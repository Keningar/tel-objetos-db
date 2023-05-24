CREATE OR REPLACE PACKAGE NAF47_TNET.cgk_mayorizar_asientos AS
  /**
  * Documentacion para cgp_valida_cta_ajuste 
  * Procedimiento realiza la validación de la cuenta de ajuste
  * @author Jimmy Gilces V. <jgilces@telconet.ec>
  * @version 1.0 03/05/2023
  *
  * @param Pv_NoCia        IN VARCHAR2     Recibe codigo de empresa
  * @param Pv_Cuenta       IN VARCHAR2     Recibe el número de la cuenta
  * @param Pv_Moneda       IN VARCHAR2     Recibe el tipode moneda
  */
  PROCEDURE cgp_valida_cta_ajuste(pv_nocia  IN VARCHAR2,
                                  pv_cuenta IN VARCHAR2,
                                  pv_moneda IN VARCHAR2);

  /**
  * Documentacion para cgp_actualizar_estructuras 
  * Procedimiento que comienza la mayorización de los asientos
  * @author Jimmy Gilces V. <jgilces@telconet.ec>
  * @version 1.0 03/05/2023
  *
  * @param Pv_NoCia              IN  VARCHAR2     			            Recibe codigo de empresa
  * @param Pv_Ano                IN  VARCHAR2     			            Recibe año a procesar
  * @param Pv_Mes                IN  VARCHAR2     			            Recibe mes a procesar
  * @param Pv_ToAsi              IN  VARCHAR2     			            Bandera que indica si se procesa un asiento especifico o todos
  * @param Pv_Moneda             IN  VARCHAR2     			            Recibe el tipode moneda
  * @param Pv_NumAsiento         IN  VARCHAR2     			            Recibe número del asiento a procesar si es que aplica
  * @param Pv_MensajeFinProceso  OUT VARCHAR2                           Mensajes que genera el proceso
  * @param Pn_Cont_Asi           OUT NUMBER                             Numero de asientos procesados
  * @param Pn_Cont_Lin           OUT NUMBER                             Numeros de lineas procedadas
  * @param P_Ac_Db               OUT naf47_tnet.arcgae.t_debitos%TYPE   Valor total en Debitos
  * @param P_Ac_Cr               OUT naf47_tnet.arcgae.t_creditos%TYPE  Valor total en Creditos
  * @param P_Ac_Dbdol            OUT naf47_tnet.arcgae.t_debitos%TYPE   Valor total de Debitos en Dolares
  * @param P_Ac_Crdol            OUT naf47_tnet.arcgae.t_creditos%TYPE  Valor total de Creditos en Dolares
  * @param PCta_Nominal          IN  naf47_tnet.ARCGMS.cuenta%TYPE      Cuenta Nominal
  * @param PCta_Dolares          IN  naf47_tnet.ARCGMS.cuenta%TYPE      Cuenta de Dolares
  */
  PROCEDURE cgp_actualizar_estructuras(pv_nocia             VARCHAR2,
                                       pn_ano               naf47_tnet.arcgae.ano%TYPE,
                                       pn_mes               naf47_tnet.arcgae.mes%TYPE,
                                       pv_toasi             VARCHAR2,
                                       pv_numasiento        VARCHAR2,
                                       pv_mensajefinproceso OUT VARCHAR2,
                                       pn_cont_asi          OUT NUMBER,
                                       pn_cont_lin          OUT NUMBER,
                                       p_ac_db              OUT naf47_tnet.arcgae.t_debitos%TYPE,
                                       p_ac_cr              OUT naf47_tnet.arcgae.t_creditos%TYPE,
                                       p_ac_dbdol           OUT naf47_tnet.arcgae.t_debitos%TYPE,
                                       p_ac_crdol           OUT naf47_tnet.arcgae.t_creditos%TYPE,
                                       pCta_Nominal         IN naf47_tnet.ARCGMS.cuenta%TYPE,
                                       pCta_Dolares         IN naf47_tnet.ARCGMS.cuenta%TYPE);

