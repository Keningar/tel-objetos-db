CREATE OR REPLACE package NAF47_TNET.INKG_TRANSFERENCIAS is

  /**
  * Documentacion para NAF47_TNET.INKG_TRANSFERENCIAS.Gr_DetalleTransf
  * Variable Registro que permite pasar por parametro los datos necesarios para procesar transferencias
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/12/2020
  */
  TYPE Gr_DetalleTransf is RECORD
    ( BODEGA_ORIGEN  NAF47_TNET.ARINTE.BOD_ORIG%TYPE,
      BODEGA_DESTINO NAF47_TNET.ARINTE.BOD_DEST%TYPE,
      NO_ARTICULO    NAF47_TNET.ARINTL.NO_ARTI%TYPE,
      CANTIDAD       NAF47_TNET.ARINTL.CANTIDAD%TYPE,
      PEDIDO_DETALLE_ID NAF47_TNET.ARINTL.PEDIDO_DETALLE_ID%TYPE 
    );
  --
  /**
  * Documentacion para NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf
  * Variable Tipo Tabla que permite pasar por parametro detalle de articulos para procesar transferencias
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/12/2020
  */
    TYPE Gt_Detalle_Transf IS TABLE of Gr_DetalleTransf;

  /**
  * Documentacion para P_CREA_TAREA_TRANSFERENCIAS
  * Procedure crea tarea a usuario especifico sobre transferencias pendientes de recibir
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 30/01/2021
  *
  * @param Pv_NoCia          IN VARCHAR2     C�digo que identifica a la empresa de la transferencia
  * @param Pv_ObsInfoDetalle IN VARCHAR2     Detalle de las transferencias pendientes por bodegas
  * @param Pv_Login          IN VARCHAR2     Login sobre el cual se crear� la tarea.
  * @param Pv_MensajeError   IN OUT VARCHAR2 Retorna mensaje de error
  */
  PROCEDURE P_CREA_TAREA_TRANSFERENCIAS ( Pv_NoCia              IN VARCHAR2,
                                          Pv_ObsInfoDetalle     IN VARCHAR2,
                                          Pv_Login              IN VARCHAR2,
                                          Pv_MensajeError       OUT VARCHAR2);
  /**
  * Documentacion para P_NOTIFICACION_TRANSFERENCIA
  * Procedure genera las notificaciones a los usuarios encargados de bodegas a nivel regional, porceso ejecutado desde JOB_NOTIFICA_TRANSFERENCIAS 
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 30/01/2021
  *
  */
  PROCEDURE P_NOTIFICACION_TRANSFERENCIA;


  --
  /**
  * Documentacion para P_SALIDA_BODEGA_ORIGEN
  * Procedure procesa despacho de bodega de bodega origen sin generar ingreso a bodega en transito
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 24/12/2020
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 01/03/2022 - Se agrega validaci�n detalle art�culos procesados.
  *
  * @param Pv_NoDocu       IN VARCHAR2     N�mero de identificaci�n de Transferencia
  * @param Pv_Centro       IN VARCHAR2     C�digo centro distribuci�n a la que pertenece la transferencia
  * @param Pv_NoCia        IN VARCHAR2     C�digo que identifica a la empresa de la transferencia
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje de error
  */
  PROCEDURE P_SALIDA_BODEGA_ORIGEN (Pv_NoDocu       IN VARCHAR2,
                                    Pv_Centro       IN VARCHAR2,
                                    Pv_NoCia        IN VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2);
  --
  /**
  * Documentacion para P_RECIBE_TRANSFERENCIA
  * Procedure procesa Ingreso bodega de bodega destino
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 24/12/2020
  *
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.1 02/09/2022
  * Se agrega reserva para el caso de que el detalle de la transferencia tenga relacionado un pedido 
  *
  * @param Pv_NoDespacho    IN VARCHAR2          N�mero de identificaci�n de despacho bodega de salida
  * @param Pv_Centro        IN VARCHAR2          C�digo centro distribuci�n a la que pertenece la transferencia
  * @param Pt_DetalleTransf IN Gt_Detalle_Transf Detalle de art�culos a procesar.
  * @param Pv_NoCia         IN VARCHAR2          C�digo que identifica a la empresa de la transferencia
  * @param Pv_MensajeError  IN OUT VARCHAR2      Retorna mensaje de error
  */
  PROCEDURE P_RECIBE_TRANSFERENCIA (Pv_NoDespacho    IN VARCHAR2,
                                    Pv_Centro        IN VARCHAR2,
                                    Pv_NoCia         IN VARCHAR2,
                                    Pt_DetalleTransf IN NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf,
                                    Pv_NoDocuRecibe  IN OUT VARCHAR2,
                                    Pv_MensajeError  IN OUT VARCHAR2);
  --
  /**
  * Documentacion para P_RECHAZA_TRANSFERENCIA
  * Procedure crea registro de transferencia hacia bodega origen/da�ados de los articulos rechazados en las transferencia inicial
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 24/12/2020
  *
  * @param Pv_NoDespacho    IN VARCHAR2          N�mero de identificaci�n de despacho bodega de salida
  * @param Pv_Centro        IN VARCHAR2          C�digo centro distribuci�n a la que pertenece la transferencia
  * @param Pt_DetalleTransf IN Gt_Detalle_Transf Detalle de art�culos a procesar.
  * @param Pv_NoCia         IN VARCHAR2          C�digo que identifica a la empresa de la transferencia
  * @param Pv_MensajeError  IN OUT VARCHAR2      Retorna mensaje de error
  */
  PROCEDURE P_RECHAZA_TRANSFERENCIA ( Pv_NoDespacho    IN VARCHAR2,
                                      Pv_NoCia         IN VARCHAR2,
                                      Pt_DetalleTransf IN NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf,
                                      Pv_MotivoRechazo IN VARCHAR2,
                                      Pv_MensajeError  IN OUT VARCHAR2);
                                  
end INKG_TRANSFERENCIAS;
/


