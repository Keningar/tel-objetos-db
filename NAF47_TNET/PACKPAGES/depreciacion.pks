CREATE OR REPLACE PACKAGE NAF47_TNET.depreciacion IS
  -- --
  -- Este paquete ofrece funciones para calcular la depreciacion de los
  -- activos fijos, sus mejoras y sus revaluaciones tecnicas
  --
  -- Se definen los tipos de dato que deben utilizar las variables para
  -- obtener informacion acerca de los activos y sus movimientos.
  --
  --
  TYPE datos_activo_r     IS RECORD(
      no_acti                           arafma.no_acti%type
     ,f_ingre                           arafma.f_ingre%type
     ,fecha_inicio_dep                  arafma.fecha_inicio_dep%type
     ,duracion                          arafma.duracion%type
     ,ind_depreciacion                  arafmt.ind_depreciacion%type
     ,metodo_dep                        arafma.metodo_dep%type
     ,desecho                           arafma.desecho%type
     ,tipo_cambio                       arafma.tipo_cambio%type
     -- Nominal
     ,val_original                      arafma.val_original%type
     ,depacum_valorig_ant               arafma.depacum_valorig_ant%type
     ,depacum_valorig                   arafma.depacum_valorig%type
     ,mejoras                           arafma.mejoras%type
     ,depacum_mejoras_ant               arafma.depacum_mejoras_ant%type
     ,depacum_mejoras                   arafma.depacum_mejoras%type
     ,rev_tecs                          arafma.rev_tecs%type
     ,depacum_revtecs_ant               arafma.depacum_revtecs_ant%type
     ,depacum_revtecs                   arafma.depacum_revtecs%type
     -- Dolares
     ,val_original_dol                  arafma.val_original_dol%type
     ,t_valorig_dol                     arafma.val_original_dol%type
     ,depacum_valorig_ant_dol           arafma.depacum_valorig_ant_dol%type
     ,depacum_valorig_dol               arafma.depacum_valorig_dol%type
     ,mejoras_dol                       arafma.mejoras_dol%type
     ,t_mejoras_dol                     arafma.mejoras_dol%type
     ,depacum_mejoras_ant_dol           arafma.depacum_mejoras_ant_dol%type
     ,depacum_mejoras_dol               arafma.depacum_mejoras_dol%type
     ,rev_tecs_dol                      arafma.rev_tecs_dol%type
     ,t_revtecs_dol                     arafma.rev_tecs_dol%type
     ,depacum_revtecs_ant_dol           arafma.depacum_revtecs_ant_dol%type
     ,depacum_revtecs_dol               arafma.depacum_revtecs_dol%type
     );
  --
  TYPE registro_error IS RECORD(
     activo_no_creado        BINARY_INTEGER := 1,  -- Indica que el activo no se encuentra
                                                   -- definido
     movimiento_no_creado    BINARY_INTEGER := 2,  -- Indica si el movimiento no se encuentra
                                                   -- definido
     valor_ipc_no_encontrado BINARY_INTEGER := 3,
     periodo_invalido        BINARY_INTEGER := 4,
     valor_ipc_no_valido     BINARY_INTEGER := 5
     );
  --
  -- La funcion Existe retorna verdadero en caso de que el activo
  -- exista para la compa?ia.  En el caso que no se encuentre el
  -- activo especificado, se retorna falso.  La funcion no genera un error.
  FUNCTION existe(pcompania   IN arafma.no_cia%TYPE,
                  pno_acti    IN arafma.no_acti%TYPE) RETURN BOOLEAN;
  --
  -- Este procedimiento realiza el calculo de la depreciacion de los activos
  -- de la compa?ia especificada, con sus respectivas mejoras y revaluaciones
  -- tecnicas
  PROCEDURE calcula(pcompania   IN arafhm.no_cia%TYPE,
                    pano        IN arafhm.ano%TYPE,
                    pmes        IN arafhm.mes%TYPE,
                    ptipo_dep   IN varchar2 default 'N');
  --
  -- Esta funcion retorna el mensaje relacionado con el ultimo
  -- error que se presento en el paquete.
  FUNCTION ultimo_error RETURN VARCHAR2;
  --
  error       EXCEPTION;
  PRAGMA      EXCEPTION_INIT(error, -20032);
  num_error   NUMBER := -20032;
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
  /*******[ PARTE: PRIVADA ]
  * Declaracion de Procedimientos o funciones PRIVADOS
  *
  */
  --
  TYPE tabla_mensajes_t IS TABLE OF VARCHAR2(255) NOT NULL
     INDEX BY BINARY_INTEGER;
  SUBTYPE datos_depreciacion_r IS arafhd%rowtype;
  --
  --
  ultimo_numero_error   BINARY_INTEGER;  --  almacena codigo del ultimo error
  codigo_error      registro_error;   --  registro con los codigos de error
  --
  -- --
  -- Declaracion de cursores
  CURSOR c_activo (pno_cia arafma.no_cia%type,
                   pno_acti arafma.no_acti%type) is
    select no_cia, no_acti, descri
    from arafma
    where no_cia  = pno_cia and
          no_acti = pno_acti;
  --
  -- --
  -- Declaracion de variables
  gtstamp           number;
  reg_activos       datos_activo_r;
  reg_act           c_activo%rowtype;
  mensaje_error     tabla_mensajes_t;
  --
  --
  -- --
  -- Inicializa la tabla PL/SQL mensaje con los textos correspodientes a cada error.
  PROCEDURE Inicializar_Mensaje IS
  BEGIN
    mensaje_error(codigo_error.activo_no_creado)     := 'El Activo no existe o no ha sido creado.';
    mensaje_error(codigo_error.movimiento_no_creado) := 'El movimiento para el periodo especificado no ha sido creado.';
    mensaje_error(codigo_error.valor_ipc_no_encontrado) := 'Todos los valores del IPC no han sido definidos.';
    mensaje_error(codigo_error.periodo_invalido)        := 'Periodo invalido.';
  END;
  --
  --
  -- Se definen los procedimientos y funciones privadas al paquete.
  PROCEDURE limpiar_error IS
  BEGIN
    ultimo_numero_error := NULL;
  END limpiar_error;
  --
  --
  -- Este procedimiento se encarga de generar el error pasado como parametro
  PROCEDURE generar_error(cod_error IN BINARY_INTEGER) IS
  BEGIN
     ultimo_numero_error := cod_error;
     IF NOT mensaje_error.EXISTS(ultimo_numero_error) THEN
        Inicializar_Mensaje;
     END IF;
     RAISE_APPLICATION_ERROR(num_error, mensaje_error(ultimo_numero_error));
  END generar_error;
  --
  --
  -- Borra los movimientos que habian el historico de depreciacion para un a?o y mes dado
  PROCEDURE borra_historico_depreciacion(
            pcompania IN arafma.no_cia%TYPE,
                                          pAno      IN arafhd.ano%TYPE,
                                          pMes      IN arafhd.mes%TYPE
                                        ) IS
  BEGIN
     DELETE FROM arafhd
        WHERE no_cia = pcompania
          AND ano    = pAno
          AND mes    = pMes;
  END borra_historico_depreciacion;
  --
  --
  FUNCTION F_DEPRECIACION_LINEA_RECTA(Fd_InicioDepreciacion IN DATE,
                                      Fd_Actual             IN DATE,
                                      Fn_Monto              IN arafmm.monto%type,
                                      Fv_Moneda             IN Varchar2,
                                      Fn_MesesDuracion      IN NUMBER) RETURN NUMBER IS

