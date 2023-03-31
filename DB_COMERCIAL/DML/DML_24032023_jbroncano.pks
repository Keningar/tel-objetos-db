DECLARE
CURSOR c_reubicacionHomeCAB(Cv_descripcionPlan VARCHAR2) IS
SELECT ID_PLAN, CODIGO_PLAN, NOMBRE_PLAN, DESCRIPCION_PLAN, DESCUENTO_PLAN,
        ESTADO, IP_CREACION, IVA, ID_SIT, TIPO, PLAN_ID, CODIGO_INTERNO
FROM DB_COMERCIAL.info_plan_cab 
WHERE DESCRIPCION_PLAN = Cv_descripcionPlan;

CURSOR c_traslado(Cv_descripcionPlan VARCHAR2) IS
SELECT ID_PLAN, CODIGO_PLAN, NOMBRE_PLAN, DESCRIPCION_PLAN, DESCUENTO_PLAN,
        ESTADO, IP_CREACION, IVA, ID_SIT, TIPO, PLAN_ID, CODIGO_INTERNO
FROM DB_COMERCIAL.info_plan_cab 
WHERE DESCRIPCION_PLAN = Cv_descripcionPlan
AND ESTADO = 'Activo';

CURSOR c_reubicacionHomeDET(Cn_planId NUMBER) IS
SELECT PRODUCTO_ID, CANTIDAD_DETALLE, COSTO_ITEM, PRECIO_ITEM,
    DESCUENTO_ITEM, ESTADO, IP_CREACION, PRECIO_UNITARIO
FROM DB_COMERCIAL.info_plan_DET 
WHERE PLAN_ID = Cn_planId;

CURSOR c_planCaracteristica(Cn_planId NUMBER) IS
SELECT CARACTERISTICA_ID, VALOR, ESTADO, IP_CREACION
FROM DB_COMERCIAL.info_plan_caracteristica 
WHERE PLAN_ID = Cn_planId;

CURSOR c_restriccionesPlan(Cn_planId NUMBER) IS
SELECT FORMA_PAGO_ID, TIPO_CUENTA_ID, BANCO_TIPO_CUENTA_ID, TIPO_NEGOCIO_ID, ESTADO, IP_CREACION
FROM DB_COMERCIAL.info_plan_condicion 
WHERE PLAN_ID = Cn_planId;


Lv_UsrCreacion              VARCHAR2(30) := 'ecuanet';
Lv_ReubicacionHome          VARCHAR2(30) := 'REUBICACION HOME';
Lv_Reubicacion              VARCHAR2(30) := 'REUBICACION';
Lv_TrasladoHome             VARCHAR2(30) := 'TRASLADO HOME';
Lv_Traslado                 VARCHAR2(30) := 'TRASLADO';
Lc_reubicacionHomeCAB       c_reubicacionHomeCAB%ROWTYPE;
Lc_traslado                 c_traslado%ROWTYPE;
Ln_IdCodPlan                NUMBER;
Lc_reubicacionHomeDET       c_reubicacionHomeDET%ROWTYPE;
Ln_IdProducto               NUMBER;

