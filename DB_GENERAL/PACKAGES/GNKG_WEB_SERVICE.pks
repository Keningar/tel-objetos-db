CREATE OR REPLACE PACKAGE DB_GENERAL.GNKG_WEB_SERVICE AS
  
  /**
  * Documentacion para el procedimiento P_WEB_SERVICE
  *
  * M�todo encargado del consumo de webservice
  *
  * @param Pv_Url             IN  NUMBER   Recibe la url del webservice
  * @param Pcl_Mensaje        IN  VARCHAR2 Recibe el mensaje en formato JSON,XML,ETC
  * @param Pv_Application     IN  VARCHAR2 Recibe el content type por ejemplo (application/json)
  * @param Pv_Charset         IN  VARCHAR2 Recibe el charset en el que se envia el mensaje
  * @param Pv_UrlFileDigital  IN  VARCHAR2 Ruta del certificado digital
  * @param Pv_PassFileDigital IN  VARCHAR2 contrase�a para acceder al certificado digital
  * @param Pv_Respuesta       OUT VARCHAR2 Retorna la respuesta del webservice
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 17-10-2017
  */ 
  PROCEDURE P_WEB_SERVICE(
      Pv_Url             IN  VARCHAR2,
      Pcl_Mensaje        IN  CLOB,
      Pv_Application     IN  VARCHAR2,
      Pv_Charset         IN  VARCHAR2,
      Pv_UrlFileDigital  IN  VARCHAR2,
      Pv_PassFileDigital IN  VARCHAR2,
      Pcl_Respuesta      OUT CLOB,
      Pv_Error           OUT VARCHAR2);

