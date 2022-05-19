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
    FUNCTION  F_DATA_PARAMETRO(Fv_NombreParametro IN VARCHAR2,Fv_Descripcion IN VARCHAR2) RETURN   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
   
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
    PROCEDURE P_DOCUMENTOS_PENDIENTES(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response  OUT SYS_REFCURSOR);
 
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
    PROCEDURE P_DOCUMENTOS_PROCESADOS(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response  OUT SYS_REFCURSOR);

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
    PROCEDURE P_DOCUMENTOS_PENDIENTES_ACT(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response  OUT SYS_REFCURSOR);


END CMKG_TRANSF_SECURITY_DATA;

/


create or replace PACKAGE BODY  DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA AS

    FUNCTION  F_DATA_PARAMETRO(Fv_NombreParametro IN VARCHAR2,Fv_Descripcion IN VARCHAR2) 
        RETURN   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  AS
        Pcl_Detalle  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
        Pv_Mensaje  VARCHAR2(500); 
                 
        CURSOR C_GetDataParametro( Fv_NombreParametro VARCHAR2,Fv_Descripcion VARCHAR2) IS
        SELECT apd.* FROM DB_GENERAL.ADMI_PARAMETRO_DET apd 
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc ON apd.PARAMETRO_ID =  apc.ID_PARAMETRO 
        WHERE apc.ESTADO  = 'Activo' 
        AND  apd.ESTADO  = 'Activo'
        AND  apc.NOMBRE_PARAMETRO =  Fv_NombreParametro 
        AND  apd.DESCRIPCION =  Fv_Descripcion; 
       
        BEGIN 	       
          	OPEN C_GetDataParametro(Fv_NombreParametro,Fv_Descripcion); 
		    FETCH C_GetDataParametro INTO  Pcl_Detalle;     
		    CLOSE C_GetDataParametro;	
	      IF ( Pcl_Detalle.VALOR1 IS   NULL)  THEN 
	             Pv_Mensaje := 'No existe el valor de '||Fv_Descripcion||' en el parametro '||Fv_NombreParametro||'.';
	             dbms_output.put_line( Pv_Mensaje );  
	             RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
	      END IF; 
	    RETURN   Pcl_Detalle;
    END F_DATA_PARAMETRO;  

    PROCEDURE P_DOCUMENTOS_PENDIENTES(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response OUT SYS_REFCURSOR)AS 
      
       Lv_CodEmpresa   VARCHAR2(100);     
       Lv_UsrCreacion  VARCHAR2(100);
       Lv_ClientIp     VARCHAR2(100);  
       Lv_ParametroCab VARCHAR2(100);   
       Ln_CantidadProcesar NUMBER; 
       
       Pcl_UsuarioSd       DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       Pcl_TipoPersona     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       Pcl_Estados         DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;   
       Pcl_DocumentosSd    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;        
       Pcl_EstadoContrato  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       BEGIN  

       Lv_ParametroCab 	         := 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA' ;  
      
       APEX_JSON.PARSE(Pcl_Request); 
       Lv_CodEmpresa             := APEX_JSON.get_varchar2(p_path => 'strCodEmpresa');    
       Lv_UsrCreacion            := APEX_JSON.get_varchar2(p_path => 'strUsrCreacion'); 
       Lv_ClientIp               := APEX_JSON.get_varchar2(p_path => 'strClientIp'); 
                  
       Pcl_UsuarioSd             := F_DATA_PARAMETRO(Lv_ParametroCab , 'WS_NOMBRE_USUARIO');
       Pcl_TipoPersona           := F_DATA_PARAMETRO(Lv_ParametroCab , 'TIPO_PERSONA');
	   Pcl_Estados               := F_DATA_PARAMETRO(Lv_ParametroCab , 'ESTADOS_PROCESO');
       Pcl_DocumentosSd          := F_DATA_PARAMETRO(Lv_ParametroCab , 'DOCUMENTOS_SD');  
       Pcl_EstadoContrato        := F_DATA_PARAMETRO(Lv_ParametroCab , 'ESTADOS_CONTRATO'); 
         
       Ln_CantidadProcesar       := 10000; 
       
        OPEN Pcl_Response FOR 
        SELECT  doc.*  FROM ( 
        
                    SELECT  
                    icd.ID_CERTIFICADO_DOCUMENTO,            
                    (ic.NOMBRES ||' '||ic.PRIMER_APELLIDO||' '||ic.SEGUNDO_APELLIDO) AS nombreCompleto, 
                    ic.NUM_CEDULA               AS cedula,    
                    ic.SERIAL_NUMBER            AS serial,              
                    Pcl_UsuarioSd.VALOR1        AS usuario,               
                    icd.SRC                     AS rutaArchivo, 
                    atdg.CODIGO_TIPO_DOCUMENTO  As tipoArchivo,  
                    
                    ic.NUM_CEDULA||'-'||
                    (
                    CASE 
                    WHEN atdg.CODIGO_TIPO_DOCUMENTO !=  'OTR' AND atdg.CODIGO_TIPO_DOCUMENTO !=  'CONT'    
                    THEN  regexp_replace(atdg.DESCRIPCION_TIPO_DOCUMENTO , '  *', '_' )
                    ELSE doc.NOMBRE_DOCUMENTO  END 
                    ) 
                    ||'.' ||atd.EXTENSION_TIPO_DOCUMENTO AS nombreArchivo, 
                    doc.NOMBRE_DOCUMENTO AS nombreDocumento,   
                    (CASE  ic.PERSONA_NATURAL  
                    WHEN  Pcl_TipoPersona.VALOR1   THEN  Pcl_TipoPersona.VALOR2
                    WHEN  Pcl_TipoPersona.VALOR3   THEN  Pcl_TipoPersona.VALOR4
                    ELSE NULL END ) AS tipoPersona,  
                    ic.PERSONA_NATURAL AS tipoTributario,    
                    icd.DOCUMENTADO              AS estado,
                    COALESCE(icd.INTENTOS,0)     AS intentos,
                    icd.OBSERVACION              AS observacion  
                    
                    FROM DB_FIRMAELECT.INFO_CERTIFICADO ic  
                    INNER JOIN DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO icd ON icd.CERTIFICADO_ID = ic.ID_CERTIFICADO
                    INNER JOIN (
                    SELECT 
                    doc.ID_DOCUMENTO,
                    doc.TIPO_DOCUMENTO_ID,
                    doc.TIPO_DOCUMENTO_GENERAL_ID,
                    doc.UBICACION_FISICA_DOCUMENTO,
                    regexp_replace(regexp_substr( doc.NOMBRE_DOCUMENTO  , '[^/]+$', 1, 1) , '-[^/]+$', '' ) AS NOMBRE_DOCUMENTO 
                    FROM DB_COMUNICACION.INFO_DOCUMENTO doc
                    ) doc  ON doc.UBICACION_FISICA_DOCUMENTO = icd.SRC    
                    INNER JOIN DB_COMUNICACION.INFO_DOCUMENTO_RELACION idr ON idr.DOCUMENTO_ID = doc.ID_DOCUMENTO
                    INNER JOIN DB_COMUNICACION.ADMI_TIPO_DOCUMENTO atd ON   atd.ID_TIPO_DOCUMENTO = doc.TIPO_DOCUMENTO_ID
                    INNER JOIN DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL atdg ON atdg.ID_TIPO_DOCUMENTO = doc.TIPO_DOCUMENTO_GENERAL_ID
                    INNER JOIN DB_COMERCIAL.INFO_ADENDUM id ON  id.CONTRATO_ID = idr.CONTRATO_ID
                    INNER JOIN DB_COMERCIAL.INFO_CONTRATO ic2 ON ic2.ID_CONTRATO = id.CONTRATO_ID 
                    AND ( id.NUMERO = idr.NUMERO_ADENDUM  OR ( id.NUMERO IS NULL AND idr.NUMERO_ADENDUM  IS NULL)) 
                   
            WHERE icd.DOCUMENTADO != Pcl_Estados.VALOR2 
            AND   rownum <= Ln_CantidadProcesar
            AND   icd.SRC LIKE 'http%'     
            AND   ic2.ESTADO   IN   
                    (       
                    select regexp_substr(   Pcl_EstadoContrato.VALOR1 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr(   Pcl_EstadoContrato.VALOR1 , '[^,]+', 1, level) is not null
                    ) 
            AND  id.ESTADO   IN   
                    (       
                    select regexp_substr(   Pcl_EstadoContrato.VALOR1 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr(   Pcl_EstadoContrato.VALOR1 , '[^,]+', 1, level) is not null
                    )  
                    
            ORDER BY  icd.fe_creacion ASC, icd.intentos DESC     
            ) doc            
           WHERE        
           ( 
               (
                   doc.tipoArchivo IN   
                    (       
                    select regexp_substr(   Pcl_DocumentosSd.VALOR1 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr(   Pcl_DocumentosSd .VALOR1 , '[^,]+', 1, level) is not null
                    )                  
                    OR                
                   doc.nombreDocumento  IN
                    (       
                    select regexp_substr(  Pcl_DocumentosSd .VALOR3 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr( Pcl_DocumentosSd.VALOR3 , '[^,]+', 1, level) is not null
                    )              
                )             
                AND    doc.tipoTributario =  Pcl_TipoPersona.VALOR1
            )
            OR
            ( 
               (
                   doc.tipoArchivo IN   
                    (       
                    select regexp_substr(   Pcl_DocumentosSd.VALOR2 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr(   Pcl_DocumentosSd .VALOR2 , '[^,]+', 1, level) is not null
                    )                  
                    OR                
                   doc.nombreDocumento  IN
                    (       
                    select regexp_substr(  Pcl_DocumentosSd .VALOR4 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr( Pcl_DocumentosSd.VALOR4 , '[^,]+', 1, level) is not null
                    )              
                )             
                AND    doc.tipoTributario =  Pcl_TipoPersona.VALOR3
            )
            
            ;    
             
             
     
       Pv_Mensaje   := 'Tansaccion realizada correctamente';
       Pv_Status    := 'OK';
       dbms_output.put_line(Pv_Mensaje );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           Pv_Status     := 'ERROR'; 
           Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'DOCUMENTOS A TRANFERIR A SECURITY DATA',
           'DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA.P_DOCUMENTOS_PENDIENTES',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_DOCUMENTOS_PENDIENTES;   
   
    PROCEDURE P_DOCUMENTOS_PROCESADOS(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response OUT SYS_REFCURSOR)AS 
      
       Lv_CodEmpresa   VARCHAR2(100);     
       Lv_UsrCreacion  VARCHAR2(100);
       Lv_ClientIp     VARCHAR2(100);     
       Lv_ParametroCab VARCHAR2(100);   
       
       Pcl_UsuarioSd      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;        
       Pcl_TipoPersona    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       Pcl_Estados        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       Pcl_DiaProcesado   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       Pcl_DocumentosSd   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       Pcl_EstadoContrato DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       
       BEGIN  

       Lv_ParametroCab 	         := 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA' ;  
      
       APEX_JSON.PARSE(Pcl_Request); 
       Lv_CodEmpresa             := APEX_JSON.get_varchar2(p_path => 'strCodEmpresa');    
       Lv_UsrCreacion            := APEX_JSON.get_varchar2(p_path => 'strUsrCreacion'); 
       Lv_ClientIp               := APEX_JSON.get_varchar2(p_path => 'strClientIp'); 
        
       Pcl_UsuarioSd             := F_DATA_PARAMETRO(Lv_ParametroCab , 'WS_NOMBRE_USUARIO');	 
       Pcl_TipoPersona           := F_DATA_PARAMETRO(Lv_ParametroCab , 'TIPO_PERSONA');
	   Pcl_Estados               := F_DATA_PARAMETRO(Lv_ParametroCab , 'ESTADOS_PROCESO'); 
       Pcl_DiaProcesado          := F_DATA_PARAMETRO(Lv_ParametroCab , 'DIA_PROCESADO');
       Pcl_DocumentosSd          := F_DATA_PARAMETRO(Lv_ParametroCab , 'DOCUMENTOS_SD');
       Pcl_EstadoContrato        := F_DATA_PARAMETRO(Lv_ParametroCab , 'ESTADOS_CONTRATO'); 
       
        OPEN Pcl_Response FOR  
        SELECT  doc.*  FROM ( 
        
                    SELECT  
                    icd.ID_CERTIFICADO_DOCUMENTO,            
                    (ic.NOMBRES ||' '||ic.PRIMER_APELLIDO||' '||ic.SEGUNDO_APELLIDO) AS nombreCompleto, 
                    ic.NUM_CEDULA               AS cedula,    
                    ic.SERIAL_NUMBER            AS serial,              
                    Pcl_UsuarioSd.VALOR1        AS usuario,               
                    icd.SRC                     AS rutaArchivo, 
                    atdg.CODIGO_TIPO_DOCUMENTO  As tipoArchivo,  
                    
                    ic.NUM_CEDULA||'-'||
                    (
                    CASE 
                    WHEN atdg.CODIGO_TIPO_DOCUMENTO !=  'OTR' AND atdg.CODIGO_TIPO_DOCUMENTO !=  'CONT'    
                    THEN  regexp_replace(atdg.DESCRIPCION_TIPO_DOCUMENTO , '  *', '_' )
                    ELSE doc.NOMBRE_DOCUMENTO  END 
                    ) 
                    ||'.' ||atd.EXTENSION_TIPO_DOCUMENTO AS nombreArchivo, 
                    doc.NOMBRE_DOCUMENTO AS nombreDocumento,   
                    (CASE  ic.PERSONA_NATURAL  
                    WHEN  Pcl_TipoPersona.VALOR1   THEN  Pcl_TipoPersona.VALOR2
                    WHEN  Pcl_TipoPersona.VALOR3   THEN  Pcl_TipoPersona.VALOR4
                    ELSE NULL END ) AS tipoPersona,  
                    ic.PERSONA_NATURAL AS tipoTributario,   
                    
                    ip.login                          AS login, 
                    (CASE  icd.DOCUMENTADO 
                    WHEN  Pcl_Estados.VALOR2
                    THEN  Pcl_Estados.VALOR1
                    ELSE Pcl_Estados.VALOR3  END )    AS estado,              
                    COALESCE(icd.INTENTOS,0)          AS intentos,
                    icd.OBSERVACION                   AS observacion,      
                    icd.FE_ULT_MOD                    AS fechaEjecucion,
                    icd.FE_CREACION                   AS fechaRecepcion

                    
                    FROM DB_FIRMAELECT.INFO_CERTIFICADO ic  
                    INNER JOIN DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO icd ON icd.CERTIFICADO_ID = ic.ID_CERTIFICADO
                    INNER JOIN (
                    SELECT 
                    doc.ID_DOCUMENTO,
                    doc.TIPO_DOCUMENTO_ID,
                    doc.TIPO_DOCUMENTO_GENERAL_ID,
                    doc.UBICACION_FISICA_DOCUMENTO,
                    regexp_replace(regexp_substr( doc.NOMBRE_DOCUMENTO  , '[^/]+$', 1, 1) , '-[^/]+$', '' ) AS NOMBRE_DOCUMENTO 
                    FROM DB_COMUNICACION.INFO_DOCUMENTO doc
                    ) doc  ON doc.UBICACION_FISICA_DOCUMENTO = icd.SRC    
                    INNER JOIN DB_COMUNICACION.INFO_DOCUMENTO_RELACION idr ON idr.DOCUMENTO_ID = doc.ID_DOCUMENTO
                    INNER JOIN DB_COMUNICACION.ADMI_TIPO_DOCUMENTO atd ON   atd.ID_TIPO_DOCUMENTO = doc.TIPO_DOCUMENTO_ID
                    INNER JOIN DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL atdg ON atdg.ID_TIPO_DOCUMENTO = doc.TIPO_DOCUMENTO_GENERAL_ID
                    INNER JOIN DB_COMERCIAL.INFO_ADENDUM id ON  id.CONTRATO_ID = idr.CONTRATO_ID
                    INNER JOIN DB_COMERCIAL.INFO_CONTRATO ic2 ON ic2.ID_CONTRATO = id.CONTRATO_ID 
                    INNER JOIN DB_COMERCIAL.INFO_PUNTO ip ON ip.id_punto = id.punto_id
                    AND ( id.NUMERO = idr.NUMERO_ADENDUM  OR ( id.NUMERO IS NULL AND idr.NUMERO_ADENDUM  IS NULL)) 
                   
            WHERE COALESCE(icd.INTENTOS,0) > 0  
            AND  (trunc(sysdate)-cast(trunc(icd.fe_ult_mod) AS date )) <=  Pcl_DiaProcesado.VALOR1 
            AND  ic2.ESTADO   IN   
                    (       
                    select regexp_substr(   Pcl_EstadoContrato.VALOR1 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr(   Pcl_EstadoContrato.VALOR1 , '[^,]+', 1, level) is not null
                    ) 
            AND  id.ESTADO   IN   
                    (       
                    select regexp_substr(   Pcl_EstadoContrato.VALOR1 ,'[^,]+', 1, level)from dual
                    connect by regexp_substr(   Pcl_EstadoContrato.VALOR1 , '[^,]+', 1, level) is not null
                    )                      
           
            ) doc      
            ORDER BY  doc.fechaEjecucion  ASC, doc.intentos DESC ;   
           
            
              
     
       Pv_Mensaje   := 'Tansaccion realizada correctamente';
       Pv_Status    := 'OK';
       dbms_output.put_line(Pv_Mensaje );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           Pv_Status     := 'ERROR'; 
           Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'DOCUMENTOS A TRANFERIR A SECURITY DATA',
           'DB_COMERCIAL.CMKG_TRANSF_SECURITY_DATA.P_DOCUMENTOS_PROCESADOS',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_DOCUMENTOS_PROCESADOS;   
        
    
    PROCEDURE P_DOCUMENTOS_PENDIENTES_ACT(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response OUT SYS_REFCURSOR)AS 
      
       Lv_CodEmpresa VARCHAR2(100);     
       Lv_UsrCreacion VARCHAR2(100);
       Lv_ClientIp VARCHAR2(100);     
       Lv_ParametroCab VARCHAR2(100);  
       Ln_CountDocumentos  NUMBER;
       
       Pcl_UsuarioSd                 DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;        
       Pcl_TipoPersona               DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
       Pcl_Estados                   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE; 
       Pcl_InfoCertificado           DB_FIRMAELECT.INFO_CERTIFICADO%ROWTYPE;
       Pcl_InfoCertificadoDocumento  DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO%ROWTYPE;
      
       
       BEGIN  

       Lv_ParametroCab 	         := 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA' ;  
      
       APEX_JSON.PARSE(Pcl_Request); 
       Lv_CodEmpresa             := APEX_JSON.get_varchar2(p_path => 'strCodEmpresa');    
       Lv_UsrCreacion            := APEX_JSON.get_varchar2(p_path => 'strUsrCreacion'); 
       Lv_ClientIp               := APEX_JSON.get_varchar2(p_path => 'strClientIp'); 
       Ln_CountDocumentos        := APEX_JSON.get_count(p_path => 'objDocumentos');       
 	   Pcl_Estados               := F_DATA_PARAMETRO(Lv_ParametroCab , 'ESTADOS_PROCESO');
       
          FOR i IN 1 ..  Ln_CountDocumentos
                LOOP       
                Pcl_InfoCertificadoDocumento :=null; 
                Pcl_InfoCertificadoDocumento.id_certificado_documento := apex_json.get_varchar2 ('objDocumentos[%d].idCertificadoDocumento', i); 
                Pcl_InfoCertificadoDocumento.observacion := apex_json.get_clob('objDocumentos[%d].observacion', i);         
                Pcl_InfoCertificadoDocumento.intentos    := apex_json.get_varchar2 ('objDocumentos[%d].intentos', i); 
                Pcl_InfoCertificadoDocumento.fe_ult_mod  := sysdate;                 
 	    
               IF  apex_json.get_varchar2 ('objDocumentos[%d].estado', i) =   Pcl_Estados.VALOR1   THEN
                Pcl_InfoCertificadoDocumento.documentado :=Pcl_Estados.VALOR2;
               ELSE 
                Pcl_InfoCertificadoDocumento.documentado :=Pcl_Estados.VALOR4;
               END IF ;
               
               UPDATE DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO  ICD
               SET  
               icd.observacion = Pcl_InfoCertificadoDocumento.observacion, 
               icd.documentado = Pcl_InfoCertificadoDocumento.documentado , 
               icd.intentos    = Pcl_InfoCertificadoDocumento.intentos,
               icd.fe_ult_mod  = Pcl_InfoCertificadoDocumento.fe_ult_mod
               WHERE  ICD.id_certificado_documento = Pcl_InfoCertificadoDocumento.id_certificado_documento ; 
               COMMIT;
            END LOOP;
                
                
        
       Pv_Mensaje   := 'Tansaccion realizada correctamente';
       Pv_Status    := 'OK';
       dbms_output.put_line(Pv_Mensaje );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           Pv_Status     := 'ERROR'; 
           Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
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
 