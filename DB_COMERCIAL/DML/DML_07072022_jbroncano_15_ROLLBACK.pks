/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Rollback de Terminos y Condiciones
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 07-07-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:=' <p style="text-align:center"><strong><span style="font-size:18,0000pt"><span style="font-family:Calibri"><span style="color:#000000"><strong>CONDICIONES DE USO PRODUCTO CONSTRUCTOR WEB</strong></span></span></span></strong>'||chr(38)||'nbsp;</p>

<p> '||chr(38)||'nbsp;</p>

<p><span style="font-family:Calibri">Constructor Web es un servicio que te permite construir tu propia p'||chr(38)||'aacute;gina web, tener 1(UN) dominio propio y 5(CINCO) cuentas de correo asociadas a este dominio. ​ Adem'||chr(38)||'aacute;s de, asesor'||chr(38)||'iacute;a t'||chr(38)||'eacute;cnica en l'||chr(38)||'iacute;nea las 24(VEINTI CUATRO) horas v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica o web por </span><a href="https://store.netlife.net.ec/"><em><u><span style="font-family:Calibri"><span style="color:#0000ff"><u><em>store.netlife.net.ec</em></u></span></span></u></em></a><span style="font-family:Calibri">'||chr(38)||'nbsp;.​ El acceso al servicio es posible desde </span><a href="https://store.netlife.net.ec/"><u><span style="font-family:Calibri"><span style="color:#0000ff"><u>store.netlife.net.ec</u></span></span></u></a>'||chr(38)||'nbsp;</p>

<ul>
	<li><span style="font-family:Calibri">Se incluye el servicio de dise'||chr(38)||'ntilde;o de la p'||chr(38)||'aacute;gina web por parte del equipo de dise'||chr(38)||'ntilde;o bajo solicitud del usuario y sujeto al env'||chr(38)||'iacute;o de la informaci'||chr(38)||'oacute;n relevante para su creaci'||chr(38)||'oacute;n.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">El servicio incluye hasta 5(CINCO) p'||chr(38)||'aacute;ginas de contenido, formulario de contacto para recibir comunicaci'||chr(38)||'oacute;n de los visitantes a un correo especificado, links a las redes sociales, mapa de Google interactivo, conexi'||chr(38)||'oacute;n con Google Analytics.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">El tiempo de entrega/publicaci'||chr(38)||'oacute;n estimado es de 5(CINCO) d'||chr(38)||'iacute;as h'||chr(38)||'aacute;biles, pero est'||chr(38)||'aacute; sujeto al env'||chr(38)||'iacute;o oportuno de informaci'||chr(38)||'oacute;n del cliente, as'||chr(38)||'iacute; como del volumen de material recibido. ​</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">En cuanto al dominio: La propiedad del dominio est'||chr(38)||'aacute; condicionada a un tiempo de permanencia m'||chr(38)||'iacute;nima de 12 meses y se renueva anualmente.</span>'||chr(38)||'nbsp;</li>
</ul>

<ul>
	<li><span style="font-family:Calibri">En caso de cancelarlo antes de los 12 meses de cualquiera de sus per'||chr(38)||'iacute;odos de vigencia y renovaci'||chr(38)||'oacute;n, el cliente deber'||chr(38)||'aacute; pagar el valor proporcional, de acuerdo con el tiempo de vigencia que resta por cubrir.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Es responsabilidad del cliente tomar las medidas necesarias para almacenar la informaci'||chr(38)||'oacute;n colocada en su p'||chr(38)||'aacute;gina web.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">El servicio incluye Webmail: Administraci'||chr(38)||'oacute;n de correos, carpetas, y filtros con una interfaz intuitiva y f'||chr(38)||'aacute;cil de utilizar proporcionada por Roundcube. Se puede agregar cualquier cuenta IMAP/POP para tener una '||chr(38)||'uacute;nica interfaz.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">El servicio tambi'||chr(38)||'eacute;n incluye 5 cuentas de correo: Capacidad de 1 Gb de almacenamiento por cuenta. Archivos adjuntos: hasta 25 Mb por correo enviado.</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="background-color:#00ffff"><span style="font-family:Calibri">El servicio ofrece la opci'||chr(38)||'oacute;n de configuraci'||chr(38)||'oacute;n de pagos en l'||chr(38)||'iacute;nea en la p'||chr(38)||'aacute;gina web, siendo responsabilidad del cliente gestionar por sus propios medios la creaci'||chr(38)||'oacute;n y aprobaci'||chr(38)||'oacute;n de su cuenta en cada pasarela de pagos.'||chr(38)||'nbsp;</span></span>'||chr(38)||'nbsp;</li>
