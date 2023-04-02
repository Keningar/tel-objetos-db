/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Rollback del progreso porcentaje  para la empresa ecuanet.
 * @author Emmanuel Martillo<emartillo@telconet.ec>
 * @version 1.0 01-03-2023 - Versión Inicial.
 */

DELETE FROM DB_SOPORTE.INFO_PROGRESO_PORCENTAJE
WHERE ORDEN IN ('4','6','7','8','11')
AND EMPRESA_ID = '33'
AND USR_CREACION = 'admin';


COMMIT;
/
