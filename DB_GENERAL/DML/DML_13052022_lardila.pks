/*
 * SCRIPT DML PARA CREAR PARAMETROS NESECARIOS EN CALCULADORA 
 */  

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'INSP_CALC_PARAM_INI','PARAMETRO PARA OBTENER DATOS INICIALES DE CALCULADORA',null
,null,'Activo','lardila',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_INI'),
      'ROLES_ACCIONES',
      '{"roles":[{"rol": "Admin","cargosAsociados":[{"cargo": "coordinador"},{"cargo": "ING.CALIDAD SOFT. DESPLIEGUE"}],"opcionesPermitidas":[{"opcion": "aprobarInspeccion"}]},{"rol": "Empleado","cargosAsociados": [{"cargo": "Tecnico Jr. 1"},{"cargo": "Tecnico Sr."},{"cargo": "Ingeniero Software 1"},{"cargo": "Ingeniero Software 3"},{"cargo": "Ingeniero Software 3"},{"cargo": "Jefe Dpto. Nacional"},{"cargo": "Tecnico Jr."}],"opcionesPermitidas": [{"opcion": "crearInspecciones"}]}]}',
       NULL
      ,NULL
      ,NULL
      ,'Activo'
      ,'lardila'
      ,SYSDATE
      ,'0.0.0.0'
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_INI'),
      'TIPO_TAREAS_OBTENER',
      '[{"tipoTarea":"7301","filtroUsuario":"ByUsuario","tipo":"ByDepartamento","esConsulta":"S"}]',
       NULL
      ,NULL
      ,NULL
      ,'Activo'
      ,'lardila'
      ,SYSDATE
      ,'0.0.0.0'
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null);
      
      

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_INI'),
      'GRUPO_PRODUCTOS_OBTENER',
      '{"grupoProducto":[]}',
       NULL
      ,NULL
      ,NULL
      ,'Activo'
      ,'lardila'
      ,SYSDATE
      ,'0.0.0.0'
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_INI'),
      'PARAMETROS_CONSULTAS',
      '{"diasInervaloConsultas": "5","cantidadVersionesInpeccionConsulta": "1","cantidadVersionesBOMConsulta": "1","diasIntervaloConsultaSolicitudesProp": "5"}',
       NULL
      ,NULL
      ,NULL
      ,'Activo'
      ,'lardila'
      ,SYSDATE
      ,'0.0.0.0'
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_INI'),
      'CONFIG_SINCRO_DATOS_LOCAL',
      '[{"evento":"sincronizarAccounting", "cardinalidad": "5","frecuenciaSegundos": "60"}]',
       NULL,NULL,NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);


INSERT INTO DB_GENERAL.admi_parametro_cab 
    VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'INSP_CALC_PARAM_NOTIF','PARAMETRO PARA GENERAR NOTIFICACIONES DESDE CALCULADORA',null
    ,null,'Activo','lardila',SYSDATE,'0.0.0.0',null,null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF'),
      'TEMAS_GENERALES_NOTIFICAR',
      '[{"tema": "GestionApus","titulo": "Gestión de apus","mensaje": "Se notifica que hay ajustes en la configuracón de los apus"}]',
       NULL,NULL,NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF'),
      'NOTIFICACION_TAREAS',
      '[{"titulo": "Estado de tareas","mensaje": "La siguiente tarea ha sufrido cambios: "}]',
       NULL,NULL,NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF'),
      'NOTIFICACION_INSPECCIONES',
      '[{"titulo": "Estado de inspecciones","mensaje": "La siguiente inspección ha sido <<accion>>"}]',
       NULL,NULL,NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF'),
      'CARACT_TOKEN_PUSH_NOTIF',
      'Nombre_caracteristica',
       NULL,NULL,NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF'),
      'CORREO_NOTIF_SINCRO_CRM',
            '<html><body><div style="font-family: arial, helvetica, sans-serif;font-size: 12pt;color: #000000;">
        <div><br /></div>
        <div><br /></div>
        <div><br /></div>
        <div da="t" a-marker="__QUOTED_TEXT__"><div><table width="100%" cellspacing="0" cellpadding="5" align="center">
            <tbody>
                <tr>
                    <td style="border: 1px solid rgb(102, 153, 204);background-color: rgb(229, 242, 255);" align="center">
                        <img alt="logo" src="https://www.telconet.net/images/tn/logo-telconetlatam-retina.png" />
                    </td>
                </tr>
                <tr>
                    <td style="border: 1px solid rgb(102, 153, 204)">
                        <table width="100%" cellspacing="0" cellpadding="5">
                            <tbody>
                                <tr>
                                    <td colspan="2">
                                        Buenas tardes,<br />
        Se acaba de procesar la sincronizaci&'||'oacute;n del Bom desde el sistema Calculadora al sistema CRM de Telconet.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr
                ><tr>
                    <td>&'||'nbsp;</td>
                </tr>
                <tr>
                    <td><strong><font size="2" face="Tahoma">Sistema Calculadora Telconet</font></strong></td>
                </tr>
            </tbody>
        </table>
        </div>
        <br />
        </div>
        </div>
        </body>
        </html>',
       'Notificación Sincronización de Bom',
       '[{"correo": "jromero@telconet.ec"},{"correo": "jobedon@telconet.ec"},{"correo": "network@telconet.ec"}]',
       NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'INSP_CALC_PARAM_INSPECTION','CONFIGURACION NFS PARA CALCULADORA',null
