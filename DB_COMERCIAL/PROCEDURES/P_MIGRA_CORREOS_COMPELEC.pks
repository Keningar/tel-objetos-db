CREATE OR REPLACE PROCEDURE DB_COMERCIAL.P_MIGRA_CORREOS_COMPELEC IS
    --Query para obtener todos los puntos padre de facturación con estado activo.
    CURSOR Lc_PuntosCliente IS
      SELECT
            IP.IDENTIFICACION_CLIENTE,
            PER.ID_PERSONA_ROL,
            PER.ESTADO,
            COUNT(PUNTO_ID) as NUMERO
      FROM
            DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL DAT,
            DB_COMERCIAL.INFO_PUNTO PTO,
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER,
            DB_COMERCIAL.INFO_EMPRESA_ROL EMP,
            DB_GENERAL.ADMI_ROL ROL,
            DB_GENERAL.ADMI_TIPO_ROL TIPO,
            DB_COMERCIAL.INFO_PERSONA IP 
      WHERE PTO.ID_PUNTO = DAT.PUNTO_ID
        AND PTO.ESTADO = 'Activo'
        AND PER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
        AND PER.ESTADO IN ('Activo', 'Modificado')
        AND EMP.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
        AND EMP.EMPRESA_COD = '10' 
        AND EMP.ROL_ID = ROL.ID_ROL
        AND ROL.TIPO_ROL_ID = TIPO.ID_TIPO_ROL
        AND TIPO.DESCRIPCION_TIPO_ROL = 'Cliente'
        AND PER.PERSONA_ID=IP.ID_PERSONA
        AND DAT.ES_PADRE_FACTURACION='S'
        AND DAT.DATOS_ENVIO='S'
      GROUP BY
        IP.IDENTIFICACION_CLIENTE,
        PER.ID_PERSONA_ROL,
        PER.ESTADO
      ORDER BY 4 DESC;

    CURSOR Lc_EmailEnvio(Cn_PersonaEmpresaRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
      SELECT DISTINCT DAT.EMAIL_ENVIO
        FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL DAT,
             DB_COMERCIAL.INFO_PUNTO PTO
       WHERE PTO.ID_PUNTO = DAT.PUNTO_ID
         AND DAT.DATOS_ENVIO = 'S'
         AND DAT.ES_PADRE_FACTURACION = 'S'
         AND PTO.ESTADO = 'Activo'
         AND TRIM(DAT.EMAIL_ENVIO) IS NOT NULL
         AND PTO.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId;

      Ln_IdUsuario   NUMBER;
      Lv_Observacion VARCHAR2(1000);
      Lv_MsnError    VARCHAR2(1000);
      Lv_Usuario     VARCHAR2(15);
      Le_Error       EXCEPTION;
BEGIN
    FOR Lr_PuntosCliente IN Lc_PuntosCliente
    LOOP
        BEGIN
            Lv_Usuario := 'migraCompElec0';
            Lv_Observacion := 'No se pudo realizar la migración a DB_COMPROBANTES porque NO tiene correo electrónico en sus puntos de facturación';
            FOR Lr_EmailEnvio IN Lc_EmailEnvio (Lr_PuntosCliente.ID_PERSONA_ROL)
            LOOP
                IF Lc_EmailEnvio%ROWCOUNT = 1 THEN
                    Lv_Usuario     := 'migraCompElec1';
                    Lv_Observacion := 'Se realiza la migración a DB_COMPROBANTES satisfactoriamente';
                    --Se actualiza la tabla ADMI_USUARIO
                    Ln_IdUsuario   := 0;
                    UPDATE DB_COMPROBANTES.ADMI_USUARIO
                       SET EMAIL = Lr_EmailEnvio.EMAIL_ENVIO,
                           USR_ULT_MOD = Lv_Usuario,
                           FE_ULT_MOD = SYSDATE
                     WHERE LOGIN = Lr_PuntosCliente.IDENTIFICACION_CLIENTE
                       AND ESTADO = 'Activo'
                     RETURNING ID_USUARIO INTO Ln_IdUsuario;

                     IF NVL(Ln_IdUsuario,0) = 0 THEN
                        Lv_Observacion := 'No se encontró un usuario en DB_COMPROBANTES.';
                        Lv_Usuario := 'migraCompElec2';
                        RAISE Le_Error;
                     END IF;

                    --Se actualiza la tabla ADMI_USUARIO_EMPRESA VÁLIDO PARA TN
                    UPDATE DB_COMPROBANTES.ADMI_USUARIO_EMPRESA
                       SET EMAIL = Lr_EmailEnvio.EMAIL_ENVIO,
                           USR_ULT_MOD = Lv_Usuario,
                           FE_ULT_MOD = SYSDATE
                     WHERE USUARIO_ID = Ln_IdUsuario
                       AND EMPRESA_ID = 1;
                ELSE
                    Lv_Observacion := 'No se realizó la migración a DB_COMPROBANTES porque tiene correos diferentes en sus puntos de facturación';
                    Lv_Usuario := 'migraCompElec3';
                    RAISE Le_Error;
                END IF;
            END LOOP;
        EXCEPTION
            WHEN Le_Error THEN
                ROLLBACK;
            WHEN OTHERS THEN
                ROLLBACK;
                Lv_Observacion := 'No se pudo realizar la migración a DB_COMPROBANTES porque ocurrió un error inesperado';
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
                                            'Telcos+',
                                            'Migración de correos a Comprobantes Electrónicos',
                                            'Error al al migrar los correos electrónicos a CompElec: ' || SQLCODE || ' - ERROR_STACK: '
                                            || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            'migraCompElec',
                                            SYSDATE,
                                            '127.0.0.1');
        END;
        IF Lc_EmailEnvio%ISOPEN THEN
            CLOSE Lc_EmailEnvio;
        END IF;

        --INSERTO EN LA INFO_PERSONA_EMPRESA_ROL_HISTORIAL SEGÚN ÉXITO O ERROR
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO (
                    ID_PERSONA_EMPRESA_ROL_HISTO,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    ESTADO,
                    PERSONA_EMPRESA_ROL_ID,
                    OBSERVACION,
                    MOTIVO_ID,
                    EMPRESA_ROL_ID,
                    OFICINA_ID,
                    DEPARTAMENTO_ID,
                    CUADRILLA_ID,
                    REPORTA_PERSONA_EMPRESA_ROL_ID,
                    ES_PREPAGO
        ) VALUES (
                    DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
                    Lv_Usuario,
                    SYSDATE,
                    '127.0.0.1',
                    Lr_PuntosCliente.ESTADO,
                    Lr_PuntosCliente.ID_PERSONA_ROL,
                    Lv_Observacion,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL
        );
        COMMIT;
    END LOOP;
    COMMIT;
    DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL('notificaciones_telcos@telconet.ec', 
                                            'lcabrera@telconet.ec;gvillalba@telconet.ec;', 
                                            'Ejecución de script de migración de correos electrónicos', 
                                            'HA FINALIZADO LA EJECUCION DEL SCRIPT DE MIGRACION DE CORREOS ELECTRONICOS A DB_COMPROBANTES',
                                            'text/html; charset=UTF-8', 
                                            Lv_MsnError);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                              'Migración de correos a Comprobantes Electrónicos',
                                              'Error al al migrar los correos electrónicos a CompElec: ' || SQLCODE || ' - ERROR_STACK: '
                                                 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              'migraCompElec',
                                              SYSDATE,
                                              '127.0.0.1');
END P_MIGRA_CORREOS_COMPELEC;
/