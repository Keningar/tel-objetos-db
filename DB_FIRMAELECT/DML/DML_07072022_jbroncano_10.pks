/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de plantilla ADENDUM SERVICIOS / PRODUCTOS ADICIONALES
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:='<!DOCTYPE html>';
BEGIN
DBMS_LOB.APPEND(bada, '
<!DOCTYPE html>
<html>
    <head>
        <title>Requerimientos de Servicios</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style type="text/css">
             @page {
            margin-top: 0.21cm;
            margin-left: 0.10cm; 
            margin-right: 0.10cm; 
           
            size: B4 portrait; 
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
            .col-width-1 {
                width: 1% !important;
            }
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
    ');

    DBMS_LOB.APPEND(bada,'
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
        </div>
    </div>

        <br/>


        <div style="clear: both;"></div>
        <div style="$!fontSize" class="labelBlock">DATOS DEL CLIENTE</div>

        <div id="contenedor" class="col-width-100" style="$!fontSize">
            <div id="row">
                <div id="col" class="col-width-15">Nombre del cliente:</div>
                <div id="col" class="col-width-50 labelGris">$!nombresApellidos<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-5">CI:</div>
                <div id="col" class="col-width-25 labelGris">$!cedula<span class="textPadding"></span></div>
            </div>
            <div id="row">
                <div id="col" class="col-width-15">Razón social:</div>
                <div id="col" class="col-width-50 labelGris">$!razonSocial<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-5">RUC:</div>
                <div id="col" class="col-width-25 labelGris">$!ruc<span class="textPadding"></span></div>
            </div>
            <div id="row">
                <div id="col" class="col-width-15">Login:</div>
                <div id="col" class="col-width-50 labelGris">$!loginPunto<span class="textPadding"></span>
            </div>

            </div>
            <div id="row">
                <div id="col" class="col-width-15">Plan actual contratado:</div>
                <div id="col" class="col-width-50 labelGris">$!nombrePlan<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col"   class="col-width-6">Correo:</div>
                <div id="col" class="col-width-24 labelGris">$!correoCliente<span class="textPadding"></span>
            </div>

            </div>
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
                <div id="col" class="col-width-15">Persona contacto:</div>
                <div id="col" class="col-width-18 labelGris">$!personaContacto<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-16">Teléfono contacto:</div>
                <div id="col" class="col-width-16 labelGris">$!celularContacto<span class="textPadding"></span></div>
                <div id="col" class="col-width-2-5"></div>
                <div id="col" class="col-width-15">Teléfono fijo contacto:</div>
                <div id="col" class="col-width-10 labelGris">$!telefonoContacto<span class="textPadding"></span></div>
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
                                                                
                    {{listaProductos}} 
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
                {{listaTerminosProductos}}

                <br /><br />
                <div>
                El cliente con la sola suscripción voluntaria del presente Adendum confirma que ha leído y conoce las condiciones de uso de los equipos y servicios descritos a ser contratados. La información proporcionada en el presente documento, el cliente autoriza a Megadatos para uso y tratamiento  acorde a la normativa legal vigente a fin al contrato de adhesión.
                </div>

            </div>

            <div style="clear: both;"></div><br /> <br /> <br /> <br /> 
            
            <div style="clear: both; $!fontSize"></div>
            <div id="contenedor" class="col-width-100">
                <div id="row">
                  <form >
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
                                <div id="colCell" class="col-width-50">
                                    <input id="inputfirma1" name="FIRMA_ADEN_MD_EMPRESA" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/>
                                </div>
                                  
                                <div id="colCell" class="col-width-10"></div>
                            </div>
                            <div id="row" style="$!fontSize">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50"><hr><span >MEGADATOS</span></div>
                                <div id="colCell" class="col-width-25"></div>
                            </div>
                        </div>
                    </div>
                    </form>
                    <div id="colCell" class="col-width-50" style="text-align:center">
                      <form >
                        <div id="contenedor" class="col-width-100">
                            <div id="row">
                                <div id="colCell" class="col-width-25"></div>
                                <div id="colCell" class="col-width-50" style="height:35px">

                                </div>
                                <div id="colCell" class="col-width-15"></div>
                            </div>
                            <div id="row">                           
                                <div id="colCell" class="col-width-1"> </div>                                      
                                    <div id="colCell" class="col-width-80" style="$!fontSize">
                                       $!nombresApellidosFirma                                  
                                         <input class="col-width-5" id="inputfirma2" name="FIRMA_ADEN_MD_CLIENTE" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/>                                     
                                    </div>
                                  <div id="colCell" class="col-width-20"> </div> 
                             
                            </div>
                            <div id="row" style="$!fontSize">                              
                                    <div id="colCell" class="col-width-20"></div>
                                    <div id="colCell" class="col-width-30"><hr><span>Firma del Cliente</span></div>
                                    <div id="colCell" class="col-width-20"></div>
                            </div>
                        </div>
                      </form>
                    </div>
                </div>
            </div>
            <div style="clear: both;"></div> 
            <div id="contenedor" class="col-width-100">
                <div>
                    <div id="colCell" class="col-width-10" style="text-align:right; $!fontSize">$!versionFecha</div>
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
