/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Actualizacion de Terminos y Condiciones
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 07-07-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada, ' <p>TÉRMINOS Y CONDICIONES DE IP FIJA ADICIONAL PYME</p><ul><li>IP Fija Adicional PYME es un producto que entrega IPs Públicas para LAN. Cada dirección IP es un enlace que se conecta a una interfaz WAN específica. <br></li><li>Servicio sólo disponible para planes PYME. <br></li><li>Este servicio se contrata como un adicional al plan de internet contratado por un precio por IP de $4,50 (CUATRO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA CON 50/100) más IVA mensual (máximo 4 IPs Pública Fija para LAN por punto del cliente).</li></ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=80 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='IP1';
 COMMIT;
 END;