SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION AS

  /**
   * Documentación para el procedimiento 'P_ELIMINAR_SERVICIOS_SOLUCION'.
   *
   * Método encargado de eliminar los servicios de una solución.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 08-07-2020
   */
  PROCEDURE P_ELIMINAR_SERVICIOS_SOLUCION(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_SOLUCION_CAB'.
   *
   * Método encargado de guardar un registro en la 'INFO_SOLUCION_CAB' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request       IN  CLOB Recibe json request.
   * @param Pn_IdSolucionCab  OUT NUMBER Retorna el id del registro creado.
   * @param Pn_NumeroSolucion OUT NUMBER Retorna el numero de solución.
   * @param Pv_Status         OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_SOLUCION_CAB(Pcl_Request       IN  CLOB,
                                   Pn_IdSolucionCab  OUT NUMBER,
                                   Pn_NumeroSolucion OUT NUMBER,
                                   Pv_Status         OUT VARCHAR2,
                                   Pv_Mensaje        OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_SOLUCION_CAB'.
   *
   * Método encargado de actualizar un registro en la 'INFO_SOLUCION_CAB' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_ACTUALIZAR_SOLUCION_CAB(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_SOLUCION_DET'.
   *
   * Método encargado de guardar un registro en la 'INFO_SOLUCION_DET' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request      IN  CLOB Recibe json request.
   * @param Pn_IdSolucionDet OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status        OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje       OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_SOLUCION_DET(Pcl_Request      IN  CLOB,
                                   Pn_IdSolucionDet OUT NUMBER,
                                   Pv_Status        OUT VARCHAR2,
                                   Pv_Mensaje       OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_SOLUCION_DET'.
   *
   * Método encargado de actualizar un registro en la 'INFO_SOLUCION_DET' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_ACTUALIZAR_SOLUCION_DET(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_SOLUCION_REF'.
   *
   * Método encargado de guardar un registro en la 'INFO_SOLUCION_REFERENCIA' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request      IN  CLOB Recibe json request.
   * @param Pn_IdSolucionRef OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status        OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje       OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_SOLUCION_REF(Pcl_Request      IN  CLOB,
                                   Pn_IdSolucionRef OUT NUMBER,
                                   Pv_Status        OUT VARCHAR2,
                                   Pv_Mensaje       OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_SOLUCION_REF'.
   *
   * Método encargado de actualizar un registro en la 'INFO_SOLUCION_REFERENCIA' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_ACTUALIZAR_SOLUCION_REF(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_RECURSO_CAB'.
   *
   * Método encargado de guardar un registro en la 'INFO_SERVICIO_RECURSO_CAB' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request     IN  CLOB Recibe json request.
   * @param Pn_IdRecursoCab OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status       OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje      OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_RECURSO_CAB(Pcl_Request     IN  CLOB,
                                  Pn_IdRecursoCab OUT NUMBER,
                                  Pv_Status       OUT VARCHAR2,
                                  Pv_Mensaje      OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_RECURSO_CAB'.
   *
   * Método encargado de actualizar un registro en la 'INFO_SERVICIO_RECURSO_CAB' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_ACTUALIZAR_RECURSO_CAB(Pcl_Request IN  CLOB,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_RECURSO_DET'.
   *
   * Método encargado de guardar un registro en la 'INFO_SERVICIO_RECURSO_DET' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request     IN  CLOB Recibe json request.
   * @param Pn_IdRecursoDet OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status       OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje      OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_GUARDAR_RECURSO_DET(Pcl_Request     IN  CLOB,
                                  Pn_IdRecursoDet OUT NUMBER,
                                  Pv_Status       OUT VARCHAR2,
                                  Pv_Mensaje      OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_RECURSO_DET'.
   *
   * Método encargado de actualizar un registro en la 'INFO_SERVICIO_RECURSO_DET' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 30-04-2020
   */
  PROCEDURE P_ACTUALIZAR_RECURSO_DET(Pcl_Request IN  CLOB,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2);

END CMKG_SOLUCIONES_TRANSACCION;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION AS
----
----
  PROCEDURE P_ELIMINAR_SERVICIOS_SOLUCION(Pcl_Request IN  CLOB,
                                          Pv_Status   OUT VARCHAR2,
                                          Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_ObtenerServicioSolucion(Cn_IdServicio NUMBER)
    IS
      SELECT ISDET.*
        FROM DB_COMERCIAL.INFO_SOLUCION_DET ISDET
      WHERE ISDET.SERVICIO_ID =  Cn_IdServicio
        AND ISDET.ESTADO      = 'Activo';

    CURSOR C_ObtenerRecursoSolucion(Cn_IdServicio NUMBER)
    IS
      SELECT ISRCAB.*
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB ISRCAB
      WHERE ISRCAB.SERVICIO_ID =  Cn_IdServicio
        AND ISRCAB.ESTADO      = 'Activo';

    CURSOR C_TotalServiciosSolucion(Cn_NumeroSolucion NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SOLUCION_CAB ISCAB,
             DB_COMERCIAL.INFO_SOLUCION_DET ISDET
      WHERE ISCAB.ID_SOLUCION_CAB =  ISDET.SOLUCION_CAB_ID
        AND ISCAB.ESTADO          = 'Activo'
        AND ISDET.ESTADO          = 'Activo';

    Lt_JsonIndex                APEX_JSON.T_VALUES;
    Le_Exception                EXCEPTION;
    Lv_Status                   VARCHAR2(50);
    Lv_Mensaje                  VARCHAR2(3000);
    Lb_HabilitaCommit           BOOLEAN;
    Lv_UsrUltMod                VARCHAR2(30);
    Lv_IpUltMod                 VARCHAR2(30);
    Lcl_Request                 CLOB;
    Ln_TotalServicios           NUMBER;
    Ln_IdServicio               NUMBER;
    Ln_NumeroSolucion           NUMBER;
    Lc_ObtenerServicioSolucion  C_ObtenerServicioSolucion%ROWTYPE;
    Lv_Estado                   VARCHAR2(30) := 'Eliminado';

  BEGIN

    IF C_ObtenerServicioSolucion%ISOPEN THEN
      CLOSE C_ObtenerServicioSolucion;
    END IF;

    IF C_ObtenerRecursoSolucion%ISOPEN THEN
      CLOSE C_ObtenerRecursoSolucion;
    END IF;

    IF C_TotalServiciosSolucion%ISOPEN THEN
      CLOSE C_TotalServiciosSolucion;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    --Datos Principales
    Lb_HabilitaCommit := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);
    Lv_UsrUltMod      := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'    , P_VALUES => Lt_JsonIndex);
    Lv_IpUltMod       := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'     , P_VALUES => Lt_JsonIndex);
    Ln_NumeroSolucion := APEX_JSON.GET_NUMBER(P_PATH   => 'numeroSolucion' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Obtenemos el total de los servicios.
    Ln_TotalServicios := APEX_JSON.GET_COUNT(P_PATH => 'servicios', P_VALUES => Lt_JsonIndex);

    IF Ln_TotalServicios < 1 OR Ln_TotalServicios IS NULL THEN
      Lv_Mensaje := 'El atributo servicios se encuentra vacio o no existe en el jsonRequest.';
      RAISE Le_Exception;
    END IF;

    FOR i in 1..Ln_TotalServicios LOOP

      Ln_IdServicio := APEX_JSON.GET_NUMBER(P_PATH => 'servicios[%d]', p0 => i, P_VALUES => Lt_JsonIndex);

      OPEN C_ObtenerServicioSolucion(Ln_IdServicio);
        FETCH C_ObtenerServicioSolucion INTO Lc_ObtenerServicioSolucion;
      CLOSE C_ObtenerServicioSolucion;

      --Eliminamos el detalle de la solución.
      UPDATE DB_COMERCIAL.INFO_SOLUCION_DET
        SET ESTADO      = Lv_Estado,
            IP_ULT_MOD  = Lv_IpUltMod,
            USR_ULT_MOD = Lv_UsrUltMod,
            FEC_ULT_MOD = SYSDATE
      WHERE SERVICIO_ID = Ln_IdServicio;

      --Eliminamos la referencia de la solución.
      IF Lc_ObtenerServicioSolucion.ES_PREFERENCIAL = 'SI' THEN
        UPDATE DB_COMERCIAL.INFO_SOLUCION_REFERENCIA
          SET ESTADO      = Lv_Estado,
              IP_ULT_MOD  = Lv_IpUltMod,
              USR_ULT_MOD = Lv_UsrUltMod,
              FEC_ULT_MOD = SYSDATE
        WHERE SOLUCION_DET_ID_A = Lc_ObtenerServicioSolucion.ID_SOLUCION_DET;
      ELSE
        UPDATE DB_COMERCIAL.INFO_SOLUCION_REFERENCIA
          SET ESTADO      = Lv_Estado,
              IP_ULT_MOD  = Lv_IpUltMod,
              USR_ULT_MOD = Lv_UsrUltMod,
              FEC_ULT_MOD = SYSDATE
        WHERE SOLUCION_DET_ID_B = Lc_ObtenerServicioSolucion.ID_SOLUCION_DET;
      END IF;

      --Eliminamos la cabecera del recurso.
      UPDATE DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB
        SET ESTADO      = Lv_Estado,
            IP_ULT_MOD  = Lv_IpUltMod,
            USR_ULT_MOD = Lv_UsrUltMod,
            FEC_ULT_MOD = SYSDATE
      WHERE SERVICIO_ID = Ln_IdServicio;

      --Eliminamos el detalle de los recursos.
      FOR Recurso IN C_ObtenerRecursoSolucion(Ln_IdServicio) LOOP
        UPDATE DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET
          SET ESTADO      = Lv_Estado,
              IP_ULT_MOD  = Lv_IpUltMod,
              USR_ULT_MOD = Lv_UsrUltMod,
              FEC_ULT_MOD = SYSDATE
        WHERE SERVICIO_RECURSO_CAB_ID = Recurso.ID_SERVICIO_RECURSO_CAB;
      END LOOP;

    END LOOP;

    OPEN C_TotalServiciosSolucion(Ln_NumeroSolucion);
      FETCH C_TotalServiciosSolucion INTO Ln_TotalServicios;
    CLOSE C_TotalServiciosSolucion;

    --Si no se encuentra ningún servicio Activo en la solución
    --procedemos a eliminar la cabecera.
    IF Ln_TotalServicios < 1 THEN
      UPDATE DB_COMERCIAL.INFO_SOLUCION_CAB
          SET ESTADO      = Lv_Estado,
              IP_ULT_MOD  = Lv_IpUltMod,
              USR_ULT_MOD = Lv_UsrUltMod,
              FEC_ULT_MOD = SYSDATE
        WHERE NUMERO_SOLUCION = Ln_NumeroSolucion;
    END IF;

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ELIMINAR_SERVICIOS_SOLUCION;
----
----
  PROCEDURE P_GUARDAR_SOLUCION_CAB(Pcl_Request       IN  CLOB,
                                   Pn_IdSolucionCab  OUT NUMBER,
                                   Pn_NumeroSolucion OUT NUMBER,
                                   Pv_Status         OUT VARCHAR2,
                                   Pv_Mensaje        OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdSolucionCab  NUMBER;
    Ln_NumeroSolucion NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_NUMBER(P_PATH   => 'puntoId')        IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'nombreSolucion') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')         IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')    IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')     IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (puntoId,nombreSolucion,estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el secuencial.
    Ln_IdSolucionCab  := DB_COMERCIAL.SEQ_INFO_SOLUCION_CAB.NEXTVAL;
    --Número de solución
    Ln_NumeroSolucion := DB_COMERCIAL.SEQ_GRUPO_PRODUCTO.NEXTVAL;

    --Insert de la tabla.
    INSERT INTO DB_COMERCIAL.INFO_SOLUCION_CAB (
      ID_SOLUCION_CAB,
      NUMERO_SOLUCION,
      NOMBRE_SOLUCION,
      PUNTO_ID,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FEC_CREACION
    ) VALUES (
      Ln_IdSolucionCab,
      Ln_NumeroSolucion,
      APEX_JSON.GET_VARCHAR2(P_PATH => 'nombreSolucion'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'puntoId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      SYSDATE
    );

    --Respuesta Exitosa.
    Pv_Status         := 'OK';
    Pv_Mensaje        := 'Transación exitosa';
    Pn_IdSolucionCab  :=  Ln_IdSolucionCab;
    Pn_NumeroSolucion :=  Ln_NumeroSolucion;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolucionCab  :=  0;
      Pn_NumeroSolucion :=  0;
    WHEN OTHERS THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolucionCab  :=  0;
      Pn_NumeroSolucion :=  0;

  END P_GUARDAR_SOLUCION_CAB;
----
----
  PROCEDURE P_ACTUALIZAR_SOLUCION_CAB(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteSolucionCab(Cn_IdSolucionCab NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SOLUCION_CAB
      WHERE ID_SOLUCION_CAB = Cn_IdSolucionCab;

    --Variables Locales.
    Lv_Mensaje            VARCHAR2(3000);
    Le_Exception          EXCEPTION;
    Ln_IdSolucionCab      NUMBER;
    Ln_ExisteSolucionCab  NUMBER;

  BEGIN

    IF C_ExisteSolucionCab%ISOPEN THEN
      CLOSE C_ExisteSolucionCab;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdSolucionCab := APEX_JSON.GET_NUMBER(P_PATH => 'idSolucionCab');

    --Validación.
    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')  IS NULL OR
       Ln_IdSolucionCab IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idSolucionCab,usrUltMod,ipUltMod)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteSolucionCab(Ln_IdSolucionCab);
      FETCH C_ExisteSolucionCab INTO Ln_ExisteSolucionCab;
    CLOSE C_ExisteSolucionCab;

    IF Ln_ExisteSolucionCab < 1 THEN
      Lv_Mensaje := 'No existe la solución con el id('||Ln_IdSolucionCab||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SOLUCION_CAB
      SET PUNTO_ID        = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'puntoId')        , PUNTO_ID),
          NUMERO_SOLUCION = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'numeroSolucion') , NUMERO_SOLUCION),
          NOMBRE_SOLUCION = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'nombreSolucion') , NOMBRE_SOLUCION),
          ESTADO          = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')         , ESTADO),
          USR_ULT_MOD     = APEX_JSON.GET_VARCHAR2(P_PATH     => 'usrUltMod'),
          IP_ULT_MOD      = APEX_JSON.GET_VARCHAR2(P_PATH     => 'ipUltMod'),
          FEC_ULT_MOD     = SYSDATE
    WHERE ID_SOLUCION_CAB = Ln_IdSolucionCab;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_SOLUCION_CAB;
----
----
  PROCEDURE P_GUARDAR_SOLUCION_DET(Pcl_Request      IN  CLOB,
                                   Pn_IdSolucionDet OUT NUMBER,
                                   Pv_Status        OUT VARCHAR2,
                                   Pv_Mensaje       OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdSolucionDet  NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_NUMBER(P_PATH   => 'solucionCabId') IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId')    IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')        IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')   IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')    IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (solucionCabId,servicioId,estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el secuencial.
    Ln_IdSolucionDet := DB_COMERCIAL.SEQ_INFO_SOLUCION_DET.NEXTVAL;

    --Insert a la tabla.
    INSERT INTO DB_COMERCIAL.INFO_SOLUCION_DET (
      ID_SOLUCION_DET,
      SOLUCION_CAB_ID,
      SERVICIO_ID,
      TIPO_SOLUCION,
      DESCRIPCION,
      ES_CORE,
      ES_PREFERENCIAL,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FEC_CREACION
    ) VALUES (
      Ln_IdSolucionDet,
      APEX_JSON.GET_NUMBER(P_PATH   => 'solucionCabId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoSolucion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'descripcion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'esCore'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'esPreferencial'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      SYSDATE
    );

    Pv_Status        := 'OK';
    Pv_Mensaje       := 'Transación exitosa';
    Pn_IdSolucionDet :=  Ln_IdSolucionDet;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status        := 'ERROR';
      Pv_Mensaje       :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolucionDet :=  0;
    WHEN OTHERS THEN
      Pv_Status        := 'ERROR';
      Pv_Mensaje       :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolucionDet :=  0;

  END P_GUARDAR_SOLUCION_DET;
----
----
  PROCEDURE P_ACTUALIZAR_SOLUCION_DET(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_ExisteSolucionDet(Cn_IdSolucionDet NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SOLUCION_DET
      WHERE ID_SOLUCION_DET = Cn_IdSolucionDet;

    --Variables Locales.
    Lv_Mensaje            VARCHAR2(3000);
    Le_Exception          EXCEPTION;
    Ln_IdSolucionDet      NUMBER;
    Ln_ExisteSolucionDet  NUMBER;

  BEGIN

    IF C_ExisteSolucionDet%ISOPEN THEN
      CLOSE C_ExisteSolucionDet;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdSolucionDet := APEX_JSON.GET_NUMBER(P_PATH => 'idSolucionDet');

    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')  IS NULL OR
       Ln_IdSolucionDet IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idSolucionDet,usrUltMod,ipUltMod)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteSolucionDet(Ln_IdSolucionDet);
      FETCH C_ExisteSolucionDet INTO Ln_ExisteSolucionDet;
    CLOSE C_ExisteSolucionDet;

    IF Ln_ExisteSolucionDet < 1 THEN
      Lv_Mensaje := 'No existe el detalle de solución para el id('||Ln_IdSolucionDet||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SOLUCION_DET
      SET SOLUCION_CAB_ID = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'solucionCabId')  , SOLUCION_CAB_ID),
          SERVICIO_ID     = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'servicioId')     , SERVICIO_ID),
          TIPO_SOLUCION   = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoSolucion')   , TIPO_SOLUCION),
          DESCRIPCION     = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'descripcion')    , DESCRIPCION),
          ES_CORE         = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'esCore')         , ES_CORE),
          ES_PREFERENCIAL = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'esPreferencial') , ES_PREFERENCIAL),
          ESTADO          = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')         , ESTADO),
          USR_ULT_MOD     = APEX_JSON.GET_VARCHAR2(P_PATH      => 'usrUltMod'),
          IP_ULT_MOD      = APEX_JSON.GET_VARCHAR2(P_PATH      => 'ipUltMod'),
          FEC_ULT_MOD     = SYSDATE
    WHERE ID_SOLUCION_DET = Ln_IdSolucionDet;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_SOLUCION_DET;
