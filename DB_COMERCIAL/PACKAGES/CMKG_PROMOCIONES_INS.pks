CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES_INS AS 

 /**
  * Documentaci�n para PROCESO 'P_PROCESO_MAPEO_PROM_INS'.
  *
  * Proceso encargado de evaluar reglas de configuraci�n de una promoci�n, para ser otorgada a los cliente que su estado de 
  * servicio este factible.
  *
  * Costo del Query C_GetEmpresa: 0
  * Costo del Query C_GetErrorRepetido: 11
  * Costo del Query C_GetInfoServicio: 5
  * Costo del Query C_GetIdPromocion: 16
  *
  * PARAMETROS:
  * @Param Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Mensaje              OUT VARCHAR2
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-09-2019
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 03-09-2020 - Se realiza cambio para que se consuma el nuevo proceso que obtiene los tipos de promociones ordenados
  *                           por prioridad de sectorizaci�n.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.2 10-11-2020 - Se realiza cambio en el proceso para considerar los servicios que tienen como caracter�stica activa un 
  *                           c�digo promocional.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.3  31-05-2022
  * Se agregan logs para monitorear el proceso de mapeo de promociones de Instalacion.
  */ 
  PROCEDURE P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                     Pv_Mensaje              OUT VARCHAR2);

  /**
  * Documentaci�n para TYPE 'Lr_ServClientesProcesar'.
  *  
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE Lr_ServClientesProcesar IS RECORD (
    ID_PERSONA_ROL         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    COD_EMPRESA            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    SERVICIO_ID            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_PLAN                DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE);

  /**
  * Documentaci�n para TYPE 'T_ServClientesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE T_ServClientesProcesar IS TABLE OF Lr_ServClientesProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para PROCEDURE 'P_MAPEO_PROMO_INS'.
  *
  * Proceso encargado de insertar todos los mapeos por la cantidad de periodos configurados en una promoci�n de instalaci�n
  * generar los historiales del servicio, historial de mapeo y mapeo de servicio beneficiado.
  *
  * PARAMETROS:
  * @Param Pr_Punto                IN Lr_ServClientesProcesar
  * @Param Pa_ServiciosCumplePromo IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear
  * @Param Pr_TiposPromociones     IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar
  * @Param Pr_TipoPromoRegla       IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar
  * @Param Pv_TipoProceso          IN VARCHAR2
  * @Param Pv_Trama                IN VARCHAR2
  * @Param Pv_MsjResultado         OUT VARCHAR2
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-09-2019
  */
  PROCEDURE P_MAPEO_PROMO_INS (Pr_Punto                 IN Lr_ServClientesProcesar,
                               Pa_ServiciosCumplePromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear,
                               Pr_TiposPromociones      IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar,
                               Pr_TipoPromoRegla        IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar,
                               Pv_TipoProceso           IN VARCHAR2,
                               Pv_Trama                 IN VARCHAR2,
                               Pv_MsjResultado          OUT VARCHAR2);
