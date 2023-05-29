CREATE OR REPLACE PACKAGE DB_COMUNICACION.CUKG_UTILS AS

/**
 * Documentación para F_CLOB_REPLACE_VARS
 * Función que devuelve el contenido de la plantilla con los valores de las variables ya reemplazados
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 24/09/2017
 *
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.1 26/12/2017 Se elimina el reemplazo de la variable SALDO_CLIENTE
 *
 * @param Fr_EnvioMasivo IN DB_COMUNICACION.CUKG_TYPES.Lr_EnvioMasivo Registro del envío masivo
 * @param Fcl_ToSearch IN CLOB Recibe el contenido
 * @param Fv_Vars IN VARCHAR2 Cadena con las variables que contiene la plantilla
 * @return CLOB
 */
FUNCTION F_CLOB_REPLACE_VARS(
    Fr_EnvioMasivo  IN DB_COMUNICACION.CUKG_TYPES.Lr_EnvioMasivo,
    Fcl_ToSearch    IN CLOB,
    Fv_Vars         IN VARCHAR2)
  RETURN CLOB;

/**
 * Documentación para F_CLOB_INSTR
 * Función que permite verificar si existe cierta cadena de caracteres en un contenido
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 24/09/2017
 *
 * @param Fcl_ToSearch IN CLOB Recibe el contenido en el que se desea buscar Fv_Search
 * @param Fv_Search IN VARCHAR2 Cadena de caracteres que se buscará en Fcl_ToSearch
 * @return PLS_INTEGER
 */
FUNCTION F_CLOB_INSTR(
    Fcl_ToSearch IN CLOB,
    Fv_Search    IN VARCHAR2)
  RETURN PLS_INTEGER;

/**
 * Documentación para F_CLOB_REPLACE
 * Función que devuelve el contenido con el valor reemplazado de acuerdo a los parámetros enviados
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 24/09/2017
 *
 * @param Fcl_ToSearch IN CLOB Recibe el contenido en el que se desea buscar Fv_Search
 * @param Fv_Search IN VARCHAR2 Cadena de caracteres que se buscará en Fcl_ToSearch
 * @param Fv_Replace IN VARCHAR2 Valor con el que se reemplazará la cadena de caracteres encontradas en el contenido
 * @return CLOB
 */
FUNCTION F_CLOB_REPLACE(
    Fcl_ToSearch    IN CLOB,
    Fv_Search       IN VARCHAR2,
    Fv_Replace      IN VARCHAR2 )
  RETURN CLOB;

 /**
  * Documentación para procedimiento 'P_INSERT_INFO_DOCUMENTO'
  * Procedimiento para insertar un registro en la DB_COMUNICACION.INFO_DOCUMENTO
  *
  * @param  Pr_InfoDocumento    IN DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE Registro con la información a crear
  * @param  Pv_MsjError         OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */  
  PROCEDURE P_INSERT_INFO_DOCUMENTO(
    Pr_InfoDocumento    IN DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE,
    Pv_MsjError         OUT VARCHAR2);



 /**
  * Documentación para procedimiento 'P_INSERT_INFO_DOCUMENTO_RELAC'
  * Procedimiento para insertar un registro en la DB_COMUNICACION.INFO_DOCUMENTO_RELACION
  *
  * @param  Pr_InfoDocumentoRelac    IN DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE Registro con la información a crear
  * @param  Pv_MsjError         OUT VARCHAR2 Mensaje de error
  *
  * @author Andrés Montero H. <amontero@telconet.ec>
  * @version 1.0 16-05-2022
  */  
  PROCEDURE P_INSERT_INFO_DOCUMENTO_RELAC(
    Pr_InfoDocumentoRelac    IN DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE,
    Pv_MsjError         OUT VARCHAR2);

 /**
  * Documentación para procedimiento 'P_INSERT_INFO_COMUNICACION'
  * Procedimiento para insertar un registro en la DB_COMUNICACION.INFO_COMUNICACION
  *
  * @param  Pr_InfoDocumento    IN DB_COMUNICACION.INFO_COMUNICACION%ROWTYPE Registro con la información a crear
  * @param  Pv_MsjError         OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */  
  PROCEDURE P_INSERT_INFO_COMUNICACION(
    Pr_InfoComunicacion  IN DB_COMUNICACION.INFO_COMUNICACION%ROWTYPE,
    Pv_MsjError          OUT VARCHAR2);

 /**
  * Documentación para procedimiento 'P_INSERT_INFO_DOC_COMUNICACION'
  * Procedimiento para insertar un registro en la DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION
  *
  * @param  Pr_InfoDocComunicacion  IN DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION%ROWTYPE Registro con la información a crear
  * @param  Pv_MsjError             OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */  
  PROCEDURE P_INSERT_INFO_DOC_COMUNICACION( 
    Pr_InfoDocComunicacion  IN DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION%ROWTYPE,
    Pv_MsjError             OUT VARCHAR2);

