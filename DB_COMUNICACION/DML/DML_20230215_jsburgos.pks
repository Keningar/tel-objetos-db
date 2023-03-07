/**
* DEBE EJECUTARSE EN DB_COMUNICACION SOLO LAS PLANTILLAS
* MAS ADELANTE EXISTEN PARAMETROS GENERALES QUE DEBEN SER EJECUTADOS CON DB_GENERAL
* @author jsburgos <jsburgos@telconet.ec>
* @version 1.0 15-02-2023.
*/

SET SERVEROUTPUT ON
SET DEFINE OFF
--Creación de nueva plantilla para el envío de correo de notificaciones de errores en el proceso de migracion olt alta densidad
DECLARE
  Ln_IdPlantilla NUMBER(5,0);
BEGIN
  --Plantilla usada para notificar los errores que se den en las validaciones de archivos de migracion olt alta densidad
  INSERT
  INTO DB_COMUNICACION.ADMI_PLANTILLA
    (
      ID_PLANTILLA,
      NOMBRE_PLANTILLA,
      CODIGO,
      MODULO,
      PLANTILLA,
      ESTADO,
      FE_CREACION,
      USR_CREACION
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,
      'NOTIFICACIÓN DE REGISTRO DE ERRORES PARA VALIDACIONES DE ARCHIVOS MIGRACION OLT ALTA DENSIDAD',
      'OLT_MIGRA_ERR',
      'TECNICO',
      '<html>
           <head>
              <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
              <style type="text/css">table.cssTable { font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #999999;border-collapse: collapse;}table.cssTable th {background-color:#c3dde0;border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;}table.cssTable tr {background-color:#d4e3e5;}table.cssTable td {border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;}table.cssTblPrincipal{font-family: verdana,arial,sans-serif;font-size:12px;}</style>
           </head>
           <body>
              <table class = "cssTblPrincipal" align="center" width="100%" cellspacing="0" cellpadding="5">
                 <tr>
                    <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;"><img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo.png"/></td>
                 </tr>
                 <tr>
                    <td style="border:1px solid #6699CC;">
                       <table width="100%" cellspacing="0" cellpadding="5">
                          <tr>
                             <td colspan="2">Estimados,</td>
                          </tr>
                          <tr>
                             <td colspan="2"><p>Se adjunta documento CSV con la información de “Reporte errores archivos cargados - Migración OLT Alta Densidad." {{NOMBRE_OLT}}</p></td>
                          </tr>
                       </table>
                    </td>
                 </tr>
                 <tr>
                    <td></td>
                 </tr>
              </table>
           </body>
       </html>',
      'Activo',
      CURRENT_TIMESTAMP,
      'jsburgos'
    );
  SELECT ID_PLANTILLA
  INTO Ln_IdPlantilla
  FROM DB_COMUNICACION.ADMI_PLANTILLA
  WHERE CODIGO='OLT_MIGRA_ERR';
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      1,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      2,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      410,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );  
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      394,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );  
  SYS.DBMS_OUTPUT.PUT_LINE('Se creó la plantilla correctamente OLT_MIGRA_ERR');
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/

-- PLANTILLA PARA NOTIFICACIONES DE REPORTES PREVIOS A LA MIGRACION OLT ALTA DENSIDAD
DECLARE
  Ln_IdPlantilla NUMBER(5,0);