----
----
  PROCEDURE P_GUARDAR_SOLUCION_REF(Pcl_Request      IN  CLOB,
                                   Pn_IdSolucionRef OUT NUMBER,
                                   Pv_Status        OUT VARCHAR2,
                                   Pv_Mensaje       OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdSolucionRef  NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_NUMBER(P_PATH   => 'solucionDetIdA') IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH   => 'solucionDetIdB') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')         IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')    IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')     IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (solucionDetIdA,solucionDetIdB,estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    -- Obtenemos el secuencial.
    Ln_IdSolucionRef := DB_COMERCIAL.SEQ_INFO_SOLUCION_REFERENCIA.NEXTVAL;

    --Insert de la tabla.
    INSERT INTO DB_COMERCIAL.INFO_SOLUCION_REFERENCIA (
      ID_SOLUCION_REFERENCIA,
      SOLUCION_DET_ID_A,
      SOLUCION_DET_ID_B,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FEC_CREACION
    ) VALUES (
      Ln_IdSolucionRef,
      APEX_JSON.GET_NUMBER(P_PATH   => 'solucionDetIdA'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'solucionDetIdB'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      SYSDATE
    );

    --Respuesta Exitosa.
    Pv_Status        := 'OK';
    Pv_Mensaje       := 'Transación exitosa';
    Pn_IdSolucionRef :=  Ln_IdSolucionRef;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status        := 'ERROR';
      Pv_Mensaje       :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolucionRef :=  0;
    WHEN OTHERS THEN
      Pv_Status        := 'ERROR';
      Pv_Mensaje       :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolucionRef :=  0;

  END P_GUARDAR_SOLUCION_REF;
----
----
  PROCEDURE P_ACTUALIZAR_SOLUCION_REF(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteSolucionRef(Cn_IdSolucionRef NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SOLUCION_REFERENCIA
      WHERE ID_SOLUCION_REFERENCIA = Cn_IdSolucionRef;

    --Variables Locales.
    Lv_Mensaje            VARCHAR2(3000);
    Le_Exception          EXCEPTION;
    Ln_IdSolucionRef      NUMBER;
    Ln_ExisteSolucionRef  NUMBER;

  BEGIN

    IF C_ExisteSolucionRef%ISOPEN THEN
      CLOSE C_ExisteSolucionRef;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdSolucionRef := APEX_JSON.GET_NUMBER(P_PATH => 'idSolucionReferencia');

    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')  IS NULL OR
       Ln_IdSolucionRef IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idSolucionReferencia,usrUltMod,ipUltMod)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteSolucionRef(Ln_IdSolucionRef);
      FETCH C_ExisteSolucionRef INTO Ln_ExisteSolucionRef;
    CLOSE C_ExisteSolucionRef;

    IF Ln_ExisteSolucionRef < 1 THEN
      Lv_Mensaje := 'No existe la referencia de solución para el id('||Ln_IdSolucionRef||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SOLUCION_REFERENCIA
      SET SOLUCION_DET_ID_A = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'solucionDetIdA') , SOLUCION_DET_ID_A),
          SOLUCION_DET_ID_B = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'solucionDetIdB') , SOLUCION_DET_ID_B),
          ESTADO            = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')         , ESTADO),
          USR_ULT_MOD       = APEX_JSON.GET_VARCHAR2(P_PATH      => 'usrUltMod'),
          IP_ULT_MOD        = APEX_JSON.GET_VARCHAR2(P_PATH      => 'ipUltMod'),
          FEC_ULT_MOD       = SYSDATE
    WHERE ID_SOLUCION_REFERENCIA = Ln_IdSolucionRef;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_SOLUCION_REF;
