CREATE EDITIONABLE PACKAGE            SPKG_TAREAS_CAMBIO_EMPLEADO
AS
  /*
  * Documentaci�n para TYPE 'TypeInfoEmpleado'.
  * Record que me permite almancenar la informacion consultada del empleado
  */
TYPE TypeInfoEmpleado
IS
  RECORD
  (
    ID_PERSONA_ROL DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PERSONA DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    NOMBRES DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    APELLIDOS DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    LOGIN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    DEPARTAMENTO_ID DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
    NOMBRE_DEPARTAMENTO DB_GENERAL.ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
    ID_CANTON DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE );
  /**
  * Documentaci�n para la funci�n F_CAMBIO_EMPLEADO_TAREAS
  * La funci�n F_CAMBIO_EMPLEADO_TAREAS retorna un boolean indicando si se ha realizado el cambio de departamento de un empleado en una misma empresa
  *
  * @param  Fn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Recibe el id del
  * empleado que se ha cambiado de departamento
  * @param  Fn_IdEmpresaRolOld IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE Recibe el id de la empresa rol anterior del
  * empleado que se ha cambiado de departamento
  * @param  Fn_IdEmpresaRolNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE Recibe el id de la empresa rol nuevo del
  * empleado que se ha cambiado de departamento
  * @param  Fn_IdDepartamentoNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE Recibe el id del departamento
  * nuevo al que pertenecer� el empleado
  *
  * @return BOOLEAN
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 26-01-2017
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 03-02-2017 Se realizan las modificaciones respectivas debido al cambio en el trigger para la reasignaci�n de tareas,
  *                         variando los par�metros enviados a la funci�n as� como la respectiva consulta para obtener si ha existido un
  *                         cambio de departamento de un empleado
  *
  */
  FUNCTION F_CAMBIO_EMPLEADO_TAREAS(
      Fn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fn_IdEmpresaRolOld     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
      Fn_IdEmpresaRolNew     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
      Fn_IdDepartamentoNew   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE)
    RETURN BOOLEAN;
  /**
  * Documentaci�n para el procedimiento P_CAMBIO_EMPLEADO_TAREAS
  * El procedimiento P_GET_INFO_JEFE_DEP obtiene la informaci�n del jefe departamental de acuerdo al id y regi�n enviada como par�metro
  *
  * @param  Pv_Region IN VARCHAR2 Recibe el string de la regi�n a la que pertenece el empleado, es decir 'R1' o 'R2'
  * @param  Pn_IdDepartamento IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE Recibe el id del departamento del empleado
  * @param  Pv_EmpresaCod IN VARCHAR2 Recibe el string con el c�digo de la empresa
  *
  * @return Prf_InfoJefeDep  OUT SYS_REFCURSOR
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 26-01-2017
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 03-02-2017 Se realizan las modificaciones respectivas debido al cambio en el trigger para la reasignaci�n de tareas, variando
  *                         los par�metros enviados al procedimiento, as� como la respectiva consulta para obtener el cursor con la informaci�n
  *                         del jefe del departamento al que pertenec�a el empleado
  *
  */
  PROCEDURE P_GET_INFO_JEFE_DEP(
      Pv_Region         IN VARCHAR2,
      Pn_IdDepartamento IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
      Pv_EmpresaCod     IN VARCHAR2,
      Prf_InfoJefeDep OUT SYS_REFCURSOR );
  /**
  * Documentaci�n para el procedimiento P_REASIGNAR_TAREAS_JEFE_DEP
  * El procedimiento P_REASIGNAR_TAREAS_JEFE_DEP se encargar� de reasignar todas las tareas que se encuentran asignadas al empleado
  * que se ha cambiado de departamento y dichas tareas se encuentren abiertas
  *
  * @param  Pn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Recibe el id del
  * empleado que se ha cambiado de departamento
  * @param  Pn_IdOficinaOld IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE Recibe el id de la oficina a la que perteneci� el
  * empleado que se ha cambiado de departamento
  * @param  Pn_IdEmpresaRolOld IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE Recibe el id de la empresa rol anterior del
  * empleado que se ha cambiado de departamento
  * @param  Pn_IdDepartamentoOld IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE Recibe el id del departamento
  * anterior al que pertenec�a el empleado
  * @param  Pv_IpCreacionOld IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.IP_CREACION%TYPE Recibe la ip de creaci�n
  * @param  Pn_IdOficinaNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE Recibe el id de la oficina a la que pertenecer� el
  * empleado que se ha cambiado de departamento
  * @param  Pn_IdEmpresaRolNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE Recibe el id de la empresa rol actual del
  * empleado que se ha cambiadoNew de departamento
  * @param  Pn_IdDepartamentoNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE Recibe el id del departamento
  * anterior al que pertenec�a el empleado
  *
  * @return Pv_MensajeError    OUT VARCHAR2
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 26-01-2017
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 03-02-2017 Se realizan las modificaciones respectivas debido al cambio en el trigger que hace el llamado a este procedimiento,
  *                         variando los par�metros enviados y por ende modificando las funciones y procedimientos llamados en el interior de
  *                         de este procedimiento.
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.2 22-02-2017 Se realizan las modificaciones respectivas para verificar si el departamento anterior de un empleado es una divisi�n,
  *                         ya que si �ste fuera el caso las tareas permanecen con el mismo �ltimo estado y con el mismo registro de asignaci�n.
  *                         S�lo si la tarea est� asignada directamente al empleado, se procede a actualizar los campos referentes al departamento
  *                         en el registro de asignaci�n.
  *                         En ambos escenarios se ingresa un seguimiento informativo para conocer que se ha realizado la regularizaci�n de la tarea
  *                         por cambio de divisi�n.
  *                         Adem�s se agrega el nombre de la persona asignada cuando existe un cambio de departamento en el registro de reasignaci�n.
  *                         Costo de cursor C_GetDivisionYDep = 6
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.3 11-09-2017 - En la tabla INFO_DETALLE_HISTORIAL se agregan los campos de persona_empresa_rol_id,departamento_origen_id,
  *                           departamento_destino_id, accion y en la tabla INFO_TAREA_SEGUIMIENTO se agregan campos estado_tarea, departamento_id y
  *                           persona_empresa_rol_id
  */
  PROCEDURE P_REASIGNAR_TAREAS_JEFE_DEP(
      Pn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pn_IdOficinaOld        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE,
      Pn_IdEmpresaRolOld     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
      Pn_IdDepartamentoOld   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
      Pv_IpCreacionOld       IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.IP_CREACION%TYPE,
      Pn_IdOficinaNew        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE,
      Pn_IdEmpresaRolNew     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
      Pn_IdDepartamentoNew   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
      Pv_MensajeError OUT VARCHAR2);
