CREATE OR REPLACE package NAF47_TNET.INKG_GESTION_APUS AS

/**
  * Documentacion para P_CREAR_APU
  * FUNCION PARA OBTENER Y VALIDAR PARAMETROS.
  * @ANDRES MONTERO <amontero@telconet.ec>
  * @version 1.0 15/05/2022
  *
  * @param Pv_tipoValidacion        IN VARCHAR2 Parametros de tipo de validacion
  * RETURN      VARCHAR2     Resultado de VALIDACION
  */
    


FUNCTION F_GET_PARAMETROS_SOLICITUDES(
    Pv_tipoValidacion VARCHAR2
    )
    RETURN VARCHAR2;

  /**
  * Documentacion para P_CREAR_APU
  * PROCEDIMIENTO ALMACENADO QUE PERMITE CREAS APUS.
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT SYS_REFCURSOR CURSOR con el resultado
  */


PROCEDURE P_CREAR_APU(
                        Pd_request CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     );
                     
/**
  * Documentacion para P_CREAR_APU
  * PROCEDIMIENTO ALMACENADO PARA LISTAR MATERIALES DE UN APU.
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de consulta en formato JSON
  */
                     
PROCEDURE P_OBTENER_DATOS_DETALLE_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out CLOB
                     );

/**
  * Documentacion para P_OBTENER_DATOS_PRODUCTOS_APU
  * PROCEDIMIENTO ALMACENADO PARA LISTAR PRODUCTOS/SERVICIOS
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de consulta en formato JSON
  */
PROCEDURE P_OBTENER_DATOS_PRODUCTOS_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out CLOB
                     );

/**
  * Documentacion para P_ACTUALIZAR_APU
  * PROCEDIMIENTO ALMACENADO PARA EDITAR APUS
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de la edicion en formato JSON
  */
PROCEDURE P_ACTUALIZAR_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     );
  /**                   
  * Documentacion para P_CREAR_DETALLE_APU
  * PROCEDIMIENTO ALMACENADO PARA INSETAR MATERIALES EN UN APU
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de la edicion en formato JSON
  */
PROCEDURE P_CREAR_DETALLE_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     );

/**
  * Documentacion para P_ACTUALIZAR_DETALLE_APU
  * PROCEDIMIENTO ALMACENADO PARA EDITAR MATERIALES EN UN APU
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de consulta en formato JSON
  */

PROCEDURE P_ACTUALIZAR_DETALLE_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     );


/**
  * Documentacion para P_CANCELAR_APU
  * PROCEDIMIENTO ALMACENADO PARA INACTIVAR APUS
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de la transaccion en formato JSON
  */

PROCEDURE P_CANCELAR_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     );


/**
  * Documentacion para P_OBTENER_LISTADO_APU
  * PROCEDIMIENTO ALMACENADO PARA LISTAR APUS
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de la transaccion en formato JSON
  */

PROCEDURE P_OBTENER_LISTADO_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out CLOB
                     );

/**
  * Documentacion para P_CANCELAR_DETALLE_APU
  * PROCEDIMIENTO ALMACENADO PARA INACTIVAR MATERIALES DE UN APU
  * @luis ardila <lardila@telconet.ec>
  * @version 1.0 30/05/2022
  *
  * @param Pd_request        IN CLOB Parametros de entrada en formato JSON
  * @param Pv_status         OUT VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_mensaje        OUT VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pd_response       OUT CLOB JSON Resultado de la transaccion en formato JSON
  */

PROCEDURE P_CANCELAR_DETALLE_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     );

