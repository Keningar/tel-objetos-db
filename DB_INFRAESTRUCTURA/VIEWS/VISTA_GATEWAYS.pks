CREATE FORCE EDITIONABLE VIEW "DB_INFRAESTRUCTURA"."VISTA_GATEWAYS" ("NOMBRE_MARCA_ELEMENTO", "NOMBRE_MODELO_ELEMENTO", "ID_ELEMENTO", "NOMBRE_ELEMENTO", "IP", "NOMBRE_USUARIO_ACCESO", "CONTRASENA", "ESTADO", "EMPRESA_COD") AS 
  SELECT
    A .nombre_marca_elemento,
    b.nombre_modelo_elemento,
    b.id_elemento,
    b.nombre_elemento,
    b.ip,
    b.nombre_usuario_acceso,
    b.contrasena,
    b.estado,
    b.empresa_cod
FROM
    DB_INFRAESTRUCTURA.admi_marca_elemento A
INNER JOIN (
    SELECT
        A .marca_elemento_id,
        A .nombre_modelo_elemento,
        b.id_elemento,
        b.nombre_elemento,
        b.ip,
        b.nombre_usuario_acceso,
        b.contrasena,
        b.estado,
        b.empresa_cod
    FROM
        DB_INFRAESTRUCTURA.admi_modelo_elemento A
    INNER JOIN (
        SELECT
            A .ip,
            b.contrasena,
            b.id_elemento,
            b.nombre_elemento,
            b.nombre_usuario_acceso,
            b.id_modelo_elemento,
            b.estado,
            b.empresa_cod
        FROM
            DB_INFRAESTRUCTURA.info_ip A
        INNER JOIN (
            SELECT
                A .contrasena,
                b.id_elemento,
                b.nombre_elemento,
                b.nombre_usuario_acceso,
                b.id_modelo_elemento,
                b.estado,
                b.empresa_cod       
                FROM
                    DB_INFRAESTRUCTURA.info_elemento_contrasena A
                INNER JOIN (
                    SELECT
                        b.id_elemento,
                        b.nombre_elemento,
                        b.nombre_usuario_acceso,
                        b.id_modelo_elemento,
                        b.estado,
                        A .empresa_cod
                    FROM
                        DB_INFRAESTRUCTURA.info_empresa_elemento A
                    INNER JOIN (
                        SELECT
                            A .id_elemento,
                            A .nombre_elemento,
                            b.nombre_usuario_acceso,
                            b.id_modelo_elemento,
                            A .estado
                        FROM
                            DB_INFRAESTRUCTURA.info_elemento A
                        INNER JOIN (
                            SELECT
                                A .nombre_usuario_acceso,
                                b.id_modelo_elemento
                            FROM
                                DB_INFRAESTRUCTURA.admi_usuario_acceso A
                            INNER JOIN (
                                SELECT
                                    A .usuario_acceso_id,
                                    b.id_modelo_elemento
                                FROM
                                    DB_INFRAESTRUCTURA.admi_modelo_usuario_acceso A
                                INNER JOIN (
                                    SELECT
                                        id_modelo_elemento
                                    FROM
                                        DB_INFRAESTRUCTURA.admi_modelo_elemento
                                    WHERE
                                        tipo_elemento_id = (
                                            SELECT
                                                id_tipo_elemento
                                            FROM
                                                DB_INFRAESTRUCTURA.admi_tipo_elemento
                                            WHERE
                                                nombre_tipo_elemento = 'GATEWAY'
                                        )
                                ) b ON A .modelo_elemento_id = b.id_modelo_elemento
                            ) b ON A .id_usuario_acceso = b.usuario_acceso_id
                        ) b ON A .modelo_elemento_id = b.id_modelo_elemento
                    ) b ON A .elemento_id = b.id_elemento
                ) b ON A .elemento_id = b.id_elemento           
        ) b ON A .elemento_id = b.id_elemento
    ) b ON A .id_modelo_elemento = b.id_modelo_elemento
) b ON A .id_marca_elemento = b.marca_elemento_id;