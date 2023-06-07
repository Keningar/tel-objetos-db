/** 
 * @author Edgar Holguín <eholguin@telconet.ec>
 * @version 1.0 
 * @since 25-05-2023
 * Se crea DML de reverso de creación de poarámetros y numeración de facturas proporcionales..
 */

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE PARAMETRO_ID = (SELECT CAB.ID_PARAMETRO
                      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                      WHERE CAB.NOMBRE_PARAMETRO = 'NUMERACION FACTURAS');


DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
 WHERE CAB.NOMBRE_PARAMETRO = 'NUMERACION FACTURAS' 
 AND   CAB.MODULO = 'FINANCIERO';

COMMIT;
/