END CUKG_UTILS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMUNICACION.CUKG_UTILS AS
FUNCTION F_CLOB_INSTR(
    Fcl_ToSearch  IN CLOB,
    Fv_Search  IN VARCHAR2)
  RETURN PLS_INTEGER
IS
  --
  Ln_PlsInteger PLS_INTEGER;
BEGIN
  Ln_PlsInteger   := INSTR(Fcl_ToSearch, Fv_Search);
  RETURN Ln_PlsInteger;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_UTILS.F_CLOB_INSTR', 
                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
END F_CLOB_INSTR;

FUNCTION F_CLOB_REPLACE(
    Fcl_ToSearch  IN CLOB,
    Fv_Search  IN VARCHAR2,
    Fv_Replace IN VARCHAR2 )
  RETURN CLOB
IS
  --
  Ln_PlsInteger PLS_INTEGER;
BEGIN
  Ln_PlsInteger   := INSTR(Fcl_ToSearch, Fv_Search);
  IF Ln_PlsInteger > 0 THEN
    RETURN SUBSTR(Fcl_ToSearch, 1, Ln_PlsInteger-1) || Fv_Replace || SUBSTR(
    Fcl_ToSearch, Ln_PlsInteger                 + LENGTH(Fv_Search));
  END IF;
  RETURN Fcl_ToSearch;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_UTILS.F_CLOB_REPLACE', 
                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END F_CLOB_REPLACE;

FUNCTION F_CLOB_REPLACE_VARS(
    Fr_EnvioMasivo  IN DB_COMUNICACION.CUKG_TYPES.Lr_EnvioMasivo,
    Fcl_ToSearch    IN CLOB,
    Fv_Vars         IN VARCHAR2)
  RETURN CLOB
IS
  --
  Lcl_ContenidoFinal CLOB;
  Lt_ArrayParamsVarsNotif DB_COMUNICACION.CUKG_TYPES.Lt_ArrayAsociativo;
  Lt_ArrayNumYMeses DB_COMUNICACION.CUKG_TYPES.Lt_ArrayAsociativo;
  Ln_PlsInteger PLS_INTEGER;
  Lv_MesConsumo VARCHAR2(2);
  Lv_AnioConsumo VARCHAR2(4);
  Lv_MesAnioConsumo VARCHAR2(15);