END CMKG_PROMOCIONES_INS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PROMOCIONES_INS AS 

  PROCEDURE P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                     Pv_Mensaje              OUT VARCHAR2)
  IS
  
  --Costo: 1
  CURSOR C_GetEmpresa IS
    SELECT IEG.COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
    WHERE IEG.COD_EMPRESA = Pv_CodEmpresa;

  --Costo: 11
  CURSOR C_GetErrorRepetido(Cv_Mensaje VARCHAR2 ) IS
    SELECT 'EXISTE'
    FROM DB_GENERAL.INFO_ERROR
    WHERE DETALLE_ERROR = Cv_Mensaje;

  --Costo: 5
  CURSOR C_GetInfoServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
    SELECT IP.PERSONA_EMPRESA_ROL_ID,
      IP.ID_PUNTO,
      (SELECT ISH.ESTADO 
       FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
       WHERE ISH.ID_SERVICIO_HISTORIAL IN (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) AS ESTADO 
                                           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH 
                                           WHERE DBISH.SERVICIO_ID = ISE.ID_SERVICIO)) AS ESTADO,
      ISE.PLAN_ID
     FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
       DB_COMERCIAL.INFO_PUNTO IP,
       DB_COMERCIAL.INFO_PLAN_CAB IPC
    WHERE IP.ID_PUNTO   = ISE.PUNTO_ID
    AND IPC.ID_PLAN     = ISE.PLAN_ID
    AND ISE.PLAN_ID     IS NOT NULL
    AND ISE.ID_SERVICIO = Cn_IdServicio;

  CURSOR C_GetIdPromocion(Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                          Cv_CodigoGrupoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                          Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                          Cv_EstadoActivo         DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE,
                          Cv_EstadoInactivo       DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE) IS    
    SELECT DISTINCT AGP.ID_GRUPO_PROMOCION, 
      ATP.ID_TIPO_PROMOCION,
      DBAC.ID_CARACTERISTICA,
      ATPR.VALOR AS CODIGO_PROMOCION
    FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
      DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
      DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
      DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
      DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR
    WHERE ISC.SERVICIO_ID                 = Cn_IdServicio
    AND ISC.ESTADO                        = Cv_EstadoActivo
    AND DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Cn_IdServicio,Cv_CodigoGrupoPromocion,Cv_CodEmpresa) = 'S'
    AND DBAC.ID_CARACTERISTICA            = ISC.CARACTERISTICA_ID
    AND DBAC.DESCRIPCION_CARACTERISTICA   = 'PROM_COD_INST'
    AND ATP.ID_TIPO_PROMOCION             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(TRIM(ISC.VALOR),'^\d+')),0)
    AND ATP.ESTADO                        IN (Cv_EstadoActivo,Cv_EstadoInactivo)
    AND AGP.ID_GRUPO_PROMOCION            = ATP.GRUPO_PROMOCION_ID
    AND AGP.EMPRESA_COD                   = Cv_CodEmpresa
    AND AGP.ESTADO                        IN (Cv_EstadoActivo,Cv_EstadoInactivo)
    AND ATPR.TIPO_PROMOCION_ID            = ATP.ID_TIPO_PROMOCION
    AND ATPR.ESTADO                       IN (Cv_EstadoActivo,Cv_EstadoInactivo)
    AND ATPR.CARACTERISTICA_ID            IN (SELECT CARAC.ID_CARACTERISTICA
                                              FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARAC
                                              WHERE CARAC.DESCRIPCION_CARACTERISTICA = 'PROM_CODIGO');

    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo               DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE := 'Activo';
    Lv_EstadoInactivo             DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE := 'Inactivo';
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionTipoPromo         EXCEPTION;
    Lv_Existe                     VARCHAR2(6);
    Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    --Mensaje para el registro de Log de Errores
    Lv_MsjResultado               VARCHAR2(2000);
    Lv_MsjExceptionProceso        VARCHAR2(1000);
    Lv_MsjExceptionTipoPromo      VARCHAR2(1000);
    --Listados 
    Lrf_TiposPromociones          SYS_REFCURSOR;
    --Tipos definidos
    Lr_Punto                      Lr_ServClientesProcesar;
    Lr_TiposPromociones           DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar;
    Lr_GrupoPromoRegla            DB_COMERCIAL.CMKG_PROMOCIONES.Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla             DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    Lr_InfoServicioCaracteristica DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE;

    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear;
    La_SectorizacionProcesar      DB_COMERCIAL.CMKG_PROMOCIONES.T_SectorizacionProcesar;
    Lb_OtorgoPromoCliente         BOOLEAN;
    Lb_CumpleRegla1               BOOLEAN;
    Lb_CumpleRegla2               BOOLEAN;
    Lb_CumpleRegla3               BOOLEAN;
    Lb_CumpleRegla4               BOOLEAN;  
    --Tipo para el BULK
    La_GruposPromocionesProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar;
    La_TiposPromocionesProcesar   DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar;
    Ln_IndGpro                    NUMBER;    
    Ln_IndServ                    NUMBER;
    Ln_idPromocion                DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Ln_idCaracteristica           DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    --Query de consulta del script    
    Lv_Trama                      VARCHAR2(4000);
    Lc_GetInfoServicio            C_GetInfoServicio%ROWTYPE;
    Lc_GetIdPromocion             C_GetIdPromocion%ROWTYPE;
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    Ld_FeEvaluaVigencia           DATE;

  BEGIN
  --
    IF TRIM(Pv_CodigoGrupoPromocion) != 'PROM_INS' THEN
      Lv_MsjExceptionProceso := 'La promoci�n por Instalaci�n solo aplica para el tipo: ' || Pv_CodigoGrupoPromocion || ', servicio_Id - '
                                || Pn_IdServicio;
      RAISE Le_ExceptionProceso;    
    END IF;

    IF DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Pn_IdServicio,Pv_CodigoGrupoPromocion,Pv_CodEmpresa) = 'N' THEN
      Lv_MsjExceptionProceso := 'El servicio ' || Pn_IdServicio || ' ya cuenta con una promoci�n de tipo: '
                                ||Pv_CodigoGrupoPromocion;
      RAISE Le_ExceptionProceso;    
    END IF;
    --
    IF Lrf_TiposPromociones%ISOPEN THEN
      CLOSE Lrf_TiposPromociones;
    END IF;
    --
    IF C_GetErrorRepetido%ISOPEN THEN
      CLOSE C_GetErrorRepetido;
    END IF;
    -- Se recupera C�digo de Empresa 
    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;
    --
    IF C_GetInfoServicio%ISOPEN THEN
      CLOSE C_GetInfoServicio;
    END IF;
    --
    OPEN C_GetEmpresa;
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;
    --
    IF Lv_CodEmpresa IS NULL THEN
    --
      Lv_MsjExceptionProceso := 'No se encuentra definido c�digo de Empresa para el Proceso de Promociones ' 
                                 || Pv_CodigoGrupoPromocion || ' COD_EMPRESA: '||Pv_CodEmpresa;
      RAISE Le_ExceptionProceso;
    --
    END IF;
    --
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         'Inicio Proceso Mapeo Inst.', 
                                         'telcos_log_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
    IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN

      IF C_GetIdPromocion%ISOPEN THEN
        CLOSE C_GetIdPromocion;
      END IF;

      OPEN C_GetIdPromocion(Pn_IdServicio,
                            Pv_CodigoGrupoPromocion,
                            Pv_CodEmpresa,
                            Lv_EstadoActivo,
                            Lv_EstadoInactivo);
      FETCH C_GetIdPromocion INTO Lc_GetIdPromocion;
      CLOSE C_GetIdPromocion;

      IF (Lc_GetIdPromocion.ID_GRUPO_PROMOCION IS NOT NULL AND Lc_GetIdPromocion.ID_GRUPO_PROMOCION > 0) THEN

        Ln_idPromocion      := Lc_GetIdPromocion.ID_GRUPO_PROMOCION;
        Ln_idCaracteristica := Lc_GetIdPromocion.ID_CARACTERISTICA;

      ELSE

        Lv_MsjExceptionProceso := 'No se encontr� c�digo definido para el servicio: ' || Pn_IdServicio || 'del Proceso de Promociones ' 
                                   || Pv_CodigoGrupoPromocion || ' COD_EMPRESA: '||Pv_CodEmpresa;
        RAISE Le_ExceptionProceso;

      END IF;

    END IF;

    --Obtengo consulta de los Puntos Clientes a Procesar por Tipo de Promoci�n, C�digo de empresa, 
    --Tipo de Proceso : Clientes Nuevos o Clientes Existentes.
    
    OPEN C_GetInfoServicio(Pn_IdServicio);
    --
    FETCH C_GetInfoServicio INTO Lc_GetInfoServicio;
    --
    IF C_GetInfoServicio%FOUND THEN
    --
      Ln_IndServ              := 0;
      Lr_Punto                := null;
      Lr_Punto.ID_PERSONA_ROL := Lc_GetInfoServicio.PERSONA_EMPRESA_ROL_ID;
      Lr_Punto.ID_PUNTO       := Lc_GetInfoServicio.ID_PUNTO;
      Lr_Punto.COD_EMPRESA    := Pv_CodEmpresa;
      Lr_Punto.SERVICIO_ID    := Pn_IdServicio;
      Lr_Punto.ESTADO         := Lc_GetInfoServicio.ESTADO;
      Lr_Punto.ID_PLAN        := Lc_GetInfoServicio.PLAN_ID;
      Lv_Trama                := '';   
      Lb_OtorgoPromoCliente   := FALSE;
      La_ServiciosProcesar.DELETE();
      Ld_FeEvaluaVigencia     := NULL;
      Ld_FeEvaluaVigencia     := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_OBTIENE_FECHA_EVAL_VIGENCIA(Lr_Punto.ID_PUNTO,'Factible',Pv_CodigoGrupoPromocion);
      --
      La_TiposPromocionesProcesar.DELETE();
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         'Por obtener Promociones Sect: Id_servicio '||Pn_IdServicio, 
                                         'telcos_log_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
      --Obtengo los Grupos de Promociones que se van a Procesar por c�digo de grupo y empresa que cumplan la fecha de vigencia.
      DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT(Pd_FeEvaluaVigencia     => Ld_FeEvaluaVigencia,
                                                           Pn_IdServicio           => Pn_IdServicio,
                                                           Pn_IdPromocion          => Ln_idPromocion,
                                                           Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                           Pv_CodEmpresa           => Pv_CodEmpresa,
                                                           Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                           Pa_TiposPromoPrioridad  => La_TiposPromocionesProcesar);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         'Promociones a procesar: Cantidad '||La_TiposPromocionesProcesar.COUNT, 
                                         'telcos_log_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
      --
      IF La_TiposPromocionesProcesar.COUNT = 0 THEN
        Lv_MsjExceptionProceso:='No se pudo obtener los Grupos de Promocionales para el Proceso de Mapeo de Promociones. ';
        RAISE Le_ExceptionProceso;
      END IF;
      --
        Ln_IndGpro := La_TiposPromocionesProcesar.FIRST;        
        WHILE (Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente)       
        LOOP
          --Inicio de Bloque para manejo de excepciones por Grupo Promocional
          BEGIN
            Lr_TiposPromociones := La_TiposPromocionesProcesar(Ln_IndGpro);
            Ln_IndGpro          := La_TiposPromocionesProcesar.NEXT(Ln_IndGpro);
            --Limpiamos la Tabla de Sectores
            La_SectorizacionProcesar.DELETE();
            --Obtengo Sectorizaci�n como estructura de tabla por Grupo o por Tipo Promocional
            La_SectorizacionProcesar              := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Lr_TiposPromociones.ID_GRUPO_PROMOCION);
            --  
            Lr_GrupoPromoRegla                    := NULL;
            Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
            --
            --Obtengo Reglas por Tipo Promocional.
            Lr_TipoPromoRegla                     := NULL;
            Lr_TipoPromoRegla                     := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Lr_TiposPromociones.ID_TIPO_PROMOCION);
            --
            IF Lr_TipoPromoRegla.ID_TIPO_PROMOCION IS NULL THEN
            --
              Lv_MsjExceptionTipoPromo := 'Ocurri� un error al obtener las reglas del Tipo Promocional ID_TIPO_PROMOCION: '
                                          ||Lr_TiposPromociones.ID_TIPO_PROMOCION;
              RAISE Le_ExceptionTipoPromo;
            --
            END IF;     
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         'Promocion: Id_GrupoPromocion '||Lr_TiposPromociones.ID_GRUPO_PROMOCION, 
                                         'telcos_log_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
            --       
            --Si se cumplen todas las Reglas Promocionales llamo al procedimiento que genera el Mapeo de Promociones

            Lb_CumpleRegla2 := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                      Fn_IdPunto        => Lc_GetInfoServicio.ID_PUNTO); 
            Lb_CumpleRegla3 := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                        Pn_IdServicio);
            Lb_CumpleRegla4 := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion => Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                        Fn_IdServicio     => Pn_IdServicio,
                                                                                        Fv_CodEmpresa     => Pv_CodEmpresa);

            IF Lb_CumpleRegla2 AND Lb_CumpleRegla3 AND Lb_CumpleRegla4 THEN
              
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         'Cumple todas las reglas', 
                                         'telcos_log_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
              --       
              --Llamo a la Funci�n que construye la Trama de la informaci�n del Cliente en base a las reglas Promocionales evaluadas.
              Lv_Trama := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TRAMA(Fn_IdPunto               => Lc_GetInfoServicio.ID_PUNTO, 
                                                                    Fr_GrupoPromoRegla       => Lr_GrupoPromoRegla, 
                                                                    Fr_TipoPromoRegla        => Lr_TipoPromoRegla,  
                                                                    Fa_ServiciosCumplePromo  => La_ServiciosProcesar,
                                                                    Fa_SectorizacionProcesar => La_SectorizacionProcesar,
                                                                    Fn_IdServicio            => Pn_IdServicio); 
           
              Lv_MsjResultado                                      := NULL;
              La_ServiciosCumplePromo(Ln_IndServ).ID_SERVICIO      := Pn_IdServicio;
              La_ServiciosCumplePromo(Ln_IndServ).ID_PUNTO         := Lc_GetInfoServicio.ID_PUNTO;
              La_ServiciosCumplePromo(Ln_IndServ).ID_PLAN          := Lc_GetInfoServicio.PLAN_ID;
              La_ServiciosCumplePromo(Ln_IndServ).ID_PRODUCTO      := NULL;
              La_ServiciosCumplePromo(Ln_IndServ).PLAN_ID_SUPERIOR := NULL;
              La_ServiciosCumplePromo(Ln_IndServ).ESTADO           := Lc_GetInfoServicio.ESTADO;
            
              P_MAPEO_PROMO_INS (Lr_Punto,
                                 La_ServiciosCumplePromo,
                                 Lr_TiposPromociones,
                                 Lr_TipoPromoRegla,
                                 'NUEVO',
                                 nvl(Lv_Trama,'Sin Trama'),
                                 Lv_MsjResultado);
              --
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         'P_MAPEO_PROMO_INS - Mensaje: '||Lv_MsjResultado, 
                                         'telcos_log_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
              --       
            
              IF Lv_MsjResultado IS NOT NULL THEN
              --
                Lv_MsjExceptionTipoPromo := 'No se pudo generar el mapeo Promocional para el ID_SERVICIO: '||Pn_IdServicio||
                                            ' Grupo Promocional ID_GRUPO_PROMOCION: ' ||Lr_TiposPromociones.ID_GRUPO_PROMOCION||
                                            ' Tipo Promocional ID_TIPO_PROMOCION: ' ||Lr_TiposPromociones.ID_TIPO_PROMOCION||
                                            ' - ' || Lv_MsjResultado;
                RAISE Le_ExceptionTipoPromo; 
              --
              ELSE
                Lb_OtorgoPromoCliente := TRUE;
              END IF;
              --
            END IF;
          --
          EXCEPTION
          WHEN Le_ExceptionTipoPromo THEN
            Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                               || Pv_CodigoGrupoPromocion|| ' - ' ||Lv_MsjExceptionTipoPromo; 

            Lv_Existe       := '';
            OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
            --
            FETCH C_GetErrorRepetido INTO Lv_Existe;
            --
            IF Lv_Existe <> 'EXISTE' THEN

              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                                   Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                   'telcos_mapeo_promo',
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
            END IF;
            CLOSE C_GetErrorRepetido;
            Lv_MsjResultado := NULL;
           --
          END;
        --Fin de Bloque para manejo de excepciones por Grupo Promocional
        --
        END LOOP;--Fin de WHILE (Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente)
      --
    ELSE 
      Lv_MsjExceptionProceso := 'No se encontr� informaci�n del IdServicio: ' || Pn_IdServicio ||
                                ' para el tipo de promoci�n : '|| Pv_CodigoGrupoPromocion;
      RAISE Le_ExceptionProceso;
    END IF;
    CLOSE C_GetInfoServicio;

    IF Lb_OtorgoPromoCliente THEN
      Pv_Mensaje := 'OK';
    ELSE
      Lr_InfoServicioHistorial                       := NULL;
      Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
      Lr_InfoServicioHistorial.SERVICIO_ID           := Pn_IdServicio;
      Lr_InfoServicioHistorial.USR_CREACION          := 'telcos_map_prom';
      Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
      Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
      Lr_InfoServicioHistorial.ESTADO                := Lc_GetInfoServicio.ESTADO;
      Lr_InfoServicioHistorial.MOTIVO_ID             := NULL;
      IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN
        Lr_InfoServicioHistorial.OBSERVACION           := 'El servicio no cumpli� con las reglas de la promoci�n por c�digo, este servicio '||
                                                          'ser� evaluado para las dem�s promociones de instalaci�n sin c�digo.';
      ELSE
        Lr_InfoServicioHistorial.OBSERVACION           := 'El servicio no cumpli� con las reglas de los grupos promocionales, el costo '||
                                                           'de la facturaci�n ser� calculado del valor base.';
      END IF;
      Lr_InfoServicioHistorial.ACCION                := NULL;
      --
      DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,
                                                                 Lv_MsjResultado);

      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
      --
        Lv_MsjExceptionProceso := Lv_MsjResultado;
        RAISE Le_ExceptionProceso;
      --
      END IF;
      Pv_Mensaje := '';
    END IF;

    IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN
      Lr_InfoServicioCaracteristica                     := NULL;
      Lr_InfoServicioCaracteristica.SERVICIO_ID         := Pn_IdServicio;
      Lr_InfoServicioCaracteristica.CARACTERISTICA_ID   := Ln_idCaracteristica;
      Lr_InfoServicioCaracteristica.ESTADO              := 'Inactivo';
      Lr_InfoServicioCaracteristica.USR_ULT_MOD         := 'telcos_map_prom';
      Lr_InfoServicioCaracteristica.IP_ULT_MOD          := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion);
      Lr_InfoServicioCaracteristica.FE_ULT_MOD          := SYSDATE;
      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_UPDATE_CARACTERISTICA_SERV (Lr_InfoServicioCaracteristica, Lv_MsjResultado);
      Lv_MsjResultado                                   := NULL;
    END IF;

  EXCEPTION
  WHEN Le_ExceptionProceso THEN
    --
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de Mapeo de Promociones' || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                                         
    Pv_Mensaje := Lv_MsjResultado;
  WHEN OTHERS THEN
    --
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '||
                        Pv_CodigoGrupoPromocion|| ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                                         
    Pv_Mensaje := Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
  END P_PROCESO_MAPEO_PROM_INS;
  --
  --
  --
  PROCEDURE P_MAPEO_PROMO_INS (Pr_Punto                 IN Lr_ServClientesProcesar,
                               Pa_ServiciosCumplePromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear,
                               Pr_TiposPromociones      IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar,
                               Pr_TipoPromoRegla        IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar,
                               Pv_TipoProceso           IN VARCHAR2,
                               Pv_Trama                 IN VARCHAR2,
                               Pv_MsjResultado          OUT VARCHAR2)
  IS 
    --
    Ld_FechaProcesamiento     DATE           := SYSDATE;
    Lv_DescuentoPeriodo       VARCHAR2(200)  := Pr_TipoPromoRegla.PROM_PERIODO;
    Lv_Nombre                 DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE := Pr_TipoPromoRegla.NOMBRE_GRUPO;
    Lv_TipoCliente            VARCHAR2(20)   := Pv_TipoProceso;
    Lv_CodEmpresa             VARCHAR2(2)    := Pr_Punto.COD_EMPRESA;
    Lv_Estado                 VARCHAR2(15)   := 'Activo';
    Lv_TipoPromo              VARCHAR2(50)   := Pr_TiposPromociones.CODIGO_TIPO_PROMOCION;
    Ln_IdPersonaRol           NUMBER         := Pr_Punto.ID_PERSONA_ROL;
    Ln_IdPunto                NUMBER         := Pr_Punto.ID_PUNTO;
    Ln_IdGrupoPromocion       NUMBER         := Pr_TiposPromociones.ID_GRUPO_PROMOCION;
    Ln_IdTipoPromo            NUMBER         := Pr_TiposPromociones.ID_TIPO_PROMOCION;
    Lc_Trama                  CLOB           := Pv_Trama;
    Lv_IpCreacion             VARCHAR2(16)   := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    La_ServiciosMapear        DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear;
    Ln_Contador               NUMBER;
    Lv_Periodo                VARCHAR2(10);
    Lv_Descuento              VARCHAR2(10);
    Ld_FechaMapeo             DATE;
    Lex_Exception             EXCEPTION;
    Lv_CodigoCiclo            DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE;
    Ld_FechaInicioCiclo       DB_FINANCIERO.ADMI_CICLO.FE_INICIO%TYPE;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE; 
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_UserMapeo              VARCHAR2(20):='telcos_map_prom';
    Ln_IndxServMap            NUMBER;
    Lr_InfoServicioHistorial  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_FechaMapeoTotal        VARCHAR2(5000);
    --
  BEGIN
    --
    Ln_Contador:=0;
    --
    --Obtenemos el ciclo y la fecha de inicio de ciclo.
    DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_CICLO(Ln_IdPersonaRol,
                                              Lv_CodigoCiclo,
                                              Ld_FechaInicioCiclo);
    --
    IF Lv_CodigoCiclo IS NULL  AND Ld_FechaInicioCiclo IS NULL THEN
      Lv_MsjResultado := 'No se encuentra definido C�digo y Fecha de Inicio de Ciclo';
      RAISE Lex_Exception;
    END IF;   
    --
    Lr_InfoDetalleMapeoPromo                          := NULL;
    Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID       := Ln_IdGrupoPromocion;
    Lr_InfoDetalleMapeoPromo.TRAMA                    := Lc_Trama;
    Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID   := Ln_IdPersonaRol;
    Lr_InfoDetalleMapeoPromo.PUNTO_ID                 := Ln_IdPunto;
    Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID        := Ln_IdTipoPromo;
    Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION           := Lv_TipoPromo;
    Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO       := NULL;
    Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS        := NULL;
    Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS         := NULL;
    Lr_InfoDetalleMapeoPromo.TIPO_PROCESO             := Lv_TipoCliente;
    Lr_InfoDetalleMapeoPromo.INVALIDA                 := NULL;
    Lr_InfoDetalleMapeoPromo.INDEFINIDO               := NULL;
    Lr_InfoDetalleMapeoPromo.FE_CREACION              := SYSDATE;
    Lr_InfoDetalleMapeoPromo.USR_CREACION             := Lv_UserMapeo;
    Lr_InfoDetalleMapeoPromo.IP_CREACION              := Lv_IpCreacion;
    Lr_InfoDetalleMapeoPromo.FE_ULT_MOD               := NULL;
    Lr_InfoDetalleMapeoPromo.USR_ULT_MOD              := NULL;
    Lr_InfoDetalleMapeoPromo.IP_ULT_MOD               := NULL;
    Lr_InfoDetalleMapeoPromo.EMPRESA_COD              := Lv_CodEmpresa;
    Lr_InfoDetalleMapeoPromo.ESTADO                   := Lv_Estado;
    --
    --Mapeo para Cliente Nuevo--
      FOR DescuentoPeriodo IN (SELECT REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) SPLIT FROM DUAL
      CONNECT BY REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) IS NOT NULL)
      LOOP
        --
        Lv_Periodo   :=regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 1);
        Lv_Descuento :=regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 2);
        --
        Lr_InfoDetalleMapeoPromo.PORCENTAJE    := Lv_Descuento;
        Lr_InfoDetalleMapeoPromo.PERIODO       := Lv_Periodo;
        --
        IF Ln_Contador=0 THEN
          --
          Ld_FechaMapeo                               := ADD_MONTHS(Ld_FechaProcesamiento, Lv_Periodo-1);--Fecha de Activacion
          Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
          Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeo;
          --
          Lv_FechaMapeoTotal:=Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);
          --
          DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo,
                                                         Pa_ServiciosCumplePromo,
                                                         Lv_MsjResultado); 
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;
          --
        ELSE 
          --
          Ld_FechaMapeo                               := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                                                         TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                                                         TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Lv_Periodo-1);
          Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
          Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeo;
          --
          Lv_FechaMapeoTotal:=Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);
          --
          DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo,
                                                         Pa_ServiciosCumplePromo,
                                                         Lv_MsjResultado); 
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;
          -- 
        END IF;
      --
      Ln_Contador:=Ln_Contador+1;
      --      
      END LOOP;
      --
      Ln_IndxServMap := Pa_ServiciosCumplePromo.FIRST;
      WHILE (Ln_IndxServMap IS NOT NULL)  
      LOOP   
        Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
        Lr_InfoServicioHistorial.SERVICIO_ID            := Pa_ServiciosCumplePromo(Ln_IndxServMap).ID_SERVICIO;
        Lr_InfoServicioHistorial.USR_CREACION           := Lv_UserMapeo;
        Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
        Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
        Lr_InfoServicioHistorial.ESTADO                 := Pa_ServiciosCumplePromo(Ln_IndxServMap).ESTADO;
        Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
        Lr_InfoServicioHistorial.OBSERVACION            := 'Se registr� correctamente el mapeo de la Promoci�n: '
                                                           || Lv_Nombre || ', para el tipo promocional: '
                                                           ||Lv_TipoPromo
                                                           ||', Fecha-Mapeo: '||Lv_FechaMapeoTotal;
        Lr_InfoServicioHistorial.ACCION                 := NULL;
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);
        --
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Lex_Exception;
        END IF;
        --
        Ln_IndxServMap := La_ServiciosMapear.NEXT (Ln_IndxServMap);
        --
      END LOOP;
      --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_MAPEO_PROMO_INS', 
                                         Lv_MsjResultado,
                                         Lv_UserMapeo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    --
    Pv_MsjResultado:= Lv_MsjResultado;
    --
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_INS.P_MAPEO_PROMO_INS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UserMapeo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));   
    --
    Pv_MsjResultado:= 'CMKG_PROMOCIONES_INS.P_MAPEO_PROMO_INS - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
  END P_MAPEO_PROMO_INS;
  --
  --
  --
END CMKG_PROMOCIONES_INS;
/