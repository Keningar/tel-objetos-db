CREATE    OR REPLACE VIEW "NAF47_TNET"."V_DETALLE_CONTROL_CUSTODIO" ("ID_CONTROL", "ARTICULO_ID", "TIPO_CUSTODIO", "CUSTODIO_ID", "NOMBRE_CUSTODIO", "LOGIN", "RECIBE", "ENTREGA", "SALDO", "TIPO_ACTIVIDAD", "TIPO_TRANSACCION_ID", "TRANSACCION_ID", "FECHA_PROCESO", "CUSTODIO_RECIBE_ID", "LOGIN_RECIBE", "NOMBRE_CUSTODIO_RECIBE", "ID_CONTROL_ORIGEN", "USR_ULT_MOD", "EMPRESA_ID", "NO_ARTICULO", "USR_CREACION", "TIPO_ARTICULO", "OBSERVACION", "NOMBRE_ARTICULO", "FECHA_INICIO", "FECHA_FIN", "TAREA_ID", "CASO_ID", "ESTADO") AS 
  SELECT ACC.ID_CONTROL,
       ACC.ARTICULO_ID,
       ACC.TIPO_CUSTODIO,
       ACC.CUSTODIO_ID,
       NVL(P.RAZON_SOCIAL, P.APELLIDOS||' '||P.NOMBRES) NOMBRE_CUSTODIO,
       ACC.LOGIN,
       --
       DECODE(SIGN(ACC.MOVIMIENTO), 1, ACC.MOVIMIENTO, 0) RECIBE,
       DECODE(SIGN(ACC.MOVIMIENTO), -1, ABS(ACC.MOVIMIENTO), 0) ENTREGA,
       ACC.CANTIDAD SALDO,
       --
       NVL((SELECT ACC2.TIPO_ACTIVIDAD
            FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC2
            WHERE ACC2.MOVIMIENTO > 0
            AND ROWNUM = 1
            AND ACC2.ARTICULO_ID = ACC.ARTICULO_ID
            AND ACC2.ID_CONTROL > ACC.ID_CONTROL
            AND ACC2.ID_CONTROL_ORIGEN = ACC.ID_CONTROL_ORIGEN), ACC.TIPO_ACTIVIDAD) TIPO_ACTIVIDAD,
       --
       NVL((SELECT ACC2.TIPO_TRANSACCION_ID
            FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC2
            WHERE ACC2.MOVIMIENTO > 0
            AND ROWNUM = 1
            AND ACC2.ARTICULO_ID = ACC.ARTICULO_ID
            AND ACC2.ID_CONTROL > ACC.ID_CONTROL
            AND ACC2.ID_CONTROL_ORIGEN = ACC.ID_CONTROL_ORIGEN), ACC.TIPO_TRANSACCION_ID) TIPO_TRANSACCION_ID,
       --
       ACC.TRANSACCION_ID,
       --
       NVL((SELECT ACC2.FE_ASIGNACION
            FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC2
            WHERE ACC2.MOVIMIENTO > 0
            AND ROWNUM = 1
            AND ACC2.ID_CONTROL > ACC.ID_CONTROL
            AND ACC2.ARTICULO_ID = ACC.ARTICULO_ID
            AND ACC2.ID_CONTROL_ORIGEN = ACC.ID_CONTROL_ORIGEN), ACC.FE_ASIGNACION) FECHA_PROCESO,
       --
       (SELECT ACC2.CUSTODIO_ID
        FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC2
        WHERE ACC2.MOVIMIENTO > 0
        AND ROWNUM = 1
        AND ACC2.ARTICULO_ID = ACC.ARTICULO_ID
        AND ACC2.ID_CONTROL > ACC.ID_CONTROL
        AND ACC2.ID_CONTROL_ORIGEN = ACC.ID_CONTROL_ORIGEN) CUSTODIO_RECIBE_ID,
       --
       (SELECT ACC2.LOGIN
        FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC2
        WHERE ACC2.MOVIMIENTO > 0
        AND ROWNUM = 1
        AND ACC2.ID_CONTROL > ACC.ID_CONTROL
        AND ACC2.ARTICULO_ID = ACC.ARTICULO_ID
        AND ACC2.ID_CONTROL_ORIGEN = ACC.ID_CONTROL_ORIGEN) LOGIN_RECIBE,
       --
       (SELECT NVL(P.RAZON_SOCIAL, P.APELLIDOS||' '||P.NOMBRES)
        FROM DB_COMERCIAL.INFO_PERSONA P,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC2
        WHERE ACC2.MOVIMIENTO > 0
        AND ROWNUM = 1
        AND ACC2.ID_CONTROL > ACC.ID_CONTROL
        AND ACC2.ARTICULO_ID = ACC.ARTICULO_ID
        AND ACC2.ID_CONTROL_ORIGEN = ACC.ID_CONTROL_ORIGEN
        AND IPER.PERSONA_ID = P.ID_PERSONA
        AND ACC2.CUSTODIO_ID = IPER.ID_PERSONA_ROL ) NOMBRE_CUSTODIO_RECIBE,
       --
       ACC.ID_CONTROL_ORIGEN,
       ACC.USR_ULT_MOD,
       ACC.EMPRESA_ID,
       ACC.NO_ARTICULO,
       ACC.USR_CREACION,
       ACC.TIPO_ARTICULO,
       ACC.OBSERVACION,
       --
       (SELECT DA.DESCRIPCION
        FROM NAF47_TNET.ARINDA DA
        WHERE DA.NO_ARTI = ACC.NO_ARTICULO
        AND DA.NO_CIA = ACC.EMPRESA_ID) NOMBRE_ARTICULO,
       --
       ACC.FECHA_INICIO,
       ACC.FECHA_FIN,
       ACC.TAREA_ID,
       ACC.CASO_ID,
       ACC.ESTADO
       --
FROM DB_COMERCIAL.INFO_PERSONA P,
     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
     NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
WHERE IPER.PERSONA_ID = P.ID_PERSONA
AND ACC.CUSTODIO_ID = IPER.ID_PERSONA_ROL;