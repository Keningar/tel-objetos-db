/**
 * DEBE EJECUTARSE EN DB_BUSPAGOS.
 * Parametrizacion de URL para consumo de WSDL 
 *
 * @author Milen Ortega <mortega1@telconet.ec>
 * @version 1.0 28/12/2022
 */

INSERT INTO DB_BUSPAGOS.info_config_ent_rec_emp(ID_CONFIG_ENT_REC_EMP, fe_creacion, IP_CREACION , USR_CREACION, ENTIDAD_REC_EMPRESA_ID, PARAMETRO, VALOR, ESTADO)
VALUES (DB_BUSPAGOS.SEQ_INFO_CONFIG_ENT_REC_EMP.NEXTVAL, sysdate, '127.0.0.1','mortega1', 141, 'URL_CONCILIACION_WSDL_PROXY', 'http://telcos-ws-ext-lb.telconet.ec/redesactiva/ActivaTransferSystem/Collection/NETLIFE_Cobranzas.asmx', 'Activo');

COMMIT;
/