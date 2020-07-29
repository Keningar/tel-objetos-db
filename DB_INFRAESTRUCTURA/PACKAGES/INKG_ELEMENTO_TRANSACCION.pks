SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION AS

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_RELACION_ELEMENTO'
   *
   * Método encargado de actualizar un registro en la 'INFO_RELACION_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request
   * @param Pv_Status   OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 06-07-2020
   */
  PROCEDURE P_ACTUALIZAR_RELACION_ELEMENTO(Pcl_Request IN  CLOB,
                                           Pv_Mensaje  OUT VARCHAR2,
                                           Pv_Status   OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_ELEMENTO'
   *
   * Método encargado de guardar un registro en la 'INFO_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request      IN  CLOB Recibe json request
   * @param Pn_IdElemento    OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status        OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje       OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_ELEMENTO(Pcl_Request      IN  CLOB,
                               Pn_IdElemento    OUT NUMBER,
                               Pv_Status        OUT VARCHAR2,
                               Pv_Mensaje       OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_DETALLE_ELEMENTO'
   *
   * Método encargado de guardar un registro en la 'INFO_DETALLE_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request             IN  CLOB Recibe json request
   * @param Pn_IdDetalleElemento    OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status               OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje              OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_DETALLE_ELEMENTO(Pcl_Request             IN  CLOB,
                                       Pn_IdDetalleElemento    OUT NUMBER,
                                       Pv_Status               OUT VARCHAR2,
                                       Pv_Mensaje              OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_ELEMENTO'.
   *
   * Método encargado de actualizar un registro en la 'INFO_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_ACTUALIZAR_ELEMENTO(Pcl_Request IN  CLOB,
                                  Pv_Status   OUT VARCHAR2,
                                  Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_RELACION_ELEMENTO'
   *
   * Método encargado de guardar un registro en la 'INFO_RELACION_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request             IN  CLOB Recibe json request
   * @param Pn_IdRelacionElemento   OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status               OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje              OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_RELACION_ELEMENTO(Pcl_Request             IN  CLOB,
                                       Pn_IdRelacionElemento   OUT NUMBER,
                                       Pv_Status               OUT VARCHAR2,
                                       Pv_Mensaje              OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_DETALLE_ELEMENTO'.
   *
   * Método encargado de actualizar un registro en la 'INFO_DETALLE_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_ACTUALIZAR_DETALLE_ELEMENTO(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_ELEMENTO'
   *
   * Método encargado de guardar un registro en la 'INFO_EMPRESA_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request             IN  CLOB Recibe json request
   * @param Pn_IdEmpresaElemento    OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status               OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje              OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_EMPRESA_ELEMENTO(Pcl_Request      IN  CLOB,
                               Pn_IdEmpresaElemento    OUT NUMBER,
                               Pv_Status        OUT VARCHAR2,
                               Pv_Mensaje       OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_EMPRESA_ELEMENTO'.
   *
   * Método encargado de actualizar un registro en la 'INFO_EMPRESA_ELEMENTO' del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_ACTUALIZAR_EMPRESA_ELEMENTO(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_ELEMENTO_UBICA'
   *
   * Método encargado de guardar un registro en la 'INFO_EMPRESA_ELEMENTO'UBICA del esquema 'DB_INFRAESTRUCTURA'.
   *
   * @param Pcl_Request                   IN  CLOB Recibe json request
   * @param Pn_IdEmpresaElemento_Ubica    OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status                     OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje                    OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_EMPRESA_ELEMENTO_UBI(Pcl_Request                IN  CLOB,
                                             Pn_IdEmpresaElementoUbica  OUT NUMBER,
                                             Pv_Status                  OUT VARCHAR2,
                                             Pv_Mensaje                 OUT VARCHAR2);

END INKG_ELEMENTO_TRANSACCION;
/
CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_ELEMENTO_TRANSACCION AS
----
----
  PROCEDURE P_ACTUALIZAR_RELACION_ELEMENTO(Pcl_Request IN  CLOB,
                                           Pv_Mensaje  OUT VARCHAR2,
                                           Pv_Status   OUT VARCHAR2)
  IS

    Lcl_Request           CLOB;
    Ln_IdRelacionElemento NUMBER;
    Ln_elementoIdA        NUMBER;
    Ln_elementoIdB        NUMBER;

  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdRelacionElemento := APEX_JSON.GET_NUMBER(P_PATH => 'idRelacionElemento');
    Ln_elementoIdA        := APEX_JSON.GET_NUMBER(P_PATH => 'elementoIdA');
    Ln_elementoIdB        := APEX_JSON.GET_NUMBER(P_PATH => 'elementoIdB');

    UPDATE DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO
      SET ELEMENTO_ID_A = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'elementoIdA')  , ELEMENTO_ID_A),
          ELEMENTO_ID_B = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'elementoIdB')  , ELEMENTO_ID_B),
          TIPO_RELACION = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoRelacion') , TIPO_RELACION),
          POSICION_X    = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'posicionX')    , POSICION_X),
          POSICION_Y    = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'posicionY')    , POSICION_Y),
          POSICION_Z    = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'posicionZ')    , POSICION_Z),
          OBSERVACION   = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'observacion')  , OBSERVACION),
          ESTADO        = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')       , ESTADO)
    WHERE ID_RELACION_ELEMENTO = Ln_IdRelacionElemento
      OR  (ELEMENTO_ID_A = Ln_elementoIdA AND ELEMENTO_ID_B = Ln_elementoIdB);

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );

  END P_ACTUALIZAR_RELACION_ELEMENTO;
