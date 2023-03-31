/**
 * Reverso de los parametros para el proceso de actualizacion de plantilla descripcion ecuanet
 *
 * @author wdsanchez <wdsanchez@telconet.ec>
 * @version 1.0 09-03-2023
 */

--1ro
  update DB_comunicacion.Admi_Plantilla set plantilla = 
                 '<html>
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
                El presente correo es para indicarle que se asigno la siguiente TAREA: 
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                <strong>Actividad # {{ actividad.id }}</strong>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>   
             <tr>
                <td>
                   <strong>Nombre Proceso:</strong>
                </td>
                <td>
		    {{ nombreProceso }}
                </td>
            </tr>
            <tr>
                <td>
                   <strong>Nombre Tarea:</strong>
                </td>
                <td>
		    {{ nombreTarea }}
                </td>
            </tr>
             <tr>
              <td colspan="2">
                <hr />
              </td>
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
                <strong>Observacion:</strong>
              </td>
              <td>{{ asignacion.motivo | raw  }}</td>
            </tr>
            <tr>
              <td colspan="2"><br/></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
          <td>'||chr(38)||'nbsp;
          </td>
      </tr>
      <tr>
          <td>Por favor revisar la Actividad <a href="https://telcos.telconet.ec/soporte/call_activity/{{ actividad.id }}/show">{{ actividad.id }}</a>
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
</html>' , USR_ULT_MOD= 'wdsanchez' where codigo = 'TAREAACT';

--2do

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
                El presente correo es para indicarle que se reasigno a su departamento la siguiente TAREA: 
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            
            <tr>
                <td colspan="2" style="text-align: center;">
                {% if(referencia) %}
		    <strong>Perteneciente {{ referencia }}</strong>
		{% endif %}
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>  
            
             <tr>
                <td>
                   <strong>Nombre Proceso:</strong>
                </td>
                <td>
		    {{ nombreProceso }}
                </td>
            </tr>
            <tr>
                <td>
                   <strong>Nombre Tarea:</strong>
                </td>
                <td>
		    {{ nombreTarea }}
                </td>
            </tr>
            
             <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>   
            
            <tr>
              <td>
                <strong>Fecha de asignacion:</strong>
              </td>
              <td>{{asignacion.feCreacion | date("d-M-Y") }} | {{ asignacion.feCreacion | date("H:i")  }}</td>
            </tr>
            <tr>
              <td>
                <strong>Usuario que asigno:</strong>
              </td>
              <td>{% if(persona)%}{{persona.nombres}} {{persona.apellidos}} {%endif%}</td>
            </tr>
            <tr>
              <td>
                <strong>Asignado:</strong>
              </td>
              <td>{{asignacion.asignadoNombre }}{% if(asignacion.refAsignadoNombre!="")%}-{{asignacion.refAsignadoNombre}}{%endif%}</td>
            </tr>                               
            <tr>
              <td colspan="2"><br/></td>
            </tr>
            
            <tr>
                <td>
                   <strong>Estado Tarea:</strong>
                </td>
                <td>
		    {{ estado }}
                </td>
            </tr>
	    <tr> 
                <td> 
                   <strong>Observacion Tarea:</strong> 
                </td> 
                <td> 
		    {{ observacion }} 
                </td> 
             </tr>
             <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            <tr>
            {% if(numeracion) %}
		{%  if(perteneceACaso) %}
		  <td>Por favor revisar el Caso <a href="https://telcos.telconet.ec/soporte/info_caso/{{idCaso}}/show">{{numeracion}}</a></td>  
		{%  else %}
		  <td>Por favor revisar la Actividad <a href="https://telcos.telconet.ec/soporte/call_activity/{{ numeracion }}/show">{{numeracion}}</a></td>  
		{% endif %}
	    {% endif %}
	    </tr>
          </table>
        </td>
      </tr>
      <tr>
           <td>')||chr(38)||to_clob('nbsp;
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
</html>') , USR_ULT_MOD= 'wdsanchez' where codigo = 'TAREAASIG';