/**
  * Documentacion para el procedimiento P_WEB_SERVICE_BR
  *
  * M�todo encargado del consumo de webservice con request y response de gran tama�o (BIG REQUEST), se creo este
  * m�todo para evitar alguna afectaci�n con procesos que usaban el m�todo anterior existente
  *
  * @param Pv_Url             IN  NUMBER   Recibe la url del webservice
  * @param Pcl_Mensaje        IN  VARCHAR2 Recibe el mensaje en formato JSON,XML,ETC
  * @param Pv_Application     IN  VARCHAR2 Recibe el content type por ejemplo (application/json)
  * @param Pv_Charset         IN  VARCHAR2 Recibe el charset en el que se envia el mensaje
  * @param Pv_UrlFileDigital  IN  VARCHAR2 Ruta del certificado digital
  * @param Pv_PassFileDigital IN  VARCHAR2 contrase�a para acceder al certificado digital
  * @param Pv_Respuesta       OUT VARCHAR2 Retorna la respuesta del webservice
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 10-11-2022
  * 
  * @author Jes�s Bozada
  * @version 1.1 13-12-2022  Se quita l�na con "UTL_HTTP.set_persistent_conn_support" ya que causa problemas al
  *                          comunicarnos con WS GDA y utilizar el header  'Transfer-Encoding', 'chunked'
  */ 
  PROCEDURE P_WEB_SERVICE_BR(
      Pv_Url             IN  VARCHAR2,
      Pcl_Mensaje        IN  CLOB,
      Pv_Application     IN  VARCHAR2,
      Pv_Charset         IN  VARCHAR2,
      Pv_UrlFileDigital  IN  VARCHAR2,
      Pv_PassFileDigital IN  VARCHAR2,
      Pcl_Respuesta      OUT CLOB,
      Pv_Error           OUT VARCHAR2);
  
  /**
  * Documentacion para el procedimiento P_GET
  *
  * M�todo encargado del consumo de webservice GET
  *
  * @param Pv_Url             IN  VARCHAR2 Recibe la url del webservice
  * @param Pcl_Headers        IN  CLOB     Recibe un json de headers din�micos
  * @param Pn_Code            OUT NUMBER   Retorna c�digo de error
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna mensaje de transacci�n
  * @param Pcl_Data           OUT CLOB     Retorna un json respuesta del webservice
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */    
  PROCEDURE P_GET(Pv_Url      IN  VARCHAR2,
                  Pcl_Headers IN  CLOB,
                  Pn_Code     OUT NUMBER,
                  Pv_Mensaje  OUT VARCHAR2,
                  Pcl_Data    OUT CLOB);
  
  /**
  * Documentacion para el procedimiento P_POST
  *
  * M�todo encargado del consumo de webservice POST
  *
  * @param Pv_Url             IN  VARCHAR2 Recibe la url del webservice
  * @param Pcl_Headers        IN  CLOB     Recibe un json de headers din�micos
  * @param Pcl_Content        IN  CLOB     Recibe un json request
  * @param Pn_Code            OUT NUMBER   Retorna c�digo de error
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna mensaje de transacci�n
  * @param Pcl_Data           OUT CLOB     Retorna un json respuesta del webservice
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.1 18-06-2020 - Se aumenta el tiempo de respuesta a 120 segundos.
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.2 21-07-2020 - Se define la conexi�n persistente y se aumenta el tiempo de respuesta a 180 segundos.
  *
  * @author Leonardo Mero <lemero@telconet.ec>
  * @version 1.3 20-09-2022 - Se aumenta el valor de caracteres maximos en el header para tolerar tokens extensos
  */                 
  PROCEDURE P_POST(Pv_Url      IN  VARCHAR2,
                   Pcl_Headers IN  CLOB,
                   Pcl_Content IN  CLOB,
                   Pn_Code     OUT NUMBER,
                   Pv_Mensaje  OUT VARCHAR2,
                   Pcl_Data    OUT CLOB);
  
  /**
  * Documentacion para el procedimiento P_PUT
  *
  * M�todo encargado del consumo de webservice PUT
  *
  * @param Pv_Url             IN  VARCHAR2 Recibe la url del webservice
  * @param Pcl_Headers        IN  CLOB     Recibe un json de headers din�micos
  * @param Pcl_Content        IN  CLOB     Recibe un json request
  * @param Pn_Code            OUT NUMBER   Retorna c�digo de error
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna mensaje de transacci�n
  * @param Pcl_Data           OUT CLOB     Retorna un json respuesta del webservice
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                   
  PROCEDURE P_PUT(Pv_Url      IN  VARCHAR2,
                  Pcl_Headers IN  CLOB,
                  Pcl_Content IN  CLOB,
                  Pn_Code     OUT NUMBER,
                  Pv_Mensaje  OUT VARCHAR2,
                  Pcl_Data    OUT CLOB);
  
  /**
  * Documentacion para el procedimiento P_DELETE
  *
  * M�todo encargado del consumo de webservice DELETE
  *
  * @param Pv_Url             IN  VARCHAR2 Recibe la url del webservice
  * @param Pcl_Headers        IN  CLOB     Recibe un json de headers din�micos
  * @param Pcl_Content        IN  CLOB     Recibe un json request
  * @param Pn_Code            OUT NUMBER   Retorna c�digo de error
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna mensaje de transacci�n
  * @param Pcl_Data           OUT CLOB     Retorna un json respuesta del webservice
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                 
  PROCEDURE P_DELETE(Pv_Url      IN  VARCHAR2,
                     Pcl_Headers IN  CLOB,
                     Pcl_Content IN  CLOB,
                     Pn_Code     OUT NUMBER,
                     Pv_Mensaje  OUT VARCHAR2,
                     Pcl_Data    OUT CLOB);
  
  /**
  * Documentacion para el procedimiento P_PATCH
  *
  * M�todo encargado del consumo de webservice PATCH
  *
  * @param Pv_Url             IN  VARCHAR2 Recibe la url del webservice
  * @param Pcl_Headers        IN  CLOB     Recibe un json de headers din�micos
  * @param Pcl_Content        IN  CLOB     Recibe un json request
  * @param Pn_Code            OUT NUMBER   Retorna c�digo de error
  * @param Pv_Mensaje         OUT VARCHAR2 Retorna mensaje de transacci�n
  * @param Pcl_Data           OUT CLOB     Retorna un json respuesta del webservice
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                   
  PROCEDURE P_PATCH(Pv_Url      IN  VARCHAR2,
                    Pcl_Headers IN  CLOB,
                    Pcl_Content IN  CLOB,
                    Pn_Code     OUT NUMBER,
                    Pv_Mensaje  OUT VARCHAR2,
                    Pcl_Data    OUT CLOB);                  
	
		type part is record (
		ds_header varchar2(2048),
		ds_value varchar2(1024),
		ds_blob bfile
	);
	
	type parts is table of part;
	
	/**
	* Procedimiento usado para agregar par�metros en un request multipart/form-data.
	*/
	procedure add_param(
		p_parts in out parts,
		p_name in varchar2,
		p_value in varchar2
	);
	
	/**
	* Procedimiento usado para agregar archivos en un request multipart/form-data.
	*/
	procedure add_file(
		p_parts in out parts,
		p_name in varchar2,
		p_filename varchar2,
		p_content_type varchar2,
		p_blob bfile
	);
	
	/**
	* Documentacion para la funci�n 'F_FORM'.
	* Permite realizar peticiones HTTP multipart/form-data.
	*
	* p_method VARCHAR2 m�todo HTTP (POST o PUT)  
	* p_url VARCHAR2 URL al que se realizar� la petici�n
	* p_parts parts tipo que contendr� las "partes" necesarias para construir la petici�n
	* Pcl_Headers CLOB headers en formato JSON
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 02-11-2022
	*/
	PROCEDURE P_FORM(
		p_method VARCHAR2, 
		p_url VARCHAR2, p_parts IN OUT parts, 
		response IN OUT CLOB, 
		Pcl_Headers IN  CLOB DEFAULT ''
	);

END GNKG_WEB_SERVICE;
/

