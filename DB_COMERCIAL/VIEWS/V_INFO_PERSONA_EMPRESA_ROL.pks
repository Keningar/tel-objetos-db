CREATE OR REPLACE VIEW "DB_COMERCIAL"."V_INFO_PERSONA_EMPRESA_ROL" ("PER_ID_PERSONA", "PER_NOMBRES", "PER_IDENTIFICACION_CLIENTE", "IEG_COD_EMPRESA", "ID_PERSONA_ROL", "PERSONA_ID", "EMPRESA_ROL_ID", "OFICINA_ID", "DEPARTAMENTO_ID", "ESTADO", "USR_CREACION", "FE_CREACION", "IP_CREACION", "CUADRILLA_ID", "PERSONA_EMPRESA_ROL_ID", "PERSONA_EMPRESA_ROL_ID_TTCO", "REPORTA_PERSONA_EMPRESA_ROL_ID", "ES_PREPAGO", "USR_ULT_MOD", "FE_ULT_MOD") AS 
  SELECT
    IP.ID_PERSONA               AS PER_ID_PERSONA,
    IP.NOMBRES                  AS PER_NOMBRES,
    IP.IDENTIFICACION_CLIENTE   AS PER_IDENTIFICACION_CLIENTE,
    IEG.COD_EMPRESA             AS IEG_COD_EMPRESA,
    IPER."ID_PERSONA_ROL",IPER."PERSONA_ID",IPER."EMPRESA_ROL_ID",IPER."OFICINA_ID",IPER."DEPARTAMENTO_ID",IPER."ESTADO",IPER."USR_CREACION",IPER."FE_CREACION",IPER."IP_CREACION",IPER."CUADRILLA_ID",IPER."PERSONA_EMPRESA_ROL_ID",IPER."PERSONA_EMPRESA_ROL_ID_TTCO",IPER."REPORTA_PERSONA_EMPRESA_ROL_ID",IPER."ES_PREPAGO",IPER."USR_ULT_MOD",IPER."FE_ULT_MOD"
FROM
    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
    INNER JOIN DB_COMERCIAL.INFO_PERSONA IP ON IPER.PERSONA_ID = IP.ID_PERSONA
    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IER.EMPRESA_COD = IEG.COD_EMPRESA
WHERE
    IPER.ESTADO NOT IN (
        SELECT
            IPD.VALOR1
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB IPC,
            DB_GENERAL.ADMI_PARAMETRO_DET IPD
        WHERE
            IPD.PARAMETRO_ID = IPC.ID_PARAMETRO
            AND IPD.ESTADO = 'Activo'
            AND IPC.ESTADO = 'Activo'
            AND IPC.NOMBRE_PARAMETRO = 'ESTADOS_PERSONA_EMPRESA_ROL'
    )
    AND IPER.EMPRESA_ROL_ID IN (
        (
            SELECT
                ID_EMPRESA_ROL
            FROM
                DB_COMERCIAL.INFO_EMPRESA_ROL IERM,
                DB_GENERAL.ADMI_ROL AR,
                DB_GENERAL.ADMI_TIPO_ROL ATR
            WHERE
                AR.ID_ROL = IERM.ROL_ID
                AND ATR.ID_TIPO_ROL = AR.TIPO_ROL_ID
                AND ATR.DESCRIPCION_TIPO_ROL IN (
                    SELECT
                        IPD.VALOR1
                    FROM
                        DB_GENERAL.ADMI_PARAMETRO_CAB IPC,
                        DB_GENERAL.ADMI_PARAMETRO_DET IPD
                    WHERE
                        IPD.PARAMETRO_ID = IPC.ID_PARAMETRO
                        AND IPD.ESTADO = 'Activo'
                        AND IPC.ESTADO = 'Activo'
                        AND IPC.NOMBRE_PARAMETRO = 'TIPO_ROL_PERSONA_EMPRESA_ROL'
                )
        )
    );