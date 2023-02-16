/**
 * se debe ejecutar en DB_FIRMAELECT 
 * actualizacion de plantilla Autorización para Débito
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
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
<!DOCTYPE html><html>
	<head>
		<title>Autorización para Débito - Netlife</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <style type="text/css">
           @page {
            margin-top: 1cm;
            margin-left: 0.30cm; 
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
            div.labelGris {
                  height: 1em;
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
            }

            .clausulas li:before {
                content: "-";
                padding-right: 5px;           } /* // ==========================================
               // Clases de manejo de tamaño de columnas
               // ==========================================*/

            .col-width-5{
                width: 5% !important;
            }
            .col-width-10{
                width: 10% !important;
            }
            .col-width-15{
                width: 15% !important;
            }
            .col-width-20{
                width: 20% !important;
            }
           .col-width-22{
                width: 22% !important;
            }
            .col-width-21{
                width: 21% !important;
            }
            .col-width-23{
                width: 23% !important;
            }
            .col-width-25{
                width: 25% !important;
            }
            .col-width-24{
                width: 24% !important;
            }
            .col-width-30{
                width: 30% !important;
            }
            .col-width-35{
                width: 35% !important;
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
        <div style="clear: both;"></div>
		<!-- ================================================================= -->
        <!-- Autorización para Debito por concepto de pago del servicio -->
        <!-- ================================================================= -->
        <div class="labelBlock">AUTORIZACIÓN PARA DÉBITO POR CONCEPTO DE PAGO DEL SERVICIO</div>
		<div id="contenedor" class="col-width-100" >
			<div id="row">
		        <div id="col" class="col-width-20">
                    Señores (Banco/Tarjeta):
                </div>
		        <div id="col" class="col-width-50 labelGris">
					<span class="textPadding">$!nombreBanco</span>
                </div>
				<div id="col" class="col-width-5">
					<span class="textPadding"></span>
                </div>
				<div id="col" class="col-width-5">
                    Fecha:
                </div>
		        <div id="col" class="col-width-15 labelGris">
                    <span class="textPadding">$!fechaActualAutDebito</span>
                </div>
		    </div>
            <div id="row">
		        <div id="col" class="col-width-5">
                    Yo:
                </div>		        <div id="col" class="col-width-55 labelGris">
					<span class="textPadding">$!nombreTitular</span>
                </div>
				<div id="col" class="col-width-5">
					<span class="textPadding"></span>
                </div>
				<div id="col" class="col-width-10">
                    CI:
                </div>
		        <div id="col" class="col-width-20 labelGris">
                    <span class="textPadding">$!identificacionAutDebito</span>
                </div>
		    </div>
			<div id="row">
		        <div id="col" class="col-width-40">
                    Autorizo a MEGADATOS a debitar de mi cuenta:
                </div>
				<div id="col" class="col-width-15">
                    <div class="box">$isCuentaCorriente</div>
					<div class="box-label">Corriente</div>
                </div>
		        <div id="col" class="col-width-20">
                    <div class="box">$isTarjetaCredito</div>
					<div class="box-label">Tarjeta de Crédito</div>
                </div>
                <div id="col" class="col-width-20">
                    <div class="box">$isCuentaAhorros</div>
					<div class="box-label">Ahorros</div>
                </div>
		    </div>
			<div id="row">
		        <div id="col" class="col-width-15">
                    Número:
                </div>
				<div id="col" class="col-width-65 labelGris">
                    <span class="textPadding">$!numeroCuenta</span>
                </div>
		    </div>
			<div id="row">
		        <div id="col" class="col-width-30"></div>
              <div id="col" class="col-width-5">
                <span class="textPadding"></span>
               </div>
              <div id="col" class="col-width-25">
                          Fecha de Expiración:
               </div>
              <div id="col" class="col-width-20 labelGris">
                      <span class="textPadding">$!fechaExpiracion</span>
              </div>
		       </div>

		</div>
            
        <div style="text-align: justify;">
            <span>
                El valor de los servicios y el pago respectivo a MEGADATOS S.A. por concepto de todos los valores estipulados en el contrato firmado entre las partes. Me comprometo a mantener fondos suficientes y disponibles para cubrir dicho pago. Al acreditar al beneficiario agradeceré mencionar como referencia lo siguiente:  PAGO EFECTUADO A MEGADATOS S.A. POR SERVICIOS.
            </span>
        </div>
        <br/>
		<br/>
		<br/>
        <div style="clear: both;"></div>
        <form>
        <div id="contenedor" class="col-width-100">
            <div id="row">
				<div id="colCell" class="col-width-30" style="text-align:center">
                    <div id="contenedor" class="col-width-80">
                        <div id="row" >
                          <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                            <div id="colCell" class="col-width-5"></div>
                        </div>
                        <div id="row" >
                            <div id="colCell" class="col-width-30"></div>
                            <div id="colCell" class="col-width-10"></div>
                        </div>
                        <div id="row">
                             <div id="colCell" class="col-width-10"></div>
                            <div id="colCell" class="col-width-10"><input id="inputfirma1" name="FIRMA_CONT_MD_AUT_DEBITO" type="text" value="" style="background-color:#fff; width:0.0em; margin-left:0.75em; border-style: hidden; opacity:0; border:none;" readonly/></div>
                            <div id="colCell" class="col-width-40"><hr><span>Firma del Cliente</span></div>
                            
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
        </form>
        <div style="clear: both;"></div><br /><br />
        <br />
        <div style="clear: both;"></div>
        <div  style="float:right; min-width: 120px; text-align:center;">
            <div id="row" >
                <div id="col" class="col-width-100" style="text-align:center; font-size:9px;">
                    $!versionTitulo
                </div>        
                <div id="col" class="col-width-100" style="text-align:center; font-size:9px;">
                    $!versionFecha
                </div>
            </div>
        </div>
	</body>
</html>
');

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML=EMPTY_CLOB()
where COD_PLANTILLA = 'debitoMegadatos';

UPDATE DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
SET HTML= bada
where COD_PLANTILLA = 'debitoMegadatos';

COMMIT;
END;
/