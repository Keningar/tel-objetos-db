/**
 *
 * Parámetros para el proyecto Gestión Documental
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 11-08-2021
 * @version 1.1 16-09-2021
 */

INSERT INTO DB_GENERAL.ADMI_GESTION_DIRECTORIOS
(
    ID_GESTION_DIRECTORIO,
    CODIGO_APP,
    CODIGO_PATH,
    APLICACION,
    PAIS,
    EMPRESA,
    MODULO,
    SUBMODULO,
    ESTADO,
    FE_CREACION,
    USR_CREACION
)
VALUES
(   
    DB_GENERAL.SEQ_ADMI_GESTION_DIRECTORIOS.nextval,
    7,
    1,
    'GestionDocumental',
    '593',
    'TN',
    'Gestion',
    'MisDocumentos',
    'Activo',
    sysdate,
    'cjperez'
);        

INSERT INTO DB_GENERAL.ADMI_GESTION_DIRECTORIOS
(
    ID_GESTION_DIRECTORIO,
    CODIGO_APP,
    CODIGO_PATH,
    APLICACION,
    PAIS,
    EMPRESA,
    MODULO,
    SUBMODULO,
    ESTADO,
    FE_CREACION,
    USR_CREACION
)
VALUES
(   
    DB_GENERAL.SEQ_ADMI_GESTION_DIRECTORIOS.nextval,
    7,
    2,
    'GestionDocumental',
    '593',
    'TN',
    'Recepcion',
    'Asignacion',
    'Activo',
    sysdate,
    'cjperez'
);

COMMIT;

/