----
----
  PROCEDURE P_GUARDAR_ELEMENTO(Pcl_Request      IN  CLOB,
                               Pn_IdElemento    OUT NUMBER,
                               Pv_Status        OUT VARCHAR2,
                               Pv_Mensaje       OUT VARCHAR2) 
  IS

    Ln_idElemento     NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(3000);
    Le_InfoElemento   DB_INFRAESTRUCTURA.INFO_ELEMENTO%ROWTYPE;
    Lv_Result         VARCHAR2(3000) := '';

  BEGIN

  --Parse del JSON
  APEX_JSON.PARSE(Pcl_Request);

  IF APEX_JSON.GET_NUMBER(P_PATH   => 'modeloElementoId') IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'nombreElemento')   IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')           IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')      IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')       IS NULL THEN
    Lv_Mensaje := 'Ningún valor puede ir nulo (modeloElementoId,nombreElemento,estado,usrCreacion,ipCreacion)';
    RAISE Le_Exception;
  END IF;

  Ln_idElemento := DB_INFRAESTRUCTURA.SEQ_INFO_ELEMENTO.NEXTVAL;
  --Insert de la tabla.
  INSERT INTO DB_INFRAESTRUCTURA.INFO_ELEMENTO(
      ID_ELEMENTO,
      MODELO_ELEMENTO_ID,
      NOMBRE_ELEMENTO,
      DESCRIPCION_ELEMENTO,
      SERIE_FISICA,
      SERIE_LOGICA,
      VERSION_OS,
      FUNCION,
      CLAVE_CONFIGURACION,
      FE_FABRICACION,
      ACCESO_PERMANENTE,
      OBSERVACION,
      USR_RESPONSABLE,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION,
      REVISION,
      ESTADO,
      REF_ELEMENTO_ID
   )  VALUES (
      Ln_IdElemento,
      APEX_JSON.GET_NUMBER(P_PATH     => 'modeloElementoId'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'nombreElemento'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'descripcionElemento'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'serieFisica'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'serieLogica'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'versionOs'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'funcion'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'claveConfiguracion'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'feFabricacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'accesoPermanente'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'observacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'usrResponsable'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'usrCreacion'),
      SYSDATE,
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'ipCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'revision'),
      APEX_JSON.GET_VARCHAR2(P_PATH   => 'estado'),
      APEX_JSON.GET_NUMBER(P_PATH     => 'refElementoId')
  );

  --Respuesta Exitosa.
  Pv_Status         := 'OK';
  Pv_Mensaje        := 'Transación exitosa';
  Pn_IdElemento     :=  Ln_idElemento;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
      Pn_IdElemento :=  0;
    WHEN OTHERS THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
      Pn_IdElemento :=  0;

  END P_GUARDAR_ELEMENTO;

  PROCEDURE P_ACTUALIZAR_ELEMENTO(Pcl_Request IN  CLOB,
                                  Pv_Status   OUT VARCHAR2,
                                  Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteElemento(Cn_IdElemento NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE ID_ELEMENTO = Cn_IdElemento;

    --Variables Locales.
    Le_Exception       EXCEPTION;
    Lv_Mensaje         VARCHAR2(3000);
    Ln_IdElemento      NUMBER;
    Ln_ExisteElemento  NUMBER;

  BEGIN

    IF C_ExisteElemento%ISOPEN THEN
      CLOSE C_ExisteElemento;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdElemento := APEX_JSON.GET_NUMBER(P_PATH => 'idElemento');

    IF Ln_IdElemento IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idElemento)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteElemento(Ln_IdElemento);
      FETCH C_ExisteElemento INTO Ln_ExisteElemento;
    CLOSE C_ExisteElemento;

    IF Ln_ExisteElemento < 1 THEN
      Lv_Mensaje := 'No existe el elemento para el id('||Ln_IdElemento||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
      SET MODELO_ELEMENTO_ID     = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'modeloElementoId')      , MODELO_ELEMENTO_ID),
          NOMBRE_ELEMENTO        = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'nombreElemento')        , NOMBRE_ELEMENTO),
          DESCRIPCION_ELEMENTO   = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'descripcionElemento')   , DESCRIPCION_ELEMENTO),
          SERIE_FISICA           = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'serieFisica')           , SERIE_FISICA),
          SERIE_LOGICA           = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'serieLogica')           , SERIE_LOGICA),
          ESTADO                 = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')                , ESTADO)
    WHERE ID_ELEMENTO= Ln_IdElemento;

    --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR('P_ACTUALIZAR_ELEMENTO - Error: '|| Lv_Mensaje, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR('P_ACTUALIZAR_ELEMENTO - Error: '|| SQLERRM, 0 , 3000 );

  END P_ACTUALIZAR_ELEMENTO;

  PROCEDURE P_GUARDAR_DETALLE_ELEMENTO(Pcl_Request            IN  CLOB,
                                       Pn_IdDetalleElemento   OUT NUMBER,
                                       Pv_Status              OUT VARCHAR2,
                                       Pv_Mensaje             OUT VARCHAR2) 
    IS

    Ln_IdDetalleElemento    NUMBER;
    Le_Exception            EXCEPTION;
    Lv_Mensaje              VARCHAR2(3000);
    Lr_InfoDetalleElemento  DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO%ROWTYPE;
    Lv_Result               VARCHAR2(3000) := '';

  BEGIN

  --Parse del JSON
  APEX_JSON.PARSE(Pcl_Request);
  Ln_IdDetalleElemento := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;

  IF APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')         IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleNombre')      IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleValor')       IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleDescripcion') IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')             IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')        IS NULL THEN
    Lv_Mensaje := 'Ningún valor puede ir nulo (elementoId,detalleNombre,detalleValor,detalleDescripcion,estado,usrCreacion)';
    RAISE Le_Exception;
  END IF;

  Lv_Result                                       := '';
  Lr_InfoDetalleElemento                          := NULL;
  Lr_InfoDetalleElemento.ID_DETALLE_ELEMENTO      := Ln_IdDetalleElemento;
  Lr_InfoDetalleElemento.ELEMENTO_ID              := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId');
  Lr_InfoDetalleElemento.DETALLE_NOMBRE           := APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleNombre');
  Lr_InfoDetalleElemento.DETALLE_VALOR            := APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleValor');
  Lr_InfoDetalleElemento.DETALLE_DESCRIPCION      := APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleDescripcion') ;
  Lr_InfoDetalleElemento.REF_DETALLE_ELEMENTO_ID  := APEX_JSON.GET_NUMBER(P_PATH   => 'refDetalleElementoId');
  Lr_InfoDetalleElemento.USR_CREACION             := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion');
  Lr_InfoDetalleElemento.IP_CREACION              := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion');
  Lr_InfoDetalleElemento.ESTADO                   := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');
  INFRK_DML.INFRP_INSERT_DETALLE_ELEMENTO(Lr_InfoDetalleElemento, Lv_Result);
  Pv_Status             := 'OK';
  Pv_Mensaje            := 'Transación exitosa';
  Pn_IdDetalleElemento  :=  Ln_IdDetalleElemento;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := SUBSTR('P_GUARDAR_DETALLE_ELEMENTO - Error: '||Lv_Mensaje, 0 , 3000 );
      Pn_IdDetalleElemento :=  0;
    WHEN OTHERS THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := SUBSTR('P_GUARDAR_DETALLE_ELEMENTO - Error: '|| SQLERRM || ' - '||Lv_Result, 0 , 3000 );
      Pn_IdDetalleElemento :=  0;
  END P_GUARDAR_DETALLE_ELEMENTO;

  PROCEDURE P_ACTUALIZAR_DETALLE_ELEMENTO(Pcl_Request            IN  CLOB,
                                          Pv_Status              OUT VARCHAR2,
                                          Pv_Mensaje             OUT VARCHAR2) 
    IS

    --Cursores Locales
    CURSOR C_ExisteDetalleElemento(Cn_IdDetalleElemento NUMBER,
                                   Cn_ElementoId        NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ID_DETALLE_ELEMENTO = Cn_IdDetalleElemento
      OR    ELEMENTO_ID         = Cn_ElementoId;

    --Variables Locales.
    Le_Exception              EXCEPTION;
    Lv_Mensaje                VARCHAR2(3000);
    Lv_Result                 VARCHAR2(3000);
    Ln_IdDetalleElemento      NUMBER;
    Ln_ElementoId             NUMBER;
    Ln_ExisteDetalleElemento  NUMBER;
    Lr_InfoDetalleElemento    DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO%ROWTYPE;

  BEGIN

  IF C_ExisteDetalleElemento%ISOPEN THEN
      CLOSE C_ExisteDetalleElemento;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdDetalleElemento := APEX_JSON.GET_NUMBER(P_PATH => 'idDetalleElemento');
    Ln_ElementoId := APEX_JSON.GET_NUMBER(P_PATH => 'elementoId');

    IF Ln_IdDetalleElemento IS NULL AND
       Ln_ElementoId        IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idDetalleElemento, elementoId)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteDetalleElemento(Ln_IdDetalleElemento, Ln_ElementoId);
      FETCH C_ExisteDetalleElemento INTO Ln_ExisteDetalleElemento;
    CLOSE C_ExisteDetalleElemento;

    IF Ln_ExisteDetalleElemento < 1 THEN
      Lv_Mensaje := 'No existe el elemento para el id('||Ln_IdDetalleElemento||')';
      RAISE Le_Exception;
    END IF;

    Lv_Result                                       := '';
    Lr_InfoDetalleElemento                          := NULL;
    Lr_InfoDetalleElemento.ID_DETALLE_ELEMENTO      := Ln_IdDetalleElemento;
    Lr_InfoDetalleElemento.ELEMENTO_ID              := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId');
    Lr_InfoDetalleElemento.DETALLE_NOMBRE           := APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleNombre');
    Lr_InfoDetalleElemento.DETALLE_VALOR            := APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleValor');
    Lr_InfoDetalleElemento.DETALLE_DESCRIPCION      := APEX_JSON.GET_VARCHAR2(P_PATH => 'detalleDescripcion') ;
    Lr_InfoDetalleElemento.REF_DETALLE_ELEMENTO_ID  := APEX_JSON.GET_NUMBER(P_PATH   => 'refDetalleElementoId');
    Lr_InfoDetalleElemento.ESTADO                   := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');
    INFRK_DML.P_UPDATE_INFO_DETALLE_ELEMENTO(Lr_InfoDetalleElemento, Lv_Result);

    --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR('P_ACTUALIZAR_DETALLE_ELEMENTO - Error: '|| Lv_Mensaje, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR('P_ACTUALIZAR_DETALLE_ELEMENTO - Error: '|| SQLERRM, 0 , 3000 );

  END P_ACTUALIZAR_DETALLE_ELEMENTO;

  PROCEDURE P_GUARDAR_RELACION_ELEMENTO(Pcl_Request            IN  CLOB,
                                        Pn_IdRelacionElemento  OUT NUMBER,
                                        Pv_Status              OUT VARCHAR2,
                                        Pv_Mensaje             OUT VARCHAR2) 
    IS

    Ln_IdRelacionElemento   NUMBER;
    Le_Exception            EXCEPTION;
    Lv_Mensaje              VARCHAR2(3000);
    Lr_InfoRelacionElemento DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO%ROWTYPE;
    Lv_Result               VARCHAR2(3000) := '';

  BEGIN

  --Parse del JSON
  APEX_JSON.PARSE(Pcl_Request);
  Ln_IdRelacionElemento := DB_INFRAESTRUCTURA.SEQ_INFO_RELACION_ELEMENTO.NEXTVAL;

  IF APEX_JSON.GET_NUMBER(P_PATH   => 'elementoIdA')       IS NULL OR
     APEX_JSON.GET_NUMBER(P_PATH   => 'elementoIdB')       IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoRelacion')      IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')            IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')       IS NULL THEN
    Lv_Mensaje := 'Ningún valor puede ir nulo (elementoIdA,elementoIdB,tipoRelacion,estado,usrCreacion)';
    RAISE Le_Exception;
  END IF;

  Lv_Result                                       := '';
  Lr_InfoRelacionElemento                         := NULL;
  Lr_InfoRelacionElemento.ID_RELACION_ELEMENTO    := Ln_IdRelacionElemento;
  Lr_InfoRelacionElemento.ELEMENTO_ID_A           := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoIdA');
  Lr_InfoRelacionElemento.ELEMENTO_ID_B           := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoIdB');
  Lr_InfoRelacionElemento.TIPO_RELACION           := APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoRelacion');
  Lr_InfoRelacionElemento.POSICION_X              := APEX_JSON.GET_VARCHAR2(P_PATH => 'posicionX');
  Lr_InfoRelacionElemento.POSICION_Y              := APEX_JSON.GET_VARCHAR2(P_PATH => 'posicionY') ;
  Lr_InfoRelacionElemento.OBSERVACION             := APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion') ;
  Lr_InfoRelacionElemento.USR_CREACION            := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion');
  Lr_InfoRelacionElemento.IP_CREACION             := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion');
  Lr_InfoRelacionElemento.ESTADO                  := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');

  INFRK_DML.INFRP_INSERT_RELACION_ELEMENTO(Lr_InfoRelacionElemento, Lv_Result);
  Pv_Status             := 'OK';
  Pv_Mensaje            := 'Transación exitosa';
  Pn_IdRelacionElemento :=  Ln_IdRelacionElemento;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := 'P_GUARDAR_RELACION_ELEMENTO - Error: '||Lv_Mensaje;
      Pn_IdRelacionElemento :=  0;
    WHEN OTHERS THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := 'P_GUARDAR_RELACION_ELEMENTO - Error: '|| SQLERRM || ' - '||Lv_Result;
      Pn_IdRelacionElemento :=  0;
  END P_GUARDAR_RELACION_ELEMENTO;

  PROCEDURE P_GUARDAR_EMPRESA_ELEMENTO(Pcl_Request            IN  CLOB,
                                       Pn_IdEmpresaElemento   OUT NUMBER,
                                       Pv_Status              OUT VARCHAR2,
                                       Pv_Mensaje             OUT VARCHAR2) 
    IS

    Ln_IdEmpresaElemento    NUMBER;
    Le_Exception            EXCEPTION;
    Lv_Mensaje              VARCHAR2(3000);
    Lr_InfoEmpresaElemento  DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO%ROWTYPE;
    Lv_Result               VARCHAR2(3000) := '';

  BEGIN

  --Parse del JSON
  APEX_JSON.PARSE(Pcl_Request);
  Ln_IdEmpresaElemento := DB_INFRAESTRUCTURA.SEQ_INFO_EMPRESA_ELEMENTO.NEXTVAL;

  IF APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')         IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')             IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')         IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')        IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (elementoId,usrCreacion,ipCreacion,estado)';
    RAISE Le_Exception;
  END IF;

  Lv_Result                                       := '';
  Lr_InfoEmpresaElemento                          := NULL;
  Lr_InfoEmpresaElemento.ID_EMPRESA_ELEMENTO      := Ln_IdEmpresaElemento;
  Lr_InfoEmpresaElemento.EMPRESA_COD              := APEX_JSON.GET_VARCHAR2(P_PATH => 'empresaCod');
  Lr_InfoEmpresaElemento.ELEMENTO_ID              := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId');
  Lr_InfoEmpresaElemento.OBSERVACION              := APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion');
  Lr_InfoEmpresaElemento.FE_CREACION              := APEX_JSON.GET_VARCHAR2(P_PATH => 'feCreacion');
  Lr_InfoEmpresaElemento.USR_CREACION             := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion');
  Lr_InfoEmpresaElemento.IP_CREACION              := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion');
  Lr_InfoEmpresaElemento.ESTADO                   := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');
  INFRK_DML.INFRP_INSERT_EMPRESA_ELEMENTO(Lr_InfoEmpresaElemento, Lv_Result);
  Pv_Status             := 'OK';
  Pv_Mensaje            := 'Transación exitosa';
  Pn_IdEmpresaElemento  :=  Ln_IdEmpresaElemento;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := SUBSTR('P_GUARDAR_EMPRESA_ELEMENTO - Error: '||Lv_Mensaje, 0 , 3000 );
      Pn_IdEmpresaElemento :=  0;
    WHEN OTHERS THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    := SUBSTR('P_GUARDAR_EMPRESA_ELEMENTO - Error: '|| SQLERRM || ' - '||Lv_Result, 0 , 3000 );
      Pn_IdEmpresaElemento :=  0;

  END P_GUARDAR_EMPRESA_ELEMENTO;

  PROCEDURE P_ACTUALIZAR_EMPRESA_ELEMENTO(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteEmpresaElemento(Cn_IdEmpresaElemento NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO
      WHERE ID_EMPRESA_ELEMENTO = Cn_IdEmpresaElemento;

    --Variables Locales.
    Le_Exception              EXCEPTION;
    Lv_Mensaje                VARCHAR2(3000);
    Ln_IdEmpresaElemento      NUMBER;
    Ln_ExisteEmpresaElemento  NUMBER;

  BEGIN

    IF C_ExisteEmpresaElemento%ISOPEN THEN
      CLOSE C_ExisteEmpresaElemento;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdEmpresaElemento := APEX_JSON.GET_NUMBER(P_PATH => 'idEmpresaElemento');

    IF Ln_IdEmpresaElemento IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idEmpresaElemento)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteEmpresaElemento(Ln_IdEmpresaElemento);
      FETCH C_ExisteEmpresaElemento INTO Ln_ExisteEmpresaElemento;
    CLOSE C_ExisteEmpresaElemento;

    IF Ln_ExisteEmpresaElemento < 1 THEN
      Lv_Mensaje := 'No existe el empresa elemento para el id('||Ln_IdEmpresaElemento||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO
      SET EMPRESA_COD           = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'empresaCod')    , EMPRESA_COD),
          ELEMENTO_ID           = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'elementoId')    , ELEMENTO_ID),
          OBSERVACION           = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'observacion')   , OBSERVACION),
          ESTADO                = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')        , ESTADO)
    WHERE ID_EMPRESA_ELEMENTO   = Ln_IdEmpresaElemento;

    --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR('P_ACTUALIZAR_EMPRESA_ELEMENTO - Error: '|| Lv_Mensaje, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      := SUBSTR('P_ACTUALIZAR_EMPRESA_ELEMENTO - Error: '|| SQLERRM, 0 , 3000 );

  END P_ACTUALIZAR_EMPRESA_ELEMENTO;

  PROCEDURE P_GUARDAR_EMPRESA_ELEMENTO_UBI(Pcl_Request                 IN  CLOB,
                                           Pn_IdEmpresaElementoUbica   OUT NUMBER,
                                           Pv_Status                   OUT VARCHAR2,
                                           Pv_Mensaje                  OUT VARCHAR2) 
  IS

    Ln_IdEmpresaElementoUbica   NUMBER;
    Le_Exception                EXCEPTION;
    Lv_Mensaje                  VARCHAR2(3000);
    Lr_InfoEmpresaElementoUbica DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA%ROWTYPE;
    Lv_Result                   VARCHAR2(3000) := '';

  BEGIN

  --Parse del JSON
  APEX_JSON.PARSE(Pcl_Request);
  Ln_IdEmpresaElementoUbica := DB_INFRAESTRUCTURA.SEQ_INFO_EMPRESA_ELEMENTO_UBI.NEXTVAL;

  IF APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')         IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH   => 'empresaCod')         IS NULL OR
     APEX_JSON.GET_NUMBER(P_PATH   => 'ubicacionId')        IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')         IS NULL OR
     APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')        IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (elementoId,empresaCod,ubicacionId,usrCreacion,ipCreacion)';
    RAISE Le_Exception;
  END IF;

  Lv_Result                                                      := '';
  Lr_InfoEmpresaElementoUbica                                    := NULL;
  Lr_InfoEmpresaElementoUbica.ID_EMPRESA_ELEMENTO_UBICACION      := Ln_IdEmpresaElementoUbica;
  Lr_InfoEmpresaElementoUbica.EMPRESA_COD                        := APEX_JSON.GET_VARCHAR2(P_PATH => 'empresaCod');
  Lr_InfoEmpresaElementoUbica.ELEMENTO_ID                        := APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId');
  Lr_InfoEmpresaElementoUbica.UBICACION_ID                       := APEX_JSON.GET_NUMBER(P_PATH   => 'ubicacionId');
  Lr_InfoEmpresaElementoUbica.FE_CREACION                        := SYSDATE;
  Lr_InfoEmpresaElementoUbica.USR_CREACION                       := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion');
  Lr_InfoEmpresaElementoUbica.IP_CREACION                        := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion');
  INFRK_DML.INFRP_INSERT_EMPR_ELEMENT_UBIC(Lr_InfoEmpresaElementoUbica, Lv_Result);
  Pv_Status             := 'OK';
  Pv_Mensaje            := 'Transación exitosa';
  Pn_IdEmpresaElementoUbica  :=  Ln_IdEmpresaElementoUbica;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status                 := 'ERROR';
      Pv_Mensaje                := SUBSTR('P_GUARDAR_EMPRESA_ELEMENTO_UBICA - Error: '||Lv_Mensaje, 0 , 3000 );
      Pn_IdEmpresaElementoUbica :=  0;
    WHEN OTHERS THEN
      Pv_Status                 := 'ERROR';
      Pv_Mensaje                := SUBSTR('P_GUARDAR_EMPRESA_ELEMENTO_UBICA - Error: '|| SQLERRM || ' - '||Lv_Result, 0 , 3000 );
      Pn_IdEmpresaElementoUbica :=  0;

  END P_GUARDAR_EMPRESA_ELEMENTO_UBI;
----
----
END INKG_ELEMENTO_TRANSACCION;
/

