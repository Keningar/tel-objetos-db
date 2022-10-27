
/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de ubicacion de la firma 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 27-10-2022 - Versión Inicial.
 */   
 
update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-120","lly":"-8","urx":"190","ury":"-3","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}'
where codigo='FIRMA_ADEN_MD_CLIENTE';


update DB_FIRMAELECT.ADM_EMP_PLANT_CERT
set PROPIEDADES='{"llx":"-110","lly":"-8","urx":"160","ury":"-3","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}'
where codigo='FIRMA_ADEN_MD_EMPRESA';


COMMIT;

/