BEGIN
  Lcl_ContenidoFinal := Fcl_ToSearch;
  IF Fv_Vars IS NOT NULL THEN 
    FOR I_Variable IN
    (SELECT trim(regexp_substr(Fv_Vars, '[^,]+', 1, LEVEL)) nombreVariable
     FROM dual
     CONNECT BY LEVEL <= length(Fv_Vars) - length(REPLACE(Fv_Vars, ',', '')) + 1
    )
    LOOP
      Lt_ArrayParamsVarsNotif(I_Variable.nombreVariable) := I_Variable.nombreVariable;
    END LOOP;

    IF Lt_ArrayParamsVarsNotif.EXISTS('NUM_PUNTOS_AFECTADOS') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ NUM_PUNTOS_AFECTADOS }}', 
                                                                          Fr_EnvioMasivo.NUM_PUNTOS_AFECTADOS);
    END IF;


    IF Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') THEN
      Lt_ArrayNumYMeses('01')   := 'Enero';
      Lt_ArrayNumYMeses('1')    := 'Enero';
      Lt_ArrayNumYMeses('02')   := 'Febrero';
      Lt_ArrayNumYMeses('2')    := 'Febrero';
      Lt_ArrayNumYMeses('03')   := 'Marzo';
      Lt_ArrayNumYMeses('3')    := 'Marzo';
      Lt_ArrayNumYMeses('04')   := 'Abril';
      Lt_ArrayNumYMeses('4')    := 'Abril';
      Lt_ArrayNumYMeses('05')   := 'Mayo';
      Lt_ArrayNumYMeses('5')    := 'Mayo';
      Lt_ArrayNumYMeses('06')   := 'Junio';
      Lt_ArrayNumYMeses('6')    := 'Junio';
      Lt_ArrayNumYMeses('07')   := 'Julio';
      Lt_ArrayNumYMeses('7')    := 'Julio';
      Lt_ArrayNumYMeses('08')   := 'Agosto';
      Lt_ArrayNumYMeses('8')    := 'Agosto';
      Lt_ArrayNumYMeses('09')   := 'Septiembre';
      Lt_ArrayNumYMeses('9')    := 'Septiembre';
      Lt_ArrayNumYMeses('10')   := 'Octubre';
      Lt_ArrayNumYMeses('10')   := 'Octubre';
      Lt_ArrayNumYMeses('11')   := 'Noviembre';
      Lt_ArrayNumYMeses('11')   := 'Noviembre';
      Lt_ArrayNumYMeses('12')   := 'Diciembre';
      Lt_ArrayNumYMeses('9')    := 'Diciembre';

      Ln_PlsInteger := INSTR(Fr_EnvioMasivo.MES_ANIO_CONSUMO_FACTURA,'/');
      IF Ln_PlsInteger > 0 THEN
        Lv_MesConsumo  := SUBSTR(Fr_EnvioMasivo.MES_ANIO_CONSUMO_FACTURA, 1, Ln_PlsInteger-1);
        Lv_AnioConsumo := SUBSTR(Fr_EnvioMasivo.MES_ANIO_CONSUMO_FACTURA, Ln_PlsInteger+1, LENGTH(Fr_EnvioMasivo.MES_ANIO_CONSUMO_FACTURA));

        IF Lt_ArrayNumYMeses.EXISTS(Lv_MesConsumo) THEN
          Lv_MesAnioConsumo := Lt_ArrayNumYMeses(Lv_MesConsumo) || '/' || Lv_AnioConsumo;
        ELSE
          Lv_MesAnioConsumo := Fr_EnvioMasivo.MES_ANIO_CONSUMO_FACTURA;
        END IF;
      END IF;
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ MES_ANIO_CONSUMO_FACTURA }}', 
                                                                          Lv_MesAnioConsumo);
    END IF;

    IF Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ FECHA_EMISION_FACTURA }}', 
                                                                          Fr_EnvioMasivo.FECHA_EMISION_FACTURA);
    END IF;

    IF Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ NUMERO_FACTURA }}', 
                                                                          Fr_EnvioMasivo.NUMERO_FACTURA);
    END IF;

    IF Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ VALOR_FACTURA }}', 
                                                                          Fr_EnvioMasivo.VALOR_FACTURA);
    END IF;

    IF Lt_ArrayParamsVarsNotif.EXISTS('SALDO_PUNTO_FACT') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                       '{{ SALDO_PUNTO_FACT }}', 
                                                                       Fr_EnvioMasivo.SALDO_PUNTO_FACT);
    END IF;

    IF Lt_ArrayParamsVarsNotif.EXISTS('NOMBRES_CLIENTE') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ NOMBRES_CLIENTE }}', 
                                                                          Fr_EnvioMasivo.NOMBRES_CLIENTE);
    END IF;

    IF Lt_ArrayParamsVarsNotif.EXISTS('LOGIN') THEN
      Lcl_ContenidoFinal := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE( Lcl_ContenidoFinal, 
                                                                          '{{ LOGIN }}', 
                                                                          Fr_EnvioMasivo.LOGIN);
    END IF;

  END IF;
  RETURN Lcl_ContenidoFinal;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_UTILS.F_CLOB_REPLACE_VARS', 
                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

