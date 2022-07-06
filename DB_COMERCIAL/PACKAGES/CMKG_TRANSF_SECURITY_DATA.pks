SET DEFINE OFF;  
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA  AS

   /**
    * Documentación para F_DATA_PARAMETRO
    * Funcion Obtiene parametro de configuracion
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 04/14/2022
    */
    FUNCTION  F_DATA_PARAMETRO(FV_NOMBREPARAMETRO IN VARCHAR2,FV_DESCRIPCION IN VARCHAR2) RETURN   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
   
  /**
    * Documentación para P_DOCUMENTOS_PENDIENTES
    * OBTIENE LISTA DE DOCUMENTOS A TRANSFERIR QUE ESTÁN CON ESTADO PENDIENTE 
    * 
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 04/04/2022
    */
    PROCEDURE P_DOCUMENTOS_PENDIENTES(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE  OUT SYS_REFCURSOR);
 
   /**
    * Documentación para P_DOCUMENTOS_PROCESADOS
    * OBTIENE LISTA DE DOCUMENTOS QUE NO PUDIERON SER TRANSFERIDOS A SD
    * 
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 04/04/2022
    */
    PROCEDURE P_DOCUMENTOS_PROCESADOS(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE  OUT SYS_REFCURSOR);

    /**
    * Documentación para P_DOCUMENTOS_PENDIENTES_ACT
    *ACRUALIZA LOS ESTADOS , INTENTOS Y OBSERVACIONES DE DOCUMENTO
    * 
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 04/04/2022
    */
    PROCEDURE P_DOCUMENTOS_PENDIENTES_ACT(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE  OUT SYS_REFCURSOR);


END CMKG_TRANSF_SECURITY_DATA;

/


