CREATE OR REPLACE PACKAGE            formulario IS
  /* Este paquete ofrece funciones para manipular los formularios.
  NOTAS: - Los procedimientos suponen que los registros asociados
  a los formularios ya fueron creados cuando la forma de
  reseteo es manual o mediante la funcion iniciar y reservar
  cuando el formulario mantiene reservas mensuales.
  - En el caso de que un procedimiento genere un error se
  levanta una excepcion formulario.error.  El codigo de
  error se puede obtener mediante la funcion ultimo_error.
  Para obtener el texto, se debe invocar a la funcion texto_error.
  Ej:  formulario.texto_error(formulario.ultimo_error) */
  --
  /* Se define una excepcion que permite al usuario manipular
  los errores que se generan en los procedimientos. Ademas,
  se define una variable con el numero de error asociado a
  la excepcion. */
  error EXCEPTION;
  PRAGMA EXCEPTION_INIT(error, -20010);
  num_error NUMBER := -20010;
  --
  /* Se definen los tipos de dato que deben utilizar las variables para obtener
  informacion acerca de los formularios. */
  SUBTYPE datos_formulario IS
  control_formu%ROWTYPE;
  --
  SUBTYPE datos_formu_periodo IS
  consec_periodo%ROWTYPE;
  --
  /* Se define el registro que almacena los codigos de error.  Si se desea manipular los errores, se debe definir una variable de este tipo que 
     ayudara a distinguir el tipo de error posterior al levantamiento de la excepcion y a obtener informacion relacionada con este.
     Por ejemplo, se define una variable:
       err_for formulario.registro_error; 
       El texto relacionado con el error de formulario inexistente, puede ser desplegado de la forma:
       MESSAGE(formulario.texto_error(err_for.formulario_no_creado));
  */
  TYPE registro_error IS RECORD (
    otros BINARY_INTEGER := 0,                 /* Otros errores */
    formulario_no_creado BINARY_INTEGER := 1,  /* Indica que el formulario no existe y por lo tanto no se puede realizar la operacion. */
    secuencia_no_creada BINARY_INTEGER := 2,   /* Para las secuencias con reseteo manual, indica que no se ha creado el registro del periodo. */
    maximo_excedido BINARY_INTEGER := 3,       /* Indica que no se pueden obtener mas secuencias del formulario debido a que se ha llegado al maximo 
                                                 especificado. */
    periodo_invalido BINARY_INTEGER := 4,      /* Indica que el periodo para el cual se quiere obtener una secuencia no es valido. */
    tipo_invalido BINARY_INTEGER := 5,         /* Indica la aplicacion incorrecta de una funcion a un formulario. */
    reserva_no_posible BINARY_INTEGER := 6,    /* Si se genera este error indica que no fue posible crear una reserva para el periodo solicitado  */
    siguiente_no_cambiado BINARY_INTEGER := 7, /* Indica que no fue posible cambiar el numero siguiente del formulario. */
    no_activo BINARY_INTEGER := 8              /* Indica que el formulario no se encuentra activo */
  );
  --
  -- Funciones para manipular los formularios
  --
  --
  FUNCTION existe (pcompania   IN control_formu.no_cia%TYPE,
                   pformulario IN control_formu.formulario%TYPE,
                   pmodulo     IN VARCHAR2) RETURN BOOLEAN;
  /* La funcion Existe retorna verdadero en caso de que el formulario exista para la compa?ia y modulo especificado. En el caso que no se encuentre
     el formulario especificado, se retorna falso.  La funcion no genera un error.
     Si el parametro modulo es nulo, no se hace la verificacion con el modulo. 
  */
  --
  --
  PROCEDURE iniciar ( pcompania   IN control_formu.no_cia%TYPE,
                      pformulario IN control_formu.formulario%TYPE,
                      pperiodo    IN consec_periodo.periodo%TYPE);
    /* Para los formularios que mantienen una reserva mensual, se debe
       invocar este procedimiento la primera vez que se quiera utilizar
       el formulario.  Para los otros tipos de formulario no se debe
       invocar este procedimiento, si se hace, no se realiza ninguna
       operacion (no genera error).
    */
  --
  --
  PROCEDURE consulta_siguiente( pcompania   IN control_formu.no_cia%TYPE,
                                pformulario IN control_formu.formulario%TYPE,
                                pperiodo    IN consec_periodo.periodo%TYPE DEFAULT NULL,
                                psiguiente  IN OUT control_formu.siguiente%TYPE,
                                pserie      IN OUT control_formu.serie%TYPE);
    /* Esta funcion retorna la siguiente secuencia en el
       formulario.  La funcion devuelve un error en caso de que
       no exista el formulario o que se haya excedido el limite
       superior para ese formulario.
    */
  --
  --
  PROCEDURE obtiene_siguiente( pcompania   IN control_formu.no_cia%TYPE,
                               pformulario IN control_formu.formulario%TYPE,
                               pperiodo    IN consec_periodo.periodo%TYPE DEFAULT NULL,
                               psiguiente  IN OUT control_formu.siguiente%TYPE,
                               pserie      IN OUT control_formu.serie%TYPE);
    /* Esta funcion retorna la siguiente secuencia en el
       formulario.  La funcion devuelve un error en caso de que
         no exista el formulario o que se haya excedido el limite
         superior para ese formulario. Funcion copiada de 'consulta_siguiente', pero
         excluyendo el bloqueo exclusivo sobre el formulario
    */
  --
  --
  FUNCTION siguiente( pcompania   IN control_formu.no_cia%TYPE,
                      pformulario IN control_formu.formulario%TYPE,
                      pperiodo    IN consec_periodo.periodo%TYPE DEFAULT NULL) RETURN control_formu.siguiente%TYPE;
    /* Esta funcion retorna la siguiente secuencia en el
       formulario.  La funcion devuelve un error en caso de que
       no exista el formulario o que se haya excedido el limite
       superior para ese formulario.
    */
  --
  --
  PROCEDURE reservar( pcompania   IN control_formu.no_cia%TYPE,
                      pformulario IN control_formu.formulario%TYPE,
                      pperiodo    IN consec_periodo.periodo%TYPE);
    /* Para los formularios que mantienen una reserva mensual de forma automatica,
       genera una reserva para el periodo especificado y crea el registro correspondiente
       para el periodo siguiente.  Si ya fue generada la reserva, se trata
       de hacer una reserva mayor, siempre y cuando no haya sido utilizada alguna
       secuencia para el periodo posterior.
       La cantidad reservada es un atributo del formulario en la tabla control_formu.
    */
  --
  --  
  PROCEDURE cambiar_siguiente( pcompania   IN control_formu.no_cia%TYPE,
                               pformulario IN control_formu.formulario%TYPE,
                               pperiodo    IN consec_periodo.periodo%TYPE,
                               panterior   IN control_formu.siguiente%TYPE,
                               pnuevo      IN control_formu.siguiente%TYPE);
    /* Mediante este procedimiento se puede variar el siguiente numero del formulario.
       El procedimiento requiere el siguiente actual en el parametro "panterior" para
       verificar que ningun usuario haya obtenido una secuencia antes de la invocacion
       al procedimiento. En otras palabras, se debe obtener el numero siguiente previo
       a modificarlo.
    */
  --
  -- 
  FUNCTION datos( pcompania   IN control_formu.no_cia%TYPE,
                  pformulario IN control_formu.formulario%TYPE) RETURN datos_formulario;
    /* La funcion datos devuelve un registro de tipo datos_formulario con la informacion
       actual del formulario.  Si se invoca alguna operacion posterior a la
       obtencion de los datos, es recomendable volver a llamarla debido a la posibilidad
       que se haya modificado el estado del formulario. 
    */
  --
  --
  FUNCTION datos_periodo( pcompania   IN consec_periodo.no_cia%TYPE,
                          pformulario IN consec_periodo.formulario%TYPE,
                          pperiodo    IN consec_periodo.periodo%TYPE) RETURN datos_formu_periodo;
    /* La funcion datos retorna un registro de tipo datos_formu_periodo con la informacion
       actual del formulario para el periodo.  Si se invoca alguna operacion posterior a la
       obtencion de los datos, es recomendable volver a llamarla debido a la posibilidad
       que se haya modificado el estado de la secuencia para ese periodo. 
    */
  --
  --
  FUNCTION ultimo_codigo_error RETURN BINARY_INTEGER;
    /* Esta funcion retorna el codigo relacionado con el ultimo
       error que se presento en el paquete. 
    */
  --
  --
  FUNCTION ultimo_error RETURN VARCHAR2;
  /* Esta funcion retorna el mensaje relacionado con el ultimo
     error que se presento en el paquete. */
  --
  --
  FUNCTION texto_error( cod_error IN BINARY_INTEGER) RETURN VARCHAR2;
    /* Esta funcion retorna el texto del error asociado al codigo de error
       pasado como parametro 
    */
