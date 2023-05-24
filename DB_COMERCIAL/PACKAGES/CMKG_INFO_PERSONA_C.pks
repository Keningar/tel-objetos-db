CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PERSONA_C AS  
  /**
   * CMKG_INFO_PERSONA_C
   * Contiene las consultas a INFO_PERSONA
   * @author Alexander Samaniego <awsamaneigo@telconet.ec>
   * @since 1.0 28-10-2018
   **/ 
   
   /**
    * Obtien un registro por identificacion de INFO_PERSONA
    * @author Alexander Samaniego <awsamaneigo@telconet.ec>
    * @since 1.0 28-10-2018
    * @param Pv_Identificacion   IN                  INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE, Identificacion de la persona para la busqueda
    * @param Pr_InfoPersona      OUT                 CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona, Los dato de la persona
    * @param Pv_Status           OUT                 VARCHAR2, Estatus de la consulta
    * @param Pv_Code             OUT                 VARCHAR2, Codigo de la consulta
    * @param Pv_Msn              OUT                 VARCHAR2  Mensaje de la consulta
    **/
    PROCEDURE P_FIND_PERSONA_BY_IDENT (
        Pv_Identificacion   IN                  INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        Pr_InfoPersona      OUT                 CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pv_Status           OUT                 VARCHAR2,
        Pv_Code             OUT                 VARCHAR2,
        Pv_Msn              OUT                 VARCHAR2
    );


END CMKG_INFO_PERSONA_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PERSONA_C AS

    PROCEDURE P_FIND_PERSONA_BY_IDENT (
        Pv_Identificacion   IN                  INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        Pr_InfoPersona      OUT                 CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pv_Status           OUT                 VARCHAR2,
        Pv_Code             OUT                 VARCHAR2,
        Pv_Msn              OUT                 VARCHAR2
    ) AS

        /**
          * C_GetInfoPersona, obtiene un registro por identificacion
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 5, cardinalidad 1
          */

        CURSOR C_GetInfoPersona (
            Cv_Identificacion INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE
        ) IS
        SELECT
            IP.*
        FROM
            INFO_PERSONA IP
        WHERE
            IP.IDENTIFICACION_CLIENTE = Cv_Identificacion;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetInfoPersona%ISOPEN THEN
            CLOSE C_GetInfoPersona;
        END IF;
        OPEN C_GetInfoPersona(Pv_Identificacion);
        FETCH C_GetInfoPersona INTO Pr_InfoPersona;
        IF C_GetInfoPersona%NOTFOUND THEN
            CLOSE C_GetInfoPersona;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetInfoPersona;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro persona';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro persona';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_FIND_PERSONA_BY_IDENT;

END CMKG_INFO_PERSONA_C;
/