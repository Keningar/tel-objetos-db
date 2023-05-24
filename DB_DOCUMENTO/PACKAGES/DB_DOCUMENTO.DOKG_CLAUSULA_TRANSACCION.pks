CREATE OR REPLACE PACKAGE DB_DOCUMENTO.DOKG_CLAUSULA_TRANSACCION
AS
   
   /**
    * Documentación para la función P_OBTIENE_ENUNCIADO
    * Procedimiento que obtiene el enunciado indiferente del documeto o proceso.
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    *
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.1 11-10-2022
    *
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.2 01-03-2023 Se añade validación en excepción para cambiar estatus
    *
    * Se realizan los ajustes para multiempresa
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.3 28-02-2023 
    *
    */
    PROCEDURE P_OBTIENE_ENUNCIADO(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB);

    /**
    * Documentación para la función P_RESPUESTA_ENCUESTA
    * Procedimiento que obtiene las respuestas del cliente en base a la encuesta.
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    *
    * @author Carlos Caguana. <ccaguana@telconet.ec>
    * @version 1.0 11-11-2022
    */
    PROCEDURE P_RESPUESTA_ENCUESTA(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);   

   /**
    * Documentación para la función P_INFO_DOCUMENTO_CARAC
    * Procedimiento que obtiene los documentos guardados en la tabla de info_documento_relacion
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    *
    * @author Carlos Caguana. <ccaguana@telconet.ec>
    * @version 1.1 11-11-2022
    */
   PROCEDURE P_INFO_DOCUMENTO_CARAC(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);

   /**
    * Documentación para la función P_OBTENER_ADMI_DOCUMENTO
    * Procedimiento que realiza el filtrado de los registros en ADMI_DOCUMENTO permitiendo la inclusion de la empresa
    * Adecuacion necesaria para Ecuanet
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    *
    * @author Miguel Guzman. <mguzman@telconet.ec>
    * @version 1.1 01-03-2023
    */
   PROCEDURE P_OBTENER_ADMI_DOCUMENTO(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);
