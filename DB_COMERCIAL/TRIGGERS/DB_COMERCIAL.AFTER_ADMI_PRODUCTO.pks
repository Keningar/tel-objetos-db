CREATE OR REPLACE TRIGGER DB_COMERCIAL.AFTER_ADMI_PRODUCTO AFTER
        INSERT OR DELETE OR UPDATE ON db_comercial.admi_producto
        REFERENCING
                OLD AS OLD
                NEW AS NEW
        FOR EACH ROW
DECLARE
    --
        lc_json                CLOB;
        lv_op                  VARCHAR2(20);
        lhttp_request          utl_http.req;
        lhttp_response         utl_http.resp;
        lv_urltelcocrm         VARCHAR2(200);
        lv_json                VARCHAR2(100) := 'JSON';
        lv_method              VARCHAR2(100) := 'procesar';
        lv_request_data        VARCHAR2(4000);
        lv_request_data_length NUMBER;
        lv_data                VARCHAR2(4000);
        lv_status              VARCHAR2(50);
        lv_message             VARCHAR2(4000);
    --
        CURSOR lc_parametro_det IS
        SELECT
            det.valor1
        FROM
                db_general.admi_parametro_cab cab
            JOIN db_general.admi_parametro_det det ON det.parametro_id = cab.id_parametro
        WHERE
                cab.nombre_parametro = 'PARAMETROS_TELCOCRM'
            AND cab.estado = 'Activo'
            AND det.descripcion = 'URL_TELCOCRM';
        --
        lv_parametro_det     db_general.admi_parametro_det.valor1%TYPE;
        le_exceptionTelcoCrm EXCEPTION;
        le_exceptionTelcoS   EXCEPTION;
    --
    BEGIN
        lv_message      := '';
        lv_request_data := '';
        OPEN lc_parametro_det;
        FETCH lc_parametro_det INTO lv_parametro_det;
        IF(lc_parametro_det%found)THEN
            lv_urltelcocrm := lv_parametro_det;
        ELSE
            lv_message := 'Url de TelcoCRM no se encuentra parametrizada';
            RAISE le_exceptionTelcoS;
        END IF;
        CLOSE lc_parametro_det;
        IF :NEW.empresa_cod != 10 THEN
            lv_message := 'La sincronización con TelcoCRM solo aplica con la empresa Telconet S.A.';
            RAISE le_exceptionTelcoS;
        END IF;
        --Creamos el json para el request
        lc_json := '{';
        lc_json := lc_json|| '"arrayParametros":'|| '{'|| '';
        lc_json := lc_json|| '"arrayParametrosCRM":'|| '{'|| '';
        lc_json := lc_json|| '"strCodigo":"'|| translate(:NEW.codigo_producto,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
        lc_json := lc_json|| '"strCategoria":"'|| translate(:NEW.linea_negocio,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
        lc_json := lc_json|| '"strTipo":"'|| translate(:NEW.tipo,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
        lc_json := lc_json|| '"strGrupo":"'|| translate(:NEW.grupo,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
        lc_json := lc_json|| '"strSubGrupo":"'|| translate(:NEW.subgrupo,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
        CASE
            WHEN inserting THEN
                lc_json := lc_json|| '"strNombreProducto":"'|| translate(:NEW.descripcion_producto,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
                IF :NEW.estado != 'Activo' and :NEW.estado != 'Pendiente' THEN
                    lc_json := lc_json|| '"strEliminar":"'|| 'SI'|| '",';
                END IF;
                lv_op   := 'createProducto';
            WHEN updating THEN
                lc_json := lc_json|| '"strNombreProducto":"'|| translate(:OLD.descripcion_producto,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
                lc_json := lc_json|| '"strNombreProductoNew":"'|| translate(:NEW.descripcion_producto,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
                IF :NEW.estado != 'Activo' and :NEW.estado != 'Pendiente' THEN
                    lc_json := lc_json|| '"strEliminar":"'|| 'SI'|| '",';
                END IF;
                lv_op   := 'editProducto';
            WHEN deleting THEN
                lc_json := lc_json|| '"strNombreProducto":"'|| translate(:OLD.descripcion_producto,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
                lc_json := lc_json|| '"strNombreProductoNew":"'|| translate(:NEW.descripcion_producto,'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN')|| '",';
                lv_op   := 'editProducto';
                lc_json := lc_json|| '"strEliminar":"'|| 'SI'|| '",';
            ELSE 
                lv_message := 'Opción no contemplada para ejcutar el trigger';
                RAISE le_exceptionTelcoS;
        END CASE;
        --
        lc_json := lc_json|| '"strUsuarioCreacion":"'|| :NEW.usr_creacion|| '",';
        lc_json := lc_json|| '"strPrefijoEmpresa":"'|| 'TN'|| '",';
        lc_json := lc_json|| '"strCodEmpresa":"'|| :NEW.empresa_cod|| '"},';
        lc_json := lc_json|| '"strOp":"'|| lv_op|| '"';
        lc_json := lc_json || '}}';
        --
        lv_request_data := lv_request_data|| 'method='|| lv_method|| '&';
        lv_request_data := lv_request_data|| 'input_type='|| lv_json|| '&';
        lv_request_data := lv_request_data|| 'response_type='|| lv_json|| '&';
        lv_request_data := lv_request_data|| 'rest_data='|| lc_json;
        --
        lv_request_data_length := LENGTH(lv_request_data);
        --Ingresamos el request hacia la api de TelcoCRM
        lhttp_request := utl_http.begin_request(URL => lv_urltelcocrm, METHOD => 'POST');
        utl_http.set_header(R => lhttp_request, NAME => 'Content-Type', VALUE => 'application/x-www-form-urlencoded');
        utl_http.set_header(R => lhttp_request, NAME => 'Content-Length', VALUE => lv_request_data_length);
        utl_http.set_transfer_timeout(500);
        utl_http.write_text(R => lhttp_request, DATA => lv_request_data);
        lhttp_response := utl_http.get_response(lhttp_request);
        utl_http.read_text(lhttp_response, lv_data);
        utl_http.end_response(lhttp_response);
        apex_json.parse(lv_data);
        lv_status := apex_json.get_varchar2('status');
        lv_message := apex_json.get_varchar2('message');
        IF lv_status != 200 THEN
            RAISE le_exceptionTelcoCrm;
        END IF;
    EXCEPTION
        WHEN le_exceptionTelcoCrm THEN
            db_general.gnrlpck_util.insert_error('Oracle-WebService',
                                                'Trigger db_comercial.after_admi_producto',
                                                'ERROR DE TELCOCRM: ' || lv_message,
                                                nvl(sys_context('USERENV', 'HOST'), 'DB_COMERCIAL'),
                                                sysdate,
                                                nvl(sys_context('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
        WHEN le_exceptionTelcoS THEN
            db_general.gnrlpck_util.insert_error('Oracle-WebService',
                                                'Trigger db_comercial.after_admi_producto',
                                                'ERROR DE TELCOS: ' || lv_message,
                                                nvl(sys_context('USERENV', 'HOST'), 'DB_COMERCIAL'),
                                                sysdate,
                                                nvl(sys_context('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
        WHEN utl_http.request_failed THEN
            db_general.gnrlpck_util.insert_error('Oracle-WebService',
                                                'Trigger db_comercial.after_admi_producto',
                                                'ERROR AL CREAR CONEXION  '|| sqlerrm,
                                                nvl(sys_context('USERENV', 'HOST'), 'DB_COMERCIAL'),
                                                sysdate,
                                                nvl(sys_context('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
        WHEN OTHERS THEN
            db_general.gnrlpck_util.insert_error('Oracle-WebService',
                                                'Trigger db_comercial.after_admi_producto',
                                                'ERROR: '|| dbms_utility.format_error_stack|| ' - '|| dbms_utility.format_error_backtrace,
                                                nvl(sys_context('USERENV', 'HOST'), 'DB_COMERCIAL'),
                                                sysdate,
                                                nvl(sys_context('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    END after_admi_producto;
/
