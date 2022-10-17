CREATE OR REPLACE PACKAGE DB_COMPRAS.CPPKG_GESTION_LICITACION AS 

  /**
    * Documentación para el paquete CPPKG_GESTION_LICITACION
    * Paquete que contiene procedimientos y funciones para transacciones.
    * desde el sistema Gestión de Licitación.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 25-06-2022
    */

  /**
    * Documentación para el procedimiento 'P_PROCESAR_SOLICITUDES'.
    * Procedimiento que ingresa las solicitudes de ordenes de compras.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 25-06-2022
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para ingresar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la transacción.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la transacción.
    *
    */
    PROCEDURE P_PROCESAR_SOLICITUDES (
        PN_ID_PEDIDO IN NUMBER,
        PV_STATUS    OUT VARCHAR2,
        PV_MENSAJE   OUT VARCHAR2
    );

  /**
    * Documentación para el procedimiento 'P_INSERTA_INFO_SOLICITUD'.
    * Procedimiento que inserta registro en DB_COMPRAS.INFO_SOLICITUD
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 25-06-2022
    *
    * @param Pr_InfoSolicitud IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE Recibe registro que se va a insertar
    * @param Pv_MensajeError  IN OUT VARCHAR2 Retorna mensaje error.
    *
    */
    PROCEDURE P_INSERTA_INFO_SOLICITUD (
        PR_INFOSOLICITUD IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE,
        PV_MENSAJEERROR  IN OUT VARCHAR2
    );
  /**
    * Documentación para el procedimiento 'P_INSERTA_INFO_SOLICITUD_DET'.
    * Procedimiento que inserta registro en DB_COMPRAS.INFO_SOLICITUD_DETALLE
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 25-06-2022
    *
    * @param Pr_InfoSolicitudDet IN DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE Recibe registro que se va a insertar
    * @param Pv_MensajeError     IN OUT VARCHAR2 Retorna mensaje error.
    *
    */
    PROCEDURE P_INSERTA_INFO_SOLICITUD_DET (
        PR_INFOSOLICITUDDET IN DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE,
        PV_MENSAJEERROR     IN OUT VARCHAR2
    );

  /**
    * Documentación para el procedimiento 'P_PROCESAR_AGREGACION'.
    * Procedimiento que realiza la agregación de artículos.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 25-06-2022
    *
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la transacción.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la transacción.
    *
    */
    PROCEDURE P_PROCESAR_AGREGACION (
        PV_STATUS  OUT VARCHAR2,
        PV_MENSAJE OUT VARCHAR2
    );

END CPPKG_GESTION_LICITACION;
/

