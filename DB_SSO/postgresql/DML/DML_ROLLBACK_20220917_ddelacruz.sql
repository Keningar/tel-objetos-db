/*
 * Debe ejecutarse en esquema Public de SSO
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 17-09-2022 - Versión Inicial.
 */

/** Elimina Configuración de permisos de Extranet para el autorizador **/

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
		aa.codigo = '38b386fd-a7a1-48d3-8689-cc78134c590b')
	);

delete from info_permiso where codigo = '8edf7e98-8b0e-4f12-8efe-8d51eb017cee';
delete from info_permiso where codigo = '79677f8f-5a6b-4544-8290-cfad24a092fa';
delete from info_permiso where codigo = '4f5d5fc3-e403-4535-8797-ab70b49cbe40';
delete from info_permiso where codigo = '97e1f1ec-1312-4c72-bc63-2cbbba47b419';
delete from info_permiso where codigo = 'df6be120-b072-4740-a77f-8f56d450f643';
delete from info_permiso where codigo = '82bdc9a8-67cf-4a43-b977-13b1fd3c30d6';
delete from info_permiso where codigo = '5ef4b982-4f92-4881-980c-5392a2fdee95';
delete from info_permiso where codigo = '9c2cb9f8-f20c-43e9-a2e0-2fe4529cece5';
delete from info_permiso where codigo = 'bdb89448-1ada-4be9-b4ed-c4626627f3f3';
delete from info_permiso where codigo = 'c2a1784e-e59b-47e7-99aa-0c1b92577e7a';
delete from info_permiso where codigo = 'e764de6d-f30a-438a-990a-b1e61ba1e665';
delete from info_permiso where codigo = '106548a4-ad1f-4f05-8566-2c6a1330c14e';
delete from info_permiso where codigo = '6afd94fd-6449-49e1-8f1b-30a8e8c1f7c8';
delete from info_permiso where codigo = '5eb4d673-7663-4f49-ba21-45f7ab7b360b';
delete from info_permiso where codigo = '6390aff7-4445-487c-b7ab-51c66cad5e4a';
delete from info_permiso where codigo = '84fce2e8-2ecd-4447-ad8f-718dc0308799';
delete from info_permiso where codigo = 'f8fec167-f382-4ebf-bf1e-d607a6135a5f';
delete from info_permiso where codigo = '9b3b58c9-9948-4d2d-babd-ddeeffc84a2c';
delete from info_permiso where codigo = '00c783df-2a9e-4f5f-a15f-b5beef20a8eb';
delete from info_permiso where codigo = 'a08e1795-03ad-4aa7-86bd-dd843ea0473c';
delete from info_permiso where codigo = '98d5dcb7-557a-4f28-8dcb-bdb21151e009';
delete from info_permiso where codigo = '1e92b612-409f-4c61-a9a1-0c7ebec7a1a8';
delete from info_permiso where codigo = '4ea76fe4-5af8-4eb6-8aa8-6e9d2e95f5d8';
delete from info_permiso where codigo = 'ac3fff5f-5be7-43d4-a6b1-6de50b53a6b4';
delete from info_permiso where codigo = '71a58c0e-cde9-4aa9-8af8-84dcb527fd3d';
delete from info_permiso where codigo = 'dc2c7d6b-22b9-481f-aba1-bed5bbfe187d';
delete from info_permiso where codigo = '66db2b02-fbae-4b92-8cd4-073362b17acd';
delete from info_permiso where codigo = 'c7a8da74-819c-400a-a881-7cf9a538550f';
delete from info_permiso where codigo = '4c4ced3c-2308-4bec-aadd-5b50b4e23cc0';
delete from info_permiso where codigo = 'e73e9b66-b65c-4e43-85d9-6df8ab8469dc';
delete from info_permiso where codigo = '6d06e654-45f8-4fbe-853b-bd12660f5a2f';
delete from info_permiso where codigo = '833fd33c-a54e-4245-a089-6f5d25d32544';
delete from info_permiso where codigo = '8b26c0ef-c1a9-41bf-9c17-24fb4da0beeb';
delete from info_permiso where codigo = 'e0f9efcb-c552-4775-a0d6-d5e4ce093dc3';
delete from info_permiso where codigo = 'cdd1130d-a077-4c47-8f0e-64e8be29a1a9';
delete from info_permiso where codigo = '074d4fc4-6d48-44df-809c-258beced2aa9';
delete from info_permiso where codigo = '7343a1e1-1683-4f46-8e42-ed0b63393b8c';
delete from info_permiso where codigo = 'adb95dcf-e98b-48b9-bb60-34be36edf9d2';
delete from info_permiso where codigo = 'f94d07ee-1bca-4c24-904d-b3adf6972d81';
delete from info_permiso where codigo = 'cc30e295-5e53-4b9e-ae7b-6836db27fd01';
delete from info_permiso where codigo = 'ed7fddcf-3384-45dd-9026-f7ba13eb3633';
delete from info_permiso where codigo = '541c248d-ce2a-4708-b193-6be4c26dbdc5';
delete from info_permiso where codigo = '13bdf2d3-b364-47be-9577-1f3f2c84ffe5';
delete from info_permiso where codigo = 'f1df8aa0-047d-4d40-a644-3f3632556ec7';
delete from info_permiso where codigo = '8af7c4b8-d166-4b44-8e2b-3cad126007b7';
delete from info_permiso where codigo = '0db3c82b-f6d7-483e-afb1-29d3b2a3fcf7';
delete from info_permiso where codigo = '019b427e-eb85-44b4-b096-1d24afb164ca';
delete from info_permiso where codigo = 'cfa16802-d6f4-42ea-904a-a34d521c001c';
delete from info_permiso where codigo = 'ea52b2a1-fb7c-46ec-a2af-4e157aa6446e';
delete from info_permiso where codigo = 'd6dca8c3-c4da-4468-b510-dd857c80867d';
delete from info_permiso where codigo = 'f06ffddc-d280-4189-abd4-26522d610121';
delete from info_permiso where codigo = '2bd749ec-833a-46af-b80f-252dffab3519';
delete from info_permiso where codigo = '4065f0d2-09ee-48ed-bda6-66e037973289';
delete from info_permiso where codigo = 'bdda1d9a-5fc4-43ca-b81d-9a337d85fbcb';
delete from info_permiso where codigo = 'd8103b06-10fa-4364-babe-f7b1058631b7';
delete from info_permiso where codigo = '5de6032e-bdb9-44d3-9466-ea004043cd30';
delete from info_permiso where codigo = 'ed5faeaa-5bbb-4d44-9559-275e89931263';
delete from info_permiso where codigo = 'b37806e2-6813-49e3-ae4a-82f9e837765f';
delete from info_permiso where codigo = '1c382647-96f9-43cd-9b5f-6461c46c819c';
delete from info_permiso where codigo = 'af910ead-96e0-438d-9bfe-07010d130ffa';
delete from info_permiso where codigo = '36199890-aa76-4114-92ab-aa1cd11f96de';
delete from info_permiso where codigo = 'deba77cd-c875-400d-a28c-0a15137fbb8b';
delete from info_permiso where codigo = '53da41b0-849f-47a5-a651-5b422a0ac5d3';
delete from info_permiso where codigo = '24e37ba9-b38c-4c5a-9571-364ccfcf424b';
delete from info_permiso where codigo = '7c8f85af-019f-4d46-b63d-fa253083d983';
delete from info_permiso where codigo = 'e9f069a0-b884-4236-a980-100c413688d3';
delete from info_permiso where codigo = 'a773686d-7e3c-4e63-8997-f2ab9d1d2905';
delete from info_permiso where codigo = '11bef008-cee5-412e-b796-b27053d1937d';
delete from info_permiso where codigo = '3bd45653-ed4c-44ad-8acb-1b2c6230b794';


