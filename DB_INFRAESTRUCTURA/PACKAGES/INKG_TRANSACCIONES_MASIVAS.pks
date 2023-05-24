CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS
AS
  /**
  * P_INSERT_PROCESO_MASIVO_CAB
  * Procedimiento que crea un registro en la tabla INFO_PROCESO_MASIVO_CAB
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 11-11-2020
  *
  * @param Pr_InfoProcesoMasivoCab  IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE Recibe un registro para INFO_PROCESO_MASIVO_CAB
  * @param Pn_IdProcesoMasivoCab    OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE Retorna el ID de acuerdo a la secuencia
  *                                                                                                           SEQ_INFO_PROCESO_MASIVO_CAB
  * @param Pv_MsjError              OUT VARCHAR2 Retorna un mensaje de error
  *
  */
  PROCEDURE P_INSERT_PROCESO_MASIVO_CAB(
    Pr_InfoProcesoMasivoCab   IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
    Pn_IdProcesoMasivoCab     OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
    Pv_MsjError               OUT VARCHAR2);
    
  /**
  * P_INSERT_PROCESO_MASIVO_DET
  * Procedimiento que crea un registro en la tabla INFO_PROCESO_MASIVO_DET
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 11-11-2020
  *
  * @param Pr_InfoProcesoMasivoDet  IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE Recibe un registro para INFO_PROCESO_MASIVO_DET
  * @param Pn_IdProcesoMasivoDet    OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE Retorna el ID de acuerdo a la secuencia 
  *                                                                                                           SEQ_INFO_PROCESO_MASIVO_DET
  * @param Pv_MsjError              OUT VARCHAR2 Retorna un mensaje de error
  *
  */
  PROCEDURE P_INSERT_PROCESO_MASIVO_DET(
    Pr_InfoProcesoMasivoDet   IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
    Pn_IdProcesoMasivoDet     OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    Pv_MsjError               OUT VARCHAR2);

  /**
  * P_INSERT_SPC
  * Procedimiento que crea un registro en la tabla DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 14-01-2021
  *
  * @param Pn_IdServicio                   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el id del servicio
  * @param Pn_IdProducto                   IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE Recibe el id del producto
  * @param Pv_EstadoAdmiProdCaract         IN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA.ESTADO%TYPE Recibe el estado de la relaci�n entre el producto
  *                                                                                                 y la caracter�stica
  * @param Pv_DescripcionCaracteristica    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Descripci�n de la caracter�stica
  * @param Pv_ValorServicioProdCaract      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE Valor de la caracter�stica asoaciada al servicio
  * @param Pv_EstadoServicioProdCaract     IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE Estado de la caracter�stica asoaciada al servicio
  * @param Pv_UsrCreacion                  IN VARCHAR2 Usuario de creaci�n
  * @param Pv_MsjError                     OUT VARCHAR2 Retorna un mensaje de error
  *
  */
  PROCEDURE P_INSERT_SPC(
    Pn_IdServicio                   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdProducto                   IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Pv_EstadoAdmiProdCaract         IN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA.ESTADO%TYPE,
    Pv_DescripcionCaracteristica    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_ValorServicioProdCaract      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Pv_EstadoServicioProdCaract     IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE,
    Pv_UsrCreacion                  IN VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2);

  /**
  * P_ELIMINA_SPC
  * Procedimiento que elimina las caracter�sticas asociadas a un servicio
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 14-01-2021
  *
  * @param Pn_IdSpcUnicoPorActualizar   IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT Recibe el id del registro que se actualizar�
  * @param Pn_IdServicio                IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el id servicio
  * @param Pn_IdProducto                IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE Recibe el id producto
  * @param Pv_NombreTecnicoProducto     IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE Recibe el id producto
  * @param Pv_DescripcionCaracteristica IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Recibe el nombre t�cnico del producto
  * @param Pv_SetValorSpc               IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE Valor que se actualizar� en el registro
  * @param Pv_UsrUltMod                 IN VARCHAR2 Recibe el usuario que actualizar� el registro
  * @param Pv_Status                    OUT VARCHAR2 Retorna el estado del procedimiento
  * @param Pv_MsjError                  OUT VARCHAR2 Retorna el mensaje de salida
  *
  */    
  PROCEDURE P_ELIMINA_SPC(
    Pn_IdSpcUnicoPorActualizar      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE,
    Pn_IdServicio                   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdProducto                   IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Pv_NombreTecnicoProducto        IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Pv_DescripcionCaracteristica    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_SetValorSpc                  IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Pv_UsrUltMod                    IN VARCHAR2,
    Pv_Status                       OUT VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2);

  /**
  * P_CREA_PM_REGULARIZA_SERVS
  * Procedimiento que crea los registros de los servicios que pasar�n por un proceso de regularizaci�n de data t�cnica
  *
  * @param Pv_UsrCreacion   IN VARCHAR2 Recibe el usuario que crea el procesos masivo
  * @param Pv_Status        OUT VARCHAR2 Retorna el status del procedimiento
  * @param Pv_MsjError      OUT VARCHAR2 Retorna un mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 11-11-2020
  *
  */
  PROCEDURE P_CREA_PM_REGULARIZA_SERVS(
    Pv_UsrCreacion  IN VARCHAR2,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2);

  /**
  * P_NOTIF_CORREO_Y_SMS_PRODS_TV
  *
  * Procedimiento que notifica por correo o SMS las credenciales de los producto TV y agrega los contactos del punto en caso de que sea un plan 
  * el que est� asociado al servicio
  *
  * @param Pv_TipoNotif                  IN VARCHAR2 'CORREO' o 'SMS'
  * @param Pcl_Contenido                 IN CLOB Contenido a enviar ya sea en el correo o en el sms
  * @param Pn_IdPunto                    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Id del punto
  * @param Pn_IdPersona                  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE Id de la persona
  * @param Pv_AsuntoCorreo               IN VARCHAR2 Asunto del correo
  * @param Pv_CorreosDestinatarios       IN VARCHAR2 Correos destinatarios
  * @param Pv_AgregaFormasContactoPunto  IN VARCHAR2 'SI' o 'NO' se debe notificar a las formas de contacto del punto
  * @param Pv_Status                     OUT VARCHAR2 Retorna el status del procedimiento
  * @param Pv_MsjError                   OUT VARCHAR2 Retorna un mensaje de error
  * @param Pcl_DestinatariosFinales      OUT CLOB Retorna los destinatarios finales del correo o sms
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 11-11-2020
  *
  */
  PROCEDURE P_NOTIF_CORREO_Y_SMS_PRODS_TV(
    Pv_TipoNotif                  IN VARCHAR2,
    Pcl_Contenido                 IN CLOB,
    Pn_IdPunto                    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_IdPersona                  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    Pv_AsuntoCorreo               IN VARCHAR2,
    Pv_CorreosDestinatarios       IN VARCHAR2,
    Pv_AgregaFormasContactoPunto  IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pcl_DestinatariosFinales      OUT CLOB);

  /**
  * P_CREA_LOG_SERV_ADIC
  *
  * Procedimiento para crear l�gicamente un servicio adicional
  *
  * @param Pr_InfoServicioInternet       IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet Registro con la informaci�n del servicio de Internet
  * @param Pr_InfoServicioProdAdicional  IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioProdAdicional Registro con la informaci�n del servicio 
  *                                                                                                    adicional
  * @param Pv_UsrCreacion                IN VARCHAR2 Usuario de creaci�n
  * @param Pv_IpCreacion                 IN VARCHAR2 Ip de creaci�n
  * @param Pv_Status                     OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError                   OUT VARCHAR2 Mensaje de error
  * @param Pn_IdServicioNuevo            OUT DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id de l servicio creado
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 20-01-2021
  *
  */
  PROCEDURE P_CREA_LOG_SERV_ADIC(
    Pr_InfoServicioInternet       IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet,
    Pr_InfoServicioProdAdicional  IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioProdAdicional,
    Pv_UsrCreacion                IN VARCHAR2,
    Pv_IpCreacion                 IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pn_IdServicioNuevo            OUT DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE);

  /**
  * P_CANCEL_LOG_SERVS_ADIC
  *
  * Procedimiento para crear l�gicamente un servicio adicional
  *
  * @param Pn_IdPunto                  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Id del punto
  * @param Pv_NombreTecnicoProducto    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE Nombre t�cnico del producto
  * @param Pn_IdServicioUnicoACancelar IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del �nico servicio a cancelar
  * @param Pn_IdServicioANoCancelar    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio que no se debe cancelar
  * @param Pv_EstadoServicio           IN VARCHAR2 Estado del servicio
  * @param Pv_ProcesoEjecutante        IN VARCHAR2 Proceso que ejecuta el procedimiento
  * @param Pv_ObsProcesoEjecutante     IN VARCHAR2 Observaci�n del proceso a ejecutar
  * @param Pv_UsrCreacion              IN VARCHAR2 Usuario de creaci�n
  * @param Pv_Status                   OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError                 OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 22-01-2021
  *
  */
  PROCEDURE P_CANCEL_LOG_SERVS_ADIC(
    Pn_IdPunto                  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pv_NombreTecnicoProducto    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Pn_IdServicioUnicoACancelar IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdServicioANoCancelar    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pv_EstadoServicio           IN VARCHAR2,
    Pv_ProcesoEjecutante        IN VARCHAR2,
    Pv_ObsProcesoEjecutante     IN VARCHAR2,
    Pv_UsrCreacion              IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2);
  
  /**
  * P_EJECUTA_CPM_FLUJO_PRODS_TV
  *
  * Procedimiento para ejecutar el flujo de cambio de plan masivo para productos Paramount y Noggin
  *
  * @param Pr_InfoServicioInternet IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet Registro con la informaci�n del servicio de Internet
  * @param Pn_IdPlanAnterior       IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE Id del plan anterior
  * @param Pn_IdPlanNuevo          IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE Id del plan nuevo
  * @param Pv_ProcesoEjecutante    IN VARCHAR2 Proceso que invoca al procedimiento
  * @param Pv_ObsProcesoEjecutante IN VARCHAR2 Observaci�n del proceso ejecutante
  * @param Pv_UsrCreacion          IN VARCHAR2 Usuario de creaci�n
  * @param Pv_IpCreacion           IN VARCHAR2 Ip de creaci�n
  * @param Pv_Status               OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError             OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 22-01-2021
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 02-08-2021 Se agrega la validaci�n del env�o de SMS por producto
  *
  */
  PROCEDURE P_EJECUTA_CPM_FLUJO_PRODS_TV(
    Pr_InfoServicioInternet IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet,
    Pn_IdPlanAnterior       IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pn_IdPlanNuevo          IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_ProcesoEjecutante    IN VARCHAR2,
    Pv_ObsProcesoEjecutante IN VARCHAR2,
    Pv_UsrCreacion          IN VARCHAR2,
    Pv_IpCreacion           IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2);

  /**
  * P_EJECUTA_FLUJOS_PRODS_CPM
  *
  * Procedimiento para ejecutar el proceso de cambio de plan masivo respecto a productos incluidos dentro del plan y adicionales 
  * que requieren un proceso extra al ya ejecutado
  *
  * @param Pn_IdServicioInternet    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio de Internet
  * @param Pn_IdPlanAnterior        IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE Id del plan anterior
  * @param Pn_IdPlanNuevo           IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE Id del plan nuevo
  * @param Pv_ProcesoEjecutante     IN VARCHAR2 Proceso que ejecuta el procedimiento
  * @param Pv_ObsProcesoEjecutante  IN VARCHAR2 Observaci�n por el proceso ejecutante
  * @param Pv_UsrCreacion           IN VARCHAR2 Usuario de creaci�n
  * @param Pv_IpCreacion            IN VARCHAR2 Ip de creaci�n
  * @param Pv_Status                OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError              OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 22-01-2021
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 03-02-2021 Se agrega el flujo para servicios con W+AP
  *
  */
  PROCEDURE P_EJECUTA_FLUJOS_PRODS_CPM(
    Pn_IdServicioInternet   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdPlanAnterior       IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pn_IdPlanNuevo          IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_ProcesoEjecutante    IN VARCHAR2,
    Pv_ObsProcesoEjecutante IN VARCHAR2,
    Pv_UsrCreacion          IN VARCHAR2,
    Pv_IpCreacion           IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2);

  /**
  * P_CREA_CORTE_MASIVO_X_LOTES
  *
  * Procedimiento para crear los registros para ejecutar un corte masivo
  *
  * @param Pcl_JsonFiltrosBusqueda  IN CLOB  Filtros de b�squeda del corte masivo
  * @param Pv_PrefijoEmpresa        IN VARCHAR2 Prefijo de la empresa
  * @param Pv_UsrCreacion           IN VARCHAR2 Usuario de creaci�n
  * @param Pv_IpCreacion            IN VARCHAR2 Ip de creaci�n
  * @param Pv_Status                OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError              OUT VARCHAR2 Mensaje de error
  * @param Pn_IdSolCortePorLotes    OUT NUMBER Id de la solicitud para ejecuci�n de corte masivo por lotes
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 20-09-2021
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.1 26-09-2022  Se agrega actualizaci�n de estado a todos los detalles de pm y cabecera pm correspondiente
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.8 07-03-2023     Se incluye validaciones para considerar a la empresa de Ecuanet en el proceso masivo de corte.
  *
  *
  */
  PROCEDURE P_CREA_CORTE_MASIVO_X_LOTES(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_PrefijoEmpresa       IN VARCHAR2,
    Pv_UsrCreacion          IN VARCHAR2,
    Pv_IpCreacion           IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pn_IdSolCortePorLotes   OUT NUMBER);

  /**
  * P_EJECUTA_CORTE_MASIVO_X_LOTES
  *
  * Procedimiento para ejecutar los procesos masivos por lotes de manera autom�tica
  *
  * @param Pv_Status    OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError  OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 27-09-2021
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 07-12-2021 Se agrega estado permitido para actualizar registros de la INFO_PROCESO_MASIVO_DET al ejecutar el corte masivo por lotes.
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.2 25-03-2022 Se agregan validaciones para verificar filas actualizadas y proceder a nuevas actualizaciones o ingreso de historiales. 
  *
  */
  PROCEDURE P_EJECUTA_CORTE_MASIVO_X_LOTES(
    Pv_Status   OUT VARCHAR2,
    Pv_MsjError OUT VARCHAR2);

  /**
  * P_FIN_REGS_CORTE_MASIVO_XLOTES
  *
  * Procedimiento para dar de baja de manera autom�tica todos los procesos de corte masivo por lotes  
  *
  * @param Pv_Status    OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError  OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 27-09-2021
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 25-03-2022 Se agrega validaci�n para dar de baja aquellos registros de solicitud y cabecera de procesos masivos que ya han ejecutado
  *                         los detalles de dicho proceso masivo.
  *
  */
  PROCEDURE P_FIN_REGS_CORTE_MASIVO_XLOTES(
    Pv_Status   OUT VARCHAR2,
    Pv_MsjError OUT VARCHAR2);

  /**
  * P_FINALIZA_CORTE_MASIVO_XLOTES
  *
  * Procedimiento que se ejecuta a las 7am del d�a siguiente al que se ejecuta un corte masivo por lotes 
  *
  * @param Pv_Status    OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError  OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  *
  */
  PROCEDURE P_FINALIZA_CORTE_MASIVO_XLOTES(
    Pv_Status   OUT VARCHAR2,
    Pv_MsjError OUT VARCHAR2);

  /**
  * P_REPORTE_CORTE_MASIVO_XLOTES
  *
  * Procedimiento que crea el archivo con el reporte de clientes que forman parte del corte masivo por lotes 
  *
  * @param Pn_IdComunicacion    IN DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE Id de la tarea creada para revisi�n del reporte del corte
  * @param Pn_IdDetalle         IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE Id del detalle al que est� asociado la tarea
  * @param Pv_Status            OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError          OUT VARCHAR2 Mensaje de error
  * @param Pn_IdDocumento       OUT NUMBER Id del documento asociado al reporte creado
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 27-09-2021
  *
  */
  PROCEDURE P_REPORTE_CORTE_MASIVO_XLOTES(
    Pn_IdComunicacion       IN DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pn_IdDetalle            IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pn_IdDocumento          OUT NUMBER);

  /**
  * P_FINALIZA_PMS_POR_OPCION
  *
  * Procedimiento que finaliza los procesos masivos al ejecutar las opciones parametrizadas
  *
  * @param Pn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Id del punto
  * @param Pv_OpcionEjecutante  IN VARCHAR2 Opci�n a ejecutar
  * @param Pv_CodEmpresa        IN VARCHAR2 Id de la empresa
  * @param Pv_PrefijoEmpresa    IN VARCHAR2 Prefijo de la empresa
  * @param Pv_Status            OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError          OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 07-12-2021
  *
  */
  PROCEDURE P_FINALIZA_PMS_POR_OPCION(  
    Pn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pv_OpcionEjecutante IN VARCHAR2,
    Pv_CodEmpresa       IN VARCHAR2,
    Pv_PrefijoEmpresa   IN VARCHAR2,
    Pv_Status           OUT VARCHAR2,
    Pv_MsjError         OUT VARCHAR2);

  /**
  * P_CREA_PM_REACTIVACION_MD_CSV
  *
  * Procedimiento que crea los procesos masivos de reactivaci�n de manera autom�tica de los logines subidos a un archivo csv con la estructura
  * reactivaciones_masivas_YYYY-MM-DD.csv del d�a en que se realice la ejecuci�n. 
  * El archivo debe estar situado en el directorio de base de datos RESPSOLARIS
  * 
  * @param Pv_Status            OUT VARCHAR2 Estado del procedimiento
  * @param Pv_MsjError          OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 14-01-2022
  *
  */
  PROCEDURE P_CREA_PM_REACTIVACION_MD_CSV(
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2);

    /**
    * PROCESA_CREACION_MONITOREO_TG
    *
    * PROCEDIMIENTO DE CREACION DEL MONITOREO DE CLIENTES EN TELCOGRAPH
    *
    * @author Felix Caicedo <facaicedo@telconet.ec>
    * @version 1.0 27/06/2022
    * @since 1.0
    *
    */
    PROCEDURE PROCESA_CREACION_MONITOREO_TG;

END INKG_TRANSACCIONES_MASIVAS;
/

CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS
AS
  PROCEDURE P_INSERT_PROCESO_MASIVO_CAB(
      Pr_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
      Pn_IdProcesoMasivoCab   OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
      Pv_MsjError             OUT VARCHAR2)
  IS
  BEGIN
    Pn_IdProcesoMasivoCab := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
    INSERT
    INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      (
        ID_PROCESO_MASIVO_CAB,
        TIPO_PROCESO,
        EMPRESA_ID,
        CANAL_PAGO_LINEA_ID,
        CANTIDAD_PUNTOS,
        CANTIDAD_SERVICIOS,
        FACTURAS_RECURRENTES,
        FECHA_EMISION_FACTURA,
        FECHA_CORTE_DESDE,
        FECHA_CORTE_HASTA,
        VALOR_DEUDA,
        FORMA_PAGO_ID,
        IDS_BANCOS_TARJETAS,
        IDS_OFICINAS,
        ESTADO,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        IP_CREACION,
        PLAN_ID,
        PLAN_VALOR,
        PAGO_ID,
        PAGO_LINEA_ID,
        RECAUDACION_ID,
        DEBITO_ID,
        ELEMENTO_ID,
        SOLICITUD_ID
      )
      VALUES
      (
        Pn_IdProcesoMasivoCab,
        Pr_InfoProcesoMasivoCab.TIPO_PROCESO,
        Pr_InfoProcesoMasivoCab.EMPRESA_ID,
        Pr_InfoProcesoMasivoCab.CANAL_PAGO_LINEA_ID,
        Pr_InfoProcesoMasivoCab.CANTIDAD_PUNTOS,
        Pr_InfoProcesoMasivoCab.CANTIDAD_SERVICIOS,
        Pr_InfoProcesoMasivoCab.FACTURAS_RECURRENTES,
        Pr_InfoProcesoMasivoCab.FECHA_EMISION_FACTURA,
        Pr_InfoProcesoMasivoCab.FECHA_CORTE_DESDE,
        Pr_InfoProcesoMasivoCab.FECHA_CORTE_HASTA,
        Pr_InfoProcesoMasivoCab.VALOR_DEUDA,
        Pr_InfoProcesoMasivoCab.FORMA_PAGO_ID,
        Pr_InfoProcesoMasivoCab.IDS_BANCOS_TARJETAS,
        Pr_InfoProcesoMasivoCab.IDS_OFICINAS,
        Pr_InfoProcesoMasivoCab.ESTADO,
        Pr_InfoProcesoMasivoCab.FE_CREACION,
        Pr_InfoProcesoMasivoCab.FE_ULT_MOD,
        Pr_InfoProcesoMasivoCab.USR_CREACION,
        Pr_InfoProcesoMasivoCab.USR_ULT_MOD,
        Pr_InfoProcesoMasivoCab.IP_CREACION,
        Pr_InfoProcesoMasivoCab.PLAN_ID,
        Pr_InfoProcesoMasivoCab.PLAN_VALOR,
        Pr_InfoProcesoMasivoCab.PAGO_ID,
        Pr_InfoProcesoMasivoCab.PAGO_LINEA_ID,
        Pr_InfoProcesoMasivoCab.RECAUDACION_ID,
        Pr_InfoProcesoMasivoCab.DEBITO_ID,
        Pr_InfoProcesoMasivoCab.ELEMENTO_ID,
        Pr_InfoProcesoMasivoCab.SOLICITUD_ID
      );
  EXCEPTION
  WHEN OTHERS THEN
    Pn_IdProcesoMasivoCab := 0;
    Pv_MsjError           := SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_CAB', 
                                         Pv_MsjError, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_INSERT_PROCESO_MASIVO_CAB;

  PROCEDURE P_INSERT_PROCESO_MASIVO_DET(
      Pr_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
      Pn_IdProcesoMasivoDet   OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
      Pv_MsjError             OUT VARCHAR2)
  IS
  BEGIN
    Pn_IdProcesoMasivoDet := SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
    INSERT
    INTO INFO_PROCESO_MASIVO_DET
      (
        ID_PROCESO_MASIVO_DET,
        PROCESO_MASIVO_CAB_ID,
        PUNTO_ID,
        ESTADO,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        IP_CREACION,
        SERVICIO_ID,
        OBSERVACION,
        SOLICITUD_ID
      )
      VALUES
      (
        Pn_IdProcesoMasivoDet,
        Pr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID,
        Pr_InfoProcesoMasivoDet.PUNTO_ID,
        Pr_InfoProcesoMasivoDet.ESTADO,
        Pr_InfoProcesoMasivoDet.FE_CREACION,
        Pr_InfoProcesoMasivoDet.FE_ULT_MOD,
        Pr_InfoProcesoMasivoDet.USR_CREACION,
        Pr_InfoProcesoMasivoDet.USR_ULT_MOD,
        Pr_InfoProcesoMasivoDet.IP_CREACION,
        Pr_InfoProcesoMasivoDet.SERVICIO_ID,
        Pr_InfoProcesoMasivoDet.OBSERVACION,
        Pr_InfoProcesoMasivoDet.SOLICITUD_ID
      );
  EXCEPTION
  WHEN OTHERS THEN
    Pn_IdProcesoMasivoDet := 0;
    Pv_MsjError           := SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_DET', 
                                         Pv_MsjError, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_INSERT_PROCESO_MASIVO_DET;

  PROCEDURE P_INSERT_SPC(
    Pn_IdServicio                   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdProducto                   IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Pv_EstadoAdmiProdCaract         IN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA.ESTADO%TYPE,
    Pv_DescripcionCaracteristica    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_ValorServicioProdCaract      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Pv_EstadoServicioProdCaract     IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE,
    Pv_UsrCreacion                  IN VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2)
  AS
  BEGIN
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    (
      ID_SERVICIO_PROD_CARACT,
      SERVICIO_ID,
      PRODUCTO_CARACTERISITICA_ID,
      VALOR,
      FE_CREACION,
      USR_CREACION,
      ESTADO
    )
    VALUES
    (
      DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
      Pn_IdServicio,
      ( SELECT APC.ID_PRODUCTO_CARACTERISITICA
        FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
        ON APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        WHERE APC.PRODUCTO_ID = Pn_IdProducto
        AND APC.ESTADO = Pv_EstadoAdmiProdCaract
        AND AC.DESCRIPCION_CARACTERISTICA = Pv_DescripcionCaracteristica
        AND ROWNUM = 1
      ),
      Pv_ValorServicioProdCaract,
      SYSDATE,
      Pv_UsrCreacion,
      Pv_EstadoServicioProdCaract
    );
    Pv_MsjError := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjError  := 'No se ha podido crear el registro de la asociaci�n del servicio con ID ' || Pn_IdServicio 
                    || ' y la caracter�stica ' || Pv_DescripcionCaracteristica || ' con valor ' || Pv_ValorServicioProdCaract ;
  END P_INSERT_SPC;

  PROCEDURE P_ELIMINA_SPC(
    Pn_IdSpcUnicoPorActualizar      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE,
    Pn_IdServicio                   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdProducto                   IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Pv_NombreTecnicoProducto        IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Pv_DescripcionCaracteristica    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_SetValorSpc                  IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Pv_UsrUltMod                    IN VARCHAR2,
    Pv_Status                       OUT VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2)
  IS
    Lv_EstadoActivo     VARCHAR2(6) := 'Activo';
    Lv_EstadoEliminado  VARCHAR2(9) := 'Eliminado';
    Lv_UsrUltMod        VARCHAR2(15);
    Lv_MsjError         VARCHAR2(4000);
    Le_Exception        EXCEPTION;
  BEGIN
    IF Pv_UsrUltMod IS NOT NULL THEN
      Lv_UsrUltMod := Pv_UsrUltMod;
    ELSE
      Lv_UsrUltMod := 'eliminaSpcMasiv';
    END IF;
    
    IF Pn_IdSpcUnicoPorActualizar IS NOT NULL THEN
      IF Pv_SetValorSpc IS NOT NULL THEN
        UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
        SET VALOR = Pv_SetValorSpc,
        ESTADO = Lv_EstadoEliminado,
        USR_ULT_MOD = Lv_UsrUltMod,
        FE_ULT_MOD = SYSDATE
        WHERE ID_SERVICIO_PROD_CARACT = Pn_IdSpcUnicoPorActualizar;
      ELSE
        UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
        SET ESTADO = Lv_EstadoEliminado,
        USR_ULT_MOD = Lv_UsrUltMod,
        FE_ULT_MOD = SYSDATE
        WHERE ID_SERVICIO_PROD_CARACT = Pn_IdSpcUnicoPorActualizar;
      END IF;
    ELSIF Pn_IdServicio IS NOT NULL THEN
      IF Pn_IdProducto IS NOT NULL THEN
        IF Pv_DescripcionCaracteristica IS NOT NULL THEN
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET ESTADO = Lv_EstadoEliminado,
          USR_ULT_MOD = Lv_UsrUltMod,
          FE_ULT_MOD = SYSDATE
          WHERE SERVICIO_ID = Pn_IdServicio
          AND ESTADO = Lv_EstadoActivo
          AND PRODUCTO_CARACTERISITICA_ID IN 
            (
              SELECT ID_PRODUCTO_CARACTERISITICA
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT
              INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
              ON CARACT.ID_CARACTERISTICA = PROD_CARACT.CARACTERISTICA_ID
              WHERE PROD_CARACT.PRODUCTO_ID = Pn_IdProducto
              AND CARACT.DESCRIPCION_CARACTERISTICA = Pv_DescripcionCaracteristica
            );
        ELSE
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET ESTADO = Lv_EstadoEliminado,
          USR_ULT_MOD = Lv_UsrUltMod,
          FE_ULT_MOD = SYSDATE
          WHERE SERVICIO_ID = Pn_IdServicio
          AND ESTADO = Lv_EstadoActivo
          AND PRODUCTO_CARACTERISITICA_ID IN 
            (
              SELECT ID_PRODUCTO_CARACTERISITICA
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT
              WHERE PROD_CARACT.PRODUCTO_ID = Pn_IdProducto
            );
        END IF;
        
      ELSIF Pv_NombreTecnicoProducto IS NOT NULL THEN
        IF Pv_DescripcionCaracteristica IS NOT NULL THEN
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET ESTADO = Lv_EstadoEliminado,
          USR_ULT_MOD = Lv_UsrUltMod,
          FE_ULT_MOD = SYSDATE
          WHERE SERVICIO_ID = Pn_IdServicio
          AND ESTADO = Lv_EstadoActivo
          AND PRODUCTO_CARACTERISITICA_ID IN 
            (
              SELECT ID_PRODUCTO_CARACTERISITICA
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT
              INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
              ON CARACT.ID_CARACTERISTICA = PROD_CARACT.CARACTERISTICA_ID
              INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
              ON PROD.ID_PRODUCTO = PROD_CARACT.PRODUCTO_ID
              WHERE PROD.NOMBRE_TECNICO = Pv_NombreTecnicoProducto
              AND CARACT.DESCRIPCION_CARACTERISTICA = Pv_DescripcionCaracteristica
            );
        ELSE
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET ESTADO = Lv_EstadoEliminado,
          USR_ULT_MOD = Lv_UsrUltMod,
          FE_ULT_MOD = SYSDATE
          WHERE SERVICIO_ID = Pn_IdServicio
          AND ESTADO = Lv_EstadoActivo
          AND PRODUCTO_CARACTERISITICA_ID IN 
            (
              SELECT ID_PRODUCTO_CARACTERISITICA
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT
              INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
              ON PROD.ID_PRODUCTO = PROD_CARACT.PRODUCTO_ID
              WHERE PROD.NOMBRE_TECNICO = Pv_NombreTecnicoProducto
            );
        END IF;
        
      ELSIF Pv_DescripcionCaracteristica IS NOT NULL THEN
        UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
        SET ESTADO = Lv_EstadoEliminado,
        USR_ULT_MOD = Lv_UsrUltMod,
        FE_ULT_MOD = SYSDATE
        WHERE SERVICIO_ID = Pn_IdServicio
        AND ESTADO = Lv_EstadoActivo
        AND PRODUCTO_CARACTERISITICA_ID IN 
          (
            SELECT ID_PRODUCTO_CARACTERISITICA
            FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
            ON CARACT.ID_CARACTERISTICA = PROD_CARACT.CARACTERISTICA_ID
            WHERE CARACT.DESCRIPCION_CARACTERISTICA = Pv_DescripcionCaracteristica
          );
          
      ELSE
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET ESTADO = Lv_EstadoEliminado,
          USR_ULT_MOD = Lv_UsrUltMod,
          FE_ULT_MOD = SYSDATE
          WHERE SERVICIO_ID = Pn_IdServicio
          AND ESTADO = Lv_EstadoActivo;
      END IF;
    ELSE
      Lv_MsjError := 'No se han enviado correctamente los par�metros obligatorios';
      RAISE Le_Exception;
    END IF;
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC', 
                                            Lv_MsjError, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido eliminar correctamente las caracter�sticas asociadas a los servicios';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC', 
                                         SQLCODE || ' - ERROR_STACK: ' 
                                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_ELIMINA_SPC;

  PROCEDURE P_CREA_PM_REGULARIZA_SERVS(
    Pv_UsrCreacion  IN VARCHAR2,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2)
  IS
    Lv_UsrCreacion                  VARCHAR2(15);
    CURSOR Lc_GetServiciosARegularizar
    IS
    WITH T_SERVICIOS_CARACTS_REPETIDAS AS
      (SELECT SERVICIO.PUNTO_ID AS ID_PUNTO,
        SERVICIO.ID_SERVICIO,
        SERVICIO.ESTADO AS ESTADO_SERVICIO,
        CARACT.ID_CARACTERISTICA
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC
      ON SPC.SERVICIO_ID = SERVICIO.ID_SERVICIO
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
      ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON CARACT.ID_CARACTERISTICA            = APC.CARACTERISTICA_ID
      WHERE SERVICIO.PLAN_ID                IS NOT NULL
      AND CARACT.DESCRIPCION_CARACTERISTICA IN ('GEM-PORT', 'TRAFFIC-TABLE', 'VLAN', 'SERVICE-PROFILE', 'LINE-PROFILE-NAME', 'INDICE CLIENTE', 
                                                'SPID', 'PERFIL', 'CAPACIDAD1', 'CAPACIDAD2', 'CLIENT CLASS', 'PACKAGE ID')
      AND SPC.ESTADO                         = 'Activo'
      GROUP BY SERVICIO.PUNTO_ID,
        SERVICIO.ID_SERVICIO,
        SERVICIO.ESTADO,
        CARACT.ID_CARACTERISTICA
      HAVING COUNT(SPC.ID_SERVICIO_PROD_CARACT) > 1
      ),
      T_SERVICIOS_PERMITIDOS AS
      (SELECT *
      FROM
        (SELECT DISTINCT ID_PUNTO,
          ID_SERVICIO,
          ESTADO_SERVICIO,
          NVL(
          (SELECT 'SI'
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
          ON DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
          WHERE CAB.NOMBRE_PARAMETRO= 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
          AND DET.VALOR1            = 'DATA_CLIENTE_MASIVO'
          AND DET.VALOR2            = 'ESTADOS_SERVICIOS_A_CONSIDERAR'
          AND DET.VALOR3            = ESTADO_SERVICIO
          AND CAB.ESTADO            = 'Activo'
          AND DET.ESTADO            = 'Activo'
          ), 'NO') AS ESTADO_PERMITIDO,
          NVL(
          (SELECT 'SI'
          FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
          INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PM_DET
          ON PM_DET.PROCESO_MASIVO_CAB_ID = PM_CAB.ID_PROCESO_MASIVO_CAB
          WHERE PM_DET.PUNTO_ID           = ID_PUNTO
          AND PM_CAB.TIPO_PROCESO        IN
            (SELECT DET.VALOR3
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
            ON DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
            WHERE CAB.NOMBRE_PARAMETRO= 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
            AND DET.VALOR1            = 'DATA_CLIENTE_MASIVO'
            AND DET.VALOR2            = 'CONFIG_GENERAL'
            AND CAB.ESTADO            = 'Activo'
            AND DET.ESTADO            = 'Activo'
            )
          AND PM_DET.ESTADO IN
            (SELECT DET.VALOR3
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
            ON DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
            WHERE CAB.NOMBRE_PARAMETRO= 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
            AND DET.VALOR1            = 'DATA_CLIENTE_MASIVO'
            AND DET.VALOR2            = 'ESTADOS_PM_DET_ABIERTOS'
            AND CAB.ESTADO            = 'Activo'
            AND DET.ESTADO            = 'Activo'
            )
          AND ROWNUM = 1
          ), 'NO') AS TIENE_PM_DET_ABIERTO
        FROM T_SERVICIOS_CARACTS_REPETIDAS
        )
      WHERE ESTADO_PERMITIDO   = 'SI'
      AND TIENE_PM_DET_ABIERTO = 'NO'
      ),
      T_SERVICIOS_A_REGULARIZAR AS
      (SELECT OLT.ID_ELEMENTO AS ID_OLT,
        SERVICIOS_PERMITIDOS.ID_PUNTO,
        SERVICIOS_PERMITIDOS.ID_SERVICIO
      FROM T_SERVICIOS_PERMITIDOS SERVICIOS_PERMITIDOS
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ST
      ON ST.SERVICIO_ID = SERVICIOS_PERMITIDOS.ID_SERVICIO
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
      ON OLT.ID_ELEMENTO = ST.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
      ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_OLT
      ON MARCA_OLT.ID_MARCA_ELEMENTO = MODELO_OLT.MARCA_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ONT
      ON ONT.ID_ELEMENTO = ST.ELEMENTO_CLIENTE_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ONT
      ON MODELO_ONT.ID_MODELO_ELEMENTO = ONT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ONT
      ON MARCA_ONT.ID_MARCA_ELEMENTO = MODELO_ONT.MARCA_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_ONT
      ON TIPO_ONT.ID_TIPO_ELEMENTO           = MODELO_ONT.TIPO_ELEMENTO_ID
      WHERE ST.ULTIMA_MILLA_ID               = 1
      AND ( (MARCA_OLT.NOMBRE_MARCA_ELEMENTO = 'TELLION')
      OR (MARCA_OLT.NOMBRE_MARCA_ELEMENTO    = 'ZTE'
      AND MARCA_ONT.NOMBRE_MARCA_ELEMENTO    = 'ZTE'
      AND TIPO_ONT.NOMBRE_TIPO_ELEMENTO      = 'CPE ONT' )
      OR (MARCA_OLT.NOMBRE_MARCA_ELEMENTO    = 'HUAWEI'
      AND MARCA_ONT.NOMBRE_MARCA_ELEMENTO    = 'HUAWEI'
      AND TIPO_ONT.NOMBRE_TIPO_ELEMENTO      = 'CPE ONT' ) )
      )
    SELECT SERVICIOS_A_REGULARIZAR.ID_OLT,
      SERVICIOS_A_REGULARIZAR.ID_PUNTO,
      SERVICIOS_A_REGULARIZAR.ID_SERVICIO
    FROM T_SERVICIOS_A_REGULARIZAR SERVICIOS_A_REGULARIZAR
    WHERE ROWNUM <=
      (SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR5,'^\d+')), 0)
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      WHERE CAB.NOMBRE_PARAMETRO= 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
      AND DET.VALOR1            = 'DATA_CLIENTE_MASIVO'
      AND DET.VALOR2            = 'CONFIG_GENERAL'
      AND CAB.ESTADO            = 'Activo'
      AND DET.ESTADO            = 'Activo'
      );
    Ln_ContadorServicios    NUMBER := 0;
    Lr_InfoProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Ln_IdProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Lr_InfoProcesoMasivoDet DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;
    Ln_IdProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;
    Lv_TipoProceso          VARCHAR2(20) := 'RegularizarCliente';
    Lv_EstadoProcesando     VARCHAR2(11) := 'Procesando';
    Lv_EstadoPendiente      VARCHAR2(9) := 'Pendiente';
    Lv_Observacion          VARCHAR2(600) := 'Registro creado por proceso de regularizaci�n de data t�cnica del servicio';
    Lv_CodEmpresa           NUMBER := 18;
    Lv_MsjError             VARCHAR2(4000);
    Le_Exception            EXCEPTION;
  BEGIN
    IF Pv_UsrCreacion IS NOT NULL THEN
      Lv_UsrCreacion := Pv_UsrCreacion;
    ELSE
      Lv_UsrCreacion := 'regulaCliente';
    END IF;
    FOR I_GetServiciosARegularizar IN Lc_GetServiciosARegularizar
    LOOP
      IF Ln_ContadorServicios = 0 THEN
        Lr_InfoProcesoMasivoCab              := NULL;
        Lr_InfoProcesoMasivoCab.TIPO_PROCESO := Lv_TipoProceso;
        Lr_InfoProcesoMasivoCab.EMPRESA_ID   := Lv_CodEmpresa;
        Lr_InfoProcesoMasivoCab.ESTADO       := Lv_EstadoProcesando;
        Lr_InfoProcesoMasivoCab.FE_CREACION  := SYSDATE;
        Lr_InfoProcesoMasivoCab.USR_CREACION := Lv_UsrCreacion;
        Lr_InfoProcesoMasivoCab.IP_CREACION  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
        DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Ln_IdProcesoMasivoCab, Lv_MsjError);
        IF Lv_MsjError IS NOT NULL THEN 
          RAISE Le_Exception;
        END IF;
      END IF;
      IF Ln_IdProcesoMasivoCab <> 0 THEN
        Lr_InfoProcesoMasivoDet                       := NULL;
        Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID := Ln_IdProcesoMasivoCab;
        Lr_InfoProcesoMasivoDet.PUNTO_ID              := I_GetServiciosARegularizar.ID_PUNTO;
        Lr_InfoProcesoMasivoDet.ESTADO                := Lv_EstadoPendiente;
        Lr_InfoProcesoMasivoDet.FE_CREACION           := SYSDATE;
        Lr_InfoProcesoMasivoDet.USR_CREACION          := Lv_UsrCreacion;
        Lr_InfoProcesoMasivoDet.IP_CREACION           := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
        Lr_InfoProcesoMasivoDet.SERVICIO_ID           := I_GetServiciosARegularizar.ID_SERVICIO;
        Lr_InfoProcesoMasivoDet.OBSERVACION           := Lv_Observacion;
        DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_DET(Lr_InfoProcesoMasivoDet, Ln_IdProcesoMasivoDet, Lv_MsjError);
        IF Lv_MsjError IS NOT NULL THEN 
          RAISE Le_Exception;
        END IF;
        IF Ln_IdProcesoMasivoDet <> 0 THEN
          COMMIT;
          Ln_ContadorServicios := Ln_ContadorServicios + 1;
        END IF;
      END IF;
    END LOOP;
    IF Ln_ContadorServicios <> 0 THEN
      UPDATE INFO_PROCESO_MASIVO_CAB
      SET CANTIDAD_PUNTOS         = Ln_ContadorServicios,
        CANTIDAD_SERVICIOS        = Ln_ContadorServicios,
        ESTADO                    = Lv_EstadoPendiente
      WHERE ID_PROCESO_MASIVO_CAB = Ln_IdProcesoMasivoCab;
      COMMIT;
    END IF;
    Pv_Status := 'OK';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_CREA_PM_REGULARIZA_SERVS', 
                                            Lv_MsjError, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido crear correctamente el proceso masivo por regularizaci�n';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'INKG_TRANSACCIONES_MASIVAS.P_CREA_PM_REGULARIZA_SERVS', 
                                         SQLCODE || ' - ERROR_STACK: ' 
                                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_CREA_PM_REGULARIZA_SERVS;

  PROCEDURE P_NOTIF_CORREO_Y_SMS_PRODS_TV(
    Pv_TipoNotif                  IN VARCHAR2,
    Pcl_Contenido                 IN CLOB,
    Pn_IdPunto                    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_IdPersona                  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    Pv_AsuntoCorreo               IN VARCHAR2,
    Pv_CorreosDestinatarios       IN VARCHAR2,
    Pv_AgregaFormasContactoPunto  IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pcl_DestinatariosFinales      OUT CLOB
    )
  AS
    Lv_Metodo                   VARCHAR2(10);
    Lv_Version                  VARCHAR2(10);
    Lv_Aplicacion               VARCHAR2(50);
    Lv_UrlEnvioSms              VARCHAR2(200);
    Ln_LongitudReq              NUMBER;
    Ln_LongitudIdeal            NUMBER:= 32767;
    Ln_Offset                   NUMBER:= 1;
    Ln_Buffer                   VARCHAR2(2000);
    Ln_Amount                   NUMBER := 2000;
    Lc_Json                     CLOB;
    Lhttp_Request               UTL_HTTP.req;
    Lhttp_Response              UTL_HTTP.resp;
    data                        VARCHAR2(4000);
    Lv_Status                   VARCHAR2(50);
    Lv_MsjToken                 VARCHAR2(4000);
    Lv_MsjError                 VARCHAR2(4000);
    Lv_MensajeError             VARCHAR2(4000);
    Lv_UserName                 VARCHAR2(30);
    Lv_UserCreate               VARCHAR2(30) := 'NOTIF_PRODS_TV';
    Lv_AppError                 VARCHAR2(30) := 'TELCOS';
    Lv_ProcesoError             VARCHAR2(70) := 'INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_Password                 VARCHAR2(30);
    Lv_URLToken                 VARCHAR2(200);
    Lv_Name                     VARCHAR2(30);
    Lv_Token                    VARCHAR2(100);
    Lv_StatusToken              VARCHAR2(30);
    Le_Error                    EXCEPTION;
    Le_Exception                EXCEPTION;
    Lv_PrimerDigitNumMovil      VARCHAR2(1);
    Lv_NumMovil                 VARCHAR2(100);
    Lv_NotifyUrl                VARCHAR2(500);
    Lv_CorreosDestinatarios     VARCHAR2(4000);
    Lv_MovilDestinatarios       CLOB;
    Lv_Remitente                VARCHAR2(200) := 'notificacionesnetlife@netlife.info.ec';
    Lr_ParametroDetalleBusqueda DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_RespuestaInfoToken      SYS_REFCURSOR;
    Lrf_RespuestaConsumoSMS     SYS_REFCURSOR;
    Lr_RespuestaInfoToken       DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_RespuestaConsumoSMS      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lcl_DestinatariosSMS        CLOB;
    CURSOR Lc_GetFormasContacto(Cn_IdPunto                  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Cv_DescripcionFormaContacto DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
                                Cn_IdPersona                DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE)
    IS                            
      SELECT DISTINCT IPFC.VALOR
      FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
      INNER JOIN DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO IPFC
      ON IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
      WHERE AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_DescripcionFormaContacto
          AND AFC.ESTADO = Lv_EstadoActivo
          AND IPFC.PUNTO_ID = Cn_IdPunto
          AND IPFC.ESTADO = Lv_EstadoActivo
      UNION
      SELECT DISTINCT IPFC.VALOR
      FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC
      ON IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
      WHERE AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_DescripcionFormaContacto
      AND AFC.ESTADO = Lv_EstadoActivo
      AND IPFC.PERSONA_ID = Cn_IdPersona
      AND IPFC.ESTADO = Lv_EstadoActivo;
  BEGIN               
    Lv_Token        := '';
    Lv_Status       := '';
    Lv_StatusToken  := '';
    Lv_MsjToken     := '';
    Lv_MsjError     := '';
    Lv_Metodo       := 'POST';
    Lv_Version      := ' HTTP/1.1';
    Lv_Aplicacion   := 'application/json';
    
    Lr_ParametroDetalleBusqueda         := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1  := 'INFO_TOKEN_PROCESOS_MASIVOS_BD';
    Lrf_RespuestaInfoToken              := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    FETCH Lrf_RespuestaInfoToken INTO Lr_RespuestaInfoToken;
    IF Lr_RespuestaInfoToken.ID_PARAMETRO_DET IS NOT NULL THEN 
      Lv_URLToken := Lr_RespuestaInfoToken.VALOR2;
      Lv_Name     := Lr_RespuestaInfoToken.VALOR3;
      Lv_UserName := Lr_RespuestaInfoToken.VALOR4;
      Lv_Password := Lr_RespuestaInfoToken.VALOR5;  
    ELSE
      Lv_MsjError := 'No se ha podido obtener los par�metros para obtener el Token';
      RAISE Le_Exception;
    END IF;
    
    Lr_ParametroDetalleBusqueda         := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1  := 'INFO_CONSUMO_WS_SMS';
    Lrf_RespuestaConsumoSMS             := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    FETCH Lrf_RespuestaConsumoSMS INTO Lr_RespuestaConsumoSMS;
    IF Lr_RespuestaConsumoSMS.ID_PARAMETRO_DET IS NOT NULL THEN 
      Lv_UrlEnvioSms  := Lr_RespuestaConsumoSMS.VALOR2;
      Lv_NotifyUrl    := Lr_RespuestaConsumoSMS.VALOR3;
    ELSE
      Lv_MsjError := 'No se ha podido obtener los par�metros para el consumo del web service SMS';
      RAISE Le_Exception;
    END IF;
    
    
    IF Pv_TipoNotif IS NULL OR (Pv_TipoNotif <> 'CORREO' AND Pv_TipoNotif <> 'SMS') THEN
      Lv_MsjError := 'No se ha enviado correctamente el tipo de notificaci�n -> ' || Pv_TipoNotif;
      RAISE Le_Exception;
    END IF;
 
    IF Pv_TipoNotif = 'CORREO' THEN
      BEGIN
        Lv_CorreosDestinatarios := Pv_CorreosDestinatarios;
        IF Lv_CorreosDestinatarios IS NULL OR Pv_AgregaFormasContactoPunto = 'SI' THEN
          FOR I_GetFormasContacto IN Lc_GetFormasContacto(Pn_IdPunto, 'Correo Electronico', Pn_IdPersona)
          LOOP
            IF I_GetFormasContacto.VALOR IS NOT NULL THEN
              Lv_CorreosDestinatarios := Lv_CorreosDestinatarios || I_GetFormasContacto.VALOR || ',';
            END IF;
          END LOOP;
        END IF;
        
        IF Lv_CorreosDestinatarios IS NULL THEN
          Lv_CorreosDestinatarios := Lv_CorreosDestinatarios || Lv_Remitente || ',';
        END IF;
      
        DB_GENERAL.GNRLPCK_UTIL.P_SEND_MAIL_SMTP( Lv_Remitente, 
                                                  Lv_CorreosDestinatarios, 
                                                  ',', 
                                                  Pv_AsuntoCorreo, 
                                                  NULL, 
                                                  NULL, 
                                                  Pcl_Contenido, 
                                                  'text/html; charset=iso-8859-1');
        
        Pv_Status                 := 'OK';
        Pv_MsjError               := '';
        Pcl_DestinatariosFinales  := SUBSTR(Lv_CorreosDestinatarios, 1, LENGTH(Lv_CorreosDestinatarios) - 1);
      EXCEPTION
      WHEN OTHERS THEN
        Pv_Status   := 'ERROR';
        Pv_MsjError := 'No se ha podido realizar el env�o por correo de manera correcta';
        Lv_MsjError := 'Error en INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_AppError, Lv_ProcesoError, Lv_MsjError, Lv_UserCreate, SYSDATE, '127.0.0.1');
      END;
    END IF;
    
    IF Pv_TipoNotif = 'SMS' THEN
      BEGIN
        FOR I_GetFormasContacto IN Lc_GetFormasContacto(Pn_IdPunto, '%Movil%', Pn_IdPersona)
        LOOP
          IF I_GetFormasContacto.VALOR IS NOT NULL THEN
            Lv_NumMovil := '';
            Lv_PrimerDigitNumMovil := SUBSTR(I_GetFormasContacto.VALOR, 1, 1);
            IF Lv_PrimerDigitNumMovil = '0' THEN
              Lv_NumMovil := '593' || SUBSTR(I_GetFormasContacto.VALOR, 2);
            ELSE
              Lv_NumMovil := I_GetFormasContacto.VALOR;
            END IF;
            
            Lcl_DestinatariosSMS := Lcl_DestinatariosSMS || 
                                    '{' ||
                                    '"to":"' || Lv_NumMovil || '",' ||
                                    '"messageId":"' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || TRUNC(ABS(DBMS_RANDOM.VALUE(1,100))) || '"' ||
                                    '},';
            Lv_MovilDestinatarios := Lv_MovilDestinatarios || Lv_NumMovil || ',';
          END IF;
        END LOOP;
        
        IF Lcl_DestinatariosSMS IS NOT NULL THEN
          Lcl_DestinatariosSMS := DBMS_LOB.SUBSTR(Lcl_DestinatariosSMS, DBMS_LOB.GETLENGTH(Lcl_DestinatariosSMS) - 1);
          NAF47_TNET.GEKG_TRANSACCION.P_GENERAR_TOKEN ( Lv_UserName,
                                                        Lv_Password,                                             
                                                        Lv_URLToken,                                             
                                                        Lv_Name,                                             
                                                        Lv_Token,                                    
                                                        Lv_StatusToken,     
                                                        Lv_MsjToken,
                                                        Lv_MsjError                              
                                                      );
          IF Lv_MsjError IS NOT NULL OR Lv_StatusToken <> '200' THEN
            RAISE Le_Error;
          ELSE
            Lc_Json := '{';
            Lc_Json := Lc_Json || '"token":"' || Lv_Token || '",';
            Lc_Json := Lc_Json || '"user":"' || Lv_UserName || '",';
            Lc_Json := Lc_Json || '"accion":"' || 'enviarIndividual'|| '",';
            Lc_Json := Lc_Json || '"source":' || '{"name":"' || Lv_Name || '",';
            Lc_Json := Lc_Json || '"originID":"' || '127.0.0.1' || '",';
            Lc_Json := Lc_Json || '"tipoOriginID":"' || 'IP' || '"},';
            Lc_Json := Lc_Json || '"data":' ||'{"jsonMensaje":"",';
            Lc_Json := Lc_Json || '"proceso":"' || 'NOTIF_SMS_TV' || '",';
            Lc_Json := Lc_Json || '"noCia":"' || '18' || '",';
            Lc_Json := Lc_Json || '"usuarioCreacion":"' || Lv_UserCreate ||'",';
            Lc_Json := Lc_Json || '"noSalida":"' || '",';
            Lc_Json := Lc_Json || '"mensajeSalida":"' || '",';
            Lc_Json := Lc_Json || '"bulkId":"' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || Lv_Token || '",';
            Lc_Json := Lc_Json || '"messages":[';
            Lc_Json := Lc_Json || '{ "from": "' || 'InfoSMS' || '",';
            Lc_Json := Lc_Json || '"destinations":[' || Lcl_DestinatariosSMS || '],';
            Lc_Json := Lc_Json || '"text":"' || Pcl_Contenido ||'",';
            Lc_Json := Lc_Json || '"sendAt":"' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') ||'",';
            Lc_Json := Lc_Json || '"flash":true,';
            Lc_Json := Lc_Json || '"intermediateReport":true,';
            Lc_Json := Lc_Json || '"notifyUrl":"' || Lv_NotifyUrl ||'",';
            Lc_Json := Lc_Json || '"notifyContentType":"' || 'application/json' ||'",';
            Lc_Json := Lc_Json || '"callbackData":"' || 'DLR callback data' ||'",';
            Lc_Json := Lc_Json || '"validityPeriod":720 } ] }';
            Lc_Json := Lc_Json ||'}';
            Lhttp_Request := UTL_HTTP.begin_request (Lv_UrlEnvioSms, Lv_Metodo, Lv_Version);
            UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
            UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);
            Ln_LongitudReq    := DBMS_LOB.getlength(Lc_Json);
            IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
              UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lc_Json));
              UTL_HTTP.write_text(Lhttp_Request, Lc_Json);
            ELSE
              UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
              WHILE (Ln_Offset < Ln_LongitudReq)
              LOOP
                DBMS_LOB.READ(Lc_Json, Ln_Amount, Ln_Offset, Ln_Buffer);
                UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
                Ln_Offset := Ln_Offset + Ln_Amount;
              END LOOP;
            END IF;
            Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
            utl_http.read_text(Lhttp_Response, data);
            apex_json.parse (data);
            Lv_Status   := apex_json.get_varchar2('salida');
            Lv_MsjError := apex_json.get_varchar2('mensaje');
            UTL_HTTP.end_response(Lhttp_Response);
            
            IF Lv_Status = '200' THEN
              Pv_Status                 := 'OK';
              Pv_MsjError               := '';
              Pcl_DestinatariosFinales  := SUBSTR(Lv_MovilDestinatarios, 1, LENGTH(Lv_MovilDestinatarios) - 1);
            ELSE
              Pv_Status                 := 'ERROR';
              Pv_MsjError               := 'No se ha podido realizar el env�o por SMS de manera correcta';
              Pcl_DestinatariosFinales  := NULL;
            END IF;
          END IF;
        END IF;  
      EXCEPTION
      WHEN Le_Error THEN
        Pv_Status                 := 'ERROR';
        Pv_MsjError               := 'Ha ocurrido un error al realizar el env�o de SMS';
        Pcl_DestinatariosFinales  := NULL;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_AppError,
                                             Lv_ProcesoError,
                                             Lv_MsjError,
                                             Lv_UserCreate, SYSDATE, '127.0.0.1');

      WHEN UTL_HTTP.end_of_body THEN
        Pv_Status                 := 'ERROR';
        Pv_MsjError               := 'Ha ocurrido un error al obtener la respuesta del env�o del SMS';
        Pcl_DestinatariosFinales  := NULL;
        Lv_MsjError           := 'Error UTL_HTTP.end_of_body';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_AppError, Lv_ProcesoError, Lv_MsjError, Lv_UserCreate, SYSDATE, '127.0.0.1');
        UTL_HTTP.end_response(Lhttp_Response);
      WHEN OTHERS THEN
        Pv_Status                 := 'ERROR';
        Pv_MsjError                := 'Ha ocurrido un error inesperado al realizar el env�o de SMS';
        Pcl_DestinatariosFinales  := NULL;
        Lv_MsjError           := 'Error en INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV: '||SQLERRM ||' ' 
                                 || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_AppError, Lv_ProcesoError, Lv_MsjError, Lv_UserCreate, SYSDATE, '127.0.0.1');
      END;
    END IF;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status                 := 'ERROR';
    Pv_MsjError               := 'Ha ocurrido un error al realizar el env�o de correo o SMS';
    Pcl_DestinatariosFinales  := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_AppError,
                                         Lv_ProcesoError,
                                         Lv_MsjError,
                                         Lv_UserCreate, SYSDATE, '127.0.0.1');
  WHEN OTHERS THEN
    Pv_Status                 := 'ERROR';
    Pv_MsjError               := 'Ha ocurrido un error inesperado al realizar el env�o de correo o SMS';
    Pcl_DestinatariosFinales  := NULL;
    UTL_MAIL.SEND (sender => 'procesos_masivos@telconet.ec', recipients => 'mlcruz@telconet.ec', 
                  subject => 'Ejecuci�n del proceso P_NOTIF_CORREO_Y_SMS_PRODS_TV', 
                  MESSAGE => 'Par�metros Enviado:  <br>' || SQLERRM, mime_type => 'text/html; charset=UTF-8' );
  END P_NOTIF_CORREO_Y_SMS_PRODS_TV;

  PROCEDURE P_CREA_LOG_SERV_ADIC(
    Pr_InfoServicioInternet       IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet,
    Pr_InfoServicioProdAdicional  IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioProdAdicional,
    Pv_UsrCreacion                IN VARCHAR2,
    Pv_IpCreacion                 IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2, 
    Pv_MsjError                   OUT VARCHAR2,
    Pn_IdServicioNuevo            OUT DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  AS
    Lv_UsrCreacion              VARCHAR2(15);
    Lv_IpCreacion               VARCHAR2(15);
    Lv_UsrVendedor              VARCHAR2(28);
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_DescripcionEmpleado      DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE := 'Empleado';
    Lv_NumeroOrdenTrabajo       VARCHAR2(30);
    Ln_IdOficinaVendedor        NUMBER;
    Ln_IdOrdenTrabajoServicio   DB_COMERCIAL.INFO_ORDEN_TRABAJO.ID_ORDEN_TRABAJO%TYPE := 0;
    Ln_IdServicioNuevo          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE := 0;
    Lr_ServicioHistorial        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_MsjError                 VARCHAR2(4000);
    Le_Exception                EXCEPTION;
    
    CURSOR Lc_NumeracionDoc(Cn_IdOficina NUMBER, Cv_Codigo VARCHAR2)
    IS
      SELECT ID_NUMERACION, (NUMERACION_UNO || '-' || NUMERACION_DOS || '-' || LPAD(SECUENCIA,7,'0')) NUMERACION, SECUENCIA
      FROM DB_COMERCIAL.ADMI_NUMERACION
      WHERE OFICINA_ID = Cn_IdOficina
      AND CODIGO = Cv_Codigo;

    CURSOR Lc_GetIdOficinaVendedor(Cv_UsrVendedor VARCHAR2)
    IS
      SELECT
        OFICINA_ID
      FROM
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
      WHERE
        ID_PERSONA_ROL = (
          SELECT
            MAX(IPER.ID_PERSONA_ROL)
          FROM
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
            JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID
            JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
            JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = IER.EMPRESA_COD
            JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
            JOIN DB_GENERAL.ADMI_TIPO_ROL ATR ON AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
          WHERE
            IPE.LOGIN = Cv_UsrVendedor
            AND IPER.ESTADO = Lv_EstadoActivo
            AND IEG.PREFIJO = Pr_InfoServicioInternet.PREFIJO_EMPRESA_VENDEDOR
            AND ATR.DESCRIPCION_TIPO_ROL = Lv_DescripcionEmpleado
            AND IPER.DEPARTAMENTO_ID IS NOT NULL
        );
    Lr_NumeracionDoc Lc_NumeracionDoc%ROWTYPE;
  BEGIN
    IF Pv_UsrCreacion IS NOT NULL THEN
      Lv_UsrCreacion := Pv_UsrCreacion;
    ELSE
      Lv_UsrCreacion := 'creaServAdic';
    END IF;
    
    IF Pv_IpCreacion IS NOT NULL THEN
      Lv_IpCreacion := Pv_IpCreacion;
    ELSE
      Lv_IpCreacion := '127.0.0.1';
    END IF;
    
    Lv_UsrVendedor := Pr_InfoServicioInternet.USR_VENDEDOR_SERVICIO;
    IF Lv_UsrVendedor IS NULL THEN
      Lv_UsrVendedor := Pr_InfoServicioInternet.USR_VENDEDOR_PTO;
    END IF;

    OPEN Lc_GetIdOficinaVendedor(Lv_UsrVendedor);
    FETCH Lc_GetIdOficinaVendedor INTO Ln_IdOficinaVendedor;
    CLOSE Lc_GetIdOficinaVendedor;

    IF Ln_IdOficinaVendedor IS NULL THEN
      Ln_IdOficinaVendedor := 58;
    END IF;

    OPEN Lc_NumeracionDoc(Ln_IdOficinaVendedor, 'ORD');
    FETCH Lc_NumeracionDoc INTO Lr_NumeracionDoc;
    IF(Lc_NumeracionDoc%FOUND) THEN
        Lv_NumeroOrdenTrabajo := Lr_NumeracionDoc.NUMERACION;
        UPDATE DB_COMERCIAL.ADMI_NUMERACION SET SECUENCIA = SECUENCIA + 1 WHERE ID_NUMERACION = Lr_NumeracionDoc.ID_NUMERACION;
    ELSE
      Lv_MsjError := 'No se pudo obtener la numeraci�n para la orden de trabajo';
      RAISE Le_Exception;    
    END IF;
    CLOSE Lc_NumeracionDoc;

    Ln_IdOrdenTrabajoServicio := DB_COMERCIAL.SEQ_INFO_ORDEN_TRABAJO.NEXTVAL;
    INSERT
    INTO DB_COMERCIAL.INFO_ORDEN_TRABAJO
    (
      ID_ORDEN_TRABAJO,
      NUMERO_ORDEN_TRABAJO,
      PUNTO_ID,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION,
      TIPO_ORDEN,
      OFICINA_ID,
      ESTADO
    )
    VALUES
    (
      Ln_IdOrdenTrabajoServicio,
      Lv_NumeroOrdenTrabajo,
      Pr_InfoServicioInternet.ID_PUNTO,
      SYSDATE,
      Lv_UsrCreacion,
      Lv_IpCreacion,
      'N',
      Ln_IdOficinaVendedor,
      'Activa'
    );

    Ln_IdServicioNuevo := DB_COMERCIAL.SEQ_INFO_SERVICIO.NEXTVAL;
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO
    (
      ID_SERVICIO,
      PUNTO_ID,
      PRODUCTO_ID,
      ORDEN_TRABAJO_ID,
      ES_VENTA,
      CANTIDAD,
      PRECIO_VENTA,
      FRECUENCIA_PRODUCTO,
      MESES_RESTANTES,
      DESCRIPCION_PRESENTA_FACTURA,
      PRECIO_FORMULA,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION,
      PUNTO_FACTURACION_ID,
      TIPO_ORDEN,
      USR_VENDEDOR
    )
    VALUES
    (
      Ln_IdServicioNuevo,
      Pr_InfoServicioInternet.ID_PUNTO,
      Pr_InfoServicioProdAdicional.ID_PRODUCTO,
      Ln_IdOrdenTrabajoServicio,
      Pr_InfoServicioProdAdicional.ES_VENTA_SERVICIO,
      Pr_InfoServicioProdAdicional.CANTIDAD_SERVICIO,
      Pr_InfoServicioProdAdicional.PRECIO_VENTA_SERVICIO,
      Pr_InfoServicioProdAdicional.FRECUENCIA_SERVICIO,
      Pr_InfoServicioProdAdicional.MESES_RESTANTES_SERVICIO,
      Pr_InfoServicioProdAdicional.DESCRIPCION_PRODUCTO,
      Pr_InfoServicioProdAdicional.PRECIO_VENTA_SERVICIO,
      Pr_InfoServicioProdAdicional.ESTADO_SERVICIO,
      SYSDATE,
      Lv_UsrCreacion,
      Lv_IpCreacion,
      Pr_InfoServicioInternet.PUNTO_FACTURACION_ID,
      'N',
      Lv_UsrVendedor
    );
    
    Lr_ServicioHistorial              := NULL;
    Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioNuevo;
    Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
    Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
    Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioProdAdicional.ESTADO_SERVICIO;
    Lr_ServicioHistorial.OBSERVACION  := Pr_InfoServicioProdAdicional.OBSERVACION_HISTORIAL;
    Lr_ServicioHistorial.ACCION       := Pr_InfoServicioProdAdicional.ACCION_HISTORIAL;
    DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Pv_Status               := 'OK';
    Pv_MsjError             := '';
    Pn_IdServicioNuevo      := Ln_IdServicioNuevo; 
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_MsjError         := Lv_MsjError;
    Pn_IdServicioNuevo  := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'INKG_TRANSACCIONES_MASIVAS.P_CREA_LOG_SERV_ADIC',
                                            Lv_MsjError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Pv_MsjError         := 'No se ha podido crear correctamente el servicio adicional';
    Pn_IdServicioNuevo  := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'INKG_TRANSACCIONES_MASIVAS.P_CREA_LOG_SERV_ADIC',
                                            'Error al crear servicio adicional ' || SQLCODE || ' - ERROR_STACK: ' || 
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CREA_LOG_SERV_ADIC;

  PROCEDURE P_CANCEL_LOG_SERVS_ADIC(
    Pn_IdPunto                  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pv_NombreTecnicoProducto    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Pn_IdServicioUnicoACancelar IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdServicioANoCancelar    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pv_EstadoServicio           IN VARCHAR2,
    Pv_ProcesoEjecutante        IN VARCHAR2,
    Pv_ObsProcesoEjecutante     IN VARCHAR2,
    Pv_UsrCreacion              IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2
  )
  AS
    Lv_NombreParam              VARCHAR2(38) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_Valor1EstadosServicios   VARCHAR2(50) := 'ESTADOS_SERVICIOS_PROD_ADICIONALES_A_CONSIDERAR';
    Lv_Valor2TipoBusqServicios  VARCHAR2(30) := 'BUSQUEDA_POR_NOMBRE_TECNICO';
    Lv_ProcesoEjecutante        VARCHAR2(100);
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lrf_ServiciosAdicionales    SYS_REFCURSOR;
    Ln_IdServicioAdicional      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lv_MsjError                 VARCHAR2(4000);
    Lv_UsrCreacion              VARCHAR2(15);
    Lv_IpCreacion               VARCHAR2(15) := '127.0.0.1';
    Lv_ContinuaProceso          VARCHAR2(2) := 'NO';
    Lr_ServicioHistorial        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_InfoDetalleSolHistorial  DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Le_Exception                EXCEPTION;
    Lcl_Query                   CLOB;
    TYPE Lt_Servicios           IS TABLE OF DB_COMERCIAL.INFO_SERVICIO%ROWTYPE;
    Lt_ServiciosAdicionales     Lt_Servicios;
    Lr_RegServicioAdicional     DB_COMERCIAL.INFO_SERVICIO%ROWTYPE;
    Ln_IndxServicioAdicional    NUMBER;
    CURSOR Lc_GetSolicitudesServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT SOLICITUD.ID_DETALLE_SOLICITUD, SOLICITUD.ESTADO
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
      WHERE SOLICITUD.SERVICIO_ID = Cn_IdServicio;
  BEGIN
    IF Pn_IdPunto IS NULL OR Pv_NombreTecnicoProducto IS NULL THEN
      Lv_MsjError := 'No se han enviado todos los par�metros obligatorios';
      RAISE Le_Exception;
    END IF;
  
    IF Pv_UsrCreacion IS NOT NULL THEN
      Lv_UsrCreacion := Pv_UsrCreacion;
    ELSE
      Lv_UsrCreacion := 'cancelaServAdic';
    END IF;
    
    IF Pv_ProcesoEjecutante IS NOT NULL THEN
      Lv_ProcesoEjecutante := Pv_ProcesoEjecutante;
    ELSE
      Lv_ProcesoEjecutante := 'CAMBIO_PLAN_MASIVO';
    END IF;
    
    IF Pv_EstadoServicio IS NOT NULL THEN 
      Lcl_Query := 'SELECT SERVICIO.*
                    FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                    ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                    WHERE SERVICIO.PUNTO_ID = ' || Pn_IdPunto || '
                    AND PROD.NOMBRE_TECNICO = ''' || Pv_NombreTecnicoProducto || ''' 
                    AND SERVICIO.ESTADO = ''' || Pv_EstadoServicio || ''' ';        
    ELSE
      Lcl_Query := 'SELECT SERVICIO.*
                    FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                    ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                    WHERE SERVICIO.PUNTO_ID = ' || Pn_IdPunto || '
                    AND PROD.NOMBRE_TECNICO = ''' || Pv_NombreTecnicoProducto || ''' 
                    AND SERVICIO.ESTADO IN (
                                                      SELECT PARAM_DET.VALOR5
                                                      FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                      ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                      WHERE PARAM_CAB.NOMBRE_PARAMETRO = ''' || Lv_NombreParam || ''' 
                                                      AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || ''' 
                                                      AND PARAM_DET.VALOR1 = ''' || Lv_Valor1EstadosServicios || ''' 
                                                      AND PARAM_DET.VALOR2 = ''' || Lv_Valor2TipoBusqServicios || ''' 
                                                      AND PARAM_DET.VALOR3 = ''' || Lv_ProcesoEjecutante || ''' 
                                                      AND PARAM_DET.VALOR4 = PROD.NOMBRE_TECNICO
                                                      AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                                    )';                                      
    END IF;

    OPEN Lrf_ServiciosAdicionales FOR Lcl_Query;
    FETCH Lrf_ServiciosAdicionales BULK COLLECT INTO Lt_ServiciosAdicionales LIMIT 1000;
    Ln_IndxServicioAdicional := Lt_ServiciosAdicionales.FIRST;
    WHILE (Ln_IndxServicioAdicional IS NOT NULL)
    LOOP
      Lr_RegServicioAdicional := Lt_ServiciosAdicionales(Ln_IndxServicioAdicional);
      Ln_IdServicioAdicional := Lr_RegServicioAdicional.ID_SERVICIO;
      Lv_ContinuaProceso    := 'SI';
      IF ((Pn_IdServicioUnicoACancelar IS NOT NULL AND Pn_IdServicioUnicoACancelar <> Ln_IdServicioAdicional)
        OR (Pn_IdServicioANoCancelar IS NOT NULL AND Pn_IdServicioANoCancelar = Ln_IdServicioAdicional)) THEN 
        Lv_ContinuaProceso  := 'NO';
      END IF;

      IF Lv_ContinuaProceso = 'SI' THEN
        UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
        SET ESTADO = 'Eliminado',
        USR_ULT_MOD = Lv_UsrCreacion,
        FE_ULT_MOD = SYSDATE
        WHERE SERVICIO_ID = Ln_IdServicioAdicional
        AND ESTADO = Lv_EstadoActivo;

        UPDATE DB_COMERCIAL.INFO_SERVICIO
        SET    ESTADO = 'Cancel'
        WHERE  ID_SERVICIO = Ln_IdServicioAdicional;

        Lr_ServicioHistorial              := NULL;
        Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioAdicional;
        Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
        Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
        Lr_ServicioHistorial.ESTADO       := 'Cancel';
        Lr_ServicioHistorial.OBSERVACION  := 'Se cancela el servicio de manera l�gica' || Pv_ObsProcesoEjecutante;
        DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
        IF Lv_MsjError IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;

        IF Lc_GetSolicitudesServicio%ISOPEN THEN
          CLOSE Lc_GetSolicitudesServicio;
        END IF;
        FOR I_GetSolicitudesServicio IN Lc_GetSolicitudesServicio(Ln_IdServicioAdicional)
        LOOP
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
          SET ESTADO = 'Eliminada'
          WHERE ID_DETALLE_SOLICITUD = I_GetSolicitudesServicio.ID_DETALLE_SOLICITUD;

          Lr_InfoDetalleSolHistorial                        := NULL;
          Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
          Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := I_GetSolicitudesServicio.ID_DETALLE_SOLICITUD;
          Lr_InfoDetalleSolHistorial.ESTADO                 := 'Eliminada';
          Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se da de baja la solicitud en estado ' || I_GetSolicitudesServicio.ESTADO
                                                                || ' por cancelaci�n del servicio asociado ';
          Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrCreacion;
          Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
          Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
          DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;

          UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
          SET ESTADO = 'Eliminado',
          USR_ULT_MOD = Lv_UsrCreacion,
          FE_ULT_MOD = SYSDATE
          WHERE DETALLE_SOLICITUD_ID = I_GetSolicitudesServicio.ID_DETALLE_SOLICITUD;
        END LOOP;
      END IF;
      Ln_IndxServicioAdicional := Lt_ServiciosAdicionales.NEXT(Ln_IndxServicioAdicional);
    END LOOP;
      
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC', 
                                            'No se ha podido cancelar los servicios adicionales - ' || Lv_MsjError, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error inesperado por lo que no se ha podido cancelar los servicios adicionales';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC', 
                                            'Ha ocurrido un error inesperado por lo que no se ha podido cancelar los servicios adicionales - ' 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CANCEL_LOG_SERVS_ADIC;

  PROCEDURE P_EJECUTA_CPM_FLUJO_PRODS_TV(
    Pr_InfoServicioInternet IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet,
    Pn_IdPlanAnterior       IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pn_IdPlanNuevo          IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_ProcesoEjecutante    IN VARCHAR2,
    Pv_ObsProcesoEjecutante IN VARCHAR2,
    Pv_UsrCreacion          IN VARCHAR2,
    Pv_IpCreacion           IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2)
  IS
    Ln_IdServicioInternet           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Ln_IdPunto                      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Lv_Login                        DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Ln_IdPersona                    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE;
    Lv_NombreCliente                VARCHAR2(250);
    Lr_GetPlantillaError            DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lcl_PlantillaError              CLOB;
    Lv_Valor1ProdsFlujoGrupo        VARCHAR2(30) := 'PRODUCTOS_POR_FLUJO_DE_GRUPO';
    Lv_Valor2TipoFlujoProd          VARCHAR2(27) := 'FLUJO_GRUPO_TV';
    Lv_Valor3TipoBusquedaProd       VARCHAR2(24) := 'PRODS_POR_NOMBRE_TECNICO';
    Lv_ProcesoEjecutante            VARCHAR2(100);
    Lv_ObsProcesoEjecutante         VARCHAR2(500) := '';
    TYPE Lt_ParametrosDet           IS TABLE OF DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_ParametroDetalleBusqueda     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_RespuestaFlujoBusqueda       DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_RespuestaFlujoBusqueda      SYS_REFCURSOR;
    Ln_IndxParametrosDetFlujoBusq   NUMBER;
    Lt_ParametrosDetFlujoBusq       Lt_ParametrosDet;
    Lr_RespuestaKeyEncriptBusq      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_RespuestaKeyEncriptBusq     SYS_REFCURSOR;
    Ln_IndxParametrosDetKeyEncript  NUMBER;
    Lt_ParametrosDetKeyEncript      Lt_ParametrosDet;
    Lv_NombreTecnicoProd            DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE;
    Lv_SufijoCaractsProd            VARCHAR2(100);
    Lv_NombreProductoComercial      VARCHAR2(2000);
    Ln_IdItemProdPlanAnterior       DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;
    Ln_IdItemProdPlanNuevo          DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;
    Lv_UsrCreacion                  VARCHAR2(15);
    Lv_IpCreacion                   VARCHAR2(15);
    Lv_AsuntoCorreo                 VARCHAR2(300);
    Lv_CodigoPlantillaCorreo        VARCHAR2(15);
    Lv_CodigoPlantillaSms           VARCHAR2(15);
    Lv_PermiteNotifSms              VARCHAR2(2);
    Lv_CorreosDestinatarios         VARCHAR2(4000);
    Lv_CorreosDestinatariosRegu     VARCHAR2(4000);
    Lv_AgregaFormasContactoPunto    VARCHAR2(2) := 'NO';
    Lv_NotificaCredenciales         VARCHAR2(2) := 'NO';
    Lcl_PlantillaCorreo             CLOB;
    Lcl_PlantillaSms                CLOB;
    Lcl_DestinatariosFinales        CLOB;
    Lv_Remitente                    VARCHAR2(300) := 'notificacionesnetlife@netlife.info.ec';
    Ln_IdServNotifCredenciales      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lv_NotificaCredencialesRegu     VARCHAR2(2) := 'NO';
    Ln_IdServNotifCredencialesRegu  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lr_RegistroSpcSsid              DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lr_RegistroSpcUsuario           DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lr_RegistroSpcPassword          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lr_RegistroSpcMigrado           DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lr_RegistroSpcElimUsuario       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lr_RegistroSpcElimSsid          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lr_RegistroSpcElimMigrado       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Ln_IdPrimerServAdicCancel       DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Ln_IdServicioAdicional          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Ln_IdServicioAdicNuevo          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Ln_IdProdServicioAdic           DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
    Lr_ServicioProdAdicional        DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioProdAdicional;
    Lr_ConfigWsClearCache           DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService;
    Lv_NombreParamsServiciosMd      VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_NombreParamPrecioProds       VARCHAR2(17) := 'PRECIOS_PRODUCTOS';
    Lv_ParamEnvioSmsPorProducto     VARCHAR2(23) := 'ENVIO_SMS_POR_PRODUCTO';
    Lv_ParamNombreTecnicoEnvioSms   VARCHAR2(15) := 'NOMBRE_TECNICO';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_EstadoCancel                 VARCHAR2(6) := 'Cancel';
    Lv_EstadoEliminado              VARCHAR2(9) := 'Eliminado';
    Lv_EstadoCancelado              VARCHAR2(9) := 'Cancelado';
    Lv_ValorNuevoSpcUsuario         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcPassword        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcPasswordTmp     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcSsid            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcMigrado         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcPassNotif       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcReguUsuario     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcReguPassword    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcReguPassTmp     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcReguPassNotif   DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_ValorNuevoSpcReguSsid        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lr_ServicioHistorial            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_KeyEncript                   VARCHAR2(300);
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Lv_MsjHistoError                VARCHAR2(4000);
    Lv_CreaHistoError               VARCHAR2(2);
    Le_ExceptionPrincipal           EXCEPTION;
    Le_Exception                    EXCEPTION;
    
    CURSOR Lc_GetProdEnPlanDet(Cn_IdItem DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE)
    IS
      SELECT PROD.ID_PRODUCTO, PROD.NOMBRE_TECNICO AS NOMBRE_TECNICO_PRODUCTO, PROD.DESCRIPCION_PRODUCTO, 
      COALESCE(TO_NUMBER( REPLACE(PARAM_PRECIOS_PROD.VALOR3,',', '.'), '9999999.9999'),0) AS PRECIO_VENTA_SERVICIO
      FROM DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
      ON PROD.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
      INNER JOIN 
      (
        SELECT PARAM_DET.*
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
        WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_NombreParamsServiciosMd
        AND PARAM_DET.VALOR1 = Lv_NombreParamPrecioProds
        AND PARAM_CAB.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.ESTADO = Lv_EstadoActivo
      ) PARAM_PRECIOS_PROD
      ON COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAM_PRECIOS_PROD.VALOR2,'^\d+')),0) = PROD.ID_PRODUCTO
      WHERE PLAN_DET.ID_ITEM = Cn_IdItem;
      Lr_GetProdEnPlanDetAnterior Lc_GetProdEnPlanDet%ROWTYPE;
      Lr_GetProdEnPlanDetNuevo    Lc_GetProdEnPlanDet%ROWTYPE;

    CURSOR Lc_GetIdPrimerServAdicCancel(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                                        Cv_NombreTecnicoProd DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                        Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                        Cv_ValorSpc DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE)
    IS
      SELECT MIN(SERVICIO.ID_SERVICIO) AS ID_SERVICIO_CANCEL
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
      ON PRODUCTO.ID_PRODUCTO =  SERVICIO.PRODUCTO_ID
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC
      ON SPC.SERVICIO_ID = SERVICIO.ID_SERVICIO
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
      ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
      WHERE SERVICIO.PUNTO_ID = Cn_IdPunto
      AND PRODUCTO.NOMBRE_TECNICO = Cv_NombreTecnicoProd
      AND CARACT.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
      AND SERVICIO.ESTADO = Lv_EstadoCancel
      AND SPC.VALOR = Cv_ValorSpc
      AND SPC.ESTADO IN (Lv_EstadoEliminado, Lv_EstadoCancelado);
      
    CURSOR Lc_SpcPorCaractyProd(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, 
                                Cv_NombreTecnicoProd DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_EstadoSpc DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE)
    IS
      SELECT SPC.*
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
      ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
      ON PRODUCTO.ID_PRODUCTO = APC.PRODUCTO_ID
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
      WHERE SPC.SERVICIO_ID = Cn_IdServicio
      AND PRODUCTO.NOMBRE_TECNICO = Cv_NombreTecnicoProd
      AND CARACT.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
      AND SPC.ESTADO = Cv_EstadoSpc;
      
    CURSOR Lc_GetFormasContacto(Cn_IdPunto                  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Cv_DescripcionFormaContacto DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
                                Cn_IdPersona                DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE)
    IS                            
      SELECT DISTINCT IPFC.VALOR
      FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
      INNER JOIN DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO IPFC
      ON IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
      WHERE AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_DescripcionFormaContacto
          AND AFC.ESTADO = Lv_EstadoActivo
          AND IPFC.PUNTO_ID = Cn_IdPunto
          AND IPFC.ESTADO = Lv_EstadoActivo
      UNION
      SELECT DISTINCT IPFC.VALOR
      FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC
      ON IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
      WHERE AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_DescripcionFormaContacto
      AND AFC.ESTADO = Lv_EstadoActivo
      AND IPFC.PERSONA_ID = Cn_IdPersona
      AND IPFC.ESTADO = Lv_EstadoActivo;
      
    CURSOR Lc_GetIdProdServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS                            
      SELECT PROD.ID_PRODUCTO
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
      ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
      WHERE SERVICIO.ID_SERVICIO = Cn_IdServicio;
      
    CURSOR Lc_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
    IS
      SELECT
        AP.PLANTILLA
      FROM
        DB_COMUNICACION.ADMI_PLANTILLA AP 
      WHERE
        AP.CODIGO = Cv_CodigoPlantilla
      AND AP.ESTADO <> Lv_EstadoEliminado;

    CURSOR Lc_GetPermiteNotifSms(Cv_NombreTecnico DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
    IS
      SELECT PARAM_DET_ENVIO_SMS_POR_PROD.VALOR3 AS PERMITE_ENVIO_SMS 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ENVIO_SMS_POR_PROD
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ENVIO_SMS_POR_PROD
      ON PARAM_DET_ENVIO_SMS_POR_PROD.PARAMETRO_ID = PARAM_CAB_ENVIO_SMS_POR_PROD.ID_PARAMETRO
      WHERE PARAM_CAB_ENVIO_SMS_POR_PROD.NOMBRE_PARAMETRO = Lv_ParamEnvioSmsPorProducto
      AND PARAM_CAB_ENVIO_SMS_POR_PROD.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ENVIO_SMS_POR_PROD.VALOR1 = Lv_ParamNombreTecnicoEnvioSms
      AND PARAM_DET_ENVIO_SMS_POR_PROD.VALOR2 = Cv_NombreTecnico
      AND PARAM_DET_ENVIO_SMS_POR_PROD.ESTADO = Lv_EstadoActivo;

  BEGIN
    IF Pv_UsrCreacion IS NOT NULL THEN
      Lv_UsrCreacion := Pv_UsrCreacion;
    ELSE
      Lv_UsrCreacion := 'eliminaSpcTv';
    END IF;
    
    IF Pv_IpCreacion IS NOT NULL THEN
      Lv_IpCreacion := Pv_IpCreacion;
    ELSE
      Lv_IpCreacion  := '127.0.0.1';
    END IF;
    
    IF Pv_ProcesoEjecutante IS NOT NULL THEN
      Lv_ProcesoEjecutante := Pv_ProcesoEjecutante;
    ELSE
      Lv_ProcesoEjecutante := 'CAMBIO_PLAN_MASIVO';
    END IF;
    
    IF Pv_ObsProcesoEjecutante IS NOT NULL THEN
      Lv_ObsProcesoEjecutante := Pv_ObsProcesoEjecutante;
    ELSE
      Lv_ObsProcesoEjecutante := ' por cambio de plan masivo';
    END IF;
    
    Ln_IdServicioInternet := Pr_InfoServicioInternet.ID_SERVICIO;
    Ln_IdPunto            := Pr_InfoServicioInternet.ID_PUNTO;
    Lv_Login              := Pr_InfoServicioInternet.LOGIN;
    Ln_IdPersona          := Pr_InfoServicioInternet.ID_PERSONA;
    Lv_NombreCliente      := Pr_InfoServicioInternet.NOMBRE_CLIENTE;

    Lr_ParametroDetalleBusqueda         := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1  := 'KEY_SECRET_TELCOS';
    Lr_ParametroDetalleBusqueda.VALOR2  := NULL;
    Lr_ParametroDetalleBusqueda.VALOR3  := NULL;
    Lr_ParametroDetalleBusqueda.VALOR4  := NULL;
    Lr_ParametroDetalleBusqueda.VALOR5  := NULL;
    Lrf_RespuestaKeyEncriptBusq         := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    Lv_KeyEncript                       := '';
    FETCH Lrf_RespuestaKeyEncriptBusq BULK COLLECT INTO Lt_ParametrosDetKeyEncript LIMIT 1000;
    Ln_IndxParametrosDetKeyEncript := Lt_ParametrosDetKeyEncript.FIRST;
    WHILE (Ln_IndxParametrosDetKeyEncript IS NOT NULL)
    LOOP
      Lr_RespuestaKeyEncriptBusq      := Lt_ParametrosDetKeyEncript(Ln_IndxParametrosDetKeyEncript);
      Lv_KeyEncript                   := Lr_RespuestaKeyEncriptBusq.VALOR2;
      Ln_IndxParametrosDetKeyEncript  := Lt_ParametrosDetKeyEncript.NEXT(Ln_IndxParametrosDetKeyEncript);
    END LOOP;
    IF Lv_KeyEncript IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la Key para encriptar y desencriptar las claves';
      RAISE Le_Exception;
    END IF;
    
    Lr_RespuestaFlujoBusqueda           := NULL;
    Lr_ParametroDetalleBusqueda         := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1  := Lv_Valor1ProdsFlujoGrupo;
    Lr_ParametroDetalleBusqueda.VALOR2  := Lv_Valor2TipoFlujoProd;
    Lr_ParametroDetalleBusqueda.VALOR3  := Lv_Valor3TipoBusquedaProd;
    Lr_ParametroDetalleBusqueda.VALOR4  := NULL;
    Lr_ParametroDetalleBusqueda.VALOR5  := NULL;
    Lrf_RespuestaFlujoBusqueda          := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    
    FETCH Lrf_RespuestaFlujoBusqueda BULK COLLECT INTO Lt_ParametrosDetFlujoBusq LIMIT 1000;
    Ln_IndxParametrosDetFlujoBusq := Lt_ParametrosDetFlujoBusq.FIRST;
    WHILE (Ln_IndxParametrosDetFlujoBusq IS NOT NULL)
    LOOP
      Lr_RespuestaFlujoBusqueda           := Lt_ParametrosDetFlujoBusq(Ln_IndxParametrosDetFlujoBusq);      
      Lv_AsuntoCorreo                     := Lr_RespuestaFlujoBusqueda.DESCRIPCION;
      Lv_NombreTecnicoProd                := Lr_RespuestaFlujoBusqueda.VALOR4;
      Lv_SufijoCaractsProd                := Lr_RespuestaFlujoBusqueda.VALOR5;
      Lv_CodigoPlantillaCorreo            := Lr_RespuestaFlujoBusqueda.VALOR6;
      Lv_CodigoPlantillaSms               := Lr_RespuestaFlujoBusqueda.VALOR7;
      Lv_NombreProductoComercial          := Lr_RespuestaFlujoBusqueda.OBSERVACION;
      Lv_CreaHistoError                   := 'NO';
      
      --Inicio de proceso por producto encontrado
      BEGIN
        Lv_Status                           := '';
        Lv_MsjError                         := '';
        Lv_MsjHistoError                    := '';
        Lv_ValorNuevoSpcUsuario             := '';
        Lv_ValorNuevoSpcPassword            := '';
        Lv_ValorNuevoSpcPasswordTmp         := '';
        Lv_ValorNuevoSpcPassNotif           := '';
        Lv_ValorNuevoSpcSsid                := '';
        Lv_ValorNuevoSpcMigrado             := '';
        
        Lv_ValorNuevoSpcReguUsuario         := '';
        Lv_ValorNuevoSpcReguPassword        := '';
        Lv_ValorNuevoSpcReguPassTmp         := '';
        Lv_ValorNuevoSpcReguPassNotif       := '';
        Lv_ValorNuevoSpcReguSsid            := '';
        
        Lr_GetProdEnPlanDetAnterior         := NULL;
        Lr_GetProdEnPlanDetNuevo            := NULL;
        Lr_RegistroSpcSsid                  := NULL;
        Lr_RegistroSpcUsuario               := NULL;
        Lr_RegistroSpcPassword              := NULL;
        Lr_RegistroSpcMigrado               := NULL;
        Lr_RegistroSpcElimUsuario           := NULL;
        Lr_RegistroSpcElimSsid              := NULL;
        Lr_RegistroSpcElimMigrado           := NULL;
        Ln_IdServicioAdicNuevo              := NULL;
        Lr_ServicioProdAdicional            := NULL;
        Lv_PermiteNotifSms                  := 'NO';
        
        Lv_AgregaFormasContactoPunto        := 'NO';
        Lv_NotificaCredenciales             := 'NO';
        Lcl_PlantillaCorreo                 := '';
        Lcl_PlantillaSms                    := '';
        Lcl_DestinatariosFinales            := '';
        Ln_IdServNotifCredenciales          := NULL;
        Lv_CorreosDestinatarios             := '';
        Lv_NotificaCredencialesRegu         := 'NO';
        Ln_IdServNotifCredencialesRegu      := NULL;
        Lv_CorreosDestinatariosRegu         := '';
        
        Ln_IdItemProdPlanAnterior           := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ITEM_PROD_EN_PLAN(Pn_IdPlanAnterior, Lv_NombreTecnicoProd, 
                                                                                                    NULL, NULL);
        Ln_IdItemProdPlanNuevo              := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ITEM_PROD_EN_PLAN(Pn_IdPlanNuevo, Lv_NombreTecnicoProd, 
                                                                                                    NULL, NULL);
        Ln_IdServicioAdicional              := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ULT_SERV_ADIC_X_PUNTO(Ln_IdPunto, Lv_NombreTecnicoProd, 
                                                                                                        NULL, Lv_ProcesoEjecutante);
        Lr_ServicioHistorial                := NULL;          
        
        --Inicio de escenarios para cambio de plan masivo con productos adicionales TV
        IF Ln_IdItemProdPlanAnterior IS NULL AND Ln_IdItemProdPlanNuevo IS NULL THEN
          ---------------------------------------------------
          --------------------ESCENARIO 1 Y 4----------------
          ---------------------------------------------------

          ---------Escenario 1---------
          IF Ln_IdServicioAdicional IS NULL THEN
            --Cancelar todo lo relacionado con el producto tanto para el servicio de Internet como para servicios adicionales.        
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC(Ln_IdPunto, Lv_NombreTecnicoProd, NULL, NULL, NULL,
                                                                                  Lv_ProcesoEjecutante, Lv_ObsProcesoEjecutante, 
                                                                                  Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
          END IF;
          -------Fin Escenario 1-------
          
          --Se eliminan todas las caracter�sticas relacionadas con el producto dentro del servicio de Internet
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 
                                                          'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, 
                                                                          NULL, 'S', Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END LOOP;
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, NULL, NULL,
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          
          ---------Escenario 4---------
          IF Ln_IdServicioAdicional IS NOT NULL THEN
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 
                                                            'SI', Lv_Status, Lv_MsjError, Lr_RegistroSpcUsuario);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 
                                                            'SI', Lv_Status, Lv_MsjError, Lr_RegistroSpcPassword);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcUsuario.VALOR IS NULL
            OR Lr_RegistroSpcPassword.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcPassword.VALOR IS NULL THEN
              --Se debe generar las credenciales por regularizaci�n y eliminar todas caracter�sticas asociadas al producto
              FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 
                                                              'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
              LOOP
                IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                  DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL,
                                                                              'S', Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                  IF Lv_Status = 'ERROR' THEN
                    RAISE Le_Exception;
                  END IF;
                END IF;
              END LOOP;
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, NULL, NULL,
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              Lv_ValorNuevoSpcReguUsuario   := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                                'INFO_SERVICIO_PROD_CARACT',
                                                                                                'FP',
                                                                                                'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                                Lv_NombreTecnicoProd);
              Lv_ValorNuevoSpcReguPassTmp   := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                               || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
              DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcReguPassTmp,
                                                          Lv_KeyEncript,
                                                          Lv_ValorNuevoSpcReguPassword);
              
              Lv_ValorNuevoSpcReguSsid      := TO_CHAR(Ln_IdServicioAdicional);
              
              IF Lv_ValorNuevoSpcReguUsuario IS NULL THEN
                Lv_MsjError := 'No se ha podido crear el usuario';
                RAISE Le_Exception;
              END IF;
              
              IF Lv_ValorNuevoSpcReguPassword IS NULL THEN
                Lv_MsjError := 'No se ha podido crear la password';
                RAISE Le_Exception;
              END IF;
              
              IF Lv_ValorNuevoSpcReguSsid IS NULL THEN
                Lv_MsjError := 'No se ha podido crear el ssid';
                RAISE Le_Exception;
              END IF;
              
              OPEN Lc_GetIdProdServicio(Ln_IdServicioAdicional);
              FETCH Lc_GetIdProdServicio INTO Ln_IdProdServicioAdic;
              CLOSE Lc_GetIdProdServicio;
     
              --Se crean las nuevas caracter�sticas asociadas al servicio adicional por regularizaci�n
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'USUARIO_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguUsuario,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'PASSWORD_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguPassword,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'SSID_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguSsid,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'MIGRADO_' || Lv_SufijoCaractsProd,
                                                                          'N',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'TIENE INTERNET',
                                                                          'SI',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          Lv_SufijoCaractsProd,
                                                                          'S',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              Lv_NotificaCredencialesRegu     := 'SI';
              Ln_IdServNotifCredencialesRegu  := Ln_IdServicioAdicional;
            END IF;
          END IF;
          -------Fin Escenario 4-------

          ---------------------------------------------------
          ---------------FIN ESCENARIO 1 Y 4-----------------
          ---------------------------------------------------
        
        ELSIF Ln_IdItemProdPlanAnterior IS NOT NULL AND Ln_IdItemProdPlanNuevo IS NULL THEN
          ---------------------------------------------------
          --------------------ESCENARIO 2 Y 7----------------
          ---------------------------------------------------
          
          ---------Escenario 2---------
          IF Ln_IdServicioAdicional IS NULL THEN
            --Cancelar todo lo relacionado a servicios adicionales asociados al producto.
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC(Ln_IdPunto, Lv_NombreTecnicoProd, NULL, NULL, NULL, 
                                                                                  Lv_ProcesoEjecutante, Lv_ObsProcesoEjecutante, 
                                                                                  Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
          END IF;
          -------Fin Escenario 2-------
          
          --Se obtiene los registros de las caracter�sticas del servicio de Internet con el plan que si ten�a asociado el producto
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioInternet, 'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI', 
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcUsuario);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioInternet, 'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI', 
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcPassword);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioInternet, 'SSID_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI', 
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcSsid);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          OPEN Lc_GetProdEnPlanDet(Ln_IdItemProdPlanAnterior);
          FETCH Lc_GetProdEnPlanDet INTO Lr_GetProdEnPlanDetAnterior;
          IF(Lc_GetProdEnPlanDet%NOTFOUND) THEN
            Lv_MsjError := 'No se ha podido obtener el producto para creaci�n del servicio adicional';
            RAISE Le_Exception;    
          END IF;
          CLOSE Lc_GetProdEnPlanDet;
          
          --Se crea servicio adicional nuevo
          Lr_ServicioProdAdicional                          := NULL;
          Lr_ServicioProdAdicional.ID_PRODUCTO              := Lr_GetProdEnPlanDetAnterior.ID_PRODUCTO;
          Lr_ServicioProdAdicional.NOMBRE_TECNICO_PRODUCTO  := Lr_GetProdEnPlanDetAnterior.NOMBRE_TECNICO_PRODUCTO;
          Lr_ServicioProdAdicional.DESCRIPCION_PRODUCTO     := Lr_GetProdEnPlanDetAnterior.DESCRIPCION_PRODUCTO;
          Lr_ServicioProdAdicional.PRECIO_VENTA_SERVICIO    := Lr_GetProdEnPlanDetAnterior.PRECIO_VENTA_SERVICIO;
          Lr_ServicioProdAdicional.ESTADO_SERVICIO          := Pr_InfoServicioInternet.ESTADO;
          Lr_ServicioProdAdicional.OBSERVACION_HISTORIAL    := 'El Producto <b>' || Lr_GetProdEnPlanDetAnterior.DESCRIPCION_PRODUCTO ||
                                                                '</b> dentro del Plan pas� como un Producto Adicional';
          Lr_ServicioProdAdicional.ACCION_HISTORIAL         := 'confirmarServicio';
          Lr_ServicioProdAdicional.ES_VENTA_SERVICIO        := 'S';
          Lr_ServicioProdAdicional.CANTIDAD_SERVICIO        := 1;
          Lr_ServicioProdAdicional.FRECUENCIA_SERVICIO      := 1;
          Lr_ServicioProdAdicional.MESES_RESTANTES_SERVICIO := 1;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_CREA_LOG_SERV_ADIC(Pr_InfoServicioInternet, Lr_ServicioProdAdicional, 
                                                                             Lv_UsrCreacion, Lv_IpCreacion, Lv_Status, Lv_MsjError, 
                                                                             Ln_IdServicioAdicNuevo);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcUsuario.VALOR IS NOT NULL
          AND Lr_RegistroSpcPassword.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcPassword.VALOR IS NOT NULL THEN
            --Se considera que el servicio de Internet con el plan anterior si posee la informaci�n de ingreso al portal USUARIO_[PRODUCTO] 
            --y PASSWORD_[PRODUCTO]
            Lv_ValorNuevoSpcUsuario   := Lr_RegistroSpcUsuario.VALOR;
            Lv_ValorNuevoSpcPassword  := Lr_RegistroSpcPassword.VALOR;
            
            IF Lr_RegistroSpcSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL THEN
              Lv_ValorNuevoSpcSsid := Lr_RegistroSpcSsid.VALOR;
            ELSE
              Lv_ValorNuevoSpcSsid := TO_CHAR(Ln_IdServicioInternet);
            END IF;

            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se traspasa la informaci�n de usuario y contrase�a al nuevo servicio adicional ' || 
                                                 Lv_NombreProductoComercial || ' por ejecuci�n de cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioAdicNuevo;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se guarda la informaci�n de usuario y contrase�a obtenida del producto ' ||
                                                 Lv_NombreProductoComercial || ' incluido en el plan anterior del servicio de Internet' ||
                                                 ' por ejecuci�n de cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;

          ELSE
            --El servicio de Internet con el plan anterior no posee la informaci�n correcta de USUARIO_[PRODUCTO] y/o PASSWORD_[PRODUCTO]
            IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcUsuario.VALOR IS NOT NULL
            AND Lr_RegistroSpcSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcSsid.VALOR IS NOT NULL THEN
              ----El servicio de Internet con el plan anterior posee la informaci�n correcta de USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
              Lv_ValorNuevoSpcUsuario := Lr_RegistroSpcUsuario.VALOR;
              Lv_ValorNuevoSpcSsid    := Lr_RegistroSpcSsid.VALOR;
            ELSE
              --Se busca al primer servicio cancelado de este tipo de producto que pueda ser tomado como migrado
              OPEN Lc_GetIdPrimerServAdicCancel(Ln_IdPunto, 
                                                Lv_NombreTecnicoProd, 
                                                'MIGRADO_'  || Lv_SufijoCaractsProd, 
                                                'N');
              FETCH Lc_GetIdPrimerServAdicCancel INTO Ln_IdPrimerServAdicCancel;
              CLOSE Lc_GetIdPrimerServAdicCancel;
              
              IF Ln_IdPrimerServAdicCancel IS NOT NULL THEN
                --Existe un servicio adicional que fue cancelado anteriormente, por lo que se consultar� la infomaci�n del Usuario 
                --y Ssid de este servicio
                DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdPrimerServAdicCancel, 'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                'Eliminado', 'SI', Lv_Status, Lv_MsjError, Lr_RegistroSpcElimUsuario);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Exception;
                END IF;
                
                DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdPrimerServAdicCancel, 'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                'Eliminado', 'SI', Lv_Status, Lv_MsjError, Lr_RegistroSpcElimSsid);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Exception;
                END IF;
                
                IF Lr_RegistroSpcElimUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcElimUsuario.VALOR IS NOT NULL
                AND Lr_RegistroSpcElimSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcElimSsid.VALOR IS NOT NULL THEN
                  --El servicio adicional Cancelado si tiene asociadas las caracter�sticas USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
                  Lv_ValorNuevoSpcUsuario           := Lr_RegistroSpcElimUsuario.VALOR;
                  Lv_ValorNuevoSpcSsid              := Lr_RegistroSpcElimSsid.VALOR;

                  Lr_ServicioHistorial              := NULL;
                  Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioAdicNuevo;
                  Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
                  Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
                  Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
                  Lr_ServicioHistorial.OBSERVACION  := 'Recontrataci�n: El Cliente ya posee un Servicio ' 
                                                       || Lr_GetProdEnPlanDetAnterior.DESCRIPCION_PRODUCTO
                                                       || ' Cancelado, se procede a Activar el Servicio con la informaci�n del <b>LOGIN</b>'
                                                       || ' y <b>SUSCRIBER_ID existente.';
                  Lr_ServicioHistorial.ACCION       := NULL;
                  DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
                  IF Lv_MsjError IS NOT NULL THEN
                    RAISE Le_Exception;
                  END IF;
                  
                  Lr_ConfigWsClearCache := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_GET_WS_CLEAR_CACHE;
                  DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX(Lv_ValorNuevoSpcSsid,
                                                                      Ln_IdServicioAdicNuevo,
                                                                      Pr_InfoServicioInternet.ESTADO,
                                                                      'S',
                                                                      Lr_ConfigWsClearCache,
                                                                      Lv_UsrCreacion,
                                                                      Lv_IpCreacion,
                                                                      Lv_MsjError);
                                                                      
                ELSE
                  --El servicio adicional Cancelado no tiene asociadas las caracter�sticas USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
                  Lv_ValorNuevoSpcUsuario := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                              'INFO_SERVICIO_PROD_CARACT',
                                                                                              'FP',
                                                                                              'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                              Lv_NombreTecnicoProd);
                  Lv_ValorNuevoSpcSsid    := TO_CHAR(Ln_IdServicioAdicNuevo);
                END IF;
                
                FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdPrimerServAdicCancel, Lv_NombreTecnicoProd, 
                                                                'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoEliminado)
                LOOP
                  IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                    DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, 
                                                                                NULL, 'S', Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                    IF Lv_Status = 'ERROR' THEN
                      RAISE Le_Exception;
                    END IF;
                  END IF;
                END LOOP;
                
              ELSE
                --No existe un servicio adicional cancelado anteriormente
                Lv_ValorNuevoSpcUsuario := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                            'INFO_SERVICIO_PROD_CARACT',
                                                                                            'FP',
                                                                                            'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                            Lv_NombreTecnicoProd);
                Lv_ValorNuevoSpcSsid    := TO_CHAR(Ln_IdServicioAdicNuevo);
              END IF;
            END IF;
            Lv_NotificaCredenciales       := 'SI';
            Ln_IdServNotifCredenciales    := Ln_IdServicioAdicNuevo;
            Lv_ValorNuevoSpcPasswordTmp   := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                             || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
            DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcPasswordTmp,
                                                        Lv_KeyEncript,
                                                        Lv_ValorNuevoSpcPassword);

            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se traspasa la informaci�n de usuario y contrase�a al nuevo servicio adicional ' || 
                                                 Lv_NombreProductoComercial || ' por ejecuci�n de cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioAdicNuevo;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se guarda la informaci�n regularizada de usuario y contrase�a obtenida del producto ' ||
                                                 Lv_NombreProductoComercial || ' incluido en el plan anterior del servicio de Internet' ||
                                                 ' por ejecuci�n de cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;

          END IF;
          
          IF Lv_ValorNuevoSpcUsuario IS NULL THEN
            Lv_MsjError := 'No se ha podido obtener el usuario';
            RAISE Le_Exception;
          END IF;
          
          IF Lv_ValorNuevoSpcPassword IS NULL THEN
            Lv_MsjError := 'No se ha podido obtener la password';
            RAISE Le_Exception;
          END IF;
          
          IF Lv_ValorNuevoSpcSsid IS NULL THEN
            Lv_MsjError := 'No se ha podido obtener el ssid';
            RAISE Le_Exception;
          END IF;
          
          ----Se eliminan todas las caracter�sticas asociadas al servicio de Internet del plan anterior.
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          --Si existe el registro para MIGRADO_[PRODUCTO], se lo elimina con valor S para que no lo tome ning�n otro servicio
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 
                                                          'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL, 'S', 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END LOOP;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'TIENE INTERNET', NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          --Se crean las nuevas caracter�sticas asociadas al servicio adicional nuevo.
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                      Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcUsuario,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                      Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'PASSWORD_'  || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcPassword,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                      Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'SSID_'  || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcSsid,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                      Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'MIGRADO_'  || Lv_SufijoCaractsProd,
                                                                      'N',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                      Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'TIENE INTERNET',
                                                                      'SI',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                      Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      Lv_SufijoCaractsProd,
                                                                      'S',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 'CORREO ELECTRONICO', Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR IS NOT NULL THEN
              Lv_CorreosDestinatarios := Lv_CorreosDestinatarios || I_SpcPorCaractyProd.VALOR || ',';
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicNuevo,
                                                                          Lr_ServicioProdAdicional.ID_PRODUCTO,
                                                                          Lv_EstadoActivo,
                                                                          'CORREO ELECTRONICO',
                                                                          I_SpcPorCaractyProd.VALOR,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL, NULL,
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
            END IF;
          END LOOP;
          
          ---------Escenario 7---------
          IF Ln_IdServicioAdicional IS NOT NULL THEN
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'USUARIO_'  || Lv_SufijoCaractsProd, 
                                                            NULL, 'Activo', 'SI',
                                                            Lv_Status, Lv_MsjError, Lr_RegistroSpcUsuario);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'PASSWORD_'  || Lv_SufijoCaractsProd, 
                                                            NULL, 'Activo', 'SI', 
                                                            Lv_Status, Lv_MsjError, Lr_RegistroSpcPassword);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcUsuario.VALOR IS NULL
            OR Lr_RegistroSpcPassword.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcPassword.VALOR IS NULL THEN
 
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            
              --Se debe generar las credenciales por regularizaci�n y eliminar todas caracter�sticas asociadas al producto
              FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 
                                                              'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
              LOOP
                IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                  DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, 
                                                                              NULL, NULL, 'S', 
                                                                              Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                  IF Lv_Status = 'ERROR' THEN
                    RAISE Le_Exception;
                  END IF;
                END IF;
              END LOOP;
              
              --Se obtienen los correos guardados pero no se los elimina porque estos han sido guardados por el usuario
              FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 'CORREO ELECTRONICO', Lv_EstadoActivo)
              LOOP
                IF I_SpcPorCaractyProd.VALOR IS NOT NULL THEN
                  Lv_CorreosDestinatariosRegu := Lv_CorreosDestinatariosRegu ||  I_SpcPorCaractyProd.VALOR || ',';
                END IF;
              END LOOP;
              
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'TIENE INTERNET', NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              Lv_ValorNuevoSpcReguUsuario   := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                                'INFO_SERVICIO_PROD_CARACT',
                                                                                                'FP',
                                                                                                'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                                Lv_NombreTecnicoProd);
              Lv_ValorNuevoSpcReguPassTmp   := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                               || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
              DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcReguPassTmp,
                                                          Lv_KeyEncript,
                                                          Lv_ValorNuevoSpcReguPassword);
              Lv_ValorNuevoSpcReguSsid      := TO_CHAR(Ln_IdServicioAdicional);
              
              IF Lv_ValorNuevoSpcReguUsuario IS NULL THEN
                Lv_MsjError := 'No se ha podido crear el usuario';
                RAISE Le_Exception;
              END IF;
              
              IF Lv_ValorNuevoSpcReguPassword IS NULL THEN
                Lv_MsjError := 'No se ha podido crear la password';
                RAISE Le_Exception;
              END IF;
              
              IF Lv_ValorNuevoSpcReguSsid IS NULL THEN
                Lv_MsjError := 'No se ha podido crear el ssid';
                RAISE Le_Exception;
              END IF;
              
              OPEN Lc_GetIdProdServicio(Ln_IdServicioAdicional);
              FETCH Lc_GetIdProdServicio INTO Ln_IdProdServicioAdic;
              CLOSE Lc_GetIdProdServicio;
     
              --Se crean las nuevas caracter�sticas asociadas al servicio adicional por regularizaci�n
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'USUARIO_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguUsuario,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'PASSWORD_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguPassword,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'SSID_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguSsid,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'MIGRADO_' || Lv_SufijoCaractsProd,
                                                                          'N',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'TIENE INTERNET',
                                                                          'SI',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          Lv_SufijoCaractsProd,
                                                                          'S',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              Lv_NotificaCredencialesRegu     := 'SI';
              Ln_IdServNotifCredencialesRegu  := Ln_IdServicioAdicional;
              
            END IF;
          END IF;
          -------Fin Escenario 7-------
          
          ---------------------------------------------------
          ---------------FIN ESCENARIO 2 Y 7-----------------
          ---------------------------------------------------
        
        ELSIF Ln_IdItemProdPlanAnterior IS NULL AND Ln_IdItemProdPlanNuevo IS NOT NULL AND Ln_IdServicioAdicional IS NULL THEN
          -----------------------------------------------
          --------------------ESCENARIO 3----------------
          -----------------------------------------------
          --Cancelar todo lo relacionado con el producto para servicios adicionales.        
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC(Ln_IdPunto, Lv_NombreTecnicoProd, NULL, NULL, NULL, 
                                                                                Lv_ProcesoEjecutante, Lv_ObsProcesoEjecutante, 
                                                                                Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          --Se obtiene el producto incluido dentro del plan nuevo
          OPEN Lc_GetProdEnPlanDet(Ln_IdItemProdPlanNuevo);
          FETCH Lc_GetProdEnPlanDet INTO Lr_GetProdEnPlanDetNuevo;
          IF(Lc_GetProdEnPlanDet%NOTFOUND) THEN
            Lv_MsjError := 'No se ha podido obtener el producto que ser� incluido en el plan';
            RAISE Le_Exception;    
          END IF;
          CLOSE Lc_GetProdEnPlanDet;
          
          --Se busca al primer servicio cancelado de este tipo de producto que pueda ser tomado como migrado
          OPEN Lc_GetIdPrimerServAdicCancel(Ln_IdPunto, 
                                            Lv_NombreTecnicoProd, 
                                            'MIGRADO_' || Lv_SufijoCaractsProd, 
                                            'N');
          FETCH Lc_GetIdPrimerServAdicCancel INTO Ln_IdPrimerServAdicCancel;
          CLOSE Lc_GetIdPrimerServAdicCancel;
          
          IF Ln_IdPrimerServAdicCancel IS NOT NULL THEN
            --Existe un servicio adicional que fue cancelado anteriormente, por lo que se consultar� la infomaci�n del Usuario 
            --y Ssid de este servicio
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdPrimerServAdicCancel, 'USUARIO_'  || Lv_SufijoCaractsProd, 
                                                            NULL, 'Eliminado', 'SI',
                                                            Lv_Status, Lv_MsjError, Lr_RegistroSpcElimUsuario);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdPrimerServAdicCancel, 'SSID_'  || Lv_SufijoCaractsProd, 
                                                            NULL, 'Eliminado', 'SI',
                                                            Lv_Status, Lv_MsjError, Lr_RegistroSpcElimSsid);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            IF Lr_RegistroSpcElimUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcElimUsuario.VALOR IS NOT NULL
            AND Lr_RegistroSpcElimSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcElimSsid.VALOR IS NOT NULL THEN
              --El servicio adicional Cancelado si tiene asociadas las caracter�sticas USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
              Lv_ValorNuevoSpcUsuario           := Lr_RegistroSpcElimUsuario.VALOR;
              Lv_ValorNuevoSpcSsid              := Lr_RegistroSpcElimSsid.VALOR;

              Lr_ServicioHistorial              := NULL;
              Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
              Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
              Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
              Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
              Lr_ServicioHistorial.OBSERVACION  := 'Recontrataci�n: El Cliente ya posee un Servicio ' 
                                                   || Lr_GetProdEnPlanDetNuevo.DESCRIPCION_PRODUCTO
                                                   || ' Cancelado, se procede a Activar el Servicio con la informaci�n del <b>LOGIN</b>'
                                                   || ' y <b>SUSCRIBER_ID existente.';
              Lr_ServicioHistorial.ACCION       := NULL;
              DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              Lr_ConfigWsClearCache := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_GET_WS_CLEAR_CACHE;
              DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX(Lv_ValorNuevoSpcSsid,
                                                                  Ln_IdServicioInternet,
                                                                  Pr_InfoServicioInternet.ESTADO,
                                                                  'S',
                                                                  Lr_ConfigWsClearCache,
                                                                  Lv_UsrCreacion,
                                                                  Lv_IpCreacion,
                                                                  Lv_MsjError);
            ELSE
              --El servicio adicional Cancelado no tiene asociadas las caracter�sticas USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
              Lv_ValorNuevoSpcUsuario := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                          'INFO_SERVICIO_PROD_CARACT',
                                                                                          'FP',
                                                                                          'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                          Lv_NombreTecnicoProd);
              Lv_ValorNuevoSpcSsid    := TO_CHAR(Ln_IdServicioInternet);
            END IF;
            
            --Si existe el registro para MIGRADO_[PRODUCTO], se lo elimina con valor S para que no lo tome ning�n otro servicio
            FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdPrimerServAdicCancel, Lv_NombreTecnicoProd, 
                                                            'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoEliminado)
            LOOP
              IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL, 
                                                                            'S', Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Exception;
                END IF;
              END IF;
            END LOOP;
            
          ELSE
            Lv_ValorNuevoSpcUsuario := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                        'INFO_SERVICIO_PROD_CARACT',
                                                                                        'FP',
                                                                                        'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                        Lv_NombreTecnicoProd);
            Lv_ValorNuevoSpcSsid    := TO_CHAR(Ln_IdServicioInternet);
          
          END IF;
          
          Lv_ValorNuevoSpcPasswordTmp := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                         || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
          DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcPasswordTmp,
                                                      Lv_KeyEncript,
                                                      Lv_ValorNuevoSpcPassword);
          
          Lv_NotificaCredenciales       := 'SI';
          Ln_IdServNotifCredenciales    := Ln_IdServicioInternet;
          Lv_AgregaFormasContactoPunto  := 'SI';
          IF Lv_ValorNuevoSpcUsuario IS NULL THEN
            Lv_MsjError := 'No se ha podido crear el usuario';
            RAISE Le_Exception;
          END IF;
          
          IF Lv_ValorNuevoSpcPassword IS NULL THEN
            Lv_MsjError := 'No se ha podido crear la password';
            RAISE Le_Exception;
          END IF;
          
          IF Lv_ValorNuevoSpcSsid IS NULL THEN
            Lv_MsjError := 'No se ha podido crear el ssid';
            RAISE Le_Exception;
          END IF;
          
          ----Se eliminan todas las caracter�sticas asociadas al servicio de Internet del plan anterior.
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          --Si existe el registro para MIGRADO_[PRODUCTO], se lo elimina con valor S para que no lo tome ning�n otro servicio
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 
                                                          'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL, 'S',
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END LOOP;
          
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 'CORREO ELECTRONICO', Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR IS NOT NULL THEN
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL, NULL,
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END LOOP;
          
                    
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      'TIENE INTERNET', NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                      Lv_SufijoCaractsProd, NULL, 
                                                                      Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          --Se crean las nuevas caracter�sticas asociadas al servicio de Internet debido a que el nuevo plan incluye el producto
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'USUARIO_' || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcUsuario,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'PASSWORD_' || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcPassword,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'SSID_' || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcSsid,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'MIGRADO_' || Lv_SufijoCaractsProd,
                                                                      'N',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'TIENE INTERNET',
                                                                      'SI',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      Lv_SufijoCaractsProd,
                                                                      'S',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          -----------------------------------------------
          ---------------FIN ESCENARIO 3-----------------
          -----------------------------------------------


        ELSIF Ln_IdItemProdPlanAnterior IS NOT NULL AND Ln_IdItemProdPlanNuevo IS NOT NULL THEN
          ---------------------------------------------------
          --------------------ESCENARIO 5 Y 8----------------
          ---------------------------------------------------
          
          ---------Escenario 5---------
          IF Ln_IdServicioAdicional IS NULL THEN
            --Cancelar todo lo relacionado con el producto para servicios adicionales.        
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC(Ln_IdPunto, Lv_NombreTecnicoProd, NULL, NULL, NULL,
                                                                                  Lv_ProcesoEjecutante, Lv_ObsProcesoEjecutante, 
                                                                                  Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
          END IF;  
          -------Fin Escenario 5-------
          
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioInternet, 'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcUsuario);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioInternet, 'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcPassword);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcUsuario.VALOR IS NULL
          OR Lr_RegistroSpcPassword.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcPassword.VALOR IS NULL THEN
          
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                        'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                        Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                        'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 
                                                                        Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
              
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                        'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                        Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            --Se debe generar las credenciales por regularizaci�n y eliminar todas caracter�sticas asociadas al producto
            FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 
                                                            'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
            LOOP
              IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, 
                                                                            NULL, NULL, 'S', 
                                                                            Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Exception;
                END IF;
              END IF;
            END LOOP;
            
            --Se obtienen los correos guardados pero no se los elimina porque estos han sido guardados por el usuario
            FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioInternet, Lv_NombreTecnicoProd, 'CORREO ELECTRONICO', Lv_EstadoActivo)
            LOOP
              IF I_SpcPorCaractyProd.VALOR IS NOT NULL THEN
                Lv_CorreosDestinatarios := Lv_CorreosDestinatarios || I_SpcPorCaractyProd.VALOR || ',';
              END IF;
            END LOOP;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 'TIENE INTERNET', 
                                                                        NULL, Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioInternet, NULL, Lv_NombreTecnicoProd, 
                                                                        Lv_SufijoCaractsProd, NULL, Lv_UsrCreacion, Lv_Status, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            Lv_ValorNuevoSpcUsuario     := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                            'INFO_SERVICIO_PROD_CARACT',
                                                                                            'FP',
                                                                                            'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                          Lv_NombreTecnicoProd);
            Lv_ValorNuevoSpcPasswordTmp := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                           || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
            DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcPasswordTmp,
                                                        Lv_KeyEncript,
                                                        Lv_ValorNuevoSpcPassword);
            Lv_ValorNuevoSpcSsid      := TO_CHAR(Ln_IdServicioInternet);
            
            IF Lv_ValorNuevoSpcUsuario IS NULL THEN
              Lv_MsjError := 'No se ha podido crear el usuario';
              RAISE Le_Exception;
            END IF;
            
            IF Lv_ValorNuevoSpcPassword IS NULL THEN
              Lv_MsjError := 'No se ha podido crear la password';
              RAISE Le_Exception;
            END IF;
            
            IF Lv_ValorNuevoSpcSsid IS NULL THEN
              Lv_MsjError := 'No se ha podido crear el ssid';
              RAISE Le_Exception;
            END IF;
            
            --Se obtiene el producto incluido dentro del plan nuevo
            OPEN Lc_GetProdEnPlanDet(Ln_IdItemProdPlanNuevo);
            FETCH Lc_GetProdEnPlanDet INTO Lr_GetProdEnPlanDetNuevo;
            IF(Lc_GetProdEnPlanDet%NOTFOUND) THEN
              Lv_MsjError := 'No se ha podido obtener el producto que ser� incluido en el plan';
              RAISE Le_Exception;    
            END IF;
            CLOSE Lc_GetProdEnPlanDet;
   
            --Se crean las nuevas caracter�sticas asociadas al servicio de Internet por regularizaci�n
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                        Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                        Lv_EstadoActivo,
                                                                        'USUARIO_' || Lv_SufijoCaractsProd,
                                                                        Lv_ValorNuevoSpcUsuario,
                                                                        Lv_EstadoActivo,
                                                                        Lv_UsrCreacion,
                                                                        Lv_MsjError
                                                                        );
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                        Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                        Lv_EstadoActivo,
                                                                        'PASSWORD_' || Lv_SufijoCaractsProd,
                                                                        Lv_ValorNuevoSpcPassword,
                                                                        Lv_EstadoActivo,
                                                                        Lv_UsrCreacion,
                                                                        Lv_MsjError
                                                                        );
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                        Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                        Lv_EstadoActivo,
                                                                        'SSID_' || Lv_SufijoCaractsProd,
                                                                        Lv_ValorNuevoSpcSsid,
                                                                        Lv_EstadoActivo,
                                                                        Lv_UsrCreacion,
                                                                        Lv_MsjError
                                                                        );
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                        Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                        Lv_EstadoActivo,
                                                                        'MIGRADO_' || Lv_SufijoCaractsProd,
                                                                        'N',
                                                                        Lv_EstadoActivo,
                                                                        Lv_UsrCreacion,
                                                                        Lv_MsjError
                                                                        );
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                        Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                        Lv_EstadoActivo,
                                                                        'TIENE INTERNET',
                                                                        'SI',
                                                                        Lv_EstadoActivo,
                                                                        Lv_UsrCreacion,
                                                                        Lv_MsjError
                                                                        );
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                        Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                        Lv_EstadoActivo,
                                                                        Lv_SufijoCaractsProd,
                                                                        'S',
                                                                        Lv_EstadoActivo,
                                                                        Lv_UsrCreacion,
                                                                        Lv_MsjError
                                                                        );
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            
            Lv_NotificaCredenciales       := 'SI';
            Ln_IdServNotifCredenciales    := Ln_IdServicioInternet;
            Lv_AgregaFormasContactoPunto  := 'SI';
          END IF;
          
          ---------Escenario 8---------
          IF Ln_IdServicioAdicional IS NOT NULL THEN
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 
                                                            'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                            Lv_Status, Lv_MsjError, Lr_RegistroSpcUsuario);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 
                                                            'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                            Lv_Status, Lv_MsjError, Lr_RegistroSpcPassword);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcUsuario.VALOR IS NULL
            OR Lr_RegistroSpcPassword.ID_SERVICIO_PROD_CARACT IS NULL OR Lr_RegistroSpcPassword.VALOR IS NULL THEN
              --Se debe generar las credenciales por regularizaci�n y eliminar todas caracter�sticas asociadas al producto
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
                
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 
                                                              'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
              LOOP
                IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                  DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, 
                                                                              NULL, NULL, 'S', Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                  IF Lv_Status = 'ERROR' THEN
                    RAISE Le_Exception;
                  END IF;
                END IF;
              END LOOP;
              
              --Se obtienen los correos guardados pero no se los elimina porque estos han sido guardados por el usuario
              FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 'CORREO ELECTRONICO', Lv_EstadoActivo)
              LOOP
                IF I_SpcPorCaractyProd.VALOR IS NOT NULL THEN
                  Lv_CorreosDestinatariosRegu := Lv_CorreosDestinatariosRegu || I_SpcPorCaractyProd.VALOR || ',';
                END IF;
              END LOOP;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          'TIENE INTERNET', NULL, Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(NULL, Ln_IdServicioAdicional, NULL, Lv_NombreTecnicoProd, 
                                                                          Lv_SufijoCaractsProd, NULL, Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
              
              Lv_ValorNuevoSpcReguUsuario   := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                                'INFO_SERVICIO_PROD_CARACT',
                                                                                                'FP',
                                                                                                'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                                Lv_NombreTecnicoProd);

              Lv_ValorNuevoSpcReguPassTmp   := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                               || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
              DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcReguPassTmp,
                                                          Lv_KeyEncript,
                                                          Lv_ValorNuevoSpcReguPassword);
              Lv_ValorNuevoSpcReguSsid      := TO_CHAR(Ln_IdServicioAdicional);
              IF Lv_ValorNuevoSpcReguUsuario IS NULL THEN
                Lv_MsjError := 'No se ha podido crear el usuario';
                RAISE Le_Exception;
              END IF;
              
              IF Lv_ValorNuevoSpcReguPassword IS NULL THEN
                Lv_MsjError := 'No se ha podido crear la password';
                RAISE Le_Exception;
              END IF;
              
              IF Lv_ValorNuevoSpcReguSsid IS NULL THEN
                Lv_MsjError := 'No se ha podido crear el ssid';
                RAISE Le_Exception;
              END IF;
              
              OPEN Lc_GetIdProdServicio(Ln_IdServicioAdicional);
              FETCH Lc_GetIdProdServicio INTO Ln_IdProdServicioAdic;
              CLOSE Lc_GetIdProdServicio;
     
              --Se crean las nuevas caracter�sticas asociadas al servicio adicional por regularizaci�n
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'USUARIO_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguUsuario,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'PASSWORD_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguPassword,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'SSID_' || Lv_SufijoCaractsProd,
                                                                          Lv_ValorNuevoSpcReguSsid,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'MIGRADO_' || Lv_SufijoCaractsProd,
                                                                          'N',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          'TIENE INTERNET',
                                                                          'SI',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioAdicional,
                                                                          Ln_IdProdServicioAdic,
                                                                          Lv_EstadoActivo,
                                                                          Lv_SufijoCaractsProd,
                                                                          'S',
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              
              Lv_NotificaCredencialesRegu     := 'SI';
              Ln_IdServNotifCredencialesRegu  := Ln_IdServicioAdicional;
              
            END IF;
          END IF;
          -------Fin Escenario 8-------
          
          ---------------------------------------------------
          ---------------FIN ESCENARIO 5 Y 8-----------------
          ---------------------------------------------------
        
        
        ELSIF Ln_IdItemProdPlanAnterior IS NULL AND Ln_IdItemProdPlanNuevo IS NOT NULL AND Ln_IdServicioAdicional IS NOT NULL THEN
          -----------------------------------------------
          --------------------ESCENARIO 6----------------
          -----------------------------------------------
          --Se verifica servicio adicional
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcUsuario);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'PASSWORD_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcPassword);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdServicioAdicional, 'SSID_'  || Lv_SufijoCaractsProd, NULL, 'Activo', 'SI',
                                                          Lv_Status, Lv_MsjError, Lr_RegistroSpcSsid);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;

          --Se obtiene el producto incluido dentro del plan nuevo
          OPEN Lc_GetProdEnPlanDet(Ln_IdItemProdPlanNuevo);
          FETCH Lc_GetProdEnPlanDet INTO Lr_GetProdEnPlanDetNuevo;
          IF(Lc_GetProdEnPlanDet%NOTFOUND) THEN
            Lv_MsjError := 'No se ha podido obtener el producto que ser� incluido en el plan';
            RAISE Le_Exception;    
          END IF;
          CLOSE Lc_GetProdEnPlanDet;

          IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcUsuario.VALOR IS NOT NULL
          AND Lr_RegistroSpcPassword.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcPassword.VALOR IS NOT NULL THEN
            Lv_ValorNuevoSpcUsuario   := Lr_RegistroSpcUsuario.VALOR;
            Lv_ValorNuevoSpcPassword  := Lr_RegistroSpcPassword.VALOR;
            
            IF Lr_RegistroSpcSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL THEN
              Lv_ValorNuevoSpcSsid := Lr_RegistroSpcSsid.VALOR;
            ELSE
              Lv_ValorNuevoSpcSsid := TO_CHAR(Ln_IdServicioAdicional);
            END IF;
            
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioAdicional;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se traspasa la informaci�n de usuario y contrase�a al servicio de Internet por ejecuci�n de '
                                                 || 'cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se guarda la informaci�n de usuario y contrase�a obtenida del servicio ' 
                                                 || Lv_NombreProductoComercial || ' adicional que fue cancelado por ejecuci�n de cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;

          ELSE
            IF Lr_RegistroSpcUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcUsuario.VALOR IS NOT NULL
            AND Lr_RegistroSpcSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcSsid.VALOR IS NOT NULL THEN
              ----El servicio de Internet con el plan anterior posee la informaci�n correcta de USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
              Lv_ValorNuevoSpcUsuario := Lr_RegistroSpcUsuario.VALOR;
              Lv_ValorNuevoSpcSsid    := Lr_RegistroSpcSsid.VALOR;
            ELSE
              --Se busca al primer servicio cancelado de este tipo de producto que pueda ser tomado como migrado
              OPEN Lc_GetIdPrimerServAdicCancel(Ln_IdPunto, 
                                                Lv_NombreTecnicoProd, 
                                                'MIGRADO_'  || Lv_SufijoCaractsProd, 
                                                'N');
              FETCH Lc_GetIdPrimerServAdicCancel INTO Ln_IdPrimerServAdicCancel;
              CLOSE Lc_GetIdPrimerServAdicCancel;
              
              IF Ln_IdPrimerServAdicCancel IS NOT NULL THEN
                --Existe un servicio adicional que fue cancelado anteriormente, por lo que se consultar� la infomaci�n del Usuario 
                --y Ssid de este servicio
                DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdPrimerServAdicCancel, 'USUARIO_'  || Lv_SufijoCaractsProd, NULL, 
                                                                'Eliminado', 'SI', Lv_Status, Lv_MsjError, Lr_RegistroSpcElimUsuario);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Exception;
                END IF;
                
                DB_COMERCIAL.TECNK_SERVICIOS.P_GET_REGISTRO_SPC(NULL, Ln_IdPrimerServAdicCancel, 'SSID_'  || Lv_SufijoCaractsProd, NULL, 
                                                                'Eliminado', 'SI', Lv_Status, Lv_MsjError, Lr_RegistroSpcElimSsid);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Exception;
                END IF;
                
                IF Lr_RegistroSpcElimUsuario.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcElimUsuario.VALOR IS NOT NULL
                AND Lr_RegistroSpcElimSsid.ID_SERVICIO_PROD_CARACT IS NOT NULL AND Lr_RegistroSpcElimSsid.VALOR IS NOT NULL THEN
                  --El servicio adicional Cancelado si tiene asociadas las caracter�sticas USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
                  Lv_ValorNuevoSpcUsuario           := Lr_RegistroSpcElimUsuario.VALOR;
                  Lv_ValorNuevoSpcSsid              := Lr_RegistroSpcElimSsid.VALOR;

                  Lr_ServicioHistorial              := NULL;
                  Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
                  Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
                  Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
                  Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
                  Lr_ServicioHistorial.OBSERVACION  := 'Recontrataci�n: El Cliente ya posee un Servicio ' 
                                                       || Lr_GetProdEnPlanDetNuevo.DESCRIPCION_PRODUCTO
                                                       || ' Cancelado, se procede a Activar el Servicio con la informaci�n del <b>LOGIN</b>'
                                                       || ' y <b>SUSCRIBER_ID existente.';
                  Lr_ServicioHistorial.ACCION       := NULL;
                  DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
                  IF Lv_MsjError IS NOT NULL THEN
                    RAISE Le_Exception;
                  END IF;
                  
                  Lr_ConfigWsClearCache := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_GET_WS_CLEAR_CACHE;
                  DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX(Lv_ValorNuevoSpcSsid,
                                                                      Ln_IdServicioInternet,
                                                                      Pr_InfoServicioInternet.ESTADO,
                                                                      'S',
                                                                      Lr_ConfigWsClearCache,
                                                                      Lv_UsrCreacion,
                                                                      Lv_IpCreacion,
                                                                      Lv_MsjError);
                ELSE
                  --El servicio adicional Cancelado no tiene asociadas las caracter�sticas USUARIO_[PRODUCTO] y SSID_[PRODUCTO]
                  Lv_ValorNuevoSpcUsuario := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                              'INFO_SERVICIO_PROD_CARACT',
                                                                                              'FP',
                                                                                              'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                              Lv_NombreTecnicoProd);
                  Lv_ValorNuevoSpcSsid    := TO_CHAR(Ln_IdServicioInternet);
                END IF;
                
                FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdPrimerServAdicCancel, Lv_NombreTecnicoProd, 
                                                                'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoEliminado)
                LOOP
                  IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
                    DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL,
                                                                                NULL, NULL, 'S', Lv_UsrCreacion, Lv_Status, Lv_MsjError);
                    IF Lv_Status = 'ERROR' THEN
                      RAISE Le_Exception;
                    END IF;
                  END IF;
                END LOOP;
                
              ELSE
                --No existe un servicio adicional cancelado anteriormente
                Lv_ValorNuevoSpcUsuario := DB_COMERCIAL.COMEK_TRANSACTION.F_GENERA_USUARIO( Ln_IdPersona,
                                                                                            'INFO_SERVICIO_PROD_CARACT',
                                                                                            'FP',
                                                                                            'USUARIO_'  || Lv_SufijoCaractsProd,
                                                                                            Lv_NombreTecnicoProd);
                Lv_ValorNuevoSpcSsid    := TO_CHAR(Ln_IdServicioInternet);
              END IF;
            END IF;  
            Lv_ValorNuevoSpcPasswordTmp := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DBMS_RANDOM.STRING('A',8) ) 
                                           || TRUNC(ABS(DBMS_RANDOM.VALUE(0,99) ) );
            DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR( Lv_ValorNuevoSpcPasswordTmp,
                                                        Lv_KeyEncript,
                                                        Lv_ValorNuevoSpcPassword);

            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioAdicional;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se traspasa la informaci�n de usuario y contrase�a al servicio de Internet por ejecuci�n de '
                                                 || 'cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;
            
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'Se guarda la informaci�n regularizada de usuario y contrase�a obtenida del servicio ' 
                                                 || Lv_NombreProductoComercial || ' adicional que fue cancelado por ejecuci�n de cambio de plan';
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_Status = 'ERROR' THEN
              RAISE Le_Exception;
            END IF;

            Lv_NotificaCredenciales       := 'SI';
            Ln_IdServNotifCredenciales    := Ln_IdServicioInternet;
            Lv_AgregaFormasContactoPunto  := 'SI';
          END IF;
          
          IF Lv_ValorNuevoSpcUsuario IS NULL THEN
            Lv_MsjError := 'No se ha podido obtener el usuario';
            RAISE Le_Exception;
          END IF;

          IF Lv_ValorNuevoSpcPassword IS NULL THEN
            Lv_MsjError := 'No se ha podido obtener la password';
            RAISE Le_Exception;
          END IF;

          IF Lv_ValorNuevoSpcSsid IS NULL THEN
            Lv_MsjError := 'No se ha podido obtener el ssid';
            RAISE Le_Exception;
          END IF;
          
          --Si existe el registro para MIGRADO_[PRODUCTO], se lo elimina con valor S para que no lo tome ning�n otro servicio
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 
                                                          'MIGRADO_' || Lv_SufijoCaractsProd, Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR <> 'S' THEN
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_ELIMINA_SPC(I_SpcPorCaractyProd.ID_SERVICIO_PROD_CARACT, NULL, NULL, NULL, NULL, 'S',
                                                                          Lv_UsrCreacion, Lv_Status, Lv_MsjError);
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END LOOP;
          
          --Se crean las nuevas caracter�sticas asociadas al servicio adicional nuevo.
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'USUARIO_' || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcUsuario,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'PASSWORD_' || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcPassword,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'SSID_' || Lv_SufijoCaractsProd,
                                                                      Lv_ValorNuevoSpcSsid,
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'MIGRADO_' || Lv_SufijoCaractsProd,
                                                                      'N',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      'TIENE INTERNET',
                                                                      'SI',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                      Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                      Lv_EstadoActivo,
                                                                      Lv_SufijoCaractsProd,
                                                                      'S',
                                                                      Lv_EstadoActivo,
                                                                      Lv_UsrCreacion,
                                                                      Lv_MsjError
                                                                      );
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          
          FOR I_SpcPorCaractyProd IN Lc_SpcPorCaractyProd(Ln_IdServicioAdicional, Lv_NombreTecnicoProd, 'CORREO ELECTRONICO', Lv_EstadoActivo)
          LOOP
            IF I_SpcPorCaractyProd.VALOR IS NOT NULL THEN
              Lv_CorreosDestinatarios := Lv_CorreosDestinatarios || I_SpcPorCaractyProd.VALOR || ',';
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_SPC( Ln_IdServicioInternet,
                                                                          Lr_GetProdEnPlanDetNuevo.ID_PRODUCTO,
                                                                          Lv_EstadoActivo,
                                                                          'CORREO ELECTRONICO',
                                                                          I_SpcPorCaractyProd.VALOR,
                                                                          Lv_EstadoActivo,
                                                                          Lv_UsrCreacion,
                                                                          Lv_MsjError
                                                                          );
              IF Lv_Status = 'ERROR' THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END LOOP;
          
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_CANCEL_LOG_SERVS_ADIC(Ln_IdPunto, Lv_NombreTecnicoProd, Ln_IdServicioAdicional, 
                                                                                NULL, NULL, Lv_ProcesoEjecutante, Lv_ObsProcesoEjecutante, 
                                                                                Lv_UsrCreacion, Lv_Status, Lv_MsjError);
          IF Lv_Status = 'ERROR' THEN
            RAISE Le_Exception;
          END IF;
          
          -----------------------------------------------
          ---------------FIN ESCENARIO 6-----------------
          -----------------------------------------------
        
        ELSE
          Lv_MsjError := 'No existe un flujo definido';
          RAISE Le_Exception;
        END IF;

        
        --Se verifica si existen credenciales que deben ser notificadas
        IF Lv_NotificaCredenciales = 'SI' THEN
          DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Lv_ValorNuevoSpcPassword,
                                                         Lv_KeyEncript,
                                                         Lv_ValorNuevoSpcPassNotif);
          Lcl_PlantillaCorreo := NULL;
          OPEN Lc_GetPlantilla(Lv_CodigoPlantillaCorreo);
          FETCH Lc_GetPlantilla INTO Lcl_PlantillaCorreo;
          CLOSE Lc_GetPlantilla;
          Lcl_PlantillaCorreo := REPLACE(Lcl_PlantillaCorreo,'{{ cliente }}', Lv_NombreCliente);
          Lcl_PlantillaCorreo := REPLACE(Lcl_PlantillaCorreo,'{{ usuario }}', Lv_ValorNuevoSpcUsuario);
          Lcl_PlantillaCorreo := REPLACE(Lcl_PlantillaCorreo,'{{ contrasenia }}', Lv_ValorNuevoSpcPassNotif);
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV('CORREO',
                                                                                      Lcl_PlantillaCorreo,
                                                                                      Ln_IdPunto,
                                                                                      Ln_IdPersona,
                                                                                      Lv_AsuntoCorreo,
                                                                                      Lv_CorreosDestinatarios,
                                                                                      Lv_AgregaFormasContactoPunto,
                                                                                      Lv_Status,
                                                                                      Lv_MsjError,
                                                                                      Lcl_DestinatariosFinales);
          IF Lv_Status = 'OK' THEN                                 
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServNotifCredenciales;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'El usuario y contrase�a de ' || Lv_NombreProductoComercial || ' fue enviada al correo: <br>' 
                                                 || Lcl_DestinatariosFinales ;
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          ELSE
            RAISE Le_Exception;
          END IF;
          
          --Se verifica si est� activa la bandera para el env�o de SMS
          OPEN Lc_GetPermiteNotifSms(Lv_NombreTecnicoProd);
          FETCH Lc_GetPermiteNotifSms INTO Lv_PermiteNotifSms;
          CLOSE Lc_GetPermiteNotifSms; 
          IF Lv_PermiteNotifSms = 'SI' THEN
            Lcl_PlantillaSms          := NULL;
            Lcl_DestinatariosFinales  := NULL;
            OPEN Lc_GetPlantilla(Lv_CodigoPlantillaSms);
            FETCH Lc_GetPlantilla INTO Lcl_PlantillaSms;
            CLOSE Lc_GetPlantilla;
            
            Lcl_PlantillaSms := REPLACE(Lcl_PlantillaSms,'{{USUARIO}}', Lv_ValorNuevoSpcUsuario);
            Lcl_PlantillaSms := REPLACE(Lcl_PlantillaSms,'{{CONTRASENIA}}', Lv_ValorNuevoSpcPassNotif);    
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV('SMS',
                                                                                        Lcl_PlantillaSms,
                                                                                        Ln_IdPunto,
                                                                                        Ln_IdPersona,
                                                                                        NULL,
                                                                                        NULL,
                                                                                        NULL,
                                                                                        Lv_Status,
                                                                                        Lv_MsjError,
                                                                                        Lcl_DestinatariosFinales);
            IF Lv_Status = 'OK' THEN                                 
              Lr_ServicioHistorial              := NULL;
              Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServNotifCredenciales;
              Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
              Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
              Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
              Lr_ServicioHistorial.OBSERVACION  := 'El usuario y contrase�a de ' || Lv_NombreProductoComercial || ' fue enviada al tel�fono: <br>' 
                                                   || Lcl_DestinatariosFinales ;
              DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
            ELSE
              RAISE Le_Exception;
            END IF;
          END IF;
        END IF;
        
        IF Lv_NotificaCredencialesRegu = 'SI' THEN
          Lcl_DestinatariosFinales := NULL;
          DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Lv_ValorNuevoSpcReguPassword,
                                                         Lv_KeyEncript,
                                                         Lv_ValorNuevoSpcReguPassNotif);
                                                         
                                                         
                                                         
          IF Lv_CorreosDestinatariosRegu IS NULL OR Lv_AgregaFormasContactoPunto = 'SI' THEN
            FOR I_GetFormasContacto IN Lc_GetFormasContacto(Ln_IdPunto, 'Correo Electronico', Ln_IdPersona)
            LOOP
              IF I_GetFormasContacto.VALOR IS NOT NULL THEN
                Lv_CorreosDestinatariosRegu := Lv_CorreosDestinatariosRegu || I_GetFormasContacto.VALOR || ',';
              END IF;
            END LOOP;
          END IF;
          
          IF Lv_CorreosDestinatariosRegu IS NULL THEN
            Lv_CorreosDestinatariosRegu := Lv_CorreosDestinatariosRegu || Lv_Remitente || ',';
          END IF;
          
          Lcl_PlantillaCorreo := NULL;
          OPEN Lc_GetPlantilla(Lv_CodigoPlantillaCorreo);
          FETCH Lc_GetPlantilla INTO Lcl_PlantillaCorreo;
          CLOSE Lc_GetPlantilla;
          
          Lcl_PlantillaCorreo := REPLACE(Lcl_PlantillaCorreo,'{{ cliente }}', Lv_NombreCliente);
          Lcl_PlantillaCorreo := REPLACE(Lcl_PlantillaCorreo,'{{ usuario }}', Lv_ValorNuevoSpcReguUsuario);
          Lcl_PlantillaCorreo := REPLACE(Lcl_PlantillaCorreo,'{{ contrasenia }}', Lv_ValorNuevoSpcReguPassNotif);
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV('CORREO',
                                                                                      Lcl_PlantillaCorreo,
                                                                                      Ln_IdPunto,
                                                                                      Ln_IdPersona,
                                                                                      Lv_AsuntoCorreo,
                                                                                      Lv_CorreosDestinatariosRegu,
                                                                                      NULL,
                                                                                      Lv_Status,
                                                                                      Lv_MsjError,
                                                                                      Lcl_DestinatariosFinales);  
          IF Lv_Status = 'OK' THEN                                 
            Lr_ServicioHistorial              := NULL;
            Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServNotifCredencialesRegu;
            Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
            Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
            Lr_ServicioHistorial.OBSERVACION  := 'El usuario y contrase�a  por regularizaci�n de ' || Lv_NombreProductoComercial 
                                                 || ' fue enviada al correo: <br>' 
                                                 || Lcl_DestinatariosFinales ;
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          ELSE
            RAISE Le_Exception;
          END IF;
          
          OPEN Lc_GetPermiteNotifSms(Lv_NombreTecnicoProd);
          FETCH Lc_GetPermiteNotifSms INTO Lv_PermiteNotifSms;
          CLOSE Lc_GetPermiteNotifSms; 
          
          IF Lv_PermiteNotifSms = 'SI' THEN
            Lcl_PlantillaSms          := NULL;
            Lcl_DestinatariosFinales  := NULL;
            OPEN Lc_GetPlantilla(Lv_CodigoPlantillaSms);
            FETCH Lc_GetPlantilla INTO Lcl_PlantillaSms;
            CLOSE Lc_GetPlantilla;
            Lcl_PlantillaSms := REPLACE(Lcl_PlantillaSms,'{{USUARIO}}', Lv_ValorNuevoSpcReguUsuario);
            Lcl_PlantillaSms := REPLACE(Lcl_PlantillaSms,'{{CONTRASENIA}}', Lv_ValorNuevoSpcReguPassNotif);
            
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_NOTIF_CORREO_Y_SMS_PRODS_TV('SMS',
                                                                                        Lcl_PlantillaSms,
                                                                                        Ln_IdPunto,
                                                                                        Ln_IdPersona,
                                                                                        NULL,
                                                                                        NULL,
                                                                                        NULL,
                                                                                        Lv_Status,
                                                                                        Lv_MsjError,
                                                                                        Lcl_DestinatariosFinales);
            IF Lv_Status = 'OK' THEN                                 
              Lr_ServicioHistorial              := NULL;
              Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServNotifCredencialesRegu;
              Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
              Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
              Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
              Lr_ServicioHistorial.OBSERVACION  := 'El usuario y contrase�a por regularizaci�n de ' || Lv_NombreProductoComercial 
                                                   || ' fue enviada al tel�fono: <br>' 
                                                   || Lcl_DestinatariosFinales ;
              DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
            ELSE
              RAISE Le_Exception;
            END IF;
          END IF;
        END IF;
        COMMIT;

      EXCEPTION
      WHEN Le_Exception THEN  
        Lv_MsjHistoError  := 'No se ha podido ejecutar correctamente el flujo de cambio de plan masivo para el producto ' 
                             || Lv_NombreProductoComercial || ': ' || Lv_MsjError;
        Lv_CreaHistoError := 'SI';
        ROLLBACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_CPM_FLUJO_PRODS_TV', 
                                             Lv_MsjHistoError, 
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                             SYSDATE, 
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      WHEN OTHERS THEN
        Lv_MsjHistoError  := 'Ha ocurrido un error desconocido al ejecutar el flujo de cambio de plan masivo para el producto ' 
                             || Lv_NombreProductoComercial;
        Lv_CreaHistoError := 'SI';
        ROLLBACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_CPM_FLUJO_PRODS_TV', 
                                             Lv_MsjHistoError || SQLCODE || ' - ERROR_STACK: ' 
                                             || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                             SYSDATE, 
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      END;  
      --Fin de proceso por producto encontrado
      
      --Inicio de creaci�n de historial en el servicio de Internet cuando da error el proceso
      IF Lv_CreaHistoError = 'SI' THEN
        BEGIN
          Lr_ServicioHistorial              := NULL;
          Lr_ServicioHistorial.SERVICIO_ID  := Ln_IdServicioInternet;
          Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
          Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
          Lr_ServicioHistorial.ESTADO       := Pr_InfoServicioInternet.ESTADO;
          Lr_ServicioHistorial.OBSERVACION  := Lv_MsjHistoError;
          DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
          COMMIT;
        END;
        BEGIN
          Lr_GetPlantillaError  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('ERRORCPMGENERAL');
          Lcl_PlantillaError    := Lr_GetPlantillaError.PLANTILLA;
          Lcl_PlantillaError    := REPLACE(Lcl_PlantillaError,'{{ CLIENTE }}', Lv_NombreCliente);
          Lcl_PlantillaError    := REPLACE(Lcl_PlantillaError,'{{ LOGIN }}', Lv_Login);
          Lcl_PlantillaError    := REPLACE(Lcl_PlantillaError,'{{ OBSERVACION }}', Lv_MsjHistoError);
          
          IF Lr_GetPlantillaError.ALIAS_CORREOS IS NOT NULL THEN
            Lr_GetPlantillaError.ALIAS_CORREOS := REPLACE(Lr_GetPlantillaError.ALIAS_CORREOS, ';', ',') || ',';
          ELSE 
            Lr_GetPlantillaError.ALIAS_CORREOS := Lv_Remitente;
          END IF;
          UTL_MAIL.SEND(SENDER      => Lv_Remitente, 
                        RECIPIENTS  =>  Lr_GetPlantillaError.ALIAS_CORREOS, 
                        SUBJECT     => 'Error al ejecutar el cambio de plan masivo con servicios ' || Lv_NombreProductoComercial,
                        MESSAGE     => SUBSTR(Lcl_PlantillaError, 1, 32767), 
                        MIME_TYPE   => 'text/html; charset=iso-8859-1' );
        END;
      END IF;
      --Fin de creaci�n de historial en el servicio de Internet cuando da error el proceso
      
      Ln_IndxParametrosDetFlujoBusq := Lt_ParametrosDetFlujoBusq.NEXT(Ln_IndxParametrosDetFlujoBusq);
    END LOOP;
    --Fin de b�squeda de los productos que pertenecen al grupo TV para ejecutar el flujo respectivo
    
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido ejecutar correctamente el flujo de cambio de plan masivo para productos que pertenecen al grupo TV';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_CPM_FLUJO_PRODS_TV', 
                                         'No se ha podido ejecutar correctamente el flujo de cambio de plan masivo para productos ' ||
                                         'que pertenecen al grupo TV' 
                                         || SQLCODE || ' - ERROR_STACK: ' 
                                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_EJECUTA_CPM_FLUJO_PRODS_TV;
  
  PROCEDURE P_EJECUTA_FLUJOS_PRODS_CPM(
    Pn_IdServicioInternet   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdPlanAnterior       IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pn_IdPlanNuevo          IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_ProcesoEjecutante    IN VARCHAR2,
    Pv_ObsProcesoEjecutante IN VARCHAR2,
    Pv_UsrCreacion          IN VARCHAR2,
    Pv_IpCreacion           IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2)
  IS
    CURSOR Lc_GetInfoServicioInternet(Cn_IdServicioInternet DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT DISTINCT SERVICIO_INTERNET.ID_SERVICIO,
        SERVICIO_INTERNET.TIPO_ORDEN,
        SERVICIO_INTERNET.ESTADO,
        SERVICIO_INTERNET.USR_VENDEDOR AS USR_VENDEDOR_SERVICIO, 
        SERVICIO_INTERNET.PUNTO_FACTURACION_ID,
        PUNTO.ID_PUNTO,
        PUNTO.LOGIN,
        PUNTO.USR_VENDEDOR AS USR_VENDEDOR_PTO,
        PER.ID_PERSONA_ROL, 
        PERSONA.ID_PERSONA,
        CASE
          WHEN PERSONA.RAZON_SOCIAL IS NOT NULL THEN PERSONA.RAZON_SOCIAL
          WHEN PERSONA.NOMBRES IS NOT NULL AND PERSONA.APELLIDOS IS NOT NULL THEN 
            PERSONA.APELLIDOS || ' ' || PERSONA.NOMBRES
          ELSE ''
        END NOMBRE_CLIENTE,
        NVL(JURISDICCION.NOMBRE_JURISDICCION, '') AS NOMBRE_JURISDICCION,
        PLAN.ID_PLAN,
        PLAN.NOMBRE_PLAN,
        OLT.ID_ELEMENTO                                         AS ID_OLT,
        OLT.NOMBRE_ELEMENTO                                     AS NOMBRE_OLT,
        MARCA_OLT.NOMBRE_MARCA_ELEMENTO                         AS NOMBRE_MARCA_OLT,
        MODELO_OLT.NOMBRE_MODELO_ELEMENTO                       AS NOMBRE_MODELO_OLT,
        ONT.ID_ELEMENTO                                         AS ID_ONT,
        ONT.NOMBRE_ELEMENTO                                     AS NOMBRE_ONT,
        MODELO_ONT.NOMBRE_MODELO_ELEMENTO                       AS NOMBRE_MODELO_ONT,
        SERVICIO_TECNICO_INTERNET.INTERFACE_ELEMENTO_CLIENTE_ID AS ID_INTERFACE_ONT
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
      INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
      ON PUNTO.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
      ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
      ON PERSONA.ID_PERSONA = PER.PERSONA_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
      ON PLAN.ID_PLAN = SERVICIO_INTERNET.PLAN_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
      ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_INTERNET_EN_PLAN
      ON PROD_INTERNET_EN_PLAN.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO_INTERNET
      ON SERVICIO_TECNICO_INTERNET.SERVICIO_ID = SERVICIO_INTERNET.ID_SERVICIO
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
      ON OLT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
      ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_OLT
      ON TIPO_OLT.ID_TIPO_ELEMENTO = MODELO_OLT.TIPO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_OLT
      ON MARCA_OLT.ID_MARCA_ELEMENTO = MODELO_OLT.MARCA_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ONT
      ON ONT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_CLIENTE_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ONT
      ON MODELO_ONT.ID_MODELO_ELEMENTO = ONT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ONT
      ON MARCA_ONT.ID_MARCA_ELEMENTO              = MODELO_ONT.MARCA_ELEMENTO_ID
      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
      ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
      WHERE SERVICIO_INTERNET.ID_SERVICIO = Cn_IdServicioInternet
      AND PROD_INTERNET_EN_PLAN.NOMBRE_TECNICO   = 'INTERNET'
      AND PROD_INTERNET_EN_PLAN.ESTADO           = 'Activo'
      AND PROD_INTERNET_EN_PLAN.EMPRESA_COD      = '18'
      AND SERVICIO_INTERNET.ESTADO IN ('Activo', 'In-Corte');
      
    CURSOR Lc_GetServicioInternetGeneral(Cn_IdServicioInternet DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT PUNTO.LOGIN, 
      SERVICIO_INTERNET.ESTADO,
      CASE
        WHEN PERSONA.RAZON_SOCIAL IS NOT NULL THEN PERSONA.RAZON_SOCIAL
        WHEN PERSONA.NOMBRES IS NOT NULL AND PERSONA.APELLIDOS IS NOT NULL THEN 
          PERSONA.APELLIDOS || ' ' || PERSONA.NOMBRES
        ELSE ''
      END NOMBRE_CLIENTE
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
      INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
      ON PUNTO.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
      ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
      ON PERSONA.ID_PERSONA = PER.PERSONA_ID
      WHERE SERVICIO_INTERNET.ID_SERVICIO = Cn_IdServicioInternet;
    Lr_GetInfoServicioInternet    Lc_GetInfoServicioInternet%ROWTYPE;
    Lr_GetServicioInternetGeneral Lc_GetServicioInternetGeneral%ROWTYPE;
    Lr_InfoServicioPlanInternet   DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoServicioInternet;
    Lr_InfoServicioPlanInternetDb DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataClientesVerificaEquipos;
    Lr_ServicioHistorial          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_GetPlantillaError          DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Login                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Lv_NombreCliente              VARCHAR2(250);
    Lv_EstadoServicioInternet     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE;
    Lcl_PlantillaInicialError     CLOB;
    Lcl_PlantillaError            CLOB;
    Lv_Remitente                  VARCHAR2(300) := 'notificacionesnetlife@netlife.info.ec';
    Lv_ProcesoEjecutante          VARCHAR2(100);
    Lv_ObsProcesoEjecutante       VARCHAR2(2000);
    Lv_UsrCreacion                VARCHAR2(15);
    Lv_IpCreacion                 VARCHAR2(15);
    Lv_EjecutaProceso             VARCHAR2(2) := 'SI';
    Lv_Status                     VARCHAR2(5);
    Lv_MsjError                   VARCHAR2(4000);
    Lv_MsjErrorUsuario            VARCHAR2(4000);
    Ln_ContadorErrores            NUMBER := 0;
    Ln_IndxLoopErrores            NUMBER;
    Lt_MsjsErrores                DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
  BEGIN
    IF Pv_ProcesoEjecutante IS NOT NULL THEN
      Lv_ProcesoEjecutante := Pv_ProcesoEjecutante;
    ELSE
      Lv_ProcesoEjecutante := 'CAMBIO_PLAN_MASIVO';
    END IF;
    
    IF Pv_ObsProcesoEjecutante IS NOT NULL THEN
      Lv_ObsProcesoEjecutante := Pv_ObsProcesoEjecutante;
    ELSE
      Lv_ObsProcesoEjecutante := ' por cambio de plan masivo';
    END IF;

    IF Pv_UsrCreacion IS NOT NULL THEN
      Lv_UsrCreacion := Pv_UsrCreacion;
    ELSE
      Lv_UsrCreacion := 'ejecutaCpmAdic';
    END IF;
    
    IF Pv_IpCreacion IS NOT NULL THEN
      Lv_IpCreacion := Pv_IpCreacion;
    ELSE
      Lv_IpCreacion  := '127.0.0.1';
    END IF;
  
    OPEN Lc_GetInfoServicioInternet(Pn_IdServicioInternet);
    FETCH Lc_GetInfoServicioInternet INTO Lr_GetInfoServicioInternet;
    IF(Lc_GetInfoServicioInternet%NOTFOUND) THEN
      Lv_EjecutaProceso := 'NO';
    END IF;
    CLOSE Lc_GetInfoServicioInternet;
    
    Lr_GetPlantillaError      := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('ERRORCPMGENERAL');
    Lcl_PlantillaInicialError := Lr_GetPlantillaError.PLANTILLA;
    
    IF Lr_GetPlantillaError.ALIAS_CORREOS IS NOT NULL THEN
      Lr_GetPlantillaError.ALIAS_CORREOS := REPLACE(Lr_GetPlantillaError.ALIAS_CORREOS, ';', ',') || ',';
    ELSE 
      Lr_GetPlantillaError.ALIAS_CORREOS := Lv_Remitente;
    END IF; 
    
    IF Lv_EjecutaProceso = 'SI' THEN
      Lv_Login                  := Lr_GetInfoServicioInternet.LOGIN;
      Lv_NombreCliente          := Lr_GetInfoServicioInternet.NOMBRE_CLIENTE;
      Lv_EstadoServicioInternet := Lr_GetInfoServicioInternet.ESTADO;
      
      Lr_InfoServicioPlanInternetDb                           := NULL;
      Lr_InfoServicioPlanInternetDb.ID_SERVICIO               := Lr_GetInfoServicioInternet.ID_SERVICIO;
      Lr_InfoServicioPlanInternetDb.TIPO_ORDEN                := Lr_GetInfoServicioInternet.TIPO_ORDEN;
      Lr_InfoServicioPlanInternetDb.ESTADO_SERVICIO           := Lr_GetInfoServicioInternet.ESTADO;
      Lr_InfoServicioPlanInternetDb.ID_PUNTO                  := Lr_GetInfoServicioInternet.ID_PUNTO;
      Lr_InfoServicioPlanInternetDb.LOGIN                     := Lr_GetInfoServicioInternet.LOGIN;
      Lr_InfoServicioPlanInternetDb.CLIENTE                   := Lr_GetInfoServicioInternet.NOMBRE_CLIENTE;
      Lr_InfoServicioPlanInternetDb.NOMBRE_JURISDICCION       := Lr_GetInfoServicioInternet.NOMBRE_JURISDICCION;
      Lr_InfoServicioPlanInternetDb.ID_PLAN                   := Lr_GetInfoServicioInternet.ID_PLAN;
      Lr_InfoServicioPlanInternetDb.NOMBRE_PLAN               := Lr_GetInfoServicioInternet.NOMBRE_PLAN;
      Lr_InfoServicioPlanInternetDb.ID_OLT                    := Lr_GetInfoServicioInternet.ID_OLT;
      Lr_InfoServicioPlanInternetDb.NOMBRE_OLT                := Lr_GetInfoServicioInternet.NOMBRE_OLT;
      Lr_InfoServicioPlanInternetDb.NOMBRE_MARCA_OLT          := Lr_GetInfoServicioInternet.NOMBRE_MARCA_OLT;
      Lr_InfoServicioPlanInternetDb.NOMBRE_MODELO_OLT         := Lr_GetInfoServicioInternet.NOMBRE_MODELO_OLT;
      Lr_InfoServicioPlanInternetDb.ID_ONT                    := Lr_GetInfoServicioInternet.ID_ONT;
      Lr_InfoServicioPlanInternetDb.NOMBRE_ONT                := Lr_GetInfoServicioInternet.NOMBRE_ONT;
      Lr_InfoServicioPlanInternetDb.NOMBRE_MODELO_ONT         := Lr_GetInfoServicioInternet.NOMBRE_MODELO_ONT;
      Lr_InfoServicioPlanInternetDb.ID_INTERFACE_ONT          := Lr_GetInfoServicioInternet.ID_INTERFACE_ONT;
      
      Lv_Status   := '';
      Lv_MsjError := '';
      BEGIN
        DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_EJECUTA_CAMBIOPLAN_DUAL_BAND(Lr_InfoServicioPlanInternetDb,
                                                                              Pn_IdPlanAnterior,
                                                                              Pn_IdPlanNuevo,
                                                                              Lv_ObsProcesoEjecutante,
                                                                              Lv_UsrCreacion,
                                                                              Lv_IpCreacion,
                                                                              Lv_Status,
                                                                              Lv_MsjError);
        IF Lv_Status = 'OK' THEN
          COMMIT;
        ELSE
          Lt_MsjsErrores(Ln_ContadorErrores)  := 'Error al ejecutar el flujo para productos Dual Band ' || Lv_ObsProcesoEjecutante;
          Ln_ContadorErrores                  := Ln_ContadorErrores + 1;
          ROLLBACK;
        END IF;
      END;
      
      Lr_InfoServicioPlanInternet                           := NULL;
      Lr_InfoServicioPlanInternet.ID_SERVICIO               := Lr_GetInfoServicioInternet.ID_SERVICIO;
      Lr_InfoServicioPlanInternet.USR_VENDEDOR_SERVICIO     := Lr_GetInfoServicioInternet.USR_VENDEDOR_SERVICIO;
      Lr_InfoServicioPlanInternet.PUNTO_FACTURACION_ID      := Lr_GetInfoServicioInternet.PUNTO_FACTURACION_ID;
      Lr_InfoServicioPlanInternet.ID_PUNTO                  := Lr_GetInfoServicioInternet.ID_PUNTO;
      Lr_InfoServicioPlanInternet.LOGIN                     := Lr_GetInfoServicioInternet.LOGIN;
      Lr_InfoServicioPlanInternet.USR_VENDEDOR_PTO          := Lr_GetInfoServicioInternet.USR_VENDEDOR_PTO;
      Lr_InfoServicioPlanInternet.PREFIJO_EMPRESA_VENDEDOR  := 'MD';
      Lr_InfoServicioPlanInternet.ESTADO                    := Lr_GetInfoServicioInternet.ESTADO;
      Lr_InfoServicioPlanInternet.ID_PERSONA_ROL            := Lr_GetInfoServicioInternet.ID_PERSONA_ROL;
      Lr_InfoServicioPlanInternet.ID_PERSONA                := Lr_GetInfoServicioInternet.ID_PERSONA;
      Lr_InfoServicioPlanInternet.NOMBRE_CLIENTE            := Lr_GetInfoServicioInternet.NOMBRE_CLIENTE;
      
      Lv_Status   := '';
      Lv_MsjError := '';
      DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_CPM_FLUJO_PRODS_TV( Lr_InfoServicioPlanInternet,
                                                                                  Pn_IdPlanAnterior,
                                                                                  Pn_IdPlanNuevo,
                                                                                  Lv_ProcesoEjecutante,
                                                                                  Lv_ObsProcesoEjecutante,
                                                                                  Lv_UsrCreacion,
                                                                                  Lv_IpCreacion,
                                                                                  Lv_Status,
                                                                                  Lv_MsjError);
      IF Lv_Status = 'ERROR' THEN
        Lt_MsjsErrores(Ln_ContadorErrores)  := 'Error al ejecutar el flujo para productos TV ' || Lv_ObsProcesoEjecutante;
        Ln_ContadorErrores                  := Ln_ContadorErrores + 1;
      END IF;
                                                                                  
      Lv_Status   := '';
      Lv_MsjError := '';
    ELSE
      OPEN Lc_GetServicioInternetGeneral(Pn_IdServicioInternet);
      FETCH Lc_GetServicioInternetGeneral INTO Lr_GetServicioInternetGeneral;
      IF(Lc_GetServicioInternetGeneral%FOUND) THEN
        Lv_Login                  := Lr_GetServicioInternetGeneral.LOGIN;
        Lv_NombreCliente          := Lr_GetServicioInternetGeneral.NOMBRE_CLIENTE;
        Lv_EstadoServicioInternet := Lr_GetServicioInternetGeneral.ESTADO;
        
        Lt_MsjsErrores(Ln_ContadorErrores)  := 'No se ha podido obtener la informaci�n del servicio de Internet ' || Lv_ObsProcesoEjecutante;
        Ln_ContadorErrores                  := Ln_ContadorErrores + 1;
      END IF;
      CLOSE Lc_GetServicioInternetGeneral;
    END IF;
    
    IF Ln_ContadorErrores > 0 THEN
      Ln_IndxLoopErrores := Lt_MsjsErrores.FIRST;
      WHILE (Ln_IndxLoopErrores IS NOT NULL)
      LOOP
        Lv_MsjErrorUsuario  := Lt_MsjsErrores(Ln_IndxLoopErrores);
        Lcl_PlantillaError  := '';
        BEGIN
          Lr_ServicioHistorial              := NULL;
          Lr_ServicioHistorial.SERVICIO_ID  := Pn_IdServicioInternet;
          Lr_ServicioHistorial.USR_CREACION := Lv_UsrCreacion;
          Lr_ServicioHistorial.IP_CREACION  := Lv_IpCreacion;
          Lr_ServicioHistorial.ESTADO       := Lv_EstadoServicioInternet;
          Lr_ServicioHistorial.OBSERVACION  := Lv_MsjErrorUsuario;
          DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA(Lr_ServicioHistorial, Lv_MsjError);
          COMMIT;
        END;
        BEGIN
          Lcl_PlantillaError    := Lcl_PlantillaInicialError;
          Lcl_PlantillaError    := REPLACE(Lcl_PlantillaError,'{{ CLIENTE }}', Lv_NombreCliente);
          Lcl_PlantillaError    := REPLACE(Lcl_PlantillaError,'{{ LOGIN }}',  Lv_Login);
          Lcl_PlantillaError    := REPLACE(Lcl_PlantillaError,'{{ OBSERVACION }}', Lv_MsjErrorUsuario);
          UTL_MAIL.SEND(SENDER      => Lv_Remitente, 
                        RECIPIENTS  =>  Lr_GetPlantillaError.ALIAS_CORREOS, 
                        SUBJECT     => 'Error al ejecutar los flujos para productos '|| Lv_ObsProcesoEjecutante,
                        MESSAGE     => SUBSTR(Lcl_PlantillaError, 1, 32767), 
                        MIME_TYPE   => 'text/html; charset=iso-8859-1' );
        END;
        Ln_IndxLoopErrores  := Lt_MsjsErrores.NEXT(Ln_IndxLoopErrores);
      END LOOP;
    END IF;
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido ejecutar correctamente el flujo de cambio de plan masivo por productos incluidos en el plan o adicionales';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_FLUJOS_PRODS_CPM', 
                                         SQLCODE || ' - ERROR_STACK: ' 
                                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_EJECUTA_FLUJOS_PRODS_CPM;

  PROCEDURE P_CREA_CORTE_MASIVO_X_LOTES(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_PrefijoEmpresa       IN VARCHAR2,
    Pv_UsrCreacion          IN VARCHAR2,
    Pv_IpCreacion           IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pn_IdSolCortePorLotes   OUT NUMBER)
  AS
    Lv_UsrCreacion                  VARCHAR2(15);
    Lv_IpCreacion                   VARCHAR2(16);
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
    Ln_TotalPuntosCorteMasivo       NUMBER;
    Lrf_PuntosCorteMasivo           SYS_REFCURSOR;
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_FechaCreacionDoc             VARCHAR2(10);
    Lv_TiposDocumentos              VARCHAR2(100);
    Lv_NumDocsAbiertos              VARCHAR2(10);
    Lv_ValorMontoCartera            VARCHAR2(10);
    Lv_IdTipoNegocio                VARCHAR2(10);
    Lv_ValorClienteCanal            VARCHAR2(20);
    Lv_NombreUltimaMilla            VARCHAR2(20);
    Lv_IdCicloFacturacion           VARCHAR2(10);
    Lv_IdsOficinas                  VARCHAR2(32767);
    Lv_IdsFormasPago                VARCHAR2(32767);
    Lv_ValorCuentaTarjeta           VARCHAR2(100);
    Lv_IdsTiposCuentaTarjeta        VARCHAR2(4000);
    Lv_IdsBancos                    VARCHAR2(32767);
    Lv_CampoPmCabIdsBancos          VARCHAR2(32767);
    Lr_RegPuntosCorteMasivo         DB_INFRAESTRUCTURA.INKG_TYPES.Lr_PuntosCorteMasivo;
    Lt_TPuntosCorteMasivo           DB_INFRAESTRUCTURA.INKG_TYPES.Lt_PuntosCorteMasivo;
    Ln_IndxPuntosCorteMasivo        NUMBER;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lv_ParamCabNombreParametro      VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ParamDetValor1CorteMasivo    VARCHAR2(13) := 'CORTE_MASIVO';
    Lv_ParamDetValor2LoginesXLote   VARCHAR2(21) := 'NUM_LOGINES_POR_LOTE';
    Lv_NumLoginesPorLote            VARCHAR2(100);
    Ln_NumLoginesPorLote            NUMBER;
    Lv_NombreTecnicoProdUm          VARCHAR2(200);
    Lv_CodigoUm                     VARCHAR2(100);
    Lv_TipoProceso                  VARCHAR2(14) := 'CortarCliente';
    Lv_EstadoPorEjecutar            VARCHAR2(12) := 'PorEjecutar';
    Lv_EstadoFinalizada             VARCHAR2(11) := 'Finalizada';
    Lv_EstadoPendiente              VARCHAR2(11) := 'Pendiente';
    Ln_ValorMinMontoCartera         NUMBER := 5;
    Ln_Rownum                       NUMBER := 1;
    Ln_IdTipoSolCortePorLotes       DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
    Lv_DescripcionSolCortePorLotes  VARCHAR2(33) := 'SOLICITUD CORTE MASIVO POR LOTES';
    Lr_InfoDetalleSolicitud         DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolHistorial      DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_InfoDetalleSolicitudCaract   DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
    Ln_IdCaractIdPmCabFo            DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractIdPmCabCoRad         DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractIdPmCabErrorUm       DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractIdsFormasPago        DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractCodigosTiposDoc      DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lv_CaractIdPmCabFo              VARCHAR2(25) := 'ID_PROCESO_MASIVO_CAB_FO';
    Lv_CaractIdPmCabCoRad           VARCHAR2(29) := 'ID_PROCESO_MASIVO_CAB_CO_RAD';
    Lv_CaractIdPmCabErrorUm         VARCHAR2(31) := 'ID_PROCESO_MASIVO_CAB_ERROR_UM';
    Lv_CaractIdsFormasPago          VARCHAR2(16) := 'IDS_FORMAS_PAGO';
    Lv_CaractCodigosTiposDoc        VARCHAR2(18) := 'CODIGOS_TIPOS_DOC';
    Lv_TipoCaract                   VARCHAR2(7)  := 'TECNICA';
    Lr_InfoProcesoMasivoCabFo       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoCabCoRad    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoCabErrorUm  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Ln_IdProcesoMasivoCabFo         DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoCabCoRad      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoCabErrorUm    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Lr_InfoProcesoMasivoDet         DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;
    Ln_IdProcesoMasivoDet           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;
    Lv_NombreParametro              VARCHAR2(200)  := 'PARAMETROS_PROCESOS_MASIVOS_TELCOS';
    Lv_NuevoProcesamiento           VARCHAR2(200)  := 'NUEVO_PROCESAMIENTO_MASIVO';
    Lv_ValorNuevoProcesamiento      VARCHAR2(10)   := 'NO';
    Lv_CodEmpresa                   VARCHAR2(5);

    CURSOR Lc_GetValoresParamsGeneral(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                      Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DET.VALOR3, DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.VALOR1 = Cv_Valor1
      AND DET.VALOR2 = Cv_Valor2
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetInfoEmpresaPm( Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT TO_NUMBER(EMPRESA_GRUPO.COD_EMPRESA) AS ID_EMPRESA, DET.VALOR3 AS PREFIJO_EMPRESA
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPRESA_GRUPO
      ON EMPRESA_GRUPO.PREFIJO = DET.VALOR3
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.VALOR1 = Cv_Valor1
      AND DET.VALOR2 = Cv_Valor2
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetIdTipoSolCortePorLotes(Cv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE)
    IS
      SELECT TIPO_SOLICITUD.ID_TIPO_SOLICITUD
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
      WHERE TIPO_SOLICITUD.DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
      AND TIPO_SOLICITUD.ESTADO                  = Lv_EstadoActivo
      AND ROWNUM                                 = Ln_Rownum;

    CURSOR Lc_GetIdCaracteristica(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT CARACTERISTICA.ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA
      WHERE CARACTERISTICA.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND CARACTERISTICA.ESTADO                       = Lv_EstadoActivo
      AND CARACTERISTICA.TIPO                         = Lv_TipoCaract
      AND ROWNUM                                      = Ln_Rownum;
    CURSOR C_OBTENERPARAMMW IS
      SELECT NVL(VALOR1, 'NO') FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO = Lv_EstadoActivo AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
          WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1)
      AND DESCRIPCION = Lv_NuevoProcesamiento AND ROWNUM = 1;

    Lr_RegGetValoresParamsGeneral   Lc_GetValoresParamsGeneral%ROWTYPE;
    Lr_RegGetInfoEmpresaPm          Lc_GetInfoEmpresaPm%ROWTYPE;
    Lv_ParamEmpresaEquivalente      VARCHAR2(20) := 'EMPRESA_EQUIVALENTE';
    Lv_ParamDetValor2UmFo           VARCHAR2(2) := 'FO';
    Lv_ParamDetValor2UmCo           VARCHAR2(2) := 'CO';
    Ln_IdEmpresaUmFo                NUMBER;
    Ln_IdEmpresaUmCoRad             NUMBER;
    Ln_ContadorPorLoteUmFo          NUMBER := 0;
    Ln_ContadorPorLoteUmCoRad       NUMBER := 0;
    Ln_ContadorPorLoteUmError       NUMBER := 0;
    Ln_IdDetalleSolicitud           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;

  BEGIN
    IF Pv_UsrCreacion IS NOT NULL THEN
      Lv_UsrCreacion := Pv_UsrCreacion;
    ELSE
      Lv_UsrCreacion := 'corteMasivoTodo';
    END IF;

    IF Pv_IpCreacion IS NOT NULL THEN
      Lv_IpCreacion := Pv_IpCreacion;
    ELSE
      Lv_IpCreacion := '127.0.0.1';
    END IF;

    OPEN C_OBTENERPARAMMW;
    FETCH C_OBTENERPARAMMW INTO Lv_ValorNuevoProcesamiento;
    CLOSE C_OBTENERPARAMMW;

    Lcl_JsonFiltrosBusqueda   := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_FechaCreacionDoc         := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strFechaCreacionDoc'));
    Lv_TiposDocumentos          := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strTiposDocumentos'));
    Lv_NumDocsAbiertos          := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNumDocsAbiertos'));
    Lv_ValorMontoCartera        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorMontoCartera'));
    Lv_IdTipoNegocio            := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdTipoNegocio'));
    Lv_ValorClienteCanal        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorClienteCanal'));
    Lv_NombreUltimaMilla        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNombreUltimaMilla'));
    Lv_IdCicloFacturacion       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdCicloFacturacion'));
    Lv_IdsOficinas              := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsOficinas'));
    Lv_IdsFormasPago            := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsFormasPago'));
    Lv_ValorCuentaTarjeta       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorCuentaTarjeta'));
    Lv_IdsTiposCuentaTarjeta    := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsTiposCuentaTarjeta'));
    Lv_IdsBancos                := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsBancos'));
    Lv_CodEmpresa               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));

    IF Lv_ValorCuentaTarjeta IS NOT NULL OR Lv_IdsTiposCuentaTarjeta IS NOT NULL OR Lv_IdsBancos IS NOT NULL THEN
      Lv_CampoPmCabIdsBancos := Lv_ValorCuentaTarjeta || '&' || Lv_IdsTiposCuentaTarjeta || '&' || Lv_IdsBancos;
    END IF;

    OPEN Lc_GetValoresParamsGeneral(Lv_ParamCabNombreParametro, Lv_ParamDetValor1CorteMasivo, Lv_ParamDetValor2LoginesXLote);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_NumLoginesPorLote := Lr_RegGetValoresParamsGeneral.VALOR3;
    IF Lv_NumLoginesPorLote IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el valor parametrizado de logines por por lote';
      RAISE Le_Exception;
    END IF;
    Ln_NumLoginesPorLote := TO_NUMBER(Lv_NumLoginesPorLote, '9999');

    Lv_NombreTecnicoProdUm:= Lr_RegGetValoresParamsGeneral.VALOR4;
    IF Lv_NombreTecnicoProdUm IS NULL THEN
      Lv_MsjError := 'No se ha configurado el nombre t�cnico del producto Internet';
      RAISE Le_Exception;
    END IF;
    
    IF Pv_PrefijoEmpresa <> 'EN' THEN
      OPEN Lc_GetInfoEmpresaPm(Lv_ParamEmpresaEquivalente, Pv_PrefijoEmpresa, Lv_ParamDetValor2UmFo);
      FETCH Lc_GetInfoEmpresaPm INTO Lr_RegGetInfoEmpresaPm;
      CLOSE Lc_GetInfoEmpresaPm;
      Ln_IdEmpresaUmFo := Lr_RegGetInfoEmpresaPm.ID_EMPRESA;
    ELSE
      Ln_IdEmpresaUmFo := TO_NUMBER(Lv_CodEmpresa,999);
    END IF;
   
    IF Ln_IdEmpresaUmFo IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la empresa para la �ltima milla FO';
      RAISE Le_Exception;
    END IF;

      Lr_RegGetInfoEmpresaPm := NULL;
     IF Pv_PrefijoEmpresa <> 'EN' THEN
        OPEN Lc_GetInfoEmpresaPm(Lv_ParamEmpresaEquivalente, Pv_PrefijoEmpresa, Lv_ParamDetValor2UmCo);
        FETCH Lc_GetInfoEmpresaPm INTO Lr_RegGetInfoEmpresaPm;
        CLOSE Lc_GetInfoEmpresaPm;
        Ln_IdEmpresaUmCoRad := Lr_RegGetInfoEmpresaPm.ID_EMPRESA;
        IF Ln_IdEmpresaUmCoRad IS NULL  THEN
          Lv_MsjError := 'No se ha podido obtener el id de la empresa para la �ltima milla CO';
          RAISE Le_Exception;
        END IF;
      END IF;
      
    OPEN Lc_GetIdTipoSolCortePorLotes(Lv_DescripcionSolCortePorLotes);
    FETCH Lc_GetIdTipoSolCortePorLotes INTO Ln_IdTipoSolCortePorLotes;
    CLOSE Lc_GetIdTipoSolCortePorLotes;
    IF Ln_IdTipoSolCortePorLotes IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id del tipo de solicitud para el corte masivo por lotes';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetIdCaracteristica(Lv_CaractIdPmCabFo);
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractIdPmCabFo;
    CLOSE Lc_GetIdCaracteristica;
    IF Ln_IdCaractIdPmCabFo IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica de procesos masivos de Fibra �ptica';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetIdCaracteristica(Lv_CaractIdPmCabCoRad);
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractIdPmCabCoRad;
    CLOSE Lc_GetIdCaracteristica;
    IF Ln_IdCaractIdPmCabCoRad IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica de procesos masivos de Cobre/Radio';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetIdCaracteristica(Lv_CaractIdPmCabErrorUm);
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractIdPmCabErrorUm;
    CLOSE Lc_GetIdCaracteristica;
    IF Ln_IdCaractIdPmCabErrorUm IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica de procesos masivos de Error �ltima milla';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetIdCaracteristica(Lv_CaractIdsFormasPago);
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractIdsFormasPago;
    CLOSE Lc_GetIdCaracteristica;
    IF Ln_IdCaractIdsFormasPago IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica de formas de pago';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetIdCaracteristica(Lv_CaractCodigosTiposDoc);
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractCodigosTiposDoc;
    CLOSE Lc_GetIdCaracteristica;
    IF Ln_IdCaractCodigosTiposDoc IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica de los c�digos de los tipos de documentos';
      RAISE Le_Exception;
    END IF;

    DB_COMERCIAL.TECNK_SERVICIOS.P_GET_PUNTOS_CORTE_MASIVO( Pcl_JsonFiltrosBusqueda,
                                                            'NO',
                                                            Lv_Status,
                                                            Lv_MsjError,
                                                            Ln_TotalPuntosCorteMasivo,
                                                            Lrf_PuntosCorteMasivo);
    IF Lv_Status = 'ERROR' THEN
      RAISE Le_Exception;
    END IF;

    LOOP
      FETCH Lrf_PuntosCorteMasivo BULK COLLECT INTO Lt_TPuntosCorteMasivo LIMIT Ln_NumLoginesPorLote;
      Ln_IdProcesoMasivoCabFo       := NULL;
      Ln_IdProcesoMasivoCabCoRad    := NULL;
      Ln_IdProcesoMasivoCabErrorUm  := NULL;
      Ln_ContadorPorLoteUmFo        := 0;
      Ln_ContadorPorLoteUmCoRad     := 0;
      Ln_ContadorPorLoteUmError     := 0;
      Ln_IndxPuntosCorteMasivo      := Lt_TPuntosCorteMasivo.FIRST;
      WHILE (Ln_IndxPuntosCorteMasivo IS NOT NULL)
      LOOP
        Lv_MsjError             := '';
        Lr_RegPuntosCorteMasivo := Lt_TPuntosCorteMasivo(Ln_IndxPuntosCorteMasivo);

        IF Ln_IdDetalleSolicitud IS NULL THEN 
          Lr_InfoDetalleSolicitud                         := NULL;
          Ln_IdDetalleSolicitud                           := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;
          Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD    := Ln_IdDetalleSolicitud;
          Lr_InfoDetalleSolicitud.TIPO_SOLICITUD_ID       := Ln_IdTipoSolCortePorLotes;
          Lr_InfoDetalleSolicitud.USR_CREACION            := Lv_UsrCreacion;
          Lr_InfoDetalleSolicitud.ESTADO                  := Lv_EstadoPorEjecutar;
          Lr_InfoDetalleSolicitud.OBSERVACION             := 'Se crea la solicitud por ejecuci�n de corte masivo por lotes';
          DB_COMERCIAL.COMEK_MODELO.COMPP_INSERT_DETALLE_SOLICITUD(Lr_InfoDetalleSolicitud, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
      
          Lr_InfoDetalleSolicitudCaract                      := NULL;
          Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractIdsFormasPago;
          Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Ln_IdDetalleSolicitud;
          Lr_InfoDetalleSolicitudCaract.VALOR                := Lv_IdsFormasPago;
          Lr_InfoDetalleSolicitudCaract.ESTADO               := Lv_EstadoFinalizada;
          Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrCreacion;
          DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
      
          Lr_InfoDetalleSolicitudCaract                      := NULL;
          Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractCodigosTiposDoc;
          Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Ln_IdDetalleSolicitud;
          Lr_InfoDetalleSolicitudCaract.VALOR                := Lv_TiposDocumentos;
          Lr_InfoDetalleSolicitudCaract.ESTADO               := Lv_EstadoFinalizada;
          Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrCreacion;
          DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
        END IF;

        Lv_CodigoUm := DB_COMERCIAL.TECNK_SERVICIOS.FNC_GET_MEDIO_POR_PUNTO(Lr_RegPuntosCorteMasivo.ID_PUNTO, Lv_NombreTecnicoProdUm);
        IF Lv_CodigoUm IS NOT NULL AND (Lv_CodigoUm = 'FO' OR Lv_CodigoUm = 'CO' OR Lv_CodigoUm = 'RAD') THEN
          Lr_InfoProcesoMasivoDet := NULL;
          IF Lv_CodigoUm = 'FO' THEN
            IF Ln_IdProcesoMasivoCabFo IS NULL THEN 
              Lr_InfoProcesoMasivoCabFo                         := NULL;
              Lr_InfoProcesoMasivoCabFo.TIPO_PROCESO            := Lv_TipoProceso;
              Lr_InfoProcesoMasivoCabFo.FECHA_EMISION_FACTURA   := TO_DATE(Lv_FechaCreacionDoc,'YYYY-MM-DD');
              Lr_InfoProcesoMasivoCabFo.FACTURAS_RECURRENTES    := Lv_NumDocsAbiertos;
              Lr_InfoProcesoMasivoCabFo.VALOR_DEUDA             := NVL(Lv_ValorMontoCartera, Ln_ValorMinMontoCartera);
              Lr_InfoProcesoMasivoCabFo.IDS_BANCOS_TARJETAS     := Lv_CampoPmCabIdsBancos;
              Lr_InfoProcesoMasivoCabFo.IDS_OFICINAS            := Lv_IdsOficinas;
              Lr_InfoProcesoMasivoCabFo.EMPRESA_ID              := Ln_IdEmpresaUmFo;
              Lr_InfoProcesoMasivoCabFo.ESTADO                  := Lv_EstadoPorEjecutar;
              Lr_InfoProcesoMasivoCabFo.FE_CREACION             := SYSDATE;
              Lr_InfoProcesoMasivoCabFo.USR_CREACION            := Lv_UsrCreacion;
              Lr_InfoProcesoMasivoCabFo.IP_CREACION             := Lv_IpCreacion;
              Lr_InfoProcesoMasivoCabFo.SOLICITUD_ID            := Ln_IdDetalleSolicitud;
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_CAB(Lr_InfoProcesoMasivoCabFo, Ln_IdProcesoMasivoCabFo, 
                                                                                        Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN 
                RAISE Le_Exception;
              END IF;

              Lr_InfoDetalleSolHistorial                        := NULL;
              Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
              Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Ln_IdDetalleSolicitud;
              Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoPorEjecutar;
              Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se crea el proceso masivo de corte de Fibra �ptica #' || Ln_IdProcesoMasivoCabFo
                                                                   || ' asociado a esta solicitud';
              Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrCreacion;
              Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
              Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
              DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;

            END IF;
            Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID := Ln_IdProcesoMasivoCabFo;
            Ln_ContadorPorLoteUmFo  := Ln_ContadorPorLoteUmFo+1;
          ELSE
            IF Ln_IdProcesoMasivoCabCoRad IS NULL THEN 
              Lr_InfoProcesoMasivoCabCoRad                          := NULL;
              Lr_InfoProcesoMasivoCabCoRad.TIPO_PROCESO             := Lv_TipoProceso;
              Lr_InfoProcesoMasivoCabCoRad.FECHA_EMISION_FACTURA    := TO_DATE(Lv_FechaCreacionDoc,'YYYY-MM-DD');
              Lr_InfoProcesoMasivoCabCoRad.FACTURAS_RECURRENTES     := Lv_NumDocsAbiertos;
              Lr_InfoProcesoMasivoCabCoRad.VALOR_DEUDA              := NVL(Lv_ValorMontoCartera, Ln_ValorMinMontoCartera);
              Lr_InfoProcesoMasivoCabCoRad.IDS_BANCOS_TARJETAS      := Lv_CampoPmCabIdsBancos;
              Lr_InfoProcesoMasivoCabCoRad.IDS_OFICINAS             := Lv_IdsOficinas;
              Lr_InfoProcesoMasivoCabCoRad.EMPRESA_ID               := Ln_IdEmpresaUmFo;
              Lr_InfoProcesoMasivoCabCoRad.ESTADO                   := Lv_EstadoPorEjecutar;
              Lr_InfoProcesoMasivoCabCoRad.FE_CREACION              := SYSDATE;
              Lr_InfoProcesoMasivoCabCoRad.USR_CREACION             := Lv_UsrCreacion;
              Lr_InfoProcesoMasivoCabCoRad.IP_CREACION              := Lv_IpCreacion;
              Lr_InfoProcesoMasivoCabCoRad.SOLICITUD_ID             := Ln_IdDetalleSolicitud;
              DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_CAB(Lr_InfoProcesoMasivoCabCoRad, Ln_IdProcesoMasivoCabCoRad, 
                                                                                        Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN 
                RAISE Le_Exception;
              END IF;

              Lr_InfoDetalleSolHistorial                        := NULL;
              Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
              Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Ln_IdDetalleSolicitud;
              Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoPorEjecutar;
              Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se crea el proceso masivo de corte de Cobre/Radio #' 
                                                                   || Ln_IdProcesoMasivoCabCoRad || ' asociado a esta solicitud';
              Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrCreacion;
              Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
              Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
              DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;

            END IF;
            Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID := Ln_IdProcesoMasivoCabCoRad;
            Ln_ContadorPorLoteUmCoRad   := Ln_ContadorPorLoteUmCoRad+1;
          END IF;
          Lr_InfoProcesoMasivoDet.PUNTO_ID              := Lr_RegPuntosCorteMasivo.ID_PUNTO;
          Lr_InfoProcesoMasivoDet.ESTADO                := Lv_EstadoPorEjecutar;
          Lr_InfoProcesoMasivoDet.FE_CREACION           := SYSDATE;
          Lr_InfoProcesoMasivoDet.USR_CREACION          := Lv_UsrCreacion;
          Lr_InfoProcesoMasivoDet.IP_CREACION           := Lv_IpCreacion;
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_DET(Lr_InfoProcesoMasivoDet, Ln_IdProcesoMasivoDet, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN 
            RAISE Le_Exception;
          END IF;
        ELSE
          Lr_InfoProcesoMasivoDet := NULL;
          IF Ln_IdProcesoMasivoCabErrorUm IS NULL THEN 
            Lr_InfoProcesoMasivoCabErrorUm                          := NULL;
            Lr_InfoProcesoMasivoCabErrorUm.TIPO_PROCESO             := Lv_TipoProceso;
            Lr_InfoProcesoMasivoCabErrorUm.FECHA_EMISION_FACTURA    := TO_DATE(Lv_FechaCreacionDoc,'YYYY-MM-DD');
            Lr_InfoProcesoMasivoCabErrorUm.FACTURAS_RECURRENTES     := Lv_NumDocsAbiertos;
            Lr_InfoProcesoMasivoCabErrorUm.VALOR_DEUDA              := NVL(Lv_ValorMontoCartera, Ln_ValorMinMontoCartera);
            Lr_InfoProcesoMasivoCabErrorUm.IDS_BANCOS_TARJETAS      := Lv_CampoPmCabIdsBancos;
            Lr_InfoProcesoMasivoCabErrorUm.IDS_OFICINAS             := Lv_IdsOficinas;
            Lr_InfoProcesoMasivoCabErrorUm.EMPRESA_ID               := Ln_IdEmpresaUmFo;
            Lr_InfoProcesoMasivoCabErrorUm.ESTADO                   := 'Finalizada';
            Lr_InfoProcesoMasivoCabErrorUm.FE_CREACION              := SYSDATE;
            Lr_InfoProcesoMasivoCabErrorUm.USR_CREACION             := Lv_UsrCreacion;
            Lr_InfoProcesoMasivoCabErrorUm.IP_CREACION              := Lv_IpCreacion;
            Lr_InfoProcesoMasivoCabErrorUm.SOLICITUD_ID             := Ln_IdDetalleSolicitud;
            DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_CAB(Lr_InfoProcesoMasivoCabErrorUm, Ln_IdProcesoMasivoCabErrorUm, 
                                                                                      Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN 
              RAISE Le_Exception;
            END IF;

            Lr_InfoDetalleSolHistorial                        := NULL;
            Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Ln_IdDetalleSolicitud;
            Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoPorEjecutar;
            Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se crea y finaliza el proceso masivo de corte sin �ltima milla especificada #' 
                                                                 || Ln_IdProcesoMasivoCabErrorUm || ' asociado a esta solicitud';
            Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrCreacion;
            Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
            DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          END IF;
          Ln_ContadorPorLoteUmError                     := Ln_ContadorPorLoteUmError+1;
          Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID := Ln_IdProcesoMasivoCabErrorUm;
          Lr_InfoProcesoMasivoDet.PUNTO_ID              := Lr_RegPuntosCorteMasivo.ID_PUNTO;
          Lr_InfoProcesoMasivoDet.ESTADO                := 'SinEjecutar';
          Lr_InfoProcesoMasivoDet.FE_CREACION           := SYSDATE;
          Lr_InfoProcesoMasivoDet.USR_CREACION          := Lv_UsrCreacion;
          Lr_InfoProcesoMasivoDet.IP_CREACION           := Lv_IpCreacion;
          Lr_InfoProcesoMasivoDet.OBSERVACION           := 'Error de data - No se ha podido obtener la �ltima milla asociada al servicio de Internet';
          DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_DET(Lr_InfoProcesoMasivoDet, Ln_IdProcesoMasivoDet, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN 
            RAISE Le_Exception;
          END IF;
        END IF;
        Ln_IndxPuntosCorteMasivo := Lt_TPuntosCorteMasivo.NEXT(Ln_IndxPuntosCorteMasivo);
      END LOOP;
      COMMIT;
      IF Ln_IdProcesoMasivoCabFo IS NOT NULL AND Ln_ContadorPorLoteUmFo IS NOT NULL THEN
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
        SET CANTIDAD_PUNTOS = Ln_ContadorPorLoteUmFo
        WHERE ID_PROCESO_MASIVO_CAB = Ln_IdProcesoMasivoCabFo;
        Lr_InfoDetalleSolicitudCaract                      := NULL;
        Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractIdPmCabFo;
        Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Ln_IdDetalleSolicitud;
        Lr_InfoDetalleSolicitudCaract.VALOR                := Ln_IdProcesoMasivoCabFo;
        Lr_InfoDetalleSolicitudCaract.ESTADO               := Lv_EstadoPorEjecutar;
        Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrCreacion;
        DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
        IF Lv_MsjError IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
        COMMIT;
      END IF;
      IF Ln_IdProcesoMasivoCabCoRad IS NOT NULL AND Ln_ContadorPorLoteUmCoRad IS NOT NULL THEN
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
        SET CANTIDAD_PUNTOS = Ln_ContadorPorLoteUmCoRad
        WHERE ID_PROCESO_MASIVO_CAB = Ln_IdProcesoMasivoCabCoRad;
        Lr_InfoDetalleSolicitudCaract                      := NULL;
        Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractIdPmCabCoRad;
        Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Ln_IdDetalleSolicitud;
        Lr_InfoDetalleSolicitudCaract.VALOR                := Ln_IdProcesoMasivoCabCoRad;
        Lr_InfoDetalleSolicitudCaract.ESTADO               := Lv_EstadoPorEjecutar;
        Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrCreacion;
        DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
        IF Lv_MsjError IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
        COMMIT;
      END IF;
      IF Ln_IdProcesoMasivoCabErrorUm IS NOT NULL AND Ln_ContadorPorLoteUmError IS NOT NULL THEN
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
        SET CANTIDAD_PUNTOS = Ln_ContadorPorLoteUmError
        WHERE ID_PROCESO_MASIVO_CAB = Ln_IdProcesoMasivoCabErrorUm;
        Lr_InfoDetalleSolicitudCaract                      := NULL;
        Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractIdPmCabErrorUm;
        Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Ln_IdDetalleSolicitud;
        Lr_InfoDetalleSolicitudCaract.VALOR                := Ln_IdProcesoMasivoCabErrorUm;
        Lr_InfoDetalleSolicitudCaract.ESTADO               := 'Finalizada';
        Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrCreacion;
        DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
        IF Lv_MsjError IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
        COMMIT;
      END IF;
      EXIT
    WHEN Lrf_PuntosCorteMasivo%NOTFOUND;
    END LOOP;
    CLOSE Lrf_PuntosCorteMasivo;
    Pv_Status               := 'OK';
    Pn_IdSolCortePorLotes   := Ln_IdDetalleSolicitud;
    IF Ln_IdDetalleSolicitud IS NOT NULL AND Lv_ValorNuevoProcesamiento IS NOT NULL AND Lv_ValorNuevoProcesamiento = 'SI' THEN
      UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
      SET DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO = Lv_EstadoPendiente
      WHERE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.id_proceso_masivo_det IN
        (SELECT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.id_proceso_masivo_det
        FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB,
          DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
        WHERE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.PROCESO_MASIVO_CAB_ID = DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB
        AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO                = Lv_EstadoPorEjecutar
        AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.SOLICITUD_ID          = Ln_IdDetalleSolicitud
        AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO        = Lv_TipoProceso
        AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO                = Lv_EstadoPorEjecutar
        );

      UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      SET DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO = Lv_EstadoPendiente
      WHERE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO = Lv_TipoProceso
      AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO         = Lv_EstadoPorEjecutar
      AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.SOLICITUD_ID   = Ln_IdDetalleSolicitud ;
      COMMIT;
    END IF;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := Lv_MsjError;
    Pn_IdSolCortePorLotes   := NULL;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_CREA_CORTE_MASIVO_X_LOTES',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := 'No se han podido crear los registros de todos los logines para el corte masivo';
    Pn_IdSolCortePorLotes   := NULL;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_CREA_CORTE_MASIVO_X_LOTES',
                                          'Error al crear los registros de todos los logines para el corte masivo - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CREA_CORTE_MASIVO_X_LOTES;

  PROCEDURE P_EJECUTA_CORTE_MASIVO_X_LOTES(    
    Pv_Status   OUT VARCHAR2,
    Pv_MsjError OUT VARCHAR2)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_DescripcionCaractIdPmFo      VARCHAR2(25) := 'ID_PROCESO_MASIVO_CAB_FO';
    Lv_DescripcionSolCortePorLotes  VARCHAR2(33) := 'SOLICITUD CORTE MASIVO POR LOTES';
    Lv_ParamCabNombreParametro      VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ParamDetValor1CorteMasivo    VARCHAR2(13) := 'CORTE_MASIVO';
    Lv_ParamDetValor2PorEjecutar    VARCHAR2(34) := 'FILTROS_REGISTROS_PM_POR_EJECUTAR';
    Lv_ParamDetValor2EnEjecucion    VARCHAR2(34) := 'FILTROS_REGISTROS_PM_EN_EJECUCION';
    Lv_ParamDetValor2VerifFin       VARCHAR2(43) := 'FILTROS_REGISTROS_PM_VERIFICA_FINALIZACION';
    Lv_CaractEnvioReporte           VARCHAR2(14) := 'ENVIO_REPORTE';
    Ln_IdCaractEnvioReporte         DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lv_TipoCaract                   VARCHAR2(7)  := 'TECNICA';
    Lv_ParamDetEstadosSol           VARCHAR2(42) := 'ESTADOS_VALIDADOS_INFO_DETALLE_SOLICITUD';
    Lv_ParamDetEstadosSolCaract     VARCHAR2(43) := 'ESTADOS_VALIDADOS_INFO_DETALLE_SOL_CARACT';
    Lv_ParamDetEstadosPmCab         VARCHAR2(43) := 'ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_CAB';
    Lv_ParamDetEstadosPmDet         VARCHAR2(43) := 'ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_DET';
    Lv_ParamEstadosSolCaractEjec    VARCHAR2(43) := 'ESTADOS_INFO_DETALLE_SOL_CARACT_EJECUTADOS';
    Lv_ParamEstadosSolCaractTodos   VARCHAR2(38) := 'ESTADOS_INFO_DETALLE_SOL_CARACT_TODOS';
    Lv_EstadoEjecutada              VARCHAR2(10) := 'Ejecutada';
    Lv_EstadoPorEjecutar            VARCHAR2(11) := 'PorEjecutar';
    Lv_EstadoEnEjecucion            VARCHAR2(11) := 'EnEjecucion';
    Lv_EstadoPendiente              VARCHAR2(9) := 'Pendiente';
    Lv_TipoProcesoPmCab             VARCHAR2(13) := 'CortarCliente';
    Lv_IpCreacion                   VARCHAR2(20) :=  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1');
    Lr_InfoDetalleSolicitudCaract   DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
    Ln_IdSolCortePorEjecutar        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
    Ln_IdSolCaractPmCabPorEjecutar  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE;
    Ln_IdPmCabCortePorEjecutar      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdSolCorteEnEjecucion        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
    Ln_IdSolCorteVerifFin           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
    Ln_IdSolCaractPmCabVerifFin     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE;
    Ln_IdPmCabCorteVerifFin         DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_NumPuntosProcesPmVerifFin    NUMBER;
    Ln_NumPuntosTotalPmVerifFin     NUMBER;
    Ln_NumPmCabEjecutadosPorSol     NUMBER;
    Ln_NumPmCabTotalPorSol          NUMBER;
    Lv_VerificaProcesoPorEjecutar   VARCHAR2(2) := 'NO';
    Lr_InfoDetalleSolHistorial      DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lv_UsrEjecucion                 VARCHAR2(15) := 'corteMasivoLote';
    Lv_MsjError                     VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
    CURSOR Lc_GetInfoProcesoMasivoCorte(Cv_ParamDetValor2Filtros DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT *
      FROM
      (
        SELECT DISTINCT SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD, SOL_CARACT_ID_PM_CAB_FO.ID_SOLICITUD_CARACTERISTICA,
        PM_CAB.ID_PROCESO_MASIVO_CAB, PM_CAB.CANTIDAD_PUNTOS, COUNT(PM_DET.ID_PROCESO_MASIVO_DET) AS NUM_REGISTROS_PM_CAB
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
        ON TIPO_SOL.ID_TIPO_SOLICITUD = SOL_CORTE_MASIVO_POR_LOTES.TIPO_SOLICITUD_ID
        INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB_FO
        ON SOL_CARACT_ID_PM_CAB_FO.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB_FO
        ON CARACT_ID_PM_CAB_FO.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB_FO.CARACTERISTICA_ID
        INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
        ON PM_CAB.ID_PROCESO_MASIVO_CAB = COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT_ID_PM_CAB_FO.VALOR,'^\d+')),0)
        INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PM_DET
        ON PM_DET.PROCESO_MASIVO_CAB_ID = PM_CAB.ID_PROCESO_MASIVO_CAB   
        WHERE TIPO_SOL.DESCRIPCION_SOLICITUD = Lv_DescripcionSolCortePorLotes
        AND TIPO_SOL.ESTADO = Lv_EstadoActivo
        AND CARACT_ID_PM_CAB_FO.DESCRIPCION_CARACTERISTICA = Lv_DescripcionCaractIdPmFo
        AND CARACT_ID_PM_CAB_FO.ESTADO = Lv_EstadoActivo
        AND SOL_CORTE_MASIVO_POR_LOTES.ESTADO IN (
          SELECT PARAM_DET.VALOR4
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
          ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
          WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
          AND PARAM_CAB.ESTADO = Lv_EstadoActivo
          AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
          AND PARAM_DET.VALOR2 = Cv_ParamDetValor2Filtros
          AND PARAM_DET.VALOR3 = Lv_ParamDetEstadosSol
          AND PARAM_DET.ESTADO = Lv_EstadoActivo
        )
        AND SOL_CARACT_ID_PM_CAB_FO.ESTADO IN (
          SELECT PARAM_DET.VALOR4
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
          ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
          WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
          AND PARAM_CAB.ESTADO = Lv_EstadoActivo
          AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
          AND PARAM_DET.VALOR2 = Cv_ParamDetValor2Filtros
          AND PARAM_DET.VALOR3 = Lv_ParamDetEstadosSolCaract
          AND PARAM_DET.ESTADO = Lv_EstadoActivo
        )
        AND PM_CAB.ESTADO IN (
          SELECT PARAM_DET.VALOR4
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
          ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
          WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
          AND PARAM_CAB.ESTADO = Lv_EstadoActivo
          AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
          AND PARAM_DET.VALOR2 = Cv_ParamDetValor2Filtros
          AND PARAM_DET.VALOR3 = Lv_ParamDetEstadosPmCab
          AND PARAM_DET.ESTADO = Lv_EstadoActivo
        )
        AND PM_CAB.TIPO_PROCESO = Lv_TipoProcesoPmCab
        AND PM_DET.ESTADO IN (
          SELECT PARAM_DET.VALOR4
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
          ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
          WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
          AND PARAM_CAB.ESTADO = Lv_EstadoActivo
          AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
          AND PARAM_DET.VALOR2 = Cv_ParamDetValor2Filtros
          AND PARAM_DET.VALOR3 = Lv_ParamDetEstadosPmDet
          AND PARAM_DET.ESTADO = Lv_EstadoActivo
        )
        GROUP BY SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD, SOL_CARACT_ID_PM_CAB_FO.ID_SOLICITUD_CARACTERISTICA, 
                 PM_CAB.ID_PROCESO_MASIVO_CAB, PM_CAB.CANTIDAD_PUNTOS
        ORDER BY SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD ASC
      )
      WHERE ROWNUM = 1;

    CURSOR Lc_GetNumPmCabPorSolicitud(  Cn_IdSolicitudCortePorLote  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                        Cv_ParamDetEstadosSolCaract DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT COUNT(SOL_CARACT_ID_PM_CAB_FO.ID_SOLICITUD_CARACTERISTICA) AS NUM_PM_CAB_POR_SOLICITUD
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB_FO
      ON SOL_CARACT_ID_PM_CAB_FO.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB_FO
      ON CARACT_ID_PM_CAB_FO.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB_FO.CARACTERISTICA_ID
      WHERE SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD = Cn_IdSolicitudCortePorLote
      AND SOL_CARACT_ID_PM_CAB_FO.ESTADO IN (
        SELECT PARAM_DET.VALOR3
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
        WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
        AND PARAM_CAB.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
        AND PARAM_DET.VALOR2 = Cv_ParamDetEstadosSolCaract
        AND PARAM_DET.ESTADO = Lv_EstadoActivo
      )
      AND CARACT_ID_PM_CAB_FO.DESCRIPCION_CARACTERISTICA = Lv_DescripcionCaractIdPmFo
      AND CARACT_ID_PM_CAB_FO.ESTADO = Lv_EstadoActivo;
    Lr_RegGetInfoPmCorte Lc_GetInfoProcesoMasivoCorte%ROWTYPE;

    CURSOR Lc_GetIdCaracteristica(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT CARACTERISTICA.ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA
      WHERE CARACTERISTICA.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND CARACTERISTICA.ESTADO                       = Lv_EstadoActivo
      AND CARACTERISTICA.TIPO                         = Lv_TipoCaract
      AND ROWNUM                                      = 1;
  BEGIN
    /*
     * Se verifica si existe alg�n proceso ejecutado que deba finalizarse a nivel de solicitud
     * FILTROS_REGISTROS_PM_VERIFICA_FINALIZACION
     * ESTADOS_VALIDADOS_INFO_DETALLE_SOLICITUD: EnEjecucion
     * ESTADOS_VALIDADOS_INFO_DETALLE_SOL_CARACT: EnEjecucion
     * ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_CAB: Pendiente, Finalizada
     * ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_DET: In-Corte, Fallo
     */
    Lr_RegGetInfoPmCorte := NULL;
    OPEN Lc_GetInfoProcesoMasivoCorte(Lv_ParamDetValor2VerifFin);
    FETCH Lc_GetInfoProcesoMasivoCorte INTO Lr_RegGetInfoPmCorte;
    CLOSE Lc_GetInfoProcesoMasivoCorte;
    Ln_IdSolCorteVerifFin           := Lr_RegGetInfoPmCorte.ID_DETALLE_SOLICITUD;
    Ln_IdSolCaractPmCabVerifFin     := Lr_RegGetInfoPmCorte.ID_SOLICITUD_CARACTERISTICA;
    Ln_IdPmCabCorteVerifFin         := Lr_RegGetInfoPmCorte.ID_PROCESO_MASIVO_CAB;
    Ln_NumPuntosProcesPmVerifFin    := Lr_RegGetInfoPmCorte.NUM_REGISTROS_PM_CAB;
    Ln_NumPuntosTotalPmVerifFin     := Lr_RegGetInfoPmCorte.CANTIDAD_PUNTOS;
    IF Ln_IdSolCorteVerifFin IS NOT NULL AND Ln_IdSolCaractPmCabVerifFin IS NOT NULL AND Ln_IdPmCabCorteVerifFin IS NOT NULL THEN
      --Si existe un proceso que contenga detalles ya ejecutados, se verificar� si se han ejecutado todos los detalles asociados a dicho proceso
      IF Ln_NumPuntosProcesPmVerifFin = Ln_NumPuntosTotalPmVerifFin THEN
        --Se actualiza el estado de la caracter�stica atada al proceso que ya ejecut� todos los registros  
        UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
        SET ESTADO = Lv_EstadoEjecutada,
        USR_ULT_MOD = Lv_UsrEjecucion,
        FE_ULT_MOD = SYSDATE
        WHERE ID_SOLICITUD_CARACTERISTICA = Ln_IdSolCaractPmCabVerifFin
        AND ESTADO <> Lv_EstadoEjecutada;
        IF SQL%ROWCOUNT = 1 THEN
          --Se crea historial de la solicitud indicando que se ha culminado la ejecuci�n de todos los detalles de un proceso masivo
          Lr_InfoDetalleSolHistorial                        := NULL;
          Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
          Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Ln_IdSolCorteVerifFin;
          Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoEnEjecucion;
          Lr_InfoDetalleSolHistorial.OBSERVACION            := 'El proceso masivo de corte de Fibra �ptica #'|| Ln_IdPmCabCorteVerifFin
                                                               || ' ha ejecutado todos sus detalles asociados';
          Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrEjecucion;
          Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
          Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
          DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
        END IF;

        --Se verifica si dicha solicitud tiene todos los procesos ejecutados
        OPEN Lc_GetNumPmCabPorSolicitud(Ln_IdSolCorteVerifFin, Lv_ParamEstadosSolCaractEjec);
        FETCH Lc_GetNumPmCabPorSolicitud INTO Ln_NumPmCabEjecutadosPorSol;
        CLOSE Lc_GetNumPmCabPorSolicitud;

        OPEN Lc_GetNumPmCabPorSolicitud(Ln_IdSolCorteVerifFin, Lv_ParamEstadosSolCaractTodos);
        FETCH Lc_GetNumPmCabPorSolicitud INTO Ln_NumPmCabTotalPorSol;
        CLOSE Lc_GetNumPmCabPorSolicitud;

        IF Ln_NumPmCabEjecutadosPorSol = Ln_NumPmCabTotalPorSol THEN
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
          SET ESTADO = Lv_EstadoEjecutada
          WHERE ID_DETALLE_SOLICITUD = Ln_IdSolCorteVerifFin
          AND ESTADO <> Lv_EstadoEjecutada;
          IF SQL%ROWCOUNT = 1 THEN
            Lr_InfoDetalleSolHistorial                        := NULL;
            Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Ln_IdSolCorteVerifFin;
            Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoEjecutada;
            Lr_InfoDetalleSolHistorial.OBSERVACION            := 'La solicitud ha ejecutado todos los procesos masivos de corte asociados';
            Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrEjecucion;
            Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
            DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;

            --Se crea una caracter�stica para marcar las solicitudes que se tomar�n en cuenta para enviar el reporte con todos los procesos ejecutados
            OPEN Lc_GetIdCaracteristica(Lv_CaractEnvioReporte);
            FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractEnvioReporte;
            CLOSE Lc_GetIdCaracteristica;
            IF Ln_IdCaractEnvioReporte IS NULL THEN
              Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica para enviar el reporte';
              RAISE Le_Exception;
            END IF;

            Lr_InfoDetalleSolicitudCaract                      := NULL;
            Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractEnvioReporte;
            Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Ln_IdSolCorteVerifFin;
            Lr_InfoDetalleSolicitudCaract.VALOR                := 'SI';
            Lr_InfoDetalleSolicitudCaract.ESTADO               := Lv_EstadoPendiente;
            Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrEjecucion;
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          END IF;
        END IF;
        Lv_VerificaProcesoPorEjecutar := 'SI';
      END IF;
    ELSE
      /*
       * Se verifica si la solicitud tiene otros procesos a�n por procesar.
       * FILTROS_REGISTROS_PM_EN_EJECUCION
       * ESTADOS_VALIDADOS_INFO_DETALLE_SOLICITUD: EnEjecucion
       * ESTADOS_VALIDADOS_INFO_DETALLE_SOL_CARACT: EnEjecucion
       * ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_CAB: Pendiente
       * ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_DET: Pendiente, In-Corte, Fallo
       */
      Lr_RegGetInfoPmCorte := NULL;
      OPEN Lc_GetInfoProcesoMasivoCorte(Lv_ParamDetValor2EnEjecucion);
      FETCH Lc_GetInfoProcesoMasivoCorte INTO Lr_RegGetInfoPmCorte;
      CLOSE Lc_GetInfoProcesoMasivoCorte;
      Ln_IdSolCorteEnEjecucion := Lr_RegGetInfoPmCorte.ID_DETALLE_SOLICITUD;
      IF Ln_IdSolCorteEnEjecucion IS NULL THEN 
        Lv_VerificaProcesoPorEjecutar := 'SI';
      END IF;
    END IF;
    
    IF Lv_VerificaProcesoPorEjecutar = 'SI' THEN
      /*
       * Se verifica si existen otros procesos a�n por procesar.
       * FILTROS_REGISTROS_PM_POR_EJECUTAR
       * ESTADOS_VALIDADOS_INFO_DETALLE_SOLICITUD: PorEjecutar, EnEjecucion
       * ESTADOS_VALIDADOS_INFO_DETALLE_SOL_CARACT: PorEjecutar
       * ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_CAB: PorEjecutar
       * ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_DET: PorEjecutar
       */
      Lr_RegGetInfoPmCorte := NULL;
      OPEN Lc_GetInfoProcesoMasivoCorte(Lv_ParamDetValor2PorEjecutar);
      FETCH Lc_GetInfoProcesoMasivoCorte INTO Lr_RegGetInfoPmCorte;
      CLOSE Lc_GetInfoProcesoMasivoCorte;
      Ln_IdSolCortePorEjecutar        := Lr_RegGetInfoPmCorte.ID_DETALLE_SOLICITUD;
      Ln_IdSolCaractPmCabPorEjecutar  := Lr_RegGetInfoPmCorte.ID_SOLICITUD_CARACTERISTICA;
      Ln_IdPmCabCortePorEjecutar      := Lr_RegGetInfoPmCorte.ID_PROCESO_MASIVO_CAB;

      IF Ln_IdSolCortePorEjecutar IS NOT NULL AND Ln_IdSolCaractPmCabPorEjecutar IS NOT NULL AND Ln_IdPmCabCortePorEjecutar IS NOT NULL THEN          
        --Se habilita los detalles del pr�ximo proceso para que se ejecute el corte masivo
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
        SET ESTADO = Lv_EstadoPendiente,
        USR_ULT_MOD = Lv_UsrEjecucion,
        FE_ULT_MOD = SYSDATE
        WHERE PROCESO_MASIVO_CAB_ID = Ln_IdPmCabCortePorEjecutar
        AND ESTADO = Lv_EstadoPorEjecutar;

        IF SQL%ROWCOUNT > 0 THEN
          --Se habilita el pr�ximo proceso 
          UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
          SET ESTADO = Lv_EstadoPendiente,
          USR_ULT_MOD = Lv_UsrEjecucion,
          FE_ULT_MOD = SYSDATE
          WHERE ID_PROCESO_MASIVO_CAB = Ln_IdPmCabCortePorEjecutar;

          --Se actualiza el estado de la caracter�stica de la solicitud asociada al proceso masivo
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT 
          SET ESTADO = Lv_EstadoEnEjecucion,
          USR_ULT_MOD = Lv_UsrEjecucion,
          FE_ULT_MOD = SYSDATE
          WHERE ID_SOLICITUD_CARACTERISTICA = Ln_IdSolCaractPmCabPorEjecutar;

          --Se actualiza el estado de la solicitud
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
          SET ESTADO = Lv_EstadoEnEjecucion
          WHERE ID_DETALLE_SOLICITUD = Ln_IdSolCortePorEjecutar
          AND ESTADO = Lv_EstadoPorEjecutar;

          Lr_InfoDetalleSolHistorial                        := NULL;
          Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
          Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Ln_IdSolCortePorEjecutar;
          Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoEnEjecucion;
          Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se inicia la ejecuci�n del proceso masivo de corte de Fibra �ptica #' 
                                                             || Ln_IdPmCabCortePorEjecutar;
          Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrEjecucion;
          Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
          Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
          DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
          IF Lv_MsjError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
        END IF;
      END IF;
    END IF;
    COMMIT;
    Pv_Status := 'OK';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_CORTE_MASIVO_X_LOTES',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error inesperado al ejecutar el corte masivo por lotes. Por favor comun�quese con el Dep. de Sistemas!';
    ROLLBACK;
    Lv_MsjError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_EJECUTA_CORTE_MASIVO_X_LOTES', 
                                            'Ocurri� un error general en el proceso, '|| SUBSTR(Lv_MsjError,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_EJECUTA_CORTE_MASIVO_X_LOTES;

  PROCEDURE P_FIN_REGS_CORTE_MASIVO_XLOTES(
    Pv_Status   OUT VARCHAR2,
    Pv_MsjError OUT VARCHAR2)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_DescripcionCaractIdPmFo      VARCHAR2(25) := 'ID_PROCESO_MASIVO_CAB_FO';
    Lv_DescripcionCaractIdPmCoRad   VARCHAR2(29) := 'ID_PROCESO_MASIVO_CAB_CO_RAD';
    Lv_DescripcionSolCortePorLotes  VARCHAR2(33) := 'SOLICITUD CORTE MASIVO POR LOTES';
    Lv_ParamCabNombreParametro      VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ParamDetValor1CorteMasivo    VARCHAR2(13) := 'CORTE_MASIVO';
    Lv_ParamDetValor2DarDeBaja      VARCHAR2(30) := 'FILTROS_REGISTROS_DAR_DE_BAJA';
    Lv_ParamDetValor2DarDeBajaEjec  VARCHAR2(48) := 'FILTROS_REGISTROS_DAR_DE_BAJA_PROCESO_EJECUTADO';
    Lv_ParamDetValor2Reporte        VARCHAR2(30) := 'FILTROS_REGISTROS_REPORTE';
    Lv_ParamDetEstadosSol           VARCHAR2(42) := 'ESTADOS_VALIDADOS_INFO_DETALLE_SOLICITUD';
    Lv_ParamDetEstadosSolCaract     VARCHAR2(43) := 'ESTADOS_VALIDADOS_INFO_DETALLE_SOL_CARACT';
    Lv_ParamDetEstadosPmCab         VARCHAR2(43) := 'ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_CAB';
    Lv_ParamDetEstadosPmDet         VARCHAR2(43) := 'ESTADOS_VALIDADOS_INFO_PROCESO_MASIVO_DET';
    Lr_InfoDetalleSolHistorial      DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_InfoDetalleSolicitudCaract   DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
    Lv_CaractEnvioReporte           VARCHAR2(14) := 'ENVIO_REPORTE';
    Ln_IdCaractEnvioReporte         DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lv_TipoCaract                   VARCHAR2(7)  := 'TECNICA';
    Lv_UsrFinalizaCorteMasivo       VARCHAR2(15) := 'finCorteMasivo';
    Lv_EstadoPendiente              VARCHAR2(9) := 'Pendiente';
    Lv_EstadoEnEjecucion            VARCHAR2(11) := 'EnEjecucion';
    Lv_EstadoFalloReintento         VARCHAR2(15) := 'FalloReintento';
    Lv_EstadoFallo                  VARCHAR2(15) := 'Fallo';
    Lv_IpCreacion                   VARCHAR2(20) :=  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1');
    Lv_MsjError                     VARCHAR2(4000);
    Le_Exception                    EXCEPTION;

    CURSOR Lc_GetIdCaracteristica(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT CARACTERISTICA.ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA
      WHERE CARACTERISTICA.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND CARACTERISTICA.ESTADO                       = Lv_EstadoActivo
      AND CARACTERISTICA.TIPO                         = Lv_TipoCaract
      AND ROWNUM                                      = 1;

    CURSOR Lc_GetRegsCortePmEjecutado(Cv_ParamDetValor2Filtros DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DISTINCT 
      SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD, 
      SOL_CORTE_MASIVO_POR_LOTES.ESTADO AS ESTADO_SOL_CORTE, PARAM_DET_ESTADOS_SOL.VALOR5 AS ESTADO_NUEVO_SOL_CORTE,
      SOL_CARACT_ID_PM_CAB_CORTE.ID_SOLICITUD_CARACTERISTICA, 
      SOL_CARACT_ID_PM_CAB_CORTE.ESTADO AS ESTADO_SOL_CARACT_PM_CAB_CORTE, PARAM_DET_ESTADOS_SOL_CARACT.VALOR5 AS ESTADO_NUEVO_SOL_CARACT,
      PM_CAB.ID_PROCESO_MASIVO_CAB, PM_CAB.ESTADO AS ESTADO_PM_CAB, PARAM_DET_ESTADOS_PM_CAB.VALOR5 AS ESTADO_NUEVO_PM_CAB
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
      ON TIPO_SOL.ID_TIPO_SOLICITUD = SOL_CORTE_MASIVO_POR_LOTES.TIPO_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB_CORTE
      ON SOL_CARACT_ID_PM_CAB_CORTE.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB_CORTE
      ON CARACT_ID_PM_CAB_CORTE.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB_CORTE.CARACTERISTICA_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
      ON PM_CAB.ID_PROCESO_MASIVO_CAB = COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT_ID_PM_CAB_CORTE.VALOR,'^\d+')),0)
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL
      ON PARAM_DET_ESTADOS_SOL.VALOR4 = SOL_CORTE_MASIVO_POR_LOTES.ESTADO
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_SOL
      ON PARAM_CAB_ESTADOS_SOL.ID_PARAMETRO = PARAM_DET_ESTADOS_SOL.PARAMETRO_ID 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL_CARACT
      ON PARAM_DET_ESTADOS_SOL_CARACT.VALOR4 = SOL_CARACT_ID_PM_CAB_CORTE.ESTADO
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_SOL_CARACT
      ON PARAM_CAB_ESTADOS_SOL_CARACT.ID_PARAMETRO = PARAM_DET_ESTADOS_SOL_CARACT.PARAMETRO_ID 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_PM_CAB
      ON PARAM_DET_ESTADOS_PM_CAB.VALOR4 = PM_CAB.ESTADO 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_PM_CAB
      ON PARAM_CAB_ESTADOS_PM_CAB.ID_PARAMETRO = PARAM_DET_ESTADOS_PM_CAB.PARAMETRO_ID 
      WHERE TIPO_SOL.DESCRIPCION_SOLICITUD = Lv_DescripcionSolCortePorLotes
      AND TIPO_SOL.ESTADO = Lv_EstadoActivo
      AND CARACT_ID_PM_CAB_CORTE.DESCRIPCION_CARACTERISTICA IN (Lv_DescripcionCaractIdPmFo, Lv_DescripcionCaractIdPmCoRad)
      AND CARACT_ID_PM_CAB_CORTE.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_SOL.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_SOL.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_SOL.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_SOL.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_SOL.VALOR3 = Lv_ParamDetEstadosSol
      AND PARAM_DET_ESTADOS_SOL.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_SOL_CARACT.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_SOL_CARACT.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_SOL_CARACT.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_SOL_CARACT.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_SOL_CARACT.VALOR3 = Lv_ParamDetEstadosSolCaract
      AND PARAM_DET_ESTADOS_SOL_CARACT.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_PM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_PM_CAB.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_PM_CAB.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_PM_CAB.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_PM_CAB.VALOR3 = Lv_ParamDetEstadosPmCab
      AND PARAM_DET_ESTADOS_PM_CAB.ESTADO = Lv_EstadoActivo
      ORDER BY SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD ASC;

    CURSOR Lc_GetInfoProcesosDarDeBaja(Cv_ParamDetValor2Filtros DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DISTINCT SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD, 
      SOL_CORTE_MASIVO_POR_LOTES.ESTADO AS ESTADO_SOL_CORTE, PARAM_DET_ESTADOS_SOL.VALOR5 AS ESTADO_NUEVO_SOL_CORTE,
      SOL_CARACT_ID_PM_CAB_CORTE.ID_SOLICITUD_CARACTERISTICA, 
      SOL_CARACT_ID_PM_CAB_CORTE.ESTADO AS ESTADO_SOL_CARACT_PM_CAB_CORTE, PARAM_DET_ESTADOS_SOL_CARACT.VALOR5 AS ESTADO_NUEVO_SOL_CARACT,
      PM_CAB.ID_PROCESO_MASIVO_CAB, PM_CAB.ESTADO AS ESTADO_PM_CAB, PARAM_DET_ESTADOS_PM_CAB.VALOR5 AS ESTADO_NUEVO_PM_CAB, 
      PM_DET.ID_PROCESO_MASIVO_DET, PM_DET.ESTADO AS ESTADO_PM_DET, PARAM_DET_ESTADOS_PM_DET.VALOR5 AS ESTADO_NUEVO_PM_DET
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
      ON TIPO_SOL.ID_TIPO_SOLICITUD = SOL_CORTE_MASIVO_POR_LOTES.TIPO_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB_CORTE
      ON SOL_CARACT_ID_PM_CAB_CORTE.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB_CORTE
      ON CARACT_ID_PM_CAB_CORTE.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB_CORTE.CARACTERISTICA_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
      ON PM_CAB.ID_PROCESO_MASIVO_CAB = COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT_ID_PM_CAB_CORTE.VALOR,'^\d+')),0)
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PM_DET
      ON PM_DET.PROCESO_MASIVO_CAB_ID = PM_CAB.ID_PROCESO_MASIVO_CAB   
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL
      ON PARAM_DET_ESTADOS_SOL.VALOR4 = SOL_CORTE_MASIVO_POR_LOTES.ESTADO
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_SOL
      ON PARAM_CAB_ESTADOS_SOL.ID_PARAMETRO = PARAM_DET_ESTADOS_SOL.PARAMETRO_ID 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL_CARACT
      ON PARAM_DET_ESTADOS_SOL_CARACT.VALOR4 = SOL_CARACT_ID_PM_CAB_CORTE.ESTADO
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_SOL_CARACT
      ON PARAM_CAB_ESTADOS_SOL_CARACT.ID_PARAMETRO = PARAM_DET_ESTADOS_SOL_CARACT.PARAMETRO_ID 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_PM_CAB
      ON PARAM_DET_ESTADOS_PM_CAB.VALOR4 = PM_CAB.ESTADO 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_PM_CAB
      ON PARAM_CAB_ESTADOS_PM_CAB.ID_PARAMETRO = PARAM_DET_ESTADOS_PM_CAB.PARAMETRO_ID 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_PM_DET
      ON PARAM_DET_ESTADOS_PM_DET.VALOR4 = PM_DET.ESTADO 
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_ESTADOS_PM_DET
      ON PARAM_CAB_ESTADOS_PM_DET.ID_PARAMETRO = PARAM_DET_ESTADOS_PM_DET.PARAMETRO_ID 
      WHERE TIPO_SOL.DESCRIPCION_SOLICITUD = Lv_DescripcionSolCortePorLotes
      AND TIPO_SOL.ESTADO = Lv_EstadoActivo
      AND CARACT_ID_PM_CAB_CORTE.DESCRIPCION_CARACTERISTICA IN (Lv_DescripcionCaractIdPmFo, Lv_DescripcionCaractIdPmCoRad)
      AND CARACT_ID_PM_CAB_CORTE.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_SOL.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_SOL.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_SOL.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_SOL.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_SOL.VALOR3 = Lv_ParamDetEstadosSol
      AND PARAM_DET_ESTADOS_SOL.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_SOL_CARACT.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_SOL_CARACT.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_SOL_CARACT.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_SOL_CARACT.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_SOL_CARACT.VALOR3 = Lv_ParamDetEstadosSolCaract
      AND PARAM_DET_ESTADOS_SOL_CARACT.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_PM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_PM_CAB.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_PM_CAB.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_PM_CAB.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_PM_CAB.VALOR3 = Lv_ParamDetEstadosPmCab
      AND PARAM_DET_ESTADOS_PM_CAB.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_ESTADOS_PM_DET.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
      AND PARAM_CAB_ESTADOS_PM_DET.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_PM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
      AND PARAM_DET_ESTADOS_PM_DET.VALOR2 = Cv_ParamDetValor2Filtros
      AND PARAM_DET_ESTADOS_PM_DET.VALOR3 = Lv_ParamDetEstadosPmDet
      AND PARAM_DET_ESTADOS_PM_DET.ESTADO = Lv_EstadoActivo
      ORDER BY SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD ASC;

    CURSOR Lc_GetInfoPmCabCorte(Cn_IdProcesoMasivoCab       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                Cv_ParamDetValor2Filtros    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT PM_CAB.ID_PROCESO_MASIVO_CAB, PM_CAB.CANTIDAD_PUNTOS, COUNT(PM_DET.ID_PROCESO_MASIVO_DET) AS NUM_REGISTROS_PM_CAB
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PM_DET
      ON PM_DET.PROCESO_MASIVO_CAB_ID = PM_CAB.ID_PROCESO_MASIVO_CAB  
      WHERE PM_CAB.ID_PROCESO_MASIVO_CAB  = Cn_IdProcesoMasivoCab
      AND PM_DET.ESTADO IN (
        SELECT PARAM_DET.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
        WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
        AND PARAM_CAB.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
        AND PARAM_DET.VALOR2 = Cv_ParamDetValor2Filtros
        AND PARAM_DET.VALOR3 = Lv_ParamDetEstadosPmDet
        AND PARAM_DET.ESTADO = Lv_EstadoActivo
      )
      GROUP BY PM_CAB.ID_PROCESO_MASIVO_CAB, PM_CAB.CANTIDAD_PUNTOS;

    CURSOR Lc_GetNumPmCabFinXSol(   Cn_IdSolicitudCortePorLote  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Cv_ParamDetValor2Filtros DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT COUNT(SOL_CARACT_ID_PM_CAB.ID_SOLICITUD_CARACTERISTICA) AS NUM_PM_CAB_POR_SOLICITUD
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB
      ON SOL_CARACT_ID_PM_CAB.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB
      ON CARACT_ID_PM_CAB.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB.CARACTERISTICA_ID
      WHERE SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD = Cn_IdSolicitudCortePorLote
      AND SOL_CARACT_ID_PM_CAB.ESTADO IN (
        SELECT PARAM_DET.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
        WHERE PARAM_CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
        AND PARAM_CAB.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.VALOR1 = Lv_ParamDetValor1CorteMasivo
        AND PARAM_DET.VALOR2 = Cv_ParamDetValor2Filtros
        AND PARAM_DET.VALOR3 = Lv_ParamDetEstadosSolCaract
        AND PARAM_DET.ESTADO = Lv_EstadoActivo
      )
      AND CARACT_ID_PM_CAB.DESCRIPCION_CARACTERISTICA IN (Lv_DescripcionCaractIdPmFo, Lv_DescripcionCaractIdPmCoRad)
      AND CARACT_ID_PM_CAB.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetNumPmCabTotalXSol( Cn_IdSolicitudCortePorLote  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    IS
      SELECT COUNT(SOL_CARACT_ID_PM_CAB.ID_SOLICITUD_CARACTERISTICA) AS NUM_PM_CAB_POR_SOLICITUD
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB
      ON SOL_CARACT_ID_PM_CAB.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB
      ON CARACT_ID_PM_CAB.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB.CARACTERISTICA_ID
      WHERE SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD = Cn_IdSolicitudCortePorLote
      AND CARACT_ID_PM_CAB.DESCRIPCION_CARACTERISTICA IN (Lv_DescripcionCaractIdPmFo, Lv_DescripcionCaractIdPmCoRad)
      AND CARACT_ID_PM_CAB.ESTADO = Lv_EstadoActivo;

    Lr_RegGetInfoPmCabCorte         Lc_GetInfoPmCabCorte%ROWTYPE;
    Ln_NumPmCabTotalPorSol          NUMBER;
    Ln_NumPmCabFinPorSol            NUMBER;
    Lr_RegInfoCortePmEjecutado      DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoCortePmEjecutado;
    Lt_TInfoCortePmEjecutado        DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoCortePmEjecutado;
    Ln_IndxInfoCortePmEjecutado     NUMBER;
    Lr_RegProcesosCorteDarDeBaja    DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoProcesosCorteDarDeBaja;
    Lt_TProcesosCorteDarDeBaja      DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoProcesosCorteDarDeBaja;
    Ln_IndxProcesosCorteDarDeBaja   NUMBER;
  BEGIN
    OPEN Lc_GetIdCaracteristica(Lv_CaractEnvioReporte);
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaractEnvioReporte;
    CLOSE Lc_GetIdCaracteristica;
    IF Ln_IdCaractEnvioReporte IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el id de la caracter�stica para enviar el reporte';
      RAISE Le_Exception;
    END IF;

    --Se actualizar�n todos los detalles en estado Fallo para que no se vuelva a reintentar desde el proceso masivo de corte
    OPEN Lc_GetRegsCortePmEjecutado(Lv_ParamDetValor2DarDeBajaEjec);
    LOOP
      FETCH Lc_GetRegsCortePmEjecutado BULK COLLECT INTO Lt_TInfoCortePmEjecutado LIMIT 1000;
      Ln_IndxInfoCortePmEjecutado := Lt_TInfoCortePmEjecutado.FIRST;
      WHILE (Ln_IndxInfoCortePmEjecutado IS NOT NULL)
      LOOP
        Lr_RegInfoCortePmEjecutado    := Lt_TInfoCortePmEjecutado(Ln_IndxInfoCortePmEjecutado);
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
        SET ESTADO = Lv_EstadoFalloReintento,
        OBSERVACION = OBSERVACION || ' - Registro pasa de estado ' || Lv_EstadoFallo || ' a ' 
                      ||  Lv_EstadoFalloReintento,
        USR_ULT_MOD = Lv_UsrFinalizaCorteMasivo,
        FE_ULT_MOD = SYSDATE
        WHERE PROCESO_MASIVO_CAB_ID = Lr_RegInfoCortePmEjecutado.ID_PROCESO_MASIVO_CAB
        AND ESTADO = Lv_EstadoFallo;

        IF Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_PM_CAB IS NOT NULL THEN
          UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
          SET ESTADO = Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_PM_CAB,
          USR_ULT_MOD = Lv_UsrFinalizaCorteMasivo,
          FE_ULT_MOD = SYSDATE
          WHERE ID_PROCESO_MASIVO_CAB = Lr_RegInfoCortePmEjecutado.ID_PROCESO_MASIVO_CAB
          AND ESTADO = Lr_RegInfoCortePmEjecutado.ESTADO_PM_CAB;
          IF SQL%ROWCOUNT = 1 THEN
            Lr_InfoDetalleSolHistorial                        := NULL;
            Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_RegInfoCortePmEjecutado.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolHistorial.ESTADO                 := Lr_RegInfoCortePmEjecutado.ESTADO_SOL_CORTE;
            Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se finaliza autom�ticamente la ejecuci�n del proceso masivo #'
                                                                 || Lr_RegInfoCortePmEjecutado.ID_PROCESO_MASIVO_CAB
                                                                 || ' - Registro pasa de estado '  || Lr_RegInfoCortePmEjecutado.ESTADO_PM_CAB
                                                                 || ' a ' || Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_PM_CAB;
            Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrFinalizaCorteMasivo;
            Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
            DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          END IF;
        END IF;

        UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
        SET ESTADO = Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_SOL_CARACT,
        USR_ULT_MOD = Lv_UsrFinalizaCorteMasivo,
        FE_ULT_MOD = SYSDATE
        WHERE ID_SOLICITUD_CARACTERISTICA = Lr_RegInfoCortePmEjecutado.ID_SOLICITUD_CARACTERISTICA
        AND ESTADO = Lr_RegInfoCortePmEjecutado.ESTADO_SOL_CARACT_PM_CAB_CORTE;

        IF Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_SOL_CORTE IS NOT NULL THEN
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
          SET ESTADO = Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_SOL_CORTE
          WHERE ID_DETALLE_SOLICITUD = Lr_RegInfoCortePmEjecutado.ID_DETALLE_SOLICITUD
          AND ESTADO = Lr_RegInfoCortePmEjecutado.ESTADO_SOL_CORTE;
          IF SQL%ROWCOUNT = 1 THEN
            Lr_InfoDetalleSolHistorial                        := NULL;
            Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_RegInfoCortePmEjecutado.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolHistorial.ESTADO                 := Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_SOL_CORTE;
            Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se finaliza la solicitud autom�ticamente'
                                                                 || ' - Registro pasa de estado ' || Lr_RegInfoCortePmEjecutado.ESTADO_SOL_CORTE
                                                                 || ' a ' || Lr_RegInfoCortePmEjecutado.ESTADO_NUEVO_SOL_CORTE;
            Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrFinalizaCorteMasivo;
            Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
            DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          END IF;
        END IF;
        Ln_IndxInfoCortePmEjecutado := Lt_TInfoCortePmEjecutado.NEXT(Ln_IndxInfoCortePmEjecutado);
      END LOOP;
      EXIT WHEN Lc_GetRegsCortePmEjecutado%NOTFOUND;
    END LOOP;
    CLOSE Lc_GetRegsCortePmEjecutado;
    COMMIT;
    
    --Se dar� de baja todos los procesos para proceder a enviar el reporte
    OPEN Lc_GetInfoProcesosDarDeBaja(Lv_ParamDetValor2DarDeBaja);
    LOOP
      FETCH Lc_GetInfoProcesosDarDeBaja BULK COLLECT INTO Lt_TProcesosCorteDarDeBaja LIMIT 1000;
      Ln_IndxProcesosCorteDarDeBaja := Lt_TProcesosCorteDarDeBaja.FIRST;
      WHILE (Ln_IndxProcesosCorteDarDeBaja IS NOT NULL)
      LOOP
        Lr_RegProcesosCorteDarDeBaja    := Lt_TProcesosCorteDarDeBaja(Ln_IndxProcesosCorteDarDeBaja);
        IF Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_PM_DET IS NOT NULL THEN
          UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
          SET ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_PM_DET,
          OBSERVACION = OBSERVACION || ' - Registro pasa de estado ' || Lr_RegProcesosCorteDarDeBaja.ESTADO_PM_DET || ' a ' 
                        ||  Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_PM_DET,
          USR_ULT_MOD = Lv_UsrFinalizaCorteMasivo,
          FE_ULT_MOD = SYSDATE
          WHERE ID_PROCESO_MASIVO_DET = Lr_RegProcesosCorteDarDeBaja.ID_PROCESO_MASIVO_DET
          AND ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_PM_DET;
        END IF;

        UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
        SET ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_SOL_CARACT,
        USR_ULT_MOD = Lv_UsrFinalizaCorteMasivo,
        FE_ULT_MOD = SYSDATE
        WHERE ID_SOLICITUD_CARACTERISTICA = Lr_RegProcesosCorteDarDeBaja.ID_SOLICITUD_CARACTERISTICA
        AND ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_SOL_CARACT_PM_CAB_CORTE;

        Lr_RegGetInfoPmCabCorte := NULL;
        OPEN Lc_GetInfoPmCabCorte(Lr_RegProcesosCorteDarDeBaja.ID_PROCESO_MASIVO_CAB, Lv_ParamDetValor2Reporte);
        FETCH Lc_GetInfoPmCabCorte INTO Lr_RegGetInfoPmCabCorte;
        CLOSE Lc_GetInfoPmCabCorte;

        IF Lr_RegGetInfoPmCabCorte.ID_PROCESO_MASIVO_CAB IS NOT NULL 
          AND Lr_RegGetInfoPmCabCorte.CANTIDAD_PUNTOS = Lr_RegGetInfoPmCabCorte.NUM_REGISTROS_PM_CAB THEN 
          UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
          SET ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_PM_CAB,
          USR_ULT_MOD = Lv_UsrFinalizaCorteMasivo,
          FE_ULT_MOD = SYSDATE
          WHERE ID_PROCESO_MASIVO_CAB = Lr_RegProcesosCorteDarDeBaja.ID_PROCESO_MASIVO_CAB
          AND ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_PM_CAB;
          IF SQL%ROWCOUNT = 1 THEN
            Lr_InfoDetalleSolHistorial                        := NULL;
            Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_RegProcesosCorteDarDeBaja.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolHistorial.ESTADO                 := Lv_EstadoEnEjecucion;
            Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se finaliza autom�ticamente la ejecuci�n del proceso masivo #'
                                                                 || Lr_RegProcesosCorteDarDeBaja.ID_PROCESO_MASIVO_CAB
                                                                 || ' - Registro pasa de estado '  || Lr_RegProcesosCorteDarDeBaja.ESTADO_PM_CAB
                                                                 || ' a ' || Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_PM_CAB;
            Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrFinalizaCorteMasivo;
            Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
            DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
            IF Lv_MsjError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
          END IF;

          OPEN Lc_GetNumPmCabTotalXSol(Lr_RegProcesosCorteDarDeBaja.ID_DETALLE_SOLICITUD);
          FETCH Lc_GetNumPmCabTotalXSol INTO Ln_NumPmCabTotalPorSol;
          CLOSE Lc_GetNumPmCabTotalXSol;

          OPEN Lc_GetNumPmCabFinXSol(Lr_RegProcesosCorteDarDeBaja.ID_DETALLE_SOLICITUD, Lv_ParamDetValor2Reporte);
          FETCH Lc_GetNumPmCabFinXSol INTO Ln_NumPmCabFinPorSol;
          CLOSE Lc_GetNumPmCabFinXSol;
          
          IF Ln_NumPmCabTotalPorSol = Ln_NumPmCabFinPorSol THEN 
            UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
            SET ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_SOL_CORTE
            WHERE ID_DETALLE_SOLICITUD = Lr_RegProcesosCorteDarDeBaja.ID_DETALLE_SOLICITUD
            AND ESTADO = Lr_RegProcesosCorteDarDeBaja.ESTADO_SOL_CORTE;
            IF SQL%ROWCOUNT = 1 THEN
              Lr_InfoDetalleSolHistorial                        := NULL;
              Lr_InfoDetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
              Lr_InfoDetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_RegProcesosCorteDarDeBaja.ID_DETALLE_SOLICITUD;
              Lr_InfoDetalleSolHistorial.ESTADO                 := Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_SOL_CORTE;
              Lr_InfoDetalleSolHistorial.OBSERVACION            := 'Se finaliza la solicitud autom�ticamente'
                                                                   || ' - Registro pasa de estado ' || Lr_RegProcesosCorteDarDeBaja.ESTADO_SOL_CORTE
                                                                   || ' a ' || Lr_RegProcesosCorteDarDeBaja.ESTADO_NUEVO_SOL_CORTE;
              Lr_InfoDetalleSolHistorial.USR_CREACION           := Lv_UsrFinalizaCorteMasivo;
              Lr_InfoDetalleSolHistorial.FE_CREACION            := SYSDATE;
              Lr_InfoDetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
              DB_COMERCIAL.COMEK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHistorial, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;

              Lr_InfoDetalleSolicitudCaract                      := NULL;
              Lr_InfoDetalleSolicitudCaract.CARACTERISTICA_ID    := Ln_IdCaractEnvioReporte;
              Lr_InfoDetalleSolicitudCaract.DETALLE_SOLICITUD_ID := Lr_RegProcesosCorteDarDeBaja.ID_DETALLE_SOLICITUD;
              Lr_InfoDetalleSolicitudCaract.VALOR                := 'SI';
              Lr_InfoDetalleSolicitudCaract.ESTADO               := Lv_EstadoPendiente;
              Lr_InfoDetalleSolicitudCaract.USR_CREACION         := Lv_UsrFinalizaCorteMasivo;
              DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolicitudCaract, Lv_MsjError);
              IF Lv_MsjError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
            END IF;
          END IF;
          COMMIT;
        END IF;
        Ln_IndxProcesosCorteDarDeBaja := Lt_TProcesosCorteDarDeBaja.NEXT(Ln_IndxProcesosCorteDarDeBaja);
      END LOOP;
      EXIT WHEN Lc_GetInfoProcesosDarDeBaja%NOTFOUND;
    END LOOP;
    CLOSE Lc_GetInfoProcesosDarDeBaja;
    Pv_Status   := 'OK';
    COMMIT;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError || ' Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_FIN_REGS_CORTE_MASIVO_XLOTES',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error inesperado al dar de baja los registros sin ejecutar del corte masivo por lotes.'
                   || ' Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    Lv_MsjError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_FIN_REGS_CORTE_MASIVO_XLOTES', 
                                            'Ocurri� un error general en el proceso, '|| SUBSTR(Lv_MsjError,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_FIN_REGS_CORTE_MASIVO_XLOTES;

  PROCEDURE P_REPORTE_CORTE_MASIVO_XLOTES(
    Pn_IdComunicacion       IN DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pn_IdDetalle            IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pn_IdDocumento          OUT NUMBER)
  AS
    Lv_MsjError                     VARCHAR2(4000);
    Lf_ArchivoReporteCorteMasivo    UTL_FILE.FILE_TYPE;
    Lv_FechaArchivo                 VARCHAR2(20)  := TO_CHAR(SYSDATE, 'DD-MM-YYYY-HH24_MI_SS');
    Lv_NombreArchivo                VARCHAR2(500);
    Lv_NombreArchivoCorreoZip       VARCHAR2(500);
    Lv_PrefijoNombreArchivo         VARCHAR2(100) := 'ReporteEjecucionCorteMasivo';
    Lv_Delimitador                  VARCHAR2(1)   := '|';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Ln_IdDocumento                  DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Lv_SubModuloProcesMasivo        VARCHAR2(14) := 'CorteMasivo';
    Lv_NombreParamDirBdArchivosTmp  VARCHAR2(33) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
    Lv_NombreParamUrlMicroNfs       VARCHAR2(33) := 'URL_MICROSERVICIO_NFS';
    Lv_ParamCabNombreParametro      VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_CaractEnvioReporte           VARCHAR2(14) := 'ENVIO_REPORTE';
    Lv_DescripcionCaractIdPmFo      VARCHAR2(25) := 'ID_PROCESO_MASIVO_CAB_FO';
    Lv_DescripcionCaractIdPmCoRad   VARCHAR2(29) := 'ID_PROCESO_MASIVO_CAB_CO_RAD';
    Lv_DescripCaractIdPmErrorUm     VARCHAR2(31) := 'ID_PROCESO_MASIVO_CAB_ERROR_UM';
    Lv_ValorSi                      VARCHAR2(2) := 'SI';
    Lv_EstadoPendiente              VARCHAR2(9) := 'Pendiente';
    Lv_DescripcionSolCortePorLotes  VARCHAR2(33) := 'SOLICITUD CORTE MASIVO POR LOTES';
    Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
    Lv_ProcesoRemitenteYAsunto      VARCHAR2(31) := 'REPORTE_CORTE_MASIVO_POR_LOTES';
    Le_Exception                    EXCEPTION;

    CURSOR Lc_GetValoresParamsGeneral(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.ESTADO = Lv_EstadoActivo; 

    CURSOR Lc_GetConfigNfsCorteMasivo 
    IS
      SELECT TO_CHAR(CODIGO_APP) AS CODIGO_APP, TO_CHAR(CODIGO_PATH) AS CODIGO_PATH 
      FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
      WHERE APLICACION ='TelcosWeb' 
      AND SUBMODULO = Lv_SubModuloProcesMasivo
      AND EMPRESA ='MD';

    CURSOR Lc_GetRegistrosReporteCorte
    IS
      SELECT DISTINCT 
      SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD,
      SOL_CARACT_ENVIO_REPORTE.ID_SOLICITUD_CARACTERISTICA AS ID_SOL_CARACT_ENVIO_REPORTE,
      PM_CAB.ID_PROCESO_MASIVO_CAB AS NUM_PROCESO,
      PM_DET.ID_PROCESO_MASIVO_DET,
      PUNTO.LOGIN,
      NVL(JURISDICCION.NOMBRE_JURISDICCION, '') AS JURISDICCION,
      VISTA_SALDOS.SALDO AS VALOR_DEUDA,
      FORMA_PAGO.DESCRIPCION_FORMA_PAGO AS FORMA_PAGO,
      CUENTAS_TARJETAS.DESCRIPCION_BANCO AS BANCO_TARJETA,
      CUENTAS_TARJETAS.DESCRIPCION_CUENTA AS TIPO_CUENTA_TIPO_TARJETA,
      PM_DET.ESTADO AS ESTADO_CORTE, 
      PM_DET.OBSERVACION AS MOTIVO
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ENVIO_REPORTE
      ON SOL_CARACT_ENVIO_REPORTE.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ENVIO_REPORTE
      ON CARACT_ENVIO_REPORTE.ID_CARACTERISTICA = SOL_CARACT_ENVIO_REPORTE.CARACTERISTICA_ID
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
      ON TIPO_SOL.ID_TIPO_SOLICITUD = SOL_CORTE_MASIVO_POR_LOTES.TIPO_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB_CORTE
      ON SOL_CARACT_ID_PM_CAB_CORTE.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB_CORTE
      ON CARACT_ID_PM_CAB_CORTE.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB_CORTE.CARACTERISTICA_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
      ON PM_CAB.ID_PROCESO_MASIVO_CAB = COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT_ID_PM_CAB_CORTE.VALOR,'^\d+')),0)
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PM_DET
      ON PM_DET.PROCESO_MASIVO_CAB_ID = PM_CAB.ID_PROCESO_MASIVO_CAB 
      INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
      ON PUNTO.ID_PUNTO = PM_DET.PUNTO_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL
      ON PERSONA_EMPRESA_ROL.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
      INNER JOIN DB_COMERCIAL.INFO_CONTRATO CONTRATO
      ON CONTRATO.PERSONA_EMPRESA_ROL_ID = PERSONA_EMPRESA_ROL.ID_PERSONA_ROL
      INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO FORMA_PAGO
      ON FORMA_PAGO.ID_FORMA_PAGO = CONTRATO.FORMA_PAGO_ID
      INNER JOIN DB_COMERCIAL.INFO_PUNTO_SALDO VISTA_SALDOS
      ON VISTA_SALDOS.PUNTO_ID = PUNTO.ID_PUNTO
      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
      ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
      LEFT JOIN
        (SELECT CONTRATO_FORMA_PAGO.CONTRATO_ID,
          BANCO_TIPO_CUENTA.BANCO_ID,
          BANCO.DESCRIPCION_BANCO,
          BANCO_TIPO_CUENTA.TIPO_CUENTA_ID,
          TIPO_CUENTA.DESCRIPCION_CUENTA,
          TIPO_CUENTA.ES_TARJETA
        FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONTRATO_FORMA_PAGO
        INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BANCO_TIPO_CUENTA
        ON BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA = CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID
        LEFT JOIN DB_GENERAL.ADMI_BANCO BANCO
        ON BANCO.ID_BANCO = BANCO_TIPO_CUENTA.BANCO_ID
        LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA TIPO_CUENTA
        ON TIPO_CUENTA.ID_TIPO_CUENTA                      = CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID
        WHERE CONTRATO_FORMA_PAGO.ESTADO                   = Lv_EstadoActivo
        ) CUENTAS_TARJETAS ON CUENTAS_TARJETAS.CONTRATO_ID = CONTRATO.ID_CONTRATO 
      WHERE TIPO_SOL.DESCRIPCION_SOLICITUD = Lv_DescripcionSolCortePorLotes
      AND TIPO_SOL.ESTADO = Lv_EstadoActivo
      AND CONTRATO.ESTADO = Lv_EstadoActivo
      AND SOL_CARACT_ENVIO_REPORTE.ESTADO = Lv_EstadoPendiente
      AND SOL_CARACT_ENVIO_REPORTE.VALOR = Lv_ValorSi
      AND CARACT_ENVIO_REPORTE.DESCRIPCION_CARACTERISTICA = Lv_CaractEnvioReporte
      AND CARACT_ENVIO_REPORTE.ESTADO = Lv_EstadoActivo
      AND CARACT_ID_PM_CAB_CORTE.DESCRIPCION_CARACTERISTICA IN (Lv_DescripcionCaractIdPmFo,Lv_DescripcionCaractIdPmCoRad,Lv_DescripCaractIdPmErrorUm)
      AND CARACT_ID_PM_CAB_CORTE.ESTADO = Lv_EstadoActivo
      ORDER BY SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD ASC;

    CURSOR Lc_GetValorParamServiciosMd( Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DET.VALOR3, DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.VALOR1 = Cv_Valor1
      AND DET.VALOR2 = Cv_Valor2
      AND DET.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetInfoAsignacionTarea(Cn_IdDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
    IS
      SELECT DETALLE.ID_DETALLE, TAREA.NOMBRE_TAREA, PROCESO.NOMBRE_PROCESO,
        TO_CHAR(DET_ASIGNACION.FE_CREACION, 'DD-MON-YYYY HH24:MI') AS FECHA_ASIGNACION,
        CONCAT(DET_ASIGNACION.ASIGNADO_NOMBRE, CONCAT('-',DET_ASIGNACION.REF_ASIGNADO_NOMBRE)) AS ASIGNADO,
        DET_ASIGNACION.REF_ASIGNADO_ID AS ID_PERSONA,
        DET_ASIGNACION.MOTIVO AS OBSERVACION 
      FROM DB_SOPORTE.INFO_DETALLE DETALLE
      INNER JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION DET_ASIGNACION
      ON DET_ASIGNACION.DETALLE_ID = DETALLE.ID_DETALLE
      INNER JOIN DB_SOPORTE.ADMI_TAREA TAREA
      ON TAREA.ID_TAREA = DETALLE.TAREA_ID
      INNER JOIN DB_SOPORTE.ADMI_PROCESO PROCESO
      ON PROCESO.ID_PROCESO = TAREA.PROCESO_ID
      WHERE DETALLE.ID_DETALLE = Cn_IdDetalle;

    CURSOR Lc_GetCorreoAsignacionTarea( Cv_DescripcionFormaContacto DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
                                        Cn_IdPersona                DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE)
    IS
      SELECT DISTINCT IPFC.VALOR
      FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC
      INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
      ON AFC.ID_FORMA_CONTACTO = IPFC.FORMA_CONTACTO_ID 
      WHERE AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_DescripcionFormaContacto
      AND AFC.ESTADO = Lv_EstadoActivo
      AND IPFC.PERSONA_ID = Cn_IdPersona
      AND IPFC.ESTADO = Lv_EstadoActivo
      AND ROWNUM = 1;

    CURSOR Lc_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
    IS
      SELECT PLANTILLA.ID_PLANTILLA, PLANTILLA.PLANTILLA
      FROM DB_COMUNICACION.ADMI_PLANTILLA PLANTILLA 
      WHERE PLANTILLA.CODIGO = Cv_CodigoPlantilla
      AND PLANTILLA.ESTADO = Lv_EstadoActivo;

    Lv_DirectorioBaseDatos          VARCHAR2(100);
    Lv_RutaDirectorioBaseDatos      VARCHAR2(500);
    Lv_CodigoAppCorteMasivo         VARCHAR2(10);
    Lv_CodigoPathCorteMasivo        VARCHAR2(10);
    Lv_UrlMicroServicioNfs          VARCHAR2(500);
    Lv_PathGuardarArchivo           VARCHAR2(4000);
    Lv_ParamsGuardarArchivo         VARCHAR2(4000);
    Lv_RespuestaGuardarArchivo      VARCHAR2(4000);
    Ln_CodeGuardarArchivo           NUMBER;
    Ln_CountArchivosGuardados       NUMBER;
    Lr_RegGetValoresParamsGeneral   Lc_GetValoresParamsGeneral%ROWTYPE;
    Lr_RegGetConfigNfsCorteMasivo   Lc_GetConfigNfsCorteMasivo%ROWTYPE;
    Lr_RegReporteCorteMasivoXLotes  DB_INFRAESTRUCTURA.INKG_TYPES.Lr_ReporteCorteMasivoXLotes;
    Lt_TReporteCorteMasivoXLotes    DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ReporteCorteMasivoXLotes;
    Ln_IndxReptCorteMasivoXLotes    NUMBER;
    Lr_RegGetValorParamServiciosMd  Lc_GetValorParamServiciosMd%ROWTYPE;
    Lr_RegGetPlantillaTareaCorreo   Lc_GetPlantilla%ROWTYPE;
    Lr_RegGetCorreoAsignacionTarea  Lc_GetCorreoAsignacionTarea%ROWTYPE;
    Lr_RegGetInfoAsignacionTarea    Lc_GetInfoAsignacionTarea%ROWTYPE;
    Lr_GetAliasPlantillaCorreo      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lr_GetAliasPlantillaTarea       DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Remitente                    VARCHAR2(100);
    Lv_Asunto                       VARCHAR2(300);
    Lv_PlantillaCorreo              VARCHAR2(32767);
    Lv_PlantillaTareaCorreo         VARCHAR2(32767);
    Lv_Gzip                         VARCHAR2(1000);
  BEGIN
    Lr_RegGetPlantillaTareaCorreo := NULL;
    OPEN Lc_GetPlantilla('TAREACORTEXLOTE');
    FETCH Lc_GetPlantilla INTO Lr_RegGetPlantillaTareaCorreo;
    CLOSE Lc_GetPlantilla;
    Lv_PlantillaTareaCorreo := Lr_RegGetPlantillaTareaCorreo.PLANTILLA;
    IF Lv_PlantillaTareaCorreo IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la plantilla para la asignaci�n de la tarea';
      RAISE Le_Exception;
    END IF;

    Lr_RegGetInfoAsignacionTarea := NULL;
    OPEN Lc_GetInfoAsignacionTarea(Pn_IdDetalle);
    FETCH Lc_GetInfoAsignacionTarea INTO Lr_RegGetInfoAsignacionTarea;
    CLOSE Lc_GetInfoAsignacionTarea;
    IF Lr_RegGetInfoAsignacionTarea.ID_DETALLE IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n de la asignaci�n de la tarea';
      RAISE Le_Exception;
    END IF;

    Lr_GetAliasPlantillaTarea  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('TAREACORTEXLOTE');
    IF Lr_GetAliasPlantillaTarea.ALIAS_CORREOS IS NOT NULL THEN
      Lr_GetAliasPlantillaTarea.ALIAS_CORREOS := REPLACE(Lr_GetAliasPlantillaTarea.ALIAS_CORREOS, ';', ',') || ',';
    END IF;

    Lr_RegGetCorreoAsignacionTarea := NULL;
    OPEN Lc_GetCorreoAsignacionTarea('Correo Electronico', Lr_RegGetInfoAsignacionTarea.ID_PERSONA );
    FETCH Lc_GetCorreoAsignacionTarea INTO Lr_RegGetCorreoAsignacionTarea;
    CLOSE Lc_GetCorreoAsignacionTarea;
    IF Lr_RegGetCorreoAsignacionTarea.VALOR IS NOT NULL THEN
      Lr_GetAliasPlantillaTarea.ALIAS_CORREOS := Lr_GetAliasPlantillaTarea.ALIAS_CORREOS || Lr_RegGetCorreoAsignacionTarea.VALOR || ',';
    END IF;

    IF Lr_GetAliasPlantillaTarea.ALIAS_CORREOS IS NULL THEN 
      Lr_GetAliasPlantillaTarea.ALIAS_CORREOS := Lv_Remitente || ',';
    END IF;

    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{NUMERO_TAREA}}', Pn_IdComunicacion);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{NOMBRE_TAREA}}', Lr_RegGetInfoAsignacionTarea.NOMBRE_TAREA);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{NOMBRE_PROCESO}}', Lr_RegGetInfoAsignacionTarea.NOMBRE_PROCESO);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{FECHA_ASIGNACION}}', Lr_RegGetInfoAsignacionTarea.FECHA_ASIGNACION);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{USUARIO_ASIGNA}}', 'PROCESOS MASIVOS');
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{ASIGNADO}}', Lr_RegGetInfoAsignacionTarea.ASIGNADO);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{OBSERVACION}}', Lr_RegGetInfoAsignacionTarea.OBSERVACION);

    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamDirBdArchivosTmp);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_DirectorioBaseDatos      := Lr_RegGetValoresParamsGeneral.VALOR1;
    IF Lv_DirectorioBaseDatos IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;
    Lv_RutaDirectorioBaseDatos  := Lr_RegGetValoresParamsGeneral.VALOR2;
    IF Lv_RutaDirectorioBaseDatos IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la rura del directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetConfigNfsCorteMasivo;
    FETCH Lc_GetConfigNfsCorteMasivo INTO Lr_RegGetConfigNfsCorteMasivo;
    CLOSE Lc_GetConfigNfsCorteMasivo;
    Lv_CodigoAppCorteMasivo     := Lr_RegGetConfigNfsCorteMasivo.CODIGO_APP;
    Lv_CodigoPathCorteMasivo    := Lr_RegGetConfigNfsCorteMasivo.CODIGO_PATH;
    IF Lv_CodigoAppCorteMasivo IS NULL OR Lv_CodigoPathCorteMasivo IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la configuraci�n de la ruta NFS';
      RAISE Le_Exception;
    END IF;

    Lr_RegGetValoresParamsGeneral := NULL;
    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamUrlMicroNfs);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_UrlMicroServicioNfs  := Lr_RegGetValoresParamsGeneral.VALOR1;
    IF Lv_UrlMicroServicioNfs IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la URL del NFS';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetValorParamServiciosMd(Lv_ParamCabNombreParametro, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_Remitente    := Lr_RegGetValorParamServiciosMd.VALOR3;
    Lv_Asunto       := Lr_RegGetValorParamServiciosMd.VALOR4;
    IF Lv_Remitente IS NULL OR Lv_Asunto IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el remitente y/o el asunto del correo con el archivo adjunto para el corte masivo por lotes';
      RAISE Le_Exception;
    END IF;
    Lv_Asunto := Lv_Asunto || Pn_IdComunicacion;

    Lr_GetAliasPlantillaCorreo  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPTECORTEXLOTES');
    Lv_PlantillaCorreo         := Lr_GetAliasPlantillaCorreo.PLANTILLA;
    IF Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS IS NOT NULL THEN
      Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS := REPLACE(Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS, ';', ',') || ',';
    ELSE 
      Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS := Lv_Remitente || ',';
    END IF;

    IF Lv_PlantillaCorreo IS NULL THEN 
      Lv_MsjError := 'No se ha podido obtener la plantilla de env�o de correo asociada al proceso de corte masivo por lotes';
      RAISE Le_Exception;
    END IF;

    Lv_NombreArchivo                := Lv_PrefijoNombreArchivo || '_' || Lv_FechaArchivo || '.csv';
    Lf_ArchivoReporteCorteMasivo    := UTL_FILE.FOPEN(Lv_DirectorioBaseDatos, Lv_NombreArchivo, 'w', 32767);
    Lf_ArchivoReporteCorteMasivo    := UTL_FILE.FOPEN(Lv_DirectorioBaseDatos, Lv_NombreArchivo, 'w', 32767);
    UTL_FILE.PUT_LINE(Lf_ArchivoReporteCorteMasivo, 'REPORTE DE EJECUCION DEL PROCESO DE CORTE MASIVO' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador);

    UTL_FILE.PUT_LINE(Lf_ArchivoReporteCorteMasivo, 'FECHA DE GENERACION: ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS') || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador);

    UTL_FILE.PUT_LINE(Lf_ArchivoReporteCorteMasivo, ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador ||
                                                    ' ' || Lv_Delimitador);

    UTL_FILE.PUT_LINE(Lf_ArchivoReporteCorteMasivo, 'NO. PROCESO' || Lv_Delimitador ||
                                                    'LOGIN' || Lv_Delimitador ||
                                                    'JURISDICCION' || Lv_Delimitador ||
                                                    'VALOR DEUDA' || Lv_Delimitador ||
                                                    'FORMA PAGO' || Lv_Delimitador ||
                                                    'BANCO/TARJETA' || Lv_Delimitador ||
                                                    'TIPO CUENTA/TIPO TARJETA' || Lv_Delimitador ||
                                                    'ESTADO CORTE' || Lv_Delimitador ||
                                                    'MOTIVO' || Lv_Delimitador);
    OPEN Lc_GetRegistrosReporteCorte;
    LOOP
      FETCH Lc_GetRegistrosReporteCorte BULK COLLECT INTO Lt_TReporteCorteMasivoXLotes LIMIT 1000;
      Ln_IndxReptCorteMasivoXLotes := Lt_TReporteCorteMasivoXLotes.FIRST;
      WHILE (Ln_IndxReptCorteMasivoXLotes IS NOT NULL)
      LOOP
        Lr_RegReporteCorteMasivoXLotes  := Lt_TReporteCorteMasivoXLotes(Ln_IndxReptCorteMasivoXLotes);
        UTL_FILE.PUT_LINE(Lf_ArchivoReporteCorteMasivo, Lr_RegReporteCorteMasivoXLotes.NUM_PROCESO || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.LOGIN || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.JURISDICCION || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.VALOR_DEUDA || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.FORMA_PAGO || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.BANCO_TARJETA || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.TIPO_CUENTA_TIPO_TARJETA || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.ESTADO_CORTE || Lv_Delimitador ||
                                                        Lr_RegReporteCorteMasivoXLotes.MOTIVO || Lv_Delimitador);
        Ln_IndxReptCorteMasivoXLotes    := Lt_TReporteCorteMasivoXLotes.NEXT(Ln_IndxReptCorteMasivoXLotes);
      END LOOP;
      EXIT WHEN Lc_GetRegistrosReporteCorte%NOTFOUND;
    END LOOP;
    CLOSE Lc_GetRegistrosReporteCorte;
    UTL_FILE.FCLOSE(Lf_ArchivoReporteCorteMasivo);

    Lv_ParamsGuardarArchivo := 'URL NFS: ' || Lv_UrlMicroServicioNfs || ', RUTA_DIRECTORIO: ' || Lv_RutaDirectorioBaseDatos 
                                || ', NOMBRE_ARCHIVO: ' || Lv_NombreArchivo || ', CODIGO_APP: ' || Lv_CodigoAppCorteMasivo 
                                || ', CODIGO_PATH: ' || Lv_CodigoPathCorteMasivo;

    Lv_RespuestaGuardarArchivo  := DB_GENERAL.GNRLPCK_UTIL.F_GUARDAR_ARCHIVO_NFS(   Lv_UrlMicroServicioNfs,
                                                                                    Lv_RutaDirectorioBaseDatos || Lv_NombreArchivo,
                                                                                    Lv_NombreArchivo,
                                                                                    NULL,
                                                                                    Lv_CodigoAppCorteMasivo,
                                                                                    Lv_CodigoPathCorteMasivo);

    IF Lv_RespuestaGuardarArchivo IS NULL THEN
      Lv_MsjError   := 'No se ha podido generar el archivo de manera correcta. Por favor consulte al Dep. de Sistemas!';
      RAISE Le_Exception;
    END IF;

    APEX_JSON.PARSE(Lv_RespuestaGuardarArchivo);
    Ln_CodeGuardarArchivo   := APEX_JSON.GET_NUMBER('code');
    IF Ln_CodeGuardarArchivo IS NULL OR Ln_CodeGuardarArchivo <> 200 THEN
      Lv_MsjError := 'Ha ocurrido alg�n error al generar el archivo. Por favor consulte al Dep. de Sistemas!';
      RAISE Le_Exception;
    END IF;

    Ln_CountArchivosGuardados := APEX_JSON.GET_COUNT(p_path => 'data');
    IF Ln_CountArchivosGuardados IS NULL THEN
      Lv_MsjError := 'No se ha generado correctamente la ruta del archivo. Por favor consulte al Dep. de Sistemas!';
      RAISE Le_Exception;
    END IF;

    IF Ln_CountArchivosGuardados <> 1 THEN
      Lv_MsjError := 'Ha ocurrido un error inesperado al generar el archivo. Por favor consulte al Dep. de Sistemas!';
      RAISE Le_Exception;
    END IF;

    FOR i IN 1 .. Ln_CountArchivosGuardados LOOP
      Lv_PathGuardarArchivo := APEX_JSON.GET_VARCHAR2(p_path => 'data[%d].pathFile', p0 => i);
    END LOOP;
 
    IF Lv_PathGuardarArchivo IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la ruta en la que se encuentra el archivo generado. Por favor consulte al Dep. de Sistemas!';
      RAISE Le_Exception;
    END IF;

    Ln_IdDocumento := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
    INSERT
    INTO DB_COMUNICACION.INFO_DOCUMENTO
    (
      ID_DOCUMENTO,
      NOMBRE_DOCUMENTO,
      UBICACION_LOGICA_DOCUMENTO,
      UBICACION_FISICA_DOCUMENTO,
      FECHA_DOCUMENTO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION,
      ESTADO,
      MENSAJE,
      EMPRESA_COD,
      TIPO_DOCUMENTO_ID
    )
    VALUES
    (
      Ln_IdDocumento,
      'Adjunto Tarea',
      Lv_NombreArchivo,
      Lv_PathGuardarArchivo,
      SYSDATE,
      'finalizaCorteMasivo',
      SYSDATE,
      '127.0.0.1',
      'Activo',
      'Documento que genera reporte con clientes del corte masivo por lotes MD',
      '18',
      (SELECT ID_TIPO_DOCUMENTO FROM DB_COMUNICACION.ADMI_TIPO_DOCUMENTO WHERE EXTENSION_TIPO_DOCUMENTO = 'CSV' AND ROWNUM = 1)
    );

    INSERT
    INTO DB_COMUNICACION.INFO_DOCUMENTO_RELACION
    (
      ID_DOCUMENTO_RELACION,
      MODULO,
      ESTADO,
      DETALLE_ID,
      DOCUMENTO_ID,
      USR_CREACION,
      FE_CREACION
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL,
      'SOPORTE',
      Lv_EstadoActivo,
      Pn_IdDetalle,
      Ln_IdDocumento,
      'finalizaCorteMasivo',
      SYSDATE
    );

    Lv_Gzip                     := 'gzip ' || Lv_RutaDirectorioBaseDatos || Lv_NombreArchivo;
    Lv_NombreArchivoCorreoZip   := Lv_NombreArchivo || '.gz';
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_Gzip));

    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS, Lv_Asunto, Lv_PlantillaCorreo, 
                                              Lv_DirectorioBaseDatos, Lv_NombreArchivoCorreoZip);

    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, Lr_GetAliasPlantillaTarea.ALIAS_CORREOS, 
                                              'Nueva Tarea, Actividad #' || Pn_IdComunicacion ||
                                              ' | PROCESO: '|| Lr_RegGetInfoAsignacionTarea.NOMBRE_PROCESO, 
                                              Lv_PlantillaTareaCorreo, Lv_DirectorioBaseDatos, Lv_NombreArchivoCorreoZip);
    UTL_FILE.FREMOVE(Lv_DirectorioBaseDatos, Lv_NombreArchivoCorreoZip);
    Pv_Status       := 'OK';
    Pn_IdDocumento  := Ln_IdDocumento;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError || ' Por favor consulte al Dep. de Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_REPORTE_CORTE_MASIVO_XLOTES',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error inesperado al crear y enviar el reporte de corte masivo por lotes. Por favor consulte al Dep. de Sistemas!';
    Lv_MsjError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_REPORTE_CORTE_MASIVO_XLOTES', 
                                            'Ocurri� un error inesperado en el proceso, '|| SUBSTR(Lv_MsjError,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_REPORTE_CORTE_MASIVO_XLOTES;

  PROCEDURE P_FINALIZA_CORTE_MASIVO_XLOTES(
    Pv_Status   OUT VARCHAR2,
    Pv_MsjError OUT VARCHAR2)
  AS
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lr_RegInfoCreaActividad         DB_SOPORTE.SPKG_TYPES.Lr_InfoCreaActividad;
    Ln_IdComunicacionTarea          DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE;
    Ln_IdDetalleTarea               DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE;
    Ln_IdDocumentoReporte           DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Lv_CaractEnvioReporte           VARCHAR2(14) := 'ENVIO_REPORTE';
    Lv_DescripcionCaractIdPmFo      VARCHAR2(25) := 'ID_PROCESO_MASIVO_CAB_FO';
    Lv_DescripcionCaractIdPmCoRad   VARCHAR2(29) := 'ID_PROCESO_MASIVO_CAB_CO_RAD';
    Lv_DescripCaractIdPmErrorUm     VARCHAR2(31) := 'ID_PROCESO_MASIVO_CAB_ERROR_UM';
    Lv_ValorSi                      VARCHAR2(2) := 'SI';
    Lv_EstadoPendiente              VARCHAR2(9) := 'Pendiente';
    Lv_EstadoFinalizada             VARCHAR2(11) := 'Finalizada';
    Lv_UsrFinalizacion              VARCHAR2(15) := 'finalizaCorteMd';
    Lv_DescripcionSolCortePorLotes  VARCHAR2(33) := 'SOLICITUD CORTE MASIVO POR LOTES';

    CURSOR Lc_GetNumTotalSolsReporteCorte
    IS
      SELECT COUNT(DISTINCT SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD) AS NUM_TOTAL_SOLS_REPORTE
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_CORTE_MASIVO_POR_LOTES
      INNER JOIN  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ENVIO_REPORTE
      ON SOL_CARACT_ENVIO_REPORTE.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ENVIO_REPORTE
      ON CARACT_ENVIO_REPORTE.ID_CARACTERISTICA = SOL_CARACT_ENVIO_REPORTE.CARACTERISTICA_ID
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
      ON TIPO_SOL.ID_TIPO_SOLICITUD = SOL_CORTE_MASIVO_POR_LOTES.TIPO_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT_ID_PM_CAB_CORTE
      ON SOL_CARACT_ID_PM_CAB_CORTE.DETALLE_SOLICITUD_ID = SOL_CORTE_MASIVO_POR_LOTES.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_ID_PM_CAB_CORTE
      ON CARACT_ID_PM_CAB_CORTE.ID_CARACTERISTICA = SOL_CARACT_ID_PM_CAB_CORTE.CARACTERISTICA_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PM_CAB
      ON PM_CAB.ID_PROCESO_MASIVO_CAB = COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT_ID_PM_CAB_CORTE.VALOR,'^\d+')),0)
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PM_DET
      ON PM_DET.PROCESO_MASIVO_CAB_ID = PM_CAB.ID_PROCESO_MASIVO_CAB 
      WHERE TIPO_SOL.DESCRIPCION_SOLICITUD = Lv_DescripcionSolCortePorLotes
      AND TIPO_SOL.ESTADO = Lv_EstadoActivo
      AND SOL_CARACT_ENVIO_REPORTE.ESTADO = Lv_EstadoPendiente
      AND SOL_CARACT_ENVIO_REPORTE.VALOR = Lv_ValorSi
      AND CARACT_ENVIO_REPORTE.DESCRIPCION_CARACTERISTICA = Lv_CaractEnvioReporte
      AND CARACT_ENVIO_REPORTE.ESTADO = Lv_EstadoActivo
      AND CARACT_ID_PM_CAB_CORTE.DESCRIPCION_CARACTERISTICA IN (Lv_DescripcionCaractIdPmFo,Lv_DescripcionCaractIdPmCoRad,Lv_DescripCaractIdPmErrorUm)
      AND CARACT_ID_PM_CAB_CORTE.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetValorParamServiciosMd( Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DET.ID_PARAMETRO_DET, DET.VALOR3, DET.VALOR4, DET.VALOR5, DET.VALOR6, DET.VALOR7, DET.OBSERVACION, DET.EMPRESA_COD
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.VALOR1 = Cv_Valor1
      AND DET.VALOR2 = Cv_Valor2
      AND DET.ESTADO = Lv_EstadoActivo;
    Lr_RegGetParamsCreacionTarea    Lc_GetValorParamServiciosMd%ROWTYPE;
    Lr_RegGetParamsAsignacionTarea  Lc_GetValorParamServiciosMd%ROWTYPE;
    Lr_RegGetNumTotalSolsReporte    Lc_GetNumTotalSolsReporteCorte%ROWTYPE;
    Lv_ParamCabNombreParametro      VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ParamDetValor1CorteMasivo    VARCHAR2(13) := 'CORTE_MASIVO';
    Lv_ParamCreacionTareaReporte    VARCHAR2(30) := 'PARAMS_CREACION_TAREA_REPORTE';
    Lv_ParamAsignacionTareaReporte  VARCHAR2(32) := 'PARAMS_ASIGNACION_TAREA_REPORTE';
    Le_Exception                    EXCEPTION;
  BEGIN
    --Se finalizan todos los registros del proceso masivo de corte por lotes
    DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_FIN_REGS_CORTE_MASIVO_XLOTES(Lv_Status, Lv_MsjError);
    IF Lv_Status = 'ERROR' THEN
      RAISE Le_Exception;
    END IF;
    OPEN Lc_GetNumTotalSolsReporteCorte;
    FETCH Lc_GetNumTotalSolsReporteCorte INTO Lr_RegGetNumTotalSolsReporte;
    CLOSE Lc_GetNumTotalSolsReporteCorte;
    IF Lr_RegGetNumTotalSolsReporte.NUM_TOTAL_SOLS_REPORTE IS NOT NULL AND Lr_RegGetNumTotalSolsReporte.NUM_TOTAL_SOLS_REPORTE > 0 THEN
      OPEN Lc_GetValorParamServiciosMd(Lv_ParamCabNombreParametro, Lv_ParamDetValor1CorteMasivo, Lv_ParamCreacionTareaReporte);
      FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetParamsCreacionTarea;
      CLOSE Lc_GetValorParamServiciosMd;
      IF Lr_RegGetParamsCreacionTarea.ID_PARAMETRO_DET IS NULL THEN
        Lv_MsjError := 'No se ha podido obtener los par�metros configurados para la creaci�n de la tarea para el corte masivo por lotes';
        RAISE Le_Exception;
      END IF;
  
      OPEN Lc_GetValorParamServiciosMd(Lv_ParamCabNombreParametro, Lv_ParamDetValor1CorteMasivo, Lv_ParamAsignacionTareaReporte);
      FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetParamsAsignacionTarea;
      CLOSE Lc_GetValorParamServiciosMd;
      IF Lr_RegGetParamsAsignacionTarea.ID_PARAMETRO_DET IS NULL THEN
        Lv_MsjError := 'No se ha podido obtener los par�metros configurados para la asignaci�n de la tarea para el corte masivo por lotes';
        RAISE Le_Exception;
      END IF;
  
      Lr_RegInfoCreaActividad.DESCRIPCION_ORIGEN              := Lr_RegGetParamsCreacionTarea.VALOR3;
      Lr_RegInfoCreaActividad.NOMBRE_CLASE                    := Lr_RegGetParamsCreacionTarea.VALOR4;
      Lr_RegInfoCreaActividad.NOMBRE_PROCESO                  := Lr_RegGetParamsCreacionTarea.VALOR5;
      Lr_RegInfoCreaActividad.NOMBRE_TAREA                    := Lr_RegGetParamsCreacionTarea.VALOR6;
      Lr_RegInfoCreaActividad.USR_CREACION                    := Lr_RegGetParamsCreacionTarea.VALOR7;
      Lr_RegInfoCreaActividad.OBSERVACION                     := Lr_RegGetParamsCreacionTarea.OBSERVACION;
      Lr_RegInfoCreaActividad.FE_SOLICITADA                   := SYSDATE;
      Lr_RegInfoCreaActividad.COD_EMPRESA_EMPLEADO_ASIGNADO   := Lr_RegGetParamsAsignacionTarea.VALOR3;
      Lr_RegInfoCreaActividad.LOGIN_EMPLEADO_ASIGNADO         := Lr_RegGetParamsAsignacionTarea.VALOR4;
      Lr_RegInfoCreaActividad.NOMBRE_DEPARTAMENTO_CREA_TAREA  := Lr_RegGetParamsAsignacionTarea.VALOR5;
      Lr_RegInfoCreaActividad.NOMBRE_CANTON_CREA_TAREA        := Lr_RegGetParamsAsignacionTarea.VALOR6;
      Lr_RegInfoCreaActividad.REMITENTE_ID_TAREA              := NULL;
      Lr_RegInfoCreaActividad.REMITENTE_NOMBRE_TAREA          := NULL;
      Lr_RegInfoCreaActividad.FECHA_COMUNICACION              := SYSDATE;
      Lr_RegInfoCreaActividad.IP_CREACION                     := '127.0.0.1';
      Lr_RegInfoCreaActividad.COD_EMPRESA                     := Lr_RegGetParamsCreacionTarea.EMPRESA_COD;
  
      --Se crea la tarea
      DB_SOPORTE.SPKG_INFO_TAREA.P_CREA_ACTIVIDAD_AUTOMATICA( Lr_RegInfoCreaActividad,
                                                              Lv_Status, 
                                                              Lv_MsjError, 
                                                              Ln_IdComunicacionTarea,
                                                              Ln_IdDetalleTarea);
      IF Lv_Status = 'ERROR' THEN
        RAISE Le_Exception;
      END IF;
      
      --Se crea el reporte y se lo asocia a la tarea
      DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_REPORTE_CORTE_MASIVO_XLOTES(Ln_IdComunicacionTarea,
                                                                                  Ln_IdDetalleTarea,
                                                                                  Lv_Status, 
                                                                                  Lv_MsjError, 
                                                                                  Ln_IdDocumentoReporte);
      IF Lv_Status = 'ERROR' THEN
        RAISE Le_Exception;
      END IF;

      UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
      SET ESTADO = Lv_EstadoFinalizada,
      VALOR = 'NO',
      USR_ULT_MOD = Lv_UsrFinalizacion,
      FE_ULT_MOD = SYSDATE
      WHERE ESTADO = Lv_EstadoPendiente
      AND CARACTERISTICA_ID = (SELECT ID_CARACTERISTICA
                               FROM DB_COMERCIAL.ADMI_CARACTERISTICA
                               WHERE DESCRIPCION_CARACTERISTICA = Lv_CaractEnvioReporte 
                               AND ESTADO = Lv_EstadoActivo);
      COMMIT;
    END IF;
    Pv_Status := 'OK';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError || ' Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_FINALIZA_CORTE_MASIVO_XLOTES',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error al finalizar el proceso de corte masivo por lotes. Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    Lv_MsjError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_FINALIZA_CORTE_MASIVO_XLOTES', 
                                            'Ocurri� un error inesperado en el proceso, '|| SUBSTR(Lv_MsjError,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_FINALIZA_CORTE_MASIVO_XLOTES;

  PROCEDURE P_FINALIZA_PMS_POR_OPCION(  
    Pn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pv_OpcionEjecutante IN VARCHAR2,
    Pv_CodEmpresa       IN VARCHAR2,
    Pv_PrefijoEmpresa   IN VARCHAR2,
    Pv_Status           OUT VARCHAR2,
    Pv_MsjError         OUT VARCHAR2)
  AS
    Lv_EstadoActivo         VARCHAR2(6) := 'Activo';
    Lv_NombreParametro      VARCHAR2(100);
    Lv_FinalizaPmsPorOpcion VARCHAR2(37) := 'FINALIZA_PROCESOS_MASIVOS_POR_OPCION';
    Lv_Status               VARCHAR2(5);
    Lv_MsjError             VARCHAR2(4000);
    Ln_IndxPmDetDarBaja     NUMBER;
    Lr_RegPmCabDetDarBaja   DB_INFRAESTRUCTURA.INKG_TYPES.Lr_PmCabDetDarBaja;
    Lt_TPmCabDetDarBaja     DB_INFRAESTRUCTURA.INKG_TYPES.Lt_PmCabDetDarBaja;
    Lv_UsrUltMod            VARCHAR2(15) := 'finProcesMasivo';
    
    CURSOR Lc_GetPmDetsDarBaja( Cn_IdPunto              DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Cv_NombreParametro      VARCHAR2,
                                Cv_OpcionFinalizaPms    VARCHAR2,
                                Cv_CodEmpresa           VARCHAR2) 
    IS
      SELECT PMC.ID_PROCESO_MASIVO_CAB, 
      T_PARAMS_FINALIZA_PMS.TIPO_PROCESO, T_PARAMS_FINALIZA_PMS.ESTADO_NUEVO_PM_CAB, 
      PMD.ID_PROCESO_MASIVO_DET, 
      PMD.ESTADO AS ESTADO_ACTUAL_PM_DET, T_PARAMS_FINALIZA_PMS.ESTADO_NUEVO_PM_DET, 
      PMD.OBSERVACION AS OBSERVACION_ACTUAL_PM_DET, T_PARAMS_FINALIZA_PMS.OBSERVACION_NUEVA_PM_DET
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PMC
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PMD
      ON PMD.PROCESO_MASIVO_CAB_ID = PMC.ID_PROCESO_MASIVO_CAB
      INNER JOIN 
      (
        SELECT DISTINCT PARAM_DET.VALOR3 AS TIPO_PROCESO, PARAM_DET.VALOR4 AS ESTADO_ACTUAL_PM_CAB, PARAM_DET.VALOR5 AS ESTADO_NUEVO_PM_CAB,
        PARAM_DET.VALOR6 AS ESTADO_ACTUAL_PM_DET, PARAM_DET.VALOR7 AS ESTADO_NUEVO_PM_DET, PARAM_DET.OBSERVACION AS OBSERVACION_NUEVA_PM_DET
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
        WHERE PARAM_CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND PARAM_CAB.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.VALOR1 = Lv_FinalizaPmsPorOpcion
        AND PARAM_DET.VALOR2 = Cv_OpcionFinalizaPms
        AND PARAM_DET.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.EMPRESA_COD = Cv_CodEmpresa
      ) T_PARAMS_FINALIZA_PMS
      ON T_PARAMS_FINALIZA_PMS.TIPO_PROCESO = PMC.TIPO_PROCESO 
      WHERE T_PARAMS_FINALIZA_PMS.ESTADO_ACTUAL_PM_CAB = PMC.ESTADO
      AND T_PARAMS_FINALIZA_PMS.ESTADO_ACTUAL_PM_DET = PMD.ESTADO
      AND PMC.EMPRESA_ID = Cv_CodEmpresa
      AND PMD.PUNTO_ID = Cn_IdPunto;
      
    CURSOR Lc_GetNumPmDetsXPmCab(   Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                    Cv_NombreParametro      VARCHAR2,
                                    Cv_OpcionFinalizaPms    VARCHAR2,
                                    Cv_CodEmpresa           VARCHAR2)
    IS
      SELECT NVL(COUNT(PMD.ID_PROCESO_MASIVO_DET), 0) AS NUM_PM_DETS_NO_EJECUTADAS
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PMC
      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PMD
      ON PMD.PROCESO_MASIVO_CAB_ID = PMC.ID_PROCESO_MASIVO_CAB
      INNER JOIN 
      (
        SELECT PARAM_DET.VALOR3 AS TIPO_PROCESO, PARAM_DET.VALOR4 AS ESTADO_ACTUAL_PM_CAB, PARAM_DET.VALOR5 AS ESTADO_NUEVO_PM_CAB,
        PARAM_DET.VALOR6 AS ESTADO_ACTUAL_PM_DET, PARAM_DET.VALOR7 AS ESTADO_NUEVO_PM_DET, PARAM_DET.OBSERVACION AS OBSERVACION_NUEVA_PM_DET
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
        WHERE PARAM_CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND PARAM_CAB.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.VALOR1 = Lv_FinalizaPmsPorOpcion
        AND PARAM_DET.VALOR2 = Cv_OpcionFinalizaPms
        AND PARAM_DET.ESTADO = Lv_EstadoActivo
        AND PARAM_DET.EMPRESA_COD = Cv_CodEmpresa
      ) T_PARAMS_FINALIZA_PMS
      ON T_PARAMS_FINALIZA_PMS.TIPO_PROCESO = PMC.TIPO_PROCESO 
      WHERE PMC.ID_PROCESO_MASIVO_CAB = Cn_IdProcesoMasivoCab
      AND T_PARAMS_FINALIZA_PMS.ESTADO_ACTUAL_PM_CAB = PMC.ESTADO
      AND T_PARAMS_FINALIZA_PMS.ESTADO_ACTUAL_PM_DET = PMD.ESTADO
      AND PMC.EMPRESA_ID = Cv_CodEmpresa;
    Lr_RegGetNumPmDetsXPmCab Lc_GetNumPmDetsXPmCab%ROWTYPE;

  BEGIN
    Lv_NombreParametro := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_' || Pv_PrefijoEmpresa;

    OPEN Lc_GetPmDetsDarBaja(Pn_IdPunto, Lv_NombreParametro, Pv_OpcionEjecutante, Pv_CodEmpresa) ;
    LOOP
      FETCH Lc_GetPmDetsDarBaja BULK COLLECT INTO Lt_TPmCabDetDarBaja LIMIT 1000;
      Ln_IndxPmDetDarBaja := Lt_TPmCabDetDarBaja.FIRST;
      WHILE (Ln_IndxPmDetDarBaja IS NOT NULL)
      LOOP
        Lr_RegPmCabDetDarBaja  := Lt_TPmCabDetDarBaja(Ln_IndxPmDetDarBaja);
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
        SET USR_ULT_MOD             = Lv_UsrUltMod,
          FE_ULT_MOD                = SYSDATE,
          ESTADO                    = Lr_RegPmCabDetDarBaja.ESTADO_NUEVO_PM_DET,
          OBSERVACION               = Lr_RegPmCabDetDarBaja.OBSERVACION_ACTUAL_PM_DET || ' - ' 
                                      || Lr_RegPmCabDetDarBaja.OBSERVACION_NUEVA_PM_DET || ' de estado ' || Lr_RegPmCabDetDarBaja.ESTADO_ACTUAL_PM_DET
                                      || ' a ' || Lr_RegPmCabDetDarBaja.ESTADO_NUEVO_PM_DET || '.' 
        WHERE ID_PROCESO_MASIVO_DET = Lr_RegPmCabDetDarBaja.ID_PROCESO_MASIVO_DET;

        OPEN Lc_GetNumPmDetsXPmCab( Lr_RegPmCabDetDarBaja.ID_PROCESO_MASIVO_CAB, Lv_NombreParametro, Pv_OpcionEjecutante, Pv_CodEmpresa);
        FETCH Lc_GetNumPmDetsXPmCab INTO Lr_RegGetNumPmDetsXPmCab;
        CLOSE Lc_GetNumPmDetsXPmCab;
        IF Lr_RegGetNumPmDetsXPmCab.NUM_PM_DETS_NO_EJECUTADAS = 0 THEN
          UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
          SET USR_ULT_MOD             = Lv_UsrUltMod,
            FE_ULT_MOD                = SYSDATE,
            ESTADO                    = Lr_RegPmCabDetDarBaja.ESTADO_NUEVO_PM_CAB
          WHERE ID_PROCESO_MASIVO_CAB = Lr_RegPmCabDetDarBaja.ID_PROCESO_MASIVO_CAB
          AND ESTADO                  <> Lr_RegPmCabDetDarBaja.ESTADO_NUEVO_PM_CAB;
        END IF;
        Ln_IndxPmDetDarBaja    := Lt_TPmCabDetDarBaja.NEXT(Ln_IndxPmDetDarBaja);
        COMMIT;
      END LOOP;
      EXIT WHEN Lc_GetPmDetsDarBaja%NOTFOUND;
    END LOOP;
    CLOSE Lc_GetPmDetsDarBaja;
    Pv_Status := 'OK';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error al finalizar los procesos masivos. Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'INKG_TRANSACCIONES_MASIVAS.P_FINALIZA_PMS_POR_OPCION', 
                                            'Ocurri� un error inesperado en el proceso, '
                                            || SUBSTR(SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_FINALIZA_PMS_POR_OPCION;

  PROCEDURE P_CREA_PM_REACTIVACION_MD_CSV(
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2)
  AS
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_UsrCreacion                  VARCHAR2(15) := 'reactivacionCsv';
    Lv_IpCreacion                   VARCHAR2(16) := '127.0.0.1';
    Lv_PrefijoArchivoCsv            VARCHAR2(24) := 'reactivaciones_masivas_';
    Lv_FechaArchivoCsv              VARCHAR2(10) := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
    Lv_NombreParamDirBdArchivosTmp  VARCHAR2(33) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
    Lv_DirectorioBaseDatos          VARCHAR2(100);
    Lv_RutaDirectorioBaseDatos      VARCHAR2(500);
    CURSOR Lc_GetValoresParamsGeneral(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetObtieneDataPunto(Cv_Login DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE)
    IS
      SELECT PUNTO.ID_PUNTO, PUNTO.LOGIN, SERVICIO.ID_SERVICIO AS ID_SERVICIO_INTERNET, SERVICIO.ESTADO AS ESTADO_SERVICIO_INTERNET, 
        VISTA_SALDOS.SALDO
      FROM DB_COMERCIAL.INFO_PUNTO PUNTO
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
      ON SERVICIO.PUNTO_ID = PUNTO.ID_PUNTO
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO_SALDO VISTA_SALDOS
      ON VISTA_SALDOS.PUNTO_ID = PUNTO.ID_PUNTO
      WHERE PUNTO.LOGIN = Cv_Login
      AND SERVICIO.ID_SERVICIO = DB_COMERCIAL.GET_ID_SERVICIO_PREF(PUNTO.ID_PUNTO);

    CURSOR Lc_GetValorParamServiciosMd( Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DET.ID_PARAMETRO_DET, DET.VALOR3, DET.VALOR4, DET.VALOR5, DET.VALOR6, DET.VALOR7, DET.OBSERVACION, DET.EMPRESA_COD
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.VALOR1 = Cv_Valor1
      AND DET.VALOR2 = Cv_Valor2
      AND DET.ESTADO = Lv_EstadoActivo;
    Lr_RegGetValorParamServiciosMd  Lc_GetValorParamServiciosMd%ROWTYPE;
    Lr_RegGetValoresParamsGeneral   Lc_GetValoresParamsGeneral%ROWTYPE;
    Lr_RegGetObtieneDataPunto       Lc_GetObtieneDataPunto%ROWTYPE;
    Lv_EstadoServicioPermitido      VARCHAR2(1000);
    Ln_ValorSaldoMaxPermitido       NUMBER;
    Ln_IdPmCabReactivacion          DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Lr_PmCabReactivacion            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Ln_IdPmDetReactivacion          DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;
    Lr_PmDetReactivacion            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;
    Lv_Delimitador                  VARCHAR2(1) := ',';
    Lv_NombreArchivoRespuesta       VARCHAR2(500);
    Lf_ArchivoRespuesta             UTL_FILE.FILE_TYPE;
    Lf_ArchivoCsv                   UTL_FILE.FILE_TYPE;
    Lv_NombreCompletoArchivo        VARCHAR2(500);
    Lf_VerifPrimerLineaArchivo      UTL_FILE.FILE_TYPE;
    Lv_ContenidoPrimeraLinea        VARCHAR2(4000);
    Lt_TCamposPrimeraLineaCsv       DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
    Ln_CantidadColumnasCsv          NUMBER;
    Lv_ContenidoLinea               VARCHAR2(4000);
    Lv_StatusLineaCsv               VARCHAR2(5);
    Lv_ObservacionLineaCsv          VARCHAR2(500);
    Lr_RegDataPorProcesarLineaCsv   DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataLoginesPorProcesar;
    Lv_Gzip                         VARCHAR2(500);
    Lv_NombreArchivoCorreoZip       VARCHAR2(500);
    Lv_NombreParamsServiciosMd      VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
    Lv_ProcesoRemitenteYAsunto      VARCHAR2(33) := 'CREACION_REACTIVACION_MASIVA_CSV';
    Lv_NombreParamPmReactivacion    VARCHAR2(20) := 'REACTIVACION_MASIVA';
    Lv_ParamsPmReactivacion         VARCHAR2(46) := 'PARAMS_CREACION_REACTIVACION_MASIVA_DESDE_CSV';
    Lv_Asunto                       VARCHAR2(300);
    Lv_Remitente                    VARCHAR2(100);
    Lv_PlantillaCorreo              VARCHAR2(32767);
    Lr_GetAliasPlantillaCorreo      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lt_TCamposXLineaCsv             DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
    Ln_IndxTCamposXLineaCsv         NUMBER;
    Lv_LoginPuntoCsv                DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Le_ExceptionInterno             EXCEPTION;
  BEGIN

    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamDirBdArchivosTmp);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_DirectorioBaseDatos      := Lr_RegGetValoresParamsGeneral.VALOR1;
    IF Lv_DirectorioBaseDatos IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;
    Lv_RutaDirectorioBaseDatos  := Lr_RegGetValoresParamsGeneral.VALOR2;
    IF Lv_RutaDirectorioBaseDatos IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la rura del directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetValorParamServiciosMd(Lv_NombreParamsServiciosMd, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_Remitente    := Lr_RegGetValorParamServiciosMd.VALOR3;
    Lv_Asunto       := Lr_RegGetValorParamServiciosMd.VALOR4;
    IF Lv_Remitente IS NULL OR Lv_Asunto IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el remitente y/o el asunto del correo con el archivo adjunto de cambio de plan masivo';
      RAISE Le_Exception;
    END IF;

    Lr_RegGetValorParamServiciosMd := NULL;
    OPEN Lc_GetValorParamServiciosMd(Lv_NombreParamsServiciosMd, Lv_NombreParamPmReactivacion, Lv_ParamsPmReactivacion);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_EstadoServicioPermitido  := Lr_RegGetValorParamServiciosMd.VALOR3;
    Ln_ValorSaldoMaxPermitido   := TO_NUMBER(Lr_RegGetValorParamServiciosMd.VALOR4, '9999');
    IF Lv_Remitente IS NULL OR Lv_Asunto IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el remitente y/o el asunto del correo con el archivo adjunto de cambio de plan masivo';
      RAISE Le_Exception;
    END IF;

    Lr_GetAliasPlantillaCorreo  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('PMREACTCSV');
    Lv_PlantillaCorreo       := Lr_GetAliasPlantillaCorreo.PLANTILLA;
    IF Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS IS NOT NULL THEN
      Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS := REPLACE(Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS, ';', ',') || ',';
    ELSE 
      Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS := Lv_Remitente || ',';
    END IF;

    Lv_NombreCompletoArchivo    := Lv_PrefijoArchivoCsv || Lv_FechaArchivoCsv || '.csv';
    Lf_VerifPrimerLineaArchivo  := UTL_FILE.FOPEN(Lv_DirectorioBaseDatos, Lv_NombreCompletoArchivo, 'R', 4000);
    UTL_FILE.GET_LINE(Lf_VerifPrimerLineaArchivo, Lv_ContenidoPrimeraLinea);
    Lv_ContenidoPrimeraLinea    := REPLACE(Lv_ContenidoPrimeraLinea,  CHR(13), '');
    IF Lv_ContenidoPrimeraLinea IS NOT NULL THEN
      Lt_TCamposPrimeraLineaCsv := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(Lv_ContenidoPrimeraLinea, Lv_Delimitador);
      Ln_CantidadColumnasCsv := Lt_TCamposPrimeraLineaCsv.COUNT;
      IF Ln_CantidadColumnasCsv <> 1 THEN
        Lv_MsjError := 'El archivo tiene un n�mero de columnas no permitidas. S�lo se permite 1 columna';
        RAISE Le_Exception;
      END IF;
    ELSE
      Lv_MsjError := 'El archivo no tiene data para procesar';
      RAISE Le_Exception;
    END IF;
    UTL_FILE.FCLOSE(Lf_VerifPrimerLineaArchivo);

    Lv_NombreArchivoRespuesta       := Lv_PrefijoArchivoCsv || Lv_FechaArchivoCsv || '_Respuesta.csv';
    Lf_ArchivoRespuesta             := UTL_FILE.FOPEN(Lv_DirectorioBaseDatos, Lv_NombreArchivoRespuesta, 'w', 4000);
    UTL_FILE.PUT_LINE(Lf_ArchivoRespuesta,  'LOGIN' || Lv_Delimitador ||
                                            'ID_PUNTO' || Lv_Delimitador ||
                                            'ID_SERVICIO_INTERNET' || Lv_Delimitador ||
                                            'ESTADO_SERVICIO_INTERNET' || Lv_Delimitador ||
                                            'SALDO' || Lv_Delimitador ||
                                            'STATUS' || Lv_Delimitador ||
                                            'OBSERVACION');

    Lf_ArchivoCsv  := UTL_FILE.FOPEN(Lv_DirectorioBaseDatos, Lv_NombreCompletoArchivo, 'R', 4000);
    LOOP
      BEGIN
        Lv_ContenidoLinea               := '';
        Lv_StatusLineaCsv               := '';
        Lv_ObservacionLineaCsv          := '';
        Lr_RegDataPorProcesarLineaCsv   := NULL;
        UTL_FILE.GET_LINE(Lf_ArchivoCsv, Lv_ContenidoLinea, 4000);
        Lv_ContenidoLinea               := REPLACE(Lv_ContenidoLinea,  CHR(13), '');
        Lt_TCamposXLineaCsv             := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(Lv_ContenidoLinea, Lv_Delimitador);
        Ln_IndxTCamposXLineaCsv         := 0;
        Lv_LoginPuntoCsv                := '';
        IF Lt_TCamposXLineaCsv.EXISTS(Ln_IndxTCamposXLineaCsv) THEN
          Lv_LoginPuntoCsv := TRIM(Lt_TCamposXLineaCsv(Ln_IndxTCamposXLineaCsv));
        END IF;
        
        IF Lv_LoginPuntoCsv IS NOT NULL THEN 
          --Se valida si el login enviado est� listo para ser reactivado
          OPEN Lc_GetObtieneDataPunto(Lv_LoginPuntoCsv);
          FETCH Lc_GetObtieneDataPunto INTO Lr_RegGetObtieneDataPunto;
          CLOSE Lc_GetObtieneDataPunto;
          IF Lr_RegGetObtieneDataPunto.ID_PUNTO IS NOT NULL THEN
            IF Lr_RegGetObtieneDataPunto.ESTADO_SERVICIO_INTERNET <> Lv_EstadoServicioPermitido THEN
              Lv_StatusLineaCsv         := 'ERROR';
              Lv_ObservacionLineaCsv    := 'No aplica ya que el servicio de Internet asociado se encuentra en estado '
                                           || Lr_RegGetObtieneDataPunto.ESTADO_SERVICIO_INTERNET || ' y el estado permitido es ' 
                                           || Lv_EstadoServicioPermitido;
            ELSIF Lr_RegGetObtieneDataPunto.SALDO > Ln_ValorSaldoMaxPermitido THEN
              Lv_StatusLineaCsv         := 'ERROR';
              Lv_ObservacionLineaCsv    := 'No aplica ya que el saldo es de ' || Lr_RegGetObtieneDataPunto.SALDO || 'y el valor '
                                            || 'max. permitido es de ' || Ln_ValorSaldoMaxPermitido;

            ELSE
              Ln_IdPmCabReactivacion    := NULL;
              Ln_IdPmDetReactivacion    := NULL;
              BEGIN
                Lr_PmCabReactivacion                          := NULL;
                Lr_PmCabReactivacion.TIPO_PROCESO             := 'ReconectarCliente';
                Lr_PmCabReactivacion.FECHA_EMISION_FACTURA    := NULL;
                Lr_PmCabReactivacion.FACTURAS_RECURRENTES     := NULL;
                Lr_PmCabReactivacion.VALOR_DEUDA              := NULL;
                Lr_PmCabReactivacion.IDS_BANCOS_TARJETAS      := NULL;
                Lr_PmCabReactivacion.IDS_OFICINAS             := NULL;
                Lr_PmCabReactivacion.EMPRESA_ID               := 18;
                Lr_PmCabReactivacion.CANTIDAD_PUNTOS          := 1;
                Lr_PmCabReactivacion.ESTADO                   := 'Pendiente';
                Lr_PmCabReactivacion.FE_CREACION              := SYSDATE;
                Lr_PmCabReactivacion.USR_CREACION             := Lv_UsrCreacion;
                Lr_PmCabReactivacion.IP_CREACION              := Lv_IpCreacion;
                Lr_PmCabReactivacion.SOLICITUD_ID             := NULL;
                DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_CAB(Lr_PmCabReactivacion, Ln_IdPmCabReactivacion, 
                                                                                          Lv_MsjError);
                IF Lv_MsjError IS NOT NULL THEN 
                  RAISE Le_ExceptionInterno;
                END IF;

                Lr_PmDetReactivacion                        := NULL;
                Lr_PmDetReactivacion.PROCESO_MASIVO_CAB_ID  := Ln_IdPmCabReactivacion;
                Lr_PmDetReactivacion.PUNTO_ID               := Lr_RegGetObtieneDataPunto.ID_PUNTO;
                Lr_PmDetReactivacion.ESTADO                 := 'Pendiente';
                Lr_PmDetReactivacion.FE_CREACION            := SYSDATE;
                Lr_PmDetReactivacion.USR_CREACION           := Lv_UsrCreacion;
                Lr_PmDetReactivacion.IP_CREACION            := Lv_IpCreacion;
                Lr_PmDetReactivacion.OBSERVACION            := 'Registro creado autom�ticamente por subida de archivo csv';
                DB_INFRAESTRUCTURA.INKG_TRANSACCIONES_MASIVAS.P_INSERT_PROCESO_MASIVO_DET(Lr_PmDetReactivacion, Ln_IdPmDetReactivacion, Lv_MsjError);
                IF Lv_MsjError IS NOT NULL THEN 
                  RAISE Le_ExceptionInterno;
                END IF;
                COMMIT;
                Lv_StatusLineaCsv       := 'OK';
                Lv_ObservacionLineaCsv  := 'Proceso masivo creado exitosamente';
              EXCEPTION
              WHEN Le_ExceptionInterno THEN
                Lv_StatusLineaCsv       := 'ERROR';
                Lv_ObservacionLineaCsv  := 'No se ha podido crear los registros para el proceso masivo';
                ROLLBACK;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                      'INKG_TRANSACCIONES_MASIVAS.P_CREA_PM_REACTIVACION_MD_CSV',
                                                      'Login: ' || Lv_LoginPuntoCsv || '-' || Lv_MsjError,
                                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
              WHEN OTHERS THEN
                Lv_StatusLineaCsv       := 'ERROR';
                Lv_ObservacionLineaCsv  := 'Ha ocurrido un error inesperado al crear los registros para el proceso masivo';
                ROLLBACK;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                      'INKG_TRANSACCIONES_MASIVAS.P_CREA_PM_REACTIVACION_MD_CSV',
                                                      'Login: ' || Lv_LoginPuntoCsv || '-' || SQLCODE 
                                                      || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                                      || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
              END;
            END IF;
          ELSE
            Lv_StatusLineaCsv         := 'ERROR';
            Lv_ObservacionLineaCsv    := 'No se ha podido obtener la data del punto o servicio de Internet asociado';
          END IF;
        ELSE
          Lv_StatusLineaCsv         := 'ERROR';
          Lv_ObservacionLineaCsv    := 'No se ha podido obtener el login';
        END IF;
        UTL_FILE.PUT_LINE(Lf_ArchivoRespuesta,  Lv_LoginPuntoCsv || Lv_Delimitador ||
                                                Lr_RegGetObtieneDataPunto.ID_PUNTO || Lv_Delimitador ||
                                                Lr_RegGetObtieneDataPunto.ID_SERVICIO_INTERNET || Lv_Delimitador ||
                                                Lr_RegGetObtieneDataPunto.ESTADO_SERVICIO_INTERNET || Lv_Delimitador ||
                                                Lr_RegGetObtieneDataPunto.SALDO || Lv_Delimitador ||
                                                Lv_StatusLineaCsv || Lv_Delimitador ||
                                                Lv_ObservacionLineaCsv);

      EXCEPTION WHEN No_Data_Found THEN EXIT; 
      END;
    END LOOP;
    UTL_FILE.FCLOSE(Lf_ArchivoCsv);
    UTL_FILE.FCLOSE(Lf_ArchivoRespuesta);

    Lv_Gzip := 'gzip ' || Lv_RutaDirectorioBaseDatos || Lv_NombreArchivoRespuesta;
    Lv_NombreArchivoCorreoZip  := Lv_NombreArchivoRespuesta || '.gz';
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_Gzip));

    BEGIN
      DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS, Lv_Asunto, Lv_PlantillaCorreo, 
                                                Lv_DirectorioBaseDatos, Lv_NombreArchivoCorreoZip);
      UTL_FILE.FREMOVE(Lv_DirectorioBaseDatos, Lv_NombreArchivoCorreoZip);
      UTL_FILE.FREMOVE(Lv_DirectorioBaseDatos, Lv_NombreCompletoArchivo);
    EXCEPTION
    WHEN OTHERS THEN
      UTL_MAIL.SEND (   SENDER      => Lv_Remitente, 
                        RECIPIENTS  => Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS, 
                        SUBJECT     => Lv_Asunto,
                        MESSAGE     => SUBSTR(Lv_PlantillaCorreo, 1, 32767),
                        MIME_TYPE   => 'text/html; charset=iso-8859-1');

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INFRK_TRANSACCIONES.P_CREA_PM_REACTIVACION_MD_CSV->ENVIO_CORREO', 
                                            'No se ha podido enviar el archivo en la ruta ' || Lv_RutaDirectorioBaseDatos 
                                            || Lv_NombreArchivoRespuesta || ' '
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    Pv_Status               := 'OK';
    Pv_MsjError             := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := Lv_MsjError;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_CREA_PM_REACTIVACION_MD_CSV',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := 'No se han podido crear los registros para el proceso masivo de reactivaci�n';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'INKG_TRANSACCIONES_MASIVAS.P_CREA_PM_REACTIVACION_MD_CSV',
                                          'Error al crear los registros para el proceso masivo de reactivaci�n - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CREA_PM_REACTIVACION_MD_CSV;

    PROCEDURE PROCESA_CREACION_MONITOREO_TG
    AS
        --
        C_QUERYREGISTROS        SYS_REFCURSOR;
        Lv_NombreParametro      VARCHAR2(200)  := 'PARAMETROS_CREACION_MONITOREO_TELCOGRAPH';
        Lv_DatosToken           VARCHAR2(200)  := 'DATOS WS TOKEN';
        Lv_DatosTelcos          VARCHAR2(200)  := 'DATOS WS TELCOS';
        Lv_Datos                VARCHAR2(200)  := 'DATOS';
        Lv_DatosNomTec          VARCHAR2(200)  := 'NOMBRES_TECNICO';
        Lv_DatosEstados         VARCHAR2(200)  := 'ESTADOS_SERVICIOS';
        Lv_DatosCaract          VARCHAR2(200)  := 'CARACTERISTICAS_SERVICIOS';
        Lv_DatosIdServiciosIn   VARCHAR2(200)  := 'ID_SERVICIOS_PERMITIDOS';
        Lv_DatosIdServiciosNotIn VARCHAR2(200)  := 'ID_SERVICIOS_NO_PERMITIDOS';
        Lv_Estado               VARCHAR2(30)   := 'Activo';
        Lv_Gateway              VARCHAR2(30)   := 'Telcos';
        Lv_Token                VARCHAR2(200)  := '';
        Lv_ProcesoTelcoGraph    VARCHAR2(30);
        Lv_ProcesoZabbix        VARCHAR2(30);
        Lv_TipoQuery            VARCHAR2(30);
        Lv_Limit                VARCHAR2(30);
        Lv_IdServiciosIn        VARCHAR2(4000);
        Lv_IdServiciosNotIn     VARCHAR2(4000);
        --
        Lv_User                 VARCHAR2(30);
        Lv_Url                  VARCHAR2(300);
        Lv_Opcion               VARCHAR2(100);
        Lv_Service              VARCHAR2(30);
        Lv_Method               VARCHAR2(30);
        Lv_URLToken             VARCHAR2(300);
        Lv_Name                 VARCHAR2(30);
        Lv_OriginId             VARCHAR2(30);
        Lv_TipoOriginId         VARCHAR2(30);
        --
        Ln_Index                NUMBER;
        Lcl_Headers             CLOB;
        Lcl_Request             CLOB;
        Lcl_Response            CLOB;
        Lcl_ResponseToken       CLOB;
        Ln_CodeRequest          NUMBER;
        Ln_CodeRequestToken     NUMBER;
        Ln_StatusToken          NUMBER;
        Lv_StatusResult         VARCHAR2(10);
        Lv_MsgResult            VARCHAR2(4000);
        Lv_Aplicacion           VARCHAR2(50) := 'application/json';
        Lv_UsuarioCreacion      VARCHAR2(20) := 'CREACION_TG';
        Lv_IpCreacion           VARCHAR2(20) := '127.0.0.1';
        Le_Error                EXCEPTION;
        --
        Lcl_Query               CLOB;
        Lcl_WhereAnd            CLOB;
        --
        TYPE R_Registros IS RECORD (
            ID_PERSONA_ROL      NUMBER,
            ID_SERVICIO         NUMBER
        );
        TYPE T_QUERYREGISTROS IS TABLE OF R_Registros INDEX BY PLS_INTEGER;
        Lr_ServicioTg T_QUERYREGISTROS;
        --
        CURSOR C_ObtenerDatosToken IS
              SELECT VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7 FROM DB_GENERAL.ADMI_PARAMETRO_DET
              WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                  WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
               AND DESCRIPCION = Lv_DatosToken AND ROWNUM = 1;
        --
        CURSOR C_ObtenerDatosTelcos IS
              SELECT VALOR1, VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
              WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                  WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
              AND DESCRIPCION = Lv_DatosTelcos AND ROWNUM = 1;
        --
        CURSOR C_ObtenerDatos IS
              SELECT VALOR1, VALOR2, VALOR3, VALOR4 FROM DB_GENERAL.ADMI_PARAMETRO_DET
              WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                  WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
              AND DESCRIPCION = Lv_Datos AND ROWNUM = 1;
        --
        CURSOR C_ObtenerIdServicios(Cv_DescripDatos VARCHAR2) IS
              SELECT VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET
              WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                  WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
              AND DESCRIPCION = Cv_DescripDatos AND ROWNUM = 1;
        --
        --
      BEGIN
        --
        --obtengo los id servicios permitidos
        OPEN C_ObtenerIdServicios(Lv_DatosIdServiciosIn);
        FETCH C_ObtenerIdServicios INTO Lv_IdServiciosIn;
        CLOSE C_ObtenerIdServicios;
        --
        --obtengo los id servicios no permitidos
        OPEN C_ObtenerIdServicios(Lv_DatosIdServiciosNotIn);
        FETCH C_ObtenerIdServicios INTO Lv_IdServiciosNotIn;
        CLOSE C_ObtenerIdServicios;
        --
        Lcl_WhereAnd := ' EXISTS (
                        SELECT 1
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET, DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                        WHERE PRO.NOMBRE_TECNICO = DET.VALOR1
                        AND DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                        AND CAB.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''
                        AND DET.DESCRIPCION = '''||Lv_DatosNomTec||'''
                        AND CAB.ESTADO = '''||Lv_Estado||'''
                        AND DET.ESTADO = '''||Lv_Estado||'''
                      )
                      AND EXISTS (
                        SELECT 1
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET, DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                        WHERE SER.ESTADO = DET.VALOR1
                        AND DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                        AND CAB.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''
                        AND DET.DESCRIPCION = '''||Lv_DatosEstados||'''
                        AND CAB.ESTADO = '''||Lv_Estado||'''
                        AND DET.ESTADO = '''||Lv_Estado||'''
                      )
                      AND TO_NUMBER(SER.PRECIO_VENTA) > 0
                      AND NOT EXISTS (
                        SELECT 1 FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CAR
                        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C ON C.ID_CARACTERISTICA = CAR.CARACTERISTICA_ID
                        WHERE CAR.PERSONA_EMPRESA_ROL_ID = PUN.PERSONA_EMPRESA_ROL_ID
                        AND UPPER(SER.LOGIN_AUX) = UPPER(CAR.VALOR)
                        AND C.DESCRIPCION_CARACTERISTICA IN (
                          SELECT DET.VALOR1
                          FROM DB_GENERAL.ADMI_PARAMETRO_DET DET, DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                          WHERE DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                          AND CAB.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''
                          AND DET.DESCRIPCION = '''||Lv_DatosCaract||'''
                          AND CAB.ESTADO = '''||Lv_Estado||'''
                          AND DET.ESTADO = '''||Lv_Estado||''' )
                        AND CAR.ESTADO = '''||Lv_Estado||'''
                      ) ';
        --
        IF Lv_IdServiciosIn IS NOT NULL THEN
            Lcl_WhereAnd := Lcl_WhereAnd || ' AND SER.ID_SERVICIO IN (' || Lv_IdServiciosIn || ') ';
        END IF;
        --
        IF Lv_IdServiciosNotIn IS NOT NULL THEN
            Lcl_WhereAnd := Lcl_WhereAnd || ' AND SER.ID_SERVICIO NOT IN (' || Lv_IdServiciosNotIn || ') ';
        END IF;
        --
        -- CREO EL JSON HEADERS
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Content-Type', Lv_Aplicacion);
        APEX_JSON.WRITE('Accept', Lv_Aplicacion);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
        --
        --obtengo los datos token
        OPEN C_ObtenerDatosToken;
        FETCH C_ObtenerDatosToken INTO Lv_Name, Lv_Service, Lv_Method, Lv_User, Lv_URLToken, Lv_OriginId, Lv_TipoOriginId;
        CLOSE C_ObtenerDatosToken;
        --
        --obtengo los datos telcos
        OPEN C_ObtenerDatosTelcos;
        FETCH C_ObtenerDatosTelcos INTO Lv_Url, Lv_Opcion;
        CLOSE C_ObtenerDatosTelcos;
        --
        --obtengo los datos
        OPEN C_ObtenerDatos;
        FETCH C_ObtenerDatos INTO Lv_ProcesoTelcoGraph, Lv_ProcesoZabbix, Lv_TipoQuery, Lv_Limit;
        CLOSE C_ObtenerDatos;
        --
        IF Lv_TipoQuery = 'ALL' THEN
            Lcl_Query := 'SELECT PEM.ID_PERSONA_ROL, SER.ID_SERVICIO
                        FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEM
                          INNER JOIN DB_COMERCIAL.INFO_PUNTO PUN ON PUN.PERSONA_EMPRESA_ROL_ID = PEM.ID_PERSONA_ROL
                          INNER JOIN DB_COMERCIAL.INFO_SERVICIO SER ON SER.PUNTO_ID = PUN.ID_PUNTO
                          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = SER.PRODUCTO_ID
                        WHERE ' || Lcl_WhereAnd;
            Lcl_Query := Lcl_Query || ' AND ROWNUM <= ' || Lv_Limit;
        ELSE
            Lcl_Query := 'SELECT PER.ID_PERSONA_ROL, (
                          SELECT SER.ID_SERVICIO
                          FROM  DB_COMERCIAL.INFO_SERVICIO SER
                            INNER JOIN DB_COMERCIAL.INFO_PUNTO PUN ON PUN.ID_PUNTO = SER.PUNTO_ID
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = SER.PRODUCTO_ID
                            WHERE PUN.PERSONA_EMPRESA_ROL_ID = PER.ID_PERSONA_ROL
                            AND ' || Lcl_WhereAnd || '
                            AND ROWNUM <= 1
                          ) ID_SERVICIO
                        FROM (
                          SELECT PEM.ID_PERSONA_ROL
                          FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEM
                            INNER JOIN DB_COMERCIAL.INFO_PUNTO PUN ON PUN.PERSONA_EMPRESA_ROL_ID = PEM.ID_PERSONA_ROL
                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO SER ON SER.PUNTO_ID = PUN.ID_PUNTO
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = SER.PRODUCTO_ID
                          WHERE ' || Lcl_WhereAnd || '
                          GROUP BY PEM.ID_PERSONA_ROL
                        ) PER';
            Lcl_Query := Lcl_Query || ' WHERE ROWNUM <= ' || Lv_Limit;
        END IF;
        --
        --se recorren registros del cursor
        OPEN C_QUERYREGISTROS FOR Lcl_Query;
        LOOP
          FETCH C_QUERYREGISTROS BULK COLLECT INTO Lr_ServicioTg LIMIT 10000;
          EXIT WHEN Lr_ServicioTg.COUNT() < 1;
          Ln_Index := Lr_ServicioTg.FIRST;
          WHILE (Ln_Index IS NOT NULL)
          LOOP
            BEGIN
                Lcl_Request := '{
                                    "user": "' || Lv_User || '",
                                    "gateway": "' || Lv_Gateway || '",
                                    "service": "' || Lv_Service || '",
                                    "method": "' || Lv_Method || '",
                                    "source": {
                                        "name": "' || Lv_Name || '",
                                        "originID": "' || Lv_OriginId || '",
                                        "tipoOriginID": "' || Lv_TipoOriginId || '"
                                    }
                                  }';
                Ln_StatusToken  := 500;
                Lv_MsgResult    := 'Problemas al generar el Token.';
                DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_URLToken,Lcl_Headers,Lcl_Request,Ln_CodeRequestToken,Lv_MsgResult,Lcl_ResponseToken);
                IF Ln_CodeRequestToken = 0 AND INSTR(Lcl_ResponseToken, 'status') != 0 AND INSTR(Lcl_ResponseToken, 'message') != 0
                  AND INSTR(Lcl_ResponseToken, 'token') != 0 THEN
                    APEX_JSON.PARSE(Lcl_ResponseToken);
                    Ln_StatusToken  := APEX_JSON.GET_NUMBER(p_path => 'status');
                    Lv_MsgResult    := APEX_JSON.GET_VARCHAR2(p_path => 'message');
                    Lv_Token        := APEX_JSON.GET_VARCHAR2(p_path => 'token');
                END IF;
                IF Ln_StatusToken <> 200 THEN
                    RAISE Le_Error;
                ELSE
                    --
                    Lcl_Request   := '{
                                        "op": "' || Lv_Opcion || '",
                                        "user": "' || Lv_User || '",
                                        "token": "' || Lv_Token || '",
                                        "data": {
                                            "procesarTelcoGraph": "' || Lv_ProcesoTelcoGraph || '",
                                            "procesarZabbix": "' || Lv_ProcesoZabbix || '",
                                            "servicioId": "' || Lr_ServicioTg(Ln_Index).ID_SERVICIO || '"
                                        },
                                        "source": {
                                            "name": "' || Lv_Name || '",
                                            "originID": "' || Lv_OriginId || '",
                                            "tipoOriginID": "' || Lv_TipoOriginId || '"
                                        },
                                        "usrCreacion": "' || Lv_UsuarioCreacion || '",
                                        "ipCreacion": "' || Lv_IpCreacion || '"
                                      }';
                    --ejecuto el request
                    Lv_StatusResult := 'ERROR';
                    Lv_MsgResult    := 'Problemas al ejecutar el Ws de Telcos para ejecutar la creaci�n del monitoreo del TelcoGraph del cliente.';
                    DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_Url,Lcl_Headers,Lcl_Request,Ln_CodeRequest,Lv_MsgResult,Lcl_Response);
                    IF Ln_CodeRequest = 0 AND INSTR(Lcl_Response, 'status') != 0 AND INSTR(Lcl_Response, 'mensaje') != 0 THEN
                        APEX_JSON.PARSE(Lcl_Response);
                        Lv_StatusResult := APEX_JSON.GET_VARCHAR2(p_path => 'status');
                        Lv_MsgResult    := APEX_JSON.GET_VARCHAR2(p_path => 'mensaje');
                    END IF;
                    --
                    IF Lv_StatusResult <> 'OK' THEN
                        Lv_MsgResult := 'SERVICIO: '||Lr_ServicioTg(Ln_Index).ID_SERVICIO||' MENSAJE: '||Lv_MsgResult;
                        RAISE Le_Error;
                    END IF;
                END IF;
              EXCEPTION
                WHEN Le_Error THEN
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                       'INKG_TRANSACCIONES_MASIVAS.PROCESA_CREACION_MONITOREO_TG',
                                                       SUBSTR(Lv_MsgResult || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                       Lv_UsuarioCreacion,
                                                       SYSDATE,
                                                       Lv_IpCreacion);
                WHEN OTHERS THEN
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                       'INKG_TRANSACCIONES_MASIVAS.PROCESA_CREACION_MONITOREO_TG',
                                                       SUBSTR('SERVICIO: '||Lr_ServicioTg(Ln_Index).ID_SERVICIO||
                                                       ' MENSAJE: '||SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                       Lv_UsuarioCreacion,
                                                       SYSDATE,
                                                       Lv_IpCreacion);
            END;
            Ln_Index := Lr_ServicioTg.NEXT(Ln_Index);
          END LOOP;
        END LOOP;
        CLOSE C_QUERYREGISTROS;
      EXCEPTION
      WHEN OTHERS THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'INKG_TRANSACCIONES_MASIVAS.PROCESA_CREACION_MONITOREO_TG',
                                             SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                             Lv_UsuarioCreacion,
                                             SYSDATE,
                                             Lv_IpCreacion);

    END PROCESA_CREACION_MONITOREO_TG;
END INKG_TRANSACCIONES_MASIVAS;
/