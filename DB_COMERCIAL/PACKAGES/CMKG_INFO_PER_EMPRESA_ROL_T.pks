CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_T AS 
    
    /**
     * Inserta registro en INFO_PERSONA_EMPRESA_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 28-10-2018
     **/
    PROCEDURE P_INSERT_INFO_PER_EMPRESA_ROL (
        Pr_InfoPerEmpRol   IN                 INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pn_IdPerEmpRol     OUT                INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );
    
    /**
     * Actualiza registro en INFO_PERSONA_EMPRESA_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 28-10-2018
     **/

    PROCEDURE P_UPDATE_INFO_PER_EMPRESA_ROL (
        Pr_InfoPerEmpRol   IN                 INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pn_IdPerEmpRol     IN                 INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

END CMKG_INFO_PER_EMPRESA_ROL_T;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_T AS

    PROCEDURE P_INSERT_INFO_PER_EMPRESA_ROL (
        Pr_InfoPerEmpRol   IN                 INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pn_IdPerEmpRol     OUT                INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
    BEGIN
        Pn_IdPerEmpRol := SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL;
        INSERT INTO INFO_PERSONA_EMPRESA_ROL (
            ID_PERSONA_ROL,
            PERSONA_ID,
            EMPRESA_ROL_ID,
            OFICINA_ID,
            DEPARTAMENTO_ID,
            ESTADO,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            CUADRILLA_ID,
            PERSONA_EMPRESA_ROL_ID,
            PERSONA_EMPRESA_ROL_ID_TTCO,
            REPORTA_PERSONA_EMPRESA_ROL_ID,
            ES_PREPAGO
        ) VALUES (
            Pn_IdPerEmpRol,
            Pr_InfoPerEmpRol.PERSONA_ID,
            Pr_InfoPerEmpRol.EMPRESA_ROL_ID,
            Pr_InfoPerEmpRol.OFICINA_ID,
            Pr_InfoPerEmpRol.DEPARTAMENTO_ID,
            Pr_InfoPerEmpRol.ESTADO,
            Pr_InfoPerEmpRol.USR_CREACION,
            Pr_InfoPerEmpRol.FE_CREACION,
            Pr_InfoPerEmpRol.IP_CREACION,
            Pr_InfoPerEmpRol.CUADRILLA_ID,
            Pr_InfoPerEmpRol.PERSONA_EMPRESA_ROL_ID,
            Pr_InfoPerEmpRol.PERSONA_EMPRESA_ROL_ID_TTCO,
            Pr_InfoPerEmpRol.REPORTA_PERSONA_EMPRESA_ROL_ID,
            Pr_InfoPerEmpRol.ES_PREPAGO
        );

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_INFO_PER_EMPRESA_ROL;

    PROCEDURE P_UPDATE_INFO_PER_EMPRESA_ROL (
        Pr_InfoPerEmpRol   IN                 INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pn_IdPerEmpRol     IN                 INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
    BEGIN
        UPDATE INFO_PERSONA_EMPRESA_ROL
        SET
            PERSONA_ID = Pr_InfoPerEmpRol.PERSONA_ID,
            EMPRESA_ROL_ID = Pr_InfoPerEmpRol.EMPRESA_ROL_ID,
            OFICINA_ID = Pr_InfoPerEmpRol.OFICINA_ID,
            DEPARTAMENTO_ID = Pr_InfoPerEmpRol.DEPARTAMENTO_ID,
            ESTADO = Pr_InfoPerEmpRol.ESTADO,
            CUADRILLA_ID = Pr_InfoPerEmpRol.CUADRILLA_ID,
            PERSONA_EMPRESA_ROL_ID = Pr_InfoPerEmpRol.PERSONA_EMPRESA_ROL_ID,
            PERSONA_EMPRESA_ROL_ID_TTCO = Pr_InfoPerEmpRol.PERSONA_EMPRESA_ROL_ID_TTCO,
            REPORTA_PERSONA_EMPRESA_ROL_ID = Pr_InfoPerEmpRol.REPORTA_PERSONA_EMPRESA_ROL_ID,
            ES_PREPAGO = Pr_InfoPerEmpRol.ES_PREPAGO,
            USR_ULT_MOD = Pr_InfoPerEmpRol.USR_ULT_MOD,
            FE_ULT_MOD = Pr_InfoPerEmpRol.FE_ULT_MOD
        WHERE
            ID_PERSONA_ROL = Pn_IdPerEmpRol;

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia modificada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_UPDATE_INFO_PER_EMPRESA_ROL;

END CMKG_INFO_PER_EMPRESA_ROL_T;
/