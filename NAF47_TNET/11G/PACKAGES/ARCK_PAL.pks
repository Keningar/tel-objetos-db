CREATE OR REPLACE PACKAGE            ARCK_PAL AS

  /**
   * Reversa la contabilidad de un pago en linea
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 31-05-2019
  **/
    PROCEDURE P_REVERSA_CONT_PAL (
        Pv_IdPagoDet     IN               VARCHAR2,
        Pv_NoCia         IN               VARCHAR2,
        Pv_UsrCreacion   IN               VARCHAR2,
        Pv_Code          OUT              VARCHAR2
    );

END ARCK_PAL;
/


CREATE OR REPLACE PACKAGE BODY            ARCK_PAL AS

    PROCEDURE P_REVERSA_CONT_PAL (
        Pv_IdPagoDet     IN               VARCHAR2,
        Pv_NoCia         IN               VARCHAR2,
        Pv_UsrCreacion   IN               VARCHAR2,
        Pv_Code          OUT              VARCHAR2
    ) AS

    --

        CURSOR C_MigraDocAsociado (
            Cv_NoCia         NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.NO_CIA%TYPE,
            Cv_UsrCreacion   NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.USR_CREACION%TYPE,
            Cv_DocOrigen     NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.DOCUMENTO_ORIGEN_ID%TYPE
        ) IS
        SELECT
            MDA.ROWID   PK_DOC_ASOC,
            MDA.*
        FROM
            NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
        WHERE
            MDA.NO_CIA = Cv_NoCia
            AND MDA.USR_CREACION = Cv_UsrCreacion
            AND MDA.DOCUMENTO_ORIGEN_ID = Cv_DocOrigen;
        --

        CURSOR C_GetMigraArckMM (
            Cv_IdMigracion   NAF47_TNET.MIGRA_ARCKMM.ID_MIGRACION%TYPE,
            Cv_NoCia         NAF47_TNET.MIGRA_ARCKMM.NO_CIA%TYPE,
            Cv_UsrCreacion   NAF47_TNET.MIGRA_ARCKMM.USUARIO_CREACION%TYPE,
            Cv_CodDiario     NAF47_TNET.MIGRA_ARCKMM.COD_DIARIO%TYPE
        ) IS
        SELECT
            ARCK.ROWID   PK_ARCKMM,
            ARCK.*
        FROM
            NAF47_TNET.MIGRA_ARCKMM ARCK
        WHERE
            ARCK.ID_MIGRACION = Cv_IdMigracion
            AND ARCK.NO_CIA = Cv_NoCia
            AND ARCK.USUARIO_CREACION = Cv_UsrCreacion
            AND ARCK.COD_DIARIO = Cv_CodDiario;
        --

        Lv_Msn                VARCHAR2(2000) := '';
        Lv_Code               VARCHAR2(5) := '';
        Lv_TipoMov            VARCHAR2(5) := '';
        Ln_Secuencia          NUMBER := 0;
        Le_Exception EXCEPTION;
        Lc_GetMigraArckMM     C_GetMigraArckMM%ROWTYPE;
        Lc_MigraDocAsociado   C_MigraDocAsociado%ROWTYPE;
    --
    BEGIN
        FOR I_IdPagoDet IN (
            SELECT
                TRIM(REGEXP_SUBSTR(Pv_IdPagoDet, '[^,]+', 1, LEVEL)) LevelPagoDet
            FROM
                DUAL
            CONNECT BY
                LEVEL <= REGEXP_COUNT(Pv_IdPagoDet, ',') + 1
        ) LOOP
            BEGIN
                DBMS_OUTPUT.PUT_LINE('Itera PagoDet: ' || I_IdPagoDet.LevelPagoDet);
        --
                IF C_MigraDocAsociado%ISOPEN THEN
                    CLOSE C_MigraDocAsociado;
                END IF;
        --
                OPEN C_MigraDocAsociado(Pv_NoCia, Pv_UsrCreacion, I_IdPagoDet.LevelPagoDet);
                FETCH C_MigraDocAsociado INTO Lc_MigraDocAsociado;
        --
                CLOSE C_MigraDocAsociado;
        --
        --
                IF 'M' <> Lc_MigraDocAsociado.ESTADO OR 'CK' <> Lc_MigraDocAsociado.TIPO_MIGRACION OR '' <> Lc_MigraDocAsociado.MIGRACION_ID
                OR 'telcos_pal' <> Lc_MigraDocAsociado.USR_CREACION OR Lc_MigraDocAsociado.TIPO_DOC_MIGRACION NOT IN (
                    'M_DEB',
                    'M_ANT'
                ) THEN
                    Lv_Msn := 'No se puede regularizar la contabilidad de PagoDet: ' || I_IdPagoDet.LevelPagoDet;
                    RAISE Le_Exception;
                END IF;
            --

                IF C_GetMigraArckMM%ISOPEN THEN
                    CLOSE C_GetMigraArckMM;
                END IF;
            --
                OPEN C_GetMigraArckMM(Lc_MigraDocAsociado.MIGRACION_ID, Pv_NoCia, Pv_UsrCreacion, Lc_MigraDocAsociado.TIPO_DOC_MIGRACION
                );
            --
                FETCH C_GetMigraArckMM INTO Lc_GetMigraArckMM;
            --
                IF C_GetMigraArckMM%NOTFOUND THEN
                    CLOSE C_GetMigraArckMM;
                    Lv_Msn := 'No existe ArckMM para ID_MIGRACION: '
                              || Lc_MigraDocAsociado.MIGRACION_ID
                              || ' de PagoDet: '
                              || I_IdPagoDet.LevelPagoDet;
                    RAISE Le_Exception;
                END IF;
            --

                CLOSE C_GetMigraArckMM;
            --
                IF Lc_GetMigraArckMM.PROCESADO NOT IN (
                    'N',
                    'S'
                ) THEN
                    Lv_Msn := 'El estado de ArckMM es '
                              || Lc_GetMigraArckMM.PROCESADO
                              || ' de PagoDet: '
                              || I_IdPagoDet.LevelPagoDet;
                    RAISE Le_Exception;
                END IF;

                IF 'N' = Lc_GetMigraArckMM.PROCESADO THEN
            --
                    DBMS_OUTPUT.PUT_LINE('MIGRACION_ID: '
                                         || Lc_MigraDocAsociado.MIGRACION_ID
                                         || ' Pv_NoCia: '
                                         || Pv_NoCia
                                         || ' Pv_UsrCreacion: '
                                         || Pv_UsrCreacion
                                         || ' TIPO_DOC_MIGRACION: '
                                         || Lc_MigraDocAsociado.TIPO_DOC_MIGRACION
                                         || ' a [X] y MIGRA_DOCUMENTO_ASOCIADO a [E]');

                    UPDATE NAF47_TNET.MIGRA_ARCKMM ARCKU
                    SET
                        ARCKU.PROCESADO = 'X'
                    WHERE
                        ARCKU.ROWID = Lc_GetMigraArckMM.PK_ARCKMM;
                    --

                    UPDATE NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDAU
                    SET
                        MDAU.ESTADO = 'E'
                    WHERE
                        MDAU.ROWID = Lc_MigraDocAsociado.PK_DOC_ASOC;
        --

                END IF;

                IF 'S' = Lc_GetMigraArckMM.PROCESADO THEN
                    Ln_Secuencia := 0;
                    Ln_Secuencia := NAF47_TNET.TRANSA_ID.MIGRA_CK(Pv_NoCia);
                    IF 0 = Ln_Secuencia THEN
                        Lv_Msn := 'No se genero la secuencia MIGRA_CK de PagoDet: ' || I_IdPagoDet.LevelPagoDet;
                        RAISE Le_Exception;
                    END IF;
                --

                    DBMS_OUTPUT.PUT_LINE('Inserta DocAsociado: '
                                         || Ln_Secuencia
                                         || ', ARCKMM de '
                                         || I_IdPagoDet.LevelPagoDet);
                    INSERT INTO NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO (
                        DOCUMENTO_ORIGEN_ID,
                        TIPO_DOC_MIGRACION,
                        MIGRACION_ID,
                        TIPO_MIGRACION,
                        NO_CIA,
                        FORMA_PAGO_ID,
                        TIPO_DOCUMENTO_ID,
                        ESTADO,
                        USR_CREACION,
                        FE_CREACION,
                        USR_ULT_MOD,
                        FE_ULT_MOD
                    ) VALUES (
                        I_IdPagoDet.LevelPagoDet,
                        Lc_MigraDocAsociado.TIPO_DOC_MIGRACION,
                        Ln_Secuencia,
                        Lc_MigraDocAsociado.TIPO_MIGRACION,
                        Lc_MigraDocAsociado.NO_CIA,
                        Lc_MigraDocAsociado.FORMA_PAGO_ID,
                        Lc_MigraDocAsociado.TIPO_DOCUMENTO_ID,
                        Lc_MigraDocAsociado.ESTADO,
                        Lc_MigraDocAsociado.USR_CREACION,
                        Lc_MigraDocAsociado.FE_CREACION,
                        Lc_MigraDocAsociado.USR_ULT_MOD,
                        Lc_MigraDocAsociado.FE_ULT_MOD
                    );
                --

                    INSERT INTO NAF47_TNET.MIGRA_ARCKMM (
                        NO_CIA,
                        NO_CTA,
                        PROCEDENCIA,
                        TIPO_DOC,
                        NO_DOCU,
                        FECHA,
                        BENEFICIARIO,
                        COMENTARIO,
                        MONTO,
                        DESCUENTO_PP,
                        ESTADO,
                        CONCILIADO,
                        MES,
                        ANO,
                        FECHA_ANULADO,
                        IND_BORRADO,
                        IND_OTROMOV,
                        MONEDA_CTA,
                        TIPO_CAMBIO,
                        TIPO_AJUSTE,
                        IND_DIST,
                        T_CAMB_C_V,
                        IND_OTROS_MESES,
                        MES_CONCILIADO,
                        ANO_CONCILIADO,
                        NO_FISICO,
                        SERIE_FISICO,
                        IND_CON,
                        NUMERO_CTRL,
                        ORIGEN,
                        USUARIO_CREACION,
                        USUARIO_ANULA,
                        USUARIO_PROCESA,
                        FECHA_PROCESA,
                        FECHA_DOC,
                        IND_DIVISION,
                        COD_DIVISION,
                        PROCESADO,
                        FECHA_CREACION,
                        ID_FORMA_PAGO,
                        ID_OFICINA_FACTURACION,
                        ID_MIGRACION,
                        COD_DIARIO
                    ) VALUES (
                        Lc_GetMigraArckMM.NO_CIA,
                        Lc_GetMigraArckMM.NO_CTA,
                        Lc_GetMigraArckMM.PROCEDENCIA,
                        'ND',
                        Lc_GetMigraArckMM.NO_DOCU,
                        Lc_GetMigraArckMM.FECHA,
                        Lc_GetMigraArckMM.BENEFICIARIO,
                        Lc_GetMigraArckMM.COMENTARIO,
                        Lc_GetMigraArckMM.MONTO,
                        Lc_GetMigraArckMM.DESCUENTO_PP,
                        Lc_GetMigraArckMM.ESTADO,
                        Lc_GetMigraArckMM.CONCILIADO,
                        Lc_GetMigraArckMM.MES,
                        Lc_GetMigraArckMM.ANO,
                        Lc_GetMigraArckMM.FECHA_ANULADO,
                        Lc_GetMigraArckMM.IND_BORRADO,
                        Lc_GetMigraArckMM.IND_OTROMOV,
                        Lc_GetMigraArckMM.MONEDA_CTA,
                        Lc_GetMigraArckMM.TIPO_CAMBIO,
                        Lc_GetMigraArckMM.TIPO_AJUSTE,
                        Lc_GetMigraArckMM.IND_DIST,
                        Lc_GetMigraArckMM.T_CAMB_C_V,
                        Lc_GetMigraArckMM.IND_OTROS_MESES,
                        Lc_GetMigraArckMM.MES_CONCILIADO,
                        Lc_GetMigraArckMM.ANO_CONCILIADO,
                        Lc_GetMigraArckMM.NO_FISICO,
                        Lc_GetMigraArckMM.SERIE_FISICO,
                        Lc_GetMigraArckMM.IND_CON,
                        Lc_GetMigraArckMM.NUMERO_CTRL,
                        Lc_GetMigraArckMM.ORIGEN,
                        Lc_GetMigraArckMM.USUARIO_CREACION,
                        Lc_GetMigraArckMM.USUARIO_ANULA,
                        Lc_GetMigraArckMM.USUARIO_PROCESA,
                        Lc_GetMigraArckMM.FECHA_PROCESA,
                        Lc_GetMigraArckMM.FECHA_DOC,
                        Lc_GetMigraArckMM.IND_DIVISION,
                        Lc_GetMigraArckMM.COD_DIVISION,
                        'N',
                        Lc_GetMigraArckMM.FECHA_CREACION,
                        Lc_GetMigraArckMM.ID_FORMA_PAGO,
                        Lc_GetMigraArckMM.ID_OFICINA_FACTURACION,
                        Ln_Secuencia,
                        Lc_GetMigraArckMM.COD_DIARIO
                    );
                --

                    FOR I_ArckML IN (
                        SELECT
                            ARCKML.*
                        FROM
                            NAF47_TNET.MIGRA_ARCKML ARCKML
                        WHERE
                            ARCKML.MIGRACION_ID = Lc_MigraDocAsociado.MIGRACION_ID
                            AND ARCKML.COD_DIARIO = Lc_MigraDocAsociado.TIPO_DOC_MIGRACION
                            AND ARCKML.NO_CIA = Pv_NoCia
                    ) LOOP
                        Lv_TipoMov := 'D';
                        IF 'D' = I_ArckML.TIPO_MOV THEN
                            Lv_TipoMov := 'C';
                        END IF;
                        INSERT INTO NAF47_TNET.MIGRA_ARCKML (
                            NO_CIA,
                            PROCEDENCIA,
                            TIPO_DOC,
                            NO_DOCU,
                            COD_CONT,
                            CENTRO_COSTO,
                            TIPO_MOV,
                            MONTO,
                            MONTO_DOL,
                            TIPO_CAMBIO,
                            MONEDA,
                            NO_ASIENTO,
                            MODIFICABLE,
                            CODIGO_TERCERO,
                            IND_CON,
                            ANO,
                            MES,
                            MONTO_DC,
                            GLOSA,
                            EXCEDE_PRESUPUESTO,
                            MIGRACION_ID,
                            LINEA,
                            COD_DIARIO
                        ) VALUES (
                            I_ArckML.NO_CIA,
                            I_ArckML.PROCEDENCIA,
                            'ND',
                            I_ArckML.NO_DOCU,
                            I_ArckML.COD_CONT,
                            I_ArckML.CENTRO_COSTO,
                            Lv_TipoMov,
                            I_ArckML.MONTO,
                            I_ArckML.MONTO_DOL,
                            I_ArckML.TIPO_CAMBIO,
                            I_ArckML.MONEDA,
                            I_ArckML.NO_ASIENTO,
                            I_ArckML.MODIFICABLE,
                            I_ArckML.CODIGO_TERCERO,
                            I_ArckML.IND_CON,
                            I_ArckML.ANO,
                            I_ArckML.MES,
                            I_ArckML.MONTO_DC,
                            I_ArckML.GLOSA,
                            I_ArckML.EXCEDE_PRESUPUESTO,
                            Ln_Secuencia,
                            I_ArckML.LINEA,
                            I_ArckML.COD_DIARIO
                        );

                    END LOOP;

                END IF;
        --

            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE(Lv_Msn
                                         || ' '
                                         || SQLERRM);
            END;
        --
        END LOOP;

        Pv_Code := '100';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Code := '001';
            DBMS_OUTPUT.PUT_LINE(Lv_Msn
                                 || ' '
                                 || SQLERRM);
    END;

END ARCK_PAL;
/
