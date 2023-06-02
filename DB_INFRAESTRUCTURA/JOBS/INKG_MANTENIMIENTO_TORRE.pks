CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_MANTENIMIENTO_TORRE 
AS 

/*
 * Procedimiento que realiza la verificacion de nodos,
 * donde se encuentran las Torres que cumplen el tiempo para el Mantenimiento Preventivo.

 *
 * @author Adrian Ortega <amortega@telconet.ec>
 * @version 1.0 27-08-2019
 * @param  VARCHAR2  Pv_DetalleValor Fecha actual para la busqueda de proximo Mantenimiento de cada Torre.
 * @return VARCHAR2  Pv_Mensaje      Mensaje de confirmacion - error del procedimiento.
 *
 */
  PROCEDURE P_PROXIMO_MANTENIMIENTO (
    Pv_DetalleValor IN VARCHAR2, 
    Pv_Mensaje OUT VARCHAR2);
    
/*
 * Procedimiento para envio de notificaciones a Coordinadores de acuerdo a su jurisdiccion,
 * para el Mantenimiento Preventivo de Torres TN.

 *
 * @author Adrian Ortega <amortega@telconet.ec>
 * @version 1.0 27-08-2019
 * @param  INTEGER   Pn_IdNodo        Id del Nodo donde se encuentra la Torre.
 * @param  VARCHAR2  Pv_DetalleValor  Fecha del mantenimiento.
 * @param  VARCHAR2  Pv_Usuario       Usuario que realiza la ejecucion.
 * @param  VARCHAR2  Pv_Ip            Ip de Usuario que realiza la ejecucion.
 * @return VARCHAR2  Lv_Mensaje       Mensaje de confimacion - error del procedimiento.
 *
 */
  PROCEDURE P_ENVIO_NOTIFICACION (
    Pn_IdNodo IN INTEGER,
    Pv_DetalleValor IN VARCHAR2,
    Pv_Usuario IN VARCHAR2,
    Pv_Ip IN VARCHAR2, 
    Pv_Mensaje OUT VARCHAR2);

/*
 * Procedimiento para crear tarea a Coordinadores,
 * para el Mantenimiento Preventivo de Torres TN.
 *
 * @author Adrian Ortega <amortega@telconet.ec>
 * @version 1.0 27-08-2019
 * @param  VARCHAR2  Pv_Login      Login del usuario para tomar la informacion y crear tarea.
 * @param  VARCHAR2  Pv_NombreNodo Nombre del Nodo.
 * @param  VARCHAR2  Pv_Usuario    Usuario que crea la tarea.
 * @param  VARCHAR2  Pv_Ip         Ip de donde se envia a crear la tarea.
 * @return VARCHAR2  Lv_Mensaje    Mensaje de confimacion - error del procedimiento.
 *
 */
  PROCEDURE P_CREACION_TAREA (
    Pv_Login IN VARCHAR2,
    Pv_NombreNodo IN VARCHAR2,
    Pv_Usuario IN VARCHAR2,
    Pv_Ip IN VARCHAR2,
    Pv_Mensaje OUT VARCHAR2);
 
END INKG_MANTENIMIENTO_TORRE;
/


CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_MANTENIMIENTO_TORRE 
AS

/*
 * Procedimiento que realiza la verificacion de nodos,
 * donde se encuentras las Torres que cumplen el tiempo para el Mantenimiento Preventivo.

 *
 * @author Adrian Ortega <amortega@telconet.ec>
 * @version 1.0 27-08-2019
 * @param  VARCHAR2  Pv_DetalleValor Fecha actual para la busqueda de proximo Mantenimiento de cada Torre.
 * @return VARCHAR2  Pv_Mensaje      Mensaje de confimacion - error del procedimeinto.
 *
 */

PROCEDURE P_PROXIMO_MANTENIMIENTO (
  Pv_DetalleValor IN VARCHAR2,
  Pv_Mensaje OUT VARCHAR2) 
AS
  CURSOR C_GetDetalleElemento(Cv_DetalleValor VARCHAR2)
  IS
    SELECT IE.ID_ELEMENTO
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE, 
      DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE 
    WHERE IE.ID_ELEMENTO=IDE.ELEMENTO_ID 
    AND IDE.DETALLE_NOMBRE = 'PROXIMO MANTENIMIENTO TORRE' 
    AND IDE.DETALLE_VALOR  = Cv_DetalleValor 
    AND IDE.ESTADO         = 'Activo';

  Le_Exception   EXCEPTION ;
  Lv_Error       VARCHAR2(2000);

