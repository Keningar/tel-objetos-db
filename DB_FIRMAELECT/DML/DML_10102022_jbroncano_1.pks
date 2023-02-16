/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"5","lly":"-3","urx":"-200","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_CLIENTE';
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-150","lly":"-5","urx":"100","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_EMPRESA';
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-90","lly":"-5","urx":"130","ury":"60","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FORMA_PAGO';

/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-120","lly":"-15","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_CLIENTE';
 /**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-120","lly":"-15","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_EMPRESA';
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"80","lly":"-5","urx":"110","ury":"40","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_CONT_MD_PAGARE';

/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-60","lly":"2","urx":"200","ury":"40","pagina":"1","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_AUT_DEBITO';
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"30","lly":"-30","urx":"400","ury":"50","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_FORM_SD_CLIENTE';
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-170","lly":"-0","urx":"100","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_CONT_SD_EMPRESA';
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-220","lly":"-5","urx":"150","ury":"45","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_CONT_SD_CLIENTE';


update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-150","lly":"-15","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_ADEN_MD_CLIENTE';


update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-120","lly":"-15","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_ADEN_MD_EMPRESA';

commit;
/

