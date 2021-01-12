/*
  =======================================================
  ======= SCRIPT DE REVERSO -  P_MONITOREAR_IMEIS =======
  =======================================================
*/
DROP PROCEDURE IF EXISTS telconetGPSMonitoreo.P_MONITOREAR_IMEIS;

delimiter $$
CREATE PROCEDURE telconetGPSMonitoreo.P_MONITOREAR_IMEIS(IN Pv_Lista_Imeis VARCHAR(10000))
monitoreo_proc:
  BEGIN
    SELECT
      u.lon_segundos,
      u.lat_segundos,
      max(u.hora) as hora,
      u.fecha,
      u.lat_grados,
      u.lat_minutos,
      u.lat_orient,
      u.lon_grados,
      u.lon_minutos,
      u.lon_orient,
      u.status,
      u.telefono,
      u.velocidad
    FROM
      telconetGPSMonitoreo.ubicaciones_2020 u,
      (SELECT
        iti.telefono
      FROM info_telefono_imei iti
      WHERE
        FIND_IN_SET(iti.imei, Pv_Lista_Imeis)) imei
    WHERE
    u.telefono  = imei.telefono
    AND
    u.fecha     = CURRENT_DATE()
    GROUP BY u.telefono
    ORDER BY u.telefono DESC;
  END ;