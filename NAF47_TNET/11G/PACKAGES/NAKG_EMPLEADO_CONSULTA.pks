CREATE OR REPLACE package            NAKG_EMPLEADO_CONSULTA is

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
  * Documentación para el procedimiento P_INFORMACION_EMPLEADO_LOGIN
  *
  * Método encargado de retornar la lista de elementos por tipo.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   login              := Login empleado,
  *     
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author William Sanchez  <wdsanchez@telconet.ec>
  * @version 1.0 01-03-2022
  *
  *
  */
  PROCEDURE P_INFORMACION_EMPLEADO_LOGIN(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR); 
                                  
                
  
   /**
  * Documentación para el procedimiento P_UPDATE_INFO_MEDIOS
  *
  * Método actualizar  medios correo,celular personal empleado.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   login              := Login empleado,
  *   companyCode        := codigo empresa,
  *   mail		 := mail personal,
  *   cellphone  	 := celular personal	
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción

  *
  * @author William Sanchez  <wdsanchez@telconet.ec>
  * @version 1.0 06-04-2022
  *
  *
  */
   PROCEDURE P_UPDATE_INFO_MEDIOS(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2); 
  
  
  
  
  
  

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


CREATE OR REPLACE package body            NAKG_EMPLEADO_CONSULTA is

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
  
   PROCEDURE P_INFORMACION_EMPLEADO_LOGIN(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR)
                                   
    AS 
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_WhereAndJoin1       CLOB;
    Lcl_WhereAndJoin2       CLOB;
    Lcl_WhereAndJoin3       CLOB;
    Lcl_WhereAndJoin4       CLOB;
    Lcl_WhereAndJoin5       CLOB;
    Lcl_WhereAndJoin6       CLOB;
    Lcl_WhereAndJoin7       CLOB;
    Lcl_WhereAndJoin8       CLOB;
    Lcl_WhereAndJoin9       CLOB;
    Lcl_WhereAndJoin10      CLOB;
    Lcl_WhereAndJoin11      CLOB;
    Lcl_WhereAndJoin12      CLOB;
    Lcl_WhereAndJoin13      CLOB;
    
    
    Lcl_OrderAnGroup       CLOB;
    Lv_Cadena              VARCHAR2(200);
    Lv_Cadena2             VARCHAR2(200);
    Lv_LoginEmple          VARCHAR2(4000); 
    Lv_RazonSocial         VARCHAR2(4000);
    Lv_Departamento        VARCHAR2(4000);
    Lv_Cargo               VARCHAR2(4000);
    Lv_Region              VARCHAR2(4000);
    Lv_Ciudad              VARCHAR2(4000);
    Lv_Provincia           VARCHAR2(4000);
    Lv_nombres             VARCHAR2(4000);
    Lv_apellidos           VARCHAR2(4000);
    Lv_celular             VARCHAR2(4000);
    Lv_correo              VARCHAR2(4000);
    Lv_EmpresaCod          VARCHAR2(4000);
    Le_Errors              EXCEPTION;
    
  

  BEGIN
  
    --DBMS_OUTPUT.PUT_LINE('REQUEST ' ||Pcl_Request);
      -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
  

   -- APEX_JSON.
   
    Lv_LoginEmple  := APEX_JSON.get_varchar2(p_path => 'login'); 
    Lv_RazonSocial  := APEX_JSON.get_varchar2(p_path => 'businessName');
    Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'companyCode'); 
    Lv_Departamento  := APEX_JSON.get_varchar2(p_path => 'department'); 
    Lv_Cargo  := APEX_JSON.get_varchar2(p_path => 'position');
    Lv_Region  := APEX_JSON.get_varchar2(p_path => 'region');
    Lv_Ciudad  := APEX_JSON.get_varchar2(p_path => 'city');
    Lv_Provincia  := APEX_JSON.get_varchar2(p_path => 'state');
    Lv_Nombres := APEX_JSON.get_varchar2(p_path => 'name');
    Lv_Apellidos := APEX_JSON.get_varchar2(p_path => 'lastName');
    Lv_celular := APEX_JSON.get_varchar2(p_path => 'cellphone');
    
    Lv_Correo := APEX_JSON.get_varchar2(p_path => 'mail');
    
    


    

    Lcl_Select       := '
               SELECT VEE.*, 
               (VEE.NOMBRE_PILA||'' ''||VEE.NOMBRE_SEGUNDO) NOMBRES,
               (VEE.APE_PAT||'' ''||VEE.APE_MAT) APELLIDOS,
          nvl ((
        SELECT
            elem.nombre_elemento
        FROM
            db_comercial.info_persona                infp,
            db_comercial.info_persona_empresa_rol    infprol,
            db_comercial.info_empresa_rol            emprol,
            db_general.admi_rol                      admrol,
            db_general.admi_tipo_rol                 admrolt,
            db_infraestructura.info_detalle_elemento detelem,
            db_infraestructura.info_elemento         elem,
            naf47_tnet.v_empleados_empresas          emple
        WHERE
             infp.id_persona = infprol.persona_id
            AND infprol.estado = ''Activo''
            AND emprol.id_empresa_rol = infprol.empresa_rol_id
            AND emprol.estado IN ( ''Activo'', ''Modificado'' )
            AND admrol.id_rol = emprol.rol_id
            AND admrol.estado IN ( ''Activo'', ''Modificado'' )
            AND admrolt.id_tipo_rol = admrol.tipo_rol_id
            AND admrolt.estado = ''Activo''
            AND detelem.detalle_valor = infprol.id_persona_rol
            AND detelem.estado = ''Activo''
            AND detelem.detalle_nombre = ''COLABORADOR''
            AND elem.id_elemento = detelem.elemento_id
            AND elem.estado = ''Activo''
            AND emple.login_emple = infp.login
            AND emple.estado = ''A''
            AND emple.no_emple = vee.no_emple
            AND ROWNUM < 2
    ),'''')     CELULAR_CIA ,
              EMP.RAZON_SOCIAL NOMBRE_EMPRESA, 
                     (
              SELECT MAIL 
                FROM ARPLME 
               WHERE NO_CIA = VEE.NO_CIA_JEFE
                 AND NO_EMPLE =  VEE.ID_JEFE 
                 AND ESTADO = ''A''
              ) MAIL_JEFE,
                (
              SELECT MAIL_CIA
                FROM ARPLME 
               WHERE NO_CIA = VEE.NO_CIA_JEFE
                 AND NO_EMPLE =  VEE.ID_JEFE 
                 AND ESTADO = ''A''
              ) MAIL_JEFE_CIA,
              (
                  SELECT CELULAR
                    FROM ARPLME 
                   WHERE NO_CIA = VEE.NO_CIA_JEFE
                     AND NO_EMPLE =  VEE.ID_JEFE 
                     AND ESTADO = ''A''
              ) CELULAR_JEFE,
               nvl ((
        SELECT
            elem.nombre_elemento
        FROM
            db_comercial.info_persona                infp,
            db_comercial.info_persona_empresa_rol    infprol,
            db_comercial.info_empresa_rol            emprol,
            db_general.admi_rol                      admrol,
            db_general.admi_tipo_rol                 admrolt,
            db_infraestructura.info_detalle_elemento detelem,
            db_infraestructura.info_elemento         elem,
            naf47_tnet.v_empleados_empresas          emple
        WHERE
                infp.id_persona = infprol.persona_id
            AND infprol.estado = ''Activo''
            AND emprol.id_empresa_rol = infprol.empresa_rol_id
            AND emprol.estado IN ( ''Activo'', ''Modificado'' )
            AND admrol.id_rol = emprol.rol_id
            AND admrol.estado IN ( ''Activo'', ''Modificado'' )
            AND admrolt.id_tipo_rol = admrol.tipo_rol_id
            AND admrolt.estado = ''Activo''
            AND detelem.detalle_valor = infprol.id_persona_rol
            AND detelem.estado = ''Activo''
            AND detelem.detalle_nombre = ''COLABORADOR''
            AND elem.id_elemento = detelem.elemento_id
            AND elem.estado = ''Activo''
            AND emple.login_emple = infp.login
            AND emple.estado = ''A''
            AND emple.no_emple = vee.id_jefe
            AND ROWNUM < 2
    ),'''')     CELULAR_JEFE_CIA
             ';
    
    
    Lcl_From         := '
              FROM  NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE, 
                    NAF47_TNET.ARCGMC EMP 
                    WHERE VEE.ESTADO=''A''
                    AND VEE.NO_CIA = EMP.NO_CIA
                    AND VEE.LOGIN_EMPLE IS NOT NULL  ';

    IF Lv_LoginEmple IS NOT NULL THEN  
    Lcl_WhereAndJoin1 := 'AND (UPPER(VEE.LOGIN_EMPLE) in ('||Lv_LoginEmple||') OR  UPPER(VEE.CEDULA) in ('||Lv_LoginEmple||') )' ;
    END IF;   
    
    IF Lv_Departamento IS NOT NULL THEN
    Lcl_WhereAndJoin2 := ' AND REPLACE(UPPER(VEE.NOMBRE_DEPTO),'' '','''') IN ('||Lv_Departamento||')' ;
    END IF;  
    
    IF Lv_EmpresaCod IS NOT NULL THEN
    Lcl_WhereAndJoin3 := ' AND REPLACE(VEE.NO_CIA,'' '','''') IN ('||Lv_EmpresaCod||')' ;
    END IF;  
    
    
    IF Lv_RazonSocial IS NOT NULL THEN
      Lcl_WhereAndJoin4 := ' AND instr(REPLACE(UPPER(EMP.RAZON_SOCIAL),'' '',''''),'||Lv_RazonSocial||')>0' ;
    END IF;  
    
    IF Lv_Cargo IS NOT NULL THEN
    Lcl_WhereAndJoin5 := ' AND UPPER(TRANSLATE(REPLACE(VEE.DESCRIPCION_CARGO,'' '',''''),''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu'')) IN ('||Lv_Cargo||')' ;
    END IF;  
    
    IF Lv_Region IS NOT NULL THEN
    Lcl_WhereAndJoin6 := ' AND REPLACE(UPPER(VEE.IND_REGION),'' '','''') IN ('||Lv_Region||')' ;
    END IF;  
    
    IF Lv_Ciudad IS NOT NULL THEN
    Lcl_WhereAndJoin7 := ' AND REPLACE(UPPER(VEE.OFICINA_CANTON),'' '','''') IN ('||Lv_Ciudad||')' ;
    END IF;  
    
    
    IF Lv_Provincia IS NOT NULL THEN
    Lcl_WhereAndJoin8 := ' AND REPLACE(UPPER(VEE.OFICINA_PROVINCIA),'' '','''') IN ('||Lv_Provincia||')' ;
    END IF;  
    
    
    IF Lv_Nombres IS NOT NULL THEN
    Lcl_WhereAndJoin9 := ' AND TRANSLATE(REPLACE((UPPER(VEE.NOMBRE_PILA||'' ''||VEE.NOMBRE_SEGUNDO)),'' '',''''),''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu'') IN ('||Lv_Nombres||')' ;
    END IF;  
    
    IF Lv_Apellidos IS NOT NULL THEN
    Lcl_WhereAndJoin10 := ' AND TRANSLATE(REPLACE(UPPER(VEE.APE_PAT||'' ''||VEE.APE_MAT),'' '',''''),''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu'') IN ('||Lv_Apellidos||')' ;
    END IF;  
    
    IF Lv_Correo IS NOT NULL THEN
    Lcl_WhereAndJoin11 := ' AND REPLACE(UPPER(VEE.MAIL_CIA),'' '','''') IN ('||Lv_Correo||')' ;
    END IF; 
    
     IF Lv_Cargo IS NOT NULL THEN
    Lcl_WhereAndJoin12 := ' AND REPLACE(UPPER(VEE.DESCRIPCION_CARGO),'' '','''') IN ('||Lv_Cargo||')' ;
    END IF; 
    
   IF Lv_Celular IS NOT NULL THEN   
     Lcl_WhereAndJoin13  := 'AND VEE.no_emple in (
                    SELECT
           emple.no_emple
        FROM
            db_comercial.info_persona                infp,
            db_comercial.info_persona_empresa_rol    infprol,
            db_comercial.info_empresa_rol            emprol,
            db_general.admi_rol                      admrol,
            db_general.admi_tipo_rol                 admrolt,
            db_infraestructura.info_detalle_elemento detelem,
            db_infraestructura.info_elemento         elem,
            naf47_tnet.v_empleados_empresas          emple
        WHERE
             infp.id_persona = infprol.persona_id
            AND infprol.estado = ''Activo''
            AND emprol.id_empresa_rol = infprol.empresa_rol_id
            AND emprol.estado IN ( ''Activo'', ''Modificado'' )
            AND admrol.id_rol = emprol.rol_id
            AND admrol.estado IN ( ''Activo'', ''Modificado'' )
            AND admrolt.id_tipo_rol = admrol.tipo_rol_id
            AND admrolt.estado = ''Activo''
            AND detelem.detalle_valor = infprol.id_persona_rol
            AND detelem.estado = ''Activo''
            AND detelem.detalle_nombre = ''COLABORADOR''
            AND elem.id_elemento = detelem.elemento_id
            AND elem.estado = ''Activo''
            AND emple.login_emple = infp.login
            AND emple.estado = ''A''
            AND elem.nombre_elemento  IN ('||Lv_Celular||') 
            AND ROWNUM < 2)'; 
   END IF; 

    Lcl_OrderAnGroup := ' ORDER BY VEE.NOMBRE ASC ';
    Lcl_Query := Lcl_Select || Lcl_From 
                            || Lcl_WhereAndJoin1 
                            || Lcl_WhereAndJoin2 
                            || Lcl_WhereAndJoin3 
                            || Lcl_WhereAndJoin4 
                            || Lcl_WhereAndJoin6 
                            || Lcl_WhereAndJoin7 
                            || Lcl_WhereAndJoin8 
                            || Lcl_WhereAndJoin9
                            || Lcl_WhereAndJoin10
                            || Lcl_WhereAndJoin11
                            || Lcl_WhereAndJoin12
                            || Lcl_WhereAndJoin13
                            || Lcl_OrderAnGroup;

   --DBMS_OUTPUT.PUT_LINE('Query ' ||Lcl_Query);

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
    
  EXCEPTION
    WHEN Le_Errors THEN
     Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_INFORMACION_EMPLEADO_LOGIN;  
  
  
  
  
  
  
  PROCEDURE P_UPDATE_INFO_MEDIOS(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2)
    AS 
    Lv_LoginEmple          VARCHAR2(200);
    Lv_EmpresaCod          VARCHAR2(200);
    Lv_mail                VARCHAR2(200);
    Lv_phone               VARCHAR2(200);
    Le_Errors              EXCEPTION;
    BEGIN
    
      APEX_JSON.PARSE(Pcl_Request);
      
      
      --
    Lv_LoginEmple  := APEX_JSON.get_varchar2(p_path => 'login'); 
    Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'companyCode'); 
    Lv_mail  := APEX_JSON.get_varchar2(p_path => 'mail'); 
    Lv_phone  := APEX_JSON.get_varchar2(p_path => 'cellphone'); 
    
    IF Lv_LoginEmple IS NULL THEN
       Pv_Mensaje := 'El parámetro login está vacío';
       RAISE Le_Errors;
    END IF;

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro EmpresaCod está vacío';
       RAISE Le_Errors;
    END IF;
    
    
    IF Lv_mail IS NULL THEN
       Pv_Mensaje := 'El parámetro mail está vacío';
       RAISE Le_Errors;
    END IF;

    IF Lv_phone IS NULL THEN
       Pv_Mensaje := 'El parámetro phone está vacío';
       RAISE Le_Errors;
    END IF;
    
    
      
       update NAF47_TNET.arplme
          set arplme.celular=Lv_phone, 
              arplme.mail=Lv_mail
         where NO_EMPLE in(
        select arplme.no_emple
          FROM NAF47_TNET.arplme, NAF47_TNET.LOGIN_EMPLEADO
         WHERE arplme.No_Cia = LOGIN_EMPLEADO.NO_CIA(+)
           AND ARPLME.NO_EMPLE = LOGIN_EMPLEADO.NO_EMPLE(+)
           AND arplme.estado = 'A'
           AND LOGIN_EMPLEADO.login = Lv_LoginEmple
           AND arplme.NO_CIA = Lv_EmpresaCod); 
      
      
    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
    
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

    END P_UPDATE_INFO_MEDIOS;
  
  
  


 
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
