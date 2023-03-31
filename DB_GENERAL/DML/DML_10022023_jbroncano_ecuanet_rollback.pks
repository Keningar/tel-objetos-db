DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'COD_FORMA_CONTACTO'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';

DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CANALES_PUNTO_VENTA'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';

DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'EMPRESA_APLICA_PROCESO'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'FRECUENCIA_FACTURACION'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CONTRATO_FISICO_VALIDACION'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ESTADOS_GRID_SERVICIOS'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PORCENTAJE_DESCUENTO_INSTALACION'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'VALORES_OBSERVACIONES_CONTRATO_DIGITAL'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'DEPARTAMENTOS_VENDEDORES'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CAMBIO FORMA PAGO'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';


DELETE  DB_GENERAL.Admi_Gestion_Directorios 
WHERE EMPRESA='EN' AND SUBMODULO='PuntoArchivoDigital';

DELETE  DB_GENERAL.Admi_Gestion_Directorios 
WHERE EMPRESA='EN' AND SUBMODULO='ContratoDocumentoDigital';

DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ESTADOS_RESTRICCION_PLANES_ADICIONALES'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
        

DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CORREOS_ADMINISTRACION_CONTRATOS'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';

DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_REINGRESO_OS_AUTOMATICA'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo' AND DESCRIPCION='ESTADO_PUNTO';
           

 COMMIT;
 /