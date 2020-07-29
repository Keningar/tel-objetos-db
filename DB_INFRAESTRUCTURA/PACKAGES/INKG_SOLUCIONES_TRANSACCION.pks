SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_SOLUCIONES_TRANSACCION AS

  /**
   * Documentación para el procedimiento 'P_CREAR_MAQUINA_VIRTUAL'.
   *
   * Método encargado de crear maquinas virtuales.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 13-05-2020
   */
  PROCEDURE P_CREAR_MAQUINA_VIRTUAL(Pcl_Request IN  CLOB,
                                   Pv_Status   OUT VARCHAR2,
                                   Pv_Mensaje  OUT VARCHAR2);


  /**
   * Documentación para el procedimiento 'P_CREAR_FACTIBILIDAD_MV'.
   *
   * Método encargado de guardar factibilidad de la maquina virtual.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 13-05-2020
   */
  PROCEDURE P_CREAR_FACTIBILIDAD_MV(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_CREAR_FACTIBILIDAD_MV'.
   *
   * Método encargado de guardar factibilidad de la maquina virtual.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 13-05-2020
   */
  PROCEDURE P_CREAR_FACTIBILIDAD_SERVIDOR(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_CREAR_FACTIBILIDAD_POOL_SERVIDOR'.
   *
   * Método encargado de guardar factibilidad de la maquina virtual.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 13-05-2020
   */
  PROCEDURE P_CREAR_FACTIB_POOL_SERVIDOR(Pcl_Request IN  CLOB,
                                         Pv_Status   OUT VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2);

   /**
   * Documentación para el procedimiento 'P_ELIMINAR_MV'.
   *
   * Método encargado de eliminar una maquina virtual.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 13-05-2020
   */
  PROCEDURE P_ELIMINAR_MV(Pcl_Request IN  CLOB,
                          Pv_Status   OUT VARCHAR2,
                          Pv_Mensaje  OUT VARCHAR2);  

   /**
   * Documentación para el procedimiento 'P_REVERSAR_POOL_SERVIDOR'.
   *
   * Método encargado de reversar la factibilidad asignada al servicio alquiler
   * de servidor y los registros de InfoServicioRecurdoDet asociados al mismo.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 24-07-2020
   */
  PROCEDURE P_REVERSAR_POOL_SERVIDOR(Pcl_Request IN  CLOB,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2); 

END INKG_SOLUCIONES_TRANSACCION;

/

CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_SOLUCIONES_TRANSACCION AS

  PROCEDURE P_CREAR_MAQUINA_VIRTUAL(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2)
  IS

    Lt_JsonIndex        APEX_JSON.T_VALUES;
    Le_Exception        EXCEPTION;
    Lv_Status           VARCHAR2(50);
    Lv_Mensaje          VARCHAR2(3000);
    Lb_HabilitaCommit   BOOLEAN;
    Lcl_Request         CLOB;
    Lcl_JsonRecursoDet  CLOB;
    Lcl_JsonDetElemento CLOB;
    Ln_TotalRecursos    NUMBER;
    Ln_TotalRecursosDet NUMBER;
    Ln_TotalDetalle     NUMBER;
    Ln_IdElemento       NUMBER;
    Ln_IdEmpresaElementoUbica NUMBER;
    Ln_IdEmpresaElemento NUMBER;
    Ln_IdDetaleElemento NUMBER;
    Ln_Total            NUMBER;
    Ln_IdRecursoDet     NUMBER;
    Lv_UsuarioCreacion  VARCHAR2(30);
    Lv_IpCreacion       VARCHAR2(30);
    Lv_Estado           VARCHAR2(30);

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Obtenemos el total de los atributos que se encuentran dentro de la raíz.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'elemento'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'elemento' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Atributo elemento vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'detalle'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'detalle' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Atributo detalle vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'empresaElementoUbica'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'empresaElementoUbica' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Atributo empresaElementoUbica vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'detalleRecursos'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'detalleRecursos' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Atributo detalleRecursos vacio.';
      RAISE Le_Exception;
    END IF;

    --Datos principales para cada una de las tablas a insertar.
    Lv_Estado             := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'      , P_VALUES => Lt_JsonIndex);
    Lv_UsuarioCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion' , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion         := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'  , P_VALUES => Lt_JsonIndex);

    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

  --Json para crear elemento máquina virtual.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('estado' , Lv_Estado);
    APEX_JSON.WRITE('usrCreacion' , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion' , Lv_IpCreacion);
    APEX_JSON.WRITE('nombreElemento' , APEX_JSON.GET_VARCHAR2(P_PATH      => 'elemento.nombreElemento'  ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('descripcionElemento' , APEX_JSON.GET_VARCHAR2(P_PATH => 'elemento.descripcionElemento'  ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('modeloElementoId' , APEX_JSON.GET_NUMBER(P_PATH      => 'elemento.modeloElementoId',P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;   
    APEX_JSON.FREE_OUTPUT;

    --Creación de elemento máquina virtual..
    DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_ELEMENTO(Lcl_Request,Ln_IdElemento,Lv_Status,Lv_Mensaje);
    IF Lv_Status  = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear elemento de máquina virtual');
            RAISE Le_Exception;
    END IF;

    --Json para crear el empresaElementoUbica.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('estado'      , Lv_Estado);
    APEX_JSON.WRITE('usrCreacion' , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'  , Lv_IpCreacion);
    APEX_JSON.WRITE('empresaCod'  , APEX_JSON.GET_VARCHAR2(P_PATH  => 'empresaElementoUbica.empresaCod'  ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoId'  , Ln_IdElemento);
    APEX_JSON.WRITE('ubicacionId' , APEX_JSON.GET_NUMBER(P_PATH    => 'empresaElementoUbica.ubicacionId' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;   
    APEX_JSON.FREE_OUTPUT;

    --Creación de empresaElementoUbica.
    DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_EMPRESA_ELEMENTO_UBI(Lcl_Request,Ln_IdEmpresaElementoUbica,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear empresa elemento ubica');
            RAISE Le_Exception;
    END IF;


    --Json para crear el empresaElemento.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('estado'      , Lv_Estado);
    APEX_JSON.WRITE('usrCreacion' , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'  , Lv_IpCreacion);
    APEX_JSON.WRITE('empresaCod'  , APEX_JSON.GET_VARCHAR2(P_PATH  => 'empresaElementoUbica.empresaCod'  ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoId'  , Ln_IdElemento);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;   
    APEX_JSON.FREE_OUTPUT;

    --Creación de empresaElemento.
    DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_EMPRESA_ELEMENTO(Lcl_Request,Ln_IdEmpresaElemento,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear empresa elemento ');
            RAISE Le_Exception;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'detalle'.
    Ln_TotalDetalle := APEX_JSON.GET_COUNT(P_PATH => 'detalle', P_VALUES => Lt_JsonIndex);


    FOR i in 1..Ln_TotalDetalle LOOP

      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('elementoId'           , Ln_IdElemento);
      APEX_JSON.WRITE('detalleNombre'        , APEX_JSON.GET_VARCHAR2(P_PATH   => 'detalle[%d].detalleNombre',
                                                p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('detalleValor'         , APEX_JSON.GET_VARCHAR2(P_PATH   => 'detalle[%d].detalleValor',
                                                p0 => i, P_VALUES => Lt_JsonIndex));   
      APEX_JSON.WRITE('detalleDescripcion'   , APEX_JSON.GET_VARCHAR2(P_PATH   => 'detalle[%d].detalleNombre',
                                                p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('estado'               , Lv_Estado);
      APEX_JSON.WRITE('usrCreacion'          , Lv_UsuarioCreacion);
      APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_JsonDetElemento := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      --Creamos el detalle elemento.
      DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_DETALLE_ELEMENTO(Lcl_JsonDetElemento,
                                                                              Ln_IdDetaleElemento,
                                                                              Lv_Status,
                                                                              Lv_Mensaje); 

      IF Lv_Status  = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear detalle elemento de la máquina virtual');
        RAISE Le_Exception;
      END IF;

    END LOOP;

    --Obtenemos el total de los atributos que se encuentran dentro de 'detalleRecursos'.
    Ln_TotalRecursos := APEX_JSON.GET_COUNT(P_PATH => 'detalleRecursos', P_VALUES => Lt_JsonIndex);

    IF Ln_TotalRecursos < 1 OR Ln_TotalRecursos IS NULL THEN
      Lv_Mensaje := 'El atributo detalleRecursos se encuentra vacio o no existe en el Json.';
      RAISE Le_Exception;
    END IF;


    FOR i in 1..Ln_TotalRecursos LOOP

      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('servicioRecursoCabId' , APEX_JSON.GET_NUMBER(P_PATH   => 'detalleRecursos[%d].servicioRecursoCabId',
                                                p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('elementoId'           , Ln_IdElemento);
      APEX_JSON.WRITE('cantidad'             , APEX_JSON.GET_NUMBER(P_PATH   => 'detalleRecursos[%d].cantidad',
                                                p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('estado'               , Lv_Estado);
      APEX_JSON.WRITE('usrCreacion'          , Lv_UsuarioCreacion);
      APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_JsonRecursoDet := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      --Creamos el detalle de los recursos.
      DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_DET(Lcl_JsonRecursoDet,
                                                                     Ln_IdRecursoDet,
                                                                     Lv_Status,
                                                                     Lv_Mensaje); 
      IF Lv_Status  = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear detalleRecursos de la máquina virtual');
        RAISE Le_Exception;
      END IF;
    END LOOP;


    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
  END P_CREAR_MAQUINA_VIRTUAL;

  PROCEDURE P_CREAR_FACTIBILIDAD_MV(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2)
    IS

    CURSOR C_ServicioRecursoCab(Cn_ElementoId   NUMBER, 
                                Cn_SRCId        NUMBER)
      IS
        SELECT 
               SRD.ID_SERVICIO_RECURSO_DET    AS DETID
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET SRD
        WHERE SRD.ELEMENTO_ID = Cn_ElementoId
        AND   SRD.ESTADO      = 'Activo'
        AND   SRD.SERVICIO_RECURSO_CAB_ID = Cn_SRCId;

    CURSOR C_DetalleElemento(Cn_ElementoId   NUMBER, 
                             Cv_Nombre       VARCHAR2)
      IS
        SELECT 
               DETALLE.ID_DETALLE_ELEMENTO    AS DETALLE_ID
        FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE
        WHERE DETALLE.DETALLE_NOMBRE = Cv_Nombre
        AND   DETALLE.ESTADO         = 'Activo'
        AND   DETALLE.ELEMENTO_ID    = Cn_ElementoId;

    Lt_JsonIndex          APEX_JSON.T_VALUES;
    Le_Exception          EXCEPTION;
    Lv_Status             VARCHAR2(50);
    Lv_Mensaje            VARCHAR2(3000);
    Lb_HabilitaCommit     BOOLEAN;
    Lcl_Request           CLOB;
    Lcl_JsonRecursoDet    CLOB;
    Lcl_JsonDetElemento   CLOB;
    Ln_TotalDatastore     NUMBER;
    Ln_TotalRecursosDet   NUMBER;
    Ln_TotalFactibilidad  NUMBER;
    Ln_IdElemento         NUMBER;
    Ln_IdEmpresaElementoUbica NUMBER;
    Ln_IdEmpresaElemento  NUMBER;
    Ln_IdDetaleElemento   NUMBER;
    Ln_Total              NUMBER;
    Ln_IdRecursoDet       NUMBER;
    Lv_UsuarioCreacion    VARCHAR2(30);
    Lv_IpCreacion         VARCHAR2(30);
    Lv_Estado             VARCHAR2(30);
    Ln_ServicioRecursoCab C_ServicioRecursoCab%ROWTYPE;
    Ln_DetId              NUMBER;
    Ln_SRCId              NUMBER;
    Ln_DetalleElemento    C_DetalleElemento%ROWTYPE;
    Ln_DetalleId          NUMBER;
    Lv_DetalleNombre      VARCHAR2(30);


  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Obtenemos el total de los atributos que se encuentran dentro de 'data'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    --Datos principales para cada una de las tablas a insertar.
    Lv_Estado             := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'      , P_VALUES => Lt_JsonIndex);
    Lv_UsuarioCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion' , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion         := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'  , P_VALUES => Lt_JsonIndex);
    Ln_IdElemento         := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId'  , P_VALUES => Lt_JsonIndex);


    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Obtenemos el total de los atributos que se encuentran dentro de 'factibilidad'.
    Ln_TotalFactibilidad := APEX_JSON.GET_COUNT(P_PATH => 'factibilidad', P_VALUES => Lt_JsonIndex);

    IF Ln_TotalFactibilidad < 1 OR Ln_TotalFactibilidad IS NULL THEN
      Lv_Mensaje := 'El atributo factibilidad se encuentra vacio o no existe en el Json.';
      RAISE Le_Exception;
    END IF;

    FOR i in 1..Ln_TotalFactibilidad LOOP

      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;

      Lv_DetalleNombre    := APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].detalleNombre',
                                                          p0 => i, P_VALUES => Lt_JsonIndex);

      OPEN C_DetalleElemento(Ln_IdElemento,Lv_DetalleNombre);
          FETCH C_DetalleElemento INTO Ln_DetalleElemento;
          Ln_DetalleId := Ln_DetalleElemento.DETALLE_ID;
      CLOSE C_DetalleElemento;

      IF Ln_DetalleId IS NULL THEN

        APEX_JSON.WRITE('elementoId'           , Ln_IdElemento);
        APEX_JSON.WRITE('detalleNombre'        , Lv_DetalleNombre);
        APEX_JSON.WRITE('detalleValor'         , APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].detalleValor',
                                                  p0 => i, P_VALUES => Lt_JsonIndex));   
        APEX_JSON.WRITE('detalleDescripcion'   , APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].detalleNombre',
                                                  p0 => i, P_VALUES => Lt_JsonIndex));
        APEX_JSON.WRITE('estado'               , Lv_Estado);
        APEX_JSON.WRITE('usrCreacion'          , Lv_UsuarioCreacion);
        APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_JsonDetElemento := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        --Creamos el detalle elemento.
        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_DETALLE_ELEMENTO(Lcl_JsonDetElemento,
                                                                                Ln_IdDetaleElemento,
                                                                                Lv_Status,
                                                                                Lv_Mensaje); 
        IF Lv_Status  = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear detalle elemento de la máquina virtual');
          RAISE Le_Exception;
        END IF;

      ELSE
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;      
        APEX_JSON.WRITE('detalleValor'         , APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].detalleValor',
                                                  p0 => i, P_VALUES => Lt_JsonIndex));   
        APEX_JSON.WRITE('idDetalleElemento'    , Ln_DetalleId);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_JsonDetElemento := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        --Actualizamos el detalle elemento.
        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_DETALLE_ELEMENTO(Lcl_JsonDetElemento,
                                                                                   Lv_Status,
                                                                                   Lv_Mensaje); 
        IF Lv_Status  = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar detalle elemento de la máquina virtual');
          RAISE Le_Exception;
        END IF;

      END IF;


    END LOOP;

    --Obtenemos el total de los atributos que se encuentran dentro de 'datastore'.
    Ln_TotalDatastore := APEX_JSON.GET_COUNT(P_PATH => 'datastore', P_VALUES => Lt_JsonIndex);

    IF Ln_TotalDatastore < 1 OR Ln_TotalDatastore IS NULL THEN
      Lv_Mensaje := 'El atributo datastore se encuentra vacio o no existe en el Json.';
      RAISE Le_Exception;
    END IF;

    FOR i in 1..Ln_TotalDatastore LOOP

      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      Ln_SRCId    := APEX_JSON.GET_NUMBER(P_PATH   => 'datastore[%d].servicioRecursoCabId',
                                                p0 => i, P_VALUES => Lt_JsonIndex);

      OPEN C_ServicioRecursoCab(Ln_IdElemento,Ln_SRCId);
          FETCH C_ServicioRecursoCab INTO Ln_ServicioRecursoCab;
          Ln_DetId := Ln_ServicioRecursoCab.DETID;
      CLOSE C_ServicioRecursoCab;

      APEX_JSON.WRITE('idServicioRecursoDet', Ln_DetId);
      APEX_JSON.WRITE('descripcion'         , APEX_JSON.GET_VARCHAR2(P_PATH   => 'datastore[%d].descripcion',
                                                p0 => i, P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('estado'              , Lv_Estado);
      APEX_JSON.WRITE('usrUltMod'           , Lv_UsuarioCreacion);
      APEX_JSON.WRITE('ipUltMod'            , Lv_IpCreacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_JsonRecursoDet := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      --Creamos el detalle de los recursos.
      DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_ACTUALIZAR_RECURSO_DET(Lcl_JsonRecursoDet,
                                                                     Lv_Status,
                                                                     Lv_Mensaje); 

      IF Lv_Status  = 'ERROR' THEN
        Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear datastore para disco de la máquina virtual');
        RAISE Le_Exception;
      END IF;
    END LOOP;


    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

        Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR( Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR( SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
  END P_CREAR_FACTIBILIDAD_MV;
----
----
  PROCEDURE P_CREAR_FACTIBILIDAD_SERVIDOR(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2)
    IS

     --Cursores Locales.
    CURSOR C_ServidoresContratados(Cn_ServicioId   NUMBER)
    IS
      SELECT 
             COUNT (MODELO.ID_MODELO_ELEMENTO) AS CANTIDAD,
             MODELO.ID_MODELO_ELEMENTO         AS MODELO,
             MODELO.NOMBRE_MODELO_ELEMENTO     AS NOMBREMODELO,
             SRC.ID_SERVICIO_RECURSO_CAB       AS CABID
      FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB SRC
      JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO
      ON MODELO.NOMBRE_MODELO_ELEMENTO = SRC.DESCRIPCION_RECURSO
      WHERE SRC.SERVICIO_ID = Cn_ServicioId
      AND   SRC.ESTADO='Activo'
      AND   MODELO.ESTADO='Activo'
      GROUP BY MODELO.ID_MODELO_ELEMENTO, SRC.ID_SERVICIO_RECURSO_CAB,MODELO.NOMBRE_MODELO_ELEMENTO ;

    CURSOR C_ServidoresDisponibles(Cn_ModeloId     NUMBER,
                                   Cn_Cantidad     NUMBER,
                                   Cn_CantonId     NUMBER,
                                   Cv_EmpresaCod   VARCHAR2)
    IS 
      SELECT  
              ELEMENTO.ID_ELEMENTO,
              ELEMENTO.NOMBRE_ELEMENTO
      FROM 
        DB_INFRAESTRUCTURA.INFO_ELEMENTO               ELEMENTO,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO        MODELO,
        DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EMPRESA_UBICA,
        DB_INFRAESTRUCTURA.INFO_UBICACION              UBICACION,
        DB_GENERAL.ADMI_PARROQUIA                      PARROQUIA,
        DB_GENERAL.ADMI_CANTON                         CANTON
      WHERE ELEMENTO.MODELO_ELEMENTO_ID = MODELO.ID_MODELO_ELEMENTO
      AND ELEMENTO.ID_ELEMENTO          = EMPRESA_UBICA.ELEMENTO_ID
      AND EMPRESA_UBICA.UBICACION_ID    = UBICACION.ID_UBICACION
      AND UBICACION.PARROQUIA_ID        = PARROQUIA.ID_PARROQUIA
      AND PARROQUIA.CANTON_ID           = CANTON.ID_CANTON
      AND MODELO.ID_MODELO_ELEMENTO     = Cn_ModeloId
      AND CANTON.ID_CANTON              = Cn_CantonId
      AND ELEMENTO.ESTADO               = 'Disponible'
      AND EMPRESA_UBICA.EMPRESA_COD     = Cv_EmpresaCod
      AND ROWNUM                       <= Cn_Cantidad;

    CURSOR C_SecuenciaServidor(Cn_ModeloId   NUMBER)
    IS
      SELECT  TO_NUMBER(SUBSTR(ELEMENTO_SERVIDOR.NOMBRE_ELEMENTO, 8, 12))
              AS SECUENCIASERVIDOR
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO_SERVIDOR
      WHERE ELEMENTO_SERVIDOR.ID_ELEMENTO = (
                                              SELECT MAX(ID_ELEMENTO)
                                              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
                                              WHERE ELEMENTO.MODELO_ELEMENTO_ID = Cn_ModeloId
                                              AND ELEMENTO.ESTADO  IN ('Disponible', 'Asignado'));

  CURSOR C_UbicacionDC(Cn_CantonId     NUMBER,
                       Cv_EmpresaCod   VARCHAR2)
  IS
    SELECT UBICACION.ID_UBICACION
    FROM DB_INFRAESTRUCTURA.INFO_UBICACION UBICACION
    JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA ELEMENTO_UBICA
    ON ELEMENTO_UBICA.UBICACION_ID = UBICACION.ID_UBICACION
    JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
    ON ELEMENTO.ID_ELEMENTO = ELEMENTO_UBICA.ELEMENTO_ID
    JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA
    ON PARROQUIA.ID_PARROQUIA = UBICACION.PARROQUIA_ID
    WHERE PARROQUIA.CANTON_ID = Cn_CantonId
    AND ELEMENTO_UBICA.EMPRESA_COD = Cv_EmpresaCod
    AND ELEMENTO.NOMBRE_ELEMENTO IN ('Data Center (A) UIO',
                                     'Data Center ( GYE )');

    Lt_JsonIndex          APEX_JSON.T_VALUES;
    Le_Exception          EXCEPTION;
    Lv_Status             VARCHAR2(50);
    Lv_Mensaje            VARCHAR2(3000);
    Lb_HabilitaCommit     BOOLEAN;
    Lcl_Request           CLOB;
    Lcl_JsonRecursoDet    CLOB;
    Ln_IdElemento         NUMBER;
    Ln_IdEmpresaElementoUbica NUMBER;
    Ln_IdEmpresaElemento  NUMBER;
    Ln_IdServicio         NUMBER;
    Ln_IdCanton           NUMBER;
    Lv_CodEmpresa         VARCHAR2(50);
    Ln_Total                  NUMBER;
    Ln_IdRecursoDet           NUMBER;
    Ln_IdServicioHist         NUMBER;
    Ln_CantidadSolicitada     NUMBER ;
    Ln_TotalDisponible        NUMBER;
    Ln_CantidadFaltante       NUMBER;
    Ln_ModeloSolicitado       VARCHAR2(40);
    Ln_NumSecuenciaServidor   NUMBER;
    Ln_IDUbicacion            NUMBER;
    Ln_SecuenciaServidor      C_SecuenciaServidor%ROWTYPE;
    Lc_ServidoresContratados  C_ServidoresContratados%ROWTYPE;
    Lc_ServidoresDisponibles  C_ServidoresDisponibles%ROWTYPE;
    Lc_UbicacionDC            C_UbicacionDC%ROWTYPE;
    Lv_Historial              VARCHAR2(200);
    Lv_UsuarioCreacion        VARCHAR2(30);
    Lv_IpCreacion             VARCHAR2(30);
    Lv_Estado                 VARCHAR2(30);

  BEGIN

    IF C_ServidoresContratados%ISOPEN THEN
      CLOSE C_ServidoresContratados;
    END IF;

    IF C_ServidoresDisponibles%ISOPEN THEN
      CLOSE C_ServidoresDisponibles;
    END IF;

    IF C_SecuenciaServidor%ISOPEN THEN
      CLOSE C_SecuenciaServidor;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Obtenemos el total de los atributos que se encuentran dentro de 'data'.
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    --Datos principales para cada una de las tablas a insertar.
    Lv_Estado             := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'      , P_VALUES => Lt_JsonIndex);
    Lv_UsuarioCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion' , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion         := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'  , P_VALUES => Lt_JsonIndex);
    Ln_IdServicio         := APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'  , P_VALUES => Lt_JsonIndex);
    Ln_IdCanton           := APEX_JSON.GET_NUMBER(P_PATH   => 'cantonId'    , P_VALUES => Lt_JsonIndex);
    Lv_CodEmpresa         := APEX_JSON.GET_VARCHAR2(P_PATH => 'empresaCod'  , P_VALUES => Lt_JsonIndex);


    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    Lv_Historial :='Se asignó factibilidad automática de los siguientes Servidores: ';
    --Se consultan los modelos de servidores contratados con la cantidad
    FOR Lc_ServidoresContratados IN C_ServidoresContratados(Ln_IdServicio) LOOP
      Ln_CantidadSolicitada := Lc_ServidoresContratados.CANTIDAD;
      Ln_ModeloSolicitado   := Lc_ServidoresContratados.MODELO;
      Ln_TotalDisponible    := 0;

      --Se consultan los elementos servidores disponible segun el modelo solicitado
      FOR Lc_ServidoresDisponibles IN C_ServidoresDisponibles(Ln_ModeloSolicitado,Ln_CantidadSolicitada,
                                       Ln_IdCanton, Lv_CodEmpresa) LOOP                                   
        --Json que actualiza estado elemento servidor para ocuparlo
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('estado'     , 'Asignado');
        APEX_JSON.WRITE('idElemento' , Lc_ServidoresDisponibles.ID_ELEMENTO);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;   
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);

        IF Lv_Status  = 'ERROR' THEN
            Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar elemento servidor');
            RAISE Le_Exception;
          END IF;

        /*Json que inserta detalle de servicio recurso para asociar los 
          servidores asignados con el servicio*/
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('servicioRecursoCabId' , Lc_ServidoresContratados.CABID);
        APEX_JSON.WRITE('elementoId'           , Lc_ServidoresDisponibles.ID_ELEMENTO);
        APEX_JSON.WRITE('cantidad'             , 1);
        APEX_JSON.WRITE('descripcion'          , '');
        APEX_JSON.WRITE('estado'               , Lv_Estado);
        APEX_JSON.WRITE('usrCreacion'          , Lv_UsuarioCreacion);
        APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_JsonRecursoDet := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        --Creamos el detalle de los recursos.
        DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_DET(Lcl_JsonRecursoDet,
                                                                       Ln_IdRecursoDet,
                                                                       Lv_Status,
                                                                       Lv_Mensaje); 
        IF Lv_Status  = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al asociar el servidor con el servicio');
          RAISE Le_Exception;
        END IF;

        Ln_TotalDisponible := Ln_TotalDisponible + 1;
      END LOOP;

      Ln_CantidadFaltante := Ln_CantidadSolicitada - Ln_TotalDisponible;

      --Si faltan servidores para asignar factibilidad se deben insertar elementos servidores
      IF Ln_CantidadFaltante > 0 THEN
        --Consultados la secuencia del nombre del servidor para agregar al stock
        OPEN C_SecuenciaServidor(Ln_ModeloSolicitado);
          FETCH C_SecuenciaServidor INTO Ln_SecuenciaServidor;
          Ln_NumSecuenciaServidor := Ln_SecuenciaServidor.SECUENCIASERVIDOR;
        CLOSE C_SecuenciaServidor;

        --Consultados la ubicacion según el cantón
        OPEN C_UbicacionDC(Ln_IdCanton, Lv_CodEmpresa);
          FETCH C_UbicacionDC INTO Lc_UbicacionDC;
          Ln_IDUbicacion := Lc_UbicacionDC.ID_UBICACION;
        CLOSE C_UbicacionDC;

        --Ciclo para crear los elementos servidores y servicio recurso det faltantes
        FOR I IN 1..Ln_CantidadFaltante LOOP 
            --Contador de secuencia para el nombre del elemento
            Ln_NumSecuenciaServidor := Ln_NumSecuenciaServidor + 1;

            --Json para crear elemento máquina virtual.
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('estado'              , 'Asignado');
            APEX_JSON.WRITE('usrCreacion'         , Lv_UsuarioCreacion);
            APEX_JSON.WRITE('ipCreacion'          , Lv_IpCreacion);
            APEX_JSON.WRITE('nombreElemento'      , 'SERVER '||Ln_NumSecuenciaServidor);
            APEX_JSON.WRITE('descripcionElemento' , 'SERVER '||Ln_NumSecuenciaServidor);
            APEX_JSON.WRITE('modeloElementoId'    , Lc_ServidoresContratados.MODELO);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;   
            APEX_JSON.FREE_OUTPUT;

            --Creación de elemento máquina virtual..
            DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_GUARDAR_ELEMENTO(Lcl_Request,Ln_IdElemento,Lv_Status,Lv_Mensaje);

            IF Lv_Status  = 'ERROR' THEN
                    Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear elemento de máquina virtual');
                    RAISE Le_Exception;
            END IF;

            /*Json que inserta detalle de servicio recurso para asociar los 
              servidores asignados con el servicio*/
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('servicioRecursoCabId' , Lc_ServidoresContratados.CABID);
            APEX_JSON.WRITE('elementoId'           , Ln_IdElemento);
            APEX_JSON.WRITE('cantidad'             , 1);
            APEX_JSON.WRITE('descripcion'          , '');
            APEX_JSON.WRITE('estado'               , Lv_Estado);
            APEX_JSON.WRITE('usrCreacion'          , Lv_UsuarioCreacion);
            APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_JsonRecursoDet := APEX_JSON.GET_CLOB_OUTPUT;
            APEX_JSON.FREE_OUTPUT;

            --Creamos el detalle de los recursos.
            DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_DET(Lcl_JsonRecursoDet,
                                                                           Ln_IdRecursoDet,
                                                                           Lv_Status,
                                                                           Lv_Mensaje); 
            IF Lv_Status  = 'ERROR' THEN
              Lv_Mensaje := NVL(Lv_Mensaje,'Error al asociar el servidor nuevo con el servicio');
              RAISE Le_Exception;
            END IF;

        END LOOP;
     END IF;
    --Variable para escribir historial
    Lv_Historial := Lv_Historial || '<br><b>' || Lc_ServidoresContratados.NOMBREMODELO || '</b>';
    END LOOP;

    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId'    , Ln_IdServicio);
    APEX_JSON.WRITE('observacion'   , Lv_Historial);
    APEX_JSON.WRITE('estado'        ,'Pendiente');
    APEX_JSON.WRITE('usrCreacion'   , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'    , Lv_IpCreacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_GUARDAR_SERVICIO_HISTORIAL(Lcl_Request,
                                                                        Ln_IdServicioHist,
                                                                        Lv_Status,
                                                                        Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al asociar el servidor nuevo con el servicio');
      RAISE Le_Exception;
    END IF;

    --Json para actualizar el servicio.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idServicio' , Ln_IdServicio);
    APEX_JSON.WRITE('estado'     , 'Pendiente');
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_ACTUALIZAR_SERVICIO(Lcl_Request,Lv_Status,Lv_Mensaje);

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := Lv_Historial;

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
  END P_CREAR_FACTIBILIDAD_SERVIDOR;
----
----
  PROCEDURE P_CREAR_FACTIB_POOL_SERVIDOR(Pcl_Request IN  CLOB,
                                         Pv_Status   OUT VARCHAR2,
                                         Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_Recurso(Cn_RecursoId   NUMBER)
    IS
      SELECT SRC.DESCRIPCION_RECURSO NOMBRE
      FROM  DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB SRC
      WHERE SRC.ID_SERVICIO_RECURSO_CAB = Cn_RecursoId;

    CURSOR C_Elemento(Cn_ElementoId   NUMBER)
    IS  
       SELECT MODELO.NOMBRE_MODELO_ELEMENTO MODELO
       FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
       JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO
       ON MODELO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID
       WHERE ELEMENTO.ID_ELEMENTO = Cn_ElementoId;



    Lt_JsonIndex          APEX_JSON.T_VALUES;
    Le_Exception          EXCEPTION;
    Lv_Status             VARCHAR2(50);
    Lv_Mensaje            VARCHAR2(3000);
    Lb_HabilitaCommit     BOOLEAN;
    Lcl_Request           CLOB;
    Lcl_JsonRecursoDet    CLOB;
    Lcl_JsonDetElemento   CLOB;
    Ln_TotalDatastore     NUMBER;
    Ln_TotalRecursosDet   NUMBER;
    Ln_TotalFactibilidad  NUMBER;
    Ln_IdElemento         NUMBER;
    Ln_IdEmpresaElementoUbica NUMBER;
    Ln_IdEmpresaElemento  NUMBER;
    Ln_IdDetaleElemento   NUMBER;
    Ln_Total              NUMBER;
    Lc_Elemento           C_Elemento%ROWTYPE;
    Lc_Recurso            C_Recurso%ROWTYPE;
    Ln_IdRecursoDet       NUMBER;
    Ln_IdRecursoCab       NUMBER;
    Lv_Datastore          VARCHAR2(200);
    Lv_UsuarioCreacion    VARCHAR2(30);
    Lv_IpCreacion         VARCHAR2(30);
    Lv_Estado             VARCHAR2(30);
    Lv_Historial          VARCHAR2(4000);
    Ln_IdSolicitud        NUMBER;
    Ln_IdDetalleHist      NUMBER;
    Ln_ServicioId         NUMBER;
    Ln_IdServicioHist     NUMBER;
    Ln_SRCId     NUMBER;

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Obtenemos el total de los atributos que se encuentran dentro de 'data'.
    Ln_Total        := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);
    Ln_IdSolicitud  := APEX_JSON.GET_NUMBER(P_PATH => 'dataSolicitud.solicitud.idDetalleSolicitud' , P_VALUES => Lt_JsonIndex);

    --Obtenemos el total de los atributos que se encuentran dentro de 'factibilidad'.
    Ln_TotalFactibilidad := APEX_JSON.GET_COUNT(P_PATH => 'factibilidad', P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    IF Ln_TotalFactibilidad < 1 OR Ln_TotalFactibilidad IS NULL THEN
      Lv_Mensaje := 'El atributo factibilidad se encuentra vacio o no existe en el Json.';
      RAISE Le_Exception;
    END IF;

    --Datos principales para cada una de las tablas a insertar.
    Lv_Estado             := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'      , P_VALUES => Lt_JsonIndex);
    Lv_UsuarioCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion' , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion         := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'  , P_VALUES => Lt_JsonIndex);
    Ln_ServicioId         := APEX_JSON.GET_VARCHAR2(P_PATH => 'servicioId'  , P_VALUES => Lt_JsonIndex);

    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    Lv_Historial := 'Se realizó la siguiente asignación de Pool de Recursos: 
                    Se generó Factibilidad con las siguientes Descripciones:';

    FOR i in 1..Ln_TotalFactibilidad LOOP

        Ln_IdElemento   := APEX_JSON.GET_NUMBER(P_PATH   => 'factibilidad[%d].elementoId',
                                              p0 => i, P_VALUES => Lt_JsonIndex);     
        Ln_IdRecursoCab := TO_NUMBER(APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].servicioRecursoCabId',
                                                 p0 => i, P_VALUES => Lt_JsonIndex),999999);
         Lv_Datastore   := APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].descripcion',
                                                 p0 => i, P_VALUES => Lt_JsonIndex);
        /*Json que inserta detalle de servicio recurso para asociar el 
          servidor con el disco*/
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('servicioRecursoCabId' , Ln_IdRecursoCab);
        APEX_JSON.WRITE('elementoId'           , Ln_IdElemento);
        APEX_JSON.WRITE('cantidad'             , TO_NUMBER(APEX_JSON.GET_VARCHAR2(P_PATH   => 'factibilidad[%d].cantidad',
                                                 p0 => i, P_VALUES => Lt_JsonIndex),9999999));
        APEX_JSON.WRITE('descripcion'          , Lv_Datastore);
        APEX_JSON.WRITE('estado'               , Lv_Estado);
        APEX_JSON.WRITE('usrCreacion'          , Lv_UsuarioCreacion);
        APEX_JSON.WRITE('ipCreacion'           , Lv_IpCreacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_JsonRecursoDet := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        --Guardamos la factibilidad de disco para el elemento servidor.
        DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_GUARDAR_RECURSO_DET(Lcl_JsonRecursoDet,
                                                                       Ln_IdRecursoDet,
                                                                       Lv_Status,
                                                                       Lv_Mensaje); 

        IF Lv_Status  = 'ERROR' THEN
          Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear factibilidad de para servidor');
          RAISE Le_Exception;
        END IF;

      OPEN C_Elemento(Ln_IdElemento);
          FETCH C_Elemento
          INTO Lc_Elemento;
      CLOSE C_Elemento;

      OPEN C_Recurso(Ln_IdRecursoCab);
            FETCH C_Recurso
            INTO Lc_Recurso;
      CLOSE C_Recurso;

      Lv_Historial := Lv_Historial || '<br><b>Modelo Servidor</b>: ' || Lc_Elemento.MODELO 
                      || '  <b>Recurso:</b>   : ' || Lc_Recurso.NOMBRE ;
      IF Lv_Datastore IS NOT NULL THEN
           Lv_Historial := Lv_Historial ||'  <b>Datastore</b> : ' || Lv_Datastore || '  <br/> ';
      ELSE 
           Lv_Historial := Lv_Historial ||'  <br/> ';
      END IF;

     END LOOP;        
 --Llamada al método que parsea y actualiza la solicitud.
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_PARSEO_JSON_SOLICITUD(Pcl_Request,Lv_Status,Lv_Mensaje);

    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la solicitud.');
      RAISE Le_Exception;
    END IF;

    --Insertamos la observación en los Historiales.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('detalleSolicitudId', Ln_IdSolicitud);
    APEX_JSON.WRITE('observacion'       , Lv_Historial);
    APEX_JSON.WRITE('estado'            , 'Asignada');
    APEX_JSON.WRITE('usrCreacion'       , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'        , Lv_IpCreacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_GUARDAR_DETALLE_SOL_HIST(Lcl_Request,Ln_IdDetalleHist,Lv_Status,Lv_Mensaje);
    
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la solicitud.');
      RAISE Le_Exception;
    END IF;

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId'  , Ln_ServicioId);
    APEX_JSON.WRITE('observacion' , Lv_Historial);
    APEX_JSON.WRITE('estado'      , 'Asignada');
    APEX_JSON.WRITE('usrCreacion' , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'  , Lv_IpCreacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    
    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_GUARDAR_SERVICIO_HISTORIAL(Lcl_Request,Ln_IdServicioHist,Lv_Status,Lv_Mensaje);
    
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al guardar el historial del servicio.');
      RAISE Le_Exception;
    END IF;

  IF Lb_HabilitaCommit THEN
     COMMIT;
  END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := Lv_Mensaje;

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
  END P_CREAR_FACTIB_POOL_SERVIDOR;
----
----
  PROCEDURE P_ELIMINAR_MV(Pcl_Request IN  CLOB,
                        Pv_Status   OUT VARCHAR2,
                        Pv_Mensaje  OUT VARCHAR2)
    IS

    --Cursores Locales
    CURSOR C_ExisteRecursoDet(Cn_IdElemento NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET
      WHERE ELEMENTO_ID = Cn_IdElemento;

    --Variables Locales.
    Lt_JsonIndex         APEX_JSON.T_VALUES;
    Le_Exception         EXCEPTION;
    Lv_Mensaje           VARCHAR2(1000);
    Lv_Status            VARCHAR2(1000);
    Ln_ElementoId        NUMBER;
    Ln_IdRecursoDet      NUMBER;
    Ln_ExisteRecursoDet  NUMBER;
    Ln_IdServicioTecn    NUMBER;
    Lcl_Request          CLOB;
    Lb_HabilitaCommit    BOOLEAN;
    Lr_InfoHistorialElemento DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO%ROWTYPE;

  BEGIN

    IF C_ExisteRecursoDet%ISOPEN THEN
      CLOSE C_ExisteRecursoDet;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod')      IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')       IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'nombreElemento') IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')       IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo [(elementoId),usrUltMod,ipUltMod)';
      RAISE Le_Exception;
    END IF;

    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);   
    Ln_ElementoId := APEX_JSON.GET_NUMBER(P_PATH => 'elementoId');

    OPEN C_ExisteRecursoDet(Ln_ElementoId);
      FETCH C_ExisteRecursoDet INTO Ln_ExisteRecursoDet;
    CLOSE C_ExisteRecursoDet;

    IF Ln_ExisteRecursoDet < 1 THEN
      Lv_Mensaje := 'No existe detalle asociado al elementoId('||Ln_ElementoId||')';
      RAISE Le_Exception;
    END IF;

    --Array para eliminar el elemento máquina virtual.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('idElemento'   , Ln_ElementoId);
      APEX_JSON.WRITE('estado'       , APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'));
      APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);
    IF Lv_Status  = 'ERROR' THEN
       Lv_Mensaje := NVL(Lv_Mensaje,'Error al eliminar la máquina virtual');
       RAISE Le_Exception;
    END IF;

    DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_ACTUALIZAR_RECURSO_DET(Pcl_Request,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al eliminar recursos de la máquina virtual');
      RAISE Le_Exception;
    END IF;

    DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_DETALLE_ELEMENTO(Pcl_Request,Lv_Status,Lv_Mensaje);
    IF Lv_Status  = 'ERROR' THEN
       Lv_Mensaje := NVL(Lv_Mensaje,'Error al eliminar la factibilidad de la máquina virtual');
       RAISE Le_Exception;
    END IF;

    Lr_InfoHistorialElemento                 := NULL;
    Lr_InfoHistorialElemento.ELEMENTO_ID     := Ln_ElementoId;
    Lr_InfoHistorialElemento.ESTADO_ELEMENTO := 'Eliminado';
    Lr_InfoHistorialElemento.OBSERVACION     := 'Se eliminó la máquina virtual : <b>'||APEX_JSON.GET_VARCHAR2(P_PATH => 'nombreElemento');
    Lr_InfoHistorialElemento.USR_CREACION    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod');
    Lr_InfoHistorialElemento.IP_CREACION     := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod');
    DB_INFRAESTRUCTURA.INFRK_DML.INFRP_INSERT_HISTORIAL_ELEMENT(Lr_InfoHistorialElemento, Lv_Mensaje);
    IF Lv_Mensaje  IS NOT NULL THEN
       Lv_Mensaje := NVL(SUBSTR(Lv_Mensaje, 0 , 3000 ),'Error al insertar historial de la máquina virtual');
       RAISE Le_Exception;
    END IF;

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;
    -- Se confirman los cambios realizados
    IF Lb_HabilitaCommit THEN
     COMMIT;
    END IF;

    --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR( Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );

  END P_ELIMINAR_MV;
----
----
  PROCEDURE P_REVERSAR_POOL_SERVIDOR(Pcl_Request IN  CLOB,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2)
    IS

    --Cursores Locales
    CURSOR C_Servidores(Cn_IdServicio NUMBER)
    IS
      SELECT SRD.ELEMENTO_ID
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB SRC
        JOIN DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET SRD
        ON SRD.SERVICIO_RECURSO_CAB_ID = SRC.ID_SERVICIO_RECURSO_CAB
      WHERE SRC.SERVICIO_ID = Cn_IdServicio;

    --Variables Locales.
    Lt_JsonIndex         APEX_JSON.T_VALUES;
    Le_Exception         EXCEPTION;
    Lv_Mensaje           VARCHAR2(1000);
    Lv_Status            VARCHAR2(1000);
    Ln_ElementoId        NUMBER;
    Ln_IdRecursoDet      NUMBER;
    Ln_ExisteRecursoDet  NUMBER;
    Ln_IdServicioTecn    NUMBER;
    Lcl_Request          CLOB;
    Lb_HabilitaCommit    BOOLEAN;
    Ln_ServicioId        NUMBER;
    Lc_Servidores        C_Servidores%ROWTYPE;
    Lv_UsuarioMod        VARCHAR2(20);
    Lv_IpMod             VARCHAR2(20);

  BEGIN

    IF C_Servidores%ISOPEN THEN
      CLOSE C_Servidores;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod')      IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')       IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId')       IS NULL  THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo [(servicioId),usrUltMod,ipUltMod)';
      RAISE Le_Exception;
    END IF;

    Lv_UsuarioMod     := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod' );
    Lv_IpMod          := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod'  );
    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit');   
    Ln_ServicioId     := APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId');

    OPEN C_Servidores(Ln_ServicioId);
      FETCH C_Servidores INTO Lc_Servidores;
    CLOSE C_Servidores;

    FOR Lc_Servidores IN C_Servidores(Ln_ServicioId) LOOP
        --Array para reversar el elemento servidor.
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('idElemento'   , Lc_Servidores.ELEMENTO_ID);
          APEX_JSON.WRITE('estado'       , 'Disponible');
          APEX_JSON.WRITE('usrUltMod'    , Lv_UsuarioMod);
          APEX_JSON.WRITE('ipUltMod'     , Lv_IpMod);
          APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION.P_ACTUALIZAR_ELEMENTO(Lcl_Request,Lv_Status,Lv_Mensaje);

        IF Lv_Status  = 'ERROR' THEN
           Lv_Mensaje := NVL(SUBSTR( Lv_Mensaje, 0 , 3000 ),'Error al reversar el detalles de los recursos');
           RAISE Le_Exception;
        END IF;

        --Array para eliminar registros de InfoServicioRecursoDet asociado a los servidores que se reversan
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('elementoId'   , Lc_Servidores.ELEMENTO_ID);
          APEX_JSON.WRITE('estado'       , 'Eliminado');
          APEX_JSON.WRITE('usrUltMod'    , Lv_UsuarioMod);
          APEX_JSON.WRITE('ipUltMod'     , Lv_IpMod);
          APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION.P_ACTUALIZAR_RECURSO_DET(Lcl_Request,Lv_Status,Lv_Mensaje);

        IF Lv_Status  = 'ERROR' THEN
          Lv_Mensaje := NVL(SUBSTR( Lv_Mensaje, 0 , 3000 ),'Error al eliminar recursos de la máquina virtual');
          RAISE Le_Exception;
        END IF;

    END LOOP;

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;
    -- Se confirman los cambios realizados
    IF Lb_HabilitaCommit THEN
     COMMIT;
    END IF;

    --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );

  END P_REVERSAR_POOL_SERVIDOR;

END INKG_SOLUCIONES_TRANSACCION;
/