END F_CLOB_REPLACE_VARS;

  PROCEDURE P_INSERT_INFO_DOCUMENTO(Pr_InfoDocumento    IN DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE,
                                    Pv_MsjError         OUT VARCHAR2)
  AS
    Ln_IdDocumento NUMBER;
  BEGIN
    IF Pr_InfoDocumento.ID_DOCUMENTO IS NULL THEN
      Ln_IdDocumento := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
    ELSE
      Ln_IdDocumento := Pr_InfoDocumento.ID_DOCUMENTO;
    END IF;

    INSERT
    INTO DB_COMUNICACION.INFO_DOCUMENTO
      (
        ID_DOCUMENTO,
        TIPO_DOCUMENTO_ID,
        CLASE_DOCUMENTO_ID,
        NOMBRE_DOCUMENTO,
        UBICACION_LOGICA_DOCUMENTO,
        UBICACION_FISICA_DOCUMENTO,
        DOCUMENTO,
        FECHA_DOCUMENTO,
        MODELO_ELEMENTO_ID,
        ELEMENTO_ID,
        CONTRATO_ID,
        DOCUMENTO_FINANCIERO_ID,
        TAREA_INTERFACE_MODELO_TRA_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        MENSAJE,
        EMPRESA_COD,
        TIPO_DOCUMENTO_GENERAL_ID,
        FECHA_DESDE,
        FECHA_HASTA,
        FE_ULT_MOD,
        USR_ULT_MOD,
        LATITUD,
        LONGITUD,
        ETIQUETA_DOCUMENTO,
        CUADRILLA_HISTORIAL_ID
      )
      VALUES
      (
        Ln_IdDocumento,
        Pr_InfoDocumento.TIPO_DOCUMENTO_ID,
        Pr_InfoDocumento.CLASE_DOCUMENTO_ID,
        Pr_InfoDocumento.NOMBRE_DOCUMENTO,
        Pr_InfoDocumento.UBICACION_LOGICA_DOCUMENTO,
        Pr_InfoDocumento.UBICACION_FISICA_DOCUMENTO,
        Pr_InfoDocumento.DOCUMENTO,
        Pr_InfoDocumento.FECHA_DOCUMENTO,
        Pr_InfoDocumento.MODELO_ELEMENTO_ID,
        Pr_InfoDocumento.ELEMENTO_ID,
        Pr_InfoDocumento.CONTRATO_ID,
        Pr_InfoDocumento.DOCUMENTO_FINANCIERO_ID,
        Pr_InfoDocumento.TAREA_INTERFACE_MODELO_TRA_ID,
        Pr_InfoDocumento.USR_CREACION,
        SYSDATE,
        Pr_InfoDocumento.IP_CREACION,
        Pr_InfoDocumento.ESTADO,
        Pr_InfoDocumento.MENSAJE,
        Pr_InfoDocumento.EMPRESA_COD,
        Pr_InfoDocumento.TIPO_DOCUMENTO_GENERAL_ID,
        Pr_InfoDocumento.FECHA_DESDE,
        Pr_InfoDocumento.FECHA_HASTA,
        Pr_InfoDocumento.FE_ULT_MOD,
        Pr_InfoDocumento.USR_ULT_MOD,
        Pr_InfoDocumento.LATITUD,
        Pr_InfoDocumento.LONGITUD,
        Pr_InfoDocumento.ETIQUETA_DOCUMENTO,
        Pr_InfoDocumento.CUADRILLA_HISTORIAL_ID
      );

    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'CUKG_UTILS.P_INSERT_INFO_DOCUMENTO '|| SQLERRM;
  END P_INSERT_INFO_DOCUMENTO;


  PROCEDURE P_INSERT_INFO_DOCUMENTO_RELAC(Pr_InfoDocumentoRelac    IN DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE,
                                    Pv_MsjError         OUT VARCHAR2)
  AS
    Ln_IdDocumentoRelacion NUMBER;
  BEGIN
    IF Pr_InfoDocumentoRelac.ID_DOCUMENTO_RELACION IS NULL THEN
      Ln_IdDocumentoRelacion := DB_COMUNICACION.SEQ_INFO_DOCUMENTO_RELACION.NEXTVAL;
    ELSE
      Ln_IdDocumentoRelacion := Pr_InfoDocumentoRelac.ID_DOCUMENTO_RELACION;
    END IF;

    INSERT
    INTO DB_COMUNICACION.INFO_DOCUMENTO_RELACION
      (
        ID_DOCUMENTO_RELACION,
        DOCUMENTO_ID,
        MODULO,
        ENCUESTA_ID,
        SERVICIO_ID,
        PUNTO_ID,
        PERSONA_EMPRESA_ROL_ID,
        CONTRATO_ID,
        DOCUMENTO_FINANCIERO_ID,
        CASO_ID,
        ACTIVIDAD_ID,
        TIPO_ELEMENTO_ID,
        MODELO_ELEMENTO_ID,
        ELEMENTO_ID,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        DETALLE_ID,
        ORDEN_TRABAJO_ID,
        MANTENIMIENTO_ELEMENTO_ID,
        ESTADO_EVALUACION,
        EVALUACION_TRABAJO,
        FE_INICIO_EVALUACION,
        USR_EVALUACION,
        PORCENTAJE_EVALUACION_BASE,
        PORCENTAJE_EVALUADO,
        NUMERO_ADENDUM,
        PAGO_DATOS_ID
      )
      VALUES
      (
        Ln_IdDocumentoRelacion,
        Pr_InfoDocumentoRelac.DOCUMENTO_ID,
        Pr_InfoDocumentoRelac.MODULO,
        Pr_InfoDocumentoRelac.ENCUESTA_ID,
        Pr_InfoDocumentoRelac.SERVICIO_ID,
        Pr_InfoDocumentoRelac.PUNTO_ID,
        Pr_InfoDocumentoRelac.PERSONA_EMPRESA_ROL_ID,
        Pr_InfoDocumentoRelac.CONTRATO_ID,
        Pr_InfoDocumentoRelac.DOCUMENTO_FINANCIERO_ID,
        Pr_InfoDocumentoRelac.CASO_ID,
        Pr_InfoDocumentoRelac.ACTIVIDAD_ID,
        Pr_InfoDocumentoRelac.TIPO_ELEMENTO_ID,
        Pr_InfoDocumentoRelac.MODELO_ELEMENTO_ID,
        Pr_InfoDocumentoRelac.ELEMENTO_ID,
        Pr_InfoDocumentoRelac.ESTADO,
        SYSDATE,
        Pr_InfoDocumentoRelac.USR_CREACION,
        Pr_InfoDocumentoRelac.DETALLE_ID,
        Pr_InfoDocumentoRelac.ORDEN_TRABAJO_ID,
        Pr_InfoDocumentoRelac.MANTENIMIENTO_ELEMENTO_ID,
        Pr_InfoDocumentoRelac.ESTADO_EVALUACION,
        Pr_InfoDocumentoRelac.EVALUACION_TRABAJO,
        Pr_InfoDocumentoRelac.FE_INICIO_EVALUACION,
        Pr_InfoDocumentoRelac.USR_EVALUACION,
        Pr_InfoDocumentoRelac.PORCENTAJE_EVALUACION_BASE,
        Pr_InfoDocumentoRelac.PORCENTAJE_EVALUADO,
        Pr_InfoDocumentoRelac.NUMERO_ADENDUM,
        Pr_InfoDocumentoRelac.PAGO_DATOS_ID
      );

    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'CUKG_UTILS.P_INSERT_INFO_DOCUMENTO_RELAC '|| SQLERRM;
  END P_INSERT_INFO_DOCUMENTO_RELAC;

  PROCEDURE P_INSERT_INFO_COMUNICACION(Pr_InfoComunicacion  IN DB_COMUNICACION.INFO_COMUNICACION%ROWTYPE,
                                       Pv_MsjError          OUT VARCHAR2)
  AS
    Ln_IdComunicacion NUMBER;
  BEGIN
    IF Pr_InfoComunicacion.ID_COMUNICACION IS NULL THEN
      Ln_IdComunicacion := DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL;
    ELSE
      Ln_IdComunicacion := Pr_InfoComunicacion.ID_COMUNICACION;
    END IF;

    INSERT
    INTO DB_COMUNICACION.INFO_COMUNICACION
      (
        ID_COMUNICACION,
        FORMA_CONTACTO_ID,
        TRAMITE_ID,
        CASO_ID,
        DETALLE_ID,
        REMITENTE_ID,
        REMITENTE_NOMBRE,
        CLASE_COMUNICACION,
        FECHA_COMUNICACION,
        DESCRIPCION_COMUNICACION,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        PUNTO_ID,
        EMPRESA_COD
      )
      VALUES
      (
        Ln_IdComunicacion,
        Pr_InfoComunicacion.FORMA_CONTACTO_ID,
        Pr_InfoComunicacion.TRAMITE_ID,
        Pr_InfoComunicacion.CASO_ID,
        Pr_InfoComunicacion.DETALLE_ID,
        Pr_InfoComunicacion.REMITENTE_ID,
        Pr_InfoComunicacion.REMITENTE_NOMBRE,
        Pr_InfoComunicacion.CLASE_COMUNICACION,
        Pr_InfoComunicacion.FECHA_COMUNICACION,
        Pr_InfoComunicacion.DESCRIPCION_COMUNICACION,
        Pr_InfoComunicacion.ESTADO,
        Pr_InfoComunicacion.USR_CREACION,
        SYSDATE,
        Pr_InfoComunicacion.IP_CREACION,
        Pr_InfoComunicacion.PUNTO_ID,
        Pr_InfoComunicacion.EMPRESA_COD
      );

    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'CUKG_UTILS.P_INSERT_INFO_COMUNICACION '|| SQLERRM;
  END P_INSERT_INFO_COMUNICACION;


  PROCEDURE P_INSERT_INFO_DOC_COMUNICACION( Pr_InfoDocComunicacion  IN DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION%ROWTYPE,
                                            Pv_MsjError             OUT VARCHAR2)
  AS
    Ln_IdDocComunicacion NUMBER;
  BEGIN
    IF Pr_InfoDocComunicacion.ID_DOCUMENTO_COMUNICACION IS NULL THEN
      Ln_IdDocComunicacion := DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL;
    ELSE
      Ln_IdDocComunicacion := Pr_InfoDocComunicacion.ID_DOCUMENTO_COMUNICACION;
    END IF;

    INSERT
    INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION
      (
        ID_DOCUMENTO_COMUNICACION,
        DOCUMENTO_ID,
        COMUNICACION_ID,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
      )
      VALUES
      (
        Ln_IdDocComunicacion,
        Pr_InfoDocComunicacion.DOCUMENTO_ID,
        Pr_InfoDocComunicacion.COMUNICACION_ID,
        Pr_InfoDocComunicacion.ESTADO,
        Pr_InfoDocComunicacion.USR_CREACION,
        SYSDATE,
        Pr_InfoDocComunicacion.IP_CREACION
      );

    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'CUKG_UTILS.P_INSERT_INFO_DOC_COMUNICACION '|| SQLERRM;
  END P_INSERT_INFO_DOC_COMUNICACION;

END CUKG_UTILS;
/
