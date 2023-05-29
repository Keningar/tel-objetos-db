CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REPORTE_VENDEDORES_VENTAS
AS
  /**
  * Documentación para F_R_TOTAL_TIPO_VENTAS
  * Obtiene el total de ventas de un vendedor de acuerdo a un tipo de venta
  *
  * @author Jorge Veliz <jlveliz@telconet.ec>
  * @version 1.0 20/10/2021
  *
  * PARAMETROS:
  * @Fv_tipoVenta   El tipo de la venta 'activas','cancel','rechazada','brutas'
  * @Fv_vendedor    Usuario vendedor
  * @Fv_empresa     Codigo de la empresa
  * @Fv_anio        Año de consulta
  * @Fv_mes         Mes de consulta
  */
  FUNCTION F_R_TOTAL_TIPO_VENTAS(
      Fv_tipoVenta VARCHAR2,
      Fv_vendedor  VARCHAR2,
      Fv_empresa   VARCHAR2,
      Fv_anio      VARCHAR2,
      Fv_mes       VARCHAR2)
    RETURN FLOAT ;
  /**
  * Documentación para F_R_COUNT_TIPO_VENTAS
  * Obtiene el conteo de ventas de un vendedor de acuerdo a un tipo de venta
  *
  * @author Jorge Veliz <jlveliz@telconet.ec>
  * @version 1.0 20/10/2021
  *
  * PARAMETROS:
  * @Fv_tipoVenta   El tipo de la venta 'activas','cancel','rechazada','brutas'
  * @Fv_vendedor    Usuario vendedor
  * @Fv_empresa     Codigo de la empresa
  * @Fv_anio        Año de consulta
  * @Fv_mes         Mes de consulta
  */
  FUNCTION F_R_COUNT_TIPO_VENTAS(
      Fv_tipoVenta VARCHAR2,
      Fv_vendedor  VARCHAR2,
      Fv_empresa   VARCHAR2,
      Fv_anio      VARCHAR2,
      Fv_mes       VARCHAR2)
    RETURN NUMBER ;
END CMKG_REPORTE_VENDEDORES_VENTAS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REPORTE_VENDEDORES_VENTAS
AS
  /**
  * Documentación para F_R_TOTAL_TIPO_VENTAS
  * Obtiene el total de ventas de un vendedor de acuerdo a un tipo de venta
  *
  * @author Jorge Veliz <jlveliz@telconet.ec>
  * @version 1.0 20/10/2021
  *
  * PARAMETROS:
  * @Fv_tipoVenta   El tipo de la venta 'activas','cancel','rechazada','brutas'
  * @Fv_vendedor    Usuario vendedor
  * @Fv_empresa     Codigo de la empresa
  * @Fv_anio        Año de consulta
  * @Fv_mes         Mes de consulta
  */
FUNCTION F_R_TOTAL_TIPO_VENTAS(
    Fv_tipoVenta VARCHAR2,
    Fv_vendedor  VARCHAR2,
    Fv_empresa   VARCHAR2,
    Fv_anio      VARCHAR2,
    Fv_mes       VARCHAR2)
  RETURN FLOAT
