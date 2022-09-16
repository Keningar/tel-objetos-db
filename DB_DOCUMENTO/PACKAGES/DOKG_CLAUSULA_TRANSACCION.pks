CREATE OR REPLACE PACKAGE DB_DOCUMENTO.DOKG_CLAUSULA_TRANSACCION
AS

  /**
    * Documentación para la función P_ADMINISTRACION_CLAUSULA
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 04-03-2022
    */

    PROCEDURE P_ADMINISTRACION_CLAUSULA(
                                        Pcl_Request       IN  VARCHAR2,
                                        Pv_Mensaje        OUT VARCHAR2,
                                        Pv_Status         OUT VARCHAR2,
                                        Pcl_Response      OUT CLOB) ;

  /**
    * Documentación para la función P_ADMINISTRACION_ACTUALIZAR
    * Procedimiento que actualiza los enunciado del contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 04-05-2022
    */

    PROCEDURE P_ADMINISTRACION_ACTUALIZAR(
                                        Pcl_Request       IN  VARCHAR2,
                                        Pv_Mensaje        OUT VARCHAR2,
                                        Pv_Status         OUT VARCHAR2,
                                        Pcl_Response      OUT SYS_REFCURSOR) ;                                       
   /**
    * Documentación para la función P_OBTIENE_CLAUSULA
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 04-03-2022
    */

    PROCEDURE P_OBTIENE_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) ;

   /**
    * Documentación para la función P_OBTIENE_CLAUSULA_X_ENUNCIADO
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 25-03-2022
    */

    PROCEDURE P_OBTIENE_CLAUSULA_X_ENUNCIADO(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB);


   /**
    * Documentación para la función P_OBTIENE_CLAUSULA_X_ENUNCIADO
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 25-03-2022
    */
    PROCEDURE P_CONSULTA_CLAUSULA_BANC(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB);

    /**
    * Documentación para la función P_ELIMINA_CLAUSULA
    * Procedimiento que elimina la encuesta.
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 05-05-2022
    */
    PROCEDURE P_ELIMINA_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR);
