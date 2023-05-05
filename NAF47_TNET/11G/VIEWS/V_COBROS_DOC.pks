CREATE  FORCE VIEW "NAF47_TNET"."V_COBROS_DOC" ("NO_CIA", "TIPO_DOC", "NO_DOCU", "NO_DOCU_REFE", "FECHA", "M_ORIGINAL", "ID_FORMA_PAGO", "REF_CUENTA", "REF_CHEQUE", "REF_FECHA", "REF_COD_BANCO", "COD_T_C", "COD_RET", "VALOR", "SALDO") AS 
  SELECT "NO_CIA",
           "TIPO_DOC",
           "NO_DOCU",
           "NO_DOCU_REFE",
           "FECHA",
           "M_ORIGINAL",
           "ID_FORMA_PAGO",
           "REF_CUENTA",
           "REF_CHEQUE",
           "REF_FECHA",
           "REF_COD_BANCO",
           "COD_T_C",
           "COD_RET",
           "VALOR",
           "SALDO"
      FROM NAF47_TNET.V_COBROS_DOC@GPOETNET;