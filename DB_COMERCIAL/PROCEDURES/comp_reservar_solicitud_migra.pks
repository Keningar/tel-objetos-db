CREATE OR REPLACE PROCEDURE DB_COMERCIAL.comp_reservar_solicitud_migra(
    idServicioParam IN NUMBER,
    mensajeSalidaParam OUT VARCHAR2)
IS
  CURSOR productosCaracteristicas (planIdParam NUMBER, elementoOltIdParam NUMBER)
  IS
    SELECT AAA.ID_PRODUCTO_CARACTERISITICA,
      AAA.DESCRIPCION_CARACTERISTICA,
      BBB.DETALLE_VALOR
    FROM
      (SELECT *
      FROM
        (SELECT APC.ID_PRODUCTO_CARACTERISITICA,
          DESCRIPCION_CARACTERISTICA
        FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
          DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
          DB_COMERCIAL.ADMI_CARACTERISTICA AC
        WHERE AP.ID_PRODUCTO           = APC.PRODUCTO_ID
        AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
        AND AP.NOMBRE_TECNICO          ='INTERNET'
        AND EMPRESA_COD                ='18'
        AND DESCRIPCION_CARACTERISTICA ='TRAFFIC-TABLE'
      UNION
      SELECT APC.ID_PRODUCTO_CARACTERISITICA,
        DESCRIPCION_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AP.ID_PRODUCTO           = APC.PRODUCTO_ID
      AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
      AND AP.NOMBRE_TECNICO          ='INTERNET'
      AND EMPRESA_COD                ='18'
      AND DESCRIPCION_CARACTERISTICA ='GEM-PORT'
      UNION
      -- AQUI VA EL LINE PROFLE NAME
      SELECT APC.ID_PRODUCTO_CARACTERISITICA,
        DESCRIPCION_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AP.ID_PRODUCTO           = APC.PRODUCTO_ID
      AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
      AND AP.NOMBRE_TECNICO          ='INTERNET'
      AND EMPRESA_COD                ='18'
      AND DESCRIPCION_CARACTERISTICA ='LINE-PROFILE-NAME'
      UNION
      -- AQUI VA EL LINE PROFLE NAME
      SELECT APC.ID_PRODUCTO_CARACTERISITICA,
        DESCRIPCION_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AP.ID_PRODUCTO           = APC.PRODUCTO_ID
      AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
      AND AP.NOMBRE_TECNICO          ='INTERNET'
      AND EMPRESA_COD                ='18'
      AND DESCRIPCION_CARACTERISTICA ='VLAN'
        )
      ) AAA,
      (SELECT DETALLE_NOMBRE,
        DETALLE_VALOR,
        ELEMENTO_ID
      FROM db_infraestructura.info_detalle_elemento bbb
      WHERE bbb.REF_DETALLE_ELEMENTO_ID IN (
        (SELECT ID_DETALLE_ELEMENTO
        FROM db_infraestructura.info_detalle_elemento
        WHERE DETALLE_NOMBRE='LINE-PROFILE-NAME'
        AND DETALLE_VALOR   =
          (SELECT PARD.VALOR1
          FROM DB_COMERCIAL.INFO_PLAN_CAB IPC,
            DB_COMERCIAL.INFO_PLAN_DET IPD,
            DB_COMERCIAL.ADMI_PRODUCTO AP,
            DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT IPPC,
            DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
            DB_COMERCIAL.ADMI_CARACTERISTICA AC,
            DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
            DB_GENERAL.ADMI_PARAMETRO_DET PARD
          WHERE IPC.ID_PLAN                    = IPD.PLAN_ID
          AND IPD.PRODUCTO_ID                  = AP.ID_PRODUCTO
          AND AP.NOMBRE_TECNICO                = 'INTERNET'
          AND IPD.ID_ITEM                      =IPPC.PLAN_DET_ID
          AND IPPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
          AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
          AND PARC.ID_PARAMETRO                =PARD.PARAMETRO_ID
          AND PARC.NOMBRE_PARAMETRO            ='CNR_PERFIL_CLIENT_PCK'
          AND PARD.VALOR2                      =IPPC.VALOR
          AND AC.DESCRIPCION_CARACTERISTICA    ='PERFIL'
          AND IPC.ESTADO                       = IPD.ESTADO
          AND ID_PLAN                          =planIdParam
          )
        AND ELEMENTO_ID=elementoOltIdParam
        ))
      UNION
      SELECT DETALLE_NOMBRE,
        DETALLE_VALOR,
        ELEMENTO_ID
      FROM db_infraestructura.info_detalle_elemento bbb
      WHERE bbb.REF_DETALLE_ELEMENTO_ID IN (
        (SELECT REF_DETALLE_ELEMENTO_ID
        FROM db_infraestructura.info_detalle_elemento
        WHERE DETALLE_NOMBRE='LINE-PROFILE-NAME'
        AND DETALLE_VALOR   =
          (SELECT PARD.VALOR1
          FROM DB_COMERCIAL.INFO_PLAN_CAB IPC,
            DB_COMERCIAL.INFO_PLAN_DET IPD,
            DB_COMERCIAL.ADMI_PRODUCTO AP,
            DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT IPPC,
            DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
            DB_COMERCIAL.ADMI_CARACTERISTICA AC,
            DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
            DB_GENERAL.ADMI_PARAMETRO_DET PARD
          WHERE IPC.ID_PLAN                    = IPD.PLAN_ID
          AND IPD.PRODUCTO_ID                  = AP.ID_PRODUCTO
          AND AP.NOMBRE_TECNICO                = 'INTERNET'
          AND IPD.ID_ITEM                      =IPPC.PLAN_DET_ID
          AND IPPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
          AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
          AND PARC.ID_PARAMETRO                =PARD.PARAMETRO_ID
          AND PARC.NOMBRE_PARAMETRO            ='CNR_PERFIL_CLIENT_PCK'
          AND PARD.VALOR2                      =IPPC.VALOR
          AND AC.DESCRIPCION_CARACTERISTICA    ='PERFIL'
          AND IPC.ESTADO                       = IPD.ESTADO
          AND ID_PLAN                          =planIdParam
          )
        AND ELEMENTO_ID=elementoOltIdParam
        ))
      UNION
      SELECT DETALLE_NOMBRE,
        DETALLE_VALOR,
        ELEMENTO_ID
      FROM db_infraestructura.info_detalle_elemento bbb
      WHERE bbb.ID_DETALLE_ELEMENTO IN (
        (SELECT REF_DETALLE_ELEMENTO_ID
        FROM db_infraestructura.info_detalle_elemento
        WHERE DETALLE_NOMBRE='LINE-PROFILE-NAME'
        AND DETALLE_VALOR   =
          (SELECT PARD.VALOR1
          FROM DB_COMERCIAL.INFO_PLAN_CAB IPC,
            DB_COMERCIAL.INFO_PLAN_DET IPD,
            DB_COMERCIAL.ADMI_PRODUCTO AP,
            DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT IPPC,
            DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
            DB_COMERCIAL.ADMI_CARACTERISTICA AC,
            DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
            DB_GENERAL.ADMI_PARAMETRO_DET PARD
          WHERE IPC.ID_PLAN                    = IPD.PLAN_ID
          AND IPD.PRODUCTO_ID                  = AP.ID_PRODUCTO
          AND AP.NOMBRE_TECNICO                = 'INTERNET'
          AND IPD.ID_ITEM                      =IPPC.PLAN_DET_ID
          AND IPPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
          AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
          AND PARC.ID_PARAMETRO                =PARD.PARAMETRO_ID
          AND PARC.NOMBRE_PARAMETRO            ='CNR_PERFIL_CLIENT_PCK'
          AND PARD.VALOR2                      =IPPC.VALOR
          AND AC.DESCRIPCION_CARACTERISTICA    ='PERFIL'
          AND IPC.ESTADO                       = IPD.ESTADO
          AND ID_PLAN                          =planIdParam
          )
        AND ELEMENTO_ID=elementoOltIdParam
        ))
      UNION
      SELECT 'VLAN' DETALLE_NOMBRE,
        VALOR2 DETALLE_VALOR,
        NULL
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO  = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO='VLAN_HUAWEI'
      AND valor1              ='HOME'
      ) BBB
    WHERE AAA.DESCRIPCION_CARACTERISTICA=BBB.DETALLE_NOMBRE;
    idPlan                   NUMBER;
    idDetalleSolicitud       NUMBER;
    idInterfaceElementoAntes NUMBER;
    idElementoAntes          NUMBER;
    idElementoConectorAntes  NUMBER;
    idElementoActual         NUMBER;
    idIntEleConectorActual   NUMBER;
  BEGIN
    BEGIN
      SELECT plan_id
      INTO idPlan
      FROM info_servicio
      WHERE id_servicio =idServicioParam;
    EXCEPTION
    WHEN OTHERS THEN
      idPlan:=NULL;
    END;
    BEGIN
      SELECT ID_DETALLE_SOLICITUD
      INTO idDetalleSolicitud
      FROM DB_COMERCIAL.info_detalle_solicitud
      WHERE servicio_id     =idServicioParam
      AND tipo_solicitud_id = 13
      AND estado            ='Asignada'
      AND rownum           <=1;
    EXCEPTION
    WHEN OTHERS THEN
      idDetalleSolicitud:=NULL;
    END;
    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    SET estado                ='AsignadoTarea'
    WHERE id_detalle_solicitud=idDetalleSolicitud;
    DELETE DB_COMERCIAL.INFO_DETALLE_SOL_HIST
    WHERE detalle_solicitud_id=idDetalleSolicitud
    AND estado                ='Asignada';
    BEGIN
      SELECT to_number(valor)
      INTO idInterfaceElementoAntes
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      WHERE SERVICIO_ID               =idServicioParam
      AND PRODUCTO_CARACTERISITICA_ID =811
      AND ID_SERVICIO_PROD_CARACT     =
        (SELECT MAX(id_servicio_prod_caract)
        FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
        WHERE SERVICIO_ID               =idServicioParam
        AND PRODUCTO_CARACTERISITICA_ID =811
        );
    EXCEPTION
    WHEN OTHERS THEN
      idInterfaceElementoAntes:=NULL;
    END;
    BEGIN
      SELECT ELEMENTO_ID
      INTO idElementoAntes
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
      WHERE ID_INTERFACE_ELEMENTO=idInterfaceElementoAntes;
    EXCEPTION
    WHEN OTHERS THEN
      idElementoAntes:=NULL;
    END;
    BEGIN
      SELECT ref_elemento_id
      INTO idElementoConectorAntes
      FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ,
        info_elemento
      WHERE SERVICIO_ID       =idServicioParam
      AND elemento_conector_id=id_elemento;
    EXCEPTION
    WHEN OTHERS THEN
      idElementoConectorAntes:=NULL;
    END;
    BEGIN
      SELECT elemento_id, INTERFACE_ELEMENTO_CONECTOR_ID
      INTO idElementoActual, idIntEleConectorActual
      FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO
      WHERE SERVICIO_ID=idServicioParam;
    EXCEPTION
    WHEN OTHERS THEN
      idElementoActual:=NULL;
    END;
    UPDATE DB_COMERCIAL.info_servicio_tecnico
    SET elemento_id        =idElementoAntes,
      interface_elemento_id=idInterfaceElementoAntes,
      elemento_conector_id =idElementoConectorAntes
    WHERE servicio_id      =idServicioParam;
    FOR productoCaracteristica IN productosCaracteristicas (idPlan , idElementoActual )
    LOOP
      UPDATE DB_COMERCIAL.info_servicio_prod_caract
      SET estado                     ='Eliminado'
      WHERE servicio_id              =idServicioParam
      AND producto_caracterisitica_id=productoCaracteristica.ID_PRODUCTO_CARACTERISITICA;
    END LOOP;
    COMMIT;
    UPDATE DB_COMERCIAL.info_servicio_prod_caract
    SET estado                     ='Eliminado'
    WHERE SERVICIO_ID              =idServicioParam
    AND PRODUCTO_CARACTERISITICA_ID=
      (SELECT b.ID_PRODUCTO_CARACTERISITICA
      FROM DB_COMERCIAL.admi_caracteristica a,
        DB_COMERCIAL.Admi_Producto_Caracteristica b
      WHERE a.descripcion_caracteristica='INTERFACE ELEMENTO TELLION'
      AND a.ESTADO                      ='Activo'
      AND a.ID_CARACTERISTICA           =b.CARACTERISTICA_ID
      AND b.PRODUCTO_ID                 =63
      AND b.ESTADO                      ='Activo'
      );
      
    UPDATE DB_INFRAESTRUCTURA.info_ip
    SET estado       ='Eliminado'
    WHERE SERVICIO_ID=idServicioParam
    AND ESTADO       ='Reservada';

    UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
    SET estado       ='reserved'
    WHERE ID_INTERFACE_ELEMENTO=idIntEleConectorActual;
    
    COMMIT;
    mensajeSalidaParam:= '';
  EXCEPTION
  WHEN OTHERS THEN
    mensajeSalidaParam:= 'Problemas al reversar';
    ROLLBACK;
  END;
/

