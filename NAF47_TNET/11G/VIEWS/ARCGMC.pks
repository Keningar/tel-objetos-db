CREATE  FORCE VIEW "NAF47_TNET"."ARCGMC" ("NO_CIA", "NOMBRE", "ANO_PROCE", "MES_PROCE", "MES_CIERRE", "ACEPTA_TASAS_CAMB", "BANDA_TASAS_CAMB", "MONEDA_FUNC", "MON_REG_CONT", "PROMEDIO", "REPRE", "DIRECCION", "ACEPTA_TERCERO", "CODIGO_TERCERO", "TIPO_ID_TRIBUTARIO", "ID_TRIBUTARIO", "CONDICION_TRIBUTARIA", "CLASE_CAMBIO", "USA_CTAS_AUX", "CC_CUALQUIER_NIVEL", "FORMATO_CTA", "CTA_UND", "CTA_PERDIDAS", "CTA_UND_AJUSTE", "CTA_PERDIDAS_AJUSTE", "CTA_AJUSTE_NOM", "CTA_AJUSTE_DOL", "CTA_U_C_HIST", "CTA_P_C_HIST", "CTA_U_C_CTE", "CTA_P_C_CTE", "COD_DIARIO_DIFCAM", "F_U_DIFCAMBIO", "NO_ASIENTO_DIFCAM", "CTA_UD", "CTA_PD", "FIRMA_1", "FIRMA_2", "FORM_INGRESO", "FORM_EGRESO", "FORM_TRASPASO", "INDICADOR_UTILIDAD", "INDICADOR_CIERREP", "INDICADOR_DIF_CAM", "INDICADOR_CC_DISTBS", "CIERRE_FISCAL", "FECHA_LC", "FECHA_LV", "FECHA_LD", "NOMBRE_LARGO", "IND_MANEJA_AJUSTES", "ANOS_BORRADO_CTA", "FORM_LD", "FORM_LM", "FECHA_LH", "FECHA_LM", "ANO_INI", "MES_INI", "IND_UTILIZA_CONVERSION", "MAX_AJUSTE_PRECISION", "MAX_AJUSTE_PRECISION_DOL", "TELEFONO", "FAX", "RAZON_SOCIAL", "E_MAIL", "TIPO_ID_REP_LEGAL", "IDENTIFICADOR_REP_LEGAL", "IDENTIFICADOR_CONTADOR", "TELEF_RESPONSABLE", "ANO_CIERRE", "DOMINIO", "NOMBRE_CORTO", "COD_AGENTE_RET", "FECHA_COD_AGEN_RET", "NUMERO_AGENTE_RET") AS 
  SELECT "NO_CIA",
           "NOMBRE",
           "ANO_PROCE",
           "MES_PROCE",
           "MES_CIERRE",
           "ACEPTA_TASAS_CAMB",
           "BANDA_TASAS_CAMB",
           "MONEDA_FUNC",
           "MON_REG_CONT",
           "PROMEDIO",
           "REPRE",
           "DIRECCION",
           "ACEPTA_TERCERO",
           "CODIGO_TERCERO",
           "TIPO_ID_TRIBUTARIO",
           "ID_TRIBUTARIO",
           "CONDICION_TRIBUTARIA",
           "CLASE_CAMBIO",
           "USA_CTAS_AUX",
           "CC_CUALQUIER_NIVEL",
           "FORMATO_CTA",
           "CTA_UND",
           "CTA_PERDIDAS",
           "CTA_UND_AJUSTE",
           "CTA_PERDIDAS_AJUSTE",
           "CTA_AJUSTE_NOM",
           "CTA_AJUSTE_DOL",
           "CTA_U_C_HIST",
           "CTA_P_C_HIST",
           "CTA_U_C_CTE",
           "CTA_P_C_CTE",
           "COD_DIARIO_DIFCAM",
           "F_U_DIFCAMBIO",
           "NO_ASIENTO_DIFCAM",
           "CTA_UD",
           "CTA_PD",
           "FIRMA_1",
           "FIRMA_2",
           "FORM_INGRESO",
           "FORM_EGRESO",
           "FORM_TRASPASO",
           "INDICADOR_UTILIDAD",
           "INDICADOR_CIERREP",
           "INDICADOR_DIF_CAM",
           "INDICADOR_CC_DISTBS",
           "CIERRE_FISCAL",
           "FECHA_LC",
           "FECHA_LV",
           "FECHA_LD",
           "NOMBRE_LARGO",
           "IND_MANEJA_AJUSTES",
           "ANOS_BORRADO_CTA",
           "FORM_LD",
           "FORM_LM",
           "FECHA_LH",
           "FECHA_LM",
           "ANO_INI",
           "MES_INI",
           "IND_UTILIZA_CONVERSION",
           "MAX_AJUSTE_PRECISION",
           "MAX_AJUSTE_PRECISION_DOL",
           "TELEFONO",
           "FAX",
           "RAZON_SOCIAL",
           "E_MAIL",
           "TIPO_ID_REP_LEGAL",
           "IDENTIFICADOR_REP_LEGAL",
           "IDENTIFICADOR_CONTADOR",
           "TELEF_RESPONSABLE",
           "ANO_CIERRE",
           "DOMINIO",
           "NOMBRE_CORTO",
           "COD_AGENTE_RET",
           "FECHA_COD_AGEN_RET",
           "NUMERO_AGENTE_RET"
      FROM NAF47_TNET.ARCGMC@GPOETNET;