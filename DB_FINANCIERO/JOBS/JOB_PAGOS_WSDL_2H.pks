/**
 * Documentación para 'JOB_PAGOS_WSDL_2H'
 * Job que sirve para Conciliar o Reversar pagos en canal Activaecuador
 * Se ejecuta cada 2h verificando los pagos retornados por el WSDL y los que se registran en el BusPagos
 *
* @author Milen Ortega <mortega1@telconet.ec>
* @version 1.0 28/12/2022
*/ 
SET SERVEROUTPUT ON;
SET DEFINE OFF;
BEGIN

  BEGIN
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => '"DB_FINANCIERO"."JOB_PAGOS_WSDL_2H"',
                            DEFER    => FALSE,
                            FORCE    => TRUE);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('El job aún no ha sido creado...');
  END;

  DBMS_SCHEDULER.CREATE_JOB (
     JOB_NAME             => '"DB_FINANCIERO"."JOB_PAGOS_WSDL_2H"',
     JOB_TYPE             => 'PLSQL_BLOCK',
     JOB_ACTION           => 'BEGIN DB_FINANCIERO.FNCK_PAGOS_LINEA.P_CONCILIAR_PAGO_WSDL; END;',
     NUMBER_OF_ARGUMENTS  =>  0,
     START_DATE           =>  NULL,
     REPEAT_INTERVAL      => 'FREQ=DAILY;BYHOUR=6,8,10,12,14,16,18,20,22;BYMINUTE= 30;',
     END_DATE             =>  NULL,
     ENABLED              =>  FALSE,
     AUTO_DROP            =>  FALSE,
     COMMENTS             => 'Conciliacion de BusPagos cada 2h con llamado a servicio WSDL de canal Activaecuador');

  DBMS_SCHEDULER.SET_ATTRIBUTE(NAME      => '"DB_FINANCIERO"."JOB_PAGOS_WSDL_2H"',
                               ATTRIBUTE => 'logging_level',
                               VALUE     =>  DBMS_SCHEDULER.LOGGING_OFF);

  DBMS_SCHEDULER.ENABLE(NAME => '"DB_FINANCIERO"."JOB_PAGOS_WSDL_2H"');

END;
/