CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C AS 

    /**
     * Contiene consultas al objeto P_GET_INFO_EMPRESA_ROL
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_INFO_EMPRESA_ROL (
        Pn_EmpresaCod       IN                  INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
        Pn_IdRol            IN                  INFO_EMPRESA_ROL.ROL_ID%TYPE,
        Pr_InfoEmpresaRol   OUT                 INFO_EMPRESA_ROL%ROWTYPE,
        Pv_Status           OUT                 VARCHAR2,
        Pv_Code             OUT                 VARCHAR2,
        Pv_Msn              OUT                 VARCHAR2
    );

    /**
     * Documentacion para proceso 'P_GET_INFO_EMPRESA_GRUPO'
     *
     * Procedimiento para obtener informacion de la Empresa
     *
     * @param Pv_Prefijo          IN  INFO_EMPRESA_GRUPO.PREFIJO%TYPE Recibe el prefijo de la empresa
     * @param Pv_Estado           IN  INFO_EMPRESA_GRUPO.ESTADO%TYPE Recibe el estado de la empresa
     * @param Pr_InfoEmpresaGrupo OUT INFO_EMPRESA_GRUPO%ROWTYPE Retorna registro de la empresa
     * @param Pv_Status           OUT VARCHAR2 Retorna status de la consulta
     * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la consulta
     * 
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 
     * @since   05-10-2021
     **/
    PROCEDURE P_GET_INFO_EMPRESA_GRUPO (Pv_Prefijo          IN  INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                        Pv_Estado           IN  INFO_EMPRESA_GRUPO.ESTADO%TYPE,
                                        Pr_InfoEmpresaGrupo OUT INFO_EMPRESA_GRUPO%ROWTYPE,
                                        Pv_Status           OUT VARCHAR2,
                                        Pv_Mensaje          OUT VARCHAR2);

    /**
     * Documentacion para proceso 'P_GET_INFO_OFICINA_GRUPO'
     *
     * Procedimiento para obtener informacion de la oficina
     *
     * @param Pn_IdOficina        IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE Recibe el id de la oficina
     * @param Pv_Estado           IN  INFO_OFICINA_GRUPO.ESTADO%TYPE Recibe el estado de la oficina
     * @param Pr_InfoOficinaGrupo OUT INFO_OFICINA_GRUPO%ROWTYPE Retorna registro de la oficina
     * @param Pv_Status           OUT VARCHAR2 Retorna status de la consulta
     * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la consulta
     * 
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 
     * @since   02-11-2021
     **/
    PROCEDURE P_GET_INFO_OFICINA_GRUPO (Pn_IdOficina        IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                        Pv_Estado           IN  INFO_OFICINA_GRUPO.ESTADO%TYPE,
                                        Pr_InfoOficinaGrupo OUT INFO_OFICINA_GRUPO%ROWTYPE,
                                        Pv_Status           OUT VARCHAR2,
                                        Pv_Mensaje          OUT VARCHAR2);                                        

