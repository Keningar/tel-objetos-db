
/**
 * DEBE EJECUTARSE EN DB_COMERCIAL.
 * Parametros para el catalogo movil Comercial
 * @author Carlos Caguana<jbroncano@telconet.ec>
 */

DELETE  FROM DB_COMERCIAL.ADMI_CATALOGOS  WHERE
    COD_EMPRESA=33 AND TIPO='CATALOGOEMPRESA';

COMMIT;
/           