/*
* Creación de Cuentas Contables de Traslado para Ecuanet
* Jimmy Gilces <jgilces@telconet.ec>
* 11-04-2023
*/
INSERT INTO db_financiero.admi_cuenta_contable
  SELECT db_financiero.seq_admi_cuenta_contable.nextval,
         '33',
         a.no_cta,
         REPLACE(a.cuenta, '461', '481'),
         a.tabla_referencial,
         a.campo_referencial,
         (SELECT MAX(g.id_producto)
            FROM DB_COMERCIAL.admi_producto g
           WHERE g.empresa_cod = '33'
             AND UPPER(g.codigo_producto) =
                 (SELECT UPPER(x.codigo_producto)
                    FROM DB_COMERCIAL.ADMI_PRODUCTO X
                   WHERE x.id_producto =
                         TRIM(to_number(A.VALOR_CAMPO_REFERENCIAL))
                     AND X.EMPRESA_COD = '18')
             AND UPPER(g.descripcion_producto) =
                 (SELECT UPPER(x.descripcion_producto)
                    FROM DB_COMERCIAL.ADMI_PRODUCTO X
                   WHERE x.id_producto =
                         TRIM(to_number(A.VALOR_CAMPO_REFERENCIAL))
                     AND X.EMPRESA_COD = '18')), --*
         a.nombre_objeto_naf,
         a.tipo_cuenta_contable_id,
         REPLACE(a.descripcion, 'MEGADATOS', 'ECUANET'),
         '33',
         (SELECT B.ID_OFICINA
            FROM DB_COMERCIAL.INFO_OFICINA_GRUPO B
           WHERE UPPER(TRIM(B.NOMBRE_OFICINA)) =
                 (SELECT REPLACE(UPPER(TRIM(NOMBRE_OFICINA)),
                                 'MEGADATOS',
                                 'ECUANET')
                    FROM DB_COMERCIAL.INFO_OFICINA_GRUPO
                   WHERE ID_OFICINA = a.oficina_id
                     AND EMPRESA_ID = '18')
             AND B.EMPRESA_ID = '33'),
         a.fe_ini,
         a.fe_fin,
         SYSDATE,
         'jgilces',
         a.ip_creacion,
         a.estado,
         a.centro_costo
    FROM db_financiero.admi_cuenta_contable a
   WHERE a.tipo_cuenta_contable_id in (1, 7, 8, 33, 36, 37, 40, 46, 48, 49)
     AND no_cia = '18'
     AND tabla_referencial = 'ADMI_PRODUCTO'
     AND a.oficina_id IN (58, 59)
     AND VALOR_CAMPO_REFERENCIAL IN
         (SELECT ID_PRODUCTO
            FROM DB_COMERCIAL.ADMI_PRODUCTO P
           WHERE EMPRESA_COD = '18'
             AND DESCRIPCION_PRODUCTO IN ('TRASLADO'));

commit;
/
