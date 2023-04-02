/**
* actulizacion plantillas para descripcion ecuanet
* @author wdsanchez <wdsanchez@telconet.ec>
* @version 1.0 28-03-2023.
*/

--1er
      update DB_comunicacion.Admi_Plantilla set plantilla = 
                 '<html>
  <head>
  </head>
  <body>
    <table width=''100%'' border=''0'' bgcolor=''#ffffff''>
      <tr>
	<td>
	      <table width=''100%'' border=''0'' cellspacing=''1'' cellpadding=''0'' bgcolor=''#ffffff''>
	      <tr>
		<td align=''center'' style=''border:1px solid #000000;background-color:#e5f2ff;''>
		      {% if strEmpresa == ''TELCONET S.A.'' %}
		      <img src=''http://images.telconet.net/rp_telco_logo.png''/>
	    {% endif %}
		{% if strEmpresa == ''NETLIFE'' %}
		      <img src=''http://images.telconet.net/others/telcos/logo_netlife.png''/>
	    {% endif %}
		
		{% if strEmpresa == ''ECUANET'' %}
		      <img src=''http://images.telconet.net/others/telcos/logo_ecuanet.png''/ width="172" height="47" >
	    {% endif %}
		
		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a reanudar la gestion de su tarea trav'||chr(38)||'eacute;s del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
		    el cual se detalla acontinuaci'||chr(38)||'oacute;n:<br/><br/>
		    <table cellpadding="10">
			<tr>
			  <td><strong>Tipo de Caso</strong></td>
			  <td>{{tipoCaso}}</td>
			</tr>
			<tr>
			  <td><strong>Ingresado por:'||chr(38)||'nbsp;</strong></td>
			  <td>{{usrCreacion}}</td>
			</tr>
			<tr>
			  <td><strong>Departamento Asignado:'||chr(38)||'nbsp;</strong></td>
			  <td>{{departamentoAsignado}}</td>
			</tr>
			<tr>
			  <td><strong>Persona Asignada:'||chr(38)||'nbsp;</strong></td>
			  <td>{{personaAsignada}}</td>
			</tr>		      
			<tr>
			  <td><strong>Cliente Afectado:'||chr(38)||'nbsp;</strong></td>
			  <td>{{cliente}}</td>
			</tr>
			<tr>
			  <td><strong>Direcci'||chr(38)||'oacute;n Punto:'||chr(38)||'nbsp;</strong></td>
			  <td>{{direccion}}</td>
			</tr>
			<tr>
			  <td><strong>Descripci'||chr(38)||'oacute;n Punto:'||chr(38)||'nbsp;</strong></td>
			  <td>{{descripcion}}</td>
			</tr>
			<tr>
			  <td><strong>Problemas:'||chr(38)||'nbsp;</strong></td>
			  <td>
			    <table>			      
				  {% for sintoma in sintomas  %}
				    <tr><td>{{sintoma.nombre_sintoma}}</td></tr>
				  {% endfor %} 
			    </table>
			  </td>			  
			</tr>
			<tr>
			  <td><strong>Motivo:</strong></td>
			  <td>{{observacion}}</td>
			</tr>
		     </table><br/>
		      <strong>Version Inicial:</strong><br/>
		      -------------------------------------------------------------------------<br/>  
		      {{caso.versionIni}}  
		      <br/><br/><br/><br/> 
                      <p><b>NOTA:</b> Favor no responder este mensaje que ha sido emitido autom'||chr(38)||'aacute;ticamente.</p>
		      Seguros de contar con su amable atenci'||chr(38)||'oacute;n,<br/><br/>
		      Atentamente,<br/><br/>
		      <strong>{{strEmpresa}}</strong>
		      
		  </td>
		</tr>
	    </table>
	</td>
      </tr>
    </table>
  </body>
</html>	' 
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASOREANUDACLI';
                 
commit;                 
/
