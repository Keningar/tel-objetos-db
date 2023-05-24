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
  * @param Pv_NoCia              IN  VARCHAR2     			                Recibe codigo de empresa
  * @param Pv_Ano                IN  VARCHAR2     			                Recibe año a procesar
  * @param Pv_Mes                IN  VARCHAR2     			                Recibe mes a procesar
  * @param Pv_ToAsi              IN  VARCHAR2     			                Bandera que indica si se procesa un asiento especifico o todos
  * @param Pv_Moneda             IN  VARCHAR2     			                Recibe el tipode moneda
  * @param Pv_NumAsiento         IN  VARCHAR2     			                Recibe número del asiento a procesar si es que aplica
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
  BEGIN
    naf47_tnet.cgk_mayorizar_asientos.cgp_valida_cta_ajuste@gpoetnet(Pv_NoCia  => Pv_NoCia,
                                                                     Pv_Cuenta => Pv_Cuenta,
                                                                     Pv_Moneda => Pv_Moneda);
  EXCEPTION
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

    cont_asi        NUMBER(4) := 0;
    cont_lin        NUMBER(10) := 0;
    ac_db           naf47_tnet.arcgae.t_debitos%TYPE := 0;
    ac_dbdol        naf47_tnet.arcgae.t_debitos%TYPE := 0;
    ac_cr           naf47_tnet.arcgae.t_creditos%TYPE := 0;
    ac_crdol        naf47_tnet.arcgae.t_creditos%TYPE := 0;
  BEGIN

    naf47_tnet.cgk_mayorizar_asientos.cgp_actualizar_estructuras@gpoetnet(pv_nocia             => pv_nocia,
                                                                          pn_ano               => pn_ano,
                                                                          pn_mes               => pn_mes,
                                                                          pv_toasi             => pv_toasi,
                                                                          pv_numasiento        => pv_numasiento,
                                                                          pv_mensajefinproceso => pv_mensajefinproceso,
                                                                          pn_cont_asi          => pn_cont_asi,
                                                                          pn_cont_lin          => pn_cont_lin,
                                                                          p_ac_db              => p_ac_db,
                                                                          p_ac_cr              => p_ac_cr,
                                                                          p_ac_dbdol           => p_ac_dbdol,
                                                                          p_ac_crdol           => p_ac_crdol,
                                                                          pCta_Nominal         => pCta_Nominal,
                                                                          pCta_Dolares         => pCta_Dolares);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20002, sqlerrm);
  END cgp_actualizar_estructuras;

END cgk_mayorizar_asientos;
/
