/* Formatted on 5/24/2023 11:35:01 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW NAF47_TNET.V_DETALLE_PEDIDOS
(
    PEDIDO_ID,
    ID_PEDIDO_DETALLE,
    PRODUCTO_ID,
    ID_EMPRESA_PRODUCTO,
    DESCRIPCION_AUTORIZADA,
    CANTIDAD_AUTORIZADA,
    CANTIDAD_SOLICITADA,
    CANTIDAD_DESPACHADA,
    ESTADO,
    ES_COMPRA,
    USR_ASIGNADO_ID,
    USR_ASIGNADO,
    ID_EMPRESA_USR_ASIGNADO,
    PLACA,
    NOMBRE_USR_ASIGNADO,
    DESCRIPCION_USO,
    CANTON_ID,
    NOMBRE_CANTON
)
BEQUEATH DEFINER
AS
    SELECT DP.PEDIDO_ID,
           DP.ID_PEDIDO_DETALLE,
           DP.PRODUCTO_ID,
           EA.CODIGO
               ID_EMPRESA_PRODUCTO,
           DP.DESCRIPCION
               DESCRIPCION_AUTORIZADA,
           NVL (DP.CANTIDAD, 0)
               CANTIDAD_AUTORIZADA,
           NVL (DP.CANTIDAD_SOLICITADA, 0)
               CANTIDAD_SOLICITADA,
           NVL (DP.CANTIDAD_DESPACHADA, 0)
               CANTIDAD_DESPACHADA,
           DP.ESTADO,
           DP.ES_COMPRA,
           DP.USR_ASIGNADO_ID,
           DP.USR_ASIGNADO,
           EU.CODIGO
               ID_EMPRESA_USR_ASIGNADO,
           DP.PLACA,
           (SELECT NOMBRE
              FROM (SELECT E.NOMBRE AS NOMBRE, 'EMP' AS tipo
                      FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS E
                     WHERE     E.NO_CIA = EU.CODIGO
                           AND E.NO_EMPLE = DP.USR_ASIGNADO_ID
                    UNION
                    SELECT Z.NOMBRE AS NOMBRE, 'CON' AS tipo
                      FROM ARINMCNT Z
                     WHERE     Z.NO_CIA = EU.CODIGO
                           AND Z.NO_CONTRATISTA = DP.USR_ASIGNADO_ID)
             WHERE tipo = p.usr_asignado_tipo AND ROWNUM <= 1)
               NOMBRE_USR_ASIGNADO,
           UPPER (U.DESCRIPCION)
               DESCRIPCION_USO,
           DECODE (
               P.USR_ASIGNADO_TIPO,
               'EMP', (SELECT OG.CANTON_ID
                         FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS  VE,
                              DB_COMERCIAL.INFO_OFICINA_GRUPO  OG
                        WHERE     VE.OFICINA = OG.ID_OFICINA
                              AND VE.NO_CIA = OG.EMPRESA_ID
                              AND VE.NO_EMPLE = DP.USR_ASIGNADO_ID
                              AND VE.NO_CIA = EU.CODIGO),
               NULL)
               CANTON_ID,
           DECODE (
               P.USR_ASIGNADO_TIPO,
               'EMP', (SELECT C.NOMBRE_CANTON
                         FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS  VE,
                              DB_COMERCIAL.INFO_OFICINA_GRUPO  OG,
                              DB_GENERAL.ADMI_CANTON           C
                        WHERE     VE.OFICINA = OG.ID_OFICINA
                              AND VE.NO_CIA = OG.EMPRESA_ID
                              AND OG.CANTON_ID = C.ID_CANTON
                              AND VE.NO_EMPLE = DP.USR_ASIGNADO_ID
                              AND VE.NO_CIA = EU.CODIGO),
               NULL)
               NOMBRE_CANTON
      FROM DB_COMPRAS.INFO_PEDIDO_DETALLE  DP,
           DB_COMPRAS.INFO_PEDIDO          P,
           DB_COMPRAS.ADMI_DEPARTAMENTO    D,
           DB_COMPRAS.ADMI_EMPRESA         EU,
           DB_COMPRAS.INFO_PEDIDO_USO      U,
           DB_COMPRAS.ADMI_EMPRESA         EA
     WHERE     DP.PEDIDO_ID = P.ID_PEDIDO
           AND DP.PEDIDO_USO_ID = U.ID_PEDIDO_USO
           AND P.DEPARTAMENTO_ID = D.ID_DEPARTAMENTO
           AND D.EMPRESA_ID = EU.ID_EMPRESA
           AND DP.PRODUCTO_EMPRESA_ID = EA.ID_EMPRESA
           AND DP.ESTADO NOT IN ('Ingresado', 'Pendiente', 'Rechazado');
