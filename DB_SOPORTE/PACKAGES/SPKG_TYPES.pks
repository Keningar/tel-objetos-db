CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_TYPES
AS
  /**
  * Documentacion para el PKG SPKG_TYPES
  * El PKG BFNKG_TYPES contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
  * separando procedimientos y funciones de las declaraciones de variables
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 20-04-2018
  */
--
  /*
  * Documentacion para TYPE 'Lr_AsignacionSolicitud'.
  * Record que me permite devolver los valores para setear columnas del reporte de facturacion de MRC y NRC de asesores
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 20-04-2018
  *
  */
  TYPE Lr_AsignacionSolicitud IS RECORD (
    ID_ASIGNACION_SOLICITUD   DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE,
    FE_CREACION               DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.FE_CREACION%TYPE,
    REFERENCIA_CLIENTE        DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.REFERENCIA_CLIENTE%TYPE,
    USR_ASIGNADO              DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE,
    TIPO_ATENCION             DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.TIPO_ATENCION%TYPE,
    TIPO_PROBLEMA             DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.TIPO_PROBLEMA%TYPE,
    REFERENCIA_ID             DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.REFERENCIA_ID%TYPE,
    CRITICIDAD                DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.CRITICIDAD%TYPE,
    DETALLE                   DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DETALLE%TYPE,
    ESTADO                    DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE
  );
--

  TYPE arr_asignaciones IS TABLE OF Lr_AsignacionSolicitud INDEX BY binary_integer;

    TYPE Lr_EstadosCasoTarea IS RECORD (
    TIPO   VARCHAR2(200),
    ESTADO   VARCHAR2(16)
  );
