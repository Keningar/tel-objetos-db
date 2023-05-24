CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REINGRESO AS

  /**
  * Documentaci�n para el Procedimiento P_REINGRESO_ORDEN_SERVICIO
  *
  * M�todo encargado de realizar el proceso autom�tico de
  * reingreso de orden de servicio.
  *
  * @param Pcl_Json    IN  CLOB     Recibe el JSON con la informaci�n a considerar en el proceso autom�tico.
  * @param Pv_Mensaje  OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 03-09-2019

  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 20-03-2020  Se realiza la llamada al webservice putReingresoOrdenServicio que se encargar� de :
  *                          Guardar las modificaciones realizadas en (info_punto, info_punto_forma_contacto, info_punto_dato_adicional)
  *                          Guardar historial de la modificaciones realizadas (info_servicio_historial, info_punto_historial, 
  *                          info_persona_empresa_rol_hist)
  *                          Guardar la caracter�stica del servicio que entr� como proceso de reingreso autom�tico en info_servicio_caracteristica 
  *                          Caracter�stica: "ID_SERVICIO_REINGRESO" 
  *                          Llamada a los procesos sigts para Factibilidad y PrePlanificaci�n .
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 27-07-2021 Se habilita Flujo de Reingreso de ordenes de servicio para servicios con tipo de orden T: Traslado, se valida que exista
  *                         el ID_SERVICIO origen del traslado.
  *
  * Costo Query C_ParametrosWs : 4
  * Costo Query C_GetIdServOrigenTraslado: 8
  */
  PROCEDURE P_REINGRESO_ORDEN_SERVICIO(Pcl_Json   IN  CLOB,
                                       Pv_Mensaje OUT VARCHAR2);

 /**
  * Documentaci�n para F_GET_CARACT_SERVICIO
  * Retorna el valor de la Caracteristica del Servicio.
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-11-2020
  *
  * Costo CURSOR C_GetCaractServicio: 4
  *
  * @param   Fn_IdServicio    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
  * @param   Fv_DesCaract     IN VARCHAR2 Descripci�n de Caracteristica
  * @return VARCHAR2   Retorna Valor de la Caracteristica.
  */
  FUNCTION F_GET_CARACT_SERVICIO(Fn_IdServicio    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fv_DesCaract     IN VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentacion para el Procedimiento P_SET_CLON_SERVICIO
  *
  * M�todo encargado de clonar un servicio.
  *
  * @param Pn_IdServicio      IN  NUMBER   Recibe el id del servicio a clonar
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario quien realiza la clonaci�n.
  * @param Pv_IpCreacion      IN  VARCHAR2 Recibe la ip de creaci�n del servicio a clonar.
  * @param Pn_IdServicioNuevo OUT NUMBER   Retorna Id del servicio nuevo o clonado.
  * @param Pv_Proceso         OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error.
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna un mensaje de error en caso de existir.    
  *
  * @author Anebelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 20-03-2020
  */

  PROCEDURE P_SET_CLON_SERVICIO(Pn_IdServicio      IN  NUMBER,
                                Pv_UsuarioCreacion IN  VARCHAR2,
                                Pv_IpCreacion      IN  VARCHAR2,
                                Pn_IdServicioNuevo OUT  NUMBER,
                                Pv_Proceso         OUT VARCHAR2,
                                Pv_Mensaje         OUT VARCHAR2);

  /**
  * Documentaci�n para el Procedimiento P_SET_CLON_SERVICIO_TECNICO
  *
  * M�todo encargado de clonar la informaci�n t�cnica de un servicio.
  *
  * @param Pn_IdServicioClon  IN  NUMBER   Recibe el id del servicio a clonar
  * @param Pn_IdServicioNuevo IN  NUMBER   Recibe el id del Servicio clonado.
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario quien realiza la clonaci�n.
  * @param Pv_IpCreacion      IN  VARCHAR2 Recibe la ip de creaci�n del servicio a clonar.
  * @param Pv_Proceso         OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error.
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 03-09-2019
  */
  PROCEDURE P_SET_CLON_SERVICIO_TECNICO(Pn_IdServicioClon  IN  NUMBER,
                                        Pn_IdServicioNuevo IN  NUMBER,
                                        Pv_UsuarioCreacion IN  VARCHAR2,
                                        Pv_IpCreacion      IN  VARCHAR2,
                                        Pv_Proceso         OUT VARCHAR2,
                                        Pv_Mensaje         OUT VARCHAR2);

  /**
  * Documentaci�n para el Procedimiento P_SET_CLON_SERVICIO_PLAN
  *
  * M�todo encargado de clonar las caracter�sticas de un servicio.
  *
  * @param Pn_IdServicioClon  IN  NUMBER   Recibe el id del servicio a clonar
  * @param Pn_IdServicioNuevo IN  NUMBER   Recibe el id del Servicio clonado.
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario quien realiza la clonaci�n.
  * @param Pv_Proceso         OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error.
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 03-09-2019
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 20-03-2020  - Se cambia Insert de caracteristicas por plan con sentencia FORALL
  */
  PROCEDURE P_SET_CLON_SERVICIO_PLAN(Pn_IdServicioClon  IN  NUMBER,
                                     Pn_IdServicioNuevo IN  NUMBER,
                                     Pv_UsuarioCreacion IN  VARCHAR2,
                                     Pv_Proceso         OUT VARCHAR2,
                                     Pv_Mensaje         OUT VARCHAR2);

  /**
  * Documentaci�n para el Procedimiento P_SET_HISTORIAL_SERVICIO
  *
  * M�todo de ingresar un historial del servicio.
  *
  * @param Pn_IdServicio      IN  NUMBER   Recibe el id del servicio.
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario de quien ingresa el historial.
  * @param Pv_IpCreacion      IN  VARCHAR2 Recibe la ip de quien ingresa el historial.
  * @param Pv_Estado          IN  VARCHAR2 Recibe el estado del servicio.
  * @param Pn_IdMotivo        IN  NUMBER   Recibe el motivo.
  * @param Pv_Observacion     IN  VARCHAR2 Recibe la observaci�n.
  * @param Pv_Accion          IN  VARCHAR2 Recibe la acci�n.
  * @param Pv_Proceso         OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error.
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 03-09-2019
  */
  PROCEDURE P_SET_HISTORIAL_SERVICIO(Pn_IdServicio      IN  NUMBER,
                                     Pv_UsuarioCreacion IN  VARCHAR2,
                                     Pv_IpCreacion      IN  VARCHAR2,
                                     Pv_Estado          IN  VARCHAR2,
                                     Pn_IdMotivo        IN  NUMBER,
                                     Pv_Observacion     IN  VARCHAR2,
                                     Pv_Accion          IN  VARCHAR2,
                                     Pv_Proceso         OUT VARCHAR2,
                                     Pv_Mensaje         OUT VARCHAR2);
  /**
  * Documentaci�n para el Procedimiento P_SET_NOTIFICA_USUARIO
  *
  * M�todo encargado de notificar al usuario vendedor la culminaci�n del proceso de reingreso de OS.
  *
  * @param Pn_IdServicio IN  VARCHAR2  Recibe el id del servicio.
  * @param Pv_Mensaje    IN  VARCHAR2  Recibe la observaci�n del mensaje.
  * @param Pv_Usuario    IN  VARCHAR2  Recibe el usuario quien realiza la acci�n.
  * @param Pv_Ip         IN  VARCHAR2  Recibe la ip del usuario quien realiza la acci�n.
  * @param Pv_Error      OUT VARCHAR2  Retorna un mensaje de error en caso de existir.
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 03-09-2019
  */
  PROCEDURE P_SET_NOTIFICA_USUARIO(Pn_IdServicio      IN  VARCHAR2,
                                   Pv_Mensaje         IN  VARCHAR2,
                                   Pv_Usuario         IN  VARCHAR2,
                                   Pv_Ip              IN  VARCHAR2,
                                   Pv_Error           OUT VARCHAR2);

  /**
  * Documentaci�n para el Procedimiento P_SET_CARACTERISTICA_REINGRESO
  *
  * M�todo encargado de Guardar la caracter�stica del servicio que entr� como proceso de reingreso autom�tico en info_servicio_caracteristica 
  * Caracter�stica: "ID_SERVICIO_REINGRESO" 
  *
  * @param Pn_IdServicio             IN  NUMBER, Recibe el id del servicio Origen del Reingreso.
  * @param Pn_IdServicioNuevo        IN  NUMBER, Recibe el id del servicio Destino o clonado por el reingreso.
  * @param Pv_CaracteristicaReing    IN  VARCHAR2  Recibe la descripci�n de la caracteristica.
  * @param Pv_UsuarioCreacion        IN  VARCHAR2  Recibe el usuario quien realiza la acci�n.
  * @param Pv_IpCreacion             IN  VARCHAR2 Recibe la Ip de creaci�n.
  * @param Pv_Proceso                OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error.
  * @param Pv_Mensaje                OUT VARCHAR2  Retorna un mensaje de error en caso de existir.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 20-03-2020
  */                                 
  PROCEDURE P_SET_CARACTERISTICA_REINGRESO(Pn_IdServicio           IN  NUMBER,
                                           Pn_IdServicioNuevo      IN  NUMBER,
                                           Pv_CaracteristicaReing  IN  VARCHAR2,
                                           Pv_UsuarioCreacion      IN  VARCHAR2,
                                           Pv_IpCreacion           IN  VARCHAR2,
                                           Pv_Proceso              OUT VARCHAR2,
                                           Pv_Mensaje              OUT VARCHAR2); 

  /**
   * Documentaci�n para el Procedimiento P_FACTURACION_INSTAL_REINGRESO
   *
   * Procedimiento que realiza el Flujo de Facturaci�n por Instalaci�n por servicio con reingreso de orden de servicio autom�tica,
   * se considera el proceso de Mapeo y Aplicaci�n de Promociones de Instalaci�n.   
   *   
   * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
   * @version 1.0 25-03-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec> 
   * @version 1.1 19-01-2021 -Se modifica proceso por el nuevo parametro de salida que se agrego al proceso P_FACTURACION_INSTAL_REINGRESO
   *                          para evitar descompilaciones al ejecutar.
   *
   * Costo CURSOR C_GetInfoServicio: 63
   * Costo CURSOR C_GetSolicitudInstalacion: 5
   * Costo CURSOR C_GetUltMillaServ: 5
   * Costo CURSOR C_GetServicioHistorial: 14
   * Costo CURSOR C_GetPersonaEmpresaRol: 3
   * Costo CURSOR C_GetParamNumDiasFecAlcance: 3
   * Costo CURSOR C_GetParamTipoSol: 5
   */
    PROCEDURE P_FACTURACION_INSTAL_REINGRESO (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                              Pn_PuntoId       IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                              Pv_EmpresaCod    IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                                              
                                              Pv_AplicaProceso OUT VARCHAR2,
                                              Pv_Mensaje       OUT VARCHAR2);    

  /**
   * Documentaci�n para el Procedimiento P_EJECUTA_SERVICIOS_PREFACT
   *
   * M�todo encargado de retomar las ordenes de servicios reingresadas en estado factible y que tienen un historial de prefactible,
   * para continuar el flujo de facturaci�n y convertir a OT.
   *
   * Costo Query C_Servicio:144
   * Costo Query C_PARAMETROS_WS:4
   * Costo Query C_ObtieneDias:4
   *
   * @param Pv_CodEmpresa IN  VARCHAR2 C�digo de la empresa.
   *
   * @author Jos� candelario <jcandelario@telconet.ec>
   * @version 1.0 05-03-2020
   */
   
  PROCEDURE P_EJECUTA_SERVICIOS_PREFACT(Pv_CodEmpresa IN  VARCHAR2);

  /**
   * Documentaci�n para el Procedimiento P_EJECUTA_SERVICIOS_FACT
   *
   * M�todo encargado de retomar las ordenes de servicios reingresadas en estado factible que no culminaron correctamente el flujo de
   * facturaci�n, para continuar el flujo de facturaci�n y convertir a OT.
   *
   * Costo Query C_Servicio:144
   * Costo Query C_PARAMETROS_WS:4
   * Costo Query C_ObtieneDias:4
   *
   * @param Pv_CodEmpresa IN  VARCHAR2 C�digo de la empresa.
   *
   * @author Jos� candelario <jcandelario@telconet.ec>
   * @version 1.0 05-03-2020
   */

  PROCEDURE P_EJECUTA_SERVICIOS_FACT(Pv_CodEmpresa IN  VARCHAR2);

  /**
   * Documentaci�n para el Procedimiento P_PENDIENTE_CONVERTIR_OT
   *
   * M�todo encargado de retomar las ordenes de servicios reingresadas que pasaron correctamente el flujo de facturaci�n, pero a�n no
   * pasan las validaciones para convertir a OT.
   *
   * Costo Query C_Servicio:144
   * Costo Query C_PARAMETROS_WS:4
   *
   * @param Pv_CodEmpresa IN  VARCHAR2 C�digo de la empresa.
   *
   * @author Jos� candelario <jcandelario@telconet.ec>
   * @version 1.0 05-03-2020
   */

  PROCEDURE P_PENDIENTE_CONVERTIR_OT(Pv_CodEmpresa IN  VARCHAR2);

  /**
   * Documentaci�n para el Procedimiento P_REPORTE_REINGRESO
   *
   * M�todo encargado de generar un reporte diario de los servicios reingresados que se convirtieron correctamente en OT del d�a anterior.
   *
   * Costo Query C_GetDatosServicios: 1000
   * Costo Query C_ObtieneDias:4
   *
   * @param Pv_CodEmpresa IN  VARCHAR2 C�digo de la empresa.
   *
   * @author Jos� candelario <jcandelario@telconet.ec>
   * @version 1.0 05-03-2020
   *
   * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
   * @version 1.1 05-02-2021 - Se realiza correcci�n debido a que no se esta mostrando el motivo de anulaci�n de la orden de servicio
   *                           Se realiza la correcci�n para obtener la fecha minima de preplanifcaci�n debido al error presentado en servicios 
   *                           con doble historial de preplanificaci�n.
   */

  PROCEDURE P_REPORTE_REINGRESO (Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE);

  /**
   * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_SERVICIO'.
   *
   * Procedimiento que actualiza un registro en la tabla de Info_Servicio
   *
   * PARAMETROS:
   * @Param Pr_InfoServicio   IN  DB_COMERCIAL.INFO_SERVICIO%ROWTYPE  Recibe un registro con la informaci�n para actualizar.
   * @Param Pv_MsjResultado   OUT VARCHAR2                            Devuelve un mensaje del resultado de ejecuci�n.
   * 
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-03-2020
   */
   
  PROCEDURE P_UPDATE_INFO_SERVICIO(Pr_InfoServicio   IN DB_COMERCIAL.INFO_SERVICIO%ROWTYPE,
                                   Pv_MsjResultado   OUT VARCHAR2);

  /**
   * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DETALLE_SOL'.
   *
   * Procedimiento que actualiza un registro en la tabla de Info_Detalle_Solicitud
   *
   * PARAMETROS:
   * @Param Pr_InfoDetalleSolicitud  IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE  Recibe un registro con la informaci�n para actualizar.
   * @Param Pv_MsjResultado          OUT VARCHAR2                            Devuelve un mensaje del resultado de ejecuci�n.
   * 
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-03-2020
   */
   
  PROCEDURE P_UPDATE_INFO_DETALLE_SOL(Pr_InfoDetalleSolicitud  IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                      Pv_MsjResultado          OUT VARCHAR2);

END CMKG_REINGRESO;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REINGRESO AS

  PROCEDURE P_REINGRESO_ORDEN_SERVICIO(Pcl_Json   IN  CLOB,
                                       Pv_Mensaje OUT VARCHAR2) IS

     --Costo: 4
    CURSOR C_ParametrosWs(Cv_EmpresaId       VARCHAR2,
                          Cv_NombreParametro VARCHAR2,
                          Cv_Descripcion     VARCHAR2,
                          Cv_EstadoActivo    VARCHAR2) IS
      SELECT DET.VALOR1,
      DET.VALOR2,
      DET.VALOR3,
      DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND CAB.ESTADO           = Cv_EstadoActivo
      AND DET.ESTADO           = Cv_EstadoActivo
      AND CAB.MODULO           = 'COMERCIAL'
      AND DET.EMPRESA_COD      = Cv_EmpresaId
      AND DET.DESCRIPCION      = Cv_Descripcion
      AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro;

    --Costo: 8
    CURSOR C_GetIdServOrigenTraslado(Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.SERVICIO_ID%TYPE,
                                     Cv_Observacion  VARCHAR2,
                                     Cv_Formato      VARCHAR2)
        IS
          SELECT REGEXP_SUBSTR(OBSERVACION,
          Cv_Formato, 1, 2, '') AS ID_SERVICIO_TRASLADO
          FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
          WHERE SERVICIO_ID    = Cn_IdServicio
          AND OBSERVACION      LIKE Cv_Observacion; 

    Lv_Usuario               VARCHAR2(40);
    Lv_Ip                    VARCHAR2(40);
    Lv_IdServicio            VARCHAR2(50);
    Lv_Estado                VARCHAR2(40);
    Ln_IdServicioNuevo       NUMBER;
    Le_Exception             EXCEPTION;
    Lv_Error                 VARCHAR2(3000);
    Lv_Proceso               VARCHAR2(100) := 'P_REINGRESO_ORDEN_SERVICIO';
    Lv_UsuarioReingreso      VARCHAR2(20)  := 'telcos_reingresos';
    Lv_Codigo                VARCHAR2(30)  := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Lv_CodEmpresa            VARCHAR2(2);
    Lc_ParametrosWs          C_ParametrosWs%ROWTYPE;
    Lc_ParametroDetalle      C_ParametrosWs%ROWTYPE;
    Lv_EstadoActivo          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PARAMETROS_REINGRESO_OS_AUTOMATICA';    
    Lv_DescripcionWs         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PARAMETROS_WEBSERVICES';
    Lv_CaracteristicaReing   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'ID_SERVICIO_REINGRESO';
    Lv_DescripcionParametro  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DESC_TRASLADO';
    Lv_IdServicioTraslado    VARCHAR2(20);
    Lv_TipoOrden             VARCHAR2(20);
    Lc_Json                  CLOB;
    Lc_Respuesta             CLOB;
    BEGIN
      
      IF C_ParametrosWs%ISOPEN THEN
        CLOSE C_ParametrosWs;
      END IF;    

      --Parseo del Json.
      apex_json.parse(Pcl_Json);
      Lv_Usuario    := apex_json.get_varchar2('strUsuario');
      Lv_Ip         := apex_json.get_varchar2('strIp');
      Lv_IdServicio := apex_json.get_varchar2('intIdServicio');
      Lv_TipoOrden  := apex_json.get_varchar2('strTipoOrden');
      Lv_Estado     := apex_json.get_varchar2('strEstado');
      Lv_CodEmpresa := apex_json.get_varchar2('strCodEmpresa');

      IF Lv_IdServicio IS NULL THEN
        Lv_Error := 'Id del servicio Nulo';
        RAISE Le_Exception;
      END IF;       
      
      OPEN C_ParametrosWs(Lv_CodEmpresa,
                          Lv_NombreParametro,
                          Lv_DescripcionWs,
                          Lv_EstadoActivo);
      FETCH C_ParametrosWs 
      INTO Lc_ParametrosWs;
      CLOSE C_ParametrosWs;
      --
      OPEN C_ParametrosWs(Lv_CodEmpresa,
                          Lv_NombreParametro,
                          Lv_DescripcionParametro,
                          Lv_EstadoActivo);
      FETCH C_ParametrosWs 
      INTO  Lc_ParametroDetalle;
      CLOSE C_ParametrosWs;
      --      
      IF Lv_TipoOrden = 'Traslado' THEN
        IF C_GetIdServOrigenTraslado%ISOPEN THEN
          CLOSE C_GetIdServOrigenTraslado;
        END IF;
        --
        OPEN C_GetIdServOrigenTraslado(Lv_IdServicio,Lc_ParametroDetalle.VALOR1,Lc_ParametroDetalle.VALOR2);
        FETCH C_GetIdServOrigenTraslado INTO Lv_IdServicioTraslado;
        CLOSE C_GetIdServOrigenTraslado;

        IF Lv_IdServicioTraslado IS NULL THEN
          Lv_Error := 'OS No procede para Reingreso Autom�tico: No se encontro servicio origen del traslado.';
          DB_COMERCIAL.CMKG_REINGRESO.P_SET_HISTORIAL_SERVICIO(Lv_IdServicio,
                                                               Lv_UsuarioReingreso,
                                                               Lv_Ip,
                                                               Lv_Estado,
                                                               NULL,
                                                               Lv_Error,
                                                               'reingresoAutomatico',
                                                               Lv_Proceso,
                                                               Lv_Error);
          RAISE Le_Exception;
        END IF;
      END IF;
      --
      --PROCESO PARA CLONAR EL SERVICIO
      DB_COMERCIAL.CMKG_REINGRESO.P_SET_CLON_SERVICIO(Lv_IdServicio,
                                                      Lv_Usuario,
                                                      Lv_Ip,
                                                      Ln_IdServicioNuevo,
                                                      Lv_Proceso,
                                                      Lv_Error);

      IF Ln_IdServicioNuevo IS NULL OR Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;

      --PROCESO PARA CLONAR EL SERVICIO TECNICO
      DB_COMERCIAL.CMKG_REINGRESO.P_SET_CLON_SERVICIO_TECNICO(Lv_IdServicio,
                                                              Ln_IdServicioNuevo,
                                                              Lv_Usuario,
                                                              Lv_Ip,
                                                              Lv_Proceso,
                                                              Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;

      --PROCESO PARA CLONAR LAS CARACTERISTICAS DEL SERVICIO
      DB_COMERCIAL.CMKG_REINGRESO.P_SET_CLON_SERVICIO_PLAN(Lv_IdServicio,
                                                           Ln_IdServicioNuevo,
                                                           Lv_Usuario,
                                                           Lv_Proceso,
                                                           Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;

      --INSERTAMOS EL HISTORIAL DEL SERVICIO EN NUEVO SERVICIO CLONADO
      DB_COMERCIAL.CMKG_REINGRESO.P_SET_HISTORIAL_SERVICIO(Ln_IdServicioNuevo,
                                                           Lv_UsuarioReingreso,
                                                           Lv_Ip,
                                                           'Pre-servicio',
                                                           NULL,
                                                           'Se crea OS por proceso de Reingreso automatico',
                                                           'reingresoAutomatico',
                                                           Lv_Proceso,
                                                           Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;
  
      --INSERTAMOS EL HISTORIAL DEL SERVICIO EN EL SERVICIO ORIGEN DEL REINGRESO
      DB_COMERCIAL.CMKG_REINGRESO.P_SET_HISTORIAL_SERVICIO(Lv_IdServicio,
                                                           Lv_UsuarioReingreso,
                                                           Lv_Ip,
                                                           Lv_Estado,
                                                           NULL,
                                                           'Se ejecut� proceso de reingreso de orden de servicio autom�tico, '||
                                                           'por favor verificar la nueva orden clonada',
                                                           'reingresoAutomatico',
                                                           Lv_Proceso,
                                                           Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;

      --PROCESO PARA INSERTAR CARACTERISTICA DE REINGRESO DE OS QUE RELACIONA EL ID SERVICIO ORIGEN Y DESTINO "ID_SERVICIO_REINGRESO" 
      DB_COMERCIAL.CMKG_REINGRESO.P_SET_CARACTERISTICA_REINGRESO(Lv_IdServicio,
                                                                 Ln_IdServicioNuevo,
                                                                 Lv_CaracteristicaReing,
                                                                 Lv_Usuario,
                                                                 Lv_Ip, 
                                                                 Lv_Proceso,
                                                                 Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;

      COMMIT;
      
       Lc_Json := '';    
      --Se arma el json que ser� enviado al web service.      
      Lc_Json := '{"data": Pcl_Json, "op":"opWS"}';            
      Lc_Json := REPLACE(Lc_Json,'Pcl_Json'            ,Pcl_Json);
      Lc_Json := REPLACE(Lc_Json,'Ln_IdServicioNuevo'  ,Ln_IdServicioNuevo);
      Lc_Json := REPLACE(Lc_Json,'opWS'                ,Lc_ParametrosWs.VALOR2);
                                                  
      DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lc_ParametrosWs.VALOR1,
                                                Pcl_Mensaje        => Lc_Json,
                                                Pv_Application     => Lc_ParametrosWs.VALOR3,
                                                Pv_Charset         => Lc_ParametrosWs.VALOR4,
                                                Pv_UrlFileDigital  => null,
                                                Pv_PassFileDigital => null,
                                                Pcl_Respuesta      => Lc_Respuesta,
                                                Pv_Error           => Lv_Error);
      IF Lv_Error IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;       

      Pv_Mensaje := 'OK';

    EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Mensaje := Lv_Error;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_REINGRESO',
                                           Lv_Proceso,
                                           Lv_Codigo||' - Error: '||Lv_Error|| ' - ID_SERVICIO: '||Lv_IdServicio,
                                           NVL(Lv_Usuario, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(Lv_Ip, '127.0.0.1'));              
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Mensaje := SQLCODE || '-' || SQLERRM;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_REINGRESO',
                                           'P_REINGRESO_ORDEN_SERVICIO',
                                            Lv_Codigo||'| - Error: '||SQLCODE||' - ERROR_STACK:'||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ID_SERVICIO: '||Lv_IdServicio,
                                            NVL(Lv_Usuario, 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(Lv_Ip, '127.0.0.1'));           
    END P_REINGRESO_ORDEN_SERVICIO;    
    --
    --
    --
  FUNCTION F_GET_CARACT_SERVICIO(Fn_IdServicio    IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fv_DesCaract     IN VARCHAR2)
    RETURN VARCHAR2
  IS
    CURSOR C_GetCaractServicio (Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_Estado      DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA.ESTADO%TYPE,
                                Cv_DesCaract   VARCHAR2)
    IS
      SELECT SCA.VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA SCA,
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE  SCA.CARACTERISTICA_ID          = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA     = Cv_DesCaract
      AND SCA.ESTADO                        = Cv_Estado
      AND SCA.SERVICIO_ID                   = Cn_IdServicio
      ;
    
    Lv_Valor               VARCHAR2(250);
    Lv_MsnError            VARCHAR2(200);
    Lv_IpCreacion          VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    IF C_GetCaractServicio%ISOPEN THEN      
      CLOSE C_GetCaractServicio;      
    END IF;
    --
    OPEN C_GetCaractServicio(Fn_IdServicio,'Activo',Fv_DesCaract);    
    FETCH C_GetCaractServicio INTO Lv_Valor;    
    
    CLOSE C_GetCaractServicio;    
    RETURN Lv_Valor;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener la caracter�stica: ' || Fv_DesCaract || ' IdServicio: '|| Fn_IdServicio ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_REINGRESO.F_GET_CARACT_SERVICIO',
                                           Lv_MsnError,
                                           'telcos_reingreso',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN NULL;
      --
  END F_GET_CARACT_SERVICIO;  
    --
    --
    --
    PROCEDURE P_SET_CARACTERISTICA_REINGRESO(Pn_IdServicio           IN  NUMBER,
                                             Pn_IdServicioNuevo      IN  NUMBER,
                                             Pv_CaracteristicaReing  IN  VARCHAR2,
                                             Pv_UsuarioCreacion      IN  VARCHAR2,
                                             Pv_IpCreacion           IN  VARCHAR2,
                                             Pv_Proceso              OUT VARCHAR2,
                                             Pv_Mensaje              OUT VARCHAR2) IS
                                             
      CURSOR C_Caracteristica (Cv_CaracteristicaReing VARCHAR2) IS
      SELECT  ID_CARACTERISTICA         
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaReing
      AND ESTADO                       ='Activo';

      CURSOR C_ServicioCaracteristica (Cn_IdServicio       NUMBER, 
                                       Cn_IdCaracteristica NUMBER) IS
      SELECT SC.ID_SERVICIO_CARACTERISTICA
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA SC, 
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE COALESCE(TO_NUMBER(REGEXP_SUBSTR(SC.VALOR,'^\d+')),0) = Cn_IdServicio
      AND SC.CARACTERISTICA_ID                                    = CA.ID_CARACTERISTICA
      AND CA.ID_CARACTERISTICA                                    = Cn_IdCaracteristica
      AND SC.ESTADO                                               = 'Activo';
 
      Ln_IdCaracteristica          NUMBER;
      Ln_IdServicioCaracteristica  NUMBER;
      Le_Exception                 EXCEPTION;
      Lv_Mensaje                   VARCHAR2(100);
      Ln_IdServicioCarac           NUMBER := DB_COMERCIAL.SEQ_INFO_SERVICIO_CARAC.NEXTVAL;
    BEGIN
      IF C_Caracteristica%ISOPEN THEN
        CLOSE C_Caracteristica;
      END IF;

      IF C_ServicioCaracteristica%ISOPEN THEN
        CLOSE C_ServicioCaracteristica;
      END IF;        
        
      OPEN C_Caracteristica(Pv_CaracteristicaReing);
      FETCH C_Caracteristica INTO Ln_IdCaracteristica;
      CLOSE C_Caracteristica;

      IF Ln_IdCaracteristica IS NULL THEN
        Lv_Mensaje:= 'Hubo un error al obtener la caracter�stica ID_SERVICIO_REINGRESO';
        RAISE Le_Exception;
      END IF;
      
      OPEN C_ServicioCaracteristica(Pn_IdServicio, Ln_IdCaracteristica);
      FETCH C_ServicioCaracteristica INTO Ln_IdServicioCaracteristica;
      CLOSE C_ServicioCaracteristica;

      IF Ln_IdServicioCaracteristica IS NOT NULL THEN
        Lv_Mensaje:= 'Hubo un error el servicio ya se encuentra Clonado o Reingresado';
        RAISE Le_Exception;
      END IF;

      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
      (
       ID_SERVICIO_CARACTERISTICA,
       SERVICIO_ID,
       CARACTERISTICA_ID,
       VALOR,
       FE_FACTURACION,
       CICLO_ORIGEN_ID,
       ESTADO,
       OBSERVACION,
       USR_CREACION,
       IP_CREACION,
       FE_CREACION,
       USR_ULT_MOD,
       IP_ULT_MOD,
       FE_ULT_MOD)
       VALUES
      (
       Ln_IdServicioCarac,
       Pn_IdServicioNuevo,
       Ln_IdCaracteristica,
       Pn_IdServicio,
       NULL,
       NULL,
       'Activo',
       'Proceso de reingreso de orden de servicio.',
       Pv_UsuarioCreacion,
       Pv_IpCreacion,
       SYSDATE,
       NULL,
       NULL,
       NULL);     
     
    EXCEPTION
      WHEN Le_Exception THEN
        Pv_Proceso := 'P_SET_CARACTERISTICA_REINGRESO';
        Pv_Mensaje := Lv_Mensaje||' - '|| SQLCODE || '-' || SQLERRM; 
        
      WHEN OTHERS THEN
        Pv_Proceso := 'P_SET_CARACTERISTICA_REINGRESO';
        Pv_Mensaje := SQLCODE || '-' || SQLERRM;
      
    END P_SET_CARACTERISTICA_REINGRESO;
    --
    --
    --
    PROCEDURE P_SET_CLON_SERVICIO(Pn_IdServicio      IN  NUMBER,
                                  Pv_UsuarioCreacion IN  VARCHAR2,
                                  Pv_IpCreacion      IN  VARCHAR2,
                                  Pn_IdServicioNuevo OUT  NUMBER,
                                  Pv_Proceso         OUT VARCHAR2,
                                  Pv_Mensaje         OUT VARCHAR2) IS

      --Cursores Locales
      CURSOR C_Servicio (Cn_IdServicio NUMBER) IS
      SELECT ISER.*
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE ISER.ID_SERVICIO = Cn_IdServicio;

      --Variables
      Ln_IdServicioNuevo   NUMBER := DB_COMERCIAL.SEQ_INFO_SERVICIO.NEXTVAL;
      Lc_Servicio          C_Servicio%ROWTYPE;
      Lv_UsuarioReingreso  VARCHAR2(20)  := 'telcos_reingresos';

      BEGIN

        IF C_Servicio%ISOPEN THEN
          CLOSE C_Servicio;
        END IF;

        --Procedemos con la clonaci�n del servicio
        OPEN C_Servicio(Pn_IdServicio);
          FETCH C_Servicio INTO Lc_Servicio;
        CLOSE C_Servicio;

        INSERT INTO DB_COMERCIAL.INFO_SERVICIO 
        (
         ID_SERVICIO,
         PUNTO_ID,
         PLAN_ID,
         ES_VENTA,
         CANTIDAD,
         PRECIO_VENTA,
         FRECUENCIA_PRODUCTO,
         MESES_RESTANTES,
         ESTADO,
         FE_CREACION,
         USR_CREACION,
         IP_CREACION,
         PUNTO_FACTURACION_ID,
         TIPO_ORDEN,
         REF_SERVICIO_ID,
         PRECIO_FORMULA,
         USR_VENDEDOR
        ) 
        VALUES 
        (
         Ln_IdServicioNuevo,
         Lc_Servicio.PUNTO_ID,
         Lc_Servicio.PLAN_ID,
         Lc_Servicio.ES_VENTA,
         Lc_Servicio.CANTIDAD,
         Lc_Servicio.PRECIO_VENTA,
         Lc_Servicio.FRECUENCIA_PRODUCTO,
         Lc_Servicio.MESES_RESTANTES,
         'Pre-servicio',
         SYSDATE,
         Lv_UsuarioReingreso,
         Pv_IpCreacion,
         Lc_Servicio.PUNTO_FACTURACION_ID,
         Lc_Servicio.TIPO_ORDEN,
         Lc_Servicio.ID_SERVICIO,
         Lc_Servicio.PRECIO_FORMULA,
         Pv_UsuarioCreacion
        );

        Pn_IdServicioNuevo:= Ln_IdServicioNuevo;

      EXCEPTION
      WHEN OTHERS THEN
        Pv_Proceso := 'P_SET_CLON_SERVICIO';
        Pv_Mensaje := SQLCODE || '-' || SQLERRM;   
        Pn_IdServicioNuevo:= NULL;

    END P_SET_CLON_SERVICIO;
    --
    --
    --
    PROCEDURE P_SET_CLON_SERVICIO_TECNICO(Pn_IdServicioClon  IN  NUMBER,
                                          Pn_IdServicioNuevo IN  NUMBER,
                                          Pv_UsuarioCreacion IN  VARCHAR2,
                                          Pv_IpCreacion      IN  VARCHAR2,
                                          Pv_Proceso         OUT VARCHAR2,
                                          Pv_Mensaje         OUT VARCHAR2) IS

      --Cursores Locales
      CURSOR C_ServicioTecnico (Cn_IdServicio NUMBER) IS
        SELECT IST.*
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
        WHERE IST.SERVICIO_ID = Cn_IdServicio;

      --Variables Locales
      Lc_ServicioTecnico  C_ServicioTecnico%ROWTYPE;

      BEGIN
        IF C_ServicioTecnico%ISOPEN THEN
          CLOSE C_ServicioTecnico;
        END IF;

        OPEN C_ServicioTecnico(Pn_IdServicioClon);
          FETCH C_ServicioTecnico INTO Lc_ServicioTecnico;
        CLOSE C_ServicioTecnico;

        INSERT INTO DB_COMERCIAL.INFO_SERVICIO_TECNICO
        (
         ID_SERVICIO_TECNICO,
         SERVICIO_ID,
         ULTIMA_MILLA_ID,
         TIPO_ENLACE
        )
        VALUES
        (
         DB_COMERCIAL.SEQ_INFO_SERVICIO_TECNICO.NEXTVAL,
         Pn_IdServicioNuevo,
         Lc_ServicioTecnico.ULTIMA_MILLA_ID,
         Lc_ServicioTecnico.TIPO_ENLACE
        );

      EXCEPTION
      WHEN OTHERS THEN
        Pv_Proceso := 'P_SET_CLON_SERVICIO_TECNICO';
        Pv_Mensaje := SQLCODE || '-' || SQLERRM;

    END P_SET_CLON_SERVICIO_TECNICO;
    --
    --
    --
    PROCEDURE P_SET_CLON_SERVICIO_PLAN(Pn_IdServicioClon  IN  NUMBER,
                                       Pn_IdServicioNuevo IN  NUMBER,
                                       Pv_UsuarioCreacion IN  VARCHAR2,
                                       Pv_Proceso         OUT VARCHAR2,
                                       Pv_Mensaje         OUT VARCHAR2) IS

      --CURSORES LOCALES
      CURSOR C_ServicioPlanCaract (Cv_IdServicio VARCHAR2) IS
      SELECT ISPC.*
      FROM DB_COMERCIAL.INFO_SERVICIO_PLAN_CARACT ISPC
      WHERE ISPC.SERVICIO_ID = Cv_IdServicio
      AND ISPC.ESTADO        = 'Activo';

      TYPE t_CaracteristicasServ IS TABLE OF DB_COMERCIAL.INFO_SERVICIO_PLAN_CARACT%ROWTYPE;
      Lt_CaracteristicasServ     t_CaracteristicasServ;
      BEGIN
        
      OPEN C_ServicioPlanCaract(Pn_IdServicioClon);
      LOOP
        FETCH C_ServicioPlanCaract BULK COLLECT INTO Lt_CaracteristicasServ LIMIT 1000;
        EXIT WHEN Lt_CaracteristicasServ.COUNT = 0;
        FORALL Ln_Indice IN Lt_CaracteristicasServ.FIRST .. Lt_CaracteristicasServ.LAST SAVE EXCEPTIONS
          INSERT INTO DB_COMERCIAL.INFO_SERVICIO_PLAN_CARACT
          (
           ID_SERVICIO_PLAN_CARACT,
           SERVICIO_ID,
           PLAN_CARACTERISTICA_ID,
           VALOR,
           FE_CREACION,
           USR_CREACION,
           ESTADO
          )
          VALUES
          (
           DB_COMERCIAL.SEQ_INFO_SERVICIO_PLAN_CARACT.NEXTVAL,
           Pn_IdServicioNuevo,
           Lt_CaracteristicasServ(Ln_Indice).PLAN_CARACTERISTICA_ID,
           Lt_CaracteristicasServ(Ln_Indice).VALOR,
           SYSDATE,
           Pv_UsuarioCreacion,
           Lt_CaracteristicasServ(Ln_Indice).ESTADO
          );
      END LOOP;
      CLOSE C_ServicioPlanCaract;

      EXCEPTION
      WHEN OTHERS THEN
        Pv_Proceso := 'P_SET_CLON_SERVICIO_PLAN';
        Pv_Mensaje := SQLCODE || '-' || SQLERRM;

    END P_SET_CLON_SERVICIO_PLAN;
    --
    --
    --
    PROCEDURE P_SET_HISTORIAL_SERVICIO(Pn_IdServicio      IN  NUMBER,
                                       Pv_UsuarioCreacion IN  VARCHAR2,
                                       Pv_IpCreacion      IN  VARCHAR2,
                                       Pv_Estado          IN  VARCHAR2,
                                       Pn_IdMotivo        IN  NUMBER,
                                       Pv_Observacion     IN  VARCHAR2,
                                       Pv_Accion          IN  VARCHAR2,
                                       Pv_Proceso         OUT VARCHAR2,
                                       Pv_Mensaje         OUT VARCHAR2) IS

    BEGIN

      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
       ID_SERVICIO_HISTORIAL,
       SERVICIO_ID,
       USR_CREACION,
       FE_CREACION,
       IP_CREACION,
       ESTADO,
       MOTIVO_ID,
       OBSERVACION,
       ACCION
      ) 
      VALUES
      (
       DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
       Pn_IdServicio,
       Pv_UsuarioCreacion,
       SYSDATE,
       Pv_IpCreacion,
       Pv_Estado,
       Pn_IdMotivo,
       Pv_Observacion,
       Pv_Accion
      );

    EXCEPTION
      WHEN OTHERS THEN
        Pv_Proceso := 'P_SET_HISTORIAL_SERVICIO';
        Pv_Mensaje := SQLCODE || '-' || SQLERRM;

    END P_SET_HISTORIAL_SERVICIO;
    --
    --
    --
    PROCEDURE P_SET_NOTIFICA_USUARIO(Pn_IdServicio      IN  VARCHAR2,
                                     Pv_Mensaje         IN  VARCHAR2,
                                     Pv_Usuario         IN  VARCHAR2,
                                     Pv_Ip              IN  VARCHAR2,
                                     Pv_Error           OUT VARCHAR2) IS

      --CURSORES LOCALES
      CURSOR C_ObtenerCorreoUsuario(Cv_Estado VARCHAR2,Cv_Login VARCHAR2) 
      IS
        SELECT (LISTAGG(NVEE.MAIL_CIA,';')
        WITHIN GROUP (ORDER BY NVEE.MAIL_CIA)) AS VALOR
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
        WHERE UPPER(NVEE.LOGIN_EMPLE) = UPPER(Cv_Login)
        AND UPPER(NVEE.ESTADO)      = UPPER(Cv_Estado);

      CURSOR C_DatosPuntoServicio (Cn_IdServicio NUMBER) 
      IS
        SELECT ISERVICIO.USR_VENDEDOR,IPUNTO.LOGIN
        FROM DB_COMERCIAL.INFO_SERVICIO ISERVICIO,
        DB_COMERCIAL.INFO_PUNTO    IPUNTO
        WHERE ISERVICIO.PUNTO_ID    = IPUNTO.ID_PUNTO
        AND ISERVICIO.ID_SERVICIO = Cn_IdServicio;

      --VARIABLES LOCALES
      Lc_GetAliasPlantilla   DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
      Lc_DatosPuntoServicio  C_DatosPuntoServicio%ROWTYPE;
      Lcl_Mensaje            CLOB;
      Le_Exception           EXCEPTION;
      Lv_Error               VARCHAR2(4000);
      Lv_Para                VARCHAR2(1000);
      Lv_Remitente           VARCHAR2(50)   := 'notificaciones_telcos@telconet.ec';
      Lv_Asunto              VARCHAR2(50)   := 'PROCESO DE REINGRESO DE OS AUTOMATICA';
      Lv_Type                VARCHAR2(50)   := 'text/html; charset=UTF-8';
      Lv_Mensaje             VARCHAR2(1000) := Pv_Mensaje;

    BEGIN
      IF C_ObtenerCorreoUsuario%ISOPEN THEN
        CLOSE C_ObtenerCorreoUsuario;
      END IF;

      IF C_DatosPuntoServicio%ISOPEN THEN
        CLOSE C_DatosPuntoServicio;
      END IF;

      OPEN C_DatosPuntoServicio(Pn_IdServicio);
      FETCH C_DatosPuntoServicio INTO Lc_DatosPuntoServicio;
      CLOSE C_DatosPuntoServicio;


      OPEN C_ObtenerCorreoUsuario('A',Lc_DatosPuntoServicio.USR_VENDEDOR);
      FETCH C_ObtenerCorreoUsuario INTO Lv_Para;
      CLOSE C_ObtenerCorreoUsuario;

      Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('NROSA');
      Lcl_Mensaje          := Lc_GetAliasPlantilla.PLANTILLA;

      Lv_Mensaje  := DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN(Lv_Mensaje);
      Lcl_Mensaje := REPLACE(Lcl_Mensaje,'{{usuario}}'     ,Lc_DatosPuntoServicio.USR_VENDEDOR);
      Lcl_Mensaje := REPLACE(Lcl_Mensaje,'{{loginCLiente}}',Lc_DatosPuntoServicio.LOGIN);
      Lcl_Mensaje := REPLACE(Lcl_Mensaje,'{{observacion}}' ,Lv_Mensaje);

      DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lv_Remitente,
                                              Lv_Para||';'||Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                              Lv_Asunto||' - '||Lc_DatosPuntoServicio.LOGIN,
                                              Lcl_Mensaje,
                                              Lv_Type,
                                              Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        Lv_Error := 'Error al enviar el correo: '||Lv_Error;
        RAISE Le_Exception;
      END IF;

      Pv_Error := 'OK';

    EXCEPTION
      WHEN Le_Exception THEN
        Pv_Error := Lv_Error;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_REINGRESO',
                                             'P_SET_NOTIFICA_USUARIO',
                                             Lv_Error,
                                             NVL(Pv_Usuario, 'DB_COMERCIAL'),
                                             SYSDATE,
                                             NVL(Pv_Ip, '127.0.0.1'));

      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_REINGRESO',
                                             'P_SET_NOTIFICA_USUARIO',
                                             'Error: '||SQLCODE||' - ERROR_STACK:'||
                                             DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             NVL(Pv_Usuario, 'DB_COMERCIAL'),
                                             SYSDATE,
                                             NVL(Pv_Ip, '127.0.0.1'));
    END P_SET_NOTIFICA_USUARIO;
    --
    --
    --
    PROCEDURE P_FACTURACION_INSTAL_REINGRESO (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                              Pn_PuntoId       IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                              Pv_EmpresaCod    IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                                              
                                              Pv_AplicaProceso OUT VARCHAR2,
                                              Pv_Mensaje       OUT VARCHAR2)
    IS
      --Costo: 63
      CURSOR C_GetInfoServicio (Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_EstadoServ           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                Cv_EsVenta              DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
                                Cv_EstadoActivo         VARCHAR2,
                                Cv_EmpresaCod           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Cv_FibraCod             DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                                Cv_CobreCod             DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                                Cv_NombreTecnico        DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                Cn_Frecuencia           DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
                                Cv_NombreParamReingreso VARCHAR2,
                                Cv_DescParamReingreso   VARCHAR2,
                                Cn_NumeroDias           NUMBER,
                                Cv_NombreParametro      VARCHAR2,
                                Cv_TipoPromo            VARCHAR2,
                                Cv_EstadoPendiente      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                Cv_EstadoFinalizada     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                Cv_EstadoEliminada      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                Cv_IdSolWeb             DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE,
                                Cv_IdSolMovil           DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE,
                                Cv_CaracteristicaReing  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE
                               )
      IS
        SELECT ID_SERVICIO, 
          ipc.NOMBRE_PLAN AS NOMBRE_PLAN,
          NVL(ICO.ORIGEN, 'WEB') AS ORIGEN,
          NVL(atc.DESCRIPCION_CUENTA, afp.DESCRIPCION_FORMA_PAGO) AS FORMA_PAGO
        FROM DB_COMERCIAL.INFO_SERVICIO iser
          JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist ON iser.ID_SERVICIO = ist.SERVICIO_ID
          JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
          JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc ON iser.PLAN_ID = ipc.ID_PLAN
          JOIN DB_COMERCIAL.INFO_PLAN_DET ipd ON ipc.ID_PLAN = ipd.PLAN_ID
          JOIN DB_COMERCIAL.ADMI_PRODUCTO ap ON ipd.PRODUCTO_ID = ap.ID_PRODUCTO
          JOIN DB_COMERCIAL.INFO_PUNTO IP ON iser.PUNTO_ID = IP.ID_PUNTO
          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
          JOIN DB_COMERCIAL.INFO_CONTRATO ICO ON ICO.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
          JOIN DB_GENERAL.ADMI_FORMA_PAGO afp ON ICO.FORMA_PAGO_ID = afp.ID_FORMA_PAGO
          LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO icfp ON icfp.CONTRATO_ID = ICO.ID_CONTRATO
          AND ICFP.ESTADO = Cv_EstadoActivo
          LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA atc ON atc.ID_TIPO_CUENTA = icfp.TIPO_CUENTA_ID
          JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH ON ISERH.SERVICIO_ID=iser.ID_SERVICIO
        WHERE iser.ID_SERVICIO        = Cn_IdServicio
        AND iserh.ESTADO              = NVL(Cv_EstadoServ, iser.ESTADO)
        AND iser.ES_VENTA             = Cv_EsVenta
        AND iser.TIPO_ORDEN           IN (SELECT UPPER(PD.VALOR1)
                                                         FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                                           DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                                         WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                                         AND PC.NOMBRE_PARAMETRO = Cv_NombreParamReingreso
                                                         AND PC.ESTADO           = Cv_EstadoActivo
                                                         AND PD.ESTADO           = Cv_EstadoActivo
                                                         AND PD.DESCRIPCION      = Cv_DescParamReingreso)
        AND ap.ESTADO                 = Cv_EstadoActivo
        AND atm.CODIGO_TIPO_MEDIO     IN (Cv_FibraCod, Cv_CobreCod)
        AND iser.FRECUENCIA_PRODUCTO  = Cn_Frecuencia
        AND ap.EMPRESA_COD            = Cv_EmpresaCod
        AND ap.NOMBRE_TECNICO         = Cv_NombreTecnico
        AND ICO.ESTADO                IN (Cv_EstadoActivo)
        AND to_date(to_char(iserh.FE_CREACION,'DD/MM/RRRR'), 'DD/MM/RRRR') >= (SYSDATE - Cn_NumeroDias)
        AND iser.ESTADO IN (SELECT APD.VALOR2 AS VALOR2
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                              DB_GENERAL.ADMI_PARAMETRO_DET APD
                            WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                            AND APD.ESTADO           = Cv_EstadoActivo
                            AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                            AND APC.ESTADO           = Cv_EstadoActivo
                            AND APD.VALOR1           = Cv_TipoPromo
                            AND APD.EMPRESA_COD      = Cv_EmpresaCod
                           )
        AND iser.ID_SERVICIO NOT IN (SELECT DISTINCT SERVICIO_ID 
                                     FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
                                     WHERE TIPO_SOLICITUD_ID    IN (Cv_IdSolWeb,Cv_IdSolMovil)
                                     AND IDS.SERVICIO_ID        = iser.ID_SERVICIO
                                     AND IDS.ESTADO             IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
                                     AND to_date(to_char(ids.FE_CREACION,'DD/MM/RRRR'), 'DD/MM/RRRR') >= (SYSDATE - Cn_NumeroDias)
                                    )
        AND  EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                     FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                       DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                     WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaReing
                     AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                     AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                    )
        UNION
            SELECT ID_SERVICIO, 
              AP.DESCRIPCION_PRODUCTO AS NOMBRE_PLAN,
              NVL(ICO.ORIGEN, 'WEB') AS ORIGEN,
              NVL(atc.DESCRIPCION_CUENTA, afp.DESCRIPCION_FORMA_PAGO) AS FORMA_PAGO
            FROM DB_COMERCIAL.INFO_SERVICIO iser
              JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist ON iser.ID_SERVICIO = ist.SERVICIO_ID
              JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
              JOIN DB_COMERCIAL.ADMI_PRODUCTO ap ON iser.PRODUCTO_ID = ap.ID_PRODUCTO
              JOIN DB_COMERCIAL.INFO_PUNTO IP ON iser.PUNTO_ID = IP.ID_PUNTO
              JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
              JOIN DB_COMERCIAL.INFO_CONTRATO ICO ON ICO.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
              JOIN DB_GENERAL.ADMI_FORMA_PAGO afp ON ICO.FORMA_PAGO_ID = afp.ID_FORMA_PAGO
              LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO icfp ON icfp.CONTRATO_ID = ICO.ID_CONTRATO
               AND ICFP.ESTADO = Cv_EstadoActivo
              LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA atc ON atc.ID_TIPO_CUENTA = icfp.TIPO_CUENTA_ID
              JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH ON ISERH.SERVICIO_ID=iser.ID_SERVICIO
            WHERE iser.ID_SERVICIO        = Cn_IdServicio
            AND iserh.ESTADO              = NVL(Cv_EstadoServ, iser.ESTADO)
            AND iser.ES_VENTA             = Cv_EsVenta
            AND iser.TIPO_ORDEN           IN (SELECT UPPER(PD.VALOR1)
                                                         FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                                           DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                                         WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                                         AND PC.NOMBRE_PARAMETRO = Cv_NombreParamReingreso
                                                         AND PC.ESTADO           = Cv_EstadoActivo
                                                         AND PD.ESTADO           = Cv_EstadoActivo
                                                         AND PD.DESCRIPCION      = Cv_DescParamReingreso)
            AND ap.ESTADO                 = Cv_EstadoActivo
            AND atm.CODIGO_TIPO_MEDIO     IN (Cv_FibraCod, Cv_CobreCod)
            AND iser.FRECUENCIA_PRODUCTO  = Cn_Frecuencia
            AND ap.EMPRESA_COD            = Cv_EmpresaCod
            AND ap.NOMBRE_TECNICO         = Cv_NombreTecnico
            AND ICO.ESTADO                IN (Cv_EstadoActivo)
            AND to_date(to_char(iserh.FE_CREACION,'DD/MM/RRRR'),'DD/MM/RRRR') >= (SYSDATE - Cn_NumeroDias)
            AND iser.ESTADO IN (SELECT APD.VALOR2 AS VALOR2
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                  DB_GENERAL.ADMI_PARAMETRO_DET APD
                                WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                AND APD.ESTADO           = Cv_EstadoActivo
                                AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                                AND APC.ESTADO           = Cv_EstadoActivo
                                AND APD.VALOR1           = Cv_TipoPromo
                                AND APD.EMPRESA_COD      = Cv_EmpresaCod
                               )
            AND iser.ID_SERVICIO NOT IN (SELECT DISTINCT SERVICIO_ID 
                                         FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
                                         WHERE TIPO_SOLICITUD_ID    IN (Cv_IdSolWeb,Cv_IdSolMovil)
                                         AND IDS.SERVICIO_ID        = iser.ID_SERVICIO
                                         AND IDS.ESTADO             IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
                                         AND to_date(to_char(ids.FE_CREACION,'DD/MM/RRRR'),'DD/MM/RRRR') >= (SYSDATE - Cn_NumeroDias)
                                           )
            AND  EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                         FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                           DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                         WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaReing
                         AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                         AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                        );
        
      --Costo: 6
      CURSOR C_GetParametro (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_Origen          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Cv_EstadoActivo    VARCHAR2,
                             Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
      IS
        SELECT VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
          DB_GENERAL.ADMI_PARAMETRO_DET DET
        WHERE CAB.ID_PARAMETRO    = DET.PARAMETRO_ID
        AND CAB.NOMBRE_PARAMETRO  = Cv_NombreParametro
        AND CAB.ESTADO            = Cv_EstadoActivo
        AND DET.ESTADO            = Cv_EstadoActivo
        AND DET.VALOR1            = Cv_Origen
        AND DET.EMPRESA_COD       = Cv_EmpresaCod;        

      --Costo: 7
      CURSOR C_GetSolicitudInstalacion(Cn_IdServicio        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,
                                       Cv_EstadoPendiente   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                       Cv_EstadoFinalizada  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                       Cv_EstadoEliminada   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                       Cv_EstadoActivo      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ESTADO%TYPE,
                                       Cv_EstadoEliminado   DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE DEFAULT 'Eliminado',
                                       Cv_NombreParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'SOLICITUDES_DE_CONTRATO')
      IS
        SELECT IDS.ID_DETALLE_SOLICITUD,
          IDS.ESTADO
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
          JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ON IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
        WHERE IDS.SERVICIO_ID         = Cn_IdServicio
        AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
        AND ATS.ESTADO                = Cv_EstadoActivo
        AND ATS.DESCRIPCION_SOLICITUD IN (SELECT DISTINCT VALOR4
                                           FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                             DB_GENERAL.ADMI_PARAMETRO_DET DET
                                           WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                           AND CAB.ESTADO             = Cv_EstadoActivo
                                           AND CAB.ID_PARAMETRO       = DET.PARAMETRO_ID
                                           AND DET.ESTADO             <> Cv_EstadoEliminado); --Tambi�n considera los inactivos        

      --Costo: 5
      CURSOR C_GetUltMillaServ (Cn_ServicioId DB_COMERCIAL.INFO_SERVICIO_TECNICO.SERVICIO_ID%TYPE) 
      IS        
        SELECT atm.CODIGO_TIPO_MEDIO
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
          JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm ON atm.ID_TIPO_MEDIO  = ist.ULTIMA_MILLA_ID
        WHERE ist.SERVICIO_ID = Cn_ServicioId;

      --Costo:14
      CURSOR C_GetServicioHistorial (Cv_Observacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE,
                                     Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.SERVICIO_ID%TYPE
                                    ) 
      IS
        SELECT ID_SERVICIO_HISTORIAL
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        WHERE OBSERVACION LIKE Cv_Observacion
        AND SERVICIO_ID   = Cn_IdServicio;

      --Costo: 3
      CURSOR C_GetPersonaEmpresaRol (Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
      IS
        SELECT IP.PERSONA_EMPRESA_ROL_ID
        FROM DB_COMERCIAL.INFO_PUNTO IP
        WHERE IP.ID_PUNTO = Cn_PuntoId;

      --Costo: 3
      CURSOR C_GetParamNumDiasFecAlcance (Cv_NombreParam    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Cv_DescParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.DESCRIPCION%TYPE,    
                                          Cv_Estado         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE) 
      IS
        SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
        AND APD.ESTADO             = Cv_Estado
        AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
        AND APD.DESCRIPCION        = Cv_DescParametro
        AND APC.ESTADO             = Cv_Estado;

      --Costo: 5
      CURSOR C_GetParamTipoSol (Cv_NombreParam      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,    
                                Cv_EstadoEliminado  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                Cv_Origen           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE) 
      IS
        SELECT ATS.ID_TIPO_SOLICITUD
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
          DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
        WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParam
        AND CAB.ESTADO             = Cv_EstadoActivo
        AND CAB.ID_PARAMETRO       = DET.PARAMETRO_ID
        AND DET.VALOR4             = ATS.descripcion_solicitud
        AND DET.ESTADO             <> Cv_EstadoEliminado
        AND DET.VALOR1             = Cv_Origen
      ;

      Ln_IdServicio              DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE := 0;
      Lv_NombrePlan              DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE := '';
      Lr_SolicitudInstalacion    DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion := NULL;
      Ln_ContadorSolicitudes     NUMBER := 0;
      Ln_IdDetalleSolicitud      NUMBER := 0;
      Lb_PlanConRestriccion      BOOLEAN:=FALSE;
      Ln_PorcentajeDescuento     NUMBER:=0;
      Lv_UltimaMilla             DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE;
      Lo_ServicioHistorial       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
      Lv_Observacion             VARCHAR2(1000);
      Lb_AplicaPromo             BOOLEAN:=FALSE;
      Lr_GetSolicitudInstalacion C_GetSolicitudInstalacion%ROWTYPE;
      Lr_Parametro               C_GetParametro%ROWTYPE;
      Le_Exception               EXCEPTION;
      Lv_MensajeError            VARCHAR2(1000);
      --
      Ln_PersonaEmpRolId         DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE;
      Lv_AplicaProceso           VARCHAR2(1) := 'N';                
      Lv_Origen                  DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE;
      Lv_EstadoActivo            VARCHAR2(15) := 'Activo';        
      Lv_FormaPago               VARCHAR2(100); 
      --              
      Ln_NumeroDias              NUMBER := 0;
      Lv_NombreParametro         VARCHAR2(2000):='PROM_ESTADO_SERVICIO';
      Lv_TipoPromo               VARCHAR2(2000):='PROM_INS_SOL_FACT';
      Lv_NombreParametroDias     VARCHAR2(2000):='PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE';
      Lv_DescParametroDias       VARCHAR2(2000):='NUMERO_DIAS_PROM_INS';
      Lv_NombreParamReingreso    VARCHAR2(2000):='PARAMETROS_REINGRESO_OS_AUTOMATICA';
      Lv_DescParamReingreso      VARCHAR2(2000):='TIPO_ORDEN';
      Lv_IdSolWeb                VARCHAR2(20);
      Lv_IdSolMovil              VARCHAR2(20);
      Lv_ObservacionPlan         VARCHAR2(32000);
      --
      Lv_CaracteristicaReing     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'ID_SERVICIO_REINGRESO';

    BEGIN      
      IF C_GetPersonaEmpresaRol%ISOPEN THEN
        CLOSE C_GetPersonaEmpresaRol;
      END IF;

      IF C_GetParamTipoSol%ISOPEN THEN
        CLOSE C_GetParamTipoSol;
      END IF;

      IF C_GetParamNumDiasFecAlcance%ISOPEN THEN
        CLOSE C_GetParamNumDiasFecAlcance;
      END IF;

      --Se verifica si la empresa aplica al proceso de facturaci�n de instalaci�n de puntos adicionales por estado factible.        
      Lv_AplicaProceso := DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('FACTURACION_INSTALACION_PUNTOS_ADICIONALES', Pv_EmpresaCod);

      --Si no aplica el proceso, se finaliza inmediatamente
      IF Lv_AplicaProceso = 'N' THEN
        RAISE Le_Exception;
      END IF;
 
      --Se obtiene la persona Empresa rol para verificar si es cliente canal
      OPEN  C_GetPersonaEmpresaRol(Cn_PuntoId => Pn_PuntoId);
      FETCH C_GetPersonaEmpresaRol INTO Ln_PersonaEmpRolId;
      CLOSE C_GetPersonaEmpresaRol;
       
      --Se verifica que el cliente no sea Canal
      IF DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DESCRIPCION_ROL(Pn_PersonaEmpRolId => Ln_PersonaEmpRolId) = 'Cliente Canal' THEN
        Lv_Observacion := 'Cliente Canal no genera facturas de instalaci�n';
        Lv_AplicaProceso := 'N';
        RAISE Le_Exception;
      END IF;
               
      --Se obtiene el tipo de origen del punto para saber si es mandatorio crear una factura de instalaci�n.
      Lv_AplicaProceso := DB_COMERCIAL.COMEK_CONSULTAS.F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod => Pv_EmpresaCod,
                                                                                      Pn_PuntoId    => Pn_PuntoId);

      --Si no aplica el proceso porque el tipo de origen no debe generar factura, se finaliza inmediatamente
      IF Lv_AplicaProceso = 'N' THEN
        Lv_Observacion := 'El tipo de origen del punto no genera facturas de instalaci�n';
        RAISE Le_Exception;
      END IF;

      --Se verifica si se debe generar factura de instalaci�n a ese servicio en ese punto.
      Lv_AplicaProceso := DB_FINANCIERO.FNCK_CONSULTS.F_APLICA_CREAR_FACT_INST (Pn_PuntoId => Pn_PuntoId);

      --Si no aplica el proceso, se finaliza inmediatamente
      IF Lv_AplicaProceso = 'N' THEN
        Lv_Observacion := 'El punto ya tiene generada una factura de instalaci�n';
        RAISE Le_Exception;
      END IF;
      --
      OPEN C_GetParamTipoSol(Cv_NombreParam     =>   'SOLICITUDES_DE_CONTRATO',
                             Cv_EstadoActivo    =>   'Activo',
                             Cv_EstadoEliminado =>   'Eliminado', 
                             Cv_Origen          =>   'WEB');

      FETCH C_GetParamTipoSol INTO Lv_IdSolWeb;
      CLOSE C_GetParamTipoSol;                  
      --
      OPEN C_GetParamTipoSol(Cv_NombreParam     =>   'SOLICITUDES_DE_CONTRATO',
                             Cv_EstadoActivo    =>   'Activo',
                             Cv_EstadoEliminado =>   'Eliminado', 
                             Cv_Origen          =>   'MOVIL');

      FETCH C_GetParamTipoSol INTO Lv_IdSolMovil;
      CLOSE C_GetParamTipoSol;

      OPEN  C_GetParamNumDiasFecAlcance(Cv_NombreParam     => Lv_NombreParametroDias,
                                        Cv_DescParametro   => Lv_DescParametroDias,
                                        Cv_Estado          => Lv_EstadoActivo);

      FETCH C_GetParamNumDiasFecAlcance INTO Ln_NumeroDias;
      CLOSE C_GetParamNumDiasFecAlcance;
      --       
      OPEN  C_GetInfoServicio (Cn_IdServicio           => Pn_IdServicio,
                               Cv_EstadoServ           => 'Factible', 
                               Cv_EsVenta              => 'S',
                               Cv_EstadoActivo         => 'Activo',
                               Cv_EmpresaCod           => Pv_EmpresaCod,
                               Cv_FibraCod             => 'FO',
                               Cv_CobreCod             => 'CO',
                               Cv_NombreTecnico        => 'INTERNET',
                               Cn_Frecuencia           => 1,
                               Cv_NombreParamReingreso => Lv_NombreParamReingreso,
                               Cv_DescParamReingreso   => Lv_DescParamReingreso,
                               Cn_NumeroDias           => Ln_NumeroDias,
                               Cv_NombreParametro      => Lv_NombreParametro,
                               Cv_TipoPromo            => Lv_TipoPromo,
                               Cv_EstadoPendiente      => 'Pendiente',
                               Cv_EstadoFinalizada     => 'Finalizada',
                               Cv_EstadoEliminada      => 'Eliminada',
                               Cv_IdSolWeb             => Lv_IdSolWeb,
                               Cv_IdSolMovil           => Lv_IdSolMovil,
                               Cv_CaracteristicaReing  => Lv_CaracteristicaReing);

      FETCH C_GetInfoServicio INTO Ln_IdServicio, Lv_NombrePlan, Lv_Origen, Lv_FormaPago;
      CLOSE C_GetInfoServicio;
      --
      OPEN  C_GetParametro (Cv_NombreParametro => 'SOLICITUDES_DE_INSTALACION_X_SERVICIO',
                            Cv_Origen          => Lv_Origen,
                            Cv_EstadoActivo    => 'Activo',
                            Cv_EmpresaCod      => Pv_EmpresaCod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;                
      --
      --Verifico si existen Solicitudes de Instalaci�n Pendientes o Finalizadas
      Lr_GetSolicitudInstalacion := NULL;
      IF C_GetSolicitudInstalacion%ISOPEN THEN
        CLOSE C_GetSolicitudInstalacion;
      END IF;

      OPEN  C_GetSolicitudInstalacion(Ln_IdServicio, 'Pendiente', 'Finalizada','Eliminada','Activo');
      FETCH C_GetSolicitudInstalacion INTO Lr_GetSolicitudInstalacion;
      CLOSE C_GetSolicitudInstalacion;        
      --
      --Si no existen solicitudes de Instalaci�n verifico promociones y genero solicitudes de Facturaci�n de Instalaci�n.                       
      IF ( NVL(Ln_IdServicio, 0) > 0 AND NVL(Lr_GetSolicitudInstalacion.ID_DETALLE_SOLICITUD, 0) = 0 ) THEN                              
        Lv_MensajeError := '';
        --             
        --Si posee plan con restricci�n debo generar la Solicitud de Facturaci�n con el valor base por FO y con el Descuento obtenido
        --del parametro RESTRICCION_PLANES_X_INSTALACION
        DB_COMERCIAL.COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           => Lv_NombrePlan,
                                                               Pv_EmpresaCod           => Pv_EmpresaCod,
                                                               Pb_PlanConRestriccion   => Lb_PlanConRestriccion,
                                                               Pn_PorcentajeDescuento  => Ln_PorcentajeDescuento,
                                                               Pv_Observacion          => Lv_ObservacionPlan);
        IF NOT Lb_PlanConRestriccion THEN
          OPEN  C_GetUltMillaServ (Cn_ServicioId => Ln_IdServicio);
          FETCH C_GetUltMillaServ INTO Lv_UltimaMilla;
          CLOSE C_GetUltMillaServ;
        ELSE
          --Si tiene plan con restricci�n se fija por defecto FO.
          Lv_UltimaMilla := 'FO';  
        END IF;
        --
        IF Lv_UltimaMilla IS NOT NULL THEN
        --
          Lr_SolicitudInstalacion:= DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_SOL_INSTALACION(Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                                            Pv_DescripcionSolicitud => Lr_Parametro.VALOR4,
                                                                                            Pv_CaractContrato       => Lr_Parametro.VALOR2,
                                                                                            Pv_NombreMotivo         => Lr_Parametro.VALOR5,
                                                                                            Pv_UltimaMilla          => Lv_UltimaMilla);
          IF Lr_SolicitudInstalacion.ID_TIPO_SOLICITUD IS NULL THEN
            Lv_MensajeError := 'No fue encontrada la informaci�n requerida para crear las solicitudes de instalaci�n.';
            RAISE Le_Exception;
          END IF;
          --
          Lr_SolicitudInstalacion.USR_CREACION:= Lr_Parametro.VALOR6;
          --
          --Si no posee plan con restricci�n debo ejecutar el mapeo promocional por instalaci�n para verificar si aplica a alguna promoci�n
          --y poder generar la solicitud de Facturaci�n con el descuento y diferido de ser el caso.
          IF NOT Lb_PlanConRestriccion THEN
            --Proceso que genera el mapeo promocional en el caso que el servicio cumpla alguna Promoci�n por Instalaci�n.
            DB_COMERCIAL.CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio            =>Ln_IdServicio,
                                                                       Pv_CodigoGrupoPromocion  =>'PROM_INS',
                                                                       Pv_CodEmpresa            =>Pv_EmpresaCod,
                                                                       Pv_Mensaje               =>Lv_MensajeError);
            --  
            Lv_MensajeError := '';
            --Proceso genera solicitud de Facturaci�n de Instalaci�n en base a la promoci�n aplicada.
            DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   =>Pv_EmpresaCod,  
                                                             Pv_TipoPromo    =>'PROM_INS',
                                                             Pn_IdServicio   =>Ln_IdServicio, 
                                                             Pv_MsjResultado =>Lv_MensajeError);
            IF Lv_MensajeError = 'OK' THEN
              Lb_AplicaPromo:= TRUE;
            ELSE 
              Ln_PorcentajeDescuento:=0;
              Lo_ServicioHistorial  := NULL;
              Lv_Observacion        := 'No se Aplic� promoci�n de Instalaci�n para el servicio, se generar� Factura de Instalaci�n por el '||
                                       'valor base de Instalaci�n';
              --VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
              OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                           Cn_IdServicio  => Ln_IdServicio);
              FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
              CLOSE C_GetServicioHistorial;

              IF NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
                Lo_ServicioHistorial                       := NULL;
                Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                Lo_ServicioHistorial.ESTADO                := 'Factible';
                Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
                Lo_ServicioHistorial.USR_CREACION          := Lr_Parametro.VALOR6;
                Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
                DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
              END IF;
              -- 
            END IF;
            -- FIN Lv_MensajeError = 'OK'                           
            --          
          END IF;
          --FIN NOT Lb_PlanConRestriccion 
          --
          --
          --Si posee plan con restricci�n debo generar la Solicitud de Facturaci�n con el valor base por FO y con el Descuento obtenido
          --del parametro RESTRICCION_PLANES_X_INSTALACION
          --Si no Aplic� a ninguna Promoci�n por Instalaci�n debo generar la Solicitud de Facturaci�n por el valor base para FO, CO 
          --y sin descuento.
          IF Lb_PlanConRestriccion OR NOT Lb_AplicaPromo THEN                         
            --                
            Lr_SolicitudInstalacion.OBSERVACION_SOLICITUD := Lr_Parametro.VALOR3;          
            Lr_SolicitudInstalacion.NOMBRE_PLAN           := Lv_NombrePlan;
            Lr_SolicitudInstalacion.FORMA_PAGO            := Lv_FormaPago;
            Lr_SolicitudInstalacion.PUNTO_ID              := Pn_PuntoId;
            Lr_SolicitudInstalacion.ID_SERVICIO           := Ln_IdServicio;
            Lr_SolicitudInstalacion.PORCENTAJE            := Ln_PorcentajeDescuento;
            Lr_SolicitudInstalacion.PERIODOS              := NULL;
            Lr_SolicitudInstalacion.APLICA_PROMO          := NULL;
            Lv_MensajeError                               := NULL;
            DB_COMERCIAL.COMEK_TRANSACTION.P_CREA_SOL_FACT_INSTALACION(Pr_SolicitudInstalacion => Lr_SolicitudInstalacion,
                                                                       Pv_Mensaje              => Lv_MensajeError,
                                                                       Pn_ContadorSolicitudes  => Ln_ContadorSolicitudes,
                                                                       Pn_IdDetalleSolicitud   => Ln_IdDetalleSolicitud);
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            --
          END IF;-- FIN Lb_PlanConRestriccion OR NOT Lb_AplicaPromo
          --
          --
          --Se llama a Proceso que genera las Facturas en base a las solicitudes de Fact. de Instalaci�n.  
          Lv_MensajeError :=NULL;  
          DB_FINANCIERO.FNCK_TRANSACTION.P_GENERAR_FAC_SOLI_X_SERVICIO(Pn_IdServicio           => Ln_IdServicio,
                                                                       Pv_Estado               => 'Pendiente',
                                                                       Pv_DescripcionSolicitud => Lr_SolicitudInstalacion.DESCRIPCION_SOLICITUD,
                                                                       Pv_UsrCreacion          => Lr_SolicitudInstalacion.USR_CREACION,
                                                                       Pn_MotivoId             => Lr_SolicitudInstalacion.MOTIVO_ID,
                                                                       Pv_EmpresaCod           => Pv_EmpresaCod,                                                                      
                                                                       Pv_MsnError             => Lv_MensajeError);
          IF Lv_MensajeError IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          -- 
          --
        ELSE
          --Insert� Historial del servicio si la �ltima milla no es FO,CO
          --Lo_ServicioHistorial := NULL;
         
          Lv_Observacion       := 'No se genera solicitud de descuento ni factura de instalaci�n puesto'||
                                  ' que el servicio no tiene asociado una �ltima milla de Fibra o Cobre';
          Lv_AplicaProceso := 'N';
          RAISE Le_Exception;        
          --
        END IF;
        --FIN Lv_UltimaMilla IS NOT NULL 
        --              
        --        
      END IF;
      --
      --Fin ( NVL(Ln_IdServicio, 0) > 0 AND NVL(Lr_GetSolicitudInstalacion.ID_DETALLE_SOLICITUD, 0) = 0 )

       Pv_Mensaje := NULL;
       Pv_AplicaProceso:=Lv_AplicaProceso;
      COMMIT;
    EXCEPTION
      WHEN Le_Exception THEN        
        ROLLBACK;
        Pv_Mensaje := Lv_MensajeError;
        Pv_AplicaProceso:=Lv_AplicaProceso;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_REINGRESO.P_FACTURACION_INSTAL_REINGRESO',
                                             Pv_Mensaje || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                             SYSDATE, 
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Lo_ServicioHistorial := NULL;
        --VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
        OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                     Cn_IdServicio  => Pn_IdServicio);
        FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
        CLOSE C_GetServicioHistorial;

        --INSERTO HISTORIAL DEL SERVICIO SI EXISTE LA OBSERVACION Y SI NO APLIC� A GENERAR FACTURA DE INSTALACI�N
        IF Lv_AplicaProceso = 'N' AND Lv_Observacion IS NOT NULL  
           AND  NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
          Lo_ServicioHistorial                       := NULL;
          Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
          Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
          Lo_ServicioHistorial.ESTADO                := 'Factible'; --Se define estado factible por defecto
          Lo_ServicioHistorial.USR_CREACION          := 'telcos_reingreso';
          Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
          Lo_ServicioHistorial.SERVICIO_ID           := Pn_IdServicio;
          DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Pv_Mensaje);
          Pv_Mensaje := NULL;          
          COMMIT;
        END IF;       

      WHEN OTHERS THEN
        ROLLBACK;
        Pv_AplicaProceso:=Lv_AplicaProceso;
        Pv_Mensaje := DBMS_UTILITY.FORMAT_ERROR_STACK || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_REINGRESO.P_FACTURACION_INSTAL_REINGRESO:',
                                             Pv_Mensaje,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                             SYSDATE, 
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END P_FACTURACION_INSTAL_REINGRESO;
    
    PROCEDURE P_EJECUTA_SERVICIOS_PREFACT(Pv_CodEmpresa IN  VARCHAR2)
    IS 
    
    --Costo: 144
    CURSOR C_Servicio (Cv_CodEmpresa            VARCHAR2,
                       Cv_EstadoFactible        VARCHAR2,
                       Cv_EstadoPreFactibilidad VARCHAR2,
                       Cv_CodProducto           VARCHAR2,
                       Cv_DescRol               VARCHAR2,
                       Cv_EsVenta               VARCHAR2,
                       Cv_CaracteristicaReing   VARCHAR2,
                       Cv_CaracteristicaFact    VARCHAR2,
                       Cv_CaracteristicaFlujo   VARCHAR2,
                       Cn_DiasPrefactible       NUMBER,
                       Cn_Frecuencia            NUMBER,
                       Cn_Numero                NUMBER) IS
      SELECT DISTINCT ISE.ID_SERVICIO,
        IP.ID_PUNTO
      FROM 
        DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC,
        DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
      WHERE ISE.ESTADO                   = Cv_EstadoFactible
      AND ISE.CANTIDAD                   > Cn_Numero
      AND ISE.ES_VENTA                   = Cv_EsVenta
      AND ISE.PRECIO_VENTA               > Cn_Numero
      AND ISE.FRECUENCIA_PRODUCTO        = Cn_Frecuencia
      AND IPD.PLAN_ID                    = ISE.PLAN_ID 
      AND AP.ID_PRODUCTO                 = IPD.PRODUCTO_ID
      AND AP.CODIGO_PRODUCTO             = Cv_CodProducto
      AND ISC.SERVICIO_ID                = ISE.ID_SERVICIO
      AND AC.ID_CARACTERISTICA           = ISC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA  = Cv_CaracteristicaReing
      AND NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaFact
                      AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                      AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA)
      AND EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaFlujo
                  AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                  AND DBISC.ESTADO                      = 'Inactivo')             
      AND IP.ID_PUNTO                    = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL            = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA                 = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL             = IPER.EMPRESA_ROL_ID
      AND IER.EMPRESA_COD                = Cv_CodEmpresa
      AND AR.ID_ROL                      = IER.ROL_ID            
      AND AR.DESCRIPCION_ROL             = Cv_DescRol
      AND ISH.SERVICIO_ID                = ISE.ID_SERVICIO
      AND ISH.ESTADO                     = Cv_EstadoPreFactibilidad
      AND TRUNC(ISH.FE_CREACION)         >= TO_DATE(SYSDATE - Cn_DiasPrefactible, 'DD/MM/RRRR');

    --Costo: 4
    CURSOR C_ObtieneDias(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                         Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                         Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE)
    IS
      SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro;

    --Costo: 4
    CURSOR C_PARAMETROS_WS(Cv_EmpresaId       VARCHAR2,
                           Cv_NombreParametro VARCHAR2,
                           Cv_Descripcion     VARCHAR2,
                           Cv_EstadoActivo    VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND CAB.ESTADO           = Cv_EstadoActivo
      AND DET.ESTADO           = Cv_EstadoActivo
      AND CAB.MODULO           = 'COMERCIAL'
      AND DET.EMPRESA_COD      = Cv_EmpresaId
      AND DET.DESCRIPCION      = Cv_Descripcion
      AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro;

    --Variables
    Lc_ParametrosWs          C_PARAMETROS_WS%ROWTYPE;
    Lv_EstadoActivo          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_EstadoFactible        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Factible';
    Lv_EstadoPreFactibilidad DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'PreFactibilidad';
    Lv_CodProducto           VARCHAR2(4) := 'INTD';
    Lv_DescripcionRol        DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := 'Cliente';
    Lv_EsVenta               VARCHAR2(1) := 'S';
    Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PARAMETROS_REINGRESO_OS_AUTOMATICA';
    Lv_DescripcionDias       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DIAS_PREFACTIBLE';
    Lv_DescripcionWs         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PARAMETROS_WEBSERVICES';
    Lv_CaracteristicaReing   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'ID_SERVICIO_REINGRESO';
    Lv_CaracteristicaFact    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FACTURACION';
    Lv_CaracteristicaFlujo   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FLUJO_COMPLETO';
    Lv_Usuario               VARCHAR2(20) := 'telcos_reingresos';
    Lv_IpCreacion            VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Error                 VARCHAR2(32000);
    Ln_DiasPrefactible       NUMBER;
    Ln_Frecuencia            NUMBER := 1;
    Ln_Numero                NUMBER := 0;
    Lc_Json                  CLOB;
    Lc_Respuesta             CLOB;
    Le_Exception             EXCEPTION;
    
  BEGIN
    
    IF C_ObtieneDias%ISOPEN THEN
    CLOSE C_ObtieneDias;
    END IF;

    IF C_PARAMETROS_WS%ISOPEN THEN
      CLOSE C_PARAMETROS_WS;
    END IF;

    OPEN C_PARAMETROS_WS(Pv_CodEmpresa,
                         Lv_NombreParametro,
                         Lv_DescripcionWs,
                         Lv_EstadoActivo);
     FETCH C_PARAMETROS_WS 
        INTO Lc_ParametrosWs;
    CLOSE C_PARAMETROS_WS;
    
    BEGIN
      OPEN C_ObtieneDias(Lv_NombreParametro,
                         Lv_DescripcionDias,
                         Lv_EstadoActivo);
      FETCH C_ObtieneDias INTO Ln_DiasPrefactible;
      CLOSE C_ObtieneDias;
    
      IF C_ObtieneDias%NOTFOUND OR Ln_DiasPrefactible = 0 THEN
        Ln_DiasPrefactible := 7;
      END IF;
    
    EXCEPTION
    WHEN OTHERS THEN
      Ln_DiasPrefactible := 7;
    END;

    FOR Lr_Servicio IN C_Servicio(Pv_CodEmpresa,
                                  Lv_EstadoFactible,
                                  Lv_EstadoPreFactibilidad,
                                  Lv_CodProducto,
                                  Lv_DescripcionRol,
                                  Lv_EsVenta,
                                  Lv_CaracteristicaReing,
                                  Lv_CaracteristicaFact,
                                  Lv_CaracteristicaFlujo,
                                  Ln_DiasPrefactible,
                                  Ln_Frecuencia,
                                  Ln_Numero)
    LOOP
      BEGIN
        
        Lc_Json := '';
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('op', Lc_ParametrosWs.VALOR2);
        APEX_JSON.OPEN_OBJECT('data');
        APEX_JSON.WRITE('strCodEmpresa', Pv_CodEmpresa);
        APEX_JSON.WRITE('intIdServicioNuevo', Lr_Servicio.ID_SERVICIO);
        APEX_JSON.WRITE('intIdPunto', Lr_Servicio.ID_PUNTO);
        APEX_JSON.WRITE('strUsuario', Lv_Usuario);
        APEX_JSON.WRITE('strIp', Lv_IpCreacion);
        APEX_JSON.OPEN_ARRAY('strFlujoCompleto');
        APEX_JSON.WRITE('facturacion');
        APEX_JSON.WRITE('ordenTrabajo');
        APEX_JSON.CLOSE_ARRAY();
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lc_ParametrosWs.VALOR1,
                                                  Pcl_Mensaje        => Lc_Json,
                                                  Pv_Application     => Lc_ParametrosWs.VALOR3,
                                                  Pv_Charset         => Lc_ParametrosWs.VALOR4,
                                                  Pv_UrlFileDigital  => null,
                                                  Pv_PassFileDigital => null,
                                                  Pcl_Respuesta      => Lc_Respuesta,
                                                  Pv_Error           => Lv_Error);
        IF Lv_Error IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;

      EXCEPTION
      WHEN Le_Exception THEN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_REINGRESO.P_EJECUTA_SERVICIOS_PREFACT',
                                             'Ocurri� un error al ejecutar el servicio ' || Lr_Servicio.ID_SERVICIO ||
                                             ' -' || Lv_Error,
                                             Lv_Usuario,
                                             SYSDATE,
                                             Lv_IpCreacion);
      WHEN OTHERS THEN

        Lv_Error := 'Ocurri� un error al ejecutar el servicio ' || Lr_Servicio.ID_SERVICIO ||
                    ' para retomar las ordene de servicio reingresada.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_REINGRESO.P_EJECUTA_SERVICIOS_PREFACT',
                                             Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                             Lv_Usuario,
                                             SYSDATE,
                                             Lv_IpCreacion);
      END;      
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN

    Lv_Error := 'Ocurri� un error al ejecutar el proceso masivo para retomar las ordenes de servicios reingresadas.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'CMKG_REINGRESO.P_EJECUTA_SERVICIOS_PREFACT',
                                         Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_Usuario,
                                         SYSDATE,
                                         Lv_IpCreacion);

  END P_EJECUTA_SERVICIOS_PREFACT;

  PROCEDURE P_EJECUTA_SERVICIOS_FACT(Pv_CodEmpresa IN  VARCHAR2)
  IS 
    
    --Costo: 144
    CURSOR C_Servicio (Cv_CodEmpresa            VARCHAR2,
                       Cv_EstadoActivo          VARCHAR2,
                       Cv_EstadoFactible        VARCHAR2,
                       Cv_CodProducto           VARCHAR2,
                       Cv_DescRol               VARCHAR2,
                       Cv_EsVenta               VARCHAR2,
                       Cv_CaracteristicaReing   VARCHAR2,
                       Cv_CaracteristicaFact    VARCHAR2,
                       Cv_CaracteristicaFlujo   VARCHAR2,
                       Cn_DiasPrefactible       NUMBER,
                       Cn_Frecuencia            NUMBER,
                       Cn_Numero                NUMBER) IS
      SELECT DISTINCT ISE.ID_SERVICIO,
        IP.ID_PUNTO
      FROM 
        DB_COMERCIAL.INFO_SERVICIO ISE,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC,
        DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
      WHERE ISE.ESTADO                   = Cv_EstadoFactible
      AND ISE.CANTIDAD                   > Cn_Numero
      AND ISE.ES_VENTA                   = Cv_EsVenta
      AND ISE.PRECIO_VENTA               > Cn_Numero
      AND ISE.FRECUENCIA_PRODUCTO        = Cn_Frecuencia
      AND IPD.PLAN_ID                    = ISE.PLAN_ID 
      AND AP.ID_PRODUCTO                 = IPD.PRODUCTO_ID
      AND AP.CODIGO_PRODUCTO             = Cv_CodProducto
      AND ISC.SERVICIO_ID                = ISE.ID_SERVICIO
      AND AC.ID_CARACTERISTICA           = ISC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA  = Cv_CaracteristicaReing
      AND EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaFact
                  AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                  AND DBISC.ESTADO                      = Cv_EstadoActivo)
      AND EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaFlujo
                  AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                  AND DBISC.ESTADO                      = 'Inactivo')    
      AND IP.ID_PUNTO                    = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL            = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA                 = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL             = IPER.EMPRESA_ROL_ID
      AND IER.EMPRESA_COD                = Cv_CodEmpresa
      AND AR.ID_ROL                      = IER.ROL_ID
      AND AR.DESCRIPCION_ROL             = Cv_DescRol
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CMKG_REINGRESO.F_GET_CARACT_SERVICIO(ISE.ID_SERVICIO,'CONT_INTENTOS_REINGRESO_OS'),'^\d+')),0)
       < (SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(VALOR1,'^\d+')),0) FROM 
                    DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
                    DB_GENERAL.ADMI_PARAMETRO_DET APDET
                    WHERE 
                    APCAB.NOMBRE_PARAMETRO     = 'PARAMETROS_REINGRESO_OS_AUTOMATICA'
                    AND APDET.DESCRIPCION      = 'NUM_INTENTOS_REINGRESO_OS'
                    AND APCAB.ID_PARAMETRO     = APDET.PARAMETRO_ID
                    AND APCAB.ESTADO           = 'Activo'
                    AND APDET.ESTADO           = 'Activo');

    --Costo: 4
    CURSOR C_ObtieneDias(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                         Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                         Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE)
    IS
      SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro;

    --Costo: 4
    CURSOR C_PARAMETROS_WS(Cv_EmpresaId       VARCHAR2,
                           Cv_NombreParametro VARCHAR2,
                           Cv_Descripcion     VARCHAR2,
                           Cv_EstadoActivo    VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND CAB.ESTADO           = Cv_EstadoActivo
      AND DET.ESTADO           = Cv_EstadoActivo
      AND CAB.MODULO           = 'COMERCIAL'
      AND DET.EMPRESA_COD      = Cv_EmpresaId
      AND DET.DESCRIPCION      = Cv_Descripcion
      AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro;

    --Variables
    Lc_ParametrosWs          C_PARAMETROS_WS%ROWTYPE;
    Lv_EstadoActivo          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_EstadoFactible        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Factible';
    Lv_CodProducto           VARCHAR2(4) := 'INTD';
    Lv_DescripcionRol        DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := 'Cliente';
    Lv_EsVenta               VARCHAR2(1) := 'S';
    Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PARAMETROS_REINGRESO_OS_AUTOMATICA';
    Lv_DescripcionDias       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DIAS_PREFACTIBLE';
    Lv_DescripcionWs         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PARAMETROS_WEBSERVICES';
    Lv_CaracteristicaReing   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'ID_SERVICIO_REINGRESO';
    Lv_CaracteristicaFact    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FACTURACION';
    Lv_CaracteristicaFlujo   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FLUJO_COMPLETO';
    Lv_Usuario               VARCHAR2(20) := 'telcos_reingresos';
    Lv_IpCreacion            VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Error                 VARCHAR2(32000);
    Ln_DiasPrefactible       NUMBER;
    Ln_Frecuencia            NUMBER := 1;
    Ln_Numero                NUMBER := 0;
    Lc_Json                  CLOB;
    Lc_Respuesta             CLOB;
    Le_Exception             EXCEPTION;

  BEGIN

    IF C_ObtieneDias%ISOPEN THEN
    CLOSE C_ObtieneDias;
    END IF;

    IF C_PARAMETROS_WS%ISOPEN THEN
      CLOSE C_PARAMETROS_WS;
    END IF;

    OPEN C_PARAMETROS_WS(Pv_CodEmpresa,
                         Lv_NombreParametro,
                         Lv_DescripcionWs,
                         Lv_EstadoActivo);
     FETCH C_PARAMETROS_WS 
        INTO Lc_ParametrosWs;
    CLOSE C_PARAMETROS_WS;

    BEGIN
      OPEN C_ObtieneDias(Lv_NombreParametro,
                         Lv_DescripcionDias,
                         Lv_EstadoActivo);
      FETCH C_ObtieneDias INTO Ln_DiasPrefactible;
      CLOSE C_ObtieneDias;

      IF C_ObtieneDias%NOTFOUND OR Ln_DiasPrefactible = 0 THEN
        Ln_DiasPrefactible := 7;
      END IF;

    EXCEPTION
    WHEN OTHERS THEN
      Ln_DiasPrefactible := 7;
    END;

    FOR Lr_Servicio IN C_Servicio(Pv_CodEmpresa,
                                  Lv_EstadoActivo,
                                  Lv_EstadoFactible,
                                  Lv_CodProducto,
                                  Lv_DescripcionRol,
                                  Lv_EsVenta,
                                  Lv_CaracteristicaReing,
                                  Lv_CaracteristicaFact,
                                  Lv_CaracteristicaFlujo,
                                  Ln_DiasPrefactible,
                                  Ln_Frecuencia,
                                  Ln_Numero)
    LOOP
      BEGIN      

        Lc_Json := '';
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('op', Lc_ParametrosWs.VALOR2);
        APEX_JSON.OPEN_OBJECT('data');
        APEX_JSON.WRITE('strCodEmpresa', Pv_CodEmpresa);
        APEX_JSON.WRITE('intIdServicioNuevo', Lr_Servicio.ID_SERVICIO);
        APEX_JSON.WRITE('intIdPunto', Lr_Servicio.ID_PUNTO);
        APEX_JSON.WRITE('strUsuario', Lv_Usuario);
        APEX_JSON.WRITE('strIp', Lv_IpCreacion);
        APEX_JSON.OPEN_ARRAY('strFlujoCompleto');
        APEX_JSON.WRITE('facturacion');
        APEX_JSON.WRITE('ordenTrabajo');
        APEX_JSON.CLOSE_ARRAY();
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lc_ParametrosWs.VALOR1,
                                                  Pcl_Mensaje        => Lc_Json,
                                                  Pv_Application     => Lc_ParametrosWs.VALOR3,
                                                  Pv_Charset         => Lc_ParametrosWs.VALOR4,
                                                  Pv_UrlFileDigital  => null,
                                                  Pv_PassFileDigital => null,
                                                  Pcl_Respuesta      => Lc_Respuesta,
                                                  Pv_Error           => Lv_Error);
        IF Lv_Error IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;

      EXCEPTION
      WHEN Le_Exception THEN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_REINGRESO.P_EJECUTA_SERVICIOS_FACT',
                                             'Ocurri� un error al ejecutar el servicio ' || Lr_Servicio.ID_SERVICIO ||
                                             ' -' || Lv_Error,
                                             Lv_Usuario,
                                             SYSDATE,
                                             Lv_IpCreacion);
      WHEN OTHERS THEN

        Lv_Error := 'Ocurri� un error al ejecutar el servicio ' || Lr_Servicio.ID_SERVICIO || 
                    ' para retomar las ordene de servicio reingresada.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_REINGRESO.P_EJECUTA_SERVICIOS_FACT',
                                             Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                             Lv_Usuario,
                                             SYSDATE,
                                             Lv_IpCreacion);
      END;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN

    Lv_Error := 'Ocurri� un error al ejecutar el proceso masivo para retomar las ordenes de servicios reingresadas.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_REINGRESO.P_EJECUTA_SERVICIOS_FACT', 
                                         Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_Usuario,
                                         SYSDATE,
                                         Lv_IpCreacion);

  END P_EJECUTA_SERVICIOS_FACT;

  PROCEDURE P_PENDIENTE_CONVERTIR_OT(Pv_CodEmpresa IN  VARCHAR2)
  IS 

    --Costo: 144
    CURSOR C_Servicio (Cv_CodEmpresa            VARCHAR2,
                       Cv_EstadoActivo          VARCHAR2,
                       Cv_EstadoInactivo        VARCHAR2,
                       Cv_EstadoFactible        VARCHAR2,
                       Cv_CodProducto           VARCHAR2,
                       Cv_DescRol               VARCHAR2,
                       Cv_EsVenta               VARCHAR2,
                       Cv_CaracteristicaReing   VARCHAR2,
                       Cv_CaracteristicaFact    VARCHAR2,
                       Cv_CaracteristicaOT      VARCHAR2,
                       Cv_CaracteristicaFlujo   VARCHAR2,
                       Cn_Frecuencia            NUMBER,
                       Cn_Numero                NUMBER) IS
      SELECT DISTINCT ISE.ID_SERVICIO,
        IP.ID_PUNTO
      FROM 
        DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC,
        DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
      WHERE ISE.ESTADO                   = Cv_EstadoFactible
      AND ISE.CANTIDAD                   > Cn_Numero
      AND ISE.ES_VENTA                   = Cv_EsVenta
      AND ISE.PRECIO_VENTA               > Cn_Numero
      AND ISE.FRECUENCIA_PRODUCTO        = Cn_Frecuencia
      AND IPD.PLAN_ID                    = ISE.PLAN_ID 
      AND AP.ID_PRODUCTO                 = IPD.PRODUCTO_ID
      AND AP.CODIGO_PRODUCTO             = Cv_CodProducto
      AND ISC.SERVICIO_ID                = ISE.ID_SERVICIO
      AND AC.ID_CARACTERISTICA           = ISC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA  = Cv_CaracteristicaReing
      AND EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaFact
                  AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                  AND DBISC.ESTADO                      = Cv_EstadoInactivo)
      AND EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaFlujo
                  AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                  AND DBISC.ESTADO                      = Cv_EstadoInactivo) 
      AND (EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaOT
                  AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA
                  AND DBISC.ESTADO                      = Cv_EstadoActivo) OR
            NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                              FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                                DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                              WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaOT
                              AND DBISC.SERVICIO_ID                 = ISE.ID_SERVICIO
                              AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA))
      AND IP.ID_PUNTO                    = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL            = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA                 = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL             = IPER.EMPRESA_ROL_ID
      AND IER.EMPRESA_COD                = Cv_CodEmpresa
      AND AR.ID_ROL                      = IER.ROL_ID
      AND AR.DESCRIPCION_ROL             = Cv_DescRol
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CMKG_REINGRESO.F_GET_CARACT_SERVICIO(ISE.ID_SERVICIO,'CONT_INTENTOS_REINGRESO_OS'),'^\d+')),0)
      < (SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(VALOR1,'^\d+')),0) FROM 
                    DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
                    DB_GENERAL.ADMI_PARAMETRO_DET APDET
                    WHERE 
                    APCAB.NOMBRE_PARAMETRO     = 'PARAMETROS_REINGRESO_OS_AUTOMATICA'
                    AND APDET.DESCRIPCION      = 'NUM_INTENTOS_REINGRESO_OS'
                    AND APCAB.ID_PARAMETRO     = APDET.PARAMETRO_ID
                    AND APCAB.ESTADO           = 'Activo'
                    AND APDET.ESTADO           = 'Activo');

    --Costo: 4
    CURSOR C_PARAMETROS_WS(Cv_EmpresaId       VARCHAR2,
                           Cv_NombreParametro VARCHAR2,
                           Cv_Descripcion     VARCHAR2,
                           Cv_EstadoActivo    VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND CAB.ESTADO           = Cv_EstadoActivo
      AND DET.ESTADO           = Cv_EstadoActivo
      AND CAB.MODULO           = 'COMERCIAL'
      AND DET.EMPRESA_COD      = Cv_EmpresaId
      AND DET.DESCRIPCION      = Cv_Descripcion
      AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro;

    --Variables
    Lc_ParametrosWs          C_PARAMETROS_WS%ROWTYPE;
    Lv_EstadoActivo          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_EstadoInactivo        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Inactivo';
    Lv_EstadoFactible        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Factible';
    Lv_CaracReingreso        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'ID_SERVICIO_REINGRESO';
    Lv_CaracteristicaFact    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FACTURACION';
    Lv_CaracNoPasoOT         DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'NO_PASO_CONVERTIR_OT';
    Lv_CaracteristicaFlujo   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FLUJO_COMPLETO';
    Lv_CodProducto           VARCHAR2(4) := 'INTD';
    Lv_DescripcionRol        DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := 'Cliente';
    Lv_EsVenta               VARCHAR2(1) := 'S';
    Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PARAMETROS_REINGRESO_OS_AUTOMATICA';
    Lv_DescripcionWs         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PARAMETROS_WEBSERVICES';
    Lv_Usuario               VARCHAR2(20) := 'telcos_reingresos';
    Lv_IpCreacion            VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Error                 VARCHAR2(32000);
    Ln_Frecuencia            NUMBER := 1;
    Ln_Numero                NUMBER := 0;
    Lc_Json                  CLOB;
    Lc_Respuesta             CLOB;
    Le_Exception             EXCEPTION;

  BEGIN

    IF C_PARAMETROS_WS%ISOPEN THEN
      CLOSE C_PARAMETROS_WS;
    END IF;

    OPEN C_PARAMETROS_WS(Pv_CodEmpresa,
                         Lv_NombreParametro,
                         Lv_DescripcionWs,
                         Lv_EstadoActivo);
     FETCH C_PARAMETROS_WS 
        INTO Lc_ParametrosWs;
    CLOSE C_PARAMETROS_WS;

    FOR Lr_Servicio IN C_Servicio(Pv_CodEmpresa,
                                  Lv_EstadoActivo,
                                  Lv_EstadoInactivo,
                                  Lv_EstadoFactible,
                                  Lv_CodProducto,
                                  Lv_DescripcionRol,
                                  Lv_EsVenta,
                                  Lv_CaracReingreso,
                                  Lv_CaracteristicaFact,
                                  Lv_CaracNoPasoOT,
                                  Lv_CaracteristicaFlujo,
                                  Ln_Frecuencia,
                                  Ln_Numero)
    LOOP

      BEGIN

        Lc_Json := '';
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('op', Lc_ParametrosWs.VALOR2);
        APEX_JSON.OPEN_OBJECT('data');
        APEX_JSON.WRITE('strCodEmpresa', Pv_CodEmpresa);
        APEX_JSON.WRITE('intIdServicioNuevo', Lr_Servicio.ID_SERVICIO);
        APEX_JSON.WRITE('intIdPunto', Lr_Servicio.ID_PUNTO);
        APEX_JSON.WRITE('strUsuario', Lv_Usuario);
        APEX_JSON.WRITE('strIp', Lv_IpCreacion);
        APEX_JSON.OPEN_ARRAY('strFlujoCompleto');
        APEX_JSON.WRITE('ordenTrabajo');
        APEX_JSON.CLOSE_ARRAY();
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lc_ParametrosWs.VALOR1,
                                                  Pcl_Mensaje        => Lc_Json,
                                                  Pv_Application     => Lc_ParametrosWs.VALOR3,
                                                  Pv_Charset         => Lc_ParametrosWs.VALOR4,
                                                  Pv_UrlFileDigital  => null,
                                                  Pv_PassFileDigital => null,
                                                  Pcl_Respuesta      => Lc_Respuesta,
                                                  Pv_Error           => Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;

      EXCEPTION
      WHEN Le_Exception THEN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_REINGRESO.P_PENDIENTE_CONVERTIR_OT',
                                             'Ocurri� un error al ejecutar el servicio ' || Lr_Servicio.ID_SERVICIO ||
                                             ' -' || Lv_Error,
                                             Lv_Usuario,
                                             SYSDATE,
                                             Lv_IpCreacion);
      WHEN OTHERS THEN

        Lv_Error := 'Ocurri� un error al ejecutar el servicio ' || Lr_Servicio.ID_SERVICIO ||
                    ' para retomar las ordene de servicio reingresada.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_REINGRESO.P_PENDIENTE_CONVERTIR_OT',
                                             Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                             Lv_Usuario,
                                             SYSDATE,
                                             Lv_IpCreacion);
      END;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN

    Lv_Error := 'Ocurri� un error al ejecutar el proceso masivo para retomar las ordenes de servicios reingresadas.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_REINGRESO.P_PENDIENTE_CONVERTIR_OT', 
                                         Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_Usuario,
                                         SYSDATE,
                                         Lv_IpCreacion);

  END P_PENDIENTE_CONVERTIR_OT;

  PROCEDURE P_REPORTE_REINGRESO (Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS

    --Costo: 26  
    CURSOR C_GetDatosServicios (Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Cv_EstadoAnulado        VARCHAR2,
                                Cv_EstadoRechazada      VARCHAR2,
                                Cv_EstadoPrePlanificada VARCHAR2,
                                Cv_EstadoActivo         VARCHAR2,
                                Cv_CaracCanal           VARCHAR2,
                                Cv_CaracReingreso       VARCHAR2,
                                Cv_NombreParametro      VARCHAR2,
                                Cn_Dias                 NUMBER)
    IS
      SELECT DISTINCT CASE
        WHEN DBIP.RAZON_SOCIAL IS NULL
        THEN DBIP.NOMBRES
            ||' '
            || DBIP.APELLIDOS
        ELSE DBIP.RAZON_SOCIAL
        END AS CLIENTE,
        DBIP.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
        PUNTO.LOGIN,
        TO_CHAR(RECHAZ.FE_CREACION,'RRRR-MM-DD HH24:MI:SS') AS FE_CREACION_OSI,
        (SELECT AMOTIVO.NOMBRE_MOTIVO
         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SERVICIOH,
           DB_GENERAL.ADMI_MOTIVO AMOTIVO
         WHERE AMOTIVO.ID_MOTIVO             = SERVICIOH.MOTIVO_ID
         AND SERVICIOH.ID_SERVICIO_HISTORIAL IN (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL)
                                                 FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH
                                                 WHERE DBISH.SERVICIO_ID = RECHAZ.ID_SERVICIO
                                                 AND MOTIVO_ID IS NOT NULL
                                                 AND UPPER(DBISH.ESTADO) IN (Cv_EstadoRechazada,Cv_EstadoAnulado))) AS MOTIVO_OSI,
        TO_CHAR(ISERV.FE_CREACION,'RRRR-MM-DD HH24:MI:SS') AS FE_CREACION_OSR,
        (SELECT TO_CHAR(SERVICIOH.OBSERVACION)
         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SERVICIOH
         WHERE SERVICIOH.ID_SERVICIO_HISTORIAL IN (SELECT MIN(DBISH.ID_SERVICIO_HISTORIAL)
                                                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH 
                                                   WHERE DBISH.SERVICIO_ID = ISERV.ID_SERVICIO
                                                   AND DBISH.ESTADO        = Cv_EstadoPrePlanificada)) AS OBSERVACION_OSR,
        ISERV.ESTADO AS ESTADO_OSR,
        (SELECT TO_CHAR(SERVICIOH.FE_CREACION,'RRRR-MM-DD HH24:MI:SS')
         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SERVICIOH
         WHERE SERVICIOH.ID_SERVICIO_HISTORIAL IN (SELECT MIN(DBISH.ID_SERVICIO_HISTORIAL)
                                                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH 
                                                   WHERE DBISH.SERVICIO_ID = ISERV.ID_SERVICIO
                                                   AND DBISH.ESTADO        = Cv_EstadoPrePlanificada)) AS FECHA_PREPLANIFICACION_OSR,
        (SELECT DBAJ.NOMBRE_JURISDICCION 
         FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION DBAJ 
         WHERE ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID) AS JURISDICCION_OSR,
        ISERV.USR_VENDEDOR AS USUARIO_VENDEDOR_OSR,
        (SELECT APD.VALOR2
         FROM  DB_COMERCIAL.ADMI_CARACTERISTICA ACAR,
           DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC,
           DB_GENERAL.ADMI_PARAMETRO_CAB APC,
           DB_GENERAL.ADMI_PARAMETRO_DET APD
         WHERE ACAR.DESCRIPCION_CARACTERISTICA     = Cv_CaracCanal
         AND IPC.PUNTO_ID                          = PUNTO.ID_PUNTO 
         AND IPC.CARACTERISTICA_ID                 = ACAR.ID_CARACTERISTICA
         AND APC.NOMBRE_PARAMETRO                  = Cv_NombreParametro
         AND APC.ESTADO                            = Cv_EstadoActivo
         AND APD.PARAMETRO_ID                      = APC.ID_PARAMETRO
         AND APD.ESTADO                            = Cv_EstadoActivo
         AND APD.VALOR1                            = TO_CHAR(IPC.VALOR)) AS CANAL_OSR,
        (SELECT APD.VALOR4 
         FROM  DB_COMERCIAL.ADMI_CARACTERISTICA ACAR,
           DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC,
           DB_GENERAL.ADMI_PARAMETRO_CAB APC,
           DB_GENERAL.ADMI_PARAMETRO_DET APD
         WHERE ACAR.DESCRIPCION_CARACTERISTICA     = Cv_CaracCanal
         AND IPC.PUNTO_ID                          = PUNTO.ID_PUNTO 
         AND IPC.CARACTERISTICA_ID                 = ACAR.ID_CARACTERISTICA
         AND APC.NOMBRE_PARAMETRO                  = Cv_NombreParametro
         AND APC.ESTADO                            = Cv_EstadoActivo
         AND APD.PARAMETRO_ID                      = APC.ID_PARAMETRO
         AND APD.ESTADO                            = Cv_EstadoActivo
         AND APD.VALOR1                            = TO_CHAR(IPC.VALOR)) AS PUNTO_VENTA_OSR,
         (SELECT CONTRATO.ORIGEN 
          FROM DB_COMERCIAL.INFO_CONTRATO CONTRATO
          WHERE CONTRATO.ID_CONTRATO IN (SELECT MAX(ID_CONTRATO)
                                         FROM DB_COMERCIAL.INFO_CONTRATO DBIC
                                         WHERE DBIC.PERSONA_EMPRESA_ROL_ID = DBIPER.ID_PERSONA_ROL)) AS ORIGEN_OSR
      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH,
        DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO RECHAZ RIGHT JOIN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
          ON RECHAZ.ID_SERVICIO = TO_NUMBER(ISC.VALOR),
        DB_COMERCIAL.ADMI_CARACTERISTICA ACAR,
        DB_COMERCIAL.INFO_PUNTO PUNTO,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL DBIPER,
        DB_COMERCIAL.INFO_PERSONA DBIP,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE IER.EMPRESA_COD                     = Cv_CodEmpresa
      AND DBIPER.EMPRESA_ROL_ID                 = IER.ID_EMPRESA_ROL
      AND ISH.ID_SERVICIO_HISTORIAL IN (SELECT MIN(DBISH.ID_SERVICIO_HISTORIAL)
                                                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH 
                                                   WHERE DBISH.SERVICIO_ID = ISERV.ID_SERVICIO
                                                   AND DBISH.ESTADO        = Cv_EstadoPrePlanificada)
      AND ISH.ESTADO                            = Cv_EstadoPrePlanificada
      AND ISH.FE_CREACION                       BETWEEN TRUNC(SYSDATE - NVL(Cn_Dias,1))
                                                AND TRUNC(SYSDATE) - INTERVAL '1' SECOND
      AND ISERV.ID_SERVICIO                     = ISH.SERVICIO_ID
      AND ISC.SERVICIO_ID                       = ISERV.ID_SERVICIO
      AND ACAR.DESCRIPCION_CARACTERISTICA       = Cv_CaracReingreso
      AND ISC.CARACTERISTICA_ID                 = ACAR.ID_CARACTERISTICA
      AND PUNTO.ID_PUNTO                        = ISERV.PUNTO_ID
      AND DBIPER.ID_PERSONA_ROL                 = PUNTO.PERSONA_EMPRESA_ROL_ID
      AND DBIP.ID_PERSONA                       = DBIPER.PERSONA_ID;

    --Costo: 4  
    CURSOR C_ObtieneDias(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                         Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                         Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE)
    IS
      SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro;
    --
    Lv_EstadoActivo          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_EstadoAnulado         DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'ANULADO';    
    Lv_EstadoRechazada       DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'RECHAZADA'; 
    Lv_EstadoPrePlanificada  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'PrePlanificada'; 
    Lv_CaracCanal            DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PUNTO_DE_VENTA_CANAL';
    Lv_CaracReingreso        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'ID_SERVICIO_REINGRESO';
    Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'CANALES_PUNTO_VENTA';
    Lv_NombreParametroDias   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PARAMETROS_REINGRESO_OS_AUTOMATICA';
    Lv_Descripcion           DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DIAS_REPORTE';
    Ln_Dias                  NUMBER;    
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ',';
    Lv_Remitente             VARCHAR2(100)   := 'notificaciones_telcos@telconet.ec';
    Lv_Asunto                VARCHAR2(300)   := 'Reporte Ordenes de Servicios Reingresados';
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_AliasCorreos          VARCHAR2(500);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

  BEGIN
    --
    IF C_ObtieneDias%ISOPEN THEN
      CLOSE C_ObtieneDias;
    END IF;

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_OS_REINGR');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
    Lv_NombreArchivo     := 'ReporteServiciosReingresos_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

    OPEN C_ObtieneDias(Lv_NombreParametroDias,
                       Lv_Descripcion,
                       Lv_EstadoActivo);
    FETCH C_ObtieneDias INTO Ln_Dias;
    CLOSE C_ObtieneDias;

    utl_file.put_line(Lfile_Archivo,'REPORTE SERVICIOS REINGRESADOS'||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador
                      ||' '||Lv_Delimitador );
    utl_file.put_line(Lfile_Archivo,'CLIENTE'||Lv_Delimitador
                      ||'IDENTIFICACION'||Lv_Delimitador
                      ||'LOGIN'||Lv_Delimitador
                      ||'FE_CREACI�N O/S INICIAL'||Lv_Delimitador
                      ||'MOTIVO DE RECHAZO DE O/S INICIAL'||Lv_Delimitador
                      ||'FE_CREACI�N DE O/S REINGRESO'||Lv_Delimitador
                      ||'OBSERVACION REINGRESO'||Lv_Delimitador
                      ||'ESTADO REINGRESO'||Lv_Delimitador
                      ||'FECHA PRE-PLANIFICACION'||Lv_Delimitador
                      ||'JURISDICCION'||Lv_Delimitador 
                      ||'USUARIO VENDEDOR'||Lv_Delimitador
                      ||'CANAL'||Lv_Delimitador
                      ||'PUNTO DE VENTA'||Lv_Delimitador
                      ||'ORIGEN'||Lv_Delimitador);

    FOR Lr_GetDatosServicios IN C_GetDatosServicios(Pv_CodEmpresa,
                                                    Lv_EstadoAnulado,
                                                    Lv_EstadoRechazada,
                                                    Lv_EstadoPrePlanificada,
                                                    Lv_EstadoActivo,
                                                    Lv_CaracCanal,
                                                    Lv_CaracReingreso,
                                                    Lv_NombreParametro,
                                                    Ln_Dias) LOOP
        --

        UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_GetDatosServicios.CLIENTE, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.IDENTIFICACION, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.LOGIN, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.FE_CREACION_OSI, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.MOTIVO_OSI, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.FE_CREACION_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.OBSERVACION_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.ESTADO_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.FECHA_PREPLANIFICACION_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.JURISDICCION_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.USUARIO_VENDEDOR_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.CANAL_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.PUNTO_VENTA_OSR, '')||Lv_Delimitador
                          ||NVL(Lr_GetDatosServicios.ORIGEN_OSR, '')||Lv_Delimitador);
    --
    END LOOP;

    UTL_FILE.fclose(Lfile_Archivo);
    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip,
                                              'text/html; charset=UTF-8');

    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte de ordenes de servicios reingresados.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_REINGRESO.P_REPORTE_REINGRESO', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reingresos',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  END P_REPORTE_REINGRESO;

  PROCEDURE P_UPDATE_INFO_SERVICIO(Pr_InfoServicio   IN DB_COMERCIAL.INFO_SERVICIO%ROWTYPE,
                                   Pv_MsjResultado   OUT VARCHAR2)
  IS
  BEGIN
    --
    UPDATE DB_COMERCIAL.INFO_SERVICIO
    SET
      PUNTO_ID                       = NVL(Pr_InfoServicio.PUNTO_ID,PUNTO_ID),
      PRODUCTO_ID                    = NVL(Pr_InfoServicio.PRODUCTO_ID,PRODUCTO_ID),
      PLAN_ID                        = NVL(Pr_InfoServicio.PLAN_ID,PLAN_ID),
      ORDEN_TRABAJO_ID               = NVL(Pr_InfoServicio.ORDEN_TRABAJO_ID,ORDEN_TRABAJO_ID),
      CICLO_ID                       = NVL(Pr_InfoServicio.CICLO_ID,CICLO_ID),
      INTERFACE_ELEMENTO_ID          = NVL(Pr_InfoServicio.INTERFACE_ELEMENTO_ID,INTERFACE_ELEMENTO_ID),
      ES_VENTA                       = NVL(Pr_InfoServicio.ES_VENTA,ES_VENTA),
      CANTIDAD                       = NVL(Pr_InfoServicio.CANTIDAD,CANTIDAD),
      PRECIO_VENTA                   = NVL(Pr_InfoServicio.PRECIO_VENTA,PRECIO_VENTA),
      COSTO                          = NVL(Pr_InfoServicio.COSTO,COSTO),
      PORCENTAJE_DESCUENTO           = NVL(Pr_InfoServicio.PORCENTAJE_DESCUENTO,PORCENTAJE_DESCUENTO),
      VALOR_DESCUENTO                = NVL(Pr_InfoServicio.VALOR_DESCUENTO,VALOR_DESCUENTO),
      DIAS_GRACIA                    = NVL(Pr_InfoServicio.DIAS_GRACIA,DIAS_GRACIA),
      FRECUENCIA_PRODUCTO            = NVL(Pr_InfoServicio.FRECUENCIA_PRODUCTO,FRECUENCIA_PRODUCTO),
      MESES_RESTANTES                = NVL(Pr_InfoServicio.MESES_RESTANTES,MESES_RESTANTES),
      DESCRIPCION_PRESENTA_FACTURA   = NVL(Pr_InfoServicio.DESCRIPCION_PRESENTA_FACTURA,DESCRIPCION_PRESENTA_FACTURA),
      FE_VIGENCIA                    = NVL(Pr_InfoServicio.FE_VIGENCIA,FE_VIGENCIA),
      ESTADO                         = NVL(Pr_InfoServicio.ESTADO,ESTADO),
      FE_CREACION                    = NVL(Pr_InfoServicio.FE_CREACION,FE_CREACION),
      USR_CREACION                   = NVL(Pr_InfoServicio.USR_CREACION,USR_CREACION),
      IP_CREACION                    = NVL(Pr_InfoServicio.IP_CREACION,IP_CREACION),
      PUNTO_FACTURACION_ID           = NVL(Pr_InfoServicio.PUNTO_FACTURACION_ID,PUNTO_FACTURACION_ID),
      ELEMENTO_ID                    = NVL(Pr_InfoServicio.ELEMENTO_ID,ELEMENTO_ID),
      ULTIMA_MILLA_ID                = NVL(Pr_InfoServicio.ULTIMA_MILLA_ID,ULTIMA_MILLA_ID),
      TIPO_ORDEN                     = NVL(Pr_InfoServicio.TIPO_ORDEN,TIPO_ORDEN),
      OBSERVACION                    = NVL(Pr_InfoServicio.OBSERVACION,OBSERVACION),
      ELEMENTO_CLIENTE_ID            = NVL(Pr_InfoServicio.ELEMENTO_CLIENTE_ID,ELEMENTO_CLIENTE_ID),
      INTERFACE_ELEMENTO_CLIENTE_ID  = NVL(Pr_InfoServicio.INTERFACE_ELEMENTO_CLIENTE_ID,INTERFACE_ELEMENTO_CLIENTE_ID),
      REF_SERVICIO_ID                = NVL(Pr_InfoServicio.REF_SERVICIO_ID,REF_SERVICIO_ID),
      LOGIN_AUX                      = NVL(Pr_InfoServicio.LOGIN_AUX,LOGIN_AUX),
      PRECIO_FORMULA                 = NVL(Pr_InfoServicio.PRECIO_FORMULA,PRECIO_FORMULA),
      PRECIO_INSTALACION             = NVL(Pr_InfoServicio.PRECIO_INSTALACION,PRECIO_INSTALACION),
      USR_VENDEDOR                   = NVL(Pr_InfoServicio.USR_VENDEDOR,USR_VENDEDOR),
      DESCUENTO_UNITARIO             = NVL(Pr_InfoServicio.DESCUENTO_UNITARIO,DESCUENTO_UNITARIO),
      ORIGEN                         = NVL(Pr_InfoServicio.ORIGEN,ORIGEN)
    WHERE ID_SERVICIO   = NVL(Pr_InfoServicio.ID_SERVICIO,ID_SERVICIO);
  --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_INFO_SERVICIO - ' || SQLERRM;
  --
  END P_UPDATE_INFO_SERVICIO;
  
  PROCEDURE P_UPDATE_INFO_DETALLE_SOL(Pr_InfoDetalleSolicitud  IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                      Pv_MsjResultado          OUT VARCHAR2)
  IS
  BEGIN
    --
    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    SET
      SERVICIO_ID           = NVL(Pr_InfoDetalleSolicitud.SERVICIO_ID,SERVICIO_ID),
      TIPO_SOLICITUD_ID     = NVL(Pr_InfoDetalleSolicitud.TIPO_SOLICITUD_ID,TIPO_SOLICITUD_ID),
      MOTIVO_ID             = NVL(Pr_InfoDetalleSolicitud.MOTIVO_ID,MOTIVO_ID),
      USR_CREACION          = NVL(Pr_InfoDetalleSolicitud.USR_CREACION,USR_CREACION),
      FE_CREACION           = NVL(Pr_InfoDetalleSolicitud.FE_CREACION,FE_CREACION),  
      PRECIO_DESCUENTO      = NVL(Pr_InfoDetalleSolicitud.PRECIO_DESCUENTO,PRECIO_DESCUENTO),
      PORCENTAJE_DESCUENTO  = NVL(Pr_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO,PORCENTAJE_DESCUENTO),
      TIPO_DOCUMENTO        = NVL(Pr_InfoDetalleSolicitud.TIPO_DOCUMENTO,TIPO_DOCUMENTO),   
      OBSERVACION           = NVL(Pr_InfoDetalleSolicitud.OBSERVACION,OBSERVACION),
      ESTADO                = NVL(Pr_InfoDetalleSolicitud.ESTADO,ESTADO),  
      USR_RECHAZO           = NVL(Pr_InfoDetalleSolicitud.USR_RECHAZO,USR_RECHAZO),  
      FE_RECHAZO            = NVL(Pr_InfoDetalleSolicitud.FE_RECHAZO,FE_RECHAZO),  
      DETALLE_PROCESO_ID    = NVL(Pr_InfoDetalleSolicitud.DETALLE_PROCESO_ID,DETALLE_PROCESO_ID),
      FE_EJECUCION          = NVL(Pr_InfoDetalleSolicitud.FE_EJECUCION,FE_EJECUCION),
      ELEMENTO_ID           = NVL(Pr_InfoDetalleSolicitud.ELEMENTO_ID,ELEMENTO_ID)
    WHERE ID_DETALLE_SOLICITUD = NVL(Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD,ID_DETALLE_SOLICITUD);
  --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_INFO_DETALLE_SOL - ' || SQLERRM;
  --
  END P_UPDATE_INFO_DETALLE_SOL;
END CMKG_REINGRESO;
/