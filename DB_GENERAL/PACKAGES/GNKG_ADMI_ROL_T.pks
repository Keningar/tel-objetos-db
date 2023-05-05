CREATE EDITIONABLE PACKAGE            GNKG_ADMI_ROL_T AS 

    /**
     * Inserta registro en ADMI_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 28-10-2018
     **/
    PROCEDURE P_INSERT_ADMI_ROL (
        Pr_AdmiRol   IN           ADMI_ROL%ROWTYPE,
        Pn_IdRol     OUT          ADMI_ROL.ID_ROL%TYPE,
        Pv_Status    OUT          VARCHAR2,
        Pv_Code      OUT          VARCHAR2,
        Pv_Msn       OUT          VARCHAR2
    );

END GNKG_ADMI_ROL_T;
/

CREATE EDITIONABLE PACKAGE BODY            GNKG_ADMI_ROL_T AS

    PROCEDURE P_INSERT_ADMI_ROL (
        Pr_AdmiRol   IN           ADMI_ROL%ROWTYPE,
        Pn_IdRol     OUT          ADMI_ROL.ID_ROL%TYPE,
        Pv_Status    OUT          VARCHAR2,
        Pv_Code      OUT          VARCHAR2,
        Pv_Msn       OUT          VARCHAR2
    ) AS
    BEGIN
        Pn_IdRol := SEQ_ADMI_ROL.NEXTVAL;
        INSERT INTO ADMI_ROL (
            ID_ROL,
            TIPO_ROL_ID,
            DESCRIPCION_ROL,
            ESTADO,
            USR_CREACION,
            FE_CREACION,
            ES_JEFE,
            PERMITE_ASIGNACION
        ) VALUES (
            Pn_IdRol,
            Pr_AdmiRol.TIPO_ROL_ID,
            Pr_AdmiRol.DESCRIPCION_ROL,
            Pr_AdmiRol.ESTADO,
            Pr_AdmiRol.USR_CREACION,
            Pr_AdmiRol.FE_CREACION,
            Pr_AdmiRol.ES_JEFE,
            Pr_AdmiRol.PERMITE_ASIGNACION
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

END GNKG_ADMI_ROL_T;
/
