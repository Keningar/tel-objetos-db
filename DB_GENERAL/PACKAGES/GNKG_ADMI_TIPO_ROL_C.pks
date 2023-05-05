CREATE EDITIONABLE PACKAGE            GNKG_ADMI_TIPO_ROL_C AS 

    /**
     * Contiene consultas al objeto ADMI_TIPO_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_ADMI_TIPO_ROL (
        Pv_Descripcion   IN               ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
        Pr_AdmiTipoRol   OUT              ADMI_TIPO_ROL%ROWTYPE,
        Pv_Status        OUT              VARCHAR2,
        Pv_Code          OUT              VARCHAR2,
        Pv_Msn           OUT              VARCHAR2
    );

END GNKG_ADMI_TIPO_ROL_C;
/

CREATE EDITIONABLE PACKAGE BODY            GNKG_ADMI_TIPO_ROL_C AS

    PROCEDURE P_GET_ADMI_TIPO_ROL (
        Pv_Descripcion   IN               ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
        Pr_AdmiTipoRol   OUT              ADMI_TIPO_ROL%ROWTYPE,
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

        CURSOR C_GetAdmiTipoRol (
            Pv_Descripcion ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE
        ) IS
        SELECT
            ATR.*
        FROM
            ADMI_TIPO_ROL ATR
        WHERE
            ATR.DESCRIPCION_TIPO_ROL = UPPER(TRIM(Pv_Descripcion));

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetAdmiTipoRol%ISOPEN THEN
            CLOSE C_GetAdmiTipoRol;
        END IF;
        OPEN C_GetAdmiTipoRol(Pv_Descripcion);
        FETCH C_GetAdmiTipoRol INTO Pr_AdmiTipoRol;
        IF C_GetAdmiTipoRol%NOTFOUND THEN
            CLOSE C_GetAdmiTipoRol;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetAdmiTipoRol;
        Pv_Status := GNKG_RESULT.FOUND_STATUS;
        Pv_Code := GNKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro tipo rol';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := GNKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := GNKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro tipo rol';
        WHEN OTHERS THEN
            Pv_Status := GNKG_RESULT.FAILED_STATUS;
            Pv_Code := GNKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_ADMI_TIPO_ROL;

END GNKG_ADMI_TIPO_ROL_C;
/