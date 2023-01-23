/*
 * Debe ejecutarse en esquema Public de SSO
 * @author Kevin Baque Puya <kbaque@telconet.ec>
 * @version 1.0 30-11-2022
 */

/** Configuración de Gestión de Licitación para el autorizador **/

DO $$
	DECLARE
	    intSecuenciaAplicacion int;
        strUrlSitio varchar(200) = 'https://sites.telconet.ec/licitacion/';
BEGIN

   	SELECT nextval('seq_admi_aplicacion')  INTO intSecuenciaAplicacion;
    
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.admi_aplicacion
	(id_aplicacion, codigo, empresa_id, nombre, url_dominio, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(intSecuenciaAplicacion, '5d79f14e-1457-4446-8f71-d3b555f50239', (select ae.id_empresa from admi_empresa ae where ae.codigo  = '45ad3d30-bc98-41b4-8d89-ad0cd027f5d0' and lower(ae.nombre)='telconet'), 'Gestion de Licitacion', strUrlSitio, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
	/**************************************************************************************************************************************/
	/********************************************************ROLES*************************************************************************/

	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), '9672ad20-1619-495a-940c-44edb7985523', 'bossRole', intSecuenciaAplicacion, NULL, 'Rol para empleados con cargo de Jefe', 'N', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);
		
	INSERT INTO public.admi_rol
	(id_rol, codigo, nombre, aplicacion_id, rol_id, descripcion, valida_contexto, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_admi_rol'), 'e7207e98-7244-4e8e-ad5b-f0d590789ee0', 'employeeRole', intSecuenciaAplicacion, NULL, 'Rol para empleados con cargo de asistente y ayudante', 'N', 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL);	
	/**************************************************************************************************************************************/
	/***************************************************RECURSOS***************************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '553b858d-36ba-46d7-acd5-8e479b27cf70', 'Api que permite listar los tender', '/gestionLicitacion/getTendersListBy', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '355cb16e-81b3-4ac9-9289-02e3b2258f20', 'Api que permite listar los detalle del tender', '/gestionLicitacion/getTenderDetails', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '1d6adedd-bf1f-43ad-9f92-0b769b75c2b8', 'Api que permite asignar usuarios al tender', '/gestionLicitacion/assignTenderToUser', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '60f30603-1e70-4f1b-baf5-e11eb42ece4a', 'Api que permite categorizar los detalles del tender', '/gestionLicitacion/setTenderCategories', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c8e80418-919f-4032-9d04-4795285c32c9', 'Api que permite ingresar una publicación en la aplicación de Katuk', '/gestionLicitacion/sendTenderToKatuk', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
    INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '30d8ede1-aa3c-46a3-92a1-8538eb1e56ef', 'Api que permite listar los catálogos de katuk', '/gestionLicitacion/getKatukCategories', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '645e0dad-bf39-4d97-bf71-4ec732e70bf3', 'Api que permite editar los datos del tenderCab', '/gestionLicitacion/editInfoTenderCab', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '8a83047d-eb84-4804-aa91-0c86ee54ab86', 'Api que permite editar el valor unitario del tender', '/gestionLicitacion/editInfoTenderDet', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '7bac6627-996d-4b94-b9fc-56c7527b5270', 'Api que permite actualizar el tender con las novedades de la publicación', '/gestionLicitacion/getUpdatewebhookTender', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), '1b90d9c5-9707-4f64-9fdc-bf328ff33f61', 'Api que permite ejecutar el agregador', '/gestionLicitacion/aggregateTender', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'c0f9e796-5481-4161-adfb-078170ff795e', 'Api que retorna el listado de empleados de un departamento', '/empleados/ListaEmpleadosDpto', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'd926cecf-80bc-4348-b36a-6bfd8fd5c309', 'Api que retorna la lista de parametros cab con filtros', '/parametros/listaParametroCabPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);
	
	INSERT INTO public.info_recurso
	(id_recurso, codigo, descripcion, ruta, tipo_recurso, recurso_id, tipo_componente, id_componente, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod, icono, orden)
	VALUES(nextval('seq_info_recurso'), 'e79bd948-c90f-45ef-b6c1-21575cbe0d4e', 'Api que retorna la lista de parametros det con filtros', '/parametros/listaParametroDetPor', 'API', NULL, NULL, NULL, 'Activo', 'cas', now(), '127.0.0.1', NULL, NULL, NULL, NULL, 0);

	/**************************************************************************************************************************************/
	/***************************************************PERMISOS **************************************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'5eabd102-c786-4931-bee6-2fad3b78ea28',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '553b858d-36ba-46d7-acd5-8e479b27cf70'),'Permiso para listar los tender','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'52564a2f-5b77-4f6c-88dc-e3c4ab898275',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '355cb16e-81b3-4ac9-9289-02e3b2258f20'),'Permiso para listar los detalle del tender','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e5d4f4a3-cfa6-492d-a2e8-1126f6d5aa42',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '1d6adedd-bf1f-43ad-9f92-0b769b75c2b8'),'Permiso para asignar usuarios al tender','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'caa2b369-b29b-4119-b310-eb55178642c9',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '60f30603-1e70-4f1b-baf5-e11eb42ece4a'),'Permiso para categorizar los detalles del tender','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9d25fb82-a076-4389-b9d7-3f593a554bf7',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c8e80418-919f-4032-9d04-4795285c32c9'),'Permiso para ingresar una publicación en la aplicación de Katuk','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'8c77d2a8-2a18-4194-b492-7bfbe8334e8b',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '30d8ede1-aa3c-46a3-92a1-8538eb1e56ef'),'Permiso para listar los catálogos de katuk','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'9ba7241c-3137-45e2-bc8f-25f4b0bccf67',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '645e0dad-bf39-4d97-bf71-4ec732e70bf3'),'Permiso para editar los datos del tenderCab','Activo','cas', now(),'127.0.0.1',null,null,null);
		
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'3c62b835-09af-40d3-a049-ccc9245e4a40',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '8a83047d-eb84-4804-aa91-0c86ee54ab86'),'Permiso para editar el valor unitario del tender','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'52b80f35-2b69-4b81-a9cc-7f59148efc31',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '7bac6627-996d-4b94-b9fc-56c7527b5270'),'Permiso para actualizar el tender con las novedades de la publicación','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'62e54d4f-f91e-4df2-ae8c-7ceb7347f228',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = '1b90d9c5-9707-4f64-9fdc-bf328ff33f61'),'Permiso para ejecutar el agregador','Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'c71bdf1b-ebbd-4ac1-b512-c9c6f37eecc1',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'c0f9e796-5481-4161-adfb-078170ff795e'),'Permiso para listar los empleados de un departamento','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'f6d671a5-dc8e-4983-9d88-02e4f0e285d2',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'd926cecf-80bc-4348-b36a-6bfd8fd5c309'),'Permiso para listar los parametros cab con filtros','Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_permiso
	(id_permiso, codigo, operacion_id, recurso_id,nombre, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_permiso'),'e4fb20a7-d727-46ec-abdd-ea7564b3cb6c',(select ao.id_operacion from admi_operacion ao where ao.codigo = '3ce622a3-d1c2-44ca-8059-3e512bf9593f'),(select ir.id_recurso from info_recurso ir where ir.codigo = 'e79bd948-c90f-45ef-b6c1-21575cbe0d4e'),'Permiso para listar los parametros det con filtros','Activo','cas', now(),'127.0.0.1',null,null,null);

	/**************************************************************************************************************************************/
	/***************************************************ASIGNACION DE PERMISOS A ROLES ****************************************************/
	/**************************************************************************************************************************************/
	/**************************************************************************************************************************************/

	/**ROL bossRole**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5eabd102-c786-4931-bee6-2fad3b78ea28'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '52564a2f-5b77-4f6c-88dc-e3c4ab898275'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e5d4f4a3-cfa6-492d-a2e8-1126f6d5aa42'),'Activo','cas', now(),'127.0.0.1',null,null,null);
	
	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'caa2b369-b29b-4119-b310-eb55178642c9'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9d25fb82-a076-4389-b9d7-3f593a554bf7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '8c77d2a8-2a18-4194-b492-7bfbe8334e8b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9ba7241c-3137-45e2-bc8f-25f4b0bccf67'),'Activo','cas', now(),'127.0.0.1',null,null,null);


	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '3c62b835-09af-40d3-a049-ccc9245e4a40'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = '52b80f35-2b69-4b81-a9cc-7f59148efc31'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'c71bdf1b-ebbd-4ac1-b512-c9c6f37eecc1'),'Activo','cas', now(),'127.0.0.1',null,null,null);	


	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f6d671a5-dc8e-4983-9d88-02e4f0e285d2'),'Activo','cas', now(),'127.0.0.1',null,null,null);	

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = '9672ad20-1619-495a-940c-44edb7985523'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e4fb20a7-d727-46ec-abdd-ea7564b3cb6c'),'Activo','cas', now(),'127.0.0.1',null,null,null);	


	/**ROL employeeRole**/

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '5eabd102-c786-4931-bee6-2fad3b78ea28'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '52564a2f-5b77-4f6c-88dc-e3c4ab898275'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'caa2b369-b29b-4119-b310-eb55178642c9'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9d25fb82-a076-4389-b9d7-3f593a554bf7'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '8c77d2a8-2a18-4194-b492-7bfbe8334e8b'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '9ba7241c-3137-45e2-bc8f-25f4b0bccf67'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '3c62b835-09af-40d3-a049-ccc9245e4a40'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = '52b80f35-2b69-4b81-a9cc-7f59148efc31'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'f6d671a5-dc8e-4983-9d88-02e4f0e285d2'),'Activo','cas', now(),'127.0.0.1',null,null,null);

	INSERT INTO public.info_rol_permiso
	(id_rol_permiso, rol_id, permiso_id, estado, usr_creacion, fe_creacion, ip_creacion, usr_ult_mod, fe_ult_mod, ip_ult_mod)
	VALUES(nextval('seq_info_rol_permiso'),(select ar.id_rol from admi_rol ar where ar.codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0'),(select ip.id_permiso from info_permiso ip where ip.codigo = 'e4fb20a7-d727-46ec-abdd-ea7564b3cb6c'),'Activo','cas', now(),'127.0.0.1',null,null,null);

end $$;
