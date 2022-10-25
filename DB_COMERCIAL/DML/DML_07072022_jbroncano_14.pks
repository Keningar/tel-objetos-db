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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">CONDICIONES DE USO PRODUCTO NETLIFE ASSISTANCE PRO</span></strong>'||chr(38)||'nbsp;</span></span></p>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Netlife Assistance PRO</span></strong>'||chr(38)||'nbsp;</span></span></p>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Netlife Assistance Pro es un servicio que brinda soluciones a los problemas t'||chr(38)||'eacute;cnicos e inform'||chr(38)||'aacute;ticos de un negocio para mejorar su operaci'||chr(38)||'oacute;n, disponible para 5 usuarios. Para acceder a '||chr(38)||'eacute;l es necesario ingresar dentro de la secci'||chr(38)||'oacute;n '||chr(38)||'ldquo;Netlife Access'||chr(38)||'rdquo; en la p'||chr(38)||'aacute;gina web de Netlife o a store.netlife.net.ec'||chr(38)||'nbsp;</span></span></p>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Este servicio incluye:</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Asistencia guiada de configuraci'||chr(38)||'oacute;n, sincronizaci'||chr(38)||'oacute;n y conexi'||chr(38)||'oacute;n a red de software o hardware: PC, MAC.'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Revisi'||chr(38)||'oacute;n, an'||chr(38)||'aacute;lisis y mantenimiento del PC/MAC/LINUX/SmartTV/Smartphones/Tablets/Apple TV/Roku, etc.'||chr(38)||'nbsp;</span></span></li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Asesor'||chr(38)||'iacute;a t'||chr(38)||'eacute;cnica en l'||chr(38)||'iacute;nea las 24 horas v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica o web por <a href="https://store.netlife.net.ec" style="color:inherit" target="_blank"><span style="color:blue">store.netlife.net.ec.'||chr(38)||'nbsp;</span></a>'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Un servicio de Help Desk con ingenieros especialistas.'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Se puede ayudar a reinstalar el Sistema Operativo del dispositivo del cliente, siempre y cuando se disponga de las licencias y medios de instalaci'||chr(38)||'oacute;n originales correspondientes.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Sistemas Operativos sobre los cuales se brinda soporte a incidencias son:'||chr(38)||'nbsp;</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Windows: XP hasta 10, Windows Server: 2003 hasta 2019, MacOs: 10.6 (Snow Leopard) hasta 10.14 (Mojave), Linux: Ubuntu 19.04, Fedora 30, Open SUSE 15.1, Debian 10.0, Red Hat 8, CentOS 7, iOS: 7.1.2 a 12.3.2, Android: Ice Cream Sandwich 4.0 hasta Pie 9.0, Windows Phone OS: 8.0 hasta 10 Mobile'||chr(38)||'nbsp;</span></span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Asistencia Hardware:'||chr(38)||'nbsp;</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Los controladores o software necesarios para el funcionamiento del hardware son responsabilidad del usuario, sin embargo, se dar'||chr(38)||'aacute; apoyo para obtenerlos en caso de ser necesario.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Asistencia Software:</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">No incluye capacitaci'||chr(38)||'oacute;n en el uso del Software. Las licencias y medios de instalaci'||chr(38)||'oacute;n son a cargo del usuario. Nunca se prestar'||chr(38)||'aacute; ayuda sobre software ilegal.'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">No incluye capacitaci'||chr(38)||'oacute;n en el uso del Sistema Operativo y software, '||chr(38)||'uacute;nicamente se solucionar'||chr(38)||'aacute;n incidencias puntuales.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Para recibir asistencia se dispone de 3(TRES) canales de atenci'||chr(38)||'oacute;n habilitados las 24(VEINTI CUATRO) horas del d'||chr(38)||'iacute;a:'||chr(38)||'nbsp;</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Chat, llamada telef'||chr(38)||'oacute;nica y correo electr'||chr(38)||'oacute;nico.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">El tiempo de atenci'||chr(38)||'oacute;n de los distintos canales son:</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Chat 30(TREINTA) segundos, v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica 60(SESENTA) segundos (3920000), y v'||chr(38)||'iacute;a correo electr'||chr(38)||'oacute;nico 20(VEINTE) minutos (<a href="mailto:soporte@store.netlife.net.ec" style="color:inherit" target="_blank"><span style="color:blue">soporte@store.netlife.net.ec</span></a>)'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Se mantendr'||chr(38)||'aacute; en la plataforma durante 60(SESENTA) d'||chr(38)||'iacute;as, el 100% de las conversaciones chat levantadas v'||chr(38)||'iacute;a web; a trav'||chr(38)||'eacute;s de, <a href="https://store.netlife.net.ec" style="color:inherit" target="_blank"><span style="color:blue">store.netlife.net.ec</span></a>'||chr(38)||'nbsp;</span></span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:black">Netlife Assistance Pro como servicio adicional</span></strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Tiene un precio de $2,99(DOS D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 99/100) m'||chr(38)||'aacute;s IVA mensual, que se a'||chr(38)||'ntilde;ade a planes de Internet de Netlife.'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio tiene un tiempo de permanencia m'||chr(38)||'iacute;nima de 12(DOCE) meses. En caso de cancelaci'||chr(38)||'oacute;n anticipada aplica el pago de los descuentos a los que haya accedido el cliente por promociones, tales como instalaci'||chr(38)||'oacute;n, tarifas preferenciales, etc.'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio de Netlife Assistance Pro, no incluye visitas presenciales, pero si el cliente lo requiere podr'||chr(38)||'aacute; coordinar dichas visitas por un costo adicional de $30(TREINTA D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA en ciudad y $35(TREINTA D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA en zonas for'||chr(38)||'aacute;neas (aplica solo para Quito y Guayaquil).'||chr(38)||'nbsp;</span></span></li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Costo de la hora adicional despu'||chr(38)||'eacute;s de la primera hora de atenci'||chr(38)||'oacute;n $10(DIEZ D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA.'||chr(38)||'nbsp;</span></span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Todos los planes Pro y PYME (seg'||chr(38)||'uacute;n la oferta establecida por Netlife), incluyen Netlife Assistance Pro, un servicio de asistencia especializada en problemas t'||chr(38)||'eacute;cnicos e inform'||chr(38)||'aacute;ticos, disponible para 5 (CINCO) usuarios. Para acceder a '||chr(38)||'eacute;l es necesario ingresar dentro de la secci'||chr(38)||'oacute;n '||chr(38)||'ldquo;Netlife Access'||chr(38)||'rdquo; en la p'||chr(38)||'aacute;gina web de Netlife o a store.netlife.net.ec.'||chr(38)||'nbsp;'||chr(38)||'nbsp;</span></span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1262
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='KO01';
 COMMIT;
 END;