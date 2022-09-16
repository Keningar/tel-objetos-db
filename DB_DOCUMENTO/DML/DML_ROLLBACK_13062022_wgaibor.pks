/*
 * SCRIPT DML DEL ESQUEMA DB_DOCUMENTO. 
 *
 * @author: Walther Joao Gaibor <wgaibor@telconet.ec>
 * @version 1.0 13-06-2022
 */

DELETE DB_DOCUMENTO.ADMI_PROCESO
WHERE CODIGO = 'link-banc';

--
DELETE DB_DOCUMENTO.ADMI_DOCUMENTO
WHERE CODIGO = 'term-cond';
--
commit;
/