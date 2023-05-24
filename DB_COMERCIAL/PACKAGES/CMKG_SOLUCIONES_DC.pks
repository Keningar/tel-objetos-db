CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_SOLUCIONES_DC AS

  /**
   * Documentaci�n para el TYPE RECORD 'Gr_RecordElemento'.
   *
   * Record encargado de obtener los datos de la asignaci�n de la factibilidad dada a un cliente.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  TYPE Gr_RecordElemento IS RECORD (
    DESCRIPCIONRECURSO  DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB.DESCRIPCION_RECURSO%TYPE,
    NOMBRETIPOELEMENTO  DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE,
    IDFILA              DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBREFILA          DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    IDRACK              DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRERACK          DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    RESERVADOS          NUMBER
  );

  /**
   * Documentaci�n para el procedimiento 'P_GUARDAR_FACTIBILIDAD_COM'.
   *
   * M�todo encargado de guardar la factibilidad de comunicaci�n de una soluci�n DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  PROCEDURE P_GUARDAR_FACTIBILIDAD_COM(Pcl_Request IN  CLOB,
                                       Pv_Status   OUT VARCHAR2,
                                       Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentaci�n para el procedimiento 'P_GUARDAR_FACTIBILIDAD_PAC'.
   *
   * M�todo encargado de guardar la factibilidad Pac de una soluci�n DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  PROCEDURE P_GUARDAR_FACTIBILIDAD_PAC(Pcl_Request IN  CLOB,
                                       Pv_Status   OUT VARCHAR2,
                                       Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentaci�n para el procedimiento 'P_GUARDAR_FACTIBILIDAD_HOUS'.
   *
   * M�todo encargado de guardar la factibilidad Housing de una soluci�n DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  PROCEDURE P_GUARDAR_FACTIBILIDAD_HOUS(Pcl_Request IN  CLOB,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentaci�n para el procedimiento 'P_REVERSAR_FACTIBILIDAD_HOUS'.
   *
   * M�todo encargado de reversar la factibilidad Housing de una soluci�n DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 06-07-2020
   */
  PROCEDURE P_REVERSAR_FACTIBILIDAD_HOUS(Pcl_Request IN  CLOB,
                                         Pv_Status   OUT VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentaci�n para el procedimiento 'P_CREAR_SOLUCION'.
   *
   * M�todo encargado de crear una soluci�n DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pn_Solucion OUT NUMBER   Retorna el id de la soluci�n creada.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.1 12-08-2020 - Se modifica el m�todo en la parte de crear los recursos para
   *                           almacenar los datos solo si el atributo de 'dataRecurso.recursos'
   *                           no se encuentra vacio.
   */
  PROCEDURE P_CREAR_SOLUCION(Pcl_Request IN  CLOB,
                             Pn_Solucion OUT NUMBER,
                             Pv_Status   OUT VARCHAR2,
                             Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentaci�n para el procedimiento 'P_CREAR_RECURSOS'.
   *
   * M�todo encargado de crear los recursos de la soluci�n DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  PROCEDURE P_CREAR_RECURSOS(Pcl_Request IN  CLOB,
                             Pv_Status   OUT VARCHAR2,
                             Pv_Mensaje  OUT VARCHAR2);

END CMKG_SOLUCIONES_DC;
/


CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_SOLUCIONES_DC AS
----
----
  PROCEDURE P_REVERSAR_FACTIBILIDAD_HOUS(Pcl_Request IN  CLOB,
                                         Pv_Status   OUT VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_ObtenerRecursoCab(Cn_IdServicio NUMBER)
    IS
      SELECT ISRCAB.*
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB ISRCAB
      WHERE ISRCAB.SERVICIO_ID =  Cn_IdServicio
        AND ISRCAB.ESTADO      = 'Activo';

    CURSOR C_ObtenerRecursoDet(Cn_IdRecursoCab NUMBER)
    IS
      SELECT ISRDET.*
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET ISRDET
      WHERE ISRDET.SERVICIO_RECURSO_CAB_ID = Cn_IdRecursoCab
        AND ISRDET.ESTADO = 'Activo';

    CURSOR C_ObtenerTipoElemento(Cn_IdElemento NUMBER)
    IS
      SELECT
        ATE.NOMBRE_TIPO_ELEMENTO
      FROM
        DB_INFRAESTRUCTURA.INFO_ELEMENTO        IEL,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO   ATE
      WHERE
        IEL.ID_ELEMENTO            = Cn_IdElemento
        AND IEL.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
        AND AME.TIPO_ELEMENTO_ID   = ATE.ID_TIPO_ELEMENTO;

    CURSOR C_ObtenerRelacionElemento(Cn_IdElemento NUMBER)
    IS
      SELECT IRE.*
        FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE
      WHERE IRE.ELEMENTO_ID_A =  Cn_IdElemento
        AND ESTADO            = 'Activo';

    CURSOR C_ObtenerElementoFact
    IS
      SELECT IEL.*
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IEL
      WHERE IEL.NOMBRE_ELEMENTO = 'Equipos DC (TN/Clientes)';

    Lt_JsonIndex          APEX_JSON.T_VALUES;
    Le_Exception          EXCEPTION;
    Lv_Status             VARCHAR2(50);
    Lv_Mensaje            VARCHAR2(3000);
    Lb_HabilitaCommit     BOOLEAN;
    Lcl_Request           CLOB;
    Ln_ServicioId         NUMBER;
    Lc_ObtenerRecursoCab  C_ObtenerRecursoCab%ROWTYPE;
    Lc_TipoElemento       C_ObtenerTipoElemento%ROWTYPE;
    Lc_ElementoFact       C_ObtenerElementoFact%ROWTYPE;
    Lb_ActualizarFila     BOOLEAN;
    Lrf_ElementoRecurso   SYS_REFCURSOR;
    Lr_RecordElemento     Gr_RecordElemento;
    Lv_UsrUltMod          VARCHAR2(30);
    Ln_IpUltMod           VARCHAR2(30);

  BEGIN

    IF C_ObtenerRecursoCab%ISOPEN THEN
      CLOSE C_ObtenerRecursoCab;
    END IF;

    IF C_ObtenerRecursoDet%ISOPEN THEN
      CLOSE C_ObtenerRecursoDet;
    END IF;

    IF C_ObtenerTipoElemento%ISOPEN THEN
      CLOSE C_ObtenerTipoElemento;
    END IF;

    IF C_ObtenerRelacionElemento%ISOPEN THEN
      CLOSE C_ObtenerRelacionElemento;
    END IF;

    IF C_ObtenerElementoFact%ISOPEN THEN
      CLOSE C_ObtenerElementoFact;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit'         , P_VALUES => Lt_JsonIndex);
    Ln_ServicioId     := APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.servicioId' , P_VALUES => Lt_JsonIndex);
    Lv_UsrUltMod      := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.usrUltMod'  , P_VALUES => Lt_JsonIndex);
    Ln_IpUltMod       := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.ipUltMod'   , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Obtenemos la cabecera del recurso.
    OPEN C_ObtenerRecursoCab(Ln_ServicioId);
      FETCH C_ObtenerRecursoCab INTO Lc_ObtenerRecursoCab;
    CLOSE C_ObtenerRecursoCab;

    --Obtenemos el elemento de factibilidad.
    OPEN C_ObtenerElementoFact;
      FETCH C_ObtenerElementoFact INTO Lc_ElementoFact;
    CLOSE C_ObtenerElementoFact;

    FOR RecursoDet IN C_ObtenerRecursoDet(Lc_ObtenerRecursoCab.ID_SERVICIO_RECURSO_CAB)
    LOOP

      OPEN C_ObtenerTipoElemento(RecursoDet.ELEMENTO_ID);
        FETCH C_ObtenerTipoElemento INTO Lc_TipoElemento;
      CLOSE C_ObtenerTipoElemento;

      IF Lc_TipoElemento.NOMBRE_TIPO_ELEMENTO = 'UDRACK' THEN

        Lb_ActualizarFila := FALSE;

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('elementoIdA' ,  RecursoDet.ELEMENTO_ID);
        APEX_JSON.WRITE('elementoIdB' ,  Lc_ElementoFact.ID_ELEMENTO);
        APEX_JSON.WRITE('estado'      , 'Eliminado');
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_RELACION_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);

        IF Lv_Status = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la relacion elemento.');
          RAISE Le_Exception;
        END IF;

      ELSE

        Lb_ActualizarFila := TRUE;

        FOR Elemento IN C_ObtenerRelacionElemento(RecursoDet.ELEMENTO_ID)
        LOOP

          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('elementoIdA' ,  Elemento.ELEMENTO_ID_B);
          APEX_JSON.WRITE('elementoIdB' ,  Lc_ElementoFact.ID_ELEMENTO);
          APEX_JSON.WRITE('estado'      , 'Eliminado');
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;

          DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_RELACION_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);

          IF Lv_Status = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la relacion elemento.');
            RAISE Le_Exception;
          END IF;

        END LOOP;

      END IF;

    END LOOP;

    --Actualizamos las filas de los Rack a estado Activo.
    IF Lb_ActualizarFila THEN

      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('servicioId' , Ln_ServicioId);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
      DB_COMERCIAL.CMKG_SOLUCIONES_CONSULTA.P_OBTENER_INFO_CUARTO_TI_CAB(Lcl_Request,Lv_Status,Lv_Mensaje,Lrf_ElementoRecurso);

      LOOP

        FETCH Lrf_ElementoRecurso INTO Lr_RecordElemento;

        EXIT WHEN Lrf_ElementoRecurso%NOTFOUND;

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idElemento' ,  Lr_RecordElemento.IDFILA);
        APEX_JSON.WRITE('estado'     , 'Activo');
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);

        IF Lv_Status = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar el elemento ('||Lr_RecordElemento.IDFILA||')');
          RAISE Le_Exception;
        END IF;

      END LOOP;

      CLOSE Lrf_ElementoRecurso;

    END IF;

    --Eliminamos el detalle del recurso.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioRecursoCabId' ,  Lc_ObtenerRecursoCab.ID_SERVICIO_RECURSO_CAB);
    APEX_JSON.WRITE('estado'               , 'Eliminado');
    APEX_JSON.WRITE('usrUltMod'            ,  Lv_UsrUltMod);
    APEX_JSON.WRITE('ipUltMod'             ,  Ln_IpUltMod);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_ACTUALIZAR_RECURSO_DET(Lcl_Request,Lv_Status,Lv_Mensaje);

    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar el elemento ('||Lr_RecordElemento.IDFILA||')');
      RAISE Le_Exception;
    END IF;

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transaci�n exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_REVERSAR_FACTIBILIDAD_HOUS;
----
----
  PROCEDURE P_GUARDAR_FACTIBILIDAD_COM(Pcl_Request IN  CLOB,
                                       Pv_Status   OUT VARCHAR2,
                                       Pv_Mensaje  OUT VARCHAR2)
  IS

    Lt_JsonIndex       APEX_JSON.T_VALUES;
    Le_Exception       EXCEPTION;
    Lv_Status          VARCHAR2(50);
    Lv_Mensaje         VARCHAR2(3000);
    Lb_HabilitaCommit  BOOLEAN;
    Lcl_Request        CLOB;
    Ln_IdServicioTecn  NUMBER;

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Json para crear la informaci�n t�cnica del servicio.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId' , APEX_JSON.GET_NUMBER(P_PATH => 'servicioId' , P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.elementoId', P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('interfaceElementoId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.interfaceElementoId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoClienteId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.elementoClienteId', P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('interfaceElementoClienteId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.interfaceElementoClienteId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('ultimaMillaId', APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.ultimaMillaId', P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('tercerizadoraId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.tercerizadoraId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoContenedorId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.elementoContenedorId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoConectorId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.elementoConectorId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('interfaceElementoConectorId' , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadCom.interfaceElementoConectorId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('tipoEnlace' , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataFactibilidadCom.tipoEnlace',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    --Creamos la caracter�stica del servicio.
    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_GUARDAR_SERVICIO_TECNICO(Lcl_Request,Ln_IdServicioTecn,Lv_Status,Lv_Mensaje);
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear la informaci�n t�cnica del servicio.');
      RAISE Le_Exception;
    END IF;

    --Llamada al m�todo que parsea y actualiza la solicitud.
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_PARSEO_JSON_SOLICITUD(Pcl_Request,Lv_Status,Lv_Mensaje);
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la solicitud.');
      RAISE Le_Exception;
    END IF;

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transaci�n exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_GUARDAR_FACTIBILIDAD_COM;
----
----
  PROCEDURE P_GUARDAR_FACTIBILIDAD_PAC(Pcl_Request IN  CLOB,
                                       Pv_Status   OUT VARCHAR2,
                                       Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_ObtenerProductoCaract(Cn_IdProducto     NUMBER,
                                   Cv_Caracteristica VARCHAR2)
    IS
      SELECT
        APCA.ID_PRODUCTO_CARACTERISITICA
      FROM
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APCA,
        DB_COMERCIAL.ADMI_CARACTERISTICA          ACA
      WHERE
        APCA.CARACTERISTICA_ID = ACA.ID_CARACTERISTICA
        AND APCA.PRODUCTO_ID   = Cn_IdProducto
        AND ACA.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
        AND ACA.ESTADO  = 'Activo'
        AND APCA.ESTADO = 'Activo';

    Lt_JsonIndex             APEX_JSON.T_VALUES;
    Le_Exception             EXCEPTION;
    Lv_Status                VARCHAR2(50);
    Lv_Mensaje               VARCHAR2(3000);
    Lcl_Request              CLOB;
    Ln_IdServicioCaract      NUMBER;
    Lb_HabilitaCommit        BOOLEAN;
    Lv_UsrCreacion           VARCHAR2(30);
    Ln_IdServicio            NUMBER;
    Ln_IdProducto            NUMBER;
    Lv_Caracteristica        VARCHAR2(100);
    Lc_ObtenerProductoCaract C_ObtenerProductoCaract%ROWTYPE;

  BEGIN

    IF C_ObtenerProductoCaract%ISOPEN THEN
      CLOSE C_ObtenerProductoCaract;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Datos Principales
    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);
    Lv_UsrCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'    , P_VALUES => Lt_JsonIndex);
    Ln_IdServicio     := APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'     , P_VALUES => Lt_JsonIndex);
    Ln_IdProducto     := APEX_JSON.GET_NUMBER(P_PATH   => 'idProducto'     , P_VALUES => Lt_JsonIndex);
    Lv_Caracteristica := APEX_JSON.GET_VARCHAR2(P_PATH => 'caracteristica' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    OPEN C_ObtenerProductoCaract(Ln_IdProducto,Lv_Caracteristica);
      FETCH C_ObtenerProductoCaract INTO Lc_ObtenerProductoCaract;
    CLOSE C_ObtenerProductoCaract;

    --Json para crear la caracter�stica del servicio.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId'  , Ln_IdServicio);
    APEX_JSON.WRITE('usrCreacion' , Lv_UsrCreacion);
    APEX_JSON.WRITE('valor'       , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataFactibilidadPac.valor'  , P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('estado'      , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataFactibilidadPac.estado' , P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('productoCaracteristicaId' , Lc_ObtenerProductoCaract.ID_PRODUCTO_CARACTERISITICA);
    APEX_JSON.WRITE('refServicioProdCaractId'  , APEX_JSON.GET_NUMBER(P_PATH => 'dataFactibilidadPac.refServicioProdCaractId',
      P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    --Creamos la caracter�stica del servicio.
    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_GUARDAR_SERVICIO_PROD_CARACT(Lcl_Request,Ln_IdServicioCaract,Lv_Status,Lv_Mensaje);
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear la caracter�stica del servicio.');
      RAISE Le_Exception;
    END IF;

    --Llamada al m�todo que parsea y actualiza la solicitud.
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_PARSEO_JSON_SOLICITUD(Pcl_Request,Lv_Status,Lv_Mensaje);
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la solicitud.');
      RAISE Le_Exception;
    END IF;

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transaci�n exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_GUARDAR_FACTIBILIDAD_PAC;
----
----
  PROCEDURE P_GUARDAR_FACTIBILIDAD_HOUS(Pcl_Request IN  CLOB,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_ObtenerRecursoCab(Cn_ServicioId NUMBER)
    IS
      SELECT ISRCAB.*
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB ISRCAB
      WHERE ISRCAB.SERVICIO_ID =  Cn_ServicioId
        AND ISRCAB.ESTADO      = 'Activo';

    CURSOR C_ObtenerTipoElemento(Cn_IdElemento NUMBER)
    IS
      SELECT
        ATE.NOMBRE_TIPO_ELEMENTO
      FROM
        DB_INFRAESTRUCTURA.INFO_ELEMENTO        IEL,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO   ATE
      WHERE
        IEL.ID_ELEMENTO            = Cn_IdElemento
        AND IEL.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
        AND AME.TIPO_ELEMENTO_ID   = ATE.ID_TIPO_ELEMENTO;

    CURSOR C_ObtenerElementoFact
    IS
      SELECT IEL.*
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IEL
      WHERE IEL.NOMBRE_ELEMENTO = 'Equipos DC (TN/Clientes)';

    CURSOR C_ObtenerRelacionElemento(Cn_IdElemento NUMBER)
    IS
      SELECT IRE.*
        FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE
      WHERE IRE.ELEMENTO_ID_A = Cn_IdElemento
        AND ESTADO            = 'Activo';

    CURSOR C_ObtenerSolicitudFact(Cn_ServicioId      NUMBER,
                                  Cv_EstadoSolicitud VARCHAR2,
                                  Cv_TipoSolicitud   VARCHAR2)
    IS
    SELECT ID_DETALLE_SOLICITUD
      FROM
        DB_COMERCIAL.ADMI_TIPO_SOLICITUD    ATS,
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
      WHERE
        ATS.ID_TIPO_SOLICITUD         = IDS.TIPO_SOLICITUD_ID
        AND ATS.DESCRIPCION_SOLICITUD = Cv_TipoSolicitud
        AND IDS.ESTADO                = Cv_EstadoSolicitud
        AND IDS.SERVICIO_ID           = Cn_ServicioId;

    Lt_JsonIndex          APEX_JSON.T_VALUES;
    Le_Exception          EXCEPTION;
    Lv_Status             VARCHAR2(50);
    Lv_Mensaje            VARCHAR2(3000);
    Lcl_Request           CLOB;
    Lb_HabilitaCommit     BOOLEAN;
    Lv_UsrCreacion        VARCHAR2(30);
    Lv_IpCreacion         VARCHAR2(30);
    Ln_ServicioId         NUMBER;
    Lv_EstadoRecurso      VARCHAR2(30);
    Ln_TotalRecursosDet   NUMBER;
    Lc_RecursoCab         C_ObtenerRecursoCab%ROWTYPE;
    Ln_IdRecursoDet       NUMBER;
    Ln_IdElemento         NUMBER;
    Ln_IdRelacionElemento NUMBER;
    Lb_ActualizarFila     BOOLEAN;
    Lrf_ElementoRecurso   SYS_REFCURSOR;
    Lr_RecordElemento     Gr_RecordElemento;
    Lv_Observacion        VARCHAR2(1500) := 'Se gener� Factibilidad con las siguientes Descripciones:<br/>';
    Lc_TipoElemento       C_ObtenerTipoElemento%ROWTYPE;
    Lc_ElementoFact       C_ObtenerElementoFact%ROWTYPE;
    Lv_EstadoSolicitud    VARCHAR2(50);
    Lv_TipoSolicitud      VARCHAR2(100);
    Ln_IdServicioHist     NUMBER;
    Ln_IdDetalleHist      NUMBER;
    Ln_IdDetalleSol       NUMBER;

  BEGIN

    IF C_ObtenerRecursoCab%ISOPEN THEN
      CLOSE C_ObtenerRecursoCab;
    END IF;

    IF C_ObtenerTipoElemento%ISOPEN THEN
      CLOSE C_ObtenerTipoElemento;
    END IF;

    IF C_ObtenerElementoFact%ISOPEN THEN
      CLOSE C_ObtenerElementoFact;
    END IF;

    IF C_ObtenerRelacionElemento%ISOPEN THEN
      CLOSE C_ObtenerRelacionElemento;
    END IF;

    IF C_ObtenerSolicitudFact%ISOPEN THEN
      CLOSE C_ObtenerSolicitudFact;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Datos Principales
    Lb_HabilitaCommit  := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit'       , P_VALUES => Lt_JsonIndex);
    Lv_UsrCreacion     := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'          , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion      := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'           , P_VALUES => Lt_JsonIndex);
    Ln_ServicioId      := APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'           , P_VALUES => Lt_JsonIndex);
    Lv_EstadoSolicitud := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.estado' , P_VALUES => Lt_JsonIndex);
    Lv_TipoSolicitud   := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.tipoSolicitud' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Datos para crear el detalle del recurso HOUSING.
    Lv_EstadoRecurso    := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.estado'  , P_VALUES => Lt_JsonIndex);
    Ln_TotalRecursosDet := APEX_JSON.GET_COUNT(P_PATH    => 'dataRecurso.detalle' , P_VALUES => Lt_JsonIndex);

    IF Ln_TotalRecursosDet < 1 OR Ln_TotalRecursosDet IS NULL THEN
      Lv_Mensaje := 'Sin datos en el atributo detalle de recursos.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el recurso cab del servicio.
    OPEN C_ObtenerRecursoCab(Ln_ServicioId);
      FETCH C_ObtenerRecursoCab INTO Lc_RecursoCab;
    CLOSE C_ObtenerRecursoCab;

    --Obtenemos el elemento de factibilidad.
    OPEN C_ObtenerElementoFact;
      FETCH C_ObtenerElementoFact INTO Lc_ElementoFact;
    CLOSE C_ObtenerElementoFact;

    FOR i IN 1..Ln_TotalRecursosDet LOOP

      Lb_ActualizarFila := FALSE;
      Ln_IdElemento     := APEX_JSON.GET_NUMBER(P_PATH => 'dataRecurso.detalle[%d].elementoId',
        p0 => i, P_VALUES => Lt_JsonIndex);

      --Crear Relacion elemento para ocupar las unidades de rack requeridas por el Cliente/BOC
      OPEN C_ObtenerTipoElemento(Ln_IdElemento);
        FETCH C_ObtenerTipoElemento INTO Lc_TipoElemento;
      CLOSE C_ObtenerTipoElemento;

      IF Lc_TipoElemento.NOMBRE_TIPO_ELEMENTO = 'UDRACK' THEN

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('elementoIdA' ,  Ln_IdElemento);
        APEX_JSON.WRITE('elementoIdB' ,  Lc_ElementoFact.ID_ELEMENTO);
        APEX_JSON.WRITE('tipoRelacion', 'CONTIENE');
        APEX_JSON.WRITE('observacion' , 'Rack contiene Elemento DC');
        APEX_JSON.WRITE('estado'      , 'Activo');
        APEX_JSON.WRITE('usrCreacion' ,  Lv_UsrCreacion);
        APEX_JSON.WRITE('ipCreacion'  ,  Lv_IpCreacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_RELACION_ELEMENTO(Lcl_Request,
                                                                                 Ln_IdRelacionElemento,
                                                                                 Lv_Status,
                                                                                 Lv_Mensaje);
        IF Lv_Status = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al guardar la relacion elemento.');
          RAISE Le_Exception;
        END IF;

      ELSE

        Lb_ActualizarFila := TRUE;
        FOR Elemento IN C_ObtenerRelacionElemento(Ln_IdElemento) LOOP

          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('elementoIdA' ,  Elemento.ELEMENTO_ID_B);
          APEX_JSON.WRITE('elementoIdB' ,  Lc_ElementoFact.ID_ELEMENTO);
          APEX_JSON.WRITE('tipoRelacion', 'CONTIENE');
          APEX_JSON.WRITE('observacion' , 'Rack contiene Elemento DC');
          APEX_JSON.WRITE('estado'      , 'Activo');
          APEX_JSON.WRITE('usrCreacion' ,  Lv_UsrCreacion);
          APEX_JSON.WRITE('ipCreacion'  ,  Lv_IpCreacion);
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;

          DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_RELACION_ELEMENTO(Lcl_Request,
                                                                                   Ln_IdRelacionElemento,
                                                                                   Lv_Status,
                                                                                   Lv_Mensaje);
          IF Lv_Status = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al guardar la relacion elemento.');
            RAISE Le_Exception;
          END IF;

        END LOOP;

      END IF;

      --Json para crear el detalle de los recursos.
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('servicioRecursoCabId' , Lc_RecursoCab.ID_SERVICIO_RECURSO_CAB);
      APEX_JSON.WRITE('elementoId'           , Ln_IdElemento);
      APEX_JSON.WRITE('cantidad'             , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.detalle[%d].cantidad',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('refRecursoDetId'      , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.detalle[%d].refRecursoDetId',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('descripcion'          , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.detalle[%d].descripcion',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('estado'               , Lv_EstadoRecurso);
      APEX_JSON.WRITE('usrCreacion'          , Lv_UsrCreacion);
      APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_DET(Lcl_Request,Ln_IdRecursoDet,Lv_Status,Lv_Mensaje);
      IF Lv_Status = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear el detalle de los recursos de la soluci�n.');
        RAISE Le_Exception;
      END IF;

    END LOOP;

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId' , Ln_ServicioId);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    DB_COMERCIAL.CMKG_SOLUCIONES_CONSULTA.P_OBTENER_INFO_CUARTO_TI_CAB(Lcl_Request,Lv_Status,Lv_Mensaje,Lrf_ElementoRecurso);

    LOOP

      FETCH Lrf_ElementoRecurso INTO Lr_RecordElemento;

      EXIT WHEN Lrf_ElementoRecurso%NOTFOUND;

      Lv_Observacion :=  Lv_Observacion ||'<br/><b>Fila:</b>' ||Lr_RecordElemento.NOMBREFILA;
      Lv_Observacion :=  Lv_Observacion ||'<br/><b>Rack:</b>' ||Lr_RecordElemento.NOMBRERACK;
      Lv_Observacion :=  Lv_Observacion ||'<br/><b>Reservados:</b>'||Lr_RecordElemento.RESERVADOS ||' (Us) ';
      Lv_Observacion :=  Lv_Observacion ||'<br/><hr>';

      --La fila en estado Ocupado dado que queda completamente utilizado por cliente.
      IF Lb_ActualizarFila THEN

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idElemento' ,  Lr_RecordElemento.IDFILA);
        APEX_JSON.WRITE('estado'     , 'Ocupado');
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);
        IF Lv_Status = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar el elemento ('||Lr_RecordElemento.IDFILA||')');
          RAISE Le_Exception;
        END IF;

      END IF;

    END LOOP;

    CLOSE Lrf_ElementoRecurso;

    --Llamada al m�todo que parsea y actualiza la solicitud.
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_PARSEO_JSON_SOLICITUD(Pcl_Request,Lv_Status,Lv_Mensaje);
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la solicitud.');
      RAISE Le_Exception;
    END IF;

    --Obtenemos el id del detalle de la solicitud.
    OPEN C_ObtenerSolicitudFact(Ln_ServicioId,Lv_EstadoSolicitud,Lv_TipoSolicitud);
      FETCH C_ObtenerSolicitudFact INTO Ln_IdDetalleSol;
    CLOSE C_ObtenerSolicitudFact;

    --Insertamos la observaci�n en los Historiales.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('detalleSolicitudId', Ln_IdDetalleSol);
    APEX_JSON.WRITE('observacion'       , Lv_Observacion);
    APEX_JSON.WRITE('estado'            , Lv_EstadoSolicitud);
    APEX_JSON.WRITE('usrCreacion'       , Lv_UsrCreacion);
    APEX_JSON.WRITE('ipCreacion'        , Lv_IpCreacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_GUARDAR_DETALLE_SOL_HIST(Lcl_Request,Ln_IdDetalleHist,Lv_Status,Lv_Mensaje);

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId'  , Ln_ServicioId);
    APEX_JSON.WRITE('observacion' , Lv_Observacion);
    APEX_JSON.WRITE('estado'      , Lv_EstadoSolicitud);
    APEX_JSON.WRITE('usrCreacion' , Lv_UsrCreacion);
    APEX_JSON.WRITE('ipCreacion'  , Lv_IpCreacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_GUARDAR_SERVICIO_HISTORIAL(Lcl_Request,Ln_IdServicioHist,Lv_Status,Lv_Mensaje);

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transaci�n exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_GUARDAR_FACTIBILIDAD_HOUS;
----
----
  PROCEDURE P_CREAR_RECURSOS(Pcl_Request IN  CLOB,
                             Pv_Status   OUT VARCHAR2,
                             Pv_Mensaje  OUT VARCHAR2)
  IS

    Lt_JsonIndex       APEX_JSON.T_VALUES;
    Ln_Total           NUMBER;
    Ln_TotalRecursos   NUMBER;
    Ln_TotalDetalle    NUMBER;
    Le_Exception       EXCEPTION;
    Lv_Status          VARCHAR2(50);
    Lv_Mensaje         VARCHAR2(3000);
    Lv_UsrCreacion     VARCHAR2(30);
    Lv_IpCreacion      VARCHAR2(30);
    Lv_Estado          VARCHAR2(30);
    Lcl_Request        CLOB;
    Ln_IdRecursoCab    NUMBER;
    Ln_IdRecursoDet    NUMBER;
    Lb_HabilitaCommit  BOOLEAN;

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Obtenemos el total de los atributos.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos los datos principales.
    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);
    Lv_UsrCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'    , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion     := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'     , P_VALUES => Lt_JsonIndex);
    Lv_Estado         := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'         , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Obtenemos el total de los recursos.
    Ln_TotalRecursos := APEX_JSON.GET_COUNT(P_PATH => 'recursos', P_VALUES => Lt_JsonIndex);

    IF Ln_TotalRecursos < 1 OR Ln_TotalRecursos IS NULL THEN
      Lv_Mensaje := 'El atributo recursos se encuentra vacio o no existe en el Json.';
      RAISE Le_Exception;
    END IF;

    FOR i in 1..Ln_TotalRecursos LOOP

      --Json para crear la cabecera del recurso.
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('tipoRecurso'       , APEX_JSON.GET_VARCHAR2(P_PATH => 'recursos[%d].tipoRecurso',
                                              p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('descripcionRecurso', APEX_JSON.GET_VARCHAR2(P_PATH => 'recursos[%d].descripcionRecurso',
                                              p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('servicioId'        , APEX_JSON.GET_NUMBER(P_PATH   => 'recursos[%d].servicioId',
                                              p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('solicitudId'       , APEX_JSON.GET_NUMBER(P_PATH   => 'recursos[%d].solicitudId',
                                              p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('cantidad'          , APEX_JSON.GET_NUMBER(P_PATH   => 'recursos[%d].cantidad',
                                              p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('usrCreacion'       , Lv_UsrCreacion);
      APEX_JSON.WRITE('ipCreacion'        , Lv_IpCreacion);
      APEX_JSON.WRITE('estado'            , Lv_Estado);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_CAB(Lcl_Request,Ln_IdRecursoCab,Lv_Status,Lv_Mensaje);

      IF Lv_Status = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear la cabecera del recurso de la soluci�n.');
        RAISE Le_Exception;
      END IF;

      --Obtenemos el total de los detalles del recurso.
      Ln_TotalDetalle := APEX_JSON.GET_COUNT(P_PATH => 'recursos[%d].detalle' , p0 => i, P_VALUES => Lt_JsonIndex);

      IF Ln_TotalDetalle > 0 AND Ln_TotalDetalle IS NOT NULL THEN

        FOR j in 1..Ln_TotalDetalle LOOP

          --Json para crear el detalle.
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('servicioRecursoCabId' , Ln_IdRecursoCab);
          APEX_JSON.WRITE('elementoId'      , APEX_JSON.GET_NUMBER(P_PATH   => 'recursos[%d].detalle[%d].elementoId',
                                                p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('cantidad'        , APEX_JSON.GET_NUMBER(P_PATH   => 'recursos[%d].detalle[%d].cantidad',
                                                p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('refRecursoDetId' , APEX_JSON.GET_NUMBER(P_PATH   => 'recursos[%d].detalle[%d].refRecursoDetId',
                                                p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('descripcion'     , APEX_JSON.GET_VARCHAR2(P_PATH => 'recursos[%d].detalle[%d].descripcion',
                                                p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('usrCreacion'     , Lv_UsrCreacion);
          APEX_JSON.WRITE('ipCreacion'      , Lv_IpCreacion);
          APEX_JSON.WRITE('estado'          , Lv_Estado);
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;

          DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_DET(Lcl_Request,Ln_IdRecursoDet,Lv_Status,Lv_Mensaje);

          IF Lv_Status = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear el detalle de los recursos de la soluci�n.');
            RAISE Le_Exception;
          END IF;

        END LOOP;

      END IF;

    END LOOP;

    IF Lb_Habilitacommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transaci�n exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_CREAR_RECURSOS;
----
----
  PROCEDURE P_CREAR_SOLUCION(Pcl_Request IN  CLOB,
                             Pn_Solucion OUT NUMBER,
                             Pv_Status   OUT VARCHAR2,
                             Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales.
    CURSOR C_ObtenerRefSolucion(Cn_IdSolucionCab NUMBER,
                                Cn_ServicioIdA   NUMBER,
                                Cn_ServicioIdB   NUMBER)
    IS
      SELECT
        ISD1.ID_SOLUCION_DET AS SOLUCIONDETIDA,
        ISD2.ID_SOLUCION_DET AS SOLUCIONDETIDB
      FROM
        DB_COMERCIAL.INFO_SOLUCION_CAB ISC,
        DB_COMERCIAL.INFO_SOLUCION_DET ISD1,
        DB_COMERCIAL.INFO_SOLUCION_DET ISD2
      WHERE
        ISC.ID_SOLUCION_CAB     = ISD1.SOLUCION_CAB_ID
        AND ISC.ID_SOLUCION_CAB = ISD2.SOLUCION_CAB_ID
        AND ISC.ID_SOLUCION_CAB = Cn_IdSolucionCab
        AND ISD1.SERVICIO_ID    = Cn_ServicioIdA
        AND ISD2.SERVICIO_ID    = Cn_ServicioIdB;

    CURSOR C_ObtenerRecursoCab(Cn_IdSolucionCab NUMBER,
                               Cn_IdServicio    NUMBER,
                               Cv_TipoRecurso   VARCHAR2,
                               Cv_Descripcion   VARCHAR2)
    IS
      SELECT
        ISRCAB.ID_SERVICIO_RECURSO_CAB
      FROM
        DB_COMERCIAL.INFO_SOLUCION_CAB         ISCAB,
        DB_COMERCIAL.INFO_SOLUCION_DET         ISDET,
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB ISRCAB
      WHERE
        ISCAB.ID_SOLUCION_CAB          = ISDET.SOLUCION_CAB_ID
        AND ISDET.SERVICIO_ID          = ISRCAB.SERVICIO_ID
        AND ISCAB.ID_SOLUCION_CAB      = Cn_IdSolucionCab
        AND ISDET.SERVICIO_ID          = Cn_IdServicio
        AND UPPER(ISRCAB.TIPO_RECURSO) = UPPER(Cv_TipoRecurso)
        AND UPPER(ISRCAB.DESCRIPCION_RECURSO) = UPPER(Cv_Descripcion);

    CURSOR C_ObtenerSolucion(Cn_NumeroSolucion NUMBER,
                             Cn_PuntoId        NUMBER)
    IS
      SELECT ISCAB.*
        FROM DB_COMERCIAL.INFO_SOLUCION_CAB ISCAB
      WHERE ISCAB.NUMERO_SOLUCION = Cn_NumeroSolucion
        AND ISCAB.PUNTO_ID        = Cn_PuntoId;

    --Variables Locales.
    Lc_ObtenerRefSolucion  C_ObtenerRefSolucion%ROWTYPE;
    Lc_ObtenerSolucion     C_ObtenerSolucion%ROWTYPE;
    Lt_JsonIndex           APEX_JSON.T_VALUES;
    Ln_Total               NUMBER;
    Ln_Detalle             NUMBER;
    Ln_TotalRefServicios   NUMBER;
    Le_Exception           EXCEPTION;
    Lv_Status              VARCHAR2(50);
    Lv_Mensaje             VARCHAR2(3000);
    Lv_UsuarioCreacion     VARCHAR2(30);
    Lv_IpCreacion          VARCHAR2(30);
    Lv_Estado              VARCHAR2(30);
    Ln_IdRecursoCab        NUMBER;
    Ln_IdServicio          NUMBER;
    Lv_TipoRecurso         VARCHAR2(100);
    Lv_DescripcionRec      VARCHAR2(100);
    Ln_IdSolucionCab       NUMBER;
    Ln_NumeroSolucion      NUMBER;
    Lv_NombreSolucion      VARCHAR2(1500);
    Ln_PuntoId             NUMBER;
    Ln_IdSolucionDet       NUMBER;
    Ln_IdSolucionRef       NUMBER;
    Ln_ServicioIdA         NUMBER;
    Ln_ServicioIdB         NUMBER;
    Lb_HabilitaCommit      BOOLEAN;
    Lcl_Request            CLOB;

  BEGIN

    IF C_ObtenerRefSolucion%ISOPEN THEN
      CLOSE C_ObtenerRefSolucion;
    END IF;

    IF C_ObtenerRecursoCab%ISOPEN THEN
      CLOSE C_ObtenerRecursoCab;
    END IF;

    IF C_ObtenerSolucion%ISOPEN THEN
      CLOSE C_ObtenerSolucion;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Obtenemos el total de los atributos.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'detalle'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'solucion.detalle', P_VALUES => Lt_JsonIndex);

    --Validamos que el detalle no se encuentre vacio.
    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'El atributo detalle de la soluci�n se encuentra vacio o no existe en el Json.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos los datos principales.
    Lb_HabilitaCommit  := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);
    Lv_UsuarioCreacion := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'    , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion      := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'     , P_VALUES => Lt_JsonIndex);
    Lv_Estado          := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'         , P_VALUES => Lt_JsonIndex);

    --Obtenemos los datos principales de la cabecera de la soluci�n.
    Ln_NumeroSolucion  := APEX_JSON.GET_NUMBER(P_PATH   => 'solucion.numeroSolucion' , P_VALUES => Lt_JsonIndex);
    Lv_NombreSolucion  := APEX_JSON.GET_VARCHAR2(P_PATH => 'solucion.nombreSolucion' , P_VALUES => Lt_JsonIndex);
    Ln_PuntoId         := APEX_JSON.GET_NUMBER(P_PATH   => 'solucion.puntoId'        , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    IF Ln_NumeroSolucion IS NOT NULL AND Ln_NumeroSolucion > 0 THEN

      OPEN C_ObtenerSolucion(Ln_NumeroSolucion,Ln_PuntoId);
        FETCH C_ObtenerSolucion INTO Lc_ObtenerSolucion;
      CLOSE C_ObtenerSolucion;

      Ln_IdSolucionCab := Lc_ObtenerSolucion.ID_SOLUCION_CAB;

    ELSE

      --Json para crear la cabecera de la soluci�n.
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('nombreSolucion' , Lv_NombreSolucion);
      APEX_JSON.WRITE('puntoId'        , Ln_PuntoId);
      APEX_JSON.WRITE('estado'         , Lv_Estado);
      APEX_JSON.WRITE('usrCreacion'    , Lv_UsuarioCreacion);
      APEX_JSON.WRITE('ipCreacion'     , Lv_IpCreacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_SOLUCION_CAB(Lcl_Request,
                                                                      Ln_IdSolucionCab,
                                                                      Ln_NumeroSolucion,
                                                                      Lv_Status,
                                                                      Lv_Mensaje);

      IF Lv_Status = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear la soluci�n.');
        RAISE Le_Exception;
      END IF;

    END IF;

    --Recorremos el detalle de la soluci�n.
    FOR i in 1..Ln_Total LOOP

      --Json para crear el detalle de la soluci�n.
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('solucionCabId'  , Ln_IdSolucionCab);
      APEX_JSON.WRITE('servicioId'     , APEX_JSON.GET_NUMBER(P_PATH   => 'solucion.detalle[%d].servicioId',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('tipoSolucion'   , APEX_JSON.GET_VARCHAR2(P_PATH => 'solucion.detalle[%d].tipoSolucion',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('descripcion'    , APEX_JSON.GET_VARCHAR2(P_PATH => 'solucion.detalle[%d].descripcion',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('esCore'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'solucion.detalle[%d].esCore',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('esPreferencial' , APEX_JSON.GET_VARCHAR2(P_PATH => 'solucion.detalle[%d].esPreferencial',
        p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('estado'        , Lv_Estado);
      APEX_JSON.WRITE('usrCreacion'   , Lv_UsuarioCreacion);
      APEX_JSON.WRITE('ipCreacion'    , Lv_IpCreacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_SOLUCION_DET(Lcl_Request,Ln_IdSolucionDet,Lv_Status,Lv_Mensaje);

      IF Lv_Status = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear el detalle de la soluci�n.');
        RAISE Le_Exception;
      END IF;

    END LOOP;

   --Obtenemos el total de los atributos que se encuentran dentro de 'referencia'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'solucion.referencia', P_VALUES => Lt_JsonIndex);

    IF Ln_Total > 0 AND Ln_Total IS NOT NULL THEN

      --Recorremos la referencia.
      FOR i in 1..Ln_Total LOOP

        --Obtenemos el total de los servicios de referencia.
        Ln_TotalRefServicios := APEX_JSON.GET_COUNT(P_PATH => 'solucion.referencia[%d].servicios', p0 => i, P_VALUES => Lt_JsonIndex);

        --Validamos que los servicios de la referencia no se encuentre vacio.
        IF Ln_TotalRefServicios < 1 OR Ln_TotalRefServicios IS NULL THEN
          Lv_Mensaje := 'Sin datos en el atributo servicios que se encuentran dentro de referencia.';
          RAISE Le_Exception;
        END IF;

        Ln_ServicioIdA := APEX_JSON.GET_NUMBER(P_PATH => 'solucion.referencia[%d].servicio', p0 => i , P_VALUES => Lt_JsonIndex);

        IF Ln_ServicioIdA IS NULL THEN
          Lv_Mensaje := 'Sin datos en el atributo servicio que se encuentra dentro referencia.';
          RAISE Le_Exception;
        END IF;

        --Recorremos los servicios de la referencia.
        FOR j in 1..Ln_TotalRefServicios LOOP

          Ln_ServicioIdB := APEX_JSON.GET_NUMBER(P_PATH => 'solucion.referencia[%d].servicios[%d]',
            p0 => i,p1 => j,P_VALUES => Lt_JsonIndex);

          OPEN C_ObtenerRefSolucion(Ln_IdSolucionCab,Ln_ServicioIdA,Ln_ServicioIdB);
          FETCH C_ObtenerRefSolucion
            INTO Lc_ObtenerRefSolucion;
          CLOSE C_ObtenerRefSolucion;

          --Json para crear la referencia de la soluci�n.
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('solucionDetIdA' , Lc_ObtenerRefSolucion.SOLUCIONDETIDA);
          APEX_JSON.WRITE('solucionDetIdB' , Lc_ObtenerRefSolucion.SOLUCIONDETIDB);
          APEX_JSON.WRITE('estado'         , Lv_Estado);
          APEX_JSON.WRITE('usrCreacion'    , Lv_UsuarioCreacion);
          APEX_JSON.WRITE('ipCreacion'     , Lv_IpCreacion);
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;

          DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_SOLUCION_REF(Lcl_Request,Ln_IdSolucionRef,Lv_Status,Lv_Mensaje);

          IF Lv_Status = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear la referencia de la soluci�n.');
            RAISE Le_Exception;
          END IF;

        END LOOP;

      END LOOP;

    END IF;

    /*
     * Creamos los recursos de la soluci�n.
     */
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'dataRecurso.recursos', P_VALUES => Lt_JsonIndex);

    IF Ln_Total > 0 AND Ln_Total IS NOT NULL THEN

      Lv_Estado := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.estado' , P_VALUES => Lt_JsonIndex);
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('habilitaCommit' , false);
      APEX_JSON.WRITE('usrCreacion'    , Lv_UsuarioCreacion);
      APEX_JSON.WRITE('ipCreacion'     , Lv_IpCreacion);
      APEX_JSON.WRITE('estado'         , Lv_Estado);
      APEX_JSON.OPEN_ARRAY('recursos');

      FOR i IN 1..Ln_Total LOOP

        APEX_JSON.OPEN_OBJECT;

        APEX_JSON.WRITE('tipoRecurso'        , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.recursos[%d].tipoRecurso',
          p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.WRITE('descripcionRecurso' , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.recursos[%d].descripcionRecurso',
          p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.WRITE('servicioId'         , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.recursos[%d].servicioId',
          p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.WRITE('solicitudId'        , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.recursos[%d].solicitudId',
          p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.WRITE('cantidad'           , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.recursos[%d].cantidad',
          p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.OPEN_ARRAY('detalle');

        Ln_Detalle := APEX_JSON.GET_COUNT(P_PATH => 'dataRecurso.recursos[%d].detalle', p0 => i, P_VALUES => Lt_JsonIndex);

        IF Ln_Detalle > 0 AND Ln_Detalle IS NOT NULL THEN

          FOR j IN 1..Ln_Detalle LOOP

            APEX_JSON.OPEN_OBJECT;

            APEX_JSON.WRITE('elementoId'      , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.recursos[%d].detalle[%d].elementoId',
              p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
            APEX_JSON.WRITE('cantidad'        , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.recursos[%d].detalle[%d].cantidad',
              p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
            APEX_JSON.WRITE('refRecursoDetId' , APEX_JSON.GET_NUMBER(P_PATH   => 'dataRecurso.recursos[%d].detalle[%d].refRecursoDetId',
              p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
            APEX_JSON.WRITE('descripcion'     , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataRecurso.recursos[%d].detalle[%d].descripcion',
              p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));

            APEX_JSON.CLOSE_OBJECT;

          END LOOP;

        END IF;

        APEX_JSON.CLOSE_ARRAY();
        APEX_JSON.CLOSE_OBJECT;

      END LOOP;

      APEX_JSON.CLOSE_ARRAY();
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMERCIAL.CMKG_SOLUCIONES_DC.P_CREAR_RECURSOS(Lcl_Request,Lv_Status,Lv_Mensaje);

      IF Lv_Status = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear los recursos de la soluci�n.');
        RAISE Le_Exception;
      END IF;

    END IF;

    /*
     * Creaci�n de las maquinas virtuales.
    */
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'maquinasVirtuales', P_VALUES => Lt_JsonIndex);

    IF Ln_Total > 0 AND Ln_Total IS NOT NULL THEN

      FOR i IN 1..Ln_Total LOOP

        Lv_Estado := APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].estado' , p0 => i, P_VALUES => Lt_JsonIndex);

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('habilitaCommit' , false);
          APEX_JSON.WRITE('usrCreacion'    , Lv_UsuarioCreacion);
          APEX_JSON.WRITE('ipCreacion'     , Lv_IpCreacion);
          APEX_JSON.WRITE('estado'         , Lv_Estado);

        APEX_JSON.OPEN_OBJECT('elemento');
          APEX_JSON.WRITE('nombreElemento'      , APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].elemento.nombreElemento',
            p0 => i, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('descripcionElemento' , APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].elemento.descripcionElemento',
            p0 => i, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('modeloElementoId'    , APEX_JSON.GET_NUMBER(P_PATH   => 'maquinasVirtuales[%d].elemento.modeloElementoId',
            p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.CLOSE_OBJECT;

        APEX_JSON.OPEN_ARRAY('detalle');
        Ln_Detalle := APEX_JSON.GET_COUNT(P_PATH => 'maquinasVirtuales[%d].detalle', p0 => i, P_VALUES => Lt_JsonIndex);
        FOR j IN 1..Ln_Detalle LOOP
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('detalleNombre' , APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].detalle[%d].detalleNombre',
            p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('detalleValor'  , APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].detalle[%d].detalleValor',
            p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.CLOSE_OBJECT;
        END LOOP;
        APEX_JSON.CLOSE_ARRAY;

        APEX_JSON.OPEN_OBJECT('empresaElementoUbica');
          APEX_JSON.WRITE('empresaCod'  , APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].empresaElementoUbica.empresaCod',
            p0 => i, P_VALUES => Lt_JsonIndex));
          APEX_JSON.WRITE('ubicacionId' , APEX_JSON.GET_NUMBER(P_PATH   => 'maquinasVirtuales[%d].empresaElementoUbica.ubicacionId',
            p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.CLOSE_OBJECT;

        APEX_JSON.OPEN_ARRAY('detalleRecursos');
        Ln_Detalle := APEX_JSON.GET_COUNT(P_PATH => 'maquinasVirtuales[%d].detalleRecursos', p0 => i, P_VALUES => Lt_JsonIndex);
        FOR j IN 1..Ln_Detalle LOOP

          Lv_TipoRecurso    := APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].detalleRecursos[%d].tipoRecurso',
            p0 => i, p1 => j, P_VALUES => Lt_JsonIndex);
          Lv_DescripcionRec := APEX_JSON.GET_VARCHAR2(P_PATH => 'maquinasVirtuales[%d].detalleRecursos[%d].descripcionRecurso',
            p0 => i, p1 => j, P_VALUES => Lt_JsonIndex);

          --OBTENEMOS EL ID DEL RECURSO CAB.
          IF UPPER(Lv_TipoRecurso) IN ('MEMORIA RAM','PROCESADOR','DISCO') THEN
            Ln_IdServicio := APEX_JSON.GET_NUMBER(P_PATH => 'maquinasVirtuales[%d].servicioId',
              p0 => i, P_VALUES => Lt_JsonIndex);
          ELSE
            Ln_IdServicio := APEX_JSON.GET_NUMBER(P_PATH => 'maquinasVirtuales[%d].detalleRecursos[%d].servicioId',
              p0 => i, p1 => j, P_VALUES => Lt_JsonIndex);
          END IF;

          OPEN C_ObtenerRecursoCab(Ln_IdSolucionCab, Ln_IdServicio, Lv_TipoRecurso, Lv_DescripcionRec);
          FETCH C_ObtenerRecursoCab INTO Ln_IdRecursoCab;
          CLOSE C_ObtenerRecursoCab;

          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('servicioRecursoCabId' , Ln_IdRecursoCab);
          APEX_JSON.WRITE('cantidad'             , APEX_JSON.GET_NUMBER(P_PATH => 'maquinasVirtuales[%d].detalleRecursos[%d].cantidad',
            p0 => i, p1 => j, P_VALUES => Lt_JsonIndex));
          APEX_JSON.CLOSE_OBJECT;

        END LOOP;

        APEX_JSON.CLOSE_ARRAY;
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_SOLUCIONES_TRANSACCION.P_CREAR_MAQUINA_VIRTUAL(Lcl_Request,Lv_Status,Lv_Mensaje);

        IF Lv_Status = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear las maquinas virtuales.');
          RAISE Le_Exception;
        END IF;

      END LOOP;

    END IF;

    --Respuesta Exitosa.
    IF Lb_Habilitacommit THEN
      COMMIT;
    END IF;

    Pv_Status   := 'OK';
    Pv_Mensaje  := 'Soluci�n Creada.';
    Pn_Solucion :=  Ln_IdSolucionCab;

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_Solucion :=  0;
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_Solucion :=  0;

  END P_CREAR_SOLUCION;
----
----
END CMKG_SOLUCIONES_DC;
/

