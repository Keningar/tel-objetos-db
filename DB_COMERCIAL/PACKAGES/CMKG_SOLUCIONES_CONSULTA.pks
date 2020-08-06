SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_SOLUCIONES_CONSULTA AS

  /**
   * Documentación para el procedimiento 'P_OBTENER_DETALLE_SOLUCION'.
   *
   * Método encargado de obtener el detalle de una solución.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 12-06-2020
   */
  PROCEDURE P_OBTENER_DETALLE_SOLUCION(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);

  /**
   * Documentación para el procedimiento 'F_OBTENER_CORES_REFERENTES'.
   *
   * Método encargado de obtener los cores referentes del detalle de una solución.
   *
   * @param Cn_IdSolucionDet  IN  NUMBER Recibe el id del detalle de la solución.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 13-04-2020
   */
  FUNCTION F_OBTENER_CORES_REFERENTES(Cn_IdSolucionDet NUMBER) RETURN VARCHAR2;

  /**
   * Documentación para el procedimiento 'P_OBTENER_SOLUCIONES_PUNTO'.
   *
   * Método encargado de obtener las soluciones de un punto.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 13-04-2020
   */
  PROCEDURE P_OBTENER_SOLUCIONES_PUNTO(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);

  /**
   * Documentación para el procedimiento 'P_OBTENER_NUMERO_SOLUCION'.
   *
   * Método encargado de obtener el número de solución.
   *
   * @param Pn_NumeroSolucion OUT NUMBER   Retorna el número de solución.
   * @param Pv_Status         OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 13-04-2020
   */
  PROCEDURE P_OBTENER_NUMERO_SOLUCION(Pn_NumeroSolucion OUT NUMBER,
                                      Pv_Status         OUT VARCHAR2,
                                      Pv_Mensaje        OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_OBTENER_INFO_CUARTO_TI_CAB'.
   *
   * Método encargado de retornar la información general del cuarto de TI del servicio.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 07-05-2020
   */
  PROCEDURE P_OBTENER_INFO_CUARTO_TI_CAB(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR);

  /**
   * Documentación para el procedimiento 'P_OBTENER_INFO_CUARTO_TI_DET'.
   *
   * Método encargado de retornar el detalle del cuarto de TI del servicio.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 07-05-2020
   */
  PROCEDURE P_OBTENER_INFO_CUARTO_TI_DET(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR);

END CMKG_SOLUCIONES_CONSULTA;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_SOLUCIONES_CONSULTA AS
----
----
  PROCEDURE P_OBTENER_DETALLE_SOLUCION(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)
  IS

    --Variables Locales.
    Ln_IdSolucionCab  NUMBER;
    Ln_IdServicio     NUMBER;
    Ln_NumeroSolucion NUMBER;
    Ln_IdPunto        NUMBER;
    Lv_Estado         VARCHAR2(50);
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdSolucionCab  := APEX_JSON.GET_NUMBER(P_PATH   => 'idSolucionCab');
    Ln_IdServicio     := APEX_JSON.GET_NUMBER(P_PATH   => 'idServicio');
    Ln_NumeroSolucion := APEX_JSON.GET_NUMBER(P_PATH   => 'numeroSolucion');
    Ln_IdPunto        := APEX_JSON.GET_NUMBER(P_PATH   => 'idPunto');
    Lv_Estado         := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');

    -- VALIDACIONES
    IF (Ln_IdSolucionCab  IS NULL AND Ln_IdServicio IS NULL AND
        Ln_NumeroSolucion IS NULL AND Ln_IdPunto    IS NULL) OR Lv_Estado IS NULL THEN
      Lv_Mensaje := 'Parámetros incompletos para consultar el detalle de la solución.';
      RAISE Le_Exception;
    END IF;

    --Query
    OPEN Pcl_Response FOR
      SELECT
        ISCAB.PUNTO_ID             AS idPunto,
        ISE.ID_SERVICIO            AS idServicio,
        ADPRO.ID_PRODUCTO          AS idProducto,
        ADPRO.DESCRIPCION_PRODUCTO AS descripcion,
        ROUND(ISE.PRECIO_VENTA,2)  AS precio,
        ISE.ESTADO                 AS estado,
        ISCAB.ID_SOLUCION_CAB      AS idSolucionCab,
        ISCAB.NUMERO_SOLUCION      AS numeroSolucion,
        ISCAB.NOMBRE_SOLUCION      AS nombreSolucion,
        ISDET.ID_SOLUCION_DET      AS idSolucionDet,
        ISDET.TIPO_SOLUCION        AS tipoSolucion,
        TO_CHAR(ISE.FE_CREACION,'DD-MM-RRRR HH24:MI') AS feCreacion,
        CASE
          WHEN ISDET.ES_CORE = 'SI'
          THEN 'S'
          ELSE 'N'
        END AS esCore,
        CASE
          WHEN ISDET.ES_PREFERENCIAL = 'SI'
          THEN 'S'
          ELSE 'N'
        END AS esPreferencial,
        (
          SELECT 
            DET.VALOR3
          FROM 
            DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
            DB_GENERAL.ADMI_PARAMETRO_DET DET
          WHERE CAB.NOMBRE_PARAMETRO = 'GRUPO PRODUCTOS CON SUB TIPO SOLUCION'
            AND CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
            AND DET.VALOR1           = ISDET.TIPO_SOLUCION
            AND DET.ESTADO          IN ('Activo','Anulado')
        ) AS segmento,
        (
          SELECT
            CASE
              WHEN APC.ID_PRODUCTO_CARACTERISITICA IS NULL
              THEN 'N'
              ELSE 'S'
            END CONTIENE
          FROM
            DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
            DB_COMERCIAL.ADMI_CARACTERISTICA          AC
          WHERE APC.PRODUCTO_ID               = ADPRO.ID_PRODUCTO
            AND APC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
            AND AC.DESCRIPCION_CARACTERISTICA IN ('REQUERIDO_HOUSING','ES_LICENCIAMIENTO_SO')
        ) contieneCarcateristica,
        (
          SELECT 
            DETALLE.ID_DETALLE_SOLICITUD
          FROM
            DB_COMERCIAL.INFO_DETALLE_SOLICITUD DETALLE,
            DB_COMERCIAL.ADMI_TIPO_SOLICITUD    TIPO
          WHERE
            DETALLE.TIPO_SOLICITUD_ID       =  TIPO.ID_TIPO_SOLICITUD
            AND DETALLE.SERVICIO_ID         =  ISE.ID_SERVICIO
            AND TIPO.DESCRIPCION_SOLICITUD  = 'SOLICITUD INFO TECNICA'
            AND DETALLE.ESTADO             <> 'Eliminada'
            AND ROWNUM                      =  1
        ) solicitud,
        DB_COMERCIAL.CMKG_SOLUCIONES_CONSULTA.F_OBTENER_CORES_REFERENTES(ISDET.ID_SOLUCION_DET) AS coresReferentes
      FROM
        DB_COMERCIAL.INFO_SOLUCION_CAB ISCAB,
        DB_COMERCIAL.INFO_SOLUCION_DET ISDET,
        DB_COMERCIAL.INFO_SERVICIO     ISE,
        DB_COMERCIAL.ADMI_PRODUCTO     ADPRO
      WHERE
        ISCAB.ID_SOLUCION_CAB     = ISDET.SOLUCION_CAB_ID
        AND ISDET.SERVICIO_ID     = ISE.ID_SERVICIO
        AND ISE.PRODUCTO_ID       = ADPRO.ID_PRODUCTO
        AND ISCAB.ESTADO          = Lv_Estado
        AND ISDET.ESTADO          = Lv_Estado
        AND ISCAB.ID_SOLUCION_CAB = NVL(Ln_IdSolucionCab,ISCAB.ID_SOLUCION_CAB)
        AND ISE.ID_SERVICIO       = NVL(Ln_IdServicio,ISE.ID_SERVICIO)
        AND ISCAB.NUMERO_SOLUCION = NVL(Ln_NumeroSolucion,ISCAB.NUMERO_SOLUCION)
        AND ISCAB.PUNTO_ID        = NVL(Ln_IdPunto,ISCAB.PUNTO_ID)
      ORDER BY ISE.FE_CREACION DESC,ISDET.TIPO_SOLUCION;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;
    WHEN OTHERS THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;

  END P_OBTENER_DETALLE_SOLUCION;
----
----
  FUNCTION F_OBTENER_CORES_REFERENTES(Cn_IdSolucionDet NUMBER)
    RETURN VARCHAR2
  IS
    Lv_CoresReferentes VARCHAR2(3000);
  BEGIN
    SELECT
      (LISTAGG(TIPO_SOLUCION,'|') WITHIN GROUP (ORDER BY TIPO_SOLUCION)) INTO Lv_CoresReferentes
    FROM
    (
      SELECT
        ISDET.TIPO_SOLUCION
      FROM
        DB_COMERCIAL.INFO_SOLUCION_REFERENCIA ISREF,
        DB_COMERCIAL.INFO_SOLUCION_DET        ISDET
      WHERE
        ISREF.SOLUCION_DET_ID_A     =  Cn_IdSolucionDet
        AND ISREF.SOLUCION_DET_ID_B =  ISDET.ID_SOLUCION_DET
        AND ISREF.ESTADO            = 'Activo'
        AND ISDET.ESTADO            = 'Activo'
      GROUP BY ISDET.TIPO_SOLUCION
    );
    RETURN Lv_CoresReferentes;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END F_OBTENER_CORES_REFERENTES;
----
----
  PROCEDURE P_OBTENER_SOLUCIONES_PUNTO(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)
  IS

    --Variables Locales.
    Ln_PuntoId    NUMBER;
    Lv_Estado     VARCHAR2(50);
    Le_Exception  EXCEPTION;
    Lv_Mensaje    VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_PuntoId := APEX_JSON.GET_NUMBER(P_PATH   => 'puntoId');
    Lv_Estado  := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');

    -- VALIDACIONES
    IF Ln_PuntoId IS NULL OR Lv_Estado IS NULL THEN
      Lv_Mensaje := 'Parámetros incompletos para consultar las soluciones del punto.';
      RAISE Le_Exception;
    END IF;

    --Query
    OPEN Pcl_Response FOR
      SELECT
        ISCAB.ID_SOLUCION_CAB AS idSolucionCab,
        ISCAB.PUNTO_ID        AS puntoId,
        ISCAB.NUMERO_SOLUCION AS numeroSolucion,
        ISCAB.NOMBRE_SOLUCION AS nombreSolucion,
        (
          SELECT
            ROUND(SUM(ISE.PRECIO_VENTA),2)
          FROM
            DB_COMERCIAL.INFO_SERVICIO     ISE,
            DB_COMERCIAL.INFO_SOLUCION_DET ISDET
          WHERE ISDET.SOLUCION_CAB_ID = ISCAB.ID_SOLUCION_CAB
            AND ISDET.SERVICIO_ID     = ISE.ID_SERVICIO
            AND ISDET.ESTADO          = Lv_Estado
        ) totalSolucion
      FROM
        DB_COMERCIAL.INFO_SOLUCION_CAB ISCAB
      WHERE
        ISCAB.PUNTO_ID   = Ln_PuntoId
        AND ISCAB.ESTADO = Lv_Estado
      ORDER BY
        ISCAB.NUMERO_SOLUCION DESC;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;
    WHEN OTHERS THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;

  END P_OBTENER_SOLUCIONES_PUNTO;
----
----
  PROCEDURE P_OBTENER_NUMERO_SOLUCION(Pn_NumeroSolucion OUT NUMBER,
                                      Pv_Status         OUT VARCHAR2,
                                      Pv_Mensaje        OUT VARCHAR2) IS

  BEGIN

    Pv_Status         := 'OK';
    Pv_Mensaje        := 'Transación exitosa';
    Pn_NumeroSolucion :=  DB_COMERCIAL.SEQ_GRUPO_PRODUCTO.NEXTVAL;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_NumeroSolucion :=  0;

  END P_OBTENER_NUMERO_SOLUCION;
----
----
  PROCEDURE P_OBTENER_INFO_CUARTO_TI_CAB(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR)
  IS

    --Variables Locales.
    Ln_ServicioId  NUMBER;
    Le_Exception   EXCEPTION;
    Lv_Mensaje     VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ServicioId := APEX_JSON.get_number(p_path => 'servicioId');

    -- VALIDACIONES
    IF Ln_ServicioId IS NULL THEN
      Lv_Mensaje := 'El parámetro servicioId esta vacío';
      RAISE Le_Exception;
    END IF;

    --Query
    OPEN Pcl_Response FOR

      --RACK
      SELECT
        IRC.DESCRIPCION_RECURSO   AS descripcionRecurso,
        ATE1.NOMBRE_TIPO_ELEMENTO AS nombreTipoElemento,
        IEL2.ID_ELEMENTO          AS idFila,
        IEL2.NOMBRE_ELEMENTO      AS nombreFila,
        IEL1.ID_ELEMENTO          AS idRack,
        IEL1.NOMBRE_ELEMENTO      AS nombreRack,
        (
          SELECT
            COUNT(*)
          FROM
            DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE
          WHERE IRE.ELEMENTO_ID_A = IEL1.ID_ELEMENTO
            AND IRE.ESTADO        = 'Activo'
        ) reservados
      FROM
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB    IRC,
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET    IRD,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO          IEL1,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   AME1,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     ATE1,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO          IEL2,
        DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE2,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   AME2,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     ATE2,
        DB_COMERCIAL.INFO_SERVICIO                ISE,
        DB_COMERCIAL.INFO_PUNTO                   IPU,
        DB_COMERCIAL.ADMI_SECTOR                  ASE,
        DB_COMERCIAL.ADMI_PARROQUIA               APA,
        DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,
        DB_INFRAESTRUCTURA.INFO_UBICACION              IUB,
        DB_COMERCIAL.ADMI_PARROQUIA                    APA2
      WHERE
        IRC.ID_SERVICIO_RECURSO_CAB   =  IRD.SERVICIO_RECURSO_CAB_ID
        AND ISE.ID_SERVICIO           =  IRC.SERVICIO_ID
        AND IPU.ID_PUNTO              =  ISE.PUNTO_ID
        AND ASE.ID_SECTOR             =  IPU.SECTOR_ID
        AND APA.ID_PARROQUIA          =  ASE.PARROQUIA_ID
        AND ISE.ID_SERVICIO           =  Ln_ServicioId
        AND IRC.ESTADO                = 'Activo'
        AND IRD.ESTADO                = 'Activo'
        --OBTENEMOS EL RACK
        AND IRD.ELEMENTO_ID           =  IEL1.ID_ELEMENTO --RACK
        AND IEL1.MODELO_ELEMENTO_ID   =  AME1.ID_MODELO_ELEMENTO
        AND AME1.TIPO_ELEMENTO_ID     =  ATE1.ID_TIPO_ELEMENTO
        AND AME1.ESTADO               = 'Activo'
        AND ATE1.ESTADO               = 'Activo'
        --OBTENEMOS LA FILA
        AND IEL1.ID_ELEMENTO          =  IRE2.ELEMENTO_ID_B  -- B RACK
        AND IRE2.ELEMENTO_ID_A        =  IEL2.ID_ELEMENTO    -- A FILA
        AND IEL2.MODELO_ELEMENTO_ID   =  AME2.ID_MODELO_ELEMENTO
        AND AME2.TIPO_ELEMENTO_ID     =  ATE2.ID_TIPO_ELEMENTO
        AND ATE2.NOMBRE_TIPO_ELEMENTO = 'FILA'
        AND IEL2.ID_ELEMENTO          =  IEEU.ELEMENTO_ID
        AND IUB.ID_UBICACION          =  IEEU.UBICACION_ID
        AND APA2.ID_PARROQUIA         =  IUB.PARROQUIA_ID
        --LA FILA Y EL SERVICIO ESTEN EN EL MISMO CANTON
        AND APA.CANTON_ID             =  APA2.CANTON_ID
        AND IRE2.ESTADO               = 'Activo'
        AND AME2.ESTADO               = 'Activo'
        AND ATE2.ESTADO               = 'Activo'
      GROUP BY
        IRC.SERVICIO_ID,
        IRC.DESCRIPCION_RECURSO,
        ATE1.NOMBRE_TIPO_ELEMENTO,
        IEL1.ID_ELEMENTO,
        IEL1.NOMBRE_ELEMENTO,
        IEL2.ID_ELEMENTO,
        IEL2.NOMBRE_ELEMENTO
      UNION
      --UNIDAD DE RACK
      SELECT
        IRC.DESCRIPCION_RECURSO   AS descripcionRecurso,
        ATE0.NOMBRE_TIPO_ELEMENTO AS nombreTipoElemento,
        IEL2.ID_ELEMENTO          AS idFila,
        IEL2.NOMBRE_ELEMENTO      AS nombreFila,
        IEL1.ID_ELEMENTO          AS idRack,
        IEL1.NOMBRE_ELEMENTO      AS nombreRack,
        COUNT(IRD.ELEMENTO_ID)    AS reservados
      FROM
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB    IRC,
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET    IRD,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO          IEL0,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   AME0,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     ATE0,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO          IEL1,
        DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE1,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   AME1,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     ATE1,
        DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE2,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO          IEL2,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   AME2,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     ATE2,
        DB_COMERCIAL.INFO_SERVICIO                ISE,
        DB_COMERCIAL.INFO_PUNTO                   IPU,
        DB_COMERCIAL.ADMI_SECTOR                  ASE,
        DB_COMERCIAL.ADMI_PARROQUIA               APA,
        DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,
        DB_INFRAESTRUCTURA.INFO_UBICACION              IUB,
        DB_COMERCIAL.ADMI_PARROQUIA                    APA2
      WHERE
        IRC.ID_SERVICIO_RECURSO_CAB   =  IRD.SERVICIO_RECURSO_CAB_ID
        AND ISE.ID_SERVICIO           =  IRC.SERVICIO_ID
        AND IPU.ID_PUNTO              =  ISE.PUNTO_ID
        AND ASE.ID_SECTOR             =  IPU.SECTOR_ID
        AND APA.ID_PARROQUIA          =  ASE.PARROQUIA_ID
        AND ISE.ID_SERVICIO           =  Ln_ServicioId
        AND IRC.ESTADO                = 'Activo'
        AND IRD.ESTADO                = 'Activo'
          --OBTENEMOS INFORMACION DE LA UNIDAD DE RACK
        AND IRD.ELEMENTO_ID           =  IEL0.ID_ELEMENTO  --UNIDAD DE RACK
        AND IEL0.MODELO_ELEMENTO_ID   =  AME0.ID_MODELO_ELEMENTO
        AND AME0.TIPO_ELEMENTO_ID     =  ATE0.ID_TIPO_ELEMENTO
        AND AME0.ESTADO               = 'Activo'
        AND ATE0.ESTADO               = 'Activo'
        --OBTENEMOS INFORMACION DEL RACK
        AND IRD.ELEMENTO_ID           =  IRE1.ELEMENTO_ID_B  -- B UNIDAD DE RACK
        AND IRE1.ELEMENTO_ID_A        =  IEL1.ID_ELEMENTO    -- A RACK
        AND IEL1.MODELO_ELEMENTO_ID   =  AME1.ID_MODELO_ELEMENTO
        AND AME1.TIPO_ELEMENTO_ID     =  ATE1.ID_TIPO_ELEMENTO
        AND ATE1.NOMBRE_TIPO_ELEMENTO = 'RACK'
        AND IRE1.ESTADO               = 'Activo'
        AND AME1.ESTADO               = 'Activo'
        AND ATE1.ESTADO               = 'Activo'
        --OBTENEMOS INFORMACION DEL LA FILA
        AND IRE1.ELEMENTO_ID_A        =  IRE2.ELEMENTO_ID_B  -- B RACK
        AND IRE2.ELEMENTO_ID_A        =  IEL2.ID_ELEMENTO    -- A FILA
        AND IEL2.MODELO_ELEMENTO_ID   =  AME2.ID_MODELO_ELEMENTO
        AND AME2.TIPO_ELEMENTO_ID     =  ATE2.ID_TIPO_ELEMENTO
        AND ATE2.NOMBRE_TIPO_ELEMENTO = 'FILA'
        AND IEL2.ID_ELEMENTO          =  IEEU.ELEMENTO_ID
        AND IUB.ID_UBICACION          =  IEEU.UBICACION_ID
        AND APA2.ID_PARROQUIA         =  IUB.PARROQUIA_ID
        --LA FILA Y EL SERVICIO ESTEN EN EL MISMO CANTON
        AND APA.CANTON_ID             =  APA2.CANTON_ID
        AND IRE2.ESTADO               = 'Activo'
        AND AME2.ESTADO               = 'Activo'
        AND ATE2.ESTADO               = 'Activo'
      GROUP BY
        IRC.SERVICIO_ID,
        IRC.DESCRIPCION_RECURSO,
        ATE0.NOMBRE_TIPO_ELEMENTO,
        IEL1.ID_ELEMENTO,
        IEL1.NOMBRE_ELEMENTO,
        IEL2.ID_ELEMENTO,
        IEL2.NOMBRE_ELEMENTO;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;
    WHEN OTHERS THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;

  END P_OBTENER_INFO_CUARTO_TI_CAB;
----
----
  PROCEDURE P_OBTENER_INFO_CUARTO_TI_DET(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR)
  IS

    --Variables Locales.
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(3000);

  BEGIN

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);

    -- VALIDACIONES
    IF APEX_JSON.GET_NUMBER(p_path => 'servicioId') IS NULL OR APEX_JSON.GET_NUMBER(p_path => 'idRack') IS NULL THEN
      Lv_Mensaje := 'El parámetro servicioId o idRack esta vacío';
      RAISE Le_Exception;
    END IF;

    OPEN Pcl_Response FOR
      SELECT
        IRD.ELEMENTO_ID AS idUdRack,
        (ROWNUM-1)      AS numeroRack
      FROM
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB    IRC,
        DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET    IRD,
        DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO IRE
      WHERE
        IRC.ID_SERVICIO_RECURSO_CAB = IRD.SERVICIO_RECURSO_CAB_ID
        AND IRE.ELEMENTO_ID_B       = IRD.ELEMENTO_ID
        AND IRC.SERVICIO_ID         = APEX_JSON.GET_NUMBER(p_path => 'servicioId')
        AND IRE.ELEMENTO_ID_A       = APEX_JSON.GET_NUMBER(p_path => 'idRack');

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;
    WHEN OTHERS THEN
      Pv_Status    := 'ERROR';
      Pv_Mensaje   :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pcl_Response :=  NULL;

  END P_OBTENER_INFO_CUARTO_TI_DET;
----
----
END CMKG_SOLUCIONES_CONSULTA;
/

