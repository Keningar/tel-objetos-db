SET DEFINE OFF;
create or replace package                                                   DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION is

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
      
END HEKG_HORASEXTRAS_TRANSACCION;
/
create or replace package body                                DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION is
   
     PROCEDURE P_GUARDAR_HORASEXTRA(Pcl_Request  IN  CLOB,
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
     Ld_HoraFinGeneral              DATE;
     Ld_HoraInicioNoEstimadas1      DATE;
     Ld_HoraFinNoEstimadas1         DATE;
     Ld_HoraInicioNoEstimadasNt1    DATE;
     Ld_HoraFinNoEstimadasNt1       DATE;
     Ld_HoraFinDia1                 DATE;
     Ld_HoraInicioEncontrada        DATE;
     Ld_HoraFinEncontrada           DATE;
     Ld_FechaIngresada              DATE;

     Lv_TotalHorasSimples           NUMBER;
     Lv_TotalMinutosSimples         NUMBER;
     Lv_TotalHorasDobles            NUMBER;
     Lv_TotalMinutosDobles          NUMBER;
     Lv_TotalHorasNocturno          NUMBER;
     Lv_TotalMinutosNocturno        NUMBER;
     
     Lv_TotalHoraMinutoSimple       VARCHAR2(55);
     Lv_TotalHoraMinutoDoble        VARCHAR2(55);
     Lv_TotalHoraMinutoNocturno     VARCHAR2(55);
     Ln_Contador                    NUMBER:=0;
     Ln_Contador1                   NUMBER:=0;
     Ln_Contador2                   NUMBER:=0;
     Ln_ContadorDocumentos          NUMBER:=0;
     Ln_ContadorEmpleado            NUMBER:=0;
     Ln_ContadoreEmp                NUMBER:=1;
     Ln_Contador3                   NUMBER:=0;
     Ln_ContadorCuadrilla           NUMBER:=0;
     Ln_ContadorCua                 NUMBER:=1;
     
     Ld_Fecha                       VARCHAR2(25);
     Lv_HoraInicio                  VARCHAR2(7);
     Lv_HoraFin                     VARCHAR2(7);
     Lv_observacion                 VARCHAR2(200);
     Lv_Descripcion                 VARCHAR2(20);
     Lv_Estado                      VARCHAR2(15);
     Lv_EmpresaCod                  VARCHAR2(2);
     Lv_UsrCreacion                 VARCHAR2(15);
     Lv_IpCreacion                  VARCHAR2(15);
     Lv_TipoHorasExtraId            NUMBER;
     Lv_Horas                       VARCHAR2(7);
     Lv_JornadaEmpleado             VARCHAR2(2); 
     Lv_EsFinDeSemana               VARCHAR2(2);
     Lv_EsDiaLibre                  VARCHAR2(2);
     Lv_bandera                     VARCHAR2(6):='false';
     
     
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
                               Cv_TipoHorasExtra2 VARCHAR2) IS 
       SELECT ID_TIPO_HORAS_EXTRA,TIPO_HORAS_EXTRA
         FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA IN(Cv_TipoHorasExtra1,Cv_TipoHorasExtra2)
       ORDER BY ID_TIPO_HORAS_EXTRA ASC;
       
     CURSOR C_EXISTE_EMPLEADO(Cv_No_Emple VARCHAR2, Cv_Fecha Varchar2, Cv_Empresa VARCHAR2) IS
       SELECT DISTINCT IHS.ID_HORAS_SOLICITUD,VEE.NOMBRE,IHS.HORA_INICIO,IHS.HORA_FIN FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
        JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHS.ID_HORAS_SOLICITUD= IHSE.HORAS_SOLICITUD_ID
        JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
       WHERE IHS.FECHA=Cv_Fecha AND IHSE.NO_EMPLE=Cv_No_Emple AND IHS.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada') AND VEE.NO_CIA=Cv_Empresa
       AND IHSE.ESTADO IN ('Pendiente','Pre-Autorizada','Autorizada') AND IHS.EMPRESA_COD=Cv_Empresa
       ORDER BY IHS.ID_HORAS_SOLICITUD ASC;
     
     Ln_NoEmpleado                  apex_t_varchar2;
     Lv_TareaId                     apex_t_varchar2;
     Lv_NombreDocumento             apex_t_varchar2;
     Lv_UbicacionDocumento          apex_t_varchar2;
     Ln_IdCuadrilla                 apex_t_varchar2;
     Ln_IdHorasSolicitud            DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD.ID_HORAS_SOLICITUD%TYPE;
     Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
     Ln_IdHorasSolicitudDetalle     DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE.ID_HORAS_SOLICITUD_DETALLE%TYPE;
     Lr_ExisteEmpleado              C_EXISTE_EMPLEADO%ROWTYPE;
     Lr_idTipoHoraExtra             C_TIPO_HORAS_EXTRA%ROWTYPE;
     Le_Errors                      EXCEPTION;
     
     
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
      
      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';
       
      
      
      --HORA INICIO Y FIN INGRESADOS
      Ld_HoraInicio1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraInicio),'DD-MM-YYYY HH24:MI');   
      Ld_HoraFin1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFin),'DD-MM-YYYY HH24:MI'); 
      
      -- HORAS SIMPLES
      Ld_HoraInicioSimples1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioSimples),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinSimples1:= TO_DATE((Ld_Fecha||''||Lv_HoraFinSimples),'DD-MM-YYYY HH24:MI');
      
      
      -- HORAS DOBLES
      Ld_HoraInicioDobles1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioDobles),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinDobles1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinDobles),'DD-MM-YYYY HH24:MI');
      
      -- HORAS NOCTURNAS
      
      Ld_HorasInicioNocturnas1 := TO_DATE((Ld_Fecha||''||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
      Ld_HorasFinNocturnas1 :=  TO_DATE((Ld_Fecha||''||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');
      
      
      -- HORAS NO ESTIMADAS_MATUTINAS
      Ld_HoraInicioNoEstimadas1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioNoEstimadas),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinNoEstimadas1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinNoEstimadas),'DD-MM-YYYY HH24:MI');
      
      -- HORAS NO ESTIMADAS_NOCTURNAS
      Ld_HoraInicioNoEstimadasNt1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioNoEstimadasNt),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinNoEstimadasNt1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinNoEstimadasNt),'DD-MM-YYYY HH24:MI');
      
      -- HORA FIN DIA
      Ld_HoraFinDia1 := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
      
      
      Ln_ContadorEmpleado:=Ln_NoEmpleado.COUNT;
      WHILE Ln_ContadoreEmp<= Ln_ContadorEmpleado LOOP
      
         IF C_EXISTE_EMPLEADO%ISOPEN THEN CLOSE C_EXISTE_EMPLEADO; END IF;
         FOR Lr_ExisteEmpleado IN C_EXISTE_EMPLEADO(apex_json.get_number(p_path => Ln_NoEmpleado(Ln_ContadoreEmp)),TO_DATE(Ld_Fecha,'DD-MM-YYYY'),Lv_EmpresaCod)
         LOOP
         
             Ld_HoraInicioEncontrada := TO_DATE((Ld_Fecha||''||Lr_ExisteEmpleado.HORA_INICIO),'DD-MM-YYYY HH24:MI');
             Ld_HoraFinEncontrada := TO_DATE((Ld_Fecha||''||Lr_ExisteEmpleado.HORA_FIN),'DD-MM-YYYY HH24:MI');
             
             
             IF Ld_HoraFinEncontrada > Ld_HoraFinDia1 AND Ld_HoraFinEncontrada<Ld_HoraInicioEncontrada THEN
                Ld_HoraFinEncontrada := Ld_HoraFinEncontrada+1;
             END IF;
             
             
             IF Ld_HoraFinEncontrada = Ld_HoraFinDia1  THEN
                Ld_HoraFinEncontrada := Ld_HoraFinEncontrada+1;
             END IF;
             
             IF Ld_HoraFin1 > Ld_HoraFinDia1 AND Ld_HoraFin1<Ld_HoraInicio1 THEN
                Lv_bandera  :='true';
                Ld_HoraFin1 := Ld_HoraFin1+1;
             END IF;
             
             IF Ld_HoraFin1 = Ld_HoraFinDia1  THEN
                Lv_bandera  :='true';
                Ld_HoraFin1 := Ld_HoraFin1+1;
             END IF;
             
             IF((Ld_HoraInicio1>=Ld_HoraInicioEncontrada AND Ld_HoraInicio1<=Ld_HoraFinEncontrada AND Ld_HoraFin1>=Ld_HoraInicioEncontrada  AND Ld_HoraFin1<=Ld_HoraFinEncontrada) OR 
             (Ld_HoraInicio1>Ld_HoraInicioEncontrada AND Ld_HoraInicio1<Ld_HoraFinEncontrada AND 
             Ld_HoraFin1>Ld_HoraFinEncontrada))THEN
            
                Pv_Mensaje := 'ERROR 01: El Empleado '||Lr_ExisteEmpleado.NOMBRE||' ya tiene registrada una solicitud de horas extras ingresada el dia '||Ld_Fecha||' ';
                RAISE Le_Errors;
              
             END IF;
             
             IF(Ld_HoraInicio1<Ld_HoraInicioEncontrada AND Ld_HoraFin1>Ld_HoraInicioEncontrada AND Ld_HoraFin1<Ld_HoraFinEncontrada) THEN
                Pv_Mensaje := 'ERROR 02: El Empleado '||Lr_ExisteEmpleado.NOMBRE||' ya tiene registrada una solicitud de horas extras ingresada el dia '||Ld_Fecha||' ';
                RAISE Le_Errors;
             END IF;
             
            IF(Ld_HoraInicio1<=Ld_HoraInicioEncontrada AND Ld_HoraFin1>=Ld_HoraFinEncontrada) THEN
                Pv_Mensaje := 'ERROR 03: El Empleado '||Lr_ExisteEmpleado.NOMBRE||' ya tiene registrada una solicitud de horas extras ingresada el dia '||Ld_Fecha||' ';
                RAISE Le_Errors;
             END IF;
             
             Ld_HoraFinEncontrada := Ld_HoraFinEncontrada-1;
             
             IF Lv_bandera = 'true' THEN
               Ld_HoraFin1 := Ld_HoraFin1-1;
             END IF;
             
             Ln_Contador3:=Ln_Contador3+1;
         
         END LOOP;
        
         Ln_ContadoreEmp :=Ln_ContadoreEmp+1;
         
    
      END LOOP;
      
  
  IF Lv_EsFinDeSemana = 'N' THEN
  
      IF(Lv_JornadaEmpleado = 'M')THEN

          IF(Lv_HoraFin = Lv_HoraFinDia AND  Ld_HoraInicio1>= Ld_HoraInicioSimples1 AND Ld_HoraInicio1<=Ld_HoraFin1+1) THEN
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;

          --JORNADA MATUTINA
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadas1 AND Ld_HoraInicio1 < Ld_HoraFinNoEstimadas1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadas1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadas1 OR Ld_HoraFin1 > Ld_HoraFinNoEstimadas1) THEN
             Pv_Mensaje := 'Error 04: La hora inicio y hora fin ingresados no entran en el rango de horas extras ';
             RAISE Le_Errors;
          END IF;
      
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadas1 OR Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadas1 AND Ld_HoraInicio1 <= Ld_HoraFinNoEstimadas1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadas1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadas1)THEN
             Pv_Mensaje := 'Error 05:La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
  
          IF(Ld_HoraInicio1 >= Ld_HoraFinNoEstimadas1 AND Ld_HoraInicio1< Ld_HoraFinDia1+1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadas1 AND Ld_HoraFin1 < Ld_HoraFinNoEstimadas1) THEN
             Pv_Mensaje := 'Error 06: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
          AND (Ld_HoraFin1 > Ld_HoraInicioSimples1  AND Ld_HoraFin1 <= Ld_HoraFinSimples1+1) THEN
      
             Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
             Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
             
             IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
             END IF;
             
             Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
        
             Ln_Contador :=1;
        
             IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
             OPEN C_TIPO_HORAS_EXTRA('SIMPLE','');
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
      
          
          IF(Ld_HoraInicio1 >= Ld_HoraFinNoEstimadas1 AND Ld_HoraFin1 > Ld_HoraFinDia1 AND Ld_HoraFin1 <= Ld_HoraInicioNoEstimadas1) THEN
             Ld_HoraFin1 := Ld_HoraFin1+1;
             Ld_HoraFinSimples1 := Ld_HoraFinSimples1+1;
          END IF;
       
          IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
          AND(Ld_HoraFin1 > (Ld_HoraInicioDobles1 +1)) THEN
          
        
             Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFinSimples1 - Ld_HoraInicio1)*24,24));
             Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFinSimples1 - Ld_HoraInicio1)*24*60,60));
             Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraFinSimples1)*24,24));
             Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraFinSimples1)*24*60,60));
             
             IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
             END IF;
             
             IF(Lv_TotalMinutosDobles='29')THEN
                Lv_TotalMinutosDobles:='30';
             END IF;
           
           
             Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
             Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
             
             Ln_Contador := 2 ;
           
             FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','DOBLES')
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
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                  WHEN 'DOBLES' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                 END CASE;
               
           
             END LOOP;
           
           
          END IF;
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioDobles1 AND Ld_HoraInicio1< Ld_HoraFinDobles1)
          AND(Ld_HoraFin1 > Ld_HoraInicioDobles1 AND Ld_HoraFin1 <= Ld_HoraFinDobles1)THEN
        
              Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
              
              IF(Lv_TotalMinutosDobles='29')THEN
                Lv_TotalMinutosDobles:='30';
             END IF;
              
              Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
              
              Ln_Contador :=1;
        
              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('DOBLES','');
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
          
          IF(Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1)THEN
             Pv_Mensaje := 'Error 07: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1 AND 
              Ld_HoraFin1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HorasInicioNocturnas1)OR
              (Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 >= Ld_HorasInicioNocturnas1))THEN
             Pv_Mensaje := 'Error 08: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 >= Ld_HorasFinNocturnas1 AND Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1)AND
              (Ld_HoraFin1 >= Ld_HorasFinNocturnas1 AND Ld_HoraFin1 <= Ld_HoraInicioNoEstimadasNt1)) THEN
          
              Pv_Mensaje := 'Error 09: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
              Pv_Mensaje := 'Error 10: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HoraFinNoEstimadasNt1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadasNt1 OR Ld_HoraFin1 > Ld_HoraFinNoEstimadasNt1) THEN
             Pv_Mensaje := 'Error 11: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          
          IF((Lv_HoraFin = Lv_HoraFinDia) OR (Lv_HoraFin > Lv_HoraFinDia AND Ld_HoraInicio1>= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<= Ld_HoraFinDia1+1
          AND (Lv_HoraFin <= Lv_HorasFinNocturnas OR Lv_HoraFin<= Lv_HoraInicioNoEstimadasNt))) THEN
            Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
          
          IF(Ld_HoraInicio1 >= Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)THEN
             Ld_HoraInicio1 := Ld_HoraInicio1+1;
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
        
          
          IF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
          AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1 +1)THEN
                    
     
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
         
              Ln_Contador :=1;
      
              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','');
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
           
           END IF;
           
           
           
           IF (((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1 +1))OR(Ld_HoraInicio1<Ld_HoraFin1
           AND Ld_HoraFin1> Ld_HorasFinNocturnas1 AND Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1)) THEN
           
           
              IF Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<Ld_HoraFinDia1+1 THEN
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                    Ld_HorasFinNocturnas1:=Ld_HorasFinNocturnas1+1;
                    
              ELSE
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                 
              END IF;
              
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24*60,60));
              Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24,24));
              Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
              
              IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
              END IF;
              
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
              Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
              Ln_Contador :=2;
              
              
              
              FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','NOCTURNO')
              LOOP
                  Ln_Contador1 := Ln_Contador1+1;
              
                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;
                  
                  
                  
                  
                  CASE Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA
                    WHEN  'SIMPLE' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := Ld_FechaIngresada;
                    WHEN 'NOCTURNO' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                     
                  END CASE;
             
              END LOOP;
          
           END IF;
                  
            
  
      END IF;
  
  
  ELSIF(Lv_EsFinDeSemana = 'S') THEN
  
     
     
     IF(Lv_JornadaEmpleado = 'N') THEN
     
         -- JORNADA NOCTURNA
         
          IF(Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1)THEN
             Pv_Mensaje := 'Error 12: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1 AND 
              Ld_HoraFin1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HorasInicioNocturnas1)OR
              (Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 >= Ld_HorasInicioNocturnas1))THEN
             Pv_Mensaje := 'Error 13: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 >= Ld_HorasFinNocturnas1 AND Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1)AND
              (Ld_HoraFin1 >= Ld_HorasFinNocturnas1 AND Ld_HoraFin1 <= Ld_HoraInicioNoEstimadasNt1)) THEN
          
              Pv_Mensaje := 'Error 14: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
              Pv_Mensaje := 'Error 15: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HoraFinNoEstimadasNt1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadasNt1 OR Ld_HoraFin1 > Ld_HoraFinNoEstimadasNt1) THEN
             Pv_Mensaje := 'Error 16: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          
           IF((Lv_HoraFin = Lv_HoraFinDia) OR (Lv_HoraFin > Lv_HoraFinDia AND Ld_HoraInicio1>= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<= Ld_HoraFinDia1+1
          AND (Lv_HoraFin <= Lv_HorasFinNocturnas OR Lv_HoraFin<= Lv_HoraInicioNoEstimadasNt))) THEN
            Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
          
          IF(Ld_HoraInicio1 >= Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)THEN
             Ld_HoraInicio1 := Ld_HoraInicio1+1;
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
          
          IF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
          AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1 +1)THEN
                    
     
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
         
              Ln_Contador :=1;
      
              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','');
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
           
           END IF;
           
            
           IF (((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1 +1))OR(Ld_HoraInicio1<Ld_HoraFin1
           AND Ld_HoraFin1> Ld_HorasFinNocturnas1 AND Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1)) THEN
           
           
           
              IF Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<Ld_HoraFinDia1+1 THEN
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                    Ld_HorasFinNocturnas1:=Ld_HorasFinNocturnas1+1;
                    
              ELSE
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                 
              END IF;
              
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24*60,60));
              Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24,24));
              Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
              
              IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
              END IF;
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
              Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
              Ln_Contador :=2;
              
              
              FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','NOCTURNO')
              LOOP
                  Ln_Contador1 := Ln_Contador1+1;
              
                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;
                  
                  
                  CASE Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA
                  WHEN  'SIMPLE' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := Ld_FechaIngresada;
                  WHEN 'NOCTURNO' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                     
                 END CASE;
             
              END LOOP;
          
           END IF;
     
     ELSE
        --ASIGNACION HORAS DOBLES PARA FERIADOS Y FIN DE SEMANA
      
        Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
        IF(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
           Ld_HoraFin1:= Ld_HoraFin1 +1;
        END IF;
        
        IF(Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1) 
         AND(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1<= Ld_HoraFinGeneral + 1) THEN 
     
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DOBLES','');
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
     
     
     
         IF (Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1)AND 
            (Ld_HoraFin1 > Ld_HoraFinGeneral +1)THEN
            
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DOBLES','');
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
     
     END IF;
      
     
  
  
  END IF;
  
  IF Lv_EsDiaLibre = 'S' THEN
    
    --ASIGNACION HORAS DOBLES PARA DIAS LIBRES
      
     Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
     IF(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
       Ld_HoraFin1:= Ld_HoraFin1 +1;
     END IF;
      
  
     IF(Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1) AND(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1<= Ld_HoraFinGeneral + 1) THEN 
     
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','');
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
     
     
     
     IF (Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1)AND 
      (Ld_HoraFin1 > Ld_HoraFinGeneral +1)THEN
          
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','');
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
  
  END IF;
    
  IF(Ln_Contador = 0)THEN
     Pv_Mensaje := 'Error 17: La hora inicio y hora fin ingresadas no entran en el rango de horas extra ';
     RAISE Le_Errors;
  END IF;
    
      --Insercion en la tablas 
      
      Ln_IdHorasSolicitud := DB_HORAS_EXTRAS.SEQ_INFO_HORAS_SOLICITUD.NEXTVAL;
      
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
        Ln_IdHorasSolicitud,
        TO_DATE(Ld_Fecha,'DD-MM-YYYY'),
        Lv_HoraInicio,
        Lv_HoraFin,
        Lv_observacion,
        Lv_Descripcion,
        Lv_Estado,
        Lv_EmpresaCod,
        Lv_UsrCreacion,
        SYSDATE,
        NULL,
        NULL,
        NULL
        );
      
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
      
      
      
      
    
    
    FOR Ln_ContadorEmpleado in 1 .. Ln_NoEmpleado.COUNT LOOP
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
        
    FOR Ln_ContadorTarea in 1 .. Lv_TareaId.COUNT LOOP
     
          P_INSERTAR_TAREAS(Ln_IdHorasSolicitud,
                            apex_json.get_number(p_path => Lv_TareaId(Ln_ContadorTarea)),
                            Lv_UsrCreacion,
                            null,
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
                            Pv_Status,
                            Pv_Mensaje);
                          
          IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
          END IF;
          
          Ln_ContadorCua :=Ln_ContadorCua+1;
           
    END LOOP;
    
    
    FOR Ln_ContadorDocumentos in 1 .. Lv_NombreDocumento.COUNT LOOP
    
       
       P_INSERTAR_DOCUMENTOS(Ln_IdHorasSolicitud,
                             apex_json.get_varchar2(p_path => Lv_NombreDocumento(Ln_ContadorDocumentos)),
                             apex_json.get_varchar2(p_path => Lv_UbicacionDocumento(Ln_ContadorDocumentos)),
                             Lv_Estado,
                             Lv_UsrCreacion,
                             Pv_Status,
                             Pv_Mensaje);
      
       IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
       END IF;
       
       
    
    END LOOP;
    
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
                                                 Pv_Mensaje,
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
  
      Ln_IdHorasSolicitud            NUMBER;
      Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
      Lv_usrCreacion                 VARCHAR2(25);
      Le_Errors                      EXCEPTION;
      
  BEGIN
  
      -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud          :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud');
    Lv_usrCreacion               :=  APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    
    -- VALIDACIONES
         IF Ln_IdHorasSolicitud IS NULL THEN
            Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
            RAISE Le_Errors;
        END IF;
        
        IF C_OBSERVACION_SOLICITUD%ISOPEN THEN CLOSE C_OBSERVACION_SOLICITUD; END IF;
        
         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
          SET IHS.ESTADO='Eliminada',IHS.USR_MODIFICACION=Lv_usrCreacion,IHS.FE_MODIFICACION=SYSDATE
         WHERE IHS.ID_HORAS_SOLICITUD=''||Ln_IdHorasSolicitud||'';
         
         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD
          SET IHSD.ESTADO='Eliminada',IHSD.USR_MODIFICACION=Lv_usrCreacion, IHSD.FE_MODIFICACION=SYSDATE
         WHERE IHSD.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'';
         
         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE
          SET IHSE.ESTADO='Eliminada', IHSE.USR_MODIFICACION=Lv_usrCreacion, IHSE.FE_MODIFICACION=SYSDATE
         WHERE IHSE.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'';
         
         UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL IHSH
          SET IHSH.ESTADO='Inactiva', IHSH.USR_MODIFICACION=Lv_usrCreacion, IHSH.FE_MODIFICACION= SYSDATE
         WHERE IHSH.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'';
         
         
         FOR Lr_ObservacionSolicitud IN C_OBSERVACION_SOLICITUD(Ln_IdHorasSolicitud) 
         LOOP
         
             P_INSERT_HISTORIAL_SOLICITUD(Ln_IdHorasSolicitud,
                                          Lr_ObservacionSolicitud.TIPO_HORAS_EXTRA_ID,
                                          Lr_ObservacionSolicitud.HORA_INICIO_DET,
                                          Lr_ObservacionSolicitud.HORA_FIN_DET,
                                          Lr_ObservacionSolicitud.HORAS,
                                          Lr_ObservacionSolicitud.FECHA_SOLICITUD_DET,
                                          'Solicitud eliminada',
                                          'Eliminada',
                                          Lv_usrCreacion,
                                          Pv_Status,
                                          Pv_Mensaje);
                                              
             IF Pv_Status = 'ERROR' THEN
                RAISE Le_Errors;
             END IF;
         
         END LOOP;
         
         UPDATE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH
          SET ITH.ESTADO='Eliminada', ITH.USR_MODIFICACION=Lv_usrCreacion, ITH.FE_MODIFICACION=SYSDATE
         WHERE ITH.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'';
         
         UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE
          SET IDHE.ESTADO='Eliminada', IDHE.USR_MODIFICACION=Lv_usrCreacion, IDHE.FE_MODIFICACION=SYSDATE
         WHERE IDHE.HORAS_SOLICITUD_ID = ''||Ln_IdHorasSolicitud||'';
         
        COMMIT; 
             
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
      Ln_IdHorasSolicitud       apex_t_varchar2;
      Lv_Estado                 VARCHAR2(15);
      Lv_nombrePantalla         VARCHAR2(25);
      Lv_EmpresaCod             VARCHAR2(2);
      Lv_Usuario                VARCHAR2(25);
      Le_Errors                 EXCEPTION;
      
  BEGIN
  
      -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud := APEX_JSON.find_paths_like(p_return_path => 'idHorasSolicitud[%]' );
    Lv_Estado           := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_nombrePantalla   := APEX_JSON.get_varchar2(p_path => 'nombrePantalla');
    Lv_Usuario          := APEX_JSON.get_varchar2(p_path => 'usuario');
    Lv_EmpresaCod       := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    
    -- VALIDACIONES
        IF Lv_Estado IS NULL THEN
            Pv_Mensaje := 'El parámetro estado está vacío';
            RAISE Le_Errors;
        END IF;
   
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
     Ld_HoraFinGeneral              DATE;
     Ld_HoraInicioNoEstimadas1      DATE;
     Ld_HoraFinNoEstimadas1         DATE;
     Ld_HoraInicioNoEstimadasNt1    DATE;	
     Ld_HoraFinNoEstimadasNt1       DATE;
     Ld_HoraFinDia1                 DATE;
     Ld_FechaIngresada              DATE;
     
     Lv_TotalHorasSimples           NUMBER;
     Lv_TotalMinutosSimples         NUMBER;
     Lv_TotalHorasDobles            NUMBER;
     Lv_TotalMinutosDobles          NUMBER;
     Lv_TotalHorasNocturno          NUMBER;
     Lv_TotalMinutosNocturno        NUMBER;
     
     Lv_TotalHoraMinutoSimple       VARCHAR2(55);
     Lv_TotalHoraMinutoDoble        VARCHAR2(55);
     Lv_TotalHoraMinutoNocturno     VARCHAR2(55);
     Ln_Contador                    NUMBER:=0;
     Ln_Contador1                   NUMBER:=0;
     Ln_Contador2                   NUMBER:=0;
     Ln_ContadorDocumentos          NUMBER:=0;
     Ln_ContadorCuadrilla           NUMBER:=0;
     Ln_ContadorCua                 NUMBER:=1;
     
     
     Ld_Fecha                       VARCHAR2(25);
     Lv_HoraInicio                  VARCHAR2(7);
     Lv_HoraFin                     VARCHAR2(7);
     Lv_observacion                 VARCHAR2(200);
     Lv_Descripcion                 VARCHAR2(20);
     Lv_Estado                      VARCHAR2(15);
     Lv_EmpresaCod                  VARCHAR2(2);
     Lv_UsrCreacion                 VARCHAR2(15);
     Lv_IpCreacion                  VARCHAR2(15);
     Lv_TipoHorasExtraId            NUMBER;
     Lv_Horas                       VARCHAR2(7);
     Lv_JornadaEmpleado             VARCHAR2(2); 
     Lv_EsFinDeSemana               VARCHAR2(2);
     Lv_EsDiaLibre                  VARCHAR2(2);
     
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
                               Cv_TipoHorasExtra2 VARCHAR2) IS 
       SELECT ID_TIPO_HORAS_EXTRA,TIPO_HORAS_EXTRA
        FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA IN(Cv_TipoHorasExtra1,Cv_TipoHorasExtra2)
       ORDER BY ID_TIPO_HORAS_EXTRA ASC;
     
     Ln_NoEmpleado                  apex_t_varchar2;
     Lv_TareaId                     apex_t_varchar2;
     Lv_NombreDocumento             apex_t_varchar2;
     Lv_UbicacionDocumento          apex_t_varchar2;
     Ln_IdCuadrilla                 apex_t_varchar2;
     Ln_IdHorasSolicitud            DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD.ID_HORAS_SOLICITUD%TYPE;
     Ln_IdHorasSolicitudHistorial   DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL.ID_HORAS_SOLICITUD_HISTORIAL%TYPE;
     Ln_IdHorasSolicitudDetalle     DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE.ID_HORAS_SOLICITUD_DETALLE%TYPE;
     Ln_idTipoHoraExtra             DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA.ID_TIPO_HORAS_EXTRA%TYPE;
     Lr_idTipoHoraExtra             C_TIPO_HORAS_EXTRA%ROWTYPE;
     Le_Errors                      EXCEPTION;
     
     
    
     
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
      
      SELECT HORA_INICIO,HORA_FIN
       INTO Lv_HorasInicioNocturnas,Lv_HorasFinNocturnas
      FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA
       WHERE TIPO_HORAS_EXTRA = 'NOCTURNO';
       
       --HORA INICIO Y FIN INGRESADOS
      Ld_HoraInicio1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraInicio),'DD-MM-YYYY HH24:MI');   
      Ld_HoraFin1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFin),'DD-MM-YYYY HH24:MI'); 
      
      --PARAMETROS HORAS SIMPLES
      Ld_HoraInicioSimples1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioSimples),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinSimples1:= TO_DATE((Ld_Fecha||''||Lv_HoraFinSimples),'DD-MM-YYYY HH24:MI');
      
      
      --PARAMETROS HORAS DOBLES
      Ld_HoraInicioDobles1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioDobles),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinDobles1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinDobles),'DD-MM-YYYY HH24:MI');
      
      --PARAMETROS HORAS NOCTURNAS
      
      Ld_HorasInicioNocturnas1 := TO_DATE((Ld_Fecha||''||Lv_HorasInicioNocturnas),'DD-MM-YYYY HH24:MI');
      Ld_HorasFinNocturnas1 :=  TO_DATE((Ld_Fecha||''||Lv_HorasFinNocturnas),'DD-MM-YYYY HH24:MI');
      
      -- HORAS NO ESTIMADAS_MATUTINAS
      Ld_HoraInicioNoEstimadas1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioNoEstimadas),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinNoEstimadas1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinNoEstimadas),'DD-MM-YYYY HH24:MI');
      
      -- HORAS NO ESTIMADAS_NOCTURNAS
      Ld_HoraInicioNoEstimadasNt1 := TO_DATE((Ld_Fecha||''||Lv_HoraInicioNoEstimadasNt),'DD-MM-YYYY HH24:MI');
      Ld_HoraFinNoEstimadasNt1 :=  TO_DATE((Ld_Fecha||''||Lv_HoraFinNoEstimadasNt),'DD-MM-YYYY HH24:MI');
      
      -- HORA FIN DIA
      Ld_HoraFinDia1 := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
    
    IF Lv_EsFinDeSemana = 'N' THEN
  
      IF(Lv_JornadaEmpleado = 'M')THEN

          IF(Lv_HoraFin = Lv_HoraFinDia AND  Ld_HoraInicio1>= Ld_HoraInicioSimples1 AND Ld_HoraInicio1<=Ld_HoraFin1+1) THEN
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;

          --JORNADA MATUTINA
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadas1 AND Ld_HoraInicio1 < Ld_HoraFinNoEstimadas1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadas1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadas1 OR Ld_HoraFin1 > Ld_HoraFinNoEstimadas1) THEN
             Pv_Mensaje := 'Error 01: La hora inicio y hora fin ingresados no entran en el rango de horas extras ';
             RAISE Le_Errors;
          END IF;
      
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadas1 OR Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadas1 AND Ld_HoraInicio1 <= Ld_HoraFinNoEstimadas1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadas1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadas1)THEN
             Pv_Mensaje := 'Error 02:La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
  
          IF(Ld_HoraInicio1 >= Ld_HoraFinNoEstimadas1 AND Ld_HoraInicio1< Ld_HoraFinDia1+1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadas1 AND Ld_HoraFin1 < Ld_HoraFinNoEstimadas1) THEN
             Pv_Mensaje := 'Error 03: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
          AND (Ld_HoraFin1 > Ld_HoraInicioSimples1  AND Ld_HoraFin1 <= Ld_HoraFinSimples1+1) THEN
      
             Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
             Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
             
             IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
             END IF;
        
             Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
        
             Ln_Contador :=1;
        
             IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
             OPEN C_TIPO_HORAS_EXTRA('SIMPLE','');
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
      
          
          IF(Ld_HoraInicio1 >= Ld_HoraFinNoEstimadas1 AND Ld_HoraFin1 > Ld_HoraFinDia1 AND Ld_HoraFin1 <= Ld_HoraInicioNoEstimadas1) THEN
             Ld_HoraFin1 := Ld_HoraFin1+1;
             Ld_HoraFinSimples1 := Ld_HoraFinSimples1+1;
          END IF;
       
          IF(Ld_HoraInicio1 >= Ld_HoraInicioSimples1  AND Ld_HoraInicio1 < Ld_HoraFinSimples1+1)
          AND(Ld_HoraFin1 > (Ld_HoraInicioDobles1 +1)) THEN
          
        
             Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFinSimples1 - Ld_HoraInicio1)*24,24));
             Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFinSimples1 - Ld_HoraInicio1)*24*60,60));
             Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraFinSimples1)*24,24));
             Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraFinSimples1)*24*60,60));
             
             IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
             END IF;
             
             IF(Lv_TotalMinutosDobles='29')THEN
                Lv_TotalMinutosDobles:='30';
             END IF;
           
           
             Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
             Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
             
             Ln_Contador := 2 ;
           
             FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','DOBLES')
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
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                  WHEN 'DOBLES' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraFinDia1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoDoble,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                 END CASE;
               
           
             END LOOP;
           
           
          END IF;
          
          
      
          IF(Ld_HoraInicio1 >= Ld_HoraInicioDobles1 AND Ld_HoraInicio1< Ld_HoraFinDobles1)
          AND(Ld_HoraFin1 > Ld_HoraInicioDobles1 AND Ld_HoraFin1 <= Ld_HoraFinDobles1)THEN
        
              Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
              
              IF(Lv_TotalMinutosDobles='29')THEN
                Lv_TotalMinutosDobles:='30';
             END IF;
              
              Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
              
              Ln_Contador :=1;
        
              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('DOBLES','');
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
          
          
          IF(Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1)THEN
             Pv_Mensaje := 'Error 04: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1 AND 
              Ld_HoraFin1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HorasInicioNocturnas1)OR
              (Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 >= Ld_HorasInicioNocturnas1))THEN
             Pv_Mensaje := 'Error 05: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 >= Ld_HorasFinNocturnas1 AND Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1)AND
              (Ld_HoraFin1 >= Ld_HorasFinNocturnas1 AND Ld_HoraFin1 <= Ld_HoraInicioNoEstimadasNt1)) THEN
          
              Pv_Mensaje := 'Error 06: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
              Pv_Mensaje := 'Error 07: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HoraFinNoEstimadasNt1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadasNt1 OR Ld_HoraFin1 > Ld_HoraFinNoEstimadasNt1) THEN
             Pv_Mensaje := 'Error 08: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          
           IF((Lv_HoraFin = Lv_HoraFinDia) OR (Lv_HoraFin > Lv_HoraFinDia AND Ld_HoraInicio1>= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<= Ld_HoraFinDia1+1
          AND (Lv_HoraFin <= Lv_HorasFinNocturnas OR Lv_HoraFin<= Lv_HoraInicioNoEstimadasNt))) THEN
            Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
          
          IF(Ld_HoraInicio1 >= Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)THEN
             Ld_HoraInicio1 := Ld_HoraInicio1+1;
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
        
          
          IF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
          AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1 +1)THEN
                    
     
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
         
              Ln_Contador :=1;
      
              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','');
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
           
           END IF;
           
           IF (((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1 +1))OR(Ld_HoraInicio1<Ld_HoraFin1
           AND Ld_HoraFin1> Ld_HorasFinNocturnas1 AND Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1)) THEN
           
           
              IF Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<Ld_HoraFinDia1+1 THEN
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                    Ld_HorasFinNocturnas1:=Ld_HorasFinNocturnas1+1;
                    
              ELSE
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                 
              END IF;
              
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24*60,60));
              Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24,24));
              Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
              
              IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
              END IF;
              
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
              Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
              Ln_Contador :=2;
              
              
              FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','NOCTURNO')
              LOOP
                  Ln_Contador1 := Ln_Contador1+1;
              
                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;
                  
                  
                  
                  CASE Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA
                  WHEN  'SIMPLE' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := Ld_FechaIngresada;
                  WHEN 'NOCTURNO' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                     
                 END CASE;
             
              END LOOP;
          
           END IF;
                  
            
  
      END IF;
  
  
  ELSIF(Lv_EsFinDeSemana = 'S') THEN
  
     
     
     IF(Lv_JornadaEmpleado = 'N') THEN
     
         -- JORNADA NOCTURNA
         
          IF(Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1)THEN
             Pv_Mensaje := 'Error 09: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HorasInicioNocturnas1 AND 
              Ld_HoraFin1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HorasInicioNocturnas1)OR
              (Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 >= Ld_HorasInicioNocturnas1))THEN
             Pv_Mensaje := 'Error 10: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          IF((Ld_HoraInicio1 >= Ld_HorasFinNocturnas1 AND Ld_HoraInicio1 <= Ld_HoraInicioNoEstimadasNt1)AND
              (Ld_HoraFin1 >= Ld_HorasFinNocturnas1 AND Ld_HoraFin1 <= Ld_HoraInicioNoEstimadasNt1)) THEN
          
              Pv_Mensaje := 'Error 11: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          IF(Ld_HoraInicio1>Ld_HoraFin1 AND Ld_HoraInicio1<Ld_HorasInicioNocturnas1)THEN
              Pv_Mensaje := 'Error 12: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
              RAISE Le_Errors;
          END IF;
          
          
          IF(Ld_HoraInicio1 >= Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraInicio1 < Ld_HoraFinNoEstimadasNt1)
          AND(Ld_HoraFin1 > Ld_HoraInicioNoEstimadasNt1 AND Ld_HoraFin1 <= Ld_HoraFinNoEstimadasNt1 OR Ld_HoraFin1 > Ld_HoraFinNoEstimadasNt1) THEN
             Pv_Mensaje := 'Error 13: La hora inicio y hora fin ingresados no entran en el rango de horas extras';
             RAISE Le_Errors;
          END IF;
          
          
           IF((Lv_HoraFin = Lv_HoraFinDia) OR (Lv_HoraFin > Lv_HoraFinDia AND Ld_HoraInicio1>= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<= Ld_HoraFinDia1+1
          AND (Lv_HoraFin <= Lv_HorasFinNocturnas OR Lv_HoraFin<= Lv_HoraInicioNoEstimadasNt))) THEN
            Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
          
          IF(Ld_HoraInicio1 >= Ld_HoraFinDia1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1)THEN
             Ld_HoraInicio1 := Ld_HoraInicio1+1;
             Ld_HoraFin1 := Ld_HoraFin1+1;
          END IF;
          
          IF (Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
          AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1<= Ld_HorasFinNocturnas1 +1)THEN
                    
     
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
         
              Ln_Contador :=1;
      
              IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
              OPEN C_TIPO_HORAS_EXTRA('NOCTURNO','');
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
           
           END IF;
           
            
           IF (((Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1 < Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1 > Ld_HorasInicioNocturnas1 AND Ld_HoraFin1> Ld_HorasFinNocturnas1 +1)
           AND (Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1 +1))OR(Ld_HoraInicio1<Ld_HoraFin1
           AND Ld_HoraFin1> Ld_HorasFinNocturnas1 AND Ld_HoraFin1<= Ld_HoraInicioNoEstimadasNt1)) THEN
           
              IF Ld_HoraInicio1 >= Ld_HorasInicioNocturnas1 AND Ld_HoraInicio1<Ld_HoraFinDia1+1 THEN
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY')+1;
                    Ld_HorasFinNocturnas1:=Ld_HorasFinNocturnas1+1;
                    
              ELSE
                  
                    Ld_FechaIngresada:=  TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                 
              END IF;
              
              Lv_TotalHorasNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24,24));
              Lv_TotalMinutosNocturno := TRUNC(MOD((Ld_HorasFinNocturnas1 - Ld_HoraInicio1)*24*60,60));
              Lv_TotalHorasSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24,24));
              Lv_TotalMinutosSimples := TRUNC(MOD((Ld_HoraFin1 - Ld_HorasFinNocturnas1)*24*60,60));
              
              IF(Lv_TotalMinutosNocturno='29')THEN
                Lv_TotalMinutosNocturno:='30';
              END IF;
              
              IF(Lv_TotalMinutosSimples='29')THEN
                Lv_TotalMinutosSimples:='30';
              END IF;
         
              Lv_TotalHoraMinutoNocturno := Lv_TotalHorasNocturno||':'||Lv_TotalMinutosNocturno;
              Lv_TotalHoraMinutoSimple := Lv_TotalHorasSimples||':'||Lv_TotalMinutosSimples;
              Ln_Contador :=2;
              
              
              FOR Ln_idTipoHoraExtra IN C_TIPO_HORAS_EXTRA('SIMPLE','NOCTURNO')
              LOOP
                  Ln_Contador1 := Ln_Contador1+1;
              
                  C_HoraInicioDet.extend;
                  C_HoraFinDet.extend;
                  C_ListaHoras.extend;
                  C_TipoHorasExtra.extend;
                  C_FechaDet.extend;
                  
                  
                  CASE Ln_idTipoHoraExtra.TIPO_HORAS_EXTRA
                  WHEN  'SIMPLE' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HoraFin1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoSimple,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := Ld_FechaIngresada;
                  WHEN 'NOCTURNO' THEN
                     C_HoraInicioDet(Ln_Contador1):= TO_CHAR(Ld_HoraInicio1,'HH24:MI');
                     C_HoraFinDet(Ln_Contador1):= TO_CHAR(Ld_HorasFinNocturnas1,'HH24:MI');
                     C_ListaHoras(Ln_Contador1):=TO_CHAR(TO_DATE(Lv_TotalHoraMinutoNocturno,'HH24:MI'),'HH24:MI');
                     C_TipoHorasExtra(Ln_Contador1):= Ln_idTipoHoraExtra.ID_TIPO_HORAS_EXTRA;
                     C_FechaDet(Ln_Contador1) := TO_DATE(Ld_Fecha,'DD-MM-YYYY');
                     
                 END CASE;
             
              END LOOP;
          
           END IF;
     
     ELSE
        --ASIGNACION HORAS DOBLES PARA FERIADOS Y FIN DE SEMANA
      
        Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
        IF(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
           Ld_HoraFin1:= Ld_HoraFin1 +1;
        END IF;
        
        IF(Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1) 
         AND(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1<= Ld_HoraFinGeneral + 1) THEN 
     
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DOBLES','');
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
     
     
     
         IF (Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1)AND 
            (Ld_HoraFin1 > Ld_HoraFinGeneral +1)THEN
            
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DOBLES','');
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
     
     END IF;
      
     
  
  
  END IF;
  
  IF Lv_EsDiaLibre = 'S' THEN
    
    --ASIGNACION HORAS DOBLES PARA DIAS LIBRES
      
     Ld_HoraFinGeneral := TO_DATE((Ld_Fecha||''||Lv_HoraFinDia),'DD-MM-YYYY HH24:MI');
      
     IF(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1 < Ld_HoraInicio1)THEN
       Ld_HoraFin1:= Ld_HoraFin1 +1;
     END IF;
      
  
     IF(Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1) AND(Ld_HoraFin1>=Ld_HoraFinGeneral AND Ld_HoraFin1<= Ld_HoraFinGeneral + 1) THEN 
     
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','');
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
     
     
     
     IF (Ld_HoraInicio1>=Ld_HoraFinGeneral AND Ld_HoraInicio1 <= Ld_HoraFinGeneral + 1)AND 
      (Ld_HoraFin1 > Ld_HoraFinGeneral +1)THEN
          
           Lv_TotalHorasDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24,24));
           Lv_TotalMinutosDobles := TRUNC(MOD((Ld_HoraFin1 - Ld_HoraInicio1)*24*60,60));
           
           IF(Lv_TotalMinutosDobles='29')THEN
              Lv_TotalMinutosDobles:='30';
           END IF;
          
           Lv_TotalHoraMinutoDoble := Lv_TotalHorasDobles||':'||Lv_TotalMinutosDobles;
           
           Ln_Contador :=1;
        
           IF C_TIPO_HORAS_EXTRA%ISOPEN THEN CLOSE C_TIPO_HORAS_EXTRA; END IF;
           OPEN C_TIPO_HORAS_EXTRA('DIALIBRE_DOBLE','');
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
  
   END IF;
  
   IF(Ln_Contador = 0)THEN
     Pv_Mensaje := 'Error 14: La hora inicio y fin ingresadas no entran en el rango de horas extra';
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
                            Pv_Status,
                            Pv_Mensaje);
                          
          IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
          END IF;
          
          Ln_ContadorCua :=Ln_ContadorCua+1;
           
    END LOOP;
    
   
    UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS
     SET ESTADO='Inactivo'
    WHERE HORAS_SOLICITUD_ID=Ln_IdHorasSolicitud;
    
    
    FOR Ln_ContadorDocumentos in 1 .. Lv_NombreDocumento.COUNT LOOP
    
      P_INSERTAR_DOCUMENTOS(Ln_IdHorasSolicitud,
                            apex_json.get_varchar2(p_path => Lv_NombreDocumento(Ln_ContadorDocumentos)),
                            apex_json.get_varchar2(p_path => Lv_UbicacionDocumento(Ln_ContadorDocumentos)),
                            Lv_Estado,
                            Lv_UsrCreacion,
                            Pv_Status,
                            Pv_Mensaje);
      
       IF Pv_Status = 'ERROR' THEN
              RAISE Le_Errors;
       END IF;
       
     
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
      
      
  BEGIN
  
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
         Pv_Estado,
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
                              Pv_Status           OUT VARCHAR2,
                              Pv_Mensaje          OUT VARCHAR2)
                                
   AS
   
        Ln_IdTareasHoras               DB_HORAS_EXTRAS.INFO_TAREAS_HORAS.ID_TAREAS_HORAS%TYPE;
   
   
   BEGIN
       
        Ln_IdTareasHoras := DB_HORAS_EXTRAS.SEQ_INFO_TAREAS_HORAS.NEXTVAL;
        INSERT
          INTO DB_HORAS_EXTRAS.INFO_TAREAS_HORAS
          (
           ID_TAREAS_HORAS,
           HORAS_SOLICITUD_ID,
           TAREA_ID,
           ESTADO,
           USR_CREACION,
           FE_CREACION,
           USR_MODIFICACION,
           FE_MODIFICACION,
           IP_CREACION,
           CUADRILLA_ID
           )
           VALUES
           (
           Ln_IdTareasHoras,
           Pn_IdHorasSolicitud,
           Pn_TareaId,
           'Pendiente',
           Pv_usrCreacion,
           SYSDATE,
           NULL,
           NULL,
           NULL,
           Pn_IdCuadrilla
           );
           
           COMMIT;
           
           Pv_Status     := 'OK';
           Pv_Mensaje    := 'Transacción exitosa';
   
   EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'Se ha producido un error en el proceso HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_TAREAS: - '||SQLCODE||' -ERROR- '||SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                 'HEKG_HORASEXTRAS_TRANSACCION.P_INSERTAR_TAREAS: ',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));                          
                                
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
    
       UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS SET IHS.ESTADO='Anulada'
         WHERE IHS.ID_HORAS_SOLICITUD = Pn_IdHorasSolicitud AND IHS.ESTADO='Pendiente';
         
       UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD SET IHSD.ESTADO='Anulada'
        WHERE IHSD.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IHSD.ESTADO='Pendiente';
        
       UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE SET IHSE.ESTADO='Anulada'
        WHERE IHSE.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IHSE.ESTADO='Pendiente'; 
        
        
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
        WHERE ITH.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND ITH.ESTADO='Pendiente';
      
       UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE SET IDHE.ESTADO='Anulada'
        WHERE IDHE.HORAS_SOLICITUD_ID = Pn_IdHorasSolicitud AND IDHE.ESTADO='Pendiente';        
        
        
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
           WHERE IHS.ID_HORAS_SOLICITUD=''||Pn_IdHorasSolicitud AND IHS.ESTADO='Pendiente';
           
           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE
            SET IHSE.ESTADO= ''||Pv_Estado||'', IHSE.USR_MODIFICACION=Pv_Usuario, IHSE.FE_MODIFICACION = SYSDATE
           WHERE IHSE.HORAS_SOLICITUD_ID=''|| Pn_IdHorasSolicitud AND IHSE.ESTADO='Pendiente';
           
           UPDATE DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD
            SET IHSD.ESTADO=''||Pv_Estado||'', IHSD.USR_MODIFICACION=Pv_Usuario, IHSD.FE_MODIFICACION = SYSDATE
           WHERE IHSD.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND IHSD.ESTADO='Pendiente';
           
           
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
           WHERE ITH.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND ITH.ESTADO='Pendiente';
         
           UPDATE DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE
            SET IDHE.ESTADO=''||Pv_Estado||'', IDHE.USR_MODIFICACION=Pv_Usuario, IDHE.FE_MODIFICACION = SYSDATE
           WHERE IDHE.HORAS_SOLICITUD_ID = ''||Pn_IdHorasSolicitud AND IDHE.ESTADO='Pendiente';
           
           
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
        Lv_Usuario             VARCHAR2(25);
        Le_Errors              EXCEPTION;
    
    
        CURSOR C_SOLICITUDES_DEPARTAMENTO(Cv_Departamento VARCHAR2,
                                          Cv_EmpresaCod   VARCHAR2) IS
         SELECT DISTINCT IHS.ID_HORAS_SOLICITUD
          FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS
           JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
           JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE= IHSE.NO_EMPLE
          WHERE IHS.ESTADO='Pre-Autorizada' AND IHS.EMPRESA_COD=Cv_EmpresaCod AND VEE.NO_CIA=Cv_EmpresaCod
           AND VEE.NOMBRE_DEPTO=Cv_Departamento;
    
    BEGIN
    
         -- RETORNO LAS VARIABLES DEL REQUEST
         APEX_JSON.PARSE(Pcl_Request);
         Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
         Lv_NombreDpto          := APEX_JSON.get_varchar2(p_path => 'nombreDpto');
         Lv_Usuario             := APEX_JSON.get_varchar2(p_path => 'usuario');
    
         IF C_SOLICITUDES_DEPARTAMENTO%ISOPEN THEN CLOSE C_SOLICITUDES_DEPARTAMENTO; END IF;
    
         FOR Lr_Solicitudes IN C_SOLICITUDES_DEPARTAMENTO(Lv_NombreDpto,Lv_EmpresaCod)LOOP
         
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
                         IHS.FECHA, IHS.OBSERVACION, 
                         IHS.ID_HORAS_SOLICITUD, IHSD.HORA_INICIO_DET HORA_INICIO, 
                         IHSD.HORA_FIN_DET HORA_FIN,IHSD.HORAS, ATHE.TIPO_HORAS_EXTRA,VEE.NOMBRE_DEPTO,VEE.NOMBRE_PROVINCIA,VEE.NOMBRE_CANTON
                       FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON IHSE.NO_EMPLE = VEE.NO_EMPLE AND IHS.EMPRESA_COD = VEE.NO_CIA
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                       WHERE IHS.EMPRESA_COD=Cv_EmpresaCod
                          AND TO_CHAR(IHS.FECHA,'MM-YYYY')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM-YYYY')
                          AND IHS.ESTADO='Autorizada' AND IHSE.ESTADO='Autorizada' AND IHSD.ESTADO='Autorizada'
                       ORDER BY VEE.NOMBRE_DEPTO,VEE.NOMBRE, IHS.ID_HORAS_SOLICITUD;
                       
                CURSOR C_REPORTE_SOLICITUDES_DET_B(Cv_EmpresaCod VARCHAR2) IS
                  SELECT VEE.CEDULA, VEE.NOMBRE,
                         IHS.FECHA, IHS.OBSERVACION, 
                         IHS.ID_HORAS_SOLICITUD, IHSD.HORA_INICIO_DET HORA_INICIO, 
                         IHSD.HORA_FIN_DET HORA_FIN,IHSD.HORAS, ATHE.TIPO_HORAS_EXTRA,VEE.NOMBRE_DEPTO,VEE.NOMBRE_PROVINCIA,VEE.NOMBRE_CANTON
                       FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON IHSE.NO_EMPLE = VEE.NO_EMPLE AND IHS.EMPRESA_COD = VEE.NO_CIA
                         JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                         JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                       WHERE IHS.EMPRESA_COD=Cv_EmpresaCod
                          AND TO_CHAR(IHS.FECHA,'MM-YYYY')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM-YYYY')
                          AND IHS.ESTADO='Autorizada' AND IHSE.ESTADO='Autorizada' AND IHSD.ESTADO='Autorizada'
                       ORDER BY VEE.NOMBRE_DEPTO,VEE.NOMBRE, IHS.ID_HORAS_SOLICITUD;
      
              CURSOR C_SOLICITUDES_PENDIENTES IS
                  SELECT IHS.ID_HORAS_SOLICITUD
                     FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS
                    WHERE TO_CHAR(IHS.FECHA,'MM-YYYY')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM-YYYY')
                     AND ESTADO ='Pendiente';
                     
               CURSOR C_CORREO_DESTINATARIO(Cv_EmpresaCod VARCHAR2)IS
                 SELECT APD.VALOR1 
                   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
                  WHERE APD.PARAMETRO_ID=(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CORREO_DESTINATARIO_HE')
                   AND APD.EMPRESA_COD=Cv_EmpresaCod AND APD.ESTADO='Activo';
                   
                   
                   Lv_Directorio            VARCHAR2(50):= 'DIR_REPHEXTRAS';
                   Lv_Delimitador           VARCHAR2(1):= ';';
                   Lv_Remitente             VARCHAR2(100):= Pv_Remitente; 
                   Lv_Asunto                VARCHAR2(300):= Pv_Asunto;
                   Lv_Cuerpo                VARCHAR2(9999); 
                   Lv_CuerpoB               VARCHAR2(9999); 
                   Lv_FechaReporte          VARCHAR2(50):=TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
                   Lr_Valor1                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
                   Lv_NombreArchivo         VARCHAR2(150);
                   Lv_NombreArchivoZip      VARCHAR2(250);
                   Lv_NombreArchivoZipRs    VARCHAR2(250);
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
                  
                  Lv_NombreArchivo     := 'ReporteSolicitudesDetalladoHE_'||Lv_FechaReporte||'.csv';
                  Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',32767);
                  --
                     utl_file.put_line(Lfile_Archivo,'CEDULA'                    ||Lv_Delimitador
                                                   ||'NOMBRES'                   ||Lv_Delimitador
                                                   ||'FECHA'                     ||Lv_Delimitador
                                                   ||'OBSERVACION'               ||Lv_Delimitador
                                                   ||'NUMERO SOLICITUD'          ||Lv_Delimitador
                                                   ||'HORA INICIO'               ||Lv_Delimitador
                                                   ||'HORA FIN'                  ||Lv_Delimitador
                                                   ||'HORAS'                     ||Lv_Delimitador
                                                   ||'TIPO HORAS EXTRA'          ||Lv_Delimitador
                                                   ||'DEPARTAMENTO'              ||Lv_Delimitador
                                                   ||'PROVINCIA'                 ||Lv_Delimitador
                                                   ||'CANTON'                    ||Lv_Delimitador);
                      
                      
                          FOR Lr_ReporteSolicitudes IN C_REPORTE_SOLICITUDES_DET(Pv_EmpresaCod) LOOP
    
                                       UTL_FILE.PUT_LINE(Lfile_Archivo,
                                               NVL(Lr_ReporteSolicitudes.CEDULA, '')                 ||Lv_Delimitador
                                              ||NVL(Lr_ReporteSolicitudes.NOMBRE, '')                ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.FECHA, '')                  ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.OBSERVACION, '')            ||Lv_Delimitador   
                                             ||NVL(Lr_ReporteSolicitudes.ID_HORAS_SOLICITUD, 0)      ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.HORA_INICIO, '')            ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.HORA_FIN, '')               ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.HORAS, '')                  ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.TIPO_HORAS_EXTRA, '')       ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.NOMBRE_DEPTO, '')           ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.NOMBRE_PROVINCIA, '')       ||Lv_Delimitador
                                             ||NVL(Lr_ReporteSolicitudes.NOMBRE_CANTON, '')          ||Lv_Delimitador
                                        );
    
    
                           END LOOP;
    
     
                           UTL_FILE.fclose(Lfile_Archivo);
    
                           --REPORTE_SOLICITUDES_RESUMIDO
    
                     Lv_NombreArchivoRs     := 'ReporteSolicitudesResumidoHE_'||Lv_FechaReporte||'.csv';
                     Lfile_ArchivoRs        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivoRs,'w',32767);
                     --
                     utl_file.put_line(Lfile_ArchivoRs,'NOMBRE'          ||Lv_Delimitador
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
                                                NVL(Lr_ReporteSolicitudes.NOMBRE, '')            ||Lv_Delimitador
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
                     
                     IF C_CORREO_DESTINATARIO%FOUND THEN  
                     
                          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                                    Lr_valor1,
                                                                    Lv_Asunto, 
                                                                    Lv_Cuerpo, 
                                                                    Lv_Directorio,
                                                                    Lv_NombreArchivo);

                          UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivo);
                            
                          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                                    Lr_valor1,
                                                                    Lv_Asunto, 
                                                                    Lv_CuerpoB, 
                                                                    Lv_Directorio,
                                                                    Lv_NombreArchivoRs);

                          UTL_FILE.FREMOVE(Lv_Directorio,Lv_NombreArchivoRs);
                     
                     
                     END IF;
                     
    
                    
                    
                  CLOSE C_CORREO_DESTINATARIO;
   
                  
                  FOR Ln_SolicitudesPendientes IN C_SOLICITUDES_PENDIENTES 
                  LOOP
    
    
                       DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_ACTUALIZACION_GENERAL_SOLI(Ln_SolicitudesPendientes.ID_HORAS_SOLICITUD,
                                                                                                 Lv_Estado,
                                                                                                 Lv_Mensaje);
    
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
    
        CURSOR C_INFORMACION_SOLICITUD(Cv_EmpresaCod VARCHAR2,Pn_IdHorasSolicitud NUMBER, Cv_Estado1 VARCHAR2,Cv_Estado2 VARCHAR2) IS
            SELECT VEE.NOMBRE,IHS.FECHA FECHA_SOLICITUD,
                IHS.HORA_INICIO,IHS.HORA_FIN,
                IHS.OBSERVACION,IHS.ESTADO,IHS.USR_CREACION,VEE.MAIL_CIA 
             FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
              JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
             WHERE IHS.EMPRESA_COD=Cv_EmpresaCod
              AND VEE.NO_CIA=Cv_EmpresaCod AND IHS.ID_HORAS_SOLICITUD=Pn_IdHorasSolicitud AND IHS.ESTADO IN(Cv_Estado1,Cv_Estado2);
              
              
       CURSOR C_CORREO_REMITENTE(Cv_EmpresaCod VARCHAR2)IS
           SELECT APD.VALOR1 
            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
           WHERE APD.PARAMETRO_ID=(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CORREO_GERENCIAL_HE')
            AND APD.EMPRESA_COD=Cv_EmpresaCod AND APD.ESTADO='Activo';
         
    
       
        Lv_Cuerpo             VARCHAR2(9999);
        Pv_Status             VARCHAR2(1000);
        Lv_Estado1            VARCHAR2(20):='';
        Lv_Estado2            VARCHAR2(20):='';
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
        
        
        IF(Pv_Proceso='Anulacion')THEN
          Lv_Estado1:='Pendiente';
          Lv_Estado2:='Pre-Autorizada';
          Lv_EstadoSolicitud:='Anulada';
          
        ELSIF(Pv_Proceso='PreAutorizacion') THEN
          Lv_Estado1:='Pendiente';
          Lv_Estado2:='';
          Lv_EstadoSolicitud:='Pre-Autorizada';
        
        END IF;
    
        FOR Lr_InfoSolicitud IN C_INFORMACION_SOLICITUD(Pv_EmpresaCod,Pn_IdHorasSolicitud,Lv_Estado1,Lv_Estado2) LOOP
         
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
    
END HEKG_HORASEXTRAS_TRANSACCION;
/