END formulario;
/


CREATE OR REPLACE PACKAGE BODY            formulario IS
  --
  --
  /*******[ PARTE: PRIVADA ]
  * Declaracion de Procedimientos o funciones PRIVADAS
  *
  */
  -- --
  -- DECLARACION DE TIPOS
  --
  TYPE tabla_mensajes_t IS TABLE OF VARCHAR2(255) NOT NULL INDEX BY BINARY_INTEGER;
  --
  --
  vmsg_error_adicional VARCHAR2(40);
  ultimo_numero_error  BINARY_INTEGER;        -- almacena el numero del ultimo error
  codigo_error         registro_error;        -- registro con los codigos de error
  reg_control_formu    control_formu%ROWTYPE;
  reg_consec_periodo   consec_periodo%ROWTYPE;
  --
  mensaje_error tabla_mensajes_t;
  --
  -- Se definen los cursores de uso comun para los procedimientos.
  CURSOR control_formulario(pcompania control_formu.no_cia%TYPE, pformulario control_formu.formulario%TYPE) IS
    SELECT *
    FROM control_formu
    WHERE no_cia   = pcompania
    AND formulario = pformulario;
  -- FOR UPDATE OF siguiente;
  --
  CURSOR consecutivo_periodo (pcompania   consec_periodo.no_cia%TYPE, 
                              pformulario consec_periodo.formulario%TYPE, 
                              pperiodo    consec_periodo.periodo%TYPE) IS
    SELECT *
    FROM consec_periodo
    WHERE no_cia   = pcompania
    AND formulario = pformulario
    AND periodo    = pperiodo;
  --  FOR UPDATE OF siguiente;
  --
  ----
  -- Inicializa la tabla PL/SQL mensaje con los textos correspodientes a cada error.
  PROCEDURE Inicializar_Mensaje IS
    BEGIN
      mensaje_error(codigo_error.formulario_no_creado)  := 'El formulario no existe o no ha sido creado.';
      mensaje_error(codigo_error.secuencia_no_creada)   := 'La secuencia para el periodo especificado no ha sido creada.';
      mensaje_error(codigo_error.maximo_excedido)       := 'Se excedio el maximo numero especificado para la secuencia.';
      mensaje_error(codigo_error.periodo_invalido)      := 'Periodo especificado es invalido para el formulario.';
      mensaje_error(codigo_error.tipo_invalido)         := 'La operacion no es valida sobre ese tipo de formulario.';
      mensaje_error(codigo_error.reserva_no_posible)    := 'No fue posible crear una reserva de consecutivos para el periodo.';
      mensaje_error(codigo_error.siguiente_no_cambiado) := 'No fue posible cambiar el siguiente numero.';
    END;
