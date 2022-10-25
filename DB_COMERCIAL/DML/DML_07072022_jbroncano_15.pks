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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><span style="font-family:Arial,Helvetica,sans-serif"><strong><span style="color:#000000">CONDICIONES DE USO PRODUCTO CONSTRUCTOR WEB</span> </strong></span></p>

<p><span style="font-family:Arial,Helvetica,sans-serif">Constructor Web es un servicio que te permite construir tu propia p'||chr(38)||'aacute;gina web, tener 1(UN) dominio propio y 5(CINCO) cuentas de correo asociadas a este dominio. '||chr(38)||'iquest; Adem'||chr(38)||'aacute;s de, asesor'||chr(38)||'iacute;a t'||chr(38)||'eacute;cnica en l'||chr(38)||'iacute;nea las 24(VEINTI CUATRO) horas v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica o web por <a href="https://store.netlife.net.ec/"><em><u><span style="color:#0000ff"><u><em>store.netlife.net.ec</em></u></span></u></em></a>'||chr(38)||'nbsp;.'||chr(38)||'iquest; El acceso al servicio es posible desde <a href="https://store.netlife.net.ec/"><u><span style="color:#0000ff"><u>store.netlife.net.ec</u></span></u></a>'||chr(38)||'nbsp;</span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif">Se incluye el servicio de dise'||chr(38)||'ntilde;o de la p'||chr(38)||'aacute;gina web por parte del equipo de dise'||chr(38)||'ntilde;o bajo solicitud del usuario y sujeto al env'||chr(38)||'iacute;o de la informaci'||chr(38)||'oacute;n relevante para su creaci'||chr(38)||'oacute;n.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">El servicio incluye hasta 5(CINCO) p'||chr(38)||'aacute;ginas de contenido, formulario de contacto para recibir comunicaci'||chr(38)||'oacute;n de los visitantes a un correo especificado, links a las redes sociales, mapa de Google interactivo, conexi'||chr(38)||'oacute;n con Google Analytics.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">El tiempo de entrega/publicaci'||chr(38)||'oacute;n estimado es de 5(CINCO) d'||chr(38)||'iacute;as h'||chr(38)||'aacute;biles, pero est'||chr(38)||'aacute; sujeto al env'||chr(38)||'iacute;o oportuno de informaci'||chr(38)||'oacute;n del cliente, as'||chr(38)||'iacute; como del volumen de material recibido. '||chr(38)||'iquest;'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">En cuanto al dominio: La propiedad del dominio est'||chr(38)||'aacute; condicionada a un tiempo de permanencia m'||chr(38)||'iacute;nima de 12 meses y se renueva anualmente.'||chr(38)||'nbsp;</span></li>
</ul>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif">En caso de cancelarlo antes de los 12 meses de cualquiera de sus per'||chr(38)||'iacute;odos de vigencia y renovaci'||chr(38)||'oacute;n, el cliente deber'||chr(38)||'aacute; pagar el valor proporcional, de acuerdo con el tiempo de vigencia que resta por cubrir.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">Es responsabilidad del cliente tomar las medidas necesarias para almacenar la informaci'||chr(38)||'oacute;n colocada en su p'||chr(38)||'aacute;gina web.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">El servicio incluye Webmail: Administraci'||chr(38)||'oacute;n de correos, carpetas, y filtros con una interfaz intuitiva y f'||chr(38)||'aacute;cil de utilizar proporcionada por Roundcube. Se puede agregar cualquier cuenta IMAP/POP para tener una '||chr(38)||'uacute;nica interfaz.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">El servicio tambi'||chr(38)||'eacute;n incluye 5 cuentas de correo: Capacidad de 1 Gb de almacenamiento por cuenta. Archivos adjuntos: hasta 25 Mb por correo enviado.'||chr(38)||'nbsp;</span></li>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="background-color:#00ffff">El servicio ofrece la opci'||chr(38)||'oacute;n de configuraci'||chr(38)||'oacute;n de pagos en l'||chr(38)||'iacute;nea en la p'||chr(38)||'aacute;gina web, siendo responsabilidad del cliente gestionar por sus propios medios la creaci'||chr(38)||'oacute;n y aprobaci'||chr(38)||'oacute;n de su cuenta en cada pasarela de pagos.'||chr(38)||'nbsp;</span>'||chr(38)||'nbsp;</span></li>
</ul>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="background-color:#00ffff">Con sus propias credenciales el cliente podr'||chr(38)||'aacute; solicitar la configuraci'||chr(38)||'oacute;n de la funcionalidad de pagos en l'||chr(38)||'iacute;nea en su p'||chr(38)||'aacute;gina web.'||chr(38)||'nbsp;</span>'||chr(38)||'nbsp;</span></p>