----
----
  PROCEDURE P_GUARDAR_RECURSO_CAB(Pcl_Request     IN  CLOB,
                                  Pn_IdRecursoCab OUT NUMBER,
                                  Pv_Status       OUT VARCHAR2,
                                  Pv_Mensaje      OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdRecursoCab  NUMBER;
    Le_Exception     EXCEPTION;
    Lv_Mensaje       VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoRecurso')        IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'descripcionRecurso') IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId')         IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH   => 'cantidad')           IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')             IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')        IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')         IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (tipoRecurso,descripcionRecurso,servicioId,cantidad,'||
                                                'estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el secuencial.
    Ln_IdRecursoCab := DB_COMERCIAL.SEQ_INFO_SERVICIO_RECURSO_CAB.NEXTVAL;

    --Insert de la tabla.
    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB (
      ID_SERVICIO_RECURSO_CAB,
      TIPO_RECURSO,
      DESCRIPCION_RECURSO,
      SERVICIO_ID,
      SOLICITUD_ID,
      CANTIDAD,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FEC_CREACION
    ) VALUES (
      Ln_IdRecursoCab,
      APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoRecurso'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'descripcionRecurso'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'solicitudId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'cantidad'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      SYSDATE
    );

    --Respuesta Exitosa.
    Pv_Status       := 'OK';
    Pv_Mensaje      := 'Transación exitosa';
    Pn_IdRecursoCab :=  Ln_IdRecursoCab;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdRecursoCab :=  0;
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdRecursoCab :=  0;

  END P_GUARDAR_RECURSO_CAB;
