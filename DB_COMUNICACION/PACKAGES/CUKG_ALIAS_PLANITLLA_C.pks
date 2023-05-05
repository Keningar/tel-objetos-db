CREATE OR REPLACE PACKAGE                 CUKG_ALIAS_PLANITLLA_C AS
   
    /**
     * Obtiene la plantilla y alias por el codigo de la plantilla
     * @param Pv_CodePlantilla     IN          ADMI_PLANTILLA.CODIGO%TYPE Codigo de plantilla
     * @param Pv_Plantilla         OUT         VARCHAR2 Estado del proceso
     * @param Pv_Alias             OUT         VARCHAR2 Estado del proceso
     * @param Pv_Status            OUT         VARCHAR2 Estado del proceso
     * @param Pv_Code              OUT         VARCHAR2 Codigo de estado
     * @param Pv_Msn               OUT         VARCHAR2 Mensaje de proceso
     **/
    PROCEDURE P_GET_ALIAS_PLANTILLA (
        Pv_CodePlantilla   IN                 VARCHAR2,
        Pv_Plantilla       OUT                CLOB,
        Pv_Alias           OUT                VARCHAR2,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

END CUKG_ALIAS_PLANITLLA_C;
/


CREATE OR REPLACE PACKAGE BODY                 CUKG_ALIAS_PLANITLLA_C AS

    PROCEDURE P_GET_ALIAS_PLANTILLA (
        Pv_CodePlantilla   IN                 VARCHAR2,
        Pv_Plantilla       OUT                CLOB,
        Pv_Alias           OUT                VARCHAR2,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
        /**
          * C_GetAliasPlantilla, obtiene la plantilla
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 2, cardinalidad 1
          */

        CURSOR C_GetPlantilla (
            Cv_CodePlantilla VARCHAR2,
            Cv_Estado VARCHAR2
        ) IS
        SELECT
            ID_PLANTILLA,
            PLANTILLA
        FROM
            ADMI_PLANTILLA
        WHERE
            CODIGO = Cv_CodePlantilla
            AND ESTADO <> Cv_Estado;

        CURSOR C_GetAliasPlantilla (
            Cn_IdPlantilla   INFO_ALIAS_PLANTILLA.PLANTILLA_ID%TYPE,
            Cv_Estado        VARCHAR2
        ) IS
        SELECT
            AL.VALOR
        FROM
            INFO_ALIAS_PLANTILLA IAP,
            ADMI_ALIAS AL
        WHERE
            IAP.ALIAS_ID = AL.ID_ALIAS
            AND IAP.ESTADO <> Cv_Estado
            AND AL.ESTADO <> Cv_Estado
            AND AL.VALOR IS NOT NULL
            AND IAP.PLANTILLA_ID = Cn_IdPlantilla;

        Lc_GetAliasPlantilla   C_GetAliasPlantilla%ROWTYPE;
        Lc_GetPlantilla        C_GetPlantilla%ROWTYPE;
        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetPlantilla%ISOPEN THEN
            CLOSE C_GetPlantilla;
        END IF;
        OPEN C_GetPlantilla(Pv_CodePlantilla, 'Eliminado');
        FETCH C_GetPlantilla INTO Lc_GetPlantilla;
        IF C_GetPlantilla%NOTFOUND THEN
            CLOSE C_GetAliasPlantilla;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetPlantilla;
        Pv_Plantilla := Lc_GetPlantilla.PLANTILLA;
        IF C_GetAliasPlantilla%ISOPEN THEN
            CLOSE C_GetAliasPlantilla;
        END IF;
        FOR I_Alias IN C_GetAliasPlantilla(Lc_GetPlantilla.ID_PLANTILLA, 'Eliminado') LOOP
            Pv_Alias := Pv_Alias
                        || I_Alias.VALOR
                        || ';';
        END LOOP;

        Pv_Status := CUKG_RESULT.FOUND_STATUS;
        Pv_Code := CUKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Plantilla founded!';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CUKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CUKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro plantilla o alias';
        WHEN OTHERS THEN
            Pv_Status := CUKG_RESULT.FAILED_STATUS;
            Pv_Code := CUKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_ALIAS_PLANTILLA;

END CUKG_ALIAS_PLANITLLA_C;
/
