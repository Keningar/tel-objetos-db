

CREATE EDITIONABLE PACKAGE            INKG_TRANSACCION IS

  -- Author  : SFERNANDEZ
  -- Created : 17/11/2017 10:20:02
  -- Purpose : Modificado

 /**
  * Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Procedimiento que realiza request al ws de finalizacion de solicitud de retiro de equipos en Telcos
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 17-11-2017
  *
  * Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Se agrega el estado Asignada en el cursor que obtiene las solicitudes de retiro de equipo
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.1 28-05-2019
  *
   Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Se asigna valor a variable de estado que retorna procedimiento NAF47_TNET.GEKG_TRANSACCION.P_CONSUMO_TECNICOWS
  * en caso de que tenga valor nulo
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.2 10-06-2019
  *
  *Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Se valida si el cursor que trae los valores del JSON viene nulo, de ser asi se presenta mensaje
  * indicando que no se trajo valores.
  * en caso de que tenga valor nulo
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.3 01-07-2019
  *
  *Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Se omite filtro en consulta principal de registro de asigancion de custodio
  * ya que de no habersele asignado considera el custodio ingresado en el ingreso de/los equipos
  * indicando que no se trajo valores.
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.4 30-09-2019
  *
  *Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Se agrega el cursor C_GE_PARAMETROS el cual obtendra el valor PARAMETRO que decidira si se utiliza el ws de 
  * telcos o el nuevo procedimiento de naf NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS, se crea un conficional IF-THEN
  * @author Douglas Natha <dnatha@telconet.ec>
  * @version 1.5 03-02-2020
  *
  *Documentacion para el procedimiento P_FINALIZA_SOLICITUD_RETIROS
  * Se hace el llamado de la funcion GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP la cual elimina los caracteres
  * especiales que llegan a los campos observaciones y nombreCliente que arman el JSON.
  * @author Douglas Natha <dnatha@telconet.ec>
  * @version 1.6 20-02-2020
  *
   *Documentacion para el paquete INKG_TRANSACION
  * Se procede al cambio de la funcion GEK_CONSULTA.F_RECUPERA_LOGIN por la sentencia LOWER(USER) 
  * especiales que llegan a los campos observaciones y nombreCliente que arman el JSON.
  * @author Douglas Natha <dnatha@telconet.ec>
  * @version 1.6 20-02-2020

  * @param Pv_IdDetalleSolicitud  IN VARCHAR2,
  * @param Pv_NoCia               IN VARCHAR2,
  * @param Pv_LoginTecnico        IN VARCHAR2,
  * @param Pv_URLToken            IN VARCHAR2,
  * @param Pv_UserName            IN VARCHAR2,
  * @param Pv_Password            IN VARCHAR2,
  * @param Pv_Name                IN VARCHAR2,
  * @param Pv_URLRetiro          IN VARCHAR2,
  * @param Pv_MensajeError       OUT VARCHAR2
  */
  PROCEDURE P_FINALIZA_SOLICITUD_RETIROS(Pv_IdDetalleSolicitud  IN VARCHAR2,
                                         Pv_NoCia               IN VARCHAR2,
                                         Pv_LoginTecnico        IN VARCHAR2,
                                         Pv_URLToken            IN VARCHAR2,
                                         Pv_UserName            IN VARCHAR2,
                                         Pv_Password            IN VARCHAR2,
                                         Pv_Name                IN VARCHAR2,
                                         Pv_URLRetiro           IN VARCHAR2,
                                         Pv_MensajeError       OUT VARCHAR2);


  /**
  * Documentacion para P_INSERTA_ARINME
  * Procedure que inserta registro en ARINME
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 22/10/2016  Se publica y modifica procedure para que pueda ser usado en el proceso de Ingreso a Bodega por Devoluciones
  *
  * @author  Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.2 29/03/2018  Se agrega campo para retiro de equipos.
  *
  * @param Pr_Arinme       IN ARINME%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINME ( Pr_Arinme       IN     NAF47_TNET.ARINME%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_ARINML
  * Procedure que inserta registro en ARINML
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 22/10/2016  Se publica y modifica procedure para que pueda ser usado en el proceso de Ingreso a Bodega por Devoluciones
  *
  * @param Pr_Arinml       IN ARINML%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINML ( Pr_Arinml       IN     NAF47_TNET.ARINML%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);

 /**
  * Documentacion para P_INSERTA_NUMERO_SERIE
  * Procedure que inserta registro en INV_PRE_INGRESO_NUMERO_SERIE
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 23/11/2017
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 30/07/2021 -  Se modifica para considerar nuevos campos cantidad_segmento y serie_original
  *
  * @param Pr_NumeroSerie       IN INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_NUMERO_SERIE (Pr_NumeroSerie  IN     NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE,
                                    Pv_MensajeError IN OUT VARCHAR2);


 /**
  * Documentacion para P_INSERTA_MAESTRO_SERIE
  * Procedure que inserta registro en INV_NUMERO_SERIE
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 11/12/2017
  *
  * @param Pr_NumeroSerie       IN INV_NUMERO_SERIE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_MAESTRO_SERIE (Pr_NumeroSerie   IN     NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE,
                                     Pv_MensajeError  IN OUT VARCHAR2);


  /**
  * Documentacion para P_INSERTA_ARINMEH
  * Procedure que inserta registro en ARINMEH
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 14/12/2020
  *
  * @param Pr_Arinmeh       IN ARINMEH%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINMEH ( Pr_Arinmeh      IN     NAF47_TNET.ARINMEH%ROWTYPE,
                                Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_ARINMN
  * Procedure que inserta registro en ARINMN
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 14/12/2020
  *
  * @param Pr_Arinmn       IN ARINMN%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINMN ( Pr_Arinmn       IN     NAF47_TNET.ARINMN%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);

 /**
  * Documentacion para P_INSERTA_TAP_HISTORIAL_OC
  * Procedure que inserta registro en TAP_HISTORIAL_OC
  * @author Vmmoreno <vmmoreno@telconet.ec>
  * @version 1.0 19/05/2021
  *
  * @param Pr_Taphistorialoc       IN TAP_HISTORIAL_OC%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_TAP_HISTORIAL_OC(PV_NO_CIA            IN VARCHAR2,
                                       PV_ORDEN             IN VARCHAR2,
                                       PV_LINEA             IN VARCHAR2,
                                       PV_ARTICULO          IN VARCHAR2,
                                       PV_CANTIDAD          IN NUMBER,
                                       PV_RECIBIDO          IN NUMBER,
                                       PD_FECHA_RECEPCION   IN DATE,
                                       PV_USUARIO_RECEPCION IN VARCHAR2,
                                       PV_MENSAJEERROR      OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_ARINTE
  * Procedure que inserta registro en ARINTE
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 14/12/2020
  *
  * @param Pr_Arinte       IN ARINTE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINTE ( Pr_Arinte       IN     NAF47_TNET.ARINTE%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_ARINTL
  * Procedure que inserta registro en ARINTL
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 14/12/2020
  *
  * @param Pr_Arinte       IN ARINTL%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINTL ( Pr_Arintl       IN     NAF47_TNET.ARINTL%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);

   /**
  * Documentacion para P_AUDITORIA_ELEMENTOS
  * Procedure que inserta registro en DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 23/11/2017
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.1 12/04/2018 Se agrega el tecnico que recibe el despacho.
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 12/04/2018 Se modifica la busqueda de empleado/contratista que recibe despacho pues envia codigo de empresa logoneada
  *                         y debe buscar por la empresa a la que pertenece el empleado/contratista.
  *
  * @param Pr_Documento       IN NAF47_TNET.ARINME%ROWTYPE
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_AUDITORIA_ELEMENTOS (Pr_Documento  IN     NAF47_TNET.ARINME%ROWTYPE,
                                   Pv_MensajeError IN OUT VARCHAR2);

    /**
  * Documentacion para P_INSERTA_INFO_ELE_TRAZAB
  * Procedure que inserta registro en DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 23/11/2017
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 24/04/2022 -  Se modifica para asignar valores por defecto a campos TIMESTAMP
  *
  * @param Pr_InfoElementoTrazabilidad     IN DB_INFRAESTRUCTURA.Info_Elemento_Trazabilidad
  * @param Pv_MensajeError             IN OUT VARCHAR2
  */
  PROCEDURE P_INSERTA_INFO_ELE_TRAZAB (Pr_InfoElementoTrazabilidad    IN  DB_INFRAESTRUCTURA.Info_Elemento_Trazabilidad%ROWTYPE,
                                       Pv_MensajeError IN OUT VARCHAR2);

    /**
  * Documentacion para P_FINALIZA_RETIRO_EQUIPOS
  * Procedure con la misma logica migrada del ws en telcos TecnicoWSController.php que finaliza la solicitud de retiro de
  * equipo.
  * @author Douglas Natha <dnatha@telconet.ec>
  * @version 1.0 03/02/2020
  *
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.1 18/11/2021 Se aumenta longitud de variable Lv_CodigoArticulo a 25 caracteres
  *
  * @param Pv_Json                      IN VARCHAR2
  * @param Pv_URL                       IN VARCHAR2
  * @param Pv_Status                    OUT VARCHAR2
  * @param Pv_Mensaje                   OUT VARCHAR2
  * @param Pv_MensajeError              OUT VARCHAR2
  */
  PROCEDURE P_FINALIZA_RETIRO_EQUIPOS (Pv_Json         IN VARCHAR2,
                                      Pv_URL          IN VARCHAR2,
                                      Pv_Status       OUT VARCHAR2,
                                      Pv_Mensaje      OUT VARCHAR2,
                                      Pv_MensajeError OUT VARCHAR2);

   /**
  * Documentacion para P_AUDITORIA_ESTADO_ARTICULOS
  * Procedure que inserta registro en NAF47_TNET.ARIN_ESTADO_ARTICULO
  * @author Bolivar Romero <bdromero@telconet.ec>
  * @version 1.0 19/10/2020
  *
  * @author Bolivar Romero <bdromero@telconet.ec>
  * @version 1.1 06/11/2020 Se redefine cursores para eliminar registros duplicados.
  *
  * @author Bolivar Romero <bdromero@telconet.ec>
  * @version 1.2 17/11/2020 Se eliminan los duplicados de los registros tomando en cuenta los articulos sin registro en telcos
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.3 14/02/2022 Se amplia longitud de variables usadas para asignar data de Json para solventar error de longitud.
  *
  * @param Pv_Serie        IN VARCHAR2 Corresponde a la serie a revisar
  * @param Pv_MensajeError OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_AUDITORIA_ESTADO_ARTICULOS (Pv_Serie        IN  VARCHAR2,
                                          Pv_MensajeError OUT VARCHAR2);

   /**
  * Documentacion para P_CAMBIA_ESTADO_SOLICITUD
  * Procedure que actualiza registros en DB_COMERCIAL.INFO_DETALLE_SOLICITUD y DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
  * @author Bolivar Romero <bdromero@telconet.ec>
  * @version 1.0 17/11/2020
  *
  * @param Pv_Solicitud    IN NUMBER Corresponde a la solicitud del retiro que debe cambiar de estado a AsignadoTarea.
  * @param Pv_MensajeError OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_CAMBIA_ESTADO_SOLICITUD (Pv_Solicitud    IN  NUMBER,
                                       Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentacion para P_REGISTRA_TRANSF_RESERVA
  * Procedimiento que genera transferencias de articulos reservados por un pedido
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 05/05/2021
  *
  * @param Pt_Arinte    IN Gt_Arinte Cabecera de estructura de transferencias.
  * @param Pt_Arintl    IN Gt_Arintl Detalle de estructura de transferencias.
  * @param Pv_MensajeError OUT VARCHAR2 Retorna mensaje error.
  */

  Gt_Arinte NAF47_TNET.ARINTE%ROWTYPE;
  Gt_Arintl  NAF47_TNET.ARINTL%ROWTYPE; 
  PROCEDURE P_REGISTRA_TRANSF_RESERVA (Pt_Arinte    IN OUT  Gt_Arinte%ROWTYPE,
                                       Pt_Arintl    IN OUT  Gt_Arintl%ROWTYPE,
                                       Pv_MensajeError OUT VARCHAR2);

   /**
  * Documentacion para F_NOTIFICACION_MAIL
  * Funcion que emite correo
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 25/06/2021
  *
  * @param Pv_Remitente    VARCHAR2 correo de remitente.
  * @param Pv_Destinatario VARCHAR2 Correo de destinatario.
  * @param Pv_Copia        VARCHAR2 Copia.
  * @param pv_Asunto       VARCHAR2 Asunto.
  * @param pv_Mensaje      VARCHAR2 mensaje.
  */                                     
  FUNCTION F_NOTIFICACION_MAIL(Pv_Remitente    VARCHAR2,
                               Pv_Destinatario VARCHAR2,
                               Pv_Copia        VARCHAR2,
                               pv_Asunto       VARCHAR2,
                               pv_Mensaje      VARCHAR2) RETURN NUMBER;      


END INKG_TRANSACCION;
/

