CREATE OR REPLACE PACKAGE NAF47_TNET.ARCP_CONSULTA IS 

 /**
  * Documentación para NAF47_TNET.ARCP_CONSULTA
  * Paquete que contiene procedimiento para consulta de documentos por pagar
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 28/12/2020 
  */

   /**
  * Documentación para Gt_PagosHist
  * Tabla tipo record que contiene campos de documentos por pagar
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 28/12/2020
  */

TYPE Gt_PagosHist
IS
  RECORD (
    TIPO_DOC     NAF47_TNET.ARCPMD.TIPO_DOC%TYPE,
    NO_DOCU      NAF47_TNET.ARCPMD.NO_DOCU%TYPE,
    NO_PROVE   NAF47_TNET.ARCPMD.NO_PROVE%TYPE,
    NOMBRE       NAF47_TNET.ARCPMP.NOMBRE%TYPE,
    DESCRIPCION  VARCHAR2(200),
    NO_FISICO    NAF47_TNET.ARCPMD.NO_FISICO%TYPE,
    SERIE_FISICO NAF47_TNET.ARCPMD.SERIE_FISICO%TYPE,
    FECHA        NAF47_TNET.ARCPMD.FECHA%TYPE,  
    M_ORIGINAL   NAF47_TNET.ARCPMD.MONTO%TYPE,
    GRAVADO      NAF47_TNET.ARCPMD.GRAVADO%TYPE,
    TOT_IMP      NAF47_TNET.ARCPMD.TOT_IMP%TYPE,
    EXENTO       NAF47_TNET.ARCPMD.TOT_IMP%TYPE,
    TIPO_DOC_P   NAF47_TNET.ARCPRD.TIPO_DOC%TYPE,
    DOCUMENTO_P  NAF47_TNET.ARCPRD.NO_DOCU%TYPE,
    MONTO        NAF47_TNET.ARCPMD.MONTO%TYPE,
    TOT_RET      NAF47_TNET.ARCPMD.TOT_RET%TYPE,
    CHEQUE       NAF47_TNET.ARCKCE.CHEQUE%TYPE,
    SALDO        NAF47_TNET.ARCPMD.SALDO%TYPE,
    DIAS_VENCIDO NUMBER,
    FEC_APLIC    NAF47_TNET.ARCPRD.FEC_APLIC%TYPE,
    SALDO_ACTUAL NAF47_TNET.ARCPMD.SALDO%TYPE,
    SALDO_FINAL  NAF47_TNET.ARCPMD.SALDO%TYPE
    );

  TYPE Lt_PagosHist IS TABLE OF Gt_PagosHist  
        INDEX BY BINARY_INTEGER; 

 /**
  * Documentación para PRC_CONSULTA_HIST_CORTE_CP
  * Procedimiento de documentos pendiente de pago a fecha corte
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 28/12/2020
  *
  * Documentación para PRC_CONSULTA_HIST_CORTE_CP
  * Se sumarizan valores de Pago
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.1 12/04/2021
  * 
  * @param Pn_Cia        NAF47_TNET.ARCPMD.NO_CIA%TYPE Compania a consultar
  * @param Pd_FechaCorte DATE Fecha de corte
  * @param Pv_Prove      NAF47_TNET.ARCPMD.NO_PROVE%TYPE Proveedor
  * @param Pt_PagosHist  OUT Lt_PagosHist Fecha de corte  Registro de documentos por pagar
  * @param Pv_Error      OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */
 PROCEDURE PRC_CONSULTA_HIST_CORTE_CP(Pn_Cia        NAF47_TNET.ARCPMD.NO_CIA%TYPE, 
                                        Pd_FechaCorte DATE,
                                        Pv_PROVE    NAF47_TNET.ARCPMD.NO_PROVE%TYPE,
                                        Pt_PagosHist OUT Lt_PagosHist,
                                        Pv_error      OUT VARCHAR);



END ARCP_CONSULTA;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.ARCP_CONSULTA IS

