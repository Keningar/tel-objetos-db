/**
 * DEBE EJECUTARSE EN DB_BUSPAGOS.
 * Rollback para parametrizacion de URL para consumo de WSDL 
 *
 * @author Milen Ortega <mortega1@telconet.ec>
 * @version 1.0 28/12/2022
 */

DELETE FROM DB_BUSPAGOS.info_config_ent_rec_emp WHERE PARAMETRO = 'URL_CONCILIACION_WSDL_PROXY' ;

COMMIT;
/