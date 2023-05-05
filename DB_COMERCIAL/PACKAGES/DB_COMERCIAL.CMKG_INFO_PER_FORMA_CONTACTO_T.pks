CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_T AS 

  /**
   * Inserta un rgistro en INFO_PERSONA_FORMA_CONTACTO
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @since 1.0 28-10-2018
   **/
    PROCEDURE P_INSERT_INFO_PER_FORM_CONT (
        Pr_InfoPerFormContacto   IN                       INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pn_IdInfoPerFrmCont      OUT                      INFO_PERSONA_FORMA_CONTACTO.ID_PERSONA_FORMA_CONTACTO%TYPE,
        Pv_Status                OUT                      VARCHAR2,
        Pv_Code                  OUT                      VARCHAR2,
        Pv_Msn                   OUT                      VARCHAR2
    );
    --
  /**
   * Inserta un rgistro en INFO_PERSONA_FORMA_CONTACTO
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @since 1.0 28-10-2018
   **/

    PROCEDURE P_UPDATE_INFO_PER_FORM_CONT (
        Pr_InfoPerFormContacto   IN                       INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pn_IdInfoPerFrmCont      IN                       INFO_PERSONA_FORMA_CONTACTO.ID_PERSONA_FORMA_CONTACTO%TYPE,
        Pv_Status                OUT                      VARCHAR2,
        Pv_Code                  OUT                      VARCHAR2,
        Pv_Msn                   OUT                      VARCHAR2
    );

END CMKG_INFO_PER_FORMA_CONTACTO_T;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_T AS

    PROCEDURE P_INSERT_INFO_PER_FORM_CONT (
        Pr_InfoPerFormContacto   IN                       INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pn_IdInfoPerFrmCont      OUT                      INFO_PERSONA_FORMA_CONTACTO.ID_PERSONA_FORMA_CONTACTO%TYPE,
        Pv_Status                OUT                      VARCHAR2,
        Pv_Code                  OUT                      VARCHAR2,
        Pv_Msn                   OUT                      VARCHAR2
    ) AS
    BEGIN
        Pn_IdInfoPerFrmCont := SEQ_INFO_PERSONA_FORMA_CONT.NEXTVAL;
        INSERT INTO INFO_PERSONA_FORMA_CONTACTO (
            ID_PERSONA_FORMA_CONTACTO,
            PERSONA_ID,
            FORMA_CONTACTO_ID,
            VALOR,
            ESTADO,
            FE_CREACION,
            USR_CREACION,
            IP_CREACION
        ) VALUES (
            Pn_IdInfoPerFrmCont,
            Pr_InfoPerFormContacto.PERSONA_ID,
            Pr_InfoPerFormContacto.FORMA_CONTACTO_ID,
            Pr_InfoPerFormContacto.VALOR,
            Pr_InfoPerFormContacto.ESTADO,
            Pr_InfoPerFormContacto.FE_CREACION,
            Pr_InfoPerFormContacto.USR_CREACION,
            Pr_InfoPerFormContacto.IP_CREACION
        );

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    END P_INSERT_INFO_PER_FORM_CONT;
  --

    PROCEDURE P_UPDATE_INFO_PER_FORM_CONT (
        Pr_InfoPerFormContacto   IN                       INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pn_IdInfoPerFrmCont      IN                       INFO_PERSONA_FORMA_CONTACTO.ID_PERSONA_FORMA_CONTACTO%TYPE,
        Pv_Status                OUT                      VARCHAR2,
        Pv_Code                  OUT                      VARCHAR2,
        Pv_Msn                   OUT                      VARCHAR2
    ) AS
    BEGIN
        UPDATE INFO_PERSONA_FORMA_CONTACTO
        SET
            PERSONA_ID = Pr_InfoPerFormContacto.PERSONA_ID,
            FORMA_CONTACTO_ID = Pr_InfoPerFormContacto.FORMA_CONTACTO_ID,
            VALOR = Pr_InfoPerFormContacto.VALOR,
            ESTADO = Pr_InfoPerFormContacto.ESTADO,
            FE_ULT_MOD = Pr_InfoPerFormContacto.FE_ULT_MOD,
            USR_ULT_MOD = Pr_InfoPerFormContacto.USR_ULT_MOD
        WHERE
            ID_PERSONA_FORMA_CONTACTO = Pn_IdInfoPerFrmCont;

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    END P_UPDATE_INFO_PER_FORM_CONT;

END CMKG_INFO_PER_FORMA_CONTACTO_T;
/
