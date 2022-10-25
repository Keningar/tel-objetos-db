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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>T'||chr(38)||'Eacute;RMINOS Y CONDICIONES DE NETLIFE </strong><strong>ASSISTANCE</strong></span></span></p>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Netlife'||chr(38)||'nbsp;Assistance'||chr(38)||'nbsp;es un servicio que brinda soluciones remotas ilimitadas de asistencia t'||chr(38)||'eacute;cnica para equipos terminales del cliente, entre los cuales est'||chr(38)||'aacute;n:'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Asistencia guiada de configuraci'||chr(38)||'oacute;n e instalaci'||chr(38)||'oacute;n de software o hardware.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Revisi'||chr(38)||'oacute;n, an'||chr(38)||'aacute;lisis y mantenimiento del PC/MAC.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Asesor'||chr(38)||'iacute;a t'||chr(38)||'eacute;cnica en l'||chr(38)||'iacute;nea las 24 horas del PC/MAC.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">T'||chr(38)||'eacute;cnico PC y dispositivos remoto ilimitado.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Incluye hasta 3 visitas presenciales al a'||chr(38)||'ntilde;o.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Para acceder al servicio y recibir asistencia y soporte de un t'||chr(38)||'eacute;cnico especialista es necesario contactarse por v'||chr(38)||'iacute;a telef'||chr(38)||'oacute;nica al 39 20000.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>Modalidad mensualizada</strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Netlife'||chr(38)||'nbsp;Assistance'||chr(38)||'nbsp;como servicio adicional mensualizado tiene un precio promocional de $1,99(UN D'||chr(38)||'Oacute;LAR DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 99/100) m'||chr(38)||'aacute;s IVA'||chr(38)||'nbsp;mensual, que se a'||chr(38)||'ntilde;ade'||chr(38)||'nbsp;a planes de Internet HOME de Netlife.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio tiene un tiempo de permanencia m'||chr(38)||'iacute;nima de 12(DOCE) meses. En caso de que un cliente no permanezca los 12(DOCE) meses, entonces se le cobrar'||chr(38)||'aacute; el valor de las promociones. Valor normal del servicio: $8.75(OCHO D'||chr(38)||'Oacute;LARES DE LOS'||chr(38)||'nbsp;ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 75/100)+iva'||chr(38)||'nbsp;mensual.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio no incluye materiales, sin embargo, si el cliente los requiere se cobrar'||chr(38)||'aacute;n por separado. Tampoco incluye reparaci'||chr(38)||'oacute;n de equipos o dispositivos.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio aplica para planes HOME en las ciudades de Quito y Guayaquil. Servicio no disponible para planes PYME.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>Modalidad bajo demanda</strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Precio del servicio: $30,00 (TREINTA D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON) m'||chr(38)||'aacute;s IVA la visita en ciudad y $35(TREINTA Y CINCO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA en zonas for'||chr(38)||'aacute;neas.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Duraci'||chr(38)||'oacute;n de la visita 1(UNA) hora.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Adicional a la primera hora de atenci'||chr(38)||'oacute;n se cobrar'||chr(38)||'aacute; 10,00(DIEZ D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA. Los costos no incluyen materiales.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio aplica para planes HOME en las ciudades de Quito y Guayaquil.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Visitas presenciales para clientes de NETLIFE exclusivas para reparaci'||chr(38)||'oacute;n y/o revisi'||chr(38)||'oacute;n de problemas en redes internas ya establecidas.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>Dichas visitas no incluyen trabajos como:</strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Trabajos el'||chr(38)||'eacute;ctricos o trabajos en alturas externos'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">No pasar gu'||chr(38)||'iacute;as sobre'||chr(38)||'nbsp;ducter'||chr(38)||'iacute;a, ni cables por ductos sin gu'||chr(38)||'iacute;a'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Obras civiles'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Instalaci'||chr(38)||'oacute;n de Software no licenciado'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">No formatear PC'||chr(38)||'nbsp;</span></span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>Ni Materiales Adicionales como:</strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Canaletas Pl'||chr(38)||'aacute;sticas Adhesivas'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Cable UTP 5e'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Jack RJ45'||chr(38)||'nbsp;</span></span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1130 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='ASSI';
 COMMIT;
 END;