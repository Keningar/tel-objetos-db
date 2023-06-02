/**
 * JOB_EJECUTA_ACT_COOR_TURNO
 *
 * Job para la activación y eliminación de turnos para 
 * coordinadores en base a la fecha y estado de los registros.
 * 
 * @author Daniel Guzmán <ddguzman@telconet.ec>
 * @version 1.0 11-01-2023 
 */

BEGIN 
	
	BEGIN
		DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_COMERCIAL"."JOB_EJECUTA_ACT_COOR_TURNO"');
		DBMS_OUTPUT.PUT_LINE('JOB se elimino');
	EXCEPTION
		WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('No es posible eliminar el job');
	END;
	DBMS_OUTPUT.PUT_LINE('Eliminando JOB existente...');
	DBMS_OUTPUT.PUT_LINE('Creando JOB....');
	
	DBMS_SCHEDULER.CREATE_JOB(
		job_name => '"DB_COMERCIAL"."JOB_EJECUTA_ACT_COOR_TURNO"',
		job_type => 'PLSQL_BLOCK',
		job_action => 'DECLARE 
                      CURSOR C_GetRegistrosEstadoPendiente
                        IS 
                          SELECT *
                            FROM DB_COMERCIAL.INFO_COORDINADOR_TURNO ict
                            WHERE ict.ESTADO = ''Pendiente'';
                      

                      CURSOR C_GetRegistrosEstadoActivo
                      IS 
                        SELECT *
                        FROM DB_COMERCIAL.INFO_COORDINADOR_TURNO ict
                        WHERE ict.ESTADO = ''Activo'';
                    BEGIN
                      
                      FOR registro IN C_GetRegistrosEstadoPendiente
                          LOOP
                          IF (TO_CHAR(SYSDATE, ''yyyy-mm-dd'') = registro.FECHA_INICIO AND TO_CHAR(SYSDATE, ''hh24'') = SUBSTR(registro.HORA_INICIO ,0, INSTR(registro.HORA_INICIO , '':'') -1)) THEN
                                  UPDATE DB_COMERCIAL.INFO_COORDINADOR_TURNO ict 
                            SET ict.ESTADO = ''Activo'', ict.USR_ULT_MOD = ''telcos'', ict.IP_ULT_MOD = ''127.0.0.1'', ict.FECHA_ULT_MOD = SYSDATE 
                            WHERE ict.ID_COORDINADOR_TURNO  = registro.ID_COORDINADOR_TURNO;
                          END IF;
                        END LOOP; 

                      FOR registro IN C_GetRegistrosEstadoActivo
                          LOOP
                          IF (TO_CHAR(SYSDATE, ''yyyy-mm-dd'') = registro.FECHA_FIN AND TO_CHAR(SYSDATE, ''hh24'') = SUBSTR(registro.HORA_FIN ,0, INSTR(registro.HORA_FIN , '':'') -1)) THEN
                                  UPDATE DB_COMERCIAL.INFO_COORDINADOR_TURNO ict 
                            SET ict.ESTADO = ''Eliminado'', ict.USR_ULT_MOD = ''telcos'', ict.IP_ULT_MOD = ''127.0.0.1'', ict.FECHA_ULT_MOD = SYSDATE 
                            WHERE ict.ID_COORDINADOR_TURNO  = registro.ID_COORDINADOR_TURNO;
                          END IF;
                        END LOOP; 
                      
                    END;',
		number_of_arguments => 0,
		start_date 		   => TO_TIMESTAMP_TZ('2023-01-11 20:00:00.000000000 AMERICA/GUAYAQUIL','YYYY-MM-DD HH24:MI:SS.FF TZR'),
		repeat_interval    => 'FREQ=MINUTELY;INTERVAL=60',
		end_date 		   => NULL,
		enabled 		   => FALSE,
		auto_drop 		   => FALSE,
		comments		   => '');
	
	DBMS_SCHEDULER.SET_ATTRIBUTE(
		name 	  => '"DB_COMERCIAL"."JOB_EJECUTA_ACT_COOR_TURNO"',
		attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
	 
	DBMS_SCHEDULER.enable(
		name => '"DB_COMERCIAL"."JOB_EJECUTA_ACT_COOR_TURNO"');
	
	DBMS_OUTPUT.PUT_LINE('El JOB fue creado satisfactoriamente');

END;