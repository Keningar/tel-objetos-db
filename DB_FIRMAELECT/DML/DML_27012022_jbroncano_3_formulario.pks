/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de plantilla Autorización para Débito
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:='<!DOCTYPE html>';
BEGIN
DBMS_LOB.APPEND(bada, ' 
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
  <head>
    <title>FORMULARIO SECURITY DATA</title>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      @page {
        margin-top: 1cm;
        margin-left: 0.5cm;
        margin-right: 0.5cm;
        size: A4 portrait;
      }
      *{
                 font-family: "Helvetica";
       }
      * {
        box-sizing: border-box;
      }
      body {
        font-family: ''ARIAL'', sans-serif;
      }
      p {
        margin: 0.3rem;
        padding: 0;
      }
      .ft00 {
        font-size: 9px;
        font-family: ''ARIAL'', sans-serif;
        color: #000000;
      }
      .ft01 {
        font-size: 13px;
        font-family: ''ARIAL'', sans-serif;
        color: #000000;
      }
      .ft02 {
        font-size: 13px;
        font-family: ''ARIAL'', sans-serif;
        color: #000000;
      }
      .ft03 {
        font-size: 9px;
        font-family: ''ARIAL'', sans-serif;
        color: #000000;
      }
      .ft04 {
        font-size: 30px;
        font-family: ''ARIAL'', sans-serif;
        color: #000000;
      }
      .ft05 {
        font-size: 10px;
        line-height: 15px;
        font-family: ''Arial'', sans-serif;
        color: #000000;
      }
      .box {
        height: 16px;
        border: 1px solid black;
        border-radius: 2px;
        -moz-border-radius: 2px;
        -webkit-border-radius: 2px;
        vertical-align: center;
        text-align: left;
        padding: 0 0.4rem;
      }
      .m-05 {
        margin: 0.5rem;
      }
      .m-1 {
        margin: 1rem;
      }
      .m-3 {
        margin: 3rem;
      }
      .m-4 {
        margin: 4rem;
      }
      .d-flex {
        display: flex;
      }
      .mt-05 {
        margin-top: 0.5rem;
      }
      .mt-1 {
        margin-top: 1rem;
      }
      .mt-2 {
        margin-top: 2rem;
      }
      .mt-3 {
        margin-top: 3rem;
      }
      .mt-4 {
        margin-top: 4rem;
      }
      .ml-2 {
        margin-left: 2rem;
      }
      .ml-3 {
        margin-left: 3rem;
      }
      .ml-4 {
        margin-left: 4rem;
      }
      .space-between {
        justify-content: space-between;
      }
      .space-around {
        justify-content: space-around;
      }
      .flex-end {
        justify-content: flex-end;
      }
      .text-bold {
        font-weight: bold;
        font-family: "Helvetica";
      }
      .text-right {
        text-align: right;
      }
      .text-center {
        text-align: center;
      }
      .text-justify {
        text-align: justify;
      }
         .w-3{
        width: 3%;
      }
     .w-4{
        width: 4%;
      }
      .w-5{
        width: 5%;
      }
        .w-7{
        width: 7%;
      }
          .w-10 {
        width: 10%;
      }
     .w-12 {
        width: 12%;
      }
     .w-13 {
        width: 13%;
      }
        .w-14 {
        width: 14%;
      }
      .w-125 {
        width: 12.5%;
      }
      .w-15 {
        width: 15%;
      }
      .w-20 {
        width: 20%;
      }
      .w-25 {
        width: 25%;
      }
      .w-30 {
        width: 30%;
      }
      .w-40 {
        width: 40%;
      }
      .w-50 {
        width: 50%;
      }
           .w-55 {
        width: 55%;
      }
      .w-70 {
        width: 70%;
      }
    .w-60 {
        width: 60%;
      }
      .w-75 {
        width: 75%;
      }
      .w-80 {
        width: 80%;
      }
      .w-85 {
        width: 85%;
      }
      .w-875 {
        width: 87.5%;
      }
      .w-90 {
        width: 90%;
      }
      .w-95{
        width: 95%;
      }
      .w-98 {
        width: 98%;
      }
      .w-100 {
        width: 100%;
      }
      .w-auto {
        width: auto;
      }
    </style>
  </head>

  <body>
       <form>
    <div class="mt-2">
       
      <div class="d-flex space-between">
        <img
          width="300"
          height="80"
          src="http://images.telconet.net/others/telcos/logo_security_data.jpg"
          alt="background image"
        />
         <div class="d-flex w-85">
         
        </div>
        <div class="mt-4" style="margin-left: 10em;">
          <p class="ft00 text-bold text-right">V1</p>
          <p style="font-family: sans-serif !important text-right" class="ft03">
            * campos obligatorios
          </p>
        </div>
      </div>
      <h1 class="text-bold text-center mt-3 ft04">FORMULARIO DE SOLICITUD</h1>
      <div class="d-flex flex-end ft01">
        <p>Fecha:</p>
        <p class="box w-30">$fechaActual</p>
      </div>

      <!-- 1 -->
      <p class="ft02 text-bold">1. Datos del Suscriptor del Certificado</p>
      <div class="d-flex ft01">
        <p class="w-20">Nombres y Apellidos*:</p>
        <p class="box w-90">$nombresApellidos</p>
      </div>
      <div class="d-flex space-between ft01">
        <div class="d-flex w-80">
          <p class="w-50">No. Cédula / No. Pasaporte*:</p>
          <p class="box w-70">$identificacion</p>
        </div>
        <div class="d-flex w-50">
          <p class="w-25">Nacionalidad*:</p>
          <p class="box w-70">$nacionalidad</p>
        </div>
      </div>
      <div class="d-flex ft01">
        <p class="w-4">Email*:</p>
        <p class="box w-55">$emailCliente</p>
      </div>

      <!-- 2 -->
      <p class="ft02 mt-1 text-bold">2. Tipo de Certificado</p>
      <p class="ft02 mt-05 text-bold" style="margin-left: 10em;">2.1. PERSONA NATURAL</p>
      <p class="ft01" style="font-family: Helvetica; margin-left: 10em;" >Ingresar los datos de la planilla o del RUC:</p>
      <div class="d-flex ft01">
        <p class="w-7">Dirección*:</p>
        <p class="box w-90">$direccion</p>
      </div>
      <div class="d-flex space-between ft01">
        <div class="d-flex w-50">
          <p class="w-14">Provincia*:</p>
          <p class="box w-60">$provincia</p>
        </div>
        <div class="d-flex w-50">
          <p class="w-10">Ciudad*:</p>
          <p class="box w-60">$ciudad</p>
        </div>
      </div>
      <div class="d-flex space-between ft01">
        <div class="d-flex w-50">
          <p class="w-14">Teléfono*:</p>
          <p class="box w-60">$telefono</p>
        </div>
        <div class="d-flex w-50">
          <p class="w-10">Celular:</p>
          <p class="box w-60">$celular</p>
        </div>
      </div>

      <!-- 3 -->
      <p class="ft02 mt-1 text-bold" >3. Tiempo de validez del certificado</p>
      <p class="ft01 mt-1 ml-4" style="font-family: Helvetica;"><span class="box">X</span> a. 3 dias</p>

      <!-- 4 -->
      <p class="ft02 mt-1 text-bold" style="font-family: Helvetica;">4. Uso del Certificado</p>
      <p class="ft01 mt-1 ml-4" style="font-family: Helvetica;">
        <span class="box">X</span> a. Firma de contrato con MEGADATOS
      </p>
      <p class="d-flex ft01 text-justify" style="font-family: Helvetica;">
        El solicitante declara que voluntaria y libremente acepta todos los
        términos y condiciones expresados en este documento, en la DPC y en la
        Política de Certificación del certificado solicitado, los cuales ha
        revisado detalladamente y no alberga duda alguna. En prueba de
        conformidad firma el documento; además corrobora que la información
        entregada y declarada a Security Data es real; en caso de descubrirse
        falsedad en las declaraciones o documentaciones aqué presentadas
        Security Data realizará las respectivas denuncias ante la autoridad
        competente.
      </p>
       <p class="ft00 mt-2">
                 <span><b> </b></span>
      </p>
       <p class="ft00 mt-2">
                 <span><b> </b></span>
      </p>
       <p class="ft00 mt-2">
                 <span><b> </b></span>
      </p>
      <p class="ft00 mt-2" style="margin-top: 9em;">
         
        <span><b>FIRMA DEL SUSCRIPTOR</b></span
        >
      
      </p>
      <div id="firma">
           <input
              id="inputfirma1"
              name="FIRMA_FORM_SD_CLIENTE"
              type="text"
              value=""
              style="
                background-color: #fff;
                width: 0em;
                margin-left: 0.75em;
                border-style: hidden;
                opacity: 0;
                border: none; "
              readonly
            />
        </div>
    </div>
     </form>
  </body>
</html>
');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'formularioSecurityData';

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'formularioSecurityData';

COMMIT;
END;
/