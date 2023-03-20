
/**
 * se debe ejecutar en DB_COMERCIAL 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */


INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        DETALLE_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'numeroLinkDatosBancarios',
        'numero registrado para la credencial de aceptación de cláusulas y datos bancarios',
        'T',
        'Activo',
        SYSDATE,
        'jbroncano',
        'COMERCIAL'
    );


    commit;
	
