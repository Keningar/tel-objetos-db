----------------------------------------------------------------------------------------------------------------
-- Se actualiza el campo CODIGO en NULL a los registros en la tabla ADMI_FORMA_CONTACTOS previamente afectados--
-- Tiempo estimado: tarea completa en 0.013 segundos.
----------------------------------------------------------------------------------------------------------------

UPDATE  DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC 
        SET     AFC.CODIGO = null,
                AFC.USR_ULT_MOD = AFC.USR_CREACION
        WHERE   AFC.USR_ULT_MOD = 'eevargas';
COMMIT;