CREATE EDITIONABLE PACKAGE BODY            INKG_TRANSACCION IS
  --
  CARACTERISTICA_SOLICITUD CONSTANT VARCHAR2(24) := 'CARACTERISTICA-SOLICITUD';
  RETIRO_EQUIPOS           CONSTANT VARCHAR2(24) := 'RETIRO-EQUIPOS';
  ESTADOS_SOLICITUD        CONSTANT VARCHAR2(25) := 'ESTADOS-SOLICITUD-PROCESO';
  TIPOS_SOLICITUD          CONSTANT VARCHAR2(15) := 'TIPOS-SOLICITUD';
  ELEMENTO_CLIENTE         CONSTANT VARCHAR2(16) := 'ELEMENTO CLIENTE';
  SOLICITUD_NODO           CONSTANT VARCHAR2(14) := 'SOLICITUD NODO';
  ELEMENTO_NODO            CONSTANT VARCHAR2(13) := 'ELEMENTO NODO';

  --
  PROCEDURE P_FINALIZA_SOLICITUD_RETIROS(Pv_IdDetalleSolicitud  IN VARCHAR2,
                                         Pv_NoCia               IN VARCHAR2,
                                         Pv_LoginTecnico        IN VARCHAR2,
                                         Pv_URLToken            IN VARCHAR2,
                                         Pv_UserName            IN VARCHAR2,
                                         Pv_Password            IN VARCHAR2,
                                         Pv_Name                IN VARCHAR2,
                                         Pv_URLRetiro           IN VARCHAR2,
                                         Pv_MensajeError       OUT VARCHAR2)IS

    CURSOR C_GE_PARAMETROS IS
      SELECT PARAMETRO 
        FROM NAF47_TNET.GE_PARAMETROS 
      WHERE ID_GRUPO_PARAMETRO = 'MIGRAWS_RETIROEQUIPO'
        AND ESTADO = 'A';
    Lo_GeParametros C_GE_PARAMETROS%ROWTYPE;

    CURSOR C_CARACTERISTICA_RETIRO IS
     SELECT ID_CARACTERISTICA
       FROM ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = 'RETIRO_ESTADO_ELEMENTO'
        AND ESTADO = 'Activo';

    CURSOR C_PREFIJO(Cv_CodEmpresa Varchar2)IS
    SELECT PREFIJO
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
     WHERE COD_EMPRESA = Cv_CodEmpresa;

    CURSOR C_JSON (Cv_Token                    Varchar2,
                   Cn_IdCaracteristicaRetiro   Number,
                   Cv_PrefijoEmpresa           Varchar2)IS
      WITH 
        ELEMENTOS AS
          (SELECT '{ '
                    ||' "cargador":"'||'si'||'"'
                    ||' ,"entregado":"'||'si'||'"'
                    ||' ,"estadoElemento":"'||(SELECT IDSC.VALOR
                                               FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
                                               WHERE IDSC.DETALLE_SOLICITUD_ID = DSC.DETALLE_SOLICITUD_ID
                                               AND IDSC.CARACTERISTICA_ID = Cn_IdCaracteristicaRetiro
                                               AND IDSC.DETALLE_SOL_CARACT_ID = DSC.ID_SOLICITUD_CARACTERISTICA)||'"'
                    ||' ,"idElemento":"'||IEL.ID_ELEMENTO||'"'
                    ||' ,"idSolCaract":"'||DSC.ID_SOLICITUD_CARACTERISTICA||'"'
                    ||' ,"modeloElemento":"'||AME.NOMBRE_MODELO_ELEMENTO||'"'
                    ||' ,"nombreElemento":"'||IEL.NOMBRE_ELEMENTO||'"'
                    ||' ,"positionElemento":"'||'0'||'"'
                    ||' ,"serieElemento":"'||IEL.SERIE_FISICA||'"'
                    ||' ,"tipoElemento":"'||ATE.NOMBRE_TIPO_ELEMENTO||'"'
                    ||' ,"idArticuloNaf":"'||( SELECT ID_ARTICULO
                                               FROM NAF47_TNET.IN_ARTICULOS_INSTALACION IAI
                                               WHERE IAI.NUMERO_SERIE = IEL.SERIE_FISICA
                                               AND IAI.ESTADO = 'IN' )||'"'
                    ||'} ' AS JSON
           FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC,
                DB_INFRAESTRUCTURA.INFO_ELEMENTO IEL,
                DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE,
                DB_COMERCIAL.ADMI_CARACTERISTICA AC
           WHERE DSC.VALOR = TO_CHAR(IEL.ID_ELEMENTO)
           AND IEL.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
           AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO
           AND DSC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
           AND EXISTS ( SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                        WHERE APD.DESCRIPCION = ESTADOS_SOLICITUD -- Valida los estados de solicitud parametrizados
                        AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                        AND EXISTS ( SELECT NULL
                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                     WHERE APC.NOMBRE_PARAMETRO = RETIRO_EQUIPOS
                                     AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                     AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
                        AND APD.VALOR1 = DSC.ESTADO)
           AND EXISTS (SELECT NULL
                       FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                       WHERE APD.DESCRIPCION = CARACTERISTICA_SOLICITUD -- valida que solo procese solciitudes de retiros equipos
                       AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                       AND EXISTS ( SELECT NULL
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                    WHERE APC.NOMBRE_PARAMETRO = RETIRO_EQUIPOS
                                    AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                    AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
                       AND APD.VALOR1 = AC.DESCRIPCION_CARACTERISTICA)
           --
           AND DSC.DETALLE_SOLICITUD_ID = Pv_IdDetalleSolicitud),

        SOLICITUD AS
          (SELECT '{'
                  ||' "buscarCpeNaf":"'||'SI'||'"'
                  ||' ,"cedulaCliente":"'||IPE.IDENTIFICACION_CLIENTE||'"'
                  ||' ,"datosElementos": {'
                  ||'"elementos":'||( SELECT '['||listagg( json, ',') within group (order by 1)||']' as data
                                      FROM ELEMENTOS
                                     )
                  ||'}'
                  ||' ,"idSolicitud":"'||IDS.ID_DETALLE_SOLICITUD||'"'
                  ||',"ipCreacion":"'||GEK_CONSULTA.F_RECUPERA_IP||'"'
                  ||' ,"login":"'||IIP.LOGIN||'"'
                  ||' ,"nombreCliente":"'||GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(IPE.RAZON_SOCIAL)||'"'
                  ||' ,"observaciones":"'||GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(IDS.OBSERVACION)||'"'
                  ||' ,"origen":"'||'N'||'"'
                  ||' ,"usrCreacion":"'||Pv_LoginTecnico||'"'
                  ||' ,"codEmpresa":"'||IER.EMPRESA_COD||'"'
                  ||' ,"idDepartamento":"'||'0'||'"'
                  ||' ,"idOficina":"'||'0'||'"'
                  ||' ,"prefijoEmpresa":"'||Cv_PrefijoEmpresa||'"'
                  ||'} ' json
           FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
                DB_COMERCIAL.INFO_SERVICIO IIS,
                DB_COMERCIAL.INFO_PUNTO IIP,
                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPR,
                DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                DB_COMERCIAL.INFO_PERSONA IPE,
                DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC,
                DB_INFRAESTRUCTURA.INFO_ELEMENTO IEL,
                DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
           WHERE ROWNUM                     = 1
           AND IDS.ID_DETALLE_SOLICITUD   = Pv_IdDetalleSolicitud
           AND EMPRESA_COD                = Pv_NoCia
           AND EXISTS (SELECT NULL
                       FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                       WHERE APD.DESCRIPCION = TIPOS_SOLICITUD
                       AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                       AND EXISTS (SELECT NULL
                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                   WHERE APC.NOMBRE_PARAMETRO = RETIRO_EQUIPOS
                                   AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                   AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
                       AND APD.VALOR1 = ATS.DESCRIPCION_SOLICITUD)
           AND EXISTS ( SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                        WHERE APD.DESCRIPCION = ESTADOS_SOLICITUD
                        AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                        AND EXISTS ( SELECT NULL
                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                     WHERE APC.NOMBRE_PARAMETRO = RETIRO_EQUIPOS
                                     AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                     AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
                        AND APD.VALOR1 = DSC.ESTADO)
           AND IDS.SERVICIO_ID            = IIS.ID_SERVICIO
           AND IIS.PUNTO_ID               = IIP.ID_PUNTO
           AND IIP.PERSONA_EMPRESA_ROL_ID = IPR.ID_PERSONA_ROL
           AND IPR.PERSONA_ID             = IPE.ID_PERSONA
           AND IPR.EMPRESA_ROL_ID         = IER.ID_EMPRESA_ROL
           AND IDS.ID_DETALLE_SOLICITUD   =  DSC.DETALLE_SOLICITUD_ID

           AND IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
           AND EXISTS (SELECT NULL
                       FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
                       WHERE AC.DESCRIPCION_CARACTERISTICA = ELEMENTO_CLIENTE -- determinar los tipos de elementos para ingresar a bodegas
                       AND AC.ID_CARACTERISTICA = DSC.CARACTERISTICA_ID) 
           AND DSC.VALOR = TO_CHAR(IEL.ID_ELEMENTO)
           UNION
           SELECT '{'
                     ||' "buscarCpeNaf":"'||'SI'||'"'
                     ||' ,"cedulaCliente":"'||IEG.RUC||'"'
                     ||' ,"datosElementos": {'
                     ||'"elementos":'||( SELECT '['||LISTAGG( JSON, ',') WITHIN GROUP (ORDER BY 1) ||']' AS DATA
                                         FROM ELEMENTOS)
                     ||'}'
                     ||' ,"idSolicitud":"'||IDS.ID_DETALLE_SOLICITUD||'"'
                     ||',"ipCreacion":"'||GEK_CONSULTA.F_RECUPERA_IP||'"'
                     ||' ,"login":"'||IE.NOMBRE_ELEMENTO||'"'
                     ||' ,"nombreCliente":"'||GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(IEG.NOMBRE_EMPRESA)||'"'
                     ||' ,"observaciones":"'||GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(IEG.NOMBRE_EMPRESA)||'"'
                     ||' ,"origen":"'||'N'||'"'
                     ||' ,"usrCreacion":"'||Pv_LoginTecnico||'"'
                     ||' ,"codEmpresa":"'||IER.EMPRESA_COD||'"'
                     ||' ,"idDepartamento":"'||'0'||'"'
                     ||' ,"idOficina":"'||'0'||'"'
                     ||' ,"prefijoEmpresa":"'||Cv_PrefijoEmpresa||'"'
                     ||'} ' AS JSON
           FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG,
                DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA,
                DB_SOPORTE.INFO_TAREA_CARACTERISTICA ITC,
                DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
                DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC
           WHERE IDS.ID_DETALLE_SOLICITUD = Pv_IdDetalleSolicitud
           AND IER.EMPRESA_COD = Pv_NoCia
           AND EXISTS (SELECT NULL 
                       FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
                       WHERE AC.DESCRIPCION_CARACTERISTICA = SOLICITUD_NODO -- usado para determinar tarea y con eso determinar empleado asignado y empresa
                       AND AC.ID_CARACTERISTICA = ITC.CARACTERISTICA_ID)

           AND EXISTS (SELECT NULL 
                       FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
                       WHERE AC.DESCRIPCION_CARACTERISTICA = ELEMENTO_NODO -- usado para determinar elemento nodo al cual se va a ingresar a bodega
                       AND AC.ID_CARACTERISTICA = DSC.CARACTERISTICA_ID)

           AND EXISTS (SELECT NULL
                       FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
                       WHERE EXISTS (SELECT NULL
                                     FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                     WHERE APD.DESCRIPCION = TIPOS_SOLICITUD
                                     AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                     AND EXISTS (SELECT NULL
                                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                 WHERE APC.NOMBRE_PARAMETRO = RETIRO_EQUIPOS
                                                 AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                                 AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
                                     AND APD.VALOR1 = ATS.DESCRIPCION_SOLICITUD)
                       AND ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID)  -- Parametrizacion de tipo solicitud RETIRO EQUIPOS
           AND EXISTS (SELECT NULL
                       FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                       WHERE APD.DESCRIPCION = ESTADOS_SOLICITUD
                       AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                       AND EXISTS (SELECT NULL
                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                   WHERE APC.NOMBRE_PARAMETRO = RETIRO_EQUIPOS
                                   AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                                   AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
                       AND APD.VALOR1 = IDS.ESTADO)
           AND IER.EMPRESA_COD = IEG.COD_EMPRESA
           AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
           AND IDA.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
           AND ITC.DETALLE_ID = IDA.DETALLE_ID
           AND TO_CHAR(IDS.ID_DETALLE_SOLICITUD) = ITC.VALOR
           AND IDS.ELEMENTO_ID = IE.ID_ELEMENTO
           AND DSC.DETALLE_SOLICITUD_ID = IDS.ID_DETALLE_SOLICITUD)
      --
      SELECT '{"data" :'
             ||( SELECT LISTAGG(JSON, ',') WITHIN GROUP (ORDER BY 1)
                 FROM SOLICITUD)
             ||' ,"op":"'||'finalizaRetiroEquipo'||'"'
             ||' ,"source":{'
                         ||'"name":"'||'NAF'||'"'
                         ||',"originID":"'||GEK_CONSULTA.F_RECUPERA_IP||'"'
                         ||', "tipoOriginID":"'||'IP'||'"'
                         ||'},'
             ||'"token":"'||Cv_Token||'"'
             ||' ,"user":"'||'NAF47_TNET'||'"'
             ||'}'
      FROM SOLICITUD;
    --
    Lv_Json                     Varchar2(32767);
    Lv_MensajeError             Varchar2(500);
    Lv_Token                    Varchar2(500);
    Lv_StatusToken              Varchar2(500);
    Lv_Message                  Varchar2(500);
    Lv_Status                   Varchar2(500);
    Lv_Mensaje                  Varchar2(500);
    Ln_IdCaracteristicaRetiro   DB_INFRAESTRUCTURA.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE:=0;
    Lv_PrefijoEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;

    Le_Error        Exception;

  BEGIN
    --

    IF C_GE_PARAMETROS%ISOPEN THEN
      CLOSE C_GE_PARAMETROS;
    END IF;
    OPEN C_GE_PARAMETROS;
    FETCH C_GE_PARAMETROS
      INTO Lo_GeParametros;
    CLOSE C_GE_PARAMETROS;

    IF Lo_GeParametros.PARAMETRO = 'NAF' THEN
      IF Pv_IdDetalleSolicitud IS NOT NULL THEN

        IF C_CARACTERISTICA_RETIRO%ISOPEN THEN
          CLOSE C_CARACTERISTICA_RETIRO;
        END IF;
        OPEN C_CARACTERISTICA_RETIRO;
        FETCH C_CARACTERISTICA_RETIRO
          INTO Ln_IdCaracteristicaRetiro;
        CLOSE C_CARACTERISTICA_RETIRO;

        IF C_PREFIJO%ISOPEN THEN
          CLOSE C_PREFIJO;
        END IF;
        OPEN C_PREFIJO(Pv_NoCia);
        FETCH C_PREFIJO
          INTO Lv_PrefijoEmpresa;
        CLOSE C_PREFIJO;

        IF C_JSON%ISOPEN THEN
          CLOSE C_JSON;
        END IF;
        OPEN C_JSON(Lv_Token,
                    Ln_IdCaracteristicaRetiro,
                    Lv_PrefijoEmpresa);
        FETCH C_JSON
          INTO Lv_Json;
        CLOSE C_JSON;

        IF Lv_Json IS NULL THEN

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                                'NAF47_TNET.INKG_TRANSACCION C_JSON',
                                                'Lv_Token: ' || Lv_Token ||
                                                ' Ln_IdCaracteristicaRetiro: ' || TO_CHAR(Ln_IdCaracteristicaRetiro) ||
                                                ' Ln_IdCaracteristicaElemento: ' || ELEMENTO_NODO ||
                                                ' Lv_PrefijoEmpresa: ' || Lv_PrefijoEmpresa,
                                                --GEK_CONSULTA.F_RECUPERA_LOGIN,                  emunoz 11012023
                                                LOWER(USER),                                             -- emunoz 11012023
                                                SYSDATE,
                                                GEK_CONSULTA.F_RECUPERA_IP);
          Pv_MensajeError := 'No se obtuvo data, verificar el log';
          Raise Le_Error;
        END IF;

        P_FINALIZA_RETIRO_EQUIPOS(Lv_Json,
        Pv_URLRetiro,
        Lv_Status,
        Lv_Mensaje,
        Lv_MensajeError);

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'NAF47_TNET.INKG_TRANSACCION.P_FINALIZA_SOLICITUD_RETIROS',
                                              Lv_Status || Lv_Mensaje ||
                                              Lv_MensajeError,
                                              --GEK_CONSULTA.F_RECUPERA_LOGIN,                    emunoz 11012023
                                              LOWER(USER),                                               -- emunoz 11012023
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);

        IF NVL(Lv_Status, 'X') <> 'OK' THEN
          Pv_MensajeError := 'ERROR NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS - ' ||
                              Lv_MensajeError;
          Raise Le_Error;
        END IF;
      END IF;
    ELSE
      IF Pv_IdDetalleSolicitud IS NOT NULL THEN
        NAF47_TNET.GEKG_TRANSACCION.P_GENERAR_TOKEN (Pv_UserName,
                                                    Pv_Password,
                                                    Pv_URLToken,
                                                    Pv_Name,
                                                    Lv_Token,
                                                    Lv_StatusToken,
                                                    Lv_Message,
                                                    Lv_MensajeError);
        IF Lv_MensajeError IS NOT NULL OR Lv_StatusToken <>'200' THEN
          Pv_MensajeError:= Lv_MensajeError;
          Raise Le_Error;
        ELSE
          IF C_CARACTERISTICA_RETIRO%ISOPEN THEN CLOSE C_CARACTERISTICA_RETIRO; END IF;
          OPEN C_CARACTERISTICA_RETIRO;
          FETCH C_CARACTERISTICA_RETIRO INTO Ln_IdCaracteristicaRetiro;
          CLOSE C_CARACTERISTICA_RETIRO;

          IF C_PREFIJO%ISOPEN THEN CLOSE C_PREFIJO; END IF;
          OPEN C_PREFIJO(Pv_NoCia);
          FETCH C_PREFIJO INTO Lv_PrefijoEmpresa;
          CLOSE C_PREFIJO;

          IF C_JSON%ISOPEN THEN CLOSE C_JSON; END IF;
          OPEN C_JSON (Lv_Token, 
                       Ln_IdCaracteristicaRetiro,
                       Lv_PrefijoEmpresa);
          FETCH C_JSON INTO Lv_Json;
          CLOSE C_JSON;

          IF Lv_Json IS NULL THEN

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                                'NAF47_TNET.INKG_TRANSACCION C_JSON',
                                                'Lv_Token: '||Lv_Token||' Ln_IdCaracteristicaRetiro: '||TO_CHAR(Ln_IdCaracteristicaRetiro)||
                                                ' Ln_IdCaracteristicaElemento: ' || ELEMENTO_NODO ||
                                                ' Lv_PrefijoEmpresa: '||Lv_PrefijoEmpresa ,
                                                --GEK_CONSULTA.F_RECUPERA_LOGIN,          emunoz 11012023
                                                LOWER(USER),                                     -- emunoz 11012023
                                                SYSDATE,
                                                GEK_CONSULTA.F_RECUPERA_IP);
            Pv_MensajeError:= 'No se obtuvo data, verificar el log' ;
            Raise Le_Error;
          END IF;

          NAF47_TNET.GEKG_TRANSACCION.P_CONSUMO_TECNICOWS (Lv_Json,
                                                          Pv_URLRetiro,
                                                          Lv_Status,
                                                          Lv_Mensaje,
                                                          Lv_MensajeError);
        IF NVL(Lv_Status,'X') <>'OK' THEN
          Pv_MensajeError:= 'P_CONSUMO_TECNICOWS: '||Lv_Status||' - '|| Lv_Mensaje||' - '||Lv_MensajeError ;
          Raise Le_Error;
        END IF;
        END IF;
      END IF;
    END IF;
  EXCEPTION
     WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION',
                                            Pv_MensajeError,
                                            --GEK_CONSULTA.F_RECUPERA_LOGIN,          emunoz 11012033
                                            LOWER(USER),                                     -- emunoz 1101203
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en NAF47_TNET.INKG_TRANSACCION: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                            'NAF47_TNET.INKG_TRANSACCION',
                                            Pv_MensajeError,
                                            --GEK_CONSULTA.F_RECUPERA_LOGIN,          emunoz 11012023
                                            LOWER(USER),                                     -- emunoz 11012023
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP);
      DBMS_OUTPUT.PUT_LINE('');
      ROLLBACK;
  END P_FINALIZA_SOLICITUD_RETIROS;

  PROCEDURE P_INSERTA_ARINME ( Pr_Arinme       IN     NAF47_TNET.ARINME%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO NAF47_TNET.ARINME
         ( NO_CIA,             CENTRO,               TIPO_DOC,
           TIPO_CAMBIO,        PERIODO,              RUTA,
           NO_DOCU,            ESTADO,               FECHA,
           NO_FISICO,          SERIE_FISICO,         ORIGEN,
           USUARIO,            FECHA_APLICACION,     EMPLE_SOLIC,
           NO_CIA_RESPONSABLE, C_COSTO_EMPLESOL,     OBSERV1,
           ID_BODEGA,          EMPLEADO_SOLICITANTE, NO_CIA_SOLICITANTE,
           NO_PEDIDO,          TIPO_CONSUMO_INTERNO, NO_DEVOLUCIONES,
           NO_SOL_RET_EQ,      TIPO_REFE,            NO_DOCU_REFE)
    VALUES
         ( Pr_Arinme.No_Cia,             Pr_Arinme.Centro,               Pr_Arinme.Tipo_Doc,
           Pr_Arinme.Tipo_Cambio,        Pr_Arinme.Periodo,              Pr_Arinme.Ruta,
           Pr_Arinme.No_Docu,            Pr_Arinme.Estado,               Pr_Arinme.Fecha,
           Pr_Arinme.No_Fisico,          Pr_Arinme.Serie_Fisico,         Pr_Arinme.Origen,
           USER,                         SYSDATE,                        Pr_Arinme.Emple_Solic,
           Pr_Arinme.No_Cia_Responsable, Pr_Arinme.c_Costo_Emplesol,     Pr_Arinme.Observ1,
           Pr_Arinme.Id_Bodega,          Pr_Arinme.Empleado_Solicitante, Pr_Arinme.No_Cia_Solicitante,
           Pr_Arinme.No_Pedido,          Pr_Arinme.Tipo_Consumo_Interno, Pr_Arinme.No_Devoluciones,
           Pr_Arinme.No_Sol_Ret_Eq,      Pr_Arinme.Tipo_Refe,            Pr_Arinme.No_Docu_Refe);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INSERTA_NUMERO_SERIE.P_INSERTA_ARINME: '||SQLERRM;
  END P_INSERTA_ARINME;

  PROCEDURE P_INSERTA_ARINML ( Pr_Arinml       IN     NAF47_TNET.ARINML%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS

  BEGIN
     INSERT INTO NAF47_TNET.ARINML
          ( NO_CIA,     CENTRO,      TIPO_DOC,
            PERIODO,    RUTA,        NO_DOCU,
            LINEA,      LINEA_EXT,   BODEGA,
            NO_ARTI,    UNIDADES,    TIPO_CAMBIO,
            MONTO,      MONTO_DOL,   MONTO2,
            MONTO2_DOL, IND_OFERTA,  CENTRO_COSTO,
            IND_IV,     TIME_STAMP,  RECONOCE_RECLAMOPROV )
   VALUES ( Pr_Arinml.No_Cia,             Pr_Arinml.Centro,            Pr_Arinml.Tipo_Doc,
            Pr_Arinml.Periodo,            Pr_Arinml.Ruta,              Pr_Arinml.No_Docu,
            Pr_Arinml.Linea,              Pr_Arinml.Linea_Ext,         Pr_Arinml.Bodega,
            Pr_Arinml.No_Arti,            Pr_Arinml.Unidades,          Pr_Arinml.Tipo_Cambio,
            nvl(Pr_Arinml.Monto ,0),      nvl(Pr_Arinml.Monto_Dol ,0), nvl(Pr_Arinml.Monto2 ,0),
            nvl(Pr_Arinml.Monto2_Dol ,0), Pr_Arinml.Ind_Oferta,        Pr_Arinml.Centro_Costo,
            Pr_Arinml.Ind_Iv,             Pr_Arinml.Time_Stamp,        Pr_Arinml.Reconoce_Reclamoprov);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INSERTA_NUMERO_SERIE.P_INSERTA_ARINML: '||SQLERRM;
  END P_INSERTA_ARINML;

  PROCEDURE P_INSERTA_NUMERO_SERIE (Pr_NumeroSerie   IN     NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE,
                                    Pv_MensajeError  IN OUT VARCHAR2)IS
  BEGIN

       INSERT INTO NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
          ( COMPANIA,
            NO_DOCUMENTO, 
            NO_ARTICULO,
            SERIE,
            ORIGEN,
            USUARIO_CREA,
            FECHA_CREA,
            MAC,
            LINEA,
            UNIDADES,
            CANTIDAD_SEGMENTO,
            SERIE_ORIGINAL)
       VALUES ( Pr_NumeroSerie.Compania,   
                Pr_NumeroSerie.No_Documento, 
                Pr_NumeroSerie.No_Articulo,
                Pr_NumeroSerie.Serie,
                Pr_NumeroSerie.Origen,
                Pr_NumeroSerie.Usuario_Crea,
                Pr_NumeroSerie.Fecha_Crea,
                Pr_NumeroSerie.Mac,
                Pr_NumeroSerie.Linea,
                NVL(Pr_NumeroSerie.Unidades,1),
                Pr_NumeroSerie.Cantidad_Segmento,
                Pr_NumeroSerie.Serie_Original);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INSERTA_NUMERO_SERIE.P_INSERTA_NUMERO_SERIE: '||SQLERRM;
  END P_INSERTA_NUMERO_SERIE;


  PROCEDURE P_INSERTA_MAESTRO_SERIE (Pr_NumeroSerie   IN     NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE,
                                     Pv_MensajeError  IN OUT VARCHAR2) IS
  BEGIN

    INSERT INTO NAF47_TNET.INV_NUMERO_SERIE
          ( COMPANIA,
            SERIE,
            NO_ARTICULO,
            ID_BODEGA,
            ESTADO,
            MAC,
            ORIGEN,
            UBICACION,
            UNIDADES,
            SERIE_ANTERIOR,
            USUARIO_CREA,
            FECHA_CREA)
    VALUES ( Pr_NumeroSerie.compania,
            Pr_NumeroSerie.serie,
            Pr_NumeroSerie.no_articulo,
            Pr_NumeroSerie.id_bodega,
            Pr_NumeroSerie.estado,
            Pr_NumeroSerie.mac,
            Pr_NumeroSerie.origen,
            Pr_NumeroSerie.ubicacion,
            Pr_NumeroSerie.unidades,
            Pr_NumeroSerie.serie_anterior,
            Pr_NumeroSerie.usuario_crea,
            Pr_NumeroSerie.fecha_crea);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INKG_TRANSACCION.P_INSERTA_MAESTRO_SERIE: '||SQLERRM;
  END P_INSERTA_MAESTRO_SERIE;
  --
  --
  PROCEDURE P_INSERTA_ARINMEH ( Pr_Arinmeh      IN     NAF47_TNET.ARINMEH%ROWTYPE,
                                Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
   INSERT INTO ARINMEH 
             ( NO_CIA,
               CENTRO,
               TIPO_DOC, 
               PERIODO,
               RUTA,
               NO_DOCU, 
               FECHA,
               OBSERV1,
               TIPO_CAMBIO,
               NO_FISICO,
               SERIE_FISICO,
               TIPO_REFE,
               NO_DOCU_REFE,
               MES,
               SEMANA,
               IND_SEM,
               USUARIO,
               FECHA_APLICACION )
   VALUES ( Pr_Arinmeh.no_cia,
            Pr_Arinmeh.centro,
            Pr_Arinmeh.tipo_doc, 
            Pr_Arinmeh.periodo,
            Pr_Arinmeh.ruta,
            Pr_Arinmeh.no_docu, 
            Pr_Arinmeh.fecha,
            Pr_Arinmeh.observ1,
            Pr_Arinmeh.tipo_cambio,
            Pr_Arinmeh.no_fisico,
            Pr_Arinmeh.serie_fisico,
            Pr_Arinmeh.tipo_refe,
            Pr_Arinmeh.no_docu_refe,
            Pr_Arinmeh.mes,
            Pr_Arinmeh.semana,
            Pr_Arinmeh.ind_sem,
            user,
            sysdate);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INKG_TRANSACCION.P_INSERTA_ARINMEH: '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_INSERTA_ARINMEH;
  --
  --
  PROCEDURE P_INSERTA_ARINMN ( Pr_Arinmn       IN     NAF47_TNET.ARINMN%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
   INSERT INTO ARINMN 
        ( NO_CIA,
          CENTRO,
          TIPO_DOC,
          ANO,
          RUTA,
          NO_DOCU,
          NO_LINEA,
          BODEGA,
          NO_ARTI,
          COSTO_UNI,
          FECHA,
          UNIDADES,
          MONTO,
          DESCUENTO,
          TIPO_REFE,
          NO_REFE,
          NO_PROVE,
          TIME_STAMP,
          CENTRO_COSTO,
          MES,
          SEMANA,
          PERIODO_PROCE,
          PRECIO_VENTA,
          MONTO2,
          COSTO2)
   VALUES( Pr_Arinmn.No_cia,
           Pr_Arinmn.Centro,
           Pr_Arinmn.Tipo_doc,
           Pr_Arinmn.Ano,
           Pr_Arinmn.Ruta,
           Pr_Arinmn.No_docu,
           Pr_Arinmn.No_linea,
           Pr_Arinmn.Bodega,
           Pr_Arinmn.No_arti,
           Pr_Arinmn.Costo_uni,
           Pr_Arinmn.Fecha,
           Pr_Arinmn.Unidades,
           Pr_Arinmn.Monto,
           Pr_Arinmn.Descuento,
           Pr_Arinmn.Tipo_refe,
           Pr_Arinmn.No_refe,
           Pr_Arinmn.No_prove,
           SYSDATE,
           NAF47_TNET.CENTRO_COSTO.RELLENAD(Pr_Arinmn.No_Cia, NVL(Pr_Arinmn.centro_costo,'0')),
           Pr_Arinmn.mes,
           Pr_Arinmn.semana,
           Pr_Arinmn.periodo_proce,
           Pr_Arinmn.precio_venta,
           Pr_Arinmn.monto2,
           Pr_Arinmn.costo2) ;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INKG_TRANSACCION.P_INSERTA_ARINMN: '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_INSERTA_ARINMN;
 --
  --
  PROCEDURE P_INSERTA_TAP_HISTORIAL_OC(PV_NO_CIA            IN VARCHAR2,
                                       PV_ORDEN             IN VARCHAR2,
                                       PV_LINEA             IN VARCHAR2,
                                       PV_ARTICULO          IN VARCHAR2,
                                       PV_CANTIDAD          IN NUMBER,
                                       PV_RECIBIDO          IN NUMBER,
                                       PD_FECHA_RECEPCION   IN DATE,
                                       PV_USUARIO_RECEPCION IN VARCHAR2,
                                       PV_MENSAJEERROR      OUT VARCHAR2) IS

  BEGIN
    INSERT INTO NAF47_TNET.TAP_HISTORIAL_OC
      (NO_CIA,
       NO_ORDEN,
       NO_LINEA,
       NO_ARTI,
       CANTIDAD,
       RECIBIDO,
       FECHA_RECEPCION,
       USR_RECEPCION)
    VALUES
      (PV_NO_CIA,
       PV_ORDEN,
       PV_LINEA,
       PV_ARTICULO,
       PV_CANTIDAD,
       PV_RECIBIDO,
       PD_FECHA_RECEPCION,
       PV_USUARIO_RECEPCION);

  EXCEPTION
    WHEN OTHERS THEN
      PV_MENSAJEERROR := 'Error en INKG_TRANSACCION.P_INSERTA_TAP_HISTORIAL_OC: ' ||
                         SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

  END P_INSERTA_TAP_HISTORIAL_OC;
  --
  --
  PROCEDURE P_INSERTA_ARINTE ( Pr_Arinte       IN     NAF47_TNET.ARINTE%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
   INSERT INTO NAF47_TNET.ARINTE
     ( NO_CIA, 
       CENTRO, 
       BOD_ORIG, 
       BOD_DEST, 
       PERIODO, 
       NO_DOCU, 
       FECHA, 
       OBSERV1, 
       IND_BORRADO, 
       ESTADO, 
       NO_DOCU_REF, 
       USUARIO, 
       TSTAMP, 
       TIPO_FLUJO )
    VALUES
      ( Pr_Arinte.no_cia, 
        Pr_Arinte.centro, 
        Pr_Arinte.bod_orig, 
        Pr_Arinte.bod_dest, 
        Pr_Arinte.periodo, 
        Pr_Arinte.no_docu, 
        Pr_Arinte.fecha, 
        Pr_Arinte.observ1, 
        Pr_Arinte.ind_borrado, 
        Pr_Arinte.estado, 
        Pr_Arinte.no_docu_ref, 
        Pr_Arinte.usuario, 
        Pr_Arinte.tstamp, 
        Pr_Arinte.tipo_flujo);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INKG_TRANSACCION.P_INSERTA_ARINTE: '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_INSERTA_ARINTE;
  --
  --
  PROCEDURE P_INSERTA_ARINTL ( Pr_Arintl       IN     NAF47_TNET.ARINTL%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
   INSERT INTO NAF47_TNET.ARINTL
     ( no_cia,
       centro,
       bod_orig,
       bod_dest,
       periodo,
       no_docu,
       no_arti,
       clase,
       categoria,
       cantidad,
       saldo,
       tstamp )
    VALUES
      ( Pr_Arintl.no_cia,
        Pr_Arintl.centro,
        Pr_Arintl.bod_orig,
        Pr_Arintl.bod_dest,
        Pr_Arintl.periodo,
        Pr_Arintl.no_docu,
        Pr_Arintl.no_arti,
        Pr_Arintl.clase,
        Pr_Arintl.categoria,
        Pr_Arintl.cantidad,
        Pr_Arintl.saldo,
        Pr_Arintl.tstamp);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INKG_TRANSACCION.P_INSERTA_ARINTL: '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_INSERTA_ARINTL;
  --
  --
  PROCEDURE P_AUDITORIA_ELEMENTOS (Pr_Documento  IN     NAF47_TNET.ARINME%ROWTYPE,
                                    Pv_MensajeError IN OUT VARCHAR2)IS

    CURSOR C_DOCUMENTOS (Cv_NoCia NAF47_TNET.ARINME.NO_CIA%TYPE,
                         Cv_TipoM NAF47_TNET.ARINVTM.TIPO_M%TYPE)IS
    SELECT ESTADO_NAF, ESTADO_ACTIVO, ESTADO_TELCOS,UBICACION,ACCION,MOVIMI
      FROM NAF47_TNET.ARINVTM
     WHERE NO_CIA = Cv_NoCia
       AND ESTADO = 'A'
       AND IND_INSTALACION = 'S'
       AND TIPO_M = Cv_TipoM;

    CURSOR C_DETALLE_ARTICULO_INGRESO(Cv_NoCia   NAF47_TNET.ARINME.NO_CIA%TYPE,
                              Cv_NoDocu  NAF47_TNET.ARINME.NO_DOCU%TYPE)IS
    SELECT NO_ARTICULO,SERIE
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
     WHERE COMPANIA     = Cv_NoCia
       AND NO_DOCUMENTO = Cv_NoDocu;


   CURSOR C_DETALLE_ARTICULO_SALIDA(Cv_NoCia   NAF47_TNET.ARINME.NO_CIA%TYPE,
                                    Cv_NoDocu  NAF47_TNET.ARINME.NO_DOCU%TYPE)IS
    SELECT SERIE
      FROM NAF47_TNET.INV_DOCUMENTO_SERIE
     WHERE COMPANIA     = Cv_NoCia
       AND ID_DOCUMENTO = Cv_NoDocu;


    CURSOR C_BODEGA(Cv_NoCia    NAF47_TNET.ARINML.NO_CIA%TYPE,
                    Cv_NoDocu   NAF47_TNET.ARINML.NO_DOCU%TYPE,
                    Cv_TipoDocu NAF47_TNET.ARINML.TIPO_DOC%TYPE)IS
    SELECT BODEGA
      FROM ARINML
     WHERE NO_DOCU  = Cv_NoDocu
       AND NO_CIA   = Cv_NoCia
       AND TIPO_DOC = Cv_TipoDocu;

    CURSOR C_TEC_DESPACHO(Cv_NoCia    NAF47_TNET.ARINML.NO_CIA%TYPE,
                          Cv_NoDocu   NAF47_TNET.ARINML.NO_DOCU%TYPE,
                          Cv_TipoDocu NAF47_TNET.ARINML.TIPO_DOC%TYPE)IS
    SELECT A.NO_CIA_RESPONSABLE, EMPLE_SOLIC
      FROM ARINME A
     WHERE NO_DOCU  = Cv_NoDocu
       AND NO_CIA   = Cv_NoCia
       AND TIPO_DOC = Cv_TipoDocu;

    CURSOR C_REQUIERE_SERIE (Cv_NoArti NAF47_TNET.ARINDA.NO_ARTI%TYPE)IS
     SELECT IND_REQUIERE_SERIE
       FROM ARINDA
      WHERE NO_ARTI = Cv_NoArti;


    CURSOR C_USUARIO (Cv_Usuario NAF47_TNET.TASGUSUARIO.USUARIO%TYPE,
                     Cv_NoCia   NAF47_TNET.TASGUSUARIO.NO_CIA%TYPE)IS
     SELECT NOMBRE, OFICINA
        FROM V_EMPLEADOS_EMPRESAS E, TASGUSUARIO U
      WHERE E.NO_CIA   = U.NO_CIA
        AND E.NO_EMPLE = U.ID_EMPLEADO
        AND E.ESTADO   = 'A'
        AND UPPER(U.USUARIO)  = UPPER(Cv_Usuario);

    CURSOR C_NOMBRE_TECNICO (Cv_NoCia   NAF47_TNET.TASGUSUARIO.NO_CIA%TYPE,
                             Cv_NoEmple NAF47_TNET.ARPLME.NO_EMPLE%TYPE)IS
     SELECT E.NOMBRE, E.OFICINA
     FROM V_EMPLEADOS_EMPRESAS E
     WHERE E.NO_CIA   = Cv_NoCia
     AND E.NO_EMPLE = Cv_NoEmple
     AND E.ESTADO   = 'A'
     UNION
     SELECT A.NOMBRE, NULL AS OFICINA
     FROM ARINMCNT A
     WHERE NO_CIA = Cv_NoCia
     AND NO_CONTRATISTA = Cv_NoEmple;



    Lr_Documento                 NAF47_TNET.ARINME%ROWTYPE;
    Lr_Tecnico                   C_TEC_DESPACHO%ROWTYPE;
    Lr_Usuario                   C_USUARIO%ROWTYPE;
    Lr_DocumentoInv              C_DOCUMENTOS%ROWTYPE;
    Lc_DetalleArti               C_DETALLE_ARTICULO_INGRESO%ROWTYPE;
    Lc_DetalleArtiSalida         C_DETALLE_ARTICULO_SALIDA%ROWTYPE;
    Lv_RequiereSerie             NAF47_TNET.ARINDA.IND_REQUIERE_SERIE%TYPE;
    Lr_InfoElementoTrazabilidad  DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD%ROWTYPE;
    Lv_MensajeError              Varchar2(500);
    Lv_Bodega                    NAF47_TNET.ARINML.BODEGA%TYPE;
    Lr_TecnicoDesapacho          C_NOMBRE_TECNICO%ROWTYPE;

    Le_Error           Exception;



  BEGIN
    Lr_Documento:= Pr_Documento;

    IF C_BODEGA%ISOPEN THEN CLOSE C_BODEGA; END IF;
    OPEN C_BODEGA(Lr_Documento.No_Cia,Lr_Documento.No_Docu, Lr_Documento.Tipo_Doc);
    FETCH C_BODEGA INTO Lv_Bodega;
    CLOSE C_BODEGA;


    IF C_DOCUMENTOS%ISOPEN THEN CLOSE C_DOCUMENTOS; END IF;
    OPEN C_DOCUMENTOS (Lr_Documento.No_Cia,Lr_Documento.Tipo_Doc);
    FETCH C_DOCUMENTOS INTO Lr_DocumentoInv;

    IF C_DOCUMENTOS%FOUND THEN
      Lr_InfoElementoTrazabilidad.Login           := 'N/A';
      Lr_InfoElementoTrazabilidad.Usr_Creacion    := LOWER(USER);--GEK_CONSULTA.F_RECUPERA_LOGIN;      emunoz 11012023
      Lr_InfoElementoTrazabilidad.Fe_Creacion_Naf := SYSDATE;
      Lr_InfoElementoTrazabilidad.Fe_Creacion     := SYSDATE;
      Lr_InfoElementoTrazabilidad.Ip_Creacion     := GEK_CONSULTA.F_RECUPERA_IP;
      Lr_InfoElementoTrazabilidad.Cod_Empresa     := Lr_Documento.No_Cia;
      Lr_InfoElementoTrazabilidad.Estado_Naf      := Lr_DocumentoInv.Estado_Naf;
      Lr_InfoElementoTrazabilidad.Estado_Activo   := Lr_DocumentoInv.Estado_Activo;
      Lr_InfoElementoTrazabilidad.Estado_Telcos   := Lr_DocumentoInv.Estado_Telcos;
      Lr_InfoElementoTrazabilidad.Ubicacion       := Lr_DocumentoInv.Ubicacion;
      Lr_InfoElementoTrazabilidad.Transaccion     := Lr_DocumentoInv.Accion;
      Lr_InfoElementoTrazabilidad.Observacion     := 'Bodega: '||Lv_Bodega;

      IF Lr_DocumentoInv.Movimi = 'E' THEN

          IF C_USUARIO%ISOPEN THEN CLOSE C_USUARIO; END IF;
          --OPEN C_USUARIO(GEK_CONSULTA.F_RECUPERA_LOGIN,Lr_Documento.No_Cia);        emunoz 11012023
         OPEN C_USUARIO(LOWER(USER),Lr_Documento.No_Cia);                                    -- emunoz 11012023
          FETCH C_USUARIO INTO Lr_Usuario;
          CLOSE C_USUARIO;
          Lr_InfoElementoTrazabilidad.Responsable     := NVL(Lr_Usuario.Nombre,'N/A');
          Lr_InfoElementoTrazabilidad.Oficina_Id      := NVL(Lr_Usuario.Oficina,0);

          FOR Lc_DetalleArti IN C_DETALLE_ARTICULO_INGRESO(Lr_Documento.No_Cia,
                                                           Lr_Documento.No_Docu) LOOP
            IF C_REQUIERE_SERIE%ISOPEN THEN CLOSE C_REQUIERE_SERIE; END IF;
            OPEN C_REQUIERE_SERIE(Lc_DetalleArti.No_Articulo);
            FETCH C_REQUIERE_SERIE INTO Lv_RequiereSerie;
            CLOSE C_REQUIERE_SERIE;
            IF Lv_RequiereSerie = 'S' THEN
                 Lr_InfoElementoTrazabilidad.Numero_Serie    := Lc_DetalleArti.Serie;
                 NAF47_TNET.INKG_TRANSACCION.P_INSERTA_INFO_ELE_TRAZAB(Lr_InfoElementoTrazabilidad,
                                                                       Lv_MensajeError);

                  IF Lv_MensajeError IS NOT NULL THEN
                    RAISE Le_Error;
                  END IF;
            END IF;
          END LOOP;
      ELSE
          IF C_TEC_DESPACHO%ISOPEN THEN CLOSE C_TEC_DESPACHO; END IF;
          OPEN C_TEC_DESPACHO(Lr_Documento.No_Cia,Lr_Documento.No_Docu, Lr_Documento.Tipo_Doc);
          FETCH C_TEC_DESPACHO INTO Lr_Tecnico;
          CLOSE C_TEC_DESPACHO;

          IF C_NOMBRE_TECNICO%ISOPEN THEN CLOSE C_NOMBRE_TECNICO; END IF;
          OPEN C_NOMBRE_TECNICO(Lr_Tecnico.No_Cia_Responsable,Lr_Tecnico.Emple_Solic);
          FETCH C_NOMBRE_TECNICO INTO Lr_TecnicoDesapacho;
          CLOSE C_NOMBRE_TECNICO;


          Lr_InfoElementoTrazabilidad.Responsable     := NVL(Lr_TecnicoDesapacho.Nombre,'N/A');
          Lr_InfoElementoTrazabilidad.Oficina_Id      := NVL(Lr_TecnicoDesapacho.Oficina,0);

         FOR Lc_DetalleArtiSalida IN C_DETALLE_ARTICULO_SALIDA(Lr_Documento.No_Cia,
                                                         Lr_Documento.No_Docu) LOOP

           Lr_InfoElementoTrazabilidad.Numero_Serie    := Lc_DetalleArtiSalida.Serie;
           NAF47_TNET.INKG_TRANSACCION.P_INSERTA_INFO_ELE_TRAZAB(Lr_InfoElementoTrazabilidad,
                                                                 Lv_MensajeError);

           IF Lv_MensajeError IS NOT NULL THEN
                    RAISE Le_Error;
           END IF;
          END LOOP;
      END IF;
    END IF;
    CLOSE C_DOCUMENTOS;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INSERTA_NUMERO_SERIE.P_INSERTA_INFO_ELEMENTO_TRAZAB: '||SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                   'NAF47_TNET.INKG_TRANSACCION.P_INSERTA_INFO_ELEMENTO_TRAZAB',
                                    Pv_MensajeError,
                                    --GEK_CONSULTA.F_RECUPERA_LOGIN,                      emunoz 11012023
                                    LOWER(USER),                                         -- emunoz  11012023
                                    SYSDATE,
                                    GEK_CONSULTA.F_RECUPERA_IP);
  END P_AUDITORIA_ELEMENTOS;

  PROCEDURE P_INSERTA_INFO_ELE_TRAZAB (Pr_InfoElementoTrazabilidad    IN DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD%ROWTYPE,
                                       Pv_MensajeError IN OUT VARCHAR2)IS
  BEGIN

  INSERT INTO DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD 
            ( ID_TRAZABILIDAD, 
              NUMERO_SERIE, 
              COD_EMPRESA,
              ESTADO_TELCOS, 
              ESTADO_NAF, 
              ESTADO_ACTIVO,
              UBICACION, 
              LOGIN, 
              RESPONSABLE, 
              OBSERVACION,
              USR_CREACION, 
              FE_CREACION_NAF, 
              TRANSACCION,
              FE_CREACION, 
              IP_CREACION,OFICINA_ID)
  VALUES (DB_INFRAESTRUCTURA.SEQ_INFO_ELEMENTO_TRAZABILIDAD.NEXTVAL, 
          Pr_InfoElementoTrazabilidad.Numero_Serie, 
          Pr_InfoElementoTrazabilidad.Cod_Empresa,
          Pr_InfoElementoTrazabilidad.Estado_Telcos, 
          Pr_InfoElementoTrazabilidad.Estado_Naf, 
          Pr_InfoElementoTrazabilidad.Estado_Activo,
          Pr_InfoElementoTrazabilidad.Ubicacion, 
          Pr_InfoElementoTrazabilidad.Login,
          Pr_InfoElementoTrazabilidad.Responsable, 
          Pr_InfoElementoTrazabilidad.Observacion,
          Pr_InfoElementoTrazabilidad.Usr_Creacion, 
          NVL(Pr_InfoElementoTrazabilidad.Fe_Creacion, SYSTIMESTAMP), 
          Pr_InfoElementoTrazabilidad.Transaccion, 
          NVL(Pr_InfoElementoTrazabilidad.Fe_Creacion, SYSTIMESTAMP),
          Pr_InfoElementoTrazabilidad.Ip_Creacion,
          Pr_InfoElementoTrazabilidad.Oficina_Id);

  EXCEPTION
   WHEN OTHERS THEN
      Pv_MensajeError := 'Error en P_INSERTA_NUMERO_SERIE.P_INSERTA_NUMERO_SERIE: '||SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                   'NAF47_TNET.INKG_TRANSACCION.P_INSERTA_NUMERO_SERIE',
                                    Pv_MensajeError,
                                    --GEK_CONSULTA.F_RECUPERA_LOGIN,                      emunoz 11012023
                                    LOWER(USER),                                                 -- emunoz  11012023
                                    SYSDATE,
                                    GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_INFO_ELE_TRAZAB;

  PROCEDURE P_FINALIZA_RETIRO_EQUIPOS(Pv_Json         IN VARCHAR2,
                                      Pv_URL          IN VARCHAR2,
                                      Pv_Status       OUT VARCHAR2,
                                      Pv_Mensaje      OUT VARCHAR2,
                                      Pv_MensajeError OUT VARCHAR2) IS

    Lv_Json                         VARCHAR2(32767);
    Lv_Op                           Varchar2(100);
    Lv_Origen                       VARCHAR2(5);
    Lv_IpCreacion                   VARCHAR2(20);
    Lv_CodEmpresa                   VARCHAR2(5);
    Lv_CodEmpresaNaf                VARCHAR2(2);
    Lv_IdSolicitud                  VARCHAR2(10);
    Lv_buscarCpeNaf                 VARCHAR2(5);
    Lv_usrCreacion                  VARCHAR2(30);
    Ln_IdPersona                    NUMBER;
    Lv_PrefijoEmpresa               VARCHAR2(3);
    Lb_GuardoElementos              BOOLEAN := TRUE;
    Lv_MensajeResponse              VARCHAR2(200);
    Ln_IdPersonaEmpresaRol          NUMBER;
    Ln_DepartamentoId               NUMBER;
    Ln_IdDepartamentoOrigen         NUMBER;
    Ln_IdSolCaract                  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE;--VARCHAR2(10);
    Lv_SerieCpe                     DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE; --VARCHAR2(30);
    Lv_EstadoCpe                    DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE;--VARCHAR2(15);
    Lv_EntregadoCpe                 VARCHAR2(5);
    Lv_TipoElemento                 DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;-- VARCHAR2(20);
    Lv_CodigoArticulo               DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE; --VARCHAR2(25);
    Lv_NombreElemento               DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE; --VARCHAR2(100);
    Ln_IdArticuloNaf                NAF47_TNET.IN_ARTICULOS_INSTALACION.ID_ARTICULO%TYPE; --VARCHAR2(50);
    Lv_MsjErrorTelcosNaf            VARCHAR2(1000);
    Lv_MsjErrorLowerTelcosNaf       VARCHAR2(1000);
    Lb_BanderaElementosSinSerie     BOOLEAN := FALSE;
    Lb_GuardarCaracteristicasElem   BOOLEAN := FALSE;
    Lv_MsjErrVerActEnNaf            VARCHAR2(200);
    Lv_MsjErrVerActEnNafLow         VARCHAR2(200);
    Lv_MsjErrFinVerActNaf           VARCHAR2(1000);
    Lv_CadenaElementosNoEntregados  VARCHAR2(1000) := NULL;
    Lv_BuscarCpeNafTmp              VARCHAR2(10);
    Lv_TipoArticulo                 CONSTANT VARCHAR2(2) := 'AF';
    Lv_EstadoRe                     VARCHAR2(2) := 'RE';
    Lv_Cantidad                     NUMBER := 1;
    Lv_NombreCaractSerie            VARCHAR2(100);
    Lv_NombreCaractModelo           VARCHAR2(100);
    Lv_ArrayTo                      VARCHAR2(1000);
    Lv_Asunto                       VARCHAR2(1000);
    Lb_EstadoRetiro                 BOOLEAN := FALSE;
    Lv_EstadoAntDetalleSolicitud    VARCHAR2(20);
    Lv_Remitente                    VARCHAR2(100);
    Lv_Cuerpo                       VARCHAR2(9999);
    Ln_ParametroPlantilla           NUMBER := NULL;

    Le_Error                        Exception;

    CURSOR C_DETALLE_SOLICITUD(Cv_IdSolicitud VARCHAR2) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
       WHERE ID_DETALLE_SOLICITUD = Cv_IdSolicitud;
    Lo_DetalleSolicitud         C_DETALLE_SOLICITUD%ROWTYPE;
    Lo_DetalleSolicitudSinSerie C_DETALLE_SOLICITUD%ROWTYPE;

    CURSOR C_EMPLEADO_RESPONSABLE(Cn_IdResponsable VARCHAR2) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_PERSONA
       WHERE ID_PERSONA = Cn_IdResponsable;
    Lo_EmpleadoResponsable C_EMPLEADO_RESPONSABLE%ROWTYPE;

    CURSOR C_SERVICIO(Cn_ServicioId NUMBER) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_SERVICIO
       WHERE ID_SERVICIO = Cn_ServicioId;
    Lo_Servicio     C_SERVICIO%ROWTYPE;
    Lo_ServicioMail C_SERVICIO%ROWTYPE;

    CURSOR C_DETALLE(Cn_DetalleSolicitudId NUMBER) IS
      SELECT *
        FROM DB_SOPORTE.INFO_DETALLE
       WHERE DETALLE_SOLICITUD_ID = Cn_DetalleSolicitudId;
    Lo_Detalle C_DETALLE%ROWTYPE;

    CURSOR C_DETALLE_HISTORIAL(Cn_DetalleId NUMBER) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST
       WHERE DETALLE_SOLICITUD_ID = Cn_DetalleId
         AND ESTADO = 'Finalizada';
    Lo_DetalleHistorial C_DETALLE_HISTORIAL%ROWTYPE;

    CURSOR C_ULTIMA_ASIGNACION(Cn_DetalleId NUMBER) IS
      SELECT *
        FROM (SELECT *
                FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION asignacion
               WHERE asignacion.DETALLE_ID = Cn_DetalleId
               ORDER BY asignacion.ID_DETALLE_ASIGNACION DESC)
       WHERE ROWNUM <= 1;
    Lo_UltimaAsignacion C_ULTIMA_ASIGNACION%ROWTYPE;

    CURSOR C_INFO_PERSONA(Cv_UsrCreacion VARCHAR2) IS
      SELECT * FROM DB_COMERCIAL.INFO_PERSONA WHERE LOGIN = Cv_UsrCreacion;
    Lo_InfoPersona C_INFO_PERSONA%ROWTYPE;

    CURSOR C_ARRAY_DEPARTAMENTO(Cn_IdPersona  NUMBER,
                                Cv_CodEmpresa VARCHAR2) IS
      SELECT per.DEPARTAMENTO_ID
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per,
             DB_COMERCIAL.INFO_OFICINA_GRUPO       og
       WHERE per.PERSONA_ID = Cn_IdPersona
         AND per.OFICINA_ID = og.ID_OFICINA
         AND og.EMPRESA_ID = Cv_CodEmpresa
         AND per.DEPARTAMENTO_ID is not null
         and per.DEPARTAMENTO_ID <> 0
         AND per.ESTADO NOT IN
             ('Inactivo', 'Cancelado', 'Anulado', 'Eliminado');
    Lo_ArrayPersona C_ARRAY_DEPARTAMENTO%ROWTYPE;

    CURSOR C_INFO_PERSONA_EMPRESA_ROL(Cn_IdPersonaRol NUMBER) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
       WHERE ID_PERSONA_ROL = Cn_IdPersonaRol;
    Lo_InfoPersonaEmpresaRol C_INFO_PERSONA_EMPRESA_ROL%ROWTYPE;

    CURSOR C_CARACT_SOL_ELEMENTO(Cn_IdSolCaract NUMBER) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
       WHERE ID_SOLICITUD_CARACTERISTICA = Cn_IdSolCaract;
    Lo_CaractSolElemento C_CARACT_SOL_ELEMENTO%ROWTYPE;

    CURSOR C_ADMI_CARACTERISTICA(Cv_NombreCaractSerie VARCHAR2) IS
      SELECT *
        FROM DB_COMERCIAL.ADMI_CARACTERISTICA
       WHERE DESCRIPCION_CARACTERISTICA = Cv_NombreCaractSerie
         AND ESTADO = 'Activo';
    Lo_CaracteristicaSerie  C_ADMI_CARACTERISTICA%ROWTYPE;
    Lo_CaracteristicaModelo C_ADMI_CARACTERISTICA%ROWTYPE;

    CURSOR C_FORMAS_CONTACTO(Cv_UsrVendedor VARCHAR2) IS
      SELECT pfc.VALOR
        FROM DB_COMERCIAL.INFO_PERSONA                pers,
             DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO pfc,
             DB_COMERCIAL.ADMI_FORMA_CONTACTO         afc
       WHERE pers.ID_PERSONA = pfc.PERSONA_ID
         AND afc.ID_FORMA_CONTACTO = pfc.FORMA_CONTACTO_ID
         AND lower(pers.LOGIN) = lower(Cv_UsrVendedor)
         AND lower(pfc.ESTADO) = lower('Activo')
         AND pfc.VALOR is not null
         AND lower(afc.DESCRIPCION_FORMA_CONTACTO) =
             lower('Correo Electronico');
    Lo_FormasContacto C_FORMAS_CONTACTO%ROWTYPE;

    CURSOR C_ADMI_MOTIVO IS
      SELECT *
        FROM DB_COMERCIAL.ADMI_MOTIVO
       WHERE NOMBRE_MOTIVO = 'CANCELACION AUTOMATICA'
         AND ESTADO = 'Activo';
    Lo_AdmiMotivo C_ADMI_MOTIVO%ROWTYPE;

    CURSOR C_INFO_SERVICIO_HISTORIAL(Cn_ServicioId NUMBER,
                                     Cn_MotivoId   NUMBER) IS
      SELECT *
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
       WHERE SERVICIO_ID = Cn_ServicioId
         AND ESTADO = 'Cancel'
         AND MOTIVO_ID = Cn_MotivoId;
    Lo_InfoServHistCancel C_INFO_SERVICIO_HISTORIAL%ROWTYPE;

    CURSOR C_ADMI_PLANTILLA(Cv_CodigoPlantilla VARCHAR2) IS
    SELECT * FROM DB_COMUNICACION.ADMI_PLANTILLA
    WHERE CODIGO = Cv_CodigoPlantilla
    AND ESTADO <> 'Eliminado';
    Lo_AdmiPlantilla C_ADMI_PLANTILLA%ROWTYPE;

    CURSOR C_ID_PERSONA(Cv_CodEmpresa VARCHAR2, Cv_UsrCreacion VARCHAR2) IS
    select persona.ID_PERSONA ID_PERSONA
          from DB_COMERCIAL.info_persona             persona,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
               DB_GENERAL.ADMI_DEPARTAMENTO          dep,
               DB_COMERCIAL.INFO_EMPRESA_ROL         ier,
               DB_COMERCIAL.INFO_OFICINA_GRUPO       oficina,
               DB_GENERAL.ADMI_CANTON                canton
         where persona.ID_PERSONA = iper.PERSONA_ID
           and iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL
           and iper.DEPARTAMENTO_ID = dep.ID_DEPARTAMENTO
           and iper.OFICINA_ID = oficina.ID_OFICINA
           and oficina.CANTON_ID = canton.ID_CANTON
           and ier.EMPRESA_COD = Cv_CodEmpresa
           and persona.login = Cv_UsrCreacion
           and iper.estado = 'Activo';
     Lo_IdPersona C_ID_PERSONA%ROWTYPE;

     CURSOR C_INFO_PLANTILLA(Cv_IdDetalleSolicitud VARCHAR2) IS
     SELECT PE.NOMBRES, PE.APELLIDOS, PE.RAZON_SOCIAL, IP.LOGIN, IP.DIRECCION, 
            AJ.NOMBRE_JURISDICCION, ISERV.DESCRIPCION_PRESENTA_FACTURA, ISERV.PRODUCTO_ID, 
      (SELECT DESCRIPCION_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE AP.ID_PRODUCTO = ISERV.PRODUCTO_ID) AS DESCRIPCION_PRODUCTO,
      ISERV.PLAN_ID,
      (SELECT DESCRIPCION_PLAN FROM DB_COMERCIAL.INFO_PLAN_CAB IPC
      WHERE IPC.ID_PLAN = ISERV.PLAN_ID) AS DESCRIPCION_PLAN

      FROM
         DB_COMERCIAL.INFO_PERSONA             PE,
         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER,
         DB_COMERCIAL.INFO_PUNTO               IP,
         DB_COMERCIAL.INFO_SERVICIO            ISERV,
         DB_COMERCIAL.INFO_DETALLE_SOLICITUD   IDS,
         DB_INFRAESTRUCTURA.ADMI_JURISDICCION  AJ

      WHERE
         IDS.ID_DETALLE_SOLICITUD = Cv_IdDetalleSolicitud AND
         IDS.SERVICIO_ID = ISERV.ID_SERVICIO AND
         ISERV.PUNTO_ID = IP.ID_PUNTO AND
         AJ.ID_JURISDICCION = IP.PUNTO_COBERTURA_ID AND
         IP.PERSONA_EMPRESA_ROL_ID = PER.ID_PERSONA_ROL AND
         PER.PERSONA_ID = PE.ID_PERSONA;
      Lo_InfoPlantilla       C_INFO_PLANTILLA%ROWTYPE;

  BEGIN

    Lv_Json  := Pv_Json;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'INICIO - NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS',
                                         'SE INICIA EL PROCEDIMIENTO P_FINALIZA_RETIRO_EQUIPOS - JSON QUE INGRESA:  '|| Lv_Json,
                                         --GEK_CONSULTA.F_RECUPERA_LOGIN,                      emunoz 11012023
                                         LOWER(USER),                                                 -- emunoz 11012023
                                         SYSDATE,
                                         GEK_CONSULTA.F_RECUPERA_IP);

    apex_json.parse(Lv_Json);
    Lv_Op     := apex_json.get_varchar2(p_path => 'op');
    Lv_Origen := apex_json.get_varchar2(p_path => 'data.origen');

    IF Lv_Op = 'finalizaRetiroEquipo' THEN
      IF Lv_Origen != 'M' THEN
        Lv_usrCreacion   := apex_json.get_varchar2(p_path => 'data.usrCreacion');
        Lv_CodEmpresa    := apex_json.get_varchar2(p_path => 'data.codEmpresa');
        Lv_CodEmpresaNaf := Lv_CodEmpresa;

        --SE VERIFICA QUE EL EMPLEADO ASIGNADO TENGA PERMISOS EN TN o MG
        ------------------------------------------------------------------------             
        IF C_ID_PERSONA%ISOPEN THEN
          CLOSE C_ID_PERSONA;
        END IF;
        OPEN C_ID_PERSONA(Lv_CodEmpresa, Lv_usrCreacion);
        FETCH C_ID_PERSONA
          INTO Lo_IdPersona;
        CLOSE C_ID_PERSONA;

        IF Lo_IdPersona.ID_PERSONA IS NULL THEN
          Pv_MensajeError := 'El codigo del empleado ' || Lv_usrCreacion || ' no tiene creado roll en Telcos para la empresa: ' ||Lv_CodEmpresa ;
          RAISE Le_Error;
        END IF;
        ------------------------------------------------------------------------
        Lv_IpCreacion     := apex_json.get_varchar2(p_path => 'data.ipCreacion');
        Lv_IdSolicitud    := apex_json.get_varchar2(p_path => 'data.idSolicitud');
        Lv_buscarCpeNaf   := apex_json.get_varchar2(p_path => 'data.buscarCpeNaf');
        Lv_PrefijoEmpresa := apex_json.get_varchar2(p_path => 'data.prefijoEmpresa');

        IF Lv_PrefijoEmpresa = 'MD' THEN
          SELECT COD_EMPRESA
            INTO Lv_CodEmpresaNaf
            FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
           WHERE PREFIJO = 'TN';
        END IF;

        IF C_DETALLE_SOLICITUD%ISOPEN THEN
          CLOSE C_DETALLE_SOLICITUD;
        END IF;
        OPEN C_DETALLE_SOLICITUD(Lv_IdSolicitud);
        FETCH C_DETALLE_SOLICITUD
          INTO Lo_DetalleSolicitud;
        CLOSE C_DETALLE_SOLICITUD;

        --se valida si existe entidad detalle solicitud
        IF Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD IS NOT NULL THEN

          IF C_EMPLEADO_RESPONSABLE%ISOPEN THEN
            CLOSE C_EMPLEADO_RESPONSABLE;
          END IF;
          OPEN C_EMPLEADO_RESPONSABLE(Lo_IdPersona.ID_PERSONA);
          FETCH C_EMPLEADO_RESPONSABLE
            INTO Lo_EmpleadoResponsable;
          CLOSE C_EMPLEADO_RESPONSABLE;

          --se valida si existe custodo asignado
          IF Lo_EmpleadoResponsable.ID_PERSONA IS NOT NULL THEN

            IF apex_json.get_count(p_path => 'data.datosElementos.elementos') = 0 THEN
              Lv_MensajeResponse := 'Solicitud sin Equipos para Retirar. Favor notificar a Sistemas.';
              Lb_GuardoElementos := false;
            ELSE
              FOR j IN 1 .. apex_json.get_count(p_path => 'data.datosElementos.elementos') LOOP
                Lv_BuscarCpeNafTmp := apex_json.get_varchar2('data.buscarCpeNaf');
                Ln_IdSolCaract     := apex_json.get_varchar2('data.datosElementos.elementos[%d].idSolCaract', j);
                IF apex_json.get_varchar2('data.datosElementos.elementos[%d].serieElemento', j) IS NOT NULL THEN
                  Lv_SerieCpe := TRIM(apex_json.get_varchar2('data.datosElementos.elementos[%d].serieElemento', j));
                ELSE
                  Lv_SerieCpe := '';
                END IF;
                Lv_EstadoCpe                  := apex_json.get_varchar2('data.datosElementos.elementos[%d].estadoElemento', j);
                Lv_EntregadoCpe               := apex_json.get_varchar2('data.datosElementos.elementos[%d].entregado', j);
                Lv_TipoElemento               := apex_json.get_varchar2('data.datosElementos.elementos[%d].tipoElemento', j);
                Lv_CodigoArticulo             := apex_json.get_varchar2('data.datosElementos.elementos[%d].modeloElemento', j);
                Lv_NombreElemento             := apex_json.get_varchar2('data.datosElementos.elementos[%d].nombreElemento', j);
                Ln_IdArticuloNaf              := apex_json.get_varchar2('data.datosElementos.elementos[%d].idArticuloNaf', j);
                Lv_MsjErrorTelcosNaf          := '';
                Lv_MsjErrorLowerTelcosNaf     := '';
                Lb_BanderaElementosSinSerie   := FALSE;
                Lb_GuardarCaracteristicasElem := FALSE;
                Lv_MsjErrVerActEnNaf          := '';
                Lv_MsjErrVerActEnNafLow       := '';
                --si es roseta no se debe buscar en el naf porque no tiene serie
                IF Lv_TipoElemento = 'ROSETA' THEN
                  Lv_BuscarCpeNafTmp := 'NO';
                END IF;
                --se valida si el idSolCaract es mayor a cero 
                IF TO_NUMBER(Ln_IdSolCaract) > 0 THEN
                  --Si el elemento tiene como estado 'NO ENTREGADO', no debe obtener la serie fisica registrada en el telcos,
                  --sino directamente proceder a finalizar los equipos.
                  IF Lv_EntregadoCpe = 'no' THEN
                    Lv_MsjErrorTelcosNaf           := '';
                    Lb_BanderaElementosSinSerie    := TRUE;
                    Lv_CadenaElementosNoEntregados := Lv_CadenaElementosNoEntregados || ' ' ||
                                                      Lv_NombreElemento;
                  ELSE
                    --Se obliga a que la serie deberia estar en NAF. Si esto no ocurriera, no se puede realizar el retiro del equipo
                    IF Lv_BuscarCpeNafTmp = 'SI' AND
                       Ln_IdArticuloNaf IS NOT NULL THEN
                      /*
                      * Si el elemento se encuentra en estado 'NO ENTREGADO', no se procede a realizar validacion de la serie
                      * en el Naf, puesto que no se ingresa ni la serie ni el modelo del elemento.
                      * Esta validacion ha sido solicitada por el usuario
                      */
                      Lv_MsjErrorTelcosNaf := NULL; --REPEAT(' ',1000);

                      AFK_PROCESOS.IN_P_RETIRA_INSTALACION(Lv_CodEmpresaNaf,
                                                           Lv_CodigoArticulo,
                                                           Lv_TipoArticulo,
                                                           Lo_EmpleadoResponsable.IDENTIFICACION_CLIENTE,
                                                           UPPER(Lv_SerieCpe),
                                                           Lv_Cantidad,
                                                           Lv_EstadoRe,
                                                           Lv_MsjErrorTelcosNaf,
                                                           FALSE); -- se indica que no se ejecute rollback
                      IF TRIM(Lv_MsjErrorTelcosNaf) IS NOT NULL THEN

                        Lv_MsjErrorLowerTelcosNaf := NULL; --REPEAT(' ',1000);
                        AFK_PROCESOS.IN_P_RETIRA_INSTALACION(Lv_CodEmpresaNaf,
                                                             Lv_CodigoArticulo,
                                                             Lv_TipoArticulo,
                                                             Lo_EmpleadoResponsable.IDENTIFICACION_CLIENTE,
                                                             LOWER(Lv_SerieCpe),
                                                             Lv_Cantidad,
                                                             Lv_EstadoRe,
                                                             Lv_MsjErrorLowerTelcosNaf,
                                                             FALSE); -- se indica que no se ejecute rollback
                        IF TRIM(Lv_MsjErrorLowerTelcosNaf) IS NOT NULL THEN
                          Lv_MsjErrorTelcosNaf := '';
                          Lv_MsjErrVerActEnNaf := '';
                        END IF;
                      END IF;
                      /*
                      * Asi no sea obligatorio buscarlo en el NAF, se realiza la consulta de igual manera, con la diferencia que
                      * esta no formara parte de un mensaje de error, sino que aparecera como un mensaje de advertencia y permitira
                      * realizar el retiro
                      */
                    ELSE
                      /*
                      * Solo si el elemento no es una roseta deberia ir a NAF a verificar si existe la serie para mostrarlo
                      * como parte del mensaje de advertencia al usuario
                      */
                      IF Lv_TipoElemento <> 'ROSETA' AND
                         Ln_IdArticuloNaf IS NOT NULL THEN
                        /*
                        * Si Lv_EntregadoCpe=si significa que el estado es diferente de NO ENTREGADO, por ende el usuario
                        * puede ingresar la serie y el modelo del elemento y ademas si $strBuscarCpeNafTmp=NO, implica que el
                        * servicio tiene fecha de activacion menor al 2016-07-01, por lo que se asume que el elemento
                        * no existe en NAF.
                        * Sin embargo puede darse que el elemento si se encuentre en NAF, por lo que es necesario
                        * que se permita finalizar el equipo en telcos y verificar si el elemento existe en NAF, para su respectivo
                        * retiro, es decir no habra problemas de retiro en Telcos y se le mostrara al usuario si ha ocurrido
                        * algun problema en NAF para que verifique y realice la gestion manualmente.
                        */
                        Lv_MsjErrorTelcosNaf          := '';
                        Lb_GuardarCaracteristicasElem := TRUE;
                        Lv_MsjErrVerActEnNaf          := NULL;
                        AFK_PROCESOS.IN_P_RETIRA_INSTALACION(Lv_CodEmpresaNaf,
                                                             Lv_CodigoArticulo,
                                                             Lv_TipoArticulo,
                                                             Lo_EmpleadoResponsable.IDENTIFICACION_CLIENTE,
                                                             UPPER(Lv_SerieCpe),
                                                             Lv_Cantidad,
                                                             Lv_EstadoRe,
                                                             Lv_MsjErrVerActEnNaf,
                                                             FALSE); -- se indica que no se ejecute rollback
                        IF TRIM(Lv_MsjErrVerActEnNaf) IS NOT NULL THEN
                          Lv_MsjErrVerActEnNafLow := NULL;
                          AFK_PROCESOS.IN_P_RETIRA_INSTALACION(Lv_CodEmpresaNaf,
                                                               Lv_CodigoArticulo,
                                                               Lv_TipoArticulo,
                                                               Lo_EmpleadoResponsable.IDENTIFICACION_CLIENTE,
                                                               LOWER(Lv_SerieCpe),
                                                               Lv_Cantidad,
                                                               Lv_EstadoRe,
                                                               Lv_MsjErrVerActEnNafLow,
                                                               FALSE); -- se indica que no se ejecute rollback
                          IF TRIM(Lv_MsjErrVerActEnNafLow) IS NOT NULL THEN
                            Lv_MsjErrVerActEnNaf := '';
                          END IF;
                        END IF;
                      END IF;
                    END IF;
                  END IF;

                  IF TRIM(Lv_MsjErrorTelcosNaf) IS NOT NULL THEN
                    Lv_MensajeResponse := 'Error naf: ' ||
                                          Lv_MsjErrorTelcosNaf;
                    Lb_GuardoElementos := false;
                    EXIT;
                  END IF;

                  IF C_CARACT_SOL_ELEMENTO%ISOPEN THEN
                    CLOSE C_CARACT_SOL_ELEMENTO;
                  END IF;
                  OPEN C_CARACT_SOL_ELEMENTO(Ln_IdSolCaract);
                  FETCH C_CARACT_SOL_ELEMENTO
                    INTO Lo_CaractSolElemento;
                  CLOSE C_CARACT_SOL_ELEMENTO;

                  IF Lo_CaractSolElemento.ID_SOLICITUD_CARACTERISTICA IS NOT NULL THEN
                    --Lo_CaractSolElemento.ESTADO := 'Finalizada';
                    UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
                       SET ESTADO = 'Finalizada'
                     WHERE ID_SOLICITUD_CARACTERISTICA = Ln_IdSolCaract;
                    /*
                    * Se valida si se deben guardar la serie y el modelo como caracteristica de la solicitud
                    * haciendo referencia a la otra caracteristica que contiene el elemento de la solicitud y ademas
                    * validando que se haya ingresado la serie y el modelo del elemento
                    */
                    IF Lb_GuardarCaracteristicasElem = TRUE AND
                       Lb_BanderaElementosSinSerie <> TRUE THEN
                      --Guarda la serie y el id del modelo ingresados como caracteristicas del detalle solicitud
                      Lv_NombreCaractSerie := 'RETIRO_SERIE_ELEMENTO';

                      IF C_ADMI_CARACTERISTICA%ISOPEN THEN
                        CLOSE C_ADMI_CARACTERISTICA;
                      END IF;
                      OPEN C_ADMI_CARACTERISTICA(Lv_NombreCaractSerie);
                      FETCH C_ADMI_CARACTERISTICA
                        INTO Lo_CaracteristicaSerie;
                      CLOSE C_ADMI_CARACTERISTICA;

                      IF Lo_CaracteristicaSerie.ID_CARACTERISTICA IS NOT NULL THEN
                        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
                          (ID_SOLICITUD_CARACTERISTICA,
                           CARACTERISTICA_ID,
                           VALOR,
                           DETALLE_SOLICITUD_ID,
                           ESTADO,
                           FE_CREACION,
                           USR_CREACION,
                           DETALLE_SOL_CARACT_ID)
                        VALUES
                          (DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
                           Lo_CaracteristicaSerie.ID_CARACTERISTICA,
                           Lv_CodigoArticulo,
                           Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD,
                           'Finalizada',
                           SYSDATE,
                           Lv_usrCreacion,
                           Ln_IdSolCaract);
                      END IF;

                      Lv_NombreCaractModelo := 'RETIRO_MODELO_ELEMENTO';

                      IF C_ADMI_CARACTERISTICA%ISOPEN THEN
                        CLOSE C_ADMI_CARACTERISTICA;
                      END IF;
                      OPEN C_ADMI_CARACTERISTICA(Lv_NombreCaractModelo);
                      FETCH C_ADMI_CARACTERISTICA
                        INTO Lo_CaracteristicaModelo;
                      CLOSE C_ADMI_CARACTERISTICA;

                      IF Lo_CaracteristicaModelo.ID_CARACTERISTICA IS NOT NULL THEN
                        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
                          (ID_SOLICITUD_CARACTERISTICA,
                           CARACTERISTICA_ID,
                           VALOR,
                           DETALLE_SOLICITUD_ID,
                           ESTADO,
                           FE_CREACION,
                           USR_CREACION,
                           DETALLE_SOL_CARACT_ID)
                        VALUES
                          (DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
                           Lo_CaracteristicaModelo.ID_CARACTERISTICA,
                           Lv_SerieCpe,
                           Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD,
                           'Finalizada',
                           SYSDATE,
                           Lv_usrCreacion,
                           Ln_IdSolCaract);
                      END IF;
                    END IF;
                  END IF;
                  -- cierre de if - se valida si el idSolCaract es mayor a cero
                ELSE
                  Lv_MensajeResponse := 'Solicitud sin Equipos para Retirar. Favor notificar a Sistemas.';
                  Lb_GuardoElementos := false;
                  EXIT;
                END IF;

                /*
                * Obteniendo Mensaje de Verificacion y Actualizacion en Naf
                */
                IF TRIM(Lv_MsjErrVerActEnNaf) IS NOT NULL THEN
                  Lv_MsjErrFinVerActNaf := Lv_MsjErrVerActEnNaf || '<br/>';
                END IF;
                --cierre de bucle - bucle para recorrer elementos a retirar 
              END LOOP; -- cierre for 
            END IF;

            --se obtiene destinatarios para notificaciones siguientes
            IF C_SERVICIO%ISOPEN THEN
              CLOSE C_SERVICIO;
            END IF;
            OPEN C_SERVICIO(Lo_DetalleSolicitud.SERVICIO_ID);
            FETCH C_SERVICIO
              INTO Lo_Servicio;
            CLOSE C_SERVICIO;

            IF C_FORMAS_CONTACTO%ISOPEN THEN
              CLOSE C_FORMAS_CONTACTO;
            END IF;
            OPEN C_FORMAS_CONTACTO(Lo_Servicio.USR_VENDEDOR);
            LOOP
              FETCH C_FORMAS_CONTACTO
                INTO Lo_FormasContacto;
              EXIT WHEN C_FORMAS_CONTACTO%notfound;
              Lv_ArrayTo := Lv_ArrayTo || Lo_FormasContacto.VALOR || ';';
            END LOOP;
            CLOSE C_FORMAS_CONTACTO;

            --valida si la bandera guardoElementos se encuentra en true
            IF Lb_GuardoElementos = true THEN

              Lv_EstadoAntDetalleSolicitud := Lo_DetalleSolicitud.ESTADO;
              IF Lv_EstadoAntDetalleSolicitud <> 'Finalizada' THEN

                UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                   SET ESTADO = 'Finalizada'
                 WHERE ID_DETALLE_SOLICITUD =
                       Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;

                --Finalizacion de la tarea
                IF Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD IS NOT NULL THEN
                  --FINALIZACION DE TAREA
                  IF C_DETALLE%ISOPEN THEN
                    CLOSE C_DETALLE;
                  END IF;
                  OPEN C_DETALLE(Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD /*SERVICIO_IDer*/);
                  FETCH C_DETALLE
                    INTO Lo_Detalle;
                  CLOSE C_DETALLE;

                  IF Lo_Detalle.ID_DETALLE IS NOT NULL THEN

                    IF C_DETALLE_HISTORIAL%ISOPEN THEN
                      CLOSE C_DETALLE_HISTORIAL;
                    END IF;
                    OPEN C_DETALLE_HISTORIAL(Lo_Detalle.ID_DETALLE);
                    FETCH C_DETALLE_HISTORIAL
                      INTO Lo_DetalleHistorial;
                    CLOSE C_DETALLE_HISTORIAL;

                    IF Lo_DetalleHistorial.ID_SOLICITUD_HISTORIAL IS NOT NULL THEN
                      Pv_MensajeError := 'Tarea en el historial ya se encuentra Finalizada : ' ||
                                         Lo_Detalle.ID_DETALLE;
                      -- se inicializa variable para que no agregue informacion de solicitud planificada al correo notificacion
                      Lo_DetalleHistorial := null; 

                      --Raise Le_Error;
                    ELSE
                      --Se ingresa el historial de la info_detalle(codigo migrado de ingresaHistorialYSeguimientoPorTarea)
                      --Se obtiene el asignado actual de la tarea
                      IF C_ULTIMA_ASIGNACION%ISOPEN THEN
                        CLOSE C_ULTIMA_ASIGNACION;
                      END IF;
                      OPEN C_ULTIMA_ASIGNACION(Lo_Detalle.ID_DETALLE);
                      FETCH C_ULTIMA_ASIGNACION
                        INTO Lo_UltimaAsignacion;
                      CLOSE C_ULTIMA_ASIGNACION;

                      IF C_INFO_PERSONA%ISOPEN THEN
                        CLOSE C_INFO_PERSONA;
                      END IF;
                      OPEN C_INFO_PERSONA(apex_json.get_varchar2(p_path => 'data.usrCreacion'));
                      FETCH C_INFO_PERSONA
                        INTO Lo_InfoPersona;
                      CLOSE C_INFO_PERSONA;

                      IF Lo_InfoPersona.ID_PERSONA IS NOT NULL THEN
                        IF C_ARRAY_DEPARTAMENTO%ISOPEN THEN
                          CLOSE C_ARRAY_DEPARTAMENTO;
                        END IF;
                        OPEN C_ARRAY_DEPARTAMENTO(Lo_InfoPersona.ID_PERSONA,
                                                  apex_json.get_varchar2(p_path => 'data.codEmpresa'));
                        FETCH C_ARRAY_DEPARTAMENTO
                          INTO Lo_ArrayPersona;
                        CLOSE C_ARRAY_DEPARTAMENTO;

                        IF Lo_ArrayPersona.DEPARTAMENTO_ID IS NULL THEN
                          Pv_MensajeError := 'DEPARTAMENTO_ORIGEN no encontrado.';
                          Raise Le_Error;
                        ELSE
                          Ln_IdDepartamentoOrigen := Lo_ArrayPersona.DEPARTAMENTO_ID;
                        END IF;

                      ELSE
                        Pv_MensajeError := 'USR_CREACION no encontrado.';
                        Raise Le_Error;
                      END IF;

                      IF Lo_UltimaAsignacion.ID_DETALLE_ASIGNACION IS NOT NULL THEN
                        Ln_IdPersonaEmpresaRol := Lo_UltimaAsignacion.PERSONA_EMPRESA_ROL_ID;

                        IF Ln_IdPersonaEmpresaRol IS NOT NULL THEN
                          IF C_INFO_PERSONA_EMPRESA_ROL%ISOPEN THEN
                            CLOSE C_INFO_PERSONA_EMPRESA_ROL;
                          END IF;
                          OPEN C_INFO_PERSONA_EMPRESA_ROL(Ln_IdPersonaEmpresaRol);
                          FETCH C_INFO_PERSONA_EMPRESA_ROL
                            INTO Lo_InfoPersonaEmpresaRol;
                          CLOSE C_INFO_PERSONA_EMPRESA_ROL;
                        END IF;

                        IF Lo_InfoPersonaEmpresaRol.ID_PERSONA_ROL IS NOT NULL THEN
                          Ln_DepartamentoId := Lo_InfoPersonaEmpresaRol.DEPARTAMENTO_ID;
                        END IF;
                      END IF;

                      INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL
                        (ID_DETALLE_HISTORIAL,
                         DETALLE_ID,
                         OBSERVACION,
                         USR_CREACION,
                         ACCION,
                         DEPARTAMENTO_ORIGEN_ID,
                         ESTADO,
                         FE_CREACION,
                         IP_CREACION,
                         PERSONA_EMPRESA_ROL_ID,
                         DEPARTAMENTO_DESTINO_ID)
                      VALUES
                        (DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,
                         Lo_Detalle.ID_DETALLE,
                         Lo_DetalleSolicitud.OBSERVACION,
                         apex_json.get_varchar2(p_path => 'data.usrCreacion'),
                         'Finalizada',
                         Ln_IdDepartamentoOrigen,
                         'Finalizada',
                         SYSDATE,
                         apex_json.get_varchar2(p_path => 'data.ipCreacion'),
                         Ln_IdPersonaEmpresaRol,
                         Ln_DepartamentoId);

                      --Se ingresa el seguimiento de la tarea (codigo migrado de ingresaHistorialYSeguimientoPorTarea) 
                      INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO
                        (ID_SEGUIMIENTO,
                         DETALLE_ID,
                         OBSERVACION,
                         EMPRESA_COD,
                         USR_CREACION,
                         ESTADO_TAREA,
                         FE_CREACION,
                         INTERNO,
                         DEPARTAMENTO_ID,
                         PERSONA_EMPRESA_ROL_ID)
                      VALUES
                        (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,
                         Lo_Detalle.ID_DETALLE,
                         'Tarea fue Finalizada. Obs : ' ||
                         Lo_DetalleSolicitud.OBSERVACION,
                         apex_json.get_varchar2(p_path => 'data.codEmpresa'),
                         apex_json.get_varchar2(p_path => 'data.usrCreacion'),
                         'Finalizada',
                         SYSDATE,
                         'N',
                         Ln_IdDepartamentoOrigen,
                         Ln_IdPersonaEmpresaRol);
                    END IF;
                  ELSE
                    Pv_MensajeError := 'No existe Tarea.';
                    --Raise Le_Error;
                  END IF;
                ELSE
                  Pv_MensajeError := 'No existe Solicitud.';
                  --Raise Le_Error;
                END IF;
              END IF;

              --se valida si existieron elementos sin serie valida
              IF Lv_CadenaElementosNoEntregados IS NOT NULL THEN
                --GUARDAR INFO DETALLE SOLICICITUD HISTORIAL
                INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                  (ID_SOLICITUD_HISTORIAL,
                   DETALLE_SOLICITUD_ID,
                   IP_CREACION,
                   FE_CREACION,
                   USR_CREACION,
                   OBSERVACION,
                   ESTADO)
                VALUES
                  (DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                   Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD,
                   Lv_IpCreacion,
                   SYSDATE,
                   Lv_usrCreacion,
                   'Existieron equipos no entregados y que no tienen serie, Elementos:' ||
                   Lv_CadenaElementosNoEntregados || ', favor verificar.',
                   Lv_EstadoAntDetalleSolicitud);

                --notificaciones en caso de existir elementos sin serie valida en Telcos
                Lv_Asunto                               := 'Solicitud de Retiro de Equipo con elementos sin serie valida #' ||
                                                           Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;
                Lo_DetalleSolicitudSinSerie             := Lo_DetalleSolicitud;
                Lo_DetalleSolicitudSinSerie.OBSERVACION := 'Existieron equipos no entregados y que no tienen serie,' ||
                                                           ' Elementos:' ||
                                                           Lv_CadenaElementosNoEntregados ||
                                                           ', favor verificar.';
                IF Lv_PrefijoEmpresa = 'MD' THEN
                  IF C_SERVICIO%ISOPEN THEN
                    CLOSE C_SERVICIO;
                  END IF;
                  OPEN C_SERVICIO(Lo_DetalleSolicitud.SERVICIO_ID);
                  FETCH C_SERVICIO
                    INTO Lo_ServicioMail;
                  CLOSE C_SERVICIO;

                  --ENVIO CORREO

                  SELECT PD.VALOR1
                  INTO Lv_Remitente
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET PD, DB_GENERAL.ADMI_PARAMETRO_CAB PC
                  WHERE PC.ID_PARAMETRO = PD.PARAMETRO_ID
                  AND   PC.NOMBRE_PARAMETRO = 'remitente'
                  AND   PC.ESTADO = 'Activo'
                  AND   PD.ESTADO = 'Activo'
                  AND   PD.EMPRESA_COD = apex_json.get_varchar2(p_path => 'data.codEmpresa');

                  IF Lv_Remitente = '' OR Lv_Remitente IS NULL THEN
                    Lv_Remitente := 'notificaciones_telcos@telconet.ec';
                  END IF;

                  IF C_ADMI_PLANTILLA%ISOPEN THEN
                        CLOSE C_ADMI_PLANTILLA;
                      END IF;
                      OPEN C_ADMI_PLANTILLA('RETIRO_TTCO_MD2');
                      FETCH C_ADMI_PLANTILLA
                        INTO Lo_AdmiPlantilla;
                      CLOSE C_ADMI_PLANTILLA;

                  IF Lo_AdmiPlantilla.ID_PLANTILLA IS NOT NULL THEN
                    Lv_Cuerpo := Lo_AdmiPlantilla.PLANTILLA;
                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.id}}-->', Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                    IF C_INFO_PLANTILLA%ISOPEN THEN
                        CLOSE C_INFO_PLANTILLA;
                    END IF;
                    OPEN C_INFO_PLANTILLA(Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                    FETCH C_INFO_PLANTILLA
                      INTO Lo_InfoPlantilla;
                    CLOSE C_INFO_PLANTILLA;

                    IF Lo_DetalleSolicitud.SERVICIO_ID IS NOT NULL  THEN

                      IF Lo_InfoPlantilla.RAZON_SOCIAL IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.razonSocial }}-->', Lo_InfoPlantilla.RAZON_SOCIAL);
                      ELSE
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.nombres.apellidos }}-->', Lo_InfoPlantilla.NOMBRES || ' ' || Lo_InfoPlantilla.APELLIDOS);
                      END IF;

                      IF Lo_InfoPlantilla.LOGIN IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.login }}-->', Lo_InfoPlantilla.LOGIN);
                      END IF;

                      IF Lo_InfoPlantilla.NOMBRE_JURISDICCION IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.puntoCoberturaId.nombreJurisdiccion }}-->', Lo_InfoPlantilla.NOMBRE_JURISDICCION);
                      END IF;

                      IF Lo_InfoPlantilla.DIRECCION IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.direccion }}-->', Lo_InfoPlantilla.DIRECCION);
                      END IF;

                      IF Lo_InfoPlantilla.DESCRIPCION_PRODUCTO IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.productoId.descripcionProducto }}-->', Lo_InfoPlantilla.DESCRIPCION_PRODUCTO);
                      ELSE
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.planId.nombrePlan }}-->', Lo_InfoPlantilla.DESCRIPCION_PLAN);
                      END IF;

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.feCreacion }}-->', Lo_DetalleSolicitud.FE_CREACION);
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.usrCreacion}}-->', Lo_DetalleSolicitud.USR_CREACION);

                      IF Lo_DetalleSolicitud.FE_RECHAZO IS NOT NULL THEN

                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna1Rcz }}-->', '<td><strong>Fecha de rechazo:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.FE_RECHAZO || '</td>');

                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna1Rcz }}-->', '<td><strong>Usuario que rechaza:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.USR_RECHAZO || '</td>');

                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna1Rcz }}-->', '<td><strong>Motivo de rechazo:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna2Rcz }}-->', ' N/A ');

                      END IF;

                      IF Lo_DetalleHistorial.FE_CREACION IS NOT NULL THEN
                        CASE 
                          WHEN Lo_DetalleHistorial.ESTADO = 'Planificada' THEN 

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Planificaci'|| chr(38) ||'oacute;n :</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Planific'|| chr(38) ||'oacute;:</strong> </td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                          WHEN Lo_DetalleHistorial.ESTADO = 'Replanificada' THEN

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Replanificaci'|| chr(38) ||'oacute;n :</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Replanific'|| chr(38) ||'oacute;:</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  Replanificaci'|| chr(38) ||'oacute;n:</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                          WHEN Lo_DetalleHistorial.ESTADO = 'Detenido' THEN 
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de paralizacion (Detenido):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que detuvo (Detenido):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  paralizacion (Detenido):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                          WHEN Lo_DetalleHistorial.ESTADO = 'Anulado' THEN 
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de anulacion (Anulado):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que anulo (Anulado):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  anulacion (Anulado):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');
                        END CASE;
                      END IF;

                      IF Lo_DetalleSolicitud.OBSERVACION IS NOT NULL THEN 
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs1 }}-->', '<td><strong>Observacion:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs2 }}-->', '<td>' || Lo_DetalleSolicitud.OBSERVACION || '</td>');
                      END IF;

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.estado }}-->', 'Finalizada');
                    END IF;
                  END IF;

                  /*SYS.UTL_MAIL.SEND(SENDER     => Lv_Remitente,
                      RECIPIENTS => Lv_ArrayTo,
                      CC         => '',
                      SUBJECT    => Lv_Asunto,
                      MIME_TYPE  => 'text/html; charset=us-ascii',
                      MESSAGE    => Lv_Cuerpo);*/
                ELSE
                  --ENVIO CORREO

                  SELECT PD.VALOR1
                  INTO Lv_Remitente
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET PD, DB_GENERAL.ADMI_PARAMETRO_CAB PC
                  WHERE PC.ID_PARAMETRO = PD.PARAMETRO_ID
                  AND   PC.NOMBRE_PARAMETRO = 'remitente'
                  AND   PC.ESTADO = 'Activo'
                  AND   PD.ESTADO = 'Activo'
                  AND   PD.EMPRESA_COD = apex_json.get_varchar2(p_path => 'data.codEmpresa');

                  IF Lv_Remitente = '' OR Lv_Remitente IS NULL THEN
                    Lv_Remitente := 'notificaciones_telcos@telconet.ec';
                  END IF;

                  IF C_ADMI_PLANTILLA%ISOPEN THEN
                        CLOSE C_ADMI_PLANTILLA;
                      END IF;
                      OPEN C_ADMI_PLANTILLA('RETIRO_TTCO_MD2');
                      FETCH C_ADMI_PLANTILLA
                        INTO Lo_AdmiPlantilla;
                      CLOSE C_ADMI_PLANTILLA;

                  IF Lo_AdmiPlantilla.ID_PLANTILLA IS NOT NULL THEN
                    Lv_Cuerpo := Lo_AdmiPlantilla.PLANTILLA;
                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.id}}-->', Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                    IF C_INFO_PLANTILLA%ISOPEN THEN
                        CLOSE C_INFO_PLANTILLA;
                    END IF;
                    OPEN C_INFO_PLANTILLA(Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                    FETCH C_INFO_PLANTILLA
                      INTO Lo_InfoPlantilla;
                    CLOSE C_INFO_PLANTILLA;

                    IF Lo_DetalleSolicitud.SERVICIO_ID IS NOT NULL  THEN

                      IF Lo_InfoPlantilla.RAZON_SOCIAL IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.razonSocial }}-->', Lo_InfoPlantilla.RAZON_SOCIAL);
                      ELSE
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.nombres.apellidos }}-->', Lo_InfoPlantilla.NOMBRES || ' ' || Lo_InfoPlantilla.APELLIDOS);
                      END IF;

                      IF Lo_InfoPlantilla.LOGIN IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.login }}-->', Lo_InfoPlantilla.LOGIN);
                      END IF;

                      IF Lo_InfoPlantilla.NOMBRE_JURISDICCION IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.puntoCoberturaId.nombreJurisdiccion }}-->', Lo_InfoPlantilla.NOMBRE_JURISDICCION);
                      END IF;

                      IF Lo_InfoPlantilla.DIRECCION IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.direccion }}-->', Lo_InfoPlantilla.DIRECCION);
                      END IF;

                      IF Lo_InfoPlantilla.DESCRIPCION_PRODUCTO IS NOT NULL THEN
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.productoId.descripcionProducto }}-->', Lo_InfoPlantilla.DESCRIPCION_PRODUCTO);
                      ELSE
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.planId.nombrePlan }}-->', Lo_InfoPlantilla.DESCRIPCION_PLAN);
                      END IF;

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.feCreacion }}-->', Lo_DetalleSolicitud.FE_CREACION);
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.usrCreacion}}-->', Lo_DetalleSolicitud.USR_CREACION);

                      IF Lo_DetalleSolicitud.FE_RECHAZO IS NOT NULL THEN

                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna1Rcz }}-->', '<td><strong>Fecha de rechazo:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.FE_RECHAZO || '</td>');

                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna1Rcz }}-->', '<td><strong>Usuario que rechaza:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.USR_RECHAZO || '</td>');

                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna1Rcz }}-->', '<td><strong>Motivo de rechazo:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna2Rcz }}-->', ' N/A ');

                      END IF;

                      IF Lo_DetalleHistorial.FE_CREACION IS NOT NULL THEN
                        CASE 
                          WHEN Lo_DetalleHistorial.ESTADO = 'Planificada' THEN 

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Planificaci'|| chr(38) ||'oacute;n :</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Planific'|| chr(38) ||'oacute;:</strong> </td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                          WHEN Lo_DetalleHistorial.ESTADO = 'Replanificada' THEN

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Replanificaci'|| chr(38) ||'oacute;n :</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Replanific'|| chr(38) ||'oacute;:</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  Replanificaci'|| chr(38) ||'oacute;n:</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                          WHEN Lo_DetalleHistorial.ESTADO = 'Detenido' THEN 
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de paralizacion (Detenido):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que detuvo (Detenido):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  paralizacion (Detenido):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                          WHEN Lo_DetalleHistorial.ESTADO = 'Anulado' THEN 
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de anulacion (Anulado):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que anulo (Anulado):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  anulacion (Anulado):</strong></td>');
                            Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');
                        END CASE;
                      END IF;

                      IF Lo_DetalleSolicitud.OBSERVACION IS NOT NULL THEN 
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs1 }}-->', '<td><strong>Observacion:</strong></td>');
                        Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs2 }}-->', '<td>' || Lo_DetalleSolicitud.OBSERVACION || '</td>');
                      END IF;

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.estado }}-->', 'Finalizada'/*Lo_DetalleSolicitud.ESTADO*/);
                    END IF;
                  END IF;

                  /*SYS.UTL_MAIL.SEND(SENDER     => Lv_Remitente,
                      RECIPIENTS => Lv_ArrayTo,
                      CC         => '',
                      SUBJECT    => Lv_Asunto,
                      MIME_TYPE  => 'text/html; charset=us-ascii',
                      MESSAGE    => Lv_Cuerpo);*/
                END IF;
              END IF;
              --//GUARDAR INFO DETALLE SOLICICITUD HISTORIAL
              INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                (ID_SOLICITUD_HISTORIAL,
                 DETALLE_SOLICITUD_ID,
                 IP_CREACION,
                 FE_CREACION,
                 USR_CREACION,
                 OBSERVACION,
                 ESTADO)
              VALUES
                (DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                 Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD,
                 Lv_IpCreacion,
                 SYSDATE,
                 Lv_usrCreacion,
                 'Se finalizo solicitud de retiro de equipo',
                 'Finalizada');
              --notificaciones en caso de finalizar retiro de equipo
              Lv_Asunto := 'Solicitud de Retiro de Equipo Finalizada #' ||
                           Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;

              IF Lv_PrefijoEmpresa = 'MD' THEN

                IF C_SERVICIO%ISOPEN THEN
                  CLOSE C_SERVICIO;
                END IF;
                OPEN C_SERVICIO(Lo_DetalleSolicitud.SERVICIO_ID);
                FETCH C_SERVICIO
                  INTO Lo_ServicioMail;
                CLOSE C_SERVICIO;
                --ENVIO CORREO

                SELECT PD.VALOR1
                INTO Lv_Remitente
                FROM DB_GENERAL.ADMI_PARAMETRO_DET PD, DB_GENERAL.ADMI_PARAMETRO_CAB PC
                WHERE PC.ID_PARAMETRO = PD.PARAMETRO_ID
                AND   PC.NOMBRE_PARAMETRO = 'remitente'
                AND   PC.ESTADO = 'Activo'
                AND   PD.ESTADO = 'Activo'
                AND   PD.EMPRESA_COD = apex_json.get_varchar2(p_path => 'data.codEmpresa');

                IF Lv_Remitente = '' OR Lv_Remitente IS NULL THEN
                  Lv_Remitente := 'notificaciones_telcos@telconet.ec';
                END IF;

                IF C_ADMI_PLANTILLA%ISOPEN THEN
                      CLOSE C_ADMI_PLANTILLA;
                    END IF;
                    OPEN C_ADMI_PLANTILLA('RETIRO_TTCO_MD2');
                    FETCH C_ADMI_PLANTILLA
                      INTO Lo_AdmiPlantilla;
                    CLOSE C_ADMI_PLANTILLA;

                IF Lo_AdmiPlantilla.ID_PLANTILLA IS NOT NULL THEN
                  Lv_Cuerpo := Lo_AdmiPlantilla.PLANTILLA;
                  Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.id}}-->', Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                  IF C_INFO_PLANTILLA%ISOPEN THEN
                      CLOSE C_INFO_PLANTILLA;
                  END IF;
                  OPEN C_INFO_PLANTILLA(Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                  FETCH C_INFO_PLANTILLA
                    INTO Lo_InfoPlantilla;
                  CLOSE C_INFO_PLANTILLA;

                  IF Lo_DetalleSolicitud.SERVICIO_ID IS NOT NULL  THEN

                    IF Lo_InfoPlantilla.RAZON_SOCIAL IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.razonSocial }}-->', Lo_InfoPlantilla.RAZON_SOCIAL);
                    ELSE
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.nombres.apellidos }}-->', Lo_InfoPlantilla.NOMBRES || ' ' || Lo_InfoPlantilla.APELLIDOS);
                    END IF;

                    IF Lo_InfoPlantilla.LOGIN IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.login }}-->', Lo_InfoPlantilla.LOGIN);
                    END IF;

                    IF Lo_InfoPlantilla.NOMBRE_JURISDICCION IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.puntoCoberturaId.nombreJurisdiccion }}-->', Lo_InfoPlantilla.NOMBRE_JURISDICCION);
                    END IF;

                    IF Lo_InfoPlantilla.DIRECCION IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.direccion }}-->', Lo_InfoPlantilla.DIRECCION);
                    END IF;

                    IF Lo_InfoPlantilla.DESCRIPCION_PRODUCTO IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.productoId.descripcionProducto }}-->', Lo_InfoPlantilla.DESCRIPCION_PRODUCTO);
                    ELSE
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.planId.nombrePlan }}-->', Lo_InfoPlantilla.DESCRIPCION_PLAN);
                    END IF;

                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.feCreacion }}-->', Lo_DetalleSolicitud.FE_CREACION);
                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.usrCreacion}}-->', Lo_DetalleSolicitud.USR_CREACION);

                    IF Lo_DetalleSolicitud.FE_RECHAZO IS NOT NULL THEN

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna1Rcz }}-->', '<td><strong>Fecha de rechazo:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.FE_RECHAZO || '</td>');

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna1Rcz }}-->', '<td><strong>Usuario que rechaza:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.USR_RECHAZO || '</td>');

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna1Rcz }}-->', '<td><strong>Motivo de rechazo:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna2Rcz }}-->', ' N/A ');

                    END IF;

                    IF Lo_DetalleHistorial.FE_CREACION IS NOT NULL THEN
                      CASE 
                        WHEN Lo_DetalleHistorial.ESTADO = 'Planificada' THEN 

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Planificaci'|| chr(38) ||'oacute;n :</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Planific'|| chr(38) ||'oacute;:</strong> </td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION  || '</td>');

                        WHEN Lo_DetalleHistorial.ESTADO = 'Replanificada' THEN

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Replanificaci'|| chr(38) ||'oacute;n :</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Replanific'|| chr(38) ||'oacute;:</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  Replanificaci'|| chr(38) ||'oacute;n:</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                        WHEN Lo_DetalleHistorial.ESTADO = 'Detenido' THEN 
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de paralizacion (Detenido):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que detuvo (Detenido):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  paralizacion (Detenido):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                        WHEN Lo_DetalleHistorial.ESTADO = 'Anulado' THEN 
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de anulacion (Anulado):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que anulo (Anulado):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION  || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  anulacion (Anulado):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');
                      END CASE;
                    END IF;

                    IF Lo_DetalleSolicitud.OBSERVACION IS NOT NULL THEN 
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs1 }}-->', '<td><strong>Observacion:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs2 }}-->', '<td>' || Lo_DetalleSolicitud.OBSERVACION || '</td>');
                    END IF;

                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.estado }}-->', 'Finalizada'/*Lo_DetalleSolicitud.ESTADO*/);
                  END IF;
                END IF;

                /*SYS.UTL_MAIL.SEND(SENDER     => Lv_Remitente,
                      RECIPIENTS => Lv_ArrayTo,
                      CC         => '',
                      SUBJECT    => Lv_Asunto,
                      MIME_TYPE  => 'text/html; charset=us-ascii',
                      MESSAGE    => Lv_Cuerpo);*/
              ELSE
                --ENVIO CORREO

                SELECT PD.VALOR1
                  INTO Lv_Remitente
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET PD, DB_GENERAL.ADMI_PARAMETRO_CAB PC
                  WHERE PC.ID_PARAMETRO = PD.PARAMETRO_ID
                  AND   PC.NOMBRE_PARAMETRO = 'remitente'
                  AND   PC.ESTADO = 'Activo'
                  AND   PD.ESTADO = 'Activo'
                  AND   PD.EMPRESA_COD = apex_json.get_varchar2(p_path => 'data.codEmpresa');

                  IF Lv_Remitente = '' OR Lv_Remitente IS NULL THEN
                    Lv_Remitente := 'notificaciones_telcos@telconet.ec';
                  END IF;

                  IF C_ADMI_PLANTILLA%ISOPEN THEN
                    CLOSE C_ADMI_PLANTILLA;
                  END IF;
                  OPEN C_ADMI_PLANTILLA('RETIRO_TTCO_MD2');
                  FETCH C_ADMI_PLANTILLA
                    INTO Lo_AdmiPlantilla;
                  CLOSE C_ADMI_PLANTILLA;

                IF Lo_AdmiPlantilla.ID_PLANTILLA IS NOT NULL THEN
                  Lv_Cuerpo := Lo_AdmiPlantilla.PLANTILLA;
                  Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.id}}-->', Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                  IF C_INFO_PLANTILLA%ISOPEN THEN
                      CLOSE C_INFO_PLANTILLA;
                  END IF;
                  OPEN C_INFO_PLANTILLA(Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD);
                  FETCH C_INFO_PLANTILLA
                    INTO Lo_InfoPlantilla;
                  CLOSE C_INFO_PLANTILLA;

                  IF Lo_DetalleSolicitud.SERVICIO_ID IS NOT NULL  THEN

                    IF Lo_InfoPlantilla.RAZON_SOCIAL IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.razonSocial }}-->', Lo_InfoPlantilla.RAZON_SOCIAL);
                    ELSE
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ personaId.nombres.apellidos }}-->', Lo_InfoPlantilla.NOMBRES || ' ' || Lo_InfoPlantilla.APELLIDOS);
                    END IF;

                    IF Lo_InfoPlantilla.LOGIN IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.login }}-->', Lo_InfoPlantilla.LOGIN);
                    END IF;

                    IF Lo_InfoPlantilla.NOMBRE_JURISDICCION IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.puntoCoberturaId.nombreJurisdiccion }}-->', Lo_InfoPlantilla.NOMBRE_JURISDICCION);
                    END IF;

                    IF Lo_InfoPlantilla.DIRECCION IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.puntoId.direccion }}-->', Lo_InfoPlantilla.DIRECCION);
                    END IF;

                    IF Lo_InfoPlantilla.DESCRIPCION_PRODUCTO IS NOT NULL THEN
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.productoId.descripcionProducto }}-->', Lo_InfoPlantilla.DESCRIPCION_PRODUCTO);
                    ELSE
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.servicioId.planId.nombrePlan }}-->', Lo_InfoPlantilla.DESCRIPCION_PLAN);
                    END IF;

                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.feCreacion }}-->', Lo_DetalleSolicitud.FE_CREACION);
                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.usrCreacion}}-->', Lo_DetalleSolicitud.USR_CREACION);

                    IF Lo_DetalleSolicitud.FE_RECHAZO IS NOT NULL THEN

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna1Rcz }}-->', '<td><strong>Fecha de rechazo:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.FE_RECHAZO || '</td>');

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna1Rcz }}-->', '<td><strong>Usuario que rechaza:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2Rcz.columna2Rcz }}-->', '<td>' || Lo_DetalleSolicitud.USR_RECHAZO || '</td>');

                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna1Rcz }}-->', '<td><strong>Motivo de rechazo:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3Rcz.columna2Rcz }}-->', ' N/A ');

                    END IF;

                    IF Lo_DetalleHistorial.FE_CREACION IS NOT NULL THEN
                      CASE 
                        WHEN Lo_DetalleHistorial.ESTADO = 'Planificada' THEN 

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Planificaci'|| chr(38) ||'oacute;n :</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Planific'|| chr(38) ||'oacute;:</strong> </td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                        WHEN Lo_DetalleHistorial.ESTADO = 'Replanificada' THEN

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de Replanificaci'|| chr(38) ||'oacute;n :</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || ' | ' ||Lo_DetalleHistorial.FE_FIN_PLAN || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que Replanific'|| chr(38) ||'oacute;:</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  Replanificaci'|| chr(38) ||'oacute;n:</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                        WHEN Lo_DetalleHistorial.ESTADO = 'Detenido' THEN 
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de paralizacion (Detenido):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que detuvo (Detenido):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  paralizacion (Detenido):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');

                        WHEN Lo_DetalleHistorial.ESTADO = 'Anulado' THEN 
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna1DSH }}-->', '<td><strong>Fecha de anulacion (Anulado):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila1DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.FE_INI_PLAN || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna1DSH }}-->', '<td><strong>Usuario que anulo (Anulado):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila2DSH.columna2DSH }}-->', '<td>' || Lo_DetalleHistorial.USR_CREACION || '</td>');

                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna1DSH }}-->', '<td><strong>Motivo de  anulacion (Anulado):</strong></td>');
                          Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ fila3DSH.columna2DSH }}-->', ' N/A ');
                      END CASE;
                    END IF;

                    IF Lo_DetalleSolicitud.OBSERVACION IS NOT NULL THEN 
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs1 }}-->', '<td><strong>Observacion:</strong></td>');
                      Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ filaObs1.columnaObs2 }}-->', '<td>' || Lo_DetalleSolicitud.OBSERVACION || '</td>');
                    END IF;

                    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '<!--{{ detalleSolicitud.estado }}-->', 'Finalizada'/*Lo_DetalleSolicitud.ESTADO*/);
                  END IF;
                END IF;

                /*SYS.UTL_MAIL.SEND(SENDER     => Lv_Remitente,
                      RECIPIENTS => Lv_ArrayTo,
                      CC         => '',
                      SUBJECT    => Lv_Asunto,
                      MIME_TYPE  => 'text/html; charset=us-ascii',
                      MESSAGE    => Lv_Cuerpo);*/
              END IF;

              IF C_ADMI_MOTIVO%ISOPEN THEN
                CLOSE C_ADMI_MOTIVO;
              END IF;
              OPEN C_ADMI_MOTIVO;
              FETCH C_ADMI_MOTIVO
                INTO Lo_AdmiMotivo;
              CLOSE C_ADMI_MOTIVO;

              IF Lo_AdmiMotivo.ID_MOTIVO IS NOT NULL THEN

                IF C_INFO_SERVICIO_HISTORIAL%ISOPEN THEN
                  CLOSE C_INFO_SERVICIO_HISTORIAL;
                END IF;
                OPEN C_INFO_SERVICIO_HISTORIAL(Lo_Servicio.ID_SERVICIO,
                                               Lo_AdmiMotivo.ID_MOTIVO);
                FETCH C_INFO_SERVICIO_HISTORIAL
                  INTO Lo_InfoServHistCancel;
                CLOSE C_INFO_SERVICIO_HISTORIAL;

              END IF;
              /* Si el servicio fue cancelado automaticamente por procesos masivos se envia notificacion
              adicional a las jefaturas provinciales */
              IF Lo_InfoServHistCancel.ID_SERVICIO_HISTORIAL IS NOT NULL THEN
                Lv_Asunto := 'Solicitud de Retiro de Equipo #' ||
                             Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD ||
                             ' Finalizada generada por Cancelacion Automatica';
                --ENVIO CORREO
              END IF;

              --se de commit a la transaccion utilizada en actualizaciones de articulos en el naf
              Lv_MensajeResponse := 'Se finalizo el Retiro del Equipo con exito<br/><br/><b>Observacion en NAF</b><br/>';
              Lb_EstadoRetiro    := TRUE;

              IF TRIM(Lv_MsjErrFinVerActNaf) IS NOT NULL THEN
                Lv_MensajeResponse := Lv_MsjErrFinVerActNaf;
              ELSE
                Lv_MensajeResponse := 'El Retiro del Equipo fue realizado con exito';
              END IF;

            END IF; --cierre de if - valida si la bandera guardoElementos se encuentra en true  

          ELSE
            Pv_MensajeError := 'No existe el custodio asignado.';
          END IF;

        ELSE
          Pv_MensajeError := 'No existe el detalle de solicitud.';
        END IF;

      END IF;
    END IF;

    Pv_Mensaje := Lv_MensajeResponse;

    IF Lb_EstadoRetiro = TRUE THEN
      Pv_Status := 'OK';
    ELSE
      Pv_Status := 'ERROR';
    END IF;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'FIN - NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS', 
                                         'SE FINALIZO EL PROCEDIMIENTO P_FINALIZA_RETIRO_EQUIPOS SIN PROBLEMAS',
                                         --GEK_CONSULTA.F_RECUPERA_LOGIN,                        emunoz 11012023
                                         LOWER(USER),                                                   --emunoz 11012023
                                         SYSDATE,
                                         GEK_CONSULTA.F_RECUPERA_IP);

  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'ERROR NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS',
                                           Pv_MensajeError,
                                           --GEK_CONSULTA.F_RECUPERA_LOGIN,                      emunoz 11012023
                                           LOWER(USER),                                                 -- emunoz 11012023
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      ROLLBACK;

    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS: ' ||
                         SQLERRM || ' ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.P_FINALIZA_RETIRO_EQUIPOS',
                                           Pv_MensajeError,
                                          -- GEK_CONSULTA.F_RECUPERA_LOGIN,                      emunoz 11012023
                                          LOWER(USER),                                                  --- emunoz 11012023
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      IF INSTR(Pv_MensajeError, 'transfer timeout', 1) > 0 THEN
        Pv_Status       := 'OK';
        Pv_MensajeError := NULL;
      ELSE
        Pv_Status := 'X';
        ROLLBACK;
      END IF;
  END P_FINALIZA_RETIRO_EQUIPOS;

  PROCEDURE P_AUDITORIA_ESTADO_ARTICULOS (Pv_Serie        IN  VARCHAR2,
                                          Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_ELEMENTO(Cv_Serie VARCHAR2) IS
    SELECT 'X'
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
    WHERE SERIE_FISICA IN(Cv_Serie);

    CURSOR C_INFO_SIN_ELEMENTO(Cv_Serie VARCHAR2) IS
    SELECT * FROM(
    SELECT TB1.NUMERO_SERIE AS SERIE,
           TB2.COMPANIA AS COMPANIA,
           DECODE(TB1.ESTADO,'PI','Pendiente Instalar'
                            ,'IN','Instalado'
                            ,'PR','Pendiente Retirar'
                            ,'RE','Retirado'
                            ,'IB','Ingresado a Bodega'
                            ,'NE','No Entregado')AS ESTADO_REPOSITORIO,
           TB1.FE_ULT_MOD AS FECHA_REPOSITORIO,
           DECODE(TB2.ESTADO,'EB','En Bodega'
                            ,'FB','Fuera de Bodega'
                            ,'EL','Eliminado')AS ESTADO_BODEGA,
           CASE 
           WHEN TB2.FECHA_MODIFICA IS NOT NULL THEN
           TB2.FECHA_MODIFICA ELSE TB2.FECHA_CREA END AS FECHA_BODEGA
    FROM NAF47_TNET.IN_ARTICULOS_INSTALACION TB1,
         NAF47_TNET.INV_NUMERO_SERIE TB2
    WHERE TB1.NUMERO_SERIE=TB2.SERIE
    AND TB1.NUMERO_SERIE=Cv_Serie
    AND TB1.FE_ULT_MOD IN(SELECT MAX(FE_ULT_MOD) FROM NAF47_TNET.IN_ARTICULOS_INSTALACION WHERE NUMERO_SERIE IN(Cv_Serie))
    AND TB2.FECHA_MODIFICA IN(SELECT MAX(FECHA_MODIFICA) FROM NAF47_TNET.INV_NUMERO_SERIE WHERE SERIE IN(Cv_Serie)))
    WHERE ROWNUM<=1;

    CURSOR C_INFORMACION(Cv_Serie VARCHAR2)IS
    SELECT * FROM(
    SELECT TB1.SERIE_FISICA AS SERIE,
           TB1.ID_ELEMENTO AS ELEMENTO,
           TB1.ESTADO AS ESTADO_ELEMENTO,
           TRUNC(TB1.FE_CREACION) AS FECHA_ELEMENTO,
           TB3.COMPANIA AS COMPANIA,
           DECODE(TB2.ESTADO,'PI','Pendiente Instalar'
                            ,'IN','Instalado'
                            ,'PR','Pendiente Retirar'
                            ,'RE','Retirado'
                            ,'IB','Ingresado a Bodega'
                            ,'NE','No Entregado')AS ESTADO_REPOSITORIO,
           TB2.FE_ULT_MOD AS FECHA_REPOSITORIO,
           DECODE(TB3.ESTADO,'EB','En Bodega'
                            ,'FB','Fuera de Bodega'
                            ,'EL','Eliminado')AS ESTADO_BODEGA,
           CASE 
           WHEN TB3.FECHA_MODIFICA IS NOT NULL THEN
           TB3.FECHA_MODIFICA ELSE TB3.FECHA_CREA END AS FECHA_BODEGA
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO TB1,
         NAF47_TNET.IN_ARTICULOS_INSTALACION TB2,
         NAF47_TNET.INV_NUMERO_SERIE TB3
    WHERE TB1.SERIE_FISICA=TB2.NUMERO_SERIE
    AND TB1.SERIE_FISICA=TB3.SERIE
    AND TB1.SERIE_FISICA=Cv_Serie
    AND TB1.FE_CREACION IN(SELECT MAX(FE_CREACION) FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO WHERE SERIE_FISICA IN(Cv_Serie))
    AND TB2.FE_ULT_MOD IN(SELECT MAX(FE_ULT_MOD) FROM NAF47_TNET.IN_ARTICULOS_INSTALACION WHERE NUMERO_SERIE IN(Cv_Serie))
    AND TB3.FECHA_MODIFICA IN(SELECT MAX(FECHA_MODIFICA) FROM NAF47_TNET.INV_NUMERO_SERIE WHERE SERIE IN(Cv_Serie))
    ORDER BY TB1.ID_ELEMENTO)
    WHERE ROWNUM<=1;

    CURSOR C_INFORMACION_SOL(Cv_Serie VARCHAR2)IS
    SELECT * FROM(
    SELECT TB1.SERIE_FISICA AS SERIE,
           TB1.ID_ELEMENTO AS ELEMENTO,
           TB3.COMPANIA AS COMPANIA,
           TB1.ESTADO AS ESTADO_ELEMENTO,
           TRUNC(TB1.FE_CREACION) AS FECHA_ELEMENTO,
           DECODE(TB2.ESTADO,'PI','Pendiente Instalar'
                            ,'IN','Instalado'
                            ,'PR','Pendiente Retirar'
                            ,'RE','Retirado'
                            ,'IB','Ingresado a Bodega'
                            ,'NE','No Entregado')AS ESTADO_REPOSITORIO,
           TB2.FE_ULT_MOD AS FECHA_REPOSITORIO,
           DECODE(TB3.ESTADO,'EB','En Bodega'
                            ,'FB','Fuera de Bodega'
                            ,'EL','Eliminado')AS ESTADO_BODEGA,
           CASE 
           WHEN TB3.FECHA_MODIFICA IS NOT NULL THEN
           TB3.FECHA_MODIFICA ELSE TB3.FECHA_CREA END AS FECHA_BODEGA,
           TB4.ID_DETALLE_SOLICITUD AS ID_SOLICITUD,
           TRUNC(TB4.FE_CREACION) AS FECHA_SOLICITUD,
           TB4.ESTADO AS ESTADO_SOLICITUD
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO TB1,
          NAF47_TNET.IN_ARTICULOS_INSTALACION TB2,
          NAF47_TNET.INV_NUMERO_SERIE TB3,
          DB_COMERCIAL.INFO_DETALLE_SOLICITUD TB4
    WHERE TB1.SERIE_FISICA=TB2.NUMERO_SERIE
    AND TB1.SERIE_FISICA=TB3.SERIE
    AND TB1.SERIE_FISICA=Cv_Serie
    AND TB4.ID_DETALLE_SOLICITUD IN(SELECT DETALLE_SOLICITUD_ID FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
                                     WHERE VALOR=TO_CHAR(TB1.ID_ELEMENTO))
    AND TB4.TIPO_SOLICITUD_ID IN(SELECT ID_TIPO_SOLICITUD FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
                                  WHERE DESCRIPCION_SOLICITUD='SOLICITUD RETIRO EQUIPO')
    AND TB1.FE_CREACION IN(SELECT MAX(FE_CREACION) FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO WHERE SERIE_FISICA IN(Cv_Serie))
    AND TB2.FE_ULT_MOD IN(SELECT MAX(FE_ULT_MOD) FROM NAF47_TNET.IN_ARTICULOS_INSTALACION WHERE NUMERO_SERIE IN(Cv_Serie))
    AND TB3.FECHA_MODIFICA IN(SELECT MAX(FECHA_MODIFICA) FROM NAF47_TNET.INV_NUMERO_SERIE WHERE SERIE IN(Cv_Serie))
    ORDER BY TB1.ID_ELEMENTO)
    WHERE ROWNUM<=1;                                                 

    CURSOR C_SOLICITUD(Cn_Elemento number) IS
    SELECT 'X'
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    WHERE ID_DETALLE_SOLICITUD IN(SELECT DETALLE_SOLICITUD_ID 
                                   FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
                                   WHERE VALOR=TO_CHAR(Cn_Elemento))
    AND TIPO_SOLICITUD_ID IN(SELECT ID_TIPO_SOLICITUD FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
                                  WHERE DESCRIPCION_SOLICITUD='SOLICITUD RETIRO EQUIPO');

    Lv_Serie      VARCHAR2(100);
    Lc_Elemento   C_ELEMENTO%ROWTYPE;
    Lc_Solicitud  C_SOLICITUD%ROWTYPE;
    Lb_Found      BOOLEAN;
    Ln_Elemento   NUMBER;
  BEGIN
     Lv_Serie:=Pv_Serie;
     FOR I IN C_INFO_SIN_ELEMENTO(Lv_Serie)
     LOOP
        /*Cursor que verifica si existe el articulo en Telcos*/
        OPEN C_ELEMENTO(Lv_Serie);
        FETCH C_ELEMENTO INTO Lc_Elemento;
        Lb_Found:=C_ELEMENTO%NOTFOUND;
        CLOSE C_ELEMENTO;
        /*Si no existe la serie en telcos*/
        IF(Lb_Found)THEN
           INSERT INTO NAF47_TNET.ARIN_ESTADO_ARTICULO(ID_ESTADO_ARTICULO,SERIE,COMPANIA,ESTADO_ELEMENTO,FECHA_ELEMENTO,
                                                      ESTADO_REPOSITORIO,FECHA_REPOSITORIO,
                                                      ESTADO_BODEGA,FECHA_BODEGA,ID_SOLICITUD,
                                                      FECHA_SOLICITUD,ESTADO_SOLICITUD,
                                                      USR_CREACION,FE_CREACION,USR_MODIFICA,FE_MODIFICA,ESTADO_TRANSACCION)
          VALUES(NAF47_TNET.SEQ_ARIN_ESTADO_ARTICULO.NEXTVAL,I.SERIE,I.COMPANIA,NULL,NULL,
                 I.ESTADO_REPOSITORIO,I.FECHA_REPOSITORIO,I.ESTADO_BODEGA,I.FECHA_BODEGA,
                 NULL,NULL,NULL,USER,TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),USER,TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),'P');
        ELSE/*Si existe la serie en Telcos*/
          FOR Z IN C_INFORMACION(Lv_Serie) LOOP
            Ln_Elemento:=Z.ELEMENTO;
            /*Cursor que verifica si existe solicitud de retiro*/
            OPEN C_SOLICITUD(Ln_Elemento);
            FETCH C_SOLICITUD INTO Lc_Solicitud;
            Lb_Found:=C_SOLICITUD%NOTFOUND;
            CLOSE C_SOLICITUD;
            /*Si no existe solicitud de retiro*/
            IF(Lb_Found)THEN
              INSERT INTO NAF47_TNET.ARIN_ESTADO_ARTICULO(ID_ESTADO_ARTICULO,SERIE,COMPANIA,ESTADO_ELEMENTO,FECHA_ELEMENTO,
                                                          ESTADO_REPOSITORIO,FECHA_REPOSITORIO,
                                                          ESTADO_BODEGA,FECHA_BODEGA,ID_SOLICITUD,
                                                          FECHA_SOLICITUD,ESTADO_SOLICITUD,
                                                          USR_CREACION,FE_CREACION,USR_MODIFICA,FE_MODIFICA,ESTADO_TRANSACCION)
              VALUES(NAF47_TNET.SEQ_ARIN_ESTADO_ARTICULO.NEXTVAL,Z.SERIE,Z.COMPANIA,Z.ESTADO_ELEMENTO,
                     Z.FECHA_ELEMENTO,Z.ESTADO_REPOSITORIO,Z.FECHA_REPOSITORIO,Z.ESTADO_BODEGA,Z.FECHA_BODEGA,
                     NULL,NULL,NULL,USER,TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),USER,TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),'P');
            ELSE /*Si existe solicitud de retiro*/
              FOR J IN C_INFORMACION_SOL(Lv_Serie)
              LOOP
                INSERT INTO NAF47_TNET.ARIN_ESTADO_ARTICULO(ID_ESTADO_ARTICULO,SERIE,COMPANIA,ESTADO_ELEMENTO,FECHA_ELEMENTO,
                                                            ESTADO_REPOSITORIO,FECHA_REPOSITORIO,
                                                            ESTADO_BODEGA,FECHA_BODEGA,ID_SOLICITUD,
                                                            FECHA_SOLICITUD,ESTADO_SOLICITUD,
                                                            USR_CREACION,FE_CREACION,USR_MODIFICA,FE_MODIFICA,ESTADO_TRANSACCION)
                VALUES(NAF47_TNET.SEQ_ARIN_ESTADO_ARTICULO.NEXTVAL,J.SERIE,J.COMPANIA,J.ESTADO_ELEMENTO,
                       J.FECHA_ELEMENTO,J.ESTADO_REPOSITORIO,J.FECHA_REPOSITORIO,J.ESTADO_BODEGA,J.FECHA_BODEGA,
                       J.ID_SOLICITUD,J.FECHA_SOLICITUD,J.ESTADO_SOLICITUD,USER,TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),USER,TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),'P');
              END LOOP;
            END IF;
          END LOOP;  
        END IF;
     END LOOP;

     EXCEPTION
        WHEN OTHERS THEN
        Pv_MensajeError := 'Error en NAF47_TNET.P_AUDITORIA_ESTADO_ARTICULOS: ' || SQLERRM;

  END P_AUDITORIA_ESTADO_ARTICULOS;

  PROCEDURE P_CAMBIA_ESTADO_SOLICITUD(Pv_Solicitud    IN  NUMBER,
                                      Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_TIPO_SOLICITUD IS
    SELECT ID_TIPO_SOLICITUD FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
    WHERE DESCRIPCION_SOLICITUD='SOLICITUD RETIRO EQUIPO';

    CURSOR C_TIPO_CARACT IS
    SELECT ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA 
    WHERE DESCRIPCION_CARACTERISTICA='ELEMENTO CLIENTE';

    Lc_Tipo_Solicitud C_TIPO_SOLICITUD%ROWTYPE;
    Lc_Caracteristica C_TIPO_CARACT%ROWTYPE;
    Lv_Solicitud      NAF47_TNET.ARIN_ESTADO_ARTICULO.ID_SOLICITUD%TYPE;
    Lv_Ip             DB_COMERCIAL.INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE;
    Lv_Tipo_Sol       DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
    Lv_Caract         DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;

  BEGIN
    Lv_Solicitud:=Pv_Solicitud;
    Lv_Ip:=NAF47_TNET.GEK_CONSULTA.F_RECUPERA_IP;

    IF C_TIPO_SOLICITUD%ISOPEN THEN CLOSE C_TIPO_SOLICITUD; END IF;
    OPEN C_TIPO_SOLICITUD;
    FETCH C_TIPO_SOLICITUD INTO Lc_Tipo_Solicitud;
    CLOSE C_TIPO_SOLICITUD;
    Lv_Tipo_Sol:=Lc_Tipo_Solicitud.ID_TIPO_SOLICITUD;

    IF C_TIPO_CARACT%ISOPEN THEN CLOSE C_TIPO_CARACT; END IF;
    OPEN C_TIPO_CARACT;
    FETCH C_TIPO_CARACT INTO Lc_Caracteristica;
    Lv_Caract:=Lc_Caracteristica.ID_CARACTERISTICA;
    /*Se inserta detalle en el historial, en la tabla info_detalle_sol_hist*/
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,ESTADO,FE_INI_PLAN,FE_FIN_PLAN,OBSERVACION,
    USR_CREACION,FE_CREACION,IP_CREACION,MOTIVO_ID)
    VALUES(DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,Lv_Solicitud,'AsignadoTarea',NULL,NULL,'Se actualiza el estado de Finalizada a AsignadoTarea mediante el proceso de reactivacion de solicitud de retiro.',
    USER,SYSDATE,Lv_Ip,null);
    /*Se actualiza el estado en la cabecera y en el detalle de la solicitud*/
    UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SET ESTADO='AsignadoTarea', USR_ULT_MOD=USER, FE_ULT_MOD=TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS')
    WHERE DETALLE_SOLICITUD_ID=Lv_Solicitud AND ESTADO='Finalizada' AND caracteristica_id IN(Lv_Caract);
    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET ESTADO='AsignadoTarea'
    WHERE ID_DETALLE_SOLICITUD=Lv_Solicitud AND ESTADO='Finalizada' AND TIPO_SOLICITUD_ID IN(Lv_Tipo_Sol);
    UPDATE NAF47_TNET.ARIN_ESTADO_ARTICULO SET ESTADO_SOLICITUD='AsignadoTarea',USR_MODIFICA=USER, FE_MODIFICA=TO_DATE(SYSDATE,'DD-MM-RRRR HH24:MI:SS'),ESTADO_TRANSACCION='L'
    WHERE ID_SOLICITUD=Lv_Solicitud AND ESTADO_TRANSACCION='P';
    EXCEPTION
      WHEN OTHERS THEN
       Pv_MensajeError:='Error en NAF47_TNET.P_CAMBIA_ESTADO_SOLICITUD: ' || SQLERRM;

  END P_CAMBIA_ESTADO_SOLICITUD;

  PROCEDURE P_REGISTRA_TRANSF_RESERVA (Pt_Arinte    IN OUT  Gt_Arinte%ROWTYPE,
                                       Pt_Arintl    IN OUT  Gt_Arintl%ROWTYPE,
                                       Pv_MensajeError OUT VARCHAR2)IS
  CURSOR C_TOTAL_SERIES_DISPONIBLES IS
  SELECT COUNT(*) TOTAL FROM NAF47_TNET.INV_NUMERO_SERIE
  WHERE COMPANIA=Pt_Arintl.NO_CIA
  AND NO_ARTICULO=Pt_Arintl.NO_ARTI
  AND ID_BODEGA=Pt_Arintl.BOD_ORIG;

  CURSOR C_SERIES_DISPONIBLES IS
  SELECT * FROM NAF47_TNET.INV_NUMERO_SERIE
  WHERE COMPANIA=Pt_Arintl.NO_CIA
  AND NO_ARTICULO=Pt_Arintl.NO_ARTI
  AND ID_BODEGA=Pt_Arintl.BOD_ORIG
  AND ROWNUM<=Pt_Arintl.CANTIDAD;

  CURSOR C_REQUIERE_SERIE (Cv_NoArti NAF47_TNET.ARINDA.NO_ARTI%TYPE)IS
  SELECT IND_REQUIERE_SERIE
   FROM NAF47_TNET.ARINDA
  WHERE NO_ARTI = Cv_NoArti;

  CURSOR C_LOGIN_JEFE_BOD IS
  SELECT E.LOGIN_EMPLE FROM NAF47_TNET.ARINBO B, NAF47_TNET.V_EMPLEADOS_EMPRESAS E
  WHERE B.NO_CIA=E.NO_CIA
  AND B.NO_EMPLE= E.NO_EMPLE
  AND B.NO_CIA=Pt_Arintl.NO_CIA
  AND B.CODIGO=Pt_Arintl.BOD_ORIG;

  Lt_DetalleTrasnf NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf := NAF47_TNET.INKG_TRANSFERENCIAS.Gt_Detalle_Transf();
  Lt_InvNumeroSerie NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE;
  Lc_SeriesDisponibles C_SERIES_DISPONIBLES%ROWTYPE;
  Lc_LoginJefe C_LOGIN_JEFE_BOD%ROWTYPE;
  Lv_RequiereSerie VARCHAR2(2);
  Lv_NoDocuRecibe VARCHAR2(12);
  Lv_ObsInfoDetalle VARCHAR2(3000);
  Ln_TotalSeries NUMBER;
  Lb_Jefe BOOLEAN := FALSE;
  Le_Error EXCEPTION;
  BEGIN

   IF Pt_Arinte.NO_DOCU is null THEN
      Pt_Arinte.NO_DOCU := NAF47_TNET.TRANSA_ID.INV(Pt_Arinte.NO_CIA);
      Pt_Arintl.NO_DOCU := Pt_Arinte.NO_DOCU;
   END IF;

   Pt_Arinte.TSTAMP := SYSDATE;
   Pt_Arinte.FECHA := SYSDATE;
   Pt_ArintL.TSTAMP := SYSDATE;
   Pt_Arinte.PERIODO := TO_CHAR(SYSDATE,'YYYY');
   Pt_Arintl.PERIODO := TO_CHAR(SYSDATE,'YYYY');

   OPEN C_REQUIERE_SERIE(Pt_Arintl.NO_ARTI);
     FETCH C_REQUIERE_SERIE INTO Lv_RequiereSerie;
   CLOSE C_REQUIERE_SERIE;

   OPEN C_TOTAL_SERIES_DISPONIBLES;
     FETCH C_TOTAL_SERIES_DISPONIBLES INTO Ln_TotalSeries;
   CLOSE C_TOTAL_SERIES_DISPONIBLES;   


   P_INSERTA_ARINTE(Pt_Arinte,
                    Pv_MensajeError);
   IF Pv_MensajeError IS NOT NULL THEN
     RAISE Le_Error;
   END IF;

   P_INSERTA_ARINTL(Pt_Arintl,
                    Pv_MensajeError);

   IF Pv_MensajeError IS NOT NULL THEN
     RAISE Le_Error;
   END IF;

   IF NVL(Lv_RequiereSerie,'N')='S' AND Ln_TotalSeries>=Pt_Arintl.CANTIDAD  THEN 

     FOR Lc_SeriesDisponibles IN C_SERIES_DISPONIBLES LOOP
       Lt_InvNumeroSerie.COMPANIA := Pt_Arintl.NO_CIA;
       Lt_InvNumeroSerie.NO_DOCUMENTO := Pt_Arintl.NO_DOCU;
       Lt_InvNumeroSerie.NO_ARTICULO := Pt_Arintl.NO_ARTI;
       Lt_InvNumeroSerie.SERIE := Lc_SeriesDisponibles.SERIE;
       Lt_InvNumeroSerie.ORIGEN := 'PE';
       Lt_InvNumeroSerie.USUARIO_CREA := USER;
       Lt_InvNumeroSerie.FECHA_CREA := SYSDATE;
       Lt_InvNumeroSerie.MAC := Lc_SeriesDisponibles.MAC;
       Lt_InvNumeroSerie.UNIDADES := 1;

       P_INSERTA_NUMERO_SERIE(Lt_InvNumeroSerie,
                              Pv_MensajeError);

       IF Pv_MensajeError IS NOT NULL THEN
         RAISE Le_Error;
       END IF;
     END LOOP;

   END IF;

   NAF47_TNET.INKG_TRANSFERENCIAS.P_SALIDA_BODEGA_ORIGEN(Pt_Arinte.NO_DOCU,
                                                         Pt_Arinte.centro,
                                                         Pt_Arinte.no_cia,
                                                         Pv_MensajeError);

   IF Pv_MensajeError IS NOT NULL THEN
     RAISE Le_Error;
   END IF;  

   Lt_DetalleTrasnf.EXTEND;
   Lt_DetalleTrasnf(1).BODEGA_ORIGEN := Pt_Arintl.BOD_ORIG;
   Lt_DetalleTrasnf(1).BODEGA_DESTINO := Pt_Arintl.BOD_DEST;
   Lt_DetalleTrasnf(1).NO_ARTICULO := Pt_Arintl.NO_ARTI;
   Lt_DetalleTrasnf(1).CANTIDAD := Pt_Arintl.CANTIDAD; 

   NAF47_TNET.INKG_TRANSFERENCIAS.P_RECIBE_TRANSFERENCIA (Pt_Arinte.NO_DOCU,
                                                          Pt_Arinte.centro,
                                                          Pt_Arinte.NO_CIA,  
                                                          Lt_DetalleTrasnf,
                                                          Lv_NoDocuRecibe,
                                                          Pv_MensajeError);
   IF Pv_MensajeError IS NOT NULL THEN
     RAISE Le_Error;
   ELSIF Lv_NoDocuRecibe IS NULL THEN
     Pv_MensajeError := 'No se enviaron articulos a recibir!!!';
   RAISE Le_Error;
   ELSE
     OPEN C_LOGIN_JEFE_BOD;
     FETCH C_LOGIN_JEFE_BOD INTO Lc_LoginJefe;
       IF C_LOGIN_JEFE_BOD%FOUND THEN
         Lb_Jefe :=TRUE;
       END IF;
     CLOSE C_LOGIN_JEFE_BOD;

     IF Lb_Jefe THEN 
       Lv_ObsInfoDetalle:='Se realizo una transferencia por motivo de reserva de pedidos '||
       CHR(13)|| 'Documento de transferencia: '||Pt_Arinte.NO_DOCU;
       NAF47_TNET.INKG_TRANSFERENCIAS.P_CREA_TAREA_TRANSFERENCIAS (Pt_Arinte.NO_CIA,
                                                                   Lv_ObsInfoDetalle,
                                                                   Lc_LoginJefe.LOGIN_EMPLE,
                                                                   Pv_MensajeError);
       IF Pv_MensajeError IS NOT NULL THEN
         RAISE Le_Error;
       END IF;
     END IF;
   END IF;                                                          

  EXCEPTION 

  WHEN Le_Error THEN
    ROLLBACK;
   --Se devuelve error en variable de salida Pv_MensajeError y se bitacoriza
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'P_REGISTRA_TRANSF_RESERVA',
                                           Pv_MensajeError,
                                           --GEK_CONSULTA.F_RECUPERA_LOGIN,              emunoz 11012023
                                           LOWER(USER),                                         -- emunoz 11012023
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);

  WHEN OTHERS THEN
    ROLLBACK;
   --Se presenta error general al usuario y se bitacoriza 
   Pv_MensajeError := 'Error general favor comunicar a Sistemas';
   DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'P_REGISTRA_TRANSF_RESERVA',
                                           'Error en P_REGISTRA_TRANSF_RESERVA: '||SQLERRM,
                                           --GEK_CONSULTA.F_RECUPERA_LOGIN,              emunoz 11012023
                                           LOWER(USER),                                         --emunoz 11012023
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);


  END P_REGISTRA_TRANSF_RESERVA;

  FUNCTION F_NOTIFICACION_MAIL(Pv_Remitente    VARCHAR2,
                               Pv_Destinatario VARCHAR2,
                               Pv_Copia        VARCHAR2,
                               pv_Asunto       VARCHAR2,
                               pv_Mensaje      VARCHAR2)  RETURN NUMBER IS
    CURSOR C_BANDERA_RECURRENCIA IS
    SELECT PARAMETRO_ALTERNO 
        FROM NAF47_TNET.GE_PARAMETROS x, NAF47_TNET.GE_GRUPOS_PARAMETROS y
        WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
          AND X.ID_APLICACION = Y.ID_APLICACION
          AND X.ID_EMPRESA = Y.ID_EMPRESA
          AND X.ID_GRUPO_PARAMETRO = 'MAIL_SOL_PRES'
          AND X.DESCRIPCION='MAIL'
          AND X.ID_APLICACION = 'CO'
          AND X.ESTADO = 'A'
          AND Y.ESTADO = 'A';

    Lv_Remitente VARCHAR2(200);
    BEGIN
    IF Pv_Remitente IS NULL OR Pv_Remitente='' THEN
      OPEN C_BANDERA_RECURRENCIA;
      FETCH C_BANDERA_RECURRENCIA INTO Lv_Remitente;
      CLOSE C_BANDERA_RECURRENCIA;
    ELSE
      Lv_Remitente:=Pv_Remitente;
    END IF;
    SYS.UTL_MAIL.SEND(SENDER     => Lv_Remitente,
                      RECIPIENTS => Pv_Destinatario,
                      CC         => Pv_Copia,
                      SUBJECT    => pv_Asunto,
                      MIME_TYPE  => 'text/html; charset=us-ascii',
                      MESSAGE    => pv_Mensaje);
     RETURN 1;                 
    EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END F_NOTIFICACION_MAIL;

END INKG_TRANSACCION;
/