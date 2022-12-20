/*
 * Debe ejecutarse en esquema Public de SSO
 * @author Luis Ardila <lardila@telconet.ec>
 * @version 1.0 01-12-2022 - Versión Inicial.
 */

/** Configuración de Calculadora para el autorizador **/

DO $$
	DECLARE
	    seq_aplicacion_CALCULADORA int;
        url_dominio_CALCULADORA varchar(200) = 'https://test-ws2-bld1.i.telconet.net/calculadora/';
BEGIN

   	SELECT nextval('seq_admi_aplicacion')  INTO seq_aplicacion_CALCULADORA;
    
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.admi_aplicacion
	(id_aplicacion, codigo, empresa_id, nombre, url_dominio, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(seq_aplicacion_CALCULADORA, 'f1396beb-578c-457e-ab0c-25aff840d439', (select id_empresa  from admi_empresa ae where ae.codigo  = '45ad3d30-bc98-41b4-8d89-ad0cd027f5d0'), 'Calculadora', url_dominio_CALCULADORA, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	/**************************************************************************************************************************************/
	/********************************************************ROLES*************************************************************************/

	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '07d869e2-0eaa-4cae-8c03-515ab45c2a43', 'Coordinador', seq_aplicacion_CALCULADORA, NULL, 'Rol con privilegios para app calculadora', 'S', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
		
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '8f209644-7f65-4155-b1c6-7af6dc76c8d3', 'Empleado', seq_aplicacion_CALCULADORA, NULL, 'Rol con privilegios para app calculadora', 'S', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	
	/**************************************************************************************************************************************/
	/***************************************************RECURSOS CALCULADORA******************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd43e5723-b897-415e-a973-aeaee88ff553', 'Api para consultar informacion de un inspector', '/compsolutionmanagement/getAllInitialData', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '22aba4a9-371c-45fc-b088-c0f4b198842a', 'Api para obtener el listado de apus', '/compsolutionmanagement/listApusBy', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '8c9de3cd-bec1-40ee-89e9-45764074f901', 'Api para obtener el listado de apu especifico', '/compsolutionmanagement/retrieveApu', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e298b2b4-6b01-472f-9c1d-6c8250078cf5', 'Api para crear apus', '/compsolutionmanagement/createApu"', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0d9b7592-5d3b-4dcb-816f-acc3b35e8759', 'Api para editar apus', '/compsolutionmanagement/patchApu', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

    INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'add48a26-02d4-442f-a155-c9a711dde0a4', 'Api para eliminar apus', '/compsolutionmanagement/deleteApu', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'af966da0-89df-4231-bf69-512c196de83d', 'Api para obtener listado de materiales.', '/compsolutionmanagement/listResourcesBy', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c62875b6-9fe5-4d5c-99a3-a14578f2bcf7', 'Api para obtener listado de productos.', '/compsolutionmanagement/listProductsBy', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '44491130-ce92-4679-af7f-493e22353e8c', 'Api para obtener listado de marcas y apus.', '/compsolutionmanagement/getApusAndBrandResources', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '6be9108c-39de-40b0-9317-a448c662486b', 'Api para obtener listado de marcas y apus.', '/compsolutionmanagement/getSubBrandResources', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'a09c2bc0-0b82-48ae-bf81-14b73aef4446', 'Api para obtener listado de modelos.', '/compsolutionmanagement/getModelResource', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '5ecbe543-4f51-439c-a840-7398d3211879', 'Api para obtener listado de tareas.', '/compsolutionmanagement/loadTask', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e74b49b0-aebd-4dad-99ad-f0f24aaec2d3', 'Api para crear una inspeccion.', '/compsolutionmanagement/saveInspection', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '69bbf39d-da04-47a8-b88c-1303e8b7a18d', 'Api para aprobar una inspeccion.', '/compsolutionmanagement/aprobeInspection', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
		
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c7352186-5a42-4add-89c1-c2dbfa2d5a3e', 'Api para rechazar una inspeccion.', '/compsolutionmanagement/rejectInspection', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'b2dfa74d-1bb1-49cc-bd5c-7acb00d01254', 'Api para sincronizar bom con crm.', '/compsolutionmanagement/synchronizeBom', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '0f580d08-ac62-4826-8f94-fa96e038fd7d', 'Api para consultar solicitud', '/solicitud/consultaSolicitudPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'bc7fe634-88d9-4888-bc47-a05f56c45b3b', 'Api para consultar solicitudes asociadas', '/solicitud/consultaSolicitudesAsociadas', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'be07c3a9-7389-4a7a-9dd4-376b3d9372e5', 'Api para consultar Tareas Por Tipo Tarea', '/tareas/consultaTareasPorTipoTarea', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	/**************************************************************************************************************************************/
	/***************************************************PERMISOS CALCULADORA******************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ccd4229b-3ba5-4f75-91f9-c6f9f3d9e89f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd43e5723-b897-415e-a973-aeaee88ff553'),'Permiso para consultar el endpoint de getAllInitialData','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'acbb1f23-51af-461c-ba56-1b5b43d6bdca',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '22aba4a9-371c-45fc-b088-c0f4b198842a'),'Permiso para consultar apus','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'11f26352-b461-49fa-b8c4-65be86e93b66',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '8c9de3cd-bec1-40ee-89e9-45764074f901'),'Permiso para consultar apus','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'a5160060-7865-4439-a4bb-98410f12d284',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e298b2b4-6b01-472f-9c1d-6c8250078cf5'),'Permiso para crear apus','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ce685d7a-cdd3-4b07-b378-1dd406b684eb',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0d9b7592-5d3b-4dcb-816f-acc3b35e8759'),'Permiso para editar apus','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'a53f7f98-863d-4117-ae20-857092fb2154',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'add48a26-02d4-442f-a155-c9a711dde0a4'),'Permiso para eliminar apus','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'6e04a02b-e11b-41bf-bc31-1e55f6172e2f',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'af966da0-89df-4231-bf69-512c196de83d'),'Api para obtener listado de materiales.','Activo','cas', now(),'127.0.0.1',null,null,null);
		
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c17f4424-c7b6-4e52-97b9-61d37cc216ec',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c62875b6-9fe5-4d5c-99a3-a14578f2bcf7'),'Permiso para listar productos.','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'abffcde8-1ae5-4128-bfd9-e969dc01d6e4',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '44491130-ce92-4679-af7f-493e22353e8c'),'Permiso para listar apus y materiales.','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'2f35d349-d1a1-457c-9309-a6ff0814091d',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '6be9108c-39de-40b0-9317-a448c662486b'),'Permiso para listar marcas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e4c3f281-cf69-4d2e-830f-fa2542e440f4',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'a09c2bc0-0b82-48ae-bf81-14b73aef4446'),'Permiso para listar modelos.','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9243dcdf-b7ef-43dd-9b4d-58b91bc77740',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '5ecbe543-4f51-439c-a840-7398d3211879'),'Permiso para listar tareas con filtros opcionales.','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'482aa537-55f3-4403-8be7-691166b73dd3',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e74b49b0-aebd-4dad-99ad-f0f24aaec2d3'),'Permiso para crear inspecciones.','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'56bddd3f-6285-4838-88fe-81beb1a8c7a0',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '69bbf39d-da04-47a8-b88c-1303e8b7a18d'),'Permiso para aprobar inspecciones.','Activo','cas', now(),'127.0.0.1',null,null,null);
		
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'3d7a7f58-4868-4d60-b456-26996ee13b21',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c7352186-5a42-4add-89c1-c2dbfa2d5a3e'),'Permiso para rechazar inspecciones.','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'ccfcc592-d2e1-4f09-9b05-82bc4663db39',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'b2dfa74d-1bb1-49cc-bd5c-7acb00d01254'),'Permiso para sincronizar bom con crm.','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'550d6913-5417-44d3-8e45-6b1c8ab0bb12',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '0f580d08-ac62-4826-8f94-fa96e038fd7d'),'Permiso para consultar solicitudes','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e22c64ce-45a5-410f-97e6-48d2c1e30099',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'bc7fe634-88d9-4888-bc47-a05f56c45b3b'),'Permiso para consultar solicitudes asociadas','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'eb2c6675-3791-42fc-93f0-c87f2911e9c7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'be07c3a9-7389-4a7a-9dd4-376b3d9372e5'),'Permiso para consultar tareas.','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	
	/**************************************************************************************************************************************/
	/***************************************************ASIGNACION DE PERMISOS A ROLES CALCULADORA********************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	/**ROL Coordinador**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ccd4229b-3ba5-4f75-91f9-c6f9f3d9e89f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'acbb1f23-51af-461c-ba56-1b5b43d6bdca'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '11f26352-b461-49fa-b8c4-65be86e93b66'),'Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'a5160060-7865-4439-a4bb-98410f12d284'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ce685d7a-cdd3-4b07-b378-1dd406b684eb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'a53f7f98-863d-4117-ae20-857092fb2154'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '6e04a02b-e11b-41bf-bc31-1e55f6172e2f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'c17f4424-c7b6-4e52-97b9-61d37cc216ec'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'abffcde8-1ae5-4128-bfd9-e969dc01d6e4'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '2f35d349-d1a1-457c-9309-a6ff0814091d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e4c3f281-cf69-4d2e-830f-fa2542e440f4'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9243dcdf-b7ef-43dd-9b4d-58b91bc77740'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '482aa537-55f3-4403-8be7-691166b73dd3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '56bddd3f-6285-4838-88fe-81beb1a8c7a0'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '3d7a7f58-4868-4d60-b456-26996ee13b21'),'Activo','cas', now(),'127.0.0.1',null,null,null);


    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ccfcc592-d2e1-4f09-9b05-82bc4663db39'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = '550d6913-5417-44d3-8e45-6b1c8ab0bb12'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e22c64ce-45a5-410f-97e6-48d2c1e30099'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'eb2c6675-3791-42fc-93f0-c87f2911e9c7'),'Activo','cas', now(),'127.0.0.1',null,null,null);


	/**ROL Empleado**/

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ccd4229b-3ba5-4f75-91f9-c6f9f3d9e89f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'acbb1f23-51af-461c-ba56-1b5b43d6bdca'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '11f26352-b461-49fa-b8c4-65be86e93b66'),'Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'a5160060-7865-4439-a4bb-98410f12d284'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ce685d7a-cdd3-4b07-b378-1dd406b684eb'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'a53f7f98-863d-4117-ae20-857092fb2154'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '6e04a02b-e11b-41bf-bc31-1e55f6172e2f'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'c17f4424-c7b6-4e52-97b9-61d37cc216ec'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'abffcde8-1ae5-4128-bfd9-e969dc01d6e4'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '2f35d349-d1a1-457c-9309-a6ff0814091d'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e4c3f281-cf69-4d2e-830f-fa2542e440f4'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9243dcdf-b7ef-43dd-9b4d-58b91bc77740'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '482aa537-55f3-4403-8be7-691166b73dd3'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '56bddd3f-6285-4838-88fe-81beb1a8c7a0'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '3d7a7f58-4868-4d60-b456-26996ee13b21'),'Activo','cas', now(),'127.0.0.1',null,null,null);


    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'ccfcc592-d2e1-4f09-9b05-82bc4663db39'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = '550d6913-5417-44d3-8e45-6b1c8ab0bb12'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e22c64ce-45a5-410f-97e6-48d2c1e30099'),'Activo','cas', now(),'127.0.0.1',null,null,null);

    INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'eb2c6675-3791-42fc-93f0-c87f2911e9c7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	
end $$;
