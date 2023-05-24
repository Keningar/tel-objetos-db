CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REGULARIZACION_MASIVA_DOC AS
    /**
    * Documentaci�n para la funci�n P_GUARDAR_CONTRATO
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor <wgaibor@telconet.ec>
    * @version 1.0 06-07-2022
    */

    PROCEDURE P_OBTENER_CLIENTES_REG(
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) ;

    /**
    * Documentaci�n para F_ESTANDARIZAR
    * Funcion para eliminar tildes y cambiar texto a mayuscula
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 28/06/2021
    */
    FUNCTION  F_ES_CRS(p_puntoId IN NUMBER) RETURN  VARCHAR2;
END CMKG_REGULARIZACION_MASIVA_DOC;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REGULARIZACION_MASIVA_DOC AS

PROCEDURE P_OBTENER_CLIENTES_REG(
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT CLOB) IS
    CURSOR C_GET_PARAMETRO(Cv_DescripcionParametro VARCHAR2,Cv_EmpresaCod INTEGER)
    IS
        SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
        WHERE APC.NOMBRE_PARAMETRO = Cv_DescripcionParametro AND APD.EMPRESA_COD = Cv_EmpresaCod;
    Lv_Consulta             VARCHAR2(3000);
    Lc_Response             SYS_REFCURSOR;
BEGIN
    OPEN C_GET_PARAMETRO('REGULARIZA_DOCUMENTOS_CD',18);
    FETCH C_GET_PARAMETRO INTO Lv_Consulta;
    CLOSE C_GET_PARAMETRO;

    OPEN Lc_Response FOR Lv_Consulta;
    APEX_JSON.initialize_clob_output;
    APEX_JSON.write(Lc_Response);
    Pcl_Response := APEX_JSON.get_clob_output;
    APEX_JSON.free_output;
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_COMERCIAL.P_OBTENER_CLIENTES_REG',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
END P_OBTENER_CLIENTES_REG;

FUNCTION  F_ES_CRS(p_puntoId IN NUMBER) RETURN  VARCHAR2
IS
-- CONSULTAR SI EL PUNTO PROVIENE DE UN CAMBIO DE RAZ�N SOCIAL TRADICIONAL
    CURSOR C_TIENE_CRS_TRADICIONAL(Cn_PuntoId NUMBER) IS
    SELECT
    DISTINCT(1) 
    FROM db_comercial.info_persona_empresa_rol pemp, db_comercial.info_punto ipto
    where pemp.id_persona_rol = ipto.persona_empresa_rol_id
        and pemp.persona_id = (
        SELECT
            iper.persona_id FROM db_comercial.info_persona_empresa_rol iper, db_comercial.info_punto inpt
            where inpt.persona_empresa_rol_id = iper.id_persona_rol
            and iper.persona_empresa_rol_id is not null
            and iper.estado = 'Activo'
            and inpt.estado = 'Activo'
            and iper.empresa_rol_id = 813
            and inpt.id_punto = Cn_PuntoId);
    
    -- CONSULTAR SI EL PUNTO PROVIENE DE UN CAMBIO DE RAZ�N SOCIAL POR PUNTO.
    CURSOR C_TIENE_CRS_POR_PUNTO(Cn_PuntoId NUMBER) IS
    SELECT
        1 
    FROM db_comercial.info_punto_caracteristica ipca, db_comercial.info_punto ipto, db_comercial.admi_caracteristica acar
    where ipca.CARACTERISTICA_ID = acar.id_caracteristica
        and ipca.PUNTO_ID = ipto.id_punto
        and acar.descripcion_caracteristica = 'PUNTO CAMBIO RAZON SOCIAL'
        and ipca.PUNTO_ID = Cn_PuntoId;
    
    Ln_CRS_TRADICIONAL         NUMBER;
    Ln_CRS_POR_PUNTO           NUMBER;
  BEGIN
     --Consultar si el punto proviene de un CRS tradicional
    OPEN C_TIENE_CRS_TRADICIONAL(p_puntoId);
    FETCH C_TIENE_CRS_TRADICIONAL INTO Ln_CRS_TRADICIONAL;
    CLOSE C_TIENE_CRS_TRADICIONAL;
    IF Ln_CRS_TRADICIONAL IS NOT NULL THEN
        RETURN 'S';
    END IF;

    --Consultar si el punto proviene de un CRS por punto
    OPEN C_TIENE_CRS_POR_PUNTO(p_puntoId);
    FETCH C_TIENE_CRS_POR_PUNTO INTO Ln_CRS_POR_PUNTO;
    CLOSE C_TIENE_CRS_POR_PUNTO;
    IF Ln_CRS_POR_PUNTO IS NOT NULL THEN
        RETURN 'S';
    END IF;
    RETURN 'N';
  EXCEPTION
    WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_COMERCIAL.F_ES_CRS',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');  
END F_ES_CRS;

END CMKG_REGULARIZACION_MASIVA_DOC;
/