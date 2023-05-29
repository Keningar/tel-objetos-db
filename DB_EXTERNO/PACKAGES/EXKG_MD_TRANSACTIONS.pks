SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_EXTERNO.EXKG_MD_TRANSACTIONS AS

  /**
   * Documentación para el procedimiento 'P_UPDATE_PROMOCIONES'.
   *
   * Proceso encargado de actualizar el listado de las promociones enviadas en una tabla.
   *
   * Costo Query C_InfoProcesoPromo : 10.
   *
   * @Param Ptl_Promociones IN  Gtl_Promociones : Tabla de toda las promociones a actualizar.
   * @Param Pv_Usuario      IN  VARCHAR2 : Usuario quien realiza la actualización.
   * @Param Pv_Ip           IN  VARCHAR2 : Ip del usuario quien realiza la actualización.
   * @Param Pv_Mensaje      OUT VARCHAR2 : Mensaje error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_UPDATE_PROMOCIONES(Ptl_Promociones IN  DB_EXTERNO.Gtl_Promociones,
                                 Pv_Usuario      IN  VARCHAR2,
                                 Pv_Ip           IN  VARCHAR2,
                                 Pv_Mensaje      OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_UPDATE_PROMOCION'.
   *
   * Proceso encargado de actualizar el proceso de promoción.
   *
   * @Param Pr_Promocion IN  ROWTYPE  : Recibe un record de la tabla 'INFO_PROCESO_PROMO'.
   * @Param Pv_Mensaje   OUT VARCHAR2 : Mensaje error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_UPDATE_PROMOCION(Pr_InfoProcesoPromo IN  DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE,
                               Pv_Mensaje          OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_INSERT_PROCESO_PROMO'.
   *
   * Proceso encargado de insertar las promociones en la tabla 'INFO_PROCESO_PROMO'
   * del esquema 'DB_EXTERNO'.
   *
   * @Param Pr_InfoProcesoPromo  IN  INFO_PROCESO_PROMO%ROWTYPE : Recibe un record de las promociones.
   * @Param Pv_Mensaje           OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_INSERT_PROCESO_PROMO(Pr_InfoProcesoPromo IN  DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE,
                                   Pv_Mensaje          OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_INSERT_PROCESO_PROMO_HIST'.
   *
   * Proceso encargado de insertar el historial del proceso de promociones
   * en la tabla 'INFO_PROCESO_PROMO_HIST' del esquema 'DB_EXTERNO'.
   *
   * @Param Pr_InfoProcesoPromoHist IN  INFO_PROCESO_PROMO_HIST%ROWTYPE : Recibe un record del historial de las promociones.
   * @Param Pv_Mensaje              OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_INSERT_PROCESO_PROMO_HIST(Pr_InfoProcesoPromoHist IN  DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE,
                                        Pv_Mensaje              OUT VARCHAR2);

END EXKG_MD_TRANSACTIONS;
/
CREATE OR REPLACE PACKAGE BODY DB_EXTERNO.EXKG_MD_TRANSACTIONS AS

  PROCEDURE P_UPDATE_PROMOCIONES(Ptl_Promociones IN  DB_EXTERNO.Gtl_Promociones,
                                 Pv_Usuario      IN  VARCHAR2,
                                 Pv_Ip           IN  VARCHAR2,
                                 Pv_Mensaje      OUT VARCHAR2) IS

    --Cursores Locales
    CURSOR C_InfoProcesoPromo(Cn_IdProcesoPromo NUMBER,
                              Cn_DetalleMapeoId NUMBER,
                              Cv_Estado         VARCHAR2)
    IS
      SELECT IPP.*
          FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
      WHERE (IPP.ID_PROCESO_PROMO = Cn_IdProcesoPromo OR
             IPP.DETALLE_MAPEO_ID = Cn_DetalleMapeoId)
        AND UPPER(IPP.ESTADO)     = UPPER(Cv_Estado);

    --Variables Locales
    Lr_InfoProcesoPromoHist  DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE;
    Lr_InfoProcesoPromocion  DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE;
    Lc_InfoProcesoPromo      C_InfoProcesoPromo%ROWTYPE;
    Lb_ExisteData            BOOLEAN;
    Lr_Promocion             DB_EXTERNO.Gr_Promocion;
    Ln_Indx                  NUMBER;
    Le_MyException           EXCEPTION;
    Le_MyExceptionGeneral    EXCEPTION;
    Lv_Error                 VARCHAR2(4000);
    Lv_Codigo                VARCHAR2(30) := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Ln_Error                 NUMBER := 0;
    Lb_EliminarCaract        BOOLEAN;
    Lv_MsjResultado          VARCHAR2(4000); 

  BEGIN

    IF C_InfoProcesoPromo%ISOPEN THEN
      CLOSE C_InfoProcesoPromo;
    END IF;

    --Verificamos que los parámetros de entrada sean obligatorios.
    IF Ptl_Promociones IS NULL OR Pv_Usuario IS NULL OR Pv_Ip IS NULL THEN
      Lv_Error := 'Todos los parámetros de entrada deben ser obligatorios (Ptl_Promociones,Pv_Usuario,Pv_Ip)';
      RAISE Le_MyExceptionGeneral;
    END IF;

    --Verificamos que la tabla de promciones tenga al menos un registro.
    IF Ptl_Promociones.COUNT() < 1 THEN
      Lv_Error := 'No se encontrarón registros en la tabla de promociones.';
      RAISE Le_MyExceptionGeneral;
    END IF;

    Ln_Indx := Ptl_Promociones.FIRST;

    WHILE (Ln_Indx IS NOT NULL) LOOP

      BEGIN

        Lr_Promocion := NULL;
        Lv_Error     := NULL;
        Lr_Promocion := Ptl_Promociones(Ln_Indx);
        Ln_Indx      := Ptl_Promociones.NEXT(Ln_Indx);

        --Validamos que ningún valor sea nulo.
        IF (Lr_Promocion.ID_PROCESO_PROMO IS NULL AND Lr_Promocion.DETALLE_MAPEO_ID IS NULL) OR
            Lr_Promocion.ESTADO           IS NULL OR  Lr_Promocion.OBSERVACION      IS NULL THEN

          Lv_Error := 'Ningún valor puede ser nulo. - '||
                     ' ID_PROCESO_PROMO: '||Lr_Promocion.ID_PROCESO_PROMO||','||
                     ' DETALLE_MAPEO_ID: '||Lr_Promocion.DETALLE_MAPEO_ID||','||
                     ' ESTADO: '          ||Lr_Promocion.ESTADO||','||
                     ' OBSERVACION: '     ||Lr_Promocion.OBSERVACION;
          RAISE Le_MyException;

        END IF;

        --Obtenemos el proceso a actualizar para verificar si existe y se encuentre en estado 'Pendiente'.
        OPEN C_InfoProcesoPromo(Lr_Promocion.ID_PROCESO_PROMO,Lr_Promocion.DETALLE_MAPEO_ID,'Pendiente');
          FETCH C_InfoProcesoPromo INTO Lc_InfoProcesoPromo;
            Lb_ExisteData := C_InfoProcesoPromo%NOTFOUND;
        CLOSE C_InfoProcesoPromo;

        IF Lb_ExisteData THEN
          IF Lr_Promocion.ID_PROCESO_PROMO IS NOT NULL THEN
            Lv_Error := 'El id de promoción ('||Lr_Promocion.ID_PROCESO_PROMO||') no existe o '
                      ||'se encuentra en un estado diferente de Pendiente.';
          ELSE
            Lv_Error := 'El id de detalle mapeo ('||Lr_Promocion.DETALLE_MAPEO_ID||') no existe o '
                      ||'se encuentra en un estado diferente de Pendiente.';
          END IF;
          RAISE Le_MyException;
        END IF;

        --Se arma el record para actualizar la promoción.
        Lr_InfoProcesoPromocion                  := NULL;
        Lr_InfoProcesoPromocion.ID_PROCESO_PROMO := Lc_InfoProcesoPromo.ID_PROCESO_PROMO;
        Lr_InfoProcesoPromocion.ESTADO           := Lr_Promocion.ESTADO;
        Lr_InfoProcesoPromocion.DETALLE_MAPEO_ID := Lr_Promocion.DETALLE_MAPEO_ID;
        Lr_InfoProcesoPromocion.USR_MODIFICACION := Pv_Usuario;
        Lr_InfoProcesoPromocion.IP_MODIFICACION  := Pv_Ip;

        --Llamada al procedimiento encargado de actualizar la promoción.
        DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_UPDATE_PROMOCION(Lr_InfoProcesoPromocion,Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          Lv_Error := 'Id Promoción '||Lc_InfoProcesoPromo.ID_PROCESO_PROMO||', Mensaje: '||Lv_Error;
          RAISE Le_MyException;
        END IF;

        --Se arma el record para insertar el historial de la actualización de la promoción.
        Lr_InfoProcesoPromoHist                       := NULL;
        Lr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST := DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL;
        Lr_InfoProcesoPromoHist.PROCESO_PROMO_ID      := Lc_InfoProcesoPromo.ID_PROCESO_PROMO;
        Lr_InfoProcesoPromoHist.ESTADO                := Lr_Promocion.ESTADO;
        Lr_InfoProcesoPromoHist.OBSERVACION           := Lr_Promocion.OBSERVACION;
        Lr_InfoProcesoPromoHist.FE_CREACION           := SYSDATE;
        Lr_InfoProcesoPromoHist.USR_CREACION          := Pv_Usuario;
        Lr_InfoProcesoPromoHist.IP_CREACION           := Pv_Ip;

        --Llamada al procedimiento encargado de registrar el historial.
        DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO_HIST(Lr_InfoProcesoPromoHist,Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          Lv_Error := 'Id Promoción '||Lr_Promocion.ID_PROCESO_PROMO||', Mensaje: '||Lv_Error;
          RAISE Le_MyException;
        END IF;

        --Llamada al proceso de aplica.
        IF UPPER(Lr_Promocion.ESTADO) = 'FINALIZADO' AND
          (Lc_InfoProcesoPromo.DETALLE_MAPEO_ID IS NOT NULL OR
           UPPER(Lc_InfoProcesoPromo.TIPO_PROCESO) = 'REACTIVAPROMO') THEN

          DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => Lc_InfoProcesoPromo.EMPRESA_COD,
                                                           Pv_TipoPromo    => Lc_InfoProcesoPromo.TIPO_PROMO,
                                                           Pn_IdServicio   => Lc_InfoProcesoPromo.SERVICIO_ID,
                                                           Pv_MsjResultado => Lv_Error);
        END IF;

        --Verificamos si se debe eliminar las características promocionales.
        IF UPPER(Lr_Promocion.ESTADO) = 'FINALIZADO' AND UPPER(Lc_InfoProcesoPromo.TIPO_PROCESO) = 'PIERDEPROMO' THEN

          DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_VALIDA_ELIMINA_CARACT_BW(Lc_InfoProcesoPromo.SERVICIO_ID,
                                                                        Lc_InfoProcesoPromo.TIPO_PROMO,
                                                                        Lb_EliminarCaract);

          IF Lb_EliminarCaract THEN
            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW(Lc_InfoProcesoPromo.SERVICIO_ID,Lv_Error);
          END IF;

        END IF;

        --Creamos característica AB_PROMO para servicios configurados de manera masiva
        IF UPPER(Lr_Promocion.ESTADO) = 'FINALIZADO' AND 
           (UPPER(Lc_InfoProcesoPromo.TIPO_PROCESO) = 'REACTIVAPROMO' OR
            UPPER(Lc_InfoProcesoPromo.TIPO_PROCESO) = 'APLICAPROMO')THEN

          --Primero eliminamos la característica en caso de existir
          DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_INDV_BW(Lc_InfoProcesoPromo.SERVICIO_ID,
                                                                     'AB-PROMO',
                                                                      Lv_MsjResultado);

          IF Lv_MsjResultado IS NOT NULL THEN 
            RAISE Le_MyException;
          END IF;

          DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_CREA_CARACT_INDV_BW(Lc_InfoProcesoPromo.SERVICIO_ID,
                                                                  'AB-PROMO',
                                                                   Lr_Promocion.AB_PROMO,
                                                                   Lv_MsjResultado);

          IF Lv_MsjResultado IS NOT NULL THEN
            RAISE Le_MyException;
          END IF;

        END IF;

        --A este punto se actualizo el estado correctamente.
        IF UPPER(Lr_Promocion.OPCION_PROCESO) <> 'BAJA' OR Lr_Promocion.OPCION_PROCESO IS NULL THEN
          COMMIT;
        END IF;

      EXCEPTION
        WHEN Le_MyException THEN
          IF UPPER(Lr_Promocion.OPCION_PROCESO) <> 'BAJA' OR Lr_Promocion.OPCION_PROCESO IS NULL THEN
              ROLLBACK;
          END IF;
          Ln_Error := Ln_Error + 1;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_TRANSACTIONS',
                                               'P_UPDATE_PROMOCIONES',
                                                Lv_Codigo||'|'||Lv_Error,
                                                NVL(Pv_Usuario,'telcos_promo_bw'),
                                                SYSDATE,
                                                NVL(NVL(Pv_Ip,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));
      END;

    END LOOP;

    IF Ln_Error > 0 THEN
      Pv_Mensaje := 'Proceso culmino con '||Ln_Error||' un error/errores. Código de proceso: '||Lv_Codigo;
    END IF;

  EXCEPTION
    WHEN Le_MyExceptionGeneral THEN
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_TRANSACTIONS',
                                           'P_UPDATE_PROMOCIONES',
                                            Lv_Error,
                                            NVL(Pv_Usuario,'telcos_promo_bw'),
                                            SYSDATE,
                                            NVL(NVL(Pv_Ip,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));
    WHEN OTHERS THEN
      IF UPPER(Lr_Promocion.OPCION_PROCESO) <> 'BAJA' OR Lr_Promocion.OPCION_PROCESO IS NULL THEN
          ROLLBACK;
      END IF;
      Pv_Mensaje := 'Error al actualizar la promoción';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_TRANSACTIONS',
                                           'P_UPDATE_PROMOCIONES',
                                            SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(Pv_Usuario,'telcos_promo_bw'),
                                            SYSDATE,
                                            NVL(NVL(Pv_Ip,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));

  END P_UPDATE_PROMOCIONES;
----
----
  PROCEDURE P_UPDATE_PROMOCION(Pr_InfoProcesoPromo IN  DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE,
                               Pv_Mensaje          OUT VARCHAR2) IS

  BEGIN

    --Actualización del proceso de promoción.
    UPDATE DB_EXTERNO.INFO_PROCESO_PROMO
      SET ESTADO               = NVL(Pr_InfoProcesoPromo.ESTADO,ESTADO),
          TRAFFIC_PROMO        = NVL(Pr_InfoProcesoPromo.TRAFFIC_PROMO,TRAFFIC_PROMO),
          GEMPORT_PROMO        = NVL(Pr_InfoProcesoPromo.GEMPORT_PROMO,GEMPORT_PROMO),
          LINE_PROFILE_PROMO   = NVL(Pr_InfoProcesoPromo.LINE_PROFILE_PROMO,LINE_PROFILE_PROMO),
          CAPACIDAD_UP_PROMO   = NVL(Pr_InfoProcesoPromo.CAPACIDAD_UP_PROMO,CAPACIDAD_UP_PROMO),
          CAPACIDAD_DOWN_PROMO = NVL(Pr_InfoProcesoPromo.CAPACIDAD_DOWN_PROMO,CAPACIDAD_DOWN_PROMO),
          FE_MODIFICACION      = SYSDATE,
          USR_MODIFICACION     = Pr_InfoProcesoPromo.USR_MODIFICACION,
          IP_MODIFICACION      = Pr_InfoProcesoPromo.IP_MODIFICACION
    WHERE (ID_PROCESO_PROMO = Pr_InfoProcesoPromo.ID_PROCESO_PROMO OR
           DETALLE_MAPEO_ID = Pr_InfoProcesoPromo.DETALLE_MAPEO_ID);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_UPDATE_PROMOCION, Error: '||SUBSTR(SQLERRM,0,2000);

  END P_UPDATE_PROMOCION;
----
----
  PROCEDURE P_INSERT_PROCESO_PROMO(Pr_InfoProcesoPromo IN  DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE,
                                   Pv_Mensaje          OUT VARCHAR2) IS

  BEGIN

    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO (
        ID_PROCESO_PROMO,
        MODELO_ELEMENTO,
        FE_INI_MAPEO,
        FE_FIN_MAPEO,
        LOGIN_PUNTO,
        SERVICIO_ID,
        ESTADO_SERVICIO,
        EMPRESA_COD,
        SERIE,
        MAC,
        NOMBRE_OLT,
        PUERTO,
        SERVICE_PORT,
        ONT_ID,
        TRAFFIC_PROMO,
        GEMPORT_PROMO,
        LINE_PROFILE_PROMO,
        NUM_IPS_FIJAS,
        CAPACIDAD_DOWN_PROMO,
        CAPACIDAD_UP_PROMO,
        TIPO_NEGOCIO,
        TRAFFIC_ORIGIN,
        GEMPORT_ORIGIN,
        LINE_PROFILE_ORIGIN,
        VLAN_ORIGIN,
        SERVICE_PROFILE,
        CAPACIDAD_DOWN_ORIGIN,
        CAPACIDAD_UP_ORIGIN,
        DETALLE_MAPEO_ID,
        TIPO_PROCESO,
        TIPO_PROMO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        IP_CREACION
    ) VALUES (
        Pr_InfoProcesoPromo.ID_PROCESO_PROMO,
        Pr_InfoProcesoPromo.MODELO_ELEMENTO,
        Pr_InfoProcesoPromo.FE_INI_MAPEO,
        Pr_InfoProcesoPromo.FE_FIN_MAPEO,
        Pr_InfoProcesoPromo.LOGIN_PUNTO,
        Pr_InfoProcesoPromo.SERVICIO_ID,
        Pr_InfoProcesoPromo.ESTADO_SERVICIO,
        Pr_InfoProcesoPromo.EMPRESA_COD,
        Pr_InfoProcesoPromo.SERIE,
        Pr_InfoProcesoPromo.MAC,
        Pr_InfoProcesoPromo.NOMBRE_OLT,
        Pr_InfoProcesoPromo.PUERTO,
        Pr_InfoProcesoPromo.SERVICE_PORT,
        Pr_InfoProcesoPromo.ONT_ID,
        Pr_InfoProcesoPromo.TRAFFIC_PROMO,
        Pr_InfoProcesoPromo.GEMPORT_PROMO,
        Pr_InfoProcesoPromo.LINE_PROFILE_PROMO,
        Pr_InfoProcesoPromo.NUM_IPS_FIJAS,
        Pr_InfoProcesoPromo.CAPACIDAD_DOWN_PROMO,
        Pr_InfoProcesoPromo.CAPACIDAD_UP_PROMO,
        Pr_InfoProcesoPromo.TIPO_NEGOCIO,
        Pr_InfoProcesoPromo.TRAFFIC_ORIGIN,
        Pr_InfoProcesoPromo.GEMPORT_ORIGIN,
        Pr_InfoProcesoPromo.LINE_PROFILE_ORIGIN,
        Pr_InfoProcesoPromo.VLAN_ORIGIN,
        Pr_InfoProcesoPromo.SERVICE_PROFILE,
        Pr_InfoProcesoPromo.CAPACIDAD_DOWN_ORIGIN,
        Pr_InfoProcesoPromo.CAPACIDAD_UP_ORIGIN,
        Pr_InfoProcesoPromo.DETALLE_MAPEO_ID,
        Pr_InfoProcesoPromo.TIPO_PROCESO,
        Pr_InfoProcesoPromo.TIPO_PROMO,
        Pr_InfoProcesoPromo.ESTADO,
        Pr_InfoProcesoPromo.FE_CREACION,
        Pr_InfoProcesoPromo.USR_CREACION,
        Pr_InfoProcesoPromo.IP_CREACION
    );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_INSERT_PROCESO_PROMO, Error: '||SUBSTR(SQLERRM,0,2000);

  END P_INSERT_PROCESO_PROMO;
----
----
  PROCEDURE P_INSERT_PROCESO_PROMO_HIST(Pr_InfoProcesoPromoHist IN  DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE,
                                        Pv_Mensaje              OUT VARCHAR2) IS

  BEGIN

    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO_HIST (
        ID_PROCESO_PROMO_HIST,
        PROCESO_PROMO_ID,
        ESTADO,
        OBSERVACION,
        FE_CREACION,
        USR_CREACION,
        IP_CREACION
    ) VALUES (
        Pr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST,
        Pr_InfoProcesoPromoHist.PROCESO_PROMO_ID,
        Pr_InfoProcesoPromoHist.ESTADO,
        Pr_InfoProcesoPromoHist.OBSERVACION,
        Pr_InfoProcesoPromoHist.FE_CREACION,
        Pr_InfoProcesoPromoHist.USR_CREACION,
        Pr_InfoProcesoPromoHist.IP_CREACION
    );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_INSERT_PROCESO_PROMO_HIST, Error: '||SUBSTR(SQLERRM,0,2000);

  END P_INSERT_PROCESO_PROMO_HIST;

END EXKG_MD_TRANSACTIONS;
/