END cgk_mayorizar_asientos;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.cgk_mayorizar_asientos AS

  le_errorproceso EXCEPTION;

  PROCEDURE cgp_valida_cta_ajuste(pv_nocia  IN VARCHAR2,
                                  pv_cuenta IN VARCHAR2,
                                  pv_moneda IN VARCHAR2) IS
    lv_error VARCHAR2(4000) := '';
    vregcta  naf47_tnet.cuenta_contable.datos_r;
  BEGIN
    IF NOT naf47_tnet.cuenta_contable.existe(pv_nocia, pv_cuenta) THEN
      lv_error := 'La cuenta contable no está registrada !!!';
      RAISE le_errorproceso;
    ELSIF NOT naf47_tnet.cuenta_contable.acepta_mov(pv_nocia, pv_cuenta) THEN
      lv_error := 'La cuenta contable no acepta movimientos !!!';
      RAISE le_errorproceso;
    ELSIF NOT
           naf47_tnet.cuenta_contable.permitida(pv_nocia, pv_cuenta, 'CG') THEN
      lv_error := 'Contabilidad no puede utilizar la cuenta contable !!!';
      RAISE le_errorproceso;
    ELSE
      vregcta := naf47_tnet.cuenta_contable.trae_datos(pv_nocia, pv_cuenta);
      IF vregcta.clase NOT IN ('I', 'G') THEN
        lv_error := 'La cuenta contable no es de resultados !!!';
        RAISE le_errorproceso;
      ELSIF vregcta.moneda != pv_moneda THEN
        lv_error := 'La naturaleza de la cuenta no corresponde !!!';
        RAISE le_errorproceso;
      ELSIF vregcta.activa != 'S' THEN
        lv_error := 'La cuenta contable está inactiva !!!';
        RAISE le_errorproceso;
      END IF;

    END IF;
  EXCEPTION
    WHEN le_errorproceso THEN
      raise_application_error(-20001, lv_error);
    WHEN OTHERS THEN
      raise_application_error(-20002, sqlerrm);
  END;

  PROCEDURE cgp_actualizar_estructuras(pv_nocia             VARCHAR2,
                                       pn_ano               naf47_tnet.arcgae.ano%TYPE,
                                       pn_mes               naf47_tnet.arcgae.mes%TYPE,
                                       pv_toasi             VARCHAR2,
                                       pv_numasiento        VARCHAR2,
                                       pv_mensajefinproceso OUT VARCHAR2,
                                       pn_cont_asi          OUT NUMBER,
                                       pn_cont_lin          OUT NUMBER,
                                       p_ac_db              OUT naf47_tnet.arcgae.t_debitos%TYPE,
                                       p_ac_cr              OUT naf47_tnet.arcgae.t_creditos%TYPE,
                                       p_ac_dbdol           OUT naf47_tnet.arcgae.t_debitos%TYPE,
                                       p_ac_crdol           OUT naf47_tnet.arcgae.t_creditos%TYPE,
                                       pCta_Nominal         IN naf47_tnet.ARCGMS.cuenta%TYPE,
                                       pCta_Dolares         IN naf47_tnet.ARCGMS.cuenta%TYPE) IS

    CURSOR encabezadoasiento IS
      SELECT no_asiento, origen, ano, mes
        FROM naf47_tnet.arcgae
       WHERE no_cia = pv_nocia
         AND ano = pn_ano
         AND mes = pn_mes
         AND (no_asiento = pv_numasiento OR pv_toasi = 'S')
         AND estado = 'P'
         AND autorizado = 'S';

    CURSOR c_ctas IS
      SELECT cierre_fiscal, cta_ajuste_nom, cta_ajuste_dol
        FROM naf47_tnet.arcgmc
       WHERE no_cia = pv_nocia;

    va_cierreper    naf47_tnet.arcgmc.cierre_fiscal%TYPE;
    cta_ajuste_nom  VARCHAR2(22);
    cta_ajuste_dol  VARCHAR2(22);
    lv_mensajeerror VARCHAR2(4000) := '';
    cont_asi        NUMBER(4) := 0;
    cont_error      NUMBER(4) := 0;
    cont_lin        NUMBER(10) := 0;
    ac_db           naf47_tnet.arcgae.t_debitos%TYPE := 0;
    ac_dbdol        naf47_tnet.arcgae.t_debitos%TYPE := 0;
    ac_cr           naf47_tnet.arcgae.t_creditos%TYPE := 0;
    ac_crdol        naf47_tnet.arcgae.t_creditos%TYPE := 0;

    pragma autonomous_transaction;
  BEGIN
    FOR ae IN encabezadoasiento LOOP
      --Valida el asiento de apertura
      IF ae.origen = 'AP' THEN
        naf47_tnet.cglib.valida_asiento_apertura(pv_nocia, ae.no_asiento);
      END IF;

      lv_mensajeerror := NULL;
      naf47_tnet.cgmayoriza_asiento(pv_nocia,
                                    ae.no_asiento,
                                    pCta_Nominal,
                                    pCta_Dolares,
                                    ac_db,
                                    ac_dbdol,
                                    ac_cr,
                                    ac_crdol,
                                    cont_lin,
                                    lv_mensajeerror);

      IF lv_mensajeerror IS NOT NULL THEN
        cont_error := cont_error + 1;
        ROLLBACK;
      ELSE
        cont_asi := cont_asi + 1;
        COMMIT;

        --
        -- no se controla error para no detener proceso de mayorizacion.
        naf47_tnet.prkg_control_presupuesto.p_costeo_asiento_contable(ae.no_asiento,
                                                                      pv_nocia,
                                                                      lv_mensajeerror);
        --
        COMMIT;
        --        
      END IF;

    END LOOP; -- de los encabezados

    pn_cont_asi := cont_asi;
    pn_cont_lin := cont_lin;
    p_ac_db     := ac_db;
    p_ac_cr     := ac_cr;
    p_ac_dbdol  := ac_dbdol;
    p_ac_crdol  := ac_crdol; 

    pv_mensajefinproceso := chr(13) || 'Total de Asientos actualizados ' ||
                            to_char(cont_asi) || chr(13) ||
                            'Total de Asientos NO actualizados ' ||
                            to_char(cont_error);

  EXCEPTION
    WHEN le_errorproceso THEN
      raise_application_error(-20001, lv_mensajeerror);
    WHEN OTHERS THEN
      raise_application_error(-20002, sqlerrm);
  END cgp_actualizar_estructuras;

END cgk_mayorizar_asientos;
/