--
-- Se definen los procedimientos y funciones privadas al paquete. */
  PROCEDURE limpiar_error IS
  BEGIN
    ultimo_numero_error := NULL;
  END limpiar_error;
--
-- Este procedimiento se encarga de generar el error pasado como parametro
  PROCEDURE generar_error( cod_error  IN BINARY_INTEGER,
                           pmsg_error IN VARCHAR2 := NULL) IS
  BEGIN
    ultimo_numero_error := cod_error;
    IF NOT mensaje_error.EXISTS(ultimo_numero_error) THEN
      Inicializar_Mensaje;
    END IF;
    vmsg_error_adicional := pmsg_error;
    RAISE_APPLICATION_ERROR(num_error, mensaje_error(ultimo_numero_error)||' '||vmsg_error_adicional);
  END generar_error;
  --
  -- Esta funcion retorna el periodo pasado como parametro mas uno. La
  -- funcion distingue si es un a?o o un a?o concatenado con mes.
  FUNCTION aumentar_periodo( periodo IN consec_periodo.periodo%TYPE ) RETURN consec_periodo.periodo%TYPE IS
    --
    periodo_mas_1 consec_periodo.periodo%TYPE;
    ano NUMBER(4);
    mes NUMBER(2);
    --
  BEGIN
    IF LENGTH(periodo) = 6 THEN -- Corresponde a a?o y mes
      mes := SUBSTR(periodo,-2,2);
      IF mes NOT BETWEEN 1 AND 12 THEN
        generar_error(codigo_error.periodo_invalido);
      END IF;
      ano   := SUBSTR(periodo,1,4);
      IF mes = 12 THEN
        mes := 1;
        ano := ano + 1;
      ELSE
        mes := mes + 1;
      END IF;
      periodo_mas_1      := TO_CHAR(ano * 100 + mes);
    ELSIF LENGTH(periodo) = 4 THEN -- Corresponde a unicamente a?o
      periodo_mas_1      := periodo + 1;
    ELSE
      generar_error(codigo_error.periodo_invalido);
    END IF;
    RETURN periodo_mas_1;
  END aumentar_periodo;
  --
  -- --
  --
  FUNCTION activo( pcompania   IN control_formu.no_cia%TYPE,
                   pformulario IN control_formu.formulario%TYPE ) RETURN BOOLEAN IS
  BEGIN
    IF NOT Existe(pcompania, pformulario, NULL) THEN
      Generar_Error(codigo_error.formulario_no_creado);
    ELSE
      RETURN(NVL(reg_control_formu.activo, 'N') = 'S');
    END IF;
  END;
  --
  -- --
  --
  FUNCTION existe_formulario( pcompania   IN control_formu.no_cia%TYPE,
                              pformulario IN control_formu.formulario%TYPE,
                              pmodulo     IN VARCHAR2 ) RETURN BOOLEAN IS
    --
    -- verifica si el formulario ya esta definido, SIN bloqueo de la tabla.
    encontrado BOOLEAN;
    --
    CURSOR ccontrol_formulario ( pcompania control_formu.no_cia%TYPE, 
                                 pformulario control_formu.formulario%TYPE) IS
      SELECT *
      FROM control_formu
      WHERE no_cia   = pcompania
      AND formulario = pformulario;
    --
  BEGIN
    limpiar_error;
    OPEN ccontrol_formulario(pcompania, pformulario);
    FETCH ccontrol_formulario INTO reg_control_formu;
    encontrado := ccontrol_formulario%FOUND;
    CLOSE ccontrol_formulario;
    IF pmodulo IS NULL THEN
      RETURN(encontrado);
    ELSIF instr(pmodulo||',',reg_control_formu.modulo||',') >= 1 AND encontrado THEN
      RETURN(TRUE);
    ELSE
      RETURN(FALSE);
    END IF;
  END;
--
-- --
--
  FUNCTION formulario_activo( pcompania   IN control_formu.no_cia%TYPE,
                              pformulario IN control_formu.formulario%TYPE) RETURN BOOLEAN IS
    --
    -- Devuelve TRUE si el formulario se encuentra activo y FALSE sino.
    -- NO bloquea la tabla.
  BEGIN
    IF NOT Existe_Formulario(pcompania, pformulario, NULL) THEN
      Generar_Error(codigo_error.formulario_no_creado);
    ELSE
      RETURN(NVL(reg_control_formu.activo, 'N') = 'S');
    END IF;
  END;
--
-- --
-- Se implementan los procedimientos y funciones publicos que dan la
-- interface al paquete.
--
--
/*******[ PARTE: PUBLICA ]
* Declaracion de Procedimientos o funciones PUBLICAS
*
*/
--
-- --
--
  FUNCTION ultimo_error RETURN VARCHAR2 IS
  BEGIN
    RETURN(mensaje_error(ultimo_numero_error));
  END ultimo_error;
--
-- --
--
  FUNCTION texto_error( cod_error IN BINARY_INTEGER) RETURN VARCHAR2 IS
  BEGIN
    RETURN( SUBSTR(mensaje_error(cod_error)||' '||vmsg_error_adicional|| ' (Formulario:'||reg_control_formu.formulario||')',1,200) );
  END texto_error;
