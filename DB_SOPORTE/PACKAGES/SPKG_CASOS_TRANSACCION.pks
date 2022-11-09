CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_CASOS_TRANSACCION AS 

  /**
   * Documentación para proceso 'P_CREAR_CASO'
   * Procedimiento encargado de registrar un caso en sus diferentes estructuras
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [codEmpresa                                              Código empresa,
   *  prefijoEmpresa                                          Prefijo de empresa,
   *  formaContacto                                           Forma de contacto de quien reporta el caso,
   *  tipoCaso                                                Nombre del tipo de caso,
   *  nivelCriticidad                                         Nombre del nivel de criticidad,
   *  tipoAfectacion                                          Nombre del tipo de afectación,
   *  fechaApertura                                           Fecha y hora en que se apertura el caso, por default SYSDATE,
   *  tituloInicial                                           Titulo con el que se apertura el caso
   *  versionInicial                                          Versión indicada por el que apertura el caso,
   *  usuario                                                 Usuario quien apertura el caso,
   *  ip                                                      Ip desde donde se apertura el caso,
   *  tipoBackbone                                            Si es caso backbone, se permite indicar el tipo,
   *  origen                                                  Indica el origen de donde se apertura el caso,
   *  persona.idPersona                                       Id Persona del cliente que apertura el caso,
   *  persona.razonSocial                                     Razon Social del cliente que apertura el caso,
   *  persona.nombres                                         Nombres del cliente que apertura el caso,
   *  persona.apellidos                                       Apellidos del cliente que apertura el caso,
   *  sintomas[].idSintoma                                    Id del Sintoma con el cual se apertura el caso,
   *  sintomas[].afectados[].idPunto                          Id del punto afectado,
   *  sintomas[].afectados[].login                            Login del punto afectado,
   *  sintomas[].afectados[].servicios[].idServicio           Id del servicio afectado,
   *  sintomas[].afectados[].servicios[].descripcionProducto  Descripción del producto que tiene el servicio
   *  tipoSoporte                                             Este valor será utilizado por la extranet para que internamente 
   *                                                          el caso se asigne al departamento correspondiente]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la transacción
   * @param Prf_Response  OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    04-10-2021
   */
  PROCEDURE P_CREAR_CASO (Pcl_Request  IN CLOB,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Prf_Response OUT SYS_REFCURSOR);
  
  /** 
   * Documentación para el proceso 'P_ASIGNAR_RESPONSABLE_CASO'
   * Procedimiento encargado de asignar a el responsable al caso, segun la informacion recibida 
   * @param Pcl_Request    IN   CLOB Recibe json request
   * [codEmpresa          Código de la empresa,
   *  idCaso              Id del Caso,
   *  idFormaContacto     Id de la Forma de Contacto,
   *  idDetalleHipotesis  Id del detalle de Hipotesis,
   *  idAsignado          Id del asignado al caso (id persona empresa rol)
   *  usuario             Usuario quien asigna el caso,
   *  ip                  Ip de donde se genera asigna el caso]
   * @param Pv_Status   OUT  VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje  OUT  VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    12-11-2021
   */                                     
  PROCEDURE P_ASIGNAR_RESPONSABLE_CASO(Pcl_Request  IN CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2);
                                     
  /**
   * Documentación para proceso 'P_ADJUNTAR_DOCUMENTOS_CASO'
   * Procedimiento encargado de adjuntar uno o varios documentos al caso
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [codEmpresa                    Código empresa,
   *  idCaso                        Identificador del caso,
   *  usuario                       Usuario quien asigna archivo(s) al caso,
   *  ip                            Ip desde donde se asigna archivo(s) al caso,
   *  documentos[].nombreDocumento  Nombre de archivo que se adjunta al caso
   *  documentos[].rutaDocumento    Ruta de archivo que se adjunta al caso]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la transacción
   * @param Prf_Response  OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    12-11-2021
   */
  PROCEDURE P_ADJUNTAR_DOCUMENTOS_CASO(Pcl_Request  IN CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Prf_Response OUT SYS_REFCURSOR);                                      

END SPKG_CASOS_TRANSACCION;

