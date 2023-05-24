CREATE OR REPLACE PACKAGE DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T AS 

    /**
     * Inserta perfil persona 
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_INSERT_PERFIL_PERSONA (
        Pr_PerfilPersona   IN                 DB_SEGURIDAD.SEGU_PERFIL_PERSONA%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

    /**
     * Elimina perfil persona 
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/

    PROCEDURE P_DELETE_PERFIL_PERSONA (
        Pr_PerfilPersona   IN                 NUMBER,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

    /**
     * Inserta perfil persona para la sincronizacion de empleados NAF TELCOS
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/

    PROCEDURE P_INSERT_PERFIL_PER_SINC_EMPL (
        Pv_NoCia       IN             VARCHAR2,
        Pv_IdPersona   IN             DB_SEGURIDAD.SEGU_PERFIL_PERSONA.PERSONA_ID%TYPE,
        Pn_IdOficina   IN             DB_SEGURIDAD.SEGU_PERFIL_PERSONA.OFICINA_ID%TYPE,
        Pv_User        IN             VARCHAR2,
        Pv_Status      OUT            VARCHAR2,
        Pv_Code        OUT            VARCHAR2,
        Pv_Msn         OUT            VARCHAR2
    );

END SEKG_SEGU_PERFIL_PERSONA_T;
/

CREATE OR REPLACE PACKAGE BODY DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T AS

    PROCEDURE P_INSERT_PERFIL_PERSONA (
        Pr_PerfilPersona   IN                 DB_SEGURIDAD.SEGU_PERFIL_PERSONA%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
    BEGIN
        INSERT INTO DB_SEGURIDAD.SEGU_PERFIL_PERSONA (
            PERFIL_ID,
            PERSONA_ID,
            OFICINA_ID,
            EMPRESA_ID,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION
        ) VALUES (
            Pr_PerfilPersona.PERFIL_ID,
            Pr_PerfilPersona.PERSONA_ID,
            Pr_PerfilPersona.OFICINA_ID,
            Pr_PerfilPersona.EMPRESA_ID,
            Pr_PerfilPersona.USR_CREACION,
            Pr_PerfilPersona.FE_CREACION,
            Pr_PerfilPersona.IP_CREACION
        );

        Pv_Status := SEKG_RESULT.GENERATED_STATUS;
        Pv_Code := SEKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := SEKG_RESULT.FAILED_STATUS;
            Pv_Code := SEKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_PERFIL_PERSONA;

    PROCEDURE P_DELETE_PERFIL_PERSONA (
        Pr_PerfilPersona   IN                 NUMBER,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
    BEGIN
        DELETE FROM DB_SEGURIDAD.SEGU_PERFIL_PERSONA
        WHERE
            PERSONA_ID = Pr_PerfilPersona;

        Pv_Status := SEKG_RESULT.DELETED_STATUS;
        Pv_Code := SEKG_RESULT.DELETED_CODE;
        Pv_Msn := 'Instancia eliminada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := SEKG_RESULT.FAILED_STATUS;
            Pv_Code := SEKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_DELETE_PERFIL_PERSONA;

    PROCEDURE P_INSERT_PERFIL_PER_SINC_EMPL (
        Pv_NoCia       IN             VARCHAR2,
        Pv_IdPersona   IN             DB_SEGURIDAD.SEGU_PERFIL_PERSONA.PERSONA_ID%TYPE,
        Pn_IdOficina   IN             DB_SEGURIDAD.SEGU_PERFIL_PERSONA.OFICINA_ID%TYPE,
        Pv_User        IN             VARCHAR2,
        Pv_Status      OUT            VARCHAR2,
        Pv_Code        OUT            VARCHAR2,
        Pv_Msn         OUT            VARCHAR2
    ) AS
        /**
         * Obtiene los parametros a insertar en la sincronizacion de empleados
         * @costo 11, cardinalidad 1
         **/

        CURSOR C_GetPerfilFromAdmiParam (
            Cv_NombreParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
            Cv_EstadoCab         DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
            Cv_EstadoDet         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
        ) IS
        SELECT
            SP.*
        FROM
            SIST_PERFIL SP,
            DB_GENERAL.ADMI_PARAMETRO_DET APD,
            DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE
            APD.PARAMETRO_ID = APC.ID_PARAMETRO
            AND SP.NOMBRE_PERFIL = APD.VALOR1
            AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
            AND APD.ESTADO = Cv_EstadoCab
            AND APC.ESTADO = Cv_EstadoDet;

        Lr_PerfilPersona   DB_SEGURIDAD.SEGU_PERFIL_PERSONA%ROWTYPE;
        Lv_Status          VARCHAR2(100);
        Lv_Code            VARCHAR2(5);
        Lv_Msn             VARCHAR2(4000);
    BEGIN
        Lr_PerfilPersona.PERSONA_ID := Pv_IdPersona;
        Lr_PerfilPersona.OFICINA_ID := Pn_IdOficina;
        Lr_PerfilPersona.EMPRESA_ID := Pv_NoCia;
        Lr_PerfilPersona.USR_CREACION := Pv_User;
        Lr_PerfilPersona.FE_CREACION := SYSDATE;
        Lr_PerfilPersona.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        FOR I_Perfil IN C_GetPerfilFromAdmiParam('PERFILES_DEFAULT_SINCRONIZACION_EMPLEADOS', 'Activo', 'Activo') LOOP
            Lr_PerfilPersona.PERFIL_ID := I_Perfil.ID_PERFIL;
            P_INSERT_PERFIL_PERSONA(Lr_PerfilPersona, Lv_Status, Lv_Code, Lv_Msn);
            Pv_Msn := Pv_Msn
                      || ' Perfil: '
                      || Lr_PerfilPersona.PERFIL_ID
                      || ' Status: '
                      || Lv_Status;

        END LOOP;

        Pv_Status := SEKG_RESULT.GENERATED_STATUS;
        Pv_Code := SEKG_RESULT.GENERATED_CODE;
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := SEKG_RESULT.FAILED_STATUS;
            Pv_Code := SEKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_PERFIL_PER_SINC_EMPL;

END SEKG_SEGU_PERFIL_PERSONA_T;
/