--
-- --
-- Se implementan los procedimientos y funciones publicos que dan la
-- interface al paquete.
  FUNCTION existe( pcompania   IN control_formu.no_cia%TYPE,
                   pformulario IN control_formu.formulario%TYPE,
                   pmodulo     IN VARCHAR2) RETURN BOOLEAN IS
    encontrado BOOLEAN;
  BEGIN
    limpiar_error;
    OPEN control_formulario(pcompania, pformulario);
    FETCH control_formulario INTO reg_control_formu;
    encontrado := control_formulario%FOUND;
    CLOSE control_formulario;
    IF pmodulo IS NULL THEN
      RETURN(encontrado);
    ELSIF instr(pmodulo||',',reg_control_formu.modulo||',') >= 1 AND encontrado THEN
      RETURN(TRUE);
    ELSE
      RETURN(FALSE);
    END IF;
  END;
--
-- --
--
  PROCEDURE iniciar( pcompania   IN control_formu.no_cia%TYPE,
                     pformulario IN control_formu.formulario%TYPE,
                     pperiodo    IN consec_periodo.periodo%TYPE) IS
    periodo_tmp consec_periodo.periodo%TYPE;
    encontrado BOOLEAN;
    --
    CURSOR periodos(pccompania VARCHAR2, 
                    pcformulario VARCHAR2) IS
      SELECT periodo
      FROM consec_periodo
      WHERE no_cia   = pccompania
      AND formulario = pcformulario
      AND ROWNUM     < 2;
  BEGIN
    -- Verifica el tipo de formulario.  La funcion solo realiza la operacion
    -- sobre formularios con reservas.
    reg_control_formu := datos(pcompania, pformulario);
    IF reg_control_formu.ind_reseteo IN ('RN','RA') THEN
      -- Verifica que no haya sido iniciado anteriormente.
      OPEN periodos(pcompania, pformulario);
      FETCH periodos INTO periodo_tmp;
      encontrado := periodos%FOUND;
      CLOSE periodos;
      IF NOT encontrado THEN
        -- Crea la secuencia para el periodo de inicializacion pasado como parametro.
        INSERT INTO consec_periodo
          (
            no_cia,
            formulario,
            periodo,
            siguiente,
            num_inicial,
            num_final
          )
          VALUES
          (
            reg_control_formu.no_cia,
            reg_control_formu.formulario,
            pperiodo,
            reg_control_formu.num_inicial,
            reg_control_formu.num_inicial,
            NULL
          );
      END IF;
    END IF;
  END iniciar;
--
-- --
--
  PROCEDURE consulta_siguiente
    (
      pcompania   IN control_formu.no_cia%TYPE,
      pformulario IN control_formu.formulario%TYPE,
      pperiodo    IN consec_periodo.periodo%TYPE DEFAULT NULL,
      psiguiente  IN OUT control_formu.siguiente%TYPE,
      pserie      IN OUT control_formu.serie%TYPE
    )
  IS
    --
    -- obtiene el siguiente numero de secuencia segun el formulario dado, BLOQUEANDO la tabla.
    encontrado BOOLEAN;
    secuencia control_formu.siguiente%TYPE;
    vr_control_formu control_formu%ROWTYPE;
    vr_consec_periodo consec_periodo%ROWTYPE;
  BEGIN
    limpiar_error;
    IF NOT activo(pcompania, pformulario) THEN
      Generar_Error(codigo_error.no_activo);
    ELSE
      -- Obtiene de la base de datos la informacion del formulario.
      OPEN control_formulario(pcompania, pformulario);
      FETCH control_formulario INTO vr_control_formu;
      encontrado := control_formulario%FOUND;
      --  Si el formulario no esta definido, se genera un error.
      IF NOT encontrado THEN
        CLOSE control_formulario;
        generar_error(codigo_error.formulario_no_creado);
      END IF;
      --
      -- Unicamente cuando el formulario no se restea y no se mantienen reservas,
      -- se obtiene la secuencia de la tabla control_formu.  El resto de los
      -- casos se debe obtener de consec_periodo.
      IF vr_control_formu.ind_reseteo = 'NU' THEN
        -- Obtiene la secuencia
        secuencia := vr_control_formu.siguiente;
        --
        -- Verifica si la secuencia excedio el maximo en caso de que existiera limite.
        IF vr_control_formu.num_final IS NOT NULL AND secuencia > vr_control_formu.num_final THEN
          CLOSE control_formulario;
          generar_error(codigo_error.maximo_excedido);
        END IF;
        CLOSE control_formulario;
        --
      ELSE
        -- Si el formulario maneja reservas mensuales de forma automatica o se resetea de
        -- forma anual o mensual, la secuencia se debe obtener de consec_periodo.
        -- El programa genera un error en caso de que no exista un registro para
        -- el periodo si las secuencias son digitadas (no automaticas).
        --
        -- Se verifica que se haya recibido un periodo valido como parametro
        -- de acuerdo al indicador de reseteo.
        IF pperiodo IS NULL OR ( vr_control_formu.ind_reseteo IN ('AM','AA') AND LENGTH(pperiodo) != 4) OR ( vr_control_formu.ind_reseteo IN ('RA','RN','MA','MM') AND ( LENGTH(pperiodo) != 6 OR SUBSTR(pperiodo,-2,2) NOT BETWEEN 1 AND 12 )) THEN
          CLOSE control_formulario;
          generar_error(codigo_error.periodo_invalido);
        END IF;
        --
        -- Obtiene la secuencia para el periodo especificado como parametro.
        OPEN consecutivo_periodo(pcompania, pformulario, pperiodo);
        FETCH consecutivo_periodo INTO vr_consec_periodo;
        encontrado := consecutivo_periodo%FOUND;
        --
        -- Si no existe secuencia para ese periodo, se genera un error en el caso
        -- de que el resteo sea manual o se mantengan reservas.  Si el reseteo es
        -- automatico por a?o o mes, se crea un registro con la secuencia para el
        -- proximo periodo.
        IF NOT encontrado AND vr_control_formu.ind_reseteo IN ('RA','RN','MM','AM') THEN
          CLOSE consecutivo_periodo;
          CLOSE control_formulario;
          generar_error(codigo_error.secuencia_no_creada);
        ELSIF NOT encontrado AND vr_control_formu.ind_reseteo IN ('MA','AA') THEN
          -- Siguiente es igual control_formu.num_inicial
          vr_consec_periodo.siguiente := vr_control_formu.num_inicial;
        END IF;
        -- Obtiene la secuencia
        secuencia := vr_consec_periodo.siguiente;
        --
        -- Verifica si la secuencia excedio el maximo en caso de que existiera limite.
        IF vr_consec_periodo.num_final IS NOT NULL AND secuencia > vr_consec_periodo.num_final THEN
          CLOSE control_formulario;
          CLOSE consecutivo_periodo;
          generar_error(codigo_error.maximo_excedido);
        END IF;
        CLOSE control_formulario;
        CLOSE consecutivo_periodo;
      END IF;
    END IF;
    --
    psiguiente := secuencia;
    pserie     := vr_control_formu.serie;
  END consulta_siguiente;
