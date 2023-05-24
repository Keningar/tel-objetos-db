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
  * @author Elvis Mu�oz <emunoz@telconet.ec>
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