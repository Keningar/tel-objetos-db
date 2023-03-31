DECLARE
-- CURSOR PARA CONSULTAR LAS AREAS
CURSOR CUR_AREA(Cn_empresaCod NUMBER) IS
SELECT
    nombre_area, estado FROM DB_GENERAL.admi_area
    where EMPRESA_COD = Cn_empresaCod;
--
CURSOR CUR_AREA_EN(Cv_nombreArea VARCHAR2, Cn_empresaCod NUMBER) IS
SELECT
    id_area FROM DB_GENERAL.admi_area
    WHERE nombre_area = Cv_nombreArea
    AND empresa_cod = Cn_empresaCod;
-- CURSOR CUR_DEPARTAMENTO
CURSOR CUR_DEPARTAMENTO(Cn_empresaCod NUMBER) IS
SELECT
    adpt.nombre_departamento, adpt.estado, aare.nombre_area FROM DB_GENERAL.admi_departamento adpt, DB_GENERAL.admi_area aare
    WHERE adpt.area_id = aare.id_area
    and adpt.empresa_cod = Cn_empresaCod;
--OBTENER LA OFICINA DE LA PERSONA DE LA EMPRESA ECUANET
CURSOR CUR_OFICINA(Cn_empresaId NUMBER, Cn_cantonId NUMBER, Cv_nombreOficina VARCHAR2) IS
SELECT
    ID_OFICINA FROM DB_COMERCIAL.info_oficina_grupo
    WHERE empresa_id = Cn_empresaId
    AND canton_id = Cn_cantonId
    AND nombre_oficina = Cv_nombreOficina
    AND estado IN ('Activo', 'Modificado');
--
CURSOR CUR_DEPARTAMENTO_EN(Cv_nombreDepartamento VARCHAR2, Cn_empresaCod NUMBER) IS
SELECT
    id_departamento FROM DB_GENERAL.admi_departamento
    WHERE nombre_departamento = Cv_nombreDepartamento
    AND empresa_cod = Cn_empresaCod;
--
CURSOR C_DPTO_MD(Cn_departamentoId NUMBER) IS
SELECT
    adpt.id_departamento,
    adpt.nombre_departamento    
FROM
    db_comercial.admi_departamento adpt,
    db_comercial.admi_area         ader
WHERE
        adpt.area_id = ader.id_area
    AND adpt.id_departamento = Cn_departamentoId
    AND adpt.estado IN ('Activo', 'Modificado');
--OBTENER ROLES DE LA EMPRESA MEGADATOS
CURSOR CUR_ROLES(Cv_empresaId VARCHAR2) IS
SELECT
    ROL_ID FROM DB_COMERCIAL.info_empresa_rol
    where empresa_cod = Cv_empresaId
    and rol_id not in (1,4,6,586,587,648,649);
--OBTENER LAS PERSONAS QUE TIENEN ESE ROL EN MD
CURSOR CUR_PERSONAS(Cv_rolId VARCHAR2) IS
SELECT
    iper.PERSONA_ID, iper.EMPRESA_ROL_ID, iper.DEPARTAMENTO_ID, iper.OFICINA_ID, iper.ESTADO, iper.CUADRILLA_ID, iper.ES_PREPAGO
FROM
    db_comercial.info_persona_empresa_rol iper,
    db_comercial.info_oficina_grupo       iogr,
    db_comercial.info_empresa_rol         ierl
WHERE
        iper.oficina_id = iogr.id_oficina
    AND iper.empresa_rol_id = ierl.id_empresa_rol
    AND iogr.empresa_id = 18
    AND ierl.empresa_cod = 18
    AND iper.estado IN ( 'Activo', 'Modificado' )
    AND ierl.rol_id NOT IN ( 1, 4, 6, 586, 587, 125,
                             648, 649 )
    AND iper.departamento_id IS NOT NULL
    AND iper.ES_PREPAGO IS NULL
    GROUP BY iper.PERSONA_ID, iper.EMPRESA_ROL_ID, iper.DEPARTAMENTO_ID, iper.OFICINA_ID, iper.ESTADO, iper.CUADRILLA_ID, iper.ES_PREPAGO;
