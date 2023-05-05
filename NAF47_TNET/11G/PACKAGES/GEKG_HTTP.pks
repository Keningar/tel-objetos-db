CREATE OR REPLACE PACKAGE            GEKG_HTTP AS
    /**
     * Envia peticiones con body
     * @param Pv_URL             IN                 VARCHAR2 URL 
     * @param Pv_Request         IN                 VARCHAR2 Informacion en formato JSON
     * @param Pv_Method          IN                 VARCHAR2 Metodo de request
     * @param Pv_Version         IN                 VARCHAR2 Version HTTP
     * @param Prry_RequestHeader IN                 GEKG_TYPE.RequestHeader Request Header
     * @param Pv_Result          IN                 VARCHAR2 Resultado sin parsear
     * @param Pv_Status          IN                 VARCHAR2 Estado del request
     * @param Pv_Code            IN                 VARCHAR2 Codigo del request
     * @param Pv_Msn             IN                 VARCHAR2 Retorna mensaje en caso de haber error
     **/
    PROCEDURE P_REQUEST_REST (
        Pv_URL               IN                   VARCHAR2,
        Pv_Request           IN                   VARCHAR2,
        Pv_Method            IN                   VARCHAR2,
        Pv_Version           IN                   VARCHAR2,
        Prry_RequestHeader   IN                   GEKG_TYPE.RequestHeader,
        Pv_Result            OUT                  VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    );

    /**
     * Envia peticiones
     * @param Pv_URL             IN                 VARCHAR2 URL 
     * @param Pv_Request         IN                 VARCHAR2 Informacion en formato JSON
     * @param Pv_Method          IN                 VARCHAR2 Metodo de request
     * @param Pv_Version         IN                 VARCHAR2 Version HTTP
     * @param Prry_RequestHeader IN                 GEKG_TYPE.RequestHeader Request Header
     * @param Pv_Result          IN                 VARCHAR2 Resultado sin parsear
     * @param Pv_Status          IN                 VARCHAR2 Estado del request
     * @param Pv_Code            IN                 VARCHAR2 Codigo del request
     * @param Pv_Msn             IN                 VARCHAR2 Retorna mensaje en caso de haber error
     **/

    PROCEDURE P_REQUEST_SOAP (
        Pv_URL               IN                   VARCHAR2,
        Pv_Request           IN                   VARCHAR2,
        Pv_Method            IN                   VARCHAR2,
        Pv_Version           IN                   VARCHAR2,
        Prry_RequestHeader   IN                   GEKG_TYPE.RequestHeader,
        Pv_Result            OUT                  CLOB,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    );

END GEKG_HTTP;
/


