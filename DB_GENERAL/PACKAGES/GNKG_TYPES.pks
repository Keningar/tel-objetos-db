CREATE OR REPLACE PACKAGE DB_GENERAL.GNKG_TYPES AS 

  /**
  * Documentacion para el PKG GNKG_TYPES
  * El PKG GNKG_TYPES contendrá las variables que sean necesarias a usar en los PKG de consultas o transacciones
  * separando procedimientos y funciones de las declaraciones de variables
  * @author David De La Cruz <ddelacruz@telconet.ec>
  * @version 1.0 
  * @since 02-11-2021
  */

  /*
  * Documentacion para TYPE 'Lr_Departamento'.
  * Record que me permite devolver los valores de ADMI_DEPARTAMENTO y nombre de Area
  * @author David De La Cruz <ddelacruz@telconet.ec>
  * @version 1.0
  * @since 02-11-2021
  */
  TYPE Lr_Departamento IS RECORD (
    ID_DEPARTAMENTO     ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
    AREA_ID             ADMI_DEPARTAMENTO.AREA_ID%TYPE,
    NOMBRE_DEPARTAMENTO ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
    ESTADO              ADMI_DEPARTAMENTO.ESTADO%TYPE,
    USR_CREACION        ADMI_DEPARTAMENTO.USR_CREACION%TYPE,
    FE_CREACION         ADMI_DEPARTAMENTO.FE_CREACION%TYPE,
    USR_ULT_MOD         ADMI_DEPARTAMENTO.USR_ULT_MOD%TYPE,
    FE_ULT_MOD          ADMI_DEPARTAMENTO.FE_ULT_MOD%TYPE,
    EMPRESA_COD         ADMI_DEPARTAMENTO.EMPRESA_COD%TYPE,
    EMAIL_DEPARTAMENTO  ADMI_DEPARTAMENTO.EMAIL_DEPARTAMENTO%TYPE,
    NOMBRE_AREA         ADMI_AREA.NOMBRE_AREA%TYPE
  );

  TYPE Ltr_Departamento IS TABLE OF Lr_Departamento INDEX BY binary_integer;

END GNKG_TYPES;
/