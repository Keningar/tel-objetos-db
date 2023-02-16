/**
 * se debe ejecutar en DB_FIRMAELECT 
 * ROLLBACK de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 10-09-2022 - Versión Inicial.
*/
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"20","lly":"-4","urx":"210","ury":"-630","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_CONT_MD_PAGARE';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-10","lly":"10","urx":"200","ury":"-695","pagina":"1","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_AUT_DEBITO';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-120","lly":"15","urx":"100","ury":"-320","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FORMA_PAGO';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-150","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_EMPRESA';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"80","lly":"20","urx":"340","ury":"30","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_CONT_MD_FINAL_CLIENTE';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-60","lly":"-40","urx":"200","ury":"-190","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_FORM_SD_CLIENTE';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-110","lly":"-8","urx":"160","ury":"-3","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_ADEN_MD_EMPRESA';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-120","lly":"-15","urx":"190","ury":"-490","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}'
where codigo='FIRMA_ADEN_MD_CLIENTE';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-50","lly":"-10","urx":"100","ury":"-410","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_CLIENTE';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-50","lly":"-10","urx":"100","ury":"-410","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}'
where codigo='FIRMA_TERMINOS_MD_EMPRESA';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-155","lly":"5","urx":"100","ury":"-400","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_CONT_SD_EMPRESA';

update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-75","lly":"5","urx":"150","ury":"-400","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_CONT_SD_CLIENTE';



commit;
/