BEGIN

  FOR I_GetDetalleElemento IN C_GetDetalleElemento(Pv_DetalleValor)  
  LOOP
    --SE NOTIFICA MANTENIMIENTO PARA EL ELEMENTO ENCONTRADO
    DB_INFRAESTRUCTURA.INKG_MANTENIMIENTO_TORRE.P_ENVIO_NOTIFICACION(I_GetDetalleElemento.ID_ELEMENTO,
                                                                     Pv_DetalleValor,
                                                                     NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'),
                                                                     Lv_Error);

    IF Lv_Error = 'SUCCESS' THEN
      Pv_Mensaje := Lv_Error;
    ELSE
      Pv_Mensaje := Lv_Error;
      RAISE Le_Exception;
    END IF;

  END LOOP;

EXCEPTION
  WHEN Le_Exception THEN 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MANTENIMIENTO_TORRE.P_PROXIMO_MANTENIMIENTO', 
                                            Pv_Mensaje||' - '||SQLERRM, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MANTENIMIENTO_TORRE.P_PROXIMO_MANTENIMIENTO', 
                                            Pv_Mensaje||' - '||SQLERRM, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );                                           

END P_PROXIMO_MANTENIMIENTO;

/*
 * Procedimiento para envio de notificaciones a Coordinadores de acuerdo a su jurisdiccion,
 * para el Mantenimiento Preventivo de Torres TN.

 *
 * @author Adrian Ortega <amortega@telconet.ec>
 * @version 1.0 27-08-2019
 * @param  INTEGER   Pn_IdNodo        Id del Nodo donde se encuentra la Torre.
 * @param  VARCHAR2  Pv_DetalleValor  Fecha del mantenimiento.
 * @param  VARCHAR2  Pv_Usuario       Usuario que realiza la ejecucion.
 * @param  VARCHAR2  Pv_Ip            Ip de Usuario que realiza la ejecucion.
 * @return VARCHAR2  Lv_Mensaje       Mensaje de confimacion - error del procedimiento.
 *
 */

PROCEDURE P_ENVIO_NOTIFICACION (
  Pn_IdNodo IN INTEGER,
  Pv_DetalleValor IN VARCHAR2,
  Pv_Usuario IN VARCHAR2,
  Pv_Ip IN VARCHAR2, 
  Pv_Mensaje OUT VARCHAR2 )

