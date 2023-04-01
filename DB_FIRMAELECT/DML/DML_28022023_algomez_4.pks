/**
 * se debe ejecutar en DB_FIRMAELECT 
 * Inserción de plantilla FORMULARIO SECURITY DATA para Ecuanet
 * @author Alex Gomez<algomez@telconet.ec>
 * @version 1.0 27/02/2023 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:='<!DOCTYPE html>';
BEGIN
DBMS_LOB.APPEND(bada, '
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
<head>
<title>FORMULARIO SECURITY DATA</title>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<style type="text/css">
          @page {
            margin-top: 1cm;
            margin-left: 0.10cm; 
            margin-right: 1cm; 
           
            size: A4 portrait; 
          }
<!--
	p {margin: 0; padding: 0;}
        .ft00{font-size:9px;font-family: "ARIAL";color:#000000;}
	.ft01{font-size:13px;font-family:"ARIAL";color:#000000;}
	.ft02{font-size:13px;font-family:"ARIAL";color:#000000;}
	.ft03{font-size:9px;font-family:"ARIAL";color:#000000;}
	.ft04{font-size:30px;font-family:"ARIAL";color:#000000;}
	.ft05{font-size:10px;line-height:15px;font-family:"Arial";color:#000000;}
    .box{ height: 16px; width: auto; border: 1px solid black; display:inline-block; border-radius: 2px; -moz-border-radius: 2px; -webkit-border-radius: 2px; vertical-align: center; text-align: left;}
-->
</style>
</head>
<body bgcolor="#A0A0A0" vlink="blue" link="blue">
<form>
<div id="page1-div" style="position:relative;width:900px;height:1000px;background-color: white">
    <img style="position:absolute;top:40px;left:40px;" width="300" height="80" src="http://images.telconet.net/others/telcos/logo_security_data.jpg" alt="background image"/>
<p style="position:absolute;top:89px;left:700px;white-space:nowrap;font-family:sans-serif !important;" class="ft00"><b>V1</b></p>
<p style="position:absolute;top:108px;left:606px;white-space:nowrap;font-family:sans-serif !important;" class="ft03">* campos obligatorios</p>
<p style="position:absolute;top:169px;left:197px;white-space:nowrap;font-family:sans-serif !important;" class="ft04"><b>FORMULARIO DE SOLICITUD</b></p>
<p style="position:absolute;top:235px;left:480px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Fecha:<span class="box" style="width:211px">$fechaActual</span></p>
<!--p style="position:absolute;top:235px;left:500px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">____________________________</p-->
<p style="position:absolute;top:255px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft02"><b>1. Datos del Suscriptor del Certificado</b></p>
<p style="position:absolute;top:274px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Nombres y Apellidos*:<span class="box" style="width:590px">$nombresApellidos</span></p>
<p style="position:absolute;top:299px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">No. Cédula / No. Pasaporte*:<span class="box" style="width:250px">$identificacion</span></p>
<p style="position:absolute;top:299px;left:480px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Nacionalidad*:<span class="box" style="width:169px">$nacionalidad</span></p>
<p style="position:absolute;top:324px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Email*:<span class="box" style="width:377px">$emailCliente</span></p>

<p style="position:absolute;top:355px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft02"><b>2. Tipo de Certificado</b></p>
<p style="position:absolute;top:375px;left:105px;white-space:nowrap;font-family:sans-serif !important;" class="ft02"><b>2.1. PERSONA NATURAL </b></p>
<p style="position:absolute;top:394px;left:105px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Ingresar los datos de la planilla o del RUC:</p>
<p style="position:absolute;top:414px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Dirección*:<span class="box" style="width:650px">$direccion</span></p>
<p style="position:absolute;top:438px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Provincia*:<span class="box" style="width:200px">$provincia</span></p>
<p style="position:absolute;top:438px;left:409px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Ciudad*:<span class="box" style="width:200px">$ciudad</span></p>
<p style="position:absolute;top:463px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Teléfono*: <span class="box" style="width:203px">$telefono</span></p>
<p style="position:absolute;top:463px;left:404px;white-space:nowrap;font-family:sans-serif !important;" class="ft01">Celular: <span class="box" style="width:202px">$celular</span></p>
<p style="position:absolute;top:502px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft02"><b>3. Tiempo de validez del certificado</b></p>
<p style="position:absolute;top:542px;left:105px;white-space:nowrap;font-family:sans-serif !important;" class="ft01"><span class="box">X</span>  a. 3 dias</p>
<p style="position:absolute;top:600px;left:19px;white-space:nowrap;font-family:sans-serif !important;" class="ft02"><b>4. Uso del Certificado</b></p>
<p style="position:absolute;top:640px;left:105px;white-space:nowrap;font-family:sans-serif !important;" class="ft01"><span class="box">X</span>  a. Firma de contrato con MEGADATOS</p>

<!--p style="position:absolute;top:690px;left:19px;font-family:sans-serif !important;" class="ft05">El solicitante declara que voluntaria y libremente acepta todos los términos y condiciones expresados en este documento, en la DPC y en la  Política de <br/>Certificación del certificado solicitado, los cuales ha revisado detalladamente y no alberga duda alguna. En prueba de conformidad firma el documento; <br/>además corrobora que la información entregada y declarada a Security Data es real; en caso de descubrirse falsedad en las declaraciones o <br/>documentaciones aqué presentadas Security Data realizará las respectivas denuncias ante la autoridad competente. </p-->
<p style="position:absolute;top:690px;left:60px;width:650px;height:1188px;text-align: justify;font-family:sans-serif !important;" class="ft05">
    El solicitante declara que voluntaria y libremente acepta todos los términos y condiciones expresados en este documento, en la DPC y en la  Política de
Certificación del certificado solicitado, los cuales ha revisado detalladamente y no alberga duda alguna. En prueba de conformidad firma el documento;
además corrobora que la información entregada y declarada a Security Data es real; en caso de descubrirse falsedad en las declaraciones o
documentaciones aqué presentadas Security Data realizará las respectivas denuncias ante la autoridad competente.
</p>
<p style="position:absolute;top:764px;left:54px;white-space:nowrap" class="ft00"><span><b>FIRMA DEL SUSCRIPTOR</b></span><input id="inputfirma1" name="FIRMA_FORM_SD_CLIENTE" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/></p>
</div>
</form>
</body>
</html>

');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'formularioSecurityData'
AND EMPRESA_ID = 
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'formularioSecurityData'
AND EMPRESA_ID = 
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET');

COMMIT;
END;
/