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
DBMS_LOB.APPEND(bada, '<p style="text-align:center"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>T'||chr(38)||'Eacute;RMINOS Y CONDICIONES DE </strong> <strong>FIBRA INVISIBLE FTTR (FIBER TO THE ROOM)'||chr(38)||'nbsp;NETFIBER</strong>'||chr(38)||'nbsp;</span></span></p>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El servicio contempla el cableado con fibra '||chr(38)||'oacute;ptica hasta un punto espec'||chr(38)||'iacute;fico dentro del hogar.'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">El precio de servicio es de $125,00(CIENTO VEINTI CINCO D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA ('||chr(38)||'uacute;nico pago), e incluye 50(CINCUENTA)'||chr(38)||'nbsp;mts'||chr(38)||'nbsp;de fibra invisible, conversor '||chr(38)||'oacute;ptico el'||chr(38)||'eacute;ctrico y'||chr(38)||'nbsp;Swtich'||chr(38)||'nbsp;de 4 puertos Gbps e instalaci'||chr(38)||'oacute;n.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Disponible para Quito y Guayaquil. El metro adicional de fibra tiene un precio de $30,00(TREINTA D'||chr(38)||'Oacute;LARES DE LOS ESTADOS UNIDOS DE AM'||chr(38)||'Eacute;RICA) m'||chr(38)||'aacute;s IVA.'||chr(38)||'nbsp;</span></span></li>
</ul>

<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>Restricciones:</strong>'||chr(38)||'nbsp;</span></span></p>

<ul>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Factibilidad geogr'||chr(38)||'aacute;fica y t'||chr(38)||'eacute;cnica.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">La velocidad ofertada depende de la capacidad y procesamiento que soporte el dispositivo final del'||chr(38)||'nbsp;cliente,'||chr(38)||'nbsp;as'||chr(38)||'iacute; como del'||chr(38)||'nbsp;routerwifi'||chr(38)||'nbsp;y la capacidad del sitio remoto de contenido.'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Se recomienda conexi'||chr(38)||'oacute;n al'||chr(38)||'aacute;mbrica de los equipos para obtener la m'||chr(38)||'aacute;xima velocidad disponible con una eficiencia del 90% (NOVENTA POR CIENTO).'||chr(38)||'nbsp;</span></span></li>
	<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">En caso de realizar la conexi'||chr(38)||'oacute;n mediante wifi a 2.4Ghz la velocidad m'||chr(38)||'aacute;xima que permite este tipo de tecnolog'||chr(38)||'iacute;a que es de 40Mbps y en la banda de 5GHz llega hasta 100Mbps a una distancia de 3(TRES) metros y sin obst'||chr(38)||'aacute;culos, en otras condiciones se tendr'||chr(38)||'aacute;n velocidades menores.'||chr(38)||'nbsp;</span></span></li>
</ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1207 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='NETFIB';
 COMMIT;
 END;