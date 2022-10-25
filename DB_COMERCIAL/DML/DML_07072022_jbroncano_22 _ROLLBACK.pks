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
DBMS_LOB.APPEND(bada, '   <p style="text-align: center;">
    <strong>TÉRMINOS Y CONDICIONES DE NETLIFE </strong>
    <strong>ASSISTANCE</strong>
  </p>
  <p>Netlife'||chr(38)||'nbsp;Assistance'||chr(38)||'nbsp;es un servicio que brinda soluciones remotas ilimitadas de asistencia técnica para equipos terminales del cliente, entre los cuales están:'||chr(38)||'nbsp;</p>
  <ul>
    <li>Asistencia guiada de configuración e instalación de software o hardware.'||chr(38)||'nbsp;</li>
    <li>Revisión, análisis y mantenimiento del PC/MAC.'||chr(38)||'nbsp;</li>
    <li>Asesoría técnica en línea las 24 horas del PC/MAC.'||chr(38)||'nbsp;</li>
    <li>Técnico PC y dispositivos remoto ilimitado.'||chr(38)||'nbsp;</li>
    <li>Incluye hasta 3 visitas presenciales al año.'||chr(38)||'nbsp;</li>
    <li>Para acceder al servicio y recibir asistencia y soporte de un técnico especialista es necesario contactarse por vía telefónica al 39 20000.'||chr(38)||'nbsp;</li>
  </ul>
  <p>
    <strong>Modalidad mensualizada</strong>'||chr(38)||'nbsp;
  </p>
  <ul>
    <li>Netlife'||chr(38)||'nbsp;Assistance'||chr(38)||'nbsp;como servicio adicional mensualizado tiene un precio promocional de $1,99(UN DÓLAR DE LOS ESTADOS UNIDOS DE AMÉRICA CON 99/100) más IVA'||chr(38)||'nbsp;mensual, que se añade'||chr(38)||'nbsp;a planes de Internet HOME de Netlife.'||chr(38)||'nbsp;</li>
    <li>El servicio tiene un tiempo de permanencia mínima de 12(DOCE) meses. En caso de que un cliente no permanezca los 12(DOCE) meses, entonces se le cobrará el valor de las promociones. Valor normal del servicio: $8.75(OCHO DÓLARES DE LOS'||chr(38)||'nbsp;ESTADOS UNIDOS DE AMÉRICA CON 75/100)+iva'||chr(38)||'nbsp;mensual.'||chr(38)||'nbsp;</li>
    <li>El primer mes de servicio, el cliente no pagará el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación (Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</li>
    <li>El servicio no incluye materiales, sin embargo, si el cliente los requiere se cobrarán por separado. Tampoco incluye reparación de equipos o dispositivos.'||chr(38)||'nbsp;</li>
    <li>El servicio aplica para planes HOME en las ciudades de Quito y Guayaquil. Servicio no disponible para planes PYME.'||chr(38)||'nbsp;</li>
  </ul>
  <p>
    <strong>Modalidad bajo demanda</strong>'||chr(38)||'nbsp;
  </p>
  <ul>
    <li>Precio del servicio: $30,00 (TREINTA DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA CON) más IVA la visita en ciudad y $35(TREINTA Y CINCO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA en zonas foráneas.'||chr(38)||'nbsp;</li>
    <li>Duración de la visita 1(UNA) hora.'||chr(38)||'nbsp;</li>
    <li>Adicional a la primera hora de atención se cobrará 10,00(DIEZ DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA. Los costos no incluyen materiales.'||chr(38)||'nbsp;</li>
    <li>El servicio aplica para planes HOME en las ciudades de Quito y Guayaquil.'||chr(38)||'nbsp;</li>
    <li>Visitas presenciales para clientes de NETLIFE exclusivas para reparación y/o revisión de problemas en redes internas ya establecidas.'||chr(38)||'nbsp;</li>
  </ul>
  <p>
    <strong>Dichas visitas no incluyen trabajos como:</strong>'||chr(38)||'nbsp;
  </p>
  <ul>
    <li>Trabajos eléctricos o trabajos en alturas externos'||chr(38)||'nbsp;</li>
    <li>No pasar guías sobre'||chr(38)||'nbsp;ductería, ni cables por ductos sin guía'||chr(38)||'nbsp;</li>
    <li>Obras civiles'||chr(38)||'nbsp;</li>
    <li>Instalación de Software no licenciado'||chr(38)||'nbsp;</li>
    <li>No formatear PC'||chr(38)||'nbsp;</li>
  </ul>
  <p>
    <strong>Ni Materiales Adicionales como:</strong>'||chr(38)||'nbsp;
  </p>
  <ul>
    <li>Canaletas Plásticas Adhesivas'||chr(38)||'nbsp;</li>
    <li>Cable UTP 5e'||chr(38)||'nbsp;</li>
    <li>Jack RJ45'||chr(38)||'nbsp;</li>
  </ul>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1130 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='ASSI';
 COMMIT;
 END;