/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_CASOS_TRANSACCION AS

  PROCEDURE P_CREAR_CASO (Pcl_Request  IN CLOB,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Prf_Response OUT SYS_REFCURSOR) AS
    
    Lr_InfoEmpresaGrupo        DB_COMERCIAL.INFO_EMPRESA_GRUPO%ROWTYPE;
    Lr_AdmiFormaContacto       DB_COMERCIAL.ADMI_FORMA_CONTACTO%ROWTYPE;
    Lr_InfoPersona             DB_COMERCIAL.INFO_PERSONA%ROWTYPE;
    Lr_AdmiParametroDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_AdmiTipoCaso            ADMI_TIPO_CASO%ROWTYPE;
    Lr_AdmiNivelCriticidad     ADMI_NIVEl_CRITICIDAD%ROWTYPE;
    Lr_InfoCaso                INFO_CASO%ROWTYPE;
    Lr_InfoCasoHistorial       INFO_CASO_HISTORIAL%ROWTYPE;
    Lv_PrefijoEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
    Lv_FormaContacto           DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE;
    Ln_IdDocumento             DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Ln_IdComunicacion          DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE;
    Ln_IdDocComunicacion       DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION.ID_DOCUMENTO_COMUNICACION%TYPE;  
    Lv_TipoCaso                ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE;    
    Lv_NivelCriticidad         ADMI_NIVEl_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD%TYPE;
    Lv_NumeroCaso              INFO_CASO.NUMERO_CASO%TYPE := 'N';
    Ln_IdDetalleHipotesis      INFO_DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS%TYPE;
    Ln_IdDetalle               INFO_DETALLE.ID_DETALLE%TYPE;
    Ln_IdCriterioAfectado      INFO_CRITERIO_AFECTADO.ID_CRITERIO_AFECTADO%TYPE;    
    Ln_IdParteAfectada         INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE;
    Ln_IdAsignado              INFO_CASO_ASIGNACION.REF_ASIGNADO_ID%TYPE;
    Ln_IdHipotesis             ADMI_HIPOTESIS.ID_HIPOTESIS%TYPE;
    Lr_ClaseDocumento          SPKG_TYPES.Ltr_ClaseDocumento;
    Lrf_ClasesDocumento        SYS_REFCURSOR;
    Lcl_Request                CLOB;
    Lv_FeApertura              VARCHAR2(25);
    Lv_NombreCliente           VARCHAR2(250);
    Lv_Status                  VARCHAR2(200);
    Lv_TipoSoporte             VARCHAR2(100);
    Lv_Code                    VARCHAR2(20);
    Lv_Mensaje                 VARCHAR2(200);
    Ln_CantSintomas            NUMBER;
    Ln_CantAfectados           NUMBER;
    Ln_CantServicios           NUMBER;
    Ln_Contador                INTEGER := 1;    
    Le_Error                   EXCEPTION;    
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lr_InfoCaso.Empresa_Cod         := APEX_JSON.get_varchar2('codEmpresa');
    Lv_PrefijoEmpresa               := APEX_JSON.get_varchar2('prefijoEmpresa');
    Lv_FormaContacto                := APEX_JSON.get_varchar2('formaContacto');
    Lv_TipoCaso                     := APEX_JSON.get_varchar2('tipoCaso');
    Lv_NivelCriticidad              := APEX_JSON.get_varchar2('nivelCriticidad');
    Lr_InfoCaso.Tipo_Afectacion     := APEX_JSON.get_varchar2('tipoAfectacion');
    Lv_FeApertura                   := APEX_JSON.get_varchar2('fechaApertura');
    Lr_InfoCaso.Titulo_Ini          := APEX_JSON.get_varchar2('tituloInicial');
    Lr_InfoCaso.Version_Ini         := APEX_JSON.get_varchar2('versionInicial');
    Lr_InfoCaso.Usr_Creacion        := APEX_JSON.get_varchar2('usuario');
    Lr_InfoCaso.Ip_Creacion         := APEX_JSON.get_varchar2('ip');
    Lr_InfoCaso.Tipo_Backbone       := APEX_JSON.get_varchar2('tipoBackbone');
    Lr_InfoCaso.Origen              := APEX_JSON.get_varchar2('origen');
    Lr_InfoPersona.Id_Persona       := APEX_JSON.get_number('persona.idPersona');
    Lr_InfoPersona.Razon_Social     := APEX_JSON.get_varchar2('persona.razonSocial');
    Lr_InfoPersona.Nombres          := APEX_JSON.get_varchar2('persona.nombres');
    Lr_InfoPersona.Apellidos        := APEX_JSON.get_varchar2('persona.apellidos');
    Lv_TipoSoporte                  := APEX_JSON.get_varchar2('tipoSoporte');
       
    IF Lr_InfoCaso.Empresa_Cod IS NULL AND Lv_PrefijoEmpresa IS NULL THEN
      Pv_Mensaje := 'El parametro codEmpresa o prefijoEmpresa debe ser ingresado';
      RAISE Le_Error;
    END IF;
    
    IF Lv_FormaContacto IS NULL THEN
      Pv_Mensaje := 'El parametro formaContacto debe ser ingresado';
      RAISE Le_Error;
    END IF;
    
    IF Lv_TipoCaso IS NULL THEN
      Pv_Mensaje := 'El parametro tipoCaso debe ser ingresado';
      RAISE Le_Error;
    END IF;
    
    IF Lv_NivelCriticidad IS NULL THEN
      Pv_Mensaje := 'El parametro  nivelCriticidad debe ser ingresado';
      RAISE Le_Error;
    END IF;
    
    IF Lv_FeApertura IS NULL THEN
      Lr_InfoCaso.Fe_Apertura := sysdate;
      Lv_FeApertura := TO_CHAR(sysdate,'rrrr-mm-dd hh24:mi:ss');
    ELSE
      Lr_InfoCaso.Fe_Apertura := To_Date(Lv_FeApertura,'rrrr-mm-dd hh24:mi:ss');
    END IF;
    
    IF Lr_InfoPersona.Razon_Social IS NULL THEN
      Lv_NombreCliente := Lr_InfoPersona.Nombres || ' ' ||Lr_InfoPersona.Apellidos;
    ELSE
      Lv_NombreCliente := Lr_InfoPersona.Razon_Social;
    END IF;
    
    IF Lr_InfoCaso.Empresa_Cod IS NULL THEN    
      DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C.P_GET_INFO_EMPRESA_GRUPO(Pv_Prefijo          => Lv_PrefijoEmpresa, 
                                                                    Pv_Estado           => 'Activo',
                                                                    Pr_InfoEmpresaGrupo => Lr_InfoEmpresaGrupo,
                                                                    Pv_Status           => Lv_Status,
                                                                    Pv_Mensaje          => Lv_Mensaje);                                                                  
      IF Lr_InfoEmpresaGrupo.Cod_Empresa IS NULL THEN
        Pv_Mensaje := 'No existe codEmpresa con el prefijoEmpresa ingresado';
        RAISE Le_Error;
      END IF;      
      Lr_InfoCaso.Empresa_Cod := Lr_InfoEmpresaGrupo.Cod_Empresa;
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
    Lr_InfoCaso.Forma_Contacto_Id := Lr_AdmiFormaContacto.Id_Forma_Contacto;
    
    SPKG_CASOS_CONSULTA.P_GET_ADMI_TIPO_CASO(Pv_NombreTipoCaso => Lv_TipoCaso,
                                             Pv_Estado         => 'Activo',
                                             Pr_AdmiTipoCaso   => Lr_AdmiTipoCaso,
                                             Pv_Status         => Lv_Status,
                                             Pv_Mensaje        => Lv_Mensaje);                                      
    IF Lr_AdmiTipoCaso.Id_Tipo_Caso IS NULL THEN
      Pv_Mensaje := 'No existe idTipoCaso con el tipoCaso ingresado';
      RAISE Le_Error;
    END IF;
    Lr_InfoCaso.Tipo_Caso_Id := Lr_AdmiTipoCaso.Id_Tipo_Caso;
    
    SPKG_CASOS_CONSULTA.P_GET_ADMI_NIVEL_CRITICIDAD(Pv_NombreNivelCriticidad => Lv_NivelCriticidad,
                                                    Pv_Estado                => 'Activo',
                                                    Pr_AdmiNivelCriticidad   => Lr_AdmiNivelCriticidad,
                                                    Pv_Status                => Lv_Status,
                                                    Pv_Mensaje               => Lv_Mensaje);
  
    IF Lr_AdmiNivelCriticidad.Id_Nivel_Criticidad IS NULL THEN
      Pv_Mensaje := 'No existe idNivelCriticidad con el nivelCriticidad ingresado';
      RAISE Le_Error;
    END IF;
    Lr_InfoCaso.Nivel_Criticidad_Id := Lr_AdmiNivelCriticidad.Id_Nivel_Criticidad;  
            
    WHILE Lr_InfoCaso.Id_Caso IS NULL LOOP    
      DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION.P_GENERAR_CASO(Pr_InfoCaso   => Lr_InfoCaso,
                                                              Pv_TipoCaso   => Lr_AdmiTipoCaso.Nombre_Tipo_Caso,
                                                              Pn_Contador   => Ln_Contador,
                                                              Pv_NumeroCaso => Lv_NumeroCaso,
                                                              Pn_IdCaso     => Lr_InfoCaso.Id_Caso);
      Ln_Contador := Ln_Contador +1;               
    END LOOP;
    
    --Json para crear el historial del caso
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idCaso', Lr_InfoCaso.Id_Caso);
    APEX_JSON.WRITE('observacion', 'Creacion del caso');
    APEX_JSON.WRITE('estado', 'Creado');
    APEX_JSON.WRITE('fechaCreacion', sysdate);
    APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
    APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    
    DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION.P_INSERT_CASO_HISTORIAL(Pcl_Request        => Lcl_Request,
                                                                     Pn_IdCasoHistorial => Lr_InfoCasoHistorial.Id_Caso_Historial,
                                                                     Pv_Status          => Lv_Status,
                                                                     Pv_Mensaje         => Lv_Mensaje);
                            
    IF Lv_Status <> 'OK' THEN
      Pv_Mensaje := 'Error al crear historial: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;                            
    
    APEX_JSON.PARSE(Pcl_Request);
    Ln_CantSintomas := APEX_JSON.get_count('sintomas');
    
    DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   => 'MS_CORE_SOPORTE', 
                                                               Pv_Descripcion       => 'ID_HIPOTESIS_GENERAL',
                                                               Pv_Empresa_Cod       => Nvl(Lr_InfoCaso.Empresa_Cod,10),
                                                               Pr_AdmiParametroDet  => Lr_AdmiParametroDet,
                                                               Pv_Status            => Lv_Status,
                                                               Pv_Mensaje           => Lv_Mensaje);
      Ln_IdHipotesis := Lr_AdmiParametroDet.Valor1; 
   
    FOR i IN 1..Ln_CantSintomas LOOP
    
      --Json para crear el detalle de hipotesis
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('idCaso', Lr_InfoCaso.Id_Caso);
      APEX_JSON.WRITE('idSintoma', APEX_JSON.get_number('sintomas[%d].idSintoma',i));
      APEX_JSON.WRITE('idHipotesis', Ln_IdHipotesis);
      APEX_JSON.WRITE('observacion', 'Creacion del caso');
      APEX_JSON.WRITE('estado', 'Creado');
      APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
      APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
    
      DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION.P_INSERT_DETALLE_HIPOTESIS(Pcl_Request           => Lcl_Request,
                                                                          Pn_IdDetalleHipotesis => Ln_IdDetalleHipotesis,
                                                                          Pv_Status             => Lv_Status,
                                                                          Pv_Mensaje            => Lv_Mensaje);
      
      IF Lv_Status <> 'OK' THEN
        Pv_Mensaje := 'Error al crear detalle hipotesis: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;
    
      --Json para crear el detalle
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('pesoPresupuestado', 0);
      APEX_JSON.WRITE('valorPresupuestado', 0);
      APEX_JSON.WRITE('idDetalleHipotesis', Ln_IdDetalleHipotesis);
      APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
      APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
      
      SPKG_DETALLES_TRANSACCION.P_INSERT_DETALLE(Pcl_Request  => Lcl_Request,
                                                 Pn_IdDetalle => Ln_IdDetalle,
                                                 Pv_Status    => Lv_Status,
                                                 Pv_Mensaje   => Lv_Mensaje);
      
      IF Lv_Status <> 'OK' THEN
        Pv_Mensaje := 'Error al crear detalle: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;
      
      IF Lr_AdmiTipoCaso.Nombre_Tipo_Caso = 'Tecnico' THEN
        --Json para crear el criterio afectado por punto
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
        APEX_JSON.WRITE('criterio', 'Clientes');
        APEX_JSON.WRITE('opcion', 'Cliente: '|| Lv_NombreCliente ||' | OPCION: Punto Cliente');
        APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
        APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        
        Ln_IdCriterioAfectado := 1;
                      
        SPKG_DETALLES_TRANSACCION.P_INSERT_CRITERIO_AFECTADO(Pcl_Request           => Lcl_Request,
                                                             Pn_IdCriterioAfectado => Ln_IdCriterioAfectado,
                                                             Pv_Status             => Lv_Status,
                                                             Pv_Mensaje            => Lv_Mensaje);
        
        IF Lv_Status <> 'OK' THEN
          Pv_Mensaje := 'Error al crear criterio afectado por punto: '|| Lv_Mensaje;
          RAISE Le_Error;
        END IF;
        
        APEX_JSON.PARSE(Pcl_Request);
        Ln_CantAfectados := APEX_JSON.get_count('sintomas[%d].afectados',i);
        
        FOR j IN 1..Ln_CantAfectados LOOP
          --Json para crear la parte afectada por punto
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('idCriterioAfectado', Ln_IdCriterioAfectado);
          APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
          APEX_JSON.WRITE('idAfectado', APEX_JSON.get_number('sintomas[%d].afectados[%d].idPunto',i,j));
          APEX_JSON.WRITE('tipoAfectado', 'Cliente');
          APEX_JSON.WRITE('nombreAfectado', APEX_JSON.get_varchar2('sintomas[%d].afectados[%d].login',i,j));
          APEX_JSON.WRITE('descripcionAfectado', Lv_NombreCliente);
          APEX_JSON.WRITE('fechaInicioIncidencia', Lv_FeApertura);
          APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
          APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;
       
          SPKG_DETALLES_TRANSACCION.P_INSERT_PARTE_AFECTADA(Pcl_Request        => Lcl_Request,
                                                            Pn_IdParteAfectada => Ln_IdParteAfectada,
                                                            Pv_Status          => Lv_Status,
                                                            Pv_Mensaje         => Lv_Mensaje);
                                                            
          IF Lv_Status <> 'OK' THEN
            Pv_Mensaje := 'Error al crear parte afectada por punto: '|| Lv_Mensaje;
            RAISE Le_Error;
          END IF;          
          
          APEX_JSON.PARSE(Pcl_Request);
          Ln_CantServicios := APEX_JSON.get_count('sintomas[%d].afectados[%d].servicios',i,j);
          
          FOR k IN 1..Ln_CantServicios LOOP
            Ln_IdCriterioAfectado := Ln_IdCriterioAfectado + 1;
            --Json para crear el criterio afectado por servicio
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
            APEX_JSON.WRITE('criterio', 'Servicio');
            APEX_JSON.WRITE('opcion', 'Servicio: '|| APEX_JSON.get_varchar2('sintomas[%d].afectados[%d].servicios[%d].descripcionProducto',i,j,k) ||' | OPCION: Servicios');
            APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
            APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
            APEX_JSON.FREE_OUTPUT;
                      
            SPKG_DETALLES_TRANSACCION.P_INSERT_CRITERIO_AFECTADO(Pcl_Request           => Lcl_Request,
                                                                 Pn_IdCriterioAfectado => Ln_IdCriterioAfectado,
                                                                 Pv_Status             => Lv_Status,
                                                                 Pv_Mensaje            => Lv_Mensaje);
            
            IF Lv_Status <> 'OK' THEN
              Pv_Mensaje := 'Error al crear criterio afectado por servicio: '|| Lv_Mensaje;
              RAISE Le_Error;
            END IF;
            
            APEX_JSON.PARSE(Pcl_Request);
            --Json para crear la parte afectada por punto
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('idCriterioAfectado', Ln_IdCriterioAfectado);
            APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
            APEX_JSON.WRITE('idAfectado', APEX_JSON.get_number('sintomas[%d].afectados[%d].servicios[%d].idServicio',i,j,k));
            APEX_JSON.WRITE('tipoAfectado', 'Servicio');
            APEX_JSON.WRITE('nombreAfectado', APEX_JSON.get_varchar2('sintomas[%d].afectados[%d].servicios[%d].descripcionProducto',i,j,k));
            APEX_JSON.WRITE('descripcionAfectado', APEX_JSON.get_varchar2('sintomas[%d].afectados[%d].servicios[%d].descripcionProducto',i,j,k));
            APEX_JSON.WRITE('fechaInicioIncidencia', Lv_FeApertura);
              APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
            APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
            APEX_JSON.FREE_OUTPUT;
         
            SPKG_DETALLES_TRANSACCION.P_INSERT_PARTE_AFECTADA(Pcl_Request        => Lcl_Request,
                                                              Pn_IdParteAfectada => Ln_IdParteAfectada,
                                                              Pv_Status          => Lv_Status,
                                                              Pv_Mensaje         => Lv_Mensaje);
                                                              
            IF Lv_Status <> 'OK' THEN
              Pv_Mensaje := 'Error al crear parte afectada por servicio: '|| Lv_Mensaje;
              RAISE Le_Error;
            END IF;          
            APEX_JSON.PARSE(Pcl_Request);
          END LOOP;      
          APEX_JSON.PARSE(Pcl_Request);
        END LOOP;
        
      END IF;                 
    END LOOP;
    
    --Json para consultar la clase documento
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('nombreClaseDocumento', 'Notificacion Interna Correo');
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
    APEX_JSON.WRITE('nombreDocumento','Creacion de Caso '||Lr_InfoCaso.Numero_Caso); 
    APEX_JSON.WRITE('mensaje', 'Apertura Caso '||Lr_InfoCaso.Numero_Caso||' por parte de Extranet');
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('codEmpresa', Lr_InfoCaso.Empresa_Cod);
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
    APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
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
    
     --Json para crear la comunicacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idFormaContacto', Lr_AdmiFormaContacto.Id_Forma_Contacto);
    APEX_JSON.WRITE('idCaso', Lr_InfoCaso.Id_Caso);
    APEX_JSON.WRITE('claseComunicacion', 'Enviado');
    APEX_JSON.WRITE('fechaComunicacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('codEmpresa', Lr_InfoCaso.Empresa_Cod);
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', SUBSTR(Lr_InfoCaso.Usr_Creacion,1,35));
    APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
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
    
    --Json para crear la relacion del documento y la comunicacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDocumento', Ln_IdDocumento);
    APEX_JSON.WRITE('idComunicacion',Ln_IdComunicacion);
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
    APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
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
    
    IF Lv_TipoSoporte IS NOT NULL THEN
      DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   => 'MS_CORE_SOPORTE', 
                                                                  Pv_Descripcion       => 'TS_'||Lv_TipoSoporte,
                                                                  Pv_Empresa_Cod       => Nvl(Lr_InfoCaso.Empresa_Cod,10),
                                                                  Pr_AdmiParametroDet  => Lr_AdmiParametroDet,
                                                                  Pv_Status            => Lv_Status,
                                                                  Pv_Mensaje           => Lv_Mensaje);
      Ln_IdAsignado := Lr_AdmiParametroDet.Valor3;                                                                  
    END IF;
    
    IF Ln_IdAsignado IS NOT NULL THEN
      --Json para asignar al responsable del caso
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('codEmpresa', Lr_InfoCaso.Empresa_Cod);
      APEX_JSON.WRITE('idCaso',Lr_InfoCaso.Id_Caso);
      APEX_JSON.WRITE('idFormaContacto', Lr_AdmiFormaContacto.Id_Forma_Contacto);
      APEX_JSON.WRITE('idDetalleHipotesis', Ln_IdDetalleHipotesis);
      APEX_JSON.WRITE('idAsignado', Ln_IdAsignado);
      APEX_JSON.WRITE('usuario', Lr_InfoCaso.Usr_Creacion);
      APEX_JSON.WRITE('ip' , Lr_InfoCaso.Ip_Creacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
                                                                  
      P_ASIGNAR_RESPONSABLE_CASO(Pcl_Request  => Lcl_Request,
                                 Pv_Status    => Lv_Status,
                                 Pv_Mensaje   => Lv_Mensaje);
                                 
      IF Lv_Status != 'OK' THEN
        Pv_Mensaje := 'No es posible asignar un responsable del caso: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;    
    END IF;
    
    COMMIT;
    
    OPEN Prf_Response FOR
      SELECT ID_CASO AS idCaso, 
        NUMERO_CASO AS numeroCaso
    FROM DB_SOPORTE.INFO_CASO
    WHERE ID_CASO = Lr_InfoCaso.Id_Caso;
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Caso creado correctamente';
    
  EXCEPTION
    WHEN Le_Error THEN
      Pv_Status := 'ERROR';
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error al crear caso: ' || SQLERRM;
      ROLLBACK;
  END P_CREAR_CASO;

  PROCEDURE P_ASIGNAR_RESPONSABLE_CASO(Pcl_Request  IN CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2) AS

    Lv_Status                 VARCHAR2(25);
    Lv_Mensaje                VARCHAR2(3000);
    Ln_IdAsignado             NUMBER;
    Lcl_Request               CLOB;
    Lrf_ClasesDocumento       SYS_REFCURSOR;
    Lrf_Departamento          SYS_REFCURSOR;
    Lrf_Persona               SYS_REFCURSOR;    
    Lr_Departamento           DB_GENERAL.GNKG_TYPES.Ltr_Departamento;
    Lr_ClaseDocumento         SPKG_TYPES.Ltr_ClaseDocumento;
    Lr_InfoPersona            SPKG_TYPES.Ltr_InfoPersona;
    Lr_InfoOficinaGrupo       DB_COMERCIAL.INFO_OFICINA_GRUPO%ROWTYPE;
    Lr_InfoPersonaEmpresaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE;
    Lr_InfoCasoAsignacion     INFO_CASO_ASIGNACION%ROWTYPE;
    Ln_IdDetalle              INFO_DETALLE.ID_DETALLE%TYPE;
    Ln_IdCasoAsignacion       INFO_CASO_ASIGNACION.ID_CASO_ASIGNACION%TYPE;
    Lv_CodEmpresa             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Ln_IdFormaContacto        DB_COMERCIAL.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE;
    Ln_IdComunicacion         DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE;
    Ln_IdDocumento            DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Ln_IdDocComunicacion      DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION.ID_DOCUMENTO_COMUNICACION%TYPE;
    Ln_IdCaso                 INFO_CASO.ID_CASO%TYPE;
    Ln_IdDetalleHipotesis     INFO_DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS%TYPE;
    Ln_Id_Caso_Historial      INFO_CASO_HISTORIAL.ID_CASO_HISTORIAL%TYPE;
    Lv_Usuario                INFO_CASO.USR_CREACION%TYPE;
    Lv_Ip                     INFO_CASO.IP_CREACION%TYPE; 
    Le_Error                  EXCEPTION;
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Ln_IdCaso := APEX_JSON.get_number(p_path => 'idCaso');
    Ln_IdFormaContacto := APEX_JSON.get_number(p_path => 'idFormaContacto');
    Ln_IdDetalleHipotesis := APEX_JSON.get_number(p_path => 'idDetalleHipotesis');
    Ln_IdAsignado := APEX_JSON.get_number(p_path => 'idAsignado');
    Lv_Usuario := APEX_JSON.get_varchar2(p_path => 'usuario');
    Lv_Ip := APEX_JSON.get_varchar2(p_path => 'ip');

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
     
    Lr_InfoCasoAsignacion.Asignado_Id := Lr_Departamento(1).Id_Departamento;
    Lr_InfoCasoAsignacion.Asignado_Nombre := Lr_Departamento(1).Nombre_Departamento;
    Lr_InfoCasoAsignacion.Ref_Asignado_Id := Lr_InfoPersona(1).Id_Persona;
    Lr_InfoCasoAsignacion.Ref_Asignado_Nombre := Lr_InfoPersona(1).Nombres||' '||Lr_InfoPersona(1).Apellidos;
    Lr_InfoCasoAsignacion.Persona_Empresa_Rol_Id := Ln_IdAsignado;
    
    --Json para crear el detalle
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('pesoPresupuestado', 0);
    APEX_JSON.WRITE('valorPresupuestado', 0);
    APEX_JSON.WRITE('idDetalleHipotesis', Ln_IdDetalleHipotesis);
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_Ip);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    
    SPKG_DETALLES_TRANSACCION.P_INSERT_DETALLE(Pcl_Request  => Lcl_Request,
                                               Pn_IdDetalle => Ln_IdDetalle,
                                               Pv_Status    => Lv_Status,
                                               Pv_Mensaje   => Lv_Mensaje);
      
      IF Lv_Status <> 'OK' THEN
        Pv_Mensaje := 'Error al crear detalle: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;
      
    --Json para crear la comunicacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idFormaContacto', Ln_IdFormaContacto);
    APEX_JSON.WRITE('idCaso', Ln_IdCaso);
    APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
    APEX_JSON.WRITE('claseComunicacion', 'Enviado');
    APEX_JSON.WRITE('fechaComunicacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('codEmpresa', Lv_CodEmpresa);
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_Ip);
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
    
    --Json para crear el historial del caso
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idCaso', Ln_IdCaso);
    APEX_JSON.WRITE('observacion', 'Asignacion del caso');
    APEX_JSON.WRITE('estado', 'Asignado');
    APEX_JSON.WRITE('fechaCreacion', SYSDATE + 1/86400);
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_Ip);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    
    DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION.P_INSERT_CASO_HISTORIAL(Pcl_Request        => Lcl_Request,
                                                                     Pn_IdCasoHistorial => Ln_Id_Caso_Historial,
                                                                     Pv_Status          => Lv_Status,
                                                                     Pv_Mensaje         => Lv_Mensaje);
                            
    IF Lv_Status <> 'OK' THEN
      Pv_Mensaje := 'Error al crear historial: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;                            
    
    --Json para crear el caso de asignacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDetalleHipotesis', Ln_IdDetalleHipotesis);
    APEX_JSON.WRITE('idAsignado', Lr_InfoCasoAsignacion.Asignado_Id );
    APEX_JSON.WRITE('nombreAsignado', Lr_InfoCasoAsignacion.Asignado_Nombre);
    APEX_JSON.WRITE('refIdAsignado', Lr_InfoCasoAsignacion.Ref_Asignado_Id);
    APEX_JSON.WRITE('refNombreAsignado', Lr_InfoCasoAsignacion.Ref_Asignado_Nombre);
    APEX_JSON.WRITE('idPersonaEmpresaRol', Lr_InfoCasoAsignacion.Persona_Empresa_Rol_Id);
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_Ip);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION.P_INSERT_CASO_ASIGNACION(Pcl_Request         => Lcl_Request,
                                                                      Pn_IdCasoAsignacion => Ln_IdCasoAsignacion,
                                                                      Pv_Status           => Lv_Status,
                                                                      Pv_Mensaje          => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible crear el caso asignacion: '|| Lv_Mensaje;
      RAISE Le_Error;
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
    APEX_JSON.WRITE('nombreDocumento','Autoasignacion del Caso'); 
    APEX_JSON.WRITE('mensaje', 'Autoasignacion del Caso');
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
   
    Pv_Status := 'OK';
    Pv_Mensaje := 'Asignacion de Caso exitosa';

  EXCEPTION 
    WHEN Le_Error THEN
      Pv_Status := 'ERROR';
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;    
  END;
  
  PROCEDURE P_ADJUNTAR_DOCUMENTOS_CASO(Pcl_Request  IN CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Prf_Response OUT SYS_REFCURSOR) AS
  
    Ln_CantDocumentos NUMBER;
    Lcl_Request       CLOB;
    Lv_Status         VARCHAR2(25);
    Lv_Mensaje        VARCHAR2(3000);
    Le_Error          EXCEPTION;
    Lv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Lv_Usuario        INFO_CASO.USR_CREACION%TYPE;
    Lv_Ip             INFO_CASO.IP_CREACION%TYPE;
    Ln_IdCaso         INFO_CASO.ID_CASO%TYPE;
    Ln_IdDocumento    DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Ln_IdDocRelacion  DB_COMUNICACION.INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE;
  BEGIN  
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Ln_IdCaso := APEX_JSON.get_number('idCaso');
    Ln_CantDocumentos := APEX_JSON.get_count('documentos');
    Lv_Usuario := APEX_JSON.get_varchar2('usuario');
    Lv_Ip := APEX_JSON.get_varchar2('ip');
    
    FOR i IN 1..Ln_CantDocumentos LOOP
      --Json para crear el documento
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('nombreDocumento','Adjunto Caso'); 
      APEX_JSON.WRITE('mensaje', 'Documento que se adjunta en la creacion de un Caso');
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
      APEX_JSON.WRITE('idCaso', Ln_IdCaso);
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
        Pv_Mensaje := 'No es posible relacionar el documento con el caso: '|| Lv_Mensaje;
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
        AND Idr.Caso_Id = Ln_IdCaso
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
  END P_ADJUNTAR_DOCUMENTOS_CASO;
  
END SPKG_CASOS_TRANSACCION;

/
