CREATE  FORCE VIEW "NAF47_TNET"."INV_CAB_SOLICITUD_REQUISICION" ("NO_CIA", "CENTRO", "NUMERO_SOLICITUD", "CENTRO_COSTO", "FECHA", "OBSERVACION", "USUARIO_CREACION", "ESTADO", "IND_APROBADO", "USUARIO_APROBACION", "FECHA_APROBACION", "MOTIVO_NO_APROBADO", "NUMERO_DOCUMENTO_REFERENCIA", "TIPO_DOCUMENTO", "USER_REALIZA", "COD_PLANTILLA", "VALIDA_APROBADO", "FECHA_INGRESO", "FECHA_ULTIMA_MODIF", "USUARIOBD_APROBACION", "FECHA_RECHAZA", "USUARIO_RECHAZA", "ID_PRESUPUESTO", "ID_EMPRESA_DESPACHA", "ID_BODEGA", "EMPLEADO_SOLICITANTE", "NO_CIA_SOLICITANTE", "NO_CIA_RESPONSABLE", "NO_CIA_EMP_REALIZA") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NUMERO_SOLICITUD",
           "CENTRO_COSTO",
           "FECHA",
           "OBSERVACION",
           "USUARIO_CREACION",
           "ESTADO",
           "IND_APROBADO",
           "USUARIO_APROBACION",
           "FECHA_APROBACION",
           "MOTIVO_NO_APROBADO",
           "NUMERO_DOCUMENTO_REFERENCIA",
           "TIPO_DOCUMENTO",
           "USER_REALIZA",
           "COD_PLANTILLA",
           "VALIDA_APROBADO",
           "FECHA_INGRESO",
           "FECHA_ULTIMA_MODIF",
           "USUARIOBD_APROBACION",
           "FECHA_RECHAZA",
           "USUARIO_RECHAZA",
           "ID_PRESUPUESTO",
           "ID_EMPRESA_DESPACHA",
           "ID_BODEGA",
           "EMPLEADO_SOLICITANTE",
           "NO_CIA_SOLICITANTE",
           "NO_CIA_RESPONSABLE",
           "NO_CIA_EMP_REALIZA"
      FROM NAF47_TNET.INV_CAB_SOLICITUD_REQUISICION@GPOETNET;