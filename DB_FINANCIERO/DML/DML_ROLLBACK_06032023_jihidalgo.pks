/**
 * DEBE EJECUTARSE EN DB_FINANCIERO.
 * Rollback para creacion de Canal BcoGuayaquil, BcoProdubanco, BcoPichincha Ecuanet 
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 06/03/2023
 */

DELETE FROM DB_FINANCIERO.admi_canal_pago_linea WHERE USUARIO_CANAL_PAGO_LINEA = 'bcopichinchaen';
DELETE FROM DB_FINANCIERO.admi_canal_pago_linea WHERE USUARIO_CANAL_PAGO_LINEA = 'bcoprodubancoen';
DELETE FROM DB_FINANCIERO.admi_canal_pago_linea WHERE USUARIO_CANAL_PAGO_LINEA = 'bcoguayaquilen';

COMMIT;
/

