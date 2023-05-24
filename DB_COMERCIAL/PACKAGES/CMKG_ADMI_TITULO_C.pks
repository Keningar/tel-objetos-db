CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_ADMI_TITULO_C AS 

    /**
     * Contiene consultas al objeto ADMI_TITULO
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_TITULO_BY_CODIGO (
        Pv_Codigo       IN              ADMI_TITULO.CODIGO%TYPE,
        Pr_AdmiTitulo   OUT             ADMI_TITULO%ROWTYPE,
        Pv_Status       OUT             VARCHAR2,
        Pv_Code         OUT             VARCHAR2,
        Pv_Msn          OUT             VARCHAR2
    );

END CMKG_ADMI_TITULO_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_ADMI_TITULO_C AS

    PROCEDURE P_GET_TITULO_BY_CODIGO (
        Pv_Codigo       IN              ADMI_TITULO.CODIGO%TYPE,
        Pr_AdmiTitulo   OUT             ADMI_TITULO%ROWTYPE,
        Pv_Status       OUT             VARCHAR2,
        Pv_Code         OUT             VARCHAR2,
        Pv_Msn          OUT             VARCHAR2
    ) AS

        /**
          * C_GetAdmiTitulo, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 4, cardinalidad 1
          */

        CURSOR C_GetAdmiTitulo (
            Cv_Codigo ADMI_TITULO.CODIGO%TYPE
        ) IS
        SELECT
            TIT.*
        FROM
            ADMI_TITULO TIT
        WHERE
            TRIM(TIT.CODIGO) = Cv_Codigo;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetAdmiTitulo%ISOPEN THEN
            CLOSE C_GetAdmiTitulo;
        END IF;
        OPEN C_GetAdmiTitulo(Pv_Codigo);
        FETCH C_GetAdmiTitulo INTO Pr_AdmiTitulo;
        IF C_GetAdmiTitulo%NOTFOUND THEN
            CLOSE C_GetAdmiTitulo;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetAdmiTitulo;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro titulo';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro titulo';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_TITULO_BY_CODIGO;

END CMKG_ADMI_TITULO_C;
/