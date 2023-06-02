CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PRODUCTO_CIH AS
  
  /**
   * Documentación para CMKG_PRODUCTO_CIH
   * Paquete que contiene procesos y funciones para verificación y
   * preplanificación de servicios identificados como CIH
   * 
   * @author Alex Gómez <algomez@telconet.ec>
   * @version 1.0 12/09/2022
   */
  
    TYPE T_ARRAY IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
    
  /**
    * Documentación para P_PREPLANIFICA_SERVICIOS_CIH
    * Se crea procedimiento para la identificación y preplanificación de 
    * servicios de productos CIH con estado Pendiente
    *
    * @param  Pcl_Request       -  Datos para la preplanificacion por servicios CIH,
    *         Pv_Mensaje        -  Mensaje de ERROR,
    *         Pv_Status         -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */
    PROCEDURE P_PREPLANIFICA_SERVICIOS_CIH(Pcl_Request IN  VARCHAR2,
                                           Pv_Mensaje  OUT VARCHAR2,
                                           Pv_Status   OUT VARCHAR2);
    
  /**
    * Documentación para P_GENERA_SOLICITUD_DET
    * Se crea procedimiento para la generación de solicitudes por
    * preplanificación de servicios con productos CIH
    *
    * @param  Pn_idServicio        -  Id del servicio asociado a la solicitud a generar,
    *         Pv_Solicitud         -  Descripción del tipo de soluicitud a generar,
    *         Pv_Observacion       -  Observación por la solicitud a generar,
    *         Pv_estadoSolicitud   -  Estado de la solicitud a asignar,
    *         Pv_ipCreacion        -  Ip de creación,
    *         Pv_usuarioCreacion   -  Usuario de creación,
    *         Pv_Mensaje           -  Mensaje de ERROR,
    *         Pv_Status            -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */
    PROCEDURE P_GENERA_SOLICITUD_DET(Pn_idServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_Solicitud       IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                     Pv_Observacion     IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
                                     Pv_estadoSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_ipCreacion      IN  DB_COMERCIAL.INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE,
                                     Pv_usuarioCreacion IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                     Pv_Mensaje         OUT VARCHAR2,
                                     Pv_Status          OUT VARCHAR2);
  
  /**
    * Documentación para P_GENERAR_SECUENCIA
    * Se crea procedimiento para la obtención de secuencia por tipo
    *
    * @param  Pv_DatosSecuencia -  Datos de secuencia,
    *         Pv_Mensaje        -  Mensaje de ERROR,
    *         Pv_Status         -  Estado OK o ERROR,
    *         Pv_NumeroCA       -  Valor número,
    *         Pn_Secuencia      -  Secuencia,
    *         Pn_IdNumeracion   -  Id de la numeración
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */
    PROCEDURE P_GENERAR_SECUENCIA(Pv_DatosSecuencia IN  DB_COMERCIAL.DATOS_SECUENCIA,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_NumeroCA       OUT VARCHAR2,
                                  Pn_Secuencia      OUT INTEGER,
                                  Pn_IdNumeracion   OUT INTEGER);
    
    /**
    * Documentación para F_GET_ARRAY
    * Se crea procedimiento para la obtención de secuencia por tipo
    *
    * @param  Fv_Trama          -  Trama a desglosar,
    *         Fv_Separador      -  Separador de la trama,
    *         Fb_AplicaTrim     -  Se aplica trim a cada dato de la trama,
    *         RETURN T_ARRAY    -  Deevuelve array
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */
    FUNCTION F_GET_ARRAY(Fv_Trama       VARCHAR2,
                         Fv_Separador   VARCHAR2,
                         Fb_AplicaTrim  BOOLEAN) RETURN T_ARRAY;
    
  /**
    * Documentación para P_OBTIENE_SERVXPRODUCTO
    * Se crea procedimiento para la obtención del total de servicios
    *   por un producto en escpecífico
    *
    * @param  Pn_IdPunto        -  Id del punto,
    *         Pv_NombreTecnico  -  Nombre Técnico del producto,
    *         Pv_EmpresaCod     -  Código de la empresa,
    *         Pv_EstadosBuscar  -  Trama de estados a buscar (Ejemplo: |Activo|),
    *         Pn_TotalServicios -  Devuelve el total de servicios encontrados,
    *         Pv_Servicios      -  Array de servicios encontrados
    *         Pv_Mensaje        -  Mensaje de ERROR
    *         PV_Status         -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */
    PROCEDURE P_OBTIENE_SERVXPRODUCTO(Pn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pv_NombreTecnico   IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                      Pv_EmpresaCod      IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                      Pv_EstadosBuscar   IN VARCHAR2, 
                                      Pn_TotalServicios  OUT INTEGER,
                                      Pv_Servicios       OUT T_ARRAY,
                                      Pv_Mensaje         OUT VARCHAR2,
                                      PV_Status          OUT VARCHAR2);
   
   /**
    * Documentación para P_VERIFICA_EQUIPO_EXTENDER
    * Se crea procedimiento para la verficion de equipos 
    * extender en punto
    *
    * @param  Pn_IdServicio          -  Id del servicio,
    *         Pn_IdPunto             -  Id del punto,
    *         Pv_NombreTecnico       -  Nombre Técnico del producto,
    *         Pv_EmpresaCod          -  Código de l aempresa,
    *         Pv_VerificaEquipo      -  SI o NO
    *         Pv_VerificaProdPlan    -  SI o NO
    *         Pv_ProductoEncontrado  -  SI o NO
    *         Pv_Mensaje             -  Mensaje de ERROR
    *         PV_Status              -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */                                   
    PROCEDURE P_VERIFICA_EQUIPO_EXTENDER(Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                         Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Pv_NombresTecnicos    T_ARRAY,
                                         Pv_EmpresaCod         IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                         Pv_VerificaEquipo     IN VARCHAR2, 
                                         Pv_TipoEquipoBuscar   IN VARCHAR2,
                                         Pv_VerificaProdPlan   IN VARCHAR2,
                                         Pv_ProductoEncontrado OUT VARCHAR2,
                                         Pv_Mensaje            OUT VARCHAR2,
                                         Pv_Status             OUT VARCHAR2);
                                         
                                         
    /**
    * Documentación para P_VERIFICA_SOL_AGREGAR_EQUIPO
    * Se crea procedimiento para verificar si existe una solicitud 
    * de agregación de equipo por extender
    *
    * @param  Pn_IdServicioInternet   -  Id del servicio,
    *         Pv_EmpresaCod           -  Código de l aempresa,
    *         Pv_MotivoCambioOnt      -  Motivo de solicitud a consultar,
    *         Pv_TipoNuevoOnt         -  Tipo Ont,
    *         Pn_IdSolAgregar         -  Devuelve Id de la solicitud si existe,
    *         Pv_CrearSolAgregar      -  DeVuelve SI o NO
    *         Pv_EliminarSolAgregar   -  DeVuelve SI o NO
    *         Pv_Mensaje              -  Mensaje de ERROR
    *         PV_Status               -  Estado OK O ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */                                       
    PROCEDURE P_VERIFICA_SOL_AGREGAR_EQUIPO(Pn_IdServicioInternet IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                            Pv_EmpresaCod         IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                            Pv_MotivoCambioOnt    IN VARCHAR2, 
                                            Pv_TipoNuevoOnt       IN VARCHAR2,
                                            Pn_IdSolAgregar       OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                            Pv_CrearSolAgregar    OUT VARCHAR2,
                                            Pv_EliminarSolAgregar OUT VARCHAR2,
                                            Pv_Mensaje            OUT VARCHAR2,
                                            Pv_Status             OUT VARCHAR2); 
                                            
    /**
    * Documentación para P_GENERA_SOL_AGREGAREQP_DB
    * Se crea procedimiento para verificar si existe una solicitud 
    * de agregación de equipo por extender
    *
    * @param  Pn_IdServicio        -  Id del servicio,
    *         Pn_IdCliente         -  Código del cliente,
    *         Pv_MotivoCambioOnt   -  Motivo de solicitud a consultar,
    *         Pv_TipoOntNuevo      -  Tipo Ont Nuevo,
    *         Pv_EstadoSolicitud   -  Estado de la solicitd,
    *         Pv_UsrCreacion       -  Usuario de creación
    *         Pv_IpCreacion        -  Ip de creación
    *         Pn_IdSolicitudGen    -  Devuelve id de solicitud generada  
    *         Pv_Mensaje           -  Mensaje de ERROR
    *         PV_Status            -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */                                                    
    PROCEDURE P_GENERA_SOL_AGREGAREQP_DB(Pn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                         Pn_IdCliente        IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE,
                                         Pv_MotivoCambioOnt  IN VARCHAR2,
                                         Pv_TipoOntNuevo     IN VARCHAR2,
                                         Pv_EstadoSolicitud  IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Pv_UsrCreacion      IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                         Pv_IpCreacion       IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE,
                                         Pn_IdSolicitudGen   OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Pv_Mensaje          OUT VARCHAR2,
                                         Pv_Status           OUT VARCHAR2);
                                         
    /**
    * Documentación para P_ENVIA_NOTIFICACION
    * Se crea procedimiento para envio de notificaciones de correo por
    * generación de solicitud por AGREGACION DE EQUIPO
    *
    * @param  Pn_IdPunto       -  Id del punto,
    *         Pn_IdServicio    -  Id del servicio,
    *         Pv_Observacion   -  Observacion para correo,
    *         Pv_Descripcion   -  Descripcin para asunto del correo,
    *         Pv_UsrCreacion   -  Usuario de creación
    *         Pv_IpCreacion    -  Ip de creación
    *         Pv_Mensaje       -  Mensaje de ERROR
    *         PV_Status        -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */ 
    PROCEDURE P_ENVIA_NOTIFICACION(Pn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_Observacion     IN VARCHAR2,
                                   Pv_Descripcion     IN VARCHAR2,
                                   Pv_UsuarioCreacion IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                   Pv_IpCreacion      IN VARCHAR2,
                                   Pv_Status          OUT VARCHAR2,
                                   Pv_Mensaje         OUT VARCHAR2);
                                   
    /**
    * Documentación para P_REEMPLAZO_PLANTILLA
    * Se crea procedimiento para verificar si existe una solicitud 
    * de agregación de equipo por extender
    *
    * @param  Pv_Parametros        -  Trama con parámetros para reemplazo en plantilla,
    *         Pcl_PlantillaIn      -  Plantilla de entrada,
    *         Pcl_PlantillaOut     -  Plantilla de salida,
    *         Pv_Mensaje           -  Mensaje de ERROR
    *         PV_Status            -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */                                
    PROCEDURE P_REEMPLAZO_PLANTILLA(Pv_Parametros     IN VARCHAR2,
                                    Pcl_PlantillaIn   IN CLOB,
                                    Pcl_PlantillaOut  OUT CLOB,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2);
                                    
   /**
    * Documentación para P_GENERAR_OT_SERVADIC
    * Se crea procedimiento para la generación de ordenes de trabajos por
    * solicitudes de preplanificación
    *
    * @param  Pt_GenerarOt      -  Datos para la generación de OT,
    *         Pv_Mensaje        -  Mensaje de ERROR,
    *         Pv_Status         -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */
    PROCEDURE P_GENERAR_OT_SERVADIC(Pt_GenerarOt IN  DB_COMERCIAL.DATOS_GENERAR_OT_TYPE,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pv_Status    OUT VARCHAR2);
    
   /**
    * Documentación para P_GENERAR_OTXSERVICIOS_CIH
    * Se crea procedimiento para la verificación y generación de 
    * la Orden de Trabajo por preplanificación de servicios CIH
    *
    * @param  Pt_GenerarOt      -  Datos para la generación de OT,
    *         Pv_Mensaje        -  Mensaje de ERROR,
    *         Pv_Status         -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */                                
    PROCEDURE P_GENERAR_OTXSERVICIOS_CIH(Pcl_Request IN VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2,
                                         Pv_Status   OUT VARCHAR2);
    
    /**
    * Documentación para P_GENERAR_OTXSERVICIOS_CIH
    * Se crea procedimiento para realizar el reverso de solicitudes generadas
    * por preplanificación de productos CIH
    *
    * @param  Pt_GenerarOt      -  Datos para la generación de OT,
    *         Pv_Mensaje        -  Mensaje de ERROR,
    *         Pv_Status         -  Estado OK o ERROR
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.0 12/09/2022
    */                                     
    PROCEDURE P_REVERSA_PREPLANIFICACION(Pcl_Request IN VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2,
                                         Pv_Status   OUT VARCHAR2);
                                    
END CMKG_PRODUCTO_CIH;

/
 
