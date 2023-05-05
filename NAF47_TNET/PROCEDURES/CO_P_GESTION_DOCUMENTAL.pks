create or replace PROCEDURE            CO_P_GESTION_DOCUMENTAL(Pv_noOrden       VARCHAR2,
                                                               Pv_noCia         VARCHAR2,
                                                               Pv_MensajeError  in out VARCHAR2,
                                                               Pv_NumeroFactura VARCHAR2 DEFAULT NULL,
                                                               Pv_NumeroRuc     VARCHAR2 DEFAULT NULL) IS
/**
  * Documentacion para CO_P_GESTION_DOCUMENTAL
  * Procedure que recupera imagenes de documentos de Sistema Gestor Documental e insertarlas en una tabla para ser visualizadas en NAF
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 04/12/2018
  *
  * @param Pv_noOrden       IN VARCHAR2     Recibe numero de pedido
  * @param Pv_NoCia         IN VARCHAR2     Recibe codigo de compania
  * @param Pv_MensajeError  IN OUT VARCHAR2 Retorna mensaje de error
  * @param Pv_NumeroFactura IN VARCHAR2     Recibde número de factura
  * @param Pv_NumeroRuc     IN VARCHAR2     Recibe número de RUC
  */
  --
  Lc_TipoFactura     CONSTANT VARCHAR2(2) := '01';
  Lc_EstadoAsignado  CONSTANT VARCHAR2(10) := 'Asignado';
  Lc_EstadoBloqueado CONSTANT VARCHAR2(10) := 'Bloqueado';
  Lc_EtqFactura      CONSTANT VARCHAR2(15) := 'documentNumber';
  Lc_EtqRuc          CONSTANT VARCHAR2(15) := 'ruc';
  --
  cursor c_url_GestDoc is
    select a.descripcion
      from ge_parametros a,
           ge_grupos_parametros b
     where a.id_grupo_parametro = b.id_grupo_parametro
       and a.id_aplicacion = b.id_aplicacion
       and a.id_empresa = b.id_empresa
       and a.parametro = 'URL'
       and a.id_grupo_parametro = 'URL_GEST_DOC'
       and a.id_aplicacion = 'CO'
       and a.id_empresa = Pv_noCia
       and a.estado = 'A'
       and b.estado = 'A';
  --
  CURSOR C_RECUPERA_FACTURA IS
    SELECT doc.path,
           doc.id_documento,
           doc.token,
           doc.estado
    FROM db_documental.admi_tipo_documento td,
         db_documental.admi_empresa em,
         db_documental.admi_empresa_usuario eu,
         db_documental.info_documento doc
    WHERE doc.estado IN (Lc_EstadoAsignado, Lc_EstadoBloqueado)
    AND td.codigo = Lc_TipoFactura
    AND EXISTS (SELECT NULL
                FROM db_documental.admi_tipo_docu_etiqueta atde,
                     db_documental.info_documento_tipo_docu_etiq dtde
                WHERE dtde.documento_id = doc.id_documento
                AND dtde.valor LIKE '%'||Pv_NumeroFactura
                AND atde.label_key = Lc_EtqFactura
                AND dtde.tipo_docu_etiqueta_id = atde.id_tipo_docu_etiqueta
               )
    AND EXISTS (SELECT NULL
                FROM db_documental.admi_tipo_docu_etiqueta atde,
                     db_documental.info_documento_tipo_docu_etiq dtde
                WHERE dtde.documento_id = doc.id_documento
                AND dtde.valor = Pv_NumeroRuc
                AND atde.label_key = Lc_EtqRuc
                AND dtde.tipo_docu_etiqueta_id = atde.id_tipo_docu_etiqueta
               )
    AND eu.empresa_id = em.id_empresa
    AND doc.propietario_id = eu.id_empresa_usuario
    AND doc.tipo_documento_id = td.id_tipo_documento;
  --
  Lf_lob           BFILE;
  Lb_existe        BOOLEAN := TRUE;
  Lb_lob           BLOB;
  Lv_NombreArchivo VARCHAR2(1000) := NULL;
  Lv_idArchivo     NUMBER(9);
  Lv_RutaArchivo   VARCHAR2(200); 
  Lv_Token         VARCHAR2(40); 
  Lv_Estado        VARCHAR2(10); 
  ln_numArchivo    number(3) := 0;
  Le_Error         Exception;
  Lv_urlGestDoc    Varchar2(500) := null;

