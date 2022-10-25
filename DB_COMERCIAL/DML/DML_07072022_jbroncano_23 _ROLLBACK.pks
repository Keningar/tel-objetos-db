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
DBMS_LOB.APPEND(bada, '  <p style="text-align: center;">
   <strong>TÉRMINOS Y CONDICIONES DE </strong>
   <strong>FIBRA INVISIBLE FTTR (FIBER TO THE ROOM)'||chr(38)||'nbsp;NETFIBER</strong>'||chr(38)||'nbsp;
 </p>
 <p>El servicio contempla el cableado con fibra óptica hasta un punto específico dentro del hogar.'||chr(38)||'nbsp;</p>
 <ul>
   <li>El precio de servicio es de $125,00(CIENTO VEINTI CINCO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA (único pago), e incluye 50(CINCUENTA)'||chr(38)||'nbsp;mts'||chr(38)||'nbsp;de fibra invisible, conversor óptico eléctrico y'||chr(38)||'nbsp;Swtich'||chr(38)||'nbsp;de 4 puertos Gbps e instalación.'||chr(38)||'nbsp;</li>
   <li>Disponible para Quito y Guayaquil. El metro adicional de fibra tiene un precio de $30,00(TREINTA DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA.'||chr(38)||'nbsp;</li>
 </ul>
 <p>
   <strong>Restricciones:</strong>'||chr(38)||'nbsp;
 </p>
 <ul>
   <li>Factibilidad geográfica y técnica.'||chr(38)||'nbsp;</li>
   <li>La velocidad ofertada depende de la capacidad y procesamiento que soporte el dispositivo final del'||chr(38)||'nbsp;cliente,'||chr(38)||'nbsp;así como del'||chr(38)||'nbsp;routerwifi'||chr(38)||'nbsp;y la capacidad del sitio remoto de contenido.'||chr(38)||'nbsp;</li>
   <li>Se recomienda conexión alámbrica de los equipos para obtener la máxima velocidad disponible con una eficiencia del 90% (NOVENTA POR CIENTO).'||chr(38)||'nbsp;</li>
   <li>En caso de realizar la conexión mediante wifi a 2.4Ghz la velocidad máxima que permite este tipo de tecnología que es de 40Mbps y en la banda de 5GHz llega hasta 100Mbps a una distancia de 3(TRES) metros y sin obstáculos, en otras condiciones se tendrán velocidades menores.'||chr(38)||'nbsp;</li>
 </ul>
');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1207 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='NETFIB';
 COMMIT;
 END;