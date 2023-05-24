CREATE OR REPLACE PROCEDURE DB_COMUNICACION.ESTADO_ENVIOS
(
     NOMBRE       IN VARCHAR2,
     CLASE        IN NUMBER,
     ESTADO_ENVIO IN VARCHAR2,
     TIPO         IN VARCHAR2,
     EMPRESA      IN VARCHAR2,
     Q_START      IN NUMBER,
     Q_LIMIT      IN NUMBER,
     TOTAL  OUT NUMBER,
     ENVIOS OUT SYS_REFCURSOR )
AS
   -- CURSOR QUE ME DEVOVLERA EL TOTAL DE REGISTROS EN LA CONSULTA
   CURSOR NUMERO (C_NOMBRE VARCHAR2, C_CLASE NUMBER, C_ESTADO_ENVIO 
VARCHAR2, C_TIPO VARCHAR2 , C_EMPRESA VARCHAR2)
   IS
     SELECT COUNT(1)
     FROM
     (SELECT
           (SELECT info.estado
             FROM INFO_DOCUMENTO_COMUN_HIST info
             WHERE info.estado             <> 'No Enviado'
             AND info.DOCUM_COMUN_MASIVA_ID = a.ID_DOC_COM_MASIVA
             AND A.TIPO_ENVIO         IN ('MASIVO','PERSONALIZADO')
           ) AS ESTADO
     FROM INFO_DOCUMENTO_COMUN_MASIVA a,
          INFO_DOCUMENTO_COMUN_HIST b,
          INFO_DOCUMENTO c,
          ADMI_CLASE_DOCUMENTO d
     WHERE a.ID_DOC_COM_MASIVA = b.DOCUM_COMUN_MASIVA_ID
     AND a.DOCUMENTO_ID        = c.ID_DOCUMENTO
     AND c.CLASE_DOCUMENTO_ID  = d.ID_CLASE_DOCUMENTO
     AND A.TIPO_ENVIO         IN ('MASIVO','PERSONALIZADO')
       -- CONDICIONALES
     AND UPPER(c.NOMBRE_DOCUMENTO) LIKE 
NVL(UPPER('%'||C_NOMBRE||'%'),c.NOMBRE_DOCUMENTO)
     AND UPPER(b.ESTADO) LIKE NVL(UPPER('%'||C_ESTADO_ENVIO||'%'),b.ESTADO)
     AND UPPER(a.TIPO_ENVIO) LIKE NVL(UPPER('%'||C_TIPO||'%'),a.TIPO_ENVIO)
     AND c.CLASE_DOCUMENTO_ID = NVL(C_CLASE,c.CLASE_DOCUMENTO_ID)
     AND b.EMPRESA_COD = C_EMPRESA

       ) TMP WHERE TMP.ESTADO IS NOT NULL;
     --
     
  /**
  * Documentacion para procedure ESTADO_ENVIOS
  * Especificacion: Procedimiento que devuele los envios realizados con su informacion de estados,envios,fechas,nombres
  *
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.1 04-02-2016   -  Se realiza ajustes para agregar el campo USR_CREACION
  *
  * @version 1.0
  */               
   BEGIN
       

   -- Primero se obtiene el numero de total de registros para efecto de la paginacion y es retornado

     OPEN NUMERO(NOMBRE, CLASE, ESTADO_ENVIO, TIPO, EMPRESA);
     FETCH NUMERO INTO TOTAL;