--OBTENER ROLES DE LA EMPRESA MD
CURSOR CUR_ROLES_MD(Cv_empresaRolId NUMBER) IS
SELECT
    ROL_ID, ESTADO FROM DB_COMERCIAL.info_empresa_rol
    where id_empresa_rol = Cv_empresaRolId;
--CONSULTAR SI ESE ROL SE ENCUENTRA CREADO PARA LA EMPRESA EN
CURSOR CUR_ROLES_EN(Cv_rolId NUMBER, Cv_empresaId NUMBER) IS
SELECT
    ID_EMPRESA_ROL FROM DB_COMERCIAL.info_empresa_rol
    where rol_id = Cv_rolId
    AND empresa_cod = Cv_empresaId;
--CONSULTAR LA CIUDAD DE LA OFICINA ID
CURSOR CUR_CANTON(Cn_oficinaId NUMBER) IS
SELECT CANTON_ID FROM DB_COMERCIAL.info_oficina_grupo
    WHERE ID_OFICINA = Cn_oficinaId;
--VALIDAR QUE NO ESTE INGRESADO EL ROL EN LA EMPRESA EN
CURSOR CUR_PERSONA_EMPRESA_ROL(Cv_personaId NUMBER, Cv_empresaRolId NUMBER, Cv_oficinaId NUMBER, Cv_usrCreacion VARCHAR2) IS
SELECT COUNT(*)
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
   where persona_id=Cv_personaId and EMPRESA_ROL_ID=Cv_empresaRolId  and    
   OFICINA_ID=Cv_oficinaId  and ESTADO in ('Pendiente','Activo') and USR_CREACION=Cv_usrCreacion;
