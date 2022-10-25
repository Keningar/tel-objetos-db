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
DBMS_LOB.APPEND(bada, '<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>PUNTO CABLEADO ETHERNET</strong> </span></span></p>

<p><br />
'||chr(38)||'nbsp;</p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Punto Cableado Ethernet es un producto que contempla la instalaci'||chr(38)||'oacute;n o acondicionamiento de un (1) punto cableado a un (1) dispositivo del cliente, para acceso a internet directo por cable. El producto tiene un metraje m'||chr(38)||'aacute;ximo de 30mts e incluye para su acondicionamiento 2 conectores y 10 metros de canaleta. </span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Por la contrataci'||chr(38)||'oacute;n del producto el cliente realiza un pago '||chr(38)||'uacute;nico de $35,00+iva, que se incluir'||chr(38)||'aacute; en su factura. Este producto no tiene un tiempo m'||chr(38)||'iacute;nimo de permanencia y no es sujeto de traslado. </span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">La contrataci'||chr(38)||'oacute;n del servicio est'||chr(38)||'aacute; limitada a 3 puntos cableados por punto del cliente.</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">En caso de que el cliente requiera que se le retire el punto cableado, se le cobrar'||chr(38)||'aacute; el valor de la visita t'||chr(38)||'eacute;cnica programada cuyo valor se puede encontrar en la secci'||chr(38)||'oacute;n de atenci'||chr(38)||'oacute;n al cliente de: <a href="https://www.netlife.ec/">https://www.netlife.ec</a> </span></span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1332
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='CABL';
 COMMIT;
 END;