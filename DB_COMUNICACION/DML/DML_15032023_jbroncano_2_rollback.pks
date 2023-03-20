 DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada, '

<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<body>
<table align="center" width="40%" cellspacing="0" cellpadding="5">
<tr>
<td align="center">
<img alt="" height="250" width="600"  src="https://gallery.mailchimp.com/ecceab7377f33e3b122ec2a74/images/26d2b77d-827c-43de-b27b-f9f3e9e5bb75.png"/>
</td>
</tr>
<tr>
<td>
<table width="100%" cellspacing="0" cellpadding="5" align="center" style="font-family:arial;text-align: justify;">
<tr>
<td colspan="2" align = "center" ><h2>Hola {{nombrecliente}}</h2><hr></td>
</tr>

<tr>
<td colspan="2">
Felicitaciones, has escogido el plan: {{nombrePlan}} . Ya hemos registrado el contrato de tu servicio de Ultra Alta Velocidad en nuestro sistema y adicionalmente te lo adjuntamos en este correo para que puedas tenerlo siempre.
</td>
</tr>

<tr>
<td colspan="2">
Tu servicio ser'||chr(38)||'aacute; facturado en el {{nombreCicloFacturacion}}.
</td>
</tr>

<tr>
<td colspan="2">
Lo siguiente que haremos ser'||chr(38)||'aacute; enviar la petici'||chr(38)||'oacute;n a nuestra '||chr(38)||'aacute;rea de planificaci'||chr(38)||'oacute;n y log'||chr(38)||'iacute;stica, ellos revisar'||chr(38)||'aacute;n informaci'||chr(38)||'oacute;n t'||chr(38)||'eacute;cnica y asignar'||chr(38)||'aacute;n los recursos necesarios para tu servicio. Posteriormente se contactar'||chr(38)||'aacute;n contigo para agendar la visita de instalaci'||chr(38)||'oacute;n en una fecha y rango horario. Recuerda que el tiempo de instalaci'||chr(38)||'oacute;n promedio suele ser de 7 d'||chr(38)||'iacute;as h'||chr(38)||'aacute;biles, sin embargo podr'||chr(38)||'iacute;a ser superior en funci'||chr(38)||'oacute;n de las condiciones t'||chr(38)||'eacute;cnicas y de cobertura. Mientras tanto, quisi'||chr(38)||'eacute;ramos recomendarte los siguientes temas que seguro ser'||chr(38)||'aacute;n de utilidad:</td>
</tr>

<tr>
<td colspan="2" style="font-size:15">
<b>CARACTER'||chr(38)||'Iacute;STICAS DEL SERVICIO:</b>
</td>
</tr>

<tr>
<td colspan="2">
<ol>
<li>
El servicio contratado se encuentra en bits por segundo. El est'||chr(38)||'aacute;ndar para medir velocidad de enlaces es en bits por segundo y el de descarga de archivos es en bytes por segundo. (1 byte es igual a 8 bits)
</li>
<li>
El servicio no est'||chr(38)||'aacute; disponible para CYBERS o para cualquier actividad NO relacionada con la actividad inicialmente contratada, as'||chr(38)||'iacute; como tambi'||chr(38)||'eacute;n la reventa del mismo.
</li>
<li>
El equipo WiFi est'||chr(38)||'aacute;ndar tiene una cobertura horizontal que depende de los obst'||chr(38)||'aacute;culos que existan (paredes, puertas, pisos), por lo cual no se puede garantizar distancias con obst'||chr(38)||'aacute;culos ya que depende de la estructura/arquitectura de la residencia del cliente. Su cobertura horizontal CON obst'||chr(38)||'aacute;culos es de 10mts y SIN obst'||chr(38)||'aacute;culos es de 50mts de radio.
</li>
<li>
El tiempo de instalaci'||chr(38)||'oacute;n promedio del servicio es de 7 d'||chr(38)||'iacute;as h'||chr(38)||'aacute;biles, luego de haber firmado el contrato, haber entregado toda la documentaci'||chr(38)||'oacute;n y haber ingresado el contrato a nuestro sistema de gesti'||chr(38)||'oacute;n, sin embargo puede variar en funci'||chr(38)||'oacute;n de las condiciones t'||chr(38)||'eacute;cnicas y cobertura. No incluye obras civiles o cambios de acometida, la instalaci'||chr(38)||'oacute;n incluye 250m de fibra '||chr(38)||'oacute;ptica, el valor del metro de fibra '||chr(38)||'oacute;ptica adicional es de 1.00 USD + IVA.
</li>
<li>
NETLIFE ofrece soluciones de fibra '||chr(38)||'oacute;ptica invisible para residencias por un valor adicional.
</li>
<li>
Los equipos entregados son propiedad de MEGADATOS y deber'||chr(38)||'aacute;n ser devueltos en las oficinas de MEGADATOS al finalizar el contrato, caso contrario los equipos ser'||chr(38)||'aacute;n facturados y cobrados al cliente.
</li>
<li>
El cliente acepta que para salvaguardar la integridad de la red y evitar el SPAM el puerto 25 está bloqueado en servicios HOME.
</li>
<li>
El cliente conoce y acepta que la velocidad del plan contratado puede entregarse mediante conexi'||chr(38)||'oacute;n al'||chr(38)||'aacute;mbrica al equipo WiFi estandar ofrecido por NETLIFE. En el caso de realizar la conexi'||chr(38)||'oacute;n en forma inal'||chr(38)||'aacute;mbrica por WiFi, la tasa de transferencia llega hasta 30Mbps considerando las condiciones del punto 3. NETLIFE ofrece por un valor adicional SMARTWIFI que permite alcanzar velocidades superiores para planes de Ultra Alta Velocidad.
</li>