create or replace PACKAGE BODY  DB_COMERCIAL.CMKG_PRODUCTO_CIH AS

    PROCEDURE P_PREPLANIFICA_SERVICIOS_CIH(Pcl_Request IN VARCHAR2,
                                           Pv_Mensaje  OUT VARCHAR2,
                                           Pv_Status   OUT VARCHAR2) IS
      
      Lv_IpCreacion                  VARCHAR2(100);
      Lv_CodEmpresa                  VARCHAR2(100);
      Lv_PrefijoEmpresa              VARCHAR2(100);
      Lv_UsrCreacion                 VARCHAR2(100);
      Ln_PuntoId                     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
      Ln_ContratoId                  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE;
      Ln_ServicioInternetId          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
      
      Lv_NombreParamMD               VARCHAR2(100) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'; 
      Lv_NombreParamProductosCIH     VARCHAR2(100) := 'PRODUCTOS_TIPO_CIH';
      Lv_DescParamProductosCIH       VARCHAR2(100) := 'CODIGO DE PRODUCTO CIH';
      Lv_DescTipoSolicitudPlan       VARCHAR2(100) := 'SOLICITUD PLANIFICACION';
      Lv_DescTipoSolicitudAgregar    VARCHAR2(100) := 'SOLICITUD AGREGAR EQUIPO';
      Lv_MotivoCambioOnt             VARCHAR2(100) := 'CAMBIO ONT POR AGREGAR EXTENDER';
      Lv_EstadoActivo                VARCHAR2(50)  := 'Activo';
      Lv_EstadoPendiente             VARCHAR2(50)  := 'Pendiente';
      Lv_EstadoPreplanificada        VARCHAR2(50)  := 'PrePlanificada';
      Lb_ValidaExiste                BOOLEAN;
      Lb_EsProductoCIH               BOOLEAN;
      Lv_Observacion                 VARCHAR2(4000);
      
      Lv_ModelosEquiposOntXTipoOnt   VARCHAR2(4000);
      Lv_ModelosEquiposEdbXTipoOnt   VARCHAR2(4000);
      Lv_ModelosEquiposWdb           VARCHAR2(4000);
      Lv_ModelosEquiposEdb           VARCHAR2(4000);
      Lt_Array                       T_ARRAY;
      Lv_MarcaOltDB                  VARCHAR2(400);
      Lv_ModeloOltDB                 VARCHAR2(400);
      Lv_PermiteWYExtenderEnPlanes   VARCHAR2(400);
      
      Ln_TotalServicios              INTEGER := 0;
      Lv_ArrayServicios              T_ARRAY;
      
      Lt_ArrayNombresTecnicos        T_ARRAY;
      Lv_ProductoEncontrado          VARCHAR2(400) := 'NO';
      
      Lv_TieneEquipoEnlazado         VARCHAR2(400);
      Lv_InfoEquipoEncontrado        VARCHAR2(4000);
      Lc_TrazaElementos              CLOB;
      Lb_TieneEquipoOntParaExt       BOOLEAN := FALSE;
      
      Lv_CaracTipoOntNuevo           VARCHAR2(400);
      Ln_IdSolAgregarExistente       INTEGER;
      Lv_TieneCrearSolAgregar        VARCHAR2(400);
      Lv_TieneEliminarSolGestion     VARCHAR2(400);
      Lv_TieneEliminarSolAgregar     VARCHAR2(400);
      
      Lc_DetSolEliminadas            CLOB;
      Ln_IdSolicitudCambioOnt        NUMBER;
      
      Lb_ExistePendientes            BOOLEAN := FALSE;
      Lv_Mensaje                     VARCHAR2(4000);
      Lv_Status                      VARCHAR2(30);
      Le_Errors                      EXCEPTION;
      
      CURSOR C_GetPunto(Cn_IdPunto NUMBER) IS
        SELECT ip.* 
          FROM DB_COMERCIAL.INFO_PUNTO ip 
         WHERE ip.ID_PUNTO = Cn_IdPunto;
         
      CURSOR C_GetPersonaEmpresaRol(Cn_EmpresaPersonaRol NUMBER) IS
        SELECT iper.* 
          FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper 
         WHERE iper.ID_PERSONA_ROL = Cn_EmpresaPersonaRol;
        
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2,
                            Cv_Valor2      VARCHAR2,
                            Cv_valor3      VARCHAR2,
                            Cv_valor4      VARCHAR2,
                            Cv_valor5      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND (Cv_Valor2 IS NULL OR apd.VALOR2 = Cv_Valor2)
           AND (Cv_valor3 IS NULL OR apd.VALOR3 = Cv_Valor3)
           AND (Cv_valor4 IS NULL OR apd.VALOR4 = Cv_Valor4)
           AND (Cv_valor5 IS NULL OR apd.VALOR5 = Cv_Valor5)
           AND apd.ESTADO = Lv_EstadoActivo;

      CURSOR C_GetServicioPendiente(Cn_IdPunto NUMBER) IS
        SELECT ise.ID_SERVICIO, ise.PRODUCTO_ID
          FROM DB_COMERCIAL.INFO_PUNTO ipu,
               DB_COMERCIAL.INFO_ADENDUM iad,
               DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ipu.ID_PUNTO = Cn_IdPunto
           AND ipu.ID_PUNTO = iad.PUNTO_ID
           AND ipu.ID_PUNTO = ise.PUNTO_ID
           AND iad.SERVICIO_ID = ise.ID_SERVICIO
           --AND iad.CONTRATO_ID = Cn_IdContrato
           AND ise.ESTADO = Lv_EstadoPendiente
           AND ise.PLAN_ID IS NULL
           AND ise.PRODUCTO_ID IS NOT NULL
        ORDER BY ise.PRODUCTO_ID;
      
      CURSOR C_GetProducto(Cn_IdProducto NUMBER) IS
        SELECT adp.* 
          FROM DB_COMERCIAL.ADMI_PRODUCTO adp 
         WHERE adp.ID_PRODUCTO = Cn_IdProducto;     
         
      CURSOR C_GetServicioTecnico(Cn_IdServicio INTEGER) IS
        SELECT ist.*
          FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
         WHERE ist.SERVICIO_ID = Cn_IdServicio;
         
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
                    
      Lc_InfoPunto          C_GetPunto%ROWTYPE;  
      Lc_InfoServicio       C_GetServicio%ROWTYPE;
      Lc_InfoPerRol         C_GetPersonaEmpresaRol%ROWTYPE;
      Lc_AdmiParametroDet   C_GetParametro%ROWTYPE;
      Lc_AdmiProducto       C_GetProducto%ROWTYPE;
      Lc_InfoServicioTec    C_GetServicioTecnico%ROWTYPE;

    BEGIN 

      --1.- Verifica parámetros obtenidos
      APEX_JSON.PARSE(Pcl_Request);
      Lv_IpCreacion           := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
      Lv_CodEmpresa           := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
      Lv_PrefijoEmpresa       := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
      Lv_UsrCreacion          := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
      Ln_PuntoId              := APEX_JSON.get_number(p_path => 'puntoId');
      Ln_ServicioInternetId   := APEX_JSON.get_number(p_path => 'servicioInternetId');

      IF Ln_PuntoId IS NULL THEN
        Lv_Mensaje := 'El parametro puntoId esta vacio';
        RAISE Le_Errors;
      END IF;
      IF Lv_CodEmpresa IS NULL THEN
        Lv_Mensaje := 'El parámetro codEmpresa esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Ln_ServicioInternetId IS NULL THEN
        Lv_Mensaje := 'El parámetro servicioInternetId esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --2.- Verifica datos en base
      OPEN C_GetPunto(Ln_PuntoId);
      FETCH C_GetPunto INTO Lc_InfoPunto;
      Lb_ValidaExiste := C_GetPunto%FOUND;
      CLOSE C_GetPunto;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'El puntoId no existe';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetServicio(Ln_ServicioInternetId);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'El servicioInternetId no existe';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetPersonaEmpresaRol(Lc_InfoPunto.PERSONA_EMPRESA_ROL_ID);
      FETCH C_GetPersonaEmpresaRol INTO Lc_InfoPerRol;
      Lb_ValidaExiste := C_GetPersonaEmpresaRol%FOUND;
      CLOSE C_GetPersonaEmpresaRol;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'La PERSONA_EMPRESA_ROL_ID no existe';
        RAISE Le_Errors;
      END IF;
      
        --3.- Recorre servicios adicionales del punto
        FOR servicio IN C_GetServicioPendiente(Lc_InfoPunto.ID_PUNTO) LOOP
           
          --3.1.- Valida producto CIH
          Lb_EsProductoCIH := FALSE;
          FOR parametro IN C_GetParametro(Lv_NombreParamProductosCIH,
                                          Lv_DescParamProductosCIH,
                                          Lv_CodEmpresa,
                                          '','','','','') LOOP
            IF parametro.VALOR1 = servicio.PRODUCTO_ID THEN
              Lb_EsProductoCIH := TRUE;
              EXIT;
            END IF;
          END LOOP;
          
          --3.2.- Validación de producto y generación de solicitudes
          IF Lb_EsProductoCIH  THEN
          
            Lb_ExistePendientes := TRUE;
            
            OPEN C_GetProducto(servicio.PRODUCTO_ID);
            FETCH C_GetProducto INTO Lc_AdmiProducto;
            Lb_ValidaExiste := C_GetProducto%FOUND;
            CLOSE C_GetProducto;
            
            IF Lb_ValidaExiste THEN
              
              IF Lc_AdmiProducto.NOMBRE_TECNICO <> 'EXTENDER_DUAL_BAND' THEN
                
                P_GENERA_SOLICITUD_DET(servicio.ID_SERVICIO,
                                       Lv_DescTipoSolicitudPlan,
                                       Lv_Observacion,
                                       Lv_EstadoPreplanificada,
                                       Lv_IpCreacion,
                                       Lv_UsrCreacion,
                                       Lv_Mensaje,
                                       Lv_Status);
                  
                IF Lv_Status <> 'OK' THEN
                  RAISE Le_Errors;
                END IF;
                                
                Lv_Status := NULL;
                Lv_Mensaje := NULL;
                
              ELSE
              
                --Verifica la tecnología Dual Band a partir del servicio de Internet
                DB_COMERCIAL.TECNK_SERVICIOS.P_VERIFICA_TECNOLOGIA_DB('',
                                                                      '',
                                                                      '',
                                                                      Ln_ServicioInternetId,
                                                                      Lv_Status,
                                                                      Lv_Mensaje,
                                                                      Lv_ModelosEquiposOntXTipoOnt,
                                                                      Lv_ModelosEquiposEdbXTipoOnt,
                                                                      Lv_ModelosEquiposWdb,
                                                                      Lv_ModelosEquiposEdb);
                
                IF Lv_Status <> 'OK' THEN
                  Lv_Mensaje := 'No se puede crear el servicio puesto que ' || Lv_Mensaje;
                  RAISE Le_Errors;
                END IF;
                
                --Obtiene marca y modelo de OLT desde trama
                BEGIN
                  Lt_Array := F_GET_ARRAY(Lv_Mensaje,
                                          '|',
                                          true);
                                        
                  IF Lt_Array.COUNT = 0 THEN
                    Lv_Mensaje := 'No se pudo obtener información del OLT';
                  ELSE
                    Lv_MarcaOltDB := Lt_Array(1);
                    Lv_ModeloOltDB := Lt_Array(2);
                    Lv_PermiteWYExtenderEnPlanes := Lt_Array(3);
                    Lv_Mensaje := NULL;
                    Lv_Status := NULL;
                  END IF;
                EXCEPTION
                  WHEN OTHERS THEN
                    Lv_Mensaje := 'Error al obtener información del OLT';
                END;
                
                IF Lv_Mensaje IS NOT NULL THEN
                  RAISE Le_Errors;
                END IF;
                
                --Verificación de compatibilidad con equipos extender
                Lt_ArrayNombresTecnicos(1) := 'WIFI_DUAL_BAND';
                Lt_ArrayNombresTecnicos(2) := 'WDB_Y_EDB';
                P_VERIFICA_EQUIPO_EXTENDER(Ln_ServicioInternetId,
                                           Lc_InfoPunto.ID_PUNTO,
                                           Lt_ArrayNombresTecnicos,
                                           Lv_CodEmpresa,
                                           'SI',
                                           'WIFI DUAL BAND',
                                           Lv_PermiteWYExtenderEnPlanes,
                                           Lv_ProductoEncontrado,
                                           Lv_Mensaje,
                                           Lv_Status); 
                
                IF Lv_Status <> 'OK' THEN
                  RAISE Le_Errors;
                END IF;
                Lv_Mensaje := null;
                Lv_Status := null;
                
                IF Lv_ProductoEncontrado = 'NO' THEN
                  /*
                   * Flujo a nivel de extender por ont
                   * 1. Se verifica si el servicio tiene un equipo ont parametrizado para extenders. 
                   * En caso de tenerlo, el flujo se mantiene como está actualmente, caso contrario se continúa 
                   * con los siguientes puntos.
                   * 2. Se debe verificar si el servicio de Internet tiene una solicitud de agregar equipo con
                   * las características para un cambio por un ont para extender creado anteriormente por la agregación 
                   * de otro extender.
                   * Si no existe dicha solicitud se debe crear esa solicitud, caso contrario se mantiene el flujo como
                   * está actualmente. 
                   **/
                   
                   Lb_ValidaExiste := FALSE;
                   Lv_TieneEliminarSolAgregar := 'SI';
                   FOR equipo IN C_GetParametro(Lv_NombreParamMD,
                                                '', Lv_CodEmpresa,
                                                'TIPOS_EQUIPOS',
                                                Lv_MarcaOltDB,
                                                Lv_ModeloOltDB,
                                                '','TIPOS_EQUIPOS_ONT_PARA_EXTENDER') LOOP
                     
                     Lb_ValidaExiste := TRUE;
                     Lv_CaracTipoOntNuevo := equipo.VALOR4;   
                     DB_COMERCIAL.TECNK_SERVICIOS.P_VERIFICA_EQUIPO_ENLAZADO(Ln_ServicioInternetId,
                                                                             NULL,
                                                                             Lv_CaracTipoOntNuevo,
                                                                             '',
                                                                             '',
                                                                             Lv_Status,
                                                                             Lv_Mensaje,
                                                                             Lv_TieneEquipoEnlazado,
                                                                             Lv_InfoEquipoEncontrado,
                                                                             Lc_TrazaElementos);
                     
                     IF Lv_Status <> 'OK' THEN
                       RAISE Le_Errors;
                     END IF;
                     Lv_Mensaje := null;
                     Lv_Status := null;
                     
                     IF Lv_TieneEquipoEnlazado = 'SI' AND Lv_InfoEquipoEncontrado IS NOT NULL THEN
                       Lb_TieneEquipoOntParaExt := TRUE;
                       EXIT;
                     END IF;
                   END LOOP;
                   
                   IF NOT Lb_ValidaExiste THEN
                     Lv_Mensaje := 'No existe la parametrización de tipos de onts para extender para '||
                                  'el modelo de olt ' || Lv_ModeloOltDB;
                     RAISE Le_Errors;
                   END IF;
                   
                   IF Lb_TieneEquipoOntParaExt THEN
                     /*
                      * El servicio de Internet no tiene un equipo para extender, se verificará si tiene asociada 
                      * una solicitud agregar equipo que permita gestionar el cambio a un ont para extender
                      */
                     P_VERIFICA_SOL_AGREGAR_EQUIPO(Ln_ServicioInternetId,
                                                   Lv_CodEmpresa,
                                                   Lv_MotivoCambioOnt,
                                                   Lv_CaracTipoOntNuevo,
                                                   Ln_IdSolAgregarExistente,
                                                   Lv_TieneCrearSolAgregar,
                                                   Lv_TieneEliminarSolGestion,
                                                   Lv_Mensaje,
                                                   Lv_Status);
                    
                     IF Lv_Status <> 'OK' THEN
                       RAISE Le_Errors;
                     END IF;
                     Lv_Mensaje := null;
                     Lv_Status := null;
                     
                     /*Se elimina solicitud de agregar equipo en caso de ser necesario (servicio internet)*/
                     IF Lv_TieneEliminarSolAgregar = 'SI' THEN
                       DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_ELIMINA_SOLS_DUAL_BAND_SERV(Ln_ServicioInternetId,
                                                                                            Ln_IdSolAgregarExistente,
                                                                                            Lv_Status,
                                                                                            Lv_Mensaje,
                                                                                            Lc_DetSolEliminadas);
                       
                       IF Lv_Status <> 'OK' THEN
                         Lv_Mensaje := 'Se presentaron problemas al eliminar las solicitudes asociadas a servicios Dual Band '
                                      || 'por creación de servicio ' || Lc_AdmiProducto.DESCRIPCION_PRODUCTO;
                         RAISE Le_Errors;
                       END IF;
                       Lv_Mensaje := null;
                       Lv_Status := null;
                     END IF;
                     
                     /*Se elimina solicitud de gestion en caso de ser necesario (servicio internet)*/
                     IF Lv_TieneEliminarSolGestion = 'SI' THEN
                       DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_ELIMINA_SOLS_GESTIONA_ONT(Ln_ServicioInternetId,
                                                                                          Ln_IdSolAgregarExistente,
                                                                                          Lv_Status,
                                                                                          Lv_Mensaje,
                                                                                          Lc_DetSolEliminadas);
                       
                       IF Lv_Status <> 'OK' THEN
                         Lv_Mensaje := 'Se presentaron problemas al eliminar las solicitudes que gestionan el equipo CPE ONT '
                                      || 'por creación de servicio ' || Lc_AdmiProducto.DESCRIPCION_PRODUCTO;
                         RAISE Le_Errors;
                       END IF;
                       Lv_Mensaje := null;
                       Lv_Status := null;
                     END IF;
                     
                     /*Se crea solicitud en caso de ser necesario (servicio adicional)*/
                     IF Lv_TieneCrearSolAgregar = 'SI' THEN
                       
                       OPEN C_GetServicioTecnico(Ln_ServicioInternetId);
                       FETCH C_GetServicioTecnico INTO Lc_InfoServicioTec;
                       Lb_ValidaExiste := C_GetServicioTecnico%FOUND;
                       CLOSE C_GetServicioTecnico;
                       
                       IF NOT Lb_ValidaExiste THEN
                         Lv_Mensaje := 'No se pudo obtener la información técnica del '
                                       ||'servicio de Internet contratado.';
                         RAISE Le_Errors;
                       END IF;
                       
                       P_GENERA_SOL_AGREGAREQP_DB(Ln_ServicioInternetId,
                                                  Lc_InfoServicioTec.ELEMENTO_CLIENTE_ID,
                                                  Lv_MotivoCambioOnt,
                                                  Lv_CaracTipoOntNuevo,
                                                  Lv_EstadoPreplanificada,
                                                  Lv_UsrCreacion,
                                                  Lv_IpCreacion,
                                                  Ln_IdSolicitudCambioOnt,
                                                  Lv_Mensaje,
                                                  Lv_Status);
                                                  
                       IF Lv_Status <> 'OK' THEN
                         RAISE Le_Errors;
                       END IF;
                       Lv_Status := NULL;
                       Lv_Mensaje := NULL;
                     END IF;
                     
                   END IF;
                   
                END IF;
                
                P_GENERA_SOLICITUD_DET(servicio.ID_SERVICIO,
                                       Lv_DescTipoSolicitudAgregar,
                                       Lv_Observacion,
                                       Lv_EstadoPreplanificada,
                                       Lv_IpCreacion,
                                       Lv_UsrCreacion,
                                       Lv_Mensaje,
                                       Lv_Status);
                
                IF Lv_Status <> 'OK' THEN
                  RAISE Le_Errors;
                END IF;
                Lv_Status := NULL;
                Lv_Mensaje := NULL;
                
              END IF;
              
            ELSE
              Lv_Mensaje := 'Producto no encontrado: '||servicio.PRODUCTO_ID;
              RAISE Le_Errors;
            END IF;
            
          END IF;
          
        END LOOP;
        
        IF NOT Lb_ExistePendientes THEN
          Lv_Mensaje := 'No se encontraron productos CIH pendientes';
        END IF;
      
      Pv_Mensaje := Lv_Mensaje;
      Pv_Status := 'OK';
      
      COMMIT;
      
    EXCEPTION
      WHEN Le_Errors THEN
        ROLLBACK;
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'Telcos+',
           'DB_COMERCIAL.CMKG_PRODUCTO_CIH.P_PREPLANIFICA_SERVICIOS_CIH',
           'Error: '||Pv_Mensaje ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');
           
      WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'Telcos+',
           'DB_COMERCIAL.CMKG_PRODUCTO_CIH.P_PREPLANIFICA_SERVICIOS_CIH',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_PREPLANIFICA_SERVICIOS_CIH;
    
    
    PROCEDURE P_GENERA_SOLICITUD_DET(Pn_idServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_Solicitud       IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                     Pv_Observacion     IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
                                     Pv_estadoSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_ipCreacion      IN  DB_COMERCIAL.INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE,
                                     Pv_usuarioCreacion IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                     Pv_Mensaje         OUT VARCHAR2,
                                     Pv_Status          OUT VARCHAR2) IS
      
      Lb_ValidaExiste           BOOLEAN;
      Lv_EstadoActivo           VARCHAR2(50) := 'Activo';
      Lv_EstadoPendiente        VARCHAR2(50) := 'Pendiente';
      Lv_EstadoPreplanificada   VARCHAR2(50)  := 'PrePlanificada';
      
      Ln_IdDetalleSol           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
      Ln_IdDetalleSolHist       DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ID_SOLICITUD_HISTORIAL%TYPE;
      
      Lv_Mensaje                VARCHAR2(4000);
      Le_Errors                 EXCEPTION;
      
      
      CURSOR C_GetTipoSolicitud(Cv_TipoSolicitud VARCHAR2) IS
        SELECT ats.*
          FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
         WHERE ats.DESCRIPCION_SOLICITUD = Cv_TipoSolicitud
           AND ats.ESTADO = Lv_EstadoActivo;
        
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
      
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND apd.ESTADO = Lv_EstadoActivo;
      
      CURSOR C_GetSolicitud(Cn_IdServicio INTEGER,
                            Cn_IdTipoSolicitud VARCHAR2,
                            Cv_EstadoSolicitud VARCHAR2) IS
        SELECT ids.*
          FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
         WHERE ids.SERVICIO_ID = Cn_idServicio
           AND ids.TIPO_SOLICITUD_ID = Cn_IdTipoSolicitud
           AND ids.ESTADO = Cv_EstadoSolicitud;
           
      Lc_AdmiTipoSolicitud   C_GetTipoSolicitud%ROWTYPE;
      Lc_InfoServicio        C_GetServicio%ROWTYPE;
      Lc_ParamObservacion    C_GetParametro%ROWTYPE;
      Lc_InfoDetSolicitud    C_GetSolicitud%ROWTYPE;

    BEGIN
    
      --Valida Parámetros
      IF Pv_usuarioCreacion IS NULL THEN
        Lv_Mensaje := 'El Pv_usuarioCreacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_ipCreacion IS NULL THEN
        Lv_Mensaje := 'El Pv_ipCreacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_Solicitud IS NULL THEN  
        Lv_Mensaje := 'El Pv_Solicitud esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pn_idServicio IS NULL THEN  
        Lv_Mensaje := 'El Pn_idServicio esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_estadoSolicitud IS NULL THEN  
        Lv_Mensaje := 'El Pv_estadoSolicitud esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --Valida servicio
      OPEN C_GetServicio(Pn_idServicio);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN  
        Lv_Mensaje := 'No se ha encontrado servicio a PrePlanificar';
        RAISE Le_Errors;
      ELSIF Lc_InfoServicio.ESTADO <> Lv_EstadoPendiente THEN
        Lv_Mensaje := 'El servicio no se encuentra en estado Pendiente para su Preplanificación';
        RAISE Le_Errors;
      END IF;
      
      --Obtener Tipo de Solicitud
      OPEN C_GetTipoSolicitud(Pv_Solicitud);
      FETCH C_GetTipoSolicitud INTO Lc_AdmiTipoSolicitud;
      Lb_ValidaExiste := C_GetTipoSolicitud%FOUND;
      CLOSE C_GetTipoSolicitud;
      IF NOT Lb_ValidaExiste THEN  
        Lv_Mensaje := 'La solicitud '||Pv_Solicitud||' no existe o se encuentra inactiva';
        RAISE Le_Errors;
      END IF;
        
      --Validar si ya posee una solicitud
      OPEN C_GetSolicitud(Pn_idServicio,
                          Lc_AdmiTipoSolicitud.ID_TIPO_SOLICITUD,
                          Lv_EstadoPreplanificada);
      FETCH C_GetSolicitud INTO Lc_InfoDetSolicitud;
      Lb_ValidaExiste := C_GetSolicitud%FOUND;
      CLOSE C_GetSolicitud;
                
      IF Lb_ValidaExiste THEN
                  
        Lv_Mensaje := 'El servicio ' || TO_CHAR(Pn_idServicio)
                        || ' ya posee una ' || Pv_Solicitud
                        || ' en estado ' || Lv_EstadoPreplanificada;
        RAISE Le_Errors;
      
      END IF;
      
      --Inserta Detalle de Solicitud
      BEGIN
        
        SELECT DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL
          INTO Ln_IdDetalleSol
          FROM DUAL;
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD(ID_DETALLE_SOLICITUD,
                                                        TIPO_SOLICITUD_ID,
                                                        SERVICIO_ID,
                                                        OBSERVACION,
                                                        ESTADO,
                                                        USR_CREACION,
                                                        FE_CREACION)
             VALUES (Ln_IdDetalleSol,
                     Lc_AdmiTipoSolicitud.ID_TIPO_SOLICITUD,
                     Pn_idServicio,
                     Pv_Observacion,
                     Pv_estadoSolicitud,
                     Pv_usuarioCreacion,
                     SYSDATE);
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar el Detalle de la Solicitud por ' || Pv_Observacion;
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;
      
      --Inserta Detalle de Solicitud Historial
      BEGIN
        
        SELECT DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL
          INTO Ln_IdDetalleSolHist
          FROM DUAL;
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL,
                                                       DETALLE_SOLICITUD_ID,
                                                       IP_CREACION,
                                                       FE_CREACION,
                                                       USR_CREACION,
                                                       ESTADO,
                                                       OBSERVACION)
             VALUES (Ln_IdDetalleSolHist,
                     Ln_IdDetalleSol,
                     Pv_ipCreacion,
                     SYSDATE,
                     Pv_usuarioCreacion,
                     Pv_estadoSolicitud,
                     Pv_Observacion);
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar el Historial por ' || Pv_Observacion;
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;

      Pv_Mensaje := 'Proceso realizado con exito';
      Pv_Status  := 'OK';
            
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_GENERA_SOLICITUD_DET;
    

    PROCEDURE P_GENERAR_SECUENCIA(Pv_DatosSecuencia IN  DB_COMERCIAL.DATOS_SECUENCIA,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_NumeroCA       OUT VARCHAR2,
                                  Pn_Secuencia      OUT INTEGER,
                                  Pn_IdNumeracion   OUT INTEGER)  IS
                                  
      CURSOR C_GET_NUM_EMP_TIPO(Cv_CodigoNumeraEmpr  VARCHAR2,
                                Cn_CodEmpresa        INTEGER,
                                Cn_IdOficina         INTEGER,
                                Cv_EstadoActivo      VARCHAR2) IS
        SELECT AN.ID_NUMERACION,
               AN.SECUENCIA,
               AN.NUMERACION_UNO,
               AN.NUMERACION_DOS
          FROM DB_COMERCIAL.ADMI_NUMERACION AN
         WHERE AN.ESTADO     = Cv_EstadoActivo
           AND AN.CODIGO     = Cv_CodigoNumeraEmpr
           AND AN.EMPRESA_ID = Cn_CodEmpresa
           AND AN.OFICINA_ID = Cn_IdOficina;

      --Numeracion
      Lv_NumeracionUno           VARCHAR2(400);
      Lv_NumeracionDos           VARCHAR2(400);
      Lv_SecuenciaAsig           VARCHAR2(400);
      Lv_NumeroContrato          VARCHAR2(400);
      Lv_EstadoActivo            VARCHAR2(400) := 'Activo';
      
      Lv_Mensaje                 VARCHAR2(4000);
      Le_Errors                  EXCEPTION;
      
    BEGIN
      
      --Valida parámetros
      IF Pv_DatosSecuencia.Pv_codigoNumeracionVe IS NULL THEN
        Lv_Mensaje := 'El Pv_codigoNumeracionVe esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_DatosSecuencia.Pn_CodEmpresa IS NULL THEN
        Lv_Mensaje := 'El Pn_CodEmpresa esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_DatosSecuencia.Pn_IdOficina IS NULL THEN
        Lv_Mensaje := 'El Pn_CodEmpresa esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --Consulta numeración
      OPEN C_GET_NUM_EMP_TIPO (Pv_DatosSecuencia.Pv_codigoNumeracionVe,
                               Pv_DatosSecuencia.Pn_CodEmpresa,
                               Pv_DatosSecuencia.Pn_IdOficina,
                               Lv_EstadoActivo);
      FETCH C_GET_NUM_EMP_TIPO INTO Pn_IdNumeracion,
                                    Pn_Secuencia,
                                    Lv_NumeracionUno,
                                    Lv_NumeracionDos;
      CLOSE C_GET_NUM_EMP_TIPO;
        

      IF Pn_Secuencia IS NOT NULL 
        AND Lv_NumeracionUno IS NOT NULL 
        AND Lv_NumeracionDos IS NOT NULL THEN
        
        --Actualización de la númeracion
        Lv_SecuenciaAsig  := LPAD(Pn_Secuencia,7,'0');
        Pn_Secuencia      := Pn_Secuencia + 1;
        
        UPDATE DB_COMERCIAL.ADMI_NUMERACION 
           SET SECUENCIA = Pn_Secuencia 
        WHERE ID_NUMERACION = Pn_IdNumeracion;
            
        Lv_NumeroContrato := CONCAT(CONCAT(CONCAT(Lv_NumeracionUno,CONCAT('-',Lv_NumeracionDos)),'-'),Lv_SecuenciaAsig);
      ELSE
        Lv_Mensaje := 'No se ha encontrado la secuencia para el Pv_codigoNumeracionVe:' || Pv_DatosSecuencia.Pv_codigoNumeracionVe;
        RAISE Le_Errors;
      END IF;
      
      Pv_NumeroCA:= Lv_NumeroContrato;

      Pv_Mensaje   := 'Proceso realizado con exito';
      Pv_Status    := 'OK';
      
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);

    END P_GENERAR_SECUENCIA;
    
        
    FUNCTION F_GET_ARRAY(Fv_Trama       VARCHAR2,
                         Fv_Separador   VARCHAR2,
                         Fb_AplicaTrim  BOOLEAN) 
      RETURN T_ARRAY 
    IS
    
      Lt_Array    T_ARRAY;
      Lv_Trama    VARCHAR2(4000);
      Ln_Posicion INTEGER;
      Lv_Dato     VARCHAR2(1000);
      Ln_Indice   INTEGER := 0;
    
    BEGIN
      Lv_Trama := Fv_Trama;
      IF SUBSTR(Lv_Trama, -1) <> Fv_Separador THEN
        Lv_Trama := Lv_Trama || Fv_Separador;
      END IF;
    
      Ln_Posicion := INSTR(Lv_Trama, Fv_Separador);
    
      WHILE Ln_Posicion > 0 LOOP
        Ln_Indice := Ln_Indice + 1;
        Lv_Dato   := SUBSTR(Lv_Trama, 0, Ln_Posicion - 1);
        IF Fb_AplicaTrim THEN
          Lv_Dato := TRIM(Lv_Dato);
        END IF;
        Lt_Array(Ln_Indice) := Lv_Dato;
      
        Lv_Trama    := SUBSTR(Lv_Trama, Ln_Posicion + 1);
        Ln_Posicion := INSTR(Lv_Trama, Fv_Separador);
      END LOOP;
    
      RETURN Lt_Array;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN Lt_Array;
    END F_GET_ARRAY;
    
    
    PROCEDURE P_OBTIENE_SERVXPRODUCTO(Pn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pv_NombreTecnico   IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                      Pv_EmpresaCod      IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                      Pv_EstadosBuscar   IN VARCHAR2,
                                      Pn_TotalServicios  OUT INTEGER,
                                      Pv_Servicios       OUT T_ARRAY,
                                      Pv_Mensaje         OUT VARCHAR2,
                                      PV_Status          OUT VARCHAR2) IS
    
      Lv_NombreParamEstados       VARCHAR2(400)  := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
      Lv_EstadoActivo             VARCHAR2(400)  := 'Activo';
      Lv_TramaEstadosNotIn        VARCHAR2(4000) := '|';
      Lv_TramaEstadosIn           VARCHAR2(4000) := '|';
      Ln_TotalServicios           INTEGER := 0;
      Lv_Mensaje                  VARCHAR2(4000);
      Lv_Status                   VARCHAR2(30);
      Le_Errors                   EXCEPTION;
      
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2,
                            Cv_Valor2      VARCHAR2,
                            Cv_valor3      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND (Cv_Valor2 IS NULL OR apd.VALOR2 = Cv_Valor2)
           AND (Cv_valor3 IS NULL OR INSTR(Cv_Valor3,'|'||apd.VALOR1||'|') > 0)
           AND apd.ESTADO = Lv_EstadoActivo;
      
      CURSOR C_GetServiciosXProd(Cn_IdPunto INTEGER,
                                 Cv_NombreTecnico VARCHAR2,
                                 Cv_Estados VARCHAR2) IS
        SELECT ise.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_PUNTO ipu,
               DB_COMERCIAL.ADMI_PRODUCTO ipr,
               DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ipu.ID_PUNTO = Cn_IdPunto
           AND ipu.ID_PUNTO = ise.PUNTO_ID
           AND ise.PRODUCTO_ID = ipr.ID_PRODUCTO
           and ipr.NOMBRE_TECNICO = Cv_NombreTecnico
           and ipr.ESTADO = Lv_EstadoActivo
           and INSTR(Cv_Estados,'|'||ise.ESTADO||'|')>0;
      
    BEGIN
      
      --Valida Parámetros
      IF Pn_IdPunto IS NULL THEN
        Lv_Mensaje := 'El Pn_IdPunto esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_NombreTecnico IS NULL THEN
        Lv_Mensaje := 'El Pv_NombreTecnico esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_EmpresaCod IS NULL THEN
        Lv_Mensaje := 'El Pv_EmpresaCod esta vacío';
        RAISE Le_Errors;
      END IF;
            
      --Obtiene estados válidos para servicios de internet
      FOR estado IN C_GetParametro(Lv_NombreParamEstados,
                                   '', 
                                   Pv_EmpresaCod, 
                                   'ESTADOS_SERVICIOS_IN', 
                                   Pv_NombreTecnico,
                                   Pv_EstadosBuscar) LOOP
        IF estado.VALOR3 IS NOT NULL THEN
          Lv_TramaEstadosIn := Lv_TramaEstadosIn || estado.VALOR3 || '|';
        END IF;
      END LOOP;
      
      IF LENGTH(Lv_TramaEstadosIn) = 1 THEN
        Lv_Mensaje := 'No se pudo obtener los estados Validos para validación';
        RAISE Le_Errors;
      END IF;
      
      FOR servicio IN C_GetServiciosXProd(Pn_IdPunto,
                                          Pv_NombreTecnico,
                                          Lv_TramaEstadosIn) LOOP
        Ln_TotalServicios := Ln_TotalServicios + 1;
        Pv_Servicios(Ln_TotalServicios) := servicio.ID_SERVICIO;
      END LOOP;
      
      Pn_TotalServicios := Ln_TotalServicios;
      Pv_Status    := 'OK'; 
      Pv_Mensaje   := 'Proceso realizado con exito';
      
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
      
    END P_OBTIENE_SERVXPRODUCTO;
    
    
    PROCEDURE P_VERIFICA_EQUIPO_EXTENDER(Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                         Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Pv_NombresTecnicos    T_ARRAY,
                                         Pv_EmpresaCod         IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                         Pv_VerificaEquipo     IN VARCHAR2, 
                                         Pv_TipoEquipoBuscar   IN VARCHAR2,
                                         Pv_VerificaProdPlan   IN VARCHAR2,
                                         Pv_ProductoEncontrado OUT VARCHAR2,
                                         Pv_Mensaje            OUT VARCHAR2,
                                         Pv_Status             OUT VARCHAR2) IS
      
      Lv_NombreParamMD           VARCHAR2(400)  := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
      Lv_ProductoEncontrado      VARCHAR2(400) := 'NO';
      Lv_EstadoEliminado         VARCHAR2(400) := 'Eliminado';
      Lv_EstadoActivo            VARCHAR2(400) := 'Activo';
      Lv_VerificaProdPlan        VARCHAR2(400) := 'NO';
      Ln_TotalServiciosConsulta  INTEGER := 0;
      Lv_ServiciosConsulta       T_ARRAY;
      Ln_TotalServiciosAdic      INTEGER := 0;
      Lv_ServiciosAdic           T_ARRAY;
      
      Lv_TieneEquipoEnlazado     VARCHAR2(400);
      Lv_InfoEquipoEncontrado    VARCHAR2(4000);
      Lc_TrazaElementos          CLOB;
      Ln_Iterator                INTEGER;
      Ln_Iterator2               INTEGER;
      
      Lv_Status                  VARCHAR2(100);
      Lv_Mensaje                 VARCHAR2(4000);
      Le_Errors                  EXCEPTION;
      
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
      
      CURSOR C_GetProductoPlan(Cn_IdPlan INTEGER,
                               Cv_NombreTecnico VARCHAR2) IS
        SELECT adp.NOMBRE_TECNICO
          FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
               DB_COMERCIAL.ADMI_PRODUCTO adp
         WHERE ipd.PLAN_ID = Cn_IdPlan
           AND ipd.PRODUCTO_ID = adp.ID_PRODUCTO
           AND adp.NOMBRE_TECNICO = Cv_NombreTecnico
           AND ipd.ESTADO <> Lv_EstadoEliminado;
      
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2,
                            Cv_Valor2      VARCHAR2,
                            Cv_valor3      VARCHAR2,
                            Cv_valor4      VARCHAR2,
                            Cv_valor5      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND (Cv_Valor2 IS NULL OR apd.VALOR2 = Cv_Valor2)
           AND (Cv_valor3 IS NULL OR apd.VALOR3 = Cv_Valor3)
           AND (Cv_valor4 IS NULL OR apd.VALOR4 = Cv_Valor4)
           AND (Cv_valor5 IS NULL OR apd.VALOR5 = Cv_Valor5)
           AND apd.ESTADO = Lv_EstadoActivo;
           
      Lc_ProductoPlan            C_GetProductoPlan%ROWTYPE;
      Lc_InfoServicio            C_GetServicio%ROWTYPE;
      Lb_ValidaExiste            BOOLEAN;
      
    BEGIN
    
      --Valida Parámetros
      IF Pn_IdServicio IS NULL THEN
        Lv_Mensaje := 'El Pn_IdServicio esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pn_IdPunto IS NULL THEN
        Lv_Mensaje := 'El Pn_IdPunto esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_EmpresaCod IS NULL THEN
        Lv_Mensaje := 'El Pv_EmpresaCod esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_VerificaProdPlan IS NULL THEN
        Lv_VerificaProdPlan := 'SI';
      ELSE
        Lv_VerificaProdPlan := Pv_VerificaProdPlan;
      END IF;
      
      --
      OPEN C_GetServicio(Pn_IdServicio);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se ha encontrado el servicio a verificar';
        RAISE Le_Errors;
      END IF;
        
      IF Pv_NombresTecnicos.count > 0 THEN
      
        Ln_Iterator := Pv_NombresTecnicos.FIRST;
        WHILE (Ln_Iterator IS NOT NULL)
        LOOP
          --Verifica producto en plan
          IF Lv_VerificaProdPlan = 'SI' THEN
            OPEN C_GetProductoPlan(Lc_InfoServicio.PLAN_ID,
                                   Pv_NombresTecnicos(Ln_Iterator));
            FETCH C_GetProductoPlan INTO Lc_ProductoPlan;
            Lb_ValidaExiste := C_GetProductoPlan%FOUND;
            CLOSE C_GetProductoPlan;
            
            IF Lb_ValidaExiste THEN
              Lv_ProductoEncontrado := 'SI';
            END IF;
          END IF;
          
          --Verifica servicios adicionales por producto
          P_OBTIENE_SERVXPRODUCTO(Pn_IdPunto,
                                  Pv_NombresTecnicos(Ln_Iterator),
                                  Pv_EmpresaCod,
                                  '',
                                  Ln_TotalServiciosConsulta,
                                  Lv_ServiciosConsulta,
                                  Lv_Mensaje,
                                  Lv_Status);
                    
          IF Lv_Status <> 'OK' THEN
            RAISE Le_Errors;
          END IF;
          Lv_Mensaje := null;
          Lv_Status := null;
          
          IF Ln_TotalServiciosConsulta > 0 THEN
            Ln_Iterator2 := Lv_ServiciosConsulta.FIRST;
            WHILE (Ln_Iterator2 IS NOT NULL)
            LOOP
              Ln_TotalServiciosAdic := Ln_TotalServiciosAdic + 1;
              Lv_ServiciosAdic(Ln_TotalServiciosAdic) := Lv_ServiciosConsulta(Ln_Iterator2);
              Ln_Iterator2 := Lv_ServiciosConsulta.NEXT(Ln_Iterator2);
            END LOOP;
            Lv_ProductoEncontrado := 'SI';
          END IF;
          
          Ln_Iterator := Lv_ServiciosConsulta.NEXT(Ln_Iterator);
        END LOOP;
      END IF;
      
      --Verifica Equipo Enlazado
      IF NVL(Pv_VerificaEquipo,'NO') = 'SI' THEN
        DB_COMERCIAL.TECNK_SERVICIOS.P_VERIFICA_EQUIPO_ENLAZADO(Lc_InfoServicio.ID_SERVICIO,
                                                                NULL,
                                                                Pv_TipoEquipoBuscar,
                                                                '',
                                                                '',
                                                                Lv_Status,
                                                                Lv_Mensaje,
                                                                Lv_TieneEquipoEnlazado,
                                                                Lv_InfoEquipoEncontrado,
                                                                Lc_TrazaElementos);
                    
        IF Lv_Status <> 'OK' THEN
          RAISE Le_Errors;
        END IF;
        Lv_Mensaje := null;
        Lv_Status := null;
        
        IF Lv_InfoEquipoEncontrado IS NOT NULL AND Lv_TieneEquipoEnlazado = 'SI' THEN
          Lv_ProductoEncontrado := 'SI';
        END IF;
      END IF;
        
      Pv_ProductoEncontrado := Lv_ProductoEncontrado; 
      Pv_Status    := 'OK'; 
      Pv_Mensaje   := 'Proceso realizado con exito';
      
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_VERIFICA_EQUIPO_EXTENDER;
    
    
    PROCEDURE P_VERIFICA_SOL_AGREGAR_EQUIPO(Pn_IdServicioInternet IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                            Pv_EmpresaCod         IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                            Pv_MotivoCambioOnt    IN VARCHAR2, 
                                            Pv_TipoNuevoOnt       IN VARCHAR2,
                                            Pn_IdSolAgregar       OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                            Pv_CrearSolAgregar    OUT VARCHAR2,
                                            Pv_EliminarSolAgregar OUT VARCHAR2,
                                            Pv_Mensaje            OUT VARCHAR2,
                                            Pv_Status             OUT VARCHAR2) IS
      
      Lv_NombreParamMD          VARCHAR2(100) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'; 
      Lv_EstadoActivo           VARCHAR2(400) := 'Activo';
      Lv_TramaEstadosIn         VARCHAR2(4000) := '|';
      Lb_ValidaExiste           BOOLEAN;
      Ln_IdSolicitudAgregar     NUMBER;
      
      Lv_CrearSolicitudAgregar  VARCHAR2(400) := 'NO';
      Lv_EliminarSolicitudGest  VARCHAR2(400) := 'NO';
      Lv_Mensaje                VARCHAR2(4000);
      Le_Errors                 EXCEPTION;
      
      CURSOR C_GetTipoSolicitud(Cv_Descripcion VARCHAR2) IS
        SELECT ats.*
          FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
         WHERE ats.DESCRIPCION_SOLICITUD = Cv_Descripcion
           AND ats.ESTADO = Lv_EstadoActivo;
           
      CURSOR C_GetCaracteristica(Cv_Descripcion VARCHAR2) IS
        SELECT ac.*
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA ac
         WHERE ac.DESCRIPCION_CARACTERISTICA = Cv_Descripcion
           AND ac.ESTADO = Lv_EstadoActivo;
           
      CURSOR C_GetServicioSolicitud(Cn_IdServicio INTEGER,
                                    Cn_IdTipoSolicitud INTEGER,
                                    Cv_TramaEstados VARCHAR2) IS
        SELECT ifs.*
          FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ifs
         WHERE ifs.SERVICIO_ID = Cn_IdServicio
           AND ifs.TIPO_SOLICITUD_ID = Cn_IdTipoSolicitud
           AND INSTR(Cv_TramaEstados, '|'||ifs.ESTADO||'|') > 0;
      
      CURSOR C_GetDetalle_SolCaract(Cn_IdDetalleSol INTEGER,
                                    Cn_IdCaracteristica INTEGER,
                                    Cv_Valor VARCHAR2,
                                    Cv_TramaEstados VARCHAR2) IS
        SELECT idsf.*
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT idsf
         WHERE idsf.DETALLE_SOLICITUD_ID = Cn_IdDetalleSol
           AND idsf.CARACTERISTICA_ID = Cn_IdCaracteristica
           AND (Cv_Valor IS NULL OR idsf.VALOR = Cv_Valor)
           AND INSTR(Cv_TramaEstados, '|'||idsf.ESTADO||'|') > 0;
      
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2,
                            Cv_Valor2      VARCHAR2,
                            Cv_valor3      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND (Cv_Valor2 IS NULL OR apd.VALOR2 = Cv_Valor2)
           AND (Cv_valor3 IS NULL OR apd.VALOR3 = Cv_Valor3)
           AND apd.ESTADO = Lv_EstadoActivo;
           
      Lc_TipoSolicitud        C_GetTipoSolicitud%ROWTYPE;
      Lc_MotivoCreaSol        C_GetCaracteristica%ROWTYPE;
      Lc_TipoOntNuevo         C_GetCaracteristica%ROWTYPE;
      
      Lc_ServicioSolicitud    C_GetServicioSolicitud%ROWTYPE;
      Lc_DetMotivoCreaSol     C_GetDetalle_SolCaract%ROWTYPE;
      Lc_DetTipoOntNuevo      C_GetDetalle_SolCaract%ROWTYPE;
      
    BEGIN
      
      --Valida Parámetros
      IF Pn_IdServicioInternet IS NULL THEN
        Lv_Mensaje := 'El Pn_IdServicioInternet esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_EmpresaCod IS NULL THEN
        Lv_Mensaje := 'El Pv_EmpresaCod esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_MotivoCambioOnt IS NULL THEN
        Lv_Mensaje := 'El Pv_MotivoCambioOnt esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_TipoNuevoOnt IS NULL THEN
        Lv_Mensaje := 'El Pv_TipoNuevoOnt esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --Consulta valores
      OPEN C_GetTipoSolicitud('SOLICITUD AGREGAR EQUIPO');
      FETCH C_GetTipoSolicitud INTO Lc_TipoSolicitud;
      Lb_ValidaExiste := C_GetTipoSolicitud%FOUND;
      CLOSE C_GetTipoSolicitud;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se ha podido obtener el tipo de solicitud agregar equipo';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetCaracteristica('MOTIVO_CREACION_SOLICITUD');
      FETCH C_GetCaracteristica INTO Lc_MotivoCreaSol;
      Lb_ValidaExiste := C_GetCaracteristica%FOUND;
      CLOSE C_GetCaracteristica;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información acerca de característica MOTIVO_CREACION_SOLICITUD';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetCaracteristica('TIPO_ONT_NUEVO');
      FETCH C_GetCaracteristica INTO Lc_TipoOntNuevo;
      Lb_ValidaExiste := C_GetCaracteristica%FOUND;
      CLOSE C_GetCaracteristica;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información acerca de característica TIPO_ONT_NUEVO';
        RAISE Le_Errors;
      END IF;
      
      FOR parametro IN C_GetParametro(Lv_NombreParamMD,'',
                                      Pv_EmpresaCod,
                                      'ESTADOS_SOLICITUDES_ABIERTAS',
                                      'SOLICITUD AGREGAR EQUIPO','') LOOP
        Lv_TramaEstadosIn := Lv_TramaEstadosIn || parametro.VALOR3 ||'|';                                
      END LOOP;
      
      IF LENGTH(Lv_TramaEstadosIn) = 1 THEN
        Lv_Mensaje := 'No se han podido encontrar los estados permitidos para una solicitud de agregar equipo';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetServicioSolicitud(Pn_IdServicioInternet,
                                  Lc_TipoSolicitud.ID_TIPO_SOLICITUD,
                                  Lv_TramaEstadosIn);
      FETCH C_GetServicioSolicitud INTO Lc_ServicioSolicitud;
      Lb_ValidaExiste := C_GetServicioSolicitud%FOUND;
      CLOSE C_GetServicioSolicitud;
      
      IF Lb_ValidaExiste THEN
        
        /*
         * Ya existe solicitud, se verifica que permita gestionar el cambio 
         * de ont por agregación de extender
         */
          
        Ln_IdSolicitudAgregar := Lc_ServicioSolicitud.ID_DETALLE_SOLICITUD;
        
        OPEN C_GetDetalle_SolCaract(Lc_ServicioSolicitud.ID_DETALLE_SOLICITUD,
                                    Lc_MotivoCreaSol.ID_CARACTERISTICA,
                                    Pv_MotivoCambioOnt,
                                    Lv_TramaEstadosIn);
        FETCH C_GetDetalle_SolCaract INTO Lc_DetMotivoCreaSol;
        CLOSE C_GetDetalle_SolCaract;
        
        OPEN C_GetDetalle_SolCaract(Lc_ServicioSolicitud.ID_DETALLE_SOLICITUD,
                                    Lc_TipoOntNuevo.ID_CARACTERISTICA,
                                    Pv_TipoNuevoOnt,
                                    Lv_TramaEstadosIn);
        FETCH C_GetDetalle_SolCaract INTO Lc_DetTipoOntNuevo;
        CLOSE C_GetDetalle_SolCaract;
        
        IF Lc_DetMotivoCreaSol.ID_SOLICITUD_CARACTERISTICA IS NULL AND
          Lc_DetTipoOntNuevo.ID_SOLICITUD_CARACTERISTICA IS NULL THEN
          /*
           * Existe solicitud de agregar equipo asociada al servicio de Internet, 
           * pero no con las características para el cambio a otro ONT
           */
           Lv_CrearSolicitudAgregar := 'SI';
           Lv_EliminarSolicitudGest := 'SI';
        END IF;
      ELSE
        /*
         * No existe solicitud de agregar equipo asociada al servicio de Internet
         */
        Lv_CrearSolicitudAgregar := 'SI';
        Lv_EliminarSolicitudGest := 'SI';
      END IF;
    
      Pn_IdSolAgregar       := Ln_IdSolicitudAgregar;
      Pv_CrearSolAgregar    := Lv_CrearSolicitudAgregar;
      Pv_EliminarSolAgregar := Lv_EliminarSolicitudGest;
      Pv_Status    := 'OK'; 
      Pv_Mensaje   := 'Proceso realizado con exito';
      
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_VERIFICA_SOL_AGREGAR_EQUIPO;
    
    
    PROCEDURE P_GENERA_SOL_AGREGAREQP_DB(Pn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                         Pn_IdCliente        IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE,
                                         Pv_MotivoCambioOnt  IN VARCHAR2,
                                         Pv_TipoOntNuevo     IN VARCHAR2,
                                         Pv_EstadoSolicitud  IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Pv_UsrCreacion      IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                         Pv_IpCreacion       IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE,
                                         Pn_IdSolicitudGen   OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Pv_Mensaje          OUT VARCHAR2,
                                         Pv_Status           OUT VARCHAR2) IS
      
      Ln_IdDetalleSol           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
      Ln_IdDetalleSolCaract     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE;
      Ln_IdDetalleSolHist       DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ID_SOLICITUD_HISTORIAL%TYPE;
      Lv_Observacion            DB_COMERCIAL.INFO_DETALLE_SOL_HIST.OBSERVACION%TYPE;
      Lv_EstadoActivo           VARCHAR2(400) := 'Activo';
      
      Lv_Mensaje                VARCHAR2(4000);
      Le_Errors                 EXCEPTION;
      
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
      
      CURSOR C_GetTipoSolicitud(Cv_Descripcion VARCHAR2) IS
        SELECT ats.*
          FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
         WHERE ats.DESCRIPCION_SOLICITUD = Cv_Descripcion
           AND ats.ESTADO = Lv_EstadoActivo;
      
      CURSOR C_GetCaracteristica(Cv_Descripcion VARCHAR2) IS
        SELECT ac.*
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA ac
         WHERE ac.DESCRIPCION_CARACTERISTICA = Cv_Descripcion
           AND ac.ESTADO = Lv_EstadoActivo;
           
      Lb_ValidaExiste          BOOLEAN;   
      Lc_InfoServicio          C_GetServicio%ROWTYPE;
      Lc_AdmiTipoSolicitud     C_GetTipoSolicitud%ROWTYPE;
      Lc_MotivoCreaSol         C_GetCaracteristica%ROWTYPE;
      Lc_TipoOntNuevo          C_GetCaracteristica%ROWTYPE;
      Lc_ElementoCliente       C_GetCaracteristica%ROWTYPE;
          
    BEGIN
    
      --Valida Parámetros
      IF Pn_IdServicio IS NULL THEN
        Lv_Mensaje := 'El Pn_IdServicio esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_MotivoCambioOnt IS NULL THEN
        Lv_Mensaje := 'El Pv_MotivoCambioOnt esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_UsrCreacion IS NULL THEN
        Lv_Mensaje := 'El Pv_UsrCreacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_IpCreacion IS NULL THEN
        Lv_Mensaje := 'El Pv_IpCreacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_TipoOntNuevo IS NULL THEN
        Lv_Mensaje := 'El Pv_TipoOntNuevo esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_EstadoSolicitud IS NULL THEN  
        Lv_Mensaje := 'El Pv_EstadoSolicitud esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --Valida servicio
      OPEN C_GetServicio(Pn_IdServicio);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN  
        Lv_Mensaje := 'No se ha encontrado servicio a PrePlanificar';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetTipoSolicitud('SOLICITUD AGREGAR EQUIPO');
      FETCH C_GetTipoSolicitud INTO Lc_AdmiTipoSolicitud;
      Lb_ValidaExiste := C_GetTipoSolicitud%FOUND;
      CLOSE C_GetTipoSolicitud;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se ha podido obtener el tipo de solicitud agregar equipo';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetCaracteristica('MOTIVO_CREACION_SOLICITUD');
      FETCH C_GetCaracteristica INTO Lc_MotivoCreaSol;
      Lb_ValidaExiste := C_GetCaracteristica%FOUND;
      CLOSE C_GetCaracteristica;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información acerca de característica MOTIVO_CREACION_SOLICITUD';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetCaracteristica('TIPO_ONT_NUEVO');
      FETCH C_GetCaracteristica INTO Lc_TipoOntNuevo;
      Lb_ValidaExiste := C_GetCaracteristica%FOUND;
      CLOSE C_GetCaracteristica;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información acerca de característica TIPO_ONT_NUEVO';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetCaracteristica('ELEMENTO CLIENTE');
      FETCH C_GetCaracteristica INTO Lc_ElementoCliente;
      Lb_ValidaExiste := C_GetCaracteristica%FOUND;
      CLOSE C_GetCaracteristica;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información acerca de característica TIPO_ONT_NUEVO';
        RAISE Le_Errors;
      END IF;
      
      --Inserta Detalle de Solicitud
      BEGIN
        
        SELECT DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL
          INTO Ln_IdDetalleSol
          FROM DUAL;
        
        Lv_Observacion := Lc_AdmiTipoSolicitud.DESCRIPCION_SOLICITUD || ' creada automáticamente';
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD(ID_DETALLE_SOLICITUD,
                                                        TIPO_SOLICITUD_ID,
                                                        SERVICIO_ID,
                                                        ESTADO,
                                                        USR_CREACION,
                                                        FE_CREACION)
             VALUES (Ln_IdDetalleSol,
                     Lc_AdmiTipoSolicitud.ID_TIPO_SOLICITUD,
                     Pn_IdServicio,
                     Pv_EstadoSolicitud,
                     Pv_UsrCreacion,
                     SYSDATE);
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar el Detalle de la Solicitud por Agragación de Equipo';
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;
      
      --Inserta caracteríticas
      BEGIN
        
        --Detalle por motivo
        SELECT DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL
          INTO Ln_IdDetalleSolCaract
          FROM DUAL;
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT(ID_SOLICITUD_CARACTERISTICA,
                                                         CARACTERISTICA_ID,
                                                         DETALLE_SOLICITUD_ID,
                                                         VALOR,
                                                         ESTADO,
                                                         USR_CREACION,
                                                         FE_CREACION)
             VALUES (Ln_IdDetalleSolCaract,
                     Lc_MotivoCreaSol.ID_CARACTERISTICA,
                     Ln_IdDetalleSol,
                     Pv_MotivoCambioOnt,
                     Pv_EstadoSolicitud,
                     Pv_UsrCreacion,
                     SYSDATE);
                     
        --Detalle por tipo nuevo ont
        SELECT DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL
          INTO Ln_IdDetalleSolCaract
          FROM DUAL;
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT(ID_SOLICITUD_CARACTERISTICA,
                                                         CARACTERISTICA_ID,
                                                         DETALLE_SOLICITUD_ID,
                                                         VALOR,
                                                         ESTADO,
                                                         USR_CREACION,
                                                         FE_CREACION)
             VALUES (Ln_IdDetalleSolCaract,
                     Lc_TipoOntNuevo.ID_CARACTERISTICA,
                     Ln_IdDetalleSol,
                     Pv_TipoOntNuevo,
                     Pv_EstadoSolicitud,
                     Pv_UsrCreacion,
                     SYSDATE);
                     
        --Detalle por elemento cliente
        SELECT DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL
          INTO Ln_IdDetalleSolCaract
          FROM DUAL;
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT(ID_SOLICITUD_CARACTERISTICA,
                                                         CARACTERISTICA_ID,
                                                         DETALLE_SOLICITUD_ID,
                                                         VALOR,
                                                         ESTADO,
                                                         USR_CREACION,
                                                         FE_CREACION)
             VALUES (Ln_IdDetalleSolCaract,
                     Lc_ElementoCliente.ID_CARACTERISTICA,
                     Ln_IdDetalleSol,
                     Pn_IdCliente,
                     Pv_EstadoSolicitud,
                     Pv_UsrCreacion,
                     SYSDATE);
        
        Lv_Observacion := Lv_Observacion 
                              || '<br>Incluye cambio de CPE ONT a un '
                              || Pv_TipoOntNuevo;
                              
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar las caracteristicas por el detalle de la solicitud generada';
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;
            
      --Inserta Info detalle sol hist
      BEGIN
        
        --Detalle por motivo
        SELECT DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL
          INTO Ln_IdDetalleSolHist
          FROM DUAL;
        
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL,
                                                       DETALLE_SOLICITUD_ID,
                                                       OBSERVACION,
                                                       ESTADO,
                                                       USR_CREACION,
                                                       FE_CREACION,
                                                       IP_CREACION)
             VALUES (Ln_IdDetalleSolHist,
                     Ln_IdDetalleSol,
                     Lv_Observacion,
                     Pv_EstadoSolicitud,
                     Pv_UsrCreacion,
                     SYSDATE,
                     Pv_IpCreacion);
        
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar el historial por el detalle de solicitud';
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;
      
      Pn_IdSolicitudGen := Ln_IdDetalleSol;
      Pv_Status    := 'OK'; 
      Pv_Mensaje   := 'Proceso realizado con exito';
      
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_GENERA_SOL_AGREGAREQP_DB;
    
    
    PROCEDURE P_ENVIA_NOTIFICACION(Pn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_Observacion     IN VARCHAR2,
                                   Pv_Descripcion     IN VARCHAR2,
                                   Pv_UsuarioCreacion IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                   Pv_IpCreacion      IN VARCHAR2,
                                   Pv_Status          OUT VARCHAR2,
                                   Pv_Mensaje         OUT VARCHAR2) IS
      
      Lv_NombreParamCorreo     VARCHAR2(100) := 'VALIDACIONES_CAMBIOS_PRODUCTOS_CIH';
      Lv_DescParamCorreo       VARCHAR2(100) := 'ENVIO CORREO SC AGREGA EQUIPO';
      Lv_CodigoPlantilla       VARCHAR2(100) := 'AGREGAEQUIPOPYL';
      Lv_EstadoEliminado       VARCHAR2(100) := 'Eliminado';
      Lv_EstadoActivo          VARCHAR2(100) := 'Activo';
      Lv_TipoProductoPlan      VARCHAR2(100);
      Lv_DescProductoPlan      VARCHAR2(100);
      Lv_Remitente             VARCHAR2(4000) := '';
      Lv_Destinatarios         VARCHAR2(4000) := '';
      Lv_TypeMime              VARCHAR2(4000);
      Lv_AsuntoCorreo          VARCHAR2(1000);
      Lv_ParamsPlantilla       VARCHAR2(4000) := '';
      Lcl_PlantillaFinal       CLOB;
      
      Lv_Status                VARCHAR2(100);
      Lv_Mensaje               VARCHAR2(4000);
      Le_Errors                EXCEPTION;
      
      Lb_ValidaExiste          BOOLEAN;
      
      CURSOR C_GetPunto(Cn_IdPunto NUMBER) IS
        SELECT ipu.LOGIN, 
               aju.DESCRIPCION_JURISDICCION,
               ipr.NOMBRES || ' ' || ipr.APELLIDOS NOMBRES_CLIENTE
          FROM DB_COMERCIAL.INFO_PUNTO ipu,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL ipe,
               DB_COMERCIAL.INFO_PERSONA ipr,
               DB_COMERCIAL.ADMI_JURISDICCION aju
         WHERE ipu.ID_PUNTO = Cn_IdPunto
           AND ipu.PERSONA_EMPRESA_ROL_ID = ipe.ID_PERSONA_ROL
           AND ipe.PERSONA_ID = ipr.ID_PERSONA
           AND ipu.PUNTO_COBERTURA_ID = aju.ID_JURISDICCION;
           
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
         
      CURSOR C_GetProducto(Cn_IdProducto INTEGER) IS
        SELECT s.*
          FROM DB_COMERCIAL.ADMI_PRODUCTO S 
         WHERE S.ID_PRODUCTO = Cn_IdProducto ;
      
      CURSOR C_GetPlan(Cn_IdPlan INTEGER) IS
        SELECT s.*
          FROM DB_COMERCIAL.INFO_PLAN_CAB S 
         WHERE S.ID_PLAN = Cn_IdPlan;
         
      CURSOR C_GetPlantilla(Cv_Codigo VARCHAR2) IS
        SELECT s.* 
          FROM DB_COMUNICACION.ADMI_PLANTILLA S 
         WHERE S.CODIGO = Cv_Codigo;

      CURSOR C_GetAlias(Cn_IdPlantilla INTEGER,
                        Cv_EsCopia     VARCHAR2) IS
        SELECT AL.* 
          FROM DB_COMUNICACION.ADMI_ALIAS AL,
               DB_COMUNICACION.INFO_ALIAS_PLANTILLA IAP
         WHERE AL.ID_ALIAS = IAP.ALIAS_ID
           AND IAP.PLANTILLA_ID = Cn_IdPlantilla
           AND IAP.ES_COPIA = Cv_EsCopia
           AND AL.ESTADO <> Lv_EstadoEliminado
           AND IAP.ESTADO <> Lv_EstadoEliminado;
      
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = '18'
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND apd.ESTADO = Lv_EstadoActivo;
        
      
      Lc_InfoPunto       C_GetPunto%ROWTYPE;
      Lc_InfoServicio    C_GetServicio%ROWTYPE;
      Lc_InfoProducto    C_GetProducto%ROWTYPE;
      Lc_InfoPlan        C_GetPlan%ROWTYPE;
      Lc_AdmiPlantilla   C_GetPlantilla%ROWTYPE;
      Lc_Destinatarios   C_GetAlias%ROWTYPE;
      Lc_Parametro       C_GetParametro%ROWTYPE;
      
    BEGIN
      
      
      --Verificación de parámetros
      IF Pn_IdPunto IS NULL THEN
        Lv_Mensaje := 'El Pn_IdPunto esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pn_IdServicio IS NULL THEN
        Lv_Mensaje := 'El Pn_IdServicio esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_Observacion IS NULL THEN
        Lv_Mensaje := 'El Pv_Observacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Pv_Descripcion IS NULL THEN
        Lv_Mensaje := 'El Pv_Descripcion esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --Obtención de datos
      OPEN C_GetPunto(Pn_IdPunto);
      FETCH C_GetPunto INTO Lc_InfoPunto;
      Lb_ValidaExiste := C_GetPunto%FOUND;
      CLOSE C_GetPunto;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información del punto';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetServicio(Pn_IdServicio);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró información del servicio';
        RAISE Le_Errors;
      END IF;
      
      IF Lc_InfoServicio.PRODUCTO_ID IS NOT NULL THEN
      
        Lv_TipoProductoPlan := 'PRODUCTO';
        OPEN C_GetProducto(Lc_InfoServicio.PRODUCTO_ID);
        FETCH C_GetProducto INTO Lc_InfoProducto;
        Lb_ValidaExiste := C_GetProducto%FOUND;
        CLOSE C_GetProducto;
        IF NOT Lb_ValidaExiste THEN
          Lv_Mensaje := 'No se encontró información del producto';
          RAISE Le_Errors;
        END IF;
        Lv_DescProductoPlan := Lc_InfoProducto.DESCRIPCION_PRODUCTO;
        
      ELSIF Lc_InfoServicio.PLAN_ID IS NOT NULL THEN
      
        Lv_TipoProductoPlan := 'PLAN';
        OPEN C_GetPlan(Lc_InfoServicio.PLAN_ID);
        FETCH C_GetPlan INTO Lc_InfoPlan;
        Lb_ValidaExiste := C_GetPlan%FOUND;
        CLOSE C_GetPlan;
        IF NOT Lb_ValidaExiste THEN
          Lv_Mensaje := 'No se encontró información del plan';
          RAISE Le_Errors;
        END IF;
        Lv_DescProductoPlan := Lc_InfoPlan.NOMBRE_PLAN;
        
      END IF;
      
      OPEN C_GetPlantilla(Lv_CodigoPlantilla);
      FETCH C_GetPlantilla INTO Lc_AdmiPlantilla;
      Lb_ValidaExiste := C_GetPlantilla%FOUND;
      CLOSE C_GetPlantilla;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró la configuración de la plantilla';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetParametro(Lv_NombreParamCorreo,
                          Lv_DescParamCorreo);
      FETCH C_GetParametro INTO Lc_Parametro;
      Lb_ValidaExiste := C_GetParametro%FOUND;
      CLOSE C_GetParametro;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'No se encontró el parámetro de configuración '
                    || 'para el envío del correo';
        RAISE Le_Errors;
      END IF;
      Lv_Remitente := Lc_Parametro.VALOR1;
      Lv_TypeMime  := Lc_Parametro.VALOR2;
      
      FOR email IN C_GetAlias(Lc_AdmiPlantilla.ID_PLANTILLA, 'NO') LOOP
        Lv_Destinatarios := Lv_Destinatarios || email.VALOR || ',';
      END LOOP;
      IF Lv_Destinatarios IS NULL THEN
        Lv_Mensaje := 'No se encontraron los correos destinatarios';
        RAISE Le_Errors;
      END IF;
      Lv_Destinatarios := SUBSTR(Lv_Destinatarios,0,LENGTH(Lv_Destinatarios)-1);
      
      --Generación de plantilla final
      IF Lc_InfoServicio.TIPO_ORDEN = 'T' THEN
        Lv_AsuntoCorreo := 'GENERACIÓN DE TRASLADO + CAMBIO DE EQUIPO - '
                          || Pv_Descripcion || ' - '
                          || Lc_InfoPunto.LOGIN;
      ELSE
        Lv_AsuntoCorreo := 'Creación '
                          || Pv_Descripcion || ' - '
                          || Lc_InfoPunto.LOGIN;
      END IF;
      
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'descripcionTipoSolicitud=' || Pv_Descripcion || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'cliente=' || Lc_InfoPunto.NOMBRES_CLIENTE || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'login=' || Lc_InfoPunto.LOGIN || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'nombreJurisdiccion=' || Lc_InfoPunto.DESCRIPCION_JURISDICCION || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'tipoPlanOProducto=' || Lv_TipoProductoPlan || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'nombrePlanOProducto=' || Lv_DescProductoPlan || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'observacion | raw=' || Pv_Observacion || ';';
      Lv_ParamsPlantilla := Lv_ParamsPlantilla || 'estadoServicio=' || Lc_InfoServicio.ESTADO || ';';
      
      P_REEMPLAZO_PLANTILLA(Lv_ParamsPlantilla,
                            Lc_AdmiPlantilla.PLANTILLA,
                            Lcl_PlantillaFinal,
                            Lv_Status,
                            Lv_Mensaje);
      
      UTL_MAIL.SEND (sender     =>  Lv_Remitente, 
                     recipients =>  Lv_Destinatarios,
                     subject    =>  Lv_AsuntoCorreo, 
                     MESSAGE    =>  Lcl_PlantillaFinal, 
                     mime_type  =>  Lv_TypeMime );
    
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_ENVIA_NOTIFICACION;
    
    
    PROCEDURE P_REEMPLAZO_PLANTILLA(Pv_Parametros     IN VARCHAR2,
                                    Pcl_PlantillaIn   IN CLOB,
                                    Pcl_PlantillaOut  OUT CLOB,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2) IS
    
      Lcl_Plantilla        CLOB; 
      Lv_Key               VARCHAR2(2000); 
      Lv_Value             VARCHAR2(4000);
      Lv_ParamVal          VARCHAR2(4000);
    
      Ln_ContSeparador     NUMBER := 1;
      Ln_Inicio            NUMBER := 0;
      Ln_Fin               NUMBER := -1;
    
      Lv_Mensaje           VARCHAR2(4000);
      Le_Errors            EXCEPTION;
      
    BEGIN
      
      IF Pv_Parametros IS NULL THEN
        Lv_Mensaje := 'El Pv_Parametros esta vacío';
        RAISE Le_Errors;
      END IF;
      
      IF Pcl_PlantillaIn IS NULL THEN
        Lv_Mensaje := 'El Pcl_PlantillaIn esta vacío';
        RAISE Le_Errors;
      END IF;
      
      Lcl_Plantilla := Pcl_PlantillaIn;
      
      Ln_Inicio := 0;
      Ln_Fin := INSTR(Pv_Parametros, ';', 1, Ln_ContSeparador);
     
      WHILE Ln_Fin != 0 LOOP
        Lv_ParamVal := SUBSTR(Pv_Parametros, Ln_Inicio + 1, Ln_Fin - Ln_Inicio - 1);
        
        Lv_Key   := SUBSTR(Lv_ParamVal,
                             1,
                             INSTR(Lv_ParamVal, '=', 1, 1) - 1);
        Lv_Value := SUBSTR(Lv_ParamVal, INSTR(Lv_ParamVal, '=', 1, 1) + 1);
        
        Lcl_Plantilla := REPLACE(Lcl_Plantilla, '{{ ' || Lv_Key || ' }}', Lv_Value);
        
        Ln_ContSeparador := Ln_ContSeparador + 1;
        
        Ln_Inicio := INSTR(Pv_Parametros, ';', 1, Ln_ContSeparador - 1);
        Ln_Fin := INSTR(Pv_Parametros, ';', 1, Ln_ContSeparador);
      END LOOP;
      
      Lcl_Plantilla := REPLACE(REPLACE(Lcl_Plantilla,'Á',chr(38)||'Aacute;'),'á',chr(38)||'aacute;');
      Lcl_Plantilla := REPLACE(REPLACE(Lcl_Plantilla,'É',chr(38)||'Eacute;'),'é',chr(38)||'eacute;');
      Lcl_Plantilla := REPLACE(REPLACE(Lcl_Plantilla,'Í',chr(38)||'Iacute;'),'í',chr(38)||'iacute;');
      Lcl_Plantilla := REPLACE(REPLACE(Lcl_Plantilla,'Ó',chr(38)||'Oacute;'),'ó',chr(38)||'oacute;');
      Lcl_Plantilla := REPLACE(REPLACE(Lcl_Plantilla,'Ú',chr(38)||'Uacute;'),'ú',chr(38)||'uacute;');
      Pcl_PlantillaOut := Lcl_Plantilla;
    
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_REEMPLAZO_PLANTILLA;
    
    
    PROCEDURE P_GENERAR_OT_SERVADIC(Pt_GenerarOt IN  DB_COMERCIAL.DATOS_GENERAR_OT_TYPE,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pv_Status    OUT VARCHAR2) IS
      
      Lv_NombreParamObservacion VARCHAR2(400) := 'VALIDACIONES_CAMBIOS_PRODUCTOS_CIH';
      Lv_DescParamObservacion   VARCHAR2(400) := 'MENSAJE PREPLANIFICA SERVICIOS CIH';
      
      Ln_IdPunto                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
      Ln_IdServicio             DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
      Lv_Observacion            VARCHAR2(400);
      Lv_Caracteristica         VARCHAR2(400);
      Lv_UsrCreacion            VARCHAR2(400);
      Lv_IpCreacion             VARCHAR2(400);
      Ln_EmpresaCod             INTEGER;
      Ln_IdOficina              INTEGER;
      Lv_EstadoServicio         VARCHAR2(400);
      
      Lv_DatosSecuencia         DB_COMERCIAL.DATOS_SECUENCIA;
      Lv_NumeroContrato         VARCHAR2(400);
      Ln_Secuencia              NUMBER;
      Ln_IdNumeracion           NUMBER;
      Ln_IdOrdenTrabajo         INTEGER;
      Lb_ValidaExiste           BOOLEAN;
      Lv_EstadoActivo           VARCHAR2(400) := 'Activo';
      Lv_EstadoPendiente        VARCHAR2(400) := 'Pendiente';
      
      Ln_IdServicioHistorial    INTEGER;
      
      Lv_Status                 VARCHAR2(30);
      Lv_Mensaje                VARCHAR2(4000);
      Le_Errors                 EXCEPTION;
        
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
      
      Lc_InfoServicio        C_GetServicio%ROWTYPE;

    BEGIN

      Ln_IdPunto                := Pt_GenerarOt.Pn_IdPunto;
      Ln_IdServicio             := Pt_GenerarOt.Pn_IdServicio;
      Lv_Observacion            := Pt_GenerarOt.Pv_Observacion;
      Lv_Caracteristica         := Pt_GenerarOt.Pv_Caracteristica;
      Lv_UsrCreacion            := Pt_GenerarOt.Pv_UsrCreacion;
      Lv_IpCreacion             := Pt_GenerarOt.Pv_IpCreacion;
      Ln_EmpresaCod             := Pt_GenerarOt.Pn_EmpresaCod;
      Ln_IdOficina              := Pt_GenerarOt.Pn_IdOficina;
      Lv_EstadoServicio         := Pt_GenerarOt.Pv_EstadoServicio;
        
      --Valida Parámetros
      IF Ln_IdPunto IS NULL THEN
        Lv_Mensaje := 'El Pn_IdPunto esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Ln_EmpresaCod IS NULL THEN
        Lv_Mensaje := 'El Pn_EmpresaCod esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Ln_IdOficina IS NULL THEN
        Lv_Mensaje := 'El Pn_IdOficina esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Lv_UsrCreacion IS NULL THEN
        Lv_Mensaje := 'El Pv_UsrCreacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Lv_IpCreacion IS NULL THEN
        Lv_Mensaje := 'El Pv_IpCreacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Lv_Caracteristica IS NULL THEN --TIPO 
        Lv_Mensaje := 'El Pv_Caracteristica esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Lv_Observacion IS NULL THEN  
        Lv_Mensaje := 'El Lv_Observacion esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Ln_IdServicio IS NULL THEN  
        Lv_Mensaje := 'El Pn_IdServicio esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Lv_EstadoServicio IS NULL THEN  
        Lv_Mensaje := 'El Pv_EstadoServicio esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --Valida servicio
      OPEN C_GetServicio(Ln_IdServicio);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN  
        Lv_Mensaje := 'No se ha encontrado servicio a PrePlanificar';
        RAISE Le_Errors;
      ELSIF Lc_InfoServicio.ESTADO <> Lv_EstadoPendiente THEN
        Lv_Mensaje := 'El servicio no se encuentra en estado Pendiente para su Preplanificación';
        RAISE Le_Errors;
      END IF;
              
      --Obtener secuencia
      Lv_DatosSecuencia := DB_COMERCIAL.DATOS_SECUENCIA('ORD',
                                                        Ln_EmpresaCod,
                                                        Ln_IdOficina,
                                                        0);
      P_GENERAR_SECUENCIA(Lv_DatosSecuencia,
                          Lv_Mensaje,
                          Lv_Status,
                          Lv_NumeroContrato,
                          Ln_Secuencia,
                          Ln_IdNumeracion);
      
      IF Lv_Status <> 'OK' THEN  
        RAISE Le_Errors;
      END IF;
      Lv_Mensaje := '';
      
      --Inserta Orden de trabajo
      BEGIN
        SELECT DB_COMERCIAL.SEQ_INFO_ORDEN_TRABAJO.NEXTVAL
          INTO Ln_IdOrdenTrabajo
          FROM DUAL;
          
        INSERT INTO DB_COMERCIAL.INFO_ORDEN_TRABAJO(ID_ORDEN_TRABAJO,
                                                    PUNTO_ID,
                                                    TIPO_ORDEN,
                                                    NUMERO_ORDEN_TRABAJO,
                                                    FE_CREACION,
                                                    USR_CREACION,
                                                    IP_CREACION,
                                                    OFICINA_ID,
                                                    ESTADO)
             VALUES (Ln_IdOrdenTrabajo,
                     Ln_IdPunto,
                     Lv_Caracteristica,
                     Lv_NumeroContrato,
                     SYSDATE,
                     Lv_UsrCreacion,
                     Lv_IpCreacion,
                     Ln_IdOficina,
                     Lv_EstadoPendiente);
                     
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar la Orden de Trabajo';
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;
      
      --Actualiza servicio
      BEGIN
        
        UPDATE DB_COMERCIAL.INFO_SERVICIO ise
           SET ise.ORDEN_TRABAJO_ID = Ln_IdOrdenTrabajo,
               ise.ESTADO = Lv_EstadoServicio,
               ise.USR_CREACION = Lv_UsrCreacion,
               ise.IP_CREACION = Lv_IpCreacion
         WHERE ise.ID_SERVICIO = Lc_InfoServicio.ID_SERVICIO
           AND ise.ESTADO = Lc_InfoServicio.ESTADO;
                     
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo actualizar el estado del Servicio';
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;
            
      --Inserta Servicio Historial
      BEGIN
        
        SELECT DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL
          INTO Ln_IdServicioHistorial
          FROM DUAL;
                        
        INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL(ID_SERVICIO_HISTORIAL,
                                                        SERVICIO_ID,
                                                        OBSERVACION,
                                                        IP_CREACION,
                                                        USR_CREACION,
                                                        FE_CREACION,
                                                        ESTADO)
             VALUES (Ln_IdServicioHistorial,
                     Ln_IdServicio,
                     Lv_Observacion,
                     Lv_IpCreacion,
                     Lv_UsrCreacion,
                     SYSDATE,
                     Lv_EstadoServicio);
                     
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Mensaje := 'No se pudo insertar el Historial para el Servicio por la solicitud generada '||sqlerrm;
      END;
      
      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_Errors;
      END IF;

      Pv_Mensaje := 'Proceso realizado con exito';
      Pv_Status  := 'OK';
            
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
           
      WHEN OTHERS THEN
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           
    END P_GENERAR_OT_SERVADIC;
    
    
    PROCEDURE P_GENERAR_OTXSERVICIOS_CIH(Pcl_Request IN VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2,
                                         Pv_Status   OUT VARCHAR2) IS
      
      Lv_IpCreacion                  VARCHAR2(100);
      Lv_CodEmpresa                  VARCHAR2(100);
      Lv_PrefijoEmpresa              VARCHAR2(100);
      Lv_UsrCreacion                 VARCHAR2(100);
      Ln_PuntoId                     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
      Ln_ContratoId                  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE;
      Ln_ServicioInternetId          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
      Lv_Origen                      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Ln_IdServicioHistorial         DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE;
      
      Lv_NombreParamMD               VARCHAR2(100) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'; 
      Lv_NombreParamProductosCIH     VARCHAR2(100) := 'PRODUCTOS_TIPO_CIH';
      Lv_DescParamProductosCIH       VARCHAR2(100) := 'CODIGO DE PRODUCTO CIH';
      Lv_NombreParamObservacion      VARCHAR2(100) := 'VALIDACIONES_CAMBIOS_PRODUCTOS_CIH';
      Lv_DescParamObservaciones      VARCHAR2(100) := 'MENSAJE PREPLANIFICA SERVICIOS CIH';
      Lv_DescTipoSolicitudPlan       VARCHAR2(100) := 'SOLICITUD PLANIFICACION';
      Lv_DescTipoSolicitudAgregar    VARCHAR2(100) := 'SOLICITUD AGREGAR EQUIPO';
      Lv_DescTipoSolicitud           VARCHAR2(100);
      Lv_EstadoActivo                VARCHAR2(50)  := 'Activo';
      Lv_EstadoPendiente             VARCHAR2(50)  := 'Pendiente';
      Lv_EstadoPreplanificada        VARCHAR2(50)  := 'PrePlanificada';
      Lb_ValidaExiste                BOOLEAN;
      Lb_EsProductoCIH               BOOLEAN;
      Lv_Observacion                 VARCHAR2(4000);
                              
      Lb_ExistePendientes            BOOLEAN := FALSE;
      Lv_Mensaje                     VARCHAR2(4000);
      Lv_Status                      VARCHAR2(30);
      Le_Errors                      EXCEPTION;
      
      CURSOR C_GetPunto(Cn_IdPunto NUMBER) IS
        SELECT ip.* 
          FROM DB_COMERCIAL.INFO_PUNTO ip 
         WHERE ip.ID_PUNTO = Cn_IdPunto;
         
      CURSOR C_GetPersonaEmpresaRol(Cn_EmpresaPersonaRol NUMBER) IS
        SELECT iper.* 
          FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper 
         WHERE iper.ID_PERSONA_ROL = Cn_EmpresaPersonaRol;
        
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2,
                            Cv_Valor2      VARCHAR2,
                            Cv_valor3      VARCHAR2,
                            Cv_valor4      VARCHAR2,
                            Cv_valor5      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND (Cv_Valor2 IS NULL OR apd.VALOR2 = Cv_Valor2)
           AND (Cv_valor3 IS NULL OR apd.VALOR3 = Cv_Valor3)
           AND (Cv_valor4 IS NULL OR apd.VALOR4 = Cv_Valor4)
           AND (Cv_valor5 IS NULL OR apd.VALOR5 = Cv_Valor5)
           AND apd.ESTADO = Lv_EstadoActivo;

      CURSOR C_GetServicioPendiente(Cn_IdPunto NUMBER) IS
        SELECT ise.ID_SERVICIO, ise.PRODUCTO_ID
          FROM DB_COMERCIAL.INFO_PUNTO ipu,
               DB_COMERCIAL.INFO_ADENDUM iad,
               DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ipu.ID_PUNTO = Cn_IdPunto
           AND ipu.ID_PUNTO = iad.PUNTO_ID
           AND ipu.ID_PUNTO = ise.PUNTO_ID
           AND iad.SERVICIO_ID = ise.ID_SERVICIO
           --AND iad.CONTRATO_ID = Cn_IdContrato
           AND ise.ESTADO = Lv_EstadoPendiente
           AND ise.PLAN_ID IS NULL
           AND ise.PRODUCTO_ID IS NOT NULL
        ORDER BY ise.PRODUCTO_ID;
      
      CURSOR C_GetProducto(Cn_IdProducto NUMBER) IS
        SELECT adp.* 
          FROM DB_COMERCIAL.ADMI_PRODUCTO adp 
         WHERE adp.ID_PRODUCTO = Cn_IdProducto;     
         
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
         
      CURSOR C_GetSolicitud(Cn_IdServicio INTEGER,
                            Cv_DescSolicitud VARCHAR2,
                            Cv_EstadoSolicitud VARCHAR2) IS
        SELECT ids.*
          FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids,
               DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
         WHERE ids.SERVICIO_ID = Cn_idServicio
           AND ids.TIPO_SOLICITUD_ID = ats.ID_TIPO_SOLICITUD
           AND ats.DESCRIPCION_SOLICITUD = Cv_DescSolicitud
           AND ids.ESTADO = Cv_EstadoSolicitud;
      
      CURSOR C_GetInfoServicioTecnico(Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
      IS
        SELECT ELEMENTO.NOMBRE_ELEMENTO, MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO, MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO,
        ST.INTERFACE_ELEMENTO_CONECTOR_ID
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ST
        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
        ON ELEMENTO.ID_ELEMENTO = ST.ELEMENTO_ID
        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ELEMENTO
        ON MODELO_ELEMENTO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID
        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ELEMENTO
        ON MARCA_ELEMENTO.ID_MARCA_ELEMENTO = MODELO_ELEMENTO.MARCA_ELEMENTO_ID
        WHERE ST.SERVICIO_ID  = Cv_IdServicio;
        
      Lc_InfoServicioTecnico   C_GetInfoServicioTecnico%ROWTYPE;
           
      Lc_InfoPunto          C_GetPunto%ROWTYPE;  
      Lc_InfoServicio       C_GetServicio%ROWTYPE;
      Lc_InfoPerRol         C_GetPersonaEmpresaRol%ROWTYPE;
      Lc_AdmiParametroDet   C_GetParametro%ROWTYPE;
      Lc_AdmiParametroObs   C_GetParametro%ROWTYPE;
      Lc_TipoNuevoOnt       C_GetParametro%ROWTYPE;
      Lc_AdmiProducto       C_GetProducto%ROWTYPE;
      Pcl_Preplanifica_Adc  DB_COMERCIAL.DATOS_GENERAR_OT_TYPE;
      Lc_InfoDetSolicitud   C_GetSolicitud%ROWTYPE;
      

    BEGIN 

      --1.- Verifica parámetros obtenidos
      APEX_JSON.PARSE(Pcl_Request);
      Lv_IpCreacion           := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
      Lv_CodEmpresa           := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
      Lv_PrefijoEmpresa       := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
      Lv_UsrCreacion          := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
      Lv_Origen               := APEX_JSON.get_varchar2(p_path => 'origen');
      Ln_PuntoId              := APEX_JSON.get_number(p_path => 'puntoId');
      Ln_ServicioInternetId   := APEX_JSON.get_number(p_path => 'servicioInternetId');

      IF Ln_PuntoId IS NULL THEN
        Lv_Mensaje := 'El parametro puntoId esta vacio';
        RAISE Le_Errors;
      END IF;
      IF Lv_CodEmpresa IS NULL THEN
        Lv_Mensaje := 'El parámetro codEmpresa esta vacío';
        RAISE Le_Errors;
      END IF;
      IF Ln_ServicioInternetId IS NULL THEN
        Lv_Mensaje := 'El parámetro servicioInternetId esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --2.- Verifica datos en base
      OPEN C_GetPunto(Ln_PuntoId);
      FETCH C_GetPunto INTO Lc_InfoPunto;
      Lb_ValidaExiste := C_GetPunto%FOUND;
      CLOSE C_GetPunto;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'El puntoId no existe';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetServicio(Ln_ServicioInternetId);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'El servicioInternetId no existe';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetPersonaEmpresaRol(Lc_InfoPunto.PERSONA_EMPRESA_ROL_ID);
      FETCH C_GetPersonaEmpresaRol INTO Lc_InfoPerRol;
      Lb_ValidaExiste := C_GetPersonaEmpresaRol%FOUND;
      CLOSE C_GetPersonaEmpresaRol;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'La PERSONA_EMPRESA_ROL_ID no existe';
        RAISE Le_Errors;
      END IF;
      
      IF Lc_InfoServicio.ESTADO = Lv_EstadoPreplanificada THEN
        --3.- Recorre servicios adicionales del punto
        FOR servicio IN C_GetServicioPendiente(Lc_InfoPunto.ID_PUNTO) LOOP
                  
          --3.1.- Valida producto CIH
          Lb_EsProductoCIH := FALSE;
          FOR parametro IN C_GetParametro(Lv_NombreParamProductosCIH,
                                          Lv_DescParamProductosCIH,
                                          Lv_CodEmpresa,
                                          '','','','','') LOOP
            IF parametro.VALOR1 = servicio.PRODUCTO_ID THEN
              Lb_EsProductoCIH := TRUE;
              EXIT;
            END IF;
          END LOOP;
          
          --3.2.- Validación de producto y generación de solicitudes
          IF Lb_EsProductoCIH  THEN
          
            Lb_ExistePendientes := TRUE;
            
            OPEN C_GetProducto(servicio.PRODUCTO_ID);
            FETCH C_GetProducto INTO Lc_AdmiProducto;
            Lb_ValidaExiste := C_GetProducto%FOUND;
            CLOSE C_GetProducto;
            
            IF Lb_ValidaExiste THEN
              
              IF Lc_AdmiProducto.NOMBRE_TECNICO <> 'EXTENDER_DUAL_BAND' THEN
                Lv_DescTipoSolicitud:= Lv_DescTipoSolicitudPlan;
              ELSE
                Lv_DescTipoSolicitud:= Lv_DescTipoSolicitudAgregar;
              END IF;
              
              --Verifica si posee una solicitud en PrePlanificacion
              OPEN C_GetSolicitud(servicio.ID_SERVICIO,
                                  Lv_DescTipoSolicitud,
                                  Lv_EstadoPreplanificada);
              FETCH C_GetSolicitud INTO Lc_InfoDetSolicitud;
              Lb_ValidaExiste := C_GetSolicitud%FOUND;
              CLOSE C_GetSolicitud;
                
              IF Lb_ValidaExiste THEN
                
                --Obtiene observación por solicitud generada
                OPEN C_GetParametro(Lv_NombreParamObservacion,
                                    Lv_DescParamObservaciones,
                                    Lv_CodEmpresa,
                                    Lv_Origen,'','','','');
                FETCH C_GetParametro INTO Lc_AdmiParametroObs;
                Lb_ValidaExiste := C_GetParametro%FOUND;
                CLOSE C_GetParametro;
                  
                IF NOT Lb_ValidaExiste THEN
                  Lv_Mensaje := 'No se ha encontrado la observación para el historial de servicio CIH';
                  RAISE Le_Errors;
                END IF;
                  
                Lv_Observacion := Lc_AdmiParametroObs.VALOR2;
                Lv_Observacion := REPLACE(Lv_Observacion,'{numero_solicitud}',Lc_InfoDetSolicitud.ID_DETALLE_SOLICITUD);
                Lv_Observacion := REPLACE(Lv_Observacion,'{tipo_solicitud}',Lv_DescTipoSolicitud);
                
              ELSE
                Lv_Mensaje := 'No se ha generado la '||Lv_DescTipoSolicitud
                          ||' para el servicio con producto ' || Lc_AdmiProducto.NOMBRE_TECNICO;
                RAISE Le_Errors;
              END IF;
                            
              Pcl_Preplanifica_Adc := DB_COMERCIAL.DATOS_GENERAR_OT_TYPE(
                                            Lc_InfoPunto.ID_PUNTO,
                                            Lc_AdmiProducto.ID_PRODUCTO,
                                            servicio.ID_SERVICIO,
                                            Lv_Observacion,
                                            'N',--CARACTERISTICA --TIPO
                                            Lv_UsrCreacion,
                                            Lv_IpCreacion,
                                            Lv_CodEmpresa,
                                            Lc_InfoPerRol.OFICINA_ID,
                                            Lv_EstadoPreplanificada,
                                            Lv_DescTipoSolicitud,
                                            '');
                                            
              P_GENERAR_OT_SERVADIC(Pcl_Preplanifica_Adc, Lv_Mensaje, Lv_Status);
                  
              IF Lv_Status <> 'OK' THEN
                RAISE Le_Errors;
              END IF;
                  
              Lv_Status := NULL;
              Lv_Mensaje := NULL;
              
              IF Lc_AdmiProducto.NOMBRE_TECNICO = 'EXTENDER_DUAL_BAND' THEN
                --Envio de notificacion por preplanificacion
                P_ENVIA_NOTIFICACION(Lc_InfoPunto.ID_PUNTO,
                                     servicio.ID_SERVICIO,
                                     'SOLICITUD AGREGAR EQUIPO creada automáticamente'
                                       ||'<br>Incluye agregar equipo Extender Dual Band.',
                                     Lv_DescTipoSolicitudAgregar,
                                     Lv_UsrCreacion,
                                     Lv_IpCreacion,
                                     Lv_Status,
                                     Lv_Mensaje);
              END IF;
              
            ELSE
              Lv_Mensaje := 'Producto no encontrado: '||servicio.PRODUCTO_ID;
              RAISE Le_Errors;
            END IF;
            
          END IF;
          
        END LOOP;
        
        --Verifica si se generó solicitud en servicio de internet
        --por cambio de ONT, para el registro en historial
        --y envío de notificación
        OPEN C_GetSolicitud(Ln_ServicioInternetId,
                            Lv_DescTipoSolicitudAgregar,
                            Lv_EstadoPreplanificada);
        FETCH C_GetSolicitud INTO Lc_InfoDetSolicitud;
        Lb_ValidaExiste := C_GetSolicitud%FOUND;
        CLOSE C_GetSolicitud;
        
        IF Lb_ValidaExiste THEN
        
          --Obtiene marca y modelo de equipo
          OPEN C_GetInfoServicioTecnico(Ln_ServicioInternetId);
          FETCH C_GetInfoServicioTecnico INTO Lc_InfoServicioTecnico;
          CLOSE C_GetInfoServicioTecnico;
          
          OPEN C_GetParametro(Lv_NombreParamMD,
                              '', Lv_CodEmpresa,
                              'TIPOS_EQUIPOS',
                              Lc_InfoServicioTecnico.NOMBRE_MARCA_ELEMENTO,
                              Lc_InfoServicioTecnico.NOMBRE_MODELO_ELEMENTO,
                              '','TIPOS_EQUIPOS_ONT_PARA_EXTENDER');
          FETCH C_GetParametro INTO Lc_TipoNuevoOnt;
          CLOSE C_GetParametro;
        
          --Obtiene observación por solicitud generada
          OPEN C_GetParametro(Lv_NombreParamObservacion,
                              Lv_DescParamObservaciones,
                              Lv_CodEmpresa,
                              'CAMBIO_ONT_NUEVO','','','','');
          FETCH C_GetParametro INTO Lc_AdmiParametroObs;
          Lb_ValidaExiste := C_GetParametro%FOUND;
          CLOSE C_GetParametro;
                  
          IF NOT Lb_ValidaExiste THEN
            Lv_Mensaje := 'No se ha encontrado la observación para el historial de servicio internet.';
            RAISE Le_Errors;
          END IF;
                  
          Lv_Observacion := Lc_AdmiParametroObs.VALOR2;
          Lv_Observacion := REPLACE(Lv_Observacion,'{tipo_solicitud}',Lv_DescTipoSolicitudAgregar);
          Lv_Observacion := REPLACE(Lv_Observacion,'{numero_solicitud}',TO_CHAR(Lc_InfoDetSolicitud.ID_DETALLE_SOLICITUD));
          Lv_Observacion := REPLACE(Lv_Observacion,'{tipo_ont_nueva}',Lc_TipoNuevoOnt.VALOR4);
          
          --Inserta Servicio Historial
          BEGIN
            
            SELECT DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL
              INTO Ln_IdServicioHistorial
              FROM DUAL;
            
            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL(ID_SERVICIO_HISTORIAL,
                                                            SERVICIO_ID,
                                                            OBSERVACION,
                                                            IP_CREACION,
                                                            USR_CREACION,
                                                            FE_CREACION,
                                                            ESTADO)
                 VALUES (Ln_IdServicioHistorial,
                         Ln_ServicioInternetId,
                         Lv_Observacion,
                         Lv_IpCreacion,
                         Lv_UsrCreacion,
                         SYSDATE,
                         Lv_EstadoPreplanificada);
                         
          EXCEPTION
            WHEN OTHERS THEN
              Lv_Mensaje := 'No se pudo insertar el Historial para el Servicio por la solicitud generada';
          END;
          
          IF Lv_Mensaje IS NOT NULL THEN
            RAISE Le_Errors;
          END IF;
          
          --Obtiene observación para envío por correo
          Lv_Observacion := Lv_DescTipoSolicitudAgregar || ' creada automáticamente.'
                              || '<br>Incluye cambio de CPE ONT a un ' || Lc_TipoNuevoOnt.VALOR4;
          
          --Envio de notificacion por cambio de ont
          P_ENVIA_NOTIFICACION(Lc_InfoPunto.ID_PUNTO,
                               Ln_ServicioInternetId,
                               Lv_Observacion,
                               Lv_DescTipoSolicitudAgregar,
                               Lv_UsrCreacion,
                               Lv_IpCreacion,
                               Lv_Status,
                               Lv_Mensaje);
                                     
        END IF;
        
        
        IF NOT Lb_ExistePendientes THEN
          Lv_Mensaje := 'No se encontraron productos CIH pendientes';
        END IF;
        
      ELSE
        Lv_Mensaje := 'El servicio de internet no se encuentra '||Lv_EstadoPreplanificada;
      END IF;
      
      
      Pv_Mensaje := Lv_Mensaje;
      Pv_Status := 'OK';
      
      COMMIT;
      
    EXCEPTION
      WHEN Le_Errors THEN
        ROLLBACK;
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'Telcos+',
           'DB_COMERCIAL.CMKG_PRODUCTO_CIH.P_GENERAR_OTXSERVICIOS_CIH',
           'Error: '||Pv_Mensaje ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');
           
      WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'Telcos+',
           'DB_COMERCIAL.CMKG_PRODUCTO_CIH.P_GENERAR_OTXSERVICIOS_CIH',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_GENERAR_OTXSERVICIOS_CIH;
    
    
    PROCEDURE P_REVERSA_PREPLANIFICACION(Pcl_Request IN VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2,
                                         Pv_Status   OUT VARCHAR2) IS
      
      Lv_IpCreacion                  VARCHAR2(100);
      Lv_CodEmpresa                  VARCHAR2(100);
      Lv_PrefijoEmpresa              VARCHAR2(100);
      Lv_UsrCreacion                 VARCHAR2(100);
      Ln_PuntoId                     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
      Ln_ServicioInternetId          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
      Lv_Origen                      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Ln_IdDetalleSolHist            DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ID_SOLICITUD_HISTORIAL%TYPE;
      
      Lv_NombreParamProductosCIH     VARCHAR2(100) := 'PRODUCTOS_TIPO_CIH';
      Lv_DescParamProductosCIH       VARCHAR2(100) := 'CODIGO DE PRODUCTO CIH';
      Lv_DescTipoSolicitudPlan       VARCHAR2(100) := 'SOLICITUD PLANIFICACION';
      Lv_DescTipoSolicitudAgregar    VARCHAR2(100) := 'SOLICITUD AGREGAR EQUIPO';
      Lv_DescTipoSolicitud           VARCHAR2(100);
      Lv_EstadoActivo                VARCHAR2(50)  := 'Activo';
      Lv_EstadoPendiente             VARCHAR2(50)  := 'Pendiente';
      Lv_EstadoPreplanificada        VARCHAR2(50)  := 'PrePlanificada';
      Lv_EstadoEliminada             VARCHAR2(50)  := 'Eliminada';
      Lb_ValidaExiste                BOOLEAN;
      Lb_EsProductoCIH               BOOLEAN;
      
      Lb_ExistePendientes            BOOLEAN := FALSE;
      Lv_Mensaje                     VARCHAR2(4000);
      Le_Errors                      EXCEPTION;
      
      CURSOR C_GetPunto(Cn_IdPunto NUMBER) IS
        SELECT ip.* 
          FROM DB_COMERCIAL.INFO_PUNTO ip 
         WHERE ip.ID_PUNTO = Cn_IdPunto;
         
      CURSOR C_GetPersonaEmpresaRol(Cn_EmpresaPersonaRol NUMBER) IS
        SELECT iper.* 
          FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper 
         WHERE iper.ID_PERSONA_ROL = Cn_EmpresaPersonaRol;
        
      CURSOR C_GetParametro(Cv_NombreParam VARCHAR2,
                            Cv_DescParam   VARCHAR2,
                            Cv_CodEmpresa  VARCHAR2,
                            Cv_Valor1      VARCHAR2,
                            Cv_Valor2      VARCHAR2,
                            Cv_valor3      VARCHAR2,
                            Cv_valor4      VARCHAR2,
                            Cv_valor5      VARCHAR2) IS
        SELECT apd.* 
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
               DB_GENERAL.ADMI_PARAMETRO_DET apd
         WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParam
           AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
           AND apd.EMPRESA_COD = Cv_CodEmpresa
           AND (Cv_DescParam IS NULL OR apd.DESCRIPCION = Cv_DescParam)
           AND (Cv_Valor1 IS NULL OR apd.VALOR1 = Cv_Valor1)
           AND (Cv_Valor2 IS NULL OR apd.VALOR2 = Cv_Valor2)
           AND (Cv_valor3 IS NULL OR apd.VALOR3 = Cv_Valor3)
           AND (Cv_valor4 IS NULL OR apd.VALOR4 = Cv_Valor4)
           AND (Cv_valor5 IS NULL OR apd.VALOR5 = Cv_Valor5)
           AND apd.ESTADO = Lv_EstadoActivo;

      CURSOR C_GetServicioPendiente(Cn_IdPunto NUMBER) IS
        SELECT ise.ID_SERVICIO, ise.PRODUCTO_ID
          FROM DB_COMERCIAL.INFO_PUNTO ipu,
               DB_COMERCIAL.INFO_ADENDUM iad,
               DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ipu.ID_PUNTO = Cn_IdPunto
           AND ipu.ID_PUNTO = iad.PUNTO_ID
           AND ipu.ID_PUNTO = ise.PUNTO_ID
           AND iad.SERVICIO_ID = ise.ID_SERVICIO
           --AND iad.CONTRATO_ID = Cn_IdContrato
           AND ise.ESTADO = Lv_EstadoPendiente
           AND ise.PLAN_ID IS NULL
           AND ise.PRODUCTO_ID IS NOT NULL
        ORDER BY ise.PRODUCTO_ID;
      
      CURSOR C_GetProducto(Cn_IdProducto NUMBER) IS
        SELECT adp.* 
          FROM DB_COMERCIAL.ADMI_PRODUCTO adp 
         WHERE adp.ID_PRODUCTO = Cn_IdProducto;     
         
      CURSOR C_GetServicio(Cn_IdServicio INTEGER) IS
        SELECT ise.*
          FROM DB_COMERCIAL.INFO_SERVICIO ise
         WHERE ise.ID_SERVICIO = Cn_IdServicio;
         
      CURSOR C_GetSolicitud(Cn_IdServicio INTEGER,
                            Cv_DescSolicitud VARCHAR2,
                            Cv_EstadoSolicitud VARCHAR2) IS
        SELECT ids.*
          FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids,
               DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
         WHERE ids.SERVICIO_ID = Cn_idServicio
           AND ids.TIPO_SOLICITUD_ID = ats.ID_TIPO_SOLICITUD
           AND ats.DESCRIPCION_SOLICITUD = Cv_DescSolicitud
           AND ids.ESTADO = Cv_EstadoSolicitud;
                   
      Lc_InfoPunto          C_GetPunto%ROWTYPE;  
      Lc_InfoServicio       C_GetServicio%ROWTYPE;
      Lc_InfoPerRol         C_GetPersonaEmpresaRol%ROWTYPE;
      Lc_AdmiProducto       C_GetProducto%ROWTYPE;
      Lc_InfoDetSolicitud   C_GetSolicitud%ROWTYPE;
      

    BEGIN 

      --1.- Verifica parámetros obtenidos
      APEX_JSON.PARSE(Pcl_Request);
      Lv_IpCreacion           := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
      Lv_CodEmpresa           := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
      Lv_PrefijoEmpresa       := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
      Lv_UsrCreacion          := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
      Lv_Origen               := APEX_JSON.get_varchar2(p_path => 'origen');
      Ln_PuntoId              := APEX_JSON.get_number(p_path => 'puntoId');
      Ln_ServicioInternetId   := APEX_JSON.get_number(p_path => 'servicioInternetId');

      IF Ln_PuntoId IS NULL THEN
        Lv_Mensaje := 'El parametro puntoId esta vacio';
        RAISE Le_Errors;
      END IF;
      IF Lv_CodEmpresa IS NULL THEN
        Lv_Mensaje := 'El parámetro codEmpresa esta vacío';
        RAISE Le_Errors;
      END IF;
      
      --2.- Verifica datos en base
      OPEN C_GetPunto(Ln_PuntoId);
      FETCH C_GetPunto INTO Lc_InfoPunto;
      Lb_ValidaExiste := C_GetPunto%FOUND;
      CLOSE C_GetPunto;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'El puntoId no existe';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetServicio(Ln_ServicioInternetId);
      FETCH C_GetServicio INTO Lc_InfoServicio;
      Lb_ValidaExiste := C_GetServicio%FOUND;
      CLOSE C_GetServicio;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'El servicioInternetId no existe';
        RAISE Le_Errors;
      END IF;
      
      OPEN C_GetPersonaEmpresaRol(Lc_InfoPunto.PERSONA_EMPRESA_ROL_ID);
      FETCH C_GetPersonaEmpresaRol INTO Lc_InfoPerRol;
      Lb_ValidaExiste := C_GetPersonaEmpresaRol%FOUND;
      CLOSE C_GetPersonaEmpresaRol;
      IF NOT Lb_ValidaExiste THEN
        Lv_Mensaje := 'La PERSONA_EMPRESA_ROL_ID no existe';
        RAISE Le_Errors;
      END IF;
      
        --3.- Recorre servicios adicionales del punto
        FOR servicio IN C_GetServicioPendiente(Lc_InfoPunto.ID_PUNTO) LOOP
                  
          --3.1.- Valida producto CIH
          Lb_EsProductoCIH := FALSE;
          FOR parametro IN C_GetParametro(Lv_NombreParamProductosCIH,
                                          Lv_DescParamProductosCIH,
                                          Lv_CodEmpresa,
                                          '','','','','') LOOP
            IF parametro.VALOR1 = servicio.PRODUCTO_ID THEN
              Lb_EsProductoCIH := TRUE;
              EXIT;
            END IF;
          END LOOP;
          
          --3.2.- Validación de producto y generación de solicitudes
          IF Lb_EsProductoCIH  THEN
          
            Lb_ExistePendientes := TRUE;
            
            OPEN C_GetProducto(servicio.PRODUCTO_ID);
            FETCH C_GetProducto INTO Lc_AdmiProducto;
            Lb_ValidaExiste := C_GetProducto%FOUND;
            CLOSE C_GetProducto;
            
            IF Lb_ValidaExiste THEN
              
              IF Lc_AdmiProducto.NOMBRE_TECNICO <> 'EXTENDER_DUAL_BAND' THEN
                Lv_DescTipoSolicitud:= Lv_DescTipoSolicitudPlan;
              ELSE
                Lv_DescTipoSolicitud:= Lv_DescTipoSolicitudAgregar;
              END IF;
              
              --Verifica si posee una solicitud por preplanificación
              OPEN C_GetSolicitud(servicio.ID_SERVICIO,
                                  Lv_DescTipoSolicitud,
                                  Lv_EstadoPreplanificada);
              FETCH C_GetSolicitud INTO Lc_InfoDetSolicitud;
              Lb_ValidaExiste := C_GetSolicitud%FOUND;
              CLOSE C_GetSolicitud;
                
              IF Lb_ValidaExiste THEN
                
                UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
                   SET ids.ESTADO = Lv_EstadoEliminada
                 WHERE ids.ID_DETALLE_SOLICITUD = Lc_InfoDetSolicitud.ID_DETALLE_SOLICITUD
                   AND ids.ESTADO = Lv_EstadoPreplanificada;
                
                --Inserta Detalle de Solicitud Historial
                BEGIN
                  
                  SELECT DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL
                    INTO Ln_IdDetalleSolHist
                    FROM DUAL;
                  
                  INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL,
                                                                 DETALLE_SOLICITUD_ID,
                                                                 IP_CREACION,
                                                                 FE_CREACION,
                                                                 USR_CREACION,
                                                                 ESTADO,
                                                                 OBSERVACION)
                       VALUES (Ln_IdDetalleSolHist,
                               Lc_InfoDetSolicitud.ID_DETALLE_SOLICITUD,
                               Lv_IpCreacion,
                               SYSDATE,
                               Lv_UsrCreacion,
                               Lv_EstadoEliminada,
                               'Eliminación por reverso de proceso preplanificación CIH.');
                EXCEPTION
                  WHEN OTHERS THEN
                    Lv_Mensaje := 'No se pudo insertar el Historial por eliminación de ' || Lv_DescTipoSolicitud;
                END;
                
                IF Lv_Mensaje IS NOT NULL THEN
                  RAISE Le_Errors;
                END IF;
                
              END IF;
              
            ELSE
              Lv_Mensaje := 'Producto no encontrado: '||servicio.PRODUCTO_ID;
              RAISE Le_Errors;
            END IF;
            
          END IF;
          
        END LOOP;
        
        --Verifica si se generó solicitud en servicio de internet
        --por cambio de ONT, para su eliminación
        OPEN C_GetSolicitud(Ln_ServicioInternetId,
                            Lv_DescTipoSolicitudAgregar,
                            Lv_EstadoPreplanificada);
        FETCH C_GetSolicitud INTO Lc_InfoDetSolicitud;
        Lb_ValidaExiste := C_GetSolicitud%FOUND;
        CLOSE C_GetSolicitud;
        
        IF Lb_ValidaExiste THEN
        
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
             SET ids.ESTADO = Lv_EstadoEliminada
           WHERE ids.ID_DETALLE_SOLICITUD = Lc_InfoDetSolicitud.ID_DETALLE_SOLICITUD
             AND ids.ESTADO = Lv_EstadoPreplanificada;
                
          --Inserta Detalle de Solicitud Historial
          BEGIN
                  
            SELECT DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL
              INTO Ln_IdDetalleSolHist
              FROM DUAL;
                  
            INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL,
                                                           DETALLE_SOLICITUD_ID,
                                                           IP_CREACION,
                                                           FE_CREACION,
                                                           USR_CREACION,
                                                           ESTADO,
                                                           OBSERVACION)
                VALUES (Ln_IdDetalleSolHist,
                       Lc_InfoDetSolicitud.ID_DETALLE_SOLICITUD,
                       Lv_IpCreacion,
                       SYSDATE,
                       Lv_UsrCreacion,
                       Lv_EstadoEliminada,
                       'Eliminación por reverso de proceso preplanificación CIH.');
          EXCEPTION
            WHEN OTHERS THEN
              Lv_Mensaje := 'No se pudo insertar el Historial por eliminación de ' || Lv_DescTipoSolicitudAgregar;
          END;
                
          IF Lv_Mensaje IS NOT NULL THEN
            RAISE Le_Errors;
          END IF;
                                     
        END IF;
        
        IF NOT Lb_ExistePendientes THEN
          Lv_Mensaje := 'No se encontraron productos CIH pendientes';
        END IF;
      
      
      Pv_Mensaje := Lv_Mensaje;
      Pv_Status := 'OK';
      
      COMMIT;
      
    EXCEPTION
      WHEN Le_Errors THEN
        ROLLBACK;
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := Lv_Mensaje;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'Telcos+',
           'DB_COMERCIAL.CMKG_PRODUCTO_CIH.P_REVERSA_PREPLANIFICACION',
           'Error: '||Pv_Mensaje ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');
           
      WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR'; 
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'Telcos+',
           'DB_COMERCIAL.CMKG_PRODUCTO_CIH.P_REVERSA_PREPLANIFICACION',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_REVERSA_PREPLANIFICACION;
    
END CMKG_PRODUCTO_CIH;
/