END DOKG_CLAUSULA_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY DB_DOCUMENTO.DOKG_CLAUSULA_TRANSACCION
AS

  PROCEDURE P_ADMINISTRACION_CLAUSULA(Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) AS

    CURSOR C_GET_PROCESO(Cv_NombreProceso VARCHAR2)
    IS
        SELECT ID_PROCESO
        FROM DB_DOCUMENTO.ADMI_PROCESO
        WHERE
            NOMBRE = Cv_NombreProceso
        AND ESTADO = 'Activo';

    CURSOR C_GET_DOCUMENTO(Cv_NombreDocumento VARCHAR2)
    IS
        SELECT ID_DOCUMENTO
        FROM DB_DOCUMENTO.ADMI_DOCUMENTO
        WHERE
            NOMBRE = Cv_NombreDocumento
        AND ESTADO = 'Activo';

    CURSOR C_GET_ENUNCIADO(Cv_NombreEnunciado VARCHAR2)
    IS
        SELECT ID_ENUNCIADO
        FROM DB_DOCUMENTO.ADMI_ENUNCIADO
        WHERE
            NOMBRE = Cv_NombreEnunciado
        AND ESTADO = 'Activo';

    CURSOR C_GET_DOCUMENTO_ENUNCIADO(Cv_IdDocumento INTEGER, Cv_IdEnunciado INTEGER)
    IS
        SELECT ID_DOCUMENTO_ENUNCIADO
        FROM DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO
        WHERE
            DOCUMENTO_ID = Cv_IdDocumento
        AND ENUNCIADO_ID = Cv_IdEnunciado
        AND ESTADO = 'Activo';

    CURSOR C_GET_ORDEN_DOC_ENUN
    IS
        SELECT
                NVL((SELECT 
                MAX(orden) FROM DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO),0)+1  AS ORDEN_ENUNCIADO
        FROM dual;

    CURSOR C_GET_ATRIBUTO_ENUNCIADO(Cv_IdEnunciado INTEGER, Cv_Nombre VARCHAR2)
    IS
        SELECT ID_ATRIBUTO_ENUNCIADO
        FROM DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO
        WHERE ENUNCIADO_ID = Cv_IdEnunciado
        AND NOMBRE = Cv_Nombre
        AND ESTADO = 'Activo';

    CURSOR C_GET_ORDEN_ATR_ENUN
    IS
        SELECT
                NVL((SELECT 
                MAX(orden) FROM DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO),0)+1 AS ORDEN_ATRIBUTO 
        FROM dual;

    CURSOR C_GET_RESPUESTA(Cv_IdRespuesta INTEGER)
    IS
        SELECT ID_RESPUESTA, NOMBRE
        FROM DB_DOCUMENTO.ADMI_RESPUESTA
        WHERE ID_RESPUESTA = Cv_IdRespuesta
        AND ESTADO = 'Activo';

    CURSOR C_GET_RESPUESTA_EXISTE(Cv_nombreRespuesta VARCHAR2)
    IS
        SELECT ID_RESPUESTA
        FROM DB_DOCUMENTO.ADMI_RESPUESTA
        WHERE NOMBRE = Cv_nombreRespuesta
        AND ESTADO = 'Activo';

  -- Estados
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';

  -- Variables globales de empresa - usuario
    Ln_CodEmpresa              INTEGER;
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

  --Variables de salida

    Lv_nombreProceso           VARCHAR2(100);
    Lv_nombreDocumento         VARCHAR2(100);
    Ln_CountEnunciado          INTEGER;
    Ln_CountAttrEnunciado      INTEGER:=0;
    Ln_CountRespuesta          INTEGER:=0;
    Ln_CountArrayIdRespuesta   INTEGER:=0;

    Ln_procesoId               INTEGER;
    Ln_documentoId             INTEGER;
    Ln_enunciadoId             INTEGER;
    Ln_documentoEnunciadoId    INTEGER;
    Ln_atributoEnunciadoId     INTEGER;
    Lv_IdRespuesta             VARCHAR2(100);

    Lv_codigoProceso           VARCHAR2(100);
    Lv_codigoDocumento         VARCHAR2(100);
    Lv_descripcionDocumento    VARCHAR2(100);
    Lv_DescripcionProcDoc      VARCHAR2(400);

    Lv_NombreEnunciado          VARCHAR2(100);
    Lv_DescripcionEnunciado     VARCHAR2(4000);
    Lv_TagPlantilla             VARCHAR2(100);
    Lv_PlantillaHtml            VARCHAR2(4000);
    Lv_VisibleEnDoc             VARCHAR2(100);

    Lv_TipoOpcEnunciado         VARCHAR2(100);

    Lv_nombreAttrEnunciado      VARCHAR2(100);
    Lv_valorAttrEnunciado       VARCHAR2(4000);
    Ln_OrdenAttrEnunciado       INTEGER;
    Ln_OrdenDocEnunciado        INTEGER;
    Ln_idRespNumeric            INTEGER;

    Lv_nombreRespuesta          VARCHAR2(100);
    Lv_valorRespuesta           VARCHAR2(100);

    Ln_respuestaId              INTEGER;
    Ln_OrdenPregEnunciado       INTEGER;
    Ln_docEnunciadoRespId       INTEGER;

    Lv_EsDefaultEnunciado        VARCHAR2(100);
    Lv_ReqParaContEnunciado      VARCHAR2(100);
    Lv_ReqJustEnunciado          VARCHAR2(100);

    Lv_ValueEsDefaultEnunciado   VARCHAR2(100);
    Lv_ValueReqParaContEnunciado VARCHAR2(100);
    Ln_CountEsDefaultEnunci      INTEGER:=0;
    Ln_CountReqParaContEnun      INTEGER:=0;
  --VARIABLE CURSOR
    Lc_Response                  SYS_REFCURSOR;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_NombreProceso      := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Lv_NombreDocumento    := APEX_JSON.get_varchar2(p_path => 'nombreDocumento');
    Lv_DescripcionProcDoc := APEX_JSON.get_varchar2(p_path => 'descripcionDocumento');

    IF Lv_NombreProceso IS NULL THEN
      RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreProceso ');
    END IF;
    IF Lv_NombreDocumento IS NULL THEN
      RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreDocumento ');
    END IF;
    --Tamaños de arreglo clausula
    Ln_CountEnunciado     := APEX_JSON.GET_COUNT(p_path => 'enunciado');

    IF Ln_CountEnunciado IS NULL THEN
      RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreDocumento ');
    END IF;

    --
    -- VALIDACIÓN DEL PROCESO.
    --
    OPEN C_GET_PROCESO(Lv_NombreProceso);
    FETCH C_GET_PROCESO INTO Ln_procesoId;
    CLOSE C_GET_PROCESO;

    IF Ln_procesoId IS NULL
    THEN
        INSERT INTO DB_DOCUMENTO.ADMI_PROCESO (ID_PROCESO,
                                               NOMBRE,
                                               CODIGO,
                                               DESCRIPCION,
                                               EMPRESA_COD,
                                               ESTADO,
                                               USUARIO_CREACION,
                                               FECHA_CREACION)
        VALUES (DB_DOCUMENTO.SEQ_ADMI_PROCESO.NEXTVAL,
                Lv_NombreProceso,
                'PR-'||DB_DOCUMENTO.SEQ_CODIGO.NEXTVAL,
                Lv_DescripcionProcDoc,
                Ln_CodEmpresa,
                Lv_EstadoActivo,
                Lv_UsrCreacion,
                SYSDATE) 
        RETURNING ID_PROCESO INTO Ln_procesoId;
    END IF;

    --
    -- VALIDACIÓN DEL DOCUMENTO.
    --
    OPEN C_GET_DOCUMENTO(Lv_NombreDocumento);
    FETCH C_GET_DOCUMENTO INTO Ln_documentoId;
    CLOSE C_GET_DOCUMENTO;

    IF Ln_documentoId IS NULL
    THEN
        INSERT INTO DB_DOCUMENTO.ADMI_DOCUMENTO (ID_DOCUMENTO,
                                                  NOMBRE,
                                                  CODIGO,
                                                  DESCRIPCION,
                                                  PROCESO_ID,
                                                  ESTADO,
                                                  USUARIO_CREACION,
                                                  FECHA_CREACION)
        VALUES (DB_DOCUMENTO.SEQ_ADMI_DOCUMENTO.NEXTVAL,
                Lv_NombreDocumento,
                'DC-'||DB_DOCUMENTO.SEQ_CODIGO.NEXTVAL,
                Lv_DescripcionProcDoc,
                Ln_procesoId,
                Lv_EstadoActivo,
                Lv_UsrCreacion,
                SYSDATE)
                RETURNING ID_DOCUMENTO INTO Ln_documentoId;

    END IF;

    FOR i IN 1 .. Ln_CountEnunciado LOOP
      APEX_JSON.PARSE(Pcl_Request);

      Lv_NombreEnunciado      := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].nombreEnunciado',  p0 => i);
      Lv_DescripcionEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].descripcionEnunciado',  p0 => i);
      Lv_TagPlantilla         := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].tagPlantilla',  p0 => i);
      Lv_PlantillaHtml        := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].plantillaHtml',  p0 => i);
      Lv_VisibleEnDoc         := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].visibleEnDocumento',  p0 => i);
      Lv_TipoOpcEnunciado     := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].tipoOpcionEnunciado',  p0 => i);
      Ln_CountEsDefaultEnunci := APEX_JSON.GET_COUNT(p_path => 'enunciado[%d].esDefaultEnunciado',  p0 => i);
      Ln_CountReqParaContEnun := APEX_JSON.GET_COUNT(p_path => 'enunciado[%d].requeridoParaContinuarEnunciado',  p0 => i);
      Lv_ReqJustEnunciado     := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].requiereJustificacionEnunciado',  p0 => i);

      --
      -- BUSCAR EL ENUNCIADO NO EXISTE EN LA BASE DE DATOS.
      --
      OPEN C_GET_ENUNCIADO(Lv_NombreEnunciado);
      FETCH C_GET_ENUNCIADO INTO Ln_enunciadoId;
      CLOSE C_GET_ENUNCIADO;
      IF Ln_enunciadoId IS NULL
      THEN
        INSERT INTO DB_DOCUMENTO.ADMI_ENUNCIADO (ID_ENUNCIADO,
                                                  NOMBRE,
                                                  CODIGO,
                                                  DESCRIPCION,
                                                  TAG_PLANTILLA,
                                                  PLANTILLA_HTML,
                                                  EMPRESA_COD,
                                                  VISIBLE_EN_DOCUMENTO,
                                                  ESTADO,
                                                  USUARIO_CREACION,
                                                  FECHA_CREACION)
        VALUES (DB_DOCUMENTO.SEQ_ADMI_ENUNCIADO.NEXTVAL,
                Lv_NombreEnunciado,
                'EN-'||DB_DOCUMENTO.SEQ_CODIGO.NEXTVAL,
                Lv_DescripcionEnunciado,
                Lv_TagPlantilla,
                Lv_PlantillaHtml,
                Ln_CodEmpresa,
                Lv_VisibleEnDoc,
                Lv_EstadoActivo,
                Lv_UsrCreacion,
                SYSDATE)
        RETURNING ID_ENUNCIADO INTO Ln_enunciadoId;
      END IF;

      --
      -- Crear relación documento con enunciado
      --
      OPEN C_GET_DOCUMENTO_ENUNCIADO(Ln_documentoId, Ln_enunciadoId);
      FETCH C_GET_DOCUMENTO_ENUNCIADO INTO Ln_documentoEnunciadoId;
      CLOSE C_GET_DOCUMENTO_ENUNCIADO;
      IF Ln_documentoEnunciadoId IS NULL
      THEN
        OPEN C_GET_ORDEN_DOC_ENUN;
        FETCH C_GET_ORDEN_DOC_ENUN INTO Ln_OrdenDocEnunciado;
        CLOSE C_GET_ORDEN_DOC_ENUN;
        INSERT INTO DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO (ID_DOCUMENTO_ENUNCIADO,
                                                            DOCUMENTO_ID,
                                                            ENUNCIADO_ID,
                                                            ORDEN,
                                                            TIPO_OPCION,
                                                            ESTADO,
                                                            USUARIO_CREACION,
                                                            FECHA_CREACION)
        VALUES (DB_DOCUMENTO.SEQ_ADMI_DOCUMENTO_ENUNCIADO.NEXTVAL,
                Ln_documentoId,
                Ln_enunciadoId,
                Ln_OrdenDocEnunciado,
                Lv_TipoOpcEnunciado,
                Lv_EstadoActivo,
                Lv_UsrCreacion,
                SYSDATE)
        RETURNING ID_DOCUMENTO_ENUNCIADO INTO Ln_documentoEnunciadoId;
      END IF;

      --
      -- Atributos del enunciado
      --

      --Tamaños de arreglo atributo enunciado
      Ln_CountAttrEnunciado     := APEX_JSON.GET_COUNT(p_path => 'enunciado[%d].atributoEnunciado',  p0 => i);
      IF Ln_CountAttrEnunciado > 0 THEN
        FOR j IN 1 .. Ln_CountAttrEnunciado LOOP 
          APEX_JSON.PARSE(Pcl_Request);
          Ln_atributoEnunciadoId := NULL;
          Lv_nombreAttrEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].atributoEnunciado[%d].nombreAtrrEnunciado',  p0 => i, p1 => j);
          Lv_valorAttrEnunciado  := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].atributoEnunciado[%d].valorAttrEnunciado',  p0 => i, p1 => j);
          --
          -- Buscar el atributo no existe en la base de datos.
          --
          IF LENGTH(Lv_nombreAttrEnunciado) > 0  AND LENGTH(Lv_valorAttrEnunciado) > 0 THEN
            OPEN C_GET_ATRIBUTO_ENUNCIADO(Ln_EnunciadoId, Lv_nombreAttrEnunciado);
            FETCH C_GET_ATRIBUTO_ENUNCIADO INTO Ln_atributoEnunciadoId;
            CLOSE C_GET_ATRIBUTO_ENUNCIADO;
            IF Ln_atributoEnunciadoId IS NULL
            THEN
              OPEN C_GET_ORDEN_ATR_ENUN;
              FETCH C_GET_ORDEN_ATR_ENUN INTO Ln_OrdenAttrEnunciado;
              CLOSE C_GET_ORDEN_ATR_ENUN;
              INSERT INTO DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO (ID_ATRIBUTO_ENUNCIADO,
                                                                  ENUNCIADO_ID,
                                                                  NOMBRE,
                                                                  VALOR,
                                                                  ORDEN,
                                                                  ESTADO,
                                                                  USUARIO_CREACION,
                                                                  FECHA_CREACION)
              VALUES (DB_DOCUMENTO.SEQ_ADMI_ATRIBUTO_ENUNCIADO.NEXTVAL,
                      Ln_enunciadoId,
                      Lv_nombreAttrEnunciado,
                      Lv_valorAttrEnunciado,
                      Ln_OrdenAttrEnunciado,
                      Lv_EstadoActivo,
                      Lv_UsrCreacion,
                      SYSDATE)
              RETURNING ID_ATRIBUTO_ENUNCIADO INTO Ln_atributoEnunciadoId;
            END IF;
          END IF;

        END LOOP;
      END IF;


      --
      --Tamaños de arreglo respuestas enunciado
      --
      Ln_CountArrayIdRespuesta := APEX_JSON.GET_COUNT(p_path => 'enunciado[%d].arrRespuestas',  p0 => i);
      IF Ln_CountArrayIdRespuesta > 0 THEN
        Ln_OrdenPregEnunciado := 0;
        FOR j IN 1 .. Ln_CountArrayIdRespuesta LOOP
          APEX_JSON.PARSE(Pcl_Request);
          Lv_EsDefaultEnunciado   := 'N';
          Lv_ReqParaContEnunciado := 'N';
          Lv_valorRespuesta       := NULL;
          Ln_respuestaId          := NULL;
          Ln_idRespNumeric        := NULL;
          Lv_idRespuesta          := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].arrRespuestas[%d]',  p0 => i, p1 => j);
          --
          -- Buscar la respuesta no existe en la base de datos.
          --
          SELECT LENGTH(TRIM(TRANSLATE(Lv_idRespuesta, ' +-.0123456789',' '))) INTO Ln_idRespNumeric FROM dual;
          IF Ln_idRespNumeric IS NULL
          THEN
            OPEN C_GET_RESPUESTA(Lv_idRespuesta);
            FETCH C_GET_RESPUESTA INTO Ln_respuestaId, Lv_valorRespuesta;
            CLOSE C_GET_RESPUESTA;
          END IF;
          Ln_OrdenPregEnunciado := Ln_OrdenPregEnunciado + 1;
          --
          -- Consultar si la respuesta es default y permitida para continuar el flujo
          --
          IF Ln_respuestaId IS NOT NULL
          THEN
            IF Ln_CountEsDefaultEnunci > 0 THEN
              FOR k IN 1 .. Ln_CountEsDefaultEnunci LOOP
                Lv_ValueEsDefaultEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].esDefaultEnunciado[%d]',  p0 => i, p1 => k);
                IF TO_CHAR(Ln_respuestaId) = Lv_ValueEsDefaultEnunciado
                THEN
                  Lv_EsDefaultEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
            IF Ln_CountReqParaContEnun > 0 THEN
              FOR k IN 1 .. Ln_CountReqParaContEnun LOOP
                Lv_ValueReqParaContEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].requeridoParaContinuarEnunciado[%d]',  p0 => i, p1 => k);
                IF TO_CHAR(Ln_respuestaId) = Lv_ValueReqParaContEnunciado
                THEN
                  Lv_ReqParaContEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
          END IF;


          IF Ln_respuestaId IS NULL
          THEN

            INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA (ID_RESPUESTA,
                                                        NOMBRE,
                                                        VALOR,
                                                        EMPRESA_COD,
                                                        ESTADO,
                                                        USUARIO_CREACION,
                                                        FECHA_CREACION)
            VALUES (DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
                    Lv_idRespuesta,
                    Lv_idRespuesta,
                    Ln_CodEmpresa,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE)
            RETURNING ID_RESPUESTA INTO Ln_respuestaId;
            --
            -- Se valida si la respuesta es default y permitida para continuar el flujo
            --
            IF Ln_CountEsDefaultEnunci > 0 THEN
              FOR k IN 1 .. Ln_CountEsDefaultEnunci LOOP
                Lv_ValueEsDefaultEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].esDefaultEnunciado[%d]',  p0 => i, p1 => k);
                IF Lv_idRespuesta = Lv_ValueEsDefaultEnunciado
                THEN
                  Lv_EsDefaultEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
            IF Ln_CountReqParaContEnun > 0 THEN
              FOR k IN 1 .. Ln_CountReqParaContEnun LOOP
                Lv_ValueReqParaContEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].requeridoParaContinuarEnunciado[%d]',  p0 => i, p1 => k);
                IF Lv_idRespuesta = Lv_ValueReqParaContEnunciado
                THEN
                  Lv_ReqParaContEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
          --
          --
          END IF;
          INSERT INTO DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP (ID_DOC_ENUNCIADO_RESP,
                                                                DOCUMENTO_ENUNCIADO_ID,
                                                                RESPUESTA_ID,
                                                                ES_DEFAULT,
                                                                REQUERIDO_PARA_CONTINUAR,
                                                                REQUIERE_JUSTIFICACION,
                                                                ORDEN,
                                                                ESTADO,
                                                                USUARIO_CREACION,
                                                                FECHA_CREACION)
            VALUES (DB_DOCUMENTO.SEQ_ADMI_DOC_ENUNCIADO_RESP.NEXTVAL,
                    Ln_documentoEnunciadoId,
                    Ln_respuestaId,
                    Lv_EsDefaultEnunciado,
                    Lv_ReqParaContEnunciado,
                    Lv_ReqJustEnunciado,
                    Ln_OrdenPregEnunciado,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE)
            RETURNING ID_DOC_ENUNCIADO_RESP INTO Ln_docEnunciadoRespId;
        END LOOP;
      END IF;


      Ln_CountRespuesta   := APEX_JSON.GET_COUNT(p_path => 'enunciado[%d].lstRespuestas',  p0 => i);
      IF Ln_CountRespuesta > 0 THEN
        Ln_OrdenPregEnunciado := 0;
        FOR j IN 1 .. Ln_CountRespuesta LOOP
          APEX_JSON.PARSE(Pcl_Request);
          Ln_respuestaId      := NULL;
          Lv_nombreRespuesta  := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].lstRespuestas[%d].nombreRespuesta',  p0 => i, p1 => j);
          Lv_valorRespuesta   := APEX_JSON.get_varchar2(p_path => 'enunciado[%d].lstRespuestas[%d].valorRespuesta',  p0 => i, p1 => j);
          Ln_OrdenPregEnunciado := Ln_OrdenPregEnunciado + 1;
          --
          -- Buscar la respuesta no existe en la base de datos.
          --
          OPEN C_GET_RESPUESTA_EXISTE(Lv_nombreRespuesta);
          FETCH C_GET_RESPUESTA_EXISTE INTO Ln_respuestaId;
          CLOSE C_GET_RESPUESTA_EXISTE;
          IF Ln_respuestaId IS NULL
          THEN
            INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA (ID_RESPUESTA,
                                                        NOMBRE,
                                                        VALOR,
                                                        EMPRESA_COD,
                                                        ESTADO,
                                                        USUARIO_CREACION,
                                                        FECHA_CREACION)
            VALUES (DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
                    Lv_nombreRespuesta,
                    Lv_valorRespuesta,
                    Ln_CodEmpresa,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE)
            RETURNING ID_RESPUESTA INTO Ln_respuestaId;

            INSERT INTO DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP (ID_DOC_ENUNCIADO_RESP,
                                                                DOCUMENTO_ENUNCIADO_ID,
                                                                RESPUESTA_ID,
                                                                ES_DEFAULT,
                                                                REQUERIDO_PARA_CONTINUAR,
                                                                REQUIERE_JUSTIFICACION,
                                                                ORDEN,
                                                                ESTADO,
                                                                USUARIO_CREACION,
                                                                FECHA_CREACION)
            VALUES (DB_DOCUMENTO.SEQ_ADMI_DOC_ENUNCIADO_RESP.NEXTVAL,
                    Ln_documentoEnunciadoId,
                    Ln_respuestaId,
                    Lv_EsDefaultEnunciado,
                    Lv_ReqParaContEnunciado,
                    Lv_ReqJustEnunciado,
                    Ln_OrdenPregEnunciado,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE)
            RETURNING ID_DOC_ENUNCIADO_RESP INTO Ln_docEnunciadoRespId;
          END IF;
        END LOOP;
      END IF;



    END LOOP;
    COMMIT;
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
   EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_ADMINISTRACION_CLAUSULA',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1'); 
  END P_ADMINISTRACION_CLAUSULA;

  PROCEDURE P_ADMINISTRACION_ACTUALIZAR(Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) AS
  CURSOR C_GET_ENUNCIADO(Cn_EnunciadoId NUMBER) IS
    SELECT NOMBRE,
          DESCRIPCION,
          TAG_PLANTILLA,
          VISIBLE_EN_DOCUMENTO
    FROM db_documento.admi_enunciado
    where id_enunciado = Cn_EnunciadoId
      and estado = 'Activo';

  CURSOR C_GET_ENUNCIADO_ATTR(Cn_EnunciadoId NUMBER, Cv_Nombre VARCHAR2) IS
    SELECT VALOR
    FROM db_documento.admi_atributo_enunciado
    where enunciado_id = Cn_EnunciadoId
      and nombre = Cv_Nombre;

  CURSOR C_GET_ORDEN_ATR_ENUN
    IS
        SELECT
                NVL((SELECT 
                MAX(orden) FROM DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO),0)+1 AS ORDEN_ATRIBUTO 
        FROM dual;

  CURSOR C_GET_DOCUMENTO_ENUNCIADO(Cn_IdEnunciado NUMBER) IS
    SELECT ID_DOCUMENTO_ENUNCIADO
    FROM db_documento.admi_documento_enunciado aden, db_documento.admi_enunciado ade
    where ade.id_enunciado = aden.enunciado_id
      and ade.id_enunciado = Cn_IdEnunciado
      and ade.estado = 'Activo';

  CURSOR C_GET_RESPUESTA(Cv_IdRespuesta INTEGER)
    IS
        SELECT ID_RESPUESTA, NOMBRE
        FROM DB_DOCUMENTO.ADMI_RESPUESTA
        WHERE ID_RESPUESTA = Cv_IdRespuesta
        AND ESTADO = 'Activo';

  CURSOR C_GET_RESPUESTA_ENUNCIADO(Cn_IdRespuesta NUMBER, Cn_DocEnunciado NUMBER) IS
    SELECT ID_DOC_ENUNCIADO_RESP
    FROM DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP
    WHERE RESPUESTA_ID = Cn_IdRespuesta
      AND DOCUMENTO_ENUNCIADO_ID = Cn_DocEnunciado;

  -- Variables globales de empresa - usuario
    Ln_CodEmpresa              INTEGER;
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';
    Lv_EnunciadoId             VARCHAR2(400);
    Lv_DescripcionEnunciado    VARCHAR2(400);
    Lv_TituloEnunciado         VARCHAR2(400);
    Lv_TagPlantilla            VARCHAR2(400);
    Lv_VisibleEnDoc            VARCHAR2(2);
    Lv_EstadoActivo            VARCHAR2(400):= 'Activo';

    --
    Lv_Cnombre                  VARCHAR2(400);
    Lv_Cdescripcion             VARCHAR2(400);
    Lv_CtagPlantilla            VARCHAR2(400);
    Lv_CvisibleEnDoc            VARCHAR2(400);

    --
    Ln_CountAttrEnunciado       INTEGER;
    Ln_OrdenAttrEnunciado       INTEGER;

    Lv_AttrValor                VARCHAR2(4000);
    Lv_Attrnombre               VARCHAR2(400);
    Lv_ValorAttrEnunciado       VARCHAR2(4000);
    Ln_atributoEnunciadoId      INTEGER;

    --
    Ln_CountReqParaContEnun     INTEGER;
    Ln_CountEsDefaultEnunci     INTEGER;
    Ln_CountLstRespuesta        INTEGER;

    Ln_OrdenPregEnunciado       INTEGER;
    Lv_ValueEsDefaultEnunciado  VARCHAR2(400);
    Lv_ValueReqParaContEnunciado VARCHAR2(400);

    --
    Lv_DocumentoEnunciadoId     INTEGER;
    Lv_EsDefaultEnunciado       VARCHAR2(400);
    Lv_ReqParaContEnunciado     VARCHAR2(400);
    Lv_valorRespuesta           VARCHAR2(400);
    Ln_respuestaId              INTEGER;
    Ln_idRespNumeric            INTEGER;
    Lv_idRespuesta              VARCHAR2(400);
    Ln_idDocRespEnunciado       INTEGER;

    --
    Lv_ValidarValoresNuloIzq    VARCHAR2(30):='{{}}';
    Lv_ValidarValoresNuloDer    VARCHAR2(30):='****';
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Ln_CodEmpresa           := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrCreacion          := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp            := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_EnunciadoId          := APEX_JSON.get_varchar2(p_path => 'enunciado.enunciadoId');
    Lv_TituloEnunciado      := APEX_JSON.get_varchar2(p_path => 'enunciado.tituloEnunciado');
    Lv_DescripcionEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado.descripcionEnunciado');
    Lv_TagPlantilla         := APEX_JSON.get_varchar2(p_path => 'enunciado.tagPlantilla');
    Lv_VisibleEnDoc         := APEX_JSON.get_varchar2(p_path => 'enunciado.visibleEnDocumento');

    Ln_CountAttrEnunciado   := APEX_JSON.GET_COUNT(p_path => 'enunciado.atributoEnunciado');
    Ln_CountReqParaContEnun := APEX_JSON.GET_COUNT(p_path => 'enunciado.requeridoParaContinuarEnunciado');
    Ln_CountEsDefaultEnunci := APEX_JSON.GET_COUNT(p_path => 'enunciado.esDefaultEnunciado');
    Ln_CountLstRespuesta    := APEX_JSON.GET_COUNT(p_path => 'enunciado.lstRespuestas');
    
    -- Validar que el enunciado exista
    OPEN C_GET_ENUNCIADO(Lv_EnunciadoId);
    FETCH C_GET_ENUNCIADO INTO Lv_Cnombre,Lv_Cdescripcion,Lv_CtagPlantilla,Lv_CvisibleEnDoc;
    CLOSE C_GET_ENUNCIADO;
    
    IF Lv_Cnombre IS NOT NULL AND TRIM(UPPER(Lv_Cnombre)) <> TRIM(UPPER(Lv_TituloEnunciado)) THEN
      UPDATE DB_DOCUMENTO.ADMI_ENUNCIADO
      SET NOMBRE = Lv_TituloEnunciado,
      USUARIO_MODIFICACION = Lv_UsrCreacion,
      FECHA_MODIFICACION = SYSDATE
      WHERE ID_ENUNCIADO = Lv_EnunciadoId;
      --
      COMMIT;
      --
    END IF;

    IF TRIM(UPPER(NVL(Lv_Cdescripcion, Lv_ValidarValoresNuloIzq))) <> TRIM(UPPER(NVL(Lv_DescripcionEnunciado, Lv_ValidarValoresNuloDer))) THEN
      UPDATE DB_DOCUMENTO.ADMI_ENUNCIADO
      SET DESCRIPCION = Lv_DescripcionEnunciado,
          USUARIO_MODIFICACION = Lv_UsrCreacion,
          FECHA_MODIFICACION = SYSDATE
      WHERE ID_ENUNCIADO = Lv_EnunciadoId;
      --
      COMMIT;
      --
    END IF;

    IF TRIM(UPPER(NVL(Lv_CtagPlantilla, Lv_ValidarValoresNuloIzq))) <> TRIM(UPPER(NVL(Lv_TagPlantilla, Lv_ValidarValoresNuloDer))) THEN
      UPDATE DB_DOCUMENTO.ADMI_ENUNCIADO
      SET TAG_PLANTILLA = Lv_TagPlantilla,
          USUARIO_MODIFICACION = Lv_UsrCreacion,
          FECHA_MODIFICACION = SYSDATE
      WHERE ID_ENUNCIADO = Lv_EnunciadoId;
      --
      COMMIT;
      --
    END IF;

    IF TRIM(UPPER(Lv_CvisibleEnDoc)) <> TRIM(UPPER(Lv_VisibleEnDoc)) THEN
      UPDATE DB_DOCUMENTO.ADMI_ENUNCIADO
      SET VISIBLE_EN_DOCUMENTO = Lv_VisibleEnDoc,
          USUARIO_MODIFICACION = Lv_UsrCreacion,
          FECHA_MODIFICACION = SYSDATE
      WHERE ID_ENUNCIADO = Lv_EnunciadoId;
      --
      COMMIT;
      --
    END IF;


    IF Ln_CountAttrEnunciado > 0 THEN
      FOR i IN 1..Ln_CountAttrEnunciado LOOP
        Lv_ValorAttrEnunciado := NULL;
        -- Validar que el atributo exista
        Lv_Attrnombre := APEX_JSON.get_varchar2(p_path => 'enunciado.atributoEnunciado[%d].nombreAtrrEnunciado',  p0 => i);
        Lv_AttrValor  := APEX_JSON.get_varchar2(p_path => 'enunciado.atributoEnunciado[%d].valorAttrEnunciado',  p0 => i);
        --
        OPEN C_GET_ENUNCIADO_ATTR(Lv_EnunciadoId, Lv_Attrnombre);
        FETCH C_GET_ENUNCIADO_ATTR INTO Lv_ValorAttrEnunciado;
        CLOSE C_GET_ENUNCIADO_ATTR;
        --
        IF Lv_ValorAttrEnunciado IS NULL AND Lv_AttrValor IS NOT NULL 
          AND LENGTH(Lv_AttrValor) > 0 THEN
          OPEN C_GET_ORDEN_ATR_ENUN;
          FETCH C_GET_ORDEN_ATR_ENUN INTO Ln_OrdenAttrEnunciado;
          CLOSE C_GET_ORDEN_ATR_ENUN;
          INSERT INTO DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO (ID_ATRIBUTO_ENUNCIADO,
                                                                  ENUNCIADO_ID,
                                                                  NOMBRE,
                                                                  VALOR,
                                                                  ORDEN,
                                                                  ESTADO,
                                                                  USUARIO_CREACION,
                                                                  FECHA_CREACION)
              VALUES (DB_DOCUMENTO.SEQ_ADMI_ATRIBUTO_ENUNCIADO.NEXTVAL,
                      Lv_EnunciadoId,
                      Lv_Attrnombre,
                      Lv_AttrValor,
                      Ln_OrdenAttrEnunciado,
                      Lv_EstadoActivo,
                      Lv_UsrCreacion,
                      SYSDATE)
              RETURNING ID_ATRIBUTO_ENUNCIADO INTO Ln_atributoEnunciadoId;
          --
          ELSE IF TRIM(UPPER(Lv_ValorAttrEnunciado)) <> TRIM(UPPER(Lv_AttrValor)) OR 
                  (Lv_AttrValor IS NULL AND Lv_ValorAttrEnunciado IS NOT NULL) THEN
            UPDATE DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO
            SET VALOR = Lv_AttrValor,
                USUARIO_MODIFICACION = Lv_UsrCreacion,
                FECHA_MODIFICACION = SYSDATE
            WHERE ENUNCIADO_ID = Lv_EnunciadoId
            AND NOMBRE = Lv_Attrnombre;
          END IF;
        END IF;
      END LOOP;
    END IF;

    --
    -- Proceso de validación de respuesta del enunciado
    --
    OPEN C_GET_DOCUMENTO_ENUNCIADO(Lv_EnunciadoId);
    FETCH C_GET_DOCUMENTO_ENUNCIADO INTO Lv_DocumentoEnunciadoId;
    CLOSE C_GET_DOCUMENTO_ENUNCIADO;

    IF Lv_DocumentoEnunciadoId IS NOT NULL THEN
      -- Procedo a setear en estado eliminado las respuesta
      UPDATE DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP
      SET ESTADO = 'Eliminado',
          ES_DEFAULT  = 'N',
          REQUERIDO_PARA_CONTINUAR = 'N',
          USUARIO_MODIFICACION = Lv_UsrCreacion,
          FECHA_MODIFICACION = SYSDATE
      WHERE DOCUMENTO_ENUNCIADO_ID = Lv_DocumentoEnunciadoId;
      --
      COMMIT;
      --

      IF Ln_CountLstRespuesta > 0 THEN
        Ln_OrdenPregEnunciado := 0;
        FOR i IN 1 .. Ln_CountLstRespuesta LOOP
          APEX_JSON.PARSE(Pcl_Request);
          Lv_EsDefaultEnunciado   := 'N';
          Lv_ReqParaContEnunciado := 'N';
          Lv_valorRespuesta       := NULL;
          Ln_respuestaId          := NULL;
          Ln_idRespNumeric        := NULL;
          Lv_idRespuesta          := APEX_JSON.get_varchar2(p_path => 'enunciado.lstRespuestas[%d]',  p0 => i);
          --
          -- Buscar la respuesta no existe en la base de datos.
          --
          SELECT LENGTH(TRIM(TRANSLATE(Lv_idRespuesta, ' +-.0123456789',' '))) INTO Ln_idRespNumeric FROM dual;
          IF Ln_idRespNumeric IS NULL
          THEN
            OPEN C_GET_RESPUESTA(Lv_idRespuesta);
            FETCH C_GET_RESPUESTA INTO Ln_respuestaId, Lv_valorRespuesta;
            CLOSE C_GET_RESPUESTA;
          END IF;
          DBMS_OUTPUT.PUT_LINE('Respuesta: ' || Lv_idRespuesta);
          DBMS_OUTPUT.PUT_LINE('Valor: ' || Lv_valorRespuesta);
          Ln_OrdenPregEnunciado := Ln_OrdenPregEnunciado + 1;
          --
          -- Consultar si la respuesta es default y permitida para continuar el flujo
          --
          IF Ln_respuestaId IS NOT NULL
          THEN
            IF Ln_CountEsDefaultEnunci > 0 THEN
              FOR k IN 1 .. Ln_CountEsDefaultEnunci LOOP
                Lv_ValueEsDefaultEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado.esDefaultEnunciado[%d]',  p0 => k);
                IF TO_CHAR(Ln_respuestaId) = Lv_ValueEsDefaultEnunciado
                THEN
                  Lv_EsDefaultEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
            IF Ln_CountReqParaContEnun > 0 THEN
              FOR k IN 1 .. Ln_CountReqParaContEnun LOOP
                Lv_ValueReqParaContEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado.requeridoParaContinuarEnunciado[%d]', p0 => k);
                IF TO_CHAR(Ln_respuestaId) = Lv_ValueReqParaContEnunciado
                THEN
                  Lv_ReqParaContEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
          END IF;


          IF Ln_respuestaId IS NULL
          THEN

            INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA (ID_RESPUESTA,
                                                        NOMBRE,
                                                        VALOR,
                                                        EMPRESA_COD,
                                                        ESTADO,
                                                        USUARIO_CREACION,
                                                        FECHA_CREACION)
            VALUES (DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
                    Lv_idRespuesta,
                    Lv_idRespuesta,
                    Ln_CodEmpresa,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE)
            RETURNING ID_RESPUESTA INTO Ln_respuestaId;
            --
            -- Se valida si la respuesta es default y permitida para continuar el flujo
            --
            IF Ln_CountEsDefaultEnunci > 0 THEN
              FOR i IN 1 .. Ln_CountEsDefaultEnunci LOOP
                Lv_ValueEsDefaultEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado.esDefaultEnunciado[%d]',  p0 => i);
                IF Lv_idRespuesta = Lv_ValueEsDefaultEnunciado
                THEN
                  Lv_EsDefaultEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
            IF Ln_CountReqParaContEnun > 0 THEN
              FOR i IN 1 .. Ln_CountReqParaContEnun LOOP
                Lv_ValueReqParaContEnunciado := APEX_JSON.get_varchar2(p_path => 'enunciado.requeridoParaContinuarEnunciado[%d]',  p0 => i);
                IF Lv_idRespuesta = Lv_ValueReqParaContEnunciado
                THEN
                  Lv_ReqParaContEnunciado := 'S';
                END IF;
              END LOOP;
            END IF;
          --
          --
          END IF;

          --
          DBMS_OUTPUT.PUT_LINE('DOC ENUNCIADO A BUSCAR: ' || Lv_DocumentoEnunciadoId);
          DBMS_OUTPUT.PUT_LINE('RESPUESTA ENUNCIADO: ' || Lv_ReqParaContEnunciado);
          Ln_idDocRespEnunciado := null;
          OPEN C_GET_RESPUESTA_ENUNCIADO(Ln_respuestaId, Lv_DocumentoEnunciadoId);
          FETCH C_GET_RESPUESTA_ENUNCIADO INTO Ln_idDocRespEnunciado;
          CLOSE C_GET_RESPUESTA_ENUNCIADO;
          --
          IF Ln_idDocRespEnunciado IS NULL THEN
            INSERT INTO DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP (ID_DOC_ENUNCIADO_RESP,
                                                                  DOCUMENTO_ENUNCIADO_ID,
                                                                  RESPUESTA_ID,
                                                                  ES_DEFAULT,
                                                                  REQUERIDO_PARA_CONTINUAR,
                                                                  REQUIERE_JUSTIFICACION,
                                                                  ORDEN,
                                                                  ESTADO,
                                                                  USUARIO_CREACION,
                                                                  FECHA_CREACION)
              VALUES (DB_DOCUMENTO.SEQ_ADMI_DOC_ENUNCIADO_RESP.NEXTVAL,
                      Lv_DocumentoEnunciadoId,
                      Ln_respuestaId,
                      Lv_EsDefaultEnunciado,
                      Lv_ReqParaContEnunciado,
                      'S',
                      Ln_OrdenPregEnunciado,
                      Lv_EstadoActivo,
                      Lv_UsrCreacion,
                      SYSDATE);
              ELSE
                UPDATE DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP
                SET ESTADO = Lv_EstadoActivo,
                    ES_DEFAULT  = Lv_EsDefaultEnunciado,
                    REQUERIDO_PARA_CONTINUAR = Lv_ReqParaContEnunciado,
                    USUARIO_MODIFICACION = NULL,
                    FECHA_MODIFICACION = NULL
                WHERE RESPUESTA_ID = Ln_respuestaId
                  AND DOCUMENTO_ENUNCIADO_ID = Lv_DocumentoEnunciadoId;
              END IF;
        END LOOP;
      END IF;

    END IF;
    OPEN Pcl_Response FOR
    SELECT 'Encuesta actualizada' AS mensaje
    FROM   DUAL;
    --
    COMMIT;
    --
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_ADMINISTRACION_ACTUALIZAR',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');

  END P_ADMINISTRACION_ACTUALIZAR;

  PROCEDURE P_OBTIENE_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) AS


  -- Estados
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';

  -- Variables globales de empresa - usuario
    Ln_CodEmpresa              INTEGER;
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

  --Variables de salida
    Ln_procesoId               INTEGER;
    Lv_nombreProceso           VARCHAR2(100);
    Lv_codigoProceso           VARCHAR2(100);
    Lv_nombreDocumento         VARCHAR2(100);
    Lv_codigoDocumento         VARCHAR2(100);
    Lv_descripcionDocumento    VARCHAR2(100);

  --VARIABLE CURSOR
    Lc_Response                  SYS_REFCURSOR;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_NombreProceso      := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Lv_NombreDocumento    := APEX_JSON.get_varchar2(p_path => 'nombreDocumento');
    IF Lv_NombreProceso IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreProceso ');
    END IF;
    IF Lv_NombreDocumento IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreDocumento ');
    END IF;
    OPEN Lc_Response FOR SELECT
    adpr.id_proceso   idProceso,
    adpr.nombre       nombreProceso,
    adpr.codigo       codigoProceso,
    addo.id_documento idDocumento,
    addo.nombre       nombreDocumento,
    addo.codigo       codigoDocumento,
    addo.descripcion  descripcionDocumento,
    CURSOR(SELECT
              aden.id_enunciado idEnunciado,
              aden.nombre       nombreEnunciado,
              aden.descripcion  descripcionEnunciado,
              aden.tag_plantilla tagPlantilla,
              aden.VISIBLE_EN_DOCUMENTO       visibleEnDocumento,
              CURSOR(SELECT
                        adre.id_respuesta               idRespuesta,
                        adre.nombre                     nombreRespuesta,
                        adre.valor                      valorRespuesta,
                        ader.es_default                 esDefault,
                        ader.requerido_para_continuar   esRequerido
                    FROM
                        DB_DOCUMENTO.admi_doc_enunciado_resp  ader,
                        DB_DOCUMENTO.admi_documento_enunciado adden,
                        DB_DOCUMENTO.admi_respuesta           adre
                    WHERE
                        adre.id_respuesta = ader.respuesta_id
                        AND ader.documento_enunciado_id = adden.id_documento_enunciado
                        AND adden.id_documento_enunciado = adde.id_documento_enunciado
                        AND ader.estado = Lv_EstadoActivo) respuestas,
              CURSOR(SELECT
                        adae.ID_ATRIBUTO_ENUNCIADO      idAtributoEnunciado,
                        adae.NOMBRE                     nombreAttributo,
                        adae.VALOR                      valorAttributo
                    FROM
                        DB_DOCUMENTO.admi_atributo_enunciado  adae
                    WHERE
                        adae.ENUNCIADO_ID = aden.ID_ENUNCIADO
                        AND adae.estado = Lv_EstadoActivo) attRespuestas
          FROM
              DB_DOCUMENTO.admi_enunciado           aden,
              DB_DOCUMENTO.admi_documento_enunciado adde
          WHERE
              aden.id_enunciado = adde.enunciado_id
              AND adde.documento_id = addo.id_documento
              AND aden.estado = Lv_EstadoActivo
              ORDER BY adde.orden ASC) enunciado
    FROM
        DB_DOCUMENTO.admi_proceso   adpr,
        DB_DOCUMENTO.admi_documento addo
    WHERE
        adpr.id_proceso = addo.proceso_id
        AND adpr.nombre = Lv_NombreProceso
        AND addo.nombre = Lv_NombreDocumento
        AND adpr.estado = Lv_EstadoActivo
        AND addo.estado = Lv_EstadoActivo;

    APEX_JSON.initialize_clob_output;

    APEX_JSON.write(Lc_Response);

    Pcl_Response := ltrim(SUBSTR(APEX_JSON.get_clob_output, 1, LENGTH(APEX_JSON.get_clob_output) - 2), '[');

    APEX_JSON.free_output;
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_OBTIENE_CLAUSULA',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');

  END P_OBTIENE_CLAUSULA;

  PROCEDURE P_OBTIENE_CLAUSULA_X_ENUNCIADO(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) AS


  -- Estados
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';

  -- Variables globales de empresa - usuario
    Ln_CodEmpresa              INTEGER;
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

  --Variables de salida
    Ln_procesoId               INTEGER;
    Lv_nombreProceso           VARCHAR2(100);
    Lv_codigoProceso           VARCHAR2(100);
    Lv_nombreDocumento         VARCHAR2(100);
    Lv_codigoDocumento         VARCHAR2(100);
    Lv_descripcionDocumento    VARCHAR2(100);
    Ln_EnunciadoId             INTEGER;

  --VARIABLE CURSOR
    Lc_Response                  SYS_REFCURSOR;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_NombreProceso      := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Lv_NombreDocumento    := APEX_JSON.get_varchar2(p_path => 'nombreDocumento');
    Ln_EnunciadoId        := APEX_JSON.get_varchar2(p_path => 'enunciadoId');
    IF Lv_NombreProceso IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreProceso ');
    END IF;
    IF Lv_NombreDocumento IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreDocumento ');
    END IF;
    OPEN Lc_Response FOR SELECT
              aden.id_enunciado idEnunciado,
              aden.nombre       nombreEnunciado,
              aden.descripcion  descripcionEnunciado,
              aden.tag_plantilla tagPlantilla,
              aden.VISIBLE_EN_DOCUMENTO       visibleEnDocumento,
              CURSOR(SELECT
                        adre.id_respuesta               idRespuesta,
                        adre.nombre                     nombreRespuesta,
                        adre.valor                      valorRespuesta,
                        ader.es_default                 esDefault,
                        ader.requerido_para_continuar   esRequerido
                    FROM
                        DB_DOCUMENTO.admi_doc_enunciado_resp  ader,
                        DB_DOCUMENTO.admi_documento_enunciado adden,
                        DB_DOCUMENTO.admi_respuesta           adre
                    WHERE
                        adre.id_respuesta = ader.respuesta_id
                        AND ader.documento_enunciado_id = adden.id_documento_enunciado
                        AND adden.id_documento_enunciado = adde.id_documento_enunciado
                        AND ader.estado = Lv_EstadoActivo) respuestas,
              CURSOR(SELECT
                        adae.ID_ATRIBUTO_ENUNCIADO      idAtributoEnunciado,
                        adae.NOMBRE                     nombreAttributo,
                        adae.VALOR                      valorAttributo
                    FROM
                        DB_DOCUMENTO.admi_atributo_enunciado  adae
                    WHERE
                        adae.ENUNCIADO_ID = aden.ID_ENUNCIADO
                        AND adae.estado = Lv_EstadoActivo) attRespuestas
          FROM
              DB_DOCUMENTO.admi_enunciado           aden,
              DB_DOCUMENTO.admi_documento_enunciado adde,
              DB_DOCUMENTO.admi_proceso             adpr,
              DB_DOCUMENTO.admi_documento           addo
          WHERE
              aden.id_enunciado = adde.enunciado_id
              AND adpr.id_proceso = addo.proceso_id
              AND adpr.nombre = Lv_NombreProceso
              AND addo.nombre = Lv_NombreDocumento
              AND adpr.estado = Lv_EstadoActivo
              AND addo.estado = Lv_EstadoActivo
              AND adde.documento_id = addo.id_documento
              AND aden.estado = Lv_EstadoActivo
              AND aden.id_enunciado = Ln_EnunciadoId
              ORDER BY adde.orden ASC;

    APEX_JSON.initialize_clob_output;

    APEX_JSON.write(Lc_Response);

    Pcl_Response := ltrim(SUBSTR(APEX_JSON.get_clob_output, 1, LENGTH(APEX_JSON.get_clob_output) - 2), '[');

    APEX_JSON.free_output;
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_OBTIENE_CLAUSULA_X_ENUNCIADO',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');

  END P_OBTIENE_CLAUSULA_X_ENUNCIADO;

  

  PROCEDURE P_CONSULTA_CLAUSULA_BANC(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) AS
  -- Estados
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';
    Lv_EstadoPreActivo         VARCHAR2(400) := 'PreActivo';

  -- Variables globales de empresa - usuario
    Ln_CodEmpresa              INTEGER;
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

  -- Variables de entrada
    Ln_puntoId                 INTEGER;
    Lv_NombreProceso           VARCHAR2(400);
    Lv_NombreDocumento         VARCHAR2(400);
  --VARIABLE CURSOR
    Lc_Response                  SYS_REFCURSOR;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);

    Ln_puntoId            := APEX_JSON.get_varchar2(p_path => 'puntoId');
    Lv_NombreProceso      := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Lv_NombreDocumento    := APEX_JSON.get_varchar2(p_path => 'nombreDocumento');

    IF Ln_puntoId IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro puntoId ');
    END IF;
    IF Lv_NombreProceso IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreProceso ');
    END IF;
    IF Lv_NombreDocumento IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreDocumento ');
    END IF;

    OPEN Lc_Response FOR SELECT
    adpr.id_proceso   idProceso,
    adpr.nombre       nombreProceso,
    adpr.codigo       codigoProceso,
    addo.id_documento idDocumento,
    addo.nombre       nombreDocumento,
    addo.codigo       codigoDocumento,
    addo.descripcion  descripcionDocumento,
    CURSOR(SELECT
              aden.id_enunciado idEnunciado,
              aden.nombre       nombreEnunciado,
              aden.descripcion  descripcionEnunciado,
              aden.tag_plantilla tagPlantilla,
              aden.VISIBLE_EN_DOCUMENTO       visibleEnDocumento,
              CURSOR(SELECT
                        adre.id_respuesta               idRespuesta,
                        adre.nombre                     nombreRespuesta,
                        adre.valor                      valorRespuesta,
                        ader.es_default                 esDefault,
                        ader.requerido_para_continuar   esRequerido
                    FROM
                        DB_DOCUMENTO.admi_doc_enunciado_resp  ader,
                        DB_DOCUMENTO.admi_documento_enunciado adden,
                        DB_DOCUMENTO.admi_respuesta           adre
                    WHERE
                        adre.id_respuesta = ader.respuesta_id
                        AND ader.documento_enunciado_id = adden.id_documento_enunciado
                        AND adden.id_documento_enunciado = adde.id_documento_enunciado
                        AND ader.estado = Lv_EstadoActivo) respuestas,
              CURSOR(SELECT
                        adae.ID_ATRIBUTO_ENUNCIADO      idAtributoEnunciado,
                        adae.NOMBRE                     nombreAttributo,
                        adae.VALOR                      valorAttributo
                    FROM
                        DB_DOCUMENTO.admi_atributo_enunciado  adae
                    WHERE
                        adae.ENUNCIADO_ID = aden.ID_ENUNCIADO
                        AND adae.estado = Lv_EstadoActivo) attRespuestas
          FROM
              DB_DOCUMENTO.admi_enunciado           aden,
              DB_DOCUMENTO.admi_documento_enunciado adde
          WHERE
              aden.id_enunciado = adde.enunciado_id
              AND adde.documento_id = addo.id_documento
              AND aden.estado = Lv_EstadoActivo
              ORDER BY adde.orden ASC) enunciado,
    CURSOR(SELECT
              ipcr_.DOC_ENUNCIADO_RESP_ID   docEnunciadoRespId,
              aden.id_enunciado             idEnunciado,
              aden.nombre                   nombreEnunciado,
              aden.descripcion              descripcionEnunciado,
              adre.id_respuesta             idrespuesta,
              adre.nombre                   nombrerespuesta,
              adre.valor                    valorrespuesta,
              ader.es_default               esdefault,
              ader.requerido_para_continuar esrequerido
          FROM
            db_comercial.info_punto_clausula      ipcl_,
            db_comercial.info_punto_clausula_resp ipcr_,
            db_documento.admi_doc_enunciado_resp  ader,
            db_documento.admi_documento_enunciado adden,
            db_documento.admi_respuesta           adre,
            DB_DOCUMENTO.admi_enunciado           aden
          WHERE
              ipcl_.id_punto_clausula = ipcr_.punto_clausula_id
            AND ipcr_.doc_enunciado_resp_id = ader.id_doc_enunciado_resp
            AND ader.documento_enunciado_id = adden.id_documento_enunciado
            AND ader.respuesta_id = adre.id_respuesta
            AND adden.enunciado_id = aden.id_enunciado
            AND ipcl_.punto_id = Ln_puntoId
            AND ( ipcl_.estado = Lv_EstadoActivo
                  OR ipcl_.estado = Lv_EstadoPreActivo )
            AND ( ipcr_.estado = Lv_EstadoActivo
                  OR ipcl_.estado = Lv_EstadoPreActivo )
              ORDER BY adden.orden ASC) enunciadoResp
    FROM
        DB_DOCUMENTO.admi_proceso   adpr,
        DB_DOCUMENTO.admi_documento addo
    WHERE
        adpr.id_proceso = addo.proceso_id
        AND adpr.nombre = Lv_NombreProceso
        AND addo.nombre = Lv_NombreDocumento
        AND adpr.estado = Lv_EstadoActivo
        AND addo.estado = Lv_EstadoActivo;
    APEX_JSON.initialize_clob_output;
    APEX_JSON.write(Lc_Response);
    Pcl_Response := ltrim(SUBSTR(APEX_JSON.get_clob_output, 1, LENGTH(APEX_JSON.get_clob_output) - 2), '[');
    APEX_JSON.free_output;
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_CONSULTA_CLAUSULA_BANC',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
  END P_CONSULTA_CLAUSULA_BANC;

  

  PROCEDURE P_ELIMINA_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) AS
  CURSOR C_GET_DOCUMENTO_ENUNCIADO(Cn_EnunciadoId NUMBER) IS
  SELECT
    ID_DOCUMENTO_ENUNCIADO
  FROM DB_DOCUMENTO.admi_documento_enunciado
  where enunciado_id = Cn_EnunciadoId;

  -- Estados
    Lv_EstadoEliminado       VARCHAR2(400) := 'Eliminado';

  -- Variables globales de empresa - usuario
    Ln_CodEmpresa            INTEGER;
    Lv_UsrCreacion           VARCHAR2(15) := 'telcos';
    Lv_ClienteIp             VARCHAR2(400) := '127.0.0.1';
    Ln_EnunciadoId           INTEGER;

  --Variables
  Ln_DocEnunciadoId          INTEGER;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Ln_EnunciadoId        := APEX_JSON.get_varchar2(p_path => 'enunciadoId');

    IF Ln_EnunciadoId IS NULL THEN
      RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro nombreProceso ');
    END IF;

    OPEN C_GET_DOCUMENTO_ENUNCIADO(Ln_EnunciadoId);
    FETCH C_GET_DOCUMENTO_ENUNCIADO INTO Ln_DocEnunciadoId;
    CLOSE C_GET_DOCUMENTO_ENUNCIADO;

    --
    -- Eliminamos de la ADMI_DOC_ENUNCIADO_RESP
    --
    UPDATE DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP
    SET ESTADO = Lv_EstadoEliminado,
        USUARIO_MODIFICACION = Lv_UsrCreacion,
        FECHA_MODIFICACION = SYSDATE
    WHERE
        DOCUMENTO_ENUNCIADO_ID = Ln_DocEnunciadoId;

    --
    -- Eliminamos de la admi_documento_enunciado
    --
    UPDATE DB_DOCUMENTO.admi_documento_enunciado
    SET ESTADO = Lv_EstadoEliminado,
        USUARIO_MODIFICACION = Lv_UsrCreacion,
        FECHA_MODIFICACION = SYSDATE
    WHERE
        ENUNCIADO_ID = Ln_EnunciadoId;

    --
    -- Eliminamos de la admi_documento_enunciado_resp
    --
    UPDATE DB_DOCUMENTO.ADMI_ENUNCIADO
    SET ESTADO = Lv_EstadoEliminado,
        USUARIO_MODIFICACION = Lv_UsrCreacion,
        FECHA_MODIFICACION = SYSDATE
    WHERE
        ID_ENUNCIADO = Ln_EnunciadoId;

    --
    COMMIT;
    --
    OPEN Pcl_Response FOR
    SELECT 'Enunciado eliminado exitosamente!' AS mensaje
    from DUAL;
    --
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_ELIMINA_CLAUSULA',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
  END P_ELIMINA_CLAUSULA;
  
END DOKG_CLAUSULA_TRANSACCION;
/