<li>
El cliente conoce y acepta las velocidades indicadas del plan suscrito en la solicitud de prestaci'||chr(38)||'oacute;n de servicios, incluyendo su compartici'||chr(38)||'oacute;n y velocidades m'||chr(38)||'iacute;nimas.
</li>

</ol>

</td>
</tr>


<tr>
<td colspan="2" style="font-size:15">
<b>PLAZO, FACTURACION Y FORMA DE PAGO:</b>
</td>
</tr>


<tr>
<td colspan="2">
<ol>
<li>

El cliente acepta la cl'||chr(38)||'aacute;usula de permanencia m'||chr(38)||'iacute;nima por promociones sujeta al tiempo de permanencia de 36 meses que dura el contrato.
</li>

<li>
Si el cliente termina anticipadamente el contrato, antes del tiempo de permanencia m'||chr(38)||'iacute;nima, deber'||chr(38)||'aacute; cancelar el valor total de las promociones con las que se benefici'||chr(38)||'oacute;.
</li>

<li>
Los valores a pagar est'||chr(38)||'aacute;n descritos en la solicitud de servicios y recibi'||chr(38)||'oacute; el contrato con dichos valores en forma legible.
</li>

<li>
El servicio contratado se paga durante los 5 primeros d'||chr(38)||'iacute;as de cada mes luego de recibir la FACTURA.
</li>

<li>
En caso de no haber pagado el servicio en el plazo establecido, el servicio podr'||chr(38)||'aacute; suspendido en cualquier momento.
</li>

<li>
En el caso de Planes con promociones por pago anticipado, debe ser pagado hasta m'||chr(38)||'aacute;ximo 1 semana luego de la fecha de activaci'||chr(38)||'oacute;n del plan.
</li>

<li>
Existen dos ciclos de facturaci'||chr(38)||'oacute;n. Si eres cliente del CICLO I el primer d'||chr(38)||'iacute;a del mes recibir'||chr(38)||'aacute;s tu factura electr'||chr(38)||'oacute;nica por el servicio mensual que comprende del 1 al 30/31 del mes pero si eres cliente del CICLO II el 15 del mes recibir'||chr(38)||'aacute;s tu factura electr'||chr(38)||'oacute;nica por el servicio mensual que comprende del 15 del mes corriente al 14 del siguiente mes.
</li>


</ol>

</td>
</tr>

<tr>
<td colspan="2" style="font-size:15">
<b>MEDIOS DE COMUNICACI'||chr(38)||'Oacute;N Y SOPORTE:</b>
</td>
</tr>

<tr>
<td colspan="2">
<ol>
<li>
Usted puede comunicarse con nuestro centro de atención al cliente 1-700-638-543, 3920000 o al correo electr'||chr(38)||'oacute;nico <a href="mailto:info@netlife.net.ec" target="_top"> info@netlife.net.ec</a> las 24 horas del d'||chr(38)||'iacute;a, los 365 d'||chr(38)||'iacute;as del a'||chr(38)||'ntilde;o.
</li>

