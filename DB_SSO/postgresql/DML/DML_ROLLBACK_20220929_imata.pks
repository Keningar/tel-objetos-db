
/*
 * Rollback para eliminar lo recursos creados para el token autorizacion de portal cautivo
 * @author  Ivan Mata imata@telconet.ec
 * @version 1.0  
 */


delete from public.info_rol_permiso where rol_id in(select id_rol  from public.admi_rol ar where nombre = 'Radio' and estado ='Activo'and aplicacion_id in(select id_aplicacion  from public.admi_aplicacion where nombre ='Gestor de Portales Cautivos' and empresa_id =1 and estado='Activo'));


delete from public.info_rol_permiso where rol_id in(select id_rol  from public.admi_rol ar where nombre = 'Admin' and estado ='Activo'and aplicacion_id in(select id_aplicacion  from public.admi_aplicacion where nombre ='Gestor de Portales Cautivos' and empresa_id =1 and estado='Activo'));


delete from public.info_rol_permiso where rol_id in(select id_rol  from public.admi_rol ar where nombre = 'User' and estado ='Activo'and aplicacion_id in(select id_aplicacion  from public.admi_aplicacion where nombre ='Gestor de Portales Cautivos' and empresa_id =1 and estado='Activo'));





delete from info_permiso where codigo = '1d3bd27b-edb8-4f18-a539-862a21e0c01e';
delete from info_permiso where codigo = '17638d9c-8dc0-400a-b61e-38ca60ec6f7c';
delete from info_permiso where codigo = '691244b7-b984-4711-8b21-e59ed052e843';
delete from info_permiso where codigo = 'b3904531-55f5-4a03-a900-c38c7d5d92cf';
delete from info_permiso where codigo = 'd403ca27-7ba0-4399-9605-36d4caa98952';
delete from info_permiso where codigo = '9bc6b8fe-b72c-4993-a5de-9fea1c7fe039';
delete from info_permiso where codigo = '38d24e21-584d-4089-a17a-603b583ac276';
delete from info_permiso where codigo = '5dd0a58c-1331-4c0f-bbf4-b6e042dd1142';
delete from info_permiso where codigo = '5866e555-9a2d-451c-b8ff-96aa26ef5bbb';
delete from info_permiso where codigo = '9ecc4ae2-63ae-41be-ba51-6cf7555f6fb2';
delete from info_permiso where codigo = '297f2982-9554-473f-9c4d-f1162d4dd51f';
delete from info_permiso where codigo = '989e669c-97ee-4399-b655-97db94034b75';
delete from info_permiso where codigo = 'ddeb7320-94f2-4194-96bf-caf447af85fa';
delete from info_permiso where codigo = 'c3b001c0-715b-4922-be10-46b477877839';
delete from info_permiso where codigo = '55cc0e57-3a7c-4a1c-95fd-2c375548074f';
delete from info_permiso where codigo = '8a11acb6-a529-415c-b81a-0e485d555501';
delete from info_permiso where codigo = 'd14e6cb0-1961-4385-b301-d82af6f777ec';
delete from info_permiso where codigo = '21c9b93e-16a9-48a4-bd41-a711154fb895';
delete from info_permiso where codigo = '3636abbb-8366-47d8-9a49-d4b02546ac47';
delete from info_permiso where codigo = '12d06dea-71e7-4989-981d-31d806848424';
delete from info_permiso where codigo = '099fb4e5-05cf-4434-91c1-d3f51b175b6e';
delete from info_permiso where codigo = 'f0dcb3c1-8a49-4ab5-b229-ad415dfbd396';
delete from info_permiso where codigo = '251a075e-edf1-44e3-8b88-c9670230605b';
delete from info_permiso where codigo = '04e35b0e-f8f2-43c7-8133-8ac909078fe0';
delete from info_permiso where codigo = '0949d164-c63f-49cd-9924-48d7d7c66c3a';
delete from info_permiso where codigo = '7a2fcae9-a5fe-4b06-ac39-3753048963fd';
delete from info_permiso where codigo = '1370e9c1-7966-48c3-b944-508dc737bf38';
delete from info_permiso where codigo = 'ad47cd28-bc2e-4fbe-b114-c6328c705d36';
delete from info_permiso where codigo = '2ccd333a-7cf4-4371-84cc-2ab472eef20f';
delete from info_permiso where codigo = 'a6034423-9b11-432f-9904-281873cb3d34';
delete from info_permiso where codigo = 'cd095b7d-d5b0-41f5-acf4-fd60bec66885';
delete from info_permiso where codigo = 'ecee542a-991c-4dc0-b0be-8720a905c168';
delete from info_permiso where codigo = '49d74cda-3d2c-4e01-ba04-b6df673b829a';
delete from info_permiso where codigo = 'd74cd51c-54ff-4270-8a9e-24cb924a08cb';
delete from info_permiso where codigo = '7439ac2e-de53-48e1-92d8-2b6653c25133';
delete from info_permiso where codigo = '888e44db-9d3f-4f56-8355-60b26fea101f';
delete from info_permiso where codigo = '47b881cc-fc78-4ac6-9447-7864ab94b47c';
delete from info_permiso where codigo = '4d75daf4-5122-40f3-aef5-3ba25d198e6d';
delete from info_permiso where codigo = 'f8f20215-b4ab-4bc8-a6a0-ca0418bf3265';
delete from info_permiso where codigo = 'db89ab06-efd1-43d5-b71c-9863323f0475';
delete from info_permiso where codigo = '95d3f46e-436a-4748-9cee-ac653c2e2b65';
delete from info_permiso where codigo = 'a86423fc-63f7-44cb-86d5-197fbced5e38';
delete from info_permiso where codigo = '45254dfe-0daf-4885-9ea2-af324d4fe395';
delete from info_permiso where codigo = 'c56e2c05-a91d-4f06-8a4f-c93f9075c46c';
delete from info_permiso where codigo = '416d7653-29b4-4d0b-8b51-bffec9f1bb71';
delete from info_permiso where codigo = '96290b64-bb41-43d3-98b0-cb0bb24f71c1';
delete from info_permiso where codigo = 'e34d87b2-c801-4050-9e0a-5e6ff031db20';
delete from info_permiso where codigo = 'eb61d1b4-4e82-4847-9a09-bc7ea65dfb4b';
delete from info_permiso where codigo = 'd9489c50-f9c9-42aa-8ef5-edf975ac6a57';
delete from info_permiso where codigo = '673a11cb-72b9-4eb6-bef9-39ebe7667e3c';
delete from info_permiso where codigo = 'ef85dc1d-8d0f-4079-88c0-41f98d0a8bf6';
delete from info_permiso where codigo = '34a3b8bf-fc43-4a00-8f0b-6a3ab4fc0eb3';
delete from info_permiso where codigo = '01de107e-ee35-46f0-9a42-d334e668f4ba';
delete from info_permiso where codigo = 'ed36f641-6deb-4ab7-a4e5-8a2cf38b99ca';
delete from info_permiso where codigo = '7d360797-0147-4605-a4c4-b12c8e7bebdd';
delete from info_permiso where codigo = 'fa05a11d-aa49-4156-9b0a-302f81b44e94';
delete from info_permiso where codigo = '7b809072-0a55-490b-b764-97e5d8166656';
delete from info_permiso where codigo = '757b8d3d-1558-413c-a87f-352dc3f2862a';
delete from info_permiso where codigo = '0c05feee-093c-46d2-94c1-9014b813fb99';
delete from info_permiso where codigo = '9a7f662c-a03e-41c4-a072-cf6508c648c4';
delete from info_permiso where codigo = 'b55660ef-95e7-4599-8ffe-70ebd0326c16';
delete from info_permiso where codigo = '6b0ede62-6f73-4e23-964f-fab5bcb308d1';
delete from info_permiso where codigo = '21a7d96e-f9af-4c50-a2c6-b4c53411aa03';
delete from info_permiso where codigo = '9bc23b00-5c12-496b-b9f8-eea94f20bc05';
delete from info_permiso where codigo = '3d4c57c4-9955-4b36-91f4-cebdf0021bd6';
delete from info_permiso where codigo = '0365501a-e78b-4aae-85a3-a0b68b1c1608';
delete from info_permiso where codigo = '2e9363dc-75fb-4623-83b6-9fc450d07917';
delete from info_permiso where codigo = '5e5b9c0c-4f6e-4923-949c-70d12b3562fc';
delete from info_permiso where codigo = '458b3ad8-a95a-44e7-88e7-f3d5926cbc08';
delete from info_permiso where codigo = '6b68bc5d-147d-4bbf-a5ce-9a65dc3d8e60';
delete from info_permiso where codigo = '4ee522fd-8b00-4f58-ad90-c83253a309fa';
delete from info_permiso where codigo = '71110fbe-a122-41c6-b60e-c0528ebaf781';
delete from info_permiso where codigo = 'cbb7db67-68ec-4547-bfdd-7af00fde9d98';
delete from info_permiso where codigo = '59e7462e-3fb6-458d-a03e-a768364a49c5';
delete from info_permiso where codigo = '4325746b-5bac-4ea7-9f5b-ce626776dfb7';
delete from info_permiso where codigo = '3a8a128c-6f0d-4d5a-a40a-1267b7cd2c89';
delete from info_permiso where codigo = '47535228-1d96-4ef9-857c-4c19527c1dd3';
delete from info_permiso where codigo = 'f513a9bc-3bac-4643-9ce5-4f9862049111';
delete from info_permiso where codigo = 'f1c20bac-25b1-4e38-a6bc-d9a803ef76c8';
delete from info_permiso where codigo = 'b73a7a63-e98b-49b1-9826-a71ce4b37938';
delete from info_permiso where codigo = 'fd8f8ff6-7a1a-43ef-8579-fe497101e8c3';
delete from info_permiso where codigo = 'c8ed4a65-0b44-4f0f-83d0-bbc25f97ee75';
delete from info_permiso where codigo = 'd5480ba4-f284-4bf4-a4a9-fe907546f80d';
delete from info_permiso where codigo = 'becd1e8e-b4a1-42e2-b053-117720bca9fe';
delete from info_permiso where codigo = '6c117ebf-9ace-4a94-aeeb-a06c66f72770';
delete from info_permiso where codigo = 'f9c54f00-54bf-42ff-9dba-14fb9a7fcacd';
delete from info_permiso where codigo = 'f89731f9-f183-4e47-b2d1-683b6ebf8a9b';
delete from info_permiso where codigo = 'fb26b95c-4a63-4276-8805-ab20b41e1560';