END INKG_GESTION_APUS;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.INKG_GESTION_APUS AS
  --

    FUNCTION f_get_parametros_solicitudes (
        pv_tipovalidacion VARCHAR2
    ) RETURN VARCHAR2 IS
    --
        TYPE ln_array IS
            VARRAY(20) OF INTEGER;
        le_exception EXCEPTION;
        lv_mensajeerror VARCHAR2(4000);
        lv_resultado    VARCHAR2(4000);
        lv_query        VARCHAR2(1000);
    --
    BEGIN
    --
        lv_resultado := '';
    --
        IF pv_tipovalidacion IS NOT NULL THEN
            SELECT
                'OK'
            INTO lv_resultado
            FROM
                dual;

        END IF;    
    --
        RETURN lv_resultado;
  --
  --
    EXCEPTION
        WHEN no_data_found THEN
            RETURN '';

  --
    END f_get_parametros_solicitudes;

    PROCEDURE p_crear_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT SYS_REFCURSOR
    ) AS
        -----------ADMI_APU------------

        lv_code                VARCHAR2(50);
        lv_name                VARCHAR2(50);
        lv_description         VARCHAR2(100);
        lv_brand               VARCHAR2(50);
        ln_departmentid        VARCHAR2(50);
        lv_companycode         VARCHAR2(50);
        lv_registeruser        VARCHAR2(50);
        lv_fecha_creacion      VARCHAR2(50);
        ln_id_apu              NUMBER;
        -------------------------------

        ln_iteradori           NUMBER;
        --------- producs
        ln_products_count      NUMBER;
        ln_producto_id         NUMBER;
        --------------------
        ----------ITEMS
        ln_items_count         NUMBER;
        ln_id_apu_articulo     NUMBER;
        lv_codigo_apu_articulo VARCHAR2(50);
        lv_apu_api             VARCHAR2(50);
        lv_codigo_articulo_naf VARCHAR2(50);
        lv_codigo_cia_naf      VARCHAR2(50);
        lv_es_variable         VARCHAR2(50);
        ln_cantidad_default    NUMBER;
        lv_es_principal        VARCHAR2(50);
        --------------------
        le_error EXCEPTION;
    BEGIN
        apex_json.parse(pd_request);
        lv_code := apex_json.get_varchar2(p_path => 'code');
        lv_name := apex_json.get_varchar2(p_path => 'name');
        lv_description := apex_json.get_varchar2(p_path => 'description');
        lv_brand := apex_json.get_varchar2(p_path => 'brand');
        ln_departmentid := apex_json.get_varchar2(p_path => 'departmentId');
        lv_companycode := apex_json.get_varchar2(p_path => 'companyCode');
        lv_registeruser := apex_json.get_varchar2(p_path => 'registerUser');
        ln_products_count := apex_json.get_count(p_path => 'products');
        ln_items_count := apex_json.get_count(p_path => 'items');
        lv_fecha_creacion := apex_json.get_varchar2(p_path => 'fecha_creacion');
        ln_id_apu := naf47_tnet.seq_admi_apu.nextval;
        
        
        IF ln_products_count IS NULL THEN
            ln_products_count := 0;
        END IF;
        IF ln_items_count IS NULL THEN
            ln_items_count := 0;
        END IF;
        IF lv_description IS NULL THEN
            lv_description := 'Sin descripción';
        END IF;
        IF lv_brand IS NULL THEN
            pv_mensaje := 'Marca no definida ' || lv_brand;
            RAISE le_error;
        END IF;

        IF lv_companycode IS NULL THEN
            pv_mensaje := 'Codigo empresa no definido ' || lv_companycode;
            RAISE le_error;
        END IF;

        IF ln_departmentid IS NULL THEN
            pv_mensaje := 'Departamento no definido ' || lv_code;
            RAISE le_error;
        END IF;

        IF lv_registeruser IS NULL THEN
            pv_mensaje := 'Usuario no definido ' || lv_registeruser;
            RAISE le_error;
        END IF;

        IF lv_code IS NULL THEN
            pv_mensaje := 'Codigo no definido ' || lv_code;
            RAISE le_error;
        END IF;

        SELECT
            sysdate
        INTO lv_fecha_creacion
        FROM
            dual;

        INSERT INTO naf47_tnet.admi_apu (
            id_apu,
            codigo_apu,
            nombre_apu,
            descripcion_apu,
            marca,
            empresa_cod,
            departamento_id,
            estado,
            usr_creacion,
            fe_creacion,
            usr_ult_mod,
            fe_ult_mod
        ) VALUES (
            ln_id_apu,
            lv_code,
            lv_name,
            lv_description,
            lv_brand,
            lv_companycode,
            ln_departmentid,
            'Activo',
            lv_registeruser,
            lv_fecha_creacion,
            lv_registeruser,
            lv_fecha_creacion
        );

        COMMIT;
        ln_iteradori := 1;
        
        WHILE ( ln_iteradori <= ln_products_count ) LOOP
            ln_producto_id := apex_json.get_varchar2(p_path => 'products[%d]', p0 => ln_iteradori);
            ln_iteradori := ln_iteradori + 1;
            INSERT INTO naf47_tnet.admi_apu_producto (
                apu_id,
                producto_id,
                estado,
                usuario_creacion,
                fecha_creacion,
                usuario_modificacion,
                fecha_modificacion
            ) VALUES (
                ln_id_apu,
                ln_producto_id,
                'Activo',
                lv_registeruser,
                sysdate,
                lv_registeruser,
                sysdate
            );

        END LOOP;

        ln_iteradori := 1;
        WHILE ( ln_iteradori <= ln_items_count ) LOOP
            lv_codigo_apu_articulo := lv_code;
            lv_codigo_articulo_naf := apex_json.get_varchar2(p_path => 'items[%d].codeNaf', p0 => ln_iteradori);
            lv_es_variable := apex_json.get_varchar2(p_path => 'items[%d].isVariable', p0 => ln_iteradori);
            ln_cantidad_default := apex_json.get_number(p_path => 'items[%d].amountDefault', p0 => ln_iteradori);
            lv_es_principal := apex_json.get_varchar2(p_path => 'items[%d].isMain', p0 => ln_iteradori);
            lv_codigo_cia_naf := apex_json.get_varchar2(p_path => 'items[%d].codeNaf', p0 => ln_iteradori);
            INSERT INTO naf47_tnet.admi_apu_articulo (
                id_apu_articulo,
                codigo_apu_articulo,
                apu_id,
                codigo_articulo_naf,
                empresa_cod,
                es_variable,
                cantidad_default,
                es_principal,
                estado,
                usuario_creacion,
                fecha_creacion,
                usuario_modificacion,
                fecha_modificacion
            ) VALUES (
                naf47_tnet.seq_admi_apu_articulo.nextval,
                lv_codigo_apu_articulo,
                ln_id_apu,
                lv_codigo_articulo_naf,
                lv_companycode,
                lv_es_variable,
                ln_cantidad_default,
                lv_es_principal,
                'Activo',
                lv_registeruser,
                sysdate,
                lv_registeruser,
                sysdate
            );

            ln_iteradori := ln_iteradori + 1;
        END LOOP;

        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        COMMIT;
        OPEN pd_response FOR SELECT
                                 apu.id_apu                 id,
                                 apu.nombre_apu             name,
                                 apu.codigo_apu             code,
                                 apu.descripcion_apu        description,
                                 depart.id_departamento     departmentid,
                                 depart.nombre_departamento departmentname,
                                 apu.marca                  brand
                             FROM
                                 naf47_tnet.admi_apu          apu,
                                 db_general.admi_departamento depart
                             WHERE
                                     apu.departamento_id = depart.id_departamento
                                 AND apu.id_apu = ln_id_apu;

    EXCEPTION
        WHEN le_error THEN
            pv_status := 'Error';
            dbms_output.put_line(sqlerrm);
            ROLLBACK;
        WHEN OTHERS THEN
            pv_status := 'Error';
            pv_mensaje := 'Error =>' || sqlerrm;
            dbms_output.put_line(sqlerrm);
            ROLLBACK;
    END;

    PROCEDURE p_crear_detalle_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT SYS_REFCURSOR
    ) AS
        
        
        
        --------------------
        ----------ITEMS
        ln_id_articulo         VARCHAR2(50);
        ln_id_apu              number;
        lv_codigo_apu_articulo VARCHAR2(50);
        lv_apu_api             VARCHAR2(50);
        lv_codigo_articulo_naf VARCHAR2(50);
        empresa_code           VARCHAR2(50);
        lv_es_variable         VARCHAR2(50);
        lv_cantidad_default    VARCHAR2(50);
        lv_es_principal        VARCHAR2(50);
        lv_registeruser        VARCHAR2(50);
        lv_fecha_creacion      VARCHAR2(100);
        le_error EXCEPTION;
        --------------------
        CURSOR c_cursor_apu (
            codigo_apu VARCHAR2
        ) IS
        SELECT
            apu.id_apu
        FROM
            naf47_tnet.admi_apu      apu
        WHERE
            apu.codigo_apu = codigo_apu;

    BEGIN
        apex_json.parse(pd_request);
        ln_id_articulo := naf47_tnet.seq_admi_apu_articulo.nextval;
        lv_fecha_creacion := apex_json.get_varchar2(p_path => 'fecha_creacion');
        lv_codigo_apu_articulo := apex_json.get_varchar2(p_path => 'code');
        lv_codigo_articulo_naf := apex_json.get_varchar2(p_path => 'codeNaf');
        lv_es_variable := apex_json.get_varchar2(p_path => 'isVariable');
        lv_cantidad_default := apex_json.get_varchar2(p_path => 'amountDefault');
        lv_es_principal := apex_json.get_varchar2(p_path => 'isMain');
        empresa_code := apex_json.get_varchar2(p_path => 'noCia');
        lv_registeruser := apex_json.get_varchar2(p_path => 'registerUser');
        
        
        IF c_cursor_apu%isopen THEN
            CLOSE c_cursor_apu;
        END IF;
        OPEN c_cursor_apu(lv_codigo_apu_articulo);
        FETCH c_cursor_apu INTO ln_id_apu;
        IF c_cursor_apu%notfound THEN
            ln_id_apu := 0;
        END IF;
        CLOSE c_cursor_apu;
        IF nvl(ln_id_apu, 0) = 0 THEN
            pv_status := '404';
            pv_mensaje := 'APU no encontrado con codigo(UIDD): ' || lv_codigo_apu_articulo;
            RAISE le_error;
        END IF;

        INSERT INTO naf47_tnet.admi_apu_articulo (
            id_apu_articulo,
            codigo_apu_articulo,
            apu_id,
            codigo_articulo_naf,
            empresa_cod,
            es_variable,
            cantidad_default,
            es_principal,
            estado,
            usuario_creacion,
            fecha_creacion,
            usuario_modificacion,
            fecha_modificacion
        ) VALUES (
            ln_id_articulo,
            lv_codigo_apu_articulo,
            ln_id_apu,
            lv_codigo_articulo_naf,
            empresa_code,
            lv_es_variable,
            TO_NUMBER(lv_cantidad_default,'9999.99'),
            lv_es_principal,
            'Activo',
            lv_registeruser,
            sysdate,
            lv_registeruser,
            sysdate
        );

        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        OPEN pd_response FOR SELECT
                                 apuart.id_apu_articulo     id,
                                 apuart.codigo_apu_articulo code,
                                 apuart.es_principal        ismain,
                                 apuart.es_variable         isvariable,
                                 apuart.cantidad_default    amountdefault,
                                 apuart.codigo_articulo_naf codenaf,
                                 apu.descripcion_apu        description,
                                 apu.marca                  brand,
                                 arincat.descripcion        category,
                                 arinda.tipo_articulo       itemtype,
                                 arinda.costo_unitario      cost,
                                 arinda.unidad              unit,
                                 apuart.estado              status
                             FROM
                                 naf47_tnet.admi_apu_articulo apuart,
                                 naf47_tnet.admi_apu          apu,
                                 naf47_tnet.arinda            arinda,
                                 naf47_tnet.arincat           arincat
                             WHERE
                                     apu.id_apu = apuart.apu_id
                                 AND apuart.codigo_articulo_naf = arinda.no_arti
                                 AND arincat.no_cia = arinda.no_cia
                                 AND arincat.clase = arinda.clase
                                 AND apuart.estado = 'Activo'
                                 AND apuart.id_apu_articulo = ln_id_articulo;

        COMMIT;
    EXCEPTION
        WHEN le_error THEN
            pv_status := '404';
            pv_mensaje := 'APU no encontrado con codigo(UIDD): ' || lv_codigo_apu_articulo;
            --dbms_output.put_line('APU no entonctrado con codigo(UIDD): ' || lv_codigo_apu_articulo);
            ROLLBACK;
        WHEN OTHERS THEN
            pv_status := 'Error';
            pv_mensaje := 'Error =>' || sqlerrm;
            --dbms_output.put_line(sqlerrm);
            ROLLBACK;
    END;

    PROCEDURE p_actualizar_detalle_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT SYS_REFCURSOR
    ) AS
        
        
        
        --------------------
        ----------ITEMS
        lv_id_articulo         VARCHAR2(200);
        ln_id_apu              NUMBER;
        lv_codigo_apu_articulo VARCHAR2(50);
        lv_apu_api             VARCHAR2(50);
        lv_codigo_articulo_naf VARCHAR2(50);
        empresa_code           VARCHAR2(50);
        lv_es_variable         VARCHAR2(50);
        ln_cantidad_default    VARCHAR2(50);
        lv_es_principal        VARCHAR2(50);
        lv_registeruser        VARCHAR2(50);
        lv_fecha_creacion      VARCHAR2(20);
        lv_item_status         VARCHAR2(40);
        le_error EXCEPTION;
        --------------------
        CURSOR c_cursor_apu (
            codigo_apu VARCHAR2
        ) IS
        SELECT
            apu.id_apu
        FROM
            db_comercial.info_oficina_grupo iog,
            naf47_tnet.admi_apu             apu
        WHERE
            apu.codigo_apu = lv_codigo_apu_articulo;

    BEGIN
        apex_json.parse(pd_request);
        lv_id_articulo := apex_json.get_varchar2(p_path => 'id_apu_articulo');
        lv_codigo_apu_articulo := apex_json.get_varchar2(p_path => 'code');
        lv_fecha_creacion := apex_json.get_varchar2(p_path => 'fecha_creacion');
        lv_codigo_articulo_naf := apex_json.get_varchar2(p_path => 'codeNaf');
        lv_es_variable := apex_json.get_varchar2(p_path => 'isVariable');
        ln_cantidad_default := apex_json.get_varchar2(p_path => 'amountDefault');
        lv_es_principal := apex_json.get_varchar2(p_path => 'isMain');
        empresa_code := apex_json.get_varchar2(p_path => 'noCia');
        lv_registeruser := apex_json.get_varchar2(p_path => 'registerUser');
        lv_item_status := apex_json.get_varchar2(p_path => 'status');
        dbms_output.put_line('INDICE lv_id_articulo:'||lv_id_articulo);
        IF c_cursor_apu%isopen THEN
            CLOSE c_cursor_apu;
        END IF;
        OPEN c_cursor_apu(lv_codigo_apu_articulo);
        FETCH c_cursor_apu INTO ln_id_apu;
        IF c_cursor_apu%notfound THEN
            ln_id_apu := 0;
        END IF;
        CLOSE c_cursor_apu;
        IF nvl(ln_id_apu, 0) = 0 THEN
            pv_status := '404';
            pv_mensaje := 'APU no encontrado con codigo(UIDD): ' || lv_codigo_apu_articulo;
            RAISE le_error;
        END IF;
        
        
        UPDATE naf47_tnet.admi_apu_articulo
        SET
            --id_apu_articulo = lv_id_articulo,
            codigo_apu_articulo = lv_codigo_apu_articulo,
            apu_id = ln_id_apu,
            codigo_articulo_naf = lv_codigo_articulo_naf,
            empresa_cod = empresa_code,
            es_variable = lv_es_variable,
            cantidad_default = TO_NUMBER(ln_cantidad_default, '9999.99'),
            es_principal = lv_es_principal,
            usuario_modificacion = lv_registeruser,
            fecha_modificacion = sysdate,
            estado = lv_item_status
        WHERE
            apu_id = ln_id_apu
            AND codigo_articulo_naf = lv_codigo_articulo_naf;
        COMMIT;
        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        OPEN pd_response FOR SELECT
                                 apuart.id_apu_articulo     id,
                                 apuart.codigo_apu_articulo code,
                                 apuart.es_principal        ismain,
                                 apuart.es_variable         isvariable,
                                 apuart.cantidad_default    amountdefault,
                                 apuart.codigo_articulo_naf codenaf,
                                 apu.descripcion_apu        description,
                                 apu.marca                  brand,
                                 arincat.descripcion        category,
                                 arinda.tipo_articulo       itemtype,
                                 arinda.costo_unitario      cost,
                                 arinda.unidad              unit,
                                 apuart.estado              status
                             FROM
                                 naf47_tnet.admi_apu_articulo apuart,
                                 naf47_tnet.admi_apu          apu,
                                 naf47_tnet.arinda            arinda,
                                 naf47_tnet.arincat           arincat
                             WHERE
                                     apu.id_apu = apuart.apu_id
                                 AND apuart.codigo_articulo_naf = arinda.no_arti
                                 AND arincat.no_cia = arinda.no_cia
                                 AND arincat.clase = arinda.clase
                                 AND apuart.estado = 'Activo'
                                 AND apuart.id_apu_articulo = lv_id_articulo;

        
    EXCEPTION
        WHEN le_error THEN
            pv_status := '404';
            pv_mensaje := 'APU no encontrado con codigo(UIDD): ' || lv_codigo_apu_articulo;
            ROLLBACK;
        WHEN OTHERS THEN
            pv_status := 'Error';
            pv_mensaje := 'Error =>' || sqlerrm;
            dbms_output.put_line(sqlerrm);
            ROLLBACK;
    END;

    PROCEDURE P_ACTUALIZAR_APU(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out SYS_REFCURSOR
                     )
    AS
        -----------ADMI_APU------------
        
        lv_code  VARCHAR2(50);
        lv_name  VARCHAR2(50);
        lv_description  VARCHAR2(100);
        lv_brand  VARCHAR2(50);
        ln_departmentId  number;
        lv_companyCode  VARCHAR2(50);
        lv_registerUser  VARCHAR2(50);   
        lv_fecha_modificacion VARCHAR2(50);
        lv_id_apu VARCHAR2(100);
        le_error EXCEPTION;
        -------------------------------
        
         
        ln_IteradorI NUMBER;
        --------- producs
        ln_products_count number;
        ln_producto_id number;
        ln_check_product number;
        
        --------------------
        ----------ITEMS
        ln_items_count number;
        ln_id_apu_articulo number;
        lv_codigo_apu_articulo VARCHAR2(50);
        lv_apu_api VARCHAR2(50);
        lv_codigo_articulo_naf VARCHAR2(50);
        lv_item_status VARCHAR2(50);
        lv_codigo_cia_naf VARCHAR2(50);
        lv_es_variable VARCHAR2(50);
        ln_cantidad_default number;
        lv_es_principal VARCHAR2(50);
        ln_check_items number := 1;
        --------------------
        lv_regjson              CLOB;
        
        
        lv_query_inactive VARCHAR2(300);
        where_clause VARCHAR2(300);
        
        CURSOR C_APUS(id_code VARCHAR2) 
            is SELECT apu.id_apu 
        FROM NAF47_TNET.admi_apu apu where apu.codigo_apu = id_code;        
        
        CURSOR VALIDATE_PRODUCT(ln_id number,ln_id_apu VARCHAR2)
            IS SELECT prod.producto_id producto_id
        FROM NAF47_TNET.ADMI_APU_PRODUCTO prod 
        where prod.producto_id  = ln_id
        AND   prod.apu_id = ln_id_apu;
        
        CURSOR VALIDATE_ITEMS(lv_code VARCHAR2,ln_id_apu VARCHAR2)
            IS SELECT COUNT(*) 
                FROM NAF47_TNET.admi_apu_articulo art
                WHERE art.apu_id =  ln_id_apu
            AND   art.codigo_articulo_naf = lv_code;
      
      
        
    BEGIN
        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transaccion exitosa';
        -- INICIALIZACION DE VARIABLE SCON DATOS DE LA PETICION
        
        APEX_JSON.PARSE(Pd_request);
        lv_code  := APEX_JSON.get_varchar2(p_path => 'code');
        lv_name  := APEX_JSON.get_varchar2(p_path => 'name');
        lv_description  := APEX_JSON.get_varchar2(p_path => 'description');
        lv_brand  := APEX_JSON.get_varchar2(p_path => 'brand');
        ln_departmentId  := APEX_JSON.get_varchar2(p_path => 'departmentId');
        lv_companyCode  := APEX_JSON.get_varchar2(p_path => 'companyCode'); 
        lv_registerUser  := APEX_JSON.get_varchar2(p_path => 'registerUser'); 
        ln_products_count  := APEX_JSON.get_count(p_path => 'products');
        ln_items_count := APEX_JSON.get_count(p_path => 'items');
        

        
        SELECT
            sysdate
        INTO lv_fecha_modificacion
        FROM
            dual;
            
        -- VALIDACION DE CAMPOS REQUERIDOS 

        IF lv_code  IS NULL THEN
          Pv_Mensaje := 'Codigo no definido '||lv_code;
          RAISE le_error; 
        END IF;
        
        
        
        IF ln_products_count IS NULL THEN
          ln_products_count:=0;
        END IF;
        
        
        
        IF ln_items_count IS NULL THEN
          ln_items_count:=0;
        END IF;
    
        
    
        IF lv_description IS NULL THEN
           lv_description  := 'Sin descripción';
        END IF;
        
        
        
        IF lv_brand IS NULL THEN
           Pv_Mensaje := 'Marca no definida '||lv_code;
           RAISE le_error; 
        END IF;
        
        
        IF lv_companyCode IS NULL THEN
           Pv_Mensaje := 'Codigo empresa no definido '||lv_companyCode;
           RAISE le_error; 
        END IF;
        
        
        
        IF ln_departmentId IS NULL THEN
           Pv_Status     := '404';
           Pv_Mensaje := 'Departamento no definido '||lv_code;
           RAISE le_error; 
        END IF;
        
        
        
        IF lv_registerUser IS NULL THEN
           Pv_Status     := '404';
           Pv_Mensaje := 'Usuario no definido '||lv_registerUser;
           RAISE le_error; 
        END IF;
        
        
        IF lv_fecha_modificacion IS NULL THEN
           Pv_Mensaje := 'Fecha no definida '||lv_fecha_modificacion;
           RAISE le_error; 
        END IF;

        IF C_APUS%ISOPEN THEN
            CLOSE C_APUS;
        END IF;
        OPEN C_APUS(lv_code);
        FETCH C_APUS INTO lv_id_apu;
        IF C_APUS%NOTFOUND THEN
          lv_id_apu := '0';
        END IF;
        CLOSE C_APUS;
        
        IF NVL(lv_id_apu,0) = 0 THEN
          Pv_Status  := '404';
          Pv_Mensaje := 'ID NO ENCONTRADO';
          RAISE le_error; 
        END IF;
        
        --ACTUALIZO EL APU
        
        UPDATE  NAF47_TNET.ADMI_APU SET
        
            NOMBRE_APU      =lv_name,
            DESCRIPCION_APU =lv_description,
            MARCA           =lv_brand,
            EMPRESA_COD     =lv_companyCode,
            DEPARTAMENTO_ID =ln_departmentId,
            ESTADO          ='Activo',
            USR_ULT_MOD     =lv_registerUser,
            FE_ULT_MOD      =SYSDATE

            WHERE CODIGO_APU = lv_code;
        COMMIT;
        
        
        --
        --ARMO EL QUERY PARA CONCILIAR LOS PRODUCTOS DEL APU
        lv_query_inactive := 'UPDATE NAF47_TNET.admi_apu_producto prod'
                                                     ||' set prod.estado = '
                                                     ||'''Inactivo'''
                                                     ||' WHERE prod.apu_id = '||lv_id_apu;
                                                     
        where_clause := ' and prod.producto_id NOT IN (';
        Ln_IteradorI := 1;

         WHILE (ln_IteradorI <= ln_products_count)
         LOOP
                APEX_JSON.PARSE(Pd_request);
                ln_producto_id := APEX_JSON.get_varchar2(p_path => 'products[%d]', p0 => Ln_IteradorI);


                IF VALIDATE_PRODUCT%ISOPEN THEN
                    CLOSE VALIDATE_PRODUCT;
                END IF;
                OPEN VALIDATE_PRODUCT(ln_producto_id,lv_id_apu);
                FETCH VALIDATE_PRODUCT INTO ln_check_product;
                
                IF VALIDATE_PRODUCT%NOTFOUND THEN
                  ln_check_product := 0;
                END IF;

                IF ln_check_product = 0 THEN
                    dbms_output.put_line('produc insert:'||ln_producto_id);
                    INSERT INTO naf47_tnet.admi_apu_producto 
                    (
                     apu_id,producto_id,
                     estado,usuario_creacion,
                     fecha_creacion,usuario_modificacion,
                     fecha_modificacion
                    )    
                    VALUES ( lv_id_apu,ln_producto_id,
                            'Activo',lv_registeruser,
                            sysdate,lv_registeruser,
                            sysdate );
                ELSE 
                    dbms_output.put_line('produc update:'||ln_producto_id);
                    UPDATE naf47_tnet.admi_apu_producto prod
                    SET prod.estado        = 'Activo',
                        usuario_modificacion = lv_registeruser,
                        fecha_modificacion =  sysdate
                    WHERE prod.producto_id = ln_producto_id and prod.apu_id = lv_id_apu; 
                    
                END IF;
                
            where_clause := where_clause||ln_producto_id;
            IF Ln_IteradorI < ln_products_count THEN
                where_clause := where_clause||',';
            ELSE 
                where_clause := where_clause||')';
            END IF;
            Ln_IteradorI := Ln_IteradorI+1;
            
            
        END LOOP;
        COMMIT;
        --EJECUTO EL QUERY ARMADO PARA INACTIVAR TODOS LOS PRODUCTOS QUE NO LLEGARON EN EL REQUEST 
        lv_query_inactive := lv_query_inactive || where_clause;
        IF ln_products_count > 0 THEN
             EXECUTE IMMEDIATE lv_query_inactive;
        END IF;
        
                     
        -- RECORRO LOS ARTICULOS DEL APU
         ln_IteradorI := 1;
         WHILE (ln_IteradorI <= ln_items_count)
         LOOP
              APEX_JSON.PARSE(Pd_request);
              lv_codigo_apu_articulo := APEX_JSON.get_varchar2(p_path => 'items[%d].code', p0 => ln_IteradorI);
              lv_es_variable := APEX_JSON.get_varchar2(p_path => 'items[%d].isVariable', p0 => ln_IteradorI);
              ln_cantidad_default := APEX_JSON.get_number(p_path => 'items[%d].amountDefault', p0 => ln_IteradorI);
              lv_es_principal := APEX_JSON.get_varchar2(p_path => 'items[%d].isMain', p0 => ln_IteradorI);
              lv_codigo_cia_naf := lv_companyCode;
              lv_codigo_articulo_naf := APEX_JSON.get_varchar2(p_path => 'items[%d].codeNaf', p0 => ln_IteradorI);                 
              lv_item_status := APEX_JSON.get_varchar2(p_path => 'items[%d].status', p0 => ln_IteradorI);
                IF VALIDATE_ITEMS%ISOPEN THEN
                    CLOSE VALIDATE_ITEMS;
                END IF;
                OPEN VALIDATE_ITEMS(lv_codigo_articulo_naf,lv_id_apu);
                FETCH VALIDATE_ITEMS INTO ln_check_items;
                
                IF VALIDATE_ITEMS%NOTFOUND THEN
                  ln_check_items := 0;
                END IF;
                
              CLOSE VALIDATE_ITEMS;
              
              lv_regjson := '{'
                          || '"id_apu_articulo":"'
                          || lv_id_apu
                          || '",'
                          || '"fecha_creacion":"'
                          || SYSDATE
                          || '",'
                          || '"code":"'
                          || lv_codigo_apu_articulo
                          || '",'
                          || '"codeNaf":"'
                          || lv_codigo_articulo_naf
                          || '",'
                          || '"isVariable":"'
                          || lv_es_variable
                          || '",'
                          || '"amountDefault":"'
                          || ln_cantidad_default
                          || '",'
                          || '"isMain":"'
                          || lv_es_principal
                          || '",'
                          || '"registerUser":"'
                          || lv_registerUser
                          || '",'
                          || '"status":"'
                          || lv_item_status
                          || '",'
                          || '"noCia":"'
                          || lv_companyCode
                          || '"'
              || '}';
              
                          
              -- SI NO EXISTE LO CREO.
              IF ln_check_items = 0 THEN
                    INKG_GESTION_APUS.P_CREAR_DETALLE_APU(
                        PD_REQUEST => lv_regjson,
                        PV_STATUS => PV_STATUS,
                        PV_MENSAJE => PV_MENSAJE,
                        PD_RESPONSE => PD_RESPONSE
                    );
             -- SI EXISTE LO ACTUALIZO
              ELSE
                    INKG_GESTION_APUS.P_ACTUALIZAR_DETALLE_APU(
                        PD_REQUEST => lv_regjson,
                        PV_STATUS => PV_STATUS,
                        PV_MENSAJE => PV_MENSAJE,
                        PD_RESPONSE => PD_RESPONSE
                    );
              END IF;
              
              
              ln_IteradorI := ln_IteradorI+1;
              
        
        END LOOP;
        
        
        EXCEPTION
            WHEN le_error THEN
                pv_status := 'Error';
                dbms_output.put_line(sqlerrm);
                ROLLBACK;
            WHEN OTHERS THEN
                pv_status := 'Error';
                pv_mensaje := 'Error =>' || sqlerrm;
                dbms_output.put_line(sqlerrm);
                ROLLBACK;

