CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE AS
    /**
      * Info persona record
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */
    TYPE Tr_InfoPersona IS RECORD (
        ID_PERSONA INFO_PERSONA.ID_PERSONA%TYPE,
        TITULO_ID INFO_PERSONA.TITULO_ID%TYPE,
        ORIGEN_PROSPECTO INFO_PERSONA.ORIGEN_PROSPECTO%TYPE,
        TIPO_IDENTIFICACION INFO_PERSONA.TIPO_IDENTIFICACION%TYPE,
        IDENTIFICACION_CLIENTE INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        TIPO_EMPRESA INFO_PERSONA.TIPO_EMPRESA%TYPE,
        TIPO_TRIBUTARIO INFO_PERSONA.TIPO_TRIBUTARIO%TYPE,
        NOMBRES INFO_PERSONA.NOMBRES%TYPE,
        APELLIDOS INFO_PERSONA.APELLIDOS%TYPE,
        RAZON_SOCIAL INFO_PERSONA.RAZON_SOCIAL%TYPE,
        REPRESENTANTE_LEGAL INFO_PERSONA.REPRESENTANTE_LEGAL%TYPE,
        NACIONALIDAD INFO_PERSONA.NACIONALIDAD%TYPE,
        DIRECCION INFO_PERSONA.DIRECCION%TYPE,
        LOGIN INFO_PERSONA.LOGIN%TYPE,
        CARGO INFO_PERSONA.CARGO%TYPE,
        DIRECCION_TRIBUTARIA INFO_PERSONA.DIRECCION_TRIBUTARIA%TYPE,
        GENERO INFO_PERSONA.GENERO%TYPE,
        ESTADO INFO_PERSONA.ESTADO%TYPE,
        FE_CREACION INFO_PERSONA.FE_CREACION%TYPE,
        USR_CREACION INFO_PERSONA.USR_CREACION%TYPE,
        IP_CREACION INFO_PERSONA.IP_CREACION%TYPE,
        ESTADO_CIVIL INFO_PERSONA.ESTADO_CIVIL%TYPE,
        FECHA_NACIMIENTO INFO_PERSONA.FECHA_NACIMIENTO%TYPE,
        CALIFICACION_CREDITICIA INFO_PERSONA.CALIFICACION_CREDITICIA%TYPE,
        ORIGEN_INGRESOS INFO_PERSONA.ORIGEN_INGRESOS%TYPE,
        ORIGEN_WEB INFO_PERSONA.ORIGEN_WEB%TYPE,
        CONTRIBUYENTE_ESPECIAL INFO_PERSONA.CONTRIBUYENTE_ESPECIAL%TYPE,
        PAGA_IVA INFO_PERSONA.PAGA_IVA%TYPE,
        NUMERO_CONADIS INFO_PERSONA.NUMERO_CONADIS%TYPE,
        PAIS_ID INFO_PERSONA.PAIS_ID%TYPE
    );
END CMKG_INFO_PERSONA_TYPE;
/
