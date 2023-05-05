create or replace PROCEDURE CGMayoriza_Asiento2(pNumCia      IN ARCGAE.no_cia%TYPE,
                                               pNum_Asiento IN ARCGAE.no_Asiento%TYPE,
                                               pCta_Nominal IN ARCGMS.cuenta%TYPE,
                                               pCta_Dolares IN ARCGMS.cuenta%TYPE,
                                               pAc_db       IN OUT Arcgae.t_debitos%TYPE,
                                               pAc_DbDol    IN OUT Arcgae.t_debitos%TYPE,
                                               pAc_Cr       IN OUT Arcgae.t_creditos%TYPE,
                                               pAc_CrDol    IN OUT Arcgae.t_creditos%TYPE,
                                               pCont_Lin    IN OUT NUMBER,
                                               pmsg_error   IN OUT VARCHAR2) IS
/**
* Documentacion para procedure CGMayoriza_Asiento 
* Procedimiento genera mayorización de asiento contable.
* @author yoveri <yoveri@yoveri.com>
* @version 1.0 01/01/2007
*
* @author llindao <llindao@telconet.ec>
* @version 1.1 31/08/2020 -  Se modifica para considerar nuevo campo que asocia la distribución de costo con el asiento contable.
*
* @param pNumCia      IN ARCGAE.no_cia%TYPE         Recibe Identificación de compañía
* @param pNum_Asiento IN ARCGAE.no_Asiento%TYPE     Recibe Identificación de asiento contable
* @param pCta_Nominal IN ARCGMS.cuenta%TYPE         Recibe código de cuenta contable nominal
* @param pCta_Dolares IN ARCGMS.cuenta%TYPE         Recibe código de cuenta contable dolares
* @param pAc_db       IN OUT Arcgae.t_debitos%TYPE  Retorna monto total Débito
* @param pAc_DbDol    IN OUT Arcgae.t_debitos%TYPE  Retorna monto total Débito Dolares
* @param pAc_Cr       IN OUT Arcgae.t_creditos%TYPE Retorna monto total Crédito
* @param pAc_CrDol    IN OUT Arcgae.t_creditos%TYPE Retorna monto total Crédito Dolares
* @param pCont_Lin    IN OUT NUMBER                 Retorna Contador linea
* @param pmsg_error   IN OUT VARCHAR2               Retorna mensaje de error 
*/
  --
  --
  error_proceso EXCEPTION;
  --
  cNewLine VARCHAR2(2) := CHR(13);
  --
  vExiste          BOOLEAN;
  vMonto_Total_Nom Arcgal.monto%TYPE;
  vMonto_Total_Dol Arcgal.monto_dol%TYPE;
  --
  vTot_Cred_Enc Arcgae.T_Creditos%TYPE;
  vTot_Deb_Enc  Arcgae.T_Debitos%TYPE;
  vmonto_nomi   ARCGMS.DEBITOS%TYPE := 0;
  vmonto_dol    ARCGMS.DEBITOS%TYPE := 0;
  --
  PerPresicionNom ARCGMS.DEBITOS%TYPE;
  PerPresicionDol ARCGMS.DEBITOS%TYPE;
  --
  ind_utd NUMBER := 0;
  ind_dif NUMBER := 0;
  --
  UltimaLinea          ARCGAL.no_linea%TYPE;
  Mod_Diferencial      BOOLEAN := FALSE;
  cuentaConPresupuesto BOOLEAN;
  Afecta_dist_cc       BOOLEAN := FALSE;
  --
  vAfecto_utilidades BOOLEAN;
  vindicador_util    arcgmc.indicador_utilidad%TYPE;
  --
  CURSOR c_ind_utilidades IS
    SELECT indicador_utilidad
      FROM arcgmc
     WHERE no_cia = pnumCia;
  --
  CURSOR c_Asiento IS
    SELECT no_asiento,
           fecha,
           cod_diario,
           origen,
           ano,
           mes,
           impreso,
           descri1,
           estado,
           autorizado,
           t_debitos,
           t_creditos,
           ROWID,
           t_camb_c_v,
           tipo_cambio,
           tipo_comprobante,
           no_comprobante,
           numero_ctrl,
           a.usuario_creacion,
           a.fecha_ingresa,
           a.usuario_modifica,
           a.fecha_modifica
      FROM arcgae a
     WHERE no_cia = pNumCia
       AND no_asiento = pNum_asiento
       AND estado = 'P'
       AND anulado = 'N'
       AND autorizado = 'S';
  --
  CURSOR c_lineas_Asiento(pno_asiento VARCHAR2) IS
    SELECT AL.cuenta,
           AL.cc_1,
           AL.cc_2,
           AL.cc_3,
           AL.no_linea,
           AL.no_docu,
           AL.monto,
           AL.monto_dol,
           AL.tipo,
           AL.descri,
           MS.clase,
           AL.moneda,
           AL.tipo_cambio,
           MS.IND_PRESUP,
           MS.moneda Moneda_Cta,
           al.codigo_tercero,
           al.usuario_ingresa,
           al.fecha_ingresa,
           al.usuario_modifica,
           al.fecha_modifica,
           al.no_distribucion
      FROM arcgms MS,
           arcgal AL
     WHERE AL.no_cia = pNumCia
       AND no_asiento = pno_asiento
       AND MS.no_cia = AL.no_cia
       AND MS.cuenta = AL.cuenta;
  --
  ae c_asiento%ROWTYPE;
  --
BEGIN
  
                     CGMayoriza_Asiento@Gpoetnet(pNumCia,
                                                 pNum_Asiento,
                                                 pCta_Nominal,
                                                 pCta_Dolares,
                                                 pAc_db,
                                                 pAc_DbDol,
                                                 pAc_Cr,
                                                 pAc_CrDol,
                                                 pCont_Lin,
                                                 pmsg_error);
EXCEPTION
  WHEN error_proceso THEN
    pmsg_error := NVL(pmsg_error, 'CGmayoriza_asiento');
  WHEN OTHERS THEN
    pmsg_error := NVL(SQLERRM, 'CGmayoriza_asiento');
END;
