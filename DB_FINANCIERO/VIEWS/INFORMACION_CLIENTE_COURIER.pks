CREATE FORCE EDITIONABLE VIEW "DB_FINANCIERO"."INFORMACION_CLIENTE_COURIER" ("ID_PUNTO", "LATITUD", "LONGITUD", "IDENTIFICACION_CLIENTE", "ID_PERSONA", "NOMBRE_OFICINA", "CLIENTE", "DESCRIPCION_CLIENTE", "CONTRATO", "DIRECCION", "DIRECCION_PTO", "NOMBRE_TIPO_NEGOCIO", "DESCRIPCION_BANCO", "DESCRIPCION_CUENTA", "DESCRIPCION_FORMA_PAGO", "CIUDAD") AS 
  select 
ip.id_punto,
ip.latitud,
ip.longitud,
ipe.identificacion_cliente,
ipe.id_persona,
iog.nombre_oficina,
case
when ipe.razon_social is not null then ipe.razon_social
when ipe.representante_legal is not null then ipe.representante_legal 
when ipe.nombres is not null or  ipe.apellidos is not null then CONCAT(CONCAT(ipe.nombres,' '),ipe.apellidos)
end as cliente,
CONCAT(CONCAT(ipe.nombres,' '),ipe.apellidos) as descripcion_cliente,
case
when length(ic.numero_contrato)>9 then substr(ic.numero_contrato,9) 
else ic.numero_contrato 
end as contrato,
case 
when ipe.direccion_tributaria is not null then REGEXP_REPLACE(ipe.direccion_tributaria,'[^[:alnum:],[:punct:]'' '']', NULL)
when ipe.direccion is not null then REGEXP_REPLACE(ipe.direccion,'[^[:alnum:],[:punct:]'' '']', NULL) 
end as direccion,
ip.direccion as direccion_pto,
atn.nombre_tipo_negocio,
ab.descripcion_banco,
atc.descripcion_cuenta,
afp.descripcion_forma_pago,
ac.nombre_canton as ciudad
from db_comercial.info_punto ip
left join db_comercial.info_contrato ic on ic.persona_empresa_rol_id=ip.persona_empresa_rol_id and ic.estado in ('Activo','Cancelado')
left join db_comercial.info_contrato_forma_pago icfp on icfp.contrato_id=ic.id_contrato and icfp.estado = 'Activo'
left join db_general.admi_banco_tipo_cuenta abtc on abtc.id_banco_tipo_cuenta=icfp.banco_tipo_cuenta_id
left join db_general.admi_banco ab on ab.id_banco=abtc.banco_id 
left join db_general.admi_tipo_cuenta atc on atc.id_tipo_cuenta= abtc.tipo_cuenta_id
left join db_comercial.info_persona_empresa_rol iper on iper.id_persona_rol=ip.persona_empresa_rol_id 
left join db_comercial.info_oficina_grupo iog on iog.id_oficina=iper.oficina_id
left join db_comercial.info_persona ipe on ipe.id_persona=iper.persona_id 
left join db_comercial.admi_tipo_negocio atn on atn.id_tipo_negocio=ip.tipo_negocio_id
left join db_general.admi_forma_pago afp on afp.id_forma_pago=ic.forma_pago_id 
left join db_general.admi_sector ase on ase.id_sector=ip.sector_id 
left join db_general.admi_parroquia ap on ap.id_parroquia=ase.parroquia_id 
left join db_general.admi_canton ac on ac.id_canton=ap.canton_id;