<li>
En caso de soporte, el tiempo de atenci'||chr(38)||'oacute;n empieza desde el registro de la incidencia en nuestro centro de atenci'||chr(38)||'oacute;n, donde se entregar'||chr(38)||'aacute; un n'||chr(38)||'uacute;mero de ticket con el cual se podr'||chr(38)||'aacute; hacer seguimiento al caso.
</li>
</ol>
</td>
</tr>
<tr>
<td colspan="2">
Adicionalmente, hay algunos complementos que pueden ayudarte a mantener la mejor velocidad, seguridad y experiencia en Internet. Aqu'||chr(38)||'iacute; encontrar'||chr(38)||'aacute;s algunos links a temas que podr'||chr(38)||'iacute;an interesarte.
</td>
</tr>


<tr>
<td colspan="2">
<ul>
<li>
¿Interesado en proteger lo que m'||chr(38)||'aacute;s quieres en Internet? Visita <a href="http://bit.ly/1zdjkhl"  target="_blank">LINK </a>
</li>

<li>
¿Te gustar'||chr(38)||'iacute;a saber lo que sucede en tu hogar aunque no est'||chr(38)||'eacute;s presente? Visita <a href="http://bit.ly/12fkwSY"  target="_blank">LINK </a>
</li>

<li>
¿Te gustar'||chr(38)||'iacute;a tener 1.000GB de almacenamiento en la nube? Visita <a href="http://bit.ly/1zdjkhl"  target="_blank">LINK </a>
</li>

</ul>

</td>
</tr>

<tr>
<td colspan="2">
Finalmente, te sugerimos revisar nuestras gu'||chr(38)||'iacute;as de uso que contienen algunos consejos y consideraciones para que vivas la mejor experiencia con tu servicio e ingreses a nuestra secci'||chr(38)||'oacute;n de comunidad donde encontrar'||chr(38)||'aacute;s links a herramientas y contenido relevante:
</td>
</tr>


<tr>
<td colspan="2">
<ul>
<li>
<a href="http://www.netlife.ec/comunidad/" target="_blank">Secci'||chr(38)||'oacute;n Comunidad</a>
</li>

<li>
<a href="http://www.netlife.ec/comunidad/guias-de-usuario/" target="_blank">Gu'||chr(38)||'iacute;as de Usuario</a>

</li>

</ul>

</td>
</tr>


<tr>
<td colspan="2">
Si tienes cualquier requerimiento, puedes contactarnos a: <a href="mailto:soporte@netlife.net.ec" target="_top"> soporte@netlife.net.ec</a> o al 3920000
</td>
</tr>

<tr>
<td colspan="2" height="30"></td>
</tr>


<tr>
<td colspan="2">
EQUIPO NETLIFE <br>
1-700-683-543 | 3920000
</td>
</tr>


<tr>
<td colspan="2" height="30"></td>
</tr>

<tr>
<td colspan="2">

<table width="100%" cellspacing="0" cellpadding="5" bgcolor="#000000">
<tr>
<td width="140">
</td>
<td width="20">
<a href="https://www.facebook.com/netlife.ecuador?ref=ts'||chr(38)||'fref=ts" target="_blank">
<img border=0 width=24 height=24  src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-facebook-48.png">
</a>
</td>
<td style="padding:0cm 0cm 0cm 3.75pt">
<a href="https://www.facebook.com/netlife.ecuador?ref=ts'||chr(38)||'fref=ts" target="_blank">/NetlifeEcuador</a>
<td>
</tr>

<tr>
<td>
</td>
<td>
<a href="https://twitter.com/NetlifeEcuador" target="_blank">
<img border=0 width=24 height=24  src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-twitter-48.png">
</a>
</td>
<td style="padding:0cm 0cm 0cm 3.75pt">
<a href="https://twitter.com/NetlifeEcuador" target="_blank">@NetlifeEcuador</a>
<td>
</tr>

<tr>
<td>
</td>
<td>
<a href="https://www.youtube.com/user/NetlifeEcuador" target="_blank">
<img border=0 width=24 height=24 src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-youtube-48.png">
</a>
</td>
<td style="padding:0cm 0cm 0cm 3.75pt">
<a href="https://www.youtube.com/user/NetlifeEcuador" target="_blank">/NetlifeEcuador</a>
<td>
</tr>


</table>

</td>
</tr>


</table>
</body>
</html>

');


UPDATE DB_COMUNICACION.ADMI_PLANTILLA
SET PLANTILLA=bada
where CODIGO = 'CONTDIGITAL_NEW';
COMMIT;
END;