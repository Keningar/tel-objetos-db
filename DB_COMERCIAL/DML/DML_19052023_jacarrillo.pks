
/**
 * Regularización de cliente con tipo_identificacion incorrecta
 * @author Jefferson Alexy Carrillo<jcarrillo@telconet.ec>
 * @version 1.0 19-05-2023 - Versión Inicial.
 */

UPDATE  db_comercial.info_persona 
SET tipo_identificacion ='RUC'
WHERE (tipo_identificacion ='CED'AND LENGTH(identificacion_cliente)=13 )  


 COMMIT;
/
 