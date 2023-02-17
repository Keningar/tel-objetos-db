/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Script crear configuraciones adicionales proceso derecho legal(eliminacion)
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 2022-01-22 - Versión Inicial.
 */
 
delete from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL irol where irol.persona_id in (
select IPE.id_persona from DB_COMERCIAL.INFO_PERSONA IPE where IPE.identificacion_cliente = 'ESTO NO ES UNA IDENTIFICACION'
);

delete from DB_COMERCIAL.INFO_PERSONA IPE where IPE.identificacion_cliente = 'ESTO NO ES UNA IDENTIFICACION'; 

delete from DB_COMERCIAL.ADMI_FORMA_PAGO ad where ad.DESCRIPCION_FORMA_PAGO = 'No disponible LOPDP';


delete from DB_COMERCIAL.ADMI_CARACTERISTICA ae where ae.DESCRIPCION_CARACTERISTICA = 'CLIENTE CIFRADO'; 


COMMIT;

/
