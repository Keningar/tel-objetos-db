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
<html>
    <head>
        <title>Requerimientos de Servicios</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style type="text/css">
             @page {
            margin-top: 0.21cm;
            margin-left: 0.10cm; 
            margin-right: 0.10cm; 

            size: A4 portrait; 
               @bottom-center {
                   content: counter(page) ''/'' counter(pages) ;
                   font-size: 12px;
             }
          }
            * {
                font-family: "Helvetica";
            }

            body {
                width: 98%;
                 margin: 6px;
                font-size: 10px;
            } 

            /* // ==========================================
                // Clases definidas para los componentes
                // ==========================================*/
            #contenedor {
                display: table;
                width: auto;
                vertical-align: middle;
                border-spacing: 1px;
                margin: 0px;
                padding: 0px;
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
            .labelBlock {
                font-weight: bold;
                background: #f9e314;
                font-size: 12px;
                border-top: 1px black solid;
                border-bottom: 1px solid black;
                margin: 1em 0;
                padding-left: 1em;
            }

            label,
            .labelGris {
                background: #E6E6E6;
                border-radius: 3px;
                -moz-border-radius: 2px;
                -webkit-border-radius: 2px;
            }
            div.labelGris {
                  height: 1em;
            }

            .box {
                height: 15px;
                width: 15px;
                border: 1px solid black;
                display: inline-block;
                border-radius: 2px;
                -moz-border-radius: 2px;
                -webkit-border-radius: 2px;
                vertical-align: top;
                text-align: center;
            }

            .box-label {
                padding-left: 3px;
                text-align: center;
                display: inline-block;
                vertical-align: top;
            }

            .line-height,
            .labelBlock,
            #col {
                margin-top: 2px;
            }

            .textLeft {
                text-align: left;
            }

            .textRight {
                text-align: right;
            }

            .textCenter {
                text-align: center;
            }

            .textPadding {
                padding-left: 5px;
            }

            .borderTable th,
            .borderTable td {
                border: 1px solid black;
            }

            table tr td {
            font-size: 12px;
            }

            /* // ==========================================
                // Viñetas para las clausulas
                // ==========================================*/
            .clausulas ul {
                list-style: none;
                /* Remove list bullets */
                padding: 0;
                margin: 0;
                list-style-position: inside;
                text-indent: -1em;
            }

            .clausulas li {
                padding-left: 16px;
            }

            .clausulas li:before {
                content: "-";
                padding-right: 5px;
            }

            /* // ==========================================
                // Clases de manejo de tamaño de columnas
                // ==========================================*/
            .col-width-2-5 {
                width: 2.5% !important;
            }
            .col-width-5 {
                width: 5% !important;
            }
            .col-width-6 {
                width: 6% !important;
            }
            .col-width-7 {
                width: 7% !important;
            }

            .col-width-10 {
                width: 10% !important;
            }
             .col-width-16 {
                width: 16% !important;
            }


            .col-width-15 {
                width: 15% !important;
            }
            .col-width-18 {
                width: 18% !important;
            }

            .col-width-20 {
                width: 20% !important;
            }
            .col-width-24 {
                width: 24% !important;
            }

            .col-width-25 {
                width: 25% !important;
            }

            .col-width-30 {
                width: 30% !important;
            }

            .col-width-35 {
                width: 35% !important;
            }

            .col-width-40 {
                width: 40% !important;
            }

            .col-width-45 {
                width: 45% !important;
            }

            .col-width-50 {
                width: 50% !important;
            }

            .col-width-55 {
                width: 55% !important;
            }

            .col-width-60 {
                width: 60% !important;
            }

            .col-width-65 {
                width: 65% !important;
            }

            .col-width-70 {
                width: 70% !important;
            }

            .col-width-75 {
                width: 75% !important;
            }

            .col-width-80 {
                width: 80% !important;
            }

            .col-width-85 {
                width: 85% !important;
            }

            .col-width-90 {
                width: 90% !important;
            }

            .col-width-95 {
                width: 95% !important;
            }

            .col-width-100 {
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

        </script>
    </head>
    
    <body style="$!fontSize" onload="substitutePdfVariables()">
        <!-- ================================ -->
        <!-- Logo Netlife y numero de contato -->
        <!-- ================================ -->

    <div id="contenedor" class="col-width-100" style="$!fontSize">
        <table class="col-width-100">         
        <tr>     
            <td class="col-width-75" style="$!fontSize"><b>ADENDUM SERVICIOS / PRODUCTOS ADICIONALES</b></td> 
            <td id="netlife" class="col-width-30" align="center" rowspan="2">
            <img src="http://images.telconet.net/others/telcos/logo_netlife.png" alt="log" title="NETLIFE" height="40"/>
            <div style="font-size:14px">Telf: 3920000</div>
            <div style="font-size:20px"><b>$!numeroAdendum</b></div>
            </td>
        </tr>
        <tr>
            #if($!isnumeroContrato =="S")
             <td class="col-width-75" style="$!fontSize">Este documento adenda al contrato  $!numeroContrato</td>
            #end
        </tr>
        <tr style="$!verLeyenda">
            <td class="col-width-75" style="$!fontSize">FE DE ERRATAS: este adendum es emitido como corrección al adendum del contrato $!numeroContrato</td>
        </tr>

        </table>
    </div>

    <div id="contenedor" class="col-width-100">
        <div  style="$!fontSize" id="row">
            <div id="col" class="col-width-15">Fecha:</div>
            <div id="col" class="col-width-15 labelGris">$!fechaActual<span class="textPadding"></span></div>
          <div id="col" class="col-width-70"><span class="textPadding"></span></div>
        </div>
    </div>

        <br/>


        <div style="clear: both;"></div>
        <div style="$!fontSize" class="labelBlock">DATOS DEL CLIENTE</div>

        <div id="contenedor" class="col-width-100" style="$!fontSize">
            <div id="row">
                <div id="col" class="col-width-20">Nombre del cliente:</div>
                <div id="col" class="col-width-50 labelGris">$!nombresApellidos<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-5">CI:</div>
                <div id="col" class="col-width-25 labelGris">$!cedula<span class="textPadding"></span></div>
            </div>
    </div>
    <div id="contenedor" class="col-width-100" style="$!fontSize">
            <div id="row">
                <div id="col" class="col-width-20">Razón social:</div>
                <div id="col" class="col-width-50 labelGris">$!razonSocial<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-5">RUC:</div>
                <div id="col" class="col-width-25 labelGris">$!ruc<span class="textPadding"></span></div>
            </div>
   </div>
    <div id="contenedor" class="col-width-100" ="$!fontSize">
            <div id="row">
                <div id="col" class="col-width-15">Login:</div>
                <div id="col" class="col-width-50 labelGris">$!loginPunto<span class="textPadding"></span>
            </div>
   </div>
    <div id="contenedor" class="col-width-100" style="$!fontSize">
            </div>
            <div id="row">
                <div id="col" class="col-width-20">Plan actual contratado:</div>
                <div id="col" class="col-width-30 labelGris">$!nombrePlan<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col"   class="col-width-6">Correo:</div>
                <div id="col" class="col-width-24 labelGris">$!correoCliente<span class="textPadding"></span>
            </div>

            </div>
       </div>
    <div id="contenedor" class="col-width-100" style="$!fontSize">
            <div id="row">
                <div id="col" class="col-width-100">Dirección: Este servicio/producto adicional se activará en el login y plan actual contratado.</div>
            </div>
            <div id="row">
                <div id="col" class="col-width-100">Forma de pago: El cliente acepta que la forma de pago de los servicios adicionales que contrate tendrán la misma forma de pago que el servicio principal de NETLIFE contratado.</div>
            </div>
        </div>


        <div style="clear: both;"></div><br /><br/>
        <div class="labelBlock"  style="$!fontSize" >DATOS DE CONTACTO</div>
           <div id="contenedor" class="col-width-100" style="$!fontSize">
            <div >
                 <div id="row">
                <div id="col" class="col-width-15">Persona contacto:</div>
                <div id="col" class="col-width-18 labelGris">$!personaContacto<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-15">Teléfono contacto:</div>
                <div id="col" class="col-width-16 labelGris">$!celularContacto<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-20">Teléfono fijo contacto:</div>
                <div id="col" class="col-width-10 labelGris">$!telefonoContacto<span class="textPadding"></span></div>
             </div>
            </div>
        </div>
            <div style="clear: both;"></div><br/><br/>
            </div>
            <div style="col-width-100;  vertical-align:top;">
            <div class="labelBlock" style="margin: 0; border:1px black solid; $!fontSize">SERVICIO/PRODUCTO ADICIONAL CONTRATADO</div>
                <table class="box-section-content col-width-100 borderTable" style="border-collapse:collapse; border-spacing:0;">
                    <tr>
                    <td class="labelBlock textCenter" style="width: 39%; $!fontSize"><b>SERVICIO</b></td>
                    <td class="labelBlock textCenter" style="width: 10%; $!fontSize"><b>CANTIDAD</b></td>
                    <td class="labelBlock textCenter" style="width: 13%; $!fontSize"><b>VALOR UNICO</b></td> 
                    <td  class="labelBlock textCenter" style="width: 11%; $!fontSize"><b>VALOR MES</b></td>      
                    <td class="labelBlock textCenter" style="width: 14%; $!fontSize"><b>VALOR TOTAL</b></td>
                    <td class="labelBlock textCenter" style="width: 13%; $!fontSize"><b>OBSERVACIONES</b></td>

                    </tr>

                    <tr><td class="line-height labelGris">Netlife Assistance Pro</td><td class="line-height textCenter">$!KO011262Cantidad</td><td class="line-height textCenter">$!KO011262Unica</td><td class="line-height textCenter">$!KO011262Precio</td><td class="line-height textCenter">$!KO011262Total</td><td class="line-height textCenter">$!KO011262Observaciones</td></tr> 
                    <tr>
                        <td class="line-height textCenter" colspan="2" style="border-bottom:2px white solid;">SUBTOTAL:</td>
                        <td class="line-height textCenter">$!subtotalUnico</td>

                        <td class="line-height textCenter">SUBTOTAL:</td>
                        <td class="line-height textCenter">$!subtotal</td>
                        <td class="line-height textCenter" style="border-bottom:2px white solid;"></td>
                    </tr>
                    <tr>
                        <td class="line-height textCenter" colspan="2" style="border-bottom:2px white solid;">IMPUESTOS:
                        </td>
                        <td class="line-height textCenter">$!impUnico</td>
                           <td class="line-height textCenter">IMPUESTOS:</td>
                        <td class="line-height textCenter">$!impuestos</td>
                        <td class="line-height textCenter" style="border-bottom:2px white solid;"></td>
                    </tr>
                    <tr>
                        <td class="line-height textCenter" colspan="2">TOTAL:</td>
                        <td class="line-height textCenter">$!totalUnico</td>
                        <td class="line-height textCenter">TOTAL:</td>
                        <td class="line-height textCenter">$total</td>
                        <td class="line-height textCenter"></td>
                    </tr>
                </table>
            </div>
            </div><div style="clear: both;"><br /></div>
            <div class="col-width-100" style="text-align: justify; $!fontSize">
            <div style="$!fontSize">NETLIFE puede modificar estas condiciones o las condiciones adicionales que se apliquen a un Servicio o Producto con el fin, por ejemplo, de reflejar cambios legislativos, sustitución y/o mejoras en los Servicios prestados. La contratación de nuestros Servicios implica la aceptación de las condiciones descritas a este documento por lo que el cliente entiende y acepta que las ha leído detenidamente y conoce todos sus detalles.</div>

                <br />
                <div> <b>INFORMACION Y CONDICIONES ADICIONALES: </b> </div>
                <br />
                <div style="$!fontSize" class="clausulas">
                    <ul>
                        <li>El cliente conoce, acepta las condiciones aquí descritas, por lo cuál suscribe el presente documento de contratación de servicios adicionales, el cual forma parte del contrato de adhesión bajo la misma forma de pago suscrita entre el cliente y NETLIFE.</li>
                        <br />
                        <li>El cliente conoce, entiende y acepta que ha recibido toda la información referente al servicio(s) /producto(s) adicional(es) contratado(s)  y que está de acuerdo con todos los items descritos en el presente documento. El cliente conoce, entiende y acepta que el servicio contratado con NETLIFE NO incluye cableado interno o configuración de la red local del cliente e incluye condiciones de permanencia mínima en caso de recibir promociones.</li>
                        <br />
                        <li>Los servicios adicionales generan una facturación proporcional al momento de la contratación y luego será de forma recurrente. El servicio adicional estará activo mientras el cliente esté al día en pagos, caso contrario no podrá acceder al mismo por estar suspendido.</li>  
                    </ul>
                </div>

                <br /><br />
                <div  class="clausulas" style="text-align: justify; $!fontSize "><p class="paragraph" align="center" style="text-align:center;vertical-align:baseline"><p class="paragraph" align="center" style="text-align:center;vertical-align:baseline"><span class="normaltextrun"><b><span style="font-size:18.0pt;color:black">CONDICIONES
DE USO PRODUCTO NETLIFE ASSISTANCE PRO</span></b></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:2,'||chr(38)||'quot;335551620'||chr(38)||'quot;:2,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="font-size:18.0pt;color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="886237179" paraeid="{ab5de48e-4df6-4bf1-9688-2898fba61d8b}{222}"><span data-contrast="auto" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="font-size:13.5pt;color:black">Netlife Assistance PRO</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="font-size:13.5pt;color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="851691" paraeid="{ab5de48e-4df6-4bf1-9688-2898fba61d8b}{238}"><span data-contrast="auto" xml:lang="ES-EC"><span class="normaltextrun">Netlife Assistance
Pro es un servicio que brinda soluciones a los problemas técnicos e
informáticos de un negocio para mejorar su operación, disponible para 5
usuarios. Para acceder a él es necesario ingresar dentro de la sección “Netlife
Access” en la página web de Netlife o a store.netlife.net.ec</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="228338338" paraeid="{ab5de48e-4df6-4bf1-9688-2898fba61d8b}{250}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">Este servicio incluye:</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l7 level1 lfo1;tab-stops:list 36.0pt;vertical-align:baseline" paraid="991703357" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{1}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Asistencia guiada de
configuración, sincronización y conexión a red de software o hardware: PC, MAC.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l7 level1 lfo1;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1134155004" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{8}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Revisión, análisis y
mantenimiento del PC/MAC/LINUX/SmartTV/Smartphones/Tablets/Apple TV/Roku, etc.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l6 level1 lfo2;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2139920235" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{23}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Asesoría técnica en
línea las 24 horas vía telefónica o web por </span></span><a href="https://store.netlife.net.ec" target="_blank" style="color:inherit"><span class="normaltextrun"><span style="color:blue;text-decoration:none;text-underline:
none"><span data-contrast="none" xml:lang="ES-EC">store.netlife.net.ec.'||chr(38)||'nbsp;</span></span></span></a><span class="eop"><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l6 level1 lfo2;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1335481814" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{33}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Un servicio de Help
Desk con ingenieros especialistas.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l6 level1 lfo2;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1538086712" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{48}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Se puede ayudar a
reinstalar el Sistema Operativo del dispositivo del cliente, siempre y cuando
se disponga de las licencias y medios de instalación originales
correspondientes.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="603451248" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{55}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">Sistemas Operativos sobre los cuales se brinda soporte a
incidencias son:'||chr(38)||'nbsp;</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l3 level1 lfo3;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2041146197" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{61}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Windows: XP hasta 10,
Windows Server: 2003 hasta 2019, MacOs: 10.6 (Snow Leopard) hasta 10.14
(Mojave), Linux: Ubuntu 19.04, Fedora 30, Open SUSE 15.1, Debian 10.0, Red Hat
8, CentOS 7, iOS: 7.1.2 a 12.3.2, Android: Ice Cream Sandwich 4.0 hasta Pie
9.0, Windows Phone OS: 8.0 hasta 10 Mobile</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="1938267981" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{92}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">Asistencia Hardware:'||chr(38)||'nbsp;</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l5 level1 lfo4;tab-stops:list 36.0pt;vertical-align:baseline" paraid="888618468" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{98}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Los controladores o
software necesarios para el funcionamiento del hardware son responsabilidad del
usuario, sin embargo, se dará apoyo para obtenerlos en caso de ser necesario.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="202253179" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{105}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">Asistencia Software:</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l1 level1 lfo5;tab-stops:list 36.0pt;vertical-align:baseline" paraid="359914594" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{111}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">No incluye
capacitación en el uso del Software. Las licencias y medios de instalación son
a cargo del usuario. Nunca se prestará ayuda sobre software ilegal.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l1 level1 lfo5;tab-stops:list 36.0pt;vertical-align:baseline" paraid="416966146" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{118}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">No incluye
capacitación en el uso del Sistema Operativo y software, únicamente se
solucionarán incidencias puntuales.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="227023966" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{125}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">Para recibir asistencia se dispone de 3(TRES) canales de
atención habilitados las 24(VEINTI CUATRO) horas del día:'||chr(38)||'nbsp;</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l8 level1 lfo6;tab-stops:list 36.0pt;vertical-align:baseline" paraid="968161823" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{131}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Chat, llamada
telefónica y correo electrónico.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="1860977929" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{138}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">El tiempo de atención de los distintos canales son:</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l4 level1 lfo7;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2032228591" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{144}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Chat 30(TREINTA)
segundos, vía telefónica 60(SESENTA) segundos (3920000), y vía correo
electrónico 20(VEINTE) minutos (</span></span><a href="mailto:soporte@store.netlife.net.ec" target="_blank" style="color:inherit"><span class="normaltextrun"><span style="color:blue;text-decoration:none;text-underline:
none"><span data-contrast="none" xml:lang="ES-EC">soporte@store.netlife.net.ec</span></span></span></a><span data-contrast="auto" xml:lang="ES-EC"><span class="normaltextrun">)</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l4 level1 lfo7;tab-stops:list 36.0pt;vertical-align:baseline" paraid="257807352" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{156}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Se mantendrá en la
plataforma durante 60(SESENTA) días, el 100% de las conversaciones chat
levantadas vía web; a través de, </span></span><a href="https://store.netlife.net.ec" target="_blank" style="color:inherit"><span class="normaltextrun"><span style="color:blue;text-decoration:none;text-underline:
none"><span data-contrast="none" xml:lang="ES-EC">store.netlife.net.ec</span></span></span></a><span class="eop"><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="496603241" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{166}"><span data-contrast="none" xml:lang="ES-EC"><span class="normaltextrun"><b><span style="color:black">Netlife Assistance Pro como servicio adicional</span></b></span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop"><span style="color:black">'||chr(38)||'nbsp;</span></span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="658887239" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{178}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Tiene un precio de
$2,99(DOS DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA CON 99/100) más IVA mensual,
que se añade a planes de Internet de Netlife.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1684847273" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{195}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">El primer mes de
servicio, el cliente no pagará el valor total, sino el valor proporcional por
el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación </span><span data-contrast="auto" xml:lang="ES-EC">(Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del
15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span></span><span data-ccp-props="{'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="940775022" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{204}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">El servicio tiene un
tiempo de permanencia mínima de 12(DOCE) meses. En caso de cancelación
anticipada aplica el pago de los descuentos a los que haya accedido el cliente
por promociones, tales como instalación, tarifas preferenciales, etc.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:6,'||chr(38)||'quot;335551620'||chr(38)||'quot;:6,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2133746300" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{213}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">El servicio de Netlife
Assistance Pro, no incluye visitas presenciales, pero si el cliente lo requiere
podrá coordinar dichas visitas por un costo adicional de $30(TREINTA DÓLARES DE
LOS ESTADOS UNIDOS DE AMÉRICA) más IVA en ciudad y $35(TREINTA DÓLARES DE LOS
ESTADOS UNIDOS DE AMÉRICA) más IVA en zonas foráneas (aplica solo para Quito y
Guayaquil).</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:6,'||chr(38)||'quot;335551620'||chr(38)||'quot;:6,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l2 level1 lfo9;tab-stops:list 36.0pt;vertical-align:baseline" paraid="830813234" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{226}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Costo de la hora
adicional después de la primera hora de atención $10(DIEZ DÓLARES DE LOS
ESTADOS UNIDOS DE AMÉRICA) más IVA.</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p>

<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l2 level1 lfo9;tab-stops:list 36.0pt;vertical-align:baseline" paraid="812382011" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{233}"><span data-contrast="auto" xml:lang="ES-EC"><p[if !supportLists]/><span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol"><span style="mso-list:Ignore">·<span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;
</span></span></span><p[endif]/><span class="normaltextrun">Todos los planes Pro y
PYME (según la oferta establecida por Netlife), incluyen Netlife Assistance
Pro, un servicio de asistencia especializada en problemas técnicos e
informáticos, disponible para 5 (CINCO) usuarios. Para acceder a él es
necesario ingresar dentro de la sección “Netlife Access” en la página web de
Netlife o a store.netlife.net.ec.'||chr(38)||'nbsp;</span></span><span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:6,'||chr(38)||'quot;335551620'||chr(38)||'quot;:6,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}"><span class="eop">'||chr(38)||'nbsp;</span></span><o:p></o:p></p><br></p></div></br>

                <br /><br />
                <div>
                El cliente con la sola suscripción voluntaria del presente Adendum confirma que ha leído y conoce las condiciones de uso de los equipos y servicios descritos a ser contratados. La información proporcionada en el presente documento, el cliente autoriza a Megadatos para uso y tratamiento  acorde a la normativa legal vigente a fin al contrato de adhesión.
                </div>

            </div>

            <div style="clear: both;"></div><br /> <br /> <br /> <br /> 
                      <div style="clear: both; $!fontSize"></div>
            <div id="contenedor" class="col-width-100">
                <div id="row">
                    <div id="colCell" class="col-width-50" style="text-align:center">
                        <div id="contenedor" class="col-width-100">
                            <div id="row">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50" style="height:35px">

                                </div>
                                <div id="colCell" class="col-width-25"></div>
                            </div>
                            <div id="row">
                                <div id="colCell" class="col-width-40"></div>
     <form >
                             <div id="colCell" class="col-width-50">
                                    <input id="inputfirma1" name="FIRMA_ADEN_MD_EMPRESA" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/>
                                </div>
        </form>
                         <div id="colCell" class="col-width-10"></div>
                            </div>
                            <div id="row">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50"><hr><span>MEGADATOS</span></div>
                                <div id="colCell" class="col-width-25"></div>
                            </div>
                        </div>
                    </div>
                    <div id="colCell" class="col-width-50" style="text-align:center">
                        <div id="contenedor" class="col-width-100">
                            <div id="row">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50" style="height:35px">

                                </div>
                                <div id="colCell" class="col-width-25"></div>
                            </div>
                            <div id="row">
                                <div id="colCell" class="col-width-40"></div>
          <form >
                        <div id="colCell" class="col-width-60">
                                    $!nombresApellidosFirma 
                                    <input id="inputfirma2" name="FIRMA_ADEN_MD_CLIENTE" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/>
                                </div>
                                <div id="colCell" class="col-width-10"></div>
      </form>
                         </div>
                            <div id="row">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50"><hr><span>Firma del Cliente</span></div>
                                <div id="colCell" class="col-width-25"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                      <div style="clear: both;"></div> 
            <div id="contenedor" class="col-width-100">
                <div>
                    <div id="colCell" class="col-width-50" style="text-align:right $!fontSize"> $!versionTitulo<div>  
                    <div id="colCell" class="col-width-10" style="text-align:right">$!versionFecha</div>
                </div>
            </div>
    </body>
</html>

');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'adendumMegaDatos';

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'adendumMegaDatos';

COMMIT;
END;
/