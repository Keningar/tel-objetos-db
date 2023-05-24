CREATE OR REPLACE PACKAGE DB_COMUNICACION.CUKG_TYPES 
AS
/*
* Documentaci�n para TYPE 'Lt_ArrayAsociativo'.
*
* Tipo de datos para mapear los par�metros enviados en un array asociativo
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 07-09-2017
*/
TYPE Lt_ArrayAsociativo IS TABLE OF VARCHAR2(300) INDEX BY VARCHAR2(30);

/*
* Documentaci�n para TYPE 'Lr_AliasPlantilla'.
*
* Tipo de datos para obtener la informaci�n de los alias asociados a una plantilla
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 24-09-2017
*/
TYPE Lr_AliasPlantilla
IS
  RECORD
  (
    ALIAS_CORREOS VARCHAR2(4000),
    ID_PLANTILLA  DB_COMUNICACION.ADMI_PLANTILLA.ID_PLANTILLA%TYPE);

/*
* Documentaci�n para TYPE 'Lr_EnvioMasivo'.
*
* Tipo de datos para el retorno de la informaci�n correspondiente a los destinatarios del env�o masivo
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 25-09-2017
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.1 26-12-2017 Se elimina del tipo el campo SALDO_CLIENTE
*
*/
TYPE Lr_EnvioMasivo IS RECORD (
  NOMBRES_CLIENTE           VARCHAR2(200), 
  NOMBRES_CONTACTO          VARCHAR2(200), 
  CORREO                    DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
  TIPO_CONTACTO             DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE,
  LOGIN                     DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
  NUM_PUNTOS_AFECTADOS      NUMBER,
  MES_ANIO_CONSUMO_FACTURA  VARCHAR2(7),
  FECHA_EMISION_FACTURA     VARCHAR2(10),
  NUMERO_FACTURA            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
  VALOR_FACTURA             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
  SALDO_PUNTO_FACT          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
);

/*
* Documentaci�n para TYPE 'Lt_EnvioMasivo'.
* Tabla que obtiene para almacenar la data enviada al BULK con la informaci�n correspondiente a los destinatarios del env�o masivo
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 25-09-2017
*/
TYPE Lt_EnvioMasivo IS TABLE OF Lr_EnvioMasivo INDEX BY PLS_INTEGER;


/*
* Documentaci�n para TYPE 'Lr_NotifEnvioMasivoPlantilla'.
* Tipo de datos para el retorno de la informaci�n correspondiente al env�o masivo y a la plantilla asociada
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 25-09-2017
*/
TYPE Lr_NotifEnvioMasivoPlantilla
IS
  RECORD
  (
    NOMBRE_JOB          VARCHAR2(4000),
    ASUNTO              VARCHAR2(4000),
    TIPO                VARCHAR2(15),
    NOMBRE_PLANTILLA    VARCHAR2(100),
    CODIGO              VARCHAR2(15),
    PLANTILLA           CLOB
);

  /*
   * Documentacion para TYPE 'Lr_Imagen'.
   * Record que me permite obtener el registro del detalle de un documento imagen
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 23-02-2022
   *
   */
 TYPE Lr_Imagen IS RECORD (
    Rn                          NUMBER,
    Id_Documento                DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE,
    Nombres                     DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Apellidos                   DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Nombre_Documento            DB_COMUNICACION.INFO_DOCUMENTO.NOMBRE_DOCUMENTO%TYPE,
    Fe_Creacion                 DB_COMUNICACION.INFO_DOCUMENTO.FE_CREACION%TYPE,
    Url_Imagen                  DB_COMUNICACION.INFO_DOCUMENTO.UBICACION_FISICA_DOCUMENTO%TYPE,
    Latitud                     DB_COMUNICACION.INFO_DOCUMENTO.LATITUD%TYPE,
    Longitud                    DB_COMUNICACION.INFO_DOCUMENTO.LONGITUD%TYPE,
    Login                       DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Id_Documento_Relacion       DB_COMUNICACION.INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE,
    Tipo_Elemento_Id            DB_COMUNICACION.INFO_DOCUMENTO_RELACION.TIPO_ELEMENTO_ID%TYPE,
    Estado_Evaluacion           DB_COMUNICACION.INFO_DOCUMENTO_RELACION.ESTADO_EVALUACION%TYPE,
    Evaluacion_Trabajo          DB_COMUNICACION.INFO_DOCUMENTO_RELACION.EVALUACION_TRABAJO%TYPE,
    Usr_Evaluacion              DB_COMUNICACION.INFO_DOCUMENTO_RELACION.USR_EVALUACION%TYPE,
    Porcentaje_Evaluacion_Base  DB_COMUNICACION.INFO_DOCUMENTO_RELACION.PORCENTAJE_EVALUACION_BASE%TYPE,
    Porcentaje_Evaluado         DB_COMUNICACION.INFO_DOCUMENTO_RELACION.PORCENTAJE_EVALUACION_BASE%TYPE,
    Nombre_Evaluador            VARCHAR2(200),
    Numero_Caso                 DB_SOPORTE.INFO_CASO.NUMERO_CASO%TYPE,
    Id_Elemento                 DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    Id_Tipo_Elemento            DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.ID_TIPO_ELEMENTO%TYPE,
    Nombre_Tipo_Elemento        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE,
    Numero_Tarea                DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE
 );
 
  /*
   * Documentacion para TYPE 'Ltr_Imagenes'.
   * Record que me permite obtener los registros de informaci�n de imagenes
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 23-02-2022
   *
   */
  TYPE Ltr_Imagenes IS TABLE OF Lr_Imagen INDEX BY binary_integer;
  
  /*
   * Documentacion para TYPE 'Lr_CantidadImagen'.
   * Record que me permite obtener la cantidad de registros con detalles de imagenes del m�dulo de Soporte
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 04-03-2022
   *
   */
  TYPE Lr_CantidadImagen IS RECORD (
    Cantidad_Registros NUMBER
  );
  
  /*
   * Documentacion para TYPE 'Ltr_CantidadImagenes'.
   * Record que me permite obtener los registros de informaci�n de imagenes
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 04-03-2022
   *
   */
  TYPE Ltr_CantidadImagenes IS TABLE OF Lr_CantidadImagen INDEX BY binary_integer;

END CUKG_TYPES;
/