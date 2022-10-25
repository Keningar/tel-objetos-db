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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><strong><span style="font-size:18,0000pt"><span style="font-family:Calibri"><span style="color:#000000"><strong>EXTENSOR WIFI DUAL BAND</strong></span></span></span></strong>'||chr(38)||'nbsp;</p>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">El equipo Extender Dual Band se encuentran disponible solo en ciudades con tecnolog'||chr(38)||'iacute;a Huawei o ZTE.</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="font-family:Calibri">Los planes que deseen contratar un Extender Dual Band, pueden acceder a '||chr(38)||'eacute;l pagando $4,50(CUATRO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 50/100) m'||chr(38)||'aacute;s impuestos mensuales. No hay costo de visita t'||chr(38)||'eacute;cnica. Se pueden incluir hasta 3 (TRES) Extenders por servicio.'||chr(38)||'nbsp;</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="font-family:Calibri">El primer mes de servicio, el cliente no pagar'||chr(38)||'aacute; el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturaci'||chr(38)||'oacute;n (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="font-family:Calibri">Los equipos son propiedad de MEGADATOS S.A. y cuenta con una garant'||chr(38)||'iacute;a de 1(UN) a'||chr(38)||'ntilde;o por defectos de f'||chr(38)||'aacute;brica. Al finalizar la prestaci'||chr(38)||'oacute;n del servicio el cliente deber'||chr(38)||'aacute; entregarlos en las oficinas de MEGADATOS. En caso de que el cliente no lo devolviere, se detecte mal uso o da'||chr(38)||'ntilde;os, el costo total del equipo por reposici'||chr(38)||'oacute;n ser'||chr(38)||'aacute; facturado al cliente: 80,00(OCHENTA D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) (m'||chr(38)||'aacute;s IVA) para el equipo WIFI Dual Band Standard, USD$ 175 (CIENTO SETENTA Y CINCO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) (m'||chr(38)||'aacute;s IVA) para el ONT+WiFi Dual Band Premium y USD$ 75 (SETENTA Y CINCO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) (m'||chr(38)||'aacute;s IVA) para el equipo AP Extender WiFi Dual Band.</span>'||chr(38)||'nbsp;</li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">El cliente conoce y acepta que, para garantizar la calidad del servicio, estos equipos ser'||chr(38)||'aacute;n administrado por NETLIFE mientras dure la prestaci'||chr(38)||'oacute;n del servicio.</span>'||chr(38)||'nbsp;</li>
	<li style="text-align:justify"><span style="font-family:Calibri">El equipo WiFi provisto por NETIFE tiene puertos al'||chr(38)||'aacute;mbricos que permiten la utilizaci'||chr(38)||'oacute;n '||chr(38)||'oacute;ptima de la velocidad ofertada en el plan contratado, adem'||chr(38)||'aacute;s cuenta con conexi'||chr(38)||'oacute;n WiFi a una frecuencia de 5Ghz que permite una velocidad m'||chr(38)||'aacute;xima de 150Mbps a una distancia de 3 metros y pueden conectarse equipos a una distancia de hasta 12 metros en condiciones normales, sin embargo, la distancia de cobertura var'||chr(38)||'iacute;a seg'||chr(38)||'uacute;n la cantidad y tipo de paredes, obst'||chr(38)||'aacute;culos e interferencia que se encuentren en el entorno. El cliente conoce y acepta que la tecnolog'||chr(38)||'iacute;a WiFi pierde potencia a mayor distancia y por lo tanto se reducir'||chr(38)||'aacute; la velocidad efectiva a una mayor distancia de conexi'||chr(38)||'oacute;n del equipo.</span>'||chr(38)||'nbsp;</li>
</ul>

<p style="text-align:justify">'||chr(38)||'nbsp;</p>

<p style="text-align:justify"><strong><span style="font-size:13,5000pt"><span style="font-family:Calibri"><span style="color:#000000"><strong>Promoci'||chr(38)||'oacute;n</strong></span></span></span></strong>'||chr(38)||'nbsp;</p>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">50% (CINCUENTA POR CIENTO) de descuento en las (5) cinco primeras facturas del servicio del </span><span style="background-color:#00ffff"><span style="font-family:Calibri">del 1 al 31 de octubre de 2022</span></span><span style="font-family:Calibri">, aplica solo para clientes actuales que agreguen este servicio como adicional a su plan de internet dentro de la fecha estipulada.</span>'||chr(38)||'nbsp;</li>
</ul>

<ul>
	<li style="text-align:justify"><span style="font-family:Calibri">Precio despu'||chr(38)||'eacute;s de finalizar la promoci'||chr(38)||'oacute;n: $5.04 (CINCO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA CON 04/100) mensual incluido impuestos.</span></li>
</ul>

<p>'||chr(38)||'nbsp;</p>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1232
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='EXDB';
 COMMIT;
 END;