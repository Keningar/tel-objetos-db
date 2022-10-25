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
DBMS_LOB.APPEND(bada, '<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>T'||chr(38)||'Eacute;RMINOS Y CONDICIONES DE IP FIJA ADICIONAL PYME</strong></span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">IP Fija Adicional PYME es un producto que entrega IPs P'||chr(38)||'uacute;blicas para LAN. Cada direcci'||chr(38)||'oacute;n IP es un enlace que se conecta a una interfaz WAN espec'||chr(38)||'iacute;fica.</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Servicio s'||chr(38)||'oacute;lo disponible para planes PYME.</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Este servicio se contrata como un adicional al plan de internet contratado por un precio por IP de $4,50 (CUATRO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 50/100) m'||chr(38)||'aacute;s IVA mensual (m'||chr(38)||'aacute;ximo 4 IPs P'||chr(38)||'uacute;blica Fija para LAN por punto del cliente).</span></span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=80 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='IP1';
 COMMIT;
 END;