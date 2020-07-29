SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION AS

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_SERVICIO'.
   *
   * Método encargado de actualizar un registro en la 'INFO_SERVICIO' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_ACTUALIZAR_SERVICIO(Pcl_Request IN  CLOB,
                                  Pv_Status   OUT VARCHAR2,
                                  Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_SERVICIO_HISTORIAL'.
   *
   * Método encargado de guardar un registro en la 'INFO_SERVICIO_HISTORIAL' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request       IN  CLOB Recibe json request.
   * @param Pn_IdServicioHist OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status         OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_SERVICIO_HISTORIAL(Pcl_Request       IN  CLOB,
                                         Pn_IdServicioHist OUT NUMBER,
                                         Pv_Status         OUT VARCHAR2,
                                         Pv_Mensaje        OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_SERVICIO_TECNICO'.
   *
   * Método encargado de guardar un registro en la 'INFO_SERVICIO_TECNICO' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request       IN  CLOB Recibe json request.
   * @param Pn_IdServicioTecn OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status         OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_SERVICIO_TECNICO(Pcl_Request       IN  CLOB,
                                       Pn_IdServicioTecn OUT NUMBER,
                                       Pv_Status         OUT VARCHAR2,
                                       Pv_Mensaje        OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_SERVICIO_PROD_CARACT'
   *
   * Método encargado de guardar un registro en la 'INFO_SERVICIO_PROD_CARACT' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request         IN  CLOB Recibe json request
   * @param Pn_IdServicioCaract OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status           OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje          OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_SERVICIO_PROD_CARACT(Pcl_Request         IN  CLOB,
                                           Pn_IdServicioCaract OUT NUMBER,
                                           Pv_Status           OUT VARCHAR2,
                                           Pv_Mensaje          OUT VARCHAR2);

END CMKG_SERVICIO_TRANSACCION;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION AS
----
----
  PROCEDURE P_ACTUALIZAR_SERVICIO(Pcl_Request IN  CLOB,
                                  Pv_Status   OUT VARCHAR2,
                                  Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteServicio(Cn_IdServicio NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE ID_SERVICIO = Cn_IdServicio;

    --Variables Locales.
    Lv_Mensaje         VARCHAR2(3000);
    Le_Exception       EXCEPTION;
    Ln_IdServicio      NUMBER;
    Ln_ExisteServicio  NUMBER;

  BEGIN

    IF C_ExisteServicio%ISOPEN THEN
      CLOSE C_ExisteServicio;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdServicio := APEX_JSON.GET_NUMBER(P_PATH => 'idServicio');

    --Validación.
    IF Ln_IdServicio IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idServicio).';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteServicio(Ln_IdServicio);
      FETCH C_ExisteServicio INTO Ln_ExisteServicio;
    CLOSE C_ExisteServicio;

    IF Ln_ExisteServicio < 1 THEN
      Lv_Mensaje := 'No existe el servicio con el id('||Ln_IdServicio||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SERVICIO
      SET PUNTO_ID     = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'puntoId') , PUNTO_ID),
          ESTADO       = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')  , ESTADO)
    WHERE ID_SERVICIO = Ln_IdServicio;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_SERVICIO;
----
----
  PROCEDURE P_GUARDAR_SERVICIO_HISTORIAL(Pcl_Request       IN  CLOB,
                                         Pn_IdServicioHist OUT NUMBER,
                                         Pv_Status         OUT VARCHAR2,
                                         Pv_Mensaje        OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdServicioHist  NUMBER;
    Le_Exception       EXCEPTION;
    Lv_Mensaje         VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId')  IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')      IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')  IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (servicioId,observacion,estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el secuencial.
    Ln_IdServicioHist := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;

    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (
      ID_SERVICIO_HISTORIAL,
      SERVICIO_ID,
      MOTIVO_ID,
      OBSERVACION,
      ACCION,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FE_CREACION
    ) VALUES (
      Ln_IdServicioHist,
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'motivoId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'accion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      SYSDATE
    );

    --Respuesta Exitosa.
    Pv_Status         := 'OK';
    Pv_Mensaje        := 'Transación exitosa';
    Pn_IdServicioHist :=  Ln_IdServicioHist;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdServicioHist :=  0;
    WHEN OTHERS THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdServicioHist :=  0;

  END P_GUARDAR_SERVICIO_HISTORIAL;
----
----
  PROCEDURE P_GUARDAR_SERVICIO_TECNICO(Pcl_Request       IN  CLOB,
                                       Pn_IdServicioTecn OUT NUMBER,
                                       Pv_Status         OUT VARCHAR2,
                                       Pv_Mensaje        OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdServicioTecn  NUMBER;
    Le_Exception       EXCEPTION;
    Lv_Mensaje         VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_NUMBER(P_PATH => 'servicioId') IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (servicioId)';
      RAISE Le_Exception;
    END IF;

    IF APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')           IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'interfaceElementoId')  IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'elementoClienteId')    IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'interfaceElementoClienteId') IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'ultimaMillaId')        IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'tercerizadoraId')      IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'elementoContenedorId') IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'elementoConectorId')   IS NULL AND
       APEX_JSON.GET_NUMBER(P_PATH   => 'interfaceElementoConectorId') IS NULL AND
       APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoEnlace') IS NULL THEN
      Lv_Mensaje := 'Verificar la información, se ha obtenido todo los valores nulos a excepción del id del servicio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el secuencial.
    Ln_IdServicioTecn := DB_COMERCIAL.SEQ_INFO_SERVICIO_TECNICO.NEXTVAL;

    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_TECNICO (
      ID_SERVICIO_TECNICO,
      SERVICIO_ID,
      ELEMENTO_ID,
      INTERFACE_ELEMENTO_ID,
      ELEMENTO_CLIENTE_ID,
      INTERFACE_ELEMENTO_CLIENTE_ID,
      ULTIMA_MILLA_ID,
      TERCERIZADORA_ID,
      ELEMENTO_CONTENEDOR_ID,
      ELEMENTO_CONECTOR_ID,
      INTERFACE_ELEMENTO_CONECTOR_ID,
      TIPO_ENLACE
    ) VALUES (
      Ln_IdServicioTecn,
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'interfaceElementoId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'elementoClienteId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'interfaceElementoClienteId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'ultimaMillaId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'tercerizadoraId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'elementoContenedorId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'elementoConectorId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'interfaceElementoConectorId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoEnlace')
    );

    --Respuesta Exitosa.
    Pv_Status         := 'OK';
    Pv_Mensaje        := 'Transación exitosa';
    Pn_IdServicioTecn :=  Ln_IdServicioTecn;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdServicioTecn :=  0;
    WHEN OTHERS THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdServicioTecn :=  0;

  END P_GUARDAR_SERVICIO_TECNICO;
----
----
  PROCEDURE P_GUARDAR_SERVICIO_PROD_CARACT(Pcl_Request         IN  CLOB,
                                           Pn_IdServicioCaract OUT NUMBER,
                                           Pv_Status           OUT VARCHAR2,
                                           Pv_Mensaje          OUT VARCHAR2)
  IS

    Ln_IdServicioCaract  NUMBER;
    Le_Exception         EXCEPTION;
    Lv_Mensaje           VARCHAR2(3000);

  BEGIN

    --Parse del JSON
    APEX_JSON.PARSE(Pcl_Request);

    IF APEX_JSON.GET_NUMBER(P_PATH    => 'servicioId')                IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH    => 'productoCaracteristicaId')  IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH  => 'valor')                     IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')                    IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH  => 'usrCreacion')               IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (servicioId,productoCaracteristicaId,valor,estado,usrCreacion)';
      RAISE Le_Exception;
    END IF;

    Ln_idServicioCaract := DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL;

    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT (
      ID_SERVICIO_PROD_CARACT,
      SERVICIO_ID,
      PRODUCTO_CARACTERISITICA_ID,
      REF_SERVICIO_PROD_CARACT_ID,
      VALOR,
      ESTADO,
      USR_CREACION,
      FE_CREACION
    ) VALUES (
      Ln_idServicioCaract,
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'productoCaracteristicaId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'refServicioProdCaractId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'valor'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      SYSDATE
    );

    Pv_Status           := 'OK';
    Pv_Mensaje          := 'Transación exitosa';
    Pn_IdServicioCaract :=  Ln_idServicioCaract;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status           := 'ERROR';
      Pv_Mensaje          :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdServicioCaract :=  0;
    WHEN OTHERS THEN
      Pv_Status           := 'ERROR';
      Pv_Mensaje          :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdServicioCaract :=  0;

  END P_GUARDAR_SERVICIO_PROD_CARACT;
----
----
END CMKG_SERVICIO_TRANSACCION;
/
