SET SERVEROUTPUT ON 

DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada,'
<p style="text-align: center;"><strong>TÉRMINOS Y CONDICIONES DE EXTENSOR WIFI DUAL BAND</strong></p>
<ul>
	<li>El equipo Extender Dual Band se encuentran disponible solo en ciudades con tecnología Huawei </li>
	<li>Los planes que deseen contratar un Extender Dual Band, pueden acceder a él pagando $4,50(CUATRO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA CON 50/100) más impuestos mensuales. No hay costo de visita técnica. Se pueden incluir hasta 3 (TRES) Extenders por servicio. Aplica para ciudades con tecnología Huawei. </li>
	<li>El primer mes de servicio, el cliente no pagará el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación (Ciclo 1: Del 1 al 30 del mes o Ciclo 2: Del 15 al 14 del mes siguiente). </li>
	<li>Los equipos son propiedad de MEGADATOS S.A. y cuenta con una garantía de 1(UN) año por defectos de fábrica. Al finalizar la prestación del servicio el cliente deberá entregarlos en las oficinas de MEGADATOS. En caso de que el cliente no lo devolviere, se detecte mal uso o daños, el costo total del equipo por reposición será facturado al cliente: 80,00(OCHENTA DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) (más IVA) para el equipo WIFI Dual Band Standard, USD$ 175 (CIENTO SETENTA Y CINCO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) (más IVA) para el ONT+WiFi Dual Band Premium y USD$ 75 (SETENTA Y CINCO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) (más IVA) para el equipo AP Extender WiFi Dual Band. </li>
	<li>El cliente conoce y acepta que, para garantizar la calidad del servicio, estos equipos serán administrado por NETLIFE mientras dure la prestación del servicio. </li>
	<li>El equipo WiFi provisto por NETIFE tiene puertos alámbricos que permiten la utilización óptima de la velocidad ofertada en el plan contratado, además cuenta con conexión WiFi a una frecuencia de 5Ghz que permite usna velocidad máxima de 150Mbps a una distancia de 3 metros y pueden conectarse equipos a una distancia de hasta 12 metros en condiciones normales, sin embargo, la distancia de cobertura varía según la cantidad y tipo de paredes, obstáculos e interferencia que se encuentren en el entorno. El cliente conoce y acepta que la tecnología WiFi pierde potencia a mayor distancia y por lo tanto se reducirá la velocidad efectiva a una mayor distancia de conexión del equipo. </li>
</ul>
<p style="text-align: center;"><strong>Promoción</strong></p>
<ul>
	<li>50% (CINCUENTA POR CIENTO) de descuento en la 1 primera factura del servicio del 1 al 31 de diciembre del 2021, aplica solo para clientes que agreguen este servicio como adicional a su plan de internet dentro de la fecha estipulada. </li>
	<li>Precio después de finalizar la promoción: $5.04 (CINCO DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA CON 04/100) mensual incluido impuestos.  </li>
</ul>');

UPDATE db_comercial.admi_producto
SET  termino_condicion=EMPTY_CLOB()
where id_producto=1232 and empresa_cod=18;  


UPDATE db_comercial.admi_producto
SET termino_condicion= bada
where id_producto=1232 and empresa_cod=18;  

COMMIT;
end;