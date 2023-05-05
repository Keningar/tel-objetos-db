create or replace TRIGGER NAF47_TNET.AFTER_TAPORDEE
  after update of estado 
  on TAPORDEE 
  for each row
/**
 * Documentacion para AFTER_TAPORDEE
 * Trigger que genera notificación de ordenes de compras cuando son autorizadas.
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.0 12/11/2021
 * 
 * @author banton <banton@telconet.ec>
 * @version 1.1 20/09/2022
 * Se envia usuario que crea la orden de compra
 *
 */

declare
  -- local variables here
  Lr_DatosOrdenCompra NAF47_TNET.CORREO_ORDEN.Gr_DatosOrdenCompra;
begin
  --
  IF :NEW.ESTADO = 'E' THEN
    --
    Lr_DatosOrdenCompra.NO_CIA := :NEW.NO_CIA;
    Lr_DatosOrdenCompra.NO_ORDEN := :NEW.NO_ORDEN;
    Lr_DatosOrdenCompra.NO_PROVEEDOR := :NEW.NO_PROVE;
    Lr_DatosOrdenCompra.NO_SOLICITANTE := :NEW.ADJUDICADOR;
    Lr_DatosOrdenCompra.ID_TIPO_TRANSACCION := :NEW.ID_TIPO_TRANSACCION;
    Lr_DatosOrdenCompra.FECHA := :NEW.FECHA;
    Lr_DatosOrdenCompra.TOTAL := :NEW.TOTAL;
    Lr_DatosOrdenCompra.FECHA_VENCE := :NEW.FECHA_VENCE;
    Lr_DatosOrdenCompra.OBSERVACION := :NEW.OBSERV;
    Lr_DatosOrdenCompra.USUARIO :=:NEW.USUARIO;
    --
    NAF47_TNET.CORREO_ORDEN.P_NOTIFICA_AUTORIZACION (Lr_DatosOrdenCompra);
    --
  END IF;
  --
end AFTER_TAPORDEE;
