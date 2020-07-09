# Se inserta el id del parámetro de velocidad a consumirse
# en el microservicio de parámetros (oracle) para envío de correos
#
# @author Leonardo Espinoza <eespinoza@telconet.ec>
# @version 1.0 01-07-2020

INSERT INTO telconetGPSMonitoreo.admi_parametro (
  detalle,
  valor,
  usr_creacion,
  fe_creacion,
  ip_creacion,
  usr_modificacion,
  fe_modificacion,
  ip_modificacion,
  estado
)
VALUES (
  'id_parametro_velocidad',
  '1232',
  'eespinoza',
  CURRENT_TIMESTAMP,
  '127.0.0.1',
  'eespinoza',
  CURRENT_TIMESTAMP,
  '127.0.0.1',
  'Activo'
);
COMMIT;
/

#
# Se inserta el id del parámetro de correos a consumirse
# en el microservicio de parámetros (oracle) para envío de correos
#
# @author Leonardo Espinoza <eespinoza@telconet.ec>
# @version 1.0 
# @since 01-07-2020
#
INSERT INTO telconetGPSMonitoreo.admi_parametro (
  detalle,
  valor,
  usr_creacion,
  fe_creacion,
  ip_creacion,
  usr_modificacion,
  fe_modificacion,
  ip_modificacion,
  estado
)
VALUES (
  'id_parametro_correo',
  '1254',
  'eespinoza',
  CURRENT_TIMESTAMP,
  '127.0.0.1',
  'eespinoza',
  CURRENT_TIMESTAMP,
  '127.0.0.1',
  'Activo'
);
COMMIT;
/