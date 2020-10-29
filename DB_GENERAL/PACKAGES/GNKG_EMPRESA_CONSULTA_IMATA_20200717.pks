create or replace package DB_GENERAL.GNKG_EMPRESA_CONSULTA is

  /**
  * Documentación para el procedimiento P_EMPRESA_POR
  *
  * Método encargado de retornar la lista de empresas base telcos con filtros.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   estado              := Estado Default 'Activo',
  *   ruc                 := RUC de empresa
  *   razonSocial         := Razon social de empresa
  *   nombreEmpresa       := Nombre de empresa
  *   empresaCod          := Código de empresa
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 17-07-2020
  */
  PROCEDURE P_EMPRESA_POR(Pcl_Request  IN  CLOB,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_DEPARTAMENTO_POR
  *
  * Método encargado de retornar la lista de departamentos base telcos con filtros.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   estado              := Estado,
  *   empresaCod          := Código de empresa
  *   idDepartamento      := Id departamento
  *   nombreDepartamento  := Nombre departamento
  *   areaId              := Id Area
  *   nombreArea          := Nombre area
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 17-07-2020
  */                       
  PROCEDURE P_DEPARTAMENTO_POR(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT SYS_REFCURSOR);
                               
                               
  /**
  * Documentación para el procedimiento P_CONSULTA_DEPARTAMENTOS_NAF
  *
  * Método encargado de retornar la lista de departamentos base naft con filtros
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   nocia              := codigo de Empresa,
  *   area               := id area
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 17-06-2020
  */                           
  PROCEDURE P_DEPARTAMENTOS_NAF_POR(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR);
    
                                    
  /**
  * Documentación para el procedimiento P_CONSULTA_AREAS_NAF
  *
  * Método encargado de retornar la lista de areas base naft con filtros
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   nocia              := número de compañia
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 17-06-2020
  */                            
  PROCEDURE P_AREAS_NAF_POR(Pcl_Request  IN  CLOB,
                            Pv_Status    OUT VARCHAR2,
                            Pv_Mensaje   OUT VARCHAR2,
                            Pcl_Response OUT SYS_REFCURSOR);
                            
                            
  /**
  * Documentación para el procedimiento P_PROVINCIAS
  *
  * Método encargado de retornar la lista de Provincias del naf
  *
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 17-06-2020
  */
  PROCEDURE P_PROVINCIAS_NAF_POR(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);
                         
                         
  /**
  * Documentación para el procedimiento P_CANTONES_NAF
  *
  * Método encargado de retornar la lista de cantones del naft por provincia
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   nombreProvincia              := nombre de provincia
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 17-06-2020
  */                      
  PROCEDURE P_CANTONES_NAF_POR(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT SYS_REFCURSOR);
end GNKG_EMPRESA_CONSULTA;
/
create or replace package body DB_GENERAL.GNKG_EMPRESA_CONSULTA is

PROCEDURE P_EMPRESA_POR(Pcl_Request  IN  CLOB,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lv_EmpresaCod          VARCHAR2(10);
    Lv_Estado              VARCHAR2(500);
    Lv_Ruc                 VARCHAR2(500);
    Lv_RazonSocial         VARCHAR2(100);
    Lv_NombreEmpresa       VARCHAR2(100);
    Le_Errors              EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod      := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_Estado          := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_Ruc             := APEX_JSON.get_varchar2(p_path => 'ruc');
    Lv_RazonSocial     := APEX_JSON.get_varchar2(p_path => 'razonSocial');
    Lv_NombreEmpresa   := APEX_JSON.get_varchar2(p_path => 'nombreEmpresa');
    
    -- VALIDACIONES
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    
    Lcl_Select       := '
              SELECT IEG.*';
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG';
    Lcl_WhereAndJoin := '
              WHERE IEG.ESTADO = '''||Lv_Estado||'''';
    IF Lv_EmpresaCod IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IEG.COD_EMPRESA = '''||Lv_EmpresaCod||'''';
    END IF;
    IF Lv_Ruc IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IEG.RUC = '''||Lv_Ruc||'''';
    END IF;
    IF Lv_RazonSocial IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IEG.RAZON_SOCIAL = '''||Lv_RazonSocial||'''';
    END IF;
    IF Lv_NombreEmpresa IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IEG.NOMBRE_EMPRESA = '''||Lv_NombreEmpresa||'''';
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
  END P_EMPRESA_POR;
  
  PROCEDURE P_DEPARTAMENTO_POR(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lv_EmpresaCod          VARCHAR2(10);
    Lv_Estado              VARCHAR2(500);
    Ln_IdDepartamento      NUMBER;
    Lv_NombreDepart        VARCHAR2(100);
    Ln_AreaId              NUMBER;
    Lv_NombreArea          VARCHAR2(100);
    Le_Errors              EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod      := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_Estado          := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdDepartamento  := APEX_JSON.get_number(p_path => 'idDepartamento');
    Lv_NombreDepart    := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');
    Ln_AreaId          := APEX_JSON.get_number(p_path => 'areaId');
    Lv_NombreArea      := APEX_JSON.get_varchar2(p_path => 'nombreArea');
    
    -- VALIDACIONES
    
    Lcl_Select       := '
              SELECT AD.*, AA.NOMBRE_AREA';
    Lcl_From         := '
              FROM DB_GENERAL.ADMI_DEPARTAMENTO AD,
                   DB_GENERAL.ADMI_AREA AA';
    Lcl_WhereAndJoin := '
              WHERE AD.AREA_ID = AA.ID_AREA';
    IF Lv_EmpresaCod IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.EMPRESA_COD = '''||Lv_EmpresaCod||'''';
    END IF;
    IF Lv_Estado IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.ESTADO = '''||Lv_Estado||'''';
    END IF;
    IF Ln_IdDepartamento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.ID_DEPARTAMENTO = '||Ln_IdDepartamento;
    END IF;
    IF Lv_NombreDepart IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.NOMBRE_DEPARTAMENTO = '''||Lv_NombreDepart||'''';
    END IF;
    IF Ln_AreaId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AD.AREA_ID = '||Ln_AreaId;
    END IF;
    IF Lv_NombreArea IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AA.NOMBRE_AREA = '''||Lv_NombreArea||'''';
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
  END P_DEPARTAMENTO_POR;
  
  PROCEDURE P_DEPARTAMENTOS_NAF_POR(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR)
                                    
  AS 
  
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Lv_EmpresaCod      VARCHAR2(10);
    Lv_Area            VARCHAR2(10);
    Le_Errors          EXCEPTION;
    
    
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'noCia');
    Lv_Area        := APEX_JSON.get_varchar2(p_path => 'area');
    
    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro noCia está vacío';
       RAISE Le_Errors;
    END IF;
    
    IF Lv_Area IS NULL THEN
       Pv_Mensaje := 'El parámetro area está vacío';
       RAISE Le_Errors;
    END IF;
    
    Lcl_Select       := '
              SELECT DESCRI';
          
    Lcl_From         := '
              FROM NAF47_TNET.ARPLDP ';
              
    Lcl_WhereAndJoin := '
              WHERE NO_CIA = '''||Lv_EmpresaCod||''' AND AREA='''||Lv_Area||''' ';
              
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;
                       
    
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
    
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;                                
                                    
  END P_DEPARTAMENTOS_NAF_POR;
  
  PROCEDURE P_AREAS_NAF_POR(Pcl_Request  IN  CLOB,
                            Pv_Status    OUT VARCHAR2,
                            Pv_Mensaje   OUT VARCHAR2,
                            Pcl_Response OUT SYS_REFCURSOR)
                             
                             
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_EmpresaCod     VARCHAR2(2);
    Le_Errors         EXCEPTION;
  
  
  BEGIN
  
     -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod     := APEX_JSON.get_varchar2(p_path => 'noCia');
    
    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro noCia está vacío';
       RAISE Le_Errors;
    END IF;
    
    Lcl_Select       := '
              SELECT AREA,DESCRI';
          
    Lcl_From         := '
              FROM NAF47_TNET.ARPLAR ';
              
    Lcl_WhereAndJoin := '
              WHERE NO_CIA = '''||Lv_EmpresaCod||''' ';
              
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;
    
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  
  END P_AREAS_NAF_POR;
  
  PROCEDURE P_PROVINCIAS_NAF_POR(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
    
  AS
  
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_IdPais         VARCHAR2(6);
    Le_Errors         EXCEPTION;
  
  BEGIN
  
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_IdPais  := APEX_JSON.get_varchar2(p_path => 'idPais');
  
    Lcl_Select       := '
              SELECT PROVINCIA ID_PROVINCIA, DESCRIPCION NOMBRE_PROVINCIA ';
          
    Lcl_From         := '
              FROM NAF47_TNET.ARGEPRO ';
              
    Lcl_WhereAndJoin := '
              WHERE PAIS='''||Lv_IdPais||''' ';
              
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;
    
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  
  END P_PROVINCIAS_NAF_POR;
  
  PROCEDURE P_CANTONES_NAF_POR(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT SYS_REFCURSOR)
                       
                       
  AS
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lv_NombreProvincia     VARCHAR2(25);
    Le_Errors              EXCEPTION;                     
                       
  BEGIN
  
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_NombreProvincia  := APEX_JSON.get_varchar2(p_path => 'nombreProvincia');
    
  
    Lcl_Select       := '
              SELECT DISTINCT ARCAN.CANTON ID_CANTON, ARCAN.DESCRIPCION NOMBRE_CANTON  ';
          
    Lcl_From         := '
              FROM NAF47_TNET.ARGECAN ARCAN  ';
              
    Lcl_WhereAndJoin := '
              JOIN NAF47_TNET.ARGEPRO ARPRO ON ARPRO.PROVINCIA = ARCAN.PROVINCIA
              WHERE ARCAN.PAIS=''313'' AND ARPRO.DESCRIPCION='''||Lv_NombreProvincia||''' ';
              
    
    Lcl_OrderAnGroup := ' ORDER BY ARCAN.CANTON ASC  ';
              
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;
    
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;                     
                       
  END P_CANTONES_NAF_POR;
  
end GNKG_EMPRESA_CONSULTA;
/

