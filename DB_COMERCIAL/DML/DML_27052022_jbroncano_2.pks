/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Secuencia de resumen correo compra para secuencia ademdun
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
CREATE SEQUENCE DB_COMERCIAL.SEQ_CORREO_RESUMEN_COMPRA
  INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE;
/

/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Secuencia de resumen correo compra para secuencia ademdun
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
INSERT INTO DB_COMERCIAL.ADMI_NUMERACION  
VALUES(DB_COMERCIAL.SEQ_ADMI_NUMERACION.nextval,18,0,'Numeracion Ademdun Resumen Compra'
,'ARC','001','002',1,SYSDATE,'jbroncano',null,null,'ADMI_NUMERACION','Activo',null,'N',null);