end;

    PROCEDURE p_cancelar_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT SYS_REFCURSOR
    ) AS
        -----------ADMI_APU------------
        ln_code_apu VARCHAR2(50);
        -------------------------------

    BEGIN
        apex_json.parse(pd_request);
        ln_code_apu := apex_json.get_varchar2(p_path => 'code');
        UPDATE naf47_tnet.admi_apu apu
        SET
            apu.estado = 'Cancelado',
            apu.fe_ult_mod = sysdate
        WHERE
            apu.codigo_apu = ln_code_apu;

        UPDATE naf47_tnet.admi_apu_articulo apu_art
        SET
            apu_art.estado = 'Cancelado',
            apu_art.fecha_modificacion = sysdate
        WHERE
            apu_art.codigo_apu_articulo = ln_code_apu
            and apu_art.estado = 'Activo';

        COMMIT;
        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        OPEN pd_response FOR SELECT
                                 apu.codigo_apu             code,
                                 apu.nombre_apu             name,
                                 apu.descripcion_apu        description,
                                 apu.marca                  brand,
                                 depart.id_departamento     departmentid,
                                 depart.nombre_departamento departmentname
                             FROM
                                 naf47_tnet.admi_apu          apu,
                                 db_general.admi_departamento depart
                             WHERE
                                     apu.departamento_id = depart.id_departamento
                                 AND apu.codigo_apu = ln_code_apu;

    EXCEPTION
        WHEN OTHERS THEN
            pv_status := 'Error';
            pv_mensaje := 'Error =>' || sqlerrm;
            dbms_output.put_line(sqlerrm);
            ROLLBACK;
    END;

    PROCEDURE p_cancelar_detalle_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT SYS_REFCURSOR
    ) AS
        -----------ADMI_APU------------
        ln_id_apu_articulo NUMBER;
        ln_code_naf     VARCHAR2(20);
        -------------------------------

    BEGIN
        apex_json.parse(pd_request);
        ln_id_apu_articulo := apex_json.get_number(p_path => 'apu_id');
        ln_code_naf := apex_json.get_number(p_path => 'code');
        UPDATE naf47_tnet.admi_apu_articulo naf
        SET
            naf.estado = 'Cancelado',
            naf.fecha_modificacion = sysdate
        WHERE
            naf.codigo_articulo_naf = ln_code_naf
            AND naf.apu_id = ln_id_apu_articulo;

        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            pv_status := 'Error';
            pv_mensaje := 'Error =>' || sqlerrm;
            dbms_output.put_line(sqlerrm);
            ROLLBACK;
    END;

    PROCEDURE p_obtener_datos_productos_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT CLOB
    ) AS
           
        
        
    
        /*
        DB_COMERCIAL.CMKG_GESTION_PRODUCTOS.P_CONSULTAR_PRODUCTO_POR(
            PD_REQUEST => Pd_request,
            PV_STATUS => Pv_status,
            PV_MENSAJE => Pv_mensaje,
            PD_RESPONSE => Pd_response
        );*/

        lv_jason         CLOB := NULL;
        ln_linea         NUMBER;
        ln_breakpoint    NUMBER := 0;
        lv_jasonaux      CLOB := NULL;
        lv_regjson       VARCHAR2(1000) := NULL;
        ln_id_apu        NUMBER;
        lv_check_product VARCHAR2(10) := 'FILTRO';
        lv_cod           VARCHAR2(40);
        CURSOR c_product_list (
            ln_id_apu NUMBER
        ) IS
        SELECT
            admprod.id_producto,
            admprod.descripcion_producto
        FROM
            db_comercial.admi_producto   admprod,
            naf47_tnet.admi_apu_producto apu
        WHERE
                admprod.id_producto = apu.producto_id
            AND apu.apu_id = ln_id_apu;

        CURSOR c_product_list_all IS
        SELECT
            admprod.id_producto,
            admprod.descripcion_producto
        FROM
            db_comercial.admi_producto admprod;

        CURSOR c_apus (
            id_code VARCHAR2
        ) IS
        SELECT
            apu.id_apu
        FROM
            naf47_tnet.admi_apu apu
        WHERE
            apu.codigo_apu = id_code;

        le_error EXCEPTION;
    BEGIN
        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        apex_json.parse(pd_request);
        lv_cod := apex_json.get_varchar2(p_path => 'code');
        IF lv_cod IS NULL THEN
            lv_check_product := 'ALL';
        END IF;
        IF c_apus%isopen THEN
            CLOSE c_apus;
        END IF;
        OPEN c_apus(lv_cod);
        FETCH c_apus INTO ln_id_apu;
        IF c_apus%notfound THEN
            ln_id_apu := 0;
        END IF;
        CLOSE c_apus;
        IF
            nvl(ln_id_apu, 0) = 0
            AND lv_check_product = 'FILTRO'
        THEN
            pv_status := '404';
            pv_mensaje := 'ID NO ENCONTRADO';
            RAISE le_error;
        END IF;

        ln_linea := 0;
        lv_jason := '[';
        IF lv_check_product = 'ALL' THEN
            FOR lr_datos IN c_product_list_all LOOP
                IF ln_linea > 0 THEN
                    lv_jasonaux := lv_jasonaux || ',';
                END IF;
                            
                          --
                lv_regjson := '{'
                              || '"'
                              || lr_datos.id_producto
                              || '":"'
                              || lr_datos.descripcion_producto
                              || '"'
                              || '}';
                          --

                lv_jason := lv_jason || lv_jasonaux;
                lv_jasonaux := lv_regjson;
                ln_linea := ln_linea + 1;
            END LOOP;
        ELSE
            FOR lr_datos IN c_product_list(ln_id_apu) LOOP
                IF ln_linea > 0 THEN
                    lv_jasonaux := lv_jasonaux || ',';
                END IF;
                            
                          --
                lv_regjson := '{'
                              || '"'
                              || lr_datos.id_producto
                              || '":"'
                              || lr_datos.descripcion_producto
                              || '"'
                              || '}';
                          --

                lv_jason := lv_jason || lv_jasonaux;
                lv_jasonaux := lv_regjson;
                ln_linea := ln_linea + 1;
            END LOOP;
        END IF;

        lv_jason := lv_jason || lv_jasonaux;
        IF ln_linea = 0 THEN
            pv_status := '404';
            pv_mensaje := 'No se encontraron Articulos ';
        END IF;
        lv_jason := lv_jason || ']';
        pd_response := lv_jason;
        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
    END;

    PROCEDURE p_obtener_listado_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT CLOB
    ) AS

        lv_jason          CLOB := NULL;
        ln_linea          NUMBER;
        ln_breakpoint     NUMBER := 0;
        lv_jasonaux       CLOB := NULL;
        lv_regjson        CLOB := NULL;
        lv_cod            VARCHAR2(50);
        lv_brand          VARCHAR2(50);
        ln_departmentid   NUMBER;
        lv_name           VARCHAR2(100);
        ln_checkbrand     NUMBER := 0;
        ln_checkcode      NUMBER := 0;
        ln_checkdepart    NUMBER := 0;
        ln_checkname      NUMBER := 0;
        lv_request_items  CLOB;
        responseitems     CLOB;
        responseproductos CLOB;
        CURSOR c_apus_list (
            in_marca        VARCHAR2,
            in_departmentid NUMBER,
            in_code         VARCHAR2,
            in_name         VARCHAR2
        ) IS
        SELECT
            apu.codigo_apu             code,
            apu.nombre_apu             nombre_apu,
            apu.descripcion_apu        description,
            apu.empresa_cod            companyCode,
            depart.id_departamento     departmentid,
            depart.nombre_departamento departmentname,
            apu.marca                  brand
        FROM
            naf47_tnet.admi_apu          apu,
            db_general.admi_departamento depart
        WHERE
                apu.estado = 'Activo'
            AND ( apu.codigo_apu = in_code
                  OR 1 = ln_checkcode )
                AND ( apu.nombre_apu = in_name 
                      OR 1 = ln_checkname )
                    AND ( apu.marca = in_marca
                          OR 1 = ln_checkbrand )
                        AND ( depart.id_departamento = in_departmentid
                              OR 1 = ln_checkdepart )
                            AND apu.departamento_id = depart.id_departamento;

    BEGIN
        apex_json.parse(pd_request);
        lv_cod := apex_json.get_varchar2(p_path => 'code');
        lv_brand := apex_json.get_varchar2(p_path => 'brand');
        ln_departmentid := apex_json.get_varchar2(p_path => 'departmentId');
        lv_name := apex_json.get_varchar2(p_path => 'name');
        IF lv_cod IS NULL THEN
            ln_checkcode := 1;
        END IF;
        IF ln_departmentid IS NULL THEN
            ln_checkdepart := 1;
        END IF;
        IF lv_brand IS NULL THEN
            ln_checkbrand := 1;
        END IF;
        IF lv_name IS NULL THEN
            ln_checkname := 1;
        END IF;
        ln_linea := 0;
        lv_jason := lv_jason || '[';
        FOR lr_datos IN c_apus_list(lv_brand, ln_departmentid, lv_cod, lv_name) LOOP
            lv_request_items := '{'
                                || '"code":"'
                                || lr_datos.code
                                || '"'
                                || '}';

            IF ln_linea > 0 THEN
                lv_jasonaux := lv_jasonaux || ',';
            END IF;
            inkg_gestion_apus.p_obtener_datos_detalle_apu(pd_request => lv_request_items, pv_status => pv_status, pv_mensaje => pv_mensaje,
            pd_response => responseitems);

            inkg_gestion_apus.p_obtener_datos_productos_apu(pd_request => lv_request_items, pv_status => pv_status, pv_mensaje => pv_mensaje,
            pd_response => responseproductos);

      --
            lv_regjson := '{'
                          || '"code":"'
                          || lr_datos.code
                          || '",'
                          || '"name":"'
                          || REGEXP_REPLACE(lr_datos.nombre_apu, '[^0-9A-Za-z]', ' ')
                          || '",'
                          
                          || '"description":"'
                          || REGEXP_REPLACE(lr_datos.description, '[^0-9A-Za-z]', ' ')
                          || '",'
                          || '"companyCode":"'
                          || lr_datos.companyCode
                          || '",'    
                          || '"brand":"'
                          || lr_datos.brand
                          || '",'
                          || '"departmentId":"'
                          || lr_datos.departmentid
                          || '",'
                          || '"products":'
                          || responseproductos
                          || ','
                          || '"items":'
                          || responseitems
                          || ','
                          || '"departmentName":"'
                          || lr_datos.departmentname
                          || '"'
                          || '}';
      --

            lv_jasonaux := lv_jasonaux || lv_regjson;
            ln_linea := ln_linea + 1;

      

      --
      --
        END LOOP;

        lv_jason := lv_jason || lv_jasonaux;
        lv_jasonaux := lv_regjson;
   
    --
        IF ln_linea = 0 THEN
            pv_status := '404';
            pv_mensaje := 'No se encontraron Grupos ';
        END IF;
        lv_jason := lv_jason || ']';
        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        pd_response := lv_jason;
    END;

    PROCEDURE p_obtener_datos_detalle_apu (
        pd_request  IN CLOB,
        pv_status   OUT VARCHAR2,
        pv_mensaje  OUT VARCHAR2,
        pd_response OUT CLOB
    ) AS

        lv_jason      CLOB := NULL;
        ln_linea      NUMBER;
        ln_breakpoint NUMBER := 0;
        lv_jasonaux   VARCHAR2(32767) := NULL;
        lv_regjson    VARCHAR2(1000) := NULL;
        lv_cod        VARCHAR2(40);
        le_error EXCEPTION;
        CURSOR c_resource_list (
            in_code VARCHAR2
        ) IS
        SELECT DISTINCT
            apuart.id_apu_articulo     id,
            apuart.codigo_apu_articulo code,
            apuart.es_principal        ismain,
            apuart.es_variable         isvariable,
            apuart.cantidad_default    amountdefault,
            ma.modelo                  modelo,
            apuart.codigo_articulo_naf codenaf,
            ma.desc_articulo           description,
            arinda.marca                  brand,
            arincat.descripcion        category,
            arinda.tipo_articulo       itemtype,
            arinda.costo_unitario      cost,
            arinda.unidad              unit,
            apuart.estado              status
        FROM
            naf47_tnet.admi_apu_articulo           apuart,
            naf47_tnet.admi_apu                    apu,
            naf47_tnet.arinda                      arinda,
            naf47_tnet.arincat                     arincat,
            naf47_tnet.v_articulos_caracteristicas ma
        WHERE
                apu.id_apu = apuart.apu_id
            AND ma.no_arti = arinda.no_arti
                AND apuart.codigo_articulo_naf = arinda.no_arti
                  AND apuart.empresa_cod = arinda.no_cia
                    AND arincat.no_cia = arinda.no_cia
                        AND arincat.clase = arinda.clase
                            AND apuart.estado = 'Activo'
                                AND apuart.codigo_apu_articulo = in_code;

    BEGIN
        apex_json.parse(pd_request);
        lv_cod := apex_json.get_varchar2(p_path => 'code');
        ln_linea := 0;
        lv_jason := '[';
        FOR lr_datos IN c_resource_list(lv_cod) LOOP
            IF ln_linea > 0 THEN
                lv_jasonaux := lv_jasonaux || ',';
            END IF;
                        

      --
            lv_regjson := '{'
                          || '"id":"'
                          || lr_datos.id
                          || '",'
                          || '"code":"'
                          || lr_datos.code
                          || '",'
                          || '"isMain":"'
                          || lr_datos.ismain
                          || '",'
                          || '"isVariable":"'
                          || lr_datos.isvariable
                          || '",'
                          || '"amountDefault":"'
                          || lr_datos.amountdefault
                          || '",'
                          || '"model":"'
                          || REGEXP_REPLACE(lr_datos.modelo, '[^0-9A-Za-z]', ' ')
                          || '",'
                          || '"codeNaf":"'
                          || lr_datos.codenaf
                          || '",'
                          || '"description":"'
                          || REGEXP_REPLACE(lr_datos.description, '[^0-9A-Za-z]', ' ')
                          || '",'
                          || '"brand":"'
                          || TRANSLATE(lr_datos.brand, '!@#$%^&*()', '          ')
                          || '",'
                          || '"category":"'
                        || TRANSLATE(lr_datos.category, '!@#$%^&*()', '          ')
                          || '",'
                          || '"itemType":"'
                          || lr_datos.itemtype
                          || '",'
                          || '"cost":"'
                          || lr_datos.cost
                          || '",'
                          || '"unit":"'
                          || lr_datos.unit
                          || '",'
                          || '"status":"'
                          || lr_datos.status
                          || '"'
                          || '}';
      --

            lv_jasonaux := lv_jasonaux || lv_regjson;
            ln_linea := ln_linea + 1;
        END LOOP;

        lv_jason := lv_jason || lv_jasonaux;
        lv_jasonaux := lv_regjson;
        IF ln_linea = 0 THEN
            pv_status := '404';
            pv_mensaje := 'No se encontraron Articulos ';
        END IF;
        lv_jason := lv_jason || ']';
        pd_response := lv_jason;
        pv_status := 'OK';
        pv_mensaje := 'Transaccion exitosa';
        end;
END inkg_gestion_apus;
/