<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="background-color:#00ffff">El cliente es responsable del env'||chr(38)||'iacute;o y recepci'||chr(38)||'oacute;n del dinero a trav'||chr(38)||'eacute;s de esta pasarela; as'||chr(38)||'iacute; como, del pago de comisiones e impuestos que rijan por el uso de este servicio (pasarela de pagos). En este sentido, el cliente asume total responsabilidad sobre el tratamiento de su cuenta y cumplimiento de pol'||chr(38)||'iacute;ticas. MEGADATOS no se hace responsable de la gesti'||chr(38)||'oacute;n de la pasarela de pagos en cuanto a envi'||chr(38)||'oacute;, recepci'||chr(38)||'oacute;n de dinero y pagos hacia la plataforma. MEGADATOS'||chr(38)||'nbsp; no tiene convenio con ninguna de las empresas que ofrecen el servicio de pasarela de pago. El cliente es responsable del manejo de su cuenta, as'||chr(38)||'iacute; como del ingreso y recepci'||chr(38)||'oacute;n del dinero. El porcentaje de cobro de comisiones por el uso de la pasarela de pago no depende de MEGADATOS, depende 100% del proveedor del servicio y su convenio directo con el cliente.</span>'||chr(38)||'nbsp;</span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif">El servicio no incluye mantenimientos programados a las plataformas que soportan al correo y mantenimientos no programados para solventar situaciones cr'||chr(38)||'iacute;ticas. '||chr(38)||'iquest;'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">Netlife Constructor Web tiene un precio de $14,99(CATORCE D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 99/100) m'||chr(38)||'aacute;s IVA mensual, que se a'||chr(38)||'ntilde;ade a planes de Internet de Netlife.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).'||chr(38)||'nbsp;</span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif">Navegadores Soportados: Windows Vista, 7, y 8 | IE 9.0 en adelante | Firefox versi'||chr(38)||'oacute;n 19 en adelante. | Google Chrome versi'||chr(38)||'oacute;n 25 en adelante | Windows 10 | Edge 12 en adelante | Mac OS X 10.4, 10.5, y 10.6 | Firefox versi'||chr(38)||'oacute;n 19 en adelante | Safari versi'||chr(38)||'oacute;n 4.0 en adelante'||chr(38)||'nbsp;</span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif">Se considera '||chr(38)||'ldquo;spam'||chr(38)||'rdquo; la pr'||chr(38)||'aacute;ctica de enviar mensajes de correo electr'||chr(38)||'oacute;nico no deseados, a menudo con contenido comercial, en grandes cantidades a los usuarios, sin darles la opci'||chr(38)||'oacute;n de darse de baja o excluirse de una lista de distribuci'||chr(38)||'oacute;n.'||chr(38)||'nbsp;</span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif">Por lo anterior, queda prohibido que el cliente use el correo para estos fines.'||chr(38)||'nbsp;</span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="color:#000000">En caso de cualquier violaci'||chr(38)||'oacute;n a estas Pol'||chr(38)||'iacute;ticas, se proceder'||chr(38)||'aacute; a tomar una de las siguientes medidas:'||chr(38)||'nbsp;</span>'||chr(38)||'nbsp;</span></p>

<ol>
	<li><span style="font-family:Arial,Helvetica,sans-serif">Suspender/Bloquear la cuenta por un lapso de 72 horas.'||chr(38)||'nbsp;</span></li>
</ol>

<ol start="2">
	<li><span style="font-family:Arial,Helvetica,sans-serif">Suspender/Bloquear la cuenta por un lapso de 144 horas.'||chr(38)||'nbsp;</span></li>
</ol>

<ol start="3">
	<li><span style="font-family:Arial,Helvetica,sans-serif">Suspender/Bloquear todo tr'||chr(38)||'aacute;fico del dominio y se iniciar'||chr(38)||'aacute; el proceso de baja de servicio.'||chr(38)||'nbsp;</span></li>
</ol>

<ul>
	<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif">Los planes PYME (seg'||chr(38)||'uacute;n la oferta establecida por Netlife) pueden incluir el servicio de Constructor Web, para construir tu propia p'||chr(38)||'aacute;gina web, tener 1(UN) dominio propio y 5(CINCO) cuentas de correo asociadas a este dominio. Adem'||chr(38)||'aacute;s de, asesor'||chr(38)||'iacute;a t'||chr(38)||'eacute;cnica en l'||chr(38)||'iacute;nea las 24(VEINTI CUATRO) horas v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica, chat o web. Para acceder al servicio es necesario ingresar dentro de la secci'||chr(38)||'oacute;n '||chr(38)||'ldquo;Netlife Access'||chr(38)||'rdquo; en la p'||chr(38)||'aacute;gina web de Netlife o a store.netlife.net.ec.'||chr(38)||'nbsp;'||chr(38)||'nbsp;</span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1263
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='KO02';
 COMMIT;
 END;