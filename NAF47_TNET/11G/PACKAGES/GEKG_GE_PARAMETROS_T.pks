CREATE OR REPLACE PACKAGE            GEKG_GE_PARAMETROS_T AS 

    /**
     * Inserta registro en GE_PARAMETROS
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 28-10-2018
     **/
    PROCEDURE P_INSERT_GE_PARAMETROS (
        Pr_GeParametros   IN OUT            GE_PARAMETROS%ROWTYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

END GEKG_GE_PARAMETROS_T;
/


CREATE OR REPLACE PACKAGE BODY            GEKG_GE_PARAMETROS_T AS

    PROCEDURE P_INSERT_GE_PARAMETROS (
        Pr_GeParametros   IN OUT            GE_PARAMETROS%ROWTYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
    BEGIN
        INSERT INTO GE_PARAMETROS (
            ID_EMPRESA,
            ID_APLICACION,
            ID_GRUPO_PARAMETRO,
            PARAMETRO,
            PARAMETRO_ALTERNO,
            NUMERICO,
            NUMERICO_ALTERNO,
            DESCRIPCION,
            ESTADO,
            USUARIO_CREA,
            FECHA_CREA,
            USUARIO_ACTUALIZA,
            FECHA_ACTUALIZA
        ) VALUES (
            Pr_GeParametros.ID_EMPRESA,
            Pr_GeParametros.ID_APLICACION,
            Pr_GeParametros.ID_GRUPO_PARAMETRO,
            Pr_GeParametros.PARAMETRO,
            Pr_GeParametros.PARAMETRO_ALTERNO,
            Pr_GeParametros.NUMERICO,
            Pr_GeParametros.NUMERICO_ALTERNO,
            Pr_GeParametros.DESCRIPCION,
            Pr_GeParametros.ESTADO,
            Pr_GeParametros.USUARIO_CREA,
            Pr_GeParametros.FECHA_CREA,
            Pr_GeParametros.USUARIO_ACTUALIZA,
            Pr_GeParametros.FECHA_ACTUALIZA
        );

        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_GE_PARAMETROS;

END GEKG_GE_PARAMETROS_T;
/