END DOKG_CLAUSULA_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY DB_DOCUMENTO.DOKG_CLAUSULA_TRANSACCION
AS

  PROCEDURE P_OBTIENE_ENUNCIADO(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) AS

  CURSOR C_AdmEnunciadoHija(Cn_EmpresaCod NUMBER, Cv_IdEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT ID_ENUNCIADO,
           NOMBRE,
           CODIGO,
           DESCRIPCION,
           TAG_PLANTILLA,
           EMPRESA_COD,
           USUARIO_CREACION,
           FECHA_CREACION,
           FECHA_MODIFICACION,
           USUARIO_MODIFICACION,
           ESTADO,
           ENUNCIADO_ID
    FROM   DB_DOCUMENTO.ADMI_ENUNCIADO
    WHERE  ENUNCIADO_ID = Cv_IdEnunciado
    AND    ESTADO = Cv_ESTADO
    AND    EMPRESA_COD = Cn_EmpresaCod;
  --
  CURSOR C_DocumentoRelacionado( Cn_EmpresaCod NUMBER,  Cv_IdEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT ADDO.ID_DOCUMENTO,
           ADDO.NOMBRE,
           ADEN.VISIBLE_EN_DOCUMENTO
    FROM   DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN,
           DB_DOCUMENTO.ADMI_DOCUMENTO ADDO,
           DB_DOCUMENTO.admi_enunciado ADEC
    WHERE  ADDO.ID_DOCUMENTO = ADEN.DOCUMENTO_ID
    AND    ADEN.ENUNCIADO_ID = Cv_IdEnunciado
    AND    ADEC.ID_ENUNCIADO = ADEN.ENUNCIADO_ID
    AND    ADEC.EMPRESA_COD  = Cn_EmpresaCod
    AND    ADEN.ESTADO = Cv_ESTADO
    AND    ADDO.ESTADO = Cv_ESTADO;
  --
  CURSOR C_Atributos(Cn_EmpresaCod NUMBER, Cv_IdEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT ACEN.ID_CAB_ENUNCIADO,
           AAEN.ID_ATRIBUTO_ENUNCIADO,
           AAEN.VALOR,
           AAEN.NOMBRE,
           ACEN.CODIGO,
           ACEN.REFERENCIA_TABLA
    FROM   DB_DOCUMENTO.ADMI_ENUNCIADO ADEN,
           DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO AAEN,
           DB_DOCUMENTO.ADMI_CAB_ENUNCIADO ACEN
    WHERE  ADEN.ID_ENUNCIADO = AAEN.ENUNCIADO_ID
    AND    ACEN.ID_CAB_ENUNCIADO = AAEN.CAB_ENUNCIADO_ID
    AND    ADEN.ID_ENUNCIADO = Cv_IdEnunciado
    AND    ACEN.ESTADO = Cv_ESTADO
    AND    AAEN.ESTADO = Cv_ESTADO
    AND    ADEN.ESTADO = Cv_ESTADO
    AND    ADEN.EMPRESA_COD =  Cn_EmpresaCod 
    AND    ACEN.EMPRESA_COD =  Cn_EmpresaCod 
    ORDER BY ACEN.ORDEN ASC;
  --
    CURSOR C_AdmDocEnunciadoResp(Cn_EmpresaCod NUMBER, Cv_IdEnunciado NUMBER,Cv_IdDocumento NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT ADER.ID_DOC_ENUNCIADO_RESP,
           ADER.RESPUESTA_ID
    FROM   DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP ADER, 
           DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN,
           DB_DOCUMENTO.ADMI_ENUNCIADO ADEC
    WHERE  ader.documento_enunciado_id = aden.id_documento_enunciado
    AND    aden.enunciado_id  = Cv_IdEnunciado
    AND    ADEC.ID_ENUNCIADO = Cv_IdEnunciado
    AND    ADEC.EMPRESA_COD = Cn_EmpresaCod
    AND    aden.estado  = Cv_ESTADO
    AND    ADEN.DOCUMENTO_ID=Cv_IdDocumento
    AND    ADER.ESTADO = Cv_ESTADO;
  --
  CURSOR C_AdmiRespuesta(Cn_EmpresaCod NUMBER, Cv_RespuestaId NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT ID_RESPUESTA,
           VALOR
    FROM   DB_DOCUMENTO.ADMI_RESPUESTA
    WHERE  ID_RESPUESTA = Cv_RespuestaId
    AND    ESTADO = Cv_ESTADO
    AND    EMPRESA_COD =  Cn_EmpresaCod ;
  --
  CURSOR C_EsPadre(Cn_EmpresaCod NUMBER, Cv_IdEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT DISTINCT(1)
    FROM   DB_DOCUMENTO.ADMI_ENUNCIADO
    WHERE  ENUNCIADO_ID = Cv_IdEnunciado
    AND    ESTADO = Cv_ESTADO
    AND    EMPRESA_COD =  Cn_EmpresaCod ;
  --
  CURSOR C_EsHija(Cn_EmpresaCod NUMBER, Cv_IdEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
    SELECT ID_ENUNCIADO, ENUNCIADO_ID
    FROM   DB_DOCUMENTO.ADMI_ENUNCIADO
    WHERE  ID_ENUNCIADO = Cv_IdEnunciado
    AND    ESTADO = Cv_ESTADO
    AND    EMPRESA_COD =  Cn_EmpresaCod ;
  --
  Ln_EmpresaCod       NUMBER;
  Ln_IdEnunciado      NUMBER;
  Ln_esHija           NUMBER:=0;
  Lb_HayEnuncia       BOOLEAN:=FALSE;
  Lc_AdmiRespuesta    C_AdmiRespuesta%ROWTYPE;
  Lv_RefTabla         VARCHAR2(100);
  Lv_sqlRefTabla      VARCHAR2(100);
  Lv_ValorTributoName VARCHAR2(4000);
  Lv_ValorTributo     VARCHAR2(4000);
  Lv_mostrarTodo      VARCHAR2(10):='N';
  Lv_sqlAdmiEnunciado VARCHAR2(4000);
  Lv_IdEnunciado      VARCHAR2(40);
  Lv_EnunciadoBusca   VARCHAR2(40);
  Lv_esPadre          VARCHAR2(40);
  Ln_aplicaA          NUMBER;
  Ln_arregloEstado    NUMBER;
  Lv_aplicaA          VARCHAR2(400);

  Lv_arregloEstado    VARCHAR2(400);
  Lv_RequiereWhere    VARCHAR2(10):='N';
  Lv_estado           VARCHAR2(100);
  Ln_ValorEnunciado   NUMBER;
  Ln_IteradorI        NUMBER;
  Ln_IteradorH        NUMBER;

  Ln_enunciadoHija    NUMBER;
  Ln_enunciadoPadre   NUMBER;

  Ln_enunciadoHijaValido   NUMBER;

  TYPE t_getEnunciado
      IS
      TABLE OF C_AdmEnunciadoHija%ROWTYPE INDEX BY PLS_INTEGER;
  v_getEnunciado t_getEnunciado;
  Lb_HayHijaPermitida  BOOLEAN:=FALSE;

  --
  Lv_sqlEjecutar      VARCHAR2(4000);
  Lv_sqlPadre         VARCHAR2(4000);

  Lv_sqlHija         VARCHAR2(4000);
  Lv_sqlHijaWhere    VARCHAR2(4000);


  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Ln_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Ln_IdEnunciado         := APEX_JSON.get_varchar2(p_path => 'idEnunciado');
    Lv_mostrarTodo         := APEX_JSON.get_varchar2(p_path => 'mostrarTodo');
    Lv_aplicaA             := APEX_JSON.get_varchar2(p_path => 'aplicaA');
    Lv_estado              := APEX_JSON.get_varchar2(p_path => 'estado');
    --
    IF Lv_mostrarTodo IS NULL THEN
      Lv_mostrarTodo := 'N';
    END IF;

    Lv_sqlAdmiEnunciado    := 'SELECT ADME.ID_ENUNCIADO,
                                      ADME.NOMBRE,
                                      ADME.CODIGO,
                                      ADME.DESCRIPCION,
                                      ADME.TAG_PLANTILLA,
                                      ADME.EMPRESA_COD,
                                      ADME.USUARIO_CREACION,
                                      ADME.FECHA_CREACION,
                                      ADME.FECHA_MODIFICACION,
                                      ADME.USUARIO_MODIFICACION,
                                      ADME.ESTADO,
                                      ADME.ENUNCIADO_ID
                                FROM  DB_DOCUMENTO.ADMI_ENUNCIADO ADME ';
    Lv_sqlPadre             := 'SELECT
                                      CADME.ID_ENUNCIADO,
                                      CADME.NOMBRE,
                                      CADME.CODIGO,
                                      CADME.DESCRIPCION,
                                      CADME.TAG_PLANTILLA,
                                      CADME.EMPRESA_COD,
                                      CADME.USUARIO_CREACION,
                                      CADME.FECHA_CREACION,
                                      CADME.FECHA_MODIFICACION,
                                      CADME.USUARIO_MODIFICACION,
                                      CADME.ESTADO,
                                      CADME.ENUNCIADO_ID
                                      FROM  DB_DOCUMENTO.ADMI_ENUNCIADO CADME 
                                      WHERE CADME.EMPRESA_COD ='|| Ln_EmpresaCod  ||'
                                      AND  CADME.ID_ENUNCIADO IN ( ';
    IF Lv_aplicaA IS NOT NULL THEN
      Lv_RequiereWhere := 'S';
      Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' ,DB_DOCUMENTO.ADMI_DOCUMENTO ADOC, DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN 
                                                      WHERE ADOC.ID_DOCUMENTO = ADEN.DOCUMENTO_ID
                                                            AND ADME.EMPRESA_COD = '|| Ln_EmpresaCod  ||'
                                                            AND ADEN.ENUNCIADO_ID = ADME.ID_ENUNCIADO
                                                            AND ADOC.NOMBRE IN (SELECT REGEXP_SUBSTR(TRIM('''||Lv_aplicaA||'''),''[^,]+'', 1, LEVEL) FROM DUAL
                                                            CONNECT BY REGEXP_SUBSTR(TRIM('''||Lv_aplicaA||'''),''[^,]+'', 1, LEVEL) IS NOT NULL) ';
      Lv_sqlPadre := Lv_sqlPadre || 'SELECT
                                        DISTINCT(padme.enunciado_id) 
                                        FROM db_documento.admi_enunciado      padme,
                                        db_documento.admi_documento           padoc,
                                        db_documento.admi_documento_enunciado paden
                                        WHERE padoc.id_documento = paden.documento_id
                                        AND padme.EMPRESA_COD ='|| Ln_EmpresaCod  ||' 
                                        AND paden.enunciado_id = padme.id_enunciado
                                        AND PADOC.NOMBRE IN (SELECT REGEXP_SUBSTR(TRIM('''||Lv_aplicaA||'''),''[^,]+'', 1, LEVEL) FROM DUAL
                                        CONNECT BY REGEXP_SUBSTR(TRIM('''||Lv_aplicaA||'''),''[^,]+'', 1, LEVEL) IS NOT NULL) ';


     Lv_sqlHijaWhere:=' AND PADOC.NOMBRE IN (SELECT REGEXP_SUBSTR(TRIM('''||Lv_aplicaA||'''),''[^,]+'', 1, LEVEL) FROM DUAL
                                        CONNECT BY REGEXP_SUBSTR(TRIM('''||Lv_aplicaA||'''),''[^,]+'', 1, LEVEL) IS NOT NULL)';


    ELSE
      Lv_RequiereWhere := 'S';
      Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' ,DB_DOCUMENTO.ADMI_DOCUMENTO ADOC, DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN 
                                                      WHERE ADOC.ID_DOCUMENTO = ADEN.DOCUMENTO_ID                                                      
                                                      AND ADME.EMPRESA_COD = '|| Ln_EmpresaCod  ||'
                                                      AND ADEN.ENUNCIADO_ID = ADME.ID_ENUNCIADO ';
      Lv_sqlPadre := Lv_sqlPadre || 'SELECT
                                        DISTINCT(padme.enunciado_id) 
                                        FROM db_documento.admi_enunciado      padme,
                                        db_documento.admi_documento           padoc,
                                        db_documento.admi_documento_enunciado paden
                                        WHERE padoc.id_documento = paden.documento_id
                                        AND padme.EMPRESA_COD ='|| Ln_EmpresaCod  ||' 
                                        AND paden.enunciado_id = padme.id_enunciado';
    END IF;

    --
    IF Lv_estado IS NOT NULL THEN
      IF Lv_RequiereWhere = 'S' THEN
        Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' AND ';
        Lv_sqlPadre         := Lv_sqlPadre || ' AND ';
      ELSE
        Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' WHERE ';
        Lv_sqlPadre         := Lv_sqlPadre || ' WHERE ';
      END IF;
      --
      Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado ||'  ADME.ESTADO IN (SELECT REGEXP_SUBSTR(TRIM('''||Lv_estado||'''),''[^,]+'', 1, LEVEL) FROM DUAL
                                  CONNECT BY REGEXP_SUBSTR(TRIM('''||Lv_estado||'''),''[^,]+'', 1, LEVEL) IS NOT NULL) ';
      Lv_sqlPadre := Lv_sqlPadre ||'  PADME.ESTADO IN (SELECT REGEXP_SUBSTR(TRIM('''||Lv_estado||'''),''[^,]+'', 1, LEVEL) FROM DUAL
                                  CONNECT BY REGEXP_SUBSTR(TRIM('''||Lv_estado||'''),''[^,]+'', 1, LEVEL) IS NOT NULL) ';                          
    ELSE
      IF Lv_RequiereWhere = 'S' THEN
        Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' AND ADME.ESTADO = ''Activo'' ';
        Lv_sqlPadre         := Lv_sqlPadre || ' AND PADME.ESTADO = ''Activo'' ';
      ELSE
        Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' WHERE ADME.ESTADO = ''Activo'' ';
        Lv_sqlPadre         := Lv_sqlPadre || ' WHERE PADME.ESTADO = ''Activo'' ';
      END IF;
    END IF;

    --
    Lv_sqlPadre := Lv_sqlPadre || ' AND padme.enunciado_id IS NOT NULL) ';
    --
    IF Ln_IdEnunciado IS NOT NULL AND Lv_mostrarTodo <> 'S' THEN
      IF Lv_RequiereWhere <> 'S' THEN
        Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' WHERE ';
        Lv_sqlPadre         := Lv_sqlPadre || ' WHERE ';
      ELSE
        Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' AND ';
        Lv_sqlPadre         := Lv_sqlPadre || ' AND ';
      END IF;
      Lv_RequiereWhere := 'S';
      --
      Lv_sqlAdmiEnunciado := Lv_sqlAdmiEnunciado || ' ADME.ID_ENUNCIADO = ' || Ln_IdEnunciado;
      Lv_sqlPadre         := Lv_sqlPadre || ' CADME.ID_ENUNCIADO = ' || Ln_IdEnunciado;
      --
    END IF;

    --
    Lv_sqlEjecutar := Lv_sqlAdmiEnunciado || '  UNION ALL '|| Lv_sqlPadre;
    Lv_sqlEjecutar := 'SELECT DISTINCT a.* FROM (' || Lv_sqlEjecutar || ') a ORDER BY ID_ENUNCIADO';
    dbms_output.put_line(Lv_sqlEjecutar);
    EXECUTE IMMEDIATE Lv_sqlEjecutar BULK COLLECT INTO v_getEnunciado;
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    apex_json.open_array;
    Ln_IteradorI := v_getEnunciado.FIRST;
    WHILE (Ln_IteradorI IS NOT NULL) 
    LOOP
      Lb_HayEnuncia       := TRUE;
      Lv_IdEnunciado      := NULL;
      Lv_EnunciadoBusca   := NULL;
      Lv_esPadre          := NULL;
      Ln_ValorEnunciado   := NULL;
      --
      Ln_esHija         := 0;
      Lv_IdEnunciado    := v_getEnunciado(Ln_IteradorI).ID_ENUNCIADO;
      Lv_EnunciadoBusca := v_getEnunciado(Ln_IteradorI).ENUNCIADO_ID;
      Ln_enunciadoPadre := NULL;

      --
      --Consultar si ese enunciado es padre
      --
    dbms_output.put_line(Lv_IdEnunciado);

      OPEN C_EsPadre( Ln_EmpresaCod, Lv_IdEnunciado, 'Activo');
      FETCH C_EsPadre INTO Lv_esPadre;
      CLOSE C_EsPadre;

      IF Lv_esPadre IS NOT NULL THEN
        Ln_esHija := 1;
      END IF;

      dbms_output.put_line('Es padre'|| Lv_esPadre);

      --
      OPEN C_EsHija( Ln_EmpresaCod, Lv_IdEnunciado, 'Activo');
      FETCH C_EsHija INTO Ln_enunciadoHija, Ln_enunciadoPadre;
      CLOSE C_EsHija;      

      IF Ln_enunciadoPadre IS NOT NULL AND Ln_IdEnunciado IS NULL THEN
        Ln_IteradorI := v_getEnunciado.NEXT(Ln_IteradorI);
        CONTINUE;
      END IF;


      APEX_JSON.open_object;
      APEX_JSON.WRITE('idEnunciado', v_getEnunciado(Ln_IteradorI).ID_ENUNCIADO);
      APEX_JSON.WRITE('nombre', v_getEnunciado(Ln_IteradorI).NOMBRE);
      APEX_JSON.WRITE('codigo', v_getEnunciado(Ln_IteradorI).CODIGO);
      APEX_JSON.WRITE('descripcion', v_getEnunciado(Ln_IteradorI).DESCRIPCION);
      APEX_JSON.WRITE('tagPlantilla', v_getEnunciado(Ln_IteradorI).TAG_PLANTILLA);
      APEX_JSON.WRITE('empresaCod', v_getEnunciado(Ln_IteradorI).EMPRESA_COD);
      APEX_JSON.WRITE('usrCreacion', v_getEnunciado(Ln_IteradorI).USUARIO_CREACION);
      APEX_JSON.WRITE('feCreacion', v_getEnunciado(Ln_IteradorI).FECHA_CREACION);
      APEX_JSON.WRITE('feModificacion', v_getEnunciado(Ln_IteradorI).FECHA_MODIFICACION);
      APEX_JSON.WRITE('usrModificacion', v_getEnunciado(Ln_IteradorI).USUARIO_MODIFICACION);
      APEX_JSON.WRITE('estado', v_getEnunciado(Ln_IteradorI).ESTADO);


      APEX_JSON.OPEN_ARRAY('clausulas');
      --
      IF Ln_esHija = 1 THEN
      dbms_output.put_line('condicional es hija '|| Lv_IdEnunciado );

        FOR S IN C_AdmEnunciadoHija( Ln_EmpresaCod, Lv_IdEnunciado, 'Activo') LOOP
          Lb_HayHijaPermitida:=false; 
          Lv_sqlHija :=  'SELECT
                                        DISTINCT(padme.enunciado_id)  
                                        FROM db_documento.admi_enunciado           padme,
                                        db_documento.admi_documento           padoc,
                                        db_documento.admi_documento_enunciado paden
                                        WHERE  padme.EMPRESA_COD ='|| Ln_EmpresaCod  ||'
                                        AND   padoc.id_documento = paden.documento_id ';
 
          Lv_sqlHija      := Lv_sqlHija || ' AND padme.id_enunciado = ' || S.ID_ENUNCIADO;     
          Lv_sqlHija      := Lv_sqlHija || ' AND ROWNUM=1 ';                                  
          Lv_sqlHija      := Lv_sqlHija || ' AND paden.enunciado_id = padme.id_enunciado';
          Lv_sqlHija      := Lv_sqlHija || Lv_sqlHijaWhere;
          dbms_output.put_line(Lv_sqlHija);          
          BEGIN
                EXECUTE IMMEDIATE Lv_sqlHija  INTO Ln_enunciadoHijaValido;  
                Lb_HayHijaPermitida:=TRUE; 
          EXCEPTION
                WHEN OTHERS THEN
                dbms_output.put_line('No pertenece este id '||S.ID_ENUNCIADO);          
                Lb_HayHijaPermitida:=FALSE; 
          END;

          IF Lb_HayHijaPermitida =TRUE THEN

          APEX_JSON.open_object;
          APEX_JSON.WRITE('idEnunciado', S.ID_ENUNCIADO);
          APEX_JSON.WRITE('nombre', S.NOMBRE);
          APEX_JSON.WRITE('codigo', S.CODIGO);
          APEX_JSON.WRITE('descripcion', S.DESCRIPCION);
          APEX_JSON.WRITE('tagPlantilla', S.TAG_PLANTILLA);
          APEX_JSON.WRITE('empresaCod', S.EMPRESA_COD);
          APEX_JSON.WRITE('usrCreacion', S.USUARIO_CREACION);
          APEX_JSON.WRITE('feCreacion', S.FECHA_CREACION);
          APEX_JSON.WRITE('feModificacion', S.FECHA_MODIFICACION);
          APEX_JSON.WRITE('usrModificacion', S.USUARIO_MODIFICACION);
          APEX_JSON.WRITE('estado', S.ESTADO);
          APEX_JSON.OPEN_ARRAY('clausulas');
          APEX_JSON.CLOSE_ARRAY; --clausulas

          APEX_JSON.OPEN_ARRAY('documentos');
          FOR D IN  C_DocumentoRelacionado(Ln_EmpresaCod, S.ID_ENUNCIADO, 'Activo')   LOOP
            APEX_JSON.open_object;
            APEX_JSON.WRITE('idDocumento', D.ID_DOCUMENTO);
            APEX_JSON.WRITE('nombreDocumento', D.NOMBRE);
            APEX_JSON.WRITE('visibleEnDocumento', D.VISIBLE_EN_DOCUMENTO);

            --
            APEX_JSON.OPEN_ARRAY('respuestas');
            FOR l IN  C_AdmDocEnunciadoResp(Ln_EmpresaCod, S.ID_ENUNCIADO,D.ID_DOCUMENTO, 'Activo')   LOOP
                OPEN C_AdmiRespuesta(Ln_EmpresaCod, l.RESPUESTA_ID, 'Activo');
                FETCH C_AdmiRespuesta INTO Lc_AdmiRespuesta;
                CLOSE C_AdmiRespuesta;
                    APEX_JSON.open_object;
                    APEX_JSON.WRITE('idRespuesta', Lc_AdmiRespuesta.ID_RESPUESTA);
                    APEX_JSON.WRITE('idDocEnunciadoResp', l.ID_DOC_ENUNCIADO_RESP);
                    APEX_JSON.WRITE('valorRespuesta', Lc_AdmiRespuesta.VALOR);
                    APEX_JSON.close_object;
            END LOOP;
            APEX_JSON.CLOSE_ARRAY;  -- respuestas
            --
            APEX_JSON.close_object;
          END LOOP;
          APEX_JSON.CLOSE_ARRAY; --documentos

          APEX_JSON.OPEN_ARRAY('atributos');
          FOR m IN  C_Atributos(Ln_EmpresaCod, S.ID_ENUNCIADO, 'Activo')   LOOP
            Lv_ValorTributoName := NULL;
            Lv_ValorTributo := m.VALOR;
            IF m.REFERENCIA_TABLA IS NOT NULL THEN
              Lv_RefTabla := m.REFERENCIA_TABLA;
              BEGIN
                EXECUTE IMMEDIATE Lv_RefTabla INTO Lv_ValorTributoName 
                USING m.VALOR, 'Activo';
              EXCEPTION
                WHEN OTHERS THEN
                  CONTINUE;
              END;
            ELSE
              Lv_ValorTributoName := m.VALOR;
            END IF;
            Lv_ValorTributo := m.VALOR;
            APEX_JSON.open_object;
            APEX_JSON.WRITE('idCabEnunciado', m.ID_CAB_ENUNCIADO);
            APEX_JSON.WRITE('idAtributoEnunciado', m.ID_ATRIBUTO_ENUNCIADO);
            APEX_JSON.WRITE('valor', Lv_ValorTributo);
            APEX_JSON.WRITE('valorName', Lv_ValorTributoName);
            APEX_JSON.WRITE('nombreCabEnunciado', m.NOMBRE);
            APEX_JSON.WRITE('codigo', m.CODIGO);
            APEX_JSON.close_object;
          END LOOP;
          APEX_JSON.CLOSE_ARRAY;  -- atributos


          APEX_JSON.close_object;

           END IF;

        END LOOP;
      END IF;
      --
      APEX_JSON.CLOSE_ARRAY;  -- clausulas
      --

      APEX_JSON.OPEN_ARRAY('documentos');
      --
      IF Ln_esHija = 0 THEN
        FOR D IN  C_DocumentoRelacionado(Ln_EmpresaCod, Lv_IdEnunciado, 'Activo')   LOOP
          APEX_JSON.open_object;
          APEX_JSON.WRITE('idDocumento', D.ID_DOCUMENTO);
          APEX_JSON.WRITE('nombreDocumento', D.NOMBRE);
          APEX_JSON.WRITE('visibleEnDocumento',D.VISIBLE_EN_DOCUMENTO);
            --
            --
            APEX_JSON.OPEN_ARRAY('respuestas');
            --
            IF Ln_esHija = 0 THEN
              FOR l IN  C_AdmDocEnunciadoResp(Ln_EmpresaCod,Lv_IdEnunciado,D.ID_DOCUMENTO, 'Activo')   LOOP
                OPEN C_AdmiRespuesta(Ln_EmpresaCod, l.RESPUESTA_ID, 'Activo');
                FETCH C_AdmiRespuesta INTO Lc_AdmiRespuesta;
                CLOSE C_AdmiRespuesta;
                IF Lc_AdmiRespuesta.ID_RESPUESTA IS NOT NULL THEN
                  APEX_JSON.open_object;
                  APEX_JSON.WRITE('idRespuesta', Lc_AdmiRespuesta.ID_RESPUESTA);
                  APEX_JSON.WRITE('idDocEnunciadoResp', l.ID_DOC_ENUNCIADO_RESP);
                  APEX_JSON.WRITE('valorRespuesta', Lc_AdmiRespuesta.VALOR);
                  APEX_JSON.close_object;
                END IF;
              END LOOP;
            END IF;
            --
            APEX_JSON.CLOSE_ARRAY;  -- respuestas
            --
            --
          APEX_JSON.close_object;
          --
        END LOOP;
      END IF;
      --
      APEX_JSON.CLOSE_ARRAY;  -- documentos
      --
      APEX_JSON.OPEN_ARRAY('atributos');
      --
      IF Ln_esHija = 0 THEN
        FOR m IN  C_Atributos(Ln_EmpresaCod, Lv_IdEnunciado, 'Activo')   LOOP
          Lv_ValorTributoName := NULL;
          Lv_ValorTributo := NULL;
          IF m.REFERENCIA_TABLA IS NOT NULL THEN
            Lv_RefTabla := m.REFERENCIA_TABLA;
            BEGIN
              EXECUTE IMMEDIATE Lv_RefTabla INTO Lv_ValorTributoName 
              USING m.VALOR, 'Activo';
            EXCEPTION
              WHEN OTHERS THEN
                CONTINUE;
            END;
          ELSE
            Lv_ValorTributoName := m.VALOR;
          END IF;
          Lv_ValorTributo := m.VALOR;
          APEX_JSON.open_object;
          APEX_JSON.WRITE('idCabEnunciado', m.ID_CAB_ENUNCIADO);
          APEX_JSON.WRITE('idAtributoEnunciado', m.ID_ATRIBUTO_ENUNCIADO);
          APEX_JSON.WRITE('valor', Lv_ValorTributo);
          APEX_JSON.WRITE('valorName', Lv_ValorTributoName);
          APEX_JSON.WRITE('nombreCabEnunciado', m.NOMBRE);
          APEX_JSON.WRITE('codigo', m.CODIGO);
          APEX_JSON.close_object;
        END LOOP;
      END IF;
      --
      APEX_JSON.CLOSE_ARRAY;  -- atributos
      --
      APEX_JSON.OPEN_ARRAY('respuestas');
      --

      --
      APEX_JSON.CLOSE_ARRAY;  -- respuestas
      --
    APEX_JSON.close_object; -- Cierre del objeto enunciado
    --
    Ln_IteradorI := v_getEnunciado.NEXT(Ln_IteradorI);
    END LOOP;
    --
    APEX_JSON.CLOSE_ARRAY;
    apex_json.close_all;
    Pcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    --
    IF NOT Lb_HayEnuncia THEN
      RAISE_APPLICATION_ERROR(-20101, 'No existen registros');
    END IF;
    --
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    IF SQLCODE = -20101 THEN
      Pv_Status  := 'ERROR-CONTROL';
    END IF;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.DOKG_CLAUSULA_TRANSACCION.P_OBTIENE_ENUNCIADO',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
  END P_OBTIENE_ENUNCIADO;

  PROCEDURE P_RESPUESTA_ENCUESTA(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Ln_IdDocumentoRelacion       NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdDocumentoRelacion      := APEX_JSON.get_number(p_path => 'idDocumentoRelacion');
    Lcl_Select       := '
              SELECT
              IPCR.ID_DOC_RESPUESTA         idDocRespuesta,
              IPCR.DOC_ENUNCIADO_RESP_ID    docEnunciadoRespId,
              ADEN.ID_ENUNCIADO             idEnunciado,
              ADEN.NOMBRE                   nombreEnunciado,
              DOC.ID_DOCUMENTO              idDocumento,
              DOC.NOMBRE                    nombreDocumento,
              ADEN.DESCRIPCION              descripcionEnunciado,
              adre.ID_RESPUESTA             idRespuesta,
              adre.NOMBRE                   nombreRespuesta,
              adre.VALOR                    valorRespuesta';
    Lcl_From  := ' FROM
                DB_DOCUMENTO.INFO_DOCUMENTO_RELACION  IPCL,
                DB_DOCUMENTO.INFO_DOC_RESPUESTA       IPCR,
                DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP  ADER,
                DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADDEN,
                DB_DOCUMENTO.ADMI_DOCUMENTO           DOC,
                DB_DOCUMENTO.ADMI_RESPUESTA           ADRE,
                DB_DOCUMENTO.ADMI_ENUNCIADO           ADEN';

    Lcl_WhereAndJoin := '
               WHERE
                IPCL.ID_DOCUMENTO_RELACION = IPCR.DOCUMENTO_RELACION_ID
                AND IPCR.DOC_ENUNCIADO_RESP_ID = ADER.ID_DOC_ENUNCIADO_RESP
                AND ADER.DOCUMENTO_ENUNCIADO_ID = ADDEN.ID_DOCUMENTO_ENUNCIADO
                AND DOC.ID_DOCUMENTO=ADDEN.DOCUMENTO_ID
                AND ADER.RESPUESTA_ID = ADRE.ID_RESPUESTA
                AND ADDEN.ENUNCIADO_ID = ADEN.ID_ENUNCIADO
                    AND IPCR.ESTADO = ''Activo''';             
    Lcl_WhereAndJoin := Lcl_WhereAndJoin || 'AND IPCL.ID_DOCUMENTO_RELACION = '||Ln_IdDocumentoRelacion;   
    Lcl_OrderAnGroup := '
              ORDER BY ADDEN.orden ASC';
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;
    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_RESPUESTA_ENCUESTA;


 PROCEDURE P_INFO_DOCUMENTO_CARAC(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Select_General CLOB;
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Ln_IdDocumentoRelacion       NUMBER;
    Ln_NombreDocumento           VARCHAR2(200);
    Lv_IdEstado                  VARCHAR2(500);
    Lv_ListEstado                VARCHAR2(1000);
    Ln_CountListEstado           INTEGER :=0;
    Lb_FiltroListEstado    BOOLEAN := FALSE;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdDocumentoRelacion      := APEX_JSON.get_number(p_path => 'idDocumentoRelacion');
    Ln_NombreDocumento          := APEX_JSON.get_varchar2(p_path => 'nombreDocumento');
    Ln_CountListEstado        := APEX_JSON.GET_COUNT(p_path => 'listEstado');
    IF Ln_CountListEstado IS NOT NULL THEN
      FOR i IN 1 .. Ln_CountListEstado LOOP
        Lv_IdEstado         := APEX_JSON.get_varchar2(p_path => 'listEstado[%d]',  p0 => i);
        Lv_ListEstado       := CONCAT(Lv_ListEstado,CONCAT(''''||Lv_IdEstado||'''',','));
        Lb_FiltroListEstado := TRUE;
      END LOOP;
    END IF; 
    IF Ln_NombreDocumento IS NULL AND Ln_IdDocumentoRelacion IS null  THEN
        Pv_Mensaje := 'Un parámetro es requerido ';
        RAISE Le_Errors;
    END IF;    
    Lcl_Select       := '
              (SELECT
              IPCL.ID_DOCUMENTO_RELACION    idDocumentoRelacion';
    Lcl_From  := ' 
              FROM
                 DB_DOCUMENTO.INFO_DOCUMENTO_RELACION  IPCL,
                 DB_DOCUMENTO.INFO_DOC_RESPUESTA       IPCR,
                 DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP  ADER,
               DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADDEN,
               DB_DOCUMENTO.ADMI_DOCUMENTO           DOC';               
    Lcl_WhereAndJoin := '
               WHERE
                IPCL.ID_DOCUMENTO_RELACION = IPCR.DOCUMENTO_RELACION_ID
              AND IPCR.DOC_ENUNCIADO_RESP_ID = ADER.ID_DOC_ENUNCIADO_RESP
              AND ADER.DOCUMENTO_ENUNCIADO_ID = ADDEN.ID_DOCUMENTO_ENUNCIADO
              AND DOC.ID_DOCUMENTO=ADDEN.DOCUMENTO_ID
                AND IPCR.ESTADO = ''Activo''';             
    IF Ln_NombreDocumento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND DOC.NOMBRE = '''||Ln_NombreDocumento||'''';
    END IF;
    IF Ln_IdDocumentoRelacion IS NOT NULL THEN
    Lcl_WhereAndJoin := Lcl_WhereAndJoin ||  'AND IPCL.ID_DOCUMENTO_RELACION = '||Ln_IdDocumentoRelacion;   
    END IF;        
    IF Lb_FiltroListEstado THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IPCL.ESTADO IN ('||SUBSTR(Lv_ListEstado, 1, LENGTHB(Lv_ListEstado) - 1)||')';
    END IF;  
    Lcl_OrderAnGroup := 'GROUP BY  IPCL.ID_DOCUMENTO_RELACION)';
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;

    Lcl_Select_General:='SELECT IPCL1.ID_DOCUMENTO_RELACION  idDocumentoRelacion,
                      IPCL1.PROCESO  proceso,
                      IPCL1.ESTADO  estado,
                      IPCL1.OBSERVACION  observacion,
                      IPCL1.USUARIO_CREACION  usrCreacion,
                      IPCL1.FECHA_CREACION  feCreacion,
                      IPCL1.USUARIO_MODIFICACION  usrUltMod,
                      IPCL1.FECHA_MODIFICACION  feUltMod
                                  FROM  DB_DOCUMENTO.INFO_DOCUMENTO_RELACION  IPCL1
                         WHERE ID_DOCUMENTO_RELACION IN('||Lcl_Query||' )';

    OPEN Pcl_Response FOR Lcl_Select_General;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_INFO_DOCUMENTO_CARAC;

PROCEDURE P_OBTENER_ADMI_DOCUMENTO (Pcl_Request  IN  CLOB,
 	Pv_Status OUT VARCHAR2,
	Pv_Mensaje OUT VARCHAR2,
	Pcl_Response OUT SYS_REFCURSOR)
AS
    Lcl_Query CLOB;
    Lcl_Select CLOB;
    Lcl_Where CLOB;
    Ln_IdDocumento NUMBER;
    Ln_Nombre VARCHAR2(200);
    Lv_Codigo VARCHAR2(50);
    Ln_Descripcion VARCHAR2(200);
    Lv_Proceso NUMBER;
    Ln_Estado VARCHAR2(10);
    Ln_UsuarioCreacion VARCHAR2(50);
    Ln_FechaCreacion DATE;
    Ln_UsuarioModificacion VARCHAR2(50);
    Ln_FechaModificacion DATE;
    Ln_LlenarTodoDocumento VARCHAR2(1);
    Ln_EmpresaCod VARCHAR2(2);
    Le_Errors EXCEPTION;
	BEGIN
		-- RETORNO LAS VARIABLES DEL REQUEST
		APEX_JSON.PARSE(Pcl_Request);
		IF APEX_JSON.does_exist(p_path => 'idDocumento') THEN
			Ln_IdDocumento := APEX_JSON.get_number(p_path => 'idDocumento');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'nombre') THEN
			Ln_Nombre := APEX_JSON.get_varchar2(p_path => 'nombre');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'codigo') THEN
			Lv_Codigo := APEX_JSON.get_varchar2(p_path => 'codigo');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'descripcion') THEN
			Ln_Descripcion := APEX_JSON.get_varchar2(p_path => 'descripcion');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'procesoId') THEN
			Lv_Proceso := APEX_JSON.get_number(p_path => 'procesoId');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'estado') THEN
			Ln_Estado := APEX_JSON.get_varchar2(p_path => 'estado');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'usuarioCreacion') THEN
			Ln_UsuarioCreacion := APEX_JSON.get_number(p_path => 'usuarioCreacion');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'fechaCreacion') THEN
			Ln_FechaCreacion := APEX_JSON.get_date(p_path => 'fechaCreacion');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'usuarioModificacion') THEN
			Ln_UsuarioModificacion := APEX_JSON.get_varchar2(p_path => 'usuarioModificacion');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'fechaModificacion') THEN
			Ln_FechaModificacion := APEX_JSON.get_date(p_path => 'fechaModificacion');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'llenarTodoDocumento') THEN
			Ln_LlenarTodoDocumento := APEX_JSON.get_varchar2(p_path => 'llenarTodoDocumento');
		END IF;
		IF APEX_JSON.does_exist(p_path => 'empresaCod') THEN
			Ln_EmpresaCod := APEX_JSON.get_varchar2(p_path => 'empresaCod');
		END IF;

		Lcl_Query := 'SELECT d.ID_DOCUMENTO as ID_DOCUMENTO,
				d.NOMBRE as NOMBRE,
				d.CODIGO as CODIGO,
				d.DESCRIPCION as DESCRIPCION,
				d.PROCESO_ID as PROCESO_ID,
				d.ESTADO as ESTADO,
				d.USUARIO_CREACION as USUARIO_CREACION,
				d.FECHA_CREACION as FECHA_CREACION,
				d.USUARIO_MODIFICACION as USUARIO_MODIFICACION,
				d.FECHA_MODIFICACION as FECHA_MODIFICACION,
				d.LLENAR_TODO_DOCUMENTO as LLENAR_TODO_DOCUMENTO
			FROM DB_DOCUMENTO.ADMI_DOCUMENTO d
			INNER JOIN DB_DOCUMENTO.ADMI_PROCESO p ON d.PROCESO_ID = p.ID_PROCESO';
		
		IF Ln_IdDocumento IS NOT NULL OR
			Ln_Nombre IS NOT NULL OR
			Lv_Codigo IS NOT NULL OR
			Ln_Descripcion IS NOT NULL OR
			Lv_Proceso IS NOT NULL OR
			Ln_Estado IS NOT NULL OR
			Ln_UsuarioCreacion IS NOT NULL OR
			Ln_FechaCreacion IS NOT NULL OR
			Ln_UsuarioModificacion IS NOT NULL OR
			Ln_FechaModificacion IS NOT NULL OR
			Ln_LlenarTodoDocumento IS NOT NULL OR
			Ln_EmpresaCod IS NOT NULL THEN

			IF Ln_IdDocumento IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.ID_DOCUMENTO = ' || Ln_IdDocumento;
				ELSE
					Lcl_Where := ' WHERE d.ID_DOCUMENTO = ' || Ln_IdDocumento;
				END IF;
			END IF;
			IF Ln_Nombre IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.NOMBRE = ''' || Ln_Nombre || '''';
				ELSE
					Lcl_Where := ' WHERE d.NOMBRE = ''' || Ln_Nombre || '''';
				END IF;
			END IF;
			IF Lv_Codigo IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.CODIGO = ''' || Lv_Codigo || '''';
				ELSE
					Lcl_Where := ' WHERE d.CODIGO = ''' || Lv_Codigo || '''';
				END IF;
			END IF;
			IF Ln_Descripcion IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.DESCRIPCION = ''' || Ln_Descripcion || '''';
				ELSE
					Lcl_Where := ' WHERE d.DESCRIPCION = ''' || Ln_Descripcion || '''';
				END IF;
			END IF;
			IF Lv_Proceso IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.PROCESO_ID = ' || Lv_Proceso;
				ELSE
					Lcl_Where := ' WHERE d.PROCESO_ID = ' || Lv_Proceso;
				END IF;
			END IF;
			IF Ln_Estado IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.ESTADO = ''' || Ln_Estado || '''';
				ELSE
					Lcl_Where := ' WHERE d.ESTADO = ''' || Ln_Estado || '''';
				END IF;
			END IF;
			IF Ln_LlenarTodoDocumento IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.LLENAR_TODO_DOCUMENTO = ''' || Ln_LlenarTodoDocumento || '''';
				ELSE
					Lcl_Where := ' WHERE d.LLENAR_TODO_DOCUMENTO = ''' || Ln_LlenarTodoDocumento || '''';
				END IF;
			END IF;
			IF Ln_UsuarioCreacion IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.USUARIO_CREACION = ''' || Ln_UsuarioCreacion || '''';
				ELSE
					Lcl_Where := ' WHERE d.USUARIO_CREACION = ''' || Ln_UsuarioCreacion || '''';
				END IF;
			END IF;
			IF Ln_FechaCreacion IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.FECHA_CREACION = ''' || Ln_FechaCreacion || '''';
				ELSE
					Lcl_Where := ' WHERE d.FECHA_CREACION = ''' || Ln_FechaCreacion || '''';
				END IF;
			END IF;
			IF Ln_UsuarioModificacion IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.USUARIO_MODIFICACION = ''' || Ln_UsuarioModificacion || '''';
				ELSE
					Lcl_Where := ' WHERE d.USUARIO_MODIFICACION = ''' || Ln_UsuarioModificacion || '''';
				END IF;
			END IF;
			IF Ln_FechaModificacion IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND d.FECHA_MODIFICACION = ''' || Ln_FechaModificacion || '''';
				ELSE
					Lcl_Where := ' WHERE d.FECHA_MODIFICACION = ''' || Ln_FechaModificacion || '''';
				END IF;
			END IF;
			IF Ln_EmpresaCod IS NOT NULL THEN
				IF Lcl_Where IS NOT NULL THEN
					Lcl_Where := Lcl_Where || ' AND p.EMPRESA_COD = ''' || Ln_EmpresaCod || '''';
				ELSE
					Lcl_Where := ' WHERE p.EMPRESA_COD = ''' || Ln_EmpresaCod || '''';
				END IF;
			END IF;

		END IF;

		IF Lcl_Where IS NOT NULL THEN
			Lcl_Query := Lcl_Query || Lcl_Where;
		END IF;

		Lcl_Query := Lcl_Query || ' ORDER BY ID_DOCUMENTO DESC';

		OPEN Pcl_Response FOR Lcl_Query;

		Pv_Mensaje   := 'Proceso realizado con exito';
		Pv_Status    := 'OK';

		EXCEPTION WHEN Le_Errors THEN
			Pv_Status  := 'ERROR';
		WHEN OTHERS THEN
			Pv_Status  := 'ERROR';
			Pv_Mensaje := SQLERRM;
	END P_OBTENER_ADMI_DOCUMENTO;
END DOKG_CLAUSULA_TRANSACCION;
/
