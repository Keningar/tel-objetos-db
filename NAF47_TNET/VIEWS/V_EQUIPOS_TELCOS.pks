CREATE    OR REPLACE VIEW "NAF47_TNET"."V_EQUIPOS_TELCOS" ("ID_ELEMENTO", "NOMBRE_ELEMENTO", "NUMERO_SERIE", "ESTADO_ELEMENTO", "ID_PUNTO", "LOGIN", "NOMBRE_PUNTO", "ID_SERVICIO", "ESTADO_SERVICIO") AS 
  select a.id_elemento, 
         a.nombre_elemento, 
         upper(a.serie_fisica) numero_serie,
         a.estado estado_elemento,
         g.id_punto,
         g.login,
         g.nombre_punto,
         f.id_servicio,
         f.estado estado_servicio
    from db_infraestructura.info_elemento a,
         db_infraestructura.info_interface_elemento b,
         db_infraestructura.info_enlace c,
         db_infraestructura.info_interface_elemento d,
         db_comercial.info_servicio_tecnico e,
         db_comercial.info_servicio f,
         db_infraestructura.info_punto g
   where a.id_elemento = b.elemento_id
     and b.id_interface_elemento = c.interface_elemento_fin_id
     and c.interface_elemento_ini_id = d.id_interface_elemento
     and d.id_interface_elemento = e.interface_elemento_cliente_id
     and e.servicio_id = f.id_servicio
     and f.punto_id = g.id_punto
     and (a.estado = 'Activo' or f.estado = 'Activo')
   union
  select e.id_elemento, 
         e.nombre_elemento, 
         upper(e.serie_fisica),
         e.estado estado_elemento,
         p.id_punto,
         p.login,
         p.nombre_punto,
         s.id_servicio,
         s.estado estado_servicio
    from db_infraestructura.info_elemento e,
         db_comercial.info_servicio_tecnico st,
         db_comercial.info_servicio s,
         db_infraestructura.info_punto p
   where e.id_elemento = st.elemento_cliente_id
     and st.servicio_id = s.id_servicio
     and s.punto_id = p.id_punto
     and (e.estado = 'Activo' or s.estado = 'Activo');