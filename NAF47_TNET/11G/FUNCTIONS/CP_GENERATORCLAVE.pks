CREATE OR  REPLACE function NAF47_TNET.CP_GENERATORCLAVE(Pv_FechaDocumento          IN Varchar2,
                                                                                  Pv_TipoComprobanteSRI    IN Varchar2,
                                                                                  Pv_Id_identificacion_prov   IN Varchar2,
                                                                                  Pv_AmbienteId                   IN Varchar2,
                                                                                  Pv_NoSerieComprob           IN Varchar2,
                                                                                  Pv_NoFisicoComprob          IN Varchar2,
                                                                                  Pv_TipoEmision                  IN Varchar2  ) return Varchar2 IS                                                                                 
  /**
  * Documentacion para NAF47_TNET.CP_GENERATORCLAVE
  * Funcion que devuelve la clave para el comprobante de retencin 
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 22/04/2022 - Se modifica para invocar al proceso de la base 19c 
  */

   Cursor C_ClaveSRI  Is
      SELECT DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERATORCLAVE@GPOETNET ( Pv_FechaDocumento,
                                                                   Pv_TipoComprobanteSRI,
                                                                   Pv_Id_identificacion_prov,
                                                                   Pv_AmbienteId,  
                                                                   Pv_NoSerieComprob,
                                                                   Pv_NoFisicoComprob,
                                                                   Pv_FechaDocumento,
                                                                   Pv_TipoEmision ) FROM DUAL;

   Lv_ClaveAcceso  DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%type;

Begin
--- 
  Open C_ClaveSRI;
  Fetch C_ClaveSRI into Lv_ClaveAcceso;
  If C_ClaveSRI%notfound Then
   Close C_ClaveSRI;
  else
   Close C_ClaveSRI;
  end if;

  return (Lv_ClaveAcceso);

end CP_GENERATORCLAVE;
/