AS
  CURSOR C_GetInfoNodo(Cn_IdNodo INTEGER)
  IS
    SELECT IU.DIRECCION_UBICACION, ACA.NOMBRE_CANTON, 
      ACA.REGION, ACA.JURISDICCION
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
      DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEU,
      DB_INFRAESTRUCTURA.INFO_UBICACION IU,
      DB_GENERAL.ADMI_PARROQUIA APA,
      DB_GENERAL.ADMI_CANTON ACA
    WHERE IE.ID_ELEMENTO = Cn_IdNodo
    AND IE.ID_ELEMENTO   = IEU.ELEMENTO_ID
    AND IEU.UBICACION_ID = IU.ID_UBICACION
    AND IU.PARROQUIA_ID  = APA.ID_PARROQUIA
    AND APA.CANTON_ID    = ACA.ID_CANTON
    AND ROWNUM = 1;

  CURSOR C_GetParametros (Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
  IS
    SELECT APD.VALOR1,
      APD.VALOR2,
      APD.VALOR3,
      APD.VALOR4,
      APD.VALOR5,
      APD.VALOR6
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
         )
    AND APD.DESCRIPCION = Cv_DescripcionParametro;

  CURSOR C_GetDetalleElemento(Cn_IdNodo INTEGER, Cv_DetalleNombre VARCHAR2)
  IS
    SELECT ID_DETALLE_ELEMENTO,
      DETALLE_VALOR,
      DETALLE_DESCRIPCION
    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
    WHERE ELEMENTO_ID  = Cn_IdNodo
    AND DETALLE_NOMBRE = Cv_DetalleNombre
    AND ESTADO         = 'Activo';
  
  CURSOR C_GetCiclo(Cn_IdNodo INTEGER)
  IS
    SELECT
        IE.NOMBRE_ELEMENTO,
        IE.ESTADO,
        IDE.DETALLE_VALOR
    FROM
        DB_INFRAESTRUCTURA.INFO_ELEMENTO           IE,
        DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO   IDE
    WHERE
        IE.ID_ELEMENTO = IDE.ELEMENTO_ID
        AND IDE.DETALLE_NOMBRE = 'MANTENIMIENTO TORRE'
        AND IE.ESTADO = 'Activo'
        AND ID_ELEMENTO = Cn_IdNodo;

  CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  IS
    SELECT APA.PLANTILLA
    FROM DB_COMUNICACION.ADMI_PLANTILLA APA 
    WHERE APA.CODIGO = Cv_CodigoPlantilla
    AND APA.ESTADO  <> 'Eliminado';

  -- INFORMACION DEL NODO
  Lv_NombreNodo         VARCHAR2(400);
  Lv_EstadoNodo         VARCHAR2(400);
  Lv_DireccionNodo      VARCHAR2(400);
  Lv_Canton             VARCHAR2(400);
  Lv_Region             VARCHAR2(400);
  Lv_Jurisdiccion       VARCHAR2(400);
  Lv_CicloMantenimiento VARCHAR2(400);
  -- DETALLE DE NOTIFICACION
  Lv_Remitente          VARCHAR2(400);
  Lv_Login              VARCHAR2(400);
  Lv_Correo             VARCHAR2(400);
  Lv_Destinatario       VARCHAR2(400);
  Lv_CorreoLogin        VARCHAR2(400);
  Lv_Asunto             VARCHAR2(400);
  Lcl_PlantillaNotifica CLOB;
  Lcl_Plantilla         CLOB;
  Ln_IdDetalleElemento  NUMBER;

  Lr_InfoParametros     C_GetParametros%ROWTYPE;
  Lr_DetalleElemento    C_GetDetalleElemento%ROWTYPE;
  Lr_GetInfoNodo        C_GetInfoNodo%ROWTYPE;
  Lr_GetCiclo           C_GetCiclo%ROWTYPE;
  Lv_NombreParametro    VARCHAR2(400)  := 'MANTENIMIENTO TORRES';
  Lv_DetalleNombre      VARCHAR2(400)  := 'PROXIMO MANTENIMIENTO TORRE';
  Ld_ProximaFecha       VARCHAR2(400);
  Lv_DetalleDescripcion VARCHAR2(400);
  Lv_DescripParametro   VARCHAR2(400);
  Le_Exception          EXCEPTION;
  Lv_Error              VARCHAR2(4000);


