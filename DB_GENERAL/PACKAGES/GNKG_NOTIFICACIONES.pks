CREATE OR REPLACE package DB_GENERAL.GNKG_NOTIFICACIONES IS
  /*
   * Documentacion para TYPE 'Lr_Token'.
   * Record que me permite obtener el registro foma de contacto token de cliente
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0
   * @since 15-02-2023
   *
   */
  TYPE Lr_Datos_Cliente IS RECORD (
    LOGIN            VARCHAR2(200),
    MENSAJE          CLOB
   );

    TYPE Ltr_Datos_Cliente IS TABLE OF Lr_Datos_Cliente INDEX BY varchar2(20);

  /*
   * Documentacion para TYPE 'Lr_Token'.
   * Record que me permite obtener el registro foma de contacto token de cliente
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0
   * @since 15-02-2023
   *
   */
  TYPE Lr_Token IS RECORD (
    TOKEN                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE,
    IDENTIFICACION_CLIENTE DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE
   );

  /*
   * Documentacion para TYPE 'Lr_Token'.
   * Record que me permite obtener los registros de contactos token de los clientes
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0
   * @since 15-02-2023
   *
   */
  TYPE Ltr_Token IS TABLE OF Lr_Token INDEX BY binary_integer;

  /**
   * Documentaci�n para el procedimiento P_GET_CONTACTO_CLIENTE
   *
   * Metodo encargado de obtener contactData del cleinete para diferentes canales de notificaciones
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   *
   * [
   *  identification   identificacion del cliente
   *  channel   	   canal de la notificacion para obtener el contactData 
   * ]
   *
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response   OUT  CLOB Retorna json de la consulta
   *
   * @author  Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 
   * @since   01-02-2023
   */                           
  PROCEDURE P_GET_CONTACTO_CLIENTE(Pcl_Request  IN CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT CLOB);
      /**
   * Documentaci�n para el procedimiento P_TOKEN_NOTIFICACION_PUSH
   *
   * Metodo encargado de obtener contactData del cliente para canal push
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response   OUT  CLOB Retorna json de la consulta
   *
   * @author  Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 
   * @since   01-02-2023
   */                                   
  PROCEDURE P_TOKEN_NOTIFICACION_PUSH(Pcl_Request  IN CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT CLOB);

 /**
   * Documentaci�n para el procedimiento P_LOTES_CLIENTES_NOTI_PUSH
   *
   * Metodo encargado de obtener urls de nfs para envio clientes masivos
   *
   * @param Pn_LimitArchivo    IN   NUMBER limite de registros por csv
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response   OUT  CLOB Retorna json de la consulta
   *
   * @author  Andrea Orellana <adorellana@telconet.ec>
   * @version 1.0 
   * @since   13-03-2023
   */

  PROCEDURE P_LOTES_CLIENTES_NOTI_PUSH(Pn_LimitArchivo IN  NUMBER,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT CLOB);                                        

END GNKG_NOTIFICACIONES;
/

