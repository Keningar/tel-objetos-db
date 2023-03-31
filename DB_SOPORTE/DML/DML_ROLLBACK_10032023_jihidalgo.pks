/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para rollback de la replica del arbol de hipotesis de Megadatos a Ecuanet.
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 10-03-2023 - Versión Inicial.
 */

DELETE FROM DB_SOPORTE.ADMI_HIPOTESIS WHERE EMPRESA_COD = 33;

COMMIT;

/
