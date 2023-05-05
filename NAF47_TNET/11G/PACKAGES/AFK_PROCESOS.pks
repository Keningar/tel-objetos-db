CREATE OR REPLACE PACKAGE            AFK_PROCESOS IS
/**
* Documentacion para NAF47_TNET.AFK_PROCESOSSS
* Paquete que contiene procesos y funciones para procesar los articulos por instalaciones y activos fijos
* @author llindao <llindao@telconet.ec>
* @version 1.0 16/07/2012
*
* @author llindao <llindao@telconet.ec>
* @version 1.1 03/07/2016 Se modifica para procesar activos masivamente
*/

/**
* Documentacion para Lr_CargaAF
* TyperRecord creado para pasar los parametros necesarios para procesar Activo Fjo
* @author llindao <llindao@telconet.ec>
* @version 1.0 03/07/2017
*/
  TYPE Lr_CargaAF IS RECORD(
    NO_CIA       ARAFMA.NO_CIA%TYPE,
    MARCA        ARAFMA.COD_MARCA%TYPE,
    TIPO         ARAFMA.TIPO%TYPE,
    GRUPO        ARAFMA.GRUPO%TYPE,
    SUBGRUPO     ARAFMA.SUBGRUPO%TYPE,
    CENTRO_COSTO ARAFMA.CENTRO_COSTO%TYPE,
    AREA         ARAFMA.AREA%TYPE,
    DEPARTAMENTO ARAFMA.NO_DEPA%TYPE,
    NO_FISICO    ARAFMA.NO_FISICO%TYPE,
    SERIE_FISICO ARAFMA.SERIE_FISICO%TYPE,
    MONTO        ARAFMA.VAL_ORIGINAL%TYPE,
    FECHA_COMPRA ARAFMA.F_INGRE%TYPE,
    VIDA_UTIL    ARAFMA.DURACION%TYPE,
    CUENTA_VO    ARAFMA.CTAVO%TYPE,
    CUENTA_DAVO  ARAFMA.CTADAVO%TYPE,
    CUENTA_GAVO  ARAFMA.CTAGAVO%TYPE,
    METODO_DEP   ARAFMA.METODO_DEP%TYPE,
    CANTIDAD_REG NUMBER(12)
     );

  /**
  * Documentacion para P_REPLICA_ACTIVO_FIJO
  * Procedure que realiza el ingreso automaticos de los articulos identificados como activos fijos.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/05/2017
  *
  * @param Pr_Arafma       IN ARAFMA%ROWTYPE Recibe registro de activo fijo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_REPLICA_ACTIVO_FIJO ( Pr_Arafma       IN NAF47_TNET.ARAFMA%ROWTYPE,
                                    Pv_MensajeError IN OUT VARCHAR2 );
  /**
  * Documentacion para P_REPOSITORIO_ARTICULOS
  * Procedure alimenta el repositorio de instalacion y activos fijos.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/05/2017
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 29/06/2018 - Se modifica para convertir numero mac a minusculas cuando se despacha equipo TELLION
  *
  * No se consideran los activos fijos para alimentar el repositorio.
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.2 03/01/2019
  *
  * se ajusta para validar con tipo de articulos configurados.
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.3 28/09/2021
  *
  * @param Pv_IdDocumento  IN VARCHAR2 Recibe numero de documento
  * @param Pv_IdCompania   IN VARCHAR2 Recibe codigo compania
  * @param Pv_TipoArticulo IN VARCHAR2 Recibe tipo de articulo [AF] Activo Fijo [IN] Instalaciones
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_REPOSITORIO_ARTICULOS ( Pv_IdDocumento  IN VARCHAR2,
                                      Pv_IdCompania   IN VARCHAR2,
                                      Pv_TipoArticulo IN VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2);

  ---------------------------------------------------------
  -- Procedimiento que actualiza saldos de instalaciones --
  ---------------------------------------------------------
  PROCEDURE IN_P_PROCESA_INSTALACION(Pv_NoCia        IN VARCHAR2,
                                     Pv_IdArticulo   IN VARCHAR2,
                                     Pv_TipoArticulo IN VARCHAR2,
                                     Pv_NumeroCedula IN VARCHAR2,
                                     Pv_NumeroSerie  IN VARCHAR2,
                                     Pn_Cantidad     IN NUMBER,
                                     Pv_MensajeError IN OUT VARCHAR2);

  ------------------------------------------------------
  -- Procedimiento que realiza el retiro de Articulos --
  ------------------------------------------------------
  /**
  * Documentacion para IN_P_RETIRA_INSTALACION
  * Procedure procesa los retiroes de equipos en repositorio de instalación.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/05/2017
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 10/12/2021 - Se modifica para agregar parametro que controle ejecución de rollback
  *
  *
  * @param Pv_NoCia        IN VARCHAR2     Recibe código compañía
  * @param Pv_IdArticulo   IN VARCHAR2     Recibe código de artículo
  * @param Pv_TipoArticulo IN VARCHAR2     Recibe tipo de artículo [AF] Activo Fijo [IN] Instalaciones
  * @param Pv_NumeroCedula IN VARCHAR2     Recibe número de cédla de empleado
  * @param Pv_NumeroSerie  IN VARCHAR2     Recibe número serie de artículo
  * @param Pn_Cantidad     IN NUMBER       Recibe cantidad a procesar
  * @param Pv_Estado       IN VARCHAR2     Recibe estado a asignar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.,
  * @param Pb_Rollback     IN VARCHAR2     Indica si se ejecuta Rollback, por defecto es verdadero
  */
  PROCEDURE IN_P_RETIRA_INSTALACION( Pv_NoCia        IN VARCHAR2,
                                     Pv_IdArticulo   IN VARCHAR2,
                                     Pv_TipoArticulo IN VARCHAR2,
                                     Pv_NumeroCedula IN VARCHAR2,
                                     Pv_NumeroSerie  IN VARCHAR2,
                                     Pn_Cantidad     IN NUMBER,
                                     Pv_Estado  IN VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2,
                                     Pb_Rollback IN BOOLEAN DEFAULT TRUE);

  -------------------------------------------
  -- FUNCION QUE REALIZA EL CALCULO DE MAC --
  -------------------------------------------
  FUNCTION IN_F_CALCULA_MAC ( Pv_MAC      IN VARCHAR2,
                              Pv_Calcular IN VARCHAR2) RETURN VARCHAR2;


  -----------------------------------------------------------------
  -- Instalaciones de Articulos en base a solicitudes de pedidos --
  -----------------------------------------------------------------
  PROCEDURE IN_ART_INSTALACION_SOLICITUD (Pv_IdDespacho   IN VARCHAR2,
                                          --Pv_IdCentro     IN VARCHAR2,
                                          Pv_IdCompania   IN VARCHAR2,
                                          Pv_MensajeError IN OUT VARCHAR2);

  ----------------------------------------------------------------------------------------------------
  -- Procedimiento que libera equipos en telcos y naf mediante solicitud de retiro o inconsistencia --
  ----------------------------------------------------------------------------------------------------
  PROCEDURE IN_P_LIBERA_EQUIPO( Pv_NumeroSerie  IN VARCHAR2,
                                Pn_IdElemento   IN NUMBER,
                                Pn_IdServicio   IN VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2);


  ---------------------------------------------------------------------------------------------
  -- Procedimiento que genera por tipo de Activo asiento de regualrizacion de cuenta puente  --
  ---------------------------------------------------------------------------------------------
  /**
  Documentaci¿n para P_GENERA_ASIENTO_REGULARIZA
  Procedimiento que realiza la generacion del asiento contable por regularizaci¿n de cuenta puente

  @author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
  @version 1.0  05/06/2017

  @param  Pv_cia   IN varchar2  Recibe el codigo de la empresa
  @param  Pn_ano   IN number Recibe el a¿o de proceso del modulo
  @param  Pn_mes   IN number Recibe el mes de proceso del modulo
  @param  Pd_fecha IN date Recibe el ultimo dia del mes en proceso
  @param  Pv_CodigoDiario IN Recibe el codigo de diario
  @param  Pn_TipoCambio   IN Recibe el tipo de cambio
  @param  Pv_TcambCV      IN Recibe el tipo Compra o Venta
  @param  Pn_NumAsiento   IN OUT number Retorna el numero de asiento generado
  @param  Pv_Error        IN OUT varchar2 Retorna mensaje de error
  **/
  PROCEDURE P_GENERA_ASIENTO_REGULARIZA (Pv_cia   IN varchar2,
                                         Pn_ano   IN number,
                                         Pn_mes   IN number,
                                         Pd_fecha IN date,
                                         Pv_CodigoDiario IN varchar2,
                                         Pn_TipoCambio   IN number,
                                         Pv_TcambCV      IN varchar2,
                                         Pn_NumAsiento   IN arcgae.no_asiento%type,
                                         Pv_Error        IN OUT varchar2 );

  /**
  Documentaci¿n para P_GENERA_ASIENTO_DEPRECIACION
  Procedimiento que realiza la generacion del asiento cantables por depereciaciones

  @author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
  @version 1.0  07/06/2017

  @param  Pv_cia   IN varchar2  Recibe el codigo de la empresa
  @param  Pn_ano   IN number Recibe el a¿o de proceso del modulo
  @param  Pn_mes   IN number Recibe el mes de proceso del modulo
  @param  Pd_fecha IN date Recibe el ultimo dia del mes en proceso
  @param  Pv_CodigoDiario IN Recibe el codigo de diario
  @param  Pn_TipoCambio   IN Recibe el tipo de cambio
  @param  Pv_TcambCV      IN Recibe el tipo Compra o Venta
  @param  Pn_NumAsiento   IN OUT number Retorna el numero de asiento generado
  @param  Pv_Error        IN OUT varchar2 Retorna mensaje de error
  **/
  PROCEDURE P_GENERA_ASIENTO_DEPRECIACION (Pv_cia   IN varchar2,
                                           Pn_ano   IN number,
                                           Pn_mes   IN number,
                                           Pd_fecha IN date,
                                           Pv_CodigoDiario IN varchar2,
                                           Pn_TipoCambio   IN number,
                                           Pv_TcambCV      IN varchar2,
                                           Pn_NumAsiento   IN OUT arcgae.no_asiento%type,
                                           Pv_Error        IN OUT varchar2 );


  /**
  Documentacion para P_INSERTA_LINEA_AUXILIAR
  Procedimiento que realiza la creacion de linea contable para armar auxiliar
  en la genracion del asiento contable por depreciaci¿n.

  @author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
  @version 1.0  07/06/2017

  @param  Pv_cia IN arafau.no_cia%type  Recibe el codigo de la empresa
  @param  Pv_Cuenta IN arafau.cuenta%type  Recibe el codigo de la cuenta contabnle
  @param  Pn_Monto IN arafau.debitos%type  Recibe el monto por cuenta y centro
  @param  Pn_MontoDol IN arafau.debitos_dol%type  Recibe el monto en dolares por cuenta y centro
  @param  Pv_CentroCosto IN arafau.cent_cost%type  Recibe el centro de costos
  @param  Pv_Tipo IN varchar2  Recibe el tipo de movimiento de la cuenta
  **/
  Procedure P_INSERTA_LINEA_AUXILIAR (Pv_cia         IN arafau.no_cia%type,
                                      Pv_Cuenta      IN arafau.cuenta%type,
                                      Pn_Monto       IN arafau.debitos%type,
                                      Pn_MontoDol    IN arafau.debitos_dol%type,
                                      Pv_CentroCosto IN arafau.cent_cost%type,
                                      Pv_Tipo        IN arcgal.tipo%type );

  /**
  * Documentacion para P_CIERRE_MENSUAL_ACTIVOS_FIJOS
  * Procedimiento que realiza el Cierre Mensual del modulo de Activos Fijos
  *
  * @param  Pv_cia IN varchar2  Recibe el codigo de la empresa
  * @param  Pn_ano IN number Recibe el anio de proceso del modulo
  * @param  Pn_mes IN number Recibe el mes de proceso del modulo
  * @param  Pv_Error IN OUT varchar2 Retorna mensaje de error
  *
  * @author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
  * @version 1.0  02/08/2017
  **/
  Procedure P_CIERRE_MENSUAL_ACTIVOS_FIJOS(Pv_cia   IN varchar2,
                                           Pn_ano   IN number,
                                           Pn_mes   IN number,
                                           Pv_Error IN OUT varchar2 );


  /**
  Documentacion para P_DIFERENCIA_CENTAVOS
  Procedimiento que realiza ajuste por centavo a cuenta de Debito
  **/
  Procedure P_DIFERENCIA_CENTAVOS (Pv_cia        IN varchar2,
                                   Pn_NumAsiento IN arcgae.no_asiento%type,
                                   Pv_Error      IN OUT varchar2 );

  /**
  * Documentacion para P_INICIALIZA_TEMPORAL
  * Procedure que elimina registros de tabla temporal de carga
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 03/07/2017
  *
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compa¿¿¿¿a
  * @param Pn_Procesado    IN NUMBER Recibe tipo de eliminaci¿¿n a realizar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INICIALIZA_TEMPORAL ( Pv_NoCia        IN VARCHAR2,
                                    Pn_Procesado    IN NUMBER,
                                    Pv_MensajeError IN OUT VARCHAR2 );

  /**
  * Documentacion para P_REGISTRA_CARGA_TEMPORAL
  * Procedure que inserta el numero de serie en tabla temporal
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 03/07/2017
  *
  * @param Pv_NumeroSerie  IN NUMBER Recibe n¿¿mero de serie a registrar en carga
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compa¿¿¿¿a
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_REGISTRA_CARGA_TEMPORAL ( Pv_NumeroSerie  IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2,
                                        Pv_MensajeError IN OUT VARCHAR2 );

  /**
  * Documentacion para P_VALIDA_CARGA
  * Procedure que recupera datos de repositorio de instalaci¿¿n y de Telcos los logines asociados
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 03/07/2017
  *
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compa¿¿¿¿a
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_VALIDA_CARGA ( Pv_NoCia        IN VARCHAR2,
                                                Pv_MensajeError IN OUT VARCHAR2 );

  /**
  * Documentacion para P_INFORMACION_COMPLEMENTARIA
  * Procedure que recupera datos de repositorio de instalaci¿¿n y de Telcos los logines asociados
  * @author  mnavarrete <mnavarrete@telconet.ec>
  * @version 1.0 03/07/2017
  *
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compa¿¿¿¿a
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INFORMACION_COMPLEMENTARIA ( Pv_NoCia           IN VARCHAR2,
                                                                          Pv_MensajeError IN OUT VARCHAR2 );

  /**
  * Documentacion para P_PROCESAR_ACTIVO_FIJO
  * Procedure que genera informaci¿¿n a m¿¿dulo activo fijo
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 03/07/2017
  *
  * @param Pr_DatosAF      IN VARCHAR2 Recibe datos necesarios para procesar activo fijo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_PROCESAR_ACTIVO_FIJO ( Pr_DatosAF      IN AFK_PROCESOS.Lr_CargaAF,
                                                              Pv_MensajeError IN OUT VARCHAR2 );

  /**
  * Documentacion para P_PROCESAR_ACTIVO_FIJO_DESECHO 
  * Procedure que genera informaci¿¿n a m¿¿dulo activo fijo
  * @author mnavarrete <mnavarrete@telconet.ec>
  * @version 1.0 07/12/2017
  *
  * @param Pr_DatosAF      IN VARCHAR2 Recibe datos necesarios para procesar activo fijo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_PROCESAR_ACTIVO_FIJO_DESECHO ( Pr_DatosAF      IN AFK_PROCESOS.Lr_CargaAF,
                                                                             Pv_MensajeError IN OUT VARCHAR2 );
END AFK_PROCESOS;
/


CREATE OR REPLACE PACKAGE BODY            AFK_PROCESOS IS

  /**
  * Documentacion para P_GENERA_MOVIMIENTO_AF
  * Procedure genera el movimiento que refleja el ingreso del articulo al modulo de activo fijo.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/05/2017
  *
  * @param Pr_Arafmm  IN ARAFMM%ROWTYPE Recibe registro de ingreso de activo fijo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_GENERA_MOVIMIENTO_AF ( Pr_Arafmm       IN ARAFMM%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2) IS
    --
    Lv_NoDocu  ARAFMM.NO_ACTI%TYPE := NULL;
    --
  BEGIN
    --
    IF Pr_Arafmm.No_Docu IS NULL THEN
      Lv_NoDocu := TRANSA_ID.AF(Pr_Arafmm.No_Cia);
    ELSE
      Lv_NoDocu := Pr_Arafmm.No_Docu;
    END IF;

    INSERT INTO ARAFMM(
      NO_CIA,
      NO_DOCU,
      NO_ACTI,
      FECHA,
      HORA,
      TIPO_M,
      AREA_A,
      NO_DEPA_A,
      NO_EMPL_A,
      MONTO,
      ESTADO,
      CC_ACT,
      TIPO_CAMBIO,
      ANO,
      MES )
    VALUES(
      Pr_Arafmm.no_cia,
      Lv_NoDocu,
      Pr_Arafmm.no_acti,
      Pr_Arafmm.fecha,
      Pr_Arafmm.hora,
      Pr_Arafmm.tipo_m,
      Pr_Arafmm.area_a,
      Pr_Arafmm.no_depa_a,
      Pr_Arafmm.no_empl_a,
      Pr_Arafmm.monto,
      Pr_Arafmm.estado,
      Pr_Arafmm.cc_act,
      Pr_Arafmm.tipo_cambio,
      Pr_Arafmm.ano,
      Pr_Arafmm.mes);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_GENERA_MOVIMIENTO_AF. '||SQLERRM;
      ROLLBACK;
  END P_GENERA_MOVIMIENTO_AF;
  --
  --
  PROCEDURE P_REPLICA_ACTIVO_FIJO ( Pr_Arafma    IN NAF47_TNET.ARAFMA%ROWTYPE,
                                    Pv_MensajeError IN OUT VARCHAR2 ) IS
    --
    CURSOR C_SECUENCIA IS
      SELECT MAX(TO_NUMBER(NO_ACTI))
      FROM NAF47_TNET.ARAFMA
      WHERE NO_CIA = Pr_Arafma.No_Cia;
    --
    Ln_NoActivo  NUMBER(12) := NULL;
    Lr_Arafmm    ARAFMM%ROWTYPE := NULL;
    Le_Error     EXCEPTION;
    --
  BEGIN
    IF Pr_Arafma.No_Acti IS NULL THEN
      IF C_SECUENCIA%ISOPEN THEN
        CLOSE C_SECUENCIA;
      END IF;
      OPEN C_SECUENCIA;
      FETCH C_SECUENCIA INTO Ln_NoActivo;
      IF C_SECUENCIA%NOTFOUND THEN
        Ln_NoActivo := 0;
      END IF;
      CLOSE C_SECUENCIA;
      --
      Ln_NoActivo := NVL(Ln_NoActivo,0) + 1;
      --
    ELSE
      --
      Ln_NoActivo := Pr_Arafma.No_Acti;
      --
    END IF;
    --
    INSERT INTO NAF47_TNET.ARAFMA (
      NO_CIA,
      NO_ACTI,
      DESCRI,
      DESCRI1,
      AREA,
      NO_DEPA,
      SECCION,
      NO_EMPLE,
      SERIE,
      MARCA,
      MODELO,
      TIPO,
      GRUPO,
      SUBGRUPO,
      F_INGRE,
      DURACION,
      NO_PROVE,
      PROVEEDOR,
      NO_FISICO,
      SERIE_FISICO,
      NO_REFE,
      ORD_COMP,
      F_EGRE,
      F_DEPRE,
      DESECHO,
      CTAVO,
      CTADAVO,
      CTAGAVO,
      CTARE,
      CTADARE,
      CTAGARE,
      CENTRO_COSTO,
      FECHA_CAMBIO,
      TIPO_CAMBIO,
      T_CAMB_C_V,
      INDICE,
      METODO_DEP,
      FECHA_INICIO_DEP,
      VIDA_UTIL_RESIDUAL,
      VAL_ORIGINAL,
      MEJORAS,
      REV_TECS,
      DEPACUM_VALORIG_ANT,
      DEPACUM_MEJORAS_ANT,
      DEPACUM_REVTECS_ANT,
      DEPACUM_VALORIG,
      DEPACUM_MEJORAS,
      DEPACUM_REVTECS,
      DEPRE_EJER_VO_ANT,
      DEPRE_EJER_VO,
      DEPRE_EJER_MEJ_ANT,
      DEPRE_EJER_MEJ,
      DEPRE_EJER_REVTEC_ANT,
      DEPRE_EJER_REVTEC,
      VAL_ORIGINAL_DOL,
      MEJORAS_DOL,
      REV_TECS_DOL,
      DEPACUM_VALORIG_ANT_DOL,
      DEPACUM_MEJORAS_ANT_DOL,
      DEPACUM_REVTECS_ANT_DOL,
      DEPACUM_VALORIG_DOL,
      DEPACUM_MEJORAS_DOL,
      DEPACUM_REVTECS_DOL,
      DEPRE_EJER_VO_ANT_DOL,
      DEPRE_EJER_VO_DOL,
      DEPRE_EJER_MEJ_ANT_DOL,
      DEPRE_EJER_MEJ_DOL,
      DEPRE_EJER_REVTEC_ANT_DOL,
      DEPRE_EJER_REVTEC_DOL,
      ULT_ANO_CIERRE,
      ULT_MES_CIERRE,
      ESTADO,
      COD_BARRA,
      COD_ETIQUETA,
      TIPO_ADQUISICION,
      COD_INT_ACTIVO,
      FECHA_FIN_VIDA_UTIL,
      COD_MARCA,
      DEPACUM_VO_INICIAL,
      NO_ARTI,
      GRUPO_CLIENTE,
      CLIENTE,
      NO_CIA_CUSTODIO,
      ORIGEN,
      USUARIO,
      LOGIN_CLIENTE,
      NOMBRE_CPE )
    VALUES (
      Pr_Arafma.no_cia,
      TO_CHAR(Ln_NoActivo),
      Pr_Arafma.descri,
      Pr_Arafma.descri1,
      Pr_Arafma.area,
      Pr_Arafma.no_depa,
      Pr_Arafma.seccion,
      Pr_Arafma.no_emple,
      Pr_Arafma.serie,
      Pr_Arafma.marca,
      Pr_Arafma.modelo,
      Pr_Arafma.tipo,
      Pr_Arafma.grupo,
      Pr_Arafma.subgrupo,
      Pr_Arafma.f_ingre,
      Pr_Arafma.duracion,
      Pr_Arafma.no_prove,
      Pr_Arafma.proveedor,
      Pr_Arafma.no_fisico,
      Pr_Arafma.serie_fisico,
      Pr_Arafma.no_refe,
      Pr_Arafma.ord_comp,
      Pr_Arafma.f_egre,
      Pr_Arafma.f_depre,
      Pr_Arafma.desecho,
      Pr_Arafma.ctavo,
      Pr_Arafma.ctadavo,
      Pr_Arafma.ctagavo,
      Pr_Arafma.ctare,
      Pr_Arafma.ctadare,
      Pr_Arafma.ctagare,
      Pr_Arafma.centro_costo,
      Pr_Arafma.fecha_cambio,
      Pr_Arafma.tipo_cambio,
      Pr_Arafma.t_camb_c_v,
      Pr_Arafma.indice,
      Pr_Arafma.metodo_dep,
      Pr_Arafma.fecha_inicio_dep,
      Pr_Arafma.vida_util_residual,
      Pr_Arafma.val_original,
      Pr_Arafma.mejoras,
      Pr_Arafma.rev_tecs,
      Pr_Arafma.depacum_valorig_ant,
      Pr_Arafma.depacum_mejoras_ant,
      Pr_Arafma.depacum_revtecs_ant,
      Pr_Arafma.depacum_valorig,
      Pr_Arafma.depacum_mejoras,
      Pr_Arafma.depacum_revtecs,
      Pr_Arafma.depre_ejer_vo_ant,
      Pr_Arafma.depre_ejer_vo,
      Pr_Arafma.depre_ejer_mej_ant,
      Pr_Arafma.depre_ejer_mej,
      Pr_Arafma.depre_ejer_revtec_ant,
      Pr_Arafma.depre_ejer_revtec,
      Pr_Arafma.val_original_dol,
      Pr_Arafma.mejoras_dol,
      Pr_Arafma.rev_tecs_dol,
      Pr_Arafma.depacum_valorig_ant_dol,
      Pr_Arafma.depacum_mejoras_ant_dol,
      Pr_Arafma.depacum_revtecs_ant_dol,
      Pr_Arafma.depacum_valorig_dol,
      Pr_Arafma.depacum_mejoras_dol,
      Pr_Arafma.depacum_revtecs_dol,
      Pr_Arafma.depre_ejer_vo_ant_dol,
      Pr_Arafma.depre_ejer_vo_dol,
      Pr_Arafma.depre_ejer_mej_ant_dol,
      Pr_Arafma.depre_ejer_mej_dol,
      Pr_Arafma.depre_ejer_revtec_ant_dol,
      Pr_Arafma.depre_ejer_revtec_dol,
      Pr_Arafma.ult_ano_cierre,
      Pr_Arafma.ult_mes_cierre,
      Pr_Arafma.estado,
      Pr_Arafma.cod_barra,
      Pr_Arafma.cod_etiqueta,
      Pr_Arafma.tipo_adquisicion,
      Pr_Arafma.cod_int_activo,
      Pr_Arafma.fecha_fin_vida_util,
      Pr_Arafma.cod_marca,
      Pr_Arafma.depacum_vo_inicial,
      Pr_Arafma.no_arti,
      Pr_Arafma.grupo_cliente,
      Pr_Arafma.cliente,
      Pr_Arafma.no_cia_custodio,
      Pr_Arafma.origen,
      Pr_Arafma.usuario,
      Pr_Arafma.Login_Cliente,
      Pr_Arafma.Nombre_Cpe );

    -- Se registra el movimiento de ingresod e activo fijo
    Lr_Arafmm.NO_CIA := Pr_Arafma.NO_CIA;
    Lr_Arafmm.NO_ACTI := TO_CHAR(Ln_NoActivo);
    Lr_Arafmm.FECHA := Pr_Arafma.f_Ingre;
    Lr_Arafmm.HORA := TO_NUMBER(TO_CHAR(SYSDATE,'HH24MI'));
    Lr_Arafmm.TIPO_M := 'A';
    Lr_Arafmm.Monto := Pr_Arafma.Val_Original;
    Lr_Arafmm.Estado := 'P';
    Lr_Arafmm.cc_act := Pr_Arafma.Centro_Costo;
    Lr_Arafmm.tipo_cambio := Pr_Arafma.Tipo_Cambio;
    Lr_Arafmm.ano := TO_NUMBER(TO_CHAR(Pr_Arafma.f_Ingre,'YYYY'));
    Lr_Arafmm.mes := TO_NUMBER(TO_CHAR(Pr_Arafma.f_Ingre,'MM'));
    --
    P_GENERA_MOVIMIENTO_AF(Lr_Arafmm, Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_REPLICA_ACTIVO_FIJO. '||SQLERRM;
      ROLLBACK;
  END P_REPLICA_ACTIVO_FIJO;
  --
  --
  PROCEDURE P_REPOSITORIO_ARTICULOS ( Pv_IdDocumento  IN VARCHAR2,
                                      Pv_IdCompania   IN VARCHAR2,
                                      Pv_TipoArticulo IN VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2) IS
    -- cursor que recupera los articulos que se van a registra en repositorio de articulos Activos Fijos o Instalaciones
    -- @Costo: 107
    CURSOR C_ARTICULOS_INSTALACION IS
     -- recupera los articulos instalacion basado en despacho Bodega por pedido
      SELECT A.NO_CIA ID_COMPANIA,
        A.CENTRO ID_CENTRO,
        B.NO_ARTI ID_ARTICULO,
        D.DESCRIPCION,
        D.MODELO,
        C.SERIE NUMERO_SERIE,
        TRIM(REPLACE(REPLACE(REPLACE(C.MAC,'.',''),CHR(10),''),CHR(13),'')) MAC,
        NULL MAC_ORIGINAL,
        DECODE(D.IND_CONTROL_ACTIVO_FIJO, 'S', 'AF', 'MT') TIPO_ARTICULO,
        DECODE(D.IND_REQUIERE_SERIE, 'S', 1, B.UNIDADES) CANTIDAD,
        DECODE(D.IND_REQUIERE_SERIE, 'S', 1, B.UNIDADES) SALDO,
        NVL(D.PRECIOBASE, 0) PRECIO_BASE,
        A.FECHA,
        NULL ID_CUSTODIO,
        NULL CEDULA,
        A.C_COSTO_EMPLESOL CENTRO_COSTO,
        A.NO_DOCU ID_DOCUMENTO_ORIGEN,
        A.TIPO_DOC TIPO_DOCUMENTO_ORIGEN,
        B.LINEA LINEA_DOCUMENTO_ORIGEN,
        D.MARCA,
        NULL TIPO_ACTIVO,
        NULL GRUPO_ACTIVO,
        NULL SUBGRUPO_ACTIVO,
        B.BODEGA ID_BODEGA,
        G.DESCRIPCION NOMBRE_BODEGA,
        G.ID_PAIS,
        G.ID_REGION,
        G.ID_PROVINCIA,
        G.ID_CANTON,
        G.ID_PARROQUIA,
        'PI' ESTADO,
        A.EMPLE_SOLIC ID_RESPONSABLE,
        A.NO_CIA_RESPONSABLE,
        (SELECT M.DESCRIPCION
         FROM MARCAS M
         WHERE M.CODIGO = D.MARCA
        AND M.NO_CIA = D.NO_CIA) DESC_MARCA,
        'IN' TIPO_PROCESO,
        (SELECT P.PARAMETRO_ALTERNO
         FROM GE_PARAMETROS P
         WHERE P.ID_GRUPO_PARAMETRO = 'DOC_DESPACHOS_AF'
         AND P.ID_APLICACION = 'AF'
         AND P.PARAMETRO = A.TIPO_DOC
         AND P.ID_EMPRESA = A.NO_CIA ) ID_EMPRESA_DESPACHA
      FROM ARINME A,
        ARINML B,
        INV_DOCUMENTO_SERIE C,
        ARINDA D,
        ARINBO G
      WHERE A.NO_DOCU = B.NO_DOCU
      AND A.NO_CIA = B.NO_CIA
      AND B.NO_ARTI = D.NO_ARTI
      AND B.NO_CIA = D.NO_CIA
      AND B.BODEGA = G.CODIGO
      AND B.NO_CIA = G.NO_CIA
      AND NVL(D.USADO_INSTALACION, 'N') = 'S' --solo los articulos seteados como instalacion
      AND D.TIPO_ARTICULO NOT IN (SELECT D.VALOR2  
                                    FROM DB_GENERAL.ADMI_PARAMETRO_DET D,
                                         DB_GENERAL.ADMI_PARAMETRO_CAB C
                                    WHERE D.PARAMETRO_ID=C.ID_PARAMETRO
                                      AND C.NOMBRE_PARAMETRO='PARAMETROS-TIPO-ARTICULO'
                                      AND D.EMPRESA_COD=Pv_IdCompania
                                      AND D.VALOR4='REPOSITORIO_ARTICULOS')
      AND B.LINEA = C.LINEA (+)
      AND B.NO_DOCU = C.ID_DOCUMENTO (+)
      AND B.NO_CIA = C.COMPANIA (+)
      AND A.NO_DOCU = Pv_IdDocumento
      AND A.NO_CIA = Pv_IdCompania
      AND Pv_TipoArticulo IN ('IN','TD')
      --
      UNION
      -- recupera articulos instalacion basado en despacho bodega manual
      SELECT A.NO_CIA ID_COMPANIA,
        A.CENTRO ID_CENTRO,
        B.NO_ARTI ID_ARTICULO,
        D.DESCRIPCION,
        D.MODELO,
        C.SERIE NUMERO_SERIE,
        TRIM(REPLACE(REPLACE(REPLACE(C.MAC,'.',''),CHR(10),''),CHR(13),'')) MAC,
        NULL MAC_ORIGINAL,
        DECODE(D.IND_CONTROL_ACTIVO_FIJO, 'S', 'AF', 'MT') TIPO_ARTICULO,
        DECODE(D.IND_REQUIERE_SERIE, 'S', 1, B.CANTIDAD_DESPACHADA) CANTIDAD,
        DECODE(D.IND_REQUIERE_SERIE, 'S', 1, B.CANTIDAD_DESPACHADA) SALDO,
        NVL(D.PRECIOBASE, 0) PRECIO_BASE,
        A.FECHA,
        NULL ID_CUSTODIO,
        NULL CEDULA,
        A.CENTRO_COSTO,
        A.NUMERO_SOLICITUD ID_DOCUMENTO_ORIGEN,
        A.TIPO_DOCUMENTO TIPO_DOCUMENTO_ORIGEN,
        B.NUMERO_LINEA LINEA_DOCUMENTO_ORIGEN,
        D.MARCA,
        C.TIPO TIPO_ACTIVO,
        C.GRUPO GRUPO_ACTIVO,
        C.SUBGRUPO SUBGRUPO_ACTIVO,
        B.BODEGA ID_BODEGA,
        G.DESCRIPCION NOMBRE_BODEGA,
        G.ID_PAIS,
        G.ID_REGION,
        G.ID_PROVINCIA,
        G.ID_CANTON,
        G.ID_PARROQUIA,
        'PI' ESTADO,
        A.USUARIO_APROBACION ID_RESPONSABLE,
        A.NO_CIA_RESPONSABLE,
        (SELECT M.DESCRIPCION
         FROM MARCAS M
         WHERE M.CODIGO = D.MARCA
         AND M.NO_CIA = D.NO_CIA) DESC_MARCA,
        'IN' TIPO_PROCESO,
        (SELECT P.PARAMETRO_ALTERNO
         FROM GE_PARAMETROS P
         WHERE P.ID_GRUPO_PARAMETRO = 'DOC_DESPACHOS_AF'
         AND P.ID_APLICACION = 'AF'
         AND P.PARAMETRO = A.TIPO_DOCUMENTO
         AND P.ID_EMPRESA = A.NO_CIA ) ID_EMPRESA_DESPACHA
      FROM INV_CAB_SOLICITUD_REQUISICION A,
        INV_DET_SOLICITUD_REQUISICION B,
        INV_SOLICREQUI_ARTI_ACTI      C,
        ARINDA                        D,
        ARINBO                        G
      WHERE A.NUMERO_SOLICITUD = B.NUMERO_SOLICITUD
      AND A.NO_CIA = B.NO_CIA
      AND B.NO_ARTI = D.NO_ARTI
      AND B.NO_CIA = D.NO_CIA
      AND B.BODEGA = G.CODIGO
      AND B.NO_CIA = G.NO_CIA
      AND NVL(D.USADO_INSTALACION, 'N') = 'S' --solo los articulos seteados como instalacion
      AND D.TIPO_ARTICULO NOT IN (SELECT D.VALOR2  
                                    FROM DB_GENERAL.ADMI_PARAMETRO_DET D,
                                         DB_GENERAL.ADMI_PARAMETRO_CAB C
                                    WHERE D.PARAMETRO_ID=C.ID_PARAMETRO
                                      AND C.NOMBRE_PARAMETRO='PARAMETROS-TIPO-ARTICULO'
                                      AND D.EMPRESA_COD=Pv_IdCompania
                                      AND D.VALOR4='REPOSITORIO_ARTICULOS')
      AND B.NO_ARTI = C.NO_ARTI(+)
      AND B.NUMERO_LINEA = C.NUMERO_LINEA(+)
      AND B.NUMERO_SOLICITUD = C.NUMERO_SOLICITUD(+)
      AND B.NO_CIA = C.NO_CIA(+)
      AND A.NUMERO_SOLICITUD = Pv_IdDocumento
      AND A.NO_CIA = Pv_IdCompania
      AND Pv_TipoArticulo IN ('IN','TD');

    --
    CURSOR C_ID_INSTALACION IS
      SELECT NVL(MAX(A.ID_INSTALACION), 0) + 1 ID_INSTALACION
        FROM IN_ARTICULOS_INSTALACION A
       WHERE A.ID_COMPANIA = Pv_IdCompania;
    --
    CURSOR C_CUSTODIO_EMPLEADO (Cv_IdEmpleado VARCHAR2,
                                Cv_IdEmpresa  VARCHAR2) IS
      SELECT A.NO_EMPLE, A.CEDULA
        FROM V_EMPLEADOS_EMPRESAS A
       WHERE A.NO_EMPLE = Cv_IdEmpleado
         AND A.NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_CUSTODIO_CONTRATISTA (Cv_IdContratista VARCHAR2,
                                   Cv_IdEmpresa     VARCHAR2) IS
      SELECT A.NO_CONTRATISTA, A.CEDULA
        FROM ARINMCNT A
       WHERE A.NO_CONTRATISTA = Cv_IdContratista
         AND A.NO_CIA = Cv_IdEmpresa;
    --
    TYPE Lr_ValidaMac IS RECORD
       ( TIPO  GE_PARAMETROS.PARAMETRO%TYPE,
         VALOR GE_PARAMETROS.DESCRIPCION%TYPE);
    --
    TYPE La_ValidaMac IS TABLE OF Lr_ValidaMac INDEX BY PLS_INTEGER;
    --
    Lt_ValidaMac         La_ValidaMac;
    Li_Indice            NUMBER(3) := 0;
    Ln_IdInstalacion     NUMBER(12) := 0;
    Ln_Secuencia         NUMBER(4) := 0;
    Ln_CostoArticulo     NUMBER(17, 2) := 0;
    Le_Error             EXCEPTION;
    Lb_CalculaMACxMarca  BOOLEAN;
    Lb_calculaMACxModelo BOOLEAN;
    Lb_MACinMinusMarca   BOOLEAN;
    Lb_MACinMinusModelo  BOOLEAN;
    --
  BEGIN
    -- OBTENEMOS SECUENCIA
    IF C_ID_INSTALACION%ISOPEN THEN
      CLOSE C_ID_INSTALACION;
    END IF;
    OPEN C_ID_INSTALACION;
    FETCH C_ID_INSTALACION
      INTO Ln_IdInstalacion;
    IF C_ID_INSTALACION%NOTFOUND THEN
      Ln_IdInstalacion := 1;
    END IF;
    CLOSE C_ID_INSTALACION;

    IF NVL(Ln_IdInstalacion, 0) = 0 THEN
      Ln_IdInstalacion := 1;
    END IF;

    --------------------------------------------
    -- SE VERIFICA SI SE GUARDA MAC CALCULADA --
    --------------------------------------------
    SELECT B.PARAMETRO,
           B.DESCRIPCION
           BULK COLLECT
      INTO Lt_ValidaMac
      FROM GE_GRUPOS_PARAMETROS A,
           GE_PARAMETROS B
     WHERE A.ID_GRUPO_PARAMETRO = B.ID_GRUPO_PARAMETRO
       AND A.ID_APLICACION = B.ID_APLICACION
       AND A.ID_EMPRESA = B.ID_EMPRESA
       AND A.ID_GRUPO_PARAMETRO = 'MAC_CALCULADA'
       AND A.ID_APLICACION = 'IN'
       AND A.ID_EMPRESA = Pv_IdCompania
       AND A.ESTADO = 'A'
       AND B.ESTADO = 'A';

    -- Se alimenta el repositorio.
    FOR Lr_instalacion IN C_ARTICULOS_INSTALACION LOOP

      -- si esta parametrizado guardar mac calculada se calcula
      IF Lr_instalacion.MAC IS NOT NULL THEN
        Lb_calculaMACxMarca := FALSE;
        Lb_calculaMACxModelo := FALSE;
        Lb_MACinMinusMarca := FALSE;
        Lb_MACinMinusModelo := FALSE;
        -- si esta parametrizado la validacion se valida
        IF NVL(Lt_ValidaMac.first, 0) > 0 THEN
          -- se verifica si valida MAC
          Li_Indice := Lt_ValidaMac.first;
          --
          LOOP
            CASE Lt_ValidaMac(Li_Indice).TIPO
              WHEN 'MODELO-LOW' THEN
                Lb_MACinMinusModelo := (UPPER(NVL(Lr_instalacion.Modelo,'@')) = UPPER(Lt_ValidaMac(Li_Indice).VALOR));
              WHEN 'MARCA-LOW' THEN
                Lb_MACinMinusMarca := (UPPER(NVL(Lr_instalacion.Desc_Marca,'@')) = UPPER(Lt_ValidaMac(Li_Indice).VALOR));
              WHEN 'MARCA' THEN
                Lb_calculaMACxMarca := (UPPER(NVL(Lr_instalacion.Desc_Marca,'@')) = UPPER(Lt_ValidaMac(Li_Indice).VALOR));
              WHEN 'MODELO' THEN
                Lb_calculaMACxModelo := (UPPER(NVL(Lr_instalacion.Modelo,'@')) = UPPER(Lt_ValidaMac(Li_Indice).VALOR));
              END CASE;

            EXIT WHEN Li_Indice = Lt_ValidaMac.last;
            Li_Indice := Li_Indice +1;
          END LOOP;
          --
        END IF; -- fin validacion parametrizada
        --
        -- Si registro cumple con las especificaciones para validar MAC se realiza
        Lr_instalacion.Mac_Original := Lr_instalacion.MAC;
        --
        IF Lb_calculaMACxMarca OR Lb_calculaMACxModelo THEN
          Lr_instalacion.MAC := AFK_PROCESOS.IN_F_CALCULA_MAC(Lr_instalacion.Mac_Original, 'S');
        END IF;
        --
        Lr_instalacion.MAC := AFK_PROCESOS.IN_F_CALCULA_MAC(Lr_instalacion.MAC, 'N');
        Lr_instalacion.Mac_Original := AFK_PROCESOS.IN_F_CALCULA_MAC(Lr_instalacion.Mac_Original, 'N');
        --
        -- Se parametriz¿ transformar en minuscula
        IF Lb_MACinMinusMarca OR Lb_MACinMinusModelo THEN
          Lr_instalacion.MAC := LOWER(Lr_instalacion.MAC);
        END IF;
        --
      END IF; -- fin mac not null

      -- busca si custodio es empleado o contratista
      IF C_CUSTODIO_EMPLEADO%ISOPEN THEN CLOSE C_CUSTODIO_EMPLEADO; END IF;
      OPEN C_CUSTODIO_EMPLEADO (Lr_instalacion.Id_Responsable, Lr_instalacion.No_Cia_Responsable);
      FETCH C_CUSTODIO_EMPLEADO INTO Lr_instalacion.Id_Custodio, Lr_instalacion.Cedula;
      IF C_CUSTODIO_EMPLEADO%NOTFOUND THEN
        Lr_instalacion.Id_Custodio := NULL;
        Lr_instalacion.Cedula := NULL;
      END IF;
      CLOSE C_CUSTODIO_EMPLEADO;

      -- En caso de no encontrarse como empleado, se busca como contratista
      IF Lr_instalacion.Id_Custodio IS NULL THEN
        IF C_CUSTODIO_CONTRATISTA%ISOPEN THEN CLOSE C_CUSTODIO_CONTRATISTA; END IF;
        OPEN C_CUSTODIO_CONTRATISTA (Lr_instalacion.Id_Responsable, Lr_instalacion.No_Cia_Responsable);
        FETCH C_CUSTODIO_CONTRATISTA INTO Lr_instalacion.Id_Custodio, Lr_instalacion.Cedula;
        IF C_CUSTODIO_CONTRATISTA%NOTFOUND THEN
          Lr_instalacion.Id_Custodio := NULL;
          Lr_instalacion.Cedula := NULL;
        END IF;
        CLOSE C_CUSTODIO_CONTRATISTA;

        -- Si vuelve a se nulo se emite mensaje de error .
        IF Lr_instalacion.Id_Custodio IS NULL THEN
          Pv_MensajeError := 'No se pudo determinar custodio como empleado ni como contratista, favor verifique.';
          RAISE Le_Error;
        END IF;
      END IF;

      -- busqueda del costo del articulo, si es usado entonces debe buscar la
      -- ultima depreciacion del AF con el costo.
      Ln_CostoArticulo := Articulo.Costo(Lr_instalacion.id_compania, Lr_instalacion.id_articulo, Lr_instalacion.id_bodega);
      --
      -- se asigan empresa que recibira activo fijo
      IF Lr_instalacion.Id_Empresa_Despacha IS NULL THEN
        Lr_instalacion.Id_Empresa_Despacha := Lr_instalacion.Id_Compania;
      END IF;

      Ln_Secuencia := Ln_Secuencia + 1;

      BEGIN
        INSERT INTO IN_ARTICULOS_INSTALACION
          (ID_COMPANIA,
           ID_CENTRO,
           ID_INSTALACION,
           SECUENCIA,
           ID_ARTICULO,
           DESCRIPCION,
           MODELO,
           NUMERO_SERIE,
           MAC,
           MAC_ORIGINAL,
           TIPO_ARTICULO,
           CANTIDAD,
           SALDO,
           COSTO,
           PRECIO_VENTA,
           FECHA,
           ID_EMPRESA_CUSTODIO,
           ID_CUSTODIO,
           CEDULA,
           CENTRO_COSTO,
           ID_DOCUMENTO_ORIGEN,
           TIPO_DOCUMENTO_ORIGEN,
           LINEA_DOCUMENTO_ORIGEN,
           MARCA,
           TIPO_ACTIVO,
           SUBGRUPO_ACTIVO,
           GRUPO_ACTIVO,
           ID_BODEGA,
           NOMBRE_BODEGA,
           PAIS,
           REGION,
           PROVINCIA,
           CANTON,
           PARROQUIA,
           ESTADO,
           ID_EMPRESA_DESPACHA,
           USR_CREACION,
           FE_CREACION,
           TIPO_PROCESO)
        VALUES
          (Lr_instalacion.ID_COMPANIA,
           Lr_instalacion.ID_CENTRO,
           Ln_IdInstalacion,
           Ln_Secuencia,
           Lr_instalacion.ID_ARTICULO,
           Lr_instalacion.DESCRIPCION,
           Lr_instalacion.MODELO,
           Lr_instalacion.NUMERO_SERIE,
           Lr_instalacion.MAC,
           Lr_instalacion.MAC_ORIGINAL,
           Lr_instalacion.TIPO_ARTICULO,
           Lr_instalacion.CANTIDAD,
           Lr_instalacion.SALDO,
           Ln_CostoArticulo,
           Lr_instalacion.PRECIO_BASE,
           Lr_instalacion.FECHA,
           Lr_instalacion.NO_CIA_RESPONSABLE,
           Lr_instalacion.ID_CUSTODIO,
           Lr_instalacion.CEDULA,
           Lr_instalacion.CENTRO_COSTO,
           Lr_instalacion.ID_DOCUMENTO_ORIGEN,
           Lr_instalacion.TIPO_DOCUMENTO_ORIGEN,
           Lr_instalacion.LINEA_DOCUMENTO_ORIGEN,
           Lr_instalacion.MARCA,
           Lr_instalacion.TIPO_ACTIVO,
           Lr_instalacion.SUBGRUPO_ACTIVO,
           Lr_instalacion.GRUPO_ACTIVO,
           Lr_instalacion.ID_BODEGA,
           Lr_instalacion.NOMBRE_BODEGA,
           Lr_instalacion.ID_PAIS,
           Lr_instalacion.ID_REGION,
           Lr_instalacion.ID_PROVINCIA,
           Lr_instalacion.ID_CANTON,
           Lr_instalacion.ID_PARROQUIA,
           Lr_instalacion.ESTADO,
           Lr_instalacion.Id_Empresa_Despacha,
           USER,
           SYSDATE,
           Lr_instalacion.TIPO_PROCESO);
      EXCEPTION
        WHEN OTHERS THEN
          Pv_MensajeError := 'Error insertar datos en : IN_ARTICULOS_INSTALACION' || SQLERRM;
          RAISE Le_Error;
      END;

    END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'P_REPOSITORIO_ARTICULOS :' || SQLERRM;
      ROLLBACK;
  END P_REPOSITORIO_ARTICULOS;
  ---------------------------------------------------------
  -- Procedimiento que actualiza saldos de instalaciones --
  ---------------------------------------------------------
  PROCEDURE IN_P_PROCESA_INSTALACION(Pv_NoCia        IN VARCHAR2,
                                     Pv_IdArticulo   IN VARCHAR2,
                                     Pv_TipoArticulo IN VARCHAR2,
                                     Pv_NumeroCedula IN VARCHAR2,
                                     Pv_NumeroSerie  IN VARCHAR2,
                                     Pn_Cantidad     IN NUMBER,
                                     Pv_MensajeError IN OUT VARCHAR2) IS

    -- cursor acticulo  is
    CURSOR C_MATERIAL_INSTALAR IS
      SELECT A.ID_COMPANIA,
             A.ID_INSTALACION,
             A.SECUENCIA,
             A.SALDO
        FROM IN_ARTICULOS_INSTALACION A
       WHERE A.CEDULA = Pv_NumeroCedula
         AND A.ID_ARTICULO = Pv_IdArticulo
         --AND A.ID_COMPANIA = Pv_NoCia
         AND A.TIPO_ARTICULO = Pv_TipoArticulo
         AND A.ESTADO = 'PI';--IN ('PI','RE');
    --
    CURSOR C_ACTIVO_FIJO_INSTALAR IS
      SELECT A.ID_COMPANIA,
             A.ID_INSTALACION,
             A.SECUENCIA,
             A.SALDO,
             A.DESCRIPCION,
             A.MODELO
        FROM IN_ARTICULOS_INSTALACION A
       WHERE A.NUMERO_SERIE = Pv_NumeroSerie
         AND A.TIPO_ARTICULO = Pv_TipoArticulo
         AND A.ESTADO = 'PI';--IN ('PI','RE');
    --
    Le_Error           EXCEPTION;
    Ln_SaldoDescontado NUMBER(17,2) := 0;
    Lr_ActivoFijo      C_ACTIVO_FIJO_INSTALAR%ROWTYPE := NULL;
    --
    Lv_NuevoEstado VARCHAR2(2) := NULL;
    --
  BEGIN
    IF Pv_TipoArticulo = 'AF' THEN

      IF C_ACTIVO_FIJO_INSTALAR%ISOPEN THEN CLOSE C_ACTIVO_FIJO_INSTALAR; END IF;
      OPEN C_ACTIVO_FIJO_INSTALAR;
      FETCH C_ACTIVO_FIJO_INSTALAR INTO Lr_ActivoFijo;
      IF C_ACTIVO_FIJO_INSTALAR%NOTFOUND THEN
        Pv_MensajeError := 'Equipo con serie ' || Pv_NumeroSerie||' no se encuentra PENDIENTE INSTALAR, favor verifique!!!';
        RAISE Le_Error;
      END IF;
      CLOSE C_ACTIVO_FIJO_INSTALAR;

      IF Pn_Cantidad > Lr_ActivoFijo.Saldo THEN
        Pv_MensajeError := 'Articulo '||Lr_ActivoFijo.Descripcion||' '||Lr_ActivoFijo.Modelo||' con serie ' || Pv_NumeroSerie||' no cuenta con Stock suficiente en repositorio, favor revisar!!!';
        RAISE Le_Error;
      END IF;

      -- Actualiza el saldo en repositorio
      UPDATE IN_ARTICULOS_INSTALACION A
         SET A.SALDO       = A.SALDO - Pn_Cantidad,
             A.ESTADO      = 'IN',
             A.USR_ULT_MOD = USER,
             A.FE_ULT_MOD  = SYSDATE
       WHERE A.NUMERO_SERIE = Pv_NumeroSerie
         AND A.TIPO_ARTICULO = Pv_TipoArticulo
         AND A.ESTADO = 'PI';--IN ('PI','RE');

      IF SQL%ROWCOUNT = 0 THEN
        Pv_MensajeError := 'No se actualizo registro para articulo '||Lr_ActivoFijo.Descripcion||' '||Lr_ActivoFijo.Modelo||' con serie ' || Pv_NumeroSerie;
        RAISE Le_Error;
      END IF;

    ELSIF Pv_TipoArticulo = 'MT' THEN
      -- control de saldo
      Ln_SaldoDescontado := Pn_Cantidad;
      -- ciclo para rebajar todos los registros de materiales
      FOR Lr_Material IN C_MATERIAL_INSTALAR LOOP
        IF Ln_SaldoDescontado > Lr_Material.Saldo THEN -- cubre el total de la instalacion
          UPDATE IN_ARTICULOS_INSTALACION A
             SET A.SALDO       = A.SALDO - Lr_Material.Saldo,
                 A.ESTADO      = 'IN',
                 A.USR_ULT_MOD = USER,
                 A.FE_ULT_MOD  = SYSDATE
           WHERE A.SECUENCIA = Lr_Material.Secuencia
             AND A.ID_INSTALACION = Lr_Material.Id_Instalacion
             AND A.ESTADO = 'PI';--IN ('PI','RE');

          IF SQL%ROWCOUNT = 1 THEN
            Ln_SaldoDescontado := Ln_SaldoDescontado - Lr_Material.Saldo;
          END IF;

        ELSIF Ln_SaldoDescontado <= Lr_Material.Saldo AND Ln_SaldoDescontado > 0 THEN -- cubre el total de la instalacion
          IF Ln_SaldoDescontado = Lr_Material.Saldo THEN
            Lv_NuevoEstado := 'IN';
          ELSE
            Lv_NuevoEstado := 'PI';
          END IF;

          UPDATE IN_ARTICULOS_INSTALACION A
             SET A.SALDO       = A.SALDO - Ln_SaldoDescontado,
                 A.ESTADO      = Lv_NuevoEstado,
                 A.USR_ULT_MOD = USER,
                 A.FE_ULT_MOD  = SYSDATE
           WHERE A.SECUENCIA = Lr_Material.Secuencia
             AND A.ID_INSTALACION = Lr_Material.Id_Instalacion
             AND A.ESTADO = 'PI';

          IF SQL%ROWCOUNT = 1 THEN
            Ln_SaldoDescontado := 0;
          END IF;   -- fin actualiza registro
        END IF;   -- fin valuda saldo disponible
      END LOOP; -- fin lazo materiales

      IF Ln_SaldoDescontado = Pn_Cantidad then -- no encontro documentos para rebajar cantidades
        Pv_MensajeError := 'Articulo '||Pv_NumeroSerie||' no existe en repositorio, ya fue usado o no se encuentra asignado al empleado, favor revisar!!!';
        RAISE Le_Error;

      ELSIF Ln_SaldoDescontado > 0 THEN -- no completa la cantidad a instalar
        Pv_MensajeError := 'Articulo '||Pv_NumeroSerie||' no cuenta con Stock suficiente en repositorio, favor revisar!!!';
        RAISE Le_Error;

      END IF;
    ELSE
      Pv_MensajeError := 'No se ha definido tipo de articulo: '||Pv_TipoArticulo;
      RAISE Le_Error;
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en IN_P_PROCESA_INSTALACION. ' || SQLERRM;
      ROLLBACK;
  END IN_P_PROCESA_INSTALACION;

  ------------------------------------------------------
  -- Procedimiento que realiza el retiro de Articulos --
  ------------------------------------------------------
  PROCEDURE IN_P_RETIRA_INSTALACION( Pv_NoCia        IN VARCHAR2,
                                     Pv_IdArticulo   IN VARCHAR2,
                                     Pv_TipoArticulo IN VARCHAR2,
                                     Pv_NumeroCedula IN VARCHAR2,
                                     Pv_NumeroSerie  IN VARCHAR2,
                                     Pn_Cantidad     IN NUMBER,
                                     Pv_Estado  IN VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2,
                                     Pb_Rollback IN BOOLEAN DEFAULT TRUE) IS
    --
    CURSOR C_ACTIVO_FIJO_RETIRAR IS
      SELECT A.ID_COMPANIA, A.ID_INSTALACION, A.SECUENCIA, A.SALDO
        FROM IN_ARTICULOS_INSTALACION A
       WHERE A.NUMERO_SERIE = Pv_NumeroSerie
         AND A.TIPO_ARTICULO = Pv_TipoArticulo
         AND A.ESTADO = 'IN';--IN ('IN','PR');
    --
    CURSOR C_EMPLEADO IS
      SELECT A.NO_EMPLE
        FROM ARPLME A
       WHERE A.CEDULA = Pv_NumeroCedula
         --AND A.NO_CIA = Pv_NoCia
         AND A.ESTADO = 'A'
         ;
    --
    Le_Error           EXCEPTION;
    Lr_ActivoFijo      C_ACTIVO_FIJO_RETIRAR%ROWTYPE := NULL;
    Lv_IdEmpleado      ARPLME.NO_EMPLE%TYPE := NULL;
    --
  BEGIN
    IF Pv_TipoArticulo = 'AF' THEN
      -- verifica articulo en repositorio
      IF C_ACTIVO_FIJO_RETIRAR%ISOPEN THEN CLOSE C_ACTIVO_FIJO_RETIRAR; END IF;
      OPEN C_ACTIVO_FIJO_RETIRAR;
      FETCH C_ACTIVO_FIJO_RETIRAR INTO Lr_ActivoFijo;
      IF C_ACTIVO_FIJO_RETIRAR%NOTFOUND THEN
        Pv_MensajeError := 'Equipo con serie ' || Pv_NumeroSerie||' no se encuentra INSTALADO, favor verifique!!!';
        RAISE Le_Error;
      END IF;
      CLOSE C_ACTIVO_FIJO_RETIRAR;

      -- verifica el tecnico que lo va a retirar
      IF C_EMPLEADO%ISOPEN THEN CLOSE C_EMPLEADO; END IF;
      OPEN C_EMPLEADO;
      FETCH C_EMPLEADO INTO Lv_IdEmpleado;
      IF C_EMPLEADO%NOTFOUND THEN
        Pv_MensajeError := 'Empleado que retira equipo no existe: '||Pv_NumeroCedula;
        RAISE Le_Error;
      END IF;
      CLOSE C_EMPLEADO;

      IF Lr_ActivoFijo.Saldo != 0 THEN
        Pv_MensajeError := 'Articulo '||Pv_IdArticulo||' con serie ' || Pv_NumeroSerie||' posee Stock en repositorio, favor revisar!!!';
        RAISE Le_Error;
      END IF;

      -- Actualiza el saldo en repositorio
      UPDATE IN_ARTICULOS_INSTALACION A
         SET A.SALDO       = A.SALDO + Pn_Cantidad,-- si estado es NE no importa el saldo que quede
             A.ESTADO      = Pv_Estado,
             A.ID_CUSTODIO = Lv_IdEmpleado,
             A.CEDULA      = Pv_NumeroCedula,
             A.USR_ULT_MOD = USER,
             A.FE_ULT_MOD  = SYSDATE
       WHERE A.NUMERO_SERIE = Pv_NumeroSerie
         AND A.TIPO_ARTICULO = Pv_TipoArticulo
         AND A.ESTADO = 'IN';--IN ('IN','PR');

      IF SQL%ROWCOUNT = 0 THEN
        Pv_MensajeError := 'No se actualizo registro para articulo '||Pv_IdArticulo||' con serie ' || Pv_NumeroSerie;
        RAISE Le_Error;
      END IF;

    ELSIF Pv_TipoArticulo = 'MT' THEN
      Pv_MensajeError := 'Para materiales no es posible realizar retiros: '||Pv_TipoArticulo;
      RAISE Le_Error;
    ELSE
      Pv_MensajeError := 'No se ha definido tipo de articulo: '||Pv_TipoArticulo;
      RAISE Le_Error;
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      IF Pb_Rollback THEN
        ROLLBACK;
      END IF;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en IN_P_RETIRA_INSTALACION. ' || SQLERRM;
      IF Pb_Rollback THEN
        ROLLBACK;
      END IF;
  END IN_P_RETIRA_INSTALACION;

  -------------------------------------------
  -- FUNCION QUE REALIZA EL CALCULO DE MAC --
  -------------------------------------------
  FUNCTION IN_F_CALCULA_MAC ( Pv_MAC      IN VARCHAR2,
                              Pv_Calcular IN VARCHAR2) RETURN VARCHAR2 IS

    Lv_MacHEX     IN_ARTICULOS_INSTALACION.MAC%TYPE := REPLACE(Pv_MAC,'.','');
    Ln_anchoMAC   NUMBER(3) := LENGTH(Lv_MacHEX);
    Lv_formatoHEX VARCHAR2(30) := NULL;
    Lv_auxMac     IN_ARTICULOS_INSTALACION.MAC%TYPE := null;

  BEGIN
    IF Pv_MAC IS NULL THEN
      RETURN NULL;
    END IF;

    IF Pv_Calcular = 'S' THEN
      -- se determina formato Hexadecimal, los 4 primeros digitos va con CERO
      FOR I IN 1..Ln_anchoMAC LOOP
        IF I <= 4 THEN
          Lv_formatoHEX := Lv_formatoHEX||'0';
        ELSE
          Lv_formatoHEX := Lv_formatoHEX||'X';
        END IF;
      END LOOP;

      -- formla que suma 1 entero a numero HEXA
      Lv_auxMac := TRIM(to_char(to_number(replace(Lv_MacHEX,'.',''), Lv_formatoHEX)+1,Lv_formatoHEX));
    ELSE
      Lv_auxMac := TRIM(Lv_MacHEX);
    END IF;

    Lv_MacHEX := NULL;
    -- SE FORMATEA MAC: ABCD.EF12.3456
    FOR I IN 1..LENGTH(Lv_auxMac) LOOP
      Lv_MacHEX := Lv_MacHEX||SUBSTR(Lv_auxMac, I, 1);
      IF I < LENGTH(Lv_auxMac) AND MOD(I,4) = 0 THEN
        Lv_MacHEX := Lv_MacHEX||'.';
      END IF;
    END LOOP;

    -- se retorna mac calculada
    Return Lv_MacHEX;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('ERROR. '||SQLERRM);
      RETURN NULL;
  END IN_F_CALCULA_MAC;
    --

  -----------------------------------------------------------------
  -- Instalaciones de Articulos en base a solicitudes de pedidos --
  -----------------------------------------------------------------
  PROCEDURE IN_ART_INSTALACION_SOLICITUD (Pv_IdDespacho   IN VARCHAR2,
                                          --Pv_IdCentro     IN VARCHAR2,
                                          Pv_IdCompania   IN VARCHAR2,
                                          Pv_MensajeError IN OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    --
    P_REPOSITORIO_ARTICULOS ( Pv_IdDespacho, Pv_IdCompania, 'IN', Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'IN_ART_INSTALACION_SOLICITUD :' || SQLERRM;
      ROLLBACK;
  END IN_ART_INSTALACION_SOLICITUD;

  ----------------------------------------------------------------------------------------------------
  -- Procedimiento que libera equipos en telcos y naf mediante solicitud de retiro o inconsistencia --
  ----------------------------------------------------------------------------------------------------
  PROCEDURE IN_P_LIBERA_EQUIPO( Pv_NumeroSerie  IN VARCHAR2,
                                Pn_IdElemento   IN NUMBER,
                                Pn_IdServicio   IN VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2) IS
    cursor c_solicitudes is
      select a.id_detalle_solicitud
        from v_solicitudes_retiros a
       where a.elemento_id = Pn_IdElemento
         and a.servicio_id = Pn_IdServicio;
    --
    Le_Error      exception;
    --
  BEGIN

    -- si se recibe elemento
    if Pn_IdElemento is not null then
      -- si se recibe servicio
      if Pn_IdServicio is not null then
       -- se procede a cancelar servicio
/*        update db_comercial.info_servicio a
           set a.estado = 'Cancel'
         where a.id_servicio = Pn_IdServicio
           and a.estado = 'Activo';*/

        -- se finaliza solicitud de retiro
        for s in c_solicitudes loop
          -- se finalizan las caracteristicas de la solicitud de retiro
          update db_comercial.info_detalle_sol_caract a
             set a.estado = 'Finalizado'
           where a.detalle_solicitud_id = s.id_detalle_solicitud;

          -- se finaliza solicitud de retiro
          update db_comercial.info_detalle_solicitud a
             set a.estado = 'Finalizado'
           where a.id_detalle_solicitud = s.id_detalle_solicitud;
        end loop;
      end if;

      -- se procede a cancelar elemento
      update db_infraestructura.info_elemento a
         set a.estado = 'Retirado'
       where a.id_elemento = Pn_IdElemento
         and a.estado = 'Activo';
    end if;

    -- si recibe serie se libera repositorio, solo si no queda algun elemento y servicio activo
    if Pv_NumeroSerie is not null then
      update in_articulos_instalacion a
         set a.estado = 'RE',
             a.saldo = a.cantidad,
             a.usr_ult_mod = user,
             a.fe_ult_mod = sysdate
       where a.numero_serie = Pv_NumeroSerie
         and a.estado in ('IN','PI')
         and not exists (select null
                           from v_equipos_telcos b
                          where b.numero_serie = a.numero_serie
                            and b.estado_elemento = 'Activo'
                            and b.estado_servicio = 'Activo');
    end if;
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en AFK_PROCESOS.IN_P_LIBERA_EQUIPO. ' || Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en AFK_PROCESOS.IN_P_LIBERA_EQUIPO. ' || SQLERRM;
      ROLLBACK;
  END;

  ---------------------------------------------------------------------------------------------
  -- Procedimiento que genera por tipo de Activo asiento de regualrizacion de cuenta puente  --
  ---------------------------------------------------------------------------------------------
  PROCEDURE P_GENERA_ASIENTO_REGULARIZA (Pv_cia   IN varchar2,
                                         Pn_ano   IN NUMBER,
                                         Pn_mes   IN number,
                                         Pd_fecha IN date,
                                         Pv_CodigoDiario IN varchar2,
                                         Pn_TipoCambio   IN number,
                                         Pv_TcambCV      IN varchar2,
                                         Pn_NumAsiento   IN arcgae.no_asiento%type,
                                         Pv_Error        IN OUT varchar2 ) IS

    CURSOR C_DatosCia IS
      SELECT ((mc.ano_proce*100)+mc.mes_proce), ((af.ano*100)+af.mes)
      FROM arcgmc mc, arafmc af
      WHERE mc.no_cia = Pv_cia
      AND af.no_cia  = mc.no_cia;

    Cursor C_TiposActivos is
      Select no_cia, tipo, descri, ctagavo
      from arafmt
      where no_cia=Pv_cia
      and ind_ctagavo_puente = 'S';

    Cursor C_Porcentaje (Cv_tipo varchar2) is
      Select sum(NVL(cp.porcentaje,0))
      from araf_regula_cta_puente cp
      where no_cia=Pv_cia
      and tipo=Cv_tipo;

    Cursor C_MontoTotalTipo (Cv_tipo varchar2) is
     Select nvl(Sum(hd.dep_valorig),0) depreciado
      From arafma ma, arafhd hd
      Where to_char(ma.f_ingre,'yyyymm') <= to_char(Pd_fecha,'YYYYMM')
      and ma.no_cia  = Pv_cia
      and ma.tipo = Cv_tipo
      and ma.f_egre is null
      and ma.fecha_fin_vida_util is null
      and hd.no_cia  = ma.no_cia
      and hd.no_acti = ma.no_acti
      and nvl(tipo_dep,'N')   = 'N'
      and nvl(hd.dep_valorig,0) > 0
      and ano = Pn_ano
      and mes = Pn_mes;

    Cursor C_CuentasPorcentajes (Cv_tipo varchar2) is
      Select cuenta, centro_costo, porcentaje
      from araf_regula_cta_puente cp
      where no_cia=Pv_cia
      and tipo=Cv_tipo
      order by porcentaje;

    Cursor C_MontoPorPorcentaje (Cn_monto number, Cn_porcentaje number) is
      Select round(((Cn_monto * Cn_porcentaje)/100), 2) MontoCuenta from dual;

    Ln_porcentaje          number :=0;
    Ln_gasto               number :=0;
    Ln_ProcesoContabilidad number;
    Ln_ProcesoActivoFijo   number;
    Lv_Asiento      arcgae.no_asiento%type;
    Lv_Estado       arcgae.estado%type;
    Lv_Autoriza     arcgae.autorizado%type;
    Lv_TipoCambio   arafma.tipo_cambio%type;
    Ln_linea        arcgal.no_linea%type;
    Ln_monto        arcgal.monto%type;
    Le_Error        EXCEPTION;

  Begin
    --
    IF C_TiposActivos%ISOPEN THEN CLOSE C_TiposActivos; END IF;
    For Lc_tipo in C_TiposActivos Loop
      -- Verifico que tiene asociado un 100%
      IF C_Porcentaje%ISOPEN THEN CLOSE C_Porcentaje; END IF;
      Open C_Porcentaje(Lc_tipo.Tipo);
      Fetch C_Porcentaje into Ln_porcentaje;
      Close C_Porcentaje;

      IF nvl(Ln_porcentaje,0) <> 100 THEN
        Pv_Error := 'La suma de los porcentajes no llega a 100%. Favor de revisar el Tipo de Activo: '||Lc_tipo.Tipo;
        RAISE Le_Error;
      END IF;

      -- Obtengo el monto que se deprecio y acumulo en la cuenta puente
      IF C_MontoTotalTipo%ISOPEN THEN CLOSE C_MontoTotalTipo; END IF;
      Open  C_MontoTotalTipo(Lc_tipo.Tipo);
      Fetch C_MontoTotalTipo into Ln_gasto;
      Close C_MontoTotalTipo;

      IF Ln_gasto > 0 THEN  -- Si existe depreciaciones para el tipo

        -- Obtiene datos de la compania
        IF C_DatosCia%ISOPEN THEN CLOSE C_DatosCia; END IF;
        OPEN  C_DatosCia;
        FETCH C_DatosCia INTO Ln_ProcesoContabilidad, Ln_ProcesoActivoFijo;
        CLOSE C_DatosCia;

        IF (Ln_ProcesoContabilidad <= Ln_ProcesoActivoFijo) THEN
          Lv_Estado   := 'P';
          Lv_Autoriza := 'N';
        ELSE
          Lv_Estado   := 'O';
          Lv_Autoriza := 'S';
        END IF;

        Lv_Asiento := transa_id.cg(Pv_cia);
        --Pn_NumAsiento := Lv_Asiento;
        Ln_linea   := 1; --nvl(Ln_linea,0) + 1;
        -- ------------------------------------------------
        -- Genera el movimiento en contabilidad
        -- ------------------------------------------------
        insert into arcgae(no_cia,
                           ano,
                           mes,
                           no_asiento,
                           fecha,
                           estado,
                           autorizado,
                           COD_DIARIO,
                           t_camb_c_v,
                           origen,
                           tipo_comprobante,
                           no_comprobante,
                           anulado,
                           descri1,
                           t_debitos,
                           t_creditos)
                    values(Pv_cia,
                           Pn_ano,
                           Pn_mes,
                           Lv_Asiento,
                           Pd_fecha,
                           Lv_Estado,
                           Lv_autoriza,
                           Pv_CodigoDiario,
                           Pv_TcambCV,
                           'AF',
                           'T',
                           0,
                           'N',
                           SUBSTR('REGULARIZACION DE ASIENTO DE DEPRECIACION No. '||Pn_NumAsiento||' '||Pn_mes||'/'||Pn_ano
                           ||'  TIPO DE ACTIVO: '||Lc_tipo.tipo||' - '||Lc_tipo.descri,1,240),
                           Ln_gasto,
                           Ln_gasto);

        -- Se da de baja la cuenta puente enviandola al Credito
        Insert into arcgal(no_cia,
                           ano,
                           mes,
                           no_asiento,
                           no_linea,
                           cuenta,
                           tipo,
                           cod_diario,
                           tipo_cambio,
                           moneda,
                           centro_costo,
                           monto,
                           monto_dol,
                           descri)
                    values(Pv_cia,
                           Pn_ano,
                           Pn_mes,
                           Lv_Asiento,
                           Ln_Linea,
                           Lc_Tipo.ctagavo,
                           'C',
                           Pv_CodigoDiario,
                           Pn_TipoCambio, --Lv_TipoCambio,
                           'P',
                           '000000000', -- Como no es una cuenta de Gasto se asume centro '000000000'
                           Ln_gasto * -1,
                           Ln_gasto * -1,
                           SUBSTR('REGULARIZACION DE ASIENTO DE DEPRECIACION ANIO/MES '|| Pn_ano||'/'||Pn_mes,1,100) );

        -- Las dem¿¿s cuentas deben de ir al Debito
        IF C_CuentasPorcentajes%ISOPEN THEN CLOSE C_CuentasPorcentajes; END IF;
        For Lc_CuentasPorcentajes in C_CuentasPorcentajes(Lc_tipo.Tipo) Loop  -- cuenta, centro_costo, porcentaje
          Lv_TipoCambio := moneda.redondeo(Pn_TipoCambio,'P');

          Ln_monto :=0;
          Open  C_MontoPorPorcentaje(Ln_gasto, Lc_CuentasPorcentajes.porcentaje);
          Fetch C_MontoPorPorcentaje into Ln_monto;
          Close C_MontoPorPorcentaje;
          Ln_linea   := nvl(Ln_linea,0) + 1;

          insert into arcgal(no_cia,
                             ano,
                             mes,
                             no_asiento,
                             no_linea,
                             cuenta,
                             tipo,
                             cod_diario,
                             tipo_cambio,
                             moneda,
                             centro_costo,
                             monto,
                             monto_dol,
                             descri)
                      values(Pv_cia,
                             Pn_ano,
                             Pn_mes,
                             Lv_Asiento,
                             Ln_Linea,
                             Lc_CuentasPorcentajes.cuenta,
                             'D',
                             Pv_CodigoDiario,
                             Pn_TipoCambio, -- Lv_TipoCambio,
                             'P',
                             Lc_CuentasPorcentajes.centro_costo,
                             Ln_monto,
                             Ln_monto,
                             SUBSTR('REGULARIZACION DE ASIENTO DE DEPRECIACION ANIO/MES '|| Pn_ano||'/'||Pn_mes
                             ||' PORCENTAJE APLICADO '||Lc_CuentasPorcentajes.porcentaje||'%' ,1,100) );
        End Loop;
        End If;
    End Loop;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Error := 'Error en P_GENERA_ASIENTO_REGULARIZA. ' || SQLERRM;
      ROLLBACK;
  End; -- P_GENERA_ASIENTO_REGULARIZA

  ---------------------------------------------------------------------------
  -- Procedimiento que genera asiento contable por depreciacion realizada  --
  ---------------------------------------------------------------------------
  Procedure P_GENERA_ASIENTO_DEPRECIACION (Pv_cia   IN varchar2,
                                           Pn_ano   IN number,
                                           Pn_mes   IN number,
                                           Pd_fecha IN date,
                                           Pv_CodigoDiario IN varchar2,
                                           Pn_TipoCambio   IN number,
                                           Pv_TcambCV      IN varchar2,
                                           Pn_NumAsiento   IN OUT arcgae.no_asiento%type,
                                           Pv_Error        IN OUT varchar2 ) IS

  CURSOR C_DatosCia IS
    SELECT ((mc.ano_proce*100)+mc.mes_proce), ((af.ano*100)+af.mes)
    FROM arcgmc mc, arafmc af
    WHERE mc.no_cia = Pv_cia
    AND af.no_cia  = mc.no_cia;

  Cursor C_ActivosDepreciados is
    Select ma.no_acti,        ma.ctagavo,                   ma.ctadavo,
      ma.ctagare,             ma.ctadare,                   ma.ctavo,
      ma.ctare,               ma.centro_costo cc,           ma.no_cia,
      ma.tipo,                hd.depacum_valorig,           hd.depacum_mejoras,
      hd.depacum_revtecs,     hd.depacum_valorig_dol,       hd.depacum_mejoras_dol,
      hd.depacum_revtecs_dol, hd.dep_valorig,               hd.dep_valorig_dol,
      hd.dep_revtecs,         hd.dep_revtecs_dol,           hd.dep_mejoras,
      hd.dep_mejoras_dol
    From arafma ma, arafhd hd
    Where to_char(ma.f_ingre,'yyyymm') <= to_char(Pd_fecha,'YYYYMM')
    and ma.no_cia  = Pv_cia
    and ma.f_egre is null
    and ma.fecha_fin_vida_util is null
    and hd.no_cia  = ma.no_cia
    and hd.no_acti = ma.no_acti
    and nvl(tipo_dep,'N')   = 'N'
    and nvl(hd.dep_valorig,0) > 0
    and ano = Pn_ano
    and mes = Pn_mes;

  Cursor C_CuentasContables is
    Select debitos, creditos,
      debitos_dol, creditos_dol,
      cuenta, cent_cost
    From arafau
    Where no_cia = Pv_cia;

  Ln_ProcesoContabilidad number;
  Ln_ProcesoActivoFijo   number;
  Ln_Registros           number;
  Lv_Asiento      arcgae.no_asiento%type;
  Ln_TotDebe      arcgae.t_debitos%type  := 0;
  Ln_TotHaber     arcgae.t_creditos%type := 0;
  Lv_centro       arcgceco.centro%type;
  Lv_Estado       arcgae.estado%type;
  Lv_Autoriza     arcgae.autorizado%type;
  Lv_centro_costo arcgal.centro_costo%type;
  Lv_TipoCambio   arafma.tipo_cambio%type;
  Ln_linea        arcgal.no_linea%type;

  BEGIN
    --Borra los asientos contables generados por el proceso en periodos anteriores
    Delete from arafau
    Where no_cia = Pv_cia;

    Lv_Asiento := transa_id.cg(Pv_cia);
    Pn_NumAsiento := Lv_Asiento;

    -- Obtiene datos de la compania
    IF C_DatosCia%ISOPEN THEN CLOSE C_DatosCia; END IF;
    OPEN  C_DatosCia;
    FETCH C_DatosCia INTO Ln_ProcesoContabilidad, Ln_ProcesoActivoFijo;
    CLOSE C_DatosCia;

    IF (Ln_ProcesoContabilidad <= Ln_ProcesoActivoFijo) THEN
      Lv_Estado := 'P';
      Lv_Autoriza := 'N';
    ELSE
      Lv_Estado := 'O';
      Lv_Autoriza := 'S';
    END IF;
    --
    IF C_ActivosDepreciados%ISOPEN THEN CLOSE C_ActivosDepreciados; END IF;
    FOR Lc_Activo IN C_ActivosDepreciados LOOP
      -- Actualizamos la fecha de depreciacion de activos.
      update arafma
      set f_depre = to_date('01'||to_char(Pn_mes,'00')||to_char(Pn_ano),'DDMMYYYY')
      where no_cia = Pv_cia
      and no_acti = Lc_Activo.no_acti;

      -- ------------------------------------------------------------
      -- Generamos un debito por GASTO de depreciacion VALOR ORIGINAL
      -- ------------------------------------------------------------
      If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctagavo) then
        Lv_centro := Lc_Activo.cc;
      else
        Lv_centro := '000000000';
      end if;
      P_INSERTA_LINEA_AUXILIAR(Pv_cia,
                               Lc_Activo.ctagavo,
                               Lc_Activo.dep_valorig,
                               Lc_Activo.dep_valorig_dol,
                               Lv_centro,
                               'D');

      -- --------------------------------------------------------------
      -- Generamos un credito por DEPRECIACION acumulada VALOR ORIGINAL
      -- --------------------------------------------------------------
      If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctadavo) then
        Lv_centro := Lc_Activo.cc;
      else
        Lv_centro := '000000000';
      end if;
      P_INSERTA_LINEA_AUXILIAR(Pv_cia,
                               Lc_Activo.ctadavo,
                               Lc_Activo.dep_valorig,
                               Lc_Activo.dep_valorig_dol,
                               Lv_centro,
                               'C');

      -- ------------------------------------------------------------
      -- Generamos un debito por GASTO de depreciacion REVALUACIONES
      -- ------------------------------------------------------------
      If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctagare) then
        Lv_centro := Lc_Activo.cc;
      else
        Lv_centro := '000000000';
      end if;
      P_INSERTA_LINEA_AUXILIAR(Pv_cia,
                               Lc_Activo.ctagare,
                               Lc_Activo.dep_revtecs,
                               Lc_Activo.dep_revtecs_dol,
                               Lv_centro,
                               'D');

      -- --------------------------------------------------------------
      -- Generamos un credito por DEPRECIACION acumulada REVALUACIONES
      -- --------------------------------------------------------------
      If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctadare) then
        Lv_centro := Lc_Activo.cc;
      else
        Lv_centro := '000000000';
      end if;
      P_INSERTA_LINEA_AUXILIAR(Pv_cia,
                               Lc_Activo.ctadare,
                               Lc_Activo.dep_revtecs,
                               Lc_Activo.dep_revtecs_dol,
                               Lv_centro,
                               'C');

      -- ------------------------------------------------------------
      -- Generamos un debito por GASTO de depreciacion MEJORAS
      -- ------------------------------------------------------------
      If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctagavo) then
        Lv_centro := Lc_Activo.cc;
      else
        Lv_centro := '000000000';
      end if;
      P_INSERTA_LINEA_AUXILIAR(Pv_cia,
                               Lc_Activo.ctagavo,
                               Lc_Activo.dep_mejoras,
                               Lc_Activo.dep_mejoras_dol,
                               Lv_centro,
                               'D');

      -- --------------------------------------------------------------
      -- Generamos un credito por DEPRECIACION acumulada MEJORAS
      -- --------------------------------------------------------------
      If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctadavo) then
        Lv_centro := Lc_Activo.cc;
      else
        Lv_centro := '000000000';
      end if;
      P_INSERTA_LINEA_AUXILIAR(Pv_cia,
                               Lc_Activo.ctadavo,
                               Lc_Activo.dep_mejoras,
                               Lc_Activo.dep_mejoras_dol,
                               Lv_centro,
                               'C');

      Ln_Registros := Ln_Registros + 1;
    End loop;  -- C_ActivosDepreciados

    -----------------------------------------------------
    If Ln_Registros = 0 then
      update arafmc
      set ind_calculo_dep = 'S'
      where no_cia = Pv_cia;

      Pv_Error := '<ATENCION> No se genero ningun Asiento';
    else
      -- ------------------------------------------------
      -- Genera el movimiento en contabilidad
      -- ------------------------------------------------
      insert into arcgae(no_cia,
                         ano,
                         mes,
                         no_asiento,
                         fecha,
                         estado,
                         autorizado,
                         COD_DIARIO,
                         t_camb_c_v,
                         origen,
                         tipo_comprobante,
                         no_comprobante,
                         anulado,
                         descri1)
                  values(Pv_cia,
                         Pn_ano,
                         Pn_mes,
                         Lv_Asiento,
                         Pd_fecha,
                         Lv_Estado,
                         Lv_autoriza,
                         Pv_CodigoDiario,
                         Pv_TcambCV,
                         'AD',
                         'T',
                         0,
                         'N',
                         'DEPRECIACION MENSUAL DE ACTIVO FIJOS '||Pn_mes||'/'||Pn_ano);

      IF C_CuentasContables%ISOPEN THEN CLOSE C_CuentasContables; END IF;
      FOR Lc_Cuentas IN C_CuentasContables LOOP -- j IN C_CuentasContables LOOP
        Lv_centro_costo := centro_costo.rellenad(Pv_cia,'0');

        IF nvl(Lc_Cuentas.debitos,0) > nvl(Lc_Cuentas.creditos,0) THEN

          IF nvl(Lc_Cuentas.debitos_dol,0) != 0 OR nvl(Lc_Cuentas.creditos_dol,0) != 0 THEN
            Lv_TipoCambio := moneda.redondeo((nvl(Lc_Cuentas.debitos,0)-nvl(Lc_Cuentas.creditos,0))/
                             (nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0)),'P');
          ELSE
            Lv_TipoCambio := moneda.redondeo(Pn_TipoCambio,'P');
          END IF;

          Ln_linea   := nvl(Ln_linea,0) + 1;
          insert into arcgal(no_cia,
                             ano,
                             mes,
                             no_asiento,
                             no_linea,
                             cuenta,
                             tipo,
                             cod_diario,
                             tipo_cambio,
                             moneda,
                             centro_costo,
                             monto,
                             monto_dol,
                             descri)
                      values(Pv_cia,
                             Pn_ano,
                             Pn_mes,
                             Lv_Asiento,
                             Ln_Linea,
                             Lc_Cuentas.cuenta,
                             'D',
                             Pv_CodigoDiario,
                             Lv_TipoCambio,
                             'P',
                             nvl(Lc_Cuentas.cent_cost,    Lv_centro_costo),
                             nvl(Lc_Cuentas.debitos,0)    -nvl(Lc_Cuentas.creditos,0),
                             nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0),
                             'DEPREC.MENSUAL DE ACTIVOS FIJOS '||Pn_mes||'/'||Pn_ano );

          Ln_TotDebe := moneda.redondeo(nvl(Ln_TotDebe,0)+(nvl(Lc_Cuentas.debitos,0)-nvl(Lc_Cuentas.creditos,0)),'P');


        ELSIF nvl(Lc_Cuentas.creditos,0) > nvl(Lc_Cuentas.debitos,0) THEN

          IF nvl(Lc_Cuentas.debitos_dol,0) != 0 OR nvl(Lc_Cuentas.creditos_dol,0) != 0 THEN
            Lv_TipoCambio := moneda.redondeo((nvl(Lc_Cuentas.debitos,0)    -nvl(Lc_Cuentas.creditos,0))/
                            (nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0)),'P');
          ELSE
            Lv_TipoCambio := moneda.redondeo(Pn_TipoCambio,'P');
          END IF;

          Ln_Linea    := nvl(Ln_Linea,0)+1;
          insert into arcgal(no_cia,
                             ano,
                             mes,
                             no_asiento,
                             no_linea,
                             cuenta,
                             tipo,
                             cod_diario,
                             tipo_cambio,
                             moneda,
                             centro_costo,
                             monto,
                             monto_dol,
                             descri)
                      values(Pv_cia,
                             Pn_ano,
                             Pn_mes,
                             Lv_Asiento,
                             Ln_Linea,
                             Lc_Cuentas.cuenta,
                             'C',
                             Pv_CodigoDiario,
                             Lv_TipoCambio, 'P',
                             nvl(Lc_Cuentas.cent_cost, Lv_centro_costo),
                             nvl(Lc_Cuentas.debitos,0)    -nvl(Lc_Cuentas.creditos,0),
                             nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0),
                             'DEPREC.MENSUAL DE A.FIJOS '||Pn_mes||'/'||Pn_ano );

          Ln_TotHaber := moneda.redondeo(nvl(Ln_TotHaber,0)+(nvl(Lc_Cuentas.creditos,0)-nvl(Lc_Cuentas.debitos,0)),'P');

        end if;
      End loop; -- C_CuentasContables
      -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
      -- Actualiza los totales en el encabezado del asiento
      -- y indicador del calculo de depreciacion
      -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
      update arcgae
      set t_debitos  = Ln_TotDebe,
        t_creditos = Ln_TotHaber
      where no_cia     = Pv_cia
      and ano        = Pn_ano
      and mes        = Pn_mes
      and no_asiento = Lv_Asiento;

      update arafmc
      set ind_calculo_dep = 'S',
        ind_depre_generada = 'N'
      where no_cia = Pv_cia;
    End if;
  End;

  ----------------------------------------------------------------------------------
  -- Procedimiento que genera linea auxiliar por monto de depreciacion realizada  --
  ----------------------------------------------------------------------------------
  Procedure P_INSERTA_LINEA_AUXILIAR (Pv_cia         IN arafau.no_cia%type,
                                      Pv_Cuenta      IN arafau.cuenta%type,
                                      Pn_Monto       IN arafau.debitos%type,
                                      Pn_MontoDol    IN arafau.debitos_dol%type,
                                      Pv_CentroCosto IN arafau.cent_cost%type,
                                      Pv_Tipo        IN arcgal.tipo%type  ) is

    Ln_Monto      arafau.debitos%type;
    Ln_MontoDol   arafau.debitos_dol%type;

  Begin
    Ln_Monto     := moneda.redondeo(Pn_Monto,'P');
    Ln_MontoDol  := moneda.redondeo(Pn_MontoDol,'D');

    If nvl(Pn_Monto,0) > 0 then
      If Pv_Tipo = 'D' then  -- Generamos un debito por gasto de depreciacion

        update arafau
        set debitos     = nvl(debitos,0) + Ln_Monto,
          debitos_dol   = nvl(debitos_dol,0) + Ln_MontoDol
        where no_cia = Pv_cia    and
          cuenta     = Pv_Cuenta    and
          cent_cost  = Pv_CentroCosto;

        if sql%rowcount = 0 then
          insert into arafau(no_cia,
                             cuenta,
                             debitos,
                             creditos,
                             debitos_dol,
                             creditos_dol,
                             cent_cost)
                      values(Pv_cia,
                             Pv_Cuenta,
                             round(Ln_Monto,2),
                             0,
                             round(Ln_MontoDol,2),
                             0,
                             Pv_CentroCosto);
        end if;

      else   -- Generamos un credito por depreciacion acumulada valor original
        update arafau
        set creditos    = nvl(creditos,0)     + Ln_Monto,
          creditos_dol  = nvl(creditos_dol,0) + Ln_MontoDol
        where no_cia    = Pv_cia   and
          cuenta    = Pv_Cuenta   and
          cent_cost = Pv_CentroCosto;

        if sql%rowcount = 0 then
          insert into arafau(no_cia,
                             cuenta,
                             debitos,
                             creditos,
                             debitos_dol,
                             creditos_dol,
                             cent_cost)
                      values(Pv_cia,
                             Pv_Cuenta,
                             0,
                             round(Ln_Monto,2),
                             0,
                             round(Ln_MontoDol,2),
                             Pv_CentroCosto);
        end if;
      End if; -- Pv_Tipo
    End if; -- Pn_Monto
  End P_INSERTA_LINEA_AUXILIAR;


  ------------------------------------------------------------
  -- Procedimiento que genera el cierre mensual del modulo  --
  ------------------------------------------------------------
  Procedure P_CIERRE_MENSUAL_ACTIVOS_FIJOS  (Pv_cia   IN varchar2,
                                             Pn_ano   IN number,
                                             Pn_mes   IN number,
                                             Pv_Error IN OUT varchar2 ) IS
