create or replace function            CP_GENERATORCLAVE(Pv_FechaDocumento          IN Varchar2,
                                                                                  Pv_TipoComprobanteSRI    IN Varchar2,
                                                                                  Pv_Id_identificacion_prov   IN Varchar2,
                                                                                  Pv_AmbienteId                   IN Varchar2,
                                                                                  Pv_NoSerieComprob           IN Varchar2,
                                                                                  Pv_NoFisicoComprob          IN Varchar2,
                                                                                  Pv_TipoEmision                  IN Varchar2  ) return Varchar2 IS                                                                                 
   Cursor C_ClaveSRI  Is
      SELECT  DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERATORCLAVE (Pv_FechaDocumento,
                                                                                                                                                Pv_TipoComprobanteSRI,
                                                                                                                                                Pv_Id_identificacion_prov,
                                                                                                                                                Pv_AmbienteId,  
                                                                                                                                                Pv_NoSerieComprob,
                                                                                                                                                Pv_NoFisicoComprob,
                                                                                                                                                Pv_FechaDocumento,
                                                                                                                                               Pv_TipoEmision ) FROM DUAL;

   Lv_ClaveAcceso  DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%type;

Begin
--- Funcion que devuelve la clave para el comprobante de retención 
  Open C_ClaveSRI;
  Fetch C_ClaveSRI into Lv_ClaveAcceso;
  If C_ClaveSRI%notfound Then
   Close C_ClaveSRI;
  else
   Close C_ClaveSRI;
  end if;

  return (Lv_ClaveAcceso);

end CP_GENERATORCLAVE;
