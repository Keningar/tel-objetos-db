/*
 * Proceso para agregar los recursos y permisos para el token de autorización.
 * En la variable url_dominio_PCAUTIVO se debe poner el dominio y puerto de producción.
 * @author  Ivan Mata imata@telconet.ec
 * @version 1.0  
 */


DO $$
	DECLARE
	   seq_aplicacion_PCAUTIVO int;
      url_dominio_PCAUTIVO varchar(200) = 'https://smartwifi.telconet.net/admin/';
BEGIN

   SELECT nextval('seq_admi_aplicacion')  INTO seq_aplicacion_PCAUTIVO;
    
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/
	
	INSERT INTO public.admi_aplicacion
	(id_aplicacion, codigo, empresa_id, nombre, url_dominio, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(seq_aplicacion_PCAUTIVO, '48abe8f6-a9de-4e3c-8dee-e13b0b636b16', 1, 'Generador de Portales Cautivos', url_dominio_PCAUTIVO, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/
	
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), 'db5b4e78-9dfe-4e67-b572-3c7abcd3226b', 'Radio', seq_aplicacion_PCAUTIVO, NULL, 'Rol de Empleado Telconet del departamento Radio', 'S', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '2192e32d-5eb3-4b2a-9a69-08b82213f661', 'Admin', seq_aplicacion_PCAUTIVO, NULL, 'Rol de Cliente Telconet con privilegios de Administrador', 'N', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), 'cfe31da7-2065-4584-9e8f-ff7f16f4bc5d', 'User', seq_aplicacion_PCAUTIVO, NULL, 'Rol de Cliente Telconet con privilegios de Lectura', 'S', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);

	
	/**************************************************************************************************************************************/
	/***************************************************RECURSOS PORTAL CAUTIVO************************************************************/

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '7b20cda8-9cf9-4735-9ca5-d4d9e289fa01', 'Api para crear directorio root para usuario específico para Generador de Portales Cautivos', '/api-portal-backoffice/gestionarchivos/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '337b2fba-0347-412f-af0a-dbf97911c3a8', 'Api para listar directorios root en base a filtros para Generador de Portales Cautivos', '/api-portal-backoffice/gestionarchivos/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '218afcd1-6b51-43e1-8e9a-e1713e864475', 'Api para actualizar información de un directorio root específico para Generador de Portales Cautivos', '/api-portal-backoffice/gestionarchivos/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b0b62f1f-23b3-4831-a1a6-2aa35011f666', 'Api para eliminar un directorio root específico para Generador de Portales Cautivos', '/api-portal-backoffice/gestionarchivos/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '87fbf1cd-aec7-4519-9c45-db82d8deead4', 'Api para Listar los archivos y directorios que han sido creados dentro del directorio root para Generador de Portales Cautivos', '/api-portal-backoffice/gestionarchivos/listaArchivosDirectorios', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a40aab43-49ab-46a1-b192-3e4fa1bada93', 'Api para crear un directorio dentro del diirectorio Root de un usuario para Generador de Portales Cautivos', '/api-portal-backoffice/directorios/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '58121fc9-a0e0-41ac-98ec-4ddfe33d267f', 'Api para Actualizar información de directorios o Subdirectorios para Generador de Portales Cautivos', '/api-portal-backoffice/directorios/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '1d4ade3f-d5f5-4e5e-b40e-f639c6de2167', 'Api para eliminar registros directorios o Subdirectorios para Generador de Portales Cautivos', '/api-portal-backoffice/directorios/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6ca77518-5acd-4b0f-8103-afa64f7865a2', 'Api para Listar directorios o subdirectorios en base a Filtros para Generador de Portales Cautivos', '/api-portal-backoffice/directorios/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a3c63d92-a633-4abd-b183-1248339ca0c7', 'Api para Listar archivos y subdirectorios de un directorio para Generador de Portales Cautivos', '/api-portal-backoffice/directorios/listaArchivosDirectorios', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a3a32472-488d-41d6-a682-4f85672673e0', 'Api para Guardar archivos en directorio NFS para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '097b6005-07cc-4514-9b26-ce9c62fb526a', 'Api para Actualizar datos de archivos guardados para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a97bbc2d-94d0-42c6-8eae-2f4d45136dfc', 'Api para Eliminar un archivo específico para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0946979e-66f9-4ea1-9627-9855f8606d4a', 'Api para Listar  archivos en base a filtros para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c9f77fac-c189-4541-9bae-4ae84a3a7f87', 'Api para Listar archivos en base a tipo de archivo y directorio root para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/listarPorTipoRootEstado', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '68cc27a1-027f-403a-9e07-01ce46039323', 'Api para Lista archivos en base a tipo de archivo y directorio root y tipo de componente  para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/listarPorTipoComponenteRootEstado', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '33629fc3-be5e-4fbd-b6d8-749f88b703b2', 'Api para Descargar un archivo para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/descargarArchivo', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '18fca528-e1f1-4c51-acdd-ae221da28c07', 'Api para mostrar un archivo en una ventana para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/mostrarArchivo', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b3e7c3c7-ad50-4031-b1a2-c26777d0bdfe', 'Api para consultar archivos en base a filtros para Generador de Portales Cautivos', '/api-portal-backoffice/archivos/buscarPorId', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '567c0af2-3e20-419d-adaf-664cd92e040f', 'Api para Listar portales en base a filtros para Generador de Portales Cautivos', '/api-portal-backoffice/portal/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e4c81942-0bc1-4260-adc2-913cef011324', 'Api para Guardar portales para Generador de Portales Cautivos', '/api-portal-backoffice/portal/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '2f9cf08a-2423-457e-a5d2-65e7f921de27', 'Api para Actualizar información de un portal para Generador de Portales Cautivos', '/api-portal-backoffice/portal/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'ef58cd67-aea3-439a-bc60-712265d4e8ff', 'Api para Crear un nuevo portal a partir de uno ya Existente para Generador de Portales Cautivos', '/api-portal-backoffice/portal/duplicarPortal', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f9d42faa-f636-4924-949d-2e2a535e7ada', 'Api para Eliminar un portal para Generador de Portales Cautivos', '/api-portal-backoffice/portal/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f63cf717-a461-4226-bed9-9490bc0b7c15', 'Api para Guardar detalles de un componente asociado a un portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0badfe7e-bd7c-42db-948b-f159db15cd55', 'Api para Actualizar detalles de un componente asociado a un portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b9811117-1ecd-493d-87fb-9b32a4596009', 'Api para Listar detalles de componentes que forman un portal por medio de filtros para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e9f1c409-028c-410d-bfe2-14ab32bd7ba7', 'Api para Eliminar detalles de un componente asociado a un portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c347c744-07fb-41cd-a314-ef5cf5850ad0', 'Api para Actualizar index (componente o página) de una lista de componentes asociados a un portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/actualizarIndex', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '00506ab2-e66c-4ad8-b895-e89307c369de', 'Api para Eliminar lista de componentes asociado a un portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/eliminarListaDetalles', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'fb313b5c-9fe6-4707-96df-7b45b96c6662', 'Api para Guardar un componente con o sin archivo asociado a un Portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/guardarDetalleComponente', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '2c841d16-28ac-4d42-ba00-04b79d1eef11', 'Api para Actualizar un componente con o sin archivo asociado a un portal para Generador de Portales Cautivos', '/api-portal-backoffice/detallePortal/actualizarDetalleComponente', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'bd67829d-615e-49bc-9c3e-a5df66d6c7ce', 'Api para Crear zonas para Generador de Portales Cautivos', '/api-portal-backoffice/zona/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0ad7c9cd-fbcc-4311-9348-baab18ab33c2', 'Api para Actualizar zona existente para Generador de Portales Cautivos', '/api-portal-backoffice/zona/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '28c701b4-bfe6-458b-90f2-feae6744ceca', 'Api para Listar zonas en base a filtros para Generador de Portales Cautivos', '/api-portal-backoffice/zona/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '17dfaca6-9bee-4b57-984d-c164a0f2112f', 'Api para Buscar una zona por filtros de Usuario para Generador de Portales Cautivos', '/api-portal-backoffice/zona/buscarPorUsuario', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd4952408-2c00-43b1-8d6d-aece88d23163', 'Api para Devolver información del Portal y Plan de Navegación asociados a una zona realizando una búsqueda por Ssid para Generador de Portales Cautivos', '/api-portal-backoffice/zona/buscarPorSsid', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '58b4a721-d0c2-4c9f-99df-31253c58091a', 'Api para Devolver información del Portal y Plan de Navegación asociados a una zona realizando una búsqueda por dirección mac de un Acces Point para Generador de Portales Cautivos', '/api-portal-backoffice/zona/buscarPorApMac', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '975fd184-a161-4a8e-b6b5-ac9b8d15eb75', 'Api para Eliminar información de una zona específica para Generador de Portales Cautivos', '/api-portal-backoffice/zona/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '42745b4d-15c3-4d08-a59e-55e8995c5a9a', 'Api para Listar parámetros en base a filtros para Generador de Portales Cautivos', '/api-portal-backoffice/parametro/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a0ebb67b-5117-4fa6-8b89-d746fe8bdf1e', 'Api para Obtener parámetros de configuración del Servidor para Generador de Portales Cautivos', '/api-portal-backoffice/parametro/getServerParams', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6ea48371-35b1-4f29-baa0-f553db1493a0', 'Api para Listar planes de navegación por filtros aplicados para Generador de Portales Cautivos', '/api-portal-backoffice/planNavegacion/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'cbaa1cb7-7d45-45fd-be29-9144077c800e', 'Api para Crear planes de navegación para Generador de Portales Cautivos', '/api-portal-backoffice/planNavegacion/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '8e3eb998-9688-427d-8215-9e121a28abac', 'Api para Actualizar información de un plan de navegación para Generador de Portales Cautivos', '/api-portal-backoffice/planNavegacion/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '4541a494-2d48-49d2-b428-4394b555339c', 'Api para Eliminar información de un plan de navegación para Generador de Portales Cautivos', '/api-portal-backoffice/planNavegacion/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f53fabc2-fde3-4dbe-a7b8-ca144b9e5227', 'Api para Listar puntos de acceso por filtros aplicados para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '4ba1c890-e07a-4744-ad97-b5984d21acfc', 'Api para Listar puntos de acceso por filtros aplicados para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '41d3899d-9d2c-42bb-9535-67c58cd89c3f', 'Api para Actualizar información de puntos de acceso para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '67c7b8be-5404-4c01-ae9a-c6d89b828ec0', 'Api para Eliminar información de zona asociada a un punto de acceso para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/eliminarZona', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '161eb898-a6d2-4ad3-bf7f-32ac8489a22d', 'Api para Lista puntos de acceso que no han sido asignados a una zona y cuyo estado sea diferente de ELIMINADO para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/listarApsDisponibles', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '1792c416-e868-4335-ab97-65d8497af265', 'Api para Actualizar información de una lista de puntos de acceso para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/actualizarListaAps', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd9338586-2e26-4071-ae3c-bbccfd063080', 'Api para Crear un plano para Generador de Portales Cautivos', '/api-portal-backoffice/plano/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'fbf8cd2a-8dd2-4d82-8107-4bd1763026df', 'Api para Actualizar información de un plano con o sin Archivo para Generador de Portales Cautivos', '/api-portal-backoffice/plano/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'abd5532f-db09-4f17-93c5-6ce33a4b4a95', 'Api para Listar planos en base a filtros aplicados para Generador de Portales Cautivos', '/api-portal-backoffice/plano/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '41fa90e9-31cb-4f09-a667-07165e728c35', 'Api para Eliminar información de un plano para Generador de Portales Cautivos', '/api-portal-backoffice/plano/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '52536fa7-faac-4b68-a663-64ba26173fb6', 'Api para Guardar una organización para Generador de Portales Cautivos', '/api-portal-backoffice/organizaciones/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b666f39b-2dea-4aa9-9083-5ef4b3dc7866', 'Api para Actualizar una organización para Generador de Portales Cautivos', '/api-portal-backoffice/organizaciones/actualizar/bind', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'ff8dc92c-339c-4f9b-9385-7580487b801b', 'Api para Consultar cliente Telconet para Generador de Portales Cautivos', '/api-portal-backoffice/organizaciones/listarClientePorLogin/bind', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'bf483460-b605-4015-9bc4-c176f02523e9', 'Api para Consultar clientes para Generador de Portales Cautivos', '/api-portal-backoffice/organizaciones/listar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '55122161-c716-4fd2-b732-bd82f911aaed', 'Api para Resetear contraseña de usuario para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/resetear', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6af70cd0-b09f-467f-9acb-14c83298efa4', 'Api para Actualizar una organización para Generador de Portales Cautivos', '/controladora/organizacion/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '65141269-0e64-4fe8-b4bc-8455d0af1224', 'Api para guardar organización para Generador de Portales Cautivos', '/controladora/organizacion/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c2c32ee1-0c3a-4d6d-b92c-0730edd19116', 'Api para traer listado de usuarios para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/listaPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '829c973d-d69d-4980-9f24-0804962347df', 'Api para actualizar un usuario para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '5dad0ebe-9bf4-4560-8cca-fc77eb037f6d', 'Api para guardar un usuario para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '7e1ba101-a2bb-46cd-bbe3-3727d5d9011e', 'Api para consultar el portal creado por usuario para Generador de Portales Cautivos', '/api-portal-backoffice/portal/listarPorUserIdAndDistinctEstado', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '46cada61-c02b-4da4-8d2a-16d51e3103f8', 'Api para consultar mapas y app por zonas para Generador de Portales Cautivos rukus', '/controladora/puntoAcceso/numConexionesApsRks300', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '51c6a2bb-5d0b-4fca-b934-26b64db11332', 'Api para consultar mapas y app por zonas para Generador de Portales Cautivos', '/controladora/puntoAcceso/numConexionesApsHw', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '3161f77e-a3f1-4092-b38b-c40d3495879a', 'Api para consultar listado clientes para Generador de Portales Cautivos', '/controladora/cliente/listaDataClientes', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '4b8b3e8c-a2c6-4392-86b1-41c0695e8420', 'Api para exportar datos estadísticos para Generador de Portales Cautivos', '/controladora/cliente/obtenerDatosExportar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '5f5eb077-07b5-4124-b516-c919b47e86e4', 'Api para consultar tecnologias para la pantalla de graficos estadisticos para Generador de Portales Cautivos', '/controladora/cliente/listaDataTecnologia', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'cda8a20b-7888-4785-9816-6b54edc78476', 'Api para consultar información para el grafico de audiencia para Generador de Portales Cautivos', '/controladora/cliente/listaDataAudiencia', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd62d037e-e3a2-46a8-98fd-0c547076f411', 'Api para consultar resumen de visita semanal para Generador de Portales Cautivos', '/controladora/cliente/listaComportamientoPorZona', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '17adaa20-9639-4e59-b90d-1a5c374749da', 'Api para consultar tráfico de red para Generador de Portales Cautivos', '/controladora/cliente/listaZonaRangoFecha', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0b540b03-8a53-4412-98d2-2b069b4c2d2a', 'Api para reestablecer contraseña de usuario para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/updateCredentials', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '4650e8bf-3f09-4bdc-a9dd-a5ed73e1150f', 'Api para Eliminar zona para Generador de Portales Cautivos', '/api-portal-backoffice/accessPoint/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'ebd4cab3-cf06-4492-90e9-b474feb57b42', 'Api para guardar zona de portal cautivo en base mongo', '/controladora/zona/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);	
	

INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '962a8df9-6fd8-4c70-b009-d95476246f39', 'Api para actualizar zona de portal cautivo en base mongo', '/controladora/zona/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);	
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '5f6577ab-9359-46e4-ab4a-e24bbeaae195', 'Api para guardar el ap en base mongo', '/controladora/puntoAcceso/guardar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	

INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '454ca9ab-fa2b-42ec-98fe-0f2e05441d23', 'Api para eliminar el usuario de portal cautivo', '/api-portal-backoffice/usuarios/eliminar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '642270c5-3213-44cb-82ee-34deab9dc313', 'Api para desasociar la zona del AP', '/controladora/puntoAcceso/eliminarZona', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b75f296d-6434-48b7-976f-8ef93aec1c0f', 'Api para Actualizar un AP en base mongo', '/controladora/puntoAcceso/actualizar', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	

INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e19e9d60-cfc1-427a-8496-7dbeb131cf4a', 'Api para traer información de un usuario', '/api-portal-backoffice/usuarios/listaPorU', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);	
	
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '815450df-d32d-4b9e-8b28-7050a88cd961', 'Api para consultar la sesiones de la controladora', '/controladora/cliente/listaDataSesiones', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);	
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '53d1aa3a-3e3f-4ecf-b6ed-29899bb2e60f', 'Api para Actualizar la información de un ap asociado a un mapa', '/api-portal-backoffice/accessPoint/actualizarAps', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	

INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'f6d7ed38-9de4-498b-93d3-56a8d29b0fb8', 'Api para guadar un usuario con rol user', '/api-portal-backoffice/usuarios/guardarU', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	

INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '95920ab5-594f-43f0-a3ff-30bcee1a9b57', 'Api para traer listado de usuarios para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/listaUsuarioPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	
INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd456bc85-7d81-4713-8afb-2f4d8c0ecb4c', 'Api para traer listado de usuarios por organizacion para Generador de Portales Cautivos', '/api-portal-backoffice/usuarios/listaPorOrg', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, NULL);
	
	

	


	/**************************************************************************************************************************************/
	/***************************************************PERMISOS PORTAL CAUTIVO************************************************************/
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'1d3bd27b-edb8-4f18-a539-862a21e0c01e',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '7b20cda8-9cf9-4735-9ca5-d4d9e289fa01'),'Permiso para Crea Directorio Root para un usuario en específico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'17638d9c-8dc0-400a-b61e-38ca60ec6f7c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '337b2fba-0347-412f-af0a-dbf97911c3a8'),'Permiso para Lista Directorios Root en base a Filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'691244b7-b984-4711-8b21-e59ed052e843',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '218afcd1-6b51-43e1-8e9a-e1713e864475'),'Permiso para Actualiza información de un directorio root específico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'b3904531-55f5-4a03-a900-c38c7d5d92cf',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b0b62f1f-23b3-4831-a1a6-2aa35011f666'),'Permiso para Elimina un directorio root específico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d403ca27-7ba0-4399-9605-36d4caa98952',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '87fbf1cd-aec7-4519-9c45-db82d8deead4'),'Permiso para Lista los archivos y directorios que han sido creados dentro del directorio root','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9bc6b8fe-b72c-4993-a5de-9fea1c7fe039',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a40aab43-49ab-46a1-b192-3e4fa1bada93'),'Permiso para Crea un directorio dentro del directorio Root de un usuario','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'38d24e21-584d-4089-a17a-603b583ac276',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '58121fc9-a0e0-41ac-98ec-4ddfe33d267f'),'Permiso para Actualizar información de directorios o Subdirectorios','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5dd0a58c-1331-4c0f-bbf4-b6e042dd1142',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '1d4ade3f-d5f5-4e5e-b40e-f639c6de2167'),'Permiso para Eliminar registros de directorios o Subdirectorios','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5866e555-9a2d-451c-b8ff-96aa26ef5bbb',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6ca77518-5acd-4b0f-8103-afa64f7865a2'),'Permiso para Lista directorios o subdirectorios en base a Filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9ecc4ae2-63ae-41be-ba51-6cf7555f6fb2',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a3c63d92-a633-4abd-b183-1248339ca0c7'),'Permiso para Lista archivos y subdirectorios de un directorio','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'297f2982-9554-473f-9c4d-f1162d4dd51f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a3a32472-488d-41d6-a682-4f85672673e0'),'Permiso para Guarda archivos en directorio NFS','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'989e669c-97ee-4399-b655-97db94034b75',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '097b6005-07cc-4514-9b26-ce9c62fb526a'),'Permiso para Actualiza datos de archivos guardados','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ddeb7320-94f2-4194-96bf-caf447af85fa',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a97bbc2d-94d0-42c6-8eae-2f4d45136dfc'),'Permiso para Elimina un archivo específico','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c3b001c0-715b-4922-be10-46b477877839',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0946979e-66f9-4ea1-9627-9855f8606d4a'),'Permiso para Lista archivos en base a filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'55cc0e57-3a7c-4a1c-95fd-2c375548074f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c9f77fac-c189-4541-9bae-4ae84a3a7f87'),'Permiso para Lista archivos en base a tipo de archivo y directorio root','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'8a11acb6-a529-415c-b81a-0e485d555501',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '68cc27a1-027f-403a-9e07-01ce46039323'),'Permiso para Lista archivos en base a tipo de archivo y directorio root y tipo de componente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d14e6cb0-1961-4385-b301-d82af6f777ec',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '33629fc3-be5e-4fbd-b6d8-749f88b703b2'),'Permiso para Descarga un archivo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'21c9b93e-16a9-48a4-bd41-a711154fb895',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '18fca528-e1f1-4c51-acdd-ae221da28c07'),'Permiso para Muestra un archivo en una nueva ventana','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'3636abbb-8366-47d8-9a49-d4b02546ac47',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b3e7c3c7-ad50-4031-b1a2-c26777d0bdfe'),'Permiso para Lista archivos en base a filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'12d06dea-71e7-4989-981d-31d806848424',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '567c0af2-3e20-419d-adaf-664cd92e040f'),'Permiso para Lista portales en base a filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'099fb4e5-05cf-4434-91c1-d3f51b175b6e',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e4c81942-0bc1-4260-adc2-913cef011324'),'Permiso para Guarda portales','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f0dcb3c1-8a49-4ab5-b229-ad415dfbd396',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '2f9cf08a-2423-457e-a5d2-65e7f921de27'),'Permiso para Actualiza información de un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'251a075e-edf1-44e3-8b88-c9670230605b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'ef58cd67-aea3-439a-bc60-712265d4e8ff'),'Permiso para Crea un nuevo portal a partir de uno ya Existente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'04e35b0e-f8f2-43c7-8133-8ac909078fe0',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f9d42faa-f636-4924-949d-2e2a535e7ada'),'Permiso para Elimina un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'0949d164-c63f-49cd-9924-48d7d7c66c3a',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f63cf717-a461-4226-bed9-9490bc0b7c15'),'Permiso para Guarda detalles de un componente asociado a un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'7a2fcae9-a5fe-4b06-ac39-3753048963fd',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0badfe7e-bd7c-42db-948b-f159db15cd55'),'Permiso para Actualiza detalles de un componente asociado a un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'1370e9c1-7966-48c3-b944-508dc737bf38',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b9811117-1ecd-493d-87fb-9b32a4596009'),'Permiso para Lista detalles de componentes que forman un portal por medio de filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ad47cd28-bc2e-4fbe-b114-c6328c705d36',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e9f1c409-028c-410d-bfe2-14ab32bd7ba7'),'Permiso para Elimina detalles de un componente asociado a un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'2ccd333a-7cf4-4371-84cc-2ab472eef20f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c347c744-07fb-41cd-a314-ef5cf5850ad0'),'Permiso para Actualiza index (componente o página) de una lista de componentes asociados a un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'a6034423-9b11-432f-9904-281873cb3d34',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '00506ab2-e66c-4ad8-b895-e89307c369de'),'Permiso para Elimina lista de componentes asociado a un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'cd095b7d-d5b0-41f5-acf4-fd60bec66885',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'fb313b5c-9fe6-4707-96df-7b45b96c6662'),'Permiso para Guarda un componente con o sin archivo asociado a un Portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ecee542a-991c-4dc0-b0be-8720a905c168',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '2c841d16-28ac-4d42-ba00-04b79d1eef11'),'Permiso para Actualizar un componente con o sin archivo asociado a un portal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'49d74cda-3d2c-4e01-ba04-b6df673b829a',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'bd67829d-615e-49bc-9c3e-a5df66d6c7ce'),'Permiso para Crea zonas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d74cd51c-54ff-4270-8a9e-24cb924a08cb',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0ad7c9cd-fbcc-4311-9348-baab18ab33c2'),'Permiso para Actualiza zona existente','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'7439ac2e-de53-48e1-92d8-2b6653c25133',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '28c701b4-bfe6-458b-90f2-feae6744ceca'),'Permiso para Lista zonas en base a filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'888e44db-9d3f-4f56-8355-60b26fea101f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '17dfaca6-9bee-4b57-984d-c164a0f2112f'),'Permiso para Busca una zona por filtros de Usuario','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'47b881cc-fc78-4ac6-9447-7864ab94b47c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd4952408-2c00-43b1-8d6d-aece88d23163'),'Permiso para Devuelve información del Portal y Plan de Navegación asosciados a una zona realizando una búsqueda por Ssid','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4d75daf4-5122-40f3-aef5-3ba25d198e6d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '58b4a721-d0c2-4c9f-99df-31253c58091a'),'Permiso para Devuelve información del Portal y Plan de Navegación asociados a una zona realizando una búsqueda por dirección mac de un Acces Point','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f8f20215-b4ab-4bc8-a6a0-ca0418bf3265',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '975fd184-a161-4a8e-b6b5-ac9b8d15eb75'),'Permiso para Elimina información de una zona específica','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'db89ab06-efd1-43d5-b71c-9863323f0475',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '42745b4d-15c3-4d08-a59e-55e8995c5a9a'),'Permiso para Lista parámetros en base a filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'95d3f46e-436a-4748-9cee-ac653c2e2b65',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a0ebb67b-5117-4fa6-8b89-d746fe8bdf1e'),'Permiso para Obtiene parámetros de configuración del Servidor de la aplicación Portal Cautivo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'a86423fc-63f7-44cb-86d5-197fbced5e38',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6ea48371-35b1-4f29-baa0-f553db1493a0'),'Permiso para Lista planes de navegación por filtros aplicados','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'45254dfe-0daf-4885-9ea2-af324d4fe395',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'cbaa1cb7-7d45-45fd-be29-9144077c800e'),'Permiso para Crea planes de navegación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c56e2c05-a91d-4f06-8a4f-c93f9075c46c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '8e3eb998-9688-427d-8215-9e121a28abac'),'Permiso para Actualiza información de un plan de navegación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'416d7653-29b4-4d0b-8b51-bffec9f1bb71',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '4541a494-2d48-49d2-b428-4394b555339c'),'Permiso para Elimina información de un plan de navegación','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'96290b64-bb41-43d3-98b0-cb0bb24f71c1',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f53fabc2-fde3-4dbe-a7b8-ca144b9e5227'),'Permiso para Lista puntos de acceso por filtros aplicados','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e34d87b2-c801-4050-9e0a-5e6ff031db20',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '4ba1c890-e07a-4744-ad97-b5984d21acfc'),'Permiso para Crea puntos de acceso','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'eb61d1b4-4e82-4847-9a09-bc7ea65dfb4b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '41d3899d-9d2c-42bb-9535-67c58cd89c3f'),'Permiso para Actualiza información de puntos de acceso','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d9489c50-f9c9-42aa-8ef5-edf975ac6a57',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '67c7b8be-5404-4c01-ae9a-c6d89b828ec0'),'Permiso para Elimina información de zona asociada a un punto de acceso','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'673a11cb-72b9-4eb6-bef9-39ebe7667e3c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '161eb898-a6d2-4ad3-bf7f-32ac8489a22d'),'Permiso para Lista puntos de acceso que no han sido asignados a una zona y cuyo estado sea diferente de “eliminado”','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ef85dc1d-8d0f-4079-88c0-41f98d0a8bf6',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '1792c416-e868-4335-ab97-65d8497af265'),'Permiso para Actualiza información de una lista de puntos de acceso','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'34a3b8bf-fc43-4a00-8f0b-6a3ab4fc0eb3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd9338586-2e26-4071-ae3c-bbccfd063080'),'Permiso para Crea un plano','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'01de107e-ee35-46f0-9a42-d334e668f4ba',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'fbf8cd2a-8dd2-4d82-8107-4bd1763026df'),'Permiso para Actualiza información de un plano con o sin Archivo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ed36f641-6deb-4ab7-a4e5-8a2cf38b99ca',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'abd5532f-db09-4f17-93c5-6ce33a4b4a95'),'Permiso para Lista planos en base a filtros aplicados','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'7d360797-0147-4605-a4c4-b12c8e7bebdd',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '41fa90e9-31cb-4f09-a667-07165e728c35'),'Permiso para Elimina información de un plano','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'fa05a11d-aa49-4156-9b0a-302f81b44e94',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '52536fa7-faac-4b68-a663-64ba26173fb6'),'Permiso para Guardar una organización','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'7b809072-0a55-490b-b764-97e5d8166656',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b666f39b-2dea-4aa9-9083-5ef4b3dc7866'),'Permiso para Actualizar una organización','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'757b8d3d-1558-413c-a87f-352dc3f2862a',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'ff8dc92c-339c-4f9b-9385-7580487b801b'),'Permiso para Consultar cliente Telconet','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'0c05feee-093c-46d2-94c1-9014b813fb99',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'bf483460-b605-4015-9bc4-c176f02523e9'),'Permiso para Consultar clientes del Portal Cautivo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9a7f662c-a03e-41c4-a072-cf6508c648c4',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '55122161-c716-4fd2-b732-bd82f911aaed'),'Permiso para Resetear contraseña de usuario','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'b55660ef-95e7-4599-8ffe-70ebd0326c16',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6af70cd0-b09f-467f-9acb-14c83298efa4'),'Permiso para Actualizar una organización','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'6b0ede62-6f73-4e23-964f-fab5bcb308d1',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '65141269-0e64-4fe8-b4bc-8455d0af1224'),'Permiso para Guardar organización','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'21a7d96e-f9af-4c50-a2c6-b4c53411aa03',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c2c32ee1-0c3a-4d6d-b92c-0730edd19116'),'Permiso para Traer listado de usuarios','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9bc23b00-5c12-496b-b9f8-eea94f20bc05',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '829c973d-d69d-4980-9f24-0804962347df'),'Permiso para Actualizar un usuario ','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'3d4c57c4-9955-4b36-91f4-cebdf0021bd6',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '5dad0ebe-9bf4-4560-8cca-fc77eb037f6d'),'Permiso para Guardar un usuario','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'0365501a-e78b-4aae-85a3-a0b68b1c1608',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '7e1ba101-a2bb-46cd-bbe3-3727d5d9011e'),'Permiso para Consultar el portal creado por usuario','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'2e9363dc-75fb-4623-83b6-9fc450d07917',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '46cada61-c02b-4da4-8d2a-16d51e3103f8'),'Permiso para Consultar mapas y app por zonas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5e5b9c0c-4f6e-4923-949c-70d12b3562fc',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '3161f77e-a3f1-4092-b38b-c40d3495879a'),'Permiso para Consultar listado clientes','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'458b3ad8-a95a-44e7-88e7-f3d5926cbc08',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '4b8b3e8c-a2c6-4392-86b1-41c0695e8420'),'Permiso para Exportar datos estadisticos','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'6b68bc5d-147d-4bbf-a5ce-9a65dc3d8e60',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '5f5eb077-07b5-4124-b516-c919b47e86e4'),'Permiso para Consultar tecnologias para la pantalla de graficos estadisticos','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4ee522fd-8b00-4f58-ad90-c83253a309fa',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'cda8a20b-7888-4785-9816-6b54edc78476'),'Permiso para Consultar información para el grafico de audiencia','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'71110fbe-a122-41c6-b60e-c0528ebaf781',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd62d037e-e3a2-46a8-98fd-0c547076f411'),'Permiso para Consultar resumen de visita semanal','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'cbb7db67-68ec-4547-bfdd-7af00fde9d98',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '17adaa20-9639-4e59-b90d-1a5c374749da'),'Permiso para Consultar trafico de red','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'59e7462e-3fb6-458d-a03e-a768364a49c5',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0b540b03-8a53-4412-98d2-2b069b4c2d2a'),'Permiso para Reestablecer contraseña de usuario','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'4325746b-5bac-4ea7-9f5b-ce626776dfb7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '4650e8bf-3f09-4bdc-a9dd-a5ed73e1150f'),'Permiso para Eliminar zona','Activo','cas', now(),'127.0.0.1',null,null,null);


INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'3a8a128c-6f0d-4d5a-a40a-1267b7cd2c89',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'ebd4cab3-cf06-4492-90e9-b474feb57b42'),'Permiso para guardar la zona en la base mongo','Activo','cas', now(),'127.0.0.1',null,null,null);


INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'47535228-1d96-4ef9-857c-4c19527c1dd3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '962a8df9-6fd8-4c70-b009-d95476246f39'),'Permiso para actualizar la zona en la base mongo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	
	
INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f513a9bc-3bac-4643-9ce5-4f9862049111',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '5f6577ab-9359-46e4-ab4a-e24bbeaae195'),'Permiso para guardar ap en base mongo','Activo','cas', now(),'127.0.0.1',null,null,null);



INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f1c20bac-25b1-4e38-a6bc-d9a803ef76c8',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '51c6a2bb-5d0b-4fca-b934-26b64db11332'),'Permiso para conectarse con la controladora huawei','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	
	
INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'b73a7a63-e98b-49b1-9826-a71ce4b37938',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '454ca9ab-fa2b-42ec-98fe-0f2e05441d23'),'Permiso para Eliminar usuario de portal cautivo','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	
INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'fd8f8ff6-7a1a-43ef-8579-fe497101e8c3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b75f296d-6434-48b7-976f-8ef93aec1c0f'),'Permiso para actualizar un ap en base mongo','Activo','cas', now(),'127.0.0.1',null,null,null);

		
		
INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c8ed4a65-0b44-4f0f-83d0-bbc25f97ee75',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e19e9d60-cfc1-427a-8496-7dbeb131cf4a'),'Permiso para listar información de usuario','Activo','cas', now(),'127.0.0.1',null,null,null);
	

INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'d5480ba4-f284-4bf4-a4a9-fe907546f80d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '815450df-d32d-4b9e-8b28-7050a88cd961'),'Permiso para consultar las sesiones desde la controladora','Activo','cas', now(),'127.0.0.1',null,null,null);
		
		

INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'becd1e8e-b4a1-42e2-b053-117720bca9fe',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '642270c5-3213-44cb-82ee-34deab9dc313'),'Permiso para Desasociar una zona de un AP','Activo','cas', now(),'127.0.0.1',null,null,null);
			
	
	
INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'6c117ebf-9ace-4a94-aeeb-a06c66f72770',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '53d1aa3a-3e3f-4ecf-b6ed-29899bb2e60f'),'Permiso para Actualizar la información de un ap asociado a un mapa','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	

INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f9c54f00-54bf-42ff-9dba-14fb9a7fcacd',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'f6d7ed38-9de4-498b-93d3-56a8d29b0fb8'),'Permiso para guardar un usuario con rol user','Activo','cas', now(),'127.0.0.1',null,null,null);



INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f89731f9-f183-4e47-b2d1-683b6ebf8a9b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '95920ab5-594f-43f0-a3ff-30bcee1a9b57'),'Permiso para traer listado de usuarios','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	
INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'fb26b95c-4a63-4276-8805-ab20b41e1560',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd456bc85-7d81-4713-8afb-2f4d8c0ecb4c'),'Permiso para traer listado de usuarios por organización','Activo','cas', now(),'127.0.0.1',null,null,null);
	


/**************************************************************************************************************************************/
/***************************************************ROL PERMISOS PORTAL CAUTIVO************************************************************/

/*********/
/**RADIO*/


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='1d3bd27b-edb8-4f18-a539-862a21e0c01e' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='55cc0e57-3a7c-4a1c-95fd-2c375548074f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='8a11acb6-a529-415c-b81a-0e485d555501' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='099fb4e5-05cf-4434-91c1-d3f51b175b6e' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  


 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f0dcb3c1-8a49-4ab5-b229-ad415dfbd396' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='251a075e-edf1-44e3-8b88-c9670230605b' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
  INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='04e35b0e-f8f2-43c7-8133-8ac909078fe0' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
  INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='0949d164-c63f-49cd-9924-48d7d7c66c3a' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='7a2fcae9-a5fe-4b06-ac39-3753048963fd' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='1370e9c1-7966-48c3-b944-508dc737bf38' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ad47cd28-bc2e-4fbe-b114-c6328c705d36' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='2ccd333a-7cf4-4371-84cc-2ab472eef20f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='a6034423-9b11-432f-9904-281873cb3d34' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
      
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='cd095b7d-d5b0-41f5-acf4-fd60bec66885' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='49d74cda-3d2c-4e01-ba04-b6df673b829a' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d74cd51c-54ff-4270-8a9e-24cb924a08cb' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='7439ac2e-de53-48e1-92d8-2b6653c25133' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='47b881cc-fc78-4ac6-9447-7864ab94b47c' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='4d75daf4-5122-40f3-aef5-3ba25d198e6d' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   

 INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f8f20215-b4ab-4bc8-a6a0-ca0418bf3265' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);         
           
           
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='db89ab06-efd1-43d5-b71c-9863323f0475' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='95d3f46e-436a-4748-9cee-ac653c2e2b65' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='a86423fc-63f7-44cb-86d5-197fbced5e38' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='45254dfe-0daf-4885-9ea2-af324d4fe395' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='c56e2c05-a91d-4f06-8a4f-c93f9075c46c' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='416d7653-29b4-4d0b-8b51-bffec9f1bb71' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='96290b64-bb41-43d3-98b0-cb0bb24f71c1' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
            
            
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='e34d87b2-c801-4050-9e0a-5e6ff031db20' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);           
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='eb61d1b4-4e82-4847-9a09-bc7ea65dfb4b' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   

   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d9489c50-f9c9-42aa-8ef5-edf975ac6a57' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='673a11cb-72b9-4eb6-bef9-39ebe7667e3c' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ef85dc1d-8d0f-4079-88c0-41f98d0a8bf6' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='34a3b8bf-fc43-4a00-8f0b-6a3ab4fc0eb3' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='01de107e-ee35-46f0-9a42-d334e668f4ba' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ed36f641-6deb-4ab7-a4e5-8a2cf38b99ca' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);            
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='7d360797-0147-4605-a4c4-b12c8e7bebdd' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='fa05a11d-aa49-4156-9b0a-302f81b44e94' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='7b809072-0a55-490b-b764-97e5d8166656' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='757b8d3d-1558-413c-a87f-352dc3f2862a' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='0c05feee-093c-46d2-94c1-9014b813fb99' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='9a7f662c-a03e-41c4-a072-cf6508c648c4' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='b55660ef-95e7-4599-8ffe-70ebd0326c16' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='6b0ede62-6f73-4e23-964f-fab5bcb308d1' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='21a7d96e-f9af-4c50-a2c6-b4c53411aa03' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='9bc23b00-5c12-496b-b9f8-eea94f20bc05' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='3d4c57c4-9955-4b36-91f4-cebdf0021bd6' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='0365501a-e78b-4aae-85a3-a0b68b1c1608' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='2e9363dc-75fb-4623-83b6-9fc450d07917' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='5e5b9c0c-4f6e-4923-949c-70d12b3562fc' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='458b3ad8-a95a-44e7-88e7-f3d5926cbc08' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='6b68bc5d-147d-4bbf-a5ce-9a65dc3d8e60' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='4ee522fd-8b00-4f58-ad90-c83253a309fa' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='71110fbe-a122-41c6-b60e-c0528ebaf781' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='cbb7db67-68ec-4547-bfdd-7af00fde9d98' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='59e7462e-3fb6-458d-a03e-a768364a49c5' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);       
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='4325746b-5bac-4ea7-9f5b-ce626776dfb7' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);          
   
  
  ---
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='3a8a128c-6f0d-4d5a-a40a-1267b7cd2c89' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);          
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='47535228-1d96-4ef9-857c-4c19527c1dd3' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='888e44db-9d3f-4f56-8355-60b26fea101f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f513a9bc-3bac-4643-9ce5-4f9862049111' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='21c9b93e-16a9-48a4-bd41-a711154fb895' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);         
                   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f1c20bac-25b1-4e38-a6bc-d9a803ef76c8' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='12d06dea-71e7-4989-981d-31d806848424' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='b73a7a63-e98b-49b1-9826-a71ce4b37938' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
          
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='fd8f8ff6-7a1a-43ef-8579-fe497101e8c3' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      



INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='c8ed4a65-0b44-4f0f-83d0-bbc25f97ee75' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
            

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d5480ba4-f284-4bf4-a4a9-fe907546f80d' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='becd1e8e-b4a1-42e2-b053-117720bca9fe' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='6c117ebf-9ace-4a94-aeeb-a06c66f72770' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f9c54f00-54bf-42ff-9dba-14fb9a7fcacd' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ecee542a-991c-4dc0-b0be-8720a905c168' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f89731f9-f183-4e47-b2d1-683b6ebf8a9b' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
----------------------------   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='3636abbb-8366-47d8-9a49-d4b02546ac47' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d14e6cb0-1961-4385-b301-d82af6f777ec' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);              
   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='fb26b95c-4a63-4276-8805-ab20b41e1560' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   

  

/*********/
/**ADMIN*/



INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='1d3bd27b-edb8-4f18-a539-862a21e0c01e' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='17638d9c-8dc0-400a-b61e-38ca60ec6f7c' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='691244b7-b984-4711-8b21-e59ed052e843' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='21a7d96e-f9af-4c50-a2c6-b4c53411aa03' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='3d4c57c4-9955-4b36-91f4-cebdf0021bd6' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='3d4c57c4-9955-4b36-91f4-cebdf0021bd6' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='b3904531-55f5-4a03-a900-c38c7d5d92cf' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d403ca27-7ba0-4399-9605-36d4caa98952' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='0c05feee-093c-46d2-94c1-9014b813fb99' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='9bc6b8fe-b72c-4993-a5de-9fea1c7fe039' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='38d24e21-584d-4089-a17a-603b583ac276' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='5dd0a58c-1331-4c0f-bbf4-b6e042dd1142' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
             
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='5866e555-9a2d-451c-b8ff-96aa26ef5bbb' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='9ecc4ae2-63ae-41be-ba51-6cf7555f6fb2' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='297f2982-9554-473f-9c4d-f1162d4dd51f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='989e669c-97ee-4399-b655-97db94034b75' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ddeb7320-94f2-4194-96bf-caf447af85fa' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='c3b001c0-715b-4922-be10-46b477877839' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);       
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='55cc0e57-3a7c-4a1c-95fd-2c375548074f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='8a11acb6-a529-415c-b81a-0e485d555501' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d14e6cb0-1961-4385-b301-d82af6f777ec' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='21c9b93e-16a9-48a4-bd41-a711154fb895' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='3636abbb-8366-47d8-9a49-d4b02546ac47' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='12d06dea-71e7-4989-981d-31d806848424' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='099fb4e5-05cf-4434-91c1-d3f51b175b6e' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='099fb4e5-05cf-4434-91c1-d3f51b175b6e' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);        
   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f0dcb3c1-8a49-4ab5-b229-ad415dfbd396' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='251a075e-edf1-44e3-8b88-c9670230605b' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='04e35b0e-f8f2-43c7-8133-8ac909078fe0' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='0949d164-c63f-49cd-9924-48d7d7c66c3a' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='7a2fcae9-a5fe-4b06-ac39-3753048963fd' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='1370e9c1-7966-48c3-b944-508dc737bf38' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ad47cd28-bc2e-4fbe-b114-c6328c705d36' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='2ccd333a-7cf4-4371-84cc-2ab472eef20f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='a6034423-9b11-432f-9904-281873cb3d34' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='cd095b7d-d5b0-41f5-acf4-fd60bec66885' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ecee542a-991c-4dc0-b0be-8720a905c168' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='888e44db-9d3f-4f56-8355-60b26fea101f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='ed36f641-6deb-4ab7-a4e5-8a2cf38b99ca' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='0365501a-e78b-4aae-85a3-a0b68b1c1608' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      
          
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='5e5b9c0c-4f6e-4923-949c-70d12b3562fc' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);      
      
      
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='458b3ad8-a95a-44e7-88e7-f3d5926cbc08' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);       
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='6b68bc5d-147d-4bbf-a5ce-9a65dc3d8e60' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    
   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='4ee522fd-8b00-4f58-ad90-c83253a309fa' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    



INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='71110fbe-a122-41c6-b60e-c0528ebaf781' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);    


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='cbb7db67-68ec-4547-bfdd-7af00fde9d98' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='59e7462e-3fb6-458d-a03e-a768364a49c5' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);


INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='2e9363dc-75fb-4623-83b6-9fc450d07917' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f1c20bac-25b1-4e38-a6bc-d9a803ef76c8' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='96290b64-bb41-43d3-98b0-cb0bb24f71c1' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='c8ed4a65-0b44-4f0f-83d0-bbc25f97ee75' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='d5480ba4-f284-4bf4-a4a9-fe907546f80d' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null); 
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='9a7f662c-a03e-41c4-a072-cf6508c648c4' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='f89731f9-f183-4e47-b2d1-683b6ebf8a9b' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='fb26b95c-4a63-4276-8805-ab20b41e1560' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);       
          
            

/**USER*/

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'User' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='21a7d96e-f9af-4c50-a2c6-b4c53411aa03' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'User' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='888e44db-9d3f-4f56-8355-60b26fea101f' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);   
   
   
INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'User' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='59e7462e-3fb6-458d-a03e-a768364a49c5' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);  
   
   

INSERT INTO public.info_rol_permiso
(
 id_rol_permiso,rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod
 )
VALUES(
   nextval('seq_info_rol_permiso'),
   (select id_rol  from public.admi_rol ar where nombre = 'User' and estado ='Activo' and aplicacion_id = seq_aplicacion_PCAUTIVO),
   (select id_permiso from public.info_permiso ip where codigo ='c8ed4a65-0b44-4f0f-83d0-bbc25f97ee75' and estado ='Activo'),
   'Activo',
   'cas',
   now(),
   '127.0.0.1',
   null,
   null,
   null);     



end $$;



