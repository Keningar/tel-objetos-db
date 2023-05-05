/* Formatted on 5/2/2023 10:04:24 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW DB_SOPORTE.VISTA_CASOS_INDIVIDUALES
(
    ID_CASO,
    NUMERO_CASO,
    FE_APERTURA,
    TIPO_AFECTADO,
    PUNTO_ID,
    LOGIN,
    DETALLE_ID
)
BEQUEATH DEFINER
AS
    SELECT ca.ID_CASO,
           ca.NUMERO_CASO,
           ca.FE_APERTURA,
           af.TIPO_AFECTADO,
           af.AFECTADO_ID,
           af.AFECTADO_NOMBRE,
           af.detalle_id
      FROM DB_SOPORTE.INFO_PARTE_AFECTADA     af,
           DB_SOPORTE.INFO_DETALLE            de,
           DB_SOPORTE.INFO_CASO               ca,
           DB_SOPORTE.INFO_DETALLE_HIPOTESIS  dh,
           (  SELECT MIN (c.ID_DETALLE) ID_DETALLE, COUNT (*) AS AFECTADOS
                FROM DB_SOPORTE.INFO_CASO             A,
                     DB_SOPORTE.INFO_DETALLE_HIPOTESIS b,
                     DB_SOPORTE.INFO_DETALLE          c,
                     INFO_PARTE_AFECTADA              D
               WHERE     A.id_caso = b.CASO_ID
                     AND b.ID_DETALLE_HIPOTESIS = c.DETALLE_HIPOTESIS_ID
                     AND C.ID_DETALLE = D.DETALLE_ID
            GROUP BY D.DETALLE_ID, A.ID_CASO) X
     WHERE     af.DETALLE_ID = X.ID_DETALLE
           AND X.AFECTADOS = 1 --Toma solo los casos que tengan una sola afectacion
           AND af.TIPO_AFECTADO = 'Cliente' --Casos con una sola afectacion y sean solo Clientes
           AND af.DETALLE_ID = de.ID_DETALLE
           AND de.DETALLE_HIPOTESIS_ID = dh.ID_DETALLE_HIPOTESIS
           AND dh.CASO_ID = ca.ID_CASO;
/