END SPKG_TAREAS_CAMBIO_EMPLEADO;
/


CREATE EDITIONABLE PACKAGE BODY            SPKG_TAREAS_CAMBIO_EMPLEADO
AS
FUNCTION F_CAMBIO_EMPLEADO_TAREAS(
    Fn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Fn_IdEmpresaRolOld     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
    Fn_IdEmpresaRolNew     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
    Fn_IdDepartamentoNew   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE )
  RETURN BOOLEAN
IS
  CURSOR C_GetInfoCambioEmpleado( Cn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                  Cn_IdEmpresaRolOld IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE, 
                                  Cn_IdEmpresaRolNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE, 
                                  Cn_IdDepartamentoNew IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE )
  IS
    SELECT IPERANT.ID_PERSONA_ROL
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERANT
    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IERANT
    ON IERANT.ID_EMPRESA_ROL = IPERANT.EMPRESA_ROL_ID
    INNER JOIN DB_GENERAL.ADMI_ROL ARANT
    ON ARANT.ID_ROL = IERANT.ROL_ID
    INNER JOIN DB_GENERAL.ADMI_TIPO_ROL ATRANT
    ON ATRANT.ID_TIPO_ROL = ARANT.TIPO_ROL_ID
    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IERACT
    ON IERACT.ID_EMPRESA_ROL = Cn_IdEmpresaRolNew
    INNER JOIN DB_GENERAL.ADMI_ROL ARACT
    ON ARACT.ID_ROL = IERACT.ROL_ID
    INNER JOIN DB_GENERAL.ADMI_TIPO_ROL ATRACT
    ON ATRACT.ID_TIPO_ROL           = ARACT.TIPO_ROL_ID
    WHERE IPERANT.ID_PERSONA_ROL    = Cn_IdPersonaEmpresaRol
    AND IERANT.ID_EMPRESA_ROL       = Cn_IdEmpresaRolOld
    AND IPERANT.DEPARTAMENTO_ID     <> Cn_IdDepartamentoNew
    AND IPERANT.DEPARTAMENTO_ID    IS NOT NULL
    AND IERANT.EMPRESA_COD          = IERACT.EMPRESA_COD
    AND ATRACT.DESCRIPCION_TIPO_ROL = 'Empleado'
    AND ATRANT.DESCRIPCION_TIPO_ROL = 'Empleado';
  --
  Lc_GetInfoCambioEmpleado C_GetInfoCambioEmpleado%ROWTYPE;
  Lb_CambioDepartamento BOOLEAN;
  Lv_MensajeError       VARCHAR2(1000) := '';
  --
