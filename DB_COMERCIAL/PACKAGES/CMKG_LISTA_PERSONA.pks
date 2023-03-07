CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_LISTA_PERSONA AS

   /**
    * Documentación para TYPE 'Lr_RegistrosPerEnun'.
    *  
    * @author Walther Joao Gaibor <wgaibor@telconet.ec>
    * @version 1.0 12-03-2021
    */
    TYPE Lr_RegistrosPerEnun 
    IS RECORD (
                IDENTIFICACION_CLIENTE  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                TIPO_IDENTIFICACION     DB_COMERCIAL.INFO_PERSONA.TIPO_IDENTIFICACION%TYPE,
                TIPO_TRIBUTARIO         DB_COMERCIAL.INFO_PERSONA.TIPO_TRIBUTARIO%TYPE,
                TIPO_PERSONA            VARCHAR2(100),
                NOMBRES                 DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
                APELLIDOS               DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
                ENUNCIADO_ID            DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.ENUNCIADO_ID%TYPE,
                DOC_RESPUESTA_ID        DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.DOC_RESPUESTA_ID%TYPE,
                VALOR                   DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.VALOR%TYPE,
                ID_PERSONA              DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                FECHA_CREACION          VARCHAR2(100),
                FECHA_MODIFICACION      VARCHAR2(100)
            );
            
   /**
    * Documentación para TYPE 'T_RegistrosPerEnun'.
    *
    * @author Walther Joao Gaibor <wgaibor@telconet.ec>
    * @version 1.0 12-03-2021
    */                     
    TYPE T_RegistrosPerEnun IS TABLE OF Lr_RegistrosPerEnun INDEX BY PLS_INTEGER;

    /**
    * Documentación para la función P_AGREGAR_PERSONA_LISTA
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor <wgaibor@telconet.ec>
    * @version 1.0 06-11-2022
    */
    PROCEDURE P_AGREGAR_PERSONA_LISTA(Pcl_Request       IN VARCHAR2,
                                      Pv_Mensaje        OUT VARCHAR2,
                                      Pv_Status         OUT VARCHAR2,
                                      Pcl_Response      OUT SYS_REFCURSOR);

    /**
    * Documentación para la función P_BUSQUEDA_PERSONA_LISTA
    * Procedimiento que obitiene el listado de una persona.
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor <wgaibor@telconet.ec>
    * @version 1.0 06-11-2022
    *
    * @author Alex Gómez <algomez@telconet.ec>
    * @version 1.1 02/03/2023  Nuevo cod y status de error para lista vacía
    */
    PROCEDURE P_BUSQUEDA_PERSONA_LISTA(Pcl_Request       IN VARCHAR2,
                                       Pv_Mensaje        OUT VARCHAR2,
                                       Pv_Status         OUT VARCHAR2,
                                       Pcl_Response      OUT CLOB);

END CMKG_LISTA_PERSONA;

/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_LISTA_PERSONA AS

