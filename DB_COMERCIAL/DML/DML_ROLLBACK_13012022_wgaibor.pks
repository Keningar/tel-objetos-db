/**
 * Rollback de parámetros de las cláusulas de contrato
 *
 * @author Walther Joao Gaibor C <wgaibor@telconet.ec>
 *
 * @version 1.0
 * @since 13-01-2022
 */

DELETE 
    FROM DB_GENERAL.ADMI_PARAMETRO_DET t 
    WHERE t.parametro_id = (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CLAUSULA_CONTRATO_PREGUNTA'
            AND estado = 'Activo'
    );

DELETE 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
    WHERE APC.nombre_parametro = 'CLAUSULA_CONTRATO_PREGUNTA';


DELETE 
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
    WHERE ACAR.DESCRIPCION_CARACTERISTICA IN ('editarFormaPagoCliente',
                                              'datosLinkDatosBancarios',
                                              'correoLinkDatosBancarios',
                                              'usuarioLinkDatosBancarios',
                                              'passwordLinkDatosBancarios',
                                              'linkDatosBancarios');

COMMIT;
/
