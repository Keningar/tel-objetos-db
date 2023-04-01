/**
 * DEBE EJECUTARSE EN DB_FINANCIERO.
 * Creacion de Canal de pago Activa Ecuador Ecuanet
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 02/03/2023
 */
INSERT INTO DB_FINANCIERO.admi_canal_pago_linea VALUES (
DB_FINANCIERO.SEQ_ADMI_CANAL_PAGO_LINEA.NEXTVAL,
'17',
'42',
null,
'AE',
'ACTIVA ECUADOR ECUANET',
'Activo',
'activaecuadoren',
'activaecuadoren',
'4ct1v4C#@nn3l3N',
'wdsanchez',
sysdate,
null,
null
); 

COMMIT;
/
         
