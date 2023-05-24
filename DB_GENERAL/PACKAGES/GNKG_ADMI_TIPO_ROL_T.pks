CREATE OR REPLACE PACKAGE DB_GENERAL.GNKG_ADMI_TIPO_ROL_T AS 

    /**
     * Inserta registro en ADMI_TIPO_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 28-10-2018
     **/
    PROCEDURE P_INSERT_ADMI_ROL (
        Pr_AdmiTipoRol   IN               ADMI_TIPO_ROL%ROWTYPE,
        Pn_IdTipoRol     OUT              ADMI_TIPO_ROL.ID_TIPO_ROL%TYPE,
        Pv_Status        OUT              VARCHAR2,
        Pv_Code          OUT              VARCHAR2,
        Pv_Msn           OUT              VARCHAR2
    );

END GNKG_ADMI_TIPO_ROL_T;
/

CREATE OR REPLACE PACKAGE BODY DB_GENERAL.GNKG_ADMI_TIPO_ROL_T AS

    PROCEDURE P_INSERT_ADMI_ROL (
        Pr_AdmiTipoRol   IN               ADMI_TIPO_ROL%ROWTYPE,
        Pn_IdTipoRol     OUT              ADMI_TIPO_ROL.ID_TIPO_ROL%TYPE,
        Pv_Status        OUT              VARCHAR2,
        Pv_Code          OUT              VARCHAR2,
        Pv_Msn           OUT              VARCHAR2
    ) AS
    BEGIN
        Pn_IdTipoRol := SEQ_ADMI_TIPO_ROL.NEXTVAL;
        INSERT INTO ADMI_TIPO_ROL (
            ID_TIPO_ROL,
            DESCRIPCION_TIPO_ROL,
            ESTADO,
            USR_CREACION,
            FE_CREACION
        ) VALUES (
            Pn_IdTipoRol,
            Pr_AdmiTipoRol.DESCRIPCION_TIPO_ROL,
            Pr_AdmiTipoRol.ESTADO,
            Pr_AdmiTipoRol.USR_CREACION,
            Pr_AdmiTipoRol.FE_CREACION
        );

        Pv_Status := GNKG_RESULT.GENERATED_STATUS;
        Pv_Code := GNKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GNKG_RESULT.FAILED_STATUS;
            Pv_Code := GNKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_ADMI_ROL;

END GNKG_ADMI_TIPO_ROL_T;
/
