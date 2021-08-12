/*
 * Update para el pin.
 */

UPDATE DB_GENERAL.admi_parametro_det
 set valor1 ='Al proporcionar el PIN ratifica firmar digitalmente el ContratoDeAdhesion, aceptando (SI) sus clausulas (Verificar https://netlife.ec/docs/). Si no acepta, firmara contrato fisico. PIN ' 
 where id_parametro_det= 9793;

COMMIT;
/
