/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Script para reversar nueva forma de contacto para aperturar casos desde Extranet
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since 09-11-2021 - Versión Inicial.
 */

DELETE FROM Db_Comercial.Admi_Forma_Contacto
WHERE
    Codigo = 'EXTR'
  AND Estado = 'Activo'
  AND Usr_Creacion = 'ddelacruz';

DELETE FROM Db_Comercial.Admi_Caracteristica
WHERE
    Descripcion_Caracteristica = 'REFERENCIA_PERSONA'
  AND Estado = 'Activo'
  AND Usr_Creacion = 'ddelacruz';  

commit;

/
