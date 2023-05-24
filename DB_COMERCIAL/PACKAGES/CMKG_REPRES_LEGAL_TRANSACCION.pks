CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REPRES_LEGAL_TRANSACCION  AS
 
  /**
    * Documentaci�n para P_VERIFICAR
    * VERIFICAR SI EL REPRESENTANTE LEGALE ESTA DISPONIBLE
    * 
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 22/07/2022
    */
    PROCEDURE P_VERIFICAR(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE  OUT CLOB);


    /**
    * Documentaci�n para P_CONSULTAR
    * LISTAR REPRESENTANTE LEGAL RELACIONADO A PERSONA JURIDICA
    * 
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 22/07/2022
    */
   PROCEDURE P_CONSULTAR(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE  OUT CLOB);


    /**
    * Documentaci�n para P_ACTUALIZAR
    * INSERTA Y ACTUALIZA REPRESENTANTE LEGAL RELACIONADO A PERSONA JURIDICA
    * 
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 22/07/2022
    */
   PROCEDURE P_ACTUALIZAR(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE  OUT SYS_REFCURSOR);

 
    
END CMKG_REPRES_LEGAL_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REPRES_LEGAL_TRANSACCION AS
 
PROCEDURE P_VERIFICAR(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE OUT CLOB)AS 
      
       Lv_CodEmpresa       VARCHAR2(100);  
       Lv_PrefijoEmpresa   VARCHAR2(100);   
       Lv_UsrCreacion      VARCHAR2(100);
       Lv_OrigenWeb        VARCHAR2(100);  
       Ln_IdPais           NUMBER; 

       Lv_TipoIdentificacion VARCHAR2(100);  
       Lv_Identificacion     VARCHAR2(100);  
       Lv_TipoTributario     VARCHAR2(100);  

       Lv_TipoIdentificacionRepre VARCHAR2(100);  
       Lv_IdentificacionRepre     VARCHAR2(100); 
       Lv_TipoTributarioRepre     VARCHAR2(100);   
       Lcl_ArrayJsonContacto CLOB;
       Lcl_ArrayJsonRepresentante CLOB;
 
        CURSOR C_GetPersonaRepresentante(Cv_Identificacion VARCHAR2) IS
            SELECT    
            CLI_IP.ID_PERSONA,
            CLI_IP.RAZON_SOCIAL, 
            CLI_IP.NOMBRES,
            CLI_IP.APELLIDOS,
            CLI_IP.TIPO_IDENTIFICACION,
            CLI_IP.IDENTIFICACION_CLIENTE,
            CLI_IP.CARGO,
            CLI_IP.DIRECCION,
            CLI_IP.NACIONALIDAD,
            CLI_IP.TIPO_TRIBUTARIO,  
            CLI_IP.REPRESENTANTE_LEGAL ,
            CLI_IP.ESTADO
            FROM DB_COMERCIAL.INFO_PERSONA CLI_IP  
            WHERE   ROWNUM = 1  
            AND   CLI_IP.IDENTIFICACION_CLIENTE =   Cv_Identificacion ; 
           

        CURSOR C_GetClienteRepresentante(Cv_IdentificacionCli VARCHAR2, Cv_IdentificacionRep VARCHAR2) IS
          SELECT 
          CLI_IPR.ID_PERSONA_REPRESENTANTE,
          CLI_IPR.PERSONA_EMPRESA_ROL_ID,
          CLI_IPR.REPRESENTANTE_EMPRESA_ROL_ID, 
          CLI_IPR.RAZON_COMERCIAL, 
          TO_CHAR(CLI_IPR.FE_EXPIRACION_NOMBRAMIENTO, 'DD/MM/YYYY')  AS FE_EXPIRACION_NOMBRAMIENTO, 
          TO_CHAR(CLI_IPR.FE_REGISTRO_MERCANTIL, 'DD/MM/YYYY')  AS FE_REGISTRO_MERCANTIL, 
          CLI_IPR.ESTADO,
          CLI_IPR.OBSERVACION        
          FROM DB_COMERCIAL.INFO_PERSONA CLI_IP 
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL CLI_IPER ON  CLI_IPER.PERSONA_ID  = CLI_IP.ID_PERSONA
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE CLI_IPR ON  CLI_IPR.PERSONA_EMPRESA_ROL_ID  =  CLI_IPER.ID_PERSONA_ROL
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL REP_IPER ON  REP_IPER.ID_PERSONA_ROL =  CLI_IPR.REPRESENTANTE_EMPRESA_ROL_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA   REP_IP ON REP_IP.ID_PERSONA = REP_IPER.PERSONA_ID 
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL CLI_IER ON  CLI_IER.ID_EMPRESA_ROL  = CLI_IPER.EMPRESA_ROL_ID 
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL REP_IER ON  REP_IER.ID_EMPRESA_ROL  = REP_IPER.EMPRESA_ROL_ID 
          INNER JOIN DB_COMERCIAL.ADMI_ROL  CLI_AROL ON  CLI_AROL.ID_ROL = CLI_IER.ROL_ID
          INNER JOIN DB_COMERCIAL.ADMI_ROL  REP_AROL ON  REP_AROL .ID_ROL = REP_IER.ROL_ID
          WHERE CLI_IPR.ESTADO  IN ('Activo')           
          AND   CLI_AROL.DESCRIPCION_ROL IN ('Cliente', 'Pre-cliente')
          AND   REP_AROL.DESCRIPCION_ROL IN ('Representante Legal Juridico')
          AND   CLI_IER .EMPRESA_COD = Lv_CodEmpresa 
          AND   REP_IER .EMPRESA_COD = Lv_CodEmpresa
          AND   CLI_IP.IDENTIFICACION_CLIENTE = Cv_IdentificacionCli
          AND   REP_IP.IDENTIFICACION_CLIENTE  = Cv_IdentificacionRep ; 


        CURSOR C_GetPersonaContacto(Cn_IdPersona NUMBER) IS
          SELECT 
          IPFC.ID_PERSONA_FORMA_CONTACTO,
          IPFC.FORMA_CONTACTO_ID,    
          AFC.DESCRIPCION_FORMA_CONTACTO AS FORMA_CONTACTO,
          IPFC.VALOR  
          FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC 
          INNER JOIN  DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC ON  AFC.ID_FORMA_CONTACTO = IPFC.FORMA_CONTACTO_ID
          WHERE IPFC.PERSONA_ID = Cn_IdPersona
          AND IPFC.ESTADO IN ( 'Activo'); 
          


       Pcl_DataPersona  C_GetPersonaRepresentante%ROWTYPE;       
       Pcl_DataClienteRepresentante  C_GetClienteRepresentante%ROWTYPE;


       BEGIN      
        APEX_JSON.PARSE(PCL_REQUEST);                  
        Lv_CodEmpresa        := APEX_JSON.GET_VARCHAR2(P_PATH => 'codEmpresa'); 
        Lv_PrefijoEmpresa    := APEX_JSON.GET_VARCHAR2(P_PATH => 'prefijoEmpresa'); 
        Lv_UsrCreacion       := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'); 
        Lv_OrigenWeb         := APEX_JSON.get_varchar2(p_path => 'origenWeb');
        Ln_IdPais            := APEX_JSON.get_varchar2(p_path => 'idPais');


        Lv_TipoIdentificacion              := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoIdentificacion'))); 
        Lv_Identificacion                  := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'identificacion'))); 
        Lv_TipoTributario                  := 'JUR'; 

        Lv_TipoIdentificacionRepre         := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoIdentificacionRepresentante'))); 
        Lv_IdentificacionRepre             := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'identificacionRepresentante')));  
        Lv_TipoTributarioRepre             := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoTributarioRepresentante')));   

        IF  Lv_TipoTributarioRepre != 'JUR'  OR  Lv_TipoTributarioRepre IS NULL   THEN  
            Lv_TipoTributarioRepre          :=   'NAT';
        END IF; 

        IF  Lv_TipoIdentificacion = Lv_TipoIdentificacionRepre AND Lv_Identificacion = Lv_IdentificacionRepre   THEN  
            PV_MENSAJE :='La identificaci�n del representante legal no debe ser igual que la persona jur�dica'; 
            dbms_output.put_line( PV_MENSAJE );  
            RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE );
        END IF; 


       --VALIDAMOS FORMATO DE IDENTIFICACION DE PERSONA
        DB_COMERCIAL.VALIDA_IDENTIFICACION.VALIDA(   Lv_TipoIdentificacion   ,     Lv_Identificacion ,  Lv_CodEmpresa ,    Lv_TipoTributario,  PV_MENSAJE  );        
        IF  PV_MENSAJE  IS NOT NULL THEN  
            dbms_output.put_line( PV_MENSAJE );  
            RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE );
        END IF; 

        --VALIDAMOS FORMATO DE IDENTIFICACION DE REPRESENTANTE
        DB_COMERCIAL.VALIDA_IDENTIFICACION.VALIDA(Lv_TipoIdentificacionRepre ,     Lv_IdentificacionRepre  ,  Lv_CodEmpresa ,     Lv_TipoTributarioRepre  ,  PV_MENSAJE  );        
        IF  PV_MENSAJE  IS NOT NULL THEN  
            dbms_output.put_line( PV_MENSAJE );  
            RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE );
        END IF; 


        OPEN C_GetPersonaRepresentante(Lv_IdentificacionRepre); 
         FETCH C_GetPersonaRepresentante INTO  Pcl_DataPersona ;  
        CLOSE C_GetPersonaRepresentante;  

        IF   Pcl_DataPersona.ID_PERSONA  IS  NULL THEN
             PV_MENSAJE :='La identificaci�n del representante '||Lv_IdentificacionRepre||' aun no ha sido registrada.'; 
             dbms_output.put_line( PV_MENSAJE );  
      
        ELSE
        
        IF   Pcl_DataPersona.ESTADO = 'Eliminado'  THEN
             PV_MENSAJE :='La identificaci�n del representante '||Lv_IdentificacionRepre||' ya existe pero se encuentra en estado Eliminado.'; 
             dbms_output.put_line( PV_MENSAJE );  
             RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE );
        END IF; 
         --Buscar forma de contacto del representante legal  


        FOR PclDataContacto IN C_GetPersonaContacto(Pcl_DataPersona.ID_PERSONA)
        LOOP  
          Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '{"idPersonaFormaContacto":' ||PclDataContacto.ID_PERSONA_FORMA_CONTACTO ||',';
          Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '"formaContactoId":"' || PclDataContacto.FORMA_CONTACTO_ID || '",';
          Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '"formaContacto":"' || PclDataContacto.FORMA_CONTACTO|| '",';
          Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '"valor":"' || PclDataContacto.VALOR  || '"},';
        END LOOP;

     --Buscar cliente asociado a representante legal
       OPEN C_GetClienteRepresentante(Lv_Identificacion, Lv_IdentificacionRepre); 
            FETCH C_GetClienteRepresentante INTO  Pcl_DataClienteRepresentante ;  
       CLOSE C_GetClienteRepresentante;          

        END IF ; 


    Lcl_ArrayJsonContacto      := '['||SUBSTR(Lcl_ArrayJsonContacto, 0, length(Lcl_ArrayJsonContacto)-1)||']';  

 
    --CREAR JSON DE REPRESENTANTE LEGAL
    Lcl_ArrayJsonRepresentante := '{'; 
    IF Pcl_DataPersona.ID_PERSONA IS NOT NULL THEN 
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"idPersona":' || Pcl_DataPersona.ID_PERSONA || ',';
    Lv_TipoTributarioRepre     := Pcl_DataPersona.TIPO_TRIBUTARIO; 
    Lv_TipoIdentificacionRepre := Pcl_DataPersona.TIPO_IDENTIFICACION;
           
    END IF ; 
    
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"tipoIdentificacion":"' || Lv_TipoIdentificacionRepre|| '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"identificacion":"' ||    Lv_IdentificacionRepre  || '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"tipoTributario":"' ||  Lv_TipoTributarioRepre|| '",';
    
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"razonSocial":"' || Pcl_DataPersona.RAZON_SOCIAL|| '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"nombres":"' || Pcl_DataPersona.NOMBRES|| '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"apellidos":"' || Pcl_DataPersona.APELLIDOS|| '",';

    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"cargo":"' || Pcl_DataPersona.CARGO|| '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"direccion":"' || Pcl_DataPersona.DIRECCION|| '",';
    
    IF  Pcl_DataClienteRepresentante.ID_PERSONA_REPRESENTANTE  IS NOT NULL THEN 
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"idPersonaRepresentante":"' ||Pcl_DataClienteRepresentante.ID_PERSONA_REPRESENTANTE || '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"razonComercial":"' || Pcl_DataClienteRepresentante.RAZON_COMERCIAL|| '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"fechaExpiracionNombramiento":"' ||Pcl_DataClienteRepresentante.FE_EXPIRACION_NOMBRAMIENTO|| '",';
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"fechaRegistroMercantil":"' ||Pcl_DataClienteRepresentante.FE_REGISTRO_MERCANTIL|| '",'; 
    END IF; 
    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"formaContacto":' ||  Lcl_ArrayJsonContacto || '}';

       Pcl_Response := Lcl_ArrayJsonRepresentante;  
       PV_MENSAJE   := 'Tansaccion realizada correctamente';
       PV_STATUS    := 'OK'; 
       DBMS_OUTPUT.PUT_LINE(PV_MENSAJE );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           PV_STATUS     := 'ERROR'; 
           PV_MENSAJE    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           Pcl_Response := '{}';
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'VERIFICAR SI EL REPRESENTANTE LEGALE ESTA DISPONIBLE',
           'DB_COMERCIAL.CMKG_REPRES_LEGAL_TRANSACCION.P_VERIFICAR',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_VERIFICAR;   

