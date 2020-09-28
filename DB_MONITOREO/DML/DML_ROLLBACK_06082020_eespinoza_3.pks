/**
 * ROLLBACK de insert de motivos por definidos para tabla DB_MONITOREO.ADMI_MOTIVO
 * @author Leonardo Espinoza <eespinoza@telconet.ec>
 * @since 09-07-2020
 */
DELETE FROM DB_MONITOREO.ADMI_MOTIVO
  WHERE
  NOMBRE_MOTIVO = 'Robado';

DELETE FROM DB_MONITOREO.ADMI_MOTIVO
  WHERE
  NOMBRE_MOTIVO = 'Mantenimiento';

DELETE FROM DB_MONITOREO.ADMI_MOTIVO
  WHERE
  NOMBRE_MOTIVO = 'Dado de Baja';

COMMIT;
/