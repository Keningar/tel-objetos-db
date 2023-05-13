/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de plantilla Autorización para Débito
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 09-05-2023 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:='<!DOCTYPE html>';
BEGIN
DBMS_LOB.APPEND(bada, ' 
 <!DOCTYPE html><!DOCTYPE html> 
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
                 padding: 0px;
                 border-spacing: 2px;
             }
             #row {
                 display: table-row;
                 vertical-align: middle;
             }

             #col {
                 display: table-cell;
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
             .line{

                 width: 28px;
                 border-bottom: 2px solid black;
                 display:inline-block;
                 border-radius: 2px;
                 vertical-align: top;
                 text-align: center;
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
                 font-size: 10px;
             }

             .clausulasFont li {
                 padding-left: 16px;
                 font-size: 10px;
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
             .col-width-6{
                 width: 6% !important;
             }
             .col-width-7{
                 width: 7% !important;
             }
  
             .col-width-8{
                 width: 8% !important;
             }
             .col-width-9{
                 width: 9% !important;
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
                var query_strings_from_url = document.location.search.substring(1).split("'||chr(38)||'");
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

        </script>');
        DBMS_LOB.APPEND(bada, ' 
     </head><body style="$!fontSize" onload="substitutePdfVariables()">
        <!-- ================================= -->
         <!-- Logo Netlife y numero de contrato -->
         <!-- ================================= -->
       <br/><br/><br/> 
       <div id="contenedor" class="col-width-100" style="border:1px; $!fontSize">
         <table class="col-width-100">         
           <tr>     
             <td class="col-width-75" style="$!fontSize"><strong>CONTRATO DE ADHESIÓN PARA LA PRESTACIÓN DEL SERVICIO</strong></td> 
             <td id="netlife" class="col-width-25" text-align="right" rowspan="4">
               <div class="col-width-100" style="margin-left: 3.88rem; margin-top:-0.50rem;">
               <img src="http://images.telconet.net/others/telcos/logo_netlife.png" alt="log" title="NETLIFE" height="40"/>
               <div style="font-size:14px">Telf 3920000</div>
               <div style="font-size:20px"><strong>$!numeroAdendum</strong></div>
               </div>
             </td>
           </tr>
           <tr >
             <td class="col-width-75">
             <div id="row">
                <div id="col" class="col-width-30 ">
                    <strong>CONTRATO: </strong>
                </div>
                <div id="col" class="col-width-30 ">
                    <div class="box-label"><strong>NUEVO</strong></div>
                    <div class="line">$!isNuevo</div>

                </div>
                <div id="col" class="col-width-30 ">
                    <div class="box-label"><strong>EXISTENTE</strong></div>
                    <div class="line">$!isExistente</div>
                </div>
            </div>
             </td>
           </tr>
           <tr>
            <td class="col-width-75" >
            <div id="row">
                <div id="col" class="col-width-10 ">
                    <strong>FECHA(aa-mm-dd): </strong>
                </div>
                <div id="col" class="col-width-30 ">
                    <span class="line">$!anioActual</span>/<span class="line">$!mesActual</span>/<span class="line">$!diaActual</span>

                </div>

            </div>
            </td>
          </tr>
          <tr>
            <td>
            <div id="row" style="min-height: 2em;">
                <div id="col" class="col-width-30">
                    <strong>TIPO DE CLIENTE:</strong>
                </div>
                <div id="col" class="col-width-30">
                    <div class="box-label"><strong>NATURAL</strong></div>
                    <div class="line">$!isNatural</div>

                </div>
                <div id="col" class="col-width-30">
                    <div class="box-label"><strong>JURIDICA</strong></div>
                    <div class="line">$!isJuridico</div>
                </div>
            </div>
            </td>
          </tr>

         </table>
       </div><br/>
        <div style="clear: both;"></div>
<!-- ========================================================= -->
         <!--        Datos de Adhesión de prestación de servicios       -->
         <!-- ========================================================= -->
         <div style="clear: both;"></div>

         <div style="text-align: justify; $!fontSize">
             <span>

                    <strong>PRIMERA:</strong> ANTECEDENTES.- En la ciudad de <span style="text-decoration: underline"> $!ciudadServicio </span> a los <span style="text-decoration: underline"> $!diaActual </span> del mes de <span style="text-decoration: underline"> $!mesActual </span> 
                     del <span style="text-decoration: underline"> $!anioActual </span>
                    celebran el presente Contrato de Adhesión de Prestación de Servicios de Acceso a Internet; 1) por una
                    parte NETLIFE (MEGADATOS S.A.), compañía constituida bajo las leyes de la República del Ecuador, cuyo objeto
                    social constituye entre otros, las prestación de servicios de telecomunicaciones. Mediante resolución ARCOTEL-
                    2020-0338 de 31 de julio de 2020, se inscribió la renovación del título habilitante para la prestación del servicio de
                    acceso a Internet, en el Tomo 143 a Foja 14363 del Registro Público de Telecomunicaciones, cuyo nombre
                    Comercial es NETLIFE, en adelante denominado simplemente NETLIFE, ubicada en la calle Blasco Núñez de Vela
                    E3-13 y Atahualpa- Edificio Torre del Puente, en la provincia de Pichincha, cantón Distrito Metropolitano de Quito,
                    ciudad de Quito, Parroquia Iñaquito, Teléfono: 02-3920000 , RUC: 1791287541001, mail: info@netlife.net.ec, web:
                    www.netlife.ec 2) por otra parte el ABONADO, consciente expresamente en proporcionar sus datos personales a
                    favor de NETLIFE para la prestación de este servicio que se detallan a continuación:

             </span>
             ');
        DBMS_LOB.APPEND(bada, ' 
         </div><!-- ============================== -->
         <!--        Datos del Cliente       -->
         <!-- ============================== -->
         <div style="clear: both;"></div>
         <div class="labelBlock">DATOS DEL ABONADO/SUSCRIPTOR</div>
         <div id="contenedor" class="col-width-100" 
         style="margin-block-end: 1em !important;">
             <div id="row">
                 <div id="col" class="col-width-20"><strong>Nombre Completos:</strong></div>
                 <div id="col" class="col-width-45 labelGris">
                     $!nombresApellidos
                     <span class="textPadding"></span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5"><strong>CC:</strong></div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">
                     $!identificacion
                     </span>
                 </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             </div><div id="row">
                 <div id="col" class="col-width-12"><strong>Nacionalidad:</strong></div>
                 <div id="col" class="col-width-7 labelGris">
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
                 <div id="col" class="col-width-15" style="text-align : center; padding-right: 1px;"><strong>Estado Civil:</strong></div>
                 <div id="col" class="col-width-12 labelGris">
                     <span class="textPadding">$!estadoCivil</span>
                 </div>
                 <div id="col" class="col-width-7" style="text-align : left; padding-right: 1px;"><strong>Sexo/Género:</strong></div>
                 <div id="col" class="col-width-6" style="text-align : right; padding-right: 1px;"><strong>M</strong></div>
                 <div class="box">$!isMasculino</div>
                 <div id="col" class="col-width-6" style="text-align : right; padding-right: 1px;"><strong>F</strong></div>
                 <div class="box">$!isFemenino</div>
                 <div id="col" class="col-width-6" style="text-align : right; padding-right: 1px;"><strong>Otro</strong></div>
                 <div class="box">$!isOtro</div>
             </div>
      </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-84"><strong>¿El abonado es discapacitado? (en caso de afirmativo, suscribir formulario adicional para tarifa preferencial):</strong></div>
                 <div id="col" class="col-width-8" style="text-align : right; padding-right: 1px;"><strong>Si</strong></div>
                 <div class="box">$!isDiscapacitadoSi</div>
                 <div id="col" class="col-width-8" style="text-align : right; padding-right: 1px;"><strong>No</strong></div>
                 <div class="box">$!isDiscapacitadoNo</div>

             </div>
        </div>
        <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-84"><strong>¿El abonado es adulto mayor? (en caso de afirmativo, suscribir formulario adicional para tarifa preferencial):</strong></div>
                 <div id="col" class="col-width-8" style="text-align : right; padding-right: 1px;"><strong>Si</strong></div>
                 <div class="box">$!isAdultoMayorSi</div>
                 <div id="col" class="col-width-8" style="text-align : right; padding-right: 1px;"><strong>No</strong></div>
                 <div class="box">$!isAdultoMayorNo</div>

             </div>
        </div>
        ');
        DBMS_LOB.APPEND(bada, ' 
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-15"><strong>Razon Social:</strong></div>
                 <div id="col" class="col-width-46 labelGris">
                     <span class="textPadding">$!razonSocial</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5"><strong>RUC:</strong></div>
                 <div id="col" class="col-width-25 labelGris">
                     <span class="textPadding">$!ruc</span>
                 </div>
             </div>
        </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-20"><strong>Representante Legal:</strong></div>
                 <div id="col" class="col-width-41 labelGris">
                     <span class="textPadding">$!representanteLegal</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-5"><strong>CC:</strong></div>
                 <div id="col" class="col-width-25 labelGris">
                     <span class="textPadding">$!ciRepresentanteLegal</span>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-5"><strong>Origen Ingresos:</strong></div>
                 <div id="col" class="col-width-23 labelGris">
                     <span class="textPadding">$!origenIngresos</span>
                 </div>
             </div>
         </div><!-- ======================================== -->
         <!--        Datos del Cliente - Ubicacion     -->
         <!-- ======================================== -->        
         <div style="clear: both;"></div>
         <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-100" style="font-style: oblique; padding-top: 5px;">Formato: Calle Principal,Numeración,Calle Secundaria,Nombre Edficio o Conjunto,Piso,Numero
                 de Departamento o Casa</div>
             </div>
        </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" style="width:20%">
                     <strong>Dirección: </strong>
                     </div>
                 <div id="col" style="width:74%" class="labelGris">
                     <span class="textPadding">$direccion</span>
                 </div>
             </div>
        </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                <div id="col" class="col-width-10"> <strong>Referencia: </strong> </div>
                <div id="col" class="col-width-50 labelGris">
                    <span class="textPadding">$!referenciaServicio</span>
                </div>
                <div id="col" class="col-width-3" style="width: 5.7% !important;"></div>
                <div id="col" class="col-width-18"><strong>Coordenada Latitud:</strong></div>
                <div id="col" class="col-width-15 ">
                        <div id="col" class="labelGris">
                                 <span class="textPadding">$latitud</span>
                          </div>   

                </div>
            </div>
        </div>
');
        DBMS_LOB.APPEND(bada, ' 
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-10"> <strong>Provincia: </strong> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$provincia</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Ciudad: </strong> </div>
                 <div id="col" class="col-width-16 labelGris">
                     <span class="textPadding">$ciudad</span>
                 </div><div id="col" class="col-width-3" ></div>
                 <div id="col" class="col-width-18"> <strong>Coordenada Longitud: </strong> </div>
                 <div id="col" class="col-width-15 labelGris">
                     <span class="textPadding">$longuitud</span>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-10"> <strong>Cantón: </strong> </div>
                 <div id="col" class="col-width-17 " >
                     <div id="col" class="labelGris" >
                         <span class="textPadding">$canton</span>
                        </div>  

                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10" style="max-height: 1em;"> <strong>Parroquia: </strong> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$parroquia</span>
                 </div>
                 <div id="col" class="col-width-3" style="width: 4.7% !important;"></div>
                 <div id="col" class="col-width-15" style="max-height: 1em;"><strong>Sector/Barrio:</strong> </div>
                 <div id="col" class="col-width-18 ">
                     <div id="col" class="labelGris">
                          <span class="textPadding">$sector</span>
                      </div>

                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-53">
                     <div class="box-label">Casa</div>
                     <div class="box">$isCasa</div>

                     <div class="box-label">Edificio</div>
                     <div class="box">$isEdificio</div>

                     <div class="box-label">Conjunto</div>
                     <div class="box">$isConjunto</div>
                 </div>
                 <div id="col" class="col-width-5" ></div>
                 <div id="col" class="col-width-10"> <strong>Correo: </strong> </div>
                 <div id="col" class="col-width-27 ">
                         <div id="col" class="labelGris">
                                <span class="textPadding">$correoCliente</span>
                         </div>    

                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-19"> <strong>Teléfono: </strong> </div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">$telefonoCliente</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Celular: </strong> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$celularCliente</span>
                 </div>
             </div>
             <div id="row">
                 <div id="col" class="col-width-19"> <strong>Nombre de Referencia Familiar: </strong> </div>
                 <div id="col" class="col-width-35 ">
                     <div id="col" class=" labelGris">
                          <span class="textPadding">$refFamiliar1</span>
                        </div>   

                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Teléfono: </strong> </div>
                 <div id="col" class="col-width-27">
                     <div class="labelGris" style="max-height: 2px;">
                     <span class="textPadding">$telefonoFamiliar1</span>
                     </div>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-19"> <strong>Nombre de Referencia 2: </strong> </div>
                 <div id="col" class="col-width-35 ">
                     <div id="col" class=" labelGris">
                            <span class="textPadding">$refFamiliar2</span>
                      </div>   

                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Teléfono: </strong> </div>
                 <div id="col" class="col-width-27 labelGris" style="max-height: 0.5em;">
                     <span class="textPadding">$telefonoFamiliar2</span>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-19"> <strong>Nombre de Vendedor: </strong> </div>
                 <div id="col" class="col-width-35 labelGris">
                     <span class="textPadding">$nombreVendedor</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Código: </strong> </div>
                 <div id="col" class="col-width-27 labelGris">
                     <span class="textPadding">$codigoVendedor</span>
                 </div>
             </div>
         </div>
         <br/>

');
        DBMS_LOB.APPEND(bada, ' 
         <div style="$!fontSize">
             <span>
                 <strong>SEGUNDA.-</strong> OBJETO: NETLIFE se compromete a proporcionar al ABONADO el acceso a redes nacionales e
                  internacionales de Internet. Se deja expresa constancia que, NETLIFE se responsabiliza única y exclusivamente
                  del acceso a las redes de Internet, por éste motivo no resulta de su responsabilidad el contenido o la información
                  a la que pueda accederse, ni el almacenamiento de la misma. Las características del servicio objeto de este
                  contrato, así como las características mínimas que requiere el equipo y otros que deben ser garantizados por el
                  ABONADO constan en el anverso de este contrato.
             </span>
         </div> <!-- ======================================== -->
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
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-100" style="font-style: oblique; padding-top: 5px;">Formato: Calle Principal,Numeración,Calle Secundaria,Nombre Edficio o Conjunto,Piso,Numero
                 de Departamento o Casa</div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" style="width:30%">
                     <strong>Dirección estado de cuenta: </strong>
                     </div>
                 <div id="col" style="width:75%" class="labelGris">
                     <span class="textPadding">$!direccionServicio</span>
                 </div>
             </div>
             <div id="row">
                <div id="col" class="col-width-6"> <strong>Referencia: </strong> </div>
                <div id="col" class="col-width-49 labelGris">
                    <span class="textPadding">$!referenciaServicio</span>
                </div>
                <div id="col" class="col-width-5"></div>
                <div id="col" class="col-width-20"> <strong>Coordenada Latitud: </strong> </div>
                <div id="col" class="col-width-15">
                        <div id="col" class="labelGris">
                                 <span class="textPadding">$!latitudServicio</span>
                          </div>   

                </div>
            </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-10"> <strong>Ciudad: </strong> </div>
                 <div id="col" class="col-width-17 labelGris">
                     <span class="textPadding">$!ciudadServicio</span>
                 </div>
                 <div id="col" class="col-width-5" style="width: 5.5% !important;"></div>
                 <div id="col" class="col-width-9"> <strong>Canton: </strong> </div>
                 <div id="col" class="col-width-20 labelGris">
                     <span class="textPadding">$!cantonServicio</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-18"> <strong>Coordenada Longitud: </strong> </div>
                 <div id="col" class="col-width-15">
                     <div id="col" class="labelGris">
                       <span class="textPadding">$!longuitudServicio</span>
                    </div> 
                 </div>
             </div>
    </div>
');
        DBMS_LOB.APPEND(bada, ' 
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-10"> <strong>Parroquia: </strong> </div>
                 <div id="col" class="col-width-28 labelGris">
                     <span class="textPadding">$!parroquiaServicio</span>
                 </div>
                 <div id="col" class="col-width-25"></div>
                 <div id="col" class="col-width-15"><strong>Sector/Barrio: </strong> </div>
                 <div id="col" class="col-width-19 labelGris">
                     <span class="textPadding">$!sectorServicio</span>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-53">
                     <div class="box-label">Casa</div>
                     <div class="box">$!casaServicio</div>

                     <div class="box-label">Edifcio</div>
                     <div class="box">$!edificioServicio</div>

                     <div class="box-label">Conjunto</div>
                     <div class="box">$!conjuntoServicio</div>
                 </div>
                 <div id="col" class="col-width-5" style="width: 0.1% !important;"></div>
                 <div id="col" class="col-width-10"> <strong>Correo: </strong> </div>
                 <div id="col" class="col-width-24">
                     <div id="col" class="labelGris">
                        <span class="textPadding">$!correoContacto</span>
                     </div>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-15"> <strong>Teléfono: </strong> </div>
                 <div id="col" class="col-width-43 labelGris">
                     <span class="textPadding">$!telefonoContacto</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Celular: </strong> </div>
                 <div id="col" class="col-width-24 labelGris">
                     <span class="textPadding">$!celularContacto</span>
                 </div>
             </div>
    </div>
     <div id="contenedor" class="col-width-100" >
             <div id="row">
                 <div id="col" class="col-width-15"> <strong>Persona a contactar: </strong> </div>
                 <div id="col" class="col-width-43 labelGris">
                     <span class="textPadding">$!personaContacto</span>
                 </div>
                 <div id="col" class="col-width-5"></div>
                 <div id="col" class="col-width-10"> <strong>Horario: </strong> </div>
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
         <br/>
         <br/>
          <br/>
          <br/>
          <br/>
          <br/>
');
        DBMS_LOB.APPEND(bada, ' 
         <!-- ============================== -->
        <!--      Servicios Contratados     -->
        <!-- ============================== -->
        <div style="clear: both;"><br/></div>
        <div style="clear: both;"><br/></div>
        <div style="clear: both;"><br/></div>
        <div  style="margin-block-end: 13px !important;" class="labelBlock">SERVICIO CONTRATADO</div>
        <div style="width:38%; float:left; vertical-align:top;" >
            <div class="labelBlock textCenter" style="margin: 0; border:1px black solid;">CARACTERÍSTICAS DEL PLAN CON RED DE ACCESOA FIBRA</div>
            <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse;border-spacing:0;">
              <tbody>
              <tr>
                      <td class="col-width-35 line-height textCenter" colspan="2" style="$!fontSize">
                          <strong>Nivel de compartición</strong>
                      </td>
                      <td class="col-width-65 line-height textCenter" colspan="3" style="$!fontSize">
                           <strong>Tipo de Cuenta</strong>
                      </td>

                  </tr>
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

                    <td class="col-width-50 line-height textLeft" colspan="3">
                    <div style="padding-left:5px !important;">
                       <div >
                          <div class="box">$!isHome</div>
                          <div class="box-label" style="$!fontSize">HOME</div>
                        </div>
                         <div>
                          <div class="box">$!isPro</div>
                          <div class="box-label" style="$!fontSize">PRO</div>
                        </div>
                        <div>
                          <div class="box">$!isPyme</div>
                          <div class="box-label" style="$!fontSize">PYME</div>
                        </div>
                      </div>
                    </td>
                </tr>
                <tr>
                      <td class="col-width-50 line-height textCenter" colspan="2" style="$!fontSize">
                          <strong>MEDIO:</strong>
                          <div class="box">$!isGeponFibra</div>
                          <div class="box-label">FIBRA</div>

                      </td>
                      <td class="col-width-50 line-height textCenter" colspan="3" style="$!fontSize">
                           <strong>PLAN:</strong>
                          <div class="box">$!isSimetrico</div>
                          <div class="box-label">SIMETRICO</div>

                      </td>

                  </tr>

                </tbody>
            </table>
            <br>
              <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse;border-spacing:0;">
                    <tbody>
                        <tr>
                            <td class="col-width-50 line-height textCenter" colspan="2" style="$!fontSize">
                                <strong> VELOCIDAD NACIONAL/INTERNACIONAL (Mbps) </strong>
                            </td>

                        </tr>
                        <tr>
                            <td class="line-height" colspan="1">TASA MAXIMA DE SUBIDA Y BAJADA</td>
                            <td class="line-height textCenter" colspan="1" width="15%">$!velNacMax  Mbps</td>
                        </tr>
                        <tr>
                            <td class="line-height" colspan="1">TASA MINIMA DE SUBIDA Y BAJADA</td>
                            <td class="line-height textCenter" colspan="1" width="15%">$!velIntMin Mbps</td>
                         </tr>
                    </tbody> 
                  </table>
            <br/>                 


            <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse;border-spacing:0;">
              <tbody>

                <tr>
                    <td class="col-width-60 line-heightT textLeft" style="$!fontSize" rowspan="2" colspan="3">Acepto el tiempo mínimo de permanencia mínima (<u> 36 </u> meses) para el otorgamiento de beneficios y promociones vinculados con la clausula 4</td>
                    <td class="col-width-5 line-heightT textCenter ">Si</td>
                    <td class="col-width-5 line-heightT textCenter ">$!isAceptacionBeneficios</td>
                </tr>
                <tr>
                <td class="col-width-5 line-heightT textCenter ">No</td>
                    <td class="col-width-5 line-heightT textCenter "></td>
                </tr>
                <tbody>
            </table>
        </div>
        ');
        DBMS_LOB.APPEND(bada, ' 
        <div style="width:60%; float:right; vertical-align:top;$!fontSize">
            <div class="labelBlock textCenter" style="margin: 0; border:1px black solid;">TARIFAS</div>
            <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse; border-spacing:0; ">
            <tbody>
                <tr>
                    <td class="line-height textCenter labelGris" style="width: 40%"><strong>SERVICIO</strong></td>
                    <td class="line-height textCenter labelGris" style="width: 20%"><strong>INSTALACION(Valor único)</strong></td>
                    <td class="line-height textCenter labelGris" style="width: 12%"><strong>VALOR MES</strong></td>
                    <td class="line-height textCenter labelGris" style="width: 15%"><strong>VALOR TOTAL</strong></td>
                    <td class="line-height textCenter labelGris" style="width: 13%"><strong>OBSERVACIONES</strong></td>
                </tr>
                <tr>
                    <td class="line-height labelGris">ACCESO Y NAVEGACIÓN DE INTERNET <br/><strong>$!nomPlan</strong></td>
                    <td class="line-height textCenter">$!productoInternetInstalacion</td>
                    <td class="line-height textCenter">$!productoInternetPrecio</td>
                    <td class="line-height textCenter">$!productoInternetPrecio</td>
                    <td class="line-height textCenter">$!productoInternetObservaciones</td>
                </tr>

                     {{listaProductos}}
                <tr style="height: 25px;">
                  <td style="height: 25px;" class="line-height labelGris"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                </tr>
                <tr style="height: 25px;">
                  <td style="height: 25px;" class="line-height labelGris"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                </tr>
                <tr style="height: 25px;">
                  <td style="height: 25px;" class="line-height labelGris"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                  <td style="height: 25px;" class="line-height textCenter"></td>
                </tr>
                <tr>
                    <td class="line-height textCenter" style="border-bottom:1px white solid;">SUBTOTAL:</td>
                    <td class="line-height textCenter">$!subtotalInstalacion</td>
                    <td class="line-height textCenter">SUBTOTAL:</td>
                    <td class="line-height textCenter">$!subtotal</td>
                    <td class="line-height textCenter" style="border-bottom:1px white solid;"></td>
                </tr>
                <tr>
                    <td class="line-height textCenter"  style="border-bottom:1px white solid;">IMPUESTOS:</td>
                    <td class="line-height textCenter">$!impInstalacion</td>
                    <td class="line-height textCenter">IMPUESTOS:</td>
                    <td class="line-height textCenter">$!impuestos</td>
                    <td class="line-height textCenter" style="border-bottom:1px white solid;"></td>
                </tr>
                <tr>
                    <td class="line-height textCenter" >TOTAL:</td>
                    <td class="line-height textCenter">$!totalInstalacion</td>
                    <td class="line-height textCenter">TOTAL:</td>
                    <td class="line-height textCenter">$total</td>
                    <td class="line-height textCenter"></td>
                </tr>
                <tr>
                    <td colspan="2">

                        <div id="row">
                        <div id="colCell" class="col-width-10 textRight"><strong>Promoción:</strong></div>
                        <div id="colCell" class="col-width-8 textRight">$!descInstalacion</div>
                        <div id="colCell" class="col-width-43 textRight">Dscto instalación:</div>
                        <div class="box">$!isDescInstalacion</div>
                        <div id="colCell" class="textRight">%</div>
                        </div>

                    </td>
                    ');
        DBMS_LOB.APPEND(bada, ' 
                    <td class="line-height textCenter" colspan="3">
                        Mensualidad promo:
                        <div class="box">$!isPrecioPromo</div>
                        $+IVA <br/> #facturas
                        <div class="box">$!numeroMesesPromo</div>
                    </td>
                </tr>
                <tbody>
            </table>
        </div><!-- ========================================== -->
        <!-- Observaciones de los Servicios Contratados -->
        <!-- ========================================== -->        

');
        DBMS_LOB.APPEND(bada, ' 
        <div style="clear: both;"></div>

        <div id="contenedor" class="col-width-100" style="height: 65px;">
            <div id="row">
                <table class="box-section-content col-width-70" style="border-collapse:collapse;border-spacing:0;">
                <tbody>
                    <tr>
                        <td class="line-height">Sitio web para consulta de tarifas</td>
                        <td class="line-height" colspan="1"><a href="$!urlConsTarifaVal1">$!urlConsTarifaVal1</a></td>
                    </tr>

                    <tr><td class="line-height"></td>
                    <td class="line-height" colspan="1"><a href="$!urlConsTarifaVal2">$!urlConsTarifaVal2</a> </td></tr>
                    <tr><td class="line-height"></td>
                    <td class="line-height" colspan="1"><a href="$!urlConsTarifaVal3">$!urlConsTarifaVal3</a> </td></tr>
                    <tr>
                        <td class="line-height" colspan="1">Sitio web consulta calidad del servicio:</td>
                        <td class="line-height" colspan="1"><a href="$!urlConsCalidadVal1">$!urlConsCalidadVal1</a> </td>
                    </tr>
                </tbody>
            </table>
            </div>
        </div>
        <div id="contenedor" class="col-width-100" style="height: 25px;">
        <spam>El tiempo de instlación promedio del servicio será hasta 5 días hábiles</spam></div>
        <div id="contenedor" class="col-width-100" style="height: 65px;">
            <div id="row">
                <div id="col" class="col-width-14"> <strong>Beneficios/Observaciones: </strong> </div>
                <div id="col" class="col-width-100 labelGris">
                    <span class="textPadding" style="$!fontSize">
                    $!obsServicio
                    </span>
                </div>
            </div>
        </div>
        <br/>
        ');
        DBMS_LOB.APPEND(bada, ' 
        <!-- ================================================= -->
        <!--    Contrato de prestación de servicios     -->
        <!-- ================================================= -->
        <div style="text-align: justify; $!fontSize">
            <div id="col" class="col-width-100">Los términos y condiciones de los servicios adicionales se encuentran detalladas en el contrato de servicios
        digitales.</div><br/>
           <span>
                <div id="col" class="col-width-100"><strong>TERCERA.-</strong> VIGENCIA: El plazo de duración contractual es de <u> 36 </u> meses en caso de aceptar el tiempo de
                permanencia mínimo, el cual </div><div id="row"> {{isTercera}} <div id="col" class="col-width-100" >se renovará automáticamente en períodos 
                iguales y sucesivos,mientras las partes no soliciten una terminación </div></div>
                <div id="col" class="col-width-100" > del mismo, y  tendrá vigencia desde la fecha de instalación y
                activación del servicio que se indicará en la facturación mensual. El ABONADO tiene derecho a terminar la relación
                contractual conforme la legislación aplicable, o solicitar en cualquier tiempo, con hasta quince (15) días de
                antelación a la fecha de renovación, su decisión de no renovación.</div>
                </br>

                <div id="row">
                <div id="colCell" class="col-width-35" >
                <strong>CUARTA.-</strong>PERMANENCIA MÍNIMA: <strong>4.1.</strong>El ABONADO </div>{{isCuarta}} <div id="colCell" class="col-width-45" >
                se acoge al periodo de permanencia mínima de <u> 36 </u> meses. Los</div></div>
                <div id="col" class="col-width-100" > beneficios de la permanencia mínima corresponden a las promociones adquiridas sobre
                el servicio o instalación del mismo, informadas al momento de la contratación, y detalladas en el campo de
                beneficios/observaciones del presente contrato. En tal virtud, en caso de una terminación anticipada del contrato,
                cambio en la forma de pago que esté realizando contraria a las condiciones inicialmente contratadas, o downgrades
                del servicio (disminución de velocidad), el ABONADO dejará de beneficiarse de dicho descuento o promoción
                inicialmente otorgados en el servicio o costo de instalación, y por lo tanto se procederá a aplicar el cobro de las
                tarifas regulares por el servicio e instalación prorrateados en función del tiempo pendiente de permanencia. Para
                tal efecto en la última factura emitida al ABONADO, se reflejará desglosada la respectiva reliquidación de valores
                del servicio contratado en base al precio sin descuento. <strong>4.2.</strong>  La permanencia mínima se acuerda sin perjuicio de
                que el ABONADO conforme lo determina la Ley Orgánica de Telecomunicaciones, pueda dar por terminado el
                contrato en forma unilateral y anticipada, y en cualquier tiempo, previa notificación por medios físicos o electrónicos
                a NETLIFE con por lo menos quince (15) días término de anticipación, para cuyo efecto procederá a cancelar los
                servicios efectivamente prestados, los bienes solicitados y recibidos, incluyendo los descuentos y/o beneficios
                aceptados y recibidos, de forma prorrateada.</div>
                <br/>
                <strong>QUINTA.-</strong> PRECIO, FORMA DE PAGO Y FACTURACIÓN: <strong>5.1.-</strong> El precio de los servicios contratados pueden ser
                cancelados por cualquiera de los canales físicos y digitales de recaudación autorizados y comunicados por
                NETLIFE. En caso de mora, NETLIFE aplicará la máxima tasa de interés permitida por la ley por el periodo en
                mora. Para la contratación de servicios adicionales y suplementarios con costo, el ABONADO podrá realizarlo
                mediante la firma de una adenda verbal grabada, electrónica con firma digital o física al presente contrato, o
                utilizando alguno de los canales digitales. <strong>5.2.-</strong> En caso de que el abonado o suscritor desee cambiar su modalidad
                de pago a otra de las disponibles, deberá comunicar al prestador del servicio con quince (15) días de anticipación.
                <strong>5.3.-</strong> FACTURACIÓN: NETLIFE mensualmente facturará y cobrará al ABONADO el servicio contratado de acuerdo
                al ciclo de facturación asignado y comunicado en el momento de la contratación <strong>5.4.-</strong> La primera factura
                corresponderá al valor de instalación y el valor proporcional del servicio desde la fecha de activación hasta la fecha
                de finalización del ciclo de facturación correspondiente. <strong>5.5.-</strong> NETLIFE enviará a sus ABONADOS las facturas de
                conformidad con la ley, sin embargo, la no recepción de dicho documento no exime al ABONADO del pago
                correspondiente. <strong>5.6.-</strong> El ABONADO cancelará por periodos mensuales a NETLIFE por la prestación del servicio
                contratado a los precios pactados a través de éste instrumento y sus anexos o adendums, hasta el fin del período;
                si el ABONADO no cancelare los valores facturados dentro del plazo previsto, NETLIFE suspenderá los servicios
                el último día laborable del ciclo al que corresponda el abonado de forma automatizada. <strong>5.7.-</strong> El ABONADO podrá
                pedir la reactivación del servicio en un máximo de 30 días posteriores a la suspensión, previo al pago de los valores
                adeudados, caso contrario el servicio será dado por cancelado. El tiempo de reactivación del servicio es de 24
                horas después de que el ABONADO haya pagado los valores pendientes. <strong>5.8.-</strong> La modalidad de contratación es
                pospago para lo cual el abonado acepta que NETLIFE facturará y cobrará de manera anticipada y mensual el
                servicio contratado, basado en el ciclo de facturación en que haya sido definido.
                <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><strong>SEXTA.-</strong> ENTREGA DE EQUIPOS: <strong>6.1.-</strong>EL ABONADO reconoce que los equipos terminales y cualquier equipo
                adicional que eventualmente instalen nuestros técnicos son propiedad de NETLIFE. Ningún equipo terminal forma
                parte íntegra del servicio contratado, NETLIFE instalará el equipo más conveniente según factibilidad y
                disponibilidad técnica. En el caso de hurto o daño por negligencia del ABONADO, éste asumirá el valor total de su
                reposición considerando el deterioro normal y depreciación de este. <strong>6.2.-</strong>Los equipos entregados para la provisión
                del servicio pueden ser: CPE, que es el equipo que Netlife lo instala en las premisas del suscriptor e incluye WiFi
                y puertos físicos para conexión por cable, con un costo de hasta $160 USD, dependiendo del número de bandas
                (2.4 GHz y/o 5 GHz) y potencia del equipo otorgado. El extensor de señal tiene un costo de hasta $55, dependiendo
                del número de bandas. <strong>6.3.-</strong> En caso de pérdida de las fuentes, tienen un costo de USD$10,00 cada una. 6.4.-El
                equipo WiFi provisto tiene puertos físicos para conexión por cable que permiten la utilización óptima de la velocidad
                ofertada en el plan contratado. Además cuenta con conexión WiFi en planes HOME, PRO y PYME, a una frecuencia
                de 2.4GHz y 5GHz según cada caso, que permite tasas de transferencia según lo soportado por el tipo de
                dispositivo del cliente, la tecnología Wifi soportada y las condiciones de medición de velocidad, y tiene la capacidad
                de conectarse con equipos a una distancia de hasta 15 metros sin obstáculos y condiciones espectrales sin
                interferencias; sin embargo, la distancia de cobertura varía según la infraestructura del lugar de instalación,
                obstáculos e interferencia que se encuentren en el entorno. <strong>6.5.-</strong>La cantidad máxima de dispositivos conectados
                simultáneamente que soporta el equipo WiFi es de 15, salvo condiciones específicas de cada plan. Los equipos
                que operan en la banda de 5 GHz estarán sujetos a factibilidad, y su funcionamiento dependerá de las condiciones
                de uso. <strong>6.6.-</strong>El cliente está consciente y acepta esta especificación técnica y que la tecnología WiFi pierde potencia
                a mayor distancia, por lo tanto, la velocidad efectiva se reducirá a mayor distancia del equipo.
                <br/><br/>
');
        DBMS_LOB.APPEND(bada, ' 
                <strong>SEPTIMA.-</strong>
                TRATAMIENTO DE DATOS PERSONALES: <strong>7.1.-</strong>De acuerdo a la normativa vigente en materia de
                protección de datos personales, por medio del presente contrato el ABONADO manifiesta su consentimiento libre,
                específico, informado, e inequívoco, a fin de que NETLIFE realice el tratamiento de los datos personales que le
                proporcione por cualquier medio.<strong>7.2.-</strong> NETLIFE actuará como responsable del tratamiento de los datos personales
                proporcionados por el ABONADO; para lo cual, implementará medidas técnicas y relativas a la seguridad de los
                datos personales. Dada la naturaleza del contrato, el objeto del tratamiento es tendiente a cumplir una obligación
                legal de los prestadores de servicios de telecomunicaciones prevista en la Ley Orgánica de Telecomunicaciones,
                derivando en un tratamiento legítimo y lícito. <strong>7.3.-</strong> El tiempo del tratamiento de los datos personales a los que
                NETLIFE tuviere acceso, perdurará mientras se mantenga vigente el contrato hasta después de la terminación de
                la misma por efectos de la normativa ecuatoriana vigente, detallados de manera expresa en la Política de
                Privacidad. No obstante, se reserva el derecho del ABONADO a revocar el consentimiento constante en el presente
                contrato en cualquier momento, observando el procedimiento y las limitaciones establecidas en la Ley Orgánica de
                Protección de Datos Personales. <strong>7.4.-</strong> Los datos personales acordados y facilitados por el abonado o cliente por
                medio del contrato de adhesión, encuestas de servicio, gestión de requerimientos, plataforma de auto servicio,
                entre otros medios de recolección, serán utilizados por NETLIFE para gestionar adecuadamente los productos y
                servicios, y en los términos informados en la política de privacidad y sus actualizaciones que pueden ser
                consultadas en el siguiente link: https://www.netlife.ec/politica-privacidad/. <strong>7.5.-</strong> El ABONADO proporcionará los
                datos personales de manera personal o a través de su representante legal. Los datos personales serán recopilados
                en la base de datos denominada “Abonados” y podrán servir para la toma de valoraciones o decisiones
                automatizadas en temas comerciales para brindar una mejor experiencia en el servicio al ABONADO.<strong>7.6.-</strong> El
                ABONADO, en calidad de titular de sus datos personales, declara reconocer que tiene derecho a solicitar el acceso,
                eliminación, rectificación y actualización, oposición, anulación, limitación del tratamiento y a no ser objeto de una
                decisión basada únicamente en valoraciones automatizadas, y portabilidad, pudiendo dirigir su solicitud de ejercicio
                de los derechos al correo electrónico delegadodatos@netlife.net.ec, a la dirección: Atahualpa E313 y Núñez de
                Vela, Edificio Torre del Puente, piso 3, o al teléfono 02-3920000 correspondientes a NETLIFE y su Delegado de
                Protección de Datos, sin perjuicio de los procedimientos que hubiere lugar ante la Autoridad Nacional de Protección
                de Datos Personales. <strong>7.7.-</strong>El ABONADO declara haber sido informado que, en caso de tener que ejercer sus
                derechos en materia de protección de datos contra un encargado del tratamiento, procederá conforme la normativa
                legal vigente. Sin perjuicio de lo anterior, el ABONADO podrá realizar los procedimientos administrativos previstos
                en la legislación vigente ante la Autoridad Nacional de Protección de Datos Personales o la Agencia de Regulación
                y Control de las Telecomunicaciones, según corresponda. <strong>7.8.-</strong>El ABONADO entiende que, los datos personales
                recolectados por NETLIFE son obligatorios. Consecuentemente la negativa a suministrarlos supondrá la
                imposibilidad de concretar el servicio a ser contratado. Asimismo, en caso de proporcionar datos erróneos o
                inexactos, NETLIFE se reserva el derecho a dar por terminado unilateralmente el presente contrato. <strong>7.9.-</strong>NETLIFE
                podrá realizar la transferencia de datos personales de EL ABONADO tanto nacionales como internacionales con
                el objetivo de garantizar la prestación del servicio de internet, aplicación de herramientas tecnológicas u otros fines
                informados y consentidos previamente, especialmente a la Agencia de Regulación y Control de las
                Telecomunicaciones. En caso de transferencia internacional, NETLIFE se cerciorará que sea efectuada a
                jurisdicciones que tutelen la protección y privacidad de datos personales. El detalle de destinatarios que podrán
                realizar tratamiento por encargo a nivel nacional e internacional se encuentra en el siguiente enlace:
                https://www.netlife.ec/destinatarios-datos/
                Comprometidos con la protección y seguridad de sus datos personales, solicitamos revisar tus opciones de
                privacidad y ajustarlas según tus preferencias.  <strong>7.10.</strong>Acepto la
                <div id="row">
                <div id="colCell" class="col-width-32"> Política de tratamiento de Datos Personales</div>
                <div id="colCell" class="col-width-44"><a href="https://www.netlife.ec/politica-tratamiento-datos-personales/">(https://www.netlife.ec/politica-tratamiento-datos-personales/ )</a></div>
                <div id="colCell" class="col-width-24">, cuyo tratamiento ulterior permitirá </div></div> 
                 estar informado de novedades, mejoras y ofertas personalizadas de NETLIFE.<br/>
                Configuración personalizada: 
                <ul>
                  <li><div id="row"><div id="col">Acepto el tratamiento de datos para fines estadísticos y/o analíticos.</div>{{isSeptimaClausula1}}</div></li>
                  <li><div id="row"><div id="col">Acepto envío de comunicaciones comerciales propios.</div>{{isSeptimaClausula2}}</li>
                  <li><div id="row"><div id="col">Acepto envío de comunicaciones comerciales de terceros.</div>{{isSeptimaClausula3}}</li>
                </ul>
                <strong>OCTAVA.-</strong> 
                RECLAMOS Y SOPORTE TÉCNICO: Sobre los canales de atención al cliente presenciales y virtuales
                oficiales de NETLIFE, consulte la página web www.netlife.ec <strong>8.1.-</strong> En caso de reclamos o quejas, el tiempo máximo
                de respuesta es de 7 días siempre que el cliente la haya registrado y reportado a través de un ticket (tarea) por
                medio de los canales de atención de NETLIFE. Si refiere a reclamos por velocidad, el cliente deberá generar 2 ó 3
                pruebas de velocidad manteniendo conectado un solo dispositivo, siempre con cable de red (conexión directa, no
                inalámbrica), utilizando el velocímetro provisto por NETLIFE (http://netlifeecuador.speedtestcustom.com/), guardar
                en un archivo gráfico, contactarse por nuestros canales de atención para abrir un ticket (tarea), y enviar los
                resultados de las pruebas realizadas. Se recomienda tomar en cuenta el tipo de compartición contratado en su
                plan para conocer la velocidad máxima contratada, y las características técnicas del dispositivo del cliente. La
                compartición expresa el factor de cálculo para establecer la velocidad mínima que un cliente puede recibir del plan
                contratado de Internet. Una compartición 2 a 1 en un plan de 100Mbps significa que la mínima velocidad que podría
                recibir el cliente sería de 50Mbps. <strong>8.2.-</strong> Para la atención de reclamos NO resueltos por el prestador, el abonado
                también podrá presentar sus denuncias y reclamos ante la ARCOTEL por cualquiera de los siguientes canales de
                atención: Oficinas de las Coordinaciones Zonales de la ARCOTEL o PBX-Directo, Call Center (1800-567567),
                Correo Tradicional, Página web de la ARCOTEL y la página www.gob.ec <strong>8.3.-</strong>La atención telefónica del Call Center
                es 7 días, 23 horas incluyendo fines de semana y feriados. El soporte presencial se lo realizará en días y horas
                laborables.
                <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
                <strong>NOVENA.- </strong>OBLIGACIONES Y CONDICIONES DE NETLIFE: <strong>9.1.- </strong>El tiempo de instalación promedio del servicio
                será hasta 5 días hábiles; sin embargo, podría variar dependiendo de la factibilidad técnica, caso fortuito y/o fuerza
                mayor o restricciones impuestas por autoridad competente. <strong>9.2.- </strong>El servicio está sujeto a factibilidad, disponibilidad
                técnica y cobertura de red en su zona, el mismo NO incluye obras civiles o cambios de acometida, en caso de
                requerirse aquellos cambios correrán por cuenta del ABONADO. <strong>9.3.- </strong>El contrato entrará en vigencia una vez
                instalado el servicio y la fecha de activación del mismo estará especificada en la factura correspondiente; para la
                instalación se requiere la presencia de un adulto (no se procederá la instalación con menores de edad o terceros
                no autorizados previamente). NETLIFE no se hace responsable por pérdidas o daños que puedan derivarse de la
                falta del ABONADO o un adulto responsable durante el proceso de instalación del servicio. <strong>9.4.- </strong>El cliente acepta
                expresamente que NETLIFE proceda el cobro del valor de $1.00 + impuestos de ley por concepto de los reprocesos
                y cargos bancarios que generan las entidades bancarias y que se produzcan por falta de fondos de acuerdo con
                las fechas y condiciones de pago del presente contrato, valor que será detallado en la factura del mes
                correspondiente. En caso de suspensión del servicio por falta de pago, deberá realizar el pago del servicio en uno
                de los canales de pago correspondientes y comunicarlos a nuestros canales de atención al cliente. Adicionalmente,
                el cliente acepta el pago de $3.00 + impuestos de ley por concepto de reconexión que será registrado en la siguiente
                factura. El tiempo máximo de reconexión del servicio después del pago es de 23 horas. <strong>9.5.- </strong>El cliente acepta la
                recepción de facturas mediante la modalidad de facturación electrónica sin costo. Cualquier cambio referente a la
                información de la factura o el servicio deberá notificarse 15 días antes de la finalización del ciclo de facturación en
                el que se encuentre generado el cliente. <strong>9.6.- </strong>Para el pago de los servicios de internet, a nombre de usuarios con
                discapacidad o de la persona natural o jurídica sin fines de lucro que represente legalmente a la persona con
                discapacidad, se aplica las rebajas establecidas en la Ley Orgánica de Discapacidades vigente, cumpliendo
                adicionalmente con la resolución (TEL-072-03-CONATEL-2013). Para el pago de los servicios de internet, a
                nombre de usuarios de la tercera edad se lo realizará mediante la presentación de la cédula y solicitud expresa,
                para la aplicación de rebajas establecidas en la RESOLUCIÓN-ARCOTEL-2021-1023, debiendo cumplir las
                condiciones y requisitos aprobadas. <strong>9.7.- CONDICIONES DE OPERACIÓN .-</strong> El cliente es responsable de
                mantener un servicio de energía eléctrica regulada de 110V (regulador de voltaje en las conexiones donde se
                coloquen los equipos de propiedad de NETLIFE. El cliente es responsable de mantener las conexiones eléctricas
                internas en correcto estado, donde NETLIFE instale sus equipos, por ello deslinda de responsabilidad a NETLIFE
                de fallas existentes por dichas conexiones. <strong>9.8.- </strong>El cliente para obtener un servicio adecuado debe contar con un
                computador o un dispositivo funcionando adecuadamente con las siguientes características mínimas: Procesador
                Intel o superior / 1 GB de memoria RAM / 20GB mínimo en disco duro / tarjeta de red con una capacidad superior
                a la velocidad de plan contratado, por ejemplo: para planes a partir de 1 Gbps, deberá contar con tarjeta
                Gigaethernet, con conexión directa mediante cable. <strong>9.9.- </strong>Para tener conocimiento sobre las características de
                seguridad que están implícitas al intercambiar información o utilizar aplicaciones disponibles en la red, favor visite
                nuestro sitio web: https://www.netlife.ec/guia-de-seguridad-y-control-de-internet/ <strong>9.10.- </strong>Para tener conocimiento de
                los derechos que lo asisten como usuario, puede encontrar la norma de Calidad, así como el link directo a la página
                de ARCOTEL en nuestro sitio web. <strong>9.11.- </strong>El cliente garantizará que el personal designado por NETLIFE pueda
                ingresar a los sitios donde se encuentren instalados los equipos parte del presente servicio para realizar trabajos
                de instalación, mantenimiento correctivo o preventivo, revisión física del estado de los equipos propiedad de
                NETLIFE, generar evidencias cuando lo requiera o ponga en riesgo la seguridad de la red. El incumplimiento o
                negativa de estas condiciones será considerada como causal de terminación unilateral de contrato. <strong>9.12.- </strong>
                REQUERIMIENTOS ADICIONALES. - Los siguientes servicios EL CLIENTE podrá solicitarlos por un valor
                adicional: A) Obras civiles o cambios de acometida. B) Después de 400 metros de cableado de fibra óptica, cada
                metro adicional tendrá un valor adicional de $1,00+ impuestos de ley. C) Reactivaciones, D) Traslado físico del
                servicio a otro domicilio o reubicación en el mismo domicilio, sujeto a factibilidad técnica., E) Asistencia técnica a
                domicilio debido a causas no imputables a NETLIFE. <strong>9.13.- ALCANCE DE LA RESPONSABILIDAD DE NETLIFE.</strong>
                - NETLIFE no se hará responsable en los siguientes casos: <strong>9.14.- </strong>En caso de orden judicial, caso fortuito o fuerza
                mayor debidamente comprobadas se vea en la obligación de suspender el servicio. No obstante, de lo anterior,
                NETLIFE se compromete a informar inmediatamente de este hecho al ABONADO. <strong>9.15.- </strong>En caso de que se
                presente transmisión de virus a través de las redes. <strong>9.16.- </strong>Por uso indebido de los servicios contratados o uso ilegal
                y en forma diferente al paquete contratado (clientes PYMES utilizando planes HOME, por ejemplo),
                comercialización, subarrendamiento, reventa del servicio sin autorización de NETLIFE, por mandato judicial y por
                las demás causas previstas en el ordenamiento jurídico vigente, lo cual provocará que NETLIFE proceda con la
                suspensión del servicio. <strong>9.17.- </strong>NETLIFE no podrá bloquear, priorizar, restringir o discriminar de modo arbitrario y
                unilateral aplicaciones, contenidos o servicios sin consentimiento del ABONADO o por orden expresa de la
                autoridad competente, salvo que estas pudieran poner en riesgo de cualquier forma a la red de propiedad de
                NETLIFE. Del mismo modo podrá ofrecer, si el ABONADO lo solicita, servicio de control y bloqueo de contenidos
                que atenten contra la ley, la moral o las buenas costumbres, para lo cual informará oportunamente al ABONADO
                cual es el alcance de la tarifa o precio y modo de funcionamiento de estos.
                <br/><br/><strong>DÉCIMA.- </strong>OBLIGACIONES Y DERECHOS DEL ABONADO: <strong>10.1.- </strong>Cancelar a NETLIFE todos los valores
                correspondientes a los servicios, promociones, gestión de cobranzas y costos por reconexión <strong>10.2.- </strong>Obtener la
                debida autorización y/o licencia del propietario de programas, contenidos (streaming) o información en caso lo
                requiera. <strong>10.3.- </strong>Obtener y salvaguardar el uso de la clave de acceso de WiFi y canales digitales. <strong>10.4.- </strong>Brindar a
                NETLIFE información fidedigna de sus datos personales necesarios para la prestación del servicio. <strong>10.5.- </strong>La
                instalación del servicio de internet incluye un punto de acometida donde se colocarán el (los) equipo (s), de
                propiedad y administrados exclusivamente por personal de NETLIFE. Cualquier manipulación o alteración de la
                instalación original generará cobros hacia el cliente. Bajo ningún concepto el cliente puede revender, repartir o
                compartir el servicio a través de cualquier mecanismo físico o inalámbrico, o a través de la compartición de claves
                de acceso a terceros; no se podrá instalar servidores. Si desea hacerlo, su plan deberá contemplar esas
                características para comercialización. <strong>10.6.- </strong>El cliente será responsable si instala o usa aplicaciones adicionales
                ajenas a NETLIFE, realizará la configuración interna de su red de área local, del control de la información y
                navegación que realice por Internet. NETLIFE pone a disposición de los clientes un servicio integral de seguridad
                informática para proteger de amenazas cibernéticas, según se indique en los planes. <strong>10.7.-</strong> El cliente acepta que
                sólo podrá requerir IPs públicas estáticas exclusivamente en planes PYME, acepta que la dirección IP asignada
                podría modificarse debido a traslados que se soliciten, cambios de plan o mejoras tecnológicas, para lo cual
                NETLIFE coordinará previamente con el cliente a fin de generar el menor impacto posible. <strong>10.8.- </strong>No se podrán
                aplicar rebajas o descuentos sobre otras promociones ya otorgadas previamente. <strong>10.9.- </strong>El cliente acepta que
                NETLIFE en planes de Internet, para evitar el SPAM, mantenga restringido el puerto 25 (debidamente autorizado
                por ARCOTEL medianteARCOTEL-CCON-2017-0249-OF) (salvo planes PYME) y para proteger su servicio de
                posibles ataques y preservar la seguridad de la red, restrinja puertos normalmente usados para este fin como son:
                135, 137, 138, 139, 445, 593, 1434, 1900, 5000 (debidamente autorizado por ARCOTEL mediante Oficio N.-
                ARCOTEL-CCON-2020-0610-OF). <strong>10.10.- </strong>La instalación del servicio incluye la configuración del dispositivo
                provisto por el cliente (1). No incluye cableado interno. <strong>10.11.- </strong>El CLIENTE acepta que el servicio HOME sólo es
                para el segmento residencial, el servicio PRO para profesionales Home Office y PYME para personas naturales y
                empresas (servicio no disponible para Cybers y/o ISPs). <strong>10.12.- </strong>EL CLIENTE acepta que tendrá un servicio con
                disponibilidad del 98%. El tiempo promedio de reparación mensual de todos los clientes de NETLIFE es de 24
                horas, siempre que el cliente haya notificado y registrado su requerimiento con un ticket (tarea) interno a través de
                los canales de atención al cliente de NETLIFE disponibles y mencionados en nuestra página web; se excluye el
                tiempo imputable al cliente y causas derivadas del caso fortuito y/o fuerza mayor. <strong>10.13.- DERECHOS DEL
                ABONADO: </strong>Solicitar soporte técnico sobre el servicio de internet <strong>10.14.- </strong>Recibir todos los derechos adquiridos
                según la ley orgánica de las telecomunicaciones, la Ley de defensa del consumidor y demás normativa relacionada
                vigente. <strong>10.15.- </strong>Recibir compensaciones por parte del proveedor por el servicio no provisto que sea inferior al 98%
                de disponibilidad. <strong>10.16.- DECLARACIÓN FUNDAMENTAL: </strong>El ABONADO declara que ha entendido, revisado y
                acepta que ha sido explicado sobre todo el contenido de este instrumento compartido por parte de NETLIFE, por
                convenir a sus intereses, así mismo declara que conoce íntegramente el presente contrato de adhesión, mismo
                que no puede ser considerado de negociación.
                <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
                <strong>DÉCIMA PRIMERA.- </strong>CONTROVERSIAS.- Las controversias o diferencias que surjan entre las partes con ocasión
                del cobro de valores pendientes de pago a la terminación del Contrato, así como de cualquier otro asunto
                relacionado con el presente Contrato, serán sometidas a la revisión de las partes para buscar un arreglo directo,
                en término no mayor a DIEZ (10) días hábiles a partir de la fecha en que cualquiera de las partes comunique la
                existencia de una diferencia. Si no se resolviere de esta manera, se someten a la Justicia Ordinaria, para lo que
                renuncia a fuero y domicilio, sometiéndose de forma expresa a la jurisdicción de Guayaquil.<br/><br/>

                <strong>DÉCIMO SEGUNDA.- </strong>TERMINACIÓN DEL CONTRATO: <strong>12.1.- </strong>EL ABONADO podrá cancelar su contrato en
                cualquier momento a través de cualquiera de nuestros centros de atención al usuario que se indican en la sección
                de atención al cliente de la página web www.netlife.ec, o por medio de nuestros canales digitales oficiales
                habilitados, sin eximir del pago de todos los valores que se adeuden a la fecha de la terminación. El abonado
                deberá entregar los equipos que son propiedad de NETLIFE al momento de cancelar el servicio en un plazo máximo
                de 8 días calendario, caso contrario se procederá con el cobro de estos si no procedió con dicha entrega. Los
                equipos deberán estar en perfectas condiciones, salvo por deterioros normales causados por el uso diligente. Sin
                perjuicio de lo anterior, son causales de terminación anticipada del presente instrumento, las siguientes: <strong>12.2.- </strong>
                Aplicación de las normas legales, el caso fortuito o fuerza mayor que obliguen a NETLIFE a suspender
                definitivamente el servicio. <strong>12.3.- </strong>Inobservar alguna de las obligaciones del abonado establecidos en la cláusula
                décima o causas derivadas del presente Contrato. <strong>12.4.- </strong>En caso de que el servicio se esté utilizando como Cyber,
                ISP clandestino, reventa del servicio proporcionado por NETLIFE o cuando se realice un uso diferente conforme a
                las características del plan contratado, bastando para la terminación un reporte generado por NETLIFE que
                confirme esto, sin eximir del pago de todos los valores que se adeuden a la fecha de la 
                terminación. <strong>12.5.- </strong> Para el caso de promociones, el ABONADO
                <div id="row">
                {{isDecimaSegunda}} <div id="colCell" class="col-width-55 textRight"> desea acceder a las promociones que establece un plazo de
                permanencia de <u> 36 </u> meses para hacerlas efectivas, en tal virtud,</div> </div>  en casode una terminación  anticipada del
                contrato, cambio en la forma de pago que esté realizando contraria a las condiciones inicialmente contratadas, o
                downgrades del servicio (disminución de velocidad), el ABONADO dejará de beneficiarse de dicho descuento,
                promoción o costo de instalación, y por lo tanto se procederá a aplicar el cobro de las tarifas regulares por los
                servicios e instalación contratados prorrateados en función del tiempo pendiente de permanencia. Para tal efecto
                en la última factura emitida al ABONADO, se reflejará desglosada la respectiva reliquidación de valores del servicio
                contratado en base al valor real del mismo.
                <br/><br/>
                <strong>DÉCIMA TERCERA.- </strong>CESIÓN: El ABONADO puede ceder el presente contrato previo a realizar el trámite correspondiente de cesión de derechos en los canales de atención disponibles.
                <br/><br/><strong>DÉCIMO CUARTA.- </strong>NOTIFICACIONES: Toda notificación que requiera realizarse en relación con el presente Contrato, se hará por escrito a las siguientes direcciones: <strong>14.1.- </strong>NETLIFE: Quito: Av. Núñez de Vela E3-13 y
                Atahualpa, Edificio torre del Puente Piso 3, Guayaquil: Av. Rodrigo de Chávez, Parque Empresarial Colón
                Ed.Coloncorp,Torre 6, Locales 4 y 5, o en la dirección de correo electrónico info@netlife.ec <strong>14.2.- </strong>ABONADO en
                la dirección indicada en el presente contrato o en su dirección de correo electrónico. <strong>14.3.- </strong>De presentarse cambios
                en las direcciones enunciadas, la parte respectiva dará aviso escrito de tal hecho a la otra, dentro de las 24 horas
                de producido el cambio. Para constancia de todo lo expuesto y convenido, las partes suscriben el presente contrato,
                en la ciudad y fecha indicada en el anverso del presente contrato, en tres ejemplares de igual tasa y valor.
                </span>
                <br/><br/>
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
                                               <hr> <span>Representante Legal - Megadatos S.A</span>
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
                                $!versionTitulo
                            </div>
                        </div>
                        <div id="row">
                            <div  class="col-width-100" style="padding-right: 5px;text-align:center; $!fontSize">
                                $!versionFecha
                            </div>
                        </div>
                    </div><!-- ============================== -->
        <!--      Servicios Contratados     -->
        <!-- ============================== -->
');
        DBMS_LOB.APPEND(bada, ' 
         <br/><br/><br/>
        <div class="labelBlock">DOCUMENTOS QUE DEBEN ADJUNTARSE</div>
        <br/>
        <div id="contenedor" class="col-width-100" style="text-align: justify;">
            <div id="row">
                <div id="colCell" class="col-width-55">
                    <div> <strong>Personas Naturales: </strong> </div>
                    <div  class="clausulas clausulasFont" >
                        <ul>
                              <li>Copia de cédula de Identidad o pasaporte(vigente)</li>
                              <li>Copia de encabezado de estado de cuenta (Corriente/Ahorro/TC) en caso de hacer débito automático (Cuenta con apertura minima de tres(3) meses previa a la suscripción).</li>
                              <li>Copia de la calificación de discapacidad emitida por el CONADIS, que determine el tipo y porcentaje de discapacidad igual o mayor al 30%.</li>
                              <li>En caso de discapacidad, factura original de un servicio básico que confirme la residencia del solicitante para acceder al servicio.</li>
                          </ul>
                    </div>
                </div>
                <div id="colCell" class="col-width-5"></div>
                <div id="colCell" class="col-width-30">
                    <div> <strong>Personas Jurídicas: </strong> </div>
                    <div  class="clausulas clausulasFont" >
                        <ul>
                            <li>Copia del RUC/RIMPE(vigente)</li>
                            <li>Copia de encabezado de estado de cuenta (Corriente/Ahorro/TC) en caso de hacer débito automático.</li>
                            <li>Copia de cédula o pasaporte de representante legal(vigente).</li>
                            <li>Nombramiento, Delegación o Resolución Administrativa del representante legal(inscrito en registro en Órgano regulador competente en casos en los que se requiera dicha inscripción-vigente)</li>
                        </ul>
                    </div>
                </div>
                <br/>
            </div>
        </div><!-- ========================================== -->
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
            <span>El titular suscriptor del contrato declara haber leído este contrato y la socitud de prestación de servicios en su totalidad, por ello se encuentra conforme con todas y cada una de sus cláusulas. El
            cliente declara que la información suministrada a NETLIFE es veraz y correcta so pena de judicalización. Adicionalmente autoriza a NETLIFE a verificarla en cualquier momento. El cliente autoriza a 
            NETLIFE expresamente a entregar y requerir información, en forma directa, a los burós de información crediticia o entidades designadas para estas calificaciones sobre su comportamiento y capacidad de pago,
            su desempeño como deudor, para valorar su riesgo futuro 
            </span>
        </div><!-- ========================================== -->
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

                             <div id="row" style="display: flex;">

                               <div id="colCell" class="col-width-100">
                                    <div id="contenedor" class="col-width-100"> 

                                         <div id="row" style="display: flex;">          
                                            <div id="colCell" class="col-width-100">
                                                <hr> <span>Firma del Cliente</span>
                                            </div>
                                            <div id="row" style="display: flex;">
                                                <form>
                                                          <div id="colCell" class="col-width-5">

                                                               <input id="inputfirma1" name="FIRMA_CONT_MD_FORMA_PAGO" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>

                                                       </div>
                                                       </form>
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
        </div>
        <div style="clear: both;"></div>
        <div style="clear: both;"></div><br><br><br><br><br><br><br><br><br><br><br><br><!-- ================================================================= -->
        <!-- Autorización para Debito por concepto de pago del servicio -->
        <!-- ================================================================= -->
');
        DBMS_LOB.APPEND(bada, ' 
        <div class="labelBlock">AUTORIZACIÓN PARA DÉBITO POR CONCEPTO DE PAGO DEL SERVICIO</div>
        <div id="contenedor" class="col-width-100" style="padding-block-end: 10em;">
            <div id="row">
                <div id="col" class="col-width-20">
                    Señores (Banco/Tarjeta):
                </div>
                <div id="col" class="col-width-40 labelGris">
                    <span class="textPadding">$!nombreBanco</span>
                </div>
                <div id="col" class="col-width-5">
                    <span class="textPadding"></span>
                </div>
                <div id="col" class="col-width-5">
                    Fecha:
                </div>
                <div id="col" class="col-width-20 labelGris">
                    <span class="textPadding">$!fechaActualAutDebito</span>
                </div>
            </div>
        </div>

          <div id="contenedor" class="col-width-100" >
            <div id="row">
                <div id="col" class="col-width-20">
                    Yo:
                </div>              <div id="col" class="col-width-40 labelGris">
                    <span class="textPadding">$!nombreTitular</span>
                </div>
                <div id="col" class="col-width-5">
                    <span class="textPadding"></span>
                </div>
                <div id="col" class="col-width-5">
                    CI:
                </div>
                <div id="col" class="col-width-20 labelGris">
                    <span class="textPadding">$!identificacionAutDebito</span>
                </div>
            </div>
          </div>
          <div id="contenedor" class="col-width-100" >
            <div id="row">
                <div id="col" class="col-width-40">
                    Autorizo a MEGADATOS a debitar de mi cuenta:
                </div>
                <div id="col" class="col-width-13">
                    <div class="box">$isCuentaCorriente</div>
                    <div class="box-label">Corriente</div>
                </div>
                <div id="col" class="col-width-18">
                    <div class="box">$isTarjetaCredito</div>
                    <div class="box-label">Tarjeta de Crédito</div>
                </div>
                <div id="col" class="col-width-15">
                    <div class="box">$isCuentaAhorros</div>
                    <div class="box-label">Ahorros</div>
                </div>
            </div>
       </div>
        <div id="contenedor" class="col-width-100" >
            <div id="row">
                <div id="col" class="col-width-10">
                    Número:
                </div>
                <div id="col" class="col-width-35 labelGris">
                    <span class="textPadding">$!numeroCuenta</span>
                </div>
                <div id="col" class="col-width-10">
                <span class="textPadding"></span>
               </div>
                <div id="col" class="col-width-20">
                          Fecha de Expiración:
               </div>
              <div id="col" class="col-width-20 labelGris">
                      <span class="textPadding">$!fechaExpiracion</span>
              </div>
            </div>
       </div>
        <br/>

        <div style="text-align: justify;">
            <span>
              El valor de los servicios y el pago respectivo a NETLIFE por concepto de todos los valores estipulados en el contrato firmado entre las partes. Me comprometo a mantener fondos suficientes y 
              disponibles para cubrir dicho pago. Al acreditar al beneficiario agradeceré mencionar como referencia lo siguiente: PAGO EFECTUADO A NETLIFE POR SERVICIOS.
             </span>
        </div>
        <br/>
        <br/>
        <br/><br/><br/><br/><br/>
        <div style="clear: both;"></div>
       <!--==============================form firma======================================-->
');
        DBMS_LOB.APPEND(bada, ' 
        <div id="contenedor" class="col-width-100">
            <div id="row">
                <div id="colCell" class="col-width-30" style="text-align:center">
                    <div id="contenedor" class="col-width-80">
                        <div id="row" >
                          <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                        </div>


                        <div id="row">

                            <div id="colCell" class="col-width-30">

                            <form>
                             <input id="inputfirma1" name="FIRMA_CONT_MD_AUT_DEBITO" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;$!fontSize" readonly/>

                            </div>

                            </form>
                            <div id="colCell" class="col-width-60"><hr><span>Firma del Cliente</span></div>

                        </div>
                    </div>
                </div>
                <div id="colCell" class="col-width-30" style="text-align:center">                   
                <div id="contenedor" class="col-width-100">
                        <div id="row" >
                                   <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                        </div>
                        <div id="row" >
                            <div id="colCell" class="col-width-10"></div>
                            <div id="colCell" class="col-width-40"><hr></div>
                            <div id="colCell" class="col-width-20"></div>
                        </div>
                        <div id="row">
                            <div id="colCell" class="col-width-10"></div>
                            <div id="colCell" class="col-width-25">Firma Conjunta</div>
                            <div id="colCell" class="col-width-20"></div>
                        </div>
                    </div>
                </div>
                <div id="colCell" class="col-width-30" style="text-align:center">
                    <div id="contenedor" class="col-width-100">
                        <div id="row" >
                            <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                        </div>
                        <div id="row" >
                            <div id="colCell" class="col-width-10"></div>
                            <div id="colCell" class="col-width-40"><hr></div>
                            <div id="colCell" class="col-width-20"></div>
                        </div>
                        <div id="row">
                            <div id="colCell" class="col-width-10"></div>
                            <div id="colCell" class="col-width-40">Sello de la Empresa</div>
                            <div id="colCell" class="col-width-20"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

          <!--==============================form firma======================================-->
        <div style="clear: both;"></div><br /><br />
        <br />
        <div style="clear: both;"></div>

        <div id="contenedor" style="float:right">
                        <div id="row">
                            <div id="col" class="col-width-100" style="text-align:center;$!fontSize">
                                $!versionTitulo
                            </div>
                        </div>
                        <div id="row">
                            <div  class="col-width-100" style="padding-right: 5px;text-align:center; $!fontSize">
                                $!versionFecha
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