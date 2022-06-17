--CREACION DE PLANTILLA ASIGNACION DE TAREA
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (
ID_PLANTILLA,
NOMBRE_PLANTILLA,
CODIGO,
MODULO,
PLANTILLA,
ESTADO,
FE_CREACION,
USR_CREACION,
FE_ULT_MOD,
USR_ULT_MOD,
EMPRESA_COD
) VALUES(
DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL, 
'PROGRAMACIÓN PLANIFICACIÓN HAL ASIGNACION DE TAREA',
'PR-COM-PLAN-ASG',
'COMERCIAL',
 TO_CLOB(' <html>
  <head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
  </head>
  <body>
    <table align="center" width="100%" cellspacing="0" cellpadding="5">
      <tr>
        <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
            <img alt=""  src="http://images.telconet.net/others/telcos/logo.png"/>
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
                El presente correo es para notificarles que se asigno la siguiente Tarea # {{idTarea}}:
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
			<tr>
              <td>
                <strong>Cliente:</strong>
              </td>
              <td>
                 {{nombreCliente}} 
			  </td>
            </tr>
			<tr>
              <td>
                <strong>Login:</strong>
              </td>
              <td>
				{{login}} 
			  </td>
            </tr>
			<tr>
              <td>
                <strong>Jurisdicci&oacute;n:</strong>
              </td>
              <td>
				{{nombreJurisdiccion}}
			  </td>
            </tr>
			<tr>
              <td>
                <strong>Direcci&oacute;n:</strong>
              </td>
              <td>
				{{direccion}} 
			  </td>
            </tr>
			<tr>
              <td>
                <strong>Servicio / Producto:</strong>
              </td>
              <td>
                {{descripcionProducto}} 
			  </td>
            </tr>
            <tr>
              <td>
                <strong>Fecha de creacion:</strong>
              </td>
              <td>
                {{feCreacion}}
              </td>
            </tr>
            <tr>
              <td>
                <strong>Usuario de creacion:</strong>
              </td>
              <td>
                  {{usrCreacion}}
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <hr />
              </td>
            </tr>
			<tr>
                <td colspan="2" style="text-align: center;">
                <strong>Tarea: {{nombreTarea}}</strong>
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
              <td>{{fechaAsignacion}}</td>
            </tr>
            <tr>
              <td>
                <strong>Usuario que asigna:</strong>
              </td>
              <td>{{usrAsignacion}}</td>
            </tr>
            <tr>
              <td>
                <strong>Asignado:</strong>
              </td>
              <td>{{asignadoNombre}}{{refAsignadoNombre}}</td>
            </tr>		 
            <tr>
              <td colspan="2"><br/></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
          <td>&nbsp;
          </td>
      </tr>
      <tr>
          <td><strong><font size="2" face="Tahoma">Telcos + Sistema del Grupo Telconet</font></strong></p>
          </td>   
      </tr>  
    </table>
  </body>
</html>'), 
'Activo',
TIMESTAMP'2021-11-18 12:27:06',
'jacarrillo',
'2021-11-18 12:27:06',
'jacarrillo',
NULL); 
 

INSERT INTO db_general.admi_parametro_cab (
    id_parametro,
    nombre_parametro,
    descripcion,
    modulo,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion
  ) VALUES (
      db_general.seq_admi_parametro_cab.nextval,
      'SMS_PLANIFICACION_HAL',
      'SMS PARA LA PLANIFICACION HAL',
      'COMERCIAL',
      'Activo',
      'wgaibor',
      sysdate,
      '127.0.0.1'
  );

--
-- PROGRAMAR_MOTIVO_HAL
--
INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'SMS_PLANIFICACION_HAL'
              AND estado = 'Activo'
      ),
      'SMS PARA LA PLANIFICACION HAL',
      'Bienvenido a Netlife, elegiste el dia {{fechaSms}} a las {{horaIni}} para la instalacion de tu servicio, si requieres mayor informacion contactate con su asesor comercial.',
      NULL,
      NULL,
      NULL,
      'Activo',
      'wgaibor',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );

 COMMIT;
/
 