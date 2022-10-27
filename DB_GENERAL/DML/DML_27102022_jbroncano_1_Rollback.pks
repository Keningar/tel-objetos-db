
/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de la fecha para que se visualize el boton de reenvio correo compra 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 27-10-2022 - Versión Inicial.
 */


DELETE FROM DB_GENERAL.admi_parametro_Det
    where  PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                            WHERE PCA.NOMBRE_PARAMETRO = 'CRC_FECHA_REENVIO_CORREO' AND PCA.ESTADO='Activo') 
                      AND  ESTADO='Activo' AND  DESCRIPCION='CRC_FECHA_REGULARIZACION_CORREO_RESUMEN';


DELETE FROM DB_GENERAL.admi_parametro_Det
    where  PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                            WHERE PCA.NOMBRE_PARAMETRO = 'CRC_EMPRESA_RESUMEN_CORREO' AND PCA.ESTADO='Activo') 
                      AND  ESTADO='Activo' AND  DESCRIPCION='EMPRESA_RESUMEN_CORREO';


delete from DB_GENERAL.admi_parametro_cab  WHERE nombre_parametro = 'CRC_EMPRESA_RESUMEN_CORREO';



COMMIT;
/