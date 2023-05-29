CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT
AS
    
   /**
    * Documentación para la función P_JOB_GUARDAR_INCIDENCIA
    * Procedimiento que ejecuta un job para ingresar incidencias enviadas por ECUCERT 
    *
    * @param  Pcl_JsonEcucert       - Json enviado por CERT
    *          Pv_NombreJob          - Nombre del Job
    *          Pn_NumeroRegistro     - Números de registros enviados por ticket
    *          Pv_MensajeError       - Mensaje de error del sistemas
    *          Pv_Respuesta          - Respuesta de la petición.
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 04-06-2019
    */

    PROCEDURE P_JOB_GUARDAR_INCIDENCIA(
                                  Pcl_JsonEcucert   IN  CLOB, 
                                  Pv_NombreJob      IN  VARCHAR2, 
                                  Pn_NumeroRegistro IN  INTEGER,
                                  Pv_MensajeError   OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2) ;

   /**
    * Documentación para la función P_JOB_PROCESAR_TICKET
    * Procedimiento para revisa tickets pendientes a procesar
    *
    * @param  null
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 09-04-2019
    *
    */

    PROCEDURE P_JOB_PROCESAR_TICKET ;

   /**
    * Documentación para la función P_GUARDAR_INCIDENCIA
    * Procedimiento para guardar incidencias enviadas por ECUCERT 
    *
    * @param  Pcl_JsonEcucert       - Json enviado por CERT
    *          Pv_MensajeError       - Mensaje de error del sistemas
    *          Pv_Respuesta          - Respuesta de la petición.
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 09-04-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 12-08-2020 - Se realiza validación de tipo de Ip es nulo.
    * @since 1.0
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.2 23-05-2021 - Se valida si existe la categoría y sino se encuentra
    *                           se guarda en la admi parametro para la generación de
    *                           de la plantilla por empresa
    * @since 1.1
    *
    */

    PROCEDURE P_GUARDAR_INCIDENCIA(
                                  Pn_IdIncRequest   IN  INTEGER, 
                                  Pv_MensajeErrorP  OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2,
                                  Pn_NumeroRegistro IN  INTEGER) ;


   /**
    * Documentación para la función P_CREAR_INCIDENCIA
    * Procedimiento que guarda la incidencia
    *
    * @param  Pv_IncidenciaObj    - Tipo de incidencia
    *         Pn_IncidenciaId     - Id de la incidencia
    *         Pv_MensajeError     - Mensaje de error del procedimiento
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 18-02-2019
    */
    PROCEDURE P_CREAR_INCIDENCIA(
                              Pv_IncidenciaObj      IN INCIDENCIA_TYPE,
                              Pn_IncidenciaId       OUT INTEGER,
                              Pv_MensajeError       OUT VARCHAR2
                              );

   /**
    * Documentación para la función P_CREAR_INCIDENCIA_DETALLE
    * Procedimiento que guarda el detalle de la incidencia
    *
    * @param  
    *       Pv_IncidenciaDetObj - Tipo de detalle incidencia
    *       Pn_IncidenciaIdDet  - Id del detalle de la incidencia
    *       Pv_MensajeError     - Mensaje de error del procedimiento
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 18-02-2019
    */                             

    PROCEDURE P_CREAR_INCIDENCIA_DETALLE(
                                        Pv_IncidenciaDetObj IN INCIDENCIA_DETALLE_TYPE,
                                        Pn_IncidenciaIdDet  OUT INTEGER,
                                        Pv_MensajeError     OUT VARCHAR2
                                      );


   /**
    * Documentación para la función P_ACTUALIZAR_DET_INCI_CASO_CLIENTE
    * Procedimiento que modifica el detalle de la incidencia ingresando el cliente y el caso
    *
    * @param  Pn_IncidenciaDetActId    - Objeto de del detalle de la incidencia
    *          Pv_MensajeError          - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 25-02-2019
    */

    PROCEDURE P_ACT_DET_INCI_CASO_CLIENTE(
                              Pn_IncidenciaDetActId     IN INCIDENCIA_ACT_DETALLE_TYPE,
                              Pv_MensajeError       OUT VARCHAR2
                              );  


   /**
    * Documentación para la función P_ACT_ESTADO_DET_INC
    * Procedimiento que modifica el estado del detalle de la incidencia
    *
    * @param    Pn_IncidenciaDetId  - Id del detalle de la incidencia
    *         Pv_Estado             - Estado del detalle del incidente
    *         Pv_UsrModi            - Usuario de modificación de la incidencia
    *         Pv_IpModi             - Ip que modifica la incidencia
    *         Pv_MensajeError       - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 14-02-2020 - Se cambia el estado de gestión a Atendido 
    *                           si la IP ya no es vulnerable
    * @since 1.0
    */

    PROCEDURE P_ACT_ESTADO_DET_INC(
                              Pn_IncidenciaDetId    IN INTEGER,
                              Pv_Estado             IN VARCHAR2,
                              Pv_UsrModi            IN VARCHAR2,
                              Pv_IpModi             IN VARCHAR2,
                              Pv_MensajeError       OUT VARCHAR2
                              ); 


   /**
    * Documentación para la función P_ACT_ESTADO_GES_INC
    * Procedimiento que modifica el estado de gestión de la incidencia
    *
    * @param    Pn_IncidenciaDetId  - Id del detalle de la incidencia
    *         Pv_Estado             - Estado de la incidente
    *         Pv_UsrModi            - Usuario de modificación de la incidencia
    *         Pv_IpModi             - Ip que modifica la incidencia
    *         Pv_MensajeError       - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    */

    PROCEDURE P_ACT_ESTADO_GES_INC(
                              Pn_IncidenciaDetId    IN INTEGER,
                              Pv_Estado             IN VARCHAR2,
                              Pv_UsrModi            IN VARCHAR2,
                              Pv_IpModi             IN VARCHAR2,
                              Pv_MensajeError       OUT VARCHAR2
                              );   

   /**
    * Documentación para la función P_CREAR_INCIDENCIA_NOTIF
    * Procedimiento que crea el registro de la persona notificada por la incidencia
    *
    * @param  Pv_Correo             - Correo de la persona notificada
    *         Pv_TipoContacto       - Tipo de contacto del cliente (Técnico, Punto o personal)
    *         Pn_IncidenciaDetId    - Id del detalle de la incidencia
    *         Pv_Estado             - Estado del detalle del incidente
    *         Pv_UsrCreacion        - Usuario de modificación de la incidencia
    *         Pv_IpCreacion         - Ip que modifica la incidencia
    *         Pv_MensajeError       - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 19-03-2019
    */

    PROCEDURE P_CREAR_INCIDENCIA_NOTIF(
                                  Pv_Correo             IN VARCHAR2,
                                  Pv_TipoContacto       IN VARCHAR2,
                                  Pn_IncidenciaDetId    IN INTEGER,
                                  Pv_Estado             IN VARCHAR2,
                                  Pv_UsrCreacion        IN VARCHAR2,
                                  Pv_IpCreacion         IN VARCHAR2,
                                  Pv_MensajeError       OUT VARCHAR2
                                  );  

   /**
    * Documentación para la función P_REPORTE_INCIDENCIAS
    * Procedimiento que genera un archivo csv de incidencias para posteriormente enviarlo por email 
    *
    * @param  Pv_FechaInicio        - Fecha de inicio de busqueda
    *         Pv_FechaFin           - Fecha Fin de busqueda
    *         Pv_NoTicket           - Número de Ticket
    *         Pv_MensajeError       - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 19-03-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 18-08-2019 - Se cambia de destinatario para el reporte generado desde el telcos 
    *                           al campo parametrizable en la admi_parametro_det (ECCUERT)
    * @since 1.0
    *
    */

    PROCEDURE P_REPORTE_INCIDENCIAS(
                                  Pv_FechaInicio    IN  VARCHAR2,
                                  Pv_FechaFin       IN  VARCHAR2, 
                                  Pv_NoTicket       IN  VARCHAR2,  
                                  Pv_MensajeError   OUT VARCHAR2) ;

   /**
    * Documentación para la función P_CREAR_REQUEST
    * Procedimiento que genera una petición al servidor mediante una url y Json
    *
    * @param  Pcl_Json          - Json de casos y tareas
    *         Pv_URL            - Url a consumir
    *         Pv_Respuesta      - Data de respuesta de la url a consumir
    *         Pv_MensajeError   - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 09-04-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 18-08-2019 - Se trunca el Json para guardar en la info error
    * @since 1.0
    */                              

    PROCEDURE P_CREAR_REQUEST (Pcl_Json         IN CLOB,
                                Pv_URL           IN VARCHAR2,
                                Pv_Respuesta     OUT VARCHAR2,
                                Pv_MensajeError  OUT VARCHAR2);


   /**
    * Documentación para la función P_DATOS_CREAR_CASOS
    * Procedimiento que procesa la respuesta de la creación del caso y la tarea 
    *
    * @param  Pv_Data           - Json de casos y tareas
    *         Pv_Status         - Estado de la respuesta del Telcos
    *         Pv_Message        - Mensaje del Telcos
    *         Pv_NoCaso         - Número de caso
    *         Pv_NoTarea        - Número de tarea
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-04-2019
    */

    PROCEDURE P_DATOS_CREAR_CASOS (Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2,
                                    Pv_NoCaso        OUT VARCHAR2,
                                    Pv_NoTarea       OUT VARCHAR2);

   /**
    * Documentación para la función P_ENVIO_NOTIFICACION
    * Procedimiento que procesa la respuesta de la notificacion al cliente
    *
    * @param  Pv_Data           - Json de la notificación al cliente
    *         Pv_Status         - Estado de la respuesta del Telcos
    *         Pv_Message        - Mensaje del Telcos
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    */

    PROCEDURE P_ENVIO_NOTIFICACION(Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2);


   /**
    * Documentación para la función P_BUSQUEDA_CLIENTE_MD
    * Procedimiento que procesa la respuesta de la busqueda del cliente de Megadatos por RDA
    *
    * @param  Pv_Data           - Json del cliente MD
    *         Pv_Status         - Estado de la respuesta del Telcos
    *         Pv_Message        - Mensaje del Telcos
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    */

    PROCEDURE P_BUSQUEDA_CLIENTE_MD(Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2);

   /**
    * Documentación para la función P_RESPUESTA_RDA
    * Procedimiento que procesa la respuesta de RDA para la obtención del cliente.
    *
    * @param   Pv_Data      - Json de respuesta de RDA
    *          Pv_Status    - Estado de la respuesta
    *          Pv_Login     - Login del cliente
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 19-03-2019
    */

     PROCEDURE P_RESPUESTA_RDA(Pv_Data          IN  VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pv_Login        OUT VARCHAR2
                                );

   /**
    * Documentación para la función P_RESPUESTA_CGNAT
    * Procedimiento que procesa la respuesta de Networking para la obtención del cliente CGNAT.
    *
    * @param   Pv_Data      - Json de respuesta de CGNAT
    *          Pv_Status    - Estado de la respuesta
    *          Pv_Login     - Login del cliente
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 19-03-2019
    */

     PROCEDURE P_RESPUESTA_CGNAT(Pv_Data     IN  VARCHAR2, 
                                 Pv_Ip       OUT VARCHAR2
                                );

   /**
    * Documentación para la función P_REPORTE_INCIDENCIAS_AUTOMATICA
    * Procedimiento que se esta ejecutando constantemente para verificar la fecha de los tickets emitidos 
    * y enviar un informe en formato csv de incidencias por correo electrónico a ECUCERT
    *
    * @param   null
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 19-03-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 18-10-2019 - Se cambia el formato del archivo que se envía a ECUCERT a CSV
    * @since 1.0
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.2 14-02-2020 - Se cambia la observación del reporte a ECUCERT en base al estado
    *                           de gestión
    * @since 1.1
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.3 18-03-2020 - Se agrega una nueva variable para realizar el envío de reporte
    *                           en base a un número te ticket o de forma automática
    * @since 1.2
    *
    * @author José Bedón <jobedon@telconet.ec>
    * @version 1.4 31-08-2020 - Se cambia Acciones tecnicas por Gestión de procesos interno
    *                         - Se cambia mensaje Script automatico por Gestion automatica de notificaciones
    * @since 1.3
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.5 07-06-2021 - Se omite las guias generadas de forma interna
    * @since 1.5
    *
    */

    PROCEDURE P_REPORTE_INC_AUTOMAT (Pv_NumeroTicket  IN  VARCHAR2);

   /**
    * Documentación para la función P_TOKEN
    * Procedimiento que procesa la respuesta del token
    *
    * @param  Pv_Data           - Json de la notificación al cliente
    *         Pv_Token          - token
    *         Pv_Status         - Estado de la respuesta del Telcos
    *         Pv_Message        - Mensaje del Telcos
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    */

    PROCEDURE P_TOKEN(Pv_Data          IN  VARCHAR2,
                        Pv_Token         OUT VARCHAR2,
                        Pv_Status        OUT VARCHAR2,
                        Pv_Message       OUT VARCHAR2);


   /**
    * Documentación para la función P_ENVIO_CORREO
    * Procedimiento que envía correo
    *
    * @param    Pv_To           - Correo del destinataraio,
    *           Pv_From         - Correo de quien es el que envía,
    *           Pv_Message      - Mensaje del correo,
    *           Pv_SmtpHost     - Host o Ip del servidor,
    *           Pv_Subject      - Encabezado del mensaje que se envía,
    *           Pv_TextMsg      - Texto del cuerpo del mensaje,
    *           Pv_AttachName   - Nombre del archivo a enviar,
    *           Pv_AttachMime   - Tipo de Archivo
    *           Pcl_ClobText     - Clob con el texto a enviar
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 04-06-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 18-08-2019 - Se agrega por defecto copia a soc_notificaciones@telconet.net para el 
    *                           envío de correo a ECUCERT
    * @since 1.0
    *
    */

    PROCEDURE P_ENVIO_CORREO(
                                Pv_To           VARCHAR2,
                                Pv_From         VARCHAR2,
                                Pv_Message      VARCHAR2,
                                Pv_SmtpHost     VARCHAR2,
                                Pv_Subject      VARCHAR2,
                                Pv_TextMsg      VARCHAR2,
                                Pv_AttachName   VARCHAR2,
                                Pv_AttachMime   VARCHAR2,
                                Pcl_ClobText    CLOB,
                                Pv_CopiaCorreo  VARCHAR2
                            ) ;

   /**
    * Documentación para la función P_RESPUESTA_CERT_VUL
    * Procedimiento que procesa la respuesta de CERT PARA LA VULNERABLIDAD
    *
    * @param   Pv_Data          - Json de respuesta de CERT
    *          Pv_Status        - Estado de la respuesta
    *          Pv_Vulnerable    - Estado que verifica si es vulnerable
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 05-06-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 12-08-2019 - Se agrega el ingreso del seguimiento al momento de validad la vulnerabilidad
    * @since 1.0
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.2 17-08-2019 - Se ingresa la validación cuando no es vulnerable debido 
    *                           a que la respuesta por parte de CERT es diferente sino encuentra vulnerabilidad
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.3 18-02-2020 - Se actualiza el estado de vulnerabilidad y gestión indiferentemente  
    *                           la Ip este asociada una tarea
    * @since 1.2
    */

     PROCEDURE P_RESPUESTA_CERT_VUL(Pv_Data     IN  VARCHAR2,
                                Pn_NoTarea      IN INTEGER,
                                Pv_Status        OUT VARCHAR2,
                                Pv_Vulnerable    OUT VARCHAR2
                                );

   /**
    * Documentación para la función P_IP_NETWORKING
    * Procedimiento que procesa la respuesta de la notificacion de netwoking
    *
    * @param  Pv_Data           - Json de la ip local del cliente para obtener la WAN
    *         Pv_IpWAN          - IP WAN del cliente
    *         Pv_Vrf            - Es la Vrf de la red consultada a networking
    *         Pv_Message        - Mensaje del Telcos
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 12-06-2019
    */

    PROCEDURE P_IP_NETWORKING(Pv_Data          IN  VARCHAR2,
                                Pv_IpWAN        OUT VARCHAR2,
                                Pv_Jurisdiccion OUT VARCHAR2,
                                Pv_Vrf          OUT VARCHAR2,
                                Pv_Message      OUT VARCHAR2);

   /**
    * Documentación para la función P_MASCARA_IP
    * Procedimiento que procesa la mascara IP u retorna si pertenece a ese segmento la IP
    *
    * @param  Pv_SubRed         - SubRed de telconet
    *         Pv_Mascara        - Mascara de la subred
    *         Pv_IpValida       - Ip se se va a comparar
    *         Pn_boolValida     - Bandera si pertenece a la red
    *         Pv_Message        - Mensaje del Telcos
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    */

    PROCEDURE P_MASCARA_IP(Pv_SubRed        IN  VARCHAR2,
                            Pv_Mascara       IN VARCHAR2,
                            Pv_IpValida      IN  VARCHAR2,
                            Pn_boolValida    OUT INTEGER,
                            Pv_Message       OUT VARCHAR2);

   /**
    * Documentación para la función P_BUSCAR_CLIENTE_NOT
    * Procedimiento que procesa y busca el cliente y lo notifica
    *
    * @param  Pv_ipAddress       - Ip de la incidencia
    *         Pn_IncidenciaIdDet - Id detalle de la incidencia
    *         Pv_ipCreacion      - Ip de creación
    *         Pv_feIncidenciaIp  - Fecha en que se cometió la incidencia
    *         Pv_user            - Usuario
    *         Pv_puerto          - Puerto en donde se detecto la incidencia
    *         Pv_noTicket        - Número de Ticket
    *         Pv_categoria       - Categoria de la incidencia
    *         Pv_subCategoria    - SuCategoria de la incidencia
    *         Pv_tipoEvento      - Tipo de Evento de la incidencia
    *         Pv_ipDestino       - Ip de destino de la incidencia
    *         Pv_BandCPE         - bandera que indica si es posible que sea CPE
    *         Pv_statusIn        - Estado de la respuesta del Telcos
    *         Pv_Message         - Mensaje del Telcos
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 11-03-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 24-07-2019 - Se agrega la validación para que el tiempo transcurrido 
    *                           al caso cuando se asigna sea del cliente
    * @since 1.0
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.2 19-08-2019 - Se valida por el campo 'ES JEFE' para la búsqueda del jefe del departamento 
    * @since 1.1
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.3 - Se agrega el proceso para megadatos para crear tarea a IP contact center cuando ECUCERT reporta una IP
    * @since 1.2
    *
    * @author Otto Navas <onavas@telconet.ec>
    * @version 1.4 - Se agregó una validación al cursor C_RUTA_SUBRED que permite aceptar la IP gateway de una subred
    * @since 1.3
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.5 14-02-2020 - Se valida que no se cree tareas a CERT ni a IPCCL2 si la IP no es vulnerable
    * @since 1.4
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.6 04-03-2020 - Se le agrega la excepción al procedimiento.
    * @since 1.5
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.7 19-03-2020 - Se realiza validación para Ips de infraestructura y
    *                           validar el envío de correo al clietne para cambiar a "análisis" el estado de gestión
    * @since 1.6
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.8 27-04-2020 - Se realiza validación con la empresa enviada por ECUCERT para direccionar
    *                           la tarea al departamento pertinente.
    * @since 1.7
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.9 12-08-2020 - Se realiza párametrización del jefe de region sino se encuenta en la consulta.
    * @since 1.8
    * 
    * @author José Bedón <jobedon@telconet.ec>
    * @version 1.4 31-08-2020 - Se cambia estado de Pendiente a Analisis cuando el cliente no se encontro
    * @since 1.9
    *
    */

    PROCEDURE P_BUSCAR_CLIENTE_NOT(Pv_IncidenciaDetNotObj  IN  INCIDENCIA_NOT_DETALLE_TYPE,
                                   Pv_tipoUsuario          IN VARCHAR2,
                                   Pn_CodigoEmpresaTicket  IN NUMBER,
                                   Pv_Message              OUT VARCHAR2);

   /** 
    * Documentación para la función P_INGRESAR_CATEGORIA
    * Procedimiento que ingresa la categoria, subcategoria y tipo de evento
    *
    * @param  Pv_Categoria      - Categoria
    *         Pv_SubCategoria   - SuCategoria
    *         Pv_TipoEvento     - Tipo de Evento
    *         Pv_Message        - Mensaje respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 21-05-2021
    */
    PROCEDURE P_INGRESAR_CATEGORIA(Pv_Categoria       IN VARCHAR2,
                                   Pv_SubCategoria    IN VARCHAR2,
                                   Pv_TipoEvento      IN VARCHAR2,
                                   Pn_CodEmpresa      IN INTEGER,
                                   Pv_Message         OUT VARCHAR2);

   /** 
    * Documentación para la función P_DATOS_CREAR_TAREA
    * Procedimiento que procesa la respuesta de la creación de la tarea 
    *
    * @param  Pv_Data           - Json de la tarea
    *         Pv_Status         - Estado de la respuesta del Telcos
    *         Pv_Message        - Mensaje del Telcos
    *         Pv_NoTarea        - Número de tarea
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 20-06-2019
    */

    PROCEDURE P_DATOS_CREAR_TAREA (Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2,
                                    Pv_NoTarea       OUT VARCHAR2);

   /**
    * Documentación para la función P_RESPUESTA_CSOC
    * Procedimiento que procesa la respuesta de si el Cliente tiene CSOC
    *
    * @param  Pv_Data           - Json de la consulta a Csoc por Login
    *         Pv_Status         - Estado de la respuesta de CERT
    *         Pn_ClienteCsoc    - Indicador si es cliente Csoc
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 20-06-2019
    */
    PROCEDURE P_RESPUESTA_CSOC(Pv_Data          IN  VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pn_ClienteCsoc  OUT INTEGER
                                );

   /**
    * Documentación para la función P_RESPUESTA_SG
    * Procedimiento que procesa la respuesta de si el Cliente tiene Seguridad  Gestionada por Telconet
    *
    * @param  Pv_Data           - Json de la consulta a Cert para saber si el cliente tiene Seguridad Gestionada
    *         Pv_Status         - Estado de la respuesta de CERT
    *         Pn_ClienteSg      - Indicador si es un cliente Seguridad Gestionada
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 20-06-2019
    */
    PROCEDURE P_RESPUESTA_SG(Pv_Data          IN  VARCHAR2,
                              Pv_Status       OUT VARCHAR2,
                              Pn_ClienteSg     OUT INTEGER
                              );

   /** 
    * Documentación para la función P_ACTUALIZAR_ESTADOGESTION
    * Procedimiento queatualiza el estado de gestion
    *
    * @param  Pv_EstadoGestion      - Estado de Gestion
    *         Pv_SubEstado          - Sub Estado de la Incidencia
    *         Pv_IdDetalleInc       - Id detalle de incidencia
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 12-06-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 14-02-2020 - Agrega el ingreso del estado de gestión en el historial
    * @since 1.0
    *
    */

    PROCEDURE P_ACTUALIZAR_ESTADO_GESTION(Pv_EstadoGestion    IN  VARCHAR2,
                                          Pv_SubEstado        IN VARCHAR2,
                                          Pv_IdDetalleInc     IN VARCHAR2);


   /**
    * Documentación para la función P_REPROCESAR_CLIENTE
    * Procedimiento que reprocesa el registro de la incidencia
    *
    * @param  Pn_IncidenciaDetId    - Objeto de del detalle de la incidencia
    *         Pv_ipCreacion         - Ip de creación,
    *         Pv_user               - Usuario de creación,
    *         Pv_MensajeError       - Mensaje de error del sistemas
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 21-07-2019
    */

    PROCEDURE P_REPROCESAR_CLIENTE(
                              Pn_IncidenciaDetId    IN  INTEGER,
                              Pv_ipCreacion         IN  VARCHAR2,
                              Pv_user               IN  VARCHAR2,
                              Pv_MensajeError       OUT VARCHAR2
                              );  

   /** 
    *Documentación para la función F_DIAS_LABORABLES
    * Procedimiento que obtiene las horas laborales entre fechas
    *
    * @param  Ft_fechaInicio    - Fecha de Inicio de la incidencia
    *         Ft_fechaFin       - Fecha actual
    *         NUMBER            - Retorna en horas los días que lleva la incidencia
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 10-07-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 19-08-2019 - Se valida que la funciones no sume las horas los fines de semana
    * @since 1.0
    */
    FUNCTION F_DIAS_LABORABLES(
                            Ft_fechaInicio IN TIMESTAMP, 
                            Ft_fechaFin    IN TIMESTAMP)
                          RETURN NUMBER;

   /**
    * Documentación para la función P_FINALIZACION_TAREAS_AUTOMAT
    * Procedimiento que se está ejecutando constantemente para verificar si las tareas de ECUCERT 
    * estan cerradas en un periodo de tiempo máximo
    *
    * @param  null
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 06-08-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 20-02-2020 - Se agrega el token al finalizar la tarea
    * @since 1.0
    *
    */

    PROCEDURE P_FINALIZACION_TAREAS_AUTOMAT ;

   /**
    * Documentación para la función P_TAREA_PROCESADA
    * Procedimiento que cambia a procesada la tarea en la tabla de incidencias ECUCERT
    *
    * @param  Pn_IncidenciaDet  - Detalle de la Incidencia
    *         Pn_TareaProcesada - Bandera que indica si se proceso la tarea
    *         Pn_DetalleId      - Detalle de la tarea
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 01-08-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 18-03-2020 - Se parámetriza la observación del seguimiento
    * @since 1.0
    */

    PROCEDURE P_TAREA_PROCESADA(
                                Pn_IncidenciaDet  IN INTEGER,
                                Pn_TareaProcesada IN INTEGER,
                                Pn_DetalleId      IN INTEGER,
                                Pv_Observacion    IN VARCHAR2) ;

    /**
    * Documentación para la función P_IDENTIFICACION_CLIENTE
    * Procedimiento encargado de obtener un Json e identificar si el LOGIN de un punto mediante una ip determinada
    *
    * @param  Pv_IncidenciaDetNotObj     - Variable de tipo Objeto 
    *         Pn_CodigoEmpresaTicket     - Bandera
    *         Pc_JsonClient              - Json de salida obtenida de P_OBTIENE_CLIENTE
    *         Pv_Message                 - Mensaje de Error 
    * @author Otto Navas <onavas@telconet.ec>
    * @version 1.0 23-10-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 31-03-2020 - Cambio en la búsqueda de servicios adicionales 
    *                           devolviendo el número de planes por servicio
    * @since 1.0
    */ 

    PROCEDURE P_IDENTIFICACION_CLIENTE(

                                        Pv_IncidenciaDetNotObj  IN  INCIDENCIA_NOT_DETALLE_TYPE, 
                                        Pn_CodigoEmpresaTicket  IN NUMBER,
                                        Pv_TimeStamp            IN VARCHAR2,
                                        Pc_JsonClient           OUT CLOB,
                                        Pv_Message              OUT VARCHAR2); 



    /**
    * Documentación para la función P_OBTIENE_CLIENTE
    * Procedimiento encargado de obtener información del cliente en un formato Json
    *
    * @param  Pv_Login            - Login obtenido
    *         Pc_JsonCliente      - Json que contiene la informacion del cliente de acuerdo a punto
    *         Pv_ErrorMsj         - Mensaje de Error
    * @author Otto Navas <onavas@telconet.ec>
    * @version 1.0 23-10-2019
    */ 
    PROCEDURE P_OBTIENE_CLIENTE(

                                        Pv_Login                IN VARCHAR2,
                                        Pcl_JsonCliente         OUT CLOB,
                                        Pv_ErrorMsj             OUT VARCHAR2);

   /**
    * Documentación para la función P_IDENTIFICA_IP
    * Procedimiento encargado de obtener la IP necesaria para obetner los datos del cliente
    * si la IP es una sub red, lo enviara al procedimiento P_SUBNETTING para su respectivo 
    * subneteo. Una vez eso se envia la IP al procedieminto P_IDENTIFICACION_CLIENTE
    * 
    *
    * @param  Pv_IpRequest      - IP del Request
    *         Pv_originID       - Ip de originID,
    *         pv_Respuesta      - Json generado con la informacion del cliente
    *         Pv_ErrorMsj       - Mensaje de error
    * @author Otto Navas <onavas@telconet.ec>
    * @version 1.0 11-11-2019
    */ 

   PROCEDURE P_IDENTIFICA_IP(           
                                        Pv_IpRequest         IN VARCHAR2,
                                        Pv_originID          IN VARCHAR2,
                                        Pv_TimeStamp         IN VARCHAR2,
                                        Pv_User              IN VARCHAR2,
                                        Pcl_JsonResponse     OUT CLOB,
                                        Pv_ErrorMsj          OUT VARCHAR2);  

    /**
      * Documentación para el procedimiento P_CREAR_CASO
      * Procedimiento que crea el registro del caso
      *
      * @param Pn_idCaso              - Id Caso
      *        Pn_idCasoHistorial     - Id Caso Historial
      *        Pn_idDocumento         - Id Documento
      *        Pn_idComunicacion      - Id Comunicación 
      *        Pn_idDocuComunicacion  - Id Documento Comunicación
      *        Pn_idDetalleHipotesis  - Id Detalle Hipotesis
      *        Pn_idDetalle           - Id Detalle del Caso
      *        Pn_idCriterioAfectado  - Id Criterio afectado
      *        Pn_idParteAfectada     - Id Parte afectada
      *        Pn_idDetalleCaAsig     - Id Detalle asignación
      *        Pn_idComunicacionCaSig - Id Comunicación Asignado
      *        Pn_idCasoHistorialAsig - Id Caso Historial Asignado
      *        Pn_idCasoAsignacion    - Id Caso Asignación
      *        Pn_idCasoDocumentoAsig - Id Caso Documento
      *        Pn_idDocuComunicaAsig  - Id Documento Comunicación
      *        
      * @author Néstor Naula <nnaulal@telconet.ec>
      * @version 1.0 04-02-2020
      *
      * @author Néstor Naula <nnaulal@telconet.ec>
      * @version 1.1 04-03-2020 - Se cambia la lógica para crear caso para que no se repita el número
      *                           del caso.
      * @since 1.0
      * 
      * @author Néstor Naula <nnaulal@telconet.ec>
      * @version 1.2 23-05-2021 - Se modifica logica para darle un delay a la generación del
      *                           número del caso
      * @since 1.1
      *
      */

    PROCEDURE P_CREAR_CASO(
                          Pv_Login                IN VARCHAR2,
                          Pn_IdPunto              IN INTEGER,
                          Pn_CodEmpresa           IN INTEGER,
                          Pv_CasoEcucertObj       OUT  CREAR_CASO_ECUCERT_TYPE
                          ); 

     /**
      * Documentación para el procedimiento P_CREAR_TAREA
      * Procedimiento que crea el registro del caso
      *
      * @param Pn_idComunicacionTarea   - Id Comunicación
      *        Pn_idDetalleTarea        - Id Detalle
      *        Pn_idTareaDocumentoAsig  - Id Documento
      *        Pn_idDocuComuAsigTarea   - Id Documento Comunicación
      *        Pn_idDetalleAsigTarea    - Id Detalle
      *        Pn_idDetalleHistTarea    - Id Detalle Historial
      *        Pn_idTareaSeguiTarea     - Id Tarea Seguimiento
      *        
      * @author Néstor Naula <nnaulal@telconet.ec>
      * @version 1.0 04-02-2020
      */
    PROCEDURE P_CREAR_TAREA(Pn_idComunicacionTarea  OUT INTEGER,
                            Pn_idDetalleTarea       OUT INTEGER,
                            Pn_idTareaDocumentoAsig OUT INTEGER,
                            Pn_idDocuComuAsigTarea  OUT INTEGER,
                            Pn_idDetalleAsigTarea   OUT INTEGER,
                            Pn_idDetalleHistTarea   OUT INTEGER,
                            Pn_idTareaSeguiTarea    OUT INTEGER);   


     /**
      * Documentación para el procedimiento P_GENERAR_NUMERO_CASO
      * Procedimiento que genera el número del caso
      *
      * @param Pv_NumeroCaso     - Número de caso 
      *        
      * @author Néstor Naula <nnaulal@telconet.ec>
      * @version 1.0 03-03-2020
      *
      * @author Néstor Naula <nnaulal@telconet.ec>
      * @version 1.1 23-05-2021 - Se genera el número de caso a partir del contador
      *                           a partir de los mil registros
      * @since 1.0
      */
    PROCEDURE P_GENERAR_NUMERO_CASO(Pv_NumeroCaso IN OUT VARCHAR2,
                                    Pn_IdCaso     OUT INTEGER); 


   /**
    * Documentación para la función P_REENVIO_CORREO_ECUCERT
    * Procedimiento que en base al número de ticket enviado lo procesa 
    * y envía correo con la información del ticket a ECUCERT.
    *
    * @param  Pv_NumeroTicket       - Número de Ticket
    *         Pv_ipCreacion         - Ip de Creación
    *         Pv_user               - Usuario de Creación,
    *         Pv_MensajeError       - Mensaje de error del sistema
    *         Pv_Respuesta          - Respuesta de la petición.
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 18-03-2020
    */

    PROCEDURE P_REENVIO_CORREO_ECUCERT(
                                  Pv_NumeroTicket   IN  VARCHAR2, 
                                  Pv_ipCreacion     IN  VARCHAR2,
                                  Pv_user           IN  VARCHAR2,
                                  Pv_MensajeError   OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2) ;

   /**
    * Documentación para la función P_NOTIFICACION_CIERRE_CASO
    * Procedimiento que cierra caso/tarea y notifica al cliente.
    *
    * @param  Pv_Nombre_Proceso     - Siglas del proceso que lo llama si es reenvío
    *                                 o solo cierre de Caso/Tarea
    *         Pv_NumeroTicket       - Número de Ticket
    *         Pv_ipCreacion         - Ip de Creación
    *         Pv_user               - Usuario de Creación,
    *         Pv_MensajeError       - Mensaje de error del sistema
    *         Pv_Respuesta          - Respuesta de la petición.
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 18-03-2020
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 30-03-2020 - Se agrega válidación para cerrar casos y tareas puntuales
    *                           de un número de ticket en base a la variable Pv_Nombre_Proceso
    *                           Si es C hace referencia únicamente al cierra de caso y tarea
    *                           Si es T hace referencia al proceso de reenvío de correo
    * @since 1.0
    *
    */

    PROCEDURE P_NOTIFICACION_CIERRE_CASO(
                                  Pv_Nombre_Proceso IN  VARCHAR2,
                                  Pv_NumeroTicket   IN  VARCHAR2, 
                                  Pv_ipCreacion     IN  VARCHAR2,
                                  Pv_user           IN  VARCHAR2,
                                  Pv_MensajeError   OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2) ;  

