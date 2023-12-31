
/**
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 *Se elimina los nuevos parametros
 **/

DELETE FROM  DB_GENERAL.ADMI_PARAMETRO_DET  WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO        
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'PLANIFICACION_COMERCIAL_HAL' AND ESTADO= 'Activo');
  
/

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'PLANIFICACION_COMERCIAL_HAL';




DELETE FROM  DB_GENERAL.ADMI_PARAMETRO_DET  WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO        
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO' AND ESTADO= 'Activo');
  
/

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO';


/
  UPDATE  DB_GENERAL.admi_parametro_det       
  SET VALOR1 ='ver-08 | Dic-2021',VALOR2=NULL , USR_ULT_MOD='ccaguana',FE_ULT_MOD = SYSDATE
  WHERE PARAMETRO_ID  in (SELECT id_parametro FROM db_general.admi_parametro_cab WHERE nombre_parametro = 'DOC_VERSION_CONTRATO_DIGITAL' AND estado = 'Activo')
  AND DESCRIPCION  = 'adendumMegaDatos'; 
/

  UPDATE  DB_GENERAL.admi_parametro_det       
  SET VALOR1 =NULL,VALOR2='ver-07 | Ene-2021' USR_ULT_MOD='ccaguana',FE_ULT_MOD = SYSDATE
  WHERE PARAMETRO_ID  in (SELECT id_parametro FROM db_general.admi_parametro_cab WHERE nombre_parametro = 'DOC_VERSION_CONTRATO_DIGITAL' AND estado = 'Activo')
  AND DESCRIPCION  = 'terminosCondicionesMegadatos';        

/


COMMIT;

/

