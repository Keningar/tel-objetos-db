CREATE OR REPLACE package DB_COMERCIAL.CMKG_CONSULTA is
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


end CMKG_CONSULTA;

/

CREATE OR REPLACE package body DB_COMERCIAL.CMKG_CONSULTA is
  PROCEDURE P_INFORMACION_CLIENTE(Pcl_Request  IN  CLOB,
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
                      IPER.ID_PERSONA_ROL       persona_empresa_rol_id';
    Lcl_From         := '
              FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
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
                AND IPU.SECTOR_ID              = ASE.ID_SECTOR
                AND ASE.PARROQUIA_ID           = AP.ID_PARROQUIA
                AND AP.CANTON_ID               = AC.ID_CANTON
                AND AC.PROVINCIA_ID            = APR.ID_PROVINCIA
                AND APR.REGION_ID              = AR.ID_REGION
                AND AR.PAIS_ID                 = APA.ID_PAIS
                AND IPER.ID_PERSONA_ROL        = '||Ln_PersonaEmpresaRolId||'
                AND IPU.ESTADO				         IN (''Activo'',''Pendiente'')';
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
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PersonaId      := APEX_JSON.get_number(p_path => 'personaId');

    -- VALIDACIONES
    IF Ln_PersonaId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaId esta vacío';
      RAISE Le_Errors;
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
    
    IF Ln_PersonaEmpresaRolId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IPERC.PERSONA_EMPRESA_ROL_ID = '||Ln_PersonaEmpresaRolId;
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
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION
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
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.NUMERO = Cv_numeroAdendum AND
            IAD.PUNTO_ID = Cn_PuntoId AND
            --IAD.FE_CREACION = (select  MAX(A.FE_CREACION) FROM DB_COMERCIAL.INFO_ADENDUM A where A.NUMERO=IAD.NUMERO GROUP BY A.NUMERO) AND
            ISE.ESTADO IN ('Factible','Activo') AND
            IAD.TIPO = Cv_Tipo
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;

        CURSOR C_GET_SERV_CONTRATO(Cn_ContratoId INTEGER, Cv_Tipo VARCHAR2)            
        IS
            SELECT DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO) AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.CONTRATO_ID = Cn_ContratoId AND
            --IAD.FE_CREACION = (select  MAX(A.FE_CREACION) FROM DB_COMERCIAL.INFO_ADENDUM A where A.CONTRATO_ID=IAD.CONTRATO_ID GROUP BY A.CONTRATO_ID) AND
            ISE.ESTADO IN ('Factible','Activo') AND
            IAD.TIPO = Cv_Tipo
            ORDER BY ISE.PLAN_ID ASC,ISE.PRODUCTO_ID DESC;

        CURSOR C_GET_SERV_CONTRATO_RS(Cn_ContratoId INTEGER, Cv_Tipo VARCHAR2)            
        IS
            SELECT DISTINCT ISE.ID_SERVICIO,APA.TIPO,APA.ID_PLAN,APA.NOMBRE_PLAN,ISE.PRODUCTO_ID,
            to_char(APRO.FUNCION_PRECIO)AS FUNCION_PRECIO,APRO.CODIGO_PRODUCTO,APRO.NOMBRE_TECNICO,
            ISE.PLAN_ID,TO_CHAR(ISE.OBSERVACION) AS OBSERVACION
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IAD.SERVICIO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB APA ON APA.ID_PLAN = ISE.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID
            WHERE
            IAD.CONTRATO_ID = Cn_ContratoId AND
            --IAD.FE_CREACION = (select  MAX(A.FE_CREACION) FROM DB_COMERCIAL.INFO_ADENDUM A where A.CONTRATO_ID=IAD.CONTRATO_ID GROUP BY A.CONTRATO_ID) AND
            ISE.ESTADO IN ('Factible','Activo') AND
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

        CURSOR C_GET_CARACTERISTICA(Cv_DescripcionCaract VARCHAR2)
        IS
            SELECT ACA.ID_CARACTERISTICA
            FROM DB_COMERCIAL.ADMI_CARACTERISTICA ACA
            WHERE
            ACA.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract ; 

        CURSOR C_GET_DET_PLAN(Cn_IdPlan VARCHAR2,Cv_NombreParametro VARCHAR2)
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
            ); 

        CURSOR C_GET_PRODUCTO(Cn_IdProducto INTEGER)
        IS
            SELECT APO.NOMBRE_TECNICO
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

        CURSOR C_GET_PRODUCTO_CARACT(Cn_IdProducto INTEGER,Cn_IdCaracteristica INTEGER,Cn_IdPlanDet INTEGER)
        IS
            SELECT IPPC.VALOR
            FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
            INNER JOIN INFO_PLAN_PRODUCTO_CARACT IPPC ON IPPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA 
            WHERE
            APC.PRODUCTO_ID = Cn_IdProducto 
            AND APC.CARACTERISTICA_ID = Cn_IdCaracteristica
            AND IPPC.PLAN_DET_ID = Cn_IdPlanDet;

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

        CURSOR C_OBTENER_LOGIN(Cn_IdServicio INTEGER)
        IS
            SELECT IPU.LOGIN, 
            (CASE WHEN IPE.RAZON_SOCIAL IS NOT NULL THEN IPE.RAZON_SOCIAL ELSE IPE.NOMBRES || ' ' || IPE.APELLIDOS END) AS NOMBRES
            FROM DB_COMERCIAL.INFO_SERVICIO ISE
              INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON ISE.PUNTO_ID=IPU.ID_PUNTO
              INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IPU.PERSONA_EMPRESA_ROL_ID
              INNER JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID
              WHERE IPU.ESTADO != 'Eliminado' AND ISE.ID_SERVICIO=Cn_IdServicio;

        Ln_CodEmpresa              INTEGER;
        Ln_idPunto                 INTEGER;
        Ln_DescuentoIns            INTEGER;
        Ln_DescuentoMens           INTEGER;
        Ln_CantPeriodoIns          INTEGER;
        Ln_CantPeriodoMens         INTEGER;

        Lv_NombrePlan              VARCHAR2(400);
        Lv_Tipo                    VARCHAR2(400);
        Lv_NumeroAdendum           VARCHAR2(400);
        Lv_NombreParametroEstado   VARCHAR2(400) := 'ESTADO_PLAN_CONTRATO';
        Lv_NombreParametroProd     VARCHAR2(400) := 'PRODUCTOS_TM_COMERCIAL';
        Lv_ModuloParametroProd     VARCHAR2(400) := 'COMERCIAL';
        Lv_ModuloParametroMens     VARCHAR2(400) := 'CONTRATO-DIGITAL';
        Lv_DescripCaracteristicaNa VARCHAR2(400) := 'CAPACIDAD1';
        Lv_DescripCaracteristicaIn VARCHAR2(400) := 'CAPACIDAD2';
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
        Lv_PromoIns                VARCHAR2(400) := 'PROM_INS';
        Lv_PromoMens               VARCHAR2(400) := 'PROM_MENS';
        Lv_ObservacionIns          VARCHAR2(400);
        Lv_ObservacionMens         VARCHAR2(400);
        Lv_ValorProducCaractNa     VARCHAR2(400);
        Lv_ValorProducCaractInt    VARCHAR2(400);
        Lv_ObservacionContrato     VARCHAR2(4000);
        Lv_FuncionPrecio           VARCHAR2(400);
        Lv_DigitoVerificacion      VARCHAR2(400);
        Lv_NombreTecnicoServ       VARCHAR2(400);
        Lv_CodigoUltimaMilla       VARCHAR2(400);
        Lv_CambioRazonSocial       VARCHAR2(400);
        Lv_NombreProdPosterior     VARCHAR2(400);
        Lv_internet                VARCHAR2(2) := 'N';
        Lv_VariableIf              VARCHAR2(400) := '%IF%';
        Lv_VariableBusqueda        VARCHAR2(400) :=  '%[%';

        Ln_idCaracteristicaIn       INTEGER;
        Ln_idCaracteristicaNa       INTEGER;
        Ln_ContratoId               INTEGER;
        Ln_IteradorI                INTEGER;
        Ln_IteradorJ                INTEGER;

        Ln_CobroItems               FLOAT := 0;
        Ln_Impuesto                 FLOAT := 0;
        Ln_PorcentajeImps           FLOAT := 0;
        Ln_SubTotal                 FLOAT := 0;
        Lv_PrecioProducto           FLOAT := 0;
        Ln_total_servicio           FLOAT := 0;
        Ln_SubTotalProd             FLOAT := 0;

        Le_Errors                  EXCEPTION;

        Lv_JsonProdParametros       CLOB;
        Lv_JsonServiciosContratados CLOB;

        Ln_CantidadProducto         INTEGER := 0;
        Ln_CantidadProductoTec      INTEGER := 0;

        TYPE Pcl_servicio IS TABLE OF C_GET_SERV_CONTRATO%ROWTYPE;
        Pcl_arrayServicio Pcl_servicio;

        TYPE Pcl_parametroEmpr IS TABLE OF C_GET_PARAMETROS_EMPR%ROWTYPE;
        Pcl_arrayParametrosEmpr Pcl_parametroEmpr;

        TYPE Pcl_planDet IS TABLE OF C_GET_DET_PLAN%ROWTYPE;
        Pcl_arrayPlanDet Pcl_planDet;

        TYPE Pcl_ServCaract IS TABLE OF C_GET_SERV_PRODUCTO%ROWTYPE;
        Pcl_arrayServCaract Pcl_ServCaract;

        TYPE Lcl_TypeServiContrDet IS RECORD(
            PRECIO            NUMBER,
            CANTIDAD          NUMBER
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
            DETALLEEXTRA       Pcl_parametroEmpr,
            SUBTOTAL           VARCHAR2(400),
            VEL_NAC_MAX        VARCHAR2(400),
            VEL_NAC_MIN        VARCHAR2(400),
            VEL_INT_MAX        VARCHAR2(400),
            VEL_INT_MIN        VARCHAR2(400),
            DESC_PLAN          NUMBER,
            MESES_DESC         NUMBER,
            IMPUESTOS          VARCHAR2(400),
            TOTAL              VARCHAR2(400),
            VALOR_PLAN_DESC    VARCHAR2(400),
            IS_PRECIO_PROMO    VARCHAR2(400),
            NOMBRE_PLAN        VARCHAR2(400)
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

    OPEN C_GET_PARAMETROS_EMPR(Lv_NombreParametroProd,Lv_ModuloParametroProd,Ln_CodEmpresa);
    FETCH C_GET_PARAMETROS_EMPR BULK COLLECT INTO Pcl_arrayParametrosEmpr LIMIT 5000; 
    CLOSE C_GET_PARAMETROS_EMPR;    

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
    Pcl_ResponseList.DETALLEEXTRA       := Pcl_arrayParametrosEmpr;
    Pcl_ResponseList.SUBTOTAL           := 0.0;--
    Pcl_ResponseList.VEL_NAC_MAX        := '';--
    Pcl_ResponseList.VEL_NAC_MIN        := '';--
    Pcl_ResponseList.VEL_INT_MAX        := '';--
    Pcl_ResponseList.VEL_INT_MIN        := '';--
    Pcl_ResponseList.DESC_PLAN          := 0;--
    Pcl_ResponseList.MESES_DESC         := 0;--
    Pcl_ResponseList.IMPUESTOS          := 0.0;--
    Pcl_ResponseList.TOTAL              := 0.0;--
    Pcl_ResponseList.VALOR_PLAN_DESC    := 0.0;--
    Pcl_ResponseList.IS_PRECIO_PROMO    := '';--
    Pcl_ResponseList.NOMBRE_PLAN        := '';--

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

    IF Pcl_arrayServicio IS NOT NULL AND Pcl_arrayServicio.EXISTS(1)
    THEN
        OPEN C_GET_CARACTERISTICA(Lv_DescripCaracteristicaNa);
        FETCH C_GET_CARACTERISTICA INTO Ln_idCaracteristicaNa;
        CLOSE C_GET_CARACTERISTICA;

        OPEN C_GET_CARACTERISTICA(Lv_DescripCaracteristicaIn);
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

                OPEN C_GET_DET_PLAN(Pcl_arrayServicio(Ln_IteradorI).ID_PLAN,Lv_NombreParametroEstado);
                FETCH C_GET_DET_PLAN BULK COLLECT INTO Pcl_arrayPlanDet LIMIT 5000;
                CLOSE C_GET_DET_PLAN;

                Ln_CantidadProducto := Ln_CantidadProducto + 1;

                IF  Pcl_arrayPlanDet.EXISTS(1) THEN

                Ln_IteradorJ := Pcl_arrayPlanDet.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL) 
                LOOP
                    Lv_NombreTecnico := null;
                    OPEN C_GET_PRODUCTO(Pcl_arrayPlanDet(Ln_IteradorJ).PRODUCTO_ID);
                    FETCH C_GET_PRODUCTO INTO Lv_NombreTecnico;
                    CLOSE C_GET_PRODUCTO;
                    IF Lv_NombreTecnico = 'INTERNET'
                    THEN
                        Lv_internet := 'S';
                        IF Lv_CambioRazonSocial = 'N' 
                        THEN
                            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_MAPEO_PROM_TENTATIVA
                            (
                                Ln_idPunto,
                                Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO,
                                Lv_PromoIns,
                                Ln_CodEmpresa,
                                Ln_DescuentoIns,
                                Ln_CantPeriodoIns,
                                Lv_ObservacionIns
                            );

                            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_MAPEO_PROM_TENTATIVA
                            (
                                Ln_idPunto,
                                Pcl_arrayServicio(Ln_IteradorI).ID_SERVICIO,
                                Lv_PromoMens,
                                Ln_CodEmpresa,
                                Ln_DescuentoMens,
                                Ln_CantPeriodoMens,
                                Lv_ObservacionMens
                            );

                            OPEN C_GET_PARAM_EMPR_EMPL_DESC(Lv_NombreParametroEmpleado,Lv_ModuloParametroProd,Lv_ObservacionIns,'%100%',Ln_CodEmpresa);
                            FETCH C_GET_PARAM_EMPR_EMPL_DESC INTO Lv_ParametroDescripEmpl;
                            CLOSE C_GET_PARAM_EMPR_EMPL_DESC; 

                            Lv_ObservacionContrato := Pcl_arrayServicio(Ln_IteradorI).NOMBRE_PLAN || '<br>';

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
                                              Lv_LoginEmpleado || '<br>' || 
                                              Lv_ObservacionMens || '<br>' ||
                                              'Aplica Condiciones';
                            ELSE
                               Lv_ObservacionContrato := Lv_ObservacionContrato ||
                                              Lv_ObservacionIns || '<br>' || 
                                              Lv_ObservacionMens || '<br>' ||
                                              'Aplica Condiciones';
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

                          Lv_ObservacionContrato := Lv_ParametroMensajeCRS || 
                                                    ' ' || Lv_LoginCRS ||
                                                    ' CLIENTE ORIGEN: ' || Lv_NombresCliente ||
                                                    ' <br>' || 'Aplica Condiciones';

                          Ln_CantPeriodoIns  := 0;
                          Ln_DescuentoMens   := NULL;
                          Ln_CantPeriodoMens := NULL;
                        END IF;

                        Pcl_ResponseList.OBSERVACION_SERV := Lv_ObservacionContrato;                          

                        Pcl_ResponseList.NOMBRE_PLAN := Pcl_arrayServicio(Ln_IteradorI).NOMBRE_PLAN;

                        OPEN C_GET_PRODUCTO_CARACT (Pcl_arrayPlanDet(Ln_IteradorJ).PRODUCTO_ID,Ln_idCaracteristicaNa,Pcl_arrayPlanDet(Ln_IteradorJ).ID_ITEM);
                        FETCH C_GET_PRODUCTO_CARACT INTO Lv_ValorProducCaractNa;
                        CLOSE C_GET_PRODUCTO_CARACT;

                        IF Lv_ValorProducCaractNa IS NOT NULL
                        THEN
                            Pcl_ResponseList.VEL_NAC_MAX        := ROUND(Lv_ValorProducCaractNa/1000,1);
                            Pcl_ResponseList.VEL_NAC_MIN        := ROUND((ROUND(Lv_ValorProducCaractNa/1000,1))/2,1);
                        END IF;

                        OPEN C_GET_PRODUCTO_CARACT (Pcl_arrayPlanDet(Ln_IteradorJ).PRODUCTO_ID,Ln_idCaracteristicaIn,Pcl_arrayPlanDet(Ln_IteradorJ).ID_ITEM);
                        FETCH C_GET_PRODUCTO_CARACT INTO Lv_ValorProducCaractInt;
                        CLOSE C_GET_PRODUCTO_CARACT;

                        IF Lv_ValorProducCaractInt IS NOT NULL
                        THEN
                            Pcl_ResponseList.VEL_INT_MAX        := ROUND(Lv_ValorProducCaractInt/1000,1);
                            Pcl_ResponseList.VEL_INT_MIN        := ROUND((ROUND(Lv_ValorProducCaractInt/1000,1))/2,1);
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
                   Lv_JsonServiciosContratados := Lv_JsonServiciosContratados || '"INTERNET":{"CANTIDAD":"'||Ln_CantidadProducto||'","PRECIO":"'||Ln_total_servicio||'"},';
                   Ln_total_servicio := 0;
                   Lv_internet := 'N';
                --ELSE
                 --  Lv_JsonServiciosContratados := Lv_JsonServiciosContratados || '"OTROS":{"CANTIDAD":"'||Ln_CantidadProducto||'","PRECIO":"'||Ln_total_servicio||'"},';
                  -- Lv_internet := 'N';
                  -- Ln_SubTotal := 0;
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
                      Lv_FuncionPrecio := REPLACE(UPPER(Lv_FuncionPrecio),'[" '||UPPER(Pcl_arrayServCaract(Ln_IteradorJ).DESCRIPCION_CARACTERISTICA)||' "]',' '||REPLACE(UPPER(Pcl_arrayServCaract(Ln_IteradorJ).VALOR)||' ', '"',''));                      
                      Lv_FuncionPrecio := REPLACE(UPPER(Lv_FuncionPrecio),'['||UPPER(Pcl_arrayServCaract(Ln_IteradorJ).DESCRIPCION_CARACTERISTICA)||']',' '''||REPLACE(UPPER(Pcl_arrayServCaract(Ln_IteradorJ).VALOR)||''' ', '"',''));
                      Ln_IteradorJ := Pcl_arrayServCaract.NEXT(Ln_IteradorJ);
                    END LOOP;
                END IF;


                IF Lv_FuncionPrecio NOT LIKE Lv_VariableIf THEN
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'PRECIO=','');

                  Lv_FuncionPrecio      := ' SELECT ' || Lv_FuncionPrecio || ' from dual ';
                ELSE
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'ELSE IF','WHEN'); 
                  Lv_FuncionPrecio      := REPLACE(  Lv_FuncionPrecio, 'IF','WHEN');  
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

                   IF Lv_FuncionPrecio LIKE Lv_VariableBusqueda THEN
                       Pv_Mensaje := 'La función precio del servicio no tiene la caracteristica del producto.';
                       RAISE Le_Errors;     
                   END IF;


                  Lv_FuncionPrecio      := ' SELECT CASE ' || Lv_FuncionPrecio || ' END from dual '; 
                END IF;

                EXECUTE IMMEDIATE Lv_FuncionPrecio INTO Lv_PrecioProducto;

                Lv_DigitoVerificacion := SUBSTR(Lv_PrecioProducto||'',-1,1);                

                Ln_SubTotal := Ln_SubTotal + Lv_PrecioProducto;                            
                Ln_SubTotalProd := Ln_SubTotalProd + Lv_PrecioProducto;

                Ln_IteradorJ := Pcl_arrayParametrosEmpr.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL)
                LOOP                                    
                   IF Pcl_arrayParametrosEmpr(Ln_IteradorJ).VALOR1 = Pcl_arrayServicio(Ln_IteradorI).CODIGO_PRODUCTO
                   THEN
                     IF Lv_Tipo = 'AS'
                     THEN
                        Lv_NombreTecnicoServ := Pcl_arrayParametrosEmpr(Ln_IteradorJ).VALOR2;
                     ELSE
                        Lv_NombreTecnicoServ := Pcl_arrayParametrosEmpr(Ln_IteradorJ).VALOR5;
                     END IF;
                   END IF;
                   Ln_IteradorJ := Pcl_arrayServCaract.NEXT(Ln_IteradorJ);
                END LOOP;

               IF Lv_NombreTecnicoServ IS NULL
                THEN
                    Lv_NombreTecnicoServ := Pcl_arrayServicio(Ln_IteradorI).NOMBRE_TECNICO;
               END IF;  

               IF (Pcl_arrayServicio.COUNT > Ln_IteradorI )THEN
                    Ln_IteradorJ := Pcl_arrayParametrosEmpr.FIRST;
                    WHILE (Ln_IteradorJ IS NOT NULL)
                    LOOP                                       
                       IF Pcl_arrayParametrosEmpr(Ln_IteradorJ).VALOR1 = Pcl_arrayServicio(Ln_IteradorI+1).CODIGO_PRODUCTO
                       THEN
                         IF Lv_Tipo = 'AS'
                         THEN
                            Lv_NombreProdPosterior := Pcl_arrayParametrosEmpr(Ln_IteradorJ).VALOR2;
                         ELSE
                            Lv_NombreProdPosterior := Pcl_arrayParametrosEmpr(Ln_IteradorJ).VALOR5;
                         END IF;
                       END IF;
                       Ln_IteradorJ := Pcl_arrayServCaract.NEXT(Ln_IteradorJ);
                    END LOOP;
                    IF Lv_NombreProdPosterior IS NULL
                    THEN
                        Lv_NombreProdPosterior := Pcl_arrayServicio(Ln_IteradorI+1).NOMBRE_TECNICO;
                    END IF; 
                END IF;

                OPEN C_OBTENER_IMPUESTO (Pcl_arrayServicio(Ln_IteradorI).PRODUCTO_ID);
                FETCH C_OBTENER_IMPUESTO INTO Ln_PorcentajeImps;
                CLOSE C_OBTENER_IMPUESTO;

                IF Ln_PorcentajeImps IS NOT NULL
                THEN
                    Ln_Impuesto   := Ln_Impuesto + ((Lv_PrecioProducto)* (Ln_PorcentajeImps/100));
                END IF;

                Pcl_ResponseList.NOMBRE_PLAN := Lv_NombrePlan;

                Ln_CantidadProducto    := Ln_CantidadProducto + 1;
                Ln_CantidadProductoTec := Ln_CantidadProductoTec + 1;

                IF (Lv_NombreTecnicoServ != Lv_NombreProdPosterior OR Pcl_arrayServicio.COUNT = Ln_IteradorI) THEN
                    Lv_JsonServiciosContratados := Lv_JsonServiciosContratados || '"'||Lv_NombreTecnicoServ||'": {"CANTIDAD":"'||Ln_CantidadProductoTec||'","PRECIO":"'||trim(to_char(Ln_SubTotalProd,'99,999,999,990.99'))||'"},';
                    Ln_SubTotalProd        := 0; 
                    Ln_CantidadProductoTec := 0;
                END IF;

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

    Lv_JsonProdParametros := '[';

    --json 
    Ln_IteradorI := Pcl_arrayParametrosEmpr.FIRST;

    WHILE (Ln_IteradorI IS NOT NULL)
    LOOP
        Lv_JsonProdParametros := Lv_JsonProdParametros || '{' ||
                                 '"VALOR1" : "' || Pcl_arrayParametrosEmpr(Ln_IteradorI).VALOR1 || '",'||
                                 '"VALOR2" : "' || Pcl_arrayParametrosEmpr(Ln_IteradorI).VALOR2 || '",'||
                                 '"VALOR3" : "' || Pcl_arrayParametrosEmpr(Ln_IteradorI).VALOR3 || '",'||
                                 '"VALOR4" : "' || Pcl_arrayParametrosEmpr(Ln_IteradorI).VALOR4 || '",'||
                                 '"VALOR5" : "' || Pcl_arrayParametrosEmpr(Ln_IteradorI).VALOR5 || '"},';                                        

      Ln_IteradorI := Pcl_arrayParametrosEmpr.NEXT(Ln_IteradorI);
    END LOOP;

    Lv_JsonProdParametros := substr(Lv_JsonProdParametros, 0, length(Lv_JsonProdParametros)-1) || '';

    Lv_JsonProdParametros := Lv_JsonProdParametros || ']';            

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
                Pcl_ResponseList.VEL_NAC_MAX||''' VEL_NAC_MAX, '''||
                Pcl_ResponseList.VEL_NAC_MIN||''' VEL_NAC_MIN, '''||
                Pcl_ResponseList.VEL_INT_MAX||''' VEL_INT_MAX, '''||
                Pcl_ResponseList.VEL_INT_MIN||''' VEL_INT_MIN, '''||
                Pcl_ResponseList.DESC_PLAN||''' DESC_PLAN, '''||
                Pcl_ResponseList.MESES_DESC||''' MESES_DESC, '''||
                Pcl_ResponseList.IMPUESTOS||''' IMPUESTOS, '''||
                Pcl_ResponseList.TOTAL||''' TOTAL, '''||
                Pcl_ResponseList.VALOR_PLAN_DESC||''' VALOR_PLAN_DESC, '''||
                Pcl_ResponseList.IS_PRECIO_PROMO||''' IS_PRECIO_PROMO, '''||
                Lv_JsonProdParametros||''' ARRAY_PROD_PARAMETROS, '''||
                Lv_JsonServiciosContratados||''' ARRAY_SERV_CONTRATADOS, '''||
                Pcl_ResponseList.NOMBRE_PLAN||''' NOMBRE_PLAN FROM DUAL';                            

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

end CMKG_CONSULTA;

/
