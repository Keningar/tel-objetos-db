create or replace PACKAGE DB_COMERCIAL.CMKG_TAREAS_PROGRAMADAS AS

/**
   * Documentación para el procedimiento 'P_CADUCA_CREDENCIALES_LINK_BCO'
   * Proceso que sirve para INACTIVAR las contraseñas para el ingresar al portal de 
   * solicitud de llenado del proceso link bancario.
   *
   * @author Walther Joao Gaibor C <wgaibor@telconet.ec>
   * @version 1.0 31-05-2022
   *
   */
  PROCEDURE P_CADUCA_CREDENCIALES_LINK_BCO;

/**
   * Documentación para el procedimiento 'P_REGULARIZA_CONTRATO'
   * Proceso que sirve para regularizar los contratos de los clientes que no
   * pasarón por el proceso de llenado del proceso link bancario.
   *
   * @author Walther Joao Gaibor C <wgaibor@telconet.ec>
   * @version 1.0 06-06-2022
   *
   */
  PROCEDURE P_REGULARIZA_CONTRATO(PV_FECHA_INICIO   IN VARCHAR2,
                                  PV_FECHA_FIN      IN VARCHAR2,
                                  PV_MENSAJE        OUT VARCHAR2);
END CMKG_TAREAS_PROGRAMADAS;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_TAREAS_PROGRAMADAS AS

    PROCEDURE P_CADUCA_CREDENCIALES_LINK_BCO IS
    CURSOR C_OBTENER_CARACTERISTICA(Cv_DescripcionCara VARCHAR2, Cv_EstadoActivo VARCHAR2) IS
    SELECT
        ID_CARACTERISTICA 
    FROM db_comercial.admi_caracteristica 
        where descripcion_caracteristica = Cv_DescripcionCara
        and estado = Cv_EstadoActivo;

    CURSOR C_OBTENER_PARAM(Cv_NombreParam VARCHAR2, Cv_DescripcionParam VARCHAR2, Cv_Estado VARCHAR2) IS
    SELECT
        apdt.valor1,
        apdt.valor2
    FROM
        db_general.admi_parametro_cab adca, DB_GENERAL.admi_parametro_det apdt
    WHERE
        adca.id_parametro = apdt.parametro_id
        AND adca.nombre_parametro = Cv_NombreParam
        and apdt.DESCRIPCION = Cv_DescripcionParam
        AND adca.estado = Cv_Estado
        AND apdt.estado = Cv_Estado;

    CURSOR C_Credeciales_Activas(Cn_CaracteristicaId NUMBER, Cn_TiempoVigencia NUMBER, Cv_EstadoActivo VARCHAR2) IS
    SELECT
        ifca.ID_PUNTO_CARACTERISTICA,
        ifca.usr_creacion loginVendedor,
        ipto.login nombreCliente
    FROM db_comercial.info_punto_caracteristica ifca,  db_comercial.info_punto ipto
        where ifca.punto_id = ipto.id_punto
        and ifca.caracteristica_id = Cn_CaracteristicaId
        and ifca.estado = Cv_EstadoActivo
        and ifca.FE_CREACION  <= SYSDATE - Cn_TiempoVigencia/(24*60);

    CURSOR C_Obtener_Correo(Cv_Login VARCHAR2, Cv_FormaContacto VARCHAR2, Cv_Estado VARCHAR2) IS
    SELECT
    ipfc.valor
    FROM
        db_comercial.info_persona                inpe,
        db_comercial.info_persona_forma_contacto ipfc,
        db_comercial.admi_forma_contacto         afct
    WHERE
            inpe.id_persona = ipfc.persona_id
        AND ipfc.forma_contacto_id = afct.id_forma_contacto
        AND inpe.login = Cv_Login
        AND afct.descripcion_forma_contacto = Cv_FormaContacto
        AND ipfc.estado = Cv_Estado;

    Lv_DescripcionCaracteristica VARCHAR2(100):= 'passwordLinkDatosBancarios';
    Lv_EstadoActivo              VARCHAR2(100):= 'Activo';
    Ln_CaracteristicaId          NUMBER;

    Lv_NombreParam               VARCHAR2(100):= 'ACEPTACION_CLAUSULA_CONTRATO';
    Lv_DescripcionParam          VARCHAR2(100):= 'TIEMPO DE VIGENCIA MIN';
    Lv_DescripcionCaduCred       VARCHAR2(100):= 'CADUCAR CREDENCIALES';
    Lv_TagTiempoVigencia         VARCHAR2(100):= 'TIEMPO_VIGENCIA_MIN';
    Lv_TiempoVigencia            NUMBER;
    Lv_PlantillaHtml             VARCHAR2(2000);
    Lv_PlantillaCorreo           VARCHAR2(2000);

    --
    Lv_FormaContacto             VARCHAR2(100):= 'Correo Electronico';
    Lv_CorreoVendedor            VARCHAR2(100);
    Lv_Asunto                    VARCHAR2(1000);
    Lv_Remitente                 VARCHAR2(100);
    --
    BEGIN
        OPEN C_OBTENER_CARACTERISTICA(Lv_DescripcionCaracteristica, Lv_EstadoActivo);
        FETCH C_OBTENER_CARACTERISTICA INTO Ln_CaracteristicaId;
        CLOSE C_OBTENER_CARACTERISTICA;

        IF Ln_CaracteristicaId IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'La caracteristica '||Lv_DescripcionCaracteristica ||' no existe');
        END IF;

        OPEN C_OBTENER_PARAM(Lv_NombreParam, Lv_DescripcionParam, Lv_EstadoActivo);
        FETCH C_OBTENER_PARAM INTO Lv_TiempoVigencia, Lv_TagTiempoVigencia;
        CLOSE C_OBTENER_PARAM;

        IF Lv_TiempoVigencia IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El parametro '||Lv_DescripcionParam ||' no existe' || Lv_TagTiempoVigencia);
        END IF;

        OPEN C_OBTENER_PARAM(Lv_NombreParam, Lv_DescripcionCaduCred, Lv_EstadoActivo);
        FETCH C_OBTENER_PARAM INTO Lv_PlantillaHtml, Lv_Remitente;
        CLOSE C_OBTENER_PARAM;

        IF Lv_PlantillaHtml IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El parametro '||Lv_DescripcionCaduCred ||' no existe');
        END IF;

        FOR I1 IN C_Credeciales_Activas(Ln_CaracteristicaId, Lv_TiempoVigencia, Lv_EstadoActivo) LOOP
            Lv_PlantillaCorreo := NULL;
            Lv_CorreoVendedor  := NULL;
            --
            SELECT REPLACE(Lv_PlantillaHtml, '{{cliente}}', I1.nombreCliente) INTO Lv_PlantillaCorreo
            FROM dual;
            --
            OPEN C_Obtener_Correo(I1.loginVendedor, Lv_FormaContacto, Lv_EstadoActivo);
            FETCH C_Obtener_Correo INTO Lv_CorreoVendedor;
            CLOSE C_Obtener_Correo;
            --
            UPDATE db_comercial.info_punto_caracteristica
            SET estado = 'Inactivo',
                FE_ULT_MOD = SYSDATE,
                USR_ULT_MOD = 'linkBancario'
            WHERE ID_PUNTO_CARACTERISTICA = I1.ID_PUNTO_CARACTERISTICA;

            SELECT REPLACE('CREDENCIALES CADUCADAS {{cliente}}', '{{cliente}}', I1.nombreCliente) INTO Lv_Asunto
            FROM dual;
            UTL_MAIL.SEND ( sender      => Lv_Remitente,
                            recipients  => Lv_CorreoVendedor,
                            subject     => Lv_Asunto,
                            MESSAGE     => Lv_PlantillaCorreo,
                            mime_type   => 'text/html; charset=UTF-8' );
        END LOOP;
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATOCLIENTE',
                                            'DB_COMERCIAL.CMKG_TAREAS_PROGRAMADAS.P_CADUCA_CREDENCIALES_LINK_BCO',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'linkBancario',
                                            SYSDATE,
                                            '127.0.0.1');
    END P_CADUCA_CREDENCIALES_LINK_BCO;

    PROCEDURE P_REGULARIZA_CONTRATO(PV_FECHA_INICIO   IN VARCHAR2,
                                    PV_FECHA_FIN      IN VARCHAR2,
                                    PV_MENSAJE        OUT VARCHAR2) IS
    -- REGISTROS QUE TIENE UN CONTRATO DIGITAL
    CURSOR C_CONTRATO_DIG_REG(Cv_FE_INICIO VARCHAR2, Cv_FE_FIN VARCHAR2) IS
        SELECT INAD.* 
        FROM DB_COMERCIAL.info_adendum INAD, DB_COMERCIAL.info_contrato INCO
        where inco.id_contrato = inad.contrato_id
            and INAD.estado = 'Activo'
            and INCO.estado = 'Activo'
            AND inad.fe_creacion BETWEEN TO_DATE(Cv_FE_INICIO, 'dd/mm/YYYY') AND TO_DATE(Cv_FE_FIN, 'dd/mm/YYYY')
            and INAD.tipo <> 'AS'
            ORDER BY inad.fe_creacion ASC;

    -- REGISTROS QUE TIENE UN CONTRATO FISICO
    CURSOR C_CONTRATO_FIS_REG(Cv_FE_INICIO VARCHAR2, Cv_FE_FIN VARCHAR2) IS
        SELECT
        DISTINCT(iadn.punto_id) puntoId
        FROM db_comercial.info_contrato inco, 
             db_comercial.info_persona_empresa_rol iper,
             db_comercial.info_punto ipto,
             db_comercial.info_adendum iadn
        where iper.id_persona_rol = inco.persona_empresa_rol_id
            and iper.id_persona_rol = ipto.persona_empresa_rol_id
            and ipto.id_punto = iadn.punto_id
            and inco.estado = 'Pendiente'
            and inco.usr_aprobacion is null
            and inco.origen <> 'MOVIL'
            and iadn.estado = 'Pendiente'
            and iadn.fe_creacion BETWEEN to_date(Cv_FE_INICIO, 'dd/mm/yyyy') and TO_DATE(Cv_FE_FIN, 'dd/mm/yyyy');

    -- CONSULTAR SI EL PUNTO TIENE UN PLAN EMPLEADO
    CURSOR C_TIENE_PLAN_EMPLEADO(Cn_PuntoId NUMBER, Cv_PlanEmpleado VARCHAR2) IS
    SELECT
        1 
    FROM DB_COMERCIAL.info_punto infp, DB_COMERCIAL.info_servicio infs, DB_COMERCIAL.info_plan_cab ipca
    where infp.id_punto = infs.punto_id
        and infs.plan_id = ipca.id_plan
        and ipca.codigo_plan like Cv_PlanEmpleado
        and infp.id_punto = Cn_PuntoId;

    -- CONSULTAR SI EL PUNTO PROVIENE DE UN CAMBIO DE RAZÓN SOCIAL TRADICIONAL
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

    -- CONSULTAR SI EL PUNTO PROVIENE DE UN CAMBIO DE RAZÓN SOCIAL POR PUNTO.
    CURSOR C_TIENE_CRS_POR_PUNTO(Cn_PuntoId NUMBER) IS
    SELECT
        1 
    FROM db_comercial.info_punto_caracteristica ipca, db_comercial.info_punto ipto, db_comercial.admi_caracteristica acar
    where ipca.CARACTERISTICA_ID = acar.id_caracteristica
        and ipca.PUNTO_ID = ipto.id_punto
        and acar.descripcion_caracteristica = 'PUNTO CAMBIO RAZON SOCIAL'
        and ipca.PUNTO_ID = Cn_PuntoId;


    -- CONSULTAR PARAMETRO QUE OBTIENE LAS PREGUNTAS Y RESPUESTAS DE LAS CLAUSULAS
    CURSOR C_PARAMETRO_PREGUNTAS_RESP IS
    SELECT
    valor1 pregunta1, valor2 respuesta1, valor3 pregunta2, valor4 respuesta2, valor5 respuestaDefault FROM DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT
    id_parametro FROM DB_GENERAL.admi_parametro_cab
    where nombre_parametro = 'CONTRATO_FISICO_VALIDACION');

    -- CONSULTAR EL ID_RESPUESTA DE LA TABLA ADMI_RESPUESTAS.
    CURSOR C_RESPUESTA_DEFAULT(Cv_codigo VARCHAR2, Cn_docEnunciadoId NUMBER) IS
    SELECT
    AAEN.VALOR
    FROM
        DB_DOCUMENTO.ADMI_CAB_ENUNCIADO       ACEN,
        DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO  AAEN,
        DB_DOCUMENTO.ADMI_ENUNCIADO           ADEN,
        DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADOE
    WHERE
            ACEN.ID_CAB_ENUNCIADO = AAEN.CAB_ENUNCIADO_ID
        AND AAEN.ENUNCIADO_ID = ADEN.ID_ENUNCIADO
        AND ADEN.ID_ENUNCIADO = ADOE.ENUNCIADO_ID
        AND ACEN.ID_CAB_ENUNCIADO = (
            SELECT
                ACEN.ID_CAB_ENUNCIADO
            FROM
                DB_DOCUMENTO.ADMI_CAB_ENUNCIADO ACEN
            WHERE
                ACEN.CODIGO = Cv_codigo
        )
        AND ADOE.ID_DOCUMENTO_ENUNCIADO = Cn_docEnunciadoId
        AND ADEN.ESTADO = 'Activo'
        AND ACEN.ESTADO = 'Activo'
        AND AAEN.ESTADO = 'Activo'
        AND ADOE.ESTADO = 'Activo';

    -- CONSULTAR LA IDENTIFICACION DEL PUNTO
    CURSOR C_IDENTIFICACION_PUNTO(Cn_puntoId NUMBER) IS
    SELECT
        inpe.identificacion_cliente
    FROM DB_COMERCIAL.info_punto INPT,
         DB_COMERCIAL.info_persona_empresa_rol IPER,
         DB_COMERCIAL.info_persona inpe
    WHERE INPT.PERSONA_EMPRESA_ROL_ID = iper.id_persona_rol
    AND iper.persona_id = inpe.id_persona
    and inpt.id_punto = Cn_puntoId
    and ROWNUM <= 2;
    -- CONSULTAR LOS ENUNCIADOS DE LAS CLAUSULAS
    CURSOR C_ENUNCIADOS_CLAUSULAS IS
    SELECT
        addo.id_documento_enunciado DOCUMENTO_ENUNCIADO_ID,
        aden.nombre NOMBRE_CLAUSULA
    FROM db_documento.admi_enunciado aden, db_documento.admi_documento_enunciado addo
    where addo.enunciado_id = aden.id_enunciado
        and aden.estado = 'Activo'
        and addo.estado = 'Activo';

    -- VARIABLES
    TYPE Tv_ContratoDigital    IS TABLE OF C_CONTRATO_DIG_REG%ROWTYPE;
    lc_contratoDigital         Tv_ContratoDigital;
    Ln_tienePlanEmpleado       NUMBER;
    Ln_CRS_TRADICIONAL         NUMBER;
    Ln_CRS_POR_PUNTO           NUMBER;
    ln_id_documento_relacion   NUMBER;
    Lv_Pregunta1               varchar2(200);
    Lv_Respuesta1              varchar2(200);
    Lv_Pregunta2               varchar2(200);
    Lv_Respuesta2              varchar2(200);
    Lv_RespuestaDefault        varchar2(200);
    Ln_IdRespuesta             NUMBER;
    TYPE Tv_EnunciadoClausu    IS TABLE OF C_ENUNCIADOS_CLAUSULAS%ROWTYPE;
    lc_EnunciadoClausu         Tv_EnunciadoClausu;
    Ln_DocEnunciadoResp        NUMBER;

    Ln_IteradorI               NUMBER;

    Ln_FisIteradorI            NUMBER;
    TYPE Tv_ContratoFisico     IS TABLE OF C_CONTRATO_FIS_REG%ROWTYPE;
    lc_contratoFisico          Tv_ContratoFisico;

    ln_contador                NUMBER:=0;
    Lv_Proceso                 VARCHAR2(100):='LinkDatosBancarios';
    Lv_valorRespuesta          VARCHAR2(100);
    Lv_IdentificacionCliente   VARCHAR2(100);
    BEGIN
        OPEN C_CONTRATO_DIG_REG(PV_FECHA_INICIO, PV_FECHA_FIN);    
        FETCH C_CONTRATO_DIG_REG BULK COLLECT INTO lc_contratoDigital LIMIT 5000;
        CLOSE C_CONTRATO_DIG_REG;

        -- SE PROCEDE A INSERTAR EL REGISTRO EN LA TABLA DE INFO_PUNTO_CLAUSULA_RESP
        OPEN C_PARAMETRO_PREGUNTAS_RESP;
        FETCH C_PARAMETRO_PREGUNTAS_RESP INTO Lv_Pregunta1, Lv_Respuesta1, Lv_Pregunta2, Lv_Respuesta2, Lv_RespuestaDefault;
        CLOSE C_PARAMETRO_PREGUNTAS_RESP;

        Ln_IteradorI := lc_contratoDigital.FIRST;
        WHILE (Ln_IteradorI IS NOT NULL) 
        LOOP
            OPEN C_TIENE_PLAN_EMPLEADO(lc_contratoDigital(Ln_IteradorI).punto_id, '%EMPL%');
            FETCH C_TIENE_PLAN_EMPLEADO INTO Ln_tienePlanEmpleado;
            CLOSE C_TIENE_PLAN_EMPLEADO;
            --Consultar si es plan empleado y si tiene plan empleado no considerarlo en el proceso
            IF Ln_tienePlanEmpleado IS NOT NULL THEN
                Ln_IteradorI := lc_contratoDigital.NEXT(Ln_IteradorI);
                CONTINUE;
            END IF;
            --Consultar si el punto proviene de un CRS tradicional
            OPEN C_TIENE_CRS_TRADICIONAL(lc_contratoDigital(Ln_IteradorI).punto_id);
            FETCH C_TIENE_CRS_TRADICIONAL INTO Ln_CRS_TRADICIONAL;
            CLOSE C_TIENE_CRS_TRADICIONAL;
            IF Ln_CRS_TRADICIONAL IS NOT NULL THEN
                Ln_IteradorI := lc_contratoDigital.NEXT(Ln_IteradorI);
                CONTINUE;
            END IF;
            OPEN C_TIENE_CRS_POR_PUNTO(lc_contratoDigital(Ln_IteradorI).punto_id);
            FETCH C_TIENE_CRS_POR_PUNTO INTO Ln_CRS_POR_PUNTO;
            CLOSE C_TIENE_CRS_POR_PUNTO;
            IF Ln_CRS_POR_PUNTO IS NOT NULL THEN
                Ln_IteradorI := lc_contratoDigital.NEXT(Ln_IteradorI);
                CONTINUE;
            END IF;
            -- SE PROCEDE A INSERTAR EL REGISTRO EN LA TABLA INFO_DOCUMENTO_RELACION
            INSERT INTO db_documento.info_documento_relacion(
                ID_DOCUMENTO_RELACION,
                PROCESO,
                ESTADO,
                OBSERVACION,
                USUARIO_CREACION,
                FECHA_CREACION)
            VALUES(
                db_documento.SEQ_INFO_DOCUMENTO_RELACION.nextval,
                Lv_Proceso,
                'Activo',
                'SCRIPT DE REGULARIZACIÓN DE CLAUSULAS DIGITAL',
                'reg_clausulas_digital',
                SYSDATE) RETURNING ID_DOCUMENTO_RELACION INTO ln_id_documento_relacion;

            -- SE PROCEDE A INSERTAR EL REGISTRO EN LA TABLA INFO_DOCUMENTO_RELACION_HIST
            INSERT INTO db_documento.info_documento_relacion_hist(
                ID_DOCUMENTO_RELACION_HIST,
                DOCUMENTO_RELACION_ID,
                VALOR,
                EVENTO,
                USUARIO_EVENTO,
                FECHA_EVENTO)
            VALUES(
                db_documento.SEQ_INFO_DOC_RELACION_HIST.nextval,
                ln_id_documento_relacion,
                'SCRIPT DE REGULARIZACIÓN DE CLAUSULAS DIGITAL',
                'REGULARIZACIÓN',
                'reg_clausulas_digital',
                SYSDATE);
            --

            -- RELACIONO EL DOCUMENTO CON EL PUNTO
            INSERT INTO DB_DOCUMENTO.INFO_DOCUMENTO_CARAC(
                ID_DOCUMENTO_CARAC,
                DOCUMENTO_RELACION_ID,
                DOC_REFERENCIA_ID,
                VALOR,
                ESTADO,
                USUARIO_CREACION,
                FECHA_CREACION)
            VALUES(
                db_documento.SEQ_INFO_DOCUMENTO_CARAC.nextval,
                ln_id_documento_relacion,
                (SELECT id_doc_referencia
                 FROM DB_DOCUMENTO.ADMI_DOC_REFERENCIA 
                 WHERE nombre = 'PUNTO'),
                lc_contratoDigital(Ln_IteradorI).punto_id,
                'Activo',
                'reg_clausulas_digital',
                SYSDATE);

            OPEN C_IDENTIFICACION_PUNTO(lc_contratoDigital(Ln_IteradorI).punto_id);
            FETCH C_IDENTIFICACION_PUNTO INTO Lv_IdentificacionCliente;
            CLOSE C_IDENTIFICACION_PUNTO;
            -- RELACIONAR EL DOCUMENTO CON LA PERSONA
            INSERT INTO DB_DOCUMENTO.INFO_DOCUMENTO_CARAC(
                ID_DOCUMENTO_CARAC,
                DOCUMENTO_RELACION_ID,
                DOC_REFERENCIA_ID,
                VALOR,
                ESTADO,
                USUARIO_CREACION,
                FECHA_CREACION)
            VALUES(
                db_documento.SEQ_INFO_DOCUMENTO_CARAC.nextval,
                ln_id_documento_relacion,
                (SELECT id_doc_referencia
                 FROM DB_DOCUMENTO.ADMI_DOC_REFERENCIA 
                 WHERE nombre = 'PERSONA'),
                Lv_IdentificacionCliente,
                'Activo',
                'reg_clausulas_digital',
                SYSDATE);
            -- OBTENER EL ENUNCIANDO RESPUESTA PARA LA INSERCIÓN EN LA TABLA DE INFO_PUNTO_CLAUSULA_RESP
            FOR j IN C_ENUNCIADOS_CLAUSULAS 
            LOOP
                Ln_CRS_TRADICIONAL          := NULL;
                Ln_tienePlanEmpleado        := NULL;
                Ln_CRS_POR_PUNTO            := NULL;
                Lv_IdentificacionCliente    := NULL;

                OPEN C_RESPUESTA_DEFAULT('OR-MD', j.DOCUMENTO_ENUNCIADO_ID);
                FETCH C_RESPUESTA_DEFAULT INTO Ln_IdRespuesta;
                CLOSE C_RESPUESTA_DEFAULT;

                IF Ln_IdRespuesta IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20101, 'No se encontró respuesta para la clausula ' || j.NOMBRE_CLAUSULA);
                END IF;

                SELECT ID_DOC_ENUNCIADO_RESP INTO Ln_DocEnunciadoResp
                FROM db_documento.admi_doc_enunciado_resp
                WHERE documento_enunciado_id = j.DOCUMENTO_ENUNCIADO_ID 
                    AND respuesta_id = Ln_IdRespuesta;

                --
                SELECT VALOR INTO Lv_valorRespuesta
                FROM db_documento.admi_respuesta
                WHERE id_respuesta = Ln_IdRespuesta;

                INSERT INTO db_documento.INFO_DOC_RESPUESTA(
                    ID_DOC_RESPUESTA,
                    DOCUMENTO_RELACION_ID,
                    DOC_ENUNCIADO_RESP_ID,
                    JUSTIFICACION_RESPUESTA,
                    ESTADO,
                    USUARIO_CREACION,
                    FECHA_CREACION)
                VALUES(
                    db_documento.SEQ_INFO_DOC_RESPUESTA.nextval,
                    ln_id_documento_relacion,
                    Ln_DocEnunciadoResp,
                    Lv_valorRespuesta,
                    'Activo',
                    'reg_clausulas_digital',
                    SYSDATE);
            END LOOP;
            ln_contador := ln_contador + 1;
            Ln_IteradorI := lc_contratoDigital.NEXT(Ln_IteradorI);
        END LOOP;

        ln_id_documento_relacion := NULL;
        --REGULARIZACIÓN DE CONTRATOS FÍSICOS.
        OPEN C_CONTRATO_FIS_REG(PV_FECHA_INICIO, PV_FECHA_FIN);    
        FETCH C_CONTRATO_FIS_REG BULK COLLECT INTO lc_contratoFisico LIMIT 5000;
        CLOSE C_CONTRATO_FIS_REG;
        Ln_FisIteradorI := lc_contratoFisico.FIRST;
        WHILE (Ln_FisIteradorI IS NOT NULL)
        LOOP
            Ln_CRS_TRADICIONAL          := NULL;
            Ln_tienePlanEmpleado        := NULL;
            Ln_CRS_POR_PUNTO            := NULL;
            Lv_IdentificacionCliente    := NULL;
            OPEN C_TIENE_PLAN_EMPLEADO(lc_contratoFisico(Ln_FisIteradorI).puntoId, '%EMPL%');
            FETCH C_TIENE_PLAN_EMPLEADO INTO Ln_tienePlanEmpleado;
            CLOSE C_TIENE_PLAN_EMPLEADO;
            --Consultar si es plan empleado y si tiene plan empleado no considerarlo en el proceso
            IF Ln_tienePlanEmpleado IS NOT NULL THEN
                Ln_FisIteradorI := lc_contratoFisico.NEXT(Ln_FisIteradorI);
                CONTINUE;
            END IF;

            --Consultar si el punto proviene de un CRS tradicional
            OPEN C_TIENE_CRS_TRADICIONAL(lc_contratoFisico(Ln_FisIteradorI).puntoId);
            FETCH C_TIENE_CRS_TRADICIONAL INTO Ln_CRS_TRADICIONAL;
            CLOSE C_TIENE_CRS_TRADICIONAL;
            IF Ln_CRS_TRADICIONAL IS NOT NULL THEN
                Ln_FisIteradorI := lc_contratoFisico.NEXT(Ln_FisIteradorI);
                CONTINUE;
            END IF;

            OPEN C_TIENE_CRS_POR_PUNTO(lc_contratoFisico(Ln_FisIteradorI).puntoId);
            FETCH C_TIENE_CRS_POR_PUNTO INTO Ln_CRS_POR_PUNTO;
            CLOSE C_TIENE_CRS_POR_PUNTO;
            IF Ln_CRS_POR_PUNTO IS NOT NULL THEN
                Ln_FisIteradorI := lc_contratoFisico.NEXT(Ln_FisIteradorI);
                CONTINUE;
            END IF;

            -- SE PROCEDE A INSERTAR EL REGISTRO EN LA TABLA DE INFO_PUNTO_CLAUSULA Y INFO_PUNTO_CLAUSULA_RESP
            INSERT INTO db_documento.info_documento_relacion(
                ID_DOCUMENTO_RELACION,
                PROCESO,
                ESTADO,
                OBSERVACION,
                USUARIO_CREACION,
                FECHA_CREACION)
            VALUES(
                db_documento.SEQ_INFO_DOCUMENTO_RELACION.nextval,
                Lv_Proceso,
                'Activo',
                'SCRIPT DE REGULARIZACIÓN DE CLAUSULAS FÍSICO',
                'reg_clausulas_fisico',
                SYSDATE) RETURNING ID_DOCUMENTO_RELACION INTO ln_id_documento_relacion;

            -- SE PROCEDE A INSERTAR EL REGISTRO EN LA TABLA INFO_DOCUMENTO_RELACION_HIST
            INSERT INTO db_documento.info_documento_relacion_hist(
                ID_DOCUMENTO_RELACION_HIST,
                DOCUMENTO_RELACION_ID,
                VALOR,
                EVENTO,
                USUARIO_EVENTO,
                FECHA_EVENTO)
            VALUES(
                db_documento.SEQ_INFO_DOC_RELACION_HIST.nextval,
                ln_id_documento_relacion,
                'SCRIPT DE REGULARIZACIÓN DE CLAUSULAS FÍSICO',
                'REGULARIZACIÓN',
                'reg_clausulas_fisico',
                SYSDATE);
            --

            -- RELACIONO EL DOCUMENTO CON EL PUNTO
            INSERT INTO DB_DOCUMENTO.INFO_DOCUMENTO_CARAC(
                ID_DOCUMENTO_CARAC,
                DOCUMENTO_RELACION_ID,
                DOC_REFERENCIA_ID,
                VALOR,
                ESTADO,
                USUARIO_CREACION,
                FECHA_CREACION)
            VALUES(
                db_documento.SEQ_INFO_DOCUMENTO_CARAC.nextval,
                ln_id_documento_relacion,
                (SELECT id_doc_referencia
                 FROM DB_DOCUMENTO.ADMI_DOC_REFERENCIA 
                 WHERE nombre = 'PUNTO'),
                lc_contratoFisico(Ln_FisIteradorI).puntoId,
                'Activo',
                'reg_clausulas_fisico',
                SYSDATE);

            OPEN C_IDENTIFICACION_PUNTO(lc_contratoFisico(Ln_FisIteradorI).puntoId);
            FETCH C_IDENTIFICACION_PUNTO INTO Lv_IdentificacionCliente;
            CLOSE C_IDENTIFICACION_PUNTO;
            -- RELACIONAR EL DOCUMENTO CON LA PERSONA
            INSERT INTO DB_DOCUMENTO.INFO_DOCUMENTO_CARAC(
                ID_DOCUMENTO_CARAC,
                DOCUMENTO_RELACION_ID,
                DOC_REFERENCIA_ID,
                VALOR,
                ESTADO,
                USUARIO_CREACION,
                FECHA_CREACION)
            VALUES(
                db_documento.SEQ_INFO_DOCUMENTO_CARAC.nextval,
                ln_id_documento_relacion,
                (SELECT id_doc_referencia
                 FROM DB_DOCUMENTO.ADMI_DOC_REFERENCIA 
                 WHERE nombre = 'PERSONA'),
                Lv_IdentificacionCliente,
                'Activo',
                'reg_clausulas_fisico',
                SYSDATE);
            -- OBTENER EL ENUNCIANDO RESPUESTA PARA LA INSERCIÓN EN LA TABLA DE INFO_PUNTO_CLAUSULA_RESP
            FOR j IN C_ENUNCIADOS_CLAUSULAS
            LOOP
                --
                Ln_IdRespuesta      := NULL;
                Lv_valorRespuesta   := NULL;
                Ln_DocEnunciadoResp := NULL;
                --
                OPEN C_RESPUESTA_DEFAULT('OR-MD', j.DOCUMENTO_ENUNCIADO_ID);
                FETCH C_RESPUESTA_DEFAULT INTO Ln_IdRespuesta;
                CLOSE C_RESPUESTA_DEFAULT;

                SELECT ID_DOC_ENUNCIADO_RESP INTO Ln_DocEnunciadoResp
                FROM db_documento.admi_doc_enunciado_resp
                WHERE documento_enunciado_id = j.DOCUMENTO_ENUNCIADO_ID 
                    AND respuesta_id = Ln_IdRespuesta;

                --
                SELECT VALOR INTO Lv_valorRespuesta
                FROM db_documento.admi_respuesta
                WHERE id_respuesta = Ln_IdRespuesta;

                INSERT INTO db_documento.INFO_DOC_RESPUESTA(
                    ID_DOC_RESPUESTA,
                    DOCUMENTO_RELACION_ID,
                    DOC_ENUNCIADO_RESP_ID,
                    JUSTIFICACION_RESPUESTA,
                    ESTADO,
                    USUARIO_CREACION,
                    FECHA_CREACION)
                VALUES(
                    db_documento.SEQ_INFO_DOC_RESPUESTA.nextval,
                    ln_id_documento_relacion,
                    Ln_DocEnunciadoResp,
                    Lv_valorRespuesta,
                    'Activo',
                    'reg_clausulas_fisico',
                    SYSDATE);
            END LOOP;
            ln_contador := ln_contador + 1;
            Ln_FisIteradorI := lc_contratoFisico.NEXT(Ln_FisIteradorI);
        END LOOP;
        PV_MENSAJE := 'Proceso de regularización de clausulas finalizado!!! cantidad regularizada: ' || ln_contador;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      PV_MENSAJE := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_TAREAS_PROGRAMADAS',
                                           'CMKG_TAREAS_PROGRAMADAS.P_REGULARIZA_CONTRATO',
                                           'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','OS_USER'),USER),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
    END P_REGULARIZA_CONTRATO;
END CMKG_TAREAS_PROGRAMADAS;
/