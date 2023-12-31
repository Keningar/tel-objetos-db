/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de plantilla Pagaré
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
		<title>Pagaré; - Netlife</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <style type="text/css">
          @page {
            margin-top: 1cm;
            margin-left: 0.10cm; 
            margin-right: 0.50cm; 
           
            size: B4 portrait; 
          }
            *{
                font-family:"Helvetica";
            }
            body
            {
                width: 98%;
                margin: 8px;
                font-size:11px;
            }
            #bienvenido
            {
                font-weight: bold;
                font-size:28px;
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
                font-size:12px;
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
                text-align: left;
                display:inline-block;
                vertical-align: top;
                width: 100%;
            }
            .line-height,.labelBlock,#col{
                height: 18px;
                line-height: 18px;
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
                padding-left: 3px;
                padding-right: 3px;
            }
            .borderTable th,.borderTable td {
                border: 1px solid black;
            }

 /* // ==========================================               // Viñetas para las clausulas
               // ==========================================*/
            .clausulas ul {
                list-style: none; /* Remove list bullets */
                padding: 0;
                margin: 0;
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
          .col-width-3{
                width: 3% !important;
            }
            .col-width-4{
                width: 4% !important;
            }
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
             .col-width-12{
                width: 12% !important;
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
            .col-width-20{
                width: 20% !important;
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
            .col-width-31{
                width: 31% !important;
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
              .col-width-38{
                width: 38% !important;
            }
            .col-width-40{
                width: 40% !important;
            }
            .col-width-45{
                width: 45% !important;
            }
            .col-width-50{
                width: 50% !important;
            }
            .col-width-55{
                width: 55% !important;
            }
            .col-width-60{
                width: 60% !important;
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
	</head>
            ');

    DBMS_LOB.APPEND(bada,'
   <body style="$!fontSize">
		<!-- ================================ -->
        <!-- Logo Netlife y numero de contato -->
        <!-- ================================ -->
        <div align="center" style="float: right;">
            <table id="netlife" style="padding-right: 30px; ">
                <tr>
                    <td align="center" style ="font-size:14px">
						<img src="http://images.telconet.net/others/telcos/logo_netlife.png" alt="log" title="NETLIFE" height="40"/>
						<br/>
						Telf: 3920000
                    </td>
                </tr>
                <tr></tr>
                <tr><td align="center" style="font-size:20px">$numeroContrato</td></tr>
            </table>
        </div>
		<!-- ========================================== -->
		<!-- Pagare									    -->
        <!-- ========================================== -->
        <br/>
        <div style="clear: both;"></div>
        <div class="labelBlock">PAGARÉ A LA ORDEN</div>
		<div style="text-align: justify;">
            <span>
                Debo y pagaré; de forma incondicional,irrevocable e indivisible a la orden de MEGADATOS S.A.  a partir de la suscripción del presente documento por concepto de equipamiento,la cantidad de dinero que reconozco adeudarle que asciende a un total de:
            </span>
        </div>
        <div id="contenedor" class="col-width-100">           
        <div id="row">
                  <div id="col" class="col-width-25 labelGris">
                  <span class="textPadding">$!valorPlanLetras</span>
                  </div>
                  <div id="col" class="col-width-38">
                      <div class="box-label">DOLARES DE LOS ESTADOS UNIDOS DE AMERICA ($</div>
                  </div>
                  <div id="col" class="col-width-5 labelGris">
                     <span class="textPadding box-label">$!valorPlanNumeros</span>
                  </div>
                 <div id="col" class="col-width-28">
                      <div class="box-label">,00). Me obligo a pagar adicionalmente </div>
                  </div>
             </div>
        </div>
        <br/>
        <div style="text-align: justify; $!fontSize">
            <span>
               todos los gastos judiciales y extrajudiciales inclusive honorarios profesionales que ocasione el cobro. Al fiel cumplimiento de lo estipulado me obligo con todos mis bienes presentes y futuros. El pago de este Pagaré; no podrá hacerse por partes. A partir del vencimiento,pagaré; la tasa de mora máxima permitida por la ley.
            </span>
        </div>

		<div style="text-align: justify; $!fontSize">
            <span>
                Renuncio expresamente a fuero y me someto a los jueces competentes de la ciudad de $!ciudadPagare y al trámite ejecutivo o verbal sumario,a la elección del actor. Sin protesto, exímase de presentación para el pago y de avisos por falta de pago.
            </span>
        </div>
		<br/>
		<div id="contenedor" class="col-width-100">
           
            <div id="row"  style="$!fontSize">
                <div id="col" class="col-width-12">
                    <div class="box-label">En la ciudad de</div>
                </div> 
          
				        <div id="col" class="col-width-30 labelGris">
					          <span class="textPadding">$!ciudadPagare</span>
                </div>
                <div id="col" class="col-width-5">
                    <div class="box-label"> a los </div>
                </div>
				       <div id="col" class="col-width-10 labelGris">
					          <span class="textPadding">$diaActual</span>
                </div>
                <div id="col" class="col-width-14">
                    <div class="box-label"> días del mes de </div>
                </div>
				        <div id="col" class="col-width-5 labelGris">
					           <span class="textPadding">$mesActual</span>
                </div>
				        <div id="col" class="col-width-10">
                    <div class="box-label"> del año </div>
                </div>
				        <div id="col" class="col-width-5 labelGris">
					         <span class="textPadding">$anioActual</span>
                </div>
            </div>
        </div>
		<br/>
		<div id="contenedor" class="col-width-100">
            <div id="row">
                <div id="col" class="col-width-12">
                    <div class="box-label">Vencimiento</div>
                </div>
				<div id="col" class="col-width-30 labelGris">
					<span class="textPadding"></span>
                </div>
            </div>
        </div> <!-- ========================================== -->        <!-- Firma del Cliente  -->
        <!-- ========================================== -->
		<br/>
		<br/>
		<br/>
        <div style="clear: both;"></div>
        <div id="contenedor" class="col-width-100">
            <div id="row">
                <div id="colCell" class="col-width-50" style="text-align:center">
                    <div id="contenedor" class="col-width-100">
                        <div id="row" >
                            <div id="colCell" class="col-width-25"></div>
                            <div id="colCell" class="col-width-50" style="height:80px">

                            </div>
                            <div id="colCell" class="col-width-25"></div>
                        </div>
                        <div id="row" >
                            <div id="colCell" class="col-width-25"></div>
                            <div id="colCell" class="col-width-50"></div>
                            <div id="colCell" class="col-width-25"></div>
                        </div>
                        <div id="row">
                            <div id="colCell" class="col-width-25"></div>
                            <div id="colCell" class="col-width-50"></div>
                            <div id="colCell" class="col-width-25"></div>
                        </div>
                    </div>
                </div>
                <form >
                <div id="colCell" class="col-width-50">
                    <div id="contenedor" class="col-width-100" style="$!fontSize">
                        <div id="row" >
                            <div id="col" class="col-width-25"><span>Firma:</span><input id="inputfirma1" name="FIRMA_CONT_MD_PAGARE" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/></div>
                            <div id="col" class="col-width-50">
                              </br>
                                <hr/>
                            </div>
                            <div id="col" class="col-width-25"></div>
                        </div>
                        <div id="row" style="$!fontSize" >
                            <div id="col" class="col-width-25">Nombre:</div>
                            <div id="col" class="col-width-70 labelGris">
                                <span class="textPadding">$nombresApellidos</span>
                            </div>
                            <div id="col" class="col-width-25"></div>
                        </div>
                    </div>
                </div>
            </form>
            </div>
            
        </div>
        <div  style="float:right; min-width: 120px; text-align:center;">
            <div id="row" >
                <div id="col" class="col-width-100" style="text-align:center; $!fontSize">
                    $!versionTitulo
                </div>        
                <div id="col" class="col-width-100" style="text-align:center; $!fontSize">
                    $!versionFecha
                </div>
            </div>
        </div>
	</body>
</html>
');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'pagareMegadatos';

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'pagareMegadatos';

COMMIT;
END;
/