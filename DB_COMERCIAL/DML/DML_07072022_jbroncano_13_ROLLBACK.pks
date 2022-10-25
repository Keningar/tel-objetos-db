/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Rollback de Terminos y Condiciones
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 07-07-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><strong><span style="font-size:18,0000pt"><span style="font-family:Calibri"><span style="color:#000000"><strong>CONDICIONES DE USO PRODUCTO NETLIFE CLOUD</strong></span></span></span></strong>'||chr(38)||'nbsp;</p>

<p> '||chr(38)||'nbsp;</p>

<p><span style="font-family:Calibri">Netlife Cloud es un servicio que incluye Microsoft 365 Familia con almacenamiento de 6.000GB dividido entre 6(SEIS) usuarios y 60(SESENTA) minutos de llamadas Skype mensuales.</span>'||chr(38)||'nbsp;</p>

<ul>
	<li><span style="font-family:Calibri">Para su uso debe activar las credenciales enviadas desde el correo </span><a href="mailto:notificacionesnetlife@netlife.info.ec"><u><span style="font-family:Calibri"><span style="color:#0000ff"><u>notificacionesnetlife@netlife.info.ec</u></span></span></u></a><span style="font-family:Calibri">'||chr(38)||'nbsp;al correo registrado por el cliente en su contrato, e instalar los aplicativos.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Para poder activar este producto y administrar las suscripciones es requisito contar con una cuenta de Microsoft (@outlook.com, @hotmail.com, @hotmail.es, @live.com). Si no tiene este tipo de cuenta de correo, puedes crear una en la direcci'||chr(38)||'oacute;n: </span><a href="https://signup.live.com/"><u><span style="font-family:Calibri"><span style="color:#0000ff"><u>https://signup.live.com/</u></span></span></u></a>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">La entrega de este producto no incluye el servicio de instalaci'||chr(38)||'oacute;n del mismo en ning'||chr(38)||'uacute;n dispositivo. El cliente es responsable de la instalaci'||chr(38)||'oacute;n y configuraci'||chr(38)||'oacute;n del producto en sus dispositivos y usuarios.</span>'||chr(38)||'nbsp;</li>
</ul>

<ul>
	<li><span style="font-family:Calibri">Los pasos para instalar y empezar a utilizar Microsoft 365 Familia se encuentran en el siguiente link: </span><a href="https://office.com/setup"><u><span style="font-family:Calibri"><span style="color:#0000ff"><u>office.com/setup</u></span></span></u></a><span style="font-family:Calibri">. Para administrar los dispositivos y cuentas de su licencia Microsoft 365 Familia el cliente puede acceder al link: </span><a href="https://office.com/myaccount"><u><span style="font-family:Calibri"><span style="color:#0000ff"><u>office.com/myaccount</u></span></span></u></a>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Netlife Cloud tiene un precio de $7,99(SIETE D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 99/100) m'||chr(38)||'aacute;s IVA mensual, que se a'||chr(38)||'ntilde;ade a planes de Internet de Netlife.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Netlife Cloud puede ser comercializado a personas naturales, profesionales o microempresarios sin RUC, no a PYMES.</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="font-family:Calibri">El servicio tiene una vigencia de 12(DOCE) meses e incluye renovaci'||chr(38)||'oacute;n autom'||chr(38)||'aacute;tica de licencia. En caso de cancelarlo antes de los 12(DOCE) meses de cualquiera de sus per'||chr(38)||'iacute;odos de vigencia y renovaci'||chr(38)||'oacute;n, el cliente deber'||chr(38)||'aacute; pagar el valor proporcional, de acuerdo con el tiempo de vigencia que resta por cubrir adem'||chr(38)||'aacute;s del pago de los descuentos a los que haya accedido el cliente por promociones.</span>'||chr(38)||'nbsp;</li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">El canal de soporte para consultas, dudas o requerimientos espec'||chr(38)||'iacute;ficos del producto Microsoft 365 Familia podr'||chr(38)||'aacute; ser realizado a trav'||chr(38)||'eacute;s del tel'||chr(38)||'eacute;fono: 1-800-010-288</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Netlife Cloud se puede instalar en PCs y tabletas Windows que ejecuten Windows 7 o una versi'||chr(38)||'oacute;n posterior, y equipos Mac con Mac OS X 10.6 o una versi'||chr(38)||'oacute;n posterior.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Microsoft 365 Familia para iPad se puede instalar en iPads que ejecuten la '||chr(38)||'uacute;ltima versi'||chr(38)||'oacute;n de iOS. Microsoft 365 Mobile para iPhone se puede instalar en tel'||chr(38)||'eacute;fonos que ejecuten iOS 6.0 o una versi'||chr(38)||'oacute;n posterior.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Microsoft 365 Mobile para tel'||chr(38)||'eacute;fonos Android se puede instalar en tel'||chr(38)||'eacute;fonos que ejecuten OS 4.0 o una versi'||chr(38)||'oacute;n posterior. Para obtener m'||chr(38)||'aacute;s informaci'||chr(38)||'oacute;n sobre los dispositivos y requerimientos, visite: </span><a href="http://www.office.com/information"><u><span style="font-family:Calibri"><span style="color:#0000ff"><u>www.office.com/information</u></span></span></u></a><span style="font-family:Calibri">.</span>'||chr(38)||'nbsp;</li>
