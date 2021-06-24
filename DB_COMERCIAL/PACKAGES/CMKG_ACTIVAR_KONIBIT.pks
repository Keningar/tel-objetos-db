SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_ACTIVAR_KONIBIT AS

  /**
   * Documentación para el procedimiento 'P_ACTIVAR_NETLIFECLOUD'
   * Proceso que sirve para Activar los servicios con productos Netlife Assistance Pro,
   * NetlifeCloud y ECOMMERCE BASIC que se encuentren en estado Pendiente.
   * Adicional se envia la notificación de Activación al web-service de konibit.
   *
   * @author Germán Valezuela <gvalenzuela@telconet.ec>
   * @version 1.0 06-24-2021
   */
  PROCEDURE P_ACTIVAR_NETLIFECLOUD;

END CMKG_ACTIVAR_KONIBIT;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_ACTIVAR_KONIBIT AS

  PROCEDURE P_ACTIVAR_NETLIFECLOUD IS

    CURSOR C_ServiciosPendientes IS
      SELECT
        ISE.ID_SERVICIO
      FROM
        DB_COMERCIAL.INFO_SERVICIO ISE,
        DB_COMERCIAL.ADMI_PRODUCTO APO
      WHERE
        APO.ID_PRODUCTO =  ISE.PRODUCTO_ID
        AND ISE.ESTADO  = 'Pendiente'
        AND UPPER(APO.DESCRIPCION_PRODUCTO) IN (
          'NETLIFE ASSISTANCE PRO',
          'NETLIFECLOUD',
          'ECOMMERCE BASIC'
        )
        AND EXISTS (
          SELECT 1
          FROM
            DB_COMERCIAL.INFO_SERVICIO           ISE2,
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
          WHERE
            ISH.SERVICIO_ID  =  ISE2.ID_SERVICIO
            AND ISE.PUNTO_ID =  ISE2.PUNTO_ID
            AND ISE2.PLAN_ID IS NOT NULL
            AND ISE2.ESTADO  = 'Activo'
            AND ISH.ESTADO   = 'Activo'
        );
  
    Lv_Usuario   VARCHAR2(50) := 'telcos';
    Lv_IpUsuario VARCHAR2(50) :=  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1');
    Lv_Error     VARCHAR2(4000);
  
  BEGIN
  
    IF C_ServiciosPendientes%ISOPEN THEN
      CLOSE C_ServiciosPendientes;
    END IF;
  
    FOR SERVICIO IN C_ServiciosPendientes LOOP
  
      --Se actualiza el servicio en estado 'Activo'.
      UPDATE DB_COMERCIAL.INFO_SERVICIO
        SET ESTADO = 'Activo'
      WHERE ID_SERVICIO = SERVICIO.ID_SERVICIO;
  
      --Se ingresa el historial del servicio 'Activo'.
      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION,
        ACCION
      ) VALUES (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        SERVICIO.ID_SERVICIO,
        Lv_Usuario,
        SYSDATE,
        Lv_IpUsuario,
       'Activo',
        TO_CLOB('Se confirmo el servicio'),
       'confirmarServicio'
      );
  
      --Proceso para notificar la Activación del servicio konibit.
      DB_INFRAESTRUCTURA.INFRKG_KONIBIT.P_ENVIA_NOTIFICACION(Pn_idServicio  =>  SERVICIO.ID_SERVICIO,
                                                             Pv_tipoProceso => 'ACTIVAR',
                                                             Pv_tipoTrx     => 'INDIVIDUAL',
                                                             Pv_usrCreacion =>  Lv_Usuario,
                                                             Pv_ipCreacion  =>  Lv_IpUsuario,
                                                             Pv_error       =>  Lv_Error);
  
      IF Lv_Error IS NOT NULL THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_ACTIVAR_KONIBIT',
                                             'P_ACTIVAR_NETLIFECLOUD',
                                             'Error: '||Lv_Error||'; ID_SERVICIO: '||SERVICIO.ID_SERVICIO,
                                              Lv_Usuario,
                                              SYSDATE,
                                              Lv_IpUsuario);
      END IF;

    END LOOP;
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_ACTIVAR_KONIBIT',
                                           'P_ACTIVAR_NETLIFECLOUD',
                                           'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','OS_USER'),USER),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_ACTIVAR_NETLIFECLOUD;

END CMKG_ACTIVAR_KONIBIT;
/
