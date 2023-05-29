CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_CONTABILIZAR_PAGOS_RET
AS
  --
  /*
  * Documentación para FUNCION 'GET_PAGOS_DE_ASIENTO'.
  *
  * Este busca los pagos que pertenecen al pago grupal que se esta grabando en el asiento contable
  *
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 17/03/2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 09-01-2017 - Se modifica la función para obtener los detalles que no han sido contabilizados
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 09-08-2017 - Se modifica la función para obtener obtener los pagos que no han sido migrados a la tabla
  *                          'NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO'
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.3 06-01-2018 - Se modifica para agregar filtro tipo documento en consulta que recupera pagos a registrar
  *                           en documentos asociados pues registra como migrados todos cuando aun faltan por procesar.
  *
  * @param Fr_PagosAgrupados IN  FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos (Detalles de pagos)
  * @return SYS_REFCURSOR (Retorna los pagos que corresponde al pago grupal)
  */
  FUNCTION GET_PAGOS_DE_ASIENTO(
      Fr_PagosAgrupados IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos)
    RETURN SYS_REFCURSOR;
  --
  --
  /*
  * Documentación para FUNCION 'MARCA_PAGO_CONTABILIZADO'.
  *
  * Este proceso se encarga de marcar como contabilizado los pagos que forman parte del asiento contable
  *
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 17/03/2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 09-08-2017 - Se agrega el parámetro 'Pr_MigraDocumentoAsociado' para enviar los parámetros adecuados para insertar los detalles de
  *                           los pagos migrados.
  *
  * @param Pv_NoCia                  IN VARCHAR2  Código de la compañia que genera la migración
  * @param Pr_DetallePago            IN DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos  Detalle del pago a migrar
  * @param Pr_MigraDocumentoAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE  Información del registro del pago migrado
  * @param Pv_MensajeError           OUT VARCHAR2  Mensaje de error en caso de existir
  */
  PROCEDURE MARCA_CONTABILIZADO_PAGO(
      Pv_NoCia                  IN VARCHAR2,
      Pr_DetallePago            IN DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
      Pr_MigraDocumentoAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE,
      Pv_MensajeError           OUT VARCHAR2, Pn_IdMigracion18 NUMBER default null);
  --
  --
  /*
  * Documentación para FUNCION 'GET_ANTICIPOS_ADICIONALXDIA'.
  *
  * FUNCION QUE OBTIENE ANTICIPOS QUE FUERON CREADOS POR UN PAGO
  *
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 21/05/2016
  *
  * Actualizacion: Se realiza correccion de obtener anticipos por tipo documento ANT
  * @author Andres Montero amontero@telconet.ec
  * @version 1.1 30/08/2016
  *
  * Actualizacion: Se realiza correccion los anticipos debe ser filtrado tambien por oficina
  * @author Andres Montero amontero@telconet.ec
  * @version 1.2 07/09/2016
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 09-01-2017 - Se modifica la función para obtener los detalles que no han sido contabilizados
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 09-08-2017 - Se agregan los parámetros 'Fv_NombrePaqueteSQL', 'Fv_EmpresaCod' y 'Fv_EstadoActivo' para obtener los anticipos que no
  *                           han sido migrados a NAF.
  *
  * @param Fn_FormaPagoId      IN DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE  Id forma de pago
  * @param Ft_FeCreacion       IN VARCHAR2  Fecha de creación del pago
  * @param Fn_OficinaId        IN DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE  Id de oficina
  * @param Fv_NombrePaqueteSQL IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE  Nombre del paquete SQL que ejecuta el proceso
  * @param Fv_EmpresaCod       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Código de la empresa
  * @param Fv_EstadoActivo     IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE  Estado activo de lo que se requiere buscar
  */
  FUNCTION GET_ANTICIPOS_ADICIONALXDIA(
      Fn_FormaPagoId      IN DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
      Ft_FeCreacion       IN VARCHAR2,
      Fn_OficinaId        IN DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
      Fv_NombrePaqueteSQL IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
      Fv_EmpresaCod       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
      Fv_EstadoActivo     IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
    RETURN NUMBER;
  --
  --
  /*
  * Documentación para FUNCION 'F_GET_PAGOS_FORMA_PAGO_XDIA'.
  * FUNCION QUE OBTIENE PAGOS SEGUN FORMA DE PAGO Y FECHA
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 30/08/2016
  *
  * Actualizacion: Se realiza correccion los pagos debe ser filtrado tambien por oficina
  * @author Andres Montero amontero@telconet.ec
  * @version 1.1 07/09/2016
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 09-01-2017 - Se modifica la función para obtener los detalles que no han sido contabilizados
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 09-08-2017 - Se agregan los parámetros 'Fv_NombrePaqueteSQL', 'Fv_EmpresaCod' y 'Fv_EstadoActivo' para obtener las formas de pago de
  *                           los pagos que no han sido migrados a NAF.
  *
  * @param Fn_FormaPagoId      IN DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE  Id forma de pago
  * @param Ft_FeCreacion       IN VARCHAR2  Fecha de creación del pago
  * @param Fn_OficinaId        IN DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE  Id de oficina
  * @param Fv_NombrePaqueteSQL IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE  Nombre del paquete SQL que ejecuta el proceso
  * @param Fv_EmpresaCod       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Código de la empresa
  * @param Fv_EstadoActivo     IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE  Estado activo de lo que se requiere buscar
  */
  FUNCTION F_GET_PAGOS_FORMA_PAGO_XDIA(
      Fn_FormaPagoId      IN DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
      Ft_FeCreacion       IN VARCHAR2,
      Fn_OficinaId        IN DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
      Fv_NombrePaqueteSQL IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
      Fv_EmpresaCod       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
      Fv_EstadoActivo     IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE)
    RETURN NUMBER;
  --
  --
/*
* Documentación para FUNCION 'PAGO_RETENCIONESxDIA'.
* PROCEDIMIENTO QUE REALIZA EL PROCESO DE CREAR ASIENTOS CONTABLES PARA LOS PAGOS QUE TENGAN FORMA DE PAGO RETENCION
* @author Andres Montero amontero@telconet.ec
* @version 1.0
*
* Actualizacion: Se incluyen los anticipos en la contabilizacion de retenciones
* @author Andres Montero amontero@telconet.ec
* @version 1.1 31/08/2016
* @author Edson Franco <efranco@telconet.ec>
* @version 1.3 09-08-2017 - Se agrega al query principal la validación para que no retorne los pagos que ya hayan sido migrados al NAF.
*                           Se agregan las funciones implementadas en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE' para insertar en la tabla
*                           'MIGRA_ARCGAE'
*                           Se envía al procedure 'MARCA_CONTABILIZADO_PAGO' la variable 'Lr_MigraDocumentoAsociado' para migrar la información de
*                           cada detalle de pago contabilizado.
* @author Edson Franco <efranco@telconet.ec>
* @version 1.4 12-09-2017 - Se valida que no se migre la información de pagos o anticipo con valor cero.
*
* @since 17/03/2016
* @Param in  varchar2  v_no_cia (id de la empresa)
* @Param in  number    v_pago_det_id (id del detalle del pago)
* @Param out msg_ret   msg_ret (mensaje que retorna al finalizar proceso o cuando se produza un error)
*/
PROCEDURE PROCESAR_PAGO_RETENCIONESxDIA(v_no_cia in varchar2,v_fecha in varchar2,msg_ret out varchar2);


/*
* Documentación para procedimiento 'P_CONTABILIZAR_INDIVIDUAL'.
* procedimiento que genera contabilziación de retenciones individualmente al sistema NAF.
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.0 27-09-2018
*
* @param Pv_NoCia        IN     VARCHAR2  Código de la empresa
* @param Pv_Fecha        IN     VARCHAR2  Fecha de proceso
* @param Pv_MensajeError IN OUT VARCHAR2  Detalle de errores
*/
PROCEDURE P_CONTABILIZAR_INDIVIDUAL ( Pv_NoCia         IN VARCHAR2,
                                      Pv_Fecha         IN VARCHAR2,
                                      Pv_MensajeError  IN OUT VARCHAR2);


END FNKG_CONTABILIZAR_PAGOS_RET;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CONTABILIZAR_PAGOS_RET
AS
 /*
 * Documentación para FUNCION 'F_OBTENER_VALOR_PARAMETRO'.
 * FUNCION QUE OBTIENE PARAMETROS DE ECUANET PARA MIGRACION A COMPAÑIA MEGADATOS
 * @author Jimmy Gilces <jgilces@telconet.ec>
 * @version 1.0
 * @since 27/03/2023
 * @Param varchar2 Pv_NombreParametro
 * @Param varchar2 Pv_Parametro
 * @return  VARCHAR2 (VALOR DEL PARAMETRO SOLICITADO)
 */
 FUNCTION F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro IN VARCHAR2,
                                    Pv_Parametro       IN VARCHAR2)
   RETURN VARCHAR2 IS
   CURSOR C_OBTENER_PARAMETRO(Cv_NombreParametro VARCHAR2,
                              Cv_Parametro       VARCHAR2) IS
     select apd.valor2
       from db_general.admi_parametro_cab apc,
            db_general.admi_parametro_det apd
      where apc.id_parametro = apd.parametro_id
        and apc.estado = apd.estado
        and apc.estado = 'Activo'
        and apc.nombre_parametro = Cv_NombreParametro
        and apd.valor1 = Cv_Parametro;
 
   Lv_ValorParametro DB_GENERAL.Admi_Parametro_Det.VALOR2%type;
 BEGIN
   IF C_Obtener_Parametro%ISOPEN THEN
     CLOSE C_Obtener_Parametro;
   END IF;
 
   OPEN C_Obtener_Parametro(Pv_NombreParametro, Pv_Parametro);
   FETCH C_Obtener_Parametro
     INTO Lv_ValorParametro;
   CLOSE C_Obtener_Parametro;
 
   RETURN Lv_ValorParametro;
 END;
 
  --
  FUNCTION GET_PAGOS_DE_ASIENTO(
      Fr_PagosAgrupados IN FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos)
    RETURN SYS_REFCURSOR
  IS
    --
    Lc_DetallesPagos SYS_REFCURSOR;
    Lv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_CONTABILIZAR_PAGOS_RET';
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                             := 'Activo';
    --
  BEGIN
    --
    OPEN Lc_DetallesPagos FOR SELECT PDET.ID_PAGO_DET, PCAB.ID_PAGO, PCAB.ESTADO_PAGO, PCAB.TIPO_DOCUMENTO_ID
                              FROM INFO_PAGO_DET PDET
                              JOIN INFO_PAGO_CAB PCAB
                              ON PDET.PAGO_ID = PCAB.ID_PAGO
                              LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                              ON MDA.DOCUMENTO_ORIGEN_ID  = PDET.ID_PAGO_DET
                              JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF
                              ON PCAB.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
                              WHERE PDET.FORMA_PAGO_ID = Fr_PagosAgrupados.ID_FORMA_PAGO
                              AND PDET.FE_CREACION     >= CAST(Fr_PagosAgrupados.FE_CREACION AS TIMESTAMP WITH LOCAL TIME ZONE)
                              AND PDET.FE_CREACION     <  CAST(Fr_PagosAgrupados.FE_CREACION AS TIMESTAMP WITH LOCAL TIME ZONE) + 1
                              AND TDF.CODIGO_TIPO_DOCUMENTO = Fr_PagosAgrupados.TIPO_DOC
                              AND ( ( TDF.CODIGO_TIPO_DOCUMENTO IN ('ANT')
                                      AND PCAB.ANTICIPO_ID          IS NULL )
                                     OR TDF.CODIGO_TIPO_DOCUMENTO IN('PAG') )
                              AND (MDA.MIGRACION_ID         IS NULL
                              OR MDA.TIPO_DOC_MIGRACION NOT IN
                                (SELECT COD_DIARIO
                                FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
                                WHERE NOMBRE_PAQUETE_SQL = Lv_NombrePaqueteSQL
                                AND EMPRESA_COD          = Fr_PagosAgrupados.COD_EMPRESA
                                AND ESTADO               = Lv_EstadoActivo
                                GROUP BY COD_DIARIO
                                ))
                              AND PDET.ESTADO <> 'Anulado'
                              AND PCAB.OFICINA_ID = Fr_PagosAgrupados.OFICINA_ID;
    --
    RETURN Lc_DetallesPagos;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lc_DetallesPagos := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_PAGOS_RET.GET_PAGOS_DE_ASIENTO',
                                          'Error en FNKG_CONTABILIZAR_PAGOS_RET.GET_PAGOS_DE_ASIENTO - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lc_DetallesPagos;
    --
  END GET_PAGOS_DE_ASIENTO;
  --
  --
  PROCEDURE MARCA_CONTABILIZADO_PAGO(
      Pv_NoCia                  IN VARCHAR2,
      Pr_DetallePago            IN DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos,
      Pr_MigraDocumentoAsociado IN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE,
      Pv_MensajeError           OUT VARCHAR2, Pn_IdMigracion18 NUMBER default null)
  IS
    --
    Lr_DetallePagos       SYS_REFCURSOR;
    Ln_IdPagoCab          NUMBER;
    Ln_IdPagoDet          NUMBER;
    Lv_EstadoPago         VARCHAR2(20);
    Ln_TipoDocumentoId    NUMBER;
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    Le_MigraDocumentoAsociado EXCEPTION;
    PRAGMA EXCEPTION_INIT( Le_MigraDocumentoAsociado, -20001 );
    --
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
  BEGIN
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    --
    Lr_DetallePagos := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGOS_RET.GET_PAGOS_DE_ASIENTO(Pr_DetallePago);
    LOOP
      --
      FETCH Lr_DetallePagos INTO Ln_IdPagoDet, Ln_IdPagoCab, Lv_EstadoPago, Ln_TipoDocumentoId;
      EXIT WHEN Lr_DetallePagos%NOTFOUND;
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.MARCA_CONTABILIZADO_PAGO(Ln_IdPagoDet, Ln_IdPagoCab, Lv_EstadoPago);

      Lr_MigraDocumentoAsociado                     := Pr_MigraDocumentoAsociado;
      Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := Ln_TipoDocumentoId;
      Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Ln_IdPagoDet;
      --
      IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
        --
        NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          --
          raise_application_error( -20001, 'Error al insertar la relación del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                           ' DETALLE_PAGO ( ' || Ln_IdPagoDet || '). MENSAJE ERROR NAF (' || Pv_MensajeError || ').');
          --
        END IF;
        --
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
          Lr_MigraDocumentoAsociado.Migracion_Id := Pn_IdMigracion18;
          Lr_MigraDocumentoAsociado.No_Cia := Lv_EmpresaDestino;
          
          NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MensajeError);
          
          Lr_MigraDocumentoAsociado.Migracion_Id := Pr_MigraDocumentoAsociado.Migracion_Id;
          Lr_MigraDocumentoAsociado.No_Cia := Pv_NoCia;
        end if;
        --
        IF Pv_MensajeError IS NOT NULL THEN
          --
          raise_application_error( -20001, 'Error al insertar la relación del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                           ' DETALLE_PAGO ( ' || Ln_IdPagoDet || '). MENSAJE ERROR NAF (' || Pv_MensajeError || ').');
          --
        END IF;
        --
      ELSE
        --
        raise_application_error( -20001, 'Error al insertar la relación del documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. ' ||
                                         ' DETALLE_PAGO ( ' || Ln_IdPagoDet || '). MENSAJE ERROR ( NO EXISTE ID_MIGRACION ).');
        --
      END IF;
      --
    END LOOP;
    --
    --
    CLOSE Lr_DetallePagos;
    --
  EXCEPTION
  WHEN OTHERS THEN
      --
      Pv_MensajeError := Pv_MensajeError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_CONTABILIZAR_PAGOS_RET.MARCA_CONTABILIZADO_PAGO',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
      ROLLBACK;
      --
  END MARCA_CONTABILIZADO_PAGO;
  --
  --
FUNCTION GET_ANTICIPOS_ADICIONALXDIA(
    Fn_FormaPagoId      IN DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
    Ft_FeCreacion       IN VARCHAR2,
    Fn_OficinaId        IN DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
    Fv_NombrePaqueteSQL IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
    Fv_EmpresaCod       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
    Fv_EstadoActivo     IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
  RETURN NUMBER
IS
  Lv_Mensaje     VARCHAR2(4000);
  total_anticipo NUMBER := 0;
  CURSOR c_pagos_det (Cn_formaPagoId DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
                      Ct_FeCreacion  VARCHAR2,
                      Cn_OficinaId   DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
                      Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                      Cv_EmpresaCod DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                      Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
  IS
    SELECT
      SUM(NVL(PDET.VALOR_PAGO,0))
    FROM
      DB_FINANCIERO.INFO_PAGO_CAB PCAB
    JOIN DB_FINANCIERO.INFO_PAGO_DET PDET
    ON
      PCAB.ID_PAGO = PDET.PAGO_ID
    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF
    ON
      PCAB.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
    LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
    ON MDA.DOCUMENTO_ORIGEN_ID  = PDET.ID_PAGO_DET
    WHERE
      PDET.FORMA_PAGO_ID = Cn_formaPagoId
    AND PCAB.OFICINA_ID  = Cn_OficinaId
    AND PCAB.FE_CREACION BETWEEN TO_TIMESTAMP(Ct_FeCreacion
      ||' 00:00:00','DD-MM-YYYY HH24:MI:SS')
    AND TO_TIMESTAMP(Ct_FeCreacion
      ||' 23:59:59','DD-MM-YYYY HH24:MI:SS')
    AND PCAB.ESTADO_PAGO          IN ('Asignado','Pendiente','Cerrado')
    AND TDF.CODIGO_TIPO_DOCUMENTO IN('ANT')
    AND PCAB.ANTICIPO_ID          IS NULL
    AND (MDA.MIGRACION_ID         IS NULL
    OR MDA.TIPO_DOC_MIGRACION NOT IN
      (SELECT COD_DIARIO
      FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
      WHERE NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
      AND EMPRESA_COD          = Cv_EmpresaCod
      AND ESTADO               = Cv_EstadoActivo
      GROUP BY COD_DIARIO
      ));
BEGIN
  IF c_pagos_det%ISOPEN THEN
    CLOSE c_pagos_det;
  END IF;

  OPEN c_pagos_det(Fn_FormaPagoId,
                   Ft_FeCreacion,
                   Fn_OficinaId,
                   Fv_NombrePaqueteSQL,
                   Fv_EmpresaCod,
                   Fv_EstadoActivo);

  FETCH
    c_pagos_det
  INTO
    total_anticipo;

  CLOSE c_pagos_det;
  RETURN total_anticipo;
EXCEPTION
WHEN OTHERS THEN
  Lv_Mensaje := DBMS_UTILITY.FORMAT_ERROR_STACK;
  DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR(
                                                       'FNKG_CONTABILIZAR_PAGO_RET',
                                                       'GET_ANTICIPOS_ADICIONALXDIA',
                                                       Lv_Mensaje);
  RETURN 0;
END;



FUNCTION F_GET_PAGOS_FORMA_PAGO_XDIA(
    Fn_FormaPagoId      IN DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
    Ft_FeCreacion       IN VARCHAR2,
    Fn_OficinaId        IN DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
    Fv_NombrePaqueteSQL IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
    Fv_EmpresaCod       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
    Fv_EstadoActivo     IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE)
  RETURN NUMBER
IS
  Lv_Mensaje VARCHAR2(4000);
  Ln_Total   NUMBER := 0;
  --
  CURSOR c_pagos_det(Cn_FormaPagoId DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
                     Ct_FeCreacion  VARCHAR2,
                     Cn_OficinaId   DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
                     Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                     Cv_EmpresaCod DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                     Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE)
  IS
    SELECT
      SUM(NVL(PDET.VALOR_PAGO,0))
    FROM
      DB_FINANCIERO.INFO_PAGO_CAB PCAB
    JOIN DB_FINANCIERO.INFO_PAGO_DET PDET
    ON
      PCAB.ID_PAGO = PDET.PAGO_ID
    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF
    ON
      PCAB.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
    LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
    ON MDA.DOCUMENTO_ORIGEN_ID  = PDET.ID_PAGO_DET
    WHERE
      PDET.FORMA_PAGO_ID = Cn_FormaPagoId
    AND PCAB.OFICINA_ID  = Cn_OficinaId
    AND PCAB.FE_CREACION BETWEEN TO_TIMESTAMP(Ct_FeCreacion
      ||' 00:00:00','DD-MM-YYYY HH24:MI:SS')
    AND TO_TIMESTAMP(Ct_FeCreacion
      ||' 23:59:59','DD-MM-YYYY HH24:MI:SS')
    AND PCAB.ESTADO_PAGO          IN ('Cerrado')
    AND TDF.CODIGO_TIPO_DOCUMENTO IN('PAG')
    AND (MDA.MIGRACION_ID         IS NULL
    OR MDA.TIPO_DOC_MIGRACION NOT IN
      (SELECT COD_DIARIO
      FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
      WHERE NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
      AND EMPRESA_COD          = Cv_EmpresaCod
      AND ESTADO               = Cv_EstadoActivo
      GROUP BY COD_DIARIO
      ));
BEGIN
  IF c_pagos_det%ISOPEN THEN
    CLOSE c_pagos_det;
  END IF;
  --
  OPEN c_pagos_det(Fn_FormaPagoId,
                   Ft_FeCreacion,
                   Fn_OficinaId,
                   Fv_NombrePaqueteSQL,
                   Fv_EmpresaCod,
                   Fv_EstadoActivo);
  FETCH
    c_pagos_det
  INTO
    Ln_Total;
  CLOSE c_pagos_det;
  --
  RETURN Ln_Total;
EXCEPTION
WHEN OTHERS THEN
  Lv_Mensaje:=DBMS_UTILITY.FORMAT_ERROR_STACK;
  DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR(
  'FNKG_CONTABILIZAR_PAGO_RET', 'F_GET_PAGOS_FORMA_PAGO_XDIA', Lv_Mensaje);
  RETURN 0;
END;




  PROCEDURE PROCESAR_PAGO_RETENCIONESxDIA(v_no_cia in varchar2,v_fecha in varchar2,msg_ret out varchar2)
  IS
    lr_detalle_pago FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos;
    --cursor para obtener formas de pago retenciones
    CURSOR c_pagos ( Cv_EmpresaCod DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                     Cv_FeCreacion VARCHAR2,
                     Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                     Cv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
                     Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                     Cv_LabelCodigoFormaPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                     Cv_LabelEstadoPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                     Cv_LabelCodigoTipoDocumento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE )
    IS
      --
      SELECT OFI.EMPRESA_ID,
        OFI.ID_OFICINA,
        FP.ID_FORMA_PAGO,
        FP.DESCRIPCION_FORMA_PAGO,
        FP.CODIGO_FORMA_PAGO,
        OFI.NOMBRE_OFICINA
      FROM INFO_PAGO_DET PDET
      JOIN INFO_PAGO_CAB PCAB
      ON PDET.PAGO_ID = PCAB.ID_PAGO
      JOIN ADMI_FORMA_PAGO FP
      ON PDET.FORMA_PAGO_ID = FP.ID_FORMA_PAGO
      JOIN INFO_OFICINA_GRUPO OFI
      ON PCAB.OFICINA_ID = OFI.ID_OFICINA
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO TDF
      ON PCAB.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
      LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
      ON MDA.DOCUMENTO_ORIGEN_ID  = PDET.ID_PAGO_DET
      WHERE FP.CODIGO_FORMA_PAGO IN
        (SELECT APD.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APC.ID_PARAMETRO        = APD.PARAMETRO_ID
        WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APC.ESTADO             = Cv_EstadoActivo
        AND APD.ESTADO             = Cv_EstadoActivo
        AND APD.DESCRIPCION        = Cv_NombrePaqueteSQL
        AND APD.VALOR1             = Cv_LabelCodigoFormaPago
        AND APD.EMPRESA_COD        = Cv_EmpresaCod
        )
      AND PCAB.ESTADO_PAGO IN
        (SELECT APD.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APC.ID_PARAMETRO        = APD.PARAMETRO_ID
        WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APC.ESTADO             = Cv_EstadoActivo
        AND APD.ESTADO             = Cv_EstadoActivo
        AND APD.DESCRIPCION        = Cv_NombrePaqueteSQL
        AND APD.VALOR1             = Cv_LabelEstadoPago
        AND APD.EMPRESA_COD        = Cv_EmpresaCod
        )
      AND TDF.CODIGO_TIPO_DOCUMENTO IN
        (SELECT APD.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APC.ID_PARAMETRO        = APD.PARAMETRO_ID
      WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APC.ESTADO             = Cv_EstadoActivo
      AND APD.ESTADO             = Cv_EstadoActivo
      AND APD.DESCRIPCION        = Cv_NombrePaqueteSQL
      AND APD.VALOR1             = Cv_LabelCodigoTipoDocumento
      AND APD.EMPRESA_COD        = Cv_EmpresaCod
        )
      AND PCAB.FE_CREACION BETWEEN TO_TIMESTAMP(Cv_FeCreacion
        ||' 00:00:00','DD-MM-YYYY HH24:MI:SS')
      AND TO_TIMESTAMP(Cv_FeCreacion
        ||' 23:59:59','DD-MM-YYYY HH24:MI:SS')
      AND OFI.EMPRESA_ID             = Cv_EmpresaCod
      AND (MDA.MIGRACION_ID         IS NULL
      OR MDA.TIPO_DOC_MIGRACION NOT IN
        (SELECT COD_DIARIO
        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB
        WHERE NOMBRE_PAQUETE_SQL = Cv_NombrePaqueteSQL
        AND EMPRESA_COD          = Cv_EmpresaCod
        AND ESTADO               = Cv_EstadoActivo
        GROUP BY COD_DIARIO
        ))
      GROUP BY OFI.EMPRESA_ID,
        OFI.ID_OFICINA,
        FP.ID_FORMA_PAGO,
        FP.DESCRIPCION_FORMA_PAGO ,
        FP.CODIGO_FORMA_PAGO,
        OFI.NOMBRE_OFICINA
      ORDER BY OFI.ID_OFICINA,
        FP.ID_FORMA_PAGO,
        FP.DESCRIPCION_FORMA_PAGO,
        OFI.NOMBRE_OFICINA;
      --
    --
    c_admi_plantilla_contab_det SYS_REFCURSOR ;

    r_cuenta_contable FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    r_plantilla_contable_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;

    l_migra_arckmm NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    l_migra_arckml NAF47_TNET.MIGRA_ARCKML%ROWTYPE;
    l_migra_arcgae NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    l_migra_arcgal NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;

    l_MsnError            varchar2(800);
    l_MsnErrorDetalles    varchar2(800);

    l_no_asiento          varchar2(50)  := '';
    l_descripcion         varchar2(250) := '';
    total_anticipo        number        := 0;
    Ln_totalPagos         number        := 0;

    ex_insert_arcgae EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arcgae, -20001 );

    ex_insert_arcgal EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_insert_arcgal, -20002 );

    ex_no_hay_plantilla EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_no_hay_plantilla, -20005 );

    ex_faltan_datos EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_faltan_datos, -20006 );
    --
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                := 'VALIDACIONES_PROCESOS_CONTABLES';
    Lv_NombrePaqueteSQL DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_CONTABILIZAR_PAGOS_RET';
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                             := 'Activo';
    Lv_LabelCodigoFormaPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                     := 'CODIGO_FORMA_PAGO';
    Lv_LabelEstadoPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                          := 'ESTADO_PAGO';
    Lv_LabelCodigoTipoDocumento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                 := 'CODIGO_TIPO_DOCUMENTO';
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    Ln_ValorAMigrar NUMBER;
    --
    Le_MarcarContabilizado EXCEPTION;
    PRAGMA EXCEPTION_INIT( Le_MarcarContabilizado, -20007 );
    Le_MigraDocumentoAsociado EXCEPTION;
    PRAGMA EXCEPTION_INIT( Le_MigraDocumentoAsociado, -20008 );
    --
    --
    --CURSOR C_GetParametrosDet obtiene los detalles de los parametros segun los parámetros enviados por el usuario
    --COSTO QUERY: 9
    CURSOR C_GetDetalleParametros( Cv_NombreParameteroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_EstadoParametroCab  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_EstadoParametroDet  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_Descripcion         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_Valor1              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                   Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE )
    IS
      --
      SELECT APD.ID_PARAMETRO_DET, APD.PARAMETRO_ID, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4, APD.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
           DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO    = APD.PARAMETRO_ID
      AND APC.ESTADO            = NVL(Cv_EstadoParametroCab, APC.ESTADO )
      AND APD.ESTADO            = NVL(Cv_EstadoParametroDet, APD.ESTADO )
      AND APC.NOMBRE_PARAMETRO  = NVL(Cv_NombreParameteroCab, APC.NOMBRE_PARAMETRO )
      AND APD.DESCRIPCION       = NVL(Cv_Descripcion, APD.DESCRIPCION )
      AND APD.VALOR1            = NVL(Cv_Valor1, APD.VALOR1 )
      AND APD.EMPRESA_COD       = NVL(Cv_EmpresaCod, APD.EMPRESA_COD );
      --
    --
    Lr_GetDetalleParametros C_GetDetalleParametros%ROWTYPE;
    --
    Ln_IdMigracion33 number;
    Ln_IdMigracion18 number;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
  BEGIN
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
    IF c_pagos%ISOPEN THEN
      CLOSE c_pagos;
    END IF;
    --
    OPEN c_pagos( v_no_cia,
                  v_fecha,
                  Lv_NombreParametro,
                  Lv_NombrePaqueteSQL,
                  Lv_EstadoActivo,
                  Lv_LabelCodigoFormaPago,
                  Lv_LabelEstadoPago,
                  Lv_LabelCodigoTipoDocumento );
    msg_ret:='1000';
    LOOP
        --RECORRE LOS DATOS DEL DETALLE DE PAGO
        FETCH c_pagos
        INTO lr_detalle_pago.COD_EMPRESA,
          lr_detalle_pago.OFICINA_ID,
          lr_detalle_pago.ID_FORMA_PAGO ,
          lr_detalle_pago.FORMA_PAGO,
          lr_detalle_pago.CODIGO_FORMA_PAGO,
          lr_detalle_pago.OFICINA;

        EXIT WHEN c_pagos%NOTFOUND;
        --
        IF C_GetDetalleParametros%ISOPEN THEN
          CLOSE C_GetDetalleParametros;
        END IF;
        --
        OPEN C_GetDetalleParametros( Lv_NombreParametro,
                                     Lv_EstadoActivo,
                                     Lv_EstadoActivo,
                                     Lv_NombrePaqueteSQL,
                                     Lv_LabelCodigoTipoDocumento,
                                     v_no_cia );
        --
        LOOP
          --
          FETCH C_GetDetalleParametros INTO Lr_GetDetalleParametros;
          EXIT WHEN C_GetDetalleParametros%NOTFOUND;
          --
          IF Lr_GetDetalleParametros.VALOR2 IS NOT NULL THEN
            --
            Ln_ValorAMigrar                 := 0;
            lr_detalle_pago.TIPO_DOC        := Lr_GetDetalleParametros.VALOR2;
            lr_detalle_pago.FE_CREACION     := TO_DATE(v_fecha, 'dd-mm-yyyy');
            lr_detalle_pago.MONTO_ANTICIPOS := 0;
            lr_detalle_pago.MONTO           := 0;
            total_anticipo                  := 0;
            Ln_totalPagos                   := 0;
            Lr_MigraDocumentoAsociado       := NULL;
            --
            --
            IF Lr_GetDetalleParametros.VALOR2 = 'ANT' THEN
              --
              total_anticipo := GET_ANTICIPOS_ADICIONALXDIA( lr_detalle_pago.ID_FORMA_PAGO,
                                                             v_fecha,
                                                             lr_detalle_pago.OFICINA_ID,
                                                             Lv_NombrePaqueteSQL,
                                                             v_no_cia,
                                                             Lv_EstadoActivo );
              --
            ELSE
              --
              Ln_totalPagos := F_GET_PAGOS_FORMA_PAGO_XDIA( lr_detalle_pago.ID_FORMA_PAGO,
                                                            v_fecha,
                                                            lr_detalle_pago.OFICINA_ID,
                                                            Lv_NombrePaqueteSQL,
                                                            v_no_cia,
                                                            Lv_EstadoActivo );
              --
            END IF;--Lr_GetDetalleParametros.VALOR2 = 'ANT'
            --
            --
            IF total_anticipo > 0 THEN
              --
              lr_detalle_pago.MONTO_ANTICIPOS := total_anticipo;
              --
            END IF;
            --
            --
            IF Ln_totalPagos > 0 THEN
              --
              lr_detalle_pago.MONTO := Ln_totalPagos;
              --
            END IF;
            --
            --
            Ln_ValorAMigrar := lr_detalle_pago.MONTO + lr_detalle_pago.MONTO_ANTICIPOS;
            --
            --
            IF Ln_ValorAMigrar > 0 THEN
              --
              --INGRESA LA CABECERA DEL ASIENTO
              --###############################
              --OBTIENE LA PLANTILLA
              --
              r_plantilla_contable_cab := FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB_COD( lr_detalle_pago.COD_EMPRESA,
                                                                                                        lr_detalle_pago.CODIGO_FORMA_PAGO ,
                                                                                                        Lr_GetDetalleParametros.VALOR2,
                                                                                                        'INDIVIDUAL' );
              --
              --
              l_no_asiento            := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO( r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO,
                                                                                               lr_detalle_pago.ID_PAGO_DET,
                                                                                               lr_detalle_pago );
              ---
              l_descripcion           := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO( lr_detalle_pago,
                                                                                          l_no_asiento,
                                                                                          r_plantilla_contable_cab.FORMATO_GLOSA,
                                                                                          null,
                                                                                          null );
              --
              lr_detalle_pago.PREFIJO := FNKG_CONTABILIZAR_PAGO_MANUAL.OBTIENE_PREFIJO_EMPRESA(lr_detalle_pago.COD_EMPRESA);
              --
              --
              IF(r_plantilla_contable_cab.TABLA_CABECERA='MIGRA_ARCGAE')THEN
                --
                Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := r_plantilla_contable_cab.COD_DIARIO;
                Lr_MigraDocumentoAsociado.NO_CIA              := lr_detalle_pago.COD_EMPRESA;
                Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := r_plantilla_contable_cab.ID_FORMA_PAGO;
                Lr_MigraDocumentoAsociado.ESTADO              := 'M';
                Lr_MigraDocumentoAsociado.USR_CREACION        := 'telcos';
                Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
                --
                msg_ret:='1400';
                --
                IF v_no_cia != Lv_EmpresaOrigen THEN
                   l_migra_arcgae.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CG (lr_detalle_pago.COD_EMPRESA);
                ELSIF nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen THEN
                   l_migra_arcgae.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CG (Lv_EmpresaOrigen);
                   Ln_IdMigracion33 := l_migra_arcgae.Id_Migracion;
                   Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG (Lv_EmpresaDestino);
                END IF;
                --
                Lr_MigraDocumentoAsociado.MIGRACION_ID   := l_migra_arcgae.ID_MIGRACION;
                Lr_MigraDocumentoAsociado.TIPO_MIGRACION := 'CG';
                --
                --
                l_migra_arcgae.ID_FORMA_PAGO          := lr_detalle_pago.ID_FORMA_PAGO;
                l_migra_arcgae.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
                l_migra_arcgae.NO_CIA                 := v_no_cia;
                l_migra_arcgae.ANO                    := TO_CHAR(lr_detalle_pago.FE_CREACION,'YYYY');
                l_migra_arcgae.MES                    := TO_CHAR(lr_detalle_pago.FE_CREACION,'MM');
                l_migra_arcgae.NO_ASIENTO             := l_no_asiento;
                l_migra_arcgae.IMPRESO                := 'N';
                l_migra_arcgae.FECHA                  := lr_detalle_pago.FE_CREACION;
                l_migra_arcgae.DESCRI1                := l_descripcion;
                l_migra_arcgae.ESTADO                 := 'P';
                l_migra_arcgae.AUTORIZADO             := 'N';
                l_migra_arcgae.ORIGEN                 := lr_detalle_pago.PREFIJO;
                l_migra_arcgae.T_DEBITOS              := Ln_ValorAMigrar;
                l_migra_arcgae.T_CREDITOS             := Ln_ValorAMigrar;
                l_migra_arcgae.COD_DIARIO             := r_plantilla_contable_cab.COD_DIARIO;
                l_migra_arcgae.T_CAMB_C_V             := 'C';
                l_migra_arcgae.TIPO_CAMBIO            := '1';
                l_migra_arcgae.TIPO_COMPROBANTE       := 'T';
                l_migra_arcgae.ANULADO                := 'N';
                l_migra_arcgae.USUARIO_CREACION       := 'telcos';
                l_migra_arcgae.TRANSFERIDO            := 'N';
                l_migra_arcgae.FECHA_CREACION         := sysdate;
                --
                --
                --INSERTA CABECERA DEL ASIENTO
                ----------------------------
                IF (l_migra_arcgae.NO_ASIENTO IS NOT NULL) THEN
                  --
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(l_migra_arcgae,l_MsnError);
                  
                  if nvl(Lv_BanderaReplicar,'N') = 'S' AND v_no_cia = Lv_EmpresaOrigen then
                    declare
                      Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
                    begin
                      
                      select id_oficina INTO Ln_IdOficina
                        from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                       where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                   from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                  where a.id_oficina = lr_detalle_pago.OFICINA_ID);
                                                  
                      l_migra_arcgae.NO_CIA                 := Lv_EmpresaDestino;
                      l_migra_arcgae.Id_Migracion     := Ln_IdMigracion18;
                      l_migra_arcgae.ID_OFICINA_FACTURACION := Ln_IdOficina;
                      
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(l_migra_arcgae,l_MsnError);
                      
                      l_migra_arcgae.NO_CIA                 := v_no_cia;
                      l_migra_arcgae.Id_Migracion     := Ln_IdMigracion33;
                      l_migra_arcgae.ID_OFICINA_FACTURACION := lr_detalle_pago.OFICINA_ID;
                    end;
                    
                  end if;
                  --
                ELSE
                  --
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                        'FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESxDIA',
                                                        msg_ret || ': No se realiza proceso contable, faltan datos para crear asiento',
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  --
                  raise_application_error( -20006, 'No se realiza proceso contable, faltan datos para crear asiento' );
                  --
                END IF;
                --
                --
                IF l_MsnError IS NOT NULL THEN
                  --
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                        'FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESxDIA',
                                                        msg_ret || ':' || l_MsnError,
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  --
                  raise_application_error( -20001, 'Error al insertar cabecera en MIGRA_ARCGAE' );
                  --
                END IF;
                --
              ELSE
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                      'FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESxDIA',
                                                      msg_ret || ': No se realiza proceso contable, no se encontro plantilla',
                                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                --
                raise_application_error( -20005, 'No se realiza proceso contable, no se encontro plantilla' );
                --
              END IF;
              --
              --
              --CREA DETALLES DEL ASIENTO - INSERTA DEBITO Y CREDITO
              FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO( r_plantilla_contable_cab,
                                                                 lr_detalle_pago,
                                                                 l_migra_arckmm,
                                                                 l_migra_arcgae,
                                                                 l_MsnErrorDetalles, Ln_IdMigracion18);
              --
              --
              IF (l_MsnErrorDetalles='OK') THEN
                --
                l_MsnError := NULL;
                --
                --MARCA COMO CONTABILIZADO A LOS DETALLES DE PAGO
                DB_FINANCIERO.FNKG_CONTABILIZAR_PAGOS_RET.MARCA_CONTABILIZADO_PAGO(v_no_cia, lr_detalle_pago, Lr_MigraDocumentoAsociado, l_MsnError);
                --
                --
                IF l_MsnError IS NOT NULL THEN
                  --
                  raise_application_error( -20007, 'Error al marcar como contabilizado los pagos masivos. ' || l_MsnError );
                  --
                END IF;
                --
              ELSE
                --
                raise_application_error( -20002, 'Error al ingresar detalles del asiento. '||l_MsnErrorDetalles );
                --
              END IF;
              --
            END IF;--Ln_ValorAMigrar > 0
            --
          END IF;--Lr_GetDetalleParametros.VALOR2 IS NOT NULL
          --
        END LOOP;--C_GetDetalleParametros
        --
    END LOOP;
    --
    COMMIT;--c_pagos
    --
    --
    CLOSE c_pagos;
    --
    msg_ret:='Proceso OK';
    --
  EXCEPTION
  WHEN ex_insert_arcgae THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESxDIA',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN ex_insert_arcgal THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESxDIA',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN OTHERS THEN
    --
    msg_ret := msg_ret || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESxDIA',
                                          msg_ret,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  END PROCESAR_PAGO_RETENCIONESxDIA;
  --

  PROCEDURE P_CONTABILIZAR_INDIVIDUAL ( Pv_NoCia         IN VARCHAR2,
                                        Pv_Fecha         IN VARCHAR2,
                                        Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_RETENCIONES IS
      SELECT PDET.ID_PAGO_DET,
        FP.DESCRIPCION_FORMA_PAGO AS FORMA_PAGO,
        FP.CODIGO_FORMA_PAGO AS CODIGO_FORMA_PAGO,
        PDET.VALOR_PAGO AS MONTO,
        PDET.FE_CREACION,
        PCAB.NUMERO_PAGO,
        PDET.NUMERO_CUENTA_BANCO,
        (SELECT LOGIN
         FROM DB_COMERCIAL.INFO_PUNTO PTO
         WHERE PTO.ID_PUNTO = PCAB.PUNTO_ID ) AS LOGIN,
        PDET.USR_CREACION,
        OFI.NOMBRE_OFICINA AS OFICINA,
        PDET.CUENTA_CONTABLE_ID,
        PDET.NUMERO_REFERENCIA,
        PCAB.OFICINA_ID,
        (SELECT IEG.PREFIJO
         FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
         WHERE IEG.COD_EMPRESA = OFI.EMPRESA_ID) AS PREFIJO,
        TDF.CODIGO_TIPO_DOCUMENTO AS TIPO_DOC,
        PDET.PAGO_ID,
        PDET.FORMA_PAGO_ID AS ID_FORMA_PAGO,
        PCAB.TIPO_DOCUMENTO_ID,
        OFI.EMPRESA_ID AS COD_EMPRESA,
        PDET.FE_DEPOSITO,
        PCAB.PUNTO_ID,
        PCAB.ESTADO_PAGO,
        0 AS MONTO_ANTICIPOS
      FROM INFO_PAGO_DET PDET  
      JOIN INFO_PAGO_CAB PCAB ON PDET.PAGO_ID = PCAB.ID_PAGO
      JOIN ADMI_FORMA_PAGO FP ON PDET.FORMA_PAGO_ID = FP.ID_FORMA_PAGO
      JOIN INFO_OFICINA_GRUPO OFI ON PCAB.OFICINA_ID = OFI.ID_OFICINA
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO TDF  ON PCAB.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
      WHERE OFI.EMPRESA_ID  = Pv_NoCia
      AND PCAB.FE_CREACION BETWEEN TO_TIMESTAMP(Pv_Fecha||' 00:00:00','DD-MM-YYYY HH24:MI:SS')
      AND TO_TIMESTAMP(Pv_Fecha||' 23:59:59','DD-MM-YYYY HH24:MI:SS')
      -- Recupera los documentos en base a las Formas de Pagos Configuradas
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                       DB_GENERAL.ADMI_PARAMETRO_DET APD
                  WHERE APD.VALOR2         = FP.CODIGO_FORMA_PAGO
                  AND APD.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO --'&Cv_EstadoActivo'
                  AND APD.DESCRIPCION      = FNKG_VAR.Gv_ProcesoPagoRet --'&Cv_NombrePaqueteSQL'
                  AND APD.VALOR1           = FNKG_VAR.Gv_ParFormaPago --'&Cv_LabelCodigoFormaPago'
                  AND APD.EMPRESA_COD      = Pv_NoCia
                  AND APC.NOMBRE_PARAMETRO = FNKG_VAR.Gv_ValidaProcesoContable --'&Cv_NombreParametro'
                  AND APC.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO --'&Cv_EstadoActivo'
                  AND APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                 )
      -- Recupera los documentos en base a los estados configurados
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                       DB_GENERAL.ADMI_PARAMETRO_DET APD
                  WHERE APD.VALOR2         = PCAB.ESTADO_PAGO
                  AND APD.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO --'&Cv_EstadoActivo'
                  AND APD.DESCRIPCION      = FNKG_VAR.Gv_ProcesoPagoRet --'&Cv_NombrePaqueteSQL'
                  AND APD.VALOR1           = FNKG_VAR.Gv_ParEstadoPago --'&Cv_LabelEstadoPago'
                  AND APD.EMPRESA_COD      = Pv_NoCia
                  AND APC.NOMBRE_PARAMETRO = FNKG_VAR.Gv_ValidaProcesoContable --'&Cv_NombreParametro'
                  AND APC.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO --'&Cv_EstadoActivo'
                  AND APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                 )
      -- recupera solo los tipos documentos configurados
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                       DB_GENERAL.ADMI_PARAMETRO_DET APD
                  WHERE APD.VALOR2 = TDF.CODIGO_TIPO_DOCUMENTO
                  AND APD.ESTADO             = FNKG_VAR.Gr_Estado.ACTIVO --'&Cv_EstadoActivo'
                  AND APD.DESCRIPCION        = FNKG_VAR.Gv_ProcesoPagoRet --'&Cv_NombrePaqueteSQL'
                  AND APD.VALOR1             = FNKG_VAR.Gv_ParTipoDocPago --'&Cv_LabelCodigoTipoDocumento'
                  AND APD.EMPRESA_COD        = Pv_NoCia
                  AND APC.NOMBRE_PARAMETRO   = FNKG_VAR.Gv_ValidaProcesoContable --'&Cv_NombreParametro'
                  AND APC.ESTADO             = FNKG_VAR.Gr_Estado.ACTIVO --'&Cv_EstadoActivo'
                  AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
                 )
      -- valida que no se encuentre migrado
      AND NOT EXISTS ( SELECT NULL
                       FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APCC,
                            NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                       WHERE MDA.DOCUMENTO_ORIGEN_ID = PDET.ID_PAGO_DET
                       AND APCC.NOMBRE_PAQUETE_SQL   = FNKG_VAR.Gv_ProcesoPagoRet --'&Cv_NombrePaqueteSQL'
                       AND APCC.EMPRESA_COD          = Pv_NoCia
                       AND APCC.ESTADO               = FNKG_VAR.Gr_Estado.ACTIVO --
                       AND MDA.TIPO_DOC_MIGRACION    = APCC.COD_DIARIO
                       );
    --
    Le_Error         EXCEPTION;
    --
    Lr_CabPlantillaCon    DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    Lr_CuentaContable     DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    Lr_DetallePago        DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    --
    Lr_MigraArckmm      NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    Lr_MigraArcgae      NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraDocAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    --
    Lv_ContsTipoProceso CONSTANT VARCHAR2(10) := 'INDIVIDUAL';
    --
    
    Ln_IdMigracion33 NAF47_TNET.MIGRA_ARCGAE.ID_MIGRACION%TYPE;
    Ln_IdMigracion18 NAF47_TNET.MIGRA_ARCGAE.ID_MIGRACION%TYPE;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;

  BEGIN
    Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    --
    FOR Lr_DetallePago IN  C_RETENCIONES LOOP

      -- se recuperan datos de la cabecera de plantilla con la que se va a trabajr.
      Lr_CabPlantillaCon := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB_COD( Pv_NoCia,
                                                                                                        Lr_DetallePago.Codigo_Forma_Pago,
                                                                                                        Lr_DetallePago.Tipo_Doc,
                                                                                                        Lv_ContsTipoProceso);
      --
      IF Lr_CabPlantillaCon.ID_PLANTILLA_CONTABLE_CAB IS NULL THEN
        Pv_MensajeError := 'No se ha definido Plantilla contable para documento '||Lr_DetallePago.Tipo_Doc||', forma pago: '||Lr_DetallePago.Codigo_Forma_Pago||' y tipo proceso: '||Lv_ContsTipoProceso;
        RAISE Le_Error;
      END IF;
      -- se inicializa variable registro documento asociado.
      Lr_MigraDocAsociado := NULL;
      Lr_MigraArcgae := null;
      Lr_MigraArckmm := null;

      -- se inicializan los campos a insertar
      Lr_MigraArcgae.ID_FORMA_PAGO          := Lr_DetallePago.ID_FORMA_PAGO;
      Lr_MigraArcgae.ID_OFICINA_FACTURACION := Lr_DetallePago.Oficina_Id;
      Lr_MigraArcgae.NO_CIA                 := Pv_NoCia;
      Lr_MigraArcgae.FECHA                  := TRUNC(Lr_DetallePago.FE_CREACION);
      Lr_MigraArcgae.ANO                    := TO_NUMBER(TO_CHAR(Lr_MigraArcgae.Fecha,'YYYY'));
      Lr_MigraArcgae.MES                    := TO_NUMBER(TO_CHAR(Lr_MigraArcgae.Fecha,'MM'));
      Lr_MigraArcgae.NO_ASIENTO             := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO( 
                                                 Lr_CabPlantillaCon.FORMATO_NO_DOCU_ASIENTO,
                                                 Lr_DetallePago.ID_PAGO_DET,
                                                 Lr_DetallePago );
      Lr_MigraArcgae.DESCRI1                := FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(
                                                 Lr_DetallePago, 
                                                 '', 
                                                 Lr_CabPlantillaCon.FORMATO_GLOSA,
                                                 null,
                                                 null);
      Lr_MigraArcgae.IMPRESO                := 'N';
      Lr_MigraArcgae.ESTADO                 := 'P';
      Lr_MigraArcgae.AUTORIZADO             := 'N';
      Lr_MigraArcgae.ORIGEN                 := Lr_DetallePago.PREFIJO;
      Lr_MigraArcgae.T_DEBITOS              := Lr_DetallePago.Monto;
      Lr_MigraArcgae.T_CREDITOS             := Lr_DetallePago.Monto;
      Lr_MigraArcgae.COD_DIARIO             := Lr_CabPlantillaCon.COD_DIARIO;
      Lr_MigraArcgae.T_CAMB_C_V             := 'C';
      Lr_MigraArcgae.TIPO_CAMBIO            := '1';
      Lr_MigraArcgae.TIPO_COMPROBANTE       := 'T';
      Lr_MigraArcgae.ANULADO                := 'N';
      Lr_MigraArcgae.USUARIO_CREACION       := 'telcos';
      Lr_MigraArcgae.TRANSFERIDO            := 'N';
      Lr_MigraArcgae.FECHA_CREACION         := sysdate;
      --
      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen THEN
        Lr_MigraArcgae.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CG(Lv_EmpresaOrigen);
        Ln_IdMigracion33 := Lr_MigraArcgae.ID_MIGRACION;
        Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG(Lv_EmpresaDestino);
      ELSE
        Lr_MigraArcgae.ID_MIGRACION := NAF47_TNET.TRANSA_ID.MIGRA_CG(Pv_NoCia);
      END IF; 
      --
      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR_INDIVIDUAL',
                                              Pv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        RAISE Le_Error;
        --
      END IF;
      
      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen THEN
        declare
         Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
        begin
          select id_oficina INTO Ln_IdOficina
          from DB_COMERCIAL.INFO_OFICINA_GRUPO b
          where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
          from DB_COMERCIAL.INFO_OFICINA_GRUPO a
          where a.id_oficina = Lr_MigraArcgae.ID_OFICINA_FACTURACION);
          
          Lr_MigraArcgae.NO_CIA            := Lv_EmpresaDestino;
          Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_IdOficina;
          Lr_MigraArcgae.Id_Migracion     := Ln_IdMigracion18;
          
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MensajeError);
          
          Lr_MigraArcgae.Id_Migracion     := Ln_IdMigracion33;
          Lr_MigraArcgae.NO_CIA            := Pv_NoCia;
          Lr_MigraArcgae.ID_OFICINA_FACTURACION := Lr_DetallePago.Oficina_Id;
          
          IF Pv_MensajeError IS NOT NULL THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR_INDIVIDUAL',
                                              Pv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        RAISE Le_Error;
        --
      END IF;
        end;
      END IF;
      
      --
      -- generación detalle de Contabilización.
      FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO( Lr_CabPlantillaCon,
                                                         Lr_DetallePago,
                                                         Lr_MigraArckmm,
                                                         Lr_MigraArcgae,
                                                         Pv_MensajeError, Ln_IdMigracion18);
      --
      IF Pv_MensajeError != 'OK' THEN
        RAISE Le_Error;
      ELSE
        Pv_MensajeError := NULL;
        -- se acumulan los detalles de documentos que se estan contabilizando
        --Lr_MigraArckmm.Monto := NVL(Lr_MigraArckmm.Monto,0) + NVL(Lr_DetallePago.MONTO,0);
        --
      END IF;
      --
      Lr_MigraDocAsociado.DOCUMENTO_ORIGEN_ID := Lr_DetallePago.ID_PAGO_DET;
      Lr_MigraDocAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
      Lr_MigraDocAsociado.TIPO_DOC_MIGRACION  := Lr_CabPlantillaCon.COD_DIARIO;
      Lr_MigraDocAsociado.NO_CIA              := Pv_NoCia;
      Lr_MigraDocAsociado.FORMA_PAGO_ID       := Lr_CabPlantillaCon.ID_FORMA_PAGO;
      Lr_MigraDocAsociado.TIPO_DOCUMENTO_ID   := Lr_DetallePago.TIPO_DOCUMENTO_ID;
      Lr_MigraDocAsociado.ESTADO              := 'M';
      Lr_MigraDocAsociado.TIPO_MIGRACION      := 'CK';
      Lr_MigraDocAsociado.USR_CREACION        := Lr_DetallePago.USR_CREACION;
      Lr_MigraDocAsociado.FE_CREACION         := SYSDATE;
      --
      NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                             'I',
                                                             Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      
      if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_NoCia = Lv_EmpresaOrigen then
        Lr_MigraDocAsociado.MIGRACION_ID        := Ln_IdMigracion18;
        Lr_MigraDocAsociado .NO_CIA              := Lv_EmpresaDestino;
        
        
        NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                             'I',
                                                             Pv_MensajeError);
                                                             
        IF Pv_MensajeError IS NOT NULL THEN
           RAISE Le_Error;
        END IF;                                                             
        
        Lr_MigraDocAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
        Lr_MigraDocAsociado .NO_CIA              := Pv_NoCia;
      end if;
      --
      -- se marca el pago como contabilizado
      DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.MARCA_CONTABILIZADO_PAGO(Lr_DetallePago.ID_PAGO_DET,
                                                                           Lr_DetallePago.PAGO_ID,
                                                                           Lr_DetallePago.ESTADO_PAGO);
      --

    END LOOP;
    --
    COMMIT;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR_INDIVIDUAL. '||Pv_MensajeError;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR_INDIVIDUAL. '||SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR( 'Telcos+',
                                            'FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR',
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

  END P_CONTABILIZAR_INDIVIDUAL;

END FNKG_CONTABILIZAR_PAGOS_RET;
/