/* Costo: 1  */
    CURSOR C_MesCierre IS
      SELECT mes_cierre
      FROM arcgmc
      WHERE no_cia = Pv_cia;

/* Costo: 168  */
    CURSOR C_ActivosDepreciados IS
      SELECT no_acti, val_original, depacum_valorig
      FROM arafma
      WHERE no_cia = Pv_cia
      AND f_egre  is null
      AND fecha_fin_vida_util is null
      AND DEPRECIA > 0;
      --AND (nvl(val_original,0) + nvl(mejoras,0) + nvl(rev_tecs,0) - (nvl(depacum_valorig_ant,0) +
       --   nvl(depacum_mejoras_ant,0)+nvl(depacum_revtecs_ant,0) )) > desecho;

/* Costo: 74  */
  CURSOR C_ActivosParaNoDepreciar IS
   SELECT no_acti
    FROM arafma
    WHERE no_cia = Pv_cia
    AND f_egre is null
    and fecha_fin_vida_util is null
    AND NO_DEPRECIA = 0;
   -- AND (nvl(val_original,0) + nvl(mejoras,0) + nvl(rev_tecs,0) -
   -- (nvl(depacum_valorig,0) + nvl(depacum_mejoras,0)+nvl(depacum_revtecs,0) )) = 0;

     Lv_MesCierre   arcgmc.mes_cierre%TYPE;

  BEGIN
    -- Resetea los valores de la depreciacion en ejercicio al cierre del anio fiscal
    IF C_MesCierre%ISOPEN THEN CLOSE C_MesCierre; END IF;
    OPEN C_MesCierre;
    FETCH C_MesCierre INTO Lv_MesCierre;
    CLOSE C_MesCierre;

    IF Lv_MesCierre = Pn_mes   THEN
      UPDATE arafma
      SET depre_ejer_vo       = 0,
        depre_ejer_mej        = 0,
        depre_ejer_revtec     = 0,

        depre_ejer_vo_ant     = 0,
        depre_ejer_mej_ant    = 0,
        depre_ejer_revtec_ant = 0,

        depre_ejer_vo_dol     = 0,
        depre_ejer_mej_dol    = 0,
        depre_ejer_revtec_dol = 0,

        depre_ejer_vo_ant_dol     = 0,
        depre_ejer_mej_ant_dol    = 0,
        depre_ejer_revtec_ant_dol = 0
      WHERE no_cia = Pv_cia;
    END IF;

    IF C_ActivosDepreciados%ISOPEN THEN CLOSE C_ActivosDepreciados; END IF;
    For Lc_Activo in C_ActivosDepreciados loop
      -- Actualiza las depreciaciones acumuladas
      UPDATE arafma
      SET ult_ano_cierre  = Pn_ano,
        ult_mes_cierre  = Pn_mes,

        depacum_valorig_ant = nvl(depacum_valorig,0),
        depacum_mejoras_ant = nvl(depacum_mejoras,0),
        depacum_revtecs_ant = nvl(depacum_revtecs,0),

        depacum_valorig_ant_dol = nvl(depacum_valorig_dol,0),
        depacum_mejoras_ant_dol = nvl(depacum_mejoras_dol,0),
        depacum_revtecs_ant_dol = nvl(depacum_revtecs_dol,0),

        depre_ejer_vo_ant     = nvl(depre_ejer_vo,0),
        depre_ejer_mej_ant    = nvl(depre_ejer_mej,0),
        depre_ejer_revtec_ant = nvl(depre_ejer_revtec,0),

        depre_ejer_vo_ant_dol     = nvl(depre_ejer_vo_dol,0),
        depre_ejer_mej_ant_dol    = nvl(depre_ejer_mej_dol,0),
        depre_ejer_revtec_ant_dol = nvl(depre_ejer_revtec_dol,0)
      WHERE  no_cia = Pv_cia and no_acti =  Lc_Activo.no_acti;
    END LOOP;

    IF C_ActivosParaNoDepreciar%ISOPEN THEN CLOSE C_ActivosParaNoDepreciar; END IF;
    For Lc_NoDepreciar in C_ActivosParaNoDepreciar loop
      UPDATE arafma
         SET FECHA_FIN_VIDA_UTIL = Last_day(to_date('01'||to_char(Pn_mes,'00')||to_char(Pn_ano),'DDMMYYYY'))
       WHERE no_cia = Pv_cia
         and no_acti = Lc_NoDepreciar.no_acti;
    END LOOP;

      --Actualiza el mes y anio de cierre
      UPDATE arafmc
      SET ult_ano_cierre = Pn_ano,
        ult_mes_cierre   = Pn_mes,
        mes              = decode(Pn_mes,12,1,Pn_mes+1),
        ano              = decode(Pn_mes,12,Pn_ano+1,Pn_ano),
        ind_calculo_dep    = 'N',
        ind_depre_generada = 'N'
      WHERE no_cia         = Pv_cia;

    --Borra los movimientos para el mes
    DELETE FROM ARAFDC
    WHERE NO_CIA  = Pv_cia
    AND ANO = Pn_ano
    AND MES = Pn_mes;

    DELETE ARAFMM
    WHERE no_cia  = Pv_cia
    and ano = Pn_ano
    and mes = Pn_mes;

  EXCEPTION
    WHEN others THEN
      Pv_Error := sqlerrm;
  End;

  ----------------------------------------------------------------------
  -- Procedimiento que realiza ajuste por centavo a cuenta de Debito  --
  ----------------------------------------------------------------------
  Procedure P_DIFERENCIA_CENTAVOS (Pv_cia        IN varchar2,
                                   Pn_NumAsiento IN arcgae.no_asiento%type,
                                   Pv_Error      IN OUT varchar2 ) is

  Cursor C_Diferencias (Cv_AsientoDepreciacion varchar2) is
    Select al.no_asiento, sum(decode(tipo,'C',monto)*-1) credito, sum(decode(tipo,'D',monto)) debito
    From arcgae ae, arcgal al
    Where ae.no_cia=Pv_cia and ae.descri1 like '%'||Cv_AsientoDepreciacion||'%'
    and ae.no_cia=al.no_cia and ae.no_asiento=al.no_asiento
    having sum(decode(tipo,'C',monto)*-1) <> sum(decode(tipo,'D',monto))
    Group by al.no_asiento;

  Cursor C_CuentaDebito (Cv_AsientoRegulariza varchar2) is
    Select no_linea, monto from arcgal
    where no_cia=Pv_cia and no_asiento= Cv_AsientoRegulariza
    and tipo='D' and rownum=1;

  Lv_DiferenciaCredito Number :=0;
  Lv_DiferenciaDedito  Number :=0;
  Ln_Linea             Number;
  Ln_Monto             Number :=0;

  Begin
    For Lv_Diferencias in C_Diferencias(Pn_NumAsiento) Loop   -- parametro del proceso
      -- Descuadre por centavos al debito
      If nvl(Lv_Diferencias.credito,0) > nvl(Lv_Diferencias.debito,0) Then
        Lv_DiferenciaCredito := nvl(Lv_Diferencias.credito,0) - nvl(Lv_Diferencias.debito,0);
        --
        Open C_CuentaDebito (Lv_Diferencias.no_asiento);
        Fetch C_CuentaDebito into Ln_Linea, Ln_Monto;
        Close C_CuentaDebito;
        --
        Update arcgal set monto= nvl(Ln_Monto,0) + nvl(Lv_DiferenciaCredito,0), monto_dol= nvl(Ln_Monto,0) + nvl(Lv_DiferenciaCredito,0)
        Where no_cia=Pv_cia and no_asiento=Lv_Diferencias.no_asiento and no_linea = Ln_Linea;
      End if;

      -- Descuadre por centavos al credito
      If nvl(Lv_Diferencias.credito,0) < nvl(Lv_Diferencias.debito,0) Then
        Lv_DiferenciaDedito := nvl(Lv_Diferencias.debito,0) - nvl(Lv_Diferencias.credito,0);
        --
        Open C_CuentaDebito (Lv_Diferencias.no_asiento);
        Fetch C_CuentaDebito into Ln_Linea, Ln_Monto;
        Close C_CuentaDebito;
        --
        Update arcgal set monto= nvl(Ln_Monto,0) - nvl(Lv_DiferenciaCredito,0), monto_dol= nvl(Ln_Monto,0) - nvl(Lv_DiferenciaCredito,0)
        Where no_cia=Pv_cia and no_asiento=Lv_Diferencias.no_asiento and no_linea = Ln_Linea;
      End if;
    End Loop;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error := 'Error en P_DIFERENCIA_CENTAVOS. ' || SQLERRM;
      ROLLBACK;
  End;

  PROCEDURE P_INICIALIZA_TEMPORAL ( Pv_NoCia        IN VARCHAR2,
                                    Pn_Procesado    IN NUMBER,
                                    Pv_MensajeError IN OUT VARCHAR2 ) IS

  BEGIN
    -- elimina data de tabla temporal
    DELETE ARAF_ARTICULO_INSTALADO
    WHERE NO_CIA = Pv_NoCia
    AND USR_CREACION = USER
    AND PROCESAR = NVL(Pn_Procesado, PROCESAR);
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INICIALIZA_TEMPORAL. ' || SQLERRM;
      ROLLBACK;
  END;
  --
  PROCEDURE P_REGISTRA_CARGA_TEMPORAL ( Pv_NumeroSerie  IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2,
                                        Pv_MensajeError IN OUT VARCHAR2 ) IS

  BEGIN
    -- inserta registros eniados por parametros
    INSERT INTO ARAF_ARTICULO_INSTALADO
           ( NO_CIA,
             NUMERO_SERIE,
             USR_CREACION,
             FE_CREACION)
    VALUES ( Pv_NoCia,
             Pv_NumeroSerie,
             USER,
             SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_REGISTRA_CARGA_TEMPORAL. ' || SQLERRM;
      ROLLBACK;
  END;


  PROCEDURE P_VALIDA_CARGA ( Pv_NoCia        IN VARCHAR2,
                             Pv_MensajeError IN OUT VARCHAR2 ) IS
    -- cursor que recupera la data insertada en tabla temporal
    CURSOR C_DATOS_CARGADOS IS
      SELECT *
      FROM ARAF_ARTICULO_INSTALADO
      WHERE USR_CREACION = USER
      AND NO_CIA = Pv_NoCia;
    --
    -- cursor que recupera datos de repositorio de instalacion
    CURSOR C_DATOS_SERIE ( Cv_NumeroSerie VARCHAR2,
                           Cv_NoCia       VARCHAR2) IS
      -- recupera equipos despachados hacia compania logoneada
      SELECT ID_COMPANIA,
        ID_ARTICULO,
        DESCRIPCION,
        MODELO,
        CANTIDAD,
        FECHA,
        ID_CUSTODIO,
        ID_BODEGA,
        NOMBRE_BODEGA,
        MAC,
        ID_EMPRESA_CUSTODIO,
        TIPO_PROCESO,
        ID_DOCUMENTO_ORIGEN,
        TIPO_DOCUMENTO_ORIGEN
      FROM IN_ARTICULOS_INSTALACION
      WHERE NUMERO_SERIE = Cv_NumeroSerie
      AND ID_EMPRESA_DESPACHA = Cv_NoCia
      AND TIPO_ARTICULO = 'AF'
      AND NOT EXISTS (SELECT NULL
                      FROM ARAFMA
                      WHERE ARAFMA.SERIE = IN_ARTICULOS_INSTALACION.NUMERO_SERIE
                      AND ARAFMA.NO_CIA = IN_ARTICULOS_INSTALACION.ID_EMPRESA_DESPACHA)
      UNION
      -- recupera equipos despachados desde compania logoneada
      SELECT ID_COMPANIA,
        ID_ARTICULO,
        DESCRIPCION,
        MODELO,
        CANTIDAD,
        FECHA,
        ID_CUSTODIO,
        ID_BODEGA,
        NOMBRE_BODEGA,
        MAC,
        ID_EMPRESA_CUSTODIO,
        TIPO_PROCESO,
        ID_DOCUMENTO_ORIGEN,
        TIPO_DOCUMENTO_ORIGEN
      FROM IN_ARTICULOS_INSTALACION
      WHERE NUMERO_SERIE = Cv_NumeroSerie
      AND ID_COMPANIA = Cv_NoCia
      AND TIPO_ARTICULO = 'AF'
      AND NOT EXISTS (SELECT NULL
                      FROM ARAFMA
                      WHERE ARAFMA.SERIE = IN_ARTICULOS_INSTALACION.NUMERO_SERIE
                      AND ARAFMA.NO_CIA = IN_ARTICULOS_INSTALACION.ID_EMPRESA_DESPACHA);
    --
    -- cursor que recupera datos tecnicos asociados con el numero de serie.
    CURSOR C_DATOS_TECNICOS (Cv_NumeroSerie VARCHAR2,
                             Cv_NoCia       VARCHAR2) IS
      SELECT A.LOGIN,
          D.NOMBRE_ELEMENTO
        FROM DB_COMERCIAL.INFO_PUNTO A,
          DB_COMERCIAL.INFO_SERVICIO B,
          DB_COMERCIAL.INFO_SERVICIO_TECNICO C,
          DB_INFRAESTRUCTURA.INFO_ELEMENTO D,
          DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO E,
          DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO G,
          DB_INFRAESTRUCTURA.ADMI_JURISDICCION H,
          DB_COMERCIAL.INFO_OFICINA_GRUPO I
        WHERE A.ID_PUNTO = B.PUNTO_ID
        AND B.ID_SERVICIO = C.SERVICIO_ID
        AND C.ELEMENTO_CLIENTE_ID = D.ID_ELEMENTO
        AND D.MODELO_ELEMENTO_ID = E.ID_MODELO_ELEMENTO
        AND E.TIPO_ELEMENTO_ID = G.ID_TIPO_ELEMENTO
        AND A.PUNTO_COBERTURA_ID = H.ID_JURISDICCION
        AND H.OFICINA_ID = I.ID_OFICINA
        AND I.EMPRESA_ID = Cv_NoCia
        AND D.SERIE_FISICA = Cv_NumeroSerie
        AND G.NOMBRE_TIPO_ELEMENTO = 'CPE'
        AND B.ESTADO = 'Activo';
    --
    Lr_DatosSerie   C_DATOS_SERIE%ROWTYPE := NULL;
    Lr_DatosTecnico C_DATOS_TECNICOS%ROWTYPE := NULL;
    --
  BEGIN
    -- se leen los datos cargados
    FOR Lr_Datos IN C_DATOS_CARGADOS LOOP
      --
      Lr_DatosSerie := NULL;
      Lr_DatosTecnico := NULL;
      --
      -- se recueparn los datos de repositorio instalacion
      IF C_DATOS_SERIE%ISOPEN THEN
        CLOSE C_DATOS_SERIE;
      END IF;
      --
      OPEN C_DATOS_SERIE(Lr_Datos.Numero_Serie,
                         Lr_Datos.No_Cia);
      FETCH C_DATOS_SERIE INTO Lr_DatosSerie;
      IF C_DATOS_SERIE%NOTFOUND THEN
        Lr_DatosSerie := NULL;
      END IF;
      CLOSE C_DATOS_SERIE;
      --
      -- se recuperan datos tecnicos
      IF C_DATOS_TECNICOS%ISOPEN THEN
        CLOSE C_DATOS_TECNICOS;
      END IF;
      --
      OPEN C_DATOS_TECNICOS(Lr_Datos.Numero_Serie,
                         Lr_Datos.No_Cia);
      FETCH C_DATOS_TECNICOS INTO Lr_DatosTecnico;
      IF C_DATOS_TECNICOS%NOTFOUND THEN
        Lr_DatosTecnico := NULL;
      END IF;
      CLOSE C_DATOS_TECNICOS;
      --
      -- se actualizan los registros que retornan datos
      IF Lr_DatosSerie.Descripcion IS NOT NULL THEN
        UPDATE ARAF_ARTICULO_INSTALADO
        SET FECHA = Lr_DatosSerie.Fecha,
          DESC_ARTICULO = Lr_DatosSerie.Descripcion,
          MODELO = Lr_DatosSerie.Modelo,
          MAC = Lr_DatosSerie.Mac,
          CANTIDAD = Lr_DatosSerie.Cantidad,
          LOGIN_CLIENTE = Lr_DatosTecnico.Login,
          NOMBRE_CPE = Lr_DatosTecnico.Nombre_Elemento,
          ID_DOCUMENTO_ORIGEN = Lr_DatosSerie.Id_Documento_Origen,
          TIPO_DOCUMENTO_ORIGEN =  Lr_DatosSerie.Tipo_Documento_Origen,
          ID_ARTICULO = Lr_DatosSerie.Id_Articulo
        WHERE NUMERO_SERIE = Lr_Datos.Numero_Serie
        AND USR_CREACION = USER;
      END IF;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_VALIDA_CARGA. ' || SQLERRM;
      ROLLBACK;
  END;

--
  PROCEDURE P_INFORMACION_COMPLEMENTARIA ( Pv_NoCia           IN VARCHAR2,
                                                                          Pv_MensajeError IN OUT VARCHAR2 ) IS

    -- cursor que recupera la data insertada en tabla temporal para buscar el resto de informaci¿n 
    CURSOR C_DATOS_CARGADOS IS
        SELECT no_cia, numero_serie, id_documento_origen, tipo_documento_origen, fecha, id_articulo, 
                    NVL(  SUBSTR(id_documento_origen, length(id_documento_origen)-1, 2) , '00')   origen
        FROM ARAF_ARTICULO_INSTALADO
        WHERE USR_CREACION = USER
        AND NO_CIA = Pv_NoCia;
    --
    CURSOR C_DATOS_ARINME (Cv_NoDocu VARCHAR2 )  IS    
        SELECT ME.EMPLE_SOLIC, ME.C_COSTO_EMPLESOL, EE.area,  EE.depto 
        FROM ARINME ME, V_EMPLEADOS_EMPRESAS EE 
        WHERE ME.NO_CIA = Pv_NoCia
        AND ME.NO_DOCU = Cv_NoDocu
        AND ME.NO_CIA=EE.no_cia 
        AND ME.EMPLE_SOLIC=EE.no_emple;            
    --
    CURSOR C_DATOS_REQUISICION (Cv_NumeroSolicitud VARCHAR2, Cv_TipoSolicitud VARCHAR2)  IS       
        SELECT SR.USUARIO_APROBACION, SR.CENTRO_COSTO, EE.area,  EE.depto 
        FROM INV_CAB_SOLICITUD_REQUISICION SR, V_EMPLEADOS_EMPRESAS EE 
        WHERE SR.NO_CIA = Pv_NoCia
        AND SR.NUMERO_SOLICITUD = Cv_NumeroSolicitud
        AND SR.TIPO_DOCUMENTO = Cv_TipoSolicitud
        AND SR.NO_CIA=EE.no_cia 
        AND SR.USUARIO_APROBACION=EE.no_emple;     
    --
    CURSOR C_DATOS_CONSUMO (Cv_NumeroSolicitud VARCHAR2, Cv_TipoSolicitud VARCHAR2)  IS      
        SELECT CI.EMPLE_APRUEBA, CI.C_COSTO_EMPLESOL,  EE.area,  EE.depto 
        FROM  ARINENCCONSUMOINTER CI, V_EMPLEADOS_EMPRESAS EE 
        WHERE CI.NO_CIA = Pv_NoCia
        AND CI.NO_FISICO = Cv_NumeroSolicitud
        AND CI.TIPO_DOC = Cv_TipoSolicitud
        AND CI.NO_CIA=EE.no_cia 
        AND CI.EMPLE_APRUEBA= EE.no_emple;       
    --
    CURSOR C_DATOS_COMPRA (Cv_NumeroSolicitud VARCHAR2)  IS     
        SELECT ME.FECHA, ME.NO_FISICO, ME.SERIE_FISICO
        FROM INV_DOCUMENTO_SERIE DC, ARINME ME 
        WHERE DC.COMPANIA = Pv_NoCia
        AND DC.SERIE = Cv_NumeroSolicitud
        AND DC.COMPANIA = ME.NO_CIA
        AND DC.ID_DOCUMENTO = ME.NO_DOCU 
        AND ME.TIPO_DOC IN (SELECT TIPO_M FROM ARINVTM WHERE NO_CIA =Pv_NoCia AND MOVIMI='E' AND INTERFACE IN ('IM','CO'));

    CURSOR C_DATOS_COSTO_MARCA (Cv_NoArticulo VARCHAR2)  IS  
        SELECT TO_NUMBER(MARCA) MARCA, COSTO_UNITARIO
        FROM ARINDA 
        WHERE NO_CIA=Pv_NoCia
        AND NO_ARTI = Cv_NoArticulo;

    Lr_DatosComplementario  C_DATOS_ARINME%ROWTYPE := NULL;
    Lr_DatosCostoMarca         C_DATOS_COSTO_MARCA%ROWTYPE := NULL;
    Lr_DatosCompra              C_DATOS_COMPRA%ROWTYPE := NULL;
    --
  BEGIN
    -- se leen los datos cargados
    FOR Lr_Datos IN C_DATOS_CARGADOS LOOP
      --
      IF  Lr_Datos.Origen = '05'  Then 
          -- se recuperan datos 
          IF C_DATOS_ARINME%ISOPEN THEN
            CLOSE C_DATOS_ARINME;
          END IF;
          --
          OPEN C_DATOS_ARINME(Lr_Datos.Id_Documento_Origen);
          FETCH C_DATOS_ARINME INTO Lr_DatosComplementario;
          IF C_DATOS_ARINME%NOTFOUND THEN
            Lr_DatosComplementario := NULL;
          END IF;
          CLOSE C_DATOS_ARINME; 
          --
      ELSIF  Lr_Datos.Origen = '00'   THEN
            Lr_DatosComplementario := NULL;

      ELSE 
              -- se recuperan datos de tabla  INV_CAB_SOLICITUD_REQUISICION
              IF C_DATOS_REQUISICION%ISOPEN THEN
                CLOSE C_DATOS_REQUISICION;
              END IF;
              --
              OPEN C_DATOS_REQUISICION(Lr_Datos.Id_Documento_Origen, Lr_Datos.Tipo_Documento_Origen);
              FETCH C_DATOS_REQUISICION INTO Lr_DatosComplementario;
              IF C_DATOS_REQUISICION%NOTFOUND THEN
                Lr_DatosComplementario := NULL;
              END IF;
              CLOSE C_DATOS_REQUISICION;              
              --
              -- se recuperan datos de tabla  ARINENCCONSUMOINTER
              IF C_DATOS_CONSUMO%ISOPEN THEN
                CLOSE C_DATOS_CONSUMO;
              END IF;
              --
              OPEN C_DATOS_CONSUMO(Lr_Datos.Id_Documento_Origen, Lr_Datos.Tipo_Documento_Origen);
              FETCH C_DATOS_CONSUMO INTO Lr_DatosComplementario;
              IF C_DATOS_CONSUMO%NOTFOUND THEN
                Lr_DatosComplementario := NULL;
              END IF;
              CLOSE C_DATOS_CONSUMO;            
              --                           
      END IF;    
      --
      -- se recuperan datos de Compra
      IF C_DATOS_COMPRA%ISOPEN THEN
        CLOSE C_DATOS_COMPRA;
      END IF;
      --
      OPEN C_DATOS_COMPRA(Lr_Datos.Id_Documento_Origen);
      FETCH C_DATOS_COMPRA INTO Lr_DatosCompra;
      IF C_DATOS_COMPRA%NOTFOUND THEN
        Lr_DatosCompra := NULL;
      END IF;
      CLOSE C_DATOS_COMPRA;            
      --
      -- se recuperan datos de Costo y  Marca
      IF C_DATOS_COSTO_MARCA%ISOPEN THEN
        CLOSE C_DATOS_COSTO_MARCA;
      END IF;
      --
      OPEN C_DATOS_COSTO_MARCA(Lr_Datos.Id_Articulo);
      FETCH C_DATOS_COSTO_MARCA INTO Lr_DatosCostoMarca;
      IF C_DATOS_COSTO_MARCA%NOTFOUND THEN
        Lr_DatosCostoMarca := NULL;
      END IF;
      CLOSE C_DATOS_COSTO_MARCA; 
      --
      -- se actualizan los registros que retornan datos    ME.EMPLE_SOLIC, ME.C_COSTO_EMPLESOL, EE.area,  EE.depto 
      IF Lr_Datos.Numero_Serie  IS NOT NULL THEN
        UPDATE ARAF_ARTICULO_INSTALADO  
            SET No_Emple = Lr_DatosComplementario.Emple_Solic,
              CENTRO_COSTO = Lr_DatosComplementario.c_Costo_Emplesol,
              NO_AREA = Lr_DatosComplementario.Area,
              NO_DEPTO = Lr_DatosComplementario.Depto,               
              NO_FISICO = Lr_DatosCompra.No_Fisico,
              NO_SERIE = Lr_DatosCompra.Serie_Fisico,
              FECHA_COMPRA = nvl(Lr_DatosCompra.Fecha, Lr_Datos.Fecha),
              MONTO_COMPRA = Lr_DatosCostoMarca.Costo_Unitario,
              MARCA = Lr_DatosCostoMarca.Marca
        WHERE  NO_CIA = Pv_NoCia
        AND NUMERO_SERIE = Lr_Datos.Numero_Serie
        AND USR_CREACION = USER;
      END IF;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INFORMACION_COMPLEMENTARIA. ' || SQLERRM;
      ROLLBACK;
  END;
--
--
  PROCEDURE P_PROCESAR_ACTIVO_FIJO ( Pr_DatosAF        IN AFK_PROCESOS.Lr_CargaAF  ,
                                                              Pv_MensajeError IN OUT VARCHAR2 ) IS
    -- cursor que recupera datos cargados
    CURSOR C_DATOS_CARGADOS IS
      SELECT *
      FROM ARAF_ARTICULO_INSTALADO
      WHERE PROCESAR = 1
      AND USR_CREACION = USER
      AND NO_CIA = Pr_DatosAF.NO_CIA;
    --
    Lr_Arafma NAF47_TNET.ARAFMA%ROWTYPE := NULL;
    Le_Error  EXCEPTION;
    --
  BEGIN

   -- se lee la data cargada
    FOR Lr_Datos IN C_DATOS_CARGADOS LOOP
      -- inicializaciones
      Lr_Arafma := NULL;
      --
      -- si inicializan la variale registro af
      Lr_Arafma.NO_CIA := Lr_Datos.No_Cia;
      Lr_Arafma.DESCRI := SUBSTR(Lr_Datos.DESC_ARTICULO,1,100);
      Lr_Arafma.DESCRI1 := Lr_Datos.DESC_ARTICULO;
      Lr_Arafma.SERIE := Lr_Datos.NUMERO_SERIE;
      Lr_Arafma.MODELO := Lr_Datos.MODELO;
      Lr_Arafma.TIPO := Pr_DatosAF.TIPO;
      Lr_Arafma.GRUPO := Pr_DatosAF.GRUPO;
      Lr_Arafma.SUBGRUPO := Pr_DatosAF.SUBGRUPO;
      --
      Lr_Arafma.AREA := Pr_DatosAF.AREA;
      Lr_Arafma.NO_DEPA := Pr_DatosAF.DEPARTAMENTO;
      Lr_Arafma.NO_FISICO := Pr_DatosAF.NO_FISICO;
      Lr_Arafma.SERIE_FISICO := Pr_DatosAF.SERIE_FISICO;
      --
      Lr_Arafma.F_INGRE := Pr_DatosAF.FECHA_COMPRA;
      Lr_Arafma.DURACION := Pr_DatosAF.VIDA_UTIL;
      --
      Lr_Arafma.DESECHO := 0;
      Lr_Arafma.CTAVO := Pr_DatosAF.CUENTA_VO;
      Lr_Arafma.CTADAVO := Pr_DatosAF.CUENTA_DAVO;
      Lr_Arafma.CTAGAVO := Pr_DatosAF.CUENTA_GAVO;
      Lr_Arafma.CENTRO_COSTO := Pr_DatosAF.CENTRO_COSTO;
      Lr_Arafma.FECHA_CAMBIO := Pr_DatosAF.FECHA_COMPRA;
      Lr_Arafma.TIPO_CAMBIO := 1;
      Lr_Arafma.T_CAMB_C_V := 'C';
      Lr_Arafma.INDICE := 1;
      Lr_Arafma.METODO_DEP := Pr_DatosAF.METODO_DEP;
      Lr_Arafma.FECHA_INICIO_DEP := Pr_DatosAF.FECHA_COMPRA;
      Lr_Arafma.VAL_ORIGINAL := ROUND((Pr_DatosAF.MONTO / Pr_DatosAF.CANTIDAD_REG),2);
      Lr_Arafma.VAL_ORIGINAL_DOL := ROUND((Pr_DatosAF.MONTO / Pr_DatosAF.CANTIDAD_REG),2);
      Lr_Arafma.MEJORAS := 0;
      Lr_Arafma.DEPACUM_VALORIG_ANT := 0;
      Lr_Arafma.DEPACUM_MEJORAS_ANT := 0;
      Lr_Arafma.DEPACUM_REVTECS_ANT := 0;
      Lr_Arafma.DEPACUM_VALORIG := 0;
      Lr_Arafma.DEPACUM_MEJORAS := 0;
      Lr_Arafma.DEPACUM_REVTECS := 0;
      Lr_Arafma.DEPRE_EJER_VO_ANT := 0;
      Lr_Arafma.DEPRE_EJER_VO := 0;
      Lr_Arafma.DEPRE_EJER_MEJ_ANT := 0;
      Lr_Arafma.DEPRE_EJER_MEJ := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC_ANT := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC := 0;
      Lr_Arafma.DEPACUM_VALORIG_ANT_DOL := 0;
      Lr_Arafma.DEPACUM_MEJORAS_ANT_DOL := 0;
      Lr_Arafma.DEPACUM_REVTECS_ANT_DOL := 0;
      Lr_Arafma.DEPACUM_VALORIG_DOL := 0;
      Lr_Arafma.DEPACUM_MEJORAS_DOL := 0;
      Lr_Arafma.DEPACUM_REVTECS_DOL := 0;
      Lr_Arafma.DEPRE_EJER_VO_ANT_DOL := 0;
      Lr_Arafma.DEPRE_EJER_VO_DOL := 0;
      Lr_Arafma.DEPRE_EJER_MEJ_ANT_DOL := 0;
      Lr_Arafma.DEPRE_EJER_MEJ_DOL := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC_ANT_DOL := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC_DOL := 0;
      Lr_Arafma.ESTADO := 'B';
      Lr_Arafma.TIPO_ADQUISICION := 'C';
      Lr_Arafma.COD_MARCA := Pr_DatosAF.MARCA;
      Lr_Arafma.DEPACUM_VO_INICIAL := 0;
      Lr_Arafma.ORIGEN := 'IN';
      Lr_Arafma.USUARIO := USER;
      Lr_Arafma.LOGIN_CLIENTE := Lr_Datos.LOGIN_CLIENTE;
      Lr_Arafma.NOMBRE_CPE := Lr_Datos.NOMBRE_CPE;
      --
      -- replica informacion af
      AFK_PROCESOS.P_REPLICA_ACTIVO_FIJO (Lr_Arafma, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END LOOP;

    -- Elimina Procesados
    P_INICIALIZA_TEMPORAL (Pr_DatosAF.NO_CIA,
                           1, -- Procesados
                           Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_PROCESAR_ACTIVO_FIJO. ' || SQLERRM;
      ROLLBACK;
  END;
  --
  --
  PROCEDURE P_PROCESAR_ACTIVO_FIJO_DESECHO ( Pr_DatosAF        IN AFK_PROCESOS.Lr_CargaAF  ,
                                                                             Pv_MensajeError IN OUT VARCHAR2 ) IS
    -- cursor que recupera datos cargados
    CURSOR C_DATOS_CARGADOS IS
        SELECT *
        FROM ARAF_ARTICULO_INSTALADO
        WHERE PROCESAR = 1
        AND USR_CREACION = USER
        AND NO_CIA = Pr_DatosAF.NO_CIA;
    --   
    CURSOR C_PORCENTAJE_DESECHO IS      
        SELECT PORCENTAJE_DESECHO
        FROM  ARAFMT
        WHERE NO_CIA = Pr_DatosAF.NO_CIA  
        AND TIPO = Pr_DatosAF.TIPO;      
    --
    Lr_Arafma NAF47_TNET.ARAFMA%ROWTYPE := NULL;
    Ln_Desecho  Arafma.Desecho%type;
    Le_Error  EXCEPTION;
    --
  BEGIN     
   -- se lee la data cargada
    FOR Lr_Datos IN C_DATOS_CARGADOS LOOP
      -- inicializaciones
      Lr_Arafma := NULL;
      --
      -- si inicializan la variale registro af
      Lr_Arafma.NO_CIA := Lr_Datos.No_Cia;
      Lr_Arafma.DESCRI := SUBSTR(Lr_Datos.DESC_ARTICULO,1,100);
      Lr_Arafma.DESCRI1 := Lr_Datos.DESC_ARTICULO;
      Lr_Arafma.SERIE := Lr_Datos.NUMERO_SERIE;
      Lr_Arafma.MODELO := Lr_Datos.MODELO;
      Lr_Arafma.TIPO := Pr_DatosAF.TIPO;
      Lr_Arafma.GRUPO := Pr_DatosAF.GRUPO;
      Lr_Arafma.SUBGRUPO := Pr_DatosAF.SUBGRUPO;
      --
      Lr_Arafma.AREA := Pr_DatosAF.AREA;
      Lr_Arafma.NO_DEPA := Pr_DatosAF.DEPARTAMENTO;
      Lr_Arafma.NO_FISICO := Pr_DatosAF.NO_FISICO;
      Lr_Arafma.SERIE_FISICO := Pr_DatosAF.SERIE_FISICO;
      --
      Lr_Arafma.F_INGRE := Pr_DatosAF.FECHA_COMPRA;
      Lr_Arafma.DURACION := Pr_DatosAF.VIDA_UTIL;
      --
      IF C_PORCENTAJE_DESECHO%ISOPEN THEN
        CLOSE C_PORCENTAJE_DESECHO;
      END IF;
      OPEN C_PORCENTAJE_DESECHO;
      FETCH C_PORCENTAJE_DESECHO INTO Ln_Desecho;
      CLOSE C_PORCENTAJE_DESECHO;
      If  nvl(Ln_Desecho, 0) > 0  Then
        Lr_Arafma.DESECHO  := round((Pr_DatosAF.MONTO  * (Ln_Desecho/100)) ,2);
      Else
         Lr_Arafma.DESECHO := 0;
      End if;
      --
      Lr_Arafma.CTAVO := Pr_DatosAF.CUENTA_VO;
      Lr_Arafma.CTADAVO := Pr_DatosAF.CUENTA_DAVO;
      Lr_Arafma.CTAGAVO := Pr_DatosAF.CUENTA_GAVO;
      Lr_Arafma.CENTRO_COSTO := Lr_Datos.Centro_Costo;  
      Lr_Arafma.FECHA_CAMBIO := Lr_Datos.Fecha_Compra; 
      Lr_Arafma.TIPO_CAMBIO := 1;
      Lr_Arafma.T_CAMB_C_V := 'C';
      Lr_Arafma.INDICE := 1;
      Lr_Arafma.METODO_DEP := Pr_DatosAF.METODO_DEP;
      Lr_Arafma.FECHA_INICIO_DEP := Pr_DatosAF.FECHA_COMPRA;
      Lr_Arafma.VAL_ORIGINAL := Lr_Datos.Monto_Compra;  
      Lr_Arafma.VAL_ORIGINAL_DOL := Lr_Datos.Monto_Compra;  
      Lr_Arafma.MEJORAS := 0;
      Lr_Arafma.DEPACUM_VALORIG_ANT := 0;
      Lr_Arafma.DEPACUM_MEJORAS_ANT := 0;
      Lr_Arafma.DEPACUM_REVTECS_ANT := 0;
      Lr_Arafma.DEPACUM_VALORIG := 0;
      Lr_Arafma.DEPACUM_MEJORAS := 0;
      Lr_Arafma.DEPACUM_REVTECS := 0;
      Lr_Arafma.DEPRE_EJER_VO_ANT := 0;
      Lr_Arafma.DEPRE_EJER_VO := 0;
      Lr_Arafma.DEPRE_EJER_MEJ_ANT := 0;
      Lr_Arafma.DEPRE_EJER_MEJ := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC_ANT := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC := 0;
      Lr_Arafma.DEPACUM_VALORIG_ANT_DOL := 0;
      Lr_Arafma.DEPACUM_MEJORAS_ANT_DOL := 0;
      Lr_Arafma.DEPACUM_REVTECS_ANT_DOL := 0;
      Lr_Arafma.DEPACUM_VALORIG_DOL := 0;
      Lr_Arafma.DEPACUM_MEJORAS_DOL := 0;
      Lr_Arafma.DEPACUM_REVTECS_DOL := 0;
      Lr_Arafma.DEPRE_EJER_VO_ANT_DOL := 0;
      Lr_Arafma.DEPRE_EJER_VO_DOL := 0;
      Lr_Arafma.DEPRE_EJER_MEJ_ANT_DOL := 0;
      Lr_Arafma.DEPRE_EJER_MEJ_DOL := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC_ANT_DOL := 0;
      Lr_Arafma.DEPRE_EJER_REVTEC_DOL := 0;
      Lr_Arafma.ESTADO := 'B';
      Lr_Arafma.TIPO_ADQUISICION := 'C';
      Lr_Arafma.COD_MARCA := Lr_Datos.Marca; 
      Lr_Arafma.DEPACUM_VO_INICIAL := 0;
      Lr_Arafma.ORIGEN := 'IN';
      Lr_Arafma.USUARIO := USER;
      Lr_Arafma.LOGIN_CLIENTE := Lr_Datos.LOGIN_CLIENTE;
      Lr_Arafma.NOMBRE_CPE := Lr_Datos.NOMBRE_CPE;
      --
      Lr_Arafma.No_Emple  := Lr_Datos.No_Emple;
      Lr_Arafma.Area  := Lr_Datos.No_Area;
      Lr_Arafma.No_Depa  := Lr_Datos.No_Depto;
      Lr_Arafma.No_Fisico  := Lr_Datos.No_Fisico; 
      Lr_Arafma.Serie_Fisico  := Lr_Datos.No_Serie;
      --
      -- replica informacion af
      AFK_PROCESOS.P_REPLICA_ACTIVO_FIJO (Lr_Arafma, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END LOOP;

    -- Elimina Procesados
    P_INICIALIZA_TEMPORAL (Pr_DatosAF.NO_CIA,
                           1, -- Procesados
                           Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_PROCESAR_ACTIVO_FIJO_DESECHO. ' || SQLERRM;
      ROLLBACK;
  END;

END AFK_PROCESOS;
/