--
-- --
--
  PROCEDURE obtiene_siguiente(
      pcompania   IN control_formu.no_cia%TYPE,
      pformulario IN control_formu.formulario%TYPE,
      pperiodo    IN consec_periodo.periodo%TYPE DEFAULT NULL,
      psiguiente  IN OUT control_formu.siguiente%TYPE,
      pserie      IN OUT control_formu.serie%TYPE)
  IS
    --
    -- obtiene el siguiente numero de secuencia segun el formulario dado, SIN bloquear la tabla.
    encontrado BOOLEAN;
    secuencia control_formu.siguiente%TYPE;
    vr_control_formu control_formu%ROWTYPE;
    vr_consec_periodo consec_periodo%ROWTYPE;
    --
    CURSOR ccontrol_formulario(pcompania control_formu.no_cia%TYPE, pformulario control_formu.formulario%TYPE)
    IS
      SELECT *
      FROM control_formu
      WHERE no_cia   = pcompania
      AND formulario = pformulario;
    --
    CURSOR cconsecutivo_periodo(pcompania consec_periodo.no_cia%TYPE, pformulario consec_periodo.formulario%TYPE, pperiodo consec_periodo.periodo%TYPE)
    IS
      SELECT *
      FROM consec_periodo
      WHERE no_cia   = pcompania
      AND formulario = pformulario
      AND periodo    = pperiodo;
  BEGIN
    limpiar_error;
    IF NOT formulario_activo(pcompania, pformulario) THEN
      Generar_Error(codigo_error.no_activo);
    ELSE
      -- Obtiene de la base de datos la informacion del formulario.
      OPEN ccontrol_formulario(pcompania, pformulario);
      FETCH ccontrol_formulario INTO vr_control_formu;
      encontrado := ccontrol_formulario%FOUND;
      --  Si el formulario no esta definido, se genera un error.
      IF NOT encontrado THEN
        CLOSE ccontrol_formulario;
        generar_error(codigo_error.formulario_no_creado);
      END IF;
      --
      -- Unicamente cuando el formulario no se restea y no se mantienen reservas,
      -- se obtiene la secuencia de la tabla control_formu.  El resto de los
      -- casos se debe obtener de consec_periodo.
      IF vr_control_formu.ind_reseteo = 'NU' THEN
        -- Obtiene la secuencia
        secuencia := vr_control_formu.siguiente;
        --
        -- Verifica si la secuencia excedio el maximo en caso de que existiera limite.
        IF vr_control_formu.num_final IS NOT NULL AND secuencia > vr_control_formu.num_final THEN
          CLOSE ccontrol_formulario;
          generar_error(codigo_error.maximo_excedido);
        END IF;
        CLOSE ccontrol_formulario;
        --
      ELSE
        -- Si el formulario maneja reservas mensuales de forma automatica o se resetea de
        -- forma anual o mensual, la secuencia se debe obtener de consec_periodo.
        -- El programa genera un error en caso de que no exista un registro para
        -- el periodo si las secuencias son digitadas (no automaticas).
        --
        -- Se verifica que se haya recibido un periodo valido como parametro
        -- de acuerdo al indicador de reseteo.
        IF pperiodo IS NULL OR ( vr_control_formu.ind_reseteo IN ('AM','AA') AND LENGTH(pperiodo) != 4) OR ( vr_control_formu.ind_reseteo IN ('RA','RN','MA','MM') AND ( LENGTH(pperiodo) != 6 OR SUBSTR(pperiodo,-2,2) NOT BETWEEN 1 AND 12 )) THEN
          CLOSE ccontrol_formulario;
          generar_error(codigo_error.periodo_invalido);
        END IF;
        --
        -- Obtiene la secuencia para el periodo especificado como parametro.
        OPEN cconsecutivo_periodo(pcompania, pformulario, pperiodo);
        FETCH cconsecutivo_periodo INTO vr_consec_periodo;
        encontrado := cconsecutivo_periodo%FOUND;
        --
        -- Si no existe secuencia para ese periodo, se genera un error en el caso
        -- de que el resteo sea manual o se mantengan reservas.  Si el reseteo es
        -- automatico por a?o o mes, se crea un registro con la secuencia para el
        -- proximo periodo.
        IF NOT encontrado AND vr_control_formu.ind_reseteo IN ('RA','RN','MM','AM') THEN
          CLOSE cconsecutivo_periodo;
          CLOSE ccontrol_formulario;
          generar_error(codigo_error.secuencia_no_creada);
        ELSIF NOT encontrado AND vr_control_formu.ind_reseteo IN ('MA','AA') THEN
          -- Siguiente es igual control_formu.num_inicial
          vr_consec_periodo.siguiente := vr_control_formu.num_inicial;
        END IF;
        -- Obtiene la secuencia
        secuencia := vr_consec_periodo.siguiente;
        --
        -- Verifica si la secuencia excedio el maximo en caso de que existiera limite.
        IF vr_consec_periodo.num_final IS NOT NULL AND secuencia > vr_consec_periodo.num_final THEN
          CLOSE ccontrol_formulario;
          CLOSE cconsecutivo_periodo;
          generar_error(codigo_error.maximo_excedido);
        END IF;
        CLOSE ccontrol_formulario;
        CLOSE cconsecutivo_periodo;
      END IF;
    END IF;
    --
    psiguiente := secuencia;
    pserie     := vr_control_formu.serie;
  END obtiene_siguiente;
