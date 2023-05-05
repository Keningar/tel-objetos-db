CREATE FORCE EDITIONABLE VIEW "NAF47_TNET"."V_SOLICITUDES_RETIROS" ("TIPO_SOLICITUD", "ID_DETALLE_SOLICITUD", "OBSERVACION", "ESTADO_SOLICITUD", "ID_SOLICITUD_CARACTERISTICA", "DESCRIPCION_CARACTERISTICA", "ELEMENTO_ID", "ESTADO_SOL_CARACTERISTICA", "SERVICIO_ID") AS 
  select t.descripcion_solicitud tipo_solicitud,  
       s.id_detalle_solicitud,
       s.observacion,
       s.estado estado_solicitud,
       sc.id_solicitud_caracteristica,
       c.descripcion_caracteristica,
       sc.valor elemento_id,
       sc.estado estado_sol_caracteristica,
       s.servicio_id
  from db_comercial.info_detalle_sol_caract sc,
       db_comercial.admi_caracteristica c,
       db_comercial.info_detalle_solicitud s,
       db_comercial.admi_tipo_solicitud t
 where sc.detalle_solicitud_id = s.id_detalle_solicitud
   and sc.caracteristica_id = c.id_caracteristica (+)
   and s.tipo_solicitud_id = t.id_tipo_solicitud
   and t.descripcion_solicitud = 'SOLICITUD RETIRO EQUIPO'
   and s.estado !='Finalizada';