PROCEDURE PRC_CONSULTA_HIST_CORTE_CP(Pn_Cia        NAF47_TNET.ARCPMD.NO_CIA%TYPE, 
                                     Pd_FechaCorte DATE,
                                     Pv_PROVE    NAF47_TNET.ARCPMD.NO_PROVE%TYPE,
                                     Pt_PagosHist OUT Lt_PagosHist,
                                     Pv_error      OUT VARCHAR) IS
      CURSOR C_HISTORICO_CORTE IS
      SELECT * FROM( SELECT MD.NO_CIA,
       MD.TIPO_DOC ,
       MD.NO_DOCU ,
       MD.NO_PROVE,
       MP.NOMBRE,
       MD.NO_FISICO ,
       MD.SERIE_FISICO,
       MD.FECHA ,  
       MD.MONTO M_ORIGINAL,
       MD.GRAVADO ,
       MD.TOT_IMP ,
       MD.EXCENTOS ,
       SUM (RD.MONTO) MONTO,
       MD.SALDO,
       Pd_FechaCorte - TRUNC(MD.FECHA_VENCE_ORIGINAL) DIAS_VENCIDO,
       NVL( MD.MONTO-  (SELECT SUM(MONTO) FROM NAF47_TNET.ARCPRD
                        WHERE NO_CIA=MD.NO_CIA
                        AND NO_REFE=MD.NO_DOCU
                        AND FEC_APLIC<=Pd_FechaCorte),MD.MONTO)SALDO_FINAL
	FROM NAF47_TNET.ARCPMD MD, NAF47_TNET.ARCPRD RD, NAF47_TNET.ARCPMP MP, NAF47_TNET.ARCPMS MS, NAF47_TNET.ARCKRD CK, NAF47_TNET.ARCKCE CE
	WHERE  MD.NO_CIA=MP.NO_CIA
	AND MD.NO_PROVE=MP.NO_PROVE
	AND MD.NO_CIA=MS.NO_CIA
	AND MD.NO_PROVE=MS.NO_PROVE
    AND MD.NO_CIA=RD.NO_CIA(+)
	AND MD.NO_DOCU=RD.NO_REFE(+)
    AND Pd_FechaCorte>=RD.FEC_APLIC(+)
	AND RD.NO_CIA=CK.NO_CIA(+)
    AND RD.NO_DOCU=CK.NO_SECUENCIA(+)
    AND RD.NO_REFE=CK.NO_REFE(+)
    AND CK.NO_CIA=CE.NO_CIA(+)
    AND CK.NO_SECUENCIA=CE.NO_SECUENCIA(+)
    AND CK.TIPO_DOCU=CE.TIPO_DOCU(+)
	AND MD.NO_CIA=Pn_Cia
    AND MD.NO_PROVE=NVL(Pv_PROVE, MD.NO_PROVE)
    AND MD.TIPO_DOC IN (SELECT TIPO_DOC FROM NAF47_TNET.ARCPTD TD
                          WHERE TD.NO_CIA= MD.NO_CIA 
                          AND TD.TIPO_DOC=MD.TIPO_DOC
                          AND TD.TIPO_MOV='C'  )
    AND MD.FECHA <=NVL(Pd_FechaCorte,MD.FECHA)
    GROUP BY
    MD.NO_CIA,
    MD.TIPO_DOC ,
    MD.NO_DOCU ,
    MD.NO_PROVE,
    MP.NOMBRE,
    MD.NO_FISICO ,
    MD.SERIE_FISICO,
    MD.FECHA ,  
    MD.MONTO ,
    MD.GRAVADO ,
    MD.TOT_IMP ,
    MD.EXCENTOS ,
    MD.TOT_RET,
    MD.SALDO,
    Pd_FechaCorte - TRUNC(MD.FECHA_VENCE_ORIGINAL) )
    WHERE  SALDO_FINAL>0
    ORDER BY NO_PROVE,NO_DOCU,FECHA;

     Ln_Cont NUMBER:=0;
     BEGIN
     FOR CR_HISTORICO_CORTE IN C_HISTORICO_CORTE LOOP
       Ln_Cont:=Ln_Cont+1;
       Pt_PagosHist(Ln_Cont).TIPO_DOC     :=CR_HISTORICO_CORTE.TIPO_DOC;
       Pt_PagosHist(Ln_Cont).NO_DOCU      :=CR_HISTORICO_CORTE.NO_DOCU;
       Pt_PagosHist(Ln_Cont).NO_PROVE     :=CR_HISTORICO_CORTE.NO_PROVE;
       Pt_PagosHist(Ln_Cont).NOMBRE       :=CR_HISTORICO_CORTE.NOMBRE;
       Pt_PagosHist(Ln_Cont).NO_FISICO    :=CR_HISTORICO_CORTE.NO_FISICO;
       Pt_PagosHist(Ln_Cont).SERIE_FISICO :=CR_HISTORICO_CORTE.SERIE_FISICO;
       Pt_PagosHist(Ln_Cont).FECHA        :=CR_HISTORICO_CORTE.FECHA;  
       Pt_PagosHist(Ln_Cont).M_ORIGINAL   :=CR_HISTORICO_CORTE.M_ORIGINAL;
       Pt_PagosHist(Ln_Cont).GRAVADO      :=CR_HISTORICO_CORTE.GRAVADO;
       Pt_PagosHist(Ln_Cont).TOT_IMP      :=CR_HISTORICO_CORTE.TOT_IMP;
       Pt_PagosHist(Ln_Cont).EXENTO       :=CR_HISTORICO_CORTE.EXCENTOS;
       Pt_PagosHist(Ln_Cont).MONTO        :=CR_HISTORICO_CORTE.MONTO;
       Pt_PagosHist(Ln_Cont).SALDO        :=CR_HISTORICO_CORTE.SALDO;
       Pt_PagosHist(Ln_Cont).DIAS_VENCIDO :=CR_HISTORICO_CORTE.DIAS_VENCIDO;
       Pt_PagosHist(Ln_Cont).SALDO_FINAL  :=CR_HISTORICO_CORTE.SALDO_FINAL;
     END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_error:='error en PRC_CONSULTA_HIST_CORTE_CP: '||SQLERRM;
  END PRC_CONSULTA_HIST_CORTE_CP;

END ARCP_CONSULTA;
/