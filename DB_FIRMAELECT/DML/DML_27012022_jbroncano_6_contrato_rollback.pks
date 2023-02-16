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
DBMS_LOB.APPEND(bada, '<!DOCTYPE html>
<html>
     <head>
         <title>Contrato Digital - Netlife</title>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
         <style type="text/css">
          @page {
            margin-top: 0.1cm;
            margin-left: 1cm; 
            margin-right: 1cm;          
            size: B4; 
               @bottom-center {
                   content: counter(page) ''/'' counter(pages) ;
                   font-size: 11px;
             }
          }
          table {
             width: 60%;
              font-size: 12px;
             border-collapse: collapse;
            -fs-table-paginate: paginate; 
            -fs-page-break-min-height: 1.5cm;
              }
   
             *{
                 font-family: "Helvetica";
             }
             td,th {
                padding: 1px;
              }

             body
             {
                width: 98%;
                 font-size:10px;
             }
             .line-heightT{
                 height: 16px;
                 line-height: 18px;
                 margin-top: 2px;
             }

             #bienvenido
             {
                 font-weight: bold;
                 font-size:16px;
                 position: absolute;
             }
             #netlife
             {
                 font-size:9px;
             }
 
             /* // ==========================================
                // Clases definidas para los componentes
                // ==========================================*/
             #contenedor {
                 display: table;
                 width: auto;
                 vertical-align: middle;
                 border-spacing: 0px;
                 margin: 0px;
                 padding: 0px;
             }
             #row {
                 display: table-row;
                 vertical-align: middle;
             }
 
             #col {
                 display: inline-block;
                 vertical-align: middle;
             }
             #colCell {
                 display: table-cell;
                 vertical-align: middle;
             }
             /* // ==========================================
                // Clases definidas para los componentes
                // ==========================================*/
             .labelBlock
             {
                 font-weight: bold;
                 background: #f9e314;
                 $!fontSize
                 border-top: 1px black solid;
                 border-bottom: 1px solid black;
                 margin: 1em 0;
                 padding-left: 1em;
             }
             label,.labelGris
             {
                 background: #E6E6E6;
                 border-radius: 3px;
                 -moz-border-radius: 2px ;
                 -webkit-border-radius: 2px ;
             }
            div.labelGris {
                  min-height: 1em;
            }

             .box{
                 height: 15px;
                 width: 15px;
                 border: 1px solid black;
                 display:inline-block;
                 border-radius: 2px;
                 -moz-border-radius: 2px ;
                 -webkit-border-radius: 2px ;
                 vertical-align: top;
                 text-align: center;
             }
             .box-label{
                 padding-left: 3px;
                 text-align: center;
                 display:inline-block;
                 vertical-align: top;
             }
             .line-height,.labelBlock,#col{
 
                 margin-top: 2px;
             }
             .line-heightM,.labelBlock,#col{
 
                 margin-top: 2px;
             }
             .textLeft{
                 text-align: left;
             }
             .textRight{
                 text-align: right;
             }
             .textCenter{
                 text-align: center;
             }
             .textPadding{
                 padding-left: 5px;
             }
             .borderTable th,.borderTable td {
                 border: 1px solid black;
             }
 
             /* // ==========================================
                // Viñetas para las clausulas
                // ==========================================*/
             .clausulas ul {
                 list-style: none; /* Remove list bullets */
                 padding: 0;
                 margin: 0;
             }
 
             .clausulas li {
                 padding-left: 16px;
                 font-size: 8.5px;
             }

             .clausulasFont li {
                 padding-left: 16px;
                 $!fontSize
             }
 
             .clausulas li:before {
                 content: "-";
                 padding-right: 5px;
             }/* // ==========================================
                // Clases de manejo de tamaño de columnas
                // ==========================================*/
 
             .col-width-5{
                 width: 5% !important;
             }
             .col-width-10{
                 width: 10% !important;
             }
              .col-width-11{
                 width: 11% !important;
             }
             .col-width-13{
                 width: 13% !important;
             }
             .col-width-14{
                 width: 14% !important;
             }
             .col-width-15{
                 width: 15% !important;
             }
             .col-width-16{
                 width: 16% !important;
             }
            .col-width-17{
                 width: 17% !important;
             }
             .col-width-18{
                 width: 18% !important;
             }
             .col-width-19{
                 width: 19% !important;
             }
             .col-width-20{
                 width: 20% !important;
             }
             .col-width-21{
                 width: 21% !important;
             }
             .col-width-22{
                 width: 22% !important;
             }
             .col-width-23{
                 width: 23% !important;
             }
             .col-width-24{
                 width: 24% !important;
             }
             .col-width-25{
                 width: 25% !important;
             }
             .col-width-26{
                 width: 26% !important;
             }
             .col-width-27{
                 width: 27% !important;
             }
             .col-width-28{
                 width: 28% !important;
             }
             .col-width-29{
                 width: 29% !important;
             }
             .col-width-30{
                 width: 30% !important;
             }
             .col-width-32{
                 width: 32% !important;
             }
              .col-width-33{
                 width: 33% !important;
             }
             .col-width-34{
                 width: 34% !important;
             }
             .col-width-35{
                 width: 35% !important;
             }
             .col-width-37{
                 width: 37% !important;
             }
             .col-width-39{
                 width: 39% !important;
             }
             .col-width-40{
                 width: 40% !important;
             }
            .col-width-41{
                 width: 41% !important;
             }
             .col-width-42{
                 width: 42% !important;
             }
             .col-width-43{
                 width: 43% !important;
             }
            .col-width-44{
                 width: 44% !important;
             }
             .col-width-45{
                 width: 45% !important;
             }
             .col-width-46{
                 width: 46% !important;
             }
             .col-width-47{
                 width: 47% !important;
             }
             .col-width-48{
                 width: 48% !important;
             }
             .col-width-49{
                 width: 49% !important;
             }
             .col-width-50{
                 width: 50% !important;
             }
             .col-width-51{
                 width: 51% !important;
             }
              .col-width-52{
                 width: 52% !important;
             }
             .col-width-53{
                 width: 53% !important;
             }
             .col-width-55{
                 width: 55% !important;
             }
             .col-width-60{
                 width: 60% !important;
             }
            .col-width-63{
                 width: 63% !important;
             }
             .col-width-64{
                 width: 64% !important;
             }
             .col-width-65{
                 width: 65% !important;
             }
             .col-width-70{
                 width: 70% !important;
             }
             .col-width-75{
                 width: 75% !important;
             }
             .col-width-80{
                 width: 80% !important;
             }
             .col-width-85{
                 width: 85% !important;
             }
             .col-width-90{
                 width: 90% !important;
             }
             .col-width-95{
                 width: 95% !important;
             }
             .col-width-100{
                 width: 100% !important;
             }
             a {
                 display: block;
             }
         </style>
         <script>
            function substitutePdfVariables() {
                var vars = {};
                var query_strings_from_url = document.location.search.substring(1).split("&");
                for (var query_string in query_strings_from_url) {
                    if (query_strings_from_url.hasOwnProperty(query_string)) {
                        var temp_var = query_strings_from_url[query_string].split("=", 2);
                        vars[temp_var[0]] = decodeURI(temp_var[1]);
                    }
                }
                var css_selector_classes = ["page", "frompage", "topage", "webpage", "section", "subsection", "date", "isodate", "time", "title", "doctitle", "sitepage", "sitepages"];
                for (var css_class in css_selector_classes) {
                    if (css_selector_classes.hasOwnProperty(css_class)) {
                        var element = document.getElementsByClassName(css_selector_classes[css_class]);
    
                        for (var j = 0; j < element.length; ++j) {
                            element[j].textContent = vars[css_selector_classes[css_class]];
                        }
                    }
                }
            }
        
        </script>
     </head>
     <body style="$!fontSize" onload="substitutePdfVariables()">
        <!-- ================================= -->
         <!-- Logo Netlife y numero de contrato -->
         <!-- ================================= -->
       <div id="contenedor" class="col-width-100" style="$!fontSize">
         <table class="col-width-100">         
           <tr>     
             <td class="col-width-75" style="$!fontSize"><b>123CONTRATO DE ADHESIÓN DE PRESTACIÓN DE SERVICIOS</b></td> 
             <td id="netlife" class="col-width-25" text-align="right" rowspan="4">
               <img src="http://images.telconet.net/others/telcos/logo_netlife.png" alt="log" title="NETLIFE" height="40"/>
               <div style="font-size:14px">Telf 3920000</div>
               <div style="font-size:20px"><b>$!numeroAdendum</b></div>
             </td>
           </tr>
           <tr style="min-height: 3em;">
             <td class="col-width-75" style="$!verNumeroAdendum $!fontSize">Este documento adenda al contrato $!numeroContrato</td>
           </tr>
           <tr style="min-height: 3em;">
            <td class="col-width-75" style="$!verLeyenda $!fontSize min-height: 1em;">FE DE ERRATAS: este contrato es emitido como corrección del contrato $!numeroContrato</td>
          </tr>
          
         </table>
       </div>
         <!-- ============================ -->
         <!-- Datos iniciales del Contrato -->
         <!-- ============================ -->
         <div style="clear: both;"></div>
           <div id="contenedor" class="col-width-60">
              <div id="row">
                 <div id="col" class="col-width-30 ">
                     <b>CONTRATO: </b>
                 </div>
                 <div id="col" class="col-width-15 col-width-30 ">
                     <div class="box">$!isNuevo</div>
                     <div class="box-label">Nuevo</div>
                 </div>
                 <div id="col" class="col-width-17 ">
                     <div class="box">$!isExistente</div>
                     <div class="box-label">Existente</div>
                 </div>
             </div>
            <div id="row">
                 <div id="col" style="min-width:30%">
                     <b>FECHA(aa-mm-dd): </b>
                     </div>
                 <div id="col">$fechaActual</div>
             </div>
             <div id="row" style="min-height: 2em;">
                 <div id="col" class="col-width-30">
                     <b>TIPO DE CLIENTE:</b>
                 </div>
                 <div id="col" class="col-width-15">
                     <div class="box">$!isNatural</div>
                     <div class="box-label">Natural</div>
                 </div>
                 <div id="col" class="col-width-15">
                     <div class="box">$!isJuridico</div>
                     <div class="box-label">Juridico</div>
                 </div>
             </div>
         </div>
         <!-- ========================================================= -->
         <!--        Datos de Adhesión de prestación de servicios       -->
         <!-- ========================================================= -->
         <div style="clear: both;"></div>
         <div class="labelBlock">CONTRATO DE ADHESIÓN DE PRESTACIÓN DE SERVICIOS</div>
         <div style="$!fontSize">
             <span >
                 <b>Primera:</b> En la ciudad de $!ciudadServicio a los $!diaActual del mes de $!mesActual Celebran el presente Contrato de Adhesión de Prestación de Servicios de Acceso a
                 Internet/Portador; 1) por una parte MEGADATOS S.A., compañía constituida bajo las leyes de la República del Ecuador, cuyo objeto social constituye entre
                 otros, la prestación de servicios de telcomunicaciones. Mediante resolución SNT-2010-085 del 30 de marzo del 2010 se autorizó la renovación del
                 permiso para la prestación del servicio de valor agregado de acceso a la red de internet, permiso suscrito el 8 de abril del 2010 e inscrito en el tomo 8S a
                 fojas 8503 del registro público de telecomunicaciones, cuyo nombre Comercial es NETLIFE 1. en adelante denominado simplemente MEGADATOS, cuyo
                 nombre comercial es NETLIFE, ubicada en la calle Núñez de Vela y Atahualpa-Torre del Puente, en la provincia de Pichincha, cantón Quito, ciudad de
                 Quito, Parroquia Iñaquito, Teléfonos: 39-20-000, RUC: 1791287541001, mail: info@netlife.net.ec, web:www.netlife.ec/puntos-de-atencion/ 2) por otra
                 parte el ABONADO, cuyos datos se detallan a continuación:
             </span>
         </div>
         <!-- ============================== -->
         <!--        Datos del Cliente       -->
         <!-- ============================== -->
         <div style="clear: both;"></div>
         <div class="labelBlock">DATOS DEL ABONADO/SUSCRIPTOR</div>
         <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-10"><b>Nombre Completos:</b></div>
                 <div id="col" class="col-width-50 labelGris">
                     $!nombresApellidos
                     <span class="textPadding"></span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5"><b>CC:</b></div>
                 <div id="col" class="col-width-25 labelGris">
                     <span class="textPadding">
                     $!identificacion
                     </span>
                 </div>
             </div><div id="row">
                 <div id="col" class="col-width-15"><b>Nacionalidad:</b></div>
                 <div id="col" class="col-width-15 labelGris">
                     <span class="textPadding">
                     #if ($nacionalidad == "NAC")
                         ECUATORIANA
                     #elseif ($userType == "EXT")
                         EXTRANJERA
                     #else
                         $!nacionalidad
                     #end
                     </span>
                 </div>
                 <div id="col" class="col-width-15" style="text-align : center; padding-right: 1px;"><b>Estado Civil:</b></div>
                 <div id="col" class="col-width-15 labelGris">
                     <span class="textPadding">$!estadoCivil</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5" style="text-align : left; padding-right: 1px;"><b>Sexo:</b></div>
                 <div id="col" class="col-width-5" style="text-align : right; padding-right: 1px;"><b>M</b></div>
                 <div class="box">$!isMasculino</div>
                 <div id="col" class="col-width-5" style="text-align : right; padding-right: 1px;"><b>F</b></div>
                 <div class="box">$!isFemenino</div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-65"><b>¿El abonado es discapacitado (en caso de afirmativo, aplica tarifa preferencial):</b></div>
                 <div id="col" class="col-width-10" style="text-align : right; padding-right: 1px;"><b>Si</b></div>
                 <div class="box">$!isDiscapacitadoSi</div>
                 <div id="col" class="col-width-10" style="text-align : right; padding-right: 1px;"><b>No</b></div>
                 <div class="box">$!isDiscapacitadoNo</div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-15"><b>Razon Social:</b></div>
                 <div id="col" class="col-width-46 labelGris">
                     <span class="textPadding">$!razonSocial</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5"><b>RUC:</b></div>
                 <div id="col" class="col-width-25 labelGris">
                     <span class="textPadding">$!ruc</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-20"><b>Representante Legal:</b></div>
                 <div id="col" class="col-width-41 labelGris">
                     <span class="textPadding">$!representanteLegal</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5"><b>CC:</b></div>
                 <div id="col" class="col-width-25 labelGris">
                     <span class="textPadding">$!ciRepresentanteLegal</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-20"><b>Actividad Económica:</b></div>
                 <div id="col" class="col-width-33 labelGris">
                     <span class="textPadding">$!actividadEconomica</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-15"><b>Origen Ingresos:</b></div>
                 <div id="col" class="col-width-23 labelGris">
                     <span class="textPadding">$!origenIngresos</span>
                 </div>
             </div>
         </div>  ');
	DBMS_LOB.APPEND(bada, ' <!-- ======================================== -->
         <!--        Datos del Cliente - Ubicacion     -->
         <!-- ======================================== -->        
         <div style="clear: both;"></div>
         <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-100" style="font-style: oblique; padding-top: 5px;">Formato: Calle Principal,Numeración,Calle Secundaria,Nombre Edficio o Conjunto,Piso,Numero
                 de Departamento o Casa</div>
             </div>
             <div id="row">
                 <div id="col" style="width:20%">
                     <b>Dirección estado de cuenta: </b>
                     </div>
                 <div id="col" style="width:74%" class="labelGris">
                     <span class="textPadding">$direccion</span>
                 </div>
             </div>
             <div id="row">
                <div id="col" class="col-width-10"> <b>Referencia: </b> </div>
                <div id="col" class="col-width-50 labelGris">
                    <span class="textPadding">$!referenciaServicio</span>
                </div>
                <div id="col" class="col-width-5" style="width: 5.7% !important;"></div>
                <div id="col" class="col-width-15"><b>Coordenada Latitud:</b></div>
                <div id="col" class="col-width-15 labelGris">
                    <span class="textPadding">$latitud</span>
                </div>
            </div>
             <div id="row">
                 <div id="col" class="col-width-10"> <b>Provincia: </b> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$provincia</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Ciudad: </b> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$ciudad</span>
                 </div><div id="col" class="col-width-5" ></div>
                 <div id="col" class="col-width-16"> <b>Coordenada Longitud: </b> </div>
                 <div id="col" class="col-width-15 labelGris">
                     <span class="textPadding">$longuitud</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-10"> <b>Cantón: </b> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$canton</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Parroquia: </b> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$parroquia</span>
                 </div>
                 <div id="col" class="col-width-5" style="width: 4.7% !important;"></div>
                 <div id="col" class="col-width-13"><b>Sector/Barrio:</b> </div>
                 <div id="col" class="col-width-18 labelGris">
                     <span class="textPadding">$sector</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-10"> <b>Tipo Ubicación: </b> </div>
                 <div id="col" class="col-width-49">
                     <div class="box-label">Casa</div>
                     <div class="box">$isCasa</div>
 
                     <div class="box-label">Edificio</div>
                     <div class="box">$isEdificio</div>
 
                     <div class="box-label">Conjunto</div>
                     <div class="box">$isConjunto</div>
                 </div>
                 <div id="col" class="col-width-5" style="width: 0.1% !important;"></div>
                 <div id="col" class="col-width-10"> <b>Correo: </b> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$correoCliente</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-19"> <b>Teléfono: </b> </div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">$telefonoCliente</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Celular: </b> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$celularCliente</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-19"> <b>Nombre de Referencia Familiar: </b> </div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">$refFamiliar1</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Teléfono: </b> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$telefonoFamiliar1</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-19"> <b>Nombre de Referencia 2: </b> </div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">$refFamiliar2</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Teléfono: </b> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$telefonoFamiliar2</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-19"> <b>Nombre de Vendedor: </b> </div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">$nombreVendedor</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Código: </b> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$codigoVendedor</span>
                 </div>
             </div>
         </div>
         <br/>
		 		         
 
         <div style="$!fontSize">
             <span >
                 <b>SEGUNDA.-</b> PRESTACIÓN DEL SERVICIO: MEGADATOS se compromete a proporcionar al ABONADO el acceso a redes nacionales e internacionales de
                 Internet de manera que el mismo disfrute de los servicios y funciones prestados por dichas redes. Se deja expresa constancia que MEGADATOS se
                 responsabiliza única y exclusivamente del acceso a las redes de Internet, por éste motivo no resulta de su responsabilidad el contenido de la información a
                 la que pueda accederse, ni el almacenamiento de la misma, incluido el correo electrónico. Las características del servicio objeto de este contrato, así como
                 las características mínimas que requiere el equipo y otros que deben ser garantizados por el ABONADO constan en el anverso de este contrato.
             </span>
         </div>     <!-- ======================================== -->
         <!--        Datos del Servicio                -->
         <!-- ======================================== -->
         <br/>        <div style="clear: both;"></div>
         <div class="labelBlock">DATOS DEL SERVICIO</div>
         <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-40">Los datos de instalación son los mismos que los datos del cliente?</div>
                 <div id="col" class="col-width-40">
                     <div class="box-label">Si</div>
                     <div class="box">$!isSi</div>
 
                     <div class="box-label">No</div>
                     <div class="box">$!isNo</div>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-100" style="font-style: oblique; padding-top: 5px;">Formato: Calle Principal,Numeración,Calle Secundaria,Nombre Edficio o Conjunto,Piso,Numero
                 de Departamento o Casa</div>
             </div>
             <div id="row">
                 <div id="col" style="width:23%">
                     <b>Dirección estado de cuenta: </b>
                     </div>
                 <div id="col" style="width:75%" class="labelGris">
                     <span class="textPadding">$!direccionServicio</span>
                 </div>
             </div>
             <div id="row">
                <div id="col" class="col-width-10"> <b>Referencia: </b> </div>
                <div id="col" class="col-width-49 labelGris">
                    <span class="textPadding">$!referenciaServicio</span>
                </div>
                <div id="col" class="col-width-5"></div>
                <div id="col" class="col-width-18"> <b>Coordenada Latitud: </b> </div>
                <div id="col" class="col-width-15 labelGris">
                    <span class="textPadding">$!latitudServicio</span>
                </div>
            </div>

             <div id="row">
                 <div id="col" class="col-width-10"> <b>Ciudad: </b> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$!ciudadServicio</span>
                 </div>
                 <div id="col" class="col-width-5" style="width: 5.5% !important;"></div>
                 <div id="col" class="col-width-9"> <b>Canton: </b> </div>
                 <div id="col" class="col-width-20 labelGris">
                     <span class="textPadding">$!cantonServicio</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-18"> <b>Coordenada Longitud: </b> </div>
                 <div id="col" class="col-width-15 labelGris">
                     <span class="textPadding">$!longuitudServicio</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-10"> <b>Parroquia: </b> </div>
                 <div id="col" class="col-width-28 labelGris">
                     <span class="textPadding">$!parroquiaServicio</span>
                 </div>
                 <div id="col" class="col-width-25"></div>
                 <div id="col" class="col-width-15"><b>Sector/Barrio: </b> </div>
                 <div id="col" class="col-width-19 labelGris">
                     <span class="textPadding">$!sectorServicio</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-10"> <b>Tipo Ubicación: </b> </div>
                 <div id="col" class="col-width-53">
                     <div class="box-label">Casa</div>
                     <div class="box">$!casaServicio</div>
 
                     <div class="box-label">Edifcio</div>
                     <div class="box">$!edificioServicio</div>
 
                     <div class="box-label">Conjunto</div>
                     <div class="box">$!conjuntoServicio</div>
                 </div>
                 <div id="col" class="col-width-5" style="width: 0.1% !important;"></div>
                 <div id="col" class="col-width-10"> <b>Correo: </b> </div>
                 <div id="col" class="col-width-24 labelGris">
                     <span class="textPadding">$!correoContacto</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-15"> <b>Tlf sitio: </b> </div>
                 <div id="col" class="col-width-43 labelGris">
                     <span class="textPadding">$!telefonoContacto</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Celular: </b> </div>
                 <div id="col" class="col-width-24 labelGris">
                     <span class="textPadding">$!celularContacto</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-15"> <b>Persona a contactar: </b> </div>
                 <div id="col" class="col-width-43 labelGris">
                     <span class="textPadding">$!personaContacto</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <b>Horario: </b> </div>
                 <div id="col" class="col-width-24 labelGris">
                     <span class="textPadding">$!horarioContacto</span>
                 </div>
             </div>
         </div>         
         <br/>
         <br/>
         <br/>
          <br/>
         <br/>
         <br/>
         <br/>
         <br/>
         <br/>
         <br/>
         <br/>
        <br/>
         <br/>
         
              ');
	DBMS_LOB.APPEND(bada, '  <!-- ============================== -->
        <!--      Servicios Contratados     -->
        <!-- ============================== -->
        <div style="clear: both;"><br/></div>
        <div  style="margin-block-end: 13px !important;" class="labelBlock">SERVICIOS CONTRATADOS (ANEXO TÉCNICO)</div>
        <div style="width:42%; float:left; vertical-align:top;" >
            <div class="labelBlock textCenter" style="margin: 0; border:1px black solid;">CARACTERÍSTICAS DEL PLAN</div>
            <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse;border-spacing:0;">
              <tbody>
                <tr>
                     <td class="col-width-60" colspan="2">
                      
                         <div id="col" class="col-width-65">
                              COMPARTICIÓN:
                          </div>
                          <div id="col" class="col-width-30" style="height: 40px;">
                            <div id="row">
                                <div id="col" >
                                    <div class="box">$!is2a1</div>
                                    <span class="textPadding">2:1</span>
                                </div>
                            </div>
                            <div id="row">
                                <div id="col" >
                                    <div class="box">$!is1a1</div>
                                    <span class="textPadding">1:1</span>
                                </div>
                            </div>
                        </div>
                    </td>

                    <td class="col-width-50 line-height textCenter" colspan="2">
                       <div >
                          <div class="box">$!isHome</div>
                          <div class="box-label" style="$!fontSize">HOME    </div>
                        </div>
                         <div >
                          <div class="box">$!isPyme</div>
                          <div class="box-label" style="$!fontSize">PYME</div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="col-width-50 line-height textCenter" colspan="2" style="$!fontSize">
                        <b>MEDIO:</b>
                        <div class="box">$!isGeponFibra</div>
                        <div class="box-label">GEPON/FIBRA</div>

                        <div class="box">$!isDslOtros</div>
                        <div class="box-label">DSL/OTROS</div>

                    </td>
                    <td class="col-width-50 line-height textCenter" colspan="3" style="$!fontSize">
                         <b>PLAN:</b>
                        <div class="box">$!isSimetrico</div>
                        <div class="box-label">SIMETRICO</div>

                        <div class="box">$!isAsimetrico</div>
                        <div class="box-label">ASIMETRICO</div>
                    </td>

                </tr><tr>
                    <td class="line-height textCenter labelGris" colspan="2" style="$!fontSize">
                        <b> VELOCIDAD INTERNACIONAL (Mbps) </b>
                    </td>
                    <td class="line-height textCenter labelGris" colspan="2" width="50%" style="$!fontSize">
                        <b> VELOCIDAD LOCAL (Mbps) </b>
                    </td>
                </tr>
                <tr>
                    <td class="line-height textCenter" colspan="1">TASA MAXIMA DE BAJADA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velIntMax Mbps</td>
                    <td class="line-height textCenter" colspan="1">TASA MAXIMA DE BAJADA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velNacMax  Mbps</td>
                </tr>
                <tr>
                    <td class="line-height textCenter" colspan="1">TASA MINIMA DE BAJADA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velIntMin Mbps</td>
                    <td class="line-height textCenter" colspan="1">TASA MINIMA DE BAJADA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velNacMin Mbps</td>
                </tr>
                <tr>
                    <td class="line-height textCenter" colspan="1">TASA MAXIMA DE SUBIDA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velIntMax Mbps</td>
                    <td class="line-height textCenter" colspan="1">TASA MAXIMA DE SUBIDA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velNacMax Mbps</td>
                </tr>
                <tr>
                    <td class="line-height textCenter" colspan="1">TASA MINIMA DE SUBIDA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velIntMin Mbps</td>
                    <td class="line-height textCenter" colspan="1">TASA MINIMA DE SUBIDA</td>
                    <td class="line-height textCenter" colspan="1" width="15%">$!velNacMin Mbps</td>
                </tr>
                </tbody>
            </table>
 	                 
            <div class="labelBlock textCenter" style="margin: 0; border:1px black solid;">PRODUCTOS/SERVICIOS ADICIONALES</div>
            <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse;border-spacing:0;">
              <tbody>
                {{listaAdicionales}}               
                <tr>
                    <td class="col-width-10 line-heightT textCenter" style="$!fontSize" rowspan="2" colspan="3">Acepto los beneficios de promociones vinculados con la cláusula 11 de tiempo mÍnimo de permanencia.</td>
                    <td class="col-width-10 line-heightT textCenter ">Si</td>
                    <td class="col-width-10 line-heightT textCenter "><div class="box">$!isAceptacionBeneficios</div></td>
                </tr>
                <tr>
                <td class="col-width-10 line-heightT textCenter ">No</td>
                    <td class="col-width-10 line-heightT textCenter "></td>
                </tr>
                <tbody>
            </table>
        </div>
        <div style="width:55%; float:right; vertical-align:top;$!fontSize">
            <div class="labelBlock textCenter" style="margin: 0; border:1px black solid;">SERVICIOS Y TARIFAS</div>
            <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse; border-spacing:0; ">
            <tbody>
                <tr>
                    <td class="line-height textCenter labelGris" style="width: 37%"><b>SERVICIO</b></td>
                    <td class="line-height textCenter labelGris" style="width: 10%"><b>CANTIDAD</b></td>
                    <td class="line-height textCenter labelGris" style="width: 13%"><b>INSTALACION</b></td>
                    <td class="line-height textCenter labelGris" style="width: 12%"><b>VALOR MES</b></td>
                    <td class="line-height textCenter labelGris" style="width: 15%"><b>VALOR TOTAL</b></td>
                    <td class="line-height textCenter labelGris" style="width: 13%"><b>OBSERVACIONES</b></td>
                </tr>
                <tr>
                    <td class="line-height labelGris">ACCESO Y NAVEGACIóN DE INTERNET</td>
                    <td class="line-height textCenter">$!productoInternetCantidad</td>
                    <td class="line-height textCenter">$!productoInternetInstalacion</td>
                    <td class="line-height textCenter">$!productoInternetPrecio</td>
                    <td class="line-height textCenter">$!productoInternetPrecio</td>
                    <td class="line-heightM textCenter">$!productoInternetObservaciones</td>
                </tr>
                     {{listaProductos}}
                <tr>
                    <td class="line-height textCenter" colspan="2" style="border-bottom:1px white solid;">SUBTOTAL:</td>
                    <td class="line-height textCenter">$!subtotalInstalacion</td>
                    <td class="line-height textCenter">SUBTOTAL:</td>
                    <td class="line-height textCenter">$!subtotal</td>
                    <td class="line-height textCenter" style="border-bottom:1px white solid;"></td>
                </tr>
                <tr>
                    <td class="line-height textCenter" colspan="2" style="border-bottom:1px white solid;">IMPUESTOS:</td>
                    <td class="line-height textCenter">$!impInstalacion</td>
                    <td class="line-height textCenter">IMPUESTOS:</td>
                    <td class="line-height textCenter">$!impuestos</td>
                    <td class="line-height textCenter" style="border-bottom:1px white solid;"></td>
                </tr>
                <tr>
                    <td class="line-height textCenter" colspan="2">TOTAL:</td>
                    <td class="line-height textCenter">$!totalInstalacion</td>
                    <td class="line-height textCenter">TOTAL:</td>
                    <td class="line-height textCenter">$total</td>
                    <td class="line-height textCenter"></td>
                </tr>
                <tr>
                    <td colspan="3">

                        <div id="row">
                        <div id="colCell" class="col-width-10 textRight"><b>Promoción:</b></div>
                        <div>$!descInstalacion</div>
                        <div id="colCell" class="col-width-30 textRight">Descuento instalación:</div>
                        <div class="box">$!isDescInstalacion</div>
                        </div>

                    </td>
                    <td class="line-height textCenter" colspan="3">
                        Mensualidad promo:
                        <div class="box">$!isPrecioPromo</div>
                        $+IVA #meses
                        <div class="box">$!numeroMesesPromo</div>
                    </td>
                </tr>
                <tbody>
            </table>
        </div>
 
        <!-- ========================================== -->
        <!-- Observaciones de los Servicios Contratados -->
        <!-- ========================================== -->        
        <br/>  <br/>  <br/>
						                 
        <div style="clear: both;"></div>
        <div style="clear: both;"></div>
        <div style="clear: both;"></div>
        <br/>
        <div id="contenedor" class="col-width-100" style="height: 65px;">
            <div id="row">
                <div id="col" class="col-width-10"> <b>Obs: </b> </div>
                <div id="col" class="col-width-100 labelGris">
                    <span class="textPadding" style="$!fontSize">
                    $!obsServicio
                    </span>
                </div>
            </div>
        </div>
    ');
	DBMS_LOB.APPEND(bada, '
        <!-- ========================================== -->
        <!-- Requerimientos Adicionales -->
        <!-- ========================================== -->
        <div class="col-width-100" style="text-align: justify; $!fontSize">
            <div > <b>REQUERIMIENTOS ADICIONALES: </b> </div>
            <br/>
            <div>
                <span>
                    Los siguientes requerimientos podrán ser brindados por un valor adicional:
                    <br/>
                </span>
            </div>
            <div class="clausulas clausulasFont" >
                <ul>
                    <li>Obras civiles o cambios de acometida,sujeto a factibilidad.</li>
                    <li>Después de 300 metros de cableado de fibra óptica de última milla, cada metro adicional de cableado de fibra óptica tendrá un valor adicional de $1,00+ impuestos de ley. Sujeto a factibilidad.</li>
                    <li>Nuevas contrataciones, cambios de plan, reactivaciones, cesión de derechos, traslado físico del servicio a otro domicilio o reubicación en el mismo domicilio,sujeto a factibilidad.</li>
                    <li>Nuevas contrataciones podrán ser solicitadas mediante correo con firma digital a info@netlife.ec,llamando al 3920000, donde la llamada será grabada o visitándonos a nuestros centros de atención al cliente, cuyos horarios de atención se encuentran en: http://www.netlife.ec/puntos-de-atencion/ </li>
                    <li>Asistencia técnica a domicilio por solicitud del cliente y debido a causas no imputables a MEGADATOS S.A. en la provisión del servicio de Internet.</li>
                </ul>
            </div>
            <div > <b>CONDICIONES ADICIONALES: </b> <br/> </div>
            <br/>
            <div  class="clausulas clausulasFont" >
                <ul>
                    <li>El tiempo de instalación promedio del servicio es de 7 días hábiles, sin embargo, puede variar. El servicio esta sujeto a factibilidad, disponibilidad técnica y cobertura de red. No incluye obras civiles o cambios de acometida. El contrato entrará en vigencia una vez instalado el servicio y la fecha de activación del mismo estará especificada en la factura correspondiente. El cliente acepta y se obliga a estar presente o delegar a un adulto capaz para recibir el servicio el momento de la instalación. MEGADATOS no se hace responsable por pérdidas o daños que puedan derivarse de la falta de cliente o un adulto responsable de recibir el servicio.</li>
                    <li>La instalación del servicio incluye un punto de acometida donde se colocará el CPE y Router WiFi que serán administrados exclusivamente por MEGADATOS. No se podrán retirar,desinstalar o sustituir los equipos proporcionados por MEGADATOS o modificar la configuración de los mismos. De ninguna manera se podrá revender, repartir o compartir el servicio a través de cualquier mecanismo físico o inalámbrico o a través de la compartición de claves de acceso a terceros, no se podrá instalar servidores con ningún tipo de aplicativos, ni cámaras de video para video vigilancia o para video streaming para fines comerciales. Para disponer de estos servicios el cliente deberá contratar el plan que contemple aquello, el incumplimiento de estas condiciones será causal de terminación de contrato en forma inmediata, bastando la notificación del incumplimiento con la información de monitoreo respectivo, sin eximir de la cancelación de las deudas pendientes, devolución de equipos y valores de reliquidación por plazo de permanencia mínima.</li>
                    <li>La instalación del servicio incluye la configuración para dejar navegando en internet 1 dispositivo. No incluye cableado interno.</li>
                    <li>El cliente es responsable de la instalación y configuración interna de su red de área local, así como del control de la información y navegación que realice por internet MEGADATOS pone a disposición de los clientes un servicio integral de seguridad informática para reducir el potencial acceso a información que pueda herir la susceptibilidad o que pueda ser fuente de amenazas cibernéticas. Este servicio puede ser activado por el cliente por un precio adicional según se indique en los planes de la página web de MEGADATOS y es responsable de su instalación en sus equipos terminales.</li>
                    <li>El cliente entiende que sólo podrá requerir IPs públicas estáticas en planes PYME, sin embargo acepta que la dirección IP asignada podría modificarse por traslados, cambios de plan o mejoras tecnológicas, motivos en los cuáles existirá una coordinación previa para generar el menor impacto posible.</li>
                    <li>El servicio HOME sólo es para el segmento residencial, el servicio PYME para profesionales Home/Office que cuenten con máximo 5 equipos y para empresas (no disponibles para Cybers y/o ISPs). El incumplimiento de estas condiciones se convierte en causal de terminación unilateral de contrato.</li>
                    <li>El cliente acepta que MEGADATOS en planes de Internet, para evitar el SPAM, mantenga restringido el puerto 25 (salvo PYME) y para proteger su servicio de posibles ataques y preservar la seguridad de la red restrinja puertos normalmente usados para este fin como son: 135, 137, 138, 139, 445, 593, 1434, 1900, 5000.</li>
                    <li>Los planes de NETLIFE no incluyen cuentas de correo electrónico. En caso de que el cliente lo solicite es posible agregar una cuenta de correo electrónico con dominio netlife.ec por un valor adicional. Esta cuenta de correo no incluye el almacenamiento del mismo, sino que es el cliente quien deberá almacenar los correos que lleguen a su cuenta. MEGADATOS no se responsabiliza de ninguna forma por la perdida de almacenamiento de ningún contenido o información.</li>
                    <li>El equipo WiFi provisto tiene puertos alámbricos que permiten la utilización óptima de la velocidad ofertada en el plan contratado, además cuenta con conexión WiFi en planes HOME y PYME, a una frecuencia de 2.4Ghz que permite una velocidad máxima de 30Mbps a una distancia de 3mts y pueden conectarse equipos a una distancia de hasta 15metros en condiciones normales, sin embargo, la distancia de cobertura varía según la cantidad de paredes, obstáculos e interferencia que se encuentren en el entorno. La cantidad máxima de dispositivos simultaneos que soporta el equipo WiFi son de 15. El cliente conoce y acepta esta especificación técnica y que la tecnología WiFi pierde potencia a mayor distancia y por lo tanto se reducirá la velocidad efectiva a una mayor distancia de conexión del equipo.</li>
                    <li>Los equipos terminales y cualquier equipo adicional que eventualmente se instalen (CPE) son propiedad de MEGADATOS. En el caso de daño por negligencia del Cliente, éste asumirá el valor total de su reposición considerando el deterioro normal y depreciación del mismo. Para el caso de servicios FTTH son equipos ONT y WIFI, en el caso de brindar servicios DSL sólo será el WIFI y en otros medios sólo será el CPE que tendrá el mismo costo del ONT. El costo es de USD$85 (mas IVA) del ONT, USD$40 (mas IVA) para el equipo WiFi 2.4Ghz, USD$175 (mas IVA) para el ONT+WiFi Dual Band y USD$75 (mas IVA) para el equipo AP Extender WiFi Dual Band, los cuáles deben incluir sus respectivas fuentes. En caso de pérdida de las fuentes, tienen un costo de USD$10,00 cada una. </li>
                    <li>Disponibilidad del servicio 98%. El tiempo promedio de reparación mensual de todos los clientes de NETLIFE es de 24 horas de acuerdo a la normativa vigente, e inicia después de haberlo registrado con un ticket en los canales de atención al cliente de NETLIFE, se excluye el tiempo imputable al cliente.</li>
                    <li>En caso de reclamos o quejas, el tiempo máximo de respuesta es de 7 días después de haberlas registrado con un ticket en los canales de atención de NETLIFE.</li>
                    <li>Los canales de atención al cliente de NETLIFE son: 1) Call Center 2) Centros de Atención al cliente de NETLIFE 3) Página web. 4) Redes sociales. La información de estos canales se encuentra actualizada en la página web de NETLIFE www.netlife.ec</li>
                    <li>De acuerdo con la norma de calidad para la prestación de servicios de internet, para reclamos de velocidad de acceso el cliente deberá realizar los siguientes pruebas: 1) Realizar 2 o 3 pruebas de velocidad en canal vacio, en el velocímetro provisto por NETLIFE y guardarlas en un archivo gráfico. 2) Contactarse con el call center de NETLIFE para abrir un ticket y enviar los resultados de las pruebas.</li>
                    <li>La atención telefónica del Call Center es 7 días,24 horas incluyendo fines de semana y feriados. El soporte presencial es en días y horas laborables.</li>
                    <li>Cualquier cambio referente a la información de la factura o el servicio deberá notificarse 15 días antes de la finalización del ciclo de facturación.</li>
                    <li>MEGADATOS facturará y cobrará al ABONADOt1,00 por los reprocesos y cargos bancarios que se produzcan por falta de fondos de acuerdo a las fechas y condiciones de pago del presente contrato, valor que será detallado en la factura del mes correspondiente. En caso de suspensión del servicio por falta de pago deberá realizar el pago del servicio en uno de los canales de pago correspondientes y comunicarlos a nuestros canales de atención al cliente. Adicionalmente el cliente acepta el pago de $3,00 por concepto de reconexión que será registrado en la siguiente factura. El tiempo máximo de reconexión del servicio después del pago es de 24 horas.</li>
                    <li>El cliente acepta que la recepción las facturas mediante la modalidad de facturación electrónica sin costo, o vía física acercándose a un centro de atención de MEGADATOS para solicitar su factura previo el pago de $1,00 por ocasión por gastos de procesamiento y emisión de factura. </li>
                    <li>TIPO DE FACTURACIÓN: {{isTipoFacturacion}} </li>
                    <li>En caso de tener reclamos debidamente reportados con un ticket y no resueltos por la operadora, puede comunicarse al ARCOTEL a través del 1-800-567567 o cir@arcotel.gob.ec</li>
                    <li>Para el pago de los servicios de internet, a nombre de usuarios con discapacidad o de la persona natural o juridica sin fines de lucro que represente legalmente a la persona con discapacidad, se aplica las rebajas establecidas en la Ley Orgánica de Discapacidades vigente y sus futuras reformas, cumpliendo adicionalmente con la resolución TEL-072-04-CONATEL-2013 y sus futuras reformas.</li>
                </ul>
            </div><br/>
							                 
            <div> <b>CONDICIONES DE OPERACIÓN: </b> <br/> </div>
            <br/>
            <div class="clausulas clausulasFont" >
                <ul>
                    <li>El cliente es responsable de mantener una energía eléctrica regulada de 110V</li>
                    <li>El cliente debe contar con un computador o un dispositivo funcionando adecuadamente con las siguientes características mínimas: Procesador pentium III o superior / 512MB de memoria RAM / 20GB mínimo en disco duro / tarjeta de red.</li>
                    <li>Temperatura de operación normal de los equipos propiedad de MEGADATOS: 0-30 grados centígrados.</li>
                    <li>Para tener conocimiento sobre las características de seguridad que están implícitas al intercambiar información o utilizar aplicaciones disponibles en la red,favor visite nuestro sitio web: www.netlife.ec</li>
                    <li>Para tener conocimiento de los derechos que lo asisten como usuario, puede encontrar la norma de Calidad de Servicios de Valor Agregado, así como el link directo a la página del ARCOTEL en nuestro sitio web: www.netlife.ec</li>
                    <li>Para realizar la medición del ancho de banda contratado se puede ingresar a la página web de NETLIFE www.netlife.ec y utilizar el velocímetro allí provisto.</li>
                    <li>El cliente garantizará que el personal designado por MEGADATOS pueda ingresar a los sitios donde se encuentren instalados los equipos parte del presente servicio para realizar trabajos de instalación, mantenimiento correctivo o preventivo, revisión física del estado de los equipos propiedad de MEGADATOS y cuando MEGADATOS lo requiera. El incumplimiento de estas condiciones será causal de terminación unilateral de contrato.</li>
                </ul>
            </div>
        </div>
        <br/>
 	
          <!-- ================================================= -->
        <!--    Contrato de prestación de servicios     -->
        <!-- ================================================= -->
        <div style="text-align: justify; $!fontSize">
           <span>
                TERCERA.- OBLIGACIONES DEL ABONADO: Las obligaciones del ABONADO son las siguientes: 3.1.- Cancelar a MEGADATOS los valores correspondientes a los servicios contratados en el plan elegido que consta en el anverso de este Contrato o bajo cualquiera de las modalidades aceptadas por la ley de comercio electrónico y en la norma técnica que regula las condiciones generales de los contratos de adhesión. 3.2 Obtener la debida autorización y/o licencia del propietario de programas o información en caso de que su transferencia a través de las redes nacionales e internacionales de Internet, así lo requieran. 3.3.- Obtener y salvaguardar el uso de la clave de acceso cuando la misma se requiera para la transferencia de información a través de las redes nacionales e internacionales de Internet, 3.4.- Respetar y someterse en todo a la Ley Orgánica de Telecomunicaciones, Ley de Propiedad Intelectual, y en general a todas las leyes que regulan la materia en el Ecuador. 3.5.- Informarse adecuadamente de las condiciones de cada uno de los servicios que brinda MEGADATOS,los cuales se rigen por el presente Contrato y las leyes aplicables vigentes,no pudiendo alegar desconocimiento de dichas condiciones contractuales. 3.6.- Mantener actualizada la información de contacto,correo,teléfono fijo,teléfono móvil con MEGADATOS para garantizar la recepción de la información que genera la relación contractual.
                </br>
                CUARTA.- OBLIGACIONES DE MEGADATOS: Las obligaciones de MEGADATOS son las siguientes: 4.1.- Suministrar al ABONADO el servicio de acceso a las redes nacionales e internacionales de Internet acatando las disposiciones previstas en la Ley y en el presente Contrato. 4.2.- Actuar con la debida diligencia en la prestación del servicio, 4.3.- Respetar y someterse en todo a la Ley Orgánica de Telecomunicaciones, Ley Orgánica de Defensa del Consumidor,y en general a todas las leyes que en el Ecuador regulan la materia. 4.4.- Implementar los mecanismos necesarios que permitan precautelar la seguridad de sus redes. 4.5.- Entrega o prestar oportuna y eficientemente el servicio,de conformidad a las condiciones establecidas en el contrato y normativa aplicable,sin ninguna variación. 4.6.- Notificar cualquier modificación de los planes tarifarios al ARCOTEL con al menos 48 horas a su fecha de vigencia según lo establecido en la Ley Orgánica de Telecomunicaciones.
                <br/>QUINTA.- ALCANCE DE LA RESPONSABILIDAD DE MEGADATOS: Es responsabilidad de MEGADATOS cumplir con las obligaciones contempladas en el presente Contrato. Sin perjuicio de lo anterior se deja expresa constancia que MEGADATOS no se hará responsable en los siguientes casos: 5.1.- En caso de que por razones de cambio de tarifas,reformas legales,caso fortuito o fuerza mayor se vea en la obligación de suspender el servicio. No obstante lo anterior,MEGADATOS se compromete a informar inmediatamente de este hecho al ABONADO. 5.2.- En caso de que se presente transmisión de virus a través de las redes. 5.3.- El ABONADO recibirá los servicios contratados de forma continua, regular, eficiente, con calidad y eficacia, salvo que sea detectado su mal uso, su falta de pago del ABONADO, (aplicará al día siguiente de cumplida la fecha máxima de pago), por caso fortuito, por uso indebido de los servicios contratados o uso ilegal y en forma diferente al paquete contratado, comercialización, subarrendamiento, por mandato judicial y por las demás causas previstas en el ordenamiento jurídico vigente lo cual provocará que MEGADATOS suspenda sus servicios. 5.4.- Por daños que  llegaran a producirse en los equipos como consecuencia de la utilización de los equipos o del servicio contratado sin contemplar las condiciones de operación. 5.5.- En caso de Incumplimiento por parte del ABONADO,de las condiciones contractuales y sus obligaciones establecidas en la Ley Orgánica de Defensa del Consumidor y otras leyes aplicables vigentes. EL ABONADO declara que acepta desde ya todas y cada una de las modificaciones que MEGADATOS se vea obligado a efectuar a las condiciones pactadas en el presente Contrato que se deriven de reformas a la normativa al momento de suscripción del mismo. Tales modificaciones no se entenderán como terminación anticipada del contrato ni generarán responsabilidad alguna para MEGADATOS. 5.6.- MEGADATOS no podrá bloquear,priorizar,restringir o discriminar de modo arbitrario y unilateral aplicaciones,contenidos o servicios sin consentimiento del ABONADO o por orden expresa de la autoridad competente. Del mismo modo podrá ofrecer,si el ABONADO lo solicita,servicio de control y bloqueo de contenidos que atenten contra la ley,la moral o las buenas costumbres,para lo cual informará oportunamente al ABONADO cual es el alcance de la tarifa o precio y modo de funcionamiento de estos. 5.7.- Las condiciones de la prestación de los servicios contratados se sujetarán a las leyes,reglamentos,resoluciones,regulaciones,decretos y toda decisión de carácter general de cualquier institución del Estado existente o que se dictaren durante el plazo de ejecución del título habilitante que no se encuentren especificadas en la Legislación Aplicable.
                  <br/>
                SEXTA.- DERECHOS DEL ABONADO: 6.1 Recibir el servicio de acceso a las redes nacionales e internacionales de Internet según las disposiciones previstas en la ley y en el presente contrato. 6.2.- Solicitar soporte técnico según las condiciones establecidas en la ley y el presente contrato en caso de ser requerido. 6.3.- Recibir todos los derechos adquiridos según la ley orgánica de las telecomunicaciones,el reglamento general,el reglamento de prestación de servicios de valor agregado y la Ley de defensa del consumidor. 6.4.- Recibir compensaciones por parte del proveedor según lo dispuesto por el organismo de control,como notas de crédito en todos los casos por el servicio no provisto según las condiciones contractuales. 6.5.- Los nuevos derechos y beneficios para el ABONADO que se establezcan a futuro se incorporarán de manera automática al presente contrato por disposición del ARCOTEL.
                <br/>SEPTIMA.- PRECIO Y FORMA DE PAGO: El precio de los servicios contratados por EL ABONADO y los impuestos constan descritos en el anverso de este Contrato, el cual puede ser cancelado en dinero en efectivo, depósito, transferencia mediante botón de pago, débito, tarjeta de crédito u otras que implemente o facilite MEGADATOS, de acuerdo a los términos de contratación. En caso de que EL ABONADO incurra en mora de uno o más pagos,MEGADATOS se reserva el derecho de suspender el servicio y dar por terminado el mismo sin notificación o requerimiento alguno; sin perjuicio de las acciones legales que el incumplimiento de esta obligación diera lugar. En caso de mora MEGADATOS aplicará la máxima tasa de interés permitida por la ley por el periodo en mora. Para el caso de que se contrate servicios adicionales y suplementarios con costo,el ABONADO se compromete a firmar una adenda verbal grabada,electrónica con firma digital o física al presente contrato,de igual manera cuando se desuscriba de los mismos.
                <br/>
                OCTAVA.- PRIVACIDAD Y TRATAMIENTO DE INFORMACIÓN: MEGADATOS garantizará la privacidad y confidencialidad de la información del ABONADO y sólo la utilizará para brindar el servicio contratado por el ABONADO,por lo que el ABONADO conoce y
                {{isOctava}}    
                 autoriza que MEGADATOS pueda proporcionar a terceros datos necesarios para poder realizar la entrega de estado de cuenta,facturación,recordatorios de fechas de pago o montos de pago,fidelización,información de nuevos servicios,información de promociones especiales,entre otros; así mismo también autoriza a hacer uso de esta información para fines comerciales o de brindar beneficios al ABONADO a través de alianzas desarrolladas. Adicionalmente EL ABONADO acepta expresamente que MEGADATOS puede utilizar medios electrónicos y llamadas para: 8.1.- Notificar cambios relacionados con los términos y condiciones del presente CONTRATO, 8.2.- Realizar gestiones de cobtranzas y demás promociones aplicables de acuerdo a la normativa vigente. Sin embargo de lo anterior,MEGADATOS podrá entregar los datos del ABONADO en caso de requerimientos realizados por autoridad competente conforme al ordenamiento jurídico vigente y particularmente de la Agencia de Regulación y Control de las Telecomunciaciones para el cumplimiento de sus funciones.
                <br/>
                NOVENA.- FACTURACIÓN: MEGADATOS facturará y cobrará al ABONADO el servicio contratado en forma mensual basado en el ciclo de facturación en que haya sido definido.  Para ejecutar cancelaciones de servicio o downgrades,el ABONADO deberá notificar con 15 días de anticipación a la fecha de finalización de su ciclo de facturación. El primer pago constará del valor de instalación y el valor proporcional del primer período de consumo correspondiente. MEGADATOS entregará a sus ABONADOS las facturas de conformidad con la ley,sin embargo la no recepción de dicho documento no exime al ABONADO del pago correspondiente. El ABONADO cancelará por periodos mensuales a MEGADATOS por la prestación del servicio contratado a los precios pactados a través de éste instrumento y sus anexo(servicios adicionales),hasta el fin del período; si el ABONADO no cancelare los valores facturados dentro del plazo previsto,MEGADATOS suspenderá de forma automática los servicios en cualquier momento a partir del vencimiento de dicho plazo. El ABONADO podrá pedir la reactivación del servicio en un máximo de 30 días posteriores a la suspensión,previo al pago de los valores adeudados,caso contrario el servicio será dado por cancelado. El tiempo de reactivación del servicio es de 24 horas después de que el ABONADO haya pagado los valores pendientes y haya hecho el pedido de reactivación.
                <br/>DECIMA.- VIGENCIA: El plazo de duración del presente Contrato es de 36 meses y tendrá vigencia desde la fecha de instalación y activación del servicio que se indicará en la facturación mensual, en el cual
                {{isDecima}} 
                se renovará automáticamente en períodos iguales y sucesivos, mientras las partes no soliciten una terminación del mismo, se podrá realizar una revisión periodica de tarifas en función de condiciones de mercado y de mutuo acuerdo. El operador respetará las condiciones establecidas en la ley orgánica de defensa del consumidor para la prestación de los servicios entre las partes.
                <br/>
                DÉCIMO PRIMERA.- TERMINACIÓN DEL CONTRATO: Para el caso de terminación del contrato, el ABONADO se compromete a cancelar los valores adeudados a MEGADATOS y a entregar los equipos de propiedad de MEGADATOS en las oficinas de MEGADATOS habilitados para este propósito que se indican en la sección de atención al cliente de la página web www.netlife.ec, en perfectas condiciones, salvo por deterioros normales causados por el uso diligente. Sin perjuicio de lo anterior, son causales de terminación anticipada del presente instrumento,las siguientes: 11.1.- Aplicación de las normas legales,el caso fortuito o fuerza mayor que obliguen a MEGADATOS a suspender definitivamente el servicio. 11.2.- La suspensión definitiva de servicios prestados por los proveedores de MEGADATOS. 11.3.- Incumplimiento de Ias obligaciones contractuales de las partes,no pago del servicio o mal uso del servicio derivadas del presente Contrato,incluyendo la manipulación o retiro de equipos provistos por MEGADATOS,y todas las mencionadas en el presente contrato en el literal condiciones. 11.4.- En caso de que el servicio se esté utilizando en un Cyber o ISP,bastando para la terminación un informe/reporte generado por MEGADATOS que confirme esto,sin eximir del pago de todos los valores que se adeuden,entregar los equipos que proveen del servicio o su valor en efectivo y cumplir las condiciones de permanencia mínima. 11.5.- Por acuerdo mutuo. 11.6.- Por decisión unilateral de acuerdo a la ley de defensa del consumidor,sin que hayan multas o recargos para ello.
                Para el caso puntual de promociones, el ABONADO
                {{isDecimoPrimera}}   
                desea acceder a las promociones que consideran un plazo mínimo de permanencia es de 36 meses para hacerlas efectivas y permanecer vigentes y acceder a los promocionales de MEGADATOS, en tal virtud, en caso de una terminación anticipada del contrato, el ABONADO dejará de beneficiarse de dicho descuento, promoción o costo de instalación,y por lo tanto se le aplicarán las tarifas regulares por los servicios e instalación contratados prorrateados en función del tiempo de permanencia. Para tal efecto en la última factura emitida al ABONADO, se reflejará la respectiva reliquidación de valores del servicio contratado en base al valor real del mismo.
                <br/>
                DÉCIMO SEGUNDA.- DECLARACIÓN FUNDAMENTAL: El ABONADO declara que ha obtenido de forma oportuna por parte de MEGADATOS,toda la información veraz y completa del servicio contratado. Así mismo declara que conoce íntegramente el presente contrato en su anverso y reverso y que lo acepta en todas sus partes por convenir a sus intereses.
                <br/>
                DéCIMA TERCERA.- CESIóN: EL ABONADO acepta desde ya cualquier cesión parcial o total que realice MEGADATOS de los derechos y/u obligaciones contenidos en este Contrato. El ABONADO puede ceder el presente contrato previo a realizar el trámite correspondiente de cesión de derechos en los canales de atención al ABONADO de NETLIFE.
                <br/>DéCIMO CUARTA.- ACUERDO TOTAL: El presente Contrato Contiene los acuerdos totales de las partes y deja sin efecto cualquier negociación,entendimiento,contrato o convenio que haya existido previamente entre el ABONADO y MEGADATOS,el presente instrumento incluye todas las condiciones a las que se compromete la empresa y el alcance único de sus servicios y deja sin efecto cualquier información adicional recibida que no conste en el mismo. Si el ABONADO desea contratar servicios adicionales, éstos serán agregados al presente contrato.
                <br/>
                DÉCIMO QUINTA.- CONTROVERSIAS: Las controversias o diferencias que surjan entre las partes con ocasión de la firma, ejecución, interpretación, prórroga o terminación del Contrato, así como de cualquier otro asunto relacionado con el presente Contrato, serán sometidas a la revisión de las partes para buscar un arreglo directo, en término no mayor a CINCO(5) días hábiles a partir de la fecha en que cualquiera de las partes comunique por escrito a la otra parte la existencia de una diferencia y la explique someramente. Si no se resolviere de esta manera, tratarán de solucionarlo con la asistencia de un mediador de la Cámara de Comercio de Quito; en caso de que no pueda ser solucionada en mediación  las partes
                {{isDecimoQuinta}}
                , según sus intereses podrán someterse a la Justicia Ordinaria y/o a través de un Tribunal de Arbitraje de la Cámara de Comercio de Quito, el mismo que se sujetará a lo dispuesto en la Ley de Arbitraje y Mediación, y demás normativas y preceptos.
                <br/>
                DÉCIMO SEXTA.- NOTIFICACIONES: Toda y cualquier notificación que requiera realizarse en relación con el presente Contrato,se hará por escrito a las siguientes direcciones: Uno.- MEGADATOS: Quito: Av. Núñez de Vela E3-13 y Atahualpa, Edificio torre del Puente Piso 3, Guayaquil: Av. Rodrigo Chávez Parque Empresarial Colon Edif. Coloncorp locales 4 y 5 P.B, ó en la dirección de correo electrónico info@netlife.ec</span> 14.2.- ABONADO en la dirección indicada en el anverso del presente contrato o en su dirección de correo electrónico.
                De presentarse cambios en las direcciones enunciadas,la parte respectiva dará aviso escrito de tal hecho a la otra,dentro de las 24 horas de producido el cambio. Para constancia de todo lo expuesto y convenido,las partes suscriben el presente contrato,en la ciudad y fecha indicada en el anverso del presente contrato,en tres ejemplares de igual tasa y valor.
                </div>

        <!-- ========================================== -->
        <!-- Firma del Cliente  -->
        <!-- ========================================== -->
        <br/>
			      ');
	DBMS_LOB.APPEND(bada, '             
        <div style="clear: both;"></div>
        <div id="contenedor" class="col-width-100">
            <div id="row">
                <div id="colCell" class="col-width-50" style="text-align:center $!fontSize">
                        <div id="contenedor" class="col-width-100">
                            <div id="row" >
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50" style="height:35px">
                                </div>
                                <div id="colCell" class="col-width-25"></div>
                            </div>
                            <div id="row">
                                <div id="colCell" class="col-width-60">
                                    <div id="contenedor" class="col-width-100"> 
                                         <div id="row" style="display: flex;">
                                            <div class="col-width-40"></div>
                                        </div>
                                         <div id="row" style="display: flex;">              
                                            <div  class="col-width-100" style="text-align: center;">
                                               <hr> <span>MEGADATOS</span>
                                            </div>
                                           <div id="colCell" class="col-width-30">
                                              <form>
                                                 <input id="inputfirma1" name="FIRMA_CONT_MD_FINAL_EMPRESA" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>
                                              </form>
                                            </div>
                                        </div>
                                    </div>                                 
                                </div>
                                <div id="colCell" class="col-width-30"></div>
                            </div>
                        </div>
                </div>
                <div id="colCell" class="col-width-70" style="text-align:center $!fontSize">
                        <div id="contenedor" class="col-width-100">
                            <div id="row" >
                                <div id="colCell" class="col-width-40"></div>
                                <div id="colCell" class="col-width-50" style="height:35px"> </div>
                                <div id="colCell" class="col-width-40"></div>
                            </div>
                            <div id="row">
                                <div id="colCell" class="col-width-100">
                                    <div id="contenedor" class="col-width-100"> 
                                         <div id="row" style="display: flex;">
                                            <div class="col-width-40"></div>
                                        </div>
                                         <div id="row" style="display: flex;">   
                                               <div class="col-width-40"></div>
                                           <div id="colCell" class="col-width-30">
                                              <form>
                                                 <input id="inputfirma1" name="FIRMA_CONT_MD_FINAL_CLIENTE" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>
                                              </form>
                                            </div>
                                            <div  class="col-width-90" style="text-align: center;">
                                               <hr> <span>Firma del Cliente</span>
                                            </div>
                                        </div>
                                    </div>                                 
                                </div>
                                <div id="colCell" class="col-width-30"></div>
                            </div>
                        </div>

                </div>
            </div>
        </div>
                    <div id="contenedor" style="float:right">
                        <div id="row">
                            <div id="col" class="col-width-100" style="text-align:center;$!fontSize">
                                FO-VEN-01
                            </div>
                        </div>
                        <div id="row">
                            <div  class="col-width-100" style="padding-right: 5px;text-align:center; $!fontSize">
                                ver-09 | Abril-2020
                            </div>
                        </div>
                    </div>

        <!-- ============================== -->
        <!--      Servicios Contratados     -->
        <!-- ============================== -->
				                
        <br/><br/><br/>
        <div class="labelBlock">DOCUMENTOS QUE DEBEN ADJUNTARSE</div>
        <br/>
        <div id="contenedor" class="col-width-100" style="text-align: justify;">
            <div id="row">
                <div id="colCell" class="col-width-55">
                    <div> <b>Personas Naturales: </b> </div>
                    <div  class="clausulas clausulasFont" >
                        <ul>
                            <li>Copia de Cédula de Identidad o pasaporte</li>
                            <li>Copia de encabezado de estado de cuenta (Corriente/Ahorro/TC) en caso de hacer débito automático.</li>
                            <li>Copia de la calificación de discapacidad emitida por el CONADIS, que determine el tipo y porcentaje de discapacidad igual o mayor al 30%. (Si aplica)</li>
                            <li>En caso de discapacidad, factura original de un servicio básico que demuestre la residencia del solicitante para acceder al servicio.</li>
                        </ul>
                    </div>
                </div>
                <div id="colCell" class="col-width-5"></div>
                <div id="colCell" class="col-width-30">
                    <div> <b>Personas Jurídicas: </b> </div>
                    <div  class="clausulas clausulasFont" >
                        <ul>
                            <li>Copia del RUC</li>
                            <li>Copia de encabezado de estado de cuenta (Corriente/Ahorro/TC) en caso de hacer débito automático.</li>
                            <li>Copia de cédula o pasaporte de representante legal.</li>
                            <li>Nombramiento de representante legal (inscrito en registro mercantil)</li>
                        </ul>
                    </div>
                </div>
                <br/>
            </div>
        </div>

        <!-- ========================================== -->
        <!-- Forma de pago e informacion de credito -->
        <!-- ========================================== -->
        <div style="clear: both;"></div><br/>
        <div class="labelBlock">FORMA DE PAGO E INFORMACIÓN DE CRÉDITO</div>
        <div id="contenedor" class="col-width-100">
            <div id="row">
                <div id="col" class="col-width-5"></div>
                <div id="col" class="col-width-25">
                    <div class="box-label" style="$!fontSize">Tarjeta de Crédito</div>
                    <div class="box">$isTarjetaCredito</div>
                </div>
                <div id="col" class="col-width-20">
                    <div class="box-label" style="$!fontSize">Cuenta Corriente</div>
                    <div class="box">$isCuentaCorriente</div>
                </div>
                <div id="col" class="col-width-25">
                    <div class="box-label" style="$!fontSize">Cuenta de Ahorros</div>
                    <div class="box">$isCuentaAhorros</div>
                </div>
                <div id="col" class="col-width-20">
                    <div class="box-label" style="$!fontSize">Efectivo</div>
                    <div class="box">$isEfectivo</div>
                </div>
            </div>
             <br/>
			 		     
        </div>
        <br/>
        <br/>
        <div style="text-align: justify;">
            <span>El cliente declara haber leído este contrato y la solicitud de prestación de servicios en su totalidad y declara que esta conforme con todas y cada una de sus cláusulas. El cliente declara que la información suministrada a MEGADATOS es veráz y correcta. Adicionalmente autoriza a MEGADATOS a verificarla. El cliente autoriza a MEGADATOS expresamente a entregar y requerir información,en forma directa,a los buros de información crediticia o entidades designadas para estas calificaciones sobre su comportamiento y capacidad de pago,su desempeño como deudor,para valorar su riesgo futuro.
            </span>
        </div>
 
        <!-- ========================================== -->
        <!-- Firma del Cliente  -->
        <!-- ========================================== -->
        <div style="clear: both;"></div>
        <div id="contenedor" class="col-width-100">
            <div id="row">
                <div id="colCell"  style="text-align:center;width:50%;">
                  
                        <div id="contenedor" class="col-width-100">
                            <div id="row">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50" style="height:35px">
                                </div>
                                <div id="colCell" class="col-width-15"></div>
                            </div>
                            <div id="row">
                                <div id="colCell" class="col-width-20"></div> 
                                 <div id="colCell" class="col-width-70"></div>
                                 <div id="colCell" class="col-width-10"> </div>                                
                            </div>
                             <div id="row" style="display: flex;">
                                 
                               <div id="colCell" class="col-width-60">
                                    <div id="contenedor" class="col-width-100"> 
                                         <div id="row" style="display: flex;">
                                            <div class="col-width-40"></div>
                                        </div>
                                         <div id="row" style="display: flex;"> 
                                             <div id="colCell" class="col-width-40">
                                                  <input id="inputfirma1" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>
                                            </div>
                                            <div id="colCell" class="col-width-90">
                                                <hr> <span>Firma del Cliente</span>
                                            </div>
                                            <div id="colCell" class="col-width-10" style="text-align: center;">
                                                <div id="colCell" class="col-width-5">
                                                  <input id="inputfirma1" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>
                                                </div>
                                                <div id="contenedor" class="col-width-100"> 
                                                    <div id="row" style="display: flex;">
                                                         <form>
                                                           <input id="inputfirma1" name="FIRMA_CONT_MD_FORMA_PAGO" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>                                 
                                </div>                           
                            </div>
                        </div>
                     
                </div>
                <div id="colCell" style="width:50%">
                    <div id="contenedor" class="col-width-100">
                        <div id="row" >
                            <div id="col" class="col-width-20">Nombre:</div>
                            <div id="col" class="col-width-65 labelGris">
                                <span class="textPadding">$nombresApellidos</span>
                            </div>
                            <div id="col" class="col-width-15"></div>
                        </div>
                        <div id="row" >
                            <div id="col" class="col-width-20">CI/RUC:</div>
                            <div id="col" class="col-width-65 labelGris">
                                <span class="textPadding">$identificacion</span>
                            </div>
                            <div id="col" class="col-width-15"></div>
                        </div>
                    </div>
                </div>
         </div>
    </body>
</html>

');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'contratoMegadatos';

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'contratoMegadatos';

COMMIT;
END;
/