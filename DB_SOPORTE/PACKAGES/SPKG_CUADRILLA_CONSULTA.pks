CREATE OR REPLACE package DB_SOPORTE.SPKG_CUADRILLA_CONSULTA IS

      /**
  * Documentaci�n para el procedimiento P_EMPLEADO_CUADRILLA
  *
  * M�todo encargado de buscar empleados por cuadrilla
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   empresaCod              := id de la empresa
  *   nombreEmpleado          := nombre del empleado
  *   nombreCuadrilla         := nombre de la cuadrilla
  *   nombreDepartamento      := nombre del departamento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci�n
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 23-09-2020
  */                              
  PROCEDURE P_EMPLEADO_CUADRILLA(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);
                                 
               
  /**
  * Documentaci�n para el procedimiento P_LISTADO_CUADRILLAS
  *
  * M�todo que retorna el listado de cuadrillas.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   empresaCod         := id de la empresa
  *   nombreDpto         := nombre del departamento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci�n
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 20-10-2020
  */                  
  PROCEDURE P_LISTADO_CUADRILLAS(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);
                              
END SPKG_CUADRILLA_CONSULTA;
/
CREATE OR REPLACE package body DB_SOPORTE.SPKG_CUADRILLA_CONSULTA is

  PROCEDURE P_EMPLEADO_CUADRILLA(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT SYS_REFCURSOR)
                                 
  AS
  
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lv_EmpresaCod          VARCHAR2(2);
    Lv_NombreDepartamento  VARCHAR2(50);
    Lv_NombreCuadrilla     VARCHAR2(50);
    Lv_NombreEmpleado      VARCHAR2(50);
    Lv_idCuadrilla         NUMBER;
    Le_Errors              EXCEPTION;
  
  BEGIN
    
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_NombreDepartamento  := APEX_JSON.get_varchar2(p_path => 'nombreDpto');
    Lv_NombreCuadrilla     := APEX_JSON.get_varchar2(p_path => 'nombreCuadrilla');
    Lv_NombreEmpleado      := APEX_JSON.get_varchar2(p_path => 'nombreEmpleado');
    Lv_idCuadrilla         := APEX_JSON.get_number(p_path => 'idCuadrilla');
    
    
    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El par�metro empresaCod est� vac�o';
       RAISE Le_Errors;
    END IF;
    
    IF Lv_NombreDepartamento IS NULL THEN
       Pv_Mensaje := 'El par�metro nombreDpto est� vac�o';
       RAISE Le_Errors;
    END IF;
  
  
  
    Lcl_Select       := '
              SELECT VEE.NO_EMPLE,IP.IDENTIFICACION_CLIENTE,VEE.NOMBRE,VEE.MAIL_CIA,AC.ID_CUADRILLA,VEE.OFICINA_PROVINCIA,VEE.OFICINA_CANTON ';
          
    Lcl_From         := '
              FROM DB_COMERCIAL.INFO_PERSONA IP  ';
              
    Lcl_WhereAndJoin := '
              JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.PERSONA_ID = IP.ID_PERSONA 
              JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
              JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.LOGIN_EMPLE = IP.LOGIN
              JOIN DB_COMERCIAL.ADMI_CUADRILLA AC ON AC.ID_CUADRILLA = IPER.CUADRILLA_ID
              WHERE IPER.ESTADO=''Activo'' AND IP.ESTADO=''Activo'' AND IER.EMPRESA_COD='''||Lv_EmpresaCod||'''
              AND VEE.NOMBRE_DEPTO='''||Lv_NombreDepartamento||''' AND VEE.ESTADO=''A'' AND AC.ESTADO IN(''Activo'',''Prestado'') ';
              
    IF Lv_NombreCuadrilla IS NOT NULL THEN
      
      Lcl_WhereAndJoin := Lcl_WhereAndJoin|| ' AND AC.NOMBRE_CUADRILLA='''||Lv_NombreCuadrilla||''' ';
    
    END IF;
    
    IF Lv_idCuadrilla IS NOT NULL THEN
      
      Lcl_WhereAndJoin := Lcl_WhereAndJoin|| ' AND AC.ID_CUADRILLA='||Lv_idCuadrilla||' ';
    
    END IF;
    
    IF Lv_NombreEmpleado IS NOT NULL THEN
     
        Lcl_WhereAndJoin := Lcl_WhereAndJoin|| ' AND VEE.NOMBRE='''||Lv_NombreEmpleado||''' ';
    
    END IF;
              
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;
    
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacci�n exitosa';
  
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      
  END P_EMPLEADO_CUADRILLA;
  
  PROCEDURE P_LISTADO_CUADRILLAS(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT SYS_REFCURSOR)
                               
  
  AS
  
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin       CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lv_EmpresaCod          VARCHAR2(2);
    Lv_NombreDepartamento  VARCHAR2(50);
    Le_Errors              EXCEPTION;
  
  BEGIN
  
  -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_NombreDepartamento  := APEX_JSON.get_varchar2(p_path => 'nombreDpto');
    
  
    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El par�metro empresaCod est� vac�o';
       RAISE Le_Errors;
    END IF;
    
    IF Lv_NombreDepartamento IS NULL THEN
       Pv_Mensaje := 'El par�metro nombreDpto est� vac�o';
       RAISE Le_Errors;
    END IF;
    
    Lcl_Select       := '
              SELECT AC.ID_CUADRILLA, AC.NOMBRE_CUADRILLA ';
          
    Lcl_From         := '
              FROM DB_COMERCIAL.ADMI_CUADRILLA AC  ';
              
    Lcl_WhereAndJoin := '
              JOIN DB_GENERAL.ADMI_DEPARTAMENTO AD ON AC.DEPARTAMENTO_ID = AD.ID_DEPARTAMENTO
              WHERE AC.ESTADO IN(''Activo'',''Prestado'') AND UPPER(AD.NOMBRE_DEPARTAMENTO)='''||Lv_NombreDepartamento||''' AND AD.EMPRESA_COD='''||Lv_EmpresaCod||''' ';
    
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;
    
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacci�n exitosa';
  
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  
  END P_LISTADO_CUADRILLAS;

END SPKG_CUADRILLA_CONSULTA;
/