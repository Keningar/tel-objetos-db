CREATE EDITIONABLE PACKAGE            GNKG_ADMI_ROL_C AS 

    /**
     * Contiene consultas al objeto ADMI_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_ADMI_ROL (
        Pv_Descripcion   IN               ADMI_ROL.DESCRIPCION_ROL%TYPE,
        Pn_TipoRol       IN               ADMI_ROL.TIPO_ROL_ID%TYPE,
        Pr_AdmiRol       OUT              ADMI_ROL%ROWTYPE,
        Pv_Status        OUT              VARCHAR2,
        Pv_Code          OUT              VARCHAR2,
        Pv_Msn           OUT              VARCHAR2
    );

END GNKG_ADMI_ROL_C;
/

CREATE EDITIONABLE PACKAGE BODY            GNKG_ADMI_ROL_C AS

    PROCEDURE P_GET_ADMI_ROL (
        Pv_Descripcion   IN               ADMI_ROL.DESCRIPCION_ROL%TYPE,
        Pn_TipoRol       IN               ADMI_ROL.TIPO_ROL_ID%TYPE,
        Pr_AdmiRol       OUT              ADMI_ROL%ROWTYPE,
        Pv_Status        OUT              VARCHAR2,
        Pv_Code          OUT              VARCHAR2,
        Pv_Msn           OUT              VARCHAR2
    ) AS

        /**
          * C_GetAdmiRol, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 3, cardinalidad 1
          */

        CURSOR C_GetAdmiRol (
            Cv_Descripcion   ADMI_ROL.DESCRIPCION_ROL%TYPE,
            Cn_TipoRol       ADMI_ROL.TIPO_ROL_ID%TYPE
        ) IS
        SELECT
            AR.*
        FROM
            ADMI_ROL AR
        WHERE
            UPPER(TRIM(AR.DESCRIPCION_ROL)) = UPPER(TRIM(Cv_Descripcion))
            AND AR.TIPO_ROL_ID = Cn_TipoRol;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetAdmiRol%ISOPEN THEN
            CLOSE C_GetAdmiRol;
        END IF;
        OPEN C_GetAdmiRol(Pv_Descripcion, Pn_TipoRol);
        FETCH C_GetAdmiRol INTO Pr_AdmiRol;
        IF C_GetAdmiRol%NOTFOUND THEN
            CLOSE C_GetAdmiRol;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetAdmiRol;
        Pv_Status := GNKG_RESULT.FOUND_STATUS;
        Pv_Code := GNKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro rol';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := GNKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := GNKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro rol';
        WHEN OTHERS THEN
            Pv_Status := GNKG_RESULT.FAILED_STATUS;
            Pv_Code := GNKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_ADMI_ROL;

END GNKG_ADMI_ROL_C;
/