BEGIN
  IF C_GetCiclo%ISOPEN THEN
    CLOSE C_GetCiclo;
  END IF;

  OPEN C_GetCiclo(Pn_IdNodo);
  FETCH C_GetCiclo 
  INTO Lr_GetCiclo;
  IF C_GetCiclo%FOUND THEN 
    Lv_NombreNodo          := Lr_GetCiclo.NOMBRE_ELEMENTO;
    Lv_EstadoNodo          := Lr_GetCiclo.ESTADO;
    Lv_CicloMantenimiento  := Lr_GetCiclo.DETALLE_VALOR;
  ELSE
    Lv_Error := 'Esta Torre no contiene un ciclo de Mantenimiento';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetCiclo;

  IF C_GetPlantilla%ISOPEN THEN
    CLOSE C_GetPlantilla;
  END IF;

  OPEN C_GetPlantilla('MANT_TORRES');
  FETCH C_GetPlantilla 
  INTO Lcl_Plantilla;
  CLOSE C_GetPlantilla;

  IF C_GetInfoNodo%ISOPEN THEN
    CLOSE C_GetInfoNodo;
  END IF;

  OPEN C_GetInfoNodo(Pn_IdNodo);
  FETCH C_GetInfoNodo 
  INTO Lr_GetInfoNodo;
  IF C_GetInfoNodo%FOUND THEN 
    Lv_DireccionNodo  := Lr_GetInfoNodo.DIRECCION_UBICACION;
    Lv_Canton         := Lr_GetInfoNodo.NOMBRE_CANTON;
    Lv_Region         := Lr_GetInfoNodo.REGION;
    Lv_Jurisdiccion   := Lr_GetInfoNodo.JURISDICCION;
  ELSE
    Lv_Error := 'No existe informacion de la ubicacion del elemento';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetInfoNodo;

  Lv_DescripParametro := 'PARAMETROS NOTIFICACIONES';
  OPEN C_GetParametros (Lv_NombreParametro,Lv_DescripParametro);
  FETCH C_GetParametros 
  INTO Lr_InfoParametros;
  IF C_GetParametros%FOUND THEN 
    Lv_Remitente  := Lr_InfoParametros.VALOR1;
    Lv_Correo     := Lr_InfoParametros.VALOR2;
    Lv_Asunto     := Lr_InfoParametros.VALOR5;
  ELSE
    Lv_Error := 'No existe informacion de los parametros para notificar';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetParametros;

  IF C_GetDetalleElemento%ISOPEN THEN
    CLOSE C_GetDetalleElemento;
  END IF;
  OPEN C_GetDetalleElemento (Pn_IdNodo,Lv_DetalleNombre);
  FETCH C_GetDetalleElemento 
  INTO Lr_DetalleElemento;
  IF C_GetDetalleElemento%FOUND THEN 
    Ln_IdDetalleElemento  := Lr_DetalleElemento.ID_DETALLE_ELEMENTO;
    Lv_DetalleDescripcion := Lr_DetalleElemento.DETALLE_DESCRIPCION;
    Ld_ProximaFecha       := TO_CHAR(ADD_MONTHS(TO_DATE(Pv_DetalleValor,'DD/MM/YYYY'), Lv_CicloMantenimiento),'DD/MM/YYYY');

  ELSE
    Lv_Error := 'No existen detalles de mantenimiento para este elemento';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetDetalleElemento;


  --PLANTILLA DE NOTIFICACION DEL NODO DONDE ESTA UBICADA LA TORRE
  Lcl_PlantillaNotifica := Lcl_Plantilla;
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ Nodo }}', Lv_NombreNodo);
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ Ubicacion }}', Lv_DireccionNodo);              
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ Canton }}', Lv_Canton);
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ Region }}', Lv_Region);
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ cicloMantenimiento }}', Lv_CicloMantenimiento);
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ nombreJurisdiccion }}', Lv_Jurisdiccion);
  Lcl_PlantillaNotifica := REPLACE(Lcl_PlantillaNotifica,'{{ estadoNodo }}', Lv_EstadoNodo);


  IF Lv_Region = 'R1' THEN
    --NOTIFICACIONES PARA JURISDICCION REGION 1
    Lv_DescripParametro := 'PARAMETRO PARA ASIGNAR TAREA R1';
    OPEN C_GetParametros (Lv_NombreParametro,Lv_DescripParametro);
    FETCH C_GetParametros 
    INTO Lr_InfoParametros;
    CLOSE C_GetParametros;

    Lv_Login        := Lr_InfoParametros.VALOR3;
    Lv_CorreoLogin  := Lr_InfoParametros.VALOR4;
    Lv_Destinatario := Lv_CorreoLogin||';'||Lv_Correo;

    DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(Lv_Remitente,
                                                  Lv_Destinatario,
                                                  Lv_Asunto,
                                                  Lcl_PlantillaNotifica,
                                                  'text/html; charset=UTF-8',
                                                  Lv_Error);
    --CREAR TAREA                                          
    DB_INFRAESTRUCTURA.INKG_MANTENIMIENTO_TORRE.P_CREACION_TAREA(Lv_Login,
                                                                 Lv_NombreNodo,
                                                                 Pv_Usuario,
                                                                 Pv_Ip,
                                                                 Lv_Error);
    IF Lv_Error ='ok' THEN

      -- SE EDITA EL DETALLE A ESTADO INACTIVO
      UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO 
       SET ESTADO = 'Inactivo' 
      WHERE ELEMENTO_ID = Pn_IdNodo 
      AND ID_DETALLE_ELEMENTO = Ln_IdDetalleElemento;

      -- SE INGRESA EL NUEVO DETALLE
      INSERT INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        (ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO)
        VALUES
        (DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL,
        Pn_IdNodo,
        Lv_DetalleNombre,
        Ld_ProximaFecha,
        Lv_DetalleDescripcion,
        Pv_Usuario,
        SYSDATE,
        Pv_Ip,
        NULL,
        'Activo'        
        );

      Pv_Mensaje :='SUCCESS';
    ELSE 
      Lv_Error := 'No se pudo crear la tarea. Por Favor Notificar a Sistemas';
      RAISE Le_Exception;      
    END IF;

  --NOTIFICACIONES PARA JURISDICCION REGION 2  
  ELSIF Lv_Region = 'R2' THEN
    Lv_DescripParametro := 'PARAMETRO PARA ASIGNAR TAREA R2';
    OPEN C_GetParametros (Lv_NombreParametro,Lv_DescripParametro);
    FETCH C_GetParametros 
    INTO Lr_InfoParametros;
    CLOSE C_GetParametros;

    Lv_Login        := Lr_InfoParametros.VALOR3;
    Lv_CorreoLogin  := Lr_InfoParametros.VALOR4;
    Lv_Destinatario := Lv_CorreoLogin||';'||Lv_Correo;

    DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(Lv_Remitente,
                                                  Lv_Destinatario,
                                                  Lv_Asunto,
                                                  Lcl_PlantillaNotifica,
                                                  'text/html; charset=UTF-8',
                                                  Lv_Error);

    --CREAR TAREA                                          
    DB_INFRAESTRUCTURA.INKG_MANTENIMIENTO_TORRE.P_CREACION_TAREA(Lv_Login,
                                                                 Lv_NombreNodo,
                                                                 Pv_Usuario,
                                                                 Pv_Ip,
                                                                 Lv_Error);
    IF Lv_Error = 'ok' THEN

      -- SE EDITA EL DETALLE A ESTADO INACTIVO
      UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO 
       SET ESTADO = 'Inactivo' 
      WHERE ELEMENTO_ID = Pn_IdNodo 
      AND ID_DETALLE_ELEMENTO = Ln_IdDetalleElemento;

      -- SE INGRESA EL NUEVO DETALLE
      INSERT INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        (ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO)
        VALUES
        (DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL,
        Pn_IdNodo,
        Lv_DetalleNombre,
        Ld_ProximaFecha,
        Lv_DetalleDescripcion,
        Pv_Usuario,
        SYSDATE,
        Pv_Ip,
        NULL,
        'Activo'        
        );
      Pv_Mensaje :='SUCCESS';
    ELSE 
      Lv_Error := 'No se pudo crear la tarea. Por Favor Notificar a Sistemas';
      RAISE Le_Exception;   
    END IF;


  ELSE
    Lv_Error := 'No existen datos de coordinador asociado al nodo para poder notificar';
    RAISE Le_Exception;
  END IF;
  COMMIT;

  Pv_Mensaje:='SUCCESS';