CREATE OR REPLACE PACKAGE BODY DB_COMPRAS.CPPKG_GESTION_LICITACION AS

    PROCEDURE P_PROCESAR_SOLICITUDES (
        PN_ID_PEDIDO IN NUMBER,
        PV_STATUS    OUT VARCHAR2,
        PV_MENSAJE   OUT VARCHAR2
    ) AS

        CURSOR C_DATOS_EMPLEADO (
            CN_PEDIDO NUMBER
        ) IS
        SELECT DISTINCT
            P.USR_JEFE     EMPLEADO_ASIGNADO_ID,
            EN.LOGIN_EMPLE USUARIO,
            EC.ID_EMPRESA,
            EC.CODIGO      NO_CIA,
            DC.ID_DEPARTAMENTO,
            DC.AREA_ID,
            EN.IND_REGION  REGION,
            'Bie'          TIPO_SOLICITUD,
            'Pendiente'    ESTADO
        FROM
                 DB_COMPRAS.INFO_PEDIDO P
            JOIN V_EMPLEADOS_EMPRESAS         EN ON EN.LOGIN_EMPLE = P.USR_JEFE
            JOIN DB_COMPRAS.ADMI_EMPRESA      EC ON EC.CODIGO = EN.NO_CIA
            JOIN DB_COMPRAS.ADMI_DEPARTAMENTO DC ON DC.EMPRESA_ID = EC.ID_EMPRESA
                                                    AND DC.DPTO_COD = EN.DEPTO
                                                    AND ID_PEDIDO = CN_PEDIDO;

        CURSOR C_DETALLE_PEDIDO (
            CV_NOCIA NAF47_TNET.ARINDA.NO_CIA%TYPE
        ) IS
        SELECT
            ARTICULO.NO_ARTI,
            ARTICULO.DESCRIPCION,
            DECODE(ARTICULO.APLICA_IMPUESTO, 'G', 'S', 'N') AS APLICA_IMPUESTO,
            ARTICULO.COSTO_UNITARIO,
            PEDIDO_DET.CANTIDAD,
            PEDIDO_DET.ID_PEDIDO_DETALLE
        FROM
                 NAF47_TNET.ARINDA ARTICULO
            JOIN DB_COMPRAS.INFO_PEDIDO_DETALLE PEDIDO_DET ON PEDIDO_DET.PRODUCTO_ID = ARTICULO.NO_ARTI
            JOIN DB_COMPRAS.INFO_PEDIDO         PEDIDO ON PEDIDO.ID_PEDIDO = PEDIDO_DET.PEDIDO_ID
        WHERE
                ARTICULO.NO_CIA = CV_NOCIA
            AND UPPER(PEDIDO_DET.ESTADO) NOT IN ( 'RECHAZADO' )
            AND PEDIDO.ID_PEDIDO = PN_ID_PEDIDO;

        CURSOR C_PARAMETROS (
            CV_CODIGO VARCHAR2
        ) IS
        SELECT
            VALOR
        FROM
            DB_COMPRAS.ADMI_PARAMETRO
        WHERE
                EMPRESA_ID = '1'
            AND CODIGO = CV_CODIGO;

        LC_DATOS_EMPLEADO      C_DATOS_EMPLEADO%ROWTYPE;
        LR_DET_PEDIDO          C_DETALLE_PEDIDO%ROWTYPE;
        LR_PARAMETROS          C_PARAMETROS%ROWTYPE;
        LR_INFOSOLICITUD       DB_COMPRAS.INFO_SOLICITUD%ROWTYPE := NULL;
        LR_INFOSOLICITUDDET    DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE := NULL;
        LN_COUNT_PARAMETROS    NUMBER := 0;
        LN_TOTAL_SOLICITUD     NUMBER(17, 2) := 0;
        LN_SUB_TOTAL_SOLICITUD NUMBER(17, 2) := 0;
        LN_VALOR_IVA_SOLICITUD NUMBER(17, 2) := 0;
        LV_CODIGO_ARTICULO     VARCHAR2(450);
        LV_LOGIN_EMPLEADO      VARCHAR2(100) := '';
        LV_USR_CREACION        VARCHAR2(100) := '';
        LV_ERROR_SOL_CAB       VARCHAR2(450);
        LV_ERROR_SOL_DET       VARCHAR2(450);
        LN_PEDIDO              NUMBER := 0;
        LN_PEDIDO_DET          NUMBER := 0;
        LN_CANT_ARTICULO       NUMBER := 0;
        LN_VALOR               NUMBER(17, 2) := 0;
        LN_SUB_TOTAL           NUMBER(17, 2) := 0;
        LN_VALOR_IVA           NUMBER(17, 2) := 0;
        LN_TOTAL               NUMBER(17, 2) := 0;
        LN_IVA                 NUMBER := 0;
        LV_IVA                 VARCHAR2(50) := 'IVA-12';
        LE_ERRORS EXCEPTION;
    BEGIN
        LR_INFOSOLICITUD := NULL;
        LR_INFOSOLICITUDDET := NULL;
        --
        IF PN_ID_PEDIDO IS NULL THEN
            PV_MENSAJE := 'El parámetro id pedido es obligatorio.';
            RAISE LE_ERRORS;
        END IF;
        --
        IF C_DATOS_EMPLEADO%ISOPEN THEN
            CLOSE C_DATOS_EMPLEADO;
        END IF;
        --
        OPEN C_DATOS_EMPLEADO(PN_ID_PEDIDO);
        FETCH C_DATOS_EMPLEADO INTO LC_DATOS_EMPLEADO;
        --
        LV_LOGIN_EMPLEADO := '';
        --
        IF C_DATOS_EMPLEADO%FOUND THEN
            LV_LOGIN_EMPLEADO := LC_DATOS_EMPLEADO.USUARIO;
        ELSE
            PV_MENSAJE := 'No existe datos del usuario, con los parámetros recibidos.';
            RAISE LE_ERRORS;
        END IF;

        CLOSE C_DATOS_EMPLEADO;
        IF C_PARAMETROS%ISOPEN THEN
            CLOSE C_PARAMETROS;
        END IF;
        OPEN C_PARAMETROS(LV_IVA);
        FETCH C_PARAMETROS INTO LR_PARAMETROS;
        IF C_PARAMETROS%FOUND THEN
            LN_IVA := TO_NUMBER ( LR_PARAMETROS.VALOR, '9999.99' );
        ELSE
            PV_MENSAJE := 'Valor del iva no se encuentra parametrizado.';
            RAISE LE_ERRORS;
        END IF;

        CLOSE C_PARAMETROS;
        LR_INFOSOLICITUD.PEDIDO_ID := PN_ID_PEDIDO;
        LR_INFOSOLICITUD.USR_CREACION := LC_DATOS_EMPLEADO.EMPLEADO_ASIGNADO_ID;
        LR_INFOSOLICITUD.EMPRESA_ID := LC_DATOS_EMPLEADO.ID_EMPRESA;
        LR_INFOSOLICITUD.DEPARTAMENTO_ID := LC_DATOS_EMPLEADO.ID_DEPARTAMENTO;
        LR_INFOSOLICITUD.AREA_ID := LC_DATOS_EMPLEADO.AREA_ID;
        LR_INFOSOLICITUD.REGION := LC_DATOS_EMPLEADO.REGION;
            -- Se asignan valores a los otros campos
        LR_INFOSOLICITUD.TIPO := LC_DATOS_EMPLEADO.TIPO_SOLICITUD;
        LR_INFOSOLICITUD.ESTADO := LC_DATOS_EMPLEADO.ESTADO;
        LR_INFOSOLICITUD.VALOR_TOTAL := 0;
        LR_INFOSOLICITUD.TOTAL_DESCUENTO := 0;
        LR_INFOSOLICITUD.TOTAL_IVA := 0;
        LR_INFOSOLICITUD.SUBTOTAL := 0;
        LR_INFOSOLICITUD.FE_CREACION := SYSDATE;
        LR_INFOSOLICITUD.IP_CREACION := '127.0.0.1';
        LR_INFOSOLICITUD.PROCESO_SOLICITUD_COMPRA := 'NR';
        LR_INFOSOLICITUD.ID_SOLICITUD := DB_COMPRAS.SEQ_INFO_SOLICITUD.NEXTVAL;
            -- se inserta cabecera de solicitud
        P_INSERTA_INFO_SOLICITUD(LR_INFOSOLICITUD, LV_ERROR_SOL_CAB);
        IF LV_ERROR_SOL_CAB IS NOT NULL THEN
            PV_MENSAJE := 'Error al insertar la solicitud.';
            RAISE LE_ERRORS;
        END IF;
        IF C_DETALLE_PEDIDO%ISOPEN THEN
            CLOSE C_DETALLE_PEDIDO;
        END IF;
        FOR LR_DET_PEDIDO IN C_DETALLE_PEDIDO(LC_DATOS_EMPLEADO.NO_CIA) LOOP
            LN_CANT_ARTICULO := LR_DET_PEDIDO.CANTIDAD;
            LV_CODIGO_ARTICULO := LR_DET_PEDIDO.NO_ARTI;
            LN_PEDIDO_DET := LR_DET_PEDIDO.ID_PEDIDO_DETALLE;
            LN_VALOR := LR_DET_PEDIDO.COSTO_UNITARIO;
            LN_SUB_TOTAL := LN_VALOR * LN_CANT_ARTICULO;
            LN_VALOR_IVA := 0;
            IF
                LR_DET_PEDIDO.APLICA_IMPUESTO IS NOT NULL
                AND LR_DET_PEDIDO.APLICA_IMPUESTO = 'S'
            THEN
                LN_VALOR_IVA := LN_SUB_TOTAL * LN_IVA;
            END IF;

            LN_TOTAL := LN_VALOR_IVA + LN_SUB_TOTAL;
            LN_SUB_TOTAL_SOLICITUD := LN_SUB_TOTAL_SOLICITUD + LN_SUB_TOTAL;
            LN_VALOR_IVA_SOLICITUD := LN_VALOR_IVA_SOLICITUD + LN_VALOR_IVA;
            LN_TOTAL_SOLICITUD := LN_TOTAL_SOLICITUD + LN_TOTAL;
            LR_INFOSOLICITUDDET.PEDIDO_DETALLE_ID := LN_PEDIDO_DET;
            LR_INFOSOLICITUDDET.CODIGO := LR_DET_PEDIDO.NO_ARTI;
            LR_INFOSOLICITUDDET.DESCRIPCION := LR_DET_PEDIDO.DESCRIPCION;
            LR_INFOSOLICITUDDET.CANTIDAD := LN_CANT_ARTICULO;
            LR_INFOSOLICITUDDET.ESTADO := 'CotizacionSeleccionada';
            LR_INFOSOLICITUDDET.SOLICITUD_ID := LR_INFOSOLICITUD.ID_SOLICITUD;
            LR_INFOSOLICITUDDET.USR_CREACION := LR_INFOSOLICITUD.USR_CREACION;
            LR_INFOSOLICITUDDET.FE_CREACION := SYSDATE;
            LR_INFOSOLICITUDDET.IP_CREACION := LR_INFOSOLICITUD.IP_CREACION;
            LR_INFOSOLICITUDDET.CODIGO_GENERA_IMPUESTO := LR_DET_PEDIDO.APLICA_IMPUESTO;
            LR_INFOSOLICITUDDET.VALOR := LR_DET_PEDIDO.COSTO_UNITARIO;
            LR_INFOSOLICITUDDET.SUBTOTAL := LN_SUB_TOTAL;
            LR_INFOSOLICITUDDET.PORCENTAJE_DESCUENTO := 0;
            LR_INFOSOLICITUDDET.VALOR_DESCUENTO := 0;
            LR_INFOSOLICITUDDET.IVA := LN_IVA * 100;
            LR_INFOSOLICITUDDET.VALOR_IVA := LN_VALOR_IVA;
            LR_INFOSOLICITUDDET.TOTAL := LN_TOTAL;
            LR_INFOSOLICITUDDET.ID_SOLICITUD_DETALLE := DB_COMPRAS.SEQ_INFO_SOLICITUD_DETALLE.NEXTVAL;
            -- se inserta detalle de solicitud
            P_INSERTA_INFO_SOLICITUD_DET(LR_INFOSOLICITUDDET, LV_ERROR_SOL_DET);
            IF LV_ERROR_SOL_DET IS NOT NULL THEN
                RAISE LE_ERRORS;
            END IF;
        END LOOP;

        IF LN_TOTAL_SOLICITUD > 0 THEN
            UPDATE DB_COMPRAS.INFO_SOLICITUD
            SET
                TOTAL_IVA = LN_VALOR_IVA_SOLICITUD,
                SUBTOTAL = LN_SUB_TOTAL_SOLICITUD,
                VALOR_TOTAL = LN_TOTAL_SOLICITUD
            WHERE
                ID_SOLICITUD = LR_INFOSOLICITUD.ID_SOLICITUD;

        END IF;

        COMMIT;
        PV_STATUS := 'OK';
        PV_MENSAJE := 'Transacción exitosa';
    EXCEPTION
        WHEN LE_ERRORS THEN
            PV_STATUS := 'ERROR';
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('COMPRAS', 'CPPKG_GESTION_LICITACION.P_PROCESAR_SOLICITUDES',
                                                 PV_MENSAJE,
                                                 LV_LOGIN_EMPLEADO,
                                                 SYSDATE,
                                                 '127.0.0.1');

        WHEN OTHERS THEN
            PV_STATUS := 'ERROR';
            PV_MENSAJE := SQLERRM;
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('COMPRAS', 'CPPKG_GESTION_LICITACION.P_PROCESAR_SOLICITUDES',
                                                 SQLERRM,
                                                 LV_LOGIN_EMPLEADO,
                                                 SYSDATE,
                                                 '127.0.0.1');

    END P_PROCESAR_SOLICITUDES;

    PROCEDURE P_INSERTA_INFO_SOLICITUD (
        PR_INFOSOLICITUD IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE,
        PV_MENSAJEERROR  IN OUT VARCHAR2
    ) IS
    BEGIN
        INSERT INTO DB_COMPRAS.INFO_SOLICITUD (
            ID_SOLICITUD,
            TIPO,
            VALOR_TOTAL,
            ESTADO,
            PEDIDO_ID,
            FE_CREACION,
            IP_CREACION,
            USR_ULT_MOD,
            FE_ULT_MOD,
            USR_CREACION,
            OBSERVACION,
            EMPRESA_ID,
            AREA_ID,
            DEPARTAMENTO_ID,
            TOTAL_DESCUENTO,
            TOTAL_IVA,
            SUBTOTAL,
            REGION,
            PROCESO_SOLICITUD_COMPRA
        ) VALUES (
            PR_INFOSOLICITUD.ID_SOLICITUD,
            PR_INFOSOLICITUD.TIPO,
            PR_INFOSOLICITUD.VALOR_TOTAL,
            PR_INFOSOLICITUD.ESTADO,
            PR_INFOSOLICITUD.PEDIDO_ID,
            PR_INFOSOLICITUD.FE_CREACION,
            PR_INFOSOLICITUD.IP_CREACION,
            PR_INFOSOLICITUD.USR_ULT_MOD,
            PR_INFOSOLICITUD.FE_ULT_MOD,
            PR_INFOSOLICITUD.USR_CREACION,
            PR_INFOSOLICITUD.OBSERVACION,
            PR_INFOSOLICITUD.EMPRESA_ID,
            PR_INFOSOLICITUD.AREA_ID,
            PR_INFOSOLICITUD.DEPARTAMENTO_ID,
            PR_INFOSOLICITUD.TOTAL_DESCUENTO,
            PR_INFOSOLICITUD.TOTAL_IVA,
            PR_INFOSOLICITUD.SUBTOTAL,
            PR_INFOSOLICITUD.REGION,
            PR_INFOSOLICITUD.PROCESO_SOLICITUD_COMPRA
        );

    EXCEPTION
        WHEN OTHERS THEN
            PV_MENSAJEERROR := 'Error en COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_INFO_SOLICITUD: ' || SQLERRM;
    END P_INSERTA_INFO_SOLICITUD;

    PROCEDURE P_INSERTA_INFO_SOLICITUD_DET (
        PR_INFOSOLICITUDDET IN DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE,
        PV_MENSAJEERROR     IN OUT VARCHAR2
    ) IS
    BEGIN
        INSERT INTO DB_COMPRAS.INFO_SOLICITUD_DETALLE (
            ID_SOLICITUD_DETALLE,
            CODIGO,
            DESCRIPCION,
            CANTIDAD,
            VALOR,
            SUBTOTAL,
            ESTADO,
            NO_PROVEEDOR,
            CEDULA_PROVEEDOR,
            NOMBRE_PROVEEDOR,
            PROVINCIA_PROVEEDOR,
            EMAIL_PROVEEDOR,
            SOLICITUD_ID,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            USR_ULT_MOD,
            FE_ULT_MOD,
            OBSERVACION,
            ORDEN_COMPRA_ID,
            PEDIDO_DETALLE_ID,
            PORCENTAJE_DESCUENTO,
            VALOR_DESCUENTO,
            IVA,
            VALOR_IVA,
            SERVICIO_ID,
            TOTAL,
            RUTA_ARCHIVO,
            NOMBRE_ARCHIVO,
            FORMATO_ARCHIVO,
            ARCHIVO_COTIZACION,
            CODIGO_GENERA_IMPUESTO,
            VALOR_SERVICIO,
            PORCENTAJE_IMPUESTO,
            VALOR_IMPUESTO
        ) VALUES (
            PR_INFOSOLICITUDDET.ID_SOLICITUD_DETALLE,
            PR_INFOSOLICITUDDET.CODIGO,
            PR_INFOSOLICITUDDET.DESCRIPCION,
            PR_INFOSOLICITUDDET.CANTIDAD,
            PR_INFOSOLICITUDDET.VALOR,
            PR_INFOSOLICITUDDET.SUBTOTAL,
            PR_INFOSOLICITUDDET.ESTADO,
            PR_INFOSOLICITUDDET.NO_PROVEEDOR,
            PR_INFOSOLICITUDDET.CEDULA_PROVEEDOR,
            PR_INFOSOLICITUDDET.NOMBRE_PROVEEDOR,
            PR_INFOSOLICITUDDET.PROVINCIA_PROVEEDOR,
            PR_INFOSOLICITUDDET.EMAIL_PROVEEDOR,
            PR_INFOSOLICITUDDET.SOLICITUD_ID,
            PR_INFOSOLICITUDDET.USR_CREACION,
            PR_INFOSOLICITUDDET.FE_CREACION,
            PR_INFOSOLICITUDDET.IP_CREACION,
            PR_INFOSOLICITUDDET.USR_ULT_MOD,
            PR_INFOSOLICITUDDET.FE_ULT_MOD,
            PR_INFOSOLICITUDDET.OBSERVACION,
            PR_INFOSOLICITUDDET.ORDEN_COMPRA_ID,
            PR_INFOSOLICITUDDET.PEDIDO_DETALLE_ID,
            PR_INFOSOLICITUDDET.PORCENTAJE_DESCUENTO,
            PR_INFOSOLICITUDDET.VALOR_DESCUENTO,
            PR_INFOSOLICITUDDET.IVA,
            PR_INFOSOLICITUDDET.VALOR_IVA,
            PR_INFOSOLICITUDDET.SERVICIO_ID,
            PR_INFOSOLICITUDDET.TOTAL,
            PR_INFOSOLICITUDDET.RUTA_ARCHIVO,
            PR_INFOSOLICITUDDET.NOMBRE_ARCHIVO,
            PR_INFOSOLICITUDDET.FORMATO_ARCHIVO,
            PR_INFOSOLICITUDDET.ARCHIVO_COTIZACION,
            PR_INFOSOLICITUDDET.CODIGO_GENERA_IMPUESTO,
            0,
            0,
            0
        );

    EXCEPTION
        WHEN OTHERS THEN
            PV_MENSAJEERROR := 'Error en COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_INFO_SOLICITUD_DET: ' || SQLERRM;
    END P_INSERTA_INFO_SOLICITUD_DET;

    PROCEDURE P_PROCESAR_AGREGACION (
        PV_STATUS  OUT VARCHAR2,
        PV_MENSAJE OUT VARCHAR2
    ) IS
        --Cursor que obtiene todas las solicitudes, desde un id
        CURSOR C_SOLICITUDES_POR_ID (
            CN_NOCIA        IN NUMBER,
            CN_SOLICITUD_ID IN NUMBER
        ) IS
        SELECT
            SOL_CAB.ID_SOLICITUD          AS SOLICITUD_CAB_ID,
            DET_SOL.ID_SOLICITUD_DETALLE  AS SOLICITUD_DET_ID,
            ARTICULO.NO_ARTI,
            ARTICULO.DESCRIPCION          AS DESC_ARTI,
            DET_SOL.CANTIDAD,
            DET_SOL.VALOR,
            DET_SOL.SUBTOTAL,
            DET_SOL.ESTADO,
            DET_SOL.USR_CREACION,
            DET_SOL.FE_CREACION,
            PEDIDO_DET.ID_PEDIDO_DETALLE  AS ID_PEDIDO_DET,
            PEDIDO_CAB.ID_PEDIDO          AS ID_PEDIDO_CAB,
            PEDIDO_CAB.LOGIN,
            (
                SELECT
                    IPU.ID_PUNTO
                FROM
                    DB_COMERCIAL.INFO_PUNTO IPU
                WHERE
                    IPU.LOGIN = PEDIDO_CAB.LOGIN
            )                             AS PUNTO_ID,
            PEDIDO_DET.SERVICIO_ID_TELCOS AS SERVICIO_ID,
            PEDIDO_CAB.PROYECTO_ID_TELCOS AS PROYECTO_ID
        FROM
                 DB_COMPRAS.INFO_SOLICITUD SOL_CAB
            JOIN DB_COMPRAS.INFO_SOLICITUD_DETALLE DET_SOL ON DET_SOL.SOLICITUD_ID = SOL_CAB.ID_SOLICITUD
            JOIN NAF47_TNET.ARINDA                 ARTICULO ON ARTICULO.NO_ARTI = DET_SOL.CODIGO
                                               AND ARTICULO.NO_CIA = CN_NOCIA
            LEFT OUTER JOIN DB_COMPRAS.INFO_PEDIDO_DETALLE    PEDIDO_DET ON PEDIDO_DET.ID_PEDIDO_DETALLE = DET_SOL.PEDIDO_DETALLE_ID
            LEFT OUTER JOIN DB_COMPRAS.INFO_PEDIDO            PEDIDO_CAB ON PEDIDO_CAB.ID_PEDIDO = PEDIDO_DET.PEDIDO_ID
        WHERE
                SOL_CAB.ID_SOLICITUD > CN_SOLICITUD_ID
            AND DET_SOL.ID_SOLICITUD_DETALLE NOT IN (
                SELECT
                    SOLICITUD_DETALLE_ID
                FROM
                    DB_COMPRAS.INFO_TENDER_DET_SOL
                WHERE
                    ESTADO = 'Pendiente'
            )
            AND DET_SOL.ESTADO IN('Pendiente','CotizacionSeleccionada')
            AND SOL_CAB.ESTADO = 'Pendiente'
        ORDER BY
            SOL_CAB.FE_CREACION ASC;

        --Cursor que obtiene la última solicitud procesada
        CURSOR C_ULTIMA_SOLICITUD (
            CV_ESTADO IN VARCHAR2
        ) IS
        SELECT
            MAX(SOLICITUD_ID) AS SOLICITUD_ID
        FROM
            DB_COMPRAS.INFO_TENDER_EXEC
        WHERE
            ESTADO_EJECUCION = CV_ESTADO;

        --Cursor que obtiene la última solicitud procesada de la infoTenderDetSol
        CURSOR C_ULTIMA_SOLICITUD_AGREGADA IS
        SELECT
            SOL_CAB.ID_SOLICITUD
        FROM
                 DB_COMPRAS.INFO_SOLICITUD SOL_CAB
            JOIN DB_COMPRAS.INFO_SOLICITUD_DETALLE DET_SOL ON DET_SOL.SOLICITUD_ID = SOL_CAB.ID_SOLICITUD
        WHERE
            DET_SOL.ID_SOLICITUD_DETALLE = (
                SELECT
                    MAX(SOLICITUD_DETALLE_ID)
                FROM
                    DB_COMPRAS.INFO_TENDER_DET_SOL
            );

        --Cursor que obtiene los tenderCab por categoría
        CURSOR C_TENDER_CAB_POR_CAT (
            CV_CATEGORIA_DESC IN VARCHAR2
        ) IS
        SELECT
            ID_TENDER_CAB,
            CODIGO_TENDER,
            CATEGORIA_ID,
            CATEGORIA_DESC,
            DESCRIPCION,
            VALOR,
            FE_ENVIO,
            FE_VENCIMIENTO,
            TIPO_UNIDAD,
            DETALLE_KATUK,
            ESTADO,
            USR_CREACION,
            FE_CREACION,
            USR_ULT_MOD,
            FE_ULT_MOD
        FROM
            DB_COMPRAS.INFO_TENDER_CAB
        WHERE
                CATEGORIA_DESC = CV_CATEGORIA_DESC
            AND ESTADO = 'Pendiente';
        --Cursor que valida si existe un tenderDet con los parámetros enviados
        CURSOR C_VALIDA_TENDER_DET (
            CV_CODIGO        IN VARCHAR2,
            CV_ESTADO        IN VARCHAR2,
            CN_TENDER_CAB_ID IN NUMBER
        ) IS
        SELECT
            TENDER_DET.ID_TENDER_DET,
            TENDER_DET.TENDER_CAB_ID,
            TENDER_DET.SUBCAT_ID,
            TENDER_DET.SUBCAT_DESC,
            TENDER_DET.CODIGO,
            TENDER_DET.DESCRIPCION,
            TENDER_DET.CANTIDAD,
            TENDER_DET.VALOR_UNITARIO,
            TENDER_DET.SUBTOTAL,
            TENDER_DET.ESTADO,
            TENDER_DET.USR_CREACION,
            TENDER_DET.FE_CREACION,
            TENDER_DET.USR_ULT_MOD,
            TENDER_DET.FE_ULT_MOD
        FROM
            DB_COMPRAS.INFO_TENDER_DET TENDER_DET
        WHERE
                TENDER_DET.CODIGO = CV_CODIGO
            AND TENDER_DET.ESTADO = CV_ESTADO
            AND TENDER_DET.TENDER_CAB_ID = CN_TENDER_CAB_ID;
        --Cursor agrupa los artículos de las solicitudes
        CURSOR C_TENDER_DET_SOL (
            CN_NOCIA      IN NUMBER,
            CN_TENDER_CAB IN NUMBER
        ) IS
        SELECT
            TENDER_DET_SOL.TENDER_CAB_ID                           AS CAB_ID,
            TENDER_DET_SOL.CODIGO,
            ARTICULO.DESCRIPCION,
            SUM(TENDER_DET_SOL.CANTIDAD)                           AS CANTIDAD,
            ARTICULO.COSTO_UNITARIO                                AS VALOR_UNITARIO,
            SUM(ARTICULO.COSTO_UNITARIO * TENDER_DET_SOL.CANTIDAD) AS SUBTOTAL,
            'Pendiente'                                            AS ESTADO,
            'TelcoS+'                                              AS USR_CREACION,
            SYSDATE                                                AS FE_CREACION
        FROM
                 DB_COMPRAS.INFO_TENDER_DET_SOL TENDER_DET_SOL
            JOIN NAF47_TNET.ARINDA          ARTICULO ON TENDER_DET_SOL.CODIGO = ARTICULO.NO_ARTI
            JOIN DB_COMPRAS.INFO_TENDER_CAB TENDER_CAB ON TENDER_CAB.ID_TENDER_CAB = TENDER_DET_SOL.TENDER_CAB_ID
        WHERE
                TENDER_DET_SOL.ESTADO = 'Pendiente'
            AND ARTICULO.NO_CIA = CN_NOCIA
            AND TENDER_CAB.ID_TENDER_CAB = CN_TENDER_CAB
        GROUP BY
            TENDER_DET_SOL.TENDER_CAB_ID,
            TENDER_DET_SOL.CODIGO,
            ARTICULO.DESCRIPCION,
            ARTICULO.COSTO_UNITARIO;
        --Cursor que obtiene las categorías existentes
        CURSOR C_CATEGORIAS_EXISTENTES (
            CN_NOCIA IN NUMBER
        ) IS
        SELECT DISTINCT
            CAT_CAB.CODIGO,
            CAT_CAB.NOMBRE
        FROM
                 NAF47_TNET.ARIN_CATALOGO_KATUK_DET CAT_DET
            JOIN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB CAT_CAB ON CAT_CAB.ID_CATALOGO = CAT_DET.CATALOGO_ID
                                                               AND CAT_CAB.ESTADO = 'A'
        WHERE
            CAT_DET.ESTADO = 'A'
        ORDER BY
            CAT_CAB.NOMBRE ASC;
        --Cursor que obtiene los tender cab pendientes por artículo y categoría
        CURSOR C_TENDER_CAB_POR_ARTICULO (
            CN_NOCIA          IN NUMBER,
            CV_CATEGORIA_DESC IN VARCHAR2,
            CV_NO_ARTI        IN VARCHAR2
        ) IS
        SELECT DISTINCT
            TENDER_CAB.ID_TENDER_CAB,
            TENDER_CAB.CODIGO_TENDER,
            TENDER_CAB.CATEGORIA_ID,
            TENDER_CAB.CATEGORIA_DESC,
            TENDER_CAB.VALOR,
            TENDER_CAB.ESTADO
        FROM
                 NAF47_TNET.ARINDA ARTICULO
            JOIN NAF47_TNET.ARIN_CATALOGO_KATUK_DET CAT_DET ON CAT_DET.ID_CATALOGO_DET = ARTICULO.CATALOGO_ID_DET
            JOIN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB CAT_CAB ON CAT_CAB.ID_CATALOGO = CAT_DET.CATALOGO_ID
                                                               AND CAT_CAB.ESTADO = 'A'
            JOIN DB_COMPRAS.INFO_TENDER_CAB         TENDER_CAB ON TENDER_CAB.CATEGORIA_DESC = CAT_CAB.NOMBRE
        WHERE
                CAT_DET.ESTADO = 'A'
            AND ARTICULO.NO_CIA = CN_NOCIA
            AND TENDER_CAB.ESTADO = 'Pendiente'
            AND TENDER_CAB.CATEGORIA_DESC = CV_CATEGORIA_DESC
            AND ARTICULO.NO_ARTI = CV_NO_ARTI;
        --Cursor que suma el totalizado al tender Cab
        CURSOR C_TOTAL_TENDER_CAB IS
        SELECT
            SUM(TENDER_DET.SUBTOTAL) AS TOTAL,
            TENDER_DET.TENDER_CAB_ID TENDER_CAB_ID
        FROM
            DB_COMPRAS.INFO_TENDER_DET TENDER_DET
        WHERE
            TENDER_DET.ESTADO = 'Pendiente'
        GROUP BY
            TENDER_DET.TENDER_CAB_ID;
        --Cursor que retorna los valores de los parametros
        CURSOR C_PARAMETROS_DET (
            CV_NOMBRE_PARAMETRO IN VARCHAR2,
            CV_DESCRIPCION      IN VARCHAR2,
            CV_ESTADO           IN VARCHAR2
        ) IS
        SELECT
            DET.*
        FROM
                 DB_GENERAL.ADMI_PARAMETRO_CAB CAB
            JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
        WHERE
                CAB.NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
            AND DET.DESCRIPCION = 'BANDERA_RECURRENTES'
            AND DET.ESTADO = 'Activo';
        --Variables
        LR_SOLICITUDES_POR_ID      C_SOLICITUDES_POR_ID%ROWTYPE;
        LR_ULT_SOLICITUD           C_ULTIMA_SOLICITUD%ROWTYPE;
        LR_ULT_SOLICITUD_AGREGADA  C_ULTIMA_SOLICITUD_AGREGADA%ROWTYPE;
        LR_TENDER_CAB_POR_CAT      C_TENDER_CAB_POR_CAT%ROWTYPE;
        LR_TENDER_DET_SOL          C_TENDER_DET_SOL%ROWTYPE;
        LR_VALIDA_TENDER_DET       C_VALIDA_TENDER_DET%ROWTYPE;
        LR_CATEGORIAS_EXISTENTES   C_CATEGORIAS_EXISTENTES%ROWTYPE;
        LR_TENDER_CAB_POR_ARTICULO C_TENDER_CAB_POR_ARTICULO%ROWTYPE;
        LR_TOTAL_TENDER_CAB        C_TOTAL_TENDER_CAB%ROWTYPE;
        LR_PARAMETROS_DET          C_PARAMETROS_DET%ROWTYPE;
        LN_TENDER_CAB_ID           NUMBER;
        LN_TENDER_EXEC             NUMBER;
        LN_NOCIA                   NUMBER := 10;
        LN_TENDER_DET_SOL_ID       NUMBER;
        LV_CATEGORIA               VARCHAR2(450);
        LV_NOMBRE_PARAMETRO        VARCHAR2(100) := 'LOGIN_X_PEDIDO_PARAM_INI';
        LV_DESCRIPCION             VARCHAR2(100) := 'BANDERA_RECURRENTES';
        LV_ESTADO                  VARCHAR2(100) := 'Activo';
        LE_ERRORS EXCEPTION;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('-----------------');
        DBMS_OUTPUT.PUT_LINE('INICIANDO PROCESO');
        OPEN C_ULTIMA_SOLICITUD('Finalizado');
        FETCH C_ULTIMA_SOLICITUD INTO LR_ULT_SOLICITUD;
        IF
            C_ULTIMA_SOLICITUD%FOUND
            AND LR_ULT_SOLICITUD.SOLICITUD_ID IS NOT NULL
        THEN
        --Ingresamos un registro en la tabla INFO_TENDER_EXEC para saber desde y hasta que solicitud hemos agregado.
            LN_TENDER_EXEC := DB_COMPRAS.SEQ_INFO_TENDER_EXEC.NEXTVAL;
            INSERT INTO DB_COMPRAS.INFO_TENDER_EXEC (
                ID_TENDER_EXEC,
                ESTADO_EJECUCION,
                FE_EJECUCION_INI
            ) VALUES (
                LN_TENDER_EXEC,
                'Pendiente',
                SYSDATE
            );
        --Buscamos si existe un tender Sin Categoría, en caso de no existir se crea un nuevo registro.
            OPEN C_TENDER_CAB_POR_CAT('Sin Categoría');
            FETCH C_TENDER_CAB_POR_CAT INTO LR_TENDER_CAB_POR_CAT;
            IF C_TENDER_CAB_POR_CAT%NOTFOUND THEN
                INSERT INTO DB_COMPRAS.INFO_TENDER_CAB (
                    ID_TENDER_CAB,
                    CATEGORIA_DESC,
                    DESCRIPCION,
                    VALOR,
                    ESTADO,
                    USR_CREACION,
                    FE_CREACION
                ) VALUES (
                    DB_COMPRAS.SEQ_INFO_TENDER_CAB.NEXTVAL,
                    'Sin Categoría',
                    '',
                    0,
                    'Pendiente',
                    'TelcoS+',
                    SYSDATE
                );

            END IF;

            CLOSE C_TENDER_CAB_POR_CAT;
        --Recorremos todas las categorías existentes, en caso de no existir un tender con esa categoría se deberá crear.
            FOR LR_CATEGORIAS_EXISTENTES IN C_CATEGORIAS_EXISTENTES(LN_NOCIA) LOOP
                OPEN C_TENDER_CAB_POR_CAT(LR_CATEGORIAS_EXISTENTES.NOMBRE);
                FETCH C_TENDER_CAB_POR_CAT INTO LR_TENDER_CAB_POR_CAT;
                IF C_TENDER_CAB_POR_CAT%FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Tender existente, procedemos con la actualización');
                    DBMS_OUTPUT.PUT_LINE('TENDER CAB : ' || LR_TENDER_CAB_POR_CAT.ID_TENDER_CAB);
                    DBMS_OUTPUT.PUT_LINE('TENDER Desc: ' || LR_TENDER_CAB_POR_CAT.CATEGORIA_DESC);
                    LN_TENDER_CAB_ID := LR_TENDER_CAB_POR_CAT.ID_TENDER_CAB;
                    LV_CATEGORIA := LR_TENDER_CAB_POR_CAT.CATEGORIA_DESC;
                ELSE
                    LV_CATEGORIA := LR_CATEGORIAS_EXISTENTES.NOMBRE;
                    LN_TENDER_CAB_ID := DB_COMPRAS.SEQ_INFO_TENDER_CAB.NEXTVAL;
                    DBMS_OUTPUT.PUT_LINE('no existe tender:'
                                         || LR_CATEGORIAS_EXISTENTES.NOMBRE
                                         || ' en estado pendiente, procedemos a crear uno');
                    INSERT INTO DB_COMPRAS.INFO_TENDER_CAB (
                        ID_TENDER_CAB,
                        CATEGORIA_ID,
                        CATEGORIA_DESC,
                        DESCRIPCION,
                        VALOR,
                        ESTADO,
                        USR_CREACION,
                        FE_CREACION
                    ) VALUES (
                        LN_TENDER_CAB_ID,
                        LR_CATEGORIAS_EXISTENTES.CODIGO,
                        LR_CATEGORIAS_EXISTENTES.NOMBRE,
                        '',
                        0,
                        'Pendiente',
                        'TelcoS+',
                        SYSDATE
                    );

                END IF;

                DBMS_OUTPUT.PUT_LINE('-----------------');
                DBMS_OUTPUT.PUT_LINE('RECORRIENDO SOLICITUDES');
                DBMS_OUTPUT.PUT_LINE('CATEGORIA       : ' || LV_CATEGORIA);
                FOR LR_SOLICITUDES_POR_ID IN C_SOLICITUDES_POR_ID(LN_NOCIA, LR_ULT_SOLICITUD.SOLICITUD_ID) LOOP
                    DBMS_OUTPUT.PUT_LINE('-----------------');
                    DBMS_OUTPUT.PUT_LINE('SOLICITUD_DET_ID: ' || LR_SOLICITUDES_POR_ID.SOLICITUD_DET_ID);
                    DBMS_OUTPUT.PUT_LINE('DESC_ARTI       : ' || LR_SOLICITUDES_POR_ID.NO_ARTI);
                    DBMS_OUTPUT.PUT_LINE('DESC_ARTI       : ' || LR_SOLICITUDES_POR_ID.DESC_ARTI);
                    DBMS_OUTPUT.PUT_LINE('CANTIDAD        : ' || LR_SOLICITUDES_POR_ID.CANTIDAD);
                    DBMS_OUTPUT.PUT_LINE('VALOR           : ' || LR_SOLICITUDES_POR_ID.VALOR);
                    DBMS_OUTPUT.PUT_LINE('SUBTOTAL        : ' || LR_SOLICITUDES_POR_ID.SUBTOTAL);
                    DBMS_OUTPUT.PUT_LINE('PROYECTO_ID     : ' || LR_SOLICITUDES_POR_ID.PROYECTO_ID);
                    OPEN C_TENDER_CAB_POR_ARTICULO(LN_NOCIA, LV_CATEGORIA, LR_SOLICITUDES_POR_ID.NO_ARTI);
                    FETCH C_TENDER_CAB_POR_ARTICULO INTO LR_TENDER_CAB_POR_ARTICULO;
                    IF C_TENDER_CAB_POR_ARTICULO%FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('id_tender_cab : ' || LN_TENDER_CAB_ID);
                        OPEN C_PARAMETROS_DET(LV_NOMBRE_PARAMETRO, LV_DESCRIPCION, LV_ESTADO);
                        FETCH C_PARAMETROS_DET INTO LR_PARAMETROS_DET;
                        IF
                            C_PARAMETROS_DET%FOUND
                            AND ( LR_PARAMETROS_DET.VALOR1 = 'PERMITIDO' OR (
                                LR_PARAMETROS_DET.VALOR1 = 'NO_PERMITIDO'
                                AND LR_SOLICITUDES_POR_ID.PROYECTO_ID IS NOT NULL
                            ) )
                        THEN
                            LN_TENDER_DET_SOL_ID := DB_COMPRAS.SEQ_INFO_TENDER_DET_SOL.NEXTVAL;
                            INSERT INTO DB_COMPRAS.INFO_TENDER_DET_SOL (
                                ID_TENDER_DET_SOL,
                                TENDER_CAB_ID,
                                SOLICITUD_DETALLE_ID,
                                PROYECTO_ID,
                                PUNTO_ID,
                                SERVICIO_ID,
                                CODIGO,
                                CANTIDAD,
                                ESTADO,
                                USR_CREACION,
                                FE_CREACION
                            ) VALUES (
                                LN_TENDER_DET_SOL_ID,
                                LN_TENDER_CAB_ID,
                                LR_SOLICITUDES_POR_ID.SOLICITUD_DET_ID,
                                LR_SOLICITUDES_POR_ID.PROYECTO_ID,
                                LR_SOLICITUDES_POR_ID.PUNTO_ID,
                                LR_SOLICITUDES_POR_ID.SERVICIO_ID,
                                LR_SOLICITUDES_POR_ID.NO_ARTI,
                                LR_SOLICITUDES_POR_ID.CANTIDAD,
                                'Pendiente',
                                'TelcoS+',
                                SYSDATE
                            );

                        END IF;

                        CLOSE C_PARAMETROS_DET;
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('No se realiza registro en la infoTenderDetSol');
                    END IF;

                    CLOSE C_TENDER_CAB_POR_ARTICULO;
                END LOOP;

                CLOSE C_TENDER_CAB_POR_CAT;
                DBMS_OUTPUT.PUT_LINE('-----------------');
                --Aquí recorremos la tenderSol por la tenderCab
                DBMS_OUTPUT.PUT_LINE('Ingresamos los artículos agrupados');
                FOR LR_TENDER_DET_SOL IN C_TENDER_DET_SOL(LN_NOCIA, LN_TENDER_CAB_ID) LOOP
                    DBMS_OUTPUT.PUT_LINE('-----------------');
                    DBMS_OUTPUT.PUT_LINE('CAB_ID        : ' || LR_TENDER_DET_SOL.CAB_ID);
                    DBMS_OUTPUT.PUT_LINE('NO_ARTI       : ' || LR_TENDER_DET_SOL.CODIGO);
                    DBMS_OUTPUT.PUT_LINE('CANTIDAD      : ' || LR_TENDER_DET_SOL.CANTIDAD);
                    DBMS_OUTPUT.PUT_LINE('VALOR_UNITARIO: ' || LR_TENDER_DET_SOL.VALOR_UNITARIO);
                    DBMS_OUTPUT.PUT_LINE('SUBTOTAL      : ' || LR_TENDER_DET_SOL.SUBTOTAL);
                    --Validamos en la infoTenderDet que exista el artículo, en caso de existir actualizamos, caso contrario creamos
                    OPEN C_VALIDA_TENDER_DET(LR_TENDER_DET_SOL.CODIGO, 'Pendiente', LR_TENDER_DET_SOL.CAB_ID);
                    FETCH C_VALIDA_TENDER_DET INTO LR_VALIDA_TENDER_DET;
                    IF C_VALIDA_TENDER_DET%FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('-->EDITO');
                        DBMS_OUTPUT.PUT_LINE('ID_TENDER_DET: ' || LR_VALIDA_TENDER_DET.ID_TENDER_DET);
                        DBMS_OUTPUT.PUT_LINE('ID_TENDER_CAB: ' || LR_VALIDA_TENDER_DET.TENDER_CAB_ID);
                        UPDATE DB_COMPRAS.INFO_TENDER_DET TENDER_DET
                        SET
                            TENDER_DET.CANTIDAD = LR_TENDER_DET_SOL.CANTIDAD,
                            TENDER_DET.VALOR_UNITARIO = LR_TENDER_DET_SOL.VALOR_UNITARIO,
                            TENDER_DET.SUBTOTAL = LR_TENDER_DET_SOL.SUBTOTAL
                        WHERE
                            TENDER_DET.ID_TENDER_DET = LR_VALIDA_TENDER_DET.ID_TENDER_DET;

                    ELSE
                        DBMS_OUTPUT.PUT_LINE('-->INGRESO');
                        INSERT INTO DB_COMPRAS.INFO_TENDER_DET (
                            ID_TENDER_DET,
                            TENDER_CAB_ID,
                            SUBCAT_ID,
                            SUBCAT_DESC,
                            CODIGO,
                            DESCRIPCION,
                            CANTIDAD,
                            VALOR_UNITARIO,
                            SUBTOTAL,
                            ESTADO,
                            USR_CREACION,
                            FE_CREACION
                        )
                            SELECT
                                DB_COMPRAS.SEQ_INFO_TENDER_DET.NEXTVAL,
                                CAB_ID,
                                SUBCAT_ID,
                                SUBCAT_DESC,
                                CODIGO,
                                DESCRIPCION,
                                CANTIDAD,
                                VALOR_UNITARIO,
                                SUBTOTAL,
                                ESTADO,
                                USR_CREACION,
                                FE_CREACION
                            FROM
                                (
                                    SELECT
                                        TENDER_DET_SOL.TENDER_CAB_ID                           AS CAB_ID,
                                        CAT_DET.CODIGO                                         AS SUBCAT_ID,
                                        CAT_DET.NOMBRE                                         AS SUBCAT_DESC,
                                        TENDER_DET_SOL.CODIGO,
                                        ARTICULO.DESCRIPCION,
                                        SUM(TENDER_DET_SOL.CANTIDAD)                           AS CANTIDAD,
                                        ARTICULO.COSTO_UNITARIO                                AS VALOR_UNITARIO,
                                        SUM(ARTICULO.COSTO_UNITARIO * TENDER_DET_SOL.CANTIDAD) AS SUBTOTAL,
                                        'Pendiente'                                            AS ESTADO,
                                        'TelcoS+'                                              AS USR_CREACION,
                                        SYSDATE                                                AS FE_CREACION
                                    FROM
                                             DB_COMPRAS.INFO_TENDER_DET_SOL TENDER_DET_SOL
                                        JOIN NAF47_TNET.ARINDA                  ARTICULO ON TENDER_DET_SOL.CODIGO = ARTICULO.NO_ARTI
                                        JOIN NAF47_TNET.ARIN_CATALOGO_KATUK_DET CAT_DET ON CAT_DET.ID_CATALOGO_DET = ARTICULO.CATALOGO_ID_DET
                                        JOIN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB CAT_CAB ON CAT_CAB.ID_CATALOGO = CAT_DET.CATALOGO_ID
                                    WHERE
                                            TENDER_DET_SOL.ESTADO = 'Pendiente'
                                        AND ARTICULO.NO_CIA = LN_NOCIA
                                        AND ARTICULO.NO_ARTI = LR_TENDER_DET_SOL.CODIGO
                                        AND CAT_DET.ESTADO = 'A'
                                        AND CAT_CAB.ESTADO = 'A'
                                    GROUP BY
                                        TENDER_DET_SOL.TENDER_CAB_ID,
                                        CAT_DET.CODIGO,
                                        CAT_DET.NOMBRE,
                                        TENDER_DET_SOL.CODIGO,
                                        ARTICULO.DESCRIPCION,
                                        ARTICULO.COSTO_UNITARIO
                                );

                    END IF;

                    CLOSE C_VALIDA_TENDER_DET;
                END LOOP;

                DBMS_OUTPUT.PUT_LINE('Artículos agrupados exitosamente');
                DBMS_OUTPUT.PUT_LINE('------------------------');
            END LOOP;

            FOR LR_TOTAL_TENDER_CAB IN C_TOTAL_TENDER_CAB LOOP
                UPDATE DB_COMPRAS.INFO_TENDER_CAB
                SET
                    VALOR = LR_TOTAL_TENDER_CAB.TOTAL
                WHERE
                    ID_TENDER_CAB = LR_TOTAL_TENDER_CAB.TENDER_CAB_ID;

            END LOOP;

            OPEN C_ULTIMA_SOLICITUD_AGREGADA;
            FETCH C_ULTIMA_SOLICITUD_AGREGADA INTO LR_ULT_SOLICITUD_AGREGADA;
            IF
                C_ULTIMA_SOLICITUD_AGREGADA%FOUND
                AND LR_ULT_SOLICITUD_AGREGADA.ID_SOLICITUD IS NOT NULL
            THEN
                UPDATE DB_COMPRAS.INFO_TENDER_EXEC
                SET
                    SOLICITUD_ID = LR_ULT_SOLICITUD_AGREGADA.ID_SOLICITUD,
                    ESTADO_EJECUCION = 'Finalizado',
                    FE_EJECUCION_FIN = SYSDATE
                WHERE
                    ID_TENDER_EXEC = LN_TENDER_EXEC;

            END IF;

            COMMIT;
        END IF;

        CLOSE C_ULTIMA_SOLICITUD_AGREGADA;
        DBMS_OUTPUT.PUT_LINE('-----------------');
        DBMS_OUTPUT.PUT_LINE('FIN PROCESO');
        PV_STATUS := 'OK';
    EXCEPTION
        WHEN LE_ERRORS THEN
            PV_STATUS := 'ERROR';
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('COMPRAS', 'CPPKG_GESTION_LICITACION.P_PROCESAR_AGREGACION',
                                                 PV_MENSAJE,
                                                 'COMPRAS',
                                                 SYSDATE,
                                                 '127.0.0.1');

        WHEN OTHERS THEN
            PV_STATUS := 'ERROR';
            PV_MENSAJE := SQLERRM;
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('COMPRAS', 'CPPKG_GESTION_LICITACION.P_PROCESAR_AGREGACION',
                                                 SQLERRM,
                                                 'COMPRAS',
                                                 SYSDATE,
                                                 '127.0.0.1');

    END P_PROCESAR_AGREGACION;

END CPPKG_GESTION_LICITACION;
/