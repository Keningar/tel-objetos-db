/*
 * Debe ejecutarse en esquema Public de SSO
 * @author Luis Ardila <lardila@telconet.ec>
 * @version 1.0 01-12-2022 - Versión Inicial.
 */

/** Elimina Configuración de permisos de Calculadora para el autorizador **/

delete from info_rol_permiso irp  where irp.rol_id in (
	select
	ar.id_rol 
from
	admi_rol ar
where
	ar.aplicacion_id = (
	select
		aa.id_aplicacion
	from
		admi_aplicacion aa
	where
		aa.codigo = 'f1396beb-578c-457e-ab0c-25aff840d439')
	);

delete from info_permiso where codigo = 'ccd4229b-3ba5-4f75-91f9-c6f9f3d9e89f';
delete from info_permiso where codigo = 'acbb1f23-51af-461c-ba56-1b5b43d6bdca';
delete from info_permiso where codigo = '11f26352-b461-49fa-b8c4-65be86e93b66';
delete from info_permiso where codigo = 'a5160060-7865-4439-a4bb-98410f12d284';
delete from info_permiso where codigo = 'ce685d7a-cdd3-4b07-b378-1dd406b684eb';
delete from info_permiso where codigo = 'a53f7f98-863d-4117-ae20-857092fb2154';
delete from info_permiso where codigo = '6e04a02b-e11b-41bf-bc31-1e55f6172e2f';
delete from info_permiso where codigo = 'c17f4424-c7b6-4e52-97b9-61d37cc216ec';
delete from info_permiso where codigo = 'abffcde8-1ae5-4128-bfd9-e969dc01d6e4';
delete from info_permiso where codigo = '2f35d349-d1a1-457c-9309-a6ff0814091d';
delete from info_permiso where codigo = 'e4c3f281-cf69-4d2e-830f-fa2542e440f4';
delete from info_permiso where codigo = '9243dcdf-b7ef-43dd-9b4d-58b91bc77740';
delete from info_permiso where codigo = '482aa537-55f3-4403-8be7-691166b73dd3';
delete from info_permiso where codigo = '56bddd3f-6285-4838-88fe-81beb1a8c7a0';
delete from info_permiso where codigo = '3d7a7f58-4868-4d60-b456-26996ee13b21';
delete from info_permiso where codigo = 'ccfcc592-d2e1-4f09-9b05-82bc4663db39';
delete from info_permiso where codigo = '550d6913-5417-44d3-8e45-6b1c8ab0bb12';
delete from info_permiso where codigo = 'e22c64ce-45a5-410f-97e6-48d2c1e30099';
delete from info_permiso where codigo = 'eb2c6675-3791-42fc-93f0-c87f2911e9c7';

delete from info_recurso where codigo = 'd43e5723-b897-415e-a973-aeaee88ff553';
delete from info_recurso where codigo = '22aba4a9-371c-45fc-b088-c0f4b198842a';
delete from info_recurso where codigo = '8c9de3cd-bec1-40ee-89e9-45764074f901';
delete from info_recurso where codigo = 'e298b2b4-6b01-472f-9c1d-6c8250078cf5';
delete from info_recurso where codigo = '0d9b7592-5d3b-4dcb-816f-acc3b35e8759';
delete from info_recurso where codigo = 'add48a26-02d4-442f-a155-c9a711dde0a4';
delete from info_recurso where codigo = 'af966da0-89df-4231-bf69-512c196de83d';
delete from info_recurso where codigo = 'c62875b6-9fe5-4d5c-99a3-a14578f2bcf7';
delete from info_recurso where codigo = '44491130-ce92-4679-af7f-493e22353e8c';
delete from info_recurso where codigo = '6be9108c-39de-40b0-9317-a448c662486b';
delete from info_recurso where codigo = 'a09c2bc0-0b82-48ae-bf81-14b73aef4446';
delete from info_recurso where codigo = '5ecbe543-4f51-439c-a840-7398d3211879';
delete from info_recurso where codigo = 'e74b49b0-aebd-4dad-99ad-f0f24aaec2d3';
delete from info_recurso where codigo = '69bbf39d-da04-47a8-b88c-1303e8b7a18d';
delete from info_recurso where codigo = 'c7352186-5a42-4add-89c1-c2dbfa2d5a3e';
delete from info_recurso where codigo = 'b2dfa74d-1bb1-49cc-bd5c-7acb00d01254';
delete from info_recurso where codigo = '0f580d08-ac62-4826-8f94-fa96e038fd7d';
delete from info_recurso where codigo = 'bc7fe634-88d9-4888-bc47-a05f56c45b3b';
delete from info_recurso where codigo = 'be07c3a9-7389-4a7a-9dd4-376b3d9372e5';

delete from admi_rol where codigo = '07d869e2-0eaa-4cae-8c03-515ab45c2a43';
delete from admi_rol where codigo = '8f209644-7f65-4155-b1c6-7af6dc76c8d3';

delete from admi_aplicacion where codigo = 'f1396beb-578c-457e-ab0c-25aff840d439';
