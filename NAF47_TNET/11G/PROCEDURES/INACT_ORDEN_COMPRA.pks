CREATE OR REPLACE PROCEDURE NAF47_TNET.INACT_ORDEN_COMPRA ( Pv_Cia   IN VARCHAR2,
                                                            Pv_Prove IN VARCHAR2,
                                                            Pv_Oc    IN VARCHAR2) IS
/**
* Documentacion para NAF47_TNET.INACT_ORDEN_COMPRA
* Procedure que actualiza estado de orden de compra y unidades recibidas en el modulo de compras
* @author yoveri <info@yoveri.com>
* @version 1.0 13/08/2010
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 12/06/2017 Se modifica para actualizar estados de solicitudes de compras del portal de Pedidos de Compras
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.2 28/02/2018 Se modifica considerar solo los articulos recurrentes y actualizar el estado de la solicitud a nivel cabecera
*
* @author Elvis Muñoz <emunoz@telconet.ec>
* @version 1.3 28/02/2018 Se procede al cambio de la funcion GEK_CONSULTA.F_RECUPERA_LOGIN por la sentencia LOWER(USER)
*
* @param Pv_Cia   IN     VARCHAR2 Recibe codigo de compania
* @param Pv_Prove IN OUT VARCHAR2 recibe codigo de proveedor
* @param Pv_Oc    IN OUT VARCHAR2 recibe numero orden compra
*/
  CURSOR C_Inven IS
    SELECT b.no_arti,
           NVL(SUM(NVL(b.unidades_comp, 0)* decode(c.movimi, 'E', 1, decode(b.aplica_canje, 'S', -1, 0))), 0) unidades
      FROM arinme a,
           arinml b,
           arinvtm c
     WHERE a.no_cia = Pv_cia
       AND a.no_prove = Pv_prove
       AND a.orden_compra = Pv_Oc
       AND a.estado != 'P'
       AND a.no_cia = b.no_cia
       AND a.no_docu = b.no_docu
       and a.tipo_doc = c.tipo_m
       and a.no_cia = c.no_cia
     GROUP BY b.no_arti;

  CURSOR C_Taporded IS
    SELECT NVL(SUM(NVL(cantidad, 0) - NVL(recibido, 0)), 0)
      FROM taporded
     WHERE no_cia = Pv_cia
       AND no_orden IN (SELECT no_orden
                          FROM tapordee
                         WHERE no_cia = Pv_cia
                           AND no_orden = Pv_oc
                           AND estado IN ('E', 'I','F') -- Actualizar orden en estado emitido e incompleto, para Devoluciones es Finalizado
                           AND NVL(ind_no_inv, 'N') = 'N'
                           AND no_prove = Pv_prove);

  -- cursor que recupera las unidades ingresadas y el pedido relacionado
  CURSOR C_DATOS_COMPRAS (Cv_ProductoId    VARCHAR2,
                          Cv_OrdenCompraId VARCHAR2,
                          Cv_CompaniaId    VARCHAR2) IS
    SELECT OC.ID_ORDEN_COMPRA,
           DS.ID_SOLICITUD_DETALLE,
           P.ID_PEDIDO,
           PD.ID_PEDIDO_DETALLE,
           PD.PRODUCTO_ID,
           NVL(PD.CANTIDAD,0) AS CANTIDAD_PEDIDA,
           NVL(PD.CANTIDAD_DESPACHADA,0) AS CANTIDAD_DESPACHADA,
           PD.ESTADO,
           OCD.ID_ORDEN_COMPRA_DETALLE,
           OCD.CANTIDAD CANTIDAD_COMPRADA
    FROM DB_COMPRAS.INFO_ORDEN_COMPRA OC
         JOIN DB_COMPRAS.INFO_ORDEN_COMPRA_DETALLE OCD ON OCD.ORDEN_COMPRA_ID = OC.ID_ORDEN_COMPRA
         JOIN DB_COMPRAS.INFO_SOLICITUD_DETALLE DS     ON DS.ORDEN_COMPRA_ID = OC.ID_ORDEN_COMPRA
         JOIN DB_COMPRAS.INFO_PEDIDO P                 ON P.ID_PEDIDO = OC.PEDIDO_ID
         JOIN DB_COMPRAS.INFO_PEDIDO_DETALLE PD        ON PD.PEDIDO_ID = P.ID_PEDIDO AND PD.ID_PEDIDO_DETALLE = DS.PEDIDO_DETALLE_ID
         JOIN DB_COMPRAS.ADMI_EMPRESA E                ON E.ID_EMPRESA = OC.EMPRESA_ID
    WHERE DS.CODIGO = Cv_ProductoId
    AND OCD.CODIGO = Cv_ProductoId
    AND OC.SECUENCIA = Cv_OrdenCompraId
    AND E.CODIGO = Cv_CompaniaId
    AND PD.ESTADO != 'EnBodega'
    AND EXISTS (SELECT NULL
                FROM NAF47_TNET.ARINDA A
                WHERE A.NO_ARTI = PD.PRODUCTO_ID
                AND A.NO_CIA = E.CODIGO
                AND A.ES_RECURRENTE = 'S');
  --
  CURSOR C_ESTADO_PEDIDO (Cv_PedidoId NUMBER) IS
    SELECT P.ESTADO
    FROM DB_COMPRAS.INFO_PEDIDO P
    WHERE P.ID_PEDIDO = Cv_PedidoId
    AND EXISTS (SELECT NULL
                FROM DB_COMPRAS.INFO_PEDIDO_DETALLE PD
                WHERE PD.PEDIDO_ID = P.ID_PEDIDO
                AND PD.ESTADO = 'EnBodega');
  --
  Ln_total              NUMBER;
  Lr_DatosCompra        C_DATOS_COMPRAS%ROWTYPE := NULL;
  Lv_EstadoPedido       DB_COMPRAS.INFO_PEDIDO.ESTADO%TYPE := NULL;
  Lv_MensajeError       VARCHAR2(3000) := NULL;
  Le_Error              EXCEPTION;
  Ln_EnBodega           NUMBER(3) := 0;
  --
