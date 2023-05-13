create or replace package                  DB_COMERCIAL.CMKG_CONSULTA is
  -- Author  : Marlon Plùas <mpluas@telconet.ec>
  -- Created : 15/10/2020
  -- Purpose : Paquete general de consultas del db-repositorio-comercial

  /**
  * Documentación para el procedimiento P_INFORMACION_CLIENTE
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_INFORMACION_CLIENTE(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_INFORMACION_CLIENTE
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_INFORMACION_REPRESENTANTE(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_INFORMACION_CLIENTE
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_INFORMACION_PUNTO(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_INFORMACION_CLIENTE
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_FORMAS_CONTACTO_PERSONA(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_INFORMACION_CLIENTE
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  *
  * @author Nestor Naula <nnaulal@telconet.ec>
  * @version 1.1 31-08-2021 - Se valida la persona empresa rol id la validar PIN
  * @since 1.0
  */
  PROCEDURE P_OBTENER_CARACT_PERSONA(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento F_VALIDAR_ROL_PERSONA
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_VALIDAR_ROL_PERSONA(Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pb_Response  OUT NUMBER);

  /**
  * Documentación para el procedimiento F_VALIDAR_ROL_PERSONA
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_OBTENER_PLANTILLA(Pcl_Request  IN  VARCHAR2,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento F_VALIDAR_ROL_PERSONA
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_PUNTOS_PADRE(Pcl_Request  IN  VARCHAR2,
                           Pv_Status    OUT VARCHAR2,
                           Pv_Mensaje   OUT VARCHAR2,
                           Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento F_VALIDAR_ROL_PERSONA
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_SERVICIOS_CLIENTE_PARAMS(Pcl_Request  IN  VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento F_VALIDAR_ROL_PERSONA
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_FORMA_PAGO_DEBITO(Pcl_Request  IN  VARCHAR2,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento F_VALIDAR_ROL_PERSONA
  *
  * Método encargado de retornar lista de persona por region
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region,
  *   estado              := Estado Default 'Activo',
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa Defaul '10',
  *   identificacion      := Identificación,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ULTIMA_MILLA_POR_PUNTO(Pcl_Request  IN  VARCHAR2,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_OBTENER_SERVICIOS_ADENDUM
  *
  * Método encargado de retornar los servicios y productos
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   numeroAdendum              := número de adendum
  *   contratoId                 := contrato Id
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Allan Suarez <amsuarez@telconet.ec>
  * @version 1.0 02-03-2020
  *
  * @author Carlos Caguana <ccaguana@telconet.ec>
  * Se modifica el envio de las variables observaciones y descuento mensual
  * @version 1.1 09-09-2021
  *
  * @author Néstor Naula <nnaulal@telconet.ec>
  * Se agrega estados parametrizados al obtener los servicios de contrato/adendum
  * @version 1.1 09-09-2021
  *
  * Se remplazo el procedimiento para  consumo de la tentativa de promociones
  * se agrego observacion de la tentativa si aplica promocion en  observacion de comentarios
  * Se agrego en Pcl_ResponseList.OBSERVACION_SERV la la observacion por producto adicionales
  * se agrego la columna DESCRIPCION_PRODUCTO en los cursores  C_GET_SERV_ADENDUM ,  C_GET_SERV_ADENDUM_RS ,  C_GET_SERV_CONTRATO ,  C_GET_SERV_CONTRATO_RS
  * @author Jefferson Carrillo <jacarrillo@telconet.ec>
  * @version 1.2 27-05-2022 
  *
  *
  * Se agrego procedura para la generacion de los datos de ademdun temporal 
  * @author Joel Broncano <jbroncano@telconet.ec>
  * @version 1.2 01-08-2022 
  */
  PROCEDURE P_OBTENER_SERVICIOS_ADENDUM(Pcl_Request  IN  VARCHAR2,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_OBTENER_DESCUENTO_RS
  *
  * Método encargado de retornar el descuento del empleado CRS
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idservicio              := idServicio
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Néstor Naula <nnaulal@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_OBTENER_DESCUENTO_RS(Pcl_Request  IN  VARCHAR2,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);

 /**
  * Documentación para el procedimiento P_VERIFICA_DOCUMENTOS_REQ
  * Método encargado de retornar el descuento del empleado CRS
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  * codEmpresa: codigo empresa
	* prefijoEmpresa: prefijo empresa
	* usrCreacion: login usuario
	* clientIp: ip cliente
	* idFormaPago: id forma de pago
	* idTipoCuenta: id tipo cliente
	* tipoTributario: tipo tributrario
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Jefferson Carrillo <jacarrillo@telconet.ec>
  * @version 1.0 11-15-2021
  */
  PROCEDURE P_VERIFICA_DOCUMENTOS_REQ(Pcl_Request  IN  VARCHAR2,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);



/**
  * Documentación para el procedimiento P_SERVICIO_PERSONA
  *
  * Método encargado de retornar lista servicios por persona
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   estado              := Estado Default 'Activo',
  *   personaId           := Id de persona,
  *   personaEmpresaRolId           := Id de rol persona empresa,
  *   productoId           := Id de producto,
  *   productoNombreTecnico      := Nombre tecnico de producto,
  *   esVentaExterna               := Verificador de venta extena Default 'FALSE',
  *   puntoId               := Id de punto,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Wilson Quinto <wquinto@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_SERVICIO_PERSONA(Pcl_Request  IN  VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);
                                       
/**
  * Documentación para el procedimiento P_CONT_FORMA_PAGO_HISTORIAL
  *
  * Método encargado de retornar lista servicios por persona
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   estado              := Estado Default 'Activo',
  *   contratoId           := Id de contrato,
  *   formaPagoId           := Id de forma de pago,
  *   feDesde      := rango de fecha desde de historial,
  *   feHasta               := rango de fecha hasta de historial
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Wilson Quinto <wquinto@telconet.ec>
  * @version 1.0 04-03-2022
  */
  PROCEDURE P_CONT_FORMA_PAGO_HISTORIAL(Pcl_Request  IN  VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);
                          
   /** 
   * P_INFO_CLIENTE_NOT_MASIVA_DET
   *
   * Procedimiento que obtiene la informacion de los clientes afectados por fallas masivas 
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 10/05/2022
   * 
   * @param Pcl_Request  IN  CLOB
   * @param Pv_Status          OUT VARCHAR2
   * @param Pv_Mensaje         OUT VARCHAR2
   * @param Pcl_Response       OUT CLOB 
   */                                   
  PROCEDURE P_INFO_CLIENTE_NOT_MASIVA_DET(Pcl_Request  IN  CLOB,
                                         Pv_Status          OUT VARCHAR2,
                           			         Pv_Mensaje   	   OUT VARCHAR2,
                                          Pcl_Response       OUT CLOB); 

  /**
  * Documentación para el procedimiento P_FORMA_PAGO
  *
  * Método encargado de retornar lista forma de pago
  *
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  CLOB Retorna cursor de la transacción
  *
  * @author Walther Joao Gaibor <wgaibor@telconet.ec>
  * @version 1.0 04-05-2022
  */ 
  PROCEDURE P_FORMA_PAGO(Pcl_Request  IN  VARCHAR2,
                         Pv_Status    OUT VARCHAR2,
                         Pv_Mensaje   OUT VARCHAR2,
                         Pcl_Response OUT CLOB);
  /**
  * Documentación para el procedimiento P_GET_PUNTOS_SERVICIOS_CLIENTE
  *
  * Método encargado de retornar los puntos y servicios que tiene un cliente
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idPersonaEmpresaRol Id de Persona empresa rol del cliente
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
  * @param Pcl_Response   OUT  CLOB Retorna cursor de la consulta
  *
  * @author David De La Cruz <ddelacruz@telconet.ec>
  * @version 1.0 03-01-2022
  */                                  
  PROCEDURE P_GET_PUNTOS_SERVICIOS_CLIENTE(Pcl_Request  IN  CLOB,
                                           Pv_Status    OUT VARCHAR2,
                                           Pv_Mensaje   OUT VARCHAR2,
                                           Pcl_Response OUT CLOB);                                       

end CMKG_CONSULTA;
/
create or replace package body DB_COMERCIAL.CMKG_CONSULTA is
  PROCEDURE P_INFORMACION_CLIENTE(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_Select_Mot              CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_PersonaEmpresaRolId      NUMBER;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PersonaEmpresaRolId      := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');

    -- VALIDACIONES
    IF Ln_PersonaEmpresaRolId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaEmpresaRolId esta vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT  IP.IDENTIFICACION_CLIENTE identificacion        ,
                      IP.TIPO_IDENTIFICACION    tipo_identificacion   ,
                      IP.ID_PERSONA             persona_id            ,
                      IP.LOGIN                  login                 ,
                      IP.NOMBRES                nombres               ,
                      IP.APELLIDOS              apellidos             ,
                      IP.TIPO_TRIBUTARIO        tipo_tributario       ,
                      IP.RAZON_SOCIAL           razon_social          ,
                      IP.DIRECCION_TRIBUTARIA   direccion             ,
                      AR.NOMBRE_REGION          region                ,
                      APA.NOMBRE_PAIS           pais                  ,
                      APR.NOMBRE_PROVINCIA      provincia             ,
                      AP.NOMBRE_PARROQUIA       parroquia             ,
                      AC.NOMBRE_CANTON          ciudad                ,
                      IP.ORIGEN_INGRESOS        origen_ingresos       ,
                      IP.GENERO                 genero                ,
                      IP.ESTADO_CIVIL           estado_civil          ,
                      ATI.DESCRIPCION_TITULO    titulo                ,
                      IP.NACIONALIDAD           nacionalidad          ,
                      IPU.ID_PUNTO              punto_id              ,
                      AC.Jurisdiccion           ciudad_pagare         ,
                      IER.EMPRESA_COD           empresa_cod           ,
                      IPER.ID_PERSONA_ROL       persona_empresa_rol_id,';
    Lcl_Select_Mot    :='(SELECT COUNT(IDS2.MOTIVO_ID) 
                      FROM 
                           DB_COMERCIAL.INFO_SERVICIO IFO2,
                           DB_COMERCIAL.INFO_PUNTO IFP2,
                           DB_COMERCIAL.INFO_PLAN_DET IPLAN2,
                           DB_COMERCIAL.ADMI_PRODUCTO ADMP2,
                           DB_COMERCIAL.INFO_DETALLE_SOLICITUD  IDS2,
                           DB_GENERAL.ADMI_MOTIVO AM2
                      WHERE IFP2.ID_PUNTO = IFO2.PUNTO_ID 
                          AND IDS2.SERVICIO_ID= IFO2.ID_SERVICIO
                           AND IDS2.MOTIVO_ID=AM2.ID_MOTIVO
                           AND IFO2.ESTADO  IN( ''Activo'',''Factible'')
                           AND IFO2.PLAN_ID = IPLAN2.PLAN_ID
                           AND IPLAN2.PRODUCTO_ID = ADMP2.ID_PRODUCTO
                           AND IFP2.PERSONA_EMPRESA_ROL_ID ='||Ln_PersonaEmpresaRolId||'
                           AND TRIM(IDS2.ESTADO)=''Finalizada''
                           AND ADMP2.NOMBRE_TECNICO = ''INTERNET''
                           AND TRIM(AM2.NOMBRE_MOTIVO) in(''Beneficio 3era Edad / Adulto Mayor'',''3era Edad Resolución 07-2021'') 
                    )AS "CANT_MOTIVO"';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                    DB_COMERCIAL.INFO_EMPRESA_ROL         IER,
                    DB_COMERCIAL.INFO_PERSONA             IP 
                    LEFT JOIN DB_COMERCIAL.ADMI_TITULO ATI ON IP.TITULO_ID = ATI.ID_TITULO,
                    DB_COMERCIAL.INFO_PUNTO               IPU ,
                    DB_GENERAL.ADMI_SECTOR                ASE ,
                    DB_GENERAL.ADMI_PARROQUIA             AP  ,
                    DB_GENERAL.ADMI_CANTON                AC  ,
                    DB_GENERAL.ADMI_PROVINCIA             APR ,
                    DB_GENERAL.ADMI_REGION                AR  ,
                    DB_GENERAL.ADMI_PAIS                  APA';
    Lcl_WhereAndJoin := '
              WHERE IPER.PERSONA_ID            = IP.ID_PERSONA
                AND IPU.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                AND IER.ID_EMPRESA_ROL         = IPER.EMPRESA_ROL_ID
                AND IPU.SECTOR_ID              = ASE.ID_SECTOR
                AND ASE.PARROQUIA_ID           = AP.ID_PARROQUIA
                AND AP.CANTON_ID               = AC.ID_CANTON
                AND AC.PROVINCIA_ID            = APR.ID_PROVINCIA
                AND APR.REGION_ID              = AR.ID_REGION
                AND AR.PAIS_ID                 = APA.ID_PAIS
                AND IPER.ID_PERSONA_ROL        = '||Ln_PersonaEmpresaRolId||'
                AND IPU.ESTADO				         IN (''Activo'',''Pendiente'')';
    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_Select_Mot || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_INFORMACION_CLIENTE;

  PROCEDURE P_INFORMACION_REPRESENTANTE(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_PersonaEmpresaRolId      NUMBER;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PersonaEmpresaRolId      := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');

    -- VALIDACIONES
    IF Ln_PersonaEmpresaRolId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaEmpresaRolId esta vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT  IPR.ID_PERSONA_REPRESENTANTE     persona_representante_id,
                      IPR.PERSONA_EMPRESA_ROL_ID       persona_empresa_rol_id,
                      IPR.REPRESENTANTE_EMPRESA_ROL_ID repre_persona_empresa_rol_id,
                      IP.ID_PERSONA                    repre_persona_id,
                      IP.LOGIN                         logim,
                      IP.NOMBRES                       nombres,
                      IP.IDENTIFICACION_CLIENTE        identificacion,
                      IP.APELLIDOS                     apellidos,
                      IP.TIPO_TRIBUTARIO               tipo_tributario,
                      IP.TIPO_IDENTIFICACION           tipo_identificacion,
                      IP.RAZON_SOCIAL                  razon_social,
                      IP.DIRECCION_TRIBUTARIA          direccion,
                      IP.ORIGEN_INGRESOS               origen_ingresos,
                      IP.GENERO                        genero,
                      IP.ESTADO_CIVIL                  estado_civil,
                      IP.NACIONALIDAD                  nacionalidad,
                      IP.CARGO                         cargo,
                      ATI.DESCRIPCION_TITULO		       titulo';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE IPR,
                    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL   IPER,
                    DB_COMERCIAL.INFO_PERSONA               IP
                    LEFT JOIN DB_COMERCIAL.ADMI_TITULO ATI ON IP.TITULO_ID = ATI.ID_TITULO';
    Lcl_WhereAndJoin := '
              WHERE IPR.REPRESENTANTE_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                AND IPER.PERSONA_ID              = IP.ID_PERSONA
                AND IPR.ESTADO                   = ''Activo''
                AND IP.TIPO_TRIBUTARIO           = ''NAT''
                AND IPR.PERSONA_EMPRESA_ROL_ID   = '||Ln_PersonaEmpresaRolId||'';
    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_INFORMACION_REPRESENTANTE;

  PROCEDURE P_INFORMACION_PUNTO(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_PuntoId                  NUMBER;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PuntoId      := APEX_JSON.get_number(p_path => 'puntoId');

    -- VALIDACIONES
    IF Ln_PuntoId IS NULL THEN
      Pv_Mensaje := 'El parámetro puntoId esta vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT  IPU.ID_PUNTO              punto_id            ,
                      IPU.LOGIN                 login               ,
                      AR.NOMBRE_REGION          region              ,
                      APA.NOMBRE_PAIS           pais                ,
                      APR.NOMBRE_PROVINCIA      provincia           ,
                      AP.NOMBRE_PARROQUIA       parroquia           ,
                      AC.NOMBRE_CANTON          ciudad              ,
                      IPU.DIRECCION             direccion           ,
                      IPU.OBSERVACION           observacion         ,
                      IPU.DESCRIPCION_PUNTO     referencia          ,
                      IPU.LATITUD               latitud             ,
                      IPU.LONGITUD              longitud            ,
                      ASE.NOMBRE_SECTOR         sector              ,
                      ATU.CODIGO_TIPO_UBICACION codigo_tipo_ubicacion,
                      IPU.USR_VENDEDOR          usr_vendedor        ,
                      IPU.ESTADO                estado              ,
                      IPC.ID_PUNTO_CONTACTO     punto_contacto_id   ,
                      IPC.CONTACTO_ID           contacto_id         ,
                      IFO.NOMBRES               contacto_nombres    ,
                      IFO.APELLIDOS             contacto_apellidos';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PUNTO_CONTACTO IPC
                    RIGHT JOIN
                      DB_COMERCIAL.INFO_PUNTO IPU
                      ON
                        IPC.PUNTO_ID   = IPU.ID_PUNTO
                        AND IPC.ESTADO = ''Activo''
                    LEFT JOIN
                      DB_COMERCIAL.INFO_PERSONA IFO
                      ON
                        IPC.CONTACTO_ID = IFO.ID_PERSONA    ,
                        DB_COMERCIAL.ADMI_TIPO_UBICACION ATU,
                        DB_GENERAL.ADMI_SECTOR ASE          ,
                        DB_GENERAL.ADMI_PARROQUIA AP        ,
                        DB_GENERAL.ADMI_CANTON AC           ,
                        DB_GENERAL.ADMI_PROVINCIA APR       ,
                        DB_GENERAL.ADMI_REGION AR           ,
                        DB_GENERAL.ADMI_PAIS APA';
    Lcl_WhereAndJoin := '
              WHERE IPU.TIPO_UBICACION_ID = ATU.ID_TIPO_UBICACION
                    AND IPU.SECTOR_ID     = ASE.ID_SECTOR
                    AND ASE.PARROQUIA_ID  = AP.ID_PARROQUIA
                    AND AP.CANTON_ID      = AC.ID_CANTON
                    AND AC.PROVINCIA_ID   = APR.ID_PROVINCIA
                    AND APR.REGION_ID     = AR.ID_REGION
                    AND AR.PAIS_ID        = APA.ID_PAIS
                    AND IPU.ESTADO IN (''Activo'',''Pendiente'')
                    AND IPU.ID_PUNTO   = '||Ln_PuntoId||'';
    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_INFORMACION_PUNTO;



/* 
    * Se actualiza funcionabilidad envio de correo a representante legal tipo natural
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 01/09/2022
*/
  PROCEDURE P_FORMAS_CONTACTO_PERSONA(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_PersonaId                NUMBER;
    Le_Errors                   EXCEPTION;
  --
   CURSOR C_BUSCAR_PERSONA_JURIDICA(Cn_PersonaId INTEGER) IS
     SELECT 
     IPJ.ID_PERSONA, 
     IPJ.TIPO_IDENTIFICACION,
     IPJ.TIPO_TRIBUTARIO
     FROM    DB_COMERCIAL.INFO_PERSONA IPJ
     WHERE   IPJ.ID_PERSONA = Cn_PersonaId;      
  --
  CURSOR C_PERSONA_REPRESENTANTE_LEGAL (Cn_PersonaId INTEGER) IS
        SELECT         
        REP_IP.ID_PERSONA
        FROM DB_COMERCIAL.INFO_PERSONA CLI_IP 
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL CLI_IPER ON  CLI_IPER.PERSONA_ID  = CLI_IP.ID_PERSONA
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE CLI_IPR ON  CLI_IPR.PERSONA_EMPRESA_ROL_ID  =  CLI_IPER.ID_PERSONA_ROL
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL REP_IPER ON  REP_IPER.ID_PERSONA_ROL =  CLI_IPR.REPRESENTANTE_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA   REP_IP ON REP_IP.ID_PERSONA = REP_IPER.PERSONA_ID 
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL CLI_IER ON  CLI_IER.ID_EMPRESA_ROL  = CLI_IPER.EMPRESA_ROL_ID 
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL REP_IER ON  REP_IER.ID_EMPRESA_ROL  = REP_IPER.EMPRESA_ROL_ID 
        INNER JOIN DB_COMERCIAL.ADMI_ROL  CLI_AROL ON  CLI_AROL.ID_ROL = CLI_IER.ROL_ID
        INNER JOIN DB_COMERCIAL.ADMI_ROL  REP_AROL ON  REP_AROL .ID_ROL = REP_IER.ROL_ID
        WHERE CLI_IPR.ESTADO  IN  ('Pendiente','Cancelado', 'Activo')            
        AND   CLI_AROL.DESCRIPCION_ROL IN ('Cliente', 'Pre-cliente')
        AND   REP_AROL.DESCRIPCION_ROL IN ('Representante Legal Juridico')
        AND   REP_IP.TIPO_TRIBUTARIO   = 'NAT'
        AND   CLI_IP.ID_PERSONA        = Cn_PersonaId  ;

  --
    Ln_IdPersona                NUMBER;
    Lv_TipoIdentificacion       VARCHAR2(50);
    Lv_TipoTributario           VARCHAR2(50);
    Ln_IdPersonaRepresentNatul  NUMBER;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PersonaId      := APEX_JSON.get_number(p_path => 'personaId');

    -- VALIDACIONES
    IF Ln_PersonaId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaId esta vacío';
      RAISE Le_Errors;
    END IF;

    -- BUSCO SI ES PERSONA JURIDICA
    FOR LC_BUSCAR_PERSONA_JURIDICA IN C_BUSCAR_PERSONA_JURIDICA(Ln_PersonaId)
    LOOP
      Ln_IdPersona          := LC_BUSCAR_PERSONA_JURIDICA.ID_PERSONA;
      Lv_TipoIdentificacion := LC_BUSCAR_PERSONA_JURIDICA.TIPO_IDENTIFICACION;
      Lv_TipoTributario     := LC_BUSCAR_PERSONA_JURIDICA.TIPO_TRIBUTARIO;
    END LOOP;

    -- CONSULTAR SI ES PERSONA JURIDICA CON TIPO IDENTIFICACIÓN RUC Y TIPO TRIBUTARIO JUR
    IF Ln_IdPersona IS NOT NULL AND  Lv_TipoIdentificacion = 'RUC' AND Lv_TipoTributario = 'JUR' THEN

       OPEN  C_PERSONA_REPRESENTANTE_LEGAL(Ln_IdPersona); 
       FETCH C_PERSONA_REPRESENTANTE_LEGAL INTO  Ln_IdPersonaRepresentNatul;  
       CLOSE C_PERSONA_REPRESENTANTE_LEGAL; 

        IF  Ln_IdPersonaRepresentNatul IS NOT NULL THEN
            Ln_PersonaId:=  Ln_IdPersonaRepresentNatul;             
            ELSE
            Pv_Mensaje := 'No existe representante legal tipo natural.';
            RAISE Le_Errors;
        END IF;

    END IF;



    Lcl_Select       := '
              SELECT  AFC.DESCRIPCION_FORMA_CONTACTO descripcion,
                      AFC.CODIGO                     codigo     ,
                      IPFC.VALOR                     valor';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC,
                    DB_COMERCIAL.ADMI_FORMA_CONTACTO         AFC';
    Lcl_WhereAndJoin := '
              WHERE IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
                    AND IPFC.ESTADO        = ''Activo''
                    AND AFC.ESTADO         = ''Activo''
                    AND IPFC.PERSONA_ID    = '||Ln_PersonaId||'';
    Lcl_OrderAnGroup := '
              ORDER BY
                IPFC.ID_PERSONA_FORMA_CONTACTO DESC';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_FORMAS_CONTACTO_PERSONA;

  PROCEDURE P_OBTENER_CARACT_PERSONA(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_CaracteristicaId         NUMBER;
    Lv_DescripCaracteristica    VARCHAR2(1000);
    Lv_ValorCaractPersona       VARCHAR2(1000);
    Ln_PersonaEmpresaRolId      NUMBER;
    Lv_Estado                   VARCHAR2(100);
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_CaracteristicaId      := APEX_JSON.get_number(p_path => 'caracteristicaId');
    Lv_DescripCaracteristica := APEX_JSON.get_varchar2(p_path => 'descripcionCaracteristica');
    Lv_ValorCaractPersona    := APEX_JSON.get_varchar2(p_path => 'valorCaractPersona');
    Ln_PersonaEmpresaRolId   := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');
    Lv_Estado                := APEX_JSON.get_varchar2(p_path => 'estado');

    -- VALIDACIONES
    IF Ln_CaracteristicaId IS NULL AND Lv_DescripCaracteristica IS NULL THEN
      Pv_Mensaje := 'El parámetro caracteristicaId o descripcionCaracteristica está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;

    Lcl_Select       := '
              SELECT  IPERC.*';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
                    DB_COMERCIAL.ADMI_CARACTERISTICA            AC';
    Lcl_WhereAndJoin := '
              WHERE IPERC.CARACTERISTICA_ID           = AC.ID_CARACTERISTICA
                    AND AC.ESTADO                     = ''Activo''
                    AND IPERC.ESTADO                  = '''||Lv_Estado||'''';
    IF Ln_CaracteristicaId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AC.ID_CARACTERISTICA = '||Ln_CaracteristicaId;
    END IF;
    IF Lv_DescripCaracteristica IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_DescripCaracteristica||'''';
    END IF;

    IF Lv_ValorCaractPersona IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IPERC.VALOR = '''||Lv_ValorCaractPersona||'''';
    END IF;

    IF Lv_ValorCaractPersona IS NULL AND Ln_PersonaEmpresaRolId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IPERC.PERSONA_EMPRESA_ROL_ID = '||Ln_PersonaEmpresaRolId||'';
    END IF;

    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_OBTENER_CARACT_PERSONA;

  PROCEDURE P_VALIDAR_ROL_PERSONA(Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pb_Response  OUT NUMBER)
  AS

    CURSOR C_EXISTE_DESC_TIPO_ROL_PERSONA(Cn_PersonaEmpresaRolId NUMBER,
                                          Cv_DesTipoRol          VARCHAR2) IS
    SELECT COUNT(IPER.ID_PERSONA_ROL)
    FROM
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_EMPRESA_ROL         IER ,
      DB_GENERAL.ADMI_ROL                   AR  ,
      DB_GENERAL.ADMI_TIPO_ROL              ATR
    WHERE
      IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID      = AR.ID_ROL
      AND AR.TIPO_ROL_ID  = ATR.ID_TIPO_ROL
      AND ATR.ESTADO      = 'Activo'
      AND ATR.DESCRIPCION_TIPO_ROL = Cv_DesTipoRol
      AND IPER.ID_PERSONA_ROL = Cn_PersonaEmpresaRolId;

    Lb_DatoEncontrado           NUMBER := 0;
    Ln_PersonaEmpresaRolId      NUMBER;
    Ln_CountTipoRoles           NUMBER;
    Ln_ExisteDescTipoRol        NUMBER;
    Ln_IteradorI                NUMBER;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PersonaEmpresaRolId   := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');

    -- VALIDACIONES
    IF Ln_PersonaEmpresaRolId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaEmpresaRolId está vacío';
      RAISE Le_Errors;
    END IF;

    Ln_CountTipoRoles := APEX_JSON.get_count(p_path => 'listDescTipoRoles');

    Ln_IteradorI := 1;
    WHILE (Ln_IteradorI <= Ln_CountTipoRoles AND Lb_DatoEncontrado = 0)
    LOOP
      IF C_EXISTE_DESC_TIPO_ROL_PERSONA%ISOPEN THEN
        CLOSE C_EXISTE_DESC_TIPO_ROL_PERSONA;
      END IF;

      OPEN C_EXISTE_DESC_TIPO_ROL_PERSONA(Ln_PersonaEmpresaRolId, APEX_JSON.get_varchar2(p_path => 'listDescTipoRoles[%d]', p0 => Ln_IteradorI));
        FETCH C_EXISTE_DESC_TIPO_ROL_PERSONA INTO Ln_ExisteDescTipoRol;
      CLOSE C_EXISTE_DESC_TIPO_ROL_PERSONA;

      IF Ln_ExisteDescTipoRol > 0 THEN
        Lb_DatoEncontrado := 1;
      END IF;
      Ln_IteradorI := Ln_IteradorI +1;      
    END LOOP;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
    Pb_Response   := Lb_DatoEncontrado;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_VALIDAR_ROL_PERSONA;

  PROCEDURE P_OBTENER_PLANTILLA(Pcl_Request  IN  VARCHAR2,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Lv_CodigoPlantilla          VARCHAR2(1000);
    Lv_Estado                   VARCHAR2(100);
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodigoPlantilla := APEX_JSON.get_varchar2(p_path => 'codigoPlantilla');
    Lv_Estado          := APEX_JSON.get_varchar2(p_path => 'estado');

    -- VALIDACIONES
    IF Lv_CodigoPlantilla IS NULL THEN
      Pv_Mensaje := 'El parámetro codigoPlantilla está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;

    Lcl_Select       := '
              SELECT  AEP.ID_EMPRESA_PLANTILLA,
                      AEP.DESCRIPCION         ,
                      AEP.HTML                ,
                      AEP.PROPIEDADES';
    Lcl_From         := '
              FROM  DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA AEP';
    Lcl_WhereAndJoin := '
              WHERE AEP.COD_PLANTILLA = '''||Lv_CodigoPlantilla||'''
                    AND AEP.ESTADO    = '''||Lv_Estado||'''';
    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_OBTENER_PLANTILLA;

  PROCEDURE P_PUNTOS_PADRE(Pcl_Request  IN  VARCHAR2,
                           Pv_Status    OUT VARCHAR2,
                           Pv_Mensaje   OUT VARCHAR2,
                           Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_PersonaEmpresaRolId      NUMBER;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PersonaEmpresaRolId      := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');

    -- VALIDACIONES
    IF Ln_PersonaEmpresaRolId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaEmpresaRolId esta vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT  IP.*';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PUNTO                IP,
                    DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA';
    Lcl_WhereAndJoin := '
              WHERE IP.ID_PUNTO                   = IPDA.PUNTO_ID
                    AND IP.PERSONA_EMPRESA_ROL_ID = '||Ln_PersonaEmpresaRolId||'
                    AND IPDA.ES_PADRE_FACTURACION = ''S''';
    Lcl_OrderAnGroup := '
              ORDER BY IP.ID_PUNTO ASC';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_PUNTOS_PADRE;

  PROCEDURE P_SERVICIOS_CLIENTE_PARAMS(Pcl_Request  IN  VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Lv_Estado                   VARCHAR2(100);
    Ln_PersonaEmpresaRolId      NUMBER;
    Ln_puntoId                  NUMBER;
    Lb_EsVentaExterna           BOOLEAN;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado                := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_PersonaEmpresaRolId   := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');
    Lb_EsVentaExterna        := APEX_JSON.get_boolean(p_path => 'esVentaExterna');
    Ln_puntoId               := APEX_JSON.get_number(p_path => 'puntoId');

    -- VALIDACIONES
    IF Ln_PersonaEmpresaRolId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaEmpresaRolId esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Ln_puntoId IS NULL THEN
      Pv_Mensaje := 'El parámetro puntoId esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Lb_EsVentaExterna IS NULL THEN
      Lb_EsVentaExterna := FALSE;
    END IF;

    Lcl_Select       := '
              SELECT  ISE.ID_SERVICIO         ,
                      ISE.PUNTO_ID            ,
                      IP.LOGIN                ,
                      ISE.PRODUCTO_ID         ,
                      ISE.PLAN_ID             ,
                      ISE.ORDEN_TRABAJO_ID    ,
                      ISE.ES_VENTA            ,
                      ISE.CANTIDAD            ,
                      ISE.PRECIO_VENTA        ,
                      ISE.PUNTO_FACTURACION_ID,
                      ISE.ELEMENTO_ID         ,
                      ISE.ULTIMA_MILLA_ID     ,
                      ISE.TIPO_ORDEN          ,
                      ISE.OBSERVACION         ,
                      ISE.USR_VENDEDOR';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                    DB_COMERCIAL.INFO_PUNTO               IP  ,
                    DB_COMERCIAL.INFO_SERVICIO            ISE';
    Lcl_WhereAndJoin := '
              WHERE IPER.ID_PERSONA_ROL     = IP.PERSONA_EMPRESA_ROL_ID
                    AND IP.ID_PUNTO         = ISE.PUNTO_ID
                    AND IP.ID_PUNTO         = '''||Ln_puntoId||'''
                    AND ISE.ESTADO          = '''||Lv_Estado||'''
                    AND IPER.ID_PERSONA_ROL = '||Ln_PersonaEmpresaRolId||'';
    Lcl_OrderAnGroup := '
              ORDER BY ISE.FE_CREACION ASC';

    IF NOT Lb_EsVentaExterna THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND (ISE.ES_VENTA <> ''E'' OR ISE.ES_VENTA IS NULL)';
    END IF;

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_SERVICIOS_CLIENTE_PARAMS;

  PROCEDURE P_FORMA_PAGO_DEBITO(Pcl_Request  IN  VARCHAR2,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_ContratoId               NUMBER;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ContratoId   := APEX_JSON.get_number(p_path => 'contratoId');

    -- VALIDACIONES
    IF Ln_ContratoId IS NULL THEN
      Pv_Mensaje := 'El parámetro contratoId esta vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT  IC.ID_CONTRATO                           ,
                      IC.FORMA_PAGO_ID                         ,
                      ATC.DESCRIPCION_CUENTA  tipo_cuenta      ,
                      icfp.NUMERO_CTA_TARJETA numero_cuenta    ,
                      icfp.TITULAR_CUENTA     titular          ,
                      AB.DESCRIPCION_BANCO    banco            ,
                      ATC2.DESCRIPCION_CUENTA banco_tipo_cuenta,
                      ICFP.MES_VENCIMIENTO    mes_vencimiento  ,
                      ICFP.ANIO_VENCIMIENTO   anio_vencimiento';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_CONTRATO            IC ,
                    DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP
                    LEFT JOIN
                      DB_GENERAL.ADMI_TIPO_CUENTA ATC
                      ON
                        ICFP.TIPO_CUENTA_ID = ATC.ID_TIPO_CUENTA
                    LEFT JOIN
                      DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC
                      ON
                        ICFP.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA,
                        DB_GENERAL.ADMI_BANCO AB                             ,
                        DB_GENERAL.ADMI_TIPO_CUENTA ATC2';
    Lcl_WhereAndJoin := '
              WHERE IC.ID_CONTRATO          = ICFP.CONTRATO_ID
                    AND ABTC.BANCO_ID       = AB.ID_BANCO
                    AND ABTC.TIPO_CUENTA_ID = ATC2.ID_TIPO_CUENTA
                    AND ICFP.ESTADO         = ''Activo''
                    AND ic.ID_CONTRATO = '||Ln_ContratoId||'';
    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_FORMA_PAGO_DEBITO;

  PROCEDURE P_ULTIMA_MILLA_POR_PUNTO(Pcl_Request  IN  VARCHAR2,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS
    Ln_puntoId                  NUMBER;
    Le_Errors                   EXCEPTION;
    Lv_estado                   VARCHAR2(20);
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    --Ln_ServicioId   := APEX_JSON.get_number(p_path => 'servicioId');
    Ln_puntoId     := APEX_JSON.get_number(p_path => 'puntoId');
    Lv_estado      := APEX_JSON.get_varchar2(p_path => 'estado');

    -- VALIDACIONES    
    IF Ln_puntoId IS NULL THEN
      Pv_Mensaje := 'El parámetro puntoId esta vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_estado IS NULL THEN
      Pv_Mensaje := 'El parámetro estado esta vacío';
      RAISE Le_Errors;
    END IF;

    OPEN Pcl_Response FOR 
    SELECT  ATM.ID_TIPO_MEDIO,
            ATM.CODIGO_TIPO_MEDIO
      FROM  DB_COMERCIAL.INFO_SERVICIO ISE,
            DB_COMERCIAL.INFO_SERVICIO_TECNICO IST,
            DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM
     WHERE ISE.ID_SERVICIO         = IST.SERVICIO_ID
       AND IST.ULTIMA_MILLA_ID = ATM.ID_TIPO_MEDIO
       AND ATM.ESTADO          = 'Activo'
       AND ISE.ESTADO          =  Lv_estado
       AND IST.ULTIMA_MILLA_ID IS NOT NULL
       AND ISE.PUNTO_ID        = Ln_puntoId;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_ULTIMA_MILLA_POR_PUNTO;

 PROCEDURE P_OBTENER_SERVICIOS_ADENDUM(Pcl_Request  IN  VARCHAR2,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
    IS
        CURSOR C_GET_SERV_ADENDUM(Cv_numeroAdendum VARCHAR2, Cv_Tipo VARCHAR2)
        IS
            SELECT DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO, APRO.FRECUENCIA,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION,ISE.CANTIDAD ,APRO.DESCRIPCION_PRODUCTO
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.NUMERO = Cv_numeroAdendum AND
            --IAD.FE_CREACION = (select  MAX(A.FE_CREACION) FROM DB_COMERCIAL.INFO_ADENDUM A where A.NUMERO=IAD.NUMERO GROUP BY A.NUMERO) AND
            ISE.ESTADO NOT IN ('Cancelado','Anulado','Inactivo','Eliminado','Cancel','Rechazada','Eliminado-Migra') AND
            IAD.TIPO = Cv_Tipo
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;

        CURSOR C_GET_SERV_ADENDUM_RS(Cv_numeroAdendum VARCHAR2, Cv_Tipo VARCHAR2, Cn_PuntoId NUMBER)
        IS
            SELECT  DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO, APRO.FRECUENCIA,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION,ISE.CANTIDAD ,APRO.DESCRIPCION_PRODUCTO
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.NUMERO = Cv_numeroAdendum AND
            IAD.PUNTO_ID = Cn_PuntoId AND
            ISE.ESTADO IN ( SELECT 
                            SUBSTR(T2.VALOR,INSTR(T2.VALOR,'|')+1) AS ESTADOS
                              FROM 
                              (
                                SELECT REGEXP_SUBSTR(
                                      T1.VALOR
                                ,'[^,]+', 1, LEVEL) AS VALOR 
                                FROM (
                                SELECT APD.VALOR1 AS VALOR
                                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE PARAMETRO_ID = (
                                            SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                                            WHERE NOMBRE_PARAMETRO='ESTADOS_PRODUCTOS_ADICIONALES_CONTRATOS_WEB'
                                          ) 
                                        AND APD.DESCRIPCION = 'ESTADOS REQUERIDO PARA PRODUCTOS ADICIONALES DE CONTRATO WEB' 
                                        AND APD.ESTADO='Activo') T1
                                CONNECT BY REGEXP_SUBSTR(T1.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL
                              )T2) AND
            IAD.TIPO = Cv_Tipo
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;

        CURSOR C_GET_SERV_CONTRATO(Cn_ContratoId INTEGER, Cv_Tipo VARCHAR2)            
        IS
            SELECT DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO, APRO.FRECUENCIA,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION,ISE.CANTIDAD ,APRO.DESCRIPCION_PRODUCTO
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.CONTRATO_ID = Cn_ContratoId AND
            ISE.ESTADO IN ( SELECT 
                            SUBSTR(T2.VALOR,INSTR(T2.VALOR,'|')+1) AS ESTADOS
                              FROM 
                              (
                                SELECT REGEXP_SUBSTR(
                                      T1.VALOR
                                ,'[^,]+', 1, LEVEL) AS VALOR 
                                FROM (
                                SELECT APD.VALOR1 AS VALOR
                                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE PARAMETRO_ID = (
                                            SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                                            WHERE NOMBRE_PARAMETRO='ESTADOS_PRODUCTOS_ADICIONALES_CONTRATOS_WEB'
                                          ) 
                                        AND APD.DESCRIPCION = 'ESTADOS REQUERIDO PARA PRODUCTOS ADICIONALES DE CONTRATO WEB' 
                                        AND APD.ESTADO='Activo') T1
                                CONNECT BY REGEXP_SUBSTR(T1.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL
                              )T2) AND
            IAD.TIPO = Cv_Tipo
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;

        CURSOR C_GET_SERV_CONTRATO_RS(Cn_ContratoId INTEGER, Cv_Tipo VARCHAR2)            
        IS
            SELECT DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO)AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO, APRO.FRECUENCIA,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION,ISE.CANTIDAD ,APRO.DESCRIPCION_PRODUCTO
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.CONTRATO_ID = Cn_ContratoId AND
            ISE.ESTADO IN ( SELECT 
                            SUBSTR(T2.VALOR,INSTR(T2.VALOR,'|')+1) AS ESTADOS
                              FROM 
                              (
                                SELECT REGEXP_SUBSTR(
                                      T1.VALOR
                                ,'[^,]+', 1, LEVEL) AS VALOR 
                                FROM (
                                SELECT APD.VALOR1 AS VALOR
                                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE PARAMETRO_ID = (
                                            SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                                            WHERE NOMBRE_PARAMETRO='ESTADOS_PRODUCTOS_ADICIONALES_CONTRATOS_WEB'
                                          ) 
                                        AND APD.DESCRIPCION = 'ESTADOS REQUERIDO PARA PRODUCTOS ADICIONALES DE CONTRATO WEB' 
                                        AND APD.ESTADO='Activo') T1
                                CONNECT BY REGEXP_SUBSTR(T1.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL
                              )T2) AND
            IAD.TIPO = Cv_Tipo
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;               

        CURSOR C_GET_PARAMETROS_EMPR(Cv_NombreParametro VARCHAR2,
                                     Cv_ModuloParametro VARCHAR2,
                                     Cn_CodEmpresa      INTEGER)
        IS
          SELECT APD.VALOR1,APD.VALOR2,
                  APD.VALOR3,APD.VALOR4,APD.VALOR5,APD.VALOR7
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.PARAMETRO_ID =
            (SELECT APC.ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
            AND  APC.MODULO = Cv_ModuloParametro
            ) AND APD.EMPRESA_COD = Cn_CodEmpresa;

        CURSOR C_GET_PARAMETROS_EMPR_DESC(Cv_NombreParametro      VARCHAR2,
                                          Cv_ModuloParametro      VARCHAR2,
                                          Cv_DescripcionParametro VARCHAR2,
                                          Cn_CodEmpresa           INTEGER)
        IS
          SELECT APD.VALOR2,APD.VALOR3
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.PARAMETRO_ID =
            (SELECT APC.ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
            AND  APC.MODULO = Cv_ModuloParametro
            ) AND APD.EMPRESA_COD = Cn_CodEmpresa 
            AND APD.VALOR1 = Cv_DescripcionParametro;

        CURSOR C_GET_PARAMETROS_EMPR_DESC1(Cv_NombreParametro      VARCHAR2,
                                          Cv_ModuloParametro      VARCHAR2,
                                          Cv_DescripcionParametro VARCHAR2,
                                          Cn_CodEmpresa           INTEGER)
        IS
          SELECT APD.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.PARAMETRO_ID =
            (SELECT APC.ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
            AND  APC.MODULO = Cv_ModuloParametro
            ) AND APD.EMPRESA_COD = Cn_CodEmpresa 
            AND APD.DESCRIPCION = Cv_DescripcionParametro;

        CURSOR C_GET_PARAM_EMPR_EMPL_DESC(Cv_NombreParametro      VARCHAR2,
                                          Cv_ModuloParametro      VARCHAR2,
                                          Cv_DescripcionParametro VARCHAR2,
                                          Cv_Porcentaje           VARCHAR2,
                                          Cn_CodEmpresa           INTEGER)
        IS
          SELECT APD.DESCRIPCION
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.PARAMETRO_ID =
            (SELECT APC.ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
            AND  APC.MODULO = Cv_ModuloParametro
            ) AND APD.EMPRESA_COD = Cn_CodEmpresa 
            AND APD.DESCRIPCION like Cv_Porcentaje
            AND APD.DESCRIPCION = Cv_DescripcionParametro;

        CURSOR C_GET_CARACTERISTICA(Cv_DescripcionCaract VARCHAR2, Cn_CodEmpresa           INTEGER)
        IS
            SELECT ACA.ID_CARACTERISTICA
            FROM DB_COMERCIAL.ADMI_CARACTERISTICA ACA
            WHERE
            ACA.ID_CARACTERISTICA=(select adet.VALOR1 from  DB_GENERAL.admi_parametro_det adet where adet.DESCRIPCION=Cv_DescripcionCaract AND adet.EMPRESA_COD=Cn_CodEmpresa) ; 

        CURSOR C_GET_DET_PLAN(Cn_IdPlan VARCHAR2,Cv_NombreParametro VARCHAR2,Cn_CodEmpresa           INTEGER)
        IS
            SELECT IPD.PRODUCTO_ID,IPD.ID_ITEM,IPD.PRECIO_ITEM
            FROM DB_COMERCIAL.INFO_PLAN_DET IPD
            WHERE
            IPD.PLAN_ID = Cn_IdPlan 
            AND IPD.ESTADO IN (
                SELECT APD.VALOR1
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                  WHERE APD.PARAMETRO_ID =
                    (SELECT APC.ID_PARAMETRO
                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                    WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                    ) AND APD.ESTADO = 'Activo'
                    AND APD.EMPRESA_COD = Cn_CodEmpresa 
            ); 

        CURSOR C_GET_PRODUCTO(Cn_IdProducto INTEGER)
        IS
            SELECT APO.NOMBRE_TECNICO, APO.FRECUENCIA, APO.CODIGO_PRODUCTO
            FROM DB_COMERCIAL.ADMI_PRODUCTO APO
            WHERE
            APO.ID_PRODUCTO = Cn_IdProducto;

        CURSOR C_GET_SERV_PRODUCTO(Cn_IdServicio INTEGER)
        IS
            SELECT ISPC.PRODUCTO_CARACTERISITICA_ID,ISPC.VALOR,AC.DESCRIPCION_CARACTERISTICA
            FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
            WHERE
            ISPC.SERVICIO_ID = Cn_IdServicio ;

        CURSOR C_GET_PRODUCTO_CARACT(Cn_IdCaracteristica INTEGER,Cn_planDet INTEGER)
        IS
            SELECT APC.VALOR
            FROM DB_COMERCIAL.INFO_PLAN_CARACTERISTICA APC
            WHERE  APC.CARACTERISTICA_ID = Cn_IdCaracteristica
            AND APC.PLAN_ID = Cn_planDet;

        CURSOR C_OBTENER_IMPUESTO(Cn_IdProducto INTEGER)
        IS
            SELECT API.PORCENTAJE_IMPUESTO
            FROM DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO API
            INNER JOIN DB_COMERCIAL.ADMI_IMPUESTO AIM ON AIM.ID_IMPUESTO = API.IMPUESTO_ID
            WHERE
            API.PRODUCTO_ID = Cn_IdProducto;

        CURSOR C_OBTENER_ULTIMA_MILLA(Cn_IdServicio INTEGER)
        IS
            SELECT ATM.CODIGO_TIPO_MEDIO
            FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
            INNER JOIN DB_COMERCIAL.ADMI_TIPO_MEDIO ATM ON IST.ULTIMA_MILLA_ID = ATM.ID_TIPO_MEDIO
            WHERE
            IST.SERVICIO_ID = Cn_IdServicio ;

        CURSOR C_CARAT_CICLO_FACTURACION(Cn_IdPunto     VARCHAR2)
        IS
        SELECT CI.NOMBRE_CICLO
            FROM
            DB_COMERCIAL.INFO_PUNTO IPU,
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
            DB_COMERCIAL.ADMI_CARACTERISTICA CA,
            DB_COMERCIAL.ADMI_CICLO CI
            WHERE 
            IPU.ID_PUNTO                                                 = Cn_IdPunto
            AND IPER.ID_PERSONA_ROL                                      = IPU.PERSONA_EMPRESA_ROL_ID
            AND IPERC.PERSONA_EMPRESA_ROL_ID                             = IPER.ID_PERSONA_ROL
            AND IPERC.CARACTERISTICA_ID                                  = CA.ID_CARACTERISTICA
            AND CA.DESCRIPCION_CARACTERISTICA                            = 'CICLO_FACTURACION'
            AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0) = CI.ID_CICLO
            AND IPERC.ESTADO                                             = 'Activo'
            AND ROWNUM                                                   = 1;

        CURSOR C_OBTENER_PROMO_INSTALACION_RS(Cn_IdServicio INTEGER)
        IS
            SELECT 
                SUBSTR(T2.VALOR,INSTR(T2.VALOR,'|')+1) AS PORCENTAJE
            FROM 
              (SELECT 
                    REGEXP_SUBSTR(T1.VALOR,'[^,]+', 1, LEVEL) AS VALOR
                FROM(
                    SELECT 
                        ATPR.VALOR
                    FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
                        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                    WHERE IDMS.SERVICIO_ID = Cn_IdServicio
                        AND IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID
                        AND IDMP.TIPO_PROMOCION = 'PROM_INS'
                        AND ATPR.TIPO_PROMOCION_id = IDMP.TIPO_PROMOCION_ID
                        AND ATPR.ESTADO != 'Eliminado'
                        AND DBAC.ID_CARACTERISTICA = ATPR.CARACTERISTICA_ID
                        AND DBAC.DESCRIPCION_CARACTERISTICA = 'PROM_PERIODO'
                        AND MONTHS_BETWEEN(SYSDATE,IDMS.FE_CREACION) <= 36) T1
                WHERE ROWNUM = 1
                CONNECT BY REGEXP_SUBSTR(T1.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T2;



       CURSOR C_OBT_PRO_INST_PERIODO(Cn_IdServicio INTEGER)
        IS
	     SELECT 
	      (SELECT COUNT(T1.VALOR) AS  CANTIDAD_PERIODOS
	              FROM
	                (SELECT REGEXP_SUBSTR(T.VALOR,'[^,]+', 1, LEVEL) AS VALOR
	                FROM
	                  (SELECT ATPR.VALOR
	                  FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
	                    DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
	                    DB_COMERCIAL.ADMI_CARACTERISTICA AC,
	                    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
	                        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
	                  WHERE 
	                  AC.DESCRIPCION_CARACTERISTICA = 'PROM_PERIODO'
	                  AND IDMS.SERVICIO_ID = Cn_IdServicio
	                  AND AC.ID_CARACTERISTICA            = ATPR.CARACTERISTICA_ID
	                  AND ATPR.ESTADO                    != 'Eliminado'
	                  AND ATPR.TIPO_PROMOCION_ID          = ATP.ID_TIPO_PROMOCION
	                  AND ATP.ID_TIPO_PROMOCION           = IDMP.TIPO_PROMOCION_ID 
	                  AND IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID
	                  AND IDMP.TIPO_PROMOCION = 'PROM_INS'
	                  AND ATPR.TIPO_PROMOCION_id = IDMP.TIPO_PROMOCION_ID

	                  )T
	                  CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T1) AS PERIODOS,
	      (SELECT ESTADO 
	       FROM DB_COMERCIAL.INFO_SERVICIO 
	     WHERE ID_SERVICIO = Cn_IdServicio) AS ESTADO FROM DUAL;       



	   CURSOR C_OBT_PRO_MENS_REGENERAR(Cn_IdServicio INTEGER)
        IS
	      SELECT 
            DISTINCT ATPR.VALOR,IDMP.TIPO_PROMOCION_ID 
            FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                 DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                 DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR
            WHERE 
                 IDMS.SERVICIO_ID = Cn_IdServicio AND
                 IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID AND IDMP.TIPO_PROMOCION = 'PROM_MPLA'
                 AND ATPR.TIPO_PROMOCION_id = IDMP.TIPO_PROMOCION_ID
                 AND AC.DESCRIPCION_CARACTERISTICA = 'PROM_PERIODO'
                 AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID;


	     --Costo: 3
	   CURSOR C_PeriodoDesc(Cv_Trama  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
                         Cv_Orden  NUMBER) IS       
      SELECT COUNT(T2.PERIODO) AS PERIODO, 
        T2.DESCUENTO 
      FROM ( SELECT SUBSTR(T.VALOR,1,INSTR(T.VALOR,'|',1)-1) AS PERIODO, 
               SUBSTR(T.VALOR,INSTR(T.VALOR,'|',1)+1) AS DESCUENTO 
             FROM (SELECT REGEXP_SUBSTR(Cv_Trama,'[^,]+', 1, LEVEL) AS VALOR
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(Cv_Trama, '[^,]+', 1, LEVEL) IS NOT NULL) T) T2
      GROUP BY T2.DESCUENTO
      ORDER BY Cv_Orden DESC;

        CURSOR C_OBTENER_LOGIN(Cn_IdServicio INTEGER)
        IS
            SELECT IPU.LOGIN, 
            (CASE WHEN IPE.RAZON_SOCIAL IS NOT NULL THEN IPE.RAZON_SOCIAL ELSE IPE.NOMBRES || ' ' || IPE.APELLIDOS END) AS NOMBRES
            FROM DB_COMERCIAL.INFO_SERVICIO ISE
              INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON ISE.PUNTO_ID=IPU.ID_PUNTO
              INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPU.PERSONA_EMPRESA_ROL_ID
              INNER JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID
              WHERE IPU.ESTADO != 'Eliminado' AND ISE.ID_SERVICIO=Cn_IdServicio;

      CURSOR C_GET_SERVICIO_ADENDUM(Cv_servicio INTEGER)
           IS
            SELECT DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO, APRO.FRECUENCIA,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION,ISE.CANTIDAD ,APRO.DESCRIPCION_PRODUCTO
            FROM DB_COMERCIAL.INFO_SERVICIO ISE 
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE ISE.ID_SERVICIO = Cv_servicio 
           AND ISE.ESTADO NOT IN ('Cancelado','Anulado','Inactivo','Eliminado','Cancel','Rechazada','Eliminado-Migra')  
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;   


        Ln_CodEmpresa              INTEGER;
        Ln_idPunto                 INTEGER;
        Ln_DescuentoIns            INTEGER;
 --     Ln_PeridosIns              INTEGER;
        Ln_DescuentoMens           INTEGER;
        Ln_CantPeriodoIns          INTEGER;
        Ln_CantPeriodoMens         INTEGER;
        Lv_Servicio                INTEGER;

        Lr_TipoPromoRegla          DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
        Lc_PeriodoDesc             C_PeriodoDesc%ROWTYPE;
        Lc_Datos                   C_OBT_PRO_INST_PERIODO%ROWTYPE;

        Lv_PromoMensual            VARCHAR2(600);
        Lv_DescuentMensualReco     VARCHAR2(400);
        Ln_PromoId                 INTEGER;
        Lv_NombrePlan              VARCHAR2(400);
        Lv_Tipo                    VARCHAR2(400);
        Lv_NumeroAdendum           VARCHAR2(400);
        Lv_NombreParametroEstado   VARCHAR2(400) := 'ESTADO_PLAN_CONTRATO';
--      Lv_NombreParametroProd     VARCHAR2(400) := 'PRODUCTOS_TM_COMERCIAL';
        Lv_ModuloParametroProd     VARCHAR2(400) := 'COMERCIAL';
        Lv_ModuloParametroMens     VARCHAR2(400) := 'CONTRATO-DIGITAL';
        Lv_DescripCaracteristicaNa VARCHAR2(400) := 'VELOCIDAD_MAXIMA';
        Lv_DescripCaracteristicaIn VARCHAR2(400) := 'VELOCIDAD_MINIMA';
        Lv_DescipValorEquipa       VARCHAR2(400);
        Lv_DescipValorMensCRS      VARCHAR2(400) := 'MENSAJE_CONTRATO_DIGITAL_CRS';
        Lv_DescipValorMensEmple    VARCHAR2(400) := 'MENSAJE_CONTRATO_DIGITAL_EMPLEADO';
        Lv_NombreParametroEquipa   VARCHAR2(400) := 'VALOR_EQUIPAMIENTO_CONTRATO_DIGITAL';
        Lv_NombreParametroMensaje  VARCHAR2(400) := 'MENSAJES_CONTRATO_DIGITAL';
        Lv_NombreParametroEmpleado VARCHAR2(400) := 'RESTRICCION_PLANES_X_INSTALACION';
        Lv_ParametroMensajeCRS     VARCHAR2(400);
        Lv_ParametroMensajeEmpl    VARCHAR2(400);
        Lv_ParametroDescripEmpl    VARCHAR2(400);
        Lv_LoginCRS                VARCHAR2(400);
        Lv_NombresCliente          VARCHAR2(1000);
        Lv_LoginEmpleado           VARCHAR2(400);
        Lv_ParametroEquipaValor2   VARCHAR2(400);
        Lv_ParametroEquipaValor3   VARCHAR2(400);
        Lv_NombreTecnico           VARCHAR2(400);
        Lv_Frecuencia              VARCHAR2(400);
        Lv_CodigoProducto          VARCHAR2(400);
        Lv_PromoIns                VARCHAR2(400) := 'PROM_INS';
        Lv_PromoMens               VARCHAR2(400) := 'PROM_MENS';
        Lv_ObservacionIns          VARCHAR2(400);
        Lv_ObservacionMens         VARCHAR2(400);
        Lv_ValorProducCaractNa     VARCHAR2(400);
        Lv_ValorProducCaractInt    VARCHAR2(400);
        Lv_ObservacionContrato     VARCHAR2(4000);
        Lv_FuncionPrecio           VARCHAR2(4000);
        Lv_DigitoVerificacion      VARCHAR2(400);
        Lv_NombreTecnicoServ       VARCHAR2(400);
        Lv_CodigoUltimaMilla       VARCHAR2(400);
        Lv_CambioRazonSocial       VARCHAR2(400);
--      Lv_NombreProdAnterior      VARCHAR2(400);
        Lv_NombreProdPosterior     VARCHAR2(400);
        Lv_internet                VARCHAR2(2) := 'N';
        Lv_VariableIf              VARCHAR2(400) := '%IF%';
        Lv_VariableBusqueda        VARCHAR2(400) :=  '%[%';
        Lv_RecuperacionDocumentos  VARCHAR2(2) := 'N';       
        Ln_idCaracteristicaIn       INTEGER;
        Ln_idCaracteristicaNa       INTEGER;
        Ln_ContratoId               INTEGER;
        Ln_IteradorI                INTEGER;
        Ln_IteradorJ                INTEGER;        

        Ln_CobroItems               FLOAT := 0;
        Ln_Impuesto                 FLOAT := 0;
        Ln_ImpuestoUnico            FLOAT := 0;
        Ln_ImpuestoMensual          FLOAT := 0;
        Ln_PorcentajeImps           FLOAT := 0;
        Ln_SubTotal                 FLOAT := 0;
        Ln_SubtotalUnico            FLOAT := 0;
        Ln_SubtotalMensual          FLOAT := 0;
        Lv_PrecioProducto           FLOAT := 0;
        Ln_total_servicio           FLOAT := 0;
        Ln_SubTotalProd             FLOAT := 0;

        Le_Errors                  EXCEPTION;

        Lv_JsonProdParametros       CLOB;
        Lv_JsonServiciosContratados CLOB;

        Ln_CantidadProducto         INTEGER := 0;
        Ln_CantidadProductoTec      INTEGER := 0;
        Ln_NombreCicloFact          VARCHAR2(400);

        TYPE Pcl_servicio IS TABLE OF C_GET_SERV_CONTRATO%ROWTYPE;
        Pcl_arrayServicio Pcl_servicio;

        --TYPE Pcl_parametroEmpr IS TABLE OF C_GET_PARAMETROS_EMPR%ROWTYPE;
        --Pcl_arrayParametrosEmpr Pcl_parametroEmpr;

        TYPE Pcl_planDet IS TABLE OF C_GET_DET_PLAN%ROWTYPE;
        Pcl_arrayPlanDet Pcl_planDet;

        TYPE Pcl_ServCaract IS TABLE OF C_GET_SERV_PRODUCTO%ROWTYPE;
        Pcl_arrayServCaract Pcl_ServCaract;

        TYPE Lcl_TypeServiContrDet IS RECORD(
            PRECIO            NUMBER,
            CANTIDAD          NUMBER,
            INSTALACION       NUMBER,
            SUBTOTAL          NUMBER, 
            OBSERVACION       VARCHAR2(1000),
            DESCUENTO         NUMBER
        );

        TYPE Lcl_TypeServiContr IS RECORD(
            INTENET         Lcl_TypeServiContrDet,
            IP              Lcl_TypeServiContrDet,
            OTROS           Lcl_TypeServiContrDet
        );

        TYPE Lcl_TypeServ IS RECORD(
            IS_HOME            VARCHAR2(400),
            OBSERVACION_SERV   VARCHAR2(4000),
            IS_PYMES           VARCHAR2(400),
            IS_PRO             VARCHAR2(400),
            IS_GEPONFIBRA      VARCHAR2(400),
            IS_DSLOTROS        VARCHAR2(400),
            IS_SIMETRICO       VARCHAR2(400),
            IS_ASIMETRICO      VARCHAR2(400),
            VALOR_PLAN_LETRAS  VARCHAR2(400),
            VALOR_PLAN_NUM     VARCHAR2(400),
            DETALLE            Lcl_TypeServiContr,
            DETALLEEXTRA       VARCHAR2(400),
            SUBTOTAL           VARCHAR2(400),
            SUBTOTAL_UNICO     VARCHAR2(400),
            SUBTOTAL_MENSUAL   VARCHAR2(400),
            VEL_NAC_MAX        VARCHAR2(400),
            VEL_NAC_MIN        VARCHAR2(400),
            VEL_INT_MAX        VARCHAR2(400),
            VEL_INT_MIN        VARCHAR2(400),
            DESC_PLAN          NUMBER,
            MESES_DESC         NUMBER,
            IMPUESTOS          VARCHAR2(400),
            IMPUESTOS_UNICO    VARCHAR2(400),
            IMPUESTOS_MENSUAL  VARCHAR2(400),
            TOTAL              VARCHAR2(400),
            TOTAL_UNICO        VARCHAR2(400),
            TOTAL_MENSUAL      VARCHAR2(400),
            VALOR_PLAN_DESC    VARCHAR2(400),
            IS_PRECIO_PROMO    VARCHAR2(400),
            NOMBRE_PLAN        VARCHAR2(400),
            NOMBRE_CICLO       VARCHAR2(400)
        );

        Pcl_ResponseList         Lcl_TypeServ;                           

        Lv_Query              CLOB := 'SELECT ';                       
    BEGIN                                

       APEX_JSON.PARSE(Pcl_Request);

    Lv_NombrePlan         := APEX_JSON.get_varchar2(p_path => 'nombrePlan');
    Ln_CodEmpresa         := APEX_JSON.get_number(p_path => 'codEmpresa');
    Ln_idPunto            := APEX_JSON.get_number(p_path => 'idPunto');
    Lv_Tipo               := APEX_JSON.get_varchar2(p_path => 'tipo');
    Lv_NumeroAdendum      := APEX_JSON.get_varchar2(p_path => 'numeroAdendum');
    Ln_ContratoId         := APEX_JSON.get_number(p_path => 'contratoId');
    Lv_CambioRazonSocial  := APEX_JSON.get_varchar2(p_path => 'cambioRazonSocial');
    Lv_RecuperacionDocumentos:= APEX_JSON.get_varchar2(p_path => 'recuperarDocumentosDigitales');
    Lv_Servicio  := APEX_JSON.get_number(p_path => 'idServicio');



    --OPEN C_GET_PARAMETROS_EMPR(Lv_NombreParametroProd,Lv_ModuloParametroProd,Ln_CodEmpresa);
    --FETCH C_GET_PARAMETROS_EMPR BULK COLLECT INTO Pcl_arrayParametrosEmpr;
    --CLOSE C_GET_PARAMETROS_EMPR;    

    Pcl_ResponseList.IS_HOME            := '';--
    Pcl_ResponseList.OBSERVACION_SERV   := '';--
    Pcl_ResponseList.IS_PYMES           := '';--
    Pcl_ResponseList.IS_PRO             := '';--
    Pcl_ResponseList.IS_GEPONFIBRA      := '';--
    Pcl_ResponseList.IS_DSLOTROS        := '';--
    Pcl_ResponseList.IS_SIMETRICO       := '';--
    Pcl_ResponseList.IS_ASIMETRICO      := '';--
    Pcl_ResponseList.VALOR_PLAN_LETRAS  := '';--
    Pcl_ResponseList.VALOR_PLAN_NUM     := '';--
    Pcl_ResponseList.DETALLE.INTENET.PRECIO    := '';--
    --Pcl_ResponseList.DETALLEEXTRA       := Pcl_arrayParametrosEmpr;
    Pcl_ResponseList.DETALLEEXTRA       := '';
    Pcl_ResponseList.SUBTOTAL           := 0.0;--
    Pcl_ResponseList.SUBTOTAL_UNICO     := 0.0;
    Pcl_ResponseList.SUBTOTAL_MENSUAL   := 0.0;
    Pcl_ResponseList.VEL_NAC_MAX        := '';--
    Pcl_ResponseList.VEL_NAC_MIN        := '';--
    Pcl_ResponseList.VEL_INT_MAX        := '';--
    Pcl_ResponseList.VEL_INT_MIN        := '';--
    Pcl_ResponseList.DESC_PLAN          := 0;--
    Pcl_ResponseList.MESES_DESC         := 0;--
    Pcl_ResponseList.IMPUESTOS          := 0.0;--
    Pcl_ResponseList.IMPUESTOS_UNICO    := 0.0;
    Pcl_ResponseList.IMPUESTOS_MENSUAL  := 0.0;
    Pcl_ResponseList.TOTAL              := 0.0;
    Pcl_ResponseList.TOTAL_UNICO        := 0.0;
    Pcl_ResponseList.TOTAL_MENSUAL      := 0.0;
    Pcl_ResponseList.VALOR_PLAN_DESC    := 0.0;--
    Pcl_ResponseList.IS_PRECIO_PROMO    := '';--
    Pcl_ResponseList.NOMBRE_PLAN        := '';--
    Pcl_ResponseList.NOMBRE_CICLO       := '';--

   IF Lv_Servicio IS NOT NULL THEN 
            OPEN C_GET_SERVICIO_ADENDUM(Lv_Servicio);    
            FETCH C_GET_SERVICIO_ADENDUM BULK COLLECT INTO Pcl_arrayServicio LIMIT 5000;
            CLOSE C_GET_SERVICIO_ADENDUM;
   ELSE
      IF Lv_CambioRazonSocial = 'N' THEN
        IF Lv_Tipo = 'C'
        THEN
            OPEN C_GET_SERV_CONTRATO(Ln_ContratoId,Lv_Tipo);    
            FETCH C_GET_SERV_CONTRATO BULK COLLECT INTO Pcl_arrayServicio LIMIT 5000;
            CLOSE C_GET_SERV_CONTRATO;
        ELSE
            OPEN C_GET_SERV_ADENDUM(Lv_NumeroAdendum,Lv_Tipo);
            FETCH C_GET_SERV_ADENDUM BULK COLLECT INTO Pcl_arrayServicio LIMIT 5000;
            CLOSE C_GET_SERV_ADENDUM;
        END IF;
      ELSE
        IF Lv_Tipo = 'C'
        THEN
            OPEN C_GET_SERV_CONTRATO_RS(Ln_ContratoId,Lv_Tipo);    
            FETCH C_GET_SERV_CONTRATO_RS BULK COLLECT INTO Pcl_arrayServicio LIMIT 5000;
            CLOSE C_GET_SERV_CONTRATO_RS;
        ELSE
            OPEN C_GET_SERV_ADENDUM_RS(Lv_NumeroAdendum,Lv_Tipo,Ln_idPunto);
            FETCH C_GET_SERV_ADENDUM_RS BULK COLLECT INTO Pcl_arrayServicio LIMIT 5000;
            CLOSE C_GET_SERV_ADENDUM_RS;
        END IF;
      END IF;
    END IF;
  --



    OPEN C_CARAT_CICLO_FACTURACION(Ln_idPunto);
    FETCH C_CARAT_CICLO_FACTURACION INTO Ln_NombreCicloFact;
    CLOSE C_CARAT_CICLO_FACTURACION;

    Pcl_ResponseList.NOMBRE_CICLO := Ln_NombreCicloFact;

    IF Pcl_arrayServicio IS NOT NULL AND Pcl_arrayServicio.EXISTS(1)
    THEN
        OPEN C_GET_CARACTERISTICA(Lv_DescripCaracteristicaNa,Ln_CodEmpresa);
        FETCH C_GET_CARACTERISTICA INTO Ln_idCaracteristicaNa;
        CLOSE C_GET_CARACTERISTICA;

        OPEN C_GET_CARACTERISTICA(Lv_DescripCaracteristicaIn,Ln_CodEmpresa);
        FETCH C_GET_CARACTERISTICA INTO Ln_idCaracteristicaIn;
        CLOSE C_GET_CARACTERISTICA;

        --CREAR JSON de DETALLE  arrayServiciosContratados       
        Lv_JsonServiciosContratados := '{';

        Ln_IteradorI := Pcl_arrayServicio.FIRST;

        WHILE (Ln_IteradorI IS NOT NULL) 
        LOOP
            Lv_DescipValorEquipa     := null;
            Lv_ParametroEquipaValor2 := null;
            Lv_ParametroEquipaValor3 := null;

            --PLAN
            IF Pcl_arrayServicio(Ln_IteradorI).ID_PLAN IS NOT NULL
            THEN
                IF Pcl_arrayServicio(Ln_IteradorI).TIPO = 'HOME'
                THEN
                   Pcl_ResponseList.IS_HOME  := 'X';
                   Lv_DescipValorEquipa  := 'VALOR_EQUIPAMIENTO_CONTRATO_DIGITAL_HOME_MD';
                END IF;
                IF Pcl_arrayServicio(Ln_IteradorI).TIPO = 'PYME'
                THEN
                   Pcl_ResponseList.IS_PYMES := 'X';
                   Lv_DescipValorEquipa  := 'VALOR_EQUIPAMIENTO_CONTRATO_DIGITAL_PYME_MD';
                END IF;
                IF Pcl_arrayServicio(Ln_IteradorI).TIPO = 'PRO'
                THEN
                   Pcl_ResponseList.IS_PRO  := 'X';
                   Lv_DescipValorEquipa  := 'VALOR_EQUIPAMIENTO_CONTRATO_DIGITAL_PRO_MD';
                END IF;

                OPEN C_GET_PARAMETROS_EMPR_DESC(Lv_NombreParametroEquipa,Lv_ModuloParametroProd,Lv_DescipValorEquipa,Ln_CodEmpresa);
                FETCH C_GET_PARAMETROS_EMPR_DESC INTO Lv_ParametroEquipaValor2,Lv_ParametroEquipaValor3;
                CLOSE C_GET_PARAMETROS_EMPR_DESC;

                IF Lv_ParametroEquipaValor2 IS NOT NULL
                THEN
                    Pcl_ResponseList.VALOR_PLAN_NUM := Lv_ParametroEquipaValor2;
                END IF;

                IF Lv_ParametroEquipaValor3 IS NOT NULL
                THEN
                    Pcl_ResponseList.VALOR_PLAN_LETRAS := Lv_ParametroEquipaValor3;
                END IF;

                OPEN C_GET_DET_PLAN(Pcl_arrayServicio(Ln_IteradorI).ID_PLAN,Lv_NombreParametroEstado,Ln_CodEmpresa);
                FETCH C_GET_DET_PLAN BULK COLLECT INTO Pcl_arrayPlanDet LIMIT 5000;
                CLOSE C_GET_DET_PLAN;

                Ln_CantidadProducto := Ln_CantidadProducto + 1;

                IF  Pcl_arrayPlanDet.EXISTS(1) THEN

                Ln_IteradorJ := Pcl_arrayPlanDet.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL) 
                LOOP
                    Lv_NombreTecnico := null;
                    Lv_Frecuencia    := null;
                    OPEN C_GET_PRODUCTO(Pcl_arrayPlanDet(Ln_IteradorJ).PRODUCTO_ID);
                    FETCH C_GET_PRODUCTO INTO Lv_NombreTecnico, Lv_Frecuencia, Lv_CodigoProducto;
                    CLOSE C_GET_PRODUCTO;
                    IF Lv_NombreTecnico = 'INTERNET'
                    THEN
                        Lv_internet := 'S';
                        IF Lv_CambioRazonSocial = 'N' 
                        THEN

                         IF Lv_RecuperacionDocumentos= 'N'  
                         THEN
                              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_CONSUME_EVALUA_TENTATIVA
                            (
                                Ln_idPunto,
                                Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO,
                                Lv_PromoIns,
                                Ln_CodEmpresa,
                                Ln_DescuentoIns,
                                Ln_CantPeriodoIns,
                                Lv_ObservacionIns
                            );

                              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_CONSUME_EVALUA_TENTATIVA
                            (
                                Ln_idPunto,
                                Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO,
                                Lv_PromoMens,
                                Ln_CodEmpresa,
                                Ln_DescuentoMens,
                                Ln_CantPeriodoMens,
                                Lv_ObservacionMens
                            );


                            IF  Ln_DescuentoIns IS  NULL OR Ln_DescuentoIns = 0  THEN
                                Ln_DescuentoIns := 0;
                                Lv_ObservacionIns := 'No aplica Promoción por descuento de Instalación.';                                         
                            END IF;

                            IF  Ln_DescuentoMens IS  NULL OR   Ln_DescuentoMens = 0  THEN
                                Ln_DescuentoMens := 0;
                                Lv_ObservacionMens := 'No aplica Promoción por descuento Mensual.';                                       
                            END IF;

                         ELSE   

	                          OPEN C_OBTENER_PROMO_INSTALACION_RS(TO_NUMBER(Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO));
	                          FETCH C_OBTENER_PROMO_INSTALACION_RS INTO Ln_DescuentoIns;
	                          CLOSE C_OBTENER_PROMO_INSTALACION_RS;


	                          OPEN C_OBT_PRO_INST_PERIODO(TO_NUMBER(Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO));
	                          FETCH C_OBT_PRO_INST_PERIODO INTO Lc_Datos;
	                          CLOSE C_OBT_PRO_INST_PERIODO;


	                          IF Ln_DescuentoIns IS NOT NULL AND  Ln_DescuentoIns <>  0
	                          THEN
	                             Lv_ObservacionIns := 'Desct. Inst. Porcentaje: ' || Ln_DescuentoIns ||'%, #Numero de Periodos: '||Lc_Datos.PERIODOS;
	                          ELSE
	                             Lv_ObservacionIns := 'No aplica Promoción por descuento de Instalación.';
	                          END IF;




	                          OPEN C_OBT_PRO_MENS_REGENERAR(TO_NUMBER(Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO));
	                          FETCH C_OBT_PRO_MENS_REGENERAR INTO Lv_PromoMensual,Ln_PromoId;
	                          CLOSE C_OBT_PRO_MENS_REGENERAR;

	                          IF Lv_PromoMensual IS NOT NULL
	                          THEN                          
		                            Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Ln_PromoId);

		                            IF Lr_TipoPromoRegla.PROM_DESCUENTO IS NOT NULL THEN
							        --
							          Lv_DescuentMensualReco := Lr_TipoPromoRegla.PROM_DESCUENTO;
							        --
							        ELSE
							        --
							          OPEN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO,2);
								      FETCH C_PeriodoDesc INTO Lc_PeriodoDesc;
								      CLOSE C_PeriodoDesc;
								      Lv_DescuentMensualReco := Lc_PeriodoDesc.DESCUENTO;
							        --
							        END IF;


							        Ln_DescuentoMens:=TO_NUMBER(Lv_DescuentMensualReco,'9999');


		                            IF UPPER(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA) = 'SI' THEN
							        Ln_DescuentoMens := ' Descuento: ' || Lv_DescuentMensualReco ||'%';
							        ELSE
							        FOR Lc_Valores IN C_PeriodoDesc(Lv_PromoMensual,1) LOOP
							          Lv_ObservacionMens := Lv_ObservacionMens || ' #Numero de Periodos: '|| Lc_Valores.PERIODO 
							                                || ' - Descuento: ' || Lc_Valores.DESCUENTO || '%,';
							        END LOOP;
						            Lv_ObservacionMens := SUBSTR (Lv_ObservacionMens, 1, Length(Lv_ObservacionMens) - 1 );
						            END IF;                                  
                                    Lv_ObservacionMens := 'Desct. Serv. Internet: Promoción Indefinida: ' || NVL(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA,'NO')
                                    || ',' || Lv_ObservacionMens;  
	                          ELSE
	                             Ln_DescuentoMens:=0;
	                             Lv_ObservacionMens := 'No aplica Promoción por descuento Mensual.';
	                          END IF;

                          END IF;  


                            Lv_ObservacionIns := REPLACE(Lv_ObservacionIns, ', revisar en info_error','');
                            Lv_ObservacionMens := REPLACE(Lv_ObservacionMens, ', revisar en info_error','');

                            OPEN C_GET_PARAM_EMPR_EMPL_DESC(Lv_NombreParametroEmpleado,Lv_ModuloParametroProd,Lv_ObservacionIns,'%100%',Ln_CodEmpresa);
                            FETCH C_GET_PARAM_EMPR_EMPL_DESC INTO Lv_ParametroDescripEmpl;
                            CLOSE C_GET_PARAM_EMPR_EMPL_DESC; 

                            Lv_ObservacionContrato := '<li>'|| Pcl_arrayServicio(Ln_IteradorI).NOMBRE_PLAN || '<br>'; 

                            IF Lv_ParametroDescripEmpl IS NOT NULL
                            THEN
                               OPEN C_GET_PARAMETROS_EMPR_DESC1(Lv_NombreParametroMensaje,Lv_ModuloParametroMens,Lv_DescipValorMensEmple,Ln_CodEmpresa);
                               FETCH C_GET_PARAMETROS_EMPR_DESC1 INTO Lv_ParametroMensajeEmpl;
                               CLOSE C_GET_PARAMETROS_EMPR_DESC1; 

                               OPEN C_OBTENER_LOGIN(Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO);
                               FETCH C_OBTENER_LOGIN INTO Lv_LoginEmpleado,Lv_NombresCliente;
                               CLOSE C_OBTENER_LOGIN; 

                               Lv_ObservacionContrato := Lv_ObservacionContrato ||
                                              Lv_ParametroMensajeEmpl ||  ' ' ||
                                              Lv_LoginEmpleado;
                            ELSE
                               Lv_ObservacionContrato := Lv_ObservacionContrato ||
                                              Lv_ObservacionIns;
                            END IF;



                            IF Ln_DescuentoIns <>  0 AND  Ln_DescuentoMens = 0 AND Lv_ParametroDescripEmpl IS NULL
                            THEN                                                        
                            Lv_ObservacionContrato:=  Lv_ObservacionContrato|| ' Desct. Aplica Condiciones';
                            END IF;

                            Lv_ObservacionContrato:=  Lv_ObservacionContrato||'<br>'||Lv_ObservacionMens;

                            IF Ln_DescuentoMens = 0 
                            THEN
                            Lv_ObservacionContrato:= Lv_ObservacionContrato || 
                                                            '<br> Desct. Serv. Internet.'|| 
                                                              Ln_DescuentoMens|| '%; #Meses Desc 0';                          
                            END IF;


                            IF Lv_ParametroDescripEmpl IS NOT NULL
                            THEN                            
                              Lv_ObservacionContrato := Lv_ObservacionContrato || '; Desct. Aplica Condiciones.';
                            END IF;

                            IF   Ln_DescuentoMens  <>  0 AND Lv_ParametroDescripEmpl IS NULL 
                            THEN                            
                              Lv_ObservacionContrato := Lv_ObservacionContrato || '<br> Desct. Aplica Condiciones.';
                            END IF;


                        ELSE
                           -- Cursor para obtener la promociones de instalacion del anterior cliente
                          OPEN C_OBTENER_PROMO_INSTALACION_RS(TO_NUMBER(Pcl_arrayServicio(Ln_IteradorI).OBSERVACION));
                          FETCH C_OBTENER_PROMO_INSTALACION_RS INTO Ln_DescuentoIns;
                          CLOSE C_OBTENER_PROMO_INSTALACION_RS;

                          OPEN C_GET_PARAMETROS_EMPR_DESC1(Lv_NombreParametroMensaje,Lv_ModuloParametroMens,Lv_DescipValorMensCRS,Ln_CodEmpresa);
                          FETCH C_GET_PARAMETROS_EMPR_DESC1 INTO Lv_ParametroMensajeCRS;
                          CLOSE C_GET_PARAMETROS_EMPR_DESC1;  

                          OPEN C_OBTENER_LOGIN(TO_NUMBER(Pcl_arrayServicio(Ln_IteradorI).OBSERVACION));
                          FETCH C_OBTENER_LOGIN INTO Lv_LoginCRS,Lv_NombresCliente;
                          CLOSE C_OBTENER_LOGIN; 

                          Lv_ObservacionContrato :=' <br> ' || Lv_ParametroMensajeCRS || 
                                                    '  ' || Lv_LoginCRS ||
                                                    ' <br>  CLIENTE ORIGEN: ' || Lv_NombresCliente ||
                                                    ' <br>' || 'Aplica Condiciones ;Dec. Inst.'||Ln_DescuentoIns ||'% ;Desc. Fact. Mensual 0 % ; <br>  #Meses Desc. 0 ;Aplica Condiciones <br>' ;

                          Ln_CantPeriodoIns  := 0;
                          Ln_DescuentoMens   := NULL;
                          Ln_CantPeriodoMens := NULL;
                        END IF;                         

                        Lv_ObservacionContrato := Lv_ObservacionContrato ||'</li>'; 
                        Pcl_ResponseList.NOMBRE_PLAN := Pcl_arrayServicio(Ln_IteradorI).NOMBRE_PLAN;

                        OPEN C_GET_PRODUCTO_CARACT (Ln_idCaracteristicaNa,Pcl_arrayServicio(Ln_IteradorI).ID_PLAN);
                        FETCH C_GET_PRODUCTO_CARACT INTO Lv_ValorProducCaractNa;   
                        CLOSE C_GET_PRODUCTO_CARACT;

                        IF Lv_ValorProducCaractNa IS NOT NULL
                        THEN
                            Pcl_ResponseList.VEL_NAC_MAX        := Lv_ValorProducCaractNa;
                            Pcl_ResponseList.VEL_INT_MAX        := Lv_ValorProducCaractNa;
                        END IF;

                        OPEN C_GET_PRODUCTO_CARACT (Ln_idCaracteristicaIn,Pcl_arrayServicio(Ln_IteradorI).ID_PLAN);
                        FETCH C_GET_PRODUCTO_CARACT INTO Lv_ValorProducCaractInt;
                        CLOSE C_GET_PRODUCTO_CARACT;

                        IF Lv_ValorProducCaractInt IS NOT NULL
                        THEN
                            Pcl_ResponseList.VEL_NAC_MIN       :=  Lv_ValorProducCaractInt;
                            Pcl_ResponseList.VEL_INT_MIN        := Lv_ValorProducCaractInt;
                        END IF;

                    END IF;
                    Ln_CobroItems := Ln_CobroItems + Pcl_arrayPlanDet(Ln_IteradorJ).PRECIO_ITEM;

                    OPEN C_OBTENER_IMPUESTO (Pcl_arrayPlanDet(Ln_IteradorJ).PRODUCTO_ID);
                    FETCH C_OBTENER_IMPUESTO INTO Ln_PorcentajeImps;
                    CLOSE C_OBTENER_IMPUESTO;

                    IF ( Pcl_arrayServicio(Ln_IteradorI).ID_PLAN != 1430 ) THEN
                    Ln_SubTotal    := Ln_SubTotal  + Pcl_arrayPlanDet(Ln_IteradorJ).PRECIO_ITEM;          
                    Ln_total_servicio := Ln_SubTotal;
                    END IF;
                    IF Ln_PorcentajeImps IS NOT NULL
                    THEN
                        Ln_Impuesto   := Ln_Impuesto + ((Pcl_arrayPlanDet(Ln_IteradorJ).PRECIO_ITEM)* (Ln_PorcentajeImps/100));
                    END IF;  

                    Ln_IteradorJ := Pcl_arrayPlanDet.NEXT(Ln_IteradorJ);
                END LOOP;
                ELSE
                  Pv_Mensaje := 'No existe el plan definido por el parámetro ' || Lv_NombreParametroEstado;
                  RAISE Le_Errors;
                END IF;
                Pcl_ResponseList.DESC_PLAN    := Ln_DescuentoMens;
                Pcl_ResponseList.MESES_DESC   := Ln_CantPeriodoMens;          
                Pcl_ResponseList.DETALLE.INTENET.PRECIO := Ln_CobroItems;

                If (Lv_internet = 'S') THEN


                   Lv_JsonServiciosContratados := Lv_JsonServiciosContratados || '"INTERNET":{"CANTIDAD":"'||Ln_CantidadProducto||'","PRECIO":"'||Ln_total_servicio||'","DESCUENTO":"'||Ln_DescuentoMens||'","OBSERVACION":"'||Lv_ObservacionMens||'"},'; 

                   Ln_total_servicio := 0;
                   Lv_internet := 'N';
                END IF;

            ELSIF Pcl_arrayServicio(Ln_IteradorI).PRODUCTO_ID IS NOT NULL
            THEN             
                OPEN C_GET_SERV_PRODUCTO (Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO);
                FETCH C_GET_SERV_PRODUCTO BULK COLLECT INTO Pcl_arrayServCaract LIMIT 5000;
                CLOSE C_GET_SERV_PRODUCTO;

                Lv_FuncionPrecio := REPLACE(  UPPER(Pcl_arrayServicio(Ln_IteradorI).FUNCION_PRECIO), 'Math.ceil','ceil');
                Lv_FuncionPrecio := REPLACE(  Lv_FuncionPrecio, 'Math.floor','floor');
                Lv_FuncionPrecio := REPLACE(  Lv_FuncionPrecio, 'Math.pow','pow');

                IF Pcl_arrayServCaract IS NOT NULL AND Pcl_arrayServCaract.EXISTS(1) THEN                
                    Ln_IteradorJ := Pcl_arrayServCaract.FIRST;
                    WHILE (Ln_IteradorJ IS NOT NULL) 
                    LOOP
                      IF Pcl_arrayServCaract(Ln_IteradorJ).VALOR IS NULL AND Lv_FuncionPrecio LIKE Lv_VariableIf 
                         AND Lv_FuncionPrecio LIKE '%' || UPPER(Pcl_arrayServCaract(Ln_IteradorJ).DESCRIPCION_CARACTERISTICA) || '%' THEN
                        Pv_Mensaje := 'Falta valores en la característica del producto para autorizarlo';
                        RAISE Le_Errors; 
                      END IF;
                      Lv_FuncionPrecio := REPLACE(UPPER(Lv_FuncionPrecio),'["'||UPPER(Pcl_arrayServCaract(Ln_IteradorJ).DESCRIPCION_CARACTERISTICA)||'"]',' '''||REPLACE(UPPER(Pcl_arrayServCaract(Ln_IteradorJ).VALOR)||''' ', '"',''));
                      Lv_FuncionPrecio := REPLACE(UPPER(Lv_FuncionPrecio),'"['||UPPER(Pcl_arrayServCaract(Ln_IteradorJ).DESCRIPCION_CARACTERISTICA)||']"',' '''||REPLACE(UPPER(Pcl_arrayServCaract(Ln_IteradorJ).VALOR)||''' ', '"',''));                      
                      Lv_FuncionPrecio := REPLACE(UPPER(Lv_FuncionPrecio),'['||UPPER(Pcl_arrayServCaract(Ln_IteradorJ).DESCRIPCION_CARACTERISTICA)||']',' '''||REPLACE(UPPER(Pcl_arrayServCaract(Ln_IteradorJ).VALOR)||''' ', '"',''));
                      Ln_IteradorJ := Pcl_arrayServCaract.NEXT(Ln_IteradorJ);
                    END LOOP;
                END IF;


                IF Lv_FuncionPrecio NOT LIKE Lv_VariableIf THEN
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'PRECIO =','');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'PRECIO=','');

                  Lv_FuncionPrecio      := ' SELECT ' || Lv_FuncionPrecio || ' from dual ';
                ELSE
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'ELSE IF','WHEN'); 
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'IF','WHEN');  
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '"[','['); 
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, ']"',']');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '"','''');   
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, ' }','');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '}','');  
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, ') {',') THEN ');  
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '){',') THEN ');   
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '{','');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'PRECIO=','0'); 
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '===','=');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '==','=');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '&&','AND');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, ';','');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, '''''','''');
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, ''' ''','''');                

                   IF Lv_FuncionPrecio LIKE Lv_VariableBusqueda THEN
                       Pv_Mensaje := 'La función precio del servicio no tiene la caracteristica del producto.';
                       RAISE Le_Errors;     
                   END IF;


                  Lv_FuncionPrecio      := ' SELECT CASE ' || Lv_FuncionPrecio || ' END from dual '; 
                END IF;

               Lv_NombreTecnico := null;
               Lv_Frecuencia    := null;
               OPEN C_GET_PRODUCTO(Pcl_arrayServicio(Ln_IteradorI).PRODUCTO_ID);
               FETCH C_GET_PRODUCTO INTO Lv_NombreTecnico, Lv_Frecuencia, Lv_CodigoProducto;
               CLOSE C_GET_PRODUCTO;                



                EXECUTE IMMEDIATE Lv_FuncionPrecio INTO Lv_PrecioProducto;

                Lv_DigitoVerificacion := SUBSTR(Lv_PrecioProducto||'',-1,1);                
                IF LOWER(Lv_Frecuencia) = 'unica'
                THEN
                  Ln_SubtotalUnico := Ln_SubtotalUnico + Lv_PrecioProducto;
                ELSE
                  Ln_SubtotalMensual := Ln_SubtotalMensual + Lv_PrecioProducto;
                END IF;
                Ln_SubTotal := Ln_SubTotal + Lv_PrecioProducto;                            
                Ln_SubTotalProd := Ln_SubTotalProd + Lv_PrecioProducto;


                Lv_NombreTecnicoServ := Pcl_arrayServicio(Ln_IteradorI).NOMBRE_TECNICO;

               IF Lv_NombreTecnicoServ IS NULL
                THEN
                    Lv_NombreTecnicoServ := Pcl_arrayServicio(Ln_IteradorI).NOMBRE_TECNICO;
               END IF;  

                IF  Ln_IteradorI + 1 > Pcl_arrayServicio.LAST THEN
                    Lv_NombreProdPosterior := Pcl_arrayServicio(Ln_IteradorI).CODIGO_PRODUCTO;
                ELSE
                    Lv_NombreProdPosterior := Pcl_arrayServicio(Ln_IteradorI + 1).CODIGO_PRODUCTO;
                END IF;   
                OPEN C_OBTENER_IMPUESTO (Pcl_arrayServicio(Ln_IteradorI).PRODUCTO_ID);
                FETCH C_OBTENER_IMPUESTO INTO Ln_PorcentajeImps;
                CLOSE C_OBTENER_IMPUESTO;

                IF Ln_PorcentajeImps IS NOT NULL
                THEN
                  IF LOWER(Lv_Frecuencia) = 'unica'
                  THEN 
                    Ln_ImpuestoUnico := Ln_ImpuestoUnico + ((Lv_PrecioProducto)* (Ln_PorcentajeImps/100));
                  ELSE
                    Ln_ImpuestoMensual := Ln_ImpuestoMensual + ((Lv_PrecioProducto)* (Ln_PorcentajeImps/100));
                  END IF;
                  Ln_Impuesto   := Ln_Impuesto + ((Lv_PrecioProducto)* (Ln_PorcentajeImps/100));
                END IF;

                IF Lv_NombrePlan IS NOT NULL
                THEN 
                Pcl_ResponseList.NOMBRE_PLAN := Lv_NombrePlan;
                END IF;

                Ln_CantidadProductoTec := Ln_CantidadProductoTec + 1;


                Ln_DescuentoMens   := 0;
                Ln_CantPeriodoMens := 0 ; 
                DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_CONSUME_EVALUA_TENTATIVA
                        (
                            Ln_idPunto,
                            Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO,
                            Lv_PromoMens,
                            Ln_CodEmpresa,
                            Ln_DescuentoMens,
                            Ln_CantPeriodoMens,
                            Lv_ObservacionMens
                        );   

              IF  Ln_DescuentoMens IS NOT NULL AND   Ln_DescuentoMens <> 0  THEN                   
                Lv_ObservacionContrato := Lv_ObservacionContrato|| '<li>' ||  Pcl_arrayServicio(Ln_IteradorI).DESCRIPCION_PRODUCTO || '<br>';
                Lv_ObservacionContrato := Lv_ObservacionContrato|| Lv_ObservacionMens || '</li>';                    
              ELSE 
                Ln_DescuentoMens := 0;
                Lv_ObservacionMens := 'No aplica Promoción por descuento Mensual.'; 
              END IF;               

              IF (trim(Pcl_arrayServicio(Ln_IteradorI).CODIGO_PRODUCTO) != trim(Lv_NombreProdPosterior) OR 
                 (trim(Pcl_arrayServicio(Ln_IteradorI).CODIGO_PRODUCTO) = trim(Lv_NombreProdPosterior) AND Ln_DescuentoMens = 0)
                 OR Pcl_arrayServicio.COUNT = Ln_IteradorI) THEN
                    Lv_JsonServiciosContratados := Lv_JsonServiciosContratados || '"'||trim(Pcl_arrayServicio(Ln_IteradorI).CODIGO_PRODUCTO)||'-'||trim(Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO)||'": {"CANTIDAD":"'||Ln_CantidadProductoTec||'","PRECIO":"'||trim(to_char(Ln_SubTotalProd,'99,999,999,990.99'))||'","FRECUENCIA":"' || trim(Pcl_arrayServicio(Ln_IteradorI).FRECUENCIA) ||'","DESCUENTO":"'||Ln_DescuentoMens||'","OBSERVACION":"'||Lv_ObservacionMens||'"},'; 
                    Ln_SubTotalProd        := 0; 
                    Ln_CantidadProductoTec := 0;
              END IF;


                   Pcl_ResponseList.IMPUESTOS_UNICO   := trim(to_char(Ln_ImpuestoUnico,'99,999,999,990.99'));
                   Pcl_ResponseList.SUBTOTAL_UNICO    := trim(to_char(Ln_SubTotalUnico,'99,999,999,990.99'));
                   Pcl_ResponseList.TOTAL_UNICO       := trim(to_char(Ln_SubTotalUnico + Ln_ImpuestoUnico,'99,999,999,990.99'));

                   Pcl_ResponseList.IMPUESTOS_MENSUAL := trim(to_char(Ln_ImpuestoMensual,'99,999,999,990.99'));
                   Pcl_ResponseList.SUBTOTAL_MENSUAL  := trim(to_char(Ln_SubTotalMensual,'99,999,999,990.99'));
                   Pcl_ResponseList.TOTAL_MENSUAL     := trim(to_char(Ln_SubTotalMensual + Ln_ImpuestoMensual,'99,999,999,990.99')); 
            END IF;

                Lv_DescipValorEquipa  := 'VALOR_EQUIPAMIENTO_CONTRATO_DIGITAL_HOME_MD';

                OPEN C_GET_PARAMETROS_EMPR_DESC(Lv_NombreParametroEquipa,Lv_ModuloParametroProd,Lv_DescipValorEquipa,Ln_CodEmpresa);
                FETCH C_GET_PARAMETROS_EMPR_DESC INTO Lv_ParametroEquipaValor2,Lv_ParametroEquipaValor3;
                CLOSE C_GET_PARAMETROS_EMPR_DESC;

                IF Lv_ParametroEquipaValor2 IS NOT NULL
                THEN
                    Pcl_ResponseList.VALOR_PLAN_NUM := Lv_ParametroEquipaValor2;
                END IF;

                IF Lv_ParametroEquipaValor3 IS NOT NULL
                THEN
                    Pcl_ResponseList.VALOR_PLAN_LETRAS := Lv_ParametroEquipaValor3;
                END IF;


            OPEN C_OBTENER_ULTIMA_MILLA(Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO);
            FETCH C_OBTENER_ULTIMA_MILLA INTO Lv_CodigoUltimaMilla;
            CLOSE C_OBTENER_ULTIMA_MILLA;

            IF Lv_CodigoUltimaMilla = 'FO'
            THEN
                Pcl_ResponseList.IS_GEPONFIBRA := 'X';
            ELSE
                Pcl_ResponseList.IS_DSLOTROS := 'X';
            END IF;

            IF Pcl_ResponseList.VEL_NAC_MAX = Pcl_ResponseList.VEL_INT_MAX
            THEN
                Pcl_ResponseList.IS_SIMETRICO       := 'X';
            ELSE
                Pcl_ResponseList.IS_ASIMETRICO      := 'X';
            END IF;

             Pcl_ResponseList.IMPUESTOS    := trim(to_char(Ln_Impuesto,'99,999,999,990.99'));
             Pcl_ResponseList.SUBTOTAL     := trim(to_char(Ln_SubTotal,'99,999,999,990.99'));
             Pcl_ResponseList.TOTAL        := trim(to_char(Ln_SubTotal + Ln_Impuesto,'99,999,999,990.99'));


             IF Pcl_ResponseList.DESC_PLAN  IS NOT NULL AND Pcl_ResponseList.DESC_PLAN != 0
             THEN
                Pcl_ResponseList.VALOR_PLAN_DESC  := trim(to_char(Ln_SubTotal * ((100 - Pcl_ResponseList.DESC_PLAN)/100),'99,999,999,990.99'));
                Pcl_ResponseList.IS_PRECIO_PROMO  := 'X';
             END IF;

             Ln_CobroItems := 0;
             --Ln_Impuesto   := 0;
             Ln_IteradorI := Pcl_arrayServicio.NEXT(Ln_IteradorI);
        END LOOP;

    ELSE
      Pv_Mensaje := 'No se encuentran servicios asociados a Contrato/Adendum';
      RAISE Le_Errors;
    END IF;    



    Lv_JsonServiciosContratados := substr(Lv_JsonServiciosContratados, 0, length(Lv_JsonServiciosContratados)-1) || '}';
     DBMS_OUTPUT.PUT_LINE( Lv_JsonServiciosContratados );
    Pcl_ResponseList.OBSERVACION_SERV := Lv_ObservacionContrato; 
    Lv_JsonProdParametros := '[';

    --json   
    Lv_JsonProdParametros := '';
    Lv_Query := Lv_Query ||' '''||
                Pcl_ResponseList.IS_HOME||''' IS_HOME, '''||
                Pcl_ResponseList.OBSERVACION_SERV||''' OBSERVACION_SERV, '''||
                Pcl_ResponseList.IS_PYMES||''' IS_PYMES, '''||
                Pcl_ResponseList.IS_PRO||''' IS_PRO, '''||
                Pcl_ResponseList.IS_GEPONFIBRA||''' IS_GEPONFIBRA, '''||
                Pcl_ResponseList.IS_DSLOTROS||''' IS_DSLOTROS, '''||
                Pcl_ResponseList.IS_SIMETRICO||''' IS_SIMETRICO, '''||
                Pcl_ResponseList.IS_ASIMETRICO||''' IS_ASIMETRICO, '''||
                Pcl_ResponseList.VALOR_PLAN_LETRAS||''' VALOR_PLAN_LETRAS, '''||
                Pcl_ResponseList.VALOR_PLAN_NUM||''' VALOR_PLAN_NUM, '''||
                Pcl_ResponseList.DETALLE.INTENET.PRECIO||''' PRECIO, '''||
                Pcl_ResponseList.SUBTOTAL||''' SUBTOTAL, '''||
                Pcl_ResponseList.SUBTOTAL_UNICO||''' SUBTOTAL_UNICO, '''||
                Pcl_ResponseList.SUBTOTAL_MENSUAL||''' SUBTOTAL_MENSUAL, '''||
                Pcl_ResponseList.VEL_NAC_MAX||''' VEL_NAC_MAX, '''||
                Pcl_ResponseList.VEL_NAC_MIN||''' VEL_NAC_MIN, '''||
                Pcl_ResponseList.VEL_INT_MAX||''' VEL_INT_MAX, '''||
                Pcl_ResponseList.VEL_INT_MIN||''' VEL_INT_MIN, '''||
                Pcl_ResponseList.DESC_PLAN||''' DESC_PLAN, '''||
                Pcl_ResponseList.MESES_DESC||''' MESES_DESC, '''||
                Pcl_ResponseList.IMPUESTOS||''' IMPUESTOS, '''||
                Pcl_ResponseList.IMPUESTOS_UNICO||''' IMPUESTOS_UNICO, '''||
                Pcl_ResponseList.IMPUESTOS_MENSUAL||''' IMPUESTOS_MENSUAL, '''||
                Pcl_ResponseList.TOTAL||''' TOTAL, '''||
                Pcl_ResponseList.TOTAL_UNICO||''' TOTAL_UNICO, '''||
                Pcl_ResponseList.TOTAL_MENSUAL||''' TOTAL_MENSUAL, '''||
                Pcl_ResponseList.VALOR_PLAN_DESC||''' VALOR_PLAN_DESC, '''||
                Pcl_ResponseList.IS_PRECIO_PROMO||''' IS_PRECIO_PROMO, '''||
                Lv_JsonProdParametros||''' ARRAY_PROD_PARAMETROS, '''||
                Lv_JsonServiciosContratados||''' ARRAY_SERV_CONTRATADOS, '''||
                Pcl_ResponseList.NOMBRE_PLAN||''' NOMBRE_PLAN, '''||
                Pcl_ResponseList.NOMBRE_CICLO ||''' NOMBRE_CICLO '||
                'FROM DUAL';                            

                OPEN Pcl_Response FOR Lv_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
    EXCEPTION 
    WHEN Le_Errors THEN
        ROLLBACK;
        Pv_Status     := 'ERROR';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                         'DB_COMERCIAL.P_OBTENER_SERVICIOS_ADENDUM',
                                         'ERROR: ' || Pv_Mensaje,
                                         'telcos',
                                         SYSDATE,
                                         '127.0.0.1');
    WHEN OTHERS THEN 
    ROLLBACK;
    Pv_Status    := 'ERROR';
    Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    Pcl_Response := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                         'DB_COMERCIAL.P_OBTENER_SERVICIOS_ADENDUM',
                                         'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                         'telcos',
                                         SYSDATE,
                                         '127.0.0.1');

    END P_OBTENER_SERVICIOS_ADENDUM;

    PROCEDURE P_OBTENER_DESCUENTO_RS(Pcl_Request  IN  VARCHAR2,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR)
    IS
    CURSOR C_OBTENER_PROMO_INSTALACION_RS(Cn_IdServicio INTEGER)
        IS
            SELECT 
                SUBSTR(T2.VALOR,INSTR(T2.VALOR,'|')+1) AS PORCENTAJE
            FROM 
              (SELECT 
                    REGEXP_SUBSTR(T1.VALOR,'[^,]+', 1, LEVEL) AS VALOR
                FROM(
                    SELECT 
                        ATPR.VALOR
                    FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
                        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                    WHERE IDMS.SERVICIO_ID = Cn_IdServicio
                        AND IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID
                        AND IDMP.TIPO_PROMOCION = 'PROM_INS'
                        AND ATPR.TIPO_PROMOCION_id = IDMP.TIPO_PROMOCION_ID
                        AND ATPR.ESTADO != 'Eliminado'
                        AND DBAC.ID_CARACTERISTICA = ATPR.CARACTERISTICA_ID
                        AND DBAC.DESCRIPCION_CARACTERISTICA = 'PROM_PERIODO'
                        AND MONTHS_BETWEEN(SYSDATE,IDMS.FE_CREACION) <= 36) T1
                WHERE ROWNUM = 1
                CONNECT BY REGEXP_SUBSTR(T1.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T2;

    Ln_DescuentoIns     INTEGER;
    Ln_idServicio       INTEGER;

    BEGIN
      APEX_JSON.PARSE(Pcl_Request);

      Ln_idServicio         := APEX_JSON.get_number(p_path => 'idServicio');

      OPEN C_OBTENER_PROMO_INSTALACION_RS(Ln_idServicio);
      FETCH C_OBTENER_PROMO_INSTALACION_RS INTO Ln_DescuentoIns;
      CLOSE C_OBTENER_PROMO_INSTALACION_RS;

      OPEN Pcl_Response FOR 
      SELECT Ln_DescuentoIns AS descuento
      FROM  DUAL;

      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';

      EXCEPTION 
      WHEN OTHERS THEN 
      Pv_Status    := 'ERROR';
      Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
      Pcl_Response := NULL;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                          'DB_COMERCIAL.P_OBTENER_DESCUENTO_RS',
                                          'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                          'telcos',
                                          SYSDATE,
                                          '127.0.0.1');

    END P_OBTENER_DESCUENTO_RS; 

   PROCEDURE P_VERIFICA_DOCUMENTOS_REQ(Pcl_Request  IN  VARCHAR2,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
    IS
      Lv_CodEmpresa VARCHAR2(200);     
      Lv_PrefijoEmpresa VARCHAR2(200);
      Lv_UsrCreacion VARCHAR2(200);
      Lv_ClientIp VARCHAR2(200);
      Ln_IdFormaPago NUMBER ;
      Ln_IdTipoCuenta NUMBER ;
      Lv_CodFormaPago VARCHAR2(200);
      Lv_TipoTributario VARCHAR2(200);
--    Lv_CodigoTipoDocumento  VARCHAR2(200);
      Lv_Default  VARCHAR2(200);
      Lv_NombreParametro VARCHAR2(200);

       CURSOR C_FormaPago(Cn_IdFormaPago NUMBER) IS 
       SELECT CODIGO_FORMA_PAGO FROM DB_GENERAL.ADMI_FORMA_PAGO
       WHERE ID_FORMA_PAGO = Cn_IdFormaPago
       AND ESTADO  = 'Activo'; 

       CURSOR C_TipoCuenta(Cn_IdTipoCuenta NUMBER) IS 
       SELECT DESCRIPCION_CUENTA FROM DB_GENERAL.ADMI_TIPO_CUENTA
       WHERE ID_TIPO_CUENTA = Cn_IdTipoCuenta
       AND ESTADO  = 'Activo'; 


       BEGIN  
        APEX_JSON.PARSE(Pcl_Request);   
        Lv_CodEmpresa  := APEX_JSON.GET_VARCHAR2(p_path => 'codEmpresa');
        Lv_PrefijoEmpresa  := APEX_JSON.GET_VARCHAR2(p_path => 'prefijoEmpresa');     
        Lv_UsrCreacion := APEX_JSON.GET_VARCHAR2(p_path => 'usrCreacion');
        Lv_ClientIp := APEX_JSON.GET_VARCHAR2(p_path => 'clientIp');
        Ln_IdFormaPago := APEX_JSON.GET_VARCHAR2(p_path => 'idFormaPago');
        Ln_IdTipoCuenta  := APEX_JSON.GET_VARCHAR2(p_path => 'idTipoCuenta');
        Lv_TipoTributario := APEX_JSON.GET_VARCHAR2(p_path => 'tipoTributario');
        Lv_Default :='DEFAULT';
        Lv_NombreParametro := 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS'; 


        --DOCUMENTOS POR FORMA DE PAGO
        FOR i IN  C_FormaPago(Ln_IdFormaPago)   LOOP    
             Lv_CodFormaPago:=  i.CODIGO_FORMA_PAGO;  
             dbms_output.put_line('Lv_CodFormaPago'||Lv_CodFormaPago);  

            IF (Ln_IdTipoCuenta IS NOT NULL) THEN 
              dbms_output.put_line('Ln_IdTipoCuentaDD'||Ln_IdTipoCuenta);  
              FOR j IN  C_TipoCuenta(Ln_IdTipoCuenta)   LOOP   
                  Lv_CodFormaPago := j.DESCRIPCION_CUENTA;    
                   dbms_output.put_line('Lv_CodFormaPago '||Lv_CodFormaPago);  
                  --CUANDO HAY TARJETAS DE CREDITO EN DEBITO BANCARIO
                  IF (REGEXP_LIKE(j.DESCRIPCION_CUENTA, 'TARJETA') ) THEN                 
                     Lv_CodFormaPago := 'TARC';  
                  END IF;
              END LOOP;
            END IF;
      	END LOOP;         



       Pv_Status := 'OK';  
       Pv_Mensaje := 'Transacción exitosa';  


       OPEN  Pcl_Response FOR
       SELECT  
       atdg.ID_TIPO_DOCUMENTO ,  
       atdg.CODIGO_TIPO_DOCUMENTO , 
       atdg.DESCRIPCION_TIPO_DOCUMENTO , 
       apd.VALOR3  AS grupo ,
       apd.VALOR6  AS grupo_descripcion , 
       apd.VALOR5  AS requerido 
       FROM  DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL atdg 
       INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET apd  ON apd.VALOR2  = atdg.CODIGO_TIPO_DOCUMENTO 
       INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc  ON apc.ID_PARAMETRO  = apd.PARAMETRO_ID  
       WHERE apd.ESTADO  = 'Activo'
       AND   apc.ESTADO  = 'Activo'
       AND   atdg.ESTADO = 'Activo' 
       AND   apd.VALOR4  = 'S' 
       AND   apd.EMPRESA_COD = Lv_CodEmpresa
       AND   apc.NOMBRE_PARAMETRO =  Lv_NombreParametro
       AND   apd.VALOR3  IN (       
       select regexp_substr( Lv_Default || ','|| Lv_CodFormaPago || ','||      Lv_TipoTributario,'[^,]+', 1, level) from dual
       connect by regexp_substr( Lv_Default || ','|| Lv_CodFormaPago || ','||      Lv_TipoTributario, '[^,]+', 1, level) is not null
       );  


     EXCEPTION
       WHEN OTHERS THEN
       Pv_Status := 'ERROR';  
       Pv_Mensaje := 'Transacción fallida'; 
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ERROR VALIDACION CONTRATO',
                                              'DB_COMERCIAL.CMKG_VALIDACIONES_CONTRATO.P_VERIFICAR_CATALOGO',
                                              'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');

  END P_VERIFICA_DOCUMENTOS_REQ;   

 PROCEDURE P_SERVICIO_PERSONA(Pcl_Request  IN  VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Lv_Estado                   VARCHAR2(100);
    Ln_PersonaId NUMBER;
    Ln_PersonaEmpresaRolId      NUMBER;
    Ln_puntoId                  NUMBER;
    Ln_productoId NUMBER;
    Lv_ProductoNombreTecnico VARCHAR2(100);
    Ld_FechaDesde DATE;
    Ld_FechaHasta DATE;
    Lb_EsVentaExterna           BOOLEAN;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado                := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_PersonaId:= APEX_JSON.get_number(p_path => 'personaId');
    Ln_PersonaEmpresaRolId   := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');
    Ln_productoId:= APEX_JSON.get_number(p_path => 'productoId');
    Lv_ProductoNombreTecnico:= APEX_JSON.get_varchar2(p_path => 'productoNombreTecnico');
    Lb_EsVentaExterna        := APEX_JSON.get_boolean(p_path => 'esVentaExterna');
    Ln_puntoId               := APEX_JSON.get_number(p_path => 'puntoId');
    Ld_FechaDesde:=APEX_JSON.get_date(p_path => 'feDesde');
    Ld_FechaHasta:=APEX_JSON.get_date(p_path => 'feHasta');
    -- VALIDACIONES
    IF Ln_PersonaId IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_PersonaId esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Lb_EsVentaExterna IS NULL THEN
      Lb_EsVentaExterna := FALSE;
    END IF;

    Lcl_Select       := '
              SELECT  ISE.ID_SERVICIO         ,
                      ISE.PUNTO_ID            ,
                      IP.LOGIN                ,
                      ISE.PRODUCTO_ID         ,
                      ISE.PLAN_ID             ,
                      ISE.ORDEN_TRABAJO_ID    ,
                      ISE.ES_VENTA            ,
                      ISE.CANTIDAD            ,
                      ISE.PRECIO_VENTA        ,
                      ISE.PUNTO_FACTURACION_ID,
                      ISE.ELEMENTO_ID         ,
                      ISE.ULTIMA_MILLA_ID     ,
                      ISE.TIPO_ORDEN          ,
                      ISE.OBSERVACION         ,
                      ISE.USR_VENDEDOR,
                      ISE.FE_CREACION,
                      NVL(AP.NOMBRE_TECNICO,APP.NOMBRE_TECNICO) AS PRODUCTO_NOMBRE_TECNICO';
   Lcl_From         := ' FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                    DB_COMERCIAL.INFO_PUNTO               IP  ,
                    DB_COMERCIAL.INFO_SERVICIO            ISE
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC on IPC.ID_PLAN=ISE.PLAN_ID
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD on IPD.PLAN_ID=IPC.ID_PLAN
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO=IPD.PRODUCTO_ID
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APP ON APP.ID_PRODUCTO=ISE.PRODUCTO_ID,
                    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISEH';
   Lcl_WhereAndJoin := ' WHERE IPER.ID_PERSONA_ROL     = IP.PERSONA_EMPRESA_ROL_ID
                    AND IP.ID_PUNTO         = ISE.PUNTO_ID
                    AND ISE.ID_SERVICIO= ISEH.SERVICIO_ID
                    AND ISE.ESTADO          in(''Activo'',''In-Corte'')
                    AND ISEH.ESTADO          = '''||Lv_Estado||'''
                    AND ISEH.ACCION =''confirmarServicio''
                    AND to_char(ISEH.OBSERVACION) = ''Se confirmo el servicio''
                    AND IPER.PERSONA_ID= '''||Ln_PersonaId||'''';
	IF Ln_puntoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.ID_PUNTO         = '''||Ln_puntoId||'''';
    END IF;
	IF Ln_PersonaEmpresaRolId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IPER.ID_PERSONA_ROL = '''||Ln_PersonaEmpresaRolId||'''';
    END IF;	
	IF Ln_productoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP.PRODUCTO_ID='''||Ln_productoId||'''';
    END IF;
	IF Lv_ProductoNombreTecnico IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND (AP.NOMBRE_TECNICO='''||Lv_ProductoNombreTecnico||''' OR APP.NOMBRE_TECNICO='''||Lv_ProductoNombreTecnico||''')';
    END IF;	

   IF Ld_FechaDesde IS NOT NULL AND Ld_FechaHasta IS NOT NULL AND Ld_FechaDesde > Ld_FechaHasta THEN
        Pv_Mensaje := 'La fecha Deste es mayor a la fecha Hasta';
        RAISE Le_Errors;
    END IF;

    IF Ld_FechaDesde IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TRUNC(ISE.FE_CREACION)>='''||Ld_FechaDesde||'''';
    END IF;	

     IF Ld_FechaHasta IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TRUNC(ISE.FE_CREACION)<='''||Ld_FechaHasta||'''';
    END IF;	

	IF NOT Lb_EsVentaExterna THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND (ISE.ES_VENTA <> ''E'' OR ISE.ES_VENTA IS NULL)';
    END IF;

    Lcl_OrderAnGroup := '
              ORDER BY ISE.FE_CREACION ASC';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_SERVICIO_PERSONA;

  PROCEDURE P_CONT_FORMA_PAGO_HISTORIAL(Pcl_Request  IN  VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB;
    Lcl_OrderAnGroup            CLOB;
    Ln_ContratoId NUMBER;
    Ln_FormaPagoId      NUMBER;
    Ld_FechaDesde DATE;
    Ld_FechaHasta DATE;
    Le_Errors                   EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ContratoId := APEX_JSON.get_number(p_path => 'contratoId');
    Ln_FormaPagoId := APEX_JSON.get_number(p_path => 'formaPagoId');
    Ld_FechaDesde :=APEX_JSON.get_date(p_path => 'feDesde');
    Ld_FechaHasta :=APEX_JSON.get_date(p_path => 'feHasta');
    -- VALIDACIONES
    IF Ln_ContratoId IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_ContratoId esta vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := 'SELECT  ICFPH.ID_DATOS_PAGO,
							ICFPH.CONTRATO_ID,
							ICFPH.BANCO_TIPO_CUENTA_ID,
							ICFPH.NUMERO_CTA_TARJETA,
							ICFPH.NUMERO_DEBITO_BANCO,
							ICFPH.CODIGO_VERIFICACION,
							ICFPH.TITULAR_CUENTA,
							ICFPH.FE_CREACION,
							ICFPH.FE_ULT_MOD,
							ICFPH.USR_CREACION,
							ICFPH.USR_ULT_MOD,
							ICFPH.ESTADO,
							ICFPH.TIPO_CUENTA_ID,
							ICFPH.IP_CREACION,
							ICFPH.ANIO_VENCIMIENTO,
							ICFPH.MES_VENCIMIENTO,
							ICFPH.CEDULA_TITULAR,
							ICFPH.FORMA_PAGO,
							ICFPH.MOTIVO_ID,
							ICFPH.NUMERO_ACTA,
							ICFPH.FORMA_PAGO_ACTUAL_ID,
							ICFPH.FACTURA,
							ICFPH.OBSERVACION,
							ICFPH.DCTO_APLICADO';
	Lcl_From         := ' FROM  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST ICFPH';
	Lcl_WhereAndJoin := ' WHERE ICFPH.CONTRATO_ID= '''||Ln_ContratoId||'''';

	IF Ln_FormaPagoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ICFPH.FORMA_PAGO = '''||Ln_FormaPagoId||'''';
    END IF;	

	IF Ld_FechaDesde IS NOT NULL AND Ld_FechaHasta IS NOT NULL AND Ld_FechaDesde > Ld_FechaHasta THEN
        Pv_Mensaje := 'La fecha Deste es mayor a la fecha Hasta';
        RAISE Le_Errors;
    END IF;

    IF Ld_FechaDesde IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TRUNC(ICFPH.FE_CREACION)>='''||Ld_FechaDesde||'''';
    END IF;	

     IF Ld_FechaHasta IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TRUNC(ICFPH.FE_CREACION)<='''||Ld_FechaHasta||'''';
    END IF;	

    Lcl_OrderAnGroup := ' ORDER BY ICFPH.FE_CREACION ASC';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_CONT_FORMA_PAGO_HISTORIAL;

   PROCEDURE P_INFO_CLIENTE_NOT_MASIVA_DET(Pcl_Request  IN  CLOB,
                                          Pv_Status    OUT VARCHAR2,
                           			      Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT CLOB) AS

   CURSOR C_GetPersonas(Cn_ProcesoMasivoCabId number,Cv_Estado Varchar2) IS
    SELECT  count(per.IDENTIFICACION_CLIENTE) CANTIDAD_PUNTOS,
            per.NOMBRES,
            per.APELLIDOS,
            ipmd.estado AS ESTADO_REGISTRO,
            listagg(ipmd.login,' | ') within GROUP (order by ipmd.login)  as LOGIN,
            listagg(REPLACE(ip.direccion,'-',' '),' - ') 
            within GROUP (order by ip.direccion)  as DIRECCION,
            per.IDENTIFICACION_CLIENTE,
            iper.ID_PERSONA_ROL,
            iperc.VALOR TOKEN_APP        
    FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET ipmd,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
        DB_COMERCIAL.INFO_PERSONA per,
        DB_COMERCIAL.INFO_PUNTO ip,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc,
        DB_COMERCIAL.ADMI_CARACTERISTICA ac 
    WHERE ipmd.PERSONA_EMPRESA_ROL_ID = iper.ID_PERSONA_ROL
    AND per.ID_PERSONA = iper.PERSONA_ID
    AND ipmd.PUNTO_ID = ip.ID_PUNTO
    AND iperc.PERSONA_EMPRESA_ROL_ID = iper.ID_PERSONA_ROL 
    AND iperc.CARACTERISTICA_ID = ac.ID_CARACTERISTICA 
    AND ac.DESCRIPCION_CARACTERISTICA ='PUSH_ID_CLIENTE'
    AND ipmd.PROCESO_MASIVO_CAB_ID = Cn_ProcesoMasivoCabId
    AND IPMD.ESTADO = decode(Cv_Estado,'Finalizado',IPMD.ESTADO,Cv_Estado)
    AND ip.ESTADO = 'Activo'
    AND iper.ESTADO = 'Activo'
    AND iperc.ESTADO = 'Activo'
    GROUP BY per.IDENTIFICACION_CLIENTE,NOMBRES,iperc.VALOR,
    iper.ID_PERSONA_ROL,ipmd.estado,per.APELLIDOS;

   Lv_Estado_Registro  varchar2(50);Ln_Id_Proceso_Masivo_Cab number;
   Lcl_Response        CLOB;
   Le_Error            EXCEPTION;

  BEGIN
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Estado_Registro       := APEX_JSON.get_varchar2('estadoRegistro');
     Ln_Id_Proceso_Masivo_Cab := APEX_JSON.get_number('idProcesoMasivoCab');
     APEX_JSON.INITIALIZE_CLOB_OUTPUT;
     APEX_JSON.OPEN_ARRAY();

     FOR i in C_GetPersonas(Ln_Id_Proceso_Masivo_Cab, Lv_Estado_Registro) LOOP
     	 APEX_JSON.OPEN_OBJECT;
     	 APEX_JSON.WRITE('cantidadPuntos', i.CANTIDAD_PUNTOS);
		   APEX_JSON.WRITE('cliente', i.NOMBRES||' '||i.APELLIDOS);
		   APEX_JSON.WRITE('estadoRegistro', i.ESTADO_REGISTRO);
		   APEX_JSON.WRITE('login', i.LOGIN);
		   APEX_JSON.WRITE('direccion', i.DIRECCION);
		   APEX_JSON.WRITE('identificacion', i.IDENTIFICACION_CLIENTE);
		   APEX_JSON.WRITE('personaEmpresaRolId', i.ID_PERSONA_ROL);
		   APEX_JSON.WRITE('tokenApp', i.TOKEN_APP);
       APEX_JSON.CLOSE_OBJECT;
     END LOOP;

     APEX_JSON.CLOSE_ARRAY;
     Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
     APEX_JSON.FREE_OUTPUT;

     Pv_Status := 'OK';
     Pv_Mensaje := 'Consulta exitosa';
     Pcl_Response := Lcl_Response;

  EXCEPTION
	WHEN OTHERS THEN
	  Pv_Status  := 'ERROR';
	  Pv_Mensaje := SQLERRM;
  END P_INFO_CLIENTE_NOT_MASIVA_DET;

  PROCEDURE P_FORMA_PAGO(Pcl_Request  IN  VARCHAR2,
                         Pv_Status    OUT VARCHAR2,
                         Pv_Mensaje   OUT VARCHAR2,
                         Pcl_Response OUT CLOB) AS
    CURSOR C_FormaPago IS 
       SELECT ID_FORMA_PAGO,
              CODIGO_FORMA_PAGO,
              DESCRIPCION_FORMA_PAGO
       FROM DB_GENERAL.ADMI_FORMA_PAGO
       WHERE ESTADO  = 'Activo'
       order by ID_FORMA_PAGO;

    CURSOR C_TipoCuenta(Cv_NombrePais VARCHAR2) IS 
      SELECT
          atct.id_tipo_cuenta     idtipocuenta,
          atct.descripcion_cuenta descripcioncuenta
      FROM
          db_general.admi_tipo_cuenta atct,
          db_general.admi_pais adps
      WHERE atct.pais_id = adps.id_pais
      AND adps.nombre_pais = Cv_NombrePais
      AND atct.estado = 'Activo';

    CURSOR C_BancoTipoCuenta(Cn_TipoCuenta NUMBER) IS
      SELECT
          adbt.id_banco_tipo_cuenta idbancotipocta,
          aban.id_banco          idbanco,
          aban.descripcion_banco descripcionbanco
      FROM
          DB_GENERAL.ADMI_BANCO_TIPO_CUENTA adbt,
          DB_GENERAL.ADMI_BANCO aban
      WHERE
            adbt.banco_id = aban.id_banco
        AND aban.estado IN ( 'Activo', 'Activo-debitos' )
        AND adbt.tipo_cuenta_id = Cn_TipoCuenta;

  --VARIABLE
    Lv_CodFormaPago     VARCHAR2(100);
    Lc_DebitoBancario   SYS_REFCURSOR;
    Lv_NombrePais       VARCHAR2(100);
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_NombrePais         := APEX_JSON.get_varchar2(p_path => 'nombrePais');
    IF Lv_NombrePais IS NULL THEN
      RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombrePais ');
    END IF;
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    apex_json.open_array;
    FOR i IN  C_FormaPago   LOOP
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('idFormaPago', i.ID_FORMA_PAGO);
      APEX_JSON.WRITE('codigoFormaPago', i.CODIGO_FORMA_PAGO);
      APEX_JSON.WRITE('descripcionFormaPago', i.DESCRIPCION_FORMA_PAGO);

      Lv_CodFormaPago:=  i.CODIGO_FORMA_PAGO;

      IF (Lv_CodFormaPago IS NOT NULL AND Lv_CodFormaPago = 'DEB') THEN 
        APEX_JSON.OPEN_ARRAY('tipoCuenta');
        FOR j IN C_TipoCuenta(Lv_NombrePais) LOOP
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('idTipoCuenta', j.IDTIPOCUENTA);
          APEX_JSON.WRITE('descripcionTipoCuenta', j.DESCRIPCIONCUENTA);
          APEX_JSON.OPEN_ARRAY('tipoBanco');
          FOR k IN C_BancoTipoCuenta(j.IDTIPOCUENTA) LOOP
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('idBancoTipoCuenta', k.IDBANCOTIPOCTA);
            APEX_JSON.WRITE('idBanco', k.IDBANCO);
            APEX_JSON.WRITE('descripcionBanco', k.DESCRIPCIONBANCO);
            APEX_JSON.CLOSE_OBJECT;
          END LOOP;
          APEX_JSON.CLOSE_ARRAY;
          APEX_JSON.CLOSE_OBJECT;
        END LOOP;
        APEX_JSON.CLOSE_ARRAY;
      END IF;
      APEX_JSON.CLOSE_OBJECT;
    END LOOP;
    apex_json.close_all;
    Pcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'CMKG_CONSULTA.P_FORMA_PAGO',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');

  END P_FORMA_PAGO;

  PROCEDURE P_GET_PUNTOS_SERVICIOS_CLIENTE(Pcl_Request  IN  CLOB,
                                           Pv_Status    OUT VARCHAR2,
                                           Pv_Mensaje   OUT VARCHAR2,
                                           Pcl_Response OUT CLOB)
  AS

    Lv_Estados              VARCHAR2(1000);
    Ln_IdPersonaEmpresaRol  NUMBER;
    Ln_IdPunto              NUMBER;
    Ln_CantEstadosPunto     NUMBER;
    Ln_CantEstadosServicio  NUMBER;
    Lcl_QueryPuntos         CLOB;
    Lcl_QueryServicios      CLOB;
    Lr_Punto                CMKG_TYPES.Ltr_Punto;
    Lr_Servicio             CMKG_TYPES.Ltr_Servicio;
    Li_Cont_Punto           PLS_INTEGER;
    Li_Cont_Servicio        PLS_INTEGER;
    Lrf_Puntos              SYS_REFCURSOR;
    Lrf_Servicios           SYS_REFCURSOR;
    Le_Errors               EXCEPTION;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdPersonaEmpresaRol := APEX_JSON.get_number('idPersonaEmpresaRol');
    Ln_IdPunto := APEX_JSON.get_number('idPunto');
    Ln_CantEstadosPunto := APEX_JSON.get_count('estadosPunto');
    Ln_CantEstadosServicio := APEX_JSON.get_count('estadosServicio');

    IF Ln_IdPersonaEmpresaRol IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_IdPersonaEmpresaRol esta vacío';
      RAISE Le_Errors;
    END IF;

    IF NVL(Ln_CantEstadosPunto,0) > 0 THEN
      FOR i IN 1..Ln_CantEstadosPunto LOOP
        Lv_Estados := Lv_Estados ||''''||APEX_JSON.get_varchar2('estadosPunto[%d]',i)||''',';
      END LOOP;      
      Lv_Estados := Substr(Initcap(Lv_Estados),1,length(Lv_Estados)-1);
    END IF;

    Lcl_QueryPuntos := 'SELECT
                            Ipu.Id_Punto,
                            Ipu.Login,
                            Ipu.Estado,
                            Ipu.Nombre_Punto,
                            Ipu.Direccion,
                            Ipu.Longitud,
                            Ipu.Latitud,
                            Ase.Id_Sector,
                            Ase.Nombre_Sector,
                            Apa.Id_Parroquia,
                            Apa.Nombre_Parroquia,
                            Aca.Id_Canton,
                            Aca.Nombre_Canton,
                            Apr.Id_Provincia,
                            Apr.Nombre_Provincia
                        FROM
                           Info_Punto Ipu 
                        INNER JOIN Db_General.Admi_Sector    Ase ON Ipu.Sector_Id = Ase.Id_Sector
                        INNER JOIN Db_General.Admi_Parroquia Apa ON Ase.Parroquia_Id = Apa.Id_Parroquia
                        INNER JOIN Db_General.Admi_Canton    Aca ON Apa.Canton_Id = Aca.Id_Canton
                        INNER JOIN Db_General.Admi_Provincia Apr ON Aca.Provincia_Id = Apr.Id_Provincia ';

    DBMS_LOB.APPEND(Lcl_QueryPuntos,REPLACE('WHERE Ipu.Persona_Empresa_Rol_Id = :idPersonaEmpresaRol ',':idPersonaEmpresaRol',Ln_IdPersonaEmpresaRol));

    IF Ln_IdPunto IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryPuntos,REPLACE('AND Ipu.Id_Punto = :id_punto ',':id_punto',Ln_IdPunto));
    END IF;

    DBMS_LOB.APPEND(Lcl_QueryPuntos,REPLACE('AND Ipu.Estado IN (:estados) ',':estados',Lv_Estados));
    DBMS_LOB.APPEND(Lcl_QueryPuntos,'ORDER BY Ipu.Id_Punto ASC');

    OPEN Lrf_Puntos FOR Lcl_QueryPuntos;                       

    Lv_Estados := '';             
    IF NVL(Ln_CantEstadosServicio,0) > 0 THEN
      FOR i IN 1..Ln_CantEstadosServicio LOOP
        Lv_Estados := Lv_Estados ||''''||APEX_JSON.get_varchar2('estadosServicio[%d]',i)||''',';
      END LOOP;      
      Lv_Estados := Substr(Initcap(Lv_Estados),1,length(Lv_Estados)-1);
    END IF;                              

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_ARRAY();
    LOOP
      FETCH Lrf_Puntos BULK COLLECT INTO Lr_Punto LIMIT 100;
        Li_Cont_Punto := Lr_Punto.FIRST;
        WHILE (Li_Cont_Punto IS NOT NULL) LOOP
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('idPunto',Lr_Punto(Li_Cont_Punto).Id_Punto);
          APEX_JSON.WRITE('login', Lr_Punto(Li_Cont_Punto).Login);
          APEX_JSON.WRITE('estado', Lr_Punto(Li_Cont_Punto).Estado);
          APEX_JSON.WRITE('nombrePunto', Lr_Punto(Li_Cont_Punto).Nombre_Punto);
          APEX_JSON.WRITE('direccion', Lr_Punto(Li_Cont_Punto).Direccion);
          APEX_JSON.WRITE('longitud', Lr_Punto(Li_Cont_Punto).Longitud);
          APEX_JSON.WRITE('latitud', Lr_Punto(Li_Cont_Punto).Latitud);          
          APEX_JSON.WRITE('idSector',Lr_Punto(Li_Cont_Punto).Id_Sector);
          APEX_JSON.WRITE('nombreSector',Lr_Punto(Li_Cont_Punto).Nombre_Sector);
          APEX_JSON.WRITE('idParroquia',Lr_Punto(Li_Cont_Punto).Id_Parroquia);
          APEX_JSON.WRITE('nombreParroquia',Lr_Punto(Li_Cont_Punto).Nombre_Parroquia);
          APEX_JSON.WRITE('idCanton',Lr_Punto(Li_Cont_Punto).Id_Canton);
          APEX_JSON.WRITE('nombreCanton',Lr_Punto(Li_Cont_Punto).Nombre_Canton);
          APEX_JSON.WRITE('idProvincia',Lr_Punto(Li_Cont_Punto).Id_Provincia);
          APEX_JSON.WRITE('nombreProvincia',Lr_Punto(Li_Cont_Punto).Nombre_Provincia);

          Lcl_QueryServicios := 'SELECT
                                    *
                                 FROM
                                    Info_Servicio Ise ';
          DBMS_LOB.APPEND(Lcl_QueryServicios,REPLACE('WHERE Ise.Punto_Id = :idPunto ',':idPunto',Lr_Punto(Li_Cont_Punto).Id_Punto));
          DBMS_LOB.APPEND(Lcl_QueryServicios,REPLACE('AND Ise.Estado IN (:estados) ',':estados',Lv_Estados)); 
          DBMS_LOB.APPEND(Lcl_QueryServicios,'ORDER BY Ise.Id_Servicio ASC');

          OPEN Lrf_Servicios FOR Lcl_QueryServicios; 

          APEX_JSON.OPEN_ARRAY('servicios');
          LOOP
            FETCH Lrf_Servicios BULK COLLECT INTO Lr_Servicio LIMIT 100;
              Li_Cont_Servicio := Lr_Servicio.FIRST;
              WHILE (Li_Cont_Servicio IS NOT NULL) LOOP
                APEX_JSON.OPEN_OBJECT;
                APEX_JSON.WRITE('idServicio',Lr_Servicio(Li_Cont_Servicio).Id_Servicio);
                APEX_JSON.WRITE('loginAux', Lr_Servicio(Li_Cont_Servicio).Login_Aux);
                APEX_JSON.WRITE('estado', Lr_Servicio(Li_Cont_Servicio).Estado);                
                APEX_JSON.CLOSE_OBJECT;
                Li_Cont_Servicio:= Lr_Servicio.NEXT(Li_Cont_Servicio);
              END LOOP;
            EXIT WHEN Lrf_Servicios%NOTFOUND;
          END LOOP;              
          APEX_JSON.CLOSE_ARRAY;
          APEX_JSON.CLOSE_OBJECT;
          Li_Cont_Punto:= Lr_Punto.NEXT(Li_Cont_Punto);
        END LOOP;
      EXIT WHEN Lrf_Puntos%NOTFOUND;
    END LOOP;              
    APEX_JSON.CLOSE_ARRAY;
    Pcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_GET_PUNTOS_SERVICIOS_CLIENTE;    

end CMKG_CONSULTA;

/
