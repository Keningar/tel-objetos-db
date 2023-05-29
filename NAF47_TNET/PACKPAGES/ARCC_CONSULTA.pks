CREATE OR REPLACE PACKAGE NAF47_TNET.ARCC_CONSULTA IS 

 /**
  * Documentación para NAF47_TNET.ARCC_CONSULTA
  * Paquete que contiene procedimiento para consulta de documentos por cobrar
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 05/12/2020 
  */

  /**
  * Documentación para Gt_CobrosHist
  * Tabla tipo record que contiene campos de documentos por cobrar
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 05/12/2020
  */

TYPE Gt_CobrosHist
IS
  RECORD (
    TIPO_DOC     NAF47_TNET.ARCCMD.TIPO_DOC%TYPE,
    NO_DOCU      NAF47_TNET.ARCCMD.NO_DOCU%TYPE,
    NO_CLIENTE   NAF47_TNET.ARCCMD.NO_CLIENTE%TYPE,
    NOMBRE       NAF47_TNET.ARCCMC.NOMBRE%TYPE,
    DESCRIPCION  VARCHAR2(200),
    NO_FISICO    NAF47_TNET.ARCCMD.NO_FISICO%TYPE,
    SERIE_FISICO NAF47_TNET.ARCCMD.SERIE_FISICO%TYPE,
    FECHA        NAF47_TNET.ARCCMD.FECHA%TYPE,  
    M_ORIGINAL   NAF47_TNET.ARCCMD.M_ORIGINAL%TYPE,
    GRAVADO      NAF47_TNET.ARCCMD.GRAVADO%TYPE,
    TOT_IMP      NAF47_TNET.ARCCMD.TOT_IMP%TYPE,
    EXENTO       NAF47_TNET.ARCCMD.TOT_IMP%TYPE,
    TIPO_DOC_C   NAF47_TNET.ARCCMD.TIPO_DOC%TYPE,
    MONTO        NAF47_TNET.ARCCMD.M_ORIGINAL%TYPE,
    TOT_RET      NAF47_TNET.ARCCMD.TOT_RET%TYPE,
    SALDO        NAF47_TNET.ARCCMD.SALDO%TYPE,
    DIAS_VENCIDO NUMBER,
    FEC_APLIC    NAF47_TNET.ARCCRD.FEC_APLIC%TYPE,
    SALDO_ACTUAL NAF47_TNET.ARCCMD.SALDO%TYPE,
    SALDO_FINAL  NAF47_TNET.ARCCMD.SALDO%TYPE
    );

  TYPE Lt_CobrosHist IS TABLE OF Gt_CobrosHist  
        INDEX BY BINARY_INTEGER; 


 /**
  * Documentación para PRC_CONSULTA_HISTORICO_CORTE
  * Procedimiento de documentos pendiente de cobro a fecha corte
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 05/12/2020
  * 
  * @param Pn_Cia        NAF47_TNET.ARCCMD.NO_CIA%TYPE Compania a consultar
  * @param Pd_FechaCorte DATE Fecha de corte
  * @param Pv_cliente    NAF47_TNET.ARCCMD.NO_CLIENTE%TYPE Cliente
  * @param Pv_Grupo      NAF47_TNET.ARCCMD.GRUPO%TYPE Grupo del cliente
  * @param Pt_CobrosHist OUT Lt_CobrosHist Fecha de corte  Registro de documentos por cobrar
  * @param Pv_Error     OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */
 PROCEDURE PRC_CONSULTA_HISTORICO_CORTE(Pn_Cia        NAF47_TNET.ARCCMD.NO_CIA%TYPE, 
                                        Pd_FechaCorte DATE,
                                        Pv_cliente    NAF47_TNET.ARCCMD.NO_CLIENTE%TYPE,
                                        Pv_Grupo       NAF47_TNET.ARCCMD.GRUPO%TYPE,
                                        Pt_CobrosHist OUT Lt_CobrosHist,
                                        Pv_error      OUT VARCHAR);



END ARCC_CONSULTA;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.ARCC_CONSULTA IS