BEGIN

  FOR i IN C_Inven LOOP
    -- se busca datos de pedido compras
    IF C_DATOS_COMPRAS%ISOPEN THEN
      CLOSE C_DATOS_COMPRAS;
    END IF;
    --
    OPEN C_DATOS_COMPRAS(i.no_arti, Pv_oc, Pv_cia);
    FETCH C_DATOS_COMPRAS INTO Lr_DatosCompra;
    -- si encuentra registros se valida para actualizar estado pedido
    -- No se ha realizado nigun despacho, se puede manipular el estado
    -- total ingresado coincide con lo pedido, se cambia estado a EnBodega
    IF C_DATOS_COMPRAS%FOUND AND 
      Lr_DatosCompra.Estado IN ('Autorizado','ConOrdenCompra','IngresoParcial') AND 
      (i.unidades >= Lr_DatosCompra.CANTIDAD_PEDIDA) THEN
        UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE A
        SET ESTADO = 'EnBodega'
        WHERE A.ID_PEDIDO_DETALLE = Lr_DatosCompra.ID_PEDIDO_DETALLE;
        --
        Ln_EnBodega := Ln_EnBodega + 1;
        --
    END IF;
    CLOSE C_DATOS_COMPRAS;
    --
    UPDATE Taporded
       SET recibido = i.unidades
     WHERE no_cia = Pv_cia
       AND no_orden = pv_oc
       AND no_arti = i.no_arti
       AND no_orden IN (SELECT no_orden
                          FROM tapordee
                         WHERE no_cia = Pv_cia
                           AND no_orden = Pv_oc
                           AND estado IN ('E', 'I','F') -- Se adiciona para devoluciones pues debe considerar el estado finalizado.
                           AND NVL(ind_no_inv, 'N') = 'N'
                           AND no_prove = Pv_prove);
  END LOOP;

  OPEN C_Taporded ;
  FETCH C_Taporded
    INTO Ln_total;
  IF C_Taporded%NOTFOUND THEN
    CLOSE C_Taporded;
  ELSE
    CLOSE C_Taporded;
    IF Ln_total > 0 THEN
      -- Se actualiza orden compra NAF47_TNET
      UPDATE Tapordee
         SET estado = 'I' --- Si encuentra faltantes registra como incompleto
       WHERE no_cia = Pv_cia
         AND no_orden = Pv_oc;

      -- Se actualiza orden compra DB_COMPRAS
      UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA OC
      SET OC.ESTADO = 'IngresoParcial',
        OC.FECHA_ENTREGA = SYSDATE
      WHERE OC.SECUENCIA = Pv_Oc
      AND EXISTS (SELECT NULL
                  FROM DB_COMPRAS.ADMI_EMPRESA E
                  WHERE E.ID_EMPRESA = OC.EMPRESA_ID
                  AND E.CODIGO = Pv_cia );

    ELSE
      -- Se actualiza orden compra NAF47_TNET
      UPDATE Tapordee
         SET estado = 'F' --- Si encuentra igual o sobrantes registra como completo o finalizado
       WHERE no_cia = Pv_cia
         AND no_orden = Pv_oc;
      --
      -- Se actualiza orden compra DB_COMPRAS
      UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA OC
      SET OC.ESTADO = 'Finalizada',
        OC.FECHA_ENTREGA = SYSDATE
      WHERE OC.SECUENCIA = Pv_Oc
      AND EXISTS (SELECT NULL
                  FROM DB_COMPRAS.ADMI_EMPRESA E
                  WHERE E.ID_EMPRESA = OC.EMPRESA_ID
                  AND E.CODIGO = Pv_cia );
    END IF;
  END IF;
  --
  --
  IF Ln_EnBodega > 0 THEN
    IF C_ESTADO_PEDIDO%ISOPEN THEN
      CLOSE C_ESTADO_PEDIDO;
    END IF;
    --
    OPEN C_ESTADO_PEDIDO ( Lr_DatosCompra.Id_Pedido );
    FETCH C_ESTADO_PEDIDO INTO Lv_EstadoPedido;
    IF C_ESTADO_PEDIDO%NOTFOUND THEN
      Lv_EstadoPedido := NULL;
    END IF;
    CLOSE C_ESTADO_PEDIDO;
    --
    IF Lv_EstadoPedido IS NOT NULL THEN
      INK_PROCESA_PEDIDOS.P_REGISTRA_ESTADO_PEDIDO( 'DespachoParcial',
                                                    Lr_DatosCompra.Id_Pedido,
                                                    Lv_MensajeError);
      IF Lv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
  END IF;
  --
  --
EXCEPTION
  WHEN Le_Error THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
      'NAF',
      'INACT_ORDEN_COMPRA',
      Lv_MensajeError,
      --GEK_CONSULTA.F_RECUPERA_LOGIN,              emunoz 11012023
      LOWER(USER),                                            --emunoz 11012023
      SYSDATE,
      GEK_CONSULTA.F_RECUPERA_IP);

  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
      'NAF',
      'INACT_ORDEN_COMPRA',
      SQLERRM,
      --GEK_CONSULTA.F_RECUPERA_LOGIN,                 emunoz 11012023
      LOWER(USER),                                            --emunoz 11012023
      SYSDATE,
      GEK_CONSULTA.F_RECUPERA_IP);

END INACT_ORDEN_COMPRA;
/