PROCEDURE P_CONSULTAR(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE OUT CLOB)AS 

       Lv_CodEmpresa       VARCHAR2(100);  
       Lv_PrefijoEmpresa   VARCHAR2(100);   
       Lv_UsrCreacion      VARCHAR2(100);
       Lv_OrigenWeb        VARCHAR2(100);  
       Ln_IdPais           NUMBER;   

       Lv_TipoIdentificacion VARCHAR2(100);  
       Lv_Identificacion     VARCHAR2(100);  
       Lv_TipoTributario     VARCHAR2(100);  

       Lcl_ArrayJsonRepresentante CLOB; 
       Lcl_ArrayJsonContacto CLOB; 
            
        CURSOR C_GetClienteRepresentante(Cv_IdentificacionCli VARCHAR2) IS
          SELECT         
          REP_IP.ID_PERSONA,          
          REP_IP.RAZON_SOCIAL,
          REP_IP.NOMBRES, 
          REP_IP.APELLIDOS,
          REP_IP.TIPO_IDENTIFICACION,
          REP_IP.IDENTIFICACION_CLIENTE,
          REP_IP.CARGO,
          REP_IP.DIRECCION, 
          REP_IP.TIPO_TRIBUTARIO, 
          CLI_IPR.ID_PERSONA_REPRESENTANTE ,
          CLI_IPR.PERSONA_EMPRESA_ROL_ID,
          CLI_IPR.RAZON_COMERCIAL, 
          TO_CHAR(CLI_IPR.FE_EXPIRACION_NOMBRAMIENTO, 'DD/MM/YYYY')  AS FE_EXPIRACION_NOMBRAMIENTO, 
          TO_CHAR(CLI_IPR.FE_REGISTRO_MERCANTIL, 'DD/MM/YYYY')  AS FE_REGISTRO_MERCANTIL,  
          CLI_IPR.ESTADO,
          CLI_IPR.OBSERVACION
          FROM DB_COMERCIAL.INFO_PERSONA CLI_IP 
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL CLI_IPER ON  CLI_IPER.PERSONA_ID  = CLI_IP.ID_PERSONA
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE CLI_IPR ON  CLI_IPR.PERSONA_EMPRESA_ROL_ID  =  CLI_IPER.ID_PERSONA_ROL
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL REP_IPER ON  REP_IPER.ID_PERSONA_ROL =  CLI_IPR.REPRESENTANTE_EMPRESA_ROL_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA   REP_IP ON REP_IP.ID_PERSONA = REP_IPER.PERSONA_ID 
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL CLI_IER ON  CLI_IER.ID_EMPRESA_ROL  = CLI_IPER.EMPRESA_ROL_ID 
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL REP_IER ON  REP_IER.ID_EMPRESA_ROL  = REP_IPER.EMPRESA_ROL_ID 
          INNER JOIN DB_COMERCIAL.ADMI_ROL  CLI_AROL ON  CLI_AROL.ID_ROL = CLI_IER.ROL_ID
          INNER JOIN DB_COMERCIAL.ADMI_ROL  REP_AROL ON  REP_AROL .ID_ROL = REP_IER.ROL_ID
          WHERE CLI_IPR.ESTADO  IN ('Activo')              
          AND   CLI_AROL.DESCRIPCION_ROL IN ('Cliente', 'Pre-cliente')
          AND   REP_AROL.DESCRIPCION_ROL IN ('Representante Legal Juridico')
          AND   CLI_IER .EMPRESA_COD = Lv_CodEmpresa 
          AND   REP_IER .EMPRESA_COD = Lv_CodEmpresa 
          AND   CLI_IP.IDENTIFICACION_CLIENTE = Cv_IdentificacionCli;  


        CURSOR C_GetPersonaContacto(Cn_IdPersona NUMBER) IS
          SELECT 
          IPFC.ID_PERSONA_FORMA_CONTACTO,
          IPFC.FORMA_CONTACTO_ID,    
          AFC.DESCRIPCION_FORMA_CONTACTO AS FORMA_CONTACTO,
          IPFC.VALOR  
          FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC 
          INNER JOIN  DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC ON  AFC.ID_FORMA_CONTACTO = IPFC.FORMA_CONTACTO_ID
          WHERE IPFC.PERSONA_ID = Cn_IdPersona
          AND IPFC.ESTADO IN ('Activo');  


       BEGIN      
        APEX_JSON.PARSE(PCL_REQUEST);                  
        Lv_CodEmpresa        := APEX_JSON.GET_VARCHAR2(P_PATH => 'codEmpresa'); 
        Lv_PrefijoEmpresa    := APEX_JSON.GET_VARCHAR2(P_PATH => 'prefijoEmpresa'); 
        Lv_UsrCreacion       := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'); 
        Lv_OrigenWeb         := APEX_JSON.get_varchar2(p_path => 'origenWeb');
        Ln_IdPais            := APEX_JSON.get_varchar2(p_path => 'idPais');

        Lv_TipoIdentificacion              := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoIdentificacion'))); 
        Lv_Identificacion                  := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'identificacion'))); 
        
        Lv_TipoTributario                  := 'JUR'; 

       --VALIDAMOS FORMATO DE IDENTIFICACION DE PERSONA
        DB_COMERCIAL.VALIDA_IDENTIFICACION.VALIDA(Lv_TipoIdentificacion,Lv_Identificacion,Lv_CodEmpresa,Lv_TipoTributario,PV_MENSAJE);        
        IF  PV_MENSAJE  IS NOT NULL THEN  
            dbms_output.put_line( PV_MENSAJE );  
            RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
        END IF; 

        FOR PclDataRepresentante IN C_GetClienteRepresentante(Lv_Identificacion)
            LOOP 

             --CREAR JSON DE CONTACTO
            Lcl_ArrayJsonContacto      := '';
            FOR PclDataContacto IN C_GetPersonaContacto(PclDataRepresentante.ID_PERSONA)
            LOOP  
            Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '{"idPersonaFormaContacto":' ||PclDataContacto.ID_PERSONA_FORMA_CONTACTO ||',';
            Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '"formaContactoId":"' || PclDataContacto.FORMA_CONTACTO_ID || '",';
            Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '"formaContacto":"' || PclDataContacto.FORMA_CONTACTO|| '",';
            Lcl_ArrayJsonContacto := Lcl_ArrayJsonContacto || '"valor":"' || PclDataContacto.VALOR  || '"},';
            END LOOP;

            Lcl_ArrayJsonContacto      := '['||SUBSTR(Lcl_ArrayJsonContacto, 0, length(Lcl_ArrayJsonContacto)-1)||']';  



            --CREAR JSON DE REPRESNETANTE LEGAL 
              Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '{';

            IF  PclDataRepresentante.ID_PERSONA IS NOT NULL THEN 
                    Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"idPersona":"' ||PclDataRepresentante.ID_PERSONA|| '",';
            END IF; 

            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"razonSocial":"' ||PclDataRepresentante.RAZON_SOCIAL|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"nombres":"' ||PclDataRepresentante.NOMBRES|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"apellidos":"' ||PclDataRepresentante.APELLIDOS|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"tipoIdentificacion":"' ||PclDataRepresentante.TIPO_IDENTIFICACION|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"identificacion":"' ||PclDataRepresentante.IDENTIFICACION_CLIENTE|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"cargo":"' ||PclDataRepresentante.CARGO|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"direccion":"' ||PclDataRepresentante.DIRECCION|| '",'; 
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"tipoTributario":"' ||PclDataRepresentante.TIPO_TRIBUTARIO|| '",';
          
            IF  PclDataRepresentante.ID_PERSONA_REPRESENTANTE  IS NOT NULL THEN 
               Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"idPersonaRepresentante":"' ||PclDataRepresentante.ID_PERSONA_REPRESENTANTE || '",';
            END IF; 
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"razonComercial":"' ||PclDataRepresentante.RAZON_COMERCIAL|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"fechaExpiracionNombramiento":"' ||PclDataRepresentante.FE_EXPIRACION_NOMBRAMIENTO|| '",';
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"fechaRegistroMercantil":"' ||PclDataRepresentante.FE_REGISTRO_MERCANTIL|| '",';  
            Lcl_ArrayJsonRepresentante := Lcl_ArrayJsonRepresentante || '"formaContacto":' ||  Lcl_ArrayJsonContacto || '},';
            

        END LOOP;   

       Lcl_ArrayJsonRepresentante   := '['||SUBSTR(Lcl_ArrayJsonRepresentante , 0, length(Lcl_ArrayJsonRepresentante )-1)||']';  
      
       Pcl_Response :=  Lcl_ArrayJsonRepresentante ;
       PV_MENSAJE   := 'Tansaccion realizada correctamente';
       PV_STATUS    := 'OK'; 
       DBMS_OUTPUT.PUT_LINE(PV_MENSAJE );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           PV_STATUS     := 'ERROR'; 
           PV_MENSAJE    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           Pcl_Response := '[]';
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'LISTAR REPRESENTANTE LEGAL RELACIONADO A PERSONA JURIDICA',
           'DB_COMERCIAL.CMKG_REPRES_LEGAL_TRANSACCION.P_CONSULTAR',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_CONSULTAR; 