BEGIN
  Lb_CambioDepartamento := FALSE;
  --
  IF C_GetInfoCambioEmpleado%ISOPEN THEN
    CLOSE C_GetInfoCambioEmpleado;
  END IF;
  --
  --Si la variable no es nula existe un cambio de departamento dentro de la misma empresa
  IF Fn_IdDepartamentoNew IS NOT NULL THEN
    OPEN C_GetInfoCambioEmpleado( Fn_IdPersonaEmpresaRol, Fn_IdEmpresaRolOld, Fn_IdEmpresaRolNew, Fn_IdDepartamentoNew);
    --
    FETCH C_GetInfoCambioEmpleado INTO Lc_GetInfoCambioEmpleado;
    --
    CLOSE C_GetInfoCambioEmpleado;
    IF Lc_GetInfoCambioEmpleado.ID_PERSONA_ROL IS NOT NULL THEN
      --
      Lb_CambioDepartamento := TRUE;
      --
    END IF;
  END IF;
  --
  RETURN Lb_CambioDepartamento;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'SPKG_TAREAS_CAMBIO_EMPLEADO.F_CAMBIO_EMPLEADO_TAREAS', 
                                        Lv_MensajeError, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                        '127.0.0.1') 
                                      );
  --
  RETURN FALSE;
  --
END F_CAMBIO_EMPLEADO_TAREAS;
--
--
PROCEDURE P_GET_INFO_JEFE_DEP(
    Pv_Region         IN VARCHAR2,
    Pn_IdDepartamento IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
    Pv_EmpresaCod     IN VARCHAR2,
    Prf_InfoJefeDep OUT SYS_REFCURSOR )
AS
  Lv_MensajeError VARCHAR2(1000) := '';
