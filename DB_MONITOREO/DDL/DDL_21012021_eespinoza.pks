/*
  =========================================================
            MODIFICACION DE TABLA GPS_DISPOSITIVO
  =========================================================
*/

alter table DB_MONITOREO.GPS_DISPOSITIVO
	add IP_CREACION varchar2(30)
/

alter table DB_MONITOREO.GPS_DISPOSITIVO
	add IP_ULT_MOD VARCHAR2(30)
/

alter table DB_MONITOREO.GPS_DISPOSITIVO
	add ESTADO VARCHAR2(20)
/

alter table DB_MONITOREO.GPS_DISPOSITIVO
	add USR_ULT_MOD VARCHAR2(30)
/

alter table DB_MONITOREO.GPS_DISPOSITIVO
	add USR_CREACION varchar2(30)
/

COMMENT ON COLUMN DB_MONITOREO.GPS_DISPOSITIVO.IP_CREACION is 'ip de creacion de registro';
COMMENT ON COLUMN DB_MONITOREO.GPS_DISPOSITIVO.IP_ULT_MOD is 'ip de modificacion';
COMMENT ON COLUMN DB_MONITOREO.GPS_DISPOSITIVO.USR_ULT_MOD is 'usuario de modificacion de registro';
COMMENT ON COLUMN DB_MONITOREO.GPS_DISPOSITIVO.USR_CREACION is 'usuario que crea el registro';
COMMENT ON COLUMN DB_MONITOREO.GPS_DISPOSITIVO.ESTADO is 'estado del registro';
/