/**
 * DEBE EJECUTARSE EN DB_FINANCIERO.
 * Creacion de Canal de pago BcoGuayaquil, BcoProdubanco, BcoPichincha Ecuanet
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 06/03/2023
 */
INSERT INTO DB_FINANCIERO.admi_canal_pago_linea VALUES (
DB_FINANCIERO.SEQ_ADMI_CANAL_PAGO_LINEA.NEXTVAL,
'17',
'43',
null,
'BI',
'BANCO PICHINCHA ECUANET',
'Activo',
'bcopichinchaen',
'bcopichinchaen',
'P1chNc#@Ne73n',
'jihidalgo',
sysdate,
null,
null
);

INSERT INTO DB_FINANCIERO.admi_canal_pago_linea VALUES (
DB_FINANCIERO.SEQ_ADMI_CANAL_PAGO_LINEA.NEXTVAL,
'17',
'42',
null,
'PR',
'BANCO PRODUBANCO ECUANET',
'Activo',
'bcoprodubancoen',
'bcoprodubancoen',
'3cU@n3tP#08co',
'jihidalgo',
sysdate,
null,
null
);

INSERT INTO DB_FINANCIERO.admi_canal_pago_linea VALUES (
DB_FINANCIERO.SEQ_ADMI_CANAL_PAGO_LINEA.NEXTVAL,
'17',
'3',
null,
'BG',
'BANCO GUAYAQUIL ECUANET',
'Activo',
'bcoguayaquilen',
'bcoguayaquilen',
'8cOGy3ECu4#3723',
'jihidalgo',
sysdate,
null,
null
); 

COMMIT;
/
         
