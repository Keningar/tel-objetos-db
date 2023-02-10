/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para rollback de la creación de secuencia para obtener numero de casos y evitar error de "constraint unique" por alta concurrencia
 * @author Jorge Gómez <jigomez@telconet.ec>
 * @version 1.0 26-01-2023 - Versión Inicial.
 */

DROP SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_T;
DROP SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_B;
DROP SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_M;
DROP SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_A;