/**
 * Documentación para DEPRECIAR
 * Procedimiento que de acuerdo al metodo llama a otro proceso especifico.
 *
 * @author  Yoveri S.A.
 * @version 1.0 01/01/2000

 * @author  Martha Navarrete M. <mnavarrete@telconet.ec>
 * @version 1.1 30/05/2000  Se actualiza funcion para que deprecie por dia y no solo mes completo.
 *
 * @param Fd_InicioDepreciacion IN Recibe la fecha de inicio de la depreciacion
 * @param Fd_Actual             IN Recibe la fecha de proceso
 * @param Fn_Monto              IN Recibe el valor original del activo
 * @param Fv_Moneda             IN Recibe el tipo de moneda a utilizar
 * @param Fn_MesesDuracion      IN Recibe el total de meses a depreciar
 */

     Ln_VidaUtilResidual   Number(5);
     Ln_MontoDepreciacion  arafhd.dep_valorig%type;

  BEGIN
    Ln_VidaUtilResidual := Fn_MesesDuracion;

    If to_char(Fd_InicioDepreciacion,'YYYYMM') = to_char(Fd_Actual,'YYYYMM') Then
      -- Depreciación ór los dias que faltan para terminar el mes
      Ln_MontoDepreciacion := moneda.redondeo((moneda.redondeo(nvl(Fn_Monto,0)/Ln_VidaUtilResidual, Fv_moneda)/30) * (30-to_char(Fd_InicioDepreciacion,'DD')+1), Fv_moneda);
    else
      If Fd_InicioDepreciacion <= Fd_Actual then
        -- solo se divide para el factor en meses ANR 20/10/2010
        Ln_MontoDepreciacion := moneda.redondeo(nvl(Fn_Monto,0) / Ln_VidaUtilResidual, Fv_moneda);
      else
        Ln_MontoDepreciacion := 0;
      End if;
    End if;
    --
    return(Ln_MontoDepreciacion);
  END F_DEPRECIACION_LINEA_RECTA;
  --
  --
  FUNCTION depreciacion_suma_digitos(
    pf_fin            DATE,
    pf_inicio_dep     DATE,
    pf_actual         IN date,
    pmonto            IN arafmm.monto%type,
    pmoneda           IN Varchar2
  ) RETURN number
  IS
     vVida_Util_Residual   Number(5);
     vfactor               Number(5);
     vdep                 arafhd.dep_valorig%type;
  BEGIN
    if pf_inicio_dep <= pf_actual  then
      vVida_Util_Residual := trunc(MONTHS_BETWEEN(pf_fin,pf_actual));
      vVida_Util_Residual := greatest(1,vVida_Util_Residual);
      vfactor  := round(vVida_Util_Residual * ( (vVida_Util_Residual + 1) / 2 ) );
      vdep :=   moneda.redondeo((vVida_Util_residual/vfactor )* pmonto, pmoneda);
   else
       vdep := 0;
    end if;
    return(vdep);
  END depreciacion_suma_digitos;
  --
  --
  PROCEDURE depreciar(  pFecha_proce         IN DATE,
                        pFecha_inicio_dep    IN arafma.fecha_inicio_dep%type,
                        pmeses_duracion      IN arafma.duracion%type,
                        pMetodo_dep          IN arafma.metodo_dep%type,
                        pValor               IN arafma.val_original%type,
                        pDep_Acum            IN arafma.depacum_valorig%type,
                        pMonto_dep           IN OUT arafhm.monto%type,
                        pmoneda              IN VARCHAR2                ) IS