EXCEPTION
WHEN Le_Exception THEN
  ROLLBACK;
  Pv_Mensaje := Lv_Error;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MANTENIMIENTO_TORRE.P_ENVIO_NOTIFICACION', 
                                            Pv_Mensaje||' - '||SQLERRM, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

WHEN OTHERS THEN
  ROLLBACK;
  Pv_Mensaje := 'Ocurrio un problema al generar el registro de Mantenimiento, Por Favor Notificar a Sistemas';  
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MANTENIMIENTO_TORRE.P_ENVIO_NOTIFICACION', 
                                            Pv_Mensaje||' - '||SQLERRM, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

END P_ENVIO_NOTIFICACION;


/*
 * Procedimiento para crear tarea a Coordinadores,
 * para el Mantenimiento Preventivo de Torres TN.
 *
 * @author Adrian Ortega <amortega@telconet.ec>
 * @version 1.0 27-08-2019
 * @param  VARCHAR2  Pv_Login      Login del usuario para tomar la informacion y crear tarea.
 * @param  VARCHAR2  Pv_NombreNodo Nombre del Nodo.
 * @param  VARCHAR2  Pv_Usuario    Usuario que crea la tarea.
 * @param  VARCHAR2  Pv_Ip         Ip de donde se envia a crear la tarea.
 * @return VARCHAR2  Lv_Mensaje    Mensaje de confimacion - error del procedimiento.
 *
 */

PROCEDURE P_CREACION_TAREA (
     Pv_Login IN VARCHAR2,
     Pv_NombreNodo IN VARCHAR2,
     Pv_Usuario IN VARCHAR2,
     Pv_Ip IN VARCHAR2, 
     Pv_Mensaje OUT VARCHAR2)
