CREATE OR REPLACE PACKAGE NAF47_TNET.depreciacion IS
  -- --
  -- Este paquete ofrece funciones para calcular la depreciacion de los
  -- activos fijos, sus mejoras y sus revaluaciones tecnicas
  --
  -- Se definen los tipos de dato que deben utilizar las variables para
  -- obtener informacion acerca de los activos y sus movimientos.
  --
  --
  TYPE datos_activo_r IS RECORD(
    no_acti          arafma.no_acti%type,
    f_ingre          arafma.f_ingre%type,
    fecha_inicio_dep arafma.fecha_inicio_dep%type,
    duracion         arafma.duracion%type,
    ind_depreciacion arafmt.ind_depreciacion%type,
    metodo_dep       arafma.metodo_dep%type,
    desecho          arafma.desecho%type,
    tipo_cambio      arafma.tipo_cambio%type
    -- Nominal
    ,
    val_original        arafma.val_original%type,
    depacum_valorig_ant arafma.depacum_valorig_ant%type,
    depacum_valorig     arafma.depacum_valorig%type,
    mejoras             arafma.mejoras%type,
    depacum_mejoras_ant arafma.depacum_mejoras_ant%type,
    depacum_mejoras     arafma.depacum_mejoras%type,
    rev_tecs            arafma.rev_tecs%type,
    depacum_revtecs_ant arafma.depacum_revtecs_ant%type,
    depacum_revtecs     arafma.depacum_revtecs%type
    -- Dolares
    ,
    val_original_dol        arafma.val_original_dol%type,
    t_valorig_dol           arafma.val_original_dol%type,
    depacum_valorig_ant_dol arafma.depacum_valorig_ant_dol%type,
    depacum_valorig_dol     arafma.depacum_valorig_dol%type,
    mejoras_dol             arafma.mejoras_dol%type,
    t_mejoras_dol           arafma.mejoras_dol%type,
    depacum_mejoras_ant_dol arafma.depacum_mejoras_ant_dol%type,
    depacum_mejoras_dol     arafma.depacum_mejoras_dol%type,
    rev_tecs_dol            arafma.rev_tecs_dol%type,
    t_revtecs_dol           arafma.rev_tecs_dol%type,
    depacum_revtecs_ant_dol arafma.depacum_revtecs_ant_dol%type,
    depacum_revtecs_dol     arafma.depacum_revtecs_dol%type);
  --
  TYPE registro_error IS RECORD(
    activo_no_creado BINARY_INTEGER := 1, -- Indica que el activo no se encuentra
    -- definido
    movimiento_no_creado BINARY_INTEGER := 2, -- Indica si el movimiento no se encuentra
    -- definido
    valor_ipc_no_encontrado BINARY_INTEGER := 3,
    periodo_invalido        BINARY_INTEGER := 4,
    valor_ipc_no_valido     BINARY_INTEGER := 5);
  --
  -- La funcion Existe retorna verdadero en caso de que el activo
  -- exista para la compa?ia.  En el caso que no se encuentre el
  -- activo especificado, se retorna falso.  La funcion no genera un error.
  FUNCTION existe(pcompania IN naf47_tnet.arafma.no_cia%TYPE,
                  pno_acti  IN naf47_tnet.arafma.no_acti%TYPE) RETURN BOOLEAN;
  --
  -- Este procedimiento realiza el calculo de la depreciacion de los activos
  -- de la compa?ia especificada, con sus respectivas mejoras y revaluaciones
  -- tecnicas
  PROCEDURE calcula(pcompania IN naf47_tnet.arafhm.no_cia%TYPE,
                    pano      IN naf47_tnet.arafhm.ano%TYPE,
                    pmes      IN naf47_tnet.arafhm.mes%TYPE,
                    ptipo_dep IN varchar2 default 'N');
  --
  -- Esta funcion retorna el mensaje relacionado con el ultimo
  -- error que se presento en el paquete.
  FUNCTION ultimo_error RETURN VARCHAR2;
  --
  error EXCEPTION;
  PRAGMA EXCEPTION_INIT(error, -20032);
  num_error NUMBER := -20032;
  --
-- Define restricciones de procedimientos y funciones
--    WNDS = Writes No Database State
--    RNDS = Reads  No Database State
--    WNPS = Writes No Package State
--    RNPS = Reads  No Package State
--
END depreciacion;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.depreciacion IS

  FUNCTION ultimo_error RETURN VARCHAR2 IS
  BEGIN
    RETURN(naf47_tnet.depreciacion.ultimo_error);
  END ultimo_error;
  --
  --
  FUNCTION existe(pcompania IN naf47_tnet.arafma.no_cia%TYPE,
                  pno_acti  IN naf47_tnet.arafma.no_acti%TYPE) RETURN BOOLEAN IS
  BEGIN
    return naf47_tnet.depreciacion.existe@gpoetnet(pcompania => pcompania,
                                          pno_acti  => pno_acti);
  END existe;
  --

  /**
  * Documentación para CALCULA
  * Procedimiento que determina los activos a depreciar
  *
  * @author  Yoveri S.A.
  * @version 1.0 01/01/2000
  *
  * @param pcompania IN Recibe el codigo de la empresa
  * @param pano      IN Recibe el anio de proceso
  * @param pmes      IN Recibe el mes de proceso
  * @param ptipo_dep IN Recibe el metodo de depreciacion
  */
  PROCEDURE calcula(pcompania IN naf47_tnet.arafhm.no_cia%TYPE,
                    pano      IN naf47_tnet.arafhm.ano%TYPE,
                    pmes      IN naf47_tnet.arafhm.mes%TYPE,
                    ptipo_dep IN varchar2 default 'N') IS

  BEGIN
    naf47_tnet.depreciacion.calcula@gpoetnet(pcompania => pcompania,
                                             pano      => pano,
                                             pmes      => pmes,
                                             ptipo_dep => ptipo_dep);
  END calcula;
  --
END depreciacion;
/
