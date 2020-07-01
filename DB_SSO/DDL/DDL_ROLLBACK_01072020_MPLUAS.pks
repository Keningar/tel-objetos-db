/**
 * DEBE EJECUTARSE EN DB_SSO.
 * @author Marlon Plúas <mpluas@telconet.ec>
 * @version 1.0 01-07-2020 - Versión Inicial.
 */

DROP SEQUENCE DB_SSO.SEQ_REGX_REGIS_SERVICE; 
DROP SEQUENCE DB_SSO.SEQ_REGX_REGIS_SERVICE_PRO; 
DROP SEQUENCE DB_SSO.SEQ_REGIS_SERVICE_IMP_CONT; 

DROP TABLE DB_SSO.ADMI_SERVICIO_SSO PURGE; 

DROP INDEX DB_SSO.IDX_NOMBRE_SERVICIO;
DROP INDEX DB_SSO.IDX_ESTADO;
DROP INDEX DB_SSO.IDX_FE_CREACION_ASC;
DROP INDEX DB_SSO.IDX_FE_CREACION_DESC;

DROP SEQUENCE DB_SSO.SEQ_ADMI_SERVICIO_SSO;

/
