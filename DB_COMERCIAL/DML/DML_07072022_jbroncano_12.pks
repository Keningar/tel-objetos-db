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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><span style="font-size:14px"><strong>'||chr(38)||'nbsp;T'||chr(38)||'Eacute;RMINOS Y CONDICIONES DE USO PRODUCTO NETLIFE DEFENSE'||chr(38)||'nbsp; </strong> '||chr(38)||'nbsp;</span></p>

<p style="text-align:justify"><span style="font-size:14px">Netlife Defense es un servicio de seguridad inform'||chr(38)||'aacute;tica y control parental con 3(TRES) licencias multidispositivo provistas por Kaspersky, que permite reducir los riesgos de vulnerabilidades en la navegaci'||chr(38)||'oacute;n y transacciones por internet. '||chr(38)||'nbsp;</span></p>

<p style="text-align:justify"><span style="font-size:14px"><strong>Entre sus beneficios se incluye:</strong> '||chr(38)||'nbsp; '||chr(38)||'nbsp;</span></p>

<ul>
	<li style="text-align:justify"><span style="font-size:14px">Safe Kids (soluci'||chr(38)||'oacute;n de control parental) '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Conexi'||chr(38)||'oacute;n segura. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Restricci'||chr(38)||'oacute;n de acceso no autorizado a la C'||chr(38)||'aacute;mara Web. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Safe Money (protecci'||chr(38)||'oacute;n de transacciones en l'||chr(38)||'iacute;nea). '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Navegaci'||chr(38)||'oacute;n privada. '||chr(38)||'nbsp;</span></li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-size:14px">Antivirus, Antiransomware, Antibanner, Antispam. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Actualizador de software y PC Cleaner, entre otros. '||chr(38)||'nbsp;</span></li>
</ul>

<p style="text-align:justify">'||chr(38)||'nbsp;</p>

<p style="text-align:justify"><span style="font-size:14px"><strong>El m'||chr(38)||'eacute;todo de entrega de este servicio es mediante el env'||chr(38)||'iacute;o por correo electr'||chr(38)||'oacute;nico del c'||chr(38)||'oacute;digo de activaci'||chr(38)||'oacute;n desde </strong> <a href="mailto:defense@netlife.ec" target="_blank"> <strong> <span style="color:black">defense@netlife.ec</span> </strong> </a> <strong> al correo registrado por el cliente en su contrato.</strong> '||chr(38)||'nbsp;</span></p>

<ul>
	<li style="text-align:justify"><span style="font-size:14px">Este correo debe ser un correo electr'||chr(38)||'oacute;nico v'||chr(38)||'aacute;lido. Es responsabilidad del cliente verificar que el correo no se encuentre alojado en la carpeta de correo no deseado. En caso de requerirlo, el cliente podr'||chr(38)||'aacute; solicitar el reenvi'||chr(38)||'oacute; de este correo a trav'||chr(38)||'eacute;s de nuestra central telef'||chr(38)||'oacute;nica 39 20000. '||chr(38)||'nbsp;</span></li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-size:14px">El precio de Netlife Defense como servicio adicional es de $2.75(DOS D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 75/100) mensual m'||chr(38)||'aacute;s IVA. Este servicio incluye 3(TRES) licencias multidispositivo. Netlife Defense est'||chr(38)||'aacute; disponible '||chr(38)||'uacute;nicamente con el servicio de Internet de Netlife. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente). '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Para que esta soluci'||chr(38)||'oacute;n de seguridad inform'||chr(38)||'aacute;tica est'||chr(38)||'eacute; en operaci'||chr(38)||'oacute;n, es necesaria la instalaci'||chr(38)||'oacute;n del software en el dispositivo que requiera protegerse. Es de exclusiva responsabilidad del cliente su efectiva instalaci'||chr(38)||'oacute;n. Conozca el proceso de instalaci'||chr(38)||'oacute;n por dispositivo aqu'||chr(38)||'iacute;. '||chr(38)||'iquest; <a href="https://www.netlife.ec/netlife-defense-repositorio/" target="_blank"> <span style="color:blue">https://www.netlife.ec/netlife-defense-repositorio/</span> </a> . '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Netlife Defense soporta: Equipos de escritorio y port'||chr(38)||'aacute;tiles: Windows 10/8.1 /8 /7 o superior; OS X 10.12 '||chr(38)||'ndash; macOS 10.13 o superiores; Tablets: Windows 10 / 8 '||chr(38)||'amp; 8.1 / Pro (64 bits); iOS 9.0 o posterior; Smartphones: Android 4.1 o posterior, iOS 9.0 o posterior. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Puede ser instalado en el n'||chr(38)||'uacute;mero de computadoras y dispositivos Android indicados en el paquete (3(TRES) dispositivos en cualquier combinaci'||chr(38)||'oacute;n). Siempre que no exceda el n'||chr(38)||'uacute;mero de dispositivos permitidos, podr'||chr(38)||'aacute; desinstalar y reinstalar el producto, adem'||chr(38)||'aacute;s de usar el c'||chr(38)||'oacute;digo de activaci'||chr(38)||'oacute;n cuando sea necesario. '||chr(38)||'nbsp;</span></li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-size:14px">En el caso de Android el producto est'||chr(38)||'aacute; disponible descargando la aplicaci'||chr(38)||'oacute;n Kaspersky Internet Security. En el caso de dispositivos iOS, el producto est'||chr(38)||'aacute; disponible; a trav'||chr(38)||'eacute;s, de la aplicaci'||chr(38)||'oacute;n Kaspersky Safe Browser (para navegaci'||chr(38)||'oacute;n segura). '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">La soluci'||chr(38)||'oacute;n de control parental est'||chr(38)||'aacute; disponible en todos los dispositivos. Para activarla es necesario instalar Kaspersky Safe Kids tanto en PCs como en dispositivos m'||chr(38)||'oacute;viles. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">La protecci'||chr(38)||'oacute;n de la c'||chr(38)||'aacute;mara web est'||chr(38)||'aacute; habilitada para PC y Mac. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Todos los planes Home y Pyme (seg'||chr(38)||'uacute;n la oferta establecida por Netlife), incluyen Netlife Defense, un sistema de seguridad inform'||chr(38)||'aacute;tica y control parental con 3(TRES) licencias multidispositivo para protecci'||chr(38)||'oacute;n en internet provisto por Kaspersky. La protecci'||chr(38)||'oacute;n inicia al momento de instalar el software en el dispositivo, es de exclusiva responsabilidad del cliente su efectiva instalaci'||chr(38)||'oacute;n. '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Para casos en los que ya se encuentre activa tu licencias en uno de tus dispositivos y requieras reutilizarla en otro dispositivo, debes seguir los siguientes pasos: '||chr(38)||'nbsp;</span></li>