--
--
  FUNCTION siguiente(
      pcompania   IN control_formu.no_cia%TYPE,
      pformulario IN control_formu.formulario%TYPE,
      pperiodo    IN consec_periodo.periodo%TYPE )
    RETURN control_formu.siguiente%TYPE
  IS
    encontrado BOOLEAN;
    secuencia control_formu.siguiente%TYPE;
    vperiodo consec_periodo.periodo%type; -- de la forma YYYY o YYYYMM
    -- ind_reseteo:
    --  NU    Nunca resetea
    --  RA    Anual con reserva
    --  RN    Menusal con reserva
    --  MA    Mensual Automatica
    --  AA    Anual Automatica
    --  MM    Mensual Manual
    --  AM    Anual Manual
  BEGIN
    limpiar_error;
    --
    vperiodo := pperiodo;
    --
    -- Obtiene de la base de datos la informacion del formulario.
    OPEN control_formulario(pcompania, pformulario);
    FETCH control_formulario INTO reg_control_formu;
    encontrado := control_formulario%FOUND;
    CLOSE control_formulario;
    --
    --  Si el formulario no esta definido, se genera un error.
    IF NOT encontrado THEN
      generar_error(codigo_error.formulario_no_creado);
    END IF;
    --
    -- Unicamente cuando el formulario no se restea y no se mantienen reservas,
    -- se obtiene la secuencia de la tabla control_formu.  El resto de los
    -- casos se debe obtener de consec_periodo.
    --
    IF reg_control_formu.ind_reseteo = 'NU' THEN
      secuencia                     := reg_control_formu.siguiente;
      IF secuencia                   > NVL(reg_control_formu.num_final, secuencia) THEN
        -- excede el maxino de numero
        generar_error(codigo_error.maximo_excedido);
      END IF;
      --
      --
      UPDATE control_formu
      SET siguiente  = NVL(siguiente, num_inicial) + 1
      WHERE no_cia   = pcompania
      AND formulario = pformulario;
      --
      OPEN control_formulario(pcompania, pformulario);
      FETCH control_formulario INTO reg_control_formu;
      encontrado := control_formulario%FOUND;
      CLOSE control_formulario;
      --
      IF secuencia > 2 THEN
        secuencia := reg_control_formu.siguiente - 1;
      END IF;
      --
    ELSE
      -- Si el formulario maneja reservas mensuales de forma automatica o se resetea de
      -- forma anual o mensual, la secuencia se debe obtener de consec_periodo.  El programa
      -- genera un error en caso de que no exista un registro para el periodo si las
      -- secuencias son digitadas (no automaticas).
      --
      -- Se verifica que se haya recibido un periodo valido como parametro
      -- de acuerdo al indicador de reseteo.
      IF vperiodo IS NULL THEN
        generar_error(codigo_error.periodo_invalido,' periodo NULL');
      ELSIF (reg_control_formu.ind_reseteo IN ('AM','AA') AND LENGTH(vperiodo) < 4) THEN
        generar_error(codigo_error.periodo_invalido,' longitud de periodo es: '||vperiodo);
      ELSIF(reg_control_formu.ind_reseteo IN ('RA','RN','MA','MM') AND ( LENGTH(vperiodo) != 6 OR SUBSTR(vperiodo,-2,2) NOT BETWEEN 1 AND 12 )) THEN
        generar_error(codigo_error.periodo_invalido, ' periodo es: '||vperiodo);
      END IF;
      --
      IF reg_control_formu.ind_reseteo IN ('AM','AA') THEN
        vperiodo := SUBSTR(vperiodo,1,4);
      END IF;
      --
      --
      OPEN consecutivo_periodo(pcompania, pformulario, vperiodo);
      FETCH consecutivo_periodo INTO reg_consec_periodo;
      encontrado := consecutivo_periodo%FOUND;
      CLOSE consecutivo_periodo;
      --
      -- Si no existe secuencia para ese periodo, se genera un error en el caso
      -- de que el resteo sea manual o se mantengan reservas.  Si el reseteo es
      -- automatico por a?o o mes, se crea un registro con la secuencia para el
      -- proximo periodo.
      IF NOT encontrado AND reg_control_formu.ind_reseteo IN ('RA','RN','MM','AM') THEN
        generar_error(codigo_error.secuencia_no_creada);
      ELSIF NOT encontrado AND reg_control_formu.ind_reseteo IN ('MA','AA') THEN
        -- Crea el registro para el periodo que se este solicitando.
        INSERT
        INTO consec_periodo
          (
            no_cia,
            formulario,
            periodo,
            siguiente,
            num_inicial,
            num_final
          )
          VALUES
          (
            reg_control_formu.no_cia,
            reg_control_formu.formulario,
            vperiodo,
            reg_control_formu.num_inicial,
            reg_control_formu.num_inicial,
            reg_control_formu.num_final
          );
        --
        -- Actualiza la informacion del registro en memoria.
        reg_consec_periodo.no_cia      := reg_control_formu.no_cia;
        reg_consec_periodo.formulario  := reg_control_formu.formulario;
        reg_consec_periodo.periodo     := vperiodo;
        reg_consec_periodo.siguiente   := reg_control_formu.num_inicial;
        reg_consec_periodo.num_inicial := reg_control_formu.num_inicial;
        reg_consec_periodo.num_final   := reg_control_formu.num_final;
      ELSIF NOT encontrado THEN
        generar_error(codigo_error.secuencia_no_creada);
      END IF;
      --
      --
      secuencia   := reg_consec_periodo.siguiente;
      IF secuencia > NVL(reg_consec_periodo.num_final, secuencia) THEN
        generar_error(codigo_error.maximo_excedido);
      END IF;
      --
      -- Actualiza el siguiente numero.
      UPDATE consec_periodo
      SET siguiente  = NVL(siguiente, num_inicial) + 1
      WHERE no_cia   = reg_consec_periodo.no_cia
      AND formulario = reg_consec_periodo.formulario
      AND periodo    = reg_consec_periodo.periodo;
      --
      OPEN consecutivo_periodo(pcompania, pformulario, vperiodo);
      FETCH consecutivo_periodo INTO reg_consec_periodo;
      encontrado := consecutivo_periodo%FOUND;
      CLOSE consecutivo_periodo;
      --
      IF secuencia > 2 THEN
        secuencia := reg_consec_periodo.siguiente - 1;
      END IF;
    END IF;
    RETURN(secuencia);
  END siguiente;