CREATE OR REPLACE package body NAF47_TNET.INKG_TRANSFERENCIAS is
  
  PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
  CONTROL_PRESUPUESTO   CONSTANT VARCHAR2(19) := 'CONTROL_PRESUPUESTO';
  ESTADO_ACTIVO         CONSTANT VARCHAR2(6) := 'Activo';
  DIVISION_REGIONAL     CONSTANT VARCHAR2(17) := 'DIVISION_REGIONAL';
  CENTRO_DISTRIBUCION   CONSTANT VARCHAR2(19) := 'CENTRO_DISTRIBUCION';
  HORAS_NOTIFICACION    CONSTANT VARCHAR2(18) := 'HORAS-NOTIFICACION';
  ENCARGADO_REGION      CONSTANT VARCHAR2(16) := 'ENCARGADO-REGION';
  --
  -- cursor que recupera parametros del tipo de traslado
  CURSOR C_DOCUMENTO_TRASLADO ( Cv_TipoMovimiento VARCHAR2,
                                Cv_NoCia          VARCHAR2) IS
    SELECT TIPO_M, 
           FORMULARIO,
           CODIGO_TERCERO
    FROM NAF47_TNET.ARINVTM
    WHERE NO_CIA = Cv_NoCia
    AND MOVIMI = Cv_TipoMovimiento
    AND TRASLA = 'S'
    AND NVL(STAND_BY,'N') = 'N';
  --
  -- recupera los datos del periodo para asignar al nuevo documento
  CURSOR C_DATOS_PERIODO ( Cv_Centro VARCHAR2,
                           Cv_NoCia  VARCHAR2) IS
    SELECT P.ANO_PROCE,
           P.DIA_PROCESO,
           P.MES_PROCE,
           P.SEMANA_PROCE,
           P.INDICADOR_SEM,
           C.CLASE_CAMBIO
      FROM ARINCD P,
           ARCGMC C
     WHERE P.NO_CIA = C.NO_CIA
       AND P.CENTRO = Cv_Centro
       AND P.NO_CIA = Cv_NoCia;
  --
  --
  Gr_Arinme        NAF47_TNET.ARINME%ROWTYPE;
  Gr_Arinmeh       NAF47_TNET.ARINMEH%ROWTYPE;
  Gr_Arinml        NAF47_TNET.ARINML%ROWTYPE;
  Gr_Arinmn        NAF47_TNET.ARINMN%ROWTYPE;
  Gr_DatosPeriodo  C_DATOS_PERIODO%ROWTYPE;
  --
  --
  PROCEDURE P_CREA_TAREA_TRANSFERENCIAS ( Pv_NoCia              IN VARCHAR2,
                                          Pv_ObsInfoDetalle     IN VARCHAR2,
                                          Pv_Login              IN VARCHAR2,
                                          Pv_MensajeError       OUT VARCHAR2)IS
    
    CURSOR C_GRUPOS_PARAMETROS (Cv_NombreParDetalle VARCHAR2,
                                Cv_TipoParametro    VARCHAR2) IS
      SELECT APD.VALOR2
      FROM ADMI_PARAMETRO_DET APD
      WHERE APD.EMPRESA_COD = Pv_NoCia
      AND APD.DESCRIPCION = Cv_NombreParDetalle
      AND APD.VALOR1 = Cv_TipoParametro
      AND APD.ESTADO = ESTADO_ACTIVO
      AND EXISTS (SELECT NULL
                  FROM ADMI_PARAMETRO_CAB APC
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                  AND APC.ESTADO = ESTADO_ACTIVO);
    --
    CURSOR C_PROCESO (Cv_NombreProceso Varchar2)IS
      SELECT ID_PROCESO
      FROM DB_SOPORTE.ADMI_PROCESO
      WHERE NOMBRE_PROCESO = Cv_NombreProceso
      AND ESTADO         = ESTADO_ACTIVO;
    --
    CURSOR C_TAREA(Cv_NombreTarea Varchar2,
                    Cn_ProcesoId   Number)IS
      SELECT ID_TAREA
      FROM DB_SOPORTE.ADMI_TAREA
      WHERE NOMBRE_TAREA = Cv_NombreTarea
      AND PROCESO_ID   = Cn_ProcesoId
      AND ESTADO = ESTADO_ACTIVO;
    --
    CURSOR C_DEPARTAMENTO (Cv_NombreDepartamento Varchar2)IS
      SELECT ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO
      FROM DB_GENERAL.ADMI_DEPARTAMENTO 
      WHERE NOMBRE_DEPARTAMENTO = Cv_NombreDepartamento
      AND EMPRESA_COD = Pv_NoCia;
    --
    CURSOR C_ASIGNADO(Cv_IdentificacionCliente Varchar2) IS
      SELECT ID_PERSONA,NOMBRES|| ' '|| APELLIDOS AS NOMBRE
      FROM DB_COMERCIAL.INFO_PERSONA 
      WHERE IDENTIFICACION_CLIENTE = Cv_IdentificacionCliente;
    --
    CURSOR C_PERSONA_ROL (Cn_PersonaId    Number,
                          Cn_Departamento Number,
                          Cv_Activo      Varchar2 )IS
      SELECT ID_PERSONA_ROL
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL 
      WHERE PERSONA_ID      = Cn_PersonaId 
      AND DEPARTAMENTO_ID = Cn_Departamento
      AND ESTADO          = Cv_Activo;
    --
    CURSOR C_CLASE_DOC(Cv_Activo Varchar2) IS
      SELECT ID_CLASE_DOCUMENTO
      FROM DB_COMUNICACION.ADMI_CLASE_DOCUMENTO
      WHERE NOMBRE_CLASE_DOCUMENTO = 'REQUERIMIENTO INTERNO'
      AND ESTADO = Cv_Activo;
    --
    CURSOR C_FORMA_CONTACTO(Cv_Activo Varchar2) IS
      SELECT ID_FORMA_CONTACTO
      FROM DB_COMUNICACION.ADMI_FORMA_CONTACTO
      WHERE DESCRIPCION_FORMA_CONTACTO = 'Correo Electronico'
      AND ESTADO = Cv_Activo; 
    --
    CURSOR C_EMPRESA IS   
      SELECT NOMBRE_EMPRESA 
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO 
      WHERE COD_EMPRESA = Pv_NoCia;
    --
    CURSOR C_OFICINA_PUNTO IS
      SELECT ID_OFICINA, 
             IOG.EMPRESA_ID,
             APR.CODIGO_INEC_PROVINCIA,
             APR.NOMBRE_PROVINCIA,
             ME.NOMBRE_DEPTO,
             ME.CEDULA,
             ME.MAIL_CIA
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
           DB_GENERAL.ADMI_CANTON ACA,
           DB_GENERAL.ADMI_PROVINCIA APR,
           NAF47_TNET.V_EMPLEADOS_EMPRESAS ME
      WHERE ME.LOGIN_EMPLE = Pv_Login
      AND ACA.PROVINCIA_ID = APR.ID_PROVINCIA
      AND IOG.CANTON_ID  = ACA.ID_CANTON
      AND ME.OFICINA  = IOG.ID_OFICINA;
    --
    Lv_NombreEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.NOMBRE_EMPRESA%TYPE;
    Ln_IdComunicacion     DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE:=0;
    Ln_IdDocumento        DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE:=0;
    Lv_IdFormaContacto    DB_COMUNICACION.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE:=0;
    Lv_IdClaseDoc         DB_COMUNICACION.ADMI_CLASE_DOCUMENTO.ID_CLASE_DOCUMENTO%TYPE:=0;
    Lv_Descripcion        NAF47_TNET.GE_PARAMETROS.DESCRIPCION%TYPE;
    Lv_DescripcionTarea   NAF47_TNET.GE_PARAMETROS.DESCRIPCION%TYPE;
    Ln_IdProceso          DB_SOPORTE.ADMI_PROCESO.ID_PROCESO%TYPE:=0;
    Ln_IdTarea            DB_SOPORTE.ADMI_TAREA.ID_TAREA%TYPE:=0;
    Ln_IdDetalle          DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE:=0;
    Lv_Opcion             DB_SOPORTE.INFO_CRITERIO_AFECTADO.OPCION%TYPE;
    Ln_IdCriterioAfectado DB_SOPORTE.INFO_CRITERIO_AFECTADO.ID_CRITERIO_AFECTADO%TYPE:=0;
    Ln_IdParteAfectada    DB_SOPORTE.INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE:=0;
    Ln_IdPunto            DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE:=0;
    Lv_NombreCliente      DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE;
    Lv_Departamento       DB_GENERAL.ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE;
    Lr_Departamento       C_DEPARTAMENTO%ROWTYPE;
    Lr_DepartamentoAsigna C_DEPARTAMENTO%ROWTYPE;
    Lr_Persona            C_ASIGNADO%ROWTYPE;
    Ln_PersonaRol         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE:=0; 
    Ld_Fecha              Date:= SYSDATE;
    Lv_MensajeError       Varchar2(500);
    Lv_Asunto             Varchar2(150):= 'Nueva Tarea, Transferencias pendientes recepci�n - Actividad #';
    Lr_OficinaPunto       C_OFICINA_PUNTO%ROWTYPE;
    Le_Error              Exception;
    Lv_Asignada           Varchar2(10):='Asignada';
    --
  BEGIN 
    --
    IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
    OPEN C_GRUPOS_PARAMETROS ('TAREA_TRANSFERENCIA_PENDIENTE', 'PROCESO');
    FETCH C_GRUPOS_PARAMETROS INTO Lv_Descripcion;
    CLOSE C_GRUPOS_PARAMETROS;
    --
    IF C_PROCESO%ISOPEN THEN CLOSE C_PROCESO; END IF;
    OPEN C_PROCESO (Lv_Descripcion);
    FETCH C_PROCESO INTO Ln_IdProceso;
    CLOSE C_PROCESO;
    --
    Lv_Descripcion := null;
    --
    IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
    OPEN C_GRUPOS_PARAMETROS ('TAREA_TRANSFERENCIA_PENDIENTE', 'TAREA');
    FETCH C_GRUPOS_PARAMETROS INTO Lv_Descripcion;
    CLOSE C_GRUPOS_PARAMETROS;
    --
    IF C_TAREA%ISOPEN THEN CLOSE C_TAREA; END IF;
    OPEN C_TAREA (Lv_Descripcion, Ln_IdProceso);
    FETCH C_TAREA INTO Ln_IdTarea;
    CLOSE C_TAREA;
    --
    Ln_IdDetalle:= DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL;
    --
    INSERT INTO DB_SOPORTE.INFO_DETALLE 
         ( ID_DETALLE,
           TAREA_ID,
           OBSERVACION,
           PESO_PRESUPUESTADO,
           VALOR_PRESUPUESTADO,
           FE_SOLICITADA,
           FE_CREACION,
           USR_CREACION,
           IP_CREACION)
    VALUES 
         ( Ln_IdDetalle,
           Ln_IdTarea,
           Pv_ObsInfoDetalle,
           0,
           0,
           Ld_Fecha, 
           Ld_Fecha,
           Pv_Login,
           GEK_CONSULTA.F_RECUPERA_IP);
    --
    Lv_Opcion := 'Encargado Regional: '|| Pv_Login  || ' | Transferencias: Pendiente receptar';
    --
    Ln_IdCriterioAfectado:= DB_SOPORTE.SEQ_INFO_CRITERIO_AFECTADO.NEXTVAL;
    --
    INSERT INTO DB_SOPORTE.INFO_CRITERIO_AFECTADO
         ( ID_CRITERIO_AFECTADO,
           DETALLE_ID,
           CRITERIO,
           OPCION,
           USR_CREACION, 
           FE_CREACION, 
           IP_CREACION)
    VALUES 
         ( Ln_IdCriterioAfectado,
           Ln_IdDetalle,
           'Clientes',
           Lv_Opcion,
           Pv_Login,
           Ld_Fecha, 
           GEK_CONSULTA.F_RECUPERA_IP);
     --
     Ln_IdParteAfectada:= DB_SOPORTE.SEQ_INFO_PARTE_AFECTADA.NEXTVAL;
     --
     INSERT INTO DB_SOPORTE.INFO_PARTE_AFECTADA 
          ( ID_PARTE_AFECTADA,
            CRITERIO_AFECTADO_ID,
            DETALLE_ID,
            AFECTADO_ID,
            AFECTADO_NOMBRE,
            AFECTADO_DESCRIPCION, 
            FE_INI_INCIDENCIA,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,TIPO_AFECTADO)
     VALUES 
          ( Ln_IdParteAfectada,
            Ln_IdCriterioAfectado,
            Ln_IdDetalle, 
            Ln_IdPunto,
            Pv_Login,
            Lv_NombreCliente,
            Ld_Fecha,
            Pv_Login,
            Ld_Fecha,
            GEK_CONSULTA.F_RECUPERA_IP,
            'CLIENTE');
    --
    IF C_OFICINA_PUNTO%ISOPEN THEN CLOSE C_OFICINA_PUNTO; END IF;
    OPEN C_OFICINA_PUNTO;
    FETCH C_OFICINA_PUNTO INTO Lr_OficinaPunto;
    CLOSE C_OFICINA_PUNTO;
    --
    Lv_Departamento:= INITCAP(Lr_OficinaPunto.Nombre_Depto);

    IF C_DEPARTAMENTO%ISOPEN THEN CLOSE C_DEPARTAMENTO; END IF;
    OPEN C_DEPARTAMENTO (Lv_Departamento);
    FETCH C_DEPARTAMENTO INTO Lr_Departamento;
    CLOSE C_DEPARTAMENTO;
    --    
    IF C_ASIGNADO%ISOPEN THEN CLOSE C_ASIGNADO; END IF;
    OPEN C_ASIGNADO (Lr_OficinaPunto.Cedula);
    FETCH C_ASIGNADO INTO Lr_Persona;
    CLOSE C_ASIGNADO;
    --
    IF C_PERSONA_ROL%ISOPEN THEN CLOSE C_PERSONA_ROL; END IF;
    OPEN C_PERSONA_ROL (Lr_Persona.Id_Persona, Lr_Departamento.Id_Departamento, ESTADO_ACTIVO);
    FETCH C_PERSONA_ROL INTO Ln_PersonaRol;
    CLOSE C_PERSONA_ROL;
    --
    Lv_Departamento:= INITCAP(Lr_OficinaPunto.Nombre_Depto);
    --   
    IF C_DEPARTAMENTO%ISOPEN THEN CLOSE C_DEPARTAMENTO; END IF;
    OPEN C_DEPARTAMENTO (Lv_Departamento);
    FETCH C_DEPARTAMENTO INTO Lr_DepartamentoAsigna;
    CLOSE C_DEPARTAMENTO;
    --
    INSERT INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION 
         ( ID_DETALLE_ASIGNACION,
           DETALLE_ID,
           ASIGNADO_ID,
           ASIGNADO_NOMBRE,
           REF_ASIGNADO_ID,
           REF_ASIGNADO_NOMBRE,
           MOTIVO,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           PERSONA_EMPRESA_ROL_ID,
           TIPO_ASIGNADO,
           DEPARTAMENTO_ID)
    VALUES
         ( DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL,
           Ln_IdDetalle,
           Lr_Departamento.ID_DEPARTAMENTO ,
           Lr_Departamento.NOMBRE_DEPARTAMENTO, 
           Lr_Persona.ID_PERSONA,
           Lr_Persona.NOMBRE,
           Pv_ObsInfoDetalle,
           Pv_Login,
           Ld_Fecha,
           GEK_CONSULTA.F_RECUPERA_IP,
           Ln_PersonaRol,
           'Empleado',
           Lr_DepartamentoAsigna.ID_DEPARTAMENTO);
    --
    INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO 
         ( ID_SEGUIMIENTO,
           DETALLE_ID,
           OBSERVACION,
           USR_CREACION,
           FE_CREACION,
           EMPRESA_COD,
           ESTADO_TAREA,
           DEPARTAMENTO_ID,
           PERSONA_EMPRESA_ROL_ID)
    VALUES 
         ( DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, 
           Ln_IdDetalle,
           'Tarea fue Asignada a '||Lr_Departamento.Nombre_Departamento,
           Pv_Login,
           Ld_Fecha, 
           Pv_NoCia,
           Lv_Asignada,
           Lr_Departamento.ID_DEPARTAMENTO,
           Ln_PersonaRol);
    --
    INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL 
         ( ID_DETALLE_HISTORIAL, 
           DETALLE_ID, 
           OBSERVACION, 
           ESTADO,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           ASIGNADO_ID,
           PERSONA_EMPRESA_ROL_ID,
           DEPARTAMENTO_ORIGEN_ID,
           DEPARTAMENTO_DESTINO_ID,
           ACCION)
    VALUES
         ( DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,
           Ln_IdDetalle,
           'Tarea fue Asignada a '||Lr_Departamento.Nombre_Departamento,
           Lv_Asignada,
           Pv_Login, 
           Ld_Fecha,
           GEK_CONSULTA.F_RECUPERA_IP,
           Lr_Departamento.ID_DEPARTAMENTO,
           Ln_PersonaRol,
           Lr_DepartamentoAsigna.ID_DEPARTAMENTO, 
           Lr_Departamento.ID_DEPARTAMENTO,
           Lv_Asignada);
    --
    IF C_CLASE_DOC%ISOPEN THEN CLOSE C_CLASE_DOC; END IF;
    OPEN C_CLASE_DOC(ESTADO_ACTIVO);
    FETCH C_CLASE_DOC INTO Lv_IdClaseDoc;
    CLOSE C_CLASE_DOC;
    --
    Ln_IdDocumento:= DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO
         ( ID_DOCUMENTO,
           CLASE_DOCUMENTO_ID,
           NOMBRE_DOCUMENTO,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           ESTADO,
           MENSAJE,
           EMPRESA_COD)
    VALUES 
         ( Ln_IdDocumento,
           Lv_IdClaseDoc,
           'Registro de tarea',
           Pv_Login,
           Ld_Fecha,
           GEK_CONSULTA.F_RECUPERA_IP,
           ESTADO_ACTIVO,
           Pv_ObsInfoDetalle,
           Pv_NoCia);
    --
    IF C_FORMA_CONTACTO%ISOPEN THEN CLOSE C_FORMA_CONTACTO; END IF;
    OPEN C_FORMA_CONTACTO(ESTADO_ACTIVO);
    FETCH C_FORMA_CONTACTO INTO Lv_IdFormaContacto;
    CLOSE C_FORMA_CONTACTO;
    --
    Ln_IdComunicacion:= DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL;
    INSERT INTO DB_COMUNICACION.INFO_COMUNICACION 
         ( ID_COMUNICACION,
           FORMA_CONTACTO_ID,
           DETALLE_ID,
           CLASE_COMUNICACION,
           FECHA_COMUNICACION,
           ESTADO,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           EMPRESA_COD)
    VALUES( Ln_IdComunicacion,
            Lv_IdFormaContacto,
            Ln_IdDetalle,
            'Recibido',
            Ld_Fecha,
            ESTADO_ACTIVO,
            Pv_Login,
            Ld_Fecha,
            GEK_CONSULTA.F_RECUPERA_IP,
            Pv_NoCia);
    --
    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION
    VALUES 
         ( DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL,
           Ln_IdDocumento,
           Ln_IdComunicacion,
           ESTADO_ACTIVO,
           Pv_Login,
           Ld_Fecha,
           GEK_CONSULTA.F_RECUPERA_IP);
    --
    Lv_Asunto:= Lv_Asunto|| Ln_IdComunicacion; 
    --
    IF C_EMPRESA%ISOPEN THEN CLOSE C_EMPRESA; END IF;
    OPEN C_EMPRESA;
    FETCH C_EMPRESA INTO Lv_NombreEmpresa;
    CLOSE C_EMPRESA;  
    --
    NAF47_TNET.GEKG_TRANSACCION.P_ENVIA_MAIL_TAREA(Ln_IdComunicacion,
                                                   Lv_DescripcionTarea,
                                                   Ld_Fecha,
                                                   Lr_DepartamentoAsigna.Nombre_Departamento||' - '||Lr_Persona.NOMBRE ,
                                                   Lr_Persona.NOMBRE ,                                                  
                                                   Pv_ObsInfoDetalle ,
                                                   Lv_NombreEmpresa ,
                                                   Lr_OficinaPunto.Mail_Cia,
                                                   Lv_Asunto,
                                                   Lv_MensajeError);
    --
    IF Lv_MensajeError IS NOT NULL THEN
      Pv_MensajeError:=Lv_MensajeError;
    END IF;
    --
 EXCEPTION 
   WHEN Le_Error THEN     
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'INKG_TRANSFERENCIA.P_CREA_TAREA_TRANSFERENCIAS',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;    
   WHEN OTHERS THEN
        Pv_MensajeError := SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'INKG_TRANSFERENCIA.P_CREA_TAREA_TRANSFERENCIAS',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;    
  END P_CREA_TAREA_TRANSFERENCIAS;
  --
  --
  PROCEDURE P_NOTIFICACION_TRANSFERENCIA IS
    --
    CURSOR C_REGION IS
      SELECT APD.ID_PARAMETRO_DET NO_REGION
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE DESCRIPCION = DIVISION_REGIONAL
      AND ESTADO = ESTADO_ACTIVO
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID 
                  AND APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO
                  AND APC.ESTADO = ESTADO_ACTIVO );
    --
    CURSOR C_JEFE_BODEGA (Cv_RegionId VARCHAR2,
                          Cv_NoCia    VARCHAR2) IS
      SELECT APD.VALOR3 LOGIN_EMPLEADO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = ENCARGADO_REGION
      AND APD.VALOR2 = Cv_RegionId
      AND APD.EMPRESA_COD = Cv_NoCia
      AND APD.ESTADO = ESTADO_ACTIVO
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID 
                  AND APC.ESTADO = ESTADO_ACTIVO
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS);
    --
    CURSOR C_VALIDAR_HORAS IS
      SELECT APD.EMPRESA_COD AS NO_CIA,
             VALOR1 AS RANGO_INI,
             VALOR2 AS RANGO_FIN
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = HORAS_NOTIFICACION
      AND APD.ESTADO = ESTADO_ACTIVO
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID 
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                  AND APC.ESTADO = ESTADO_ACTIVO);    
    --
    CURSOR C_TRANSFERENCIAS_PENDIENTES ( Cn_RangoHorasIni NUMBER,
                                         Cn_RangoHorasFin NUMBER,
                                         Cv_RegionId      VARCHAR2,
                                         Cv_NoCia         VARCHAR2 ) IS
      SELECT TE.BOD_DEST,
             BO.DESCRIPCION,
             COUNT(NO_DOCU) CANTIDAD
      FROM NAF47_TNET.ARINBO BO,
           NAF47_TNET.ARINTE TE
      WHERE TE.NO_CIA = Cv_NoCia
      AND TE.ESTADO = 'T'
      AND TE.HORAS_NOTIFICACION = Cn_RangoHorasIni
      AND TRUNC((SYSDATE - TE.FE_ULT_NOTIFICACION) * 24) > Cn_RangoHorasFin
      AND EXISTS (SELECT NULL
                    FROM NAF47_TNET.ARINTL TL
                    WHERE TL.NO_DOCU = TE.NO_DOCU
                    AND TL.NO_CIA = TE.NO_CIA
                    AND TL.SALDO > 0)
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                  WHERE APD.DESCRIPCION = CENTRO_DISTRIBUCION
                  AND APD.VALOR2 = Cv_RegionId
                  AND APD.VALOR3 = BO.CENTRO
                  AND APD.EMPRESA_COD = BO.NO_CIA
                  AND APD.ESTADO = ESTADO_ACTIVO
                  AND EXISTS (SELECT NULL
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                              WHERE APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                              AND APC.ID_PARAMETRO = APD.PARAMETRO_ID
                              AND APC.ESTADO = ESTADO_ACTIVO
                             )
                  )
      AND TE.BOD_DEST = BO.CODIGO
      AND TE.NO_CIA = BO.NO_CIA
      GROUP BY TE.BOD_DEST,
               BO.DESCRIPCION;
    --
    Lr_JefeBodega   C_JEFE_BODEGA%ROWTYPE;
    Lv_MensajeError VARCHAR2(3000);
    Lv_ObsInfoDetalle VARCHAR2(3000);
    --
  BEGIN
    --
    -- lectura de las regiones habilitadas
    FOR Lr_Region IN C_REGION LOOP
      --
      -- lectura de las rango de horas configuradas por empresa y region a validar
      FOR Lr_Horas IN C_VALIDAR_HORAS LOOP
        -- Se recupera usuario encargado regional de bodega para envios de solicitudes
        IF C_JEFE_BODEGA%ISOPEN THEN
          CLOSE C_JEFE_BODEGA;
        END IF;
        OPEN C_JEFE_BODEGA(Lr_Region.No_Region,
                           Lr_Horas.No_Cia);

        FETCH C_JEFE_BODEGA INTO Lr_JefeBodega;
        CLOSE C_JEFE_BODEGA;
        --
        IF Lr_JefeBodega.Login_Empleado IS NULL THEN
          --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                               'GEK_TRANSFERENCIA.P_NOTIFICACION_TRANSFERENCIA',
                                               'No se ha definido Jefe Regional de Bodega para empresa: '||Lr_Horas.No_Cia||', region: '||Lr_Region.No_Region||'. No es posible generar notificaci�n.',
                                               GEK_CONSULTA.F_RECUPERA_LOGIN,
                                               SYSDATE,
                                               GEK_CONSULTA.F_RECUPERA_IP);

          GOTO ET_SIGUIENTE_REGISTRO_HORAS;
          --
        END IF;
        --
        -- transferencias pendientes de notificar de acuerdo a rangos de horas, region y empresa
        FOR Lr_Transf IN C_TRANSFERENCIAS_PENDIENTES ( Lr_Horas.Rango_Ini,
                                                       Lr_Horas.Rango_Fin,
                                                       Lr_Region.No_Region,
                                                       Lr_Horas.No_Cia) LOOP
          --
          IF Lv_ObsInfoDetalle IS NULL THEN
            Lv_ObsInfoDetalle := 'Las siguientes bodegas tiene transferencias pendientes de recibir que superas las '||Lr_Horas.Rango_Fin||' horas: '||
                                 CHR(13)||Lr_Transf.Descripcion||'['||Lr_Transf.Bod_Dest||']: '||Lr_Transf.Cantidad;
          ELSE
            Lv_ObsInfoDetalle := SUBSTR(Lv_ObsInfoDetalle||CHR(13)||Lr_Transf.Descripcion||'['||Lr_Transf.Bod_Dest||']: '||Lr_Transf.Cantidad,1,3000);
          END IF;
          --
        END LOOP;
        --
        IF Lv_ObsInfoDetalle IS NULL THEN
          GOTO ET_SIGUIENTE_REGISTRO_HORAS;
        END IF;
        --
        P_CREA_TAREA_TRANSFERENCIAS ( Lr_Horas.No_Cia,
                                      Lv_ObsInfoDetalle,
                                      Lr_JefeBodega.Login_Empleado,
                                      Lv_MensajeError);
        --
        IF Lv_MensajeError IS NOT NULL THEN
          -- Se registra el error y debe cintinuar generando notificaciones para las demas regiones.
          GOTO ET_SIGUIENTE_REGISTRO;
        END IF;
        -- se actualiza horas y ultima notificacion
        UPDATE NAF47_TNET.ARINTE TE
        SET TE.HORAS_NOTIFICACION = Lr_Horas.Rango_Fin,
            TE.FE_ULT_NOTIFICACION = SYSDATE
        WHERE TE.NO_CIA = Lr_Horas.No_Cia
        AND TE.ESTADO = 'T'
        AND TE.HORAS_NOTIFICACION = Lr_Horas.Rango_Ini
        AND TRUNC((SYSDATE - TE.FE_ULT_NOTIFICACION) * 24) > Lr_Horas.Rango_Fin
        AND EXISTS (SELECT NULL
                      FROM NAF47_TNET.ARINTL TL
                      WHERE TL.NO_DOCU = TE.NO_DOCU
                      AND TL.NO_CIA = TE.NO_CIA
                      AND TL.SALDO > 0)
        AND EXISTS (SELECT NULL
                    FROM NAF47_TNET.ARINBO BO
                    WHERE BO.CODIGO = TE.BOD_DEST
                    AND BO.NO_CIA = TE.NO_CIA
                    AND EXISTS (SELECT NULL
                                FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                WHERE APD.DESCRIPCION = CENTRO_DISTRIBUCION
                                AND APD.VALOR2 = Lr_Region.No_Region
                                AND APD.VALOR3 = BO.CENTRO
                                AND APD.EMPRESA_COD = BO.NO_CIA
                                AND APD.ESTADO = ESTADO_ACTIVO
                                AND EXISTS (SELECT NULL
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                            WHERE APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                                            AND APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                            AND APC.ESTADO = ESTADO_ACTIVO
                                           )
                                )                      
                   );

        --
        <<ET_SIGUIENTE_REGISTRO_HORAS>>
        Lv_ObsInfoDetalle := NULL;
        Lr_JefeBodega := NULL;
        --
      END LOOP;
      --
      <<ET_SIGUIENTE_REGISTRO>>
      Lr_JefeBodega := NULL;
      Lv_ObsInfoDetalle := NULL;
      --
    END LOOP;
    --
    commit;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Lv_MensajeError := 'Error en GEK_TRANSFERENCIA.P_NOTIFICACION_TRANSFERENCIA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'GEK_TRANSFERENCIA.P_NOTIFICACION_TRANSFERENCIA',
                                              Lv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;    
  END P_NOTIFICACION_TRANSFERENCIA;
  --
  --
  PROCEDURE P_SALIDA_BODEGA_ORIGEN (Pv_NoDocu       IN VARCHAR2,
                                    Pv_Centro       IN VARCHAR2,
                                    Pv_NoCia        IN VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_DOCUMENTO IS
      SELECT TE.NO_DOCU,
             TE.BOD_ORIG,
             TE.BOD_DEST,
             TE.FECHA,
             TE.PERIODO,
             TE.INTERFAZ,
             'C' AS TIPO_CAMBIO,
             TE.OBSERV1,
             NVL(BD.MAL_ESTADO,'N') AS ES_MAL_ESTADO_BD
      FROM NAF47_TNET.ARINBO BD,
           NAF47_TNET.ARINTE TE
      WHERE TE.NO_DOCU = Pv_NoDocu
      AND TE.CENTRO = Pv_Centro
      AND TE.NO_CIA = Pv_NoCia
      AND TE.BOD_DEST = BD.CODIGO
      AND TE.NO_CIA = BD.NO_CIA;
    --
    CURSOR C_TOTAL_LINEAS IS 
      SELECT L.CANTIDAD, 
             L.NO_ARTI, 
             L.BOD_ORIG
      FROM NAF47_TNET.ARINTL L
      WHERE L.NO_CIA = Pv_NoCia
      AND L.CENTRO = Pv_Centro
      AND L.NO_DOCU  = Pv_NoDocu
      AND NVL(L.CANTIDAD,0) > 0;  
    --
    CURSOR C_ARTICULO_BODEGA (Cv_NoArti VARCHAR2,
                              Cv_Bodega VARCHAR2,
                              Cv_No_Cia VARCHAR2) IS
      SELECT MA.COSTO_UNI, 
             MA.AFECTA_COSTO
      FROM NAF47_TNET.ARINMA MA
      WHERE MA.NO_CIA = Cv_No_Cia
      AND MA.BODEGA = Cv_Bodega
      AND MA.NO_ARTI = Cv_NoArti;
    --
    CURSOR C_DETALLE_DOCUMENTO ( Cv_NoDocu        VARCHAR2,
                                 Cv_BodegaOrigen  VARCHAR2,    
                                 Cv_BodegaDestino VARCHAR2,    
                                 Cv_Periodo       VARCHAR2,    
                                 Cv_Centro        VARCHAR2,    
                                 Cv_NoCia         VARCHAR2 ) IS
      SELECT TL.NO_ARTI,
             TL.CLASE, 
             TL.CATEGORIA,
             NVL(TL.CANTIDAD,0) AS CANTIDAD,
             DA.GRUPO GRUPO_COSTO,   
             TL.NO_DOCU,
             DA.COSTO_ESTANDAR,
             DA.ULTIMO_COSTO, 
             DA.ULTIMO_COSTO2,
             DA.IND_LOTE,
             DA.IND_REQUIERE_SERIE,
             NVL(DA.APLICA_GARANTIA,'N') AS APLICA_GARANTIA,
             (SELECT METODO_COSTO
              FROM GRUPOS
              WHERE NO_CIA  = DA.NO_CIA
              AND GRUPO   = DA.GRUPO) AS METODO_COSTO
      FROM NAF47_TNET.ARINDA DA, 
           NAF47_TNET.ARINTL TL
       WHERE TL.NO_DOCU = Cv_NoDocu  
       AND TL.BOD_ORIG = Cv_BodegaOrigen  
       AND TL.BOD_DEST = Cv_BodegaDestino  
       AND TL.PERIODO = Cv_Periodo  
       AND TL.CENTRO = Cv_Centro  
       AND TL.NO_CIA = Cv_NoCia  
       AND NVL(TL.CANTIDAD,0) > 0 
       AND DA.NO_CIA = TL.NO_CIA 
       AND DA.NO_ARTI = TL.NO_ARTI ;
    --
    CURSOR C_SERIES_INCONSISTENTE IS
      SELECT A.SERIE
      FROM NAF47_TNET.INV_NUMERO_SERIE A
      WHERE A.COMPANIA = Pv_noCia
      AND A.ESTADO = 'FB'
      AND EXISTS (SELECT NULL 
                       FROM INV_PRE_INGRESO_NUMERO_SERIE B
                      WHERE B.SERIE = A.SERIE
                        AND B.NO_ARTICULO = A.NO_ARTICULO
                        AND B.COMPANIA = A.COMPANIA
                        AND B.NO_DOCUMENTO = Pv_NoDocu);
    --
    --
    Lr_Arinte        C_DOCUMENTO%ROWTYPE;
    Lr_TipoDocSalida C_DOCUMENTO_TRASLADO%ROWTYPE;
    Gr_ArticuloBodeg C_ARTICULO_BODEGA%ROWTYPE;
    --
    Ln_Total         NUMBER;       
    Ln_CostoArticulo NUMBER:=0;
    Ln_CostoTotal    NUMBER:=0;
    Ld_FechaAux      DATE;
    --
    Ln_TotalDocumento  NUMBER := 0;
    Ln_TotalDocumento2 NUMBER := 0;
    --
    Le_Error         EXCEPTION;
    --
  BEGIN
    --
    IF C_DOCUMENTO%ISOPEN THEN
      CLOSE C_DOCUMENTO;
    END IF;
    OPEN C_DOCUMENTO;
    FETCH C_DOCUMENTO INTO Lr_Arinte;
    IF C_DOCUMENTO%NOTFOUND THEN
      Lr_Arinte := NULL;
    END IF;
    CLOSE C_DOCUMENTO;
    --
    --
    FOR J IN C_TOTAL_LINEAS LOOP
      --
      Ln_CostoArticulo := articulo.costo(Pv_NoCia, j.no_arti, j.bod_orig);
      Ln_CostoTotal :=  Ln_CostoTotal + (j.cantidad * Ln_CostoArticulo);                     
      --
    END LOOP;
    --
    Ln_Total := Ln_CostoTotal;
    --
    UPDATE NAF47_TNET.ARINTE 
    SET TOTAL_LINEAS = nvl(Ln_Total,0)             
    WHERE NO_CIA  = Pv_NoCia 
    AND NO_DOCU = Pv_NoDocu;
    --
    -- A�adir proceso por Transferencia de Consignaci�n
    -- INCONSIGNACION.PU_VALIDAR se corre al inicio ya que ACTUALIZA pone 
    -- en 0 el detalle de ARINTL
    IF NVL(Lr_Arinte.Interfaz,'X') = 'CS'  THEN
      --
      NAF47_TNET.INCONSIGNACION.PU_VALIDAR( Pv_NoDocu, 
                                            Pv_NoCia,
                                            Pv_Centro, 
                                            Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END IF;
    --
    -- Actualizar el Tota_lineas de arinte            
    --  ACTUALIZA(:uno.no_cia,:uno.centro,:uno.periodo,:uno.no_docu,p_error);
    --
    NAF47_TNET.MONEDA.INICIALIZA(Pv_NoCia);
    --
        -- se recuperan parametros para asignar a documentos inventarios.
    IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
    OPEN C_DATOS_PERIODO (Pv_Centro,
                          Pv_NoCia);
    FETCH C_DATOS_PERIODO INTO Gr_DatosPeriodo;
    IF C_DATOS_PERIODO%NOTFOUND THEN
      Pv_MensajeError := 'La definici�n del calendario del inventario es incorrecta.';
      RAISE Le_Error;
    END IF;
    CLOSE C_DATOS_PERIODO;
    --
    --
    Gr_Arinme.Tipo_Cambio := NAF47_TNET.TIPO_CAMBIO( Gr_DatosPeriodo.Clase_Cambio, 
                                                     Lr_Arinte.Fecha, 
                                                     Ld_FechaAux, 
                                                     Lr_Arinte.Tipo_Cambio);
    --

    --
    -- Se recupetra tipo de documento salida
    IF C_DOCUMENTO_TRASLADO%ISOPEN THEN
      CLOSE C_DOCUMENTO_TRASLADO;
    END IF;
    OPEN C_DOCUMENTO_TRASLADO ('S', Pv_NoCia);
    FETCH C_DOCUMENTO_TRASLADO INTO Lr_TipoDocSalida;
    IF C_DOCUMENTO_TRASLADO%NOTFOUND THEN
      Lr_TipoDocSalida := NULL;
    END IF;
    CLOSE C_DOCUMENTO_TRASLADO;
    --
    IF Lr_TipoDocSalida.Tipo_m IS NULL THEN
      Pv_MensajeError := 'No se ha definido tipo de documento Traslado Salida';
      Raise Le_Error;
    ELSIF Lr_TipoDocSalida.Formulario IS NULL THEN
      Pv_MensajeError := 'El documento de traslado de salida no tiene formulario asociado.';
      Raise Le_Error;
    END IF;
    --
    -- se valida si existen inconistencias
    FOR A IN C_SERIES_INCONSISTENTE LOOP
      IF Pv_mensajeError IS NULL THEN
        Pv_mensajeError := A.SERIE;
      ELSE
        Pv_mensajeError := A.SERIE||', '||Pv_mensajeError;
      END IF;
    END LOOP;
    --
    IF Pv_mensajeError IS NOT NULL THEN
      Pv_mensajeError := 'Se encontraron series en estado [FB] Fuera Bodega: '||Pv_mensajeError;
      Raise Le_Error;
    END IF;
    --
    Gr_Arinme.No_Cia := Pv_NoCia;
    Gr_Arinme.Centro := Pv_Centro;
    Gr_Arinme.Tipo_Doc := Lr_TipoDocSalida.Tipo_m;
    Gr_Arinme.No_Docu := Pv_NoDocu;
    Gr_Arinme.No_Fisico := NAF47_TNET.CONSECUTIVO.INV( Gr_Arinme.No_Cia, 
                                                       Gr_DatosPeriodo.ano_proce, 
                                                       Gr_DatosPeriodo.mes_proce, 
                                                       Gr_Arinme.Centro, 
                                                       Gr_Arinme.Tipo_Doc, 
                                                       'NUMERO');
    Gr_Arinme.Serie_Fisico := NAF47_TNET.CONSECUTIVO.INV( Gr_Arinme.No_Cia, 
                                                          Gr_DatosPeriodo.ano_proce, 
                                                          Gr_DatosPeriodo.mes_proce, 
                                                          Gr_Arinme.Centro, 
                                                          Gr_Arinme.Tipo_Doc, 
                                                          'SERIE');
    Gr_Arinme.Periodo := Lr_Arinte.Periodo;
    Gr_Arinme.Fecha := Lr_Arinte.Fecha;
    Gr_Arinme.Observ1 := Lr_Arinte.Observ1;
    Gr_Arinme.Ruta := '0000';
    Gr_Arinme.Estado := 'D';
    Gr_Arinme.Origen := 'IN';
    Gr_Arinme.Id_Bodega := Lr_Arinte.Bod_Orig;
    --
    NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINME (Gr_Arinme, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    -- se asigna data para registrar historico de movimientos
    Gr_Arinmeh.no_cia := Gr_Arinme.No_Cia;
    Gr_Arinmeh.centro := Gr_Arinme.Centro;
    Gr_Arinmeh.tipo_doc := Gr_Arinme.Tipo_Doc;
    Gr_Arinmeh.periodo := Gr_Arinme.Periodo;
    Gr_Arinmeh.ruta := Gr_Arinme.Ruta;
    Gr_Arinmeh.no_docu := Gr_Arinme.No_Docu;
    Gr_Arinmeh.fecha := Gr_Arinme.Fecha;
    Gr_Arinmeh.observ1 := Gr_Arinme.Observ1;
    Gr_Arinmeh.tipo_cambio := Gr_Arinme.Tipo_Cambio;
    Gr_Arinmeh.no_fisico := Gr_Arinme.No_Fisico;
    Gr_Arinmeh.serie_fisico := Gr_Arinme.Serie_Fisico;
    Gr_Arinmeh.tipo_refe := Gr_Arinme.Tipo_Refe;
    Gr_Arinmeh.no_docu_refe := Gr_Arinme.No_Docu_Refe;
    Gr_Arinmeh.mes := Gr_DatosPeriodo.mes_proce;
    Gr_Arinmeh.semana := Gr_DatosPeriodo.semana_proce;
    Gr_Arinmeh.ind_sem := Gr_DatosPeriodo.indicador_sem;
    --
    NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINMEH (Gr_Arinmeh, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    -- Se inicializa datos fijos de tabla detalle
    Gr_Arinml.no_cia := Gr_Arinme.No_Cia;
    Gr_Arinml.centro := Gr_Arinme.Centro;
    Gr_Arinml.tipo_doc := Gr_Arinme.Tipo_Doc;
    Gr_Arinml.periodo := Gr_Arinme.Periodo;
    Gr_Arinml.ruta := Gr_Arinme.Ruta;
    Gr_Arinml.no_docu := Gr_Arinme.No_Docu;
    Gr_Arinml.Time_Stamp := sysdate;
    Gr_Arinml.linea := 0;
    Gr_Arinml.linea_ext := 0;
    --
    -- Se inicializa datos fijos de tabla detalle kardex
    Gr_Arinmn.no_cia := Gr_Arinme.No_Cia;
    Gr_Arinmn.centro := Gr_Arinme.Centro;
    Gr_Arinmn.tipo_doc := Gr_Arinme.Tipo_Doc;
    Gr_Arinmn.Periodo_Proce := TO_CHAR((Gr_DatosPeriodo.ano_proce*100)+Gr_DatosPeriodo.semana_proce) || Gr_DatosPeriodo.indicador_sem;
    Gr_Arinmn.ruta := Gr_Arinme.Ruta;
    Gr_Arinmn.no_docu := Gr_Arinme.No_Docu;
    Gr_Arinmn.No_Linea := 0;
    Gr_Arinmn.Ano := Gr_Arinme.Periodo;
    Gr_Arinmn.mes := Gr_DatosPeriodo.mes_proce;     
    Gr_Arinmn.semana := Gr_DatosPeriodo.semana_proce;
    Gr_Arinmn.Fecha := Gr_Arinme.Fecha;
    Gr_Arinmn.Time_stamp := Gr_Arinml.Time_Stamp;
      
    -- se procesan linea detalle de documento
    FOR Lr_DetalleDoc IN C_DETALLE_DOCUMENTO ( Lr_Arinte.No_Docu,
                                               Lr_Arinte.Bod_Orig,
                                               Lr_Arinte.Bod_Dest,
                                               Lr_Arinte.Periodo,
                                               Pv_Centro,
                                               Pv_NoCia ) LOOP
      --
      IF C_ARTICULO_BODEGA%ISOPEN THEN
        CLOSE C_ARTICULO_BODEGA;
      END IF;
      OPEN C_ARTICULO_BODEGA( Lr_DetalleDoc.No_Arti,
                              Lr_Arinte.Bod_Orig,
                              Pv_NoCia);
      FETCH C_ARTICULO_BODEGA INTO Gr_ArticuloBodeg;
      IF C_ARTICULO_BODEGA%NOTFOUND THEN
        Gr_ArticuloBodeg := NULL;
      END IF;
      CLOSE C_ARTICULO_BODEGA;
      --
      IF Gr_ArticuloBodeg.Costo_Uni IS NULL THEN
        Pv_MensajeError := 'El art�culo '||Lr_DetalleDoc.No_Arti||' no existe en la bodega ORIGEN: '||Lr_Arinte.Bod_Orig;
        Raise Le_Error;
      END IF;
      --
      --
      Gr_Arinml.linea := NVL(Gr_Arinml.linea,0) + 1;
      Gr_Arinml.linea_ext := NVL(Gr_Arinml.linea_ext,0) + 1;
      --
      Gr_Arinml.bodega := Gr_Arinme.Id_Bodega;
      Gr_Arinml.no_arti := Lr_DetalleDoc.No_Arti;
      Gr_Arinml.unidades := Lr_DetalleDoc.Cantidad;
      --
      IF Lr_DetalleDoc.Metodo_Costo = 'P' THEN
        Gr_Arinmn.Costo_Uni := nvl(Gr_ArticuloBodeg.Costo_Uni,0);
      ELSE
        IF Lr_DetalleDoc.Metodo_Costo = 'E' AND NVL(Lr_DetalleDoc.Costo_Estandar,0) = 0 THEN
          Pv_MensajeError := 'El art�culo '|| Lr_DetalleDoc.No_Arti ||' no tiene definido costo estandar';
          Raise Le_Error;
        END IF;
        --
        Gr_Arinmn.Costo_Uni := Lr_DetalleDoc.Costo_Estandar;
        --
      END IF;
      --
      Gr_Arinmn.Costo2 := NAF47_TNET.ARTICULO.COSTO2(Gr_Arinml.No_Cia, --ANR costo2 es de la bodega origen, porque el costo 1 se devuelve de la bodega origen 21/04/2009
                                                     Gr_Arinml.No_Arti,
                                                     Gr_Arinml.Bodega); 
      
      --
      Gr_Arinml.monto := NAF47_TNET.MONEDA.REDONDEO(NVL(ABS(Gr_Arinml.unidades * Gr_Arinmn.Costo_Uni), 0), 'P');
      Gr_Arinml.monto_dol :=  NAF47_TNET.MONEDA.REDONDEO(nvl(Gr_Arinml.monto / Gr_Arinme.Tipo_Cambio,0), 'D');
      Gr_Arinml.tipo_cambio := Gr_Arinme.Tipo_Cambio;
      Gr_Arinml.monto2 := NAF47_TNET.MONEDA.REDONDEO(nvl(abs(Gr_Arinml.unidades * Gr_Arinmn.Costo2), 0), 'P'); --FEM
      Gr_Arinml.monto2_dol := NAF47_TNET.MONEDA.REDONDEO(nvl(Gr_Arinml.monto2 / Gr_Arinme.Tipo_Cambio,0), 'D');
      --
      IF Lr_Arinte.Es_Mal_Estado_Bd = 'S' AND Lr_DetalleDoc.Aplica_Garantia = 'S' THEN
        Gr_Arinml.reconoce_reclamoprov := 'S';
      ELSE
        Gr_Arinml.reconoce_reclamoprov := 'N';
      END IF;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINML (Gr_Arinml, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      -- se procede a registrar en movimiento kardex
      Gr_Arinmn.No_Linea := Gr_Arinml.Linea;
      Gr_Arinmn.Bodega := Gr_Arinml.Bodega;
      Gr_Arinmn.No_arti := Gr_Arinml.No_Arti;
      Gr_Arinmn.Unidades := Gr_Arinml.Unidades;
      Gr_Arinmn.Monto := Gr_Arinml.Monto;
      Gr_Arinmn.Descuento := 0;
      Gr_Arinmn.precio_venta := 0;
      Gr_Arinmn.monto2 := Gr_Arinml.Monto2;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINMN (Gr_Arinmn, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      -- Replica serie por linea detalle
      BEGIN
        INSERT INTO NAF47_TNET.INV_DOCUMENTO_SERIE
                  ( COMPANIA,
                    ID_DOCUMENTO,
                    LINEA,
                    SERIE,
                    MAC,
                    UNIDADES,
                    CANTIDAD_SEGMENTO,
                    SERIE_ORIGINAL,
                    USUARIO_CREA,
                    FECHA_CREA)
             SELECT A.COMPANIA,
                    Gr_Arinmn.No_Docu,
                    Gr_Arinmn.No_Linea,
                    A.SERIE,
                    A.MAC,
                    A.UNIDADES,
                    A.CANTIDAD_SEGMENTO,
                    A.SERIE_ORIGINAL,
                    USER,
                    SYSDATE
               FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A
              WHERE A.NO_ARTICULO = Gr_Arinmn.No_Arti --llindao: linea articulo que se esta procesando.
                AND A.NO_DOCUMENTO = Gr_Arinmn.No_Docu
                AND A.COMPANIA = Gr_Arinmn.No_Cia
                AND A.ORIGEN = 'IN';
      EXCEPTION
        WHEN OTHERS THEN
          Pv_mensajeError := 'Error al guardar en INV_DOCUMENTO_SERIE. '||SQLERRM;
          RAISE Le_Error;
      END;
     
      -- se actualiza estado de numeros de series a fuera de bodega
      UPDATE NAF47_TNET.INV_NUMERO_SERIE A
      SET A.ID_BODEGA = NULL,
          A.ESTADO = 'FB',
          A.USUARIO_MODIFICA = USER,
          A.FECHA_MODIFICA = SYSDATE
      WHERE A.COMPANIA = Pv_noCia
      AND A.ESTADO = 'EB'-- solo se pueden transferir series que se encuentran en bodega
      AND EXISTS (SELECT NULL 
                  FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE B
                  WHERE B.SERIE = A.SERIE
                  AND B.COMPANIA = A.COMPANIA
                  AND B.NO_ARTICULO = A.NO_ARTICULO
                  AND B.NO_ARTICULO = Gr_Arinmn.No_Arti
                  AND B.NO_DOCUMENTO = Gr_Arinmn.No_Docu
                  AND B.COMPANIA = Gr_Arinmn.No_Cia
                  AND B.ORIGEN = 'IN');
      --
      NAF47_TNET.INACTUALIZA_SALDOS_ARTICULO ( Gr_Arinmn.No_Cia, 
                                               Gr_Arinmn.Bodega, 
                                               Gr_Arinmn.No_Arti, 
                                               'TRASLADO', 
                                               -Gr_Arinmn.Unidades,
                                               -nvl(Gr_Arinmn.Monto,0),  
                                               Null, 
                                               Pv_MensajeError);
      IF Pv_MensajeError is not null THEN
        RAISE Le_Error;
      END IF;  
      --
      -- En la bodega origen se actualiza solamente el costo 2 ANR 27/04/2009
      UPDATE NAF47_TNET.ARINMA 
      SET COSTO2     = Gr_Arinmn.Costo2,
          ULT_COSTO2 = Lr_DetalleDoc.Ultimo_Costo2,
          MONTO2     = Gr_Arinmn.Costo2 * (SAL_ANT_UN + COMP_UN - VENT_UN - CONS_UN + OTRS_UN)
      WHERE NO_CIA  = Gr_Arinmn.No_Cia
      AND NO_ARTI = Gr_Arinmn.No_Arti
      AND BODEGA  = Gr_Arinmn.Bodega;
      --
      -- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
      -- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas
      NAF47_TNET.INCOSTO_ACTUALIZA (Gr_Arinmn.No_Cia, Gr_Arinmn.No_Arti);
      --
      Ln_TotalDocumento  := Ln_TotalDocumento + Gr_Arinmn.Monto;
      Ln_TotalDocumento2 := Ln_TotalDocumento2 + Gr_Arinmn.Monto2;
      --
    END LOOP;
    --
    --
    IF NVL(Gr_Arinml.linea,0) = 0 THEN
      Pv_mensajeError := 'Existe inconsistencia de informaci�n entre cabecera y detalle del documento, favor eliminar el detalle articulos y vuelva a ingresar.';
      Raise Le_Error;
    END IF;
    --
    --
    UPDATE NAF47_TNET.ARINME
    SET MOV_TOT  = Ln_TotalDocumento,
        MOV_TOT2 = Ln_TotalDocumento2   
    WHERE NO_CIA  = Gr_Arinme.No_Cia
    AND NO_DOCU = Gr_Arinme.No_Docu; 
    --
    UPDATE NAF47_TNET.ARINMEH
    SET MOV_TOT  = Ln_TotalDocumento,
        MOV_TOT2 = Ln_TotalDocumento2   
    WHERE NO_CIA  = Gr_Arinme.No_Cia
    AND NO_DOCU = Gr_Arinme.No_Docu; 
    --
    --
    UPDATE NAF47_TNET.ARINTE
    SET ESTADO = 'T', 
        IND_BORRADO = 'S',
        FE_ULT_NOTIFICACION = SYSDATE
    WHERE NO_CIA = Gr_Arinme.No_Cia 
    AND NO_DOCU = Gr_Arinme.No_Docu;
    --
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_SALIDA_BODEGA_ORIGEN',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_SALIDA_BODEGA_ORIGEN',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_SALIDA_BODEGA_ORIGEN;
  --
  --
  PROCEDURE P_RECIBE_TRANSFERENCIA (Pv_NoDespacho    IN VARCHAR2,
                                    Pv_Centro        IN VARCHAR2,
                                    Pv_NoCia         IN VARCHAR2,
                                    Pt_DetalleTransf IN NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf,
                                    Pv_NoDocuRecibe  IN OUT VARCHAR2,
                                    Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_TRANSFERENCIA_SALIDA IS
      SELECT ME.TIPO_DOC,
             ME.NO_DOCU,
             ME.NO_CIA,
             ME.TIPO_CAMBIO,
             ME.NO_FISICO,
             ME.SERIE_FISICO,
             ME.OBSERV1
      FROM NAF47_TNET.ARINME ME
      WHERE NO_CIA = Pv_NoCia 
      AND NO_DOCU = Pv_NoDespacho
      UNION
      SELECT ME.TIPO_DOC,
             ME.NO_DOCU,
             ME.NO_CIA,
             ME.TIPO_CAMBIO,
             ME.NO_FISICO,
             ME.SERIE_FISICO,
             TE.OBSERV1
      FROM NAF47_TNET.ARINME ME,
           NAF47_TNET.ARINTE TE
      WHERE TE.NO_CIA = Pv_NoCia 
      AND TE.NO_DOCU = Pv_NoDespacho
      AND TE.NO_DOCU_REF = ME.NO_DOCU
      AND TE.NO_CIA = ME.NO_CIA
      ORDER BY 2;
      
    --
    CURSOR C_SERIES_INCONSISTENTE IS
      SELECT A.SERIE
      FROM NAF47_TNET.INV_NUMERO_SERIE A
      WHERE A.COMPANIA = Pv_noCia
      AND A.ESTADO = 'EB'
      AND EXISTS (SELECT NULL 
                       FROM INV_PRE_INGRESO_NUMERO_SERIE B
                      WHERE B.SERIE = A.SERIE
                        AND B.NO_ARTICULO = A.NO_ARTICULO
                        AND B.COMPANIA = A.COMPANIA
                        AND B.NO_DOCUMENTO = Pv_NoDespacho
                        AND B.ESTADO = 'Pendiente');
    --
    CURSOR C_DATOS_ARTICULO (Cv_NoArti       VARCHAR2,
                             Cv_BodegaOrigen VARCHAR2,
                             Cv_NoCia        VARCHAR2) IS
      SELECT DA.IND_REQUIERE_SERIE MANEJA_SERIE,
             DA.COSTO_ESTANDAR,
             NVL(DA.APLICA_GARANTIA,'N') AS APLICA_GARANTIA,
             DA.ULTIMO_COSTO,
             DA.ULTIMO_COSTO2,
             DA.TIPO_ASTERISCO AS CLASIFICACION,
             (SELECT MA.AFECTA_COSTO
              FROM NAF47_TNET.ARINMA MA
              WHERE MA.NO_ARTI = Cv_NoArti
              AND MA.BODEGA = Cv_BodegaOrigen
              AND MA.NO_CIA = Cv_NoCia) AS AFECTA_COSTO,
             (SELECT METODO_COSTO
              FROM NAF47_TNET.GRUPOS
              WHERE NO_CIA = DA.NO_CIA
              AND GRUPO = DA.GRUPO) AS METODO_COSTO,
             DA.DESCRIPCION  
      FROM NAF47_TNET.ARINDA DA
      WHERE DA.NO_ARTI = Cv_NoArti
      AND DA.NO_CIA = Cv_NoCia;
    --
    CURSOR C_DATOS_BODEGA (Cv_Bodega VARCHAR2,
                           Cv_NoCia   VARCHAR2) IS
      SELECT NVL(BO.MAL_ESTADO, 'N') AS MAL_ESTADO
      FROM NAF47_TNET.ARINBO BO
      WHERE BO.CODIGO = Cv_Bodega
      AND BO.NO_CIA = Cv_NoCia;
      
    CURSOR C_EMPRESA IS
    SELECT ID_EMPRESA FROM DB_COMPRAS.ADMI_EMPRESA
    WHERE CODIGO=Pv_NoCia;  
    --
    Lc_IdEmpresa        C_EMPRESA%ROWTYPE;
    Lr_InsertReservaProd DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE := NULL;
    Lr_DatosDespacho  C_TRANSFERENCIA_SALIDA%ROWTYPE;
    Lr_TipoDocEntrada C_DOCUMENTO_TRASLADO%ROWTYPE;
    Lr_DatosArticulo  C_DATOS_ARTICULO%ROWTYPE;
    Lr_DatosBodega    C_DATOS_BODEGA%ROWTYPE;
    --
    Ln_TotalDocumento  NUMBER := 0;
    Ln_TotalDocumento2 NUMBER := 0;
    --
    Le_Error          EXCEPTION;
    --
  BEGIN
    -- Se inicializan las variables
    Gr_Arinme := NULL;
    Gr_Arinmeh := NULL;
    Gr_Arinml := NULL;
    Gr_Arinmn := NULL;
    Gr_DatosPeriodo := NULL;
    --
    IF C_TRANSFERENCIA_SALIDA%ISOPEN THEN
      CLOSE C_TRANSFERENCIA_SALIDA;
    END IF;
    OPEN C_TRANSFERENCIA_SALIDA;
    FETCH C_TRANSFERENCIA_SALIDA INTO Lr_DatosDespacho;
    IF C_TRANSFERENCIA_SALIDA%NOTFOUND THEN
      Lr_DatosDespacho := NULL;
    END IF;
    CLOSE C_TRANSFERENCIA_SALIDA;
    --
    IF Lr_DatosDespacho.No_Cia IS NULL THEN
      Pv_mensajeError := 'No se encontr� trasnferencia de salida '||Pv_NoDespacho||', favor revisar ';
      RAISE Le_Error;
    END IF;
    --
    -- se recuperan parametros para asignar a documentos inventarios.
    IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
    OPEN C_DATOS_PERIODO (Pv_Centro,
                          Pv_NoCia);
    FETCH C_DATOS_PERIODO INTO Gr_DatosPeriodo;
    IF C_DATOS_PERIODO%NOTFOUND THEN
      Pv_MensajeError := 'La definici�n del calendario del inventario es incorrecta.';
      RAISE Le_Error;
    END IF;
    CLOSE C_DATOS_PERIODO;
    --
    -- Se recupetra tipo de documento salida
    IF C_DOCUMENTO_TRASLADO%ISOPEN THEN
      CLOSE C_DOCUMENTO_TRASLADO;
    END IF;
    OPEN C_DOCUMENTO_TRASLADO ('E', Pv_NoCia);
    FETCH C_DOCUMENTO_TRASLADO INTO Lr_TipoDocEntrada;
    IF C_DOCUMENTO_TRASLADO%NOTFOUND THEN
      Lr_TipoDocEntrada := NULL;
    END IF;
    CLOSE C_DOCUMENTO_TRASLADO;
    --
    IF Lr_TipoDocEntrada.Tipo_m IS NULL THEN
      Pv_MensajeError := 'No se ha definido tipo de documento Traslado Entrada';
      Raise Le_Error;
    ELSIF Lr_TipoDocEntrada.Formulario IS NULL THEN
      Pv_MensajeError := 'El documento de traslado de Entrada no tiene formulario asociado.';
      Raise Le_Error;
    END IF;
    
    OPEN C_EMPRESA;
    FETCH C_EMPRESA INTO Lc_IdEmpresa;
    CLOSE C_EMPRESA;
    
    --
    -- se valida si existen inconistencias
    FOR A IN C_SERIES_INCONSISTENTE LOOP
      IF Pv_mensajeError IS NULL THEN
        Pv_mensajeError := A.SERIE;
      ELSE
        Pv_mensajeError := A.SERIE||', '||Pv_mensajeError;
      END IF;
    END LOOP;
    --
    IF Pv_mensajeError IS NOT NULL THEN
      Pv_mensajeError := 'Se encontraron series en estado [EB] En Bodega: '||Pv_mensajeError;
      Raise Le_Error;
    END IF;
    --
    Gr_Arinme.No_Cia := Pv_NoCia;
    Gr_Arinme.Centro := Pv_Centro;
    Gr_Arinme.Tipo_Doc := Lr_TipoDocEntrada.Tipo_m;
    Gr_Arinme.No_Docu := NAF47_TNET.TRANSA_ID.INV(Gr_Arinme.No_Cia);
    Gr_Arinme.No_Fisico := Lr_DatosDespacho.No_Fisico;
    Gr_Arinme.Serie_Fisico := Lr_DatosDespacho.Serie_Fisico;
    Gr_Arinme.Periodo := Gr_DatosPeriodo.Ano_Proce;
    Gr_Arinme.Fecha := Gr_DatosPeriodo.Dia_Proceso;
    Gr_Arinme.Observ1 := Lr_DatosDespacho.Observ1;
    Gr_Arinme.Tipo_Refe := Lr_DatosDespacho.Tipo_Doc;
    Gr_Arinme.No_Docu_Refe := Lr_DatosDespacho.No_Docu;
    Gr_Arinme.Ruta := '0000';
    Gr_Arinme.Estado := 'D';
    Gr_Arinme.Origen := 'IN';
    Gr_Arinme.Tipo_Cambio := Lr_DatosDespacho.Tipo_Cambio;
    --Gr_Arinme.Id_Bodega := Lr_Arinte.Bod_Orig;
    --
    NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINME (Gr_Arinme, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                     'INKG_TRANSFERENCIAS.P_RECIBE_TRANSFERENCIA',
                                     'Parametros:  Pv_NoCia ['||Pv_NoCia||'], Pv_Centro['||Pv_Centro||'], Lr_Arinte.no_docu['||Gr_Arinme.no_docu||']',
                                     NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                     SYSDATE,
                                     NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    
    -- se asigna data para registrar historico de movimientos
    Gr_Arinmeh.no_cia := Gr_Arinme.No_Cia;
    Gr_Arinmeh.centro := Gr_Arinme.Centro;
    Gr_Arinmeh.tipo_doc := Gr_Arinme.Tipo_Doc;
    Gr_Arinmeh.periodo := Gr_Arinme.Periodo;
    Gr_Arinmeh.ruta := Gr_Arinme.Ruta;
    Gr_Arinmeh.no_docu := Gr_Arinme.No_Docu;
    Gr_Arinmeh.fecha := Gr_Arinme.Fecha;
    Gr_Arinmeh.observ1 := Gr_Arinme.Observ1;
    Gr_Arinmeh.tipo_cambio := Gr_Arinme.Tipo_Cambio;
    Gr_Arinmeh.no_fisico := Gr_Arinme.No_Fisico;
    Gr_Arinmeh.serie_fisico := Gr_Arinme.Serie_Fisico;
    Gr_Arinmeh.tipo_refe := Gr_Arinme.Tipo_Refe;
    Gr_Arinmeh.no_docu_refe := Gr_Arinme.No_Docu_Refe;
    Gr_Arinmeh.mes := Gr_DatosPeriodo.mes_proce;
    Gr_Arinmeh.semana := Gr_DatosPeriodo.semana_proce;
    Gr_Arinmeh.ind_sem := Gr_DatosPeriodo.indicador_sem;
    --
    NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINMEH (Gr_Arinmeh, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    -- Se inicializa datos fijos de tabla detalle
    Gr_Arinml.no_cia := Gr_Arinme.No_Cia;
    Gr_Arinml.centro := Gr_Arinme.Centro;
    Gr_Arinml.tipo_doc := Gr_Arinme.Tipo_Doc;
    Gr_Arinml.periodo := Gr_Arinme.Periodo;
    Gr_Arinml.ruta := Gr_Arinme.Ruta;
    Gr_Arinml.no_docu := Gr_Arinme.No_Docu;
    Gr_Arinml.Time_Stamp := sysdate;
    Gr_Arinml.linea := 0;
    Gr_Arinml.linea_ext := 0;
    --
    -- Se inicializa datos fijos de tabla detalle kardex
    Gr_Arinmn.no_cia := Gr_Arinme.No_Cia;
    Gr_Arinmn.centro := Gr_Arinme.Centro;
    Gr_Arinmn.tipo_doc := Gr_Arinme.Tipo_Doc;
    Gr_Arinmn.Periodo_Proce := TO_CHAR((Gr_DatosPeriodo.ano_proce*100)+Gr_DatosPeriodo.semana_proce) || Gr_DatosPeriodo.indicador_sem;
    Gr_Arinmn.ruta := Gr_Arinme.Ruta;
    Gr_Arinmn.no_docu := Gr_Arinme.No_Docu;
    Gr_Arinmn.No_Linea := 0;
    Gr_Arinmn.Ano := Gr_Arinme.Periodo;
    Gr_Arinmn.mes := Gr_DatosPeriodo.mes_proce;     
    Gr_Arinmn.semana := Gr_DatosPeriodo.semana_proce;
    Gr_Arinmn.Fecha := Gr_Arinme.Fecha;
    Gr_Arinmn.Time_stamp := Gr_Arinml.Time_Stamp;
    --
    --
    Ln_TotalDocumento := 0;
    Ln_TotalDocumento2 := 0;
    -- se procesan linea detalle de documento
    FOR Li_Indice IN 1..Pt_DetalleTransf.LAST LOOP
      --
      Gr_Arinml.no_arti := Pt_DetalleTransf(Li_Indice).NO_ARTICULO;
      Gr_Arinml.unidades := Pt_DetalleTransf(Li_Indice).CANTIDAD;
      Gr_Arinml.bodega := Pt_DetalleTransf(Li_Indice).BODEGA_DESTINO;
      --
      IF C_DATOS_ARTICULO%ISOPEN THEN
        CLOSE C_DATOS_ARTICULO;
      END IF;
      OPEN C_DATOS_ARTICULO( Pt_DetalleTransf(Li_Indice).NO_ARTICULO,
                             Pt_DetalleTransf(Li_Indice).BODEGA_ORIGEN,
                             Pv_NoCia);
      FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo;
      IF C_DATOS_ARTICULO%NOTFOUND THEN
        Lr_DatosArticulo := NULL;
      END IF;
      CLOSE C_DATOS_ARTICULO;
      --
      --
      IF Lr_DatosBodega.Mal_Estado IS NULL THEN
        --
        IF C_DATOS_BODEGA%ISOPEN THEN
          CLOSE C_DATOS_BODEGA;
        END IF;
        OPEN C_DATOS_BODEGA (Gr_Arinml.bodega, Gr_Arinml.No_Cia);
        FETCH C_DATOS_BODEGA INTO Lr_DatosBodega;
        IF C_DATOS_BODEGA%NOTFOUND THEN
          Lr_DatosBodega.Mal_Estado := 'N';
        END IF;
        CLOSE C_DATOS_BODEGA;
        --
      END IF;
      --
      NAF47_TNET.INCREA_ARTICULO(Gr_Arinml.no_cia, Gr_Arinml.bodega, Gr_Arinml.no_arti, Lr_DatosArticulo.Afecta_Costo, Pv_MensajeError);
      --
      If Pv_MensajeError is not null Then
        Raise Le_Error;
      End If;
      --
      --
      Gr_Arinml.linea := nvl(Gr_Arinml.linea,0) + 1;
      Gr_Arinml.linea_ext := nvl(Gr_Arinml.linea_ext,0) + 1;
      --
      IF Lr_DatosArticulo.Metodo_Costo = 'P' THEN
        Gr_Arinmn.Costo_Uni := naf47_tnet.articulo.costo(Gr_Arinml.No_Cia, 
                                                         Gr_Arinml.No_Arti, 
                                                         Gr_Arinml.Bodega);
      ELSE
        IF Lr_DatosArticulo.Metodo_Costo = 'E' AND NVL(Lr_DatosArticulo.Costo_Estandar,0) = 0 THEN
          Pv_MensajeError := 'El art�culo '|| Gr_Arinml.No_Arti ||' no tiene definido costo estandar';
          Raise Le_Error;
        END IF;
        --
        Gr_Arinmn.Costo_Uni := Lr_DatosArticulo.Costo_Estandar;
        --
      END IF;
      --
      Gr_Arinmn.Costo2 := NAF47_TNET.ARTICULO.COSTO2(Gr_Arinml.No_Cia, --ANR costo2 es de la bodega origen, porque el costo 1 se devuelve de la bodega origen 21/04/2009
                                                     Gr_Arinml.No_Arti,
                                                     Gr_Arinml.Bodega); 
      
      --
      Gr_Arinml.monto := NAF47_TNET.MONEDA.REDONDEO(NVL(ABS(Gr_Arinml.unidades * Gr_Arinmn.Costo_Uni), 0), 'P');
      Gr_Arinml.monto_dol :=  NAF47_TNET.MONEDA.REDONDEO(nvl(Gr_Arinml.monto / Gr_Arinme.Tipo_Cambio,0), 'D');
      Gr_Arinml.tipo_cambio := Gr_Arinme.Tipo_Cambio;
      Gr_Arinml.monto2 := NAF47_TNET.MONEDA.REDONDEO(nvl(abs(Gr_Arinml.unidades * Gr_Arinmn.Costo2), 0), 'P'); --FEM
      Gr_Arinml.monto2_dol := NAF47_TNET.MONEDA.REDONDEO(nvl(Gr_Arinml.monto2 / Gr_Arinme.Tipo_Cambio,0), 'D');
      --
      IF Lr_DatosBodega.Mal_Estado = 'S' AND Lr_DatosArticulo.Aplica_Garantia = 'S' THEN
        Gr_Arinml.reconoce_reclamoprov := 'S';
      ELSE
        Gr_Arinml.reconoce_reclamoprov := 'N';
      END IF;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINML (Gr_Arinml, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      -- se procede a registrar en movimiento kardex
      Gr_Arinmn.No_Linea := Gr_Arinml.Linea;
      Gr_Arinmn.Bodega := Gr_Arinml.Bodega;
      Gr_Arinmn.No_arti := Gr_Arinml.No_Arti;
      Gr_Arinmn.Unidades := Gr_Arinml.Unidades;
      Gr_Arinmn.Monto := Gr_Arinml.Monto;
      Gr_Arinmn.Descuento := 0;
      Gr_Arinmn.precio_venta := 0;
      Gr_Arinmn.monto2 := Gr_Arinml.Monto2;
      --
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_RECIBE_TRANSFERENCIA',
                                           'Parametros:  Gr_Arinmn.No_Cia ['||Gr_Arinmn.No_Cia||'], Gr_Arinmn.No_Docu['||Gr_Arinmn.No_Docu||'], Gr_Arinmn.No_Linea['||Gr_Arinmn.No_Linea||']',
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINMN (Gr_Arinmn, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      -- Replica serie por linea detalle
      BEGIN
        INSERT INTO NAF47_TNET.INV_DOCUMENTO_SERIE
                  ( COMPANIA,
                    ID_DOCUMENTO,
                    LINEA,
                    SERIE,
                    MAC,
                    UNIDADES,
                    CANTIDAD_SEGMENTO,
                    SERIE_ORIGINAL,
                    USUARIO_CREA,
                    FECHA_CREA)
             SELECT A.COMPANIA,
                    Gr_Arinmn.No_Docu,
                    Gr_Arinmn.No_Linea,
                    A.SERIE,
                    A.MAC,
                    A.UNIDADES,
                    A.CANTIDAD_SEGMENTO,
                    A.SERIE_ORIGINAL,
                    USER,
                    SYSDATE
               FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A
              WHERE A.NO_ARTICULO = Gr_Arinml.No_Arti --llindao: linea articulo que se esta procesando.
                AND A.NO_DOCUMENTO = Pv_NoDespacho
                AND A.COMPANIA = Pv_NoCia
                AND A.ORIGEN = 'IN'
                AND A.ESTADO = 'Pendiente';
      EXCEPTION
        WHEN OTHERS THEN
          Pv_mensajeError := 'Error al guardar en INV_DOCUMENTO_SERIE. '||SQLERRM;
          RAISE Le_Error;
      END;
      --
      -- se actualiza para asignar bodega y estado
      UPDATE NAF47_TNET.INV_NUMERO_SERIE A
      SET A.ID_BODEGA = Gr_Arinml.Bodega,
          A.ESTADO = 'EB',
          A.USUARIO_MODIFICA = USER,
          A.FECHA_MODIFICA = SYSDATE
      WHERE A.COMPANIA = Pv_noCia
      AND A.ESTADO = 'FB' -- solo se pueden transferir series que se encuentran fuera de bodega
      AND EXISTS (SELECT NULL 
                  FROM NAF47_TNET.ARINMN MN,
                       NAF47_TNET.INV_DOCUMENTO_SERIE B
                  WHERE B.SERIE = A.SERIE
                  AND B.COMPANIA = A.COMPANIA
                  AND B.LINEA = Gr_Arinmn.No_Linea
                  AND B.ID_DOCUMENTO = Gr_Arinmn.No_Docu
                  AND B.COMPANIA = Gr_Arinmn.No_Cia
                  AND MN.NO_ARTI = A.NO_ARTICULO
                  AND B.LINEA = MN.NO_LINEA
                  AND B.ID_DOCUMENTO = MN.NO_DOCU
                  AND B.COMPANIA = MN.NO_CIA
                  );
      --
      -- Se asigna documento traslado entrada en pre ingreso, temporalemte se asign� con documento despacho
      UPDATE NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE B
      SET B.NO_DOCUMENTO = Gr_Arinml.No_Docu,
          B.LINEA = Gr_Arinml.Linea,
          B.ESTADO = 'Procesado'
      WHERE B.NO_ARTICULO = Gr_Arinml.No_Arti --llindao: linea articulo que se esta procesando.
      AND B.NO_DOCUMENTO = Pv_NoDespacho
      AND B.COMPANIA = Pv_NoCia
      AND B.ORIGEN = 'IN'
      AND B.ESTADO = 'Pendiente';
      --
      -- se actualizan los saldos de la bodega
      NAF47_TNET.INACTUALIZA_SALDOS_ARTICULO ( Gr_Arinmn.No_Cia, 
                                               Gr_Arinmn.Bodega, 
                                               Gr_Arinmn.No_Arti, 
                                               'TRASLADO', 
                                               Gr_Arinmn.Unidades,
                                               nvl(Gr_Arinmn.Monto,0),  
                                               Null, 
                                               Pv_MensajeError);
      IF Pv_MensajeError is not null THEN
        RAISE Le_Error;
      END IF;  
      --
      -- En la bodega origen se actualiza solamente el costo 2 ANR 27/04/2009
      UPDATE NAF47_TNET.ARINMA 
      SET COSTO_UNI = Gr_Arinmn.Costo_Uni,
          ULT_COSTO = Lr_DatosArticulo.Ultimo_Costo,
          COSTO2 = Gr_Arinmn.Costo2,
          ULT_COSTO2 = Lr_DatosArticulo.Ultimo_Costo2,
          MONTO2 = Gr_Arinmn.Costo2 * (SAL_ANT_UN + COMP_UN - VENT_UN - CONS_UN + OTRS_UN)
      WHERE NO_CIA = Gr_Arinmn.No_Cia
      AND NO_ARTI = Gr_Arinmn.No_Arti
      AND BODEGA = Gr_Arinmn.Bodega;
      --
      -- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
      -- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas
      NAF47_TNET.INCOSTO_ACTUALIZA (Gr_Arinmn.No_Cia, Gr_Arinmn.No_Arti);
      --
      
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_RECIBE_TRANSFERENCIA',
                                           'Procesando:  Gr_Arinmn.No_Arti ['||Gr_Arinmn.No_Arti||'], Gr_Arinmn.Unidades['||Gr_Arinmn.Unidades||']',
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

      --
      -- Se descuenta saldo pendiente de trasnferir
      UPDATE NAF47_TNET.ARINTL TL
      SET SALDO = SALDO - Gr_Arinmn.Unidades
      WHERE TL.NO_ARTI = Gr_Arinmn.No_Arti
      AND TL.NO_DOCU = Pv_NoDespacho
      AND TL.NO_CIA = Pv_NoCia;
      --
      
      --
      Ln_TotalDocumento  := Ln_TotalDocumento + Gr_Arinmn.Monto;
      Ln_TotalDocumento2 := Ln_TotalDocumento2 + Gr_Arinmn.Monto2;
      --
      --
      
      --si tiene pedido_detalle_id se precede a reservar
      IF Pt_DetalleTransf(Li_Indice).PEDIDO_DETALLE_ID IS NOT NULL THEN
                   
        Lr_InsertReservaProd := NULL;
        --Se procede a registrar la reserva en base a un proyecto
        Lr_InsertReservaProd.ID_RESERVA_PRODUCTOS := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
        Lr_InsertReservaProd.EMPRESA_ID           := Lc_IdEmpresa.ID_EMPRESA;
        Lr_InsertReservaProd.BODEGA               := Pt_DetalleTransf(Li_Indice).BODEGA_DESTINO;
        Lr_InsertReservaProd.NO_ARTI              := Pt_DetalleTransf(Li_Indice).NO_ARTICULO;
        Lr_InsertReservaProd.DESCRIPCION          := Lr_DatosArticulo.Descripcion;
        Lr_InsertReservaProd.CANTIDAD           :=  Pt_DetalleTransf(Li_Indice).CANTIDAD;
        Lr_InsertReservaProd.TIPO_MOV           := 'I'; --Se procede registrar el tipo I por devolcion de unidades al momento que se recibe la transferencia
        Lr_InsertReservaProd.PEDIDO_DETALLE_ID  :=  Pt_DetalleTransf(Li_Indice).PEDIDO_DETALLE_ID;
        Lr_InsertReservaProd.NO_CIA             := Pv_NoCia;
        Lr_InsertReservaProd.DESCRIPCION_MOTIVO := 'IngresoReserva';
        Lr_InsertReservaProd.USUARIO_CREACION   := USER;
        Lr_InsertReservaProd.FECHA_CREACION     := SYSDATE;
        --
        --

        NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA(Lr_InsertReservaProd, --
                                                                  Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF; 
        
        UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE PD
         SET PD.CANTIDAD_RESERVADA = NVL(PD.CANTIDAD_RESERVADA, 0) +
                                     Pt_DetalleTransf(Li_Indice).CANTIDAD,
             PD.USR_ULT_MOD        = USER,
             PD.FE_ULT_MOD         = SYSDATE
        WHERE PD.ID_PEDIDO_DETALLE = Pt_DetalleTransf(Li_Indice).PEDIDO_DETALLE_ID;        
      END IF;
      
      --
      --
    END LOOP;
    --
    UPDATE NAF47_TNET.ARINME
    SET MOV_TOT  = Ln_TotalDocumento,
        MOV_TOT2 = Ln_TotalDocumento2   
    WHERE NO_CIA  = Gr_Arinme.No_Cia
    AND NO_DOCU = Gr_Arinme.No_Docu; 
    --
    UPDATE NAF47_TNET.ARINMEH
    SET MOV_TOT  = Ln_TotalDocumento,
        MOV_TOT2 = Ln_TotalDocumento2   
    WHERE NO_CIA  = Gr_Arinme.No_Cia
    AND NO_DOCU = Gr_Arinme.No_Docu; 
    --
    UPDATE NAF47_TNET.ARINTE TE
    SET TE.NO_DOCU_REF = Gr_Arinme.No_Docu
    WHERE TE.NO_DOCU = Pv_NoDespacho
    AND TE.NO_CIA = Pv_NoCia;
    --
    -- se recupera documentos para realizar impresion del mismo.
    Pv_NoDocuRecibe := Gr_Arinme.No_Docu;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_RECIBE_TRANSFERENCIA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_RECIBE_TRANSFERENCIA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_RECIBE_TRANSFERENCIA;
  --
  --
  PROCEDURE P_RECHAZA_TRANSFERENCIA ( Pv_NoDespacho    IN VARCHAR2,
                                      Pv_NoCia         IN VARCHAR2,
                                      Pt_DetalleTransf IN NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf,
                                      Pv_MotivoRechazo IN VARCHAR2,
                                      Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_TRANSFERENCIA_SALIDA IS
      SELECT ME.CENTRO,
             ME.TIPO_DOC,
             ME.NO_DOCU,
             ME.NO_CIA,
             ME.TIPO_CAMBIO,
             ME.NO_FISICO,
             ME.SERIE_FISICO,
             ME.OBSERV1
      FROM NAF47_TNET.ARINME ME
      WHERE NO_CIA = Pv_NoCia 
      AND NO_DOCU = Pv_NoDespacho;
    --
    CURSOR C_SERIES_INCONSISTENTE IS
      SELECT A.SERIE
      FROM NAF47_TNET.INV_NUMERO_SERIE A
      WHERE A.COMPANIA = Pv_noCia
      AND A.ESTADO = 'EB'
      AND EXISTS (SELECT NULL 
                       FROM INV_PRE_INGRESO_NUMERO_SERIE B
                      WHERE B.SERIE = A.SERIE
                        AND B.NO_ARTICULO = A.NO_ARTICULO
                        AND B.COMPANIA = A.COMPANIA
                        AND B.NO_DOCUMENTO = Pv_NoDespacho
                        AND B.ESTADO = 'Pendiente');
    --
    CURSOR C_DATOS_ARTICULO (Cv_NoArti       VARCHAR2,
                             Cv_BodegaOrigen VARCHAR2,
                             Cv_NoCia        VARCHAR2) IS
      SELECT DA.IND_REQUIERE_SERIE MANEJA_SERIE,
             DA.COSTO_ESTANDAR,
             NVL(DA.APLICA_GARANTIA,'N') AS APLICA_GARANTIA,
             DA.ULTIMO_COSTO,
             DA.ULTIMO_COSTO2,
             DA.TIPO_ASTERISCO AS CLASIFICACION,
             DA.CATEGORIA,
             DA.CLASE,
             (SELECT MA.AFECTA_COSTO
              FROM NAF47_TNET.ARINMA MA
              WHERE MA.NO_ARTI = Cv_NoArti
              AND MA.BODEGA = Cv_BodegaOrigen
              AND MA.NO_CIA = Cv_NoCia) AS AFECTA_COSTO,
             (SELECT METODO_COSTO
              FROM NAF47_TNET.GRUPOS
              WHERE NO_CIA = DA.NO_CIA
              AND GRUPO = DA.GRUPO) AS METODO_COSTO 
      FROM NAF47_TNET.ARINDA DA
      WHERE DA.NO_ARTI = Cv_NoArti
      AND DA.NO_CIA = Cv_NoCia;
    --
    /*
    CURSOR C_DATOS_BODEGA (Cv_Bodega VARCHAR2,
                           Cv_NoCia   VARCHAR2) IS
      SELECT NVL(BO.MAL_ESTADO, 'N') AS MAL_ESTADO
      FROM NAF47_TNET.ARINBO BO
      WHERE BO.CODIGO = Cv_Bodega
      AND BO.NO_CIA = Cv_NoCia;
    */
    --
    /*
    CURSOR C_BODEGA_MAL_ESTADO ( Cv_Bodega VARCHAR2,
                                 Cv_NoCia  VARCHAR2 ) IS
      SELECT BME.CODIGO
      FROM NAF47_TNET.ARINBO BME
      WHERE BME.NO_CIA = Cv_NoCia
      AND BME.MAL_ESTADO = 'S'
      AND EXISTS (SELECT NULL
                  FROM NAF47_TNET.ARINBO BO
                  WHERE BO.NO_CIA = BME.NO_CIA
                  AND BO.CENTRO = BME.CENTRO
                  AND BO.CODIGO = Cv_Bodega);
    */
    --
    Lr_DatosDespacho  C_TRANSFERENCIA_SALIDA%ROWTYPE;
    --Lr_TipoDocEntrada C_DOCUMENTO_TRASLADO%ROWTYPE;
    Lr_DatosArticulo  C_DATOS_ARTICULO%ROWTYPE;
    --Lr_DatosBodega    C_DATOS_BODEGA%ROWTYPE;
    --Lr_BodMalEstado   C_BODEGA_MAL_ESTADO%ROWTYPE;
    --
    Lr_Arinte         NAF47_TNET.ARINTE%ROWTYPE;
    Lr_Arintl         NAF47_TNET.ARINTL%ROWTYPE;
    --
    Ln_TotalDocumento  NUMBER := 0;
    Ln_TotalDocumento2 NUMBER := 0;
    --
    Le_Error          EXCEPTION;
    --
  BEGIN
    -- Se inicializan las variables
    Lr_Arinte := NULL;
    Lr_Arintl := NULL;
    Gr_DatosPeriodo := NULL;
    --
    IF C_TRANSFERENCIA_SALIDA%ISOPEN THEN
      CLOSE C_TRANSFERENCIA_SALIDA;
    END IF;
    OPEN C_TRANSFERENCIA_SALIDA;
    FETCH C_TRANSFERENCIA_SALIDA INTO Lr_DatosDespacho;
    IF C_TRANSFERENCIA_SALIDA%NOTFOUND THEN
      Lr_DatosDespacho := NULL;
    END IF;
    CLOSE C_TRANSFERENCIA_SALIDA;
    --
    IF Lr_DatosDespacho.No_Cia IS NULL THEN
      Pv_mensajeError := 'No se encontr� trasnferencia de salida '||Pv_NoDespacho||', favor revisar ';
      RAISE Le_Error;
    END IF;
    --
    -- se recuperan parametros para asignar a documentos inventarios.
    IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
    OPEN C_DATOS_PERIODO (Lr_DatosDespacho.Centro,
                          Pv_NoCia);
    FETCH C_DATOS_PERIODO INTO Gr_DatosPeriodo;
    IF C_DATOS_PERIODO%NOTFOUND THEN
      Pv_MensajeError := 'La definici�n del calendario del inventario es incorrecta.';
      RAISE Le_Error;
    END IF;
    CLOSE C_DATOS_PERIODO;
    --
    --
    -- se valida si existen inconistencias
    FOR A IN C_SERIES_INCONSISTENTE LOOP
      IF Pv_mensajeError IS NULL THEN
        Pv_mensajeError := A.SERIE;
      ELSE
        Pv_mensajeError := A.SERIE||', '||Pv_mensajeError;
      END IF;
    END LOOP;
    --
    IF Pv_mensajeError IS NOT NULL THEN
      Pv_mensajeError := 'Se encontraron series en estado [EB] En Bodega: '||Pv_mensajeError;
      Raise Le_Error;
    END IF;
    --
    -- se asigna data para registrar en arinte el rechazo
    Lr_Arinte.no_cia := Pv_NoCia; 
    Lr_Arinte.centro := Lr_DatosDespacho.Centro;
    Lr_Arinte.bod_orig := Pt_DetalleTransf(1).BODEGA_ORIGEN;
    Lr_Arinte.bod_dest := Pt_DetalleTransf(1).BODEGA_DESTINO;
    Lr_Arinte.periodo := Gr_DatosPeriodo.Ano_Proce;
    Lr_Arinte.no_docu := NAF47_TNET.TRANSA_ID.INV(Lr_Arinte.No_Cia);
    Lr_Arinte.fecha := Gr_DatosPeriodo.Dia_Proceso;
    Lr_Arinte.observ1 :=  SUBSTR(Pv_MotivoRechazo||'. '||Lr_DatosDespacho.Observ1,1,400);
    Lr_Arinte.ind_borrado := 'N';
    Lr_Arinte.estado := 'T';
    Lr_Arinte.no_docu_ref := Lr_DatosDespacho.No_Docu;
    Lr_Arinte.usuario := USER;
    Lr_Arinte.tstamp := SYSDATE;
    Lr_Arinte.tipo_flujo := 'SinBodegaEnTransito';
    --
    INKG_TRANSACCION.P_INSERTA_ARINTE(Lr_Arinte,  Pv_MensajeError);
    --
    IF Pv_mensajeError IS NOT NULL THEN
      Raise Le_Error;
    END IF;
    -- Se inicializa datos fijos de tabla detalle
    Lr_Arintl.no_cia := Lr_Arinte.No_Cia;
    Lr_Arintl.centro := Lr_Arinte.Centro;
    Lr_Arintl.bod_orig := Lr_Arinte.Bod_Orig;
    Lr_Arintl.bod_dest := Lr_Arinte.Bod_Dest;
    Lr_Arintl.periodo := Lr_Arinte.Periodo;
    Lr_Arintl.no_docu := Lr_Arinte.No_Docu;
    Lr_Arintl.tstamp := sysdate;
    --
    --
    Ln_TotalDocumento := 0;
    Ln_TotalDocumento2 := 0;
    -- se procesan linea detalle de documento
    FOR Li_Indice IN 1..Pt_DetalleTransf.LAST LOOP
      --
      Lr_Arintl.no_arti := Pt_DetalleTransf(Li_Indice).NO_ARTICULO;
      Lr_Arintl.cantidad := Pt_DetalleTransf(Li_Indice).CANTIDAD;
      Lr_Arintl.saldo := Pt_DetalleTransf(Li_Indice).CANTIDAD;
      --
      IF C_DATOS_ARTICULO%ISOPEN THEN
        CLOSE C_DATOS_ARTICULO;
      END IF;
      OPEN C_DATOS_ARTICULO( Lr_Arintl.no_arti,
                             Lr_Arintl.bod_dest,
                             Lr_Arintl.no_cia);
      FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo;
      IF C_DATOS_ARTICULO%NOTFOUND THEN
        Lr_DatosArticulo := NULL;
      END IF;
      CLOSE C_DATOS_ARTICULO;
      --
      Lr_Arintl.clase := Lr_DatosArticulo.Clase;
      Lr_Arintl.categoria := Lr_DatosArticulo.Categoria;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINTL (Lr_Arintl, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      -- Replica serie por linea detalle
      BEGIN
        INSERT INTO NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
                  ( COMPANIA, 
                    NO_DOCUMENTO, 
                    NO_ARTICULO, 
                    SERIE, 
                    MAC, 
                    UNIDADES,
                    ORIGEN )
        SELECT Lr_Arintl.No_Cia, 
               Lr_Arintl.No_Docu, 
               Lr_Arintl.No_Arti, 
               PINS.SERIE, 
               PINS.MAC, 
               PINS.UNIDADES,
               PINS.ORIGEN
        FROM INV_PRE_INGRESO_NUMERO_SERIE PINS
        WHERE PINS.NO_ARTICULO = Lr_Arintl.No_Arti
        AND PINS.NO_DOCUMENTO = Pv_NoDespacho
        AND PINS.COMPANIA = Pv_NoCia
        AND PINS.ESTADO = 'Procesado'
        AND NOT EXISTS (SELECT NULL
                        FROM INV_NUMERO_SERIE INS
                        WHERE INS.SERIE = PINS.SERIE
                        AND INS.COMPANIA = PINS.COMPANIA
                        AND INS.ESTADO = 'EB');
      EXCEPTION
        WHEN OTHERS THEN
          Pv_mensajeError := 'Error al guardar en INV_DOCUMENTO_SERIE. '||SQLERRM;
          RAISE Le_Error;
      END;
      --
      -- Se descuenta saldo pendiente de trasnferir
      UPDATE NAF47_TNET.ARINTL TL
      SET SALDO = SALDO - Lr_Arintl.Cantidad
      WHERE TL.NO_ARTI = Lr_Arintl.No_Arti
      AND TL.NO_DOCU = Pv_NoDespacho
      --AND TL.BOD_ORIG = Pt_DetalleTransf(Li_Indice).BODEGA_ORIGEN
      --AND TL.BOD_DEST = Pt_DetalleTransf(Li_Indice).BODEGA_DESTINO
      AND TL.NO_CIA = Pv_NoCia;
      --
      --
      Ln_TotalDocumento  := Ln_TotalDocumento + Gr_Arinmn.Monto;
      Ln_TotalDocumento2 := Ln_TotalDocumento2 + Gr_Arinmn.Monto2;
      --
      --
    END LOOP;
    --
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_RECHAZA_TRANSFERENCIA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_TRANSFERENCIAS.P_RECHAZA_TRANSFERENCIA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_RECHAZA_TRANSFERENCIA;
  
end INKG_TRANSFERENCIAS;
/