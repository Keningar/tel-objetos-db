DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET
  WHERE parametro_id =
  (SELECT Id_Parametro
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
  AND estado            ='Activo'
  );
  DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
  AND estado            ='Activo'; 
  COMMIT;
/
