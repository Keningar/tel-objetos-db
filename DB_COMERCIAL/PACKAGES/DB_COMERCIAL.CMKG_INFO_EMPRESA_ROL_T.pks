CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_T AS 

    /**
     * Inserta registro en INFO_EMPRESA_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 28-10-2018
     **/
    PROCEDURE P_INSERT_INFO_EMPRESA_ROL (
        Pr_InfoEmpresaRol   IN                  INFO_EMPRESA_ROL%ROWTYPE,
        Pn_IdEmpresaRol     OUT                 INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE,
        Pv_Status           OUT                 VARCHAR2,
        Pv_Code             OUT                 VARCHAR2,
        Pv_Msn              OUT                 VARCHAR2
    );

END CMKG_INFO_EMPRESA_ROL_T;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_T AS

    PROCEDURE P_INSERT_INFO_EMPRESA_ROL (
        Pr_InfoEmpresaRol   IN                  INFO_EMPRESA_ROL%ROWTYPE,
        Pn_IdEmpresaRol     OUT                 INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE,
        Pv_Status           OUT                 VARCHAR2,
        Pv_Code             OUT                 VARCHAR2,
        Pv_Msn              OUT                 VARCHAR2
    ) AS
    BEGIN
        Pn_IdEmpresaRol := SEQ_INFO_EMPRESA_ROL.NEXTVAL;
        INSERT INTO INFO_EMPRESA_ROL (
            ID_EMPRESA_ROL,
            EMPRESA_COD,
            ROL_ID,
            ESTADO,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION
        ) VALUES (
            Pn_IdEmpresaRol,
            Pr_InfoEmpresaRol.EMPRESA_COD,
            Pr_InfoEmpresaRol.ROL_ID,
            Pr_InfoEmpresaRol.ESTADO,
            Pr_InfoEmpresaRol.USR_CREACION,
            Pr_InfoEmpresaRol.FE_CREACION,
            Pr_InfoEmpresaRol.IP_CREACION
        );

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_INFO_EMPRESA_ROL;

END CMKG_INFO_EMPRESA_ROL_T;
/
