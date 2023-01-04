/**
 * Documentación para 'JOB_INACTIVAR_CORREOS_PERSONALES'
 * Job que inactiva correos personales de empleados de TN 
 * para que al enviarles correos solo les lleguen al correo corporativo.
 *
 * @author Bryan Fonseca <bfonseca@telconet.ec>
 * @version 1.0 01-09-2022
 */
SET SERVEROUTPUT ON;
BEGIN
	
	BEGIN
		DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_COMERCIAL"."JOB_INAC_CORREOS_PERSONALES"');
		DBMS_OUTPUT.PUT_LINE('Se eliminó el JOB.');
	EXCEPTION
		WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('El JOB aun no existe.');
	END;
	
	DBMS_SCHEDULER.CREATE_JOB (
		JOB_NAME 			=> '"DB_COMERCIAL"."JOB_INAC_CORREOS_PERSONALES"',
		JOB_TYPE 			=> 'PLSQL_BLOCK',
		JOB_ACTION 			=> 'BEGIN DB_COMERCIAL.CMKG_INACT_CORREOS_PERSONALES.P_INACTIVAR_CORREOS_PERSONALES; END;',
		NUMBER_OF_ARGUMENTS => 0,
		START_DATE 			=> TO_TIMESTAMP_TZ('2022-12-13 11:00:00.000000000 AMERICA/GUAYAQUIL','YYYY-MM-DD HH24:MI:SS.FF TZR'),
		REPEAT_INTERVAL		=> 'FREQ=DAILY;BYHOUR=23;BYMINUTE=45', -- CAMBIAR
		END_DATE 			=> NULL,
		ENABLED 			=> FALSE,
		AUTO_DROP 			=> FALSE,
		COMMENTS 			=> 'Job de inactivación de correos electrónicos personales de empleados.');

 DBMS_SCHEDULER.SET_ATTRIBUTE(
  name    => '"DB_COMERCIAL"."JOB_INAC_CORREOS_PERSONALES"',
  attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
  
 DBMS_SCHEDULER.enable(
  name => '"DB_COMERCIAL"."JOB_INAC_CORREOS_PERSONALES"');
 
 DBMS_OUTPUT.PUT_LINE('El JOB fue creado satisfactoriamente');
END;
/