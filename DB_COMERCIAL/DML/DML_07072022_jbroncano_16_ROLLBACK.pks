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
DBMS_LOB.APPEND(bada, '<p style="margin-top: 0.49cm; margin-bottom: 0.49cm; line-height: 100%;" align="center">
  <font face="Times New Roman, serif">
    <font style="font-size: 18pt;" size="5">
      <b>PUNTO CABLEADO ETHERNET</b>
    </font>
  </font>
</p>
<p style="margin-bottom: 0.28cm; line-height: 108%;" align="justify">
  <br />
  <br />
</p>
<ul>
  <li>
    <p style="margin-bottom: 0.28cm; line-height: 100%;" align="justify">
      <font face="Times New Roman, serif">
        <font style="font-size: 12pt;" size="3"> Punto Cableado Ethernet es un producto que contempla la instalación o acondicionamiento de un (1) punto cableado a un (1) dispositivo del cliente, para acceso a internet directo por cable. El producto tiene un metraje máximo de 30mts e incluye para su acondicionamiento 2 conectores y 10 metros de canaleta. </font>
      </font>
    </p>
  </li>
  <li>
    <p style="margin-bottom: 0.28cm; line-height: 100%;" align="justify">
      <font face="Times New Roman, serif">
        <font style="font-size: 12pt;" size="3"> Por la contratación del producto el cliente realiza un pago único de $35,00+iva, que se incluirá en su factura. Este producto no tiene un tiempo mínimo de permanencia y no es sujeto de traslado. </font>
      </font>
    </p>
  </li>
  <li>
    <p style="margin-bottom: 0.28cm; line-height: 100%;" align="justify">
      <font face="Times New Roman, serif">
        <font style="font-size: 12pt;" size="3">La contratación del servicio está limitada a 3 puntos cableados por punto del cliente.</font>
      </font>
    </p>
  </li>
  <li>
    <p style="margin-bottom: 0.28cm; line-height: 100%;" align="justify">
      <font face="Times New Roman, serif">
        <font style="font-size: 12pt;" size="3"> En caso de que el cliente requiera que se le retire el punto cableado, se le cobrará el valor de la visita técnica programada cuyo valor se puede encontrar en la sección de atención al cliente de: <a href="https://www.netlife.ec/">https://www.netlife.ec</a>
        </font>
      </font>
    </p>
  </li>
  <li>
    <p style="margin-bottom: 0.28cm; line-height: 100%;" align="justify">
      <font face="Times New Roman, serif">
        <font style="font-size: 12pt;" size="3">En los casos de soporte imputables al cliente se cobrará el costo de los materiales utilizados y la visita técnica programada.</font>
      </font>
    </p>
  </li>
</ul>
<style type="text/css">
  p {
    margin-bottom: 0.25cm;
    direction: ltr;
    line-height: 115%;
    text-align: left;
    orphans: 2;
    widows: 2;
    background: transparent;
  }

  a:link {
    color: #0000ff;
    text-decoration: underline;
  }
</style>

');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1332
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='CABL';
 COMMIT;
 END;