END SPKG_INCIDENCIA_ECUCERT;
/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT
AS

    PROCEDURE P_JOB_GUARDAR_INCIDENCIA(
                                  Pcl_JsonEcucert   IN  CLOB,
                                  Pv_NombreJob      IN  VARCHAR2, 
                                  Pn_NumeroRegistro IN  INTEGER,
                                  Pv_MensajeError   OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2) 
                                  IS
    Ln_IncidenciaResq INTEGER;
    BEGIN

        INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_REQUEST (
          ID_INCIDENCIA_REQUEST,
          REQUEST,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          NUMERO_REGISTROS) 
        VALUES (
          DB_SOPORTE.SEQ_INFO_INCIDENCIA_REQUEST.NEXTVAL,
          Pcl_JsonEcucert,
          'TELCOS',
          sysdate,
          '127.0.0.1',
          'Pendiente',
          Pn_NumeroRegistro)
        RETURNING ID_INCIDENCIA_REQUEST INTO Ln_IncidenciaResq;
        COMMIT;

        EXCEPTION 
            WHEN OTHERS THEN 
            ROLLBACK;
            Pv_MensajeError := 'Error al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                                    'DB_SOPORTE.P_JOB_GUARDAR_INCIDENCIA',
                                                    Pv_MensajeError,
                                                    'telcos',
                                                    SYSDATE,
                                                    '127.0.0.1'); 

    END P_JOB_GUARDAR_INCIDENCIA;

    PROCEDURE P_JOB_PROCESAR_TICKET
                                  IS
    CURSOR C_GET_INCI_REQUEST(Cv_Estado VARCHAR2)
    IS
    SELECT
    T1.ID_INCIDENCIA_REQUEST,T1.NUMERO_REGISTROS
    FROM(
      SELECT 
        IIR.ID_INCIDENCIA_REQUEST,IIR.NUMERO_REGISTROS
        FROM DB_SOPORTE.INFO_INCIDENCIA_REQUEST IIR
        WHERE  IIR.ESTADO = Cv_Estado
        ORDER BY IIR.ID_INCIDENCIA_REQUEST ASC
        )T1
    WHERE ROWNUM = 1;

    Lv_EstadoPendiente   VARCHAR2(100) := 'Pendiente';
    Lv_EstadoProcesando  VARCHAR2(100) := 'Procesando';
    Lv_EstadoProcesado   VARCHAR2(100) := 'Procesado';
    Ln_IdIncRequest      INTEGER;
    Lv_MensajeError      VARCHAR2(1000);
    Lv_Respuesta         VARCHAR2(1000);
    Ln_NumeroRegistro    INTEGER;

    BEGIN

        OPEN C_GET_INCI_REQUEST (Lv_EstadoProcesando);
        FETCH C_GET_INCI_REQUEST INTO Ln_IdIncRequest,Ln_NumeroRegistro;
        CLOSE C_GET_INCI_REQUEST;

        IF Ln_IdIncRequest IS NULL
        THEN

          OPEN C_GET_INCI_REQUEST (Lv_EstadoPendiente);
          FETCH C_GET_INCI_REQUEST INTO Ln_IdIncRequest,Ln_NumeroRegistro;
          CLOSE C_GET_INCI_REQUEST;

          IF Ln_IdIncRequest IS NOT NULL
          THEN

            UPDATE INFO_INCIDENCIA_REQUEST 
            SET ESTADO = Lv_EstadoProcesando
            WHERE ID_INCIDENCIA_REQUEST = Ln_IdIncRequest;
            COMMIT;

            DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_GUARDAR_INCIDENCIA(
                                                Ln_IdIncRequest,
                                                Lv_MensajeError,
                                                Lv_Respuesta,
                                                Ln_NumeroRegistro);

            UPDATE INFO_INCIDENCIA_REQUEST 
            SET ESTADO = Lv_EstadoProcesado
            WHERE ID_INCIDENCIA_REQUEST = Ln_IdIncRequest;
            COMMIT;

          END IF;
        END IF;

        EXCEPTION 
            WHEN OTHERS THEN 
            ROLLBACK;
            Lv_MensajeError := 'Error al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                                    'DB_SOPORTE.P_JOB_PROCESAR_TICKET',
                                                    Lv_MensajeError,
                                                    'telcos',
                                                    SYSDATE,
                                                    '127.0.0.1'); 

    END P_JOB_PROCESAR_TICKET;

    PROCEDURE P_GUARDAR_INCIDENCIA(
                                  Pn_IdIncRequest   IN  INTEGER, 
                                  Pv_MensajeErrorP  OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2,
                                  Pn_NumeroRegistro IN  INTEGER) 
                                  IS

    CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
    IS
      SELECT APD.VALOR1,APD.VALOR2,
              APD.VALOR3,APD.VALOR4,APD.VALOR5,VALOR6
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.descripcion = Cv_DescripcionParametro;

    CURSOR C_GET_REQUEST_ECUCERT(Cv_idIncidenciaRequest INTEGER)
    IS
      SELECT AIR.REQUEST
      FROM DB_SOPORTE.INFO_INCIDENCIA_REQUEST AIR
      WHERE AIR.ID_INCIDENCIA_REQUEST=Cv_idIncidenciaRequest;

    Ld_fechaActual      DATE;
    Ln_count            PLS_INTEGER;

    Lv_noTicket         VARCHAR2(400); 
    Lv_feTicket         VARCHAR2(400);
    Lv_feIncidenciaIp   VARCHAR2(400);  
    Lv_categoria        VARCHAR2(400);  
    Lv_subCategoria     VARCHAR2(400);  
    Lv_prioridad        VARCHAR2(400);  
    Lv_subject          VARCHAR2(400);  
    Lv_tipoEvento       VARCHAR2(400);  
    Lv_user             VARCHAR2(400);  
    Lv_ipCreacion       VARCHAR2(400);  

    Lr_InfoParamTarea   C_GET_PARAMETROS%ROWTYPE;

    Ln_IncidenciaId     INTEGER;
    Ln_IncidenciaIdDet  INTEGER;

    Lv_ipAddress        VARCHAR2(400);  
    Lv_puerto           VARCHAR2(400);  
    Lv_ipDestino        VARCHAR2(400);  
    Lv_ipCC             VARCHAR2(400);  
    Lv_status           VARCHAR2(400);
    Lv_puertoDest       VARCHAR2(400);

    Lv_NombreParametro  VARCHAR2(400) := 'PARAMETROS_ECUCERT';
    Lv_DescripParametro VARCHAR2(400);

    Lv_EstadoInicialInc VARCHAR2(400);
    Lv_EstadoPendiente  VARCHAR2(400);

    Lcl_MensajeError    CLOB;
    Lcl_JsonEcucert     CLOB;
    Lv_IpWAN            VARCHAR2(400);

    Lv_bandCGNAT        VARCHAR2(400);
    Lv_nombreCategoria  VARCHAR2(400);
    Lv_tituloCategoria  VARCHAR2(400);
    Lv_prioridadInfra   VARCHAR2(400);
    Lv_BandCPE          VARCHAR2(400);
    Lv_tipoUsuario      VARCHAR2(400);
    Lv_BandRDA          VARCHAR2(400);
    Lv_EmpresaMEGADATOS VARCHAR2(400) := '%MEGADATOS%';
    Ln_CodigoEmprTicket NUMBER;

    Lv_IncidenciaObj        INCIDENCIA_TYPE;
    Lv_IncidenciaDetObj     INCIDENCIA_DETALLE_TYPE;
    Lv_IncidenciaDetNotObj  INCIDENCIA_NOT_DETALLE_TYPE;

   BEGIN
    SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;

    OPEN C_GET_REQUEST_ECUCERT (Pn_IdIncRequest);
    FETCH C_GET_REQUEST_ECUCERT INTO Lcl_JsonEcucert;
    CLOSE C_GET_REQUEST_ECUCERT;

    Lv_DescripParametro := 'PARAMETROS PARA ESTADO INCIDENCIA';
    OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
    FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
    CLOSE C_GET_PARAMETROS;

    Lv_EstadoInicialInc := Lr_InfoParamTarea.VALOR1;
    Lv_EstadoPendiente  := Lr_InfoParamTarea.VALOR2;

    APEX_JSON.PARSE(Lcl_JsonEcucert);

    Lv_noTicket         := APEX_JSON.get_varchar2(p_path => 'data.noTicket');
    Lv_feTicket         := APEX_JSON.get_varchar2(p_path => 'data.feTicket');
    Lv_categoria        := APEX_JSON.get_varchar2(p_path => 'data.categoria');
    Lv_subCategoria     := APEX_JSON.get_varchar2(p_path => 'data.subCategoria');
    Lv_prioridad        := APEX_JSON.get_varchar2(p_path => 'data.prioridad');
    Lv_subject          := APEX_JSON.get_varchar2(p_path => 'data.subject');
    Lv_tipoEvento       := APEX_JSON.get_varchar2(p_path => 'data.tipoEvento');
    Lv_nombreCategoria  := APEX_JSON.get_varchar2(p_path => 'data.nombreCategoria');
    Lv_tituloCategoria  := APEX_JSON.get_varchar2(p_path => 'data.tituloCategoria');
    Lv_prioridadInfra   := APEX_JSON.get_varchar2(p_path => 'data.prioridadInfraestructura');
    Lv_user             := APEX_JSON.get_varchar2(p_path => 'user');
    Lv_ipCreacion       := APEX_JSON.get_varchar2(p_path => 'source.originID');
    Lv_BandCPE          := APEX_JSON.get_varchar2(p_path => 'data.bandCPE');
    Lv_BandRDA          := APEX_JSON.get_varchar2(p_path => 'data.bandRDA');

    CASE WHEN UPPER(Lv_subject) LIKE Lv_EmpresaMEGADATOS
    THEN Ln_CodigoEmprTicket:= 18;
    ELSE Ln_CodigoEmprTicket:= 10;
    END CASE;

    Lv_IncidenciaObj    := INCIDENCIA_TYPE(Lv_noTicket,
                                         Lv_feTicket,
                                         Lv_categoria,
                                         Lv_subCategoria,
                                         Lv_EstadoInicialInc,
                                         Lv_prioridad,
                                         Lv_subject,
                                         Lv_tipoEvento,
                                         Pn_IdIncRequest,
                                         Pn_NumeroRegistro,
                                         Lv_nombreCategoria,
                                         Lv_tituloCategoria,
                                         Lv_prioridadInfra,
                                         Lv_user,
                                         Lv_ipCreacion);

    P_CREAR_INCIDENCIA(Lv_IncidenciaObj,
                     Ln_IncidenciaId,
                     Lcl_MensajeError);

    P_INGRESAR_CATEGORIA(UPPER(Lv_categoria),UPPER(Lv_subCategoria),
                         UPPER(Lv_tipoEvento),Ln_CodigoEmprTicket,Lcl_MensajeError);

    IF Ln_IncidenciaId IS NOT NULL AND Ln_IncidenciaId != 0  
    THEN
        Ln_count := APEX_JSON.GET_COUNT(p_path => 'data.ips');

        FOR i IN 1 .. Ln_count LOOP

            APEX_JSON.PARSE(Lcl_JsonEcucert);
            Lv_ipAddress        := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].ipAddress',       p0 => i);
            Lv_puerto           := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].puerto',          p0 => i);
            Lv_ipDestino        := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].ipDestino',       p0 => i);
            Lv_ipCC             := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].ipCC',            p0 => i);
            Lv_status           := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].status',          p0 => i);
            Lv_puertoDest       := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].puertoDestino',   p0 => i);
            Lv_feIncidenciaIp   := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].feIncidencia',    p0 => i);          
            Lv_tipoUsuario      := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].tipoIp',          p0 => i); 
            Lv_bandCGNAT        := APEX_JSON.get_varchar2(p_path => 'data.ips[%d].bandCGNAT',       p0 => i); 

            Lv_IncidenciaDetObj := INCIDENCIA_DETALLE_TYPE(Ln_IncidenciaId,
                                                            Lv_ipAddress,
                                                            Lv_IpWAN,
                                                            Lv_puerto,
                                                            Lv_ipDestino,
                                                            Lv_ipCC,
                                                            Lv_status,
                                                            Lv_puertoDest,
                                                            Lv_EstadoPendiente,
                                                            Lv_feIncidenciaIp,
                                                            Lv_user,
                                                            Lv_ipCreacion);

            P_CREAR_INCIDENCIA_DETALLE(Lv_IncidenciaDetObj,
                                        Ln_IncidenciaIdDet,
                                        Lcl_MensajeError);

            Lv_IncidenciaDetNotObj   := INCIDENCIA_NOT_DETALLE_TYPE(Lv_ipAddress,
                                        Ln_IncidenciaIdDet,
                                        Lv_ipCreacion,
                                        Lv_feIncidenciaIp,
                                        Lv_user,
                                        Lv_puerto,
                                        Lv_noTicket,
                                        Lv_categoria,
                                        Lv_subCategoria,
                                        Lv_tipoEvento,
                                        Lv_ipDestino,
                                        Lv_BandCPE,
                                        Lv_status,
                                        Lv_bandCGNAT,
                                        Lv_BandRDA);

            IF Lv_tipoUsuario IS NULL THEN
              Lv_tipoUsuario := 'Cliente';      
            END IF;

            P_BUSCAR_CLIENTE_NOT(Lv_IncidenciaDetNotObj,Lv_tipoUsuario,Ln_CodigoEmprTicket,Lcl_MensajeError);
        END LOOP;
        COMMIT;
     ELSE
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_GUARDAR_INCIDENCIA',
                                              'ERROR: No se agrego el encabezado de la incidencia. Revisar la data',
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1'); 
     END IF;

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Lcl_MensajeError := 'Error al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_GUARDAR_INCIDENCIA',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1'); 

    END P_GUARDAR_INCIDENCIA;

    PROCEDURE P_CREAR_INCIDENCIA(
                              Pv_IncidenciaObj      IN INCIDENCIA_TYPE,
                              Pn_IncidenciaId       OUT INTEGER,
                              Pv_MensajeError       OUT VARCHAR2
                              )
                              IS
   Ld_fechaActual DATE;
   BEGIN
    SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;

    INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_CAB (ID_INCIDENCIA,NO_TICKET,FE_TICKET,CATEGORIA,SUBCATEGORIA,ESTADO,PRIORIDAD,SUBJECT,TIPO_EVENTO,INCIDENCIA_REQUEST_ID,NUMERO_REGISTROS,NOMBRE_CATEGORIA,TITULO_CATEGORIA,PRIORIDAD_INFRAES,USR_CREACION,FE_CREACION,IP_CREACION)
    VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_CAB.NEXTVAL,
            Pv_IncidenciaObj.Pv_NoTicket,
            TO_DATE(Pv_IncidenciaObj.Pv_FeIncidencia,'yyyy/mm/dd hh24:mi:ss'),
            Pv_IncidenciaObj.Pv_Categoria,
            Pv_IncidenciaObj.Pv_SubCategoria,
            Pv_IncidenciaObj.Pv_Estado,
            Pv_IncidenciaObj.Pv_Prioridad,
            Pv_IncidenciaObj.Pv_Subject,
            Pv_IncidenciaObj.Pv_TipoEvento,
            Pv_IncidenciaObj.Pn_IdIncRequest,
            Pv_IncidenciaObj.Pn_NumeroRegistro,
            Pv_IncidenciaObj.Pv_NombreCategoria,
            Pv_IncidenciaObj.Pv_TituloCategoria,
            Pv_IncidenciaObj.Pv_PrioridadInfra,
            Pv_IncidenciaObj.Pv_UsrCreacion,
            Ld_fechaActual,
            Pv_IncidenciaObj.Pv_IpCreacion) 
    RETURNING ID_INCIDENCIA INTO Pn_IncidenciaId;

    COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Pv_MensajeError:= 'Error al procesar' || SQLERRM;
      Pn_IncidenciaId:= 0;

    END P_CREAR_INCIDENCIA;


    PROCEDURE P_CREAR_INCIDENCIA_DETALLE(
                                Pv_IncidenciaDetObj  IN INCIDENCIA_DETALLE_TYPE,
                                Pn_IncidenciaIdDet   OUT INTEGER,
                                Pv_MensajeError      OUT VARCHAR2
                              )
                              IS
   Ld_fechaActual DATE;
   BEGIN
    SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;

    INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET (ID_DETALLE_INCIDENCIA,INCIDENCIA_ID,IP,FE_INCIDENCIA,IPWAN,PUERTO,IP_DEST,IP_CC,STATUS,CASO_ID,PERSONA_EMPRESA_ROL_ID,TIPO_USUARIO,ESTADO_GESTION,PUERTO_DEST,USR_CREACION,FE_CREACION,IP_CREACION)
    VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET.NEXTVAL,
    Pv_IncidenciaDetObj.Ln_IncidenciaId,
    Pv_IncidenciaDetObj.Pv_Ip,
    TO_DATE(Pv_IncidenciaDetObj.Pv_feIncidenciaIp,'yyyy/mm/dd hh24:mi:ss'),
    Pv_IncidenciaDetObj.Pv_IpWAN,
    Pv_IncidenciaDetObj.Pv_Puerto,
    Pv_IncidenciaDetObj.Pv_IpDestino,
    Pv_IncidenciaDetObj.Pv_IpCC,
    Pv_IncidenciaDetObj.Pv_Status,
    null,null,null,
    Pv_IncidenciaDetObj.Pv_EstadoGestion,
    Pv_IncidenciaDetObj.Pv_puertoDest,
    Pv_IncidenciaDetObj.Pv_UsrCreacion,
    Ld_fechaActual,
    Pv_IncidenciaDetObj.Pv_IpCreacion)
    RETURNING ID_DETALLE_INCIDENCIA INTO Pn_IncidenciaIdDet;

    INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
    VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,
    Pn_IncidenciaIdDet,
    Pv_IncidenciaDetObj.Pv_EstadoGestion,
    Pv_IncidenciaDetObj.Pv_UsrCreacion,
    Ld_fechaActual,
    Pv_IncidenciaDetObj.Pv_IpCreacion);

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Pv_MensajeError:= 'Error al procesar'|| SQLERRM;

    END P_CREAR_INCIDENCIA_DETALLE;


   PROCEDURE P_ACT_DET_INCI_CASO_CLIENTE(
                          Pn_IncidenciaDetActId     IN INCIDENCIA_ACT_DETALLE_TYPE,
                          Pv_MensajeError           OUT VARCHAR2
                          )
                           IS
   Ld_fechaActual DATE;
   BEGIN
    SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;
    UPDATE 
    DB_SOPORTE.INFO_INCIDENCIA_DET
    SET CASO_ID                 = Pn_IncidenciaDetActId.Pn_CasoId,
        PERSONA_EMPRESA_ROL_ID  = Pn_IncidenciaDetActId.Pv_PersonaEmpRol,
        TIPO_USUARIO            = Pn_IncidenciaDetActId.Pv_TipoUsuario,
        USR_ULT_MOD             = Pn_IncidenciaDetActId.Pv_UsrModi, 
        FE_ULT_MOD              = Ld_fechaActual, 
        IP_ULT_MOD              = Pn_IncidenciaDetActId.Pv_IpModi, 
        EMPRESA_ID              = Pn_IncidenciaDetActId.Pn_IdEmpresa,
        COMUNICACION_ID         = Pn_IncidenciaDetActId.Pn_ComunicacionId,
        SERVICIO_ID             = Pn_IncidenciaDetActId.Pn_IdServicio,
        ESCSOC                  = Pn_IncidenciaDetActId.Pn_EsClieCsoc,
        ESCPE                   = Pn_IncidenciaDetActId.Pn_EsCPE,
        ESSG                    = Pn_IncidenciaDetActId.Pn_EsClieSG,
        ESCGNAT                 = Pn_IncidenciaDetActId.Pn_bandCGNAT,
        ESRDA                   = Pn_IncidenciaDetActId.Pn_BandRDA,
        IPCGNAT                 = Pn_IncidenciaDetActId.Pv_IpAddressCGNAT
    WHERE ID_DETALLE_INCIDENCIA= Pn_IncidenciaDetActId.Pn_IncidenciaDetId;
    COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Pv_MensajeError:= 'Error al procesar'|| SQLERRM;

    END P_ACT_DET_INCI_CASO_CLIENTE;

  PROCEDURE P_ACT_ESTADO_DET_INC(
                          Pn_IncidenciaDetId    IN INTEGER,
                          Pv_Estado             IN VARCHAR2,
                          Pv_UsrModi            IN VARCHAR2,
                          Pv_IpModi             IN VARCHAR2,
                          Pv_MensajeError       OUT VARCHAR2
                          )
                           IS
   Ld_fechaActual DATE;
   BEGIN
    SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;
    IF Pv_Estado = 'No Vulnerable'
    THEN

      UPDATE 
      DB_SOPORTE.INFO_INCIDENCIA_DET
      SET STATUS=Pv_Estado,USR_ULT_MOD=Pv_UsrModi, FE_ULT_MOD=Ld_fechaActual, IP_ULT_MOD=Pv_IpModi,ESTADO_GESTION='Atendido'
      WHERE ID_DETALLE_INCIDENCIA=Pn_IncidenciaDetId;

      INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
      VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,Pn_IncidenciaDetId,'Atendido','telcos',sysdate,'127.0.0.1');

    ELSE
      UPDATE 
      DB_SOPORTE.INFO_INCIDENCIA_DET
      SET STATUS=Pv_Estado,USR_ULT_MOD=Pv_UsrModi, FE_ULT_MOD=Ld_fechaActual, IP_ULT_MOD=Pv_IpModi
      WHERE ID_DETALLE_INCIDENCIA=Pn_IncidenciaDetId;
    END IF;

    COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Pv_MensajeError:= 'Error al procesar'|| SQLERRM;

    END P_ACT_ESTADO_DET_INC;


    PROCEDURE P_ACT_ESTADO_GES_INC(
                              Pn_IncidenciaDetId    IN INTEGER,
                              Pv_Estado             IN VARCHAR2,
                              Pv_UsrModi            IN VARCHAR2,
                              Pv_IpModi             IN VARCHAR2,
                              Pv_MensajeError       OUT VARCHAR2
                              )
    IS
        Ld_fechaActual DATE;
    BEGIN
        SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;
        UPDATE 
        DB_SOPORTE.INFO_INCIDENCIA_DET
        SET ESTADO_GESTION=Pv_Estado,USR_ULT_MOD=Pv_UsrModi, FE_ULT_MOD=Ld_fechaActual, IP_ULT_MOD=Pv_IpModi
        WHERE ID_DETALLE_INCIDENCIA=Pn_IncidenciaDetId;

        INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
        VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,Pn_IncidenciaDetId,Pv_Estado,Pv_UsrModi,Ld_fechaActual,Pv_IpModi);

        COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Pv_MensajeError:= 'Error al procesar'|| SQLERRM;

    END P_ACT_ESTADO_GES_INC;


    PROCEDURE P_CREAR_INCIDENCIA_NOTIF(
                                    Pv_Correo             IN VARCHAR2,
                                    Pv_TipoContacto       IN VARCHAR2,
                                    Pn_IncidenciaDetId    IN INTEGER,
                                    Pv_Estado             IN VARCHAR2,
                                    Pv_UsrCreacion        IN VARCHAR2,
                                    Pv_IpCreacion         IN VARCHAR2,
                                    Pv_MensajeError       OUT VARCHAR2
                              )
                              IS
   Ld_fechaActual DATE;
   BEGIN
    SELECT SYSDATE INTO Ld_fechaActual FROM DUAL;

    INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_NOTIF (ID_INCIDENCIA_NOTIFICACION,DETALLE_INCIDENCIA_ID,CORREO,TIPO_CONTACTO,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
    VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_NOTIF.NEXTVAL,Pn_IncidenciaDetId,Pv_Correo,Pv_TipoContacto,Pv_Estado,Pv_UsrCreacion,Ld_fechaActual,Pv_IpCreacion);
    COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN 
      ROLLBACK;
      Pv_MensajeError:= 'Error al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                                  'DB_SOPORTE.P_CREAR_INCIDENCIA_NOTIF',
                                                  Pv_MensajeError,
                                                  Pv_UsrCreacion,
                                                  SYSDATE,
                                                  Pv_IpCreacion); 

    END P_CREAR_INCIDENCIA_NOTIF;


    PROCEDURE P_REPORTE_INCIDENCIAS(
                                  Pv_FechaInicio    IN  VARCHAR2,
                                  Pv_FechaFin       IN  VARCHAR2,
                                  Pv_NoTicket       IN  VARCHAR2,
                                  Pv_MensajeError   OUT VARCHAR2) 
    IS

    CURSOR C_Get_Incidencias_Por_Fecha(Cv_FechaInicio VARCHAR2,Cv_FechaFin VARCHAR2,Cv_Ticket VARCHAR2)
    IS
    SELECT 
    ROWNUM AS NUMERO,IID.IP,IIC.NO_TICKET,IIC.FE_TICKET,IIC.CATEGORIA,IIC.PRIORIDAD,'AMBAR' AS TLP,
    IIC.ESTADO,IID.TIPO_USUARIO,IID.PUERTO,'GESTIONAR' AS ACCIONES,'NINGUNA' AS OBSERVACION
    FROM DB_SOPORTE.INFO_INCIDENCIA_CAB IIC
    INNER JOIN DB_SOPORTE.INFO_INCIDENCIA_DET IID ON IIC.ID_INCIDENCIA = IID.INCIDENCIA_ID
    WHERE (IIC.FE_TICKET BETWEEN TO_DATE(Cv_FechaInicio) AND TO_DATE(Cv_FechaFin)) OR IIC.NO_TICKET  = Cv_Ticket;

    CURSOR C_Get_Parametros_Base_Ec(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
    IS
      SELECT APD.VALOR1 as remitente,APD.VALOR6 as destinatario,
              APD.VALOR3 as extesion,APD.VALOR4 as directorio,APD.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.descripcion = Cv_DescripcionParametro;

    Lv_FechaArchivo                 VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
    Lv_AsuntoNotificacion           VARCHAR2(100)  := 'Notificación de Generacion de Reporte de Incidencias'; 
    Lv_NombreArchivo                VARCHAR2(100)  := 'ReporteIncidencias_'|| Lv_FechaArchivo||'.csv';
    Lv_ParametroProyectoEcucert     VARCHAR2(100)  := 'PARAMETROS_ECUCERT';
    Lv_ParametroDescripcion         VARCHAR2(100)  := 'PARAMETROS_REPORTE_BASE';    
    Lv_Directorio                   VARCHAR2(50)   ;
    Lv_NombreArchivoComprimir       VARCHAR2(100)  ;
    Lv_Remitente                    VARCHAR2(100)  ;
    Lv_Destinatario                 VARCHAR2(100)  ;
    Lv_ParametroExtensionReport     VARCHAR2(100)  ;
    Lv_Delimitador                  VARCHAR2(1)    := '|';
    Lv_ParamBaseEcucert             C_Get_Parametros_Base_Ec%ROWTYPE;
    Lcl_Texto                       CLOB;
    Lcl_InfoIp                      CLOB;
    Lv_AttachName                   VARCHAR2(4000) := 'REPORTE_ECUCERT.csv';
    Lv_AttachMime                   VARCHAR2(4000) := 'text/plain';
    Lv_SmtpHost                     VARCHAR2(4000);
    Lv_CopiaCorreo                  VARCHAR2(4000); 

    BEGIN
    --Se obtiene el comando a ejecutar    
    OPEN C_Get_Parametros_Base_Ec(Lv_ParametroProyectoEcucert,Lv_ParametroDescripcion);
    FETCH C_Get_Parametros_Base_Ec INTO Lv_ParamBaseEcucert;
    CLOSE C_Get_Parametros_Base_Ec;

    Lv_Remitente                :=  Lv_ParamBaseEcucert.remitente;
    Lv_Destinatario             :=  Lv_ParamBaseEcucert.destinatario;
    Lv_ParametroExtensionReport :=  Lv_ParamBaseEcucert.extesion;
    Lv_Directorio               :=  Lv_ParamBaseEcucert.directorio;
    Lv_SmtpHost                 :=  Lv_ParamBaseEcucert.VALOR5;
    --Se crea el archivo

    Lcl_Texto := 'NUMERO'||Lv_Delimitador 
                        ||'IP'||Lv_Delimitador 
                        ||'NO_TICKET'||Lv_Delimitador
                        ||'FE_TICKET'||Lv_Delimitador
                        ||'CATEGORIA'||Lv_Delimitador
                        ||'PRIORIDAD'||Lv_Delimitador
                        ||'TLP'||Lv_Delimitador
                        ||'ESTADO'||Lv_Delimitador
                        ||'TIPO_USUARIO'||Lv_Delimitador
                        ||'PUERTO'||Lv_Delimitador
                        ||'ACCIONES'||Lv_Delimitador
                        ||'OBSERVACION'||Lv_Delimitador || UTL_TCP.crlf;

    IF (C_Get_Incidencias_Por_Fecha%isopen) THEN 
      CLOSE C_Get_Incidencias_Por_Fecha;
    END IF;

    FOR i IN C_Get_Incidencias_Por_Fecha(Pv_FechaInicio,Pv_FechaFin,Pv_NoTicket)
    LOOP

    Lcl_InfoIp :=  i.NUMERO ||Lv_Delimitador                                 
                ||i.IP||Lv_Delimitador                                                   
                ||i.NO_TICKET||Lv_Delimitador   
                ||i.FE_TICKET||Lv_Delimitador
                ||i.CATEGORIA||Lv_Delimitador
                ||i.PRIORIDAD||Lv_Delimitador
                ||i.TLP||Lv_Delimitador
                ||i.ESTADO||Lv_Delimitador
                ||i.TIPO_USUARIO||Lv_Delimitador
                ||i.PUERTO||Lv_Delimitador
                ||i.ACCIONES||Lv_Delimitador
                ||i.OBSERVACION||Lv_Delimitador;

    Lcl_Texto := Lcl_Texto || Lcl_InfoIp || UTL_TCP.crlf;

    END LOOP;

    --Armo nombre completo del archivo que se genera
    Lv_NombreArchivoComprimir := Lv_NombreArchivo || Lv_ParametroExtensionReport;

    P_ENVIO_CORREO(
                                Lv_Destinatario,
                                Lv_Remitente,
                                Lv_AsuntoNotificacion,
                                Lv_SmtpHost,
                                Lv_AsuntoNotificacion,
                                Lv_AsuntoNotificacion,
                                Lv_AttachName,
                                Lv_AttachMime,
                                Lcl_Texto,
                                Lv_CopiaCorreo   
                            );


    Pv_MensajeError := 'Proceso realizado correctamente';

    EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_REPORTE_INCIDENCIAS',
                                              Pv_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');


    END P_REPORTE_INCIDENCIAS;

	PROCEDURE P_CREAR_REQUEST (Pcl_Json          IN CLOB,
                                Pv_URL           IN VARCHAR2,
                                Pv_Respuesta     OUT VARCHAR2,
                                Pv_MensajeError  OUT VARCHAR2
                                    )IS

    Lv_Metodo        VARCHAR2(10);
    Lv_Version       VARCHAR2(10);
    Lv_Aplicacion    VARCHAR2(50);
    Ln_LongitudReq   NUMBER;
    Ln_LongitudIdeal NUMBER:= 32767;
    Ln_Offset        NUMBER:= 1;
    Ln_Buffer        VARCHAR2(2000);
    Ln_Amount        NUMBER := 2000;
    Lcl_Json         CLOB;
    Lhttp_Request    UTL_HTTP.req;
    Lhttp_Response   UTL_HTTP.resp;

    BEGIN

      Lv_Metodo       := 'POST';
      Lv_Version      := 'HTTP/1.1';
      Lv_Aplicacion   := 'application/json';

      Lcl_Json          := Pcl_Json;
      Lhttp_Request     := UTL_HTTP.begin_request (Pv_URL,
                                               Lv_Metodo,
                                               Lv_Version);
      utl_http.set_body_charset( Lhttp_Request, 'utf-8'); 
      UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
      UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);

      Ln_LongitudReq  := DBMS_LOB.getlength(Lcl_Json);

      IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
        UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lcl_Json));
        UTL_HTTP.write_text(Lhttp_Request, Lcl_Json);
      ELSE
        UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
        WHILE (Ln_Offset < Ln_LongitudReq) LOOP
          DBMS_LOB.READ(Lcl_Json, 
                        Ln_Amount,
                        Ln_Offset,
                        Ln_Buffer);
          UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
          Ln_Offset := Ln_Offset + Ln_Amount;
        END LOOP;
      END IF;

      Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
      utl_http.read_text(Lhttp_Response, Pv_Respuesta);                         
      UTL_HTTP.end_response(Lhttp_Response);

    EXCEPTION  
      WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
        UTL_HTTP.END_RESPONSE(Lhttp_Response); 
      WHEN UTL_HTTP.end_of_body THEN
        UTL_HTTP.end_response(Lhttp_Response);
        Pv_MensajeError := 'Error AL CREAR REQUEST GUARDAR INCIDENCIA: HTTP END BODY'||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK || ' JSON:'|| SUBSTR(Pcl_Json,1,3700);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_CREAR_REQUEST',
                                              Pv_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');
      WHEN OTHERS THEN
        Pv_MensajeError := 'Error AL CREAR REQUEST GUARDAR INCIDENCIA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK || ' JSON:'|| SUBSTR(Pcl_Json,1,3700);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_CREAR_REQUEST',
                                              Pv_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

  END P_CREAR_REQUEST;

  PROCEDURE P_DATOS_CREAR_CASOS   (Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2,
                                    Pv_NoCaso        OUT VARCHAR2,
                                    Pv_NoTarea       OUT VARCHAR2
                                    )IS 
    Lv_StatusCaso    VARCHAR2(50);
    Lv_StatusTarea   VARCHAR2(50);
    Lcl_MensajeError   CLOB;
    BEGIN
      apex_json.parse (Pv_Data);
      Lv_StatusCaso     := UPPER(APEX_JSON.get_varchar2(p_path => 'status'));
      IF Lv_StatusCaso = 'OK'
      THEN
        Pv_NoCaso         := APEX_JSON.get_varchar2(p_path => 'result.numeroCaso');
        Lv_StatusTarea    := UPPER(APEX_JSON.get_varchar2(p_path => 'result.tareas[%d].status',   p0 => 1));
        IF Lv_StatusTarea = 'OK'
        THEN
            Pv_NoTarea        := APEX_JSON.get_varchar2(p_path => 'result.tareas[%d].numeroTarea',   p0 => 1);
        END IF;
      END IF;

      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Message:=apex_json.get_varchar2('mensaje');

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error AL CREAR REQUEST GUARDAR INCIDENCIA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_DATOS_CREAR_CASOS',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_DATOS_CREAR_CASOS;

    PROCEDURE P_ENVIO_NOTIFICACION(Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2
                                    )IS 
    Lcl_MensajeError CLOB;
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Message:=apex_json.get_varchar2('mensaje');

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error AL CREAR REQUEST GUARDAR INCIDENCIA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.PUT NOTIFICACION',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_ENVIO_NOTIFICACION;

    PROCEDURE P_RESPUESTA_RDA(Pv_Data          IN  VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pv_Login        OUT VARCHAR2
                                )IS 
    Lcl_MensajeError CLOB;
    Lv_Mac          VARCHAR2(400);
    CURSOR C_GetLoginPorMAc(Cv_Mac VARCHAR2) 
    IS
        select ipu.login from 
        DB_COMERCIAL.info_servicio_prod_caract ispc
        inner join DB_COMERCIAL.info_servicio ise on ispc.servicio_id=ise.id_servicio
        inner join DB_COMERCIAL.info_punto ipu on ipu.id_punto=ise.punto_id
        where UPPER(valor)=Cv_Mac AND ispc.estado = 'Activo' and ROWNUM <2; 
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status := UPPER(apex_json.get_varchar2('status'));
      IF Pv_Status = 'OK'
      THEN 
        Lv_Mac    := apex_json.get_varchar2(p_path => 'datos[%d].mac',   p0 => 1);
        Pv_Login  := apex_json.get_varchar2(p_path => 'datos[%d].login',   p0 => 1);
        IF Lv_Mac IS NOT NULL AND Pv_Login IS NULL
        THEN
            OPEN C_GetLoginPorMAc(Lv_Mac);
            FETCH C_GetLoginPorMAc INTO Pv_Login;
            CLOSE C_GetLoginPorMAc; 
        END IF;
      END IF;

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error P_RESPUESTA_RDA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_RESPUESTA_RDA',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_RESPUESTA_RDA;

    PROCEDURE P_RESPUESTA_CGNAT(Pv_Data     IN  VARCHAR2, 
                                 Pv_Ip      OUT VARCHAR2
                                )IS 
    Lcl_MensajeError CLOB;
    BEGIN
        apex_json.parse (Pv_Data);
        Pv_Ip    := apex_json.get_varchar2(p_path => 'hits.hits[%d]._source.netflow.ipv4_src_addr',   p0 => 1);
      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error P_RESPUESTA_CGNAT: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_RESPUESTA_CGNAT',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_RESPUESTA_CGNAT;

    PROCEDURE P_BUSQUEDA_CLIENTE_MD(Pv_Data         IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2
                                    )IS 
    Lcl_MensajeError CLOB;
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Message:=apex_json.get_varchar2('mensaje');

       EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error AL CREAR REQUEST GUARDAR INCIDENCIA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.CLIENTE_MD',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_BUSQUEDA_CLIENTE_MD;

    PROCEDURE P_REPORTE_INC_AUTOMAT(Pv_NumeroTicket  IN  VARCHAR2)
    IS

    CURSOR C_Get_Incidencias_Fecha_Cab(Cv_Estado VARCHAR2,Cv_EmpresaMEGADATOS VARCHAR2)
    IS
    SELECT 
    IIC.ID_INCIDENCIA,IIC.SUBJECT,UPPER(IIC.TIPO_EVENTO),UPPER(IIC.NO_TICKET),UPPER(IIC.NOMBRE_CATEGORIA), TO_CHAR(IIC.FE_TICKET, 'YYYY-MM-DD HH24:MI:SS'),
    IIC.ESTADO,(CASE WHEN UPPER(IIC.SUBJECT) LIKE Cv_EmpresaMEGADATOS THEN 18 ELSE 10 END) AS CODIGO_EMPRESA
    FROM DB_SOPORTE.INFO_INCIDENCIA_CAB IIC
    INNER JOIN DB_SOPORTE.ADMI_INCIDENCIA_PRIORIDAD AIP ON UPPER(AIP.TIPO_EVENTO)=UPPER(IIC.TIPO_EVENTO) AND UPPER(AIP.PRIORIDAD)=UPPER(IIC.PRIORIDAD)
    WHERE  IIC.ESTADO = Cv_Estado AND F_DIAS_LABORABLES(IIC.FE_TICKET,SYSDATE) >= AIP.TIEMPO_HORA 
           AND IIC.NO_TICKET NOT LIKE 'INTERNO%' AND ROWNUM = 1;

    CURSOR C_Get_Incidencias_Cab_Ticket(Cv_NumeroTicket VARCHAR2,Cv_EmpresaMEGADATOS VARCHAR2)
    IS
    SELECT 
    IIC.ID_INCIDENCIA,IIC.SUBJECT,UPPER(IIC.TIPO_EVENTO),UPPER(IIC.NO_TICKET),UPPER(IIC.NOMBRE_CATEGORIA), TO_CHAR(IIC.FE_TICKET, 'YYYY-MM-DD HH24:MI:SS'),
    IIC.ESTADO,(CASE WHEN UPPER(IIC.SUBJECT) LIKE Cv_EmpresaMEGADATOS THEN 18 ELSE 10 END) AS CODIGO_EMPRESA
    FROM DB_SOPORTE.INFO_INCIDENCIA_CAB IIC
    INNER JOIN DB_SOPORTE.ADMI_INCIDENCIA_PRIORIDAD AIP ON UPPER(AIP.TIPO_EVENTO)=UPPER(IIC.TIPO_EVENTO) AND UPPER(AIP.PRIORIDAD)=UPPER(IIC.PRIORIDAD)
    WHERE IIC.NO_TICKET = Cv_NumeroTicket;

    CURSOR C_Get_Incidencias_Fecha_Det(Cv_IdIncidencia INTEGER,Cv_EstadoAtendido VARCHAR2,Cv_EstadoAnalisis VARCHAR2,Cv_CodigoEmpreTicket INTEGER)
    IS
    SELECT 
    ROWNUM AS NUMERO,IID.ID_DETALLE_INCIDENCIA,IID.IP,IIC.NO_TICKET,IIC.FE_TICKET,IIC.CATEGORIA,IIC.SUBCATEGORIA,IIC.PRIORIDAD,'AMBAR' AS TLP,
    IID.ESTADO_GESTION,NVL(IID.TIPO_USUARIO,'Cliente') AS TIPO_USUARIO,IID.PUERTO,'GESTIONAR' AS ACCIONES,
    CASE  WHEN (IID.ESTADO_GESTION = Cv_EstadoAtendido OR IID.ESTADO_GESTION = Cv_EstadoAnalisis) THEN
      CASE
        WHEN (Cv_CodigoEmpreTicket = 18 OR Cv_CodigoEmpreTicket = 10) AND IID.ESTADO_GESTION = Cv_EstadoAtendido AND UPPER(IIC.TIPO_EVENTO) = 'VULNERABLE'
        THEN 'Script automático ejecutado en la fecha '
          ||IFDH.FE_CREACION
          ||' indica que la IP reportada NO ES VULNERABLE. '
        WHEN (Cv_CodigoEmpreTicket = 18 OR Cv_CodigoEmpreTicket = 10) AND IID.PERSONA_EMPRESA_ROL_ID IS NULL AND IID.ESTADO_GESTION = Cv_EstadoAnalisis
        THEN 'Gestión por procesos internos'
        WHEN UPPER(IIC.TIPO_EVENTO) = 'INCIDENTE' OR (UPPER(IID.STATUS) = 'VULNERABLE' AND IID.ESTADO_GESTION = Cv_EstadoAnalisis)
        THEN 'Gestión automática de notificaciones'
        ELSE 'Script automático ejecutado en la fecha ' ||IFDH.FE_CREACION ||' indica que la IP reportada NO ES VULNERABLE. '
      END
    ELSE CASE  WHEN TNO.TOTALNOTIF IS NULL THEN 
         CASE WHEN NVL(IID.TIPO_USUARIO,'Cliente') = 'Infraestructura' THEN 
         'Se Notificó al departamento de Seguridad Lógica mediante tarea de gestión interna para su revisión y gestión' 
         ELSE 'Notificación Pendiente. ' END
         ELSE 'Se Notificó al Cliente mediante correo electrónico, incluyendo recomendaciones de Seguridad para su gestión. ' 
         END
    END AS OBSERVACION,
    IFDH.FE_CREACION AS FECHAGESTION,IID.COMUNICACION_ID
    FROM DB_SOPORTE.INFO_INCIDENCIA_CAB IIC
    INNER JOIN DB_SOPORTE.INFO_INCIDENCIA_DET IID ON IIC.ID_INCIDENCIA = IID.INCIDENCIA_ID
    LEFT JOIN (
                SELECT IIN.DETALLE_INCIDENCIA_ID,COUNT(IIN.CORREO) AS TOTALNOTIF
                FROM DB_SOPORTE.INFO_INCIDENCIA_NOTIF IIN  
                WHERE IIN.CORREO IS NOT NULL
                GROUP BY IIN.DETALLE_INCIDENCIA_ID) TNO ON TNO.DETALLE_INCIDENCIA_ID = IID.ID_DETALLE_INCIDENCIA
    LEFT JOIN (SELECT DETALLE_INCIDENCIA_ID,MAX(ID_INCIDENCIA_DET_HIST)  AS ID_INCIDENCIA_DET_HIST 
                FROM DB_SOPORTE.INFO_INCIDENCIA_DET_HIST
                GROUP BY DETALLE_INCIDENCIA_ID) T1 ON T1.DETALLE_INCIDENCIA_ID=IID.ID_DETALLE_INCIDENCIA
    LEFT JOIN DB_SOPORTE.INFO_INCIDENCIA_DET_HIST IFDH ON IFDH.ID_INCIDENCIA_DET_HIST = T1.ID_INCIDENCIA_DET_HIST
    WHERE  IIC.ID_INCIDENCIA = Cv_IdIncidencia;

    CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
    IS
      SELECT APD.VALOR1,APD.VALOR2,
              APD.VALOR3,APD.VALOR4,APD.VALOR5,APD.VALOR7
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.descripcion = Cv_DescripcionParametro;

    CURSOR C_GET_PARAMETROS_ALIAS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2,Cn_CodEmpresa VARCHAR2)
    IS
      SELECT APD.VALOR1,APD.VALOR2,APD.VALOR3,
             APD.VALOR4,APD.VALOR5,APD.VALOR6,APD.VALOR7
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.DESCRIPCION = Cv_DescripcionParametro AND  APD.EMPRESA_COD = Cn_CodEmpresa;


    Lv_FechaArchivo                 VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
    Lv_AsuntoNotificacion           VARCHAR2(100)  := 'Notificación de Generación de Reporte de Incidencias'; 
    Lv_NombreArchivo                VARCHAR2(100)  := 'ReporteIncidencias_'|| Lv_FechaArchivo||'.csv';
    Lv_ParametroProyectoEcucert     VARCHAR2(100)  := 'PARAMETROS_ECUCERT';
    Lv_ParametroDescripcion         VARCHAR2(100)  := 'PARAMETROS_REPORTE_BASE';     
    Lv_IpCreacion                   VARCHAR2(30)   := '127.0.0.1';
    Lv_Directorio                   VARCHAR2(50)   ;
    Lv_NombreArchivoComprimir       VARCHAR2(100)  ;
    Lv_Remitente                    VARCHAR2(100)  ;
    Lv_RemitenteTelconet            VARCHAR2(100)  ;
    Lv_RemitenteMegadatos           VARCHAR2(100)  ;
    Lv_Destinatario                 VARCHAR2(100)  ;
    Lv_ParametroExtensionReport     VARCHAR2(100)  ;
    Lv_ParamBaseEcucert             C_GET_PARAMETROS%ROWTYPE;
    Lv_ParamAliasEcucert            C_GET_PARAMETROS_ALIAS%ROWTYPE;
    Lv_Estado                       VARCHAR2(300):='Creado';
    Lv_TipoIncidencia               VARCHAR2(300);   
    Lv_MensajeError                 VARCHAR2(1000);
    Lv_NoTicket                     VARCHAR2(1000);
    Lv_Categoria                    VARCHAR2(1000);
    Lv_IdIncidencia                 INTEGER;
    Lcl_Datos                       CLOB;
    Lcl_Encabezado                  CLOB;
    Lv_SubjectInc                   VARCHAR2(1000);
    Lv_URLCERT                      VARCHAR2(1000);
    Lv_RespuestaCert                VARCHAR2(1000);
    Lv_fechaGestion                 VARCHAR2(1000);
    Lv_horaGestion                  VARCHAR2(1000);
    Lv_URLToken                     VARCHAR2(400);
    Lv_RespuestaToken               VARCHAR2(4000);
    Lcl_JsonVulnerabilidad          CLOB;
    Lcl_JsonToken                   CLOB;
    Lv_Token                        VARCHAR2(800);
    Lv_Status                       VARCHAR2(800);
    Lv_Message                      VARCHAR2(800);
    Lv_NombrePrestador              VARCHAR2(4000);
    Lv_FechaIncidencia              VARCHAR2(800);
    Lv_EstadoAtendido               VARCHAR2(800);
    Lv_EstadoAnalisis               VARCHAR2(800);
    Lv_AttachMime                   VARCHAR2(4000) := 'text/plain';
    Lv_SmtpHost                     VARCHAR2(4000);
    Lv_Vulnerable                   VARCHAR2(400);
    Lv_EstadoEnvio                  VARCHAR2(400);
    Lv_CodigoEmpreTicket            INTEGER;
    Lv_CopiaCorreo                  VARCHAR2(4000) := 'soc_notificaciones@telconet.net'; 
    Lv_EmpresaMEGADATOS             VARCHAR2(400) := '%MEGADATOS%';
    Lv_Delimitador                  VARCHAR2(1)    := ';';

    BEGIN

    Lcl_Datos   := '';
    OPEN C_GET_PARAMETROS(Lv_ParametroProyectoEcucert,Lv_ParametroDescripcion);
    FETCH C_GET_PARAMETROS INTO Lv_ParamBaseEcucert;
    CLOSE C_GET_PARAMETROS;

    Lv_RemitenteTelconet        :=  Lv_ParamBaseEcucert.VALOR1;
    Lv_Destinatario             :=  Lv_ParamBaseEcucert.VALOR2;
    Lv_ParametroExtensionReport :=  Lv_ParamBaseEcucert.VALOR3;
    Lv_Directorio               :=  Lv_ParamBaseEcucert.VALOR4;
    Lv_SmtpHost                 :=  Lv_ParamBaseEcucert.VALOR5;
    Lv_RemitenteMegadatos       :=  Lv_ParamBaseEcucert.VALOR7;

    Lv_ParametroDescripcion := 'PARAMETROS PARA ESTADO INCIDENCIA';
    OPEN C_GET_PARAMETROS (Lv_ParametroProyectoEcucert,Lv_ParametroDescripcion);
    FETCH C_GET_PARAMETROS INTO Lv_ParamBaseEcucert;
    CLOSE C_GET_PARAMETROS;

    Lv_EstadoAtendido   := Lv_ParamBaseEcucert.VALOR5;
    Lv_EstadoAnalisis   := Lv_ParamBaseEcucert.VALOR3;         

    Lv_ParametroDescripcion := 'URL ECUCERT';
    OPEN C_GET_PARAMETROS (Lv_ParametroProyectoEcucert,Lv_ParametroDescripcion);
    FETCH C_GET_PARAMETROS INTO Lv_ParamBaseEcucert;
    CLOSE C_GET_PARAMETROS;

    Lv_URLCERT          := Lv_ParamBaseEcucert.VALOR3;
    Lv_URLToken         := Lv_ParamBaseEcucert.VALOR5;

    IF (C_Get_Incidencias_Fecha_Cab%isopen) THEN 
      CLOSE C_Get_Incidencias_Fecha_Cab;
    END IF;

    IF (C_Get_Incidencias_Cab_Ticket%isopen) THEN 
      CLOSE C_Get_Incidencias_Cab_Ticket;
    END IF;

    IF (C_Get_Incidencias_Fecha_Det%isopen) THEN 
      CLOSE C_Get_Incidencias_Fecha_Det;
    END IF;

    IF Pv_NumeroTicket IS NOT NULL THEN
      OPEN C_Get_Incidencias_Cab_Ticket(Pv_NumeroTicket,Lv_EmpresaMEGADATOS);
      FETCH C_Get_Incidencias_Cab_Ticket INTO Lv_IdIncidencia,Lv_SubjectInc,Lv_TipoIncidencia,
                                              Lv_NoTicket,Lv_Categoria,Lv_FechaIncidencia,Lv_EstadoEnvio,Lv_CodigoEmpreTicket;
      CLOSE C_Get_Incidencias_Cab_Ticket;
    ELSE
      OPEN C_Get_Incidencias_Fecha_Cab(Lv_Estado,Lv_EmpresaMEGADATOS);
      FETCH C_Get_Incidencias_Fecha_Cab INTO Lv_IdIncidencia,Lv_SubjectInc,Lv_TipoIncidencia,
                                              Lv_NoTicket,Lv_Categoria,Lv_FechaIncidencia,Lv_EstadoEnvio,Lv_CodigoEmpreTicket;
      CLOSE C_Get_Incidencias_Fecha_Cab;
    END IF;

    IF Lv_IdIncidencia IS NOT NULL
    THEN
        IF Lv_CodigoEmpreTicket = 10 THEN
            Lv_Remitente        := Lv_RemitenteTelconet;
            Lv_NombrePrestador  :='TELCONET';
        ELSE
            Lv_Remitente        := Lv_RemitenteMegadatos;
            Lv_NombrePrestador  :='MEGADATOS';
        END IF;

        --Copia a Alias
        Lv_ParametroDescripcion := 'CORREOS ALIAS ECUCERT';
        OPEN C_GET_PARAMETROS_ALIAS(Lv_ParametroProyectoEcucert,Lv_ParametroDescripcion,Lv_CodigoEmpreTicket);
        FETCH C_GET_PARAMETROS_ALIAS INTO Lv_ParamAliasEcucert;
        CLOSE C_GET_PARAMETROS_ALIAS;

        IF Lv_ParamAliasEcucert.VALOR1 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR1;
        END IF;
        IF Lv_ParamAliasEcucert.VALOR2 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR2;
        END IF;
        IF Lv_ParamAliasEcucert.VALOR3 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR3;
        END IF;
        IF Lv_ParamAliasEcucert.VALOR4 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR4;
        END IF;
        IF Lv_ParamAliasEcucert.VALOR5 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR5;
        END IF;
        IF Lv_ParamAliasEcucert.VALOR6 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR6;
        END IF;
        IF Lv_ParamAliasEcucert.VALOR7 IS NOT NULL THEN
            Lv_CopiaCorreo := Lv_CopiaCorreo||','||Lv_ParamAliasEcucert.VALOR7;
        END IF;

        UPDATE DB_SOPORTE.INFO_INCIDENCIA_CAB SET ESTADO='Procesando' WHERE ID_INCIDENCIA=Lv_IdIncidencia;
        COMMIT;

        IF Lv_TipoIncidencia = 'INCIDENTE' THEN

        Lcl_Encabezado := 'Codigo: FO-CCDR-04'||Lv_Delimitador 
                    ||'DIRECCIÓN TÉCNICA DE CONTROL DE SEGURIDAD DE REDES DE TELECOMUNICACIONES REPORTE SOBRE LA GESTION DE INCIDENTES NOTIFICADOS POR LA ARCOTEL'|| UTL_TCP.crlf || '' || Lv_Delimitador 
                    ||'AGENCIA DE REGULACIÓN Y CONTROL DE LAS TELECOMUNICACIONES'||  UTL_TCP.crlf ||  UTL_TCP.crlf
                    || 'Version: 1.0' ||  UTL_TCP.crlf ||  UTL_TCP.crlf
                    || 'PRESTADOR:'||Lv_Delimitador|| Lv_NombrePrestador ||  UTL_TCP.crlf
                    || 'ELABORACIÓN REPORTE:'||Lv_Delimitador|| Lv_NombrePrestador ||  UTL_TCP.crlf
                    || 'FECHA DEL REPORTE:'||Lv_Delimitador|| sysdate ||  UTL_TCP.crlf
                    || 'NÚMERO DE TICKET ARCOTEL:'||Lv_Delimitador|| Lv_NoTicket ||  UTL_TCP.crlf
                    || 'FECHA DE NOTIFICACIÓN:'||Lv_Delimitador|| Lv_FechaIncidencia ||  UTL_TCP.crlf
                    || 'EVENTO (INCIDENTE):'||Lv_Delimitador|| Lv_Categoria ||  UTL_TCP.crlf || UTL_TCP.crlf
                    || 'No.:'||Lv_Delimitador|| 'IP reportada/caso' ||Lv_Delimitador|| 'Tipo de Usuario' || Lv_Delimitador
                    || 'Estado de Gestión:'||Lv_Delimitador|| 'Fecha de gestión del incidente (dd/mm/aaaa)' ||Lv_Delimitador|| 
                    'Hora de fin de gestión del incidente (hh:mm)' || Lv_Delimitador|| 
                    'Acciones técnicas o administrativas ejecutadas para la gestion del incidente' || UTL_TCP.crlf ;
        ELSE

        Lcl_Encabezado := 'Codigo: FO-CCDR-03'||Lv_Delimitador 
                    ||'DIRECCIÓN TÉCNICA DE CONTROL DE SEGURIDAD DE REDES DE TELECOMUNICACIONES REPORTE SOBRE LA GESTION DE INCIDENTES NOTIFICADOS POR LA ARCOTEL'|| UTL_TCP.crlf || '' || Lv_Delimitador 
                    ||'AGENCIA DE REGULACIÓN Y CONTROL DE LAS TELECOMUNICACIONES'||  UTL_TCP.crlf ||  UTL_TCP.crlf
                    || 'Version: 1.0' ||  UTL_TCP.crlf ||  UTL_TCP.crlf
                    || 'PRESTADOR:'||Lv_Delimitador|| Lv_NombrePrestador ||  UTL_TCP.crlf
                    || 'REPORTE ELABORADO POR:'||Lv_Delimitador|| Lv_NombrePrestador ||  UTL_TCP.crlf
                    || 'FECHA DEL REPORTE:'||Lv_Delimitador|| sysdate ||  UTL_TCP.crlf
                    || 'NÚMERO DE TICKET ARCOTEL:'||Lv_Delimitador|| Lv_NoTicket ||  UTL_TCP.crlf
                    || 'FECHA DE NOTIFICACIÓN:'||Lv_Delimitador|| Lv_FechaIncidencia ||  UTL_TCP.crlf
                    || 'EVENTO (VULNERABILIDAD):'||Lv_Delimitador|| Lv_Categoria ||  UTL_TCP.crlf || UTL_TCP.crlf
                    || '#'||Lv_Delimitador|| 'IP reportada' ||Lv_Delimitador|| 'Tipo de Usuario' || Lv_Delimitador
                    || 'Estado de Gestión:'||Lv_Delimitador|| 'Fecha de gestión' ||Lv_Delimitador|| 
                    'Acciones técnicas o administrativas ejecutadas para la gestion del incidente' || UTL_TCP.crlf ;
        END IF;

        FOR i IN C_Get_Incidencias_Fecha_Det(Lv_IdIncidencia,Lv_EstadoAtendido,Lv_EstadoAnalisis,Lv_CodigoEmpreTicket)
        LOOP   

            Lcl_JsonToken    := '
                    {
                      "source": {
                        "name": "APP.CERT",
                        "originID": "'||Lv_ipCreacion||'",
                        "tipoOriginID": "IP"
                                },
                      "user": "CERT",
                      "gateway": "Authentication",
                      "service": "Authentication",
                      "method": "Authentication"
                    }';

            P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lv_MensajeError);        
            P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

            Lcl_JsonVulnerabilidad  :='{"op": "validate", 
                                    "token": "'||Lv_Token||'",
                                    "data": { "categoria": "'||i.CATEGORIA||'", "subcategoria": "'|| i.SUBCATEGORIA ||'", "ip_address": "'|| i.IP || '"}}';
            Lv_Vulnerable := '';
            P_CREAR_REQUEST (Lcl_JsonVulnerabilidad ,Lv_URLCERT,Lv_RespuestaCert,Lv_MensajeError);
            P_RESPUESTA_CERT_VUL(Lv_RespuestaCert,i.COMUNICACION_ID,Lv_Status,Lv_Vulnerable);
            IF Lv_Vulnerable IS NOT NULL AND Lv_Vulnerable = 'N'
            THEN 
                P_ACTUALIZAR_ESTADO_GESTION(Lv_EstadoAtendido,'No Vulnerable',i.ID_DETALLE_INCIDENCIA);
            END IF;

        END LOOP;
        COMMIT;

        IF (C_Get_Incidencias_Fecha_Det%isopen) THEN 
          CLOSE C_Get_Incidencias_Fecha_Det;
        END IF;

        FOR i IN C_Get_Incidencias_Fecha_Det(Lv_IdIncidencia,Lv_EstadoAtendido,Lv_EstadoAnalisis,Lv_CodigoEmpreTicket)
        LOOP
        IF i.FECHAGESTION IS NOT NULL
        THEN
            Lv_fechaGestion    := TO_CHAR(i.FECHAGESTION, 'YYYY/MM/DD');
            Lv_horaGestion     := TO_CHAR(i.FECHAGESTION, 'HH24:MI:SS');
        ELSE
            Lv_fechaGestion    := TO_CHAR(i.FE_TICKET, 'YYYY/MM/DD');
            Lv_horaGestion     := TO_CHAR(i.FE_TICKET, 'HH24:MI:SS');
        END IF;

        IF Lv_TipoIncidencia = 'INCIDENTE' THEN

        IF i.ESTADO_GESTION != Lv_EstadoAtendido
        THEN
            Lv_fechaGestion    := '';
            Lv_horaGestion     := '';
        END IF;
        Lcl_Datos := Lcl_Datos || TO_CLOB( i.NUMERO||Lv_Delimitador || i.IP ||Lv_Delimitador ||
                          i.TIPO_USUARIO||Lv_Delimitador || i.ESTADO_GESTION ||Lv_Delimitador ||
                          Lv_fechaGestion||Lv_Delimitador || Lv_horaGestion ||Lv_Delimitador ||
                          i.OBSERVACION||UTL_TCP.crlf) ;  
        ELSE

        IF i.ESTADO_GESTION = Lv_EstadoAnalisis
        THEN
            Lv_fechaGestion    := '';
            Lv_horaGestion     := '';
        END IF;
        Lcl_Datos := Lcl_Datos || TO_CLOB( i.NUMERO||Lv_Delimitador || i.IP ||Lv_Delimitador ||
                          i.TIPO_USUARIO||Lv_Delimitador || i.ESTADO_GESTION ||Lv_Delimitador ||
                          Lv_fechaGestion||Lv_Delimitador || i.OBSERVACION||UTL_TCP.crlf) ;  
        END IF;
        END LOOP;

        Lcl_Encabezado := Lcl_Encabezado || Lcl_Datos ;

        --Armo nombre completo del archivo que se genera
        Lv_NombreArchivoComprimir := Lv_NombreArchivo || Lv_ParametroExtensionReport;  

         P_ENVIO_CORREO(
                Lv_Destinatario,
                Lv_Remitente,
                Lv_AsuntoNotificacion,
                Lv_SmtpHost,
                Lv_SubjectInc,
                Lv_AsuntoNotificacion,
                'REPORTE ECUCERT - ' || Lv_SubjectInc ||'.csv',
                Lv_AttachMime,
                Lcl_Encabezado,
                Lv_CopiaCorreo
            );

        UPDATE DB_SOPORTE.INFO_INCIDENCIA_CAB SET ESTADO = 'Enviado' WHERE ID_INCIDENCIA = Lv_IdIncidencia;
        COMMIT;
        Lv_MensajeError:= 'Proceso realizado correctamente';
    END IF;

    EXCEPTION
    WHEN OTHERS THEN
        UPDATE DB_SOPORTE.INFO_INCIDENCIA_CAB SET ESTADO=Lv_Estado WHERE ID_INCIDENCIA=Lv_IdIncidencia;
        COMMIT;
        Lv_MensajeError := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK; 
        DB_GENERAL.GNRLPCK_UTIL.insert_error('ECUCERT', 
                                            'SPKG_INCIDENCIA_ECUCERT.P_REPORTE_INC_AUTOMAT', 
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );  
    END P_REPORTE_INC_AUTOMAT;

    PROCEDURE P_TOKEN(Pv_Data          IN  VARCHAR2,
                        Pv_Token         OUT VARCHAR2,
                        Pv_Status        OUT VARCHAR2,
                        Pv_Message       OUT VARCHAR2)
                        IS 
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Message:=apex_json.get_varchar2('mensaje');

      IF Pv_Status = '200'
      THEN 
        Pv_Token  :=apex_json.get_varchar2('token');
      END IF;

    END P_TOKEN;

    PROCEDURE P_ENVIO_CORREO(
                                Pv_To           VARCHAR2,
                                Pv_From         VARCHAR2,
                                Pv_Message      VARCHAR2,
                                Pv_SmtpHost     VARCHAR2,
                                Pv_Subject      VARCHAR2,
                                Pv_TextMsg      VARCHAR2,
                                Pv_AttachName   VARCHAR2,
                                Pv_AttachMime   VARCHAR2,
                                Pcl_ClobText    CLOB,
                                Pv_CopiaCorreo  VARCHAR2
                            )IS
    Lv_mail_conn    UTL_SMTP.connection;
    Lv_correoCC     VARCHAR2(1000);
    Lv_boundary     VARCHAR2(50) := '----=*#abc1234321cba#*=';
    Lv_step         PLS_INTEGER  := 30000;
    Ln_SmtpPort     NUMBER DEFAULT 25;
    Lv_MensajeError CLOB;
    Ln_variableIncr NUMBER;

    BEGIN
        Lv_mail_conn := UTL_SMTP.open_connection(Pv_SmtpHost, Ln_SmtpPort);
        UTL_SMTP.helo(Lv_mail_conn, Pv_SmtpHost);
        UTL_SMTP.mail(Lv_mail_conn, Pv_From);
        UTL_SMTP.rcpt(Lv_mail_conn, Pv_To);

        IF TRIM(Pv_CopiaCorreo) IS NOT NULL THEN
            Ln_variableIncr := 1;
            WHILE (Lv_CorreoCC IS NOT NULL OR Ln_variableIncr = 1) LOOP
                Lv_CorreoCC := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_CopiaCorreo ,',',Ln_variableIncr);
                IF Lv_CorreoCC IS NOT NULL THEN
                    UTL_SMTP.rcpt(Lv_mail_conn, TRIM(Lv_CorreoCC));
                END IF;
                Ln_variableIncr := Ln_variableIncr +1;
            END LOOP;
        END IF;
        UTL_SMTP.open_data(Lv_mail_conn);

        UTL_SMTP.write_data(Lv_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
        UTL_SMTP.write_data(Lv_mail_conn, 'To: ' || Pv_To|| UTL_TCP.crlf);
        IF TRIM(Pv_CopiaCorreo) IS NOT NULL THEN
            UTL_SMTP.write_data(Lv_mail_conn, 'CC: ' || REPLACE(Pv_CopiaCorreo, ',', ';') || UTL_TCP.crlf);
        END IF;
        UTL_SMTP.write_data(Lv_mail_conn, 'From: ' || Pv_From || UTL_TCP.crlf);
        UTL_SMTP.write_data(Lv_mail_conn, 'Subject: ' || Pv_Subject|| UTL_TCP.crlf);
        UTL_SMTP.write_data(Lv_mail_conn, 'Reply-To: ' || Pv_From || UTL_TCP.crlf);
        UTL_SMTP.write_data(Lv_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
        UTL_SMTP.write_data(Lv_mail_conn, 'Content-Type: multipart/mixed; boundary="' || Lv_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);

        IF Pv_TextMsg IS NOT NULL THEN
            UTL_SMTP.write_data(Lv_mail_conn, '--' || Lv_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(Lv_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);

            UTL_SMTP.write_data(Lv_mail_conn, Pv_TextMsg);
            UTL_SMTP.write_data(Lv_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        END IF;

        IF Pv_AttachName IS NOT NULL THEN
            UTL_SMTP.write_data(Lv_mail_conn, '--' || Lv_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(Lv_mail_conn, 'Content-Type: ' || Pv_AttachMime || '; name="' || Pv_AttachName || '"' || UTL_TCP.crlf);
            UTL_SMTP.write_data(Lv_mail_conn, 'Content-Disposition: attachment; filename="' || Pv_AttachName || '"' || UTL_TCP.crlf || UTL_TCP.crlf);

            FOR i IN 0 .. TRUNC((DBMS_LOB.getlength(Pcl_ClobText) - 1 )/Lv_step) LOOP
                UTL_SMTP.write_data(Lv_mail_conn, DBMS_LOB.substr(Pcl_ClobText, Lv_step, i * Lv_step + 1));
            END LOOP;

            UTL_SMTP.write_data(Lv_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        END IF;

        UTL_SMTP.write_data(Lv_mail_conn, '--' || Lv_boundary || '--' || UTL_TCP.crlf);
        UTL_SMTP.close_data(Lv_mail_conn);

        UTL_SMTP.quit(Lv_mail_conn);

    EXCEPTION
        WHEN OTHERS THEN
        Lv_MensajeError := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.insert_error('ECUCERT', 
                                            'SPKG_INCIDENCIA_ECUCERT.P_ENVIO_CORREO', 
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );  

    END P_ENVIO_CORREO;

    PROCEDURE P_RESPUESTA_CERT_VUL(Pv_Data          IN  VARCHAR2,
                                    Pn_NoTarea      IN INTEGER,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Vulnerable    OUT VARCHAR2
                                ) IS
    CURSOR C_DETALLE_TAREA(Cn_IdComunicacion INTEGER)
    IS 
        SELECT ICO.DETALLE_ID 
        FROM DB_COMUNICACION.INFO_COMUNICACION ICO
        WHERE ICO.ID_COMUNICACION = Cn_IdComunicacion;

    Ln_DetalleId            INTEGER;
    Lv_MensajeError         VARCHAR2(4000);
    Lv_MensajeVulnerabilidad VARCHAR2(4000);
    BEGIN
        apex_json.parse (Pv_Data);
        Pv_Status :=apex_json.get_varchar2('success');

        IF Pv_Status = 'true'
        THEN 
            Pv_Vulnerable            :=apex_json.get_varchar2('vulnerable');
            Lv_MensajeVulnerabilidad := apex_json.get_varchar2(p_path => 'msg');
        ELSE
            Lv_MensajeVulnerabilidad  := apex_json.get_varchar2(p_path => 'errors.msg',   p0 => 1);

        END IF;

        IF Pn_NoTarea IS NOT NULL THEN

            OPEN C_DETALLE_TAREA (Pn_NoTarea);
            FETCH C_DETALLE_TAREA INTO Ln_DetalleId;
            CLOSE C_DETALLE_TAREA;

            INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(ID_SEGUIMIENTO, DETALLE_ID, OBSERVACION, USR_CREACION, FE_CREACION) 
            VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Ln_DetalleId,'Validación Automática: '||Lv_MensajeVulnerabilidad,'telcos',SYSDATE);

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
        Lv_MensajeError := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.insert_error('ECUCERT', 
                                            'SPKG_INCIDENCIA_ECUCERT.P_RESPUESTA_CERT_VUL', 
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );  

    END P_RESPUESTA_CERT_VUL;     

    PROCEDURE P_IP_NETWORKING(Pv_Data          IN  VARCHAR2,
                                Pv_IpWAN        OUT VARCHAR2,
                                Pv_Jurisdiccion OUT VARCHAR2,
                                Pv_Vrf          OUT VARCHAR2,
                                Pv_Message      OUT VARCHAR2)
                                IS
    Pv_Status VARCHAR2(400);                           
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status     := APEX_JSON.get_varchar2(p_path => 'results.status');

      IF Pv_Status IS NOT NULL
      THEN 
        Pv_IpWAN        := APEX_JSON.get_varchar2(p_path => 'results.msg[%d].ipwan',   p0 => 1);
        Pv_Jurisdiccion := APEX_JSON.get_varchar2(p_path => 'results.msg[%d].jurisdiccion',   p0 => 1);
        Pv_Vrf          := APEX_JSON.get_varchar2(p_path => 'results.msg[%d].vrf',   p0 => 1);
      END IF;

    END P_IP_NETWORKING;

    PROCEDURE P_MASCARA_IP(Pv_SubRed        IN  VARCHAR2,
                            Pv_Mascara       IN  VARCHAR2,
                            Pv_IpValida      IN  VARCHAR2,
                            Pn_boolValida    OUT INTEGER,
                            Pv_Message       OUT VARCHAR2)
                            IS
    Ln_Resultado1       INTEGER := 1; 
    Ln_CountResultado1  INTEGER := 0; 
    Ln_Resultado2       INTEGER := 1; 
    Ln_CountResultado2  INTEGER := 0; 
    Ln_Resultado3       INTEGER := 1; 
    Ln_CountResultado3  INTEGER := 0; 
    Ln_Resultado4       INTEGER := 1; 
    Ln_CountResultado4  INTEGER := 0; 
    Ln_Tramo1           INTEGER;
    Ln_Tramo2           INTEGER;
    Ln_Tramo3           INTEGER;
    Ln_Tramo4           INTEGER;
    Ln_TramoIp1         INTEGER;
    Ln_TramoIp2         INTEGER;
    Ln_TramoIp3         INTEGER;
    Ln_TramoIp4         INTEGER;
    Ln_TramoSubRed1     INTEGER;
    Ln_TramoSubRed2     INTEGER;
    Ln_TramoSubRed3     INTEGER;
    Ln_TramoSubRed4     INTEGER;
    Ln_SubNet           INTEGER;
    Ln_NumeroIP         INTEGER;
    Lv_RangoInicio      VARCHAR2(800);
    Lv_RangoFin         VARCHAR2(800);
    BEGIN
        Ln_Tramo1       := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_Mascara ,'.',1);
        Ln_Tramo2       := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_Mascara ,'.',2);
        Ln_Tramo3       := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_Mascara ,'.',3);
        Ln_Tramo4       := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_Mascara ,'.',4);
        Ln_TramoSubRed1 := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_SubRed ,'.',1);
        Ln_TramoSubRed2 := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_SubRed ,'.',2);
        Ln_TramoSubRed3 := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_SubRed ,'.',3);
        Ln_TramoSubRed4 := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_SubRed ,'.',4),'/',1);
        Ln_TramoIp1     := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_IpValida ,'.',1);
        Ln_TramoIp2     := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_IpValida ,'.',2);
        Ln_TramoIp3     := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_IpValida ,'.',3);
        Ln_TramoIp4     := DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Pv_IpValida ,'.',4);
    WHILE Ln_Tramo1 > 0
    LOOP
        IF Ln_Tramo1 != 0
        THEN
            Ln_Resultado1          := MOD(Ln_Tramo1,2);
            Ln_Tramo1           := trunc(Ln_Tramo1/2,0);
            IF Ln_Resultado1 = 1
            THEN
                Ln_CountResultado1 := Ln_CountResultado1 + 1;
            END IF;
        END IF;
    END LOOP;

    WHILE Ln_Tramo2 > 0
    LOOP
        IF Ln_Tramo2 != 0
        THEN
            Ln_Resultado2       := MOD(Ln_Tramo2,2);
            Ln_Tramo2           := trunc(Ln_Tramo2/2,0);
            IF Ln_Resultado2 = 1
            THEN
                Ln_CountResultado2 := Ln_CountResultado2 + 1;
            END IF;
        END IF;
    END LOOP;

    WHILE Ln_Tramo3 > 0
    LOOP
        IF Ln_Tramo3 != 0
        THEN
            Ln_Resultado3          := MOD(Ln_Tramo3,2);
            Ln_Tramo3           := trunc(Ln_Tramo3/2,0);
            IF Ln_Resultado3 = 1
            THEN
                Ln_CountResultado3 := Ln_CountResultado3 + 1;
            END IF;
        END IF;
    END LOOP;

    WHILE Ln_Tramo4 > 0
    LOOP
        IF Ln_Tramo4 != 0
        THEN
            Ln_Resultado4          := MOD(Ln_Tramo4,2);
            Ln_Tramo4           := trunc(Ln_Tramo4/2,0);
            IF Ln_Resultado4 = 1
            THEN
                Ln_CountResultado4 := Ln_CountResultado4 + 1;
            END IF;
        END IF;
    END LOOP;

    Ln_SubNet   := 32 - (Ln_CountResultado1+Ln_CountResultado2+Ln_CountResultado3+Ln_CountResultado4);
    Ln_NumeroIP := POWER(2,Ln_SubNet);

    Lv_RangoFin    := Ln_TramoSubRed4 + Ln_NumeroIP-1;
    Lv_RangoInicio := Ln_TramoSubRed4;

    IF Ln_TramoIp4 >= Lv_RangoInicio AND Ln_TramoIp4 <= Lv_RangoFin AND Ln_TramoIp3 = Ln_TramoSubRed3 AND Ln_TramoIp2 = Ln_TramoSubRed2 AND Ln_TramoIp1 = Ln_TramoSubRed1
    THEN
        Pn_boolValida := 1;
    ELSE
        Pn_boolValida := 0;
    END IF;

    END P_MASCARA_IP;

    PROCEDURE P_BUSCAR_CLIENTE_NOT(Pv_IncidenciaDetNotObj  IN  INCIDENCIA_NOT_DETALLE_TYPE,
                                   Pv_tipoUsuario          IN VARCHAR2,
                                   Pn_CodigoEmpresaTicket  IN NUMBER,
                                   Pv_Message              OUT VARCHAR2)
                            IS
    CURSOR C_CLIENTES_POR_IP(Cv_EstadoActivo VARCHAR2,Cv_EstadoActiva VARCHAR2,Cv_EstadoInCorte VARCHAR2,Cv_EstadoReservada VARCHAR2,Cv_ip VARCHAR2,Cv_EstadoEliminado VARCHAR2,Cv_EstadoCancelado VARCHAR2,Cv_EstadoCancel VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
            IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
            FROM DB_INFRAESTRUCTURA.INFO_IP IP 
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IP.SERVICIO_ID=ISE.ID_SERVICIO
            INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
            INNER JOIN DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
            INNER JOIN DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
            WHERE IP.ESTADO IN (Cv_EstadoActivo,Cv_EstadoActiva,Cv_EstadoInCorte,Cv_EstadoReservada) AND IP.IP=Cv_ip AND IPO.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel)
                  AND IPER.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel)
            ORDER BY IP.IP desc;

    CURSOR C_CLIENTES_POR_SERVICIO(Cn_ServicioId INTEGER,Cv_EstadoEliminado VARCHAR2,Cv_EstadoCancelado VARCHAR2,Cv_EstadoCancel VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
            IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ISE 
            INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
            INNER JOIN  DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
            INNER JOIN  DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
            WHERE IPO.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel) AND IPER.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel) AND ISE.ID_SERVICIO = Cn_ServicioId;

    CURSOR C_RUTA_IP
    IS 
    SELECT IRE.RED_LAN,IRE.MASCARA_RED_LAN,IRE.SERVICIO_ID 
    FROM DB_INFRAESTRUCTURA.INFO_RUTA_ELEMENTO IRE
    WHERE IRE.ESTADO != 'Eliminado';

    CURSOR C_DETALLE_TAREA(Cn_IdComunicacion INTEGER)
    IS 
    SELECT ICO.DETALLE_ID 
    FROM DB_COMUNICACION.INFO_COMUNICACION ICO
    WHERE ICO.ID_COMUNICACION = Cn_IdComunicacion;

    CURSOR C_RUTA_SUBRED(Cv_ip VARCHAR2, Cv_Eliminado VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
        IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
        FROM DB_INFRAESTRUCTURA.INFO_SUBRED  ISU
        INNER JOIN DB_INFRAESTRUCTURA.info_ruta_elemento IRE on IRE.SUBRED_ID=ISU.ID_SUBRED
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IRE.SERVICIO_ID=ISE.ID_SERVICIO 
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
        INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
        INNER JOIN DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
        INNER JOIN DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
        INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
        WHERE (ISU.GATEWAY = Cv_ip OR Cv_ip = (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.SUBRED,'/',1)) OR 
        DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',1)        = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',1) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',2)    = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',2) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',3)    = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',3)
        AND TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',4)) >= TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',4)) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',1)      = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',1) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',2)      = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',2) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',3)      = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',3)
        AND TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',4)) <=  TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',4)))
        AND ISU.ESTADO != Cv_Eliminado AND IRE.ESTADO != Cv_Eliminado AND ISU.SUBRED IS NOT NULL;

    CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
    IS
      SELECT APD.VALOR1,APD.VALOR2,
              APD.VALOR3,APD.VALOR4,APD.VALOR5,VALOR6,VALOR7,OBSERVACION
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.descripcion = Cv_DescripcionParametro;

    CURSOR C_GET_PARAMETROS_PLAN(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2,Cv_Categoria VARCHAR2,Cv_SubCategoria VARCHAR2,Cv_TipoEvento VARCHAR2,Cn_CodEmpresa VARCHAR2)
    IS
      SELECT APD.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.DESCRIPCION = Cv_DescripcionParametro AND APD.VALOR1 = UPPER(Cv_Categoria) AND NVL(APD.VALOR2,'N')= UPPER(NVL(Cv_SubCategoria,'N')) AND APD.VALOR3 = UPPER(Cv_TipoEvento) AND  APD.EMPRESA_COD = Cn_CodEmpresa;

    CURSOR C_CLIENTES_POR_LOGIN(Cv_estadoServicio VARCHAR2,Cv_login VARCHAR2, Cv_EstadoEliminado VARCHAR2,Cv_EstadoCancelado VARCHAR2,Cv_EstadoCancel VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
            IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
            FROM DB_COMERCIAL.INFO_PUNTO IPO
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IPO.ID_PUNTO=ISE.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
            INNER JOIN DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
            INNER JOIN DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
            WHERE IPO.LOGIN=Cv_login AND IPO.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel) AND ISE.ESTADO NOT IN (Cv_estadoServicio)
                  AND IPER.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel);

    CURSOR C_JEFE_REGION_CARGO(Cv_codEmpresa VARCHAR2,Cv_region VARCHAR2,
            Cv_nomDepart VARCHAR2,Cv_descripcionRol VARCHAR2,Cv_EstadoPersona VARCHAR2)
    IS
    SELECT IPER.ID_PERSONA_ROL
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_DEPARTAMENTO ADE ON ade.id_departamento=IPER.DEPARTAMENTO_ID
            INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IPER.OFICINA_ID
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=IOG.CANTON_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            WHERE ADE.EMPRESA_COD=Cv_codEmpresa AND UPPER(ACO.JURISDICCION)=UPPER(Cv_region) AND UPPER(ADE.NOMBRE_DEPARTAMENTO)=UPPER(Cv_nomDepart)
            AND UPPER(AR.DESCRIPCION_ROL) like Cv_DescripcionRol AND AR.ES_JEFE='S' 
            AND IPER.ESTADO=Cv_EstadoPersona AND ROWNUM=1;

    CURSOR C_JEFE_REGION_SIN_DESCRIP(Cv_codEmpresa VARCHAR2,Cv_region VARCHAR2,
            Cv_nomDepart VARCHAR2,Cv_EstadoPersona VARCHAR2)
    IS
    SELECT IPER.ID_PERSONA_ROL
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_DEPARTAMENTO ADE ON ade.id_departamento=IPER.DEPARTAMENTO_ID
            INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IPER.OFICINA_ID
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=IOG.CANTON_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            WHERE ADE.EMPRESA_COD=Cv_codEmpresa AND UPPER(ACO.JURISDICCION)=UPPER(Cv_region) AND UPPER(ADE.NOMBRE_DEPARTAMENTO)=UPPER(Cv_nomDepart)
            AND AR.ES_JEFE='S' 
            AND IPER.ESTADO=Cv_EstadoPersona AND ROWNUM=1;

    CURSOR C_CASO_ID(Cv_NoCaso VARCHAR2)
    IS
    SELECT IC.ID_CASO
            FROM DB_SOPORTE.INFO_CASO IC
            WHERE IC.NUMERO_CASO = Cv_NoCaso;

    CURSOR C_NOMBRE_CLIENTE(Cn_PersonaEmpresaRol INTEGER)
    IS
    SELECT 
    regexp_replace(UPPER(UTL_RAW.CAST_TO_VARCHAR2((nlssort(T1.NOMBRE_CLIENTE, 'nls_sort=binary_ai')))), '(^[[:cntrl:]^\t]+)|([[:cntrl:]^\t]+$)',null)  AS NOMBRE_CLIENTE
    FROM
    (
        SELECT (CASE WHEN IPE.NOMBRES IS NULL AND IPE.APELLIDOS IS NULL THEN IPE.RAZON_SOCIAL ELSE IPE.NOMBRES || IPE.APELLIDOS END) AS NOMBRE_CLIENTE
                FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                INNER JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPER.PERSONA_ID=IPE.ID_PERSONA
                WHERE IPER.ID_PERSONA_ROL = Cn_PersonaEmpresaRol) T1;

    CURSOR C_ESTADO_IP(Cv_ip VARCHAR2)
    IS 
    SELECT MAX(IP.ID_IP) AS ID_IP,IP.ESTADO
            FROM DB_INFRAESTRUCTURA.INFO_IP IP 
            WHERE IP.IP=Cv_ip 
            GROUP BY IP.ESTADO;

    CURSOR C_CANTON(Cv_Canton VARCHAR2)
    IS 
    SELECT ACA.JURISDICCION
            FROM DB_GENERAL.ADMI_CANTON ACA
            WHERE ACA.NOMBRE_CANTON=Cv_Canton;

    CURSOR C_ID_TAREA(Cv_NombreTarea VARCHAR2, Cn_IdProceso INTEGER)
    IS 
    SELECT ATA.ID_TAREA
            FROM DB_SOPORTE.ADMI_TAREA ATA
            WHERE ATA.NOMBRE_TAREA=Cv_NombreTarea AND PROCESO_ID =Cn_IdProceso AND ESTADO='Activo';

    CURSOR C_ID_PROCESO(Cv_NombreProceso VARCHAR2)
    IS 
    SELECT APO.ID_PROCESO
            FROM DB_SOPORTE.ADMI_PROCESO APO
            WHERE APO.NOMBRE_PROCESO=Cv_NombreProceso  AND ESTADO='Activo';

    CURSOR C_IP_BGP(Cv_ip VARCHAR2)
    IS 
    SELECT
        ISPC.SERVICIO_ID
        FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC 
        WHERE 
        ISPC.ESTADO NOT IN ('Cancel','Eliminado','Cancelado') AND 
        ISPC.PRODUCTO_CARACTERISITICA_ID=6778 AND
        (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',1)) = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',1) AND
        (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',2)) = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',2) AND
        (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',3)) = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',3) AND
        TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',4)) <= TO_NUMBER((DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',4)
        +(POWER(2,32-DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',2),'/',2))-1))) AND
        TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',4)) >= TO_NUMBER((DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',4)));

    CURSOR C_ES_CPE(Cv_ip VARCHAR2) 
    IS
    SELECT VSCPE.LOGIN 
    FROM
    (SELECT OFICINA.NOMBRE_OFICINA,
          NVL( PERSONA.RAZON_SOCIAL, CONCAT( PERSONA.NOMBRES, CONCAT(' ', PERSONA.APELLIDOS) ) ) AS CLIENTE,
          PUNTO.LOGIN,
          CANTON.REGION,
          JURISDICCION.NOMBRE_JURISDICCION AS OFICINA_COBERTURA,
          INFO_TECNICA_SERVICIO.IP         AS IP_INTERFACE,
          ELEMENTO.NOMBRE_ELEMENTO         AS NOMBRE_CPE,
          PRODUCTO.DESCRIPCION_PRODUCTO    AS MECANISMO,
          DETALLE_ELEMENTO.DETALLE_VALOR AS DESCRIPCION_ADMINISTRACION,
          INFO_TECNICA_SERVICIO.FE_CREACION AS FECHA_ACTIVACION,
          SERVICIO.ID_SERVICIO,
          SERVICIO.ESTADO AS ESTADO_SERVICIO,
          INFO_TECNICA_SERVICIO.ULTIMA_MILLA_ID,
          INFO_TECNICA_SERVICIO.CPE_DIRECTO,
          ROL_CLIENTE.DESCRIPCION_ROL,
          PERSONA.TIPO_IDENTIFICACION,
          PERSONA.IDENTIFICACION_CLIENTE,
          INFO_CONTACTO.CONTACTO_CLIENTE,
          INFO_CONTACTO.VALOR_CONTACTO_CLIENTE,
          INFO_CONTACTO.TIPO_CONTACTO,
          INFO_CONTACTO.FORMA_CONTACTO
        FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
        ON PUNTO.ID_PUNTO = SERVICIO.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
        ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER_CLIENTE
        ON IER_CLIENTE.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
        INNER JOIN DB_GENERAL.ADMI_ROL ROL_CLIENTE
        ON ROL_CLIENTE.ID_ROL = IER_CLIENTE.ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA
        ON OFICINA.ID_OFICINA = PER.OFICINA_ID
        INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
        ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
        INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
        ON CANTON.ID_CANTON = OFICINA.CANTON_ID
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
        ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
        ON PERSONA.ID_PERSONA = PER.PERSONA_ID
        INNER JOIN
          (SELECT INFO_SERVICIO_IP_ENLACE.SERVICIO_ID,
            INFO_SERVICIO_IP_ENLACE.ID_IP,
            INFO_SERVICIO_IP_ENLACE.IP,
            INFO_SERVICIO_IP_ENLACE.INTERFACE_ELEMENTO_CLIENTE_ID,
            INFO_SERVICIO_IP_ENLACE.ULTIMA_MILLA_ID,
            INFO_SERVICIO_IP_ENLACE.ELEMENTO_CLIENTE_ID,
            INFO_SERVICIO_IP_ENLACE.FE_CREACION,
            (
            CASE
              WHEN (INFO_SERVICIO_IP_ENLACE.CANTIDAD_ENLACES = 0)
              THEN INFO_SERVICIO_IP_ENLACE.ELEMENTO_CLIENTE_ID
              ELSE DB_COMERCIAL.COMEK_CONSULTAS.F_GET_ID_ELEMENTO_PRINCIPAL(INFO_SERVICIO_IP_ENLACE.INTERFACE_ELEMENTO_CLIENTE_ID,'CPE')
            END) AS ID_CPE,
        (
            CASE
              WHEN (INFO_SERVICIO_IP_ENLACE.CANTIDAD_ENLACES = 0)
              THEN 'SI'
              ELSE 'NO'
            END) AS CPE_DIRECTO
          FROM
            (SELECT SERVICIO_TECNICO.SERVICIO_ID,
              IP.ID_IP,
              IP.IP,
              SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID,
              SERVICIO_TECNICO.ULTIMA_MILLA_ID,
              SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID,
              IP.FE_CREACION,
              COUNT(ENLACE.ID_ENLACE) AS CANTIDAD_ENLACES
            FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO UM
            ON UM.ID_TIPO_MEDIO = SERVICIO_TECNICO.ULTIMA_MILLA_ID
            INNER JOIN DB_INFRAESTRUCTURA.INFO_IP IP
            ON IP.SERVICIO_ID = SERVICIO_TECNICO.SERVICIO_ID
            LEFT JOIN DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
            ON ENLACE.INTERFACE_ELEMENTO_INI_ID = SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID
            WHERE UM.CODIGO_TIPO_MEDIO         IN ('FO','RAD','UTP')
            AND IP.ESTADO = 'Activo'
            GROUP BY (SERVICIO_TECNICO.SERVICIO_ID, IP.ID_IP, IP.IP, SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID, 
                      SERVICIO_TECNICO.ULTIMA_MILLA_ID, SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID, IP.FE_CREACION)
            ) INFO_SERVICIO_IP_ENLACE
          ) INFO_TECNICA_SERVICIO ON INFO_TECNICA_SERVICIO.SERVICIO_ID = SERVICIO.ID_SERVICIO
        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
        ON ELEMENTO.ID_ELEMENTO = INFO_TECNICA_SERVICIO.ID_CPE
        INNER JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_ELEMENTO
        ON DETALLE_ELEMENTO.ELEMENTO_ID = ELEMENTO.ID_ELEMENTO 
        LEFT JOIN
          (SELECT PUNTO_CONTACTO.PUNTO_ID,
            PUNTO_CONTACTO.ID_PUNTO_CONTACTO,
            NVL( PERSONA_CONTACTO.RAZON_SOCIAL, CONCAT( PERSONA_CONTACTO.NOMBRES, CONCAT(' ', PERSONA_CONTACTO.APELLIDOS) ) ) AS CONTACTO_CLIENTE,
            PERSONA_F_CONTACTO.VALOR                                                                                          AS VALOR_CONTACTO_CLIENTE,
            ROL_CONTACTO.DESCRIPCION_ROL                                                                                      AS TIPO_CONTACTO,
            FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO                                                                         AS FORMA_CONTACTO
          FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO PUNTO_CONTACTO
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO PERSONA_F_CONTACTO
          ON PERSONA_F_CONTACTO.PERSONA_ID = PUNTO_CONTACTO.CONTACTO_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA_CONTACTO
          ON PERSONA_CONTACTO.ID_PERSONA = PERSONA_F_CONTACTO.PERSONA_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER_CONTACTO
          ON PER_CONTACTO.ID_PERSONA_ROL = PUNTO_CONTACTO.PERSONA_EMPRESA_ROL_ID
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER
          ON IER.ID_EMPRESA_ROL = PER_CONTACTO.EMPRESA_ROL_ID
          INNER JOIN DB_GENERAL.ADMI_ROL ROL_CONTACTO
          ON ROL_CONTACTO.ID_ROL = IER.ROL_ID
          INNER JOIN DB_GENERAL.ADMI_TIPO_ROL TIPO_ROL_CONTACTO
          ON TIPO_ROL_CONTACTO.ID_TIPO_ROL = ROL_CONTACTO.TIPO_ROL_ID
          INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
          ON FORMA_CONTACTO.ID_FORMA_CONTACTO            = PERSONA_F_CONTACTO.FORMA_CONTACTO_ID
          WHERE PUNTO_CONTACTO.ESTADO                    = 'Activo'
          AND PERSONA_F_CONTACTO.ESTADO                  = 'Activo'
          AND ROL_CONTACTO.DESCRIPCION_ROL               = 'Contacto Tecnico'
          AND TIPO_ROL_CONTACTO.DESCRIPCION_TIPO_ROL     = 'Contacto'
          AND FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO IN ('Correo Electronico', 'Telefono Fijo', 'Telefono Movil', 'Telefono Movil Claro', 
                                                            'Telefono Movil Movistar', 'Telefono Movil CNT')
          AND FORMA_CONTACTO.ESTADO                      = 'Activo'
          ) INFO_CONTACTO ON INFO_CONTACTO.PUNTO_ID      = PUNTO.ID_PUNTO
        WHERE SERVICIO.ESTADO                           IN ('Activo','In-Corte','EnPruebas')
        AND PRODUCTO.EMPRESA_COD                         = '10'
        AND DETALLE_ELEMENTO.ESTADO = 'Activo'
        AND DETALLE_NOMBRE = 'ADMINISTRA') VSCPE
        WHERE VSCPE.IP_INTERFACE=Cv_ip
        GROUP BY VSCPE.LOGIN;

    Lr_InfoClienteIp        C_CLIENTES_POR_IP%ROWTYPE;
    Lr_InfoClienteSubRed    C_RUTA_SUBRED%ROWTYPE;
    Lr_InfoClienteRDA       C_CLIENTES_POR_LOGIN%ROWTYPE;
    Lr_InfoClienteCPE       C_CLIENTES_POR_LOGIN%ROWTYPE;
    Lr_InfoClienteIpWAN     C_CLIENTES_POR_LOGIN%ROWTYPE;
    Lr_InfoParamTarea       C_GET_PARAMETROS%ROWTYPE;

    Lv_IdPersonaRol     VARCHAR2(200);
    Lv_Login            VARCHAR2(400);
    Ln_CodEmpresa       INTEGER;
    Lv_Region           VARCHAR2(400);
    Lv_IdPunto          VARCHAR2(400);
    Ln_IdServicio       INTEGER;

    Lv_NombreSintoma    VARCHAR2(400);
    Lv_TituloInicial    VARCHAR2(400);
    Lv_VersionInicial   VARCHAR2(400);
    Lv_NombreHipotesis  VARCHAR2(400);
    Lv_NombreTarea      VARCHAR2(400);
    Lv_MotivoTarea      VARCHAR2(400);
    Lv_Observacion      VARCHAR2(400);
    Lv_NombreProceso    VARCHAR2(400);

    Ln_NoTarea          INTEGER;
    Lv_NoCaso           VARCHAR2(4000);
    Lv_CasoId           VARCHAR2(4000);
    Lv_EtiquetaCaso     VARCHAR2(4000);

    Lv_EstadoPersona    VARCHAR2(400):= 'Activo';
    Lv_EstadoActivo     VARCHAR2(400):= 'Activo';
    Lv_AutoAsig         VARCHAR2(3):=   'NO';
    Lv_Cuadrilla        VARCHAR2(4);
    Lv_TipoBackbone     VARCHAR2(5);
    Lv_NivelCriticidad  VARCHAR2(5):=   'Alto';

    Ln_IdIpNP           INTEGER;
    Lv_EstadoIpNP       VARCHAR2(100);
    Lv_SubEstado        VARCHAR2(100);

    Lv_DescFormContact  VARCHAR2(400);
    Lv_Contacto         VARCHAR2(400);
    Lv_FormaContacto    VARCHAR2(400);
    Lv_Asunto           VARCHAR2(400);

    Lv_NombreParametro  VARCHAR2(400) := 'PARAMETROS_ECUCERT';
    Lv_DescripParametro VARCHAR2(400);

    Lv_Jurisdiccion     VARCHAR2(400);
    Lv_Vrf              VARCHAR2(400);            
    Lv_IpWAN            VARCHAR2(400);
    Ln_IpValida         INTEGER;
    Lv_IpRed            VARCHAR2(800);
    Lv_MascaraRed       VARCHAR2(800);

    Lv_DescripcionRol   VARCHAR2(400);
	Lv_DescripJefe      VARCHAR2(400) :='%JEFE%';
    Lv_TipoAsig         VARCHAR2(400);
    Lv_TipoCaso         VARCHAR2(400);
    Lv_TipoAfectacion   VARCHAR2(400);
    Lv_Departamento     VARCHAR2(400);
    Lv_PrefijoEmpre     VARCHAR2(400);
    Ln_JefeSucursalId   INTEGER;

    Lcl_JsonNotificacion CLOB;
    Lcl_JsonCliente      CLOB;
    Lcl_JsonCGNAT        CLOB;
    Lcl_JsonSg           CLOB;
    Lcl_JsonCsoc         CLOB;
    Lcl_JsonToken        CLOB;
    Lcl_JsonNetworking   CLOB;
    Lcl_JsonCasos        CLOB;
    Lcl_JsonTarea        CLOB;

    Lcl_SintomasA        CLOB;
    Lcl_HipotesisA       CLOB;
    Lcl_TareaA           CLOB;

    Lcl_MensajeError    CLOB;
    Lv_Status           VARCHAR2(400);

    Lv_URLTenico            VARCHAR2(800);
    Lv_URLSoporte           VARCHAR2(800);
    Lv_URLCERT              VARCHAR2(800);
    Lv_URLRDA               VARCHAR2(800);
    Lv_URLCGNAT             VARCHAR2(800);
    Lv_URLToken             VARCHAR2(800);
    Lv_URLCERTCsoc          VARCHAR2(800);
    Lv_URLCERTSg            VARCHAR2(800);
    Lv_URLNetworking        VARCHAR2(800);
    Lv_LoginRDA             VARCHAR2(400);
    Ln_ClieCsoc             INTEGER := 0;
    Ln_ClieSg               INTEGER := 0;
    Lv_Token                VARCHAR2(800);

    Lv_RespuestaCaso    VARCHAR2(4000);
    Lv_RespuestaNotif   VARCHAR2(4000);
    Lv_RespuestaRDACl   VARCHAR2(4000);
    Lv_RespuestaCGNAT   VARCHAR2(4000);
    Lv_RespuestaCsoc    VARCHAR2(4000);
    Lv_RespuestaSg      VARCHAR2(4000);
    Lv_RespuestaNetW    VARCHAR2(4000);
    Lv_RespuestaToken   VARCHAR2(4000);

    Lv_EstadoEliminado  VARCHAR2(400) := 'Eliminado';
    Lv_EstadoCancelado  VARCHAR2(400) := 'Cancelado';
    Lv_EstadoCancel     VARCHAR2(400) := 'Cancel';

    Lv_EstadoActiva     VARCHAR2(400) := 'Activa';
    Lv_EstadoInCorte    VARCHAR2(400) := 'In-Corte';
    Lv_EstadoReservada  VARCHAR2(400) := 'Reservada';
    Lv_EstadoServicio   VARCHAR2(400) := 'Anulado';

    Lv_fechaRDA         VARCHAR2(400);
    Lv_horaRDA          VARCHAR2(400);
    Lv_fechaCGNAT       VARCHAR2(400);
    Lv_horaCGNAT        VARCHAR2(400);
    Ln_DetalleId        INTEGER;

    Lv_EstadoAnalisis   VARCHAR2(400);
    Lv_EstadoNotif      VARCHAR2(400);
    Lv_EstadoNotifFallo VARCHAR2(400);

    Lv_InfoParamPlanti  VARCHAR2(100);
    Lv_NombreParamPlan  VARCHAR2(100):='PLANTILLAS DE NOTIFICACIONES';
    Lv_DescripParamPlan VARCHAR2(100):='CODIGO DE PLANTILLA ECUCERT';

    Lv_LoginCPE         VARCHAR2(400);
    Ln_EsCPE            INTEGER := 0;
    Lv_Message          VARCHAR2(800);
    Pn_IncidenciaDetActId   INCIDENCIA_ACT_DETALLE_TYPE;

    Lv_EstadoActual     VARCHAR2(800):='Asignada';
    Lv_TipoReprograma   VARCHAR2(800):='C';
    Ln_tiempoMinutos    INTEGER:=0;

    Lv_AsignacionJefeTN1    VARCHAR2(800);
    Lv_AsignacionJefeTN2    VARCHAR2(800);
    Lv_AsignacionJefeMD     VARCHAR2(800);

    Ln_ServicioIdBGP        INTEGER;
    Ln_NombresCliente       VARCHAR2(1000);
    Lv_ProcesoNoEncTelco    VARCHAR2(1000);
    Lv_TareaNoEncTelco      VARCHAR2(1000);
    Lv_ProcesoSG            VARCHAR2(1000);
    Lv_TareaSG              VARCHAR2(1000);
    Lv_ProcesoInfraes       VARCHAR2(1000);
    Lv_TareaInfraes         VARCHAR2(1000);
    Lv_ProcesoIPCPE         VARCHAR2(1000);
    Lv_TareaIPCPE           VARCHAR2(1000);
    Lv_ProcesoCSOC          VARCHAR2(1000);
    Lv_TareaCSOC            VARCHAR2(1000);
    Lv_TareaRegNoEcontrado  VARCHAR2(1000);
    Lv_TareaRegMegadatos    VARCHAR2(1000);
    Lv_ProcesoNoEncMega     VARCHAR2(1000);

    Ln_bandCGNAT            INTEGER :=0;         
    Ln_BandRDA              INTEGER :=0;
    Lv_ipAddressBusqCGNAT   VARCHAR2(800);
    Lv_ProcesoInterno       VARCHAR2(800) := '%INTERNO%';
    Lv_NombrePrestador      VARCHAR2(4000);

    Ln_idCaso               INTEGER :=0;   
    Ln_idCasoHistorial      INTEGER :=0;
    Ln_idComunicacion       INTEGER :=0;
    Ln_idDocumento          INTEGER :=0;
    Ln_idDocuComunicacion   INTEGER :=0;
    Ln_idDetalleHipotesis   INTEGER :=0;
    Ln_idDetalle            INTEGER :=0;
    Ln_idParteAfectada      INTEGER :=0;
    Ln_idCriterioAfectado   INTEGER :=0;

    Ln_idComunicacionTarea  INTEGER :=NULL;
    Ln_idDetalleTarea       INTEGER :=0;

    Ln_idDetalleCaAsig      INTEGER :=0;
    Ln_idComunicacionCaSig  INTEGER :=0;
    Ln_idCasoHistorialAsig  INTEGER :=0;
    Ln_idCasoAsignacion     INTEGER :=0;
    Ln_idCasoDocumentoAsig  INTEGER :=0;
    Ln_idDocuComunicaAsig   INTEGER :=0;

    Ln_idTareaDocumentoAsig INTEGER :=0;
    Ln_idDocuComuAsigTarea  INTEGER :=0;
    Ln_idDetalleAsigTarea   INTEGER :=0;
    Ln_idDetalleHistTarea   INTEGER :=0;
    Ln_idTareaSeguiTarea    INTEGER :=0;

    Ln_idTarea              INTEGER :=0;
    Ln_idProceso            INTEGER :=0;

    Pv_CasoEcucertObj       CREAR_CASO_ECUCERT_TYPE;


    BEGIN

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_NombreSintoma   := Lr_InfoParamTarea.VALOR1;
        Lv_TituloInicial   := Lr_InfoParamTarea.VALOR1;
        Lv_VersionInicial  := Lr_InfoParamTarea.VALOR1;
        Lv_NombreHipotesis := Lr_InfoParamTarea.VALOR2;
        Lv_NombreTarea     := Lr_InfoParamTarea.VALOR3;
        Lv_MotivoTarea     := Lr_InfoParamTarea.VALOR3;
        Lv_Observacion     := Lr_InfoParamTarea.VALOR3;
        Lv_NombreProceso   := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'PARAMETROS PARA ASIG TAREA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_TipoAsig         := Lr_InfoParamTarea.VALOR2;
        Lv_TipoCaso         := Lr_InfoParamTarea.VALOR3;
        Lv_TipoAfectacion   := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'PARAMETROS PARA ENVIAR CORREO';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_DescFormContact  := Lr_InfoParamTarea.VALOR1;
        Lv_Contacto         := Lr_InfoParamTarea.VALOR2;
        Lv_FormaContacto    := Lr_InfoParamTarea.VALOR3;
        Lv_Asunto           := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'URL ECUCERT';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_URLTenico        := Lr_InfoParamTarea.VALOR1;
        Lv_URLSoporte       := Lr_InfoParamTarea.VALOR2;
        Lv_URLCERT          := Lr_InfoParamTarea.VALOR3;
        Lv_URLRDA           := Lr_InfoParamTarea.VALOR4;
        Lv_URLToken         := Lr_InfoParamTarea.VALOR5;
        Lv_URLNetworking    := Lr_InfoParamTarea.VALOR6;
        Lv_URLCERTCsoc      := Lr_InfoParamTarea.VALOR7;
        Lv_URLCERTSg        := Lr_InfoParamTarea.OBSERVACION;

        Lv_DescripParametro := 'URL ECUCERT 2';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_URLCGNAT         := Lr_InfoParamTarea.VALOR1;

        Lv_DescripParametro := 'PARAMETROS PARA ESTADO INCIDENCIA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_EstadoAnalisis   := Lr_InfoParamTarea.VALOR3;
        Lv_EstadoNotif      := Lr_InfoParamTarea.VALOR4;
        Lv_EstadoNotifFallo := 'No '||Lv_EstadoNotif;

        Lv_DescripParametro := 'PARAMETROS_CASOS_SLA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_EstadoActual     := Lr_InfoParamTarea.VALOR1;  
        Lv_TipoReprograma   := Lr_InfoParamTarea.VALOR2;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA 2';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_ProcesoNoEncTelco    := Lr_InfoParamTarea.VALOR1;
        Lv_TareaNoEncTelco      := Lr_InfoParamTarea.VALOR2;
        Lv_ProcesoSG            := Lr_InfoParamTarea.VALOR3;
        Lv_TareaSG              := Lr_InfoParamTarea.VALOR4;
        Lv_ProcesoIPCPE         := Lr_InfoParamTarea.VALOR5;
        Lv_TareaIPCPE           := Lr_InfoParamTarea.VALOR6;
        Lv_ProcesoCSOC          := Lr_InfoParamTarea.VALOR7;
        Lv_TareaCSOC            := Lr_InfoParamTarea.OBSERVACION;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA 3';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_TareaRegNoEcontrado    := Lr_InfoParamTarea.VALOR1;
        Lv_TareaRegMegadatos      := Lr_InfoParamTarea.VALOR2;
        Lv_ProcesoInfraes         := Lr_InfoParamTarea.VALOR3;
        Lv_TareaInfraes           := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA MEGADATOS';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_ProcesoNoEncMega   := Lr_InfoParamTarea.VALOR2;

        Lv_DescripParametro := 'PARAMETROS_ASIGNACION_ECUCERT';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_AsignacionJefeTN2   := Lr_InfoParamTarea.VALOR1;
        Lv_AsignacionJefeTN1   := Lr_InfoParamTarea.VALOR2;
        Lv_AsignacionJefeMD    := Lr_InfoParamTarea.VALOR3;

        Ln_ClieSg           := 0;
        Ln_ClieCsoc         := 0;
        Ln_IpValida         := 0;
        Lr_InfoClienteIp    := NULL;
        Lr_InfoClienteSubRed:= NULL;
        Lr_InfoClienteRDA   := NULL;
        Lr_InfoClienteCPE   := NULL;
        Lr_InfoClienteIpWAN := NULL;
        Lv_NoCaso           := NULL;
        Lv_EstadoIpNP       := NULL;
        Lv_IpWAN            := NULL;
        Lv_Jurisdiccion     := NULL;
        Lv_Vrf              := NULL;
        Lv_LoginCPE         := NULL;

        IF Pn_CodigoEmpresaTicket = 10 THEN
          Lv_NombrePrestador  :='TELCONET';
        ELSE
          Lv_NombrePrestador  :='NETLIFE';
        END IF;

        IF UPPER(Pv_IncidenciaDetNotObj.Pv_noTicket) LIKE Lv_ProcesoInterno THEN 
          Lv_Asunto:= 'TLP-AMBAR ' || Lv_NombrePrestador || ' :NOTIFICACION DE ';
        END IF;

        Lv_ipAddressBusqCGNAT := Pv_IncidenciaDetNotObj.Pv_ipAddress;

        Lcl_JsonToken    := '
            {
              "source": {
                "name": "APP.CERT",
                "originID": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'",
                "tipoOriginID": "IP"
                        },
              "user": "CERT",
              "gateway": "Authentication",
              "service": "Authentication",
              "method": "Authentication"
            }';

        Ln_CodEmpresa   := Pn_CodigoEmpresaTicket;

        IF Pn_CodigoEmpresaTicket = 10 THEN
            IF Pv_IncidenciaDetNotObj.Pv_BandCPE = 'S'
            THEN
                OPEN C_ES_CPE (Pv_IncidenciaDetNotObj.Pv_ipAddress);
                FETCH C_ES_CPE INTO Lv_LoginCPE;
                CLOSE C_ES_CPE;

                IF Lv_LoginCPE IS NOT NULL
                THEN
                    Ln_EsCPE := 1;
                    OPEN C_CLIENTES_POR_LOGIN (Lv_EstadoServicio,Lv_LoginCPE,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                    FETCH C_CLIENTES_POR_LOGIN INTO Lr_InfoClienteCPE;
                    CLOSE C_CLIENTES_POR_LOGIN;

                    IF Lr_InfoClienteCPE.ID_PERSONA_ROL IS NOT NULL
                        THEN
                        Lv_IdPersonaRol     := Lr_InfoClienteCPE.ID_PERSONA_ROL;
                        Lv_DescripcionRol   := Lr_InfoClienteCPE.DESCRIPCION_ROL;
                        Lv_Login            := Lr_InfoClienteCPE.LOGIN;
                        Ln_CodEmpresa       := Lr_InfoClienteCPE.COD_EMPRESA;
                        Lv_Region           := Lr_InfoClienteCPE.REGION;
                        Lv_IdPunto          := Lr_InfoClienteCPE.ID_PUNTO;
                        Ln_IdServicio       := Lr_InfoClienteCPE.ID_SERVICIO;
                    END IF;
                END IF;
            END IF; 
        ELSE
            IF Pv_IncidenciaDetNotObj.Pv_BandRDA = 'S' THEN
                Ln_BandRDA      := 1;
            END IF;
        END IF;

        IF Lv_LoginCPE IS NULL
        THEN
            OPEN C_CLIENTES_POR_IP (Lv_EstadoActivo,Lv_EstadoActiva,Lv_EstadoInCorte,Lv_EstadoReservada,Pv_IncidenciaDetNotObj.Pv_ipAddress,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
            FETCH C_CLIENTES_POR_IP INTO Lr_InfoClienteIp;
            CLOSE C_CLIENTES_POR_IP;

            Lv_IdPersonaRol     := Lr_InfoClienteIp.ID_PERSONA_ROL;
            Lv_DescripcionRol   := Lr_InfoClienteIp.DESCRIPCION_ROL;
            Lv_Login            := Lr_InfoClienteIp.LOGIN;
            Ln_CodEmpresa       := Lr_InfoClienteIp.COD_EMPRESA;
            Lv_Region           := Lr_InfoClienteIp.REGION;
            Lv_IdPunto          := Lr_InfoClienteIp.ID_PUNTO;
            Ln_IdServicio       := Lr_InfoClienteIp.ID_SERVICIO;

            IF (Lv_IdPersonaRol IS NULL)
            THEN
                FOR i IN C_RUTA_IP
                LOOP
                    Lv_IpRed        := regexp_replace(TRIM(i.RED_LAN), '(^[[:space:]]+)|([[:space:]]+$)',null);
                    Lv_MascaraRed   := regexp_replace(TRIM(i.MASCARA_RED_LAN), '(^[[:space:]]+)|([[:space:]]+$)',null);
                    P_MASCARA_IP(Lv_IpRed,Lv_MascaraRed,Pv_IncidenciaDetNotObj.Pv_ipAddress,Ln_IpValida,Lcl_MensajeError);
                    IF Ln_IpValida = 1
                    THEN
                        OPEN C_CLIENTES_POR_SERVICIO (i.SERVICIO_ID,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                        FETCH C_CLIENTES_POR_SERVICIO INTO Lr_InfoClienteIp;
                        CLOSE C_CLIENTES_POR_SERVICIO;
                        Lv_IdPersonaRol     := Lr_InfoClienteIp.ID_PERSONA_ROL;
                        Lv_DescripcionRol   := Lr_InfoClienteIp.DESCRIPCION_ROL;
                        Lv_Login            := Lr_InfoClienteIp.LOGIN;
                        Ln_CodEmpresa       := Lr_InfoClienteIp.COD_EMPRESA;
                        Lv_Region           := Lr_InfoClienteIp.REGION;
                        Lv_IdPunto          := Lr_InfoClienteIp.ID_PUNTO;
                        Ln_IdServicio       := Lr_InfoClienteIp.ID_SERVICIO;
                    END IF;
                END LOOP;
            END IF;

            IF (Lv_IdPersonaRol IS NULL)
            THEN
                OPEN C_RUTA_SUBRED (Pv_IncidenciaDetNotObj.Pv_ipAddress,Lv_EstadoEliminado);
                FETCH C_RUTA_SUBRED INTO Lr_InfoClienteSubRed;
                CLOSE C_RUTA_SUBRED;

                IF Lr_InfoClienteSubRed.ID_PERSONA_ROL IS NOT NULL
                THEN
                    Lv_IdPersonaRol     := Lr_InfoClienteSubRed.ID_PERSONA_ROL;
                    Lv_DescripcionRol   := Lr_InfoClienteSubRed.DESCRIPCION_ROL;
                    Lv_Login            := Lr_InfoClienteSubRed.LOGIN;
                    Ln_CodEmpresa       := Lr_InfoClienteSubRed.COD_EMPRESA;
                    Lv_Region           := Lr_InfoClienteSubRed.REGION;
                    Lv_IdPunto          := Lr_InfoClienteSubRed.ID_PUNTO;
                    Ln_IdServicio       := Lr_InfoClienteSubRed.ID_SERVICIO;
                END IF;
            END IF;

            IF (Lv_IdPersonaRol IS NULL)
            THEN
                OPEN C_IP_BGP (Pv_IncidenciaDetNotObj.Pv_ipAddress);
                FETCH C_IP_BGP INTO Ln_ServicioIdBGP;
                CLOSE C_IP_BGP;

                IF Ln_ServicioIdBGP IS NOT NULL
                THEN
                    OPEN C_CLIENTES_POR_SERVICIO (Ln_ServicioIdBGP,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                    FETCH C_CLIENTES_POR_SERVICIO INTO Lr_InfoClienteIp;
                    CLOSE C_CLIENTES_POR_SERVICIO;

                    Lv_IdPersonaRol     := Lr_InfoClienteIp.ID_PERSONA_ROL;
                    Lv_DescripcionRol   := Lr_InfoClienteIp.DESCRIPCION_ROL;
                    Lv_Login            := Lr_InfoClienteIp.LOGIN;
                    Ln_CodEmpresa       := Lr_InfoClienteIp.COD_EMPRESA;
                    Lv_Region           := Lr_InfoClienteIp.REGION;
                    Lv_IdPunto          := Lr_InfoClienteIp.ID_PUNTO;
                    Ln_IdServicio       := Lr_InfoClienteIp.ID_SERVICIO;
                END IF;
            END IF;

            IF (Lv_Login IS NOT NULL AND Lv_IdPersonaRol IS NOT NULL)
            THEN
                Lv_fechaRDA    := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD');
                Lv_horaRDA     := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY/MM/DD HH24:MI:SS'),'HH24:MI:SS');

                P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
                P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                Lcl_JsonCsoc    :='{
                                    "op": "search",
                                    "token": "'||Lv_Token||'",
                                    "data": {
                                        "login": "'||Lv_Login||'"
                                    }
                                }';

                P_CREAR_REQUEST (Lcl_JsonCsoc,Lv_URLCERTCsoc,Lv_RespuestaCsoc,Lcl_MensajeError);
                P_RESPUESTA_CSOC(Lv_RespuestaCsoc,Lv_Status,Ln_ClieCsoc);

            END IF;

            IF (Lv_Login IS NOT NULL AND Ln_ClieCsoc=0)
            THEN
                Lv_fechaRDA    := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD');
                Lv_horaRDA     := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY/MM/DD HH24:MI:SS'),'HH24:MI:SS');

                P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
                P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                Lcl_JsonSg      :='{
                                    "op": "search",
                                    "token": "'||Lv_Token||'",
                                    "data": {
                                        "login": "'||Lv_Login||'"
                                    }
                                }';

                P_CREAR_REQUEST (Lcl_JsonSg,Lv_URLCERTSg,Lv_RespuestaSg,Lcl_MensajeError);
                P_RESPUESTA_SG(Lv_RespuestaSg,Lv_Status,Ln_ClieSg);

            END IF;

        END IF;

        IF  Lv_IdPersonaRol IS NULL AND Pv_IncidenciaDetNotObj.Pv_bandCGNAT = 'S' THEN
            Lv_fechaCGNAT   := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD');
            Lv_horaCGNAT    := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY-MM-DD HH24:MI:SS'),'HH24:MI:SS');

            Ln_bandCGNAT    := 1;
            Lcl_JsonCGNAT   := '{
                                "query": {
                                    "bool": {
                                        "must": [
                                            {
                                                "match": {
                                                    "netflow.xlate_src_addr_ipv4": "'||Lv_ipAddressBusqCGNAT||'"
                                                }
                                            },
                                            {
                                                "match": {
                                                    "netflow.xlate_src_port": "'||Pv_IncidenciaDetNotObj.Pv_puerto||'"
                                                }
                                            },
                                            {
                                                "match": {
                                                    "@timestamp": "'||Lv_fechaCGNAT||'T'||Lv_horaCGNAT||'"
                                                }
                                            }
                                        ]
                                    }
                                }
                            }';
            P_CREAR_REQUEST (Lcl_JsonCGNAT,Lv_URLCGNAT,Lv_RespuestaCGNAT,Lcl_MensajeError);
            P_RESPUESTA_CGNAT(Lv_RespuestaCGNAT,Lv_ipAddressBusqCGNAT);
        END IF;

        IF (Lv_IdPersonaRol IS NULL AND Lv_ipAddressBusqCGNAT IS NOT NULL)
            THEN
                Lv_fechaRDA    := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD');
                Lv_horaRDA     := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY-MM-DD HH24:MI:SS'),'HH24:MI:SS');
                Lcl_JsonCliente :='{
                                    "empresa":"MD",
                                    "nombre_cliente":"",
                                    "login":"",
                                    "identificacion":"",
                                    "datos": 
                                            {
                                            "ip":       "'|| Lv_ipAddressBusqCGNAT ||'",
                                            "fecha":"'||Lv_fechaRDA||'",
                                            "hora_conexion":"'||Lv_horaRDA||'"
                                            },
                                    "opcion": "ECUCERT",
                                    "ejecutaComando":"SI",
                                    "usrCreacion": "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                    "ipCreacion": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'",
                                    "comandoConfiguracion":"SI"
                            }';

                P_CREAR_REQUEST (Lcl_JsonCliente,Lv_URLRDA,Lv_RespuestaRDACl,Lcl_MensajeError);
                P_RESPUESTA_RDA(Lv_RespuestaRDACl,Lv_Status,Lv_LoginRDA);

                OPEN C_CLIENTES_POR_LOGIN (Lv_EstadoServicio,Lv_LoginRDA,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                FETCH C_CLIENTES_POR_LOGIN INTO Lr_InfoClienteRDA;
                CLOSE C_CLIENTES_POR_LOGIN;

                IF Lr_InfoClienteRDA.ID_PERSONA_ROL IS NOT NULL
                    THEN
                    Lv_IdPersonaRol     := Lr_InfoClienteRDA.ID_PERSONA_ROL;
                    Lv_DescripcionRol   := Lr_InfoClienteRDA.DESCRIPCION_ROL;
                    Lv_Login            := Lr_InfoClienteRDA.LOGIN;
                    Ln_CodEmpresa       := Lr_InfoClienteRDA.COD_EMPRESA;
                    Lv_Region           := Lr_InfoClienteRDA.REGION;
                    Lv_IdPunto          := Lr_InfoClienteRDA.ID_PUNTO;
                    Ln_IdServicio       := Lr_InfoClienteRDA.ID_SERVICIO;
                END IF;   
        END IF;

        IF Ln_bandCGNAT != 1
        THEN 
            Lv_ipAddressBusqCGNAT:= null;
        END IF;

        IF ( Pv_tipoUsuario != 'Infraestructura' AND Lv_IdPersonaRol IS NOT NULL AND Lv_Login IS NOT NULL  AND Lv_IdPunto IS NOT NULL AND Ln_ClieCsoc!=1 AND Ln_ClieSg!=1 AND Lv_LoginCPE IS NULL) 
        THEN
            IF(Ln_CodEmpresa = 18)
            THEN
                Lv_Departamento     := 'IP CONTACT CENTER';
                Lv_PrefijoEmpre     := 'MD';
            ELSE                           
                Lv_Departamento := 'IPCCL1';
                Lv_PrefijoEmpre := 'TN';
            END IF;

            IF Ln_JefeSucursalId IS NULL THEN
                OPEN C_JEFE_REGION_CARGO (Ln_CodEmpresa,Lv_Region,Lv_Departamento,Lv_DescripJefe,Lv_EstadoPersona);
                FETCH C_JEFE_REGION_CARGO INTO Ln_JefeSucursalId;
                CLOSE C_JEFE_REGION_CARGO;
            END IF;

            IF Ln_JefeSucursalId IS NULL THEN
                OPEN C_JEFE_REGION_SIN_DESCRIP (Ln_CodEmpresa,Lv_Region,Lv_Departamento,Lv_EstadoPersona);
                FETCH C_JEFE_REGION_SIN_DESCRIP INTO Ln_JefeSucursalId;
                CLOSE C_JEFE_REGION_SIN_DESCRIP;
            END IF;

            IF Pv_IncidenciaDetNotObj.Pv_statusIn != 'No Vulnerable'
                THEN

                IF Ln_CodEmpresa = 10
                THEN

                    P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
                    P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                    OPEN C_ID_PROCESO (Lv_NombreProceso);
                    FETCH C_ID_PROCESO INTO Ln_idProceso;
                    CLOSE C_ID_PROCESO;

                    OPEN C_ID_TAREA (Lv_NombreTarea,Ln_idProceso);
                    FETCH C_ID_TAREA INTO Ln_idTarea;
                    CLOSE C_ID_TAREA;

                    P_CREAR_CASO(Lv_Login,
                                 Lv_IdPunto,
                                 Ln_CodEmpresa,
                                 Pv_CasoEcucertObj);

                    P_CREAR_TAREA(Ln_idComunicacionTarea,
                                  Ln_idDetalleTarea,
                                  Ln_idTareaDocumentoAsig,
                                  Ln_idDocuComuAsigTarea,
                                  Ln_idDetalleAsigTarea,
                                  Ln_idDetalleHistTarea,
                                  Ln_idTareaSeguiTarea);

                    IF Ln_JefeSucursalId IS NULL THEN
                        Ln_JefeSucursalId := Lv_AsignacionJefeTN1;  
                    END IF;

                    Lcl_SintomasA    :='[{
                                        "afectados": 
                                                    {
                                                    "puntoId": [  "'|| Lv_IdPunto||'"]
                                                    },
                                        "nombre":             "'|| Lv_NombreSintoma||'",
                                        "idDetalle":           '|| Pv_CasoEcucertObj.Pn_idDetalle||',
                                        "idParteAfectada":     '|| Pv_CasoEcucertObj.Pn_idParteAfectada ||',
                                        "idDetalleHipotesis":  '|| Pv_CasoEcucertObj.Pn_idDetalleHipotesis ||'
                                       }]';

                    Lcl_HipotesisA   :='[{
                                        "nombreHipotesis":    "'|| Lv_NombreHipotesis||'",
                                        "idDetalleCaAsig":     '|| Pv_CasoEcucertObj.Pn_idDetalleCaAsig||',
                                        "idComunicacionCaSig": '|| Pv_CasoEcucertObj.Pn_idComunicacionCaSig||',
                                        "idCasoHistorialAsig": '|| Pv_CasoEcucertObj.Pn_idCasoHistorialAsig||',
                                        "idCasoAsignacion":    '|| Pv_CasoEcucertObj.Pn_idCasoAsignacion||',
                                        "idCasoDocumentoAsig": '|| Pv_CasoEcucertObj.Pn_idCasoDocumentoAsig||',
                                        "idDocuComunicaAsig":  '|| Pv_CasoEcucertObj.Pn_idDocuComunicaAsig||',
                                        "estado":             "'|| Lv_EstadoActivo||'"
                                       }]';

                    Lcl_TareaA       :='[{
                                        "asignacionAut":    "'|| Lv_AutoAsig||'",
                                        "idProceso":        "'|| Ln_idProceso||'",
                                        "idTarea":          "'|| Ln_idTarea||'",
                                        "idDetalle":         '|| Ln_idDetalleTarea||',
                                        "idComunicacion":    '|| Ln_idComunicacionTarea||',
                                        "idDocumento":       '|| Ln_idTareaDocumentoAsig||',
                                        "idDocuComunica":    '|| Ln_idDocuComuAsigTarea||',
                                        "idDetalleAsig":     '|| Ln_idDetalleAsigTarea||',
                                        "idDetalleHisto":    '|| Ln_idDetalleHistTarea||',
                                        "idTareaSeguimiento":'|| Ln_idTareaSeguiTarea||',
                                        "sintoma":          "'|| Lv_NombreSintoma||'",
                                        "afectados":        {
                                                            "idAfectados":   "'|| Lv_IdPunto||'"
                                                            },
                                        "empleado":         "'|| Ln_JefeSucursalId||'",
                                        "cuadrilla":        "'|| Lv_Cuadrilla||'",
                                        "tipoAsignacion":   "'|| Lv_TipoAsig||'",
                                        "motivoTarea":      "'|| Lv_MotivoTarea||'",
                                        "observacion":      "'|| Lv_Observacion||'"
                                       }]';

                    Lcl_JsonCasos    :='{
                                        "data": 
                                                {
                                                "prefijoEmpresa":   "'|| Lv_PrefijoEmpre||'",
                                                "tipoCaso":         "'|| Lv_TipoCaso||'",
                                                "formaContacto":    "'|| Lv_FormaContacto||'",
                                                "nivelCriticidad":  "'|| Lv_NivelCriticidad||'", 
                                                "tipoAfectacion":   "'|| Lv_TipoAfectacion||'",
                                                "fechaHoraApertura":"'|| TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS')||'",
                                                "tipoBackbone":     "'|| Lv_TipoBackbone||'",
                                                "tituloInicial":    "'|| Lv_TituloInicial||'",
                                                "versionInicial":   "'|| Lv_VersionInicial||'",
                                                "sintomas":          '|| Lcl_SintomasA||',
                                                "hipotesis":         '|| Lcl_HipotesisA||',
                                                "empleadoAsignado": "'|| Ln_JefeSucursalId||'",
                                                "tareas":            '|| Lcl_TareaA||',
                                                "estadoActual":     "'|| Lv_EstadoActual||'",     
                                                "tipoReprograma":   "'|| Lv_TipoReprograma||'",   
                                                "tiempo":           "'|| Ln_tiempoMinutos||'",   
                                                "user":             "'|| Pv_IncidenciaDetNotObj.Pv_user||'",
                                                "ipCreacion":       "'|| Pv_IncidenciaDetNotObj.Pv_ipCreacion||'",
                                                "idCasoHistorial":   '|| Pv_CasoEcucertObj.Pn_idCasoHistorial ||',
                                                "idComunicacion ":   '|| Pv_CasoEcucertObj.Pn_idComunicacion ||',
                                                "idDocumento":       '|| Pv_CasoEcucertObj.Pn_idDocumento ||',
                                                "idDocComunicacion": '|| Pv_CasoEcucertObj.Pn_idDocuComunicacion ||',
                                                "idCaso":            '|| Pv_CasoEcucertObj.Pn_idCaso || '    
                                                },
                                        "op": "putCrearCaso",
                                        "token": "'||Lv_Token||'",
                                        "source": {
                                            "name": "APP.CERT",
                                            "originID": "127.0.0.1",
                                            "tipoOriginID": "IP"
                                        },
                                        "user": "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                        "ipCreacion": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'"
                                        }'; 

                    P_CREAR_REQUEST (Lcl_JsonCasos ,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
                    P_DATOS_CREAR_CASOS(Lv_RespuestaCaso,Lv_Status,Pv_Message,Lv_NoCaso,Ln_NoTarea);

                    IF Lv_NoCaso IS NOT NULL
                    THEN
                        OPEN C_CASO_ID (Lv_NoCaso);
                        FETCH C_CASO_ID INTO Lv_CasoId;
                        CLOSE C_CASO_ID;
                    END IF;

                    IF Lv_NoCaso IS NULL
                    THEN 
                        P_CREAR_REQUEST (Lcl_JsonCasos ,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
                        P_DATOS_CREAR_CASOS(Lv_RespuestaCaso,Lv_Status,Pv_Message,Lv_NoCaso,Ln_NoTarea);

                        OPEN C_CASO_ID (Lv_NoCaso);
                        FETCH C_CASO_ID INTO Lv_CasoId;
                        CLOSE C_CASO_ID;
                    END IF;

                ELSE

                    P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
                    P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                    OPEN C_ID_PROCESO (Lv_NombreProceso);
                    FETCH C_ID_PROCESO INTO Ln_idProceso;
                    CLOSE C_ID_PROCESO;

                    OPEN C_ID_TAREA (Lv_NombreTarea,Ln_idProceso);
                    FETCH C_ID_TAREA INTO Ln_idTarea;
                    CLOSE C_ID_TAREA;

                    --Crear Tarea
                    P_CREAR_TAREA(Ln_idComunicacionTarea,
                                  Ln_idDetalleTarea,
                                  Ln_idTareaDocumentoAsig,
                                  Ln_idDocuComuAsigTarea,
                                  Ln_idDetalleAsigTarea,
                                  Ln_idDetalleHistTarea,
                                  Ln_idTareaSeguiTarea);

                    IF Ln_JefeSucursalId IS NULL THEN
                        Ln_JefeSucursalId := Lv_AsignacionJefeMD;  
                    END IF;

                    Lcl_TareaA       :='[{
                            "asignacionAut":    "'|| Lv_AutoAsig||'",
                            "idProceso":        "'|| Ln_idProceso||'",
                            "idTarea":          "'|| Ln_idTarea||'",
                            "idDetalle":         '|| Ln_idDetalleTarea||',
                            "idComunicacion":    '|| Ln_idComunicacionTarea||',
                            "idDocumento":       '|| Ln_idTareaDocumentoAsig||',
                            "idDocuComunica":    '|| Ln_idDocuComuAsigTarea||',
                            "idDetalleAsig":     '|| Ln_idDetalleAsigTarea||',
                            "idDetalleHisto":    '|| Ln_idDetalleHistTarea||',
                            "idTareaSeguimiento":'|| Ln_idTareaSeguiTarea||',
                            "sintoma":          "'|| Lv_NombreSintoma||'",
                            "afectados":        {
                                                "idAfectados":   "'|| Lv_IdPunto||'"
                                                },
                            "empleado":         "'|| Ln_JefeSucursalId||'",
                            "cuadrilla":        "'|| Lv_Cuadrilla||'",
                            "tipoAsignacion":   "'|| Lv_TipoAsig||'",
                            "motivoTarea":      "'|| Lv_MotivoTarea||'",
                            "observacion":      "'|| Lv_Observacion||'"
                           }]';

                    Lcl_JsonTarea    :='{
                                        "data": 
                                                {
                                                "prefijoEmpresa":   "'|| Lv_PrefijoEmpre||'",
                                                "formaContacto":    "'|| Lv_FormaContacto||'",                          
                                                "empleadoAsignado": "'|| Ln_JefeSucursalId||'",
                                                "tareas":            '|| Lcl_TareaA||',
                                                "user":             "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                                "ipCreacion":       "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'"
                                                },
                                        "op": "putCrearTarea",
                                        "token": "'||Lv_Token||'",
                                        "source": {
                                            "name": "APP.CERT",
                                            "originID": "127.0.0.1",
                                            "tipoOriginID": "IP"
                                        },
                                        "user": "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                        "ipCreacion": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'"
                                        }'; 

                    P_CREAR_REQUEST (Lcl_JsonTarea ,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
                    P_DATOS_CREAR_TAREA(Lv_RespuestaCaso,Lv_Status,Pv_Message,Ln_NoTarea);

                    IF Ln_NoTarea IS NULL
                    THEN
                        P_CREAR_REQUEST (Lcl_JsonTarea ,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
                        P_DATOS_CREAR_TAREA(Lv_RespuestaCaso,Lv_Status,Pv_Message,Ln_NoTarea);
                    END IF;

                END IF;

                P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
                P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                OPEN C_GET_PARAMETROS_PLAN (Lv_NombreParamPlan,Lv_DescripParamPlan,Pv_IncidenciaDetNotObj.Pv_categoria,Pv_IncidenciaDetNotObj.Pv_subCategoria,Pv_IncidenciaDetNotObj.Pv_tipoEvento,Ln_CodEmpresa);
                FETCH C_GET_PARAMETROS_PLAN INTO Lv_InfoParamPlanti;
                CLOSE C_GET_PARAMETROS_PLAN;

                OPEN C_NOMBRE_CLIENTE (Lv_IdPersonaRol);
                FETCH C_NOMBRE_CLIENTE INTO Ln_NombresCliente;
                CLOSE C_NOMBRE_CLIENTE;

                IF Lv_NoCaso IS NOT NULL THEN
                    Lv_EtiquetaCaso := ' // Caso:  '||Lv_NoCaso;
                ELSE
                    Lv_EtiquetaCaso := NULL;
                END IF;

                Lcl_JsonNotificacion    :='{
                                           "data": 
                                                {
                                                "idPersonaEmpresaRol":      "'|| Lv_IdPersonaRol||'",
                                                "estado":                   "'|| Lv_EstadoActivo||'",
                                                "intIdPunto":               "'|| Lv_IdPunto||'",
                                                "strDescFormContact":       "'|| Lv_DescFormContact||'", 
                                                "strContacto":              "'|| Lv_Contacto||'",
                                                "strEstadoNotificacionIn":  "'|| Lv_EstadoNotifFallo||'",
                                                "strEstadoNotificacionEn":  "'|| Lv_EstadoNotif||'",
                                                "asunto":                   "'|| Lv_Asunto||' '||Pv_IncidenciaDetNotObj.Pv_tipoEvento||':'||REPLACE(Pv_IncidenciaDetNotObj.Pv_categoria,'_','')|| Lv_EtiquetaCaso ||' // '|| Ln_NombresCliente || ' // Login:  '||Lv_Login|| '",
                                                "codPlantilla":             "'|| Lv_InfoParamPlanti||'",
                                                "idCaso":                   "'|| Lv_CasoId||'",
                                                "idEmpresa":                "'|| Ln_CodEmpresa||'",
                                                "strLoginAfectado":         "'|| Lv_Login||'",
                                                "intIncidenciaDetId":       "'|| Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet||'",
                                                "ip":                       "'|| Pv_IncidenciaDetNotObj.Pv_ipAddress||'",
                                                "puerto":                   "'|| Pv_IncidenciaDetNotObj.Pv_puerto||'",
                                                "ipDestino":                "'|| Pv_IncidenciaDetNotObj.Pv_ipDestino||'",
                                                "ticket":                   "'|| Pv_IncidenciaDetNotObj.Pv_noTicket||'",
                                                "nombreCliente":            "'|| Ln_NombresCliente||'",
                                                "feIncidencia":             "'|| Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp||'"
                                                },
                                        "op": "putNotificarClienteEcucert",
                                        "token": "'||Lv_Token||'",
                                        "source": {
                                            "name": "APP.CERT",
                                            "originID": "127.0.0.1",
                                            "tipoOriginID": "IP"
                                        },
                                        "user": "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                       "ipCreacion": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'"
                                        }';

                P_CREAR_REQUEST (Lcl_JsonNotificacion ,Lv_URLTenico,Lv_RespuestaNotif,Lcl_MensajeError);
                P_ENVIO_NOTIFICACION(Lv_RespuestaNotif,Lv_Status,Pv_Message);
                IF Lv_Message = 'Enviado'
                THEN
                  UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET ESTADO_GESTION=Lv_EstadoAnalisis, SUB_ESTADO='' WHERE ID_DETALLE_INCIDENCIA=Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;
                END IF;
            ELSE
                UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET ESTADO_GESTION='Atendido', SUB_ESTADO='' WHERE ID_DETALLE_INCIDENCIA=Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;
                INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
                VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet,'Atendido',Pv_IncidenciaDetNotObj.Pv_user,sysdate,Pv_IncidenciaDetNotObj.Pv_ipCreacion);

            END IF;

            Pv_Message := 'Proceso realizado con exito';  

        ELSE                 
            IF (Lv_IdPersonaRol IS NULL AND Ln_ClieCsoc=0 AND Ln_ClieSg=0)
            THEN

                P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
                P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                Lcl_JsonNetworking :='{
                        "op": "search",
                        "token": "'||Lv_Token||'",
                        "data":
                        {
                            "ip_address": "'||Pv_IncidenciaDetNotObj.Pv_ipAddress||'"
                        }
                    }';

                P_CREAR_REQUEST (Lcl_JsonNetworking,Lv_URLNetworking,Lv_RespuestaNetW,Lcl_MensajeError);
                P_IP_NETWORKING (Lv_RespuestaNetW,Lv_IpWAN,Lv_Jurisdiccion,Lv_Vrf,Lcl_MensajeError); 

                IF Lv_IpWAN IS NOT NULL
                THEN
                    OPEN C_CANTON (Lv_Jurisdiccion);
                    FETCH C_CANTON INTO Lv_Region;
                    CLOSE C_CANTON;

                    IF Lv_Region IS NULL
                    THEN
                        Lv_Region := 'QUITO';
                    END IF;
                    Lv_Observacion      := 'La IP '||Pv_IncidenciaDetNotObj.Pv_ipAddress || ': No está registrada en el Telcos, pero fue encontrada en el  backbone con la IPWAN: '||Lv_IpWAN;

                    UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET IPWAN=Lv_IpWAN WHERE ID_DETALLE_INCIDENCIA = Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;

                END IF;
            END IF;

            IF (Pv_tipoUsuario = 'Infraestructura') OR (Lv_IdPersonaRol IS NOT NULL AND Ln_ClieCsoc=1)  OR (Lv_IdPersonaRol IS NULL AND Lv_IpWAN IS NULL AND Lv_Vrf IS NULL AND Ln_CodEmpresa = 10)
            THEN
                Ln_CodEmpresa       := 10;
                Lv_Departamento     := 'Seguridad Logica';
                Lv_PrefijoEmpre     := 'TN';
                Lv_Region           := 'GUAYAQUIL';
            ELSE
                lv_Vrf :=  LOWER(Lv_Vrf);
                IF (Lv_Vrf IS NOT NULL) AND ( Lv_Vrf = 'gepon' OR Lv_Vrf = 'cgnat' OR Lv_Vrf = 'netlife') OR (Ln_CodEmpresa = 18)
                THEN
                    --Asignación a RDA - Red de acceso
                    Ln_CodEmpresa       := 18;
                    Lv_Departamento     := 'Gepon/Tap';
                    Lv_PrefijoEmpre     := 'MD';
                ELSE
                    Ln_CodEmpresa       := 10; 
                    Lv_Departamento     := 'IPCCL2';
                    Lv_PrefijoEmpre     := 'TN';
                END IF;
            END IF;

            IF Lv_Region IS NULL
            THEN
                Lv_Region := 'GUAYAQUIL';
            END IF;

            OPEN C_JEFE_REGION_CARGO (Ln_CodEmpresa,Lv_Region,Lv_Departamento,Lv_DescripJefe,Lv_EstadoPersona);
            FETCH C_JEFE_REGION_CARGO INTO Ln_JefeSucursalId;
            CLOSE C_JEFE_REGION_CARGO;

            IF Ln_JefeSucursalId IS NULL THEN
                OPEN C_JEFE_REGION_SIN_DESCRIP (Ln_CodEmpresa,Lv_Region,Lv_Departamento,Lv_EstadoPersona);
                FETCH C_JEFE_REGION_SIN_DESCRIP INTO Ln_JefeSucursalId;
                CLOSE C_JEFE_REGION_SIN_DESCRIP;
            END IF;

            OPEN C_ESTADO_IP (Pv_IncidenciaDetNotObj.Pv_ipAddress);
            FETCH C_ESTADO_IP INTO Ln_IdIpNP,Lv_EstadoIpNP;
            CLOSE C_ESTADO_IP;

            IF Pv_tipoUsuario = 'Infraestructura'
            THEN
                Lv_SubEstado    := 'Cliente Infraestructura';
                Lv_NombreTarea  := Lv_TareaInfraes;
                Lv_NombreProceso:= Lv_ProcesoInfraes;
                Lv_Observacion  := 'Estimados CSOC, favor su ayuda con la revision y remediacion de la vulnerabilidad ' ||Pv_IncidenciaDetNotObj.Pv_categoria|| ' reportada por la Arcotel en la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' asignada al cliente '|| Lv_Login || ' usuario de Infraestructura.';
            ELSIF Lv_IdPersonaRol IS NOT NULL AND Ln_ClieCsoc=1
            THEN
                Lv_SubEstado    := 'Cliente Csoc';
                Lv_NombreTarea  := Lv_TareaCSOC;
                Lv_NombreProceso:= Lv_ProcesoCSOC;
                Lv_Observacion  := 'Estimados CSOC, favor su ayuda con la revision y remediacion de la vulnerabilidad ' ||Pv_IncidenciaDetNotObj.Pv_categoria|| ' reportada por la Arcotel en la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' asignada al cliente '|| Lv_Login || ' con servicio contratado de CSOC.';
            ELSIF Lv_IdPersonaRol IS NOT NULL AND Ln_ClieSg=1
            THEN
                Lv_SubEstado    := 'Cliente Sg';
                Lv_NombreTarea  := Lv_TareaSG;
                Lv_NombreProceso:= Lv_ProcesoSG;
                Lv_Observacion  := 'Estimados IPCCL2, favor su ayuda con la revision de politicas y buenas practicas de configuracion en el Fortigate del cliente '|| Lv_Login || ', con servicio contratado de seguridad gestionada, dado que se verifica que la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' asignada a este es reportada por la Arcotel por la vulnerabilidad ' ||Pv_IncidenciaDetNotObj.Pv_categoria;
            ELSIF Lv_LoginCPE IS NOT NULL
            THEN
                Lv_SubEstado    := 'IP CPE'; 
                Lv_NombreTarea  := Lv_TareaIPCPE;
                Lv_NombreProceso:= Lv_ProcesoIPCPE;
                Lv_Observacion  := 'Estimados IPCCL2, favor su ayuda con la revision y remediacion de la vulnerabilidad  ' ||Pv_IncidenciaDetNotObj.Pv_categoria|| ' reportada por la Arcotel en la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' la cual esta asociada al equipo CPE asignado al cliente';
            ELSIF Lv_IdPersonaRol IS NULL AND Lv_IpWAN IS NULL AND Lv_Vrf IS NULL
            THEN
                Lv_SubEstado    := 'Registro no encontrado en VRF ni GPON'; 
                Lv_NombreTarea  := Lv_TareaNoEncTelco;
                Lv_NombreProceso:= Lv_ProcesoNoEncTelco;
                Lv_Observacion  := 'Estimados CERT, favor su ayuda con la verificacion y regularizacion de la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' reportada por la Arcotel por la vulnerabilidad ' ||Pv_IncidenciaDetNotObj.Pv_categoria|| ', dado que no hay registro existente de la asignacion de dicha direccion IP a un cliente';
            ELSIF Lv_IdPersonaRol IS NULL AND Lv_Jurisdiccion IS NOT NULL AND Lv_Vrf != 'gepon' AND Lv_Vrf != 'cgnat' AND Lv_Vrf != 'netlife'
            THEN
                IF  UPPER(Lv_Jurisdiccion) = 'GUAYAQUIL'
                THEN
                    Lv_SubEstado    := 'Registro no encontrado en telcos Jurisdicion GYE';
                    Lv_NombreTarea  := Lv_TareaNoEncTelco;
                    Lv_NombreProceso:= Lv_ProcesoNoEncTelco;
                    Lv_Observacion  := 'Estimados IPCCL2 GYE, favor su ayuda con la verificacion y regularizacion en Telcos de la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' reportada por la Arcotel por la vulnerabilidad ' || Pv_IncidenciaDetNotObj.Pv_categoria|| ', dado que no hay registro en Telcos existente de la asignacion de dicha direccion IP a un cliente.';
                ELSE
                    Lv_SubEstado    := 'Registro no encontrado en telcos Jurisdicion UIO';
                    Lv_NombreTarea  := Lv_TareaNoEncTelco;
                    Lv_NombreProceso:= Lv_ProcesoNoEncTelco;
                    Lv_Observacion  := 'Estimados IPCCL2 UIO, favor su ayuda con la verificacion y regularizacion de la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' reportada por la Arcotel por la vulnerabilidad ' ||Pv_IncidenciaDetNotObj.Pv_categoria|| ', dado que no hay registro existente en Telcos de la asignacion de dicha direccion IP a un cliente.';
                END IF; 
            ELSIF (Lv_IdPersonaRol IS NULL) AND (Lv_Vrf = 'gepon' OR  Lv_Vrf = 'cgnat' OR Lv_Vrf = 'netlife' )
            THEN
                lv_Vrf :=  UPPER(Lv_Vrf);
                Lv_SubEstado    := 'Regularizacion de Ips que estan en la VRF '||Lv_Vrf||''; 
                Lv_NombreTarea  := Lv_TareaRegMegadatos;
                Lv_NombreProceso:= Lv_ProcesoNoEncMega;
                Lv_Observacion  := 'Estimados GEPON, favor su ayuda con la verificacion y regularizacion de la direccion IP '|| Pv_IncidenciaDetNotObj.Pv_ipAddress ||' reportada por la Arcotel por la vulnerabilidad ' ||Pv_IncidenciaDetNotObj.Pv_categoria|| ', dado que no hay registro existente de la asignacion de dicha direccion IP a un cliente';
            ELSE
                Lv_SubEstado :='IP '||Lv_EstadoIpNP;
            END IF; 

            IF Pv_IncidenciaDetNotObj.Pv_statusIn != 'No Vulnerable'
            THEN

              P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
              P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

              OPEN C_ID_PROCESO (Lv_NombreProceso);
              FETCH C_ID_PROCESO INTO Ln_idProceso;
              CLOSE C_ID_PROCESO;

              OPEN C_ID_TAREA (Lv_NombreTarea,Ln_idProceso);
              FETCH C_ID_TAREA INTO Ln_idTarea;
              CLOSE C_ID_TAREA;

              IF Ln_JefeSucursalId IS NULL AND Ln_CodEmpresa = 18 THEN
                  Ln_JefeSucursalId := Lv_AsignacionJefeMD;  
              END IF;

              IF Ln_JefeSucursalId IS NULL AND Ln_CodEmpresa = 10 THEN
                  Ln_JefeSucursalId := Lv_AsignacionJefeTN2;  
              END IF;

              --Crear Tarea
              P_CREAR_TAREA(Ln_idComunicacionTarea,
                            Ln_idDetalleTarea,
                            Ln_idTareaDocumentoAsig,
                            Ln_idDocuComuAsigTarea,
                            Ln_idDetalleAsigTarea,
                            Ln_idDetalleHistTarea,
                            Ln_idTareaSeguiTarea);

              Lcl_TareaA       :='[{
                              "asignacionAut":    "'|| Lv_AutoAsig||'",
                              "idProceso":        "'|| Ln_idProceso||'",
                              "idTarea":          "'|| Ln_idTarea||'",
                              "idDetalle":         '|| Ln_idDetalleTarea||',
                              "idComunicacion":    '|| Ln_idComunicacionTarea||',
                              "idDocumento":       '|| Ln_idTareaDocumentoAsig||',
                              "idDocuComunica":    '|| Ln_idDocuComuAsigTarea||',
                              "idDetalleAsig":     '|| Ln_idDetalleAsigTarea||',
                              "idDetalleHisto":    '|| Ln_idDetalleHistTarea||',
                              "idTareaSeguimiento":'|| Ln_idTareaSeguiTarea||',
                              "sintoma":          "'|| Lv_NombreSintoma||'",
                              "afectados":        {
                                                  "idAfectados":   "'|| Lv_IdPunto||'"
                                                  },
                              "empleado":         "'|| Ln_JefeSucursalId||'",
                              "cuadrilla":        "'|| Lv_Cuadrilla||'",
                              "tipoAsignacion":   "'|| Lv_TipoAsig||'",
                              "motivoTarea":      "'|| Lv_MotivoTarea||'",
                              "observacion":      "'|| Lv_Observacion||'"
                            }]';

              Lcl_JsonTarea    :='{
                                  "data": 
                                          {
                                          "prefijoEmpresa":   "'|| Lv_PrefijoEmpre||'",
                                          "formaContacto":    "'|| Lv_FormaContacto||'",                          
                                          "empleadoAsignado": "'|| Ln_JefeSucursalId||'",
                                          "tareas":            '|| Lcl_TareaA||',
                                          "estadoActual":     "'|| Lv_EstadoActual||'",     
                                          "tipoReprograma":   "'|| Lv_TipoReprograma||'",   
                                          "tiempo":           "'|| Ln_tiempoMinutos||'",   
                                          "user":             "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                          "ipCreacion":       "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'"
                                          },
                                  "op": "putCrearTarea",
                                  "token": "'||Lv_Token||'",
                                  "source": {
                                        "name": "APP.CERT",
                                        "originID": "127.0.0.1",
                                        "tipoOriginID": "IP"
                                    },
                                  "user": "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                  "ipCreacion": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'"
                                  }'; 

              IF Ln_bandCGNAT != 1
              THEN
                  P_CREAR_REQUEST (Lcl_JsonTarea,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
                  P_DATOS_CREAR_TAREA(Lv_RespuestaCaso,Lv_Status,Pv_Message,Ln_NoTarea);

                  IF Ln_NoTarea IS NULL
                  THEN
                      P_CREAR_REQUEST (Lcl_JsonTarea ,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
                      P_DATOS_CREAR_TAREA(Lv_RespuestaCaso,Lv_Status,Pv_Message,Ln_NoTarea);
                  END IF;
              END IF;

              UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET SUB_ESTADO=Lv_SubEstado WHERE ID_DETALLE_INCIDENCIA=Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;
              Pv_Message := 'No se pudo procesar: '||Lv_SubEstado;

              IF Pv_tipoUsuario = 'Infraestructura' OR Pn_CodigoEmpresaTicket = 18 OR Pn_CodigoEmpresaTicket = 10 THEN
                 UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET ESTADO_GESTION=Lv_EstadoAnalisis WHERE ID_DETALLE_INCIDENCIA=Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;
              END IF;

            ELSE
                UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET ESTADO_GESTION='Atendido', SUB_ESTADO=Lv_SubEstado WHERE ID_DETALLE_INCIDENCIA=Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;
                INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
                VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet,'Atendido',Pv_IncidenciaDetNotObj.Pv_user,sysdate,Pv_IncidenciaDetNotObj.Pv_ipCreacion);

            END IF;
        END IF;

            IF Ln_idComunicacionTarea IS NOT NULL AND Ln_idComunicacionTarea != 0 THEN

                OPEN C_DETALLE_TAREA (Ln_idComunicacionTarea);
                FETCH C_DETALLE_TAREA INTO Ln_DetalleId;
                CLOSE C_DETALLE_TAREA;

                INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(ID_SEGUIMIENTO, DETALLE_ID, OBSERVACION, USR_CREACION, FE_CREACION) 
                VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Ln_DetalleId,'Validación Automática: '||Pv_IncidenciaDetNotObj.Pv_statusIn,Pv_IncidenciaDetNotObj.Pv_user,SYSDATE);
            END IF;
            Lv_DescripcionRol := Pv_tipoUsuario;
            Pn_IncidenciaDetActId :=  INCIDENCIA_ACT_DETALLE_TYPE(Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet,
                                                                  Lv_CasoId,
                                                                  Ln_idComunicacionTarea,
                                                                  Lv_IdPersonaRol,
                                                                  Lv_DescripcionRol,
                                                                  Ln_CodEmpresa,
                                                                  Pv_IncidenciaDetNotObj.Pv_user,
                                                                  Pv_IncidenciaDetNotObj.Pv_ipCreacion,
                                                                  Ln_IdServicio,
                                                                  Ln_ClieCsoc,
                                                                  Ln_ClieSg,
                                                                  Ln_EsCPE,
                                                                  Ln_bandCGNAT,
                                                                  Ln_BandRDA,
                                                                  Lv_ipAddressBusqCGNAT);            

        P_ACT_DET_INCI_CASO_CLIENTE(Pn_IncidenciaDetActId,
                                    Lcl_MensajeError );
      EXCEPTION 
      WHEN OTHERS THEN 
          Lcl_MensajeError :=  SQLCODE || ' - ERROR_STACK:'||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '. IdDetalleIncidencia' || Pv_IncidenciaDetNotObj.Pn_IncidenciaIdDet;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                                'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_BUSCAR_CLIENTE_NOT',
                                                Lcl_MensajeError,
                                                'telcos',
                                                SYSDATE,
                                                '127.0.0.1'); 

    END P_BUSCAR_CLIENTE_NOT;

    PROCEDURE P_INGRESAR_CATEGORIA(Pv_Categoria       IN VARCHAR2,
                                   Pv_SubCategoria    IN VARCHAR2,
                                   Pv_TipoEvento      IN VARCHAR2,
                                   Pn_CodEmpresa      IN INTEGER,
                                   Pv_Message         OUT VARCHAR2)
                                   IS 
    CURSOR C_GET_PARAMETRO(Cv_NombreParametro VARCHAR2,Cv_Estado VARCHAR2)
    IS
      SELECT APC.id_parametro
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
      WHERE APC.nombre_parametro = Cv_NombreParametro;

    CURSOR C_GET_PARAMETRO_DET(Cv_IdParametro INTEGER,Cv_Categoria VARCHAR2,
                               Cv_SubCategoria VARCHAR2,Cv_TipoEvento VARCHAR2,
                               Cn_CodEmpresa INTEGER,Cv_Estado VARCHAR2)
    IS
      SELECT APD.ID_PARAMETRO_DET
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID = Cv_IdParametro
      AND APD.VALOR1 = Cv_Categoria
      AND (APD.VALOR2 = Cv_SubCategoria OR Cv_SubCategoria IS NULL)
      AND APD.VALOR3 = Cv_TipoEvento
      AND APD.ESTADO = Cv_Estado
      AND APD.EMPRESA_COD = Cn_CodEmpresa;

    Lv_Estado           VARCHAR2(50)  := 'Activo';
    Lv_NombreParametro  VARCHAR2(350) := 'PLANTILLAS DE NOTIFICACIONES';
    Lv_DescripParametro VARCHAR2(350) := 'CODIGO DE PLANTILLA ECUCERT';
    Lv_Usuario          VARCHAR2(50)  := 'telcos';
    Lv_CodPlantilla     VARCHAR2(250);
    Ln_IdParametro      INTEGER;
    Ln_IdParametroDet   INTEGER;
    Lcl_MensajeError    CLOB;
    Lv_Prefijo          VARCHAR2(50);
    BEGIN

      OPEN C_GET_PARAMETRO(Lv_NombreParametro,Lv_Estado);
      FETCH C_GET_PARAMETRO INTO Ln_IdParametro;
      CLOSE C_GET_PARAMETRO;

      OPEN C_GET_PARAMETRO_DET(Ln_IdParametro,Pv_Categoria,Pv_SubCategoria,
                               Pv_TipoEvento,Pn_CodEmpresa,Lv_Estado);
      FETCH C_GET_PARAMETRO_DET INTO Ln_IdParametroDet;
      CLOSE C_GET_PARAMETRO_DET;

      IF Pn_CodEmpresa = 18
      THEN
        Lv_Prefijo := 'MD';
      ELSE
        Lv_Prefijo := 'TN';
      END IF;

      IF Ln_IdParametroDet IS NULL
      THEN
        Lv_CodPlantilla := Pv_Categoria;

        IF Pv_SubCategoria IS NOT NULL
        THEN
          Lv_CodPlantilla := Lv_CodPlantilla || SUBSTR(Pv_SubCategoria, 1, 2);
        END IF;

        Lv_CodPlantilla := Lv_CodPlantilla || Lv_Prefijo;

        INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET(
          ID_PARAMETRO_DET,
          PARAMETRO_ID,
          DESCRIPCION,
          VALOR1,
          VALOR2,
          VALOR3,
          VALOR4, 
          ESTADO,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION, 
          EMPRESA_COD)
        VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
          Ln_IdParametro,
          Lv_DescripParametro,
          Pv_Categoria,
          Pv_SubCategoria,
          Pv_TipoEvento,
          Lv_CodPlantilla,
          Lv_Estado,
          Lv_Usuario,
          SYSDATE,
          '127.0.0.1',
          Pn_CodEmpresa);
        COMMIT;
      END IF;

      Pv_Message := 'Se proceso con éxito';

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error AL PROCESAR REQUEST P_INGRESAR_CATEGORIA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_INGRESAR_CATEGORIA',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_INGRESAR_CATEGORIA;

    PROCEDURE P_DATOS_CREAR_TAREA (Pv_Data          IN  VARCHAR2,
                                    Pv_Status        OUT VARCHAR2,
                                    Pv_Message       OUT VARCHAR2,
                                    Pv_NoTarea       OUT VARCHAR2)
                                    IS 
    Lv_StatusTarea   VARCHAR2(50);
    Lcl_MensajeError CLOB;
    BEGIN
      apex_json.parse (Pv_Data);
      Lv_StatusTarea     := APEX_JSON.get_varchar2(p_path => 'mensaje');
      IF Lv_StatusTarea = 'ok'
      THEN
        Pv_NoTarea         := APEX_JSON.get_varchar2(p_path => 'numeroTarea');
      END IF;

      Pv_Message:=apex_json.get_varchar2('mensaje');

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error AL PROCESAR REQUEST P_DATOS_CREAR_TAREA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'DB_SOPORTE.P_DATOS_CREAR_TAREA',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_DATOS_CREAR_TAREA;

    PROCEDURE P_RESPUESTA_CSOC(Pv_Data          IN  VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pn_ClienteCsoc  OUT INTEGER 
                                )IS 
    Lcl_MensajeError CLOB;
    Lv_BandC         VARCHAR2(100);
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status :=apex_json.get_varchar2('success');
      IF Pv_Status = 'true'
      THEN 
        Lv_BandC  := apex_json.get_varchar2('band_csoc');   
        IF Lv_BandC = 'S'
          THEN 
            Pn_ClienteCsoc := 1;
        ELSE
            Pn_ClienteCsoc := 0;
        END IF;
      ELSE
        Pn_ClienteCsoc := 0;
      END IF;

      EXCEPTION
      WHEN OTHERS THEN
        Pn_ClienteCsoc := 0;
        Lcl_MensajeError := 'Error P_RESPUESTA_CSOC: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'SPKG_INCIDENCIA_ECUCERT.P_RESPUESTA_CSOC',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_RESPUESTA_CSOC;

    PROCEDURE P_RESPUESTA_SG(Pv_Data          IN  VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pn_ClienteSg    OUT INTEGER
                                )IS 
    Lcl_MensajeError CLOB;
    Lv_BanSg           VARCHAR2(100);
    BEGIN
      apex_json.parse (Pv_Data);
      Pv_Status :=apex_json.get_varchar2('success');
      IF Pv_Status = 'true'
      THEN 
        Lv_BanSg  := apex_json.get_varchar2('band_sg');
        IF Lv_BanSg = 'S'
          THEN 
            Pn_ClienteSg := 1;
         ELSE
            Pn_ClienteSg := 0;
        END IF;
      ELSE
        Pn_ClienteSg := 0;
      END IF;

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error P_RESPUESTA_SG: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'SPKG_INCIDENCIA_ECUCERT.P_RESPUESTA_SG',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_RESPUESTA_SG;

    PROCEDURE P_ACTUALIZAR_ESTADO_GESTION(Pv_EstadoGestion    IN  VARCHAR2,
                                           Pv_SubEstado        IN VARCHAR2,
                                           Pv_IdDetalleInc     IN VARCHAR2)
                                          IS 
    Lcl_MensajeError CLOB;
    BEGIN
      UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET ESTADO_GESTION = Pv_EstadoGestion,STATUS=Pv_SubEstado WHERE ID_DETALLE_INCIDENCIA = Pv_IdDetalleInc;
      INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
      VALUES(DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,Pv_IdDetalleInc,Pv_EstadoGestion,'telcos',sysdate,'127.0.0.1');

      EXCEPTION
      WHEN OTHERS THEN
        Lcl_MensajeError := 'Error P_RESPUESTA_SG: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'SPKG_INCIDENCIA_ECUCERT.P_ACTUALIZAR_ESTADO_GESTION',
                                              Lcl_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_ACTUALIZAR_ESTADO_GESTION;

    PROCEDURE P_REPROCESAR_CLIENTE(
                                  Pn_IncidenciaDetId    IN  INTEGER,
                                  Pv_ipCreacion         IN  VARCHAR2,
                                  Pv_user               IN  VARCHAR2,
                                  Pv_MensajeError       OUT VARCHAR2
                                  )
                                  IS 
    CURSOR C_BUSCAR_DETALLE_INCI(Cv_IdDetalleInc VARCHAR2)
    IS
        SELECT IID.IP, 
        IID.FE_INCIDENCIA, 
        IID.PUERTO,
        IIC.NO_TICKET,
        IIC.CATEGORIA,
        IIC.SUBCATEGORIA,
        IIC.TIPO_EVENTO,
        IID.IP_DEST, 
        IID.ESCPE,
        IID.STATUS,
        IID.TIPO_USUARIO,
        IIC.SUBJECT,
        IID.ESCGNAT,
        IID.ESRDA
        FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID
        INNER JOIN DB_SOPORTE.INFO_INCIDENCIA_CAB IIC ON IID.INCIDENCIA_ID=IIC.ID_INCIDENCIA
        WHERE IID.ID_DETALLE_INCIDENCIA = Cv_IdDetalleInc;    

    Lv_IncidenciaDetNotObj  INCIDENCIA_NOT_DETALLE_TYPE;
    Lv_ipAddress            VARCHAR2(800);
    Lv_feIncidenciaIp       VARCHAR2(800);
    Lv_puerto               VARCHAR2(800);
    Lv_noTicket             VARCHAR2(800);
    Lv_categoria            VARCHAR2(800);
    Lv_subCategoria         VARCHAR2(800);
    Lv_tipoEvento           VARCHAR2(800);
    Lv_ipDestino            VARCHAR2(800);
    Lv_BandCPE              VARCHAR2(800);
    Lv_status               VARCHAR2(800);
    Lv_tipoUsuario          VARCHAR2(800);
    Lv_subject              VARCHAR2(800);
    Lv_bandCGNAT            VARCHAR2(800);
    Lv_BandRDA              VARCHAR2(800);
    Lv_EmpresaMEGADATOS     VARCHAR2(400) := '%MEGADATOS%';
    Ln_CodigoEmprTicket     NUMBER;
    BEGIN

        OPEN C_BUSCAR_DETALLE_INCI (Pn_IncidenciaDetId);
        FETCH C_BUSCAR_DETALLE_INCI INTO Lv_ipAddress,
                                         Lv_feIncidenciaIp,
                                         Lv_puerto,
                                         Lv_noTicket,
                                         Lv_categoria,
                                         Lv_subCategoria,
                                         Lv_tipoEvento,
                                         Lv_ipDestino,
                                         Lv_BandCPE,
                                         Lv_status,
                                         Lv_tipoUsuario,
                                         Lv_subject,
                                         Lv_bandCGNAT,
                                         Lv_BandRDA;
        CLOSE C_BUSCAR_DETALLE_INCI;

        CASE WHEN UPPER(Lv_subject) LIKE Lv_EmpresaMEGADATOS
        THEN Ln_CodigoEmprTicket:= 18;
        ELSE Ln_CodigoEmprTicket:= 10;
        END CASE;

        Lv_IncidenciaDetNotObj   := INCIDENCIA_NOT_DETALLE_TYPE(
                                        Lv_ipAddress,
                                        Pn_IncidenciaDetId,
                                        Pv_ipCreacion,
                                        Lv_feIncidenciaIp,
                                        Pv_user,
                                        Lv_puerto,
                                        Lv_noTicket,
                                        Lv_categoria,
                                        Lv_subCategoria,
                                        Lv_tipoEvento,
                                        Lv_ipDestino,
                                        Lv_BandCPE,
                                        Lv_status,
                                        Lv_bandCGNAT,
                                        Lv_BandRDA);

        P_BUSCAR_CLIENTE_NOT(Lv_IncidenciaDetNotObj,Lv_tipoUsuario,Ln_CodigoEmprTicket,Pv_MensajeError);
      EXCEPTION
      WHEN OTHERS THEN
        Pv_MensajeError := 'ERROR P_REPROCESAR_CLIENTE: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                              'SPKG_INCIDENCIA_ECUCERT.P_REPROCESAR_CLIENTE',
                                              Pv_MensajeError,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

    END P_REPROCESAR_CLIENTE;

    FUNCTION F_DIAS_LABORABLES(
        Ft_fechaInicio  IN TIMESTAMP, 
        Ft_fechaFin     IN TIMESTAMP)
      RETURN NUMBER IS
          Ln_numeroDias         NUMBER := 0;
          Ld_fechaActual        TIMESTAMP;
          Ld_fechaActualComp    DATE;
          Ln_tiempoHoras        INTEGER;
          Ln_Resultado          NUMBER := 0;
          Ln_tiempoHorasViernes INTEGER := 0;
      BEGIN
          Ln_tiempoHoras := (((extract( minute from(Ft_fechaFin-Ft_fechaInicio)))/60)+(extract( hour from(Ft_fechaFin-Ft_fechaInicio)))+
                            ((extract( day from(Ft_fechaFin-Ft_fechaInicio)))*24)+((extract( second from(Ft_fechaFin-Ft_fechaInicio)))/3600));

            IF Ft_fechaFin >= Ft_fechaInicio THEN    
               Ld_fechaActual := Ft_fechaInicio;
               WHILE Ld_fechaActual <= Ft_fechaFin AND Ln_tiempoHoras>=24 
               LOOP
                Ld_fechaActualComp := Ld_fechaActual+1;
                 IF TO_CHAR(Ld_fechaActual,'DY') NOT IN ('SAT','SUN') THEN 
                    Ln_numeroDias := Ln_numeroDias + 1;
                 END IF;       
                 Ln_tiempoHorasViernes := (((extract( minute from(Ld_fechaActualComp-Ld_fechaActual)))/60)+(extract( hour from(Ld_fechaActualComp-Ld_fechaActual)))+
                                ((extract( day from(Ld_fechaActualComp-Ld_fechaActual)))*24)+((extract( second from(Ld_fechaActualComp-Ld_fechaActual)))/3600));

                 Ld_fechaActual := Ld_fechaActual + 1;
                 Ln_tiempoHoras := (((extract( minute from(Ft_fechaFin-Ld_fechaActualComp)))/60)+(extract( hour from(Ft_fechaFin-Ld_fechaActualComp)))+
                                    ((extract( day from(Ft_fechaFin-Ld_fechaActualComp)))*24)+((extract( second from(Ft_fechaFin-Ld_fechaActualComp)))/3600));
                END LOOP;

                 IF TO_CHAR(Ft_fechaFin,'DY') NOT IN ('SAT','SUN') THEN 
                    Ln_Resultado := ((Ln_numeroDias-1)*24)+Ln_tiempoHoras+Ln_tiempoHorasViernes;
                 ELSE
                    Ln_Resultado := ((Ln_numeroDias-1)*24)+Ln_tiempoHorasViernes;
                 END IF;
            ELSE
               Ln_Resultado := 0;
            END IF;  
         RETURN Ln_Resultado;
     END F_DIAS_LABORABLES;

    PROCEDURE P_FINALIZACION_TAREAS_AUTOMAT
    IS

    CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
    IS
      SELECT APD.VALOR1,APD.VALOR2,
              APD.VALOR3,APD.VALOR4,APD.VALOR5,VALOR6,VALOR7,OBSERVACION
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.parametro_id =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.nombre_parametro = Cv_NombreParametro
        )
    AND APD.descripcion = Cv_DescripcionParametro;

    CURSOR C_GET_TAREAS_ECUCERT(Cv_EstadoTarea VARCHAR2)
    IS    
    SELECT T1.TAREA_ID,T1.EMPRESA_ID,T1.CASO_ID,T1.ID_DETALLE,
            (EXTRACT(HOUR FROM (SYSDATE-T1.FE_CREACION))*60+
            EXTRACT(DAY FROM (SYSDATE-T1.FE_CREACION))*24*60+
            EXTRACT(MINUTE FROM (SYSDATE-T1.FE_CREACION))) AS MINUTOS_TAREA,
            T1.PREFIJO,
            TO_CHAR(SYSDATE,'DD/MM/YYYY') AS FECHA_CIERRE, 
            TO_CHAR(SYSDATE,'HH24:MI:SS') AS HORA_CIERRE,
            T1.VALOR2 AS USUARIO,T1.ID_DETALLE_INCIDENCIA
    FROM(
        SELECT (
                SELECT MAX(IDEH.ID_DETALLE_HISTORIAL) 
                FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDEH 
                WHERE IDE.ID_DETALLE=IDEH.DETALLE_ID ) AS ID_DETALLE_HISTORIAL,
                IDE.TAREA_ID,IID.TAREA_PROCESADA,IID.EMPRESA_ID,IID.CASO_ID,
                IDE.ID_DETALLE,IDE.FE_CREACION,IEG.PREFIJO,
                APD.VALOR1,APD.VALOR2,IID.ID_DETALLE_INCIDENCIA
        FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID
        INNER JOIN DB_COMUNICACION.INFO_COMUNICACION ICO ON ICO.ID_COMUNICACION = IID.COMUNICACION_ID
        INNER JOIN DB_SOPORTE.INFO_DETALLE IDE ON IDE.ID_DETALLE=ICO.DETALLE_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = IID.EMPRESA_ID
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APD.EMPRESA_COD = IID.EMPRESA_ID AND APD.DESCRIPCION ='PARAMETROS_CIERRE_TAREA'
        WHERE IID.CASO_ID IS NULL AND  IID.TAREA_PROCESADA = 0
        ) T1
        INNER JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDEH ON T1.ID_DETALLE_HISTORIAL=IDEH.ID_DETALLE_HISTORIAL 
        WHERE IDEH.ESTADO = Cv_EstadoTarea 
              AND  ROUND((EXTRACT(HOUR FROM (SYSDATE-T1.FE_CREACION))+
                    EXTRACT(DAY FROM (SYSDATE-T1.FE_CREACION))*24+
                    EXTRACT(MINUTE FROM (SYSDATE-T1.FE_CREACION))/60),2) >= T1.VALOR1;

    Lr_InfoParamTarea       C_GET_PARAMETROS%ROWTYPE;

    Lv_NombreParametro      VARCHAR2(400) := 'PARAMETROS_ECUCERT';
    Lv_DescripParametro     VARCHAR2(400);
    Lv_RespuestaFinTarea    VARCHAR2(4000);
    Lv_URLSoporte           VARCHAR2(4000);
    Lcl_JsonFinTarea        CLOB;
    Lcl_MensajeError        CLOB;
    Lv_EstadoAsignada       VARCHAR2(400) := 'Asignada';
    Lv_Observacion          VARCHAR2(400) := 'Cierre de tarea por proceso ECUCERT';
    Lv_StatusTarea          VARCHAR2(400);
    Ln_TareaProcesada       INTEGER :=1;
    Ln_ContadorCommit       INTEGER :=50;
    Ln_ContadorIteracion    INTEGER :=0;
    Ln_IdDetalle            INTEGER;
    Lcl_JsonToken           CLOB;
    Lv_RespuestaToken       VARCHAR2(4000);
    Lv_Message              VARCHAR2(800);
    Lv_Token                VARCHAR2(800);
    Lv_Status               VARCHAR2(800);
    Lv_URLToken             VARCHAR2(400);

    BEGIN

        Lcl_JsonToken    := '
            {
              "source": {
                "name": "APP.CERT",
                "originID": "127.0.0.1",
                "tipoOriginID": "IP"
                        },
              "user": "CERT",
              "gateway": "Authentication",
              "service": "Authentication",
              "method": "Authentication"
            }';

        Lv_DescripParametro := 'URL ECUCERT';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_URLSoporte        := Lr_InfoParamTarea.VALOR2;
        Lv_URLToken          := Lr_InfoParamTarea.VALOR5;
        Ln_ContadorIteracion := 0;

        FOR i IN  C_GET_TAREAS_ECUCERT(Lv_EstadoAsignada)
        LOOP
            Ln_ContadorIteracion := Ln_ContadorIteracion+1;
            Ln_IdDetalle         := i.ID_DETALLE;

            P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lcl_MensajeError);        
            P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

            Lcl_JsonFinTarea     :='{
                                    "op": "putFinalizarTarea",
                                    "source": {
                                        "name": "APP.CERT",
                                        "originID": "127.0.0.1",
                                        "tipoOriginID": "IP"
                                    },
                                    "token": "'||Lv_Token||'",
                                    "user": "'||i.USUARIO||'",
                                    "data":
                                    {
                                        "codEmpresa":       "'||i.EMPRESA_ID||'",
                                        "idCaso":           "'||i.CASO_ID||'",
                                        "prefijoEmpresa":   "'||i.PREFIJO||'",
                                        "tarea": {
                                                        "idTarea":         "'|| i.ID_DETALLE||'",
                                                        "materiales":      "",
                                                        "tiempoTotalTarea":"'|| i.MINUTOS_TAREA||'",
                                                        "fechaInicial":    "",
                                                        "horaInicial":     "",
                                                        "observacion":     "'|| Lv_Observacion||'",
                                                        "fechaCierre":     "'|| i.FECHA_CIERRE||'",
                                                        "horaCierre":      "'|| i.HORA_CIERRE||'",
                                                        "idTareaFinal":    "'|| i.TAREA_ID||'"
                                                }
                                    }
                                }';

            P_CREAR_REQUEST (Lcl_JsonFinTarea,Lv_URLSoporte,Lv_RespuestaFinTarea,Lcl_MensajeError);

            APEX_JSON.PARSE (Lv_RespuestaFinTarea);
            Lv_StatusTarea     := UPPER(APEX_JSON.GET_VARCHAR2(p_path => 'status'));
            IF Lv_StatusTarea = '200'
            THEN
                P_TAREA_PROCESADA(i.ID_DETALLE_INCIDENCIA,Ln_TareaProcesada,i.ID_DETALLE,'Cierre Automático de la Tarea de ECUCERT'); 
            ELSE
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                                'SPKG_INCIDENCIA_ECUCERT.P_FINALIZACION_TAREAS_AUTOMAT/P_CREAR_REQUEST',
                                                SUBSTR(Lcl_MensajeError||SQLERRM ||' id_detalle: '||i.ID_DETALLE ||Lv_RespuestaFinTarea,1,4000),
                                                'telcos',
                                                SYSDATE,
                                                '127.0.0.1');
            END IF;

            IF MOD(Ln_ContadorIteracion,Ln_ContadorCommit) = 0
            THEN
                COMMIT; 
            END IF;            

        END LOOP;
        COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
            Lcl_MensajeError := 'ERROR P_FINALIZACION_TAREAS_AUTOMAT: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK||' id_detalle: '||Ln_IdDetalle || Lv_RespuestaFinTarea;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                                'SPKG_INCIDENCIA_ECUCERT.P_FINALIZACION_TAREAS_AUTOMAT',
                                                SUBSTR(Lcl_MensajeError,1,4000),
                                                'telcos',
                                                SYSDATE,
                                                '127.0.0.1');

    END P_FINALIZACION_TAREAS_AUTOMAT;

    PROCEDURE P_TAREA_PROCESADA(
                                Pn_IncidenciaDet  IN INTEGER,
                                Pn_TareaProcesada IN INTEGER,
                                Pn_DetalleId      IN INTEGER,
                                Pv_Observacion    IN VARCHAR2)
                                IS
    BEGIN
        UPDATE DB_SOPORTE.INFO_INCIDENCIA_DET SET TAREA_PROCESADA = Pn_TareaProcesada WHERE ID_DETALLE_INCIDENCIA = Pn_IncidenciaDet;

        INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(ID_SEGUIMIENTO, DETALLE_ID, OBSERVACION, USR_CREACION, FE_CREACION) 
               VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Pn_DetalleId,Pv_Observacion,'telcos',SYSDATE);

    END P_TAREA_PROCESADA;

    -- CONSULTAS WEBSERVICE VALIDACION

    PROCEDURE P_IDENTIFICACION_CLIENTE(
                                        Pv_IncidenciaDetNotObj  IN  INCIDENCIA_NOT_DETALLE_TYPE, 
                                        Pn_CodigoEmpresaTicket  IN  NUMBER,
                                        Pv_TimeStamp            IN  VARCHAR2,
                                        Pc_JsonClient           OUT CLOB,
                                        Pv_Message              OUT VARCHAR2)
        IS        

    --Costo 17    
    CURSOR C_CLIENTES_POR_IP(Cv_EstadoActivo VARCHAR2,Cv_EstadoActiva VARCHAR2,Cv_EstadoInCorte VARCHAR2,Cv_EstadoReservada VARCHAR2,Cv_ip VARCHAR2,Cv_EstadoEliminado VARCHAR2,Cv_EstadoCancelado VARCHAR2,Cv_EstadoCancel VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
            IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
            FROM DB_INFRAESTRUCTURA.INFO_IP IP 
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IP.SERVICIO_ID=ISE.ID_SERVICIO
            INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
            INNER JOIN DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
            INNER JOIN DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
            WHERE IP.ESTADO IN (Cv_EstadoActivo,Cv_EstadoActiva,Cv_EstadoInCorte,Cv_EstadoReservada) AND IP.IP=Cv_ip AND IPO.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel)
                  AND IPER.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel)
            ORDER BY IP.IP desc;
        --Costo 15    
        CURSOR C_CLIENTES_POR_LOGIN(Cv_estadoServicio VARCHAR2,
                                    Cv_login VARCHAR2, 
                                    Cv_EstadoEliminado VARCHAR2,
                                    Cv_EstadoCancelado VARCHAR2,
                                    Cv_EstadoCancel VARCHAR2)
        IS 
        SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
            IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
            FROM DB_COMERCIAL.INFO_PUNTO IPO
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IPO.ID_PUNTO=ISE.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
            INNER JOIN DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
            INNER JOIN DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
            WHERE IPO.LOGIN=Cv_login AND IPO.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel) AND ISE.ESTADO NOT IN (Cv_estadoServicio)
            AND IPER.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel);
    --Costo 13581        
    CURSOR C_RUTA_SUBRED(Cv_ip VARCHAR2, Cv_Eliminado VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
        IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
        FROM DB_INFRAESTRUCTURA.INFO_SUBRED  ISU
        INNER JOIN DB_INFRAESTRUCTURA.info_ruta_elemento IRE on IRE.SUBRED_ID=ISU.ID_SUBRED
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IRE.SERVICIO_ID=ISE.ID_SERVICIO 
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
        INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
        INNER JOIN DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
        INNER JOIN DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
        INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
        WHERE (ISU.GATEWAY = Cv_ip OR Cv_ip = (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.SUBRED,'/',1)) OR  
        DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',1)        = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',1) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',2)    = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',2) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',3)    = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',3)
        AND TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',4)) >= TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_INICIAL ,'.',4)) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',1)      = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',1) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',2)      = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',2) 
        AND DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',3)      = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',3)
        AND TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip,'.',4)) <=  TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISU.IP_FINAL ,'.',4)))
        AND ISU.ESTADO != Cv_Eliminado AND IRE.ESTADO != Cv_Eliminado AND ISU.SUBRED IS NOT NULL;

      CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
        IS
          SELECT APD.VALOR1,APD.VALOR2,
              APD.VALOR3,APD.VALOR4,APD.VALOR5,VALOR6,VALOR7,OBSERVACION
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.parametro_id =
            (SELECT APC.id_parametro
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.nombre_parametro = Cv_NombreParametro
            )
          AND APD.descripcion = Cv_DescripcionParametro;


        --Costo 384
        CURSOR C_RUTA_IP
        IS 
        SELECT IRE.RED_LAN,IRE.MASCARA_RED_LAN,IRE.SERVICIO_ID 
        FROM DB_INFRAESTRUCTURA.INFO_RUTA_ELEMENTO IRE
        WHERE IRE.ESTADO != 'Eliminado';    
    --Costo 43        
    CURSOR C_ES_CPE(Cv_ip VARCHAR2) 
    IS
    SELECT VSCPE.LOGIN 
    FROM
    (SELECT OFICINA.NOMBRE_OFICINA,
          NVL( PERSONA.RAZON_SOCIAL, CONCAT( PERSONA.NOMBRES, CONCAT(' ', PERSONA.APELLIDOS) ) ) AS CLIENTE,
          PUNTO.LOGIN,
          CANTON.REGION,
          JURISDICCION.NOMBRE_JURISDICCION AS OFICINA_COBERTURA,
          INFO_TECNICA_SERVICIO.IP         AS IP_INTERFACE,
          ELEMENTO.NOMBRE_ELEMENTO         AS NOMBRE_CPE,
          PRODUCTO.DESCRIPCION_PRODUCTO    AS MECANISMO,
          DETALLE_ELEMENTO.DETALLE_VALOR AS DESCRIPCION_ADMINISTRACION,
          INFO_TECNICA_SERVICIO.FE_CREACION AS FECHA_ACTIVACION,
          SERVICIO.ID_SERVICIO,
          SERVICIO.ESTADO AS ESTADO_SERVICIO,
          INFO_TECNICA_SERVICIO.ULTIMA_MILLA_ID,
          INFO_TECNICA_SERVICIO.CPE_DIRECTO,
          ROL_CLIENTE.DESCRIPCION_ROL,
          PERSONA.TIPO_IDENTIFICACION,
          PERSONA.IDENTIFICACION_CLIENTE,
          INFO_CONTACTO.CONTACTO_CLIENTE,
          INFO_CONTACTO.VALOR_CONTACTO_CLIENTE,
          INFO_CONTACTO.TIPO_CONTACTO,
          INFO_CONTACTO.FORMA_CONTACTO
        FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
        ON PUNTO.ID_PUNTO = SERVICIO.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
        ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER_CLIENTE
        ON IER_CLIENTE.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
        INNER JOIN DB_GENERAL.ADMI_ROL ROL_CLIENTE
        ON ROL_CLIENTE.ID_ROL = IER_CLIENTE.ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA
        ON OFICINA.ID_OFICINA = PER.OFICINA_ID
        INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
        ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
        INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
        ON CANTON.ID_CANTON = OFICINA.CANTON_ID
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
        ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
        ON PERSONA.ID_PERSONA = PER.PERSONA_ID
        INNER JOIN
          (SELECT INFO_SERVICIO_IP_ENLACE.SERVICIO_ID,
            INFO_SERVICIO_IP_ENLACE.ID_IP,
            INFO_SERVICIO_IP_ENLACE.IP,
            INFO_SERVICIO_IP_ENLACE.INTERFACE_ELEMENTO_CLIENTE_ID,
            INFO_SERVICIO_IP_ENLACE.ULTIMA_MILLA_ID,
            INFO_SERVICIO_IP_ENLACE.ELEMENTO_CLIENTE_ID,
            INFO_SERVICIO_IP_ENLACE.FE_CREACION,
            (
            CASE
              WHEN (INFO_SERVICIO_IP_ENLACE.CANTIDAD_ENLACES = 0)
              THEN INFO_SERVICIO_IP_ENLACE.ELEMENTO_CLIENTE_ID
              ELSE DB_COMERCIAL.COMEK_CONSULTAS.F_GET_ID_ELEMENTO_PRINCIPAL(INFO_SERVICIO_IP_ENLACE.INTERFACE_ELEMENTO_CLIENTE_ID,'CPE')
            END) AS ID_CPE,
        (
            CASE
              WHEN (INFO_SERVICIO_IP_ENLACE.CANTIDAD_ENLACES = 0)
              THEN 'SI'
              ELSE 'NO'
            END) AS CPE_DIRECTO
          FROM
            (SELECT SERVICIO_TECNICO.SERVICIO_ID,
              IP.ID_IP,
              IP.IP,
              SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID,
              SERVICIO_TECNICO.ULTIMA_MILLA_ID,
              SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID,
              IP.FE_CREACION,
              COUNT(ENLACE.ID_ENLACE) AS CANTIDAD_ENLACES
            FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO UM
            ON UM.ID_TIPO_MEDIO = SERVICIO_TECNICO.ULTIMA_MILLA_ID
            INNER JOIN DB_INFRAESTRUCTURA.INFO_IP IP
            ON IP.SERVICIO_ID = SERVICIO_TECNICO.SERVICIO_ID
            LEFT JOIN DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
            ON ENLACE.INTERFACE_ELEMENTO_INI_ID = SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID
            WHERE UM.CODIGO_TIPO_MEDIO         IN ('FO','RAD','UTP')
            AND IP.ESTADO = 'Activo'
            GROUP BY (SERVICIO_TECNICO.SERVICIO_ID, IP.ID_IP, IP.IP, SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID, 
                      SERVICIO_TECNICO.ULTIMA_MILLA_ID, SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID, IP.FE_CREACION)
            ) INFO_SERVICIO_IP_ENLACE
          ) INFO_TECNICA_SERVICIO ON INFO_TECNICA_SERVICIO.SERVICIO_ID = SERVICIO.ID_SERVICIO
        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
        ON ELEMENTO.ID_ELEMENTO = INFO_TECNICA_SERVICIO.ID_CPE
        INNER JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_ELEMENTO
        ON DETALLE_ELEMENTO.ELEMENTO_ID = ELEMENTO.ID_ELEMENTO 
        LEFT JOIN
          (SELECT PUNTO_CONTACTO.PUNTO_ID,
            PUNTO_CONTACTO.ID_PUNTO_CONTACTO,
            NVL( PERSONA_CONTACTO.RAZON_SOCIAL, CONCAT( PERSONA_CONTACTO.NOMBRES, CONCAT(' ', PERSONA_CONTACTO.APELLIDOS) ) ) AS CONTACTO_CLIENTE,
            PERSONA_F_CONTACTO.VALOR                                                                                          AS VALOR_CONTACTO_CLIENTE,
            ROL_CONTACTO.DESCRIPCION_ROL                                                                                      AS TIPO_CONTACTO,
            FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO                                                                         AS FORMA_CONTACTO
          FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO PUNTO_CONTACTO
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO PERSONA_F_CONTACTO
          ON PERSONA_F_CONTACTO.PERSONA_ID = PUNTO_CONTACTO.CONTACTO_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA_CONTACTO
          ON PERSONA_CONTACTO.ID_PERSONA = PERSONA_F_CONTACTO.PERSONA_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER_CONTACTO
          ON PER_CONTACTO.ID_PERSONA_ROL = PUNTO_CONTACTO.PERSONA_EMPRESA_ROL_ID
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER
          ON IER.ID_EMPRESA_ROL = PER_CONTACTO.EMPRESA_ROL_ID
          INNER JOIN DB_GENERAL.ADMI_ROL ROL_CONTACTO
          ON ROL_CONTACTO.ID_ROL = IER.ROL_ID
          INNER JOIN DB_GENERAL.ADMI_TIPO_ROL TIPO_ROL_CONTACTO
          ON TIPO_ROL_CONTACTO.ID_TIPO_ROL = ROL_CONTACTO.TIPO_ROL_ID
          INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
          ON FORMA_CONTACTO.ID_FORMA_CONTACTO            = PERSONA_F_CONTACTO.FORMA_CONTACTO_ID
          WHERE PUNTO_CONTACTO.ESTADO                    = 'Activo'
          AND PERSONA_F_CONTACTO.ESTADO                  = 'Activo'
          AND ROL_CONTACTO.DESCRIPCION_ROL               = 'Contacto Tecnico'
          AND TIPO_ROL_CONTACTO.DESCRIPCION_TIPO_ROL     = 'Contacto'
          AND FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO IN ('Correo Electronico', 'Telefono Fijo', 'Telefono Movil', 'Telefono Movil Claro', 
                                                            'Telefono Movil Movistar', 'Telefono Movil CNT')
          AND FORMA_CONTACTO.ESTADO                      = 'Activo'
          ) INFO_CONTACTO ON INFO_CONTACTO.PUNTO_ID      = PUNTO.ID_PUNTO
        WHERE SERVICIO.ESTADO                           IN ('Activo','In-Corte','EnPruebas')
        AND PRODUCTO.EMPRESA_COD                         = '10'
        AND DETALLE_ELEMENTO.ESTADO = 'Activo'
        AND DETALLE_NOMBRE = 'ADMINISTRA') VSCPE
        WHERE VSCPE.IP_INTERFACE=Cv_ip
        GROUP BY VSCPE.LOGIN;     

        --Costo 13
        CURSOR C_CLIENTES_POR_SERVICIO(Cn_ServicioId INTEGER,Cv_EstadoEliminado VARCHAR2,Cv_EstadoCancelado VARCHAR2,Cv_EstadoCancel VARCHAR2)
    IS 
    SELECT IPER.ID_PERSONA_ROL AS ID_PERSONA_ROL,AR.DESCRIPCION_ROL AS DESCRIPCION_ROL,IPO.LOGIN AS LOGIN,
            IEG.COD_EMPRESA AS COD_EMPRESA,ACO.JURISDICCION AS REGION,IPO.ID_PUNTO AS ID_PUNTO,ISE.ID_SERVICIO AS ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ISE 
            INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPO.PERSONA_EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
            INNER JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IER.EMPRESA_COD
            INNER JOIN  DB_GENERAL.ADMI_SECTOR  ASE ON ASE.ID_SECTOR=IPO.SECTOR_ID
            INNER JOIN  DB_GENERAL.ADMI_PARROQUIA APA ON APA.ID_PARROQUIA=ASE.PARROQUIA_ID 
            INNER JOIN DB_GENERAL.ADMI_CANTON ACO ON ACO.ID_CANTON=APA.CANTON_ID
            WHERE IPO.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel) AND IPER.ESTADO NOT IN (Cv_EstadoEliminado,Cv_EstadoCancelado,Cv_EstadoCancel) AND ISE.ID_SERVICIO = Cn_ServicioId;

      --Costo 13      
      CURSOR C_IP_BGP(Cv_ip VARCHAR2)   IS 
        SELECT  ISPC.SERVICIO_ID
        FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC 
        WHERE  ISPC.ESTADO NOT IN ('Cancel','Eliminado','Cancelado') AND 
        ISPC.PRODUCTO_CARACTERISITICA_ID=6778 AND
        (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',1)) = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',1) AND
        (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',2)) = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',2) AND
        (DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',3)) = DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',3) AND
        TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',4)) <= TO_NUMBER((DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',4)
        +(POWER(2,32-DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',2),'/',2))-1))) AND
        TO_NUMBER(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(Cv_ip ,'.',4)) >= TO_NUMBER((DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(DB_COMERCIAL.SPKG_OBTENER_CAJA_ANTERIOR.SPLIT(ISPC.VALOR ,'|',1) ,'.',4)));

          Ln_CodEmpresa                 INTEGER;
          Ln_EsCPE                      INTEGER;
          Ln_IdServicio                 INTEGER;
          Ln_IpValida                   INTEGER;
          Ln_ServicioIdBGP              INTEGER;
          Ln_BandRDA                    INTEGER := 0;

          Lv_fechaRDA                   VARCHAR2(400);
          Lv_horaRDA                    VARCHAR2(400);
          Lv_LoginRDA                   VARCHAR2(400);          
          Lv_status                     VARCHAR2(800);
          Lv_RespuestaRDACl             VARCHAR2(4000);
          Lv_DescripParametro           VARCHAR2(400);
          Lcl_JsonCliente               CLOB;
          Lr_InfoClienteRDA             C_CLIENTES_POR_LOGIN%ROWTYPE;
          Lr_InfoParamTarea             C_GET_PARAMETROS%ROWTYPE;
          Lv_NombreParametro            VARCHAR2(400) := 'PARAMETROS_ECUCERT';
          Lv_NombreSintoma              VARCHAR2(400);
          Lv_TituloInicial              VARCHAR2(400);
          Lv_VersionInicial             VARCHAR2(400);
          Lv_NombreHipotesis            VARCHAR2(400);
          Lv_NombreTarea                VARCHAR2(400);
          Lv_MotivoTarea                VARCHAR2(400);
          Lv_Observacion                VARCHAR2(400);
          Lv_NombreProceso              VARCHAR2(400);
          Lv_TipoAsig                   VARCHAR2(400);
          Lv_TipoCaso                   VARCHAR2(400);
          Lv_TipoAfectacion             VARCHAR2(400);
          Lv_ProcesoNoEncTelco          VARCHAR2(400);
          Lv_URLTenico                  VARCHAR2(400);
          Lv_URLSoporte                 VARCHAR2(400);
          Lv_URLCERT                    VARCHAR2(400);
          Lv_URLRDA                     VARCHAR2(800);
          Lv_URLToken                   VARCHAR2(800);
          Lv_URLNetworking              VARCHAR2(800);
          Lv_URLCERTCsoc                VARCHAR2(800);
          Lv_DescFormContact            VARCHAR2(400);
          Lv_Contacto                   VARCHAR2(400);
          Lv_FormaContacto              VARCHAR2(400);
          Lv_Asunto                     VARCHAR2(400);
          Lv_EstadoActual               VARCHAR2(400);
          Lv_TipoReprograma             VARCHAR2(400);
          Lv_URLCERTSg                  VARCHAR2(400);
          Lv_TareaRegNoEcontrado        VARCHAR2(400);
          Lv_TareaNoEncTelco            VARCHAR2(400);
          Lv_ProcesoSG                  VARCHAR2(400);
          Lv_TareaSG                    VARCHAR2(400);
          Lv_ProcesoIPCPE               VARCHAR2(400);
          Lv_TareaIPCPE                 VARCHAR2(400);
          Lv_ProcesoCSOC                VARCHAR2(400);
          Lv_TareaCSOC                  VARCHAR2(400);          
          Lv_URLCGNAT                   VARCHAR2(400);
          Lv_TareaRegMegadatos          VARCHAR2(400);
          Lv_ProcesoNoEncMega           VARCHAR2(400);


          Lv_ipAddressBusqCGNAT         VARCHAR2(800);          
          Lv_LoginCPE                   VARCHAR2(400);
          Lv_IdPersonaRol               VARCHAR2(200);
          Lv_DescripcionRol             VARCHAR2(400);
          Lv_Login                      VARCHAR2(400);
          Lv_Region                     VARCHAR2(400);
          Lv_IdPunto                    VARCHAR2(400);          
          Lv_IpRed                      VARCHAR2(800);
          Lv_MascaraRed                 VARCHAR2(800);                 
          Lv_EstadoAnalisis             VARCHAR2(400);
          Lv_EstadoNotif                VARCHAR2(400);
          Lv_EstadoNotifFallo           VARCHAR2(400);



          Lv_EstadoEliminado            VARCHAR2(400) := 'Eliminado';
          Lv_EstadoCancelado            VARCHAR2(400) := 'Cancelado';
          Lv_EstadoCancel               VARCHAR2(400) := 'Cancel';
          Lv_EstadoActivo               VARCHAR2(400) := 'Activo';
          Lv_EstadoActiva               VARCHAR2(400) := 'Activa';
          Lv_EstadoInCorte              VARCHAR2(400) := 'In-Corte';
          Lv_EstadoReservada            VARCHAR2(400) := 'Reservada';
          Lv_EstadoServicio             VARCHAR2(400) := 'Anulado';

          Lr_InfoClienteCPE             C_CLIENTES_POR_LOGIN%ROWTYPE;
          Lr_InfoClienteIp              C_CLIENTES_POR_IP%ROWTYPE;
          Lr_InfoClienteSubRed          C_RUTA_SUBRED%ROWTYPE;

          Lcl_MensajeError              CLOB;
          Lcl_JsonToken                 CLOB;
          Lcl_JsonClient                CLOB;       

    BEGIN
        Lv_LoginCPE         := NULL;
        Lr_InfoClienteCPE   := NULL;

        Lv_ipAddressBusqCGNAT := Pv_IncidenciaDetNotObj.Pv_ipAddress;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_NombreSintoma   := Lr_InfoParamTarea.VALOR1;
        Lv_TituloInicial   := Lr_InfoParamTarea.VALOR1;
        Lv_VersionInicial  := Lr_InfoParamTarea.VALOR1;
        Lv_NombreHipotesis := Lr_InfoParamTarea.VALOR2;
        Lv_NombreTarea     := Lr_InfoParamTarea.VALOR3;
        Lv_MotivoTarea     := Lr_InfoParamTarea.VALOR3;
        Lv_Observacion     := Lr_InfoParamTarea.VALOR3;
        Lv_NombreProceso   := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'PARAMETROS PARA ASIG TAREA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_TipoAsig         := Lr_InfoParamTarea.VALOR2;
        Lv_TipoCaso         := Lr_InfoParamTarea.VALOR3;
        Lv_TipoAfectacion   := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'PARAMETROS PARA ENVIAR CORREO';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_DescFormContact  := Lr_InfoParamTarea.VALOR1;
        Lv_Contacto         := Lr_InfoParamTarea.VALOR2;
        Lv_FormaContacto    := Lr_InfoParamTarea.VALOR3;
        Lv_Asunto           := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'URL ECUCERT';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_URLTenico        := Lr_InfoParamTarea.VALOR1;
        Lv_URLSoporte       := Lr_InfoParamTarea.VALOR2;
        Lv_URLCERT          := Lr_InfoParamTarea.VALOR3;
        Lv_URLRDA           := Lr_InfoParamTarea.VALOR4;
        Lv_URLToken         := Lr_InfoParamTarea.VALOR5;
        Lv_URLNetworking    := Lr_InfoParamTarea.VALOR6;
        Lv_URLCERTCsoc      := Lr_InfoParamTarea.VALOR7;
        Lv_URLCERTSg        := Lr_InfoParamTarea.OBSERVACION;

        Lv_DescripParametro := 'URL ECUCERT 2';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_URLCGNAT         := Lr_InfoParamTarea.VALOR1;

        Lv_DescripParametro := 'PARAMETROS PARA ESTADO INCIDENCIA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_EstadoAnalisis   := Lr_InfoParamTarea.VALOR3;
        Lv_EstadoNotif      := Lr_InfoParamTarea.VALOR4;
        Lv_EstadoNotifFallo := 'No '||Lv_EstadoNotif;

        Lv_DescripParametro := 'PARAMETROS_CASOS_SLA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_EstadoActual     := Lr_InfoParamTarea.VALOR1;  
        Lv_TipoReprograma   := Lr_InfoParamTarea.VALOR2;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA 2';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_ProcesoNoEncTelco    := Lr_InfoParamTarea.VALOR1;
        Lv_TareaNoEncTelco      := Lr_InfoParamTarea.VALOR2;
        Lv_ProcesoSG            := Lr_InfoParamTarea.VALOR3;
        Lv_TareaSG              := Lr_InfoParamTarea.VALOR4;
        Lv_ProcesoIPCPE         := Lr_InfoParamTarea.VALOR5;
        Lv_TareaIPCPE           := Lr_InfoParamTarea.VALOR6;
        Lv_ProcesoCSOC          := Lr_InfoParamTarea.VALOR7;
        Lv_TareaCSOC            := Lr_InfoParamTarea.OBSERVACION;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA 3';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_TareaRegNoEcontrado    := Lr_InfoParamTarea.VALOR1;
        Lv_TareaRegMegadatos      := Lr_InfoParamTarea.VALOR2;

        Lv_DescripParametro := 'PARAMETROS PARA CREAR TAREA MEGADATOS';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_ProcesoNoEncMega   := Lr_InfoParamTarea.VALOR2;



        Lcl_JsonToken    := '
            {
              "source": {
                "name": "APP.CERT",
                "originID": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'",
                "tipoOriginID": "IP"
                        },
              "user": "CERT",
              "gateway": "Authentication",
              "service": "Authentication",
              "method": "Authentication"
            }';

        IF Pn_CodigoEmpresaTicket = 10 THEN
            IF Pv_IncidenciaDetNotObj.Pv_BandCPE = 'S'
            THEN
                OPEN C_ES_CPE (Pv_IncidenciaDetNotObj.Pv_ipAddress);
                FETCH C_ES_CPE INTO Lv_LoginCPE;
                CLOSE C_ES_CPE;                  
                IF Lv_LoginCPE IS NOT NULL
                THEN
                    Ln_EsCPE := 1;
                    OPEN C_CLIENTES_POR_LOGIN (Lv_EstadoServicio,Lv_LoginCPE,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                    FETCH C_CLIENTES_POR_LOGIN INTO Lr_InfoClienteCPE;
                    CLOSE C_CLIENTES_POR_LOGIN;

                    IF Lr_InfoClienteCPE.ID_PERSONA_ROL IS NOT NULL
                        THEN
                        Lv_IdPersonaRol     := Lr_InfoClienteCPE.ID_PERSONA_ROL;
                        Lv_DescripcionRol   := Lr_InfoClienteCPE.DESCRIPCION_ROL;
                        Lv_Login            := Lr_InfoClienteCPE.LOGIN;
                        Ln_CodEmpresa       := Lr_InfoClienteCPE.COD_EMPRESA;
                        Lv_Region           := Lr_InfoClienteCPE.REGION;
                        Lv_IdPunto          := Lr_InfoClienteCPE.ID_PUNTO;
                        Ln_IdServicio       := Lr_InfoClienteCPE.ID_SERVICIO;

                    END IF;
                END IF;      
            END IF;
        ELSE
          IF Pv_IncidenciaDetNotObj.Pv_BandRDA = 'S' THEN
            Ln_BandRDA      := 1;
            Ln_CodEmpresa   := Pn_CodigoEmpresaTicket;
          END IF;        
        END  IF;
        IF Lv_LoginCPE IS NULL
        THEN
            OPEN C_CLIENTES_POR_IP (Lv_EstadoActivo,Lv_EstadoActiva,Lv_EstadoInCorte,Lv_EstadoReservada,Pv_IncidenciaDetNotObj.Pv_ipAddress,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
            FETCH C_CLIENTES_POR_IP INTO Lr_InfoClienteIp;
            CLOSE C_CLIENTES_POR_IP;

            Lv_IdPersonaRol     := Lr_InfoClienteIp.ID_PERSONA_ROL;
            Lv_DescripcionRol   := Lr_InfoClienteIp.DESCRIPCION_ROL;
            Lv_Login            := Lr_InfoClienteIp.LOGIN;
            Ln_CodEmpresa       := Lr_InfoClienteIp.COD_EMPRESA;
            Lv_Region           := Lr_InfoClienteIp.REGION;
            Lv_IdPunto          := Lr_InfoClienteIp.ID_PUNTO;
            Ln_IdServicio       := Lr_InfoClienteIp.ID_SERVICIO;


            IF (Lv_IdPersonaRol IS NULL)
            THEN
                FOR i IN C_RUTA_IP
                LOOP
                    Lv_IpRed        := regexp_replace(TRIM(i.RED_LAN), '(^[[:space:]]+)|([[:space:]]+$)',null);
                    Lv_MascaraRed   := regexp_replace(TRIM(i.MASCARA_RED_LAN), '(^[[:space:]]+)|([[:space:]]+$)',null);
                    P_MASCARA_IP(Lv_IpRed,Lv_MascaraRed,Pv_IncidenciaDetNotObj.Pv_ipAddress,Ln_IpValida,Lcl_MensajeError);
                    IF Ln_IpValida = 1
                    THEN
                        OPEN C_CLIENTES_POR_SERVICIO (i.SERVICIO_ID,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                        FETCH C_CLIENTES_POR_SERVICIO INTO Lr_InfoClienteIp;
                        CLOSE C_CLIENTES_POR_SERVICIO;
                        Lv_IdPersonaRol     := Lr_InfoClienteIp.ID_PERSONA_ROL;
                        Lv_DescripcionRol   := Lr_InfoClienteIp.DESCRIPCION_ROL;
                        Lv_Login            := Lr_InfoClienteIp.LOGIN;
                        Ln_CodEmpresa       := Lr_InfoClienteIp.COD_EMPRESA;
                        Lv_Region           := Lr_InfoClienteIp.REGION;
                        Lv_IdPunto          := Lr_InfoClienteIp.ID_PUNTO;
                        Ln_IdServicio       := Lr_InfoClienteIp.ID_SERVICIO;


                    END IF;
                END LOOP;
            END IF;
            IF (Lv_IdPersonaRol IS NULL)
            THEN
                OPEN C_RUTA_SUBRED (Pv_IncidenciaDetNotObj.Pv_ipAddress,Lv_EstadoEliminado);
                FETCH C_RUTA_SUBRED INTO Lr_InfoClienteSubRed;
                CLOSE C_RUTA_SUBRED;

                IF Lr_InfoClienteSubRed.ID_PERSONA_ROL IS NOT NULL
                THEN
                    Lv_IdPersonaRol     := Lr_InfoClienteSubRed.ID_PERSONA_ROL;
                    Lv_DescripcionRol   := Lr_InfoClienteSubRed.DESCRIPCION_ROL;
                    Lv_Login            := Lr_InfoClienteSubRed.LOGIN;
                    Ln_CodEmpresa       := Lr_InfoClienteSubRed.COD_EMPRESA;
                    Lv_Region           := Lr_InfoClienteSubRed.REGION;
                    Lv_IdPunto          := Lr_InfoClienteSubRed.ID_PUNTO;
                    Ln_IdServicio       := Lr_InfoClienteSubRed.ID_SERVICIO;

                END IF;
            END IF;
            IF (Lv_IdPersonaRol IS NULL)
            THEN
                OPEN C_IP_BGP (Pv_IncidenciaDetNotObj.Pv_ipAddress);
                FETCH C_IP_BGP INTO Ln_ServicioIdBGP;
                CLOSE C_IP_BGP;

                IF Ln_ServicioIdBGP IS NOT NULL
                THEN
                    OPEN C_CLIENTES_POR_SERVICIO (Ln_ServicioIdBGP,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                    FETCH C_CLIENTES_POR_SERVICIO INTO Lr_InfoClienteIp;
                    CLOSE C_CLIENTES_POR_SERVICIO;

                    Lv_IdPersonaRol     := Lr_InfoClienteIp.ID_PERSONA_ROL;
                    Lv_DescripcionRol   := Lr_InfoClienteIp.DESCRIPCION_ROL;
                    Lv_Login            := Lr_InfoClienteIp.LOGIN;
                    Ln_CodEmpresa       := Lr_InfoClienteIp.COD_EMPRESA;
                    Lv_Region           := Lr_InfoClienteIp.REGION;
                    Lv_IdPunto          := Lr_InfoClienteIp.ID_PUNTO;
                    Ln_IdServicio       := Lr_InfoClienteIp.ID_SERVICIO;

                END IF;
            END IF;          
        END IF;    
        IF (Lv_IdPersonaRol IS NULL AND Lv_ipAddressBusqCGNAT IS NOT NULL)
            THEN                                                                             
                Lv_fechaRDA    := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD');
                Lv_horaRDA     := TO_CHAR(TO_DATE(Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp, 'YYYY-MM-DD HH24:MI:SS'),'HH24:MI:SS');


                Lcl_JsonCliente :='{
                                    "empresa":"MD",
                                    "nombre_cliente":"",
                                    "login":"",
                                    "identificacion":"",
                                    "datos": 
                                            {
                                            "ip":       "'|| Lv_ipAddressBusqCGNAT ||'",
                                            "fecha":"'||Lv_fechaRDA||'",
                                            "hora_conexion":"'||Lv_horaRDA||'"
                                            },
                                    "opcion": "ECUCERT",
                                    "ejecutaComando":"SI",
                                    "usrCreacion": "'||Pv_IncidenciaDetNotObj.Pv_user||'",
                                    "ipCreacion": "'||Pv_IncidenciaDetNotObj.Pv_ipCreacion||'",
                                    "comandoConfiguracion":"SI"
                            }';

                P_CREAR_REQUEST (Lcl_JsonCliente,Lv_URLRDA,Lv_RespuestaRDACl,Lcl_MensajeError);
                P_RESPUESTA_RDA(Lv_RespuestaRDACl,Lv_Status,Lv_LoginRDA);

                OPEN C_CLIENTES_POR_LOGIN (Lv_EstadoServicio,Lv_LoginRDA,Lv_EstadoEliminado,Lv_EstadoCancelado,Lv_EstadoCancel);
                FETCH C_CLIENTES_POR_LOGIN INTO Lr_InfoClienteRDA;
                CLOSE C_CLIENTES_POR_LOGIN;

                IF Lr_InfoClienteRDA.ID_PERSONA_ROL IS NOT NULL
                    THEN
                    Lv_IdPersonaRol     := Lr_InfoClienteRDA.ID_PERSONA_ROL;
                    Lv_DescripcionRol   := Lr_InfoClienteRDA.DESCRIPCION_ROL;
                    Lv_Login            := Lr_InfoClienteRDA.LOGIN;
                    Ln_CodEmpresa       := Lr_InfoClienteRDA.COD_EMPRESA;
                    Lv_Region           := Lr_InfoClienteRDA.REGION;
                    Lv_IdPunto          := Lr_InfoClienteRDA.ID_PUNTO;
                    Ln_IdServicio       := Lr_InfoClienteRDA.ID_SERVICIO;


                END IF;   
        END IF;

        P_OBTIENE_CLIENTE(Lv_Login,Lcl_JsonClient,Pv_Message);
        Pc_JsonCLient := Lcl_JsonClient;

        EXCEPTION
          WHEN OTHERS THEN
            Pv_Message  :=  'ERROR P_OBTIENE_CLIENTE: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;       

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_IDENTIFICACION_CLIENTE',
                                             SUBSTR(SQLCODE || '  - ERROR_STACK:'||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || Pv_IncidenciaDetNotObj.Pv_feIncidenciaIp ,1,4000),
                                             'onavas',
                                             SYSDATE,
                                             '127.0.0.1'); 

    END P_IDENTIFICACION_CLIENTE;

    PROCEDURE P_OBTIENE_CLIENTE(                                        
                                        Pv_Login                IN VARCHAR2,
                                        Pcl_JsonCliente         OUT CLOB,
                                        Pv_ErrorMsj             OUT VARCHAR2)
                                        IS 
  --Costo 4
  CURSOR C_OBTIENE_SERVICIOS(CN_PUNTO NUMBER, CV_PARAMESTADO VARCHAR2) IS
        SELECT DISTINCT
         (CASE
            WHEN SS.PRODUCTO_ID IS NULL THEN (SELECT NOMBRE_PLAN FROM DB_COMERCIAL.INFO_PLAN_CAB WHERE ID_PLAN = SS.PLAN_ID)
            ELSE (SELECT DESCRIPCION_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO WHERE ID_PRODUCTO IN(PRODUCTO_ID))    
          END
         ) AS PRODUCTO_PLAN , COUNT(*) TOTAL           
        FROM DB_COMERCIAL.INFO_SERVICIO SS
        WHERE SS.PUNTO_ID IN (CN_PUNTO)
        AND UPPER(SS.ESTADO) IN (CV_PARAMESTADO) GROUP BY SS.PRODUCTO_ID,SS.PLAN_ID;
   --Costo 400     
   CURSOR C_OBTIENE_IP_HIST(Cn_ServicioId NUMBER, Cv_ParamEstado VARCHAR2) IS
      SELECT IPE.IP FROM DB_INFRAESTRUCTURA.INFO_IP IPE
        WHERE IPE.SERVICIO_ID = (Cn_ServicioId) 
        AND (UPPER(IPE.ESTADO) <>(Cv_ParamEstado) OR UPPER(IPE.ESTADO) IS NOT NULL)
      UNION
      SELECT IRE.RED_LAN FROM DB_INFRAESTRUCTURA.INFO_RUTA_ELEMENTO IRE
        WHERE IRE.SERVICIO_ID =(Cn_ServicioId)
        AND UPPER(IRE.ESTADO) <> (Cv_ParamEstado)
      UNION
      SELECT ISU.IP_DISPONIBLE FROM DB_INFRAESTRUCTURA.INFO_SUBRED ISU
        WHERE ISU.SUBRED_ID IN (Cn_ServicioId)
        AND UPPER(ISU.ESTADO) <>(Cv_ParamEstado)
      UNION
      SELECT regexp_substr(ISP.VALOR, '[^|]+', 1, 1) SPLIT FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISP
        WHERE ISP.PRODUCTO_CARACTERISITICA_ID IN (6778)
        AND ISP.SERVICIO_ID IN (Cn_ServicioId)
        AND (UPPER(ISP.ESTADO) <>(Cv_ParamEstado) OR ISP.ESTADO <>'A'); 
  --Costo 16
  CURSOR C_OBTIENE_ING_VIP(Cn_PerEmpRolId NUMBER , Cv_ParamEstado VARCHAR2) IS
            SELECT pemprolc.valor, pervip.NOMBRES || ' ' || pervip.APELLIDOS as nombre_ingvip , perfc.VALOR AS CORREO            
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC pemprolc
            JOIN DB_COMERCIAL.ADMI_CARACTERISTICA carac on pemprolc.CARACTERISTICA_ID=carac.ID_CARACTERISTICA
            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL peremprolvip on COALESCE(TO_NUMBER(REGEXP_SUBSTR(pemprolc.valor,'^\d+')),0)=peremprolvip.ID_PERSONA_ROL
            JOIN DB_COMERCIAL.info_persona pervip on (peremprolvip.PERSONA_ID)=(pervip.ID_PERSONA)
            JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO perfc on pervip.ID_PERSONA=perfc.PERSONA_ID 
            JOIN ADMI_FORMA_CONTACTO FC on perfc.FORMA_CONTACTO_ID = FC.ID_FORMA_CONTACTO 
            WHERE carac.DESCRIPCION_CARACTERISTICA='ID_VIP' 
            AND pemprolc.PERSONA_EMPRESA_ROL_ID = Cn_PerEmpRolId
            AND ROWNUM = 1
            AND UPPER(FC.DESCRIPCION_FORMA_CONTACTO) IN ('CORREO ELECTRONICO') 
            AND UPPER(fc.ESTADO) IN (Cv_ParamEstado);
  --Costo 18
  CURSOR C_OBTIENE_CONTACTO(Cn_PuntoId NUMBER, Cv_Estado VARCHAR2)  IS
          SELECT distinct(IPFC.VALOR) AS CONTACTO, AFC.DESCRIPCION_FORMA_CONTACTO AS FORMA_CONTACTO, 
          IPC.ESTADO AS ESTADO, IPFC.PERSONA_ID, IPE.NOMBRES||' '||IPE.APELLIDOS AS NOMBRE_CONTACTO, IPC.punto_id AS PUNTO
          FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO IPC
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC on IPFC.PERSONA_ID = IPC.CONTACTO_ID
          INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC ON IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER2 ON IPER2.PERSONA_ID = IPC.CONTACTO_ID
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IPER2.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
          INNER JOIN DB_GENERAL.ADMI_ROL AR ON IER.ROL_ID = AR.ID_ROL
          INNER JOIN DB_COMERCIAL.INFO_PERSONA IPE ON  IPE.ID_PERSONA = IPFC.PERSONA_ID
          WHERE IPC.punto_id IN (Cn_PuntoId)
          AND UPPER(IPC.estado) IN (Cv_Estado)
          AND UPPER(AR.DESCRIPCION_ROL) IN ('CONTACTO TECNICO');  
  -- Costo 9             
  CURSOR C_IDENTIFICA_CLIENTE(Cv_Login VARCHAR2, Cv_ParamEstado VARCHAR2) IS
        SELECT  PT.LOGIN, PT.ID_PUNTO, PE.ID_PERSONA, PE.IDENTIFICACION_CLIENTE,
        (CASE 
          WHEN PE.TIPO_EMPRESA IS NOT NULL THEN PE.RAZON_SOCIAL
          ELSE PE.NOMBRES ||' '|| PE.APELLIDOS 
          END) AS NOMBRE_CLIENTE,
        CC.PERSONA_EMPRESA_ROL_ID,
        TN.NOMBRE_TIPO_NEGOCIO, 
        (SELECT COUNT(*) FROM DB_COMERCIAL.INFO_PUNTO PT
         WHERE PT.PERSONA_EMPRESA_ROL_ID IN (SELECT PT.PERSONA_EMPRESA_ROL_ID FROM DB_COMERCIAL.INFO_PUNTO PT
                                          WHERE PT.LOGIN IN (Cv_login))
         AND UPPER(PT.ESTADO) IN ('ACTIVO')) AS TOTAL_PUNTOS, 
        (SELECT JU.DESCRIPCION_JURISDICCION 
              FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION JU
              WHERE JU.ID_JURISDICCION IN (SELECT PPT.PUNTO_COBERTURA_ID 
                                        FROM DB_COMERCIAL.INFO_PUNTO PPT 
                                        WHERE PPT.LOGIN IN(Cv_Login))) AS OFICINA,          
        (SELECT CAN.REGION
                FROM DB_COMERCIAL.ADMI_CANTON CAN
                INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFI ON CAN.ID_CANTON = OFI.CANTON_ID
                INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JU ON JU.OFICINA_ID = OFI.ID_OFICINA
                INNER JOIN DB_COMERCIAL.INFO_PUNTO PT ON PT.PUNTO_COBERTURA_ID = JU.ID_JURISDICCION
                WHERE PT.LOGIN IN (Cv_Login)) AS JURISDICCION , 
        ( SELECT DISTINCT(NOMBRES||' '||APELLIDOS) AS VENDEDOR_TEMP
          FROM DB_COMERCIAL.INFO_PERSONA 
          WHERE LOGIN IN (SELECT PT.USR_VENDEDOR 
                          FROM DB_COMERCIAL.INFO_PUNTO PT
                          WHERE PT.LOGIN IN (Cv_Login)  
                          AND UPPER(PT.ESTADO) IN (Cv_ParamEstado))) AS VENDEDOR,
        (SELECT 
         CASE 
          WHEN SAL.SALDO <1000 THEN 'RANGO 1'
          WHEN SAL.SALDO BETWEEN  1000 AND 4999 THEN 'RANGO 2'
          WHEN SAL.SALDO BETWEEN  5000 AND 9999 THEN 'RANGO 3'
          WHEN SAL.SALDO BETWEEN 10000 AND 19999 THEN 'RANGO 4'
          WHEN SAL.SALDO BETWEEN 20000 AND 49999 THEN 'RANGO 5'
          WHEN SAL.SALDO BETWEEN 50000 AND 99999 THEN 'RANGO 6'
          WHEN SAL.SALDO BETWEEN 100000 AND 499999 THEN 'RANGO 7'
          ELSE 'RANGO 8'       
         END
        FROM DB_COMERCIAL.INFO_PUNTO_SALDO SAL
        WHERE SAL.PUNTO_ID IN(PT.ID_PUNTO)) AS RANGO ,
        (SELECT MIN(HI.FE_CREACION) FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL HI
          INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISO ON ISO.ID_SERVICIO = HI.SERVICIO_ID
          INNER JOIN DB_COMERCIAL.INFO_PUNTO PP ON PP.ID_PUNTO = ISO.PUNTO_ID
          WHERE UPPER(HI.ESTADO) IN (Cv_ParamEstado)
          AND PP.LOGIN IN(Cv_Login)) AS FEC_CREACION
        FROM INFO_PUNTO PT 
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL CC ON CC.ID_PERSONA_ROL = PT.PERSONA_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA PE ON CC.PERSONA_ID = PE.ID_PERSONA                   
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO TN on TN.ID_TIPO_NEGOCIO = PT.TIPO_NEGOCIO_ID
        WHERE PT.LOGIN IN (Cv_Login);        

   Lv_Login                      VARCHAR2(400); 
   Lv_TipoNegocio                VARCHAR2(800);   
   Lv_NombreCliente              VARCHAR2(400);
   Lv_Jurisdiccion               VARCHAR2(400);
   Lv_FecCreacion                VARCHAR2(200);
   Lv_Rango                      VARCHAR2(200);
   Lv_Vendedor                   VARCHAR2(400); 
   Lv_Oficina                    VARCHAR2(400);
   Lv_BanderaVip                 VARCHAR2(200);
   Lv_ParamEstado                VARCHAR2(200):= 'ACTIVO';
   Ln_PerEmpRolId                INTEGER; 
   Ln_IdPersona                  INTEGER;
   Ln_totalPuntos                INTEGER;
   Ln_PuntoId                    INTEGER;   
   Lr_InfoClienteData            C_IDENTIFICA_CLIENTE%ROWTYPE;
   Lr_InfoIngVip                 C_OBTIENE_ING_VIP%ROWTYPE;
   Lr_InfoContacto               C_OBTIENE_CONTACTO%ROWTYPE;   
   Lcl_JsonCliente               CLOB;   
   Lcl_JsonIngVip                CLOB;
   Lcl_JsonConTec                CLOB;
   Lcl_JsonIpHist                CLOB;
   Lcl_jsonServicios             CLOB;    

   BEGIN

   IF C_IDENTIFICA_CLIENTE%ISOPEN THEN                  
      CLOSE C_IDENTIFICA_CLIENTE;
   END IF;

   IF Pv_Login IS NOT NULL THEN  

          OPEN C_IDENTIFICA_CLIENTE(Pv_Login,Lv_ParamEstado);
          FETCH C_IDENTIFICA_CLIENTE INTO Lr_InfoClienteData;
          CLOSE C_IDENTIFICA_CLIENTE;

          Lv_Login                      := Lr_InfoClienteData.LOGIN;          
          Lv_TipoNegocio                := Lr_InfoClienteData.NOMBRE_TIPO_NEGOCIO;
          Ln_PerEmpRolId                := Lr_InfoClienteData.PERSONA_EMPRESA_ROL_ID;
          Lv_NombreCliente              := Lr_InfoClienteData.NOMBRE_CLIENTE;
          Ln_IdPersona                  := Lr_InfoClienteData.ID_PERSONA;
          Ln_totalPuntos                := Lr_infoClienteData.TOTAL_PUNTOS;
          Ln_PuntoId                    := Lr_InfoClienteData.ID_PUNTO;
          Lv_Jurisdiccion               := Lr_InfoClienteData.JURISDICCION; 
          Lv_FecCreacion                := Lr_InfoClienteData.FEC_CREACION;
          Lv_Rango                      := Lr_InfoClienteData.RANGO;
          Lv_Vendedor                   := Lr_InfoClienteData.VENDEDOR;
          Lv_Oficina                    := Lr_InfoClienteData.OFICINA;

          Lcl_jsonServicios := '[';                    

          IF Ln_PuntoId IS NOT NULL THEN
            IF C_OBTIENE_SERVICIOS%ISOPEN THEN                  
                CLOSE C_OBTIENE_SERVICIOS;
            END IF;

            IF C_OBTIENE_IP_HIST%ISOPEN THEN                  
                CLOSE C_OBTIENE_IP_HIST;
            END IF;

            FOR Lr_listaServicios IN C_OBTIENE_SERVICIOS(Ln_PuntoId,Lv_ParamEstado)     
              LOOP            
                Lcl_jsonServicios :=   Lcl_jsonServicios||'{
                                    "producto_plan":"'||Lr_listaServicios.PRODUCTO_PLAN||'",                                   
                                    "cantidad":"'||Lr_listaServicios.TOTAL||'"},';
                Lcl_JsonIpHist :='[]';            
              END LOOP;                 
          ELSE
              Lcl_JsonIpHist :='[]';                  
          END IF;

          Lcl_jsonServicios := Lcl_jsonServicios||']';
          SELECT REPLACE(Lcl_jsonServicios, ',]', ']') INTO Lcl_jsonServicios FROM DUAL;  

          IF Lcl_jsonServicios = '[]' THEN
              Lcl_JsonIpHist :='[]';
          END IF;

          IF C_OBTIENE_ING_VIP%ISOPEN THEN
            CLOSE C_OBTIENE_ING_VIP;
          END IF;

          OPEN C_OBTIENE_ING_VIP(Ln_PerEmpRolId, Lv_ParamEstado);
          FETCH C_OBTIENE_ING_VIP INTO Lr_InfoIngVip;
          CLOSE C_OBTIENE_ING_VIP;

          IF C_OBTIENE_CONTACTO%ISOPEN THEN
            CLOSE C_OBTIENE_CONTACTO;
          END IF;

          OPEN  C_OBTIENE_CONTACTO(Ln_PuntoId, Lv_ParamEstado);
          FETCH C_OBTIENE_CONTACTO INTO Lr_InfoContacto;
          CLOSE C_OBTIENE_CONTACTO;

          Lcl_JsonConTec :='[';
          FOR Lr_InfoContacto IN C_OBTIENE_CONTACTO(Ln_PuntoId,Lv_ParamEstado)     
          LOOP

            Lcl_JsonConTec :=   Lcl_JsonConTec||'{
                                    "contacto":"'||Lr_InfoContacto.CONTACTO||'",
                                    "forma_contacto":"'||Lr_InfoContacto.FORMA_CONTACTO||'",
                                    "contacto_tecnico":"'||Lr_InfoContacto.NOMBRE_CONTACTO||'",
                                    "punto":"'||Lr_InfoContacto.PUNTO||'"},';
          END LOOP;  
          Lcl_JsonConTec := Lcl_JsonConTec||']';
          SELECT REPLACE(Lcl_JsonConTec, ',]', ']') INTO Lcl_JsonConTec FROM DUAL;             

          IF Lr_InfoIngVip.valor IS NULL THEN
            Lv_BanderaVip :='"tiene_vip":false,';
            Lcl_JsonIngVip :='[]';
          ELSE
            Lv_BanderaVip :='"tiene_vip":true,';
            FOR Lr_InfoIngVip IN C_OBTIENE_ING_VIP(Ln_PerEmpRolId, Lv_ParamEstado)     
            LOOP            
              Lcl_JsonIngVip :=  Lcl_JsonIngVip||'[{ "nombre_ingvip":"'||Lr_InfoIngVip.nombre_ingvip||'",'
                                  ||'"correo":"'||Lr_InfoIngVip.correo||'"},';
            END LOOP;     
            SELECT REPLACE(Lcl_JsonIngVip, '},', '}') INTO Lcl_JsonIngVip FROM DUAL;   
            Lcl_JsonIngVip := Lcl_JsonIngVip||']';
          END IF;

          Lcl_JsonCliente := '{"nombre_cliente":"'||Lv_NombreCliente||'","login_cliente":"'||Lv_Login||'",'
          ||'"jurisdiccion":"'||Lv_Jurisdiccion||'","punto_cobertura":"'||Lv_Oficina||'",'
          ||'"contacto_tecnico":'||Lcl_JsonConTec||','
          ||Lv_BanderaVip||'"ingeniero_vip":'||Lcl_JsonIngVip||','
          ||'"vendedor":"'||Lv_Vendedor||'","fecha_activacion":"'||Lv_FecCreacion||'",'
          ||'"servicios_contratados":'||Lcl_jsonServicios||','
          ||'"tipo_cliente:":"'||Lv_TipoNegocio||'","cantidad_puntos":"'||Ln_totalPuntos||'",'
          ||'"volumen_facturacion":"'||Lv_Rango||'","historial_ips":'||Lcl_JsonIpHist||'},'; 

   ELSE
          Lcl_JsonCliente :='{},';
   END IF; 

   Pcl_JsonCliente:= Lcl_JsonCliente;


   EXCEPTION 
    WHEN  OTHERS THEN 

      Pv_ErrorMsj := 'ERROR P_OBTIENE_CLIENTE: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
      DBmS_OUTPUT.PUT_LINE(Pv_ErrorMsj);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_OBTIENE_CLIENTE',
                                             SQLCODE || '  - ERROR_STACK:'||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             'onavas',
                                             SYSDATE,
                                             '127.0.0.1'); 

   END P_OBTIENE_CLIENTE;  


   PROCEDURE P_IDENTIFICA_IP( 
                                        Pv_IpRequest         IN VARCHAR2, 
                                        Pv_originID          IN VARCHAR2,
                                        Pv_TimeStamp         IN VARCHAR2,
                                        Pv_User              IN VARCHAR2,
                                        Pcl_JsonResponse     OUT CLOB,
                                        Pv_ErrorMsj          OUT VARCHAR2) 
                                        IS 

   Lv_IP                      VARCHAR2(200);
   Lv_ipCreacion              VARCHAR2(20);   
   Lv_IncidenciaDetNotObj     INCIDENCIA_NOT_DETALLE_TYPE;
   Lcl_MensajeError           CLOB;
   Lcl_JsonResponse           CLOB;
   Lcl_TempReponse            CLOB;

   BEGIN
     Lv_ipCreacion    := Pv_originID;  
     Lv_IP            := Pv_IpRequest;
     Lcl_JsonResponse := '';

      Lv_IncidenciaDetNotObj   := INCIDENCIA_NOT_DETALLE_TYPE(Lv_IP,
                                          null,
                                          Lv_ipCreacion,
                                          Pv_TimeStamp,
                                          Pv_User,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null, 
                                          null,
                                          null,
                                          null);
     P_IDENTIFICACION_CLIENTE(Lv_IncidenciaDetNotObj,10,Pv_TimeStamp,Lcl_JsonResponse,Lcl_MensajeError);       

     IF Lcl_MensajeError IS NOT NULL THEN
      Lcl_MensajeError := '{"status":"Error","mensaje":"ip fallida '||Pv_IpRequest||' - '||SQLERRM||'","data":[]}';
     END IF;
     Lcl_TempReponse := '{"status":"OK","mensaje":"'||Lcl_MensajeError||'","data":[' ||Lcl_JsonResponse||']}';
     SELECT REPLACE(Lcl_TempReponse, ',]', ']') INTO Lcl_TempReponse FROM DUAL;
     Pv_ErrorMsj :=  Lcl_MensajeError;
     Pcl_JsonResponse :=  Lcl_TempReponse;

   EXCEPTION 

     WHEN VALUE_ERROR THEN
        Pv_ErrorMsj := '{"status":"Error","mensaje":"ip fallida '||Pv_IpRequest||' - '||SQLERRM||'","data":[]}';
      WHEN OTHERS THEN     
        Pv_ErrorMsj := '{"status":"Error","mensaje":"ip fallida '||Pv_IpRequest||' - '||SQLERRM||'","data":[]}';

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_IDENTIFICA_IP',
                                             SQLCODE || 'ip: '||Pv_IpRequest||' - ERROR_STACK:'||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             'onavas',
                                             SYSDATE,
                                             '127.0.0.1'); 
   END P_IDENTIFICA_IP;   

   PROCEDURE P_CREAR_CASO( 
                          Pv_Login               IN VARCHAR2,
                          Pn_IdPunto             IN INTEGER,
                          Pn_CodEmpresa          IN INTEGER,
                          Pv_CasoEcucertObj      OUT  CREAR_CASO_ECUCERT_TYPE)
                          IS 
    Ln_idCaso               INTEGER := NULL;
    Ln_idCasoHistorial      INTEGER;
    Ln_idDocumento          INTEGER;
    Ln_idComunicacion       INTEGER;
    Ln_idDocuComunicacion   INTEGER;
    Ln_idDetalleHipotesis   INTEGER;
    Ln_idDetalle            INTEGER;
    Ln_idCriterioAfectado   INTEGER;
    Ln_idParteAfectada      INTEGER;
    Ln_idDetalleCaAsig      INTEGER;
    Ln_idComunicacionCaSig  INTEGER;
    Ln_idCasoHistorialAsig  INTEGER;
    Ln_idCasoAsignacion     INTEGER;
    Ln_idCasoDocumentoAsig  INTEGER;
    Ln_idDocuComunicaAsig   INTEGER;
    Lv_NumeroCaso           VARCHAR2(200) := 'N';                     
   BEGIN
     -- Crear Caso
      WHILE Ln_idCaso IS NULL
      LOOP
          DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_GENERAR_NUMERO_CASO(Lv_NumeroCaso,Ln_idCaso);
      END LOOP;

      INSERT INTO DB_SOPORTE.INFO_CASO_HISTORIAL (ID_CASO_HISTORIAL,CASO_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_CASO_HISTORIAL.NEXTVAL,Ln_idCaso,'Creado','telcos','127.0.0.1')
      RETURNING ID_CASO_HISTORIAL INTO Ln_idCasoHistorial;

      INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO (ID_DOCUMENTO,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL,'Activo','telcos','127.0.0.1')
      RETURNING ID_DOCUMENTO INTO Ln_idDocumento;

      INSERT INTO DB_COMUNICACION.INFO_COMUNICACION (ID_COMUNICACION,CASO_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL,Ln_idCaso,'Activo','telcos','127.0.0.1')
      RETURNING ID_COMUNICACION INTO Ln_idComunicacion;

      INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION (ID_DOCUMENTO_COMUNICACION, DOCUMENTO_ID, COMUNICACION_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL,Ln_idDocumento,Ln_idComunicacion,'Activo','telcos','127.0.0.1')
      RETURNING ID_DOCUMENTO_COMUNICACION INTO Ln_idDocuComunicacion;

      INSERT INTO DB_SOPORTE.INFO_DETALLE_HIPOTESIS (ID_DETALLE_HIPOTESIS,CASO_ID) 
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_HIPOTESIS.NEXTVAL,Ln_idCaso)
      RETURNING ID_DETALLE_HIPOTESIS INTO Ln_idDetalleHipotesis;

      INSERT INTO DB_SOPORTE.INFO_DETALLE (ID_DETALLE,PESO_PRESUPUESTADO,VALOR_PRESUPUESTADO,DETALLE_HIPOTESIS_ID,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL,0,0,Ln_idDetalleHipotesis,'telcos','127.0.0.1')
      RETURNING ID_DETALLE INTO Ln_idDetalle;

      INSERT INTO INFO_CRITERIO_AFECTADO (FE_CREACION, IP_CREACION, ID_CRITERIO_AFECTADO, CRITERIO, OPCION, USR_CREACION, DETALLE_ID) 
      VALUES (SYSDATE, '127.0.0.1', 1, 'Clientes', 'Cliente: '||Pv_Login||' | OPCION: Punto Cliente', 'telcos', Ln_idDetalle)
      RETURNING ID_CRITERIO_AFECTADO INTO Ln_idCriterioAfectado;

      INSERT INTO DB_SOPORTE.INFO_PARTE_AFECTADA (ID_PARTE_AFECTADA,DETALLE_ID,CRITERIO_AFECTADO_ID,AFECTADO_ID,TIPO_AFECTADO,AFECTADO_NOMBRE,FE_INI_INCIDENCIA,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_PARTE_AFECTADA.NEXTVAL,Ln_idDetalle,1,Pn_IdPunto,'Cliente',Pv_Login,SYSDATE,'telcos','127.0.0.1')
      RETURNING ID_PARTE_AFECTADA INTO Ln_idParteAfectada;

      -- Asignacion Caso
      INSERT INTO DB_SOPORTE.INFO_DETALLE (ID_DETALLE,PESO_PRESUPUESTADO,VALOR_PRESUPUESTADO,DETALLE_HIPOTESIS_ID,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL,0,0,Ln_idDetalleHipotesis,'telcos','127.0.0.1')
      RETURNING ID_DETALLE INTO Ln_idDetalleCaAsig;

      INSERT INTO DB_COMUNICACION.INFO_COMUNICACION (ID_COMUNICACION,CASO_ID,DETALLE_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL,Ln_idCaso,Ln_idDetalleCaAsig,'Activo','telcos','127.0.0.1')
      RETURNING ID_COMUNICACION INTO Ln_idComunicacionCaSig;

      INSERT INTO DB_SOPORTE.INFO_CASO_HISTORIAL (ID_CASO_HISTORIAL,CASO_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_CASO_HISTORIAL.NEXTVAL,Ln_idCaso,'Asignado','telcos','127.0.0.1')
      RETURNING ID_CASO_HISTORIAL INTO Ln_idCasoHistorialAsig;

      INSERT INTO DB_SOPORTE.INFO_CASO_ASIGNACION (ID_CASO_ASIGNACION,DETALLE_HIPOTESIS_ID,ASIGNADO_ID,ASIGNADO_NOMBRE,REF_ASIGNADO_ID,REF_ASIGNADO_NOMBRE,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_CASO_ASIGNACION.NEXTVAL,Ln_idDetalleHipotesis,0,'ECUCERT',0,'ECUCERT','telcos','127.0.0.1')
      RETURNING ID_CASO_ASIGNACION INTO Ln_idCasoAsignacion;

      INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO (ID_DOCUMENTO,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL,'Activo','telcos','127.0.0.1')
      RETURNING ID_DOCUMENTO INTO Ln_idCasoDocumentoAsig;

      INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION (ID_DOCUMENTO_COMUNICACION, DOCUMENTO_ID, COMUNICACION_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL,Ln_idCasoDocumentoAsig,Ln_idComunicacionCaSig,'Activo','telcos','127.0.0.1')
      RETURNING ID_DOCUMENTO_COMUNICACION INTO Ln_idDocuComunicaAsig;

      COMMIT;

      Pv_CasoEcucertObj := CREAR_CASO_ECUCERT_TYPE (Ln_idCaso,
                                                    Ln_idCasoHistorial,
                                                    Ln_idDocumento,
                                                    Ln_idComunicacion,
                                                    Ln_idDocuComunicacion,
                                                    Ln_idDetalleHipotesis,
                                                    Ln_idDetalle,
                                                    Ln_idCriterioAfectado,
                                                    Ln_idParteAfectada,
                                                    Ln_idDetalleCaAsig,
                                                    Ln_idComunicacionCaSig,
                                                    Ln_idCasoHistorialAsig,
                                                    Ln_idCasoAsignacion,
                                                    Ln_idCasoDocumentoAsig,
                                                    Ln_idDocuComunicaAsig);

   EXCEPTION 
   WHEN OTHERS THEN   
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_CASO',
                                            SQLCODE || ' - ERROR_STACK:'||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1'); 
   END P_CREAR_CASO; 


   PROCEDURE P_CREAR_TAREA(
                          Pn_idComunicacionTarea  OUT INTEGER,
                          Pn_idDetalleTarea       OUT INTEGER,
                          Pn_idTareaDocumentoAsig OUT INTEGER,
                          Pn_idDocuComuAsigTarea  OUT INTEGER,
                          Pn_idDetalleAsigTarea   OUT INTEGER,
                          Pn_idDetalleHistTarea   OUT INTEGER,
                          Pn_idTareaSeguiTarea    OUT INTEGER)
                          IS                                      
   BEGIN
      -- Crear Tarea
      INSERT INTO DB_COMUNICACION.INFO_COMUNICACION (ID_COMUNICACION,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL,'Activo','telcos','127.0.0.1')
      RETURNING ID_COMUNICACION INTO Pn_idComunicacionTarea;

      INSERT INTO DB_SOPORTE.INFO_DETALLE (ID_DETALLE,PESO_PRESUPUESTADO,VALOR_PRESUPUESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL,0,0,'telcos','127.0.0.1')
      RETURNING ID_DETALLE INTO Pn_idDetalleTarea;

      --Asignar Tarea
      INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO (ID_DOCUMENTO,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL,'Activo','telcos','127.0.0.1')
      RETURNING ID_DOCUMENTO INTO Pn_idTareaDocumentoAsig;

      INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION (ID_DOCUMENTO_COMUNICACION, DOCUMENTO_ID, COMUNICACION_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL,Pn_idTareaDocumentoAsig,Pn_idComunicacionTarea,'Activo','telcos','127.0.0.1')
      RETURNING ID_DOCUMENTO_COMUNICACION INTO Pn_idDocuComuAsigTarea;

      INSERT INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION (ID_DETALLE_ASIGNACION,DETALLE_ID,ASIGNADO_ID,ASIGNADO_NOMBRE,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL,Pn_idDetalleTarea,0,'ECUCERT','telcos','127.0.0.1')
      RETURNING ID_DETALLE_ASIGNACION INTO Pn_idDetalleAsigTarea;

      INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL (ID_DETALLE_HISTORIAL,DETALLE_ID,ESTADO,USR_CREACION,IP_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,Pn_idDetalleTarea,'Asignada','telcos','127.0.0.1')
      RETURNING ID_DETALLE_HISTORIAL INTO Pn_idDetalleHistTarea;

      INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO (ID_SEGUIMIENTO,DETALLE_ID,USR_CREACION) 
      VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,Pn_idDetalleTarea,'telcos')
      RETURNING ID_SEGUIMIENTO INTO Pn_idTareaSeguiTarea;  

      COMMIT;

   EXCEPTION 
   WHEN OTHERS THEN   
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_TAREA',
                                            SQLCODE || ' - ERROR_STACK:'||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1'); 
   END P_CREAR_TAREA; 

 PROCEDURE P_GENERAR_NUMERO_CASO(Pv_NumeroCaso IN OUT VARCHAR2,
                                   Pn_IdCaso     OUT INTEGER)
   IS    

    Lv_TipoCaso  VARCHAR2(400) := 'Tecnico'; 
    Lv_NumeroCaso  VARCHAR2(200);
    Lv_Status    VARCHAR2(200);
    Lv_Mensaje   VARCHAR2(200);
    Ln_NumeroCasoBase   VARCHAR2(400) := 'N';  

   BEGIN

    WHILE Pv_NumeroCaso = Ln_NumeroCasoBase
    LOOP

        SPKG_CASOS_INSERT_TRANSACCION.P_OBTENER_NUMERO_CASO(Lv_TipoCaso, Lv_NumeroCaso, Lv_Status, Lv_Mensaje);
        Pv_NumeroCaso := Lv_NumeroCaso;
    END LOOP;
    IF Pv_NumeroCaso != 'N' THEN
      INSERT INTO DB_SOPORTE.INFO_CASO (ID_CASO,EMPRESA_COD,TIPO_CASO_ID,FORMA_CONTACTO_ID,NIVEL_CRITICIDAD_ID,NUMERO_CASO) 
      VALUES (DB_SOPORTE.SEQ_INFO_CASO.NEXTVAL,10,1,5,1,Pv_NumeroCaso)

      RETURNING ID_CASO INTO Pn_IdCaso;
      COMMIT;
    END IF;
    COMMIT;
   EXCEPTION 
   WHEN OTHERS THEN  
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INCIDENCIA_ECUCERT',
                                           'P_GENERAR_NUMERO_CASO',
                                            SUBSTR('ERROR EN JOB '||SQLERRM,1,4000),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    Pv_NumeroCaso   := 'N'; 
    Pn_IdCaso   := NULL;
   END P_GENERAR_NUMERO_CASO;

   PROCEDURE P_NOTIFICACION_CIERRE_CASO(
                                  Pv_Nombre_Proceso IN  VARCHAR2,
                                  Pv_NumeroTicket   IN  VARCHAR2, 
                                  Pv_ipCreacion     IN  VARCHAR2,
                                  Pv_user           IN  VARCHAR2,
                                  Pv_MensajeError   OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2) IS
    CURSOR C_GETMASTAREAS(Cv_casoID VARCHAR2, Cv_detalleId VARCHAR2)
    IS
    SELECT DETALLE_ID FROM DB_COMUNICACION.INFO_COMUNICACION 
        WHERE CASO_ID=Cv_casoID AND DETALLE_ID<>Cv_detalleId 
        AND DETALLE_ID IS NOT NULL
        GROUP BY DETALLE_ID;

    CURSOR C_GET_PARAMETROS_PLAN(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2,Cv_Categoria VARCHAR2,Cv_SubCategoria VARCHAR2,Cv_TipoEvento VARCHAR2,Cn_CodEmpresa VARCHAR2)
        IS
          SELECT APD.VALOR4
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.parametro_id =
            (SELECT APC.id_parametro
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.nombre_parametro = Cv_NombreParametro
            )
        AND APD.DESCRIPCION = Cv_DescripcionParametro AND APD.VALOR1 = UPPER(Cv_Categoria) AND NVL(APD.VALOR2,'N')= UPPER(NVL(Cv_SubCategoria,'N')) AND APD.VALOR3 = UPPER(Cv_TipoEvento) AND  APD.EMPRESA_COD = Cn_CodEmpresa;
    CURSOR C_NOMBRE_CLIENTE(Cn_PersonaEmpresaRol INTEGER)
        IS
        SELECT 
        regexp_replace(UPPER(UTL_RAW.CAST_TO_VARCHAR2((nlssort(T1.NOMBRE_CLIENTE, 'nls_sort=binary_ai')))), '(^[[:cntrl:]^\t]+)|([[:cntrl:]^\t]+$)',null)  AS NOMBRE_CLIENTE
        FROM
        (
            SELECT (CASE WHEN IPE.NOMBRES IS NULL AND IPE.APELLIDOS IS NULL THEN IPE.RAZON_SOCIAL ELSE IPE.NOMBRES || IPE.APELLIDOS END) AS NOMBRE_CLIENTE
                    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                    INNER JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPER.PERSONA_ID=IPE.ID_PERSONA
                    WHERE IPER.ID_PERSONA_ROL = Cn_PersonaEmpresaRol) T1;
    CURSOR C_ESTADONOTIFICADO(Cn_detalleIncidencia INTEGER)
        IS
        SELECT 
        ID_INCIDENCIA_NOTIFICACION
        FROM
        DB_SOPORTE.info_incidencia_notif iin
        WHERE iin.DETALLE_INCIDENCIA_ID = Cn_detalleIncidencia;
    CURSOR C_BUSCAR_CASO(Cv_IdCasoEcu VARCHAR2) IS
        SELECT
        ica.empresa_cod,(select idh.hipotesis_id from db_Soporte.info_detalle_hipotesis idh where idh.caso_id=ica.id_caso and ROWNUM=1 )
        FROM DB_SOPORTE.INFO_CASO ica WHERE ica.ID_CASO=Cv_IdCasoEcu;
    CURSOR C_BUSCAR_LOGIN(Cv_idServicio VARCHAR2) IS
        SELECT
        ise.punto_id,ipu.login
        FROM DB_COMERCIAL.INFO_SERVICIO ise 
        INNER JOIN DB_COMERCIAL.INFO_PUNTO ipu on ipu.ID_PUNTO=ise.PUNTO_ID
        WHERE ise.ID_SERVICIO=Cv_idServicio;
    CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
        IS
          SELECT APD.VALOR1,APD.VALOR2,
                  APD.VALOR3,APD.VALOR4,APD.VALOR5,VALOR6,VALOR7,OBSERVACION
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.parametro_id =
            (SELECT APC.id_parametro
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.nombre_parametro = Cv_NombreParametro
            )
        AND APD.descripcion = Cv_DescripcionParametro;
    CURSOR C_DETALLE_TAREA(Cn_IdComunicacion INTEGER) IS 
            SELECT ICO.DETALLE_ID 
            FROM DB_COMUNICACION.INFO_COMUNICACION ICO
            WHERE ICO.ID_COMUNICACION = Cn_IdComunicacion;
    CURSOR C_OBTENER_INCIDENCIA(Cn_NumeroTicket VARCHAR2,Cn_TipoProceso VARCHAR2) IS 
        SELECT T1.TAREA_ID,T1.EMPRESA_ID,T1.CASO_ID,T1.ID_DETALLE,
                (EXTRACT(HOUR FROM (SYSDATE-T1.FE_CREACION))*60+
                EXTRACT(DAY FROM (SYSDATE-T1.FE_CREACION))*24*60+
                EXTRACT(MINUTE FROM (SYSDATE-T1.FE_CREACION))) AS MINUTOS_TAREA,
                T1.PREFIJO,
                TO_CHAR(SYSDATE,'DD/MM/YYYY') AS FECHA_CIERRE, 
                TO_CHAR(SYSDATE,'HH24:MI:SS') AS HORA_CIERRE,
                'telcos' AS USUARIO,T1.ID_DETALLE_INCIDENCIA,
                T1.IP,
                T1.USR_CREACION,
                T1.FE_INCIDENCIA, 
                T1.PUERTO,
                T1.NO_TICKET,
                T1.CATEGORIA,
                T1.SUBCATEGORIA,
                T1.TIPO_EVENTO,
                T1.IP_DEST, 
                T1.ESCPE,
                T1.STATUS,
                T1.TIPO_USUARIO,
                T1.SUBJECT,
                T1.ESCGNAT,
                T1.ESRDA,
                T1.PERSONA_EMPRESA_ROL_ID,
                T1.COMUNICACION_ID,
                T1.SERVICIO_ID,
                T1.ESSG
        FROM(
            SELECT (
                    SELECT MAX(IDEH.ID_DETALLE_HISTORIAL) 
                    FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDEH 
                    WHERE IDE.ID_DETALLE=IDEH.DETALLE_ID ) AS ID_DETALLE_HISTORIAL,
                    IDE.TAREA_ID,IID.TAREA_PROCESADA,IID.EMPRESA_ID,IID.CASO_ID,
                    IDE.ID_DETALLE,IDE.FE_CREACION,IEG.PREFIJO,
                    IID.ID_DETALLE_INCIDENCIA,
                    IID.IP,
                    IID.USR_CREACION,
                    IID.FE_INCIDENCIA, 
                    IID.PUERTO,
                    IIC.NO_TICKET,
                    IIC.CATEGORIA,
                    IIC.SUBCATEGORIA,
                    IIC.TIPO_EVENTO,
                    IID.IP_DEST, 
                    IID.ESCPE,
                    IID.STATUS,
                    IID.TIPO_USUARIO,
                    IIC.SUBJECT,
                    IID.ESCGNAT,
                    IID.ESRDA,
                    IID.PERSONA_EMPRESA_ROL_ID,
                    IID.COMUNICACION_ID,
                    IID.SERVICIO_ID,
                    IID.ESSG
            FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID
            INNER JOIN DB_SOPORTE.INFO_INCIDENCIA_CAB IIC ON IID.INCIDENCIA_ID=IIC.ID_INCIDENCIA
            LEFT JOIN DB_COMUNICACION.INFO_COMUNICACION ICO ON ICO.ID_COMUNICACION = IID.COMUNICACION_ID
            LEFT JOIN DB_SOPORTE.INFO_DETALLE IDE ON IDE.ID_DETALLE=ICO.DETALLE_ID
            LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = IID.EMPRESA_ID
            WHERE IIC.NO_TICKET = Cn_NumeroTicket 
            AND IID.ESTADO_GESTION  <> CASE WHEN Cn_TipoProceso = 'T' THEN 'Atendido' ELSE 'Ninguno' END
            ) T1
            LEFT JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDEH ON T1.ID_DETALLE_HISTORIAL=IDEH.ID_DETALLE_HISTORIAL 
            WHERE NVL(IDEH.ESTADO,'No encontrada') <> 'Finalizada';

      Lv_EmpresaMEGADATOS             VARCHAR2(400) := '%MEGADATOS%';
      Ln_CodigoEmprTicket             NUMBER;
      Lv_MensajeError                 VARCHAR2(4000);
      Lv_RespuestaCert                VARCHAR2(4000);
      Lcl_JsonVulnerabilidad          CLOB;
      Lv_Token                        VARCHAR2(800);
      Lv_Status                       VARCHAR2(800);
      Lv_Message                      VARCHAR2(800);
      Lv_RespuestaToken               VARCHAR2(4000);
      Lv_URLToken                     VARCHAR2(4000);
      Lv_URLCERT                      VARCHAR2(4000);
      Lv_StatusCert                   VARCHAR2(4000);
      Lv_Vulnerable                   VARCHAR2(50);
      Lv_MensajeVulnerabilidad        VARCHAR2(4000);
      Ln_DetalleId                    INTEGER;
      Lv_NombreParametro              VARCHAR2(400) := 'PARAMETROS_ECUCERT';
      Lv_DescripParametro             VARCHAR2(400);
      Lr_InfoParamTarea               C_GET_PARAMETROS%ROWTYPE;
      Lv_URLTenico                    VARCHAR2(4000);
      Lv_URLSoporte                   VARCHAR2(4000);
      Lcl_JsonToken                   CLOB;
      Lv_Prefijo                      VARCHAR2(4000);
      Ln_EmpresaId                    NUMBER;
      Ln_idHipotesis                  NUMBER;
      Ln_ObservacionTarea             VARCHAR2(4000) := 'Cierre de tarea por proceso ECUCERT';
      Ln_ObservacionCaso              VARCHAR2(4000) := 'Cierre de caso por proceso ECUCERT';
      Lv_tiempo                       NUMBER:=0; 
      Lcl_JsonCerrarCasos             CLOB ;
      Lv_RespuestaCierreCasos         VARCHAR2(4000);
      Lv_RespuestaFinTarea            VARCHAR2(4000);
      Lcl_JsonFinTarea                CLOB;
      Lv_StatusTarea                  VARCHAR2(400);
      Lcl_JsonNotificacion            CLOB;
      Lv_RespuestaNotif               VARCHAR2(400);
      Ln_NombresCliente               VARCHAR2(400);
      Lv_IdPunto                      VARCHAR2(400);
      Lv_DescFormContact              VARCHAR2(400);
      Lv_Contacto                     VARCHAR2(400);
      Lv_FormaContacto                VARCHAR2(400);
      Lv_Asunto                       VARCHAR2(400);
      Lv_EstadoAnalisis               VARCHAR2(400);
      Lv_EstadoNotif                  VARCHAR2(400);
      Lv_EstadoNotifFallo             VARCHAR2(400);
      Lv_Login                        VARCHAR2(400);
      Lv_EtiquetaCaso                 VARCHAR2(400);
      Lv_InfoParamPlanti              VARCHAR2(100);
      Lv_IdNotificacion               VARCHAR2(400);      
      Lv_NombreParamPlan              VARCHAR2(100):='PLANTILLAS DE NOTIFICACIONES';
      Lv_DescripParamPlan             VARCHAR2(100):='CODIGO DE PLANTILLA ECUCERT';
    BEGIN

        Lv_DescripParametro := 'URL ECUCERT';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_URLTenico        := Lr_InfoParamTarea.VALOR1;
        Lv_URLSoporte       := Lr_InfoParamTarea.VALOR2;
        Lv_URLCERT          := Lr_InfoParamTarea.VALOR3;
        Lv_URLToken         := Lr_InfoParamTarea.VALOR5;

        Lv_DescripParametro := 'PARAMETROS PARA ENVIAR CORREO';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_DescFormContact  := Lr_InfoParamTarea.VALOR1;
        Lv_Contacto         := Lr_InfoParamTarea.VALOR2;
        Lv_FormaContacto    := Lr_InfoParamTarea.VALOR3;
        Lv_Asunto           := Lr_InfoParamTarea.VALOR4;

        Lv_DescripParametro := 'PARAMETROS PARA ESTADO INCIDENCIA';
        OPEN C_GET_PARAMETROS (Lv_NombreParametro,Lv_DescripParametro);
        FETCH C_GET_PARAMETROS INTO Lr_InfoParamTarea;
        CLOSE C_GET_PARAMETROS;

        Lv_EstadoAnalisis   := Lr_InfoParamTarea.VALOR3;
        Lv_EstadoNotif      := Lr_InfoParamTarea.VALOR4;
        Lv_EstadoNotifFallo := 'No '||Lv_EstadoNotif;

        Lcl_JsonToken    := '
            {
              "source": {
                "name": "APP.CERT",
                "originID": "127.0.0.1",
                "tipoOriginID": "IP"
                        },
              "user": "CERT",
              "gateway": "Authentication",
              "service": "Authentication",
              "method": "Authentication"
            }';

        IF Pv_Nombre_Proceso IS NOT NULL AND Pv_Nombre_Proceso = 'C'
        THEN
          INSERT INTO DB_SOPORTE.INFO_INCIDENCIA_DET_HIST 
          (ID_INCIDENCIA_DET_HIST,DETALLE_INCIDENCIA_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
          SELECT 
          DB_SOPORTE.SEQ_INFO_INCIDENCIA_DET_HIST.NEXTVAL,
          IID.ID_DETALLE_INCIDENCIA,
          'Atendido','telcos',SYSDATE,'127.0.0.1'
          FROM DB_SOPORTE.INFO_INCIDENCIA_CAB IIC
          INNER JOIN DB_SOPORTE.INFO_INCIDENCIA_DET IID ON IIC.ID_INCIDENCIA=IID.INCIDENCIA_ID
          WHERE IID.ESTADO_GESTION <> 'Atendido' AND IIC.NO_TICKET=Pv_NumeroTicket; 

          MERGE INTO DB_SOPORTE.INFO_INCIDENCIA_DET  IID
          USING
          (
          SELECT 
          IIC.ID_INCIDENCIA,
          IIC.NO_TICKET
          FROM DB_SOPORTE.INFO_INCIDENCIA_CAB IIC
          ) T1
          ON (IID.INCIDENCIA_ID=T1.ID_INCIDENCIA AND T1.NO_TICKET=Pv_NumeroTicket)
          WHEN MATCHED THEN
              UPDATE SET IID.ESTADO_GESTION = 'Atendido',IID.STATUS='No Vulnerable' 
              WHERE IID.ESTADO_GESTION <> 'Atendido';
          COMMIT;

        END IF;

        FOR i IN C_OBTENER_INCIDENCIA(Pv_NumeroTicket,Pv_Nombre_Proceso)
        LOOP 

        CASE WHEN UPPER(i.SUBJECT) LIKE Lv_EmpresaMEGADATOS
        THEN Ln_CodigoEmprTicket:= 18;
        ELSE Ln_CodigoEmprTicket:= 10;
        END CASE;

        IF Pv_Nombre_Proceso IS NOT NULL AND Pv_Nombre_Proceso != 'C'
        THEN

          DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lv_MensajeError);        
          DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

          Lcl_JsonVulnerabilidad  :='{"op": "validate", 
                                      "token": "'||Lv_Token||'",
                                      "data": { "categoria": "'||i.CATEGORIA||'", "subcategoria": "'|| i.SUBCATEGORIA ||'", "ip_address": "'|| i.IP || '"}}';

          DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonVulnerabilidad ,Lv_URLCERT,Lv_RespuestaCert,Lv_MensajeError); 
          Lv_Vulnerable := '';
          apex_json.parse (Lv_RespuestaCert);
          Lv_StatusCert :=apex_json.get_varchar2('success');

          IF Lv_StatusCert = 'true'
          THEN 
              Lv_Vulnerable            :=apex_json.get_varchar2('vulnerable');
              Lv_MensajeVulnerabilidad := apex_json.get_varchar2(p_path => 'msg');
          ELSE
              Lv_MensajeVulnerabilidad  := apex_json.get_varchar2(p_path => 'errors.msg',   p0 => 1);

          END IF;

        END IF;

        IF (Lv_Vulnerable IS NOT NULL AND Lv_Vulnerable = 'N') OR (Pv_Nombre_Proceso IS NOT NULL AND Pv_Nombre_Proceso != 'T')
        THEN 
            IF Pv_Nombre_Proceso IS NOT NULL AND Pv_Nombre_Proceso != 'C'
            THEN
                DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_ACTUALIZAR_ESTADO_GESTION('Atendido','No Vulnerable',i.ID_DETALLE_INCIDENCIA);
            END IF;
            IF i.COMUNICACION_ID IS NOT NULL 
            THEN
                OPEN C_DETALLE_TAREA (i.COMUNICACION_ID);
                FETCH C_DETALLE_TAREA INTO Ln_DetalleId;
                CLOSE C_DETALLE_TAREA;

                P_TAREA_PROCESADA(i.ID_DETALLE_INCIDENCIA,0,Ln_DetalleId,'Validación automática: No Vulnerable'); 
                P_TAREA_PROCESADA(i.ID_DETALLE_INCIDENCIA,0,Ln_DetalleId,'Cambio de estado de gestión a: Atendido'); 

                DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lv_MensajeError);        
                DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                Lcl_JsonFinTarea     :='{
                                        "op": "putFinalizarTarea",
                                        "source": {
                                            "name": "APP.CERT",
                                            "originID": "127.0.0.1",
                                            "tipoOriginID": "IP"
                                        },
                                        "token": "'||Lv_Token||'",
                                        "user": "'||i.USUARIO||'",
                                        "data":
                                        {
                                            "codEmpresa":       "'||i.EMPRESA_ID||'",
                                            "idCaso":           "'||i.CASO_ID||'",
                                            "prefijoEmpresa":   "'||i.PREFIJO||'",
                                            "tarea": {
                                                            "idTarea":         "'|| i.ID_DETALLE||'",
                                                            "materiales":      "",
                                                            "tiempoTotalTarea":"'|| i.MINUTOS_TAREA||'",
                                                            "fechaInicial":    "",
                                                            "horaInicial":     "",
                                                            "observacion":     "'|| Ln_ObservacionTarea||'",
                                                            "fechaCierre":     "'|| i.FECHA_CIERRE||'",
                                                            "horaCierre":      "'|| i.HORA_CIERRE||'",
                                                            "idTareaFinal":    "'|| i.TAREA_ID||'",
                                                            "esSolucion":      "true"
                                                    }
                                        }
                                    }';

                DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonFinTarea,Lv_URLSoporte,Lv_RespuestaFinTarea,Lv_MensajeError);
                APEX_JSON.PARSE (Lv_RespuestaFinTarea);
                Lv_StatusTarea     := UPPER(APEX_JSON.GET_VARCHAR2(p_path => 'status'));
                IF Lv_StatusTarea = '200' AND Pv_Nombre_Proceso IS NOT NULL AND Pv_Nombre_Proceso = 'C'
                THEN
                  P_TAREA_PROCESADA(i.ID_DETALLE_INCIDENCIA,0,Ln_DetalleId,'Cierre de tarea automática: Arcotel informa que el ticket fue resuelto'); 
                END IF;
                IF Lv_StatusTarea = '200' AND i.CASO_ID IS NOT NULL 
                THEN
                  FOR j IN C_GETMASTAREAS(i.CASO_ID,Ln_DetalleId)
                  LOOP 
                      DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lv_MensajeError);        
                      DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                      Lcl_JsonFinTarea     :='{
                                              "op": "putFinalizarTarea",
                                              "source": {
                                                  "name": "APP.CERT",
                                                  "originID": "127.0.0.1",
                                                  "tipoOriginID": "IP"
                                              },
                                              "token": "'||Lv_Token||'",
                                              "user": "'||i.USUARIO||'",
                                              "data":
                                              {
                                                  "codEmpresa":       "'||i.EMPRESA_ID||'",
                                                  "idCaso":           "'||i.CASO_ID||'",
                                                  "prefijoEmpresa":   "'||i.PREFIJO||'",
                                                  "tarea": {
                                                                  "idTarea":         "'|| j.DETALLE_ID||'",
                                                                  "materiales":      "",
                                                                  "tiempoTotalTarea":"'|| i.MINUTOS_TAREA||'",
                                                                  "fechaInicial":    "",
                                                                  "horaInicial":     "",
                                                                  "observacion":     "'|| Ln_ObservacionTarea||'",
                                                                  "fechaCierre":     "'|| i.FECHA_CIERRE||'",
                                                                  "horaCierre":      "'|| i.HORA_CIERRE||'",
                                                                  "idTareaFinal":    "'|| i.TAREA_ID||'",
                                                                  "esSolucion":      "true"
                                                          }
                                              }
                                          }';

                            DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonFinTarea,Lv_URLSoporte,Lv_RespuestaFinTarea,Lv_MensajeError);
                            APEX_JSON.PARSE (Lv_RespuestaFinTarea);
                            Lv_StatusTarea     := UPPER(APEX_JSON.GET_VARCHAR2(p_path => 'status'));
                            IF Lv_StatusTarea = '200' AND Pv_Nombre_Proceso IS NOT NULL AND Pv_Nombre_Proceso = 'C'
                            THEN
                              P_TAREA_PROCESADA(i.ID_DETALLE_INCIDENCIA,0,j.DETALLE_ID,'Cierre de tarea automática: Arcotel informa que el ticket fue resuelto'); 
                            END IF;

                        END LOOP;

                       OPEN C_BUSCAR_CASO(i.CASO_ID);
                       FETCH C_BUSCAR_CASO INTO  Ln_EmpresaId,Ln_idHipotesis;
                       CLOSE C_BUSCAR_CASO; 

                       DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lv_MensajeError);        
                       DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                        IF(Ln_EmpresaId=18) THEN
                            Lv_Prefijo := 'MD';
                         ELSE
                            Lv_Prefijo := 'TN';
                         END IF;

                        Lcl_JsonCerrarCasos  :='{
                           "data": 
                                {
                                "codEmpresa":      "'||Ln_EmpresaId||'",
                                "prefijoEmpresa":  "'||Lv_Prefijo||'",
                                "caso": 
                                    {
                                        "idCaso":           "'||i.CASO_ID||'",
                                        "fechaCierre":      "'||TO_CHAR(SYSDATE,'DD-MM-YYYY')||'",
                                        "horaCierre":       "'||TO_CHAR(SYSDATE,'hh24:mi:ss')||'",
                                        "idHipotesisFinal": "'||Ln_idHipotesis||'",
                                        "versionFinal":     "'||Ln_ObservacionCaso||'",
                                        "tiempoTotalCaso":  "'||Lv_tiempo||'"
                                    }
                                },
                        "op": "putCerrarCaso",
                        "token": "'||Lv_Token||'",
                        "user": "telcos",
                       "ipCreacion": "127.0.0.1"
                        }';

                        DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonCerrarCasos,Lv_URLSoporte,Lv_RespuestaCierreCasos,Lv_MensajeError);  
                END IF;
            END IF;
        ELSE
            IF i.PERSONA_EMPRESA_ROL_ID IS NOT NULL 
            THEN
                    OPEN C_ESTADONOTIFICADO (i.ID_DETALLE_INCIDENCIA);
                    FETCH C_ESTADONOTIFICADO INTO Lv_IdNotificacion;
                    CLOSE C_ESTADONOTIFICADO;

                    IF Lv_IdNotificacion is null AND i.ESCGNAT=0 AND i.ESCPE=0 AND i.ESSG=0
                    then

                        OPEN C_NOMBRE_CLIENTE (i.PERSONA_EMPRESA_ROL_ID);
                        FETCH C_NOMBRE_CLIENTE INTO Ln_NombresCliente;
                        CLOSE C_NOMBRE_CLIENTE;

                        OPEN C_BUSCAR_LOGIN (i.SERVICIO_ID);
                        FETCH C_BUSCAR_LOGIN INTO Lv_IdPunto,Lv_Login;
                        CLOSE C_BUSCAR_LOGIN;

                         IF i.CASO_ID IS NOT NULL THEN
                            Lv_EtiquetaCaso := ' // Caso:  '||i.CASO_ID;
                        ELSE
                            Lv_EtiquetaCaso := NULL;
                        END IF;

                        OPEN C_GET_PARAMETROS_PLAN (Lv_NombreParamPlan,Lv_DescripParamPlan,i.CATEGORIA,i.SUBCATEGORIA,i.TIPO_EVENTO,i.EMPRESA_ID);
                        FETCH C_GET_PARAMETROS_PLAN INTO Lv_InfoParamPlanti;
                        CLOSE C_GET_PARAMETROS_PLAN;

                        DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonToken ,Lv_URLToken,Lv_RespuestaToken,Lv_MensajeError);        
                        DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_TOKEN(Lv_RespuestaToken,Lv_Token,Lv_Status,Lv_Message);

                        Lcl_JsonNotificacion    :='{
                                               "data": 
                                                    {
                                                    "idPersonaEmpresaRol":      "'|| i.PERSONA_EMPRESA_ROL_ID||'",
                                                    "estado":                   "Activo",
                                                    "intIdPunto":               "'|| Lv_IdPunto||'",
                                                    "strDescFormContact":       "'|| Lv_DescFormContact||'", 
                                                    "strContacto":              "'|| Lv_Contacto||'",
                                                    "strEstadoNotificacionIn":  "'|| Lv_EstadoNotifFallo||'",
                                                    "strEstadoNotificacionEn":  "'|| Lv_EstadoNotif||'",
                                                    "asunto":                   "'|| Lv_Asunto||' '||i.TIPO_EVENTO||':'||REPLACE(i.CATEGORIA,'_','')|| Lv_EtiquetaCaso ||' // '|| Ln_NombresCliente || ' // Login:  '||Lv_Login|| '",
                                                    "codPlantilla":             "'|| Lv_InfoParamPlanti||'",
                                                    "idCaso":                   "'|| i.CASO_ID||'",
                                                    "idEmpresa":                "'|| i.EMPRESA_ID||'",
                                                    "strLoginAfectado":         "'|| Lv_Login||'",
                                                    "intIncidenciaDetId":       "'|| i.ID_DETALLE_INCIDENCIA||'",
                                                    "ip":                       "'|| i.IP||'",
                                                    "puerto":                   "'|| i.PUERTO||'",
                                                    "ipDestino":                "'|| i.IP_DEST||'",
                                                    "ticket":                   "'|| i.NO_TICKET||'",
                                                    "nombreCliente":            "'|| Ln_NombresCliente||'",
                                                    "feIncidencia":             "'|| i.FE_INCIDENCIA||'"
                                                    },
                                            "op": "putNotificarClienteEcucert",
                                            "token": "'||Lv_Token||'",
                                            "source": {
                                                "name": "APP.CERT",
                                                "originID": "127.0.0.1",
                                                "tipoOriginID": "IP"
                                            },
                                            "user": "telcos",
                                           "ipCreacion": "127.0.0.1"
                                            }';

                        DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonNotificacion ,Lv_URLTenico,Lv_RespuestaNotif,Lv_MensajeError);
                        DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_ENVIO_NOTIFICACION(Lv_RespuestaNotif,Lv_Status,Lv_Message);
                   IF i.COMUNICACION_ID IS NOT NULL AND Lv_Message = 'Enviado'
                   THEN
                        OPEN C_DETALLE_TAREA (i.COMUNICACION_ID);
                        FETCH C_DETALLE_TAREA INTO Ln_DetalleId;
                        CLOSE C_DETALLE_TAREA;

                        P_TAREA_PROCESADA(i.ID_DETALLE_INCIDENCIA,0,Ln_DetalleId,'Notificación reenviada automáticamente'); 

                   END IF;
                END IF;
            END IF;
        END IF;

        END LOOP;
        COMMIT;
   EXCEPTION 
   WHEN OTHERS THEN  
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_NOTIFICACION_CIERRE_CASO',
                                            SQLCODE || ' - ERROR_STACK:'||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1'); 
   END P_NOTIFICACION_CIERRE_CASO;

   PROCEDURE P_REENVIO_CORREO_ECUCERT(
                                  Pv_NumeroTicket   IN  VARCHAR2, 
                                  Pv_ipCreacion     IN  VARCHAR2,
                                  Pv_user           IN  VARCHAR2,
                                  Pv_MensajeError   OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2) IS
   CURSOR C_OBTENER_INCIDENCIA_PENDIENTE(Cn_NumeroTicket VARCHAR2) IS 
        SELECT IID.IP, 
        IID.ID_DETALLE_INCIDENCIA,
        IID.USR_CREACION,
        IID.FE_INCIDENCIA, 
        IID.PUERTO,
        IIC.NO_TICKET,
        IIC.CATEGORIA,
        IIC.SUBCATEGORIA,
        IIC.TIPO_EVENTO,
        IID.IP_DEST, 
        IID.ESCPE,
        IID.STATUS,
        IID.TIPO_USUARIO,
        IIC.SUBJECT,
        IID.ESCGNAT,
        IID.ESRDA
        FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID
        INNER JOIN DB_SOPORTE.INFO_INCIDENCIA_CAB IIC ON IID.INCIDENCIA_ID=IIC.ID_INCIDENCIA
        WHERE IIC.NO_TICKET = Cn_NumeroTicket AND IID.estado_gestion= 'Pendiente' 
              AND IID.PERSONA_EMPRESA_ROL_ID IS NULL;
    Pv_TipoProceso VARCHAR2(400) := 'T';
   BEGIN
    FOR i IN C_OBTENER_INCIDENCIA_PENDIENTE(Pv_NumeroTicket)
        LOOP
          DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_REPROCESAR_CLIENTE(i.ID_DETALLE_INCIDENCIA,
                                                                  i.IP,
                                                                  i.USR_CREACION,
                                                                  Pv_MensajeError);
    END LOOP;
    DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_NOTIFICACION_CIERRE_CASO(Pv_TipoProceso,
                                                                        Pv_NumeroTicket,
                                                                        Pv_ipCreacion,
                                                                        Pv_user,
                                                                        Pv_MensajeError,
                                                                        Pv_Respuesta);

    DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_REPORTE_INC_AUTOMAT(Pv_NumeroTicket);

   EXCEPTION 
   WHEN OTHERS THEN  
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ECUCERT',
                                            'DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_REENVIO_CORREO_ECUCERT',
                                            SQLCODE || ' - ERROR_STACK:'||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1'); 
   END P_REENVIO_CORREO_ECUCERT;

END SPKG_INCIDENCIA_ECUCERT;
/
