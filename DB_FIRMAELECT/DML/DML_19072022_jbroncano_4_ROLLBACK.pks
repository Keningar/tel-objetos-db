/**
 * se debe ejecutar en DB_FIRMAELECT 
 * ROLLBACK de plantilla CONTRATO SECURITY DATA
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:='<!DOCTYPE html>';
BEGIN
DBMS_LOB.APPEND(bada, '

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
<head>
<title>CONTRATO SECURITY DATA</title>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<style type="text/css">
<!--
	p {margin: 0; padding: 0;}
        .ft00{font-size:14px;font-family:"ARIAL";color:#000000;}
	.ft01{font-size:9px;font-family:"ARIAL";color:#000000;}
	.ft02{font-size:9px;font-family:"ARIAL";color:#0000ff;}
	.ft03{font-size:14px;font-family:"ARIAL";color:#7ba0cd;}
	.ft04{font-size:13px;font-family:"ARIAL";color:#000000;}
	.ft05{font-size:13px;font-family:"ARIAL";color:#000000;}
	.ft06{font-size:14px;font-family:"ARIAL";color:#000000;}
	.ft07{font-size:13px;line-height:21px;font-family:"ARIAL";color:#000000;}
	.ft08{font-size:13px;line-height:21px;font-family:"ARIAL";color:#000000;}
    .box{height: 16px; width: auto; border: 1px solid black; display:inline-block; border-radius: 2px; -moz-border-radius: 2px; -webkit-border-radius: 2px ; vertical-align: center; text-align: left;}

-->
</style>
</head>
<body bgcolor="#A0A0A0" vlink="blue" link="blue">
<div id="page1-div" style="position:relative;width:893px;height:3720px;background:white">
<img style="position:absolute;top:10px;right: 20px;white-space:nowrap" width="250" height="60" src="http://images.telconet.net/others/telcos/logo_security_data.jpg" alt="background image">

<p style="position:absolute;top:54px;left:217px;white-space:nowrap" class="ft04"><b>CONTRATO DE CERTIFICADO DE FIRMA ELECTRÓNICA. </b></p>
<p style="position:absolute;top:90px;left:54px;width:793px;height:100px;text-align: justify" class="ft04"><b>COMPARECIENTES.-</b>
Security Data Seguridad en Datos y Firma Digital S. A. como Entidad de Certificación de Información, representado por Roosevelt Arévalo por una parte; y, por otra El/la señor/a:</p>

<p style="position:absolute;top:149px;left:58px;width:793px;height:18px;border: solid 1px #000000;" class="ft06"><i><b>Persona Natural:</b></i><span class="box">$isPersonaNatural</span></p>
<p style="position:absolute;top:169px;left:58px;width:793px;height:24px;border: solid 1px #000000;" class="ft00">Nombres:<span class="box" style="width:340px;">$nombresApellidos</span>CI:<span class="box" style="width:150px;">$identificacion</span>RUC:<span class="box" style="width:150px;">$ruc</span></p>

<p style="position:absolute;top:213px;left:54px;width:793px;height:100px;text-align: justify" class="ft05">Verificado que sus datos y descripción corresponde con dicho nombre, así como, en suficiente apariencia con su imagen, por sus propios derechos, o en representación de una entidad a quien en adelante se denominarÁ El Suscriptor, conforme los documentos habilitantes legalmente conferidos que se adjuntan convienen en celebrar el presente Contrato, al tenor de las siguientes clÁusulas:</p>

    <p style="position:absolute;top:305px;left:54px;width:793px;height:275px;text-align: justify" class="ft05"><b>CLÁUSULA PRIMERA: ANTECEDENTES.- </b><br />1. Mediante Ley No. 67, publicada en el Suplemento del Registro Oficial No. 577 de 17 de abril del 2002 se expidió la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos.<br />
2. Con Decreto No. 3496 publicado en el Registro Oficial 735 de 31 de diciembre de 2002, se expidió el Reglamento General a la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos, el mismo que fue reformado mediante Decreto Ejecutivo 1356 de 29 de septiembre de 2008, constante en el Registro Oficial No. 440 de 6 de octubre de 2008.<br />
3. El artículo 37 de la Ley de Comercio Electrónico dispone, que el Consejo Nacional de Telecomunicaciones (CONATEL) es el organismo de autorización, regulación y registro de las Entidades de Certificación Acreditadas<br />
4.El segundo artículo innumerado agregado por el artículo 4 del Decreto Ejecutivo No.1356 a continuación del artículo 17 del Reglamento General a la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos, dispone que la Acreditación como Entidad de Certificación de Información y Servicios Relacionados, consistirÁ en un acto administrativo emitido por el CONATEL, a través de una resolución que serÁ inscrita en el Registro Público Nacional de Entidades de Certificación de Información y Servicios Relacionados Acreditadas y Terceros Vinculados.<br />
5 .El CONATEL mediante Resolución No. 481-20-CONATEL-2008 de 8 de octubre de 2008, aprobó la petición de Acreditación de Security Data Seguridad en Datos y Firma Digital S. A. como Entidad de Certificación de Información y Servicios Relacionados, para lo cual la Secretaría Nacional de Telecomunicaciones (SENATEL) suscribió el respectivo acto administrativo.<br />
</p>
<p style="position:absolute;top:615px;left:54px;width:793px;height:275px;text-align: justify" class="ft04"><b>CLÁUSULA SEGUNDA: OBJETO.- </b>El presente contrato tiene por objeto la prestación de los servicios de certificación de Información y servicios relacionados, contempla la emisión, suspensión, revocación y renovación de Certificados de Firma Electrónica. Así mismo tiene por objeto garantizar la prestación permanente, confidencial, oportuna y segura del servicio de certificación de información.<br /></p>

<p style="position:absolute;top:695px;left:54px;width:793px;height:275px;text-align: justify" class="ft04"><b>CLÁUSULA TERCERA: NIVELES DE FIRMA.- </b>El nivel del certificado que se emite es el de certificado de firma electrónica que servirÁ para todo propósito dentro de sus límites de uso, según se describe en la Declaración de Practicas de Certificación y en las Políticas de Certificados. En este caso el uso del certificado específicop serÁ la firma del contrato con Megadatos SA<br /></p>


<p style="position:absolute;top:781px;left:54px;width:793px;height:275px;text-align: justify" class="ft04"><b>CLÁUSULA CUARTA: CONDICIONES DEL SERVICIO.-</b><br /><b>4.1.- Listas de Certificados Revocados - CRL.-</b> EstarÁn disponibles las veinte y cuatro horas del día, durante los trescientos sesenta y cinco días del año, en el sitio web de Security Data Seguridad en Datos y Firma Digital S. A. <a href="https://www.securitydata.net.ec/crl">https://www.securitydata.net.ec/crl</a> Estas Listas serÁn actualizadas en forma permanente por la SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A..<br /></p>

<p style="position:absolute;top:891px;left:54px;white-space:nowrap" class="ft04"><b>CLÁUSULA QUINTA: TARIFAS Y FORMA DE PAGO.- </b>Los pagos se realizarÁn conforme a lo acordado con MegaDatos SA.<br /></p>

<p style="position:absolute;top:927px;left:54px;width:793px;height:275px;text-align: justify" class="ft05"><b>CLÁUSULA SEXTA: OBLIGACIONES DEL SUSCRIPTOR.- </b>Son obligaciones del Suscriptor:<br />
6.1. Cumplir en todo momento con las normas y regulaciones emitidas por SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A.;<br />
6.2. Comunicar a SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. cualquier modificación o variación de los datos que se aportaron para obtener el Certificado de Firma Electrónica;<br />
6.3. Verificar, a través de la Lista de Certificados Revocados, el estado de los Certificados de firma electrónica y la validez de las firmas electrónicas emitidas por SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A.;<br />
6.4. Proteger y conservar con el mayor de los cuidados el Dispositivo, información y/o claves que se entreguen o emitan en relación con el certificado de Firma Electrónica;<br />
6.5. Solicitar a SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. de forma personal y/o escrita, en caso de olvido de clave, una nueva clave de protección del Certificado de Firma Electrónica;<br />
6.6. Responder por el uso del Certificado de Firma Electrónica y de las consecuencias que se deriven de su utilización; y,<br />
6.7. Las demÁs contempladas en la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos y, su Reglamento.<br /></p>

<p style="position:absolute;top:1175px;left:54px;width:793px;height:275px;text-align: justify" class="ft05"><b>CLÁUSULA SÉPTIMA: OBLIGACIONES DE SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A..-</b><br />
Son obligaciones de SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A.:<br />
7.1.- Garantizar la prestación permanente, inmediata, confidencial, oportuna y segura del servicio de certificación de información bajo los dispositivos, claves y/o información relacionada con el certificado de firma electrónica;<br />
7.2.- Mantener sistemas de respaldo de la información relativa a los certificados;<br />
7.3.- Proceder de forma inmediata a la suspensión o revocatoria de certificados electrónicos previo mandato del Superintendente de Telecomunicaciones, en los casos que se especifiquen en la Ley de Comercio Electrónico, Firmas Electrónicas Mensajes de Datos;<br />
7.4.- Mantener una publicación del estado de los certificados electrónicos emitidos;<br />
7.5.- Las demÁs contempladas en la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos y, su Reglamento.<br />
</p>

<p style="position:absolute;top:1375px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA OCTAVA: RESPONSABILIDADES DE SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A..- </b>SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. serÁ responsable hasta de la culpa leve y responderÁ por los daños y perjuicios que cause a cualquier persona natural o jurídica, en el ejercicio de su actividad, cuando incumpla las obligaciones que le impone la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos o actúe con negligencia, sin perjuicio de las sanciones previstas en la Ley OrgÁnica de Defensa del Consumidor. SerÁ también responsable por el uso indebido del certificado de firma electrónica acreditado, cuando no haya consignado en dichos certificados, de forma clara, el límite de su uso y el importe de las transacciones vÁlidas que pueda realizar. No serÁ responsabilidad de SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. el eventual daño o perjuicio causado por un evento de caso fortuito o fuerza mayor en los términos establecidos en el artículo 30 de la Codificación del Código Civil.
</p>
    ');

    DBMS_LOB.APPEND(bada,'
<p style="position:absolute;top:1550px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
<b>CLÁUSULA NOVENA: GARANTÍA DE RESPONSABILIDAD.- </b>De conformidad con lo dispuesto en el apartado h) del artículo 30 de la Ley No. 67, SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. cuenta con una garantía de responsabilidad para asegurar a los usuarios el pago de los daños y perjuicios ocasionados por el incumplimiento de sus obligaciones.<br />
En caso de producirse algún evento de esta naturaleza, la SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. es responsable hasta por la culpa leve, en este evento, la indemnización serÁ de hasta el 100% de la tarifa (precio) del Certificado de Firma Electrónica emitido y pagado por el Suscriptor.<br />
El procedimiento de ejecución de la Garantía de Responsabilidad, conforme lo previsto en el Reglamento General a la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos, se efectuarÁ de la siguiente forma: Cuando el Suscriptor considere que ha existido incumplimiento en la prestación del servicio que le haya ocasionado daños y perjuicios, este podrÁ presentar a la Secretaría Nacional de Telecomunicaciones, hasta en el término de 15 días contados desde que se produjo el incumplimiento, una solicitud motivada a fin de que ésta:<br />
a) Al amparo de lo dispuesto en el artículo 31 de la Ley No. 67, ponga en conocimiento de SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. el reclamo formulado y solicite que dentro del término perentorio de 5 días, presente sus descargos o en su defecto reconozca el incumplimiento; y,<br />
b) Vencido el término señalado en el numeral anterior, la Secretaría Nacional de Telecomunicaciones con o sin la presentación de los descargos respectivos por parte de SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A., dentro del término de cinco días, resolverÁ sobre la procedencia del reclamo formulado por el Suscriptor, el que de ser estimado total o parcialmente darÁ lugar a que disponga a la compañía aseguradora la ejecución parcial de la garantía de responsabilidad civil por el monto de los daños y perjuicios causados, los que no podrÁn reconocerse por un valor superior al establecido en la presente clÁusula.<br />
</p>
<p style="position:absolute;top:1915px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMA: EXCLUSIÓN DE RESPONSABILIDAD.- </b>SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. no serÁ responsable por:<br />
1) Daños y perjuicios cuando El Suscriptor exceda los límites de uso indicados en el Certificado de Firma Electrónica y en el presente contrato;<br />
2) Ninguna obligación, texto y/o en general de todo o parte del contenido de los mensajes de datos vinculados con el certificado que se emita en base a este contrato; tampoco siendo responsable de las consecuencias que se generen por todo o parte del contenido de los señalados mensajes de datos; y,<br />
3) Las interrupciones o demoras en el servicio, ocasionadas por eventos de fuerza mayor o caso fortuito u otras circunstancias que no sean imputables a SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A.<br />
</p>

<p style="position:absolute;top:2085px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
<b>CLÁUSULA DÉCIMO PRIMERA: SUSPENSIÓN.- </b>Se suspenderÁn los Certificados de Firma Electrónica en los siguientes casos:<br />
1. Por disposición del Consejo Nacional de Telecomunicaciones, de conformidad con lo previsto en la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos;<br />
2. Si SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. comprueba falsedad en los datos consignados por El Suscriptor del certificado; o,<br />
3. Por incumplimiento de los términos y condiciones del presente contrato, en especial la que hace relación al pago de la retribución de SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A.<br />
</p>

<p style="position:absolute;top:2235px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLAUSULA DÉCIMO SEGUNDA: REVOCACIÓN.- </b>La revocación de los Certificados de Firma Electrónica se realizarÁ según los procedimientos descritos en Declaración de Practicas de Certificación y en las Políticas de Certificados.<br />
</p>

<p style="position:absolute;top:2285px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMO TERCERA: PROTECCIÓN DE INFORMACIÓN.- </b>SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. garantiza la protección de los datos personales obtenidos en función de sus actividades, de conformidad con lo establecido en el artículo 9 de la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos.<br />
</p>

<p style="position:absolute;top:2346px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMO CUARTA: TERMINACIÓN.- </b>SerÁn causales de terminación del contrato de prestación de servicios de Certificación de Información las siguientes: <br />
1) La terminación del plazo de vigencia del certificado de firma electrónica; <br />
2) La declaración unilateral de alguna de las partes contratantes con al menos 15 días de antelación, la cual deberÁ ser comunicada por escrito a la dirección informada por cada una de las partes en la ClÁusula Vigésimo Primera de este instrumento legal; <br />
3) Fallecimiento o incapacidad del Suscriptor;<br />
4) Por causa judicialmente declarada; y,<br />
5) Por revocación del Certificado de firma electrónica.<br />
</p>

<p style="position:absolute;top:2510px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMO QUINTA: VIGENCIA.- </b>El Certificado de Firma Electrónica y por ende este contrato tendrÁ una vigencia de tres días.<br />
</p>

<p style="position:absolute;top:2556px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMO SEXTA: JURISDICCIÓN.-</b> Las diferencias que se presenten entre las partes con ocasión de la interpretación o ejecución de este contrato serÁn resueltas mediante arbitraje administrado por el Centro de Mediación y Arbitraje de la CÁmara de Comercio de Guayaquil.<br />
La legislación aplicable a este contrato es, bajo el procedimiento CNUDMI (UNCITRAL).<br />
</p>

<p style="position:absolute;top:2646px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMO SEPTIMA.- AUTORIZACIÓN.-</b> El Suscriptor autoriza a SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A. a:<br />
1) Conservar y hacer uso de toda la documentación o demÁs información que se le ha entregado con la solicitud o que le entregue en el futuro, independientemente de la aceptación o rechazo de la misma. En especial la solicitud que ha presentado el Suscriptor y los documentos anexos a esta.<br />
2) Verificar toda la información entregada a través de los medios que se estime pertinentes.<br />
</p>


<p style="position:absolute;top:2786px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    <b>CLÁUSULA DÉCIMO OCTAVA.- DECLARACIÓN.-</b> El Suscriptor, por el presente instrumento, declara que recibe <b>un certificado de firma electrónica en archivo,</b> a su entera satisfacción, y se compromete a dar estricto cumplimiento a las obligaciones y recomendaciones previstas en el presente contrato y a cuidar este hardware y/o software con sumo cuidado.<br />
</p>

<p style="position:absolute;top:2906px;left:54px;width:793px;height:275px;text-align: justify" class="ft05">
    El Suscriptor declara, ademÁs, haber recibido toda la información necesaria sobre los certificados que expide SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A., su nivel de confiabilidad, los límites de responsabilidad, y las obligaciones que asume como Suscriptor del servicio de certificación de información. Así también, manifiesta que conoce y ha leído las Declaraciones de PrÁcticas de Certificación y demÁs normas emitidas por la SECURITY DATA SEGURIDAD EN DATOS Y FIRMA DIGITAL S. A., que se encuentran disponibles en la pÁgina web <a href="https://www.securitydata.net.ec">https://www.securitydata.net.ec</a> Entidad de Certificación.
</p>


<p style="position:absolute;top:3020px;left:134px;white-space:nowrap" class="ft05">(fecha de emisión):<span class="box" style="width:120px; text-align: center;">$fechaActual</span></p>
<!--p style="position:absolute;top:3186px;left:134px;white-space:nowrap" class="ft05">------------------------------------------&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;----------------------------------&#160;&#160;&#160;&#160;</p-->

<p style="position:absolute;top:3303px;left:134px;white-space:nowrap" class="ft04"><span><b>SECURITY DATA SEGURIDAD EN</b></span><input id="inputfirma1" name="FIRMA_CONT_SD_EMPRESA" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/></p>
<p style="position:absolute;top:3318px;left:134px;white-space:nowrap" class="ft04"><b>DATOS Y FIRMA DIGITAL S. A.</b></p>
<p style="position:absolute;top:3303px;left:512px;white-space:nowrap" class="ft04"><span><b>EL SUSCRIPTOR</b></span><input id="inputfirma2" name="FIRMA_CONT_SD_CLIENTE" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/></p>

<p style="position:absolute;top:3460px;left:340px;text-align: center" class="ft04"><a href="http://www.securitydata.net.ec/">www.securitydata.net.ec</a><br />
    Quito-Ecuador</p>
<img style="position:absolute;top:3500px;left:200px" width="400" height="150" src="http://images.telconet.net/others/telcos/footer_security_data.png" alt="background image">
</div>
</body>
</html>
');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'contratoSecurityData';

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'contratoSecurityData';

COMMIT;
END;
/