create or replace PROCEDURE            CO_P_GESTION_DOCUMENTAL( Pv_noOrden       VARCHAR2,
                                                                Pv_noCia         VARCHAR2,
                                                                Pv_MensajeError  in out VARCHAR2,
                                                                Pv_NumeroFactura VARCHAR2 DEFAULT NULL,
                                                                Pv_NumeroRuc     VARCHAR2 DEFAULT NULL) IS
/**
* Documentacion para NAF47_TNET.CO_P_GESTION_DOCUMENTAL
* Procedimiento que invoca al proceso gestión documental de base 19c
* @author llindao <llindao@telconet.ec>
* @version 1.0 04/04/2022
*
*/

begin
  --
  NAF47_TNET.CO_P_GESTION_DOCUMENTAL@GPOETNET (Pv_noOrden,
                                               Pv_noCia,
                                               Pv_MensajeError,
                                               Pv_NumeroFactura,
                                               Pv_NumeroRuc);
  --
end CO_P_GESTION_DOCUMENTAL;