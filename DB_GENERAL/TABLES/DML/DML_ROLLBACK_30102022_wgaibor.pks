/**
* Documentación del archivo DML_30102022_wgaibor
*
* @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
* @version 1.1 11-10-2022
*/

DELETE FROM DB_GENERAL.ADMI_ROL WHERE TIPO_ROL_ID = (SELECT ID_TIPO_ROL FROM DB_GENERAL.ADMI_TIPO_ROL WHERE DESCRIPCION_TIPO_ROL = 'listaPersona');
    
DELETE FROM DB_GENERAL.ADMI_TIPO_ROL WHERE DESCRIPCION_TIPO_ROL = 'listaPersona';

COMMIT;
/