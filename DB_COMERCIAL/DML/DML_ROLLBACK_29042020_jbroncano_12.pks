    SET SERVEROUTPUT ON 

DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada,'
<p style="text-align: center;"><strong>TÉRMINOS Y CONDICIONES DE NETLIFE CLOUD</strong></p>
<p>Netlife Cloud es un servicio que incluye Microsoft 365 Familia con almacenamiento de 6.000GB dividido entre 6(SEIS) usuarios y 60(SESENTA) minutos de llamadas Skype mensuales.</p>
<ul>
	<li>Para su uso debe activar las credenciales enviadas desde el correo<a href="mailto:notificacionesnetlife@netlife.info.ec">notificacionesnetlife@netlife.info.ec</a>al correo registrado por el cliente en su contrato, e instalar los aplicativos.</li>
	<li>Para poder activar este producto y administrar las suscripciones es requisito contar con una cuenta de Microsoft (@outlook.com, @hotmail.com, @hotmail.es, @live.com). Si no tiene este tipo de cuenta de correo, puedes crear una en la dirección:<a href="https://signup.live.com/">https://signup.live.com/</a></li>
	<li>La entrega de este producto no incluye el servicio de instalacióndel mismoen ningún dispositivo. El cliente es responsable de la instalación y configuración del producto en sus dispositivos y usuarios.</li>
	<li>Los pasos para instalar y empezar a utilizar Microsoft 365 Familia se encuentran en el siguientelink:<a href="https://office.com/setup">com/setup</a>. Para administrar los dispositivos y cuentas de su licencia Microsoft 365 Familia el cliente puede acceder allink:<a href="https://office.com/myaccount">office.com/myaccount</a></li>
	<li>Netlife Cloud tiene un precio de $7,99(SIETE DÓLARES DE LOS ESTADOSUNIDOS DE AMÉRICA CON 99/100) más IVAmensual, que se añade a planes de Internet de Netlife.</li>
	<li>El primer mes de servicio, el cliente no pagará el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación (Ciclo 1: Del 1 al 30 del mes o Ciclo 2: Del 15 al 14 del mes siguiente).</li>
	<li>Netlife Cloud puede ser comercializado a personas naturales, profesionales o microempresarios sin RUC, no a PYMES.</li>
	<li>El servicio tiene una vigencia de 12(DOCE) meses e incluye renovación automática de licencia. En caso de cancelarlo antes de los 12(DOCE) meses de cualquiera de sus períodos de vigencia y renovación, el cliente deberá pagar el valor proporcional, de acuerdo con el tiempo de vigencia que resta por cubrir.</li>
	<li>El canal de soporte para consultas, dudas o requerimientos específicos del producto Microsoft 365 Familia podrá ser realizado a través del teléfono: 1-800-010-288</li>
	<li>Netlife Cloud se puede instalar enPCsy tabletas Windows que ejecuten Windows 7 o una versión posterior, y equipos Mac con Mac OS X 10.6 o una versión posterior.</li>
	<li>Microsoft 365 Familia para iPad se puede instalar en iPads que ejecuten la última versión de iOS. Microsoft 365 Mobile para iPhone se puede instalar en teléfonos que ejecuten iOS 6.0 o una versión posterior.</li>
	<li>Microsoft 365 Mobile para teléfonos Android se puede instalar en teléfonos que ejecuten OS 4.0 o una versión posterior. Para obtener más información sobre los dispositivos y requerimientos, visite:<a href="http://www.office.com/information">office.com/information</a>.</li>
</ul>
<p><strong>Requisitos de operación:</strong></p>
<ul>
	<li>El cliente es responsable de mantener una energía eléctrica regulada de 110V y de contar con dispositivos compatibles a las condiciones mínimas de operación del producto.</li>
	<li>Procesador y memoria RAM: procesador x86/x64 de 1 GHz o superior con conjunto de instrucciones SSE2 (PC), procesador Intel (Mac), Memoria: 1 GB de RAM (32 bits o Mac), 2 GB de RAM (64 bits)</li>
	<li>Disco duro: 3 GB de espacio disponible en disco (PC), 2.5 GB de HFS+ formato de disco duro (Mac), Sistema operativo (PC): Windows 7 o superior de 32 bits o 64 bits; Windows 2008 R2 o superior con .NET 3.5 o superior. El nuevo Office no se puede instalar en un PC con Windows XP o Vista. Para usar con Windows 8, se debe contar con la versiónReleasePreviewo superior, Sistema operativo (Mac): Mac OS X versión 10.5.8 o superior.</li>
	<li>Gráficos: La aceleración gráfica de hardware requiere una tarjeta gráfica DirectX 10 y resolución de 1366 x 728 (PC); 1280 x 800 de resolución de pantalla (Mac).</li>
</ul>');

UPDATE db_comercial.admi_producto
SET  termino_condicion=EMPTY_CLOB()
where id_producto=939 and empresa_cod=18;  


UPDATE db_comercial.admi_producto
SET termino_condicion= bada
where id_producto=939 and empresa_cod=18;  

COMMIT;
end;