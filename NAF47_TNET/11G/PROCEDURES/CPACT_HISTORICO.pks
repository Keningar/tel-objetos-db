create or replace PROCEDURE            CPACT_HISTORICO
 (PCIA IN VARCHAR2
 ,PPROVE IN VARCHAR2
 ,PFECHA IN DATE
 ,PMONTO IN NUMBER
 ,PTIPO IN VARCHAR2
 ,PMES_PROC IN NUMBER
 ,PANO_PROC IN NUMBER
 ,PMONEDA IN VARCHAR2
 )
 IS
-- PL/SQL Block
vMes_Doc  NUMBER(2);
vAno_Doc  NUMBER(4);
--
V_ANO NUMBER(4);
V_MES NUMBER(4);
BEGIN
   vMes_Doc := TO_NUMBER(TO_CHAR(pFecha, 'MM'));
   vAno_Doc := TO_NUMBER(TO_CHAR(pFecha, 'RRRR'));
   -- Actualiza el saldo anterior del mes en proceso
   UPDATE ARCPMP
      SET SAL_ANT = NVL(SAL_ANT,0) + decode(pTipo, 'C', NVL(pMONTO,0), -NVL(pmonto,0))
    WHERE NO_CIA   = pCia
      AND NO_PROVE = pPROVE;

   -- saldo actual en tabla de proveedores
  UPDATE arcpms
	   SET saldo_actual = nvl(saldo_actual,0) + decode(pTipo, 'C', nvl(pMonto,0), -nvl(pMonto,0))
   WHERE no_cia   = pCia
     AND no_prove = pProve
     AND moneda   = pMoneda;
   
   UPDATE ARCPSA
      SET SALDO = SALDO  
                + decode(pTipo, 'C', NVL(pMONTO,0), 0) 
                - decode(pTipo, 'D', NVL(pMONTO,0), 0),
          CREDITOS = NVL(CREDITOS,0) + decode(pTipo, 'C', NVL(pMONTO,0), 0),
          DEBITOS  = NVL(DEBITOS,0)  + decode(pTipo, 'D', NVL(pMONTO,0), 0)
    WHERE NO_CIA   = pCia
      AND NO_PROVE = pProve
      AND ANO      = vAno_Doc
      AND MES      = vMes_Doc;
   IF SQL%NOTFOUND THEN
      INSERT INTO ARCPSA
            (NO_CIA,    NO_PROVE, ANO, MES,
             SALDO_ANT, DEBITOS,  CREDITOS, 
             SALDO)
      VALUES
            (pCIA, pPROVE, vAno_Doc, vMes_Doc,
             0, decode(pTipo, 'D', pMONTO, 0), decode(pTipo, 'C', pMONTO, 0),
             pMONTO*decode(pTipo, 'D', -1, 1));
   END IF;
   -- Actualiza el saldo anterior en los meses posteriores al que se actualiza
   -- hasta el anterior al mes en proceso.
      V_ANO := vAno_Doc;
      V_MES := vMes_Doc;
      LOOP
         IF V_MES = 12 THEN
            V_MES := 1;
            V_ANO := V_ANO + 1;
         ELSE
            V_MES := V_MES + 1;
         END IF;
         EXIT WHEN V_ANO = pANO_PROC AND V_MES = pMES_PROC;
         UPDATE ARCPSA
            SET SALDO_ANT = NVL(SALDO_ANT,0) + pMONTO*decode(pTipo, 'D', -1, 1), --NVL(pMONTO,0)
                SALDO = NVL(SALDO,0) + pMONTO*decode(pTipo, 'D', -1, 1)
          WHERE NO_CIA   = pCia
            AND NO_PROVE = pPROVE
            AND ANO      = V_ANO
            AND MES      = V_MES;
         IF SQL%NOTFOUND THEN
            -- Inserta el registro en el historico de saldos
            INSERT INTO ARCPSA
                  (NO_CIA, NO_PROVE, ANO, MES,
                   SALDO_ANT, DEBITOS, CREDITOS,
                   SALDO)
            VALUES
                  (pCIA,pPROVE,V_ANO,V_MES,
                   pMONTO*decode(pTipo, 'D', -1, 1), 0, 0, --pMONTO,0,0); 
                   pMONTO*decode(pTipo, 'D', -1, 1)); 
         END IF;
      END LOOP;
END CPACT_HISTORICO;