</ul>

<p style="text-align:justify"><span style="background-color:#00ffff"><span style="font-family:Calibri">Con sus propias credenciales el cliente podr'||chr(38)||'aacute; solicitar la configuraci'||chr(38)||'oacute;n de la funcionalidad de pagos en l'||chr(38)||'iacute;nea en su p'||chr(38)||'aacute;gina web.'||chr(38)||'nbsp;</span></span>'||chr(38)||'nbsp;</p>

<p style="text-align:justify"><span style="background-color:#00ffff"><span style="font-family:Calibri">El cliente es responsable del env'||chr(38)||'iacute;o y recepci'||chr(38)||'oacute;n del dinero a trav'||chr(38)||'eacute;s de esta pasarela; as'||chr(38)||'iacute; como, del pago de comisiones e impuestos que rijan por el uso de este servicio (pasarela de pagos). En este sentido, el cliente asume total responsabilidad sobre el tratamiento de su cuenta y cumplimiento de pol'||chr(38)||'iacute;ticas. MEGADATOS no se hace responsable de la gesti'||chr(38)||'oacute;n de la pasarela de pagos en cuanto a envi'||chr(38)||'oacute;, recepci'||chr(38)||'oacute;n de dinero y pagos hacia la plataforma. MEGADATOS'||chr(38)||'nbsp; no tiene convenio con ninguna de las empresas que ofrecen el servicio de pasarela de pago. El cliente es responsable del manejo de su cuenta, as'||chr(38)||'iacute; como del ingreso y recepci'||chr(38)||'oacute;n del dinero. El porcentaje de cobro de comisiones por el uso de la pasarela de pago no depende de MEGADATOS, depende 100% del proveedor del servicio y su convenio directo con el cliente.</span></span>'||chr(38)||'nbsp;</p>

<ul>
	<li><span style="font-family:Calibri">El servicio no incluye mantenimientos programados a las plataformas que soportan al correo y mantenimientos no programados para solventar situaciones cr'||chr(38)||'iacute;ticas. ​</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Netlife Constructor Web tiene un precio de $14,99(CATORCE D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 99/100) m'||chr(38)||'aacute;s IVA mensual, que se a'||chr(38)||'ntilde;ade a planes de Internet de Netlife.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span>'||chr(38)||'nbsp;</li>
</ul>

<p><span style="font-family:Calibri">Navegadores Soportados: Windows Vista, 7, y 8 | IE 9.0 en adelante | Firefox versi'||chr(38)||'oacute;n 19 en adelante. | Google Chrome versi'||chr(38)||'oacute;n 25 en adelante | Windows 10 | Edge 12 en adelante | Mac OS X 10.4, 10.5, y 10.6 | Firefox versi'||chr(38)||'oacute;n 19 en adelante | Safari versi'||chr(38)||'oacute;n 4.0 en adelante</span>'||chr(38)||'nbsp;</p>