,null,'Activo','lardila',SYSDATE,'0.0.0.0',null,null,null);



INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAM_INSPECTION'),
      'CONFIG_NFS',
      '[{"codigoApp": "10","codigoPath": "1"}]',
       NULL,NULL,NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);
      
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
)
VALUES
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='INSP_CALC_PARAM_INSPECTION' AND ESTADO='Activo'),
    'ALLOWED_CHANGE_STATUS',
    '[{"currentStatus":"Aceptada","allowedStatus":[{"status":"Finalizada"}]},{"currentStatus":"Detenido","allowedStatus":[{"status":"Finalizada"}]},{"currentStatus":"Asignada","allowedStatus":[{"status":"Finalizada"}]},{"currentStatus":"Replanificada","allowedStatus":[{"status":"Finalizada"}]},{"currentStatus":"Reprogramada","allowedStatus":[{"status":"Finalizada"}]},{"currentStatus":"Finalizada","allowedStatus":[]},{"currentStatus":"Cancelada","allowedStatus":[]},{"currentStatus":"Anulada","allowedStatus":[]},{"currentStatus":"Pausada","allowedStatus":[]},{"currentStatus":"Rechazada","allowedStatus":[]}]',
    'Activo',
    'banton',
    SYSDATE,
    '127.0.0.1',
    10,
    'VALOR1 => Json donde se especifican currentStatus: El estado actual y allowedStatus: Son el grupo de estados que son permitidos ser asignados segun el currentStatus'
);

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(
        DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,
        'INSP_CALC_PARAMS_REPORT',
        'PARAMETROS DE REPORTES PARA CALCULADORA',
        null,
        null,
        'Activo',
        'lardila',
        SYSDATE,
        '0.0.0.0'
        ,null
        ,null
        ,null
);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAMS_REPORT'),
      'PLANTILLA_REPORTE_ELEC',
      'Plantilla  HTML con tags para identificar cada sección',
       '129','Electrico',NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);
      

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAMS_REPORT'),
      'PLANTILLA_REPORTE_FIBRA',
      'Plantilla  HTML con tags para identificar cada sección',
       '116','Fibra',NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAMS_REPORT'),
      'PLANTILLA_REPORTE_RADIO',
      'Plantilla  HTML con tags para identificar cada sección',
       '124','Radio',NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);
      
      

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'INSP_CALC_PARAMS_REPORT'),
      'PLANTILLA_REPORTE_OC',
      'Plantilla  HTML con tags para identificar cada sección',
       '596','Obras Civiles',NULL,'Activo','lardila',SYSDATE,'0.0.0.0'
      ,null,null,null,null,null,null
      ,null,null);
      
COMMIT;

/