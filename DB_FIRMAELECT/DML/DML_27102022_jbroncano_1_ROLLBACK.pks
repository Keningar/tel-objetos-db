
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 27-10-2022 - Versión Inicial.
 */
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_ADEN_MD_CLIENTE';


update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-100","lly":"15","urx":"100","ury":"35","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_ADEN_MD_EMPRESA';


COMMIT;

/