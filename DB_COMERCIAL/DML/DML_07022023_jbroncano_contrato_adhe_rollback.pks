
/**
 * se debe ejecutar en DB_COMERCIAL 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */

DELETE 
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
    WHERE ACAR.DESCRIPCION_CARACTERISTICA IN ('numeroLinkDatosBancarios');



    commit;