--3er
update DB_comunicacion.Admi_Plantilla set plantilla = 
                  '<html>
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
                El presente correo es para indicarle que se ingreso un nuevo seguimiento de TAREA: 
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                {% if(actividad)%}
		    <strong>Actividad # {{ actividad }}</strong>                
                {% endif %}
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>    
            <tr>
                <td>
                   <strong>Nombre Tarea:</strong>
                </td>
                <td>
		    {{ nombreTarea }}
                </td>
            </tr>
             <tr>
              <td colspan="2">
                <hr />
              </td>
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
           <td>'||chr(38)||'nbsp;
          </td>
      </tr>
      <tr>
	  {% if(actividad) %}
          <td>Por favor revisar la Actividad <a href="https://telcos.telconet.ec/soporte/call_activity/{{ actividad }}/show">{{ actividad }}</a>
          </td>   
          {% endif %}
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
</html>' , USR_ULT_MOD= 'wdsanchez' where codigo = 'TAREASEGU';




--4to
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
                El presente correo es para indicarle la siguiente TAREA ha sido finalizada:  
              </td> 
            </tr> 
            <tr> 
              <td colspan="2"> 
                <hr /> 
              </td> 
            </tr>                        
             
            <tr> 
                <td colspan="2" style="text-align: center;"> 
                <strong>Perteneciente {{ referencia }}</strong> 
              </td> 
            </tr> 
            <tr> 
              <td colspan="2"> 
                <hr /> 
              </td> 
            </tr>    
             