BEGIN
  OPEN Prf_InfoJefeDep FOR 
  SELECT IPER.ID_PERSONA_ROL,
  IPERSONA.ID_PERSONA,
  IPERSONA.NOMBRES,
  IPERSONA.APELLIDOS,
  IPERSONA.LOGIN,
  IPER.DEPARTAMENTO_ID,
  AD.NOMBRE_DEPARTAMENTO,
  AC.ID_CANTON 
  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER 
  INNER JOIN DB_COMERCIAL.INFO_PERSONA IPERSONA 
  ON IPERSONA.ID_PERSONA = IPER.PERSONA_ID 
  INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER 
  ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID 
  INNER JOIN DB_GENERAL.ADMI_DEPARTAMENTO AD 
  ON AD.ID_DEPARTAMENTO = IPER.DEPARTAMENTO_ID 
  INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG 
  ON IOG.ID_OFICINA = IPER.OFICINA_ID 
  INNER JOIN DB_GENERAL.ADMI_CANTON AC 
  ON AC.ID_CANTON = IOG.CANTON_ID 
  INNER JOIN DB_GENERAL.ADMI_ROL AR 
  ON AR.ID_ROL = IER.ROL_ID 
  INNER JOIN DB_GENERAL.ADMI_TIPO_ROL ATR 
  ON ATR.ID_TIPO_ROL = AR.TIPO_ROL_ID 
  WHERE ATR.DESCRIPCION_TIPO_ROL = 'Empleado' 
  AND AR.ES_JEFE = 'S' 
  AND IER.EMPRESA_COD = Pv_EmpresaCod 
  AND IPER.DEPARTAMENTO_ID = Pn_IdDepartamento 
  AND AC.REGION = Pv_Region 
  AND IPER.ESTADO = 'Activo' 
  AND AR.ESTADO <> 'Eliminado' 
  AND ATR.ESTADO <> 'Eliminado' 
  AND ROWNUM < 2;
EXCEPTION
WHEN OTHERS THEN
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'SPKG_TAREAS_CAMBIO_EMPLEADO.P_GET_INFO_JEFE_DEP', 
                                        Lv_MensajeError, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                        '127.0.0.1') 
                                      );
END P_GET_INFO_JEFE_DEP;
--
--
PROCEDURE P_REASIGNAR_TAREAS_JEFE_DEP(
    Pn_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Pn_IdOficinaOld        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE,
    Pn_IdEmpresaRolOld     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
    Pn_IdDepartamentoOld   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
    Pv_IpCreacionOld       IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.IP_CREACION%TYPE,
    Pn_IdOficinaNew        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE,
    Pn_IdEmpresaRolNew     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE,
    Pn_IdDepartamentoNew   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE,
    Pv_MensajeError OUT VARCHAR2)