delete from info_recurso where codigo = '7b20cda8-9cf9-4735-9ca5-d4d9e289fa01';
delete from info_recurso where codigo = '337b2fba-0347-412f-af0a-dbf97911c3a8';
delete from info_recurso where codigo = '218afcd1-6b51-43e1-8e9a-e1713e864475';
delete from info_recurso where codigo = 'b0b62f1f-23b3-4831-a1a6-2aa35011f666';
delete from info_recurso where codigo = '87fbf1cd-aec7-4519-9c45-db82d8deead4';
delete from info_recurso where codigo = 'a40aab43-49ab-46a1-b192-3e4fa1bada93';
delete from info_recurso where codigo = '58121fc9-a0e0-41ac-98ec-4ddfe33d267f';
delete from info_recurso where codigo = '1d4ade3f-d5f5-4e5e-b40e-f639c6de2167';
delete from info_recurso where codigo = '6ca77518-5acd-4b0f-8103-afa64f7865a2';
delete from info_recurso where codigo = 'a3c63d92-a633-4abd-b183-1248339ca0c7';
delete from info_recurso where codigo = 'a3a32472-488d-41d6-a682-4f85672673e0';
delete from info_recurso where codigo = '097b6005-07cc-4514-9b26-ce9c62fb526a';
delete from info_recurso where codigo = 'a97bbc2d-94d0-42c6-8eae-2f4d45136dfc';
delete from info_recurso where codigo = '0946979e-66f9-4ea1-9627-9855f8606d4a';
delete from info_recurso where codigo = 'c9f77fac-c189-4541-9bae-4ae84a3a7f87';
delete from info_recurso where codigo = '68cc27a1-027f-403a-9e07-01ce46039323';
delete from info_recurso where codigo = '33629fc3-be5e-4fbd-b6d8-749f88b703b2';
delete from info_recurso where codigo = '18fca528-e1f1-4c51-acdd-ae221da28c07';
delete from info_recurso where codigo = 'b3e7c3c7-ad50-4031-b1a2-c26777d0bdfe';
delete from info_recurso where codigo = '567c0af2-3e20-419d-adaf-664cd92e040f';
delete from info_recurso where codigo = 'e4c81942-0bc1-4260-adc2-913cef011324';
delete from info_recurso where codigo = '2f9cf08a-2423-457e-a5d2-65e7f921de27';
delete from info_recurso where codigo = 'ef58cd67-aea3-439a-bc60-712265d4e8ff';
delete from info_recurso where codigo = 'f9d42faa-f636-4924-949d-2e2a535e7ada';
delete from info_recurso where codigo = 'f63cf717-a461-4226-bed9-9490bc0b7c15';
delete from info_recurso where codigo = '0badfe7e-bd7c-42db-948b-f159db15cd55';
delete from info_recurso where codigo = 'b9811117-1ecd-493d-87fb-9b32a4596009';
delete from info_recurso where codigo = 'e9f1c409-028c-410d-bfe2-14ab32bd7ba7';
delete from info_recurso where codigo = 'c347c744-07fb-41cd-a314-ef5cf5850ad0';
delete from info_recurso where codigo = '00506ab2-e66c-4ad8-b895-e89307c369de';
delete from info_recurso where codigo = 'fb313b5c-9fe6-4707-96df-7b45b96c6662';
delete from info_recurso where codigo = '2c841d16-28ac-4d42-ba00-04b79d1eef11';
delete from info_recurso where codigo = 'bd67829d-615e-49bc-9c3e-a5df66d6c7ce';
delete from info_recurso where codigo = '0ad7c9cd-fbcc-4311-9348-baab18ab33c2';
delete from info_recurso where codigo = '28c701b4-bfe6-458b-90f2-feae6744ceca';
delete from info_recurso where codigo = '17dfaca6-9bee-4b57-984d-c164a0f2112f';
delete from info_recurso where codigo = 'd4952408-2c00-43b1-8d6d-aece88d23163';
delete from info_recurso where codigo = '58b4a721-d0c2-4c9f-99df-31253c58091a';
delete from info_recurso where codigo = '975fd184-a161-4a8e-b6b5-ac9b8d15eb75';
delete from info_recurso where codigo = '42745b4d-15c3-4d08-a59e-55e8995c5a9a';
delete from info_recurso where codigo = 'a0ebb67b-5117-4fa6-8b89-d746fe8bdf1e';
delete from info_recurso where codigo = '6ea48371-35b1-4f29-baa0-f553db1493a0';
delete from info_recurso where codigo = 'cbaa1cb7-7d45-45fd-be29-9144077c800e';
delete from info_recurso where codigo = '8e3eb998-9688-427d-8215-9e121a28abac';
delete from info_recurso where codigo = '4541a494-2d48-49d2-b428-4394b555339c';
delete from info_recurso where codigo = 'f53fabc2-fde3-4dbe-a7b8-ca144b9e5227';
delete from info_recurso where codigo = '4ba1c890-e07a-4744-ad97-b5984d21acfc';
delete from info_recurso where codigo = '41d3899d-9d2c-42bb-9535-67c58cd89c3f';
delete from info_recurso where codigo = '67c7b8be-5404-4c01-ae9a-c6d89b828ec0';
delete from info_recurso where codigo = '161eb898-a6d2-4ad3-bf7f-32ac8489a22d';
delete from info_recurso where codigo = '1792c416-e868-4335-ab97-65d8497af265';
delete from info_recurso where codigo = 'd9338586-2e26-4071-ae3c-bbccfd063080';
delete from info_recurso where codigo = 'fbf8cd2a-8dd2-4d82-8107-4bd1763026df';
delete from info_recurso where codigo = 'abd5532f-db09-4f17-93c5-6ce33a4b4a95';
delete from info_recurso where codigo = '41fa90e9-31cb-4f09-a667-07165e728c35';
delete from info_recurso where codigo = '52536fa7-faac-4b68-a663-64ba26173fb6';
delete from info_recurso where codigo = 'b666f39b-2dea-4aa9-9083-5ef4b3dc7866';
delete from info_recurso where codigo = 'ff8dc92c-339c-4f9b-9385-7580487b801b';
delete from info_recurso where codigo = 'bf483460-b605-4015-9bc4-c176f02523e9';
delete from info_recurso where codigo = '55122161-c716-4fd2-b732-bd82f911aaed';
delete from info_recurso where codigo = '6af70cd0-b09f-467f-9acb-14c83298efa4';
delete from info_recurso where codigo = '65141269-0e64-4fe8-b4bc-8455d0af1224';
delete from info_recurso where codigo = 'c2c32ee1-0c3a-4d6d-b92c-0730edd19116';
delete from info_recurso where codigo = '829c973d-d69d-4980-9f24-0804962347df';
delete from info_recurso where codigo = '5dad0ebe-9bf4-4560-8cca-fc77eb037f6d';
delete from info_recurso where codigo = '7e1ba101-a2bb-46cd-bbe3-3727d5d9011e';
delete from info_recurso where codigo = '46cada61-c02b-4da4-8d2a-16d51e3103f8';
delete from info_recurso where codigo = '51c6a2bb-5d0b-4fca-b934-26b64db11332';
delete from info_recurso where codigo = '3161f77e-a3f1-4092-b38b-c40d3495879a';
delete from info_recurso where codigo = '4b8b3e8c-a2c6-4392-86b1-41c0695e8420';
delete from info_recurso where codigo = '5f5eb077-07b5-4124-b516-c919b47e86e4';
delete from info_recurso where codigo = 'cda8a20b-7888-4785-9816-6b54edc78476';
delete from info_recurso where codigo = 'd62d037e-e3a2-46a8-98fd-0c547076f411';
delete from info_recurso where codigo = '17adaa20-9639-4e59-b90d-1a5c374749da';
delete from info_recurso where codigo = '0b540b03-8a53-4412-98d2-2b069b4c2d2a';
delete from info_recurso where codigo = '4650e8bf-3f09-4bdc-a9dd-a5ed73e1150f';
delete from info_recurso where codigo = 'ebd4cab3-cf06-4492-90e9-b474feb57b42';
delete from info_recurso where codigo = '962a8df9-6fd8-4c70-b009-d95476246f39';
delete from info_recurso where codigo = '5f6577ab-9359-46e4-ab4a-e24bbeaae195';
delete from info_recurso where codigo = '454ca9ab-fa2b-42ec-98fe-0f2e05441d23';
delete from info_recurso where codigo = '642270c5-3213-44cb-82ee-34deab9dc313';
delete from info_recurso where codigo = 'b75f296d-6434-48b7-976f-8ef93aec1c0f';
delete from info_recurso where codigo = 'e19e9d60-cfc1-427a-8496-7dbeb131cf4a';
delete from info_recurso where codigo = '815450df-d32d-4b9e-8b28-7050a88cd961';
delete from info_recurso where codigo = '53d1aa3a-3e3f-4ecf-b6ed-29899bb2e60f';
delete from info_recurso where codigo = 'f6d7ed38-9de4-498b-93d3-56a8d29b0fb8';
delete from info_recurso where codigo = '95920ab5-594f-43f0-a3ff-30bcee1a9b57';
delete from info_recurso where codigo = 'd456bc85-7d81-4713-8afb-2f4d8c0ecb4c';


delete from public.admi_rol ar where nombre = 'Radio' 
and estado ='Activo'and aplicacion_id in(select id_aplicacion  
from public.admi_aplicacion where nombre ='Generador de Portales Cautivos' and empresa_id =1 and estado='Activo');

delete from public.admi_rol ar where nombre = 'Admin' 
and estado ='Activo'and aplicacion_id in(select id_aplicacion  
from public.admi_aplicacion where nombre ='Generador de Portales Cautivos' and empresa_id =1 and estado='Activo');

delete from public.admi_rol ar where nombre = 'User' 
and estado ='Activo'and aplicacion_id in(select id_aplicacion  
from public.admi_aplicacion where nombre ='Generador de Portales Cautivos' and empresa_id =1 and estado='Activo');


delete from public.admi_aplicacion where nombre ='Generador de Portales Cautivos' 
and empresa_id =1 and estado='Activo';