IS
  Lv_FechaInicio VARCHAR2(20);
  Lv_FechaFin    VARCHAR2(20);
  Lf_TotalVenta FLOAT;
  Lv_MsjResultado    VARCHAR2(120);
  Lv_UsuarioCreacion VARCHAR2(35):= 'telcos_reporte_vendedores_ventas';
  Lv_IpCreacion      VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  --Activa
  CURSOR Lc_TotalVentaActiva
  IS
    SELECT DISTINCT SUM((ins.PRECIO_VENTA * ins.CANTIDAD )) AS totalVenta
    FROM DB_COMERCIAL.INFO_PUNTO ip,
      DB_COMERCIAL.INFO_SERVICIO ins,
      DB_COMERCIAL.INFO_CONTRATO ic,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
      DB_COMERCIAL.INFO_EMPRESA_ROL ier,
      DB_GENERAL.ADMI_ROL ar,
      DB_GENERAL.ADMI_TIPO_ROL atr ,
      DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
    WHERE ip.ID_PUNTO             = ins.PUNTO_ID
    AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
    AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
    AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
    AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
    AND ar.ID_ROL                 = ier.ROL_ID
    AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
    AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
    AND ins.ES_VENTA              = 'S'
    AND ( ins.PLAN_ID            IN
      (SELECT ipc.id_plan
      FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
        DB_COMERCIAL.INFO_PLAN_CAB ipc,
        DB_COMERCIAL.ADMI_PRODUCTO ap
      WHERE ipc.id_plan     = ipd.plan_id
      AND ipc.id_plan       = ins.plan_id
      AND ap.id_producto    = ipd.producto_id
      AND ap.nombre_tecnico = 'INTERNET'
      )
  OR ins.PRODUCTO_ID IN
    (SELECT ap2.ID_PRODUCTO
    FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
    WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
    AND ap2.nombre_tecnico = 'INTERNET'
    ) )
    AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
    AND ieg.COD_EMPRESA  = Fv_empresa
    AND ip.USR_VENDEDOR  = Fv_vendedor
    AND ins.ID_SERVICIO IN
      (SELECT ins2.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO ins2,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh2
      WHERE ins2.ID_SERVICIO = insh2.SERVICIO_ID
      AND insh2.OBSERVACION LIKE 'Se confirmo el servicio%'
      AND ( insh2.ACCION     = 'confirmarServicio'
      OR insh2.ACCION       IS NULL )
      AND insh2.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
      )
    AND ins.ID_SERVICIO IN
      (SELECT ins3.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO ins3,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh3
      WHERE ins3.ID_SERVICIO = insh3.SERVICIO_ID
      AND insh3.OBSERVACION LIKE 'Se confirmo el servicio%'
      AND ( insh3.ACCION     = 'confirmarServicio'
      OR insh3.ACCION       IS NULL )
      AND insh3.fe_Creacion <= Lv_FechaFin
      )
    AND ins.estado = 'Activo' ;
    --Brutas
    CURSOR Lc_TotalVentaBruta
    IS
      SELECT DISTINCT SUM((ins.PRECIO_VENTA * ins.CANTIDAD )) AS totalVentas
      FROM DB_COMERCIAL.INFO_PUNTO ip,
        DB_COMERCIAL.INFO_SERVICIO ins,
        DB_COMERCIAL.INFO_CONTRATO ic,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
        DB_COMERCIAL.INFO_EMPRESA_ROL ier,
        DB_GENERAL.ADMI_ROL ar,
        DB_GENERAL.ADMI_TIPO_ROL atr ,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
      WHERE ip.ID_PUNTO             = ins.PUNTO_ID
      AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
      AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
      AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
      AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
      AND ar.ID_ROL                 = ier.ROL_ID
      AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
      AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
      AND ins.ES_VENTA              = 'S'
      AND ( ins.PLAN_ID            IN
        (SELECT ipc.id_plan
        FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
          DB_COMERCIAL.INFO_PLAN_CAB ipc,
          DB_COMERCIAL.ADMI_PRODUCTO ap
        WHERE ipc.id_plan     = ipd.plan_id
        AND ipc.id_plan       = ins.plan_id
        AND ap.id_producto    = ipd.producto_id
        AND ap.nombre_tecnico = 'INTERNET'
        )
    OR ins.PRODUCTO_ID IN
      (SELECT ap2.ID_PRODUCTO
      FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
      WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
      AND ap2.nombre_tecnico = 'INTERNET'
      ) )
      AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
      AND ieg.COD_EMPRESA  = Fv_empresa
      AND ip.USR_VENDEDOR  = Fv_vendedor
      AND ins.estado NOT  IN ( 'Inactivo','Rechazada','Cancel','Eliminado','In-Corte','Anulado','In-Temp' )
      AND ins.ID_SERVICIO IN
        (SELECT ins4.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ins4,
          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh5
        WHERE ins4.ID_SERVICIO = insh5.SERVICIO_ID
        AND insh5.OBSERVACION LIKE 'Se solicito planificacion%'
        AND insh5.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
        )
      AND ins.ID_SERVICIO IN
        (SELECT ins6.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ins6,
          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh7
        WHERE ins6.ID_SERVICIO = insh7.SERVICIO_ID
        AND insh7.OBSERVACION LIKE 'Se solicito planificacion%'
        AND insh7.fe_Creacion <= Lv_FechaFin
        );
      -- Canceladas
      CURSOR Lc_TotalVentaCancel
      IS
        SELECT DISTINCT SUM((ins.PRECIO_VENTA * ins.CANTIDAD )) AS totalVentas
        FROM DB_COMERCIAL.INFO_PUNTO ip,
          DB_COMERCIAL.INFO_SERVICIO ins,
          DB_COMERCIAL.INFO_CONTRATO ic,
          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
          DB_COMERCIAL.INFO_EMPRESA_ROL ier,
          DB_GENERAL.ADMI_ROL ar,
          DB_GENERAL.ADMI_TIPO_ROL atr ,
          DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
        WHERE ip.ID_PUNTO             = ins.PUNTO_ID
        AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
        AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
        AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
        AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
        AND ar.ID_ROL                 = ier.ROL_ID
        AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
        AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
        AND ins.ES_VENTA              = 'S'
        AND ( ins.PLAN_ID            IN
          (SELECT ipc.id_plan
          FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
            DB_COMERCIAL.INFO_PLAN_CAB ipc,
            DB_COMERCIAL.ADMI_PRODUCTO ap
          WHERE ipc.id_plan     = ipd.plan_id
          AND ipc.id_plan       = ins.plan_id
          AND ap.id_producto    = ipd.producto_id
          AND ap.nombre_tecnico = 'INTERNET'
          )
      OR ins.PRODUCTO_ID IN
        (SELECT ap2.ID_PRODUCTO
        FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
        WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
        AND ap2.nombre_tecnico = 'INTERNET'
        ) )
        AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
        AND ieg.COD_EMPRESA  = Fv_empresa
        AND ip.USR_VENDEDOR  = Fv_vendedor
        AND ip.FE_CREACION  >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
        AND ip.FE_CREACION  <= Lv_FechaFin
        AND ins.ID_SERVICIO IN
          (SELECT ins_1.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ins_1,
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_1
          WHERE ins_1.ID_SERVICIO = insh_1.SERVICIO_ID
          AND insh_1.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
          AND insh_1.estado      IN ('Cancelado','Cancel')
          )
        AND ins.ID_SERVICIO IN
          (SELECT ins_2.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ins_2,
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_2
          WHERE ins_2.ID_SERVICIO = insh_2.SERVICIO_ID
          AND insh_2.fe_Creacion <= Lv_FechaFin
          AND insh_2.estado      IN ('Cancelado','Cancel')
          );
        --Rechazadas
        CURSOR Lc_TotalVentaRechazada
        IS
          SELECT DISTINCT SUM((ins.PRECIO_VENTA * ins.CANTIDAD )) AS totalVenta
          FROM DB_COMERCIAL.INFO_PUNTO ip,
            DB_COMERCIAL.INFO_SERVICIO ins,
            DB_COMERCIAL.INFO_CONTRATO ic,
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
            DB_COMERCIAL.INFO_EMPRESA_ROL ier,
            DB_GENERAL.ADMI_ROL ar,
            DB_GENERAL.ADMI_TIPO_ROL atr ,
            DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
          WHERE ip.ID_PUNTO             = ins.PUNTO_ID
          AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
          AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
          AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
          AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
          AND ar.ID_ROL                 = ier.ROL_ID
          AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
          AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
          AND ins.ES_VENTA              = 'S'
          AND ( ins.PLAN_ID            IN
            (SELECT ipc.id_plan
            FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
              DB_COMERCIAL.INFO_PLAN_CAB ipc,
              DB_COMERCIAL.ADMI_PRODUCTO ap
            WHERE ipc.id_plan     = ipd.plan_id
            AND ipc.id_plan       = ins.plan_id
            AND ap.id_producto    = ipd.producto_id
            AND ap.nombre_tecnico = 'INTERNET'
            )
        OR ins.PRODUCTO_ID IN
          (SELECT ap2.ID_PRODUCTO
          FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
          WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
          AND ap2.nombre_tecnico = 'INTERNET'
          ) )
          AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
          AND ieg.COD_EMPRESA  = Fv_empresa  --(:PARAM EMPRESA)
          AND ip.USR_VENDEDOR  = Fv_vendedor -- (PARAM :usuarioVendedor)
          AND ip.FE_CREACION  >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
          AND ip.FE_CREACION  <= Lv_FechaFin
          AND ins.ID_SERVICIO IN
            (SELECT ins_1.ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ins_1,
              DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_1
            WHERE ins_1.ID_SERVICIO = insh_1.SERVICIO_ID
            AND insh_1.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
            AND insh_1.estado      IN ('Rechazada','Anulado') -- (PARAM :estadoServiciosTipoVenta)
            )
          AND ins.ID_SERVICIO IN
            (SELECT ins_2.ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ins_2,
              DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_2
            WHERE ins_2.ID_SERVICIO = insh_2.SERVICIO_ID
            AND insh_2.fe_Creacion <= Lv_FechaFin
            AND insh_2.estado      IN ('Rechazada','Anulado')
            );
  BEGIN
    Lf_TotalVenta   := 0;
    Lv_FechaInicio  := Fv_anio || '/' || Fv_mes || '/01';
    Lv_FechaFin     := ADD_MONTHS(TO_DATE(Lv_FechaInicio,'YYYY/MM/DD'),1);
    Lv_MsjResultado := '';
    IF (Fv_tipoVenta = 'activas') THEN
      --ACTIVAS
      OPEN Lc_TotalVentaActiva;
      FETCH Lc_TotalVentaActiva INTO Lf_TotalVenta;
      IF Lc_TotalVentaActiva%notfound THEN
        Lf_TotalVenta := 0.00;
      END IF;
      CLOSE Lc_TotalVentaActiva;
      -- BRUTAS
    ELSIF (Fv_tipoVenta = 'brutas') THEN
      OPEN Lc_TotalVentaBruta;
      FETCH Lc_TotalVentaBruta INTO Lf_TotalVenta;
      IF Lc_TotalVentaBruta%notfound THEN
        Lf_TotalVenta := 0.00;
      END IF;
      CLOSE Lc_TotalVentaBruta;
      --Canceladas
    ELSIF (Fv_tipoVenta = 'cancel') THEN
      OPEN Lc_TotalVentaCancel;
      FETCH Lc_TotalVentaCancel INTO Lf_TotalVenta;
      IF Lc_TotalVentaCancel%notfound THEN
        Lf_TotalVenta := 0.00;
      END IF;
      CLOSE Lc_TotalVentaCancel;
      -- Rechazadas
    ELSIF (Fv_tipoVenta = 'rechazada') THEN
      OPEN Lc_TotalVentaRechazada;
      FETCH Lc_TotalVentaRechazada INTO Lf_TotalVenta;
      IF Lc_TotalVentaRechazada%notfound THEN
        Lf_TotalVenta := 0.00;
      END IF;
      CLOSE Lc_TotalVentaRechazada;
    END IF;
    IF Lf_TotalVenta IS NULL THEN
      Lf_TotalVenta  := 0.00;
    END IF;
  RETURN Lf_TotalVenta;
  EXCEPTION
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Hubo un error al tratar de extraer los datos de ' || Fv_tipoVenta;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'CMKG_REPORTE_VENDEDORES_VENTAS.F_R_TOTAL_TIPO_VENTAS', SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), Lv_UsuarioCreacion, SYSDATE, Lv_IpCreacion);
      RETURN 0;
