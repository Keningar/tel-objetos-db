/**
 * Reverso de los parametros para el proceso de actualizacion de plantilla descripcion ecuanet
 *
 * @author wdsanchez <wdsanchez@telconet.ec>
 * @version 1.0 09-03-2023
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
		
		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a dar inicio a la tarea a trav'||chr(38)||'eacute;s del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
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
</html>' 
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASOINICIACLI';
                 
                 
                 
                 --2do
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
		

		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a pausar la gestion de su tarea a trav'||chr(38)||'eacute;s del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
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
</html>' 
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASOPAUSACLI';
                 
--3er
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
		

		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a rechazar la gestion de su tarea a trav'||chr(38)||'eacute;s del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
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
</html>' 
                 , USR_ULT_MOD= 'janavarretej' 
                 where codigo = 'CASORECHAZACLI';   
                 
                 
--4to
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
		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a cancelar la gestion de su tarea a trav'||chr(38)||'eacute;s del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
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
</html>' 
                 , USR_ULT_MOD= 'janavarretej' 
                 where codigo = 'CASOCANCELACLI';  
                 
                 
--5to
    
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

		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a reprogramar la gestion de su tarea a trav'||chr(38)||'eacute;s del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
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
</html>' 
                 , USR_ULT_MOD= 'janavarretej' 
                 where codigo = 'CASOREPROGRACLI'; 

--6to


--6to
 
  update DB_comunicacion.Admi_Plantilla set plantilla = 
              to_clob('<html>
  <head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">

 <style type="text/css">
                    table.cssTable { 
                      font-family: verdana,arial,sans-serif;
                      font-size:11px;color:#333333;border-width: 1px;border-color: #999999;border-collapse: collapse;
                    }table.cssTable th {
                      background-color:#c3dde0;border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;
                    }table.cssTable tr {
                      background-color:#d4e3e5;
                    }table.cssTable td {
                      border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;
                    }table.cssTblPrincipal{
                     font-family: verdana,arial,sans-serif;font-size:12px;
                    }
                    </style>

  </head>
  <body>
    <table align="center" width="100%" cellspacing="0" cellpadding="5">
      <tr>
        <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
            <img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo.png"/>
            {#<img alt=""  src="https://telcos.telconet.ec/public/images/logo.png"/>#}
        </td>
      </tr>
      <tr>
        <td style="border:1px solid #6699CC;">
          <table width="100%" cellspacing="0" cellpadding="5">
            <tr>
                <td colspan="2">Estimado personal,</td>
            </tr>
            <tr>
              <td colspan="2">
                El presente correo es para indicarle que el departamento al que pertenece creo el siguiente CASO: 
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                <strong>Caso # {{ caso.numeroCaso}}</strong>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
              <tr>
              <td>
                <strong>Afectación:</strong>
              </td>
           </tr>
           
           <tr>')||to_clob('
		<td colspan="2">
                                      <table class = "cssTable"  align="center" >
                                          <tr>                  
                                              <th> Tipo Afectacion </th>
                                              <th> Nombre Afectado <br></th>
                                              <th> Descripcion Afectado <br></th>                                                             
                                         </tr>
                                          {% for afectado in afectadoPadre  %}
                                           <tr>                  
                                              <td> {{ afectado.tipoAfectado}} </td>
                                              <td> {{ afectado.afectadoNombre}} </td>
                                              <td> {{ afectado.afectadoDescripcion}} </td>                                                             
					  </tr>
                                          {% endfor %} 
                                      </table>
                               </td>
           </tr>    
           
            {% if tieneDetalle  %}
           
            <tr>
              <td>
                <strong>Detalle Afectación:</strong>
              </td>
           </tr>
           
            <tr>
	      <td colspan="2">
		    <table class = "cssTable"  align="center" >
			<tr>                  
			    <th> Afectacion </th>
			    <th> Nombre <br></th>
			    <th> Descripcion <br></th>                                                             
			</tr>
			{% for afectado in afectadoDetalle %}
			  <tr>                  
			    <td> {{ afectado.tipoAfectado}} </td>
			    <td> {{ afectado.afectadoNombre}} </td>
			    <td> {{ afectado.afectadoDescripcion}} </td>                                                             
			</tr>
			{% endfor %} 
		    </table>
	      </td>
           </tr>
           
           {% endif %}
            <tr>
              <td>
                <strong>Fecha de creacion:</strong>
              </td>
              <td>{{caso.feApertura | date("d-M-Y") }} | {{ caso.feApertura | date("H:i")  }}</td>
            </tr>
            <tr>
              <td>
                <strong>Usuario de Creacion:</strong>
              </td>
              <td>{{ empleadoLogeado }}</td>
            </tr>
            <tr>
              <td>
                <strong>Version Inicial:</strong>
              </td>
              <td>{{ caso.versionIni }}</td>
            </tr>
            <tr>
              <td>
                <strong>Titulo Inicial:</strong>
              </td>
              <td>{{ caso.tituloIni }}</td>
            </tr>
            <tr>
              <td colspan="2"><br/></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
          <td>')||chr(38)||to_clob('nbsp;
          </td>
      </tr>
      <tr>
          <td>Por favor revisar el caso <a href="https://telcos.telconet.ec/soporte/info_caso/{{caso.id}}/show">{{caso.numeroCaso}}</a>
          </td>   
      </tr>
      <tr>
          {% if empresa == ''TTCO'' %}
          <td><strong><font size=''2'' face=''Tahoma''>TransTelco S.A.</font></strong></p>
          {% elseif empresa == ''MD'' %}
          <td><strong><font size=''2'' face=''Tahoma''>MegaDatos S.A.</font></strong></p>
          {% else %}
          <td><strong><font size=''2'' face=''Tahoma''>Telconet S.A.</font></strong></p>
          {% endif %}
          </td>   
      </tr>  
    </table>
  </body>
</html>')
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASO';   
                 
--7to

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
		
		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa que se ha procedido a ingresar su incidencia a traves del Caso con n'||chr(38)||'uacute;mero <b>{{caso.numeroCaso}}</b>,  
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
			  <td><strong>Fecha Apertura Incidencia:'||chr(38)||'nbsp;</strong></td>
			  <td>{{caso.feApertura | date("d-M-Y") }} | {{ caso.feApertura | date("H:i")  }}</td>
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
</html>'
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASO_CLIENTE'; 
                 
                 
  --8to
 
 update DB_comunicacion.Admi_Plantilla set plantilla = 
              to_clob('<html>
  <head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
  </head>
  <body>
    <table align="center" width="100%" cellspacing="0" cellpadding="5">
      <tr>
        <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
            <img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo.png"/>
            {#<img alt=""  src="https://telcos.telconet.ec/public/images/logo.png"/>#}
        </td>
      </tr>
      <tr>
        <td style="border:1px solid #6699CC;">
          <table width="100%" cellspacing="0" cellpadding="5">
            <tr>
                <td colspan="2">Estimado personal,</td>
            </tr>
            <tr>
              <td colspan="2">
                El presente correo es para indicarle que se ingreso un nuevo seguimiento: 
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                <strong>Caso # {{ caso.numeroCaso}}</strong>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            <tr>
              <td>
                <strong>Afectados:</strong>
              </td>
              <td>
                    {% for afectado in afectados %}
                            {{ afectado.afectadoNombre}}  {{ afectado.afectadoDescripcion}}
                    {% else %}
                        No existen afectados definidos.
                    {% endfor %}
              </td>
            </tr>
            <tr>
              <td>
                <strong>Fecha de creacion:</strong>
              </td>
              <td>{{caso.feApertura | date("d-M-Y") }} | {{ caso.feApertura | date("H:i")  }}</td>
            </tr>
            <tr>
              <td>
                <strong>Fecha de asignacion:</strong>
              </td>
              <td>{{asignacion.feCreacion | date("d-M-Y") }} | {{ asignacion.feCreacion | date("H:i")  }}</td>
            </tr>
            <tr>
              <td>
                <strong>Usuario que asigna:</strong>
              </td>
              <td>{{ empleadoLogeado }}</td>
            </tr>
            <tr>
              <td>
                <strong>Asignado:</strong>
              </td>
              <td>{{asignacion.asignadoNombre }}{% if(asignacion.refAsignadoNombre!="")%}-{{asignacion.refAsignadoNombre}}{%endif%}</td>
            </tr>
            <tr>
              <td>
                <strong>Version Inicial:</strong>
              </td>
              <td>{{ caso.versionIni }}</td>
            </tr>
            <tr>
              <td>
                <strong>Titulo Inicial:</strong>
              </td>
              <td>{{ caso.tituloIni }}</td>
            </tr>
            <tr>
              <td>
                <strong>Seguimiento:</strong>
              </td>
              <td>{{ seguimiento }}</td>
            </tr>
            <tr>
              <td colspan="2"><br/></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
          <td>')||chr(38)||to_clob('nbsp;
          </td>
      </tr>
      <tr>
          <td>Por favor revisar el caso <a href="https://telcos.telconet.ec/soporte/info_caso/{{caso.id}}/show">{{caso.numeroCaso}}</a>
          </td>   
      </tr>
      <tr>
          {% if empresa == ''TTCO'' %}
          <td><strong><font size=''2'' face=''Tahoma''>TransTelco S.A.</font></strong></p>
          {% elseif empresa == ''MD'' %}
          <td><strong><font size=''2'' face=''Tahoma''>MegaDatos S.A.</font></strong></p>
          {% else %}
          <td><strong><font size=''2'' face=''Tahoma''>Telconet S.A.</font></strong></p>
          {% endif %}
          </td>   
      </tr>  
    </table>
  </body>
</html>')
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASOSEGU'; 
                 
                 --9no

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
		
		</td>
	      </tr>
	      <tr>
		<td>'||chr(38)||'nbsp;</td>
	      </tr>
	      <tr>
		  <td>
		    Estimado Cliente,<br/><br/>
		    Por medio del presente {{strEmpresa}} le informa el avance de su Caso <b>{{caso.numeroCaso}}</b>, el cual se detalla acontinuaci'||chr(38)||'oacute;n:<br/><br/>
		    <table cellpadding="10">	
      			<tr>
			  <td><strong>Tipo de Caso</strong></td>
			  <td>{{tipoCaso}}</td>
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
			  <td><strong>Tarea en Ejecuci'||chr(38)||'oacute;n:</strong></td>
			  <td>{{tarea}}</td>
			</tr>
			<tr>
			  <td><strong>Fecha Avance:'||chr(38)||'nbsp;</strong></td>
			  <td>{{fecha | date("d-M-Y") }} | {{ fecha | date("H:i")  }}</td>
			</tr>
			<tr>
			  <td><strong>Registrado por:'||chr(38)||'nbsp;</strong></td>
			  <td>{{usrCreacion}}</td>
			</tr>						
		     </table><br/>
		      <strong>Avance:</strong><br/>
		      -------------------------------------------------------------------------<br/>  
		      {{seguimiento}}  
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
</html>'
                 , USR_ULT_MOD= 'wdsanchez' 
                 where codigo = 'CASOSEGUI_CLIE';  
                                                 

COMMIT;

/