PROCEDURE P_AGREGAR_PERSONA_LISTA(Pcl_Request       IN VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) IS
    
    CURSOR C_PERSONA_EMPRESA_ROL(Cn_IdPersona IN NUMBER, Cv_ESTADO VARCHAR2, Cv_DescripcionRol VARCHAR2) IS
        SELECT
            ADRO.DESCRIPCION_ROL,
            IPEM.ID_PERSONA_ROL 
        FROM DB_GENERAL.ADMI_TIPO_ROL ATRO,
             DB_GENERAL.ADMI_ROL ADRO,
             DB_COMERCIAL.INFO_EMPRESA_ROL IERO,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPEM,
             DB_COMERCIAL.INFO_PERSONA INFP
        WHERE ATRO.ID_TIPO_ROL              = ADRO.TIPO_ROL_ID
            AND ADRO.ID_ROL                 = IERO.ROL_ID
            AND IPEM.EMPRESA_ROL_ID         = IERO.ID_EMPRESA_ROL
            AND IPEM.PERSONA_ID             = INFP.ID_PERSONA
            AND ATRO.DESCRIPCION_TIPO_ROL   = Cv_DescripcionRol
            AND ATRO.ESTADO                 = Cv_ESTADO
            AND ADRO.ESTADO                 = Cv_ESTADO
            AND IERO.ESTADO                 = Cv_ESTADO
            AND IPEM.ESTADO                 = Cv_ESTADO
            AND INFP.ESTADO                 = Cv_ESTADO
            AND INFP.ID_PERSONA             = Cn_IdPersona;
    --
    CURSOR C_CAB_ENUNCIADO(Cv_codigo VARCHAR2, Cv_ESTADO VARCHAR2) IS
        SELECT ID_CAB_ENUNCIADO
          FROM DB_DOCUMENTO.ADMI_CAB_ENUNCIADO
         WHERE CODIGO = Cv_codigo
           AND ESTADO = Cv_ESTADO;
    --
    CURSOR C_APLICA_LISTA(Cn_IdDocRespuesta NUMBER, Cn_IdEnunciado NUMBER, Cn_IdCabEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
        SELECT 
            1 EXISTE
        FROM DB_DOCUMENTO.INFO_DOC_RESPUESTA IDRE, 
             DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP ADER, 
             DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN, 
             DB_DOCUMENTO.ADMI_ENUNCIADO AENU, 
             DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO AAEN,
             DB_DOCUMENTO.ADMI_CAB_ENUNCIADO ACEN
        WHERE IDRE.DOC_ENUNCIADO_RESP_ID     = ADER.ID_DOC_ENUNCIADO_RESP
            AND ADER.DOCUMENTO_ENUNCIADO_ID  = ADEN.ID_DOCUMENTO_ENUNCIADO
            AND ADEN.ENUNCIADO_ID            = AENU.ID_ENUNCIADO
            AND AENU.ID_ENUNCIADO            = AAEN.ENUNCIADO_ID
            AND AAEN.CAB_ENUNCIADO_ID        = acen.id_cab_enunciado
            AND ADER.RESPUESTA_ID            = AAEN.VALOR
            AND IDRE.ID_DOC_RESPUESTA        = Cn_IdDocRespuesta
            AND AENU.ID_ENUNCIADO            = Cn_IdEnunciado
            AND ACEN.ID_CAB_ENUNCIADO        = Cn_IdCabEnunciado
            AND IDRE.ESTADO                  = Cv_ESTADO
            AND ADER.ESTADO                  = Cv_ESTADO
            AND ADEN.ESTADO                  = Cv_ESTADO
            AND AENU.ESTADO                  = Cv_ESTADO
            AND AAEN.ESTADO                  = Cv_ESTADO
            AND ACEN.ESTADO                  = Cv_ESTADO;
    --
    CURSOR C_EMPRESA_ROL(Cv_DescripcionTipoRol VARCHAR2, Cv_DescripcionRol VARCHAR2) IS
        SELECT
            IERO.ID_EMPRESA_ROL
        FROM DB_GENERAL.ADMI_TIPO_ROL ATRO,
             DB_GENERAL.ADMI_ROL ADRO,
             DB_COMERCIAL.INFO_EMPRESA_ROL IERO
        WHERE ATRO.ID_TIPO_ROL              = ADRO.TIPO_ROL_ID
            AND ADRO.ID_ROL                 = IERO.ROL_ID
            AND ATRO.DESCRIPCION_TIPO_ROL   = Cv_DescripcionTipoRol
            AND adro.descripcion_rol        = Cv_DescripcionRol;
    --
    CURSOR C_PERSONA_FORMA_CONTACTO(Cn_FormaContactoId NUMBER, Cv_PersonaId VARCHAR2, Cv_ESTADO VARCHAR2) IS
        SELECT
            1 EXISTE
        FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO
        WHERE FORMA_CONTACTO_ID = Cn_FormaContactoId
            AND PERSONA_ID      = Cv_PersonaId
            AND ESTADO          = Cv_ESTADO;
    --
    CURSOR C_PER_EMP_ROL_ENUNCIADO(Cv_PersonaEmpRol VARCHAR2, Cv_EnunciadoId NUMBER, Cv_Estado VARCHAR2) IS
        SELECT
            IPEE.ID_PERSONA_EMP_ROL_ENUM
        FROM DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO IPEE
        WHERE IPEE.PERSONA_EMPRESA_ROL_ID   = Cv_PersonaEmpRol
            AND IPEE.ENUNCIADO_ID           = Cv_EnunciadoId
            AND IPEE.ESTADO                 = Cv_Estado;
    --
    CURSOR C_OBTENER_RESPUESTA_CLIENTE (Cn_IdDocRelacion NUMBER, Cv_Estado VARCHAR2) IS
    SELECT
        INDR.ID_DOC_RESPUESTA        idDocRespuesta,
        INDR.JUSTIFICACION_RESPUESTA valor,
        AENU.ID_ENUNCIADO            enunciadoId
    FROM
        DB_DOCUMENTO.INFO_DOCUMENTO_RELACION               IDRE,
        DB_DOCUMENTO.INFO_DOC_RESPUESTA                    INDR,
        DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP  ADER,
        DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN,
        DB_DOCUMENTO.ADMI_ENUNCIADO           AENU
    WHERE
            INDR.DOCUMENTO_RELACION_ID  = IDRE.ID_DOCUMENTO_RELACION
        AND INDR.DOC_ENUNCIADO_RESP_ID  = ADER.ID_DOC_ENUNCIADO_RESP
        AND ADER.DOCUMENTO_ENUNCIADO_ID = ADEN.ID_DOCUMENTO_ENUNCIADO
        AND ADEN.ENUNCIADO_ID           = AENU.ID_ENUNCIADO
        AND IDRE.ID_DOCUMENTO_RELACION  = Cn_IdDocRelacion
        AND IDRE.ESTADO                 = Cv_estado
        AND INDR.ESTADO                 = Cv_estado
        AND ADER.ESTADO                 = Cv_estado
        AND ADEN.ESTADO                 = Cv_estado
        AND AENU.ESTADO                 = Cv_estado;
    --
    CURSOR C_PARAMETROS(Cv_NombreParametro VARCHAR2, Cv_Estado VARCHAR2) IS
        SELECT DET.VALOR1 AS VALOR1
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET DET
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB
          ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
          AND CAB.ESTADO           = Cv_Estado
          AND DET.ESTADO           = Cv_Estado
        ORDER BY DET.ID_PARAMETRO_DET ASC;
    --
    Lv_identificacion       VARCHAR2(300);
    Lv_tipoIdentificacion   VARCHAR2(7);
    Lv_tipoPersona          VARCHAR2(3);
    Lv_nombre               VARCHAR2(100);
    Lv_apellido             VARCHAR2(100);
    Ln_formaContacto        INTEGER;
    Lv_IdDocumentoRelacion  VARCHAR2(30);
    Lv_valor                VARCHAR2(30);
    Lv_usrCreacion          VARCHAR2(30);
    Lv_ipCreacion           VARCHAR2(30);
    Ln_IdDocRespuesta       NUMBER;
    Ln_EnunciadoId          NUMBER;
    Lv_MsgSalida            VARCHAR2(4000);

    --
    Ln_IdPersona            INTEGER;
    Lv_TipoRol              VARCHAR2(30):='listaPersona';
    Ln_IdTipoRol            INTEGER;
    Lv_TipoRolBlanca        VARCHAR2(30):='blanca';
    Lv_TipoRolNegra         VARCHAR2(30):='negra';
    Ln_personaEmpresaRolId  INTEGER;
    Ln_personaEmpresaRolBla INTEGER;
    Ln_personaEmpresaRolNgr INTEGER;
    Ln_IdFormaContacto      INTEGER;
    Lv_ValorFormaContacto   VARCHAR2(300);
    Lv_IdPersonaFormaContacto VARCHAR2(3);
    --
    Lv_CodigoListaNegra     VARCHAR2(30):='OR-LN';
    Lv_CodigoListaBlanca    VARCHAR2(30):='OR-LB';
    Ln_IdCabEnunciado       INTEGER;
    Ln_IdAplicaLista        VARCHAR2(3);
    Lb_RequierePersonaEmp   BOOLEAN:=FALSE;
    Lv_TipoRolBuscar        VARCHAR2(30);
    Ln_IdEmpresaRol         INTEGER;
    Ln_IdPersonaEmpRolEnum  INTEGER;

    --
    Lv_MsgIdentificacion    VARCHAR2(4000);
    Lv_ValorParametro       VARCHAR2(40);
    Lv_actualizarSql        VARCHAR2(4000);
BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    Lv_identificacion       := APEX_JSON.get_varchar2(p_path => 'identificacion');
    Lv_tipoIdentificacion   := APEX_JSON.get_varchar2(p_path => 'tipoIdentificacion');
    Lv_tipoPersona          := APEX_JSON.get_varchar2(p_path => 'tipoPersona');
    Lv_nombre               := APEX_JSON.get_varchar2(p_path => 'nombres');
    Lv_apellido             := APEX_JSON.get_varchar2(p_path => 'apellidos');
    Ln_formaContacto        := APEX_JSON.get_count(p_path => 'contactos');
    Lv_IdDocumentoRelacion  := APEX_JSON.get_varchar2(p_path => 'idDocumentoRelacion');
    Lv_usrCreacion          := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ipCreacion           := APEX_JSON.get_varchar2(p_path => 'ipCreacion');

    --
    IF Lv_identificacion IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El campo identificacion es obligatorio');
    END IF;
    --
    IF Lv_IdDocumentoRelacion IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El campo idDocumentoRelacion es obligatorio');
    END IF;
    --
    --
    -- CONSULTAR SI LA PERSONA EXISTE EN LA INFO_PERSONA
    --
    BEGIN
        SELECT ID_PERSONA
        INTO Ln_IdPersona
        FROM DB_COMERCIAL.INFO_PERSONA
        WHERE IDENTIFICACION_CLIENTE    = Lv_identificacion
        AND ESTADO                      IN('Activo','Pendiente');
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         Ln_IdPersona := NULL;
    END;

    IF Ln_IdPersona IS NULL THEN
        IF Lv_tipoIdentificacion IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El campo tipoIdentificacion es obligatorio');
        END IF;
        --
        IF Lv_tipoPersona IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El campo tipoPersona es obligatorio');
        END IF;
        --
        --VALIDAMOS FORMATO DE IDENTIFICACION DE PERSONA
        DB_COMERCIAL.VALIDA_IDENTIFICACION.VALIDA(Lv_TipoIdentificacion,Lv_identificacion,Lv_MsgIdentificacion);        
        IF  Lv_MsgIdentificacion  IS NOT NULL THEN  
            dbms_output.put_line( Lv_MsgIdentificacion );  
            RAISE_APPLICATION_ERROR(-20101,'[Identificación] '||Lv_MsgIdentificacion );
        END IF; 
        --
        IF Lv_nombre IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El campo nombre es obligatorio');
        END IF;
        --
        IF Lv_apellido IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El campo apellido es obligatorio');
        END IF;
        --
    ELSE
        --UPDATE DE LA TABLA INFO_PERSONA
        OPEN C_PARAMETROS('REQUIERE_ACTUALIZAR_PERSONA','Activo');
        FETCH C_PARAMETROS INTO Lv_ValorParametro;
        CLOSE C_PARAMETROS;
        --
        IF Lv_ValorParametro = 'S' THEN
            Lv_actualizarSql := 'UPDATE DB_COMERCIAL.INFO_PERSONA SET ORIGEN_WEB = ''L'' ';
            IF Lv_nombre IS NOT NULL THEN
                Lv_actualizarSql := Lv_actualizarSql || ' , NOMBRES = ''' || Lv_nombre || ''' ';
            END IF;
            IF Lv_apellido IS NOT NULL THEN
                Lv_actualizarSql := Lv_actualizarSql || ' , APELLIDOS = ''' || Lv_apellido || ''' ';
            END IF;
            Lv_actualizarSql := Lv_actualizarSql || ' WHERE ID_PERSONA = ' || Ln_IdPersona;
            --
            EXECUTE IMMEDIATE Lv_actualizarSql;
        END IF;
        --
    END IF;



    --
    IF Lv_usrCreacion IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El campo usrCreacion es obligatorio');
    END IF;
    --
    IF Lv_ipCreacion IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El campo ipCreacion es obligatorio');
    END IF;
    --
    Ln_IdCabEnunciado := NULL;
    
    --
    IF Ln_IdPersona IS NULL THEN
        --
        -- INSERTAR EN LA TABLA INFO_PERSONA
        --
        INSERT INTO DB_COMERCIAL.INFO_PERSONA
        (ID_PERSONA,
         IDENTIFICACION_CLIENTE,
         TIPO_IDENTIFICACION,
         TIPO_TRIBUTARIO,
         NOMBRES,
         APELLIDOS,
         ESTADO,
         USR_CREACION,
         IP_CREACION,
         FE_CREACION,
         ORIGEN_WEB)
        VALUES
        (DB_COMERCIAL.SEQ_INFO_PERSONA.NEXTVAL,
         Lv_identificacion,
         Lv_tipoIdentificacion,
         Lv_tipoPersona,
         Lv_nombre,
         Lv_apellido,
         'Activo',
         Lv_usrCreacion,
         Lv_ipCreacion,
         SYSDATE,
         'L') RETURNING ID_PERSONA INTO Ln_IdPersona;
    END IF;
    --
    -- CONSULTAR SI LA PERSONA TIENE FORMA DE CONTACTO
    --
    FOR i IN 1 .. Ln_formaContacto LOOP
        Ln_IdFormaContacto      := APEX_JSON.get_varchar2(p_path => 'contactos[%d].idFormaContacto', p0 => i);
        Lv_ValorFormaContacto   := APEX_JSON.get_varchar2(p_path => 'contactos[%d].valor', p0 => i);

        --
        OPEN C_PERSONA_FORMA_CONTACTO(Ln_IdFormaContacto, Ln_IdPersona, 'Activo');
        FETCH C_PERSONA_FORMA_CONTACTO INTO Lv_IdPersonaFormaContacto;
        CLOSE C_PERSONA_FORMA_CONTACTO;

        IF Lv_IdPersonaFormaContacto IS NULL THEN
            --
            -- INSERTAR EN LA TABLA INFO_PERSONA_FORMA_CONTACTO
            --
            INSERT INTO DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO
            (ID_PERSONA_FORMA_CONTACTO,
             PERSONA_ID,
             FORMA_CONTACTO_ID,
             VALOR,
             ESTADO,
             USR_CREACION,
             IP_CREACION,
             FE_CREACION)
            VALUES
            (DB_COMERCIAL.SEQ_INFO_PERSONA_FORMA_CONT.NEXTVAL,
             Ln_IdPersona,
             Ln_IdFormaContacto,
             Lv_ValorFormaContacto,
             'Activo',
             Lv_usrCreacion,
             Lv_ipCreacion,
             SYSDATE);
        END IF;
    END LOOP;
    --
    -- CONSULTAR EL TIPO ROL
    --
    BEGIN
        SELECT ID_TIPO_ROL
        INTO Ln_IdTipoRol
        FROM DB_GENERAL.ADMI_TIPO_ROL
        WHERE DESCRIPCION_TIPO_ROL = Lv_TipoRol
        AND ESTADO                 = 'Activo';
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         Ln_IdTipoRol := NULL;
    END;

    IF Ln_IdTipoRol IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El tipo de rol no existe  '||Lv_TipoRol);
    END IF;   

    --
    FOR k IN C_OBTENER_RESPUESTA_CLIENTE(Lv_IdDocumentoRelacion, 'Activo') LOOP
        Ln_EnunciadoId          := NULL;
        Ln_IdDocRespuesta       := NULL;
        Lv_valor                := NULL;
        --
        Ln_IdCabEnunciado       := NULL;
        Ln_IdAplicaLista        := NULL;
        --
        Lb_RequierePersonaEmp   := FALSE;
        --
        Ln_personaEmpresaRolId  := NULL;
        Lv_TipoRolBuscar        := NULL;
        Lv_TipoRolBuscar        := NULL;
        --
        Ln_EnunciadoId      := k.enunciadoId;
        Ln_IdDocRespuesta   := k.idDocRespuesta;
        Lv_valor            := k.valor;
        --
        dbms_output.put_line('Ln_IdDocRespuesta: '||Ln_IdDocRespuesta);
        dbms_output.put_line('Lv_Enunciado: '||Ln_EnunciadoId);
        dbms_output.put_line('Ln_IdCabEnunciado: '||Ln_IdCabEnunciado);
        --
        IF Lv_valor IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'El campo valor es obligatorio');
        END IF;
        --
        -- consultamos la cab_enunciado de lista blanca.
        --
        OPEN c_cab_enunciado(Lv_CodigoListaBlanca, 'Activo');
        FETCH c_cab_enunciado INTO Ln_IdCabEnunciado;
        CLOSE c_cab_enunciado;

        IF Ln_IdCabEnunciado IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'La lista blanca no existe');
        END IF;
        --
        OPEN C_APLICA_LISTA(Ln_IdDocRespuesta, Ln_EnunciadoId, Ln_IdCabEnunciado, 'Activo');
        FETCH C_APLICA_LISTA INTO Ln_IdAplicaLista;
        CLOSE C_APLICA_LISTA;

        IF Ln_IdAplicaLista IS NOT NULL OR Ln_IdAplicaLista = 1 THEN
            --
            -- Se enciende la bandera para que se cree el rol de lista blanca
            --
            Lb_RequierePersonaEmp := TRUE;
            Lv_TipoRolBuscar      := Lv_TipoRolBlanca;
            DBMS_OUTPUT.PUT_LINE('Se enciende la bandera para que se cree el rol de lista blanca'||Lv_TipoRolBuscar);
        END IF;

        --
        Ln_IdCabEnunciado := NULL;
        Ln_IdAplicaLista  := NULL;

        --
        -- consultamos la cab_enunciado de lista negra.
        --
        OPEN c_cab_enunciado(Lv_CodigoListaNegra, 'Activo');
        FETCH c_cab_enunciado INTO Ln_IdCabEnunciado;
        CLOSE c_cab_enunciado;

        IF Ln_IdCabEnunciado IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'La lista negra no existe');
        END IF;

        --
        -- CONSULTO SI EL ENUNCIADO CORRESPONDE A UNA LISTA NEGRA
        --
        dbms_output.put_line('Ln_IdDocRespuesta: '||Ln_IdDocRespuesta);
        dbms_output.put_line('Lv_Enunciado: '||Ln_EnunciadoId);
        dbms_output.put_line('Ln_IdCabEnunciado: '||Ln_IdCabEnunciado);
        OPEN C_APLICA_LISTA(Ln_IdDocRespuesta, Ln_EnunciadoId, Ln_IdCabEnunciado, 'Activo');
        FETCH C_APLICA_LISTA INTO Ln_IdAplicaLista;
        CLOSE C_APLICA_LISTA;

        IF Ln_IdAplicaLista IS NOT NULL OR Ln_IdAplicaLista = 1 THEN
            --
            -- Se enciende la bandera para que se cree el rol de lista negra
            --
            Lb_RequierePersonaEmp := TRUE;
            Lv_TipoRolBuscar      := Lv_TipoRolNegra;
            DBMS_OUTPUT.PUT_LINE('Se enciende la bandera para que se cree el rol de lista negra'||Lv_TipoRolBuscar);
        END IF;

        --
        -- CONSULTAR SI LA PERSONA TIENE ROL DE LISTA BLANCA O NEGRA
        --
        FOR persona IN C_PERSONA_EMPRESA_ROL(Ln_IdPersona, 'Activo', Lv_TipoRol) LOOP
            IF persona.DESCRIPCION_ROL = Lv_TipoRolBlanca THEN
                Ln_personaEmpresaRolBla := persona.ID_PERSONA_ROL;
                Ln_personaEmpresaRolId  := Ln_personaEmpresaRolBla;
            END IF;
            IF persona.DESCRIPCION_ROL = Lv_TipoRolNegra THEN
                Ln_personaEmpresaRolNgr := persona.ID_PERSONA_ROL;
                Ln_personaEmpresaRolId  := Ln_personaEmpresaRolNgr;
            END IF;
        END LOOP;
        --

        IF Lv_TipoRolBuscar IS NULL THEN
            CONTINUE;
        END IF;

        --CONSULTAR SI EL ENUNCIADO TIENE REGISTRADA UNA LISTA BLANCA O NEGRA.
        IF Lb_RequierePersonaEmp = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('NO SE REQUIERE CREAR ROL DE LISTA BLANCA O NEGRA');
        END IF;

        --CONSULTAR EN LA INFO_PERSONA_EMPRESA_ROL EXISTE CON EL ROL LISTA BLANCA O NEGRA
        --EN BASE A LA ENCUESTA LO QUE HUBIERE ENCONTRADO
        IF Ln_personaEmpresaRolId IS NULL THEN
            dbms_output.put_line('Lv_TipoRol  '||Lv_TipoRol);
            dbms_output.put_line('Lv_TipoRolBuscar  '||Lv_TipoRolBuscar);
            OPEN C_EMPRESA_ROL(Lv_TipoRol, Lv_TipoRolBuscar);
            FETCH C_EMPRESA_ROL INTO Ln_IdEmpresaRol;
            close C_EMPRESA_ROL;

            INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
            (ID_PERSONA_ROL,
            PERSONA_ID,
            EMPRESA_ROL_ID,
            ESTADO,
            USR_CREACION,
            IP_CREACION,
            FE_CREACION)
            VALUES
            (DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL,
            Ln_IdPersona,
            Ln_IdEmpresaRol,
            'Activo',
            Lv_usrCreacion,
            Lv_ipCreacion,
            SYSDATE) RETURNING ID_PERSONA_ROL INTO Ln_personaEmpresaRolId;
        END IF;

        --
        IF Lb_RequierePersonaEmp = TRUE THEN
            -- CONSULTO SI YA SE HA REGISTRADO EL ENUNCIADO Y LA DOC_RESPUESTA_ID EN LA TABLA INFO_PERSONA_EMPRESA_ROL_ENUNCIADO
            -- DE EXISTIR REGISTROS LOS ELIMINO PARA REGISTRAR LOS NUEVOS.
            FOR perEnunciado IN C_PER_EMP_ROL_ENUNCIADO(Ln_personaEmpresaRolId, Ln_EnunciadoId, 'Activo') LOOP
                UPDATE DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO
                SET ESTADO                  = 'Eliminado',
                    USUARIO_MODIFICACION    = Lv_usrCreacion,
                    IP_MODIFICACION         = Lv_ipCreacion,
                    FECHA_MODIFICACION      = SYSDATE
                WHERE ID_PERSONA_EMP_ROL_ENUM = perEnunciado.ID_PERSONA_EMP_ROL_ENUM;
            END LOOP;
            --
            -- INSERTAR EN LA TABLA PERSONA_EMPRESA_ROL
            --
            INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO
                (ID_PERSONA_EMP_ROL_ENUM,
                PERSONA_EMPRESA_ROL_ID,
                ENUNCIADO_ID,
                DOC_RESPUESTA_ID,
                ESTADO,
                VALOR,
                USUARIO_CREACION,
                IP_CREACION,
                FECHA_CREACION)
            VALUES
                (DB_COMERCIAL.SEQ_INFO_PER_EMP_ROL_ENU.NEXTVAL,
                Ln_personaEmpresaRolId,
                Ln_EnunciadoId,
                Ln_IdDocRespuesta,
                'Activo',
                Lv_valor,
                Lv_usrCreacion,
                Lv_ipCreacion,
                SYSDATE) RETURNING ID_PERSONA_EMP_ROL_ENUM INTO Ln_IdPersonaEmpRolEnum;
        
        END IF;
        --
        Lv_MsgSalida := Lv_MsgSalida||' -  Agregado a lista '||Lv_TipoRolBuscar||' - ID_PERSONA_EMP_ROL_ENUM '||Ln_IdPersonaEmpRolEnum;
    END LOOP;
    --    
    OPEN Pcl_Response FOR
    SELECT Lv_MsgSalida AS mensaje
    FROM   DUAL;
    --
    Pv_Mensaje   := Pv_Mensaje||' Transacción realizada correctamente.';
    Pv_Status    := 'OK';
    --
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR';
        Pcl_Response  :=  NULL;
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        IF SQLCODE = -20101 THEN
            Pv_Status  := 'ERROR-CONTROL';
        END IF;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                                'DB_COMERCIAL.CMKG_LISTA_PERSONA.P_AGREGAR_PERSONA_LISTA',
                                                'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                Lv_usrCreacion,
                                                SYSDATE,
                                                '127.0.0.1');
END P_AGREGAR_PERSONA_LISTA;

PROCEDURE P_BUSQUEDA_PERSONA_LISTA(Pcl_Request       IN VARCHAR2,
                                   Pv_Mensaje        OUT VARCHAR2,
                                   Pv_Status         OUT VARCHAR2,
                                   Pcl_Response      OUT CLOB) IS
    --
    CURSOR C_APLICA_LISTA(Cn_IdDocRespuesta NUMBER, Cn_IdEnunciado NUMBER, Cn_IdCabEnunciado NUMBER, Cv_ESTADO VARCHAR2) IS
        SELECT 
            ACEN.CODIGO,
            AENU.DESCRIPCION
        FROM DB_DOCUMENTO.INFO_DOC_RESPUESTA IDRE, 
             DB_DOCUMENTO.ADMI_DOC_ENUNCIADO_RESP ADER, 
             DB_DOCUMENTO.ADMI_DOCUMENTO_ENUNCIADO ADEN, 
             DB_DOCUMENTO.ADMI_ENUNCIADO AENU, 
             DB_DOCUMENTO.ADMI_ATRIBUTO_ENUNCIADO AAEN,
             DB_DOCUMENTO.ADMI_CAB_ENUNCIADO ACEN
        WHERE IDRE.DOC_ENUNCIADO_RESP_ID     = ADER.ID_DOC_ENUNCIADO_RESP
            AND ADER.DOCUMENTO_ENUNCIADO_ID  = ADEN.ID_DOCUMENTO_ENUNCIADO
            AND ADEN.ENUNCIADO_ID            = AENU.ID_ENUNCIADO
            AND AENU.ID_ENUNCIADO            = AAEN.ENUNCIADO_ID
            AND AAEN.CAB_ENUNCIADO_ID        = acen.id_cab_enunciado
            AND ADER.RESPUESTA_ID            = AAEN.VALOR
            AND IDRE.ID_DOC_RESPUESTA        = Cn_IdDocRespuesta
            AND AENU.ID_ENUNCIADO            = Cn_IdEnunciado
            AND ACEN.ID_CAB_ENUNCIADO        = Cn_IdCabEnunciado
            AND IDRE.ESTADO                  = Cv_ESTADO
            AND ADER.ESTADO                  = Cv_ESTADO
            AND ADEN.ESTADO                  = Cv_ESTADO
            AND AENU.ESTADO                  = Cv_ESTADO
            AND AAEN.ESTADO                  = Cv_ESTADO
            AND ACEN.ESTADO                  = Cv_ESTADO
            AND ROWNUM < 2;
    --
    CURSOR C_CAB_ENUNCIADO(Cv_codigo VARCHAR2, Cv_ESTADO VARCHAR2) IS
        SELECT ID_CAB_ENUNCIADO
          FROM DB_DOCUMENTO.ADMI_CAB_ENUNCIADO
         WHERE CODIGO = Cv_codigo
           AND ESTADO = Cv_ESTADO;
    --
    CURSOR C_FORMA_CONTACTO (Cn_IdPersona NUMBER, Cv_ESTADO VARCHAR2) IS
        SELECT IPFC.FORMA_CONTACTO_ID, IPFC.VALOR
        FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC
        WHERE PERSONA_ID = Cn_IdPersona
            AND ESTADO   = Cv_ESTADO;
    --
    CURSOR C_POLITICA (Cv_enunciadoId VARCHAR2) IS
    select
        ADEN.DESCRIPCION
    from
        DB_DOCUMENTO.ADMI_ENUNCIADO ADEN
    where
        ADEN.ID_ENUNCIADO = (
            select
                ENUNCIADO_ID
            from
                DB_DOCUMENTO.ADMI_ENUNCIADO ADENU
            where
                ADENU.ID_ENUNCIADO = Cv_enunciadoId);
    --
    CURSOR C_CLAUSULA (Cv_enunciadoId VARCHAR2) IS
    select
        ADENU.DESCRIPCION
    from
        DB_DOCUMENTO.ADMI_ENUNCIADO ADENU
    where
        ADENU.ID_ENUNCIADO = Cv_enunciadoId;

    Lv_identificacion       VARCHAR2(100);
    Lv_tipoIdentificacion   VARCHAR2(7);
    Lv_tipoPersona          VARCHAR2(30);
    Lv_usrCreacion          VARCHAR2(30);
    Lv_ipCreacion           VARCHAR2(30);
    Lv_estado               VARCHAR2(300);
    Lv_lista                VARCHAR2(50);
    Ln_IdEnunciado          NUMBER;
    Lv_IdFormaContacto      VARCHAR2(50);
    Lv_valorFormaContacto   VARCHAR2(500);
    Lv_nombre               VARCHAR2(500);
    Lv_apellido             VARCHAR2(500);
    --
    La_RegistrosPerEnun     T_RegistrosPerEnun;
    Lv_sqlPerEmpRolEnum     VARCHAR2(4000);
    Lv_sqlField             VARCHAR2(3000);
    Lv_sqlTable             VARCHAR2(3000);
    Lv_sqlWhere             VARCHAR2(3000);
    --
    Lv_codigoBlanco         VARCHAR2(30):='OR-LB';
    Lv_codigoNegro          VARCHAR2(30):='OR-LN';
    Lv_codigoBuscar         VARCHAR2(30);
    Ln_IdCabEnunciado       NUMBER;
    Lv_CodigoEncuesta       VARCHAR2(30);
    Lv_DescEncuesta         VARCHAR2(3000);
    Lb_HayProceso           BOOLEAN:=FALSE;
    Lv_ExisteEnunLista      VARCHAR2(30):='N';
    Lv_clausula             VARCHAR2(3000);
    Lv_politica             VARCHAR2(3000);
    Ln_IteradorI            NUMBER;

    --
    Lv_CodigoEncuestaBlanco  VARCHAR2(30);
    Lv_CodigoEncuestaNegra   VARCHAR2(30);
    Ln_IdCabEnunciadoBlanco  NUMBER;
    Ln_IdCabEnunciadoNegro   NUMBER;
BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_identificacion       := APEX_JSON.get_varchar2(p_path => 'identificacion');
    Lv_tipoIdentificacion   := APEX_JSON.get_varchar2(p_path => 'tipoIdentificacion');
    Lv_tipoPersona          := APEX_JSON.get_varchar2(p_path => 'tipoPersona');
    Lv_usrCreacion          := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ipCreacion           := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_estado               := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_lista                := APEX_JSON.get_varchar2(p_path => 'lista');
    Ln_IdEnunciado          := APEX_JSON.get_varchar2(p_path => 'idEnunciado');
    Lv_IdFormaContacto      := APEX_JSON.get_varchar2(p_path => 'detalleContacto.formaContacto');
    Lv_valorFormaContacto   := APEX_JSON.get_varchar2(p_path => 'detalleContacto.contacto');
    Lv_nombre               := APEX_JSON.get_varchar2(p_path => 'nombres');
    Lv_apellido             := APEX_JSON.get_varchar2(p_path => 'apellidos');

    IF Lv_estado IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El campo estado es obligatorio');
    END IF;
    --
    
    --
    Lv_sqlField     := 'SELECT
                                INFP.IDENTIFICACION_CLIENTE,
                                INFP.TIPO_IDENTIFICACION,
                                INFP.TIPO_TRIBUTARIO,
                                NVL((SELECT
                                    AROL.descripcion_rol 
                                    FROM DB_COMERCIAL.info_persona_empresa_rol PERO, 
                                        DB_COMERCIAL.info_empresa_rol IROL, 
                                        DB_GENERAL.admi_rol AROL,  
                                        DB_GENERAL.admi_tipo_rol ATRO,
                                        DB_COMERCIAL.INFO_PERSONA ipsa
                                    WHERE PERO.empresa_rol_id = irol.id_empresa_rol
                                    AND IROL.rol_id = AROL.id_rol
                                    AND ATRO.id_tipo_rol = AROL.tipo_rol_id
                                    AND pero.persona_id = ipsa.id_persona
                                    AND ipsa.id_persona = INFP.ID_PERSONA
                                    AND PERO.estado = ''Activo''
                                    AND PERO.EMPRESA_ROL_ID in(813,1542)
                                    AND IROL.estado = ''Activo''
                                    AND IROL.empresa_cod = 18
                                    AND atro.descripcion_tipo_rol <> ''listaPersona''
                                    AND ROWNUM < 2),''PROSPECTO'') TIPO_PERSONA,
                                INFP.NOMBRES, 
                                INFP.APELLIDOS,
                                IERE.ENUNCIADO_ID,
                                IERE.DOC_RESPUESTA_ID,
                                IERE.valor,
                                INFP.ID_PERSONA,
                                TO_CHAR(IERE.FECHA_CREACION, ''DD/MM/YYYY HH24:MI:SS'') FECHA_CREACION,
                                TO_CHAR(IERE.FECHA_MODIFICACION, ''DD/MM/YYYY HH24:MI:SS'') FECHA_MODIFICACION';
    Lv_sqlTable     := ' 
                            FROM DB_COMERCIAL.INFO_PERSONA INFP,
                                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                                DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO IERE';

    Lv_sqlWhere     := '                             
                            WHERE INFP.ID_PERSONA = IPER.PERSONA_ID
                                AND IPER.ID_PERSONA_ROL = IERE.PERSONA_EMPRESA_ROL_ID
                                AND IPER.ID_PERSONA_ROL = IERE.PERSONA_EMPRESA_ROL_ID
                                AND IERE.ESTADO IN (SELECT REGEXP_SUBSTR(TRIM('''||Lv_estado||'''),''[^,]+'', 1, LEVEL) FROM DUAL
                                CONNECT BY REGEXP_SUBSTR(TRIM('''||Lv_estado||'''),''[^,]+'', 1, LEVEL) IS NOT NULL) ';
    --
    IF Lv_identificacion IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND INFP.IDENTIFICACION_CLIENTE = '''||Lv_identificacion||''' ';
    END IF;
    --
    IF Lv_tipoIdentificacion IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND INFP.TIPO_IDENTIFICACION = '''||Lv_tipoIdentificacion||''' ';
    END IF;
    --
    IF Lv_tipoPersona IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND INFP.TIPO_TRIBUTARIO = '''||Lv_tipoPersona||''' ';
    END IF;
    --
    IF Ln_IdEnunciado IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND IERE.ENUNCIADO_ID = '''||Ln_IdEnunciado||''' ';
    END IF;
    --
    IF Lv_nombre IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND INFP.NOMBRES = '''||Lv_nombre||''' ';
    END IF;
    --
    IF Lv_apellido IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND INFP.APELLIDOS = '''||Lv_apellido||''' ';
    END IF;
    --
    IF Lv_IdFormaContacto IS NOT NULL AND Lv_valorFormaContacto IS NOT NULL THEN
        Lv_sqlWhere := Lv_sqlWhere||' AND 1 = (
                                                SELECT DISTINCT
                                                    ( 1 )
                                                FROM
                                                    db_comercial.info_persona_forma_contacto IFCT
                                                WHERE
                                                    IFCT.PERSONA_ID = INFP.ID_PERSONA
                                                    AND IFCT.FORMA_CONTACTO_ID = '''||Lv_IdFormaContacto||'''
                                                    AND IFCT.VALOR = '''||Lv_valorFormaContacto||'''
                                                    AND IFCT.ESTADO = ''Activo'' ) ';
    END IF;
    --
    Lv_sqlPerEmpRolEnum := Lv_sqlField||Lv_sqlTable|| Lv_sqlWhere ||' ORDER BY INFP.IDENTIFICACION_CLIENTE, INFP.TIPO_IDENTIFICACION, INFP.TIPO_TRIBUTARIO, IERE.ENUNCIADO_ID, IERE.DOC_RESPUESTA_ID ';
    dbms_output.put_line(Lv_sqlPerEmpRolEnum);
    EXECUTE IMMEDIATE Lv_sqlPerEmpRolEnum BULK COLLECT INTO La_RegistrosPerEnun;
    --
    IF La_RegistrosPerEnun.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20102, 'No se encontraron registros');
    END IF;
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    apex_json.open_array;
    Ln_IteradorI := La_RegistrosPerEnun.FIRST;
    WHILE (Ln_IteradorI IS NOT NULL) 
    LOOP
        Lv_codigoBuscar     := NULL;
        Ln_IdCabEnunciado   := NULL;
        Lv_CodigoEncuesta   := NULL;
        Lv_DescEncuesta     := NULL;
        Lv_politica         := NULL;
        Lv_clausula         := NULL;
        Lb_HayProceso       := TRUE;
        Lv_ExisteEnunLista  := 'N';

        --
        Lv_CodigoEncuestaBlanco := NULL;
        Lv_CodigoEncuestaNegra  := NULL;
        Ln_IdCabEnunciadoBlanco := NULL;
        Ln_IdCabEnunciadoNegro  := NULL;

        --
        -- CONSULTAR SI ENVIAN EL PARAMETRO LISTA; SI ES ASI, SE CONSULTA LA LISTA DE PERSONAS QUE TENGAN EL ROL DE LA LISTA
        --
        IF Lv_lista IS NOT NULL THEN
            IF TRIM(UPPER(Lv_lista)) = 'BLANCA' THEN
                Lv_codigoBuscar := Lv_codigoBlanco;
            END IF;
            IF TRIM(UPPER(Lv_lista)) = 'NEGRA' THEN
                Lv_codigoBuscar := Lv_codigoNegro;
            END IF;
            IF Lv_codigoBuscar IS NULL THEN
                RAISE_APPLICATION_ERROR(-20101, 'El parametro lista no es valido - '||Lv_lista);
            ELSE
                --
                OPEN c_cab_enunciado(Lv_codigoBuscar, 'Activo');
                FETCH c_cab_enunciado INTO Ln_IdCabEnunciado;
                CLOSE c_cab_enunciado;
                --
                OPEN C_APLICA_LISTA(La_RegistrosPerEnun(Ln_IteradorI).DOC_RESPUESTA_ID, La_RegistrosPerEnun(Ln_IteradorI).ENUNCIADO_ID, Ln_IdCabEnunciado, 'Activo');
                FETCH C_APLICA_LISTA INTO Lv_CodigoEncuesta, Lv_DescEncuesta;
                CLOSE C_APLICA_LISTA;
                --
                -- Si el id de la lista es nulo, quiere decir que no esta en la lista y no lo agrego al arreglo
                --
                IF Lv_CodigoEncuesta IS NULL THEN
                    Ln_IteradorI := La_RegistrosPerEnun.NEXT(Ln_IteradorI);
                    CONTINUE;
                END IF;
            END IF;
        ELSE
            --Obtener el id de la lista blanca
            OPEN c_cab_enunciado(Lv_codigoBlanco, 'Activo');
            FETCH c_cab_enunciado INTO Ln_IdCabEnunciadoBlanco;
            CLOSE c_cab_enunciado;
            --Obtener el id de la lista negra
            OPEN c_cab_enunciado(Lv_codigoNegro, 'Activo');
            FETCH c_cab_enunciado INTO Ln_IdCabEnunciadoNegro;
            CLOSE c_cab_enunciado;
            --
            OPEN C_APLICA_LISTA(La_RegistrosPerEnun(Ln_IteradorI).DOC_RESPUESTA_ID, La_RegistrosPerEnun(Ln_IteradorI).ENUNCIADO_ID, Ln_IdCabEnunciadoBlanco, 'Activo');
            FETCH C_APLICA_LISTA INTO Lv_CodigoEncuestaBlanco, Lv_DescEncuesta;
            CLOSE C_APLICA_LISTA;

            OPEN C_APLICA_LISTA(La_RegistrosPerEnun(Ln_IteradorI).DOC_RESPUESTA_ID, La_RegistrosPerEnun(Ln_IteradorI).ENUNCIADO_ID, Ln_IdCabEnunciadoNegro, 'Activo');
            FETCH C_APLICA_LISTA INTO Lv_CodigoEncuestaNegra, Lv_DescEncuesta;
            CLOSE C_APLICA_LISTA;

            IF Lv_CodigoEncuestaBlanco IS NOT NULL THEN
                Lv_CodigoEncuesta := Lv_CodigoEncuestaBlanco;
            END IF;

            IF Lv_CodigoEncuestaNegra IS NOT NULL THEN
                Lv_CodigoEncuesta := Lv_CodigoEncuestaNegra;
            END IF;
            --
            -- Si el id de la lista es nulo, quiere decir que no esta en la lista y no lo agrego al arreglo
            --
            IF Lv_CodigoEncuesta IS NULL THEN
                Ln_IteradorI := La_RegistrosPerEnun.NEXT(Ln_IteradorI);
                CONTINUE;
            ELSE
                Lv_ExisteEnunLista := 'S';
            END IF;

            --
        END IF;
        IF Lv_ExisteEnunLista = 'N' AND Lv_lista IS NULL THEN
            CONTINUE;
        END IF;
        --
        APEX_JSON.OPEN_OBJECT;
        --
        APEX_JSON.WRITE('identificacion', La_RegistrosPerEnun(Ln_IteradorI).IDENTIFICACION_CLIENTE);
        APEX_JSON.WRITE('tipoIdentificacion', La_RegistrosPerEnun(Ln_IteradorI).TIPO_IDENTIFICACION);
        APEX_JSON.WRITE('tipoTributario', La_RegistrosPerEnun(Ln_IteradorI).TIPO_TRIBUTARIO);
        APEX_JSON.WRITE('tipoPersona', La_RegistrosPerEnun(Ln_IteradorI).TIPO_PERSONA);
        APEX_JSON.WRITE('nombres', La_RegistrosPerEnun(Ln_IteradorI).NOMBRES);
        APEX_JSON.WRITE('apellido', La_RegistrosPerEnun(Ln_IteradorI).APELLIDOS);
        APEX_JSON.WRITE('idEnunciado', La_RegistrosPerEnun(Ln_IteradorI).ENUNCIADO_ID);
        APEX_JSON.WRITE('idDocRespuesta', La_RegistrosPerEnun(Ln_IteradorI).DOC_RESPUESTA_ID);
        APEX_JSON.WRITE('valor', La_RegistrosPerEnun(Ln_IteradorI).VALOR);
        APEX_JSON.WRITE('idPersona', La_RegistrosPerEnun(Ln_IteradorI).ID_PERSONA);
        APEX_JSON.WRITE('codigoEnunciado', Lv_CodigoEncuesta);
        APEX_JSON.WRITE('descripcionEnunciado', Lv_DescEncuesta);
        APEX_JSON.WRITE('feCreacion', La_RegistrosPerEnun(Ln_IteradorI).FECHA_CREACION);
        APEX_JSON.WRITE('feModificacion', La_RegistrosPerEnun(Ln_IteradorI).FECHA_MODIFICACION);


        IF Lv_CodigoEncuesta = Lv_codigoBlanco THEN
            APEX_JSON.WRITE('lista', 'blanca');
        END IF;
        IF Lv_CodigoEncuesta = Lv_codigoNegro THEN
            APEX_JSON.WRITE('lista', 'negra');
        END IF;
        -- valido si es una politica
        OPEN C_POLITICA(La_RegistrosPerEnun(Ln_IteradorI).ENUNCIADO_ID);
        FETCH C_POLITICA INTO Lv_politica;
        CLOSE C_POLITICA;

        -- veo si es una hija
        OPEN C_CLAUSULA(La_RegistrosPerEnun(Ln_IteradorI).ENUNCIADO_ID);
        FETCH C_CLAUSULA INTO Lv_clausula;
        CLOSE C_CLAUSULA;

        IF Lv_politica IS NULL AND Lv_clausula IS NOT NULL THEN
            Lv_politica := Lv_clausula;
            Lv_clausula := NULL;
        END IF;

        APEX_JSON.WRITE('politica', Lv_politica);
        APEX_JSON.WRITE('clausula', Lv_clausula);
        --
        APEX_JSON.OPEN_ARRAY('contactos');
        FOR J IN C_FORMA_CONTACTO(La_RegistrosPerEnun(Ln_IteradorI).ID_PERSONA, 'Activo') LOOP
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('idFormaContacto', J.FORMA_CONTACTO_ID);
            APEX_JSON.WRITE('valor', J.VALOR);
            APEX_JSON.CLOSE_OBJECT;
        END LOOP;
        APEX_JSON.CLOSE_ARRAY;  -- contactos
        --
        APEX_JSON.CLOSE_OBJECT;
        --
        Ln_IteradorI := La_RegistrosPerEnun.NEXT(Ln_IteradorI);
    END LOOP;
    --
    APEX_JSON.CLOSE_ARRAY;
    apex_json.close_all;
    Pcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    IF NOT Lb_HayProceso THEN
      RAISE_APPLICATION_ERROR(-20102, 'No existe registros a buscar');
    END IF;
    --
    Pv_Mensaje   := Pv_Mensaje||' Transacción realizada correctamente.';
    Pv_Status    := 'OK';
    --
EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR';
        Pcl_Response  :=  NULL;
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        IF SQLCODE = -20101 THEN
            Pv_Status  := 'ERROR-CONTROL';
        END IF;
        IF SQLCODE = -20102 THEN
            Pv_Status  := 'ERROR-NOT-FOUND';
        END IF;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                                'DB_COMERCIAL.CMKG_LISTA_PERSONA.P_BUSQUEDA_PERSONA_LISTA',
                                                'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                Lv_usrCreacion,
                                                SYSDATE,
                                                '127.0.0.1');
END P_BUSQUEDA_PERSONA_LISTA;

END CMKG_LISTA_PERSONA;
/