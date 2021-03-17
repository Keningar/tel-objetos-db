create or replace package DB_COMERCIAL.CMKG_PERSONA_CONSULTA is
  /**
  * Documentación para el procedimiento P_PERSONA_POR_REGION
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
  PROCEDURE P_PERSONA_POR_REGION(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_PERSONA_POR_EMPRESA
  *
  * Método encargado de retornar lista de persona por empresa (COD o Prefijo)
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   prefijoEmpresa      := Prefijo de empresa,
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
  PROCEDURE P_PERSONA_POR_EMPRESA(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);
                               
  /**
  * Documentación para el procedimiento P_PERSONA_POR_ROL
  *
  * Método encargado de retornar lista de persona por rol.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   descripcionRol      := Descripcion de rol,
  *   rolId               := Id de rol,
  *   descripcionTipoRol  := Descripcion de tipo de rol,
  *   tipoRolId           := Id de tipo de rol,
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
  PROCEDURE P_PERSONA_POR_ROL(Pcl_Request  IN  CLOB,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2,
                             Pcl_Response OUT SYS_REFCURSOR);
                             
  /**
  * Documentación para el procedimiento P_PERSONA_POR_DEPARTAMENTO
  *
  * Método encargado de retornar lista de persona por departamento.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   nombreDepartamento  := Nombre de departamento,
  *   departamentoId      := Id de departamento,
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
  PROCEDURE P_PERSONA_POR_DEPARTAMENTO(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);
                                      
  /**
  * Documentación para el procedimiento P_HIS_SERVICIO_POR_FECHA
  *
  * Método encargado de retornar el historial de un servicio por un rango de fecha
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   servicioId         := Id de servicio,
  *   fechaInicio        := Fecha inicio,
  *   fechaFin           := Fecha fin
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_HIS_SERVICIO_POR_FECHA(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);
                                    
  /**
  * Documentación para el procedimiento P_INFO_USUARIO_PERSONA
  *
  * Método encargado de retornar la información adicional de una persona.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idPersona           := Id de persona,
  *   empresaId           := Id de empresa,
  *   login               := Login,
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_INFO_USUARIO_PERSONA(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR);
end CMKG_PERSONA_CONSULTA;
/
create or replace package body DB_COMERCIAL.CMKG_PERSONA_CONSULTA is
  PROCEDURE P_PERSONA_POR_REGION(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Lv_Region          VARCHAR2(100);
    Lv_Estado          VARCHAR2(500);
    Lv_Identificacion  VARCHAR2(1000);
    Lv_Login           VARCHAR2(1000);
    Ln_IdPersona       NUMBER;
    Ln_EmpresaId       NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Region         := APEX_JSON.get_varchar2(p_path => 'region');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdPersona      := APEX_JSON.get_number(p_path => 'idPersona');
    Ln_EmpresaId      := APEX_JSON.get_number(p_path => 'empresaId');
    Lv_Identificacion := APEX_JSON.get_varchar2(p_path => 'identificacion');
    Lv_Login          := APEX_JSON.get_varchar2(p_path => 'login');
    
    -- VALIDACIONES
    IF Lv_Region IS NULL THEN
      Pv_Mensaje := 'El parámetro region esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    
    Lcl_Select       := '
              SELECT IP.*';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_PERSONA IP,
                   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                   DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                   DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
                   DB_GENERAL.ADMI_CANTON AC';
    Lcl_WhereAndJoin := '
              WHERE IP.ID_PERSONA = IPER.PERSONA_ID
                AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
                AND IPER.OFICINA_ID = IOG.ID_OFICINA
                AND IOG.CANTON_ID = AC.ID_CANTON
                AND IP.ESTADO = '''||Lv_Estado||'''
                AND IPER.DEPARTAMENTO_ID IS NOT NULL
                AND IPER.ESTADO = ''Activo''
                AND IER.EMPRESA_COD = '||Ln_EmpresaId||'
                AND AC.ESTADO = ''Activo''
                AND AC.REGION = '''||Lv_Region||'''';
    IF Ln_IdPersona IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.ID_PERSONA = '||Ln_IdPersona;
    END IF;
    IF Lv_Identificacion IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.IDENTIFICACION_CLIENTE = '''||Lv_Identificacion||'''';
    END IF;
    IF Lv_Login IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.LOGIN = '''||Lv_Login||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IP.ID_PERSONA DESC';
    
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
  END P_PERSONA_POR_REGION;

  PROCEDURE P_PERSONA_POR_EMPRESA(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Lv_PrefijoEmpresa  VARCHAR2(100);
    Lv_Estado          VARCHAR2(500);
    Lv_Identificacion  VARCHAR2(1000);
    Lv_Login           VARCHAR2(1000);
    Ln_IdPersona       NUMBER;
    Ln_EmpresaId       NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_PrefijoEmpresa := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
    Ln_EmpresaId      := APEX_JSON.get_number(p_path => 'empresaId');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdPersona      := APEX_JSON.get_number(p_path => 'idPersona');
    Lv_Identificacion := APEX_JSON.get_varchar2(p_path => 'identificacion');
    Lv_Login          := APEX_JSON.get_varchar2(p_path => 'login');
    
    -- VALIDACIONES
    IF Ln_EmpresaId IS NULL AND Lv_PrefijoEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro empresaId o prefijoEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    
    Lcl_Select       := '
              SELECT IP.*';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_PERSONA IP,
                   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                   DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                   DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG';
    Lcl_WhereAndJoin := '
              WHERE IP.ID_PERSONA = IPER.PERSONA_ID
                AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
                AND IER.EMPRESA_COD = IEG.COD_EMPRESA
                AND IP.ESTADO = '''||Lv_Estado||'''
                AND IPER.DEPARTAMENTO_ID IS NOT NULL
                AND IPER.ESTADO = ''Activo''
                AND IEG.ESTADO = ''Activo''';
    IF Ln_EmpresaId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IEG.COD_EMPRESA = '||Ln_EmpresaId;
    END IF;
    IF Lv_PrefijoEmpresa IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IEG.PREFIJO = '''||Lv_PrefijoEmpresa||'''';
    END IF;
    IF Ln_IdPersona IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.ID_PERSONA = '||Ln_IdPersona;
    END IF;
    IF Lv_Identificacion IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.IDENTIFICACION_CLIENTE = '''||Lv_Identificacion||'''';
    END IF;
    IF Lv_Login IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.LOGIN = '''||Lv_Login||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IP.ID_PERSONA DESC';
    
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
  END P_PERSONA_POR_EMPRESA;

  PROCEDURE P_PERSONA_POR_ROL(Pcl_Request  IN  CLOB,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2,
                             Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query              CLOB;
    Lcl_Select         	   CLOB;
    Lcl_From           	   CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup   	   CLOB;
    Lv_DescripcionRol      VARCHAR2(100);
    Lv_DescripcionTipoRol  VARCHAR2(100);
    Lv_Estado              VARCHAR2(500);
    Lv_Identificacion      VARCHAR2(1000);
    Lv_Login               VARCHAR2(1000);
    Ln_RolId           	   NUMBER;
    Ln_TipoRolId           NUMBER;
    Ln_IdPersona           NUMBER;
    Ln_EmpresaId           NUMBER;
    Le_Errors              EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_DescripcionRol     := APEX_JSON.get_varchar2(p_path => 'descripcionRol');
    Ln_RolId              := APEX_JSON.get_number(p_path => 'rolId');
    Ln_TipoRolId          := APEX_JSON.get_number(p_path => 'tipoRolId');
    Lv_DescripcionTipoRol := APEX_JSON.get_varchar2(p_path => 'descripcionTipoRol');
    Lv_Estado             := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdPersona          := APEX_JSON.get_number(p_path => 'idPersona');
    Ln_EmpresaId          := APEX_JSON.get_number(p_path => 'empresaId');
    Lv_Identificacion     := APEX_JSON.get_varchar2(p_path => 'identificacion');
    Lv_Login              := APEX_JSON.get_varchar2(p_path => 'login');
    
    -- VALIDACIONES
    IF Ln_RolId IS NULL AND Lv_DescripcionRol IS NULL AND Ln_TipoRolId IS NULL AND Lv_DescripcionTipoRol IS NULL THEN
      Pv_Mensaje := 'El parámetro rolId o descripcionRol para rol y tipoRolId o descripcionTipoRol para tipo de rol está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    
    Lcl_Select       := '
              SELECT IP.*';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_PERSONA IP,
                   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                   DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                   DB_GENERAL.ADMI_ROL AR,
                   DB_GENERAL.ADMI_TIPO_ROL ATR';
    Lcl_WhereAndJoin := '
              WHERE IP.ID_PERSONA = IPER.PERSONA_ID
                AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
                AND IER.ROL_ID = AR.ID_ROL
                AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
                AND IP.ESTADO = '''||Lv_Estado||'''
                AND IPER.ESTADO = ''Activo''
                AND ATR.ESTADO = ''Activo''
                AND IER.EMPRESA_COD = '||Ln_EmpresaId||'';
    IF Ln_RolId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AR.ID_ROL = '||Ln_RolId;
    END IF;
    IF Lv_DescripcionRol IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AR.DESCRIPCION_ROL = '''||Lv_DescripcionRol||'''';
    END IF;
    IF Ln_TipoRolId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATR.ID_TIPO_ROL = '||Ln_TipoRolId;
    END IF;
    IF Lv_DescripcionTipoRol IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATR.DESCRIPCION_TIPO_ROL = '''||Lv_DescripcionTipoRol||'''';
    END IF;
    IF Ln_IdPersona IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.ID_PERSONA = '||Ln_IdPersona;
    END IF;
    IF Lv_Identificacion IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.IDENTIFICACION_CLIENTE = '''||Lv_Identificacion||'''';
    END IF;
    IF Lv_Login IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.LOGIN = '''||Lv_Login||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IP.ID_PERSONA DESC';
    
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
  END P_PERSONA_POR_ROL;
  
  PROCEDURE P_PERSONA_POR_DEPARTAMENTO(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lv_NombreDepartamento  VARCHAR2(100);
    Lv_Estado              VARCHAR2(500);
    Lv_Identificacion      VARCHAR2(1000);
    Lv_Login               VARCHAR2(1000);
    Ln_DepartamentoId      NUMBER;
    Ln_IdPersona           NUMBER;
    Ln_EmpresaId           NUMBER;
    Le_Errors              EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_NombreDepartamento := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');
    Ln_DepartamentoId     := APEX_JSON.get_number(p_path => 'departamentoId');
    Lv_Estado             := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdPersona          := APEX_JSON.get_number(p_path => 'idPersona');
    Ln_EmpresaId          := APEX_JSON.get_number(p_path => 'empresaId');
    Lv_Identificacion     := APEX_JSON.get_varchar2(p_path => 'identificacion');
    Lv_Login              := APEX_JSON.get_varchar2(p_path => 'login');
    
    -- VALIDACIONES
    IF Ln_DepartamentoId IS NULL AND Lv_NombreDepartamento IS NULL THEN
      Pv_Mensaje := 'El parámetro departamentoId o nombreDepartamento esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    
    Lcl_Select       := '
              SELECT IP.*';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_PERSONA IP,
                   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                   DB_COMERCIAL.ADMI_DEPARTAMENTO AD';
    Lcl_WhereAndJoin := '
              WHERE IP.ID_PERSONA = IPER.PERSONA_ID
                AND IPER.DEPARTAMENTO_ID = AD.ID_DEPARTAMENTO
                AND IP.ESTADO = '''||Lv_Estado||'''
                AND IPER.ESTADO = ''Activo''
                AND AD.ESTADO = ''Activo''
                AND AD.EMPRESA_COD = '||Ln_EmpresaId||'';
    IF Ln_DepartamentoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.ID_DEPARTAMENTO = '||Ln_DepartamentoId;
    END IF;
    IF Lv_NombreDepartamento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.NOMBRE_DEPARTAMENTO = '''||Lv_NombreDepartamento||'''';
    END IF;
    IF Ln_IdPersona IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.ID_PERSONA = '||Ln_IdPersona;
    END IF;
    IF Lv_Identificacion IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.IDENTIFICACION_CLIENTE = '''||Lv_Identificacion||'''';
    END IF;
    IF Lv_Login IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IP.LOGIN = '''||Lv_Login||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IP.ID_PERSONA DESC';
    
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
  END P_PERSONA_POR_DEPARTAMENTO;
  
  PROCEDURE P_HIS_SERVICIO_POR_FECHA(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Lv_FechaInicio     VARCHAR2(500);
    Lv_FechaFin        VARCHAR2(500);
    Ln_ServicioId      NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ServicioId     := APEX_JSON.get_number(p_path => 'servicioId');
    Lv_FechaInicio    := APEX_JSON.get_varchar2(p_path => 'fechaInicio');
    Lv_FechaFin       := APEX_JSON.get_varchar2(p_path => 'fechaFin');
    
    -- VALIDACIONES
    IF Lv_FechaInicio IS NULL THEN
      Pv_Mensaje := 'El parámetro fechaInicio esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_FechaFin IS NULL THEN
      Pv_Mensaje := 'El parámetro fechaFin esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Ln_ServicioId IS NULL THEN
      Pv_Mensaje := 'El parámetro servicioId esta vacío';
      RAISE Le_Errors;
    END IF;
    
    Lcl_Select       := '
              SELECT ISH.*';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH,
                   DB_COMERCIAL.INFO_SERVICIO IS2';
    Lcl_WhereAndJoin := '
              WHERE ISH.SERVICIO_ID = IS2.ID_SERVICIO
              AND IS2.ID_SERVICIO = '||Ln_ServicioId||'
              AND ISH.FE_CREACION BETWEEN TO_DATE('''||Lv_FechaInicio||' 00:00:00'', ''yyyy-MM-dd HH24:MI:SS'') 
              AND TO_DATE('''||Lv_FechaFin||' 23:59:59'', ''yyyy-MM-dd HH24:MI:SS'')';
    Lcl_OrderAnGroup := '
              ORDER BY
                ISH.ID_SERVICIO_HISTORIAL DESC';
    
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
  END P_HIS_SERVICIO_POR_FECHA;
  
  PROCEDURE P_INFO_USUARIO_PERSONA(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Lv_Estado          VARCHAR2(500);
    Lv_Login           VARCHAR2(1000);
    Ln_EmpresaId       NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado     := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_EmpresaId  := APEX_JSON.get_number(p_path => 'empresaId');
    Lv_Login      := APEX_JSON.get_varchar2(p_path => 'login');
    
    -- VALIDACIONES
    IF Lv_Login IS NULL THEN
      Pv_Mensaje := 'El parámetro login esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    
    Lcl_Select       := '
              SELECT IP.ID_PERSONA,
                     IPER.ID_PERSONA_ROL ID_PERSONA_EMPRESA_ROL,
                     AD.NOMBRE_DEPARTAMENTO,
                     AR.ES_JEFE';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_PERSONA IP,
                   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                   DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                   DB_COMERCIAL.ADMI_DEPARTAMENTO AD,
                   DB_GENERAL.ADMI_ROL AR';
    Lcl_WhereAndJoin := '
              WHERE IP.ID_PERSONA = IPER.PERSONA_ID
                AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
                AND IPER.DEPARTAMENTO_ID = AD.ID_DEPARTAMENTO
                AND IER.ROL_ID = AR.ID_ROL
                AND IP.ESTADO = '''||Lv_Estado||'''
                AND IPER.ESTADO = ''Activo''
                AND IER.EMPRESA_COD = '||Ln_EmpresaId||'
                AND IP.LOGIN = '''||Lv_Login||'''';
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
  END P_INFO_USUARIO_PERSONA;
end CMKG_PERSONA_CONSULTA;
/

