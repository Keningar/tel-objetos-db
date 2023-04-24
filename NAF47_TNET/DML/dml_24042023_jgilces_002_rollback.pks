/*
* Eliminación de Cuentas Contables de Traslado para Ecuanet
* Jimmy Gilces <jgilces@telconet.ec>
* 11-04-2023
*/
delete FROM db_financiero.admi_cuenta_contable a
 WHERE a.tipo_cuenta_contable_id in (1, 7, 8, 33, 36, 37, 40, 46, 48, 49)
   AND no_cia = '33'
   AND tabla_referencial = 'ADMI_PRODUCTO'
   AND a.oficina_id IN
       (SELECT id_oficina
          FROM DB_COMERCIAL.INFO_OFICINA_GRUPO B
         where empresa_id = '33'
           and nombre_oficina in ('ECUANET - GUAYAQUIL', 'ECUANET - QUITO'))
   AND VALOR_CAMPO_REFERENCIAL IN
       (SELECT ID_PRODUCTO
          FROM DB_COMERCIAL.ADMI_PRODUCTO P
         WHERE EMPRESA_COD = '33'
           AND DESCRIPCION_PRODUCTO IN ('TRASLADO'));

commit;
/