--
Ln_empresaCodMd             NUMBER := 18;
Ln_empresaCodEn             NUMBER := 33;
Ln_idArea                   NUMBER;
Ln_AreaIdEN                 NUMBER;
Ln_idDepartamento           NUMBER;
Lv_EstadoActivo             VARCHAR2(10) := 'Activo';
Ln_EmpresaRolId             NUMBER;
Ln_oficinaGrupo             NUMBER;
Ln_DepartamentoId           NUMBER;
Lv_OficinaGYE               VARCHAR2(100) := 'ECUANET - GUAYAQUIL';
Lv_OficinaUIO               VARCHAR2(100) := 'ECUANET - QUITO';
Lv_NombreDepartamento       VARCHAR2(100);
Ln_IdPersonaEmpresaRol      NUMBER;
Ln_IdPersonaEmpresaRolHis   NUMBER;
Ln_CantonId                 NUMBER;
Ln_ExisteRegistro           NUMBER;
--
Lv_UsrCreacion              VARCHAR2(100) := 'ecuanet';
BEGIN
    -- INSERTAR LAS AREAS DE LA EMPRESA MD EN LA EMPRESA EN
    FOR cArea IN CUR_AREA(Ln_empresaCodMd) LOOP
        --
        Ln_idArea := NULL;
        -- BUSCAR QUE ESTA AREA NO EXISTA EN LA EMPRESA EN
        OPEN CUR_AREA_EN(cArea.nombre_area, Ln_empresaCodEn);
        FETCH CUR_AREA_EN INTO Ln_idArea;
        CLOSE CUR_AREA_EN;

        IF Ln_idArea IS NULL THEN
            Ln_idArea := DB_GENERAL.SEQ_ADMI_AREA.NEXTVAL;
            INSERT INTO DB_GENERAL.admi_area(
                ID_AREA,
                NOMBRE_AREA,
                EMPRESA_COD,
                ESTADO,
                USR_CREACION,
                FE_CREACION,
                USR_ULT_MOD
                )
            VALUES(
                Ln_idArea,
                cArea.NOMBRE_AREA,
                Ln_empresaCodEn,
                cArea.ESTADO,
                Lv_UsrCreacion,
                SYSDATE,
                Lv_UsrCreacion);
        END IF;
    END LOOP;
    --
    -- INSERTAR LOS DEPARTAMENTOS DE LA EMPRESA MD EN LA EMPRESA EN
    FOR cDepartamento IN CUR_DEPARTAMENTO(Ln_empresaCodMd) LOOP
        Ln_AreaIdEN             := NULL;
        Ln_idDepartamento       := NULL;
        -- BUSCAR QUE ESTE DEPARTAMENTO NO EXISTA EN LA EMPRESA EN
        OPEN CUR_DEPARTAMENTO_EN(cDepartamento.nombre_departamento, Ln_empresaCodEn);
        FETCH CUR_DEPARTAMENTO_EN INTO Ln_idDepartamento;
        CLOSE CUR_DEPARTAMENTO_EN;

        IF Ln_idDepartamento IS NULL THEN
            -- CONSULTAR EL ID DE LA AREA A LA QUE PERTENECE EL DEPARTAMENTO PERO DE EN
            OPEN CUR_AREA_EN(cDepartamento.nombre_area, Ln_empresaCodEn);
            FETCH CUR_AREA_EN INTO Ln_AreaIdEN;
            CLOSE CUR_AREA_EN;

            IF Ln_AreaIdEN IS NULL THEN
                Ln_AreaIdEN := DB_GENERAL.SEQ_ADMI_AREA.NEXTVAL;
                INSERT INTO DB_GENERAL.admi_area(
                    ID_AREA,
                    NOMBRE_AREA,
                    EMPRESA_COD,
                    ESTADO,
                    USR_CREACION,
                    FE_CREACION,
                    USR_ULT_MOD
                    )
                VALUES(
                    Ln_AreaIdEN,
                    cDepartamento.nombre_area,
                    Ln_empresaCodEn,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_UsrCreacion);
            END IF;

            Ln_idDepartamento := DB_GENERAL.SEQ_ADMI_DEPARTAMENTO.NEXTVAL;
            INSERT INTO DB_GENERAL.admi_departamento(
                ID_DEPARTAMENTO,
                AREA_ID,
                NOMBRE_DEPARTAMENTO,
                ESTADO,
                USR_CREACION,
                FE_CREACION,
                EMPRESA_COD,
                USR_ULT_MOD
                )
            VALUES(
                Ln_idDepartamento,
                Ln_AreaIdEN,
                cDepartamento.NOMBRE_DEPARTAMENTO,
                cDepartamento.ESTADO,
                lv_UsrCreacion,
                SYSDATE,
                Ln_empresaCodEn,
                lv_UsrCreacion);
        END IF;
    END LOOP;

    --
    -- OBTENER LOS ROLES DE LA EMPRESA MD Y REPLICARLOS A LA EMPRESA EN
    --
    FOR P IN CUR_PERSONAS(Ln_empresaCodMd) LOOP

        --
        Ln_oficinaGrupo                 := NULL;
        Ln_DepartamentoId               := NULL;
        Ln_EmpresaRolId                 := NULL;
        Lv_NombreDepartamento           := NULL;
        Ln_CantonId                     := NULL;
        Ln_ExisteRegistro               := NULL;
        --
        OPEN CUR_CANTON(P.OFICINA_ID);
        FETCH CUR_CANTON INTO Ln_CantonId;
        CLOSE CUR_CANTON;
        IF Ln_CantonId IS NULL THEN
            CONTINUE;
        END IF;

        --
        IF Ln_CantonId = 75 THEN
            OPEN CUR_OFICINA(Ln_empresaCodEn, 75, Lv_OficinaGYE);
            FETCH CUR_OFICINA INTO Ln_oficinaGrupo;
            CLOSE CUR_OFICINA;
        END IF;
        IF Ln_CantonId = 178 THEN
            OPEN CUR_OFICINA(Ln_empresaCodEn, 178, Lv_OficinaUIO);
            FETCH CUR_OFICINA INTO Ln_oficinaGrupo;
            CLOSE CUR_OFICINA;
        END IF;

        IF Ln_oficinaGrupo IS NULL THEN
            CONTINUE;
        END IF;

        --
        OPEN C_DPTO_MD(P.DEPARTAMENTO_ID);
        FETCH C_DPTO_MD INTO Ln_DepartamentoId, Lv_NombreDepartamento;
        CLOSE C_DPTO_MD;

        --BUSCAR EL DEPARTAMENTO DE LA EMPRESA EN
        OPEN CUR_DEPARTAMENTO_EN(Lv_NombreDepartamento, Ln_empresaCodEn);
        FETCH CUR_DEPARTAMENTO_EN INTO Ln_DepartamentoId;
        CLOSE CUR_DEPARTAMENTO_EN;

        --LÓGICA DE EMPRESA ROL ID
        FOR ROLMD IN CUR_ROLES_MD(P.EMPRESA_ROL_ID) LOOP
            OPEN CUR_ROLES_EN(ROLMD.ROL_ID, Ln_empresaCodEn);
            FETCH CUR_ROLES_EN INTO Ln_EmpresaRolId;
            CLOSE CUR_ROLES_EN;
            IF Ln_EmpresaRolId IS NULL THEN
                INSERT INTO DB_COMERCIAL.info_empresa_rol(
                    ID_EMPRESA_ROL,
                    EMPRESA_COD,
                    ROL_ID,
                    ESTADO,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION
                ) VALUES(
                    DB_COMERCIAL.SEQ_INFO_EMPRESA_ROL.NEXTVAL,
                    Ln_empresaCodEn,
                    ROLMD.ROL_ID,
                    ROLMD.ESTADO,
                    Lv_UsrCreacion,
                    SYSDATE,
                    '127.0.0.1'
                ) RETURNING ID_EMPRESA_ROL INTO Ln_EmpresaRolId;

            END IF;
        END LOOP;
        --
        -- VALIDAR QUE EL REGISTRO NO SE DUPLIQUE
        --
        OPEN CUR_PERSONA_EMPRESA_ROL(P.PERSONA_ID, Ln_EmpresaRolId, Ln_oficinaGrupo, Ln_DepartamentoId);
        FETCH CUR_PERSONA_EMPRESA_ROL INTO Ln_ExisteRegistro;
        CLOSE CUR_PERSONA_EMPRESA_ROL;

        IF Ln_ExisteRegistro >= 1 THEN
            CONTINUE;
        END IF;

        --
        -- INSERTAR EN LA TABLA DE PERSONA_EMPRESA_ROL
        --
        Ln_IdPersonaEmpresaRol := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL;
        INSERT INTO DB_COMERCIAL.info_persona_empresa_rol(
            ID_PERSONA_ROL,
            PERSONA_ID,
            EMPRESA_ROL_ID,
            OFICINA_ID,
            DEPARTAMENTO_ID,
            ESTADO,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            CUADRILLA_ID,
            ES_PREPAGO
            )
        VALUES(
            Ln_IdPersonaEmpresaRol,
            P.PERSONA_ID,
            Ln_EmpresaRolId,
            Ln_oficinaGrupo,
            Ln_DepartamentoId,
            P.ESTADO,
            lv_UsrCreacion,
            SYSDATE,
            '127.0.0.1',
            P.CUADRILLA_ID,
            P.ES_PREPAGO
            );
        --Inserto Historial para el contacto        
        Ln_IdPersonaEmpresaRolHis := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
        INSERT INTO db_comercial.info_persona_empresa_rol_histo (
            id_persona_empresa_rol_histo,
            usr_creacion,
            fe_creacion,
            ip_creacion,
            estado,
            persona_empresa_rol_id
        ) VALUES (
            ln_idpersonaempresarolhis,
            lv_usrcreacion,
            sysdate,
            '127.0.0.1',
            Lv_EstadoActivo,
            Ln_IdPersonaEmpresaRol
        );
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('REGULARIZACION_ROLES',
                                            'SCRIPT DE REGULARIZACIÓN DE ROLES DE LA EMPRESA ECUANET',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            Lv_UsrCreacion,
                                            SYSDATE,
                                            '127.0.0.1');
END;
/

