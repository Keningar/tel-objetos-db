CREATE  FORCE VIEW "NAF47_TNET"."LOGIN_EMPLEADO" ("NO_CIA", "NO_EMPLE", "CEDULA", "LOGIN", "PASSWORD") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "CEDULA",
           "LOGIN",
           "PASSWORD"
      FROM NAF47_TNET.LOGIN_EMPLEADO@GPOETNET;