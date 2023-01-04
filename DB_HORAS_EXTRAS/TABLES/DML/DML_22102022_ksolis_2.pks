UPDATE DB_GENERAL.admi_parametro_det 
  SET VALOR2 = '1', VALOR3 = 'dia_vencido'
  WHERE  ID_PARAMETRO_DET = (SELECT pardet.ID_PARAMETRO_DET FROM db_general.admi_parametro_det pardet, db_general.admi_parametro_cab parcab 
    WHERE pardet.parametro_id = parcab.id_parametro 
    AND parcab.nombre_parametro = 'DEPARTAMENTOS_ADMINISTRATIVA'
    AND PARAMETRO_ID = parcab.id_parametro
    AND pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
    AND pardet.estado = 'Activo'
    AND pardet.valor1 = 'HELP DESK') 
    AND ESTADO = 'Activo';


UPDATE DB_GENERAL.admi_parametro_det 
SET ESTADO = 'Inactivo'
WHERE  VALOR3 = '2022' AND VALOR1 NOT IN ('12');

COMMIT;

/
