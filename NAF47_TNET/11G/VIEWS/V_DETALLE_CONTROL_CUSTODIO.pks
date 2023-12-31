CREATE  OR REPLACE VIEW "NAF47_TNET"."V_DETALLE_CONTROL_CUSTODIO" ("ID_CONTROL", "ARTICULO_ID", "TIPO_CUSTODIO", "CUSTODIO_ID", "NOMBRE_CUSTODIO", "LOGIN", "RECIBE", "ENTREGA", "SALDO", "TIPO_ACTIVIDAD", "TIPO_TRANSACCION_ID", "TRANSACCION_ID", "FECHA_PROCESO", "CUSTODIO_RECIBE_ID", "LOGIN_RECIBE", "NOMBRE_CUSTODIO_RECIBE", "ID_CONTROL_ORIGEN", "USR_ULT_MOD", "EMPRESA_ID", "NO_ARTICULO", "USR_CREACION", "TIPO_ARTICULO", "OBSERVACION", "NOMBRE_ARTICULO", "FECHA_INICIO", "FECHA_FIN", "TAREA_ID", "CASO_ID", "ESTADO") AS 
  SELECT "ID_CONTROL",
           "ARTICULO_ID",
           "TIPO_CUSTODIO",
           "CUSTODIO_ID",
           "NOMBRE_CUSTODIO",
           "LOGIN",
           "RECIBE",
           "ENTREGA",
           "SALDO",
           "TIPO_ACTIVIDAD",
           "TIPO_TRANSACCION_ID",
           "TRANSACCION_ID",
           "FECHA_PROCESO",
           "CUSTODIO_RECIBE_ID",
           "LOGIN_RECIBE",
           "NOMBRE_CUSTODIO_RECIBE",
           "ID_CONTROL_ORIGEN",
           "USR_ULT_MOD",
           "EMPRESA_ID",
           "NO_ARTICULO",
           "USR_CREACION",
           "TIPO_ARTICULO",
           "OBSERVACION",
           "NOMBRE_ARTICULO",
           "FECHA_INICIO",
           "FECHA_FIN",
           "TAREA_ID",
           "CASO_ID",
           "ESTADO"
      FROM NAF47_TNET.V_DETALLE_CONTROL_CUSTODIO@GPOETNET;