<ul>
	<li><span style="font-family:Calibri">Se considera '||chr(38)||'ldquo;spam'||chr(38)||'rdquo; la pr'||chr(38)||'aacute;ctica de enviar mensajes de correo electr'||chr(38)||'oacute;nico no deseados, a menudo con contenido comercial, en grandes cantidades a los usuarios, sin darles la opci'||chr(38)||'oacute;n de darse de baja o excluirse de una lista de distribuci'||chr(38)||'oacute;n.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Por lo anterior, queda prohibido que el cliente use el correo para estos fines.</span>'||chr(38)||'nbsp;</li>
</ul>

<p><strong><span style="font-family:Calibri"><span style="color:#000000"><strong>En caso de cualquier violaci'||chr(38)||'oacute;n a estas Pol'||chr(38)||'iacute;ticas, se proceder'||chr(38)||'aacute; a tomar una de las siguientes medidas:'||chr(38)||'nbsp;</strong></span></span></strong>'||chr(38)||'nbsp;</p>

<ol>
	<li><span style="font-family:Calibri">Suspender/Bloquear la cuenta por un lapso de 72 horas.</span>'||chr(38)||'nbsp;</li>
</ol>

<ol start="2">
	<li><span style="font-family:Calibri">Suspender/Bloquear la cuenta por un lapso de 144 horas.</span>'||chr(38)||'nbsp;</li>
</ol>

<ol start="3">
	<li><span style="font-family:Calibri">Suspender/Bloquear todo tr'||chr(38)||'aacute;fico del dominio y se iniciar'||chr(38)||'aacute; el proceso de baja de servicio.</span>'||chr(38)||'nbsp;</li>