--
--
  PROCEDURE reservar(
      pcompania   IN control_formu.no_cia%TYPE,
      pformulario IN control_formu.formulario%TYPE,
      pperiodo    IN consec_periodo.periodo%TYPE)
  IS
    periodo_siguiente consec_periodo.periodo%TYPE;
    encontrado_sig_per BOOLEAN;
    encontrado         BOOLEAN;
    ano_nuevo          BOOLEAN;
    inicial consec_periodo.num_inicial%TYPE;
    final consec_periodo.num_final%TYPE;
  BEGIN
    IF NOT activo(pcompania, pformulario) THEN
      Generar_Error(codigo_error.no_activo);
    END IF;
    -- Obtiene la informacion del formulario.
    OPEN control_formulario(pcompania, pformulario);
    FETCH control_formulario INTO reg_control_formu;
    encontrado := control_formulario%FOUND;
    CLOSE control_formulario;
    IF NOT encontrado THEN
      generar_error(codigo_error.formulario_no_creado);
    END IF;
    -- Valida que esta operacion se realice sobre formularios que generen
    -- reservas por mes.
    IF reg_control_formu.ind_reseteo NOT IN ('RA','RN') THEN
      generar_error(codigo_error.tipo_invalido);
    END IF;
    -- Obtiene el siguiente periodo del que se esta pasando como parametro.
    periodo_siguiente := aumentar_periodo(pperiodo);
    -- Guarda en la variable si hay cambio a?o
    ano_nuevo := (SUBSTR(pperiodo,1,4) != SUBSTR(periodo_siguiente,1,4));
    -- Para el periodo siguiente se obtiene la informacion para verificar que
    -- que no se haya generado ninguna secuencia de ese mes o que no tenga un
    -- limite superior.
    OPEN consecutivo_periodo(pcompania, pformulario, periodo_siguiente);
    FETCH consecutivo_periodo INTO reg_consec_periodo;
    encontrado_sig_per := consecutivo_periodo%FOUND;
    CLOSE consecutivo_periodo;
    IF encontrado_sig_per AND (reg_consec_periodo.num_inicial < reg_consec_periodo.siguiente OR reg_consec_periodo.num_final IS NOT NULL) THEN
      generar_error(codigo_error.reserva_no_posible);
    END IF;
    -- Obtiene la informacion del consecutivo para el periodo pasado como parametro.
    OPEN consecutivo_periodo(pcompania, pformulario, pperiodo);
    FETCH consecutivo_periodo INTO reg_consec_periodo;
    encontrado := consecutivo_periodo%FOUND;
    IF NOT encontrado THEN
      CLOSE consecutivo_periodo;
      generar_error(codigo_error.secuencia_no_creada);
    END IF;
    -- Calcula el numero final para el periodo incluyendo reservados.
    final := reg_consec_periodo.siguiente + reg_control_formu.reservados;
    -- Calcula el inical para el siguiente mes.
    IF ano_nuevo THEN
      inicial := reg_control_formu.num_inicial;
    ELSE
      inicial := final + 1;
    END IF;
    -- Si el consecutivo para el periodo no existe se inserta uno nuevo.  Si
    -- ya existe se actualiza la informacion para permitir expander los
    -- reservados.
    IF encontrado_sig_per THEN
      UPDATE consec_periodo
      SET num_inicial = inicial,
        siguiente     = inicial
      WHERE no_cia    = pcompania
      AND formulario  = pformulario
      AND periodo     = periodo_siguiente;
    ELSE
      INSERT
      INTO consec_periodo
        (
          no_cia,
          formulario,
          periodo,
          siguiente,
          num_inicial,
          num_final
        )
        VALUES
        (
          pcompania,
          pformulario,
          periodo_siguiente,
          inicial,
          inicial,
          NULL
        );
    END IF;
    -- Actualiza el limite superior de los consecutivos por el numero actual mas
    -- la cantidad de reservados.
    /* UPDATE consec_periodo
    SET num_final = final
    WHERE CURRENT OF consecutivo_periodo;*/
    CLOSE consecutivo_periodo;
  END reservar;