</ul>

<p style="margin-left:48px; text-align:justify"><span style="font-size:14px"><strong>1.</strong> '||chr(38)||'iquest;Desinstalar tu licencia activa del dispositivo '||chr(38)||'nbsp;<br />
<strong>2. </strong> '||chr(38)||'iquest;Eliminar el dispositivo de tu administrador en'||chr(38)||'iquest; <a href="https://my.kaspersky.com/%22%20/t%20%22_blank" target="_blank"> <span style="color:blue"> My kaspersky </span> </a> '||chr(38)||'nbsp;<br />
<strong>3. </strong> '||chr(38)||'iquest;Esperar 72 horas m'||chr(38)||'iacute;nimo antes de volver a instalar la licencia en otro dispositivo para evitar que la licencia se bloquee. '||chr(38)||'nbsp;</span></p>

<p style="margin-left:48px; text-align:justify"><span style="font-size:14px"><strong>4.</strong> Si presentas inconvenientes en el primer intento de la instalaci'||chr(38)||'oacute;n de tu licencia Netlife Defense cont'||chr(38)||'aacute;ctate con nosotros al 3920000 para poder asesorarte en el proceso. '||chr(38)||'nbsp;</span></p>

<p style="margin-left:48px; text-align:justify">'||chr(38)||'nbsp;</p>

<p style="text-align:justify"><span style="font-size:14px"><strong>Requisitos de operaci'||chr(38)||'oacute;n: </strong> '||chr(38)||'nbsp;</span></p>

<p style="text-align:justify"><span style="font-size:14px"><strong>Requerimientos m'||chr(38)||'iacute;nimos del sistema para la instalaci'||chr(38)||'oacute;n de Netlife Defense:'||chr(38)||'nbsp;</strong> '||chr(38)||'nbsp;</span></p>

<ul>
	<li style="text-align:justify"><span style="font-size:14px">Disco Duro: Windows: 1.500 MB; Mac 1220 MB. Memoria (RAM) libre:1 GB (32 bits) o 2 GB (64 bits). '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Resoluci'||chr(38)||'oacute;n m'||chr(38)||'iacute;nima de pantalla 1024'||chr(38)||'times;600 (para tablets con Windows), 320'||chr(38)||'times;480 (para dispositivos Android). '||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-size:14px">Conexi'||chr(38)||'oacute;n Activa a Internet. '||chr(38)||'nbsp;</span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=210
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='IPMP';
 COMMIT;
 END;