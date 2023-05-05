CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PERSONA_T AS

   /**
    * Inserta un registro en INFO_PERSONA,
    * recibe como parametro un objeto de tipo INFO_PERSONA.
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @since 1.0 28-10-2018
    **/
    PROCEDURE P_INSERT_INFO_PERSONA (
        Pr_Info_Persona   IN                INFO_PERSONA%ROWTYPE,
        Pn_IdPersona      OUT               INFO_PERSONA.ID_PERSONA%TYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

   /**
    * Actualiza un registro en INFO_PERSONA,
    * recibe como parametro un objeto de tipo INFO_PERSONA.
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @since 1.0 28-10-2018
    **/

    PROCEDURE P_UPDATE_INFO_PERSONA (
        Pr_Info_Persona   IN                INFO_PERSONA%ROWTYPE,
        Pn_IdPersona      IN                INFO_PERSONA.ID_PERSONA%TYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );   
    
    /**
    * Actualiza un registro en INFO_PERSONA, para la sincronización de empleados
    * recibe como parametro un objeto de tipo INFO_PERSONA.
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @since 1.0 28-10-2018
    **/

    PROCEDURE P_UPDATE_INFO_PERSONA_SINC_EMP (
        Pr_Info_Persona   IN                INFO_PERSONA%ROWTYPE,
        Pn_IdPersona      IN                INFO_PERSONA.ID_PERSONA%TYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

END CMKG_INFO_PERSONA_T;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PERSONA_T AS

    PROCEDURE P_INSERT_INFO_PERSONA (
        Pr_Info_Persona   IN                INFO_PERSONA%ROWTYPE,
        Pn_IdPersona      OUT               INFO_PERSONA.ID_PERSONA%TYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
    BEGIN
        Pn_IdPersona := SEQ_INFO_PERSONA.NEXTVAL;
        INSERT INTO INFO_PERSONA (
            ID_PERSONA,
            TITULO_ID,
            ORIGEN_PROSPECTO,
            TIPO_IDENTIFICACION,
            IDENTIFICACION_CLIENTE,
            TIPO_EMPRESA,
            TIPO_TRIBUTARIO,
            NOMBRES,
            APELLIDOS,
            RAZON_SOCIAL,
            REPRESENTANTE_LEGAL,
            NACIONALIDAD,
            DIRECCION,
            LOGIN,
            CARGO,
            DIRECCION_TRIBUTARIA,
            GENERO,
            ESTADO,
            FE_CREACION,
            USR_CREACION,
            IP_CREACION,
            ESTADO_CIVIL,
            FECHA_NACIMIENTO,
            CALIFICACION_CREDITICIA,
            ORIGEN_INGRESOS,
            ORIGEN_WEB,
            CONTRIBUYENTE_ESPECIAL,
            PAGA_IVA,
            NUMERO_CONADIS,
            PAIS_ID
        ) VALUES (
            Pn_IdPersona,
            Pr_Info_Persona.TITULO_ID,
            Pr_Info_Persona.ORIGEN_PROSPECTO,
            Pr_Info_Persona.TIPO_IDENTIFICACION,
            Pr_Info_Persona.IDENTIFICACION_CLIENTE,
            Pr_Info_Persona.TIPO_EMPRESA,
            Pr_Info_Persona.TIPO_TRIBUTARIO,
            Pr_Info_Persona.NOMBRES,
            Pr_Info_Persona.APELLIDOS,
            Pr_Info_Persona.RAZON_SOCIAL,
            Pr_Info_Persona.REPRESENTANTE_LEGAL,
            Pr_Info_Persona.NACIONALIDAD,
            Pr_Info_Persona.DIRECCION,
            Pr_Info_Persona.LOGIN,
            Pr_Info_Persona.CARGO,
            Pr_Info_Persona.DIRECCION_TRIBUTARIA,
            Pr_Info_Persona.GENERO,
            Pr_Info_Persona.ESTADO,
            Pr_Info_Persona.FE_CREACION,
            Pr_Info_Persona.USR_CREACION,
            Pr_Info_Persona.IP_CREACION,
            Pr_Info_Persona.ESTADO_CIVIL,
            Pr_Info_Persona.FECHA_NACIMIENTO,
            Pr_Info_Persona.CALIFICACION_CREDITICIA,
            Pr_Info_Persona.ORIGEN_INGRESOS,
            Pr_Info_Persona.ORIGEN_WEB,
            Pr_Info_Persona.CONTRIBUYENTE_ESPECIAL,
            Pr_Info_Persona.PAGA_IVA,
            Pr_Info_Persona.NUMERO_CONADIS,
            Pr_Info_Persona.PAIS_ID
        );

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_INFO_PERSONA;

    PROCEDURE P_UPDATE_INFO_PERSONA (
        Pr_Info_Persona   IN                INFO_PERSONA%ROWTYPE,
        Pn_IdPersona      IN                INFO_PERSONA.ID_PERSONA%TYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
    BEGIN
        UPDATE INFO_PERSONA
        SET
            TITULO_ID = Pr_Info_Persona.TITULO_ID,
            ORIGEN_PROSPECTO = Pr_Info_Persona.ORIGEN_PROSPECTO,
            TIPO_IDENTIFICACION = Pr_Info_Persona.TIPO_IDENTIFICACION,
            IDENTIFICACION_CLIENTE = Pr_Info_Persona.IDENTIFICACION_CLIENTE,
            TIPO_EMPRESA = Pr_Info_Persona.TIPO_EMPRESA,
            TIPO_TRIBUTARIO = Pr_Info_Persona.TIPO_TRIBUTARIO,
            NOMBRES = Pr_Info_Persona.NOMBRES,
            APELLIDOS = Pr_Info_Persona.APELLIDOS,
            RAZON_SOCIAL = Pr_Info_Persona.RAZON_SOCIAL,
            REPRESENTANTE_LEGAL = Pr_Info_Persona.REPRESENTANTE_LEGAL,
            NACIONALIDAD = Pr_Info_Persona.NACIONALIDAD,
            DIRECCION = Pr_Info_Persona.DIRECCION,
            LOGIN = Pr_Info_Persona.LOGIN,
            CARGO = Pr_Info_Persona.CARGO,
            DIRECCION_TRIBUTARIA = Pr_Info_Persona.DIRECCION_TRIBUTARIA,
            GENERO = Pr_Info_Persona.GENERO,
            ESTADO = Pr_Info_Persona.ESTADO,
            ESTADO_CIVIL = Pr_Info_Persona.ESTADO_CIVIL,
            FECHA_NACIMIENTO = Pr_Info_Persona.FECHA_NACIMIENTO,
            CALIFICACION_CREDITICIA = Pr_Info_Persona.CALIFICACION_CREDITICIA,
            ORIGEN_INGRESOS = Pr_Info_Persona.ORIGEN_INGRESOS,
            ORIGEN_WEB = Pr_Info_Persona.ORIGEN_WEB,
            CONTRIBUYENTE_ESPECIAL = Pr_Info_Persona.CONTRIBUYENTE_ESPECIAL,
            PAGA_IVA = Pr_Info_Persona.PAGA_IVA,
            NUMERO_CONADIS = Pr_Info_Persona.NUMERO_CONADIS,
            PAIS_ID = Pr_Info_Persona.PAIS_ID
        WHERE
            ID_PERSONA = Pn_IdPersona;

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia modificada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_UPDATE_INFO_PERSONA;

    PROCEDURE P_UPDATE_INFO_PERSONA_SINC_EMP (
        Pr_Info_Persona   IN                INFO_PERSONA%ROWTYPE,
        Pn_IdPersona      IN                INFO_PERSONA.ID_PERSONA%TYPE,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
    BEGIN
        UPDATE INFO_PERSONA
        SET
            TITULO_ID = Pr_Info_Persona.TITULO_ID,
            ORIGEN_PROSPECTO = Pr_Info_Persona.ORIGEN_PROSPECTO,
            TIPO_IDENTIFICACION = Pr_Info_Persona.TIPO_IDENTIFICACION,
            TIPO_EMPRESA = Pr_Info_Persona.TIPO_EMPRESA,
            TIPO_TRIBUTARIO = Pr_Info_Persona.TIPO_TRIBUTARIO,
            NOMBRES = Pr_Info_Persona.NOMBRES,
            APELLIDOS = Pr_Info_Persona.APELLIDOS,
            RAZON_SOCIAL = Pr_Info_Persona.RAZON_SOCIAL,
            REPRESENTANTE_LEGAL = Pr_Info_Persona.REPRESENTANTE_LEGAL,
            NACIONALIDAD = Pr_Info_Persona.NACIONALIDAD,
            DIRECCION = Pr_Info_Persona.DIRECCION,
            LOGIN = Pr_Info_Persona.LOGIN,
            CARGO = Pr_Info_Persona.CARGO,
            DIRECCION_TRIBUTARIA = Pr_Info_Persona.DIRECCION_TRIBUTARIA,
            GENERO = Pr_Info_Persona.GENERO,
            ESTADO_CIVIL = Pr_Info_Persona.ESTADO_CIVIL,
            FECHA_NACIMIENTO = Pr_Info_Persona.FECHA_NACIMIENTO,
            CALIFICACION_CREDITICIA = Pr_Info_Persona.CALIFICACION_CREDITICIA
        WHERE
            ID_PERSONA = Pn_IdPersona;

        Pv_Status := CMKG_RESULT.GENERATED_STATUS;
        Pv_Code := CMKG_RESULT.GENERATED_CODE;
        Pv_Msn := 'Instancia modificada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_UPDATE_INFO_PERSONA_SINC_EMP;

END CMKG_INFO_PERSONA_T;
/
