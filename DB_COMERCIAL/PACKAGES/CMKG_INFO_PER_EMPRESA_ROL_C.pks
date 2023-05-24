CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C AS

    PROCEDURE P_GET_INFO_PERSONA_EMPR_ROL (
        Pv_Identificacion      IN                     INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        Pv_CodEmpresa          IN                     INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pr_InfoPersonaEmpRol   OUT                    V_INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    ) AS

        /**
          * C_GetInfoPersona, obtiene un registro por identificacion
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 5, cardinalidad 1
          */

        CURSOR C_GetInfoPersonaPersonEmpRol (
            Cv_Identificacion   INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
            Cv_CodEmpresa       INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
        ) IS
        SELECT
            V_PER.*
        FROM
            V_INFO_PERSONA_EMPRESA_ROL V_PER
        WHERE
            V_PER.IEG_COD_EMPRESA = Cv_CodEmpresa
            AND V_PER.PER_IDENTIFICACION_CLIENTE = Cv_Identificacion;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetInfoPersonaPersonEmpRol%ISOPEN THEN
            CLOSE C_GetInfoPersonaPersonEmpRol;
        END IF;
        OPEN C_GetInfoPersonaPersonEmpRol(Pv_Identificacion, Pv_CodEmpresa);
        FETCH C_GetInfoPersonaPersonEmpRol INTO Pr_InfoPersonaEmpRol;
        IF C_GetInfoPersonaPersonEmpRol%NOTFOUND THEN
            CLOSE C_GetInfoPersonaPersonEmpRol;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetInfoPersonaPersonEmpRol;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro persona empresa rol';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro persona empresa rol';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_INFO_PERSONA_EMPR_ROL;

    PROCEDURE P_GET_INFO_PERSONA_EMPRESA_ROL (Pn_IdPersonaEmpresaRol    IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                              Pv_Estado                 IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE,
                                              Pr_InfoPersonaEmpresaRol  OUT INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
                                              Pv_Status                 OUT VARCHAR2,
                                              Pv_Mensaje                OUT VARCHAR2) AS
       /**
        * C_GetInfoPersonaEmprRol, obtiene un registro por idPersonaEmpresaRol y estado
        * @author David De La Cruz <ddelacruz@telconet.ec>
        * @version 1.0 
        * @since 02-11-2021
        * @costo 3, cardinalidad 1
        */
      CURSOR C_GetInfoPersonaEmprRol(Cn_IdPersonaEmpresaRol INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Cv_Estado              INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE) IS
        SELECT
            IPER.*
        FROM
            INFO_PERSONA_EMPRESA_ROL IPER
        WHERE
            IPER.ID_PERSONA_ROL = Cn_IdPersonaEmpresaRol
        AND IPER.ESTADO = Cv_Estado;  

      Le_NotFound EXCEPTION;
    BEGIN
      IF C_GetInfoPersonaEmprRol%ISOPEN THEN
          CLOSE C_GetInfoPersonaEmprRol;
      END IF;

      OPEN C_GetInfoPersonaEmprRol(Pn_IdPersonaEmpresaRol, Pv_Estado);
      FETCH C_GetInfoPersonaEmprRol INTO Pr_InfoPersonaEmpresaRol;
        IF C_GetInfoPersonaEmprRol%NOTFOUND THEN
          CLOSE C_GetInfoPersonaEmprRol;
          RAISE Le_NotFound;
        END IF;
      CLOSE C_GetInfoPersonaEmprRol;

      Pv_Status := 'OK';
      Pv_Mensaje := 'Se encontro persona empresa rol';
    EXCEPTION
      WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro persona empresa rol';
      WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
    END;

END CMKG_INFO_PER_EMPRESA_ROL_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C AS

    PROCEDURE P_GET_INFO_PERSONA_EMPR_ROL (
        Pv_Identificacion      IN                     INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        Pv_CodEmpresa          IN                     INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pr_InfoPersonaEmpRol   OUT                    V_INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    ) AS

        /**
          * C_GetInfoPersona, obtiene un registro por identificacion
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 5, cardinalidad 1
          */

        CURSOR C_GetInfoPersonaPersonEmpRol (
            Cv_Identificacion   INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
            Cv_CodEmpresa       INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
        ) IS
        SELECT
            V_PER.*
        FROM
            V_INFO_PERSONA_EMPRESA_ROL V_PER
        WHERE
            V_PER.IEG_COD_EMPRESA = Cv_CodEmpresa
            AND V_PER.PER_IDENTIFICACION_CLIENTE = Cv_Identificacion;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetInfoPersonaPersonEmpRol%ISOPEN THEN
            CLOSE C_GetInfoPersonaPersonEmpRol;
        END IF;
        OPEN C_GetInfoPersonaPersonEmpRol(Pv_Identificacion, Pv_CodEmpresa);
        FETCH C_GetInfoPersonaPersonEmpRol INTO Pr_InfoPersonaEmpRol;
        IF C_GetInfoPersonaPersonEmpRol%NOTFOUND THEN
            CLOSE C_GetInfoPersonaPersonEmpRol;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetInfoPersonaPersonEmpRol;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro persona empresa rol';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro persona empresa rol';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_INFO_PERSONA_EMPR_ROL;

    PROCEDURE P_GET_INFO_PERSONA_EMPRESA_ROL (Pn_IdPersonaEmpresaRol    IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                              Pv_Estado                 IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE,
                                              Pr_InfoPersonaEmpresaRol  OUT INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
                                              Pv_Status                 OUT VARCHAR2,
                                              Pv_Mensaje                OUT VARCHAR2) AS
       /**
        * C_GetInfoPersonaEmprRol, obtiene un registro por idPersonaEmpresaRol y estado
        * @author David De La Cruz <ddelacruz@telconet.ec>
        * @version 1.0 
        * @since 02-11-2021
        * @costo 3, cardinalidad 1
        */
      CURSOR C_GetInfoPersonaEmprRol(Cn_IdPersonaEmpresaRol INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Cv_Estado              INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE) IS
        SELECT
            IPER.*
        FROM
            INFO_PERSONA_EMPRESA_ROL IPER
        WHERE
            IPER.ID_PERSONA_ROL = Cn_IdPersonaEmpresaRol
        AND IPER.ESTADO = Cv_Estado;  

      Le_NotFound EXCEPTION;
    BEGIN
      IF C_GetInfoPersonaEmprRol%ISOPEN THEN
          CLOSE C_GetInfoPersonaEmprRol;
      END IF;

      OPEN C_GetInfoPersonaEmprRol(Pn_IdPersonaEmpresaRol, Pv_Estado);
      FETCH C_GetInfoPersonaEmprRol INTO Pr_InfoPersonaEmpresaRol;
        IF C_GetInfoPersonaEmprRol%NOTFOUND THEN
          CLOSE C_GetInfoPersonaEmprRol;
          RAISE Le_NotFound;
        END IF;
      CLOSE C_GetInfoPersonaEmprRol;

      Pv_Status := 'OK';
      Pv_Mensaje := 'Se encontro persona empresa rol';
    EXCEPTION
      WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro persona empresa rol';
      WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
    END;

END CMKG_INFO_PER_EMPRESA_ROL_C;
/