/**
 * Documentación para 'JOB_HISTORIAL_SERV_PLANF'
 * Job que sirve para Escribir en el historial de servicio cuando una planificación pasa a pyl
 *
 * @author Edgar Pin Villavicencio <epin@telconet.ec>
 * @version 1.0 24-10-2021
 */
SET SERVEROUTPUT ON;
SET DEFINE OFF;
BEGIN

  BEGIN
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => '"DB_COMERCIAL"."JOB_HISTORIAL_SERV_PLANF"',
                            DEFER    => FALSE,
                            FORCE    => TRUE);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('El job aún no ha sido creado...');
  END;

  DBMS_SCHEDULER.CREATE_JOB (
     JOB_NAME             => '"DB_COMERCIAL"."JOB_HISTORIAL_SERV_PLANF"',
     JOB_TYPE             => 'PLSQL_BLOCK',
     JOB_ACTION           => 'DECLARE
                                PV_CODEMPRESA VARCHAR2(200);
                                PV_TIPO VARCHAR2(200);
                                PV_ESTADO VARCHAR2(200);
                                PV_STATUS VARCHAR2(200);
                                PV_MENSAJE VARCHAR2(200);
                              BEGIN
                                PV_CODEMPRESA := ''18'';
                                PV_TIPO := ''SOLICITUD PLANIFICACION'';
                                PV_ESTADO := ''PrePlanificada'';
                              
                                CMKG_HISTORIAL_SERV_PLANF.P_INSERTA_HISTORIAL(
                                  PV_CODEMPRESA => PV_CODEMPRESA,
                                  PV_TIPO => PV_TIPO,
                                  PV_ESTADO => PV_ESTADO,
                                  PV_STATUS => PV_STATUS,
                                  PV_MENSAJE => PV_MENSAJE
                                );
                                END;',
     NUMBER_OF_ARGUMENTS  =>  0,
     START_DATE           =>  NULL,
     REPEAT_INTERVAL      => 'FREQ=MINUTELY;INTERVAL=5',
     END_DATE             =>  NULL,
     ENABLED              =>  FALSE,
     AUTO_DROP            =>  FALSE,
     COMMENTS             => 'Los productos Netlife Assistance Pro y NetlifeCloud en estado Pendiente se activan y se registra en el historial del servicio');

  DBMS_SCHEDULER.SET_ATTRIBUTE(NAME      => '"DB_COMERCIAL"."JOB_HISTORIAL_SERV_PLANF"',
                               ATTRIBUTE => 'logging_level',
                               VALUE     =>  DBMS_SCHEDULER.LOGGING_OFF);

  DBMS_SCHEDULER.ENABLE(NAME => '"DB_COMERCIAL"."JOB_HISTORIAL_SERV_PLANF"');

END;
/