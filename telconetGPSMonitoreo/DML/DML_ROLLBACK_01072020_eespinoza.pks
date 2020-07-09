#
# =======================================================
# ======= SCRIPT DE REVERSO -  Creación de parámetros ===
# =======================================================
# @author Leonardo Espinoza <eespinoza@telconet.ec>
# @version 1.0 
# @since 01-07-2020
#
DELETE FROM telconetgpsmonitoreo.admi_parametro 
  WHERE 
  detalle = 'id_parametro_correo';

COMMIT;
/

DELETE FROM telconetgpsmonitoreo.admi_parametro 
  WHERE 
  detalle = 'id_parametro_velocidad';

  COMMIT;
/