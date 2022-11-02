/*
 * Debe ejecutarse en esquema Public de SSO para realizar el rollback
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 02-08-2022 - Versión Inicial.
 */

DROP SEQUENCE seq_admi_empresa; 
DROP SEQUENCE seq_admi_aplicacion; 
DROP SEQUENCE seq_admi_rol; 
DROP SEQUENCE seq_admi_operacion; 
DROP SEQUENCE seq_info_usuario; 
DROP SEQUENCE seq_info_recurso;
DROP SEQUENCE seq_info_permiso; 
DROP SEQUENCE seq_info_rol_permiso; 
DROP SEQUENCE seq_info_contexto; 
DROP SEQUENCE seq_info_delegacion;

DROP TABLE info_delegacion;
DROP TABLE info_contexto;
DROP TABLE info_usuario;
DROP TABLE info_rol_permiso;
DROP TABLE admi_rol;
DROP TABLE info_permiso;
DROP TABLE info_recurso;
DROP TABLE admi_operacion;
DROP TABLE admi_aplicacion;
DROP TABLE admi_empresa;
DROP TABLE shedlock;
