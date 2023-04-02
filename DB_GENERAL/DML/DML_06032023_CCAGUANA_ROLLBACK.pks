/**
 * Reverso de creación de parametros
 *
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 * @version 1.0 06-03-2023
 */

DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'remitente'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo';
           
 COMMIT;
/