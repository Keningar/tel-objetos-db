/* Formatted on 5/2/2023 9:41:47 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW NAF47_TNET.V_SOLICITUD_COMPRA
(
    EMPRESA_ID,
    ID_SOLICITUD,
    ID_SOLICITUD_DETALLE,
    ID_ARTICULO,
    DESCRIPCION_ARTICULO,
    CANTIDAD,
    FECHA,
    USR_CREACION,
    ESTADO,
    REGION,
    ID_ORDEN_COMPRA,
    USR_ORDEN_COMPRA,
    FECHA_ORDEN_COMPRA,
    ESTADO_ORDEN_COMPRA,
    ORDEN_COMPRA_NAF,
    PROVEEDOR_COMPRA,
    ESTADO_COMPRA
)
BEQUEATH DEFINER
AS
    WITH
        V_SOLICITUD
        AS
            (SELECT VS.EMPRESA_ID,
                    VS.ID_SOLICITUD,
                    VSD.ID_SOLICITUD_DETALLE,
                    VSD.CODIGO                 AS ARTICULO_ID,
                    VSD.CANTIDAD,
                    TRUNC (VS.FE_CREACION)     AS FECHA,
                    VS.USR_CREACION,
                    VS.ESTADO,
                    VS.REGION,
                    VS.PROCESO_SOLICITUD_COMPRA,
                    VS.PEDIDO_ID,
                    VSD.ORDEN_COMPRA_ID
               FROM DB_COMPRAS.INFO_SOLICITUD_DETALLE  VSD
                    JOIN DB_COMPRAS.INFO_SOLICITUD VS
                        ON VS.ID_SOLICITUD = VSD.SOLICITUD_ID),
        V_ORDEN_COMPRA
        AS
            (SELECT A.EMPRESA_ID,
                    A.ID_ORDEN_COMPRA,
                    A.USR_CREACION            AS USR_ORDEN_COMPRA,
                    TRUNC (A.FE_CREACION)     AS FECHA_ORDEN_COMPRA,
                    A.PEDIDO_ID,
                    B.CODIGO                  AS ARTICULO_ID,
                    A.SECUENCIA               AS ORDEN_COMPRA_NAF,
                    A.ESTADO                  AS ESTADO_ORDEN_COMPRA,
                    A.NOMBRE_PROVEEDOR        AS PROVEEDOR_COMPRA
               FROM DB_COMPRAS.INFO_ORDEN_COMPRA  A
                    JOIN DB_COMPRAS.INFO_ORDEN_COMPRA_DETALLE B
                        ON B.ORDEN_COMPRA_ID = A.ID_ORDEN_COMPRA
              WHERE A.ESTADO != 'Anulada')
    SELECT E.CODIGO                                                     AS EMPRESA_ID,
           S.ID_SOLICITUD,
           S.ID_SOLICITUD_DETALLE,
           AR.NO_ARTI                                                   AS ID_ARTICULO,
           AR.DESCRIPCION                                               AS DESCRIPCION_ARTICULO,
           S.CANTIDAD,
           S.FECHA,
           S.USR_CREACION,
           S.ESTADO,
           S.REGION,
           IOC.ID_ORDEN_COMPRA,
           IOC.USR_ORDEN_COMPRA,
           IOC.FECHA_ORDEN_COMPRA,
           IOC.ESTADO_ORDEN_COMPRA,
           IOC.ORDEN_COMPRA_NAF,
           IOC.PROVEEDOR_COMPRA,
           (SELECT DECODE (TA.ESTADO,
                           'P', 'Pendiente',
                           'E', 'Emitido',
                           'F', 'Finalizado',
                           'I', 'Incompleto',
                           'X', 'Anulado',
                           'R', 'Registrada',
                           'O', 'Por Corregir',
                           'C', 'Creada')    AS ESTADO_COMPRA
              FROM NAF47_TNET.TAPORDEE TA
             WHERE     TA.NO_CIA = E.CODIGO
                   AND TA.NO_ORDEN = TO_CHAR (IOC.ORDEN_COMPRA_NAF))    ESTADO_COMPRA
      FROM V_SOLICITUD  S
           JOIN DB_COMPRAS.ADMI_EMPRESA E ON E.ID_EMPRESA = S.EMPRESA_ID
           JOIN NAF47_TNET.ARINDA AR
               ON AR.NO_ARTI = S.ARTICULO_ID AND AR.NO_CIA = E.CODIGO
           LEFT JOIN V_ORDEN_COMPRA IOC
               ON     IOC.ID_ORDEN_COMPRA = S.ORDEN_COMPRA_ID
                  AND IOC.ARTICULO_ID = S.ARTICULO_ID --IOC.EMPRESA_ID = S.EMPRESA_ID AND IOC.PEDIDO_ID = S.PEDIDO_ID
     WHERE S.PROCESO_SOLICITUD_COMPRA = 'R';
/
