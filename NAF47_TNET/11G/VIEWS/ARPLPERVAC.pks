CREATE  FORCE VIEW "NAF47_TNET"."ARPLPERVAC" ("NO_CIA", "NO_EMPLE", "PERIODO", "DIAS_GANADOS", "DIAS_GANADOS_ADIC", "DIAS_DISFRUTADOS", "SALDO_DISFRUTAR") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "PERIODO",
           "DIAS_GANADOS",
           "DIAS_GANADOS_ADIC",
           "DIAS_DISFRUTADOS",
           "SALDO_DISFRUTAR"
      FROM NAF47_TNET.ARPLPERVAC@GPOETNET;