BEGIN
  --Plantilla usada para notificar reportes previos a la migracion
  INSERT
  INTO DB_COMUNICACION.ADMI_PLANTILLA
    (
      ID_PLANTILLA,
      NOMBRE_PLANTILLA,
      CODIGO,
      MODULO,
      PLANTILLA,
      ESTADO,
      FE_CREACION,
      USR_CREACION
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,
      'NOTIFICACIÓN DE REPORTES PREVIOS A LA MIGRACION OLT ALTA DENSIDAD',
      'OLT_MIGRA_PREV',
      'TECNICO',
      '<html>
           <head>
              <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
              <style type="text/css">table.cssTable { font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #999999;border-collapse: collapse;}table.cssTable th {background-color:#c3dde0;border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;}table.cssTable tr {background-color:#d4e3e5;}table.cssTable td {border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;}table.cssTblPrincipal{font-family: verdana,arial,sans-serif;font-size:12px;}</style>
           </head>
           <body>
              <table class = "cssTblPrincipal" align="center" width="100%" cellspacing="0" cellpadding="5">
                 <tr>
                    <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;"><img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo.png"/></td>
                 </tr>
                 <tr>
                    <td style="border:1px solid #6699CC;">
                       <table width="100%" cellspacing="0" cellpadding="5">
                          <tr>
                             <td colspan="2">Estimados,</td>
                          </tr>
                          <tr>
                             <td colspan="2"><p>Se adjunta documentos CSV con la información de planes MEGADATOS y de productos de TELCONET existentes del OLT {{NOMBRE_OLT}}</p></td>
                          </tr>
                       </table>
                    </td>
                 </tr>
                 <tr>
                    <td></td>
                 </tr>
              </table>
           </body>
       </html>',
      'Activo',
      CURRENT_TIMESTAMP,
      'jsburgos'
    );
  SELECT ID_PLANTILLA
  INTO Ln_IdPlantilla
  FROM DB_COMUNICACION.ADMI_PLANTILLA
  WHERE CODIGO='OLT_MIGRA_PREV';
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      1,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      2,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      410,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );  
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      394,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    ); 
  SYS.DBMS_OUTPUT.PUT_LINE('Se creó la plantilla correctamente OLT_MIGRA_PREV');
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/

-- PLANTILLA PARA NOTIFICACIONES DE REPORTES POSTERIOR A LA MIGRACION OLT ALTA DENSIDAD
DECLARE
  Ln_IdPlantilla NUMBER(5,0);
BEGIN
  --Plantilla usada para notificar reportes posterior a la migracion
  INSERT
  INTO DB_COMUNICACION.ADMI_PLANTILLA
    (
      ID_PLANTILLA,
      NOMBRE_PLANTILLA,
      CODIGO,
      MODULO,
      PLANTILLA,
      ESTADO,
      FE_CREACION,
      USR_CREACION
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,
      'NOTIFICACIÓN DE REPORTES POSTERIOR A LA MIGRACION OLT ALTA DENSIDAD',
      'OLT_MIGRA_POST',
      'TECNICO',
      '<html>
           <head>
              <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
              <style type="text/css">table.cssTable { font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #999999;border-collapse: collapse;}table.cssTable th {background-color:#c3dde0;border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;}table.cssTable tr {background-color:#d4e3e5;}table.cssTable td {border-width: 1px;padding: 8px;border-style: solid;border-color: #a9c6c9;}table.cssTblPrincipal{font-family: verdana,arial,sans-serif;font-size:12px;}</style>
           </head>
           <body>
              <table class = "cssTblPrincipal" align="center" width="100%" cellspacing="0" cellpadding="5">
                 <tr>
                    <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;"><img alt=""  src="http://images.telconet.net/others/sit/notificaciones/logo.png"/></td>
                 </tr>
                 <tr>
                    <td style="border:1px solid #6699CC;">
                       <table width="100%" cellspacing="0" cellpadding="5">
                          <tr>
                             <td colspan="2">Estimados,</td>
                          </tr>
                          <tr>
                             <td colspan="2"><p>Se adjunta documentos CSV con la información de planes MEGADATOS y de productos de TELCONET migrados al OLT {{NOMBRE_OLT}}</p></td>
                          </tr>
                       </table>
                    </td>
                 </tr>
                 <tr>
                    <td></td>
                 </tr>
              </table>
           </body>
       </html>',
      'Activo',
      CURRENT_TIMESTAMP,
      'jsburgos'
    );
  SELECT ID_PLANTILLA
  INTO Ln_IdPlantilla
  FROM DB_COMUNICACION.ADMI_PLANTILLA
  WHERE CODIGO='OLT_MIGRA_POST';
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      1,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      2,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      410,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );  
  INSERT
  INTO DB_COMUNICACION.INFO_ALIAS_PLANTILLA
    (
      ID_ALIAS_PLANTILLA,
      ALIAS_ID,
      PLANTILLA_ID,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      ES_COPIA
    )
    VALUES
    (
      DB_COMUNICACION.SEQ_INFO_ALIAS_PLANTILLA.NEXTVAL,
      394,
      Ln_IdPlantilla,
      'Activo',
      SYSDATE,
      'jsburgos',
      'NO'
    );
  SYS.DBMS_OUTPUT.PUT_LINE('Se creó la plantilla correctamente OLT_MIGRA_POST');
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/
