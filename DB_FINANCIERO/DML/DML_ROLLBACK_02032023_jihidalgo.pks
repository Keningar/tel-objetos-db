/**
 * DEBE EJECUTARSE EN DB_FINANCIERO.
 * Rollback para creacion de Canal Activa Ecuador Ecuanet 
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 02/03/2023
 */

DELETE FROM DB_FINANCIERO.admi_canal_pago_linea WHERE USUARIO_CANAL_PAGO_LINEA = 'activaecuadoren';

COMMIT;
/