-----------------------------------------------------------------------------------

   -- Se genera la consulta a devolver mediante cursor

     OPEN ENVIOS FOR

     SELECT * FROM (
     SELECT rownum as filas, TMP.* FROM
     (SELECT a.COMUNICACION_ID,
       a.ID_DOC_COM_MASIVA,
       (SELECT DISTINCT 
(LENGTH(com.puntos_enviar)-LENGTH(REPLACE(com.puntos_enviar,'-'))) + 1
       FROM INFO_DOCUMENTO_COMUN_MASIVA com,
         INFO_DOCUMENTO_COMUN_HIST hist,
         INFO_DOCUMENTO doc
       WHERE com.ID_DOC_COM_MASIVA = hist.DOCUM_COMUN_MASIVA_ID
       AND com.DOCUMENTO_ID        = doc.ID_DOCUMENTO
       AND doc.CLASE_DOCUMENTO_ID  = d.ID_CLASE_DOCUMENTO
       AND hist.estado            <> 'No Enviado'
       AND com.TIPO_ENVIO         IN ('MASIVO','PERSONALIZADO')
       and a.COMUNICACION_ID = com.COMUNICACION_ID
       ) AS ENVIADOS,

       (SELECT DISTINCT 
(LENGTH(com.puntos_enviar)-LENGTH(REPLACE(com.puntos_enviar,'-'))) + 1
       FROM INFO_DOCUMENTO_COMUN_MASIVA com,
         INFO_DOCUMENTO_COMUN_HIST hist,
         INFO_DOCUMENTO doc
       WHERE com.ID_DOC_COM_MASIVA = hist.DOCUM_COMUN_MASIVA_ID
       AND com.DOCUMENTO_ID        = doc.ID_DOCUMENTO
       AND doc.CLASE_DOCUMENTO_ID  = d.ID_CLASE_DOCUMENTO
       AND hist.estado             = 'No Enviado'
       AND com.TIPO_ENVIO         IN ('MASIVO','PERSONALIZADO')
       and a.COMUNICACION_ID = com.COMUNICACION_ID
       ) AS NOENVIADOS,

       (SELECT info.estado
       FROM INFO_DOCUMENTO_COMUN_HIST info
       WHERE info.estado             <> 'No Enviado'
       AND info.DOCUM_COMUN_MASIVA_ID = a.ID_DOC_COM_MASIVA
       ) AS ESTADO ,

       c.NOMBRE_DOCUMENTO,
       d.NOMBRE_CLASE_DOCUMENTO,
       b.OBSERVACION,
       to_char(b.FE_CREACION,'DD-MM-YYYY HH24:MI:SS') as FE_CREACION,
       b.USR_CREACION as USR_CREACION,
       a.TIPO_ENVIO,
       to_char(b.FE_FINALIZACION,'DD-MM-YYYY HH24:MI:SS') AS 
FECHA_FINALIZACION,
       b.EQUIPO_OCUPADO

     FROM

     INFO_DOCUMENTO_COMUN_MASIVA a,
     INFO_DOCUMENTO_COMUN_HIST b,
     INFO_DOCUMENTO c,
     ADMI_CLASE_DOCUMENTO d

     WHERE

     a.ID_DOC_COM_MASIVA       = b.DOCUM_COMUN_MASIVA_ID
     AND a.DOCUMENTO_ID        = c.ID_DOCUMENTO
     AND c.CLASE_DOCUMENTO_ID  = d.ID_CLASE_DOCUMENTO
     AND A.TIPO_ENVIO         IN ('MASIVO','PERSONALIZADO')

       -- CONDICIONALES

     AND UPPER(c.NOMBRE_DOCUMENTO) LIKE 
NVL(UPPER('%'||NOMBRE||'%'),c.NOMBRE_DOCUMENTO)
     AND UPPER(b.ESTADO)           LIKE 
NVL(UPPER('%'||ESTADO_ENVIO||'%'),b.ESTADO)
     AND UPPER(a.TIPO_ENVIO)       LIKE 
NVL(UPPER('%'||TIPO||'%'),a.TIPO_ENVIO)
     AND c.CLASE_DOCUMENTO_ID      = NVL(CLASE,c.CLASE_DOCUMENTO_ID)
     AND b.EMPRESA_COD             = EMPRESA

     GROUP BY
     a.COMUNICACION_ID,
     b.FE_CREACION,
     b.USR_CREACION,
     b.OBSERVACION,
     c.NOMBRE_DOCUMENTO,
     d.NOMBRE_CLASE_DOCUMENTO,
     d.ID_CLASE_DOCUMENTO,
     a.ID_DOC_COM_MASIVA,
     a.TIPO_ENVIO  ,
     b.FE_FINALIZACION,
     b.EQUIPO_OCUPADO

     order by b.fe_creacion DESC

     ) TMP WHERE TMP.ESTADO IS NOT NULL AND  ROWNUM <= Q_LIMIT
     ) WHERE filas >= Q_START;

     EXCEPTION WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM);

END ESTADO_ENVIOS;
/