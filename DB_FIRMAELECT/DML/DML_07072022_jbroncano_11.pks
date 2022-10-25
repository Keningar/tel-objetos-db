
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-160","lly":"50","urx":"180","ury":"8","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FORMA_PAGO';



/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-150","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_EMPRESA';


/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
Update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"80","lly":"20","urx":"340","ury":"30","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_CLIENTE';
COMMIT;




/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-70","lly":"-30","urx":"200","ury":"-20","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_FORM_SD_CLIENTE';

/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"20","urx":"100","ury":"-28","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
TIPO='empresa'
where codigo='FIRMA_TERMINOS_MD_EMPRESA';


/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"20","urx":"100","ury":"-28","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_CLIENTE';
COMMIT;

/