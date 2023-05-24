CREATE OR REPLACE PACKAGE DB_GENERAL.GNKG_ADMI_DEPARTAMENTO_C AS 

    /**
     * Contiene consultas al objeto ADMI_DEPARTAMENTO
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_ADMI_DEPARTAMENTO (
        Pv_NombreDepartamento   IN                      ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
        Pv_EmpresaCod           IN                      ADMI_DEPARTAMENTO.EMPRESA_COD%TYPE,
        Pr_AdmiDeparatamento    OUT                     ADMI_DEPARTAMENTO%ROWTYPE,
        Pv_Status               OUT                     VARCHAR2,
        Pv_Code                 OUT                     VARCHAR2,
        Pv_Msn                  OUT                     VARCHAR2
    );

END GNKG_ADMI_DEPARTAMENTO_C;
/

CREATE OR REPLACE PACKAGE BODY DB_GENERAL.GNKG_ADMI_DEPARTAMENTO_C AS

    PROCEDURE P_GET_ADMI_DEPARTAMENTO (
        Pv_NombreDepartamento   IN                      ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
        Pv_EmpresaCod           IN                      ADMI_DEPARTAMENTO.EMPRESA_COD%TYPE,
        Pr_AdmiDeparatamento    OUT                     ADMI_DEPARTAMENTO%ROWTYPE,
        Pv_Status               OUT                     VARCHAR2,
        Pv_Code                 OUT                     VARCHAR2,
        Pv_Msn                  OUT                     VARCHAR2
    ) AS

        /**
          * C_GetAdmiDepartamento, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 3, cardinalidad 1
          */

        CURSOR C_GetAdmiDepartamento (
            Cv_NombreDepartamento   ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
            Cv_EmpresaCod           ADMI_DEPARTAMENTO.EMPRESA_COD%TYPE
        ) IS
        SELECT
            AD.*
        FROM
            ADMI_DEPARTAMENTO AD
        WHERE
            AD.EMPRESA_COD = Cv_EmpresaCod
            AND UPPER(TRIM(AD.NOMBRE_DEPARTAMENTO)) = UPPER(TRIM(Cv_NombreDepartamento));

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetAdmiDepartamento%ISOPEN THEN
            CLOSE C_GetAdmiDepartamento;
        END IF;
        OPEN C_GetAdmiDepartamento(Pv_NombreDepartamento, Pv_EmpresaCod);
        FETCH C_GetAdmiDepartamento INTO Pr_AdmiDeparatamento;
        IF C_GetAdmiDepartamento%NOTFOUND THEN
            CLOSE C_GetAdmiDepartamento;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetAdmiDepartamento;
        Pv_Status := GNKG_RESULT.FOUND_STATUS;
        Pv_Code := GNKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro departamento';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := GNKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := GNKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro departamento';
        WHEN OTHERS THEN
            Pv_Status := GNKG_RESULT.FAILED_STATUS;
            Pv_Code := GNKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_ADMI_DEPARTAMENTO;

END GNKG_ADMI_DEPARTAMENTO_C;
/
