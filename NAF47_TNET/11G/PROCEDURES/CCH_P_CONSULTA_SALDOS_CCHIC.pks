create or replace PROCEDURE            CCH_P_CONSULTA_SALDOS_CCHIC(Pv_Cia           IN VARCHAR2,
                                                        Pv_CodCaja       IN VARCHAR2,
                                                        Pn_CompNominalMC IN OUT NUMBER,
                                                        Pn_TotalCompMM   IN OUT NUMBER,
                                                        Pn_TotalMontoDD  IN OUT NUMBER,
                                                        Pn_TotalMontoDC  IN OUT NUMBER, 
                                                        Pn_CompNominalHS IN OUT NUMBER)
                                                        IS
      
   
BEGIN
                                                             
SELECT COMPROBANTE_NOMINAL INTO Pn_CompNominalMC
FROM TAFFMC 
WHERE NO_CIA = Pv_Cia AND COD_CAJA = Pv_CodCaja;
---
SELECT SUM(MONTO_NOM) INTO Pn_TotalCompMM 
FROM TAFFMM  
WHERE NO_CIA = Pv_Cia
AND COD_CAJA = Pv_CodCaja AND TIPO_MOV = 'CO';
---
SELECT SUM(MONTO) INTO Pn_TotalMontoDD
FROM TAFFDD
WHERE NO_CIA = Pv_Cia
AND TRANSA_ID IN 
            (SELECT TRANSA_ID 
             FROM TAFFMM 
             WHERE NO_CIA = Pv_Cia 
             AND COD_CAJA = Pv_CodCaja AND TIPO_MOV = 'CO');
---
SELECT SUM(MONTO) INTO Pn_TotalMontoDC
FROM TAFFDC
WHERE NO_CIA = Pv_Cia 
AND TRANSA_ID IN 
            (SELECT TRANSA_ID 
             FROM TAFFMM 
             WHERE NO_CIA = Pv_Cia 
             AND COD_CAJA = Pv_CodCaja AND TIPO_MOV='CO' )
AND NATURALEZA = 'C';
---
SELECT SUM(COMPROBANTE_NOMINAL) INTO Pn_CompNominalHS
FROM TAFFHS
WHERE COD_CAJA = Pv_CodCaja;
--

END CCH_P_CONSULTA_SALDOS_CCHIC;