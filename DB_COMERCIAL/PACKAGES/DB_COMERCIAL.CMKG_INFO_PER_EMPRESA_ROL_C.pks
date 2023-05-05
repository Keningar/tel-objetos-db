CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C AS
    /**
     * Contiene consultas al objeto INFO_PERSONA_EMPRESA_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/

    /**
     * Contiene consultas al objeto INFO_PERSONA_EMPRESA_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_INFO_PERSONA_EMPR_ROL (
        Pv_Identificacion      IN                     INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        Pv_CodEmpresa          IN                     INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pr_InfoPersonaEmpRol   OUT                    V_INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    );

    /**
     * Documentacion para proceso 'P_GET_INFO_PERSONA_EMPRESA_ROL'
     *
     * Procedimiento para obtener informacion de la Empresa
     *
     * @param Pn_IdPersonaEmpresaRol    IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Recibe el id de la persona empresa rol
     * @param Pv_Estado                 IN IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE Recibe el estado de la persona empresa rol
     * @param Pr_InfoPersonaEmpresaRol  OUT INFO_PERSONA_EMPRESA_ROL%ROWTYPE Retorna registro de la persona empresa rol
     * @param Pv_Status                 OUT VARCHAR2 Retorna status de la consulta
     * @param Pv_Mensaje                OUT VARCHAR2 Retorna mensaje de la consulta
     * 
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 
     * @since   02-11-2021
     **/
    PROCEDURE P_GET_INFO_PERSONA_EMPRESA_ROL (Pn_IdPersonaEmpresaRol    IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                              Pv_Estado                 IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE,
                                              Pr_InfoPersonaEmpresaRol  OUT INFO_PERSONA_EMPRESA_ROL%ROWTYPE,
                                              Pv_Status                 OUT VARCHAR2,
                                              Pv_Mensaje                OUT VARCHAR2);

END CMKG_INFO_PER_EMPRESA_ROL_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_OFICINA_GRUPO_C AS

    PROCEDURE P_GET_INFO_OFICINA_GRUPO (
        Pn_IdOficina          IN                    INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        Pn_IdEmpresa          IN                    INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
        Pv_Estado             IN                    INFO_OFICINA_GRUPO.ESTADO%TYPE,
        Pr_InfoOficinaGrupo   OUT                   INFO_OFICINA_GRUPO%ROWTYPE,
        Pv_Status             OUT                   VARCHAR2,
        Pv_Code               OUT                   VARCHAR2,
        Pv_Msn                OUT                   VARCHAR2
    ) AS
 
        /**
          * C_GetInfoOficinaGrupo, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 1, cardinalidad 1
          */

        CURSOR C_GetInfoOficinaGrupo (
            Cn_IdOficina   INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
            Cn_IdEmpresa   INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
            Cv_Estado      INFO_OFICINA_GRUPO.ESTADO%TYPE
        ) IS
        SELECT
            IOG.*
        FROM
            INFO_OFICINA_GRUPO IOG
        WHERE
            IOG.ID_OFICINA = Cn_IdOficina
            AND IOG.EMPRESA_ID = Cn_IdEmpresa
            AND IOG.ESTADO = Cv_Estado;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetInfoOficinaGrupo%ISOPEN THEN
            CLOSE C_GetInfoOficinaGrupo;
        END IF;
        OPEN C_GetInfoOficinaGrupo(Pn_IdOficina, Pn_IdEmpresa, Pv_Estado);
        FETCH C_GetInfoOficinaGrupo INTO Pr_InfoOficinaGrupo;
        IF C_GetInfoOficinaGrupo%NOTFOUND THEN
            CLOSE C_GetInfoOficinaGrupo;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetInfoOficinaGrupo;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro oficina';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro oficina';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_INFO_OFICINA_GRUPO;

END CMKG_INFO_OFICINA_GRUPO_C;
/