CREATE OR REPLACE package body DB_GENERAL.GNKG_NOTIFICACIONES IS

 PROCEDURE P_GET_CONTACTO_CLIENTE(Pcl_Request  IN CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT CLOB) AS 
  
  Lcl_Response      CLOB;
  Lv_Canal          varchar2(50);
  Lv_Contacto       varchar2(3000);
  Lv_Status         varchar2(10);
  Lv_Mensaje        varchar2(250);
  Lv_Error          varchar2(250);
  Le_Error          EXCEPTION;
 BEGIN 
	 APEX_JSON.PARSE(Pcl_Request);
	 Lv_Canal          :=  APEX_JSON.get_varchar2(p_path => 'channel');

	 IF Lv_Canal = 'PUSH_NOTIFICATION' THEN
		P_TOKEN_NOTIFICACION_PUSH(Pcl_Request,Lv_Status,Lv_Mensaje,Lcl_Response);	    
	 ELSIF Lv_Canal = 'SMS_NOTIFICATION' THEN
 		 DBMS_OUTPUT.put_line ('llamar proceso de sms');
	 ELSIF Lv_Canal = 'MAIL_NOTIFICATION' THEN
		 DBMS_OUTPUT.put_line ('llamar proceso de mail');
	 ELSE
		  Lv_Error:= 'No esta configurado canal '||Lv_Canal||' para notificaciones';
		  raise Le_Error;
	 END IF;

     Pv_Status := Lv_Status;
     Pv_Mensaje := Lv_Mensaje;
     Pcl_Response := Lcl_Response;

 EXCEPTION
    WHEN Le_Error THEN
     Pv_Status := 'ERROR';
     Pv_Mensaje := Lv_Error;
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
 END P_GET_CONTACTO_CLIENTE;

 PROCEDURE P_TOKEN_NOTIFICACION_PUSH(Pcl_Request  IN CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT CLOB ) AS 

	 Lc_Identificacions CLOB;
	 Ln_Count_Identification NUMBER:=0;
	 Lcl_Response       CLOB;
	 Lv_Status     	    varchar2(10);
	 Lv_Mensaje         varchar2(250);
	 Le_Error      		EXCEPTION;
	 Ln_count      		NUMBER:=1;
	 Lcl_QuerySelect    CLOB;
     Lrf_Token   		SYS_REFCURSOR;
     Lv_Query  			varchar2(3000);
     Li_Cont       		PLS_INTEGER;
     ln_countList  		NUMBER:=1;
     Lr_Token           Ltr_Token;
     Lr_Datos_Cliente   Ltr_Datos_Cliente;
     Lv_Identificacion  varchar2(20);

 BEGIN 

	APEX_JSON.PARSE(Pcl_Request);
	Ln_Count_Identification :=  APEX_JSON.get_count(p_path => 'clientData');

	DBMS_LOB.CREATETEMPORARY(Lc_Identificacions, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
	APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_ARRAY();
   --  
	WHILE ln_countList <= Ln_Count_Identification LOOP
	    Lv_Identificacion := APEX_JSON.get_varchar2('clientData[%d].identification',ln_countList);
		 IF Ln_count = 1 THEN 
		    DBMS_LOB.APPEND(Lc_Identificacions,''''||Lv_Identificacion||'''');
		 ELSE
		    DBMS_LOB.APPEND(Lc_Identificacions,','''||Lv_Identificacion||'''');
		 END IF;	
		Lr_Datos_Cliente(Lv_Identificacion).LOGIN   :=APEX_JSON.get_varchar2('clientData[%d].login',ln_countList);
		Lr_Datos_Cliente(Lv_Identificacion).MENSAJE :=APEX_JSON.get_CLOB('clientData[%d].message',ln_countList); 

	    IF Ln_count = 5 OR ln_countList = Ln_Count_Identification THEN 

		    Lv_Query := 'SELECT S.VALOR TOKEN,IP.IDENTIFICACION_CLIENTE 
						   FROM DB_COMERCIAL.INFO_PERSONA IP , 
					            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
					            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC s
						  WHERE IP.ID_PERSONA = IPER.PERSONA_ID 
						    AND IP.IDENTIFICACION_CLIENTE  in (:Lv_identificacion)
							AND s.PERSONA_EMPRESA_ROL_ID = iper.ID_PERSONA_ROL 
							AND s.CARACTERISTICA_ID = (SELECT ID_CARACTERISTICA  
							                             FROM DB_COMERCIAL.ADMI_CARACTERISTICA s 
							                            WHERE s.DESCRIPCION_CARACTERISTICA = ''PUSH_ID_CLIENTE'')
							AND s.ESTADO = ''Activo''
							AND IPER.ESTADO = ''Activo''
							AND iper.EMPRESA_ROL_ID = (SELECT ier.ID_EMPRESA_ROL  
											FROM DB_COMERCIAL.INFO_EMPRESA_ROL ier ,
											     DB_COMERCIAL.admi_rol ar
											WHERE ier.ROL_ID = ar.id_rol
											AND  ier.EMPRESA_COD = 18 
											AND ar.descripcion_rol= ''Cliente''
				                            AND ier.ESTADO =''Activo''
				                            AND ar.estado=''Activo'')';

			DBMS_LOB.APPEND(Lcl_QuerySelect,REPLACE(Lv_Query, ':Lv_identificacion', Lc_Identificacions));

			OPEN Lrf_Token FOR Lcl_QuerySelect;
		    LOOP
			    FETCH Lrf_Token BULK COLLECT INTO Lr_Token LIMIT 100;
	    		Li_Cont := Lr_Token.FIRST;
	        	WHILE Li_Cont IS NOT NULL LOOP
		        	APEX_JSON.OPEN_OBJECT;
		            APEX_JSON.WRITE('identification',Lr_Token(Li_Cont).IDENTIFICACION_CLIENTE);
		           	APEX_JSON.WRITE('contactData',Lr_Token(Li_Cont).TOKEN);
		            APEX_JSON.WRITE('login',Lr_Datos_Cliente(Lr_Token(Li_Cont).IDENTIFICACION_CLIENTE).LOGIN);
		            APEX_JSON.WRITE('message',Lr_Datos_Cliente(Lr_Token(Li_Cont).IDENTIFICACION_CLIENTE).MENSAJE);
		            APEX_JSON.WRITE('status','PENDING');
		            APEX_JSON.CLOSE_OBJECT; 
		            Li_Cont:= Lr_Token.NEXT(Li_Cont);
	        	END LOOP;		    	      
			 EXIT WHEN Lrf_Token%NOTFOUND;	
		    END LOOP;
		    Ln_count := 0;
			DBMS_LOB.CREATETEMPORARY(Lc_Identificacions, TRUE); 
		    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE);
		  END IF;

	   Ln_count:= Ln_count+1;
	   ln_countList:= ln_countList+1;
	  Lv_Identificacion:='';

	END LOOP;

	APEX_JSON.CLOSE_ARRAY;
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

   Pv_Status := 'OK';
   Pv_Mensaje := 'Consulta exitosa';
   Pcl_Response := Lcl_Response;


 EXCEPTION 
  WHEN Le_Error THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := Lv_Mensaje;
  WHEN OTHERS THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := 'Error: ' || SQLERRM;
 END P_TOKEN_NOTIFICACION_PUSH;

 PROCEDURE P_LOTES_CLIENTES_NOTI_PUSH(Pn_LimitArchivo IN  NUMBER,
                                        Pv_Status      OUT VARCHAR2,
                                        Pv_Mensaje     OUT VARCHAR2,
                                        Pcl_Response   OUT CLOB ) AS 

 Lv_NombreParamDirBdArchivosTmp  VARCHAR2(33) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
 Lv_NombreParamUrlMicroNfs       VARCHAR2(33) := 'URL_MICROSERVICIO_NFS';
 Lv_DirectorioBaseDatos          VARCHAR2(100);
 Lv_MsjError                     VARCHAR2(4000);
 Le_Exception                    EXCEPTION;
 Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
 Lv_UrlMicroServicioNfs          VARCHAR2(500);
 Lv_RutaDirectorioBaseDatos      VARCHAR2(500);
 Lv_NombreArchivo                VARCHAR2(100);
 Lv_PrefijoNombreArchivo         VARCHAR2(100) := 'ClientesNotiPush_';
 Lv_FechaArchivo                 VARCHAR2(20)  := TO_CHAR(SYSDATE, 'DD-MM-YYYY-HH24_MI_SS');
 Lv_TextLote                     VARCHAR2(10)  := 'Lote_';
 Lv_SubModuloNotificaciones      VARCHAR2(14)  := 'Notificaciones';
 Lv_CodigoApp                    VARCHAR2(10);
 Lv_CodigoPath                   VARCHAR2(10);
 Lrf_Token   		             SYS_REFCURSOR;
 Ln_Limit                        NUMBER := Pn_LimitArchivo;
 Li_Cont       		             PLS_INTEGER;
 Lr_Token                        Ltr_Token;
 Ln_NumeracionCsv                NUMBER := 0;
 Lf_ArchivoRespuesta             UTL_FILE.FILE_TYPE;
 LCv_Delimitador                 VARCHAR2(2) := ',';
 Lv_RespuestaGuardarArchivo      VARCHAR2(4000);
 Ln_CodeResWsNFS                 NUMBER;
 Ln_CountArchivos                NUMBER;
 Lv_PathArchivo                  VARCHAR2(4000);
 Lcl_Response                    CLOB;


 CURSOR Lc_GetValoresParamsGeneral(Cv_NombreParametro IN VARCHAR2)
    IS
      SELECT DET.VALOR1, DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.ESTADO = Lv_EstadoActivo;  

 CURSOR Lc_GetConfigNfsNotiPush 
    IS
      SELECT TO_CHAR(CODIGO_APP) AS CODIGO_APP, TO_CHAR(CODIGO_PATH) AS CODIGO_PATH 
      FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
      WHERE APLICACION ='TelcosWeb' 
      AND SUBMODULO = Lv_SubModuloNotificaciones
      AND EMPRESA ='MD';

 CURSOR LcGetClientes 
 IS    
    SELECT DISTINCT s.valor,ip.identificacion_cliente       
    FROM DB_COMERCIAL.INFO_PERSONA IP , 
		 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
		 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC s
    WHERE IP.ID_PERSONA = IPER.PERSONA_ID 
    AND s.PERSONA_EMPRESA_ROL_ID = iper.ID_PERSONA_ROL
    AND s.CARACTERISTICA_ID = (SELECT ID_CARACTERISTICA  
                               FROM DB_COMERCIAL.ADMI_CARACTERISTICA s 
							   WHERE s.DESCRIPCION_CARACTERISTICA = 'PUSH_ID_CLIENTE')
    AND s.ESTADO = 'Activo'
	AND IPER.ESTADO = 'Activo'
	AND iper.EMPRESA_ROL_ID = (SELECT ier.ID_EMPRESA_ROL  
                               FROM DB_COMERCIAL.INFO_EMPRESA_ROL ier ,
                                    DB_COMERCIAL.admi_rol ar
                               WHERE ier.ROL_ID = ar.id_rol
                               AND  ier.EMPRESA_COD = 18 
                               AND ar.descripcion_rol= 'Cliente'
                               AND ier.ESTADO ='Activo'
				               AND ar.estado='Activo');                                                        

  Lr_RegGetValoresParamsGeneral   Lc_GetValoresParamsGeneral%ROWTYPE;
  Lr_RegGetConfigNfs   Lc_GetConfigNfsNotiPush%ROWTYPE;

 BEGIN 

    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamDirBdArchivosTmp);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_DirectorioBaseDatos      := Lr_RegGetValoresParamsGeneral.VALOR1;
    IF Lv_DirectorioBaseDatos IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;
    Lv_RutaDirectorioBaseDatos  := Lr_RegGetValoresParamsGeneral.VALOR2;
    IF Lv_RutaDirectorioBaseDatos IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la rura del directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF; 
    Lr_RegGetValoresParamsGeneral := NULL;
    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamUrlMicroNfs);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;

    Lv_UrlMicroServicioNfs  := Lr_RegGetValoresParamsGeneral.VALOR1;
    IF Lv_UrlMicroServicioNfs IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la URL del NFS';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetConfigNfsNotiPush;
    FETCH Lc_GetConfigNfsNotiPush INTO Lr_RegGetConfigNfs;
    CLOSE Lc_GetConfigNfsNotiPush;
    Lv_CodigoApp      := Lr_RegGetConfigNfs.CODIGO_APP;
    Lv_CodigoPath     := Lr_RegGetConfigNfs.CODIGO_PATH;
    IF Lv_CodigoApp  IS NULL OR Lv_CodigoPath IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la configuraci�n de la ruta NFS';
      RAISE Le_Exception;
    END IF;
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_ARRAY();

     OPEN LcGetClientes;
		    LOOP
                Ln_NumeracionCsv := Ln_NumeracionCsv + 1;
                Lv_NombreArchivo  := Lv_PrefijoNombreArchivo || Lv_FechaArchivo || '_' || Lv_TextLote || Ln_NumeracionCsv || '.csv';
                Lf_ArchivoRespuesta := UTL_FILE.FOPEN(Lv_DirectorioBaseDatos, Lv_NombreArchivo, 'w', 32767);

			    FETCH LcGetClientes BULK COLLECT INTO Lr_Token LIMIT Ln_Limit;
                    Li_Cont := Lr_Token.FIRST;
                    WHILE Li_Cont IS NOT NULL LOOP
                         UTL_FILE.PUT_LINE(Lf_ArchivoRespuesta, Lr_Token(Li_Cont).IDENTIFICACION_CLIENTE || LCv_Delimitador ||
                                                    '' || LCv_Delimitador ||
                                                    '' || LCv_Delimitador ||  Lr_Token(Li_Cont).TOKEN);
                         Li_Cont:= Lr_Token.NEXT(Li_Cont);
                    END LOOP;

                    UTL_FILE.FCLOSE(Lf_ArchivoRespuesta);
                EXIT WHEN Lr_Token.count =0;	
               Lv_RespuestaGuardarArchivo  := DB_GENERAL.GNRLPCK_UTIL.F_GUARDAR_ARCHIVO_NFS(Lv_UrlMicroServicioNfs,
                                                                                    Lv_RutaDirectorioBaseDatos || Lv_NombreArchivo,
                                                                                    Lv_NombreArchivo,
                                                                                    NULL,
                                                                                    Lv_CodigoApp,
                                                                                    Lv_CodigoPath); 
                IF Lv_RespuestaGuardarArchivo IS NULL THEN
                  Lv_MsjError   := 'No se ha podido generar el archivo de manera correcta. Por favor consulte al Dep. de Sistemas!';
                  RAISE Le_Exception;
                END IF;
                APEX_JSON.PARSE(Lv_RespuestaGuardarArchivo);
                Ln_CodeResWsNFS   := APEX_JSON.GET_NUMBER('code');

                IF Ln_CodeResWsNFS IS NULL OR Ln_CodeResWsNFS <> 200 THEN
                  Lv_MsjError := 'Ha ocurrido alg�n error al generar el archivo. Por favor consulte al Dep. de Sistemas!';
                  RAISE Le_Exception;
                END IF;

                Ln_CountArchivos := APEX_JSON.GET_COUNT(p_path => 'data');
                IF Ln_CountArchivos IS NULL THEN
                  Lv_MsjError := 'No se ha generado correctamente la ruta del archivo. Por favor consulte al Dep. de Sistemas!';
                  RAISE Le_Exception;
                END IF;

                IF Ln_CountArchivos <> 1 THEN
                  Lv_MsjError := 'Ha ocurrido un error inesperado al generar el archivo. Por favor consulte al Dep. de Sistemas!';
                  RAISE Le_Exception;
                END IF;

                FOR i IN 1 .. Ln_CountArchivos LOOP
                Lv_PathArchivo := APEX_JSON.GET_VARCHAR2(p_path => 'data[%d].pathFile', p0 => i);
                END LOOP;

                IF Lv_PathArchivo IS NULL THEN
                  Lv_MsjError := 'No se ha podido obtener la ruta en la que se encuentra el archivo generado. Por favor consulte al Dep. de Sistemas!';
                  RAISE Le_Exception;
                END IF;

                APEX_JSON.OPEN_OBJECT;
                APEX_JSON.WRITE('urlNfs', Lv_PathArchivo);
                APEX_JSON.CLOSE_OBJECT; 

                UTL_FILE.FREMOVE(Lv_DirectorioBaseDatos, Lv_NombreArchivo);
		    END LOOP;
      CLOSE LcGetClientes;
    APEX_JSON.CLOSE_ARRAY;
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

   Pv_Status := 'OK';
   Pv_Mensaje := 'Proceso realizado satisfactoriamente';
   Pcl_Response := Lcl_Response;


 EXCEPTION 
  WHEN Le_Exception THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := Lv_MsjError;
  WHEN OTHERS THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := 'Error: ' || SQLERRM;

END P_LOTES_CLIENTES_NOTI_PUSH;

END GNKG_NOTIFICACIONES;
/