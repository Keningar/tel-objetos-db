DELETE FROM DB_COMERCIAL.info_plan_condicion
where usr_creacion = 'ecuanet';

DELETE FROM DB_COMERCIAL.info_plan_caracteristica
where usr_creacion = 'ecuanet';

DELETE FROM DB_COMERCIAL.info_plan_det
where usr_creacion = 'ecuanet';

DELETE FROM DB_COMERCIAL.info_plan_historial
where usr_creacion = 'ecuanet';

DELETE FROM DB_COMERCIAL.info_plan_cab
where usr_creacion = 'ecuanet';

DELETE FROM DB_COMERCIAL.info_producto_impuesto
where usr_creacion = 'ecuanet';

ALTER TRIGGER DB_COMERCIAL.AFTER_ADMI_PRODUCTO DISABLE;

DELETE FROM DB_COMERCIAL.admi_producto
where usr_creacion = 'ecuanet';

ALTER TRIGGER DB_COMERCIAL.AFTER_ADMI_PRODUCTO ENABLE;

commit;

/