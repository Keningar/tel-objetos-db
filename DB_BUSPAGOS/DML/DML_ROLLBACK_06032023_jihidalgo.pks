/**
 * DEBE EJECUTARSE EN DB_BUSPAGOS.
 * Rollback para parametrizacion de data para nuevo Canal BcoGuayaquil, BcoProdubanco, BcoPichincha Ecuanet 
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 02/03/2023
 */

DELETE FROM DB_BUSPAGOS.info_config_ent_rec_emp a 
WHERE a.entidad_rec_empresa_id = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'bcoguayaquilen');

DELETE FROM DB_BUSPAGOS.info_entidad_rec_empresa where usuario_bus = 'bcoguayaquilen';

DELETE FROM DB_BUSPAGOS.admi_entidad_recaudadora where codigo = 'bcoguayaquilen';

DELETE FROM DB_BUSPAGOS.info_config_ent_rec_emp a 
WHERE a.entidad_rec_empresa_id = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'bcoprodubancoen');

DELETE FROM DB_BUSPAGOS.info_entidad_rec_empresa where usuario_bus = 'bcoprodubancoen';

DELETE FROM DB_BUSPAGOS.admi_entidad_recaudadora where codigo = 'bcoprodubancoen';

DELETE FROM DB_BUSPAGOS.info_config_ent_rec_emp a 
WHERE a.entidad_rec_empresa_id = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'bcopichinchaen');

DELETE FROM DB_BUSPAGOS.info_entidad_rec_empresa where usuario_bus = 'bcopichinchaen';

DELETE FROM DB_BUSPAGOS.admi_entidad_recaudadora where codigo = 'bcopichinchaen';

COMMIT;
/

