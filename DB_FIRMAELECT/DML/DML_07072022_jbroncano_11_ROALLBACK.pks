
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FORMA_PAGO';
COMMIT;
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_EMPRESA';
COMMIT;
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_CLIENTE';
COMMIT;

/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-70","lly":"-30","urx":"200","ury":"-10","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_FORM_SD_CLIENTE';
COMMIT;

/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_CLIENTE';
COMMIT;

/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_EMPRESA';
COMMIT;


