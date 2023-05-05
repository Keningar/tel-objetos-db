CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES_BK AS

  /**
   * Documentación para el procedimiento 'P_PROCESO_PROMO_BK'.
   *
   * Proceso encargado de realizar el respaldo de la información de las tablas
   * 'INFO_PROCESO_PROMO' y 'INFO_PROCESO_PROMO_HIST' del esquema 'DB_EXTERNO'.
   *
   * Costo Query C_InfoProcesoPromo     : 10.
   * Costo Query C_InfoProcesoPromoHist : 8.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_PROCESO_PROMO_BK;

  /**
   * Documentación para el procedimiento 'P_INSERT_PROCESO_PROMO_BK'.
   *
   * Proceso encargado de insertar la promoción en la 'INFO_PROCESO_PROMO_BCK' del esquema 'DB_EXTERNO'.
   *
   * @Param Pr_InfoProcesoPromoBk IN  ROWTYPE  : Record de la tabla 'INFO_PROCESO_PROMO_BCK'.
   * @Param Pv_Mensaje            OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_INSERT_PROCESO_PROMO_BK(Pr_InfoProcesoPromoBk IN  DB_EXTERNO.INFO_PROCESO_PROMO_BCK%ROWTYPE,
                                      Pv_Mensaje            OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_INSERT_PROCESO_PROMO_HIST_BK'.
   *
   * Proceso encargado de insertar el historial de la promoción
   * en la 'INFO_PROCESO_PROMO_HIST_BCK' del esquema 'DB_EXTERNO'.
   *
   * @Param Pr_InfoProcesoPromoHistBk IN  ROWTYPE  : Record de la tabla 'INFO_PROCESO_PROMO_HIST_BCK'.
   * @Param Pv_Mensaje                OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_INSERT_PROCESO_PROMO_HIST_BK(Pr_InfoProcesoPromoHistBk IN  DB_EXTERNO.INFO_PROCESO_PROMO_HIST_BCK%ROWTYPE,
                                           Pv_Mensaje                OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_DELETE_PROCESO_PROMO'.
   *
   * Proceso encargado de eliminar la promoción con sus respectivos historiales de las tablas
   * 'INFO_PROCESO_PROMO' y 'INFO_PROCESO_PROMO_HIST' del esquema 'DB_EXTERNO'.
   *
   * @Param Pn_IdProcesoPromo IN  NUMBER   : Id de la tabla 'INFO_PROCESO_PROMO'.
   * @Param Pv_Mensaje        OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_DELETE_PROCESO_PROMO(Pn_IdProcesoPromo IN  NUMBER,
                                   Pv_Mensaje        OUT VARCHAR2);

END CMKG_PROMOCIONES_BK;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PROMOCIONES_BK AS

  PROCEDURE P_PROCESO_PROMO_BK IS

    CURSOR C_InfoProcesoPromo(Cv_Estado IN VARCHAR2) IS
      SELECT IPP.*
        FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
      WHERE UPPER(IPP.ESTADO) = UPPER(Cv_Estado);

    CURSOR C_InfoProcesoPromoHist(Cn_IdProcesoPromo IN NUMBER) IS
      SELECT IPPH.*
        FROM DB_EXTERNO.INFO_PROCESO_PROMO_HIST IPPH
      WHERE IPPH.PROCESO_PROMO_ID = Cn_IdProcesoPromo
        ORDER BY IPPH.FE_CREACION ASC;

    Lr_InfoProcesoPromoBk     DB_EXTERNO.INFO_PROCESO_PROMO_BCK%ROWTYPE;
    Lr_InfoProcesoPromoHistBk DB_EXTERNO.INFO_PROCESO_PROMO_HIST_BCK%ROWTYPE;
    Lv_IpCreacion             VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1');
    Lv_UsuarioCreacion        VARCHAR2(15) := 'telcos_promo_bw';
    Lv_Error                  VARCHAR2(4000);
    Le_MyException            EXCEPTION;

  BEGIN

    IF C_InfoProcesoPromo%ISOPEN THEN
      CLOSE C_InfoProcesoPromo;
    END IF;

    IF C_InfoProcesoPromoHist%ISOPEN THEN
      CLOSE C_InfoProcesoPromoHist;
    END IF;

    FOR Lc_InfoProcesoPromo IN C_InfoProcesoPromo('Finalizado') LOOP

      BEGIN

        --Se prepara la data para insertar en la tabla 'INFO_PROCESO_PROMO_BCK' de 'DB_EXTERNO'.
        Lr_InfoProcesoPromoBk                       := NULL;
        Lr_InfoProcesoPromoBk.FE_MODIFICACION       := Lc_InfoProcesoPromo.FE_CREACION;
        Lr_InfoProcesoPromoBk.USR_MODIFICACION      := Lc_InfoProcesoPromo.USR_CREACION;
        Lr_InfoProcesoPromoBk.IP_MODIFICACION       := Lc_InfoProcesoPromo.IP_CREACION;
        Lr_InfoProcesoPromoBk.IP_CREACION           := Lv_IpCreacion;
        Lr_InfoProcesoPromoBk.USR_CREACION          := Lv_UsuarioCreacion;
        Lr_InfoProcesoPromoBk.FE_CREACION           := SYSDATE;
        Lr_InfoProcesoPromoBk.ESTADO                := Lc_InfoProcesoPromo.ESTADO;
        Lr_InfoProcesoPromoBk.TIPO_PROMO            := Lc_InfoProcesoPromo.TIPO_PROMO;
        Lr_InfoProcesoPromoBk.TIPO_PROCESO          := Lc_InfoProcesoPromo.TIPO_PROCESO;
        Lr_InfoProcesoPromoBk.DETALLE_MAPEO_ID      := Lc_InfoProcesoPromo.DETALLE_MAPEO_ID;
        Lr_InfoProcesoPromoBk.CAPACIDAD_UP_ORIGIN   := Lc_InfoProcesoPromo.CAPACIDAD_UP_ORIGIN;
        Lr_InfoProcesoPromoBk.CAPACIDAD_DOWN_ORIGIN := Lc_InfoProcesoPromo.CAPACIDAD_DOWN_ORIGIN;
        Lr_InfoProcesoPromoBk.SERVICE_PROFILE       := Lc_InfoProcesoPromo.SERVICE_PROFILE;
        Lr_InfoProcesoPromoBk.VLAN_ORIGIN           := Lc_InfoProcesoPromo.VLAN_ORIGIN;
        Lr_InfoProcesoPromoBk.LINE_PROFILE_ORIGIN   := Lc_InfoProcesoPromo.LINE_PROFILE_ORIGIN;
        Lr_InfoProcesoPromoBk.GEMPORT_ORIGIN        := Lc_InfoProcesoPromo.GEMPORT_ORIGIN;
        Lr_InfoProcesoPromoBk.TRAFFIC_ORIGIN        := Lc_InfoProcesoPromo.TRAFFIC_ORIGIN;
        Lr_InfoProcesoPromoBk.TIPO_NEGOCIO          := Lc_InfoProcesoPromo.TIPO_NEGOCIO;
        Lr_InfoProcesoPromoBk.CAPACIDAD_UP_PROMO    := Lc_InfoProcesoPromo.CAPACIDAD_UP_PROMO;
        Lr_InfoProcesoPromoBk.CAPACIDAD_DOWN_PROMO  := Lc_InfoProcesoPromo.CAPACIDAD_DOWN_PROMO;
        Lr_InfoProcesoPromoBk.NUM_IPS_FIJAS         := Lc_InfoProcesoPromo.NUM_IPS_FIJAS;
        Lr_InfoProcesoPromoBk.LINE_PROFILE_PROMO    := Lc_InfoProcesoPromo.LINE_PROFILE_PROMO;
        Lr_InfoProcesoPromoBk.GEMPORT_PROMO         := Lc_InfoProcesoPromo.GEMPORT_PROMO;
        Lr_InfoProcesoPromoBk.TRAFFIC_PROMO         := Lc_InfoProcesoPromo.TRAFFIC_PROMO;
        Lr_InfoProcesoPromoBk.ONT_ID                := Lc_InfoProcesoPromo.ONT_ID;
        Lr_InfoProcesoPromoBk.SERVICE_PORT          := Lc_InfoProcesoPromo.SERVICE_PORT;
        Lr_InfoProcesoPromoBk.PUERTO                := Lc_InfoProcesoPromo.PUERTO;
        Lr_InfoProcesoPromoBk.NOMBRE_OLT            := Lc_InfoProcesoPromo.NOMBRE_OLT;
        Lr_InfoProcesoPromoBk.MAC                   := Lc_InfoProcesoPromo.MAC;
        Lr_InfoProcesoPromoBk.SERIE                 := Lc_InfoProcesoPromo.SERIE;
        Lr_InfoProcesoPromoBk.EMPRESA_COD           := Lc_InfoProcesoPromo.EMPRESA_COD;
        Lr_InfoProcesoPromoBk.ESTADO_SERVICIO       := Lc_InfoProcesoPromo.ESTADO_SERVICIO;
        Lr_InfoProcesoPromoBk.SERVICIO_ID           := Lc_InfoProcesoPromo.SERVICIO_ID;
        Lr_InfoProcesoPromoBk.LOGIN_PUNTO           := Lc_InfoProcesoPromo.LOGIN_PUNTO;
        Lr_InfoProcesoPromoBk.FE_FIN_MAPEO          := Lc_InfoProcesoPromo.FE_FIN_MAPEO;
        Lr_InfoProcesoPromoBk.FE_INI_MAPEO          := Lc_InfoProcesoPromo.FE_INI_MAPEO;
        Lr_InfoProcesoPromoBk.MODELO_ELEMENTO       := Lc_InfoProcesoPromo.MODELO_ELEMENTO;
        Lr_InfoProcesoPromoBk.ID_PROCESO_PROMO      := DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_BCK.NEXTVAL;

        DB_COMERCIAL.CMKG_PROMOCIONES_BK.P_INSERT_PROCESO_PROMO_BK(Lr_InfoProcesoPromoBk,Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          Lv_Error := 'ID_PROCESO_PROMO: '||Lc_InfoProcesoPromo.ID_PROCESO_PROMO||', Error: '||Lv_Error;
          RAISE Le_MyException;
        END IF;

        --Se realiza el insert de toda la información del Historial de las promociones.
        FOR Lc_InfoProcesoPromoHist IN C_InfoProcesoPromoHist(Lc_InfoProcesoPromo.ID_PROCESO_PROMO)
        LOOP

          --Se prepara la data para insertar en la tabla 'INFO_PROCESO_PROMO_HIST_BCK' de 'DB_EXTERNO'.
          Lr_InfoProcesoPromoHistBk                       := NULL;
          Lr_InfoProcesoPromoHistBk.IP_CREACION           := Lc_InfoProcesoPromoHist.IP_CREACION;
          Lr_InfoProcesoPromoHistBk.USR_CREACION          := Lc_InfoProcesoPromoHist.USR_CREACION;
          Lr_InfoProcesoPromoHistBk.FE_CREACION           := Lc_InfoProcesoPromoHist.FE_CREACION;
          Lr_InfoProcesoPromoHistBk.OBSERVACION           := Lc_InfoProcesoPromoHist.OBSERVACION;
          Lr_InfoProcesoPromoHistBk.ESTADO                := Lc_InfoProcesoPromoHist.ESTADO;
          Lr_InfoProcesoPromoHistBk.PROCESO_PROMO_ID      := Lr_InfoProcesoPromoBk.ID_PROCESO_PROMO;
          Lr_InfoProcesoPromoHistBk.ID_PROCESO_PROMO_HIST := DB_EXTERNO.SEQ_INFO_PROCESO_PROM_HIS_BCK.NEXTVAL;

          DB_COMERCIAL.CMKG_PROMOCIONES_BK.P_INSERT_PROCESO_PROMO_HIST_BK(Lr_InfoProcesoPromoHistBk,Lv_Error);

          IF Lv_Error IS NOT NULL THEN
            Lv_Error := 'ID_PROCESO_PROMO: '||Lc_InfoProcesoPromo.ID_PROCESO_PROMO||', Error: '||Lv_Error;
            RAISE Le_MyException;
          END IF;

        END LOOP;

        --Procedemos con la eliminación del registro.
        DB_COMERCIAL.CMKG_PROMOCIONES_BK.P_DELETE_PROCESO_PROMO(Lc_InfoProcesoPromo.ID_PROCESO_PROMO,Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          Lv_Error := 'ID_PROCESO_PROMO: '||Lc_InfoProcesoPromo.ID_PROCESO_PROMO||', Error: '||Lv_Error;
          RAISE Le_MyException;
        END IF;

        --A este punto el respaldo se realizó con éxito.
        COMMIT;

      EXCEPTION
        WHEN Le_MyException THEN
          ROLLBACK;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BK',
                                               'P_PROCESO_PROMO_BK',
                                                Lv_Error,
                                               'telcos_promo_bw',
                                                SYSDATE,
                                                NVL(NVL(Lv_IpCreacion,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));

      END;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BK',
                                           'P_PROCESO_PROMO_BK',
                                            SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(NVL(Lv_IpCreacion,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));
  END P_PROCESO_PROMO_BK;
----
----
  PROCEDURE P_INSERT_PROCESO_PROMO_BK(Pr_InfoProcesoPromoBk IN  DB_EXTERNO.INFO_PROCESO_PROMO_BCK%ROWTYPE,
                                      Pv_Mensaje            OUT VARCHAR2) IS
  BEGIN
    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO_BCK(
        IP_MODIFICACION,
        USR_MODIFICACION,
        FE_MODIFICACION,
        IP_CREACION,
        USR_CREACION,
        FE_CREACION,
        ESTADO,
        TIPO_PROMO,
        TIPO_PROCESO,
        DETALLE_MAPEO_ID,
        CAPACIDAD_UP_ORIGIN,
        CAPACIDAD_DOWN_ORIGIN,
        SERVICE_PROFILE,
        VLAN_ORIGIN,
        LINE_PROFILE_ORIGIN,
        GEMPORT_ORIGIN,
        TRAFFIC_ORIGIN,
        TIPO_NEGOCIO,
        CAPACIDAD_UP_PROMO,
        CAPACIDAD_DOWN_PROMO,
        NUM_IPS_FIJAS,
        LINE_PROFILE_PROMO,
        GEMPORT_PROMO,
        TRAFFIC_PROMO,
        ONT_ID,
        SERVICE_PORT,
        PUERTO,
        NOMBRE_OLT,
        MAC,
        SERIE,
        EMPRESA_COD,
        ESTADO_SERVICIO,
        SERVICIO_ID,
        LOGIN_PUNTO,
        FE_FIN_MAPEO,
        FE_INI_MAPEO,
        MODELO_ELEMENTO,
        ID_PROCESO_PROMO
    ) VALUES (
        Pr_InfoProcesoPromoBk.IP_MODIFICACION,
        Pr_InfoProcesoPromoBk.USR_MODIFICACION,
        Pr_InfoProcesoPromoBk.FE_MODIFICACION,
        Pr_InfoProcesoPromoBk.IP_CREACION,
        Pr_InfoProcesoPromoBk.USR_CREACION,
        Pr_InfoProcesoPromoBk.FE_CREACION,
        Pr_InfoProcesoPromoBk.ESTADO,
        Pr_InfoProcesoPromoBk.TIPO_PROMO,
        Pr_InfoProcesoPromoBk.TIPO_PROCESO,
        Pr_InfoProcesoPromoBk.DETALLE_MAPEO_ID,
        Pr_InfoProcesoPromoBk.CAPACIDAD_UP_ORIGIN,
        Pr_InfoProcesoPromoBk.CAPACIDAD_DOWN_ORIGIN,
        Pr_InfoProcesoPromoBk.SERVICE_PROFILE,
        Pr_InfoProcesoPromoBk.VLAN_ORIGIN,
        Pr_InfoProcesoPromoBk.LINE_PROFILE_ORIGIN,
        Pr_InfoProcesoPromoBk.GEMPORT_ORIGIN,
        Pr_InfoProcesoPromoBk.TRAFFIC_ORIGIN,
        Pr_InfoProcesoPromoBk.TIPO_NEGOCIO,
        Pr_InfoProcesoPromoBk.CAPACIDAD_UP_PROMO,
        Pr_InfoProcesoPromoBk.CAPACIDAD_DOWN_PROMO,
        Pr_InfoProcesoPromoBk.NUM_IPS_FIJAS,
        Pr_InfoProcesoPromoBk.LINE_PROFILE_PROMO,
        Pr_InfoProcesoPromoBk.GEMPORT_PROMO,
        Pr_InfoProcesoPromoBk.TRAFFIC_PROMO,
        Pr_InfoProcesoPromoBk.ONT_ID,
        Pr_InfoProcesoPromoBk.SERVICE_PORT,
        Pr_InfoProcesoPromoBk.PUERTO,
        Pr_InfoProcesoPromoBk.NOMBRE_OLT,
        Pr_InfoProcesoPromoBk.MAC,
        Pr_InfoProcesoPromoBk.SERIE,
        Pr_InfoProcesoPromoBk.EMPRESA_COD,
        Pr_InfoProcesoPromoBk.ESTADO_SERVICIO,
        Pr_InfoProcesoPromoBk.SERVICIO_ID,
        Pr_InfoProcesoPromoBk.LOGIN_PUNTO,
        Pr_InfoProcesoPromoBk.FE_FIN_MAPEO,
        Pr_InfoProcesoPromoBk.FE_INI_MAPEO,
        Pr_InfoProcesoPromoBk.MODELO_ELEMENTO,
        Pr_InfoProcesoPromoBk.ID_PROCESO_PROMO
    );
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_INSERT_PROCESO_PROMO_BK, Error: '||SUBSTR(SQLERRM,0,2000);
  END P_INSERT_PROCESO_PROMO_BK;
----
----
  PROCEDURE P_INSERT_PROCESO_PROMO_HIST_BK(Pr_InfoProcesoPromoHistBk IN  DB_EXTERNO.INFO_PROCESO_PROMO_HIST_BCK%ROWTYPE,
                                           Pv_Mensaje                OUT VARCHAR2) IS
  BEGIN
    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO_HIST_BCK (
        IP_CREACION,
        USR_CREACION,
        FE_CREACION,
        OBSERVACION,
        ESTADO,
        PROCESO_PROMO_ID,
        ID_PROCESO_PROMO_HIST
    ) VALUES (
        Pr_InfoProcesoPromoHistBk.IP_CREACION,
        Pr_InfoProcesoPromoHistBk.USR_CREACION,
        Pr_InfoProcesoPromoHistBk.FE_CREACION,
        Pr_InfoProcesoPromoHistBk.OBSERVACION,
        Pr_InfoProcesoPromoHistBk.ESTADO,
        Pr_InfoProcesoPromoHistBk.PROCESO_PROMO_ID,
        Pr_InfoProcesoPromoHistBk.ID_PROCESO_PROMO_HIST
    );
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_INSERT_PROCESO_PROMO_HIST_BK, Error: '||SUBSTR(SQLERRM,0,2000);
  END P_INSERT_PROCESO_PROMO_HIST_BK;
----
----
  PROCEDURE P_DELETE_PROCESO_PROMO(Pn_IdProcesoPromo IN  NUMBER,
                                   Pv_Mensaje        OUT VARCHAR2) IS
  BEGIN
    DELETE FROM DB_EXTERNO.INFO_PROCESO_PROMO_HIST WHERE PROCESO_PROMO_ID = Pn_IdProcesoPromo;
    DELETE FROM DB_EXTERNO.INFO_PROCESO_PROMO      WHERE ID_PROCESO_PROMO = Pn_IdProcesoPromo;
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_DELETE_PROCESO_PROMO, Error: '||SUBSTR(SQLERRM,0,2000);
  END P_DELETE_PROCESO_PROMO;

END CMKG_PROMOCIONES_BK;
/
