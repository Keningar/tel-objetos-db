CREATE OR REPLACE PACKAGE            CKK_PROCESOS IS

  PROCEDURE P_INSERTA_ARCK_CECL (Pv_NoCia   IN  Varchar2,
                                 Pv_TipoDoc IN  Varchar2,
                                 Pv_NoDocu  IN  Varchar2,
                                 Pv_NumeroCtrl OUT Varchar2,
                                 Pv_Mensaje OUT Varchar2);

END CKK_PROCESOS;
/


CREATE OR REPLACE PACKAGE BODY            CKK_PROCESOS IS
/**
* Documentacion para el procedimiento P_INSERTA_ARCK_CECL
* Procedimiento que realiza la insercion en las estructuras ARCKCE, ARCKML
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 14-10-2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 18-09-2017 Se modifica para hacer uso del nuevo pk de la tabla migracion (No_Cia, Id_Migracion)
*/

  PROCEDURE P_INSERTA_ARCK_CECL(Pv_NoCia  IN  Varchar2,
                                Pv_TipoDoc IN  Varchar2,
                                Pv_NoDocu  IN  Varchar2,
                                Pv_NumeroCtrl OUT Varchar2,
                                Pv_Mensaje OUT Varchar2)  IS

  CURSOR C_CABECERA IS
   SELECT * FROM MIGRA_ARCKMM
   WHERE NO_CIA = Pv_NoCia
     AND TIPO_DOC = Pv_TipoDoc
     AND ID_MIGRACION = Pv_NoDocu
     ;

  CURSOR C_DETALLE IS
   SELECT * FROM MIGRA_ARCKML
   WHERE NO_CIA = Pv_NoCia
     AND TIPO_DOC = Pv_TipoDoc
     AND MIGRACION_ID= Pv_NoDocu
--     AND NO_DOCU = Pv_NoDocu
     ;

  CURSOR C_BANCO(Cv_NoCta Varchar2) IS
   SELECT NO_CIA, NO_CUENTA, ANO_PROC, MES_PROC,
          TO_DATE(TO_CHAR(ANO_PROC)||TO_CHAR(MES_PROC),'YYYYMM') 
     FROM ARCKMC
     WHERE NO_CIA = Pv_NoCia 
       AND  NO_CTA = Cv_NoCta;

  Lv_NoDocu      ARCKCE.NO_SECUENCIA%TYPE;
  Lv_TipoTransfe ARCKCE.TIPO_TRANSFE%TYPE;
  Lv_Emitido     ARCKCE.EMITIDO%TYPE;
  Lv_Cheque      ARCKCE.CHEQUE%TYPE;
  Lv_TasaCambio  ARPLCP.TC_CALCULO%TYPE;
  Lv_TCamb       ARCKCE.T_CAMB_C_V%TYPE;
  Lr_Cabecera    C_CABECERA%ROWTYPE:=NULL;
  Lr_Bancos      C_BANCO%ROWTYPE:=NULL;
  Lv_Autoriza    ARCKCE.AUTORIZA%TYPE;
  Ld_FechaVence  ARCKCE.FECHA_VENCE%TYPE;
  Ln_Contador number:=0;

  BEGIN
    Lv_NoDocu:= transa_id.ck(Pv_NoCia); 
    Lv_Emitido := 'N' ;
    Lv_TasaCambio:= '1';
    Lv_TCamb:= 'V';
    Lv_Autoriza:= 'N';

    IF C_CABECERA%ISOPEN THEN CLOSE C_CABECERA; END IF;
    OPEN C_CABECERA;
    FETCH C_CABECERA INTO Lr_Cabecera;
    CLOSE C_CABECERA;

    IF C_DETALLE%ISOPEN THEN CLOSE C_DETALLE; END IF;

    Ld_FechaVence := Lr_Cabecera.Fecha + 360;

    IF C_BANCO%ISOPEN THEN CLOSE C_BANCO; END IF;
    OPEN C_BANCO(Lr_Cabecera.No_Cta);
    FETCH C_BANCO INTO Lr_Bancos;
    CLOSE C_BANCO;

    IF Lr_Cabecera.Tipo_Doc = 'TR' THEN
      Lv_TipoTransfe:='U';
      Lv_Cheque := consecutivo.ck(Lr_Cabecera.No_Cia,
                                  Lr_Bancos.Ano_Proc,
                                  Lr_Bancos.Mes_Proc,
                                  Lr_Cabecera.No_Cta,
                                  Lr_Cabecera.Tipo_Doc,
                                  'NUMERO');   

    ELSIF Lr_Cabecera.Tipo_Doc = 'CK' THEN
      Lv_TipoTransfe:= '';
    END IF;
    Pv_NumeroCtrl:=Lv_NoDocu;
    INSERT INTO ARCKCE(NO_CIA,      NO_CTA,      TIPO_DOCU,    NO_SECUENCIA, 
                       CHEQUE,      FECHA,       MONTO,        BENEFICIARIO, 
                       IND_ACT,     IND_CON,     EMITIDO,      SALDO,
                       MONEDA_CTA,  MONEDA_PAGO, TIPO_CAMBIO,  TOT_DB,
                       TOT_CR,      AUTORIZA,    ORIGEN,       T_CAMB_C_V,   
                       FECHA_VENCE, COM,         TIPO_TRANSFE, USUARIO_CREACION,
                       NUMERO_CTRL)

               VALUES( Pv_NoCia,    Lr_Cabecera.No_Cta, Lr_Cabecera.Tipo_Doc, Lv_NoDocu, 
                       Lv_Cheque,   TO_DATE(Lr_Cabecera.Fecha,'DD-MM-YYYY') ,  Lr_Cabecera.Monto, Lr_Cabecera.Beneficiario,
                       'P',         'P',         Lv_Emitido,        0,
                       'P',         'P',         Lv_TasaCambio,     Lr_Cabecera.Monto, 
                       Lr_Cabecera.Monto,      Lv_Autoriza,   'PL',            Lv_TCamb,
                       TO_DATE(Ld_FechaVence,'DD-MM-YYYY'), Lr_Cabecera.Comentario, Lv_TipoTransfe, Lr_Cabecera.Usuario_Creacion,
                       Lr_Cabecera.Id_Migracion);

    FOR I IN C_DETALLE LOOP

      INSERT INTO ARCKCL(NO_CIA, TIPO_DOCU, NO_SECUENCIA,  
                         COD_CONT, CENTRO_COSTO, TIPO_MOV, MONTO, MONTO_DOL, MONEDA, 
                         TIPO_CAMBIO,MONTO_DC, GLOSA)

                  VALUES(I.NO_CIA, I.TIPO_DOC, Lv_NoDocu,
                         I.COD_CONT,I.CENTRO_COSTO,I.TIPO_MOV, I.MONTO, I.MONTO_DOL, 'P', 
                         Lv_TasaCambio,I.MONTO, substr(I.GLOSA,1,100));
                         Ln_Contador := Ln_Contador+1;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Error: '|| Ln_Contador;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF', 
                                           'CKK_PROCESOS.P_INSERTA_ARCK_CECL', 
                                           'Error- P_INSERTA_ARCK_CECL: '||SQLERRM,
                                            USER,
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                            '127.0.0.1'));
      ROLLBACK;  
  END P_INSERTA_ARCK_CECL;
END CKK_PROCESOS;
/