delete from info_recurso where codigo = '878fc8b5-e80d-4833-9f53-5058795df454';
delete from info_recurso where codigo = '2f0b79e5-4656-4381-9f0b-35d4a64a1559';
delete from info_recurso where codigo = 'a04d72c2-9b3f-4cbd-baf2-359ed475eba1';
delete from info_recurso where codigo = 'aea3edfd-02e9-44fd-a476-6b5c244beee9';
delete from info_recurso where codigo = '9440db3a-6ec7-49c0-bd9e-b5bca3cd0eec';
delete from info_recurso where codigo = 'dc218e9c-8a8f-4ace-bf22-b2e3d9dd7d6b';
delete from info_recurso where codigo = '0bce5c19-fd5d-4bb7-9860-bedea1dd369d';
delete from info_recurso where codigo = '511043ca-dbab-4876-9c15-a6b926372acc';
delete from info_recurso where codigo = '0d67e9e7-9d35-40cd-8dcd-1cf6d5383731';
delete from info_recurso where codigo = '5283433b-93b3-462b-9048-682af2bdf345';
delete from info_recurso where codigo = 'f80ecd9d-2431-48c6-a8c1-bb59dcbffa2d';
delete from info_recurso where codigo = 'ceecc40b-983f-4903-93aa-217a32d0361c';
delete from info_recurso where codigo = '76b2adf5-d7db-48da-bccf-958ca2078275';
delete from info_recurso where codigo = '603ac4c0-aef7-4f7b-bc6d-0e4bdc3d7442';
delete from info_recurso where codigo = 'a67f3701-2767-436a-9469-6b8e9fb72b38';
delete from info_recurso where codigo = '80db2109-632d-4afd-b00c-b92dc72a5888';
delete from info_recurso where codigo = 'd73815f9-b218-4b1f-9036-84a116f787fb';
delete from info_recurso where codigo = '37c93b92-5523-4e90-a11b-04407b4a30d1';
delete from info_recurso where codigo = 'b99dc078-4e90-4d5b-b479-8dd4072ad12b';
delete from info_recurso where codigo = 'be05b8f1-b57c-443a-922a-4c65ab909858';
delete from info_recurso where codigo = 'e3f40357-94ba-479b-b821-665b37021dcc';
delete from info_recurso where codigo = '01531f6c-c0b3-476b-8516-5365a7005588';
delete from info_recurso where codigo = 'eb14d25a-894b-4c20-8914-32b03b21180a';
delete from info_recurso where codigo = '6f71c9d9-c8c9-4af4-89f6-8dbd359cb00d';
delete from info_recurso where codigo = 'f3f98fb1-a13c-410a-9dfd-0085ed848aee';
delete from info_recurso where codigo = '70ec606e-f46d-4c6d-a086-0ef4ccf7a29c';
delete from info_recurso where codigo = 'e38dffed-ed97-4c97-b8d2-6c6a6fd5ee01';
delete from info_recurso where codigo = '9ad10cc8-dcc7-4d69-889f-8a8eedbc670f';
delete from info_recurso where codigo = 'fc70ab5b-f36a-4f8f-8cd8-dea5b88d8470';
delete from info_recurso where codigo = 'da41e048-b483-4ecc-9b74-3e25ffeb7402';
delete from info_recurso where codigo = '16ca8076-89de-4dc2-846f-5daac88f6906';
delete from info_recurso where codigo = '5f947267-b689-4092-87a1-c377e2414c2e';
delete from info_recurso where codigo = '984a6989-eedd-4c11-9592-1b1adae11552';
delete from info_recurso where codigo = '4b4fafa3-609c-4ef3-9ac1-c0fdd978c4e8';
delete from info_recurso where codigo = 'cabddefa-9ac2-43a1-8487-9415966dac2c';
delete from info_recurso where codigo = 'e37271a4-c4eb-4fca-902f-1d200effae06';
delete from info_recurso where codigo = 'aa533d49-6e2c-4679-8748-c245e0fe1632';
delete from info_recurso where codigo = '4d2d5fd3-48ae-4681-90b4-d3dd68cd9d43';
delete from info_recurso where codigo = '152ddc80-b6a9-4654-a4a8-652c3a9b40ec';
delete from info_recurso where codigo = 'e2cfb33a-4bac-4a4c-bce0-afe6cb83e8c3';
delete from info_recurso where codigo = '88966cf3-4694-40fc-b09a-f65f503fb52d';
delete from info_recurso where codigo = '99fdb14f-e7a2-4a91-a5a9-fd06a31e32e2';
delete from info_recurso where codigo = '3c5ab839-7b42-4f86-8983-4c2ca5bef222';
delete from info_recurso where codigo = '82e9c6d5-e2bf-4783-b744-548889474f22';
delete from info_recurso where codigo = '19c132a0-81c3-49f4-ad0e-72b774b52c4c';
delete from info_recurso where codigo = '32c668e3-a94b-432b-977f-773237915f6b';
delete from info_recurso where codigo = '139fc119-5369-4471-aa80-daced053cf64';
delete from info_recurso where codigo = 'db80d388-38a8-42f2-a826-1f05d5bfc47a';
delete from info_recurso where codigo = '3ef6bfaa-5da7-4f67-85fc-8492e0d4309c';
delete from info_recurso where codigo = '73f1db23-5207-46e0-becc-3e3eb4d4d490';
delete from info_recurso where codigo = '49a1d803-41eb-4385-be60-2fc7fe339948';
delete from info_recurso where codigo = '6026d796-8adb-4a62-bc35-38a63a340824';
delete from info_recurso where codigo = '36e6f52d-41f3-416a-8a2f-97d920f6f814';
delete from info_recurso where codigo = '44214849-c32c-4ce2-b2ae-357d70b77a89';
delete from info_recurso where codigo = '9a720f04-0759-4580-b853-8a78453ba043';
delete from info_recurso where codigo = 'f647ba86-f479-4fab-b79a-22e6f20762fc';
delete from info_recurso where codigo = '8d809333-85f1-43f4-b2b6-56a182d04624';
delete from info_recurso where codigo = '951826a8-cdb0-4cca-ac1d-68bb95e2f1e7';
delete from info_recurso where codigo = '928e1ac2-9b8f-41a9-a88b-4d51dcaf069b';
delete from info_recurso where codigo = 'cd16b661-cf22-4be2-97cb-787f81396607';
delete from info_recurso where codigo = '935bc13c-a3c6-4909-9511-0abdf78411f2';
delete from info_recurso where codigo = '6819c371-aeab-4765-b2ea-2630f1091c58';
delete from info_recurso where codigo = '8750fc64-2069-496f-afc1-8f27307ff770';
delete from info_recurso where codigo = 'af57988d-c311-4bf3-9f0b-0de2916aa949';
delete from info_recurso where codigo = 'da6fba65-a38e-4318-b5f9-8b9df0f60fa0';
delete from info_recurso where codigo = 'dff86b75-4166-4f74-92b5-a640ddb6cd51';
delete from info_recurso where codigo = '404d50c8-9399-4e89-abd0-d1e15ce31b75';
delete from info_recurso where codigo = 'ea99ce91-cf8f-4150-b79d-2594d4fdc5df';
delete from info_recurso where codigo = '33148da9-8c88-4022-ad42-b0cbb353b895';


delete from admi_rol where codigo = '02579cca-f768-42b9-ba4c-1ae88cc8115f';
delete from admi_rol where codigo = '843d0751-6a4b-4135-b86b-edf9c3b826e5';
delete from admi_rol where codigo = '3ce28ec7-aaeb-4ebf-ba99-40f54ab0e079';
delete from admi_rol where codigo = 'b8ea31c8-2b1a-4be8-a91a-d147019b7730';
delete from admi_rol where codigo = 'a5e68104-4372-45c6-91f9-4eb85779b9de';

delete from admi_aplicacion where codigo = '38b386fd-a7a1-48d3-8689-cc78134c590b';