--
-- --
--
  PROCEDURE cambiar_siguiente
    (
      pcompania   IN control_formu.no_cia%TYPE,
      pformulario IN control_formu.formulario%TYPE,
      pperiodo    IN consec_periodo.periodo%TYPE,
      panterior   IN control_formu.siguiente%TYPE,
      pnuevo      IN control_formu.siguiente%TYPE
    )
  IS
    encontrado BOOLEAN;
  BEGIN
    limpiar_error;
    IF NOT activo(pcompania, pformulario) THEN
      Generar_Error(codigo_error.no_activo);
    END IF;
    -- Obtiene la informacion de la base de datos para determinar el tipo
    -- de formulario.
    OPEN control_formulario(pcompania, pformulario);
    FETCH control_formulario INTO reg_control_formu;
    encontrado := control_formulario%FOUND;
    IF NOT encontrado THEN
      CLOSE control_formulario;
      generar_error(codigo_error.formulario_no_creado);
    END IF;
    -- Si el formulario nunca se resetea se modifica directamente en
    -- control_formu, de lo contrario el siguiente se modifica en el periodo
    -- pasado como parametro.
    IF reg_control_formu.ind_reseteo = 'NU' THEN
      -- Se verifica que el panterior coincida con el siguiente.
      IF panterior != reg_control_formu.siguiente THEN
        CLOSE control_formulario;
        generar_error(codigo_error.siguiente_no_cambiado);
      END IF;
      -- Actualiza el siguiente.
      UPDATE control_formu
      SET siguiente    = pnuevo
      WHERE formulario = reg_control_formu.formulario
      AND no_cia       = reg_control_formu.no_cia;
      /*CURRENT OF control_formulario;*/
      CLOSE control_formulario;
    ELSE
      -- Obtiene la informacion de los consecutivos por periodo
      OPEN consecutivo_periodo(pcompania, pformulario, pperiodo);
      FETCH consecutivo_periodo INTO reg_consec_periodo;
      encontrado := consecutivo_periodo%FOUND;
      IF NOT encontrado THEN
        CLOSE control_formulario;
        CLOSE consecutivo_periodo;
        generar_error(codigo_error.secuencia_no_creada);
      END IF;
      -- Se verifica que el panterior coincida con el siguiente.
      IF panterior != reg_consec_periodo.siguiente THEN
        CLOSE control_formulario;
        CLOSE consecutivo_periodo;
        generar_error(codigo_error.siguiente_no_cambiado);
      END IF;
      -- Actualiza el siguiente.
      /*UPDATE consec_periodo
      SET siguiente = pnuevo
      WHERE CURRENT OF consecutivo_periodo;*/
      CLOSE control_formulario;
      CLOSE consecutivo_periodo;
    END IF;
  END cambiar_siguiente;
--
--
  FUNCTION datos(
      pcompania   IN control_formu.no_cia%TYPE,
      pformulario IN control_formu.formulario%TYPE)
    RETURN datos_formulario
  IS
    encontrado BOOLEAN;
  BEGIN
    limpiar_error;
    -- Obtiene de la base de datos la informacion del formulario.
    OPEN control_formulario(pcompania, pformulario);
    FETCH control_formulario INTO reg_control_formu;
    encontrado := control_formulario%FOUND;
    CLOSE control_formulario;
    -- Si el formulario no esta definido, se genera un error.
    IF NOT encontrado THEN
      generar_error(codigo_error.formulario_no_creado);
    END IF;
    RETURN(reg_control_formu);
  END datos;
--
--
  FUNCTION datos_periodo(
      pcompania   IN consec_periodo.no_cia%TYPE,
      pformulario IN consec_periodo.formulario%TYPE,
      pperiodo    IN consec_periodo.periodo%TYPE)
    RETURN datos_formu_periodo
  IS
    encontrado BOOLEAN;
  BEGIN
    limpiar_error;
    -- Verifica si el formulario se encuentra en memoria para no tener que
    -- realizar un "select".
    IF reg_consec_periodo.no_cia = pcompania AND reg_consec_periodo.formulario = pformulario AND reg_consec_periodo.periodo = pperiodo THEN
      RETURN(reg_consec_periodo);
      -- El el caso de que el periodo de la secuencia no se encuentre en la variable
      -- global del paquete o se este tratando de obtener la informacion de otro periodo,
      -- se realiza la consulta.
    ELSE
      -- Obtiene de la base de datos la informacion del formulario.
      OPEN consecutivo_periodo(pcompania, pformulario, pperiodo);
      FETCH consecutivo_periodo INTO reg_consec_periodo;
      encontrado := consecutivo_periodo%FOUND;
      CLOSE consecutivo_periodo;
      -- Si el formulario no esta definido, se genera un error.
      IF NOT encontrado THEN
        generar_error(codigo_error.secuencia_no_creada);
      END IF;
      RETURN(reg_consec_periodo);
    END IF;
  END datos_periodo;
--
  FUNCTION ultimo_codigo_error
    RETURN BINARY_INTEGER
  IS
  BEGIN
    RETURN(ultimo_numero_error);
  END ultimo_codigo_error;
--
END formulario;
/
