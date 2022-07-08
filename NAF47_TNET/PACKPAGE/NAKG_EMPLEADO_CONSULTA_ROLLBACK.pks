SET DEFINE OFF;
create or replace package                                          NAF47_TNET.NAKG_EMPLEADO_CONSULTA is

  /**
  * Documentación para el procedimiento P_INFORMACION_EMPLEADO
  *
  * Método encargado de retornar la lista de elementos por tipo.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   cedulaEmpleado              := Cedula de empleado
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 19-06-2020
  *
  * @author Kevin Baque Puya <kbaque@telconet.ec>
  * @version 1.1 20-05-2021 - Se ordena el response.
  *
  */
  PROCEDURE P_INFORMACION_EMPLEADO(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_INFORMACION_DEPARTAMENTOS
  *
  * Método encargado de retornar la lista de departamento.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Kevin Baque Puya <kbaque@telconet.ec>
  * @version 1.0 20-05-2021
  */
  PROCEDURE P_INFORMACION_DEPARTAMENTOS(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);

END NAKG_EMPLEADO_CONSULTA;
/
create or replace package body                        NAF47_TNET.NAKG_EMPLEADO_CONSULTA is

  PROCEDURE P_INFORMACION_EMPLEADO(Pcl_Request  IN  CLOB,
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
    Lv_NombreDepartamento  := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');
    
    
    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro empresaCod está vacío';
       RAISE Le_Errors;
    END IF;
    
    IF Lv_NombreDepartamento IS NULL THEN
       Pv_Mensaje := 'El parámetro nombreDepartamento está vacío';
       RAISE Le_Errors;
    END IF;
    
    
    
    Lcl_Select       := '
              SELECT VEE.*';
          
    Lcl_From         := '
              FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ';
              
    Lcl_WhereAndJoin := '
              WHERE VEE.NO_CIA = '''||Lv_EmpresaCod||''' 
              AND VEE.ESTADO=''A'' AND VEE.NOMBRE_DEPTO='''||Lv_NombreDepartamento||''' ';
              
    Lcl_OrderAnGroup := ' ORDER BY VEE.NOMBRE ASC ';
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
              
  END P_INFORMACION_EMPLEADO;
 
  PROCEDURE P_INFORMACION_DEPARTAMENTOS(Pcl_Request  IN  CLOB,
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
    Le_Errors              EXCEPTION;
    
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro empresaCod está vacío';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := ' SELECT DEPARTAMENTO.* ';
          
    Lcl_From         := ' FROM NAF47_TNET.ARPLDP DEPARTAMENTO ';
              
    Lcl_WhereAndJoin := ' WHERE DEPARTAMENTO.NO_CIA = '''||Lv_EmpresaCod||''' 
                          AND EXISTS (
                            SELECT
                                VEMP.*
                            FROM
                                NAF47_TNET.V_EMPLEADOS_EMPRESAS VEMP
                            WHERE
                                VEMP.NO_CIA ='''||Lv_EmpresaCod||''' 
                                AND VEMP.DEPTO = DEPARTAMENTO.DEPA ) ';
    Lcl_OrderAnGroup  := ' ORDER BY DEPARTAMENTO.DESCRI ASC ';
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
              
  END P_INFORMACION_DEPARTAMENTOS;

END NAKG_EMPLEADO_CONSULTA;
/