PROCEDURE P_ACTUALIZAR(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE OUT SYS_REFCURSOR)AS 

       Lv_CodEmpresa       VARCHAR2(100);  
       Lv_PrefijoEmpresa   VARCHAR2(100);   
       Lv_UsrCreacion      VARCHAR2(100);
       Lv_ClientIp         VARCHAR2(100);
       Lv_OrigenWeb        VARCHAR2(100);  
       Ln_IdPais           NUMBER; 
       Ln_OficinaId        NUMBER;  
       Ln_TituloId         NUMBER; 
       Ln_EmpresaRolId     NUMBER;   

       Lv_TipoIdentificacion VARCHAR2(100);  
       Lv_Identificacion     VARCHAR2(100);  
       Lv_TipoTributario     VARCHAR2(100);  
       Lv_FechaRegistroMercantil VARCHAR2(200); 
       Lv_RazonComercial         VARCHAR2(200); 

       Ln_CountRepresentante NUMBER;
       Ln_CountFormaContacto  NUMBER;
       
       Ln_ReprTipoNaturalMin  NUMBER;
       Ln_ReprTipoNaturalMax  NUMBER;
       Ln_CountReprTipoNatural  NUMBER; 

       Lcl_ArrayJsonRepresentante CLOB; 
       Lcl_ArrayJsonContacto CLOB; 

       Lv_VerificaIdentificacion  VARCHAR2(500);  
       
        CURSOR C_GetPersona(Cv_Identificacion VARCHAR2) IS
            SELECT    
            CLI_IP.ID_PERSONA,
            CLI_IP.RAZON_SOCIAL, 
            CLI_IP.NOMBRES,
            CLI_IP.APELLIDOS,
            CLI_IP.TIPO_IDENTIFICACION,
            CLI_IP.IDENTIFICACION_CLIENTE,
            CLI_IP.CARGO,
            CLI_IP.DIRECCION,
            CLI_IP.NACIONALIDAD,
            CLI_IP.TIPO_TRIBUTARIO,  
            CLI_IP.REPRESENTANTE_LEGAL,
            CLI_IPER.ID_PERSONA_ROL, 
            CLI_AROL.DESCRIPCION_ROL
            FROM DB_COMERCIAL.INFO_PERSONA CLI_IP  
            LEFT JOIN ( SELECT OUTPER.PERSONA_ID, OUTPER.ID_PERSONA_ROL,  OUTPER.EMPRESA_ROL_ID  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  OUTPER  
            WHERE  OUTPER.ESTADO  IN  ('Inactivo','Pendiente','Cancelado', 'Activo')  
            ORDER BY  OUTPER.ID_PERSONA_ROL DESC) CLI_IPER ON  CLI_IPER.PERSONA_ID  = CLI_IP.ID_PERSONA 
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL CLI_IER ON  CLI_IER.ID_EMPRESA_ROL  = CLI_IPER.EMPRESA_ROL_ID 
            INNER JOIN DB_COMERCIAL.ADMI_ROL  CLI_AROL ON  CLI_AROL.ID_ROL = CLI_IER.ROL_ID        
            WHERE   ROWNUM = 1 
            AND   CLI_AROL.DESCRIPCION_ROL IN ('Cliente', 'Pre-cliente') 
            AND   CLI_IP.IDENTIFICACION_CLIENTE =   Cv_Identificacion ; 
          
          
          
  
        CURSOR C_GetIdEmpresaRol(Cv_NombreRol VARCHAR2,Cv_CodEmpresa VARCHAR2) IS  
          SELECT INER.ID_EMPRESA_ROL 
          FROM DB_COMERCIAL.INFO_EMPRESA_ROL  INER
          INNER JOIN  DB_COMERCIAL.ADMI_ROL   ADRO 
          ON INER.ROL_ID =  ADRO.ID_ROL  
          WHERE  ADRO.DESCRIPCION_ROL = Cv_NombreRol 
          AND ADRO.ESTADO = 'Activo'
          AND INER.ESTADO = 'Activo'
          AND INER.EMPRESA_COD=Cv_CodEmpresa; 



        Pcl_DataPersona  C_GetPersona%ROWTYPE;         

        Pcl_InfoPersona               DB_COMERCIAL.INFO_PERSONA%ROWTYPE;
        Pcl_InfoPersonaEmpresaRol     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE;  
        Pcl_InfoPersonaRepresentante  DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE%ROWTYPE;
        Pcl_InfoPersonaFormaContacto  DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE;

       BEGIN      
        APEX_JSON.PARSE(PCL_REQUEST);                  
        Lv_CodEmpresa        := APEX_JSON.GET_VARCHAR2(P_PATH => 'codEmpresa'); 
        Lv_PrefijoEmpresa    := APEX_JSON.GET_VARCHAR2(P_PATH => 'prefijoEmpresa'); 
        Lv_UsrCreacion       := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'); 
        Lv_ClientIp          := APEX_JSON.get_varchar2(p_path => 'clientIp');
        Lv_OrigenWeb         := APEX_JSON.get_varchar2(p_path => 'origenWeb');
        Ln_IdPais            := APEX_JSON.get_varchar2(p_path => 'idPais');
        Ln_OficinaId         := APEX_JSON.get_varchar2(p_path => 'oficinaId');

        Lv_TipoIdentificacion              := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoIdentificacion'))); 
        Lv_Identificacion                  := UPPER(TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'identificacion'))); 
       
        Lv_TipoTributario                  := 'JUR'; 
        Lv_FechaRegistroMercantil          := APEX_JSON.GET_VARCHAR2(P_PATH => 'fechaRegistroMercantil');  
        Lv_RazonComercial                  := APEX_JSON.GET_VARCHAR2(P_PATH => 'razonComercial');  
        Ln_TituloId                        := 140;  --?      

        IF  Lv_FechaRegistroMercantil IS NULL  THEN
         Lv_FechaRegistroMercantil  := TO_DATE (SYSDATE, 'DD-MM-YYYY'); --? 
        ELSE 
         Lv_FechaRegistroMercantil  := TO_DATE (Lv_FechaRegistroMercantil, 'DD-MM-YYYY');         
        END IF; 
        
        Ln_ReprTipoNaturalMin    :=  1; --?
        Ln_ReprTipoNaturalMax    :=  1; --?
        Ln_CountReprTipoNatural  :=  0;--?
        
        Ln_CountRepresentante := APEX_JSON.get_count(p_path => 'representanteLegal');      
     
        IF  Lv_TipoIdentificacion IS NULL THEN  
           PV_MENSAJE :='El campo tipoIdentificacion  es requerida.';
           RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
        END IF; 
        
        IF  Lv_Identificacion  IS NULL THEN  
           PV_MENSAJE :='El campo identificaci�n  es requerida.';
           RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
        END IF; 


       --VALIDAMOS FORMATO DE IDENTIFICACION DE PERSONA
        DB_COMERCIAL.VALIDA_IDENTIFICACION.VALIDA(Lv_TipoIdentificacion,Lv_Identificacion,Lv_CodEmpresa,Lv_TipoTributario,PV_MENSAJE);        
        IF  PV_MENSAJE  IS NOT NULL THEN  
            dbms_output.put_line( PV_MENSAJE );  
            RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
        END IF; 

        OPEN C_GetPersona(Lv_Identificacion); 
         FETCH C_GetPersona INTO  Pcl_DataPersona ;  
        CLOSE C_GetPersona;  

        IF   Pcl_DataPersona.ID_PERSONA  IS  NULL THEN
             PV_MENSAJE :='La identificaci�n  '||Lv_Identificacion||' requiere ser (Pre-cliente o Cliente).'; 
             dbms_output.put_line( PV_MENSAJE );  
             RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
        ELSE
        
        
        OPEN C_GetIdEmpresaRol('Representante Legal Juridico',Lv_CodEmpresa); 
         FETCH C_GetIdEmpresaRol INTO   Ln_EmpresaRolId ;  
        CLOSE C_GetIdEmpresaRol;  
        
        IF Ln_EmpresaRolId IS NULL THEN 
             PV_MENSAJE :='Rol Representante Legal Juridico no existe.'; 
             dbms_output.put_line( PV_MENSAJE );  
             RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
        END IF;
         
        
        --REVALIDARCION DE  DATOS
           Lv_VerificaIdentificacion :=''; 
           FOR I IN 1 ..  Ln_CountRepresentante
                LOOP                    
                Pcl_InfoPersona := NULL; 
                Pcl_InfoPersona.TIPO_IDENTIFICACION    := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].tipoIdentificacion', I))); 
                Pcl_InfoPersona.IDENTIFICACION_CLIENTE := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].identificacion', I)));  
                Pcl_InfoPersona.TIPO_TRIBUTARIO        := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].tipoTributario', I)));   
 
                IF Pcl_InfoPersona.TIPO_TRIBUTARIO  = 'NAT' THEN 
                Ln_CountReprTipoNatural:=Ln_CountReprTipoNatural+1;                   
                END IF; 
            
                IF Pcl_InfoPersona.IDENTIFICACION_CLIENTE =  Lv_Identificacion THEN  
                PV_MENSAJE :='La identificacion '|| Pcl_InfoPersona.IDENTIFICACION_CLIENTE ||' no debe ser igual que la persona jur�dica.'; 
                dbms_output.put_line( PV_MENSAJE );                 
                RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);                
                END IF;  
                
                IF INSTR( Lv_VerificaIdentificacion  , Pcl_InfoPersona.IDENTIFICACION_CLIENTE||',') <> 0   THEN                  
                PV_MENSAJE :='La identificacion '|| Pcl_InfoPersona.IDENTIFICACION_CLIENTE ||' solo puede ser ingresada una vez.'; 
                dbms_output.put_line( PV_MENSAJE );                 
                RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
                END IF;   
                      
                Lv_VerificaIdentificacion  :=  Lv_VerificaIdentificacion ||Pcl_InfoPersona.IDENTIFICACION_CLIENTE||',' ; 
          
            END LOOP; 
          
           IF Ln_CountReprTipoNatural <  Ln_ReprTipoNaturalMax THEN                  
                PV_MENSAJE :='Es requerido un representante legal de tipo natural.'; 
                dbms_output.put_line( PV_MENSAJE );                 
                RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
           END IF;   
           
           IF Ln_CountReprTipoNatural >  Ln_ReprTipoNaturalMin THEN                  
                PV_MENSAJE :='Solo esta permitido ingresar un representante legal de tipo natural.'; 
                dbms_output.put_line( PV_MENSAJE );                
                RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
           END IF; 
               
          
        --ACTUALIZAR DATOS
            UPDATE DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE INPR
            SET INPR.ESTADO='Eliminado',
            INPR.OBSERVACION = 'Cambio de representante legal',
            INPR.FE_ULT_MOD  = SYSDATE,  
            INPR.USR_ULT_MOD = Lv_UsrCreacion,
            INPR.IP_ULT_MOD  = Lv_ClientIp            
            WHERE INPR.PERSONA_EMPRESA_ROL_ID  IN  (
            SELECT INPER.ID_PERSONA_ROL FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL INPER 
            INNER JOIN DB_COMERCIAL.INFO_PERSONA INPE ON INPE.ID_PERSONA = INPER.PERSONA_ID
            WHERE  INPE.ID_PERSONA = Pcl_DataPersona.ID_PERSONA 
            );            
            COMMIT ; 


            FOR I IN 1 ..  Ln_CountRepresentante
                LOOP     


                --ACTUALIZAR PERSONA 
                Pcl_InfoPersona := NULL; 
                Pcl_InfoPersona.TIPO_IDENTIFICACION    := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].tipoIdentificacion', I)));
                Pcl_InfoPersona.IDENTIFICACION_CLIENTE := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].identificacion', I))); 
                Pcl_InfoPersona.TIPO_TRIBUTARIO        := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].tipoTributario', I))); 
                Pcl_InfoPersona.RAZON_SOCIAL           := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].razonSocial',  I)));      
                Pcl_InfoPersona.NOMBRES                := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].nombres',  I)));      
                Pcl_InfoPersona.APELLIDOS              := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].apellidos', I)));  
                Pcl_InfoPersona.DIRECCION              := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].direccion',  I)));   
                Pcl_InfoPersona.CARGO                  := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].cargo', I))); 
                Pcl_InfoPersona.DIRECCION_TRIBUTARIA   := UPPER(TRIM(APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].direccion',  I)));   
                Pcl_InfoPersona.ESTADO                 :='Activo';               
                Pcl_InfoPersona.ORIGEN_WEB             := Lv_OrigenWeb;                 
                Pcl_InfoPersona.PAIS_ID                := Ln_IdPais;    

                DBMS_OUTPUT.PUT_LINE('IDENTIFICACION '|| Pcl_InfoPersona.IDENTIFICACION_CLIENTE );  

                    IF  Pcl_InfoPersona.TIPO_TRIBUTARIO = 'NAT' THEN                   
                        UPDATE DB_COMERCIAL.INFO_PERSONA  IP SET                      
                        IP.REPRESENTANTE_LEGAL  =   Pcl_InfoPersona.APELLIDOS||' '||Pcl_InfoPersona.NOMBRES    
                        WHERE  IP.IDENTIFICACION_CLIENTE = Lv_Identificacion ;
                        COMMIT;            
                    END IF ;           

                    IF  Pcl_InfoPersona.TIPO_TRIBUTARIO = 'JUR' THEN   
                        UPDATE DB_COMERCIAL.INFO_PERSONA  IP SET                                             
                        IP.RAZON_SOCIAL                  = Pcl_InfoPersona.RAZON_SOCIAL, 
                        IP.DIRECCION                     = Pcl_InfoPersona.DIRECCION,
                        IP.CARGO                         = Pcl_InfoPersona.CARGO,
                        IP.DIRECCION_TRIBUTARIA          = Pcl_InfoPersona.DIRECCION_TRIBUTARIA             
                        WHERE  IP.IDENTIFICACION_CLIENTE = Pcl_InfoPersona.IDENTIFICACION_CLIENTE 
                        RETURNING IP.ID_PERSONA INTO Pcl_InfoPersona.ID_PERSONA; 
                    ELSE 
                        UPDATE DB_COMERCIAL.INFO_PERSONA  IP SET                        
                        IP.NOMBRES                       = Pcl_InfoPersona.NOMBRES,
                        IP.APELLIDOS                     = Pcl_InfoPersona.APELLIDOS,
                        IP.DIRECCION                     = Pcl_InfoPersona.DIRECCION,
                        IP.CARGO                         = Pcl_InfoPersona.CARGO,
                        IP.DIRECCION_TRIBUTARIA          = Pcl_InfoPersona.DIRECCION_TRIBUTARIA             
                        WHERE  IP.IDENTIFICACION_CLIENTE = Pcl_InfoPersona.IDENTIFICACION_CLIENTE 
                        RETURNING IP.ID_PERSONA INTO Pcl_InfoPersona.ID_PERSONA;     
                    END IF ;           
                    

                    IF Pcl_InfoPersona.ID_PERSONA IS  NULL THEN   
                        Pcl_InfoPersona.TITULO_ID        := Ln_TituloId; 
                        Pcl_InfoPersona.ORIGEN_PROSPECTO :='N';
                        Pcl_InfoPersona.FE_CREACION      := SYSDATE;            
                        Pcl_InfoPersona.USR_CREACION     := Lv_UsrCreacion; 
                        Pcl_InfoPersona.IP_CREACION      := Lv_ClientIp;                
                        Pcl_InfoPersona.ID_PERSONA       := SEQ_INFO_PERSONA.NEXTVAL;                      
                        INSERT INTO DB_COMERCIAL.INFO_PERSONA VALUES  Pcl_InfoPersona; 
                    END IF;                 
                    COMMIT ;
 
                  DBMS_OUTPUT.PUT_LINE('INFO_PERSONA  '||Pcl_InfoPersona.ID_PERSONA);   
                --ACTUALIZAR DE EMPRESA ROL
                        Pcl_InfoPersonaEmpresaRol := NULL; 
                        Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL   := APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].representanteEmpresaRolId', I);    
                        Pcl_InfoPersonaEmpresaRol.PERSONA_ID       := Pcl_InfoPersona.ID_PERSONA ; 
                        Pcl_InfoPersonaEmpresaRol.EMPRESA_ROL_ID   := Ln_EmpresaRolId ; --Empresa Rol de representante legal
                        Pcl_InfoPersonaEmpresaRol.OFICINA_ID       := Ln_OficinaId;
                        Pcl_InfoPersonaEmpresaRol.ESTADO           := 'Activo'; 
                        Pcl_InfoPersonaEmpresaRol.USR_ULT_MOD      := Lv_UsrCreacion; 
                        Pcl_InfoPersonaEmpresaRol.FE_ULT_MOD       := SYSDATE;   

                        UPDATE  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER SET         
                        IPER.PERSONA_ID           = Pcl_InfoPersonaEmpresaRol.PERSONA_ID, 
                        IPER.EMPRESA_ROL_ID       = Pcl_InfoPersonaEmpresaRol.EMPRESA_ROL_ID, 
                        IPER.OFICINA_ID           = Pcl_InfoPersonaEmpresaRol.OFICINA_ID, 
                        IPER.ESTADO               = Pcl_InfoPersonaEmpresaRol.ESTADO ,
                        IPER.USR_ULT_MOD          = Pcl_InfoPersonaEmpresaRol.USR_ULT_MOD, 
                        IPER.FE_ULT_MOD           = Pcl_InfoPersonaEmpresaRol.FE_ULT_MOD 
                        WHERE IPER.PERSONA_ID     = Pcl_InfoPersona.ID_PERSONA 
                        AND   IPER.EMPRESA_ROL_ID = Pcl_InfoPersonaEmpresaRol.EMPRESA_ROL_ID                      
                        RETURNING IPER.ID_PERSONA_ROL INTO Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL ;

                        IF Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL IS NULL THEN                         
                        Pcl_InfoPersonaEmpresaRol.USR_CREACION   := Lv_UsrCreacion ; 
                        Pcl_InfoPersonaEmpresaRol.FE_CREACION    := SYSDATE ;             
                        Pcl_InfoPersonaEmpresaRol.IP_CREACION    := Lv_ClientIp;                        
                        Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL := SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL;
                        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL VALUES  Pcl_InfoPersonaEmpresaRol;   
                        END IF ; 
                 COMMIT ;
                 DBMS_OUTPUT.PUT_LINE('INFO_PERSONA_EMPRESA_ROL '||Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL);   

                --ACTUALIZAR REPRESENTANTE LEGAL  
                    Pcl_InfoPersonaRepresentante := NULL;      
                    
                    IF  Lv_RazonComercial IS NOT NULL THEN
                    Pcl_InfoPersonaRepresentante.RAZON_COMERCIAL              := Lv_RazonComercial;  
                    ELSE 
                    Pcl_InfoPersonaRepresentante.RAZON_COMERCIAL              := Pcl_DataPersona.RAZON_SOCIAL; 
                    END IF;
                    
                    Pcl_InfoPersonaRepresentante.PERSONA_EMPRESA_ROL_ID       := Pcl_DataPersona.ID_PERSONA_ROL; 
                    Pcl_InfoPersonaRepresentante.REPRESENTANTE_EMPRESA_ROL_ID := Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL ; 
                    Pcl_InfoPersonaRepresentante.ESTADO                       := 'Activo'; 
                    Pcl_InfoPersonaRepresentante.FE_REGISTRO_MERCANTIL        := Lv_FechaRegistroMercantil;   
                    Pcl_InfoPersonaRepresentante.FE_EXPIRACION_NOMBRAMIENTO   := TO_DATE (APEX_JSON.GET_VARCHAR2 ('representanteLegal[%d].fechaExpiracionNombramiento', I), 'DD-MM-YYYY'); 
                    Pcl_InfoPersonaRepresentante.OBSERVACION                  := 'Actualizacion de represenatnte legal'; 
                    Pcl_InfoPersonaRepresentante.FE_ULT_MOD  := SYSDATE;     
                    Pcl_InfoPersonaRepresentante.USR_ULT_MOD := Lv_UsrCreacion; 
                    Pcl_InfoPersonaRepresentante.IP_ULT_MOD  := Lv_ClientIp;


                    
                    IF  Lv_OrigenWeb ='S' THEN 
                       Pcl_InfoPersonaRepresentante.OBSERVACION  := Pcl_InfoPersonaRepresentante.OBSERVACION ||'. (Origen WEB)'; 
                    END IF ; 

                    UPDATE DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE  IPR SET                     
                    IPR.ESTADO                      = Pcl_InfoPersonaRepresentante.ESTADO,
                    IPR.RAZON_COMERCIAL             = Pcl_InfoPersonaRepresentante.RAZON_COMERCIAL ,
                    IPR.FE_REGISTRO_MERCANTIL       = Pcl_InfoPersonaRepresentante.FE_REGISTRO_MERCANTIL,
                    IPR.FE_EXPIRACION_NOMBRAMIENTO  = Pcl_InfoPersonaRepresentante.FE_EXPIRACION_NOMBRAMIENTO,
                    IPR.OBSERVACION                 = Pcl_InfoPersonaRepresentante.OBSERVACION,
                    IPR.FE_ULT_MOD                  = Pcl_InfoPersonaRepresentante.FE_ULT_MOD,
                    IPR.USR_ULT_MOD                 = Pcl_InfoPersonaRepresentante.USR_ULT_MOD,
                    IPR.IP_ULT_MOD                  = Pcl_InfoPersonaRepresentante.IP_ULT_MOD                   
                    WHERE  IPR.PERSONA_EMPRESA_ROL_ID     = Pcl_InfoPersonaRepresentante.PERSONA_EMPRESA_ROL_ID
                    AND  IPR.REPRESENTANTE_EMPRESA_ROL_ID = Pcl_InfoPersonaRepresentante.REPRESENTANTE_EMPRESA_ROL_ID
                    RETURNING  IPR.ID_PERSONA_REPRESENTANTE INTO Pcl_InfoPersonaRepresentante.ID_PERSONA_REPRESENTANTE;

                    IF Pcl_InfoPersonaRepresentante.ID_PERSONA_REPRESENTANTE   IS  NULL THEN    
                    Pcl_InfoPersonaRepresentante.FE_CREACION   := SYSDATE;    
                    Pcl_InfoPersonaRepresentante.USR_CREACION  := Lv_UsrCreacion; 
                    Pcl_InfoPersonaRepresentante.IP_CREACION   := Lv_ClientIp;      
                    Pcl_InfoPersonaRepresentante.ID_PERSONA_REPRESENTANTE  :=  SEQ_INFO_PERSONA_REPRESENTANTE.NEXTVAL;
                    INSERT INTO DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE VALUES   Pcl_InfoPersonaRepresentante;                 
                    END IF; 
               COMMIT ;
               DBMS_OUTPUT.PUT_LINE('INFO_PERSONA_REPRESENTANTE '||Pcl_InfoPersonaRepresentante.ID_PERSONA_REPRESENTANTE); 
                --ACTUALIZANDO  FORMA DE CONTACTO
                
                UPDATE DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO  IPFC SET           
                IPFC.FE_ULT_MOD         = SYSDATE, 
                IPFC.USR_ULT_MOD        = Lv_UsrCreacion,  
                IPFC.ESTADO             = 'Eliminado'
                WHERE  IPFC.PERSONA_ID  = Pcl_InfoPersona.ID_PERSONA; 
                COMMIT ; 
                

                Ln_CountFormaContacto := APEX_JSON.get_count(p_path => 'representanteLegal[%d].formaContacto', p0 => I);      

                FOR J IN 1 ..  Ln_CountFormaContacto 
                LOOP     

                Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO := APEX_JSON.GET_VARCHAR2 (p_path => 'representanteLegal[%d].formaContacto[%d].idPersonaFormaContacto', p0 => I, p1=>J) ;          
                Pcl_InfoPersonaFormaContacto.PERSONA_ID          := Pcl_InfoPersona.ID_PERSONA;        
                Pcl_InfoPersonaFormaContacto.FORMA_CONTACTO_ID   := APEX_JSON.GET_VARCHAR2 (p_path => 'representanteLegal[%d].formaContacto[%d].formaContactoId', p0 => I, p1=>J) ;          
                Pcl_InfoPersonaFormaContacto.VALOR               := APEX_JSON.GET_VARCHAR2 (p_path => 'representanteLegal[%d].formaContacto[%d].valor', p0 => I, p1=>J);
                Pcl_InfoPersonaFormaContacto.ESTADO              := 'Activo';  
                Pcl_InfoPersonaFormaContacto.FE_ULT_MOD          := SYSDATE; 
                Pcl_InfoPersonaFormaContacto.USR_ULT_MOD         := Lv_UsrCreacion;  
                 

                IF  Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO IS NULL OR Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO= 0 THEN 
                
                Pcl_InfoPersonaFormaContacto.FE_CREACION   := SYSDATE;            
                Pcl_InfoPersonaFormaContacto.USR_CREACION  := Lv_UsrCreacion;      
                Pcl_InfoPersonaFormaContacto.IP_CREACION   := Lv_ClientIp;  
                Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO  := SEQ_INFO_PERSONA_FORMA_CONT.NEXTVAL;
                INSERT INTO DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO  VALUES   Pcl_InfoPersonaFormaContacto;       
              
                ELSE 
                                            
                UPDATE DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO  IPFC SET 
                IPFC.FORMA_CONTACTO_ID = Pcl_InfoPersonaFormaContacto.FORMA_CONTACTO_ID,               
                IPFC.VALOR             = Pcl_InfoPersonaFormaContacto.VALOR ,   
                IPFC.FE_ULT_MOD        = Pcl_InfoPersonaFormaContacto.FE_ULT_MOD, 
                IPFC.USR_ULT_MOD       = Pcl_InfoPersonaFormaContacto.USR_ULT_MOD,                 
                IPFC.ESTADO            = Pcl_InfoPersonaFormaContacto.ESTADO  
                WHERE IPFC.ID_PERSONA_FORMA_CONTACTO =  Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO; 
             
                END IF; 
                COMMIT ; 
  
                DBMS_OUTPUT.PUT_LINE('INFO_PERSONA_FORMA_CONTACTO '|| Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO); 
  
                 END LOOP; 

             END LOOP;               
        END IF;    

       PV_MENSAJE   := 'Tansaccion realizada correctamente';
       PV_STATUS    := 'OK'; 
       DBMS_OUTPUT.PUT_LINE(PV_MENSAJE );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           PV_STATUS     := 'ERROR'; 
           PV_MENSAJE    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           ' INSERTA Y ACTUALIZA REPRESENTANTE LEGAL RELACIONADO A PERSONA JURIDICA',
           'DB_COMERCIAL.CMKG_REPRES_LEGAL_TRANSACCION.P_ACTUALIZAR',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_ACTUALIZAR; 

END CMKG_REPRES_LEGAL_TRANSACCION;
/