--
Ln_empresaCodEN             NUMBER := 33;    -- ECUANET
BEGIN
    Ln_IdProducto := NULL;
    -- PROCEDO A CREAR EL PRODUCTO OTROS PARA EL PROCESO DE REUBICACION

    INSERT INTO db_comercial.admi_producto (
        id_producto,
        empresa_cod,
        codigo_producto,
        descripcion_producto,
        funcion_costo,
        instalacion,
        estado,
        fe_creacion,
        usr_creacion,
        ip_creacion,
        cta_contable_prod,
        cta_contable_prod_nc,
        es_preferencia,
        es_enlace,
        requiere_planificacion,
        requiere_info_tecnica,
        nombre_tecnico,
        cta_contable_desc,
        tipo,
        es_concentrador,
        funcion_precio,
        soporte_masivo,
        estado_inicial,
        grupo,
        comision_venta,
        comision_mantenimiento,
        usr_gerente,
        clasificacion,
        requiere_comisionar,
        subgrupo,
        linea_negocio,
        frecuencia,
        termino_condicion
    ) VALUES (
        db_comercial.seq_admi_producto.nextval,
        '33',
        'OTROS',
        'OTROS',
        'COSTO=6.00',
        NULL,
        'Inactivo',
        sysdate,
        'ecuanet',
        '127.0.0.1',
        '4610103001',
        NULL,
        'NO',
        'NO',
        'NO',
        'NO',
        'OTROS',
        '5610103001',
        'S',
        'NO',
        'PRECIO=6.00',
        'N',
        NULL,
        'OTROS',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        'OTROS',
        'OTROS',
        NULL,
        empty_clob()
    ) RETURNING id_producto INTO Ln_IdProducto;


    -- PROCEDO A CREAR EL IMPUESTO PARA EL PRODUCTO OTROS
    INSERT INTO db_comercial.info_producto_impuesto (
        id_producto_impuesto,
        producto_id,
        impuesto_id,
        porcentaje_impuesto,
        fe_creacion,
        usr_creacion,
        fe_ult_mod,
        usr_ult_mod,
        estado
    ) VALUES (
        db_comercial.SEQ_INFO_PRODUCTO_IMPUESTO.nextval,
        Ln_IdProducto,
        '1',
        '12',
        SYSDATE,
        'ecuanet',
        SYSDATE,
        null,
        'Activo'
    );

    -- CREACION DEL PLAN DE REUBICACION HOME
    OPEN c_reubicacionHomeCAB(Lv_ReubicacionHome);
    FETCH c_reubicacionHomeCAB INTO Lc_reubicacionHomeCAB;
    CLOSE c_reubicacionHomeCAB;

    Ln_IdCodPlan := DB_COMERCIAL.SEQ_INFO_PLAN_CAB.NEXTVAL;
    INSERT INTO DB_COMERCIAL.info_plan_cab
    (ID_PLAN,
     CODIGO_PLAN,
     NOMBRE_PLAN,
     DESCRIPCION_PLAN,
     EMPRESA_COD,
     DESCUENTO_PLAN,
     ESTADO,
     IP_CREACION,
     FE_CREACION,
     USR_CREACION,
     IVA,
     ID_SIT,
     TIPO,
     PLAN_ID,
     CODIGO_INTERNO)
    VALUES
    (Ln_IdCodPlan,
     Lc_reubicacionHomeCAB.CODIGO_PLAN,
     Lc_reubicacionHomeCAB.NOMBRE_PLAN,
     Lc_reubicacionHomeCAB.DESCRIPCION_PLAN,
     Ln_empresaCodEN,
     Lc_reubicacionHomeCAB.DESCUENTO_PLAN,
     Lc_reubicacionHomeCAB.ESTADO,
     Lc_reubicacionHomeCAB.IP_CREACION,
     SYSDATE,
     Lv_UsrCreacion,
     Lc_reubicacionHomeCAB.IVA,
     Lc_reubicacionHomeCAB.ID_SIT,
     Lc_reubicacionHomeCAB.TIPO,
     Lc_reubicacionHomeCAB.PLAN_ID,
     Lc_reubicacionHomeCAB.CODIGO_INTERNO);

     -- PROCEDO A REGISTRAR EL HISTORIAL DEL PLAN
    INSERT INTO DB_COMERCIAL.info_plan_historial
    (ID_PLAN_HISTORIAL,
     PLAN_ID,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     ESTADO,
     OBSERVACION)
    VALUES
    (DB_COMERCIAL.SEQ_INFO_PLAN_HISTORIAL.NEXTVAL,
     Ln_IdCodPlan,
     Lv_UsrCreacion,
     SYSDATE,
     Lc_reubicacionHomeCAB.IP_CREACION,
     Lc_reubicacionHomeCAB.ESTADO,
     'Se realizó Clonacion del Plan : REUBICACION HOME para la empresa ECUANET'); 

    -- PROCEDO A CREAR EL DETALLE DEL PLAN
    OPEN c_reubicacionHomeDET(Lc_reubicacionHomeCAB.ID_PLAN);
    FETCH c_reubicacionHomeDET INTO Lc_reubicacionHomeDET;
    CLOSE c_reubicacionHomeDET;

    INSERT INTO DB_COMERCIAL.info_plan_det
    (ID_ITEM,
     PRODUCTO_ID,
     PLAN_ID,
     CANTIDAD_DETALLE,
     COSTO_ITEM,
     PRECIO_ITEM,
     DESCUENTO_ITEM,
     ESTADO,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     PRECIO_UNITARIO)
    values
    (
        DB_COMERCIAL.SEQ_INFO_PLAN_DET.NEXTVAL,
        Ln_IdProducto,
        Ln_IdCodPlan,
        Lc_reubicacionHomeDET.CANTIDAD_DETALLE,
        Lc_reubicacionHomeDET.COSTO_ITEM,
        Lc_reubicacionHomeDET.PRECIO_ITEM,
        Lc_reubicacionHomeDET.DESCUENTO_ITEM,
        Lc_reubicacionHomeDET.ESTADO,
        SYSDATE,
        Lv_UsrCreacion,
        Lc_reubicacionHomeDET.IP_CREACION,
        Lc_reubicacionHomeDET.PRECIO_UNITARIO
    );

    -- PROCEDO A CREAR LAS CARACTERISTICAS DEL PLAN
    FOR Lc_planCaracteristica IN c_planCaracteristica(Lc_reubicacionHomeCAB.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_caracteristica
        (ID_PLAN_CARACTERISITCA,
         PLAN_ID,
         CARACTERISTICA_ID,
         VALOR,
         ESTADO,
         FE_CREACION,
         USR_CREACION,
         IP_CREACION)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CARACTERISTICA.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCaracteristica.CARACTERISTICA_ID,
            Lc_planCaracteristica.VALOR,
            Lc_planCaracteristica.ESTADO,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCaracteristica.IP_CREACION
        );
    END LOOP;

    -- PROCEDO A REGISTRAR LAS CONDICIONES DEL PLAN CREADO
    FOR Lc_planCondicion IN c_restriccionesPlan(Lc_reubicacionHomeCAB.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_condicion
        (ID_PLAN_CONDICION,
         PLAN_ID,
         FORMA_PAGO_ID,
         TIPO_CUENTA_ID,
         BANCO_TIPO_CUENTA_ID,
         TIPO_NEGOCIO_ID,
         FE_CREACION,
         USR_CREACION,
         ESTADO,
         IP_CREACION,
         EMPRESA_COD)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CONDICION.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCondicion.FORMA_PAGO_ID,
            Lc_planCondicion.TIPO_CUENTA_ID,
            Lc_planCondicion.BANCO_TIPO_CUENTA_ID,
            Lc_planCondicion.TIPO_NEGOCIO_ID,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCondicion.ESTADO,
            Lc_planCondicion.IP_CREACION,
            Ln_empresaCodEN
        );
    END LOOP;


    -- SE PROCEDE A CREAR EL PLAN DE REUBICACION PARA LA EMPRESA ECUANET
    OPEN c_reubicacionHomeCAB(Lv_Reubicacion);
    FETCH c_reubicacionHomeCAB INTO Lc_reubicacionHomeCAB;
    CLOSE c_reubicacionHomeCAB;

    INSERT INTO DB_COMERCIAL.info_plan_cab
    (ID_PLAN,
     CODIGO_PLAN,
     NOMBRE_PLAN,
     DESCRIPCION_PLAN,
     EMPRESA_COD,
     DESCUENTO_PLAN,
     ESTADO,
     IP_CREACION,
     FE_CREACION,
     USR_CREACION,
     IVA,
     ID_SIT,
     TIPO,
     PLAN_ID,
     CODIGO_INTERNO)
    VALUES
    (DB_COMERCIAL.SEQ_INFO_PLAN_CAB.NEXTVAL,
     Lc_reubicacionHomeCAB.CODIGO_PLAN,
     Lc_reubicacionHomeCAB.NOMBRE_PLAN,
     Lc_reubicacionHomeCAB.DESCRIPCION_PLAN,
     Ln_empresaCodEN,
     Lc_reubicacionHomeCAB.DESCUENTO_PLAN,
     Lc_reubicacionHomeCAB.ESTADO,
     Lc_reubicacionHomeCAB.IP_CREACION,
     SYSDATE,
     Lv_UsrCreacion,
     Lc_reubicacionHomeCAB.IVA,
     Lc_reubicacionHomeCAB.ID_SIT,
     Lc_reubicacionHomeCAB.TIPO,
     Ln_IdCodPlan,
     Lc_reubicacionHomeCAB.CODIGO_INTERNO)
     RETURNING ID_PLAN INTO Ln_IdCodPlan;

    -- PROCEDO A REGISTRAR EL HISTORIAL DEL PLAN
    INSERT INTO DB_COMERCIAL.info_plan_historial
    (ID_PLAN_HISTORIAL,
     PLAN_ID,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     ESTADO,
     OBSERVACION)
    VALUES
    (DB_COMERCIAL.SEQ_INFO_PLAN_HISTORIAL.NEXTVAL,
     Ln_IdCodPlan,
     Lv_UsrCreacion,
     SYSDATE,
     Lc_reubicacionHomeCAB.IP_CREACION,
     Lc_reubicacionHomeCAB.ESTADO,
     'Se Libera Plan Clonado para su venta -> Plan Clonado: REUBICACION para la empresa ECUANET');

    -- PROCEDO A CREAR EL DETALLE DEL PLAN
    OPEN c_reubicacionHomeDET(Lc_reubicacionHomeCAB.ID_PLAN);
    FETCH c_reubicacionHomeDET INTO Lc_reubicacionHomeDET;
    CLOSE c_reubicacionHomeDET;

    INSERT INTO DB_COMERCIAL.info_plan_det
    (ID_ITEM,
     PRODUCTO_ID,
     PLAN_ID,
     CANTIDAD_DETALLE,
     COSTO_ITEM,
     PRECIO_ITEM,
     DESCUENTO_ITEM,
     ESTADO,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     PRECIO_UNITARIO)
    values
    (
        DB_COMERCIAL.SEQ_INFO_PLAN_DET.NEXTVAL,
        Ln_IdProducto,
        Ln_IdCodPlan,
        Lc_reubicacionHomeDET.CANTIDAD_DETALLE,
        Lc_reubicacionHomeDET.COSTO_ITEM,
        Lc_reubicacionHomeDET.PRECIO_ITEM,
        Lc_reubicacionHomeDET.DESCUENTO_ITEM,
        Lc_reubicacionHomeDET.ESTADO,
        SYSDATE,
        Lv_UsrCreacion,
        Lc_reubicacionHomeDET.IP_CREACION,
        Lc_reubicacionHomeDET.PRECIO_UNITARIO
    );

    -- PROCEDO A CREAR LAS CARACTERISTICAS DEL PLAN
    FOR Lc_planCaracteristica IN c_planCaracteristica(Lc_reubicacionHomeCAB.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_caracteristica
        (ID_PLAN_CARACTERISITCA,
         PLAN_ID,
         CARACTERISTICA_ID,
         VALOR,
         ESTADO,
         FE_CREACION,
         USR_CREACION,
         IP_CREACION)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CARACTERISTICA.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCaracteristica.CARACTERISTICA_ID,
            Lc_planCaracteristica.VALOR,
            Lc_planCaracteristica.ESTADO,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCaracteristica.IP_CREACION
        );
    END LOOP;

    -- PROCEDO A REGISTRAR LAS CONDICIONES DEL PLAN CREADO
    FOR Lc_planCondicion IN c_restriccionesPlan(Lc_reubicacionHomeCAB.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_condicion
        (ID_PLAN_CONDICION,
         PLAN_ID,
         FORMA_PAGO_ID,
         TIPO_CUENTA_ID,
         BANCO_TIPO_CUENTA_ID,
         TIPO_NEGOCIO_ID,
         FE_CREACION,
         USR_CREACION,
         ESTADO,
         IP_CREACION,
         EMPRESA_COD)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CONDICION.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCondicion.FORMA_PAGO_ID,
            Lc_planCondicion.TIPO_CUENTA_ID,
            Lc_planCondicion.BANCO_TIPO_CUENTA_ID,
            Lc_planCondicion.TIPO_NEGOCIO_ID,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCondicion.ESTADO,
            Lc_planCondicion.IP_CREACION,
            Ln_empresaCodEN
        );
    END LOOP;

    --=============================================================
    --==========================TRASLADO===========================
    --=============================================================
    Ln_IdProducto := NULL;

    INSERT INTO db_comercial.admi_producto (
        id_producto,
        empresa_cod,
        codigo_producto,
        descripcion_producto,
        funcion_costo,
        instalacion,
        estado,
        fe_creacion,
        usr_creacion,
        ip_creacion,
        cta_contable_prod,
        cta_contable_prod_nc,
        es_preferencia,
        es_enlace,
        requiere_planificacion,
        requiere_info_tecnica,
        nombre_tecnico,
        cta_contable_desc,
        tipo,
        es_concentrador,
        funcion_precio,
        soporte_masivo,
        estado_inicial,
        grupo,
        comision_venta,
        comision_mantenimiento,
        usr_gerente,
        clasificacion,
        requiere_comisionar,
        subgrupo,
        linea_negocio,
        frecuencia,
        termino_condicion
    ) VALUES (
        db_comercial.seq_admi_producto.nextval,
        '33',
        'TRAS',
        'TRASLADO',
        NULL,
        '0',
        'Activo',
        sysdate,
        'ecuanet',
        '127.0.0.1',
        '4410101003',
        '4410101003',
        'NO',
        'NO',
        'NO',
        NULL,
        NULL,
        NULL,
        'S',
        'NO',
        'if ( [CAPACIDAD1]==1 ) { PRECIO=10.00 } else if ( [CAPACIDAD1]==2 ) { PRECIO=10.00 } else if ( [CAPACIDAD1]==3 ) { PRECIO=10.00 }  else if ( [CAPACIDAD1]==4 ) { PRECIO=10.00 }',
        'N',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        'OTROS',
        'OTROS',
        NULL,
        empty_clob()
    ) RETURNING id_producto INTO Ln_IdProducto;

    INSERT INTO db_comercial.info_producto_impuesto (
        id_producto_impuesto,
        producto_id,
        impuesto_id,
        porcentaje_impuesto,
        fe_creacion,
        usr_creacion,
        fe_ult_mod,
        usr_ult_mod,
        estado
    ) VALUES (
        db_comercial.SEQ_INFO_PRODUCTO_IMPUESTO.nextval,
        Ln_IdProducto,
        '1',
        '12',
        SYSDATE,
        'ecuanet',
        SYSDATE,
        null,
        'Activo'
    );

    -- CREACION DEL PLAN DE TRASLADO HOME
    OPEN c_reubicacionHomeCAB(Lv_TrasladoHome);
    FETCH c_reubicacionHomeCAB INTO Lc_reubicacionHomeCAB;
    CLOSE c_reubicacionHomeCAB;

    Ln_IdCodPlan := DB_COMERCIAL.SEQ_INFO_PLAN_CAB.NEXTVAL;
    INSERT INTO DB_COMERCIAL.info_plan_cab
    (ID_PLAN,
     CODIGO_PLAN,
     NOMBRE_PLAN,
     DESCRIPCION_PLAN,
     EMPRESA_COD,
     DESCUENTO_PLAN,
     ESTADO,
     IP_CREACION,
     FE_CREACION,
     USR_CREACION,
     IVA,
     ID_SIT,
     TIPO,
     PLAN_ID,
     CODIGO_INTERNO)
    VALUES
    (Ln_IdCodPlan,
     Lc_reubicacionHomeCAB.CODIGO_PLAN,
     Lc_reubicacionHomeCAB.NOMBRE_PLAN,
     Lc_reubicacionHomeCAB.DESCRIPCION_PLAN,
     Ln_empresaCodEN,
     Lc_reubicacionHomeCAB.DESCUENTO_PLAN,
     Lc_reubicacionHomeCAB.ESTADO,
     Lc_reubicacionHomeCAB.IP_CREACION,
     SYSDATE,
     Lv_UsrCreacion,
     Lc_reubicacionHomeCAB.IVA,
     Lc_reubicacionHomeCAB.ID_SIT,
     Lc_reubicacionHomeCAB.TIPO,
     Lc_reubicacionHomeCAB.PLAN_ID,
     Lc_reubicacionHomeCAB.CODIGO_INTERNO);

     -- PROCEDO A REGISTRAR EL HISTORIAL DEL PLAN
    INSERT INTO DB_COMERCIAL.info_plan_historial
    (ID_PLAN_HISTORIAL,
     PLAN_ID,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     ESTADO,
     OBSERVACION)
    VALUES
    (DB_COMERCIAL.SEQ_INFO_PLAN_HISTORIAL.NEXTVAL,
     Ln_IdCodPlan,
     Lv_UsrCreacion,
     SYSDATE,
     Lc_reubicacionHomeCAB.IP_CREACION,
     Lc_reubicacionHomeCAB.ESTADO,
     'Se realizó Clonacion del Plan : TRASLADO HOME para la empresa ECUANET'); 

    -- PROCEDO A CREAR EL DETALLE DEL PLAN
    OPEN c_reubicacionHomeDET(Lc_reubicacionHomeCAB.ID_PLAN);
    FETCH c_reubicacionHomeDET INTO Lc_reubicacionHomeDET;
    CLOSE c_reubicacionHomeDET;

    INSERT INTO DB_COMERCIAL.info_plan_det
    (ID_ITEM,
     PRODUCTO_ID,
     PLAN_ID,
     CANTIDAD_DETALLE,
     COSTO_ITEM,
     PRECIO_ITEM,
     DESCUENTO_ITEM,
     ESTADO,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     PRECIO_UNITARIO)
    values
    (
        DB_COMERCIAL.SEQ_INFO_PLAN_DET.NEXTVAL,
        Ln_IdProducto,
        Ln_IdCodPlan,
        Lc_reubicacionHomeDET.CANTIDAD_DETALLE,
        Lc_reubicacionHomeDET.COSTO_ITEM,
        Lc_reubicacionHomeDET.PRECIO_ITEM,
        Lc_reubicacionHomeDET.DESCUENTO_ITEM,
        Lc_reubicacionHomeDET.ESTADO,
        SYSDATE,
        Lv_UsrCreacion,
        Lc_reubicacionHomeDET.IP_CREACION,
        Lc_reubicacionHomeDET.PRECIO_UNITARIO
    );

    -- PROCEDO A CREAR LAS CARACTERISTICAS DEL PLAN
    FOR Lc_planCaracteristica IN c_planCaracteristica(Lc_reubicacionHomeCAB.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_caracteristica
        (ID_PLAN_CARACTERISITCA,
         PLAN_ID,
         CARACTERISTICA_ID,
         VALOR,
         ESTADO,
         FE_CREACION,
         USR_CREACION,
         IP_CREACION)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CARACTERISTICA.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCaracteristica.CARACTERISTICA_ID,
            Lc_planCaracteristica.VALOR,
            Lc_planCaracteristica.ESTADO,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCaracteristica.IP_CREACION
        );
    END LOOP;

    -- PROCEDO A REGISTRAR LAS CONDICIONES DEL PLAN CREADO
    FOR Lc_planCondicion IN c_restriccionesPlan(Lc_reubicacionHomeCAB.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_condicion
        (ID_PLAN_CONDICION,
         PLAN_ID,
         FORMA_PAGO_ID,
         TIPO_CUENTA_ID,
         BANCO_TIPO_CUENTA_ID,
         TIPO_NEGOCIO_ID,
         FE_CREACION,
         USR_CREACION,
         ESTADO,
         IP_CREACION,
         EMPRESA_COD)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CONDICION.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCondicion.FORMA_PAGO_ID,
            Lc_planCondicion.TIPO_CUENTA_ID,
            Lc_planCondicion.BANCO_TIPO_CUENTA_ID,
            Lc_planCondicion.TIPO_NEGOCIO_ID,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCondicion.ESTADO,
            Lc_planCondicion.IP_CREACION,
            Ln_empresaCodEN
        );
    END LOOP;

    -- SE PROCEDE A CREAR EL PLAN DE REUBICACION PARA LA EMPRESA ECUANET
    OPEN c_traslado(Lv_Traslado);
    FETCH c_traslado INTO Lc_traslado;
    CLOSE c_traslado;

    INSERT INTO DB_COMERCIAL.info_plan_cab
    (ID_PLAN,
     CODIGO_PLAN,
     NOMBRE_PLAN,
     DESCRIPCION_PLAN,
     EMPRESA_COD,
     DESCUENTO_PLAN,
     ESTADO,
     IP_CREACION,
     FE_CREACION,
     USR_CREACION,
     IVA,
     ID_SIT,
     TIPO,
     PLAN_ID,
     CODIGO_INTERNO)
    VALUES
    (DB_COMERCIAL.SEQ_INFO_PLAN_CAB.NEXTVAL,
     Lc_traslado.CODIGO_PLAN,
     Lc_traslado.NOMBRE_PLAN,
     Lc_traslado.DESCRIPCION_PLAN,
     Ln_empresaCodEN,
     Lc_traslado.DESCUENTO_PLAN,
     Lc_traslado.ESTADO,
     Lc_traslado.IP_CREACION,
     SYSDATE,
     Lv_UsrCreacion,
     Lc_traslado.IVA,
     Lc_traslado.ID_SIT,
     Lc_traslado.TIPO,
     Ln_IdCodPlan,
     Lc_traslado.CODIGO_INTERNO)
     RETURNING ID_PLAN INTO Ln_IdCodPlan;

    -- PROCEDO A REGISTRAR EL HISTORIAL DEL PLAN
    INSERT INTO DB_COMERCIAL.info_plan_historial
    (ID_PLAN_HISTORIAL,
     PLAN_ID,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     ESTADO,
     OBSERVACION)
    VALUES
    (DB_COMERCIAL.SEQ_INFO_PLAN_HISTORIAL.NEXTVAL,
     Ln_IdCodPlan,
     Lv_UsrCreacion,
     SYSDATE,
     Lc_traslado.IP_CREACION,
     Lc_traslado.ESTADO,
     'Se Libera Plan Clonado para su venta -> Plan Clonado: TRASLADO para la empresa ECUANET');

    -- PROCEDO A CREAR EL DETALLE DEL PLAN
    OPEN c_reubicacionHomeDET(Lc_traslado.ID_PLAN);
    FETCH c_reubicacionHomeDET INTO Lc_reubicacionHomeDET;
    CLOSE c_reubicacionHomeDET;

    INSERT INTO DB_COMERCIAL.info_plan_det
    (ID_ITEM,
     PRODUCTO_ID,
     PLAN_ID,
     CANTIDAD_DETALLE,
     COSTO_ITEM,
     PRECIO_ITEM,
     DESCUENTO_ITEM,
     ESTADO,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     PRECIO_UNITARIO)
    values
    (
        DB_COMERCIAL.SEQ_INFO_PLAN_DET.NEXTVAL,
        Ln_IdProducto,
        Ln_IdCodPlan,
        Lc_reubicacionHomeDET.CANTIDAD_DETALLE,
        Lc_reubicacionHomeDET.COSTO_ITEM,
        Lc_reubicacionHomeDET.PRECIO_ITEM,
        Lc_reubicacionHomeDET.DESCUENTO_ITEM,
        Lc_reubicacionHomeDET.ESTADO,
        SYSDATE,
        Lv_UsrCreacion,
        Lc_reubicacionHomeDET.IP_CREACION,
        Lc_reubicacionHomeDET.PRECIO_UNITARIO
    );

    -- PROCEDO A CREAR LAS CARACTERISTICAS DEL PLAN
    FOR Lc_planCaracteristica IN c_planCaracteristica(Lc_traslado.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_caracteristica
        (ID_PLAN_CARACTERISITCA,
         PLAN_ID,
         CARACTERISTICA_ID,
         VALOR,
         ESTADO,
         FE_CREACION,
         USR_CREACION,
         IP_CREACION)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CARACTERISTICA.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCaracteristica.CARACTERISTICA_ID,
            Lc_planCaracteristica.VALOR,
            Lc_planCaracteristica.ESTADO,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCaracteristica.IP_CREACION
        );
    END LOOP;

    -- PROCEDO A REGISTRAR LAS CONDICIONES DEL PLAN CREADO
    FOR Lc_planCondicion IN c_restriccionesPlan(Lc_traslado.ID_PLAN)
    LOOP
        INSERT INTO DB_COMERCIAL.info_plan_condicion
        (ID_PLAN_CONDICION,
         PLAN_ID,
         FORMA_PAGO_ID,
         TIPO_CUENTA_ID,
         BANCO_TIPO_CUENTA_ID,
         TIPO_NEGOCIO_ID,
         FE_CREACION,
         USR_CREACION,
         ESTADO,
         IP_CREACION,
         EMPRESA_COD)
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_PLAN_CONDICION.NEXTVAL,
            Ln_IdCodPlan,
            Lc_planCondicion.FORMA_PAGO_ID,
            Lc_planCondicion.TIPO_CUENTA_ID,
            Lc_planCondicion.BANCO_TIPO_CUENTA_ID,
            Lc_planCondicion.TIPO_NEGOCIO_ID,
            SYSDATE,
            Lv_UsrCreacion,
            Lc_planCondicion.ESTADO,
            Lc_planCondicion.IP_CREACION,
            Ln_empresaCodEN
        );
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('PLANES_REUBICACION_EN',
                                            'SCRIPT DE CREACIÓN DE PLANES DE REUBICACIÓN PARA LA EMPRESA ECUANET',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            Lv_UsrCreacion,
                                            SYSDATE,
                                            '127.0.0.1');
END;


/