BEGIN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'GestorDocumental-NAF',
        'CO_P_GESTION_DOCUMENTAL',
        'Pv_noOrden: '||Pv_noOrden||chr(10)||
        'Pv_noCia: '||Pv_noCia||chr(10)||
        'Pv_NumeroFactura: '||Pv_NumeroFactura||chr(10)||
        'Pv_NumeroRuc: '||Pv_NumeroRuc,
        USER,
        SYSDATE,
        '127.0.0.1'
        );


  ---------------------------------------------
  -- se limpia la tabla temporal de imagenes --
  ---------------------------------------------
  delete CO_DOCUMENTO_ORDEN a
   where a.usuario_crea = user;

  commit;

  -- se busca url de gestion documental para visualizar en gestion documental --
  if c_url_GestDoc%isopen then close c_url_GestDoc; end if;
  open c_url_GestDoc;
  fetch c_url_GestDoc into Lv_urlGestDoc;
  close c_url_GestDoc;

  if Lv_urlGestDoc is not null then
    if substr(Lv_urlGestDoc, length(Lv_urlGestDoc), 1) != '/' then
      Lv_urlGestDoc := Lv_urlGestDoc||'/';
    end if;
  end if;
  --
  IF Pv_NumeroFactura IS NULL THEN -- no se envio busqueda por numero de factura se consulta por OC
    ----------------------------------------------
    -- realizar busqueda en gestion documental. --
    ----------------------------------------------
    DB_DOCUMENTAL.INFO_P_DATOS_ARCHIVOS ( Pv_noOrden,
                                          Pv_noCia,
                                          Lv_RutaArchivo,
                                          Lv_idArchivo,
                                          Lv_Token,
                                          Lv_Estado,
                                          Pv_MensajeError);

    IF Pv_MensajeError IS NOT NULL THEN
      Raise Le_Error;
    END IF;
    --
  ELSE
    --
    IF C_RECUPERA_FACTURA%ISOPEN THEN
      CLOSE C_RECUPERA_FACTURA;
    END IF;
    --no
    OPEN C_RECUPERA_FACTURA;
    FETCH C_RECUPERA_FACTURA INTO Lv_RutaArchivo,
                                  Lv_idArchivo,
                                  Lv_Token,
                                  Lv_Estado;
    IF C_RECUPERA_FACTURA%NOTFOUND THEN
      Lv_RutaArchivo := NULL;
      Lv_idArchivo := NULL;
      Lv_Token := NULL;
      Lv_Estado := NULL;
    END IF;
    CLOSE C_RECUPERA_FACTURA;
    --
  END IF;

  WHILE lb_existe LOOP
    Lv_NombreArchivo := '/' || Lv_RutaArchivo || to_char(Lv_idArchivo)||'-'||to_char(ln_numArchivo)||'.jpg';

    --Lf_lob    := BFILENAME('DIR_GESDOCUMENTAL2', Lv_nombreArchivo);
    Lf_lob    := BFILENAME('DIR_GESDOCUMENTAL', Lv_nombreArchivo);
    lb_existe := (DBMS_LOB.FILEEXISTS(Lf_lob) = 1);

    IF lb_existe THEN
      INSERT INTO CO_DOCUMENTO_ORDEN
        (no_cia,
         no_orden,
         secuencia,
         ruta_archivo,
         archivo,
         url_archivo,
         estado_archivo,
         usuario_crea,
         fecha_crea
          )
      VALUES
        (Pv_noCia,
         NVL(Pv_noOrden,Pv_NumeroFactura),
         ln_numArchivo+1,
         to_char(Lv_nombreArchivo),
         empty_blob(),
         Lv_urlGestDoc||Lv_Token,
         Lv_Estado,
         USER,
         SYSDATE) RETURN archivo INTO Lb_lob;

      Lf_lob := BFILENAME('DIR_GESDOCUMENTAL', Lv_nombreArchivo);
      dbms_lob.fileopen(Lf_lob, dbms_lob.file_readonly);
      dbms_lob.loadfromfile(Lb_lob, Lf_lob, dbms_lob.getlength(Lf_lob));
      dbms_lob.fileclose(Lf_lob);
    END IF;
    COMMIT;
    ln_numArchivo := ln_numArchivo + 1;    
  END LOOP;

EXCEPTION
  WHEN Le_Error THEN NULL;
  WHEN OTHERS THEN
    Pv_MensajeError := 'Inside Exception: ' || SQLERRM;
END;