--

  TYPE arr_estadoscasotarea IS TABLE OF Lr_EstadosCasoTarea INDEX BY binary_integer;

  /*
  * Documentación para TYPE 'Lr_InfoCreaActividad'.
  *
  * Tipo de datos para la información necesaria para crear una actividad
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */
  TYPE Lr_InfoCreaActividad IS RECORD
  (
    DESCRIPCION_ORIGEN              DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
    NOMBRE_CLASE                    DB_COMUNICACION.ADMI_CLASE_DOCUMENTO.NOMBRE_CLASE_DOCUMENTO%TYPE,
    NOMBRE_PROCESO                  DB_SOPORTE.ADMI_PROCESO.NOMBRE_PROCESO%TYPE,
    NOMBRE_TAREA                    DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
    FE_SOLICITADA                   DB_SOPORTE.INFO_DETALLE.FE_SOLICITADA%TYPE,
    NOMBRE_DEPARTAMENTO_CREA_TAREA  DB_GENERAL.ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
    NOMBRE_CANTON_CREA_TAREA        DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    LOGIN_EMPLEADO_ASIGNADO         DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    COD_EMPRESA_EMPLEADO_ASIGNADO   DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
    OBSERVACION                     DB_SOPORTE.INFO_DETALLE.OBSERVACION%TYPE,
    REMITENTE_ID_TAREA              DB_COMUNICACION.INFO_COMUNICACION.REMITENTE_ID%TYPE,
    REMITENTE_NOMBRE_TAREA          DB_COMUNICACION.INFO_COMUNICACION.REMITENTE_NOMBRE%TYPE,
    FECHA_COMUNICACION              DB_COMUNICACION.INFO_COMUNICACION.FECHA_COMUNICACION%TYPE,
    USR_CREACION                    VARCHAR2(15),
    IP_CREACION                     VARCHAR2(16),
    COD_EMPRESA                     VARCHAR2(2)
  );

  /*
   * Documentacion para TYPE 'Ltr_AdmiTarea'.
   * Record que me permite obtener los registros de tareas
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 02-11-2021
   *
   */
  TYPE Ltr_AdmiTarea IS TABLE OF Admi_Tarea%ROWTYPE INDEX BY binary_integer;

  /*
   * Documentacion para TYPE 'Lr_Caso'.
   * Record que me permite obtener el registro de un caso
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 10-11-2021
   *
   */
  TYPE Lr_Caso IS RECORD (
    ID_CASO             DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,                
    COD_EMPRESA         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    NOMBRE_EMPRESA      DB_COMERCIAL.INFO_EMPRESA_GRUPO.NOMBRE_EMPRESA%TYPE,
    PREFIJO             DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    ID_TIPO_CASO        DB_SOPORTE.ADMI_TIPO_CASO.ID_TIPO_CASO%TYPE,
    TIPO_CASO           DB_SOPORTE.ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
    ID_FORMA_CONTACTO   DB_COMERCIAL.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE,
    FORMA_CONTACTO      DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
    ID_NIVEL_CRITICIDAD DB_SOPORTE.ADMI_NIVEL_CRITICIDAD.ID_NIVEL_CRITICIDAD%TYPE,
    NIVEL_CRITICIDAD    DB_SOPORTE.ADMI_NIVEL_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD%TYPE,
    NUMERO_CASO         DB_SOPORTE.INFO_CASO.NUMERO_CASO%TYPE,
    TITULO_INICIAL      DB_SOPORTE.INFO_CASO.TITULO_INI%TYPE,
    TITULO_FINAL        DB_SOPORTE.INFO_CASO.TITULO_FIN%TYPE,
    VERSION_INICIAL     DB_SOPORTE.INFO_CASO.VERSION_INI%TYPE,            
    VERSION_FINAL       DB_SOPORTE.INFO_CASO.VERSION_FIN%TYPE,            
    FE_APERTURA         DB_SOPORTE.INFO_CASO.FE_APERTURA%TYPE,            
    FE_CIERRE           DB_SOPORTE.INFO_CASO.FE_CIERRE%TYPE,               
    USR_CREACION        DB_SOPORTE.INFO_CASO.USR_CREACION%TYPE,           
    IP_CREACION         DB_SOPORTE.INFO_CASO.IP_CREACION%TYPE,          
    FE_CREACION         DB_SOPORTE.INFO_CASO.FE_CREACION%TYPE,         
    ID_TITULO_FIN_HIP   DB_SOPORTE.INFO_CASO.TITULO_FIN_HIP%TYPE,      
    TIPO_AFECTACION     DB_SOPORTE.INFO_CASO.TIPO_AFECTACION%TYPE,      
    TIPO_BACKBONE       DB_SOPORTE.INFO_CASO.TIPO_BACKBONE%TYPE,   
    ORIGEN              DB_SOPORTE.INFO_CASO.ORIGEN%TYPE,
    ESTADO              DB_SOPORTE.INFO_CASO_HISTORIAL.ESTADO%TYPE
  );

  /*
   * Documentacion para TYPE 'Ltr_Caso'.
   * Record que me permite obtener los registros de casos
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 10-11-2021
   *
   */
  TYPE Ltr_Caso IS TABLE OF Lr_Caso INDEX BY binary_integer;

  /*
   * Documentacion para TYPE 'Ltr_AdmiProceso'.
   * Record que me permite obtener los registros de procesos
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 02-11-2021
   *
   */
  TYPE Ltr_AdmiProceso IS TABLE OF Admi_Proceso%ROWTYPE INDEX BY binary_integer;

  /*
   * Documentacion para TYPE 'Ltr_ClaseDocumento'.
   * Record que me permite obtener los registros de clases de documentos
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 02-11-2021
   *
   */
  TYPE Ltr_ClaseDocumento IS TABLE OF DB_COMUNICACION.ADMI_CLASE_DOCUMENTO%ROWTYPE INDEX BY binary_integer;

  /*
   * Documentacion para TYPE 'Ltr_Documento'.
   * Record que me permite obtener los registros de documentos
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 12-11-2021
   *
   */
  TYPE Ltr_Documento IS TABLE OF DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE INDEX BY binary_integer;

  /*
   * Documentacion para TYPE 'Ltr_InfoPersona'.
   * Record que me permite obtener los registros de clases de personas
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 02-11-2021
   *
   */
  TYPE Ltr_InfoPersona IS TABLE OF DB_COMERCIAL.INFO_PERSONA%ROWTYPE INDEX BY binary_integer;

  /*
   * Documentacion para TYPE 'Lr_Tarea'.
   * Record que me permite obtener el registro de una tarea
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 15-11-2021
   *
   */
  TYPE Lr_Tarea IS RECORD (
    NUMERO_TAREA        DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,    
    ID_FORMA_CONTACTO   DB_COMERCIAL.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE,
    FORMA_CONTACTO      DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
    ID_CASO             DB_SOPORTE.INFO_CASO.ID_CASO%TYPE, 
    ID_DETALLE          DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
    OBSERVACION         DB_SOPORTE.INFO_DETALLE.OBSERVACION%TYPE,
    FE_CREACION         DB_COMUNICACION.INFO_COMUNICACION.FE_CREACION%TYPE,
    ESTADO              DB_SOPORTE.INFO_DETALLE_HISTORIAL.ESTADO%TYPE,
    USR_CREACION        DB_COMUNICACION.INFO_COMUNICACION.USR_CREACION%TYPE,           
    IP_CREACION         DB_COMUNICACION.INFO_COMUNICACION.IP_CREACION%TYPE,
    TIPO_AFECTADO       DB_SOPORTE.INFO_PARTE_AFECTADA.TIPO_AFECTADO%TYPE,
    AFECTADO_ID         DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_ID%TYPE
  );

  /*
   * Documentacion para TYPE 'Ltr_Tarea'.
   * Record que me permite obtener los registros de tareas
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 15-11-2021
   *
   */
  TYPE Ltr_Tarea IS TABLE OF Lr_Tarea INDEX BY binary_integer;

END SPKG_TYPES;
/