CREATE OR REPLACE PACKAGE BODY DB_GENERAL.GNKG_WEB_SERVICE AS
  v_newline  CONSTANT VARCHAR2(10) := chr(13) || chr(10);
  v_boundary CONSTANT VARCHAR2(60) := '---------------------------30837156019033';
  v_end      CONSTANT VARCHAR2(10) := '--';	
	
  PROCEDURE P_WEB_SERVICE(Pv_Url             IN  VARCHAR2,
                          Pcl_Mensaje        IN  CLOB,
                          Pv_Application     IN  VARCHAR2,
                          Pv_Charset         IN  VARCHAR2,
                          Pv_UrlFileDigital  IN  VARCHAR2,
                          Pv_PassFileDigital IN  VARCHAR2,
                          Pcl_Respuesta      OUT CLOB,
                          Pv_Error           OUT VARCHAR2) AS
    
    Lhttp_Request   UTL_HTTP.REQ;
    Lhttp_Response  UTL_HTTP.RESP; 
    Lv_Respuesta    CLOB;
    Lv_Response     CLOB;

  BEGIN

    UTL_HTTP.set_wallet(Pv_UrlFileDigital, Pv_PassFileDigital);

    Lhttp_Request := UTL_HTTP.BEGIN_REQUEST(Pv_Url, 'POST');

    UTL_HTTP.SET_HEADER(Lhttp_Request, 'content-type', Pv_Application);

    UTL_HTTP.SET_HEADER(Lhttp_Request, 'Content-Length', length(Pcl_Mensaje));

    UTL_HTTP.SET_BODY_CHARSET(Lhttp_Request, Pv_Charset);

    UTL_HTTP.WRITE_TEXT(Lhttp_Request, Pcl_Mensaje);
    
    
    Lhttp_Response := UTL_HTTP.GET_RESPONSE(Lhttp_Request);

    BEGIN

      LOOP

        UTL_HTTP.READ_LINE(Lhttp_Response, Lv_Response);

        Lv_Respuesta := Lv_Respuesta || Lv_Response;

      END LOOP;

        UTL_HTTP.END_RESPONSE(Lhttp_Response);   

    EXCEPTION

      WHEN UTL_HTTP.END_OF_BODY THEN

        UTL_HTTP.END_RESPONSE(Lhttp_Response);

    END;

    Pcl_Respuesta := Lv_Respuesta;

  EXCEPTION

    WHEN OTHERS THEN

      Pv_Error := 'Error en el proceso GNKG_WEB_SERVICE.P_WEB_SERVICE ' || SQLERRM;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('GNKG_WEB_SERVICE',
                                           'GNKG_WEB_SERVICE.P_WEB_SERVICE', 
                                           SQLERRM, 
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

  END P_WEB_SERVICE;

  PROCEDURE P_WEB_SERVICE_BR(Pv_Url             IN  VARCHAR2,
                          Pcl_Mensaje        IN  CLOB,
                          Pv_Application     IN  VARCHAR2,
                          Pv_Charset         IN  VARCHAR2,
                          Pv_UrlFileDigital  IN  VARCHAR2,
                          Pv_PassFileDigital IN  VARCHAR2,
                          Pcl_Respuesta      OUT CLOB,
                          Pv_Error           OUT VARCHAR2) AS
    
    Lhttp_Request   UTL_HTTP.REQ;
    Lhttp_Response  UTL_HTTP.RESP; 
    Lv_Respuesta    CLOB;
    Lv_Response     CLOB;
    Ln_LongitudReq   NUMBER;
    Ln_LongitudIdeal NUMBER:= 32767;
    Ln_Offset        NUMBER:= 1;
    Ln_Buffer        VARCHAR2(2000);
    Ln_Amount        NUMBER := 2000;
    l_buffer   varchar2(2000);
  BEGIN
    dbms_lob.createtemporary(Lv_Respuesta, TRUE);
    dbms_lob.createtemporary(Lv_Response, TRUE);
    -- TIME OUT
    UTL_HTTP.set_transfer_timeout(5000);
    UTL_HTTP.set_wallet(Pv_UrlFileDigital, Pv_PassFileDigital);
    Lhttp_Request := UTL_HTTP.BEGIN_REQUEST(Pv_Url, 'POST');
    UTL_HTTP.SET_HEADER(Lhttp_Request, 'content-type', Pv_Application);
    UTL_HTTP.SET_BODY_CHARSET(Lhttp_Request, Pv_Charset);
    Ln_LongitudReq  := length(Pcl_Mensaje);
    UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
    WHILE (Ln_Offset < Ln_LongitudReq) LOOP
      DBMS_LOB.READ(Pcl_Mensaje, 
                    Ln_Amount,
                    Ln_Offset,
                    Ln_Buffer);
      UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
      Ln_Offset := Ln_Offset + Ln_Amount;
    END LOOP;
    Lhttp_Response := UTL_HTTP.GET_RESPONSE(Lhttp_Request);
    BEGIN
      LOOP
        utl_http.read_text(Lhttp_Response, l_buffer, 2000);
        dbms_lob.writeappend (Lv_Response, length(l_buffer), l_buffer);
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        utl_http.end_response(Lhttp_Response);
    END;
    Pcl_Respuesta := Lv_Response;
    DBMS_LOB.FREETEMPORARY(Lv_Response);
    DBMS_LOB.FREETEMPORARY(Lv_Respuesta);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error := 'Error en el proceso GNKG_WEB_SERVICE.P_WEB_SERVICE_BR ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('GNKG_WEB_SERVICE',
                                           'GNKG_WEB_SERVICE.P_WEB_SERVICE_BR', 
                                           SQLERRM, 
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_WEB_SERVICE_BR;
  
  PROCEDURE P_GET(Pv_Url      IN  VARCHAR2,
                  Pcl_Headers IN  CLOB,
                  Pn_Code     OUT NUMBER,
                  Pv_Mensaje  OUT VARCHAR2,
                  Pcl_Data    OUT CLOB)
  AS
   Lv_Req           UTL_HTTP.req;
   Lv_Resp          UTL_HTTP.resp;
   Lv_Error         VARCHAR2(1000);
   Ln_CountHeaders  NUMBER;
   Lv_NameHeader    VARCHAR2(250);
   Lv_ValorHeader   VARCHAR2(1500);
   Lv_ValueHeader   VARCHAR2(1500);
   Lcl_Response     CLOB;
   Lcl_Respuesta    CLOB;
   Le_Data          EXCEPTION;
   Le_Headers       EXCEPTION;
  BEGIN
    -- VALIDACIONES
    IF Pv_Url IS NULL THEN
      Lv_Error := 'El campo Pv_Url es obligatorio';
      RAISE Le_Data;
    END IF;
    IF Pcl_Headers = empty_clob() THEN
      Lv_Error := 'El campo Pcl_Headers es obligatorio';
      RAISE Le_Data;
    END IF;
    -- URL
    Lv_Req := UTL_HTTP.begin_request(Pv_Url, 'GET');
    UTL_HTTP.set_transfer_timeout(80);
    -- HEADERS
    APEX_JSON.PARSE(Pcl_Headers);
    Ln_CountHeaders := APEX_JSON.GET_COUNT(P_PATH => 'headers');
    IF Ln_CountHeaders IS NULL THEN
      Lv_Error := 'No se ha encontrado la cabecera headers';
      RAISE Le_Headers;
    END IF;
    FOR I IN 1 .. Ln_CountHeaders LOOP
      Lv_NameHeader := APEX_JSON.get_members(P_PATH => 'headers')(I);
      Lv_ValorHeader := 'headers.' || Lv_NameHeader;
      Lv_ValueHeader := APEX_JSON.get_varchar2(P_PATH => Lv_ValorHeader);
      UTL_HTTP.set_header(Lv_Req, replace(Lv_NameHeader, '"', ''), Lv_ValueHeader);
    END LOOP;
    Lv_Resp := UTL_HTTP.get_response(Lv_Req);
    -- OBTENER LA RESPUESTA.
    BEGIN
      LOOP
        UTL_HTTP.READ_LINE(Lv_Resp, Lcl_Response);
        Lcl_Respuesta := Lcl_Respuesta || Lcl_Response;
      END LOOP;
      UTL_HTTP.END_RESPONSE(Lv_Resp);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN UTL_HTTP.END_RESPONSE(Lv_Resp);
    END;
    Pn_Code    := 0;
    Pv_Mensaje := 'Ok';
    Pcl_Data   := Lcl_Respuesta;
  EXCEPTION
    WHEN Le_Data THEN 
      Pn_Code    := 1;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_GET',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN Le_Headers THEN 
      Pn_Code    := 2;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_GET',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN 
      Pn_Code    := 99;
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_GET',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_GET;
  
  PROCEDURE P_POST(Pv_Url      IN  VARCHAR2,
                   Pcl_Headers IN  CLOB,
                   Pcl_Content IN  CLOB,
                   Pn_Code     OUT NUMBER,
                   Pv_Mensaje  OUT VARCHAR2,
                   Pcl_Data    OUT CLOB)
  AS
   Lv_Req           UTL_HTTP.req;
   Lv_Resp          UTL_HTTP.resp;
   Lv_Error         VARCHAR2(1000);
   Ln_CountHeaders  NUMBER;
   Lv_NameHeader    VARCHAR2(250);
   Lv_ValorHeader   VARCHAR2(1500);
   Lv_ValueHeader   VARCHAR2(1500);
   Lcl_Response     CLOB;
   Lcl_Respuesta    CLOB;
   Le_Data          EXCEPTION;
   Le_Headers       EXCEPTION;
   Ln_LongitudRequest   NUMBER;
   Ln_LongitudIdeal     NUMBER          := 32767;
   Ln_Offset            NUMBER          := 1;
   Ln_Buffer            VARCHAR2(2000);
   Ln_Amount            NUMBER          := 2000;
  BEGIN
    -- VALIDACIONES
    IF Pv_Url IS NULL THEN
      Lv_Error := 'El campo Pv_Url es obligatorio';
      RAISE Le_Data;
    END IF;
    IF Pcl_Headers = empty_clob() THEN
      Lv_Error := 'El campo Pcl_Headers es obligatorio';
      RAISE Le_Data;
    END IF;
    -- CONEXION PERSISTENTE
    UTL_HTTP.set_persistent_conn_support(true);
    -- TIME OUT
    UTL_HTTP.set_transfer_timeout(180);
    -- URL
    Lv_Req := UTL_HTTP.begin_request(Pv_Url, 'POST');
    -- HEADERS
    APEX_JSON.PARSE(Pcl_Headers);
    Ln_CountHeaders := APEX_JSON.GET_COUNT(P_PATH => 'headers');
    IF Ln_CountHeaders IS NULL THEN
      Lv_Error := 'No se ha encontrado la cabecera headers';
      RAISE Le_Headers;
    END IF;
    FOR I IN 1 .. Ln_CountHeaders LOOP
      Lv_NameHeader := APEX_JSON.get_members(P_PATH => 'headers')(I);
      Lv_ValorHeader := 'headers.' || Lv_NameHeader;
      Lv_ValueHeader := APEX_JSON.get_varchar2(P_PATH => Lv_ValorHeader);
      UTL_HTTP.set_header(Lv_Req, replace(Lv_NameHeader, '"', ''), Lv_ValueHeader);
    END LOOP;
    IF Pcl_Content IS NOT NULL THEN
        Ln_LongitudRequest := DBMS_LOB.getlength(Pcl_Content);
        IF Ln_LongitudRequest <= Ln_LongitudIdeal THEN
            UTL_HTTP.set_header(Lv_Req, 'Content-Length', LENGTH(Pcl_Content));
            UTL_HTTP.write_text(Lv_Req, Pcl_Content);
        ELSE
            UTL_HTTP.SET_HEADER(Lv_Req, 'Transfer-Encoding', 'chunked');
            WHILE (Ln_Offset < Ln_LongitudRequest)
            LOOP
                DBMS_LOB.READ(Pcl_Content, Ln_Amount, Ln_Offset, Ln_Buffer);
                UTL_HTTP.WRITE_TEXT(Lv_Req, Ln_Buffer);
                Ln_Offset := Ln_Offset + Ln_Amount;
            END LOOP;
        END IF;
    END IF;
    Lv_Resp := UTL_HTTP.get_response(Lv_Req);
    -- OBTENER LA RESPUESTA.
    BEGIN
      LOOP
        UTL_HTTP.READ_LINE(Lv_Resp, Lcl_Response);
        Lcl_Respuesta := Lcl_Respuesta || Lcl_Response;
      END LOOP;
      UTL_HTTP.END_RESPONSE(Lv_Resp);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN UTL_HTTP.END_RESPONSE(Lv_Resp);
    END;
    Pn_Code    := 0;
    Pv_Mensaje := 'Ok';
    Pcl_Data   := Lcl_Respuesta;
  EXCEPTION
    WHEN Le_Data THEN 
      Pn_Code    := 1;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_POST',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN Le_Headers THEN 
      Pn_Code    := 2;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_POST',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN 
      Pn_Code    := 99;
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_POST',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_POST;
  
  PROCEDURE P_PUT(Pv_Url      IN  VARCHAR2,
                  Pcl_Headers IN  CLOB,
                  Pcl_Content IN  CLOB,
                  Pn_Code     OUT NUMBER,
                  Pv_Mensaje  OUT VARCHAR2,
                  Pcl_Data    OUT CLOB)
  AS
   Lv_Req           UTL_HTTP.req;
   Lv_Resp          UTL_HTTP.resp;
   Lv_Error         VARCHAR2(1000);
   Ln_CountHeaders  NUMBER;
   Lv_NameHeader    VARCHAR2(250);
   Lv_ValorHeader   VARCHAR2(500);
   Lv_ValueHeader   VARCHAR2(1000);
   Lcl_Response     CLOB;
   Lcl_Respuesta    CLOB;
   Le_Data          EXCEPTION;
   Le_Headers       EXCEPTION;
  BEGIN
    -- VALIDACIONES
    IF Pv_Url IS NULL THEN
      Lv_Error := 'El campo Pv_Url es obligatorio';
      RAISE Le_Data;
    END IF;
    IF Pcl_Headers = empty_clob() THEN
      Lv_Error := 'El campo Pcl_Headers es obligatorio';
      RAISE Le_Data;
    END IF;
    -- URL
    Lv_Req := UTL_HTTP.begin_request(Pv_Url, 'PUT');
    UTL_HTTP.set_transfer_timeout(80);
    -- HEADERS
    APEX_JSON.PARSE(Pcl_Headers);
    Ln_CountHeaders := APEX_JSON.GET_COUNT(P_PATH => 'headers');
    IF Ln_CountHeaders IS NULL THEN
      Lv_Error := 'No se ha encontrado la cabecera headers';
      RAISE Le_Headers;
    END IF;
    FOR I IN 1 .. Ln_CountHeaders LOOP
      Lv_NameHeader := APEX_JSON.get_members(P_PATH => 'headers')(I);
      Lv_ValorHeader := 'headers.' || Lv_NameHeader;
      Lv_ValueHeader := APEX_JSON.get_varchar2(P_PATH => Lv_ValorHeader);
      UTL_HTTP.set_header(Lv_Req, replace(Lv_NameHeader, '"', ''), Lv_ValueHeader);
    END LOOP;
    IF Pcl_Content IS NOT NULL THEN
      UTL_HTTP.set_header(Lv_Req, 'Content-Length', LENGTH(Pcl_Content));
      UTL_HTTP.write_text(Lv_Req, Pcl_Content);
    END IF;
    Lv_Resp := UTL_HTTP.get_response(Lv_Req);
    -- OBTENER LA RESPUESTA.
    BEGIN
      LOOP
        UTL_HTTP.READ_LINE(Lv_Resp, Lcl_Response);
        Lcl_Respuesta := Lcl_Respuesta || Lcl_Response;
      END LOOP;
      UTL_HTTP.END_RESPONSE(Lv_Resp);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN UTL_HTTP.END_RESPONSE(Lv_Resp);
    END;
    Pn_Code    := 0;
    Pv_Mensaje := 'Ok';
    Pcl_Data   := Lcl_Respuesta;
  EXCEPTION
    WHEN Le_Data THEN 
      Pn_Code    := 1;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_PUT',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN Le_Headers THEN 
      Pn_Code    := 2;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_PUT',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN 
      Pn_Code    := 99;
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_PUT',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_PUT;
  
  PROCEDURE P_DELETE(Pv_Url      IN  VARCHAR2,
                     Pcl_Headers IN  CLOB,
                     Pcl_Content IN  CLOB,
                     Pn_Code     OUT NUMBER,
                     Pv_Mensaje  OUT VARCHAR2,
                     Pcl_Data    OUT CLOB)
  AS
   Lv_Req           UTL_HTTP.req;
   Lv_Resp          UTL_HTTP.resp;
   Lv_Error         VARCHAR2(1000);
   Ln_CountHeaders  NUMBER;
   Lv_NameHeader    VARCHAR2(250);
   Lv_ValorHeader   VARCHAR2(500);
   Lv_ValueHeader   VARCHAR2(1000);
   Lcl_Response     CLOB;
   Lcl_Respuesta    CLOB;
   Le_Data          EXCEPTION;
   Le_Headers       EXCEPTION;
  BEGIN
    -- VALIDACIONES
    IF Pv_Url IS NULL THEN
      Lv_Error := 'El campo Pv_Url es obligatorio';
      RAISE Le_Data;
    END IF;
    IF Pcl_Headers = empty_clob() THEN
      Lv_Error := 'El campo Pcl_Headers es obligatorio';
      RAISE Le_Data;
    END IF;
    -- URL
    Lv_Req := UTL_HTTP.begin_request(Pv_Url, 'DELETE');
    UTL_HTTP.set_transfer_timeout(80);
    -- HEADERS
    APEX_JSON.PARSE(Pcl_Headers);
    Ln_CountHeaders := APEX_JSON.GET_COUNT(P_PATH => 'headers');
    IF Ln_CountHeaders IS NULL THEN
      Lv_Error := 'No se ha encontrado la cabecera headers';
      RAISE Le_Headers;
    END IF;
    FOR I IN 1 .. Ln_CountHeaders LOOP
      Lv_NameHeader := APEX_JSON.get_members(P_PATH => 'headers')(I);
      Lv_ValorHeader := 'headers.' || Lv_NameHeader;
      Lv_ValueHeader := APEX_JSON.get_varchar2(P_PATH => Lv_ValorHeader);
      UTL_HTTP.set_header(Lv_Req, replace(Lv_NameHeader, '"', ''), Lv_ValueHeader);
    END LOOP;
    IF Pcl_Content IS NOT NULL THEN
      UTL_HTTP.set_header(Lv_Req, 'Content-Length', LENGTH(Pcl_Content));
      UTL_HTTP.write_text(Lv_Req, Pcl_Content);
    END IF;
    Lv_Resp := UTL_HTTP.get_response(Lv_Req);
    -- OBTENER LA RESPUESTA.
    BEGIN
      LOOP
        UTL_HTTP.READ_LINE(Lv_Resp, Lcl_Response);
        Lcl_Respuesta := Lcl_Respuesta || Lcl_Response;
      END LOOP;
      UTL_HTTP.END_RESPONSE(Lv_Resp);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN UTL_HTTP.END_RESPONSE(Lv_Resp);
    END;
    Pn_Code    := 0;
    Pv_Mensaje := 'Ok';
    Pcl_Data   := Lcl_Respuesta;
  EXCEPTION
    WHEN Le_Data THEN 
      Pn_Code    := 1;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_DELETE',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN Le_Headers THEN 
      Pn_Code    := 2;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_DELETE',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN 
      Pn_Code    := 99;
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_DELETE',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_DELETE;

  PROCEDURE P_PATCH(Pv_Url      IN  VARCHAR2,
                    Pcl_Headers IN  CLOB,
                    Pcl_Content IN  CLOB,
                    Pn_Code     OUT NUMBER,
                    Pv_Mensaje  OUT VARCHAR2,
                    Pcl_Data    OUT CLOB)
  AS
   Lv_Req           UTL_HTTP.req;
   Lv_Resp          UTL_HTTP.resp;
   Lv_Error         VARCHAR2(1000);
   Ln_CountHeaders  NUMBER;
   Lv_NameHeader    VARCHAR2(250);
   Lv_ValorHeader   VARCHAR2(500);
   Lv_ValueHeader   VARCHAR2(1000);
   Lcl_Response     CLOB;
   Lcl_Respuesta    CLOB;
   Le_Data          EXCEPTION;
   Le_Headers       EXCEPTION;
  BEGIN
    -- VALIDACIONES
    IF Pv_Url IS NULL THEN
      Lv_Error := 'El campo Pv_Url es obligatorio';
      RAISE Le_Data;
    END IF;
    IF Pcl_Headers = empty_clob() THEN
      Lv_Error := 'El campo Pcl_Headers es obligatorio';
      RAISE Le_Data;
    END IF;
    -- URL
    Lv_Req := UTL_HTTP.begin_request(Pv_Url, 'PATCH');
    UTL_HTTP.set_transfer_timeout(80);
    -- HEADERS
    APEX_JSON.PARSE(Pcl_Headers);
    Ln_CountHeaders := APEX_JSON.GET_COUNT(P_PATH => 'headers');
    IF Ln_CountHeaders IS NULL THEN
      Lv_Error := 'No se ha encontrado la cabecera headers';
      RAISE Le_Headers;
    END IF;
    FOR I IN 1 .. Ln_CountHeaders LOOP
      Lv_NameHeader := APEX_JSON.get_members(P_PATH => 'headers')(I);
      Lv_ValorHeader := 'headers.' || Lv_NameHeader;
      Lv_ValueHeader := APEX_JSON.get_varchar2(P_PATH => Lv_ValorHeader);
      UTL_HTTP.set_header(Lv_Req, replace(Lv_NameHeader, '"', ''), Lv_ValueHeader);
    END LOOP;
    IF Pcl_Content IS NOT NULL THEN
      UTL_HTTP.set_header(Lv_Req, 'Content-Length', LENGTH(Pcl_Content));
      UTL_HTTP.write_text(Lv_Req, Pcl_Content);
    END IF;
    Lv_Resp := UTL_HTTP.get_response(Lv_Req);
    -- OBTENER LA RESPUESTA.
    BEGIN
      LOOP
        UTL_HTTP.READ_LINE(Lv_Resp, Lcl_Response);
        Lcl_Respuesta := Lcl_Respuesta || Lcl_Response;
      END LOOP;
      UTL_HTTP.END_RESPONSE(Lv_Resp);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN UTL_HTTP.END_RESPONSE(Lv_Resp);
    END;
    Pn_Code    := 0;
    Pv_Mensaje := 'Ok';
    Pcl_Data   := Lcl_Respuesta;
  EXCEPTION
    WHEN Le_Data THEN 
      Pn_Code    := 1;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_PATCH',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN Le_Headers THEN 
      Pn_Code    := 2;
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_PATCH',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN 
      Pn_Code    := 99;
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_PATCH',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_PATCH;

		PROCEDURE add_param(
			p_parts IN OUT parts,
			p_name  IN VARCHAR2,
			p_value IN VARCHAR2 )
	AS
		v_part part;
	BEGIN
		v_part.ds_header := 'Content-Disposition: form-data; name="' || p_name || '"' || v_newline || v_newline ;
		v_part.ds_value  := p_value;
		p_parts.EXTEND();
		p_parts(p_parts.last) := v_part;
	END add_param;
	
	PROCEDURE add_file(
			p_parts IN OUT parts,
			p_name  IN VARCHAR2,
			p_filename     VARCHAR2,
			p_content_type VARCHAR2,
			p_blob bfile )
	AS
		v_part part;
	BEGIN
		v_part.ds_header := 'Content-Disposition: form-data; name="' || p_name || '"; filename="' || p_filename || '"' || v_newline || 'Content-Type: ' || p_content_type || v_newline || v_newline ;
		v_part.ds_blob   := p_blob;
		p_parts.EXTEND();
		p_parts(p_parts.last) := v_part;
	END add_file;
	
	PROCEDURE send(
			p_req   IN OUT utl_http.req,
			p_parts IN OUT parts )
	AS
		v_length     NUMBER := 0;
		v_length_bo  NUMBER := LENGTH(v_boundary);
		v_length_nl  NUMBER := LENGTH(v_newline);
		v_length_end NUMBER := LENGTH(v_end);
		v_step pls_integer  := 12000;
		v_count pls_integer := 0;
		idx NUMBER;
	BEGIN
		v_length := v_length + v_length_end + v_length_bo + v_length_nl;
		idx := p_parts.first;
		WHILE(idx IS NOT NULL)
		LOOP
			v_length              := v_length + LENGTH(p_parts(idx).ds_header);
			IF(p_parts(idx).ds_blob IS NOT NULL) THEN
				v_length             := v_length + dbms_lob.getlength(p_parts(idx).ds_blob);
			ELSE
				v_length := v_length + LENGTH(p_parts(idx).ds_value);
			END IF;
			v_length  := v_length + v_length_nl;
			v_length  := v_length + v_length_end + v_length_bo;
			IF(idx      != p_parts.last) THEN
				v_length := v_length + v_length_nl;
			END IF;
			idx := p_parts.NEXT(idx);
		END LOOP;
		v_length := v_length + v_length_end + v_length_nl;
		utl_http.set_header(p_req, 'Content-Type', 'multipart/form-data; boundary=' || v_boundary);
		utl_http.set_header(p_req, 'Content-Length', v_length);
		utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_end));
		utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_boundary));
		utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_newline));

		idx := p_parts.first;
		WHILE(idx IS NOT NULL)
		LOOP
			utl_http.write_raw(p_req, utl_raw.cast_to_raw(p_parts(idx).ds_header));
			IF(p_parts(idx).ds_blob IS NOT NULL) THEN
				dbms_lob.open(p_parts(idx).ds_blob, dbms_lob.lob_readonly);
				v_count := TRUNC((dbms_lob.getlength(p_parts(idx).ds_blob) - 1)/v_step);
				FOR j                                                   IN 0..v_count
				LOOP
					utl_http.write_raw(p_req, dbms_lob.substr(p_parts(idx).ds_blob, v_step, j * v_step + 1));
				END LOOP;
				dbms_lob.close(p_parts(idx).ds_blob);
			ELSE
				utl_http.write_raw(p_req, utl_raw.cast_to_raw(p_parts(idx).ds_value));
			END IF;
			utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_newline));
			utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_end));
			utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_boundary));
			IF(idx != p_parts.last) THEN
				utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_newline));
			END IF;
			idx := p_parts.NEXT(idx);
		END LOOP;
		utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_end));
		utl_http.write_raw(p_req, utl_raw.cast_to_raw(v_newline));
	END send;
	
	PROCEDURE P_FORM(
			p_method VARCHAR2,
			p_url    VARCHAR2,
			p_parts IN OUT parts,
			response IN OUT CLOB,
			Pcl_Headers IN  CLOB DEFAULT '')
	AS
		idx             NUMBER;
		jsonHeaderKey   VARCHAR2(100);
		jsonHeaderValue VARCHAR2(100);
		statusCode            NUMBER;
		l_request_body_length NUMBER;
		-- buffering
		l_offset NUMBER := 1;
		l_amount NUMBER := 2000; -- De 2000 en 2000 caracteres
		l_buffer VARCHAR2(2000);
		Ln_CountHeaders NUMBER;
		Lv_Error         VARCHAR2(1000);
		Le_Headers       EXCEPTION;
		Pn_Code NUMBER;
		Pv_Mensaje VARCHAR2(256);
	BEGIN
		DECLARE
			req utl_http.req;
			res utl_http.resp;
			vResult CLOB;
			Lv_NameHeader VARCHAR2(256);
			Lv_ValorHeader VARCHAR2(512);
			Lv_ValueHeader VARCHAR2(256);
		BEGIN
			utl_http.set_transfer_timeout(60);
			req := utl_http.begin_request(p_url, p_method, 'HTTP/1.1');
			utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
			APEX_JSON.PARSE(Pcl_Headers);
			Ln_CountHeaders := APEX_JSON.GET_COUNT(P_PATH => 'headers');
			IF Ln_CountHeaders IS NULL THEN
			  Lv_Error := 'No se ha encontrado la cabecera headers';
			  RAISE Le_Headers;
			END IF;
			FOR I IN 1 .. Ln_CountHeaders LOOP
			  Lv_NameHeader := APEX_JSON.get_members(P_PATH => 'headers')(I);
			  Lv_ValorHeader := 'headers.' || Lv_NameHeader;
			  Lv_ValueHeader := APEX_JSON.get_varchar2(P_PATH => Lv_ValorHeader);
			  UTL_HTTP.set_header(req, replace(Lv_NameHeader, '"', ''), Lv_ValueHeader);
			END LOOP;
			
			send(req, p_parts);
			res          := utl_http.get_response(req);
			statusCode   := to_number(trim(res.status_code));
			
			-- deber�an manejarse UTL_HTTP.HTTP_BAD_REQUEST y UTL_HTTP.HTTP_NOT_FOUND
			BEGIN
				LOOP
					utl_http.read_line(res, vResult);
					response := response || vResult;
				END LOOP;
				utl_http.end_response(res);
			EXCEPTION
			WHEN utl_http.end_of_body THEN
				utl_http.end_response(res);
			END;
		EXCEPTION
		WHEN OTHERS THEN
			IF req.private_hndl IS NOT NULL THEN
				utl_http.end_request(req);
			END IF;
			IF res.private_hndl IS NOT NULL THEN
				utl_http.end_response(res);
			END IF;
			RAISE;
		END;
	EXCEPTION
	WHEN Le_Headers THEN 
      Pn_Code    := 2;
      Pv_Mensaje := 'No se proporcionaron headers.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO WEB SERVICE', 
                                           'GNKG_WEB_SERVICE.P_DELETE',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
	END P_FORM;

END GNKG_WEB_SERVICE;
/
