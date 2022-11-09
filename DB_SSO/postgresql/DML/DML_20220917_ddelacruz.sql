/*
 * Debe ejecutarse en esquema Public de SSO
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 17-09-2022 - Versión Inicial.
 */

/** Configuración de Extranet para el autorizador **/

DO $$
	DECLARE
	    seq_aplicacion_EXTRANET int;
        url_dominio_EXTRANET varchar(200) = 'https://telconetcontigo.telconet.ec/';
BEGIN

   	SELECT nextval('seq_admi_aplicacion')  INTO seq_aplicacion_EXTRANET;
    
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.admi_aplicacion
	(id_aplicacion, codigo, empresa_id, nombre, url_dominio, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(seq_aplicacion_EXTRANET, '38b386fd-a7a1-48d3-8689-cc78134c590b', (select id_empresa  from admi_empresa ae where ae.codigo  = '45ad3d30-bc98-41b4-8d89-ad0cd027f5d0'), 'Extranet TN', url_dominio_EXTRANET, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	/**************************************************************************************************************************************/
	/********************************************************ROLES*************************************************************************/

	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '02579cca-f768-42b9-ba4c-1ae88cc8115f', 'SuperAdmin', seq_aplicacion_EXTRANET, NULL, 'Rol de Empleado Telconet con privilegios para administrar usuarios', 'N', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
		
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '843d0751-6a4b-4135-b86b-edf9c3b826e5', 'GestorInterno', seq_aplicacion_EXTRANET, NULL, 'Rol de Empleado Telconet con privilegios de gestor de contenido', 'N', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079', 'AdministradorExterno', seq_aplicacion_EXTRANET, NULL, 'Rol de Cliente Telconet con privilegios de administrador', 'S', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), 'b8ea31c8-2b1a-4be8-a91a-d147019b7730', 'Externo', seq_aplicacion_EXTRANET, NULL, 'Rol de Cliente Telconet con privilegios inferior al AdministradorExterno', 'S', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), 'a5e68104-4372-45c6-91f9-4eb85779b9de', 'Aplicacion', seq_aplicacion_EXTRANET, NULL, 'Rol con privilegios de aplicación', 'N', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	/**************************************************************************************************************************************/
	/***************************************************RECURSOS EXTRANET******************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '878fc8b5-e80d-4833-9f53-5058795df454', 'Api para crear usuario con roles de SuperAdmin y AdministradorExterno en Extranet TN', '/federated-entity/crearCuentaAdmin', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'da6fba65-a38e-4318-b5f9-8b9df0f60fa0', 'Api para crear usuario con rol GestorInterno en Extranet TN', '/federated-entity/crearCuentaEmpleado', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'dff86b75-4166-4f74-92b5-a640ddb6cd51', 'Api para crear usuario con rol Externo en Extranet TN', '/federated-entity/crearCuentaEmpleadoCliente', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a04d72c2-9b3f-4cbd-baf2-359ed475eba1', 'Api para consultar usuario con perfiles en Extranet TN', '/federated-entity/consultarCuenta', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'aea3edfd-02e9-44fd-a476-6b5c244beee9', 'Api para consultar usuarios con perfiles según filtros en Extranet TN', '/federated-entity/listadoMisCuentas', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
    INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '33148da9-8c88-4022-ad42-b0cbb353b895', 'Api para consultar usuarios con perfiles según filtros en Extranet TN, por cada empresa', '/federated-entity/listadoCuentasPorEmpresa', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '9440db3a-6ec7-49c0-bd9e-b5bca3cd0eec', 'Api para actualizar estado del usuario en Extranet TN', '/federated-entity/actualizarEstado', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'ea99ce91-cf8f-4150-b79d-2594d4fdc5df', 'Api para actualizar estado de una cuenta del usuario en Extranet TN desde un rol SuperAdmin', '/federated-entity/actualizarEstadoCuentas', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'dc218e9c-8a8f-4ace-bf22-b2e3d9dd7d6b', 'Api para consultar lista de empresas clientes de Telconet en Extranet TN', '/federated-entity/listadoEmpresa', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0bce5c19-fd5d-4bb7-9860-bedea1dd369d', 'Api para consultar lista de empresas clientes de Telconet que son Holding en Extranet TN', '/federated-entity/listadoHolding', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '511043ca-dbab-4876-9c15-a6b926372acc', 'Api para consultar lista de empleados de Telconet en Extranet TN', '/federated-entity/listadoEmpleados', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0d67e9e7-9d35-40cd-8dcd-1cf6d5383731', 'Api para consultar datos del username (login) en Extranet TN', '/federated-entity/login', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '5283433b-93b3-462b-9048-682af2bdf345', 'Api para validar password en Extranet TN', '/federated-entity/validarPassword', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f80ecd9d-2431-48c6-a8c1-bb59dcbffa2d', 'Api para actualizar password en Extranet TN', '/federated-entity/actualizarPassword', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
		
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'ceecc40b-983f-4903-93aa-217a32d0361c', 'Api para enviar email para reseteo de contraseña a usuario en Extranet TN', '/federated-entity/emailChangePass', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '404d50c8-9399-4e89-abd0-d1e15ce31b75', 'Api para actualizar Términos y Condiciones a usuario en Extranet TN', '/federated-entity/actualizarTerminosCondiciones', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '603ac4c0-aef7-4f7b-bc6d-0e4bdc3d7442', 'Api para consultar Topicos del Chat en Extranet TN', '/communication/consultarTopicos', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a67f3701-2767-436a-9469-6b8e9fb72b38', 'Api para crear Topico del Chat en Extranet TN', '/communication/crearTopico', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '80db2109-632d-4afd-b00c-b92dc72a5888', 'Api para actualizar Topico del Chat en Extranet TN', '/communication/actualizarTopico', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd73815f9-b218-4b1f-9036-84a116f787fb', 'Api para eliminar Topico del Chat en Extranet TN', '/communication/eliminarTopic', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '37c93b92-5523-4e90-a11b-04407b4a30d1', 'Api para actualizar mensaje para un Topico del Chat en Extranet TN', '/communication/actualizarMensaje', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b99dc078-4e90-4d5b-b479-8dd4072ad12b', 'Api para consultar mensaje para un Topico del Chat en Extranet TN', '/communication/consultarMensaje', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'be05b8f1-b57c-443a-922a-4c65ab909858', 'Api para crear mensaje para un Topico del Chat en Extranet TN', '/communication/crearMensaje', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e3f40357-94ba-479b-b821-665b37021dcc', 'Api para eliminar mensaje para un Topico del Chat en Extranet TN', '/communication/eliminarMensaje', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '01531f6c-c0b3-476b-8516-5365a7005588', 'Api para actualizar parámetro en Extranet TN', '/communication/actualizarCustomValue', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'eb14d25a-894b-4c20-8914-32b03b21180a', 'Api para consultar parámetro en Extranet TN', '/communication/consultarCustomValue', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6f71c9d9-c8c9-4af4-89f6-8dbd359cb00d', 'Api para crear parámetro en Extranet TN', '/communication/crearCustomValue', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f3f98fb1-a13c-410a-9dfd-0085ed848aee', 'Api para eliminar parámetro en Extranet TN', '/communication/eliminarCustomValue', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '70ec606e-f46d-4c6d-a086-0ef4ccf7a29c', 'Api para actualizar publicación en Extranet TN', '/communication/actualizarPublicacion', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e38dffed-ed97-4c97-b8d2-6c6a6fd5ee01', 'Api para eliminar publicación en Extranet TN', '/communication/eliminarPublicacion', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '9ad10cc8-dcc7-4d69-889f-8a8eedbc670f', 'Api para crear publicación en Extranet TN', '/communication/crearPublicacion', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'fc70ab5b-f36a-4f8f-8cd8-dea5b88d8470', 'Api para consultar publicación en Extranet TN', '/communication/consultaPublicacion', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'da41e048-b483-4ecc-9b74-3e25ffeb7402', 'Api para suscribir usuario para notificaciones push en Extranet TN', '/communication/crearSuscripcionNotificacion', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '16ca8076-89de-4dc2-846f-5daac88f6906', 'Api para actualizar documento para Extranet TN', '/document-management/actualizarDocumento', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '5f947267-b689-4092-87a1-c377e2414c2e', 'Api para borrar documento para Extranet TN', '/document-management/borrarDocumento', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '984a6989-eedd-4c11-9592-1b1adae11552', 'Api para crear documento para Extranet TN', '/document-management/crearDocumento', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '4b4fafa3-609c-4ef3-9ac1-c0fdd978c4e8', 'Api para consultar documentos según filtros para Extranet TN', '/document-management/consultarDocumentosPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'cabddefa-9ac2-43a1-8487-9415966dac2c', 'Api para consultar información resumida del cliente para Extranet TN', '/customer-management/consolidatedPosition', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e37271a4-c4eb-4fca-902f-1d200effae06', 'Api para consultar contactos del cliente según filtros para Extranet TN', '/customer-management/listarContactosPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'aa533d49-6e2c-4679-8748-c245e0fe1632', 'Api para crear contacto del cliente para Extranet TN', '/customer-management/crearContacto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '4d2d5fd3-48ae-4681-90b4-d3dd68cd9d43', 'Api para actualizar contacto del cliente para Extranet TN', '/customer-management/actualizarContacto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '152ddc80-b6a9-4654-a4a8-652c3a9b40ec', 'Api para borrar contacto del cliente para Extranet TN', '/customer-management/borrarContacto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e2cfb33a-4bac-4a4c-bce0-afe6cb83e8c3', 'Api para consultar contactos asignados de Telconet para el cliente para Extranet TN', '/customer-management/listarContactosTelconetPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '88966cf3-4694-40fc-b09a-f65f503fb52d', 'Api para consultar contactos de Telconet para Extranet TN', '/customer-management/consultaContactosEmpresa', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '99fdb14f-e7a2-4a91-a5a9-fd06a31e32e2', 'Api para actualizar nickname de un punto para Extranet TN', '/customer-management/actualizarNickname', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '3c5ab839-7b42-4f86-8983-4c2ca5bef222', 'Api para borrar nickname de un punto para Extranet TN', '/customer-management/borrarNickname', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '82e9c6d5-e2bf-4783-b744-548889474f22', 'Api para crear nickname de un punto para Extranet TN', '/customer-management/crearNickname', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '19c132a0-81c3-49f4-ad0e-72b774b52c4c', 'Api para obtener nickname de un punto para Extranet TN', '/customer-management/obtenerNickname', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '32c668e3-a94b-432b-977f-773237915f6b', 'Api para consultar puntos para Extranet TN', '/customer-management/points', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '139fc119-5369-4471-aa80-daced053cf64', 'Api para consultar servicios por Punto para Extranet TN', '/customer-management/serviciosPorPunto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'db80d388-38a8-42f2-a826-1f05d5bfc47a', 'Api para consultar estado de servicios por Punto para Extranet TN', '/customer-management/estadoServiciosPorPunto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '3ef6bfaa-5da7-4f67-85fc-8492e0d4309c', 'Api para consultar motivo del estado del servicio por Punto para Extranet TN', '/customer-management/motivo/bind', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '73f1db23-5207-46e0-becc-3e3eb4d4d490', 'Api para consultar facturas según filtro para Extranet TN', '/customer-billing/listadoFacturasPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '49a1d803-41eb-4385-be60-2fc7fe339948', 'Api para descargar facturas para Extranet TN', '/customer-billing/descargaFactura', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6026d796-8adb-4a62-bc35-38a63a340824', 'Api para generar estado de cuenta para Extranet TN', '/customer-billing/generarEstadoCuenta', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '36e6f52d-41f3-416a-8a2f-97d920f6f814', 'Api para consultar provincias para Extranet TN', '/geographic-location/provincias', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '44214849-c32c-4ce2-b2ae-357d70b77a89', 'Api para consultar cantones para Extranet TN', '/geographic-location/cantones', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '9a720f04-0759-4580-b853-8a78453ba043', 'Api para consultar parroquias para Extranet TN', '/geographic-location/parroquias', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f647ba86-f479-4fab-b79a-22e6f20762fc', 'Api para consultar requerimientos (tareas) para Extranet TN', '/trouble-ticket/consultarRequerimientosPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '8d809333-85f1-43f4-b2b6-56a182d04624', 'Api para crear requerimiento (tarea) para Extranet TN', '/trouble-ticket/crearRequerimiento', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '951826a8-cdb0-4cca-ac1d-68bb95e2f1e7', 'Api para crear ticket (caso) para Extranet TN', '/trouble-ticket/crearTicket', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '928e1ac2-9b8f-41a9-a88b-4d51dcaf069b', 'Api para consultar tickets (casos) para Extranet TN', '/trouble-ticket/consultarTicketsPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'cd16b661-cf22-4be2-97cb-787f81396607', 'Api para consultar tickets (casos) en proceso para Extranet TN', '/trouble-ticket/consultarTicketsEnProceso', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '935bc13c-a3c6-4909-9511-0abdf78411f2', 'Api para consultar tickets (casos) en proceso por Punto para Extranet TN', '/trouble-ticket/consultarTicketsEnProcesoPorPunto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6819c371-aeab-4765-b2ea-2630f1091c58', 'Api para validar datos en Datafast y mostrar modal para ingresar pago para Extranet TN', '/payment-management/checkout', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '8750fc64-2069-496f-afc1-8f27307ff770', 'Api para consultar deuda de un cliente para Extranet TN', '/payment-management/consultarDeuda', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'af57988d-c311-4bf3-9f0b-0de2916aa949', 'Api para validar pago de un cliente para Extranet TN', '/payment-management/validarPago', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	/**************************************************************************************************************************************/
	/***************************************************PERMISOS EXTRANET******************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'8edf7e98-8b0e-4f12-8efe-8d51eb017cee',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '878fc8b5-e80d-4833-9f53-5058795df454'),'Permiso para crear cuenta SuperAdmin o AdministradorExterno','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'a773686d-7e3c-4e63-8997-f2ab9d1d2905',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'da6fba65-a38e-4318-b5f9-8b9df0f60fa0'),'Permiso para crear cuenta GestorInterno','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e9f069a0-b884-4236-a980-100c413688d3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'dff86b75-4166-4f74-92b5-a640ddb6cd51'),'Permiso para crear cuenta Externo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4f5d5fc3-e403-4535-8797-ab70b49cbe40',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a04d72c2-9b3f-4cbd-baf2-359ed475eba1'),'Permiso para consultar cuenta','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'97e1f1ec-1312-4c72-bc63-2cbbba47b419',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'aea3edfd-02e9-44fd-a476-6b5c244beee9'),'Permiso para consultar cuentas según filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'11bef008-cee5-412e-b796-b27053d1937d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '33148da9-8c88-4022-ad42-b0cbb353b895'),'Permiso para consultar cuentas según filtros, por empresas','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'df6be120-b072-4740-a77f-8f56d450f643',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '9440db3a-6ec7-49c0-bd9e-b5bca3cd0eec'),'Permiso para actualizar estado','Activo','cas', now(),'127.0.0.1',null,null,null);
		
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'3bd45653-ed4c-44ad-8acb-1b2c6230b794',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'ea99ce91-cf8f-4150-b79d-2594d4fdc5df'),'Permiso para actualizar estado desde un rol SuperAdmin','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'82bdc9a8-67cf-4a43-b977-13b1fd3c30d6',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'dc218e9c-8a8f-4ace-bf22-b2e3d9dd7d6b'),'Permiso para listar empresas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5ef4b982-4f92-4881-980c-5392a2fdee95',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0bce5c19-fd5d-4bb7-9860-bedea1dd369d'),'Permiso para listar holding','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9c2cb9f8-f20c-43e9-a2e0-2fe4529cece5',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '511043ca-dbab-4876-9c15-a6b926372acc'),'Permiso para listar empleados','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'bdb89448-1ada-4be9-b4ed-c4626627f3f3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0d67e9e7-9d35-40cd-8dcd-1cf6d5383731'),'Permiso para realizar login','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c2a1784e-e59b-47e7-99aa-0c1b92577e7a',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '5283433b-93b3-462b-9048-682af2bdf345'),'Permiso para validar password','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e764de6d-f30a-438a-990a-b1e61ba1e665',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f80ecd9d-2431-48c6-a8c1-bb59dcbffa2d'),'Permiso para actualizar password','Activo','cas', now(),'127.0.0.1',null,null,null);
		
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'106548a4-ad1f-4f05-8566-2c6a1330c14e',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'ceecc40b-983f-4903-93aa-217a32d0361c'),'Permiso para enviar email para reseteo de password','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'7c8f85af-019f-4d46-b63d-fa253083d983',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '404d50c8-9399-4e89-abd0-d1e15ce31b75'),'Permiso para actualizar términos y condiciones','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5eb4d673-7663-4f49-ba21-45f7ab7b360b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '603ac4c0-aef7-4f7b-bc6d-0e4bdc3d7442'),'Permiso para consultar topicos','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'6390aff7-4445-487c-b7ab-51c66cad5e4a',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a67f3701-2767-436a-9469-6b8e9fb72b38'),'Permiso para crear topico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'84fce2e8-2ecd-4447-ad8f-718dc0308799',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '80db2109-632d-4afd-b00c-b92dc72a5888'),'Permiso para actualizar topico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f8fec167-f382-4ebf-bf1e-d607a6135a5f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd73815f9-b218-4b1f-9036-84a116f787fb'),'Permiso para eliminar topico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9b3b58c9-9948-4d2d-babd-ddeeffc84a2c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '37c93b92-5523-4e90-a11b-04407b4a30d1'),'Permiso para actualizar mensaje','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'00c783df-2a9e-4f5f-a15f-b5beef20a8eb',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b99dc078-4e90-4d5b-b479-8dd4072ad12b'),'Permiso para consultar mensaje','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'a08e1795-03ad-4aa7-86bd-dd843ea0473c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'be05b8f1-b57c-443a-922a-4c65ab909858'),'Permiso para crear mensaje','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'98d5dcb7-557a-4f28-8dcb-bdb21151e009',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e3f40357-94ba-479b-b821-665b37021dcc'),'Permiso para eliminar mensaje','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'1e92b612-409f-4c61-a9a1-0c7ebec7a1a8',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '01531f6c-c0b3-476b-8516-5365a7005588'),'Permiso para actualizar parámetro','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4ea76fe4-5af8-4eb6-8aa8-6e9d2e95f5d8',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'eb14d25a-894b-4c20-8914-32b03b21180a'),'Permiso para consultar parámetro','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ac3fff5f-5be7-43d4-a6b1-6de50b53a6b4',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6f71c9d9-c8c9-4af4-89f6-8dbd359cb00d'),'Permiso para crear parámetro','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'71a58c0e-cde9-4aa9-8af8-84dcb527fd3d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f3f98fb1-a13c-410a-9dfd-0085ed848aee'),'Permiso para eliminar parámetro','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'dc2c7d6b-22b9-481f-aba1-bed5bbfe187d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '70ec606e-f46d-4c6d-a086-0ef4ccf7a29c'),'Permiso para actualizar publicación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'66db2b02-fbae-4b92-8cd4-073362b17acd',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e38dffed-ed97-4c97-b8d2-6c6a6fd5ee01'),'Permiso para eliminar publicación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c7a8da74-819c-400a-a881-7cf9a538550f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '9ad10cc8-dcc7-4d69-889f-8a8eedbc670f'),'Permiso para crear publicación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4c4ced3c-2308-4bec-aadd-5b50b4e23cc0',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'fc70ab5b-f36a-4f8f-8cd8-dea5b88d8470'),'Permiso para consultar publicación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e73e9b66-b65c-4e43-85d9-6df8ab8469dc',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'da41e048-b483-4ecc-9b74-3e25ffeb7402'),'Permiso para suscribir dispositivo de usuario para notificaciones push','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'6d06e654-45f8-4fbe-853b-bd12660f5a2f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '16ca8076-89de-4dc2-846f-5daac88f6906'),'Permiso para actualizar documento','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'833fd33c-a54e-4245-a089-6f5d25d32544',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '5f947267-b689-4092-87a1-c377e2414c2e'),'Permiso para eliminar documento','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'8b26c0ef-c1a9-41bf-9c17-24fb4da0beeb',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '984a6989-eedd-4c11-9592-1b1adae11552'),'Permiso para crear documento','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e0f9efcb-c552-4775-a0d6-d5e4ce093dc3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '4b4fafa3-609c-4ef3-9ac1-c0fdd978c4e8'),'Permiso para consultar documentos','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'cdd1130d-a077-4c47-8f0e-64e8be29a1a9',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'cabddefa-9ac2-43a1-8487-9415966dac2c'),'Permiso para consultar información resumida del cliente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'074d4fc4-6d48-44df-809c-258beced2aa9',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e37271a4-c4eb-4fca-902f-1d200effae06'),'Permiso para consultar contactos del cliente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'7343a1e1-1683-4f46-8e42-ed0b63393b8c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'aa533d49-6e2c-4679-8748-c245e0fe1632'),'Permiso para crear contacto del cliente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'adb95dcf-e98b-48b9-bb60-34be36edf9d2',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '4d2d5fd3-48ae-4681-90b4-d3dd68cd9d43'),'Permiso para actualizar contacto del cliente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f94d07ee-1bca-4c24-904d-b3adf6972d81',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '152ddc80-b6a9-4654-a4a8-652c3a9b40ec'),'Permiso para eliminar contacto del cliente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'cc30e295-5e53-4b9e-ae7b-6836db27fd01',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e2cfb33a-4bac-4a4c-bce0-afe6cb83e8c3'),'Permiso para listar contactos de Telconet','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ed7fddcf-3384-45dd-9026-f7ba13eb3633',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '88966cf3-4694-40fc-b09a-f65f503fb52d'),'Permiso para consultar contactos de empresa','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'541c248d-ce2a-4708-b193-6be4c26dbdc5',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '99fdb14f-e7a2-4a91-a5a9-fd06a31e32e2'),'Permiso para actualizar nickname','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'13bdf2d3-b364-47be-9577-1f3f2c84ffe5',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '3c5ab839-7b42-4f86-8983-4c2ca5bef222'),'Permiso para eliminar nickname','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f1df8aa0-047d-4d40-a644-3f3632556ec7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '82e9c6d5-e2bf-4783-b744-548889474f22'),'Permiso para crear nickname','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'8af7c4b8-d166-4b44-8e2b-3cad126007b7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '19c132a0-81c3-49f4-ad0e-72b774b52c4c'),'Permiso para consultar nickname','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'0db3c82b-f6d7-483e-afb1-29d3b2a3fcf7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '32c668e3-a94b-432b-977f-773237915f6b'),'Permiso para consultar puntos','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'019b427e-eb85-44b4-b096-1d24afb164ca',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '139fc119-5369-4471-aa80-daced053cf64'),'Permiso para consultar servicios por punto','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'cfa16802-d6f4-42ea-904a-a34d521c001c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'db80d388-38a8-42f2-a826-1f05d5bfc47a'),'Permiso para consultar estado de servicios por punto','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ea52b2a1-fb7c-46ec-a2af-4e157aa6446e',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '3ef6bfaa-5da7-4f67-85fc-8492e0d4309c'),'Permiso para consultar motivo de estado de servicio','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d6dca8c3-c4da-4468-b510-dd857c80867d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '73f1db23-5207-46e0-becc-3e3eb4d4d490'),'Permiso para consultar facturas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f06ffddc-d280-4189-abd4-26522d610121',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '49a1d803-41eb-4385-be60-2fc7fe339948'),'Permiso para descargar facturas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'2bd749ec-833a-46af-b80f-252dffab3519',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6026d796-8adb-4a62-bc35-38a63a340824'),'Permiso para generar estado de cuenta','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4065f0d2-09ee-48ed-bda6-66e037973289',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '36e6f52d-41f3-416a-8a2f-97d920f6f814'),'Permiso para consultar provincias','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'bdda1d9a-5fc4-43ca-b81d-9a337d85fbcb',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '44214849-c32c-4ce2-b2ae-357d70b77a89'),'Permiso para consultar cantones','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d8103b06-10fa-4364-babe-f7b1058631b7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '9a720f04-0759-4580-b853-8a78453ba043'),'Permiso para consultar parroquias','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5de6032e-bdb9-44d3-9466-ea004043cd30',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f647ba86-f479-4fab-b79a-22e6f20762fc'),'Permiso para consultar requerimientos','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ed5faeaa-5bbb-4d44-9559-275e89931263',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '8d809333-85f1-43f4-b2b6-56a182d04624'),'Permiso para crear requerimiento','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'b37806e2-6813-49e3-ae4a-82f9e837765f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '951826a8-cdb0-4cca-ac1d-68bb95e2f1e7'),'Permiso para crear ticket','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'1c382647-96f9-43cd-9b5f-6461c46c819c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '928e1ac2-9b8f-41a9-a88b-4d51dcaf069b'),'Permiso para consultar tickets','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'af910ead-96e0-438d-9bfe-07010d130ffa',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'cd16b661-cf22-4be2-97cb-787f81396607'),'Permiso para consultar tickets en proceso','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'36199890-aa76-4114-92ab-aa1cd11f96de',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '935bc13c-a3c6-4909-9511-0abdf78411f2'),'Permiso para consultar tickets en proceso por punto','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'deba77cd-c875-400d-a28c-0a15137fbb8b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6819c371-aeab-4765-b2ea-2630f1091c58'),'Permiso para validar datos en datafast','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'53da41b0-849f-47a5-a651-5b422a0ac5d3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '8750fc64-2069-496f-afc1-8f27307ff770'),'Permiso para consultar deuda','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'24e37ba9-b38c-4c5a-9571-364ccfcf424b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'af57988d-c311-4bf3-9f0b-0de2916aa949'),'Permiso para validar pago','Activo','cas', now(),'127.0.0.1',null,null,null);

	/**************************************************************************************************************************************/
	/***************************************************ASIGNACION DE PERMISOS A ROLES EXTRANET********************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	/**ROL SuperAdmin**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'a773686d-7e3c-4e63-8997-f2ab9d1d2905'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4f5d5fc3-e403-4535-8797-ab70b49cbe40'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '97e1f1ec-1312-4c72-bc63-2cbbba47b419'),'Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '11bef008-cee5-412e-b796-b27053d1937d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'df6be120-b072-4740-a77f-8f56d450f643'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '82bdc9a8-67cf-4a43-b977-13b1fd3c30d6'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5ef4b982-4f92-4881-980c-5392a2fdee95'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9c2cb9f8-f20c-43e9-a2e0-2fe4529cece5'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'bdb89448-1ada-4be9-b4ed-c4626627f3f3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '1e92b612-409f-4c61-a9a1-0c7ebec7a1a8'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4ea76fe4-5af8-4eb6-8aa8-6e9d2e95f5d8'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ac3fff5f-5be7-43d4-a6b1-6de50b53a6b4'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '71a58c0e-cde9-4aa9-8af8-84dcb527fd3d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e764de6d-f30a-438a-990a-b1e61ba1e665'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f'),(select ip.id_permiso from info_permiso ip where ip.codigo = '106548a4-ad1f-4f05-8566-2c6a1330c14e'),'Activo','cas', now(),'127.0.0.1',null,null,null);


	/**ROL GestorInterno**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'dc2c7d6b-22b9-481f-aba1-bed5bbfe187d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '66db2b02-fbae-4b92-8cd4-073362b17acd'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'c7a8da74-819c-400a-a881-7cf9a538550f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4c4ced3c-2308-4bec-aadd-5b50b4e23cc0'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '6d06e654-45f8-4fbe-853b-bd12660f5a2f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '833fd33c-a54e-4245-a089-6f5d25d32544'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '8b26c0ef-c1a9-41bf-9c17-24fb4da0beeb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e0f9efcb-c552-4775-a0d6-d5e4ce093dc3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'bdb89448-1ada-4be9-b4ed-c4626627f3f3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '82bdc9a8-67cf-4a43-b977-13b1fd3c30d6'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4ea76fe4-5af8-4eb6-8aa8-6e9d2e95f5d8'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e764de6d-f30a-438a-990a-b1e61ba1e665'),'Activo','cas', now(),'127.0.0.1',null,null,null);
    
    /**ROL AdministradorExterno**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'cdd1130d-a077-4c47-8f0e-64e8be29a1a9'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '074d4fc4-6d48-44df-809c-258beced2aa9'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '7343a1e1-1683-4f46-8e42-ed0b63393b8c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'adb95dcf-e98b-48b9-bb60-34be36edf9d2'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f94d07ee-1bca-4c24-904d-b3adf6972d81'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'cc30e295-5e53-4b9e-ae7b-6836db27fd01'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ed7fddcf-3384-45dd-9026-f7ba13eb3633'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '541c248d-ce2a-4708-b193-6be4c26dbdc5'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '13bdf2d3-b364-47be-9577-1f3f2c84ffe5'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f1df8aa0-047d-4d40-a644-3f3632556ec7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '8af7c4b8-d166-4b44-8e2b-3cad126007b7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '0db3c82b-f6d7-483e-afb1-29d3b2a3fcf7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '019b427e-eb85-44b4-b096-1d24afb164ca'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'cfa16802-d6f4-42ea-904a-a34d521c001c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ea52b2a1-fb7c-46ec-a2af-4e157aa6446e'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'd6dca8c3-c4da-4468-b510-dd857c80867d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f06ffddc-d280-4189-abd4-26522d610121'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '2bd749ec-833a-46af-b80f-252dffab3519'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4065f0d2-09ee-48ed-bda6-66e037973289'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'bdda1d9a-5fc4-43ca-b81d-9a337d85fbcb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'd8103b06-10fa-4364-babe-f7b1058631b7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5de6032e-bdb9-44d3-9466-ea004043cd30'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ed5faeaa-5bbb-4d44-9559-275e89931263'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'b37806e2-6813-49e3-ae4a-82f9e837765f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '1c382647-96f9-43cd-9b5f-6461c46c819c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'af910ead-96e0-438d-9bfe-07010d130ffa'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '36199890-aa76-4114-92ab-aa1cd11f96de'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'deba77cd-c875-400d-a28c-0a15137fbb8b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '53da41b0-849f-47a5-a651-5b422a0ac5d3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '24e37ba9-b38c-4c5a-9571-364ccfcf424b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4f5d5fc3-e403-4535-8797-ab70b49cbe40'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'bdb89448-1ada-4be9-b4ed-c4626627f3f3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5eb4d673-7663-4f49-ba21-45f7ab7b360b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4c4ced3c-2308-4bec-aadd-5b50b4e23cc0'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4ea76fe4-5af8-4eb6-8aa8-6e9d2e95f5d8'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '97e1f1ec-1312-4c72-bc63-2cbbba47b419'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e0f9efcb-c552-4775-a0d6-d5e4ce093dc3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e9f069a0-b884-4236-a980-100c413688d3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '3bd45653-ed4c-44ad-8acb-1b2c6230b794'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e764de6d-f30a-438a-990a-b1e61ba1e665'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'c2a1784e-e59b-47e7-99aa-0c1b92577e7a'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '106548a4-ad1f-4f05-8566-2c6a1330c14e'),'Activo','cas', now(),'127.0.0.1',null,null,null);
    
	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '7c8f85af-019f-4d46-b63d-fa253083d983'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = '00c783df-2a9e-4f5f-a15f-b5beef20a8eb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e73e9b66-b65c-4e43-85d9-6df8ab8469dc'),'Activo','cas', now(),'127.0.0.1',null,null,null);


    /**ROL Externo**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'bdb89448-1ada-4be9-b4ed-c4626627f3f3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5eb4d673-7663-4f49-ba21-45f7ab7b360b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4c4ced3c-2308-4bec-aadd-5b50b4e23cc0'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4ea76fe4-5af8-4eb6-8aa8-6e9d2e95f5d8'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e0f9efcb-c552-4775-a0d6-d5e4ce093dc3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'cdd1130d-a077-4c47-8f0e-64e8be29a1a9'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '074d4fc4-6d48-44df-809c-258beced2aa9'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '7343a1e1-1683-4f46-8e42-ed0b63393b8c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'adb95dcf-e98b-48b9-bb60-34be36edf9d2'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f94d07ee-1bca-4c24-904d-b3adf6972d81'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'cc30e295-5e53-4b9e-ae7b-6836db27fd01'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ed7fddcf-3384-45dd-9026-f7ba13eb3633'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '541c248d-ce2a-4708-b193-6be4c26dbdc5'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '13bdf2d3-b364-47be-9577-1f3f2c84ffe5'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f1df8aa0-047d-4d40-a644-3f3632556ec7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '8af7c4b8-d166-4b44-8e2b-3cad126007b7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '0db3c82b-f6d7-483e-afb1-29d3b2a3fcf7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '019b427e-eb85-44b4-b096-1d24afb164ca'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'cfa16802-d6f4-42ea-904a-a34d521c001c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ea52b2a1-fb7c-46ec-a2af-4e157aa6446e'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'd6dca8c3-c4da-4468-b510-dd857c80867d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f06ffddc-d280-4189-abd4-26522d610121'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '2bd749ec-833a-46af-b80f-252dffab3519'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '4065f0d2-09ee-48ed-bda6-66e037973289'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'bdda1d9a-5fc4-43ca-b81d-9a337d85fbcb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'd8103b06-10fa-4364-babe-f7b1058631b7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5de6032e-bdb9-44d3-9466-ea004043cd30'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ed5faeaa-5bbb-4d44-9559-275e89931263'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'b37806e2-6813-49e3-ae4a-82f9e837765f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '1c382647-96f9-43cd-9b5f-6461c46c819c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'af910ead-96e0-438d-9bfe-07010d130ffa'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '36199890-aa76-4114-92ab-aa1cd11f96de'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'deba77cd-c875-400d-a28c-0a15137fbb8b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '53da41b0-849f-47a5-a651-5b422a0ac5d3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '24e37ba9-b38c-4c5a-9571-364ccfcf424b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e764de6d-f30a-438a-990a-b1e61ba1e665'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'c2a1784e-e59b-47e7-99aa-0c1b92577e7a'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '7c8f85af-019f-4d46-b63d-fa253083d983'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = '00c783df-2a9e-4f5f-a15f-b5beef20a8eb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e73e9b66-b65c-4e43-85d9-6df8ab8469dc'),'Activo','cas', now(),'127.0.0.1',null,null,null);



	/**ROL Aplicacion*/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'), (select ar.id_rol from admi_rol ar where ar.codigo = 'a5e68104-4372-45c6-91f9-4eb85779b9de'), (select ip.id_permiso from info_permiso ip where ip.codigo = '4f5d5fc3-e403-4535-8797-ab70b49cbe40'), 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'), (select ar.id_rol from admi_rol ar where ar.codigo = 'a5e68104-4372-45c6-91f9-4eb85779b9de'), (select ip.id_permiso from info_permiso ip where ip.codigo = '8edf7e98-8b0e-4f12-8efe-8d51eb017cee'), 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

end $$;