----
----
  PROCEDURE P_ACTUALIZAR_RECURSO_CAB(Pcl_Request IN  CLOB,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteRecursoCab(Cn_IdRecursoCab NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB
      WHERE ID_SERVICIO_RECURSO_CAB = Cn_IdRecursoCab;

    --Variables Locales.
    Le_Exception         EXCEPTION;
    Lv_Mensaje           VARCHAR2(3000);
    Ln_IdRecursoCab      NUMBER;
    Ln_ExisteRecursoCab  NUMBER;

  BEGIN

    IF C_ExisteRecursoCab%ISOPEN THEN
      CLOSE C_ExisteRecursoCab;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdRecursoCab := APEX_JSON.GET_NUMBER(P_PATH => 'idServicioRecursoCab');

    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')  IS NULL OR
       Ln_IdRecursoCab IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idServicioRecursoCab,usrUltMod,ipUltMod)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteRecursoCab(Ln_IdRecursoCab);
      FETCH C_ExisteRecursoCab INTO Ln_ExisteRecursoCab;
    CLOSE C_ExisteRecursoCab;

    IF Ln_ExisteRecursoCab < 1 THEN
      Lv_Mensaje := 'No existe el servicio recurso cab para el id('||Ln_IdRecursoCab||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB
      SET TIPO_RECURSO        = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoRecurso')        , TIPO_RECURSO),
          DESCRIPCION_RECURSO = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'descripcionRecurso') , DESCRIPCION_RECURSO),
          SERVICIO_ID         = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'servicioId')         , SERVICIO_ID),
          SOLICITUD_ID        = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'solicitudId')        , SOLICITUD_ID),
          CANTIDAD            = NVL(APEX_JSON.GET_NUMBER(P_PATH    => 'cantidad')           , CANTIDAD),
          ESTADO              = NVL(APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')             , ESTADO),
          USR_ULT_MOD         = APEX_JSON.GET_VARCHAR2(P_PATH      => 'usrUltMod'),
          IP_ULT_MOD          = APEX_JSON.GET_VARCHAR2(P_PATH      => 'ipUltMod'),
          FEC_ULT_MOD         = SYSDATE
    WHERE ID_SERVICIO_RECURSO_CAB = Ln_IdRecursoCab;

    --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_RECURSO_CAB;
----
----
  PROCEDURE P_GUARDAR_RECURSO_DET(Pcl_Request     IN  CLOB,
                                  Pn_IdRecursoDet OUT NUMBER,
                                  Pv_Status       OUT VARCHAR2,
                                  Pv_Mensaje      OUT VARCHAR2)
  IS

    --Variables Locales.
    Ln_IdRecursoDet  NUMBER;
    Le_Exception     EXCEPTION;
    Lv_Mensaje       VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    --Validación.
    IF APEX_JSON.GET_NUMBER(P_PATH   => 'servicioRecursoCabId') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')               IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')          IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')           IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (servicioRecursoCabId,estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    --Obtenemos el secuencial.
    Ln_IdRecursoDet := DB_COMERCIAL.SEQ_INFO_SERVICIO_RECURSO_DET.NEXTVAL;

    --Insert de la tabla.
    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET (
      ID_SERVICIO_RECURSO_DET,
      SERVICIO_RECURSO_CAB_ID,
      ELEMENTO_ID,
      CANTIDAD,
      REF_RECURSO_DET_ID,
      DESCRIPCION,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FEC_CREACION
    ) VALUES (
      Ln_IdRecursoDet,
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioRecursoCabId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'cantidad'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'refRecursoDetId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'descripcion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      SYSDATE
    );

    --Respuesta Exitosa.
    Pv_Status       := 'OK';
    Pv_Mensaje      := 'Transación exitosa';
    Pn_IdRecursoDet :=  Ln_IdRecursoDet;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdRecursoDet :=  0;
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdRecursoDet :=  0;

  END P_GUARDAR_RECURSO_DET;
