CREATE OR REPLACE package DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION is

   /**
  * Documentación para el procedimiento P_GUARDAR_HORASEXTRA
  *
  * Método encargado de guardar la solicitud de horas extra
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   noEmpleado          := Numero empleado,
  *   fecha               := Fecha de solicitud,
  *   horaInicio          := Hora inicio horas extra,
  *   horaFin             := Hora fin horas extra
  *   observacion         := Observacion de solicitud
  *   estado              := Estado default 'Pendiente'
  *   empresaCod          := id Empresa
  *   usrCreacion         := Usuario registro
  *   tareaId             := Tarea id
  *   ubicacionDocumento  := Ubicacion documento
  *   nombreDocumento     := Nombre documento
  *   jornadaEmpleado     := jornada empleado
  *   esFinDeSemana       := Dia fin de semana o feriado
  *   esDiaLibre          := Dia no laboral
  *   descripcion         := descripción solicitud
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */
   PROCEDURE P_GUARDAR_HORASEXTRA(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2);



    /**
  * Documentación para el procedimiento P_ELIMINAR_SOLICITUD_HEXTRA
  *
  * Método encargado de eliminar la solicitud de hora extra.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                                         
   PROCEDURE P_ELIMINAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2);


   /**
  * Documentación para el procedimiento P_ANULAR_SOLICITUD_HEXTRA
  *
  * Método encargado de anular la solicitud de hora extra.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                                         
   PROCEDURE P_ANULAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2);



   /**
  * Documentación para el procedimiento P_AUTORIZAR_SOLICITUD_HEXTRA
  *
  * Método encargado de autorizar una solicitud de hora extra.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */  
   PROCEDURE P_AUTORIZAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2);

    /**
  * Documentación para el procedimiento P_ACTUALIZAR_SOLICITUD_HEXTRA
  *
  * Método encargado de actualizar una solicitud de hora extra.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  *   noEmpleado          := Numero empleado,
  *   fecha               := Fecha de solicitud,
  *   horaInicio          := Hora inicio horas extra,
  *   horaFin             := Hora fin horas extra
  *   observacion         := Observacion de solicitud
  *   usrCreacion         := Usuario registro
  *   tareaId             := Tarea id
  *   ubicacionDocumento  := Ubicacion documento
  *   nombreDocumento     := Nombre documento
  *   jornadaEmpleado     := jornada empleado
  *   esFinDeSemana       := Dia fin de semana o feriado
  *   esDiaLibre          := Dia no laboral
  *   descripcion         := descripción solicitud
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                                        
   PROCEDURE P_ACTUALIZAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                           Pv_Status    OUT VARCHAR2,
                                           Pv_Mensaje   OUT VARCHAR2);


   /**
   * Documentación para el procedimiento P_INSERT_SOLICITUD_HEXTRA
   *
   * Método encargado de realizar un insert en la tabla info_horas_solcitud
   *
   * @param Pn_IdHorasSolicitud    := numero de solicitud de horas extra
   * @param Pv_Fecha               := Fecha de solicitud,
   * @param Pv_HoraInicio          := Hora inicio horas extra,
   * @param Pv_HoraFin             := Hora fin horas extra
   * @param Pv_observacion         := Observacion de solicitud
   * @param Pv_Descripcion         := descripción solicitud
   * @param Pv_EmpresaCod          := id empresa
   * @param Pv_UsrCreacion         := usuario creación
   * @param Pv_Status              OUT  VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje             OUT  VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Ivan Mata <imata@telconet.ec>
   * @version 1.0 22-10-2020
   */   
   PROCEDURE P_INSERT_SOLICITUD_HEXTRA(Pn_IdHorasSolicitud   IN NUMBER,
                                      Pd_Fecha               IN DATE,
                                      Pv_HoraInicio          IN VARCHAR2,
                                      Pv_HoraFin             IN VARCHAR2,
                                      Pv_observacion         IN VARCHAR2,
                                      Pv_Descripcion         IN VARCHAR2,
                                      Pv_EmpresaCod          IN VARCHAR2,
                                      Pv_UsrCreacion         IN VARCHAR2,
                                      Pv_Status              OUT VARCHAR2,
                                      Pv_Mensaje             OUT VARCHAR2);



   /**
  * Documentación para el procedimiento P_INSERT_DETA_SOLICITUD_HEXTRA
  *
  * Método encargado de Insertar el detalle de una solicitud de horas extra.
  *
  * @param Pn_IdHorasSolicitud IN NUMBER,
  * @param Pn_TareasExtraId    IN NUMBER,
  * @param Pv_HoraInicioDet    IN VARCHAR2,
  * @param Pv_HoraFinDet       IN VARCHAR2,
  * @param Pv_Horas            IN VARCHAR2,
  * @param Pd_FechaDet         IN DATE,
  * @param Pd_FechaDet         IN DATE,
  * @param Pv_Observacion      IN VARCHAR2,
  * @param Pv_Estado           IN VARCHAR2,
  * @param Pv_usrCreacion      IN VARCHAR2,
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 24-06-2020
  */                              
   PROCEDURE P_INSERT_DETA_SOLICITUD_HEXTRA(Pn_IdHorasSolicitud IN NUMBER,
                                            Pn_TareasExtraId    IN NUMBER,
                                            Pv_HoraInicioDet    IN VARCHAR2,
                                            Pv_HoraFinDet       IN VARCHAR2,
                                            Pv_Horas            IN VARCHAR2,
                                            Pd_FechaDet         IN DATE,
                                            Pv_Observacion      IN VARCHAR2,
                                            Pv_Estado           IN VARCHAR2,
                                            Pv_usrCreacion      IN VARCHAR2,
                                            Pv_Status           OUT VARCHAR2,
                                            Pv_Mensaje          OUT VARCHAR2);

   /**
    * Documentación para el procedimiento P_INSERT_HISTORIAL_SOLICITUD
    *
    * Método encargado de Insertar el historial de una solicitud
    *
    * @param Pn_IdHorasSolicitud IN NUMBER,
    * @param Pn_TareasExtraId    IN NUMBER,
    * @param Pv_HoraInicioDet    IN VARCHAR2,
    * @param Pv_HoraFinDet       IN VARCHAR2,
    * @param Pv_Horas            IN VARCHAR2,
    * @param Pd_FechaDet         IN DATE,
    * @param Pd_FechaDet         IN DATE,
    * @param Pv_Observacion      IN VARCHAR2,
    * @param Pv_Estado           IN VARCHAR2,
    * @param Pv_usrCreacion      IN VARCHAR2,
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 24-06-2020
    */                                        
    PROCEDURE P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud IN NUMBER,
                                           Pn_TareasExtraId    IN NUMBER,
                                           Pv_HoraInicioDet    IN VARCHAR2,
                                           Pv_HoraFinDet       IN VARCHAR2,
                                           Pv_Horas            IN VARCHAR2,
                                           Pd_FechaDet         IN DATE,
                                           Pv_Observacion      IN VARCHAR2,
                                           Pv_Estado           IN VARCHAR2,
                                           Pv_usrCreacion      IN VARCHAR2,
                                           Pv_Status           OUT VARCHAR2,
                                           Pv_Mensaje          OUT VARCHAR2);


    /**
  * Documentación para el procedimiento P_INSERTAR_TAREAS
  *
  * Método encargado de Insertar las tareas que contiene una solicitud de horas extra.
  *
  * @param Pn_IdHorasSolicitud IN NUMBER,
  * @param Pn_TareaId          IN NUMBER,
  * @param Pv_usrCreacion      IN VARCHAR2,
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 24-06-2020
  */                               
    PROCEDURE P_INSERTAR_TAREAS(Pn_IdHorasSolicitud IN NUMBER,
                                Pn_TareaId          IN NUMBER,
                                Pv_usrCreacion      IN VARCHAR2,
                                Pn_IdCUadrilla      IN NUMBER,
                                Pv_observacion      IN VARCHAR2,
                                Pv_Status           OUT VARCHAR2,
                                Pv_Mensaje          OUT VARCHAR2);




    /**
    * Documentación para el procedimiento P_INSERTAR_DOCUMENTOS
    *
    * Método encargado de Insertar los Documentos que contiene una solicitud de horas extra.
    *
    * @param Pn_IdHorasSolicitud IN NUMBER,
    * @param Pv_NombreDocumento  IN VARCHAR2,
    * @param Pv_usrCreacion      IN VARCHAR2,
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 24-06-2020
    */  
    PROCEDURE P_INSERTAR_DOCUMENTOS(Pn_IdHorasSolicitud   IN NUMBER,
                                    Pv_NombreDocumento    IN VARCHAR2,
                                    Pv_UbicacionDocumento IN VARCHAR2,
                                    Pv_Estado             IN VARCHAR2,
                                    Pv_usrCreacion        IN VARCHAR2,
                                    Pv_Status             OUT VARCHAR2,
                                    Pv_Mensaje            OUT VARCHAR2);


    /**
    * Documentación para el procedimiento P_ACTUALIZACION_GENERAL_SOLI
    *
    * Método encargado de actualizar el estado de todas las solicitudes pendientes a anuladas.
    *
    * @param Pn_IdHorasSolicitud IN NUMBER,
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 24-06-2020
    */                                
    PROCEDURE P_ACTUALIZACION_GENERAL_SOLI(Pn_IdHorasSolicitud IN NUMBER,
                                           Pv_Proceso          IN VARCHAR2,
                                           Pv_Status           OUT VARCHAR2,
                                           Pv_Mensaje          OUT VARCHAR2);


    /**
    * Documentación para el procedimiento P_AUTORIZACION_MASIVA
    *
    * Método encargado de preautorizar y autorizar de manera masiva o uno por uno las solicitudes de horas extra
    *
    * @param Pn_IdHorasSolicitud IN NUMBER,
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 24-06-2020
    */                   
    PROCEDURE P_AUTORIZACION_MASIVA(Pn_IdHorasSolicitud IN NUMBER,
                                    Pv_Estado           IN VARCHAR2,
                                    Pv_NomPantalla      IN VARCHAR2,
                                    Pv_Usuario          IN VARCHAR2,
                                    Pv_EmpresaCod       IN VARCHAR2,
                                    Pv_Status           OUT VARCHAR2,
                                    Pv_Mensaje          OUT VARCHAR2);


    /**
    * Documentación para el procedimiento P_INSERTAR_EMPLEADOS
    *
    * Método encargado de insertar los empleados asociados a una solicitud unica.
    *
    * @param Pn_IdHorasSolicitud IN NUMBER.
    * @param Pn_NoEmple IN NUMBER.
    * @param Pv_Estado  IN VARCHAR2.
    * @param Pv_UsrCreacion IN VARCHAR2.
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 28-08-2020
    */                                   
    PROCEDURE P_INSERTAR_EMPLEADOS(Pn_IdHorasSolicitud IN NUMBER,
                                   Pn_NoEmple          IN NUMBER,
                                   Pv_Estado           IN VARCHAR2,
                                   Pv_UsrCreacion      IN VARCHAR2,
                                   Pv_Status           OUT VARCHAR2,
                                   Pv_Mensaje          OUT VARCHAR2);


   /**
    * Documentación para el procedimiento P_AUTORIZACION_POR_DEPTO
    *
    * Método encargado de Autorizar las solicitudes Pre-Autorizadas por departamento.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   idHorasSolicitud    := numero de solicitud de horas extra
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 09-09-2020
    */                                
    PROCEDURE P_AUTORIZACION_POR_DEPTO(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2);

    /**
    * Documentación para el procedimiento P_ENVIO_MAIL_HE
    *
    * Método encargado de enviar correo a los empleados que tengan una solicitud de horas extras autorizada.
    *
    * @param Pv_EmpresaCod  IN  VARCHAR2
    * @param Pv_Remitente   IN  VARCHAR2
    * @param Pv_Asunto      IN  VARCHAR2
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 09-09-2020
    */                                
    PROCEDURE P_ENVIO_MAIL_HE(Pv_EmpresaCod IN VARCHAR2,
                              Pv_Remitente  IN VARCHAR2,
                              Pv_Asunto     IN VARCHAR2);



    /**
    * Documentación para el procedimiento P_REPORTE_AUTORIZACIONES
    *
    * Método encargado de enviar correo a gerencia con un reporte general y detallado de las solicitudes autorizadas.
    * @param Pv_EmpresaCod  IN  VARCHAR2
    * @param Pv_Remitente   IN  VARCHAR2
    * @param Pv_Asunto      IN  VARCHAR2
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 09-09-2020
    */
    PROCEDURE P_REPORTE_AUTORIZACIONES(Pv_EmpresaCod IN VARCHAR2,
                                       Pv_Remitente  IN VARCHAR2,
                                       Pv_Asunto     IN VARCHAR2);



    /**
    * Documentación para el procedimiento P_ENVIAR_MAIL_GENERAL
    *
    * Método encargado de notificar mediante correo una vez anulada o autorizada una solicitud.
    *
    * @param Pv_Proceso          IN VARCHAR2
    * @param Pv_EmpresaCod       IN VARCHAR2
    * @param Pn_IdHorasSolicitud IN NUMBER
    * @param Pv_Observacion      IN VARCHAR2
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 06-10-2020
    */             
    PROCEDURE P_ENVIAR_MAIL_GENERAL(Pv_Proceso          IN VARCHAR2,
                                    Pv_EmpresaCod       IN VARCHAR2,
                                    Pn_IdHorasSolicitud IN NUMBER,
                                    Pv_Observacion      IN VARCHAR2);


    /**
    * Documentación para el procedimiento P_ELIMINAR_MASIVA
    *
    * Método encargado eliminar listado de solicitudes.
    *
    * @param Pn_IdHorasSolicitud  IN NUMBER
    * @param Pv_Usuario           IN VARCHAR2
    * @param Pv_EmpresaCod        IN VARCHAR2
    * @param Pv_Status            OUT VARCHAR2
    * @param Pv_Mensaje           OUT VARCHAR2
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 06-10-2020
    */ 
     PROCEDURE P_ELIMINAR_MASIVA(Pn_IdHorasSolicitud IN NUMBER,
                                Pv_Usuario          IN VARCHAR2,
                                Pv_EmpresaCod       IN VARCHAR2,
                                Pv_Status           OUT VARCHAR2,
                                Pv_Mensaje          OUT VARCHAR2);


    /**
    * Documentación para el procedimiento P_PLANIFICAR_HORARIO
    *
    * Método encargado de la planificacion.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod         := número de compañía.
    *   fechaInicio        := fecha inicio.
    *   fechaFin           := fecha fin.
    *   horaInicio         := hora inicio.
    *   horaFin            := hora fin.
    *   tipoHorario        := id tipo horario.
    *   usrCreacion        := usuario creacion.
    *   diasEscogidos      := dias escogidos.
    *   idSecuencia        := Id secuencia.
    *   planificacionAnual := Si es planificacion anual
    * ]
    * @param Pv_Status            OUT VARCHAR2
    * @param Pv_Mensaje           OUT VARCHAR2
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 
    */                            
     PROCEDURE P_PLANIFICAR_HORARIO(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2);
     /**
    * Documentación para el procedimiento P_GUARDAR_PLANIFICACION
    *
    * Método encargado de guardar la planificacion.
    *
    * @param Pv_NoEmpleado         := Numero empleado
    * @param Pv_EmpresaCod         := número de compañía.
    * @param Pv_FechaInicio        := fecha inicio.
    * @param Pv_FechaFin           := fecha fin.
    * @param Pv_HoraInicio         := hora inicio.
    * @param Pv_HoraFin            := hora fin.
    * @param Pv_TipoHorario        := id tipo horario.
    * @param Pv_UsrCreacion        := usuario creacion.
    * @param Pv_Status             := estado de la transaccion
    * @param Pv_Mensaje            := mensaje de transaccion
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 
    */                                        
     PROCEDURE P_GUARDAR_PLANIFICACION(Pv_NoEmpleado  VARCHAR2,
                                      Pv_FechaInicio DATE,
                                      Pv_FechaFin    DATE,
                                      Pv_HoraInicio  VARCHAR2,
                                      Pv_HoraFin     VARCHAR2,
                                      Pv_TipoHorario VARCHAR2,
                                      Pv_EmpresaCod  VARCHAR2,
                                      Pv_UsrCreacion VARCHAR2,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2);

   /**
    * Documentación para el procedimiento P_EDITAR_PLANIFICACION
    *
    * Método encargado de editar la planificacion.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod         := número de compañía.
    *   fechaInicio        := fecha inicio.
    *   fechaFin           := fecha fin.
    *   horaInicio         := hora inicio.
    *   horaFin            := hora fin.
    *   tipoHorario        := id tipo horario.
    *   usrCreacion        := usuario creacion.
    *   diasEscogidos      := dias escogidos.
    *   idSecuencia        := Id secuencia.
    *   planificacionAnual := Si es planificacion anual
    * ]
    * @param Pv_Status            OUT VARCHAR2
    * @param Pv_Mensaje           OUT VARCHAR2
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 
    */                                     
      PROCEDURE P_EDITAR_PLANIFICACION(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2);

   /**
    * Documentación para el procedimiento P_ELIMINAR_PLANIFICACION
    *
    * Método encargado de eliminar la planificacion.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod         := número de compañía.
    *   fechaInicio        := fecha inicio.
    *   fechaFin           := fecha fin.
    *   horaInicio         := hora inicio.
    *   horaFin            := hora fin.
    *   tipoHorario        := id tipo horario.
    *   usrCreacion        := usuario creacion.
    *   diasEscogidos      := dias escogidos.
    *   idSecuencia        := Id secuencia.
    *   planificacionAnual := Si es planificacion anual
    * ]
    * @param Pv_Status            OUT VARCHAR2
    * @param Pv_Mensaje           OUT VARCHAR2
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 
    */                                   
       PROCEDURE P_ELIMINAR_PLANIFICACION(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2);
      /**
    * Documentación para el procedimiento P_ELIMINAR_PLA_MASIVA
    *
    * Método encargado de eliminar la planificacion masivamente.
    *
    * @param Pn_IdHorarioEmple    NUMBER
    * @param Pv_UsrCreacion       VARCHAR2
    * @param Pv_Observacion       VARCHAR2
    * @param Pv_Status            OUT VARCHAR2
    * @param Pv_Mensaje           OUT VARCHAR2
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 
    */    
       PROCEDURE P_ELIMINAR_PLA_MASIVA(Pn_IdHorarioEmple NUMBER,
                                    Pv_UsrCreacion    VARCHAR2,
                                    Pv_Observacion    VARCHAR2,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2);
        /**
    * Documentación para el procedimiento P_GENERA_HE_VERIFICACION
    *
    * Método encargado de generar las solicitudes barriendo las tareas.
    *
    * @param Pv_Error           OUT VARCHAR2
    * @author Katherine Portugal <kportugal@telconet.ec>
    * @version 1.0 
    */                                 
       PROCEDURE P_GENERA_HE_VERIFICACION(Pv_Error      OUT VARCHAR2);   


        /**
    * Documentación para el procedimiento P_GENERA_HE_VERI_TAREAS_ADMI
    *
    * Método encargado de generar las solicitudes de horas extras barriendo todas las tareas.
    *
    * @param Pv_Error           OUT VARCHAR2
    * @author Katherine Portugal <kportugal@telconet.ec>
    * @version 1.0 
    */                                                                                             
      PROCEDURE P_GENERA_HE_VERI_TAREAS_ADMI ;


    /**
    * Documentación para el procedimiento P_GEN_HE_AUTO_TAREAS_TECNICA
    *
    * Método encargado de generar las solicitudes de horas extras en estado autorizado barriendo todas las tareas para los departamentos tecnico.
    *
    * @param Pv_Error           OUT VARCHAR2
    * @author Katherine Portugal <kportugal@telconet.ec>
    * @version 1.0 
    */              
    PROCEDURE P_GEN_HE_AUTO_TAREAS_TECNICA;                            


END HEKG_HORASEXTRAS_TRANSACCION;
/


CREATE OR REPLACE package body                                                DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION is
  
  PROCEDURE P_GUARDAR_HORASEXTRA(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2) AS
    
     Lv_HoraInicioSimples           VARCHAR2(7);
     Lv_HoraFinSimples              VARCHAR2(7);
     Lv_HoraInicioDobles            VARCHAR2(7);
     Lv_HoraFinDobles               VARCHAR2(7);
     Lv_HorasInicioNocturnas        VARCHAR2(7);
     Lv_HorasFinNocturnas           VARCHAR2(7);
     Lv_NumHorasNocturnas           VARCHAR2(7);  
     Lv_HoraFinDia                  VARCHAR2(7);     

     Ld_HoraInicio1                 DATE;
     Ld_HoraFin1                    DATE;
     Ld_HoraFin2                    DATE;
     Ld_HoraInicioSimples1          DATE;
     Ld_HoraFinSimples1             DATE;
     Ld_HoraInicioDobles1           DATE;
     Ld_HoraFinDobles1              DATE;
     Ld_HorasInicioNocturnas1       DATE;
     Ld_HorasInicioNocturnas2       DATE;
     Ld_HorasFinNocturnas1          DATE;
     Ld_HorasFinNocturnas2          DATE;
     Ld_HoraFinGeneral              DATE;
     Ld_HoraInicioDia1              DATE;
     Ld_HoraFinDia1                 DATE;
     Ld_HoraInicioEncontrada        DATE;
     Ld_HoraFinEncontrada           DATE;
     Ld_FechaIngresada              DATE;
     Ld_FeInicioTarea1              DATE;
     Ld_FeFinTarea1                 DATE;
     Ld_FechaSolicitud              DATE;
     Ld_FechaSolicitud2             DATE;
     Ld_FechaCorte                  DATE;	
     Ld_FechaActual                 DATE;
     Ld_LineaBaseFechaInicio        DATE;
     Ld_LineaBaseFechaFin           DATE;

     Lv_TotalHorasSimples           NUMBER;
     Lv_TotalMinutosSimples         NUMBER;
     Lv_TotalHorasDobles            NUMBER;
     Ln_TotalHorasDobles_1          NUMBER;
     Lv_TotalMinutosDobles          NUMBER;
     Ln_TotalMinutosDobles_1        NUMBER;
     Lv_TotalHorasNocturno          NUMBER;
     Ln_TotalHorasNocturno_1        NUMBER;
     Lv_TotalMinutosNocturno        NUMBER;
     Ln_TotalMinutosNocturno_1      NUMBER;

     Lv_TotalHoraMinutoSimple       VARCHAR2(55);
     Lv_TotalHoraMinutoDoble        VARCHAR2(55);
     Lv_TotalHoraMinutoDoble_1      VARCHAR2(55);
     Lv_TotalHoraMinutoNocturno     VARCHAR2(55);
     Lv_TotalHoraMinutoNocturno_1   VARCHAR2(55);
     Ln_Contador                    NUMBER:=0;
     Ln_Contador1                   NUMBER:=0;
     Ln_Contador2                   NUMBER:=0;
     Ln_ContadorEmpleado            NUMBER:=0;
     Ln_ContadorFecha               NUMBER:=0;
     Ln_ContadoreEmp                NUMBER:=1;
     Ln_ContadorFecha_1             NUMBER:=1;
     Ln_Contador3                   NUMBER:=0;
     Ln_Contador4                   NUMBER:=0;
     Ln_ContadorCuadrilla           NUMBER:=0;
     Ln_ContadorCua                 NUMBER:=1;
     Ln_ContadorDocumentos          NUMBER:=0;
     Ln_ContadorDocu                NUMBER:=1;
     Ln_ContadorTarea               NUMBER:=0;
     Ln_ContadorTar                 NUMBER:=1;
     Ln_total_horas                 NUMBER:=0;
     totalresgistros                NUMBER:=0;----variable puesta momentaneamente 
     Ln_sumaDia                     NUMBER:=0;
     Ln_contadorFeriado             NUMBER := 1;

     Ld_Fecha                       VARCHAR2(25);
     Ld_FechaTemp                   VARCHAR2(25):=NULL; ----fecha que guarda temporalmente la fecha anterior
     Ld_FechaFormato                VARCHAR2(25);--- se anadio variable para poner formato estandar de la fache que se recibe del json
     Ld_FechaHasta                  VARCHAR2(25);
     Lv_HoraInicio                  VARCHAR2(7);
     Lv_HoraFin                     VARCHAR2(7);
     Lv_observacion                 VARCHAR2(200);
     Lv_Descripcion                 VARCHAR2(20);
     Lv_Estado                      VARCHAR2(15);
     Lv_EmpresaCod                  VARCHAR2(2);
     Lv_UsrCreacion                 VARCHAR2(15);
     Lv_IpCreacion                  VARCHAR2(15);
     Lv_Canton                      VARCHAR2(30):= NULL; 
     Lv_Provincia                   VARCHAR2(30):= NULL;

     Lv_TipoHorasExtraId            NUMBER;
     Lv_Horas                       VARCHAR2(7);
     Lv_JornadaEmpleado             VARCHAR2(2); 
     Lv_EsFinDeSemana               VARCHAR2(2);
     Lv_EsDiaLibre                  VARCHAR2(2);
     Lv_nombreArea                  VARCHAR2(35);
     Lv_bandera                     VARCHAR2(6):='false';
     Lv_bandera2                    VARCHAR2(6):='false';
     Lv_bandera3                    VARCHAR2(6):='false'; 
     Lv_EntraLineaBase              VARCHAR2(6):='false'; 
     Lv_Mensaje                     VARCHAR2(30);
     Lv_nombreDepartamento          VARCHAR2(35);
     Lv_EsSuperUsuario              VARCHAR2(20);
     Lv_Mes_Solicitud               VARCHAR2(25);
     Lv_IndiceEmpleado              NUMBER;
     Lr_esFeriado                   NUMBER:=0;
     Lv_EsFeriado1                  NUMBER:=0;
     Lr_esFecha                     NUMBER:=0;--VARIABLE PARA CONTROLAR EL FORMATO FECHA QUE ESTA MANDANDO LA FECHA POR ERROR 

     TYPE C_ListTotalHoras          IS VARRAY(8) OF VARCHAR2(40);
     C_ListaHoras                   C_ListTotalHoras :=C_ListTotalHoras();
     TYPE C_ListTipoHorasExtra      IS VARRAY(8) OF VARCHAR2(40);
     C_TipoHorasExtra               C_ListTipoHorasExtra :=C_ListTipoHorasExtra();
     TYPE C_HoraInicio_Det          IS VARRAY(8) OF VARCHAR2(40);
     C_HoraInicioDet                C_HoraInicio_Det := C_HoraInicio_Det();
     TYPE C_HoraFin_Det             IS VARRAY(8) OF VARCHAR2(40);
     C_HoraFinDet                   C_HoraFin_Det := C_HoraFin_Det();
     TYPE C_Fecha_Det               IS VARRAY(8) OF DATE;
     C_FechaDet                     C_Fecha_Det := C_Fecha_Det();
     


      CURSOR C_TIPO_HORAS_EXTRA(Cv_TipoHorasExtra1 VARCHAR2,
                                Cv_TipoHorasExtra2 VARCHAR2, 
                                Cv_TipoHorasExtra3 VARCHAR2) IS 
       SELECT ID_TIPO_HORAS_EXTRA,TIPO_HORAS_EXTRA
       FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA IN(Cv_TipoHorasExtra1,Cv_TipoHorasExtra2,Cv_TipoHorasExtra3)
       ORDER BY ID_TIPO_HORAS_EXTRA ASC;

     CURSOR C_EXISTE_EMPLEADO(Cv_No_Emple VARCHAR2, Cv_Fecha DATE,Cv_Fecha2 DATE, Cv_Empresa VARCHAR2) IS
       SELECT DISTINCT IHS.ID_HORAS_SOLICITUD,VEE.NOMBRE,TO_CHAR(TO_DATE(TO_CHAR(IHSD.FECHA_SOLICITUD_DET,'DD-MM-YY')||' '||IHSD.HORA_INICIO_DET,'DD-MM-YY HH24:MI'),'DD-MM-YYYY HH24:MI')FECHA_INICIO,
       TO_CHAR(TO_DATE(TO_CHAR(IHSD.FECHA_SOLICITUD_DET,'DD-MM-YY')||' '||IHSD.HORA_FIN_DET,'DD-MM-YY HH24:MI'),'DD-MM-YYYY HH24:MI')FECHA_FIN  
       FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
        JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHS.ID_HORAS_SOLICITUD= IHSE.HORAS_SOLICITUD_ID
        JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
        JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
       WHERE IHSD.FECHA_SOLICITUD_DET IN(Cv_Fecha,Cv_Fecha2) AND IHSE.NO_EMPLE=Cv_No_Emple AND IHS.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada','Verificacion') AND VEE.NO_CIA=Cv_Empresa
       AND IHSE.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada','Verificacion') 
       AND IHSD.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada','Verificacion')
       AND IHS.EMPRESA_COD=Cv_Empresa
       ORDER BY IHS.ID_HORAS_SOLICITUD ASC;

      CURSOR C_VALIDAR_INFORMACION(Cv_No_Emple VARCHAR2,Cv_Empresa VARCHAR2, Cv_Fecha_Inicio VARCHAR2, Cv_Fecha_Fin VARCHAR2, Cd_FechaSolicitud DATE,Cd_FechaSolicitud2 DATE,
        Cd_FechaInicioEncontrada VARCHAR2,Cd_FechaFinEncontrada VARCHAR2) IS
        SELECT  COUNT(*) CANTIDAD
         FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS
         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHS.ID_HORAS_SOLICITUD = IHSE.HORAS_SOLICITUD_ID
         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
         JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.no_emple = IHSE.no_emple
        WHERE IHSD.FECHA_SOLICITUD_DET IN(Cd_FechaSolicitud,Cd_FechaSolicitud2) AND IHSE.NO_EMPLE = Cv_No_Emple       
           -- CONDICIONAL 1
         AND
          (
           (to_timestamp(Cv_Fecha_Inicio,'DD-MM-YYYY HH24:MI') >= to_timestamp(Cd_FechaInicioEncontrada,'DD-MM-YYYY HH24:MI')
           AND to_timestamp(Cv_Fecha_Inicio,'DD-MM-YYYY HH24:MI') < to_timestamp(Cd_FechaFinEncontrada,'DD-MM-YYYY HH24:MI') 
           AND to_timestamp(Cv_Fecha_Fin,'DD-MM-YYYY HH24:MI') > to_timestamp(Cd_FechaInicioEncontrada,'DD-MM-YYYY HH24:MI')
           AND to_timestamp(Cv_Fecha_Fin,'DD-MM-YYYY HH24:MI') <= to_timestamp(Cd_FechaFinEncontrada,'DD-MM-YYYY HH24:MI'))
         OR
           -- CONDICIONAL 2
           (to_timestamp(Cv_Fecha_Inicio,'DD-MM-YYYY HH24:MI') >= to_timestamp(Cd_FechaInicioEncontrada,'DD-MM-YYYY HH24:MI')
           AND to_timestamp(Cv_Fecha_Inicio,'DD-MM-YYYY HH24:MI') < to_timestamp(Cd_FechaFinEncontrada,'DD-MM-YYYY HH24:MI')   
           AND to_timestamp(Cv_Fecha_Fin,'DD-MM-YYYY HH24:MI') > to_timestamp(Cd_FechaFinEncontrada,'DD-MM-YYYY HH24:MI'))
         OR
           -- CONDICIONAL 3
           (to_timestamp(Cv_Fecha_Inicio,'DD-MM-YYYY HH24:MI') < to_timestamp(Cd_FechaInicioEncontrada,'DD-MM-YYYY HH24:MI')
           AND to_timestamp(Cv_Fecha_Fin,'DD-MM-YYYY HH24:MI') > to_timestamp(Cd_FechaInicioEncontrada,'DD-MM-YYYY HH24:MI')   
           AND to_timestamp(Cv_Fecha_Fin,'DD-MM-YYYY HH24:MI') <= to_timestamp(Cd_FechaFinEncontrada,'DD-MM-YYYY HH24:MI'))
         OR
           -- CONDICIONAL 4
           (to_timestamp(Cv_Fecha_Inicio,'DD-MM-YYYY HH24:MI') <= to_timestamp(Cd_FechaInicioEncontrada,'DD-MM-YYYY HH24:MI')
           AND to_timestamp(Cv_Fecha_Fin,'DD-MM-YYYY HH24:MI') >= to_timestamp(Cd_FechaFinEncontrada,'DD-MM-YYYY HH24:MI'))
          )
         AND IHS.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada','Verificacion')
         AND VEE.NO_CIA = Cv_Empresa
         AND IHSE.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada','Verificacion')
         AND IHSD.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada','Verificacion')
         AND IHS.EMPRESA_COD = Cv_Empresa

        ORDER BY IHS.ID_HORAS_SOLICITUD ASC;


        CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
          SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD	
            WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
          WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_REGISTRO'
          AND APD.ESTADO='Activo';


       CURSOR C_EXISTE_AREA(Cv_Area VARCHAR2) IS
         SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='LISTADO_AREAS_HE')
         AND VALOR1=Cv_Area AND APD.ESTADO='Activo';

       CURSOR C_EXISTE_DEPARTAMENTO(Cv_Departamento VARCHAR2)IS
         SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='DEPARTAMENTO_TAREA_HE')
         AND VALOR1=Cv_Departamento AND APD.ESTADO='Activo';

       CURSOR C_EXISTE_CARGO_DEPARTAMENTO(Cv_Departamento VARCHAR2, Cv_CargoEmpleado VARCHAR2)IS
         SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='ROLES_TAREA_HE')
         AND VALOR1=Cv_Departamento AND VALOR2=Cv_CargoEmpleado AND APD.ESTADO='Activo';
      
      --DEPARTAMENTOS CONFIGURADOS   
      CURSOR C_DEPARTAMENTOS_CONFIGURADOS IS
          SELECT PARDET.VALOR1 AS NOMBRE_DEPTO,PARDET.VALOR2
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo';


      CURSOR C_CARGO_EMPLEADO(Cv_NoEmple VARCHAR2, Cv_NoCia VARCHAR2)IS
         SELECT DESCRIPCION_CARGO,NOMBRE,OFICINA_PROVINCIA,OFICINA_CANTON FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS WHERE NO_CIA=Cv_NoCia AND NO_EMPLE=Cv_NoEmple;


     CURSOR C_OBTENER_LINEA_BASE(Cv_EmpresaCod VARCHAR2,
                                    Cv_Estado     VARCHAR2,
                                    Cv_NoEMple    VARCHAR2,
                                    Cv_FechaDesde VARCHAR2,
                                    Cv_FechaHasta VARCHAR2) IS
          SELECT AHE.NO_EMPLE,
                 TO_CHAR(AHE.FECHA_INICIO,'DD-MM-YYYY') FECHA_INICIO,
                 TO_CHAR(AHE.FECHA_FIN,'DD-MM-YYYY') FECHA_FIN,
                 AHE.HORA_INICIO,
                 AHE.HORA_FIN
            FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
            JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
              ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
             AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
           WHERE AHE.EMPRESA_COD = Cv_EmpresaCod
             AND AHE.ESTADO = Cv_Estado
             AND AHE.NO_EMPLE = Cv_NoEMple
             AND ((AHE.FECHA_INICIO >=
                 TO_DATE(Cv_FechaDesde, 'DD-MM-YYYY') AND
                 AHE.FECHA_INICIO <=
                 TO_DATE(Cv_FechaHasta, 'DD-MM-YYYY')) OR
                 (AHE.FECHA_FIN >=
                 TO_DATE(Cv_FechaDesde, 'DD-MM-YYYY') AND
                 AHE.FECHA_FIN <=
                 TO_DATE(Cv_FechaHasta, 'DD-MM-YYYY')));
             
        --OBTINE LA LINEA BASE MENSUAL DEL EMPLEADO 
        CURSOR C_OBTENER_LINEA_BASE_MES(Cv_EmpresaCod VARCHAR2,
                                    Cv_Estado     VARCHAR2,
                                    Cv_NoEMple    VARCHAR2,
                                    Cv_FechaDesde VARCHAR2,
                                    Cv_FechaHasta VARCHAR2) IS
                 SELECT AHE.NO_EMPLE,
                 TO_CHAR(AHE.FECHA_INICIO,'DD-MM-YYYY') FECHA_INICIO,
                 TO_CHAR(AHE.FECHA_FIN,'DD-MM-YYYY') FECHA_FIN,
                 AHE.HORA_INICIO,
                 AHE.HORA_FIN
            FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
            JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
              ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
             AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
           WHERE AHE.EMPRESA_COD = Cv_EmpresaCod
             AND AHE.ESTADO = Cv_Estado
             AND AHE.NO_EMPLE = Cv_NoEMple
             AND (TO_CHAR(AHE.FECHA_INICIO,'MM') = Cv_FechaDesde 
             AND TO_CHAR(AHE.FECHA_INICIO,'YYYY') = Cv_FechaHasta);
             
      CURSOR C_FERIADO_LOCAL (fecha VARCHAR2, nombreProvincia VARCHAR2)IS 
     SELECT p.DESCRIPCION PROVINCIA, c.DESCRIPCION CANTON
          --INTO Lv_Provincia, Lv_Canton
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          INNER JOIN NAF47_TNET.argepro p
          ON p.PROVINCIA = APD.VALOR6
          AND p.pais = '313'
          LEFT JOIN NAF47_TNET.argecan c
          ON p.PROVINCIA = c.PROVINCIA
          AND c.CANTON = APD.VALOR7
          AND C.pais = '313'
        WHERE APD.DESCRIPCION = 'MES_DIAS_FERIADO' 
          AND APD.VALOR3 = TO_CHAR(TO_DATE(fecha, 'DD-MM-YYYY'),'YYYY')
          AND TO_CHAR(TO_DATE(APD.VALOR2||'-'||APD.VALOR1||'-'||APD.VALOR3,'DD-MM-YYYY'), 'DD-MM-YYYY')= TO_CHAR(TO_DATE(fecha,'DD-MM-YYYY'), 'DD-MM-YYYY')
          AND APD.ESTADO = 'Activo'
          AND p.DESCRIPCION = nombreProvincia;
             

     Ln_NoEmpleado                  apex_t_varchar2;
     Lv_TareaId                     apex_t_varchar2;
     Lv_NombreDocumento             apex_t_varchar2;
     Lv_UbicacionDocumento          apex_t_varchar2;
     Ln_IdCuadrilla                 apex_t_varchar2;
     Lv_feInicioTarea               apex_t_varchar2;
     Lv_feFinTarea                  apex_t_varchar2;
     Ln_IdHorasSolicitud            DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD.ID_HORAS_SOLICITUD%TYPE;
     Ln_IdHorasSolicitud2           DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD.ID_HORAS_SOLICITUD%TYPE;
     Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
     Ln_IdHorasSolicitudDetalle     DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE.ID_HORAS_SOLICITUD_DETALLE%TYPE;
     Lr_ExisteEmpleado              C_EXISTE_EMPLEADO%ROWTYPE;
     Lr_Cantidad                    C_VALIDAR_INFORMACION%ROWTYPE;
     Lr_Valor1                      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
     Lr_Valor_1                     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
     Lr_Departamento                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
     Lr_CargoEmpleado               C_CARGO_EMPLEADO%ROWTYPE;
     Lr_CargoDepartamento           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
     Lr_idTipoHoraExtra             C_TIPO_HORAS_EXTRA%ROWTYPE;
     Le_Errors                      EXCEPTION;
     Lr_DepartamentosConfigurados   C_DEPARTAMENTOS_CONFIGURADOS%ROWTYPE;
     TYPE lv_linea_base IS TABLE OF C_OBTENER_LINEA_BASE_MES%ROWTYPE;
     T_LineaBase lv_linea_base;
     TYPE lv_feriado_local1 IS TABLE OF C_FERIADO_LOCAL%ROWTYPE;
     T_feriado_local1 lv_feriado_local1;

     


  BEGIN

     -- RETORNO LAS VARIABLES DEL REQUEST

    APEX_JSON.PARSE(Pcl_Request);
    Ln_NoEmpleado          := APEX_JSON.find_paths_like(p_return_path => 'noEmpleado[%]' );
    Ld_Fecha               := APEX_JSON.get_varchar2(p_path => 'fecha');
    Lv_HoraInicio          := APEX_JSON.get_varchar2(p_path => 'horaInicio');
    Lv_HoraFin             := APEX_JSON.get_varchar2(p_path => 'horaFin');
    Lv_observacion         := APEX_JSON.get_varchar2(p_path => 'observacion');
    Lv_Estado              := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrCreacion         := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_TareaId             := APEX_JSON.find_paths_like(p_return_path => 'tareaId[%]' );
    Lv_NombreDocumento     := APEX_JSON.find_paths_like(p_return_path => 'nombreDocumento[%]' );
    Lv_UbicacionDocumento  := APEX_JSON.find_paths_like(p_return_path => 'ubicacionDocumento[%]' );
    Lv_JornadaEmpleado     := APEX_JSON.get_varchar2(p_path => 'jornadaEmpleado');
    Lv_EsFinDeSemana       := APEX_JSON.get_varchar2(p_path => 'esFinDeSemana');
    Lv_EsDiaLibre          := APEX_JSON.get_varchar2(p_path => 'esDiaLibre');
    Lv_Descripcion         := APEX_JSON.get_varchar2(p_path => 'descripcion');
    Ln_IdCuadrilla         := APEX_JSON.find_paths_like(p_return_path => 'idCuadrilla[%]' );
    Lv_nombreArea          := APEX_JSON.get_varchar2(p_path => 'nombreArea');
    Lv_feInicioTarea       := APEX_JSON.find_paths_like(p_return_path => 'feInicioTarea[%]' );
    Lv_feFinTarea          := APEX_JSON.find_paths_like(p_return_path => 'feFinTarea[%]' );
    Lv_nombreDepartamento  := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');
    Lv_EsSuperUsuario      := APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');
      

    IF Ld_Fecha IS NULL THEN
      Pv_Mensaje := 'El parámetro fecha está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_HoraInicio IS NULL THEN
      Pv_Mensaje := 'El parámetro horaInicio está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_HoraFin IS NULL THEN
      Pv_Mensaje := 'El parámetro horaFin está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_Estado IS NULL THEN
      Pv_Mensaje := 'El parámetro estado está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_EmpresaCod IS NULL THEN
      Pv_Mensaje := 'El parámetro empresaCod está vacío';
      RAISE Le_Errors;
    END IF;


    IF Lv_UsrCreacion IS NULL THEN
      Pv_Mensaje := 'El parámetro usrCreacion está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_JornadaEmpleado IS NULL THEN
      Pv_Mensaje := 'El parámetro jornadaEmpleado está vacío';
      RAISE Le_Errors;
    END IF;


    IF C_DIA_CORTE%ISOPEN THEN
        CLOSE C_DIA_CORTE;
    END IF;

    OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
    FETCH C_DIA_CORTE INTO Lr_valor_1;
      IF C_DIA_CORTE%FOUND THEN  
           SELECT TO_DATE(Lr_valor_1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
             INTO Ld_FechaCorte
           FROM DUAL;          
      END IF;

    CLOSE C_DIA_CORTE;
    
    ---VALIDACION PARA CONTROLAR EL FORMATO FECHA QUE VIENE DEL JSON----
        SELECT REPLACE(Ld_Fecha, '/', '-')AS FECHA  
          INTO Ld_FechaFormato
        FROM DUAL;
        
        SELECT 
         CASE 
           WHEN substr(Ld_FechaFormato, 1,  instr(Ld_FechaFormato, '-', 1, 1)-1) is null then 1
           WHEN substr(Ld_FechaFormato, instr(Ld_FechaFormato, '-', 1, 1)+1, instr(Ld_FechaFormato, '-', 1, 2) - instr(Ld_FechaFormato, '-', 1, 1) -1) is null OR
                TO_NUMBER(substr(Ld_FechaFormato, instr(Ld_FechaFormato, '-', 1, 1)+1, instr(Ld_FechaFormato, '-', 1, 2) - instr(Ld_FechaFormato, '-', 1, 1) -1)) > 12 then 1
           WHEN substr(Ld_FechaFormato, instr(Ld_FechaFormato, '-', 1, 2)+1, LENGTH(Ld_FechaFormato) -1) is null OR
                LENGTH(substr(Ld_FechaFormato, instr(Ld_FechaFormato, '-', 1, 2)+1, LENGTH(Ld_FechaFormato) -1)) <> 4 then 1
           ELSE 0
          END ESFECHA
           INTO Lr_esFecha
        FROM dual;
    
        IF Lr_esFecha = 1 THEN
          Pv_Mensaje := 'El formato de la fecha contiene un error';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                     'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                     Pv_Mensaje||' '|| Pcl_Request,
                                                     NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
          RAISE Le_Errors;
        END IF;
  --END FIN DE VALIDACION DE FORMATO FECHA------  

      --Consulta de parametros de horarios de horas extras

      SELECT HORA_FIN
       INTO Lv_HoraFinDia
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'HORA_FIN_DIA';

      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HoraInicioSimples,Lv_HoraFinSimples
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'SIMPLE';

      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HoraInicioDobles,Lv_HoraFinDobles
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'DOBLES';

      SELECT HORA_INICIO,HORA_FIN,TOTAL_HORAS_DIA
       INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas,Lv_NumHorasNocturnas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';

       SELECT CANTIDAD
       INTO Lr_esFeriado
      FROM (SELECT COUNT(*)AS CANTIDAD FROM DB_GENERAL.ADMI_PARAMETRO_DET 
       WHERE DESCRIPCION = 'MES_DIAS_FERIADO' 
          AND VALOR3 = TO_CHAR(TO_DATE(Ld_Fecha, 'DD-MM-YYYY'),'YYYY')
          AND TO_CHAR(TO_DATE(VALOR2||'-'||VALOR1||'-'||VALOR3,'DD-MM-YYYY'), 'DD-MM-YYYY')= TO_CHAR(TO_DATE(Ld_Fecha,'DD-MM-YYYY'), 'DD-MM-YYYY')
          AND ESTADO = 'Activo'
          AND VALOR5 IS NULL);
        
      --HORA INICIO Y FIN INGRESADOS
      Ld_HoraInicio1 :=  to_timestamp((Ld_Fecha||' '||Lv_HoraInicio),'DD-MM-YYYY HH24:MI');   
      Ld_HoraFin1 :=  to_timestamp((Ld_Fecha||' '||Lv_HoraFin),'DD-MM-YYYY HH24:MI'); 

      -- HORAS SIMPLES
      Ld_HoraInicioSimples1 := to_timestamp((Ld_Fecha||' '||Lv_HoraInicioSimples),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinSimples1:= to_timestamp((Ld_Fecha||' '||Lv_HoraFinSimples),'DD-MM-YYYY HH24:MI');

      -- HORAS DOBLES
      Ld_HoraInicioDobles1 := to_timestamp((Ld_Fecha||' '||Lv_HoraInicioDobles),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinDobles1 :=  to_timestamp((Ld_Fecha||' '||Lv_HoraFinDobles),'DD-MM-YYYY HH24:MI');

      -- HORAS NOCTURNAS
      Ld_HorasInicioNocturnas1 := to_timestamp((Ld_Fecha||' '||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
      Ld_HorasFinNocturnas1 :=  to_timestamp((Ld_Fecha||' '||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');

      -- HORA FIN DIA
      Ld_HoraFinDia1 := to_timestamp((Ld_Fecha||' '||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
      --  HORA INICIO DIA 
      Ld_HoraInicioDia1 := to_timestamp((Ld_Fecha||' '||'00:00'),'DD-MM-YYYY HH24:MI');

      Ld_FechaSolicitud:= TO_DATE(Ld_Fecha,'DD-MM-YYYY');
      Ld_FechaActual:= SYSDATE;
      Lv_Mes_Solicitud:= TO_CHAR(Ld_FechaSolicitud,'MM');
      
      Ld_HoraFin2 := Ld_HoraFin1;
      
      IF Ld_HoraFin1 < Ld_HoraInicio1 AND Ld_HoraFin1 >= (Ld_HoraFinDia1+1/1440)-1 THEN
            Ld_HoraFin2 := Ld_HoraFin1+1;
      END IF;  
      
      CASE Lv_Mes_Solicitud
        WHEN  '01' THEN
           Lv_Mes_Solicitud :='Enero';
        WHEN  '02' THEN
           Lv_Mes_Solicitud :='Febrero';
        WHEN  '03' THEN
           Lv_Mes_Solicitud :='Marzo';
        WHEN  '04' THEN
           Lv_Mes_Solicitud :='Abril';
        WHEN  '05' THEN
           Lv_Mes_Solicitud :='Mayo';
        WHEN  '06' THEN
           Lv_Mes_Solicitud :='Junio';
        WHEN  '07' THEN
           Lv_Mes_Solicitud :='Julio';
        WHEN  '08' THEN
           Lv_Mes_Solicitud :='Agosto';
        WHEN  '09' THEN
           Lv_Mes_Solicitud :='Septiembre';
        WHEN  '10' THEN
           Lv_Mes_Solicitud :='Octubre';
        WHEN  '11' THEN
           Lv_Mes_Solicitud :='Noviembre';
        WHEN  '12' THEN
           Lv_Mes_Solicitud :='Diciembre';
      END CASE;


      ---- VALIDAR QUE SOLO SE PUEDAN REGISTRAR SOLICITUD PARA EL MES ACTUAL Y/O  MES VENCIDO
      IF( (TO_CHAR(Ld_FechaSolicitud,'MM') !=  TO_CHAR(Ld_FechaActual,'MM')) AND (TO_CHAR(Ld_FechaSolicitud,'MM') != TO_CHAR(ADD_MONTHS(Ld_FechaActual,-1),'MM')) ) THEN
             Pv_Mensaje := 'ERROR 01: No se puede ingresar solicitud para el mes de'||' '||Lv_Mes_Solicitud||' ,'||' mes inválido';
             RAISE Le_Errors;
      END IF;

      IF((TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY')) AND(TO_CHAR(Ld_FechaSolicitud,'MM') != TO_CHAR(Ld_FechaActual,'MM')) )THEN
            Pv_Mensaje := 'ERROR 02: No se puede ingresar solicitud para el mes de'||' '||Lv_Mes_Solicitud||' el plazo máximo de ingreso es hasta el'||' '||TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY');
            RAISE Le_Errors;
      END IF;
      ----//END VALIDAR REGISTRO SOLICITUD.
      
      ----VALIDAR AREAS QUE PUEDAN REGISTRAR SOLICITUD
      IF C_EXISTE_AREA%ISOPEN THEN
            CLOSE C_EXISTE_AREA;
      END IF;

      OPEN C_EXISTE_AREA(Lv_nombreArea);
      FETCH C_EXISTE_AREA INTO Lr_valor1;

      IF C_EXISTE_AREA%NOTFOUND THEN  
          Pv_Mensaje := 'ERROR 03: No se puede registrar solicitud para el area'||' '||Lv_nombreArea;
          RAISE Le_Errors;
      END IF;

      CLOSE C_EXISTE_AREA;
      ----//END VALIDAR AREAS.

      --VALIDAR SI EL DEPARTAMENTO DEBE INGRESAR TAREA EN LA SOLICITUD

         IF C_EXISTE_DEPARTAMENTO%ISOPEN THEN
              CLOSE C_EXISTE_DEPARTAMENTO;
         END IF;       

         OPEN C_EXISTE_DEPARTAMENTO(Lv_nombreDepartamento);
         FETCH C_EXISTE_DEPARTAMENTO INTO Lr_Departamento;
              
         IF(C_EXISTE_DEPARTAMENTO%FOUND)THEN  

                     Ln_ContadorEmpleado:=Ln_NoEmpleado.COUNT;
                     WHILE Ln_ContadoreEmp<= Ln_ContadorEmpleado LOOP

                        IF C_CARGO_EMPLEADO%ISOPEN THEN CLOSE C_CARGO_EMPLEADO; END IF;
                        OPEN C_CARGO_EMPLEADO(apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),Lv_EmpresaCod);
                        FETCH C_CARGO_EMPLEADO INTO Lr_CargoEmpleado;


                        IF(C_CARGO_EMPLEADO%FOUND)THEN 

                           IF C_EXISTE_CARGO_DEPARTAMENTO%ISOPEN THEN CLOSE C_EXISTE_CARGO_DEPARTAMENTO; END IF;
                           OPEN C_EXISTE_CARGO_DEPARTAMENTO(Lv_nombreDepartamento,Lr_CargoEmpleado.DESCRIPCION_CARGO);
                           FETCH C_EXISTE_CARGO_DEPARTAMENTO INTO Lr_CargoDepartamento;


                           IF(C_EXISTE_CARGO_DEPARTAMENTO%NOTFOUND AND Lv_feInicioTarea.COUNT = 0)THEN

                             Pv_Mensaje := 'Error 04: Se debe agregar una tarea para la solicitud de horas extras del empleado '||Lr_CargoEmpleado.NOMBRE||', 
                                            cargo: '||Lr_CargoEmpleado.DESCRIPCION_CARGO||' ';
                             RAISE Le_Errors;

                           END IF;


                           CLOSE C_EXISTE_CARGO_DEPARTAMENTO;

                        END IF;


                        CLOSE C_CARGO_EMPLEADO;

                        Ln_ContadoreEmp :=Ln_ContadoreEmp+1;

                     END LOOP;

                     Ln_ContadoreEmp:=1;
         END IF;

         CLOSE C_EXISTE_DEPARTAMENTO;
      ----//END VALIDAR DEPARTAMENTO.


      --CONDICIONAL PARA VALIDAR TAREA
      Ln_ContadorFecha:=Lv_feInicioTarea.COUNT;
      IF Ln_ContadorFecha > 0 THEN

          WHILE Ln_ContadorFecha_1<= Ln_ContadorFecha LOOP

            Ld_FeInicioTarea1 := to_timestamp(apex_json.get_varchar2(p_path => Lv_feInicioTarea(Ln_ContadorFecha_1)),'DD-MM-YYYY HH24:MI');
            Ld_FeFinTarea1 := to_timestamp(apex_json.get_varchar2(p_path => Lv_feFinTarea(Ln_ContadorFecha_1)),'DD-MM-YYYY HH24:MI');

            IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
                 Lv_bandera2:='true';
                 Ld_HoraFin1:=Ld_HoraFin1+1;
            END IF;

            IF (Ld_FeInicioTarea1 <= Ld_HoraInicio1 OR Ld_FeInicioTarea1 >= Ld_HoraInicio1) AND Ld_FeInicioTarea1< Ld_HoraFin1 AND Ld_FeFinTarea1>Ld_HoraInicio1 AND Ld_FeFinTarea1<=Ld_HoraFin1 THEN

                Lv_Mensaje:='Exito';

            ELSIF Ld_FeInicioTarea1 >= Ld_HoraInicio1 AND Ld_FeInicioTarea1< Ld_HoraFin1 AND Ld_FeFinTarea1>Ld_HoraInicio1 AND (Ld_FeFinTarea1<=Ld_HoraFin1 OR Ld_FeFinTarea1>=Ld_HoraFin1)  THEN

                Lv_Mensaje:='Exito';

            ELSIF (Ld_FeInicioTarea1 < Ld_HoraInicio1 AND Ld_FeInicioTarea1 < Ld_HoraFin1 AND Ld_FeFinTarea1>Ld_HoraInicio1 AND Ld_FeFinTarea1 > Ld_HoraFin1) AND
                  (Ld_HoraFin1 > Ld_FeInicioTarea1 AND Ld_HoraFin1 <= Ld_FeFinTarea1) THEN

               Lv_Mensaje:='Exito';

            ELSE 

                IF Lv_TareaId.COUNT = Ln_ContadorFecha THEN 
                    Pv_Mensaje:='Error 05: El rango de fecha hora inicio y hora fin de la tarea '||apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorFecha_1))||' no entra
                                 en el intervalo de tiempo de la fecha hora inicio y fin de la solicitud ';

                    RAISE Le_Errors;
                  
                ELSE 
                    Pv_Mensaje:='Error 05: El rango de fecha hora inicio y hora fin de una tarea no entra
                                 en el intervalo de tiempo de la fecha hora inicio y fin de la solicitud ';

                    RAISE Le_Errors;
                     
                END IF;

            END IF;

            IF(Lv_bandera2 = 'true')THEN

                Ld_HoraFin1 := Ld_HoraFin1-1;

            END IF;

            Ln_ContadorFecha_1:=Ln_ContadorFecha_1+1;
          END LOOP;
          Ln_ContadorFecha_1:=1;
      END IF;
      ----//END CONDICIONAL PARA VALIDAR TAREA.

       ---- VALIDAR QUE NO SE REGISTREN SOLICITUDES EN EL MISMO RANGO DE HORAS.

       ---- OBTENER LOS DIAS A REGISTRAR DE LA SOLICITUD

       IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
            Ld_FechaSolicitud2 := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
            Ld_FechaSolicitud2:=Ld_FechaSolicitud2+1;
       END IF;
      
      Ln_ContadorEmpleado:=Ln_NoEmpleado.COUNT;
      WHILE Ln_ContadoreEmp<= Ln_ContadorEmpleado LOOP
         IF C_EXISTE_EMPLEADO%ISOPEN THEN CLOSE C_EXISTE_EMPLEADO; END IF;

         FOR Lr_ExisteEmpleado IN C_EXISTE_EMPLEADO(apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),Ld_FechaSolicitud,Ld_FechaSolicitud2,Lv_EmpresaCod)
         LOOP
             Ld_HoraInicioEncontrada := to_timestamp(Lr_ExisteEmpleado.FECHA_INICIO,'DD-MM-YYYY HH24:MI');
             Ld_HoraFinEncontrada := to_timestamp(Lr_ExisteEmpleado.FECHA_FIN,'DD-MM-YYYY HH24:MI');


             IF Ld_HoraFinEncontrada+1 > (Ld_HoraFinDia1+1/1440) AND Ld_HoraFinEncontrada<Ld_HoraInicioEncontrada THEN
                Ld_HoraFinEncontrada := Ld_HoraFinEncontrada+1;
             END IF;

             IF Ld_HoraFinEncontrada+1 = (Ld_HoraFinDia1+1/1440)  THEN
                Ld_HoraFinEncontrada := Ld_HoraFinEncontrada+1;
             END IF;

             IF Ld_HoraFin1+1 > (Ld_HoraFinDia1+1/1440) AND Ld_HoraFin1<Ld_HoraInicio1 THEN
                Lv_bandera  :='true';
                Ld_HoraFin1 := Ld_HoraFin1+1;
             END IF;

             IF Ld_HoraFin1+1 = (Ld_HoraFinDia1+1/1440)  THEN
                Lv_bandera  :='true';
                Ld_HoraFin1 := Ld_HoraFin1+1;
             END IF;


             OPEN C_VALIDAR_INFORMACION(apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),Lv_EmpresaCod,TO_CHAR(Ld_HoraInicio1,'DD-MM-YYYY HH24:MI'),TO_CHAR(Ld_HoraFin1,'DD-MM-YYYY HH24:MI'),
             Ld_FechaSolicitud,Ld_FechaSolicitud2,TO_CHAR(Ld_HoraInicioEncontrada,'DD-MM-YYYY HH24:MI'),TO_CHAR(Ld_HoraFinEncontrada,'DD-MM-YYYY HH24:MI'));
             FETCH C_VALIDAR_INFORMACION INTO Lr_Cantidad;

             IF Lr_Cantidad.CANTIDAD >0 THEN  
                Pv_Mensaje := 'ERROR 06: El Empleado '||Lr_ExisteEmpleado.NOMBRE||' ya tiene registrada una solicitud de horas extras ingresada en el rango de fecha de '
                              ||''||TO_CHAR(Ld_HoraInicio1,'DD-MM-YYYY HH24:MI')||' y '||TO_CHAR(Ld_HoraFin1,'DD-MM-YYYY HH24:MI');
                RAISE Le_Errors;

             END IF;

             CLOSE C_VALIDAR_INFORMACION;

             IF Ld_HoraFinEncontrada > Ld_HoraFinDia1 AND Ld_HoraFinEncontrada<Ld_HoraInicioEncontrada THEN
                Ld_HoraFinEncontrada := Ld_HoraFinEncontrada-1;
             END IF;

             IF Lv_bandera = 'true' THEN
               Ld_HoraFin1 := Ld_HoraFin1-1;
             END IF;


         END LOOP;

         Ln_ContadoreEmp :=Ln_ContadoreEmp+1;

      END LOOP;
      ----//END VALIDAR QUE NO SE REGISTREN SOLICITUDES EN EL MISMO RANGO DE HORAS.

    --VERIFICACION DE LINEA BASE PARA LOS DEPARTAMENTOS CONFIGURADOS
    IF C_DEPARTAMENTOS_CONFIGURADOS%ISOPEN THEN CLOSE C_DEPARTAMENTOS_CONFIGURADOS; END IF;
    --VERIFICACION DE FERIADO
 
    FOR Lr_DepartamentosConfigurados IN C_DEPARTAMENTOS_CONFIGURADOS loop

     IF (Lv_nombreDepartamento = Lr_DepartamentosConfigurados.NOMBRE_DEPTO) THEN
          Lv_EsFinDeSemana :='N';
          Ln_ContadoreEmp := 1;   
          Ln_ContadorEmpleado := Ln_NoEmpleado.COUNT;
          WHILE Ln_ContadoreEmp <= Ln_ContadorEmpleado LOOP
          
                --Se verifica si el empleado tiene registrada una linea base 
               IF C_OBTENER_LINEA_BASE_MES%ISOPEN THEN CLOSE C_OBTENER_LINEA_BASE_MES; END IF;
              
                OPEN C_OBTENER_LINEA_BASE_MES(Lv_EmpresaCod,
                                              'Activo',
                                              apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),
                                              to_char(to_date(Ld_Fecha,'DD/MM/YYYY'),'MM'),
                                              to_char(to_date(Ld_Fecha,'DD/MM/YYYY'),'YYYY'));
                    FETCH C_OBTENER_LINEA_BASE_MES BULK COLLECT INTO T_LineaBase;
                CLOSE C_OBTENER_LINEA_BASE_MES;

              --condicion que determina si el empleado tiene linea base 
              IF(T_LineaBase.count > 0)THEN
              
                    Lv_EsDiaLibre := 'S';
                    
                    --CONSULTAR EL HORARIO DE TRABAJO DEL EMPLEADO Y DETERMINA SI ES SU DIA LIBRE
                    FOR Lr_lineaBaseEmpleado IN C_OBTENER_LINEA_BASE(Lv_EmpresaCod,
                                                                     'Activo',
                                                                     apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),
                                                                     to_char(to_date(Ld_Fecha,'DD/MM/YYYY'),'DD/MM/YYYY') ,
                                                                     to_char(to_date(nvl(Ld_FechaHasta,to_char(Ld_HoraFin2,'DD/MM/YYYY')),'DD/MM/YYYY'),'DD/MM/YYYY')) LOOP
                      
                        Ld_LineaBaseFechaInicio := TO_DATE(Lr_lineaBaseEmpleado.FECHA_INICIO||' '||Lr_lineaBaseEmpleado.HORA_INICIO,'DD-MM-YYYY HH24:MI');
                        Ld_LineaBaseFechaFin := TO_DATE(Lr_lineaBaseEmpleado.FECHA_FIN||' '||Lr_lineaBaseEmpleado.HORA_FIN,'DD-MM-YYYY HH24:MI');
                        Ld_HorasInicioNocturnas2 := to_timestamp((Lr_lineaBaseEmpleado.FECHA_INICIO||' '||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
                        Ld_HorasFinNocturnas2 :=  to_timestamp((Lr_lineaBaseEmpleado.FECHA_INICIO||' '||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');
                        
                        IF (Lr_lineaBaseEmpleado.FECHA_INICIO <> Lr_lineaBaseEmpleado.FECHA_FIN AND Lr_lineaBaseEmpleado.FECHA_FIN > Lr_lineaBaseEmpleado.FECHA_INICIO)
                           OR Ld_LineaBaseFechaFin > Ld_HorasFinNocturnas2 THEN 
                            Ld_HorasFinNocturnas2 := Ld_HorasFinNocturnas2+1;
                        END IF;
                      
                      IF ((Lr_lineaBaseEmpleado.FECHA_INICIO <>  Lr_lineaBaseEmpleado.FECHA_FIN AND (Lr_lineaBaseEmpleado.FECHA_INICIO =  Ld_Fecha OR Lr_lineaBaseEmpleado.FECHA_FIN = Ld_Fecha))
                          OR Lr_lineaBaseEmpleado.FECHA_INICIO =  Lr_lineaBaseEmpleado.FECHA_FIN)  THEN 
                                                                  
                      IF Ld_HoraInicio1 >= Ld_HoraInicioDia1 AND Ld_HoraInicio1 < Ld_HoraFin2 AND Ld_LineaBaseFechaInicio >= Ld_HoraInicioDia1 AND Ld_LineaBaseFechaInicio < Ld_HoraFinDia1 THEN  

                        IF ((Ld_LineaBaseFechaFin > Ld_HorasInicioNocturnas2 AND Ld_HoraFin2 <= Ld_LineaBaseFechaFin AND
                            Ld_HoraInicio1 >= Ld_HorasInicioNocturnas2 AND Ld_HoraFin2 <= Ld_HorasFinNocturnas2 AND  Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio) OR
                           (Ld_HoraInicio1 >= (Ld_HoraFinDia1+1/1440)-1 AND Ld_HoraFin2 <= Ld_HorasFinNocturnas2 AND Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio AND 
                            Ld_HoraFin2 <= Ld_LineaBaseFechaFin)) THEN 
  
                              Lv_JornadaEmpleado:= 'N';
                              Lv_EntraLineaBase := 'false';
                        ELSE 
                            Lv_JornadaEmpleado:= 'M';
  
                        END IF;
                      END IF;

                      IF C_CARGO_EMPLEADO%ISOPEN THEN CLOSE C_CARGO_EMPLEADO; END IF;
                        OPEN C_CARGO_EMPLEADO(apex_json.get_number(p_path => Ln_NoEmpleado(1)),Lv_EmpresaCod);
                        FETCH C_CARGO_EMPLEADO INTO Lr_CargoEmpleado;
                        
                         ----PARA INDENTIFICAR SI EL EMPLEADO TIENE FERIADO LOCAL-----
                         IF C_FERIADO_LOCAL%ISOPEN THEN CLOSE C_FERIADO_LOCAL; END IF;
                              OPEN C_FERIADO_LOCAL(TO_CHAR(Ld_HoraInicio1, 'DD-MM-YYYY'), Lr_CargoEmpleado.OFICINA_PROVINCIA);
                              FETCH C_FERIADO_LOCAL BULK COLLECT INTO T_feriado_local1;
                              totalresgistros := T_feriado_local1.count;

                                 IF (T_feriado_local1.count > 0) then
                                     WHILE Ln_contadorFeriado <= totalresgistros loop
                                        Lv_Provincia := T_feriado_local1(Ln_contadorFeriado).PROVINCIA;
                                        Lv_Canton := T_feriado_local1(Ln_contadorFeriado).CANTON;
                                         IF ( Lv_Canton is null AND Lr_CargoEmpleado.OFICINA_PROVINCIA = Lv_Provincia) THEN 
                                             Lv_EsFeriado1 := 1;
                                         ELSIF(Lr_CargoEmpleado.OFICINA_PROVINCIA = Lv_Provincia AND Lr_CargoEmpleado.OFICINA_CANTON = Lv_Canton) THEN 
                                             Lv_EsFeriado1 := 1;
                                         ELSE 
                                             Lv_EsFeriado1 := 0;
                                         END IF;
                                         Ln_contadorFeriado:= Ln_contadorFeriado+1;
                                      END loop;
                                      Ln_contadorFeriado:=1;
                                      Lv_Provincia := null;
                                      Lv_Canton := null;
                                 END IF;
                        CLOSE C_FERIADO_LOCAL;

                      IF Lr_esFeriado = 1 OR Lv_EsFeriado1 = 1 OR 
                        (Lr_lineaBaseEmpleado.FECHA_INICIO <> Lr_lineaBaseEmpleado.FECHA_FIN AND Ld_FechaTemp IS NULL AND 
                        Ld_HoraInicio1 >= Ld_LineaBaseFechaFin AND Lr_DepartamentosConfigurados.VALOR2 = '2' AND Lv_JornadaEmpleado = 'M') THEN
                          Lv_EsDiaLibre := 'S';
                      ELSE
                          Lv_EsDiaLibre := 'N';
                      END IF;

                      IF(Lv_JornadaEmpleado = 'M' AND Lv_EsDiaLibre = 'N')THEN
                        SELECT
                              CASE
                                WHEN ((Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio OR Ld_HoraInicio1 <= Ld_LineaBaseFechaInicio AND 
                                       Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                      (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 <= Ld_LineaBaseFechaFin)) THEN 'true'
                                WHEN ((Ld_HoraInicio1 < Ld_LineaBaseFechaInicio AND Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                       (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 > Ld_LineaBaseFechaFin)) THEN 'true'
                                WHEN ((Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio AND Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                       (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 > Ld_LineaBaseFechaFin)) THEN 'true'   
                                WHEN ((Ld_HoraInicio1 < Ld_LineaBaseFechaInicio AND Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                       (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 <= Ld_LineaBaseFechaFin)) THEN 'true'
                                ELSE 'false'
                              END EXISTE
                              into Lv_EntraLineaBase
                            FROM DUAL;

                      END IF;
              
                      IF(Lv_EntraLineaBase = 'true')THEN
              
                          Pv_Mensaje := 'Error 07:  No se permite realizar el registro. El intervalo hora inicio y hora fin para la fecha ' ||
                                      TO_CHAR(Ld_FechaSolicitud, 'DD-MM-YYYY') ||
                                      ' , se encuentra dentro de la linea base. ';
                          RAISE Le_Errors;
              
                       END IF;
                      Ld_FechaTemp:= Lr_lineaBaseEmpleado.FECHA_FIN;
                     END IF;
                    END LOOP;
                    Ln_sumaDia := 0;
                    ELSE 
                      Pv_Mensaje := 'Error 08:  No se permite realizar el registro. El empleado no tine linea base. ';
                      RAISE Le_Errors;
                  END IF;
                    Ln_ContadoreEmp := Ln_ContadoreEmp + 1;
              
          END LOOP;
      
      END IF;  
    END LOOP; 
--//FIN DE VALIDACION QUE OBLIGA A DEPARTAMENTOS CONFIGURADOS A TENER LINEA BASE

--SE IDENTIFICA SI ES DIA LIBRE DEL EMPLEADO 
  IF Lv_EsDiaLibre = 'N' THEN
        IF (Lv_EsFinDeSemana ='N') THEN
      --SE IDENTIFICA QUE TIPO DE JORNADA TIENE EL EMPLEADO
          IF(Lv_JornadaEmpleado = 'M')THEN
            --Se agrega validacion para aumentar un dia a la fecha fin para jornadas mixta simples y dobles 
            IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' OR 
               (Ld_HoraInicio1>= Ld_HoraInicioSimples1 AND Ld_HoraInicio1<=Ld_HoraFin1+1 AND Ld_HoraFin1<Ld_HoraInicio1 AND Ld_HoraFin1>= Ld_HoraInicioSimples1 AND Ld_HoraFin1<=Ld_HoraFinSimples1+1) THEN
               Ld_HoraFin1 := Ld_HoraFin1+1;
            END IF;
  
            --Validacion para crear solicitudes simples 
            IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
            AND (Ld_HoraFin1 > Ld_HoraInicioSimples1  AND Ld_HoraFin1 <= Ld_HoraFinSimples1+1) THEN
  
               Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
               Lv_TotalMinutosSimples := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
  
               IF(Lv_TotalMinutosSimples='29')THEN
                  Lv_TotalMinutosSimples:='30';
               END IF;
             
               Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
  
               Ln_Contador :=1;
  
               IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
               OPEN C_TIPO_HORAS_EXTRA('SIMPLE','','');
               FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
               CLOSE C_TIPO_HORAS_EXTRA;
  
               C_HoraInicioDet.extend;
               C_HoraFinDet.extend;
               C_ListaHoras.extend;
               C_TipoHorasExtra.extend;
               C_FechaDet.extend;
               C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
               C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
               C_ListaHoras(Ln_Contador):= TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
               C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
               C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
  
            END IF;
  
            --Validacion para crear solicitudes Simples y dobles (mix)
            IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
            AND(Ld_HoraFin1 > (Ld_HoraInicioDobles1+1) AND Ld_HoraFin1 <= (Ld_HoraFinDobles1+1)) THEN
  
                  Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFinSimples1+1 - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosSimples := ROUND(MOD((Ld_HoraFinSimples1+1 - Ld_HoraInicio1)*24*60,60));
                  Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24));
                  Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24*60,60));
  
                  IF(Lv_TotalMinutosSimples='29')THEN
                     Lv_TotalMinutosSimples:='30';
                  END IF;
  
                  IF(Lv_TotalMinutosDobles='29')THEN
                     Lv_TotalMinutosDobles:='30';
                  END IF;
                  
  
                  Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                  Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                  
                  Ln_Contador := 2 ;
  
                  FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','DOBLES','')
                  LOOP
  
  
                       Ln_Contador1 := Ln_Contador1+1;
  
                       C_HoraInicioDet.extend;
                       C_HoraFinDet.extend;
                       C_ListaHoras.extend;
                       C_TipoHorasExtra.extend;
                       C_FechaDet.extend;
  
                       CASE Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA
                          WHEN  'SIMPLE' THEN
                             C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                             C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                             C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                             C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                             C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                          WHEN 'DOBLES' THEN
                             C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                             C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                             C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                             C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                             C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                       END CASE;
  
  
                  END LOOP;
  
            END IF;
  
            --Validacion para crear solicitudes dobles
            IF(Ld_HoraInicio1 >= Ld_HoraInicioDobles1 AND Ld_HoraInicio1< Ld_HoraFinDobles1)
            AND(Ld_HoraFin1 > Ld_HoraInicioDobles1 AND Ld_HoraFin1 <= Ld_HoraFinDobles1)THEN
  
                Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
  
                IF(Lv_TotalMinutosDobles='29')THEN
                  Lv_TotalMinutosDobles:='30';
               END IF;
  
                Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
  
                Ln_Contador :=1;
  
                IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                OPEN C_TIPO_HORAS_EXTRA('DOBLES','','');
                FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                CLOSE C_TIPO_HORAS_EXTRA;
  
                C_HoraInicioDet.extend;
                C_HoraFinDet.extend;
                C_ListaHoras.extend;
                C_TipoHorasExtra.extend;
                C_FechaDet.extend;
  
                C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
  
                C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
            END IF;
  
  
          ELSE
              -- JORNADA NOCTURNA
  
              IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
                  Pv_Mensaje := 'Error 13: La hora inicio y hora fin ingresados para la fecha '||TO_CHAR(Ld_FechaSolicitud,'DD-MM-YYYY')||' , no entra en el rango de horas extras permitido';
                  RAISE Le_Errors;
              END IF;
    
              IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
                  Ld_HoraFin1 := Ld_HoraFin1+1;
              END IF;
  
              --Primer if funciona para el rango de horas de 19:00 a 00:00 nocturnas
              IF((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HoraFinDia1 +1)
              AND(Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HoraFinDia1 +1 ) AND Ld_HoraFin1<= (Ld_HoraFinDia1+1/1440)) OR
              ((Ld_HoraInicio1 >= Ld_HoraFinDia1-1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1)
              AND(Ld_HoraFin1 < Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)) THEN 
                  
                  Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosNocturno := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
    
                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
    
                  Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
    
                  Ln_Contador :=1;
    
                  IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                  OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                  FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                  CLOSE C_TIPO_HORAS_EXTRA;
    
                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;
                  C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                  C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                  C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                  C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                  C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
              
              --tercer if funciona para el rango de horas de 19:00 a 06:00 nocturnas separa las horas del dia anterior con las horas del siguiente dia.    
              ELSIF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < (Ld_HoraFinDia1+1/1440))
              AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1 > (Ld_HoraFinDia1+1/1440)  AND Ld_HoraFin1<= Ld_HorasFinNocturnas1+1)THEN
                        
                  Ln_total_horas :=0;
                  --Calculo de horas nocturnas de las 19:00 a 00:00
                  Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                  --Calculo de horas nocturnas de las 00:00 a 06:00
                  Ln_TotalHorasNocturno_1   := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24));
                  Ln_TotalMinutosNocturno_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24*60,60));
                  
                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
                  
                  IF(Ln_TotalMinutosNocturno_1='29')THEN
                    Ln_TotalMinutosNocturno_1:='30';
                  END IF;
                  
                  Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                  Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                  Ln_total_horas := MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24) + MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24);
                  --se valida el total de horas en jornada nocturna
                  IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                    
                    --se hace el calculo de nocturnas dobles segun corresponda
                    --Calculo de horas nocturnas de las 19:00 a 00:00
                    Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                    Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                    --Calculo de horas nocturnas de las 00:00 a 06:00
                    Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                    Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                    --Calculo de horas dobles de las 00:00 a 06:00
                    Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                    Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                    
                    IF(Lv_TotalMinutosNocturno='29')THEN
                      Lv_TotalMinutosNocturno:='30';
                    END IF;
      
                    IF(Ln_TotalMinutosNocturno_1='29')THEN
                      Ln_TotalMinutosNocturno_1:='30';
                    END IF;
      
                    IF(Lv_TotalMinutosDobles='29')THEN
                      Lv_TotalMinutosDobles:='30';
                    END IF; 
  
                    Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                    Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                    Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                    
                    Ln_Contador :=3;
                    Ln_Contador4:=2;
                    Ln_Contador1:=0;
      
                    FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','')
                    LOOP
                            
                         IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN
                             C_HoraInicioDet.extend;
                             C_HoraFinDet.extend;
                             C_ListaHoras.extend;
                             C_TipoHorasExtra.extend;
                             C_FechaDet.extend;
      
                             Ln_Contador1:=Ln_Contador1+1;
                             C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                             C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFin1),'HH24:MI');
                             C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                             C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                             C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
      
                         ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
      
                             WHILE Ln_Contador1 < Ln_Contador4 LOOP
      
                                  Ln_Contador1:=Ln_Contador1+1;
      
                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
      
                                  CASE Ln_Contador1
                                   WHEN '1' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                   WHEN '2' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24),'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                  ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                   'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                   'ERROR 20',
                                                   NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                  END CASE;
      
                             END LOOP;
      
      
                         END IF;
      
      
                    END LOOP;
    
                  ELSE 
                    --se hace el calculo solos de nocturnas
                    Ln_Contador  :=2;
                    Ln_Contador1 :=0;
                    
                    IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                    OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                    FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                    CLOSE C_TIPO_HORAS_EXTRA;
                    
                    WHILE Ln_Contador1 < Ln_Contador LOOP
              
                        Ln_Contador1:=Ln_Contador1+1;
              
                        C_HoraInicioDet.extend;
                        C_HoraFinDet.extend;
                        C_ListaHoras.extend;
                        C_TipoHorasExtra.extend;
                        C_FechaDet.extend;
                     
                        CASE Ln_Contador1
                        WHEN '1' THEN
                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                          C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                        WHEN '2' THEN
                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                          C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                        ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                   'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                   'ERROR 20',
                                                   NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                        END CASE;
                     
                     END LOOP;
                  END IF ;
  
              --Validacion jornada nocturna y horas extras simples mix
              ELSE
                IF ((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
                AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1+1)AND (Ld_HoraFin1 < Ld_HorasInicioNocturnas1+1)) THEN
      
                    --Calculo de horas nocturnas de las 19:00 a 00:00
                    Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                    Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                    --Calculo de horas nocturnas de las 00:00 a 06:00
                    Ln_TotalHorasNocturno_1   := TRUNC(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24,24));
                    Ln_TotalMinutosNocturno_1 := ROUND(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24*60,60));
      
                    IF(Lv_TotalMinutosNocturno='29')THEN
                      Lv_TotalMinutosNocturno:='30';
                    END IF;
      
                    IF(Ln_TotalMinutosNocturno_1='29')THEN
                      Ln_TotalMinutosNocturno_1:='30';
                    END IF;
      
                    Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                    Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                    Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                    
                    IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                    --- SE AGREGA DIVISION DE HORAS POR 8 HORAS TRABAJADAS Y POR EL ADICIONAL DE HORAS EXTRAS 
                      Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                      Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                      --Calculo de horas nocturnas de las 00:00 a 06:00
                      Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                      Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                      --Calculo de horas dobles de las 00:00 a 06:00
                      Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                      Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                      --Calculo de horas simples de las 06:00 a 00:00
                      Lv_TotalHorasSimples      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24,24));
                      Lv_TotalMinutosSimples    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24*60,60));
                      
                      IF(Lv_TotalMinutosNocturno='29')THEN
                        Lv_TotalMinutosNocturno:='30';
                      END IF;
        
                      IF(Ln_TotalMinutosNocturno_1='29')THEN
                        Ln_TotalMinutosNocturno_1:='30';
                      END IF;
        
                      IF(Lv_TotalMinutosDobles='29')THEN
                        Lv_TotalMinutosDobles:='30';
                      END IF; 
    
                      IF(Lv_TotalMinutosSimples='29')THEN
                        Lv_TotalMinutosSimples:='30';
                      END IF;
                      
                      Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                      Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                      Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                      Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                      
                      Ln_Contador :=4;
                      Ln_Contador4:=2;
                      Ln_Contador1:=0;
        
                      FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','SIMPLE')
                      LOOP
                              
                          IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN
                               C_HoraInicioDet.extend;
                               C_HoraFinDet.extend;
                               C_ListaHoras.extend;
                               C_TipoHorasExtra.extend;
                               C_FechaDet.extend;
        
                               Ln_Contador1:=Ln_Contador1+1;
                               C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                               C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDobles1+1),'HH24:MI');
                               C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                               C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                               C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                          
                          ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN

                              WHILE Ln_Contador1 < Ln_Contador4 LOOP
        
                                    Ln_Contador1:=Ln_Contador1+1;
        
                                    C_HoraInicioDet.extend;
                                    C_HoraFinDet.extend;
                                    C_ListaHoras.extend;
                                    C_TipoHorasExtra.extend;
                                    C_FechaDet.extend;
        
                                    CASE Ln_Contador1
                                    WHEN '1' THEN
                                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                        C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                    WHEN '2' THEN
                                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                        C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                      ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                      'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                      'ERROR 20',
                                                      NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                    END CASE;
        
                              END LOOP;
                            ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN
                               
                                    C_HoraInicioDet.extend;
                                    C_HoraFinDet.extend;
                                    C_ListaHoras.extend;
                                    C_TipoHorasExtra.extend;
                                    C_FechaDet.extend;
              
                                    Ln_Contador1:=Ln_Contador1+1;
                                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDobles1+1,'HH24:MI');
                                    C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                                    C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
    
  
                          END IF;
                   
                      END LOOP;
                    
                    ELSE 
                      --Calculo de horas simples de las 06:00 a 00:00
                      Lv_TotalHorasSimples      := TRUNC(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                      Lv_TotalMinutosSimples    := ROUND(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));

                      IF(Lv_TotalMinutosSimples='29')THEN
                        Lv_TotalMinutosSimples:='30';
                      END IF;
                    
                      Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                      
                      Ln_Contador :=3;
                      Ln_Contador4:=2;
                      Ln_Contador1:=0;
        
                      FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','SIMPLE','')
                      LOOP
                              
    
                          IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN
                              C_HoraInicioDet.extend;
                              C_HoraFinDet.extend;
                              C_ListaHoras.extend;
                              C_TipoHorasExtra.extend;
                              C_FechaDet.extend;
        
                              Ln_Contador1:=Ln_Contador1+1;
                              C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                              C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                              C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                              C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                              C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
    
                          ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
        
                              WHILE Ln_Contador1 < Ln_Contador4 LOOP
        
                                    Ln_Contador1:=Ln_Contador1+1;
        
                                    C_HoraInicioDet.extend;
                                    C_HoraFinDet.extend;
                                    C_ListaHoras.extend;
                                    C_TipoHorasExtra.extend;
                                    C_FechaDet.extend;
        
                                    CASE Ln_Contador1
                                    WHEN '1' THEN
                                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                        C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                    WHEN '2' THEN
                                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                        C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                      ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                      'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                      'ERROR 20',
                                                      NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                    END CASE;
        
                              END LOOP;
        
        
                          END IF;
        
        
                      END LOOP;
                    END IF;--- SE LE AGREGAGO UN END IF-----
                END IF;
  
              END IF;                         
  
          END IF;
        
        ELSIF (Lv_EsFinDeSemana ='S') THEN
        --SE IDENTIFICA QUE TIPO DE JORNADA TIENE EL EMPLEADO
        IF(Lv_JornadaEmpleado = 'M')THEN
              --ASIGNACION HORAS DOBLES PARA FERIADOS Y FIN DE SEMANA
          
            --ASIGNACION HORAS DOBLES PARA DIAS LIBRES
    
           Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
                IF(Ld_HoraFin1>=Ld_HoraFinGeneral-1 AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
                   Ld_HoraFin1:= Ld_HoraFin1 +1;
                END IF;
      
                IF(Ld_HoraInicio1>Ld_HoraFinGeneral-1 AND Ld_HoraInicio1 < Ld_HoraFinGeneral) 
               AND(Ld_HoraFin1>Ld_HoraFinGeneral-1 AND Ld_HoraFin1<= Ld_HoraFinGeneral+1/1440) THEN 
    
                     Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                     Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
    
                     IF(Lv_TotalMinutosDobles='29')THEN
                        Lv_TotalMinutosDobles:='30';
                     END IF;
                       
                     Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                     Ln_Contador :=1;
          
                     IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                     OPEN C_TIPO_HORAS_EXTRA('DOBLES','','');
                     FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                     CLOSE C_TIPO_HORAS_EXTRA;
          
                     C_HoraInicioDet.extend;
                     C_HoraFinDet.extend;
                     C_ListaHoras.extend;
                     C_TipoHorasExtra.extend;
                     C_FechaDet.extend;
                     C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
          
               ELSIF (Ld_HoraInicio1<=Ld_HoraFinGeneral AND Ld_HoraInicio1 < Ld_HoraFin1)AND 
                  (Ld_HoraFin1 > Ld_HoraFinGeneral)THEN
    
                         Lv_TotalHorasDobles := TRUNC(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24,24));
                         Lv_TotalMinutosDobles := ROUND(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24*60,60));
                         Ln_TotalHorasDobles_1 := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral))*24,24));
                         Ln_TotalMinutosDobles_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral+1/1440))*24*60,60));
    
                         IF(Lv_TotalMinutosDobles='29')THEN
                            Lv_TotalMinutosDobles:='30';
                         END IF;
          
                         IF(Ln_TotalMinutosDobles_1 = '29')THEN
                            Ln_TotalMinutosDobles_1:= '30';
                         END IF;
          
                         Lv_TotalHoraMinutoDoble   := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                         Lv_TotalHoraMinutoDoble_1 := Ln_TotalHorasDobles_1||':'||Ln_TotalMinutosDobles_1;               
                        
                         Ln_Contador  :=2;
                         Ln_Contador1 :=0;
                         IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                         OPEN C_TIPO_HORAS_EXTRA('DOBLES','','');
                         FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                         CLOSE C_TIPO_HORAS_EXTRA;
          
                         WHILE Ln_Contador1 < Ln_Contador LOOP
          
                            Ln_Contador1:=Ln_Contador1+1;
    
                            C_HoraInicioDet.extend;
                            C_HoraFinDet.extend;
                            C_ListaHoras.extend;
                            C_TipoHorasExtra.extend;
                            C_FechaDet.extend;
          
                            CASE Ln_Contador1
                            WHEN '1' THEN
                              C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                              C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                              C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                              C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                              C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                            WHEN '2' THEN
                              C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                              C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                              C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble_1,'HH24:MI'),'HH24:MI');
                              C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                              C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                            ELSE
                                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                                'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                                'ERROR 20',
                                                                NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                                SYSDATE,
                                                                NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                            END CASE;
          
                         END LOOP;
          
               END IF;
          ELSE
              -- JORNADA NOCTURNA
              IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
                    Pv_Mensaje := 'Error 13: La hora inicio y hora fin ingresados para la fecha '||TO_CHAR(Ld_FechaSolicitud,'DD-MM-YYYY')||' , no entra en el rango de horas extras permitido';
                    RAISE Le_Errors;
              END IF;
      
                IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
                    Ld_HoraFin1 := Ld_HoraFin1+1;
                END IF;
                
               --Primer if funciona para el rango de horas de 19:00 a 00:00 nocturnas
               --Segundo if funciona para el rango de horas de 00:00 a 06:00 nocturnas
                IF((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HoraFinDia1 +1)
                AND(Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HoraFinDia1 +1 ) AND Ld_HoraFin1<= (Ld_HoraFinDia1+1/1440)) OR
                ((Ld_HoraInicio1 >= Ld_HoraFinDia1-1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1)
                AND(Ld_HoraFin1 < Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)) THEN 
                    
                    Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                    Lv_TotalMinutosNocturno := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
      
                    IF(Lv_TotalMinutosNocturno='29')THEN
                      Lv_TotalMinutosNocturno:='30';
                    END IF;
      
                    Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
      
                    Ln_Contador :=1;
      
                    IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                    OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                    FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                    CLOSE C_TIPO_HORAS_EXTRA;
      
                    C_HoraInicioDet.extend;
                    C_HoraFinDet.extend;
                    C_ListaHoras.extend;
                    C_TipoHorasExtra.extend;
                    C_FechaDet.extend;
                    C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                    C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                    C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                    C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                    C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
               
                --tercer if funciona para el rango de horas de 19:00 a 06:00 nocturnas separa las horas del dia anterior con las horas del siguiente dia.    
                ELSIF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < (Ld_HoraFinDia1+1/1440))
                AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1 > (Ld_HoraFinDia1+1/1440)  AND Ld_HoraFin1<= Ld_HorasFinNocturnas1+1)THEN
                          
                    Ln_total_horas :=0;
                    --Calculo de horas nocturnas de las 19:00 a 00:00
                    Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                    Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                    --Calculo de horas nocturnas de las 00:00 a 06:00
                    Ln_TotalHorasNocturno_1   := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24));
                    Ln_TotalMinutosNocturno_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24*60,60));
                    
                    Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                    Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                    Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                    --se valida el total de horas en jornada nocturna
                    IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                      
                      --se hace el calculo de nocturnas dobles segun corresponda
                      --Calculo de horas nocturnas de las 19:00 a 00:00
                      Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                      Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                      --Calculo de horas nocturnas de las 00:00 a 06:00
                      Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                      Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                      --Calculo de horas dobles de las 00:00 a 06:00
                      Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                      Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                      
                      IF(Lv_TotalMinutosNocturno='29')THEN
                        Lv_TotalMinutosNocturno:='30';
                      END IF;
        
                      IF(Ln_TotalMinutosNocturno_1='29')THEN
                        Ln_TotalMinutosNocturno_1:='30';
                      END IF;
        
                      IF(Lv_TotalMinutosDobles='29')THEN
                        Lv_TotalMinutosDobles:='30';
                      END IF; 
    
                      Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                      Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                      Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                      
                      Ln_Contador :=3;
                      Ln_Contador4:=2;
                      Ln_Contador1:=0;
        
                      FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','')
                      LOOP
                              
                           IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN
                               C_HoraInicioDet.extend;
                               C_HoraFinDet.extend;
                               C_ListaHoras.extend;
                               C_TipoHorasExtra.extend;
                               C_FechaDet.extend;
        
                               Ln_Contador1:=Ln_Contador1+1;
                               C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                               C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFin1),'HH24:MI');
                               C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                               C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                               C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
        
                           ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
        
                               WHILE Ln_Contador1 < Ln_Contador4 LOOP
        
                                    Ln_Contador1:=Ln_Contador1+1;
        
                                    C_HoraInicioDet.extend;
                                    C_HoraFinDet.extend;
                                    C_ListaHoras.extend;
                                    C_TipoHorasExtra.extend;
                                    C_FechaDet.extend;
        
                                    CASE Ln_Contador1
                                     WHEN '1' THEN
                                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                        C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                        C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                     WHEN '2' THEN
                                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24),'HH24:MI');
                                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                        C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                    ELSE
                                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                                'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                                'ERROR 20',
                                                                NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                                SYSDATE,
                                                                NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                    END CASE;
        
                               END LOOP;
        
        
                           END IF;
        
        
                      END LOOP;
      
                    ELSE 
    
                      IF(Lv_TotalMinutosNocturno='29')THEN
                        Lv_TotalMinutosNocturno:='30';
                      END IF;
                      
                      IF(Ln_TotalMinutosNocturno_1='29')THEN
                        Ln_TotalMinutosNocturno_1:='30';
                      END IF;
                      --se hace el calculo solos de nocturnas
                      Ln_Contador  :=2;
                      Ln_Contador1 :=0;
                      
                      IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                      OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                      FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                      CLOSE C_TIPO_HORAS_EXTRA;
                      
                      WHILE Ln_Contador1 < Ln_Contador LOOP
                
                          Ln_Contador1:=Ln_Contador1+1;
                
    
                          C_HoraInicioDet.extend;
                          C_HoraFinDet.extend;
                          C_ListaHoras.extend;
                          C_TipoHorasExtra.extend;
                          C_FechaDet.extend;
    
    
                          CASE Ln_Contador1
                          WHEN '1' THEN
                            C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                            C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                            C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                            C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                            C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                          WHEN '2' THEN
                            C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                            C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                            C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                            C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                            C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                            ELSE
                                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                                'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                                'ERROR 20',
                                                                NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                                SYSDATE,
                                                                NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                          END CASE;
                       
                       END LOOP;
                    END IF ;
    
                --Validacion jornada nocturna y horas extras simples mix
                ELSE
                  IF ((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
                  AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1+1)AND (Ld_HoraFin1 < Ld_HorasInicioNocturnas1+1)) THEN
        
                      --Calculo de horas nocturnas de las 19:00 a 00:00
                      Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                      Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                      --Calculo de horas nocturnas de las 00:00 a 06:00
                      Ln_TotalHorasNocturno_1   := TRUNC(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24,24));
                      Ln_TotalMinutosNocturno_1 := ROUND(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24*60,60));
  
                      IF(Lv_TotalMinutosNocturno='29')THEN
                        Lv_TotalMinutosNocturno:='30';
                      END IF;
        
                      IF(Ln_TotalMinutosNocturno_1='29')THEN
                        Ln_TotalMinutosNocturno_1:='30';
                      END IF;
        
                      Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                      Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                      Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                      
                      IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                      --- SE AGREGA DIVISION DE HORAS POR 8 HORAS TRABAJADAS Y POR EL ADICIONAL DE HORAS EXTRAS 
                        Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                        Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                        --Calculo de horas nocturnas de las 00:00 a 06:00
                        Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                        Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                        --Calculo de horas dobles de las 00:00 a 06:00
                        Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                        Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                        --Calculo de horas simples de las 06:00 a 00:00
                        Lv_TotalHorasSimples      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24,24));
                        Lv_TotalMinutosSimples    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24*60,60));
                        
                        IF(Lv_TotalMinutosNocturno='29')THEN
                          Lv_TotalMinutosNocturno:='30';
                        END IF;
          
                        IF(Ln_TotalMinutosNocturno_1='29')THEN
                          Ln_TotalMinutosNocturno_1:='30';
                        END IF;
          
                        IF(Lv_TotalMinutosDobles='29')THEN
                          Lv_TotalMinutosDobles:='30';
                        END IF; 
      
                        IF(Lv_TotalMinutosSimples='29')THEN
                          Lv_TotalMinutosSimples:='30';
                        END IF;
                        
                        Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                        Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                        Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                        Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                        
                        Ln_Contador :=4;
                        Ln_Contador4:=2;
                        Ln_Contador1:=0;
          
                        FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','SIMPLE')
                        LOOP
                                
                            IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN
                                 C_HoraInicioDet.extend;
                                 C_HoraFinDet.extend;
                                 C_ListaHoras.extend;
                                 C_TipoHorasExtra.extend;
                                 C_FechaDet.extend;
          
                                 Ln_Contador1:=Ln_Contador1+1;
                                 C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                                 C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDobles1+1),'HH24:MI');
                                 C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                                 C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                 C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                            
                            ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
  
                                WHILE Ln_Contador1 < Ln_Contador4 LOOP
          
                                      Ln_Contador1:=Ln_Contador1+1;
          
                                      C_HoraInicioDet.extend;
                                      C_HoraFinDet.extend;
                                      C_ListaHoras.extend;
                                      C_TipoHorasExtra.extend;
                                      C_FechaDet.extend;
          
                                      CASE Ln_Contador1
                                      WHEN '1' THEN
                                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                          C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                      WHEN '2' THEN
                                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                          C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                        ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                        'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                        'ERROR 20',
                                                        NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                      END CASE;
          
                                END LOOP;
                              ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN
                                 
                                      C_HoraInicioDet.extend;
                                      C_HoraFinDet.extend;
                                      C_ListaHoras.extend;
                                      C_TipoHorasExtra.extend;
                                      C_FechaDet.extend;
                
                                      Ln_Contador1:=Ln_Contador1+1;
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDobles1+1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
      
    
                            END IF;
                     
                        END LOOP;
                      
                      ELSE 
                        --Calculo de horas simples de las 06:00 a 00:00
                        Lv_TotalHorasSimples      := TRUNC(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                        Lv_TotalMinutosSimples    := ROUND(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
  
                        IF(Lv_TotalMinutosSimples='29')THEN
                          Lv_TotalMinutosSimples:='30';
                        END IF;
                      
                        Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                        
                        Ln_Contador :=3;
                        Ln_Contador4:=2;
                        Ln_Contador1:=0;
          
                        FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','SIMPLE','')
                        LOOP
                                
      
                            IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN
                                C_HoraInicioDet.extend;
                                C_HoraFinDet.extend;
                                C_ListaHoras.extend;
                                C_TipoHorasExtra.extend;
                                C_FechaDet.extend;
          
                                Ln_Contador1:=Ln_Contador1+1;
                                C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                                C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                                C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                                C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
      
                            ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
          
                                WHILE Ln_Contador1 < Ln_Contador4 LOOP
          
                                      Ln_Contador1:=Ln_Contador1+1;
          
                                      C_HoraInicioDet.extend;
                                      C_HoraFinDet.extend;
                                      C_ListaHoras.extend;
                                      C_TipoHorasExtra.extend;
                                      C_FechaDet.extend;
          
                                      CASE Ln_Contador1
                                      WHEN '1' THEN
                                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                          C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                      WHEN '2' THEN
                                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                          C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                        ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                        'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                        'ERROR 20',
                                                        NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                      END CASE;
          
                                END LOOP;
          
          
                            END IF;
          
          
                        END LOOP;
                      END IF;--- SE LE AGREGAGO UN END IF-----
                  END IF;
  
                END IF;           
          END IF;
        END IF;
        
  END IF;

  IF Lv_EsDiaLibre = 'S' THEN

    --ASIGNACION HORAS DOBLES PARA DIAS LIBRES

     Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');

     IF(Ld_HoraFin1>=Ld_HoraFinGeneral-1 AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
       Ld_HoraFin1:= Ld_HoraFin1 +1;
     END IF;

     IF(Ld_HoraInicio1>Ld_HoraFinGeneral-1 AND Ld_HoraInicio1 < Ld_HoraFinGeneral) 
     AND(Ld_HoraFin1>Ld_HoraFinGeneral-1 AND Ld_HoraFin1<= Ld_HoraFinGeneral+1/1440) THEN 

           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));

           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
             
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           Ln_Contador :=1;

           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','','');
           FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
           CLOSE C_TIPO_HORAS_EXTRA;

           C_HoraInicioDet.extend;
           C_HoraFinDet.extend;
           C_ListaHoras.extend;
           C_TipoHorasExtra.extend;
           C_FechaDet.extend;
           C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
           C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
           C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
           C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
           C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');

     ELSIF (Ld_HoraInicio1<=Ld_HoraFinGeneral AND Ld_HoraInicio1 < Ld_HoraFin1)AND 
        (Ld_HoraFin1 > Ld_HoraFinGeneral)THEN
     
               Lv_TotalHorasDobles := TRUNC(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24,24));
               Lv_TotalMinutosDobles := ROUND(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24*60,60));
               Ln_TotalHorasDobles_1 := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral+1/1440))*24,24));
               Ln_TotalMinutosDobles_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral+1/1440))*24*60,60));

               IF(Lv_TotalMinutosDobles='29')THEN
                  Lv_TotalMinutosDobles:='30';
               END IF;

               IF(Ln_TotalMinutosDobles_1 = '29')THEN
                  Ln_TotalMinutosDobles_1:= '30';
               END IF;

               Lv_TotalHoraMinutoDoble   := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
               Lv_TotalHoraMinutoDoble_1 := Ln_TotalHorasDobles_1||':'||Ln_TotalMinutosDobles_1;               
              
               Ln_Contador  :=2;
               Ln_Contador1 :=0;
               IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
               OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','','');
               FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
               CLOSE C_TIPO_HORAS_EXTRA;


               WHILE Ln_Contador1 < Ln_Contador LOOP

                  Ln_Contador1:=Ln_Contador1+1;


                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;


                  CASE Ln_Contador1
                  WHEN '1' THEN
                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                    C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                    C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                  WHEN '2' THEN
                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                    C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble_1,'HH24:MI'),'HH24:MI');
                    C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                  END CASE;

               END LOOP;

     END IF;
                                         
  
  END IF;
  
  
  IF(Ln_Contador = 0)THEN
     Pv_Mensaje := 'Error 20: La hora inicio y hora fin ingresadas para la fecha '||TO_CHAR(Ld_FechaSolicitud,'DD-MM-YYYY')||', no entran en el rango de horas extra permitido ';
     RAISE Le_Errors;
  END IF;

  -- Validar cuando una solicitud es de meses diferentes
  IF(Ld_HoraFin1>Ld_HoraFinDia1 + 1 AND (TO_CHAR(Ld_HoraInicio1,'MM')!= TO_CHAR(Ld_HoraFin1,'MM')) ) THEN
      Lv_bandera3:='true';

  END IF;

      --Insercion en la tablas

      IF (Lv_Descripcion = 'IND_TAR_HN_SM' OR Lv_Descripcion ='IND_TAR_SM' OR Lv_Descripcion='IND_CUAD_HN_SM' OR  Lv_Descripcion='IND_CUAD_SM' OR
          Lv_Descripcion='Unitaria') THEN

         IF Lv_bandera3 ='true' THEN
            Ln_ContadoreEmp:=1;
            Ln_ContadorEmpleado:=Ln_NoEmpleado.COUNT;
            WHILE Ln_ContadoreEmp<= Ln_ContadorEmpleado LOOP

                 WHILE Ln_Contador2 < Ln_Contador LOOP

                     Ln_Contador2 := Ln_Contador2 + 1;

                      Ln_IdHorasSolicitud := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD.NEXTVAL;

                      P_INSERT_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud,
                                                C_FechaDet(Ln_Contador2),
                                                C_HoraInicioDet(Ln_Contador2),
                                                C_HoraFinDet(Ln_Contador2),
                                                Lv_observacion,
                                                Lv_Descripcion,
                                                Lv_EmpresaCod,
                                                Lv_UsrCreacion,
                                                Pv_Status,
                                                Pv_Mensaje);

                       IF Pv_Status = 'ERROR' THEN
                            RAISE Le_Errors;
                       END IF;

                       P_INSERT_DETA_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud,
                                             C_TipoHorasExtra(Ln_Contador2),
                                             C_HoraInicioDet(Ln_Contador2),
                                             C_HoraFinDet(Ln_Contador2),
                                             C_ListaHoras(Ln_Contador2),
                                             C_FechaDet(Ln_Contador2),
                                             Lv_observacion,
                                             Lv_Estado,
                                             Lv_UsrCreacion,
                                             Pv_Status,
                                             Pv_Mensaje);

                       IF Pv_Status = 'ERROR' THEN
                            RAISE Le_Errors;
                       END IF;

                       P_INSERTAR_EMPLEADOS(Ln_IdHorasSolicitud,
                                            apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),
                                            Lv_Estado,
                                            Lv_UsrCreacion,
                                            Pv_Status,
                                            Pv_Mensaje);

                       IF Pv_Status = 'ERROR' THEN
                           RAISE Le_Errors;
                       END IF;

                       Ln_ContadorTarea := Lv_TareaId.COUNT;
                       WHILE Ln_ContadorTar <=  Ln_ContadorTarea LOOP

                             P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                                              apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorTar)),
                                              Lv_UsrCreacion,
                                              null,
                                              Lv_observacion,
                                              Pv_Status,
                                              Pv_Mensaje);

                             IF Pv_Status = 'ERROR' THEN
                                 RAISE Le_Errors;
                             END IF;

                             Ln_ContadorTar:=Ln_ContadorTar+1;

                       END LOOP;
                       Ln_ContadorTar:=1;
                       Ln_ContadorTarea:=0;

                       Ln_ContadorCuadrilla:=Ln_IdCuadrilla.COUNT;
                       WHILE Ln_ContadorCua <=  Ln_ContadorCuadrilla LOOP

                              P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                                                null,
                                                Lv_UsrCreacion,
                                                apex_json.get_number(p_path => Ln_IdCuadrilla(Ln_ContadorCua)),
                                                Lv_observacion,
                                                Pv_Status,
                                                Pv_Mensaje);

                              IF Pv_Status = 'ERROR' THEN
                                    RAISE Le_Errors;
                              END IF;

                              Ln_ContadorCua :=Ln_ContadorCua+1;

                       END LOOP;
                       Ln_ContadorCua:=1;
                       Ln_ContadorCuadrilla:=0;

                       Ln_ContadorDocumentos :=  Lv_NombreDocumento.COUNT;
                       WHILE Ln_ContadorDocu <=  Ln_ContadorDocumentos LOOP


                              P_INSERTAR_DOCUMENTOS(Ln_IdHorasSolicitud,
                                                    apex_json.get_varchar2(p_path => Lv_NombreDocumento(Ln_ContadorDocu)),
                                                    apex_json.get_varchar2(p_path => Lv_UbicacionDocumento(Ln_ContadorDocu)),
                                                    Lv_Estado,
                                                    Lv_UsrCreacion,
                                                    Pv_Status,
                                                    Pv_Mensaje);

                               IF Pv_Status = 'ERROR' THEN
                                    RAISE Le_Errors;
                               END IF;

                               Ln_ContadorDocu:=Ln_ContadorDocu+1;

                       END LOOP;
                       Ln_ContadorDocu:=1;
                       Ln_ContadorDocumentos:=0;

                 END LOOP;
                 Ln_Contador2:=0;


               Ln_ContadoreEmp :=Ln_ContadoreEmp+1;
            END LOOP;


         ELSE


            Ln_ContadoreEmp:=1;
            Ln_ContadorEmpleado:=Ln_NoEmpleado.COUNT;
            WHILE Ln_ContadoreEmp<= Ln_ContadorEmpleado LOOP


                      Ln_IdHorasSolicitud := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD.NEXTVAL;

                      P_INSERT_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud,
                                                TO_DATE(Ld_Fecha,'DD-MM-YYYY'),
                                                Lv_HoraInicio,
                                                Lv_HoraFin,
                                                Lv_observacion,
                                                Lv_Descripcion,
                                                Lv_EmpresaCod,
                                                Lv_UsrCreacion,
                                                Pv_Status,
                                                Pv_Mensaje);

                       IF Pv_Status = 'ERROR' THEN
                            RAISE Le_Errors;
                       END IF;

                       WHILE Ln_Contador2 < Ln_Contador LOOP

                             Ln_Contador2 := Ln_Contador2 + 1;


                          P_INSERT_DETA_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud,
                                             C_TipoHorasExtra(Ln_Contador2),
                                             C_HoraInicioDet(Ln_Contador2),
                                             C_HoraFinDet(Ln_Contador2),
                                             C_ListaHoras(Ln_Contador2),
                                             C_FechaDet(Ln_Contador2),
                                             Lv_observacion,
                                             Lv_Estado,
                                             Lv_UsrCreacion,
                                             Pv_Status,
                                             Pv_Mensaje);

                          IF Pv_Status = 'ERROR' THEN
                             RAISE Le_Errors;
                          END IF;


                       END LOOP;

                       Ln_Contador2:=0;


                       P_INSERTAR_EMPLEADOS(Ln_IdHorasSolicitud,
                                            apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),
                                            Lv_Estado,
                                            Lv_UsrCreacion,
                                            Pv_Status,
                                            Pv_Mensaje);

                       IF Pv_Status = 'ERROR' THEN
                           RAISE Le_Errors;
                       END IF;

                       Ln_ContadorTarea := Lv_TareaId.COUNT;
                       WHILE Ln_ContadorTar <=  Ln_ContadorTarea LOOP

                             P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                                              apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorTar)),
                                              Lv_UsrCreacion,
                                              null,
                                              Lv_observacion,
                                              Pv_Status,
                                              Pv_Mensaje);

                             IF Pv_Status = 'ERROR' THEN
                                 RAISE Le_Errors;
                             END IF;

                             Ln_ContadorTar:=Ln_ContadorTar+1;

                       END LOOP;
                       Ln_ContadorTar:=1;
                       Ln_ContadorTarea:=0;

                       Ln_ContadorCuadrilla:=Ln_IdCuadrilla.COUNT;
                       WHILE Ln_ContadorCua <=  Ln_ContadorCuadrilla LOOP

                              P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                                                null,
                                                Lv_UsrCreacion,
                                                apex_json.get_number(p_path => Ln_IdCuadrilla(Ln_ContadorCua)),
                                                Lv_observacion,
                                                Pv_Status,
                                                Pv_Mensaje);

                              IF Pv_Status = 'ERROR' THEN
                                    RAISE Le_Errors;
                              END IF;

                              Ln_ContadorCua :=Ln_ContadorCua+1;

                       END LOOP;
                       Ln_ContadorCua:=1;
                       Ln_ContadorCuadrilla:=0;


                       Ln_ContadorDocumentos :=  Lv_NombreDocumento.COUNT;
                       WHILE Ln_ContadorDocu <=  Ln_ContadorDocumentos LOOP


                              P_INSERTAR_DOCUMENTOS(Ln_IdHorasSolicitud,
                                                    apex_json.get_varchar2(p_path => Lv_NombreDocumento(Ln_ContadorDocu)),
                                                    apex_json.get_varchar2(p_path => Lv_UbicacionDocumento(Ln_ContadorDocu)),
                                                    Lv_Estado,
                                                    Lv_UsrCreacion,
                                                    Pv_Status,
                                                    Pv_Mensaje);

                               IF Pv_Status = 'ERROR' THEN
                                    RAISE Le_Errors;
                               END IF;

                               Ln_ContadorDocu:=Ln_ContadorDocu+1;

                       END LOOP;
                       Ln_ContadorDocu:=1;
                       Ln_ContadorDocumentos:=0;


                Ln_ContadoreEmp :=Ln_ContadoreEmp+1;
             END LOOP;


         END IF;





      ELSE


            Ln_IdHorasSolicitud2 := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD.NEXTVAL;


            P_INSERT_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud2,
                                      TO_DATE(Ld_Fecha,'DD-MM-YYYY'),
                                      Lv_HoraInicio,
                                      Lv_HoraFin,
                                      Lv_observacion,
                                      Lv_Descripcion,
                                      Lv_EmpresaCod,
                                      Lv_UsrCreacion,
                                      Pv_Status,
                                      Pv_Mensaje);


            WHILE Ln_Contador2 < Ln_Contador LOOP

              Ln_Contador2 := Ln_Contador2 + 1;


              P_INSERT_DETA_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud2,
                                             C_TipoHorasExtra(Ln_Contador2),
                                             C_HoraInicioDet(Ln_Contador2),
                                             C_HoraFinDet(Ln_Contador2),
                                             C_ListaHoras(Ln_Contador2),
                                             C_FechaDet(Ln_Contador2),
                                             Lv_observacion,
                                             Lv_Estado,
                                             Lv_UsrCreacion,
                                             Pv_Status,
                                             Pv_Mensaje);

               IF Pv_Status = 'ERROR' THEN
                  RAISE Le_Errors;
               END IF;


            END LOOP;


            FOR Ln_ContadorEmpleado in 1 .. Ln_NoEmpleado.COUNT LOOP
               P_INSERTAR_EMPLEADOS(Ln_IdHorasSolicitud2,
                                    apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadorEmpleado)),
                                    Lv_Estado,
                                    Lv_UsrCreacion,
                                    Pv_Status,
                                    Pv_Mensaje);

               IF Pv_Status = 'ERROR' THEN
                   RAISE Le_Errors;
               END IF;

            END LOOP;

            Ln_ContadorTarea := Lv_TareaId.COUNT;
            WHILE Ln_ContadorTar <=  Ln_ContadorTarea LOOP

               P_INSERTAR_TAREAS(Ln_IdHorasSolicitud2,
                                 apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorTar)),
                                 Lv_UsrCreacion,
                                 null,
                                 Lv_observacion,
                                 Pv_Status,
                                 Pv_Mensaje);

                IF Pv_Status = 'ERROR' THEN
                    RAISE Le_Errors;
                END IF;

                Ln_ContadorTar:=Ln_ContadorTar+1;

            END LOOP;

            Ln_ContadorCuadrilla:=Ln_IdCuadrilla.COUNT;
            WHILE Ln_ContadorCua <=  Ln_ContadorCuadrilla LOOP

               P_INSERTAR_TAREAS(Ln_IdHorasSolicitud2,
                                 null,
                                 Lv_UsrCreacion,
                                 apex_json.get_number(p_path => Ln_IdCuadrilla(Ln_ContadorCua)),
                                 Lv_observacion,
                                 Pv_Status,
                                 Pv_Mensaje);

               IF Pv_Status = 'ERROR' THEN
                   RAISE Le_Errors;
               END IF;

               Ln_ContadorCua :=Ln_ContadorCua+1;

             END LOOP;

             Ln_ContadorDocumentos :=  Lv_NombreDocumento.COUNT;
             WHILE Ln_ContadorDocu <=  Ln_ContadorDocumentos LOOP

                   P_INSERTAR_DOCUMENTOS(Ln_IdHorasSolicitud2,
                                       apex_json.get_varchar2(p_path => Lv_NombreDocumento(Ln_ContadorDocu)),
                                       apex_json.get_varchar2(p_path => Lv_UbicacionDocumento(Ln_ContadorDocu)),
                                       Lv_Estado,
                                       Lv_UsrCreacion,
                                       Pv_Status,
                                       Pv_Mensaje);

                 IF Pv_Status = 'ERROR' THEN
                       RAISE Le_Errors;
                 END IF;

                 Ln_ContadorDocu:=Ln_ContadorDocu+1;
             END LOOP;
             Ln_ContadorDocu:=1;
             Ln_ContadorDocumentos:=0;


      END IF;

     COMMIT;

     Pv_Status     := 'OK';
     Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
     WHEN Le_Errors THEN
       Pv_Status  := 'ERROR';
     WHEN OTHERS THEN
       Pv_Status  := 'ERROR';
       Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                 Pv_Mensaje || ' Linea error: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));


  END P_GUARDAR_HORASEXTRA;
  
  PROCEDURE P_ELIMINAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2)

  AS

      CURSOR C_OBSERVACION_SOLICITUD(Cn_IdHorasSolicitud NUMBER) IS
        SELECT IHSD.HORAS_SOLICITUD_ID,IHSD.TIPO_HORAS_EXTRA_ID,IHSD.HORA_INICIO_DET,IHSD.HORA_FIN_DET,
          IHSD.HORAS,IHSD.FECHA_SOLICITUD_DET,IHSD.OBSERVACION  
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
          WHERE IHS.ID_HORAS_SOLICITUD=Cn_IdHorasSolicitud 
          AND IHSD.FE_CREACION=(SELECT MAX(IHSDE.FE_CREACION) FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSDE
          WHERE IHSDE.HORAS_SOLICITUD_ID=Cn_IdHorasSolicitud);

      Ln_ContadorSolicitudes         NUMBER:=0;
      Ln_ContadorSoli                NUMBER:=1;
      Ln_IdSolicitud                 NUMBER;
      Ln_IdHorasSolicitud            apex_t_varchar2;
      Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
      Lv_usrCreacion                 VARCHAR2(25);
      Lv_EmpresaCod                  VARCHAR2(2);
      Le_Errors                      EXCEPTION;

  BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud          :=  APEX_JSON.find_paths_like(p_return_path => 'idHorasSolicitud[%]' );
    Lv_usrCreacion               :=  APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_EmpresaCod                :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');


       Ln_ContadorSolicitudes :=  Ln_IdHorasSolicitud.COUNT;
       WHILE Ln_ContadorSoli <=  Ln_ContadorSolicitudes LOOP

          Ln_IdSolicitud := apex_json.get_number(p_path => Ln_IdHorasSolicitud(Ln_ContadorSoli));

          P_ELIMINAR_MASIVA(Ln_IdSolicitud,
                            Lv_usrCreacion,
                            Lv_EmpresaCod,
                            Pv_Status,
                            Pv_Mensaje);


          IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
          END IF;

          Ln_ContadorSoli:=Ln_ContadorSoli+1;

       END LOOP;


        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';



  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_SOLICITUD_HEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_SOLICITUD_HEXTRA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));        

  END P_ELIMINAR_SOLICITUD_HEXTRA;


  PROCEDURE P_ANULAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2)

  AS


      CURSOR C_OBSERVACION_SOLICITUD(Cn_IdHorasSolicitud NUMBER) IS
        SELECT IHSD.HORAS_SOLICITUD_ID,IHSD.TIPO_HORAS_EXTRA_ID,IHSD.HORA_INICIO_DET,IHSD.HORA_FIN_DET,
          IHSD.HORAS,IHSD.FECHA_SOLICITUD_DET,IHSD.OBSERVACION  
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
          WHERE IHS.ID_HORAS_SOLICITUD=Cn_IdHorasSolicitud 
          AND IHSD.FE_CREACION=(SELECT MAX(IHSDE.FE_CREACION) FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSDE
          WHERE IHSDE.HORAS_SOLICITUD_ID=Cn_IdHorasSolicitud);

      Ln_IdHorasSolicitud            NUMBER;
      Lv_Observacion                 VARCHAR2(210);
      Lv_usrCreacion                 VARCHAR2(30);
      Lv_Estado                      VARCHAR2(20):='Anulada';
      Lv_EmpresaCod                  VARCHAR2(2);
      Lv_Proceso                     VARCHAR2(30):='Anulacion';
      Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
      Le_Errors                      EXCEPTION;

  BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud        :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud');
    Lv_Observacion             :=  APEX_JSON.get_varchar2(p_path => 'observacion');
    Lv_usrCreacion             :=  APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_empresaCod              :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');

    -- VALIDACIONES
         IF Ln_IdHorasSolicitud IS NULL THEN
            Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
            RAISE Le_Errors;
        END IF;

        IF Lv_Observacion IS NULL THEN
            Pv_Mensaje := 'Debe ingresar una observación para anular la solicitud N° '||Ln_IdHorasSolicitud||' ';
            RAISE Le_Errors;
        END IF;

        IF C_OBSERVACION_SOLICITUD%ISOPEN THEN CLOSE C_OBSERVACION_SOLICITUD; END IF;


         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          SET IHS.ESTADO='Anulada', IHS.OBSERVACION=''||Lv_Observacion||'',
          IHS.FE_MODIFICACION=SYSDATE,IHS.USR_MODIFICACION=Lv_usrCreacion
         WHERE IHS.ID_HORAS_SOLICITUD=''||Ln_IdHorasSolicitud||'' AND ESTADO IN('Pendiente','Pre-Autorizada');

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD
          SET IHSD.ESTADO='Anulada',IHSD.FE_MODIFICACION=SYSDATE, IHSD.USR_MODIFICACION=Lv_usrCreacion
         WHERE IHSD.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'' AND ESTADO IN('Pendiente','Pre-Autorizada');

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE
          SET IHSE.ESTADO='Anulada',IHSE.FE_MODIFICACION=SYSDATE, IHSE.USR_MODIFICACION=Lv_usrCreacion
         WHERE IHSE.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'' AND ESTADO IN('Pendiente','Pre-Autorizada');

         UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH
          SET ITH.ESTADO='Anulada',ITH.FE_MODIFICACION=SYSDATE, ITH.USR_MODIFICACION=Lv_usrCreacion
         WHERE ITH.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'' AND ESTADO IN('Pendiente','Pre-Autorizada');

         UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE
          SET IDHE.ESTADO='Anulada', IDHE.FE_CREACION=SYSDATE, IDHE.USR_MODIFICACION=Lv_usrCreacion
         WHERE IDHE.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'' AND ESTADO IN('Pendiente','Pre-Autorizada');


         FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Ln_IdHorasSolicitud) 
         LOOP

            P_INSERT_HISTORIAL_SOLICITUD(Ln_IdHorasSolicitud,
                                              Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                              Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                              Lr_ObservacionSolicitud.HORA_FIN_DET,
                                              Lr_ObservacionSolicitud.HORAS,
                                              Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                              Lr_ObservacionSolicitud.OBSERVACION,
                                              Lv_Estado,
                                              Lv_usrCreacion,
                                              Pv_Status,
                                              Pv_Mensaje);

                IF Pv_Status = 'ERROR' THEN
                  RAISE Le_Errors;
                END IF;

         END LOOP;


         P_ENVIAR_MAIL_GENERAL(Lv_Proceso,
                               Lv_EmpresaCod,
                               Ln_IdHorasSolicitud,
                               Lv_Observacion);


        COMMIT;


        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ANULAR_SOLICITUD_HEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ANULAR_SOLICITUD_HEXTRA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));          

  END P_ANULAR_SOLICITUD_HEXTRA;

  PROCEDURE P_AUTORIZAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2)

  AS

      Ln_IdSolicitud            NUMBER;
      Ln_IdSolicitud_1          NUMBER;
      Lv_Estado                 VARCHAR2(15);
      Lv_nombrePantalla         VARCHAR2(25);
      Lv_EmpresaCod             VARCHAR2(2);
      Lv_Usuario                VARCHAR2(25);
      Lv_EsSuperUsuario         VARCHAR2(20);
      Ld_FechaCorte             DATE;	
      Ld_FechaActual            DATE;
      Ln_ContadorSolicitudes    NUMBER:=0;
      Ln_ContadorSoli           NUMBER:=1;
      Lv_Mes_Solicitud          VARCHAR2(25);
      Lv_Mensaje                VARCHAR2(25);
      Le_Errors                 EXCEPTION;

      CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
       SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
         WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
       WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_CONSULTA';


       CURSOR C_FECHA_SOLICITUDES(Cv_IdHorasSolicitudes NUMBER)IS
        SELECT FECHA FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD WHERE ID_HORAS_SOLICITUD = Cv_IdHorasSolicitudes;

       Ln_IdHorasSolicitud      apex_t_varchar2;
       Lr_valor_1               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
       Lr_FechaSolicitud        DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD.FECHA%TYPE;

  BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud := APEX_JSON.find_paths_like(p_return_path => 'idHorasSolicitud[%]' );
    Lv_Estado           := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_nombrePantalla   := APEX_JSON.get_varchar2(p_path => 'nombrePantalla');
    Lv_Usuario          := APEX_JSON.get_varchar2(p_path => 'usuario');
    Lv_EmpresaCod       := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_EsSuperUsuario   := APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');


    -- VALIDACIONES
        IF Lv_Estado IS NULL THEN
            Pv_Mensaje := 'El parámetro estado está vacío';
            RAISE Le_Errors;
        END IF;

        IF Lv_EmpresaCod IS NULL THEN
            Pv_Mensaje := 'El parámetro empresaCod está vacío';
            RAISE Le_Errors;
        END IF;

        IF C_DIA_CORTE%ISOPEN THEN
          CLOSE C_DIA_CORTE;
        END IF;

        OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
        FETCH C_DIA_CORTE INTO Lr_valor_1;
        IF C_DIA_CORTE%FOUND THEN  
           SELECT TO_DATE(Lr_valor_1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
             INTO Ld_FechaCorte
           FROM DUAL;          
        END IF;

        CLOSE C_DIA_CORTE;

        Ld_FechaActual:= SYSDATE;        

        Ln_ContadorSolicitudes:= Ln_IdHorasSolicitud.COUNT;
        WHILE Ln_ContadorSoli <= Ln_ContadorSolicitudes LOOP

           Ln_IdSolicitud_1 := apex_json.get_number(p_path => Ln_IdHorasSolicitud(Ln_ContadorSoli));

           IF C_FECHA_SOLICITUDES%ISOPEN THEN CLOSE C_FECHA_SOLICITUDES; END IF;

           OPEN C_FECHA_SOLICITUDES(Ln_IdSolicitud_1);
           FETCH C_FECHA_SOLICITUDES INTO Lr_FechaSolicitud;

           Lv_Mes_Solicitud:= TO_CHAR(Lr_FechaSolicitud,'MM');

           CASE Lv_Mes_Solicitud
              WHEN  '01' THEN
                Lv_Mes_Solicitud :='Enero';
              WHEN  '02' THEN
                Lv_Mes_Solicitud :='Febrero';
              WHEN  '03' THEN
                Lv_Mes_Solicitud :='Marzo';
              WHEN  '04' THEN
                Lv_Mes_Solicitud :='Abril';
              WHEN  '05' THEN
                Lv_Mes_Solicitud :='Mayo';
              WHEN  '06' THEN
                Lv_Mes_Solicitud :='Junio';
              WHEN  '07' THEN
                Lv_Mes_Solicitud :='Julio';
              WHEN  '08' THEN
                Lv_Mes_Solicitud :='Agosto';
              WHEN  '09' THEN
                Lv_Mes_Solicitud :='Septiembre';
              WHEN  '10' THEN
                Lv_Mes_Solicitud :='Octubre';
              WHEN  '11' THEN
                Lv_Mes_Solicitud :='Noviembre';
              WHEN  '12' THEN
                Lv_Mes_Solicitud :='Diciembre';
            END CASE;

             ---- VALIDAR QUE SOLO SE PUEDAN Pre-Autorizar,Autorizar SOLICITUD PARA EL MES ACTUAL Y/O  MES VENCIDO

            IF Lv_EsSuperUsuario='Jefatura' THEN

              Lv_Mensaje:='Pre-Autorizar';

            ELSE

              Lv_Mensaje:='Autorizar';

            END IF;

            IF( (TO_CHAR(Lr_FechaSolicitud,'MM') !=  TO_CHAR(Ld_FechaActual,'MM')) AND (TO_CHAR(Lr_FechaSolicitud,'MM') != TO_CHAR(ADD_MONTHS(Ld_FechaActual,-1),'MM')) ) THEN
               Pv_Mensaje := 'ERROR 01: No se puede '||Lv_Mensaje||' solicitud para el mes de'||' '||Lv_Mes_Solicitud||' ,'||' mes inválido';
               RAISE Le_Errors;
            END IF;

            IF((TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY')) AND(TO_CHAR(Lr_FechaSolicitud,'MM') != TO_CHAR(Ld_FechaActual,'MM')) )THEN
               Pv_Mensaje := 'ERROR 02: No se puede '||Lv_Mensaje||' solicitud para el mes de'||' '||Lv_Mes_Solicitud||' el plazo máximo para '||Lv_Mensaje||' es hasta el'||' '||TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY');
               RAISE Le_Errors;
            END IF;

            ----//END VALIDAR Pre-Autorizar,Autorizar SOLICITUD.



           CLOSE C_FECHA_SOLICITUDES;


           Ln_ContadorSoli:= Ln_ContadorSoli+1;

        END LOOP;


        FOR Ln_ContadorSolicitud in 1 .. Ln_IdHorasSolicitud.COUNT LOOP

          Ln_IdSolicitud := apex_json.get_number(p_path => Ln_IdHorasSolicitud(Ln_ContadorSolicitud));

          P_AUTORIZACION_MASIVA(Ln_IdSolicitud,
                                Lv_Estado,
                                Lv_nombrePantalla,
                                Lv_Usuario,
                                Lv_EmpresaCod,
                                Pv_Status,
                                Pv_Mensaje);


          IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
          END IF;


        END LOOP;


        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_AUTORIZAR_SOLICITUD_HEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_AUTORIZAR_SOLICITUD_HEXTRA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

  END P_AUTORIZAR_SOLICITUD_HEXTRA;

  PROCEDURE P_ACTUALIZAR_SOLICITUD_HEXTRA(Pcl_Request  IN  CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2)      

  AS  

     Lv_HoraInicioSimples           VARCHAR2(7);
     Lv_HoraFinSimples              VARCHAR2(7);
     Lv_HoraInicioDobles            VARCHAR2(7);
     Lv_HoraFinDobles               VARCHAR2(7);
     Lv_HorasInicioNocturnas        VARCHAR2(7);
     Lv_HorasFinNocturnas           VARCHAR2(7);
     Lv_HoraInicioNoEstimadas       VARCHAR2(7);
     Lv_HoraFinNoEstimadas          VARCHAR2(7);
     Lv_NumHorasNocturnas           VARCHAR2(7);
     Lv_HoraInicioNoEstimadasNt     VARCHAR2(7);	
     Lv_HoraFinNoEstimadasNt        VARCHAR2(7);
     Lv_HoraFinDia                  VARCHAR2(7);

     Ld_HoraInicio1                 DATE;
     Ld_HoraFin1                    DATE;
     Ld_HoraInicioSimples1          DATE;
     Ld_HoraFinSimples1             DATE;
     Ld_HoraInicioDobles1           DATE;
     Ld_HoraFinDobles1              DATE;
     Ld_HorasInicioNocturnas1       DATE;
     Ld_HorasFinNocturnas1          DATE;
     Ld_HorasFinNocturnas2          DATE;
     Ld_HoraFinGeneral              DATE;
     Ld_HoraInicioNoEstimadas1      DATE;
     Ld_HoraFinNoEstimadas1         DATE;
     Ld_HoraInicioNoEstimadasNt1    DATE;	
     Ld_HoraFinNoEstimadasNt1       DATE;    
     Ld_HoraFinDia1                 DATE;
     Ld_FechaIngresada              DATE;
     Ld_FeInicioTarea1              DATE;
     Ld_FeFinTarea1                 DATE;
     Ld_FechaSolicitud              DATE;
     Ld_FechaCorte                  DATE;
     Ld_FechaActual                 DATE;
     Ld_LineaBaseFechaInicio        DATE;
     Ld_LineaBaseFechaFin           DATE;

     Lv_TotalHorasSimples           NUMBER;
     Lv_TotalMinutosSimples         NUMBER;
     Lv_TotalHorasDobles            NUMBER;
     Ln_TotalHorasDobles_1          NUMBER;
     Lv_TotalMinutosDobles          NUMBER;
     Ln_TotalMinutosDobles_1        NUMBER;
     Lv_TotalHorasNocturno          NUMBER;
     Ln_TotalHorasNocturno_1        NUMBER;
     Lv_TotalMinutosNocturno        NUMBER;
     Ln_TotalMinutosNocturno_1      NUMBER;

     Lv_TotalHoraMinutoSimple       VARCHAR2(55);
     Lv_TotalHoraMinutoDoble        VARCHAR2(55);
     Lv_TotalHoraMinutoDoble_1      VARCHAR2(55);
     Lv_TotalHoraMinutoNocturno     VARCHAR2(55);
     Lv_TotalHoraMinutoNocturno_1   VARCHAR2(55);
     Ln_total_horas                 NUMBER:=0;
     Ln_ContadorFecha               NUMBER:=0;
     Ln_ContadorEmpleado            NUMBER:=0;
     Ln_Contador                    NUMBER:=0;
     Ln_Contador1                   NUMBER:=0;
     Ln_Contador2                   NUMBER:=0;
     Ln_Contador4                   NUMBER:=0;
     Ln_ContadorDocumentos          NUMBER:=0;
     Ln_ContadorDocu                NUMBER:=1;
     Ln_ContadorImagenes            NUMBER:=0;
     Ln_ContadorImg                 NUMBER:=1;
     Ln_ContadorCuadrilla           NUMBER:=0;
     Ln_ContadorCua                 NUMBER:=1;
     Ln_ContadoreEmp                NUMBER:=1;
     Ln_ContadorFecha_1             NUMBER:=1;
     Ln_contadorFeriado             NUMBER := 1;
     Lv_bandera2                    VARCHAR2(6):='false';
     Lv_Mensaje                     VARCHAR2(30);

     Ld_Fecha                       VARCHAR2(25);
     Ld_FechaHasta                  VARCHAR2(25);
     Lv_HoraInicio                  VARCHAR2(7);
     Lv_HoraFin                     VARCHAR2(7);
     Lv_observacion                 VARCHAR2(200);
     Lv_Descripcion                 VARCHAR2(20);
     Lv_Estado                      VARCHAR2(15);
     Lv_EmpresaCod                  VARCHAR2(2);
     Lv_UsrCreacion                 VARCHAR2(15);
     Lv_IpCreacion                  VARCHAR2(15);
     Lv_Canton                      VARCHAR2(30):= NULL; 
     Lv_Provincia                   VARCHAR2(30):= NULL;
     Lv_TipoHorasExtraId            NUMBER;
     Lv_Horas                       VARCHAR2(7);
     Lv_JornadaEmpleado             VARCHAR2(2); 
     Lv_EsFinDeSemana               VARCHAR2(2);
     Lv_EsDiaLibre                  VARCHAR2(2);
     Lv_nombreDepartamento          VARCHAR2(35);
     Lv_EsSuperUsuario              VARCHAR2(20);
     Lv_Mes_Solicitud               VARCHAR2(25);
     Lv_EntraLineaBase              VARCHAR2(6):='false'; 
     Lr_esFeriado                   NUMBER:=0;
     Ld_HoraFin2                    DATE;
     Ln_sumaDia                     NUMBER:=0;
     Lv_EsFeriado1                  NUMBER:=0;
     Ld_FechaTemp                   VARCHAR2(25):=NULL; ----fecha que guarda temporalmente la fecha anterior
     totalresgistros                NUMBER:=0;----variable puesta momentaneamente 
     Ld_HorasInicioNocturnas2       DATE;
     Ld_HoraInicioDia1              DATE;

     TYPE C_ListTotalHoras          IS VARRAY(4) OF VARCHAR2(20);
     C_ListaHoras                   C_ListTotalHoras :=C_ListTotalHoras();
     TYPE C_ListTipoHorasExtra      IS VARRAY(4) OF VARCHAR2(20);
     C_TipoHorasExtra               C_ListTipoHorasExtra :=C_ListTipoHorasExtra();
     TYPE C_HoraInicio_Det          IS VARRAY(4) OF VARCHAR2(20);
     C_HoraInicioDet                C_HoraInicio_Det := C_HoraInicio_Det();
     TYPE C_HoraFin_Det             IS VARRAY(4) OF VARCHAR2(20);
     C_HoraFinDet                   C_HoraFin_Det := C_HoraFin_Det();
     TYPE C_Fecha_Det               IS VARRAY(4) OF DATE;
     C_FechaDet                     C_Fecha_Det := C_Fecha_Det();


     CURSOR C_TIPO_HORAS_EXTRA(Cv_TipoHorasExtra1 VARCHAR2,
                               Cv_TipoHorasExtra2 VARCHAR2, 
                               Cv_TipoHorasExtra3 VARCHAR2) IS 
       SELECT ID_TIPO_HORAS_EXTRA,TIPO_HORAS_EXTRA
         FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA IN(Cv_TipoHorasExtra1,Cv_TipoHorasExtra2,Cv_TipoHorasExtra3)
       ORDER BY ID_TIPO_HORAS_EXTRA ASC;


     CURSOR C_EXISTE_DEPARTAMENTO(Cv_Departamento VARCHAR2)IS
        SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
          WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='DEPARTAMENTO_TAREA_HE')
        AND VALOR1=Cv_Departamento AND APD.ESTADO='Activo';

     CURSOR C_EXISTE_CARGO_DEPARTAMENTO(Cv_Departamento VARCHAR2, Cv_CargoEmpleado VARCHAR2)IS
         SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='ROLES_TAREA_HE')
         AND VALOR1=Cv_Departamento AND VALOR2=Cv_CargoEmpleado AND APD.ESTADO='Activo';


     CURSOR C_CARGO_EMPLEADO(Cv_NoEmple VARCHAR2, Cv_NoCia VARCHAR2)IS
        SELECT DESCRIPCION_CARGO,NOMBRE,OFICINA_PROVINCIA,OFICINA_CANTON FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS WHERE NO_CIA=Cv_NoCia AND NO_EMPLE=Cv_NoEmple;

     CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
        SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
          WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
        WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_REGISTRO'
        AND APD.ESTADO='Activo';
        
     --DEPARTAMENTOS CONFIGURADOS   
      CURSOR C_DEPARTAMENTOS_CONFIGURADOS IS
          SELECT PARDET.VALOR1 AS NOMBRE_DEPTO, PARDET.VALOR2
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo';

        CURSOR C_OBTENER_LINEA_BASE(Cv_EmpresaCod VARCHAR2,
                                    Cv_Estado     VARCHAR2,
                                    Cv_NoEMple    VARCHAR2,
                                    Cv_FechaDesde VARCHAR2,
                                    Cv_FechaHasta VARCHAR2) IS
          SELECT AHE.NO_EMPLE,
                 TO_CHAR(AHE.FECHA_INICIO,'DD-MM-YYYY') FECHA_INICIO,
                 TO_CHAR(AHE.FECHA_FIN,'DD-MM-YYYY') FECHA_FIN,
                 AHE.HORA_INICIO,
                 AHE.HORA_FIN
            FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
            JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
              ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
             AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
           WHERE AHE.EMPRESA_COD = Cv_EmpresaCod
             AND AHE.ESTADO = Cv_Estado
             AND AHE.NO_EMPLE = Cv_NoEMple
             AND ((AHE.FECHA_INICIO >=
                 TO_DATE(Cv_FechaDesde, 'DD-MM-YYYY') AND
                 AHE.FECHA_INICIO <=
                 TO_DATE(Cv_FechaHasta, 'DD-MM-YYYY')) OR
                 (AHE.FECHA_FIN >=
                 TO_DATE(Cv_FechaDesde, 'DD-MM-YYYY') AND
                 AHE.FECHA_FIN <=
                 TO_DATE(Cv_FechaHasta, 'DD-MM-YYYY')));
             
        --OBTINE LA LINEA BASE MENSUAL DEL EMPLEADO 
        CURSOR C_OBTENER_LINEA_BASE_MES(Cv_EmpresaCod VARCHAR2,
                                    Cv_Estado     VARCHAR2,
                                    Cv_NoEMple    VARCHAR2,
                                    Cv_FechaDesde VARCHAR2,
                                    Cv_FechaHasta VARCHAR2) IS
                 SELECT AHE.NO_EMPLE,
                 TO_CHAR(AHE.FECHA_INICIO,'DD-MM-YYYY') FECHA_INICIO,
                 TO_CHAR(AHE.FECHA_FIN,'DD-MM-YYYY') FECHA_FIN,
                 AHE.HORA_INICIO,
                 AHE.HORA_FIN
            FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
            JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
              ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
             AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
           WHERE AHE.EMPRESA_COD = Cv_EmpresaCod
             AND AHE.ESTADO = Cv_Estado
             AND AHE.NO_EMPLE = Cv_NoEMple
             AND (TO_CHAR(AHE.FECHA_INICIO,'MM') = Cv_FechaDesde 
             AND TO_CHAR(AHE.FECHA_INICIO,'YYYY') = Cv_FechaHasta);
             
             
    CURSOR C_FERIADO_LOCAL (fecha VARCHAR2, nombreProvincia VARCHAR2)IS 
     SELECT p.DESCRIPCION PROVINCIA, c.DESCRIPCION CANTON
          --INTO Lv_Provincia, Lv_Canton
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          INNER JOIN NAF47_TNET.argepro p
          ON p.PROVINCIA = APD.VALOR6
          AND p.pais = '313'
          LEFT JOIN NAF47_TNET.argecan c
          ON p.PROVINCIA = c.PROVINCIA
          AND c.CANTON = APD.VALOR7
          AND C.pais = '313'
        WHERE APD.DESCRIPCION = 'MES_DIAS_FERIADO' 
          AND APD.VALOR3 = TO_CHAR(TO_DATE(fecha, 'DD-MM-YYYY'),'YYYY')
          AND TO_CHAR(TO_DATE(APD.VALOR2||'-'||APD.VALOR1||'-'||APD.VALOR3,'DD-MM-YYYY'), 'DD-MM-YYYY')= TO_CHAR(TO_DATE(fecha,'DD-MM-YYYY'), 'DD-MM-YYYY')
          AND APD.ESTADO = 'Activo'
          AND p.DESCRIPCION = nombreProvincia;




     Ln_NoEmpleado                  apex_t_varchar2;
     Lv_TareaId                     apex_t_varchar2;
     Lv_NombreDocumento             apex_t_varchar2;
     Lv_UbicacionDocumento          apex_t_varchar2;
     Ln_IdCuadrilla                 apex_t_varchar2;
     Lv_feInicioTarea               apex_t_varchar2;
     Lv_feFinTarea                  apex_t_varchar2;
     Lv_nombreImgEliminados         apex_t_varchar2;
     Ln_IdHorasSolicitud            DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD.ID_HORAS_SOLICITUD%TYPE;
     Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
     Ln_IdHorasSolicitudDetalle     DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE.ID_HORAS_SOLICITUD_DETALLE%TYPE;
     Ln_idTipoHoraExtra             DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA.ID_TIPO_HORAS_EXTRA%TYPE;
     Lr_Valor_1                     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
     Lr_Departamento                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
     Lr_CargoEmpleado               C_CARGO_EMPLEADO%ROWTYPE;
     Lr_CargoDepartamento           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
     Lr_idTipoHoraExtra             C_TIPO_HORAS_EXTRA%ROWTYPE;
     Le_Errors                      EXCEPTION;
     Lr_DepartamentosConfigurados   C_DEPARTAMENTOS_CONFIGURADOS%ROWTYPE;
    TYPE lv_linea_base IS TABLE OF C_OBTENER_LINEA_BASE_MES%ROWTYPE;
        T_LineaBase lv_linea_base;
    TYPE lv_feriado_local1 IS TABLE OF C_FERIADO_LOCAL%ROWTYPE;
     T_feriado_local1 lv_feriado_local1;


  BEGIN

     -- RETORNO LAS VARIABLES DEL REQUEST

    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud    := APEX_JSON.get_number(p_path => 'idHorasSolicitud');
    Ln_NoEmpleado          := APEX_JSON.find_paths_like(p_return_path => 'noEmpleado[%]' );
    Ld_Fecha               := APEX_JSON.get_varchar2(p_path => 'fecha');
    Lv_HoraInicio          := APEX_JSON.get_varchar2(p_path => 'horaInicio');
    Lv_HoraFin             := APEX_JSON.get_varchar2(p_path => 'horaFin');
    Lv_observacion         := APEX_JSON.get_varchar2(p_path => 'observacion');
    Lv_Estado              := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrCreacion         := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_TareaId             := APEX_JSON.find_paths_like (p_return_path => 'tareaId[%]' );
    Lv_NombreDocumento     := APEX_JSON.find_paths_like (p_return_path => 'nombreDocumento[%]' );
    Lv_UbicacionDocumento  := APEX_JSON.find_paths_like(p_return_path => 'ubicacionDocumento[%]' );
    Lv_JornadaEmpleado     := APEX_JSON.get_varchar2(p_path => 'jornadaEmpleado');
    Lv_EsFinDeSemana       := APEX_JSON.get_varchar2(p_path => 'esFinDeSemana');
    Lv_EsDiaLibre          := APEX_JSON.get_varchar2(p_path => 'esDiaLibre');
    Lv_Descripcion         := APEX_JSON.get_varchar2(p_path => 'descripcion');
    Ln_IdCuadrilla         := APEX_JSON.find_paths_like(p_return_path => 'idCuadrilla[%]' );
    Lv_nombreDepartamento  := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');
    Lv_EsSuperUsuario      := APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');
    Lv_feInicioTarea       := APEX_JSON.find_paths_like(p_return_path => 'feInicioTarea[%]' );
    Lv_feFinTarea          := APEX_JSON.find_paths_like(p_return_path => 'feFinTarea[%]' );
    Lv_nombreImgEliminados := APEX_JSON.find_paths_like(p_return_path => 'nombreImgEliminados[%]' );
    

    -- VALIDACIONES

    IF Ln_IdHorasSolicitud IS NULL THEN
      Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
      RAISE Le_Errors;
    END IF;

    IF Ld_Fecha IS NULL THEN
      Pv_Mensaje := 'El parámetro fecha está vacío';
      RAISE Le_Errors;

    END IF;

    IF Lv_HoraInicio IS NULL THEN
      Pv_Mensaje := 'El parámetro horaInicio está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_HoraFin IS NULL THEN
      Pv_Mensaje := 'El parámetro horaFin está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_Estado IS NULL THEN
      Pv_Mensaje := 'El parámetro estado está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_UsrCreacion IS NULL THEN
      Pv_Mensaje := 'El parámetro usrCreacion está vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_JornadaEmpleado IS NULL THEN
      Pv_Mensaje := 'El parámetro jornadaEmpleado está vacío';
      RAISE Le_Errors;
    END IF;

      SELECT
            CASE
              WHEN Lv_observacion LIKE ('Origen Solicitud Job barrido de tareas por departamentos tecnica%')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS TECNICA'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )              
              WHEN Lv_observacion LIKE ('Origen Tarea HE Job barrido de tareas por departamentos administrativos%')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS_ADMINISTRATIVA'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
                WHEN Lv_observacion LIKE ('Origen Tarea HE %')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO TAREA PROCESO HE'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
              WHEN Lv_observacion LIKE ('Origen Portal Planificacion HE%')
              THEN 'Verificacion'
              ELSE 'Pendiente'
            END AS ESTADO INTO Lv_Estado
          FROM DUAL;

      --Consulta de parametros de horarios de horas extras

      SELECT HORA_FIN
       INTO Lv_HoraFinDia
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'HORA_FIN_DIA';

      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HoraInicioNoEstimadas,Lv_HoraFinNoEstimadas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'HORAS_NO_ESTIMADAS_MATUTINA';

       SELECT HORA_INICIO,HORA_FIN	
        INTO Lv_HoraInicioNoEstimadasNt,Lv_HoraFinNoEstimadasNt	
        FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA	
       WHERE TIPO_HORAS_EXTRA = 'HORAS_NO_ESTIMADAS_NOCTURNA';

      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HoraInicioSimples,Lv_HoraFinSimples
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'SIMPLE';

      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HoraInicioDobles,Lv_HoraFinDobles
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'DOBLES';

      SELECT HORA_INICIO,HORA_FIN,TOTAL_HORAS_DIA
       INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas,Lv_NumHorasNocturnas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';

       SELECT CANTIDAD
       INTO Lr_esFeriado
      FROM (SELECT COUNT(*)AS CANTIDAD FROM DB_GENERAL.ADMI_PARAMETRO_DET 
       WHERE DESCRIPCION = 'MES_DIAS_FERIADO' 
          AND VALOR3 = TO_CHAR(TO_DATE(Ld_Fecha, 'DD-MM-YYYY'),'YYYY')
          AND TO_CHAR(TO_DATE(VALOR2||'-'||VALOR1||'-'||VALOR3,'DD-MM-YYYY'), 'DD-MM-YYYY')= TO_CHAR(TO_DATE(Ld_Fecha,'DD-MM-YYYY'), 'DD-MM-YYYY')
          AND ESTADO = 'Activo'
          AND VALOR5 IS NULL);


        IF C_DIA_CORTE%ISOPEN THEN
            CLOSE C_DIA_CORTE;
        END IF;

        OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
        FETCH C_DIA_CORTE INTO Lr_valor_1;

        IF C_DIA_CORTE%FOUND THEN  
           SELECT TO_DATE(Lr_valor_1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
             INTO Ld_FechaCorte
           FROM DUAL;           

        END IF;
        CLOSE C_DIA_CORTE;
        

       --HORA INICIO Y FIN INGRESADOS
      Ld_HoraInicio1 :=  to_timestamp((Ld_Fecha||' '||Lv_HoraInicio),'DD-MM-YYYY HH24:MI');   
      Ld_HoraFin1 :=  to_timestamp((Ld_Fecha||' '||Lv_HoraFin),'DD-MM-YYYY HH24:MI'); 

      -- HORAS SIMPLES
      Ld_HoraInicioSimples1 := to_timestamp((Ld_Fecha||' '||Lv_HoraInicioSimples),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinSimples1:= to_timestamp((Ld_Fecha||' '||Lv_HoraFinSimples),'DD-MM-YYYY HH24:MI');

      -- HORAS DOBLES
      Ld_HoraInicioDobles1 := to_timestamp((Ld_Fecha||' '||Lv_HoraInicioDobles),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinDobles1 :=  to_timestamp((Ld_Fecha||' '||Lv_HoraFinDobles),'DD-MM-YYYY HH24:MI');

      -- HORAS NOCTURNAS
      Ld_HorasInicioNocturnas1 := to_timestamp((Ld_Fecha||' '||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
      Ld_HorasFinNocturnas1 :=  to_timestamp((Ld_Fecha||' '||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');

      -- HORAS NO ESTIMADAS_MATUTINAS
      Ld_HoraInicioNoEstimadas1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioNoEstimadas),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinNoEstimadas1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinNoEstimadas),'DD-MM-YYYY HH24:MI');

      -- HORAS NO ESTIMADAS_NOCTURNAS
      Ld_HoraInicioNoEstimadasNt1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioNoEstimadasNt),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinNoEstimadasNt1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinNoEstimadasNt),'DD-MM-YYYY HH24:MI');

      -- HORA FIN DIA
      Ld_HoraFinDia1 := to_timestamp((Ld_Fecha||' '||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');


      Ld_FechaSolicitud:= TO_DATE(Ld_Fecha,'DD-MM-YYYY');
      Ld_FechaActual:= SYSDATE;

      Lv_Mes_Solicitud:= TO_CHAR(Ld_FechaSolicitud,'MM');

      Ld_HoraFin2 := Ld_HoraFin1;
      
      IF Ld_HoraFin1 < Ld_HoraInicio1 AND Ld_HoraFin1 >= (Ld_HoraFinDia1+1/1440)-1 THEN
            Ld_HoraFin2 := Ld_HoraFin1+1;
      END IF;  

      CASE Lv_Mes_Solicitud
        WHEN  '01' THEN
           Lv_Mes_Solicitud :='Enero';
        WHEN  '02' THEN
           Lv_Mes_Solicitud :='Febrero';
        WHEN  '03' THEN
           Lv_Mes_Solicitud :='Marzo';
        WHEN  '04' THEN
           Lv_Mes_Solicitud :='Abril';
        WHEN  '05' THEN
           Lv_Mes_Solicitud :='Mayo';
        WHEN  '06' THEN
           Lv_Mes_Solicitud :='Junio';
        WHEN  '07' THEN
           Lv_Mes_Solicitud :='Julio';
        WHEN  '08' THEN
           Lv_Mes_Solicitud :='Agosto';
        WHEN  '09' THEN
           Lv_Mes_Solicitud :='Septiembre';
        WHEN  '10' THEN
           Lv_Mes_Solicitud :='Octubre';
        WHEN  '11' THEN
           Lv_Mes_Solicitud :='Noviembre';
        WHEN  '12' THEN
           Lv_Mes_Solicitud :='Diciembre';
      END CASE;


      ---- VALIDAR QUE SOLO SE PUEDAN REGISTRAR SOLICITUD PARA EL MES ACTUAL Y/O  MES VENCIDO

      IF( (TO_CHAR(Ld_FechaSolicitud,'MM') !=  TO_CHAR(Ld_FechaActual,'MM')) AND (TO_CHAR(Ld_FechaSolicitud,'MM') != TO_CHAR(ADD_MONTHS(Ld_FechaActual,-1),'MM')) ) THEN

             Pv_Mensaje := 'ERROR 01: No se puede actualizar solicitud para el mes de'||' '||Lv_Mes_Solicitud||' ,'||' mes inválido';
             RAISE Le_Errors;

      END IF;


      IF((TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY')) AND(TO_CHAR(Ld_FechaSolicitud,'MM') != TO_CHAR(Ld_FechaActual,'MM')) )THEN
            Pv_Mensaje := 'ERROR 02: No se puede actualizar solicitud para el mes de'||' '||Lv_Mes_Solicitud||' el plazo máximo de actualizar es hasta el'||' '||TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY');
            RAISE Le_Errors;

      END IF;



      --VALIDAR SI EL DEPARTAMENTO DEBE INGRESAR TAREA EN LA SOLICITUD

         IF C_EXISTE_DEPARTAMENTO%ISOPEN THEN
              CLOSE C_EXISTE_DEPARTAMENTO;
         END IF;       

         OPEN C_EXISTE_DEPARTAMENTO(Lv_nombreDepartamento);
         FETCH C_EXISTE_DEPARTAMENTO INTO Lr_Departamento;

         IF(C_EXISTE_DEPARTAMENTO%FOUND)THEN  


                     Ln_ContadorEmpleado:=Ln_NoEmpleado.COUNT;
                     WHILE Ln_ContadoreEmp<= Ln_ContadorEmpleado LOOP

                        IF C_CARGO_EMPLEADO%ISOPEN THEN CLOSE C_CARGO_EMPLEADO; END IF;
                        OPEN C_CARGO_EMPLEADO(apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),Lv_EmpresaCod);
                        FETCH C_CARGO_EMPLEADO INTO Lr_CargoEmpleado;


                        IF(C_CARGO_EMPLEADO%FOUND)THEN 

                           IF C_EXISTE_CARGO_DEPARTAMENTO%ISOPEN THEN CLOSE C_EXISTE_CARGO_DEPARTAMENTO; END IF;
                           OPEN C_EXISTE_CARGO_DEPARTAMENTO(Lv_nombreDepartamento,Lr_CargoEmpleado.DESCRIPCION_CARGO);
                           FETCH C_EXISTE_CARGO_DEPARTAMENTO INTO Lr_CargoDepartamento;


                           IF(C_EXISTE_CARGO_DEPARTAMENTO%NOTFOUND AND Lv_feInicioTarea.COUNT = 0)THEN

                             Pv_Mensaje := 'Error 03: Se debe agregar una tarea para la solicitud de horas extras del empleado '||Lr_CargoEmpleado.NOMBRE||', 
                                            cargo: '||Lr_CargoEmpleado.DESCRIPCION_CARGO||' ';
                             RAISE Le_Errors;

                           END IF;


                           CLOSE C_EXISTE_CARGO_DEPARTAMENTO;

                        END IF;


                        CLOSE C_CARGO_EMPLEADO;

                        Ln_ContadoreEmp :=Ln_ContadoreEmp+1;


                     END LOOP;

                     Ln_ContadoreEmp:=1;


         END IF;

         CLOSE C_EXISTE_DEPARTAMENTO;

      ----//END VALIDAR DEPARTAMENTO.

      --CONDICIONAL PARA VALIDAR TAREA
      Ln_ContadorFecha:=Lv_feInicioTarea.COUNT;
      IF Ln_ContadorFecha > 0 THEN

          WHILE Ln_ContadorFecha_1<= Ln_ContadorFecha LOOP

            Ld_FeInicioTarea1 := TO_DATE(apex_json.get_varchar2(p_path => Lv_feInicioTarea(Ln_ContadorFecha_1)),'DD-MM-YYYY HH24:MI');
            Ld_FeFinTarea1 := TO_DATE(apex_json.get_varchar2(p_path => Lv_feFinTarea(Ln_ContadorFecha_1)),'DD-MM-YYYY HH24:MI');

            IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
                 Lv_bandera2:='true';
                 Ld_HoraFin1:=Ld_HoraFin1+1;
            END IF;


            IF (Ld_FeInicioTarea1 <= Ld_HoraInicio1 OR Ld_FeInicioTarea1 >= Ld_HoraInicio1) AND Ld_FeInicioTarea1< Ld_HoraFin1 AND Ld_FeFinTarea1>Ld_HoraInicio1 AND Ld_FeFinTarea1<=Ld_HoraFin1 THEN

                Lv_Mensaje:='Exito';

            ELSIF Ld_FeInicioTarea1 >= Ld_HoraInicio1 AND Ld_FeInicioTarea1< Ld_HoraFin1 AND Ld_FeFinTarea1>Ld_HoraInicio1 AND (Ld_FeFinTarea1<=Ld_HoraFin1 OR Ld_FeFinTarea1>=Ld_HoraFin1)  THEN

                Lv_Mensaje:='Exito';

            ELSIF (Ld_FeInicioTarea1 < Ld_HoraInicio1 AND Ld_FeInicioTarea1 < Ld_HoraFin1 AND Ld_FeFinTarea1>Ld_HoraInicio1 AND Ld_FeFinTarea1 > Ld_HoraFin1) AND
                  (Ld_HoraFin1 > Ld_FeInicioTarea1 AND Ld_HoraFin1 <= Ld_FeFinTarea1) THEN

               Lv_Mensaje:='Exito';

            ELSE 

                Pv_Mensaje:='Error 04: El rango de fecha hora inicio y hora fin de la tarea '||apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorFecha_1))||' no entra
                             en el intervalo de tiempo de la fecha hora inicio y fin de la solicitud ';
                RAISE Le_Errors;

            END IF;

            IF(Lv_bandera2 = 'true')THEN

                Ld_HoraFin1 := Ld_HoraFin1-1;

            END IF;

            Ln_ContadorFecha_1:=Ln_ContadorFecha_1+1;
          END LOOP;
          Ln_ContadorFecha_1:=1;
      END IF;
      ----//END CONDICIONAL PARA VALIDAR TAREA.

    --VERIFICACION DE LINEA BASE PARA LOS DEPARTAMENTOS CONFIGURADOS
    IF C_DEPARTAMENTOS_CONFIGURADOS%ISOPEN THEN CLOSE C_DEPARTAMENTOS_CONFIGURADOS; END IF;
    --VERIFICACION DE FERIADO
 
    FOR Lr_DepartamentosConfigurados IN C_DEPARTAMENTOS_CONFIGURADOS loop

     IF (Lv_nombreDepartamento = Lr_DepartamentosConfigurados.NOMBRE_DEPTO) THEN
 
          Ln_ContadoreEmp := 1;   
          Ln_ContadorEmpleado := Ln_NoEmpleado.COUNT;
          WHILE Ln_ContadoreEmp <= Ln_ContadorEmpleado LOOP
          
                --Se verifica si el empleado tiene registrada una linea base 
               IF C_OBTENER_LINEA_BASE_MES%ISOPEN THEN CLOSE C_OBTENER_LINEA_BASE_MES; END IF;
              
                OPEN C_OBTENER_LINEA_BASE_MES(Lv_EmpresaCod,
                                              'Activo',
                                              apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),
                                              to_char(to_date(Ld_Fecha,'DD/MM/YYYY'),'MM'),
                                              to_char(to_date(Ld_Fecha,'DD/MM/YYYY'),'YYYY'));
                    FETCH C_OBTENER_LINEA_BASE_MES BULK COLLECT INTO T_LineaBase;
                CLOSE C_OBTENER_LINEA_BASE_MES;

              --condicion que determina si el empleado tiene linea base 
              IF(T_LineaBase.count > 0)THEN
              
                    Lv_EsDiaLibre := 'S';
                    
                    --CONSULTAR EL HORARIO DE TRABAJO DEL EMPLEADO Y DETERMINA SI ES SU DIA LIBRE
                    FOR Lr_lineaBaseEmpleado IN C_OBTENER_LINEA_BASE(Lv_EmpresaCod,
                                                                     'Activo',
                                                                     apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),
                                                                     to_char(to_date(Ld_Fecha,'DD/MM/YYYY'),'DD/MM/YYYY') ,
                                                                     to_char(to_date(nvl(Ld_FechaHasta,to_char(Ld_HoraFin2,'DD/MM/YYYY')),'DD/MM/YYYY'),'DD/MM/YYYY')) LOOP
                      
                        Ld_LineaBaseFechaInicio := TO_DATE(Lr_lineaBaseEmpleado.FECHA_INICIO||' '||Lr_lineaBaseEmpleado.HORA_INICIO,'DD-MM-YYYY HH24:MI');
                        Ld_LineaBaseFechaFin := TO_DATE(Lr_lineaBaseEmpleado.FECHA_FIN||' '||Lr_lineaBaseEmpleado.HORA_FIN,'DD-MM-YYYY HH24:MI');
                        Ld_HorasInicioNocturnas2 := to_timestamp((Lr_lineaBaseEmpleado.FECHA_INICIO||' '||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
                        Ld_HorasFinNocturnas2 :=  to_timestamp((Lr_lineaBaseEmpleado.FECHA_INICIO||' '||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');
                        
                        IF (Lr_lineaBaseEmpleado.FECHA_INICIO <> Lr_lineaBaseEmpleado.FECHA_FIN AND Lr_lineaBaseEmpleado.FECHA_FIN > Lr_lineaBaseEmpleado.FECHA_INICIO)
                           OR Ld_LineaBaseFechaFin > Ld_HorasFinNocturnas2 THEN 
                            Ld_HorasFinNocturnas2 := Ld_HorasFinNocturnas2+1;
                        END IF;
                      
                        IF ((Lr_lineaBaseEmpleado.FECHA_INICIO <>  Lr_lineaBaseEmpleado.FECHA_FIN AND (Lr_lineaBaseEmpleado.FECHA_INICIO =  Ld_Fecha OR Lr_lineaBaseEmpleado.FECHA_FIN = Ld_Fecha))
                            OR Lr_lineaBaseEmpleado.FECHA_INICIO =  Lr_lineaBaseEmpleado.FECHA_FIN)  THEN 
                                                                    
                        IF Ld_HoraInicio1 >= Ld_HoraInicioDia1 AND Ld_HoraInicio1 < Ld_HoraFin2 AND Ld_LineaBaseFechaInicio >= Ld_HoraInicioDia1 AND Ld_LineaBaseFechaInicio < Ld_HoraFinDia1 THEN  
  
                        IF ((Ld_LineaBaseFechaFin > Ld_HorasInicioNocturnas2 AND Ld_HoraFin2 <= Ld_LineaBaseFechaFin AND
                            Ld_HoraInicio1 >= Ld_HorasInicioNocturnas2 AND Ld_HoraFin2 <= Ld_HorasFinNocturnas2 AND  Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio) OR
                           (Ld_HoraInicio1 >= (Ld_HoraFinDia1+1/1440)-1 AND Ld_HoraFin2 <= Ld_HorasFinNocturnas2 AND Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio AND 
                            Ld_HoraFin2 <= Ld_LineaBaseFechaFin)) THEN 

                              Lv_JornadaEmpleado:= 'N';
                              Lv_EntraLineaBase := 'false';
                        ELSE 
                            Lv_JornadaEmpleado:= 'M';
                        END IF;
                        END IF;
  
                        IF C_CARGO_EMPLEADO%ISOPEN THEN CLOSE C_CARGO_EMPLEADO; END IF;
                          OPEN C_CARGO_EMPLEADO(apex_json.get_number(p_path => Ln_NoEmpleado(1)),Lv_EmpresaCod);
                          FETCH C_CARGO_EMPLEADO INTO Lr_CargoEmpleado;
                          
                           ----PARA INDENTIFICAR SI EL EMPLEADO TIENE FERIADO LOCAL-----
                           IF C_FERIADO_LOCAL%ISOPEN THEN CLOSE C_FERIADO_LOCAL; END IF;
                                OPEN C_FERIADO_LOCAL(TO_CHAR(Ld_HoraInicio1, 'DD-MM-YYYY'), Lr_CargoEmpleado.OFICINA_PROVINCIA);
                                FETCH C_FERIADO_LOCAL BULK COLLECT INTO T_feriado_local1;
                                totalresgistros := T_feriado_local1.count;
  
                                   IF (T_feriado_local1.count > 0) then
                                       WHILE Ln_contadorFeriado <= totalresgistros loop
                                          Lv_Provincia := T_feriado_local1(Ln_contadorFeriado).PROVINCIA;
                                          Lv_Canton := T_feriado_local1(Ln_contadorFeriado).CANTON;
                                           IF ( Lv_Canton is null AND Lr_CargoEmpleado.OFICINA_PROVINCIA = Lv_Provincia) THEN 
                                               Lv_EsFeriado1 := 1;
                                           ELSIF(Lr_CargoEmpleado.OFICINA_PROVINCIA = Lv_Provincia AND Lr_CargoEmpleado.OFICINA_CANTON = Lv_Canton) THEN 
                                               Lv_EsFeriado1 := 1;
                                           ELSE 
                                               Lv_EsFeriado1 := 0;
                                           END IF;
                                           Ln_contadorFeriado:= Ln_contadorFeriado+1;
                                        END loop;
                                        Ln_contadorFeriado:=1;
                                        Lv_Provincia := null;
                                        Lv_Canton := null;
                                   END IF;
                          CLOSE C_FERIADO_LOCAL;
  
                        IF Lr_esFeriado = 1 OR Lv_EsFeriado1 = 1 OR 
                          (Lr_lineaBaseEmpleado.FECHA_INICIO <> Lr_lineaBaseEmpleado.FECHA_FIN AND Ld_FechaTemp IS NULL AND 
                          Ld_HoraInicio1 >= Ld_LineaBaseFechaFin AND Lr_DepartamentosConfigurados.VALOR2 = '2' AND Lv_JornadaEmpleado = 'M') THEN
                            Lv_EsDiaLibre := 'S';
                        ELSE
                            Lv_EsDiaLibre := 'N';
                        END IF;
                        
                        IF(Lv_JornadaEmpleado = 'M' AND Lv_EsDiaLibre = 'N')THEN
                          SELECT
                                CASE
                                  WHEN ((Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio OR Ld_HoraInicio1 <= Ld_LineaBaseFechaInicio AND 
                                         Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                        (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 <= Ld_LineaBaseFechaFin)) THEN 'true'
                                  WHEN ((Ld_HoraInicio1 < Ld_LineaBaseFechaInicio AND Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                         (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 > Ld_LineaBaseFechaFin)) THEN 'true'
                                  WHEN ((Ld_HoraInicio1 >= Ld_LineaBaseFechaInicio AND Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                         (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 > Ld_LineaBaseFechaFin)) THEN 'true'   
                                  WHEN ((Ld_HoraInicio1 < Ld_LineaBaseFechaInicio AND Ld_HoraInicio1 < Ld_LineaBaseFechaFin) AND
                                         (Ld_HoraFin2 > Ld_LineaBaseFechaInicio AND Ld_HoraFin2 <= Ld_LineaBaseFechaFin)) THEN 'true'
                                  ELSE 'false'
                                END EXISTE
                                into Lv_EntraLineaBase
                              FROM DUAL;
  
                        END IF;
                
                        IF(Lv_EntraLineaBase = 'true')THEN
                
                            Pv_Mensaje := 'Error 07:  No se permite realizar el registro. El intervalo hora inicio y hora fin para la fecha ' ||
                                        TO_CHAR(Ld_FechaSolicitud, 'DD-MM-YYYY') ||
                                        ' , se encuentra dentro de la linea base. ';
                            RAISE Le_Errors;
                
                         END IF;
                        Ld_FechaTemp:= Lr_lineaBaseEmpleado.FECHA_FIN;
                       END IF;
                      END LOOP;
                      Ln_sumaDia := 0;
                    ELSE 
                      Pv_Mensaje := 'Error 08:  No se permite realizar el registro. El empleado no tine linea base. ';
                      RAISE Le_Errors;
                  END IF;
                    Ln_ContadoreEmp := Ln_ContadoreEmp + 1;
              
          END LOOP;
      
      END IF;  
    END LOOP; 
--//FIN DE VALIDACION QUE OBLIGA A DEPARTAMENTOS CONFIGURADOS A TENER LINEA BASE

--SE IDENTIFICA SI ES DIA LIBRE DEL EMPLEADO 

  IF Lv_EsDiaLibre = 'N' THEN
      IF (Lv_EsFinDeSemana ='N') THEN
    --SE IDENTIFICA QUE TIPO DE JORNADA TIENE EL EMPLEADO
        IF(Lv_JornadaEmpleado = 'M')THEN
          --Se agrega validacion para aumentar un dia a la fecha fin para jornadas mixta simples y dobles 
          IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' OR 
             (Ld_HoraInicio1>= Ld_HoraInicioSimples1 AND Ld_HoraInicio1<=Ld_HoraFin1+1 AND Ld_HoraFin1<Ld_HoraInicio1 AND Ld_HoraFin1>= Ld_HoraInicioSimples1 AND Ld_HoraFin1<=Ld_HoraFinSimples1+1) THEN
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;

          --Validacion para crear solicitudes simples 
          IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
          AND (Ld_HoraFin1 > Ld_HoraInicioSimples1  AND Ld_HoraFin1 <= Ld_HoraFinSimples1+1) THEN

             Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
             Lv_TotalMinutosSimples := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));

             IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
             END IF;
           
             Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;

             Ln_Contador :=1;

             IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
             OPEN C_TIPO_HORAS_EXTRA('SIMPLE','','');
             FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
             CLOSE C_TIPO_HORAS_EXTRA;

             C_HoraInicioDet.extend;
             C_HoraFinDet.extend;
             C_ListaHoras.extend;
             C_TipoHorasExtra.extend;
             C_FechaDet.extend;
             C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
             C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
             C_ListaHoras(Ln_Contador):= TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
             C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
             C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');

          END IF;

          --Validacion para crear solicitudes Simples y dobles (mix)
          IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
          AND(Ld_HoraFin1 > (Ld_HoraInicioDobles1+1) AND Ld_HoraFin1 <= (Ld_HoraFinDobles1+1)) THEN

                Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFinSimples1+1 - Ld_HoraInicio1)*24,24));
                Lv_TotalMinutosSimples := ROUND(MOD((Ld_HoraFinSimples1+1 - Ld_HoraInicio1)*24*60,60));
                Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24));
                Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24*60,60));

                IF(Lv_TotalMinutosSimples='29')THEN
                   Lv_TotalMinutosSimples:='30';
                END IF;

                IF(Lv_TotalMinutosDobles='29')THEN
                   Lv_TotalMinutosDobles:='30';
                END IF;
                

                Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                
                Ln_Contador := 2 ;

                FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','DOBLES','')
                LOOP


                     Ln_Contador1 := Ln_Contador1+1;

                     C_HoraInicioDet.extend;
                     C_HoraFinDet.extend;
                     C_ListaHoras.extend;
                     C_TipoHorasExtra.extend;
                     C_FechaDet.extend;

                     CASE Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA
                        WHEN  'SIMPLE' THEN
                           C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                           C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                           C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                           C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                           C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                        WHEN 'DOBLES' THEN
                           C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                           C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                           C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                           C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                           C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                     END CASE;


                END LOOP;

          END IF;

          --Validacion para crear solicitudes dobles
          IF(Ld_HoraInicio1 >= Ld_HoraInicioDobles1 AND Ld_HoraInicio1< Ld_HoraFinDobles1)
          AND(Ld_HoraFin1 > Ld_HoraInicioDobles1 AND Ld_HoraFin1 <= Ld_HoraFinDobles1)THEN

              Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));

              IF(Lv_TotalMinutosDobles='29')THEN
                Lv_TotalMinutosDobles:='30';
             END IF;

              Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;

              Ln_Contador :=1;

              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('DOBLES','','');
              FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
              CLOSE C_TIPO_HORAS_EXTRA;

              C_HoraInicioDet.extend;
              C_HoraFinDet.extend;
              C_ListaHoras.extend;
              C_TipoHorasExtra.extend;
              C_FechaDet.extend;

              C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
              C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
              C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');

              C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
              C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
          END IF;


        ELSE
            -- JORNADA NOCTURNA

            IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
                Pv_Mensaje := 'Error 13: La hora inicio y hora fin ingresados para la fecha '||TO_CHAR(Ld_FechaSolicitud,'DD-MM-YYYY')||' , no entra en el rango de horas extras permitido';
                RAISE Le_Errors;
            END IF;
  
            IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
                Ld_HoraFin1 := Ld_HoraFin1+1;
            END IF;

            --Primer if funciona para el rango de horas de 19:00 a 00:00 nocturnas
            IF((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HoraFinDia1 +1)
            AND(Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HoraFinDia1 +1 ) AND Ld_HoraFin1<= (Ld_HoraFinDia1+1/1440)) OR
            ((Ld_HoraInicio1 >= Ld_HoraFinDia1-1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1)
            AND(Ld_HoraFin1 < Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)) THEN 
                
                Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                Lv_TotalMinutosNocturno := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
  
                IF(Lv_TotalMinutosNocturno='29')THEN
                  Lv_TotalMinutosNocturno:='30';
                END IF;
  
                Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
  
                Ln_Contador :=1;
  
                IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                CLOSE C_TIPO_HORAS_EXTRA;
  
                C_HoraInicioDet.extend;
                C_HoraFinDet.extend;
                C_ListaHoras.extend;
                C_TipoHorasExtra.extend;
                C_FechaDet.extend;
                C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
            
            --tercer if funciona para el rango de horas de 19:00 a 06:00 nocturnas separa las horas del dia anterior con las horas del siguiente dia.    
            ELSIF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < (Ld_HoraFinDia1+1/1440))
            AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1 > (Ld_HoraFinDia1+1/1440)  AND Ld_HoraFin1<= Ld_HorasFinNocturnas1+1)THEN
                      
                Ln_total_horas :=0;
                --Calculo de horas nocturnas de las 19:00 a 00:00
                Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                --Calculo de horas nocturnas de las 00:00 a 06:00
                Ln_TotalHorasNocturno_1   := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24));
                Ln_TotalMinutosNocturno_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24*60,60));
                
                IF(Lv_TotalMinutosNocturno='29')THEN
                  Lv_TotalMinutosNocturno:='30';
                END IF;
                
                IF(Ln_TotalMinutosNocturno_1='29')THEN
                  Ln_TotalMinutosNocturno_1:='30';
                END IF;
                
                Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                --se valida el total de horas en jornada nocturna
                IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                  
                  --se hace el calculo de nocturnas dobles segun corresponda
                  --Calculo de horas nocturnas de las 19:00 a 00:00
                  Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                  --Calculo de horas nocturnas de las 00:00 a 06:00
                  Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                  Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                  --Calculo de horas dobles de las 00:00 a 06:00
                  Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                  Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                  
                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
    
                  IF(Ln_TotalMinutosNocturno_1='29')THEN
                    Ln_TotalMinutosNocturno_1:='30';
                  END IF;
    
                  IF(Lv_TotalMinutosDobles='29')THEN
                    Lv_TotalMinutosDobles:='30';
                  END IF; 

                  Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                  Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                  Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                  
                  Ln_Contador :=3;
                  Ln_Contador4:=2;
                  Ln_Contador1:=0;
    
                  FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','')
                  LOOP
                          
                       IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN
                           C_HoraInicioDet.extend;
                           C_HoraFinDet.extend;
                           C_ListaHoras.extend;
                           C_TipoHorasExtra.extend;
                           C_FechaDet.extend;
    
                           Ln_Contador1:=Ln_Contador1+1;
                           C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                           C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFin1),'HH24:MI');
                           C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                           C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                           C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
    
                       ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
    
                           WHILE Ln_Contador1 < Ln_Contador4 LOOP
    
                                Ln_Contador1:=Ln_Contador1+1;
    
                                C_HoraInicioDet.extend;
                                C_HoraFinDet.extend;
                                C_ListaHoras.extend;
                                C_TipoHorasExtra.extend;
                                C_FechaDet.extend;
    
                                CASE Ln_Contador1
                                 WHEN '1' THEN
                                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                    C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                    C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                 WHEN '2' THEN
                                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                    C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24),'HH24:MI');
                                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                    C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                 'ERROR 20',
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                END CASE;
    
                           END LOOP;
    
    
                       END IF;
    
    
                  END LOOP;
  
                ELSE 
                  --se hace el calculo solos de nocturnas
                  Ln_Contador  :=2;
                  Ln_Contador1 :=0;
                  
                  IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                  OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                  FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                  CLOSE C_TIPO_HORAS_EXTRA;
                  
                  WHILE Ln_Contador1 < Ln_Contador LOOP
            
                      Ln_Contador1:=Ln_Contador1+1;
            
                      C_HoraInicioDet.extend;
                      C_HoraFinDet.extend;
                      C_ListaHoras.extend;
                      C_TipoHorasExtra.extend;
                      C_FechaDet.extend;
                   
                      CASE Ln_Contador1
                      WHEN '1' THEN
                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                        C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                      WHEN '2' THEN
                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                        C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                      ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                 'ERROR 20',
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                      END CASE;
                   
                   END LOOP;
                END IF ;

            --Validacion jornada nocturna y horas extras simples mix
            ELSE
              IF ((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
              AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1+1)AND (Ld_HoraFin1 < Ld_HorasInicioNocturnas1+1)) THEN
    
                  --Calculo de horas nocturnas de las 19:00 a 00:00
                  Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                  --Calculo de horas nocturnas de las 00:00 a 06:00
                  Ln_TotalHorasNocturno_1   := TRUNC(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24,24));
                  Ln_TotalMinutosNocturno_1 := ROUND(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24*60,60));
    
                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
    
                  IF(Ln_TotalMinutosNocturno_1='29')THEN
                    Ln_TotalMinutosNocturno_1:='30';
                  END IF;
    
                  Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                  Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                  Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                  
                  IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                  --- SE AGREGA DIVISION DE HORAS POR 8 HORAS TRABAJADAS Y POR EL ADICIONAL DE HORAS EXTRAS 
                    Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                    Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                    --Calculo de horas nocturnas de las 00:00 a 06:00
                    Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                    Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                    --Calculo de horas dobles de las 00:00 a 06:00
                    Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                    Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                    --Calculo de horas simples de las 06:00 a 00:00
                    Lv_TotalHorasSimples      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24,24));
                    Lv_TotalMinutosSimples    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24*60,60));
                    
                    IF(Lv_TotalMinutosNocturno='29')THEN
                      Lv_TotalMinutosNocturno:='30';
                    END IF;
      
                    IF(Ln_TotalMinutosNocturno_1='29')THEN
                      Ln_TotalMinutosNocturno_1:='30';
                    END IF;
      
                    IF(Lv_TotalMinutosDobles='29')THEN
                      Lv_TotalMinutosDobles:='30';
                    END IF; 
  
                    IF(Lv_TotalMinutosSimples='29')THEN
                      Lv_TotalMinutosSimples:='30';
                    END IF;
                    
                    Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                    Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                    Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                    Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                    
                    Ln_Contador :=4;
                    Ln_Contador4:=2;
                    Ln_Contador1:=0;
      
                    FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','SIMPLE')
                    LOOP
                            
                        IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN

                             C_HoraInicioDet.extend;
                             C_HoraFinDet.extend;
                             C_ListaHoras.extend;
                             C_TipoHorasExtra.extend;
                             C_FechaDet.extend;
      
                             Ln_Contador1:=Ln_Contador1+1;
                             C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                             C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDobles1+1),'HH24:MI');
                             C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                             C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                             C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                        
                        ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN

                            WHILE Ln_Contador1 < Ln_Contador4 LOOP
      
                                  Ln_Contador1:=Ln_Contador1+1;
      
                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
      
                                  CASE Ln_Contador1
                                  WHEN '1' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                  WHEN '2' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                    ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                    'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                    'ERROR 20',
                                                    NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                  END CASE;
      
                            END LOOP;
                          ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN

                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
            
                                  Ln_Contador1:=Ln_Contador1+1;
                                  C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDobles1+1,'HH24:MI');
                                  C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                                  C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                                  C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                  C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
  

                        END IF;

                    END LOOP;
                  
                  ELSE 
                    --Calculo de horas simples de las 06:00 a 00:00
                    Lv_TotalHorasSimples      := TRUNC(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                    Lv_TotalMinutosSimples    := ROUND(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));

                    IF(Lv_TotalMinutosSimples='29')THEN
                      Lv_TotalMinutosSimples:='30';
                    END IF;
                  
                    Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                    
                    Ln_Contador :=3;
                    Ln_Contador4:=2;
                    Ln_Contador1:=0;
      
                    FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','SIMPLE','')
                    LOOP
                            
  
                        IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN
                            C_HoraInicioDet.extend;
                            C_HoraFinDet.extend;
                            C_ListaHoras.extend;
                            C_TipoHorasExtra.extend;
                            C_FechaDet.extend;
      
                            Ln_Contador1:=Ln_Contador1+1;
                            C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                            C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                            C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                            C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                            C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
  
                        ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
      
                            WHILE Ln_Contador1 < Ln_Contador4 LOOP
      
                                  Ln_Contador1:=Ln_Contador1+1;
      
                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
      
                                  CASE Ln_Contador1
                                  WHEN '1' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                  WHEN '2' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                    ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                    'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                    'ERROR 20',
                                                    NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                  END CASE;
      
                            END LOOP;
      
      
                        END IF;
      
      
                    END LOOP;
                  END IF;--- SE LE AGREGAGO UN END IF-----
              END IF;

            END IF;                         

        END IF;
      
      
      
  ELSIF (Lv_EsFinDeSemana ='S') THEN
    --SE IDENTIFICA QUE TIPO DE JORNADA TIENE EL EMPLEADO
    IF(Lv_JornadaEmpleado = 'M')THEN
          --ASIGNACION HORAS DOBLES PARA FERIADOS Y FIN DE SEMANA
      
        --ASIGNACION HORAS DOBLES PARA DIAS LIBRES

       Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
  
            IF(Ld_HoraFin1>=Ld_HoraFinGeneral-1 AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
               Ld_HoraFin1:= Ld_HoraFin1 +1;
            END IF;
  
            IF(Ld_HoraInicio1>Ld_HoraFinGeneral-1 AND Ld_HoraInicio1 < Ld_HoraFinGeneral) 
           AND(Ld_HoraFin1>Ld_HoraFinGeneral-1 AND Ld_HoraFin1<= Ld_HoraFinGeneral+1/1440) THEN 

                 Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                 Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));

                 IF(Lv_TotalMinutosDobles='29')THEN
                    Lv_TotalMinutosDobles:='30';
                 END IF;
                   
                 Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                 Ln_Contador :=1;
      
                 IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                 OPEN C_TIPO_HORAS_EXTRA('DOBLES','','');
                 FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                 CLOSE C_TIPO_HORAS_EXTRA;
      
                 C_HoraInicioDet.extend;
                 C_HoraFinDet.extend;
                 C_ListaHoras.extend;
                 C_TipoHorasExtra.extend;
                 C_FechaDet.extend;
                 C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                 C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                 C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                 C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                 C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
      
           ELSIF (Ld_HoraInicio1<=Ld_HoraFinGeneral AND Ld_HoraInicio1 < Ld_HoraFin1)AND 
              (Ld_HoraFin1 > Ld_HoraFinGeneral)THEN

                     Lv_TotalHorasDobles := TRUNC(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24,24));
                     Lv_TotalMinutosDobles := ROUND(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24*60,60));
                     Ln_TotalHorasDobles_1 := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral))*24,24));
                     Ln_TotalMinutosDobles_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral+1/1440))*24*60,60));

                     IF(Lv_TotalMinutosDobles='29')THEN
                        Lv_TotalMinutosDobles:='30';
                     END IF;
      
                     IF(Ln_TotalMinutosDobles_1 = '29')THEN
                        Ln_TotalMinutosDobles_1:= '30';
                     END IF;
      
                     Lv_TotalHoraMinutoDoble   := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                     Lv_TotalHoraMinutoDoble_1 := Ln_TotalHorasDobles_1||':'||Ln_TotalMinutosDobles_1;               
                    
                     Ln_Contador  :=2;
                     Ln_Contador1 :=0;
                     IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                     OPEN C_TIPO_HORAS_EXTRA('DOBLES','','');
                     FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                     CLOSE C_TIPO_HORAS_EXTRA;
      
                     WHILE Ln_Contador1 < Ln_Contador LOOP
      
                        Ln_Contador1:=Ln_Contador1+1;

                        C_HoraInicioDet.extend;
                        C_HoraFinDet.extend;
                        C_ListaHoras.extend;
                        C_TipoHorasExtra.extend;
                        C_FechaDet.extend;
      
                        CASE Ln_Contador1
                        WHEN '1' THEN
                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                          C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                          C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                        WHEN '2' THEN
                          C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                          C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                          C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble_1,'HH24:MI'),'HH24:MI');
                          C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                          C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                        ELSE
                                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                            'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                            'ERROR 20',
                                                            NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                            SYSDATE,
                                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                        END CASE;
      
                     END LOOP;
      
           END IF;
      ELSE
          -- JORNADA NOCTURNA
          IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
                Pv_Mensaje := 'Error 13: La hora inicio y hora fin ingresados para la fecha '||TO_CHAR(Ld_FechaSolicitud,'DD-MM-YYYY')||' , no entra en el rango de horas extras permitido';
                RAISE Le_Errors;
          END IF;
  
            IF (Lv_HoraFin >'00:00' AND Lv_HoraFin < Lv_HoraInicio) OR Lv_HoraFin='00:00' THEN
                Ld_HoraFin1 := Ld_HoraFin1+1;
            END IF;
            
           --Primer if funciona para el rango de horas de 19:00 a 00:00 nocturnas
           --Segundo if funciona para el rango de horas de 00:00 a 06:00 nocturnas
            IF((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HoraFinDia1 +1)
            AND(Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HoraFinDia1 +1 ) AND Ld_HoraFin1<= (Ld_HoraFinDia1+1/1440)) OR
            ((Ld_HoraInicio1 >= Ld_HoraFinDia1-1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1)
            AND(Ld_HoraFin1 < Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)) THEN 
                
                Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
                Lv_TotalMinutosNocturno := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
  
                IF(Lv_TotalMinutosNocturno='29')THEN
                  Lv_TotalMinutosNocturno:='30';
                END IF;
  
                Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
  
                Ln_Contador :=1;
  
                IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                CLOSE C_TIPO_HORAS_EXTRA;
  
                C_HoraInicioDet.extend;
                C_HoraFinDet.extend;
                C_ListaHoras.extend;
                C_TipoHorasExtra.extend;
                C_FechaDet.extend;
                C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
           
            --tercer if funciona para el rango de horas de 19:00 a 06:00 nocturnas separa las horas del dia anterior con las horas del siguiente dia.    
            ELSIF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < (Ld_HoraFinDia1+1/1440))
            AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1 > (Ld_HoraFinDia1+1/1440)  AND Ld_HoraFin1<= Ld_HorasFinNocturnas1+1)THEN
                      
                Ln_total_horas :=0;
                --Calculo de horas nocturnas de las 19:00 a 00:00
                Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                --Calculo de horas nocturnas de las 00:00 a 06:00
                Ln_TotalHorasNocturno_1   := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24,24));
                Ln_TotalMinutosNocturno_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinDia1+1/1440))*24*60,60));
                
                Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                --se valida el total de horas en jornada nocturna
                IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                  
                  --se hace el calculo de nocturnas dobles segun corresponda
                  --Calculo de horas nocturnas de las 19:00 a 00:00
                  Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                  --Calculo de horas nocturnas de las 00:00 a 06:00
                  Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                  Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                  --Calculo de horas dobles de las 00:00 a 06:00
                  Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                  Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                  
                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
    
                  IF(Ln_TotalMinutosNocturno_1='29')THEN
                    Ln_TotalMinutosNocturno_1:='30';
                  END IF;
    
                  IF(Lv_TotalMinutosDobles='29')THEN
                    Lv_TotalMinutosDobles:='30';
                  END IF; 

                  Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                  Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                  Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                  
                  Ln_Contador :=3;
                  Ln_Contador4:=2;
                  Ln_Contador1:=0;
    
                  FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','')
                  LOOP
                          
                       IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN
                           C_HoraInicioDet.extend;
                           C_HoraFinDet.extend;
                           C_ListaHoras.extend;
                           C_TipoHorasExtra.extend;
                           C_FechaDet.extend;
    
                           Ln_Contador1:=Ln_Contador1+1;
                           C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                           C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFin1),'HH24:MI');
                           C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                           C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                           C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
    
                       ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
    
                           WHILE Ln_Contador1 < Ln_Contador4 LOOP
    
                                Ln_Contador1:=Ln_Contador1+1;
    
                                C_HoraInicioDet.extend;
                                C_HoraFinDet.extend;
                                C_ListaHoras.extend;
                                C_TipoHorasExtra.extend;
                                C_FechaDet.extend;
    
                                CASE Ln_Contador1
                                 WHEN '1' THEN
                                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                    C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                    C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                 WHEN '2' THEN
                                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDia1+1/1440),'HH24:MI');
                                    C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24),'HH24:MI');
                                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                    C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                ELSE
                                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                            'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                            'ERROR 20',
                                                            NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                            SYSDATE,
                                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                END CASE;
    
                           END LOOP;
    
    
                       END IF;
    
    
                  END LOOP;
  
                ELSE 

                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
                  
                  IF(Ln_TotalMinutosNocturno_1='29')THEN
                    Ln_TotalMinutosNocturno_1:='30';
                  END IF;
                  --se hace el calculo solos de nocturnas
                  Ln_Contador  :=2;
                  Ln_Contador1 :=0;
                  
                  IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
                  OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','','');
                  FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
                  CLOSE C_TIPO_HORAS_EXTRA;
                  
                  WHILE Ln_Contador1 < Ln_Contador LOOP
            
                      Ln_Contador1:=Ln_Contador1+1;
            

                      C_HoraInicioDet.extend;
                      C_HoraFinDet.extend;
                      C_ListaHoras.extend;
                      C_TipoHorasExtra.extend;
                      C_FechaDet.extend;


                      CASE Ln_Contador1
                      WHEN '1' THEN
                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                        C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                      WHEN '2' THEN
                        C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1+1/1440,'HH24:MI');
                        C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                        C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                        C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                        C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                        ELSE
                                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                            'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                            'ERROR 20',
                                                            NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                            SYSDATE,
                                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                      END CASE;
                   
                   END LOOP;
                END IF ;

            --Validacion jornada nocturna y horas extras simples mix
            ELSE
              IF ((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
              AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1+1)AND (Ld_HoraFin1 < Ld_HorasInicioNocturnas1+1)) THEN
    
                  --Calculo de horas nocturnas de las 19:00 a 00:00
                  Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                  Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                  --Calculo de horas nocturnas de las 00:00 a 06:00
                  Ln_TotalHorasNocturno_1   := TRUNC(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24,24));
                  Ln_TotalMinutosNocturno_1 := ROUND(MOD(((Ld_HorasFinNocturnas1+1) - (Ld_HoraFinDia1+1/1440))*24*60,60));
    
                  IF(Lv_TotalMinutosNocturno='29')THEN
                    Lv_TotalMinutosNocturno:='30';
                  END IF;
    
                  IF(Ln_TotalMinutosNocturno_1='29')THEN
                    Ln_TotalMinutosNocturno_1:='30';
                  END IF;
    
                  Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                  Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                  Ln_total_horas := Lv_TotalHorasNocturno + Ln_TotalHorasNocturno_1;
                  
                  IF (Ln_total_horas > Lv_NumHorasNocturnas) THEN
                  --- SE AGREGA DIVISION DE HORAS POR 8 HORAS TRABAJADAS Y POR EL ADICIONAL DE HORAS EXTRAS 
                    Lv_TotalHorasNocturno     := TRUNC(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24,24));
                    Lv_TotalMinutosNocturno   := ROUND(MOD(((Ld_HoraFinDia1+1/1440) - Ld_HoraInicio1)*24*60,60));
                    --Calculo de horas nocturnas de las 00:00 a 06:00
                    Ln_TotalHorasNocturno_1   := TRUNC(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24,24));
                    Ln_TotalMinutosNocturno_1 := ROUND(MOD((((Ld_HoraFinDia1+1/1440)+(Lv_NumHorasNocturnas-Lv_TotalHorasNocturno)/24) - (Ld_HoraFinDia1+1/1440))*24*60,60));
                    --Calculo de horas dobles de las 00:00 a 06:00
                    Lv_TotalHorasDobles      := TRUNC(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                    Lv_TotalMinutosDobles    := ROUND(MOD(((Ld_HoraFinDobles1+1) - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));
                    --Calculo de horas simples de las 06:00 a 00:00
                    Lv_TotalHorasSimples      := TRUNC(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24,24));
                    Lv_TotalMinutosSimples    := ROUND(MOD(((Ld_HoraFin1) - ((Ld_HoraFinDia1+1/1440)+((Ln_TotalHorasNocturno_1)+(Lv_TotalHorasDobles))/24))*24*60,60));
                    
                    IF(Lv_TotalMinutosNocturno='29')THEN
                      Lv_TotalMinutosNocturno:='30';
                    END IF;
      
                    IF(Ln_TotalMinutosNocturno_1='29')THEN
                      Ln_TotalMinutosNocturno_1:='30';
                    END IF;
      
                    IF(Lv_TotalMinutosDobles='29')THEN
                      Lv_TotalMinutosDobles:='30';
                    END IF; 
  
                    IF(Lv_TotalMinutosSimples='29')THEN
                      Lv_TotalMinutosSimples:='30';
                    END IF;
                    
                    Lv_TotalHoraMinutoNocturno   := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
                    Lv_TotalHoraMinutoNocturno_1 := Ln_TotalHorasNocturno_1||':'||Ln_TotalMinutosNocturno_1;
                    Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
                    Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                    
                    Ln_Contador :=4;
                    Ln_Contador4:=2;
                    Ln_Contador1:=0;
      
                    FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','DOBLES','SIMPLE')
                    LOOP
                            
                        IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='DOBLES')THEN

                             C_HoraInicioDet.extend;
                             C_HoraFinDet.extend;
                             C_ListaHoras.extend;
                             C_TipoHorasExtra.extend;
                             C_FechaDet.extend;
      
                             Ln_Contador1:=Ln_Contador1+1;
                             C_HoraInicioDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                             C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinDobles1+1),'HH24:MI');
                             C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                             C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                             C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                        
                        ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN

                            WHILE Ln_Contador1 < Ln_Contador4 LOOP
      
                                  Ln_Contador1:=Ln_Contador1+1;
      
                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
      
                                  CASE Ln_Contador1
                                  WHEN '1' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                  WHEN '2' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24),'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                    ELSE DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                    'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                    'ERROR 20',
                                                    NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                  END CASE;
      
                            END LOOP;
                          ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN

                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
            
                                  Ln_Contador1:=Ln_Contador1+1;
                                  C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDobles1+1,'HH24:MI');
                                  C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                                  C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                                  C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                  C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
  

                        END IF;

                    END LOOP;
                  
                  ELSE 
                    --Calculo de horas simples de las 06:00 a 00:00
                    Lv_TotalHorasSimples      := TRUNC(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24,24));
                    Lv_TotalMinutosSimples    := ROUND(MOD((Ld_HoraFin1 - ((Ld_HoraFinDia1+1/1440)+(Ln_TotalHorasNocturno_1)/24))*24*60,60));

                    IF(Lv_TotalMinutosSimples='29')THEN
                      Lv_TotalMinutosSimples:='30';
                    END IF;
                  
                    Lv_TotalHoraMinutoSimple     := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
                    
                    Ln_Contador :=3;
                    Ln_Contador4:=2;
                    Ln_Contador1:=0;
      
                    FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('NOCTURNO','SIMPLE','')
                    LOOP
                            
  
                        IF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='SIMPLE')THEN
                            C_HoraInicioDet.extend;
                            C_HoraFinDet.extend;
                            C_ListaHoras.extend;
                            C_TipoHorasExtra.extend;
                            C_FechaDet.extend;
      
                            Ln_Contador1:=Ln_Contador1+1;
                            C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                            C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                            C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                            C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                            C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
  
                        ELSIF(Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA='NOCTURNO')THEN
      
                            WHILE Ln_Contador1 < Ln_Contador4 LOOP
      
                                  Ln_Contador1:=Ln_Contador1+1;
      
                                  C_HoraInicioDet.extend;
                                  C_HoraFinDet.extend;
                                  C_ListaHoras.extend;
                                  C_TipoHorasExtra.extend;
                                  C_FechaDet.extend;
      
                                  CASE Ln_Contador1
                                  WHEN '1' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                                  WHEN '2' THEN
                                      C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinSimples1,'HH24:MI');
                                      C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                                      C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno_1,'HH24:MI'),'HH24:MI');
                                      C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                                      C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                                  ELSE 
                                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                    'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA: ',
                                                    'ERROR 20',
                                                    NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                  END CASE;
      
                            END LOOP;
      
      
                        END IF;
      
      
                    END LOOP;
                  END IF;--- SE LE AGREGAGO UN END IF-----
              END IF;

            END IF;           
      END IF;
    END IF;
      
END IF;


  IF Lv_EsDiaLibre = 'S' THEN

    --ASIGNACION HORAS DOBLES PARA DIAS LIBRES

     Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');

     IF(Ld_HoraFin1>=Ld_HoraFinGeneral-1 AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
       Ld_HoraFin1:= Ld_HoraFin1 +1;
     END IF;

     IF(Ld_HoraInicio1>Ld_HoraFinGeneral-1 AND Ld_HoraInicio1 < Ld_HoraFinGeneral) 
     AND(Ld_HoraFin1>Ld_HoraFinGeneral-1 AND Ld_HoraFin1<= Ld_HoraFinGeneral+1/1440) THEN 

           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := ROUND(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));

           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
             
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           Ln_Contador :=1;

           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','','');
           FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
           CLOSE C_TIPO_HORAS_EXTRA;

           C_HoraInicioDet.extend;
           C_HoraFinDet.extend;
           C_ListaHoras.extend;
           C_TipoHorasExtra.extend;
           C_FechaDet.extend;
           C_HoraInicioDet(Ln_Contador):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
           C_HoraFinDet(Ln_Contador):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
           C_ListaHoras(Ln_Contador):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
           C_TipoHorasExtra(Ln_Contador):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
           C_FechaDet(Ln_Contador) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');

     ELSIF (Ld_HoraInicio1<=Ld_HoraFinGeneral AND Ld_HoraInicio1 < Ld_HoraFin1)AND 
        (Ld_HoraFin1 > Ld_HoraFinGeneral)THEN
     
               Lv_TotalHorasDobles := TRUNC(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24,24));
               Lv_TotalMinutosDobles := ROUND(MOD(((Ld_HoraFinGeneral+1/1440) - Ld_HoraInicio1)*24*60,60));
               Ln_TotalHorasDobles_1 := TRUNC(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral+1/1440))*24,24));
               Ln_TotalMinutosDobles_1 := ROUND(MOD((Ld_HoraFin1 - (Ld_HoraFinGeneral+1/1440))*24*60,60));

               IF(Lv_TotalMinutosDobles='29')THEN
                  Lv_TotalMinutosDobles:='30';
               END IF;

               IF(Ln_TotalMinutosDobles_1 = '29')THEN
                  Ln_TotalMinutosDobles_1:= '30';
               END IF;

               Lv_TotalHoraMinutoDoble   := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
               Lv_TotalHoraMinutoDoble_1 := Ln_TotalHorasDobles_1||':'||Ln_TotalMinutosDobles_1;               
              
               Ln_Contador  :=2;
               Ln_Contador1 :=0;
               IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
               OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','','');
               FETCH C_TIPO_HORAS_EXTRA INTO Lr_idTipoHoraExtra;
               CLOSE C_TIPO_HORAS_EXTRA;


               WHILE Ln_Contador1 < Ln_Contador LOOP

                  Ln_Contador1:=Ln_Contador1+1;


                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;


                  CASE Ln_Contador1
                  WHEN '1' THEN
                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                    C_HoraFinDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                    C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                  WHEN '2' THEN
                    C_HoraInicioDet(Ln_Contador1):= TO_CHAR((Ld_HoraFinGeneral+1/1440),'HH24:MI');
                    C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                    C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble_1,'HH24:MI'),'HH24:MI');
                    C_TipoHorasExtra(Ln_Contador1):= Lr_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                    C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                  END CASE;

               END LOOP;

     END IF;
                                         
  
  END IF;
  
   IF(Ln_Contador = 0)THEN
     Pv_Mensaje := 'Error 18: La hora inicio y hora fin ingresados para la fecha '||TO_CHAR(Ld_FechaSolicitud,'DD-MM-YYYY')||' , no entra en el rango de horas extras permitido ';
     RAISE Le_Errors;
   END IF;


    --Modificación de tablas

    UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD
     SET HORA_INICIO =Lv_HoraInicio, HORA_FIN =Lv_HoraFin, FECHA=TO_DATE(Ld_Fecha,'DD-MM-YYYY'),
         OBSERVACION= Lv_observacion, USR_MODIFICACION=Lv_UsrCreacion, FE_MODIFICACION =SYSDATE,
         ESTADO=Lv_Estado
    WHERE ID_HORAS_SOLICITUD=Ln_IdHorasSolicitud;

    FOR Ln_ContadorEmpleado in 1 .. Ln_NoEmpleado.COUNT LOOP

        UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO
         SET ESTADO='Inactivo'
        WHERE HORAS_SOLICITUD_ID= Ln_IdHorasSolicitud AND NO_EMPLE=apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadorEmpleado));

        P_INSERTAR_EMPLEADOS(Ln_IdHorasSolicitud,
                             apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadorEmpleado)),
                             Lv_Estado,
                             Lv_UsrCreacion,
                             Pv_Status,
                             Pv_Mensaje);

        IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
        END IF;

    END LOOP;

    UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE
     SET ESTADO='Inactivo' 
    WHERE HORAS_SOLICITUD_ID= Ln_IdHorasSolicitud;

    WHILE Ln_Contador2 < Ln_Contador LOOP

       Ln_Contador2 := Ln_Contador2 + 1;

       P_INSERT_DETA_SOLICITUD_HEXTRA(Ln_IdHorasSolicitud,
                                      C_TipoHorasExtra(Ln_Contador2),
                                      C_HoraInicioDet(Ln_Contador2),
                                      C_HoraFinDet(Ln_Contador2),
                                      C_ListaHoras(Ln_Contador2),
                                      C_FechaDet(Ln_Contador2),
                                      Lv_observacion,
                                      Lv_Estado,
                                      Lv_UsrCreacion,
                                      Pv_Status,
                                      Pv_Mensaje);

       IF Pv_Status = 'ERROR' THEN
           RAISE Le_Errors;
       END IF;


    END LOOP;


    UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS 
     SET ESTADO='Inactivo'
    WHERE HORAS_SOLICITUD_ID= Ln_IdHorasSolicitud;


    FOR Ln_ContadorTarea in 1 .. Lv_TareaId.COUNT LOOP

       P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                         apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorTarea)),
                         Lv_UsrCreacion,
                         null,
                         Lv_observacion,
                         Pv_Status,
                         Pv_Mensaje);

        IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
        END IF;

    END LOOP;

    Ln_ContadorCuadrilla:=Ln_IdCuadrilla.COUNT;
    WHILE Ln_ContadorCua <=  Ln_ContadorCuadrilla LOOP

          P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                            null,
                            Lv_UsrCreacion,
                            apex_json.get_number(p_path => Ln_IdCuadrilla(Ln_ContadorCua)),
                            Lv_observacion,
                            Pv_Status,
                            Pv_Mensaje);

          IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
          END IF;

          Ln_ContadorCua :=Ln_ContadorCua+1;

    END LOOP;

    Ln_ContadorImagenes := Lv_nombreImgEliminados.COUNT;
    WHILE Ln_ContadorImg <= Ln_ContadorImagenes LOOP

       UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS
         SET ESTADO='Inactivo'
        WHERE HORAS_SOLICITUD_ID=Ln_IdHorasSolicitud 
         AND NOMBRE_DOCUMENTO = (apex_json.get_varchar2(p_path => Lv_nombreImgEliminados(Ln_ContadorImg)));

        Ln_ContadorImg := Ln_ContadorImg+1;
    END LOOP;


    Ln_ContadorDocumentos := Lv_UbicacionDocumento.COUNT;
    WHILE Ln_ContadorDocu <= Ln_ContadorDocumentos LOOP

       P_INSERTAR_DOCUMENTOS(Ln_IdHorasSolicitud,
                            apex_json.get_varchar2(p_path => Lv_NombreDocumento(Ln_ContadorDocu)),
                            apex_json.get_varchar2(p_path => Lv_UbicacionDocumento(Ln_ContadorDocu)),
                            Lv_Estado,
                            Lv_UsrCreacion,
                            Pv_Status,
                            Pv_Mensaje);

       IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
       END IF;

       Ln_ContadorDocu:=Ln_ContadorDocu+1;
    END LOOP;


    COMMIT;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZAR_SOLICITUD_HEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZAR_SOLICITUD_HEXTRA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

  END P_ACTUALIZAR_SOLICITUD_HEXTRA;

  PROCEDURE P_INSERT_SOLICITUD_HEXTRA(Pn_IdHorasSolicitud    IN NUMBER,
                                      Pd_Fecha               IN DATE,
                                      Pv_HoraInicio          IN VARCHAR2,
                                      Pv_HoraFin             IN VARCHAR2,
                                      Pv_observacion         IN VARCHAR2,
                                      Pv_Descripcion         IN VARCHAR2,
                                      Pv_EmpresaCod          IN VARCHAR2,
                                      Pv_UsrCreacion         IN VARCHAR2,
                                      Pv_Status              OUT VARCHAR2,
                                      Pv_Mensaje             OUT VARCHAR2)


  AS
      Lv_EstadoSol                   VARCHAR2(15);     
      Le_Errors                      EXCEPTION;

  BEGIN

      SELECT
        CASE
          WHEN Pv_observacion LIKE ('Origen Solicitud Job barrido de tareas por departamentos tecnica%')
          THEN
            (SELECT PARDET.VALOR1 AS ESTADO
            FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS TECNICA'
            AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
            AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA'
            AND PARDET.ESTADO             = 'Activo'
            AND PARCAB.ESTADO             = 'Activo'
            )
          WHEN Pv_observacion LIKE ('Origen Tarea HE Job barrido de tareas por departamentos administrativos%')
          THEN
            (SELECT PARDET.VALOR1 AS ESTADO
            FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS_ADMINISTRATIVA'
            AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
            AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA'
            AND PARDET.ESTADO             = 'Activo'
            AND PARCAB.ESTADO             = 'Activo'
            )
             WHEN Pv_observacion LIKE ('Origen Tarea HE %')
          THEN
            (SELECT PARDET.VALOR1 AS ESTADO
            FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'ESTADO TAREA PROCESO HE'
            AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
            AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE'
            AND PARDET.ESTADO             = 'Activo'
            AND PARCAB.ESTADO             = 'Activo'
            )
          WHEN Pv_observacion LIKE ('Origen Portal Planificacion HE%')
          THEN 'Verificacion'
          ELSE 'Pendiente'
        END AS ESTADO INTO Lv_EstadoSol
      FROM DUAL;

        INSERT        

        INTO DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD 
        (
        ID_HORAS_SOLICITUD,
        FECHA,
        HORA_INICIO,
        HORA_FIN,
        OBSERVACION,
        DESCRIPCION,
        ESTADO,
        EMPRESA_COD,
        USR_CREACION,
        FE_CREACION,
        USR_MODIFICACION,
        FE_MODIFICACION,
        IP_CREACION
        )
        VALUES
        (
        Pn_IdHorasSolicitud,
        Pd_Fecha,
        Pv_HoraInicio,
        Pv_HoraFin,
        Pv_observacion,
        Pv_Descripcion,
        Lv_EstadoSol,
        Pv_EmpresaCod,
        Pv_UsrCreacion,
        SYSDATE,
        NULL,
        NULL,
        NULL
        );


    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';


  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERT_SOLICITUD_HEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_INSERT_SOLICITUD_HEXTRA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  


  END P_INSERT_SOLICITUD_HEXTRA;

  PROCEDURE P_INSERT_DETA_SOLICITUD_HEXTRA(Pn_IdHorasSolicitud    IN NUMBER,
                                           Pn_TareasExtraId       IN NUMBER,
                                           Pv_HoraInicioDet       IN VARCHAR2,
                                           Pv_HoraFinDet          IN VARCHAR2,
                                           Pv_Horas               IN VARCHAR2,
                                           Pd_FechaDet            IN DATE,
                                           Pv_Observacion         IN VARCHAR2,
                                           Pv_Estado              IN VARCHAR2,
                                           Pv_usrCreacion         IN VARCHAR2,
                                           Pv_Status              OUT VARCHAR2,
                                           Pv_Mensaje             OUT VARCHAR2)

  AS
      Ln_IdHorasSolicitudDetalle     DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE.ID_HORAS_SOLICITUD_DETALLE%TYPE;
      Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;

      Lv_EstadoSol                   VARCHAR2(15); 
  BEGIN

       SELECT
            CASE
              WHEN Pv_observacion LIKE ('Origen Solicitud Job barrido de tareas por departamentos tecnica%')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS TECNICA'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
              WHEN Pv_observacion LIKE ('Origen Tarea HE Job barrido de tareas por departamentos administrativos%')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS_ADMINISTRATIVA'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )

              WHEN Pv_observacion LIKE ('Origen Tarea HE %')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO TAREA PROCESO HE'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
              WHEN Pv_observacion LIKE ('Origen Portal Planificacion HE%')
              THEN 'Verificacion'
              ELSE 'Pendiente'
            END AS ESTADO INTO Lv_EstadoSol
          FROM DUAL;     

       Ln_IdHorasSolicitudDetalle := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD_DETA.NEXTVAL;

       INSERT
        INTO DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE
        (
         ID_HORAS_SOLICITUD_DETALLE,
         HORAS_SOLICITUD_ID,
         TIPO_HORAS_EXTRA_ID,
         HORA_INICIO_DET,
         HORA_FIN_DET,
         HORAS,
         FECHA_SOLICITUD_DET,
         OBSERVACION,
         ESTADO,
         USR_CREACION,
         FE_CREACION,
         USR_MODIFICACION,
         FE_MODIFICACION,
         IP_CREACION
        )
        VALUES
        (
         Ln_IdHorasSolicitudDetalle,
         Pn_IdHorasSolicitud,
         Pn_TareasExtraId,
         Pv_HoraInicioDet,
         Pv_HoraFinDet,
         Pv_Horas,
         Pd_FechaDet,
         Pv_Observacion,
         Lv_EstadoSol,
         Pv_usrCreacion,
         SYSDATE,
         NULL,
         NULL,
         NULL
        );

      Ln_IdHorasSolicitudHistorial := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD_HISTO.NEXTVAL;
      INSERT 
       INTO DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL
       (
       ID_HORAS_SOLICITUD_HISTORIAL,
       HORAS_SOLICITUD_ID,
       TIPO_HORAS_EXTRA_ID,
       HORA_INICIO_DET,
       HORA_FIN_DET,
       HORAS,
       FECHA_SOLICITUD_DET,
       OBSERVACION,
       ESTADO,
       USR_CREACION,
       FE_CREACION,
       USR_MODIFICACION,
       FE_MODIFICACION,
       IP_CREACION
       )
       VALUES
       (
       Ln_IdHorasSolicitudHistorial,
       Pn_IdHorasSolicitud,
       Pn_TareasExtraId,
       Pv_HoraInicioDet,
       Pv_HoraFinDet,
       Pv_Horas,
       Pd_FechaDet,
       Pv_Observacion,
       Lv_EstadoSol,
       Pv_usrCreacion,
       SYSDATE,
       NULL,
       NULL,
       NULL
       );


        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERT_DETA_SOLICITUD_HEXTRA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_INSERT_DETA_SOLICITUD_HEXTRA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));                                      

  END P_INSERT_DETA_SOLICITUD_HEXTRA;


  PROCEDURE P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud IN NUMBER,
                                         Pn_TareasExtraId    IN NUMBER,
                                         Pv_HoraInicioDet    IN VARCHAR2,
                                         Pv_HoraFinDet       IN VARCHAR2,
                                         Pv_Horas            IN VARCHAR2,
                                         Pd_FechaDet         IN DATE,
                                         Pv_Observacion      IN VARCHAR2,
                                         Pv_Estado           IN VARCHAR2,
                                         Pv_usrCreacion      IN VARCHAR2,
                                         Pv_Status           OUT VARCHAR2,
                                         Pv_Mensaje          OUT VARCHAR2)

  As

       Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;

  BEGIN

               Ln_IdHorasSolicitudHistorial := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD_HISTO.NEXTVAL;
               INSERT 
                 INTO DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL
                 (
                 ID_HORAS_SOLICITUD_HISTORIAL,
                 HORAS_SOLICITUD_ID,
                 TIPO_HORAS_EXTRA_ID,
                 HORA_INICIO_DET,
                 HORA_FIN_DET,
                 HORAS,
                 FECHA_SOLICITUD_DET,
                 OBSERVACION,
                 ESTADO,
                 USR_CREACION,
                 FE_CREACION,
                 USR_MODIFICACION,
                 FE_MODIFICACION,
                 IP_CREACION
                 )
                 VALUES
                 ( 
                 Ln_IdHorasSolicitudHistorial,
                 Pn_IdHorasSolicitud,
                 Pn_TareasExtraId,
                 Pv_HoraInicioDet,
                 Pv_HoraFinDet,
                 Pv_Horas,
                 Pd_FechaDet,
                 Pv_Observacion,
                 Pv_Estado,
                 Pv_usrCreacion,
                 SYSDATE,
                 NULL,
                 NULL,
                 NULL
                 );

           COMMIT;

           Pv_Status     := 'OK';
           Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERT_HISTORIAL_SOLICITUD: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_INSERT_HISTORIAL_SOLICITUD: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

  END P_INSERT_HISTORIAL_SOLICITUD;


  PROCEDURE P_INSERTAR_TAREAS(Pn_IdHorasSolicitud IN NUMBER,
                              Pn_TareaId          IN NUMBER,
                              Pv_usrCreacion      IN VARCHAR2,
                              Pn_IdCuadrilla      IN NUMBER,
                              Pv_observacion      IN VARCHAR2,
                              Pv_Status           OUT VARCHAR2,
                              Pv_Mensaje          OUT VARCHAR2)

    AS

    Ln_IdTareasHoras DB_HORAS_EXTRAS.INFO_TAREAS_HORAS.ID_TAREAS_HORAS%TYPE;

    Lv_EstadoTarea VARCHAR2(15);

  BEGIN

  SELECT
            CASE
              WHEN Pv_observacion LIKE ('Origen Solicitud Job barrido de tareas por departamentos tecnica%')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS TECNICA'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
              WHEN Pv_observacion LIKE ('Origen Tarea HE Job barrido de tareas por departamentos administrativos%')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS_ADMINISTRATIVA'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
              WHEN Pv_observacion LIKE ('Origen Tarea HE %')
              THEN
                (SELECT PARDET.VALOR1 AS ESTADO
                FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
                WHERE PARCAB.Nombre_parametro = 'ESTADO TAREA PROCESO HE'
                AND PARDET.PARAMETRO_ID       =PARCAB.ID_PARAMETRO
                AND PARDET.DESCRIPCION        = 'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE'
                AND PARDET.ESTADO             = 'Activo'
                AND PARCAB.ESTADO             = 'Activo'
                )
              WHEN Pv_observacion LIKE ('Origen Portal Planificacion HE%')
              THEN 'Verificacion'
              ELSE 'Pendiente'
            END AS ESTADO INTO Lv_EstadoTarea
          FROM DUAL;


    Ln_IdTareasHoras := DB_HORAS_EXTRAS.SEQ_INFO_TAREAS_HORAS.NEXTVAL;
    INSERT INTO DB_HORAS_EXTRAS.INFO_TAREAS_HORAS
      (ID_TAREAS_HORAS,
       HORAS_SOLICITUD_ID,
       TAREA_ID,
       ESTADO,
       USR_CREACION,
       FE_CREACION,
       USR_MODIFICACION,
       FE_MODIFICACION,
       IP_CREACION,
       CUADRILLA_ID)
    VALUES
      (Ln_IdTareasHoras,
       Pn_IdHorasSolicitud,
       Pn_TareaId,
       Lv_EstadoTarea,
       Pv_usrCreacion,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       Pn_IdCuadrilla);

    COMMIT;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacción exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_TAREAS: - ' ||
                    SQLCODE || ' -ERROR- ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_TAREAS: ',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               USER),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));                      

   END P_INSERTAR_TAREAS;

   PROCEDURE P_INSERTAR_DOCUMENTOS(Pn_IdHorasSolicitud    IN NUMBER,
                                   Pv_NombreDocumento    IN VARCHAR2,
                                   Pv_UbicacionDocumento IN VARCHAR2,
                                   Pv_Estado             IN VARCHAR2,
                                   Pv_usrCreacion        IN VARCHAR2,
                                   Pv_Status             OUT VARCHAR2,
                                   Pv_Mensaje            OUT VARCHAR2)

    AS 

       Ln_IdDocumentoHorasExtra       DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS.ID_DOCUMENTO_HORAS_EXTRA%TYPE;
    BEGIN

       Ln_IdDocumentoHorasExtra := DB_HORAS_EXTRAS.SEQ_INFO_DOCUMENTO_HORAS_EXT.NEXTVAL;
       INSERT
       INTO DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS
       (
       ID_DOCUMENTO_HORAS_EXTRA,
       HORAS_SOLICITUD_ID,
       UBICACION_DOCUMENTO,
       NOMBRE_DOCUMENTO,
       ESTADO,
       USR_CREACION,
       FE_CREACION,
       USR_MODIFICACION,
       FE_MODIFICACION,
       IP_CREACION
       )
       VALUES
       (
       Ln_IdDocumentoHorasExtra,
       Pn_IdHorasSolicitud,
       Pv_UbicacionDocumento,
       Pv_NombreDocumento,
       Pv_Estado,
       Pv_usrCreacion,
       SYSDATE,
       NULL,
       NULL,
       NULL
       );

       COMMIT;

       Pv_Status     := 'OK';
       Pv_Mensaje    := 'Transacción exitosa';

    EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_DOCUMENTOS: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_DOCUMENTOS: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1')); 


    END P_INSERTAR_DOCUMENTOS;


    PROCEDURE P_ACTUALIZACION_GENERAL_SOLI(Pn_IdHorasSolicitud IN NUMBER,
                                           Pv_Proceso          IN VARCHAR2,
                                           Pv_Status           OUT VARCHAR2,
                                           Pv_Mensaje          OUT VARCHAR2)

    AS

      CURSOR C_OBSERVACION_SOLICITUD(Cn_IdHorasSolicitud NUMBER) IS
        SELECT IHSD.HORAS_SOLICITUD_ID,IHSD.TIPO_HORAS_EXTRA_ID,IHSD.HORA_INICIO_DET,IHSD.HORA_FIN_DET,
          IHSD.HORAS,IHSD.FECHA_SOLICITUD_DET,IHSD.OBSERVACION  
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
          WHERE IHS.ID_HORAS_SOLICITUD=Cn_IdHorasSolicitud 
          AND IHSD.FE_CREACION=(SELECT MAX(IHSDE.FE_CREACION) FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSDE
          WHERE IHSDE.HORAS_SOLICITUD_ID=Cn_IdHorasSolicitud);

      Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
      Le_Errors                      EXCEPTION;

    BEGIN



      IF Pv_Proceso = 'Anulacion' THEN

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS SET IHS.ESTADO='Anulada'
         WHERE IHS.ID_HORAS_SOLICITUD = Pn_IdHorasSolicitud AND IHS.ESTADO IN ('Pendiente','Verificacion');

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD SET IHSD.ESTADO='Anulada'
         WHERE IHSD.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IHSD.ESTADO IN ('Pendiente','Verificacion');

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE SET IHSE.ESTADO='Anulada'
         WHERE IHSE.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IHSE.ESTADO IN ('Pendiente','Verificacion');


         FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Pn_IdHorasSolicitud) 
         LOOP

            P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud,
                                         Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                         Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                         Lr_ObservacionSolicitud.HORA_FIN_DET,
                                         Lr_ObservacionSolicitud.HORAS,
                                         Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                         'Solucitud anulada',
                                         'Anulada',
                                         USER,
                                         Pv_Status,
                                         Pv_Mensaje);

                IF Pv_Status = 'ERROR' THEN
                  RAISE Le_Errors;
                END IF;

         END LOOP;


         UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH SET ITH.ESTADO='Anulada'
         WHERE ITH.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND ITH.ESTADO IN ('Pendiente','Verificacion');

         UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE SET IDHE.ESTADO='Anulada'
         WHERE IDHE.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IDHE.ESTADO IN ('Pendiente','Verificacion');   

      ELSIF Pv_Proceso = 'Procesamiento' THEN


         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS SET IHS.ESTADO='Procesada'
         WHERE IHS.ID_HORAS_SOLICITUD = Pn_IdHorasSolicitud AND IHS.ESTADO='Autorizada';

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD SET IHSD.ESTADO='Procesada'
         WHERE IHSD.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IHSD.ESTADO='Autorizada';

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE SET IHSE.ESTADO='Procesada'
         WHERE IHSE.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IHSE.ESTADO='Autorizada'; 


         FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Pn_IdHorasSolicitud) 
         LOOP

            P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud,
                                         Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                         Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                         Lr_ObservacionSolicitud.HORA_FIN_DET,
                                         Lr_ObservacionSolicitud.HORAS,
                                         Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                         'Solucitud Procesada',
                                         'Procesada',
                                         USER,
                                         Pv_Status,
                                         Pv_Mensaje);

                IF Pv_Status = 'ERROR' THEN
                  RAISE Le_Errors;
                END IF;

         END LOOP;


         UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH SET ITH.ESTADO='Procesada'
         WHERE ITH.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND ITH.ESTADO='Autorizada';

         UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE SET IDHE.ESTADO='Procesada'
         WHERE IDHE.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IDHE.ESTADO='Autorizada';   

      END IF;


      COMMIT;

      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';



    EXCEPTION
    WHEN Le_Errors THEN
       Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZACION_GENERAL_SOLI: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZACION_GENERAL_SOLI: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1')); 


    END P_ACTUALIZACION_GENERAL_SOLI;   

    PROCEDURE P_AUTORIZACION_MASIVA(Pn_IdHorasSolicitud IN NUMBER,
                                    Pv_Estado           IN VARCHAR2,
                                    Pv_NomPantalla      IN VARCHAR2,
                                    Pv_Usuario          IN VARCHAR2,
                                    Pv_EmpresaCod       IN VARCHAR2,
                                    Pv_Status           OUT VARCHAR2,
                                    Pv_Mensaje          OUT VARCHAR2)

    AS

      CURSOR C_OBSERVACION_SOLICITUD(Cn_IdHorasSolicitud NUMBER, Cv_estado VARCHAR2) IS
        SELECT IHSD.HORAS_SOLICITUD_ID,IHSD.TIPO_HORAS_EXTRA_ID,IHSD.HORA_INICIO_DET,IHSD.HORA_FIN_DET,
          IHSD.HORAS,IHSD.FECHA_SOLICITUD_DET,IHSD.OBSERVACION  
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
          WHERE IHS.ID_HORAS_SOLICITUD=Cn_IdHorasSolicitud 
          AND IHSD.FE_CREACION=(SELECT MAX(IHSDE.FE_CREACION) FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSDE
          WHERE IHSDE.HORAS_SOLICITUD_ID=Cn_IdHorasSolicitud) AND IHS.ESTADO=Cv_estado;


      Lv_Estado                      VARCHAR2(20);
      Lv_Proceso                     VARCHAR2(30);
      Lv_Observacion                 VARCHAR2(205);
      Le_Errors                      EXCEPTION;

    BEGIN

        IF C_OBSERVACION_SOLICITUD%ISOPEN THEN CLOSE C_OBSERVACION_SOLICITUD; END IF;

        IF Pv_NomPantalla = 'PreAutorizacion' THEN

           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
            SET IHS.ESTADO= ''||Pv_Estado||'',IHS.USR_MODIFICACION=Pv_Usuario, IHS.FE_MODIFICACION =SYSDATE
           WHERE IHS.ID_HORAS_SOLICITUD=''||Pn_IdHorasSolicitud AND IHS.ESTADO IN ('Pendiente','Verificacion');

           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE
            SET IHSE.ESTADO= ''||Pv_Estado||'', IHSE.USR_MODIFICACION=Pv_Usuario, IHSE.FE_MODIFICACION = SYSDATE
           WHERE IHSE.HORAS_SOLICITUD_ID=''|| Pn_IdHorasSolicitud AND IHSE.ESTADO IN ('Pendiente','Verificacion');

           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD
            SET IHSD.ESTADO=''||Pv_Estado||'', IHSD.USR_MODIFICACION=Pv_Usuario, IHSD.FE_MODIFICACION = SYSDATE
           WHERE IHSD.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND IHSD.ESTADO IN ('Pendiente','Verificacion');


           FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Pn_IdHorasSolicitud,Pv_Estado) 
           LOOP


                 P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud,
                                              Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                              Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                              Lr_ObservacionSolicitud.HORA_FIN_DET,
                                              Lr_ObservacionSolicitud.HORAS,
                                              Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                              Lr_ObservacionSolicitud.OBSERVACION,
                                              Pv_Estado,
                                              Pv_Usuario,
                                              Pv_Status,
                                              Pv_Mensaje);

                Lv_Observacion:=Lr_ObservacionSolicitud.OBSERVACION;

                IF Pv_Status = 'ERROR' THEN
                  RAISE Le_Errors;
                END IF;

           END LOOP;

           UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH
            SET ITH.ESTADO=''||Pv_Estado||'', ITH.USR_MODIFICACION=Pv_Usuario, ITH.FE_MODIFICACION = SYSDATE
           WHERE ITH.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND ITH.ESTADO IN ('Pendiente','Verificacion');

           UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE
            SET IDHE.ESTADO=''||Pv_Estado||'', IDHE.USR_MODIFICACION=Pv_Usuario, IDHE.FE_MODIFICACION = SYSDATE
           WHERE IDHE.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND IDHE.ESTADO IN ('Pendiente','Verificacion');


           P_ENVIAR_MAIL_GENERAL(Pv_NomPantalla,
                                 Pv_EmpresaCod,
                                 Pn_IdHorasSolicitud,
                                 Lv_Observacion);

        ELSE

           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
            SET IHS.ESTADO= ''||Pv_Estado||'', IHS.USR_MODIFICACION=Pv_Usuario, IHS.FE_MODIFICACION = SYSDATE
           WHERE IHS.ID_HORAS_SOLICITUD=''||Pn_IdHorasSolicitud AND ESTADO='Pre-Autorizada';

           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE
            SET IHSE.ESTADO= ''||Pv_Estado||'', IHSE.USR_MODIFICACION=Pv_Usuario, IHSE.FE_MODIFICACION = SYSDATE
           WHERE IHSE.HORAS_SOLICITUD_ID=''||Pn_IdHorasSolicitud AND ESTADO='Pre-Autorizada';

           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD
            SET IHSD.ESTADO=''||Pv_Estado||'', IHSD.USR_MODIFICACION=Pv_Usuario, IHSD.FE_MODIFICACION = SYSDATE
           WHERE IHSD.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND ESTADO='Pre-Autorizada';

           FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Pn_IdHorasSolicitud,Pv_Estado) 
           LOOP

               P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud,
                                              Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                              Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                              Lr_ObservacionSolicitud.HORA_FIN_DET,
                                              Lr_ObservacionSolicitud.HORAS,
                                              Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                              Lr_ObservacionSolicitud.OBSERVACION,
                                              Pv_Estado,
                                              Pv_Usuario,
                                              Pv_Status,
                                              Pv_Mensaje);


                IF Pv_Status = 'ERROR' THEN
                  RAISE Le_Errors;
                END IF;


           END LOOP;


           UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH
            SET ITH.ESTADO=''||Pv_Estado||'', ITH.USR_MODIFICACION=Pv_Usuario, ITH.FE_MODIFICACION = SYSDATE
           WHERE ITH.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND ESTADO='Pre-Autorizada';

           UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE
            SET IDHE.ESTADO=''||Pv_Estado||'', IDHE.USR_MODIFICACION=Pv_Usuario, IDHE.FE_MODIFICACION= SYSDATE
           WHERE IDHE.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND ESTADO='Pre-Autorizada';


        END IF;

        COMMIT;

        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';

    EXCEPTION
    WHEN Le_Errors THEN
       Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_AUTORIZACION_MASIVA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_AUTORIZACION_MASIVA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

    END P_AUTORIZACION_MASIVA;


    PROCEDURE P_INSERTAR_EMPLEADOS(Pn_IdHorasSolicitud IN NUMBER,
                                   Pn_NoEmple          IN NUMBER,
                                   Pv_Estado           IN VARCHAR2,
                                   Pv_UsrCreacion      IN VARCHAR2,
                                   Pv_Status           OUT VARCHAR2,
                                   Pv_Mensaje          OUT VARCHAR2)

    AS

      Ln_IdHorasSolicitudEmpleado   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO.ID_HORAS_SOLICITUD_EMPLEADO%TYPE;
      Le_Errors                     EXCEPTION;

    BEGIN                               

       Ln_IdHorasSolicitudEmpleado := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD_EMPLE.NEXTVAL;
       INSERT
       INTO DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO
       (
       ID_HORAS_SOLICITUD_EMPLEADO,
       HORAS_SOLICITUD_ID,
       NO_EMPLE,
       ESTADO,
       USR_CREACION,
       FE_CREACION,
       USR_MODIFICACION,
       FE_MODIFICACION,
       IP_CREACION
       )
       VALUES
       (
       Ln_IdHorasSolicitudEmpleado,
       Pn_IdHorasSolicitud,
       Pn_NoEmple,
       Pv_Estado,
       Pv_usrCreacion,
       SYSDATE,
       NULL,
       NULL,
       NULL
       );

       Pv_Status     := 'OK';
       Pv_Mensaje    := 'Transacción exitosa';



    EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_EMPLEADOS: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_EMPLEADOS: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));


    END P_INSERTAR_EMPLEADOS;


    PROCEDURE P_AUTORIZACION_POR_DEPTO(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2)


    AS
        Lv_EmpresaCod          VARCHAR2(2);
        Lv_NombreDpto          VARCHAR2(60);
        Lv_nombrePantalla      VARCHAR2(20):='Autorizacion';
        Lv_Estado              VARCHAR2(10):='Autorizada';
        Lv_NombreArea          VARCHAR2(35);
        Lv_Area                VARCHAR2(2);
        Lv_Usuario             VARCHAR2(25);
        Lv_EsSuperUsuario      VARCHAR2(25);
        Ln_Cantidad            NUMBER;
        Ld_FechaCorte          DATE;
        Ld_FechaActual         DATE;
        Le_Errors              EXCEPTION;


        CURSOR C_SOLICITUDES_DEPARTAMENTO(Cv_Departamento VARCHAR2,
                                          Cv_EmpresaCod   VARCHAR2,
                                          Cn_Cantidad     NUMBER) IS
         SELECT DISTINCT IHS.ID_HORAS_SOLICITUD
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS
           JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
           JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE= IHSE.NO_EMPLE
          WHERE IHS.ESTADO='Pre-Autorizada' AND IHS.EMPRESA_COD=Cv_EmpresaCod AND VEE.NO_CIA=Cv_EmpresaCod
           AND VEE.TIPO_EMP NOT IN('03')
           AND TO_CHAR(TO_DATE(IHS.FECHA,'DD-MM-YY'),'MM-YYYY') =TO_CHAR(ADD_MONTHS(SYSDATE,Cn_Cantidad),'MM-YYYY')
           AND VEE.NOMBRE_DEPTO=Cv_Departamento;

        CURSOR C_EXISTE_AREA(Cv_Area VARCHAR2) IS
          SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='LISTADO_AREAS_HE')
          AND VALOR1=Cv_Area;

        CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
          SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
          WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_CONSULTA';


          Lr_Valor1               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
          Lr_Valor_1              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE; 

    BEGIN

         -- RETORNO LAS VARIABLES DEL REQUEST
         APEX_JSON.PARSE(Pcl_Request);
         Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
         Lv_NombreDpto          := APEX_JSON.get_varchar2(p_path => 'nombreDpto');
         Lv_Usuario             := APEX_JSON.get_varchar2(p_path => 'usuario');
         Lv_NombreArea          := APEX_JSON.get_varchar2(p_path => 'nombreArea');
         Lv_Area                := APEX_JSON.get_varchar2(p_path => 'area');
         Lv_EsSuperUsuario      := APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');

         IF Lv_Area IS NOT NULL AND Lv_NombreArea IS NULL THEN

            SELECT DESCRI
             INTO Lv_NombreArea
             FROM NAF47_TNET.ARPLAR 
            WHERE AREA=Lv_Area AND NO_CIA=Lv_EmpresaCod;

         END IF;


         IF C_EXISTE_AREA%ISOPEN THEN
             CLOSE C_EXISTE_AREA;
         END IF;


         OPEN C_EXISTE_AREA(Lv_nombreArea);
         FETCH C_EXISTE_AREA INTO Lr_valor1;

         IF C_EXISTE_AREA%NOTFOUND THEN  
             Pv_Mensaje := 'No se puede autorizar solicitudes para el area'||' '||Lv_nombreArea;
             RAISE Le_Errors;
         END IF;

         CLOSE C_EXISTE_AREA;

         --- DIA DE CORTE 
         IF C_DIA_CORTE%ISOPEN THEN
            CLOSE C_DIA_CORTE;
         END IF;

         OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
         FETCH C_DIA_CORTE INTO Lr_Valor_1;


         IF C_DIA_CORTE%FOUND THEN  

            SELECT TO_DATE(Lr_Valor_1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
              INTO Ld_FechaCorte
            FROM DUAL;           

         END IF;

         CLOSE C_DIA_CORTE;

         Ld_FechaActual:= SYSDATE;


         IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY'))THEN

           Ln_Cantidad:=0;

         ELSE

          Ln_Cantidad:=-1;

         END IF;


         IF C_SOLICITUDES_DEPARTAMENTO%ISOPEN THEN CLOSE C_SOLICITUDES_DEPARTAMENTO; END IF;

         FOR Lr_Solicitudes IN C_SOLICITUDES_DEPARTAMENTO(Lv_NombreDpto,Lv_EmpresaCod,Ln_Cantidad)LOOP

             P_AUTORIZACION_MASIVA(Lr_Solicitudes.ID_HORAS_SOLICITUD,
                                   Lv_Estado,
                                   Lv_nombrePantalla,
                                   Lv_Usuario,
                                   Lv_EmpresaCod,
                                   Pv_Status,
                                   Pv_Mensaje);


             IF Pv_Status = 'ERROR' THEN
                RAISE Le_Errors;
             END IF;

         END LOOP;

         Pv_Status     := 'OK';
         Pv_Mensaje    := 'Transacción exitosa';

    EXCEPTION
    WHEN Le_Errors THEN
       Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_AUTORIZACION_POR_DEPTO: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_AUTORIZACION_POR_DEPTO: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

    END P_AUTORIZACION_POR_DEPTO;

    PROCEDURE P_ENVIO_MAIL_HE(Pv_EmpresaCod IN VARCHAR2,
                              Pv_Remitente  IN VARCHAR2,
                              Pv_Asunto     IN VARCHAR2)


    AS

            CURSOR C_SOLICITUDES_AUTORIZADAS(Cv_empresaCod VARCHAR2) IS
                SELECT VEE.NOMBRE,IHS.FECHA FECHA_SOLICITUD,
                     IHS.HORA_INICIO,IHS.HORA_FIN,
                     IHS.OBSERVACION,IHS.ESTADO,IHS.USR_CREACION,VEE.MAIL_CIA 
                  FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                    JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                    JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
                  WHERE IHS.ESTADO='Autorizada' AND TO_CHAR(IHS.FE_MODIFICACION,'DD-MM-YYYY')= TO_CHAR(SYSDATE,'DD-MM-YYYY') AND IHS.EMPRESA_COD=Cv_empresaCod
                    AND VEE.NO_CIA=Cv_empresaCod;

         Lv_Cuerpo           VARCHAR2(9999);
         Pv_Status           VARCHAR2(1000);
         Pv_Mensaje          VARCHAR2(1000);


    BEGIN

          IF C_SOLICITUDES_AUTORIZADAS%ISOPEN THEN
               CLOSE C_SOLICITUDES_AUTORIZADAS;
          END IF;

          FOR Lr_Solicitudes IN C_SOLICITUDES_AUTORIZADAS(Pv_EmpresaCod) LOOP

               Lv_Cuerpo := '<html>
                                 <head>
                                     <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
                                 </head>
                                 <body>
                                         <table align="center" width="100%" cellspacing="0" cellpadding="5">
                                             <tr>
                                                <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                                                   <img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo-tn.png"/>
                                                </td>
                                             </tr>
                                             <tr>
                                                <td style="border:1px solid #6699CC;">
                                                   <table width="100%" cellspacing="0" cellpadding="5">
                                                       <tr>
                                                          <td colspan="2">
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"></span></span></p>
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                               Estimado colaborador(a), el presente es para informarle que su solicitud de horas extra ha sido autorizada</span></span></p>

                                                                <table border="1px">
                                                                     <thead>
                                                                         <tr>
		                                                                       <th>Nombres</th>
		                                                                       <th>Fecha Solicitud</th> 
                                                                           <th>Hora Inicio</th>
                                                                           <th>Hora Fin</th>
		                                                                       <th>Observacion</th>
                                                                           <th>Estado</th>
                                                                           <th>Usuario Creacion</th> 
		                                                                     </tr>
		                                                                  </thead>
                                                                      <tbody>
                                                                          <tr>
                                                                              <td>'||Lr_Solicitudes.NOMBRE||'</td>
                                                                              <td>'||Lr_Solicitudes.FECHA_SOLICITUD||'</td>
                                                                              <td>'||Lr_Solicitudes.HORA_INICIO||'</td>
                                                                              <td>'||Lr_Solicitudes.HORA_FIN||'</td>
                                                                              <td>'||Lr_Solicitudes.OBSERVACION||'</td>
                                                                              <td>'||Lr_Solicitudes.ESTADO||'</td>
                                                                              <td>'||Lr_Solicitudes.USR_CREACION||'</td>
                                                                          </tr>
                                                                       </tbody>
                                                                </table>
                                                                    <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                                   <strong>Nota:</strong> Este correo es un seguimiento informativo de la solicitud registrada.</span></span></p>
                                                          </td>
                                                       </tr>
                                                   </table>
                                                </td>
                                             </tr>
                                         </table>
                                 </body>
                             </html>';


                            UTL_MAIL.SEND(
                                  SENDER       => Pv_Remitente,
                                  RECIPIENTS   => Lr_Solicitudes.MAIL_CIA,
                                  SUBJECT      => Pv_Asunto,
                                  MESSAGE      => Lv_Cuerpo,
                                  MIME_TYPE    => 'text/html; charset=UTF-8'
                             );



          END LOOP;                   

    EXCEPTION
    WHEN OTHERS THEN
            Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ENVIO_MAIL_HE: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ENVIO_MAIL_HE: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));


    END P_ENVIO_MAIL_HE;


    PROCEDURE P_REPORTE_AUTORIZACIONES(Pv_EmpresaCod IN VARCHAR2,
                                       Pv_Remitente  IN VARCHAR2,
                                       Pv_Asunto     IN VARCHAR2)


    AS

                CURSOR C_REPORTE_SOLICITUDES_DET(Cv_EmpresaCod VARCHAR2) IS
                  SELECT VEE.CEDULA, VEE.NOMBRE,
                         IHSD.FECHA_SOLICITUD_DET FECHA, 
                         (CASE WHEN REPLACE(REPLACE(IHS.OBSERVACION,CHR(10),''),';','.') IS NULL THEN '-'
                          WHEN REPLACE(REPLACE(IHS.OBSERVACION,CHR(10),''),';','.') IS NOT NULL THEN REPLACE(REPLACE(IHS.OBSERVACION,CHR(10),' '),';','.')
                          ELSE '--' END)OBSERVACION,
                          IHSD.HORA_INICIO_DET HORA_INICIO, 
                         IHSD.HORA_FIN_DET HORA_FIN,IHSD.HORAS, ATHE.TIPO_HORAS_EXTRA,VEE.NOMBRE_DEPTO,VEE.OFICINA_PROVINCIA NOMBRE_PROVINCIA,VEE.OFICINA_CANTON NOMBRE_CANTON,
                         (SELECT MIN(ihsde.horas_solicitud_id)
                             FROM db_horas_extras.info_horas_solicitud ihso
                               JOIN db_horas_extras.info_horas_solicitud_detalle ihsde ON ihsde.horas_solicitud_id = ihso.id_horas_solicitud
                               JOIN db_horas_extras.info_horas_solicitud_empleado ihsem ON ihsem.horas_solicitud_id   = ihso.id_horas_solicitud
                              WHERE ihsem.no_emple = ihse.no_emple AND ihsde.fecha_solicitud_det = ihsd.fecha_solicitud_det
                               AND ihsde.hora_inicio_det = ihsd.hora_inicio_det AND ihsde.hora_fin_det = ihsd.hora_fin_det) ID_HORAS_SOLICITUD
                       FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON IHSE.NO_EMPLE = VEE.NO_EMPLE AND IHS.EMPRESA_COD = VEE.NO_CIA
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                       WHERE IHS.EMPRESA_COD=Cv_EmpresaCod
                          AND TO_CHAR(TO_DATE(IHS.FECHA,'DD-MM-YY'),'MM-YYYY') =TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM-YYYY')
                          AND IHS.ESTADO='Autorizada' AND IHSE.ESTADO='Autorizada' AND IHSD.ESTADO='Autorizada'
                          AND VEE.TIPO_EMP NOT IN('03')
                       GROUP BY vee.cedula,vee.nombre,ihsd.fecha_solicitud_det,ihsd.hora_inicio_det,ihsd.hora_fin_det,
                                ihsd.horas,ihs.observacion,athe.tipo_horas_extra,vee.nombre_depto,vee.oficina_provincia,
                                vee.oficina_canton,ihse.no_emple
                       ORDER BY VEE.NOMBRE_DEPTO,VEE.NOMBRE;


                CURSOR C_REPORTE_SOLICITUDES_DET_B(Cv_EmpresaCod VARCHAR2) IS
                  SELECT VEE.CEDULA, VEE.NOMBRE,
                         IHSD.FECHA_SOLICITUD_DET FECHA, 
                         (CASE WHEN REPLACE(REPLACE(IHS.OBSERVACION,CHR(10),''),';','.') IS NULL THEN '-'
                          WHEN REPLACE(REPLACE(IHS.OBSERVACION,CHR(10),''),';','.') IS NOT NULL THEN REPLACE(REPLACE(IHS.OBSERVACION,CHR(10),' '),';','.')
                          ELSE '--' END)OBSERVACION,
                          IHSD.HORA_INICIO_DET HORA_INICIO, 
                         IHSD.HORA_FIN_DET HORA_FIN,IHSD.HORAS, ATHE.TIPO_HORAS_EXTRA,VEE.NOMBRE_DEPTO,VEE.OFICINA_PROVINCIA NOMBRE_PROVINCIA,VEE.OFICINA_CANTON NOMBRE_CANTON,
                         (SELECT MIN(ihsde.horas_solicitud_id)
                             FROM db_horas_extras.info_horas_solicitud ihso
                               JOIN db_horas_extras.info_horas_solicitud_detalle ihsde ON ihsde.horas_solicitud_id = ihso.id_horas_solicitud
                               JOIN db_horas_extras.info_horas_solicitud_empleado ihsem ON ihsem.horas_solicitud_id   = ihso.id_horas_solicitud
                              WHERE ihsem.no_emple = ihse.no_emple AND ihsde.fecha_solicitud_det = ihsd.fecha_solicitud_det
                               AND ihsde.hora_inicio_det = ihsd.hora_inicio_det AND ihsde.hora_fin_det = ihsd.hora_fin_det) ID_HORAS_SOLICITUD
                       FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON IHSE.NO_EMPLE = VEE.NO_EMPLE AND IHS.EMPRESA_COD = VEE.NO_CIA
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                       WHERE IHS.EMPRESA_COD=Cv_EmpresaCod
                          AND TO_CHAR(TO_DATE(IHS.FECHA,'DD-MM-YY'),'MM-YYYY') =TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM-YYYY')
                          AND IHS.ESTADO='Autorizada' AND IHSE.ESTADO='Autorizada' AND IHSD.ESTADO='Autorizada'
                          AND VEE.TIPO_EMP NOT IN('03')
                       GROUP BY vee.cedula,vee.nombre,ihsd.fecha_solicitud_det,ihsd.hora_inicio_det,ihsd.hora_fin_det,
                                ihsd.horas,ihs.observacion,athe.tipo_horas_extra,vee.nombre_depto,vee.oficina_provincia,
                                vee.oficina_canton,ihse.no_emple
                       ORDER BY VEE.NOMBRE_DEPTO,VEE.NOMBRE;

              CURSOR C_SOLICITUDES_PENDIENTES IS
                  SELECT IHS.ID_HORAS_SOLICITUD
                     FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS
                    WHERE TO_CHAR(IHS.FECHA,'MM-YYYY')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM-YYYY')
                     AND ESTADO IN ('Pendiente','Verificacion');

               CURSOR C_CORREO_DESTINATARIO(Cv_EmpresaCod VARCHAR2)IS
                 SELECT APD.VALOR1 
                   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
                  WHERE APD.PARAMETRO_ID=(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CORREO_DESTINATARIO_HE')
                   AND APD.EMPRESA_COD=Cv_EmpresaCod AND APD.ESTADO='Activo';


               CURSOR C_RUTA_DIRECTORIO(Cv_EmpresaCod VARCHAR2)IS
                 SELECT APD.VALOR1 
                   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
                  WHERE APD.PARAMETRO_ID=(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PATH_DIRECTORIO_HE')
                   AND APD.EMPRESA_COD=Cv_EmpresaCod AND APD.ESTADO='Activo';


                   Lv_Directorio            VARCHAR2(50):= 'DIR_REPHEXTRAS';
                   Lv_Delimitador           VARCHAR2(1):= ';';
                   Lv_Remitente             VARCHAR2(100):= Pv_Remitente; 
                   Lv_Asunto                VARCHAR2(300):= Pv_Asunto;
                   Lv_Cuerpo                VARCHAR2(9999); 
                   Lv_CuerpoB               VARCHAR2(9999); 
                   Lv_FechaReporte          VARCHAR2(50):=TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
                   Lr_Valor1                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
                   Lr_RutaDirectorio        DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
                   Lv_NombreArchivo         VARCHAR2(150);
                   Lv_NombreArchivoZip      VARCHAR2(250);
                   Lv_NombreArchivoRsZip    VARCHAR2(250);
                   Lv_NombreArchivoRs       VARCHAR2(250);
                   Lv_Gzip                  VARCHAR2(100);
                   Lv_GzipRs                VARCHAR2(100);
                   Lv_MsjResultado          VARCHAR2(2000);
                   Lv_Estado                VARCHAR2(50);
                   Lv_Mensaje               VARCHAR2(1000);
                   Ln_Contador              NUMBER:=1;
                   Lv_Nombres               VARCHAR2(40);
                   Ln_Segundos              NUMBER:=0;
                   Ln_SegundosB             NUMBER:=0;
                   Lv_TotalHoras            VARCHAR2(10);
                   Lfile_ArchivoRs          UTL_FILE.FILE_TYPE;
                   Lfile_Archivo            UTL_FILE.FILE_TYPE;
                   Pv_Status                VARCHAR2(1000);
                   Pv_Mensaje               VARCHAR2(1000);
                   Le_Errors                EXCEPTION;


    BEGIN

                  IF C_REPORTE_SOLICITUDES_DET%ISOPEN THEN
                        CLOSE C_REPORTE_SOLICITUDES_DET;
                  END IF;

                  IF C_REPORTE_SOLICITUDES_DET_B%ISOPEN THEN
                        CLOSE C_REPORTE_SOLICITUDES_DET_B;
                  END IF;


                  IF C_SOLICITUDES_PENDIENTES%ISOPEN THEN
                         CLOSE C_SOLICITUDES_PENDIENTES;
                  END IF;

                  IF C_CORREO_DESTINATARIO%ISOPEN THEN
                         CLOSE C_CORREO_DESTINATARIO;
                  END IF;

                  IF C_RUTA_DIRECTORIO%ISOPEN THEN
                         CLOSE C_RUTA_DIRECTORIO;
                  END IF;


                  OPEN C_CORREO_DESTINATARIO(Pv_EmpresaCod);
                  FETCH C_CORREO_DESTINATARIO INTO Lr_valor1;


                  -- REPORTE DETALLADO
                  Lv_Cuerpo := '<html>
                                 <head>
                                     <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
                                 </head>
                                 <body>
                                         <table align="center" width="100%" cellspacing="0" cellpadding="5">
                                             <tr>
                                                <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                                                   <img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo-tn.png"/>
                                                </td>
                                             </tr>
                                             <tr>
                                                <td style="border:1px solid #6699CC;">
                                                   <table width="100%" cellspacing="0" cellpadding="5">
                                                       <tr>
                                                          <td colspan="2">
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"></span></span></p>
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                               Estimados(as), mediante este correo se adjunta el reporte detallado de las solicitudes autorizadas  </span></span></p>

                                                          </td>
                                                       </tr>
                                                   </table>
                                                </td>
                                             </tr>
                                         </table>
                                 </body>
                             </html>';
                    -- REPORTE DETALLADO

                  Lv_CuerpoB := '<html>
                                 <head>
                                     <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
                                 </head>
                                 <body>
                                         <table align="center" width="100%" cellspacing="0" cellpadding="5">
                                             <tr>
                                                <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                                                   <img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo-tn.png"/>
                                                </td>
                                             </tr>
                                             <tr>
                                                <td style="border:1px solid #6699CC;">
                                                   <table width="100%" cellspacing="0" cellpadding="5">
                                                       <tr>
                                                          <td colspan="2">
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"></span></span></p>
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                               Estimados(as), mediante este correo se adjunta el reporte resumido de las solicitudes autorizadas  </span></span></p>

                                                          </td>
                                                       </tr>
                                                   </table>
                                                </td>
                                             </tr>
                                         </table>
                                 </body>
                             </html>';

                    OPEN C_RUTA_DIRECTORIO(Pv_EmpresaCod);
                    FETCH C_RUTA_DIRECTORIO INTO Lr_RutaDirectorio;  

                    IF C_RUTA_DIRECTORIO%FOUND THEN 


                      Lv_NombreArchivo     := 'ReporteSolicitudesDetalladoHE_'||Lv_FechaReporte||'.csv';
                      Lv_Gzip              := Lr_RutaDirectorio||Lv_NombreArchivo;
                      Lv_NombreArchivoZip  := Lv_NombreArchivo;
                      Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',32767);


                  --
                      utl_file.put_line(Lfile_Archivo,'CEDULA'                    ||Lv_Delimitador
                                                    ||'NOMBRES'                   ||Lv_Delimitador
                                                    ||'FECHA'                     ||Lv_Delimitador
                                                    ||'NUMERO SOLICITUD'          ||Lv_Delimitador
                                                    ||'HORA INICIO'               ||Lv_Delimitador
                                                    ||'HORA FIN'                  ||Lv_Delimitador
                                                    ||'HORAS'                     ||Lv_Delimitador
                                                    ||'TIPO HORAS EXTRA'          ||Lv_Delimitador
                                                    ||'DEPARTAMENTO'              ||Lv_Delimitador
                                                    ||'PROVINCIA'                 ||Lv_Delimitador
                                                    ||'CANTON'                    ||Lv_Delimitador
                                                    ||'OBSERVACION'               ||Lv_Delimitador);


                          FOR Lr_ReporteSolicitudes IN C_REPORTE_SOLICITUDES_DET(Pv_EmpresaCod) LOOP

                                       UTL_FILE.PUT_LINE(Lfile_Archivo,
                                               NVL(Lr_ReporteSolicitudes.CEDULA, '')                 ||Lv_Delimitador
                                              ||NVL(Lr_ReporteSolicitudes.NOMBRE, '')                ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.FECHA, '')                  ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.ID_HORAS_SOLICITUD, 0)      ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.HORA_INICIO, '')            ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.HORA_FIN, '')               ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.HORAS, '')                  ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.TIPO_HORAS_EXTRA, '')       ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.NOMBRE_DEPTO, '')           ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.NOMBRE_PROVINCIA, '')       ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.NOMBRE_CANTON, '')          ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.OBSERVACION, '')            ||Lv_Delimitador
                                        );


                           END LOOP;


                           UTL_FILE.fclose(Lfile_Archivo);

                         --  dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 

                           --REPORTE_SOLICITUDES_RESUMIDO

                       Lv_NombreArchivoRs     := 'ReporteSolicitudesResumidoHE_'||Lv_FechaReporte||'.csv';
                       Lv_GzipRs              := Lr_RutaDirectorio||Lv_NombreArchivoRs;
                       Lv_NombreArchivoRsZip  := Lv_NombreArchivoRs;
                       Lfile_ArchivoRs        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivoRs,'w',32767);
                     --
                       utl_file.put_line(Lfile_ArchivoRs,'CEDULA'          ||Lv_Delimitador
                                               ||'NOMBRE'                  ||Lv_Delimitador
                                               ||'TOTAL HORAS MES'         ||Lv_Delimitador
                                               ||'DEPARTAMENTO'            ||Lv_Delimitador
                                               ||'PROVINCIA'               ||Lv_Delimitador
                                               ||'CANTON'                  ||Lv_Delimitador);



                        FOR Lr_ReporteSolicitudes IN C_REPORTE_SOLICITUDES_DET(Pv_EmpresaCod) LOOP


                                  IF(Lv_Nombres != Lr_ReporteSolicitudes.NOMBRE OR Ln_Contador=1)THEN


                                        FOR Lr_ReporteSolicitudesB IN C_REPORTE_SOLICITUDES_DET_B(Pv_EmpresaCod) LOOP
                                              IF(Lr_ReporteSolicitudesB.NOMBRE=Lr_ReporteSolicitudes.NOMBRE)THEN
                                                 SELECT REGEXP_SUBSTR(Lr_ReporteSolicitudesB.HORAS,'[^:]+',1,1)*60*60 + REGEXP_SUBSTR(Lr_ReporteSolicitudesB.HORAS,'[^:]+',1,2)*60 
                                                   INTO Ln_Segundos from dual;

                                                   Ln_SegundosB:=Ln_SegundosB+Ln_Segundos;

                                              END IF;

                                        END LOOP;

                                        SELECT TO_CHAR(TRUNC((Ln_SegundosB)/3600),'FM9900') || ':' ||TO_CHAR(TRUNC(MOD((Ln_SegundosB),3600)/60),'FM00') INTO Lv_totalHoras
                                               FROM DUAL;


                                       UTL_FILE.PUT_LINE(Lfile_ArchivoRs,
                                                NVL(Lr_ReporteSolicitudes.CEDULA, '')            ||Lv_Delimitador
                                              ||NVL(Lr_ReporteSolicitudes.NOMBRE, '')            ||Lv_Delimitador
                                              ||NVL(Lv_totalHoras, '')                           ||Lv_Delimitador
                                              ||NVL(Lr_ReporteSolicitudes.NOMBRE_DEPTO, '')      ||Lv_Delimitador
                                              ||NVL(Lr_ReporteSolicitudes.NOMBRE_PROVINCIA, '')  ||Lv_Delimitador
                                              ||NVL(Lr_ReporteSolicitudes.NOMBRE_CANTON, '')     ||Lv_Delimitador
                                       );


                                        Ln_Segundos:=0;
                                        Ln_SegundosB:=0;
                                  END IF;

                                  Lv_Nombres:= Lr_ReporteSolicitudes.NOMBRE;
                                  Ln_Contador:=Ln_Contador+1;
                       END LOOP;

                       UTL_FILE.fclose(Lfile_ArchivoRs);

                     --  dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_GzipRs) ) ; 

                    END IF;

                     IF C_CORREO_DESTINATARIO%FOUND THEN  

                          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                                    Lr_Valor1,
                                                                    Lv_Asunto, 
                                                                    Lv_Cuerpo, 
                                                                    Lv_Directorio,
                                                                    Lv_NombreArchivoZip);

                          UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

                          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                                    Lr_Valor1,
                                                                    Lv_Asunto, 
                                                                    Lv_CuerpoB, 
                                                                    Lv_Directorio,
                                                                    Lv_NombreArchivoRsZip);

                          UTL_FILE.FREMOVE(Lv_Directorio,Lv_NombreArchivoRsZip);


                     END IF;




                  CLOSE C_CORREO_DESTINATARIO;


                  FOR Ln_SolicitudesPendientes IN C_SOLICITUDES_PENDIENTES 
                  LOOP


                       DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZACION_GENERAL_SOLI(Ln_SolicitudesPendientes.ID_HORAS_SOLICITUD,
                                                                                                 'Anulacion',
                                                                                                 Pv_Status,
                                                                                                 Pv_Mensaje);

                       IF Lv_Estado = 'ERROR' THEN
                                  RAISE Le_Errors;
                       END IF;

                  END LOOP;

                  FOR Lr_ProcesamientoSolicitudes IN C_REPORTE_SOLICITUDES_DET(Pv_EmpresaCod) LOOP


                      DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZACION_GENERAL_SOLI(Lr_ProcesamientoSolicitudes.ID_HORAS_SOLICITUD,
                                                                                                'Procesamiento',
                                                                                                Pv_Status,
                                                                                                Pv_Mensaje);

                       IF Lv_Estado = 'ERROR' THEN
                                  RAISE Le_Errors;
                       END IF;

                  END LOOP;






    EXCEPTION
    WHEN Le_Errors THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_REPORTE_AUTORIZACIONES: ',
                                                 Lv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

    WHEN OTHERS THEN
            Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_REPORTE_AUTORIZACIONES: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_REPORTE_AUTORIZACIONES: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));


    END P_REPORTE_AUTORIZACIONES;

    PROCEDURE P_ENVIAR_MAIL_GENERAL(Pv_Proceso          IN VARCHAR2,
                                    Pv_EmpresaCod       IN VARCHAR2,
                                    Pn_IdHorasSolicitud IN NUMBER,
                                    Pv_Observacion      IN VARCHAR2)

    AS

       CURSOR C_INFORMACION_SOLICITUD(Cv_EmpresaCod VARCHAR2,Pn_IdHorasSolicitud NUMBER, Cv_Estado1 VARCHAR2,Cv_Estado2 VARCHAR2,Cv_Estado3 VARCHAR2) IS
            SELECT VEE.NOMBRE,IHS.FECHA FECHA_SOLICITUD,
                IHS.HORA_INICIO,IHS.HORA_FIN,
                IHS.OBSERVACION,IHS.ESTADO,IHS.USR_CREACION,VEE.MAIL_CIA 
             FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
              JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
             WHERE IHS.EMPRESA_COD=Cv_EmpresaCod
              AND VEE.NO_CIA=Cv_EmpresaCod AND IHS.ID_HORAS_SOLICITUD=Pn_IdHorasSolicitud AND IHS.ESTADO IN(Cv_Estado1,Cv_Estado2,Cv_Estado3);


       CURSOR C_CORREO_REMITENTE(Cv_EmpresaCod VARCHAR2)IS
           SELECT APD.VALOR1 
            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID=(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CORREO_GERENCIAL_HE')
            AND APD.EMPRESA_COD=Cv_EmpresaCod AND APD.ESTADO='Activo';



        Lv_Cuerpo             VARCHAR2(9999);
        Pv_Status             VARCHAR2(1000);
        Lv_Estado1            VARCHAR2(20):='';
        Lv_Estado2            VARCHAR2(20):='';
        Lv_Estado3            VARCHAR2(20):='';
        Lv_EstadoSolicitud    VARCHAR2(20);
        Lr_Valor1             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
        Lv_Asunto             VARCHAR2(50):='Reporte de Solicitud de horas extras	';
        Pv_Mensaje            VARCHAR2(1000);
        Le_Errors             EXCEPTION;

    BEGIN

        IF C_INFORMACION_SOLICITUD%ISOPEN THEN
               CLOSE C_INFORMACION_SOLICITUD;
        END IF;

        IF C_CORREO_REMITENTE%ISOPEN THEN
               CLOSE C_CORREO_REMITENTE;
        END IF;


        OPEN C_CORREO_REMITENTE(Pv_EmpresaCod);
        FETCH C_CORREO_REMITENTE INTO Lr_valor1;       

        IF (Pv_Proceso='Anulacion')THEN
          Lv_Estado1:='Pendiente';
          Lv_Estado2:='Pre-Autorizada';
          Lv_Estado3:='Verificacion';
          Lv_EstadoSolicitud:='Anulada';

        ELSIF (Pv_Proceso='PreAutorizacion') THEN
          Lv_Estado1:='Pendiente';
          Lv_Estado2:='';
          Lv_Estado3:='Verificacion';
          Lv_EstadoSolicitud:='Pre-Autorizada';

        END IF;

        FOR Lr_InfoSolicitud IN C_INFORMACION_SOLICITUD(Pv_EmpresaCod,Pn_IdHorasSolicitud,Lv_Estado1,Lv_Estado2,Lv_Estado3) LOOP

               Lv_Cuerpo := '<html>
                                 <head>
                                     <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
                                 </head>
                                 <body>
                                         <table align="center" width="100%" cellspacing="0" cellpadding="5">
                                             <tr>
                                                <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                                                   <img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo-tn.png"/>
                                                </td>
                                             </tr>
                                             <tr>
                                                <td style="border:1px solid #6699CC;">
                                                   <table width="100%" cellspacing="0" cellpadding="5">
                                                       <tr>
                                                          <td colspan="2">
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"></span></span></p>
                                                              <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                               Estimado colaborador(a), el presente es para informarle que su solicitud de horas extra ha sido '||Lv_EstadoSolicitud||'</span></span></p>

                                                                <table border="1px">
                                                                     <thead>
                                                                         <tr>
		                                                                       <th>Nombres</th>
		                                                                       <th>Fecha Solicitud</th> 
                                                                           <th>Hora Inicio</th>
                                                                           <th>Hora Fin</th>
		                                                                       <th>Observacion</th>
                                                                           <th>Estado</th>
                                                                           <th>Usuario Creacion</th> 
		                                                                     </tr>
		                                                                  </thead>
                                                                      <tbody>
                                                                          <tr>
                                                                              <td>'||Lr_InfoSolicitud.NOMBRE||'</td>
                                                                              <td>'||TO_CHAR(Lr_InfoSolicitud.FECHA_SOLICITUD,'DD-MM-YY')||'</td>
                                                                              <td>'||Lr_InfoSolicitud.HORA_INICIO||'</td>
                                                                              <td>'||Lr_InfoSolicitud.HORA_FIN||'</td>
                                                                              <td>'||Pv_Observacion||'</td>
                                                                              <td>'||Lv_EstadoSolicitud||'</td>
                                                                              <td>'||Lr_InfoSolicitud.USR_CREACION||'</td>
                                                                          </tr>
                                                                       </tbody>
                                                                </table>
                                                                    <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                                   <strong>Nota:</strong> Este correo es un seguimiento informativo de la solicitud registrada.</span></span></p>
                                                          </td>
                                                       </tr>
                                                   </table>
                                                </td>
                                             </tr>
                                         </table>
                                 </body>
                             </html>';

                           IF C_CORREO_REMITENTE%FOUND THEN  

                             UTL_MAIL.SEND(
                                  SENDER       => Lr_valor1,
                                  RECIPIENTS   => Lr_InfoSolicitud.MAIL_CIA,
                                  SUBJECT      => Lv_Asunto,
                                  MESSAGE      => Lv_Cuerpo,
                                  MIME_TYPE    => 'text/html; charset=UTF-8'
                                  );

                           END IF;
          END LOOP;

      CLOSE C_CORREO_REMITENTE;

    EXCEPTION
    WHEN OTHERS THEN
            Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ENVIAR_MAIL_GENERAL: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ENVIAR_MAIL_GENERAL: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

    END P_ENVIAR_MAIL_GENERAL;

    PROCEDURE P_ELIMINAR_MASIVA(Pn_IdHorasSolicitud IN NUMBER,
                                Pv_Usuario          IN VARCHAR2,
                                Pv_EmpresaCod       IN VARCHAR2,
                                Pv_Status           OUT VARCHAR2,
                                Pv_Mensaje          OUT VARCHAR2)


    AS

      CURSOR C_OBSERVACION_SOLICITUD(Cn_IdHorasSolicitud NUMBER) IS
        SELECT IHSD.HORAS_SOLICITUD_ID,IHSD.TIPO_HORAS_EXTRA_ID,IHSD.HORA_INICIO_DET,IHSD.HORA_FIN_DET,
          IHSD.HORAS,IHSD.FECHA_SOLICITUD_DET,IHSD.OBSERVACION  
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
          WHERE IHS.ID_HORAS_SOLICITUD=Cn_IdHorasSolicitud 
          AND IHSD.FE_CREACION=(SELECT MAX(IHSDE.FE_CREACION) FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSDE
          WHERE IHSDE.HORAS_SOLICITUD_ID=Cn_IdHorasSolicitud);

       Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
       Le_Errors                      EXCEPTION;



    BEGIN 


         IF C_OBSERVACION_SOLICITUD%ISOPEN THEN CLOSE C_OBSERVACION_SOLICITUD; END IF;

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          SET IHS.ESTADO='Eliminada',IHS.USR_MODIFICACION=Pv_Usuario,IHS.FE_MODIFICACION=SYSDATE
         WHERE IHS.ID_HORAS_SOLICITUD=''||Pn_IdHorasSolicitud||'';

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD
          SET IHSD.ESTADO='Eliminada',IHSD.USR_MODIFICACION=Pv_Usuario, IHSD.FE_MODIFICACION=SYSDATE
         WHERE IHSD.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud||'';

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE
          SET IHSE.ESTADO='Eliminada', IHSE.USR_MODIFICACION=Pv_Usuario, IHSE.FE_MODIFICACION=SYSDATE
         WHERE IHSE.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud||'';

         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL IHSH
          SET IHSH.ESTADO='Inactiva', IHSH.USR_MODIFICACION=Pv_Usuario, IHSH.FE_MODIFICACION= SYSDATE
         WHERE IHSH.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud||'';


         FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Pn_IdHorasSolicitud) 
         LOOP

             P_INSERT_HISTORIAL_SOLICITUD(Pn_IdHorasSolicitud,
                                          Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                          Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                          Lr_ObservacionSolicitud.HORA_FIN_DET,
                                          Lr_ObservacionSolicitud.HORAS,
                                          Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                          'Solicitud eliminada',
                                          'Eliminada',
                                          Pv_Usuario,
                                          Pv_Status,
                                          Pv_Mensaje);

             IF Pv_Status = 'ERROR' THEN
                RAISE Le_Errors;
             END IF;

         END LOOP;

         UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH
          SET ITH.ESTADO='Eliminada', ITH.USR_MODIFICACION=Pv_Usuario, ITH.FE_MODIFICACION=SYSDATE
         WHERE ITH.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud||'';

         UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE
          SET IDHE.ESTADO='Eliminada', IDHE.USR_MODIFICACION=Pv_Usuario, IDHE.FE_MODIFICACION=SYSDATE
         WHERE IDHE.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud||'';

        COMMIT; 

        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';

    EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_MASIVA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_MASIVA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));     


    END P_ELIMINAR_MASIVA;

    PROCEDURE P_PLANIFICAR_HORARIO(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2)


    AS

       Lv_EmpresaCod                  VARCHAR2(2);
       Lv_NombreArea                  VARCHAR2(30);
       Lv_NombreDepto                 VARCHAR2(30);
       Lv_UsrCreacion                 VARCHAR2(15);
       Lv_jorEmple                    VARCHAR2(2);
       Lv_Observacion     		        VARCHAR2(200);
       Lv_descripcion                 VARCHAR2(20);
       Lv_estadoSolicitud             VARCHAR2(25);
       Lv_emplPlanificados            VARCHAR2(500);
       Ln_Contador                    NUMBER:=0;
       Ln_Contador1                   NUMBER:=1;
       Ln_Contador2                   NUMBER:=0;
       Ln_Cantidad                    NUMBER:=0;
       Ln_ContadorDias                Number:=0;
       Ln_ContadorD                   Number:=1;
       Lv_NoEmpleado                  apex_t_varchar2;
       Lv_FechaInicio                 apex_t_varchar2;
       Lv_FechaFin                    apex_t_varchar2;
       Lv_HoraInicio                  apex_t_varchar2;
       Lv_HoraFin                     apex_t_varchar2;
       Lv_TipoHorario                 apex_t_varchar2;
       Lv_PlanificacionAnual          apex_t_varchar2;
       Ln_DiasEscogidos               apex_t_varchar2;
       Lv_EmpleDia                    apex_t_varchar2;
       Ln_SecuencialDia               apex_t_varchar2;
       Ln_IdSecuencial                apex_t_varchar2;
       Lv_HoraI                       VARCHAR2(6);
       Lv_HoraF                       VARCHAR2(6);
       Ld_FechaI                      DATE;
       Ld_FechaF                      DATE;
       Ld_FechaHoraI                  DATE;
       Ld_FechaHoraF                  DATE;
       Ld_FechaEncontradaHI           DATE;
       Ld_FechaEncontradaHF           DATE;
       Ld_HorasInicioNocturnas1       DATE;
       Ld_HorasFinNocturnas1          DATE;
       Ln_Dia                         NUMBER;
       Ln_Mes                         NUMBER;
       Ln_NumeroHoras                 DATE;
       Lv_Año                         VARCHAR2(5);
       Lv_DiaFeriado                  VARCHAR2(2);
       Lv_Bandera                     VARCHAR2(6);
       Lv_MensajeError                CLOB;
       Lc_arrejson       		          CLOB;
       Le_Errors                      EXCEPTION;

       Lv_HorasInicioNocturnas        VARCHAR2(7);
       Lv_HorasFinNocturnas           VARCHAR2(7);
       Lv_NumHorasNocturnas           VARCHAR2(7);  
       Ln_emple NUMBER ;
       Ln_codEmpresa  NUMBER ;


       CURSOR C_DIAS_PLANIFICADOS(Cv_FechaInicio VARCHAR2, Cv_FechaFin VARCHAR2) IS
         SELECT (TO_DATE(Cv_FechaFin,'DD/MM/YYYY') - TO_DATE(Cv_FechaInicio,'DD/MM/YYYY')) CANTIDAD FROM DUAL;


       CURSOR C_EXISTE_PLANIFICACION(Cv_EmpresaCod VARCHAR2,Cv_NoEmple VARCHAR2,Cv_FechaInicio VARCHAR2,Cv_FechaFin VARCHAR2) IS
         SELECT AHE.ID_HORARIO_EMPLEADO,TO_CHAR(TO_DATE(AHE.FECHA_INICIO||' '||AHE.HORA_INICIO,'DD-MM-YY HH24:MI'),'DD-MM-YYYY HH24:MI')FECHA_HORA_INICIO,
            TO_CHAR(TO_DATE(AHE.FECHA_FIN||' '||AHE.HORA_FIN,'DD-MM-YY HH24:MI'),'DD-MM-YYYY HH24:MI')FECHA_HORA_FIN,VEE.NOMBRE
          FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE 
           JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = AHE.NO_EMPLE AND VEE.NO_CIA = AHE.EMPRESA_COD
          WHERE AHE.EMPRESA_COD =Cv_EmpresaCod AND VEE.NO_EMPLE=Cv_NoEmple AND AHE.ESTADO='Activo'
           AND (AHE.FECHA_INICIO >=TO_DATE(Cv_FechaInicio,'DD-MM-YY')  AND AHE.FECHA_FIN <=TO_DATE(Cv_FechaFin,'DD-MM-YY'))
           ORDER BY AHE.FECHA_INICIO ASC,AHE.FECHA_FIN ASC;

       CURSOR C_NUMERO_DIA(Cd_FechaInicio DATE,Cd_FechaFin DATE)IS
          SELECT TO_CHAR(Cd_FechaInicio,'D') DIA_INICIO,TO_CHAR(Cd_FechaFin,'D') DIA_FIN FROM DUAL;


       CURSOR C_DIAS_FERIADO(Cn_dia NUMBER,Cn_Mes NUMBER,Cv_Año VARCHAR2) IS
        SELECT COUNT(APD.VALOR1)CANTIDAD FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID=(SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='DIAS_FERIADO_HORASEXTRA')
          AND VALOR2=Cn_dia AND VALOR1=Cn_Mes AND VALOR3=Cv_Año AND APD.ESTADO='Activo';

       CURSOR C_NUMERO_HORAS(Cv_FechaI VARCHAR2,Cv_HoraI VARCHAR2,Cv_FechaF VARCHAR2,Cv_HoraF VARCHAR2)IS
        SELECT TRUNC((TO_DATE(Cv_FechaF
          || ' '
          ||Cv_HoraF, 'DD.MM.YYYY HH24:MI:SS') - TO_DATE(Cv_FechaI
          || ' '
          ||Cv_HoraI, 'DD.MM.YYYY HH24:MI:SS')) * (24)) DIFERENCIA_HORAS
        FROM DUAL;

       Lr_Cantidad                    C_DIAS_PLANIFICADOS%ROWTYPE;
       Lr_Dia                         C_NUMERO_DIA%ROWTYPE;
       Ln_NumHoras                    NUMBER;
       Lr_CantidadDia                 C_DIAS_FERIADO%ROWTYPE;
       Lv_HoraFinDia                  VARCHAR2(7);

    BEGIN

    -- RETORNO LAS VARIABLES DEL REQUEST

    APEX_JSON.PARSE(Pcl_Request);
    Lv_NoEmpleado          := APEX_JSON.find_paths_like(p_return_path => 'noEmpleado[%]' );
    Lv_FechaInicio         := APEX_JSON.find_paths_like(p_return_path => 'fechaInicio[%]' );
    Lv_FechaFin            := APEX_JSON.find_paths_like(p_return_path => 'fechaFin[%]' );
    Lv_HoraInicio          := APEX_JSON.find_paths_like(p_return_path => 'horaInicio[%]' );
    Lv_HoraFin             := APEX_JSON.find_paths_like(p_return_path => 'horaFin[%]' );
    Lv_TipoHorario         := APEX_JSON.find_paths_like(p_return_path => 'tipoHorario[%]' );
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrCreacion         := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_EmpleDia            := APEX_JSON.find_paths_like(p_return_path => 'diasEscogidos[%].noEmple' );
    Ln_DiasEscogidos       := APEX_JSON.find_paths_like(p_return_path => 'diasEscogidos[%].dia' );
    Ln_SecuencialDia       := APEX_JSON.find_paths_like(p_return_path => 'diasEscogidos[%].idDia' );
    Ln_IdSecuencial        := APEX_JSON.find_paths_like(p_return_path => 'idSecuencia[%]' );
    Lv_PlanificacionAnual  := APEX_JSON.find_paths_like(p_return_path => 'planificacionAnual[%]' );
    Lv_observacion         := 'Origen Portal Planificacion HE:Creacion solicitud por planificacion temporal';
    Lv_estadoSolicitud     := 'Verificacion';
    Lv_descripcion         := 'Unitaria';
       -- VALIDACIONES

       IF Lv_EmpresaCod IS NULL THEN
          Pv_Mensaje := 'El parámetro Lv_EmpresaCod está vacío';
          RAISE Le_Errors;
       END IF;

       IF Lv_UsrCreacion IS NULL THEN
          Pv_Mensaje := 'El parámetro Lv_UsrCreacion está vacío';
          RAISE Le_Errors;
       END IF;

     SELECT HORA_INICIO,HORA_FIN,TOTAL_HORAS_DIA
       INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas,Lv_NumHorasNocturnas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';

     SELECT HORA_FIN
       INTO Lv_HoraFinDia
       FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
      WHERE TIPO_HORAS_EXTRA = 'HORA_FIN_DIA';

       Ln_Contador := Lv_NoEmpleado.COUNT;
       
       IF Ln_Contador > 50 THEN 
          
          Pv_Mensaje := 'ERROR 02: El número máximo de planificaciones es de 50 ingresos';
          RAISE Le_Errors;
       END IF;

       WHILE Ln_Contador1 <=  Ln_Contador LOOP             

             IF C_DIAS_PLANIFICADOS%ISOPEN THEN CLOSE C_DIAS_PLANIFICADOS; END IF;             
             OPEN C_DIAS_PLANIFICADOS(apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1)),apex_json.get_varchar2(p_path => Lv_FechaFin(Ln_Contador1)));
             FETCH C_DIAS_PLANIFICADOS INTO Lr_Cantidad;

             CLOSE C_DIAS_PLANIFICADOS;

             Ln_Cantidad := Lr_Cantidad.CANTIDAD;

             Lv_HoraI  := apex_json.get_varchar2(p_path => Lv_HoraInicio(Ln_Contador1));
             Lv_HoraF  := apex_json.get_varchar2(p_path => Lv_HoraFin(Ln_Contador1));
             Ld_FechaI := TO_DATE(apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1)),'DD-MM-YYYY');
             Ld_FechaF := TO_DATE(apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1)),'DD-MM-YYYY');

             IF (Lv_HoraF >='00:00' AND Lv_HoraF < Lv_HoraI) THEN
                 Ld_FechaF:=Ld_FechaF+1;
             END IF;

             -- OBTENER EL NÚMERO DE HORAS PLANIFICACION

             IF C_NUMERO_HORAS%ISOPEN THEN CLOSE C_NUMERO_HORAS; END IF;
                OPEN C_NUMERO_HORAS(Ld_FechaI,Lv_HoraI,Ld_FechaF,Lv_HoraF);
                FETCH C_NUMERO_HORAS INTO Ln_NumHoras;
                CLOSE C_NUMERO_HORAS;

             IF (Lv_HoraI >= Lv_HorasInicioNocturnas OR Lv_HoraI <= Lv_HorasFinNocturnas OR Lv_HoraF <= Lv_HorasFinNocturnas OR Lv_HoraF >= Lv_HorasInicioNocturnas) AND Ln_NumHoras > Lv_NumHorasNocturnas THEN 
                 Pv_Mensaje := 'ERROR 01: La jornada supera el máximo de horas permitido para la planificación';
                 RAISE Le_Errors;
             END IF;

             WHILE Ln_Contador2 <= Ln_Cantidad LOOP

                Ld_FechaHoraI := TO_DATE((TO_CHAR(Ld_FechaI,'DD-MM-YYYY')||''||Lv_HoraI),'DD-MM-YYYY HH24:MI');  
                Ld_FechaHoraF := TO_DATE((TO_CHAR(Ld_FechaF,'DD-MM-YYYY')||''||Lv_HoraF),'DD-MM-YYYY HH24:MI'); 

                Ld_FechaHoraI:= Ld_FechaHoraI + Ln_Contador2;
                Ld_FechaHoraF:= Ld_FechaHoraF + Ln_Contador2;

                -- OBTENER EL NÚMERO DE DIA DE LA SEMANA

                IF C_NUMERO_DIA%ISOPEN THEN CLOSE C_NUMERO_DIA; END IF;

                OPEN C_NUMERO_DIA(Ld_FechaHoraI,Ld_FechaHoraF);
                FETCH C_NUMERO_DIA INTO Lr_Dia;
                CLOSE C_NUMERO_DIA;
                -----

                --- VALIDAR QUE EL DIA A AGREGAR NO SEA FERIADO CUANDO SE REALIZA UNA PLANIFICACION ANUAL

                IF(apex_json.get_varchar2(p_path => Lv_PlanificacionAnual(Ln_Contador1)) = 'S') THEN

                  Ln_Dia := TO_NUMBER(TO_CHAR(Ld_FechaHoraI,'DD'));
                  Ln_Mes := TO_NUMBER(TO_CHAR(Ld_FechaHoraI,'MM'));
                  Lv_Año := TO_CHAR(Ld_FechaHoraI,'YYYY');

                  IF C_DIAS_FERIADO%ISOPEN THEN CLOSE C_DIAS_FERIADO; END IF;

                  OPEN C_DIAS_FERIADO(Ln_Dia,Ln_Mes,Lv_Año);
                  FETCH C_DIAS_FERIADO INTO Lr_CantidadDia;
                  CLOSE C_DIAS_FERIADO;

                    IF(Lr_CantidadDia.CANTIDAD = 0) THEN

                      Lv_DiaFeriado:='N';

                    ELSE

                      Lv_DiaFeriado:='S';

                    END IF;                
                END IF;

                Ln_ContadorDias := Ln_DiasEscogidos.COUNT;
                WHILE Ln_ContadorD <= Ln_ContadorDias LOOP                

                     IF(apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1)) = apex_json.get_varchar2(p_path => Lv_EmpleDia(Ln_ContadorD)) 
                      AND (apex_json.get_number(p_path => Ln_IdSecuencial(Ln_Contador1)) = apex_json.get_number(p_path => Ln_SecuencialDia(Ln_ContadorD)))) 
                      AND (Lr_Dia.DIA_INICIO = apex_json.get_number(p_path => Ln_DiasEscogidos(Ln_ContadorD)))THEN                         
                              Lv_Bandera := 'true';
                     END IF;

                    Ln_ContadorD:=Ln_ContadorD+1;

                  EXIT WHEN Lv_Bandera = 'true';

                END LOOP;
                Ln_ContadorD:=1;

                IF(Lv_Bandera = 'true') THEN

                   --validar que el horario no exista para que se registre
                         IF C_EXISTE_PLANIFICACION%ISOPEN THEN CLOSE C_EXISTE_PLANIFICACION; END IF;

                                FOR Lr_ExistePlani IN C_EXISTE_PLANIFICACION(Lv_EmpresaCod,apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1)),
                                     apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1)),apex_json.get_varchar2(p_path => Lv_FechaFin(Ln_Contador1)))
                                LOOP 
                                         Ld_FechaEncontradaHI:=TO_DATE(Lr_ExistePlani.FECHA_HORA_INICIO,'DD-MM-YYYY HH24:MI');
                                         Ld_FechaEncontradaHF:=TO_DATE(Lr_ExistePlani.FECHA_HORA_FIN,'DD-MM-YYYY HH24:MI');

                                         Lv_MensajeError:='<h5 align="left" style="margin-bottom:5px;"> No se pudo crear la Planificación escogida </h5>
                                                           <h5 align="left" style="margin-top:0px;margin-bottom:20px;">Se generarón las siguientes observaciones:</h5>
                                                           <h5 align="left" style="margin-top:0px;margin-bottom:5px">El Empleado <b>'||Lr_ExistePlani.NOMBRE||'</b> ya tiene
                                                            planificado un horario dentro del mismo rango de fecha e intervalo. <b style="color:green">(Sobre Planificación Existente)</b> </h5>
                                                           <h5 align="left" style="margin-top:0px;margin-bottom:5px"><b>Datos de Planificación Existente con la que existen cruces:</b></h5>
                                                           <table  style="width:100%">
                                                             <tbody>
                                                                <tr>
                                                                  <td align="left">Fechas de trabajo:</td>
                                                                  <td align="left">'||Lr_ExistePlani.FECHA_HORA_INICIO||' - '||Lr_ExistePlani.FECHA_HORA_FIN||'</td>
                                                                </tr>
                                                             </tbody>
                                                           </table>
                                                           <br>
                                                           <h5 align="left" style="margin-top:0px;margin-bottom:5px"> <b>Se realizó la planificación de los siguientes id:</b><b>'||Lv_emplPlanificados||'</b> . <b style="color:green">(Eliminar de lista para planificar)</b> </h5>';

                                         IF(Ld_FechaHoraI >= Ld_FechaEncontradaHI AND Ld_FechaHoraI< Ld_FechaEncontradaHF 
                                         AND Ld_FechaHoraF>Ld_FechaHoraI AND Ld_FechaHoraF <= Ld_FechaEncontradaHF) THEN
                                             Pv_Mensaje:= Lv_MensajeError;
                                             ROLLBACK;
                                             RAISE Le_Errors;
                                         END IF;


                                         IF(Ld_FechaHoraI >= Ld_FechaEncontradaHI AND Ld_FechaHoraI < Ld_FechaEncontradaHF AND Ld_FechaHoraF > Ld_FechaEncontradaHF)THEN
                                             Pv_Mensaje:= Lv_MensajeError;
                                             ROLLBACK;
                                             RAISE Le_Errors;
                                         END IF;

                                         IF(Ld_FechaHoraI < Ld_FechaEncontradaHI AND Ld_FechaHoraF > Ld_FechaEncontradaHI AND Ld_FechaHoraF <= Ld_FechaEncontradaHF)THEN
                                             Pv_Mensaje:= Lv_MensajeError;
                                             ROLLBACK;
                                             RAISE Le_Errors;
                                         END IF;

                                         IF(Ld_FechaHoraI <= Ld_FechaEncontradaHI AND Ld_FechaHoraF >= Ld_FechaEncontradaHF)THEN
                                            Pv_Mensaje:= Lv_MensajeError;
                                            ROLLBACK;
                                            RAISE Le_Errors;
                                         END IF;
                              END LOOP;
                END IF;

                Lv_Bandera:='';                
                Ln_Contador2:=Ln_Contador2+1;
             END LOOP;

             Ln_Contador2:=0;

             WHILE Ln_Contador2 <= Ln_Cantidad LOOP

                -- OBTENER EL NÚMERO DE DIA DE LA SEMANA

                IF C_NUMERO_DIA%ISOPEN THEN CLOSE C_NUMERO_DIA; END IF;

                OPEN C_NUMERO_DIA(Ld_FechaI+Ln_Contador2,Ld_FechaF+Ln_Contador2);
                FETCH C_NUMERO_DIA INTO Lr_Dia;
                CLOSE C_NUMERO_DIA;

                --- VALIDAR QUE EL DIA A AGREGAR NO SEA FERIADO CUANDO SE REALIZA UNA PLANIFICACION ANUAL

                  Ln_Dia := TO_NUMBER(TO_CHAR(Ld_FechaI+Ln_Contador2,'DD'));
                  Ln_Mes := TO_NUMBER(TO_CHAR(Ld_FechaI+Ln_Contador2,'MM'));
                  Lv_Año := TO_CHAR(Ld_FechaI+Ln_Contador2,'YYYY');

                  IF C_DIAS_FERIADO%ISOPEN THEN CLOSE C_DIAS_FERIADO; END IF;

                  OPEN C_DIAS_FERIADO(Ln_Dia,Ln_Mes,Lv_Año);
                  FETCH C_DIAS_FERIADO INTO Lr_CantidadDia;
                  CLOSE C_DIAS_FERIADO;

                    IF(Lr_CantidadDia.CANTIDAD = 0) THEN   
                      Lv_DiaFeriado:='N';                  
                    ELSE                   
                      Lv_DiaFeriado:='S';                    
                    END IF;

                Ln_ContadorDias := Ln_DiasEscogidos.COUNT;

                WHILE Ln_ContadorD <= Ln_ContadorDias LOOP

                       IF(apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1)) = apex_json.get_varchar2(p_path => Lv_EmpleDia(Ln_ContadorD)) 
                    AND (apex_json.get_number(p_path => Ln_IdSecuencial(Ln_Contador1)) = apex_json.get_number(p_path => Ln_SecuencialDia(Ln_ContadorD))))  
                    AND (Lr_Dia.DIA_INICIO = apex_json.get_number(p_path => Ln_DiasEscogidos(Ln_ContadorD)))THEN

                           P_GUARDAR_PLANIFICACION(apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1)),
                                            Ld_FechaI+Ln_Contador2,
                                            Ld_FechaF+Ln_Contador2,
                                            Lv_HoraI,
                                            Lv_HoraF,
                                            apex_json.get_varchar2(p_path => Lv_TipoHorario(Ln_Contador1)),
                                            Lv_EmpresaCod,
                                            Lv_UsrCreacion,
                                            Pv_Status,
                                            Pv_Mensaje);

                             IF Pv_Status = 'ERROR' THEN
                                RAISE Le_Errors;
                             END IF;

                   END IF;                                
                   Ln_ContadorD := Ln_ContadorD+1;
                END LOOP;
                Ln_ContadorD:=1;                 

                Ln_Contador2:=Ln_Contador2+1;
             END LOOP;

             Ln_Contador2:=0;
             Lv_emplPlanificados := Lv_emplPlanificados || ' - ' || apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1));

             Ln_Contador1:=Ln_Contador1+1;

       END LOOP;

       Ln_Contador := Lv_NoEmpleado.COUNT;
       Ln_Contador1:=1;
        Ln_Contador2:=0;

       WHILE Ln_Contador1 <=  Ln_Contador LOOP  

           IF C_DIAS_PLANIFICADOS%ISOPEN THEN CLOSE C_DIAS_PLANIFICADOS; END IF;             
            OPEN C_DIAS_PLANIFICADOS(apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1)),apex_json.get_varchar2(p_path => Lv_FechaFin(Ln_Contador1)));
           FETCH C_DIAS_PLANIFICADOS INTO Lr_Cantidad;

           CLOSE C_DIAS_PLANIFICADOS;

           Ln_Cantidad := Lr_Cantidad.CANTIDAD;

           IF apex_json.get_varchar2(p_path => Lv_TipoHorario(Ln_Contador1)) = 'TEMPORAL' THEN

           SELECT HORA_INICIO,HORA_FIN
             INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas
            FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
             WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';

             Ld_HorasInicioNocturnas1 := TO_DATE((apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1))||''||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
             Ld_HorasFinNocturnas1 :=  TO_DATE((apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1))||''||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');


                  Ln_emple := to_number(apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1)));
                  Ln_codEmpresa:=to_number(APEX_JSON.get_varchar2(p_path => 'empresaCod'));   

                SELECT vee.nombre_area, vee.nombre_depto
                  into Lv_NombreArea, Lv_NombreDepto
                  FROM naf47_tnet.v_empleados_empresas vee
                 WHERE vee.no_emple = to_number(apex_json.get_varchar2(p_path => Lv_NoEmpleado(Ln_Contador1)))
                   AND vee.no_cia = Ln_codEmpresa;

                  Lv_HoraI  := apex_json.get_varchar2(p_path => Lv_HoraInicio(Ln_Contador1));
                  Lv_HoraF  := apex_json.get_varchar2(p_path => Lv_HoraFin(Ln_Contador1));
                  Ld_FechaI := TO_DATE(apex_json.get_varchar2(p_path => Lv_FechaInicio(Ln_Contador1)),'DD-MM-YYYY');
                  Ld_FechaF := TO_DATE(apex_json.get_varchar2(p_path => Lv_FechaFin(Ln_Contador1)),'DD-MM-YYYY');

                  Ln_Dia := TO_NUMBER(TO_CHAR(Ld_FechaI+Ln_Contador2,'DD'));
                  Ln_Mes := TO_NUMBER(TO_CHAR(Ld_FechaI+Ln_Contador2,'MM'));
                  Lv_Año := TO_CHAR(Ld_FechaI+Ln_Contador2,'YYYY');

                  IF(Lv_HoraF > Lv_HorasFinNocturnas AND Lv_HoraI > Lv_HorasInicioNocturnas)THEN
                       Lv_jorEmple:='N';
                  ELSE
                       Lv_jorEmple:='M';
                  END IF;

                   WHILE Ln_Contador2 <= Ln_Cantidad LOOP                                                                                         

                  Lc_arrejson := chr(10) || lpad(' ', 6, ' ') || '{' || chr(10) ||
                                 lpad(' ', 9, ' ') || '"noEmpleado":[' || Ln_emple  || '],' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"fecha":"' || (Ld_FechaI+Ln_Contador2) || '",' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"horaInicio":"' || Lv_HoraI || '",' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"horaFin":"' || Lv_HoraF || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"observacion":"' || Lv_Observacion || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"estado":"' || Lv_estadoSolicitud || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"empresaCod":"' || Ln_codEmpresa || '",' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"usrCreacion":"' || Lv_UsrCreacion || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"tareaId":[],' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"nombreDocumento":[],' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"ubicacionDocumento":[],' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"jornadaEmpleado":"' || Lv_jorEmple || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"esFinDeSemana":"' || 'N' || '",' || 
                                                   chr(10) ||  lpad(' ', 9, ' ') 
                                                   || '"esDiaLibre":"' || 'N' || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"descripcion":"' || Lv_descripcion || '",' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"idCuadrilla":"' || null || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"nombreArea":"' || Lv_NombreArea || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"feInicioTarea":[],' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"feFinTarea":[],' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"nombreDepartamento":"' || Lv_NombreDepto || '",' ||
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"esSuperUsuario":"' || 'N' || '",' || 
                                                   chr(10) || lpad(' ', 9, ' ') 
                                                   || '"fechaHasta":"' || Ld_FechaF || '"' || 
                                                   chr(10) || lpad(' ', 6, ' ') || '}';                                  

                        DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA(lc_arrejson,
                                                                                    Pv_Status,
                                                                                    Pv_Mensaje);
                        IF Pv_Status = 'ERROR' THEN
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                               ' DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_PLANIFICAR_HORARIO',
                                                               Pv_Mensaje || ' Linea: ' ||
                                                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ,
                                                               NVL(SYS_CONTEXT('USERENV',
                                                                               'HOST'),
                                                                   'DB_SOPORTE'),
                                                               SYSDATE,
                                                               NVL(SYS_CONTEXT('USERENV',
                                                                               'IP_ADDRESS'),
                                                                   '127.0.0.1'));
                        END IF;

                   Ln_Contador2:=Ln_Contador2+1;
                   END LOOP;             

                END IF;

          Ln_Contador2:=0;                            
          Ln_Contador1:=Ln_Contador1+1;
       END LOOP;
    COMMIT;

     Pv_Status     := 'OK';
     Pv_Mensaje    := 'Transacción exitosa';

    EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_PLANIFICAR_HORARIO: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_PLANIFICAR_HORARIO: ',
                                                 Pv_Mensaje || ' Linea: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE  ,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1')); 

    END P_PLANIFICAR_HORARIO;

    PROCEDURE P_GUARDAR_PLANIFICACION(Pv_NoEmpleado  VARCHAR2,
                                      Pv_FechaInicio DATE,
                                      Pv_FechaFin    DATE,
                                      Pv_HoraInicio  VARCHAR2,
                                      Pv_HoraFin     VARCHAR2,
                                      Pv_TipoHorario VARCHAR2,
                                      Pv_EmpresaCod  VARCHAR2,
                                      Pv_UsrCreacion VARCHAR2,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2)

    AS

      CURSOR C_NOMBRE_TIPO_HORARIO(Cv_TipoHorario VARCHAR2) IS
       SELECT ID_TIPO_HORARIO 
        FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS 
       WHERE ESTADO='Activo' 
         AND NOMBRE_TIPO_HORARIO=Cv_TipoHorario
          OR TO_CHAR(ID_TIPO_HORARIO)=Cv_TipoHorario;

       Lr_IdTipoHorario      DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS.ID_TIPO_HORARIO%TYPE;
       Ln_IdHorarioEmpleado  DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS.ID_HORARIO_EMPLEADO%TYPE;
       Le_Errors             EXCEPTION;


    BEGIN

       IF C_NOMBRE_TIPO_HORARIO%ISOPEN THEN CLOSE C_NOMBRE_TIPO_HORARIO; END IF;
       OPEN C_NOMBRE_TIPO_HORARIO(Pv_TipoHorario);
       FETCH C_NOMBRE_TIPO_HORARIO INTO Lr_IdTipoHorario;

       CLOSE C_NOMBRE_TIPO_HORARIO;

       Ln_IdHorarioEmpleado := DB_HORAS_EXTRAS.SEQ_INFO_HORARIO_EMPLEADOS.NEXTVAL;

       INSERT 
         INTO DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS
         (
          ID_HORARIO_EMPLEADO,
          FECHA_INICIO,
          FECHA_FIN,
          HORA_INICIO,
          HORA_FIN,
          CUADRILLA_ID,
          NO_EMPLE,
          EMPRESA_COD,
          TIPO_HORARIO_ID,
          ESTADO,
          FE_CREACION,
          USR_CREACION,
          FE_MODIFICACION,
          USR_MODIFICACION,
          IP_CREACION
         )
         VALUES
         (
          Ln_IdHorarioEmpleado,
          Pv_FechaInicio,
          Pv_FechaFin,
          Pv_HoraInicio,
          Pv_HoraFin,
          NULL,
          Pv_NoEmpleado,
          Pv_EmpresaCod,
          Lr_IdTipoHorario,
          'Activo',
          SYSDATE,
          Pv_UsrCreacion,
          NULL,
          NULL,
          NULL
         );


         INSERT INTO
            DB_HORAS_EXTRAS.INFO_HORARIO_HISTORIAL
            (
            ID_HORARIO_HISTORIAL,
            HORARIO_EMPLEADO_ID,
            FECHA_INICIO,
            FECHA_FIN,
            HORA_INICIO,
            HORA_FIN,
            CUADRILLA_ID,
            NO_EMPLE,
            TIPO_HORARIO_ID,
            ESTADO,
            OBSERVACION,
            FE_CREACION,
            USR_CREACION,
            FE_MODIFICACION,
            USR_MODIFICACION,
            IP_CREACION
            )
            VALUES
            (
            DB_HORAS_EXTRAS.SEQ_INFO_HORARIO_HISTORIAL.NEXTVAL,
            Ln_IdHorarioEmpleado,
            Pv_FechaInicio,
            Pv_FechaFin,
            Pv_HoraInicio,
            Pv_HoraFin,
            NULL,
            Pv_NoEmpleado,
            Lr_IdTipoHorario,
            'Activo',
            'Se registró planificación de horario',
            SYSDATE,
            Pv_UsrCreacion,
            NULL,
            NULL,
            NULL
            );

        COMMIT;

        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';

    EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_PLANIFICACION: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_PLANIFICACION: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    END P_GUARDAR_PLANIFICACION;


    PROCEDURE P_EDITAR_PLANIFICACION(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2)


    AS

       Le_Errors             EXCEPTION;

    BEGIN 


      DBMS_OUTPUT.PUT_LINE('');


    EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_EDITAR_PLANIFICACION: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_EDITAR_PLANIFICACION: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

    END P_EDITAR_PLANIFICACION;


    PROCEDURE P_ELIMINAR_PLANIFICACION(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2)

    AS   

       --Ln_IdHorarioEmpleado     DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS.ID_HORARIO_EMPLEADO%TYPE;

       Ln_IdHorarioEmpleado     apex_t_varchar2;
       Lv_UsrCreacion            VARCHAR2(15);
       Lv_Observacion            VARCHAR2(205);
       Ln_ContadorPlanificacion  NUMBER:=0;
       Ln_ContadorPlani          NUMBER:=1;
       Ln_IdHorarioEmple         NUMBER;
       Le_Errors                 EXCEPTION;



    BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorarioEmpleado  := APEX_JSON.find_paths_like(p_return_path => 'idHorarioEmpleado[%]' );
    Lv_UsrCreacion        := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_Observacion        := APEX_JSON.get_varchar2(p_path => 'observacion');


    -- VALIDACIONES

        IF Ln_IdHorarioEmpleado IS NULL THEN
           Pv_Mensaje := 'El parámetro Ln_IdHorarioEmpleado está vacío';
           RAISE Le_Errors;
        END IF;

        IF Lv_UsrCreacion IS NULL THEN
           Pv_Mensaje := 'El parámetro Lv_UsrCreacion está vacío';
           RAISE Le_Errors;
        END IF;

        IF Lv_Observacion IS NULL THEN
           Pv_Mensaje := 'El parámetro Lv_Observacion está vacío';
           RAISE Le_Errors;
        END IF;


        Ln_ContadorPlanificacion :=  Ln_IdHorarioEmpleado.COUNT;
        WHILE Ln_ContadorPlani <=  Ln_ContadorPlanificacion LOOP

            Ln_IdHorarioEmple := apex_json.get_number(p_path => Ln_IdHorarioEmpleado(Ln_ContadorPlani));

            P_ELIMINAR_PLA_MASIVA(Ln_IdHorarioEmple,
                                  Lv_UsrCreacion,
                                  Lv_Observacion,
                                  Pv_Status,
                                  Pv_Mensaje);



            IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
            END IF;

            Ln_ContadorPlani:=Ln_ContadorPlani+1;

        END LOOP;




        COMMIT;

        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';


    EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_PLANIFICACION: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_PLANIFICACION: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

    END P_ELIMINAR_PLANIFICACION;

    PROCEDURE P_ELIMINAR_PLA_MASIVA(Pn_IdHorarioEmple NUMBER,
                                    Pv_UsrCreacion    VARCHAR2,
                                    Pv_Observacion    VARCHAR2,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2)

   AS                          

       Le_Errors                 EXCEPTION;

       CURSOR C_INFO_HORARIO_EMPLEADO(Cn_IdHorarioEmpleado NUMBER)IS
        SELECT AHE.FECHA_INICIO,AHE.FECHA_FIN,AHE.HORA_INICIO,AHE.HORA_FIN,AHE.CUADRILLA_ID,AHE.NO_EMPLE,AHE.TIPO_HORARIO_ID 
          FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE 
         WHERE AHE.ID_HORARIO_EMPLEADO=Cn_IdHorarioEmpleado;


         Lr_Info                  C_INFO_HORARIO_EMPLEADO%ROWTYPE;

   BEGIN


      UPDATE DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS 
        SET ESTADO='Inactivo' 
       WHERE ID_HORARIO_EMPLEADO=Pn_IdHorarioEmple;

      IF C_INFO_HORARIO_EMPLEADO%ISOPEN THEN CLOSE C_INFO_HORARIO_EMPLEADO; END IF;

        OPEN C_INFO_HORARIO_EMPLEADO(Pn_IdHorarioEmple);
        FETCH C_INFO_HORARIO_EMPLEADO INTO Lr_Info;

        IF C_INFO_HORARIO_EMPLEADO%FOUND THEN  

           INSERT INTO
             DB_HORAS_EXTRAS.INFO_HORARIO_HISTORIAL
             (
              ID_HORARIO_HISTORIAL,
              HORARIO_EMPLEADO_ID,
              FECHA_INICIO,
              FECHA_FIN,
              HORA_INICIO,
              HORA_FIN,
              CUADRILLA_ID,
              NO_EMPLE,
              TIPO_HORARIO_ID,
              ESTADO,
              OBSERVACION,
              FE_CREACION,
              USR_CREACION,
              FE_MODIFICACION,
              USR_MODIFICACION,
              IP_CREACION
             )
             VALUES
             (
              DB_HORAS_EXTRAS.SEQ_INFO_HORARIO_HISTORIAL.NEXTVAL,
              Pn_IdHorarioEmple,
              Lr_Info.FECHA_INICIO,
              Lr_Info.FECHA_FIN,
              Lr_Info.HORA_INICIO,
              Lr_Info.HORA_FIN,
              Lr_Info.CUADRILLA_ID,
              Lr_Info.NO_EMPLE,
              Lr_Info.TIPO_HORARIO_ID,
              'Inactivo',
              Pv_Observacion,
              SYSDATE,
              Pv_UsrCreacion,
              NULL,
              NULL,
              NULL
             );

        END IF;

        CLOSE C_INFO_HORARIO_EMPLEADO;

   EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_PLA_MASIVA: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_ELIMINAR_PLA_MASIVA: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));

   END P_ELIMINAR_PLA_MASIVA;

   --

   PROCEDURE P_GENERA_HE_VERIFICACION(Pv_Error OUT VARCHAR2) AS

      CURSOR C_GET_HISTORIAL_TAREA(Cn_EmpresaCod NUMBER,
                                 CV_TAREA_ID   VARCHAR2,
                                 Cn_IdDetalle  NUMBER) IS
      SELECT Q1.NO_EMPLE,
             Q1.USR_CREACION,
             TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY') FECHA_INICIO,
             TO_CHAR(Q2.FECHA, 'DD-MM-YYYY') FECHA_FIN,
             TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY HH24:MI') FECHA_INICIO_HE,
             TO_CHAR(Q2.FECHA, 'DD-MM-YYYY HH24:MI') FECHA_FIN_HE,
             TO_CHAR(Q1.FE_CREACION, 'HH24:MI') HORA_INICIO,
             TO_CHAR(Q2.FECHA, 'HH24:MI') HORA_FIN,
             TRUNC(24 * (to_date(TO_CHAR(Q2.FECHA, 'DD-MM-YYYY') || ' ' || TO_CHAR(Q2.FECHA, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')- to_date(TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY')|| ' ' || TO_CHAR(Q1.FE_CREACION, 'HH24:MI'), 'DD-MM-YYYY HH24:MI'))) TOTAL_HORAS
        FROM (SELECT VE.NO_EMPLE, IDH1.USR_CREACION, IDH1.FE_CREACION
                FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH1
                JOIN DB_SOPORTE.INFO_DETALLE IDE1
                  ON IDE1.ID_DETALLE = IDH1.DETALLE_ID
                JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
                  ON VE.LOGIN_EMPLE = IDH1.USR_CREACION
                 AND VE.NO_CIA = Cn_EmpresaCod
               WHERE IDE1.TAREA_ID = CV_TAREA_ID
                 AND IDH1.DETALLE_ID = Cn_IdDetalle
                 AND IDH1.ESTADO IN ('Aceptada')
                 AND IDH1.ACCION IN ('Ejecutada')) Q1,
             (SELECT IDH.USR_CREACION USER_CREACION, IDH.FE_CREACION fecha
                FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
                JOIN DB_SOPORTE.INFO_DETALLE IDE
                  ON IDE.ID_DETALLE = IDH.DETALLE_ID
               WHERE IDE.TAREA_ID = CV_TAREA_ID
                 AND IDH.DETALLE_ID = Cn_IdDetalle
                 AND IDH.ESTADO IN ('Asignada', 'Finalizada')
                 AND IDH.ACCION IN ('Reasignada', 'Finalizada')) Q2
       WHERE Q1.USR_CREACION = Q2.USER_CREACION
       GROUP BY Q1.NO_EMPLE, Q1.USR_CREACION, Q1.FE_CREACION, Q2.FECHA
       ORDER BY Q1.FE_CREACION ASC;

    CURSOR C_ADMI_HORA_EMPLE_LINEA_BASE(Cn_EmpresaCod NUMBER,
                                        Cv_Estado     VARCHAR2,
                                        Cv_NoEMple    NUMBER,
                                        Cv_FechaDesde VARCHAR2,
                                        Cv_FechaHasta VARCHAR2) IS
      SELECT AHE.NO_EMPLE,
             MIN(AHE.FECHA_INICIO) FECHA_INICIO,
             MAX(AHE.FECHA_FIN) FECHA_FIN,
             MIN(AHE.HORA_INICIO) HORA_INICIO,
             MAX(AHE.HORA_FIN) HORA_FIN
        FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
        JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
          ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
         AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
       WHERE AHE.EMPRESA_COD = Cn_EmpresaCod
         AND AHE.ESTADO = Cv_Estado
         AND AHE.NO_EMPLE = Cv_NoEMple
         AND ((TO_CHAR(AHE.FECHA_INICIO, 'MM') = TO_CHAR(TO_DATE(Cv_FechaDesde,'DD-MM-YYYY'), 'MM') 
         AND TO_CHAR(AHE.FECHA_INICIO, 'YYYY') = TO_CHAR(TO_DATE(Cv_FechaDesde,'DD-MM-YYYY'), 'YYYY'))
         OR  (TO_CHAR(AHE.FECHA_FIN, 'MM') = TO_CHAR(TO_DATE(Cv_FechaHasta,'DD-MM-YYYY'), 'MM') 
         AND TO_CHAR(AHE.FECHA_FIN, 'YYYY') = TO_CHAR(TO_DATE(Cv_FechaHasta,'DD-MM-YYYY'), 'YYYY')))
       GROUP BY AHE.NO_EMPLE;

    CURSOR C_DATOS_EMPLE(Cv_EmpresaCod VARCHAR2, Cv_NoEMple VARCHAR2) IS
      SELECT VEE.AREA, VEE.NOMBRE_AREA, VEE.DEPTO, VEE.NOMBRE_DEPTO, VEE.NOMBRE
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE
       WHERE VEE.NO_EMPLE = Cv_NoEMple
         AND VEE.NO_CIA = Cv_EmpresaCod;

    --CURSOR QUE OBTIENE TAREAS FINALIZADAS EN EL MES Y AÑO ACTUAL, (TAREA_ID)
    CURSOR C_GET_TAREA(CV_ESTADO VARCHAR2) IS
      SELECT IT.TAREA_ID, IT.DETALLE_ID, IT.NUMERO_TAREA, IT.ASIGNADO_NOMBRE
        FROM DB_SOPORTE.INFO_TAREA IT
       WHERE IT.ESTADO = 'Finalizada'
         AND (IT.FE_ULT_MOD) >= TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYY-MM-DD'),'YYYY-MM-DD')
         AND PROCESO_ID = (SELECT ID_PROCESO
                             FROM DB_SOPORTE.ADMI_PROCESO
                            WHERE NOMBRE_PROCESO = 'TAREAS DE HORAS EXTRA'
                              AND ESTADO = 'Activo')
         AND IT.NUMERO_TAREA NOT IN
             (SELECT ITH.TAREA_ID
                FROM DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH
               WHERE ITH.ESTADO IN
                     ('Verificacion', 'Procesada', 'Autorizada', 'Pre-Autorizada','Pendiente')
                 AND ITH.TAREA_ID IS NOT NULL)
       ORDER BY it.NUMERO_TAREA DESC;
       
       CURSOR C_DIA_CORTE_MES_VENCIDO IS
          SELECT APD.VALOR1 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
          ON APC.ID_PARAMETRO = APD. PARAMETRO_ID
          WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_MES_VENCIDO';
          
      ----CURSOR QUE ME TRAE LOS DEPARTAMENTOS CONFIGURADOS   
      CURSOR C_DEPARTAMENTOS_CONFIGURADOS IS
          SELECT PARDET.VALOR1 AS NOMBRE_DEPTO,PARDET.VALOR2 AS TIPO_CREACION
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo';


    Lc_PlaniLineBase      C_ADMI_HORA_EMPLE_LINEA_BASE%ROWTYPE;
    Lc_DatosEMple         C_DATOS_EMPLE%ROWTYPE;
    Lv_EmpresaCod         NUMBER;
    Ln_ContadorRegistros  NUMBER;
    Ln_ContadorReg        NUMBER;    
    Ln_NumeroHoras        NUMBER;
    Lv_EstadoTarea        VARCHAR2(20);
    Lv_estadoSolicitud    VARCHAR2(20);
    Lv_Observacion        VARCHAR2(200);
    Lv_userCreacion       VARCHAR2(15);
    Lv_Status             VARCHAR2(10);
    Lv_regjson            CLOB;
    Le_Exception          EXCEPTION;
    Lv_Error              VARCHAR2(500);
    Ld_FechaCorte         DATE;	
    Lv_crearSolicitudes   VARCHAR2(7):= 'N';


    Type C_GET_HISTORIAL_TAREA_TYPE IS VARRAY(3) OF C_GET_HISTORIAL_TAREA%ROWTYPE;
    Lr_DepartamentosConfigurados   C_DEPARTAMENTOS_CONFIGURADOS%ROWTYPE; --departamentos configurados 
    Lr_Valor_1                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lc_horariosTareaEnviar    C_GET_HISTORIAL_TAREA_TYPE;   
    Lc_horariosTarea_tmp      C_GET_HISTORIAL_TAREA%ROWTYPE;
    Lc_horariosTarea_tmp1     C_GET_HISTORIAL_TAREA%ROWTYPE;
  BEGIN

    Lv_EmpresaCod      := 10;
    Lv_EstadoTarea     := 'Finalizada';

    Lv_Observacion     := 'Origen Tarea HE Job barrido de tareas';
    Lv_userCreacion    := 'Horas_Extras';
    Ln_ContadorRegistros:=0;
    Ln_ContadorReg:=1;

    IF Lv_EmpresaCod IS NULL THEN
      Pv_Error := 'El parámetro empresaCod está vacío';
      RAISE Le_Exception;
    END IF;

     SELECT PARDET.VALOR1 AS TOTAL_HORAS
     INTO Ln_NumeroHoras
         FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
        WHERE PARCAB.Nombre_parametro = 'TOTAL DE HORAS EXTRAS'
          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
          AND PARDET.DESCRIPCION = 'NUMERO TOTAL DE HORAS EXTRAS PARA GENERAR SOLICITUD DESDE UNA TAREA TIPO PROCESO HORAS EXTRAS'
          AND PARDET.ESTADO = 'Activo' 
          AND PARCAB.ESTADO = 'Activo'; 

      SELECT PARDET.VALOR1 AS ESTADO
     INTO Lv_estadoSolicitud
     FROM DB_GENERAL.admi_parametro_cab PARCAB,
          DB_GENERAL.admi_parametro_det PARDET
    WHERE PARCAB.Nombre_parametro = 'ESTADO TAREA PROCESO HE'
      AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
      AND PARDET.DESCRIPCION = 'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE'
      AND PARDET.ESTADO = 'Activo' 
      AND PARCAB.ESTADO = 'Activo';     
      
      IF C_DIA_CORTE_MES_VENCIDO%ISOPEN THEN
        CLOSE C_DIA_CORTE_MES_VENCIDO;
    END IF;

    OPEN C_DIA_CORTE_MES_VENCIDO;
    FETCH C_DIA_CORTE_MES_VENCIDO INTO Lr_valor_1;
      IF C_DIA_CORTE_MES_VENCIDO%FOUND THEN  
           SELECT TO_DATE(Lr_valor_1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
             INTO Ld_FechaCorte
           FROM DUAL;          
      END IF;
    CLOSE C_DIA_CORTE_MES_VENCIDO;

    IF C_DEPARTAMENTOS_CONFIGURADOS%ISOPEN THEN 
       CLOSE C_DEPARTAMENTOS_CONFIGURADOS; 
    END IF;

    FOR tareasFinalizadas IN C_GET_TAREA(Lv_EstadoTarea) LOOP
       Lv_Error :=null;
        
        FOR Lr_DepartamentosConfigurados IN C_DEPARTAMENTOS_CONFIGURADOS loop

            IF Lr_DepartamentosConfigurados.TIPO_CREACION = 2 AND Ld_FechaCorte = TO_CHAR(SYSDATE,'DD-MM-YYYY') 
               AND Lr_DepartamentosConfigurados.NOMBRE_DEPTO = tareasFinalizadas.ASIGNADO_NOMBRE THEN
              Lv_crearSolicitudes := 'S';
            ELSIF Lr_DepartamentosConfigurados.TIPO_CREACION = 1 AND Lr_DepartamentosConfigurados.NOMBRE_DEPTO = tareasFinalizadas.ASIGNADO_NOMBRE THEN  
              Lv_crearSolicitudes := 'S';
            ELSE
              Lv_crearSolicitudes := 'N';
            END IF;
            IF Lv_crearSolicitudes = 'S' THEN 
            
              FOR histoTarea IN C_GET_HISTORIAL_TAREA(Lv_EmpresaCod,
                                                      tareasFinalizadas.TAREA_ID,
                                                      tareasFinalizadas.detalle_id) LOOP    
        
                IF C_ADMI_HORA_EMPLE_LINEA_BASE%ISOPEN THEN
                  CLOSE C_ADMI_HORA_EMPLE_LINEA_BASE;
                END IF;
        
                OPEN C_ADMI_HORA_EMPLE_LINEA_BASE(Lv_EmpresaCod,
                                                  'Activo',
                                                  TO_NUMBER(histoTarea.no_emple),
                                                  histoTarea.FECHA_INICIO,
                                                  histoTarea.FECHA_FIN);
                FETCH C_ADMI_HORA_EMPLE_LINEA_BASE
                  INTO Lc_PlaniLineBase;
                CLOSE C_ADMI_HORA_EMPLE_LINEA_BASE;
        
                IF C_DATOS_EMPLE%ISOPEN THEN
                  CLOSE C_DATOS_EMPLE;
                END IF;
        
                OPEN C_DATOS_EMPLE(Lv_EmpresaCod, histoTarea.NO_EMPLE);
                FETCH C_DATOS_EMPLE
                  INTO Lc_DatosEMple;
                CLOSE C_DATOS_EMPLE;   
                
                IF Lc_PlaniLineBase.FECHA_INICIO IS NOT NULL AND histoTarea.TOTAL_HORAS<=Ln_NumeroHoras then
        
                       IF to_date(histoTarea.FECHA_FIN, 'DD-MM-YYYY') > to_date(histoTarea.FECHA_INICIO, 'DD-MM-YYYY') THEN
                        Lc_horariosTarea_tmp := histoTarea;
                        Lc_horariosTarea_tmp.HORA_FIN:='23:59';
                        Lc_horariosTarea_tmp.FECHA_FIN:=histoTarea.FECHA_INICIO;
                        Lc_horariosTareaEnviar := C_GET_HISTORIAL_TAREA_TYPE(Lc_horariosTarea_tmp);

                        IF histoTarea.HORA_FIN <= '06:00' AND histoTarea.HORA_FIN > '00:00' THEN
                          Lc_horariosTareaEnviar.extend;
                          Lc_horariosTarea_tmp := histoTarea;
                          Lc_horariosTarea_tmp.HORA_INICIO:='00:00';
                          Lc_horariosTarea_tmp.FECHA_INICIO:=histoTarea.FECHA_FIN;
                          Lc_horariosTareaEnviar(2):=Lc_horariosTarea_tmp;
                        ELSIF histoTarea.HORA_FIN >= '06:00' AND histoTarea.HORA_FIN > '00:00' THEN
                          Lc_horariosTareaEnviar.extend;
                          Lc_horariosTarea_tmp := histoTarea;
                          Lc_horariosTarea_tmp.HORA_INICIO:='00:00';
                          Lc_horariosTarea_tmp.HORA_FIN:='06:00';
                          Lc_horariosTarea_tmp.FECHA_INICIO:=histoTarea.FECHA_FIN;
                          Lc_horariosTareaEnviar(2):=Lc_horariosTarea_tmp;
                          
                          Lc_horariosTareaEnviar.extend;
                          Lc_horariosTarea_tmp1 := histoTarea;
                          Lc_horariosTarea_tmp1.HORA_INICIO:='06:00';
                          Lc_horariosTarea_tmp1.FECHA_INICIO:=histoTarea.FECHA_FIN;
                          Lc_horariosTareaEnviar(3):=Lc_horariosTarea_tmp1;
                        END IF;

                       ELSE
                          IF histoTarea.HORA_INICIO >='00:00' AND histoTarea.HORA_INICIO <'06:00' AND histoTarea.HORA_FIN > '06:00' THEN
                            Lc_horariosTarea_tmp := histoTarea;
                            Lc_horariosTarea_tmp.HORA_FIN:='06:00';
                            Lc_horariosTareaEnviar := C_GET_HISTORIAL_TAREA_TYPE(Lc_horariosTarea_tmp);
                              
                            Lc_horariosTareaEnviar.extend;
                            Lc_horariosTarea_tmp := histoTarea;
                            Lc_horariosTarea_tmp.HORA_INICIO:='06:00';
                            Lc_horariosTareaEnviar(2):=Lc_horariosTarea_tmp;
                            
                          ELSE 
                            Lc_horariosTareaEnviar := C_GET_HISTORIAL_TAREA_TYPE(histoTarea);
                            
                          END IF;
                       END IF;

                      Ln_ContadorRegistros:=Lc_horariosTareaEnviar.count;

                       WHILE Ln_ContadorReg <=  Ln_ContadorRegistros LOOP
                              lv_regjson := chr(10) || lpad(' ', 6, ' ') || '{' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"noEmpleado":[' ||
                                            Lc_horariosTareaEnviar(Ln_ContadorReg).NO_EMPLE || '],' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"fecha":"' ||
                                            Lc_horariosTareaEnviar(Ln_ContadorReg).FECHA_INICIO  || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"horaInicio":"' ||
                                            Lc_horariosTareaEnviar(Ln_ContadorReg).HORA_INICIO  || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"horaFin":"' ||
                                            Lc_horariosTareaEnviar(Ln_ContadorReg)
                                            .HORA_FIN || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"observacion":"' ||
                                            Lv_Observacion || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"estado":"' ||
                                            Lv_estadoSolicitud || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"empresaCod":"' ||
                                            Lv_EmpresaCod || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"usrCreacion":"' ||
                                            Lv_userCreacion || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"tareaId":[' ||
                                            tareasFinalizadas.numero_tarea ||  '],'  || chr(10) ||
                                            lpad(' ', 9, ' ') || '"nombreDocumento":[],' ||
                                            chr(10) || lpad(' ', 9, ' ') ||
                                            '"ubicacionDocumento":[],' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"jornadaEmpleado":"' || 'M' || '",' ||
                                            chr(10) || lpad(' ', 9, ' ') || '"esFinDeSemana":"' || 'N' || '",' ||
                                            chr(10) || lpad(' ', 9, ' ') || '"esDiaLibre":"' || 'N' || '",' ||
                                            chr(10) || lpad(' ', 9, ' ') || '"descripcion":"' || 'Unitaria' || '",' ||
                                            chr(10) || lpad(' ', 9, ' ') || '"idCuadrilla":"' || null || '",' ||
                                            chr(10) || lpad(' ', 9, ' ') || '"nombreArea":"' ||
                                            Lc_DatosEMple.NOMBRE_AREA || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"feInicioTarea":["' ||
                                            Lc_horariosTareaEnviar(Ln_ContadorReg).FECHA_INICIO_HE || '"],'  || chr(10) ||
                                            lpad(' ', 9, ' ') || '"feFinTarea":["' ||
                                            Lc_horariosTareaEnviar(Ln_ContadorReg).FECHA_FIN_HE || '"],'  || chr(10) ||
                                            lpad(' ', 9, ' ') || '"nombreDepartamento":"' ||
                                            Lc_DatosEMple.NOMBRE_DEPTO || '",' || chr(10) ||
                                            lpad(' ', 9, ' ') || '"esSuperUsuario":"' || 'N' || '"' ||
                                            chr(10) || lpad(' ', 6, ' ') || '}';
                              DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA(lv_regjson,
                                                                                                Lv_Status,
                                                                                                Lv_Error);
                              
                              IF Lv_Status = 'ERROR' THEN
                                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                                     'HEKG_HORASEXTRAS_TRANSACCION.P_GENERA_HE_VERIFICACION',
                                                                     Lv_Error,
                                                                     NVL(SYS_CONTEXT('USERENV',
                                                                                     'HOST'),
                                                                         'DB_HORAS_EXTRAS'),
                                                                     SYSDATE,
                                                                     NVL(SYS_CONTEXT('USERENV',
                                                                                     'IP_ADDRESS'),
                                                                         '127.0.0.1'));                                       
                              END IF;
        
                              Ln_ContadorReg := Ln_ContadorReg + 1;
        
                        END LOOP; 
                        Ln_ContadorReg :=1;
                        Ln_ContadorRegistros :=0;
                                    
                END IF;
        
              END LOOP;
              --FIN DEL FOR C_GET_HISTORIAL_TAREA
            END IF;
            Lv_crearSolicitudes := 'N';
          
        END LOOP;
        
    END LOOP;
    
    COMMIT;
  EXCEPTION
    WHEN Le_Exception THEN 	


      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_GENERA_HE_VERIFICACION',
                                           Pv_Error || ' - ' || SQLCODE ||
                                           ' -ERROR- ' || SQLERRM ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_HORAS_EXTRAS'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));

    WHEN OTHERS THEN 


      Pv_Error := SQLCODE || ' -ERROR- ' || SQLERRM || ' ' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' ||
                  DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_GENERA_HE_VERIFICACION',
                                           Pv_Error,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_HORAS_EXTRAS'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_GENERA_HE_VERIFICACION;

  PROCEDURE P_GEN_HE_AUTO_TAREAS_TECNICA AS

      CURSOR C_GET_HISTORIAL_TAREA(Cn_EmpresaCod NUMBER,
                                   CV_ESTADO VARCHAR2,
                                   CV_TIPO_ASIGNADO VARCHAR2,
                                   CN_NumeroDias NUMBER) IS

        SELECT Q3.USR_CREACION,
          Q3.TOTAL_MINUTOS
        FROM
          (SELECT Q1.NO_EMPLE,
            Q1.USR_CREACION,
            SUM(TRUNC(24*60* (to_date(TO_CHAR(Q2.FECHA, 'DD-MM-YYYY')
            || ' '
            || TO_CHAR(Q2.FECHA, 'HH24:MI'), 'DD-MM-YYYY HH24:MI') - to_date(TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY')
            || ' '
            || TO_CHAR(Q1.FE_CREACION, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')))) TOTAL_MINUTOS
          FROM
            (SELECT IDH1.DETALLE_ID,
              VE.NO_EMPLE,
              IDH1.USR_CREACION,
              IDH1.FE_CREACION
            FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH1
            JOIN DB_SOPORTE.INFO_DETALLE IDE1
            ON IDE1.ID_DETALLE = IDH1.DETALLE_ID
            JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
            ON VE.LOGIN_EMPLE      = IDH1.USR_CREACION
            AND VE.NO_CIA          = Cn_EmpresaCod
            AND VE.NOMBRE_DEPTO IN (SELECT PARDET.VALOR1 AS NOMBRE_DEPTO
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_TECNICA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. TEC. (ATENCION AL USUARIO) PARA JOB BARRIDO DE TAREA Y GENERACION DE HE AUTORIZADAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo')
            WHERE IDH1.DETALLE_ID IN
              (SELECT IT.DETALLE_ID
              FROM DB_SOPORTE.INFO_TAREA IT
              WHERE IT.ESTADO                          = CV_ESTADO
              AND IT.TIPO_ASIGNADO                     = CV_TIPO_ASIGNADO
              AND PROCESO_ID <>1477
              AND TO_CHAR(IT.FE_ULT_MOD, 'DD-MM-YYYY') = TO_CHAR(SYSDATE-CN_NumeroDias, 'DD-MM-YYYY')
              )
            AND (IDH1.ESTADO IN ('Aceptada')
            AND IDH1.ACCION  IN ('Ejecutada'))
            ) Q1,
            (SELECT IDH.DETALLE_ID,
              IDH.USR_CREACION USER_CREACION,
              IDH.FE_CREACION fecha
            FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
            JOIN DB_SOPORTE.INFO_DETALLE IDE
            ON IDE.ID_DETALLE     = IDH.DETALLE_ID
            WHERE IDH.DETALLE_ID IN
              (SELECT IT.DETALLE_ID
              FROM DB_SOPORTE.INFO_TAREA IT
              WHERE IT.ESTADO                          = CV_ESTADO
              AND IT.TIPO_ASIGNADO                     = CV_TIPO_ASIGNADO
              AND TO_CHAR(IT.FE_ULT_MOD, 'DD-MM-YYYY') = TO_CHAR(SYSDATE-CN_NumeroDias, 'DD-MM-YYYY')
              )
            AND ((IDH.ESTADO = 'Asignada'
            AND IDH.ACCION   = 'Reasignada')
            OR (IDH.ESTADO   = 'Finalizada'
            AND IDH.ACCION   = 'Finalizada'))
            ) Q2
          WHERE Q1.USR_CREACION = Q2.USER_CREACION
          AND Q1.DETALLE_ID     = Q2.DETALLE_ID
          GROUP BY Q1.NO_EMPLE,
            Q1.USR_CREACION
          ) Q3
        WHERE Q3.TOTAL_MINUTOS/60>8
        ORDER BY Q3.USR_CREACION ASC;

       CURSOR C_GET_DETALLE_TAREA(Cn_EmpresaCod NUMBER,
                                  CV_ESTADO VARCHAR2,
                                  CV_TIPO_ASIGNADO VARCHAR2,
                                  CV_USR_CREACION VARCHAR2,
                                  CN_NumeroDias NUMBER) IS

       SELECT Q3.*
        FROM
          (SELECT TO_CHAR(Q1.NUMERO_TAREA) NUMERO_TAREA,
              TO_CHAR(Q1.DETALLE_ID) DETALLE_ID,  
              Q1.ASIGNADO_ID,
              Q1.USR_CREACION,
              TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY') FECHA_INICIO,
              TO_CHAR(Q2.FECHA, 'DD-MM-YYYY') FECHA_FIN,
              TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY HH24:MI') FECHA_INICIO_HE,
              TO_CHAR(Q2.FECHA, 'DD-MM-YYYY HH24:MI') FECHA_FIN_HE,
              TO_CHAR(Q1.FE_CREACION, 'HH24:MI') HORA_INICIO,
              TO_CHAR(Q2.FECHA, 'HH24:MI') HORA_FIN,
              (TRUNC(24*60* (to_date(TO_CHAR(Q2.FECHA, 'DD-MM-YYYY')
              || ' '
              || TO_CHAR(Q2.FECHA, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')- to_date(TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY')
              || ' '
              || TO_CHAR(Q1.FE_CREACION, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')))) TOTAL_MINUTOS
            FROM
              (SELECT IT.NUMERO_TAREA,
                      IDH1.DETALLE_ID,
                      IT.ASIGNADO_ID,
                      IDH1.USR_CREACION,
                      IDH1.FE_CREACION
              FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH1
              JOIN DB_SOPORTE.INFO_DETALLE IDE1
              ON IDE1.ID_DETALLE = IDH1.DETALLE_ID
              JOIN DB_SOPORTE.INFO_TAREA IT
              ON IT.DETALLE_ID = IDH1.DETALLE_ID
              AND IT.DETALLE_ID IN
                (SELECT IT.DETALLE_ID
                FROM DB_SOPORTE.INFO_TAREA IT
                WHERE IT.ESTADO                          = CV_ESTADO
                AND IT.TIPO_ASIGNADO                     = CV_TIPO_ASIGNADO
                AND PROCESO_ID <>1477
                AND TO_CHAR(IT.FE_ULT_MOD, 'DD-MM-YYYY') = TO_CHAR(SYSDATE-CN_NumeroDias, 'DD-MM-YYYY')
                )
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
              ON VE.LOGIN_EMPLE      = IDH1.USR_CREACION
              AND VE.NO_CIA          = Cn_EmpresaCod
              AND VE.NOMBRE_DEPTO IN (SELECT PARDET.VALOR1 AS NOMBRE_DEPTO
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_TECNICA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. TEC. (ATENCION AL USUARIO) PARA JOB BARRIDO DE TAREA Y GENERACION DE HE AUTORIZADAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo')
              WHERE (IDH1.ESTADO IN ('Aceptada')
              AND IDH1.ACCION  IN ('Ejecutada'))
              ) Q1,
              (SELECT IT.NUMERO_TAREA,
                      IDH.DETALLE_ID,
                      IT.ASIGNADO_ID,
                      IDH.USR_CREACION USER_CREACION,
                      IDH.FE_CREACION fecha
                 FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
                 JOIN DB_SOPORTE.INFO_DETALLE IDE
                   ON IDE.ID_DETALLE     = IDH.DETALLE_ID
                 JOIN DB_SOPORTE.INFO_TAREA IT
                   ON IT.DETALLE_ID = IDH.DETALLE_ID  
                  AND IT.DETALLE_ID IN
                  (SELECT IT.DETALLE_ID
                  FROM DB_SOPORTE.INFO_TAREA IT
                  WHERE IT.ESTADO                          = CV_ESTADO
                  AND IT.TIPO_ASIGNADO                     = CV_TIPO_ASIGNADO
                  AND TO_CHAR(IT.FE_ULT_MOD, 'DD-MM-YYYY') = TO_CHAR(SYSDATE-CN_NumeroDias, 'DD-MM-YYYY')
                  )
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
              ON VE.LOGIN_EMPLE      = IDH.USR_CREACION
              AND VE.NO_CIA          = Cn_EmpresaCod
              AND VE.NOMBRE_DEPTO IN (SELECT PARDET.VALOR1 AS NOMBRE_DEPTO
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_TECNICA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. TEC. (ATENCION AL USUARIO) PARA JOB BARRIDO DE TAREA Y GENERACION DE HE AUTORIZADAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo')
              WHERE ((IDH.ESTADO ='Asignada'
              AND IDH.ACCION   ='Reasignada')
              OR (IDH.ESTADO   = 'Finalizada'
              AND IDH.ACCION   = 'Finalizada'))
              ) Q2
            WHERE Q1.USR_CREACION = Q2.USER_CREACION
            AND Q1.DETALLE_ID     = Q2.DETALLE_ID
            AND Q1.NUMERO_TAREA   = Q2.NUMERO_TAREA
            AND Q1.ASIGNADO_ID    = Q2.ASIGNADO_ID
            AND Q1.USR_CREACION   = CV_USR_CREACION) Q3
        WHERE Q3.TOTAL_MINUTOS>0
        ORDER BY Q3.NUMERO_TAREA,Q3.DETALLE_ID,Q3.FECHA_INICIO ASC;   

        CURSOR C_GET_DET_TAREA_GENE_HE(Cn_EmpresaCod NUMBER,
                                  CV_ESTADO VARCHAR2,
                                  CV_TIPO_ASIGNADO VARCHAR2,
                                  CV_USR_CREACION VARCHAR2,
                                  CV_NUMEROS_TAREAS VARCHAR2,
                                  CV_DETALLES_ID VARCHAR2,
                                  CN_NumeroDias NUMBER) IS                                  

        SELECT Q3.*
          FROM
          (SELECT TO_CHAR(Q1.NUMERO_TAREA) NUMERO_TAREA,
              TO_CHAR(Q1.DETALLE_ID) DETALLE_ID,  
              Q1.ASIGNADO_ID,
              Q1.USR_CREACION,
              TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY') FECHA_INICIO,
              TO_CHAR(Q2.FECHA, 'DD-MM-YYYY') FECHA_FIN,
              TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY HH24:MI') FECHA_INICIO_HE,
              TO_CHAR(Q2.FECHA, 'DD-MM-YYYY HH24:MI') FECHA_FIN_HE,
              TO_CHAR(Q1.FE_CREACION, 'HH24:MI') HORA_INICIO,
              TO_CHAR(Q2.FECHA, 'HH24:MI') HORA_FIN,
              (TRUNC(24*60* (to_date(TO_CHAR(Q2.FECHA, 'DD-MM-YYYY')
              || ' '
              || TO_CHAR(Q2.FECHA, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')- to_date(TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY')
              || ' '
              || TO_CHAR(Q1.FE_CREACION, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')))) TOTAL_MINUTOS
            FROM
              (SELECT IT.NUMERO_TAREA,
                      IDH1.DETALLE_ID,
                      IT.ASIGNADO_ID,
                      IDH1.USR_CREACION,
                      IDH1.FE_CREACION
              FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH1
              JOIN DB_SOPORTE.INFO_DETALLE IDE1
              ON IDE1.ID_DETALLE = IDH1.DETALLE_ID
              JOIN DB_SOPORTE.INFO_TAREA IT
              ON IT.DETALLE_ID = IDH1.DETALLE_ID
              AND IT.DETALLE_ID IN
                (SELECT IT.DETALLE_ID
                FROM DB_SOPORTE.INFO_TAREA IT
                WHERE IT.ESTADO                          = CV_ESTADO
                AND IT.TIPO_ASIGNADO                     = CV_TIPO_ASIGNADO
                AND TO_CHAR(IT.FE_ULT_MOD, 'DD-MM-YYYY') = TO_CHAR(SYSDATE-CN_NumeroDias, 'DD-MM-YYYY')
                )
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
              ON VE.LOGIN_EMPLE      = IDH1.USR_CREACION
              AND VE.NO_CIA          = Cn_EmpresaCod
              AND VE.NOMBRE_DEPTO IN (SELECT PARDET.VALOR1 AS NOMBRE_DEPTO
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_TECNICA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. TEC. (ATENCION AL USUARIO) PARA JOB BARRIDO DE TAREA Y GENERACION DE HE AUTORIZADAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo')
              WHERE (IDH1.ESTADO IN ('Aceptada')
              AND IDH1.ACCION  IN ('Ejecutada'))
              ) Q1,
              (SELECT IT.NUMERO_TAREA,
                      IDH.DETALLE_ID,
                      IT.ASIGNADO_ID,
                      IDH.USR_CREACION USER_CREACION,
                      IDH.FE_CREACION fecha
                 FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
                 JOIN DB_SOPORTE.INFO_DETALLE IDE
                   ON IDE.ID_DETALLE     = IDH.DETALLE_ID
                 JOIN DB_SOPORTE.INFO_TAREA IT
                   ON IT.DETALLE_ID = IDH.DETALLE_ID  
                  AND IT.DETALLE_ID IN
                  (SELECT IT.DETALLE_ID
                  FROM DB_SOPORTE.INFO_TAREA IT
                  WHERE IT.ESTADO                          = CV_ESTADO
                  AND IT.TIPO_ASIGNADO                     = CV_TIPO_ASIGNADO
                  AND PROCESO_ID <>1477
                  AND TO_CHAR(IT.FE_ULT_MOD, 'DD-MM-YYYY') = TO_CHAR(SYSDATE-CN_NumeroDias, 'DD-MM-YYYY')
                  )
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
              ON VE.LOGIN_EMPLE      = IDH.USR_CREACION
              AND VE.NO_CIA          = Cn_EmpresaCod
              AND VE.NOMBRE_DEPTO IN (SELECT PARDET.VALOR1 AS NOMBRE_DEPTO
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_TECNICA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. TEC. (ATENCION AL USUARIO) PARA JOB BARRIDO DE TAREA Y GENERACION DE HE AUTORIZADAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo')
              WHERE ((IDH.ESTADO ='Asignada'
              AND IDH.ACCION   ='Reasignada')
              OR (IDH.ESTADO   = 'Finalizada'
              AND IDH.ACCION   = 'Finalizada'))
              ) Q2
            WHERE Q1.USR_CREACION = Q2.USER_CREACION
            AND Q1.DETALLE_ID     = Q2.DETALLE_ID
            AND Q1.NUMERO_TAREA   = Q2.NUMERO_TAREA
            AND Q1.ASIGNADO_ID    = Q2.ASIGNADO_ID
            AND Q1.USR_CREACION   = CV_USR_CREACION) Q3
        WHERE Q3.TOTAL_MINUTOS>0
         AND Q3.NUMERO_TAREA IN (CV_NUMEROS_TAREAS)
         AND Q3.DETALLE_ID IN (CV_DETALLES_ID)
        ORDER BY Q3.NUMERO_TAREA,Q3.DETALLE_ID,Q3.FECHA_INICIO ASC;   

    CURSOR C_EMPLE_CUADRILLA(Cv_EmpresaCod VARCHAR2, Cv_IdCuadrilla NUMBER) IS
         SELECT VEE.NO_EMPLE
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE
        WHERE VEE.LOGIN_EMPLE IN
          (SELECT ip.login
          FROM DB_COMERCIAL.info_persona ip
          WHERE ip.id_persona IN
            (SELECT IPER.persona_id
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
            WHERE IPER.cuadrilla_id =Cv_IdCuadrilla
            AND IPER.ESTADO         ='Activo'
            )
          AND ip.ESTADO = 'Activo'
          )
        AND VEE.NO_CIA = Cv_EmpresaCod;


     CURSOR C_DIAS_TAREA(Cv_FechaInicio VARCHAR2, Cv_FechaFin VARCHAR2) IS
      SELECT (TO_DATE(Cv_FechaFin,'DD/MM/YYYY') - TO_DATE(Cv_FechaInicio,'DD/MM/YYYY')) CANTIDAD FROM DUAL;


    Type C_GET_DETALLE_TAREA_TYPE IS VARRAY(5) OF C_GET_DETALLE_TAREA%ROWTYPE;

    Lr_Cantidad           C_DIAS_TAREA%ROWTYPE;  
    Lc_TareaEnviar        C_GET_DETALLE_TAREA_TYPE;        
    Ln_NumHorasExtras     NUMBER;
    Ln_NumHE              NUMBER;
    Ln_EmpresaCod         NUMBER;
    Ln_ContadorRegistros  NUMBER;
    Ln_ContadorReg        NUMBER;    
    Ln_NumeroHoras        NUMBER;    
    Ln_NumeroDias         NUMBER; 
    Lv_NomArea            VARCHAR2(25);
    Lv_NomDep             VARCHAR2(25);
    Lv_EstadoTarea        VARCHAR2(20);
    Lv_estadoSolicitud    VARCHAR2(20);
    Lv_Observacion        VARCHAR2(200);
    Lv_userCreacion       VARCHAR2(15);
    Lv_Status             VARCHAR2(10);
    Lv_Error              VARCHAR2(1000);
    Lv_regjson            CLOB;
    Lv_TareaId            CLOB;
    Lv_DetalleId          CLOB;
    Lv_no_emples          CLOB;
    Le_Exception          EXCEPTION;

  BEGIN

    Ln_EmpresaCod        := 10;
    Lv_EstadoTarea       := 'Finalizada';
    Lv_Observacion       := 'Origen Solicitud Job barrido de tareas por departamentos tecnica';
    Lv_userCreacion      := 'Horas_Extras';
    Ln_ContadorRegistros := 0;
    Ln_ContadorReg       := 1;
    Ln_NumHorasExtras    := 0;

    IF Ln_EmpresaCod IS NULL THEN
      Lv_Error := 'El parámetro empresaCod está vacío';
      RAISE Le_Exception;
    END IF;

   SELECT PARDET.VALOR1 AS TOTAL_HORAS
     INTO Ln_NumeroHoras
     FROM DB_GENERAL.admi_parametro_cab PARCAB,
          DB_GENERAL.admi_parametro_det PARDET
    WHERE PARCAB.Nombre_parametro = 'TOTAL DE HORAS EXTRAS'
      AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
      AND PARDET.DESCRIPCION = 'NUMERO TOTAL DE HORAS EXTRAS PARA GENERAR SOLICITUD DESDE UNA TAREA TIPO PROCESO HORAS EXTRAS'
      AND PARDET.ESTADO = 'Activo' 
      AND PARCAB.ESTADO = 'Activo'; 

   SELECT PARDET.VALOR1 AS ESTADO
     INTO Lv_estadoSolicitud
     FROM DB_GENERAL.admi_parametro_cab PARCAB,
          DB_GENERAL.admi_parametro_det PARDET
    WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS TECNICA'
      AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
      AND PARDET.DESCRIPCION = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA'
      AND PARDET.ESTADO = 'Activo' 
      AND PARCAB.ESTADO = 'Activo'; 


   SELECT PARDET.VALOR1 AS NUMERO
     INTO Ln_NumeroDias
     FROM DB_GENERAL.admi_parametro_cab PARCAB,
          DB_GENERAL.admi_parametro_det PARDET
    WHERE PARCAB.Nombre_parametro = 'NUMERO DIAS PARA BARRIDO TAREAS'
      AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
      AND PARDET.DESCRIPCION = 'NUMERO DIAS PARA BARRIDO TAREAS'
      AND PARDET.ESTADO = 'Activo' 
      AND PARCAB.ESTADO = 'Activo'; 


      FOR histoTarea IN C_GET_HISTORIAL_TAREA(Ln_EmpresaCod,
                                              Lv_EstadoTarea,
                                              'CUADRILLA',
                                              Ln_NumeroDias) LOOP                                       
         FOR detaTarea IN C_GET_DETALLE_TAREA(Ln_EmpresaCod,
                                              Lv_EstadoTarea,
                                              'CUADRILLA',
                                              histoTarea.USR_CREACION,
                                              Ln_NumeroDias) LOOP    

            IF Ln_NumHorasExtras!=0 THEN
               IF ((Ln_NumHorasExtras + detaTarea.TOTAL_MINUTOS)/60)>8 THEN                  
                    IF Lv_TareaId is null THEN 
                        Lv_TareaId := detaTarea.NUMERO_TAREA;
                        Lv_DetalleId := detaTarea.DETALLE_ID;
                    ELSE    
                        Lv_TareaId := Lv_TareaId || ',' || detaTarea.NUMERO_TAREA;
                        Lv_DetalleId := Lv_DetalleId || ',' || detaTarea.DETALLE_ID;
                    END IF;
               END IF;
               Ln_NumHorasExtras := Ln_NumHorasExtras + detaTarea.TOTAL_MINUTOS;
            ELSE
               Ln_NumHorasExtras := detaTarea.TOTAL_MINUTOS;
            END IF;
        END LOOP;

        FOR TareHE IN C_GET_DET_TAREA_GENE_HE(Ln_EmpresaCod,
                                               Lv_EstadoTarea,
                                               'CUADRILLA',
                                                  histoTarea.USR_CREACION,
                                                  Lv_TareaId,
                                                  Lv_DetalleId,
                                                  Ln_NumeroDias) LOOP                                                    

              SELECT VEE.NOMBRE_AREA,
                   VEE.NOMBRE_DEPTO
                    INTO Lv_NomArea,Lv_NomDep
                  FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE
                  WHERE VEE.LOGIN_EMPLE IN
                    (SELECT ip.login
                    FROM DB_COMERCIAL.info_persona ip
                    WHERE ip.id_persona IN
                      (SELECT IPER.persona_id
                      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                      WHERE IPER.cuadrilla_id =TareHE.ASIGNADO_ID
                      AND IPER.ESTADO         ='Activo'
                      )
                    AND ip.ESTADO = 'Activo'
                    )
                  AND VEE.NO_CIA = Ln_EmpresaCod
                  GROUP BY VEE.AREA,
                    VEE.NOMBRE_AREA,
                    VEE.DEPTO,
                    VEE.NOMBRE_DEPTO;

            FOR integrantesCuadrilla IN C_EMPLE_CUADRILLA(Ln_EmpresaCod, TareHE.ASIGNADO_ID) LOOP  
                 IF Lv_no_emples is null THEN 
                      Lv_no_emples := integrantesCuadrilla.NO_EMPLE;
                  ELSE   
                      Lv_no_emples := Lv_no_emples || ',' || integrantesCuadrilla.NO_EMPLE;
                  END IF;                                    
            END LOOP;    
      

              lv_regjson := chr(10) || lpad(' ', 6, ' ') || '{' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"noEmpleado":[' ||
                                    Lv_no_emples || '],' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"fecha":"' ||
                                    TareHE.FECHA_INICIO  || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"horaInicio":"' ||
                                    TareHE.HORA_INICIO  || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"horaFin":"' ||
                                    TareHE.HORA_FIN || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"observacion":"' ||
                                    Lv_Observacion || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"estado":"' ||
                                    Lv_estadoSolicitud || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"empresaCod":"' ||
                                    Ln_EmpresaCod || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"usrCreacion":"' ||
                                    Lv_userCreacion || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"tareaId":[' ||
                                    TareHE.numero_tarea ||  '],'  || chr(10) ||
                                    lpad(' ', 9, ' ') || '"nombreDocumento":[],' ||
                                    chr(10) || lpad(' ', 9, ' ') ||
                                    '"ubicacionDocumento":[],' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"jornadaEmpleado":"' || 'N' || '",' ||
                                    chr(10) || lpad(' ', 9, ' ') || '"esFinDeSemana":"' || 'N' || '",' ||
                                    chr(10) || lpad(' ', 9, ' ') || '"esDiaLibre":"' || 'N' || '",' ||
                                    chr(10) || lpad(' ', 9, ' ') || '"descripcion":"' || 'UNIF_CUAD_SM' || '",' ||
                                    chr(10) || lpad(' ', 9, ' ') || '"idCuadrilla":"' || TareHE.ASIGNADO_ID || '",' ||
                                    chr(10) || lpad(' ', 9, ' ') || '"nombreArea":"' ||
                                    Lv_NomArea || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"feInicioTarea":["' ||
                                    TareHE.FECHA_INICIO_HE || '"],'  || chr(10) ||
                                    lpad(' ', 9, ' ') || '"feFinTarea":["' ||
                                    TareHE.FECHA_FIN_HE || '"],'  || chr(10) ||
                                    lpad(' ', 9, ' ') || '"nombreDepartamento":"' ||
                                    Lv_NomDep || '",' || chr(10) ||
                                    lpad(' ', 9, ' ') || '"esSuperUsuario":"' || 'N' || '"' ||
                                    chr(10) || lpad(' ', 6, ' ') || '}';

                      DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA(lv_regjson,
                                                                                        Lv_Status,
                                                                                        Lv_Error);

                      IF Lv_Status = 'ERROR' THEN
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                             'HEKG_HORASEXTRAS_TRANSACCION.P_GEN_HE_AUTO_TAREAS_TECNICA',
                                                             Lv_Error,
                                                             NVL(SYS_CONTEXT('USERENV',
                                                                             'HOST'),
                                                                 'DB_HORAS_EXTRAS'),
                                                             SYSDATE,
                                                             NVL(SYS_CONTEXT('USERENV',
                                                                             'IP_ADDRESS'),
                                                                 '127.0.0.1'));                                       
                      END IF;  
        END LOOP;                       

        Lv_TareaId        := '';
        Lv_DetalleId      := '';
        Lv_no_emples      := '';
        Ln_NumHorasExtras := 0;                                    

    END LOOP;
    COMMIT;
  EXCEPTION
    WHEN Le_Exception THEN 			   

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_GEN_HE_AUTO_TAREAS_TECNICA',
                                           Lv_Error || ' - ' || SQLCODE ||
                                           ' -ERROR- ' || SQLERRM ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_HORAS_EXTRAS'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));

    WHEN OTHERS THEN 

      Lv_Error := SQLCODE || ' -ERROR- ' || SQLERRM || ' ' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' ||
                  DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_GEN_HE_AUTO_TAREAS_TECNICA',
                                           Lv_Error,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_HORAS_EXTRAS'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_GEN_HE_AUTO_TAREAS_TECNICA;

PROCEDURE P_GENERA_HE_VERI_TAREAS_ADMI AS
      
      Ld_HoraInicio2                 DATE;
      Ld_HoraFin2                    DATE;
      Ld_HorasInicioNocturnas1       DATE;
      Ld_HorasFinNocturnas1          DATE;
      Ld_HoraInicioDia               DATE;
      Ld_FechaCorte                  DATE;
      ln_cont                        number:= 0;
      Ln_numero_for                  NUMBER:=0;    
      Ln_ContadorTemp                NUMBER := 0;
      Lv_NumeroMesRestar             VARCHAR2(7);
      Lv_crearSolicitudes            VARCHAR2(7):= 'N';
      Lv_configDepa                  VARCHAR2(7):= null;
      lv_fechaInicioSemana           VARCHAR2(20);
      lv_fechaFinSemana              VARCHAR2(20);
      Lv_Canton                      VARCHAR2(30):= NULL; 
      Lv_Provincia                   VARCHAR2(30):= NULL;
      Lv_Canton1                     VARCHAR2(30):= NULL; 
      Lv_Provincia1                  VARCHAR2(30):= NULL;
      Ld_Fecha                       VARCHAR2(25);
      lv_fechaInicioLineaBase        VARCHAR2(20);
      lv_fechaFinLineaBase           VARCHAR2(20);
      lv_numeroFechaInicio           NUMBER := 0;
      lv_numeroFcehaFin              NUMBER := 0;
      lv_reverse                     NUMBER:= 0;
      lv_horaInicioLineaBaseTemp     VARCHAR2(20);
      lv_horaFinLineaBaseTemp        VARCHAR2(20);
      lv_fechaHETemp                 VARCHAR2(20):= NULL;
      lv_horaInicioHETemp            VARCHAR2(20):= NULL;
      lv_horaFinHETemp               VARCHAR2(20):= NULL;
      lv_no_emple                    VARCHAR2(450);
      lv_regjson                     CLOB;
      ln_empresacod                  NUMBER;
      ln_numerodias                  NUMBER;
      Ln_total_linea_base            NUMBER:=0;
      Ln_numero_tareas               NUMBER:=0;
      lv_status                      VARCHAR2(10);
      lv_error                       VARCHAR2(1000);
      lv_trama                       NUMBER := 0;
      lv_envia_trama                 NUMBER := 0;
      Ln_Contador                    NUMBER := 0;--- contador de indices para guardar datos en los arrays
      Ln_Contador1                   NUMBER := 0;
      Ln_contadorFeriado             NUMBER := 1;
      Ln_contadorFeriado1            NUMBER := 1;
      Lv_HorasInicioNocturnas        VARCHAR2(7);
      Lv_HorasFinNocturnas           VARCHAR2(7);
      Lv_EsDiaLibre                  VARCHAR2(7):= 'N';
      Lv_JornadaEmpleado             VARCHAR2(7);
      --Lv_EsFinDeSemana               VARCHAR2(7);
      lv_estadosolicitud             VARCHAR2(20);
      lv_observacion                 VARCHAR2(200);
      lv_usercreacion                VARCHAR2(15);
      Ld_HoraInicio1                 VARCHAR2(20);
      Ld_HoraFin1                    VARCHAR2(20);
      lv_fecha1                      VARCHAR2(10);
      lv_estadotarea                 VARCHAR2(20);
      lv_fecha_inicio1               VARCHAR2(20);
      lv_fecha_fin1                  VARCHAR2(20);
      Le_Exception                    EXCEPTION;

      CURSOR C_OBTENER_LINEA_BASE      (Cv_EmpresaCod VARCHAR2,
                                        Cv_Estado     VARCHAR2,
                                        Cv_NoEMple    VARCHAR2,
                                        Cv_FechaDesde VARCHAR2,
                                        Cv_FechaHasta VARCHAR2) IS                
         SELECT AHE.NO_EMPLE,
                 TO_CHAR(AHE.FECHA_INICIO,'DD-MM-YYYY') FECHA_INICIO,
                 TO_CHAR(AHE.FECHA_FIN,'DD-MM-YYYY') FECHA_FIN,
                 AHE.HORA_INICIO,
                 AHE.HORA_FIN,
                 IE.LOGIN_EMPLE
            FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
            JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
              ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
             AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
              INNER JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS IE
              ON IE.NO_EMPLE = AHE.NO_EMPLE
              AND IE.NO_CIA=Cv_EmpresaCod 
              AND IE.ESTADO ='A'
           WHERE AHE.EMPRESA_COD = Cv_EmpresaCod
             AND AHE.ESTADO = Cv_Estado
             AND IE.NO_EMPLE = Cv_NoEMple
             AND ((AHE.FECHA_INICIO >=
                 TO_DATE(Cv_FechaDesde, 'DD-MM-YYYY') AND
                 AHE.FECHA_INICIO <=
                 TO_DATE(Cv_FechaDesde, 'DD-MM-YYYY')) OR
                 (AHE.FECHA_FIN >=
                 TO_DATE(Cv_FechaHasta, 'DD-MM-YYYY') AND
                 AHE.FECHA_FIN <=
                 TO_DATE(Cv_FechaHasta, 'DD-MM-YYYY')));
                 
        --OBTINE LA LINEA BASE MENSUAL DEL EMPLEADO 
        CURSOR C_OBTENER_LINEA_BASE_MES(Cv_EmpresaCod VARCHAR2,
                                    Cv_Estado     VARCHAR2,
                                    Cv_NoEMple    VARCHAR2,
                                    Cv_FechaDesde VARCHAR2,
                                    Cv_FechaHasta VARCHAR2) IS
                 SELECT AHE.NO_EMPLE,
                 TO_CHAR(AHE.FECHA_INICIO,'DD-MM-YYYY') FECHA_INICIO,
                 TO_CHAR(AHE.FECHA_FIN,'DD-MM-YYYY') FECHA_FIN,
                 AHE.HORA_INICIO,
                 AHE.HORA_FIN
            FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
            JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
              ON ATH.ID_TIPO_HORARIO = AHE.TIPO_HORARIO_ID
             AND ATH.NOMBRE_TIPO_HORARIO = 'LINEA BASE'
           WHERE AHE.EMPRESA_COD = Cv_EmpresaCod
             AND AHE.ESTADO = Cv_Estado
             AND AHE.NO_EMPLE = Cv_NoEMple
             AND (TO_CHAR(AHE.FECHA_INICIO,'MM') = Cv_FechaDesde 
             AND TO_CHAR(AHE.FECHA_INICIO,'YYYY') = Cv_FechaHasta);
             
      --Cursor de feriado LOCAL
    CURSOR C_FERIADO_LOCAL (fecha VARCHAR2, nombreProvincia VARCHAR2)IS 
     SELECT p.DESCRIPCION PROVINCIA, c.DESCRIPCION CANTON
          --INTO Lv_Provincia, Lv_Canton
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          INNER JOIN NAF47_TNET.argepro p
          ON p.PROVINCIA = APD.VALOR6
          AND p.pais = '313'
          LEFT JOIN NAF47_TNET.argecan c
          ON p.PROVINCIA = c.PROVINCIA
          AND c.CANTON = APD.VALOR7
          AND C.pais = '313'
        WHERE APD.DESCRIPCION = 'MES_DIAS_FERIADO' 
          AND APD.VALOR3 = TO_CHAR(TO_DATE(fecha, 'DD-MM-YYYY'),'YYYY')
          AND TO_CHAR(TO_DATE(APD.VALOR2||'-'||APD.VALOR1||'-'||APD.VALOR3,'DD-MM-YYYY'), 'DD-MM-YYYY')= TO_CHAR(TO_DATE(fecha,'DD-MM-YYYY'), 'DD-MM-YYYY')
          AND APD.ESTADO = 'Activo'
          AND p.DESCRIPCION = nombreProvincia;
                     
----CURSOR QUE ME TRAE LOS DEPARTAMENTOS CONFIGURADOS   
      CURSOR C_DEPARTAMENTOS_CONFIGURADOS IS
          SELECT PARDET.VALOR1 AS NOMBRE_DEPTO,PARDET.VALOR2 AS TIPO_CREACION
             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                  DB_GENERAL.admi_parametro_det PARDET
            WHERE PARCAB.Nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
              AND PARDET.DESCRIPCION = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
              AND PARDET.ESTADO = 'Activo' 
              AND PARCAB.ESTADO = 'Activo';
              
      CURSOR C_LISTADO_EMPLEADOS (Cv_nombreDepartamento VARCHAR2)IS 
        SELECT NO_EMPLE, LOGIN_EMPLE, AREA, NOMBRE_AREA, DEPTO, NOMBRE_DEPTO, NO_CIA, OFICINA_PROVINCIA, OFICINA_CANTON, NOMBRE  
          FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS 
            WHERE NO_CIA=10 
              AND ESTADO ='A' 
              AND NOMBRE_DEPTO = Cv_nombreDepartamento;
              
              
            ---Se indentifica el primer y el ultimo del mes
      CURSOR C_MES_VENCIDO (FECHA VARCHAR2, NUMERO_RESTAR VARCHAR2)IS
         SELECT to_char(trunc(ADD_MONTHS(TO_DATE(FECHA,'DD-MM-YYYY'),-NUMERO_RESTAR),'MONTH'),'DD-MM-YYYY') primerDiaMes,
                to_char(last_day(trunc(ADD_MONTHS(TO_DATE(FECHA,'DD-MM-YYYY'),-NUMERO_RESTAR),'MONTH')),'DD-MM-YYYY') ultimoDiaMes 
             FROM dual;
      
      --- Se identifica si es un fin de semana        
      CURSOR C_FIN_DE_SEMANA (fecha VARCHAR2) IS
        SELECT 
            CASE WHEN TRIM(upper(to_char(TO_DATE(fecha,'DD/MM/YYYY'), 'DAY', 'NLS_DATE_LANGUAGE=SPANISH')))= 'SÁBADO' THEN 'S'
                 WHEN TRIM(upper(to_char(TO_DATE(fecha,'DD/MM/YYYY'), 'DAY', 'NLS_DATE_LANGUAGE=SPANISH')))= 'DOMINGO' THEN 'S'
            ELSE 'N' END AS FIN_SEMANA
        FROM dual;
      
      --Identifica si es un feriado nacional
      CURSOR C_FERIADO_NACIONAL (FECHA VARCHAR2) IS
        SELECT CANTIDAD
        FROM (SELECT COUNT(*)AS CANTIDAD FROM ADMI_PARAMETRO_DET 
        WHERE DESCRIPCION = 'MES_DIAS_FERIADO' 
            AND VALOR3 = TO_CHAR(TO_DATE(FECHA,'DD/MM/YYYY'), 'YYYY')
            AND TO_CHAR(TO_DATE(VALOR2||'-'||VALOR1||'-'||VALOR3), 'DD-MM-YYYY')= TO_CHAR(TO_DATE(FECHA,'DD/MM/YYYY'), 'DD-MM-YYYY')
            AND ESTADO = 'Activo'
            AND VALOR5 IS NULL);
            
      CURSOR C_DIA_CORTE_MES_VENCIDO IS
          SELECT APD.VALOR1 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
          ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
          WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_MES_VENCIDO';
      
      CURSOR c_get_historial_tarea (cn_empresacod    NUMBER,
                                    cv_estado        VARCHAR2,
                                    cv_tipo_asignado VARCHAR2,
                                    cn_numerodias    NUMBER) IS
          SELECT
              q3.no_emple,
              q3.usr_creacion
          FROM
              (
                  SELECT
                      q1.no_emple,
                      q1.usr_creacion
                  FROM
                      (
                          SELECT
                              ve.no_emple,
                              idh1.usr_creacion
                          FROM
                                   db_soporte.info_detalle_historial idh1
                              JOIN db_soporte.info_detalle         ide1 ON ide1.id_detalle = idh1.detalle_id
                              JOIN db_soporte.info_tarea           it ON it.detalle_id = idh1.detalle_id
                              JOIN naf47_tnet.v_empleados_empresas ve ON ve.login_emple = idh1.usr_creacion
                                                                         AND ve.no_cia = 10
                                                                         AND ve.nombre_depto IN (
                                  SELECT
                                      pardet.valor1 AS nombre_depto
                                  FROM
                                      db_general.admi_parametro_cab parcab, db_general.admi_parametro_det pardet
                                  WHERE
                                          parcab.nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
                                      AND pardet.parametro_id = parcab.id_parametro
                                      AND pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
                                      AND pardet.estado = 'Activo'
                                      AND parcab.estado = 'Activo'
                              )
                          WHERE
                              idh1.detalle_id IN ( SELECT it.detalle_id
                                  FROM db_soporte.info_tarea it
                                  WHERE it.estado IN ( 'Finalizada', 'Asignada', 'Pausada', 'Reprogramada','Cancelada')
                                      AND it.tipo_asignado = 'EMPLEADO'
                                      AND idh1.estado IN ('Aceptada')
                                      AND to_char(idh1.fe_creacion, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY')
                                      AND proceso_id <> ( SELECT id_proceso FROM  db_soporte.admi_proceso WHERE nombre_proceso = 'TAREAS DE HORAS EXTRA' AND estado = 'Activo')
                                      AND to_char(it.fe_ult_mod, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY')
                              )
                              AND ( idh1.estado IN ( 'Aceptada' )
                              AND idh1.accion IN ( 'Ejecutada', 'Reanudada' ) )
                              group by ve.no_emple,idh1.usr_creacion
                              ORDER BY idh1.usr_creacion asc
                      ) q1,
                      (
                          SELECT
                              idh.usr_creacion user_creacion,
                              ve.no_emple
                          FROM db_soporte.info_detalle_historial idh
                          JOIN db_soporte.info_detalle ide ON ide.id_detalle = idh.detalle_id
                          JOIN naf47_tnet.v_empleados_empresas ve ON ve.login_emple = idh.usr_creacion
                           AND ve.no_cia = 10
                           AND ve.nombre_depto IN ( SELECT pardet.valor1 AS nombre_depto
                                  FROM db_general.admi_parametro_cab parcab, db_general.admi_parametro_det pardet
                                  WHERE parcab.nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
                                      AND pardet.parametro_id = parcab.id_parametro
                                      AND pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
                                      AND pardet.estado = 'Activo'
                                      AND parcab.estado = 'Activo' )
                          WHERE idh.detalle_id IN ( SELECT it.detalle_id FROM db_soporte.info_tarea it
                                                    WHERE it.estado IN ( 'Finalizada', 'Asignada', 'Pausada', 'Reprogramada','Cancelada')
                                                        AND it.tipo_asignado = 'EMPLEADO'
                                                        AND idh.estado IN ( 'Finalizada', 'Pausada', 'Reprogramada','Cancelada', 'Asignada' )
                                                        AND to_char(idh.fe_creacion, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY')
                                                        AND to_char(it.fe_ult_mod, 'DD-MM-YYYY')   = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY')
                                                        AND proceso_id <> (SELECT id_proceso FROM db_soporte.admi_proceso WHERE nombre_proceso = 'TAREAS DE HORAS EXTRA' AND estado = 'Activo'))
                          AND  (( idh.estado = 'Asignada'AND idh.accion = 'Reasignada' )
                             OR ( idh.estado IN ( 'Finalizada' ) AND idh.accion IN ( 'Finalizada'))
                             OR ( idh.estado = 'Reprogramada'    AND idh.accion = 'Reprogramada')
                             OR ( idh.estado = 'Pausada'         AND idh.accion = 'Pausada')
                             OR ( idh.estado = 'Cancelada'       AND idh.accion = 'Cancelada'))
                          GROUP BY ve.no_emple,idh.usr_creacion
                          ORDER BY idh.usr_creacion asc
                      ) q2
                  WHERE q1.usr_creacion = q2.user_creacion
                  GROUP BY
                      q1.no_emple,
                      q1.usr_creacion
              ) q3
          ORDER BY q3.usr_creacion ASC;  
              
      CURSOR c_get_detalle_tarea (
              cn_empresacod    NUMBER,
              cv_estado        VARCHAR2,
              cv_tipo_asignado VARCHAR2,
              cv_usr_creacion  VARCHAR2,
              cn_numerodias    NUMBER
          ) IS
        select 
              q3.numero_tarea, 
              q3.detalle_id, 
              q3.no_emple, 
              q3.usr_creacion,
              q3.fecha_inicio_he1, 
              q3.fecha_inicio, 
              q3.fecha_inicio fecha_fin, 
              q3.fecha_inicio_he,  
              substr(LISTAGG(q3.fecha_fin_he, ',')WITHIN GROUP (ORDER BY q3.fecha_fin_he),1, 16 )fecha_fin_he,
              q3.hora_inicio,
              substr(LISTAGG(q3.hora_fin, ',')WITHIN GROUP (ORDER BY q3.hora_fin),1, 5 )hora_fin
        FROM
   
        (SELECT
                to_char(q1.fe_creacion, 'DD-MM-YYYY HH24:MI:SS') fecha_inicio_he1,
                to_char(q2.fecha, 'DD-MM-YYYY HH24:MI:SS') fecha_fin_he1,
                to_char(q1.numero_tarea)                      numero_tarea,
                to_char(q1.detalle_id)                        detalle_id,
                q1.no_emple,
                q1.usr_creacion,
                to_char(q1.fe_creacion, 'DD-MM-YYYY')         fecha_inicio,
                to_char(q2.fecha, 'DD-MM-YYYY')               fecha_fin,
                to_char(q1.fe_creacion, 'DD-MM-YYYY HH24:MI') fecha_inicio_he,
                to_char(q2.fecha, 'DD-MM-YYYY HH24:MI')       fecha_fin_he,
                to_char(q1.fe_creacion, 'HH24:MI')            hora_inicio,
                to_char(q2.fecha, 'HH24:MI')                  hora_fin
            FROM
                (
                  SELECT
                        it.numero_tarea,
                        idh1.detalle_id,
                        ve.no_emple,
                        idh1.usr_creacion,
                        IDH1.ESTADO AS ESTADO_HISTORIAL_TAREA,
                        IDH1.ACCION AS ACCION_HISTORIAL_TAREA,
                        it.estado as ESTADO_TAREA,
                        idh1.fe_creacion
                    FROM
                        db_soporte.info_detalle_historial idh1
                        JOIN db_soporte.info_detalle         ide1 ON ide1.id_detalle = idh1.detalle_id
                        JOIN db_soporte.info_tarea           it ON it.detalle_id = idh1.detalle_id
                         AND it.detalle_id IN (SELECT it.detalle_id FROM db_soporte.info_tarea it
                            WHERE
                                it.estado in ('Finalizada','Asignada', 'Reprogramada', 'Pausada')
                                AND it.tipo_asignado = 'EMPLEADO'
                                AND idh1.estado IN ('Aceptada' )
                                AND to_char(idh1.fe_creacion, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY')
                                AND proceso_id <> (SELECT id_proceso FROM db_soporte.admi_proceso WHERE nombre_proceso = 'TAREAS DE HORAS EXTRA'AND estado = 'Activo')
                                AND to_char(it.fe_ult_mod, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY'))
                        JOIN naf47_tnet.v_empleados_empresas ve ON ve.login_emple = idh1.usr_creacion
                        AND ve.no_cia = 10
                        AND ve.nombre_depto IN (
                            SELECT
                                pardet.valor1 AS nombre_depto
                            FROM
                                db_general.admi_parametro_cab parcab, db_general.admi_parametro_det pardet
                            WHERE
                                    parcab.nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
                                AND pardet.parametro_id = parcab.id_parametro
                                AND pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
                                AND pardet.estado = 'Activo'
                                AND parcab.estado = 'Activo'
                        )
                    WHERE( idh1.estado IN ( 'Aceptada' )
                    AND idh1.accion IN ( 'Ejecutada', 'Reanudada' ) )
                    ORDER BY IDH1.FE_CREACION ASC) q1
                inner join 
                (
                    SELECT
                        it.numero_tarea,
                        idh.detalle_id,
                        ve.no_emple,
                        idh.usr_creacion user_creacion,
                        IDH.ESTADO AS ESTADO_HISTORIAL_TAREA,
                        IDH.ACCION AS ACCION_HISTORIAL_TAREA,
                        it.estado as ESTADO_TAREA,
                        idh.fe_creacion  fecha
                    FROM db_soporte.info_detalle_historial idh
                        JOIN db_soporte.info_detalle ide ON ide.id_detalle = idh.detalle_id
                        JOIN db_soporte.info_tarea it    ON it.detalle_id = idh.detalle_id
                        AND it.detalle_id IN (
                            SELECT
                                it.detalle_id
                            FROM
                                db_soporte.info_tarea it
                            WHERE
                                it.estado in ('Finalizada','Asignada', 'Reprogramada', 'Pausada')
                                AND it.tipo_asignado = 'EMPLEADO'
                                AND idh.estado IN ( 'Finalizada', 'Asignada', 'Pausada', 'Reprogramada','Cancelada')
                                AND to_char(idh.fe_creacion, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY')
                                AND proceso_id <> (SELECT id_proceso FROM db_soporte.admi_proceso WHERE nombre_proceso = 'TAREAS DE HORAS EXTRA' AND estado = 'Activo')
                                AND to_char(it.fe_ult_mod, 'DD-MM-YYYY') = to_char(sysdate-cn_numerodias, 'DD-MM-YYYY'))
                        JOIN naf47_tnet.v_empleados_empresas ve ON ve.login_emple = idh.usr_creacion
                        AND ve.no_cia = 10
                        AND ve.nombre_depto IN (SELECT
                                                    pardet.valor1 AS nombre_depto
                                                FROM
                                                    db_general.admi_parametro_cab parcab, db_general.admi_parametro_det pardet
                                                WHERE
                                                        parcab.nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
                                                    AND pardet.parametro_id = parcab.id_parametro
                                                    AND pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
                                                    AND pardet.estado = 'Activo'
                                                    AND parcab.estado = 'Activo')
                      WHERE (( idh.estado = 'Asignada'    AND idh.accion = 'Reasignada')
                          OR ( idh.estado = 'Finalizada'  AND idh.accion = 'Finalizada')
                          OR ( idh.estado = 'Pausada'     AND idh.accion = 'Pausada')
                          OR ( idh.estado = 'Reprogramada'AND idh.accion = 'Reprogramada' ))
                     ORDER BY IDH.FE_CREACION ASC) q2
            ON q1.usr_creacion = q2.user_creacion
            AND q1.detalle_id = q2.detalle_id
            AND q1.numero_tarea = q2.numero_tarea
            AND q1.no_emple = q2.no_emple
            AND Q1.fe_creacion <= Q2.FECHA
            AND q1.usr_creacion = cv_usr_creacion
    ORDER BY
        fecha_inicio_he,fecha_fin_he ASC)Q3
        group by Q3.fecha_inicio_he1, q3.fecha_inicio, q3.fecha_inicio_he, q3.hora_inicio, q3.numero_tarea, q3.detalle_id,q3.no_emple, q3.usr_creacion;

      
    TYPE lv_linea_base          IS TABLE OF C_OBTENER_LINEA_BASE%ROWTYPE;
    T_LineaBase lv_linea_base;   
    TYPE Lr_ListadoEmpleados    IS TABLE OF C_LISTADO_EMPLEADOS%ROWTYPE;
    T_ListaEmpleados Lr_ListadoEmpleados;  
    Lr_DepartamentosConfigurados   C_DEPARTAMENTOS_CONFIGURADOS%ROWTYPE;
    TYPE lv_linea_base_mes IS TABLE OF C_OBTENER_LINEA_BASE_MES%ROWTYPE;
     T_LineaBaseMes lv_linea_base_mes;
    Lv_EsFeriado                   C_FERIADO_NACIONAL%ROWTYPE;
    Lv_EsFeriado1                  C_FERIADO_NACIONAL%ROWTYPE;
    Lv_EsFinDeSemana               C_FIN_DE_SEMANA%ROWTYPE;
    ----array creados para crear solicitudes de horas extras------------
    TYPE C_No_Empledo               IS ARRAY (5000) OF VARCHAR2(7);
      C_NoEmpledo                   C_No_Empledo := C_No_Empledo();
    TYPE C_Fecha_Solicitud          IS ARRAY (5000) OF VARCHAR2(15);
      C_FechaSolicitud              C_Fecha_Solicitud := C_Fecha_Solicitud();
    TYPE C_Numeros_Tareas           IS ARRAY (5000) OF VARCHAR2(1000);
      C_NumerosTareas               C_Numeros_Tareas := C_Numeros_Tareas();
    TYPE C_Hora_Inicio_Solicitud    IS ARRAY (5000) OF VARCHAR2(1000);
      C_HoraInicioSolicitud         C_Hora_Inicio_Solicitud := C_Hora_Inicio_Solicitud();
    TYPE C_Hora_Fin_Solicitud       IS ARRAY (5000) OF VARCHAR2(1000);
      C_HoraFinSolicitud            C_Hora_Fin_Solicitud := C_Hora_Fin_Solicitud();
    TYPE C_Fecha_Inicio_Tarea       IS ARRAY (5000) OF VARCHAR2(1000);
      C_FechaInicioTarea            C_Fecha_Inicio_Tarea := C_Fecha_Inicio_Tarea();
    TYPE C_Fecha_Fin_Tarea          IS ARRAY (5000) OF VARCHAR2(1000);
      C_FechaFinTarea               C_Fecha_Fin_Tarea := C_Fecha_Fin_Tarea();
    TYPE C_Jornada_Empleado         IS ARRAY (5000) OF VARCHAR2(3);
      C_JornadaEmpleado             C_Jornada_Empleado := C_Jornada_Empleado();
    TYPE C_Dia_Libre                IS ARRAY (5000) OF VARCHAR2(3);
      C_DiaLibre                    C_Dia_Libre := C_Dia_Libre();
    Lr_Valor_1                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    TYPE lv_feriado_local IS TABLE OF C_FERIADO_LOCAL%ROWTYPE;
     T_feriado_local lv_feriado_local;
    TYPE lv_feriado_local1 IS TABLE OF C_FERIADO_LOCAL%ROWTYPE;
     T_feriado_local1 lv_feriado_local1;

BEGIN 
      lv_usercreacion      := 'Horas_Extras';
      ln_empresacod        := 10;
      lv_estadotarea       := 'Finalizada';
      lv_observacion       := 'Origen Tarea HE Job barrido de tareas por departamentos administrativos';
      
      IF Ln_EmpresaCod IS NULL THEN
        Lv_Error := 'El parámetro empresaCod está vacío';
        RAISE Le_Exception;
      END IF;
      
      --estado con las que se crean las solicitudes
      SELECT PARDET.VALOR1 AS ESTADO
       INTO Lv_estadoSolicitud
       FROM DB_GENERAL.admi_parametro_cab PARCAB,
            DB_GENERAL.admi_parametro_det PARDET
      WHERE PARCAB.Nombre_parametro = 'ESTADO DEPARTAMENTOS_ADMINISTRATIVA'
        AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
        AND PARDET.DESCRIPCION = 'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA'
        AND PARDET.ESTADO = 'Activo' 
        AND PARCAB.ESTADO = 'Activo';  
       
       --numero de dias o mes que se restan para realizar el barrido de tareas 
      SELECT pardet.valor1 AS numero
        INTO ln_numerodias
        FROM db_general.admi_parametro_cab parcab,
             db_general.admi_parametro_det pardet
        WHERE parcab.nombre_parametro = 'NUMERO DIAS PARA BARRIDO TAREAS'
            AND pardet.parametro_id = parcab.id_parametro
            AND pardet.descripcion = 'NUMERO DIAS PARA BARRIDO TAREAS'
            AND pardet.estado = 'Activo'
            AND parcab.estado = 'Activo';

      --horario en el que empieza la jornada nocturna 
      SELECT HORA_INICIO,HORA_FIN
      INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
      WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';

      --numero mes barrido tareas---
      SELECT pardet.valor1 as numero_mes 
      INTO Lv_NumeroMesRestar
      FROM db_general.admi_parametro_det pardet, db_general.admi_parametro_cab parcab 
      WHERE pardet.parametro_id = parcab.id_parametro 
      AND parcab.nombre_parametro = 'NUMERO_MES_BARRIDO_TAREAS_HE'
      AND PARAMETRO_ID = parcab.id_parametro
      AND pardet.descripcion = 'NUMERO_MES_BARRIDO_TAREAS_HE'
      AND pardet.estado = 'Activo';


      IF C_DIA_CORTE_MES_VENCIDO%ISOPEN THEN
              CLOSE C_DIA_CORTE_MES_VENCIDO;
          END IF;
      
          OPEN C_DIA_CORTE_MES_VENCIDO;
          FETCH C_DIA_CORTE_MES_VENCIDO INTO Lr_valor_1;
            IF C_DIA_CORTE_MES_VENCIDO%FOUND THEN  
                 SELECT TO_DATE(Lr_valor_1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
                   INTO Ld_FechaCorte
                 FROM DUAL;          
            END IF;
          CLOSE C_DIA_CORTE_MES_VENCIDO;
          
          IF C_DEPARTAMENTOS_CONFIGURADOS%ISOPEN THEN CLOSE C_DEPARTAMENTOS_CONFIGURADOS; END IF;
    
          OPEN C_DEPARTAMENTOS_CONFIGURADOS;
            FETCH C_DEPARTAMENTOS_CONFIGURADOS INTO Lr_DepartamentosConfigurados;
          CLOSE C_DEPARTAMENTOS_CONFIGURADOS;
        
                  FOR Lr_DepartamentosConfigurados IN C_DEPARTAMENTOS_CONFIGURADOS loop
            Lv_configDepa := Lr_DepartamentosConfigurados.TIPO_CREACION;----- se asina a una variable el tipo de validacion por departamento
            
            IF Lr_DepartamentosConfigurados.TIPO_CREACION = 2 AND Ld_FechaCorte = TO_CHAR(SYSDATE,'DD-MM-YYYY') THEN
              Lv_crearSolicitudes := 'S';
            ELSIF Lr_DepartamentosConfigurados.TIPO_CREACION = 1 THEN  
              Lv_crearSolicitudes := 'S';
            ELSE
              Lv_crearSolicitudes := 'N';
            END IF;
            
            IF Lv_crearSolicitudes = 'S' THEN
            
                ---SE VALIDA SI CREA SOLICITUDES A MES VENCIDO O DIA VENCIDO SEGUN DEPARTAMENTO
                IF Lr_DepartamentosConfigurados.TIPO_CREACION = '1' THEN
                  lv_fechaInicioLineaBase        := TO_CHAR(SYSDATE-ln_numerodias, 'DD-MM-YYYY');
                  lv_fechaFinLineaBase           := TO_CHAR(SYSDATE-ln_numerodias, 'DD-MM-YYYY');
                  lv_numeroFechaInicio           := TO_NUMBER(TO_CHAR(SYSDATE-ln_numerodias, 'DD'));
                  lv_numeroFcehaFin              := TO_NUMBER(TO_CHAR(SYSDATE-ln_numerodias, 'DD'));
                  /*lv_fechaInicioLineaBase        := TO_CHAR(TO_DATE(Ld_Fecha,'DD-MM-YYYY'), 'DD-MM-YYYY');
                  lv_fechaFinLineaBase           := TO_CHAR(TO_DATE(Ld_Fecha,'DD-MM-YYYY'), 'DD-MM-YYYY');
                  lv_numeroFechaInicio           := TO_NUMBER(TO_CHAR(TO_DATE(Ld_Fecha,'DD-MM-YYYY'), 'DD'));
                  lv_numeroFcehaFin              := TO_NUMBER(TO_CHAR(TO_DATE(Ld_Fecha,'DD-MM-YYYY'), 'DD'));*/
                ELSE 
                  IF C_MES_VENCIDO%ISOPEN THEN CLOSE C_MES_VENCIDO; END IF;
                  OPEN C_MES_VENCIDO(TO_CHAR(SYSDATE,'DD-MM-YYYY'),Lv_NumeroMesRestar);
                  FETCH C_MES_VENCIDO INTO lv_fechaInicioLineaBase, lv_fechaFinLineaBase;
                  CLOSE C_MES_VENCIDO;
                  lv_numeroFechaInicio           := TO_NUMBER(TO_CHAR(TO_DATE(lv_fechaInicioLineaBase,'DD-MM-YYYY'), 'DD'));
                  lv_numeroFcehaFin              := TO_NUMBER(TO_CHAR(TO_DATE(lv_fechaFinLineaBase,'DD-MM-YYYY'), 'DD'));
                END IF;
                
    
                IF C_LISTADO_EMPLEADOS%ISOPEN THEN CLOSE C_LISTADO_EMPLEADOS; END IF;
                      
                OPEN C_LISTADO_EMPLEADOS(Lr_DepartamentosConfigurados.NOMBRE_DEPTO);
                        FETCH C_LISTADO_EMPLEADOS BULK COLLECT INTO T_ListaEmpleados;
                CLOSE C_LISTADO_EMPLEADOS;
    
                FOR T_ListaEmpleados IN C_LISTADO_EMPLEADOS(Lr_DepartamentosConfigurados.NOMBRE_DEPTO) loop
                    
                     --Se verifica si el empleado tiene registrada una linea base EN EL MES
                   IF C_OBTENER_LINEA_BASE_MES%ISOPEN THEN CLOSE C_OBTENER_LINEA_BASE_MES; END IF;
                  
                    OPEN C_OBTENER_LINEA_BASE_MES(T_ListaEmpleados.NO_CIA, 'Activo',T_ListaEmpleados.NO_EMPLE,
                                                   to_char(to_date(lv_fechaInicioLineaBase,'DD/MM/YYYY'),'MM'),
                                                   to_char(to_date(lv_fechaFinLineaBase,'DD/MM/YYYY'),'YYYY'));
                    FETCH C_OBTENER_LINEA_BASE_MES BULK COLLECT INTO T_LineaBaseMes;
                    CLOSE C_OBTENER_LINEA_BASE_MES;
                    IF(T_LineaBaseMes.COUNT > 0)THEN
                      ----- SE CREA UN FOR PARA OBTENER LAS FECHAS A CREAR LAS TRAMAS 
                      FOR Ln_numero_for IN lv_numeroFechaInicio..lv_numeroFcehaFin
                      LOOP
                      
                        lv_fechaInicioLineaBase := to_char(to_date(Ln_numero_for ||'-'||to_char(to_date(lv_fechaInicioLineaBase,'DD-MM-YYYY'),'MM')||'-'||to_char(to_date(lv_fechaInicioLineaBase,'DD-MM-YYYY'),'YYYY'),'DD-MM-YYYY'),'DD-MM-YYYY'); 
                        lv_fechaFinLineaBase    := to_char(to_date(Ln_numero_for ||'-'||to_char(to_date(lv_fechaInicioLineaBase,'DD-MM-YYYY'),'MM')||'-'||to_char(to_date(lv_fechaInicioLineaBase,'DD-MM-YYYY'),'YYYY'),'DD-MM-YYYY'),'DD-MM-YYYY'); 
                        
                          ---FERIADO NACIONAL----- 
                          IF C_FERIADO_NACIONAL%ISOPEN THEN CLOSE C_FERIADO_NACIONAL; END IF;
                          OPEN C_FERIADO_NACIONAL(lv_fechaInicioLineaBase);
                          FETCH C_FERIADO_NACIONAL INTO Lv_EsFeriado;
                          CLOSE C_FERIADO_NACIONAL;
                          ---FIN DE FERIADO NACIONALES---
                                                 
                          ----PARA INDENTIFICAR SI EL EMPLEADO TIENE FERIADO LOCAL-----
                          IF C_FERIADO_LOCAL%ISOPEN THEN CLOSE C_FERIADO_LOCAL; END IF;
                            OPEN C_FERIADO_LOCAL(lv_fechaInicioLineaBase, T_ListaEmpleados.OFICINA_PROVINCIA);
                                FETCH C_FERIADO_LOCAL BULK COLLECT INTO T_feriado_local;
                                  IF (Lv_EsFeriado.CANTIDAD = 0 AND T_feriado_local.count > 0) then
                                      while Ln_contadorFeriado <= T_feriado_local.count loop
                                          Lv_Provincia := T_feriado_local(Ln_contadorFeriado).PROVINCIA;
                                          Lv_Canton := T_feriado_local(Ln_contadorFeriado).CANTON;
                                          IF (Lv_Canton is null AND T_ListaEmpleados.OFICINA_PROVINCIA = Lv_Provincia) THEN 
                                              Lv_EsFeriado.CANTIDAD := 1;
                                          ELSIF(T_ListaEmpleados.OFICINA_PROVINCIA = Lv_Provincia AND T_ListaEmpleados.OFICINA_CANTON = Lv_Canton) THEN 
                                              Lv_EsFeriado.CANTIDAD := 1;
                                          ELSE 
                                              Lv_EsFeriado.CANTIDAD := 0;
                                          END IF;
                                              Ln_contadorFeriado:= Ln_contadorFeriado+1;
                                      END loop;
                                      Ln_contadorFeriado:=1;
                                      Lv_Provincia:=null;
                                      Lv_Canton:=null;
                                  END IF;
                            CLOSE C_FERIADO_LOCAL;
                          ---FIN PARA IDENTIFICAR SI EL EMPLEADO TIENE FERIADO LOCAL----
                          
                          -----VERIFICAR SI LA FECHA ES FIN DE SEMANA------
                          IF C_FIN_DE_SEMANA%ISOPEN THEN CLOSE C_FIN_DE_SEMANA; END IF;
                          OPEN C_FIN_DE_SEMANA(lv_fechaInicioLineaBase);
                          FETCH C_FIN_DE_SEMANA INTO Lv_EsFinDeSemana;
                          CLOSE C_FIN_DE_SEMANA;
                          -----FIN DE VERIFICACION SI ES FIN DE SEMANA-----
                          ----SE VERIFICA SI EL EMPLEADO TIENE LINEA BASE-------
                          IF C_OBTENER_LINEA_BASE%ISOPEN THEN CLOSE C_OBTENER_LINEA_BASE; END IF;
                          OPEN C_OBTENER_LINEA_BASE(T_ListaEmpleados.NO_CIA,
                                                    'Activo',T_ListaEmpleados.NO_EMPLE,
                                                    lv_fechaInicioLineaBase,lv_fechaFinLineaBase);
                          FETCH C_OBTENER_LINEA_BASE BULK COLLECT INTO T_LineaBase;
                          CLOSE C_OBTENER_LINEA_BASE;
                          
                        --TOTAL DE LINEAS BASE EMPLEADO
                          Ln_total_linea_base := T_LineaBase.count;
                          
                          IF (Ln_total_linea_base > 0 AND ((Lv_EsFeriado.CANTIDAD = 0 AND Lv_configDepa = '1')OR Lv_configDepa = '2')) THEN  

                              FOR T_LineaBase IN C_OBTENER_LINEA_BASE(T_ListaEmpleados.NO_CIA,
                                                                      'Activo',T_ListaEmpleados.NO_EMPLE,
                                                                      lv_fechaInicioLineaBase,lv_fechaFinLineaBase) loop
                                  
                                  ---validacion para crear solicitudes nocturnas cuando jornada se encuentra dentro del rango de un dia para el otro
                                  IF (T_LineaBase.FECHA_INICIO = T_LineaBase.FECHA_FIN) OR 
                                     (T_LineaBase.FECHA_INICIO <> T_LineaBase.FECHA_FIN AND T_LineaBase.FECHA_INICIO = lv_fechaInicioLineaBase) THEN 
                                      
                                      --VALIDACION QUE DETERMINA SI LA FECHA INICIO Y FIN SON DIFERENTES SE VERIFICA QUE SI EXISTE FERIADO PARA AMBAS FECHAS
                                      IF TO_DATE(T_LineaBase.FECHA_INICIO, 'DD-MM-YYYY') < TO_DATE(T_LineaBase.FECHA_FIN, 'DD-MM-YYYY') 
                                         AND T_LineaBase.FECHA_INICIO <> T_LineaBase.FECHA_FIN  AND T_LineaBase.HORA_FIN > '00:00' THEN

                                          ---FERIADO NACIONAL----- 
                                          IF C_FERIADO_NACIONAL%ISOPEN THEN CLOSE C_FERIADO_NACIONAL; END IF;
                                          OPEN C_FERIADO_NACIONAL(T_LineaBase.FECHA_FIN);
                                          FETCH C_FERIADO_NACIONAL INTO Lv_EsFeriado1;
                                          CLOSE C_FERIADO_NACIONAL;
                                          ---FIN DE FERIADO NACIONALES---
                                          
                                          ----PARA INDENTIFICAR SI EL EMPLEADO TIENE FERIADO LOCAL-----
                                          IF C_FERIADO_LOCAL%ISOPEN THEN CLOSE C_FERIADO_LOCAL; END IF;
                                            OPEN C_FERIADO_LOCAL(T_LineaBase.FECHA_FIN, T_ListaEmpleados.OFICINA_PROVINCIA);
                                                FETCH C_FERIADO_LOCAL BULK COLLECT INTO T_feriado_local1;
                                                  IF (Lv_EsFeriado1.CANTIDAD = 0 AND T_feriado_local1.count > 0) then
                                                      while Ln_contadorFeriado1 <= T_feriado_local1.count loop
                                                        Lv_Provincia1 := T_feriado_local1(Ln_contadorFeriado1).PROVINCIA;
                                                        Lv_Canton1 := T_feriado_local1(Ln_contadorFeriado1).CANTON;
                                                          IF (Lv_Canton1 is null AND T_ListaEmpleados.OFICINA_PROVINCIA = Lv_Provincia1) THEN 
                                                              Lv_EsFeriado1.CANTIDAD := 1;
                                                          ELSIF(T_ListaEmpleados.OFICINA_PROVINCIA = Lv_Provincia1 AND T_ListaEmpleados.OFICINA_CANTON = Lv_Canton1) THEN 
                                                              Lv_EsFeriado1.CANTIDAD := 1;
                                                          ELSE 
                                                              Lv_EsFeriado1.CANTIDAD := 0;
                                                          END IF;
                                                          Ln_contadorFeriado1:= Ln_contadorFeriado1+1;
                                                      END loop;
                                                      Ln_contadorFeriado1:=1;
                                                      Lv_Provincia1:=null;
                                                      Lv_Canton1:=null;
                                                  END IF;
                                            CLOSE C_FERIADO_LOCAL;
                                          ---FIN PARA IDENTIFICAR SI EL EMPLEADO TIENE FERIADO LOCAL----
                                          IF Lv_EsFeriado1.CANTIDAD = 1 AND Lv_EsFeriado.CANTIDAD = 0 THEN
                                                      ---variables temporales de feriados en linea base para casos de fecha inicio y fin en dias diferentes
                                                      lv_fechaHETemp                 := T_LineaBase.FECHA_FIN;
                                                      lv_horaInicioHETemp            := '00:00';
                                                      lv_horaFinHETemp               := T_LineaBase.HORA_FIN;
                                                      T_LineaBase.HORA_FIN           := '00:00';
                                          ELSIF Lv_EsFeriado.CANTIDAD = 1 AND Lv_EsFeriado1.CANTIDAD = 0 THEN 
                                                      lv_reverse                     := 1;
                                                      lv_fechaHETemp                 := T_LineaBase.FECHA_INICIO;
                                                      lv_horaInicioHETemp            := T_LineaBase.HORA_INICIO;
                                                      lv_horaFinHETemp               := '00:00';
                                                      T_LineaBase.FECHA_INICIO       := T_LineaBase.FECHA_FIN;
                                                      T_LineaBase.HORA_INICIO        := '00:00';
                                          END IF;
                                      END IF;
                                      
                                      --SE IDENTIFICA SI ES UN DIA LIBRE SEGUN EL TIPO DE DEPARTAMENTO APLICA VALIDACION 1.-REALIZA BARRIDO DE TAREAS NORMALES Y 2.- SOLO CREA SOLICITUDES A PARTIR DE SU LINEA BASE PARA JORNADAS NOCTURNAS
                                      IF ((Ln_total_linea_base = 0 AND Lv_EsFinDeSemana.FIN_SEMANA = 'S' AND Lr_DepartamentosConfigurados.TIPO_CREACION = '1' AND T_LineaBaseMes.COUNT > 0 ) OR 
                                          (Ln_total_linea_base = 0 AND Lr_DepartamentosConfigurados.TIPO_CREACION = '2' AND T_LineaBaseMes.COUNT > 0 ) OR
                                          (Lv_EsFeriado.CANTIDAD = 1 AND lv_reverse = '0'))THEN
                                          Lv_EsDiaLibre := 'S';
                                      ELSE
                                          Lv_EsDiaLibre := 'N';
                                      END IF;
                                      
                                      lv_fecha1 := to_char((TO_DATE(T_LineaBase.FECHA_INICIO, 'dd/mm/rrrr hh24:mi:ss')), 'dd-mm-rrrr');
                                      --FINALIZACION DE VALIDACION FERIADOS EN AMBAS FECHAS --- 
                                      ---VARIABLES PARA VALIDACION DE JORNADA NOCTURNA
                                      Ld_HoraInicio2 :=  to_timestamp((T_LineaBase.FECHA_INICIO||' '||T_LineaBase.HORA_INICIO),'DD-MM-YYYY HH24:MI');   
                                      Ld_HoraFin2 :=  to_timestamp((T_LineaBase.FECHA_FIN||' '||T_LineaBase.HORA_FIN),'DD-MM-YYYY HH24:MI'); 
                                      Ld_HoraInicioDia :=  to_timestamp((T_LineaBase.FECHA_INICIO||' '||'00:00'),'DD-MM-YYYY HH24:MI');
                                      -- HORAS NOCTURNAS
                                      Ld_HorasInicioNocturnas1 := to_timestamp((T_LineaBase.FECHA_INICIO||' '||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
                                      Ld_HorasFinNocturnas1 :=  to_timestamp((T_LineaBase.FECHA_INICIO||' '||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');
                                      
                                      -------FIN DE ASGINACION DE VARIABLES-------
                                      --SE LE SUMA UN DIA CUANDO LAS FECHAS SON DIFERENTES
                                      IF T_LineaBase.FECHA_INICIO <> T_LineaBase.FECHA_FIN THEN 
                                        Ld_HorasFinNocturnas1 := Ld_HorasFinNocturnas1+1;
                                      END IF;
                                      --VALIDACION QUE DETERMINA LA J0RNADA LABORAL DEL EMPLEADO
                                      IF ((Ld_HoraFin2 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio2 < Ld_HorasInicioNocturnas1)OR
                                         ((Ld_HoraInicio2 >= Ld_HorasInicioNocturnas1 OR Ld_HoraInicio2 >= Ld_HoraInicioDia) AND Ld_HoraFin2 <= Ld_HorasFinNocturnas1) OR 
                                         (Ld_HoraInicio2 >= Ld_HoraInicioDia AND Ld_HoraFin2 >= Ld_HorasFinNocturnas1 AND Ld_HoraInicio2 < Ld_HorasFinNocturnas1)) AND
                                         Lv_EsDiaLibre = 'N' THEN
                                         
                                          Ln_Contador:= Ln_Contador+1;
                                          Lv_JornadaEmpleado := 'N';
                                         C_NoEmpledo.extend;
                                         C_FechaSolicitud.extend;
                                         C_NumerosTareas.extend;
                                         C_FechaInicioTarea.extend;
                                         C_FechaFinTarea.extend;
                                         C_JornadaEmpleado.extend;
                                         C_HoraInicioSolicitud.extend;
                                         C_HoraFinSolicitud.extend;
                                         C_DiaLibre.extend;
                                                                                    
                                          C_NoEmpledo(Ln_Contador)          := T_LineaBase.no_emple;
                                          C_FechaSolicitud(Ln_Contador)     := lv_fecha1;
                                          C_NumerosTareas(Ln_Contador)      := '[';
                                          C_FechaInicioTarea(Ln_Contador)   := '[';
                                          C_FechaFinTarea(Ln_Contador)      := '[';
                                          C_JornadaEmpleado(Ln_Contador)    := 'N';
                                          C_DiaLibre(Ln_Contador)           :=  Lv_EsDiaLibre;      
                                            
                                                --SI EL EMPLEADO EN SU LINEA BASE REGISTRADA CONTIENE UN RECARGO NOCTURNO Y ESTABLECE LA HORA INICIO Y FIN 
                                                IF (Ld_HoraFin2 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio2 < Ld_HorasInicioNocturnas1) THEN 
                                                   
                                                    C_HoraInicioSolicitud(Ln_Contador) := to_char((TO_DATE(lv_fecha1||' '||Lv_HorasInicioNocturnas,'dd/mm/rrrr hh24:mi:ss')), 'hh24:mi');
                                                    C_HoraFinSolicitud(Ln_Contador)    := to_char((TO_DATE(lv_fecha1||' '||T_LineaBase.HORA_FIN,'dd/mm/rrrr hh24:mi:ss')), 'hh24:mi');
                                                ELSIF(Ld_HoraInicio2 >= Ld_HoraInicioDia AND Ld_HoraFin2 >= Ld_HorasFinNocturnas1 AND Ld_HoraInicio2 < Ld_HorasFinNocturnas1) THEN 
                                                   
                                                    C_HoraInicioSolicitud(Ln_Contador) := to_char((TO_DATE(lv_fecha1||' '||T_LineaBase.HORA_INICIO,'dd/mm/rrrr hh24:mi:ss')), 'hh24:mi');
                                                    C_HoraFinSolicitud(Ln_Contador)    := to_char((TO_DATE(lv_fecha1||' '||Lv_HorasFinNocturnas,'dd/mm/rrrr hh24:mi:ss')), 'hh24:mi');
                                                ELSE 
                                                    C_HoraInicioSolicitud(Ln_Contador) := to_char((TO_DATE(lv_fecha1||' '||T_LineaBase.HORA_INICIO,'dd/mm/rrrr hh24:mi:ss')), 'hh24:mi');
                                                    C_HoraFinSolicitud(Ln_Contador)    := to_char((TO_DATE(lv_fecha1||' '||T_LineaBase.HORA_FIN,'dd/mm/rrrr hh24:mi:ss')), 'hh24:mi');
                                                    
                                                END IF;
                                      END IF;
                                      
                                      IF (T_LineaBase.HORA_INICIO >= Lv_HorasFinNocturnas AND Lr_DepartamentosConfigurados.TIPO_CREACION = '1' AND Lv_EsDiaLibre = 'N') THEN  
    
                                          FOR histotarea IN c_get_historial_tarea(ln_empresacod, lv_estadotarea, 'EMPLEADO', ln_numerodias) LOOP
                                          IF T_ListaEmpleados.LOGIN_EMPLE = histotarea.usr_creacion THEN
                                              --BUSCO POR EL EMPLEADO LAS TAREAS EJECUTADAS
                                              FOR detatarea IN c_get_detalle_tarea(ln_empresacod, lv_estadotarea, 'EMPLEADO', histotarea.usr_creacion, ln_numerodias) LOOP
                                                  ---vALIDACION QUE CREA TRAMA SI LA EJECUCION DE LA TAREA FUE ANTES O DESPUES DE LA LINEA BASE
                                                  IF (TRIM(detatarea.hora_inicio) >= T_LineaBase.HORA_FIN AND TRIM(detatarea.hora_fin) > T_LineaBase.HORA_FIN) THEN 
                                                      lv_envia_trama      := 1;
                                                      Ld_HoraInicio1      := detatarea.hora_inicio;
                                                      Ld_HoraFin1         := detatarea.hora_fin;
                                                      lv_fecha_inicio1    := detatarea.fecha_inicio_he;
                                                      lv_fecha_fin1       := detatarea.fecha_fin_he;
                                                     
                                                  ELSIF (TRIM(detatarea.hora_inicio) >= T_LineaBase.HORA_INICIO AND TRIM(detatarea.hora_fin) > T_LineaBase.HORA_FIN) THEN
                                                      lv_envia_trama      := 1;
                                                      Ld_HoraInicio1      := T_LineaBase.HORA_FIN;
                                                      Ld_HoraFin1         := detatarea.hora_fin;
                                                      lv_fecha_inicio1    := to_char((TO_DATE(lv_fecha1||' '||T_LineaBase.HORA_FIN,'dd/mm/rrrr hh24:mi:ss')), 'dd/mm/rrrr hh24:mi');
                                                      lv_fecha_fin1       := detatarea.fecha_fin_he;
                                                  
                                                  ELSIF (TRIM(detatarea.hora_inicio) < T_LineaBase.HORA_INICIO AND TRIM(detatarea.hora_fin) > T_LineaBase.HORA_FIN)THEN
                                                      lv_envia_trama      := 1;
                                                      Ld_HoraInicio1      := detatarea.hora_inicio;
                                                      Ld_HoraFin1         := T_LineaBase.HORA_FIN;
                                                      lv_fecha_inicio1    := detatarea.fecha_inicio_he;
                                                      lv_fecha_fin1       := to_char((TO_DATE(lv_fecha1||' '||T_LineaBase.HORA_FIN,'dd/mm/rrrr hh24:mi:ss')), 'dd/mm/rrrr hh24:mi');
                                                      
                                                  ELSE
                                                    IF (TRIM(detatarea.hora_inicio) < T_LineaBase.HORA_INICIO AND TRIM(detatarea.hora_fin) < T_LineaBase.HORA_FIN
                                                          AND TRIM(detatarea.hora_fin) < T_LineaBase.HORA_INICIO)THEN
                                                        lv_envia_trama      := 1;
                                                        Ld_HoraInicio1      := detatarea.hora_inicio;
                                                        Ld_HoraFin1         := detatarea.hora_fin;
                                                        lv_fecha_inicio1    := detatarea.fecha_inicio_he;
                                                        lv_fecha_fin1       := detatarea.fecha_fin_he;
                                                        
                                                    END IF;
                                                  END IF;
                                                  
                                                --ASIGNO LOS VALORES A LAS VARIABLES QUE VOY A USAR PARA ENVIAR EN LA TRAMA.
                                                  IF lv_envia_trama = 1  THEN 
                                                      C_NoEmpledo.extend;
                                                      C_FechaSolicitud.extend;
                                                      C_NumerosTareas.extend;
                                                      C_FechaInicioTarea.extend;
                                                      C_FechaFinTarea.extend;
                                                      C_JornadaEmpleado.extend;
                                                      C_HoraInicioSolicitud.extend;
                                                      C_HoraFinSolicitud.extend;
                                                      C_DiaLibre.extend;
                                                      IF ( lv_trama = 0 ) THEN
                                                          Ln_Contador:= Ln_Contador+1;
                                                          C_NoEmpledo(Ln_Contador)          := T_ListaEmpleados.no_emple;
                                                          C_NumerosTareas(Ln_Contador)      := '['||detatarea.numero_tarea;
                                                          C_JornadaEmpleado(Ln_Contador)    := 'M';
                                                          C_DiaLibre(Ln_Contador)           :=  Lv_EsDiaLibre;
                                                          C_HoraInicioSolicitud(Ln_Contador) := Ld_HoraInicio1;
                                                          C_FechaSolicitud(Ln_Contador)      := detatarea.fecha_inicio;
                                                          C_FechaInicioTarea(Ln_Contador)    := '["'|| lv_fecha_inicio1 ||'"';
                                                          C_FechaFinTarea(Ln_Contador)       := '["'|| lv_fecha_fin1 ||'"';
                                                          C_HoraFinSolicitud(Ln_Contador)    := Ld_HoraFin1;
                                                          lv_trama := 2;
                                                      ELSE
                                                          C_HoraFinSolicitud(Ln_Contador)    := Ld_HoraFin1;
                                                          C_NumerosTareas(Ln_Contador) := C_NumerosTareas(Ln_Contador)
                                                                                || ','
                                                                                || detatarea.numero_tarea;
                                                          C_FechaInicioTarea(Ln_Contador)    := C_FechaInicioTarea(Ln_Contador)
                                                                                || ',"'
                                                                                || lv_fecha_inicio1
                                                                                || '"';
                                                          C_FechaFinTarea(Ln_Contador)       := C_FechaFinTarea(Ln_Contador)
                                                                                || ',"'
                                                                                || lv_fecha_fin1
                                                                                || '"';
                                                      END IF;
                                                  END IF;
                                                  lv_envia_trama := 0;
                                              END LOOP;
                                              Ln_numero_tareas    := 0;
                                              lv_trama := 0;
                                          END IF;
                                      END LOOP;
                                      
                                      ELSIF Lv_EsFeriado.CANTIDAD = 1 
                                            AND Lv_EsDiaLibre = 'S' AND Lr_DepartamentosConfigurados.TIPO_CREACION = '2' THEN 
                                          Lv_EsFeriado1.CANTIDAD := 1;
                                          lv_fechaHETemp                 := T_LineaBase.FECHA_INICIO;
                                          lv_horaInicioHETemp            := T_LineaBase.HORA_INICIO;
                                          lv_horaFinHETemp               := T_LineaBase.HORA_FIN;
                                      END IF;
                                     
                                      ----se cambia variable es dia libre para le fecha fin de la jornada del empleado
                                      IF Lv_EsFeriado1.CANTIDAD = 1 OR lv_reverse = 1 THEN
                                         Lv_EsDiaLibre:= 'S';
                                      ELSE 
                                          Lv_EsDiaLibre:= 'N';
                                      END IF;
                                  END IF;
                                  
                              END LOOP;
                             
                          END IF;
                          
                          IF ((Lv_EsDiaLibre = 'S' OR (Lv_EsFinDeSemana.FIN_SEMANA = 'S' AND Lv_configDepa = '1') OR Lv_EsFeriado.CANTIDAD = 1 OR Lv_EsFeriado1.CANTIDAD = 1)AND 
                             (Ln_total_linea_base = 0 OR (Ln_total_linea_base = 1 AND Lv_configDepa = '1') OR Lv_EsFeriado.CANTIDAD = 1 OR Lv_EsFeriado1.CANTIDAD = 1)) THEN
              
                            IF Lv_configDepa = '2' AND Lv_EsDiaLibre = 'S' AND (Lv_EsFeriado1.CANTIDAD = 1 OR Lv_EsFeriado.CANTIDAD = 1) AND lv_fechaHETemp IS NOT NULL
                               AND lv_horaInicioHETemp IS NOT NULL AND lv_horaFinHETemp IS NOT NULL THEN
                                  C_NoEmpledo.extend;
                                  C_FechaSolicitud.extend;
                                  C_NumerosTareas.extend;
                                  C_FechaInicioTarea.extend;
                                  C_FechaFinTarea.extend;
                                  C_JornadaEmpleado.extend;
                                  C_HoraInicioSolicitud.extend;
                                  C_HoraFinSolicitud.extend;
                                  C_DiaLibre.extend;
                              Ln_Contador:= Ln_Contador+1;
                              C_NoEmpledo(Ln_Contador)           := T_ListaEmpleados.no_emple;
                              C_NumerosTareas(Ln_Contador)       := '[';
                              C_JornadaEmpleado(Ln_Contador)     := 'M';
                              C_DiaLibre(Ln_Contador)            :=  Lv_EsDiaLibre;
                              C_FechaInicioTarea(Ln_Contador)    := '[';
                              C_FechaFinTarea(Ln_Contador)       := '[';
                              C_FechaSolicitud(Ln_Contador)      := lv_fechaHETemp;
                              C_HoraInicioSolicitud(Ln_Contador) := lv_horaInicioHETemp;
                              C_HoraFinSolicitud(Ln_Contador)    := lv_horaFinHETemp;
                            END IF;
                            
                            --VALIDACION PARA DEPARTAMENTOS QUE TRABAJAN CON TAREAS NORMALES
                            IF Lr_DepartamentosConfigurados.TIPO_CREACION = '1' THEN
                                FOR histotarea IN c_get_historial_tarea(ln_empresacod, lv_estadotarea, 'EMPLEADO', ln_numerodias) LOOP
                                    IF T_ListaEmpleados.LOGIN_EMPLE = histotarea.usr_creacion THEN
                                        C_NoEmpledo.extend;
                                        C_FechaSolicitud.extend;
                                        C_NumerosTareas.extend;
                                        C_FechaInicioTarea.extend;
                                        C_FechaFinTarea.extend;
                                        C_JornadaEmpleado.extend;
                                        C_HoraInicioSolicitud.extend;
                                        C_HoraFinSolicitud.extend;
                                        C_DiaLibre.extend;
                                        Ln_Contador:= Ln_Contador+1;
                                        C_NoEmpledo(Ln_Contador)          := T_ListaEmpleados.no_emple;
                                        C_JornadaEmpleado(Ln_Contador)    := 'M';
                                        C_DiaLibre(Ln_Contador)           :=  Lv_EsDiaLibre;
                                        --BUSCO POR EL EMPLEADO LAS TAREAS EJECUTADAS
                                        FOR detatarea IN c_get_detalle_tarea(ln_empresacod, lv_estadotarea, 'EMPLEADO', histotarea.usr_creacion, ln_numerodias) LOOP
                                          --ASIGNO LOS VALORES A LAS VARIABLES QUE VOY A USAR PARA EL CURSOR.
                                            IF ( lv_trama = 0 ) THEN
                                                C_HoraInicioSolicitud(Ln_Contador) := detatarea.hora_inicio;
                                                C_FechaInicioTarea(Ln_Contador)    := '["'|| detatarea.fecha_inicio_he ||'"';
                                                C_FechaFinTarea(Ln_Contador)       := '["'|| detatarea.fecha_fin_he ||'"';
                                                C_NumerosTareas(Ln_Contador)      := '['||detatarea.numero_tarea;
                                                C_FechaSolicitud(Ln_Contador)      := detatarea.fecha_inicio;
                                                C_HoraFinSolicitud(Ln_Contador)    := detatarea.hora_fin;
                                                lv_trama := 2;
                                            ELSE
                                                C_HoraFinSolicitud(Ln_Contador)    := detatarea.hora_fin;
                                                C_NumerosTareas(Ln_Contador) := C_NumerosTareas(Ln_Contador)
                                                                                || ','
                                                                                || detatarea.numero_tarea;
                                                C_FechaInicioTarea(Ln_Contador)    := C_FechaInicioTarea(Ln_Contador)
                                                                      || ',"'
                                                                      || detatarea.fecha_inicio_he
                                                                      || '"';
                                                C_FechaFinTarea(Ln_Contador)       := C_FechaFinTarea(Ln_Contador)
                                                                      || ',"'
                                                                      || detatarea.fecha_fin_he
                                                                      || '"';
                                            END IF;
            
                                        END LOOP;
                                        lv_trama := 0;
                                    END IF;
                                END LOOP;
                              END IF;----FIN DE VALIDACION PARA LOS DEPARTAMENTOS QUE TRABAJAN DON TAREAS NORMALES
                            
                          END IF;
                          
                          Ln_total_linea_base := 0;
                          Lv_EsDiaLibre := 'N';
                          lv_fechaHETemp := NULL;
                          lv_horaInicioHETemp := NULL;
                          lv_horaFinHETemp  := NULL;
                          Lv_EsFeriado1.CANTIDAD := 0;
                          Lv_EsFeriado.CANTIDAD := 0;
                          lv_reverse := 0;
                      END LOOP;
                      ------FIN DEL FOR DE LAS FECHAS PARA CREAR TRAMAS--------
    
                                  --SE ENVIAN TRAMAS A CREAR
                                   Ln_Contador1:= 0;
                                   
                                   WHILE Ln_Contador1 < Ln_Contador LOOP
                                          Ln_Contador1:= Ln_Contador1+1;
                                          --if(C_HoraInicioSolicitud(Ln_Contador1)< C_HoraFinSolicitud(Ln_Contador1)) THEN
                                            lv_regjson := chr(10)
                                                        || lpad(' ', 6, ' ')
                                                        || '{'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"noEmpleado":['
                                                        || C_NoEmpledo(Ln_Contador1)
                                                        || '],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"fecha":"'
                                                        || C_FechaSolicitud(Ln_Contador1)
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"horaInicio":"'
                                                        || C_HoraInicioSolicitud(Ln_Contador1)
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"horaFin":"'
                                                        || C_HoraFinSolicitud(Ln_Contador1)
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"observacion":"'
                                                        || lv_observacion
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"estado":"'
                                                        || lv_estadosolicitud
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"empresaCod":"'
                                                        || ln_empresacod
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"usrCreacion":"'
                                                        || lv_usercreacion
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"tareaId":'
                                                        || C_NumerosTareas(Ln_Contador1)
                                                        || '],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"nombreDocumento":[],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"ubicacionDocumento":[],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"jornadaEmpleado":"'
                                                        || C_JornadaEmpleado(Ln_Contador1)
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"esFinDeSemana":"'
                                                        || 'N'
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"esDiaLibre":"'
                                                        || C_DiaLibre(Ln_Contador1)
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"descripcion":"'
                                                        || 'Unitaria'
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"idCuadrilla":[],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"nombreArea":"'
                                                        || T_ListaEmpleados.nombre_area
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"feInicioTarea":'
                                                        || C_FechaInicioTarea(Ln_Contador1)
                                                        || '],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"feFinTarea":'
                                                        || C_FechaFinTarea(Ln_Contador1)
                                                        || '],'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"nombreDepartamento":"'
                                                        || T_ListaEmpleados.nombre_depto
                                                        || '",'
                                                        || chr(10)
                                                        || lpad(' ', 9, ' ')
                                                        || '"esSuperUsuario":"'
                                                        || 'N'
                                                        || '"'
                                                        || chr(10)
                                                        || lpad(' ', 6, ' ')
                                                        || '}';
                                                        
                                                        db_horas_extras.hekg_horasextras_transaccion.p_guardar_horasextra(lv_regjson, lv_status, lv_error);

                                                        IF lv_status = 'ERROR' THEN
                                                              db_general.gnrlpck_util.insert_error('HORAS_EXTRAS', 'HEKG_HORASEXTRAS_TRANSACCION.JOB_MANUAL', lv_error, nvl(sys_context
                                                              ('USERENV', 'HOST'), 'DB_HORAS_EXTRAS'), sysdate, nvl(sys_context('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
                                                        END IF;
                                          
                                    END LOOP;
                                    Ln_Contador:= 0;
                                    Ln_Contador1:= 0;
                      END IF;
                      
                    END LOOP;
          
            END IF;
        END LOOP;
           COMMIT;
  EXCEPTION
    WHEN Le_Exception THEN 			   

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_GENERA_HE_VERI_TAREAS_ADMI',
                                           Lv_Error || ' - ' || SQLCODE ||
                                           ' -ERROR- ' || SQLERRM ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_HORAS_EXTRAS'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));

    WHEN OTHERS THEN 

      Lv_Error := SQLCODE || ' -ERROR- ' || SQLERRM || ' ' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' ||
                  DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                           'HEKG_HORASEXTRAS_TRANSACCION.P_GENERA_HE_VERI_TAREAS_ADMI',
                                           Lv_Error,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_HORAS_EXTRAS'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));

  END P_GENERA_HE_VERI_TAREAS_ADMI;


END HEKG_HORASEXTRAS_TRANSACCION;
/