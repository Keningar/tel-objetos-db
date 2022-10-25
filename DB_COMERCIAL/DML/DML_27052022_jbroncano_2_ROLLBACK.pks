/**
 ** DEBE EJECUTARSE EN DB_COMERCIAL.
 * Se elimina secuencia creada
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
DROP SEQUENCE DB_COMERCIAL.SEQ_CORREO_RESUMEN_COMPRA;
/



delete from DB_COMERCIAL.ADMI_NUMERACION  WHERE CODIGO = 'ARC' AND DESCRIPCION='Numeracion Ademdun Resumen Compra';