CREATE OR REPLACE PACKAGE BODY            GEKG_HTTP AS

    PROCEDURE P_REQUEST_REST (
        Pv_URL               IN                   VARCHAR2,
        Pv_Request           IN                   VARCHAR2,
        Pv_Method            IN                   VARCHAR2,
        Pv_Version           IN                   VARCHAR2,
        Prry_RequestHeader   IN                   GEKG_TYPE.RequestHeader,
        Pv_Result            OUT                  VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    ) AS

        Ln_LongitudReq     NUMBER;
        Ln_LongitudIdeal   NUMBER := 32767;
        Ln_Offset          NUMBER := 1;
        Ln_Buffer          VARCHAR2(2000);
        Ln_Amount          NUMBER := 2000;
        Lhttp_Request      UTL_HTTP.REQ;
        Lhttp_Response     UTL_HTTP.RESP;
        Ljson_Result       VARCHAR2(32767);
        ArrayIndex         VARCHAR2(200);
        Ljson_Request      VARCHAR2(32767) := Pv_Request;
        Ljson_Response     VARCHAR2(4000);
    BEGIN
        Lhttp_Request := UTL_HTTP.BEGIN_REQUEST(Pv_URL, Pv_Method, Pv_Version);
        ArrayIndex := Prry_RequestHeader.FIRST;
        WHILE ( ArrayIndex IS NOT NULL ) LOOP
            UTL_HTTP.SET_HEADER(Lhttp_Request, ArrayIndex, Prry_RequestHeader(ArrayIndex));
            ArrayIndex := Prry_RequestHeader.next(ArrayIndex);
        END LOOP;

        Ln_LongitudReq := DBMS_LOB.GETLENGTH(Ljson_Request);
        IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
            UTL_HTTP.SET_HEADER(Lhttp_Request, 'Content-Length', LENGTH(Ljson_Request));
            UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ljson_Request);
        ELSE
            UTL_HTTP.SET_HEADER(Lhttp_Request, 'Transfer-Encoding', 'chunked');
            WHILE ( Ln_Offset < Ln_LongitudReq ) LOOP
                DBMS_LOB.READ(Ljson_Request, Ln_Amount, Ln_Offset, Ln_Buffer);
                UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
                Ln_Offset := Ln_Offset + Ln_Amount;
            END LOOP;

        END IF;

        Lhttp_Response := UTL_HTTP.GET_RESPONSE(Lhttp_Request);
        UTL_HTTP.READ_TEXT(Lhttp_Response, Ljson_Response);
        Pv_Result := Ljson_Response;
        APEX_JSON.PARSE(Ljson_Response);
        Pv_Status := APEX_JSON.GET_VARCHAR2('status');
        Pv_Code := APEX_JSON.GET_VARCHAR2('code');
        Pv_Msn := NVL(APEX_JSON.GET_VARCHAR2('msn'), 'Sin mensaje');
        UTL_HTTP.END_RESPONSE(Lhttp_Response);
    EXCEPTION
        WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
            Pv_Msn := 'Error UTL_HTTP.TOO_MANY_REQUESTS'
                      || SQLERRM
                      || ' '
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
            UTL_HTTP.END_REQUEST(Lhttp_Request);
        WHEN UTL_HTTP.END_OF_BODY THEN
            Pv_Msn := 'Error UTL_HTTP.END_OF_BODY'
                      || SQLERRM
                      || ' '
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
            UTL_HTTP.END_REQUEST(Lhttp_Request);
        WHEN OTHERS THEN
            Pv_Msn := 'Error en NAF47_TNET.WHEN OTHERS: '
                      || SQLERRM
                      || ' '
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
            UTL_HTTP.END_REQUEST(Lhttp_Request);
    END P_REQUEST_REST;

    PROCEDURE P_REQUEST_SOAP (
        Pv_URL               IN                   VARCHAR2,
        Pv_Request           IN                   VARCHAR2,
        Pv_Method            IN                   VARCHAR2,
        Pv_Version           IN                   VARCHAR2,
        Prry_RequestHeader   IN                   GEKG_TYPE.RequestHeader,
        Pv_Result            OUT                  CLOB,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    ) AS

        Lhttp_Request    UTL_HTTP.REQ;
        Lhttp_Response   UTL_HTTP.RESP;
        Lbuffer_Result   VARCHAR2(32767);
        ArrayIndex       VARCHAR2(200);
        Lv_Request       VARCHAR2(32767) := Pv_Request;
        Lc_Response      CLOB;
    BEGIN
        Lhttp_Request := UTL_HTTP.BEGIN_REQUEST(Pv_URL, Pv_Method, Pv_Version);
        ArrayIndex := Prry_RequestHeader.FIRST;
        WHILE ( ArrayIndex IS NOT NULL ) LOOP
            UTL_HTTP.SET_HEADER(Lhttp_Request, ArrayIndex, Prry_RequestHeader(ArrayIndex));
            ArrayIndex := Prry_RequestHeader.next(ArrayIndex);
        END LOOP;

        UTL_HTTP.WRITE_TEXT(Lhttp_Request, Lv_Request);
        Lhttp_Response := UTL_HTTP.GET_RESPONSE(Lhttp_Request);
        DBMS_LOB.CREATETEMPORARY(Lc_Response, FALSE);
        DBMS_LOB.OPEN(Lc_Response, DBMS_LOB.LOB_READWRITE);
        BEGIN
            LOOP
                UTL_HTTP.READ_TEXT(Lhttp_Response, Lbuffer_Result);
                DBMS_LOB.WRITEAPPEND(Lc_Response, LENGTH(Lbuffer_Result), Lbuffer_Result);
            END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE <> -29266 THEN
                    RAISE;
                END IF;
        END;

        Pv_Result := Lc_Response;
        Pv_Status := Lhttp_Response.REASON_PHRASE;
        Pv_Code := Lhttp_Response.STATUS_CODE;
        Pv_Msn := Lhttp_Response.REASON_PHRASE;
        UTL_HTTP.END_RESPONSE(Lhttp_Response);
    EXCEPTION
        WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
            Pv_Msn := 'Error UTL_HTTP.TOO_MANY_REQUESTS'
                      || SQLERRM
                      || ' '
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
            UTL_HTTP.END_REQUEST(Lhttp_Request);
        WHEN UTL_HTTP.END_OF_BODY THEN
            Pv_Msn := 'Error UTL_HTTP.END_OF_BODY'
                      || SQLERRM
                      || ' '
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
            UTL_HTTP.END_REQUEST(Lhttp_Request);
        WHEN OTHERS THEN
            Pv_Msn := 'Error en NAF47_TNET.WHEN OTHERS: '
                      || SQLERRM
                      || ' '
                      || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
            UTL_HTTP.END_REQUEST(Lhttp_Request);
    END P_REQUEST_SOAP;

END GEKG_HTTP;
/