</ul>

<p><strong><span style="font-size:13,5000pt"><span style="font-family:Calibri"><span style="color:#000000"><strong>Requisitos de operaci'||chr(38)||'oacute;n:</strong></span></span></span></strong>'||chr(38)||'nbsp;</p>

<ul>
	<li><span style="font-family:Calibri">El cliente es responsable de mantener una energ'||chr(38)||'iacute;a el'||chr(38)||'eacute;ctrica regulada de 110V y de contar con dispositivos compatibles a las condiciones m'||chr(38)||'iacute;nimas de operaci'||chr(38)||'oacute;n del producto.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Procesador y memoria RAM: procesador x86/x64 de 1 GHz o superior con conjunto de instrucciones SSE2 (PC), procesador Intel (Mac), Memoria: 1 GB de RAM (32 bits o Mac), 2 GB de RAM (64 bits)</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Disco duro: 3 GB de espacio disponible en disco (PC), 2.5 GB de HFS+ formato de disco duro (Mac), Sistema operativo (PC): Windows 7 o superior de 32 bits o 64 bits; Windows 2008 R2 o superior con .NET 3.5 o superior. El nuevo Office no se puede instalar en un PC con Windows XP o Vista. Para usar con Windows 8, se debe contar con la versi'||chr(38)||'oacute;n Release Preview o superior, Sistema operativo (Mac): Mac OS X versi'||chr(38)||'oacute;n 10.5.8 o superior.</span>'||chr(38)||'nbsp;</li>
	<li><span style="font-family:Calibri">Gr'||chr(38)||'aacute;ficos: La aceleraci'||chr(38)||'oacute;n gr'||chr(38)||'aacute;fica de hardware requiere una tarjeta gr'||chr(38)||'aacute;fica DirectX 10 y resoluci'||chr(38)||'oacute;n de 1366 x 728 (PC); 1280 x 800 de resoluci'||chr(38)||'oacute;n de pantalla (Mac).</span>'||chr(38)||'nbsp;</li>
</ul>

<p>'||chr(38)||'nbsp;</p>

<p style="text-align:justify"><strong><span style="font-size:13,5000pt"><span style="font-family:Calibri"><span style="color:#000000"><strong>Promoci'||chr(38)||'oacute;n</strong></span></span></span></strong>'||chr(38)||'nbsp;</p>

<p style="text-align:justify">'||chr(38)||'nbsp;</p>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">30% (TREINTA POR CIENTO) de descuento en las (3) tres primeras facturas del servicio </span><span style="background-color:#00ffff"><span style="font-family:Calibri">del 1 al 31 de octubre de 2022</span></span><span style="font-family:Calibri">, aplica para clientes nuevos y actuales que agreguen este servicio como adicional a su plan de internet dentro de la fecha estipulada.</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="font-family:Calibri">Precio despu'||chr(38)||'eacute;s de finalizar la promoci'||chr(38)||'oacute;n: $8,95 (OCHO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 95/100), mensual incluido impuestos, con un tiempo de permanencia m'||chr(38)||'iacute;nima de 12 meses y renovaci'||chr(38)||'oacute;n autom'||chr(38)||'aacute;tica de licencia</span>'||chr(38)||'nbsp;</li>
</ul>
');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=939
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='1612';
 COMMIT;
 END;