CREATE  FORCE VIEW "NAF47_TNET"."ARFAENCPROFORM" ("NO_CIA", "CENTROD", "NO_PROFORMA", "RUTA", "GRUPO", "NO_CLIENTE", "FECHA", "OBSERVACIONES", "MONEDA", "TOT_LIN", "SUB_TOTAL", "DESCUENTO", "IMPUESTO", "TOTAL", "ESTADO", "TIPO_CAMBIO", "USUARIO", "TSTAMP", "CEDULA", "NOMBRES", "APELLIDOS", "DIRECCION", "TELEFONO", "TIPO_ID_TRIBUTARIO", "DIAS", "FECHA_VENCE", "TIPO_VENTA", "PORC_DESC", "DIVISION", "VENDEDOR", "USUARIO_APRUEBA", "FECHA_APRUEBA", "EMPLE_APRUEBA", "SUBCLIENTE", "FECHA_ANULA", "USUARIO_ANULA", "IND_APLICA_ESCALA", "BODEGA", "FECHA_CREACION", "IND_PROCESADA", "VALOR_TRANSPORTE", "RUTA_DESPACHO", "IND_FLETE", "CODIGO_TRANSPORTISTA", "IMP_SINO", "NOMBRE_ATENCION") AS 
  SELECT "NO_CIA",
           "CENTROD",
           "NO_PROFORMA",
           "RUTA",
           "GRUPO",
           "NO_CLIENTE",
           "FECHA",
           "OBSERVACIONES",
           "MONEDA",
           "TOT_LIN",
           "SUB_TOTAL",
           "DESCUENTO",
           "IMPUESTO",
           "TOTAL",
           "ESTADO",
           "TIPO_CAMBIO",
           "USUARIO",
           "TSTAMP",
           "CEDULA",
           "NOMBRES",
           "APELLIDOS",
           "DIRECCION",
           "TELEFONO",
           "TIPO_ID_TRIBUTARIO",
           "DIAS",
           "FECHA_VENCE",
           "TIPO_VENTA",
           "PORC_DESC",
           "DIVISION",
           "VENDEDOR",
           "USUARIO_APRUEBA",
           "FECHA_APRUEBA",
           "EMPLE_APRUEBA",
           "SUBCLIENTE",
           "FECHA_ANULA",
           "USUARIO_ANULA",
           "IND_APLICA_ESCALA",
           "BODEGA",
           "FECHA_CREACION",
           "IND_PROCESADA",
           "VALOR_TRANSPORTE",
           "RUTA_DESPACHO",
           "IND_FLETE",
           "CODIGO_TRANSPORTISTA",
           "IMP_SINO",
           "NOMBRE_ATENCION"
      FROM NAF47_TNET.ARFAENCPROFORM@GPOETNET;