END F_R_TOTAL_TIPO_VENTAS;
/**
* Documentación para F_R_COUNT_TIPO_VENTAS
* Obtiene el conteo de ventas de un vendedor de acuerdo a un tipo de venta
*
* @author Jorge Veliz <jlveliz@telconet.ec>
* @version 1.0 20/10/2021
*
* PARAMETROS:
* @Fv_tipoVenta   El tipo de la venta 'activas','cancel','rechazada','brutas'
* @Fv_vendedor    Usuario vendedor
* @Fv_empresa     Codigo de la empresa
* @Fv_anio        Año de consulta
* @Fv_mes         Mes de consulta
*/
FUNCTION F_R_COUNT_TIPO_VENTAS(
    Fv_tipoVenta VARCHAR2,
    Fv_vendedor  VARCHAR2,
    Fv_empresa   VARCHAR2,
    Fv_anio      VARCHAR2,
    Fv_mes       VARCHAR2)
  RETURN NUMBER
IS
  Lv_FechaInicio     VARCHAR2(20);
  Lv_FechaFin        VARCHAR2(20);
  Ln_Total           NUMBER;
  Lv_MsjResultado    VARCHAR2(120);
  Lv_UsuarioCreacion VARCHAR2(35):= 'telcos_reporte_vendedores_ventas';
  Lv_IpCreacion      VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  --Activas
  CURSOR Lc_CountVentaActivas
  IS
    SELECT COUNT(DISTINCT ins.ID_SERVICIO) AS total
    FROM DB_COMERCIAL.INFO_PUNTO ip,
      DB_COMERCIAL.INFO_SERVICIO ins,
      DB_COMERCIAL.INFO_CONTRATO ic,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
      DB_COMERCIAL.INFO_EMPRESA_ROL ier,
      DB_GENERAL.ADMI_ROL ar,
      DB_GENERAL.ADMI_TIPO_ROL atr ,
      DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
    WHERE ip.ID_PUNTO             = ins.PUNTO_ID
    AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
    AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
    AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
    AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
    AND ar.ID_ROL                 = ier.ROL_ID
    AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
    AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
    AND ins.ES_VENTA              = 'S'
    AND ( ins.PLAN_ID            IN
      (SELECT ipc.id_plan
      FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
        DB_COMERCIAL.INFO_PLAN_CAB ipc,
        DB_COMERCIAL.ADMI_PRODUCTO ap
      WHERE ipc.id_plan     = ipd.plan_id
      AND ipc.id_plan       = ins.plan_id
      AND ap.id_producto    = ipd.producto_id
      AND ap.nombre_tecnico = 'INTERNET'
      )
  OR ins.PRODUCTO_ID IN
    (SELECT ap2.ID_PRODUCTO
    FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
    WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
    AND ap2.nombre_tecnico = 'INTERNET'
    ) )
    AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
    AND ieg.COD_EMPRESA  = Fv_empresa
    AND ip.USR_VENDEDOR  = Fv_vendedor
    AND ins.ID_SERVICIO IN
      (SELECT ins2.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO ins2,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh2
      WHERE ins2.ID_SERVICIO = insh2.SERVICIO_ID
      AND insh2.OBSERVACION LIKE 'Se confirmo el servicio%'
      AND ( insh2.ACCION     = 'confirmarServicio'
      OR insh2.ACCION       IS NULL )
      AND insh2.fe_Creacion >= TO_DATE(Lv_FechaInicio,'YYYY/MM/DD')
      )
    AND ins.ID_SERVICIO IN
      (SELECT ins3.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO ins3,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh3
      WHERE ins3.ID_SERVICIO = insh3.SERVICIO_ID
      AND insh3.OBSERVACION LIKE 'Se confirmo el servicio%'
      AND ( insh3.ACCION     = 'confirmarServicio'
      OR insh3.ACCION       IS NULL )
      AND insh3.fe_Creacion <= Lv_FechaFin
      )
    AND ins.estado = 'Activo' ;
    --Brutas
    CURSOR Lc_CountVentaBrutas
    IS
      SELECT COUNT(DISTINCT ins.ID_SERVICIO) AS total
      FROM DB_COMERCIAL.INFO_PUNTO ip,
        DB_COMERCIAL.INFO_SERVICIO ins,
        DB_COMERCIAL.INFO_CONTRATO ic,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
        DB_COMERCIAL.INFO_EMPRESA_ROL ier,
        DB_GENERAL.ADMI_ROL ar,
        DB_GENERAL.ADMI_TIPO_ROL atr ,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
      WHERE ip.ID_PUNTO             = ins.PUNTO_ID
      AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
      AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
      AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
      AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
      AND ar.ID_ROL                 = ier.ROL_ID
      AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
      AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
      AND ins.ES_VENTA              = 'S'
      AND ( ins.PLAN_ID            IN
        (SELECT ipc.id_plan
        FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
          DB_COMERCIAL.INFO_PLAN_CAB ipc,
          DB_COMERCIAL.ADMI_PRODUCTO ap
        WHERE ipc.id_plan     = ipd.plan_id
        AND ipc.id_plan       = ins.plan_id
        AND ap.id_producto    = ipd.producto_id
        AND ap.nombre_tecnico = 'INTERNET'
        )
    OR ins.PRODUCTO_ID IN
      (SELECT ap2.ID_PRODUCTO
      FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
      WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
      AND ap2.nombre_tecnico = 'INTERNET'
      ) )
      AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
      AND ieg.COD_EMPRESA  = Fv_empresa
      AND ip.USR_VENDEDOR  = Fv_vendedor
      AND ins.estado NOT  IN ( 'Inactivo','Rechazada','Cancel','Eliminado','In-Corte','Anulado','In-Temp' )
      AND ins.ID_SERVICIO IN
        (SELECT ins4.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ins4,
          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh5
        WHERE ins4.ID_SERVICIO = insh5.SERVICIO_ID
        AND insh5.OBSERVACION LIKE 'Se solicito planificacion%' -- (:observacion)
        AND insh5.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
        )
      AND ins.ID_SERVICIO IN
        (SELECT ins6.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ins6,
          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh7
        WHERE ins6.ID_SERVICIO = insh7.SERVICIO_ID
        AND insh7.OBSERVACION LIKE 'Se solicito planificacion%'
        AND insh7.fe_Creacion <= Lv_FechaFin
        );
      --Canceladas
      CURSOR Lc_CountVentaCancel
      IS
        SELECT COUNT(DISTINCT ins.ID_SERVICIO)
        INTO Ln_Total
        FROM DB_COMERCIAL.INFO_PUNTO ip,
          DB_COMERCIAL.INFO_SERVICIO ins,
          DB_COMERCIAL.INFO_CONTRATO ic,
          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
          DB_COMERCIAL.INFO_EMPRESA_ROL ier,
          DB_GENERAL.ADMI_ROL ar,
          DB_GENERAL.ADMI_TIPO_ROL atr ,
          DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
        WHERE ip.ID_PUNTO             = ins.PUNTO_ID
        AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
        AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
        AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
        AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
        AND ar.ID_ROL                 = ier.ROL_ID
        AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
        AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
        AND ins.ES_VENTA              = 'S'
        AND ( ins.PLAN_ID            IN
          (SELECT ipc.id_plan
          FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
            DB_COMERCIAL.INFO_PLAN_CAB ipc,
            DB_COMERCIAL.ADMI_PRODUCTO ap
          WHERE ipc.id_plan     = ipd.plan_id
          AND ipc.id_plan       = ins.plan_id
          AND ap.id_producto    = ipd.producto_id
          AND ap.nombre_tecnico = 'INTERNET'
          )
      OR ins.PRODUCTO_ID IN
        (SELECT ap2.ID_PRODUCTO
        FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
        WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
        AND ap2.nombre_tecnico = 'INTERNET'
        ) )
        AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
        AND ieg.COD_EMPRESA  = Fv_empresa
        AND ip.USR_VENDEDOR  = Fv_vendedor
        AND ip.FE_CREACION  >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
        AND ip.FE_CREACION  <= Lv_FechaFin
        AND ins.ID_SERVICIO IN
          (SELECT ins_1.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ins_1,
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_1
          WHERE ins_1.ID_SERVICIO = insh_1.SERVICIO_ID
          AND insh_1.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
          AND insh_1.estado      IN ('Cancelado','Cancel')
          )
        AND ins.ID_SERVICIO IN
          (SELECT ins_2.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ins_2,
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_2
          WHERE ins_2.ID_SERVICIO = insh_2.SERVICIO_ID
          AND insh_2.fe_Creacion <= Lv_FechaFin
          AND insh_2.estado      IN ('Cancelado','Cancel')
          );
        --Rechazada
        CURSOR Lc_CountVentaReChazada
        IS
          SELECT COUNT(DISTINCT ins.ID_SERVICIO) AS total
          FROM DB_COMERCIAL.INFO_PUNTO ip,
            DB_COMERCIAL.INFO_SERVICIO ins,
            DB_COMERCIAL.INFO_CONTRATO ic,
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
            DB_COMERCIAL.INFO_EMPRESA_ROL ier,
            DB_GENERAL.ADMI_ROL ar,
            DB_GENERAL.ADMI_TIPO_ROL atr ,
            DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
          WHERE ip.ID_PUNTO             = ins.PUNTO_ID
          AND ic.PERSONA_EMPRESA_ROL_ID = ip.PERSONA_EMPRESA_ROL_ID
          AND iper.ID_PERSONA_ROL       = ip.PERSONA_EMPRESA_ROL_ID
          AND ier.ID_EMPRESA_ROL        = iper.EMPRESA_ROL_ID
          AND iper.EMPRESA_ROL_ID       = ier.ID_EMPRESA_ROL
          AND ar.ID_ROL                 = ier.ROL_ID
          AND ar.TIPO_ROL_ID            = atr.ID_TIPO_ROL
          AND atr.DESCRIPCION_TIPO_ROL  = 'Cliente'
          AND ins.ES_VENTA              = 'S'
          AND ( ins.PLAN_ID            IN
            (SELECT ipc.id_plan
            FROM DB_COMERCIAL.INFO_PLAN_DET ipd,
              DB_COMERCIAL.INFO_PLAN_CAB ipc,
              DB_COMERCIAL.ADMI_PRODUCTO ap
            WHERE ipc.id_plan     = ipd.plan_id
            AND ipc.id_plan       = ins.plan_id
            AND ap.id_producto    = ipd.producto_id
            AND ap.nombre_tecnico = 'INTERNET'
            )
        OR ins.PRODUCTO_ID IN
          (SELECT ap2.ID_PRODUCTO
          FROM DB_COMERCIAL.ADMI_PRODUCTO ap2
          WHERE ap2.ID_PRODUCTO  = ins.PRODUCTO_ID
          AND ap2.nombre_tecnico = 'INTERNET'
          ) )
          AND ieg.COD_EMPRESA  = ier.EMPRESA_COD
          AND ieg.COD_EMPRESA  = Fv_empresa
          AND ip.USR_VENDEDOR  = Fv_vendedor
          AND ip.FE_CREACION  >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
          AND ip.FE_CREACION  <= Lv_FechaFin
          AND ins.ID_SERVICIO IN
            (SELECT ins_1.ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ins_1,
              DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_1
            WHERE ins_1.ID_SERVICIO = insh_1.SERVICIO_ID
            AND insh_1.fe_Creacion >= TO_DATE(Lv_FechaInicio, 'YYYY/MM/DD')
            AND insh_1.estado      IN ('Rechazada','Anulado')
            )
          AND ins.ID_SERVICIO IN
            (SELECT ins_2.ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ins_2,
              DB_COMERCIAL.INFO_SERVICIO_HISTORIAL insh_2
            WHERE ins_2.ID_SERVICIO = insh_2.SERVICIO_ID
            AND insh_2.fe_Creacion <= Lv_FechaFin
            AND insh_2.estado      IN ('Rechazada','Anulado')
            );
        BEGIN
          Ln_Total       := 0;
          Lv_FechaInicio := Fv_anio || '/' || Fv_mes || '/01';
          Lv_FechaFin    := ADD_MONTHS(TO_DATE(Lv_FechaInicio,'YYYY/MM/DD'),1);
          --Activas
          IF(Fv_tipoVenta = 'activas') THEN
            OPEN Lc_CountVentaActivas;
            FETCH Lc_CountVentaActivas INTO Ln_Total;
            IF Lc_CountVentaActivas%notfound THEN
              Ln_Total := 0;
            END IF;
            CLOSE Lc_CountVentaActivas;
            --Brutas
          ELSIF (Fv_tipoVenta = 'brutas') THEN
            OPEN Lc_CountVentaBrutas;
            FETCH Lc_CountVentaBrutas INTO Ln_Total;
            IF Lc_CountVentaBrutas%notfound THEN
              Ln_Total := 0;
            END IF;
            CLOSE Lc_CountVentaBrutas;
            -- Cancel
          ELSIF(Fv_tipoVenta = 'cancel') THEN
            OPEN Lc_CountVentaCancel;
            FETCH Lc_CountVentaCancel INTO Ln_Total;
            IF Lc_CountVentaCancel%notfound THEN
              Ln_Total := 0.00;
            END IF;
            CLOSE Lc_CountVentaCancel;
            -- Rechazadas
          ELSIF(Fv_tipoVenta = 'rechazada') THEN
            OPEN Lc_CountVentaReChazada;
            FETCH Lc_CountVentaReChazada INTO Ln_Total;
            IF Lc_CountVentaReChazada%notfound THEN
              Ln_Total := 0;
            END IF;
            CLOSE Lc_CountVentaReChazada;
          END IF;
          IF Ln_Total IS NULL THEN
            Ln_Total  := 0;
          END IF ;
          RETURN Ln_Total;
        EXCEPTION
        WHEN OTHERS THEN
          Lv_MsjResultado := 'Hubo un error al tratar de extraer los datos de ' || Fv_tipoVenta;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'CMKG_REPORTE_VENDEDORES_VENTAS.F_R_COUNT_TIPO_VENTAS', SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), Lv_UsuarioCreacion, SYSDATE, Lv_IpCreacion);
          RETURN 0;
        END F_R_COUNT_TIPO_VENTAS;
END CMKG_REPORTE_VENDEDORES_VENTAS;
/