</ol>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">Los planes PYME (seg'||chr(38)||'uacute;n la oferta establecida por Netlife) pueden incluir el servicio de Constructor Web, para construir tu propia p'||chr(38)||'aacute;gina web, tener 1(UN) dominio propio y 5(CINCO) cuentas de correo asociadas a este dominio. Adem'||chr(38)||'aacute;s de, asesor'||chr(38)||'iacute;a t'||chr(38)||'eacute;cnica en l'||chr(38)||'iacute;nea las 24(VEINTI CUATRO) horas v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica, chat o web. Para acceder al servicio es necesario ingresar dentro de la secci'||chr(38)||'oacute;n '||chr(38)||'ldquo;Netlife Access'||chr(38)||'rdquo; en la p'||chr(38)||'aacute;gina web de Netlife o a store.netlife.net.ec.'||chr(38)||'nbsp;</span>'||chr(38)||'nbsp;</li>
</ul>
';
BEGIN
DBMS_LOB.APPEND(bada, ' <p style="text-align: center;">
   <strong>TÉRMINOS Y CONDICIONES DE CONSTRUCTOR WEB</strong>
 </p>
 <p>Constructor Web es un servicio que te permite construir tu propia página web, tener 1(UN) dominio propio y 5(CINCO) cuentas de correo asociadas a este dominio. Además de, asesoría técnica en línea las 24(VEINTI CUATRO) horas vía telefónica o web por'||chr(38)||'nbsp; <a href="https://store.netlife.net.ec/">
     <em>store.netlife.net.ec</em>
   </a>'||chr(38)||'nbsp;. El acceso al servicio es posible desde'||chr(38)||'nbsp; <a href="https://store.netlife.net.ec/">store.netlife.net.ec</a>'||chr(38)||'nbsp; </p>
 <ul>
   <li>Se incluye el servicio de diseño de la página web por parte del equipo de diseño bajo solicitud del usuario y sujeto al envío de la información relevante para su creación.'||chr(38)||'nbsp;</li>
   <li>El servicio incluye hasta 5(CINCO) páginas de contenido, formulario de contacto para recibir comunicación de los visitantes a un correo especificado, links a las redes sociales, mapa de Google interactivo, conexión con Google'||chr(38)||'nbsp;Analytics.'||chr(38)||'nbsp;</li>
   <li>El tiempo de entrega/publicación estimado'||chr(38)||'nbsp;es de 5(CINCO) días hábiles, pero está sujeto al envío oportuno de información del cliente, así como del volumen de material recibido.'||chr(38)||'nbsp;</li>
   <li>En cuanto al dominio: La propiedad del dominio está condicionada a un tiempo de permanencia mínima de 12 meses y se renueva anualmente.'||chr(38)||'nbsp;</li>
   <li>En caso de cancelarlo antes de los 12 meses de cualquiera de sus períodos de vigencia y renovación, el cliente deberá pagar el valor proporcional, de acuerdo con el tiempo de vigencia que resta por cubrir.'||chr(38)||'nbsp;</li>
   <li>Es responsabilidad del cliente tomar las medidas necesarias para almacenar la información colocada en su página web.'||chr(38)||'nbsp;</li>
   <li>El servicio incluye'||chr(38)||'nbsp;Webmail: Administración de correos, carpetas, y filtros con una interfaz intuitiva y fácil de utilizar proporcionada por'||chr(38)||'nbsp;Roundcube. Se puede agregar cualquier cuenta IMAP/POP para tener una única interfaz.'||chr(38)||'nbsp;</li>
   <li>El servicio también incluye 5 cuentas de correo: Capacidad de 1 Gb de almacenamiento por cuenta. Archivos adjuntos: hasta 25 Mb por correo enviado.'||chr(38)||'nbsp;</li>
   <li>El servicio no incluye mantenimientos programados a las plataformas que soportan al correo y mantenimientos no programados para solventar situaciones críticas.'||chr(38)||'nbsp;</li>
   <li>Netlife Constructor Web tiene un precio de $14,99(CATORCE DÓLARES DE LOS'||chr(38)||'nbsp;ESTADOS UNIDOS DE AMÉRICA CON 99/100) más IVA'||chr(38)||'nbsp;mensual, que se añade a planes de Internet de Netlife.'||chr(38)||'nbsp;</li>
   <li>El primer mes de servicio, el cliente no pagará el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</li>
   <li>Navegadores Soportados: Windows Vista, 7, y 8 | IE 9.0 en adelante | Firefox versión 19 en adelante. | Google Chrome versión 25 en adelante | Windows 10 | Edge 12 en adelante | Mac OS X 10.4, 10.5, y 10.6 | Firefox versión 19 en adelante | Safari versión 4.0 en adelante. <br>
   </li>
   <li>Se considera “spam” la práctica de enviar mensajes de correo electrónico no deseados, a menudo con contenido comercial, en grandes cantidades a los usuarios, sin darles la opción de darse de baja o excluirse de una lista de distribución.'||chr(38)||'nbsp;</li>
   <li>Por lo anterior, queda prohibido que el cliente use el correo para estos fines.'||chr(38)||'nbsp;</li>
 </ul>
 <p>
   <strong>En caso de cualquier violación a estas Políticas, se procederá a tomar una de las siguientes medidas:'||chr(38)||'nbsp;</strong>'||chr(38)||'nbsp;
 </p>
 <ol>
   <li>Suspender/Bloquear la cuenta por un lapso de 72 horas.'||chr(38)||'nbsp;</li>
   <li>Suspender/Bloquear la cuenta por un lapso de 144 horas.'||chr(38)||'nbsp;</li>
   <li>Suspender/Bloquear todo tráfico del dominio y se iniciará el proceso de baja de servicio.'||chr(38)||'nbsp;</li>
 </ol>
 <ul>
   <li>Los planes PYME (según la oferta establecida por Netlife) pueden incluir el servicio de Constructor Web, para construir tu propia página web, tener 1(UN) dominio propio y 5(CINCO) cuentas de correo asociadas a este dominio. Además de, asesoría técnica en línea las 24(VEINTI CUATRO) horas vía telefónica, chat o web. Para acceder al servicio es necesario ingresar dentro de la sección “Netlife Access” en la página web de Netlife o a store.netlife.net.ec.</li>
 </ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1263
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='KO02';
 COMMIT;
 END;