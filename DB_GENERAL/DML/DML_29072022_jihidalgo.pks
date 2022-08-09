/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones para consumo de WS desde BusPagos
 * VALOR1 = USERNAME
 * VALOR2 = PASSWORD
 * VALOR3 = URL GENERATE TOKEN
 * VALOR4 = URL WS TECNICO TELCOS
 * VALOR5 = OPERACION
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 29-07-2022 - Versión Inicial.
 */
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL, 'BUS_PAGOS', 'PARAMETROS PARA CONSUMO DE WS DESDE BUSPAGOS','TECNICO','BUS_PAGOS','Activo','jihidalgo',SYSDATE,'127.0.0.1', NULL, NULL, NULL);
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'BUS_PAGOS'), 
    'DATA PARA CONSUMO DE WS DESDE BUSPAGOS', 
    'BUSPAGOS', 
    '8u5p4G05', 
    'http://172.24.15.60/ws/token-security/rest/token/authentication', 
    'http://telcos-ws-lb.telconet.ec/rs/tecnico/ws/rest/procesar', 
    'Activo', 
    'jihidalgo', 
    SYSDATE, 
    '127.0.0.1', 
    NULL, 
    NULL, 
    NULL, 
    'callJarReactivacion', 
    18, 
    NULL, 
    NULL, 
    NULL
);

COMMIT;
/