create or replace PROCEDURE            CGAplicar_Terceros (
   pCia           in varchar2,
   pCta           in varchar2,
   pTercero       in varchar2,
   pMto           in number,
   pMto_Dol       in number,
   pAno           in number,
   pMes           in number,
   pTipo          in varchar2,
   pmsg_error     in out varchar2
) IS
BEGIN
   UPDATE ARCGHC_T
      SET Mov_Db     = NVL(Mov_Db,0)     + decode(pTipo, 'D', nvl(pMto,0), 0),
          Mov_Cr     = NVL(Mov_Cr,0)     + decode(pTipo, 'C', nvl(pMto,0), 0),
          Mov_Db_Dol = NVL(Mov_Db_Dol,0) + decode(pTipo, 'D', nvl(pMto_Dol,0), 0),
          Mov_Cr_Dol = NVL(Mov_Cr_Dol,0) + decode(pTipo, 'C', nvl(pMto_Dol,0), 0),
          Movimiento = NVL(Movimiento,0) + nvl(pMto,0),
          Saldo      = NVL(Saldo,0)      + nvl(pMto,0),
          Saldo_Dol  = NVL(Saldo_Dol,0)  + nvl(pMto_Dol, 0)
    WHERE no_cia         = pCia
      AND cuenta         = pCta
      AND codigo_tercero = pTercero
      AND Ano            = pAno
      AND Mes            = pMes;
   --
   IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO ARCGHC_T (NO_CIA,     ANO,            MES,        PERIODO,
                            CUENTA,     CODIGO_TERCERO, MOVIMIENTO,
                            MOV_DB,
                            MOV_CR,     SALDO,
                            MOV_DB_DOL,
                            MOV_CR_DOL, SALDO_DOL)
                    VALUES (pCia,      pAno,          pMes,         pAno*100+pMes,
                            pCta,      pTercero,      nvl(pMto,0),
                            decode(pTipo, 'D', nvl(pMto,0), 0),
                            decode(pTipo, 'C', nvl(pMto,0), 0),     nvl(pMto,0),
                            decode(pTipo, 'D', nvl(pMto_Dol,0), 0),
                            decode(pTipo, 'C', nvl(pMto_Dol,0), 0), nvl(pmto_Dol,0));
   END IF;
EXCEPTION
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGaplicar_tercero');
END;