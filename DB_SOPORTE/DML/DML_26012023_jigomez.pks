/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para crear secuencia para obtener numero de casos y evitar error de "constraint unique" por alta concurrencia
 * @author Jorge Gómez <jigomez@telconet.ec>
 * @version 1.0 26-01-2023 - Versión Inicial.
 */

CREATE SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_T MINVALUE 1 MAXVALUE 999999 INCREMENT BY 1 START WITH 1 NOCACHE ORDER NOCYCLE;
CREATE SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_B MINVALUE 1 MAXVALUE 999999 INCREMENT BY 1 START WITH 1 NOCACHE ORDER NOCYCLE;
CREATE SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_M MINVALUE 1 MAXVALUE 999999 INCREMENT BY 1 START WITH 1 NOCACHE ORDER NOCYCLE;
CREATE SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_A MINVALUE 1 MAXVALUE 999999 INCREMENT BY 1 START WITH 1 NOCACHE ORDER NOCYCLE;
