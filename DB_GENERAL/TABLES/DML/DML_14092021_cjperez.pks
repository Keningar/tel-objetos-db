/**
 *
 * Mensajes personalizados para los diálogos y ventanas emergentes 
 * para el proyecto Gestión Documental
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 14-09-2021
 */

INSERT INTO DB_DOCUMENTAL.SIST_RESOURCE_BUNDLE
(
    ID_RESOURCE_BUNDLE,
    FE_CREACION,
    FE_ULT_MOD,
    IP_CREACION,
    USR_CREACION,
    USR_ULT_MOD,
    CODIGO,
    LOCALE,
    VALOR
) 
VALUES
(
    DB_DOCUMENTAL.SEQ_SIST_RESOURCE_BUNDLE.nextval,
    sysdate, 
    NULL, 
    '127.0.0.1', 
    'cjperez', 
    NULL, 
    'element.delete.undo', 
    'es_EC', 
    'Se restauró el elemento correctamente'
);

COMMIT;
/
