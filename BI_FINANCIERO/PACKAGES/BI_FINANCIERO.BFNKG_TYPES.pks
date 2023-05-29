CREATE OR REPLACE PACKAGE BI_FINANCIERO.BFNKG_TYPES 
AS
  /**
  * Documentacion para el PKG BFNKG_TYPES
  * El PKG BFNKG_TYPES contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
  * separando procedimientos y funciones de las declaraciones de variables
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 20-04-2018
  */
--
  /*
  * Documentacion para TYPE 'Lr_DetalladoFacturacionMrcNrc'.
  * Record que me permite devolver los valores para setear columnas del reporte de facturacion de MRC y NRC de asesores
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 20-04-2018
  *
  * Actualizacion: Se asigna los valores de instalacion al NRC
                   En el reporte de excel se agrega FE_EMISION, ASESOR, IDENTIFICACION_CLIENTE y TIPO 
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.1 08-05-2018
  *
  * Actualización: Se agregan variables para Internet/Datos y Business Solutions, factura y nota de credito.
  * @author David Leon <mdleon@telconet.ec>
  * @version 1.5 12-12-2021
  */
  TYPE Lr_DetalladoFacturacionMrcNrc IS RECORD (
    MES                     VARCHAR2(2),
    FE_EMISION              DATE,
    CLIENTE                 VARCHAR2(300),
    IDENTIFICACION_CLIENTE  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    USR_VENDEDOR            DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
    ASESOR                  VARCHAR2(300),
    LOGIN                   DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    FILTRO                  VARCHAR2(20),
    LINEA_NEGOCIO           DB_COMERCIAL.ADMI_PRODUCTO.LINEA_NEGOCIO%TYPE,
    GRUPO                   DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
    SUBGRUPO                DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
    ID_PERSONA_ROL          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    DESCRIPCION_PRODUCTO    DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    OBSERVACION_PRODUCTO    VARCHAR2(4000),
    ID_PERSONA_ROL_MRC     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PERSONA_ROL_NRC     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    FAC_MRC                NUMBER,
    FAC_MRCID              NUMBER,
    FAC_MRCBS              NUMBER,
    FAC_NRC                NUMBER,
    NC_MRC                 NUMBER,
    NC_MRCID               NUMBER,
    NC_MRCBS               NUMBER,
    NC_NRC                 NUMBER
  );
--
END BFNKG_TYPES;
/
