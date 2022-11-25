/*Regularizacion tipo documento = CONTRATO = 2*/

update db_comunicacion.info_documento idoc 
set idoc.tipo_documento_general_id = 2, idoc.mensaje = 'Regulariza tipo documento'
where idoc.estado='Activo' and idoc.TIPO_DOCUMENTO_ID is null 
and idoc.TIPO_DOCUMENTO_GENERAL_ID is null and idoc.empresa_cod=18 and idoc.contrato_id is not null 
and idoc.FE_CREACION BETWEEN TO_DATE('09-11-2022','DD-MM-YYYY') and sysdate;

commit;

/