AS
  Lv_MsjError            VARCHAR2(1000) := '';
  Lv_MsjAsignacionTarea  VARCHAR2(1000) := '';
  Lv_MsjSeguimientoTarea VARCHAR2(1000) := '';
  Le_Exception           EXCEPTION;
  --Cursor para obtener la observaci�n del historial de una tarea cuando se realiza una reasignaci�n por cambio de departamento del empleado
  CURSOR C_GetParamObsCambioDep
  IS
    SELECT PC.NOMBRE_PARAMETRO,
      PD.ID_PARAMETRO_DET,
      PD.DESCRIPCION,
      PD.VALOR1
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC
    JOIN DB_GENERAL.ADMI_PARAMETRO_DET PD
    ON PC.ID_PARAMETRO        = PD.PARAMETRO_ID
    WHERE PC.NOMBRE_PARAMETRO = 'MSG_REASIGNACION_TAREA_CAMBIO_DEPARTAMENTO'
    AND ROWNUM                < 2;
  --Cursor para obtener las tareas que se encuentran asignadas al empleado que se cambi� de departamento
  CURSOR C_GetTareasAbiertasEmpleado(Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  IS
    SELECT IDE.ID_DETALLE,
      AT.NOMBRE_TAREA,
      IDA.ID_DETALLE_ASIGNACION,
      IDA.REF_ASIGNADO_ID,
      IDA.REF_ASIGNADO_NOMBRE,
      IDA.ASIGNADO_ID,
      IDA.ASIGNADO_NOMBRE,
      IDA.PERSONA_EMPRESA_ROL_ID,
      IDA.TIPO_ASIGNADO,
      IDH.ESTADO
    FROM DB_SOPORTE.INFO_DETALLE IDE
    INNER JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
    ON IDH.DETALLE_ID = IDE.ID_DETALLE
    INNER JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA
    ON IDA.DETALLE_ID = IDE.ID_DETALLE
    INNER JOIN DB_SOPORTE.ADMI_TAREA AT
    ON AT.ID_TAREA                 = IDE.TAREA_ID
    WHERE IDH.ID_DETALLE_HISTORIAL =
      (SELECT MAX(dhMax.ID_DETALLE_HISTORIAL)
      FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL dhMax
      WHERE dhMax.DETALLE_ID = IDH.DETALLE_ID
      )
  AND IDA.ID_DETALLE_ASIGNACION =
    (SELECT MAX(daMax.ID_DETALLE_ASIGNACION)
    FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION daMax
    WHERE daMax.DETALLE_ID = IDA.DETALLE_ID
    )
  AND IDA.PERSONA_EMPRESA_ROL_ID IS NOT NULL
  AND IDA.TIPO_ASIGNADO          IN ('CUADRILLA','EMPLEADO')
  AND IDH.ESTADO                 IN ('Aceptada','Asignada','Pausada','Reprogramada')
  AND IDA.PERSONA_EMPRESA_ROL_ID  = Cn_IdPersonaEmpresaRol;
  --
  CURSOR C_GetInfoPersonaEmpresaRol( Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                     Cn_IdOficinaOld DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.OFICINA_ID%TYPE, 
                                     Cn_IdEmpresaRolOld DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID%TYPE )
  IS
    SELECT IPER.ID_PERSONA_ROL,
      IPERSONA.ID_PERSONA,
      IPERSONA.NOMBRES,
      IPERSONA.APELLIDOS,
      IPERSONA.IDENTIFICACION_CLIENTE,
      IERANT.EMPRESA_COD AS EMPRESA_COD_ANTERIOR,
      IOFACPER.REGION_OFIC_ANTERIOR
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
    INNER JOIN DB_COMERCIAL.INFO_PERSONA IPERSONA
    ON IPERSONA.ID_PERSONA = IPER.PERSONA_ID
    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IERANT
    ON IERANT.ID_EMPRESA_ROL = Cn_IdEmpresaRolOld
    INNER JOIN
      (SELECT IOG.ID_OFICINA AS ID_OFIC_ANTERIOR,
        AC.REGION            AS REGION_OFIC_ANTERIOR
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      INNER JOIN DB_GENERAL.ADMI_CANTON AC
      ON AC.ID_CANTON                         = IOG.CANTON_ID
      WHERE IOG.ID_OFICINA                    = Cn_IdOficinaOld
      AND AC.REGION                          IS NOT NULL
      ) IOFACPER ON IOFACPER.ID_OFIC_ANTERIOR = Cn_IdOficinaOld
  WHERE IPER.ID_PERSONA_ROL                   = Cn_IdPersonaEmpresaRol
  AND ROWNUM                                  < 2;
  --
  --Cursor para obtener el mapeo de las divisiones con sus repectivos departamentos
  CURSOR C_GetDivisionYDep( Cn_IdDivisionDep DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.DEPARTAMENTO_ID%TYPE, Cv_CodEmpresaDivDep VARCHAR2)
  IS
    SELECT PCDIV.NOMBRE_PARAMETRO,
      PDDIV.ID_PARAMETRO_DET,
      ADDIV.ID_DEPARTAMENTO AS ID_DEP_DIVISION,
      PDDIV.VALOR1,
      PDDIV.VALOR2,
      AD.ID_DEPARTAMENTO AS ID_DEPARTAMENTO,
      AD.NOMBRE_DEPARTAMENTO
    FROM DB_GENERAL.ADMI_DEPARTAMENTO ADDIV
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PDDIV
    ON ADDIV.NOMBRE_DEPARTAMENTO = PDDIV.VALOR1
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PCDIV
    ON PCDIV.ID_PARAMETRO = PDDIV.PARAMETRO_ID
    INNER JOIN DB_GENERAL.ADMI_DEPARTAMENTO AD
    ON AD.NOMBRE_DEPARTAMENTO   = PDDIV.VALOR2
    WHERE ADDIV.ID_DEPARTAMENTO = Cn_IdDivisionDep
    AND PCDIV.NOMBRE_PARAMETRO  = 'MAPEO_DEPARTAMENTO_DIVISIONES_EMPLEADO'
    AND PDDIV.EMPRESA_COD       = Cv_CodEmpresaDivDep
    AND AD.EMPRESA_COD          = Cv_CodEmpresaDivDep
    AND PDDIV.ESTADO            = 'Activo'
    AND ROWNUM                  < 2;
  Lr_GetDivisionYDep C_GetDivisionYDep%ROWTYPE;
  Lr_GetInfoPersonaEmpresaRol C_GetInfoPersonaEmpresaRol%ROWTYPE;
  Lv_RegionAnteriorEmpleado     VARCHAR2(2);
  Lv_EmpresaCodAnteriorEmpleado VARCHAR2(2);
  Ln_IdDepAnteriorEmpleado      NUMBER;
  Lrf_GetInfoJefeDep SYS_REFCURSOR;
  Lr_GetInfoJefeDep TypeInfoEmpleado;
  Lr_GetParamObsCambioDep C_GetParamObsCambioDep%ROWTYPE;

BEGIN
  Lv_RegionAnteriorEmpleado     := '';
  Ln_IdDepAnteriorEmpleado      := 0;
  Lv_EmpresaCodAnteriorEmpleado := '';
  IF C_GetParamObsCambioDep%ISOPEN THEN
    CLOSE C_GetParamObsCambioDep;
  END IF;
  IF C_GetInfoPersonaEmpresaRol%ISOPEN THEN
    CLOSE C_GetInfoPersonaEmpresaRol;
  END IF;
  IF F_CAMBIO_EMPLEADO_TAREAS(Pn_IdPersonaEmpresaRol, Pn_IdEmpresaRolOld, Pn_IdEmpresaRolNew, Pn_IdDepartamentoNew) THEN
    OPEN C_GetParamObsCambioDep;
    FETCH C_GetParamObsCambioDep INTO Lr_GetParamObsCambioDep;
    OPEN C_GetInfoPersonaEmpresaRol(Pn_IdPersonaEmpresaRol, Pn_IdOficinaOld, Pn_IdEmpresaRolOld);
    FETCH C_GetInfoPersonaEmpresaRol INTO Lr_GetInfoPersonaEmpresaRol;
    IF (C_GetInfoPersonaEmpresaRol%found AND C_GetParamObsCambioDep%found ) THEN
      Lv_RegionAnteriorEmpleado     := Lr_GetInfoPersonaEmpresaRol.REGION_OFIC_ANTERIOR;
      Ln_IdDepAnteriorEmpleado      := Pn_IdDepartamentoOld;
      Lv_EmpresaCodAnteriorEmpleado := Lr_GetInfoPersonaEmpresaRol.EMPRESA_COD_ANTERIOR;
      OPEN C_GetDivisionYDep(Ln_IdDepAnteriorEmpleado, Lv_EmpresaCodAnteriorEmpleado);
      FETCH C_GetDivisionYDep INTO Lr_GetDivisionYDep;
      IF (C_GetDivisionYDep%found) THEN
        FOR I_GetTareasAbiertasEmpleado IN C_GetTareasAbiertasEmpleado(Pn_IdPersonaEmpresaRol)
        LOOP
          IF I_GetTareasAbiertasEmpleado.TIPO_ASIGNADO = 'EMPLEADO' THEN
            Lv_MsjSeguimientoTarea                    := 'Tarea gestionada por asignaci�n a empleado regularizado por divisi�n departamental';
            UPDATE DB_SOPORTE.INFO_DETALLE_ASIGNACION
            SET DEPARTAMENTO_ID         = Ln_IdDepAnteriorEmpleado, 
            ASIGNADO_ID = Lr_GetDivisionYDep.ID_DEPARTAMENTO,
            ASIGNADO_NOMBRE = Lr_GetDivisionYDep.NOMBRE_DEPARTAMENTO
            WHERE ID_DETALLE_ASIGNACION = I_GetTareasAbiertasEmpleado.ID_DETALLE_ASIGNACION;
          ELSE
            Lv_MsjSeguimientoTarea := 'Tarea gestionada por asignaci�n a cuadrilla de empleado regularizado por divisi�n departamental';
          END IF;
          INSERT
          INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO
            (
              ID_SEGUIMIENTO,
              DETALLE_ID,
              OBSERVACION,
              USR_CREACION,
              FE_CREACION,
              EMPRESA_COD,
              ESTADO_TAREA,
              DEPARTAMENTO_ID,
              PERSONA_EMPRESA_ROL_ID
            )
            VALUES
            (
              DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,
              I_GetTareasAbiertasEmpleado.ID_DETALLE,
              Lv_MsjSeguimientoTarea,
              'regulariza_emp',
              CURRENT_TIMESTAMP,
              Lv_EmpresaCodAnteriorEmpleado,
              I_GetTareasAbiertasEmpleado.ESTADO,
              Ln_IdDepAnteriorEmpleado,
              Pn_IdPersonaEmpresaRol
            );
          COMMIT;
        END LOOP;
      ELSE
        Lv_MsjAsignacionTarea  := 'Tarea Reasignada autom�ticamente a ';
        Lv_MsjSeguimientoTarea := 'Tarea es reasignada autom�ticamente a ';
        P_GET_INFO_JEFE_DEP(Lv_RegionAnteriorEmpleado, Ln_IdDepAnteriorEmpleado, Lv_EmpresaCodAnteriorEmpleado, Lrf_GetInfoJefeDep);
        FETCH Lrf_GetInfoJefeDep INTO Lr_GetInfoJefeDep;
        IF Lr_GetInfoJefeDep.ID_PERSONA_ROL IS NOT NULL THEN
          Lv_MsjAsignacionTarea             := Lv_MsjAsignacionTarea || Lr_GetInfoJefeDep.NOMBRES || ' ' || Lr_GetInfoJefeDep.APELLIDOS 
                                               || ' por cambio de departamento del �lltimo empleado asignado';
          Lv_MsjSeguimientoTarea            := Lv_MsjSeguimientoTarea || Lr_GetInfoJefeDep.NOMBRES || ' ' || Lr_GetInfoJefeDep.APELLIDOS 
                                               || ' por cambio de departamento del �lltimo empleado asignado';
          FOR I_GetTareasAbiertasEmpleado IN C_GetTareasAbiertasEmpleado(Pn_IdPersonaEmpresaRol)
          LOOP
            INSERT
            INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL
              (
                ID_DETALLE_HISTORIAL,
                DETALLE_ID,
                OBSERVACION,
                ESTADO,
                USR_CREACION,
                FE_CREACION,
                IP_CREACION,
                PERSONA_EMPRESA_ROL_ID,
                DEPARTAMENTO_ORIGEN_ID,
                DEPARTAMENTO_DESTINO_ID,
                ACCION
              )
              VALUES
              (
                DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,
                I_GetTareasAbiertasEmpleado.ID_DETALLE,
                Lr_GetParamObsCambioDep.VALOR1,
                'Asignada',
                Lr_GetInfoJefeDep.LOGIN,
                CURRENT_TIMESTAMP,
                Pv_IpCreacionOld,
                Lr_GetInfoJefeDep.ID_PERSONA_ROL,
                Lr_GetInfoJefeDep.DEPARTAMENTO_ID,
                Lr_GetInfoJefeDep.DEPARTAMENTO_ID,
                'Asignada'
              );
            INSERT
            INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION
              (
                ID_DETALLE_ASIGNACION,
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
                DEPARTAMENTO_ID,
                CANTON_ID
              )
              VALUES
              (
                DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL,
                I_GetTareasAbiertasEmpleado.ID_DETALLE,
                Lr_GetInfoJefeDep.DEPARTAMENTO_ID,
                Lr_GetInfoJefeDep.NOMBRE_DEPARTAMENTO,
                Lr_GetInfoJefeDep.ID_PERSONA,
                Lr_GetInfoJefeDep.NOMBRES
                || ' '
                || Lr_GetInfoJefeDep.APELLIDOS,
                Lv_MsjAsignacionTarea,
                Lr_GetInfoJefeDep.LOGIN,
                CURRENT_TIMESTAMP,
                Pv_IpCreacionOld,
                Lr_GetInfoJefeDep.ID_PERSONA_ROL,
                'EMPLEADO',
                Lr_GetInfoJefeDep.DEPARTAMENTO_ID,
                Lr_GetInfoJefeDep.ID_CANTON
              );
            INSERT
            INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO
              (
                ID_SEGUIMIENTO,
                DETALLE_ID,
                OBSERVACION,
                USR_CREACION,
                FE_CREACION,
                EMPRESA_COD,
                ESTADO_TAREA,
                DEPARTAMENTO_ID,
                PERSONA_EMPRESA_ROL_ID
              )
              VALUES
              (
                DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,
                I_GetTareasAbiertasEmpleado.ID_DETALLE,
                Lv_MsjSeguimientoTarea,
                Lr_GetInfoJefeDep.LOGIN,
                CURRENT_TIMESTAMP,
                Lv_EmpresaCodAnteriorEmpleado,
                'Asignada',
                Ln_IdDepAnteriorEmpleado,
                Lr_GetInfoJefeDep.ID_PERSONA_ROL
              );
            COMMIT;
          END LOOP;
        ELSE
          Lv_MsjError := 'No se pudo obtener la informacion del jefe del empleado con ID_PERSONA_ROL: ' || Pn_IdPersonaEmpresaRol;
          RAISE Le_Exception;
        END IF;--IF Lr_GetInfoJefeDep.ID_PERSONA_ROL
      END IF;--IF (C_GetDivisionYDep%found)
    ELSE
      Lv_MsjError := 'No se pudo obtener la informacion del empleado: ID_PERSONA_ROL: ' || Pn_IdPersonaEmpresaRol 
                     || ' o no se encuentra el valor para el parametro MSG_REASIGNACION_TAREA_CAMBIO_DEPARTAMENTO';
      RAISE Le_Exception;
    END IF;--IF (C_GetInfoPersonaEmpresaRol%found AND C_GetParamObsCambioDep%found)
    CLOSE C_GetParamObsCambioDep;
    CLOSE C_GetInfoPersonaEmpresaRol;
  END IF; --IF F_CAMBIO_EMPLEADO_TAREAS(Pn_IdPersonaEmpresaRol, Pn_IdEmpresaRol, Pn_IdDepartamento)
  IF C_GetTareasAbiertasEmpleado%ISOPEN THEN
    CLOSE C_GetTareasAbiertasEmpleado;
  END IF;
  IF C_GetParamObsCambioDep%ISOPEN THEN
    CLOSE C_GetParamObsCambioDep;
  END IF;
  IF C_GetInfoPersonaEmpresaRol%ISOPEN THEN
    CLOSE C_GetInfoPersonaEmpresaRol;
  END IF;
EXCEPTION
WHEN Le_Exception THEN
  ROLLBACK;
  Pv_MensajeError := Lv_MsjError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'SPKG_TAREAS_CAMBIO_EMPLEADO.P_REASIGNAR_TAREAS_JEFE_DEP', 
                                        Pv_MensajeError, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                        '127.0.0.1') 
                                      );
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MensajeError := Lv_MsjError || '-' || SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'SPKG_TAREAS_CAMBIO_EMPLEADO.P_REASIGNAR_TAREAS_JEFE_DEP', 
                                        Pv_MensajeError, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                        '127.0.0.1') 
                                      );
END P_REASIGNAR_TAREAS_JEFE_DEP;
END SPKG_TAREAS_CAMBIO_EMPLEADO;
/