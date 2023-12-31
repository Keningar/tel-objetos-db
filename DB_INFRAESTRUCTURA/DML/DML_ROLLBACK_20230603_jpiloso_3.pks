SET SERVEROUTPUT ON
--Creación de perfiles equivalentes
DECLARE
 
BEGIN
  DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
  WHERE PARAM_DET.PARAMETRO_ID = (SELECT PARAM_CAB.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                  WHERE PARAM_CAB.NOMBRE_PARAMETRO='MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2' --135
                                  AND PARAM_CAB.ESTADO = 'Activo')
  AND PARAM_DET.ESTADO = 'Activo'
  AND PARAM_DET.VALOR1 = 'EN_PLAN_20M'
  AND PARAM_DET.VALOR2 = 'PERFIL_H_HOME_DEFAULT'; 
  
  DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
  WHERE PARAM_DET.PARAMETRO_ID = (SELECT PARAM_CAB.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                  WHERE PARAM_CAB.NOMBRE_PARAMETRO='MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2' --135
                                  AND PARAM_CAB.ESTADO = 'Activo')
  AND PARAM_DET.ESTADO = 'Activo'
  AND PARAM_DET.VALOR1 = 'EN_PLAN_22M'
  AND PARAM_DET.VALOR2 = 'PERFIL_H_HOME_DEFAULT'; 
  
  COMMIT;
  
  SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2');   
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                           || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
  ROLLBACK;
END;
/

--Creación de valores requeridos para el LDAP
DECLARE
  
BEGIN

  DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
  WHERE PARAM_DET.PARAMETRO_ID = (SELECT PARAM_CAB.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                  WHERE PARAM_CAB.NOMBRE_PARAMETRO='EQ_NUEVOS_PLANES_SI_ACEPTACION' --135
                                  AND PARAM_CAB.ESTADO = 'Activo')
  AND PARAM_DET.ESTADO = 'Activo'
  AND PARAM_DET.VALOR1 = 'EN_PLAN_20M'
  AND PARAM_DET.VALOR2 = 'EN_PLAN_20M'
  AND PARAM_DET.VALOR4 = 'HOME'; 
  
  DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
  WHERE PARAM_DET.PARAMETRO_ID = (SELECT PARAM_CAB.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                  WHERE PARAM_CAB.NOMBRE_PARAMETRO='EQ_NUEVOS_PLANES_SI_ACEPTACION' --135
                                  AND PARAM_CAB.ESTADO = 'Activo')
  AND PARAM_DET.ESTADO = 'Activo'
  AND PARAM_DET.VALOR1 = 'EN_PLAN_22M'
  AND PARAM_DET.VALOR2 = 'EN_PLAN_22M'
  AND PARAM_DET.VALOR4 = 'HOME'; 
  
  SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION');
  COMMIT;
  
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                           || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
  ROLLBACK;
END;
/

--Creación de valores requeridos para el LDAP
DECLARE

BEGIN

      DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
  WHERE PARAM_DET.PARAMETRO_ID = (SELECT PARAM_CAB.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                  WHERE PARAM_CAB.NOMBRE_PARAMETRO='CNR_PERFIL_CLIENT_PCK' --135
                                  AND PARAM_CAB.ESTADO = 'Activo')
  AND PARAM_DET.ESTADO = 'Activo'
  AND PARAM_DET.VALOR1 = 'EN_PLAN_20M'
  AND PARAM_DET.VALOR2 = 'EN_PLAN_20M'
  AND PARAM_DET.VALOR4 = 'EN_PLAN_20M'; 
  
    DELETE
  FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
  WHERE PARAM_DET.PARAMETRO_ID = (SELECT PARAM_CAB.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                  WHERE PARAM_CAB.NOMBRE_PARAMETRO='CNR_PERFIL_CLIENT_PCK' --135
                                  AND PARAM_CAB.ESTADO = 'Activo')
  AND PARAM_DET.ESTADO = 'Activo'
  AND PARAM_DET.VALOR1 = 'EN_PLAN_22M'
  AND PARAM_DET.VALOR2 = 'EN_PLAN_22M'
  AND PARAM_DET.VALOR4 = 'EN_PLAN_22M'; 
  
   SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de parámetro CNR_PERFIL_CLIENT_PCK');

  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                           || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
  ROLLBACK;
END;
/
