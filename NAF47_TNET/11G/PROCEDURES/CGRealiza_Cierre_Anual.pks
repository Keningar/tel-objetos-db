create or replace PROCEDURE CGRealiza_Cierre_Anual (
  pCia                  Varchar2,
  pcta_Util             Varchar2,
  pCta_Util_Aj          Varchar2,
  pCta_Perd             Varchar2,
  pCta_Perd_Aj          Varchar2,
  pCta_Temp             Varchar2,
  pCta_Temp_Aj          Varchar2,
  pmsg_Error     IN OUT Varchar2
) IS
  --
  vmes_Proce   ARCGMC.MES_PROCE%type;
  vano_Proce   ARCGMC.ANO_PROCE%type;
  vmes_Cierre  ARCGMC.MES_CIERRE%type;
  vmsg         VARCHAR2(400);
  Error_PRoceso EXCEPTION;

BEGIN
  CGRealiza_Cierre_Anual@Gpoetnet ( pCia, pcta_Util, pCta_Util_Aj, pCta_Perd, pCta_Perd_Aj, pCta_Temp, pCta_Temp_Aj, pmsg_Error);
  --
EXCEPTION
    WHEN Error_Proceso THEN
         pMsg_Error := nvl(pMsg_Error, 'CGRegistra_Cierre_Anual');
    WHEN others THEN
         pMsg_Error := nvl(SQLERRM, 'CGRegistra_Cierre_Anual');
END;