CREATE OR REPLACE PACKAGE BODY  DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA AS

    FUNCTION  F_DATA_PARAMETRO(FV_NOMBREPARAMETRO IN VARCHAR2,FV_DESCRIPCION IN VARCHAR2) 
        RETURN   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  AS
        PCL_DETALLE  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
        PV_MENSAJE  VARCHAR2(500); 
                 
        CURSOR C_GETDATAPARAMETRO( FV_NOMBREPARAMETRO VARCHAR2,FV_DESCRIPCION VARCHAR2) IS
        SELECT APD.* FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APD.PARAMETRO_ID =  APC.ID_PARAMETRO 
        WHERE APC.ESTADO  = 'Activo' 
        AND  APD.ESTADO  = 'Activo'
        AND  APC.NOMBRE_PARAMETRO =  FV_NOMBREPARAMETRO 
        AND  APD.DESCRIPCION =  FV_DESCRIPCION; 
       
        BEGIN 	       
          	OPEN C_GETDATAPARAMETRO(FV_NOMBREPARAMETRO,FV_DESCRIPCION); 
		    FETCH C_GETDATAPARAMETRO INTO  PCL_DETALLE;     
		    CLOSE C_GETDATAPARAMETRO;	
	      IF ( PCL_DETALLE.VALOR1 IS   NULL)  THEN 
	             PV_MENSAJE := 'No existe el valor de '||FV_DESCRIPCION||' en el parametro '||FV_NOMBREPARAMETRO||'.';
	             DBMS_OUTPUT.PUT_LINE( PV_MENSAJE );  
	             RAISE_APPLICATION_ERROR(-20101,PV_MENSAJE);
	      END IF; 
	    RETURN   PCL_DETALLE;
    END F_DATA_PARAMETRO;  

    PROCEDURE P_DOCUMENTOS_PENDIENTES(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE OUT SYS_REFCURSOR)AS 
      
       LV_CODEMPRESA   VARCHAR2(100);     
       LV_USRCREACION  VARCHAR2(100);
       LV_CLIENTIP     VARCHAR2(100);  
       LV_PARAMETROCAB VARCHAR2(100);   
       
       PCL_USUARIOSD        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       PCL_TIPOPERSONA      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       PCL_ESTADOS          DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;   
       PCL_DOCUMENTOSSD     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;        
       PCL_ESTADOCONTRATO   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;       
       PCL_CANTIDADPROCESAR DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       PCL_ESTADOFIRMA      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       PCL_CANTIDADDIAS     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       
       BEGIN  

       LV_PARAMETROCAB 	         := 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA' ;  
      
       APEX_JSON.PARSE(PCL_REQUEST); 
       LV_CODEMPRESA             := APEX_JSON.GET_VARCHAR2(P_PATH => 'strCodEmpresa');    
       LV_USRCREACION            := APEX_JSON.GET_VARCHAR2(P_PATH => 'strUsrCreacion'); 
       LV_CLIENTIP               := APEX_JSON.GET_VARCHAR2(P_PATH => 'strClientIp'); 
                  
       PCL_USUARIOSD             := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'WS_NOMBRE_USUARIO');
       PCL_TIPOPERSONA           := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'TIPO_PERSONA');
	   PCL_ESTADOS               := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADOS_PROCESO');
       PCL_DOCUMENTOSSD          := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'DOCUMENTOS_SD');  
       PCL_ESTADOCONTRATO        := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADOS_CONTRATO'); 
       PCL_CANTIDADPROCESAR      := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'CANTIDAD_PROCESAR'); 
       PCL_ESTADOFIRMA           := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADO_FIRMA'); 
       PCL_CANTIDADDIAS          := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'CANTIDAD_DIAS');  
       
        OPEN PCL_RESPONSE FOR 
        SELECT  
        DOCU.ID_CERTIFICADO_DOCUMENTO,
        DOCU.NOMBRECOMPLETO, 
        DOCU.CEDULA,    
        DOCU.SERIAL,              
        DOCU.USUARIO,               
        DOCU.RUTAARCHIVO, 
        DOCU.TIPOARCHIVO,  
        DOCU.NOMBREARCHIVO, 
        DOCU.NOMBREDOCUMENTO,   
        DOCU.TIPOPERSONA,  
        DOCU.TIPOTRIBUTARIO,    
        DOCU.ESTADO,
        DOCU.INTENTOS        
        FROM (         
            SELECT
            INCD.ID_CERTIFICADO_DOCUMENTO,   
            (INCE.NOMBRES ||' '||INCE.PRIMER_APELLIDO||' '||INCE.SEGUNDO_APELLIDO) AS NOMBRECOMPLETO, 
            INCE.NUM_CEDULA                                                        AS CEDULA,          
            REPLACE(INCE.SERIAL_NUMBER,'-'||INCE.NUM_CEDULA,'')                    AS SERIAL,       
            PCL_USUARIOSD.VALOR1        AS USUARIO,               
            INCD.SRC                    AS RUTAARCHIVO, 
            ATDG.CODIGO_TIPO_DOCUMENTO  AS TIPOARCHIVO,          
            INCE.NUM_CEDULA||'-'|| ( CASE 
            WHEN ATDG.CODIGO_TIPO_DOCUMENTO !=  'OTR' AND ATDG.CODIGO_TIPO_DOCUMENTO !=  'CONT'    
            THEN  REGEXP_REPLACE(ATDG.DESCRIPCION_TIPO_DOCUMENTO , '  *', '_' )
            ELSE  REGEXP_REPLACE(REGEXP_SUBSTR( INDO.NOMBRE_DOCUMENTO  , '[^/]+$', 1, 1) , '-[^/]+$', '' )   END 
            )||'.' ||ATDO.EXTENSION_TIPO_DOCUMENTO AS NOMBREARCHIVO,         
            REGEXP_REPLACE(REGEXP_SUBSTR( INDO.NOMBRE_DOCUMENTO  , '[^/]+$', 1, 1) , '-[^/]+$', '' )  AS NOMBREDOCUMENTO,   
            (CASE  INCE.PERSONA_NATURAL  
            WHEN  PCL_TIPOPERSONA.VALOR1   THEN  PCL_TIPOPERSONA.VALOR2
            WHEN  PCL_TIPOPERSONA.VALOR3   THEN  PCL_TIPOPERSONA.VALOR4
            ELSE NULL END)                AS TIPOPERSONA,  
            INCE.PERSONA_NATURAL          AS TIPOTRIBUTARIO,    
            INCD.DOCUMENTADO              AS ESTADO,
            COALESCE(INCD.INTENTOS,0)     AS INTENTOS,
            INCD.OBSERVACION              AS OBSERVACION  
            FROM 
            DB_COMUNICACION.INFO_DOCUMENTO INDO,
            DB_COMUNICACION.ADMI_TIPO_DOCUMENTO ATDO,
            DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL ATDG,    
            DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO INCD,
            DB_FIRMAELECT.INFO_CERTIFICADO INCE,     
            DB_COMERCIAL.INFO_PERSONA INPE ,
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER , 
            DB_COMERCIAL.INFO_CONTRATO ICON     
            WHERE  INDO.TIPO_DOCUMENTO_ID = ATDO.ID_TIPO_DOCUMENTO
            AND INDO.TIPO_DOCUMENTO_GENERAL_ID = ATDG.ID_TIPO_DOCUMENTO    
            AND INDO.UBICACION_FISICA_DOCUMENTO = INCD.SRC
            AND INCD.CERTIFICADO_ID = INCE.ID_CERTIFICADO 
            AND INCD.DOCUMENTADO != PCL_ESTADOS.VALOR2   
            AND INCD.SRC LIKE 'http%' 
            AND INCE.NUM_CEDULA =  INPE.IDENTIFICACION_CLIENTE
            AND INCE.ESTADO IN   
                (       
                SELECT REGEXP_SUBSTR(   PCL_ESTADOFIRMA.VALOR1 ,'[^,]+', 1, LEVEL)FROM DUAL
                CONNECT BY REGEXP_SUBSTR( PCL_ESTADOFIRMA.VALOR1 , '[^,]+', 1, LEVEL) IS NOT NULL
                ) 
            AND INCE.FE_CREACION >= SYSDATE -TO_NUMBER(PCL_CANTIDADDIAS.VALOR1)
            AND INPE.ID_PERSONA  = IPER.PERSONA_ID
            AND IPER.ID_PERSONA_ROL =  ICON.PERSONA_EMPRESA_ROL_ID 
            AND IPER.ESTADO ='Activo'  
            AND IPER.EMPRESA_ROL_ID = 813   
            AND ICON.ID_CONTRATO = INDO.CONTRATO_ID
            AND ICON.ESTADO   IN   
                (       
                SELECT REGEXP_SUBSTR(   PCL_ESTADOCONTRATO.VALOR1 ,'[^,]+', 1, LEVEL)FROM DUAL
                CONNECT BY REGEXP_SUBSTR(   PCL_ESTADOCONTRATO.VALOR1 , '[^,]+', 1, LEVEL) IS NOT NULL
                )             
            ) DOCU  
            WHERE (
                     (
                        DOCU.TIPOARCHIVO IN   
                            (       
                            SELECT REGEXP_SUBSTR(   PCL_DOCUMENTOSSD.VALOR1 ,'[^,]+', 1, LEVEL)FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(   PCL_DOCUMENTOSSD .VALOR1 , '[^,]+', 1, LEVEL) IS NOT NULL
                            )                  
                            OR                
                        DOCU.NOMBREDOCUMENTO  IN
                            (       
                            SELECT REGEXP_SUBSTR(  PCL_DOCUMENTOSSD .VALOR3 ,'[^,]+', 1, LEVEL)FROM DUAL
                            CONNECT BY REGEXP_SUBSTR( PCL_DOCUMENTOSSD.VALOR3 , '[^,]+', 1, LEVEL) IS NOT NULL
                            )              
                        )             
                        AND    DOCU.TIPOTRIBUTARIO =  PCL_TIPOPERSONA.VALOR1
                    )
                    OR
                    ( 
                     (
                        DOCU.TIPOARCHIVO IN   
                            (       
                            SELECT REGEXP_SUBSTR(   PCL_DOCUMENTOSSD.VALOR2 ,'[^,]+', 1, LEVEL)FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(   PCL_DOCUMENTOSSD .VALOR2 , '[^,]+', 1, LEVEL) IS NOT NULL
                            )                  
                            OR                
                        DOCU.NOMBREDOCUMENTO  IN
                            (       
                            SELECT REGEXP_SUBSTR(  PCL_DOCUMENTOSSD .VALOR4 ,'[^,]+', 1, LEVEL)FROM DUAL
                            CONNECT BY REGEXP_SUBSTR( PCL_DOCUMENTOSSD.VALOR4 , '[^,]+', 1, LEVEL) IS NOT NULL
                            )              
                        )             
                        AND    DOCU.TIPOTRIBUTARIO =  PCL_TIPOPERSONA.VALOR3
            ) ;
 
     
       PV_MENSAJE   := 'Tansaccion realizada correctamente';
       PV_STATUS    := 'OK';
       DBMS_OUTPUT.PUT_LINE(PV_MENSAJE );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           PV_STATUS     := 'ERROR'; 
           PV_MENSAJE    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'DOCUMENTOS A TRANFERIR A SECURITY DATA',
           'DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA.P_DOCUMENTOS_PENDIENTES',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_DOCUMENTOS_PENDIENTES;   
   
    PROCEDURE P_DOCUMENTOS_PROCESADOS(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE OUT SYS_REFCURSOR)AS 
      
       LV_CODEMPRESA   VARCHAR2(100);     
       LV_USRCREACION  VARCHAR2(100);
       LV_CLIENTIP     VARCHAR2(100);     
       LV_PARAMETROCAB VARCHAR2(100);   
         
       PCL_TIPOPERSONA    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       PCL_ESTADOS        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       PCL_DIAPROCESADO   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       PCL_ESTADOCONTRATO DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       PCL_ESTADOFIRMA DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       
       BEGIN  

       LV_PARAMETROCAB 	         := 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA' ;  
      
       APEX_JSON.PARSE(PCL_REQUEST); 
       LV_CODEMPRESA             := APEX_JSON.GET_VARCHAR2(P_PATH => 'strCodEmpresa');    
       LV_USRCREACION            := APEX_JSON.GET_VARCHAR2(P_PATH => 'strUsrCreacion'); 
       LV_CLIENTIP               := APEX_JSON.GET_VARCHAR2(P_PATH => 'strClientIp'); 
         
       PCL_TIPOPERSONA           := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'TIPO_PERSONA');
	   PCL_ESTADOS               := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADOS_PROCESO'); 
       PCL_DIAPROCESADO          := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'DIA_PROCESADO'); 
       PCL_ESTADOCONTRATO        := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADOS_CONTRATO'); 
       PCL_ESTADOFIRMA           := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADO_FIRMA'); 
       
        OPEN PCL_RESPONSE FOR  
        SELECT  DOC.*  FROM ( 
        
                    SELECT  
                    INCD.ID_CERTIFICADO_DOCUMENTO,            
                    (INCE.NOMBRES ||' '||INCE.PRIMER_APELLIDO||' '||INCE.SEGUNDO_APELLIDO) AS NOMBRECOMPLETO, 
                    INCE.NUM_CEDULA                                                        AS CEDULA,          
                    REPLACE(INCE.SERIAL_NUMBER,'-'||INCE.NUM_CEDULA,'')                    AS SERIAL,       
                    INCD.SRC                    AS RUTAARCHIVO, 
                    ATDG.CODIGO_TIPO_DOCUMENTO  AS TIPOARCHIVO,          
                    INCE.NUM_CEDULA||'-'|| ( CASE 
                    WHEN ATDG.CODIGO_TIPO_DOCUMENTO !=  'OTR' AND ATDG.CODIGO_TIPO_DOCUMENTO !=  'CONT'    
                    THEN  REGEXP_REPLACE(ATDG.DESCRIPCION_TIPO_DOCUMENTO , '  *', '_' )
                    ELSE  REGEXP_REPLACE(REGEXP_SUBSTR( INDO.NOMBRE_DOCUMENTO  , '[^/]+$', 1, 1) , '-[^/]+$', '' )   END 
                    )||'.' ||ATDO.EXTENSION_TIPO_DOCUMENTO AS NOMBREARCHIVO,   
                    REGEXP_REPLACE(REGEXP_SUBSTR( INDO.NOMBRE_DOCUMENTO  , '[^/]+$', 1, 1) , '-[^/]+$', '' )  AS NOMBREDOCUMENTO,   
                    (CASE  INCE.PERSONA_NATURAL  
                     WHEN  PCL_TIPOPERSONA.VALOR1   THEN  PCL_TIPOPERSONA.VALOR2
                     WHEN  PCL_TIPOPERSONA.VALOR3   THEN  PCL_TIPOPERSONA.VALOR4
                     ELSE NULL END ) AS TIPOPERSONA,  
                    INCE.PERSONA_NATURAL  AS TIPOTRIBUTARIO,   
                     (CASE  INCD.DOCUMENTADO 
                     WHEN  PCL_ESTADOS.VALOR2
                     THEN  PCL_ESTADOS.VALOR1
                     ELSE PCL_ESTADOS.VALOR3  END )    AS ESTADO,              
                    INCD.INTENTOS                      AS INTENTOS,
                    INCD.OBSERVACION                   AS OBSERVACION,      
                    INCD.FE_ULT_MOD                    AS FECHAEJECUCION,
                    INCD.FE_CREACION                   AS FECHARECEPCION,   
                   
                  (
                    SELECT INPU2.LOGIN FROM   
                    DB_COMERCIAL.INFO_ADENDUM INAD2,
                    DB_COMERCIAL.INFO_PUNTO INPU2,
                    DB_COMUNICACION.INFO_DOCUMENTO_RELACION IDRE2
                    WHERE INAD2.PUNTO_ID   = INPU2.ID_PUNTO  
                    AND IDRE2.CONTRATO_ID  = INAD2.CONTRATO_ID  
                    AND IDRE2.CONTRATO_ID  = INDO.CONTRATO_ID 
                    AND IDRE2.DOCUMENTO_ID  = INDO.ID_DOCUMENTO                   
                    AND (INAD2.NUMERO = IDRE2.NUMERO_ADENDUM OR (INAD2.NUMERO IS NULL AND IDRE2.NUMERO_ADENDUM IS NULL ))
                    AND ROWNUM = 1 
                    )AS LOGIN 
                    
                    FROM
                    DB_COMUNICACION.INFO_DOCUMENTO INDO,
                    DB_COMUNICACION.ADMI_TIPO_DOCUMENTO ATDO,
                    DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL ATDG,    
                    DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO INCD,
                    DB_FIRMAELECT.INFO_CERTIFICADO INCE,     
                    DB_COMERCIAL.INFO_PERSONA INPE ,
                    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER , 
                    DB_COMERCIAL.INFO_CONTRATO ICON   
                   
            WHERE INDO.TIPO_DOCUMENTO_ID = ATDO.ID_TIPO_DOCUMENTO 
            AND INDO.TIPO_DOCUMENTO_GENERAL_ID = ATDG.ID_TIPO_DOCUMENTO             
            AND INDO.UBICACION_FISICA_DOCUMENTO = INCD.SRC  
            AND INCD.CERTIFICADO_ID = INCE.ID_CERTIFICADO 
            AND INCE.NUM_CEDULA =  INPE.IDENTIFICACION_CLIENTE
            AND INCE.ESTADO IN   
                (       
                 SELECT REGEXP_SUBSTR(   PCL_ESTADOFIRMA.VALOR1 ,'[^,]+', 1, LEVEL)FROM DUAL
                 CONNECT BY REGEXP_SUBSTR( PCL_ESTADOFIRMA.VALOR1 , '[^,]+', 1, LEVEL) IS NOT NULL
                ) 
            AND INPE.ID_PERSONA  = IPER.PERSONA_ID
            AND IPER.ID_PERSONA_ROL =  ICON.PERSONA_EMPRESA_ROL_ID 
            AND IPER.ESTADO ='Activo'  
            AND IPER.EMPRESA_ROL_ID = 813   
            AND ICON.ID_CONTRATO = INDO.CONTRATO_ID
            AND ICON.ESTADO   IN   
                (       
                 SELECT REGEXP_SUBSTR(   PCL_ESTADOCONTRATO.VALOR1 ,'[^,]+', 1, LEVEL)FROM DUAL
                 CONNECT BY REGEXP_SUBSTR(   PCL_ESTADOCONTRATO.VALOR1 , '[^,]+', 1, LEVEL) IS NOT NULL
                )           
   
            AND  INCD.FE_ULT_MOD >= SYSDATE -TO_NUMBER(PCL_DIAPROCESADO.VALOR1) 
            ) DOC      
            ORDER BY  DOC.FECHAEJECUCION  ASC, DOC.INTENTOS DESC ;    
           
            
              
     
       PV_MENSAJE   := 'Tansaccion realizada correctamente';
       PV_STATUS    := 'OK';
       DBMS_OUTPUT.PUT_LINE(PV_MENSAJE );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           PV_STATUS     := 'ERROR'; 
           PV_MENSAJE    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'DOCUMENTOS A TRANFERIR A SECURITY DATA',
           'DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA.P_DOCUMENTOS_PROCESADOS',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_DOCUMENTOS_PROCESADOS;   
        
    
    PROCEDURE P_DOCUMENTOS_PENDIENTES_ACT(PCL_REQUEST IN CLOB,PV_MENSAJE OUT VARCHAR2,PV_STATUS OUT VARCHAR2,PCL_RESPONSE OUT SYS_REFCURSOR)AS 
      
       LV_CODEMPRESA VARCHAR2(100);     
       LV_USRCREACION VARCHAR2(100);
       LV_CLIENTIP VARCHAR2(100);     
       LV_PARAMETROCAB VARCHAR2(100);  
       LN_COUNTDOCUMENTOS  NUMBER;
       
       PCL_USUARIOSD                 DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;        
       PCL_TIPOPERSONA               DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       PCL_ESTADOS                   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       PCL_INFOCERTIFICADO           DB_FIRMAELECT.INFO_CERTIFICADO%ROWTYPE;
       PCL_INFOCERTIFICADODOCUMENTO  DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO%ROWTYPE;
      
       
       BEGIN  

       LV_PARAMETROCAB 	         := 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA' ;  
      
       APEX_JSON.PARSE(PCL_REQUEST); 
       LV_CODEMPRESA             := APEX_JSON.GET_VARCHAR2(P_PATH => 'strCodEmpresa');    
       LV_USRCREACION            := APEX_JSON.GET_VARCHAR2(P_PATH => 'strUsrCreacion'); 
       LV_CLIENTIP               := APEX_JSON.GET_VARCHAR2(P_PATH => 'strClientIp'); 
       LN_COUNTDOCUMENTOS        := APEX_JSON.GET_COUNT(P_PATH => 'objDocumentos');       
 	   PCL_ESTADOS               := F_DATA_PARAMETRO(LV_PARAMETROCAB , 'ESTADOS_PROCESO');
       
          FOR I IN 1 ..  LN_COUNTDOCUMENTOS
                LOOP       
                PCL_INFOCERTIFICADODOCUMENTO :=NULL; 
                PCL_INFOCERTIFICADODOCUMENTO.ID_CERTIFICADO_DOCUMENTO := APEX_JSON.GET_VARCHAR2 ('objDocumentos[%d].idCertificadoDocumento', I); 
                PCL_INFOCERTIFICADODOCUMENTO.OBSERVACION := APEX_JSON.GET_CLOB('objDocumentos[%d].observacion', I);         
                PCL_INFOCERTIFICADODOCUMENTO.INTENTOS    := APEX_JSON.GET_VARCHAR2 ('objDocumentos[%d].intentos', I); 
                PCL_INFOCERTIFICADODOCUMENTO.FE_ULT_MOD  := SYSDATE;                 
 	    
               IF  APEX_JSON.GET_VARCHAR2 ('objDocumentos[%d].estado', I) =   PCL_ESTADOS.VALOR1   THEN
                PCL_INFOCERTIFICADODOCUMENTO.DOCUMENTADO :=PCL_ESTADOS.VALOR2;
               ELSE 
                PCL_INFOCERTIFICADODOCUMENTO.DOCUMENTADO :=PCL_ESTADOS.VALOR4;
               END IF ;
               
               UPDATE DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO  ICD
               SET  
               ICD.OBSERVACION = PCL_INFOCERTIFICADODOCUMENTO.OBSERVACION, 
               ICD.DOCUMENTADO = PCL_INFOCERTIFICADODOCUMENTO.DOCUMENTADO , 
               ICD.INTENTOS    = PCL_INFOCERTIFICADODOCUMENTO.INTENTOS,
               ICD.FE_ULT_MOD  = PCL_INFOCERTIFICADODOCUMENTO.FE_ULT_MOD
               WHERE  ICD.ID_CERTIFICADO_DOCUMENTO = PCL_INFOCERTIFICADODOCUMENTO.ID_CERTIFICADO_DOCUMENTO ; 
               COMMIT;
            END LOOP;
                
                
        
       PV_MENSAJE   := 'Tansaccion realizada correctamente';
       PV_STATUS    := 'OK';
       DBMS_OUTPUT.PUT_LINE(PV_MENSAJE );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           PV_STATUS     := 'ERROR'; 
           PV_MENSAJE    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'DOCUMENTOS A TRANFERIR A SECURITY DATA',
           'DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA.P_DOCUMENTOS_PENDIENTES_ACT',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_DOCUMENTOS_PENDIENTES_ACT;   
   
 
END CMKG_TRANSF_SECURITY_DATA;       
 
/
 