----
----
  PROCEDURE P_ACTUALIZAR_RECURSO_DET(Pcl_Request IN  CLOB,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteRecursoDet(Cn_IdRecursoDet NUMBER,
                              Cn_RecursoCabId NUMBER,
                              Cn_ElementoId   NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET
      WHERE ID_SERVICIO_RECURSO_DET = Cn_IdRecursoDet
        OR  SERVICIO_RECURSO_CAB_ID = Cn_RecursoCabId
        OR  ELEMENTO_ID = Cn_ElementoId;

    --Variables Locales.
    Le_Exception         EXCEPTION;
    Lv_Mensaje           VARCHAR2(3000);
    Ln_IdRecursoDet      NUMBER;
    Ln_IdRecursoCab      NUMBER;
    Ln_IdElemento        NUMBER;
    Ln_ExisteRecursoDet  NUMBER;

  BEGIN

    IF C_ExisteRecursoDet%ISOPEN THEN
      CLOSE C_ExisteRecursoDet;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdRecursoDet := APEX_JSON.GET_NUMBER(P_PATH => 'idServicioRecursoDet');
    Ln_IdRecursoCab := APEX_JSON.GET_NUMBER(P_PATH => 'servicioRecursoCabId');
    Ln_IdElemento   := APEX_JSON.GET_NUMBER(P_PATH => 'elementoId');


    IF APEX_JSON.GET_VARCHAR2(P_PATH => 'usrUltMod') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipUltMod')  IS NULL OR
       (Ln_IdRecursoDet IS NULL AND Ln_IdRecursoCab IS NULL AND Ln_IdElemento IS NULL) THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo [(idServicioRecursoDet o servicioRecursoCabId o elementoId),usrUltMod,ipUltMod)'||Pcl_Request;
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteRecursoDet(Ln_IdRecursoDet,Ln_IdRecursoCab,Ln_IdElemento);
      FETCH C_ExisteRecursoDet INTO Ln_ExisteRecursoDet;
    CLOSE C_ExisteRecursoDet;

    IF Ln_ExisteRecursoDet < 1 THEN
      Lv_Mensaje := 'No existe el detalle del recurso para para el id('||Ln_IdRecursoDet||') '||
                    'o para el recurso cab id('||Ln_IdRecursoCab||') '||
                    'o para el recurso elemento id('||Ln_IdElemento||') ';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET
      SET SERVICIO_RECURSO_CAB_ID = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'servicioRecursoCabId') , SERVICIO_RECURSO_CAB_ID),
          ELEMENTO_ID             = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')           , ELEMENTO_ID),
          CANTIDAD                = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'cantidad')             , CANTIDAD),
          REF_RECURSO_DET_ID      = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'refRecursoDetId')      , REF_RECURSO_DET_ID),
          DESCRIPCION             = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'descripcion')          , DESCRIPCION),
          ESTADO                  = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')               , ESTADO),
          USR_ULT_MOD             = APEX_JSON.GET_VARCHAR2(P_PATH     => 'usrUltMod'),
          IP_ULT_MOD              = APEX_JSON.GET_VARCHAR2(P_PATH     => 'ipUltMod'),
          FEC_ULT_MOD             = SYSDATE
    WHERE ID_SERVICIO_RECURSO_DET = Ln_IdRecursoDet
      OR  SERVICIO_RECURSO_CAB_ID = Ln_IdRecursoCab
      OR  ELEMENTO_ID             = Ln_IdElemento;

      --Respuesta Exitosa.
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status       := 'ERROR';
      Pv_Mensaje      :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_RECURSO_DET;
----
----
END CMKG_SOLUCIONES_TRANSACCION;
/