PROCEDURE PRC_CONSULTA_HISTORICO_CORTE(Pn_Cia        NAF47_TNET.ARCCMD.NO_CIA%TYPE, 
                                        Pd_FechaCorte DATE,
                                        Pv_cliente    NAF47_TNET.ARCCMD.NO_CLIENTE%TYPE,
                                        Pv_Grupo       NAF47_TNET.ARCCMD.GRUPO%TYPE,
                                        Pt_CobrosHist OUT Lt_CobrosHist,
                                        Pv_error      OUT VARCHAR) IS
      CURSOR C_HISTORICO_CORTE IS
      SELECT * FROM( SELECT MD.NO_CIA,
                       MD.TIPO_DOC ,
                       MD.NO_DOCU ,
                       MD.NO_CLIENTE,
                       MC.NOMBRE,
                       GR.DESCRIPCION,
                       MD.NO_FISICO ,
                       MD.SERIE_FISICO,
                       MD.FECHA ,  
                       MD.M_ORIGINAL,
                       MD.GRAVADO ,
                       MD.TOT_IMP ,
                       MD.EXENTO ,
                       RD.TIPO_DOC TIPO_DOC_C ,
                       SUM(RD.MONTO) MONTO,
                       SUM(MDD.TOT_RET)TOT_RET,
                        MD.SALDO SALDO,
                       DECODE (MD.SALDO,0,0,TRUNC(SYSDATE) - TRUNC(MD.FECHA_VENCE_ORIGINAL) )DIAS_VENCIDO,
                       RD.FEC_APLIC,
                       NVL( MD.M_ORIGINAL-
                       (SELECT SUM(MONTO) FROM NAF47_TNET.ARCCRD
                        WHERE NO_CIA=MD.NO_CIA
                        AND NO_REFE=MD.NO_DOCU
                        AND FEC_APLIC<RD.FEC_APLIC),MD.M_ORIGINAL)SALDO_ACTUAL,
                       NVL( MD.M_ORIGINAL-
                       (SELECT SUM(MONTO) FROM NAF47_TNET.ARCCRD
                        WHERE NO_CIA=MD.NO_CIA
                        AND NO_REFE=MD.NO_DOCU
                        AND FEC_APLIC<=Pd_FechaCorte),MD.M_ORIGINAL)SALDO_FINAL
                    FROM NAF47_TNET.ARCCMD MD, NAF47_TNET.ARCCRD RD, NAF47_TNET.ARCCMC MC,ARCCMS MS,NAF47_TNET.ARCCMD MDD,NAF47_TNET.ARCCGR GR
                    WHERE  MD.NO_CIA=MC.NO_CIA
                    AND MD.GRUPO=MC.GRUPO
                    AND MD.NO_CLIENTE=MC.NO_CLIENTE
                    AND MD.NO_CIA=GR.NO_CIA
                    AND MD.GRUPO=GR.GRUPO
                    AND MS.NO_CIA = MD.NO_CIA
                    AND MS.GRUPO = MD.GRUPO
                    AND MS.NO_CLIENTE =  MD.NO_CLIENTE
                    AND MD.NO_CIA=RD.NO_CIA(+)
                    AND MD.NO_DOCU=RD.NO_REFE(+)
                    AND Pd_FechaCorte>=RD.FEC_APLIC(+)
                    AND RD.NO_CIA=MDD.NO_CIA(+)
                    AND RD.NO_DOCU=MDD.NO_DOCU(+)
                    AND MD.NO_CIA=Pn_Cia
                    AND MD.NO_CLIENTE=NVL(Pv_cliente,MD.NO_CLIENTE)
                    AND MD.GRUPO=NVL(Pv_Grupo,MD.GRUPO)
                    AND MD.TIPO_DOC IN (SELECT TIPO FROM NAF47_TNET.ARCCTD TD
                                        WHERE TD.NO_CIA= MD.NO_CIA 
                                          AND TD.TIPO=MD.TIPO_DOC
                                          AND TD.TIPO_MOV='D'  )
                                    
                AND MD.FECHA <=Pd_FechaCorte
                GROUP BY  MD.NO_CIA,
                           MD.TIPO_DOC ,
                           MD.NO_DOCU ,
                           MD.NO_CLIENTE,
                           MC.NOMBRE,
                           GR.DESCRIPCION,
                           MD.NO_FISICO ,
                           MD.SERIE_FISICO,
                           MD.FECHA ,  
                           MD.M_ORIGINAL,
                           MD.GRAVADO ,
                           MD.TOT_IMP ,
                           MD.EXENTO ,
                           RD.TIPO_DOC ,
                            MD.SALDO,
                           DECODE (MD.SALDO,0,0,TRUNC(SYSDATE) - TRUNC(MD.FECHA_VENCE_ORIGINAL) ) ,
                           RD.FEC_APLIC
                  )
      WHERE  SALDO_FINAL>0
      ORDER BY NO_DOCU,FECHA,FEC_APLIC ;
      Ln_Cont NUMBER:=0;
     BEGIN
     FOR CR_HISTORICO_CORTE IN C_HISTORICO_CORTE LOOP
       Ln_Cont:=Ln_Cont+1;
       Pt_CobrosHist(Ln_Cont).TIPO_DOC     :=CR_HISTORICO_CORTE.TIPO_DOC;
       Pt_CobrosHist(Ln_Cont).NO_DOCU      :=CR_HISTORICO_CORTE.NO_DOCU;
       Pt_CobrosHist(Ln_Cont).NO_CLIENTE   :=CR_HISTORICO_CORTE.NO_CLIENTE;
       Pt_CobrosHist(Ln_Cont).NOMBRE       :=CR_HISTORICO_CORTE.NOMBRE;
       Pt_CobrosHist(Ln_Cont).DESCRIPCION  :=CR_HISTORICO_CORTE.DESCRIPCION;
       Pt_CobrosHist(Ln_Cont).NO_FISICO    :=CR_HISTORICO_CORTE.NO_FISICO;
       Pt_CobrosHist(Ln_Cont).SERIE_FISICO :=CR_HISTORICO_CORTE.SERIE_FISICO;
       Pt_CobrosHist(Ln_Cont).FECHA        :=CR_HISTORICO_CORTE.FECHA;  
       Pt_CobrosHist(Ln_Cont).M_ORIGINAL   :=CR_HISTORICO_CORTE.M_ORIGINAL;
       Pt_CobrosHist(Ln_Cont).GRAVADO      :=CR_HISTORICO_CORTE.GRAVADO;
       Pt_CobrosHist(Ln_Cont).TOT_IMP      :=CR_HISTORICO_CORTE.TOT_IMP;
       Pt_CobrosHist(Ln_Cont).EXENTO       :=CR_HISTORICO_CORTE.EXENTO;
       Pt_CobrosHist(Ln_Cont).TIPO_DOC_C   :=CR_HISTORICO_CORTE.TIPO_DOC_C;
       Pt_CobrosHist(Ln_Cont).MONTO        :=CR_HISTORICO_CORTE.MONTO;
       Pt_CobrosHist(Ln_Cont).TOT_RET      :=CR_HISTORICO_CORTE.TOT_RET;
       Pt_CobrosHist(Ln_Cont).SALDO        :=CR_HISTORICO_CORTE.SALDO;
       Pt_CobrosHist(Ln_Cont).DIAS_VENCIDO :=CR_HISTORICO_CORTE.DIAS_VENCIDO;
       Pt_CobrosHist(Ln_Cont).FEC_APLIC    :=CR_HISTORICO_CORTE.FEC_APLIC;
       Pt_CobrosHist(Ln_Cont).SALDO_ACTUAL :=CR_HISTORICO_CORTE.SALDO_ACTUAL;
       Pt_CobrosHist(Ln_Cont).SALDO_FINAL    :=CR_HISTORICO_CORTE.SALDO_FINAL;
     END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_error:='error en PRC_CONSULTA_HISTORICO_CORTE: '||SQLERRM;
  END PRC_CONSULTA_HISTORICO_CORTE;

END ARCC_CONSULTA;
/