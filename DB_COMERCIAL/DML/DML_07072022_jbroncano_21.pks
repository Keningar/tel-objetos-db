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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>T'||chr(38)||'Eacute;RMINOS Y CONDICIONES DE </strong><strong>IP FIJA </strong></span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">IP Fija es un producto que entrega una IP P'||chr(38)||'uacute;blica Fija en la WAN que act'||chr(38)||'uacute;an como un identificador '||chr(38)||'uacute;nico y permite disponer de una direcci'||chr(38)||'oacute;n exclusiva y reconocible en internet.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Las aplicaciones que precisan del uso de una IP'||chr(38)||'nbsp;fija'||chr(38)||'nbsp;son:'||chr(38)||'nbsp; Servidor de correo propio, Servidor para alojar una web o Intranet, Conexiones seguras en una Red Privada Virtual, entre otras.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Servicio s'||chr(38)||'oacute;lo disponible para planes PYME.'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Este servicio se contrata como un adicional al plan de internet contratado por un precio de $10,00 (DIEZ D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA mensual'||chr(38)||'nbsp;(m'||chr(38)||'aacute;ximo 1 IP P'||chr(38)||'uacute;blica Fija en la WAN por punto del cliente).'||chr(38)||'nbsp;</span></span></li>
</ul>
');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=66 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='IPF';
 COMMIT;
 END;