END CMKG_INFO_EMPRESA_ROL_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C AS

    PROCEDURE P_GET_INFO_EMPRESA_ROL (
        Pn_EmpresaCod       IN                  INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
        Pn_IdRol            IN                  INFO_EMPRESA_ROL.ROL_ID%TYPE,
        Pr_InfoEmpresaRol   OUT                 INFO_EMPRESA_ROL%ROWTYPE,
        Pv_Status           OUT                 VARCHAR2,
        Pv_Code             OUT                 VARCHAR2,
        Pv_Msn              OUT                 VARCHAR2
    ) AS

        /**
          * C_GetInfoEmpresaRol, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 3, cardinalidad 1
          */

        CURSOR C_GetInfoEmpresaRol (
            Cn_EmpresaCod   INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
            Cn_IdRol        INFO_EMPRESA_ROL.ROL_ID%TYPE
        ) IS
        SELECT
            ER.*
        FROM
            INFO_EMPRESA_ROL ER
        WHERE
            ER.EMPRESA_COD = Cn_EmpresaCod
            AND ER.ROL_ID = Cn_IdRol;

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetInfoEmpresaRol%ISOPEN THEN
            CLOSE C_GetInfoEmpresaRol;
        END IF;
        OPEN C_GetInfoEmpresaRol(Pn_EmpresaCod, Pn_IdRol);
        FETCH C_GetInfoEmpresaRol INTO Pr_InfoEmpresaRol;
        IF C_GetInfoEmpresaRol%NOTFOUND THEN
            CLOSE C_GetInfoEmpresaRol;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetInfoEmpresaRol;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro empresa rol';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro empresa rol';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_INFO_EMPRESA_ROL;

    PROCEDURE P_GET_INFO_EMPRESA_GRUPO (Pv_Prefijo          IN  INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                        Pv_Estado           IN  INFO_EMPRESA_GRUPO.ESTADO%TYPE,
                                        Pr_InfoEmpresaGrupo OUT INFO_EMPRESA_GRUPO%ROWTYPE,
                                        Pv_Status           OUT VARCHAR2,
                                        Pv_Mensaje          OUT VARCHAR2) AS

      /**
       * C_GetInfoEmpresaGrupo, obtiene un registro por prefijo de empresa y estado
       * @author David De La Cruz <ddelacruz@telconet.ec>
       * @version 1.0
       * @since 05-10-2021
       * @costo 2, cardinalidad 1
       */
      CURSOR C_GetInfoEmpresaGrupo(Cv_Prefijo INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                    Cv_Estado  INFO_EMPRESA_GRUPO.ESTADO%TYPE) IS
        SELECT
            IEG.*
        FROM
            INFO_EMPRESA_GRUPO IEG
        WHERE
            IEG.PREFIJO = Cv_Prefijo
        AND IEG.ESTADO = Cv_Estado;

      Le_NotFound EXCEPTION;
    BEGIN        
      IF C_GetInfoEmpresaGrupo%ISOPEN THEN
        CLOSE C_GetInfoEmpresaGrupo;
      END IF;

      OPEN C_GetInfoEmpresaGrupo(Pv_Prefijo, Pv_Estado);
      FETCH C_GetInfoEmpresaGrupo INTO Pr_InfoEmpresaGrupo;
        IF C_GetInfoEmpresaGrupo%NOTFOUND THEN
          CLOSE C_GetInfoEmpresaGrupo;
          RAISE Le_NotFound;
        END IF;
      CLOSE C_GetInfoEmpresaGrupo;

      Pv_Status := 'OK';
      Pv_Mensaje := 'Se encontro empresa grupo';
    EXCEPTION
      WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro empresa grupo';
      WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
    END P_GET_INFO_EMPRESA_GRUPO;

    PROCEDURE P_GET_INFO_OFICINA_GRUPO (Pn_IdOficina        IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                        Pv_Estado           IN  INFO_OFICINA_GRUPO.ESTADO%TYPE,
                                        Pr_InfoOficinaGrupo OUT INFO_OFICINA_GRUPO%ROWTYPE,
                                        Pv_Status           OUT VARCHAR2,
                                        Pv_Mensaje          OUT VARCHAR2) AS
      /**
       * C_GetInfoEmpresaGrupo, obtiene un registro por idOficina y estado
       * @author David De La Cruz <ddelacruz@telconet.ec>
       * @version 1.0
       * @since 02-11-2021
       * @costo 1, cardinalidad 1
       */
      CURSOR C_GetInfoOficinaGrupo(Cn_IdOficina INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                   Cv_Estado    INFO_OFICINA_GRUPO.ESTADO%TYPE) IS
        SELECT
            IOG.*
        FROM
            INFO_OFICINA_GRUPO IOG
        WHERE
            IOG.ID_OFICINA = Cn_IdOficina
        AND IOG.ESTADO = Cv_Estado;

      Le_NotFound EXCEPTION;
    BEGIN        
      IF C_GetInfoOficinaGrupo%ISOPEN THEN
        CLOSE C_GetInfoOficinaGrupo;
      END IF;

      OPEN C_GetInfoOficinaGrupo(Pn_IdOficina, Pv_Estado);
      FETCH C_GetInfoOficinaGrupo INTO Pr_InfoOficinaGrupo;
        IF C_GetInfoOficinaGrupo%NOTFOUND THEN
          CLOSE C_GetInfoOficinaGrupo;
          RAISE Le_NotFound;
        END IF;
      CLOSE C_GetInfoOficinaGrupo;

      Pv_Status := 'OK';
      Pv_Mensaje := 'Se encontro oficina';
    EXCEPTION
      WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro oficina';
      WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
    END P_GET_INFO_OFICINA_GRUPO;

END CMKG_INFO_EMPRESA_ROL_C;
/