CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_ADMI_FORMA_CONTACTO_C AS 

    /**
     * Contiene consultas al objeto P_GET_ADMI_FORMA_CONTACTO
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_ADMI_FORMA_CONTACTO (
        Pv_Codigo              IN                     ADMI_FORMA_CONTACTO.CODIGO%TYPE,
        Pr_AdmiFormaContacto   OUT                    ADMI_FORMA_CONTACTO%ROWTYPE,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    );

END CMKG_ADMI_FORMA_CONTACTO_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_ADMI_FORMA_CONTACTO_C AS

    PROCEDURE P_GET_ADMI_FORMA_CONTACTO (
        Pv_Codigo              IN                     ADMI_FORMA_CONTACTO.CODIGO%TYPE,
        Pr_AdmiFormaContacto   OUT                    ADMI_FORMA_CONTACTO%ROWTYPE,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    ) AS
  

        /**
          * C_GetAdmiFormaContacto, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 3, cardinalidad 1
          */

        CURSOR C_GetAdmiFormaContacto (
            Cv_Codigo ADMI_FORMA_CONTACTO.CODIGO%TYPE
        ) IS
        SELECT
            AFC.*
        FROM
            ADMI_FORMA_CONTACTO AFC
        WHERE
            AFC.CODIGO = Cv_Codigo;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetAdmiFormaContacto%ISOPEN THEN
            CLOSE C_GetAdmiFormaContacto;
        END IF;
        OPEN C_GetAdmiFormaContacto(Pv_Codigo);
        FETCH C_GetAdmiFormaContacto INTO Pr_AdmiFormaContacto;
        IF C_GetAdmiFormaContacto%NOTFOUND THEN
            CLOSE C_GetAdmiFormaContacto;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetAdmiFormaContacto;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro forma contacto';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro forma contacto';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_ADMI_FORMA_CONTACTO;

END CMKG_ADMI_FORMA_CONTACTO_C;
/