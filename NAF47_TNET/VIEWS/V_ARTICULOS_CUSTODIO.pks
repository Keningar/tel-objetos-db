CREATE    OR REPLACE VIEW "NAF47_TNET"."V_ARTICULOS_CUSTODIO" ("CUSTODIO_ID", "EMPRESA_CUSTODIO_ID", "NOMBRE_CUSTODIO", "TIPO_CUSTODIO", "ARTICULO_ID", "EMPRESA_ID", "LOGIN", "TIPO_ARTICULO", "NO_ARTICULO", "DESCRIPCION", "VALOR_BASE", "CANTIDAD", "FE_ASIGNACION", "FECHA") AS 
  SELECT ACC.CUSTODIO_ID,
       ACC.EMPRESA_CUSTODIO_ID,
       (SELECT  CASE
                when P.TIPO_IDENTIFICACION = 'RUC'
                then P.RAZON_SOCIAL
                else P.APELLIDOS||' '||P.NOMBRES
            END
        FROM DB_COMERCIAL.INFO_PERSONA P,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             DB_GENERAL.INFO_EMPRESA_ROL IER,
             DB_GENERAL.ADMI_ROL AR,
             DB_GENERAL.ADMI_TIPO_ROL ATR
        WHERE IPER.ID_PERSONA_ROL = ACC.CUSTODIO_ID
        AND ATR.DESCRIPCION_TIPO_ROL = ACC.TIPO_CUSTODIO
        AND P.ID_PERSONA = IPER.PERSONA_ID
        AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
        AND IER.ROL_ID = AR.ID_ROL
        AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL) NOMBRE_CUSTODIO,
        ACC.TIPO_CUSTODIO,
        ACC.ARTICULO_ID,
        ACC.EMPRESA_ID,
        ACC.LOGIN,
        ACC.TIPO_ARTICULO,
        ACC.NO_ARTICULO,
        NVL(( SELECT DA.DESCRIPCION
              FROM NAF47_TNET.ARINDA DA
              WHERE DA.NO_ARTI = ACC.NO_ARTICULO
              AND DA.NO_CIA = ACC.EMPRESA_ID), 'FIBRA GENERADA') AS DESCRIPCION,
        SUM(ACC.VALOR_BASE) AS VALOR_BASE,
        SUM(ACC.CANTIDAD) As CANTIDAD,
        --
        CASE 
          WHEN ACC.TIPO_CUSTODIO = 'Empleado' THEN
            (SELECT MAX(FE_ASIGNACION)
             FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO
             WHERE ARTICULO_ID = ACC.ARTICULO_ID
             AND CUSTODIO_ID = ACC.CUSTODIO_ID
             AND ID_CONTROL_ORIGEN is Null
             AND TIPO_ACTIVIDAD = 'DespachoBodega'
             AND FECHA_INICIO <= NAF47_TNET.GEK_VAR.F_GET_FECHA_DESDE)
          ELSE
            (SELECT MAX(FECHA_INICIO)
             FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO
             WHERE ARTICULO_ID = ACC.ARTICULO_ID
             AND CUSTODIO_ID = ACC.CUSTODIO_ID
             AND FECHA_INICIO <= NAF47_TNET.GEK_VAR.F_GET_FECHA_DESDE
             AND FECHA_FIN >= NAF47_TNET.GEK_VAR.F_GET_FECHA_HASTA)             
          END FECHA_ASIGNACION,
        --
        (SELECT MAX(FE_CREACION) from NAF47_TNET.ARAF_CONTROL_CUSTODIO
            WHERE ARTICULO_ID = ACC.ARTICULO_ID
            AND ID_CONTROL_ORIGEN is Null
            AND TIPO_ACTIVIDAD = 'DespachoBodega') FECHA
FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
WHERE ACC.FECHA_INICIO <= NAF47_TNET.GEK_VAR.F_GET_FECHA_DESDE
AND ACC.FECHA_FIN >= NAF47_TNET.GEK_VAR.F_GET_FECHA_HASTA
GROUP BY
    ACC.CUSTODIO_ID,
    ACC.EMPRESA_CUSTODIO_ID,
    ACC.TIPO_CUSTODIO,
    ACC.ARTICULO_ID,
    ACC.EMPRESA_ID,
    ACC.LOGIN,
    Acc.Tipo_Articulo,
    ACC.NO_ARTICULO
having (SUM(ACC.CANTIDAD) != 0);