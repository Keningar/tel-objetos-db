/**
 * Documentación para 'JOB_ACTIVAR_NETLIFECLOUD'
 * Job que sirve para Activar los servicios con productos
 * Netlife Assistance Pro, NetlifeCloud y ECOMMERCE BASIC que se encuentren en estado Pendiente.
 * Adicional se envia la notificación de Activación al web-service de konibit.
 *
 * @author Germán Valezuela <gvalenzuela@telconet.ec>
 * @version 1.0 24-06-2021
 */
SET SERVEROUTPUT ON;
SET DEFINE OFF;
BEGIN

  BEGIN
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => '"DB_COMERCIAL"."JOB_ACTIVAR_NETLIFECLOUD"',
                            DEFER    => FALSE,
                            FORCE    => TRUE);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('El job aún no ha sido creado...');
  END;

  DBMS_SCHEDULER.CREATE_JOB (
     JOB_NAME             => '"DB_COMERCIAL"."JOB_ACTIVAR_NETLIFECLOUD"',
     JOB_TYPE             => 'PLSQL_BLOCK',
     JOB_ACTION           => 'BEGIN DB_COMERCIAL.CMKG_ACTIVAR_KONIBIT.P_ACTIVAR_NETLIFECLOUD; END;',
     NUMBER_OF_ARGUMENTS  =>  0,
     START_DATE           =>  NULL,
     REPEAT_INTERVAL      => 'FREQ=DAILY;BYHOUR=22;BYMINUTE=00;BYSECOND=00',
     END_DATE             =>  NULL,
     ENABLED              =>  FALSE,
     AUTO_DROP            =>  FALSE,
     COMMENTS             => 'Los productos Netlife Assistance Pro y NetlifeCloud en estado Pendiente se activan y se registra en el historial del servicio');

  DBMS_SCHEDULER.SET_ATTRIBUTE(NAME      => '"DB_COMERCIAL"."JOB_ACTIVAR_NETLIFECLOUD"',
                               ATTRIBUTE => 'logging_level',
                               VALUE     =>  DBMS_SCHEDULER.LOGGING_OFF);

  DBMS_SCHEDULER.ENABLE(NAME => '"DB_COMERCIAL"."JOB_ACTIVAR_NETLIFECLOUD"');

END;
/