{% if nombreProceso is defined %}
             <tr>
                <td>
                   <strong>Nombre Proceso:</strong>
                </td>
                <td>
		    {{ nombreProceso }}
                </td>
            </tr>
{% endif %}

             <tr> 
                <td> 
                   <strong>Nombre Tarea:</strong> 
                </td> 
                <td> 
		    {{ nombreTarea }} 
                </td> 
            </tr> 
             
             <tr> 
              <td colspan="2"> 
                <hr /> 
              </td> 
            </tr>    
             
            <tr> 
              <td> 
                <strong>Fecha de asignacion:</strong> 
              </td> 
              <td>{{asignacion.feCreacion | date("d-M-Y") }} | {{ asignacion.feCreacion | date("H:i")  }}</td> 
            </tr> 
            <tr> 
              <td> 
                <strong>Usuario que asigno:</strong> 
              </td> 
              <td>{% if(persona)%}{{persona.nombres}} {{persona.apellidos}} {%endif%}</td> 
            </tr> 
            <tr> 
              <td> 
                <strong>Asignado:</strong> 
              </td> 
              <td>{{asignacion.asignadoNombre }}{% if(asignacion.refAsignadoNombre!="")%}-{{asignacion.refAsignadoNombre}}{%endif%}</td> 
            </tr>  
            <tr> 
              <td> 
                <strong>Login Afectado:</strong> 
              </td> 
              <td>{{ clientes }}</td> 
            </tr>                              
            <tr> 
              <td colspan="2"><br/></td> 
            </tr> 
             
            <tr> 
                <td> 
                   <strong>Estado Tarea:</strong> 
                </td> 
                <td> 
		    {{ estado }} 
                </td> 
            </tr>
            <tr> 
                <td> 
                   <strong>Observacion Tarea:</strong> 
                </td> 
                <td> 
		    {{ observacion }} 
                </td> 
             </tr>
             <tr> 
		{% if bandCoordenadas == ''S'' %}
                <td> 
                   <strong>Coordenadas:</strong> 
                </td> 
                <td> 
		    {{ obsCoordenadas }} 
                </td> 
          	{% endif %}
             </tr>
             <tr> 
              <td colspan="2"> 
                <hr /> 
              </td> 
            </tr> 
          </table> 
        </td> 
      </tr> 
      <tr> 
           <td>')||chr(38)||to_clob('nbsp;
          </td> 
      </tr> 
      <tr> 
  {%  if perteneceACaso == ''NO'' %}     
      <td>Por favor revisar la Tarea</td> 
	{% elseif(perteneceACaso) %} 
          <td>Por favor revisar el Caso <a href="https://telcos.telconet.ec/soporte/info_caso/{{idCaso}}/show">{{numeracion}}</a></td>   
        {%  else %} 
	  <td>Por favor revisar la Actividad <a href="https://telcos.telconet.ec/soporte/call_activity/{{ numeracion }}/show">{{numeracion}}</a></td>   
	{% endif %} 
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
</html>') , USR_ULT_MOD= 'wdsanchez' where codigo = 'TAREAFINALIZA';



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
                El presente correo es para indicarle que la siguiente TAREA ha sido rechazada: 
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>                       
            
            <tr>
                <td colspan="2" style="text-align: center;">
                <strong>Perteneciente {{ referencia }}</strong>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>   
            
            </tr>  
                <tr>
                <td>
                   <strong>Nombre Proceso:</strong>
                </td>
                <td>
		    {{ nombreProceso }}
                </td>
            </tr>
             <tr>
                <td>
                   <strong>Nombre Tarea:</strong>
                </td>
                <td>
            {{ nombreTarea }}
                </td>
            </tr>
            
             <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>   
            
            <tr>
              <td>
                <strong>Fecha de asignacion:</strong>
              </td>
              <td>{{asignacion.feCreacion | date("d-M-Y") }} | {{ asignacion.feCreacion | date("H:i")  }}</td>
            </tr>
            <tr>
              <td>
                <strong>Usuario que asigno:</strong>
              </td>
              <td>{% if(persona)%}{{persona.nombres}} {{persona.apellidos}} {%endif%}</td>
            </tr>
            <tr>
              <td>
                <strong>Asignado:</strong>
              </td>
              <td>{{asignacion.asignadoNombre }}{% if(asignacion.refAsignadoNombre!="")%}-{{asignacion.refAsignadoNombre}}{%endif%}</td>
            </tr>                               
            <tr>
              <td colspan="2"><br/></td>
            </tr>
            
            <tr>
                <td>
                   <strong>Estado Tarea:</strong>
                </td>
                <td>
            {{ estado }}
                </td>
            </tr>
             <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
          <td>')||chr(38)||to_clob('nbsp;
          </td>
      </tr>
      <tr>
    {%  if perteneceACaso == ''true'' %}
          <td>Por favor revisar el Caso <a href="https://telcos.telconet.ec/soporte/info_caso/{{idCaso}}/show">{{numeracion}}</a></td>  
        {%  else %}
      <td>Por favor revisar la Actividad <a href="https://telcos.telconet.ec/soporte/call_activity/{{ numeracion }}/show">{{numeracion}}</a></td>  
    {% endif %}
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
</html>') , USR_ULT_MOD= 'wdsanchez'  where codigo = 'TAREARECHAZADA';  


update DB_comunicacion.Admi_Plantilla set plantilla = 
                 to_clob('<html>
  <head>TAREA
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
                El presente correo es para indicarle que se asigno a su departamento la siguiente TAREA: 
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
              <td colspan="2">
                <hr />
              </td>
            </tr>   
             <tr>
                <td>
                   <strong>Nombre Proceso:</strong>
                </td>
                <td>
		    {{ nombreProceso }}
                </td>
            </tr>
            <tr>
                <td>
                   <strong>Nombre Tarea:</strong>
                </td>
                <td>
		    {{ nombreTarea }}
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
                    {% for afectado in afectados %}
              <td>
                            {{ afectado.afectadoNombre}} - {{ afectado.afectadoDescripcion}}
              </td>
                    {% else %}
              <td>
                        No existen afectados definidos.
              </td>
                    {% endfor %}
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
                <strong>Observacion:</strong>
              </td>
              <td>{{ asignacion.motivo }}</td>
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
</html>'), USR_ULT_MOD= 'wdsanchez'  where codigo = 'TAREA';   


COMMIT;

/