/**
 * Documentación para DEPRECIAR
 * Procedimiento que de acuerdo al metodo llama a otro proceso especifico.
 *
 * @author  Yoveri S.A.
 * @version 1.0 01/01/2000

 * @author  Martha Navarrete M. <mnavarrete@telconet.ec>
 * @version 1.1 30/05/2000  Se modifica nombre de proceso que realiza depreciacion lineal
 *
 * @param pFecha_proce      IN Recibe la fecha de proceso del modulo
 * @param pFecha_inicio_dep IN Recibe la fecha de inicio de la depreciacion
 * @param pmeses_duracion   IN Recibe el total de meses a depreciar
 * @param pMetodo_dep       IN Recibe el metodo de deperciacion
 * @param pValor     IN Recibe el valor original del activo
 * @param pDep_Acum  IN Recibe el valor acumulado por depreciaciones
 * @param pMonto_dep IN OUT Retorna el valor a depreciar
 * @param pmoneda    IN Recibe la moneda a utilizar
 */

    valor_a_depreciar   number;
    vFecha_fin          date;

  BEGIN
    -- Lineal
    vFecha_fin := add_months(pFecha_inicio_dep, pmeses_duracion);

    ---valor_a_depreciar  := greatest(0, nvl(pValor,0) - nvl(pDep_Acum,0)); -- ANR 20/10/2010  no debe restar la depreciacion acumulada
    valor_a_depreciar  := greatest(0, nvl(pValor,0));

    if pMetodo_dep = 'L' then   --Lineal
      pMonto_dep := F_DEPRECIACION_LINEA_RECTA(pFecha_inicio_dep,
                                               pFecha_proce,  valor_a_depreciar,
                                               pmoneda, pmeses_duracion);--- se agrega parametro de meses duracion ANR 20/10/2010
    elsif pmetodo_dep = 'S' then  --Suma de digitos
      pMonto_dep := depreciacion_suma_digitos(vFecha_fin,    pFecha_inicio_dep,
                                              pFecha_proce,  valor_a_depreciar,
                                              pmoneda);
    end if;

    --Caso para la ultima depreciacion, por el factor de redondeo
    pMonto_dep :=  least(pMonto_dep, (nvl(pValor,0)-nvl(pDep_Acum,0)));

  END depreciar;
  --
  --
  --
  /*******[ PARTE: PUBLICA ]
  * Declaracion de Procedimientos o funciones PUBLICAS
  *
  */
  --
  --
  FUNCTION ultimo_error RETURN VARCHAR2 IS
  BEGIN
     RETURN(mensaje_error(ultimo_numero_error));
  END ultimo_error;
  --
  --
  FUNCTION existe(
    pcompania   IN arafma.no_cia%TYPE,
    pno_acti    IN arafma.no_acti%TYPE
  ) RETURN BOOLEAN
  IS
    encontrado  BOOLEAN;
    vtstamp     NUMBER;
   BEGIN
    limpiar_error;
  encontrado := FALSE;
    vtstamp    := TO_CHAR(sysdate, 'SSSSS');
    IF (gTstamp is null OR ABS(vtstamp - gTstamp) > 1) OR
     (reg_act.no_cia  is null OR reg_act.no_cia != pcompania) OR
     (reg_act.no_acti is null OR reg_act.no_acti != pno_acti) THEN
       -- Obtiene de la base de datos la informacion del activo.
       OPEN c_activo(pcompania, pno_acti);
       FETCH c_activo INTO reg_act;
       encontrado := c_activo%FOUND;
       CLOSE c_activo;
       -- Si el activo esta definido, se genera un error.
       IF NOT encontrado THEN
          generar_error(codigo_error.activo_no_creado);
       END IF;
  ELSE
     encontrado := (reg_act.no_cia = pcompania AND reg_act.no_acti = pno_acti);
    END IF;
  END existe;
  --
  --
  PROCEDURE calcula(pcompania   IN arafhm.no_cia%TYPE,
                    pano        IN arafhm.ano%TYPE,
                    pmes        IN arafhm.mes%TYPE,
                    ptipo_dep   IN varchar2 default 'N'  ) IS

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

    vMeses_Duracion       arafma.duracion%type;
    vFecha_proce          date;
    --
    vdep_mov_vo           arafmm.monto%type;
    vdep_mov_vo_dol       arafmm.monto%type;
    vdep_mov_mej          arafmm.monto%type;
    vdep_mov_mej_dol      arafmm.monto%type;
    vdep_mov_re           arafmm.monto%type;
    vdep_mov_re_dol       arafmm.monto%type;
    --
    vvalor_original       arafma.val_original%type;
    vvalor_original_dol   arafma.val_original_dol%type;
    --

    cursor c_activos_dep(pno_cia char,ptipo_m char default 'N') is
       select ma.no_acti                              -- Codigo de activo
             ,ma.f_ingre                              -- Fecha de ingreso
             ,ma.fecha_inicio_dep                     -- Fecha de inicio de la depreciacion
             ,(ma.duracion * 12) meses_duracion       -- Duracion en meses
             ,ma.metodo_dep                           -- Metodo de depreciacion
             ,ma.desecho                              -- Valor de desecho o rescate
             ,ma.tipo_cambio
             -- Nominal
             ,ma.val_original
             ,ma.depacum_valorig_ant
             ,ma.depacum_valorig
             ,ma.mejoras
             ,ma.depacum_mejoras_ant
             ,ma.depacum_mejoras
             ,ma.rev_tecs
             ,ma.depacum_revtecs_ant
             ,ma.depacum_revtecs
             -- Dolares
             ,ma.val_original_dol
             ,ma.depacum_valorig_ant_dol
             ,ma.depacum_valorig_dol
             ,ma.mejoras_dol
             ,ma.depacum_mejoras_ant_dol
             ,ma.depacum_mejoras_dol
             ,ma.rev_tecs_dol
             ,ma.depacum_revtecs_ant_dol
             ,ma.depacum_revtecs_dol
             ,rowid rowid_activo
       from  arafma ma
       where ma.no_cia           = pno_cia
         and ma.f_egre is null
         and ma.fecha_fin_vida_util is null
         and (nvl(ma.val_original,0)- nvl(ma.depacum_valorig_ant,0)+
              nvl(ma.mejoras,0)     - nvl(ma.depacum_mejoras_ant,0)+
              nvl(ma.rev_tecs,0)    - nvl(ma.depacum_revtecs_ant,0))   > nvl(ma.desecho,0)
         and (ptipo_m = 'N')
         and ma.tipo in (select tipo
                             from arafmt
                             where no_cia = pno_cia
                               and ind_depreciacion = 'S')
     for update of depacum_valorig, depacum_mejoras, depacum_revtecs;


  BEGIN
    vFecha_proce   := to_date(lpad(to_char(pmes),2,'0')||to_char(pano),'MMYYYY');
    borra_historico_depreciacion(pcompania,pano,pmes);

    FOR reg_activos in c_activos_dep(pcompania,pTipo_dep) loop

      vmeses_duracion  := nvl(reg_activos.meses_duracion,0);

      ---------------------------------------------
      -- Depreciacion Activo por Valor Original
      ---------------------------------------------
      -- Obtiene el valor neto (eliminado el monto de desecho) a depreciar
      vvalor_original     :=  reg_activos.val_original     - reg_activos.desecho;
      vvalor_original_dol := (reg_activos.val_original_dol -
                             (moneda.redondeo((reg_activos.desecho/reg_activos.tipo_cambio),'D')));

      --Variables donde devuelve el monto de la depreciacion por valor original en nominal y en dolares
      vdep_mov_vo     := 0;
      vdep_mov_vo_dol := 0;

      -- Deprecia valor original del activo en nominal
      depreciar(vFecha_proce,        reg_activos.fecha_inicio_dep,
                vmeses_duracion,     reg_activos.metodo_dep,
                vvalor_original,     reg_activos.depacum_valorig_ant,
                vdep_mov_vo,         'P' );

      -- Deprecia valor original del activo en dolares
      depreciar(vFecha_proce,         reg_activos.fecha_inicio_dep,
                vmeses_duracion,      reg_activos.metodo_dep,
                vvalor_original_dol,  reg_activos.depacum_valorig_ant_dol,
                vdep_mov_vo_dol,      'D' );

      -------------------------------------
      -- Mejoras del activo
      -------------------------------------
      --Variables donde devuelve el monto de la depreciacion por mejoras en nominal y en dolares
      vdep_mov_mej      := 0;
      vdep_mov_mej_dol  := 0;

      -- Deprecia las mejoras en nominal
      depreciar(vFecha_proce,         reg_activos.fecha_inicio_dep,
                vmeses_duracion,      reg_activos.metodo_dep,
                reg_activos.mejoras,  reg_activos.depacum_mejoras_ant,
                vdep_mov_mej,         'P' );

      -- Deprecia las mejoras en dolares
      depreciar(vFecha_proce,             reg_activos.fecha_inicio_dep,
                vmeses_duracion,          reg_activos.metodo_dep,
                reg_activos.mejoras_dol,  reg_activos.depacum_mejoras_ant_dol,
                vdep_mov_mej_dol,         'D'  );

      -------------------------------------
      -- Revalorizaciones
      -------------------------------------
      --Variables donde devuelve el monto de la depreciacion por revalorizaciones
      --en nominal y en dolares
      vdep_mov_re       := 0;
      vdep_mov_re_dol   := 0;

      -- Deprecia las revalorizacione en nominal
      depreciar(vFecha_proce,         reg_activos.fecha_inicio_dep,
                vmeses_duracion,      reg_activos.metodo_dep,
                reg_activos.rev_tecs, reg_activos.depacum_revtecs_ant,
                vdep_mov_re,          'P'        );

      -- Deprecia las revalorizacione en dolares
      depreciar(vFecha_proce,             reg_activos.fecha_inicio_dep,
                vmeses_duracion,          reg_activos.metodo_dep,
                reg_activos.rev_tecs_dol, reg_activos.depacum_revtecs_ant_dol,
                vdep_mov_re_dol,          'D'     );

      --Actualiza las depreciaciones acumuladas  y  las depreciaciones en ejercicio
      update arafma
        set  --depacum_valorig   = nvl(depacum_valorig_ant,0) + nvl(vdep_mov_vo,0),
             depacum_valorig   = nvl(depacum_valorig_ant,0) + nvl(vdep_mov_vo,0) + nvl(depacum_vo_inicial,0), ---- se aumenta dep. acum. vo inicial ANR 30/08/2010 para la primera vez
             depacum_mejoras   = nvl(depacum_mejoras_ant,0) + nvl(vdep_mov_mej,0),
             depacum_revtecs   = nvl(depacum_revtecs_ant,0) + nvl(vdep_mov_re,0),
             depre_ejer_vo     = nvl(depre_ejer_vo_ant,0)     + nvl(vdep_mov_vo,0),
             depre_ejer_mej    = nvl(depre_ejer_mej_ant,0)    + nvl(vdep_mov_mej,0),
             depre_ejer_revtec = nvl(depre_ejer_revtec_ant,0) + nvl(vdep_mov_re,0),
             --depacum_valorig_dol = nvl(depacum_valorig_ant_dol,0) + nvl(vdep_mov_vo_dol,0),
             depacum_valorig_dol = nvl(depacum_valorig_ant_dol,0) + nvl(vdep_mov_vo_dol,0)+ nvl(depacum_vo_inicial,0), ---- se aumenta dep. acum. vo inicial ANR 30/08/2010 para la primera vez
             depacum_mejoras_dol = nvl(depacum_mejoras_ant_dol,0) + nvl(vdep_mov_mej_dol,0),
             depacum_revtecs_dol = nvl(depacum_revtecs_ant_dol,0) + nvl(vdep_mov_re_dol,0),
             depre_ejer_vo_dol     = nvl(depre_ejer_vo_ant_dol,0)    + nvl(vdep_mov_vo_dol,0),
             depre_ejer_mej_dol    = nvl(depre_ejer_mej_ant_dol,0)   + nvl(vdep_mov_mej_dol,0),
             depre_ejer_revtec_dol = nvl(depre_ejer_revtec_ant_dol,0)+ nvl(vdep_mov_re_dol,0)
        where rowid = reg_activos.rowid_activo;

      -- Actualiza el historico de depreciaciones
      insert into arafhd(  no_cia, no_acti,
                          tipo_dep, ano, mes,
                          dep_valorig,          dep_mejoras,
                          dep_revtecs,
                          dep_valorig_dol,      dep_mejoras_dol,
                          dep_revtecs_dol,
                          depacum_valorig,      depacum_mejoras,
                          depacum_revtecs,
                          depacum_valorig_dol,  depacum_mejoras_dol,
                          depacum_revtecs_dol,
                          mejoras_acum,         rev_tecs_acum,
                          mejoras_acum_dol,     rev_tecs_acum_dol)
            select no_cia,  no_acti,
                   ptipo_dep, pano, pmes,
                   nvl(vdep_mov_vo,0),     nvl(vdep_mov_mej,0),
                   nvl(vdep_mov_re,0),
                   nvl(vdep_mov_vo_dol,0), nvl(vdep_mov_mej_dol,0),
                   nvl(vdep_mov_re_dol,0),
                   depacum_valorig,        depacum_mejoras,
                   depacum_revtecs,
                   depacum_valorig_dol,    depacum_mejoras_dol,
                   depacum_revtecs_dol,
                   mejoras, rev_tecs,
                   mejoras_dol, rev_tecs_dol
                 from arafma
                where rowid = reg_activos.rowid_activo;
    end loop;

  END calcula;
  --
END depreciacion;
/
