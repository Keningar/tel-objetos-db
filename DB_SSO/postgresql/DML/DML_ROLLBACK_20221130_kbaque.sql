/*
 * Debe ejecutarse en esquema Public de SSO
 * @author Kevin Baque Puya <kbaque@telconet.ec>
 * @version 1.0 30-11-2022
 */

/** Elimina Configuración de permisos de Gestión de Licitación para el autorizador **/

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
		aa.codigo = '5d79f14e-1457-4446-8f71-d3b555f50239')
	);

delete from info_permiso where codigo = '5eabd102-c786-4931-bee6-2fad3b78ea28';
delete from info_permiso where codigo = '52564a2f-5b77-4f6c-88dc-e3c4ab898275';
delete from info_permiso where codigo = 'e5d4f4a3-cfa6-492d-a2e8-1126f6d5aa42';
delete from info_permiso where codigo = 'caa2b369-b29b-4119-b310-eb55178642c9';
delete from info_permiso where codigo = '9d25fb82-a076-4389-b9d7-3f593a554bf7';
delete from info_permiso where codigo = '8c77d2a8-2a18-4194-b492-7bfbe8334e8b';
delete from info_permiso where codigo = '9ba7241c-3137-45e2-bc8f-25f4b0bccf67';
delete from info_permiso where codigo = '3c62b835-09af-40d3-a049-ccc9245e4a40';
delete from info_permiso where codigo = '52b80f35-2b69-4b81-a9cc-7f59148efc31';
delete from info_permiso where codigo = 'c71bdf1b-ebbd-4ac1-b512-c9c6f37eecc1';
delete from info_permiso where codigo = 'f6d671a5-dc8e-4983-9d88-02e4f0e285d2';
delete from info_permiso where codigo = 'e4fb20a7-d727-46ec-abdd-ea7564b3cb6c';


delete from info_recurso where codigo = '553b858d-36ba-46d7-acd5-8e479b27cf70';
delete from info_recurso where codigo = '355cb16e-81b3-4ac9-9289-02e3b2258f20';
delete from info_recurso where codigo = '1d6adedd-bf1f-43ad-9f92-0b769b75c2b8';
delete from info_recurso where codigo = '60f30603-1e70-4f1b-baf5-e11eb42ece4a';
delete from info_recurso where codigo = 'c8e80418-919f-4032-9d04-4795285c32c9';
delete from info_recurso where codigo = '30d8ede1-aa3c-46a3-92a1-8538eb1e56ef';
delete from info_recurso where codigo = '645e0dad-bf39-4d97-bf71-4ec732e70bf3';
delete from info_recurso where codigo = '8a83047d-eb84-4804-aa91-0c86ee54ab86';
delete from info_recurso where codigo = '7bac6627-996d-4b94-b9fc-56c7527b5270';
delete from info_recurso where codigo = 'c0f9e796-5481-4161-adfb-078170ff795e';
delete from info_recurso where codigo = 'd926cecf-80bc-4348-b36a-6bfd8fd5c309';
delete from info_recurso where codigo = 'e79bd948-c90f-45ef-b6c1-21575cbe0d4e';


delete from admi_rol where codigo = '9672ad20-1619-495a-940c-44edb7985523';
delete from admi_rol where codigo = 'e7207e98-7244-4e8e-ad5b-f0d590789ee0';


delete from admi_aplicacion where codigo = '5d79f14e-1457-4446-8f71-d3b555f50239';