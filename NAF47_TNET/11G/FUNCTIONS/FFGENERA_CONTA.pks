CREATE OR REPLACE FUNCTION NAF47_TNET.FFGENERA_CONTA( pNo_cia   in varchar2,
                                           pCod_Caja in varchar2,
                                           pFecha    in date,
                                           pMensaje  in out varchar2 ) Return Boolean IS

BEGIN --principal
  
return NAF47_TNET.FFGENERA_CONTA@GPOETNET( pNo_cia ,
                           pCod_Caja ,
                           pFecha ,
                           pMensaje);

EXCEPTION
  WHEN transa_id.error THEN
    pMensaje:='Error generando asiento: '||transa_id.ultimo_error;
    RETURN FALSE;

  WHEN Others THEN
    pMensaje:='FFGENERA_CONTA: '||sqlerrm;
    RETURN FALSE;
END;
/