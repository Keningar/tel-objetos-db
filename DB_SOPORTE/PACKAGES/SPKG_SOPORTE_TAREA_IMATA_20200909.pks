SET DEFINE OFF;
create or replace package                                      DB_SOPORTE.SPKG_SOPORTE_TAREA IS

 /**
  * Documentación para el procedimiento P_TAREA_EMPLEADO
  *
  * Método encargado de consultar mediante el numero de tarea la tarea y los empleados asociados a la  tarea.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   numeroTarea    := número de tarea
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                              
   PROCEDURE P_TAREA_EMPLEADO(Pcl_Request  IN  CLOB,
                              Pv_Status    OUT VARCHAR2,
                              Pv_Mensaje   OUT VARCHAR2,
                              Pcl_Response OUT SYS_REFCURSOR);

END SPKG_SOPORTE_TAREA;
/
create or replace package body                                DB_SOPORTE.SPKG_SOPORTE_TAREA IS

   PROCEDURE P_TAREA_EMPLEADO(Pcl_Request  IN  CLOB,
                              Pv_Status    OUT VARCHAR2,
                              Pv_Mensaje   OUT VARCHAR2,
                              Pcl_Response OUT SYS_REFCURSOR) 
                              
   AS
      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_NumeroTarea         VARCHAR2(30);
      Lv_EmpresaCod          VARCHAR2(2);
      Lv_NombreDepartamento  VARCHAR2(50);
      Lv_Nombres             VARCHAR2(50);
      Le_Errors              EXCEPTION;
   
   
   BEGIN 
   
      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Lv_NumeroTarea         :=  APEX_JSON.get_varchar2(p_path => 'numeroTarea');
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');
      Lv_NombreDepartamento  :=  APEX_JSON.get_varchar2(p_path => 'nombreDpto');
      Lv_Nombres             :=  APEX_JSON.get_varchar2(p_path => 'nombres');
   
      Lcl_Select       :=  '
                     SELECT DISTINCT IP.IDENTIFICACION_CLIENTE IDENTIFICACION, VEE.NOMBRE NOMBRES,ATA.NOMBRE_TAREA,ATA.ESTADO ESTADO_TAREA,
                            VEE.NO_EMPLE,VEE.MAIL_CIA, VEE.NOMBRE_DEPTO DEPARTAMENTO,ICO.ID_COMUNICACION NUMERO_TAREA  ';
   
   
      Lcl_From         :=   ' 
                     FROM DB_COMUNICACION.INFO_COMUNICACION ICO ';
      
      Lcl_WhereAndJoin := '  
                     JOIN DB_SOPORTE.INFO_DETALLE IDE ON IDE.ID_DETALLE = ICO.DETALLE_ID
                     JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
                     JOIN DB_SOPORTE.ADMI_TAREA ATA ON ATA.ID_TAREA = IDE.TAREA_ID
                     JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL= IDA.PERSONA_EMPRESA_ROL_ID
                     JOIN DB_COMERCIAL.INFO_PERSONA IP ON IP.ID_PERSONA = IPER.PERSONA_ID
                     JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.LOGIN_EMPLE = IP.LOGIN 
                     WHERE ICO.ID_COMUNICACION='||Lv_NumeroTarea||'
                     AND VEE.NO_CIA='''||Lv_EmpresaCod||''' AND VEE.NOMBRE_DEPTO = '''||Lv_NombreDepartamento||''' ';
      
      
      IF Lv_Nombres IS NOT NULL THEN
      
         Lcl_WhereAndJoin := Lcl_WhereAndJoin ||' AND VEE.NOMBRE='''||Lv_Nombres||''' ' ;
         
      END IF;
      
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
      
   
   END P_TAREA_EMPLEADO;
   
END SPKG_SOPORTE_TAREA;
/