AS

  CURSOR C_GetEmpleado (Cv_Login VARCHAR2)
  IS
    SELECT IPR.ID_PERSONA_ROL 
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPR,
         DB_COMERCIAL.INFO_PERSONA IPE,
         DB_COMERCIAL.INFO_EMPRESA_ROL IER,
         DB_COMERCIAL.ADMI_ROL ARO,
         DB_COMERCIAL.ADMI_TIPO_ROL ATR
    WHERE IPR.PERSONA_ID         = IPE.ID_PERSONA
    AND IPR.EMPRESA_ROL_ID       = IER.ID_EMPRESA_ROL
    AND IER.ROL_ID               = ARO.ID_ROL
    AND ARO.TIPO_ROL_ID          = ATR.ID_TIPO_ROL
    AND IPE.LOGIN                = Cv_Login 
    AND IER.EMPRESA_COD          = 10
    AND ATR.DESCRIPCION_TIPO_ROL = 'Empleado'
    AND IPR.ESTADO               = 'Activo';

  CURSOR C_GetParametros (Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
  IS
    SELECT APD.VALOR1,
      APD.VALOR2,
      APD.VALOR3,
      APD.VALOR4,
      APD.VALOR5,
      APD.VALOR6
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID =
        (SELECT APC.id_parametro
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
         )
    AND APD.DESCRIPCION = Cv_DescripcionParametro;

  Lv_PrefijoEmpresa   VARCHAR2(10);
  Lv_FormaContacto    VARCHAR2(20);
  Ln_Empleado         NUMBER;
  --INFORMACION DE LA TAREA
  Lv_Asignacion       VARCHAR2(2)   := 'NO';
  Lv_NombreProceso    VARCHAR2(400); 
  Lv_NombreTarea      VARCHAR2(400);
  Lv_Sintoma          VARCHAR2(400);
  Lv_Afectados        VARCHAR2(10);
  Lv_Cuadrilla        VARCHAR2(10);
  Lv_TipoAsignacion   VARCHAR2(400);
  Lv_MotivoTarea      VARCHAR2(400);
  Lv_Observacion      VARCHAR2(400);
  Lcl_TareaA          CLOB;
  Lcl_JsonTarea       CLOB;
  Lv_RespuestaCaso    VARCHAR2(4000);
  Lcl_MensajeError    CLOB;
  Lv_Status           VARCHAR2(4000);
  Ln_NoTarea          NUMBER;
  Lv_URLSoporte       VARCHAR2(800);
  Lr_InfoParametros   C_GetParametros%ROWTYPE;
  Le_Exception        EXCEPTION;
  Lv_Error            VARCHAR2(4000);

  Lv_NombreParametro  VARCHAR2(400) := 'MANTENIMIENTO TORRES';
  Lv_DescripParametro VARCHAR2(400);

BEGIN
  IF C_GetEmpleado%ISOPEN THEN
    CLOSE C_GetEmpleado;
  END IF;

  OPEN C_GetEmpleado (Pv_Login);
  FETCH C_GetEmpleado
  INTO Ln_Empleado;
  CLOSE C_GetEmpleado;
  
  IF Ln_Empleado IS NULL THEN
    Lv_Error := 'No existe data del empleado para crear Tarea';
    Raise Le_Exception;
    
  END IF;
  
  IF C_GetParametros%ISOPEN THEN
    CLOSE C_GetParametros;
  END IF;
  Lv_DescripParametro := 'PARAMETRO PARA CREAR TAREA';
  OPEN C_GetParametros (Lv_NombreParametro,Lv_DescripParametro);
  FETCH C_GetParametros 
  INTO Lr_InfoParametros;

  IF C_GetParametros%FOUND THEN
    Lv_NombreTarea    := Lr_InfoParametros.VALOR1;
    Lv_MotivoTarea    := Lr_InfoParametros.VALOR2;
    Lv_NombreProceso  := Lr_InfoParametros.VALOR3;
    Lv_Observacion    := Lr_InfoParametros.VALOR4;
    Lv_Sintoma        := Lr_InfoParametros.VALOR5;
    Lv_TipoAsignacion := Lr_InfoParametros.VALOR6;  
  ELSE
    Lv_Error := 'No existen detalles de parametros para crear tarea';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetParametros;

  IF C_GetParametros%ISOPEN THEN
    CLOSE C_GetParametros;
  END IF;
  
  Lv_DescripParametro := 'PARAMETROS NOTIFICACIONES';
  OPEN C_GetParametros (Lv_NombreParametro,Lv_DescripParametro);
  FETCH C_GetParametros 
  INTO Lr_InfoParametros;
  
  IF C_GetParametros%FOUND THEN
    Lv_FormaContacto  := Lr_InfoParametros.VALOR3;
    Lv_PrefijoEmpresa := Lr_InfoParametros.VALOR4;
  ELSE
    Lv_Error := 'No existen parametros para generar notificaciones';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetParametros;
  
  IF C_GetParametros%ISOPEN THEN
    CLOSE C_GetParametros;
  END IF;

  Lv_DescripParametro := 'URL ECUCERT PARA CREAR TAREAS';
  OPEN C_GetParametros (Lv_NombreParametro,Lv_DescripParametro);
  FETCH C_GetParametros 
  INTO Lr_InfoParametros;
  
  IF C_GetParametros%FOUND THEN
    Lv_URLSoporte  := Lr_InfoParametros.VALOR2;
  ELSE
    Lv_Error := 'No existen parametros para Consumo de Web Service para generar Tarea';
    RAISE Le_Exception;
  END IF;
  CLOSE C_GetParametros;

  Lcl_TareaA       :='[{
                        "asignacionAut":    "'|| Lv_Asignacion ||'",
                        "nombreProceso":    "'|| Lv_NombreProceso ||'",
                        "nombreTarea":      "'|| Lv_NombreTarea ||'",
                        "sintoma":          "'|| Lv_Sintoma ||'",
                        "afectados":        {
                                            "idAfectados":   "'|| Lv_Afectados ||'"
                                            },
                        "empleado":         "'|| Ln_Empleado ||'",
                        "cuadrilla":        "'|| Lv_Cuadrilla ||'",
                        "tipoAsignacion":   "'|| Lv_TipoAsignacion ||'",
                        "motivoTarea":      "'|| Lv_MotivoTarea ||'",
                        "observacion":      "'|| Lv_Observacion || Pv_NombreNodo ||'"
                       }]';

  Lcl_JsonTarea    :='{
                        "data": 
                                {
                                "prefijoEmpresa":   "'|| Lv_PrefijoEmpresa ||'",
                                "formaContacto":    "'|| Lv_FormaContacto ||'",                          
                                "empleadoAsignado": "'|| Ln_Empleado ||'",
                                "tareas":            '|| Lcl_TareaA ||',
                                "user":             "'||Pv_Usuario ||'",
                                "ipCreacion":       "'||Pv_Ip ||'"
                                },
                        "op": "putCrearTarea",
                        "token": "''",
                        "user": "'|| Pv_Usuario ||'",
                        "ipCreacion": "'|| Pv_Ip ||'"
                        }'; 

  DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST(Lcl_JsonTarea,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
  DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_DATOS_CREAR_TAREA(Lv_RespuestaCaso,Lv_Status,Pv_Mensaje,Ln_NoTarea);

  IF Ln_NoTarea IS NULL THEN
    DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_CREAR_REQUEST (Lcl_JsonTarea,Lv_URLSoporte,Lv_RespuestaCaso,Lcl_MensajeError);
    DB_SOPORTE.SPKG_INCIDENCIA_ECUCERT.P_DATOS_CREAR_TAREA (Lv_RespuestaCaso,Lv_Status,Pv_Mensaje,Ln_NoTarea);
  END IF;

EXCEPTION
  WHEN Le_Exception THEN
    Pv_Mensaje := Lv_Error;  
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MANTENIMIENTO_TORRE.P_CREACION_TAREA', 
                                            Pv_Mensaje||' - '||SQLERRM, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Mensaje := 'Ocurrio un problema al generar la tarea. Por Favor Notificar a Sistemas';  
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MANTENIMIENTO_TORRE.P_CREACION_TAREA', 
                                            Pv_Mensaje||' - '||SQLERRM, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_CREACION_TAREA;

END INKG_MANTENIMIENTO_TORRE;

/
