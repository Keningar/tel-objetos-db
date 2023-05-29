CREATE OR REPLACE package NAF47_TNET.AFK_CONTROL_CUSTODIO is
  /**
  * Documentacion para NAF47_TNET.AFK_CONTROL_CUSTODIO
  * Paquete que contiene procesos y funciones para registrar control articulos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  */

  -- Declaracion de Constantes --
  Gc_EstadoAsignado CONSTANT VARCHAR2(08) := 'Asignado';
  Gc_EstadoProcesado CONSTANT VARCHAR2(08) := 'Generado';


  /**
  * Documentacion para NAF47_TNET.AFK_CONTROL_CUSTODIO.TypeControlCustodio
  * Variable Registro que permite pasar por parametro los datos necesarios para el registro de control de articulos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 02/10/2018 Se agrega el campo Observacion
   *
  * @author Elvis Munoz <emunoz@telconet.ec>
  * @version 1.1 15/01/2023 Se Procede al cambio de la funcion GEK_CONSULTA.F_RECUPERA_LOGIN por la senetencia LOWER(USER)
  */

  TYPE TypeControlCustodio IS RECORD(
    ID_CONTROL          ARAF_CONTROL_CUSTODIO.ID_CONTROL%TYPE, -- Identificacion registro desde donde se transfiere
    NUMERO_SERIE        ARAF_CONTROL_CUSTODIO.ARTICULO_ID%TYPE, -- numero de serie para equipos/fibra y Cod Articulo NAF para materiales
    TIPO_ARTICULO       ARAF_CONTROL_CUSTODIO.TIPO_ARTICULO%TYPE, -- tipo de articulo Fibra, Equipo, Material
    EMPRESA_ID          ARAF_CONTROL_CUSTODIO.EMPRESA_ID%TYPE, -- empresa asociado al id persona empresa rol
    CUSTODIO_ENTREGA_ID ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Cliente/Empleado/Contratista que traspasa articulo
    CANTIDAD_ENTREGA    ARAF_CONTROL_CUSTODIO.CANTIDAD%TYPE, -- cantidad a procesar
    CUSTODIO_RECIBE_ID  ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Cliente/Empleado/Contratista que recibe articulo
    CANTIDAD_RECIBE    ARAF_CONTROL_CUSTODIO.CANTIDAD%TYPE, -- cantidad a procesar
    TIPO_TRANSACCION    ARAF_CONTROL_CUSTODIO .TIPO_TRANSACCION_ID%TYPE, -- tipo transaccion: Instalacion, CambioEquipo, RetiroEquipo, etc
    TRANSACCION_ID      ARAF_CONTROL_CUSTODIO.TRANSACCION_ID%TYPE, -- # transaccion: Id Solcitud retiro, Id solicitud cambio, etc
    TIPO_ACTIVIDAD      ARAF_CONTROL_CUSTODIO.TIPO_ACTIVIDAD%TYPE, -- Tipo Actividad: Instalacion, Soporte
    TAREA_ID            ARAF_CONTROL_CUSTODIO.TAREA_ID%TYPE, -- numero tarea asociada a la instalacion
    LOGIN               ARAF_CONTROL_CUSTODIO.LOGIN%TYPE, -- login servicio
    LOGIN_EMPLEADO      ARAF_CONTROL_CUSTODIO.LOGIN%TYPE, -- Login Empleado Procesa
    CARACTERISTICA_ID   ARAF_CONTROL_CUSTODIO.CARACTERISTICA_ID%TYPE, -- Caracteristica
    OBSERVACION         ARAF_CONTROL_CUSTODIO.OBSERVACION%TYPE -- Observacion
    );
  --
  TYPE TypeIngresoBodegaCC IS RECORD (
    CUSTODIO_ID         ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Empleado/Contratista que traspasa articulo
    EMPRESA_ID          ARINME.NO_CIA%TYPE, -- Codigo de empresa
    CENTRO_ID           ARINME.CENTRO%TYPE, -- Codigo de centro distribucion
    CUSTODIO_NAF_ID     ARINME.EMPLE_SOLIC%TYPE, --Codigo de empleado/Contartista de NAF
    TIPO_INGRESO_ID     ARINME.TIPO_DOC%TYPE, -- Tipo de Documento de Ingreso
    OBSERVACION         ARINME.OBSERV1%TYPE, -- Observacion
    BODEGA_ID           ARINML.BODEGA%TYPE, -- Codigo Bodega registra ingreso
    CANTIDAD            ARINML.UNIDADES%TYPE, -- cantidad a procesar
    ARTICULO_ID         ARINDA.NO_ARTI%TYPE, -- codigo de Articulo
    MANEJA_SERIE        VARCHAR2(2), -- Indica si maneja numero de Serie
    NUMERO_SERIE        ARAF_CONTROL_CUSTODIO.ARTICULO_ID%TYPE, -- Numero de serie registrado
    ID_CONTROL          ARAF_CONTROL_CUSTODIO.ID_CONTROL%TYPE, -- Identificacion registro desde donde se transfiere
    GENERA_SERIE        VARCHAR2(1) DEFAULT 'N'
  );
  --
  /**
  * Documentacion para NAF47_TNET.AFK_CONTROL_CUSTODIO.Gt_TransfCustodio
  * Variable Tipo Tabla que permite pasar por parametro los datos necesarios para control de articulos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  */
  TYPE Gt_TransfCustodio IS TABLE OF TypeControlCustodio INDEX BY BINARY_INTEGER;

  TYPE Gt_IngresoBodegaCC IS TABLE OF TypeIngresoBodegaCC INDEX BY BINARY_INTEGER;


  /**
  * Documentacion para P_TRANSFERENCIA
  * Procedure interno que procesa las trasnferencias usando arreglo
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 15/08/2018 -  Se renombra procedimiento y se corrige error generado cuando custodio entrega se queda con cero stock
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 07/09/2018 -  Se modifica para ejecutar el proceso en base id control.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 09/03/2019 -  Se modifica proceso para considerar las devoluciones dentro del proceso control custodio.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.4 23/09/2019 -  Se modifica proceso asignar estados, controlar saldo cero y controlar las devoluciones.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.5 04/10/2019 -  Se modifica proceso para agregar funcionalidad de fragmentacion de articulos
  *
  * @author banton <banton@telconet.ec>
  * @version 1.6 28/09/2021 -  Se modifica para validar tipos de articulo, antes solo fibra 
  *
  * @author emunoz <banton@telconet.ec>
  * @version 1.7 08/02/2022 -  Se modifica para validar la regularizacion de fibra
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.8 17/01/2022 -  Se modifica para considerar nuevo flujo de retiro/cambio equipo de nodos
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.9 24/04/2022 -  Se modifica recuperar login cuando registro existe asociado a un custodio y reflejar correctamente el login
  *
  * @param Pt_Transferencia IN     ARRAY    Recibe arreglo con registro para insertar en control custodio
  * @param Pv_MensajeError  IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_TRANSFERENCIA(Pt_Transferencia IN AFK_CONTROL_CUSTODIO.Gt_TransfCustodio,
                            Pv_MensajeError  IN OUT VARCHAR2);
  --

 /**
  * Documentacion para P_GENERA_INGRESO_BODEGA
  * Procedure que genera ingreso a bodega a partir de la fibra retirada.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/12/2018
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 24/01/2020 - Se modifica para recuperar correctamente los datos del custodio que entrega la fibra a bodega
  *                           para los casos de empleados Telconet retiran fibra empresa Megadatos
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 30/07/2021 - Se modifica para considerar nuevos campos cantidad_segmento, serie_original en proceso retiro fibra
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 14/09/2021 - Se corrige validacion para generar serie desde check enviado por pantalla y no de configuracion del articulo
  *
  * @param Pt_DatosIB      IN     VARCHAR2 Recibe registro de Ingreso a Bodega
  * @param Pv_IngBodegaId  IN OUT VARCHAR2 Retorna numero de ingreso a bodega generado.
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_GENERA_INGRESO_BODEGA ( Pt_DatosIB      IN Gt_IngresoBodegaCC,
                                      Pv_IngBodegaId  IN OUT VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2);



  /**
  * Documentacion para P_TRANSFIERE_CUSTODIO
  * Procedure que registra asignaciones y entregad de articulos que se transfieren entre personas (Cliente, Empleado, etc)
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 07/09/2018  -  Se modifica para agregar parmetro que identifica al registro a se trasnferido
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.2 02/10/2018  -  Se agrega el campo observacion.
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.3 11/12/2018  -  Se agrega parametro Cantidad Recibe para identificar cuando se asigna o recibe cantidades
                             -  Se modifica para considerar nuevos escenarios para control de Materiales.
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.4 19/02/2019  -  Se modifica el paquete para procesar transferencias masivas de articulos asignados al tecnico
                             -  utilizando metodo FIFO
  *
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.5 28/09/2021  -  Se modifica para considerar tipos de articulo, antes solo fibra
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.6 17/01/2022 -  Se modifica para considerar nuevo flujo de retiro/cambio equipo de nodos
  *  
  * @author llindao <llindao@telconet.ec>
  * @version 1.8 17/02/2022 -  Se corrige error al procesar articulos existentes control custodio, se cargaban parametros y no registro recuperado
  *  
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.9 01/03/2022  -  Se modifica para validar proceso de ingreso a bodega vs devoluciones/Retiro.
  *
  * @param Pv_NumeroSerie      IN VARCHAR2 Recibe nmero de serie a registrar
  * @param Pn_IdCaracteristica IN VARCHAR2 Recibe carcaterstica artculo
  * @param Pv_IdEmpresa        IN VARCHAR2 Recibe cdigo de empresa
  * @param Pn_IdCustodioEnt    IN NUMBER   Recibe custodio entrega artculo
  * @param Pn_CantidadEnt      IN NUMBER   Recibe cantidad a reducir de custodio actual
  * @param Pn_IdCustodioRec    IN NUMBER   Recibe custodio Recibe artculo
  * @param Pn_CantidadRec      IN NUMBER   Recibe cantidad a asignar a nuevo custodio
  * @param Pv_TipoTransaccion  IN VARCHAR2 Recibe Tipo Transacin
  * @param Pv_IdTransaccion    IN VARCHAR2 Recibe nmero de transaccion
  * @param Pv_TipoActividad    IN VARCHAR2 Recibe tipo de actividad
  * @param Pn_IdCaso           IN NUMBER   Recbe cdigo de caso
  * @param Pn_IdTarea          IN NUMBER   recibe Cdigo de Tarea
  * @param Pv_Login            IN VARCHAR2 Recibe Login
  * @param Pv_LoginProcesa     IN VARCHAR2 Recibe Login procesa
  * @param Pv_MensajeError     IN OUT VARCHAR2  retorna error
  * @param Pn_IdControl        IN VARCHAR2 Recibe codigo de control a procesar
  * @param Pv_Observacion      IN ARAF_CONTROL_CUSTODIO.OBSERVACION%TYPE DEFAULT NULL
  */
  --  

  PROCEDURE P_TRANSFIERE_CUSTODIO(Pv_NumeroSerie      IN ARAF_CONTROL_CUSTODIO.ARTICULO_ID%TYPE, -- numero de serie para equipos/fibra y Cod Articulo NAF para materiales
                                  Pn_IdCaracteristica IN ARAF_CONTROL_CUSTODIO.CARACTERISTICA_ID%TYPE, -- Caracteristica
                                  Pv_IdEmpresa        IN ARAF_CONTROL_CUSTODIO.EMPRESA_ID%TYPE, -- empresa asociado al id persona empresa rol
                                  Pn_IdCustodioEnt    IN ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Cliente/Empleado/Contratista que traspasa articulo
                                  Pn_CantidadEnt      IN ARAF_CONTROL_CUSTODIO.CANTIDAD%TYPE, -- cantidad a procesar
                                  Pn_IdCustodioRec    IN ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Cliente/Empleado/Contratista que recibe articulo
                                  Pn_CantidadRec      IN ARAF_CONTROL_CUSTODIO.CANTIDAD%TYPE, -- cantidad a procesar
                                  Pv_TipoTransaccion  IN ARAF_CONTROL_CUSTODIO.TIPO_TRANSACCION_ID%TYPE, -- tipo transaccion: Tarea, Caso
                                  Pv_IdTransaccion    IN ARAF_CONTROL_CUSTODIO.TRANSACCION_ID%TYPE, -- # transaccion: numero tarea, numero caso
                                  Pv_TipoActividad    IN ARAF_CONTROL_CUSTODIO.TIPO_ACTIVIDAD%TYPE, -- Tipo Actividad: Instalacion, Soporte
                                  Pn_IdTarea          IN ARAF_CONTROL_CUSTODIO.TAREA_ID%TYPE, -- numero tarea asociada a la instalacion
                                  Pv_Login        IN ARAF_CONTROL_CUSTODIO.LOGIN%TYPE, -- login servicio
                                  Pv_LoginProcesa IN ARAF_CONTROL_CUSTODIO.LOGIN%TYPE, -- login usuario procesa
                                  Pv_MensajeError IN OUT VARCHAR2,
                                  Pn_IdControl    IN ARAF_CONTROL_CUSTODIO.ID_CONTROL%TYPE DEFAULT 0,
                                  Pv_Observacion  IN ARAF_CONTROL_CUSTODIO.OBSERVACION%TYPE DEFAULT NULL,
                                  Pv_TipoArticulo IN ARAF_CONTROL_CUSTODIO.TIPO_ARTICULO%TYPE, -- Tipo de Articulo Fibra, Equpo, Materiales, etc
                                  Pb_Commit	  IN BOOLEAN DEFAULT TRUE);

  /**
  * Documentacion para P_ARTICULO_CONTROL
  * Procedure que registra los despachos / asignaciones de equipos desde la Bodega
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 25/08/2018 - Se modifica replicar a Telcos los contratista registrados en NAF que no se encuentran creados en Telcos
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 09/05/2019 - Se modifica para considerar serie anterior como descuento en control custodio (Ingreso a bodega) 
  *                           y la serie generada como asigancion a control de custodio (Despacho a Bodega)
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 23/09/2019 - Se modifica para identificar las devoluciones a bodegas de los ingresos por compras.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.4 04/10/2019 - Se modifica para mantener numero serie original en los tramos que reingresan a bodega.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.5 21/05/2021 - Se modifica para corregir busqueda de codigo de empleados en tecos porque esta retornado un codigo con rol inactivo.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.6 30/07/2021 - Se modifica para considerar proceso de generacion automatica de numeros de series.
  *
  * @author banton <banton@telconet.ec>
  * @version 1.7 28/09/2021 - Se modifica para considerar tipos de articulos, antes solo fibra.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.8 17/02/2022 - Se corrige asignacion de cantidad de articulos que manejan segmentos, para considerar valor CERO y no NULL.
  *
  * @param Pv_IdDocumento  IN     VARCHAR2 Recibe nmero despacho
  * @param Pv_IdCompania   IN     VARCHAR2 Recibe cdigo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_ARTICULO_CONTROL(Pv_IdDocumento  IN VARCHAR2,
                               Pv_IdCompania   IN VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_REGULARIZA_NEGATIVOS
  * Procedure que regulariza los registros negativos convirtiendo en positivo cruzando estos valores.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 17/01/2022
  *
  * @param Pv_NumeroSerie IN VARCHAR2 Recibe numero serie
  * @param Pn_CustodioId  IN VARCHAR2 Recibe codigo de custodio asignado
  * @param Pv_UsrProcesa  IN VARCHAR2 Recibe usuario procesa
  * @param Pv_EmpresaId   IN VARCHAR2 Recibe codigo de empresa
  */
  PROCEDURE P_REGULARIZA_NEGATIVOS ( Pv_NumeroSerie IN VARCHAR2,
                                     Pn_CustodioId  IN NUMBER,
                                     Pv_UsrProcesa  IN VARCHAR2,
                                     Pv_EmpresaId   IN VARCHAR2);

  /**
  * Documentacion para P_INSERTA_INFO_ELEMENTO_TRAZAB
  * Procedure que invoca a NAF47_TNET.INKG_TRANSACCION.P_INSERTA_INFO_ELE_TRAZAB porque no puede ser invocado desde la forma
  *           usando variable registro por los campos TIMESTAMP
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/04/2022
  *
  * @param Pv_NumeroSerie  IN     VARCHAR2 Recibe numero de serie
  * @param Pv_Login        IN     VARCHAR2 Recibe login
  * @param Pn_OficinaId    IN     NUMBER   Recibe codigo de oficina
  * @param Pv_Responsable  IN     VARCHAR2 Recibe nombre responsable
  * @param Pv_Transaccion  IN     VARCHAR2 Recibe tipo transaccion
  * @param Pv_Ubicacion    IN     VARCHAR2 Recibe ubicacion
  * @param Pv_EstadoNaf    IN     VARCHAR2 Recibe estado del sistema NAF
  * @param Pv_EstadoTelcos IN     VARCHAR2 Recibe estado del sistema TELCOS
  * @param Pv_EstadoActivo IN     VARCHAR2 Recibe estado de Equipo
  * @param Pv_Observacion  IN     VARCHAR2 Recibe observacion del registro
  * @param Pv_EmpresaId    IN     VARCHAR2 Recibe codigo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje de error
  */
  PROCEDURE P_INSERTA_INFO_ELEMENTO_TRAZAB (Pv_NumeroSerie  IN VARCHAR2,
                                            Pv_Login        IN VARCHAR2,
                                            Pn_OficinaId    IN NUMBER,
                                            Pv_Responsable  IN VARCHAR2,
                                            Pv_Transaccion  IN VARCHAR2,
                                            Pv_Ubicacion    IN VARCHAR2,
                                            Pv_EstadoNaf    IN VARCHAR2,
                                            Pv_EstadoTelcos IN VARCHAR2,
                                            Pv_EstadoActivo IN VARCHAR2,
                                            Pv_Observacion  IN VARCHAR2,
                                            Pv_EmpresaId    IN VARCHAR2,
                                            Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_INFO_RELACION_ELEMEN
  * Procedure que invoca a DB_INFRAESTRUCTURA.INFRK_DML.INFRP_INSERT_RELACION_ELEMENTO porque no puede ser invocado desde la forma
  *           usando variable registro por los campos TIMESTAMP
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/04/2022
  *
  * @param Pn_ElmentoIdA   IN     NUMBER   Recibe codigo de elemento Nodo
  * @param Pn_ElmentoIdB   IN     NUMBER   Recibe codigo de elemento Equipo
  * @param Pv_TipoRelacion IN     VARCHAR2 Recibe tipo relacion
  * @param Pv_Observacion  IN     VARCHAR2 Recibe observacion del registro
  * @param Pv_Estado       IN     VARCHAR2 Recibe el estado del registro
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje de error
  */
  PROCEDURE P_INSERTA_INFO_RELACION_ELEMEN (Pn_ElmentoIdA   IN NUMBER,
                                            Pn_ElmentoIdB   IN NUMBER,
                                            Pv_TipoRelacion IN VARCHAR2,
                                            Pv_Observacion  IN VARCHAR2,
                                            Pv_Estado       IN VARCHAR2,
                                            Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_INFO_RELACION_ELEMEN
  * Procedure lee parametrizacion de condiguracipons del articulo para validar si todos los parametros cumplen con el
  *           Requerimiento minimo para realizar una instalacion.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/04/2022
  *
  * @param Pv_ArticuloId   IN     VARCHAR2 Recibe codigo de articulo
  * @param Pv_EmpresaId    IN     VARCHAR2 Recibe codigo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje de error
  */
  PROCEDURE P_VALIDA_PARAMETRO_INSTALACION (Pv_ArticuloId   IN VARCHAR2,
                                            Pv_EmpresaId    IN VARCHAR2,
                                            Pv_MensajeError IN OUT VARCHAR2);

end AFK_CONTROL_CUSTODIO;
/

CREATE OR REPLACE package body NAF47_TNET.AFK_CONTROL_CUSTODIO is
  
   -- constantes
   CONTROL_CUSTODIO       CONSTANT VARCHAR2(16) := 'CONTROL-CUSTODIO';
   TIPO_PROCESOS_NODOS    CONSTANT VARCHAR2(19) := 'TIPO-PROCESOS-NODOS';
   PARAMETROS_INSTALACION CONSTANT VARCHAR2(23) := 'PARAMETROS-INSTALACION';

  /**
  * Documentacion para P_GENERA_PERSONA_EMPRESA_ROL 
  * Procedure que registra persona empresa rol de contratista
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  *
  * @param Pv_IdContratista IN     VARCHAR2 Recibe nmero de contratista en NAF
  * @param Pv_NoCia         IN     VARCHAR2 Recibe cdigo de empresa
  * @param Pn_PersEmpRol    IN OUT NUMBER   Retorna cdigo de persona empresa rol de contratista
  * @param Pv_MensajeError  IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_GENERA_PERSONA_EMPRESA_ROL(Pv_IdContratista IN VARCHAR2,
                                         Pv_NoCia         IN VARCHAR2,
                                         Pn_PersEmpRol    IN OUT NUMBER,
                                         Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_CONSULTA_PERSONA IS
      SELECT IP.ID_PERSONA
      FROM DB_COMERCIAL.INFO_PERSONA IP
      WHERE EXISTS (SELECT NULL
             FROM ARINMCNT CNT
             WHERE CNT.CEDULA = IP.IDENTIFICACION_CLIENTE
             AND CNT.NO_CONTRATISTA = Pv_IdContratista
             AND CNT.NO_CIA = Pv_NoCia);

    --
    CURSOR C_ROL_CONTRATISTA IS
      SELECT IER.ID_EMPRESA_ROL
      FROM DB_GENERAL.INFO_EMPRESA_ROL IER,
           DB_GENERAL.ADMI_ROL         AR,
           DB_GENERAL.ADMI_TIPO_ROL    ATR
      WHERE ATR.DESCRIPCION_TIPO_ROL = 'Contratista'
      AND IER.ROL_ID = AR.ID_ROL
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
      AND IER.EMPRESA_COD = Pv_NoCia;

    --
    Ln_IdPersona    NUMBER;
    Ln_IdEmpresaRol NUMBER;
    --Lr_EmpresaRol   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE := NULL;
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    IF C_CONSULTA_PERSONA%ISOPEN THEN
      CLOSE C_CONSULTA_PERSONA;
    END IF;
    --
    OPEN C_CONSULTA_PERSONA;
    FETCH C_CONSULTA_PERSONA
      INTO Ln_IdPersona;
    IF C_CONSULTA_PERSONA%NOTFOUND THEN
      Ln_IdPersona := NULL;
    END IF;
    CLOSE C_CONSULTA_PERSONA;
    --
    IF Ln_IdPersona IS NULL THEN
      --
      Ln_IdPersona := DB_COMERCIAL.MIG_SECUENCIA.SEQ_INFO_PERSONA;
      -- se genera persona
      INSERT INTO DB_COMERCIAL.INFO_PERSONA
        (ID_PERSONA,
         TIPO_IDENTIFICACION,
         IDENTIFICACION_CLIENTE,
         TIPO_TRIBUTARIO,
         NOMBRES,
         APELLIDOS,
         RAZON_SOCIAL,
         DIRECCION,
         DIRECCION_TRIBUTARIA,
         ORIGEN_WEB,
         ESTADO,
         FE_CREACION,
         USR_CREACION,
         IP_CREACION)
        SELECT Ln_IdPersona,
               DECODE(CNT.TIPO_ID_TRIBUTARIO, 'R', 'RUC', 'P', 'PAS', 'C','CED') AS TIPO_IDENTIFICACION,
               CNT.CEDULA AS IDENTIFICACION_CLIENTE,
               DECODE(CNT.TIPO_ID_TRIBUTARIO, 'C', 'NAT', 'JUR') AS TIPO_TRIBUTARIO,
               DECODE(CNT.TIPO_ID_TRIBUTARIO, 'R', NULL,CNT.NOMBRE_PILA || ' ' || CNT.NOMBRE_SEGUNDO) AS NOMBRES,
               DECODE(CNT.TIPO_ID_TRIBUTARIO, 'R', NULL,CNT.APE_PAT || ' ' || CNT.APE_MAT) AS APELLIDOS,
               DECODE(CNT.TIPO_ID_TRIBUTARIO, 'R', CNT.NOMBRE, NULL) AS RAZON_SOCIAL,
               CNT.DIRECCION_ENC AS DIRECCION,
               CNT.DIRECCION_ENC AS DIRECCION_TRIBUTARIA,
               'N' AS ORIGEN_WEB,
               'Activo' AS ESTADO,
               SYSDATE,
               --NVL(GEK_CONSULTA.F_RECUPERA_LOGIN,USER), emunoz 1101203
               LOWER(USER),
               NVL(GEK_CONSULTA.F_RECUPERA_IP,'127.0.0.1')
        FROM ARINMCNT CNT
        WHERE CNT.NO_CONTRATISTA = Pv_IdContratista
        AND CNT.NO_CIA = Pv_NoCia;
    END IF;
    --
    --
    IF C_ROL_CONTRATISTA%ISOPEN THEN
      CLOSE C_ROL_CONTRATISTA;
    END IF;
    --
    OPEN C_ROL_CONTRATISTA;
    FETCH C_ROL_CONTRATISTA INTO Ln_IdEmpresaRol;
    IF C_ROL_CONTRATISTA%NOTFOUND THEN
      Ln_IdEmpresaRol := NULL;
    END IF;
    CLOSE C_ROL_CONTRATISTA;
    --
    IF Ln_IdEmpresaRol IS NULL THEN
      Pv_MensajeError := 'No se encontro rol contratista, favor revisar';
      RAISE Le_Error;
    END IF;
    --
    Pn_PersEmpRol := DB_COMERCIAL.MIG_SECUENCIA.SEQ_INFO_PERSONA_EMPRESA_ROL;
    --

    INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
      (id_persona_rol,
       persona_id,
       empresa_rol_id,
       estado,
       usr_creacion,
       fe_creacion,
       ip_creacion,
       es_prepago)
    VALUES
      (Pn_PersEmpRol,
       Ln_IdPersona,
       Ln_IdEmpresaRol,
       'Activo',
       ---GEK_CONSULTA.F_RECUPERA_LOGIN,
       LOWER(USER),   --emunoz 15012023 Cambio de Login
       sysdate,
       GEK_CONSULTA.F_RECUPERA_IP,
       'N');

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_GENERA_PERSONA_EMPRESA_ROL',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,
                                                            GEK_VAR.Gr_Sesion.HOST),
                                                user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,
                                                            GEK_VAR.Gr_Sesion.IP_ADRESS),
                                                '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_GENERA_PERSONA_EMPRESA_ROL',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_GENERA_PERSONA_EMPRESA_ROL;

  /**
  * Documentacion para P_INSERTA_CONTROL_CUSTODIO
  * Procedure que registra inserta registro en tabla control custodio
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 13/08/2018
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 30/11/2020 -  Se modifica para asignar usuario por defecto para aquellos procesos ejecutados en bakground
  *
  * @param Pr_ControlCustodio IN  ROWTYPE Recibe registro para insertar en control custodio
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_INSERTA_CONTROL_CUSTODIO(Pr_ControlCustodio IN ARAF_CONTROL_CUSTODIO%ROWTYPE,
                                       Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    Ln_IdControlCustodio ARAF_CONTROL_CUSTODIO.ID_CONTROL%type := 0;
    --

    --
  BEGIN
    --
    IF Pr_ControlCustodio.Id_Control IS NULL OR Pr_ControlCustodio.Id_Control = 0 THEN
      Ln_IdControlCustodio := NAF47_TNET.MIG_SECUENCIA.SEQ_ARAF_CONTROL_CUSTODIO;
    ELSE
      Ln_IdControlCustodio := Pr_ControlCustodio.Id_Control;
    END IF;
    --
    INSERT INTO NAF47_TNET.ARAF_CONTROL_CUSTODIO
      (ID_CONTROL,
       CUSTODIO_ID,
       EMPRESA_CUSTODIO_ID,
       TIPO_CUSTODIO,
       ARTICULO_ID,
       TIPO_ARTICULO,
       FECHA_INICIO,
       FECHA_FIN,
       FE_ASIGNACION,
       CANTIDAD,
       MOVIMIENTO,
       TIPO_TRANSACCION_ID,
       TRANSACCION_ID,
       EMPRESA_ID,
       TIPO_ACTIVIDAD,
       CASO_ID,
       TAREA_ID,
       LOGIN,
       OBSERVACION,
       ID_CONTROL_ORIGEN,
       CARACTERISTICA_ID,
       VALOR_BASE,
       NO_ARTICULO,
       ESTADO,
       USR_CREACION,
       FE_CREACION)
    VALUES
      (Ln_IdControlCustodio,
       Pr_ControlCustodio.custodio_id,
       Pr_ControlCustodio.empresa_custodio_id,
       Pr_ControlCustodio.tipo_custodio,
       Pr_ControlCustodio.articulo_id,
       Pr_ControlCustodio.Tipo_Articulo,
       Pr_ControlCustodio.fecha_inicio,
       Pr_ControlCustodio.fecha_fin,
       Pr_ControlCustodio.fe_asignacion,
       Pr_ControlCustodio.cantidad,
       Pr_ControlCustodio.Movimiento,
       NVL(Pr_ControlCustodio.tipo_transaccion_id,'SinTipo'),
       Pr_ControlCustodio.transaccion_id,
       Pr_ControlCustodio.empresa_id,
       NVL(Pr_ControlCustodio.tipo_actividad,'Regularizacion'),
       Pr_ControlCustodio.caso_id,
       NVL(Pr_ControlCustodio.tarea_id,0),
       Pr_ControlCustodio.login,
       Pr_ControlCustodio.observacion,
       Pr_ControlCustodio.id_control_origen,
       Pr_ControlCustodio.caracteristica_id,
       Pr_ControlCustodio.valor_base,
       Pr_ControlCustodio.No_Articulo,
       Pr_ControlCustodio.Estado,
       NVL(Pr_ControlCustodio.usr_creacion,USER),
       SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := Pr_ControlCustodio.Id_Control || ' - ' || Ln_IdControlCustodio || ' - ' || SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_INSERTA_CONTROL_CUSTODIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_CONTROL_CUSTODIO;


  PROCEDURE P_TRANSFERENCIA(Pt_Transferencia IN AFK_CONTROL_CUSTODIO.Gt_TransfCustodio,
                            Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_LINEA_KARDEX(Cv_ArticuloId      VARCHAR2,
                          Cv_CustodioId      NUMBER,
                          Cd_Fecha           DATE) IS
      SELECT ACC.ID_CONTROL,
             ACC.ARTICULO_ID,
             ACC.CANTIDAD,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID,
             ACC.EMPRESA_CUSTODIO_ID,
             ACC.TIPO_ACTIVIDAD,
             ACC.EMPRESA_ID,
             ACC.TIPO_ARTICULO,
             ACC.NO_ARTICULO,
             ACC.ESTADO
      FROM ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ARTICULO_ID = Cv_ArticuloId
      AND ACC.CUSTODIO_ID = Cv_CustodioId
      AND ACC.FECHA_INICIO <= Cd_Fecha
      AND ACC.FECHA_FIN >= Cd_Fecha;
    --
    CURSOR C_DATOS_PERSONA(Cn_IdPersonaEmpresaRol NUMBER) IS
      SELECT ATR.DESCRIPCION_TIPO_ROL,
             IER.EMPRESA_COD,
             P.LOGIN
      FROM DB_GENERAL.INFO_PERSONA             P,
           DB_GENERAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_GENERAL.INFO_EMPRESA_ROL         IER,
           DB_GENERAL.ADMI_ROL                 AR,
           DB_GENERAL.ADMI_TIPO_ROL            ATR
      WHERE IPER.ID_PERSONA_ROL = Cn_IdPersonaEmpresaRol
      AND P.ID_PERSONA = IPER.PERSONA_ID
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID = AR.ID_ROL
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL;
    --
    CURSOR C_DATOS_PEDIDO(Cv_NumeroSerie   VARCHAR2,
                          Cv_IdDespachoBod VARCHAR2,
                          Cv_NoCia         VARCHAR2) IS
      SELECT ME.EMPLE_SOLIC ID_CUSTODIO,
             ME.NO_CIA,
             ML.NO_ARTI,
             TO_NUMBER(ME.NO_PEDIDO) ID_PEDIDO
      FROM ARINME              ME,
           ARINML              ML,
           INV_DOCUMENTO_SERIE IDS
      WHERE IDS.SERIE = Cv_NumeroSerie
      AND IDS.ID_DOCUMENTO = Cv_IdDespachoBod
      AND IDS.COMPANIA = Cv_NoCia
      AND IDS.LINEA = ML.LINEA
      AND IDS.ID_DOCUMENTO = ML.NO_DOCU
      AND IDS.COMPANIA = ML.NO_CIA
      AND IDS.ID_DOCUMENTO = ME.NO_DOCU
      AND IDS.COMPANIA = ME.NO_CIA;
    --
    CURSOR C_PEDIDO_DETALLE(Cn_IdPedido    NUMBER,
                            Cv_ProductoId  VARCHAR2,
                            Cv_UsrAsignado VARCHAR2,
                            Cv_NoCia       VARCHAR2) IS
      SELECT IPD.ID_PEDIDO_DETALLE,
             IPD.CANTIDAD_DESPACHADA - (NVL(IPD.CANTIDAD_A_DEVOLVER, 0) +
             NVL(IPD.CANTIDAD_DEVUELTA, 0)) PENDIENTE_USAR
      FROM DB_COMPRAS.INFO_PEDIDO_DETALLE IPD
      WHERE IPD.PEDIDO_ID = Cn_IdPedido
      AND IPD.PRODUCTO_ID = Cv_ProductoId
      AND IPD.USR_ASIGNADO_ID = Cv_UsrAsignado
      AND EXISTS (SELECT NULL
                  FROM DB_COMPRAS.ADMI_EMPRESA AE
                  WHERE AE.ID_EMPRESA = IPD.PRODUCTO_EMPRESA_ID
                  AND AE.CODIGO = Cv_NoCia);
    --
    CURSOR C_RECUPERA_ORIGEN(Cn_ControlId NUMBER) IS
      SELECT ACC.ID_CONTROL,
             ACC.TIPO_ACTIVIDAD,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID,
             ACC.CUSTODIO_ID
      FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ID_CONTROL_ORIGEN IS NULL
      CONNECT BY NOCYCLE PRIOR ACC.ID_CONTROL_ORIGEN = ACC.ID_CONTROL
      START WITH ACC.ID_CONTROL = Cn_ControlId;
    --
    CURSOR C_CONTROL_ENTREGA_POR_ID ( Cn_IdControl NUMBER) IS
      SELECT ACC.CUSTODIO_ID,
             ACC.EMPRESA_CUSTODIO_ID,
             ACC.TIPO_CUSTODIO,
             ACC.ARTICULO_ID,
             ACC.TIPO_ARTICULO,
             ACC.CANTIDAD,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID,
             ACC.CASO_ID,
             ACC.TAREA_ID,
             ACC.TIPO_ACTIVIDAD,
             ACC.CARACTERISTICA_ID,
             ACC.EMPRESA_ID,
             ACC.ID_CONTROL,
             ACC.LOGIN,
             ACC.FE_ASIGNACION,
             ACC.FECHA_INICIO,
             ACC.FECHA_FIN,
             ACC.NO_ARTICULO,
             ACC.OBSERVACION,
             ACC.ESTADO
      FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ID_CONTROL = Cn_IdControl;
    --
    CURSOR C_CONTROL_ENTREGA ( Cv_ArticuloId      VARCHAR2,
                               Cn_CustodioId      NUMBER,
                               Cn_IdTransaccion   NUMBER,
                               Cv_TipoTransaccion VARCHAR2,
                               Cn_TareaId         NUMBER,
                               Cv_TipoActividad   VARCHAR2
                             ) IS
      SELECT ACC.CUSTODIO_ID,
             ACC.EMPRESA_CUSTODIO_ID,
             ACC.TIPO_CUSTODIO,
             ACC.ARTICULO_ID,
             ACC.TIPO_ARTICULO,
             ACC.CANTIDAD,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID,
             ACC.CASO_ID,
             ACC.TAREA_ID,
             ACC.TIPO_ACTIVIDAD,
             ACC.CARACTERISTICA_ID,
             ACC.EMPRESA_ID,
             ACC.ID_CONTROL,
             ACC.LOGIN,
             ACC.FE_ASIGNACION,
             ACC.FECHA_INICIO,
             ACC.FECHA_FIN,
             ACC.NO_ARTICULO,
             ACC.OBSERVACION,
             ACC.ESTADO
      FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ARTICULO_ID =  Cv_ArticuloId
      AND ACC.CUSTODIO_ID = Cn_CustodioId
      AND ACC.TRANSACCION_ID = Cn_IdTransaccion
      AND ACC.TIPO_TRANSACCION_ID = Cv_TipoTransaccion
      AND ACC.TAREA_ID = Cn_TareaId
      AND ACC.TIPO_ACTIVIDAD = Cv_TipoActividad;

    CURSOR C_VERIFICA_TIPO_ART(Cv_NoCia       VARCHAR2,
                                 Cv_tipoArt NAF47_TNET.ARINDA.TIPO_ARTICULO%TYPE) IS
      SELECT COUNT(D.VALOR2)TOTAL  
      FROM DB_GENERAL.ADMI_PARAMETRO_DET D,
             DB_GENERAL.ADMI_PARAMETRO_CAB C
      WHERE D.PARAMETRO_ID=C.ID_PARAMETRO
      AND C.NOMBRE_PARAMETRO='PARAMETROS-TIPO-ARTICULO'
      AND D.VALOR4='REPOSITORIO_ARTICULOS'
      AND D.EMPRESA_COD=Cv_NoCia
      AND D.VALOR2=Cv_tipoArt;
    --
    Lb_RegProcesado BOOLEAN := FALSE;
    Lr_DocOrigen    C_RECUPERA_ORIGEN%ROWTYPE := NULL;
    --
    CURSOR C_RECUPERA_PROCESO_NODO (Cv_TipoActividad VARCHAR2,
                                    Cv_NoCia         VARCHAR2) IS
      SELECT 'NODOS'
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.VALOR1 = Cv_TipoActividad
      AND APD.DESCRIPCION = TIPO_PROCESOS_NODOS
      AND APD.EMPRESA_COD = Cv_NoCia
      AND APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                  AND APC.NOMBRE_PARAMETRO = CONTROL_CUSTODIO);
    --
    CURSOR C_DATOS_NODO (Cn_ElementoId NUMBER) IS
      SELECT InitCap(ATE.NOMBRE_TIPO_ELEMENTO) AS NOMBRE_TIPO_ELEMENTO
      FROM DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE,
           DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
           DB_INFRAESTRUCTURA.INFO_ELEMENTO IE
      WHERE ID_ELEMENTO = Cn_ElementoId
      AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO
      AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO;
    --
    Lr_ControlCustodioEntrega C_CONTROL_ENTREGA_POR_ID%ROWTYPE := NULL;
    Lr_ControlCustodio        ARAF_CONTROL_CUSTODIO%ROWTYPE := NULL;
    Lr_PersonaEntrega         C_DATOS_PERSONA%ROWTYPE := NULL;
    Lr_PersonaRecibe          C_DATOS_PERSONA%ROWTYPE := NULL;
    Lr_DatosPedido            C_DATOS_PEDIDO%ROWTYPE := NULL;
    Lr_PedidoDetalle          C_PEDIDO_DETALLE%ROWTYPE := NULL;
    Lr_LineaKardex            C_LINEA_KARDEX%ROWTYPE := NULL;
    Ln_IdControlEntNuevo      ARAF_CONTROL_CUSTODIO.ID_CONTROL%TYPE := NULL;
    Ln_IdControlEntAux        ARAF_CONTROL_CUSTODIO.ID_CONTROL%TYPE := -1;
    Lv_TipoProceso            VARCHAR2(100);
    Ln_TipoArticulo           NUMBER :=0;
    --
    Le_Salir EXCEPTION;
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    -- se debe determinar si el tipo de proceso es para Nodos



    --
    FOR Li_Idx IN Pt_Transferencia.FIRST .. Pt_Transferencia.LAST LOOP
      -- inicialiacion variables
      Lr_ControlCustodio        := NULL;
      Lr_ControlCustodioEntrega := NULL;
      --
      --
      -- si no envia cantidades o registro ya fue procesado no se realiza ninguna accion y continue con siguiente registro
      IF (NVL((Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA), 0) = 0 AND NVL((Pt_Transferencia(Li_Idx).CANTIDAD_RECIBE), 0) = 0) THEN -- valida que se procesa una cantidad
        GOTO NEXT_RECORD;
      END IF;
      --
      --
      -- Se determina el tipo de proceso
      IF Lv_TipoProceso IS NULL THEN
        --
        IF C_RECUPERA_PROCESO_NODO%ISOPEN THEN
          CLOSE C_RECUPERA_PROCESO_NODO;
        END IF;
        OPEN C_RECUPERA_PROCESO_NODO ( Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD,
                                       Pt_Transferencia(Li_Idx).EMPRESA_ID);
        FETCH C_RECUPERA_PROCESO_NODO INTO Lv_TipoProceso;
        IF C_RECUPERA_PROCESO_NODO%NOTFOUND THEN
          Lv_TipoProceso := 'CLIENTES';
        END IF;
        CLOSE C_RECUPERA_PROCESO_NODO;
        --
      END IF;
      --
      --
      -- Se recupera datos persona que sera nuevo custodio
      IF C_DATOS_PERSONA%ISOPEN THEN
        CLOSE C_DATOS_PERSONA;
      END IF;
      --
      OPEN C_DATOS_PERSONA(Pt_Transferencia(Li_Idx).CUSTODIO_RECIBE_ID);
      FETCH C_DATOS_PERSONA INTO Lr_PersonaRecibe;
      IF C_DATOS_PERSONA%NOTFOUND THEN
        Lr_PersonaRecibe := NULL;
      END IF;
      CLOSE C_DATOS_PERSONA;
      --
      --
      IF NVL((Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA), 0) = 0 THEN
        ---------------------------------
        GOTO E04_PROCESA_NUEVO_CUSTODIO;--
        ---------------------------------
      END IF;
      --
      --
      -- Si id control es distinto se realiza busqueda por id control envido en el arreglo
      -- caso contrario se realiza busqueda por id control generado en interaccion anterior
      -- a la primer interaccion se asignan los valores directamente
      IF Ln_IdControlEntAux != NVL(Pt_Transferencia(Li_Idx).ID_CONTROL, 0) THEN
        Ln_IdControlEntNuevo := NVL(Pt_Transferencia(Li_Idx).ID_CONTROL, 0);
        Ln_IdControlEntAux   := NVL(Pt_Transferencia(Li_Idx).ID_CONTROL, 0);
      END IF;
      -- 
      -- Si NO se recibe numero de control realiza busquea sin control id
      IF Ln_IdControlEntNuevo = 0 THEN
        ---------------------------------
        GOTO E02_BUSQUEDA_SIN_ID_CONTROL;
        ---------------------------------
      END IF;
      --
      -- Se recupera datos en base a id_control
      IF C_CONTROL_ENTREGA_POR_ID%ISOPEN THEN
        CLOSE C_CONTROL_ENTREGA_POR_ID;
      END IF;
      OPEN C_CONTROL_ENTREGA_POR_ID(Ln_IdControlEntNuevo);
      FETCH C_CONTROL_ENTREGA_POR_ID INTO Lr_ControlCustodioEntrega;
      IF C_CONTROL_ENTREGA_POR_ID%NOTFOUND THEN
        Lr_ControlCustodioEntrega := NULL;
      END IF;
      CLOSE C_CONTROL_ENTREGA_POR_ID;
      ------------------------------------
      GOTO E01_VALIDA_CONTROL_PROCESADO;--
      ------------------------------------
      --
      ----------------------------------
      <<E02_BUSQUEDA_SIN_ID_CONTROL>> --
      ----------------------------------
      -- Se recupera datos de registro sin id control
      IF C_CONTROL_ENTREGA%ISOPEN THEN
        CLOSE C_CONTROL_ENTREGA;
      END IF;
      OPEN C_CONTROL_ENTREGA(Pt_Transferencia(Li_Idx).NUMERO_SERIE,
                             Pt_Transferencia(Li_Idx).CUSTODIO_ENTREGA_ID,
                             Pt_Transferencia(Li_Idx).TRANSACCION_ID,
                             Pt_Transferencia(Li_Idx).TIPO_TRANSACCION,
                             Pt_Transferencia(Li_Idx).TAREA_ID,
                             Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD--, Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA
                             );
      FETCH C_CONTROL_ENTREGA INTO Lr_ControlCustodioEntrega;
      Lb_RegProcesado := C_CONTROL_ENTREGA%FOUND;
      CLOSE C_CONTROL_ENTREGA;
      --
      -- si encuentra registro continua con validaciones
      IF Lb_RegProcesado THEN
        ------------------------------------
        GOTO E01_VALIDA_CONTROL_PROCESADO;--
        ------------------------------------
      END IF;
      --
      -- se asigna variable registro lo enviado por parametro
      Lr_ControlCustodio.Articulo_Id         := Pt_Transferencia(Li_Idx).NUMERO_SERIE;
      Lr_ControlCustodio.Tipo_Articulo       := Pt_Transferencia(Li_Idx).TIPO_ARTICULO;
      Lr_ControlCustodio.Empresa_Id          := Pt_Transferencia(Li_Idx).EMPRESA_ID;
      Lr_ControlCustodio.Caracteristica_Id   := Pt_Transferencia(Li_Idx).CARACTERISTICA_ID;
      Lr_ControlCustodio.Custodio_Id         := Pt_Transferencia(Li_Idx).CUSTODIO_ENTREGA_ID;
      Lr_ControlCustodio.Cantidad            := Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA;
      Lr_ControlCustodio.Movimiento          := Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA;
      Lr_ControlCustodio.Fe_Asignacion       := TRUNC(SYSDATE);
      Lr_ControlCustodio.Tipo_Transaccion_Id := Pt_Transferencia(Li_Idx).TIPO_TRANSACCION;
      Lr_ControlCustodio.Transaccion_Id      := Pt_Transferencia(Li_Idx).TRANSACCION_ID;
      Lr_ControlCustodio.Tarea_Id            := Pt_Transferencia(Li_Idx).TAREA_ID;
      Lr_ControlCustodio.Tipo_Actividad      := Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD;
      Lr_ControlCustodio.Fecha_Inicio        := TRUNC(SYSDATE);
      Lr_ControlCustodio.Fecha_Fin           := ADD_MONTHS(LAST_DAY(TRUNC(SYSDATE)),1200);
      Lr_ControlCustodio.Login               := Pt_Transferencia(Li_Idx).LOGIN;
      Lr_ControlCustodio.Usr_Creacion        := Pt_Transferencia(Li_Idx).LOGIN_EMPLEADO;
      Lr_ControlCustodio.Valor_Base          := 0;
      Lr_ControlCustodio.No_Articulo         := '00-00-00-000';
      Lr_ControlCustodio.Observacion         := Pt_Transferencia(Li_Idx).OBSERVACION;
      Lr_ControlCustodio.Estado              := AFK_CONTROL_CUSTODIO.Gc_EstadoAsignado;
      --
      -- no se encontro por ningun tipo de busqueda, se procede a ingresar registro --
      -- Se recupera datos persona que ser nuevo custodio
      IF C_DATOS_PERSONA%ISOPEN THEN
        CLOSE C_DATOS_PERSONA;
      END IF;
      --
      OPEN C_DATOS_PERSONA(Lr_ControlCustodio.Custodio_Id);
      FETCH C_DATOS_PERSONA INTO Lr_ControlCustodio.Tipo_Custodio,
                                 Lr_ControlCustodio.Empresa_Custodio_Id,
                                 Lr_ControlCustodio.Login;
      IF C_DATOS_PERSONA%NOTFOUND THEN
        Lr_PersonaEntrega := NULL;
      END IF;
      CLOSE C_DATOS_PERSONA;
      --
      --
      IF Pt_Transferencia(Li_Idx).TIPO_TRANSACCION = 'Caso' THEN
        Lr_ControlCustodio.Caso_Id := Pt_Transferencia(Li_Idx).TRANSACCION_ID;
      ELSE
        Lr_ControlCustodio.Caso_Id := 0;
      END IF;
      --
      IF Lr_ControlCustodio.Observacion != 'Migracion Saldo Inicial' 
        AND Lr_ControlCustodio.Custodio_Id IS NOT NULL 
        AND Lr_ControlCustodio.Custodio_Id !=0 THEN
        --
        Lr_ControlCustodio.Id_Control := NAF47_TNET.MIG_SECUENCIA.SEQ_ARAF_CONTROL_CUSTODIO;
        --
        P_INSERTA_CONTROL_CUSTODIO(Lr_ControlCustodio, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Salir;
        END IF;
        --
        -- Se recupera datos en base a id_control
        IF C_CONTROL_ENTREGA_POR_ID%ISOPEN THEN
          CLOSE C_CONTROL_ENTREGA_POR_ID;
        END IF;
        OPEN C_CONTROL_ENTREGA_POR_ID(Lr_ControlCustodio.Id_Control);
        FETCH C_CONTROL_ENTREGA_POR_ID INTO Lr_ControlCustodioEntrega;
        IF C_CONTROL_ENTREGA_POR_ID%NOTFOUND THEN
          Lr_ControlCustodioEntrega := NULL;
        END IF;
        CLOSE C_CONTROL_ENTREGA_POR_ID;
        --
      END IF;
      --
      ----------------------------------
      <<E01_VALIDA_CONTROL_PROCESADO>>--
      ----------------------------------
      -- Si no recupero control id entrega no se genera descargo, simplemente es una asignacion
      IF NVL(Lr_ControlCustodioEntrega.Id_Control,0) = 0 THEN
        ------------------------------
        GOTO E03_AFECTACION_PEDIDOS;--
        ------------------------------
      END IF;
      --
      -- si registro ya fue procesado no se realiza ninguna accion y continue con siguiente registro
      IF (NVL(Lr_ControlCustodioEntrega.Fecha_Fin,TRUNC(SYSDATE)) < TRUNC(SYSDATE)) THEN -- valida que registro recuperado aun se encuentre vigente
        -------------------
        GOTO NEXT_RECORD;--
        -------------------
      END IF;
      --
      --
      Lr_ControlCustodio.Id_Control   := Lr_ControlCustodioEntrega.Id_Control;
      Lr_ControlCustodio.Movimiento   := Lr_ControlCustodioEntrega.Cantidad;
      Lr_ControlCustodio.Fecha_Inicio := TRUNC(SYSDATE);
      --
      -- se actualiza fecha de vigencia del custodio anterior
      UPDATE ARAF_CONTROL_CUSTODIO ACC
      SET ACC.FECHA_FIN   = Lr_ControlCustodio.Fecha_Inicio - 1,
          ACC.ESTADO = AFK_CONTROL_CUSTODIO.Gc_EstadoProcesado,
          ACC.USR_ULT_MOD = Pt_Transferencia(Li_Idx).LOGIN_EMPLEADO,
          ACC.FE_ULT_MOD  = SYSDATE
      WHERE ACC.ID_CONTROL = Lr_ControlCustodio.Id_Control;
      --
      -- Se procede a registrar el nuevo saldo del custodio anterior
      -- asi quede en cero el saldo se regitra para efecto de reporte
      Lr_ControlCustodio.Articulo_Id         := Lr_ControlCustodioEntrega.Articulo_Id;
      Lr_ControlCustodio.Tipo_Articulo       := Lr_ControlCustodioEntrega.Tipo_Articulo;
      Lr_ControlCustodio.Caracteristica_Id   := Lr_ControlCustodioEntrega.Caracteristica_Id;
      Lr_ControlCustodio.Custodio_Id         := Lr_ControlCustodioEntrega.Custodio_Id;
      Lr_ControlCustodio.Tipo_Custodio       := Lr_ControlCustodioEntrega.Tipo_Custodio;
      Lr_ControlCustodio.Empresa_Custodio_Id := Lr_ControlCustodioEntrega.Empresa_Custodio_Id;
      Lr_ControlCustodio.Fecha_Fin           := ADD_MONTHS(LAST_DAY(Lr_ControlCustodio.Fecha_Inicio),1200);
      Lr_ControlCustodio.Cantidad            := Lr_ControlCustodio.Movimiento - Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA;
      Lr_ControlCustodio.Empresa_Id          := Lr_ControlCustodioEntrega.Empresa_Id;
      Lr_ControlCustodio.Caso_Id             := 0;
      Lr_ControlCustodio.Tarea_Id            := 0;
      Lr_ControlCustodio.Valor_Base          := 0;
      Lr_ControlCustodio.Login               := Lr_ControlCustodioEntrega.Login;
      Lr_ControlCustodio.Usr_Creacion        := Pt_Transferencia(Li_Idx).LOGIN_EMPLEADO;
      Lr_ControlCustodio.Id_Control_Origen   := Lr_ControlCustodioEntrega.Id_Control; -- asigna transaccion anterior ejecutada.
      Lr_ControlCustodio.No_Articulo         := Lr_ControlCustodioEntrega.No_Articulo;
      Lr_ControlCustodio.Estado              := Lr_ControlCustodioEntrega.Estado;
      --
      -- solo por baja de articulo y devolucion a bodega se asigna lo enviado por parametro
      IF (LOWER(Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD) = LOWER(NAF47_TNET.GEK_VAR.Gc_Regularizacion) AND 
        LOWER(Pt_Transferencia(Li_Idx).TIPO_TRANSACCION) = LOWER(NAF47_TNET.GEK_VAR.Gc_BajaArticulo)) OR
        LOWER(Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD) = LOWER(NAF47_TNET.GEK_VAR.Gc_DevolucionBodega) OR
        LOWER(Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD)  = LOWER(NAF47_TNET.GEK_VAR.Gc_IngresoBodega) THEN
        Lr_ControlCustodio.Tipo_Actividad      := Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD;
        Lr_ControlCustodio.Tipo_Transaccion_Id := Pt_Transferencia(Li_Idx).TIPO_TRANSACCION;
        Lr_ControlCustodio.Transaccion_Id      := Pt_Transferencia(Li_Idx).TRANSACCION_ID;
        Lr_ControlCustodio.Fe_Asignacion       := Lr_ControlCustodio.Fecha_Inicio;
        Lr_ControlCustodio.Observacion         := Pt_Transferencia(Li_Idx).OBSERVACION;
      ELSE
        Lr_ControlCustodio.Tipo_Actividad      := Lr_ControlCustodioEntrega.Tipo_Actividad;
        Lr_ControlCustodio.Tipo_Transaccion_Id := Lr_ControlCustodioEntrega.Tipo_Transaccion_Id;
        Lr_ControlCustodio.Transaccion_Id      := Lr_ControlCustodioEntrega.Transaccion_Id;
        Lr_ControlCustodio.Fe_Asignacion       := Lr_ControlCustodioEntrega.Fe_Asignacion;
        Lr_ControlCustodio.Observacion         := Pt_Transferencia(Li_Idx).OBSERVACION ||' -  Nuevo saldo';
      END IF;
      --
      Lr_ControlCustodio.Movimiento := Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA * -1;
      Lr_ControlCustodio.Id_Control := NAF47_TNET.MIG_SECUENCIA.SEQ_ARAF_CONTROL_CUSTODIO;
      -- variable usada para realizar busqueda por registro generado y no por el enviado por parametro porque ya fue dado de baja
      Ln_IdControlEntNuevo := Lr_ControlCustodio.Id_Control;
      --
      IF Lr_ControlCustodio.Empresa_Custodio_Id IS NULL THEN
          Lr_ControlCustodio.Empresa_Custodio_Id :=  Pt_Transferencia(Li_Idx).EMPRESA_ID;
      END IF;
      --
      P_INSERTA_CONTROL_CUSTODIO(Lr_ControlCustodio, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Salir;
      END IF;

      ----------------------------
      <<E03_AFECTACION_PEDIDOS>>--
      ----------------------------
      -- se debe recuperar origen para identiicar si ingreso por despacho bodega 
      IF C_RECUPERA_ORIGEN%ISOPEN THEN
        CLOSE C_RECUPERA_ORIGEN;
      END IF;
      OPEN C_RECUPERA_ORIGEN(Lr_ControlCustodioEntrega.Id_Control);
      FETCH C_RECUPERA_ORIGEN
        INTO Lr_DocOrigen;
      IF C_RECUPERA_ORIGEN%NOTFOUND THEN
        Lr_DocOrigen := NULL;
      END IF;
      CLOSE C_RECUPERA_ORIGEN;

      -- se procede a actualizar la data de pedidos si origen es un despacho
      IF Lr_DocOrigen.Tipo_Actividad = 'DespachoBodega' AND 
        Lr_DocOrigen.Custodio_Id in (Pt_Transferencia(Li_Idx).CUSTODIO_ENTREGA_ID, Pt_Transferencia(Li_Idx).CUSTODIO_RECIBE_ID) AND
         LOWER(Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD) != LOWER(NAF47_TNET.GEK_VAR.Gc_Regularizacion) THEN --emunoz 08022022 se aumenta validacion para que no actuliza pedidos por Regularizaciones Depto Control Activos 
        --
        IF C_DATOS_PEDIDO%ISOPEN THEN
          CLOSE C_DATOS_PEDIDO;
        END IF;
        OPEN C_DATOS_PEDIDO(Lr_ControlCustodioEntrega.Articulo_Id,
                            Lr_DocOrigen.Transaccion_Id,
                            Lr_ControlCustodioEntrega.Empresa_Id
                            );
        FETCH C_DATOS_PEDIDO INTO Lr_DatosPedido;
        IF C_DATOS_PEDIDO%NOTFOUND THEN
          Lr_DatosPedido := NULL;
        END IF;
        CLOSE C_DATOS_PEDIDO;
        --
        IF Lr_DatosPedido.Id_Pedido IS NULL THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                               'AFK_CONTROL_CUSTODIO.P_TRANSFIERE_CUSTODIO',
                                               'No se encontro numero de Pedido asociado al numero de serie ' ||Lr_ControlCustodioEntrega.Articulo_Id ||
                                               ', numero conrol ' || Lr_ControlCustodioEntrega.Id_Control,
                                               NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV, GEK_VAR.Gr_Sesion.HOST), user), SYSDATE,
                                               NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
          ---------------------------------
          GOTO E04_PROCESA_NUEVO_CUSTODIO;--
          ---------------------------------
        END IF;
        --
        -- Se encotro pedido se recupera pedido detalle dependiendo del articulo
        IF C_PEDIDO_DETALLE%ISOPEN THEN
          CLOSE C_PEDIDO_DETALLE;
        END IF;
        OPEN C_PEDIDO_DETALLE(Lr_DatosPedido.Id_Pedido,
                              Lr_DatosPedido.No_Arti,
                              Lr_DatosPedido.Id_Custodio,
                              Lr_DatosPedido.No_Cia);
        FETCH C_PEDIDO_DETALLE INTO Lr_PedidoDetalle;
        IF C_PEDIDO_DETALLE%NOTFOUND THEN
          Lr_PedidoDetalle := NULL;
        END IF;
        CLOSE C_PEDIDO_DETALLE;
        --
        -- Se valida cantidad entregada no supere la cantidad despachada al usuario due?o del pedido
        IF Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA > NVL(Lr_PedidoDetalle.Pendiente_Usar, 0) AND 
          Lr_DocOrigen.Custodio_Id = Pt_Transferencia(Li_Idx).CUSTODIO_ENTREGA_ID THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                               'AFK_CONTROL_CUSTODIO.P_TRANSFIERE_CUSTODIO',
                                               'Cantidad a descargar del producto ' ||Lr_ControlCustodio.Articulo_Id ||
                                               ' es superior a lo asignado en el pedido ' ||Lr_DatosPedido.Id_Pedido ||
                                               ' por ' ||TO_CHAR(Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA - NVL(Lr_PedidoDetalle.Pendiente_Usar,0)) ||
                                               ', Id Control: ' ||Lr_ControlCustodioEntrega.Id_Control,
                                               NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                               NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
          ---------------------------------
          GOTO E04_PROCESA_NUEVO_CUSTODIO;--
          ---------------------------------
        END IF;
        --
        -- si usuario due?o del pedido es el custodio entrega, se incrementa la cantidad de uso
        IF Lr_DocOrigen.Custodio_Id = Pt_Transferencia(Li_Idx).CUSTODIO_ENTREGA_ID THEN
          -- se descarga del pedido asociado al empleado.
          UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE
          SET CANTIDAD_A_DEVOLVER = NVL(CANTIDAD_A_DEVOLVER, 0) + Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA
          WHERE ID_PEDIDO_DETALLE = Lr_PedidoDetalle.Id_Pedido_Detalle;
          --
          -- si usuario due?o del pedido es el custodio recibe, se resta la cantidad de uso
        ELSIF Lr_DocOrigen.Custodio_Id = Pt_Transferencia(Li_Idx).CUSTODIO_RECIBE_ID THEN
          -- se devuelve del pedido asociado al empleado.
          UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE
          SET CANTIDAD_A_DEVOLVER = NVL(CANTIDAD_A_DEVOLVER, 0) + Pt_Transferencia(Li_Idx).CANTIDAD_ENTREGA
          WHERE ID_PEDIDO_DETALLE = Lr_PedidoDetalle.Id_Pedido_Detalle;
          --
        END IF;
        --
      END IF;
      --
      -------------------------------
      <<E04_PROCESA_NUEVO_CUSTODIO>>
      -------------------------------
      --
      IF NVL(Pt_Transferencia(Li_Idx).CANTIDAD_RECIBE,0) = 0 THEN
        -------------------
        GOTO NEXT_RECORD;--
        -------------------
      END IF;
      --
      -- 
      Lr_LineaKardex                  := NULL;
      Lr_ControlCustodio.Fecha_Inicio := TRUNC(SYSDATE);
      IF C_LINEA_KARDEX%ISOPEN THEN
        CLOSE C_LINEA_KARDEX;
      END IF;
      OPEN C_LINEA_KARDEX(Lr_ControlCustodioEntrega.Articulo_Id,
                          Pt_Transferencia(Li_Idx).CUSTODIO_RECIBE_ID,
                          Lr_ControlCustodio.Fecha_Inicio);
      FETCH C_LINEA_KARDEX INTO Lr_LineaKardex;
      IF C_LINEA_KARDEX%NOTFOUND THEN
        Lr_LineaKardex := NULL;
      END IF;
      CLOSE C_LINEA_KARDEX;
      --

      --
      --solo la fibra, cable y los materiales se acumulan en un mismo registro
      OPEN C_VERIFICA_TIPO_ART(Pt_Transferencia(Li_Idx).EMPRESA_ID,Lr_ControlCustodioEntrega.Tipo_Articulo);
      FETCH C_VERIFICA_TIPO_ART INTO Ln_TipoArticulo;
      CLOSE C_VERIFICA_TIPO_ART; 
      IF Lr_LineaKardex.Id_Control IS NULL OR Ln_TipoArticulo=0 THEN

        -----------------------------
        GOTO E05_DATOS_NUEVO_CUSTODIO;
        -----------------------------
      END IF;
      --
      -- se actualiza fecha de vigencia del custodio anterior
      UPDATE ARAF_CONTROL_CUSTODIO ACC
      SET ACC.FECHA_FIN   = Lr_ControlCustodio.Fecha_Inicio - 1,
          ACC.ESTADO      = AFK_CONTROL_CUSTODIO.Gc_EstadoProcesado,
          ACC.USR_ULT_MOD = Pt_Transferencia(Li_Idx).LOGIN_EMPLEADO,
          ACC.FE_ULT_MOD  = SYSDATE
      WHERE ACC.ID_CONTROL = Lr_LineaKardex.Id_Control;
      --
      Lr_ControlCustodio.Movimiento    := NVL(Lr_LineaKardex.Cantidad, 0) + Pt_Transferencia(Li_Idx).CANTIDAD_RECIBE;
      Lr_ControlCustodio.Articulo_Id   := Lr_LineaKardex.Articulo_Id;
      Lr_ControlCustodio.Id_Control    := Lr_LineaKardex.Id_Control;
      Lr_ControlCustodio.Empresa_Id    := Lr_LineaKardex.Empresa_Id;
      Lr_ControlCustodio.Tipo_Articulo := Lr_LineaKardex.Tipo_Articulo;
      Lr_ControlCustodio.No_Articulo   := Lr_LineaKardex.No_Articulo;
      Lr_ControlCustodio.Estado        := Lr_LineaKardex.Estado;
      ------------------------------
      GOTO E06_GENERA_NUEVO_CUSTODIO;
      ------------------------------
      --
      ------------------------------
      <<E05_DATOS_NUEVO_CUSTODIO>>--
      ------------------------------  
      IF Lr_ControlCustodioEntrega.Articulo_Id IS NOT NULL THEN
        Lr_ControlCustodio.Articulo_Id := Lr_ControlCustodioEntrega.Articulo_Id; --Pt_Transferencia(Li_Idx).NUMERO_SERIE;
      ELSE
        Lr_ControlCustodio.Articulo_Id := Pt_Transferencia(Li_Idx).NUMERO_SERIE;
      END IF;
      --
      IF Lr_ControlCustodioEntrega.Id_Control IS NOT NULL THEN
        Lr_ControlCustodio.Id_Control_Origen := Lr_ControlCustodioEntrega.Id_Control;
      END IF;
      --
      IF Lr_ControlCustodioEntrega.Empresa_Id IS NOT NULL THEN
        Lr_ControlCustodio.Empresa_Id := Lr_ControlCustodioEntrega.Empresa_Id;
      ELSE
        Lr_ControlCustodio.Empresa_Id := Pt_Transferencia(Li_Idx).EMPRESA_ID;
      END IF;
      --
      IF Lr_ControlCustodioEntrega.No_Articulo IS NOT NULL THEN
        Lr_ControlCustodio.No_Articulo := Lr_ControlCustodioEntrega.No_Articulo;
      ELSE
        Lr_ControlCustodio.No_Articulo := '00-00-00-000';
      END IF;
      --
      Lr_ControlCustodio.Tipo_Articulo := Lr_ControlCustodioEntrega.Tipo_Articulo;
      Lr_ControlCustodio.Movimiento    := Pt_Transferencia(Li_Idx).CANTIDAD_RECIBE;
      Lr_ControlCustodio.Estado        := AFK_CONTROL_CUSTODIO.Gc_EstadoAsignado;
      --
      -- Proceo NODOS: si origen es un empleado entonces el destino es un nodo, caso contrario es un empleado
      IF Lv_TipoProceso = 'NODOS' AND NVL(Lr_ControlCustodioEntrega.Tipo_Custodio,'Empleado') IN ('Empleado','Contratista') THEN
        --
        IF C_DATOS_NODO%ISOPEN THEN
          CLOSE C_DATOS_NODO;
        END IF;
        OPEN C_DATOS_NODO(Pt_Transferencia(Li_Idx).CUSTODIO_RECIBE_ID);
        FETCH C_DATOS_NODO INTO Lr_PersonaRecibe.Descripcion_Tipo_Rol;
        IF C_DATOS_NODO%NOTFOUND THEN
          NULL;
        END IF;
        CLOSE C_DATOS_NODO;
        --
        Lr_PersonaRecibe.Empresa_Cod := Pt_Transferencia(Li_Idx).EMPRESA_ID;
        --
      END IF;

      -------------------------------
      <<E06_GENERA_NUEVO_CUSTODIO>>--
      ------------------------------- 
      -- Se procede a registrar el asignacion a nuevo custodio
      Lr_ControlCustodio.Custodio_Id         := Pt_Transferencia(Li_Idx).CUSTODIO_RECIBE_ID;
      --
      Lr_ControlCustodio.Tipo_Custodio       := Lr_PersonaRecibe.Descripcion_Tipo_Rol;
      Lr_ControlCustodio.Empresa_Custodio_Id := Lr_PersonaRecibe.Empresa_Cod;
      --
      Lr_ControlCustodio.Cantidad            := Lr_ControlCustodio.Movimiento;
      Lr_ControlCustodio.Fecha_Fin           := ADD_MONTHS(LAST_DAY(Lr_ControlCustodio.Fecha_Inicio),1200);
      Lr_ControlCustodio.Fe_Asignacion       := Lr_ControlCustodio.Fecha_Inicio;
      Lr_ControlCustodio.Movimiento          := Pt_Transferencia(Li_Idx).CANTIDAD_RECIBE;
      Lr_ControlCustodio.Transaccion_Id      := Pt_Transferencia(Li_Idx).TRANSACCION_ID;
      Lr_ControlCustodio.Tarea_Id            := Pt_Transferencia(Li_Idx).TAREA_ID;
      Lr_ControlCustodio.Valor_Base          := 0;
      Lr_ControlCustodio.Observacion         := Pt_Transferencia(Li_Idx).Observacion;
      Lr_ControlCustodio.Login               := Pt_Transferencia(Li_Idx).LOGIN;
      Lr_ControlCustodio.Usr_Creacion        := Pt_Transferencia(Li_Idx).LOGIN_EMPLEADO;
      --
      IF Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD IN ('NUEVO','TRASLADO') THEN
        Lr_ControlCustodio.Tipo_Actividad := GEK_VAR.Gc_Instalacion;
        Lr_ControlCustodio.Tipo_Transaccion_Id := InitCap(Pt_Transferencia(Li_Idx).TIPO_TRANSACCION);
      ELSIF Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD = 'SOPORTE' THEN
        Lr_ControlCustodio.Tipo_Actividad := InitCap(Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD);
        Lr_ControlCustodio.Tipo_Transaccion_Id := InitCap(Pt_Transferencia(Li_Idx).TIPO_TRANSACCION);
      ELSE
        Lr_ControlCustodio.Tipo_Actividad := Pt_Transferencia(Li_Idx).TIPO_ACTIVIDAD;
        Lr_ControlCustodio.Tipo_Transaccion_Id := Pt_Transferencia(Li_Idx).TIPO_TRANSACCION;
      END IF;
      --
      IF Pt_Transferencia(Li_Idx).TIPO_TRANSACCION = 'Caso' THEN
        Lr_ControlCustodio.Caso_Id := Pt_Transferencia(Li_Idx).TRANSACCION_ID;
      ELSE
        Lr_ControlCustodio.Caso_Id := 0;
      END IF;
      --
     IF Lr_ControlCustodio.Empresa_Custodio_Id IS NULL THEN
          Lr_ControlCustodio.Empresa_Custodio_Id :=  Pt_Transferencia(Li_Idx).EMPRESA_ID;
      END IF;

      -- Los Ingresos a Bodegas enviaran nulo porque solo registraran descargo del tecnico.
      IF Lr_ControlCustodio.Custodio_Id IS NOT NULL THEN
        Lr_ControlCustodio.Id_Control := NAF47_TNET.MIG_SECUENCIA.SEQ_ARAF_CONTROL_CUSTODIO;

        IF Lr_ControlCustodio.Tipo_Articulo IS NULL  THEN
          Lr_ControlCustodio.Tipo_Articulo := Pt_Transferencia(Li_Idx).TIPO_ARTICULO;
        END IF;

        P_INSERTA_CONTROL_CUSTODIO(Lr_ControlCustodio, Pv_MensajeError);
        --
      END IF;
      --
      <<NEXT_RECORD>>
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Salir;
      END IF;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Salir THEN
      ROLLBACK;
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_TRANSFERENCIA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_TRANSFERENCIA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_TRANSFERENCIA;

  PROCEDURE P_ARTICULO_CONTROL(Pv_IdDocumento  IN VARCHAR2,
                               Pv_IdCompania   IN VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2) IS
    --
    ASIGNADO CONSTANT VARCHAR2(8) := 'Asignado';
    --
    -- costo query: 22
    CURSOR C_ARTICULO_CONTROL_CUSTODIO IS
    -- recupera articulos que en base a la caracterisica se controla las asignaciones a empleados, contratistas, empresa, etc
      SELECT ME.EMPLE_SOLIC ID_RESPONSABLE,
             ME.NO_CIA_RESPONSABLE,
             --
             (SELECT E.LOGIN_EMPLE
              FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS E
              WHERE E.NO_EMPLE = ME.EMPLE_SOLIC
              AND E.NO_CIA = ME.NO_CIA_RESPONSABLE) LOGIN_EMPLEADO,
             --
             (SELECT CNT.CEDULA
              FROM NAF47_TNET.ARINMCNT CNT
              WHERE CNT.NO_CONTRATISTA = ME.EMPLE_SOLIC
              AND CNT.NO_CIA = ME.NO_CIA_RESPONSABLE) IDENTIFICACION_CONTRATISTA,
             --
             IDS.SERIE AS ARTICULO_ID,
             ML.NO_ARTI ID_ARTICULO_NAF,
             TRUNC(SYSDATE) FECHA_INICIO,
             ADD_MONTHS(LAST_DAY(TRUNC(SYSDATE)), 1200) FECHA_FIN,
             CASE
               WHEN NVL(IDS.CANTIDAD_SEGMENTO,0) = 0 THEN
                 IDS.UNIDADES
               ELSE
                 IDS.CANTIDAD_SEGMENTO
             END AS CANTIDAD,ME.TIPO_DOC TIPO_TRANSACCION,
             ME.NO_DOCU TRANSACCION_ID,
             ME.NO_CIA EMPRESA_ID,
             CASE 
               WHEN TM.MOVIMI = 'E' AND ME.NO_DEVOLUCIONES IS NULL THEN
                 NAF47_TNET.GEK_VAR.Gc_IngresoBodega
               WHEN TM.MOVIMI = 'E' AND ME.NO_DEVOLUCIONES IS NOT NULL THEN
                 NAF47_TNET.GEK_VAR.Gc_DevolucionBodega
               ELSE
                 'DespachoBodega'
             END TIPO_ACTIVIDAD,
             ML.BODEGA,
             ME.FECHA,
             DA.NO_ARTI,
             DA.TIPO_ARTICULO,
             IDS.SERIE_ORIGINAL AS SERIE_ANTERIOR
      FROM NAF47_TNET.ARINVTM             TM,
           NAF47_TNET.ARINDA              DA,
           NAF47_TNET.ARINBO              BO,
           NAF47_TNET.ARINME              ME,
           NAF47_TNET.INV_DOCUMENTO_SERIE IDS,
           NAF47_TNET.ARINML              ML
      WHERE ML.NO_DOCU = Pv_IdDocumento
      AND ML.NO_CIA = Pv_IdCompania
      AND ME.EMPLE_SOLIC IS NOT NULL
      AND TM.INTERFACE IN ('VA','CF')
      AND TM.TRASLA != GEK_VAR.Gr_IndSimple.SI -- solo despachos e ingresos
      AND DA.IND_MOV_KARDEX = GEK_VAR.Gr_IndSimple.SI
      AND ML.TIPO_DOC = TM.TIPO_M
      AND ML.NO_CIA = TM.NO_CIA
      AND ML.BODEGA = BO.CODIGO
      AND ML.NO_CIA = BO.NO_CIA
      AND ML.NO_ARTI = DA.NO_ARTI
      AND ML.NO_CIA = DA.NO_CIA
      AND ML.NO_DOCU = ME.NO_DOCU
      AND ML.NO_CIA = ME.NO_CIA
      AND ML.LINEA = IDS.LINEA
      AND ML.NO_DOCU = IDS.ID_DOCUMENTO
      AND ML.NO_CIA = IDS.COMPANIA
      UNION ALL
      SELECT ME.EMPLE_SOLIC ID_RESPONSABLE,
             ME.NO_CIA_RESPONSABLE,
             --
             (SELECT E.LOGIN_EMPLE
              FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS E
              WHERE E.NO_EMPLE = ME.EMPLE_SOLIC
              AND E.NO_CIA = ME.NO_CIA_RESPONSABLE) LOGIN_EMPLEADO,
             --
             (SELECT CNT.CEDULA
              FROM NAF47_TNET.ARINMCNT CNT
              WHERE CNT.NO_CONTRATISTA = ME.EMPLE_SOLIC
              AND CNT.NO_CIA = ME.NO_CIA_RESPONSABLE) IDENTIFICACION_CONTRATISTA,
             --
             ML.NO_ARTI ARTICULO_ID,
             ML.NO_ARTI ID_ARTICULO_NAF,
             TRUNC(SYSDATE) FECHA_INICIO,
             ADD_MONTHS(LAST_DAY(TRUNC(SYSDATE)), 1200) FECHA_FIN,
             SUM(ML.UNIDADES * NVL(DA.PACK,1)) CANTIDAD,
             ME.TIPO_DOC TIPO_TRANSACCION,
             ME.NO_DOCU TRANSACCION_ID,
             ME.NO_CIA EMPRESA_ID,
             CASE 
               WHEN TM.MOVIMI = 'E' AND ME.NO_DEVOLUCIONES IS NULL THEN
                 NAF47_TNET.GEK_VAR.Gc_IngresoBodega
               WHEN TM.MOVIMI = 'E' AND ME.NO_DEVOLUCIONES IS NOT NULL THEN
                 NAF47_TNET.GEK_VAR.Gc_DevolucionBodega
               ELSE
                 'DespachoBodega'
             END TIPO_ACTIVIDAD,
             ML.BODEGA,
             ME.FECHA,
             DA.NO_ARTI,
             DA.TIPO_ARTICULO,
             NULL SERIE_ANTERIOR
      FROM NAF47_TNET.ARINVTM TM,
           NAF47_TNET.ARINDA  DA,
           NAF47_TNET.ARINBO  BO,
           NAF47_TNET.ARINME  ME,
           NAF47_TNET.ARINML  ML
      WHERE ML.NO_DOCU = Pv_IdDocumento
      AND ML.NO_CIA = Pv_IdCompania
      AND TM.INTERFACE IN ('VA','CF')
      AND TM.TRASLA != GEK_VAR.Gr_IndSimple.SI -- solo despachos e ingresos
      AND DA.IND_MOV_KARDEX = GEK_VAR.Gr_IndSimple.SI
      AND ME.EMPLE_SOLIC IS NOT NULL
      AND ML.TIPO_DOC = TM.TIPO_M
      AND ML.NO_CIA = TM.NO_CIA
      AND ML.BODEGA = BO.CODIGO
      AND ML.NO_CIA = BO.NO_CIA
      AND ML.NO_ARTI = DA.NO_ARTI
      AND ML.NO_CIA = DA.NO_CIA
      AND ML.NO_DOCU = ME.NO_DOCU
      AND ML.NO_CIA = ME.NO_CIA
      AND NOT EXISTS (SELECT NULL
             FROM NAF47_TNET.INV_DOCUMENTO_SERIE IDS
             WHERE IDS.LINEA = ML.LINEA
             AND IDS.ID_DOCUMENTO = ML.NO_DOCU
             AND IDS.COMPANIA = ML.NO_CIA)
      GROUP BY ME.EMPLE_SOLIC,
               ME.NO_CIA_RESPONSABLE,
               ML.NO_ARTI,
               ME.TIPO_DOC,
               ME.NO_DOCU,
               ME.NO_DEVOLUCIONES,
               ME.NO_CIA,
               TM.MOVIMI,
               ML.BODEGA,
               ME.FECHA,
               DA.NO_ARTI,
               DA.TIPO_ARTICULO;
    --
    CURSOR C_CARACTERISTICA(Cv_NoArticulo VARCHAR2,
                            Cv_NoCia      VARCHAR2) IS
      SELECT (SELECT AC.ID_CARACTERISTICA
              FROM ARIN_CARACTERISTICA AC
              WHERE AC.ES_CONTROL_CUSTODIO = GEK_VAR.Gr_IndSimple.SI
              CONNECT BY NOCYCLE AC.ID_CARACTERISTICA = PRIOR
                         AC.ID_CARACTERISTICA_PADRE
              START WITH AC.ID_CARACTERISTICA = ACA.ID_CARACTERISTICA) CARACTERISTICA_PADRE
      FROM ARIN_CARACTERISTICA_ARTICULO ACA
      WHERE ACA.NO_CIA = Cv_NoCia
      AND ACA.NO_ARTICULO = Cv_NoArticulo;

    --
    CURSOR C_EMPLEADO_ACTIVO (Cv_Login VARCHAR2,
                               Cv_NoCia VARCHAR2) IS
      SELECT IPER.ID_PERSONA_ROL
      FROM DB_GENERAL.INFO_PERSONA             P,
           DB_GENERAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_GENERAL.INFO_EMPRESA_ROL         IER,
           DB_GENERAL.ADMI_ROL                 AR,
           DB_GENERAL.ADMI_TIPO_ROL            ATR
      WHERE P.LOGIN = Cv_Login
      AND ATR.DESCRIPCION_TIPO_ROL = GEK_VAR.Gr_TipoPersona.EMPLEADO
      AND IER.EMPRESA_COD = Cv_NoCia
      AND IPER.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
      AND P.ID_PERSONA = IPER.PERSONA_ID
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID = AR.ID_ROL
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
      ORDER BY IPER.ID_PERSONA_ROL DESC;
    --
    --
    CURSOR C_EMPLEADO_INACTIVO (Cv_Login VARCHAR2,
                                Cv_NoCia VARCHAR2) IS
      SELECT IPER.ID_PERSONA_ROL
      FROM DB_GENERAL.INFO_PERSONA             P,
           DB_GENERAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_GENERAL.INFO_EMPRESA_ROL         IER,
           DB_GENERAL.ADMI_ROL                 AR,
           DB_GENERAL.ADMI_TIPO_ROL            ATR
      WHERE P.LOGIN = Cv_Login
      AND ATR.DESCRIPCION_TIPO_ROL = GEK_VAR.Gr_TipoPersona.EMPLEADO
      AND IER.EMPRESA_COD = Cv_NoCia
      AND IPER.ESTADO = GEK_VAR.Gr_Estado.INACTIVO
      AND P.ID_PERSONA = IPER.PERSONA_ID
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID = AR.ID_ROL
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
      AND EXISTS (SELECT NULL
                  FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
                  WHERE ACC.CUSTODIO_ID = IPER.ID_PERSONA_ROL
                  AND ACC.TIPO_CUSTODIO = ATR.DESCRIPCION_TIPO_ROL)
      ORDER BY IPER.ID_PERSONA_ROL DESC
      ;
    --
    CURSOR C_CONTRATISTA(Cv_Identificacion VARCHAR2,
                         Cv_NoCia          VARCHAR2) IS
      SELECT IPER.ID_PERSONA_ROL
      FROM DB_GENERAL.INFO_PERSONA             P,
           DB_GENERAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_GENERAL.INFO_EMPRESA_ROL         IER,
           DB_GENERAL.ADMI_ROL                 AR,
           DB_GENERAL.ADMI_TIPO_ROL            ATR
      WHERE P.IDENTIFICACION_CLIENTE = Cv_Identificacion
      AND ATR.DESCRIPCION_TIPO_ROL = GEK_VAR.Gr_TipoPersona.CONTRATISTA
      AND IER.EMPRESA_COD = Cv_NoCia
      AND IPER.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
      AND P.ID_PERSONA = IPER.PERSONA_ID
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID = AR.ID_ROL
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL;
    --
    CURSOR C_CONTROL(Cv_ArticuloId VARCHAR2,
                     Cv_CustodioId VARCHAR2) IS
      SELECT ACC.ID_CONTROL,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID
      FROM ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ID_CONTROL IN ( SELECT MAX(ID_CONTROL)
                                FROM ARAF_CONTROL_CUSTODIO
                                WHERE ARTICULO_ID = Cv_ArticuloId
                                AND CUSTODIO_ID = Cv_CustodioId
                                AND FECHA_INICIO <= TRUNC(SYSDATE)
                                AND FECHA_FIN >= TRUNC(SYSDATE)
                                AND CANTIDAD > 0
                                AND ESTADO = ASIGNADO);


    CURSOR C_VERIFICA_TIPO_ART(Cv_NoCia       VARCHAR2,
                                 Cv_tipoArt NAF47_TNET.ARINDA.TIPO_ARTICULO%TYPE) IS
      SELECT COUNT(D.VALOR2)TOTAL  
      FROM DB_GENERAL.ADMI_PARAMETRO_DET D,
           DB_GENERAL.ADMI_PARAMETRO_CAB C
      WHERE D.PARAMETRO_ID=C.ID_PARAMETRO
      AND C.NOMBRE_PARAMETRO='PARAMETROS-CONTROL-CABLE'
      AND D.EMPRESA_COD=Cv_NoCia
      AND D.VALOR2=Cv_tipoArt;
    --
    Lr_ControlCustodio ARAF_CONTROL_CUSTODIO%ROWTYPE := NULL;
    Lr_ControlExiste   C_CONTROL%ROWTYPE := NULL;
    Ln_TipoArticulo NUMBER := 0;
    --
    Le_Error EXCEPTION;
    Le_Salir EXCEPTION;
    --
  BEGIN

    FOR Lr_Reg IN C_ARTICULO_CONTROL_CUSTODIO LOOP
      --
      Lr_ControlExiste := null;
      --

      -- Se recuepara el codigo de persona
      IF Lr_Reg.Login_Empleado IS NOT NULL THEN
        --
        IF C_EMPLEADO_ACTIVO%ISOPEN THEN
          CLOSE C_EMPLEADO_ACTIVO;
        END IF;
        OPEN C_EMPLEADO_ACTIVO(Lr_Reg.Login_Empleado,
                               Lr_Reg.No_Cia_Responsable);
        FETCH C_EMPLEADO_ACTIVO INTO Lr_ControlCustodio.Custodio_Id;
        IF C_EMPLEADO_ACTIVO%NOTFOUND THEN
          Lr_ControlCustodio.Custodio_Id := NULL;
        END IF;
        CLOSE C_EMPLEADO_ACTIVO;
        --
        -- si no se encuentra nigun activo se verifica empleados inactivos
        IF Lr_ControlCustodio.Custodio_Id IS NULL THEN
          --
          IF C_EMPLEADO_INACTIVO%ISOPEN THEN
            CLOSE C_EMPLEADO_INACTIVO;
          END IF;
          OPEN C_EMPLEADO_INACTIVO(Lr_Reg.Login_Empleado,
                                   Lr_Reg.No_Cia_Responsable);
          FETCH C_EMPLEADO_INACTIVO INTO Lr_ControlCustodio.Custodio_Id;
          IF C_EMPLEADO_INACTIVO%NOTFOUND THEN
            Lr_ControlCustodio.Custodio_Id := NULL;
          END IF;
          CLOSE C_EMPLEADO_INACTIVO;
        END IF;
        --
        Lr_ControlCustodio.Tipo_Custodio := 'Empleado';
        --
      ELSIF Lr_Reg.Identificacion_Contratista IS NOT NULL THEN
        --
        IF C_CONTRATISTA%ISOPEN THEN
          CLOSE C_CONTRATISTA;
        END IF;
        OPEN C_CONTRATISTA(Lr_Reg.Identificacion_Contratista,
                           Lr_Reg.No_Cia_Responsable);
        FETCH C_CONTRATISTA INTO Lr_ControlCustodio.Custodio_Id;
        IF C_CONTRATISTA%NOTFOUND THEN
          Lr_ControlCustodio.Custodio_Id := NULL;
        END IF;
        CLOSE C_CONTRATISTA;
        --
        Lr_ControlCustodio.Tipo_Custodio := 'Contratista';
        --
        --
        IF Lr_ControlCustodio.Custodio_Id IS NULL THEN
          P_GENERA_PERSONA_EMPRESA_ROL(Lr_Reg.Id_Responsable,
                                       Lr_Reg.No_Cia_Responsable,
                                       Lr_ControlCustodio.Custodio_Id,
                                       Pv_MensajeError);
          --
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Salir;
          END IF;
          --
        END IF;
        --        
      END IF;
      --
      IF Lr_ControlCustodio.Custodio_Id IS NULL THEN
        Pv_MensajeError := 'No se encontro custodio definido en PERSONA EMPRESA ROL ' ||
                           Lr_Reg.Id_Responsable || ', ' ||
                           Lr_Reg.Login_Empleado || ', ' ||
                           Lr_Reg.Identificacion_Contratista || ', ' ||
                           Lr_ControlCustodio.Tipo_Custodio;
        RAISE Le_Error;
      END IF;
      --
      -- si se procesa ingreso a bodega se salta validaciones duplicidad registro control custodio
      IF Lr_Reg.Tipo_Actividad IN (NAF47_TNET.GEK_VAR.Gc_IngresoBodega,NAF47_TNET.GEK_VAR.Gc_DevolucionBodega) THEN
        GOTO RECUPERA_CARACTERISTICA;
      END IF;
      --
      --
      IF C_CONTROL%ISOPEN THEN
        CLOSE C_CONTROL;
      END IF;
      OPEN C_CONTROL(Lr_Reg.Articulo_Id, Lr_ControlCustodio.Custodio_Id);
      FETCH C_CONTROL INTO Lr_ControlExiste;
      IF C_CONTROL%NOTFOUND THEN
        Lr_ControlExiste.Id_Control := NULL;
      END IF;
      CLOSE C_CONTROL;
      --
      -- no encontro registro entonces continua con la reopilacion de datos
      IF Lr_ControlExiste.Id_Control IS NULL THEN
        GOTO RECUPERA_CARACTERISTICA;
      END IF;
      --
      OPEN C_VERIFICA_TIPO_ART(Pv_IdCompania,Lr_ControlCustodio.Tipo_Articulo);
      FETCH C_VERIFICA_TIPO_ART INTO Ln_TipoArticulo;
      CLOSE C_VERIFICA_TIPO_ART;
      --
      -- se valida repetidos solo para la fibra
      IF Ln_TipoArticulo > 0 THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'NAF',
                                              'AFK_CONTROL_CUSTODIO.P_ARTICULO_CONTROL',
                                              'Articulo ' ||Lr_Reg.Articulo_Id ||
                                              ' ya se encuentra asignado al custodio ' ||Lr_Reg.LOGIN_EMPLEADO,
                                              NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                              NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
        -- 
        GOTO SIGUIENTE_REGISTRO;
        --
      END IF;

      <<RECUPERA_CARACTERISTICA>>
      -- se recupera caractaristica padre para asignar
      Lr_ControlCustodio.Caracteristica_Id := 0;
      IF C_CARACTERISTICA%ISOPEN THEN
        CLOSE C_CARACTERISTICA;
      END IF;
      OPEN C_CARACTERISTICA(Lr_Reg.Id_Articulo_Naf, Lr_Reg.Empresa_Id);
      FETCH C_CARACTERISTICA INTO Lr_ControlCustodio.Caracteristica_Id;
      IF C_CARACTERISTICA%NOTFOUND THEN
        Lr_ControlCustodio.Caracteristica_Id := 0;
      END IF;
      CLOSE C_CARACTERISTICA;
      --
      Lr_ControlCustodio.Empresa_Custodio_Id  := Lr_Reg.No_Cia_Responsable;
      Lr_ControlCustodio.Articulo_Id          := Lr_Reg.Articulo_Id;
      Lr_ControlCustodio.Tipo_Articulo        := Lr_Reg.Tipo_Articulo;
      Lr_ControlCustodio.No_Articulo          := Lr_Reg.No_Arti;
      Lr_ControlCustodio.Fecha_Inicio         := Lr_Reg.Fecha_Inicio;
      Lr_ControlCustodio.Fecha_Fin            := Lr_Reg.Fecha_Fin;
      Lr_ControlCustodio.Fe_Asignacion        := Lr_Reg.Fecha;
      Lr_ControlCustodio.Cantidad             := Lr_Reg.Cantidad;
      Lr_ControlCustodio.Movimiento           := Lr_Reg.Cantidad;
      Lr_ControlCustodio.Tipo_Transaccion_Id  := Lr_Reg.Tipo_Transaccion;
      Lr_ControlCustodio.Transaccion_Id       := Lr_Reg.Transaccion_Id;
      Lr_ControlCustodio.Empresa_Id           := Lr_Reg.Empresa_Id;
      Lr_ControlCustodio.Tipo_Actividad       := Lr_Reg.Tipo_Actividad;
      Lr_ControlCustodio.Caso_Id              := 0;
      Lr_ControlCustodio.Tarea_Id             := 0;
      Lr_ControlCustodio.Login                := Lr_Reg.Login_Empleado;
      Lr_ControlCustodio.Valor_Base           := 0;
      Lr_ControlCustodio.Usr_Creacion         := LOWER(USER);---GEK_CONSULTA.F_RECUPERA_LOGIN; ---emunoz 15012023  Cambio de usuario Login
      Lr_ControlCustodio.Estado               := AFK_CONTROL_CUSTODIO.Gc_EstadoAsignado;
      Lr_ControlCustodio.Anterior_Articulo_Id := Lr_Reg.Serie_Anterior;
      --
      IF Lr_Reg.Tipo_Actividad IN (NAF47_TNET.GEK_VAR.Gc_IngresoBodega,NAF47_TNET.GEK_VAR.Gc_DevolucionBodega) THEN
        --
        IF C_CONTROL%ISOPEN THEN
          CLOSE C_CONTROL;
        END IF;
        OPEN C_CONTROL(Lr_ControlCustodio.Articulo_Id,
                       Lr_ControlCustodio.Custodio_Id);
        FETCH C_CONTROL INTO Lr_ControlExiste;
        CLOSE C_CONTROL;
        --
        -- si no se encuentra serie principal se busca por serie anterior para considerar la fibra segmentada por primera vez
        IF Lr_ControlExiste.Id_Control IS NULL THEN
          --
          IF C_CONTROL%ISOPEN THEN
            CLOSE C_CONTROL;
          END IF;
          OPEN C_CONTROL(Lr_Reg.Serie_Anterior,
                         Lr_ControlCustodio.Custodio_Id);
          FETCH C_CONTROL INTO Lr_ControlExiste;
          CLOSE C_CONTROL;
          --
        END IF;
        --
        Lr_ControlCustodio.Id_Control := Lr_ControlExiste.Id_Control;
        --
        P_TRANSFIERE_CUSTODIO(Lr_ControlCustodio.Articulo_Id,
                              Lr_ControlCustodio.Caracteristica_Id,
                              Lr_ControlCustodio.Empresa_Id,
                              Lr_ControlCustodio.Custodio_Id,
                              Lr_ControlCustodio.Cantidad, 
                              NULL,
                              NULL,
                              Lr_ControlCustodio.Tipo_Transaccion_Id,
                              Lr_ControlCustodio.Transaccion_Id,
                              Lr_ControlCustodio.Tipo_Actividad, 
                              0,
                              Lr_Reg.Bodega, 
                              Lr_ControlCustodio.Usr_Creacion,
                              Pv_MensajeError,
                              Lr_ControlCustodio.Id_Control,
                              'Producto ingresa a bodega', 
                              Lr_ControlCustodio.Tipo_Articulo,
			      FALSE);

      ELSE
        -- para generar nuevo registro
        Lr_ControlCustodio.Id_Control := 0 ;
        --
        P_INSERTA_CONTROL_CUSTODIO(Lr_ControlCustodio, Pv_MensajeError);
        --
      END IF;
      --
      <<SIGUIENTE_REGISTRO>>
    --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Salir;
      END IF;
      --

    END LOOP;

  EXCEPTION
    WHEN Le_Salir THEN
      ROLLBACK;
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_ARTICULO_CONTROL',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_ARTICULO_CONTROL',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_ARTICULO_CONTROL;

  PROCEDURE P_GENERA_INGRESO_BODEGA ( Pt_DatosIB      IN Gt_IngresoBodegaCC,
                                      Pv_IngBodegaId  IN OUT VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2) IS
    --
    -- recupera los datos del perioso para asignar al despacho --
    CURSOR C_DATOS_PERIODO ( Cv_Centro VARCHAR2,
                             Cv_NoCia  VARCHAR2) IS
      SELECT P.ANO_PROCE,
             P.DIA_PROCESO,
             P.MES_PROCE,
             C.CLASE_CAMBIO
        FROM NAF47_TNET.ARINCD P,
             NAF47_TNET.ARCGMC C
       WHERE P.NO_CIA = C.NO_CIA
         AND P.CENTRO = Cv_Centro
         AND P.NO_CIA = Cv_NoCia;
    --
    CURSOR C_VERFICA_DETALLE ( Cv_NoArti VARCHAR2,
                               Cv_NoDocu VARCHAR2,
                               Cv_NoCia  VARCHAR2 ) IS
      SELECT *
      FROM NAF47_TNET.ARINML ML
      WHERE ML.NO_ARTI = Cv_NoArti
      AND ML.NO_DOCU = Cv_NoDocu
      AND ML.NO_CIA = Cv_NoCia;
    --
    -- cursor que recupera secuencia de arinml --
    CURSOR C_SEC_ARINML (Cv_NoDocumento VARCHAR2,
                         Cv_NoCia       VARCHAR2) IS
      SELECT MAX(A.LINEA)
        FROM NAF47_TNET.ARINML A
       WHERE A.NO_DOCU = Cv_NoDocumento
         AND A.NO_CIA = Cv_NoCia;
    --
    CURSOR C_SERIE_GENERADA (Cv_Formato VARCHAR2) IS
      SELECT TO_NUMBER(NVL(MAX(SUBSTR(INS.SERIE, 14, 4)),'0')) CANTIDAD
      FROM INV_NUMERO_SERIE INS
      WHERE INS.FECHA_CREA >= TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 00:00:00','DD/MM/YYYY HH24:MI:SS')
      AND INS.FECHA_CREA <= TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY HH24:MI:SS')
      AND INS.SERIE LIKE Cv_Formato;
    --
    CURSOR C_VERIFICA_SERIE ( Cv_NumeroSerie VARCHAR2,
                              Cv_EmpresaId   VARCHAR2 ) IS
      SELECT INS.ESTADO,
             INS.NO_ARTICULO,
             INS.ID_BODEGA,
             INS.UNIDADES,
             INS.SERIE_ANTERIOR,
             INS.CANTIDAD_SEGMENTO
      FROM INV_NUMERO_SERIE INS
      WHERE INS.SERIE = Cv_NumeroSerie
      AND INS.COMPANIA = Cv_EmpresaId;
    --
    --
    CURSOR C_DATOS_CUSTODIO (Cn_CustodioId  NUMBER) IS
      SELECT P.LOGIN,
             IER.EMPRESA_COD,
             P.IDENTIFICACION_CLIENTE,
             ATR.DESCRIPCION_TIPO_ROL TIPO
      FROM DB_GENERAL.ADMI_TIPO_ROL ATR,
           DB_GENERAL.ADMI_ROL AR,
           DB_GENERAL.INFO_EMPRESA_ROL IER,
           DB_GENERAL.INFO_PERSONA P,
           DB_GENERAL.INFO_PERSONA_EMPRESA_ROL IPER
      WHERE IPER.ID_PERSONA_ROL = Cn_CustodioId
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
      AND IER.ROL_ID = AR.ID_ROL
      AND IPER.PERSONA_ID = P.ID_PERSONA
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL;
    --
    CURSOR C_DATOS_EMPLEADO_NAF (Cv_LoginEmple VARCHAR2,
                                 Cv_NoCia      VARCHAR2) IS
      SELECT NO_EMPLE
      FROM NAF47_TNET.LOGIN_EMPLEADO LE
      WHERE LE.LOGIN = Cv_LoginEmple
      AND LE.NO_CIA = Cv_NoCia;
    --
    CURSOR C_DATOS_CONTRATISTA (Cv_IdentificacionId VARCHAR2,
                                Cv_NoCia            VARCHAR2) IS
      SELECT NO_CONTRATISTA
      FROM NAF47_TNET.ARINMCNT
      WHERE CEDULA = Cv_IdentificacionId
      AND NO_CIA = Cv_NoCia;
    --
    Ld_FechaAux      DATE := NULL;
    --
    Lr_DatosPeriodo    C_DATOS_PERIODO%ROWTYPE := NULL;
    Lr_DatosCustodio   C_DATOS_CUSTODIO%ROWTYPE := NULL;
    Lr_Arinme          NAF47_TNET.ARINME%ROWTYPE := NULL;
    Lr_Arinml          NAF47_TNET.ARINML%ROWTYPE := NULL;
    Lr_PreIngSerie     NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE := NULL;
    Lr_NumeroSerie     NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE := NULL;
    Lr_SerieSegmentada C_VERIFICA_SERIE%ROWTYPE;
    Pt_Transferencia   Gt_TransfCustodio;
    Li_Idx             NUMBER := 0;
    Ln_Secuencia       NUMBER := 0;
    Lb_ExisteRegistro  BOOLEAN;
    Ln_CostoArticulo   NUMBER;
    Ln_Costo2Articulo  NUMBER;
    Lv_NumeroSerie     NAF47_TNET.ARAF_CONTROL_CUSTODIO.ARTICULO_ID%TYPE := NULL;
    Lv_EmpSolicita     NAF47_TNET.ARINME.EMPLE_SOLIC%TYPE := NULL;
    Lv_NoCiaSolicita   NAF47_TNET.ARINME.NO_CIA_RESPONSABLE%TYPE := NULL;
    --
    Le_Salir EXCEPTION;
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    FOR Li_Idx IN Pt_DatosIB.FIRST..Pt_DatosIB.LAST LOOP
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                       'RECIBE PARAMETRO GENERA INGRESO BODEGA',
                                       'Pt_DatosIB(Li_Idx).CUSTODIO_ID := ' || Pt_DatosIB(Li_Idx).CUSTODIO_ID || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).EMPRESA_ID := ' || Pt_DatosIB(Li_Idx).EMPRESA_ID || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).CENTRO_ID := ' || Pt_DatosIB(Li_Idx).CENTRO_ID || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).CUSTODIO_NAF_ID := ' || Pt_DatosIB(Li_Idx).CUSTODIO_NAF_ID || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).TIPO_INGRESO_ID := ' || Pt_DatosIB(Li_Idx).TIPO_INGRESO_ID || CHR(13) || 
                                       'Pt_DatosIB(Li_Idx).OBSERVACION := ' || Pt_DatosIB(Li_Idx).OBSERVACION || CHR(13) || 
                                       'Pt_DatosIB(Li_Idx).BODEGA_ID := ' || Pt_DatosIB(Li_Idx).BODEGA_ID || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).CANTIDAD := ' || Pt_DatosIB(Li_Idx).CANTIDAD || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).ARTICULO_ID := ' || Pt_DatosIB(Li_Idx).ARTICULO_ID || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).MANEJA_SERIE := ' || Pt_DatosIB(Li_Idx).MANEJA_SERIE || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).NUMERO_SERIE := ' || Pt_DatosIB(Li_Idx).NUMERO_SERIE || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).ID_CONTROL := ' || Pt_DatosIB(Li_Idx).ID_CONTROL || CHR(13) ||
                                       'Pt_DatosIB(Li_Idx).GENERA_SERIE := ' || Pt_DatosIB(Li_Idx).GENERA_SERIE || CHR(13) ||
                                       'Li_Idx := '|| Li_Idx, 
                                       NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                       NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      IF C_VERIFICA_SERIE%ISOPEN THEN
        CLOSE C_VERIFICA_SERIE;
      END IF;
      OPEN C_VERIFICA_SERIE (Pt_DatosIB(Li_Idx).NUMERO_SERIE,
                             Pt_DatosIB(Li_Idx).EMPRESA_ID);
      FETCH C_VERIFICA_SERIE INTO Lr_SerieSegmentada;
      IF C_VERIFICA_SERIE%NOTFOUND THEN
        Lr_SerieSegmentada := NULL;
      END IF;
      CLOSE C_VERIFICA_SERIE;
      --     
      -- si ya se recupero datos de custodio procesa directamente los numeros de series
      IF Lv_EmpSolicita IS NOT NULL THEN
        GOTO ET01_VALIDA_GENERACION_SERIE;
      END IF; -- 
      --
      -- se recuperan datos de custodio pra determinar codigo NAF
      IF C_DATOS_CUSTODIO%ISOPEN THEN
        CLOSE C_DATOS_CUSTODIO;
      END IF;
      OPEN C_DATOS_CUSTODIO (Pt_DatosIB(Li_Idx).CUSTODIO_ID);
      FETCH C_DATOS_CUSTODIO INTO Lr_DatosCustodio;
      IF C_DATOS_CUSTODIO%NOTFOUND THEN
        Lr_DatosCustodio := NULL;
      END IF;
      CLOSE C_DATOS_CUSTODIO; 
      --
      IF Lr_DatosCustodio.Tipo IS NULL THEN
        Pv_MensajeError := 'No se encontro Login definido en Telcos para custodio '||Pt_DatosIB(Li_Idx).CUSTODIO_ID ||', favor revisar';
        RAISE Le_Error;
      END IF;
      --
      IF Lr_DatosCustodio.Tipo = 'Empleado' THEN
        -- se busca datos de empleados NAF
        IF C_DATOS_EMPLEADO_NAF%ISOPEN THEN
          CLOSE C_DATOS_EMPLEADO_NAF;
        END IF;
        OPEN C_DATOS_EMPLEADO_NAF (Lr_DatosCustodio.Login,
                                   Lr_DatosCustodio.Empresa_Cod);
        FETCH C_DATOS_EMPLEADO_NAF INTO Lv_EmpSolicita;
        IF C_DATOS_EMPLEADO_NAF%NOTFOUND THEN
          Lv_EmpSolicita := NULL;
        END IF;
        CLOSE C_DATOS_EMPLEADO_NAF;
        --
      ELSIF Lr_DatosCustodio.Tipo = 'Contratista' THEN
        -- se busca datos de empleados NAF
        IF C_DATOS_CONTRATISTA%ISOPEN THEN
          CLOSE C_DATOS_CONTRATISTA;
        END IF;
        OPEN C_DATOS_CONTRATISTA (Lr_DatosCustodio.Identificacion_Cliente,
                                  Lr_DatosCustodio.Empresa_Cod);
        FETCH C_DATOS_CONTRATISTA INTO Lv_EmpSolicita;
        IF C_DATOS_CONTRATISTA%NOTFOUND THEN
          Lv_EmpSolicita := NULL;
        END IF;
        CLOSE C_DATOS_CONTRATISTA;
        --
      END IF;
      --
      IF Lv_EmpSolicita IS NULL THEN
        Pv_MensajeError := 'No se encontro Codigo de Empleado NAF para custodio '||Pt_DatosIB(Li_Idx).CUSTODIO_ID ||', favor revisar';
        RAISE Le_Error;
      END IF;
      --
      Lv_NoCiaSolicita := Lr_DatosCustodio.Empresa_Cod;
      --
      -------------------------------
      <<ET01_VALIDA_GENERACION_SERIE>>
      -------------------------------
      --
      -- Si longitud supera los 20 caracteres es obligaotrio generar Serie
      IF LENGTH(Pt_DatosIB(Li_Idx).NUMERO_SERIE) > 20 AND Pt_DatosIB(Li_Idx).GENERA_SERIE = 'N' THEN
        --
        Ln_Secuencia := 0;
        --
        IF C_SERIE_GENERADA%ISOPEN THEN
          CLOSE C_SERIE_GENERADA;
        END IF;
        OPEN C_SERIE_GENERADA('SEG-'||TO_CHAR(TRUNC(SYSDATE),'YYYYMMDD')||'%');
        FETCH C_SERIE_GENERADA INTO Ln_Secuencia;
        IF C_SERIE_GENERADA%NOTFOUND THEN
          Ln_Secuencia := 0;
        END IF;
        CLOSE C_SERIE_GENERADA;
        --
        Ln_Secuencia := nvl(Ln_Secuencia,0) + 1;
        --
        Lv_NumeroSerie := 'SEG-'||TO_CHAR(TRUNC(SYSDATE),'YYYYMMDD')||'-'||LPAD(Ln_Secuencia,4,'0');
        --
        -- se regula todo a un solo formato de numero de serie
        UPDATE ARAF_CONTROL_CUSTODIO ACC
        SET ACC.OBSERVACION = ACC.OBSERVACION||'. Serie Temporal: '||Pt_DatosIB(Li_Idx).NUMERO_SERIE,
            ACC.ARTICULO_ID = Lv_NumeroSerie
        WHERE ACC.CUSTODIO_ID = Pt_DatosIB(Li_Idx).CUSTODIO_ID
        AND ACC.ARTICULO_ID = Pt_DatosIB(Li_Idx).NUMERO_SERIE;
        --
      ELSE
        Lv_NumeroSerie := Pt_DatosIB(Li_Idx).NUMERO_SERIE;
      END IF;
      --

      -- si existe documento no debe genrar cabecera, solo actualziar detalle 
      IF Lr_Arinme.No_Docu IS NOT NULL THEN
        --------------------------
        GOTO E01_GENERA_DETALLE;--
        --------------------------
      END IF;
      --
      -- se procede a generar cabecera de documento
      Lr_Arinme.No_Cia := Pt_DatosIB(Li_Idx).EMPRESA_ID;
      Lr_Arinme.Centro := Pt_DatosIB(Li_Idx).CENTRO_ID;
      Lr_Arinme.Tipo_Doc := Pt_DatosIB(Li_Idx).TIPO_INGRESO_ID;
      Lr_Arinme.Ruta := '0000';
      Lr_Arinme.Estado := 'P';
      Lr_Arinme.Origen := 'AC';
      Lr_Arinme.Id_Bodega := Pt_DatosIB(Li_Idx).BODEGA_ID;
      Lr_Arinme.Observ1 := Pt_DatosIB(Li_Idx).OBSERVACION;
      --
      -- se recuperan parametros para asignar a documentos inventarios.
      IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
      OPEN C_DATOS_PERIODO (Pt_DatosIB(Li_Idx).CENTRO_ID,
                            Pt_DatosIB(Li_Idx).EMPRESA_ID);
      FETCH C_DATOS_PERIODO INTO Lr_DatosPeriodo;
      IF C_DATOS_PERIODO%NOTFOUND THEN
        Pv_MensajeError := 'La definicion del calendario del inventario es incorrecta.';
        RAISE Le_Error;
      END IF;
      CLOSE C_DATOS_PERIODO;
      --
      Lr_Arinme.Tipo_Cambio := Tipo_Cambio(Lr_DatosPeriodo.Clase_Cambio,
                                           Lr_DatosPeriodo.Dia_Proceso,
                                           Ld_FechaAux,
                                           'C');
      --
      Lr_Arinme.Periodo := Lr_DatosPeriodo.Ano_Proce;
      Lr_Arinme.Fecha := Lr_DatosPeriodo.Dia_Proceso;
      Lr_Arinme.Emple_Solic := Lv_EmpSolicita; --Pt_DatosIB(Li_Idx).CUSTODIO_NAF_ID;
      Lr_Arinme.No_Cia_Responsable := Lv_NoCiaSolicita; --Pt_DatosIB(Li_Idx).EMPRESA_ID;
      Lr_Arinme.No_Docu := Transa_Id.Inv(Lr_Arinme.No_Cia);
      Lr_Arinme.No_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia, Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'NUMERO');
      Lr_Arinme.Serie_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia,  Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'SERIE');

      -- Se inserta registro en cabecera de documentos de inventarios
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINME( Lr_Arinme,
                                                    Pv_MensajeError);

      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      -------------------------
      <<E01_GENERA_DETALLE>> --
      -------------------------
      Lb_ExisteRegistro := FALSE;
      IF C_VERFICA_DETALLE%ISOPEN THEN
        CLOSE C_VERFICA_DETALLE;
      END IF;
      OPEN C_VERFICA_DETALLE( Pt_DatosIB(Li_Idx).ARTICULO_ID,
                              Lr_Arinme.No_Docu,
                              Lr_Arinme.No_Cia);
      FETCH C_VERFICA_DETALLE INTO Lr_Arinml;
      Lb_ExisteRegistro := C_VERFICA_DETALLE%FOUND;
      CLOSE C_VERFICA_DETALLE;
      --
      IF Lb_ExisteRegistro THEN
        -----------------------------
        GOTO E02_ACTUALIZA_DETALLE;--
        -----------------------------
      END IF;
      --
      Lr_Arinml.No_Cia := Lr_Arinme.No_Cia;
      Lr_Arinml.Centro := Lr_Arinme.Centro;
      Lr_Arinml.Tipo_Doc := Lr_Arinme.Tipo_Doc;
      Lr_Arinml.Periodo := Lr_Arinme.Periodo;
      Lr_Arinml.Ruta := Lr_Arinme.Ruta;
      Lr_Arinml.No_Docu := Lr_Arinme.No_Docu;
      Lr_Arinml.Bodega := Lr_Arinme.Id_Bodega;
      Lr_Arinml.No_Arti := Pt_DatosIB(Li_Idx).ARTICULO_ID;
      --
      -- si es una serie segmentada la cantidad a ingresar a bodega depende de la serie original.
      IF Lr_SerieSegmentada.Serie_Anterior IS NOT NULL THEN
        Lr_Arinml.Unidades := Lr_SerieSegmentada.Unidades;
      ELSE
        Lr_Arinml.Unidades := Pt_DatosIB(Li_Idx).CANTIDAD;
      END IF;
      --
      Lr_Arinml.Tipo_Cambio := Lr_Arinme.Tipo_Cambio;
      Lr_Arinml.Ind_Oferta := 'N';

      --
      Ln_CostoArticulo  := naf47_tnet.articulo.costo(Lr_Arinml.No_Cia, Lr_Arinml.No_Arti, Lr_Arinml.Bodega);
      Ln_Costo2Articulo := naf47_tnet.articulo.costo2(Lr_Arinml.No_Cia, Lr_Arinml.No_Arti, Lr_Arinml.Bodega);
      --
      Lr_Arinml.Monto  := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.Unidades * Ln_CostoArticulo, 'P'), 0);
      Lr_Arinml.Monto2 := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.Unidades * Ln_Costo2Articulo, 'P'), 0);
      --
      IF Lr_Arinml.Tipo_Cambio > 0 then
        Lr_Arinml.monto_dol  := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.monto / Lr_Arinml.Tipo_Cambio, 'D'), 0);
        Lr_Arinml.monto2_dol := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.monto2 / Lr_Arinml.Tipo_Cambio, 'D'), 0);
      ELSE
        Lr_Arinml.Monto_Dol := 0;
        Lr_Arinml.Monto2_Dol := 0;
      END IF;
      --
      -- se recupera la secuencia correspondiente
      IF C_SEC_ARINML%ISOPEN THEN CLOSE C_SEC_ARINML; END IF;
      OPEN C_SEC_ARINML( Lr_Arinml.No_Docu,
                         Lr_Arinml.No_Cia);
      FETCH C_SEC_ARINML INTO Lr_Arinml.Linea;
      CLOSE C_SEC_ARINML;

      Lr_Arinml.Linea := nvl(Lr_Arinml.Linea,0) + 1;
      Lr_Arinml.Linea_Ext := Lr_Arinml.Linea;

      -- insertar detalle documento inventario --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINML( Lr_Arinml,
                                                    Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      ---------------------------
      GOTO E03_PRE_INGRESO_SERIE;
      ---------------------------
      --
      ----------------------------
      <<E02_ACTUALIZA_DETALLE>> --
      ----------------------------

      UPDATE NAF47_TNET.ARINML ML
      SET ML.UNIDADES = ML.UNIDADES + DECODE(Lr_SerieSegmentada.Serie_Anterior, NULL, Pt_DatosIB(Li_Idx).CANTIDAD, Lr_SerieSegmentada.Unidades)
      WHERE ML.NO_ARTI = Lr_Arinml.No_Arti
      AND ML.NO_DOCU = Lr_Arinml.No_Docu
      AND ML.NO_CIA = Lr_Arinml.No_Cia;
      --
      IF Pt_DatosIB(Li_Idx).MANEJA_SERIE = 'NO' THEN
        GOTO E04_SIGUIENTE_REGISTRO;
      END IF;
      ---------------------------
      <<E03_PRE_INGRESO_SERIE>>--
      ---------------------------
      --
      Lr_PreIngSerie := NULL;
      Lr_NumeroSerie := NULL;
      Lb_ExisteRegistro := FALSE;
      --
      -- si articulo genera serie y no tiene serie original entonces genera nuevo numero serie
      IF Pt_DatosIB(Li_Idx).GENERA_SERIE = 'S' AND Lr_SerieSegmentada.Serie_Anterior IS NULL THEN
        --
        Ln_Secuencia := 0;
        --
        IF C_SERIE_GENERADA%ISOPEN THEN
          CLOSE C_SERIE_GENERADA;
        END IF;
        OPEN C_SERIE_GENERADA('SEG-'||TO_CHAR(TRUNC(SYSDATE),'YYYYMMDD')||'%');
        FETCH C_SERIE_GENERADA INTO Ln_Secuencia;
        IF C_SERIE_GENERADA%NOTFOUND THEN
          Ln_Secuencia := 0;
        END IF;
        CLOSE C_SERIE_GENERADA;
        --
        Ln_Secuencia := nvl(Ln_Secuencia,0) + 1;
        --
        -- Se procede a dar de baja a la serie antigua
        Pt_Transferencia(1).ID_CONTROL := Pt_DatosIB(Li_Idx).ID_CONTROL;
        Pt_Transferencia(1).CANTIDAD_ENTREGA := Pt_DatosIB(Li_Idx).CANTIDAD;
        Pt_Transferencia(1).LOGIN_EMPLEADO := LOWER(USER); --GEK_CONSULTA.F_RECUPERA_LOGIN;    emunoz 15012023 Cambio de Login usuario
        --
        AFK_CONTROL_CUSTODIO.P_TRANSFERENCIA(Pt_Transferencia, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        Lr_PreIngSerie.Serie := 'SEG-'||TO_CHAR(TRUNC(SYSDATE),'YYYYMMDD')||'-'||LPAD(Ln_Secuencia,4,'0');
        --

      ELSE
        -- Se asigna numero de serie
        Lr_PreIngSerie.Serie := Lv_NumeroSerie;--Pt_DatosIB(Li_Idx).NUMERO_SERIE;
        --
      END IF;
      --
      --se verifica ni numero serie se encuentra ingresado
      --
      Lb_ExisteRegistro := FALSE;
      --
      FOR Lr_MaestroSerie IN C_VERIFICA_SERIE ( Lr_PreIngSerie.Serie, 
                                                Lr_Arinml.No_Cia) LOOP
        IF Lr_MaestroSerie.Estado = 'EB' THEN
          Pv_MensajeError := 'Numero de serie se encuentra registrado en bodega: '||Lr_MaestroSerie.Id_Bodega||' asociado al articulo '||Lr_MaestroSerie.No_Articulo;
          RAISE Le_Error;
        ELSIF NOT Lb_ExisteRegistro THEN
         Lb_ExisteRegistro := (NVL(Lr_MaestroSerie.No_Articulo,'@') = Lr_Arinml.No_Arti);
        END IF;
        --

      END LOOP;
      --
      -- si no existe ingresado con ningun otro articulo, se procede a registrar
      IF NOT Lb_ExisteRegistro THEN
        --
        Lr_NumeroSerie.Compania := Lr_Arinml.No_Cia;
        Lr_NumeroSerie.Serie := Lr_PreIngSerie.Serie;
        Lr_NumeroSerie.No_Articulo := Lr_Arinml.No_Arti;
        Lr_NumeroSerie.Unidades := Lr_Arinml.Unidades;
        --
        IF Lr_SerieSegmentada.Serie_Anterior IS NOT NULL THEN
          Lr_NumeroSerie.Serie_Anterior := Lr_SerieSegmentada.Serie_Anterior;
          Lr_NumeroSerie.Cantidad_Segmento := Pt_DatosIB(Li_Idx).CANTIDAD;
        END IF;
        --
        Lr_NumeroSerie.Estado := 'FB';
        Lr_NumeroSerie.Usuario_Crea := USER;
        Lr_NumeroSerie.Fecha_Crea := SYSDATE;
        --
        INKG_TRANSACCION.P_INSERTA_MAESTRO_SERIE(Lr_NumeroSerie,
                                                 Pv_MensajeError);
        --

        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END IF;
      --
      Lr_PreIngSerie.Compania := Lr_Arinml.No_Cia;
      Lr_PreIngSerie.No_Documento := Lr_Arinml.No_Docu;
      Lr_PreIngSerie.No_Articulo := Lr_Arinml.No_Arti;
      Lr_PreIngSerie.Origen := 'CA'; --'DE'
      Lr_PreIngSerie.Linea := Lr_Arinml.Linea;
      Lr_PreIngSerie.Mac := NULL;
      Lr_PreIngSerie.Unidades := Lr_NumeroSerie.Unidades;
      --
      IF Lr_SerieSegmentada.Serie_Anterior IS NOT NULL THEN
        Lr_PreIngSerie.Serie_Original := Lr_SerieSegmentada.Serie_Anterior;
        Lr_PreIngSerie.Cantidad_Segmento := Pt_DatosIB(Li_Idx).CANTIDAD;
      END IF;
      --
      Lr_PreIngSerie.Usuario_Crea := USER;
      Lr_PreIngSerie.Fecha_Crea := SYSDATE;
      --

      INKG_TRANSACCION.P_INSERTA_NUMERO_SERIE ( Lr_PreIngSerie,
                                                Pv_MensajeError);

      ----------------------------
      <<E04_SIGUIENTE_REGISTRO>>--
      ----------------------------
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;
    --
    --
    Pv_IngBodegaId := Lr_Arinme.NO_DOCU;
    --
    IF Pv_IngBodegaId IS NULL THEN
      RAISE Le_Error;
    END IF;
    --
    -- se ejecuta actualizacion
    -- proceso que actualiza el movimiento de inventarios.
    NAF47_TNET.INACTUALIZA( Lr_Arinme.NO_CIA ,
                            Lr_Arinme.TIPO_DOC,
                            Lr_Arinme.NO_DOCU,
                            Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := Lr_Arinme.NO_DOCU||' '||Pv_MensajeError;
      RAISE Le_Error;
    END IF;
    --
  EXCEPTION
    WHEN Le_Salir THEN
      ROLLBACK;
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_GENERA_INGRESO_BODEGA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_GENERA_INGRESO_BODEGA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_GENERA_INGRESO_BODEGA;

  PROCEDURE P_TRANSFIERE_CUSTODIO(Pv_NumeroSerie      IN ARAF_CONTROL_CUSTODIO.ARTICULO_ID%TYPE, -- numero de serie para equipos/fibra y Cod Articulo NAF para materiales
                                  Pn_IdCaracteristica IN ARAF_CONTROL_CUSTODIO.CARACTERISTICA_ID%TYPE, -- Caracteristica
                                  Pv_IdEmpresa        IN ARAF_CONTROL_CUSTODIO.EMPRESA_ID%TYPE, -- empresa asociado al id persona empresa rol
                                  Pn_IdCustodioEnt    IN ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Cliente/Empleado/Contratista que traspasa articulo
                                  Pn_CantidadEnt      IN ARAF_CONTROL_CUSTODIO.CANTIDAD%TYPE, -- cantidad a Entregar
                                  Pn_IdCustodioRec    IN ARAF_CONTROL_CUSTODIO.CUSTODIO_ID%TYPE, -- id persona empresa rol Cliente/Empleado/Contratista que recibe articulo
                                  Pn_CantidadRec      IN ARAF_CONTROL_CUSTODIO.CANTIDAD%TYPE, -- cantidad a recibir procesar
                                  Pv_TipoTransaccion  IN ARAF_CONTROL_CUSTODIO.TIPO_TRANSACCION_ID%TYPE, -- tipo transaccion: Tarea, Caso
                                  Pv_IdTransaccion    IN ARAF_CONTROL_CUSTODIO.TRANSACCION_ID%TYPE, -- # transaccion: numero tarea, numero caso
                                  Pv_TipoActividad    IN ARAF_CONTROL_CUSTODIO.TIPO_ACTIVIDAD%TYPE, -- Tipo Actividad: Instalacion, Soporte
                                  Pn_IdTarea          IN ARAF_CONTROL_CUSTODIO.TAREA_ID%TYPE, -- numero tarea asociada a la instalacion
                                  Pv_Login            IN ARAF_CONTROL_CUSTODIO.LOGIN%TYPE, -- login servicio
                                  Pv_LoginProcesa     IN ARAF_CONTROL_CUSTODIO.LOGIN%TYPE, -- login usuario procesa
                                  Pv_MensajeError     IN OUT VARCHAR2,
                                  Pn_IdControl        IN ARAF_CONTROL_CUSTODIO.ID_CONTROL%TYPE DEFAULT 0,
                                  Pv_Observacion      IN ARAF_CONTROL_CUSTODIO.OBSERVACION%TYPE DEFAULT NULL,
                                  Pv_TipoArticulo     IN ARAF_CONTROL_CUSTODIO.TIPO_ARTICULO%TYPE, -- Tipo de Articulo Fibra, Equpo, Materiales, etc
                                  Pb_Commit	      IN BOOLEAN DEFAULT TRUE) IS --Variable para no considerar commit cuando el procedimiento es llamado desde el sistema NAF
    --
    Lc_Retiro CONSTANT VARCHAR2(6) := 'Retiro';
    --
    CURSOR C_ARTICULOS_TRANSFERIR IS
      SELECT ACC.ID_CONTROL,
             ACC.CANTIDAD,
             COUNT(ACC.ID_CONTROL) OVER (PARTITION BY ARTICULO_ID) REGISTROS,
             ACC.FE_ASIGNACION
      FROM ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.CUSTODIO_ID = Pn_IdCustodioEnt
      AND ACC.ARTICULO_ID = Pv_NumeroSerie
      AND ACC.ESTADO = GEK_VAR.Gr_Estado.ASIGNADO
      AND ACC.CANTIDAD > 0
      AND ACC.TIPO_TRANSACCION_ID != Lc_Retiro
      ORDER BY 4;
    --
    CURSOR C_VERIFICA_PROCESADO ( Cn_Cantidad          NUMBER,
                                  Cv_NumeroSerie       VARCHAR2,
                                  Cn_CustodioId        NUMBER,
                                  Cn_TareaId           NUMBER,
                                  Cv_TipoTransaccionId VARCHAR2,
                                  Cv_Transaccion       VARCHAR2,
                                  Cv_TipoActividad     VARCHAR2) IS
      SELECT COUNT(ID_CONTROL)
      FROM ARAF_CONTROL_CUSTODIO ACCP
      WHERE ACCP.MOVIMIENTO = Cn_Cantidad
      AND ACCP.ARTICULO_ID = Cv_NumeroSerie
      AND ACCP.TAREA_ID = Cn_TareaId
      AND ACCP.CUSTODIO_ID = Cn_CustodioId
      AND ACCP.TRANSACCION_ID = Cv_Transaccion
      AND ACCP.TIPO_TRANSACCION_ID = Cv_TipoTransaccionId
      AND ACCP.TIPO_ACTIVIDAD = Cv_TipoActividad;
    --
    CURSOR C_RETIRO_EQUIPOS IS
      SELECT ACC.ID_CONTROL,
             ACC.CANTIDAD,
             ACC.CUSTODIO_ID,
             ACC.LOGIN
      FROM ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ARTICULO_ID = Pv_NumeroSerie
      AND ACC.ESTADO = GEK_VAR.Gr_Estado.ASIGNADO
      AND ACC.CANTIDAD > 0
      AND ACC.TIPO_TRANSACCION_ID != Lc_Retiro
      AND ACC.TIPO_CUSTODIO != 'Cliente'
      ORDER BY ACC.ID_CONTROL;
    --
    CURSOR C_VALIDA_BODEGA IS
      SELECT BO.CODIGO
      FROM NAF47_TNET.ARINBO BO
      WHERE BO.CODIGO = Pv_Login
      AND BO.NO_CIA = Pv_IdEmpresa;
    --
    Lr_ControlCustodio Gt_TransfCustodio;
    Lr_ArticuloTransfe C_ARTICULOS_TRANSFERIR%ROWTYPE;
    Lr_RetiroEquipos   C_RETIRO_EQUIPOS%ROWTYPE;
    Lr_DatosBodega     C_VALIDA_BODEGA%ROWTYPE;
    Ln_CantidadEntrega NUMBER := 0;
    Ln_CantidadRecibe  NUMBER := 0;
    Ln_NumReg          NUMBER(3) := 0;
    Ln_Idx             NUMBER(3) := 0;
    --
    Lv_TipoActividadAux  NAF47_TNET.ARAF_CONTROL_CUSTODIO.TIPO_ACTIVIDAD%TYPE := NULL;
    Lv_TipoTransacionAux NAF47_TNET.ARAF_CONTROL_CUSTODIO.TIPO_TRANSACCION_ID%TYPE := NULL;
    Ln_Procesado         NUMBER := 0;
    Ln_Negativos         NUMBER(6) := 0;
    --
    Le_Salir EXCEPTION;
    Le_Error EXCEPTION;
    --

  BEGIN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'RECIBE PARAMETRO CONTROL CUSTODIO',
                                         'Pv_NumeroSerie: ' || Pv_NumeroSerie || CHR(13) ||
                                         'Pn_IdCaracteristica: ' || Pn_IdCaracteristica || CHR(13) ||
                                         'Pv_IdEmpresa: ' || Pv_IdEmpresa || CHR(13) || 
                                         'Pn_IdCustodioEnt: ' || Pn_IdCustodioEnt || CHR(13) ||
                                         'Pn_CantidadEnt: ' || Pn_CantidadEnt || CHR(13) || 
                                         'Pn_IdCustodioRec: ' || Pn_IdCustodioRec || CHR(13) ||
                                         'Pn_CantidadRec: ' || Pn_CantidadRec || CHR(13) || 
                                         'Pv_TipoTransaccion: ' || Pv_TipoTransaccion || CHR(13) ||
                                         'Pv_IdTransaccion: ' || Pv_IdTransaccion || CHR(13) ||
                                         'Pv_TipoActividad: ' || Pv_TipoActividad || CHR(13) ||
                                         'Pn_IdTarea: ' || Pn_IdTarea || CHR(13) ||
                                         'Pv_Login: ' || Pv_Login || CHR(13) ||
                                         'Pv_LoginProcesa: ' || Pv_LoginProcesa || CHR(13) ||
                                         'Pn_IdControl: ' || Pn_IdControl || CHR(13) ||
                                         'Pv_Observacion: ' || Pv_Observacion || CHR(13) ||
                                         'Pv_TipoArticulo: ' || Pv_TipoArticulo, 
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    --
    Pv_MensajeError := NULL;
    --
    -- se valida la tarea ejecutada no se repita (concurrencia movil)
    IF Pv_TipoActividad IN ('NUEVO','TRASLADO') THEN
      --
      Lv_TipoActividadAux := NAF47_TNET.GEK_VAR.Gc_Instalacion;
      Lv_TipoTransacionAux := InitCap(Pv_TipoTransaccion);
      --
    ELSIF Pv_TipoActividad = 'SOPORTE' THEN
      --
      Lv_TipoActividadAux := InitCap(Pv_TipoActividad);
      Lv_TipoTransacionAux := InitCap(Pv_TipoTransaccion);
    ELSE
      Lv_TipoActividadAux := Pv_TipoActividad;
      Lv_TipoTransacionAux := Pv_TipoTransaccion;
    END IF;
    --
    IF Pv_TipoActividad = 'IngresoBodega' THEN
      -- Se valida que no es por retiro o devolucion
      -- Retiro / Devolucion el login viene asignado con el login del empleado 
      -- Ingreso bodega normal en el login viene asignado el coigo de la bodega.
      IF C_VALIDA_BODEGA%ISOPEN THEN
        CLOSE C_VALIDA_BODEGA;
      END IF;
      OPEN C_VALIDA_BODEGA;
      FETCH C_VALIDA_BODEGA INTO Lr_DatosBodega;
      IF C_VALIDA_BODEGA%NOTFOUND THEN
        Lr_DatosBodega := NULL;
      END IF;
      CLOSE C_VALIDA_BODEGA;
      --si solo es un ingreso a bodega NORMAL, entonces va directo a procesar en base a los parametros enviados.
      IF Lr_DatosBodega.Codigo IS NOT NULL THEN
        ---------------------------------
        GOTO ET05_LLENA_DATOS_PARAMETROS;
        ---------------------------------
      END IF;
    END IF;
    --
    --
    -- En regularizacion (Pantalla NAF) o tipo de articulo diferente de fibra no se validara concurrencia
    IF Pv_TipoActividad = GEK_VAR.Gc_Regularizacion OR Pv_TipoArticulo != 'Fibra' THEN
      ---------------------------
      GOTO E03_VALIDA_ID_CONTROL;
      ---------------------------
    END IF;
    --
    OPEN C_VERIFICA_PROCESADO(Pn_CantidadRec,
                              Pv_NumeroSerie,
                              Pn_IdCustodioRec,
                              Pn_IdTarea,
                              Lv_TipoTransacionAux,
                              Pv_IdTransaccion,
                              Lv_TipoActividadAux);

    FETCH C_VERIFICA_PROCESADO INTO Ln_Procesado;
    IF C_VERIFICA_PROCESADO%NOTFOUND THEN
      Ln_procesado := 0;
    END IF;
    CLOSE C_VERIFICA_PROCESADO;
    --
    IF NVL(Ln_procesado,0) > 0 THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_TRANSFIERE_CUSTODIO',
                                           'Pv_NumeroSerie: ' || Pv_NumeroSerie || CHR(13) ||
                                           'Pn_IdCustodioRec: ' || Pn_IdCustodioRec || CHR(13) ||
                                           'Pn_CantidadRec: ' || Pn_CantidadRec || CHR(13) || 
                                           'Pv_TipoTransaccion: ' || Pv_TipoTransaccion || CHR(13) ||
                                           'Pv_IdTransaccion: ' || Pv_IdTransaccion || CHR(13) ||
                                           'Pv_TipoActividad: ' || Pv_TipoActividad || CHR(13) ||
                                           'Pn_IdTarea: ' || Pn_IdTarea || CHR(13) ||
                                           'Pv_Login: ' || Pv_Login || CHR(13) ||
                                           'Pv_LoginProcesa: ' || Pv_LoginProcesa || CHR(13) ||
                                           'Pn_IdControl: ' || Pn_IdControl || CHR(13) ||
                                           'Pv_Observacion: ' || Pv_Observacion || CHR(13) ||
                                           'Pv_TipoArticulo: ' || Pv_TipoArticulo|| CHR(13) ||
                                           'log tarea ya ejecutada, se devuelve proceso exitoso.',
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      ------------------------
      GOTO ET04_VALIDA_COMMIT;
      ------------------------
    END IF;

    -------------------------
    <<E03_VALIDA_ID_CONTROL>>
    -------------------------
    -- No envia id control se busca todos los articulos para realizar tarsnferencias
    IF Nvl(Pn_IdControl,0) != 0 THEN
      ---------------------------------
      GOTO ET05_LLENA_DATOS_PARAMETROS;
      ---------------------------------
    END IF;
    --
    Ln_CantidadEntrega := Pn_CantidadEnt;
    --
    FOR Lr_ArticuloTransfe IN C_ARTICULOS_TRANSFERIR LOOP
      --
      Ln_NumReg := Ln_NumReg + 1;
      --        
      -- es el ultimo registro si hay pendientes debe descontar todo
      IF Ln_NumReg = Lr_ArticuloTransfe.Registros THEN
        Lr_ArticuloTransfe.cantidad := Ln_CantidadEntrega;
        IF nvl(Pn_CantidadRec,0) > 0 THEN
          Ln_CantidadRecibe := Lr_ArticuloTransfe.cantidad;
        END IF;
        -----------------------------------
        GOTO E04_LLENA_DATOS_TRANSFERENCIA;
        -----------------------------------
      END IF;

      IF nvl(Ln_CantidadEntrega,0) > 0 THEN
        --
        IF Lr_ArticuloTransfe.cantidad >= Ln_CantidadEntrega then
          Lr_ArticuloTransfe.cantidad := Ln_CantidadEntrega;
        END IF;
        --
        Ln_CantidadEntrega := Ln_CantidadEntrega - Lr_ArticuloTransfe.cantidad;
        --
      ELSE
        Lr_ArticuloTransfe.cantidad := nvl(Ln_CantidadEntrega,0);
      END IF;
      --
      IF nvl(Pn_CantidadRec,0) > 0 THEN
        Ln_CantidadRecibe := Lr_ArticuloTransfe.cantidad;
      END IF;
      -----------------------------------
      <<E04_LLENA_DATOS_TRANSFERENCIA>>--
      -----------------------------------

      Lr_ControlCustodio(Ln_Idx).ID_CONTROL := Lr_ArticuloTransfe.id_control;
      Lr_ControlCustodio(Ln_Idx).NUMERO_SERIE := Pv_NumeroSerie;
      Lr_ControlCustodio(Ln_Idx).CARACTERISTICA_ID := Pn_IdCaracteristica;
      Lr_ControlCustodio(Ln_Idx).EMPRESA_ID := Pv_IdEmpresa;
      Lr_ControlCustodio(Ln_Idx).CUSTODIO_ENTREGA_ID := Pn_IdCustodioEnt;
      Lr_ControlCustodio(Ln_Idx).CANTIDAD_ENTREGA := Lr_ArticuloTransfe.cantidad;
      Lr_ControlCustodio(Ln_Idx).CUSTODIO_RECIBE_ID := Pn_IdCustodioRec;
      Lr_ControlCustodio(Ln_Idx).CANTIDAD_RECIBE := Ln_CantidadRecibe;
      Lr_ControlCustodio(Ln_Idx).TIPO_TRANSACCION := Pv_TipoTransaccion;
      Lr_ControlCustodio(Ln_Idx).TRANSACCION_ID := Pv_IdTransaccion;
      Lr_ControlCustodio(Ln_Idx).TIPO_ACTIVIDAD := Pv_TipoActividad;
      Lr_ControlCustodio(Ln_Idx).TAREA_ID := Pn_IdTarea;
      Lr_ControlCustodio(Ln_Idx).LOGIN := Pv_Login;
      Lr_ControlCustodio(Ln_Idx).LOGIN_EMPLEADO := Pv_LoginProcesa;
      Lr_ControlCustodio(Ln_Idx).OBSERVACION := Pv_Observacion;
      Lr_ControlCustodio(Ln_Idx).TIPO_ARTICULO := Pv_TipoArticulo;
      --
      --P_TRANSFERENCIA(Lr_ControlCustodio, Pv_MensajeError);
      --
      ----------------------------
      <<E01_SIGUIENTE_REGISTRO>>--
      ----------------------------
      --
      Ln_Idx := Ln_Idx + 1;
      --
      /*
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      */
    END LOOP;
    --
    -- si recupero data de cursor anterio y no es un ingreso a bodega se procesa lo recuperado
    IF Ln_NumReg != 0 THEN
      ---------------------------------
      GOTO E02_PROCESA_TRANSFERENCIA;
      ---------------------------------
    END IF;
    --
    -- Es un ingreso a bodega donde no coincide empleado asignado en ingreso a bodega vs asignado en control custodio
    IF Pv_TipoActividad = 'IngresoBodega' THEN
      --
      FOR Lr_RetiroEquipos IN C_RETIRO_EQUIPOS LOOP
        --
        Lr_ControlCustodio(Ln_NumReg).ID_CONTROL := Lr_RetiroEquipos.id_control;
        Lr_ControlCustodio(Ln_NumReg).NUMERO_SERIE := Pv_NumeroSerie;
        Lr_ControlCustodio(Ln_NumReg).CARACTERISTICA_ID := Pn_IdCaracteristica;
        Lr_ControlCustodio(Ln_NumReg).EMPRESA_ID := Pv_IdEmpresa;
        Lr_ControlCustodio(Ln_NumReg).CUSTODIO_ENTREGA_ID := Lr_RetiroEquipos.Custodio_Id;
        Lr_ControlCustodio(Ln_NumReg).CANTIDAD_ENTREGA := Lr_RetiroEquipos.cantidad;
        Lr_ControlCustodio(Ln_NumReg).CUSTODIO_RECIBE_ID := NULL;
        Lr_ControlCustodio(Ln_NumReg).CANTIDAD_RECIBE := NULL;
        Lr_ControlCustodio(Ln_NumReg).TIPO_TRANSACCION := Pv_TipoTransaccion;
        Lr_ControlCustodio(Ln_NumReg).TRANSACCION_ID := Pv_IdTransaccion;
        Lr_ControlCustodio(Ln_NumReg).TIPO_ACTIVIDAD := 'RetiroEquipos';
        Lr_ControlCustodio(Ln_NumReg).TAREA_ID := Pn_IdTarea;
        Lr_ControlCustodio(Ln_NumReg).LOGIN := Lr_RetiroEquipos.Login;
        Lr_ControlCustodio(Ln_NumReg).LOGIN_EMPLEADO := Pv_LoginProcesa;
        Lr_ControlCustodio(Ln_NumReg).OBSERVACION := Pv_Observacion;
        Lr_ControlCustodio(Ln_NumReg).TIPO_ARTICULO := Pv_TipoArticulo;
        --
        --P_TRANSFERENCIA(Lr_ControlCustodio, Pv_MensajeError);
        --
        ----------------------------
        <<E01_SIGUIENTE_REGISTRO>>--
        ----------------------------
        --
        Ln_NumReg := Ln_NumReg + 1;
        --
        /*
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        */
      END LOOP;
    END IF;


    -- No se proceso nada, se envia el control id recibido para que genere los registros carga y descarga
    IF Ln_NumReg != 0 THEN
      -------------------------------
      GOTO E02_PROCESA_TRANSFERENCIA;
      -------------------------------
    END IF;
    --
    --------------------------------
    <<ET05_LLENA_DATOS_PARAMETROS>>
    --------------------------------
    Lr_ControlCustodio(0).ID_CONTROL := Pn_IdControl;
    Lr_ControlCustodio(0).NUMERO_SERIE := Pv_NumeroSerie;
    Lr_ControlCustodio(0).CARACTERISTICA_ID := Pn_IdCaracteristica;
    Lr_ControlCustodio(0).EMPRESA_ID := Pv_IdEmpresa;
    Lr_ControlCustodio(0).CUSTODIO_ENTREGA_ID := Pn_IdCustodioEnt;
    Lr_ControlCustodio(0).CANTIDAD_ENTREGA := Pn_CantidadEnt;
    Lr_ControlCustodio(0).CUSTODIO_RECIBE_ID := Pn_IdCustodioRec;
    Lr_ControlCustodio(0).CANTIDAD_RECIBE := Pn_CantidadRec;
    Lr_ControlCustodio(0).TIPO_TRANSACCION := Pv_TipoTransaccion;
    Lr_ControlCustodio(0).TRANSACCION_ID := Pv_IdTransaccion;
    Lr_ControlCustodio(0).TIPO_ACTIVIDAD := Pv_TipoActividad;
    Lr_ControlCustodio(0).TAREA_ID := Pn_IdTarea;
    Lr_ControlCustodio(0).LOGIN := Pv_Login;
    Lr_ControlCustodio(0).LOGIN_EMPLEADO := Pv_LoginProcesa;
    Lr_ControlCustodio(0).OBSERVACION := Pv_Observacion;
    Lr_ControlCustodio(0).TIPO_ARTICULO := Pv_TipoArticulo;
      --
    --
    -----------------------------
    <<E02_PROCESA_TRANSFERENCIA>>
    -----------------------------
    P_TRANSFERENCIA(Lr_ControlCustodio, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

    -----------------------
    <<ET04_VALIDA_COMMIT>>
    -----------------------
    IF Pb_Commit THEN
      COMMIT;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_TRANSFIERE_CUSTODIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_TRANSFIERE_CUSTODIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_TRANSFIERE_CUSTODIO;
  --


  PROCEDURE P_REGULARIZA_NEGATIVOS ( Pv_NumeroSerie IN VARCHAR2,
                                     Pn_CustodioId  IN NUMBER,
                                     Pv_UsrProcesa  IN VARCHAR2,
                                     Pv_EmpresaId   IN VARCHAR2) IS
    --
    PRAGMA AUTONOMOUS_TRANSACTION;
    --
    CURSOR C_NEGATIVOS IS
      SELECT ACC.ID_CONTROL,
             ACC.CANTIDAD,
             ACC.ARTICULO_ID,
             ACC.TIPO_ARTICULO,
             ACC.CARACTERISTICA_ID,
             ACC.CUSTODIO_ID,
             ACC.TIPO_CUSTODIO,
             ACC.EMPRESA_CUSTODIO_ID,
             ACC.EMPRESA_ID,
             ACC.CASO_ID,
             ACC.TAREA_ID,
             ACC.VALOR_BASE,
             ACC.LOGIN,
             ACC.NO_ARTICULO,
             ACC.ESTADO,
             ACC.TIPO_ACTIVIDAD,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID,
             ACC.FE_ASIGNACION,
             ACC.OBSERVACION
      FROM ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ARTICULO_ID = Pv_NumeroSerie--'10-06-02-006'
      AND ACC.CUSTODIO_ID = Pn_CustodioId --1581767
      AND ACC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ASIGNADO
      AND ACC.CANTIDAD < 0
      AND ACC.EMPRESA_ID = Pv_EmpresaId;
    --
    CURSOR C_POSITIVOS IS
      SELECT ACC.ID_CONTROL,
             ACC.CANTIDAD,
             ACC.ARTICULO_ID,
             ACC.TIPO_ARTICULO,
             ACC.CARACTERISTICA_ID,
             ACC.CUSTODIO_ID,
             ACC.TIPO_CUSTODIO,
             ACC.EMPRESA_CUSTODIO_ID,
             ACC.EMPRESA_ID,
             ACC.CASO_ID,
             ACC.TAREA_ID,
             ACC.VALOR_BASE,
             ACC.LOGIN,
             ACC.NO_ARTICULO,
             ACC.ESTADO,
             ACC.TIPO_ACTIVIDAD,
             ACC.TIPO_TRANSACCION_ID,
             ACC.TRANSACCION_ID,
             ACC.FE_ASIGNACION,
             ACC.OBSERVACION
      FROM ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ARTICULO_ID = Pv_NumeroSerie--'10-06-02-006'
      AND ACC.CUSTODIO_ID = Pn_CustodioId --1581767
      AND ACC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ASIGNADO
      AND ACC.CANTIDAD > 0
      AND ACC.EMPRESA_ID = Pv_EmpresaId
      ORDER BY ACC.CANTIDAD DESC;
    --
    Ln_MontoRegular     NUMBER;
    Lr_Positivo         C_POSITIVOS%ROWTYPE;
    Lr_CustodioNegativo NAF47_TNET.ARAF_CONTROL_CUSTODIO%ROWTYPE;
    Lr_CustodioPositivo NAF47_TNET.ARAF_CONTROL_CUSTODIO%ROWTYPE;
    Lv_MensajeError     VARCHAR2(3000);
    Le_Salir            EXCEPTION;
    --
  BEGIN

    FOR Lr_Negativo IN C_NEGATIVOS LOOP
      --
      Ln_MontoRegular := Lr_Negativo.CANTIDAD;
      --
      Lr_CustodioNegativo.Articulo_Id         := Lr_Negativo.Articulo_Id;
      Lr_CustodioNegativo.Tipo_Articulo       := Lr_Negativo.Tipo_Articulo;
      Lr_CustodioNegativo.Caracteristica_Id   := Lr_Negativo.Caracteristica_Id;
      Lr_CustodioNegativo.Custodio_Id         := Lr_Negativo.Custodio_Id;
      Lr_CustodioNegativo.Tipo_Custodio       := Lr_Negativo.Tipo_Custodio;
      Lr_CustodioNegativo.Empresa_Custodio_Id := Lr_Negativo.Empresa_Custodio_Id;
      Lr_CustodioNegativo.Empresa_Id          := Lr_Negativo.Empresa_Id;
      Lr_CustodioNegativo.Caso_Id             := Lr_Negativo.Caso_Id;
      Lr_CustodioNegativo.Tarea_Id            := Lr_Negativo.Tarea_Id;
      Lr_CustodioNegativo.Valor_Base          := Lr_Negativo.Valor_Base;
      Lr_CustodioNegativo.Login               := Lr_Negativo.Login;
      Lr_CustodioNegativo.No_Articulo         := Lr_Negativo.No_Articulo;
      Lr_CustodioNegativo.Estado              := Lr_Negativo.Estado;
      Lr_CustodioNegativo.Tipo_Transaccion_Id := Lr_Negativo.Tipo_Transaccion_Id;
      Lr_CustodioNegativo.Transaccion_Id      := Lr_Negativo.Transaccion_Id;
      Lr_CustodioNegativo.Fecha_Inicio        := TRUNC(SYSDATE);
      Lr_CustodioNegativo.Fe_Asignacion       := Lr_CustodioNegativo.Fecha_Inicio;
      Lr_CustodioNegativo.Fecha_Fin           := ADD_MONTHS(LAST_DAY(Lr_CustodioNegativo.Fecha_Inicio),1200);
      Lr_CustodioNegativo.Tipo_Actividad      := 'RegularizacionAutomatica';
      Lr_CustodioNegativo.Usr_Creacion        := Pv_UsrProcesa;
      Lr_CustodioNegativo.Id_Control_Origen   := Lr_Negativo.Id_Control; -- asigna transaccion anterior ejecutada.

      --
      IF C_POSITIVOS%ISOPEN THEN
        CLOSE C_POSITIVOS;
      END IF;
      OPEN C_POSITIVOS;
      FETCH C_POSITIVOS INTO Lr_Positivo;
      --
      LOOP 
        --
        Lr_CustodioPositivo.Articulo_Id         := Lr_Positivo.Articulo_Id;
        Lr_CustodioPositivo.Tipo_Articulo       := Lr_Positivo.Tipo_Articulo;
        Lr_CustodioPositivo.Caracteristica_Id   := Lr_Positivo.Caracteristica_Id;
        Lr_CustodioPositivo.Custodio_Id         := Lr_Positivo.Custodio_Id;
        Lr_CustodioPositivo.Tipo_Custodio       := Lr_Positivo.Tipo_Custodio;
        Lr_CustodioPositivo.Empresa_Custodio_Id := Lr_Positivo.Empresa_Custodio_Id;
        Lr_CustodioPositivo.Empresa_Id          := Lr_Positivo.Empresa_Id;
        Lr_CustodioPositivo.Caso_Id             := Lr_Positivo.Caso_Id;
        Lr_CustodioPositivo.Tarea_Id            := Lr_Positivo.Tarea_Id;
        Lr_CustodioPositivo.Valor_Base          := Lr_Positivo.Valor_Base;
        Lr_CustodioPositivo.Login               := Lr_Positivo.Login;
        Lr_CustodioPositivo.No_Articulo         := Lr_Positivo.No_Articulo;
        Lr_CustodioPositivo.Estado              := Lr_Positivo.Estado;
        Lr_CustodioPositivo.Tipo_Transaccion_Id := Lr_Positivo.Tipo_Transaccion_Id;
        Lr_CustodioPositivo.Transaccion_Id      := Lr_Positivo.Transaccion_Id;
        Lr_CustodioPositivo.Fecha_Inicio        := TRUNC(SYSDATE);
        Lr_CustodioPositivo.Fe_Asignacion       := Lr_CustodioPositivo.Fecha_Inicio;
        Lr_CustodioPositivo.Fecha_Fin           := ADD_MONTHS(LAST_DAY(Lr_CustodioPositivo.Fecha_Inicio),1200);
        Lr_CustodioPositivo.Tipo_Actividad      := 'RegularizacionAutomatica';
        Lr_CustodioPositivo.Usr_Creacion        := Pv_UsrProcesa;
        Lr_CustodioPositivo.Id_Control_Origen   := Lr_Positivo.Id_Control; -- asigna transaccion anterior ejecutada.
        --
        IF Lr_Positivo.CANTIDAD >= ABS(Ln_MontoRegular) THEN --cubre el total del negativo
          Lr_CustodioNegativo.Movimiento          := ABS(Ln_MontoRegular);
          Lr_CustodioNegativo.Cantidad            := Lr_Negativo.Cantidad + Lr_CustodioNegativo.Movimiento;
        ELSE
          Lr_CustodioNegativo.Movimiento          := Lr_Positivo.CANTIDAD;
          Lr_CustodioNegativo.Cantidad            := Lr_Negativo.Cantidad + Lr_CustodioNegativo.Movimiento;
        END IF;

        Lr_CustodioNegativo.Observacion         := Lr_Negativo.Observacion||'. Regularizacion Automatica de valores Negativos cruzando con valores positivos de Id_control: '||Lr_Positivo.Id_Control;
        Lr_CustodioNegativo.Id_Control          := NAF47_TNET.MIG_SECUENCIA.SEQ_ARAF_CONTROL_CUSTODIO;
        --
        P_INSERTA_CONTROL_CUSTODIO(Lr_CustodioNegativo, Lv_MensajeError);
        --
        IF Lv_MensajeError IS NOT NULL THEN
          RAISE Le_Salir;
        END IF;
        --
        -- se actualiza registro procesado
        UPDATE ARAF_CONTROL_CUSTODIO ACC
        SET ACC.FECHA_FIN   = Lr_CustodioNegativo.Fecha_Inicio - 1,
            ACC.ESTADO = NAF47_TNET.AFK_CONTROL_CUSTODIO.Gc_EstadoProcesado,
            ACC.USR_ULT_MOD = Pv_UsrProcesa,
            ACC.FE_ULT_MOD  = SYSDATE
        WHERE ACC.ID_CONTROL = Lr_Negativo.Id_Control;
        --
        --
        IF Lr_Positivo.CANTIDAD >= ABS(Ln_MontoRegular) THEN --cubre el total del negativo
          Lr_CustodioPositivo.Movimiento := Ln_MontoRegular;
          Lr_CustodioPositivo.Cantidad   := Lr_Positivo.Cantidad + Lr_CustodioPositivo.Movimiento;
          Ln_MontoRegular                := 0;
        ELSE
          Lr_CustodioPositivo.Movimiento := Lr_Positivo.CANTIDAD*-1;
          Lr_CustodioPositivo.Cantidad   := Lr_Positivo.Cantidad + Lr_CustodioPositivo.Movimiento;
          Ln_MontoRegular                := Ln_MontoRegular + Lr_Positivo.CANTIDAD;
        END IF;
        --
        Lr_CustodioPositivo.Observacion         := Lr_Positivo.Observacion||'. Regularizacion Automatica de valores Positivos cruzando con valores negativos de Id_control: '||Lr_Negativo.Id_Control;
        Lr_CustodioPositivo.Id_Control          := NAF47_TNET.MIG_SECUENCIA.SEQ_ARAF_CONTROL_CUSTODIO;
        --
        P_INSERTA_CONTROL_CUSTODIO(Lr_CustodioPositivo, Lv_MensajeError);
        --
        IF Lv_MensajeError IS NOT NULL THEN
          RAISE Le_Salir;
        END IF;
        --
        -- se actualiza registro procesado
        UPDATE ARAF_CONTROL_CUSTODIO ACC
        SET ACC.FECHA_FIN   = Lr_CustodioPositivo.Fecha_Inicio - 1,
            ACC.ESTADO = NAF47_TNET.AFK_CONTROL_CUSTODIO.Gc_EstadoProcesado,
            ACC.USR_ULT_MOD = Pv_UsrProcesa,
            ACC.FE_ULT_MOD  = SYSDATE
        WHERE ACC.ID_CONTROL = Lr_Positivo.Id_Control;
        --
        EXIT WHEN Ln_MontoRegular = 0 OR C_POSITIVOS%NOTFOUND;
        --
        FETCH C_POSITIVOS INTO Lr_Positivo;
        --
      END LOOP;
      --
      CLOSE C_POSITIVOS;
      --
    END LOOP;
    --
    COMMIT;
    --

  EXCEPTION
    WHEN Le_Salir then
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_REGULARIZA_NEGATIVOS',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Lv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_REGULARIZA_NEGATIVOS',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_REGULARIZA_NEGATIVOS;
  --
  --
  PROCEDURE P_INSERTA_INFO_ELEMENTO_TRAZAB (Pv_NumeroSerie  IN VARCHAR2,
                                            Pv_Login        IN VARCHAR2,
                                            Pn_OficinaId    IN NUMBER,
                                            Pv_Responsable  IN VARCHAR2,
                                            Pv_Transaccion  IN VARCHAR2,
                                            Pv_Ubicacion    IN VARCHAR2,
                                            Pv_EstadoNaf    IN VARCHAR2,
                                            Pv_EstadoTelcos IN VARCHAR2,
                                            Pv_EstadoActivo IN VARCHAR2,
                                            Pv_Observacion  IN VARCHAR2,
                                            Pv_EmpresaId    IN VARCHAR2,
                                            Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CLIENTE            CONSTANT VARCHAR2(07) := 'Cliente';
    ACTIVACION_CLIENTE CONSTANT VARCHAR2(18) := 'Activacion Cliente';
    --
    CURSOR C_INSTALACION_CLIENTE IS
      SELECT IET.ID_TRAZABILIDAD
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD IET
      WHERE IET.NUMERO_SERIE = Pv_NumeroSerie
      AND UBICACION = CLIENTE
      AND TRANSACCION = ACTIVACION_CLIENTE;
    --
    Lr_InfoElementoTrazabilidad DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD%ROWTYPE := NULL;
    Lr_InstalacionCliente       C_INSTALACION_CLIENTE%ROWTYPE;
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    -- Se verifica sin en trazabilidad esta asociado a una instalacion cliente para actualziarlo a instalacion nodo
    IF C_INSTALACION_CLIENTE%ISOPEN THEN
      CLOSE C_INSTALACION_CLIENTE;
    END IF;
    OPEN C_INSTALACION_CLIENTE;
    FETCH C_INSTALACION_CLIENTE INTO Lr_InstalacionCliente;
    IF C_INSTALACION_CLIENTE%NOTFOUND THEN
      Lr_InstalacionCliente := NULL;
    END IF;
    CLOSE C_INSTALACION_CLIENTE;
    --
    IF Lr_InstalacionCliente.Id_Trazabilidad IS NOT NULL THEN
      --
      UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD IET
      SET IET.UBICACION = Pv_Ubicacion,
          IET.TRANSACCION = Pv_Transaccion,
          IET.LOGIN = Pv_Login,
          IET.RESPONSABLE = Pv_Responsable,
          IET.OBSERVACION = Pv_Observacion
      WHERE IET.ID_TRAZABILIDAD = Lr_InstalacionCliente.Id_Trazabilidad;
      --
    ELSE
      Lr_InfoElementoTrazabilidad.Login           := Pv_Login;
      Lr_InfoElementoTrazabilidad.Usr_Creacion    := LOWER(USER); --NAF47_TNET.GEK_CONSULTA.F_RECUPERA_LOGIN;       emunoz 15012023 Cambio de Login usuario
      Lr_InfoElementoTrazabilidad.Ip_Creacion     := NAF47_TNET.GEK_CONSULTA.F_RECUPERA_IP;
      Lr_InfoElementoTrazabilidad.Cod_Empresa     := Pv_EmpresaId;
      Lr_InfoElementoTrazabilidad.Estado_Naf      := Pv_EstadoNaf;
      Lr_InfoElementoTrazabilidad.Estado_Activo   := Pv_EstadoActivo;
      Lr_InfoElementoTrazabilidad.Estado_Telcos   := Pv_EstadoTelcos;
      Lr_InfoElementoTrazabilidad.Ubicacion       := Pv_Ubicacion;
      Lr_InfoElementoTrazabilidad.Transaccion     := Pv_Transaccion;
      Lr_InfoElementoTrazabilidad.Observacion     := Pv_Observacion;
      Lr_InfoElementoTrazabilidad.Responsable     := Pv_Responsable;
      Lr_InfoElementoTrazabilidad.Oficina_Id      := Pn_OficinaId;
      Lr_InfoElementoTrazabilidad.Numero_Serie    := Pv_NumeroSerie;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_INFO_ELE_TRAZAB(Lr_InfoElementoTrazabilidad,
                                                            Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
  END IF;
  --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_INSERTA_INFO_ELEMENTO_TRAZAB',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_INSERTA_INFO_ELEMENTO_TRAZAB',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_INFO_ELEMENTO_TRAZAB; 
  --
  --
  PROCEDURE P_INSERTA_INFO_RELACION_ELEMEN (Pn_ElmentoIdA   IN NUMBER,
                                            Pn_ElmentoIdB   IN NUMBER,
                                            Pv_TipoRelacion IN VARCHAR2,
                                            Pv_Observacion  IN VARCHAR2,
                                            Pv_Estado       IN VARCHAR2,
                                            Pv_MensajeError IN OUT VARCHAR2) IS
    --
    Lr_InfoRelacionElemento DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO%ROWTYPE;
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    Lr_InfoRelacionElemento.ELEMENTO_ID_A  := Pn_ElmentoIdA;
    Lr_InfoRelacionElemento.ELEMENTO_ID_B  := Pn_ElmentoIdB;
    Lr_InfoRelacionElemento.TIPO_RELACION  := Pv_TipoRelacion;
    Lr_InfoRelacionElemento.OBSERVACION    := Pv_Observacion;
    Lr_InfoRelacionElemento.USR_CREACION   := LOWER(USER);    --NAF47_TNET.GEK_CONSULTA.F_RECUPERA_LOGIN;     emunoz 15012023 Cambio de Login 
    Lr_InfoRelacionElemento.IP_CREACION    := NAF47_TNET.GEK_CONSULTA.F_RECUPERA_IP;
    Lr_InfoRelacionElemento.ESTADO         := Pv_Estado;
    --
    DB_INFRAESTRUCTURA.INFRK_DML.INFRP_INSERT_RELACION_ELEMENTO@GPOETNET (Lr_InfoRelacionElemento,
                                                                 Pv_MensajeError);

    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
  --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_INSERTA_INFO_RELACION_ELEMEN',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_INSERTA_INFO_RELACION_ELEMEN',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_INFO_RELACION_ELEMEN; 
  --
  --
  PROCEDURE P_VALIDA_PARAMETRO_INSTALACION (Pv_ArticuloId   IN VARCHAR2,
                                            Pv_EmpresaId    IN VARCHAR2,
                                            Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_PARAMETROS_VALIDAR IS
      SELECT APD.VALOR1 AS SENTENCIA_SQL,
             APD.VALOR3 AS PARAMETRO,
             APD.VALOR4 AS VALOR_COMPARAR,
             APD.VALOR5 AS MENSAJE_ERROR
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = PARAMETROS_INSTALACION
      AND APD.EMPRESA_COD IS NULL
      AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL
                  FROM NAF47_TNET.ARINDA DA
                  WHERE DA.NO_ARTI = Pv_ArticuloId
                  AND DA.NO_CIA = Pv_EmpresaId
                  AND DA.TIPO_ARTICULO = APD.VALOR2)
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.NOMBRE_PARAMETRO = CONTROL_CUSTODIO
                  AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
      UNION
      SELECT APD.VALOR1 AS SENTENCIA_SQL,
             APD.VALOR3 AS PARAMETRO,
             APD.VALOR4 AS VALOR_COMPARAR,
             APD.VALOR5 AS MENSAJE_ERROR
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = PARAMETROS_INSTALACION
      AND APD.EMPRESA_COD = Pv_EmpresaId
      AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL
                  FROM NAF47_TNET.ARINDA DA
                  WHERE DA.NO_ARTI = Pv_ArticuloId
                  AND DA.NO_CIA = APD.EMPRESA_COD
                  AND DA.TIPO_ARTICULO = APD.VALOR2)
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.NOMBRE_PARAMETRO = CONTROL_CUSTODIO
                  AND APC.ID_PARAMETRO = APD.PARAMETRO_ID);
    --
    Lc_Datos     SYS_REFCURSOR;
    Lv_Resultado VARCHAR2(100);
    --
  BEGIN
    --
    FOR Lr_Datos IN C_PARAMETROS_VALIDAR LOOP
      --
      OPEN Lc_Datos FOR Lr_Datos.Sentencia_Sql 
      USING Pv_ArticuloId, 
            Pv_EmpresaId;
      --
      FETCH Lc_Datos into Lv_Resultado;
      CLOSE Lc_Datos;
      --
      IF Lv_Resultado != Lr_Datos.Valor_Comparar THEN
        IF Pv_MensajeError IS NULL THEN
          Pv_MensajeError := Lr_Datos.Parametro||' '||Lr_Datos.Mensaje_Error;
        ELSE
          Pv_MensajeError := Pv_MensajeError||CHR(10)||Lr_Datos.Parametro||' '||Lr_Datos.Mensaje_Error;
        END IF;
      END IF;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'AFK_CONTROL_CUSTODIO.P_VALIDA_PARAMETRO_INSTALACION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_VALIDA_PARAMETRO_INSTALACION;
  --
  --
end AFK_CONTROL_CUSTODIO;
/