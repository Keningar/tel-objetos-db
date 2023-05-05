/* Formatted on 5/2/2023 9:53:02 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW NAF47_TNET.V_INGRESO_BODEGA_FACTURA
(
    NO_CIA,
    NO_PROVE,
    RAZON_SOCIAL,
    TIPO_DOC,
    NO_DOCU,
    FECHA,
    TOTAL,
    VALOR_FACTURADO,
    SALDO,
    ID_TIPO_TRANSACCION,
    NO_ORDEN,
    ESTADO,
    ADJUDICADOR,
    OBSERV
)
BEQUEATH DEFINER
AS
    SELECT EE.NO_CIA,
           EE.NO_PROVE,
           MP.NOMBRE_LARGO                       AS RAZON_SOCIAL,
           ME.TIPO_DOC,
           ME.NO_DOCU,
           ME.FECHA,
           ME.MOV_TOT                            AS TOTAL,
           ME.MONTO_FACTURADO                    AS VALOR_FACTURADO,
           (ME.MOV_TOT - ME.MONTO_FACTURADO)     AS SALDO,
           EE.ID_TIPO_TRANSACCION,
           EE.NO_ORDEN,
           EE.ESTADO,
           EE.ADJUDICADOR,
           EE.OBSERV
      FROM NAF47_TNET.ARCPMP    MP,
           NAF47_TNET.ARINVTM   TM,
           NAF47_TNET.TAPORDEE  EE,
           NAF47_TNET.ARINME    ME
     WHERE     ME.MONTO_FACTURADO < ME.MOV_TOT
           AND ME.ESTADO != 'P'
           AND TM.REG_MOV = 'S'
           AND TM.MOVIMI = 'E'
           AND TM.CONSUM = 'N'
           AND TM.COMPRA = 'S'
           AND TM.PRODUCCION = 'N'
           AND TM.VENTAS = 'N'
           AND TM.INTERFACE != 'IM'
           AND TM.ESTADO = 'A'
           AND EE.NO_PROVE = MP.NO_PROVE
           AND EE.NO_CIA = MP.NO_CIA
           AND ME.TIPO_DOC = TM.TIPO_M
           AND ME.NO_CIA = TM.NO_CIA
           AND ME.ORDEN_COMPRA = EE.NO_ORDEN
           AND ME.NO_CIA = EE.NO_CIA;
/
