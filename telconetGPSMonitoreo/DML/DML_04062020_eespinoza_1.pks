#CREACION DEL PARÁMETRO DE VELOCIDAD
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
  'velocidad', 
  '90', 
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