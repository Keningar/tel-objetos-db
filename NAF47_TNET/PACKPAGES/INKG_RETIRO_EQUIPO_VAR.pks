CREATE OR REPLACE package NAF47_TNET.INKG_RETIRO_EQUIPO_VAR is

  -- Author  : JOHNNY
  -- Created : 02/12/2022 9:07:48
  -- Purpose :

  -- Public type declarations
  GRX_ENTRE_EMPRESAS  BOOLEAN := false;

  PROCEDURE P_SET_ENTRE_EMPRESAS (PV_VALOR IN VARCHAR2);

end INKG_RETIRO_EQUIPO_VAR;
/

CREATE OR REPLACE package body NAF47_TNET.INKG_RETIRO_EQUIPO_VAR is

PROCEDURE P_SET_ENTRE_EMPRESAS (PV_VALOR IN VARCHAR2) IS
  BEGIN
    if(PV_VALOR='S') then
       INKG_RETIRO_EQUIPO_VAR.GRX_ENTRE_EMPRESAS := true;
    else
      INKG_RETIRO_EQUIPO_VAR.GRX_ENTRE_EMPRESAS := false;
    end if;
  END;
end INKG_RETIRO_EQUIPO_VAR;
/
