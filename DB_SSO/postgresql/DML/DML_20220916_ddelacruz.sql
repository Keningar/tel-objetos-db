/*
 * Debe ejecutarse en esquema Public de SSO
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 16-09-2022 - Versión Inicial.
 */

/** Configuración inicial para el autorizador **/

DO $$
	DECLARE
	    seq_empresa_TN int;
	   	seq_empresa_MD int;
	
BEGIN
	SELECT nextval('seq_admi_empresa')  INTO seq_empresa_TN;
   	SELECT nextval('seq_admi_empresa')  INTO seq_empresa_MD;
    
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

    INSERT INTO public.admi_empresa
	(id_empresa, codigo, nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(seq_empresa_TN, '45ad3d30-bc98-41b4-8d89-ad0cd027f5d0', 'Telconet', 'Activo', 'cas', now(), '127.0.0.1', null, null, null);

    INSERT INTO public.admi_empresa
	(id_empresa, codigo, nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(seq_empresa_MD, '1bb4d948-f3e5-4164-9099-341f370b9243', 'Megadatos', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	
	/**************************************************************************************************************************************/
	/***************************************************OPERACIONES************************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.admi_operacion
	(id_operacion, codigo, descripcion, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_operacion'), '3ce622a3-d1c2-44ca-8059-3e512bf9593f', 'Consumir API REST', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	INSERT INTO public.admi_operacion
	(id_operacion, codigo, descripcion, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_operacion'), 'b8352c1d-decd-499b-bfc0-833ba3f56c33', 'Ver Modulo', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	INSERT INTO public.admi_operacion
	(id_operacion, codigo, descripcion, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_operacion'), '106e3463-dad8-4c3a-9ced-181f5a23ebf9', 'Ver Submodulo', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	INSERT INTO public.admi_operacion
	(id_operacion, codigo, descripcion, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_operacion'), 'c84a61b9-039c-4de8-9a69-c0f35d0224a0', 'Ejecutar accion', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
end $$;
