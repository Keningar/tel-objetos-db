CREATE OR REPLACE PACKAGE DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE IS
	TELCODRIVE_EXCEPTION EXCEPTION;
	NO_REPO_FOUND EXCEPTION;
	AUTH_ERROR EXCEPTION;
	NO_TOKEN EXCEPTION;
	FILE_DOES_NOT_EXIST EXCEPTION;
	DIR_DOES_NOT_EXIST EXCEPTION;
	NO_PARAM_FOUND EXCEPTION;
	TELCO_NODE_NOT_FOUND EXCEPTION;

	/**
	* Documentacion para el paquete 'GNKG_INTEGRACION_TELCODRIVE'
	* Paquete que contiene procedimientos y funciones para interactuar con Telcodrive.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-28-2022
	*/
	
	NOMBRE_PARAMETRO_CAB VARCHAR2(128) := 'INTEGRACION_TELCODRIVE';

	
	/**
	* Documentacion para la función 'F_AUTHENTICATION'.
	* Retorna token al recibir credenciales de Telcodrive. El token retornado es necesario para todos los otros métodos de este paquete.
	*
	* @param p_username usuario de telcodrive
	* @param p_password contraseña de telcodrive
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_AUTHENTICATION(p_username VARCHAR2, p_password VARCHAR2) RETURN VARCHAR2;
	
	/**
	* Documentacion para la función 'F_LIST_REPOS'.
	* Lista todos los repositorios pertenecientes a un usuario identificado por el token proporcionado.
	*
	* @param p_token token obtenido con F_AUTHENTICATION
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_LIST_REPOS(p_token VARCHAR2) RETURN CLOB;
	
	/**
	* Documentacion para la función 'F_GET_REPO_ID'.
	* Retorna el ID de un repositorio.
	*
	* @param p_token token obtenido con F_AUTHENTICATION
	* @param p_repo_name nombre de repositorio
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_GET_REPO_ID(p_token VARCHAR2, p_repo_name VARCHAR2) RETURN CLOB;
	
	-- TODO: remover esto el public API
	FUNCTION F_GET_UPLOAD_LINK(p_token VARCHAR2, p_repo_name VARCHAR2) RETURN CLOB;
	
	/**
	* Documentacion para la función 'F_UPLOAD_FILE'.
	* Permite subir archivos usando multipart/form-data
	*
	* @param p_token token obtenido con F_AUTHENTICATION
	* @param p_dir_name nombre del objeto directorio de Oracle donde está el archivo
	* @param p_file_name nombre del archivo del directorio
	* @param p_repo nombre del repositorio de Telcodrive al que se subirá el archivo
	* @param p_path path en el repo al que se subirá el archivo. Si no existe, será creado. El path puede empezar con / o no.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_UPLOAD_FILE(p_token VARCHAR2, p_dir_name VARCHAR2, p_file_name VARCHAR2, p_repo VARCHAR2, p_path VARCHAR2 DEFAULT '') RETURN CLOB;
	
	/**
	* Documentacion para la función 'F_GET_SHARE_LINK'.
	* Obtiene enlace para un archivo o directorio de Telcodrive. 
	* El enlace generado es válido únicamente para las personas que tienen acceso al repositorio, es decir, previamente tiene que dárseles permisos usando F_SHARE_TO_USER.
	*
	* @param p_token token obtenido con F_AUTHENTICATION
	* @param p_repo_name nombre de repositorio.
	* @param p_path path del archivo en Telcodrive. Puede empezar con '/' o no.
	* @param p_is_dir define si el objeto de Telcodrive es un archivo o directorio, por defecto es un archivo (FALSE).
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_GET_SHARE_LINK(p_token VARCHAR2, p_repo_name VARCHAR2, p_path VARCHAR2, p_is_dir BOOLEAN DEFAULT FALSE) RETURN CLOB;
	
	/**
	* Documentacion para el procedimiento 'P_NOTIFICAR_SUBIDA'.
	* Notifica a destinatarios mediante correo electrónico que un archivo o directorio ha sido subido a Telcodrive. Idealmente debe usarse en conjunto con F_UPLOAD_FILE.
	*
	* @param p_token token obtenido con F_AUTHENTICATION
	* @param p_nombre_repo nombre de repositorio.
	* @param p_path_archivo path del archivo en Telcodrive. Puede empezar con '/' o no.
	* @param p_is_dir define si el objeto de Telcodrive es un archivo o directorio, por defecto es un archivo (FALSE).
	* @param p_destinatarios direcciones de correos electrónicos separadas por comas: 'ejemplo1@telconet.ec,ejemplo2@telconet.ec'
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	PROCEDURE P_NOTIFICAR_SUBIDA(p_token VARCHAR2, p_nombre_repo VARCHAR2, p_path_archivo VARCHAR2, p_is_dir BOOLEAN DEFAULT FALSE, p_destinatarios VARCHAR2);
	
	/**
	* Documentacion para la función 'F_SHARE_TO_USER'.
	* Comparte un repositorio de Telcodrive con el usuario especificado.
	*
	* @param p_token token obtenido con F_AUTHENTICATION
	* @param p_repo_name nombre de repositorio.
	* @param p_user_email correo de telconet del usuario al que se le compartirá el repositorio.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_SHARE_TO_USER(p_token VARCHAR2, p_repo_name VARCHAR2, p_user_email VARCHAR2) RETURN CLOB;
	
END GNKG_INTEGRACION_TELCODRIVE;
/
CREATE OR REPLACE PACKAGE BODY DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE IS	

	FUNCTION F_GET_PARAMETRO(p_descripcion VARCHAR2) RETURN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE
	AS
		detalleParametroRow DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
	BEGIN
		SELECT apd.* INTO detalleParametroRow
		FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc 
			INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET apd ON apd.PARAMETRO_ID = apc.ID_PARAMETRO
		WHERE apc.NOMBRE_PARAMETRO = NOMBRE_PARAMETRO_CAB 
		AND apd.DESCRIPCION = p_descripcion;
		RETURN detalleParametroRow;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20007, 'No se encontró el parámetro ' || p_descripcion || '.');
	END;
	
	FUNCTION F_CHECK_IF_JSON(testString CLOB) RETURN BOOLEAN AS
	BEGIN
		APEX_JSON.PARSE(testString);
		RETURN TRUE;
	EXCEPTION
		WHEN OTHERS THEN 
			RETURN FALSE;
	END;

	FUNCTION F_AUTHENTICATION(p_username VARCHAR2, p_password VARCHAR2) RETURN VARCHAR2
	AS
		HOST_TELCODRIVE VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_BASE').VALOR1;
		PATH_AUTHENTICATION VARCHAR2(128) := F_GET_PARAMETRO('PATH_AUTHENTICATION').VALOR1;
		urlRequest VARCHAR2(128);
		credencialesJson VARCHAR2(100);
		response CLOB;
		token VARCHAR2(100);
		headersJson CLOB;
		codigoEstadoPeticion NUMBER;
		mensajePeticion VARCHAR2(256);
	BEGIN
		IF (TRIM(p_username) IS NULL OR TRIM(p_password) IS NULL) THEN
			RAISE TELCODRIVE_EXCEPTION;
		END IF;

		-- Se genera el JSON con username y password
		APEX_JSON.initialize_clob_output;
		APEX_JSON.open_object;
		APEX_JSON.write('username', p_username);
		APEX_JSON.write('password', p_password);
		APEX_JSON.close_object;
		credencialesJson := APEX_JSON.get_clob_output;		
		
		-- Se genera el JSON de los headers
		APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Content-Type', 'application/json');
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        headersJson := APEX_JSON.GET_CLOB_OUTPUT;     	
		
		-- Se realiza la petición
		urlRequest := HOST_TELCODRIVE || PATH_AUTHENTICATION ;
		GNKG_WEB_SERVICE.P_POST(urlRequest, headersJson, credencialesJson, codigoEstadoPeticion, mensajePeticion, response);
		
		IF (codigoEstadoPeticion = 99) THEN
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || urlRequest || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		IF NOT F_CHECK_IF_JSON(response) THEN
			-- Esto se considera un 404, porque siempre que eso sucede, se retorna algo que no es JSON
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || urlRequest || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		APEX_JSON.PARSE(response);			
		token := APEX_JSON.get_varchar2(p_path => 'token');
		
		IF (token IS NULL) THEN
			RAISE_APPLICATION_ERROR(-20003, 'Username o password incorrectos, o comprobar tabla de parámetros.');
		END IF;
		
		RETURN token;
	END;
	
	FUNCTION F_LIST_REPOS(p_token VARCHAR2) RETURN CLOB
	AS
		HOST_TELCODRIVE VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_BASE').VALOR1;
		PATH_LIST_REPOS VARCHAR2(128) := F_GET_PARAMETRO('PATH_LIST_REPOS').VALOR1;
		urlRequest VARCHAR2(128);
		response CLOB;
		reposContador Number;
		
		headersJson CLOB;
		codigoEstadoPeticion NUMBER;
		mensajePeticion VARCHAR2(256);
	BEGIN
		urlRequest := HOST_TELCODRIVE || PATH_LIST_REPOS;
		
		-- Se genera el JSON de los headers
		APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Authorization', 'Token ' || p_token);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;		
        headersJson := APEX_JSON.GET_CLOB_OUTPUT;    
		
		GNKG_WEB_SERVICE.P_GET(urlRequest, headersJson, codigoEstadoPeticion, mensajePeticion, response);
		
		IF (codigoEstadoPeticion = 99) THEN
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || urlRequest || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		IF NOT F_CHECK_IF_JSON(response) THEN
			-- Esto se considera un 404, porque siempre que eso sucede, se retorna algo que no es JSON
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || urlRequest || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		APEX_JSON.PARSE(response);	
		reposContador := APEX_JSON.get_count(p_path => 'repos');

		IF (reposContador IS NULL) THEN
			IF APEX_JSON.get_varchar2(p_path => 'detail') = 'Invalid token' THEN
				dbms_output.put_line('token inválido');
				RAISE AUTH_ERROR;
			END IF;
			-- podría llegarse aquí si el usuario no tiene repositorios
			dbms_output.put_line('El usuario no tiene repositorios.');
		END IF;		
		
		RETURN response;
	END;
	
	FUNCTION F_GET_REPO_ID(p_token VARCHAR2, p_repo_name VARCHAR2) RETURN CLOB
	AS
		response CLOB;
		repos CLOB;
		idx NUMBER;
		currentRepoName VARCHAR2(100);
		encontrado BOOLEAN := FALSE;
		indexEncontrado NUMBER;
	BEGIN
		repos := F_LIST_REPOS(p_token);	
		APEX_JSON.PARSE(repos);
		FOR idx IN 1..APEX_JSON.get_count(p_path => 'repos') LOOP
			currentRepoName := APEX_JSON.get_varchar2(p_path => 'repos[' || idx ||'].repo_name');
			IF currentRepoName = p_repo_name THEN
				encontrado := TRUE;
				indexEncontrado := idx;
				EXIT;
			END IF;							
		END LOOP;
		
		IF NOT ENCONTRADO THEN
			RAISE NO_REPO_FOUND;			
		END IF;
		
		RETURN APEX_JSON.get_varchar2(p_path => 'repos[' || indexEncontrado ||'].repo_id');
	EXCEPTION
		WHEN NO_REPO_FOUND THEN
			dbms_output.put_line('No se encontró repo con el nombre proporcionado.');
			RAISE;
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20003, 'Token incorrecto.');
	END;
	
	FUNCTION F_GET_UPLOAD_LINK(p_token VARCHAR2, p_repo_name VARCHAR2) RETURN CLOB
	AS
		HOST_TELCODRIVE VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_BASE').VALOR1;
		PATH_GET_UPLOAD_LINK VARCHAR2(128) := F_GET_PARAMETRO('PATH_GET_UPLOAD_LINK').VALOR1;
		uploadLink CLOB;
		repoId VARCHAR2(100);
		requestUrl CLOB;
		
		headersJson CLOB;
		codigoEstadoPeticion NUMBER;
		mensajePeticion VARCHAR2(256);
	BEGIN
		repoId := F_GET_REPO_ID(p_token, p_repo_name);
		requestUrl := HOST_TELCODRIVE || PATH_GET_UPLOAD_LINK;
		requestUrl := TRIM(REPLACE(requestUrl, '{repo_id}', repoId));
		
		-- Se genera el JSON de los headers
		APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Authorization', 'Token ' || p_token);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;		
        headersJson := APEX_JSON.GET_CLOB_OUTPUT;    
		
		GNKG_WEB_SERVICE.P_GET(requestUrl, headersJson, codigoEstadoPeticion, mensajePeticion, uploadLink);
		
		IF (codigoEstadoPeticion = 99) THEN
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || requestUrl || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		-- Si el contenido es HTML, es un 404		
		IF REGEXP_LIKE(uploadLink, '<\/?[a-z][\s\S]*>') THEN
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || requestUrl || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		RETURN TRIM(BOTH '"' FROM uploadLink);
	EXCEPTION
		WHEN NO_REPO_FOUND THEN
			RAISE;
		WHEN OTHERS THEN
			RAISE;
	END;	
	
	FUNCTION F_CHECK_IF_FILE_EXISTS(p_dir_name VARCHAR2, p_file_name VARCHAR2) RETURN BOOLEAN
	AS
		l_file_loc bfile;
		fileExists NUMBER;
		l_dir_counter NUMBER := 0;
	BEGIN
		SELECT COUNT(*) INTO l_dir_counter FROM SYS.datapump_dir_objs 
			WHERE name = p_dir_name AND READ = 'TRUE' AND WRITE = 'TRUE'; 
				
		-- Check if dir is available
		IF l_dir_counter = 0 THEN
			RAISE DIR_DOES_NOT_EXIST;
		END IF;
		
		l_file_loc := bfilename(upper(p_dir_name), p_file_name);
		fileExists := dbms_lob.fileexists(l_file_loc);
		
		IF fileExists = 1 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;
	
	FUNCTION F_UPLOAD_FILE(p_token VARCHAR2, p_dir_name VARCHAR2, p_file_name VARCHAR2, p_repo VARCHAR2, p_path VARCHAR2 DEFAULT '') RETURN CLOB 
	AS
		HOST_TELCODRIVE VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_BASE').VALOR1;
		HOST_TELCODRIVE_PRODUCCION VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_PRODUCCION').VALOR1;
		serverDirPath VARCHAR2(100);
		response CLOB;
		uploadLink VARCHAR2(512);
		cleanPath VARCHAR2(128);
		
		bodyParts DB_GENERAL.GNKG_WEB_SERVICE.parts := DB_GENERAL.GNKG_WEB_SERVICE.parts();
		bf BFILE := bfilename(upper(p_dir_name), p_file_name);
		headersJson CLOB;		
	BEGIN
		IF F_CHECK_IF_FILE_EXISTS(p_dir_name, p_file_name) = false THEN
			RAISE FILE_DOES_NOT_EXIST;
		END IF;
		
		uploadLink := F_GET_UPLOAD_LINK(p_token, p_repo);		
		uploadLink := TRIM(REPLACE(uploadLink, HOST_TELCODRIVE_PRODUCCION, HOST_TELCODRIVE) || '?ret-json=1');	

		DB_GENERAL.GNKG_WEB_SERVICE.add_file(bodyParts, 'file', p_file_name, 'application/gzip', bf);
		DB_GENERAL.GNKG_WEB_SERVICE.add_param(bodyParts, 'parent_dir', '/');
		DB_GENERAL.GNKG_WEB_SERVICE.add_param(bodyParts, 'replace', '1');
		
		IF LENGTH(p_path) IS NOT NULL THEN
			cleanPath := TRIM(LEADING '/' FROM p_path);
			DB_GENERAL.GNKG_WEB_SERVICE.add_param(bodyParts, 'relative_path', cleanPath);
		END IF;
		
		APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Authorization', 'Token ' || p_token);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;		
        headersJson := APEX_JSON.GET_CLOB_OUTPUT;   
	
		DB_GENERAL.GNKG_WEB_SERVICE.P_FORM('POST', uploadLink, bodyParts, response, headersJson);
		RETURN response;
	EXCEPTION
		WHEN FILE_DOES_NOT_EXIST THEN
			RAISE_APPLICATION_ERROR(-20005, 'No existe el archivo en el servidor de la base.');
		WHEN DIR_DOES_NOT_EXIST THEN 
			RAISE_APPLICATION_ERROR(-20006, 'El directorio en el servidor de la base.');
		WHEN NO_REPO_FOUND THEN
			RAISE_APPLICATION_ERROR(-20006, 'No se encontró repo con el nombre proporcionado.');
	END;
	
	FUNCTION F_GET_SHARE_LINK(p_token VARCHAR2, p_repo_name VARCHAR2, p_path VARCHAR2, p_is_dir BOOLEAN DEFAULT FALSE) RETURN CLOB
	AS
		HOST_TELCODRIVE VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_BASE').VALOR1;
		PATH_GET_SHARE_LINK VARCHAR2(128) := F_GET_PARAMETRO('PATH_GET_SHARE_LINK').VALOR1;
		shareLink VARCHAR2(1024);
		requestUrl VARCHAR2(1024);
		isDirString VARCHAR2(100);
		response CLOB;
		repoId VARCHAR2(128);
		
		headersJson CLOB;
		codigoEstadoPeticion NUMBER;
		mensajePeticion VARCHAR2(256);
	BEGIN
		isDirString := case when p_is_dir = TRUE then 'true' else 'false' end;
		repoId := F_GET_REPO_ID(p_token, p_repo_name);
		
		requestUrl := HOST_TELCODRIVE || PATH_GET_SHARE_LINK;
		requestUrl := TRIM(REPLACE(requestUrl, '{repo_id}', repoId));	
		requestUrl := TRIM(REPLACE(requestUrl, '{path}', p_path));	
		requestUrl := TRIM(REPLACE(requestUrl, '{is_dir}', isDirString));	
		
		-- Se genera el JSON de los headers
		APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Authorization', 'Token ' || p_token);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;		
        headersJson := APEX_JSON.GET_CLOB_OUTPUT;    
		
		GNKG_WEB_SERVICE.P_GET(requestUrl, headersJson, codigoEstadoPeticion, mensajePeticion, response);
		
		IF (codigoEstadoPeticion = 99) THEN
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || requestUrl || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		-- Si el contenido es HTML, es un 404		
		IF REGEXP_LIKE(response, '<\/?[a-z][\s\S]*>') THEN
			RAISE_APPLICATION_ERROR(-20001, 'URL ' || requestUrl || ' incorrecta, comprobar tabla de parámetros.');
		END IF;
		
		APEX_JSON.PARSE(response);
		shareLink := APEX_JSON.get_varchar2(p_path => 'smart_link');
		
		-- si no hay smart_link, se comprueba si la propiedad error_msg existe
		IF shareLink IS NULL AND APEX_JSON.get_varchar2(p_path => 'error_msg') IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20008, 'El' || case when p_is_dir = TRUE then ' directorio ' else ' archivo ' end || p_path || ' no existe en Telcodrive.');
		END IF;
		
		return shareLink;
	EXCEPTION
		WHEN NO_REPO_FOUND THEN
			RAISE_APPLICATION_ERROR(-20006, 'No se encontró repo con el nombre proporcionado.');
	END;

	PROCEDURE P_NOTIFICAR_SUBIDA(p_token VARCHAR2, p_nombre_repo VARCHAR2, p_path_archivo VARCHAR2, p_is_dir BOOLEAN DEFAULT FALSE, p_destinatarios VARCHAR2) AS
		shareLink CLOB;
		fileName VARCHAR2(128);
		senderNotificacion VARCHAR2(128) := F_GET_PARAMETRO('REMITENTE_NOTIFICACION').VALOR1;
		messageBody CLOB := '
							<h4>
								Se ha subido ' || 
								case when p_is_dir = TRUE then 'la carpeta ' else 'el archivo ' end || 
								'{file_name} a Telcodrive.
							</h4>
							<p>
								Ingresar a <a href="{file_smart_link}">{file_smart_link}</a> para acceder al archivo.
							</p>';
	BEGIN
		shareLink := GNKG_INTEGRACION_TELCODRIVE.F_GET_SHARE_LINK(p_token, 
															 p_nombre_repo, 
															 p_path_archivo,
															 p_is_dir); 
		fileName :=  TRIM(LEADING '/' FROM REGEXP_SUBSTR(TRIM(TRAILING '/' FROM p_path_archivo), '[^/]*$'));
		messageBody := TRIM(REPLACE(messageBody, '{file_name}', fileName));	
		messageBody := TRIM(REPLACE(messageBody, '{file_smart_link}', shareLink));	
		UTL_MAIL.SEND(sender     => senderNotificacion,
					  recipients => p_destinatarios,                  
					  subject    => 'Se ha subido ' || fileName || ' a Telcodrive',
					  message    => messageBody,
					  mime_type  => 'text/html; charset=UTF-8');
	END;
	
	FUNCTION F_SHARE_TO_USER(p_token VARCHAR2, p_repo_name VARCHAR2, p_user_email VARCHAR2) RETURN CLOB AS
		HOST_TELCODRIVE VARCHAR2(128) := F_GET_PARAMETRO('HOST_TELCODRIVE_BASE').VALOR1;
		PATH_SHARE_REPO VARCHAR2(128) := F_GET_PARAMETRO('PATH_SHARE_REPO').VALOR1;
		headersJson CLOB;
		requestUrl VARCHAR2(128);
		bodyParts DB_GENERAL.GNKG_WEB_SERVICE.parts := DB_GENERAL.GNKG_WEB_SERVICE.parts();
		repoId VARCHAR2(128);
		response CLOB;
	BEGIN
		repoId := F_GET_REPO_ID(p_token, p_repo_name);
		requestUrl := HOST_TELCODRIVE || PATH_SHARE_REPO; 
		requestUrl := TRIM(REPLACE(requestUrl, '{repo_id}', repoId));	
		
		DB_GENERAL.GNKG_WEB_SERVICE.add_param(bodyParts, 'share_type', 'user');
		DB_GENERAL.GNKG_WEB_SERVICE.add_param(bodyParts, 'username', p_user_email);
		DB_GENERAL.GNKG_WEB_SERVICE.add_param(bodyParts, 'permission', 'r');
		
		APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Authorization', 'Token ' || p_token);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;		
        headersJson := APEX_JSON.GET_CLOB_OUTPUT;    
		
		DB_GENERAL.GNKG_WEB_SERVICE.P_FORM('PUT', requestUrl, bodyParts, response, headersJson);
		RETURN response;
	END;
	
END GNKG_INTEGRACION_TELCODRIVE;
/