-- new object type path: SCHEMA_EXPORT/TABLE/TRIGGER
CREATE OR REPLACE TRIGGER DB_INFRAESTRUCTURA.TRG_PROCESO_MASIVO_CAB
  BEFORE INSERT ON DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
  REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW 
DECLARE
 /**
  * Documentaci�n para trigger DB_COMERCIAL.TRG_PROCESO_MASIVO_CAB
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 10-10-2019  Se crea trigger para cambiar a un estado intermedio los procesos masivos de reactivaci�n MD
  *                          que deben validar las promociones de BW en la que pueden estar aplicando.
  * @since 1.0
  */
  Lv_Mensaje VARCHAR2(500) := 'Trigger para cambiar de estado Pendiente a PendientePromo al insertar registros ' ||
                              'para procesar promociones de servicios';
BEGIN
      IF :NEW.TIPO_PROCESO = 'ReconectarCliente' AND :NEW.EMPRESA_ID = 18 AND :NEW.ESTADO = 'Pendiente'  THEN
        :NEW.ESTADO := 'PendientePromo';
      END IF;
EXCEPTION
WHEN OTHERS THEN
  UTL_MAIL.SEND (sender     => 'notificaciones@telconet.ec', 
                 recipients => 'telcos@telconet.ec', 
                 subject    => 'Error generado en el trigger DB_INFRAESTRUCTURA.TRG_PROCESO_MASIVO_CAB', 
                 MESSAGE    => '<p>Ocurrio el siguiente error: '  || SQLERRM || ' - ' ||
                                SQLCODE ||Lv_Mensaje||' </p>', mime_type => 'text/html; charset=UTF-8' );
END;
/
