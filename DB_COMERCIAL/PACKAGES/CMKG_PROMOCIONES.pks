CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES AS 

  /**
  * Documentación para TYPE 'Lr_PtosClientesProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE Lr_PtosClientesProcesar IS RECORD (
    ID_PERSONA_ROL         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN                  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    COD_EMPRESA            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  );

  /**
  * Documentación para TYPE 'T_PtosClientesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE T_PtosClientesProcesar IS TABLE OF Lr_PtosClientesProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentación para TYPE 'Lr_GruposPromocionesProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 10-06-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 03-09-2020 - Se aumenta el tamaño al campo TIPO_PROCESO motivo que se agregaron nuevos tipos upgrade y downgrade
  */
  TYPE Lr_GruposPromocionesProcesar IS RECORD (
    ID_GRUPO_PROMOCION     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    NOMBRE_GRUPO           DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
    FE_INICIO_VIGENCIA     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_INICIO_VIGENCIA%TYPE,
    FE_FIN_VIGENCIA        DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_FIN_VIGENCIA%TYPE,
    FE_CREACION            DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_CREACION%TYPE,
    EMPRESA_COD            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    TIPO_PROCESO           VARCHAR2(3200),
    PRIORIDAD              NUMBER
  );

  /**
  * Documentación para TYPE 'T_GruposPromocionesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-07-2019
  */
  TYPE T_GruposPromocionesProcesar IS TABLE OF Lr_GruposPromocionesProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentación para TYPE 'Lr_TiposPromocionesProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 10-06-2019
  */
  TYPE Lr_TiposPromocionesProcesar IS RECORD (
    ID_GRUPO_PROMOCION       DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    NOMBRE_GRUPO             DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
    FE_INICIO_VIGENCIA       DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_INICIO_VIGENCIA%TYPE,
    FE_FIN_VIGENCIA          DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_FIN_VIGENCIA%TYPE,
    ID_TIPO_PROMOCION        DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
    TIPO                     DB_COMERCIAL.ADMI_TIPO_PROMOCION.TIPO%TYPE,
    FE_CREACION              DB_COMERCIAL.ADMI_TIPO_PROMOCION.FE_CREACION%TYPE,
    CODIGO_TIPO_PROMOCION    DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    CODIGO_GRUPO_PROMOCION   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    PRIORIDAD                NUMBER,
    EMPRESA_COD              DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  );

  /**
  * Documentación para TYPE 'T_TiposPromocionesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-07-2019
  */
  TYPE T_TiposPromocionesProcesar IS TABLE OF Lr_TiposPromocionesProcesar INDEX BY PLS_INTEGER;

  /**
  *  Documentación para TYPE 'Lr_ServiciosProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 12-06-2019
  */      
  TYPE Lr_ServiciosProcesar IS RECORD (
    ID_SERVICIO            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,    
    ID_PLAN                DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ID_PRODUCTO            DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    PLAN_ID_SUPERIOR       DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE   
  ); 

  /**
  * Documentación para TYPE 'T_ServiciosProcesar'.  
  * 
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2019
  */
  TYPE T_ServiciosProcesar IS TABLE OF Lr_ServiciosProcesar INDEX BY PLS_INTEGER;

  /**
  *  Documentación para TYPE 'Lr_TipoPromoPlanProdProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-06-2019
  */      
  TYPE Lr_TipoPromoPlanProdProcesar IS RECORD (
    ID_TIPO_PROMOCION      DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
    CODIGO_TIPO_PROMOCION  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    ID_PLAN                DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ID_PRODUCTO            DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    PLAN_ID_SUPERIOR       DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ESTADO                 DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION.ESTADO%TYPE   
  ); 

  /**
  * Documentación para TYPE 'T_TipoPromoPlanProdProcesar'.  
  * 
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-06-2019
  */
  TYPE T_TipoPromoPlanProdProcesar IS TABLE OF Lr_TipoPromoPlanProdProcesar INDEX BY PLS_INTEGER;

  /**
  *  Documentación para TYPE 'Lr_GrupoPromoReglaProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2019
  */  
  TYPE Lr_GrupoPromoReglaProcesar IS RECORD (    
    ID_GRUPO_PROMOCION     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    PROM_ESTADO_SERVICIO   DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_FORMA_PAGO        DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_EMISOR            DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_TIPO_CLIENTE      DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE,
    NOMBRE_GRUPO           DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
    FE_INICIO_VIGENCIA     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_INICIO_VIGENCIA%TYPE,
    FE_FIN_VIGENCIA        DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_FIN_VIGENCIA%TYPE,
    FE_CREACION            DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_CREACION%TYPE
  );    

  /**
  *  Documentación para TYPE 'Lr_TipoPromoReglaProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2019
  */   
   TYPE Lr_TipoPromoReglaProcesar IS RECORD (    
    ID_GRUPO_PROMOCION           DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    NOMBRE_GRUPO                 DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
    FE_INICIO_VIGENCIA           DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_INICIO_VIGENCIA%TYPE,
    FE_FIN_VIGENCIA              DB_COMERCIAL.ADMI_GRUPO_PROMOCION.FE_FIN_VIGENCIA%TYPE,
    CODIGO_TIPO_PROMOCION        DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    TIPO                         DB_COMERCIAL.ADMI_TIPO_PROMOCION.TIPO%TYPE,
    FE_CREACION                  DB_COMERCIAL.ADMI_TIPO_PROMOCION.FE_CREACION%TYPE,
    ID_TIPO_PROMOCION            DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
    PROM_ESTADO_SERVICIO         DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_ULTIMA_MILLA            DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_PERMANENCIA_MINIMA      DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_PIERDE_PROMOCION_MORA   DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_EMISOR                  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_DESCUENTO               DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_FORMA_PAGO              DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_ANTIGUEDAD              DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_PERIODO                 DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_PROMOCION_INDEFINIDA    DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_TIPO_NEGOCIO            DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_TIPO_PERIODO            DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_DIAS_MORA               DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_TIPO_CLIENTE            DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
    PROM_INVALIDA_PROMO          DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE
  );   

  /**
  *  Documentación para TYPE 'Lr_SectorizacionProcesar'.
  *  
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 19-06-2019
  */
  TYPE Lr_SectorizacionProcesar IS RECORD (
    ID_SECTORIZACION           DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.SECUENCIA%TYPE,
    ID_JURISDICCION            DB_INFRAESTRUCTURA.ADMI_JURISDICCION.ID_JURISDICCION%TYPE,
    DESCRIPCION_JURISDICCION   DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
    ID_CANTON                  DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
    NOMBRE_CANTON              DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    ID_PARROQUIA               DB_GENERAL.ADMI_PARROQUIA.ID_PARROQUIA%TYPE,
    NOMBRE_PARROQUIA           DB_GENERAL.ADMI_PARROQUIA.NOMBRE_PARROQUIA%TYPE,
    ID_SECTOR                  DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE,
    ID_ELEMENTO                DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE,
    ID_EDIFICIO                DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.VALOR%TYPE
  );
  /**
  * Documentación para TYPE 'T_SectorizacionProcesar'.  
  * 
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2019
  */
  TYPE T_SectorizacionProcesar IS TABLE OF Lr_SectorizacionProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentación para PROCEDURE 'P_OBTIENE_GRUPOS_PROC_MAPEO'.
  *
  * Procedimiento que obtiene los grupos parametrizados por banco_tipo_cuenta_id y por ciclo de facturación para filtrar los clientes
  * para el procesamiento del Mapeo Promocional Mensual.
  * Se procesa clientes existentes, basados en los grupos parametrizados el día anterior a su fecha de Fin de ciclo.
  *
  * Costo Query C_GetCiclosDiaProceso:2
  * Costo Query C_GruposEjecucionMapeoMensual:6
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE, 
  * Tipo de Promoción a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  * Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad , 
  * PROM_BW:   Descuento por Ancho de Banda, 
  * PROM_INS:  Descuento y Diferido de Instalación.
  *
  * @Param Pv_CodEmpresa             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Código de Empresa.
  * @Param Pv_TipoProceso            IN VARCHAR2, Tipo de Proceso a ejecutarse:
  * NUEVOS: Clientes Nuevos, EXISTENTES: Clientes Existentes.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 02-09-2019
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 21-11-2019 - Se modifica para que el proceso de mapeo de Promociones para Clientes existentes se levante el dia de inicio
  *                           por cada ciclo de de facturación.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.2 14-05-2020 - Se elimina validación para obtener los grupos de ejecución de mapeos según el ciclo, 
  * se agrega validación para que se realice el mapeo ya sea por el proceso diario o por el proceso mensual pero no por ambos a la vez. 
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 10-11-2020 - Se realizan cambios en el proceso para invocar como prioridad al proceso de mapeo de promociones para los servicios
  *                           que tienen un código promocional como característica en estado activo.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.6 17-03-2023 - Se agrega validación de promociones vigentes.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.7 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_OBTIENE_GRUPOS_PROC_MAPEO(Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoProceso          IN VARCHAR2,
                                        Pv_JobProceso           IN VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_PROCESO_MAPEO_PROMOCIONES'.
  *
  * Procedimiento que Procesa el Mapeo de Promociones para Clientes Nuevos y Existentes
  *
  * Costo Query C_GetEmpresa:0
  * Costo Query C_GetErrorRepetido:8
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE, 
  * Tipo de Promoción a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  * Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad , 
  * PROM_BW:   Descuento por Ancho de Banda, 
  * PROM_INS:  Descuento y Diferido de Instalación.
  *
  * @Param Pv_CodEmpresa             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Código de Empresa.
  * @Param Pv_TipoProceso            IN VARCHAR2, Tipo de Proceso a ejecutarse:
  * NUEVOS: Clientes Nuevos, EXISTENTES: Clientes Existentes.
  * @Param Pv_FormaPago              IN VARCHAR2 DEFAULT NULL Descripcion de la forma de pago,
  * @Param Pn_IdCiclo                IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL Id del ciclo de Facturación,
  * @Param Pv_IdsFormasPagoEmisores  IN VARCHAR2 DEFAULT NULL Contiene Ids de Formas de Pagos o de emisores (Banco_tipo_cuenta_id) separados por coma.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-06-2019
  *
  * Se modifica proceso por motivo de los nuevos párametros que se agregaron a la función F_VALIDA_SECTORIZACION.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 27-09-2019
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.2 24-10-2019 -Se modifica Proceso y se agrega funcion F_OBTIENE_FECHA_EVAL_VIGENCIA para obtener la Fecha para evaluación de Vigencia
  *                          la cual permite validar si un Grupo Promocional puede ser otorgado en base a su fecha Inicio y Fin de vigencia.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.3 13-11-2019 -Se agrega bloque de manejo de excepciones por Punto , se agrega que se inserte en INFO_ERROR en caso de no obtener  la
  *                          fecha para evaluación de Vigencia por casos de inconsistencia en data de contratos se inserta LOG de error y se continua
  *                          con el proceso.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 03-09-2020 - Se cambia la lectura de los grupos promocionales por promociones ordenadas por prioridad de sectorización.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 10-11-2020 - Se realizan cambios en el proceso por afectaciones de lecturas de los servicios que tienen un característica activa de un
  *                           de código promocional.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.6 23-02-2023 - Se agrega parametro Pv_Alcance para evaluar los servicios confirmados desde un rango parametrizado.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.7 17-03-2023 - Se agrega validaciones de promociones vigentes.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.8 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_PROCESO_MAPEO_PROMOCIONES(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoProceso           IN VARCHAR2,
                                        Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                        Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                        Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                        Pv_Alcance               IN VARCHAR2 DEFAULT NULL);

  /**
  * Documentación para FUNCTION 'F_GET_TRAMA'.
  *
  * Función Para obtener información del cliente en base a las reglas promocionales y contruye la Trama, devuelve varchar del string de 
  * la trama completa.
  *
  * Costo Query C_GetDataTrama:25
  * Costo Query C_GetDataServicio:25
  *
  * PARAMETROS:
  * @Param Fn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,  
  * @Param Fr_GrupoPromoRegla       IN Lr_GrupoPromoReglaProcesar DEFAULT NULL
  * @Param Fr_TipoPromoRegla        IN Lr_TipoPromoReglaProcesar DEFAULT NULL,
  * @Param Fa_ServiciosCumplePromo  IN T_ServiciosProcesar
  * @Param Fa_SectorizacionProcesar IN T_SectorizacionProcesar
  * @Param Fn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL 
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-07-2019
  *
  * Se agrega a la función un parámetro de entrada por id_servicio, se cambia lógica interna para que la función
  * devuelva información por id_servicio si asi lo requiere el proceso que consuma la función.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 27-09-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 05-02-2021 - Se quita nvl de query principal y se crea otro cursor que se abrirá solo cuando el
  *                           parámetro Fn_IdServicio reciba información.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 23-03-2023 - Se quita CASTEO en querys para los campos de tipo DATE;
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 03-03-2023 - Se agrega parametro de entrada Pv_CodEmpresa el mismo que sirve para filtrar la tabla 
  *                           parametros.
  */
  FUNCTION F_GET_TRAMA(Fn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                       Fr_GrupoPromoRegla       IN Lr_GrupoPromoReglaProcesar DEFAULT NULL,
                       Fr_TipoPromoRegla        IN Lr_TipoPromoReglaProcesar DEFAULT NULL,
                       Fa_ServiciosCumplePromo  IN T_ServiciosProcesar,
                       Fa_SectorizacionProcesar IN T_SectorizacionProcesar,
                       Fn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL)
  RETURN VARCHAR2;

  /**
  * Documentación para PROCEDURE 'P_OBTIENE_PUNTOS_PROCESAR'.
  *
  * Procedimiento que obtiene los Puntos Clientes a Procesar para el mapeo de promociones.
  * En caso de TipoProceso: NUEVO se obtiene los clientes que poseen servicios de Facturación mensual y que hayan confirmado o activado el servicio el 
  * dia de procesamiento SYSDATE
  * En caso de TipoProceso: EXISTENTE se obtiene los clientes que poseen servicios de Facturación mensual y que la información de la forma de pago,
  * emisores (banco_tipo_cuenta_id) y el ciclo de facturación correspondan a los valores recibidos como parametros
  *
  * Costo Query para Clientes que Confirman Servicios (TipoProceso: NUEVO) : 13975
  * Costo Query para Clientes existentes (TipoProceso: EXISTENTE) : 12022
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE, 
  * Tipo de Promoción a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  * Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad , 
  * PROM_BW:   Descuento por Ancho de Banda, 
  * PROM_INS:  Descuento y Diferido de Instalación.
  * 
  * @Param Pv_CodEmpresa            IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Código de Empresa.
  * @Param Pv_TipoProceso           IN  VARCHAR2, Tipo de Proceso a ejecutarse: Clientes Nuevos, Clientes Existentes.
  * @Param Pv_FormaPago             IN VARCHAR2 DEFAULT NULL Descripcion de la forma de pago,
  * @Param Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL Id del ciclo de Facturación,
  * @Param Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL Contiene Ids de Formas de Pagos o de emisores (Banco_tipo_cuenta_id) separados por coma.
  * @Param Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL
  * @Param Pv_Consulta              OUT VARCHAR2, Obtiene y devuelve string de la consulta de Puntos según el tipo de Promoción y el Tipo de
  * Proceso a ejecutarse      
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 11-06-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 03-01-2020 - Se modifica la parte de obtener los puntos de Clientes nuevos para que el proceso considere un rango de hora del día anterior, 
  *                           por el motivo que existen Clientes que confirman un servicio después de la ejecución de los procesos de mapeo.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.2 04-09-2020 - Se agrega variable IdPunto para obtener la búsqueda de puntos de forma individual.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 10-11-2020 - Se agrega variable Pv_EsCodigo para realizar las evaluaciones de los servicios que tiene una característica activa de un código 
  *                           promocional.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 23-02-2023 - Se agrega parametro Pv_Alcance para evaluar los servicios confirmados desde un rango parametrizado.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 17-03-2023 - Se cambia el tipo de dato de la variable de salida Pv_Consulta y se modifica query macro.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.6 07-03-2023 - Se agregan validacion por proyecto Ecuanet.  
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.7 04-04-2023 - Se agrega validación al query para verificar si un servicio cuenta con promoción vigente.
  */
  PROCEDURE P_OBTIENE_PUNTOS_PROCESAR(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                      Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pv_TipoProceso           IN VARCHAR2,
                                      Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                      Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                      Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                      Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                      Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL,
                                      Pv_Alcance               IN VARCHAR2 DEFAULT NULL,
                                      Pv_Consulta              OUT CLOB);

  /**
  * Documentación para PROCEDURE 'P_OBTIENE_SERVICIOS_PROCESAR'.
  *
  * Procedimiento que obtiene los Servicios a Procesar en base al Punto, el codigo de empresa, considerando el estado de los servicios
  * en base a la regla (PROM_ESTADO_SERVICIO) y al TipoProceso a ejecutarse sobre los clientes: NUEVO y/o EXISTENTE
  *
  * Costo Query obtiene servicios cliente Nuevo: 15
  * Costo Query obtiene servicios cliente Existente: 14  
  *
  * PARAMETROS:
  * @Param Pn_IdPunto                IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, Id del Punto a Procesar
  * @Param Pv_CodigoGrupoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * Codigo del grupo Promocional: PROM_MENS, PROM_BW, PROM_INS.
  * PROM_MENS: Grupo de Promociones Mensual.
  * Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad , 
  * PROM_BW:   Descuento por Ancho de Banda, 
  * PROM_INS:  Descuento y Diferido de Instalación.
  *
  * @Param Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Código de Empresa.
  * @Param Pv_TipoProceso            IN  VARCHAR2, Tipo de Proceso a ejecutarse: NUEVO: Clientes Nuevos, EXISTENTE: Clientes Existentes.
  * @Param Pa_ServiciosProcesar      OUT T_ServiciosProcesar, Se obtiene tabla de Servicios por Punto Cliente
  * @Param Pv_EstadoServicio         IN VARCHAR2 Estados de los Servicios a considerarse en el Procesamiento del Mapeo en base a la regla
  *                                  PROM_ESTADO_SERVICIO definida por Grupo o Tipo de Promoción.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 13-06-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 03-01-2020 - Se modifica la parte de obtener los servicios de Clientes nuevos para que el proceso considere un rango de hora del día anterior, 
  *                           por el motivo que existen Clientes que confirman un servicio después de la ejecución de los procesos de mapeo.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 05-02-2021 - Se envían parámetros al query dinámico para mejorar los tiempos de respuesta en ejecuciones masivas.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 10-11-2020 - Se se agrega el dato de entrada Pn_IdServicio para que la consulta se la realice por un servicio en especifico por motivo de las 
  *                           las evaluaciones de promociones por código.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.4 29-08-2022 - Se realiza cambio al formatear fecha en consulta de fecha de creación de historial del servicio .
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 23-02-2023 - Se agrega parametro Pv_Alcance para evaluar los servicios confirmados desde un rango parametrizado.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.6 23-03-2023 - Se cambian las variables que componen Lv_Consulta a tipo dato CLOB y se se agrega query que remplaza 
  *                           la función DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.7 03-03-2023 - Se agrega filtro empresa al los query que hagan referencia a las estructura de parametro.
  *
  */
  PROCEDURE P_OBTIENE_SERVICIOS_PROCESAR(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoProceso          IN VARCHAR2,                                        
                                         Pa_ServiciosProcesar    OUT T_ServiciosProcesar,
                                         Pv_EstadoServicio       IN VARCHAR2,
                                         Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                         Pv_Codigo               IN VARCHAR2 DEFAULT NULL,
                                         Pv_EsContrato           IN VARCHAR2 DEFAULT NULL,
                                         Pv_Alcance              IN VARCHAR2 DEFAULT NULL);

  /**
  * Documentación para PROCEDURE 'P_OBTIENE_GRUPOS_PROMOCIONES'.
  *
  * Procedimiento que obtiene los Grupos de Promociones del parametro PROM_TIPO_PROMOCIONES en base al Código de empresa,
  * Codigo de Grupo Promoción, cuya fecha de procesamiento se encuentre en el rango de fecha de inicio y fin de Vigencia.
  *
  * Costo Query obtiene grupos promocionales:14
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE, 
  * Tipo de Promoción a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  * Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad , 
  * PROM_BW:   Descuento por Ancho de Banda, 
  * PROM_INS:  Descuento y Diferido de Instalación.
  *
  * @Param Pv_CodEmpresa            IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Código de Empresa.
  * @Param Pv_TipoProceso           IN  VARCHAR2, Tipo de Proceso NUEVOS: Clientes Nuevos, EXISTENTE: Clientes Existentes
  * @Param Prf_GruposPromociones    OUT SYS_REFCURSOR Obtiene listado de Grupos de Promociones a Procesar.
  * @Param Pd_FeEvaluaVigencia      IN DATE DEFAULT NULL fecha que se obtienen las promociones por su rango de vigencia
  * @Param Pn_IdPromocion           IN NUMBER DEFAULT NULL id de promción especifica a obtener
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 13-06-2019
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 24-10-2019 - Se agrega parametro Fecha de evaluacion de Vigencias, se evaluara en base a la fecha el rango de inicio y fin 
  *                           de vigencia para permitir otorgar o no un grupo promocional
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 03-09-2020 - Se agrega parametro Pn_IdPromocion para las evaluaciones por una promción en especifica y se cambia Pd_FeEvaluaVigencia
  *                           a DEFAULT NULL para los proceso que no necesiten enviar este valor.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 05-02-2021 - Se envían parámetros al query dinámico para mejorar los tiempos de respuesta en ejecuciones masivas.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 10-11-2020 - Se realizan validaciones en el query dinámico para las consultas que se realicen por un id promoción en específico.
  * 
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.5 27-09-2021 - Se modifica query dinamico y se reemplaza uso de REGEXP_LIKE debido a que se detecta que el query esta generando 
  *                           lentitud en el proceso de mapeo de promociones de clientes 'EXISTENTES', lo cual afecta el tiempo de la ejecución
  *                           del mapeo promocional y posterior proceso de facturación mensual.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.6 29-11-2021 - Se modifica query dinamico y se agrega ordenamiento por:
  *                          1)  Ordenamiento por tipo de promoción en base al parametro 'PROM_TIPO_PROMOCIONES'.
  *                          2)  Ordenamiento por la fecha mas actual de creación de la promoción.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.7 15-07-2022 - Se modifica query dinamico y se agrega ordenamiento por ID_GRUPO_PROMOCION.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.8 23-03-2023 - Se modifica query dinamico se quitan CASTEO a los campos de tipo DATE.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.9 04-04-2023 - Se agrega validación al query para verificar si un servicio cuenta con promoción vigente.
  */  
  PROCEDURE P_OBTIENE_GRUPOS_PROMOCIONES(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoProceso           IN VARCHAR2,
                                         Prf_GruposPromociones    OUT SYS_REFCURSOR,
                                         Pd_FeEvaluaVigencia      IN DATE DEFAULT NULL,
                                         Pn_IdPromocion           IN NUMBER DEFAULT NULL);

  /**
  * Documentación para PROCEDURE 'P_OBTIENE_TIPOS_PROMOCIONES'.
  *
  * Procedimiento que obtiene los Tipos de Promociones en base al parametro PROM_TIPO_PROMOCIONES, Código de empresa,
  * Codigo de Grupo Promoción, id grupo Promocional, cuya fecha de procesamiento se encuentre en el rango de fecha de inicio y fin de Vigencia.
  * y Ordenado por prioridad.
  *
  * Costo Query obtiene tipos promocionales:9
  *
  * PARAMETROS:
  * @Param Pn_IdGrupoPromocion      IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
  * @Param Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE, 
  * Tipo de Promoción a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  * Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad , 
  * PROM_BW:   Descuento por Ancho de Banda, 
  * PROM_INS:  Descuento y Diferido de Instalación.
  *
  * @Param Pv_CodEmpresa            IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Código de Empresa.
  * @Param Prf_TiposPromociones     OUT SYS_REFCURSOR Obtiene listado de Tipos de Promociones a Procesar.
  * @Param Pd_FeEvaluaVigencia      IN DATE DEFAULT NULL fecha con la que se obtienen las promociones por su rango de vigencia.
  * @Param Pv_TipoProceso           IN VARCHAR2 DEFAULT NULL tipo de proceso a evaluar Nuevo, Existenten, UpGrade , etc.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 13-06-2019
  *
  * Se modificó query principal para que el id_grupo_promocion soporte valores nulos y devuelva todas la promociones vigente
  * por el código del tipo de promoción.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 27-09-2019
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.2 24-10-2019 - Se agrega parametro Fecha de evaluacion de Vigencias, se evaluara en base a la fecha el rango de inicio y fin 
  *                           de vigencia para permitir otorgar o no un grupo promocional
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 03-09-2020 - Se agrega parametro de entrada Pv_TipoProceso que la proceso trabaje tanto por un id promoción en especifico ó por
  *                           el tipo de proceso enviado se cambiaron los parametros Pn_IdGrupoPromocion y Pd_FeEvaluaVigencia a DEFAULT NULL para
  *                           los proceso que no necesiten enviar estos valores.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 05-02-2021 - Se envían parámetros al query dinámico para mejorar los tiempos de respuesta en ejecuciones masivas.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 10-11-2020 - Se agrega parametro de entrada Pn_IdTipoPromocion para que el proceso trabaje por un id tipo promoción en especifico.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.6 29-11-2021 - Se modifica query dinamico y se agrega ordenamiento por:
  *                          1)  Ordenamiento por tipo de promoción en base al parametro 'PROM_TIPO_PROMOCIONES'.
  *                          2)  Ordenamiento por la fecha mas actual de creación de la promoción.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.7 15-07-2022 - Se modifica query dinamico y se agrega ordenamiento por ID_GRUPO_PROMOCION.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.8 23-03-2023 - Se modifica query dinamico se quitan CASTEO a los campos de tipo DATE. 
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.9 03-03-2023 - Se agrega filtro empresa en el query dinamino.
  *
  */  
  PROCEDURE P_OBTIENE_TIPOS_PROMOCIONES(Pn_IdGrupoPromocion      IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE DEFAULT NULL,
                                        Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Prf_TiposPromociones     OUT SYS_REFCURSOR,
                                        Pd_FeEvaluaVigencia      IN DATE DEFAULT NULL,
                                        Pv_TipoProceso           IN VARCHAR2 DEFAULT NULL,
                                        Pn_IdTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE DEFAULT NULL);

  /**
  * Documentación para FUNCTION 'F_GET_PROMO_GRUPO_REGLA'.
  * Función que retorna registro de las reglas  definidas para un Grupo Promocional.
  *
  * Costo Query C_GetPromoGrupoRegla:8
  *
  * @Param Fn_IdGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
  * RETURN Lr_GrupoPromoReglaProcesar
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2019
  */
  FUNCTION F_GET_PROMO_GRUPO_REGLA(Fn_IdGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
  RETURN Lr_GrupoPromoReglaProcesar;

  /**
  * Documentación para FUNCTION 'F_GET_PROMO_TIPO_REGLA'.
  * Función que retorna registro de las reglas por Tipo Promocional.
  *
  * Costo Query C_GetPromoTipoRegla:9
  *
  * @Param Fn_IdTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE
  * RETURN Lr_TipoPromoReglaProcesar
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2019
  */
  FUNCTION F_GET_PROMO_TIPO_REGLA(Fn_IdTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
  RETURN Lr_TipoPromoReglaProcesar;

  /**
  * Documentación para FUNCTION 'F_GET_PROMO_SECTORIZACION'.
  * Función que retorna tabla con la sectorización de un Grupo Promocional 
  *
  * Costo Query C_GetSectorizacionPorGrupo:5
  * Costo Query C_GetSectorizacionPorTipo:7
  *
  * @Param Fn_IdGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
  * RETURN T_SectorizacionProcesar
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-06-2019
  */
  FUNCTION F_GET_PROMO_SECTORIZACION(Fn_IdGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
  RETURN T_SectorizacionProcesar;

  /**
  * Documentación para FUNCTION 'F_GET_TIPO_PROMO_PLAN_PROD'.
  * Función que retorna tabla con los planes y productos por Tipo Promocional
  *
  * Costo Query C_GetPlanProdPorTipoPromo:5
  *
  * @Param Fn_IdTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE
  * RETURN T_TipoPromoPlanProdProcesar
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-06-2019
  */
  FUNCTION F_GET_TIPO_PROMO_PLAN_PROD(Fn_IdTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
  RETURN T_TipoPromoPlanProdProcesar;

  /**
  * Documentación para PROCEDURE 'P_GET_SERV_PROMO_PLAN_PROD'.
  * Procedimiento que verifica que los Planes y/o Productos definidos por Tipo Promocional se encuentren como servicios en el Punto Cliente
  * para poder otorgar la promoción.
  * Si se trata de PROM_MIX: Verifico que todos los planes y productos del MIX se encuentren como servicios en el Punto Cliente,
  * Si se trata de PROM_MPLA, PROM_MPRO, PROM_BW : Verifico que al menos 1 Plan o producto de la Promoción se encuentre como servicio del Punto
  * Si se trata de PROM_TOT, PROM_INS: Debo asignar todos los servicios a Procesar como servicios que cumplen la Promoción.
  * Si no se cumple se debe enviar boolean que No Cumple Promo y la tabla de servicios que cumplen Promo vacia.
  *
  * @Param Pa_ServiciosProcesar         IN T_ServiciosProcesar Tabla de servicios Activos por Punto Cliente.
  * @Param Pv_CodigoTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE Código del Tipo promocional
  * @Param Pa_TipoPromoPlanProdProcesar IN T_TipoPromoPlanProdProcesar, Tabla de Planes y Productos por Tipo Promocional
  * @Param Pb_CumplePromo               OUT BOOLEAN devuelve si se cumple o no que los planes y/o productos de una Promoción se encuentran 
  *                                     en los servicios del Punto Cliente.
  * @Param Pa_ServiciosCumplePromo      OUT T_ServiciosProcesar devuelve tabla de servicios del punto cliente que cumplen el tipo promocional.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 27-06-2019
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.1 26-01-2022 - Se realiza la compración de los planes por la característica line profile para las promociones de ancho de banda.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 15-11-2022 - Se elimina el llenado de Pa_ServiciosCumplePromo(Ln_Ind).PLAN_ID_SUPERIOR para promociones MIX motivo que este valor
  *                           solo se usa para promociones de tipo PROM_BW.
  *
  */ 
  PROCEDURE P_GET_SERV_PROMO_PLAN_PROD(Pa_ServiciosProcesar         IN T_ServiciosProcesar,
                                       Pv_CodigoTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pa_TipoPromoPlanProdProcesar IN T_TipoPromoPlanProdProcesar, 
                                       Pb_CumplePromo               OUT BOOLEAN,
                                       Pa_ServiciosCumplePromo      OUT T_ServiciosProcesar);
  /**
  * Documentación para PROCEDURE 'P_INSERT_INFO_DET_MAPEO_HISTO'.
  *
  * Procedimiento que Inserta registro de Historial en la tabla INFO_DETALLE_MAPEO_HISTO
  *
  * PARAMETROS:
  * @Param Pr_InfoDetalleMapeoHisto  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE
  * @Param Pv_MsjResultado           OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-06-2019
  */
  PROCEDURE P_INSERT_INFO_DET_MAPEO_HISTO(Pr_InfoDetalleMapeoHisto  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE,
                                          Pv_MsjResultado           OUT VARCHAR2);

 /**
  * Documentación para PROCEDURE 'P_INSERT_INFO_DET_MAPEO_PROMO'.
  *
  * Procedimiento que Inserta registro en la tabla de mapeo de promociones INFO_DETALLE_MAPEO_PROMO
  *
  * PARAMETROS:
  * @Param Pr_InfoDetalleMapeoPromo  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE
  * @Param Pv_MsjResultado           OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-06-2019
  */
  PROCEDURE P_INSERT_INFO_DET_MAPEO_PROMO(Pr_InfoDetalleMapeoPromo  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                                          Pv_MsjResultado           OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_INSERT_INFO_DET_MAPEO_SOLIC'.
  *
  * Procedimiento que Inserta registro en la tabla de mapeo de solicitudes y promociones generadas INFO_DETALLE_MAPEO_SOLICITUD
  *
  * PARAMETROS:
  * @Param Pr_InfoDetalleMapeoSolicitud  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE
  * @Param Pv_MsjResultado               OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-06-2019
  */
  PROCEDURE P_INSERT_INFO_DET_MAPEO_SOLIC(Pr_InfoDetalleMapeoSolicitud  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE,
                                          Pv_MsjResultado               OUT VARCHAR2);

 /**
  * Documentación para TYPE 'Lr_RegistrosMapeados'.
  *  
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 09-07-2019
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1 16-09-2019 - Se agrega la columna 'PUNTO_ID', 'PLAN_ID', 'GRUPO_PROMOCION'
  */
  TYPE Lr_RegistrosMapeados IS RECORD (
    ID_MAPEO_SOLICITUD     DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.ID_MAPEO_SOLICITUD%TYPE,
    SERVICIO_ID            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    TIPO_PROMOCION         DB_COMERCIAL.ADMI_TIPO_PROMOCION.TIPO%TYPE,
    PORCENTAJE             DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PORCENTAJE%TYPE,
    ID_DETALLE_MAPEO       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
    PUNTO_ID               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    PLAN_ID                DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    GRUPO_PROMOCION        DB_COMERCIAL.ADMI_TIPO_PROMOCION.GRUPO_PROMOCION_ID%TYPE
  );

  /**
   * Documentación para TYPE 'T_RegistrosMapeados'.
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 19-06-2019
   */                     
  TYPE T_RegistrosMapeados IS TABLE OF Lr_RegistrosMapeados INDEX BY PLS_INTEGER;

  /**
   * Documentación para TYPE 'T_ServiciosMapear'.
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 19-06-2019
   */                     
  TYPE T_ServiciosMapear IS TABLE OF Lr_ServiciosProcesar INDEX BY PLS_INTEGER;

  /**
   * Documentación para P_MAPEO_PROMO_DEFINIDAS
   * Procedimiento principal para mapear promociones definidas.
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 11-06-2019
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.1 21-05-2021 - Se elimina doble mapeo para el ciclo 2 en activación por servicio y se agrega doble mapeo
   *                           para los servicios que realicen un cambio de plan sin importar el ciclo o día de ejecución.
   * 
   * @param Pr_Punto                 IN Lr_PtosClientesProcesar       Recibe la información del punto a procesar
   * @param Pa_ServiciosCumplePromo  IN T_ServiciosProcesar           Recibe la información de los servicios a procesar
   * @param Pr_GruposPromociones     IN Lr_GruposPromocionesProcesar  Recibe la información de la promoción a procesar
   * @param Pr_GrupoPromoRegla       IN Lr_GrupoPromoReglaProcesar    Recibe la información de las reglas de grupo a procesar
   * @param Pr_TiposPromociones      IN Lr_TiposPromocionesProcesar   Recibe la información del tipoPromo a procesar
   * @param Pr_TipoPromoRegla        IN Lr_TipoPromoReglaProcesar     Recibe la información de las reglas de tipoPromo a procesar
   * @param Pv_TipoProceso           IN VARCHAR2                      Recibe el tipo de proceso(NUEVO ó EXISTENTE)
   * @param Pv_Trama                 IN VARCHAR2                      Recibe la información de la Trama
   * @param Pv_MsjResultado          OUT VARCHAR2                      Devuelve mensaje si existe un error
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.2 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
   */    
  PROCEDURE P_MAPEO_PROMO_DEFINIDAS (Pr_Punto                 IN Lr_PtosClientesProcesar,
                                     Pa_ServiciosCumplePromo  IN T_ServiciosProcesar,
                                     Pr_GruposPromociones     IN Lr_GruposPromocionesProcesar,
                                     Pr_GrupoPromoRegla       IN Lr_GrupoPromoReglaProcesar,
                                     Pr_TiposPromociones      IN Lr_TiposPromocionesProcesar,
                                     Pr_TipoPromoRegla        IN Lr_TipoPromoReglaProcesar,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pv_Trama                 IN VARCHAR2,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL,
                                     Pv_MsjResultado          OUT VARCHAR2);
  /**
   * Documentación para P_INSERT_DETALLE
   * Procedimiento que inserta las promociones en las tablas de mapeo.
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 12-06-2019
   * 
   * @param Pr_InfoDetalleMapeoPromo   IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE   Recibe la información para el mapeo de la promoción
   * @param Pa_DetalleServiciosMapear  IN T_ServiciosMapear                               Recibe la información de los servicios a mapear
   * @param Pv_MsjResultado           OUT VARCHAR2                                        Devuelve mensaje si existe un error
   *
   * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
   * @version 1.1 21-11-2019- Se modifica que el proceso de mapeo mensual para las tablas:
   *                          INFO_DETALLE_MAPEO_HISTO, INFO_DETALLE_MAPEO_SOLICITUD en el campo FE_CREACION se guarden con la fecha
   *                          INFO_DETALLE_MAPEO_PROMO.FE_CREACION, generada.
   */    
  PROCEDURE P_INSERT_DETALLE(Pr_InfoDetalleMapeoPromo    IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                             Pa_DetalleServiciosMapear   IN T_ServiciosMapear,
                             Pv_MsjResultado            OUT VARCHAR2);

  /**
   * Documentación para P_GET_CICLO
   * Procedimiento que obtiene el ciclo del cliente.
   *
   * Costo Query C_GetPerRolCaractCiclo:6
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 17-06-2019
   * 
   * @param Pn_IdPersonaRol         IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE   Recibe el id de la tabla Info_Persona_Rol
   * @param Pv_CodigoCiclo         OUT DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE                         Devuelve el Código del Ciclo
   * @param Pd_FechaInicioCiclo    OUT DB_FINANCIERO.ADMI_CICLO.FE_INICIO                           Devuelve la Fecha de Inicio del Ciclo
   */ 
  PROCEDURE P_GET_CICLO(Pn_IdPersonaRol        IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                        Pv_CodigoCiclo        OUT  DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE,
                        Pd_FechaInicioCiclo   OUT  DB_FINANCIERO.ADMI_CICLO.FE_INICIO%TYPE);

  /**
   * Documentación para P_VALIDA_JERARQUIA_PROMOCION
   * Procedimiento que valida la jerarquía de una promoción, para poder ser mapeada
   * 
   * Costo Query C_ObtieneDetalleMapeo: 3
   * Costo Query C_ObtieneDetalleInvalidaPromo : 2 
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 25-06-2019
   * 
   * @param Pn_IdGrupoPromocion       IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE     Recibe la coordenada del punto
   * @param Pv_Tipo_Promocion         IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE   Recibe la coordenada del elemento
   * @param Pa_ServiciosCumplePromo   IN T_ServiciosProcesar                                           Recibe la información de los servicios 
   * @param Pt_ServiciosMapear       OUT T_ServiciosMapear                                             Devuelve los servicios a mapear
   * @param Pb_AplicaMapeo           OUT BOOLEAN                                                       Devuelve ('True' Si Aplica Mapeo o 'False' 
   *                                                                                                   No Aplica Mapeo)
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.1 13-11-2019 - Se agrega parametro de entrada Tipo Promoción al cursor C_ObtieneDetalleMapeo   
   */                   
  PROCEDURE P_VALIDA_JERARQUIA_PROMOCION(Pn_IdGrupoPromocion      IN  DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                         Pv_Tipo_Promocion        IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pa_ServiciosCumplePromo  IN  T_ServiciosProcesar,
                                         Pa_ServiciosMapear      OUT  T_ServiciosMapear,
                                         Pb_AplicaMapeo          OUT  BOOLEAN);

  /**
   * Documentación para FUNCTION 'F_VALIDA_PROMO_INDEFINIDA'.
   *
   * Función verifica que la promoción cumpla con la regla de Promoción Indefinida,la cual
   * devuelve como respuesta un valor de tipo Boolean True "Si es Indefinida" ó False "No es Indefinida".
   *
   * Costo Query C_Tiene_Promo_Indefinida: 5 
   *
   * PARAMETROS:
   * @Param Pn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE    Recibe el Id del Grupo Promoción
   * @Param Pv_Tipo_Promocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE  Recibe el Código de Tipo de Promoción
   * RETURN BOOLEAN
   *
   * @author Héctor Lozano <hlozano@telconet.ec>
   * @version 1.0 20-06-2019
   */
  FUNCTION F_VALIDA_PROMO_INDEFINIDA(Fn_IdGrupoPromocion  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                     Fv_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE) 
  RETURN BOOLEAN;

  /**
   * Documentación para PROCEDURE 'P_INSERT_INFO_SERVICIO_HISTO'.
   *
   * Procedimiento que inserta registro en la tabla de historial de servicio INFO_SERVICIO_HISTORIAL
   *
   * PARAMETROS:
   * @Param Pr_InfoServicioHisto     IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE  Recibe un registro con la información necesaria para ingresar
   * @Param Pv_MsjResultado         OUT  VARCHAR2                                      Devuelve un mensaje del resultado de ejecución
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 02-07-2019
   */
  PROCEDURE P_INSERT_INFO_SERVICIO_HISTO(Pr_InfoServicioHisto   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE,
                                         Pv_MsjResultado       OUT VARCHAR2);


  /**
   * Documentación para PROCEDURE 'P_INSERT_INFO_DETALLE_SOLICITUD'.
   *
   * Procedimiento que inserta registro en la solicitud INFO_DETALLE_SOLICITUD
   *
   * PARAMETROS:
   * @Param Pr_InfoDetalleSolicitud   IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE  Recibe un registro con la información necesaria para ingresar
   * @Param Pv_MsjResultado          OUT  VARCHAR2                                     Devuelve un mensaje del resultado de ejecución
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 08-07-2019
   */
  PROCEDURE P_INSERT_INFO_DET_SOLICITUD(Pr_InfoDetalleSolicitud   IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                        Pv_MsjResultado          OUT VARCHAR2);

  /**
   * Documentación para PROCEDURE 'P_INSERT_INFO_DETALLE_SOL_HIST'.
   *
   * Procedimiento que inserta registro en la solicitud INFO_DETALLE_SOL_HIST
   *
   * PARAMETROS:
   * @Param Pr_InfoDetalleSolHist     IN  DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE  Recibe un registro con la información necesaria para ingresar
   * @Param Pv_MsjResultado          OUT  VARCHAR2                                    Devuelve un mensaje del resultado de ejecución
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 08-07-2019
   */
  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
                                           Pv_MsjResultado        OUT VARCHAR2);

  /**
   * Documentación para PROCEDURE 'P_UPDATE_DET_MAP_SOLIC'.
   *
   * Procedimiento que actualiza un registro en la tabla de Info_Detalle_Mapeo_Solicitud
   *
   * PARAMETROS:
   * @Param Pr_InfoDetMapSolicitud     IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE  Recibe un registro con la información para actualizar
   * @Param Pv_MsjResultado           OUT  VARCHAR2                                           Devuelve un mensaje del resultado de ejecución
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 19-07-2019
   *
   * @author José Candelario<jcandelario@telconet.ec>
   * @version 1.1 06-02-2020 - Se modifica procedimiento para que la sentencia de Update sea dinámica debido a que los procesos de Aplica Promoción 
   * y Pierde Promoción consumen el mismo procedimiento y se genera lentitud en la base la utilizaión del NVL para segmentar la clausula Where.
   */
  PROCEDURE P_UPDATE_DET_MAP_SOLIC(Pr_InfoDetMapSolicitud  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE, 
                                   Pv_MsjResultado         OUT VARCHAR2);   

  /**
   * Documentación para PROCEDURE 'P_UPDATE_DETALLE_MAPEO_PROM'.
   *
   * Procedimiento que actualiza un registro en la tabla de Info_Detalle_Mapeo_Promo
   *
   * PARAMETROS:
   * @Param Pr_InfoDetalleMapeoPromo     IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE  Recibe un registro con la información para actualizar
   * @Param Pv_MsjResultado             OUT  VARCHAR2                                           Devuelve un mensaje del resultado de ejecución
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 19-07-2019
   */
  PROCEDURE P_UPDATE_DETALLE_MAPEO_PROM(Pr_InfoDetalleMapeoPromo  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                                        Pv_MsjResultado          OUT VARCHAR2);      

  /**
   * Documentación para PROCEDURE 'P_APLICA_PROMOCION'.
   *
   * Procedimiento que aplica la promoción insertando registros en las tablas de solicitud.
   *
   * Costo Query C_ObtieneServiciosMapeados:    1307
   * Costo Query C_ObtieneTipoSolicitud:        5 
   * Costo Query C_ObtieneMotivoSolicitud:      2
   *
   * PARAMETROS:
   * @Param Pv_CodEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Recibe el código de la Empresa
   * @Param Pv_TipoPromo    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
   * @Param Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL
   * @Param Pv_MsjResultado OUT VARCHAR2
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 08-07-2019
   *
   * Se agrega validación y proeso para que se generen las solicitudes de las promociones por instalación PROM_INS.
   * Costo Query C_ObtieneObservacionSolicitud: 4
   * Costo Query C_ObtieneDescripcionSolIns:    5
   * Costo Query C_ObtieneUsuarioSolicitud:     5
   * Costo Query C_ObtienePersonaEnpresaRol:    3
   * Costo Query C_ObtieneOrigenContrato:       4
   * Costo Query C_ObtieneCaracContrato:        4
   * Costo Query C_ValidaSolicitudesActivas:    2
   * Costo Query C_ObtieneNombrePlan:           2
   * Costo Query C_GetUltMillaServ:             5
   *   
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.1  14-09-2019  
   *
   * Costo Query C_ObtieneDias:                 3
   * Costo Query C_GetCicloProceso:             3
   * Costo Query  C_GetDiasRestar:              1
   *   
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.2  21-11-2019 - Se agrega parametro de entrada Pv_TipoProceso para obtener la fecha con la cual se debe 
   *                            evaluar el query principal C_ObtieneServiciosMapeados. 
   *
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.3 24-05-2020 - Se modifica query que obtiene mapeos para que se realice de forma dinámica y realizar validaciones
   * según si es cliente nuevo o existente, se valida que se apliquen las solicitudes de clientes de ciclo 2.
   *
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.4 21-07-2020 - Se  modifica query que obtiene mapeos para que cuando se ejecute por job de clientes Nuevos 
   * no considere a los clientes Existentes.
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.5 24-01-2022 - Se modifica el query que obtiene mapeos para que cuando se ejecute por JobDiarioCambioPrecio,
   *                           reste un día a la fecha de mapeo. 
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.6 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
   */
   PROCEDURE P_APLICA_PROMOCION(Pv_CodEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Pv_TipoPromo     IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                               Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                               Pv_TipoProceso   IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE DEFAULT NULL,
                               Pv_JobProceso    IN  VARCHAR2 DEFAULT NULL,
                               Pv_MsjResultado  OUT VARCHAR2);   
   /**
   * Documentación para FUNCTION 'F_OBTIENE_ESTADO_SERV'.
   *
   * Función que obtiene el estado del servicio".
   *
   * Costo Query C_ObtieneEstadoServ: 3
   *
   * PARAMETROS:
   * @Param Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE    Recibe el Id del Servicio
   * RETURN VARCHAR2
   *
   * @author Héctor Lozano <hlozano@telconet.ec>
   * @version 1.0 11-07-2019
   */
  FUNCTION F_OBTIENE_ESTADO_SERV(Fn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN VARCHAR2;

  /**
  *  Documentación para TYPE 'Lr_ClientesProcesar'.
  *
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE Lr_ClientesProcesar IS RECORD (
    ID_DETALLE_MAPEO        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
    GRUPO_PROMOCION_ID      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    TIPO_PROMOCION_ID       DB_COMERCIAL.ADMI_TIPO_PROMOCION.TIPO_PROMOCION_ID%TYPE,
    PERSONA_EMPRESA_ROL_ID  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    PUNTO_ID                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    TIPO_PROMOCION          DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    INDEFINIDO              VARCHAR2(1),
    FE_MAPEO                DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.FE_MAPEO%TYPE
  );

  /**
  * Documentación para TYPE 'T_ClientesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  */
  TYPE T_ClientesProcesar IS TABLE OF Lr_ClientesProcesar INDEX BY PLS_INTEGER;

  /**
  *  Documentación para TYPE 'Lr_ClientesMapeos'.
  *
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1  21-05-2020 - Se agrega parámetro NOMBRE_GRUPO.
  */
  TYPE Lr_ClientesMapeos IS RECORD (
    ID_DETALLE_MAPEO        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
    NOMBRE_GRUPO            DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
    GRUPO_PROMOCION_ID      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    TIPO_PROMOCION_ID       DB_COMERCIAL.ADMI_TIPO_PROMOCION.TIPO_PROMOCION_ID%TYPE,
    PERSONA_EMPRESA_ROL_ID  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    PUNTO_ID                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    TIPO_PROMOCION          DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    INDEFINIDO              VARCHAR2(1),
    FE_MAPEO                DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.FE_MAPEO%TYPE,
    SERVICIO_ID             DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  );
  /**
  * Documentación para TYPE 'T_ClientesMapeo'.
  * Record para almacenar la data enviada al BULK.
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  */
  TYPE T_ClientesMapeo IS TABLE OF Lr_ClientesMapeos INDEX BY PLS_INTEGER;

  /**
  * Documentación para PROCEDURE 'P_VALIDA_PROMO_PLAN_PROD'.
  *
  * Proceso encargado de validar que las servicios de planes y productos mapeados en la estructura INFO_DETALLE_MAPEO_SOLICITUD
  * sigan siendo servicios activos para punto mapeado en la estructura INFO_DETALLE_MAPEO_PROMO. El proceso devuelve un valor
  * de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica", adicional devuelve como parámetro un tabla con los servicios mapeados. 
  *
  * Costo del Query C_MapeoSolicitud: 4
  * Costo del Query C_ServiciosPunto: 4
  *
  * PARAMETROS:
  * @Param Pn_Id_Detalle_Mapeo     IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
  * @Param Pn_Id_Promocion         IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
  * @Param Pn_Id_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
  * @Param Pv_Tipo_Promocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param Pn_IntIdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pb_CumplePromo          OUT BOOLEAN,
  * @Param Pa_ServiciosMapeados    OUT T_ServiciosProcesar
  * @Param Pa_ServiciosProcesar    OUT T_ServiciosProcesar
  * @Param Pa_PierdeServiciosPromo OUT T_ServiciosProcesar
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 15-11-2019 - Se modifica cursores C_MapeoSolicitud y C_ServiciosPunto para considera el estado de la estructura info_servicio.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.2 21-05-2020 - Se agrega variable Booleana para controlar cuando se cumple con los estados del servicio parametrizados.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 07-03-2023 - Se agregan validacion por proyecto Ecuanet.  
  */
  
PROCEDURE P_VALIDA_PROMO_PLAN_PROD(Pn_Id_Detalle_Mapeo     IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
                                     Pn_Id_Promocion         IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                     Pn_Id_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                     Pv_Tipo_Promocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pn_IntIdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Pb_CumplePromo          OUT BOOLEAN,
                                     Pa_ServiciosMapeados    OUT T_ServiciosProcesar,
                                     Pa_ServiciosProcesar    OUT T_ServiciosProcesar,
                                     Pa_PierdeServiciosPromo OUT T_ServiciosProcesar,
                                     Pb_CumpleEstadoServ     OUT BOOLEAN);


  /**
  * Documentación para PROCEDURE 'P_EJECUTA_MAPEO_MENSUAL'.
  *
  * Proceso que evalua el día del ciclo con la fecha actual para ejecutar el proceso P_MAPEO_MENSUAL_POR_CICLO
  *
  * PARAMETROS:
  * @Param Pv_Empresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoPromo IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  *
  * Costo del Query C_GetCiclosDiaProceso: 2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1 21-05-2020 - Se agrega variable Booleana para controlar cuando se cumple con los estados del servicio parametrizados.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.2 07-01-2022 - Se modifica cursor C_GetCiclosDiaProceso y se agrega que el proceso se ejecute el dia de inicio de ciclo de Facturación
  *                           para ciclo1 y ciclo2.
  *
  */
  PROCEDURE P_EJECUTA_MAPEO_MENSUAL (Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoPromo   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE);

  /**
  * Documentación para PROCEDURE 'P_MAPEO_MENSUAL_POR_CICLO'.
  *
  * Proceso de ejecución masiva para evaluar mensualmente la reglas de una promoción que actualmente están mapeadas
  * para un cliente en la estructura INFO_DETALLE_MAPEO_PROMO. Si el cliente cumple con las reglas el proceso debe
  * generar el siguiente mapeo con estado 'Activo', caso contrario debe generar un mapeo con estado 'Eliminado' o 'Baja'
  *
  * PARAMETROS:
  * @Param Pv_Empresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoPromo IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pn_IdCiclo   IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE
  *
  * Costo del Query C_ClientesMapeo: 78
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 15-11-2019 - Se modifica cursor C_ClientesMapeo para considera el estado de la estructura info_servicio.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 05-01-2023 - Se modifica proceso se agrega llamado a proceso de actualización de solicitudes en caso de perdida
  *                           de promociones.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  *
  */
  PROCEDURE P_MAPEO_MENSUAL_POR_CICLO (Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoPromo   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pn_IdCiclo     IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE);

  /**
  * Documentación para PROCEDURE 'P_MAPEO_PROMO_MENSUAL'.
  *
  * Proceso que evalua la reglas de una promoción que actualmente están mapeadas para un cliente en la estructura 
  * INFO_DETALLE_MAPEO_PROMO. Si el cliente cumple con las reglas el proceso debe generar el siguiente mapeo con
  * estado 'Activo', caso contrario debe generar un mapeo con estado 'Eliminado' o 'Baja'
  *
  * Costo del Query C_ClienteMapeo: 2
  * Costo del Query C_GetCantMapPeriodoUno: 2
  * Costo del Query C_GetCantMapCicloEsp: 2
  *
  * PARAMETROS:
  * @Param Pr_Punto                IN Lr_PtosClientesProcesar DEFAULT NULL
  * @Param Pa_ServiciosCumplePromo IN T_ServiciosProcesar
  * @Param Pr_GruposPromociones    IN Lr_GruposPromocionesProcesar DEFAULT NULL
  * @Param Pr_GrupoPromoRegla      IN Lr_GrupoPromoReglaProcesar DEFAULT NULL
  * @Param Pr_TiposPromociones     IN Lr_TiposPromocionesProcesar DEFAULT NULL
  * @Param Pr_TipoPromoRegla       IN Lr_TipoPromoReglaProcesar DEFAULT NULL
  * @Param Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL
  * @Param Pv_Trama                IN VARCHAR2 DEFAULT NULL
  * @Param Prf_AdmiTipoPromoRegla  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE DEFAULT NULL
  * @Param Pv_MsjResultado         OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  *
  * Se modifica proceso por motivo de los nuevos párametros que se agregaron a la función F_VALIDA_SECTORIZACION.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 27-09-2019
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.2 21-11-2019- Se modifica que el proceso de mapeo mensual para TipoProceso: EXISTENTE, lea del parametro
  *                          Nombre_parametro: PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE
  *                          Descripcion: NUMERO_DIAS_FECHA_PROCESA_ALCANCE,
  *                          el numero de días a restar a la fecha de creación del mapeo Promocional y a la fecha usada para el calculo
  *                          de la fecha de mapeo y fecha de siguiente mapeo.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 21-05-2021 - Se elimina doble mapeo para el ciclo 2 en activación por servicio y se agrega doble mapeo
  *                           para los servicios que realicen un cambio de plan sin importar el ciclo o día de ejecución.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.2 24-01-2022 - Se detecta Bug en el proceso de calculo en la fecha_siguiente_mapeo el cual genera erroneamente un salto en los meses
  *                           calculados, se realizan correcciones y validaciones al proceso. Se agregan Logs al proceso P_MAPEO_PROMO_MENSUAL, con
  *                           el fin de monitorear el proceso.
  *
  * @authorJosé Candelario <jcandelario@telconet.ec>
  * @version 1.3 16-08-2022 - Se detecta Bug en el proceso de calculo en la fecha_siguiente_mapeo el cual genera erroneamente un salto en los meses
  *                           calculados en el segundo periodo, se realizan correcciones en el cursor GetCantMapCicloEsp y se elimina la variable 
  *                           Ln_CantidadPeriodos en las validaciones del proceso.
  *
  * @authorJosé Candelario <jcandelario@telconet.ec>
  * @version 1.4 11-11-2022 - Se da de baja el cursor C_GetCantMapPeriodoUno y se modifica los cursores C_GetCantMapCicloEsp, C_ClienteMapeo por problemas de salto fechas en el campo 
  *                           siguiente mapeo.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_MAPEO_PROMO_MENSUAL (Pr_Punto                IN Lr_PtosClientesProcesar DEFAULT NULL,
                                   Pa_ServiciosCumplePromo IN T_ServiciosProcesar,
                                   Pr_GruposPromociones    IN Lr_GruposPromocionesProcesar DEFAULT NULL,
                                   Pr_GrupoPromoRegla      IN Lr_GrupoPromoReglaProcesar DEFAULT NULL,
                                   Pr_TiposPromociones     IN Lr_TiposPromocionesProcesar DEFAULT NULL,
                                   Pr_TipoPromoRegla       IN Lr_TipoPromoReglaProcesar DEFAULT NULL,
                                   Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL,
                                   Pv_Trama                IN VARCHAR2 DEFAULT NULL,
                                   Prf_AdmiTipoPromoRegla  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE DEFAULT NULL,
                                   Pv_MsjResultado         OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_INSERTA_HIST_SERVICIO'.
  *
  * Proceso que inserta el historial de un servicio.
  *
  * PARAMETROS:
  * @Param Pa_ServiciosPromo   IN T_ServiciosProcesar
  * @Param Pv_Observacion      IN VARCHAR2
  * @Param Pv_MsjResultado     OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  */
  PROCEDURE P_INSERTA_HIST_SERVICIO (Pa_ServiciosPromo IN T_ServiciosProcesar,
                                     Pv_Observacion    IN VARCHAR2,
                                     Pv_MsjResultado   OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_OBTIENE_GRUPOS_PROC_PIERDE'.
  *
  * Procedimiento que obtiene los grupos parametrizados por banco_tipo_cuenta_id y por ciclo de facturación para filtrar los clientes
  * para el procesamiento de Perdidas de Promociones de Mensualidad
  *
  * Costo Query C_GruposEjecucion:6
  *
  * PARAMETROS:
  * @Param Pv_Empresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param Pv_TipoPromo IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-02-2020
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1 05-06-2020 - Se envía el tipo de proceso para segmenar la data.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_OBTIENE_GRUPOS_PROC_PIERDE(Pv_Empresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoPromo IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_TipoProceso IN VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_PIERDE_PROMO_MAPEO'.
  *
  * Proceso de ejecución masiva para evaluar mensualmente la reglas de una promoción que actualmente están mapeadas
  * para un cliente en la estructura INFO_DETALLE_MAPEO_PROMO.
  *
  * Costo del Query C_ServicioActivo: 16
  * Costo del Query C_ClientesMapeo: 69
  * Costo del Query C_TipoPromocion: 1
  * Costo del Query C_Id_Detalle_Mapeo: 2
  *
  * PARAMETROS:
  * @Param Pv_Empresa                IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoPromo              IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_FormaPago              IN VARCHAR2 DEFAULT NULL Descripcion de la forma de pago,
  * @Param Pn_IdCiclo                IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL Id del ciclo de Facturación,
  * @Param Pv_IdsFormasPagoEmisores  IN VARCHAR2 DEFAULT NULL Contiene Ids de Formas de Pagos o de emisores (Banco_tipo_cuenta_id) separados por coma.
  * Pv_TipoProceso                   IN VARCHAR2,
  * Pn_IdPunto                       IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL 
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  *
  * Se agrega al proceso un parámetro de entrada por tipo de promoción, se agregan validaciones para el tipo de promoción
  * por instalación.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 27-09-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 15-11-2019 - Se modifica cursor C_ServicioActivo para considera el estado de la estructura info_servicio.
  * 
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.3 06-02-2020 - Se modifica para que el Procesamiento de las Perdidas Promocionales se realice por grupos parametrizados por
  *                           banco_tipo_cuenta_id y por ciclo de facturación.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.4 18-05-2020 - Se modifica para que se obtenga la data de los mapeos con fecha del día anterior.
  *
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.5 21-05-2020 - Se obtiene nombre de la promoción que perdió el cliente para guardar en el log de mapeo y de servicio historial
  * Se modifica validación de estados de servicios para obtener el mensaje de pérdida, se envía el tipo de proceso para segmenar la data.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.6 04-09-2020 - Se agrega variable IdPunto para realizar la pérdida de promociones individual.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.7 10-11-2020 - Se realizan cambios para una mejor invocación del proceso F_VALIDA_TIPO_NEGOCIO
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.8 05-01-2023 - Se modifica proceso se agrega llamado a proceso de actualización de solicitudes en caso de perdida
  *                           de promociones.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.9 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_PIERDE_PROMO_MAPEO (Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_TipoPromo             IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                  Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                  Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                  Pv_TipoProceso           IN VARCHAR2 DEFAULT NULL,
                                  Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL);

  /**
  * Documentación para FUNCTION 'F_VALIDA_SERVICIO'.
  *
  * Función que verifica si el servicio de un punto tiene una promoción en vigencia, devuelve como respuesta
  * un valor de tipo VARCHAR2 "S -> No tiene una promoción vigente" ó "N -> Si tiene una promoción vigente".
  *
  * Costo del Query que valida si el servicio tiene una promoción definida ó indefinida: 1
  * Costo del Query que valida si el servicio tiene una promoción vigente definida ó indefinida: 1
  *
  * PARAMETROS:
  * @Param Fn_IntIdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Fv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-06-2019
  */  
  FUNCTION F_VALIDA_SERVICIO(Fn_IntIdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                             Fv_TipoPromocion IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                             Fv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2;


     /**
  * Documentación para FUNCTION 'F_OBTIENE_PERIODOS'.
  *
  * Función que obtiene la cantidad de periodos configurados en la promocion , devuelve como respuesta
  * un valor de tipo NUMBER con la cantidad de periodos.
  *
  * PARAMETROS:
  * @Param Fv_TipoPromocion   IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE
  * @Param Fv_IdPromocion     IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
  * @Param Fv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 20-09-2019
  */  
  FUNCTION F_OBTIENE_PERIODOS(Fv_TipoPromocion IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                               Fv_IdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2;


  /**
  * Documentación para PROCEDURE 'P_GET_PROMOCIONES_SECT'.
  *
  * Proceso que realiza una evaluación de la sectorización ya sea del punto o servicio contra la sectorización de las
  * promociones, se realiza una evaluación por prioridad configurada, como variables de salida el proceso puede devolver
  * información en las tablas Pa_PromocionesPrioridad ó Pa_TiposPromoPrioridad dependiendo del Pv_TipoEvaluacion enviado.
  *
  * PARAMETROS:
  * @Param Pd_FeEvaluaVigencia     IN DATE (fecha con la que obtiene las promociones en su rango de vigencia)
  * @Param Pn_IdPunto              IN NUMBER DEFAULT NULL (id punto del cliente)
  * @Param Pn_IdServicio           IN NUMBER DEFAULT NULL (id servicio de internet)
  * @Param Pn_IdPromocion          IN NUMBER DEFAULT NULL (id de una promoción especifica)
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE (Grupo de la promoción MENS, INS, BW)
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (código de empresa)
  * @Param Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL (tipo de proceso a evaluar 'Nuevo', 'Existente', 'UpGrade' , etc)
  * @Param Pv_TipoEvaluacion       IN VARCHAR2 DEFAULT NULL (se lo utiliza para las evaluaciones de promociones tentativas)
  * @Param Pa_PromocionesPrioridad OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar (tabla de la promociones ordenadas por prioridad
                                                                                                  de sectorización)
  * @Param Pa_TiposPromoPrioridad  OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar (tabla de los tipos de promociones ordenadas por 
                                                                                                 prioridad de sectorización)
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-09-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 10-11-2020 - Se declara como default null el valor de entrada Pd_FeEvaluaVigencia para no sea considerado en la evaluación de 
  *                           promociones por código.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 28-02-2023 - Se agrega sentencia empresa_cod en cursor C_GetPrioridadSect, C_SevicioPunto.
  */
  PROCEDURE P_GET_PROMOCIONES_SECT(Pd_FeEvaluaVigencia     IN DATE DEFAULT NULL,
                                   Pn_IdPunto              IN NUMBER DEFAULT NULL,
                                   Pn_IdServicio           IN NUMBER DEFAULT NULL,
                                   Pn_IdPromocion          IN NUMBER DEFAULT NULL,
                                   Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL,
                                   Pv_TipoEvaluacion       IN VARCHAR2 DEFAULT NULL,
                                   Pa_PromocionesPrioridad OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar,
                                   Pa_TiposPromoPrioridad  OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar);

 /**
  * Documentación para FUNCTION 'F_OBTIENE_TIPO_CAMBIO_PLAN'.
  *
  * Función que obtiene el tipo de cambio de plan realizado en el cliente, ya sea Upgrade o Downgrade.
  *
  * PARAMETROS:
  * @Param Fn_IntIdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Fv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 19-08-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 21-05-2021 - Se parametrizan valores para obtener el cambio de precio desde la observación del historial 
  *                           del servicio.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.2 01-12-2021 - -Se modifica funcion y se eliminan los cursores : C_GetPrecioAnterior, C_GetPrecioNuevo debido a que retorna de forma
  *                            incorrecta el tipo de cambio de plan, se crea nuevo cursor C_GetPrecioAnteriorNuevo CostoQuery: 8, que devuelve de 
  *                            forma correcta el precio anterior y el precio nuevo del servicio por el cambio de plan realizado.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 16-12-2022 - Se cambia condición en cursores que valide un cambio de plan entre dos días y evitar que los sevicios se queden sin
  *                           promoción.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 23-03-2023 - Se quitan en los querys el CASTEO a los campos de tipo DATE.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.5 02-03-2023 - Se agrega filtro codEmpresa en los querys que utilizan las estructuras de parametros.
  *
  */  
  FUNCTION F_OBTIENE_TIPO_CAMBIO_PLAN(Fn_IntIdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoEjecucion IN VARCHAR2)
    RETURN VARCHAR2; 
    
    
  /**
  * Documentación para PROCEDURE 'P_MAPEO_CAMBIO_PLAN'.
  *
  * Procedimiento que realiza el mapeo de cambio de plan  de los clientes Existentes.
  *
  * PARAMETROS:
  * @Param  Pv_TipoPromo             IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE, 
  * @Param  Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  * @Param  Pn_IdServicio            IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
  * @Param  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param  Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param  Pv_TipoProceso           IN VARCHAR2
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 24-08-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 10-11-2020 Se agrega el valor de entrada Pn_IdPromocion para las evaluaciones de la promociones por código.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 25-05-2021 Se agrega un rango de dos días en el cursor principal para obtener si se realizó un cambio de precio.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 05-01-2023 Se agrega logs para seguimiento de servicios en el proceso.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_MAPEO_CAMBIO_PLAN ( Pr_Punto                 IN Lr_PtosClientesProcesar DEFAULT NULL,
                                  Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_TipoProceso           IN VARCHAR2,
                                  Pv_TipoEjecucion         IN VARCHAR2,
                                  Pn_IdPromocion           IN NUMBER DEFAULT NULL);  
    
    /**
  * Documentación para PROCEDURE 'P_MAPEO_CAMBIO_PRECIO'.
  *
  * Procedimiento que realiza el mapeo de cambio de plan por cambio de precio de los clientes Existentes.
  *
  * PARAMETROS:
  * @Param  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param  Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 21-09-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 25-05-2021 Se agrega un rango de dos días en el cursor principal para obtener si se realizó un cambio de precio.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.3 22-04-2022 Se agrega cursor C_GetServiciosCambioPlan para obtener los servicios que realizaron Cambio de Plan, los cuales ya poseen un mapeo
  *                         para luego invocar al proceso P_APLICA_PROMOCION y realizar la aplicación de la promoción correspondiente. 
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 16-12-2022 Se unifican los cursores para que todos los cambios de plan sean evaluados para aplicar promociones.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.5 28-10-2022 Se modifica cursores C_GetServiciosCambioPlan, C_GetServiciosCambioPrecio para obtener los servicios que realizaron
  *                         Cambio de Plan y Cambio de Precio, los cuales poseen un mapeo (Se obtiene el mínimo mapeo) para luego invocar al proceso
  *                         P_APLICA_PROMOCION y realizar la aplicación de la promoción correspondiente. 
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.6 17-03-2023 Se agrega valor límite caracteres en SUBSTR al obtener observación del historial de servicio en cursor C_GetServiciosCambioPrecio.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.7 23-03-2023 Se quitan en los querys los CASTEO en los campos de tipo DATE.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.8 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  *
  */
  PROCEDURE P_MAPEO_CAMBIO_PRECIO(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_TipoProceso           IN VARCHAR2,
                                  Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE);      
    
  /**
  * Documentación para PROCEDURE 'P_MAPEO_CAMBIO_PLAN_INDIVIDUAL'.
  *
  * Procedimiento que realiza el mapeo de cambio de plan individual de los clientes Existentes.
  *
  * PARAMETROS:
  * @Param  Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
  * @Param  Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
  * @Param  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param  Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param  Pv_TipoProceso           IN VARCHAR2
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 01-09-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 10-11-2020 Se agrega valor de entrada Pv_EsCodigo para diferenciar el tipo de procesamiento cuando sea una
  *                         evaluación por código.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 10-11-2020 Se agrega a la función F_OBTIENE_ESTADO_PROMOCION si devuelve un estado Finalizado y aún tiene una
  *                         promoción vigente se debe llamar al proceso P_PIERDE_PROMO_EXISTENTE.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 17-03-2023 Se cambio el tipo de dato de la variable Lv_Consulta.
  *
  */
  PROCEDURE P_MAPEO_CAMBIO_PLAN_INDIVIDUAL(Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                           Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                           Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                           Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_TipoProceso           IN VARCHAR2,
                                           Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL,
                                           Pv_Status                OUT VARCHAR2,
                                           Pv_MsjError              OUT VARCHAR2);  

  /**
  * Documentación para PROCEDURE 'P_CAMBIO_PLAN_INDIVIDUAL'.
  *
  * Procedimiento que realiza el mapeo de cambio de plan individual de los clientes Existentes.
  *
  * PARAMETROS:
  * @Param  Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
  * @Param  Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
  * @Param  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param  Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param  Pv_TipoProceso           IN VARCHAR2,
  * @Param  Pv_CodigoMens            IN VARCHAR2 DEFAULT NULL,
  * @Param  Pv_IdTipoPromocion      IN VARCHAR2 DEFAULT NULL,
  * @Param  Pv_Status                OUT VARCHAR2,
  * @Param  Pv_MsjError              OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 10-11-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_CAMBIO_PLAN_INDIVIDUAL(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoProceso          IN VARCHAR2,
                                     Pv_CodigoMens           IN VARCHAR2 DEFAULT NULL,
                                     Pv_IdTipoPromocion      IN VARCHAR2 DEFAULT NULL,
                                     Pv_Status               OUT VARCHAR2,
                                     Pv_MsjError             OUT VARCHAR2);

  /**
  *  Documentación para TYPE 'Lr_ServiciosPromCodigo'.
  *  
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 30-10-2020
  */      
  TYPE Lr_ServiciosPromCodigo IS RECORD (
    ID_SERVICIO            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,    
    ID_PLAN                DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ID_PRODUCTO            DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    PLAN_ID_SUPERIOR       DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_GRUPO_PROMOCION     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    ID_CARACTERISTICA      DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
    TIPO_PROMOCION         DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    ID_TIPO_PROMOCION      DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE); 

  /**
  * Documentación para TYPE 'T_ServiciosPromCodigo'.  
  * 
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 30-10-2020
  */
  TYPE T_ServiciosPromCodigo IS TABLE OF Lr_ServiciosPromCodigo INDEX BY PLS_INTEGER;

  /**
  * Documentación para PROCEDURE 'P_SERVICIOS_PROM_CODIGO'.
  *
  * Procedimiento que consulta los servicios que tienen como caracteríticas activa de un código promocional.
  *
  * PARAMETROS:
  * @Param  Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  * @Param  Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param  Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param  Pv_TipoProceso          IN VARCHAR2,
  * @Param  Pv_EstadoServicio       IN VARCHAR2,
  * @Param  Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosPromCodigo
  *
  * Costo Query C_HoraJobCliNuev: 3
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 10-11-2020
  */
  PROCEDURE P_SERVICIOS_PROM_CODIGO(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                    Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_TipoProceso          IN VARCHAR2,
                                    Pv_EstadoServicio       IN VARCHAR2,
                                    Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosPromCodigo);

  /**
  * Documentación para PROCEDURE 'P_PROMOCIONES_POR_CODIGO'.
  *
  * Procedimiento que realiza las evaluaciones de reglas de una promoción por código contra los datos de un servicio.
  *
  * PARAMETROS:
  * @Param  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param  Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param  Pv_TipoProceso           IN VARCHAR2,
  * @Param  Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
  * @Param  Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
  * @Param  Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 10-11-2020
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 17-03-2023 - Se cambio tipo de dato a la variable Lv_Consulta.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
  PROCEDURE P_PROMOCIONES_POR_CODIGO(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                     Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                     Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL);

  /**
  *  Documentación para TYPE 'Lr_ServiciosProcesarTras'.
  *  
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 05-04-2022
  */      
  TYPE Lr_ServiciosProcesarTras IS RECORD (
    ID_SERVICIO            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,    
    ID_PLAN                DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ID_PRODUCTO            DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    PLAN_ID_SUPERIOR       DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_SERVICIO_ORIG       DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_DETALLE_SOLICITUD   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE
  ); 
  
  /**
   * Documentación para TYPE 'T_ServiciosMapearTras'.
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.0 05-04-2022
   */                     
  TYPE T_ServiciosMapearTras IS TABLE OF Lr_ServiciosProcesarTras INDEX BY PLS_INTEGER;
  
  /**
  *  Documentación para TYPE 'Lr_ClientesMapeosTras'.
  *
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 01-04-2022
  */
  TYPE Lr_ClientesMapeosTras IS RECORD (
    ID_DETALLE_MAPEO        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
    NOMBRE_GRUPO            DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
    GRUPO_PROMOCION_ID      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    TIPO_PROMOCION_ID       DB_COMERCIAL.ADMI_TIPO_PROMOCION.TIPO_PROMOCION_ID%TYPE,
    PERSONA_EMPRESA_ROL_ID  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    PUNTO_ID                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    TIPO_PROMOCION          DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
    INDEFINIDO              VARCHAR2(1),
    FE_MAPEO                DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.FE_MAPEO%TYPE,
    TRAMA                   VARCHAR2(4000),
    PERIODO                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PERIODO%TYPE,
    FE_SIGUIENTE_MAPEO      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.FE_SIGUIENTE_MAPEO%TYPE,
    CANTIDAD_PERIODOS       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.CANTIDAD_PERIODOS%TYPE,
    MAPEOS_GENERADOS        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.MAPEOS_GENERADOS%TYPE,
    PORCENTAJE              DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PORCENTAJE%TYPE,
    TIPO_PROCESO            DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE,
    INVALIDA                DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.INVALIDA%TYPE,
    ESTADO                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE,
    SERVICIO_ID             DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  );
  /**
  * Documentación para TYPE 'T_ClientesMapeoTras'.
  * Record para almacenar la data enviada al BULK.
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 01-04-2022
  */
  TYPE T_ClientesMapeoTras IS TABLE OF Lr_ClientesMapeosTras INDEX BY PLS_INTEGER;

  /**
   * Documentación para P_INSERT_DETALLE_TRASLADO
   * Procedimiento que inserta las promociones en las tablas de mapeo.
   * 
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.0 07-04-2022
   * 
   * @param Pr_InfoDetalleMapeoPromo   IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE   Recibe la información para el mapeo de la promoción
   * @param Pa_DetalleServiciosMapear  IN T_ServiciosMapearTras                           Recibe la información de los servicios a mapear
   * @param Pv_MsjResultado            OUT VARCHAR2                                       Devuelve mensaje si existe un error
   */ 
  PROCEDURE P_INSERT_DETALLE_TRASLADO( Pr_InfoDetalleMapeoPromo    IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                                       Pa_DetalleServiciosMapear   IN T_ServiciosMapearTras,
                                       Pv_MsjResultado             OUT VARCHAR2);


  /**
  * Documentación para PROCEDURE 'P_VALIDA_PROM_TRASLADO'.
  *
  * Proceso encargado de validar que las servicios de planes y productos mapeados en la estructura INFO_DETALLE_MAPEO_SOLICITUD
  * sean servicios trasladados y que se encuentren activos para el punto validado en la estructura INFO_DETALLE_MAPEO_PROMO. El proceso devuelve un valor
  * de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica", adicional devuelve como parámetro un tabla con los servicios mapeados. 
  *
  * Costo del Query C_MapeoSolicitud: 4
  * Costo del Query C_ServiciosPunto: 4
  *
  * PARAMETROS:
  * @Param Pn_Id_Detalle_Mapeo     IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
  * @Param Pn_Id_Promocion         IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
  * @Param Pn_Id_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
  * @Param Pv_Tipo_Promocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param Pn_IntIdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pb_CumplePromo          OUT BOOLEAN,
  * @Param Pa_ServiciosMapeados    OUT T_ServiciosProcesar
  * @Param Pa_ServiciosProcesar    OUT T_ServiciosProcesar
  * @Param Pa_PierdeServiciosPromo OUT T_ServiciosProcesar
  * @Param Pb_CumpleEstadoServ     OUT BOOLEAN
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 07-04-2022
  */
  PROCEDURE P_VALIDA_PROM_TRASLADO(Pn_Id_Detalle_Mapeo     IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
                                     Pn_Id_Promocion         IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                     Pn_Id_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                     Pv_Tipo_Promocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pn_IntIdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Pb_CumplePromo          OUT BOOLEAN,
                                     Pa_ServiciosMapeados    OUT T_ServiciosProcesar,
                                     Pa_ServiciosProcesar    OUT T_ServiciosProcesar,
                                     Pa_PierdeServiciosPromo OUT T_ServiciosProcesar,
                                     Pb_CumpleEstadoServ     OUT BOOLEAN);


  /**
  * Documentación para PROCEDURE 'P_TRASLADA_PROMO_MAPEO'.
  *
  * Proceso de ejecución individual para evaluar las promociones y reglas de una promoción que actualmente están mapeadas
  * para un cliente en la estructura INFO_DETALLE_MAPEO_PROMO.
  *
  * Costo del Query C_ServicioActivo: 16
  * Costo del Query C_ClientesMapeo: 69
  * Costo del Query C_TipoPromocion: 1
  * Costo del Query C_Id_Detalle_Mapeo: 2
  *
  * PARAMETROS:
  * @Param Pv_Empresa                IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoPromo              IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * Param  Pn_IdPunto                IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL 
  * Param  Pn_IdPuntoDestino         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL 
  * Param  Pv_RespuestaProceso       IN VARCHAR2 
  * Param  Pv_TrasladoPromo          IN VARCHAR2
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 07-04-2022
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 09-05-2023 - Se migra toda la lógica al proceso P_PROMO_MAPEO_TRASLADO.
  */
    PROCEDURE P_TRASLADA_PROMO_MAPEO (Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                      Pn_IdPuntoDestino        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                      Pv_RespuestaProceso      OUT VARCHAR2,
                                      Pv_TrasladoPromo         OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_PROMO_MAPEO_TRASLADO'.
  *
  * Proceso de ejecución individual para evaluar las promociones y reglas de una promoción que actualmente están mapeadas
  * para un cliente en la estructura INFO_DETALLE_MAPEO_PROMO.
  *
  * Costo del Query C_ServicioActivo: 16
  * Costo del Query C_ClientesMapeo: 69
  * Costo del Query C_TipoPromocion: 1
  * Costo del Query C_Id_Detalle_Mapeo: 2
  *
  * PARAMETROS:
  * @Param Pv_Empresa                IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoPromo              IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * Param  Pn_IdPunto                IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL
  * Param  Pn_IdServicio             IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL
  * Param  Pv_Estado                 IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE DEFAULT NULL
  * Param  Pn_IdPuntoDestino         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL 
  * Param  Pv_RespuestaProceso       IN VARCHAR2 
  * Param  Pv_TrasladoPromo          IN VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 09-05-2023
  */                                 
  PROCEDURE P_PROMO_MAPEO_TRASLADO (Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                    Pv_Estado                IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE DEFAULT NULL,
                                    Pn_IdPuntoDestino        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pv_RespuestaProceso      OUT VARCHAR2,
                                    Pv_TrasladoPromo         OUT VARCHAR2);
                                    
  /**
  * Documentación para PROCEDURE 'P_PIERDE_PROMO_EXISTENTE'.
  *
  * Proceso que obtiene el último mapeo de una promoción existente para validar las reglas promocionales y proceder a dar de baja
  * la promoción.
  *
  * Costo del Query C_ServicioMapeo: 3
  *
  * PARAMETROS:
  * @Param Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * Param  Pv_TipoPromo   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-01-2023
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */
    PROCEDURE P_PIERDE_PROMO_EXISTENTE (Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                        Pv_TipoPromo   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE);

  /**
  * Documentación para PROCEDURE 'P_MAPEO_APLICA_PROMO_NUEVOS'.
  *
  * Se migra la lógica de los job de mapeo y aplica promoción de Clientes Nuevos.
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoProceso          IN VARCHAR2
  * @Param Pv_Alcance              IN VARCHAR2 DEFAULT NULL
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 17-03-2023
  */
  PROCEDURE P_MAPEO_APLICA_PROMO_NUEVOS(Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoProceso          IN VARCHAR2,
                                        Pv_Alcance              IN VARCHAR2 DEFAULT NULL);
                                        
END CMKG_PROMOCIONES;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PROMOCIONES AS 
    
  PROCEDURE P_OBTIENE_GRUPOS_PROC_MAPEO(Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoProceso          IN VARCHAR2,
                                        Pv_JobProceso           IN VARCHAR2)
  IS
    Lv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE     := Pv_CodEmpresa;
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='MAPEO DE PROMOCIONES MENSUAL';
    Lv_Estado DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                   :='Activo';
    Ln_DiaActual NUMBER                                                   := TO_NUMBER(TO_CHAR(SYSDATE, 'DD'), '99');
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_DiaCiclo               NUMBER;   
    Ln_promocionesCod         NUMBER;

   CURSOR C_GetCiclosDiaProceso(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ID_CICLO,
      NOMBRE_CICLO,
      TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') AS DIA_PROCESO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE EMPRESA_COD = Cv_CodigoEmpresa;   
      
   CURSOR C_GetDiaProceso(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT
      TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') AS DIA_PROCESO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE EMPRESA_COD = Cv_CodigoEmpresa
      and TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') = TO_NUMBER(TO_CHAR(sysdate, 'DD'), '99');   

    CURSOR C_GruposEjecucionMapeoMensual(Cv_IdCiclo          DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE, 
                                         Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                         Cv_Estado           DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                         Cv_CodigoEmpresa    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
    SELECT DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1) AS GRUPO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR5), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR5),'([^,]*)(,\1)+($|,)', '\1\3') AS CICLO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR1), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR1),'([^,]*)(,\1)+($|,)', '\1\3') AS FORMA_PAGO,
      LISTAGG (TRIM(PAMD.VALOR2), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR2) AS IDS_FORMASPAGO_EMISORES
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAMC,
      DB_GENERAL.ADMI_PARAMETRO_DET PAMD
    WHERE NOMBRE_PARAMETRO                                         = Cv_NombreParametro
    AND PAMC.ESTADO                                                = 'Activo'
    AND PAMD.ESTADO                                                = 'Activo'
    AND PAMD.EMPRESA_COD                                           = Cv_CodigoEmpresa
    AND PAMC.ID_PARAMETRO                                          = PAMD.PARAMETRO_ID
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PAMD.VALOR5,'^\d+')),0)   = Cv_IdCiclo
    GROUP BY DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1);

  BEGIN
  
    IF C_GetDiaProceso%ISOPEN THEN
      CLOSE C_GetDiaProceso;
    END IF;
    OPEN  C_GetDiaProceso(Lv_CodigoEmpresa);
    FETCH C_GetDiaProceso INTO Ln_DiaCiclo;
    CLOSE C_GetDiaProceso;

    Ln_promocionesCod := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_POMOCIONES_VIGENTES(FV_TipoProceso => Pv_TipoProceso,
                                                                                  Fv_CodEmpresa  => Lv_CodigoEmpresa,
                                                                                  Fv_EsCodigo    => 'S');
   FOR Lr_GetCiclosDiaProceso IN C_GetCiclosDiaProceso(Lv_CodigoEmpresa)
    LOOP


        FOR Lr_GruposEjecucionMapeoMensual IN C_GruposEjecucionMapeoMensual(Lr_GetCiclosDiaProceso.ID_CICLO, Lv_NombreParametro, Lv_Estado, Lv_CodigoEmpresa)
        LOOP        
            IF (Pv_JobProceso='JobDiario' AND Ln_DiaCiclo is null) OR (Pv_JobProceso='JobFacturacion' AND  Ln_DiaActual=Lr_GetCiclosDiaProceso.DIA_PROCESO) THEN
                    
              IF Ln_promocionesCod > 0 THEN
                DB_COMERCIAL.CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO(Pv_CodigoGrupoPromocion  => 'PROM_MENS',
                                                                       Pv_CodEmpresa            => Lv_CodigoEmpresa,
                                                                       Pv_TipoProceso           => 'EXISTENTE',
                                                                       Pv_FormaPago             => Lr_GruposEjecucionMapeoMensual.FORMA_PAGO,
                                                                       Pn_IdCiclo               => Lr_GetCiclosDiaProceso.ID_CICLO,
                                                                       Pv_IdsFormasPagoEmisores => Lr_GruposEjecucionMapeoMensual.IDS_FORMASPAGO_EMISORES);
              END IF;                                                       

              DB_COMERCIAL.CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES(Pv_CodigoGrupoPromocion  => 'PROM_MENS',
                                                                        Pv_CodEmpresa            => Lv_CodigoEmpresa,
                                                                        Pv_TipoProceso           => 'EXISTENTE',
                                                                        Pv_FormaPago             => Lr_GruposEjecucionMapeoMensual.FORMA_PAGO,
                                                                        Pn_IdCiclo               => Lr_GetCiclosDiaProceso.ID_CICLO,
                                                                        Pv_IdsFormasPagoEmisores => Lr_GruposEjecucionMapeoMensual.IDS_FORMASPAGO_EMISORES);

            END IF;
        
    
        END LOOP;

    END LOOP;
      
  EXCEPTION 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Mapeo de Promociones
                      para el Grupo de Promocional: '||
                      Pv_CodigoGrupoPromocion|| ' Tipo Proceso: '||Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_MAPEO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_OBTIENE_GRUPOS_PROC_MAPEO;
  --
  --
  --
  PROCEDURE P_PROCESO_MAPEO_PROMOCIONES(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoProceso           IN VARCHAR2,
                                        Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                        Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                        Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                        Pv_Alcance               IN VARCHAR2 DEFAULT NULL)
  IS
  CURSOR C_GetEmpresa IS
  SELECT IEG.COD_EMPRESA
  FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
  WHERE IEG.COD_EMPRESA = Pv_CodEmpresa;

  CURSOR C_GetErrorRepetido(Cv_Mensaje VARCHAR2 ) IS
  SELECT 'EXISTE'
  FROM DB_GENERAL.INFO_ERROR
  WHERE DETALLE_ERROR = Cv_Mensaje;

    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionTipoPromo         EXCEPTION;
    Le_ExceptionGrupoPromo        EXCEPTION;
    Le_ExceptionPunto             EXCEPTION;
    Lv_Existe                     VARCHAR2(6);
    Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    --Mensaje para el registro de Log de Errores
    Lv_MsjResultado               VARCHAR2(2000);   
    Lv_MsjExceptionProceso        VARCHAR2(1000);
    Lv_MsjExceptionTipoPromo      VARCHAR2(1000);
    Lv_MsjExceptionGrupoPromo     VARCHAR2(1000);
    Lv_MsjExceptionPunto          VARCHAR2(1000);
    --Listados 
    Lrf_PuntosProcesar            SYS_REFCURSOR;
    Lrf_GruposPromociones         SYS_REFCURSOR;
    Lrf_TiposPromociones          SYS_REFCURSOR;    
    --Tipos definidos
    Lr_Punto                      Lr_PtosClientesProcesar;
    Lr_GruposPromociones          Lr_GruposPromocionesProcesar;
    Lr_TiposPromociones           Lr_TiposPromocionesProcesar;
    Lr_GrupoPromoRegla            Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla             Lr_TipoPromoReglaProcesar;

    La_ServiciosProcesar          T_ServiciosProcesar;
    La_ServiciosCumplePromo       T_ServiciosProcesar;
    La_SectorizacionProcesar      T_SectorizacionProcesar;   
    La_TipoPromoPlanProdProcesar  T_TipoPromoPlanProdProcesar;
    Lb_OtorgoPromoCliente         BOOLEAN;
    Lb_CumplePromo                BOOLEAN;
    Lb_CumpleRegla2               BOOLEAN;
    Lb_CumpleRegla3               BOOLEAN;
    Lb_CumpleRegla4               BOOLEAN;  
    Lb_PromoIndefinida            BOOLEAN;
    Lv_TipoPromocion              VARCHAR2(20);
    Lv_EstadoServicio             VARCHAR2(20):='Activo';    
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    --Tipo para el BULK
    Ln_Limit                      CONSTANT PLS_INTEGER DEFAULT 5000;
    La_PtosClientesProcesar       T_PtosClientesProcesar;
    La_GruposPromocionesProcesar  T_GruposPromocionesProcesar;
    La_TiposPromocionesProcesar   T_TiposPromocionesProcesar;
    La_TiposPromoPrioridad        T_TiposPromocionesProcesar;
    Ln_Indx                       NUMBER;
    Ln_IndGpro                    NUMBER;    
    Ln_IndTpro                    NUMBER;    
    --Query de consulta del script    
    Lv_Consulta                   CLOB;
    Lv_Trama                      VARCHAR2(4000);
    Ld_FeEvaluaVigencia           DATE;
    Lv_IdServicioPref             VARCHAR2(4000);
    Lv_EsCambioPlan               VARCHAR2(4000);
    Ln_promociones                NUMBER := 0;

  BEGIN   
    IF Lrf_PuntosProcesar%ISOPEN THEN
      CLOSE Lrf_PuntosProcesar;
    END IF;
    IF Lrf_GruposPromociones%ISOPEN THEN
      CLOSE Lrf_GruposPromociones;
    END IF;
    IF Lrf_TiposPromociones%ISOPEN THEN
      CLOSE Lrf_TiposPromociones;
    END IF;
    IF C_GetErrorRepetido%ISOPEN THEN
      CLOSE C_GetErrorRepetido;
    END IF;
    
    IF Pv_TipoProceso = 'EXISTENTE' THEN
    
      Ln_promociones := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_POMOCIONES_VIGENTES(FV_TipoProceso => Pv_TipoProceso,
                                                                                 Fv_CodEmpresa  => Pv_CodEmpresa);
    END IF;
    --
    -- Se recupera Código de Empresa 
    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;
    OPEN C_GetEmpresa;
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;
    --
    IF Lv_CodEmpresa IS NULL THEN

      Lv_MsjExceptionProceso := 'No se encuentra definido código de Empresa para el Proceso de Promociones COD_EMPRESA: '||Pv_CodEmpresa;
      RAISE Le_ExceptionProceso;

    END IF;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
    'Antes de ejecutar el proceso DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR',
    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
    --
    --Obtengo consulta de los Puntos Clientes a Procesar por Tipo de Promoción, Código de empresa, 
    --Tipo de Proceso : Clientes Nuevos o Clientes Existentes.
    DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR(Pv_CodigoGrupoPromocion  => Pv_CodigoGrupoPromocion,
                                                            Pv_CodEmpresa            => Pv_CodEmpresa,
                                                            Pv_TipoProceso           => Pv_TipoProceso,
                                                            Pv_FormaPago             => Pv_FormaPago,
                                                            Pn_IdCiclo               => Pn_IdCiclo,
                                                            Pv_IdsFormasPagoEmisores => Pv_IdsFormasPagoEmisores,
                                                            Pv_Alcance               => Pv_Alcance,
                                                            Pv_Consulta              => Lv_Consulta);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
    'Despues de ejecutar el proceso DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR',
    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
    --
    IF Lv_Consulta IS NULL THEN

      Lv_MsjExceptionProceso:='No se pudo obtener los puntos clientes para el Proceso de Mapeo de Promociones. ';
      RAISE Le_ExceptionProceso;

    END IF;
    --    
    La_PtosClientesProcesar.DELETE();
    --
    OPEN Lrf_PuntosProcesar FOR Lv_Consulta;
    LOOP    
      FETCH Lrf_PuntosProcesar BULK COLLECT INTO La_PtosClientesProcesar LIMIT Ln_Limit;

      Ln_Indx:=La_PtosClientesProcesar.FIRST;

      WHILE (Ln_Indx IS NOT NULL)       
      LOOP       
      BEGIN
        --Limpiamos la Tabla de Servicios y Trama
        La_ServiciosProcesar.DELETE();    
        Lv_Trama:='';   
        Lb_OtorgoPromoCliente:=FALSE;

        --Recorriendo la data de los Puntos
        Lr_Punto := La_PtosClientesProcesar(Ln_Indx);
        Ln_Indx  := La_PtosClientesProcesar.NEXT(Ln_Indx);  
        -- Se realiza validación de Cambio de Plan
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
        'Consumo de funcion DB_COMERCIAL.GET_ID_SERVICIO_PREF para el idPunto: '||Lr_Punto.ID_PUNTO,
        'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
        --
        Lv_IdServicioPref:= DB_COMERCIAL.GET_ID_SERVICIO_PREF(Lr_Punto.ID_PUNTO);
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
        'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_TIPO_CAMBIO_PLAN para el idServicio: '||Lv_IdServicioPref,
        'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
        --
        Lv_EsCambioPlan  := DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_TIPO_CAMBIO_PLAN(Lv_IdServicioPref,Pv_CodEmpresa,'MASIVO');
     
        IF Lv_EsCambioPlan!='N' THEN

           --P_MAPEO_CAMBIO_PLAN
           DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN(Lr_Punto, Lv_IdServicioPref, Pv_CodigoGrupoPromocion, Pv_CodEmpresa, Lv_EsCambioPlan,'MASIVO');
  
        END IF;
        
        IF Pv_TipoProceso = 'NUEVO' OR (Pv_TipoProceso = 'EXISTENTE' AND Ln_promociones > 0 ) THEN
        
        --Obtengo la fecha con la cual se va a evaluar las vigencias de los grupos promocionales.
        Ld_FeEvaluaVigencia:=NULL;
        IF Pv_TipoProceso = 'NUEVO' THEN
          --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
          'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_OBTIENE_FECHA_EVAL_VIGENCIA para el idPunto: '||Lr_Punto.ID_PUNTO,
          'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
          --
          Ld_FeEvaluaVigencia:=DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_OBTIENE_FECHA_EVAL_VIGENCIA(Lr_Punto.ID_PUNTO,'Activo',Pv_CodigoGrupoPromocion);
          IF Ld_FeEvaluaVigencia IS NULL THEN
            Lv_MsjExceptionPunto:='No se pudo obtener la fecha para evaluación de vigencias para el Proceso de Mapeo de Promociones ' ||
            ' ID_PUNTO= ' || Lr_Punto.ID_PUNTO;
            RAISE Le_ExceptionPunto;
          END IF;
          --
        ELSE
          Ld_FeEvaluaVigencia:=SYSDATE-1;
        END IF;
             
        La_GruposPromocionesProcesar.DELETE();
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
        'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT para el idPunto: '||Lr_Punto.ID_PUNTO,
        'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
        --Obtengo los Grupos de Promociones que se van a Procesar por código de grupo y empresa que cumplan la fecha de vigencia.
        DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT(Pd_FeEvaluaVigencia     => Ld_FeEvaluaVigencia,
                                                             Pn_IdPunto              => Lr_Punto.ID_PUNTO,
                                                             Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                             Pv_CodEmpresa           => Pv_CodEmpresa,
                                                             Pv_TipoProceso          => Pv_TipoProceso,
                                                             Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                             Pa_TiposPromoPrioridad  => La_TiposPromoPrioridad);
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
        'Despues del consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT para el idPunto: '||Lr_Punto.ID_PUNTO,
        'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
        --
        IF La_GruposPromocionesProcesar.COUNT = 0 THEN
          Lv_MsjExceptionProceso:='No se pudo obtener los Grupos de Promocionales para el Proceso de Mapeo de Promociones. ';
          RAISE Le_ExceptionPunto;
        END IF;
        --
          Ln_IndGpro :=La_GruposPromocionesProcesar.FIRST;        

          WHILE (Ln_IndGpro IS NOT NULL)
          LOOP  
            --Inicio de Bloque para manejo de excepciones por Grupo Promocional                   
            BEGIN
              Lr_GruposPromociones := La_GruposPromocionesProcesar(Ln_IndGpro);
              Ln_IndGpro := La_GruposPromocionesProcesar.NEXT(Ln_IndGpro);  

              --Obtengo Reglas por Grupo Promocional.
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
              'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_GRUPO_REGLA para el idPunto: '||Lr_Punto.ID_PUNTO||
              ',con el idGrupoPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION,
              'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
              --
              Lr_GrupoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_GRUPO_REGLA(Lr_GruposPromociones.ID_GRUPO_PROMOCION);   
              --
              IF Pv_CodigoGrupoPromocion ='PROM_MENS' AND Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION IS NULL THEN             
                Lv_MsjExceptionGrupoPromo:= 'Ocurrio un error al obtener las reglas del Grupo Promocion ID_GRUPO_PROMOCION: '
                                          ||Lr_GruposPromociones.ID_GRUPO_PROMOCION;

                RAISE Le_ExceptionGrupoPromo;            
              END IF;            
              --          
              --Limpiamos la Tabla de Sectores
              La_SectorizacionProcesar.DELETE();
              --Obtengo Sectorizacion como estructura de tabla por Grupo o por Tipo Promocional
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
              'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION para el idPunto: '||Lr_Punto.ID_PUNTO||
              ',con el idGrupoPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION,
              'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
              --
              La_SectorizacionProcesar:=DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Lr_GruposPromociones.ID_GRUPO_PROMOCION);        
              --Obtengo los Tipos de Promociones que se van a Procesar por Grupo y empresa que cumplan la fecha de vigencia y ordenado Prioridad.
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
              'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_TIPOS_PROMOCIONES para el idPunto: '||Lr_Punto.ID_PUNTO||
              ',con el idGrupoPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION,
              'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
              --
              DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_TIPOS_PROMOCIONES(Pn_IdGrupoPromocion     => Lr_GruposPromociones.ID_GRUPO_PROMOCION, 
                                                                        Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                        Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                        Prf_TiposPromociones    => Lrf_TiposPromociones,
                                                                        Pd_FeEvaluaVigencia     => Ld_FeEvaluaVigencia);
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
              'Despues del consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_TIPOS_PROMOCIONES para el idPunto: '||Lr_Punto.ID_PUNTO||
              ',con el idGrupoPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION,
              'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
              --
              IF NOT(Lrf_TiposPromociones%ISOPEN) THEN              
                Lv_MsjExceptionGrupoPromo:= 'Ocurrio un error al obtener los Tipos de Promocionales del Grupo Promocion ID_GRUPO_PROMOCION: '
                                           ||Lr_GruposPromociones.ID_GRUPO_PROMOCION;

                RAISE Le_ExceptionGrupoPromo;
              END IF; 
              --
              La_TiposPromocionesProcesar.DELETE();
              --  
              --
              LOOP
                FETCH Lrf_TiposPromociones BULK COLLECT INTO La_TiposPromocionesProcesar LIMIT 4;
                Ln_IndTpro :=La_TiposPromocionesProcesar.FIRST;  

                WHILE (Ln_IndTpro IS NOT NULL)
                LOOP 
                  --Inicio de Bloque para manejo excepciones por Tipo Promocional
                  BEGIN
                    Lr_TiposPromociones := La_TiposPromocionesProcesar(Ln_IndTpro);
                    Ln_IndTpro := La_TiposPromocionesProcesar.NEXT(Ln_IndTpro); 

                    --Obtengo Reglas por Tipo Promocional.
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                    'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA para el idPunto: '||Lr_Punto.ID_PUNTO||
                    ',con el idTipoPromocion: '||Lr_TiposPromociones.ID_TIPO_PROMOCION,
                    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                    --
                    Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Lr_TiposPromociones.ID_TIPO_PROMOCION);
                    --
                    IF Lr_TipoPromoRegla.ID_TIPO_PROMOCION IS NULL THEN                    
                      Lv_MsjExceptionTipoPromo:= 'Ocurrio un error al obtener las reglas del Tipo Promocional ID_TIPO_PROMOCION: '
                                                 ||Lr_TiposPromociones.ID_TIPO_PROMOCION;

                      RAISE Le_ExceptionTipoPromo;            
                    END IF;            
                    --
                    --Obtengo los planes y productos por Tipo de Promoción, en este caso: PROM_MIX, PROM_MPLA, PROM_MPRO, PROM_BW.
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                    'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD para el idPunto: '||Lr_Punto.ID_PUNTO||
                    ',con el idTipoPromocion: '||Lr_TiposPromociones.ID_TIPO_PROMOCION,
                    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                    --
                    La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Lr_TiposPromociones.ID_TIPO_PROMOCION);

                    IF (Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_BW')
                        AND La_TipoPromoPlanProdProcesar.COUNT = 0) THEN  

                      Lv_MsjExceptionTipoPromo:= 'No se encontraron definidos Planes y/o Productos para el Tipo Promocional ID_TIPO_PROMOCION: '
                                               ||Lr_TiposPromociones.ID_TIPO_PROMOCION;         
                      RAISE Le_ExceptionTipoPromo;             
                    END IF;
                    --
                    --Obtengo el valor de la regla que define el estado de los servicios a considerar en el Proceso.                         
                    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
                      Lv_EstadoServicio:=Lr_GrupoPromoRegla.PROM_ESTADO_SERVICIO;
                    ELSE
                      Lv_EstadoServicio:=Lr_TipoPromoRegla.PROM_ESTADO_SERVICIO;
                    END IF;
                    --
                    --Obtengo los servicios a procesar por punto considerando el estado de los servicios en base a la regla (PROM_ESTADO_SERVICIO)
                    --y al TipoProceso: NUEVO y/o EXISTENTE.
                    --Para el caso de NUEVO, se consideran los clientes que confirman servicio y el estado del servicio Activo.
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                    'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_SERVICIOS_PROCESAR para el idPunto: '||Lr_Punto.ID_PUNTO,
                    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                    --
                    P_OBTIENE_SERVICIOS_PROCESAR(Pn_IdPunto              => Lr_Punto.ID_PUNTO, 
                                                 Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion, 
                                                 Pv_CodEmpresa           => Pv_CodEmpresa, 
                                                 Pv_TipoProceso          => Pv_TipoProceso, 
                                                 Pa_ServiciosProcesar    => La_ServiciosProcesar,
                                                 Pv_EstadoServicio       => Lv_EstadoServicio,
                                                 Pv_Alcance              => Pv_Alcance);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                    'Despues del consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_SERVICIOS_PROCESAR para el idPunto: '||Lr_Punto.ID_PUNTO,
                    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                    --
                    IF La_ServiciosProcesar.COUNT = 0 THEN
                      Lv_MsjExceptionTipoPromo:= 'No se encontraron servicios para el Proceso de Mapeo de Promociones para el ID_PUNTO: '
                                                 ||Lr_Punto.ID_PUNTO;

                      RAISE Le_ExceptionTipoPromo; 
                    END IF;                    
                    --
                    --Limpiamos la Tabla de servicios que cumplen el Tipo Promocional
                    La_ServiciosCumplePromo.DELETE(); 
                    Lb_CumplePromo:=TRUE;                   
                    --Obtengo los servicios a procesar por cada Tipo Promocional
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                    'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD para el idPunto: '||Lr_Punto.ID_PUNTO,
                    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                    DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_ServiciosProcesar, 
                                                                             Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION,
                                                                             La_TipoPromoPlanProdProcesar, 
                                                                             Lb_CumplePromo,
                                                                             La_ServiciosCumplePromo);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                    'Despues del consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD para el idPunto: '||Lr_Punto.ID_PUNTO,
                    'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                    --
                    IF NOT Lb_CumplePromo and La_ServiciosCumplePromo.COUNT = 0 THEN                      
                      Lv_MsjExceptionTipoPromo:= 'No se encontraron servicios en el Punto Cliente ID_PUNTO: '||Lr_Punto.ID_PUNTO||
                                                 ' que cumplan o se encuentren definidos en el Tipo Promocional ID_TIPO_PROMOCION: ' 
                                                 ||Lr_TiposPromociones.ID_TIPO_PROMOCION;   

                      RAISE Le_ExceptionTipoPromo; 
                    END IF;                    
                    --
                    --Si se cumplen todas las Reglas Promocionales llamo al procedimiento que genera el Mapeo de Promociones
                    --Se llama a Proceso de Mapeo por Tipo de Promocion Indefinida o Definida.           
                    IF Lb_CumplePromo THEN
                    --
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                      'Cumple la regla de DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD para el idPunto: '||Lr_Punto.ID_PUNTO,
                      'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                      --
                      Lb_CumpleRegla2:=DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                              Fn_IdPunto        => Lr_Punto.ID_PUNTO);
                      --
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                      'Cumple la regla de DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO para el idPunto: '||Lr_Punto.ID_PUNTO||
                      ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                      'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                      --
                      IF UPPER(Pv_TipoProceso) = 'NUEVO' THEN
                        Lb_CumpleRegla3 := TRUE;
                      ELSE
                        Lb_CumpleRegla3 := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PERMANENCIA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                                   Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                                   Lr_Punto.ID_PUNTO);
                      END IF;
                      Lb_CumpleRegla4:=DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                        Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                        Lr_Punto.ID_PUNTO);
                      --
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                      'Cumple la regla de DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA para el idPunto: '||Lr_Punto.ID_PUNTO||
                      ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                      ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                      'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                      --
                      Lb_PromoIndefinida:=F_VALIDA_PROMO_INDEFINIDA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                    Lr_TiposPromociones.CODIGO_TIPO_PROMOCION);                    
                      --
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                      'Cumple la regla de DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_PROMO_INDEFINIDA para el idPunto: '||Lr_Punto.ID_PUNTO||
                      ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                      ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                      'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                      --
                      IF Lb_CumpleRegla2 AND Lb_CumpleRegla3 AND Lb_CumpleRegla4 THEN
                      --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                        'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TRAMA para el idPunto: '||Lr_Punto.ID_PUNTO||
                        ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                        ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                        'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                        --Llamo a la Función que construye la Trama de la información del Cliente en base a las reglas Promocionales evaluadas.
                        Lv_Trama:=F_GET_TRAMA(Lr_Punto.ID_PUNTO, Lr_GrupoPromoRegla, Lr_TipoPromoRegla,  
                                              La_ServiciosCumplePromo,La_SectorizacionProcesar,null,Pv_CodEmpresa);

                        Lv_MsjResultado := NULL;
                        IF Lb_PromoIndefinida THEN  
                          --                                                    
                          Lv_TipoPromocion:= 'Promoción Indefinida';
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                          'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL para el idPunto: '||Lr_Punto.ID_PUNTO||
                          ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                          ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                          'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                          --
                          P_MAPEO_PROMO_MENSUAL(Lr_Punto,
                                                La_ServiciosCumplePromo,
                                                Lr_GruposPromociones,
                                                Lr_GrupoPromoRegla,
                                                Lr_TiposPromociones,
                                                Lr_TipoPromoRegla,
                                                Pv_TipoProceso,
                                                Lv_Trama,
                                                NULL,
                                                Lv_MsjResultado);
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                          'Despues de consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL para el idPunto: '||Lr_Punto.ID_PUNTO||
                          ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                          ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                          'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                          --
                        ELSE   
                          --                                                            
                          Lv_TipoPromocion:= 'Promoción Definida';
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                          'Consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_PROMO_DEFINIDAS para el idPunto: '||Lr_Punto.ID_PUNTO||
                          ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                          ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                          'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                          --
                          P_MAPEO_PROMO_DEFINIDAS(Pr_Punto                => Lr_Punto,
                                                  Pa_ServiciosCumplePromo => La_ServiciosCumplePromo,
                                                  Pr_GruposPromociones    => Lr_GruposPromociones,
                                                  Pr_GrupoPromoRegla      => Lr_GrupoPromoRegla,
                                                  Pr_TiposPromociones     => Lr_TiposPromociones,
                                                  Pr_TipoPromoRegla       => Lr_TipoPromoRegla,
                                                  Pv_TipoProceso          => Pv_TipoProceso,
                                                  Pv_Trama                => Lv_Trama,
                                                  Pv_CodEmpresa           => Pv_CodEmpresa,
                                                  Pv_MsjResultado         => Lv_MsjResultado);
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                          'Despues de consumo de funcion DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_PROMO_DEFINIDAS para el idPunto: '||Lr_Punto.ID_PUNTO||
                          ',con el idPromocion: '||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                          ',codigoTipoPromocion: '||Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                          'telcos_log_'||Pv_TipoProceso,SYSDATE, Lv_IpCreacion);
                          --
                        END IF;
                        --
                        IF Lv_MsjResultado IS NOT NULL THEN
                          --                          
                          Lv_MsjExceptionTipoPromo:= 'No se pudo generar el mapeo Promocional para el ID_PUNTO: '||Lr_Punto.ID_PUNTO||
                                                     ' Grupo Promocional ID_GRUPO_PROMOCION: ' ||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                                                     ' Tipo Promocional ID_TIPO_PROMOCION: ' ||Lr_TiposPromociones.ID_TIPO_PROMOCION||
                                                     ' ' ||Lv_TipoPromocion||' - ' || Lv_MsjResultado;                                               
                          RAISE Le_ExceptionTipoPromo; 
                          --
                        ELSE
                          Lb_OtorgoPromoCliente:=TRUE;
                        END IF;
                        --
                      END IF;
                    END IF;           
                    --                
                    --Limpiamos la Tabla de Planes y Productos por Tipo Promocional
                    La_TipoPromoPlanProdProcesar.DELETE();             
                    --
                    -- 
                  EXCEPTION
                  WHEN Le_ExceptionTipoPromo THEN

                    Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                                      || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionTipoPromo; 
                    Lv_Existe:='';
                    OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
                    --
                    FETCH C_GetErrorRepetido INTO Lv_Existe;
                    --
                    IF Lv_Existe <> 'EXISTE' THEN

                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                           'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                           'telcos_mapeo_promo',
                                                           SYSDATE,
                                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                                          ); 
                    END IF;
                    CLOSE C_GetErrorRepetido;                                      
                    Lv_MsjResultado:=NULL;
                    --
                  END;
                  --Fin de Bloque para manejo de excepciones por Tipo Promocional

                END LOOP;--Fin de WHILE (Ln_IndTpro IS NOT NULL) 
                EXIT WHEN Lrf_TiposPromociones%NOTFOUND;
                --
                --
              END LOOP;--Fin Loop 
              CLOSE Lrf_TiposPromociones;                                        
              --  
              --
            EXCEPTION
            WHEN Le_ExceptionGrupoPromo THEN
              Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                                 || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionGrupoPromo; 

              Lv_Existe:='';
              OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
              --
              FETCH C_GetErrorRepetido INTO Lv_Existe;
              --
              IF Lv_Existe <> 'EXISTE' THEN

                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                                                     Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_mapeo_promo',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                                    ); 
              END IF;
              CLOSE C_GetErrorRepetido;
              Lv_MsjResultado:=NULL;
              --
            END;
            --Fin de Bloque para manejo de excepciones por Grupo Promocional
            --
          END LOOP;--Fin de WHILE (Ln_IndGpro IS NOT NULL)
      END IF;
        --
        --
      EXCEPTION
        WHEN Le_ExceptionPunto THEN
          Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                            || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionPunto; 

          Lv_Existe:='';
          OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
          --
          FETCH C_GetErrorRepetido INTO Lv_Existe;
          --
          IF Lv_Existe <> 'EXISTE' THEN

             DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                  'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                                                  Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                  'telcos_mapeo_promo',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                                 ); 
          END IF;
          CLOSE C_GetErrorRepetido;
          Lv_MsjResultado:=NULL;
          --
      END;
      --Fin de Bloque para manejo de excepciones por Punto
      --
      END LOOP;--Fin de WHILE (Ln_Indx IS NOT NULL)
      COMMIT;
      EXIT WHEN Lrf_PuntosProcesar%NOTFOUND;
      --
      --
    END LOOP;-- Fin Loop - End Loop  
    CLOSE Lrf_PuntosProcesar; 
    --

  EXCEPTION
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '||Pv_CodigoGrupoPromocion||
                      ' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'MsjeError: Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '||
                      Pv_CodigoGrupoPromocion|| ' Tipo Proceso: '||Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_PROCESO_MAPEO_PROMOCIONES;
  --
  --
  FUNCTION F_GET_TRAMA(Fn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                       Fr_GrupoPromoRegla       IN Lr_GrupoPromoReglaProcesar DEFAULT NULL,                                 
                       Fr_TipoPromoRegla        IN Lr_TipoPromoReglaProcesar DEFAULT NULL,
                       Fa_ServiciosCumplePromo  IN T_ServiciosProcesar,
                       Fa_SectorizacionProcesar IN T_SectorizacionProcesar,
                       Fn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL)
  RETURN VARCHAR2
  IS
    --
    --Costo: 25
    CURSOR C_GetDataTrama (Cn_IdPunto       DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                           Cv_EstadoActivo  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                           Cv_CodTipoPromo  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                           Cv_CodEmpresa    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
    SELECT 
      ISE.ESTADO            AS PROM_ESTADO_SERVICIO,
      CONT.FORMA_PAGO_ID    AS PROM_FORMA_PAGO,
      NVL((SELECT CONTFP.BANCO_TIPO_CUENTA_ID
           FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONTFP
           WHERE CONTFP.CONTRATO_ID = CONT.ID_CONTRATO
           AND CONTFP.ESTADO        = Cv_EstadoActivo ),0)  AS PROM_EMISOR,        
      IP.PUNTO_COBERTURA_ID AS PROM_JURISDICCION,
      APA.CANTON_ID         AS PROM_CANTON,
      APA.ID_PARROQUIA      AS PROM_PARROQUIA,
      ASE.ID_SECTOR         AS PROM_SECTOR,
      IE.ID_ELEMENTO        AS PROM_ELEMENTO,
      NVL((SELECT DISTINCT IPDA.ELEMENTO_ID
          FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA,
            DB_COMERCIAL.INFO_SERVICIO                DBIS,
            DB_INFRAESTRUCTURA.INFO_ELEMENTO          DBIE,
            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   DBAME,
            DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     DBATE
         WHERE DBIS.ID_SERVICIO           =  ISE.ID_SERVICIO
           AND IPDA.PUNTO_ID              =  DBIS.PUNTO_ID
           AND IPDA.DEPENDE_DE_EDIFICIO   = 'S'
           AND DBIE.ID_ELEMENTO           = IPDA.ELEMENTO_ID
           AND DBAME.ID_MODELO_ELEMENTO   = DBIE.MODELO_ELEMENTO_ID
           AND DBATE.ID_TIPO_ELEMENTO     = DBAME.TIPO_ELEMENTO_ID
           AND DBATE.NOMBRE_TIPO_ELEMENTO = 'EDIFICACION'),0) AS PROM_EDIFICIO,
      IST.ULTIMA_MILLA_ID   AS PROM_ULTIMA_MILLA,
      NVL((SELECT 
             TRUNC(MONTHS_BETWEEN(
                SYSDATE,
                MIN(ISH.FE_CREACION)
             ))
           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  ISH
           WHERE       
           ISE.ID_SERVICIO = ISH.SERVICIO_ID
           AND (UPPER(dbms_lob.substr(ISH.OBSERVACION)) LIKE '%CONFIRMO%'
           OR ISH.ACCION                                = 'confirmarServicio' )       
           AND ISH.ESTADO                               = Cv_EstadoActivo),'')  AS PROM_PERMANENCIA_MINIMA,                  
      IP.TIPO_NEGOCIO_ID          AS PROM_TIPO_NEGOCIO
    FROM DB_COMERCIAL.INFO_PUNTO                  IP,
      DB_GENERAL.ADMI_PARROQUIA                   APA,
      DB_GENERAL.ADMI_SECTOR                      ASE,
      DB_COMERCIAL.INFO_SERVICIO                  ISE,           
      DB_COMERCIAL.INFO_SERVICIO_TECNICO          IST,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO            IE,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO     AME,
      DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO       ATE,
      DB_COMERCIAL.INFO_PLAN_DET                  IPD,
      DB_COMERCIAL.ADMI_PRODUCTO                  AP,
      DB_COMERCIAL.INFO_CONTRATO                  CONT
    WHERE APA.ID_PARROQUIA       = ASE.PARROQUIA_ID
    AND ASE.ID_SECTOR            = IP.SECTOR_ID
    AND ATE.NOMBRE_TIPO_ELEMENTO = 'OLT'
    AND ATE.ID_TIPO_ELEMENTO     = AME.TIPO_ELEMENTO_ID
    AND AME.ID_MODELO_ELEMENTO   = IE.MODELO_ELEMENTO_ID
    AND IE.ESTADO                = Cv_EstadoActivo
    AND IE.ID_ELEMENTO           = IST.ELEMENTO_ID
    AND IST.SERVICIO_ID          = ISE.ID_SERVICIO
    AND AP.CODIGO_PRODUCTO       = 'INTD'
    AND AP.ID_PRODUCTO           = IPD.PRODUCTO_ID
    AND IPD.PLAN_ID              = ISE.PLAN_ID        
    AND (ISE.ESTADO IN (SELECT APD.VALOR1 
                       FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                         DB_GENERAL.ADMI_PARAMETRO_DET APD
                       WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                       AND APD.ESTADO             = Cv_EstadoActivo
                       AND APD.EMPRESA_COD        = Cv_CodEmpresa
                       AND APC.NOMBRE_PARAMETRO   = 'PROM_ESTADOS_SERVICIO'
                       AND APC.ESTADO             = Cv_EstadoActivo) 
         OR Cv_CodTipoPromo IN ('PROM_INS','PROM_BW')) 
    AND IP.PERSONA_EMPRESA_ROL_ID = CONT.PERSONA_EMPRESA_ROL_ID
    AND (CONT.ESTADO              = Cv_EstadoActivo 
         OR Cv_CodTipoPromo IN ('PROM_INS','PROM_BW'))
    AND ISE.PUNTO_ID              = IP.ID_PUNTO        
    AND IP.ID_PUNTO               = Cn_IdPunto
    AND ROWNUM=1;
    
    --Costo: 25
    CURSOR C_GetDataServicio (Cn_IdPunto       DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Cv_EstadoActivo  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                              Cv_CodTipoPromo  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Cn_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_CodEmpresa    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
    SELECT 
      ISE.ESTADO            AS PROM_ESTADO_SERVICIO,
      CONT.FORMA_PAGO_ID    AS PROM_FORMA_PAGO,
      NVL((SELECT CONTFP.BANCO_TIPO_CUENTA_ID
           FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONTFP
           WHERE CONTFP.CONTRATO_ID = CONT.ID_CONTRATO
           AND CONTFP.ESTADO        = Cv_EstadoActivo ),0)  AS PROM_EMISOR,        
      IP.PUNTO_COBERTURA_ID AS PROM_JURISDICCION,
      APA.CANTON_ID         AS PROM_CANTON,
      APA.ID_PARROQUIA      AS PROM_PARROQUIA,
      ASE.ID_SECTOR         AS PROM_SECTOR,
      IE.ID_ELEMENTO        AS PROM_ELEMENTO,
      NVL((SELECT DISTINCT IPDA.ELEMENTO_ID
          FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA,
            DB_COMERCIAL.INFO_SERVICIO                DBIS,
            DB_INFRAESTRUCTURA.INFO_ELEMENTO          DBIE,
            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   DBAME,
            DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     DBATE
         WHERE DBIS.ID_SERVICIO           =  ISE.ID_SERVICIO
           AND IPDA.PUNTO_ID              =  DBIS.PUNTO_ID
           AND IPDA.DEPENDE_DE_EDIFICIO   = 'S'
           AND DBIE.ID_ELEMENTO           = IPDA.ELEMENTO_ID
           AND DBAME.ID_MODELO_ELEMENTO   = DBIE.MODELO_ELEMENTO_ID
           AND DBATE.ID_TIPO_ELEMENTO     = DBAME.TIPO_ELEMENTO_ID
           AND DBATE.NOMBRE_TIPO_ELEMENTO = 'EDIFICACION'),0) AS PROM_EDIFICIO,
      IST.ULTIMA_MILLA_ID   AS PROM_ULTIMA_MILLA,
      NVL((SELECT 
             TRUNC(MONTHS_BETWEEN(
                SYSDATE,
                MIN(ISH.FE_CREACION)
             ))
           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  ISH
           WHERE       
           ISE.ID_SERVICIO = ISH.SERVICIO_ID
           AND (UPPER(dbms_lob.substr(ISH.OBSERVACION)) LIKE '%CONFIRMO%'
           OR ISH.ACCION                                = 'confirmarServicio' )       
           AND ISH.ESTADO                               = Cv_EstadoActivo),'')  AS PROM_PERMANENCIA_MINIMA,                  
      IP.TIPO_NEGOCIO_ID          AS PROM_TIPO_NEGOCIO
    FROM DB_COMERCIAL.INFO_PUNTO                  IP,
      DB_GENERAL.ADMI_PARROQUIA                   APA,
      DB_GENERAL.ADMI_SECTOR                      ASE,
      DB_COMERCIAL.INFO_SERVICIO                  ISE,           
      DB_COMERCIAL.INFO_SERVICIO_TECNICO          IST,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO            IE,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO     AME,
      DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO       ATE,
      DB_COMERCIAL.INFO_PLAN_DET                  IPD,
      DB_COMERCIAL.ADMI_PRODUCTO                  AP,
      DB_COMERCIAL.INFO_CONTRATO                  CONT
    WHERE APA.ID_PARROQUIA       = ASE.PARROQUIA_ID
    AND ASE.ID_SECTOR            = IP.SECTOR_ID
    AND ATE.NOMBRE_TIPO_ELEMENTO = 'OLT'
    AND ATE.ID_TIPO_ELEMENTO     = AME.TIPO_ELEMENTO_ID
    AND AME.ID_MODELO_ELEMENTO   = IE.MODELO_ELEMENTO_ID
    AND IE.ESTADO                = Cv_EstadoActivo
    AND IE.ID_ELEMENTO           = IST.ELEMENTO_ID
    AND IST.SERVICIO_ID          = ISE.ID_SERVICIO
    AND AP.CODIGO_PRODUCTO       = 'INTD'
    AND AP.ID_PRODUCTO           = IPD.PRODUCTO_ID
    AND IPD.PLAN_ID              = ISE.PLAN_ID        
    AND (ISE.ESTADO IN (SELECT APD.VALOR1 
                       FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                         DB_GENERAL.ADMI_PARAMETRO_DET APD
                       WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                       AND APD.ESTADO             = Cv_EstadoActivo
                       AND APD.EMPRESA_COD        = Cv_CodEmpresa
                       AND APC.NOMBRE_PARAMETRO   = 'PROM_ESTADOS_SERVICIO'
                       AND APC.ESTADO             = Cv_EstadoActivo) 
         OR Cv_CodTipoPromo IN ('PROM_INS','PROM_BW')) 
    AND IP.PERSONA_EMPRESA_ROL_ID = CONT.PERSONA_EMPRESA_ROL_ID
    AND (CONT.ESTADO              = Cv_EstadoActivo 
         OR Cv_CodTipoPromo IN ('PROM_INS','PROM_BW'))
    AND ISE.PUNTO_ID              = IP.ID_PUNTO        
    AND IP.ID_PUNTO               = Cn_IdPunto
    AND ISE.ID_SERVICIO           = Cn_IdServicio
    AND ROWNUM=1;

    Lr_GetDataTrama       C_GetDataTrama%ROWTYPE;
    Lv_EstadoActivo       VARCHAR2(20):='Activo';
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(2000); 
    Lv_Trama              VARCHAR2(4000);
    Lv_ServiciosPromo     VARCHAR2(2000);
    Ln_Indice             NUMBER:=1;
    Lv_Jurisdiccion       VARCHAR2(50);
    Lv_Canton             VARCHAR2(50);
    Lv_Parroquia          VARCHAR2(50);
    Lv_Sector             VARCHAR2(50);
    Lv_Elemento           VARCHAR2(50);
    Lv_Edificio           VARCHAR2(50);

  BEGIN
  --
  Lr_GetDataTrama := null;
  Lv_Trama        := 'Sin Trama';  
  IF C_GetDataTrama%ISOPEN THEN
    --
    CLOSE C_GetDataTrama;
    --
  END IF;
  
  IF C_GetDataServicio%ISOPEN THEN
    --
    CLOSE C_GetDataServicio;
    --
  END IF;
  --
  IF Fn_IdServicio IS NULL THEN
    OPEN C_GetDataTrama(Fn_IdPunto,Lv_EstadoActivo,Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION,Pv_CodEmpresa);
    --
    FETCH C_GetDataTrama INTO Lr_GetDataTrama;
    --
    CLOSE C_GetDataTrama;
  ELSE 
    OPEN C_GetDataServicio(Fn_IdPunto,Lv_EstadoActivo,Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION,Fn_IdServicio,Pv_CodEmpresa);
    --
    FETCH C_GetDataServicio INTO Lr_GetDataTrama;
    --
    CLOSE C_GetDataServicio;
  END IF;

  IF Lr_GetDataTrama.PROM_ESTADO_SERVICIO IS NOT NULL
    AND Fr_GrupoPromoRegla.ID_GRUPO_PROMOCION IS NOT NULL
    AND Fr_TipoPromoRegla.ID_TIPO_PROMOCION IS NOT NULL  THEN        
    --
    IF Fa_ServiciosCumplePromo.COUNT > 0 THEN
      Ln_Indice := Fa_ServiciosCumplePromo.FIRST;
      WHILE (Ln_Indice IS NOT NULL)
      LOOP
        Lv_ServiciosPromo:=Lv_ServiciosPromo || '{"ID_SERVICIO":"'|| Fa_ServiciosCumplePromo(Ln_Indice).ID_SERVICIO || '",' ||
                     '"ID_PUNTO":"'|| Fa_ServiciosCumplePromo(Ln_Indice).ID_PUNTO || '",' ||
                     '"ID_PLAN":"'|| Fa_ServiciosCumplePromo(Ln_Indice).ID_PLAN || '",' ||
                     '"ID_PRODUCTO":"'|| Fa_ServiciosCumplePromo(Ln_Indice).ID_PRODUCTO ||'",' ||
                     '"PLAN_ID_SUPERIOR":"'|| Fa_ServiciosCumplePromo(Ln_Indice).PLAN_ID_SUPERIOR ||'",' ||
                     '"ESTADO":"'|| Fa_ServiciosCumplePromo(Ln_Indice).ESTADO || '"}';

        IF Ln_Indice < Fa_ServiciosCumplePromo.COUNT THEN
          Lv_ServiciosPromo:=Lv_ServiciosPromo || ',';
        END IF;  
        Ln_Indice := Fa_ServiciosCumplePromo.NEXT(Ln_Indice);
      END LOOP;
    END IF;     
    --Si la Promoción tiene reglas de Sectorización definidas, entonces debo contruir la trama con la sectorización del Punto
    IF Fa_SectorizacionProcesar.COUNT > 0 THEN
      Lv_Jurisdiccion:=Lr_GetDataTrama.PROM_JURISDICCION;
      Lv_Canton      :=Lr_GetDataTrama.PROM_CANTON;
      Lv_Parroquia   :=Lr_GetDataTrama.PROM_PARROQUIA;
      Lv_Sector      :=Lr_GetDataTrama.PROM_SECTOR;
      Lv_Elemento    :=Lr_GetDataTrama.PROM_ELEMENTO;
      Lv_Edificio    :=Lr_GetDataTrama.PROM_EDIFICIO;
    END IF;

    IF Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IS NOT NULL 
       AND Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_TOT') THEN               
      Lv_Trama:='{"TRAMA":{' ||
                '"PROM_ESTADO_SERVICIO":"'|| Lr_GetDataTrama.PROM_ESTADO_SERVICIO || '",' ||
                '"PROM_FORMA_PAGO":"'|| Lr_GetDataTrama.PROM_FORMA_PAGO || '",' ||
                '"PROM_EMISOR":"'|| Lr_GetDataTrama.PROM_EMISOR || '",' ||
                '"PROM_TIPO_CLIENTE":"'|| Fr_GrupoPromoRegla.PROM_TIPO_CLIENTE || '",' ||
                '"PROM_ULTIMA_MILLA":"",' ||
                '"PROM_PERMANENCIA_MINIMA":"'|| Fr_TipoPromoRegla.PROM_PERMANENCIA_MINIMA || '",' ||
                '"PROM_PIERDE_PROMOCION_MORA":"'|| Fr_TipoPromoRegla.PROM_PIERDE_PROMOCION_MORA || '",' ||
                '"PROM_DESCUENTO":"'|| Fr_TipoPromoRegla.PROM_DESCUENTO || '",' ||
                '"PROM_ANTIGUEDAD":"",' ||
                '"PROM_PERIODO":"'|| Fr_TipoPromoRegla.PROM_PERIODO || '",' ||
                '"PROM_PROMOCION_INDEFINIDA":"'|| Fr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA || '",' ||
                '"PROM_TIPO_NEGOCIO":"",' ||
                '"PROM_TIPO_PERIODO":"'|| Fr_TipoPromoRegla.PROM_TIPO_PERIODO || '",' ||
                '"PROM_DIAS_MORA":"'|| Fr_TipoPromoRegla.PROM_DIAS_MORA || '",' ||
                '"PROM_JURISDICCION":"'|| Lv_Jurisdiccion || '",' ||
                '"PROM_CANTON":"'|| Lv_Canton || '",' ||
                '"PROM_PARROQUIA":"'|| Lv_Parroquia || '",' ||
                '"PROM_SECTOR":"'|| Lv_Sector || '",' ||
                '"PROM_ELEMENTO":"'|| Lv_Elemento || '",' ||
                '"PROM_EDIFICIO":"'|| Lv_Edificio || '",' ||
                '"PROM_INVALIDA_PROMO":"'|| Fr_TipoPromoRegla.PROM_INVALIDA_PROMO || '",' ||    
                '"PROM_SERVICIOS_CUMPLEN_PROMO":['|| Lv_ServiciosPromo ||']}}';           
    ELSIF Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IS NOT NULL 
      AND Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_BW') THEN    
      Lv_Trama:='{"TRAMA":{' ||
                '"PROM_ESTADO_SERVICIO":"'|| Lr_GetDataTrama.PROM_ESTADO_SERVICIO || '",' ||
                '"PROM_FORMA_PAGO":"'|| Lr_GetDataTrama.PROM_FORMA_PAGO || '",' ||
                '"PROM_EMISOR":"'|| Lr_GetDataTrama.PROM_EMISOR || '",' ||
                '"PROM_TIPO_CLIENTE":"'|| Fr_TipoPromoRegla.PROM_TIPO_CLIENTE || '",' ||
                '"PROM_ULTIMA_MILLA":"'|| Lr_GetDataTrama.PROM_ULTIMA_MILLA || '",' ||
                '"PROM_PERMANENCIA_MINIMA":"",' ||
                '"PROM_PIERDE_PROMOCION_MORA":"",' ||
                '"PROM_DESCUENTO":"",' ||
                '"PROM_ANTIGUEDAD":"'|| Fr_TipoPromoRegla.PROM_ANTIGUEDAD || '",' ||
                '"PROM_PERIODO":"'|| Fr_TipoPromoRegla.PROM_PERIODO || '",' ||
                '"PROM_PROMOCION_INDEFINIDA":"",' ||
                '"PROM_TIPO_NEGOCIO":"'|| Lr_GetDataTrama.PROM_TIPO_NEGOCIO || '",' ||
                '"PROM_TIPO_PERIODO":"",' ||
                '"PROM_DIAS_MORA":"",' ||
                '"PROM_JURISDICCION":"'|| Lv_Jurisdiccion || '",' ||
                '"PROM_CANTON":"'|| Lv_Canton || '",' ||
                '"PROM_PARROQUIA":"'|| Lv_Parroquia || '",' ||
                '"PROM_SECTOR":"'|| Lv_Sector || '",' ||
                '"PROM_ELEMENTO":"'|| Lv_Elemento || '",' ||
                '"PROM_EDIFICIO":"'|| Lv_Edificio || '",' ||
                '"PROM_INVALIDA_PROMO":"",' ||
                '"PROM_SERVICIOS_CUMPLEN_PROMO":['|| Lv_ServiciosPromo ||']}}';                     
    ELSIF Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IS NOT NULL 
      AND Fr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_INS') THEN    
      Lv_Trama:='{"TRAMA":{' ||
                '"PROM_ESTADO_SERVICIO":"'|| Lr_GetDataTrama.PROM_ESTADO_SERVICIO || '",' ||
                '"PROM_FORMA_PAGO":"'|| Lr_GetDataTrama.PROM_FORMA_PAGO || '",' ||
                '"PROM_EMISOR":"'|| Lr_GetDataTrama.PROM_EMISOR || '",' ||
                '"PROM_TIPO_CLIENTE":"'|| Fr_TipoPromoRegla.PROM_TIPO_CLIENTE || '",' ||
                '"PROM_ULTIMA_MILLA":"'|| Lr_GetDataTrama.PROM_ULTIMA_MILLA || '",' ||
                '"PROM_PERMANENCIA_MINIMA":"",' ||
                '"PROM_PIERDE_PROMOCION_MORA":"",' ||
                '"PROM_DESCUENTO":"",' ||
                '"PROM_ANTIGUEDAD":"",' ||
                '"PROM_PERIODO":"'|| Fr_TipoPromoRegla.PROM_PERIODO || '",' ||
                '"PROM_PROMOCION_INDEFINIDA":"",' ||
                '"PROM_TIPO_NEGOCIO":"'|| Lr_GetDataTrama.PROM_TIPO_NEGOCIO || '",' ||
                '"PROM_TIPO_PERIODO":"",' ||
                '"PROM_DIAS_MORA":"",' ||
                '"PROM_JURISDICCION":"'|| Lv_Jurisdiccion || '",' ||
                '"PROM_CANTON":"'|| Lv_Canton || '",' ||
                '"PROM_PARROQUIA":"'|| Lv_Parroquia || '",' ||
                '"PROM_SECTOR":"'|| Lv_Sector || '",' ||
                '"PROM_ELEMENTO":"'|| Lv_Elemento || '",' ||
                '"PROM_EDIFICIO":"'|| Lv_Edificio || '",' ||
                '"PROM_INVALIDA_PROMO":"",' ||
                '"PROM_SERVICIOS_CUMPLEN_PROMO":['|| Lv_ServiciosPromo ||']}}';            
    END IF; 

  END IF;
  --
  RETURN Lv_Trama;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrio un error al construir la Trama con los valores de las reglas Promocionales en el Punto Cliente: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_GET_TRAMA', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );  
    Lv_Trama:='Sin Trama';                                        
    RETURN Lv_Trama;                                                                      
  END F_GET_TRAMA;
  --
  --
  PROCEDURE P_OBTIENE_PUNTOS_PROCESAR(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                      Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pv_TipoProceso           IN VARCHAR2,
                                      Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                      Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                      Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                      Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                      Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL,
                                      Pv_Alcance               IN VARCHAR2 DEFAULT NULL,
                                      Pv_Consulta              OUT CLOB)

  IS
  
    CURSOR C_HoraJobCliNuev(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                            Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                            Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                            Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)--JCA
    IS
      SELECT APD.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APD.EMPRESA_COD        = Cv_CodEmpresa
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro;

    Le_Exception                 EXCEPTION;
    Lv_Estado                    VARCHAR2(15):= 'Activo';
    Lv_DescripcionRol            VARCHAR2(15):= 'Cliente';
    Lv_CaractCicloFact           VARCHAR2(20):='CICLO_FACTURACION';
    Lv_EsVenta                   VARCHAR2(1):= 'S';
    Ln_Frecuencia                NUMBER:=1;  
    Ln_Numero                    NUMBER:=0;
    Lv_IpCreacion                VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado              VARCHAR2(2000);   
    Lv_CadenaQuery               CLOB;
    Lv_CadenaFrom                CLOB;
    Lv_CadenaWhere               CLOB;
    Lv_CadenaAgrupa              CLOB;
    Lv_CadenaOrdena              CLOB;
    Lv_NombreParametro           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_HORA_EJECUCION_JOB';
    Lv_Descripcion               DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_HORA_EJECUCION_JOB_CLI_NUEV';
    Lv_EstadoActivo              VARCHAR2(15):= 'Activo';
    Lv_Hora                      VARCHAR2(10);
    Ld_FechaAnterior             DATE:= SYSDATE - 1 ;
    Ld_FechaAlcance              DATE:= SYSDATE;
    Lv_fechaJob                  VARCHAR2(100);
    Lv_CaracteristicaTipoProceso DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;

  BEGIN

    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
      --Costo: Query para Clientes que Confirman Servicios (TipoProceso: NUEVO) : 13975
      --Costo: Query para Clientes existentes (TipoProceso: EXISTENTE) : 12022

      Lv_CadenaQuery:= ' SELECT DISTINCT
      IPER.ID_PERSONA_ROL,
      IP.ID_PUNTO,
      IP.LOGIN, 
      IER.EMPRESA_COD ';
      Lv_CadenaFrom:= ' FROM 
      DB_COMERCIAL.INFO_SERVICIO ISE, 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPE,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AR';

      Lv_CadenaWhere:=' WHERE ISE.ESTADO ='''||Lv_Estado||'''
      AND ISE.CANTIDAD                   > '||Ln_Numero||'
      AND IER.EMPRESA_COD                = '''||Pv_CodEmpresa||'''
      AND ISE.ES_VENTA                   = '''||Lv_EsVenta||'''
      AND AR.DESCRIPCION_ROL             = '''||Lv_DescripcionRol||'''
      AND ISE.PRECIO_VENTA               > '||Ln_Numero||'
      AND ISE.FRECUENCIA_PRODUCTO        = '|| Ln_Frecuencia ||'
      AND IP.ID_PUNTO                    = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL            = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA                 = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL             = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                      = IER.ROL_ID
      --AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PLAN_EMP_PYME(ISE.ID_SERVICIO) = ''S''
      AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(ISE.ID_SERVICIO) = ''S''
      --AND DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(ISE.ID_SERVICIO,'''||Pv_CodigoGrupoPromocion||''','''||Pv_CodEmpresa||''')=''S'' 
      
      AND NOT EXISTS (  
      SELECT ''X'' AS EXISTE 
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DBIDMP  
      WHERE DBIDMP.ID_DETALLE_MAPEO IN (SELECT NVL(MAX(IDMP.ID_DETALLE_MAPEO),0) AS ID_DETALLE_MAPEO 
                                      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP 
                                      WHERE IDMP.ID_DETALLE_MAPEO IN (SELECT IDMS.DETALLE_MAPEO_ID 
                                                                      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
                                                                      WHERE IDMS.SERVICIO_ID = ISE.ID_SERVICIO) 
                                      AND IDMP.EMPRESA_COD = '''||Pv_CodEmpresa||'''
                                      AND IDMP.TIPO_PROMOCION IN (SELECT DET.VALOR2 
                                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                     DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                   WHERE CAB.NOMBRE_PARAMETRO = ''PROM_TIPO_PROMOCIONES''
                                                   AND CAB.ESTADO             = '''||Lv_Estado||'''
                                                   AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                   AND DET.VALOR3             = '''||Pv_CodigoGrupoPromocion||'''
                                                   AND DET.EMPRESA_COD        = '''||Pv_CodEmpresa||'''
                                                   AND DET.ESTADO             = '''||Lv_Estado||''')
                                     )
        AND ((DBIDMP.INDEFINIDO IS NOT NULL AND DBIDMP.ESTADO != ''Baja'')
             OR ((DBIDMP.ESTADO = '''||Lv_Estado||''' OR (DBIDMP.ESTADO != ''Baja'' AND 
                DBIDMP.CANTIDAD_PERIODOS > DBIDMP.MAPEOS_GENERADOS)))))
      
      ';    

      Lv_CadenaAgrupa:= ' GROUP BY
      IPER.ID_PERSONA_ROL,
      IP.ID_PUNTO,
      IP.LOGIN, 
      IER.EMPRESA_COD ';

      Lv_CadenaOrdena:= ' ORDER BY  IP.ID_PUNTO ASC';  
      
      IF Pn_IdPunto IS NOT NULL THEN
      
          Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IP.ID_PUNTO = '''||Pn_IdPunto||''' ';
          
      END IF;

    END IF;

    IF Pv_EsCodigo = 'S' THEN
    
      IF Pv_TipoProceso = 'NUEVO' THEN
        Lv_CaracteristicaTipoProceso := 'PROM_COD_NUEVO';
      ELSE
        Lv_CaracteristicaTipoProceso := 'PROM_COD_EXISTENTE';
      END IF;
    
      Lv_CadenaWhere := Lv_CadenaWhere ||  ' AND EXISTS( SELECT ''X'' FROM     
          DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
          DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE ISC.SERVICIO_ID               = ISE.ID_SERVICIO
        AND ISC.ESTADO                      = ''Activo''
        AND ISC.VALOR                       IS NOT NULL
        AND DBAC.ID_CARACTERISTICA          = ISC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = '''|| Lv_CaracteristicaTipoProceso ||''' ) ' ;
    
    END IF; 

    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso = 'NUEVO' THEN

      IF Pv_Alcance = 'ALCANCE' THEN
        Lv_Descripcion := 'PROM_HORA_ALCANCE_JOB_CLI_NUEV';
      END IF;

      IF C_HoraJobCliNuev%ISOPEN THEN
        CLOSE C_HoraJobCliNuev;
      END IF;

      BEGIN
        OPEN C_HoraJobCliNuev(Lv_NombreParametro,
                              Lv_Descripcion,
                              Lv_EstadoActivo,
                              Pv_CodEmpresa);
        FETCH C_HoraJobCliNuev INTO Lv_Hora;
        CLOSE C_HoraJobCliNuev;
      EXCEPTION
        WHEN OTHERS THEN
          IF Pv_Alcance = 'ALCANCE' THEN
            Lv_Hora := ' 21:20:00';
          ELSE
            Lv_Hora := ' 23:20:00';
          END IF;
      END;

      IF Pv_Alcance = 'ALCANCE' THEN
        Lv_fechaJob   := Ld_FechaAlcance|| Lv_Hora ;
      ELSE
        Lv_fechaJob   := Ld_FechaAnterior || Lv_Hora ;
      END IF;
          
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ';
      Lv_CadenaWhere:= Lv_CadenaWhere || '  
      AND ISE.ID_SERVICIO                                    = ISH.SERVICIO_ID
      AND (UPPER(dbms_lob.substr(ISH.OBSERVACION))           LIKE ''%CONFIRMO%''
      OR ISH.ACCION                                          = ''confirmarServicio'' )
      AND ISH.FE_CREACION                                    >= TO_DATE('''|| Lv_fechaJob ||''',''DD-MM-RRRR HH24:MI:SS'')
      AND ISH.FE_CREACION                                    <= SYSDATE
      AND ISH.ESTADO                                         ='''||Lv_Estado||''' ';

      Pv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaAgrupa || Lv_CadenaOrdena;

    ELSIF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso = 'EXISTENTE' 
           AND Pv_FormaPago IS NOT NULL AND Pn_IdCiclo IS NOT NULL AND Pv_IdsFormasPagoEmisores IS NOT NULL THEN

      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_FINANCIERO.ADMI_CICLO ADMCICLO';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO CONT, DB_GENERAL.ADMI_FORMA_PAGO FP ';      

      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IPER.ID_PERSONA_ROL   = CICLO.PERSONA_EMPRESA_ROL_ID
      AND CICLO.CARACTERISTICA_ID                                    = CARAC.ID_CARACTERISTICA
      AND CARAC.DESCRIPCION_CARACTERISTICA                           = '''||Lv_CaractCicloFact||'''
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,''^\d+'')),0) = ADMCICLO.ID_CICLO
      AND ADMCICLO.ID_CICLO                                          = COALESCE(TO_NUMBER(REGEXP_SUBSTR('||Pn_IdCiclo||',''^\d+'')),0)
      AND IPER.ID_PERSONA_ROL                                        = CONT.PERSONA_EMPRESA_ROL_ID
      AND CONT.ESTADO                                                ='''||Lv_Estado||'''
      AND CONT.FORMA_PAGO_ID                                         = FP.ID_FORMA_PAGO ';

      IF Pv_FormaPago='DEBITO BANCARIO' THEN
        Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONFP';

        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.DESCRIPCION_FORMA_PAGO = '''||Pv_FormaPago||''' 
        AND CONT.ID_CONTRATO                                               = CONFP.CONTRATO_ID
        AND CONFP.BANCO_TIPO_CUENTA_ID                                     IN ('|| Pv_IdsFormasPagoEmisores ||') 
        AND CONFP.ESTADO                                                   ='''||Lv_Estado||''' ';    

      ELSIF Pv_FormaPago='EFECTIVO' THEN
        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.ID_FORMA_PAGO IN ('|| Pv_IdsFormasPagoEmisores ||') ';
      END IF;

      Pv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaAgrupa || Lv_CadenaOrdena;
    END IF;

    IF Pn_IdPunto IS NOT NULL THEN
      Pv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaAgrupa || Lv_CadenaOrdena;
    END IF;
        
    IF Pv_Consulta IS NULL THEN
      RAISE Le_Exception;
    END IF;

  EXCEPTION
  WHEN Le_Exception THEN   
    Lv_MsjResultado := 'Ocurrio un error al obtener los puntos clientes para el Proceso de Mapeo de Promociones ' || 
                       'para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' y Tipo Proceso: '||Pv_TipoProceso; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
  WHEN OTHERS THEN   
    Lv_MsjResultado := 'Ocurrio un error al obtener los puntos clientes para el Proceso de Mapeo de Promociones ' || 
                       'para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' y Tipo Proceso: '||Pv_TipoProceso; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );                  
  END P_OBTIENE_PUNTOS_PROCESAR;
  --
  --
  PROCEDURE P_OBTIENE_GRUPOS_PROMOCIONES(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoProceso           IN VARCHAR2,
                                         Prf_GruposPromociones    OUT SYS_REFCURSOR,
                                         Pd_FeEvaluaVigencia      IN DATE DEFAULT NULL,
                                         Pn_IdPromocion           IN NUMBER DEFAULT NULL)
  IS    
    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';
    Lv_EstadoInactivo    VARCHAR2(15) := 'Inactivo';
    Lv_EstadoEliminado   VARCHAR2(15) := 'Eliminado';
    Lv_CaracCodigo       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PROM_CODIGO';
    Lv_TipoCliente       VARCHAR2(20) := 'PROM_TIPO_CLIENTE';
    Lv_NombreParametro   VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion        VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado      VARCHAR2(2000);  
    Lv_QuerySelect       VARCHAR2(4000);
    Lv_QueryFrom         VARCHAR2(4000); 
    Lv_QueryWhere        VARCHAR2(4000); 
    Lv_QueryGroupBy      VARCHAR2(4000); 
    Lv_QueryOrderBy      VARCHAR2(4000); 
    Lv_Consulta          VARCHAR2(4000); 
    Le_Exception         EXCEPTION;
    Lv_FeProcesaVigencia VARCHAR2(15):= TO_CHAR(SYSDATE,'RRRR/MM/DD');
    Ln_Numero            NUMBER := 0;
  BEGIN   
   
    IF Pd_FeEvaluaVigencia IS NOT NULL THEN
      Lv_FeProcesaVigencia:= TO_CHAR(Pd_FeEvaluaVigencia,'RRRR/MM/DD');      
    END IF;
    
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
    --Costo:14

   Lv_QuerySelect:='SELECT 
     GPROMO.ID_GRUPO_PROMOCION,
     GPROMO.NOMBRE_GRUPO,
     GPROMO.FE_INICIO_VIGENCIA,
     GPROMO.FE_FIN_VIGENCIA,
     GPROMO.FE_CREACION,
     GPROMO.EMPRESA_COD ';
   Lv_QueryFrom:='FROM 
     DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO, 
     DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPROMO,     
     DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
     DB_GENERAL.ADMI_PARAMETRO_DET DET ';
   Lv_QueryWhere:='WHERE
   CAB.NOMBRE_PARAMETRO                = :1 
   AND CAB.ESTADO                      = :2 
   AND DET.ESTADO                      = :3 
   AND DET.EMPRESA_COD                 = :4 
   AND DET.VALOR3                      = :5 
   AND CAB.ID_PARAMETRO                = DET.PARAMETRO_ID
   AND TPROMO.CODIGO_TIPO_PROMOCION    = DET.VALOR2  
   --
   AND TPROMO.GRUPO_PROMOCION_ID       = GPROMO.ID_GRUPO_PROMOCION  
   AND GPROMO.ESTADO                   in ( :6 , :7 )  
   AND TPROMO.ESTADO                   in ( :8 , :9 ) 
   AND GPROMO.EMPRESA_COD              = :10 ';

   IF Pn_IdPromocion IS NULL THEN
     Lv_QueryWhere := Lv_QueryWhere || ' AND (TO_DATE('''||Lv_FeProcesaVigencia||''',''RRRR/MM/DD'') 
      BETWEEN GPROMO.FE_INICIO_VIGENCIA
     AND GPROMO.FE_FIN_VIGENCIA ) ';
   END IF;

   IF Pn_IdPromocion IS NULL AND Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN                       
     Lv_QueryWhere := Lv_QueryWhere || ' AND NOT EXISTS (SELECT DBAGPR.ID_GRUPO_PROMOCION_REGLA 
                         FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA DBAGPR, 
                         DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                         WHERE DBAGPR.GRUPO_PROMOCION_ID     = GPROMO.ID_GRUPO_PROMOCION
                         AND DBAGPR.ESTADO                   != '''||Lv_EstadoEliminado||'''
                         AND DBAC.ID_CARACTERISTICA          = DBAGPR.CARACTERISTICA_ID
                         AND DBAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaracCodigo||'''
                         AND DBAC.ESTADO                     = '''||Lv_EstadoActivo||''' ) ';
   END IF;

   IF Pn_IdPromocion IS NULL AND Pv_CodigoGrupoPromocion IN ('PROM_INS','PROM_BW') THEN
     Lv_QueryWhere := Lv_QueryWhere || ' AND NOT EXISTS (SELECT DBATPR.ID_TIPO_PROMOCION_REGLA
                         FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA DBATPR, 
                         DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                         WHERE DBATPR.TIPO_PROMOCION_ID      = TPROMO.ID_TIPO_PROMOCION
                         AND DBATPR.ESTADO                   != '''||Lv_EstadoEliminado||'''
                         AND DBAC.ID_CARACTERISTICA          = DBATPR.CARACTERISTICA_ID
                         AND DBAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaracCodigo||'''
                         AND DBAC.ESTADO                     = '''||Lv_EstadoActivo||''' ) ';
   END IF;

   Lv_QueryGroupBy:='GROUP BY GPROMO.ID_GRUPO_PROMOCION,
   GPROMO.NOMBRE_GRUPO,
   GPROMO.FE_INICIO_VIGENCIA,
   GPROMO.FE_FIN_VIGENCIA,
   GPROMO.FE_CREACION,
   GPROMO.EMPRESA_COD';

   Lv_QueryOrderBy:=' ORDER BY TO_NUMBER(DET.VALOR4) ASC, GPROMO.FE_CREACION DESC, GPROMO.ID_GRUPO_PROMOCION DESC ';

   --Si es promo Mensual o Ancho de banda, obtengo los grupos promocionales que poseen en la regla PROM_TIPO_CLIENTE, el tipo de Proceso a 
   --a considerarse: Clientes Nuevos: NUEVOS  , Clientes Existentes: EXISTENTES, en base al Pv_TipoProceso recibido como parametro.
   IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
     --
     Lv_QuerySelect:=Lv_QuerySelect || ', GPRORE.VALOR AS TIPO_PROCESO ';
     Lv_QueryFrom:=Lv_QueryFrom || ', DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA GPRORE, DB_COMERCIAL.ADMI_CARACTERISTICA REG ';
     Lv_QueryWhere:=Lv_QueryWhere || ' 
   AND GPROMO.ID_GRUPO_PROMOCION       = GPRORE.GRUPO_PROMOCION_ID 
   AND GPRORE.CARACTERISTICA_ID        = REG.ID_CARACTERISTICA
   AND REG.DESCRIPCION_CARACTERISTICA  = '''||Lv_TipoCliente||''' 
   AND GPRORE.ESTADO                   != '''||Lv_EstadoEliminado||''' 
   AND INSTR(UPPER (GPRORE.VALOR),'''||Pv_TipoProceso||''') > '||Ln_Numero||' ';

     Lv_QueryGroupBy:=Lv_QueryGroupBy || ', GPRORE.VALOR ';
     --
   ELSIF Pv_CodigoGrupoPromocion = 'PROM_BW' THEN
     --
     Lv_QuerySelect:=Lv_QuerySelect || ', TPRORE.VALOR AS TIPO_PROCESO ';
     Lv_QueryFrom:=Lv_QueryFrom || ', DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA TPRORE, DB_COMERCIAL.ADMI_CARACTERISTICA REG ';
     Lv_QueryWhere:=Lv_QueryWhere || '
   AND TPROMO.ID_TIPO_PROMOCION       = TPRORE.TIPO_PROMOCION_ID 
   AND TPRORE.CARACTERISTICA_ID       = REG.ID_CARACTERISTICA
   AND REG.DESCRIPCION_CARACTERISTICA = '''||Lv_TipoCliente||''' 
   AND TPRORE.ESTADO                  != '''||Lv_EstadoEliminado||''' 
   AND INSTR(UPPER (TPRORE.VALOR),'''||Pv_TipoProceso||''') > '||Ln_Numero||' ';

     Lv_QueryGroupBy:=Lv_QueryGroupBy || ', TPRORE.VALOR ';
     --
   ELSE
     Lv_QuerySelect:=Lv_QuerySelect || ', '' ''  AS TIPO_PROCESO ';
   END IF;

   IF Pn_IdPromocion IS NOT NULL AND Pn_IdPromocion > 0 THEN
     Lv_QueryWhere:=Lv_QueryWhere || ' AND GPROMO.ID_GRUPO_PROMOCION = '||Pn_IdPromocion;
   END IF;

   Lv_QuerySelect:=Lv_QuerySelect || ', TO_NUMBER(DET.VALOR4) AS PRIORIDAD ';
   Lv_QueryGroupBy:=Lv_QueryGroupBy || ', TO_NUMBER(DET.VALOR4) ';

   Lv_Consulta:=Lv_QuerySelect||Lv_QueryFrom||Lv_QueryWhere||Lv_QueryGroupBy||Lv_QueryOrderBy;
     
   IF Lv_Consulta IS NULL THEN
      RAISE Le_Exception;
   END IF;

   OPEN Prf_GruposPromociones FOR Lv_Consulta using
   Lv_NombreParametro,
   Lv_EstadoActivo,
   Lv_EstadoActivo,
   Pv_CodEmpresa,
   Pv_CodigoGrupoPromocion,
   Lv_EstadoActivo,
   Lv_EstadoInactivo,
   Lv_EstadoActivo,
   Lv_EstadoInactivo,
   Pv_CodEmpresa;

  EXCEPTION
  WHEN Le_Exception THEN    
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
    Lv_MsjResultado := 'Ocurrio un error al obtener los Grupos de Promociones  del parametro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROMOCIONES', 
                                         Lv_Consulta || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );  
    Prf_GruposPromociones:=NULL;    
  WHEN OTHERS THEN
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
     Lv_MsjResultado := 'Ocurrio un error al obtener los Grupos de Promociones  del parametro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROMOCIONES', 
                                         Lv_Consulta || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );  
    Prf_GruposPromociones:=NULL;                      
  END P_OBTIENE_GRUPOS_PROMOCIONES;
  --
  --
  PROCEDURE P_OBTIENE_TIPOS_PROMOCIONES(Pn_IdGrupoPromocion      IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE DEFAULT NULL,
                                        Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Prf_TiposPromociones     OUT SYS_REFCURSOR,
                                        Pd_FeEvaluaVigencia      IN DATE DEFAULT NULL,
                                        Pv_TipoProceso           IN VARCHAR2 DEFAULT NULL,
                                        Pn_IdTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE DEFAULT NULL)
  IS    
    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';
    Lv_EstadoInactivo    VARCHAR2(15) := 'Inactivo';
    Lv_EstadoEliminado   VARCHAR2(15) := 'Eliminado';
    Lv_TipoCliente       VARCHAR2(20) := 'PROM_TIPO_CLIENTE';
    Lv_CaracCodigo       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PROM_CODIGO';
    Lv_NombreParametro   VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion        VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado      VARCHAR2(4000);  
    Lv_QuerySelect       VARCHAR2(4000);
    Lv_QueryFrom         VARCHAR2(4000); 
    Lv_QueryWhere        VARCHAR2(4000); 
    Lv_QueryOrderBy      VARCHAR2(4000); 
    Lv_Consulta          VARCHAR2(4000);
    Lv_FeProcesaVigencia VARCHAR2(15);
    Le_Exception         EXCEPTION;
  BEGIN
   IF Pd_FeEvaluaVigencia IS NOT NULL THEN
     Lv_FeProcesaVigencia:= TO_CHAR(Pd_FeEvaluaVigencia,'DD/MM/YYYY');
   ELSE
     Lv_FeProcesaVigencia:= TO_CHAR(SYSDATE,'DD/MM/YYYY');
   END IF;

   IF Prf_TiposPromociones%ISOPEN THEN
     CLOSE Prf_TiposPromociones;
   END IF;
    
   --Costo: 12
   Lv_QuerySelect := ' SELECT 
                       GPROMO.ID_GRUPO_PROMOCION,
                       GPROMO.NOMBRE_GRUPO,
                       GPROMO.FE_INICIO_VIGENCIA,
                       GPROMO.FE_FIN_VIGENCIA,
                       TPROMO.ID_TIPO_PROMOCION,
                       TPROMO.TIPO,
                       TPROMO.FE_CREACION,      
                       DET.VALOR2            AS CODIGO_TIPO_PROMOCION, 
                       DET.VALOR3            AS CODIGO_GRUPO_PROMOCION,
                       TO_NUMBER(DET.VALOR4) AS PRIORIDAD,
                       DET.EMPRESA_COD ';
   Lv_QueryFrom   := ' FROM 
                       DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO, 
                       DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPROMO,     
                       DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                       DB_GENERAL.ADMI_PARAMETRO_DET DET ';
   Lv_QueryWhere  := ' WHERE
                       CAB.NOMBRE_PARAMETRO                = :1     
                       AND CAB.ESTADO                      = :2    
                       AND DET.ESTADO                      = :3    
                       AND DET.EMPRESA_COD                 = :4
                       AND DET.VALOR3                      = :5
                       AND DET.EMPRESA_COD                 = '''||Pv_CodEmpresa||'''
                       AND CAB.ID_PARAMETRO                = DET.PARAMETRO_ID
                       AND TPROMO.CODIGO_TIPO_PROMOCION    = DET.VALOR2  
                       --
                       AND TPROMO.GRUPO_PROMOCION_ID       = GPROMO.ID_GRUPO_PROMOCION  
                       AND GPROMO.ESTADO                   IN ( :6 , :7 ) 
                       AND TPROMO.ESTADO                   IN ( :8 , :9 )
                       AND GPROMO.EMPRESA_COD              = :10 ';
    
   IF Pn_IdGrupoPromocion IS NULL THEN                       
     Lv_QueryWhere := Lv_QueryWhere || ' AND (TO_DATE('''||Lv_FeProcesaVigencia||''',''DD/MM/YYYY'')
                         BETWEEN GPROMO.FE_INICIO_VIGENCIA 
                         AND GPROMO.FE_FIN_VIGENCIA ) ';
   END IF;

   IF Pn_IdGrupoPromocion IS NULL AND Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN                       
     Lv_QueryWhere := Lv_QueryWhere || ' AND NOT EXISTS (SELECT DBAGPR.ID_GRUPO_PROMOCION_REGLA 
                         FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA DBAGPR, 
                         DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                         WHERE DBAGPR.GRUPO_PROMOCION_ID     = GPROMO.ID_GRUPO_PROMOCION
                         AND DBAGPR.ESTADO                   != '''||Lv_EstadoEliminado||'''
                         AND DBAC.ID_CARACTERISTICA          = DBAGPR.CARACTERISTICA_ID
                         AND DBAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaracCodigo||'''
                         AND DBAC.ESTADO                     = '''||Lv_EstadoActivo||''' ) ';
   END IF;

   IF Pn_IdGrupoPromocion IS NULL AND Pv_CodigoGrupoPromocion IN ('PROM_INS','PROM_BW') THEN
     Lv_QueryWhere := Lv_QueryWhere || ' AND NOT EXISTS (SELECT DBATPR.ID_TIPO_PROMOCION_REGLA  
                         FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA DBATPR, 
                         DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                         WHERE DBATPR.TIPO_PROMOCION_ID      = TPROMO.ID_TIPO_PROMOCION
                         AND DBATPR.ESTADO                   != '''||Lv_EstadoEliminado||'''
                         AND DBAC.ID_CARACTERISTICA          = DBATPR.CARACTERISTICA_ID
                         AND DBAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaracCodigo||'''
                         AND DBAC.ESTADO                     = '''||Lv_EstadoActivo||''' ) ';
   END IF;

   IF Pn_IdTipoPromocion IS NOT NULL AND Pn_IdTipoPromocion > 0 THEN
     Lv_QueryWhere  := Lv_QueryWhere || ' AND TPROMO.ID_TIPO_PROMOCION = '|| Pn_IdTipoPromocion ;
   END IF;
   
   Lv_QueryOrderBy := ' ORDER BY  TO_NUMBER(DET.VALOR4) ASC, GPROMO.FE_CREACION DESC, GPROMO.ID_GRUPO_PROMOCION DESC ';
                        
   IF Pn_IdGrupoPromocion IS NOT NULL THEN
     Lv_QueryWhere  := Lv_QueryWhere || ' AND GPROMO.ID_GRUPO_PROMOCION = '|| Pn_IdGrupoPromocion ;
   END IF;

   IF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso IS NOT NULL THEN
   --
     Lv_QueryFrom   := Lv_QueryFrom || ', DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA GPRORE, DB_COMERCIAL.ADMI_CARACTERISTICA REG ';
     Lv_QueryWhere  := Lv_QueryWhere || ' AND GPROMO.ID_GRUPO_PROMOCION       = GPRORE.GRUPO_PROMOCION_ID 
                                          AND GPRORE.CARACTERISTICA_ID        = REG.ID_CARACTERISTICA
                                          AND REG.DESCRIPCION_CARACTERISTICA  = '''||Lv_TipoCliente||''' 
                                          AND GPRORE.ESTADO                   != '''||Lv_EstadoEliminado||''' 
                                          AND REGEXP_LIKE(UPPER(GPRORE.VALOR), '''||Pv_TipoProceso||''') ';
   --
   END IF;

   Lv_Consulta := Lv_QuerySelect||Lv_QueryFrom||Lv_QueryWhere||Lv_QueryOrderBy;

   IF Lv_Consulta IS NULL THEN
      RAISE Le_Exception;
   END IF;

   OPEN Prf_TiposPromociones FOR Lv_Consulta using
   Lv_NombreParametro,
   Lv_EstadoActivo,
   Lv_EstadoActivo,
   Pv_CodEmpresa,
   Pv_CodigoGrupoPromocion,
   Lv_EstadoActivo,
   Lv_EstadoInactivo,
   Lv_EstadoActivo,
   Lv_EstadoInactivo,
   Pv_CodEmpresa;

  EXCEPTION
  WHEN OTHERS THEN
    IF Prf_TiposPromociones%ISOPEN THEN
      CLOSE Prf_TiposPromociones;
    END IF;
     Lv_MsjResultado := 'Ocurrio un error al obtener los Tipos de Promociones  del parametro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_TIPOS_PROMOCIONES', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );    
    Prf_TiposPromociones:=NULL;               
  END P_OBTIENE_TIPOS_PROMOCIONES;
  --
  --
  PROCEDURE P_OBTIENE_SERVICIOS_PROCESAR(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoProceso          IN VARCHAR2,                                        
                                         Pa_ServiciosProcesar    OUT T_ServiciosProcesar,
                                         Pv_EstadoServicio       IN VARCHAR2,
                                         Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                         Pv_Codigo               IN VARCHAR2 DEFAULT NULL,
                                         Pv_EsContrato           IN VARCHAR2 DEFAULT NULL,
                                         Pv_Alcance              IN VARCHAR2 DEFAULT NULL)
  IS
  
    CURSOR C_HoraJobCliNuev(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                            Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                            Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                            Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT APD.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APD.EMPRESA_COD        = Cv_CodEmpresa
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro;

    Lv_EstadoActivo       VARCHAR2(15) := 'Activo';
    Lv_DescripcionRol     VARCHAR2(15) := 'Cliente';
    Lv_EsVenta            VARCHAR2(1)  := 'S';
    Ln_Frecuencia         NUMBER:=1;  
    Ln_Numero             NUMBER:=0;
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(2000); 
    Lv_Consulta           CLOB;
    Lv_CadenaQuery        CLOB;
    Lv_CadenaFrom         CLOB;
    Lv_CadenaWhere        CLOB;
    Lv_CadenaOrdena       CLOB; 
    Lrf_ServiciosProcesar SYS_REFCURSOR; 
    Lr_Servicios          Lr_ServiciosProcesar; 
    La_ServiciosProcesar  T_ServiciosProcesar;  
    Ln_Indice             NUMBER:=1; 
    Ln_Indx               NUMBER;
    Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_HORA_EJECUCION_JOB';
    Lv_Descripcion        DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_HORA_EJECUCION_JOB_CLI_NUEV';
    Lv_Hora               VARCHAR2(10);
    Ld_FechaAnterior      DATE := SYSDATE - 1 ;
    Ld_FechaAlcance       DATE := SYSDATE;
    Lv_fechaJob           VARCHAR2(100);
    LV_DESCCARACTERISTICA VARCHAR2(2000);

  BEGIN
    --Costo query obtiene servicios cliente Nuevo: 15
    --Costo query obtiene servicios cliente Existente: 14   
    Lv_CadenaQuery:='SELECT
      DISTINCT
      ISE.ID_SERVICIO,
      IP.ID_PUNTO,       
      ISE.PLAN_ID     AS ID_PLAN,
      ISE.PRODUCTO_ID AS ID_PRODUCTO,  
      NULL            AS PLAN_ID_SUPERIOR,
      ISE.ESTADO      AS ESTADO ';

    Lv_CadenaFrom:=' FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPE,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AR ';

    Lv_CadenaWhere:=' WHERE 

      ISE.CANTIDAD                   > :1
      AND IER.EMPRESA_COD            = :2
      AND ISE.ES_VENTA               = :3
      AND ISE.PRECIO_VENTA           > :4
      AND ISE.FRECUENCIA_PRODUCTO    = :5      
      AND IP.ID_PUNTO                = :6 
      AND IP.ID_PUNTO                = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL        = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA             = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL         = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                  = IER.ROL_ID
      AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PLAN_EMP_PYME(ISE.ID_SERVICIO) = ''S''
      AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(ISE.ID_SERVICIO) = ''S''
      AND NOT EXISTS (  
          SELECT ''X'' AS EXISTE 
          FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DBIDMP  
          WHERE DBIDMP.ID_DETALLE_MAPEO IN (SELECT NVL(MAX(IDMP.ID_DETALLE_MAPEO),0) AS ID_DETALLE_MAPEO 
                                          FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP 
                                          WHERE IDMP.ID_DETALLE_MAPEO IN (SELECT IDMS.DETALLE_MAPEO_ID 
                                                                          FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
                                                                          WHERE IDMS.SERVICIO_ID = ISE.ID_SERVICIO) 
                                          AND IDMP.EMPRESA_COD = '''||Pv_CodEmpresa||'''
                                          AND IDMP.TIPO_PROMOCION IN (SELECT DET.VALOR2 
                                                       FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                         DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                       WHERE CAB.NOMBRE_PARAMETRO = ''PROM_TIPO_PROMOCIONES''
                                                       AND CAB.ESTADO             = '''||Lv_EstadoActivo||'''
                                                       AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                       AND DET.VALOR3             = '''||Pv_CodigoGrupoPromocion||'''
                                                       AND DET.EMPRESA_COD        = '''||Pv_CodEmpresa||'''
                                                       AND DET.ESTADO             = '''||Lv_EstadoActivo||''')
                                         )
        AND ((DBIDMP.INDEFINIDO IS NOT NULL AND DBIDMP.ESTADO != ''Baja'')
            OR ((DBIDMP.ESTADO = '''||Lv_EstadoActivo||''' OR (DBIDMP.ESTADO != ''Baja'' AND 
                DBIDMP.CANTIDAD_PERIODOS > DBIDMP.MAPEOS_GENERADOS)))))
      ';

    IF UPPER(TRIM(Pv_EsContrato)) = 'S' AND TRIM(Pv_EsContrato) IS NOT NULL THEN
      Lv_CadenaWhere := Lv_CadenaWhere || ' AND UPPER(AR.DESCRIPCION_ROL) IN ( SELECT UPPER(APD.VALOR1) AS VALOR1
                                                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                                                  DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                                                WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                                                                AND APD.ESTADO           = '''||Lv_EstadoActivo||'''
                                                                                AND APC.NOMBRE_PARAMETRO = ''PROM_ROLES_CLIENTES''
                                                                                AND APC.ESTADO           = '''||Lv_EstadoActivo||''' 
                                                                                AND APD.EMPRESA_COD      = '''||Pv_CodEmpresa||''') ';    
    ELSE
      Lv_CadenaWhere := Lv_CadenaWhere || ' AND AR.DESCRIPCION_ROL = '''||Lv_DescripcionRol||''' ';
    END IF;

    IF TRIM(Pv_EsCodigo) IS NOT NULL AND UPPER(TRIM(Pv_EsCodigo)) = 'S' AND TRIM(Pv_Codigo) IS NOT NULL THEN

      IF Pv_TipoProceso = 'NUEVO' THEN
        LV_DESCCARACTERISTICA := 'PROM_COD_NUEVO';
      ELSE
        LV_DESCCARACTERISTICA := 'PROM_COD_EXISTENTE';
      END IF;

      Lv_CadenaWhere := Lv_CadenaWhere || ' AND EXISTS (SELECT DBISER.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO DBISER,
          DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
          DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
        WHERE DBISER.ID_SERVICIO            = ISE.ID_SERVICIO
        AND DBISC.SERVICIO_ID               = DBISER.ID_SERVICIO
        AND DBISC.ESTADO                    = ''Activo''
        AND DBAC.ID_CARACTERISTICA          = DBISC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = '''||LV_DESCCARACTERISTICA||'''
        AND DBISC.VALOR                     = '''||Pv_Codigo||''') ';      
    END IF;

    Lv_CadenaOrdena:=' ORDER BY ISE.ID_SERVICIO ASC'; 


    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso = 'NUEVO' THEN   
      --
      IF UPPER(TRIM(Pv_EsContrato)) = 'S' AND TRIM(Pv_EsContrato) IS NOT NULL THEN
        Lv_CadenaWhere:= Lv_CadenaWhere || '
        AND UPPER(ISE.ESTADO) NOT IN ( SELECT UPPER(APD.VALOR1) AS VALOR1
                                       FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                         DB_GENERAL.ADMI_PARAMETRO_DET APD
                                       WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                       AND APD.ESTADO           = '''||Lv_EstadoActivo||'''
                                       AND APC.NOMBRE_PARAMETRO = ''PROM_ESTADOS_BAJA_SERV''
                                       AND APC.ESTADO           = '''||Lv_EstadoActivo||''' 
                                       AND APD.EMPRESA_COD      = '''||Pv_CodEmpresa||''') ';      
      ELSE
      --
        IF Pv_Alcance = 'ALCANCE' THEN
          Lv_Descripcion := 'PROM_HORA_ALCANCE_JOB_CLI_NUEV';
        END IF;
        
        IF C_HoraJobCliNuev%ISOPEN THEN
          CLOSE C_HoraJobCliNuev;
        END IF;

        BEGIN
          OPEN C_HoraJobCliNuev(Lv_NombreParametro,
                                Lv_Descripcion,
                                Lv_EstadoActivo,
                                Pv_CodEmpresa);
          FETCH C_HoraJobCliNuev INTO Lv_Hora;
          CLOSE C_HoraJobCliNuev;
        EXCEPTION
          WHEN OTHERS THEN
          IF Pv_Alcance = 'ALCANCE' THEN
            Lv_Hora := ' 21:20:00';
          ELSE
            Lv_Hora := ' 23:20:00';
          END IF;
        END;

        IF Pv_Alcance = 'ALCANCE' THEN
          Lv_fechaJob   := Ld_FechaAlcance|| Lv_Hora ;
        ELSE
          Lv_fechaJob   := Ld_FechaAnterior || Lv_Hora ;
        END IF;
      
        Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ';
        Lv_CadenaWhere:= Lv_CadenaWhere || '
        AND ISE.ID_SERVICIO = ISH.SERVICIO_ID 
        AND ISE.ESTADO ='''||Lv_EstadoActivo||''' 
        AND (UPPER(dbms_lob.substr(ISH.OBSERVACION)) LIKE ''%CONFIRMO%'' 
        OR ISH.ACCION  = ''confirmarServicio'' )
        AND ISH.FE_CREACION >= TO_DATE('''|| Lv_fechaJob ||''',''DD-MM-RRRR HH24:MI:SS'')
        AND ISH.FE_CREACION <= SYSDATE 
        AND ISH.ESTADO ='''||Lv_EstadoActivo||'''    
        ';
      --
      END IF;
      --
    ELSIF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso = 'EXISTENTE'  THEN
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND REGEXP_LIKE(NVL('''||Pv_EstadoServicio||''', '''||Lv_EstadoActivo||'''),ISE.ESTADO)  ';    
      --
    ELSE
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND ISE.ESTADO ='''||Lv_EstadoActivo||''' ';
      --
    END IF;

    Lv_Consulta:=Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdena;        

    Pa_ServiciosProcesar.DELETE();  
    IF Lrf_ServiciosProcesar%ISOPEN THEN
      CLOSE Lrf_ServiciosProcesar;
    END IF;

    La_ServiciosProcesar.DELETE();
    OPEN Lrf_ServiciosProcesar FOR Lv_Consulta using 
    Ln_Numero,
    Pv_CodEmpresa,
    Lv_EsVenta,
    Ln_Numero,
    Ln_Frecuencia,
    Pn_IdPunto;   

    LOOP
      FETCH Lrf_ServiciosProcesar BULK COLLECT INTO La_ServiciosProcesar LIMIT 100;       
      Ln_Indx:=La_ServiciosProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP  
        Lr_Servicios := La_ServiciosProcesar(Ln_Indx);
        Ln_Indx  := La_ServiciosProcesar.NEXT(Ln_Indx);       
        Pa_ServiciosProcesar(Ln_Indice).ID_SERVICIO:=Lr_Servicios.ID_SERVICIO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PUNTO:=Lr_Servicios.ID_PUNTO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PLAN:=Lr_Servicios.ID_PLAN;
        Pa_ServiciosProcesar(Ln_Indice).ID_PRODUCTO:=Lr_Servicios.ID_PRODUCTO;
        Pa_ServiciosProcesar(Ln_Indice).PLAN_ID_SUPERIOR:=Lr_Servicios.PLAN_ID_SUPERIOR;
        Pa_ServiciosProcesar(Ln_Indice).ESTADO:=Lr_Servicios.ESTADO;
        Ln_Indice:=Ln_Indice + 1;
      END LOOP;
      EXIT WHEN Lrf_ServiciosProcesar%NOTFOUND; 
    END LOOP;
    CLOSE Lrf_ServiciosProcesar;      

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrio un error al obtener los servicios del punto cliente para el Proceso de Mapeo de Promociones ' || 
                       'para el Grupo Promocional: '||Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso|| ' ID_PUNTO: '|| Pn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_SERVICIOS_PROCESAR', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    Pa_ServiciosProcesar.DELETE();                  
  END P_OBTIENE_SERVICIOS_PROCESAR;
  --
  --
  FUNCTION F_GET_PROMO_GRUPO_REGLA(Fn_IdGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
  RETURN Lr_GrupoPromoReglaProcesar
  IS
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(2000); 
    Lv_EstadoEliminado    VARCHAR2(15) := 'Eliminado';
  --
  -- Costo: 8
    CURSOR C_GetPromoGrupoRegla (Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Cv_EstadoEliminado  DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.ESTADO%TYPE)
    IS
      SELECT GRUPO_PROMO_REGLA.*,GRUPO_PROMO.NOMBRE_GRUPO,GRUPO_PROMO.FE_INICIO_VIGENCIA,GRUPO_PROMO.FE_FIN_VIGENCIA,GRUPO_PROMO.FE_CREACION 
      FROM (SELECT *
            FROM
           (
            SELECT GPROMO.ID_GRUPO_PROMOCION,
              REGPRO.DESCRIPCION_CARACTERISTICA,
              GPROMORE.VALOR
            FROM 
              DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPROMO,
              DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA GPROMORE,
              DB_COMERCIAL.ADMI_CARACTERISTICA  REGPRO
            WHERE GPROMO.ID_GRUPO_PROMOCION= Cn_IdGrupoPromocion 
            AND GPROMO.ID_GRUPO_PROMOCION  = GPROMORE.GRUPO_PROMOCION_ID
            AND GPROMORE.CARACTERISTICA_ID = REGPRO.ID_CARACTERISTICA
            AND GPROMORE.ESTADO            != Cv_EstadoEliminado            
            AND REGPRO.DESCRIPCION_CARACTERISTICA IN ('PROM_ESTADO_SERVICIO','PROM_FORMA_PAGO','PROM_EMISOR','PROM_TIPO_CLIENTE')
           ) PIVOT ( MAX ( VALOR )
                    FOR DESCRIPCION_CARACTERISTICA
                    IN ( 'PROM_ESTADO_SERVICIO' PROM_ESTADO_SERVICIO,'PROM_FORMA_PAGO' PROM_FORMA_PAGO,'PROM_EMISOR' PROM_EMISOR,
                         'PROM_TIPO_CLIENTE' PROM_TIPO_CLIENTE)

                  )
           ) GRUPO_PROMO_REGLA , DB_COMERCIAL.ADMI_GRUPO_PROMOCION GRUPO_PROMO 
    WHERE GRUPO_PROMO_REGLA.ID_GRUPO_PROMOCION=GRUPO_PROMO.ID_GRUPO_PROMOCION
    ;
  --
  Lr_GetPromoGrupoRegla C_GetPromoGrupoRegla%ROWTYPE;
  --
  BEGIN
  --
  IF C_GetPromoGrupoRegla%ISOPEN THEN
    --
    CLOSE C_GetPromoGrupoRegla;
    --
  END IF;
  --
  OPEN C_GetPromoGrupoRegla(Fn_IdGrupoPromocion,Lv_EstadoEliminado);
  --
  FETCH
    C_GetPromoGrupoRegla
  INTO
    Lr_GetPromoGrupoRegla;
  --
  CLOSE C_GetPromoGrupoRegla;
  --
  RETURN Lr_GetPromoGrupoRegla;
  --
  EXCEPTION
  WHEN OTHERS THEN
    --
    IF C_GetPromoGrupoRegla%ISOPEN THEN
    --
    CLOSE C_GetPromoGrupoRegla;
    --
    END IF; 
    Lv_MsjResultado := 'Ocurrio un error al obtener las reglas del Grupo Promocion ID_GRUPO_PROMOCION: ' || Fn_IdGrupoPromocion; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_GET_PROMO_GRUPO_REGLA', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );      
    Lr_GetPromoGrupoRegla:=NULL;             
  END F_GET_PROMO_GRUPO_REGLA;
  --
  --
  FUNCTION F_GET_PROMO_TIPO_REGLA(Fn_IdTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
  RETURN Lr_TipoPromoReglaProcesar
  IS
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(2000); 
    Lv_EstadoEliminado    VARCHAR2(15) := 'Eliminado';
  --
  -- Costo: 9
    CURSOR C_GetPromoTipoRegla (Cn_IdTipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                Cv_EstadoEliminado DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.ESTADO%TYPE)
    IS
      SELECT GRUPO_PROMO.ID_GRUPO_PROMOCION,
        GRUPO_PROMO.NOMBRE_GRUPO,
        GRUPO_PROMO.FE_INICIO_VIGENCIA,
        GRUPO_PROMO.FE_FIN_VIGENCIA, 
        TIPO_PROMO.CODIGO_TIPO_PROMOCION,
        TIPO_PROMO.TIPO,
        TIPO_PROMO.FE_CREACION,
        TIPO_PROMO_REGLA.* FROM (SELECT *
      FROM (
            SELECT TPROMO.ID_TIPO_PROMOCION,
              REGPRO.DESCRIPCION_CARACTERISTICA,
              TPROMORE.VALOR
            FROM 
              ADMI_TIPO_PROMOCION TPROMO,
              ADMI_TIPO_PROMOCION_REGLA TPROMORE,
              ADMI_CARACTERISTICA  REGPRO
            WHERE  TPROMO.ID_TIPO_PROMOCION      = Cn_IdTipoPromocion
            AND TPROMO.ID_TIPO_PROMOCION         = TPROMORE.TIPO_PROMOCION_ID
            AND TPROMORE.CARACTERISTICA_ID       = REGPRO.ID_CARACTERISTICA
            AND TPROMORE.ESTADO                  != Cv_EstadoEliminado
            AND REGPRO.DESCRIPCION_CARACTERISTICA IN ('PROM_ESTADO_SERVICIO',
            'PROM_ULTIMA_MILLA',
            'PROM_PERMANENCIA_MINIMA',
            'PROM_PIERDE_PROMOCION_MORA',
            'PROM_EMISOR',
            'PROM_DESCUENTO',
            'PROM_FORMA_PAGO',
            'PROM_ANTIGUEDAD',
            'PROM_PERIODO',
            'PROM_PROMOCION_INDEFINIDA',
            'PROM_TIPO_NEGOCIO',
            'PROM_TIPO_PERIODO',
            'PROM_DIAS_MORA',
            'PROM_TIPO_CLIENTE',
            'PROM_INVALIDA_PROMO')
            ) PIVOT ( MAX ( VALOR )
                  FOR DESCRIPCION_CARACTERISTICA
                  IN ( 'PROM_ESTADO_SERVICIO' PROM_ESTADO_SERVICIO,
                       'PROM_ULTIMA_MILLA' PROM_ULTIMA_MILLA,
                       'PROM_PERMANENCIA_MINIMA' PROM_PERMANENCIA_MINIMA,
                       'PROM_PIERDE_PROMOCION_MORA' PROM_PIERDE_PROMOCION_MORA,
                       'PROM_EMISOR' PROM_EMISOR,
                       'PROM_DESCUENTO' PROM_DESCUENTO,
                       'PROM_FORMA_PAGO' PROM_FORMA_PAGO,
                       'PROM_ANTIGUEDAD' PROM_ANTIGUEDAD,
                       'PROM_PERIODO' PROM_PERIODO,
                       'PROM_PROMOCION_INDEFINIDA' PROM_PROMOCION_INDEFINIDA,
                       'PROM_TIPO_NEGOCIO' PROM_TIPO_NEGOCIO,
                       'PROM_TIPO_PERIODO' PROM_TIPO_PERIODO,
                       'PROM_DIAS_MORA' PROM_DIAS_MORA,
                       'PROM_TIPO_CLIENTE' PROM_TIPO_CLIENTE,
                       'PROM_INVALIDA_PROMO' PROM_INVALIDA_PROMO)                                    
             )) TIPO_PROMO_REGLA , ADMI_TIPO_PROMOCION TIPO_PROMO,
                ADMI_GRUPO_PROMOCION GRUPO_PROMO
      WHERE TIPO_PROMO_REGLA.ID_TIPO_PROMOCION=TIPO_PROMO.ID_TIPO_PROMOCION
      AND TIPO_PROMO.GRUPO_PROMOCION_ID = GRUPO_PROMO.ID_GRUPO_PROMOCION;

  Lr_GetPromoTipoRegla C_GetPromoTipoRegla%ROWTYPE;
  --
  BEGIN
  --
  IF C_GetPromoTipoRegla%ISOPEN THEN
    --
    CLOSE C_GetPromoTipoRegla;
    --
  END IF;
  --
  OPEN C_GetPromoTipoRegla(Fn_IdTipoPromocion,Lv_EstadoEliminado);
  --
  FETCH
    C_GetPromoTipoRegla
  INTO
    Lr_GetPromoTipoRegla;
  --
  CLOSE C_GetPromoTipoRegla;
  --
  RETURN Lr_GetPromoTipoRegla;
  --
  EXCEPTION
  WHEN OTHERS THEN
    --
    IF C_GetPromoTipoRegla%ISOPEN THEN
    --
    CLOSE C_GetPromoTipoRegla;
    --
    END IF;
    Lv_MsjResultado := 'Ocurrio un error al obtener las reglas del Tipo Promocion ID_TIPO_PROMOCION: ' || Fn_IdTipoPromocion; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );  
    Lr_GetPromoTipoRegla:=NULL; 
    RETURN Lr_GetPromoTipoRegla;               
  END F_GET_PROMO_TIPO_REGLA;

  --
  --
  FUNCTION F_GET_PROMO_SECTORIZACION(Fn_IdGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
  RETURN T_SectorizacionProcesar
  IS
    Lv_IpCreacion              VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado            VARCHAR2(2000); 
    La_SectorizacionProcesar   T_SectorizacionProcesar;
    Ln_Indice                  NUMBER:=1;
    Lr_Sectorizacion           Lr_SectorizacionProcesar;
    Lv_EstadoEliminado         VARCHAR2(15) := 'Eliminado';
  --
  -- Costo: 5
    CURSOR C_GetSectorizacionPorGrupo (Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                       Cv_EstadoEliminado  DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.ESTADO%TYPE)
    IS
    SELECT NVL(SECTORIZACION.ID_SECTORIZACION,'0') AS ID_SECTORIZACION,
      SECTORIZACION.ID_JURISDICCION,
      (SELECT AJ.NOMBRE_JURISDICCION
       FROM ADMI_JURISDICCION AJ
       WHERE
       AJ.ID_JURISDICCION = SECTORIZACION.ID_JURISDICCION
      ) DESCRIPCION_JURISDICCION,
      NVL(SECTORIZACION.ID_CANTON,'0') AS ID_CANTON,
      (SELECT AC.NOMBRE_CANTON
       FROM ADMI_CANTON AC
       WHERE
       AC.ID_CANTON = SECTORIZACION.ID_CANTON
      ) NOMBRE_CANTON,
      NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA,
      (SELECT AP.NOMBRE_PARROQUIA
       FROM ADMI_PARROQUIA AP
       WHERE
       AP.ID_PARROQUIA = SECTORIZACION.ID_PARROQUIA
      ) NOMBRE_PARROQUIA,
      NVL(SECTORIZACION.ID_SECTOR,'0')   AS ID_SECTOR,
      NVL(SECTORIZACION.ID_ELEMENTO,'0') AS ID_ELEMENTO,
      NVL(SECTORIZACION.ID_EDIFICIO,'0') AS ID_EDIFICIO
     FROM ( SELECT *
            FROM ( SELECT AC.DESCRIPCION_CARACTERISTICA,
                     AGPR.VALOR,
                     AGPR.SECUENCIA ID_SECTORIZACION
                   FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION     AGP,
                     DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA  AGPR,
                     DB_COMERCIAL.ADMI_CARACTERISTICA         AC
                   WHERE AGP.ID_GRUPO_PROMOCION = Cn_IdGrupoPromocion
                   AND AGP.ID_GRUPO_PROMOCION   = AGPR.GRUPO_PROMOCION_ID
                   AND AC.ID_CARACTERISTICA     = AGPR.CARACTERISTICA_ID
                   AND AC.DESCRIPCION_CARACTERISTICA 
                   IN ('PROM_JURISDICCION',
                       'PROM_CANTON',
                       'PROM_PARROQUIA',
                       'PROM_SECTOR',
                       'PROM_ELEMENTO',
                       'PROM_EDIFICIO')
                   AND AGPR.SECUENCIA IS NOT NULL
                   AND AGPR.ESTADO    !=Cv_EstadoEliminado
                 ) PIVOT ( MAX ( VALOR )
                          FOR DESCRIPCION_CARACTERISTICA
                          IN ( 'PROM_JURISDICCION' ID_JURISDICCION, 
                               'PROM_CANTON' ID_CANTON, 
                               'PROM_PARROQUIA' ID_PARROQUIA, 
                               'PROM_SECTOR' ID_SECTOR, 
                               'PROM_ELEMENTO' ID_ELEMENTO,
                               'PROM_EDIFICIO' ID_EDIFICIO)
                             )
                         ) SECTORIZACION;

   --
   -- Costo: 7
    CURSOR C_GetSectorizacionPorTipo (Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                      Cv_EstadoEliminado  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.ESTADO%TYPE)
    IS
    SELECT NVL(SECTORIZACION.ID_SECTORIZACION,'0') AS ID_SECTORIZACION,
      SECTORIZACION.ID_JURISDICCION,
      (SELECT AJ.NOMBRE_JURISDICCION
       FROM ADMI_JURISDICCION AJ
       WHERE
         AJ.ID_JURISDICCION = SECTORIZACION.ID_JURISDICCION
      ) DESCRIPCION_JURISDICCION,
      NVL(SECTORIZACION.ID_CANTON,'0') AS ID_CANTON,
      (SELECT AC.NOMBRE_CANTON
       FROM ADMI_CANTON AC
       WHERE
         AC.ID_CANTON = SECTORIZACION.ID_CANTON
      ) NOMBRE_CANTON,
      NVL(SECTORIZACION.ID_PARROQUIA,'0')AS ID_PARROQUIA,
      (SELECT AP.NOMBRE_PARROQUIA
       FROM ADMI_PARROQUIA AP
       WHERE
         AP.ID_PARROQUIA = SECTORIZACION.ID_PARROQUIA
      ) NOMBRE_PARROQUIA,
      NVL(SECTORIZACION.ID_SECTOR,'0')   AS ID_SECTOR,
      NVL(SECTORIZACION.ID_ELEMENTO,'0') AS ID_ELEMENTO,
      NVL(SECTORIZACION.ID_EDIFICIO,'0') AS ID_EDIFICIO
      FROM ( SELECT *
             FROM ( SELECT AC.DESCRIPCION_CARACTERISTICA,
                      ATPR.VALOR,
                      ATPR.SECUENCIA ID_SECTORIZACION
                    FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION     AGP,
                      DB_COMERCIAL.ADMI_TIPO_PROMOCION         ATP,
                      DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA   ATPR,
                      DB_COMERCIAL.ADMI_CARACTERISTICA         AC
                    WHERE AGP.ID_GRUPO_PROMOCION      = Cn_IdGrupoPromocion
                    AND AGP.ID_GRUPO_PROMOCION        = ATP.GRUPO_PROMOCION_ID 
                    AND ATP.ID_TIPO_PROMOCION         = ATPR.TIPO_PROMOCION_ID
                    AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
                    AND AC.DESCRIPCION_CARACTERISTICA 
                    IN ('PROM_JURISDICCION',
                        'PROM_CANTON',
                        'PROM_PARROQUIA',
                        'PROM_SECTOR',
                        'PROM_ELEMENTO',
                        'PROM_EDIFICIO')
                    AND ATPR.SECUENCIA IS NOT NULL
                    AND ATPR.ESTADO    !=Cv_EstadoEliminado
                  ) PIVOT ( MAX ( VALOR )
                            FOR DESCRIPCION_CARACTERISTICA
                            IN ( 'PROM_JURISDICCION' ID_JURISDICCION, 
                                 'PROM_CANTON' ID_CANTON, 
                                 'PROM_PARROQUIA' ID_PARROQUIA, 
                                 'PROM_SECTOR' ID_SECTOR, 
                                 'PROM_ELEMENTO' ID_ELEMENTO,
                                 'PROM_EDIFICIO' ID_EDIFICIO)
                               )
                          ) SECTORIZACION;

  BEGIN
  --
  FOR Lr_Sectorizacion IN C_GetSectorizacionPorGrupo(Fn_IdGrupoPromocion,Lv_EstadoEliminado)
  LOOP   
    La_SectorizacionProcesar(Ln_Indice).ID_SECTORIZACION:=Lr_Sectorizacion.ID_SECTORIZACION;
    La_SectorizacionProcesar(Ln_Indice).ID_JURISDICCION:=Lr_Sectorizacion.ID_JURISDICCION;
    La_SectorizacionProcesar(Ln_Indice).DESCRIPCION_JURISDICCION:=Lr_Sectorizacion.DESCRIPCION_JURISDICCION;
    La_SectorizacionProcesar(Ln_Indice).ID_CANTON:=Lr_Sectorizacion.ID_CANTON;
    La_SectorizacionProcesar(Ln_Indice).NOMBRE_CANTON:=Lr_Sectorizacion.NOMBRE_CANTON;
    La_SectorizacionProcesar(Ln_Indice).ID_PARROQUIA:=Lr_Sectorizacion.ID_PARROQUIA;
    La_SectorizacionProcesar(Ln_Indice).NOMBRE_PARROQUIA:=Lr_Sectorizacion.NOMBRE_PARROQUIA;
    La_SectorizacionProcesar(Ln_Indice).ID_SECTOR:=Lr_Sectorizacion.ID_SECTOR;
    La_SectorizacionProcesar(Ln_Indice).ID_ELEMENTO:=Lr_Sectorizacion.ID_ELEMENTO;
    La_SectorizacionProcesar(Ln_Indice).ID_EDIFICIO:=Lr_Sectorizacion.ID_EDIFICIO;
    Ln_Indice:=Ln_Indice + 1;
  END LOOP; 

  IF La_SectorizacionProcesar.COUNT = 0 THEN
    FOR Lr_Sectorizacion IN C_GetSectorizacionPorTipo(Fn_IdGrupoPromocion,Lv_EstadoEliminado)
    LOOP      
      La_SectorizacionProcesar(Ln_Indice).ID_SECTORIZACION:=Lr_Sectorizacion.ID_SECTORIZACION;
      La_SectorizacionProcesar(Ln_Indice).ID_JURISDICCION:=Lr_Sectorizacion.ID_JURISDICCION;
      La_SectorizacionProcesar(Ln_Indice).DESCRIPCION_JURISDICCION:=Lr_Sectorizacion.DESCRIPCION_JURISDICCION;
      La_SectorizacionProcesar(Ln_Indice).ID_CANTON:=Lr_Sectorizacion.ID_CANTON;
      La_SectorizacionProcesar(Ln_Indice).NOMBRE_CANTON:=Lr_Sectorizacion.NOMBRE_CANTON;
      La_SectorizacionProcesar(Ln_Indice).ID_PARROQUIA:=Lr_Sectorizacion.ID_PARROQUIA;
      La_SectorizacionProcesar(Ln_Indice).NOMBRE_PARROQUIA:=Lr_Sectorizacion.NOMBRE_PARROQUIA;
      La_SectorizacionProcesar(Ln_Indice).ID_SECTOR:=Lr_Sectorizacion.ID_SECTOR;
      La_SectorizacionProcesar(Ln_Indice).ID_ELEMENTO:=Lr_Sectorizacion.ID_ELEMENTO;
      La_SectorizacionProcesar(Ln_Indice).ID_EDIFICIO:=Lr_Sectorizacion.ID_EDIFICIO;
      Ln_Indice:=Ln_Indice + 1;
    END LOOP;    
  END IF;

  RETURN La_SectorizacionProcesar;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrio un error al obtener la Sectorización del Grupo Promocional ID_GRUPO_PROMOCION: ' || Fn_IdGrupoPromocion; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );                   
  END F_GET_PROMO_SECTORIZACION;
  --
  --  
  FUNCTION F_GET_TIPO_PROMO_PLAN_PROD(Fn_IdTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
  RETURN T_TipoPromoPlanProdProcesar
  IS
    Lv_IpCreacion                  VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado                VARCHAR2(2000); 
    La_TipoPromoPlanProdProcesar   T_TipoPromoPlanProdProcesar;
    Ln_Indice                      NUMBER:=1;
    Lr_TipoPromoPlanProd           Lr_TipoPromoPlanProdProcesar;
    Lv_EstadoEliminado             VARCHAR2(15) := 'Eliminado';
    --
    -- Costo: 5
    CURSOR C_GetPlanProdPorTipoPromo(Cn_IdTipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                     Cv_EstadoEliminado DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.ESTADO%TYPE)
    IS   
    SELECT 
      PROMOPLANPROD.TIPO_PROMOCION_ID AS ID_TIPO_PROMOCION,
      TPROM.CODIGO_TIPO_PROMOCION,
      PROMOPLANPROD.PLAN_ID AS ID_PLAN,
      PROMOPLANPROD.PRODUCTO_ID AS ID_PRODUCTO,  
      PROMOPLANPROD.PLAN_ID_SUPERIOR, 
      PROMOPLANPROD.ESTADO
    FROM DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION PROMOPLANPROD,
    DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROM
    WHERE
    PROMOPLANPROD.ESTADO                != Cv_EstadoEliminado
    AND TPROM.ID_TIPO_PROMOCION          = Cn_IdTipoPromocion
    AND PROMOPLANPROD.TIPO_PROMOCION_ID  = TPROM.ID_TIPO_PROMOCION; 
  BEGIN
  --
  La_TipoPromoPlanProdProcesar.DELETE();
  FOR Lr_TipoPromoPlanProd IN C_GetPlanProdPorTipoPromo(Fn_IdTipoPromocion,Lv_EstadoEliminado)
  LOOP   
    La_TipoPromoPlanProdProcesar(Ln_Indice).ID_TIPO_PROMOCION:=Lr_TipoPromoPlanProd.ID_TIPO_PROMOCION;
    La_TipoPromoPlanProdProcesar(Ln_Indice).CODIGO_TIPO_PROMOCION:=Lr_TipoPromoPlanProd.CODIGO_TIPO_PROMOCION;
    La_TipoPromoPlanProdProcesar(Ln_Indice).ID_PLAN:=Lr_TipoPromoPlanProd.ID_PLAN;     
    La_TipoPromoPlanProdProcesar(Ln_Indice).ID_PRODUCTO:=Lr_TipoPromoPlanProd.ID_PRODUCTO;     
    La_TipoPromoPlanProdProcesar(Ln_Indice).PLAN_ID_SUPERIOR:=Lr_TipoPromoPlanProd.PLAN_ID_SUPERIOR;     
    La_TipoPromoPlanProdProcesar(Ln_Indice).ESTADO:=Lr_TipoPromoPlanProd.ESTADO;          
    Ln_Indice:=Ln_Indice + 1;
  END LOOP;  

  RETURN La_TipoPromoPlanProdProcesar; 

  EXCEPTION
  WHEN OTHERS THEN
    --       
    Lv_MsjResultado := 'Ocurrio un error al obtener los Planes y/o Productos del Tipo Promocional ID_TIPO_PROMOCION: ' || Fn_IdTipoPromocion; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );     
    La_TipoPromoPlanProdProcesar.DELETE();                  
  END F_GET_TIPO_PROMO_PLAN_PROD;
  --
  --  
  PROCEDURE P_GET_SERV_PROMO_PLAN_PROD(Pa_ServiciosProcesar         IN T_ServiciosProcesar,
                                       Pv_CodigoTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pa_TipoPromoPlanProdProcesar IN T_TipoPromoPlanProdProcesar, 
                                       Pb_CumplePromo               OUT BOOLEAN,
                                       Pa_ServiciosCumplePromo      OUT T_ServiciosProcesar)
  IS
    Lv_IpCreacion      VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado    VARCHAR2(2000); 
    Ln_Ind             NUMBER:=1;
    Ln_Indice1         NUMBER;
    Ln_Indice2         NUMBER;             
    Ln_IndServPlan     NUMBER;
    Ln_IndServProd     NUMBER;    
    Lb_EncontroProd    BOOLEAN:=FALSE; 
    Lb_EncontroPlan    BOOLEAN:=FALSE; 
    Lb_ProdNoCumple    BOOLEAN:=FALSE;     
    Lv_CompararPlanBw  VARCHAR2(5);
    La_TipoPromoPlan   T_TipoPromoPlanProdProcesar;
    La_TipoPromoProd   T_TipoPromoPlanProdProcesar;
  BEGIN
    La_TipoPromoPlan:=Pa_TipoPromoPlanProdProcesar;
    La_TipoPromoProd:=Pa_TipoPromoPlanProdProcesar;

    --Verifico que los Planes y Productos definidos por Tipo Promocional se encuentren como servicios en el Punto para poder 
    --otorgar la promoción.   
    Pa_ServiciosCumplePromo.DELETE();   

    IF (Pv_CodigoTipoPromocion != 'PROM_MIX' AND Pa_TipoPromoPlanProdProcesar.COUNT > 0) THEN   
      Ln_Indice1 := Pa_TipoPromoPlanProdProcesar.FIRST;   
      WHILE (Ln_Indice1 IS NOT NULL)   
      LOOP
        Ln_Indice2 := Pa_ServiciosProcesar.FIRST;           
        WHILE (Ln_Indice2 IS NOT NULL)   
        LOOP            
          --
          Lv_CompararPlanBw := 'NO';
          IF Pv_CodigoTipoPromocion = 'PROM_BW' AND Pa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PLAN IS NOT NULL
            AND Pa_ServiciosProcesar(Ln_Indice2).ID_PLAN IS NOT NULL THEN
              Lv_CompararPlanBw := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(
                                      Pa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PLAN,Pa_ServiciosProcesar(Ln_Indice2).ID_PLAN);
          END IF;
          --
          IF ((Pa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PLAN IS NOT NULL 
            AND (Pa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PLAN = Pa_ServiciosProcesar(Ln_Indice2).ID_PLAN OR Lv_CompararPlanBw = 'SI') )
            OR (Pa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PRODUCTO IS NOT NULL 
            AND Pa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PRODUCTO = Pa_ServiciosProcesar(Ln_Indice2).ID_PRODUCTO)) THEN

            Pa_ServiciosCumplePromo(Ln_Ind).ID_SERVICIO:=Pa_ServiciosProcesar(Ln_Indice2).ID_SERVICIO;
            Pa_ServiciosCumplePromo(Ln_Ind).ID_PUNTO:=Pa_ServiciosProcesar(Ln_Indice2).ID_PUNTO;
            Pa_ServiciosCumplePromo(Ln_Ind).ID_PLAN:=Pa_ServiciosProcesar(Ln_Indice2).ID_PLAN;
            Pa_ServiciosCumplePromo(Ln_Ind).ID_PRODUCTO:=Pa_ServiciosProcesar(Ln_Indice2).ID_PRODUCTO;
            Pa_ServiciosCumplePromo(Ln_Ind).PLAN_ID_SUPERIOR:=Pa_TipoPromoPlanProdProcesar(Ln_Indice1).PLAN_ID_SUPERIOR;
            Pa_ServiciosCumplePromo(Ln_Ind).ESTADO:=Pa_ServiciosProcesar(Ln_Indice2).ESTADO;
            Ln_Ind:=Ln_Ind + 1;               
          END IF;       
          --
          Ln_Indice2 := Pa_ServiciosProcesar.NEXT(Ln_Indice2);
          --
        END LOOP; 
        --    
        Ln_Indice1 := Pa_TipoPromoPlanProdProcesar.NEXT(Ln_Indice1);   
        --
      END LOOP;
      --
    ELSIF (Pv_CodigoTipoPromocion = 'PROM_MIX' AND Pa_TipoPromoPlanProdProcesar.COUNT > 0) THEN   
      Ln_Indice1 := La_TipoPromoPlan.FIRST;   
      WHILE (Ln_Indice1 IS NOT NULL AND NOT Lb_EncontroPlan AND NOT Lb_ProdNoCumple)   
      LOOP
        Ln_IndServPlan := Pa_ServiciosProcesar.FIRST;             
        Lb_EncontroPlan:=FALSE;
        WHILE (Ln_IndServPlan IS NOT NULL AND NOT Lb_EncontroPlan)   
        LOOP
          IF (La_TipoPromoPlan(Ln_Indice1).ID_PLAN IS NOT NULL 
            AND La_TipoPromoPlan(Ln_Indice1).ID_PLAN = Pa_ServiciosProcesar(Ln_IndServPlan).ID_PLAN) THEN  

            Pa_ServiciosCumplePromo(Ln_Ind).ID_SERVICIO:=Pa_ServiciosProcesar(Ln_IndServPlan).ID_SERVICIO;
            Pa_ServiciosCumplePromo(Ln_Ind).ID_PUNTO:=Pa_ServiciosProcesar(Ln_IndServPlan).ID_PUNTO;
            Pa_ServiciosCumplePromo(Ln_Ind).ID_PLAN:=Pa_ServiciosProcesar(Ln_IndServPlan).ID_PLAN;
            Pa_ServiciosCumplePromo(Ln_Ind).ID_PRODUCTO:=Pa_ServiciosProcesar(Ln_IndServPlan).ID_PRODUCTO;
            Pa_ServiciosCumplePromo(Ln_Ind).ESTADO:=Pa_ServiciosProcesar(Ln_IndServPlan).ESTADO;
            Ln_Ind:=Ln_Ind + 1;
            Lb_EncontroPlan:=TRUE;
            --
            --Verifico que existan todos los productos del tipo Promocional como servicios en el Punto Cliente
            Ln_Indice2 := La_TipoPromoProd.FIRST;   
            WHILE (Ln_Indice2 IS NOT NULL AND NOT Lb_ProdNoCumple)   
            LOOP          
              IF  La_TipoPromoProd(Ln_Indice2).ID_PRODUCTO IS NOT NULL  THEN
                Ln_IndServProd := Pa_ServiciosProcesar.FIRST;           
                Lb_EncontroProd:=FALSE;
                WHILE (Ln_IndServProd IS NOT NULL AND NOT Lb_EncontroProd)   
                LOOP            
                  IF (NOT Lb_EncontroProd AND La_TipoPromoProd(Ln_Indice2).ID_PRODUCTO IS NOT NULL 
                    AND La_TipoPromoProd(Ln_Indice2).ID_PRODUCTO = Pa_ServiciosProcesar(Ln_IndServProd).ID_PRODUCTO) THEN

                    Pa_ServiciosCumplePromo(Ln_Ind).ID_SERVICIO:=Pa_ServiciosProcesar(Ln_IndServProd).ID_SERVICIO;
                    Pa_ServiciosCumplePromo(Ln_Ind).ID_PUNTO:=Pa_ServiciosProcesar(Ln_IndServProd).ID_PUNTO;
                    Pa_ServiciosCumplePromo(Ln_Ind).ID_PLAN:=Pa_ServiciosProcesar(Ln_IndServProd).ID_PLAN;
                    Pa_ServiciosCumplePromo(Ln_Ind).ID_PRODUCTO:=Pa_ServiciosProcesar(Ln_IndServProd).ID_PRODUCTO;
                    Pa_ServiciosCumplePromo(Ln_Ind).ESTADO:=Pa_ServiciosProcesar(Ln_IndServProd).ESTADO;
                    Ln_Ind:=Ln_Ind + 1;
                    Lb_EncontroProd:=TRUE;
                  END IF;              
                  --
                  Ln_IndServProd := Pa_ServiciosProcesar.NEXT(Ln_IndServProd);
                  --
                END LOOP; 
                --        
                IF NOT Lb_EncontroProd THEN
                  Lb_ProdNoCumple:=TRUE;
                  Pa_ServiciosCumplePromo.DELETE();
                  Pb_CumplePromo:=FALSE;
                END IF;
                --
              END IF;
              --
              Ln_Indice2 := La_TipoPromoProd.NEXT(Ln_Indice2);              
              --
            END LOOP;--fin bloque que verifica que todos los productos definidos en la promoción existan como servicios en el Punto cliente
              --
          END IF;  
          --
          Ln_IndServPlan := Pa_ServiciosProcesar.NEXT(Ln_IndServPlan);            
          --
        END LOOP;                    
        --
        Ln_Indice1 := La_TipoPromoPlan.NEXT(Ln_Indice1);    
        --
      END LOOP; 
      --                  
    END IF;

    --Si se trata de PROM_MIX: Verifico que todos los planes y productos del MIX se encuentren como servicios en el Punto Cliente,
    --Si se trata de PROM_MPLA, PROM_MPRO, PROM_BW : Verifico que al menos 1 Plan o producto de la Promoción se encuentre como servicio del Punto
    --Si se trata de PROM_TOT, PROM_INS: Debo asignar todos los servicios a Procesar como servicios que cumplen la Promoción.
    --Si no se cumple se debe enviar boolean que No Cumple Promo y la tabla de servicios que cumplen promo vacia(Pa_ServiciosCumplePromo).       
    Pb_CumplePromo:=TRUE;    
    IF (Pv_CodigoTipoPromocion NOT IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_TOT','PROM_INS','PROM_BW')) THEN
      Pa_ServiciosCumplePromo.DELETE();
      Pb_CumplePromo:=FALSE;
    END IF;
    --
    IF Pv_CodigoTipoPromocion = 'PROM_TOT' OR Pv_CodigoTipoPromocion = 'PROM_INS' THEN
      Pa_ServiciosCumplePromo.DELETE();
      Pa_ServiciosCumplePromo:=Pa_ServiciosProcesar;
    ELSIF (Pv_CodigoTipoPromocion IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_BW')
      AND Pa_ServiciosCumplePromo.COUNT=0) THEN      
      Pb_CumplePromo:=FALSE;
    END IF;       
    --    

  EXCEPTION
  WHEN OTHERS THEN    
    Lv_MsjResultado := 'Ocurrio un error al verificar que los Planes y Productos del Promocional se encuentran como servicios en el Punto Cliente';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    Pa_ServiciosCumplePromo.DELETE();
    Pb_CumplePromo:=FALSE;                       
  END P_GET_SERV_PROMO_PLAN_PROD;  --
  --
  PROCEDURE P_INSERT_INFO_DET_MAPEO_PROMO(Pr_InfoDetalleMapeoPromo  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                                          Pv_MsjResultado           OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO
    (ID_DETALLE_MAPEO,
     GRUPO_PROMOCION_ID,
     TRAMA,
     PERSONA_EMPRESA_ROL_ID,
     PUNTO_ID,
     TIPO_PROMOCION_ID,
     TIPO_PROMOCION,
     FE_MAPEO,
     PERIODO,
     FE_SIGUIENTE_MAPEO,
     CANTIDAD_PERIODOS,
     MAPEOS_GENERADOS,
     PORCENTAJE,
     TIPO_PROCESO,
     INDEFINIDO,
     INVALIDA,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     EMPRESA_COD,     
     ESTADO)
    VALUES
    (Pr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO,
     Pr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID,
     Pr_InfoDetalleMapeoPromo.TRAMA,
     Pr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID,
     Pr_InfoDetalleMapeoPromo.PUNTO_ID,
     Pr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID,
     Pr_InfoDetalleMapeoPromo.TIPO_PROMOCION,
     Pr_InfoDetalleMapeoPromo.FE_MAPEO,
     Pr_InfoDetalleMapeoPromo.PERIODO,
     Pr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO,
     Pr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS,
     Pr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS,
     Pr_InfoDetalleMapeoPromo.PORCENTAJE,
     Pr_InfoDetalleMapeoPromo.TIPO_PROCESO,
     Pr_InfoDetalleMapeoPromo.INDEFINIDO,
     Pr_InfoDetalleMapeoPromo.INVALIDA,
     Pr_InfoDetalleMapeoPromo.FE_CREACION,
     Pr_InfoDetalleMapeoPromo.USR_CREACION,
     Pr_InfoDetalleMapeoPromo.IP_CREACION,
     Pr_InfoDetalleMapeoPromo.FE_ULT_MOD,
     Pr_InfoDetalleMapeoPromo.USR_ULT_MOD,
     Pr_InfoDetalleMapeoPromo.IP_ULT_MOD,
     Pr_InfoDetalleMapeoPromo.EMPRESA_COD,
     Pr_InfoDetalleMapeoPromo.ESTADO
    );
  EXCEPTION
  WHEN OTHERS THEN    
    Pv_MsjResultado := 'Error en P_INSERT_INFO_DET_MAPEO_PROMO - punto: ' || Pr_InfoDetalleMapeoPromo.PUNTO_ID || SQLERRM;
  --
  END P_INSERT_INFO_DET_MAPEO_PROMO;
  --

  PROCEDURE P_INSERT_INFO_DET_MAPEO_SOLIC(Pr_InfoDetalleMapeoSolicitud  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE,
                                          Pv_MsjResultado               OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD
    (ID_MAPEO_SOLICITUD,
     DETALLE_MAPEO_ID,
     SERVICIO_ID,
     PLAN_ID,
     PRODUCTO_ID,
     PLAN_ID_SUPERIOR,
     SOLICITUD_ID,     
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     ESTADO)
    VALUES
    (Pr_InfoDetalleMapeoSolicitud.ID_MAPEO_SOLICITUD,
     Pr_InfoDetalleMapeoSolicitud.DETALLE_MAPEO_ID,
     Pr_InfoDetalleMapeoSolicitud.SERVICIO_ID,
     Pr_InfoDetalleMapeoSolicitud.PLAN_ID,
     Pr_InfoDetalleMapeoSolicitud.PRODUCTO_ID,
     Pr_InfoDetalleMapeoSolicitud.PLAN_ID_SUPERIOR,
     Pr_InfoDetalleMapeoSolicitud.SOLICITUD_ID,
     Pr_InfoDetalleMapeoSolicitud.FE_CREACION,
     Pr_InfoDetalleMapeoSolicitud.USR_CREACION,
     Pr_InfoDetalleMapeoSolicitud.IP_CREACION,
     Pr_InfoDetalleMapeoSolicitud.FE_ULT_MOD,
     Pr_InfoDetalleMapeoSolicitud.USR_ULT_MOD,
     Pr_InfoDetalleMapeoSolicitud.IP_ULT_MOD,
     Pr_InfoDetalleMapeoSolicitud.ESTADO
    );
  EXCEPTION
  WHEN OTHERS THEN    
    Pv_MsjResultado := 'Error en P_INSERT_INFO_DET_MAPEO_SOLIC - ' || SQLERRM;
  --
  END P_INSERT_INFO_DET_MAPEO_SOLIC;
  --

  PROCEDURE P_INSERT_INFO_DET_MAPEO_HISTO(Pr_InfoDetalleMapeoHisto  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE,
                                          Pv_MsjResultado           OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO
    (ID_DETALLE_MAPEO_HISTO,
     DETALLE_MAPEO_ID,     
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     OBSERVACION,    
     ESTADO)
    VALUES
    (Pr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO,
     Pr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID,    
     Pr_InfoDetalleMapeoHisto.FE_CREACION,
     Pr_InfoDetalleMapeoHisto.USR_CREACION,
     Pr_InfoDetalleMapeoHisto.IP_CREACION,    
     Pr_InfoDetalleMapeoHisto.OBSERVACION,
     Pr_InfoDetalleMapeoHisto.ESTADO
    );

  EXCEPTION
  WHEN OTHERS THEN    
    Pv_MsjResultado := 'Error en P_INSERT_INFO_DET_MAPEO_HISTO - ' || SQLERRM;
  --
  END P_INSERT_INFO_DET_MAPEO_HISTO;
  --
  --
  --
  FUNCTION F_OBTIENE_ESTADO_SERV(Fn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN VARCHAR2
  IS
    --Costo: Query para obtener el estado de un servicio: 3
    CURSOR C_ObtieneEstadoServ(Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS  
      SELECT ESTADO
      FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE ID_SERVICIO =  Cn_IdServicio;
    --
    Lv_EstadoServicio       VARCHAR2(25);
    Lc_ObtieneEstadoServ    C_ObtieneEstadoServ%ROWTYPE;
    Lv_IpCreacion           VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
  BEGIN
    --
    IF C_ObtieneEstadoServ%ISOPEN THEN
      CLOSE C_ObtieneEstadoServ;
    END IF;
    --
    OPEN C_ObtieneEstadoServ(Fn_IdServicio);
    --
    FETCH C_ObtieneEstadoServ INTO Lc_ObtieneEstadoServ;
    Lv_EstadoServicio:= Lc_ObtieneEstadoServ.ESTADO;
    --
    CLOSE C_ObtieneEstadoServ;
    --  
    RETURN Lv_EstadoServicio;
    --    
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_EstadoServicio := '';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_OBTIENE_ESTADO_SERV', 
                                         SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_map_prom',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    --
    RETURN Lv_EstadoServicio;
    --
  END F_OBTIENE_ESTADO_SERV;
  --
  --
  --
  FUNCTION F_VALIDA_PROMO_INDEFINIDA(Fn_IdGrupoPromocion  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                     Fv_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE) 
  RETURN BOOLEAN
  IS
    --Costo: Query para obtener Regla de Promoción Indefinida: 5
    CURSOR C_Tiene_Promo_Indefinida(Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                    Cv_TipoPromocion      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                    Cv_DescCaract         DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_EstadoEliminado    DB_COMERCIAL.ADMI_TIPO_PROMOCION.ESTADO%TYPE)
    IS  
      SELECT ATPR.VALOR
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION     ATP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA  ATPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA        AC
      WHERE AC.DESCRIPCION_CARACTERISTICA =  Cv_DescCaract
        AND AC.ID_CARACTERISTICA          =  ATPR.CARACTERISTICA_ID
        AND ATPR.ESTADO                  != Cv_EstadoEliminado
        AND ATPR.TIPO_PROMOCION_ID        =  ATP.ID_TIPO_PROMOCION
        AND ATP.CODIGO_TIPO_PROMOCION     =  Cv_TipoPromocion
        AND ATP.ESTADO                   != Cv_EstadoEliminado
        AND ATP.GRUPO_PROMOCION_ID        =  Cn_IdGrupoPromocion;
    --
    Lc_PromocionIndefinida  C_Tiene_Promo_Indefinida%ROWTYPE;
    Lv_IpCreacion           VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_DescCaract           VARCHAR2(30):= 'PROM_PROMOCION_INDEFINIDA';
    Lv_EstadoEliminado      VARCHAR2(10):= 'Eliminado';
    Lb_Aplica               BOOLEAN;
    --
  BEGIN
    --
    IF C_Tiene_Promo_Indefinida%ISOPEN THEN
      CLOSE C_Tiene_Promo_Indefinida;
    END IF;
    --
    OPEN C_Tiene_Promo_Indefinida(Fn_IdGrupoPromocion, Fv_Tipo_Promocion, Lv_DescCaract, Lv_EstadoEliminado);
    --
    FETCH C_Tiene_Promo_Indefinida INTO Lc_PromocionIndefinida;
    --
    IF Lc_PromocionIndefinida.VALOR = 'SI' THEN
      Lb_Aplica := TRUE;
    ELSE
      Lb_Aplica := FALSE;
    END IF;
    --
    CLOSE C_Tiene_Promo_Indefinida;
    --  
    RETURN Lb_Aplica;
    --    
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lb_Aplica := FALSE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_VALIDA_PROMO_INDEFINIDA', 
                                         SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_map_prom',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    --
    RETURN Lb_Aplica;
    --
  END F_VALIDA_PROMO_INDEFINIDA;
  -- 
  --
  --
  PROCEDURE P_GET_CICLO(Pn_IdPersonaRol       IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                        Pv_CodigoCiclo       OUT DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE,
                        Pd_FechaInicioCiclo  OUT DB_FINANCIERO.ADMI_CICLO.FE_INICIO%TYPE)
  IS
    --Costo: Query para obtener detalle del Ciclo de Facturación del Cliente: 6
    CURSOR C_GetPerRolCaractCiclo (Cn_IdPersonaRol   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                   Cv_DescCaract     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_EstadoActivo   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.ESTADO%TYPE)
    IS
      SELECT CI.CODIGO,
             CI.FE_INICIO
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, 
           DB_COMERCIAL.ADMI_CARACTERISTICA CA,
           DB_FINANCIERO.ADMI_CICLO CI
      WHERE IPER.ID_PERSONA_ROL                                     = Cn_IdPersonaRol
      AND IPERC.PERSONA_EMPRESA_ROL_ID                              = IPER.ID_PERSONA_ROL
      AND IPERC.CARACTERISTICA_ID                                   = CA.ID_CARACTERISTICA
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0)  = CI.ID_CICLO
      AND CA.DESCRIPCION_CARACTERISTICA                             = Cv_DescCaract  
      AND IPERC.ESTADO                                              = Cv_EstadoActivo;
      --
      Lv_IpCreacion      VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      Lv_DescCaract      VARCHAR2(20):= 'CICLO_FACTURACION';
      Lv_EstadoActivo    VARCHAR2(10):= 'Activo';
      --
  BEGIN
    --
    IF C_GetPerRolCaractCiclo%ISOPEN THEN
      CLOSE C_GetPerRolCaractCiclo;
    END IF;
    --
    OPEN C_GetPerRolCaractCiclo(Pn_IdPersonaRol, Lv_DescCaract, Lv_EstadoActivo);
    --
    FETCH C_GetPerRolCaractCiclo INTO Pv_CodigoCiclo, Pd_FechaInicioCiclo;
    --
    IF Pv_CodigoCiclo IS NULL THEN
      Pv_CodigoCiclo := '';
    END IF;
    --
    IF Pd_FechaInicioCiclo IS NULL THEN
      Pd_FechaInicioCiclo := '';
    END IF;
    --
    CLOSE C_GetPerRolCaractCiclo;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pv_CodigoCiclo      := '';
    Pd_FechaInicioCiclo := '';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_GET_CICLO', 
                                         'Error en P_GET_CICLO' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_map_prom',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );        
  END P_GET_CICLO;
  --
  --
  --
  PROCEDURE P_VALIDA_JERARQUIA_PROMOCION(Pn_IdGrupoPromocion       IN  DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                         Pv_Tipo_Promocion         IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pa_ServiciosCumplePromo   IN  T_ServiciosProcesar,
                                         Pa_ServiciosMapear       OUT  T_ServiciosMapear,
                                         Pb_AplicaMapeo           OUT  BOOLEAN)
  IS
    --Costo: Query para obtener detalle del Mapeo de Promoción: 3
    CURSOR C_ObtieneDetalleMapeo(Cv_Estado         DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE,
                                 Cn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Cv_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    IS  
      SELECT IDMP.*
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
           DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP 
      WHERE IDMP.TIPO_PROMOCION   = Cv_Tipo_Promocion
      AND IDMP.ID_DETALLE_MAPEO   = IDMS.DETALLE_MAPEO_ID
      AND IDMS.SERVICIO_ID        = Cn_IdServicio
      AND IDMP.ESTADO             = Cv_Estado
      AND ROWNUM                  = 1;
    --
    --Costo: Query para obtener detalle del Mapeo de Promoción con característica de Invalida Promo: 2        
    CURSOR C_ObtieneDetalleInvalidaPromo(Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                         Cv_Estado             DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE,
                                         Cv_InvalidaPromo      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.INVALIDA%TYPE)
    IS  
      SELECT IDMP.*
      FROM  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP 
      WHERE IDMP.ESTADO           = Cv_Estado
      AND IDMP.GRUPO_PROMOCION_ID = Cn_IdGrupoPromocion
      AND IDMP.INVALIDA           = Cv_InvalidaPromo
      AND ROWNUM                  = 1;
    --
    Lc_DetalleMapeoPromo     C_ObtieneDetalleMapeo%ROWTYPE;
    Lb_ExisteDetallePromo    BOOLEAN;
    Lc_DetalleInvalidaPromo  C_ObtieneDetalleInvalidaPromo%ROWTYPE;
    Lb_ExisteInvalidaPromo   BOOLEAN;
    Lb_AplicaMapeo           BOOLEAN:= FALSE;
    Ln_ContServicios         NUMBER :=1;
    Ln_ContRegMapeo          NUMBER :=1;
    Ln_ContRegistros         NUMBER :=0;
    Ln_Indx                  PLS_INTEGER;
    Lv_EstadoPromo           VARCHAR2(15):='Activo';
    Lv_InvalidaPromo         VARCHAR2(1) :='S';
    Lv_IpCreacion            VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --   
    TYPE T_MapeoPromo IS TABLE OF DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE INDEX BY PLS_INTEGER;
    T_RegistroMapeo T_MapeoPromo;
    --
    La_Servicios   T_ServiciosMapear;
    --
  BEGIN
    --
    IF C_ObtieneDetalleInvalidaPromo%ISOPEN THEN
      CLOSE C_ObtieneDetalleInvalidaPromo;
    END IF;
    --
    OPEN C_ObtieneDetalleInvalidaPromo(Pn_IdGrupoPromocion,Lv_EstadoPromo,Lv_InvalidaPromo);
    FETCH C_ObtieneDetalleInvalidaPromo INTO Lc_DetalleInvalidaPromo;
    Lb_ExisteInvalidaPromo:=C_ObtieneDetalleInvalidaPromo%NOTFOUND;  
    CLOSE C_ObtieneDetalleInvalidaPromo;
    --
    --Si no existe una Promoción activa con la característica que invalida a otras Promociones, entonces ingresa a mapear.
    IF Lb_ExisteInvalidaPromo THEN      
      --
      Ln_Indx := Pa_ServiciosCumplePromo.FIRST;
      --
      WHILE (Ln_Indx IS NOT NULL)  
      LOOP
        --
        IF C_ObtieneDetalleMapeo%ISOPEN THEN
          CLOSE C_ObtieneDetalleMapeo;
        END IF;
        --
        OPEN C_ObtieneDetalleMapeo(Lv_EstadoPromo,TO_NUMBER(Pa_ServiciosCumplePromo(Ln_Indx).ID_SERVICIO),Pv_Tipo_Promocion);
        FETCH C_ObtieneDetalleMapeo INTO Lc_DetalleMapeoPromo;
        Lb_ExisteDetallePromo:=C_ObtieneDetalleMapeo%NOTFOUND;
        CLOSE C_ObtieneDetalleMapeo;
        --
        --Añadimos los servicios que se van a mapear.
        IF Lb_ExisteDetallePromo THEN
          Pa_ServiciosMapear(Ln_Indx) := Pa_ServiciosCumplePromo(Ln_Indx);
          Ln_ContServicios:=Ln_ContServicios+1;
        ELSE
        --Añadimos los Registros de Mapeo que sus servicios ya están mapeados.
          T_RegistroMapeo(Ln_ContRegMapeo) := Lc_DetalleMapeoPromo;
          Ln_ContRegMapeo:=Ln_ContRegMapeo+1;
        END IF;  
        --
        Ln_ContRegistros:=Ln_ContRegistros+1;
        --
        Ln_Indx := Pa_ServiciosCumplePromo.NEXT (Ln_Indx);
        --
      END LOOP;            
      --
      Ln_Indx := Pa_ServiciosMapear.FIRST;
      --
      WHILE (Ln_Indx IS NOT NULL)  
      LOOP
        --        
        Ln_Indx := Pa_ServiciosMapear.NEXT (Ln_Indx);
        --
      END LOOP;

      --
      --Validación para verificar que un servicio de la Promoción Mix ya este mapeado.
      IF T_RegistroMapeo.COUNT > 0 AND Pa_ServiciosMapear.COUNT > 0 AND Pv_Tipo_Promocion = 'PROM_MIX' AND 
         Pa_ServiciosMapear.COUNT <> Ln_ContRegistros THEN
        --        
        Lb_AplicaMapeo:=FALSE;
        --
      --Validación para verificar que todos los servicios de una promoción ya este mapeados.
      ELSIF (T_RegistroMapeo.COUNT > 0 AND Pa_ServiciosMapear.COUNT = 0) THEN
         --         
         Lb_AplicaMapeo:=FALSE;
         -- 
      ELSE
         --         
         Lb_AplicaMapeo:=TRUE;
         --
      END IF;
      --       
    END IF;    
    --
    Pb_AplicaMapeo:=Lb_AplicaMapeo; 
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pb_AplicaMapeo:=FALSE;
    --
    Pa_ServiciosMapear:=La_Servicios;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_JERARQUIA_PROMOCION', 
                                         'Error en P_VALIDA_JERARQUIA_PROMOCION' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_map_prom',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );        
  END P_VALIDA_JERARQUIA_PROMOCION;
  --
  --
  --
  PROCEDURE P_INSERT_INFO_SERVICIO_HISTO(Pr_InfoServicioHisto   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE,
                                         Pv_MsjResultado       OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
    (ID_SERVICIO_HISTORIAL,
     SERVICIO_ID,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     ESTADO,
     MOTIVO_ID,
     OBSERVACION,
     ACCION)
    VALUES
    (Pr_InfoServicioHisto.ID_SERVICIO_HISTORIAL,
     Pr_InfoServicioHisto.SERVICIO_ID,
     Pr_InfoServicioHisto.USR_CREACION,
     Pr_InfoServicioHisto.FE_CREACION,
     Pr_InfoServicioHisto.IP_CREACION,
     Pr_InfoServicioHisto.ESTADO,
     Pr_InfoServicioHisto.MOTIVO_ID,
     Pr_InfoServicioHisto.OBSERVACION,
     Pr_InfoServicioHisto.ACCION
    );
  --
  EXCEPTION
  WHEN OTHERS THEN  
    Pv_MsjResultado := 'Error en P_INSERT_INFO_SERVICIO_HISTO - ' || SQLERRM;
  --
  END P_INSERT_INFO_SERVICIO_HISTO;
  --
  --
  --
  PROCEDURE P_INSERT_INFO_DET_SOLICITUD(Pr_InfoDetalleSolicitud   IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                        Pv_MsjResultado          OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    (ID_DETALLE_SOLICITUD,
     SERVICIO_ID,
     TIPO_SOLICITUD_ID,
     MOTIVO_ID,
     USR_CREACION,
     FE_CREACION,
     PRECIO_DESCUENTO,
     PORCENTAJE_DESCUENTO,
     TIPO_DOCUMENTO,
     OBSERVACION,
     ESTADO,
     USR_RECHAZO,
     FE_RECHAZO,
     DETALLE_PROCESO_ID,
     FE_EJECUCION,
     ELEMENTO_ID)
    VALUES
    (Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD,
     Pr_InfoDetalleSolicitud.SERVICIO_ID,
     Pr_InfoDetalleSolicitud.TIPO_SOLICITUD_ID,
     Pr_InfoDetalleSolicitud.MOTIVO_ID,
     Pr_InfoDetalleSolicitud.USR_CREACION,
     Pr_InfoDetalleSolicitud.FE_CREACION,
     Pr_InfoDetalleSolicitud.PRECIO_DESCUENTO,
     Pr_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO,
     Pr_InfoDetalleSolicitud.TIPO_DOCUMENTO,
     Pr_InfoDetalleSolicitud.OBSERVACION,
     Pr_InfoDetalleSolicitud.ESTADO,
     Pr_InfoDetalleSolicitud.USR_RECHAZO,
     Pr_InfoDetalleSolicitud.FE_RECHAZO,
     Pr_InfoDetalleSolicitud.DETALLE_PROCESO_ID,
     Pr_InfoDetalleSolicitud.FE_EJECUCION,
     Pr_InfoDetalleSolicitud.ELEMENTO_ID
    );
  --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_INSERT_INFO_DET_SOLICITUD - ' || SQLERRM;
  --
  END P_INSERT_INFO_DET_SOLICITUD;
  --
  --
  --
  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
                                           Pv_MsjResultado        OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
    (ID_SOLICITUD_HISTORIAL,
     DETALLE_SOLICITUD_ID,
     ESTADO,
     FE_INI_PLAN,
     FE_FIN_PLAN,
     OBSERVACION,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     MOTIVO_ID)
    VALUES
    (Pr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL,
     Pr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID,
     Pr_InfoDetalleSolHist.ESTADO,
     Pr_InfoDetalleSolHist.FE_INI_PLAN,
     Pr_InfoDetalleSolHist.FE_FIN_PLAN,
     Pr_InfoDetalleSolHist.OBSERVACION,
     Pr_InfoDetalleSolHist.USR_CREACION,
     Pr_InfoDetalleSolHist.FE_CREACION,
     Pr_InfoDetalleSolHist.IP_CREACION,
     Pr_InfoDetalleSolHist.MOTIVO_ID
    );
  --
  EXCEPTION
  WHEN OTHERS THEN    
    Pv_MsjResultado := 'Error en P_INSERT_INFO_DETALLE_SOL_HIST - ' || SQLERRM;
  --
  END P_INSERT_INFO_DETALLE_SOL_HIST;
  --
  --
  --
  PROCEDURE P_UPDATE_DET_MAP_SOLIC(Pr_InfoDetMapSolicitud  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE,
                                   Pv_MsjResultado         OUT VARCHAR2)
  IS
    Lv_Update     VARCHAR2(32000);
    Lv_Set        VARCHAR2(32000);
    Lv_Where      VARCHAR2(32000);
    Lv_Query      VARCHAR2(32000);
    Lex_Exito     EXCEPTION;
    Lex_Exception EXCEPTION;
  BEGIN
    --
    Lv_Update := ' UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD ';
    Lv_Set    := ' SET DETALLE_MAPEO_ID   = NVL( :1 ,DETALLE_MAPEO_ID),
      SERVICIO_ID          = NVL( :2 ,SERVICIO_ID),
      PLAN_ID              = NVL( :3 ,PLAN_ID),
      PRODUCTO_ID          = NVL( :4 ,PRODUCTO_ID),
      PLAN_ID_SUPERIOR     = NVL( :5 ,PLAN_ID_SUPERIOR),
      SOLICITUD_ID         = NVL( :6 ,SOLICITUD_ID),
      FE_CREACION          = NVL( :7 ,FE_CREACION),
      USR_CREACION         = NVL( :8 ,USR_CREACION),
      IP_CREACION          = NVL( :9 ,IP_CREACION),
      FE_ULT_MOD           = NVL( :10 ,FE_ULT_MOD),
      USR_ULT_MOD          = NVL( :11 ,USR_ULT_MOD),
      IP_ULT_MOD           = NVL( :12 ,IP_ULT_MOD),
      ESTADO               = NVL( :13 ,ESTADO) ';
      
    IF Pr_InfoDetMapSolicitud.ID_MAPEO_SOLICITUD IS NOT NULL AND 
       COALESCE(TO_NUMBER(REGEXP_SUBSTR(Pr_InfoDetMapSolicitud.ID_MAPEO_SOLICITUD,'^\d+')),0) > 0 THEN
    --
      Lv_Where := ' WHERE ID_MAPEO_SOLICITUD = :14 ';
      Lv_Query := Lv_Update || Lv_Set || Lv_Where;
      
      EXECUTE IMMEDIATE Lv_Query
      USING Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,
      Pr_InfoDetMapSolicitud.SERVICIO_ID,
      Pr_InfoDetMapSolicitud.PLAN_ID,
      Pr_InfoDetMapSolicitud.PRODUCTO_ID,
      Pr_InfoDetMapSolicitud.PLAN_ID_SUPERIOR,
      Pr_InfoDetMapSolicitud.SOLICITUD_ID,
      Pr_InfoDetMapSolicitud.FE_CREACION,
      Pr_InfoDetMapSolicitud.USR_CREACION,
      Pr_InfoDetMapSolicitud.IP_CREACION,
      Pr_InfoDetMapSolicitud.FE_ULT_MOD,
      Pr_InfoDetMapSolicitud.USR_ULT_MOD,
      Pr_InfoDetMapSolicitud.IP_ULT_MOD,
      Pr_InfoDetMapSolicitud.ESTADO,
      Pr_InfoDetMapSolicitud.ID_MAPEO_SOLICITUD;
      
      RAISE Lex_Exito;
    -- 
    END IF;
    
    IF Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID IS NOT NULL AND 
       COALESCE(TO_NUMBER(REGEXP_SUBSTR(Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,'^\d+')),0) > 0  AND 
       Pr_InfoDetMapSolicitud.SERVICIO_ID IS NULL THEN
       --
      Lv_Where := ' WHERE DETALLE_MAPEO_ID = :14 ';
      Lv_Query := Lv_Update || Lv_Set || Lv_Where;
      
      EXECUTE IMMEDIATE Lv_Query
      USING Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,
      Pr_InfoDetMapSolicitud.SERVICIO_ID,
      Pr_InfoDetMapSolicitud.PLAN_ID,
      Pr_InfoDetMapSolicitud.PRODUCTO_ID,
      Pr_InfoDetMapSolicitud.PLAN_ID_SUPERIOR,
      Pr_InfoDetMapSolicitud.SOLICITUD_ID,
      Pr_InfoDetMapSolicitud.FE_CREACION,
      Pr_InfoDetMapSolicitud.USR_CREACION,
      Pr_InfoDetMapSolicitud.IP_CREACION,
      Pr_InfoDetMapSolicitud.FE_ULT_MOD,
      Pr_InfoDetMapSolicitud.USR_ULT_MOD,
      Pr_InfoDetMapSolicitud.IP_ULT_MOD,
      Pr_InfoDetMapSolicitud.ESTADO,
      Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID;
      
      RAISE Lex_Exito;
    --
    END IF;
    
    IF Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID IS NOT NULL AND 
       COALESCE(TO_NUMBER(REGEXP_SUBSTR(Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,'^\d+')),0) > 0  AND 
       Pr_InfoDetMapSolicitud.SERVICIO_ID IS NOT NULL AND 
       COALESCE(TO_NUMBER(REGEXP_SUBSTR(Pr_InfoDetMapSolicitud.SERVICIO_ID,'^\d+')),0) > 0 THEN
    --
      Lv_Where := ' WHERE DETALLE_MAPEO_ID = :14 
                    AND SERVICIO_ID        = :15 ';
      Lv_Query := Lv_Update || Lv_Set || Lv_Where;
      
      EXECUTE IMMEDIATE Lv_Query
      USING Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,
      Pr_InfoDetMapSolicitud.SERVICIO_ID,
      Pr_InfoDetMapSolicitud.PLAN_ID,
      Pr_InfoDetMapSolicitud.PRODUCTO_ID,
      Pr_InfoDetMapSolicitud.PLAN_ID_SUPERIOR,
      Pr_InfoDetMapSolicitud.SOLICITUD_ID,
      Pr_InfoDetMapSolicitud.FE_CREACION,
      Pr_InfoDetMapSolicitud.USR_CREACION,
      Pr_InfoDetMapSolicitud.IP_CREACION,
      Pr_InfoDetMapSolicitud.FE_ULT_MOD,
      Pr_InfoDetMapSolicitud.USR_ULT_MOD,
      Pr_InfoDetMapSolicitud.IP_ULT_MOD,
      Pr_InfoDetMapSolicitud.ESTADO,
      Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,
      Pr_InfoDetMapSolicitud.SERVICIO_ID;
      
      RAISE Lex_Exito;
    --
    END IF;
    
    IF TRIM(Lv_Where) IS NULL THEN
      RAISE Lex_Exception;
    END IF;    
  --
  EXCEPTION
  WHEN Lex_Exito THEN
    Pv_MsjResultado := NULL; 
  WHEN Lex_Exception THEN
    Pv_MsjResultado := 'Error al crear sentencia dinámica en P_UPDATE_DET_MAP_SOLIC';  
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_DET_MAP_SOLIC - ' || SQLERRM;
  --
  END P_UPDATE_DET_MAP_SOLIC; 
  -- 
  -- 
  --
  PROCEDURE P_UPDATE_DETALLE_MAPEO_PROM(Pr_InfoDetalleMapeoPromo  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                                     Pv_MsjResultado           OUT VARCHAR2) AS
  BEGIN
    UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
    SET
      IDMP.GRUPO_PROMOCION_ID     = NVL(Pr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID,IDMP.GRUPO_PROMOCION_ID),
      IDMP.TRAMA                  = NVL(Pr_InfoDetalleMapeoPromo.TRAMA,IDMP.TRAMA),
      IDMP.PERSONA_EMPRESA_ROL_ID = NVL(Pr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID,IDMP.PERSONA_EMPRESA_ROL_ID),
      IDMP.PUNTO_ID               = NVL(Pr_InfoDetalleMapeoPromo.PUNTO_ID,IDMP.PUNTO_ID),
      IDMP.TIPO_PROMOCION_ID      = NVL(Pr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID,IDMP.TIPO_PROMOCION_ID),
      IDMP.TIPO_PROMOCION         = NVL(Pr_InfoDetalleMapeoPromo.TIPO_PROMOCION,IDMP.TIPO_PROMOCION),
      IDMP.FE_MAPEO               = NVL(Pr_InfoDetalleMapeoPromo.FE_MAPEO,IDMP.FE_MAPEO),
      IDMP.PERIODO                = NVL(Pr_InfoDetalleMapeoPromo.PERIODO,IDMP.PERIODO),
      IDMP.FE_SIGUIENTE_MAPEO     = NVL(Pr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO,IDMP.FE_SIGUIENTE_MAPEO),
      IDMP.CANTIDAD_PERIODOS      = NVL(Pr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS,IDMP.CANTIDAD_PERIODOS),
      IDMP.MAPEOS_GENERADOS       = NVL(Pr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS,IDMP.MAPEOS_GENERADOS),
      IDMP.PORCENTAJE             = NVL(Pr_InfoDetalleMapeoPromo.PORCENTAJE,IDMP.PORCENTAJE),
      IDMP.TIPO_PROCESO           = NVL(Pr_InfoDetalleMapeoPromo.TIPO_PROCESO,IDMP.TIPO_PROCESO),
      IDMP.INDEFINIDO             = NVL(Pr_InfoDetalleMapeoPromo.INDEFINIDO,IDMP.INDEFINIDO),
      IDMP.INVALIDA               = NVL(Pr_InfoDetalleMapeoPromo.INVALIDA,IDMP.INVALIDA),
      IDMP.FE_CREACION            = NVL(Pr_InfoDetalleMapeoPromo.FE_CREACION,IDMP.FE_CREACION),
      IDMP.USR_CREACION           = NVL(Pr_InfoDetalleMapeoPromo.USR_CREACION,IDMP.USR_CREACION),
      IDMP.IP_CREACION            = NVL(Pr_InfoDetalleMapeoPromo.IP_CREACION,IDMP.IP_CREACION),
      IDMP.FE_ULT_MOD             = NVL(Pr_InfoDetalleMapeoPromo.FE_ULT_MOD,IDMP.FE_ULT_MOD),
      IDMP.USR_ULT_MOD            = NVL(Pr_InfoDetalleMapeoPromo.USR_ULT_MOD,IDMP.USR_ULT_MOD),
      IDMP.IP_ULT_MOD             = NVL(Pr_InfoDetalleMapeoPromo.IP_ULT_MOD,IDMP.IP_ULT_MOD),
      IDMP.EMPRESA_COD            = NVL(Pr_InfoDetalleMapeoPromo.EMPRESA_COD,IDMP.EMPRESA_COD),
      IDMP.ESTADO                 = NVL(Pr_InfoDetalleMapeoPromo.ESTADO,IDMP.ESTADO)
    WHERE IDMP.ID_DETALLE_MAPEO = Pr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO;
    --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_DETALLE_MAPEO_PROM - ' || SQLERRM;
  END P_UPDATE_DETALLE_MAPEO_PROM;
  --
  --
  --
  PROCEDURE P_INSERT_DETALLE( Pr_InfoDetalleMapeoPromo    IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                              Pa_DetalleServiciosMapear   IN T_ServiciosMapear,
                              Pv_MsjResultado             OUT VARCHAR2)
  IS
    --
    Lr_InfoDetalleMapeoSolicitud  DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleMapeoHisto      DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lex_Exception                 EXCEPTION;
    Lv_MsjResultado               VARCHAR2(2000);
    Lv_IpCreacion                 VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_Indice                     PLS_INTEGER;
    Lv_UserMapeo                  VARCHAR2(20):='telcos_map_prom';
    --
  BEGIN
    --
    IF Pa_DetalleServiciosMapear.COUNT > 0 THEN
      --
      P_INSERT_INFO_DET_MAPEO_PROMO(Pr_InfoDetalleMapeoPromo, Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      ELSE    
        --   
        Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
        Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Pr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO;
        Lr_InfoDetalleMapeoHisto.FE_CREACION             := Pr_InfoDetalleMapeoPromo.FE_CREACION;
        Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UserMapeo;
        Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
        Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se registró correctamente el mapeo de la Promoción: '
                                                            ||Pr_InfoDetalleMapeoPromo.TIPO_PROMOCION
                                                            ||', Grupo-Promocional: '||Pr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID
                                                            ||', Fecha-Mapeo: '||TO_CHAR(Pr_InfoDetalleMapeoPromo.FE_MAPEO);
        Lr_InfoDetalleMapeoHisto.ESTADO                  := Pr_InfoDetalleMapeoPromo.ESTADO;
        --
        P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_MsjResultado);  
        --
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Lex_Exception;
        END IF;       
        --
        Lr_InfoDetalleMapeoSolicitud.DETALLE_MAPEO_ID    := Pr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO ;
        Lr_InfoDetalleMapeoSolicitud.SOLICITUD_ID        := NULL;
        Lr_InfoDetalleMapeoSolicitud.FE_CREACION         := Pr_InfoDetalleMapeoPromo.FE_CREACION;
        Lr_InfoDetalleMapeoSolicitud.USR_CREACION        := Lv_UserMapeo;
        Lr_InfoDetalleMapeoSolicitud.IP_CREACION         := Lv_IpCreacion;
        Lr_InfoDetalleMapeoSolicitud.FE_ULT_MOD          := NULL;
        Lr_InfoDetalleMapeoSolicitud.USR_ULT_MOD         := NULL;
        Lr_InfoDetalleMapeoSolicitud.IP_ULT_MOD          := NULL;
        --
        Ln_Indice := Pa_DetalleServiciosMapear.FIRST;
        --
        WHILE (Ln_Indice IS NOT NULL)  
        LOOP          
          --
          Lr_InfoDetalleMapeoSolicitud.ID_MAPEO_SOLICITUD  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_SOLICI.NEXTVAL;
          Lr_InfoDetalleMapeoSolicitud.SERVICIO_ID         := Pa_DetalleServiciosMapear(Ln_Indice).ID_SERVICIO;
          Lr_InfoDetalleMapeoSolicitud.PLAN_ID             := Pa_DetalleServiciosMapear(Ln_Indice).ID_PLAN;
          Lr_InfoDetalleMapeoSolicitud.PLAN_ID_SUPERIOR    := Pa_DetalleServiciosMapear(Ln_Indice).PLAN_ID_SUPERIOR;
          Lr_InfoDetalleMapeoSolicitud.PRODUCTO_ID         := Pa_DetalleServiciosMapear(Ln_Indice).ID_PRODUCTO; 
          Lr_InfoDetalleMapeoSolicitud.ESTADO              := Pr_InfoDetalleMapeoPromo.ESTADO;
          --
          P_INSERT_INFO_DET_MAPEO_SOLIC(Lr_InfoDetalleMapeoSolicitud, Lv_MsjResultado);
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;       
          --
          Ln_Indice := Pa_DetalleServiciosMapear.NEXT (Ln_Indice);
          --
        END LOOP;
        --      
      END IF;
      --
    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_PROMO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UserMapeo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    --
    Pv_MsjResultado := Lv_MsjResultado;
    --
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_PROMO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UserMapeo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    --
    Pv_MsjResultado := Lv_MsjResultado;
    --
  END P_INSERT_DETALLE;
  --
  --
  --
  PROCEDURE P_MAPEO_PROMO_DEFINIDAS (Pr_Punto                 IN Lr_PtosClientesProcesar,
                                     Pa_ServiciosCumplePromo  IN T_ServiciosProcesar,
                                     Pr_GruposPromociones     IN Lr_GruposPromocionesProcesar,
                                     Pr_GrupoPromoRegla       IN Lr_GrupoPromoReglaProcesar,
                                     Pr_TiposPromociones      IN Lr_TiposPromocionesProcesar,
                                     Pr_TipoPromoRegla        IN Lr_TipoPromoReglaProcesar,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pv_Trama                 IN VARCHAR2,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL,
                                     Pv_MsjResultado          OUT VARCHAR2)
  IS 
    CURSOR C_GetParamNumDiasFecAlcance (Cv_NombreParam    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_DescParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.DESCRIPCION%TYPE,    
                                        Cv_Estado         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                        Cv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS
    SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
    DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
    AND APD.ESTADO             = Cv_Estado
    AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
    AND APD.DESCRIPCION        = Cv_DescParametro
    AND APD.EMPRESA_COD        = Cv_CodEmpresa
    AND APC.ESTADO             = Cv_Estado;

    CURSOR C_CicloEspecial(Cv_DescripcionParemetro DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                           Cv_Parametro            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                           Cv_Valor1               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                           Cv_EstadoActivo         VARCHAR2,
                           Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT COUNT(DET.ID_PARAMETRO_DET) AS VALOR
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.DESCRIPCION      = Cv_DescripcionParemetro
      AND DET.VALOR1           = Cv_Valor1
      AND DET.ESTADO           = Cv_EstadoActivo
      AND DET.EMPRESA_COD      = Cv_CodEmpresa
      AND CAB.NOMBRE_PARAMETRO = Cv_Parametro
      AND CAB.ESTADO           = Cv_EstadoActivo;

    Lv_NombreParametro        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE';
    Lv_DescParametro          DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='NUMERO_DIAS_FECHA_PROCESA_ALCANCE';
    Ln_NumeroDias             NUMBER := 0;
    --
    Lv_Nombre                 DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE := Pr_TipoPromoRegla.NOMBRE_GRUPO;
    Ld_FechaProcesamiento     DATE           := SYSDATE;
    Lv_DescuentoPeriodo       VARCHAR2(200)  := Pr_TipoPromoRegla.PROM_PERIODO;
    Lv_TipoCliente            VARCHAR2(3200) := Pv_TipoProceso;
    Lv_CodEmpresa             VARCHAR2(2)    := Pr_Punto.COD_EMPRESA;
    Lv_Estado                 VARCHAR2(15)   := 'Activo';
    Lv_TipoPromo              VARCHAR2(50)   := Pr_TiposPromociones.CODIGO_TIPO_PROMOCION;
    Ln_IdPersonaRol           NUMBER         := Pr_Punto.ID_PERSONA_ROL;
    Ln_IdPunto                NUMBER         := Pr_Punto.ID_PUNTO;
    Ln_IdGrupoPromocion       NUMBER         := Pr_GruposPromociones.ID_GRUPO_PROMOCION;
    Ln_IdTipoPromo            NUMBER         := Pr_TiposPromociones.ID_TIPO_PROMOCION;
    Lc_Trama                  CLOB           := Pv_Trama;
    Lv_IpCreacion             VARCHAR2(16)   := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_InvalidaPromo          VARCHAR2(1)    := Pr_TipoPromoRegla.PROM_INVALIDA_PROMO;
    La_ServiciosMapear        T_ServiciosMapear;
    Lb_AplicaMapeo            BOOLEAN;
    Ln_Contador               NUMBER;
    Ln_ContDescSgte           NUMBER         := 0;
    Ln_PeriodoSiguente        NUMBER;
    Ln_PeriodoSigMapeo        NUMBER;
    Lv_Periodo                VARCHAR2(10);
    Lv_Descuento              VARCHAR2(10);
    Lv_DescSiguente           VARCHAR2(10);
    Ld_FechaMapeo             DATE;
    Ld_FechaMapeoCiclo2       DATE;
    Lex_Exception             EXCEPTION;
    Lv_CodigoCiclo            DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE;
    Ld_FechaInicioCiclo       DB_FINANCIERO.ADMI_CICLO.FE_INICIO%TYPE;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE; 
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_UserMapeo              VARCHAR2(20):='telcos_map_prom';
    Ln_IndxServMap            NUMBER;
    Lr_InfoServicioHistorial  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_FechaMapeoTotal        VARCHAR2(5000);
    Lv_DescripcionParametro   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_CICLOS_FACTURACION';
    Lv_Parametro              DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_PARAMETROS';
    Ln_CicloEspecial          NUMBER;
    --
  BEGIN
    --
    IF C_CicloEspecial%ISOPEN THEN
      CLOSE C_CicloEspecial;
    END IF;
    --
    IF Pv_TipoProceso ='UPGRADE' OR Pv_TipoProceso ='DOWNGRADE'  OR Pv_TipoProceso ='UPGRADE_CAMBIO_PRECIO' THEN
    
      Lv_TipoCliente:='EXISTENTE';
    
    END IF;
    
    IF Lv_TipoCliente ='EXISTENTE' THEN
      OPEN  C_GetParamNumDiasFecAlcance(Cv_NombreParam    => Lv_NombreParametro,
                                        Cv_DescParametro  => Lv_DescParametro,
                                        Cv_Estado         => Lv_Estado,
                                        Cv_CodEmpresa     => Pv_CodEmpresa);
      FETCH C_GetParamNumDiasFecAlcance INTO Ln_NumeroDias;
      CLOSE C_GetParamNumDiasFecAlcance;
      --
      IF (Ln_NumeroDias IS NULL OR Ln_NumeroDias = 0) THEN
        Lv_MsjResultado := 'No se puedo obtener el numero de dias parametrizados en PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE 
                para la ejecución del proceso de Mapeo Promocional Tipo Proceso: '||Lv_TipoCliente;
        RAISE Lex_Exception;
      END IF;  
    END IF;
    --  
    --   
    Ln_Contador:=0;
    --
    --Obtenemos los servicios a mapear y la variable que nos indica si aplica o no el mapeo.
    P_VALIDA_JERARQUIA_PROMOCION(Ln_IdGrupoPromocion,
                                 Lv_TipoPromo,
                                 Pa_ServiciosCumplePromo,
                                 La_ServiciosMapear,
                                 Lb_AplicaMapeo);
    --
    --Obtenemos el ciclo y la fecha de inicio de ciclo.
    P_GET_CICLO(Ln_IdPersonaRol,Lv_CodigoCiclo,Ld_FechaInicioCiclo);
    --
    IF Lv_CodigoCiclo IS NULL  AND Ld_FechaInicioCiclo IS NULL THEN
      Lv_MsjResultado := 'No se encuentra definido Código y Fecha de Inicio de Ciclo';
      RAISE Lex_Exception;
    END IF;   

    OPEN C_CicloEspecial(Lv_DescripcionParametro,Lv_Parametro,Lv_CodigoCiclo,Lv_Estado,Pv_CodEmpresa);
    FETCH C_CicloEspecial INTO Ln_CicloEspecial;
    CLOSE C_CicloEspecial;
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
    Lr_InfoDetalleMapeoPromo.INVALIDA                 := Lv_InvalidaPromo;
    Lr_InfoDetalleMapeoPromo.INDEFINIDO               := NULL;
    Lr_InfoDetalleMapeoPromo.FE_CREACION              := SYSDATE-Ln_NumeroDias;
    Lr_InfoDetalleMapeoPromo.USR_CREACION             := Lv_UserMapeo;
    Lr_InfoDetalleMapeoPromo.IP_CREACION              := Lv_IpCreacion;
    Lr_InfoDetalleMapeoPromo.FE_ULT_MOD               := NULL;
    Lr_InfoDetalleMapeoPromo.USR_ULT_MOD              := NULL;
    Lr_InfoDetalleMapeoPromo.IP_ULT_MOD               := NULL;
    Lr_InfoDetalleMapeoPromo.EMPRESA_COD              := Lv_CodEmpresa;
    Lr_InfoDetalleMapeoPromo.ESTADO                   := Lv_Estado;
    --
    --Mapeo para Cliente Nuevo
    --
    IF Lv_TipoCliente = 'NUEVO' AND Lb_AplicaMapeo THEN
      --
      FOR DescuentoPeriodo IN (SELECT REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) SPLIT FROM DUAL
      CONNECT BY REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) IS NOT NULL)
      LOOP
        --
        Lv_Periodo                             := regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 1);
        Lv_Descuento                           := regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 2);
        Lr_InfoDetalleMapeoPromo.PORCENTAJE    := Lv_Descuento;
        Lr_InfoDetalleMapeoPromo.PERIODO       := Lv_Periodo;
        --
        IF Ln_Contador=0 THEN
        --
          IF Lv_Periodo = 1 THEN
            Ld_FechaMapeo := ADD_MONTHS(Ld_FechaProcesamiento, Lv_Periodo-1);--Fecha de Activacion
          ELSE
            IF Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaProcesamiento,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicioCiclo,'DD')) THEN
              Lv_Periodo := Lv_Periodo-2;
            ELSE
              Lv_Periodo := Lv_Periodo-1;
            END IF;
            Ld_FechaMapeo := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                             TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                             TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Lv_Periodo);
          END IF;
          Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
          Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeo;
          --
          Lv_FechaMapeoTotal:=Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);
          --
          P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo, La_ServiciosMapear, Lv_MsjResultado); 
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;
        --
        ELSE 
        --
          IF Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaProcesamiento,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicioCiclo,'DD')) THEN
            Lv_Periodo := Lv_Periodo-2;
          ELSE
            Lv_Periodo := Lv_Periodo-1;
          END IF;
          --
          Ld_FechaMapeo := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                           TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                           TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Lv_Periodo);
          Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
          Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeo;
          --
          Lv_FechaMapeoTotal:=Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);
          P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo, La_ServiciosMapear, Lv_MsjResultado); 
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
      Ln_IndxServMap := La_ServiciosMapear.FIRST;
      WHILE (Ln_IndxServMap IS NOT NULL)  
      LOOP   
        Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
        Lr_InfoServicioHistorial.SERVICIO_ID            := La_ServiciosMapear(Ln_IndxServMap).ID_SERVICIO;
        Lr_InfoServicioHistorial.USR_CREACION           := Lv_UserMapeo;
        Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
        Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
        Lr_InfoServicioHistorial.ESTADO                 := La_ServiciosMapear(Ln_IndxServMap).ESTADO;
        Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
        Lr_InfoServicioHistorial.OBSERVACION            := 'Se registró correctamente el mapeo de la Promoción: '
                                                           ||Lv_Nombre|| ', para el tipo promocional: '
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
    END IF; 
    --
    --Mapeo para Cliente Existente
    --
    IF Lv_TipoCliente = 'EXISTENTE' AND Lb_AplicaMapeo THEN
      --                                                  
      --
      Ld_FechaProcesamiento:= Ld_FechaProcesamiento-Ln_NumeroDias;
      --
      FOR DescuentoPeriodoSiguiente IN (SELECT REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) SPLIT FROM DUAL
      CONNECT BY REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) IS NOT NULL)
      LOOP
        --
        IF Ln_ContDescSgte = 1 THEN
          Ln_PeriodoSiguente := regexp_substr(DescuentoPeriodoSiguiente.SPLIT,'[^|]+', 1, 1);
          Lv_DescSiguente    := regexp_substr(DescuentoPeriodoSiguiente.SPLIT,'[^|]+', 1, 2);
        END IF;
        IF Ln_ContDescSgte = 2 THEN
          Ln_PeriodoSigMapeo := regexp_substr(DescuentoPeriodoSiguiente.SPLIT,'[^|]+', 1, 1);
        END IF;
        --
        Ln_ContDescSgte := Ln_ContDescSgte + 1;
        --
      END LOOP;
      --
      Lv_Periodo                           := REGEXP_SUBSTR(REGEXP_SUBSTR(Lv_DescuentoPeriodo,'[^,]+'),'[^|]+', 1, 1);
      Lv_Descuento                         := REGEXP_SUBSTR(REGEXP_SUBSTR(Lv_DescuentoPeriodo,'[^,]+'),'[^|]+', 1, 2);
      Lr_InfoDetalleMapeoPromo.PORCENTAJE  := Lv_Descuento;
      Lr_InfoDetalleMapeoPromo.PERIODO     := Lv_Periodo;
      IF Lv_Periodo = 1 THEN
        Ld_FechaMapeo := ADD_MONTHS(Ld_FechaProcesamiento, Lv_Periodo-1);
      ELSE
        IF Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaProcesamiento,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicioCiclo,'DD')) THEN
          Lv_Periodo := Lv_Periodo-2;
        ELSE
          Lv_Periodo := Lv_Periodo-1;
        END IF;
        Ld_FechaMapeo := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                         TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                         TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Lv_Periodo);
      END IF;
      Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
      Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeo;
      IF Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaProcesamiento,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicioCiclo,'DD')) THEN
        Lv_Periodo := nvl(Ln_PeriodoSiguente,Lr_InfoDetalleMapeoPromo.PERIODO)-2;
      ELSE
        Lv_Periodo := nvl(Ln_PeriodoSiguente,Lr_InfoDetalleMapeoPromo.PERIODO)-1;
      END IF;
      Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                                                     TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                                                     TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Lv_Periodo);
      Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS  := Ln_ContDescSgte;
      Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS   := 1;
      -- 
      P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo, La_ServiciosMapear, Lv_MsjResultado); 
      --
      IF Pv_TipoProceso = 'UPGRADE_CAMBIO_PRECIO' AND Ln_PeriodoSiguente > 0 THEN
        --
        Lv_Periodo                                   := Ln_PeriodoSiguente;
        Lv_Descuento                                 := Lv_DescSiguente;
        Lr_InfoDetalleMapeoPromo.PORCENTAJE          := Lv_Descuento;
        Lr_InfoDetalleMapeoPromo.PERIODO             := Lv_Periodo;
        IF Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaProcesamiento,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicioCiclo,'DD')) THEN
          Ln_PeriodoSiguente := Ln_PeriodoSiguente-2;
        ELSE
          Ln_PeriodoSiguente := Ln_PeriodoSiguente-1;
        END IF;
        Ld_FechaMapeo                                := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                                                        TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                                                        TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Ln_PeriodoSiguente);
        Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO    := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
        Lr_InfoDetalleMapeoPromo.FE_MAPEO            := Ld_FechaMapeo;
        IF Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaProcesamiento,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicioCiclo,'DD')) THEN
          Ln_PeriodoSigMapeo := nvl(Ln_PeriodoSigMapeo,Lv_Periodo)-2;
        ELSE
          Ln_PeriodoSigMapeo := nvl(Ln_PeriodoSigMapeo,Lv_Periodo)-1;
        END IF;
        Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO  := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicioCiclo,'DD')||'-'||
                                                        TO_CHAR(Ld_FechaProcesamiento,'MM')||'-'||
                                                        TO_CHAR(Ld_FechaProcesamiento,'YYYY'),'DD-MM-YYYY'), Ln_PeriodoSigMapeo);
        Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS     := 2;
        --
        Lv_FechaMapeoTotal:=Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);
        --
        P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo, La_ServiciosMapear, Lv_MsjResultado); 
        --
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Lex_Exception;
        END IF; 
        --
      END IF;
      
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      ELSE
        --
        Ln_IndxServMap := La_ServiciosMapear.FIRST;
        WHILE (Ln_IndxServMap IS NOT NULL)  
        LOOP   
          Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
          Lr_InfoServicioHistorial.SERVICIO_ID            := La_ServiciosMapear(Ln_IndxServMap).ID_SERVICIO;
          Lr_InfoServicioHistorial.USR_CREACION           := Lv_UserMapeo;
          Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
          Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
          Lr_InfoServicioHistorial.ESTADO                 := La_ServiciosMapear(Ln_IndxServMap).ESTADO;
          Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
          Lr_InfoServicioHistorial.OBSERVACION            := 'Se registró correctamente el mapeo de la Promoción: '
                                                             ||Lv_Nombre|| ', para el tipo promocional: '
                                                             ||Lv_TipoPromo
                                                             ||', Fecha-Mapeo: '||TO_CHAR(Ld_FechaMapeo);
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
      END IF;
      --        
    END IF;                                   
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_PROMO_DEFINIDAS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UserMapeo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    --
    Pv_MsjResultado:= Lv_MsjResultado;
    --
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_PROMO_DEFINIDAS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UserMapeo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );   
    --
    Pv_MsjResultado:= Lv_MsjResultado;
    --
  END P_MAPEO_PROMO_DEFINIDAS;
  --
  --
  --
  PROCEDURE P_APLICA_PROMOCION(Pv_CodEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Pv_TipoPromo    IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                               Pn_IdServicio   IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                               Pv_TipoProceso  IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE DEFAULT NULL,
                               Pv_JobProceso   IN  VARCHAR2 DEFAULT NULL,
                               Pv_MsjResultado OUT VARCHAR2)
  IS
    --
    --Costo: Query para obtener Tipo de Solicitud: 5
    CURSOR C_ObtieneTipoSolicitud(Cv_EstadoParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                  Cv_NombreParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_TipoPromo         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                  Cv_CodEmpresa        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS  
      SELECT ATS.ID_TIPO_SOLICITUD
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
           DB_GENERAL.ADMI_PARAMETRO_DET APD,
           DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.VALOR2           = Cv_TipoPromo
      AND APC.ESTADO           = Cv_EstadoParametro
      AND APD.VALOR5           = ATS.DESCRIPCION_SOLICITUD
      AND APD.EMPRESA_COD      = Cv_CodEmpresa;
    --
    --Costo: Query para obtener Observacion de la solicitud: 4
    CURSOR C_ObtieneObservacionSolicitud(Cv_OrigenContrato       DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE, 
                                         Cv_ParametroSolicitudes DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                         Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DET.VALOR3
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.VALOR1           = Cv_OrigenContrato
      AND CAB.NOMBRE_PARAMETRO = Cv_ParametroSolicitudes
      AND DET.EMPRESA_COD      = Cv_CodEmpresa;
      --
    --Costo: Query para obtener Motivo de la solicitud de Instalacion: 4
     CURSOR C_ObtieneMotivoSolIns(Cv_OrigenContrato       DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE, 
                                  Cv_ParametroSolicitudes DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
      IS
      SELECT DET.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.VALOR1           = Cv_OrigenContrato
      AND CAB.NOMBRE_PARAMETRO = Cv_ParametroSolicitudes
      AND DET.EMPRESA_COD      = Cv_CodEmpresa;
      --
      --Costo: Query para obtener Descripcion de la solicitud: 5  
       CURSOR C_ObtieneDescripcionSolIns (Cv_ParametroSolicitudes DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Cv_OrigenContrato       DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE,
                                          Cv_EstadoParametro      DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                          Cv_EstadoInactivo       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                          Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
        IS
            SELECT  VALOR4
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET
             WHERE CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
               AND CAB.NOMBRE_PARAMETRO = Cv_ParametroSolicitudes
               AND CAB.ESTADO           = Cv_EstadoParametro
               AND DET.ESTADO           = Cv_EstadoParametro
               AND DET.VALOR1           = Cv_OrigenContrato
               AND DET.EMPRESA_COD      = Cv_CodEmpresa;
    --
    --Costo: Query para obtener Usuario de la Solicitud: 5
    CURSOR C_ObtieneUsuarioSolicitud(Cv_OrigenContrato       DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE, 
                                     Cv_ParametroSolicitudes DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                     Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DET.VALOR6
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.VALOR1           = Cv_OrigenContrato
      AND CAB.NOMBRE_PARAMETRO = Cv_ParametroSolicitudes
      AND DET.EMPRESA_COD      = Cv_CodEmpresa;
    --
    --Costo: Query para obtener Motivos de la solicitud: 2
    CURSOR C_ObtieneMotivoSolicitud(Cv_EstadoMotivo   DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE,
                                    Cv_NombreMotivo   DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
    IS  
      SELECT ID_MOTIVO 
      FROM DB_GENERAL.ADMI_MOTIVO 
      WHERE NOMBRE_MOTIVO = Cv_NombreMotivo 
      AND ESTADO          = Cv_EstadoMotivo;
    -- 
    --Costo: Query para obtener Persona Empresa Rol Id: 3
    CURSOR C_ObtienePersonaEnpresaRol(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, Cv_EstadoActivo DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE)
    IS
      SELECT PERSONA_EMPRESA_ROL_ID
      FROM DB_COMERCIAL.INFO_PUNTO
      WHERE ID_PUNTO = Cn_IdPunto
      AND ESTADO     = Cv_EstadoActivo;
    -- 
    --Costo: Query para obtener Origen Contrato: 2
    CURSOR C_ObtieneOrigenContrato(Cn_PersonaEmpresaRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, Lv_EstadoActivo DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
    IS
      SELECT  NVL(ORIGEN,'WEB') AS ORIGEN
      FROM DB_COMERCIAL.INFO_CONTRATO
      WHERE PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId;
    -- 
    --Costo: Query para obtener Caractersitica contrato: 4
    CURSOR C_ObtieneCaracContrato(Cv_OrigenContrato       DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE, 
                                  Cv_ParametroSolicitudes DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.VALOR1           = Cv_OrigenContrato
      AND CAB.NOMBRE_PARAMETRO = Cv_ParametroSolicitudes
      AND DET.EMPRESA_COD      = Cv_CodEmpresa;
    --
    --Costo: Query para obtener solicitudes activas: 4
    CURSOR C_ValidaSolicitudesActivas(Cn_IdDetallePromo DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE, Cv_Estado DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.ESTADO%TYPE)
    IS  
      SELECT COUNT(IDMS.ID_MAPEO_SOLICITUD) AS VALOR
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
      WHERE IDMS.DETALLE_MAPEO_ID = Cn_IdDetallePromo
      AND IDMS.ESTADO             = Cv_Estado; 
    --
    --Costo: Query para obtener nombre del plan: 2
    CURSOR C_ObtieneNombrePlan(Cn_PlanId DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE, Cv_EstadoActivo DB_COMERCIAL.INFO_PLAN_CAB.ESTADO%TYPE)
    IS
      SELECT NOMBRE_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB
      WHERE ID_PLAN = Cn_PlanId
      AND ESTADO    = Cv_EstadoActivo;
    --
    --Costo: Query para obtener la ultima milla del servicio: 5
    CURSOR C_GetUltMillaServ (Cn_ServicioId DB_COMERCIAL.INFO_SERVICIO_TECNICO.SERVICIO_ID%TYPE) IS
        SELECT atm.CODIGO_TIPO_MEDIO
          FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
          JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
            ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
         WHERE ist.SERVICIO_ID = Cn_ServicioId;
    --
    --Costo: 3
    CURSOR C_GetCicloProceso(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT
      ID_CICLO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE EMPRESA_COD = Cv_CodigoEmpresa
      and TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') = TO_NUMBER(TO_CHAR(sysdate, 'DD'), '99');
    --
    --Costo: 1
    CURSOR C_GetDiasRestar(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT
      TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') AS DIA_PROCESO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE EMPRESA_COD = Cv_CodigoEmpresa
      and id_ciclo='6';
    --
    Lr_SolicitudInstalacion DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion;
    Lv_DescripcionTipoSolicitud VARCHAR2(2000);
    Lv_MotivoSolicitudIns       VARCHAR2(2000);
    Lv_ObservacionSolicitud     VARCHAR2(2000);
    Lv_OrigenContrato           VARCHAR2(2000);
    Lv_NombrePlan               VARCHAR2(2000);
    Lv_UsuarioSolicitud         VARCHAR2(2000);
    Ln_IdPersonaEmpresaRol      NUMBER;
    Ln_ContadorSolicitudes      NUMBER                                         := 0;
    Ln_CantidadPeriodos         NUMBER                                         := 1;
    Ln_IdDetalleSolicitud       NUMBER                                         := 0;
    Lv_ParametroSolicitudes     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:= 'SOLICITUDES_DE_INSTALACION_X_SERVICIO';
    Lv_CaractContrato           DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;
    Lv_UltimaMilla              DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE;
    --
    Lv_IpCreacion               VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lr_InfoDetalleSolicitud     DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolHist       DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Ln_IdTipoSolicitud          NUMBER;
    Ln_IdMotivoSolicitud        NUMBER;    
    Ln_Indx                     NUMBER;
    La_RegistrosMapeados        T_RegistrosMapeados;
    Ln_TotalCommit              NUMBER:= 0;
    Ln_AnioMapeo                NUMBER;
    Ln_AnioMapeoCiclo2          NUMBER;
    Ln_MesMapeo                 NUMBER;
    Ln_MesMapeCiclo2            NUMBER;
    Ln_AnioMapCambioPrecio      NUMBER;
    Ln_MesMapCambioPrecio       NUMBER;
    Lv_EstadoActivo             VARCHAR2(15):='Activo';
    Lv_EstadoInactivo           VARCHAR2(15):='Inactivo';
    Lv_EstadoFinalizado         VARCHAR2(15):='Finalizado';
    Lv_EstadoAprobado           VARCHAR2(15):='Aprobado';
    Lv_NombreMotivo             VARCHAR2(20):='Descuento Promocion';
    Lv_NombreParamTipoSol       VARCHAR2(25):='PROM_TIPO_PROMOCIONES';
    Lv_UserAplicaPromo          VARCHAR2(20):='telcos_apl_prom';
    Lr_InfoServicioHistorial    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_InfoDetMapSolicitud      DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE; 
    Lr_InfoDetalleMapeoPromo    DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE; 
    Lv_MsjResultado             VARCHAR2(2000);
    Lex_Exception               EXCEPTION;
    Ln_TieneSolicitud           NUMBER;
    Lv_NombreParametro          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE';
    Lv_Descripcion              DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'NUMERO_DIAS_FECHA_PROCESA_ALCANCE';
    --
    Lv_Consulta                 VARCHAR2(4000);
    Lv_CadenaQuery              VARCHAR2(4000);
    Lv_CadenaFrom               VARCHAR2(3000);
    Lv_CadenaWhere              VARCHAR2(3000);    
    Lv_CadenaWhereFechas        VARCHAR2(3000);
    Lv_CadenaGroupBy            VARCHAR2(3000);
    Lrf_ClientesMapeo           SYS_REFCURSOR;  
    Ln_Ciclo                    NUMBER;   
    Ln_DiasRestar               NUMBER; 
    --
  BEGIN
     --  
      IF C_GetCicloProceso%ISOPEN THEN
        CLOSE C_GetCicloProceso;
      END IF;
      OPEN  C_GetCicloProceso(Pv_CodEmpresa);
      FETCH C_GetCicloProceso INTO Ln_Ciclo;
      CLOSE C_GetCicloProceso;
     --  
     --  
      IF C_GetDiasRestar%ISOPEN THEN
        CLOSE C_GetDiasRestar;
      END IF;
      OPEN  C_GetDiasRestar(Pv_CodEmpresa);
      FETCH C_GetDiasRestar INTO Ln_DiasRestar;
      CLOSE C_GetDiasRestar;
     -- 
      Ln_AnioMapeo := TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'));
      Ln_MesMapeo  := TO_NUMBER(TO_CHAR(SYSDATE,'MM'));
     --
      Ln_AnioMapCambioPrecio := TO_NUMBER(TO_CHAR(SYSDATE-1,'YYYY'));
      Ln_MesMapCambioPrecio  := TO_NUMBER(TO_CHAR(SYSDATE-1,'MM'));
     --
     IF Pv_TipoProceso IS NOT NULL AND Pv_JobProceso='JobFacturacion'  THEN
     --    
      Ln_MesMapeCiclo2:= TO_NUMBER(TO_CHAR(SYSDATE - NVL(Ln_DiasRestar,1),'MM'));
      Ln_AnioMapeoCiclo2 := TO_NUMBER(TO_CHAR(SYSDATE - NVL(Ln_DiasRestar,1),'YYYY'));
     --
     END IF;
     --
     Lv_CadenaQuery:= ' SELECT IDMS.ID_MAPEO_SOLICITUD,
        IDMS.SERVICIO_ID,
        IDMP.TIPO_PROMOCION,
        IDMP.PORCENTAJE,
        IDMP.ID_DETALLE_MAPEO,
        IDMP.PUNTO_ID,
        IDMS.PLAN_ID,
        IDMP.GRUPO_PROMOCION_ID ';
        
     Lv_CadenaFrom:= ' FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
           DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP ';
           
     Lv_CadenaWhere:='      WHERE IDMP.ID_DETALLE_MAPEO                  = IDMS.DETALLE_MAPEO_ID
      AND IDMS.ESTADO                              =  '''||Lv_EstadoActivo||'''
      AND IDMP.ESTADO                              =  '''||Lv_EstadoActivo||'''
      AND IDMP.EMPRESA_COD                         =  '''||Pv_CodEmpresa||'''
      AND IDMS.SERVICIO_ID                         = NVL('''||Pn_IdServicio||''',IDMS.SERVICIO_ID)
      AND IDMP.TIPO_PROMOCION                      IN (SELECT DET.VALOR2 
                                                       FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                         DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                       WHERE CAB.NOMBRE_PARAMETRO = ''PROM_TIPO_PROMOCIONES''
                                                       AND CAB.ESTADO             =  '''||Lv_EstadoActivo||'''
                                                       AND DET.PARAMETRO_ID       =  CAB.ID_PARAMETRO
                                                       AND DET.VALOR3             =  '''||Pv_TipoPromo||'''
                                                       AND DET.EMPRESA_COD        =  '''||Pv_CodEmpresa||'''
                                                       AND DET.ESTADO             =  '''||Lv_EstadoActivo||''')  ';

     Lv_CadenaWhereFechas:='  AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,''YYYY'')) =  '''||Ln_AnioMapeo||''' 
                              AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,''MM''))   =  '''||Ln_MesMapeo||''' ';
                              
     IF Pv_TipoProceso IS NOT NULL  AND Pv_JobProceso='JobFacturacion' THEN
      
        Lv_CadenaFrom:= Lv_CadenaFrom || '           ,DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
                                                      DB_COMERCIAL.ADMI_CARACTERISTICA            CA,
                                                      DB_FINANCIERO.ADMI_CICLO                    CI';
        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.TIPO_PROCESO             ='''||Pv_TipoProceso||'''
                                             AND CA.DESCRIPCION_CARACTERISTICA = ''CICLO_FACTURACION''
                                             AND CA.ID_CARACTERISTICA          = IPERC.CARACTERISTICA_ID
                                             AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,''^\d+'')),0)  = CI.ID_CICLO
                                             AND IPERC.ESTADO                                                = ''Activo''
                                             AND IPERC.PERSONA_EMPRESA_ROL_ID                                = IDMP.PERSONA_EMPRESA_ROL_ID
                                             AND CI.ID_CICLO                                               = '''||Ln_Ciclo||'''
                                             ';
      
        Lv_CadenaWhereFechas:='  AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,''YYYY'')) IN ( '''||Ln_AnioMapeo||''', '''||Ln_AnioMapeoCiclo2||''' )
                                     AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,''MM''))   IN ( '''||Ln_MesMapeo||''',  '''||Ln_MesMapeCiclo2||''') ';
                                    

     END IF;
     
       IF (Pv_TipoProceso='NUEVO'  AND Pv_JobProceso='JobDiario') OR  Pv_JobProceso='JobFacturacion' OR   Pv_JobProceso='JobDiarioCambioPrecio' THEN
          Lv_CadenaQuery:= ' SELECT min(IDMS.ID_MAPEO_SOLICITUD)  as ID_MAPEO_SOLICITUD,
                              IDMS.SERVICIO_ID,
                              IDMP.TIPO_PROMOCION,
                              IDMP.PORCENTAJE,
                              min(IDMP.ID_DETALLE_MAPEO) as ID_DETALLE_MAPEO,
                              IDMP.PUNTO_ID,
                              IDMS.PLAN_ID,
                              IDMP.GRUPO_PROMOCION_ID ';

          IF Pv_TipoProceso='NUEVO' THEN     
                 Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.TIPO_PROCESO             ='''||Pv_TipoProceso||'''';
          END IF;
          
          IF Pv_JobProceso='JobDiario'  OR Pv_JobProceso='JobDiarioCambioPrecio' THEN     
                 Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.PERIODO             =''1''';
          END IF;
          
          IF Pv_JobProceso='JobDiarioCambioPrecio' THEN  

                 Lv_CadenaWhereFechas:='  AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,''YYYY'')) =  '''||Ln_AnioMapCambioPrecio||''' 
                                          AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,''MM''))   =  '''||Ln_MesMapCambioPrecio||''' ';
          END IF;
                              
          Lv_CadenaGroupBy:='  GROUP BY  IDMS.SERVICIO_ID,IDMP.TIPO_PROMOCION,
                               IDMP.PORCENTAJE,IDMP.PUNTO_ID,
                               IDMS.PLAN_ID,  IDMP.GRUPO_PROMOCION_ID ';                                       
       END IF;
    
    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaWhereFechas || Lv_CadenaGroupBy ;    
 

    IF Lrf_ClientesMapeo%ISOPEN THEN
    --
      CLOSE Lrf_ClientesMapeo;
    --  
    END IF;
    
    IF UPPER(Pv_TipoPromo) = 'PROM_BW' AND Pn_IdServicio IS NULL THEN
       Lv_MsjResultado := 'Ocurrió un error, el servicio es un campo obligatorio para aplicar el tipo de promoción: '
                          ||Pv_TipoPromo;
       RAISE Lex_Exception;
    END IF;

    -- nuevo proceso por consulta dinamica
       OPEN Lrf_ClientesMapeo FOR Lv_Consulta;
        LOOP
        FETCH Lrf_ClientesMapeo BULK COLLECT    
        INTO La_RegistrosMapeados LIMIT 1000;
        EXIT WHEN La_RegistrosMapeados.count = 0;
        Ln_Indx := La_RegistrosMapeados.FIRST;
        WHILE (Ln_Indx IS NOT NULL)
        LOOP
       --
       BEGIN
        --
          Ln_TotalCommit := Ln_TotalCommit + 1;
          --
          IF C_ObtieneTipoSolicitud%ISOPEN THEN
            CLOSE C_ObtieneTipoSolicitud;
          END IF;
          --
          OPEN C_ObtieneTipoSolicitud(Lv_EstadoActivo,Lv_NombreParamTipoSol,La_RegistrosMapeados(Ln_Indx).TIPO_PROMOCION,Pv_CodEmpresa);
          FETCH C_ObtieneTipoSolicitud INTO Ln_IdTipoSolicitud;
          CLOSE C_ObtieneTipoSolicitud;
          --
          IF C_ObtieneMotivoSolicitud%ISOPEN THEN
            CLOSE C_ObtieneMotivoSolicitud;
          END IF;
          --
          OPEN C_ObtieneMotivoSolicitud(Lv_EstadoActivo,Lv_NombreMotivo);
          FETCH C_ObtieneMotivoSolicitud INTO Ln_IdMotivoSolicitud;
          CLOSE C_ObtieneMotivoSolicitud;
          --
       IF UPPER(Pv_TipoPromo) = 'PROM_INS' THEN
          IF C_ObtienePersonaEnpresaRol%ISOPEN THEN
            CLOSE C_ObtienePersonaEnpresaRol;
          END IF;
          --
          OPEN C_ObtienePersonaEnpresaRol(La_RegistrosMapeados(Ln_Indx).PUNTO_ID,Lv_EstadoActivo);
          FETCH C_ObtienePersonaEnpresaRol INTO Ln_IdPersonaEmpresaRol;
          CLOSE C_ObtienePersonaEnpresaRol;
          --
          IF C_ObtieneOrigenContrato%ISOPEN THEN
            CLOSE C_ObtieneOrigenContrato;
          END IF;
          --
          OPEN C_ObtieneOrigenContrato(Ln_IdPersonaEmpresaRol,Lv_EstadoActivo);
          FETCH C_ObtieneOrigenContrato INTO Lv_OrigenContrato;
          CLOSE C_ObtieneOrigenContrato;
          --
          IF C_ObtieneCaracContrato%ISOPEN THEN
            CLOSE C_ObtieneCaracContrato;
          END IF;
          --
          OPEN C_ObtieneCaracContrato(Lv_OrigenContrato,Lv_ParametroSolicitudes,Pv_CodEmpresa);
          FETCH C_ObtieneCaracContrato INTO Lv_CaractContrato;
          CLOSE C_ObtieneCaracContrato;
          --
          IF C_ObtieneObservacionSolicitud%ISOPEN THEN
            CLOSE C_ObtieneObservacionSolicitud;
          END IF;
          --
          OPEN C_ObtieneObservacionSolicitud(Lv_OrigenContrato,Lv_ParametroSolicitudes,Pv_CodEmpresa);
          FETCH C_ObtieneObservacionSolicitud INTO Lv_ObservacionSolicitud;
          CLOSE C_ObtieneObservacionSolicitud;
          --
          IF C_ObtieneUsuarioSolicitud%ISOPEN THEN
            CLOSE C_ObtieneUsuarioSolicitud;
          END IF;
          --
          OPEN C_ObtieneUsuarioSolicitud(Lv_OrigenContrato,Lv_ParametroSolicitudes,Pv_CodEmpresa);
          FETCH C_ObtieneUsuarioSolicitud INTO Lv_UsuarioSolicitud;
          CLOSE C_ObtieneUsuarioSolicitud;
           --
          IF C_ObtieneNombrePlan%ISOPEN THEN
            CLOSE C_ObtieneNombrePlan;
          END IF;
          --
         OPEN C_ObtieneNombrePlan(La_RegistrosMapeados(Ln_Indx).PLAN_ID,Lv_EstadoActivo);
          FETCH C_ObtieneNombrePlan INTO Lv_NombrePlan;
          CLOSE C_ObtieneNombrePlan;
          --
            IF C_ObtieneDescripcionSolIns%ISOPEN THEN
            CLOSE C_ObtieneDescripcionSolIns;
          END IF;
          --
          OPEN C_ObtieneDescripcionSolIns(Lv_ParametroSolicitudes,Lv_OrigenContrato,Lv_EstadoActivo,Lv_EstadoInactivo,Pv_CodEmpresa);
          FETCH C_ObtieneDescripcionSolIns INTO Lv_DescripcionTipoSolicitud;
          CLOSE C_ObtieneDescripcionSolIns;
          --
          IF C_GetUltMillaServ%ISOPEN THEN
            CLOSE C_GetUltMillaServ;
          END IF;
          --
          OPEN  C_GetUltMillaServ (La_RegistrosMapeados(Ln_Indx).SERVICIO_ID);
                           FETCH C_GetUltMillaServ INTO Lv_UltimaMilla;
                           CLOSE C_GetUltMillaServ;
          --C_ObtieneMotivoSolIns
          IF C_ObtieneMotivoSolIns%ISOPEN THEN
            CLOSE C_ObtieneMotivoSolIns;
          END IF;
          --
          OPEN C_ObtieneMotivoSolIns(Lv_OrigenContrato,Lv_ParametroSolicitudes,Pv_CodEmpresa);
          FETCH C_ObtieneMotivoSolIns INTO Lv_MotivoSolicitudIns;
          CLOSE C_ObtieneMotivoSolIns;
          --

            Ln_IdDetalleSolicitud :=0;

            Ln_CantidadPeriodos   := F_OBTIENE_PERIODOS(La_RegistrosMapeados(Ln_Indx).TIPO_PROMOCION, La_RegistrosMapeados(Ln_Indx).GRUPO_PROMOCION,Pv_CodEmpresa);
          --
              IF Ln_CantidadPeriodos='0' THEN
                Lv_MsjResultado:='Cantidad de periodos 0';
                RAISE Lex_Exception;
              END IF;

            IF Lv_ObservacionSolicitud                     IS NOT NULL THEN

              Lr_SolicitudInstalacion                      := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_SOL_INSTALACION (Pv_EmpresaCod => Pv_CodEmpresa, Pv_DescripcionSolicitud => Lv_DescripcionTipoSolicitud, Pv_CaractContrato => Lv_CaractContrato, Pv_NombreMotivo => Lv_MotivoSolicitudIns,Pv_UltimaMilla=>Lv_UltimaMilla);

              IF Lr_SolicitudInstalacion.ID_TIPO_SOLICITUD IS NULL THEN
                 Lv_MsjResultado:='No posee una solicitud configurada';
                RAISE Lex_Exception;
              END IF;
              Lr_SolicitudInstalacion.PUNTO_ID              := La_RegistrosMapeados(Ln_Indx).PUNTO_ID;
              Lr_SolicitudInstalacion.ID_SERVICIO           := La_RegistrosMapeados(Ln_Indx).SERVICIO_ID;
              Lr_SolicitudInstalacion.OBSERVACION_SOLICITUD := Lv_ObservacionSolicitud;
              Lr_SolicitudInstalacion.FORMA_PAGO            := 'EFECTIVO';
              Lr_SolicitudInstalacion.USR_CREACION          := Lv_UsuarioSolicitud;
              Lr_SolicitudInstalacion.NOMBRE_PLAN           := Lv_NombrePlan;
              Lr_SolicitudInstalacion.PORCENTAJE            := La_RegistrosMapeados(Ln_Indx).PORCENTAJE;
              Lr_SolicitudInstalacion.PERIODOS              := Ln_CantidadPeriodos;
              Lr_SolicitudInstalacion.APLICA_PROMO          := 'S';

              DB_COMERCIAL.COMEK_TRANSACTION.P_CREA_SOL_FACT_INSTALACION(Pr_SolicitudInstalacion => Lr_SolicitudInstalacion, Pv_Mensaje => Lv_MsjResultado, Pn_ContadorSolicitudes => Ln_ContadorSolicitudes,Pn_IdDetalleSolicitud => Ln_IdDetalleSolicitud);

              Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD  :=  Ln_IdDetalleSolicitud;
              Lr_InfoDetalleSolicitud.SERVICIO_ID           :=  La_RegistrosMapeados(Ln_Indx).SERVICIO_ID;

                IF Ln_IdDetalleSolicitud IS NOT NULL or Ln_IdDetalleSolicitud!=0 THEN
                    Pv_MsjResultado := 'OK';
                ELSE
                    Pv_MsjResultado := NULL;
                END IF;

            END IF;
          ELSE
          --
            Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD  := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL ;
            Lr_InfoDetalleSolicitud.SERVICIO_ID           := La_RegistrosMapeados(Ln_Indx).SERVICIO_ID;
            Lr_InfoDetalleSolicitud.TIPO_SOLICITUD_ID     := Ln_IdTipoSolicitud;
            Lr_InfoDetalleSolicitud.MOTIVO_ID             := Ln_IdMotivoSolicitud;
            Lr_InfoDetalleSolicitud.USR_CREACION          := Lv_UserAplicaPromo;
            Lr_InfoDetalleSolicitud.FE_CREACION           := SYSDATE;
            Lr_InfoDetalleSolicitud.PRECIO_DESCUENTO      := null;
            Lr_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO  := La_RegistrosMapeados(Ln_Indx).PORCENTAJE;
            Lr_InfoDetalleSolicitud.TIPO_DOCUMENTO        := null;
            Lr_InfoDetalleSolicitud.OBSERVACION           := 'Se aplica el tipo de promoción: '
                                                              || La_RegistrosMapeados(Ln_Indx).TIPO_PROMOCION;
            Lr_InfoDetalleSolicitud.ESTADO                := Lv_EstadoAprobado;
            Lr_InfoDetalleSolicitud.USR_RECHAZO           := null;
            Lr_InfoDetalleSolicitud.FE_RECHAZO            := null;
            Lr_InfoDetalleSolicitud.DETALLE_PROCESO_ID    := null;
            Lr_InfoDetalleSolicitud.FE_EJECUCION          := null;
            Lr_InfoDetalleSolicitud.ELEMENTO_ID           := null;

            P_INSERT_INFO_DET_SOLICITUD(Lr_InfoDetalleSolicitud, Lv_MsjResultado); 
            IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
              RAISE Lex_Exception;
            ELSE
              IF Ln_IdTipoSolicitud IS NOT NULL THEN
                --
                Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;
                Lr_InfoDetalleSolHist.ESTADO                 := Lr_InfoDetalleSolicitud.ESTADO;
                Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
                Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
                Lr_InfoDetalleSolHist.OBSERVACION            := 'Se aplica el tipo de promoción: '|| La_RegistrosMapeados(Ln_Indx).TIPO_PROMOCION;
                Lr_InfoDetalleSolHist.USR_CREACION           := Lv_UserAplicaPromo;
                Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
                Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
                Lr_InfoDetalleSolHist.MOTIVO_ID              := Lr_InfoDetalleSolicitud.MOTIVO_ID;
                --
                P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_MsjResultado);
                --
                IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                  RAISE Lex_Exception;
                END IF;

              END IF;
              --
            END IF;
            --
          END IF;
          -- 
            IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
              RAISE Lex_Exception;
            ELSE
              Lr_InfoDetMapSolicitud.ID_MAPEO_SOLICITUD  := La_RegistrosMapeados(Ln_Indx).ID_MAPEO_SOLICITUD;
              Lr_InfoDetMapSolicitud.SOLICITUD_ID        := Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;
              Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
              Lr_InfoDetMapSolicitud.USR_ULT_MOD         := Lv_UserAplicaPromo;
              Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;
              Lr_InfoDetMapSolicitud.ESTADO              := Lv_EstadoFinalizado;
              --
              P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud, Lv_MsjResultado); 
              --
              IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                RAISE Lex_Exception;
              END IF;
              --
              IF C_ValidaSolicitudesActivas%ISOPEN THEN
                CLOSE C_ValidaSolicitudesActivas;
              END IF;
              OPEN C_ValidaSolicitudesActivas(La_RegistrosMapeados(Ln_Indx).ID_DETALLE_MAPEO,Lv_EstadoActivo);
              FETCH C_ValidaSolicitudesActivas INTO Ln_TieneSolicitud;
              CLOSE C_ValidaSolicitudesActivas;
              IF Ln_TieneSolicitud = 0 THEN
              --
                Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO         :=La_RegistrosMapeados(Ln_Indx).ID_DETALLE_MAPEO;
                Lr_InfoDetalleMapeoPromo.FE_ULT_MOD               :=SYSDATE;
                Lr_InfoDetalleMapeoPromo.USR_ULT_MOD              :=Lv_UserAplicaPromo;
                Lr_InfoDetalleMapeoPromo.IP_ULT_MOD               :=Lv_IpCreacion;
                Lr_InfoDetalleMapeoPromo.ESTADO                   :=Lv_EstadoFinalizado;
                --
                --
                P_UPDATE_DETALLE_MAPEO_PROM(Lr_InfoDetalleMapeoPromo, Lv_MsjResultado); 
                --
                IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                  RAISE Lex_Exception;
                END IF;
              --
              END IF;
              --
              Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
              Lr_InfoServicioHistorial.SERVICIO_ID            := Lr_InfoDetalleSolicitud.SERVICIO_ID;
              Lr_InfoServicioHistorial.USR_CREACION           := Lv_UserAplicaPromo;
              Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
              Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
              Lr_InfoServicioHistorial.ESTADO                 := F_OBTIENE_ESTADO_SERV(Lr_InfoDetalleSolicitud.SERVICIO_ID);
              Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
              Lr_InfoServicioHistorial.OBSERVACION            := 'Se aplica el tipo de promoción: '|| 
                                                                   La_RegistrosMapeados(Ln_Indx).TIPO_PROMOCION;
              Lr_InfoServicioHistorial.ACCION                 := NULL;
              --
              P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado); 
              --
              IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                RAISE Lex_Exception;
              END IF;
          END IF;
          --

        --
        EXCEPTION
        WHEN Lex_Exception THEN
        --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_APLICA_PROMOCION', 
                                               ' -ERROR- '||Lv_MsjResultado,
                                               Lv_UserAplicaPromo,
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        WHEN OTHERS THEN
        --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_APLICA_PROMOCION', 
                                               'Error en P_APLICA_PROMOCION' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                               Lv_UserAplicaPromo,
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
        --
        END; 
        Ln_Indx := La_RegistrosMapeados.NEXT (Ln_Indx);
      --
      END LOOP;
       --
      IF Pv_TipoPromo = 'PROM_MENS' THEN
        COMMIT;
      END IF;
        Ln_TotalCommit := 0; 

    --
    END LOOP;
    --
    IF Pv_TipoPromo = 'PROM_BW' THEN
      IF TRIM(Lv_MsjResultado) IS NULL THEN
        Pv_MsjResultado := 'OK';
      ELSE
        Pv_MsjResultado := Lv_MsjResultado;
      END IF;
    ELSIF Pv_TipoPromo             != 'PROM_INS' THEN
      Pv_MsjResultado := 'OK';
    END IF;
  EXCEPTION
  WHEN Lex_Exception THEN
  --
    IF Pv_TipoPromo = 'PROM_MENS' THEN
         ROLLBACK;
    END IF;

    Pv_MsjResultado := Lv_MsjResultado;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_APLICA_PROMOCION', 
                                         ' -ERROR- '||Lv_MsjResultado,
                                         Lv_UserAplicaPromo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  WHEN OTHERS THEN

     IF Pv_TipoPromo = 'PROM_MENS' THEN
         ROLLBACK;
    END IF;

    Pv_MsjResultado := 'Error en P_APLICA_PROMOCION' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_APLICA_PROMOCION', 
                                         'Error en P_APLICA_PROMOCION' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UserAplicaPromo,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));        
  END P_APLICA_PROMOCION;  
  --
  --
  PROCEDURE P_VALIDA_PROMO_PLAN_PROD(Pn_Id_Detalle_Mapeo     IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
                                     Pn_Id_Promocion         IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                     Pn_Id_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                     Pv_Tipo_Promocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pn_IntIdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Pb_CumplePromo          OUT BOOLEAN,
                                     Pa_ServiciosMapeados    OUT T_ServiciosProcesar,
                                     Pa_ServiciosProcesar    OUT T_ServiciosProcesar,
                                     Pa_PierdeServiciosPromo OUT T_ServiciosProcesar,
                                     Pb_CumpleEstadoServ     OUT BOOLEAN)
  IS

    --Costo: 4
    CURSOR C_MapeoSolicitud(Cn_Id_Detalle_Mapeo DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE)
    IS   
      SELECT IDMS.SERVICIO_ID,
        IDMP.PUNTO_ID,
        IDMS.PLAN_ID,
        IDMS.PRODUCTO_ID,
        IDMS.PLAN_ID_SUPERIOR,
        ISE.ESTADO AS ESTADO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO  IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
        DB_COMERCIAL.INFO_SERVICIO                ISE
      WHERE ISE.ID_SERVICIO     = IDMS.SERVICIO_ID
      AND IDMS.ESTADO           != 'Baja'
      AND IDMS.DETALLE_MAPEO_ID = IDMP.ID_DETALLE_MAPEO
      AND IDMP.ID_DETALLE_MAPEO = Cn_Id_Detalle_Mapeo;

    --Costo: 4  
    CURSOR C_ServiciosPunto(Cv_Empresa VARCHAR2,
                            Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cv_Estado  VARCHAR2)
    IS   
      SELECT ISE.ID_SERVICIO,
        IP.ID_PUNTO,       
        ISE.PLAN_ID     AS ID_PLAN,
        ISE.PRODUCTO_ID AS ID_PRODUCTO,  
        NULL            AS PLAN_ID_SUPERIOR,
        ISE.ESTADO      AS ESTADO 
      FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR
      WHERE ISE.CANTIDAD            > 0
      AND IER.EMPRESA_COD           = Cv_Empresa
      AND ISE.ES_VENTA              = 'S'
      AND AR.DESCRIPCION_ROL        = 'Cliente'
      AND ISE.PRECIO_VENTA          > 0
      AND ISE.FRECUENCIA_PRODUCTO   = 1      
      AND IP.ID_PUNTO               = Cn_IdPunto	  
      AND IP.ID_PUNTO               = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL       = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA            = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL        = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                 = IER.ROL_ID
      AND ISE.ESTADO                IN (SELECT APD.VALOR1 
                                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                          DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                        AND APD.ESTADO           = 'Activo'
                                        AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                        AND APD.EMPRESA_COD      = Cv_Empresa
                                        AND APC.ESTADO           = 'Activo')
      ORDER BY ISE.ID_SERVICIO ASC;
     --Costo: 1
    CURSOR C_GetEmpresa ( Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)                    
    IS
      SELECT IEG.COD_EMPRESA
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE IEG.prefijo= DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(Cn_IdPunto,NULL);

    Lr_GrupoPromoRegla     Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla      Lr_TipoPromoReglaProcesar;
    Lv_TipoPromocion       DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
    Lv_IpCreacion          VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado        VARCHAR2(2000);
    Lv_EstadoServicio      VARCHAR2(20);
    Ln_CumpleServicio      NUMBER := 0;
    Ln_Contador            NUMBER := 0;
    Ln_Ind                 NUMBER := 1;
    Ln_Ind1                NUMBER;
    Ln_Ind2                NUMBER := 1;
    Ln_Ind3                NUMBER := 1;
    Lb_CumpleMplaMpro      BOOLEAN;
    Lb_CumpleEstadoServ    BOOLEAN := FALSE;
    Lv_CodEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  BEGIN
    --
    IF C_GetEmpresa%ISOPEN THEN
    --
      CLOSE C_GetEmpresa;
    --
    END IF;
    --
    OPEN C_GetEmpresa(Pn_IntIdPunto);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;
    
    --Verifico que los Planes y Productos definidos por Tipo Promocional se encuentren como servicios en el Punto para poder 
    --otorgar la promoción.   
    Pa_ServiciosMapeados.DELETE();
    Pa_ServiciosProcesar.DELETE();
    Pa_PierdeServiciosPromo.DELETE();
    --Obtengo los servicios a procesar por punto.
    IF Pv_Tipo_Promocion IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_TOT') THEN
      Lv_TipoPromocion   := 'PROM_MENS';
      Lr_GrupoPromoRegla := F_GET_PROMO_GRUPO_REGLA(Pn_Id_Promocion);  
      Lv_EstadoServicio  := Lr_GrupoPromoRegla.PROM_ESTADO_SERVICIO;
    ELSE
      Lv_TipoPromocion  := Pv_Tipo_Promocion;
      Lr_TipoPromoRegla := F_GET_PROMO_TIPO_REGLA(Pn_Id_Tipo_Promocion);  
      Lv_EstadoServicio := Lr_TipoPromoRegla.PROM_ESTADO_SERVICIO;
    END IF;

    FOR Lc_Mapeo_Solicitud IN C_MapeoSolicitud(Pn_Id_Detalle_Mapeo)
    LOOP
    --
      Pa_ServiciosMapeados(Ln_Ind).ID_SERVICIO      := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PUNTO         := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PLAN          := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PRODUCTO      := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_ServiciosMapeados(Ln_Ind).PLAN_ID_SUPERIOR := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_ServiciosMapeados(Ln_Ind).ESTADO           := Lc_Mapeo_Solicitud.ESTADO;
      Ln_Ind                                        := Ln_Ind + 1;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                'Cursor C_MapeoSolicitud - Pn_Id_Detalle_Mapeo:'|| Pn_Id_Detalle_Mapeo ||'Lc_Mapeo_Solicitud.SERVICIO_ID:'
                ||Lc_Mapeo_Solicitud.SERVICIO_ID ||' -Lc_Mapeo_Solicitud.PUNTO_ID:'||Lc_Mapeo_Solicitud.PUNTO_ID
                ||' -Lc_Mapeo_Solicitud.PLAN_ID:'||Lc_Mapeo_Solicitud.PLAN_ID||' -Lc_Mapeo_Solicitud.PRODUCTO_ID:'
                ||Lc_Mapeo_Solicitud.PRODUCTO_ID||' -Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR:'||Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR 
                ||' -Lc_Mapeo_Solicitud.ESTADO:'||Lc_Mapeo_Solicitud.ESTADO,
                'telcos_mapeo_promo',
                SYSDATE,
                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    --
    END LOOP;

    IF Pv_Tipo_Promocion = 'PROM_TOT' THEN
    --
      FOR Lc_ServiciosPunto IN C_ServiciosPunto(Lv_CodEmpresa,
                                                Pn_IntIdPunto,
                                                Lv_EstadoServicio)
      LOOP
      --
        Pa_ServiciosProcesar(Ln_Ind2).ID_SERVICIO      := Lc_ServiciosPunto.ID_SERVICIO;
        Pa_ServiciosProcesar(Ln_Ind2).ID_PUNTO         := Lc_ServiciosPunto.ID_PUNTO;
        Pa_ServiciosProcesar(Ln_Ind2).ID_PLAN          := Lc_ServiciosPunto.ID_PLAN;
        Pa_ServiciosProcesar(Ln_Ind2).ID_PRODUCTO      := Lc_ServiciosPunto.ID_PRODUCTO;
        Pa_ServiciosProcesar(Ln_Ind2).PLAN_ID_SUPERIOR := Lc_ServiciosPunto.PLAN_ID_SUPERIOR;
        Pa_ServiciosProcesar(Ln_Ind2).ESTADO           := Lc_ServiciosPunto.ESTADO;
        Ln_Ind2                                        := Ln_Ind2 + 1;
      --  
      END LOOP;
    --
    ELSE
    --
      IF Pa_ServiciosMapeados.COUNT > 0 THEN 
      --
        Ln_Ind1 := Pa_ServiciosMapeados.FIRST;   
        WHILE (Ln_Ind1 IS NOT NULL)   
        LOOP
        --
          Ln_Contador := Ln_Contador + 1;
          FOR Lc_ServiciosPunto IN C_ServiciosPunto(Lv_CodEmpresa,
                                                    Pa_ServiciosMapeados(Ln_Ind1).ID_PUNTO,
                                                    Lv_EstadoServicio)
          LOOP
          --
            Lb_CumpleEstadoServ:= TRUE;    
            Lb_CumpleMplaMpro  := FALSE;
            IF (Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN IS NOT NULL
                AND Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO = Lc_ServiciosPunto.ID_SERVICIO
                AND Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN = Lc_ServiciosPunto.ID_PLAN) OR 
               (Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO IS NOT NULL 
                AND Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO = Lc_ServiciosPunto.ID_SERVICIO
                AND Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO = Lc_ServiciosPunto.ID_PRODUCTO) THEN
            --
              Ln_CumpleServicio := Ln_CumpleServicio + 1;
              Lb_CumpleMplaMpro := TRUE;    

              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                        'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                        'Cursor C_ServiciosPunto Ingreso a -Ln_CumpleServicio- -Pa_ServiciosMapeados.ID_PLAN:'
                        ||Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN||' -Pa_ServiciosMapeados.ID_SERVICIO:'
                        ||Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO 
                        || ' -Lc_ServiciosPunto.ID_SERVICIO:'||Lc_ServiciosPunto.ID_SERVICIO
                        ||' -Pa_ServiciosMapeados.ID_PLAN:'||Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN 
                        || ' -Lc_ServiciosPunto.ID_PLAN:'||Lc_ServiciosPunto.ID_PLAN 
                        ||' -Pa_ServiciosMapeados.ID_PRODUCTO:'||Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO
                        || ' -Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO:'||Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO
                        || ' -Lc_ServiciosPunto.ID_SERVICIO:'||Lc_ServiciosPunto.ID_SERVICIO
                        ||' -Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO:'||Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO
                        || '-Lc_ServiciosPunto.ID_PRODUCTO:'||Lc_ServiciosPunto.ID_PRODUCTO, 
                        'telcos_mapeo_promo',
                        SYSDATE,
                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));        
            --         
            END IF;
            IF Lb_CumpleMplaMpro THEN
            --
              Pa_ServiciosProcesar(Ln_Ind2).ID_SERVICIO      := Lc_ServiciosPunto.ID_SERVICIO;
              Pa_ServiciosProcesar(Ln_Ind2).ID_PUNTO         := Lc_ServiciosPunto.ID_PUNTO;
              Pa_ServiciosProcesar(Ln_Ind2).ID_PLAN          := Lc_ServiciosPunto.ID_PLAN;
              Pa_ServiciosProcesar(Ln_Ind2).ID_PRODUCTO      := Lc_ServiciosPunto.ID_PRODUCTO;
              Pa_ServiciosProcesar(Ln_Ind2).PLAN_ID_SUPERIOR := Lc_ServiciosPunto.PLAN_ID_SUPERIOR;
              Pa_ServiciosProcesar(Ln_Ind2).ESTADO           := Lc_ServiciosPunto.ESTADO;
              Ln_Ind2                                        := Ln_Ind2 + 1;

              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                        'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                        'Ingreso a Lb_CumpleMplaMpro. - Lc_ServiciosPunto.ID_SERVICIO:'
                        || Lc_ServiciosPunto.ID_SERVICIO ||' -Lc_ServiciosPunto.ID_PUNTO:'||Lc_ServiciosPunto.ID_PUNTO
                        || ' -Lc_ServiciosPunto.ID_PLAN:'||Lc_ServiciosPunto.ID_PLAN
                        ||' -Lc_ServiciosPunto.ID_PRODUCTO:'||Lc_ServiciosPunto.ID_PRODUCTO
                        ||' -Lc_ServiciosPunto.PLAN_ID_SUPERIOR:'||Lc_ServiciosPunto.PLAN_ID_SUPERIOR
                        ||' -Lc_ServiciosPunto.ESTADO:'||Lc_ServiciosPunto.ESTADO, 
                        'telcos_mapeo_promo',
                        SYSDATE,
                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
            --
            END IF;
          --  
          END LOOP;
          IF Ln_CumpleServicio = 0 THEN
            Pa_PierdeServiciosPromo(Ln_Ind3).ID_SERVICIO      := Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO;
            Pa_PierdeServiciosPromo(Ln_Ind3).ID_PUNTO         := Pa_ServiciosMapeados(Ln_Ind1).ID_PUNTO;
            Pa_PierdeServiciosPromo(Ln_Ind3).ID_PLAN          := Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN;
            Pa_PierdeServiciosPromo(Ln_Ind3).ID_PRODUCTO      := Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO;
            Pa_PierdeServiciosPromo(Ln_Ind3).PLAN_ID_SUPERIOR := Pa_ServiciosMapeados(Ln_Ind1).PLAN_ID_SUPERIOR;
            Pa_PierdeServiciosPromo(Ln_Ind3).ESTADO           := Pa_ServiciosMapeados(Ln_Ind1).ESTADO;
            Ln_Ind3                                           := Ln_Ind3 + 1;

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                      'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                      'Ingreso a Ln_CumpleServicio. - Ln_CumpleServicio:'|| Ln_CumpleServicio 
                      ||' -Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO:'||Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO
                      ||' -Pa_ServiciosMapeados(Ln_Ind1).ID_PUNTO:'||Pa_ServiciosMapeados(Ln_Ind1).ID_PUNTO
                      ||' -Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN:'||Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN
                      ||' -Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO:'
                      ||Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO
                      ||' -Pa_ServiciosMapeados(Ln_Ind1).PLAN_ID_SUPERIOR:'||Pa_ServiciosMapeados(Ln_Ind1).PLAN_ID_SUPERIOR
                      ||' -Pa_ServiciosMapeados(Ln_Ind1).ESTADO:'||Pa_ServiciosMapeados(Ln_Ind1).ESTADO, 
                      'telcos_mapeo_promo',
                      SYSDATE,
                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

          END IF;
          Ln_CumpleServicio := 0;
          Ln_Ind1           := Pa_ServiciosMapeados.NEXT(Ln_Ind1);
        --
        END LOOP;
      --
      END IF;
    --
    END IF;
   
   Pb_CumpleEstadoServ := Lb_CumpleEstadoServ;
    IF Ln_Contador = 0 AND Pv_Tipo_Promocion != 'PROM_TOT' THEN
      Pb_CumplePromo := FALSE;
    ELSE
      IF Pa_ServiciosProcesar.COUNT != Pa_ServiciosMapeados.COUNT AND
         Pv_Tipo_Promocion != 'PROM_TOT' THEN
         Pb_CumplePromo := FALSE;

         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                                         'Ingreso a IF Pa_ServiciosProcesar.COUNT != Pa_ServiciosMapeados.COUNT -> Pb_CumplePromo := FALSE ', 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
      ELSE 
        Pb_CumplePromo := TRUE;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                                         'Ingreso a ELSE -> Pb_CumplePromo := TRUE', 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      END IF;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Pa_ServiciosProcesar.DELETE();
    Pb_CumplePromo := FALSE;
    Ln_Ind         := 1;
    Pa_ServiciosMapeados.DELETE();
    FOR Lc_Mapeo_Solicitud IN C_MapeoSolicitud(Pn_Id_Detalle_Mapeo)
    LOOP
    --
      Pa_ServiciosMapeados(Ln_Ind).ID_SERVICIO         := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PUNTO            := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PLAN             := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PRODUCTO         := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_ServiciosMapeados(Ln_Ind).PLAN_ID_SUPERIOR    := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_ServiciosMapeados(Ln_Ind).ESTADO              := Lc_Mapeo_Solicitud.ESTADO;

      Pa_ServiciosProcesar(Ln_Ind).ID_SERVICIO         := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_ServiciosProcesar(Ln_Ind).ID_PUNTO            := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_ServiciosProcesar(Ln_Ind).ID_PLAN             := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_ServiciosProcesar(Ln_Ind).ID_PRODUCTO         := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_ServiciosProcesar(Ln_Ind).PLAN_ID_SUPERIOR    := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_ServiciosProcesar(Ln_Ind).ESTADO              := Lc_Mapeo_Solicitud.ESTADO;

      Pa_PierdeServiciosPromo(Ln_Ind).ID_SERVICIO      := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).ID_PUNTO         := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).ID_PLAN          := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).ID_PRODUCTO      := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).PLAN_ID_SUPERIOR := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_PierdeServiciosPromo(Ln_Ind).ESTADO           := Lc_Mapeo_Solicitud.ESTADO;

      Ln_Ind:=Ln_Ind + 1;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                'Ingreso a WHEN OTHERS - C_MapeoSolicitud -Lc_Mapeo_Solicitud.SERVICIO_ID:'
                ||Lc_Mapeo_Solicitud.SERVICIO_ID || '-Lc_Mapeo_Solicitud.PLAN_ID:'||Lc_Mapeo_Solicitud.PLAN_ID
                || ' -Lc_Mapeo_Solicitud.PRODUCTO_ID:'||Lc_Mapeo_Solicitud.PRODUCTO_ID
                || ' -Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR:'||Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR
                || ' -Lc_Mapeo_Solicitud.ESTADO:'||Lc_Mapeo_Solicitud.ESTADO, 
                'telcos_mapeo_promo',
                 SYSDATE,
                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    --
    END LOOP;
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Planes y Producto del GRUPO_PROMOCION: '
                        || Pn_Id_Promocion || ' - ' || Pv_Tipo_Promocion || ' para el ID_PUNTO: ' || Pn_IntIdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));                   
  END P_VALIDA_PROMO_PLAN_PROD;
  --
  --
  --
  PROCEDURE P_EJECUTA_MAPEO_MENSUAL(Pv_Empresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_TipoPromo  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
  IS
    Ln_DiaActual     NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'DD'), '99');
    Lv_MsjResultado  VARCHAR2(2000);
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    --Costo: 2
    CURSOR C_GetCiclosDiaProceso(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ID_CICLO,
      (CASE
        WHEN TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') = 1
        THEN (TO_NUMBER(TO_CHAR(LAST_DAY(SYSDATE), 'DD'), '99')-1)
        ELSE (TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99')-1)
       END) AS DIA_PROCESO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE EMPRESA_COD = Cv_CodigoEmpresa
    UNION
    SELECT ID_CICLO,      
    TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') AS DIA_PROCESO
    FROM DB_FINANCIERO.ADMI_CICLO
    WHERE EMPRESA_COD = Cv_CodigoEmpresa;

  BEGIN
    FOR Lr_GetCiclosDiaProceso IN C_GetCiclosDiaProceso(Pv_Empresa)
    LOOP
      IF Ln_DiaActual = Lr_GetCiclosDiaProceso.DIA_PROCESO THEN      
        P_MAPEO_MENSUAL_POR_CICLO(Pv_Empresa,
                                  Pv_TipoPromo,
                                  Lr_GetCiclosDiaProceso.ID_CICLO);
      END IF;
    END LOOP;

  EXCEPTION 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrió un error al ejecutar el Proceso Mensual de Mapeo de Promociones
                       para el Grupo Promocional: '||Pv_TipoPromo;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_EJECUTA_MAPEO_MENSUAL', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            
  END P_EJECUTA_MAPEO_MENSUAL;
  --
  --
  --
  PROCEDURE P_MAPEO_MENSUAL_POR_CICLO (Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoPromo   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pn_IdCiclo     IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE) IS

    --Costo: 78
    CURSOR C_ClientesMapeo (Cv_Cod_Empresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                            Cv_TipoPromo    DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                            Cn_IdCiclo      DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,
                            Cv_EstadoActivo VARCHAR2)
    IS    
      SELECT DISTINCT IDMP.ID_DETALLE_MAPEO,
        IDMP.GRUPO_PROMOCION_ID, 
        IDMP.TIPO_PROMOCION_ID,
        IDMP.PERSONA_EMPRESA_ROL_ID,
        IDMP.PUNTO_ID,
        IDMP.TIPO_PROMOCION,
        'N' AS INDEFINIDO,
        IDMP.FE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO    IDMP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION            ATP,
        DB_COMERCIAL.INFO_SERVICIO                  ISER,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL        ISH,
        DB_COMERCIAL.INFO_PLAN_DET                  IPD,
        DB_COMERCIAL.ADMI_PRODUCTO                  AP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
        DB_COMERCIAL.ADMI_CARACTERISTICA            CA,
        DB_FINANCIERO.ADMI_CICLO                    CI,
        (SELECT DISTINCT T.ID_DETALLE_MAPEO 
         FROM(SELECT MAX(IDMP.ID_DETALLE_MAPEO) AS ID_DETALLE_MAPEO,
                IDMP.GRUPO_PROMOCION_ID, 
                IDMP.PERSONA_EMPRESA_ROL_ID,
                IDMP.PUNTO_ID,
                IDMP.TIPO_PROMOCION_ID,
                IDMS.SERVICIO_ID
              FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
              WHERE IDMP.INDEFINIDO IS NULL
              AND UPPER(IDMP.TIPO_PROCESO) = 'EXISTENTE'
              AND IDMP.TIPO_PROMOCION      IN (SELECT DET.VALOR2 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET DET
                                               WHERE CAB.NOMBRE_PARAMETRO = 'PROM_TIPO_PROMOCIONES'
                                               AND CAB.ESTADO             = Cv_EstadoActivo
                                               AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                               AND DET.VALOR3             = Cv_TipoPromo
                                               AND DET.ESTADO             = Cv_EstadoActivo
                                               AND DET.EMPRESA_COD        = Cv_Cod_Empresa)
              AND IDMP.EMPRESA_COD         = Cv_Cod_Empresa
              AND IDMS.DETALLE_MAPEO_ID    = IDMP.ID_DETALLE_MAPEO
              GROUP BY IDMP.GRUPO_PROMOCION_ID,
              IDMP.PERSONA_EMPRESA_ROL_ID,
              IDMP.PUNTO_ID,
              IDMP.TIPO_PROMOCION_ID,
              IDMS.SERVICIO_ID)T) DEF
      WHERE CA.DESCRIPCION_CARACTERISTICA                             = 'CICLO_FACTURACION'
        AND CA.ID_CARACTERISTICA                                      = IPERC.CARACTERISTICA_ID
        AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0)  = CI.ID_CICLO
        AND IPERC.ESTADO                                              = Cv_EstadoActivo
        AND IPERC.PERSONA_EMPRESA_ROL_ID                              = IDMP.PERSONA_EMPRESA_ROL_ID
        AND CI.ID_CICLO                                               = Cn_IdCiclo
        AND ATP.ESTADO                != 'Baja'
        AND ATP.ID_TIPO_PROMOCION     = IDMP.TIPO_PROMOCION_ID
        AND AP.CODIGO_PRODUCTO        = 'INTD'
        AND AP.ID_PRODUCTO            = IPD.PRODUCTO_ID
        AND IPD.PLAN_ID               = ISER.PLAN_ID
        AND (ISH.ESTADO               IN (SELECT APD.VALOR1 
                                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                            DB_GENERAL.ADMI_PARAMETRO_DET APD
                                          WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                            AND APD.ESTADO           = Cv_EstadoActivo
                                            AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                            AND APC.ESTADO           = Cv_EstadoActivo
                                            AND APD.EMPRESA_COD      = Cv_Cod_Empresa)
            OR 
            ISER.ESTADO               IN (SELECT APD.VALOR1 
                                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                            DB_GENERAL.ADMI_PARAMETRO_DET APD
                                          WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                            AND APD.ESTADO           = Cv_EstadoActivo
                                            AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                            AND APC.ESTADO           = Cv_EstadoActivo
                                            AND APD.EMPRESA_COD      = Cv_Cod_Empresa))
        AND ISH.ID_SERVICIO_HISTORIAL = (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) 
                                         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH
                                         WHERE DBISH.servicio_id = ISER.ID_SERVICIO)
        AND ISH.SERVICIO_ID           = ISER.ID_SERVICIO
        AND ISER.PUNTO_ID             = IDMP.PUNTO_ID
        AND TRUNC(IDMP.FE_MAPEO) <= TRUNC(SYSDATE)
        AND IDMP.CANTIDAD_PERIODOS > IDMP.MAPEOS_GENERADOS
        AND (TO_CHAR(IDMP.FE_SIGUIENTE_MAPEO,'MM/RRRR') = TO_CHAR(SYSDATE,'MM/RRRR')
             OR TO_DATE(TO_CHAR(IDMP.FE_SIGUIENTE_MAPEO,'DD/MM/RRRR'),'DD/MM/RRRR') < TO_DATE(TO_CHAR(SYSDATE,'DD/MM/RRRR'),'DD/MM/RRRR'))
        AND IDMP.ESTADO               != 'Baja'
        AND IDMP.ID_DETALLE_MAPEO     = DEF.ID_DETALLE_MAPEO
      UNION
      SELECT DISTINCT IDMP.ID_DETALLE_MAPEO,
        IDMP.GRUPO_PROMOCION_ID, 
        IDMP.TIPO_PROMOCION_ID,
        IDMP.PERSONA_EMPRESA_ROL_ID,
        IDMP.PUNTO_ID,
        IDMP.TIPO_PROMOCION,
        'S' AS INDEFINIDO,
        IDMP.FE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO    IDMP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION            ATP,
        DB_COMERCIAL.INFO_SERVICIO                  ISER,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL        ISH,
        DB_COMERCIAL.INFO_PLAN_DET                  IPD,
        DB_COMERCIAL.ADMI_PRODUCTO                  AP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
        DB_COMERCIAL.ADMI_CARACTERISTICA            CA,
        DB_FINANCIERO.ADMI_CICLO                    CI,
        (SELECT DISTINCT T.ID_DETALLE_MAPEO 
         FROM(SELECT MAX(IDMP.ID_DETALLE_MAPEO) AS ID_DETALLE_MAPEO,
                IDMP.GRUPO_PROMOCION_ID, 
                IDMP.PERSONA_EMPRESA_ROL_ID,
                IDMP.PUNTO_ID,
                IDMP.TIPO_PROMOCION_ID,
                IDMS.SERVICIO_ID
              FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
              WHERE IDMP.INDEFINIDO    IS NOT NULL
              AND IDMP.TIPO_PROMOCION  IN (SELECT DET.VALOR2 
                                           FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                             DB_GENERAL.ADMI_PARAMETRO_DET DET
                                           WHERE CAB.NOMBRE_PARAMETRO = 'PROM_TIPO_PROMOCIONES'
                                           AND CAB.ESTADO             = Cv_EstadoActivo
                                           AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                           AND DET.VALOR3             = Cv_TipoPromo
                                           AND DET.ESTADO             = Cv_EstadoActivo
                                           AND DET.EMPRESA_COD        = Cv_Cod_Empresa)
              AND IDMP.EMPRESA_COD      = Cv_Cod_Empresa
              AND IDMS.DETALLE_MAPEO_ID = IDMP.ID_DETALLE_MAPEO
              GROUP BY IDMP.GRUPO_PROMOCION_ID, 
              IDMP.PERSONA_EMPRESA_ROL_ID,
              IDMP.PUNTO_ID,
              IDMP.TIPO_PROMOCION_ID,
              IDMS.SERVICIO_ID)T) INDEF
      WHERE CA.DESCRIPCION_CARACTERISTICA                             = 'CICLO_FACTURACION'
        AND CA.ID_CARACTERISTICA                                      = IPERC.CARACTERISTICA_ID
        AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0)  = CI.ID_CICLO
        AND IPERC.ESTADO                                              = Cv_EstadoActivo
        AND IPERC.PERSONA_EMPRESA_ROL_ID                              = IDMP.PERSONA_EMPRESA_ROL_ID
        AND CI.ID_CICLO                                               = Cn_IdCiclo
        AND ATP.ESTADO                != 'Baja'
        AND ATP.ID_TIPO_PROMOCION     = IDMP.TIPO_PROMOCION_ID
        AND AP.CODIGO_PRODUCTO        = 'INTD'
        AND AP.ID_PRODUCTO            = IPD.PRODUCTO_ID
        AND IPD.PLAN_ID               = ISER.PLAN_ID
        AND (ISH.ESTADO               IN (SELECT APD.VALOR1 
                                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                            DB_GENERAL.ADMI_PARAMETRO_DET APD
                                          WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                            AND APD.ESTADO           = Cv_EstadoActivo
                                            AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                            AND APC.ESTADO           = Cv_EstadoActivo
                                            AND APD.EMPRESA_COD      = Cv_Cod_Empresa)
             OR
             ISER.ESTADO              IN (SELECT APD.VALOR1 
                                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                            DB_GENERAL.ADMI_PARAMETRO_DET APD
                                          WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                            AND APD.ESTADO           = Cv_EstadoActivo
                                            AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                            AND APC.ESTADO           = Cv_EstadoActivo
                                            AND APD.EMPRESA_COD      = Cv_Cod_Empresa)
             )
        AND ISH.ID_SERVICIO_HISTORIAL = (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) 
                                         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH
                                         WHERE DBISH.servicio_id = ISER.ID_SERVICIO)
        AND ISH.SERVICIO_ID           = ISER.ID_SERVICIO
        AND ISER.PUNTO_ID             = IDMP.PUNTO_ID
        AND (TO_CHAR(IDMP.FE_SIGUIENTE_MAPEO,'MM/RRRR') = TO_CHAR(SYSDATE,'MM/RRRR')
             OR TO_DATE(TO_CHAR(IDMP.FE_SIGUIENTE_MAPEO,'DD/MM/RRRR'),'DD/MM/RRRR') < TO_DATE(TO_CHAR(SYSDATE,'DD/MM/RRRR'),'DD/MM/RRRR'))
        AND IDMP.ESTADO               != 'Baja'
        AND IDMP.ID_DETALLE_MAPEO     = INDEF.ID_DETALLE_MAPEO;

    Lv_Status                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE;
    Lr_TipoPromoRegla         Lr_TipoPromoReglaProcesar;
    Lr_GrupoPromoRegla        Lr_GrupoPromoReglaProcesar;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    La_SectorizacionProcesar  T_SectorizacionProcesar;
    La_ClientesProcesar       T_ClientesProcesar;
    La_ServiciosMapeados      T_ServiciosProcesar;
    La_ServiciosProcesar      T_ServiciosProcesar;
    La_ServiciosPerdidos      T_ServiciosProcesar;
    Lb_AplicaMapeo            BOOLEAN := TRUE;
    Ln_Indx                   NUMBER;
    Lv_EstadoActivo           VARCHAR2(6) := 'Activo';
    Lv_msj                    VARCHAR2(3200);
    Lv_msj2                   VARCHAR2(3200);
    Lv_Observacion            VARCHAR2(32000);
    Lv_Trama                  VARCHAR2(4000);
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lex_Exception             EXCEPTION;
    Lr_ParametrosValidarSec   DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    Lb_CumpleEstadoServ       BOOLEAN;

  BEGIN
  --
    OPEN C_ClientesMapeo (Pv_Empresa,
                          Pv_TipoPromo,
                          Pn_IdCiclo,
                          Lv_EstadoActivo);
     LOOP
     --
      FETCH C_ClientesMapeo BULK COLLECT
      --
        INTO La_ClientesProcesar LIMIT 1000;
        EXIT WHEN La_ClientesProcesar.count = 0;
        Ln_Indx := La_ClientesProcesar.FIRST;
        WHILE (Ln_Indx IS NOT NULL)
        LOOP
        --
          BEGIN
          Lv_Status      := 'Activo';
          Lb_AplicaMapeo := TRUE;

          P_VALIDA_PROMO_PLAN_PROD(La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO,
                                   La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                   La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID,
                                   La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                   La_ClientesProcesar(Ln_Indx).PUNTO_ID,
                                   Lb_AplicaMapeo,
                                   La_ServiciosMapeados,
                                   La_ServiciosProcesar,
                                   La_ServiciosPerdidos,
                                   Lb_CumpleEstadoServ);

          IF NOT Lb_AplicaMapeo THEN
            IF La_ServiciosMapeados.COUNT = La_ServiciosPerdidos.COUNT OR (
               La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION = 'PROM_MIX' AND La_ServiciosPerdidos.COUNT > 0) THEN
              Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                ' indefinidamente por imcumplir la Regla de Planes y Productos.';
              P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                      Lv_Observacion,
                                      Lv_msj);

              IF TRIM(Lv_msj) IS NOT NULL THEN
              --
                Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
                RAISE Lex_Exception;
              --
              END IF;
              Lb_AplicaMapeo := FALSE;
              Lv_Status      := 'Baja';
            ELSE
              Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                ' indefinidamente por imcumplir la Regla de Planes y Productos.';
              P_INSERTA_HIST_SERVICIO(La_ServiciosPerdidos,
                                      Lv_Observacion,
                                      Lv_msj);

              IF TRIM(Lv_msj) IS NOT NULL THEN
              --
                Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
                RAISE Lex_Exception;
              --
              END IF;
              Lb_AplicaMapeo := TRUE;
            END IF;
          END IF;

          Lr_ParametrosValidarSec                    :=  NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_TIPO_PROMOCION  :=  La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_PUNTO           :=  La_ClientesProcesar(Ln_Indx).PUNTO_ID;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'EXISTENTE';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_MENS';
          Lr_ParametrosValidarSec.EMPRESA_COD        := Pv_Empresa;--MENSUALIDAD

          IF Lb_AplicaMapeo AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec)) THEN

            Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                              ' indefinidamente por imcumplir la Regla de Sectorización.';
            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            --
            END IF;

            Lb_AplicaMapeo := FALSE;
            Lv_Status      := 'Baja';
          END IF;

          IF Lb_AplicaMapeo AND 
             NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                         Fn_IdPunto        => La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
            Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                              ' indefinidamente por imcumplir la Regla de Forma de Pago.';
            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            --
            END IF;

            Lb_AplicaMapeo := FALSE;
            Lv_Status      := 'Baja';
          END IF;

          IF Lb_AplicaMapeo AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                                      La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                                                                      La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
            Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                              ' momentaneamente por imcumplir la Regla por Mora.';
            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            --
            END IF;

            Lb_AplicaMapeo := FALSE;
            Lv_Status      := 'Eliminado';
          END IF;

          La_SectorizacionProcesar.DELETE();
          Lr_InfoDetalleMapeoPromo                        := NULL;
          Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
          Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
          Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID      := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
          Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
          Lr_InfoDetalleMapeoPromo.PUNTO_ID               := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
          Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION         := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION;
          Lr_InfoDetalleMapeoPromo.INDEFINIDO             := La_ClientesProcesar(Ln_Indx).INDEFINIDO;
          Lr_InfoDetalleMapeoPromo.FE_MAPEO               := La_ClientesProcesar(Ln_Indx).FE_MAPEO;
          Lr_InfoDetalleMapeoPromo.EMPRESA_COD            := Pv_Empresa;
          Lr_InfoDetalleMapeoPromo.ESTADO                 := Lv_Status;
          Lr_GrupoPromoRegla                              := F_GET_PROMO_GRUPO_REGLA(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID);  
          Lr_TipoPromoRegla                               := F_GET_PROMO_TIPO_REGLA(La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID);  
          La_SectorizacionProcesar                        := F_GET_PROMO_SECTORIZACION(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID); 
          Lv_Trama                                        := F_GET_TRAMA(La_ClientesProcesar(Ln_Indx).PUNTO_ID, 
                                                                         Lr_GrupoPromoRegla,
                                                                         Lr_TipoPromoRegla,
                                                                         La_ServiciosProcesar,
                                                                         La_SectorizacionProcesar,
                                                                         null,
                                                                         Pv_Empresa);

          IF La_ServiciosMapeados.COUNT = La_ServiciosPerdidos.COUNT OR (
             La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION = 'PROM_MIX' AND La_ServiciosPerdidos.COUNT > 0)THEN

            P_MAPEO_PROMO_MENSUAL(Pa_ServiciosCumplePromo => La_ServiciosMapeados,
                                  Pr_TipoPromoRegla       => Lr_TipoPromoRegla,
                                  Prf_AdmiTipoPromoRegla  => Lr_InfoDetalleMapeoPromo,
                                  Pv_Trama                => Lv_Trama,
                                  Pv_MsjResultado         => Lv_msj);   
                                  
            IF Pv_TipoPromo = 'PROM_MENS' THEN
              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES(Pa_ServiciosPromo => La_ServiciosMapeados,
                                                                          Pv_CodEmpresa     => Pv_Empresa,
                                                                          Pv_TipoPromocion  => Pv_TipoPromo,
                                                                          Pv_EstadoOld      => 'Finalizada',
                                                                          Pv_estadoNew      => 'Eliminado',
                                                                          Pv_Observacion    => 'Se elimina la solicitud por perdida de promoción.',
                                                                          Pv_Mensaje        => Lv_msj2);
            END IF;
          ELSE

            P_MAPEO_PROMO_MENSUAL(Pa_ServiciosCumplePromo => La_ServiciosProcesar,
                                  Pr_TipoPromoRegla       => Lr_TipoPromoRegla,
                                  Prf_AdmiTipoPromoRegla  => Lr_InfoDetalleMapeoPromo,
                                  Pv_Trama                => Lv_Trama,
                                  Pv_MsjResultado         => Lv_msj); 

          END IF;

          IF TRIM(Lv_msj) IS NOT NULL THEN
          --
            RAISE Lex_Exception;
          --
          END IF;

          EXCEPTION
          WHEN Lex_Exception THEN
          --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_MAPEO_MENSUAL_POR_CICLO', 
                                                 Lv_msj,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          WHEN OTHERS THEN
          --
            Lv_msj := 'Ocurrió un error al mapear el registro para el  GRUPO_PROMOCION: '|| La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID
                       || ' TIPO_PROMOCION ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID || ' para el ID_PUNTO: ' || 
                       La_ClientesProcesar(Ln_Indx).PUNTO_ID; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_MAPEO_MENSUAL_POR_CICLO', 
                                                 Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          END;
        --
        Ln_Indx := La_ClientesProcesar.NEXT (Ln_Indx);
        END LOOP;
        COMMIT;
      --
      END LOOP;
    --
    CLOSE C_ClientesMapeo;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_msj := 'Ocurrió un error al ejecutar el proceso Mensual';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_MENSUAL_POR_CICLO', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_MAPEO_MENSUAL_POR_CICLO;
  --
  --
  --
  PROCEDURE P_MAPEO_PROMO_MENSUAL (Pr_Punto                IN Lr_PtosClientesProcesar DEFAULT NULL,
                                   Pa_ServiciosCumplePromo IN T_ServiciosProcesar,
                                   Pr_GruposPromociones    IN Lr_GruposPromocionesProcesar DEFAULT NULL,
                                   Pr_GrupoPromoRegla      IN Lr_GrupoPromoReglaProcesar DEFAULT NULL,
                                   Pr_TiposPromociones     IN Lr_TiposPromocionesProcesar DEFAULT NULL,
                                   Pr_TipoPromoRegla       IN Lr_TipoPromoReglaProcesar DEFAULT NULL,
                                   Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL,
                                   Pv_Trama                IN VARCHAR2 DEFAULT NULL,
                                   Prf_AdmiTipoPromoRegla  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE DEFAULT NULL,
                                   Pv_MsjResultado         OUT VARCHAR2) 
  IS

    --Costo: 2
    CURSOR C_ClienteMapeo (Cn_Id_Promocion      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                           Cn_Id_Persona_rol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                           Cn_Id_Punto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                           Cn_Id_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                           Cn_Id_Mapeo          DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE)
    IS
      SELECT IDMP.PERIODO,
        IDMP.MAPEOS_GENERADOS,
        IDMP.CANTIDAD_PERIODOS,
        IDMP.PORCENTAJE,
        IDMP.TIPO_PROCESO,
        IDMP.INVALIDA,
        (SELECT TRUNC(MAX(IDMP2.FE_MAPEO))
         FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP2
         WHERE IDMP2.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
           AND IDMP2.PERSONA_EMPRESA_ROL_ID = Cn_Id_Persona_rol
           AND IDMP2.PUNTO_ID               = Cn_Id_Punto
           AND IDMP2.TIPO_PROMOCION_ID      = Cn_Id_Tipo_Promocion
           AND IDMP2.PERIODO                IN ( SELECT MIN(IDMP3.PERIODO)
                                                 FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP3
                                                 WHERE IDMP3.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
                                                   AND IDMP3.PERSONA_EMPRESA_ROL_ID = Cn_Id_Persona_rol
                                                   AND IDMP3.PUNTO_ID               = Cn_Id_Punto
                                                   AND IDMP3.TIPO_PROMOCION_ID      = Cn_Id_Tipo_Promocion)) AS FE_CREACION,
        IDMP.FE_SIGUIENTE_MAPEO, IDMP.FE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
      WHERE IDMP.ID_DETALLE_MAPEO     = Cn_Id_Mapeo;

    CURSOR C_GetParamNumDiasFecAlcance (Cv_NombreParam    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_DescParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.DESCRIPCION%TYPE,    
                                        Cv_Estado         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                        Cv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS
    SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
    DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
    AND APD.ESTADO             = Cv_Estado
    AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
    AND APD.DESCRIPCION        = Cv_DescParametro
    AND APD.EMPRESA_COD        = Cv_CodEmpresa
    AND APC.ESTADO             = Cv_Estado;

    CURSOR C_CicloEspecial(Cv_DescripcionParemetro DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                           Cv_Parametro            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                           Cv_Valor1               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                           Cv_EstadoActivo         VARCHAR2,
                           Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT COUNT(DET.ID_PARAMETRO_DET) AS VALOR
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.DESCRIPCION      = Cv_DescripcionParemetro
      AND DET.VALOR1           = Cv_Valor1
      AND DET.ESTADO           = Cv_EstadoActivo
      AND DET.EMPRESA_COD      = Cv_CodEmpresa
      AND CAB.NOMBRE_PARAMETRO = Cv_Parametro
      AND CAB.ESTADO           = Cv_EstadoActivo;

    CURSOR C_GetEsCambioPrecio (Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                                
                                Cd_FeCreacion  DATE) IS
       SELECT 
       case  when  ish.servicio_id is not null then 'S' else null end as cambio_precio
         FROM INFO_SERVICIO_HISTORIAL ish
         inner join info_servicio iser on ish.servicio_id=iser.id_servicio
         inner join info_punto ipu on iser.punto_id = ipu.id_punto
         WHERE ish.accion    =  'confirmoCambioPrecio'
         AND ish.FE_CREACION >= Cd_FeCreacion
         AND ish.FE_CREACION <= Cd_FeCreacion + 1
         AND ipu.id_punto    =  Cn_IdPunto
         group by ish.servicio_id;
           
    CURSOR C_GetCantMapCicloEsp (Cn_Id_Promocion      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Cn_Id_Persona_rol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                 Cn_Id_Punto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Cn_Id_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                 Cd_FeCreacion        DATE)
    IS
       SELECT COUNT(*) AS CANT_MAPEO_CICLO_ESP
       FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
       WHERE IDMP.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
       AND IDMP.PERSONA_EMPRESA_ROL_ID   = Cn_Id_Persona_rol
       AND IDMP.PUNTO_ID                 = Cn_Id_Punto
       AND IDMP.TIPO_PROMOCION_ID        = Cn_Id_Tipo_Promocion
       AND IDMP.ESTADO                   !='Baja'
       AND IDMP.PERIODO                  IN (  SELECT MIN(IDMP2.PERIODO)
                                               FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP2
                                               WHERE IDMP2.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
                                               AND IDMP2.PERSONA_EMPRESA_ROL_ID   = Cn_Id_Persona_rol
                                               AND IDMP2.PUNTO_ID                 = Cn_Id_Punto
                                               AND IDMP2.TIPO_PROMOCION_ID        = Cn_Id_Tipo_Promocion
                                               AND IDMP2.ESTADO                   !='Baja')
       AND TO_NUMBER(TO_CHAR(IDMP.FE_MAPEO,'DD')) BETWEEN TO_NUMBER(TO_CHAR(TRUNC(SYSDATE,'MM'),'DD'))
       AND TO_NUMBER(TO_CHAR(Cd_FeCreacion,'DD'));

    --Costo: 8
    CURSOR C_GetEmpresa(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT IER.EMPRESA_COD
      FROM DB_COMERCIAL.INFO_PUNTO PTO,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE PTO.ID_PUNTO      = Cn_IdPunto
      AND IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
      AND IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID;

    Lv_NombreParametro        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE';
    Lv_DescParametro          DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='NUMERO_DIAS_FECHA_PROCESA_ALCANCE';
    Ln_NumeroDias             NUMBER := 0;
    Lv_Estado DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE:='Activo';
    Lv_Nombre                 DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE := Pr_TipoPromoRegla.NOMBRE_GRUPO;
    Ld_FechaActivacion        DATE            := ADD_MONTHS(SYSDATE,-1);
    Ld_FechaPrimeraAct        DATE            := SYSDATE;
    Ld_FechaMapeoCiclo2       DATE;
    Ld_Fecha_Map              DATE;
    Lv_msj                    VARCHAR2(3200);
    Lv_FechaMapeoTotal        VARCHAR2(5000);
    Lv_DescuentoPeriodo       VARCHAR2(200)   := Pr_TipoPromoRegla.PROM_PERIODO;
    Lv_InvalidaPromo          VARCHAR2(1)     := Pr_TipoPromoRegla.PROM_INVALIDA_PROMO;
    Lv_IpCreacion             VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lc_Trama                  CLOB            := Pv_Trama;
    Lb_AplicaMapeo            BOOLEAN;
    Ln_Contador               NUMBER          := 0;
    Ln_Periodo                NUMBER;
    Ln_Periodo_Map            NUMBER;
    Ln_Periodo_Sig            NUMBER;
    Ln_Descuento              NUMBER;
    Ln_Descuento_Map          NUMBER;
    Ln_Indx                   NUMBER;
    Ln_IndxServMap            NUMBER;
    Lex_Exception             EXCEPTION;
    Lv_CodigoCiclo            DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE;
    Ld_FechaInicio            DB_FINANCIERO.ADMI_CICLO.FE_INICIO%TYPE;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    Lr_InfoServicioHistorial  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lc_Cliente_Mapeo          C_ClienteMapeo%ROWTYPE;
    La_ServiciosProcesar      T_ServiciosMapear;
    Lv_TipoCliente            VARCHAR2(32000)   := Pv_TipoProceso;
    Lv_DescripcionParametro   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_CICLOS_FACTURACION';
    Lv_Parametro              DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_PARAMETROS';
    Ln_CicloEspecial          NUMBER;
    Lv_EsCambioPrecio         VARCHAR2(20);
    Ln_CantMapCicloEsp        NUMBER:=0;
    Lv_CodEmpresa             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    --
  BEGIN       

    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;

    IF C_CicloEspecial%ISOPEN THEN
      CLOSE C_CicloEspecial;
    END IF;
    
    IF C_GetEsCambioPrecio%ISOPEN THEN
      CLOSE C_GetEsCambioPrecio;
    END IF;
    
    IF C_GetCantMapCicloEsp%ISOPEN THEN
      CLOSE C_GetCantMapCicloEsp;
    END IF;

    OPEN C_GetEmpresa(Pr_Punto.ID_PUNTO);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;

    IF Pv_TipoProceso ='UPGRADE' OR Pv_TipoProceso ='DOWNGRADE' OR Pv_TipoProceso ='UPGRADE_CAMBIO_PRECIO' THEN
    
      Lv_TipoCliente:='EXISTENTE';
    
    END IF;
  
    IF Lv_TipoCliente ='EXISTENTE' THEN
      OPEN  C_GetParamNumDiasFecAlcance(Cv_NombreParam    => Lv_NombreParametro,
                                        Cv_DescParametro  => Lv_DescParametro,
                                        Cv_Estado         => Lv_Estado,
                                        Cv_CodEmpresa     => Lv_CodEmpresa);
      FETCH C_GetParamNumDiasFecAlcance INTO Ln_NumeroDias;
      CLOSE C_GetParamNumDiasFecAlcance;
      --
      IF (Ln_NumeroDias IS NULL OR Ln_NumeroDias = 0) THEN
        Lv_Msj := 'No se puedo obtener el numero de dias parametrizados en PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE 
                para la ejecución del proceso de Mapeo Promocional Tipo Proceso: '||Lv_TipoCliente;
        RAISE Lex_Exception;
      END IF;  
    END IF;
    --
    --
    IF C_ClienteMapeo%ISOPEN THEN
    --
      CLOSE C_ClienteMapeo;
    --
    END IF;

    Lr_InfoDetalleMapeoPromo              := NULL;
    Lr_InfoDetalleMapeoPromo.TRAMA        := Lc_Trama;
    Lr_InfoDetalleMapeoPromo.FE_CREACION  := SYSDATE-Ln_NumeroDias;
    Lr_InfoDetalleMapeoPromo.USR_CREACION := 'telcos_map_prom';
    Lr_InfoDetalleMapeoPromo.IP_CREACION  := Lv_IpCreacion;
    Lr_InfoDetalleMapeoPromo.FE_ULT_MOD   := NULL;
    Lr_InfoDetalleMapeoPromo.USR_ULT_MOD  := NULL;
    Lr_InfoDetalleMapeoPromo.IP_ULT_MOD   := NULL;

    IF Pv_TipoProceso IS NOT NULL THEN
    --
      --Seteamos variables para detalle del Ciclo
      P_GET_CICLO(Pr_Punto.ID_PERSONA_ROL,
                  Lv_CodigoCiclo,
                  Ld_FechaInicio);

      IF Lv_CodigoCiclo IS NULL  AND Ld_FechaInicio IS NULL THEN
        Lv_Msj := 'No se encuentra definido Código y Fecha de Inicio de Ciclo';
        RAISE Lex_Exception;
      END IF;

      OPEN C_CicloEspecial(Lv_DescripcionParametro,Lv_Parametro,Lv_CodigoCiclo,Lv_Estado,Lv_CodEmpresa);
      FETCH C_CicloEspecial INTO Ln_CicloEspecial;
      CLOSE C_CicloEspecial;

      P_VALIDA_JERARQUIA_PROMOCION(Pr_GruposPromociones.ID_GRUPO_PROMOCION,
                                   Pr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                   Pa_ServiciosCumplePromo,
                                   La_ServiciosProcesar,
                                   Lb_AplicaMapeo);
    --
    END IF;

    IF Pv_TipoProceso IS NOT NULL  AND Lb_AplicaMapeo THEN
    --
      Ld_FechaPrimeraAct                              := Ld_FechaPrimeraAct-Ln_NumeroDias;
      Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
      Lr_InfoDetalleMapeoPromo.TIPO_PROCESO           := Lv_TipoCliente;
      Lr_InfoDetalleMapeoPromo.INDEFINIDO             := 'X';
      Lr_InfoDetalleMapeoPromo.PERIODO                := 1;
      Lr_InfoDetalleMapeoPromo.PORCENTAJE             := Pr_TipoPromoRegla.PROM_DESCUENTO;
      Lr_InfoDetalleMapeoPromo.FE_MAPEO               := Ld_FechaPrimeraAct;
      Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO     := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||TO_CHAR(Ld_FechaPrimeraAct,'MM')||
                                                         '-'||TO_CHAR(Ld_FechaPrimeraAct,'YYYY'),'DD-MM-YYYY'),1);
      Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID     := Pr_GruposPromociones.ID_GRUPO_PROMOCION;
      Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID      := Pr_TiposPromociones.ID_TIPO_PROMOCION;
      Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID := Pr_Punto.ID_PERSONA_ROL;
      Lr_InfoDetalleMapeoPromo.PUNTO_ID               := Pr_Punto.ID_PUNTO;
      Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION         := Pr_TiposPromociones.CODIGO_TIPO_PROMOCION;
      Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS      := 1;
      Lr_InfoDetalleMapeoPromo.INVALIDA               := Lv_InvalidaPromo;
      Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS       := 1;
      Lr_InfoDetalleMapeoPromo.EMPRESA_COD            := Pr_Punto.COD_EMPRESA;
      Lr_InfoDetalleMapeoPromo.ESTADO                 := 'Activo';

      P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo,
                       La_ServiciosProcesar,
                       Lv_msj);

      IF TRIM(Lv_msj) IS NOT NULL THEN
      --
        RAISE Lex_Exception;
      --
      END IF;

      Lv_FechaMapeoTotal := TO_CHAR(Ld_FechaPrimeraAct);

      IF (Ln_CicloEspecial > 0 AND TO_NUMBER(TO_CHAR(Ld_FechaPrimeraAct,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicio,'DD')) 
          AND Pv_TipoProceso = 'NUEVO') OR Pv_TipoProceso = 'UPGRADE_CAMBIO_PRECIO' THEN
      --
        Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
        Ld_FechaMapeoCiclo2                         := TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||TO_CHAR(Ld_FechaPrimeraAct,'MM')||'-'||
                                                       TO_CHAR(Ld_FechaPrimeraAct,'YYYY'),'DD-MM-YYYY');
        Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeoCiclo2;
        Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||TO_CHAR(Ld_FechaMapeoCiclo2,'MM')||
                                                       '-'||TO_CHAR(Ld_FechaMapeoCiclo2,'YYYY'),'DD-MM-YYYY'),1);

        Lv_FechaMapeoTotal := '|'||TO_CHAR(Ld_FechaMapeoCiclo2);

        P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo,
                         La_ServiciosProcesar,
                         Lv_msj);

        IF TRIM(Lv_msj) IS NOT NULL THEN
        --
          RAISE Lex_Exception;
        --
        END IF;
      --
      END IF;

      Ln_IndxServMap := La_ServiciosProcesar.FIRST;
      WHILE (Ln_IndxServMap IS NOT NULL)  
      LOOP
        Lr_InfoServicioHistorial                        := NULL;
        Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
        Lr_InfoServicioHistorial.SERVICIO_ID            := La_ServiciosProcesar(Ln_IndxServMap).ID_SERVICIO;
        Lr_InfoServicioHistorial.USR_CREACION           := 'telcos_map_prom';
        Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE-Ln_NumeroDias;
        Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
        Lr_InfoServicioHistorial.ESTADO                 := La_ServiciosProcesar(Ln_IndxServMap).ESTADO;
        Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
        Lr_InfoServicioHistorial.OBSERVACION            := 'Se registró correctamente el mapeo de la Promoción: '
                                                           ||Lv_Nombre|| ', para el tipo promocional: '
                                                           ||Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION
                                                           ||', Fecha-Mapeo: '||Lv_FechaMapeoTotal;
        Lr_InfoServicioHistorial.ACCION                 := NULL;
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_msj);
        --
        IF TRIM(Lv_msj) IS NOT NULL THEN
          Lv_msj:= 'Ocurrió un error al insertar el historial del servicio: '
                    || La_ServiciosProcesar(Ln_IndxServMap).ID_SERVICIO || ' por mapeo de promoción.'
                    || ' - ' || Lv_msj;
          RAISE Lex_Exception;
        END IF;
        --
        Ln_IndxServMap := La_ServiciosProcesar.NEXT (Ln_IndxServMap);

      END LOOP;
    --  
    ELSE
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           'Se inicia proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID, 
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
      --Seteamos variables para detalle del Ciclo
      P_GET_CICLO(Prf_AdmiTipoPromoRegla.PERSONA_EMPRESA_ROL_ID,
                  Lv_CodigoCiclo,
                  Ld_FechaInicio);
      IF Lv_CodigoCiclo IS NULL  AND Ld_FechaInicio IS NULL THEN
        Lv_Msj := 'No se encuentra definido Código y Fecha de Inicio de Ciclo';
        RAISE Lex_Exception;
      END IF;

      OPEN C_CicloEspecial(Lv_DescripcionParametro,Lv_Parametro,Lv_CodigoCiclo,Lv_Estado,Lv_CodEmpresa);
      FETCH C_CicloEspecial INTO Ln_CicloEspecial;
      CLOSE C_CicloEspecial;
 
      OPEN C_ClienteMapeo(Prf_AdmiTipoPromoRegla.GRUPO_PROMOCION_ID,
                          Prf_AdmiTipoPromoRegla.PERSONA_EMPRESA_ROL_ID,
                          Prf_AdmiTipoPromoRegla.PUNTO_ID,
                          Prf_AdmiTipoPromoRegla.TIPO_PROMOCION_ID,
                          Prf_AdmiTipoPromoRegla.ID_DETALLE_MAPEO);
      --
      FETCH C_ClienteMapeo INTO Lc_Cliente_Mapeo;
      --
      CLOSE C_ClienteMapeo;

      OPEN  C_GetEsCambioPrecio(Prf_AdmiTipoPromoRegla.PUNTO_ID,Lc_Cliente_Mapeo.FE_CREACION);
      FETCH C_GetEsCambioPrecio INTO Lv_EsCambioPrecio;
      CLOSE C_GetEsCambioPrecio;
      --
      Ln_CantMapCicloEsp:=0;
      OPEN C_GetCantMapCicloEsp(Prf_AdmiTipoPromoRegla.GRUPO_PROMOCION_ID,
                                Prf_AdmiTipoPromoRegla.PERSONA_EMPRESA_ROL_ID,
                                Prf_AdmiTipoPromoRegla.PUNTO_ID,
                                Prf_AdmiTipoPromoRegla.TIPO_PROMOCION_ID,
                                Lc_Cliente_Mapeo.FE_CREACION);
      --
      FETCH C_GetCantMapCicloEsp INTO Ln_CantMapCicloEsp;
      --
      CLOSE C_GetCantMapCicloEsp;
      --

      Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID     := Prf_AdmiTipoPromoRegla.GRUPO_PROMOCION_ID;
      Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID      := Prf_AdmiTipoPromoRegla.TIPO_PROMOCION_ID;
      Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID := Prf_AdmiTipoPromoRegla.PERSONA_EMPRESA_ROL_ID;
      Lr_InfoDetalleMapeoPromo.PUNTO_ID               := Prf_AdmiTipoPromoRegla.PUNTO_ID;
      Lr_InfoDetalleMapeoPromo.TIPO_PROCESO           := Lc_Cliente_Mapeo.TIPO_PROCESO;
      Lr_InfoDetalleMapeoPromo.INVALIDA               := Lc_Cliente_Mapeo.INVALIDA;
      Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION         := Prf_AdmiTipoPromoRegla.TIPO_PROMOCION;
      Lr_InfoDetalleMapeoPromo.EMPRESA_COD            := Prf_AdmiTipoPromoRegla.EMPRESA_COD;
      Lr_InfoDetalleMapeoPromo.ESTADO                 := Prf_AdmiTipoPromoRegla.ESTADO;

      IF Prf_AdmiTipoPromoRegla.INDEFINIDO = 'S' THEN
      --
        Lr_InfoDetalleMapeoPromo.FE_MAPEO           := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||
                                                       TO_CHAR(TRUNC(Ld_FechaActivacion),'MM')||'-'||
                                                       TO_CHAR(TRUNC(Ld_FechaActivacion),'YYYY'),'DD-MM-YYYY'), 1);
        Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||
                                                       TO_CHAR(TRUNC(Ld_FechaActivacion),'MM')||'-'||
                                                       TO_CHAR(TRUNC(Ld_FechaActivacion),'YYYY'),'DD-MM-YYYY'), 2);
        Lr_InfoDetalleMapeoPromo.INDEFINIDO         := 'X';
        Lr_InfoDetalleMapeoPromo.PERIODO            := Lc_Cliente_Mapeo.PERIODO + 1;
        Lr_InfoDetalleMapeoPromo.PORCENTAJE         := Lc_Cliente_Mapeo.PORCENTAJE;
        Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS  := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_Cliente_Mapeo.CANTIDAD_PERIODOS,'^\d+')),0) + 1;
        Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS   := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_Cliente_Mapeo.MAPEOS_GENERADOS,'^\d+')),0) + 1;

      ELSE
      --
        Lr_InfoDetalleMapeoPromo.INDEFINIDO := NULL;
        FOR DescuentoPeriodo IN (SELECT REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) SPLIT 
                                 FROM DUAL
                                CONNECT BY REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) IS NOT NULL)
        LOOP
        --
          Ln_Periodo   := TO_NUMBER(regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 1));
          Ln_Descuento := TO_NUMBER(regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 2));

          IF Ln_Periodo = Lc_Cliente_Mapeo.PERIODO THEN
            Ln_Contador := Ln_Contador + 1;
            CONTINUE;
          END IF;

          IF Ln_Contador = 1 THEN
            Ln_Descuento_Map := Ln_Descuento;
            Ln_Periodo_Map   := Ln_Periodo;
            Ld_Fecha_Map     := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'MM')||'-'||
                                TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'YYYY'),'DD-MM-YYYY'), Ln_Periodo_Map-1);
            
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           ' Proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID ||
                                           ' Ln_Contador: ' || Ln_Contador ||
                                           ' Ld_Fecha_Map: '|| Ld_Fecha_Map ||
                                           ' Ln_Periodo_Map: '|| Ln_Periodo_Map ||
                                           ' Lc_Cliente_Mapeo.FE_CREACION: '|| Lc_Cliente_Mapeo.FE_CREACION, 
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));     
          END IF;

          IF Ln_Contador = 1 AND TRUNC(Ld_FechaActivacion) < Ld_Fecha_Map  THEN
            Ln_Contador := Ln_Contador + 1;
            CONTINUE;
          END IF;

          IF Ln_Contador = 2 AND Ln_Periodo_Sig IS NULL THEN
            Ln_Periodo_Sig := Ln_Periodo;
          END IF;
        --      
        END LOOP;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           ' Proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID || 
                                           ' Ld_Fecha_Map: '|| Ld_Fecha_Map ||
                                           ' Ln_Periodo_Sig: ' || Ln_Periodo_Sig ||
                                           ' Ln_CantMapCicloEsp: '|| Ln_CantMapCicloEsp,
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));   

        IF Ld_Fecha_Map IS NOT NULL AND TRUNC(Ld_FechaActivacion) > Ld_Fecha_Map THEN
          Ln_Periodo_Map := Ln_Periodo_Map + 1;
          Ld_Fecha_Map   := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||TO_CHAR(Ld_FechaActivacion,'MM')||'-'||
                            TO_CHAR(Ld_FechaActivacion,'YYYY'),'DD-MM-YYYY'), 1);

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           ' Mayor Proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID || 
                                           ' Ld_FechaActivacion: ' || Ld_FechaActivacion|| ' Ld_Fecha_Map: '||Ld_Fecha_Map||
                                           ' Ln_Periodo_Map: '||Ln_Periodo_Map, 
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));        
        ELSE
          Ld_Fecha_Map     := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||TO_CHAR(Ld_FechaActivacion,'MM')||'-'||
                              TO_CHAR(Ld_FechaActivacion,'YYYY'),'DD-MM-YYYY'), 1);
          Ln_Periodo_Map   := Lc_Cliente_Mapeo.PERIODO + 1;
          Ln_Descuento_Map := Lc_Cliente_Mapeo.PORCENTAJE;
          
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           ' Menor Proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID || 
                                           ' Ld_FechaActivacion: ' || Ld_FechaActivacion|| ' Ld_Fecha_Map: '||Ld_Fecha_Map||
                                           ' Ln_Periodo_Map: '||Ln_Periodo_Map, 
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
        END IF;
        Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS  := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_Cliente_Mapeo.MAPEOS_GENERADOS,'^\d+')),0) + 1;
        Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_Cliente_Mapeo.CANTIDAD_PERIODOS,'^\d+')),0);
        Lr_InfoDetalleMapeoPromo.PERIODO           := Ln_Periodo_Map;
        Lr_InfoDetalleMapeoPromo.PORCENTAJE        := Ln_Descuento_Map;
        Lr_InfoDetalleMapeoPromo.FE_MAPEO          := Ld_Fecha_Map;
        IF Ln_Periodo_Sig IS NULL THEN
          Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO := Ld_Fecha_Map;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           ' Proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID || 
                                           ' FE_SIGUIENTE_MAPEO: ' || Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO  , 
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));     
        ELSE
          IF (Ln_CicloEspecial > 0 AND Ln_CantMapCicloEsp>0
              AND TO_NUMBER(TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'DD')) < TO_NUMBER(TO_CHAR(Ld_FechaInicio,'DD'))) THEN
             Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||
                                                         TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'MM')||'-'||
                                                         TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'YYYY'),'DD-MM-YYYY'), Ln_Periodo_Sig-2);  
          ELSE
             Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO := ADD_MONTHS(TO_DATE(TO_CHAR(Ld_FechaInicio,'DD')||'-'||
                                                         TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'MM')||'-'||
                                                         TO_CHAR(Lc_Cliente_Mapeo.FE_CREACION,'YYYY'),'DD-MM-YYYY'), Ln_Periodo_Sig-1);  
          END IF;                
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                           ' Proceso: P_MAPEO_PROMO_MENSUAL, ID_PUNTO: '||Prf_AdmiTipoPromoRegla.PUNTO_ID || 
                                           ' FE_SIGUIENTE_MAPEO: ' || Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO ||
                                           ' Ld_FechaInicio ciclo: ' || Ld_FechaInicio || 
                                           ' Lc_Cliente_Mapeo.FE_CREACION: ' || Lc_Cliente_Mapeo.FE_CREACION  ||
                                           ' Ln_Periodo_Sig: ' ||  Ln_Periodo_Sig ||
                                           ' Lv_EsCambioPrecio: ' || Lv_EsCambioPrecio ||
                                           ' Ln_CantMapCicloEsp: '|| Ln_CantMapCicloEsp ||
                                           ' Lc_Cliente_Mapeo.PERIODO: '|| Lc_Cliente_Mapeo.PERIODO, 
                                           'telcos_mapeo_log',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));        
        END IF;
      --
      END IF;
      --
        Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
        IF Pa_ServiciosCumplePromo.COUNT > 0 THEN
          Ln_Indx := Pa_ServiciosCumplePromo.FIRST;
          WHILE (Ln_Indx IS NOT NULL)
          LOOP
          --
            La_ServiciosProcesar(Ln_Indx) := Pa_ServiciosCumplePromo(Ln_Indx);
            Ln_Indx                       := Pa_ServiciosCumplePromo.NEXT (Ln_Indx);
          --
          END LOOP;
        END IF;
        P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo,
                         La_ServiciosProcesar,
                         Lv_msj);

        IF TRIM(Lv_msj) IS NOT NULL THEN
        --
          RAISE Lex_Exception;
        --
        END IF;
        IF Prf_AdmiTipoPromoRegla.ESTADO = 'Activo' THEN
          Ln_IndxServMap := La_ServiciosProcesar.FIRST;
          WHILE (Ln_IndxServMap IS NOT NULL)  
          LOOP
            Lr_InfoServicioHistorial                        := NULL;
            Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
            Lr_InfoServicioHistorial.SERVICIO_ID            := La_ServiciosProcesar(Ln_IndxServMap).ID_SERVICIO;
            Lr_InfoServicioHistorial.USR_CREACION           := 'telcos_map_prom';
            Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
            Lr_InfoServicioHistorial.ESTADO                 := La_ServiciosProcesar(Ln_IndxServMap).ESTADO;
            Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
            Lr_InfoServicioHistorial.OBSERVACION            := 'Se registró correctamente el mapeo de la Promoción: '
                                                                ||Lv_Nombre|| ', para el tipo promocional: '
                                                                ||Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION
                                                                ||', Fecha-Mapeo: '||Lr_InfoDetalleMapeoPromo.FE_MAPEO;
            Lr_InfoServicioHistorial.ACCION                 := NULL;
            --
            DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_msj);
            --
            IF TRIM(Lv_msj) IS NOT NULL THEN
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio: '
                        || La_ServiciosProcesar(Ln_IndxServMap).ID_SERVICIO || ' por mapeo de promoción.'
                        || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            END IF;
            --
            Ln_IndxServMap := La_ServiciosProcesar.NEXT (Ln_IndxServMap);
          END LOOP;
        END IF;
    END IF;                                  

  EXCEPTION
  WHEN Lex_Exception THEN
  --
    Pv_MsjResultado := Lv_msj; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                         Lv_msj,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
  WHEN OTHERS THEN
  --
    Lv_msj          := 'Ocurrió un error al mapear el registro: '|| Pv_Trama || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM; 
    Pv_MsjResultado := Lv_msj;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_PROMO_MENSUAL', 
                                         Lv_msj,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
  END P_MAPEO_PROMO_MENSUAL;
  --
  --
  --
  PROCEDURE P_INSERTA_HIST_SERVICIO (Pa_ServiciosPromo IN T_ServiciosProcesar,
                                     Pv_Observacion    IN VARCHAR2,
                                     Pv_MsjResultado   OUT VARCHAR2) 
  IS 
    Lr_InfoServicioHistorial  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_IpCreacion             VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado           VARCHAR2(2000);
    Ln_Indice                 NUMBER;
    Lex_Exception             EXCEPTION;
    --
  BEGIN
  --
    IF Pa_ServiciosPromo.COUNT > 0 THEN
      Ln_Indice := Pa_ServiciosPromo.FIRST;
      WHILE (Ln_Indice IS NOT NULL)
      LOOP
      --
        Lr_InfoServicioHistorial                       := NULL;
        Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
        Lr_InfoServicioHistorial.SERVICIO_ID           := Pa_ServiciosPromo(Ln_Indice).ID_SERVICIO;
        Lr_InfoServicioHistorial.USR_CREACION          := 'telcos_map_prom';
        Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
        Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
        Lr_InfoServicioHistorial.ESTADO                := Pa_ServiciosPromo(Ln_Indice).ESTADO;
        Lr_InfoServicioHistorial.MOTIVO_ID             := NULL;
        Lr_InfoServicioHistorial.OBSERVACION           := Pv_Observacion;
        Lr_InfoServicioHistorial.ACCION                := NULL;
        --
        P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,
                                     Lv_MsjResultado);

        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        --
          RAISE Lex_Exception;
        --
        END IF;
        Ln_Indice := Pa_ServiciosPromo.NEXT (Ln_Indice);  
      --   
      END LOOP;
    ELSE
    --
      Lv_MsjResultado := 'Ocurrió un error el proceso no encontró servicios a procesar.';
      RAISE Lex_Exception;
    --
    END IF;

  EXCEPTION
  WHEN Lex_Exception THEN
  --
    Pv_MsjResultado := Lv_MsjResultado; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_INSERTA_HIST_SERVICIO', 
                                         Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

  WHEN OTHERS THEN
  --
    Pv_MsjResultado := SQLCODE || ' -ERROR- ' || SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_INSERTA_HIST_SERVICIO', 
                                         SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
  END P_INSERTA_HIST_SERVICIO;
  --
  --
  --
  PROCEDURE P_OBTIENE_GRUPOS_PROC_PIERDE(Pv_Empresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoPromo IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_TipoProceso          IN VARCHAR2)
  IS
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='MAPEO DE PROMOCIONES MENSUAL';
    Lv_Estado DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                   :='Activo';   
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    CURSOR C_GruposEjecucion(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                             Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                             Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
    SELECT DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1) AS GRUPO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR5), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR5),'([^,]*)(,\1)+($|,)', '\1\3') AS CICLO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR1), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR1),'([^,]*)(,\1)+($|,)', '\1\3') AS FORMA_PAGO,
      LISTAGG (TRIM(PAMD.VALOR2), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR2) AS IDS_FORMASPAGO_EMISORES
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAMC,
      DB_GENERAL.ADMI_PARAMETRO_DET PAMD,
      DB_FINANCIERO.ADMI_CICLO CICLO
    WHERE NOMBRE_PARAMETRO                                         = Cv_NombreParametro
    AND PAMC.ESTADO                                                = Cv_Estado
    AND PAMD.ESTADO                                                = Cv_Estado
    AND PAMD.EMPRESA_COD                                           = Cv_CodEmpresa
    AND PAMC.ID_PARAMETRO                                          = PAMD.PARAMETRO_ID
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PAMD.VALOR5,'^\d+')),0)   = CICLO.ID_CICLO
    GROUP BY DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1);

  BEGIN
    FOR Lr_GruposEjecucion IN C_GruposEjecucion(Lv_NombreParametro, Lv_Estado, Pv_Empresa)
        LOOP        
          P_PIERDE_PROMO_MAPEO(Pv_Empresa               => Pv_Empresa,
                               Pv_TipoPromo             => Pv_TipoPromo,
                               Pv_FormaPago             => Lr_GruposEjecucion.FORMA_PAGO,
                               Pn_IdCiclo               => COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_GruposEjecucion.CICLO,'^\d+')),0),
                               Pv_IdsFormasPagoEmisores => Lr_GruposEjecucion.IDS_FORMASPAGO_EMISORES,
                               Pv_TipoProceso           => Pv_TipoProceso
                              );                                                            
    END LOOP;

  EXCEPTION 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Perdida de Promociones
                      para el Grupo de Promocional: '|| Pv_TipoPromo;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_OBTIENE_GRUPOS_PROC_PIERDE;
  --
  --
  --
  PROCEDURE P_PIERDE_PROMO_MAPEO (Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_TipoPromo             IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                  Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                  Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                  Pv_TipoProceso           IN VARCHAR2 DEFAULT NULL,
                                  Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL) 
  IS

    --Cosot: 16
    CURSOR C_ServicioActivo (Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Cv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS 
      SELECT COUNT(*) AS VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP 
      WHERE AP.CODIGO_PRODUCTO = 'INTD'
        AND AP.ID_PRODUCTO     = IPD.PRODUCTO_ID
        AND IPD.PLAN_ID        = ISER.PLAN_ID
        AND UPPER(ISER.ESTADO) IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                      AND APD.ESTADO           = 'Activo'
                                      AND APD.EMPRESA_COD      = Cv_EmpresaCod
                                      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                      AND APC.ESTADO           = 'Activo')
        AND ISER.PUNTO_ID   = Cn_IdPunto;
    
    --Costo: 1        
    CURSOR C_TipoPromocion (Cn_Id_Tipo_Promocion NUMBER)
    IS
      SELECT UPPER(TRIM(ATP.ESTADO)) AS ESTADO
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP 
      WHERE ATP.ID_TIPO_PROMOCION = Cn_Id_Tipo_Promocion;

    --Costo: 2        
    CURSOR C_Id_Detalle_Mapeo (Cn_Id_Promocion      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Cn_Id_Persona_rol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                               Cn_Id_Punto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Cn_Id_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                               Cn_Id_Mapeo          DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
                               Cn_Id_Servicio       DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IDMP.ID_DETALLE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
      WHERE IDMP.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
        AND IDMP.PERSONA_EMPRESA_ROL_ID = Cn_Id_Persona_rol
        AND IDMP.PUNTO_ID               = Cn_Id_Punto
        AND IDMP.TIPO_PROMOCION_ID      = Cn_Id_Tipo_Promocion
        AND IDMP.ID_DETALLE_MAPEO       > = Cn_Id_Mapeo
        AND IDMP.ID_DETALLE_MAPEO       = IDMS.DETALLE_MAPEO_ID 
        AND IDMS.SERVICIO_ID            = Cn_Id_Servicio
        ORDER BY IDMP.ID_DETALLE_MAPEO ASC;

    --Cosot: 16
    CURSOR C_ServicioAnulado (Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT COUNT(*) AS VALOR
      FROM  DB_COMERCIAL.INFO_SERVICIO ISERV
      WHERE UPPER(ISERV.ESTADO) IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                    AND APD.ESTADO           = 'Activo'
                                    AND APD.EMPRESA_COD      = Cv_EmpresaCod
                                    AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_BAJA_SERV'
                                    AND APC.ESTADO           = 'Activo')                          
       AND ISERV.ID_SERVICIO         = Cn_IdServicio;

    Lc_Tipo_Promocion         C_TipoPromocion%ROWTYPE;
    Lr_InfoDetalleMapeoHisto  DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lr_GrupoPromoRegla        Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla         Lr_TipoPromoReglaProcesar;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    Lr_InfoDetMapSolicitud    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE; 
    Ln_IntIdPromocion         DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Ln_IntIdTipoPromocion     DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    Ln_IntIdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_IdPersonaRol           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
    Ln_Id_Detalle_Mapeo       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE;
    La_SectorizacionProcesar  T_SectorizacionProcesar;
    La_ClientesProcesar       T_ClientesMapeo;
    La_ServiciosMapeados      T_ServiciosProcesar;
    La_ServiciosProcesar      T_ServiciosProcesar;
    La_ServiciosPerdidos      T_ServiciosProcesar;
    Lb_AplicaMapeo            BOOLEAN;
    Ln_ServicioActivo         NUMBER;
    Ln_ServicioAnulado        NUMBER;
    Lv_Status                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE;
    Lv_EstadoActivo           DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE := 'Activo'; 
    Ln_Indx                   NUMBER;
    Ln_Contador               NUMBER;
    Ln_ServiciosPerdidos      NUMBER;
    Ln_Id_Servicio            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_msj                    VARCHAR2(32000);
    Lv_Observacion            VARCHAR2(32000);
    Lv_Trama                  VARCHAR2(4000);
    Le_ActualizaMapeo         EXCEPTION;
    Le_ActualizaServicio      EXCEPTION;
    Le_Exception              EXCEPTION;
    Lr_ParametrosValidarSec   DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;  
    --
    Lv_CaractCicloFact        VARCHAR2(20)   :='CICLO_FACTURACION';
    Lv_Consulta               VARCHAR2(4000);
    Lv_CadenaQuery            VARCHAR2(4000);
    Lv_CadenaFrom             VARCHAR2(3000);
    Lv_CadenaWhere            VARCHAR2(3000);    
    Lv_CadenaOrdena           VARCHAR2(1000);
    Lv_TieneSolicitud         VARCHAR2(1);
    Lrf_ClientesMapeo         SYS_REFCURSOR;  
    Lb_CumpleEstadoServ       BOOLEAN;
    Ln_DiasRestar             NUMBER          :=1; 
  --
  BEGIN
  --
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                         'Ingreso P_PIERDE_PROMO_MAPEO ', 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
       IF Pv_TipoProceso = 'NUEVO' THEN
          Ln_DiasRestar:= 0;
       END IF;

    Lv_CadenaQuery:= 'SELECT DISTINCT IDMP.ID_DETALLE_MAPEO,
        AGP.NOMBRE_GRUPO,
        IDMP.GRUPO_PROMOCION_ID,
        IDMP.TIPO_PROMOCION_ID,
        IDMP.PERSONA_EMPRESA_ROL_ID,
        IDMP.PUNTO_ID,
        IDMP.TIPO_PROMOCION,
        IDMP.INDEFINIDO,
        IDMP.FE_MAPEO,
        (SELECT MAX(IDMS.SERVICIO_ID) AS SERVICIO_ID 
         FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS 
         WHERE IDMS.DETALLE_MAPEO_ID = IDMP.ID_DETALLE_MAPEO) AS SERVICIO_ID ';
         
    Lv_CadenaFrom:= ' FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
      DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS 
    , DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP';

    Lv_CadenaWhere:=' WHERE  IDMP.EMPRESA_COD                 = '''||Pv_Empresa||'''
        AND IDMP.ESTADO                      = '''||Lv_EstadoActivo||'''
        AND IDMS.DETALLE_MAPEO_ID            = IDMP.ID_DETALLE_MAPEO
        AND IDMP.GRUPO_PROMOCION_ID          = AGP.ID_GRUPO_PROMOCION
        AND IDMS.ESTADO                      = '''||Lv_EstadoActivo||'''
        AND IDMP.TIPO_PROMOCION              IN (SELECT DET.VALOR2 
                                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                   DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                 WHERE CAB.NOMBRE_PARAMETRO = ''PROM_TIPO_PROMOCIONES''
                                                 AND CAB.ESTADO             = '''||Lv_EstadoActivo||'''
                                                 AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                 AND DET.VALOR3             = '''||Pv_TipoPromo||'''
                                                 AND DET.EMPRESA_COD        = '''||Pv_Empresa||'''
                                                 AND DET.ESTADO             = '''||Lv_EstadoActivo||''') '; 
      IF Pv_TipoProceso IS NOT NULL THEN   
      
        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND TO_CHAR(IDMP.FE_MAPEO,''MM/YYYY'') = TO_CHAR(SYSDATE-NVL('''||Ln_DiasRestar||''',0),''MM/YYYY'') ';
        
      END IF;
                                                 
    Lv_CadenaOrdena:= ' ORDER BY IDMP.ID_DETALLE_MAPEO ASC ';
    
    IF Pn_IdPunto IS NOT NULL THEN
      
       Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.PUNTO_ID ='''||Pn_IdPunto||''' ';
          
    END IF;

    
    IF Pv_TipoPromo = 'PROM_MENS'  AND Pv_FormaPago IS NOT NULL AND Pn_IdCiclo IS NOT NULL AND Pv_IdsFormasPagoEmisores IS NOT NULL THEN

      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO ';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ,DB_FINANCIERO.ADMI_CICLO ADMCICLO';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO CONT, DB_GENERAL.ADMI_FORMA_PAGO FP ';      

      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
      AND IPER.ID_PERSONA_ROL              = CICLO.PERSONA_EMPRESA_ROL_ID
      AND CICLO.CARACTERISTICA_ID          = CARAC.ID_CARACTERISTICA
      AND CARAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractCicloFact||'''
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,''^\d+'')),0) = ADMCICLO.ID_CICLO
      AND ADMCICLO.ID_CICLO                = COALESCE(TO_NUMBER(REGEXP_SUBSTR('||Pn_IdCiclo||',''^\d+'')),0)
      AND IPER.ID_PERSONA_ROL              = CONT.PERSONA_EMPRESA_ROL_ID
      AND CONT.ESTADO                      IN (''Activo'',''Cancelado'')
      AND CONT.FORMA_PAGO_ID               = FP.ID_FORMA_PAGO ';

      IF Pv_FormaPago = 'DEBITO BANCARIO' THEN
        Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONFP';

        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.DESCRIPCION_FORMA_PAGO = '''||Pv_FormaPago||''' 
        AND CONT.ID_CONTRATO            = CONFP.CONTRATO_ID
        AND CONFP.BANCO_TIPO_CUENTA_ID  IN ('|| Pv_IdsFormasPagoEmisores ||') 
        AND CONFP.ESTADO                IN (''Activo'',''Cancelado'') ';

      ELSIF Pv_FormaPago = 'EFECTIVO' THEN
        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.ID_FORMA_PAGO IN ('|| Pv_IdsFormasPagoEmisores ||') ';
      END IF;
      ---- verificar tipo proceso y agregar al query 
       IF Pv_TipoProceso = 'NUEVO' THEN
          Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.TIPO_PROCESO=''NUEVO''';
       ELSIF Pv_TipoProceso = 'EXISTENTE' THEN
          Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.TIPO_PROCESO=''EXISTENTE''';
       END IF;
    END IF;
    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdena;    

    IF Lrf_ClientesMapeo%ISOPEN THEN
    --
      CLOSE Lrf_ClientesMapeo;
    --  
    END IF;
    --
    IF C_TipoPromocion%ISOPEN THEN
    --
      CLOSE C_TipoPromocion;
    --
    END IF;

    IF C_ServicioActivo%ISOPEN THEN
    --
      CLOSE C_ServicioActivo;
    --
    END IF;

    IF C_ServicioAnulado%ISOPEN THEN
    --
      CLOSE C_ServicioAnulado;
    --
    END IF;
    --
    OPEN Lrf_ClientesMapeo FOR Lv_Consulta;
    LOOP
      FETCH Lrf_ClientesMapeo BULK COLLECT    
      INTO La_ClientesProcesar LIMIT 1000;
      EXIT WHEN La_ClientesProcesar.count = 0;
      Ln_Indx := La_ClientesProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)
      LOOP
       --
        BEGIN

          P_VALIDA_PROMO_PLAN_PROD(La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO,
                                   La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                   La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID,
                                   La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                   La_ClientesProcesar(Ln_Indx).PUNTO_ID,
                                   Lb_AplicaMapeo,
                                   La_ServiciosMapeados,
                                   La_ServiciosProcesar,
                                   La_ServiciosPerdidos,
                                   Lb_CumpleEstadoServ);

          IF Pv_TipoPromo = 'PROM_MENS' AND Lb_AplicaMapeo THEN
         
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                                         'P_VALIDA_PROMO_PLAN_PROD - Lb_AplicaMapeo: es TRUE'  , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          ELSE
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_PROMO_PLAN_PROD', 
                                         'P_VALIDA_PROMO_PLAN_PROD - Lb_AplicaMapeo: es FALSE'  , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

          END IF;

          IF Pv_TipoPromo = 'PROM_MENS' THEN
          --
            OPEN C_ServicioActivo(La_ClientesProcesar(Ln_Indx).PUNTO_ID,Pv_Empresa);
            --
            FETCH C_ServicioActivo INTO Ln_ServicioActivo;
            --
            CLOSE C_ServicioActivo;
            IF Ln_ServicioActivo = 0 THEN
              Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
              Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
              Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
              Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
              Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
              Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
              Lv_Observacion        := 'El servicio pierde la Promoción: '
              || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
              || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                       ', actualmente el servicio no se encuentra en un estado Activo.';
              Lv_Status             := 'Baja';
              RAISE Le_ActualizaMapeo;
            END IF;
          --
          END IF;
          IF Pv_TipoPromo = 'PROM_INS' THEN
          --
            OPEN C_ServicioAnulado(La_ClientesProcesar(Ln_Indx).SERVICIO_ID,Pv_Empresa);
            --
            FETCH C_ServicioAnulado INTO Ln_ServicioAnulado;
            --
            CLOSE C_ServicioAnulado;

            IF Ln_ServicioAnulado = 1 THEN
              Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
              Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
              Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
              Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
              Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
              Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
              Lv_Observacion        := 'El servicio pierde la Promoción: ' 
              || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
              || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                       ', actualmente el servicio no se encuentra en un estado Funcional.';
              Lv_Status             := 'Baja';
              RAISE Le_ActualizaMapeo;
            END IF;
          --
          END IF;

          OPEN C_TipoPromocion(La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID);
          --
          FETCH C_TipoPromocion INTO Lc_Tipo_Promocion;
          --
          CLOSE C_TipoPromocion;
          IF Lc_Tipo_Promocion.ESTADO = 'BAJA' THEN

            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' por estado actual "Baja" del Tipo de Promoción.';
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;

          Lr_ParametrosValidarSec                    :=  NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_TIPO_PROMOCION  :=  La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_PUNTO           :=  La_ClientesProcesar(Ln_Indx).PUNTO_ID;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'EXISTENTE';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_MENS'; --MENSUALIDAD
          Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_Empresa;
          
          IF Pv_TipoPromo = 'PROM_MENS' AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec)) THEN

            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: '
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Sectorización.';
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;

          IF Pv_TipoPromo != 'PROM_BW' AND 
             NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                         Fn_IdPunto        => La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Forma de Pago.';
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;

          IF Pv_TipoPromo = 'PROM_MENS' AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                                                  La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                                                                                  La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' momentaneamente por imcumplir la Regla por Mora.';
            Lv_Status             := 'Eliminado';
            RAISE Le_ActualizaMapeo;
          END IF;

          IF Pv_TipoPromo = 'PROM_MENS' AND NOT Lb_AplicaMapeo THEN

           Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
           Lv_Observacion        := 'El servicio pierde la Promoción: ' 
           || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
           || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Planes y Productos.';
  
            IF  NOT Lb_CumpleEstadoServ  THEN
               Lv_Observacion        := 'El servicio pierde la Promoción: ' 
               || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
               || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por no contar con los estados permitidos del servicio.';
            END IF;
              
           
            Lv_Status             := 'Baja';
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            IF La_ServiciosMapeados.COUNT = La_ServiciosPerdidos.COUNT OR (
               La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION = 'PROM_MIX' AND La_ServiciosPerdidos.COUNT > 0) THEN
              RAISE Le_ActualizaMapeo;
            ELSE
              RAISE Le_ActualizaServicio;
            END IF;
          END IF;

          Lr_ParametrosValidarSec                    :=  NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_SERVICIO        :=  La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'EXISTENTE';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_INS'; --INSTALACION
          Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_Empresa;
          
          IF Pv_TipoPromo = 'PROM_INS' AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec)) THEN

            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Sectorización.';
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;
          
          IF Pv_TipoPromo = 'PROM_MENS' THEN
            Lv_TieneSolicitud := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(La_ClientesProcesar(Ln_Indx).SERVICIO_ID);
            IF Lv_TieneSolicitud = 'N' THEN
              Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
              Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
              Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
              Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
              Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
              Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
              Lv_Observacion        := 'El servicio pierde la Promoción: ' 
              || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
              || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por contar con una solicitud de descuento.';
              Lv_Status             := 'Baja';
              RAISE Le_ActualizaMapeo;
            END IF;
          END IF;

          IF Pv_TipoPromo = 'PROM_INS' AND 
             NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                           La_ClientesProcesar(Ln_Indx).SERVICIO_ID)) THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: '
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Última Milla.';
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;

          IF Pv_TipoPromo = 'PROM_INS' AND 
             NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion => La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                           Fn_IdServicio     => La_ClientesProcesar(Ln_Indx).SERVICIO_ID,
                                                                           Fv_CodEmpresa     => Pv_Empresa)) THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla por Tipo de Negocio.';
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;

        EXCEPTION
        WHEN Le_ActualizaMapeo THEN
        --
          BEGIN
          --
            Ln_Contador := 0;
            La_SectorizacionProcesar.DELETE();
            Lv_msj                   := NULL;
            Lr_GrupoPromoRegla       := F_GET_PROMO_GRUPO_REGLA(Ln_IntIdPromocion);  
            Lr_TipoPromoRegla        := F_GET_PROMO_TIPO_REGLA(Ln_IntIdTipoPromocion);
            La_SectorizacionProcesar := F_GET_PROMO_SECTORIZACION(Ln_IntIdPromocion); 

            Lv_Trama                 := F_GET_TRAMA(Ln_IntIdPunto, 
                                                    Lr_GrupoPromoRegla,
                                                    Lr_TipoPromoRegla,
                                                    La_ServiciosMapeados,
                                                    La_SectorizacionProcesar,
                                                    null,
                                                    Pv_Empresa);
            FOR Lc_Id_Detalle_Mapeo IN C_Id_Detalle_Mapeo (Ln_IntIdPromocion,
                                                           Ln_IdPersonaRol,
                                                           Ln_IntIdPunto,
                                                           Ln_IntIdTipoPromocion,
                                                           Ln_Id_Detalle_Mapeo,
                                                           Ln_Id_Servicio) 
            LOOP
            --
              IF Ln_Contador < 1 OR Lv_Status = 'Baja' THEN
                Lr_InfoDetalleMapeoPromo                        := NULL;
                Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                Lr_InfoDetalleMapeoPromo.TRAMA                  := Lv_Trama;
                Lr_InfoDetalleMapeoPromo.FE_ULT_MOD             := SYSDATE;
                Lr_InfoDetalleMapeoPromo.USR_ULT_MOD            := 'telcos_map_prom';
                Lr_InfoDetalleMapeoPromo.IP_ULT_MOD             := Lv_IpCreacion;
                Lr_InfoDetalleMapeoPromo.ESTADO                 := Lv_Status;

                P_UPDATE_DETALLE_MAPEO_PROM(Lr_InfoDetalleMapeoPromo,
                                            Lv_msj);

                IF TRIM(Lv_msj) IS NOT NULL THEN
                --
                  RAISE Le_Exception;
                --
                END IF;

                Lr_InfoDetMapSolicitud                     := NULL;
                Lr_InfoDetMapSolicitud.DETALLE_MAPEO_ID    := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
                Lr_InfoDetMapSolicitud.USR_ULT_MOD         := 'telcos_map_prom';
                Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;
                Lr_InfoDetMapSolicitud.ESTADO              := Lv_Status;
                --
                P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud,
                                       Lv_msj);
                --
                IF TRIM(Lv_msj) IS NOT NULL THEN
                --
                  RAISE Le_Exception;
                --
                END IF;

                Lr_InfoDetalleMapeoHisto                         := NULL;
                Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
                Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
                Lr_InfoDetalleMapeoHisto.USR_CREACION            := 'telcos_map_prom';
                Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
                Lr_InfoDetalleMapeoHisto.OBSERVACION             := Lv_Observacion;
                Lr_InfoDetalleMapeoHisto.ESTADO                  := Lv_Status;
                --
                P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_msj);
                --
                IF TRIM(Lv_msj) IS NOT NULL THEN
                --
                  RAISE Le_Exception;
                --
                END IF;
              --
              END IF;
              Ln_Contador := Ln_Contador + 1;
            --
            END LOOP;

            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              RAISE Le_Exception;
            --
            END IF;
            IF Pv_TipoPromo = 'PROM_MENS' THEN
              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES(Pa_ServiciosPromo => La_ServiciosMapeados,
                                                                          Pv_CodEmpresa     => Pv_Empresa,
                                                                          Pv_TipoPromocion  => Pv_TipoPromo,
                                                                          Pv_EstadoOld      => 'Finalizada',
                                                                          Pv_estadoNew      => 'Eliminado',
                                                                          Pv_Observacion    => 'Se elimina la solicitud por perdida de promoción.',
                                                                          Pv_Mensaje        => Lv_msj);
            END IF;   

          EXCEPTION                     
          WHEN Le_Exception THEN
          --
            Lv_msj := 'Ocurrió un error al insertar el historial del servicio o mapeo para el ID_DETALLE_MAPEO: '
                      || Ln_Id_Detalle_Mapeo || ' en el script de perdida de promoción. MOTIVO : '
                      || Lv_Observacion || ' - ' || Lv_msj;

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                                 Lv_msj,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          WHEN OTHERS THEN
          --
            Lv_msj := 'Ocurrió un error al actualizar el mapeo del ID_DETALLE_MAPEO: ' || Ln_Id_Detalle_Mapeo 
                       || ' para el script de perdida de promoción.'; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                                 Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          END;
        WHEN Le_ActualizaServicio THEN
        --
          BEGIN
          --

            IF La_ServiciosPerdidos.COUNT > 0 THEN
              --
              Ln_ServiciosPerdidos := La_ServiciosPerdidos.FIRST;
              WHILE (Ln_ServiciosPerdidos IS NOT NULL)     
              LOOP

                FOR Lc_Id_Detalle_Mapeo IN C_Id_Detalle_Mapeo (Ln_IntIdPromocion,
                                                               Ln_IdPersonaRol,
                                                               Ln_IntIdPunto,
                                                               Ln_IntIdTipoPromocion,
                                                               Ln_Id_Detalle_Mapeo,
                                                               Ln_Id_Servicio) 
                LOOP

                  Lr_InfoDetMapSolicitud                     := NULL;
                  Lr_InfoDetMapSolicitud.DETALLE_MAPEO_ID    := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                  Lr_InfoDetMapSolicitud.SERVICIO_ID         := La_ServiciosPerdidos(Ln_ServiciosPerdidos).ID_SERVICIO;
                  Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
                  Lr_InfoDetMapSolicitud.USR_ULT_MOD         := 'telcos_map_prom';
                  Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;
                  Lr_InfoDetMapSolicitud.ESTADO              := Lv_Status;
                  --
                  P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud,
                                         Lv_msj);

                  IF TRIM(Lv_msj) IS NOT NULL THEN
                  --
                    RAISE Le_Exception;
                  --
                  END IF;
                END LOOP;
                Ln_ServiciosPerdidos := La_ServiciosPerdidos.NEXT(Ln_ServiciosPerdidos);           
              END LOOP;
              --
            END IF; 

            P_INSERTA_HIST_SERVICIO(La_ServiciosPerdidos,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              RAISE Le_Exception;
            --
            END IF;
            IF Pv_TipoPromo = 'PROM_MENS' THEN
              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES(Pa_ServiciosPromo => La_ServiciosPerdidos,
                                                                          Pv_CodEmpresa     => Pv_Empresa,
                                                                          Pv_TipoPromocion  => Pv_TipoPromo,
                                                                          Pv_EstadoOld      => 'Finalizada',
                                                                          Pv_estadoNew      => 'Eliminado',
                                                                          Pv_Observacion    => 'Se elimina la solicitud por perdida de promoción.',
                                                                          Pv_Mensaje        => Lv_msj);
            END IF;   

          EXCEPTION                          
          WHEN Le_Exception THEN
          --
            Lv_msj := 'Ocurrió un error al insertar el historial del servicio para el ID_DETALLE_MAPEO: '
                      || Ln_Id_Detalle_Mapeo || ' en el script de perdida de promoción. MOTIVO : '
                      || Lv_Observacion || ' - ' || Lv_msj;

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                                 Lv_msj,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          WHEN OTHERS THEN
          --
            Lv_msj := 'Ocurrió un error al actualizar el mapeo de la solicitud del ID_DETALLE_MAPEO: ' || Ln_Id_Detalle_Mapeo 
                       || ' para el script de perdida de promoción.'; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                                 Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          END;
        WHEN OTHERS THEN
        --
          Lv_msj := 'Ocurrió un error al evaluar el mapeo del ID_DETALLE_MAPEO: ' || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO 
                     || ' para el script de perdida de promoción.'; 
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                               Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                               'telcos_mapeo_promo',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
        END;
        Ln_Indx := La_ClientesProcesar.NEXT (Ln_Indx);
      --
      END LOOP;
      COMMIT;
    --
    END LOOP;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_msj := 'Ocurrió un error al ejecutar el script de perdida de promociones.'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
  END P_PIERDE_PROMO_MAPEO;
  --
  --
  --
  FUNCTION F_VALIDA_SERVICIO(Fn_IntIdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                             Fv_TipoPromocion IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                             Fv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2
  IS

    Lv_SelectDefinido   VARCHAR2(2000);
    Lv_SelectExiste     VARCHAR2(2000);
    Lv_CuerpoQuery      VARCHAR2(2000);
    Lv_Query            VARCHAR2(2000);
    Lv_TiposPromociones VARCHAR2(2000);
    Lv_Valor            VARCHAR2(1);
    Lv_Existe           VARCHAR2(1);
    Lb_Aplica           VARCHAR2(2);

  BEGIN

   IF Fv_TipoPromocion = 'PROM_MENS' THEN
     Lv_TiposPromociones := q'{'PROM_MPLA','PROM_MPRO','PROM_TOT','PROM_MIX'}';
   ELSE 
     Lv_TiposPromociones := ''''||TRIM(Fv_TipoPromocion)||'''';
   END IF;
   --Costo Query que valida si el servicio tiene una promoción definida ó indefinida: 1
   --Costo Query que valida si el servicio tiene una promoción vigente definida ó indefinida: 1
   Lv_SelectDefinido := q'{ SELECT DECODE(DBIDMP.INDEFINIDO,'','N','X','S') AS INDEFINIDO }';
   Lv_SelectExiste   := q'{ SELECT 'X' AS EXISTE }';
   Lv_CuerpoQuery    := q'{ FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DBIDMP  }'
                     || q'{ WHERE DBIDMP.ID_DETALLE_MAPEO IN (SELECT NVL(MAX(IDMP.ID_DETALLE_MAPEO),0) AS ID_DETALLE_MAPEO }'
                     || q'{ FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP }'
                     || q'{ WHERE IDMP.ID_DETALLE_MAPEO IN (SELECT IDMS.DETALLE_MAPEO_ID }'
                     || q'{ FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS }'
                     || q'{ WHERE IDMS.SERVICIO_ID = :1) }'
                     || q'{ AND IDMP.EMPRESA_COD = :2 }'
                     || q'{ AND IDMP.TIPO_PROMOCION IN (}'
                     || Lv_TiposPromociones
                     || q'{))}';

    BEGIN
      Lv_Query := Lv_SelectDefinido || Lv_CuerpoQuery;
      EXECUTE IMMEDIATE Lv_Query 
        INTO Lv_Valor 
        USING Fn_IntIdServicio, Fv_CodEmpresa;
    EXCEPTION
      WHEN OTHERS THEN
        Lb_Aplica := 'S';
        RETURN Lb_Aplica;
    END;

    IF Lv_Valor = 'S' THEN
      Lv_Query := Lv_SelectExiste || Lv_CuerpoQuery || q'{ AND DBIDMP.INDEFINIDO IS NOT NULL AND DBIDMP.ESTADO != 'Baja' }';
    ELSE
      Lv_Query := Lv_SelectExiste || Lv_CuerpoQuery || q'{ AND (DBIDMP.ESTADO = 'Activo' OR (DBIDMP.ESTADO != 'Baja' AND }'
                                                    || q'{ DBIDMP.CANTIDAD_PERIODOS > DBIDMP.MAPEOS_GENERADOS)) }';
    END IF;

    BEGIN
      EXECUTE IMMEDIATE Lv_Query 
        INTO Lv_Existe 
        USING Fn_IntIdServicio, Fv_CodEmpresa;
    EXCEPTION
      WHEN OTHERS THEN
        Lb_Aplica := 'S';
        RETURN Lb_Aplica;
    END;    

    IF Lv_Existe IS NOT NULL THEN
      Lb_Aplica := 'N';
    ELSE
      Lb_Aplica := 'S';
    END IF;

    RETURN Lb_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lb_Aplica := 'S';
    RETURN Lb_Aplica;
  END F_VALIDA_SERVICIO;
  --

   --
    FUNCTION F_OBTIENE_PERIODOS(
        Fv_TipoPromocion IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
        Fv_IdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
        Fv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
      RETURN VARCHAR2
    IS

        --Costo: 2
          CURSOR C_ObtieneCantidadPeriodos(Cn_IntTipoPromocion DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                                            Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
          IS
               SELECT COUNT(T1.VALOR) AS  CANTIDAD_PERIODOS
              FROM
                (SELECT REGEXP_SUBSTR(T.VALOR,'[^,]+', 1, LEVEL) AS VALOR
                FROM
                  (SELECT ATPR.VALOR
                  FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
                    DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                    DB_COMERCIAL.ADMI_CARACTERISTICA AC
                  WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_PERIODO'
                  AND AC.ID_CARACTERISTICA            = ATPR.CARACTERISTICA_ID
                  AND ATPR.ESTADO                    != 'Eliminado'
                  AND ATPR.TIPO_PROMOCION_ID          = ATP.ID_TIPO_PROMOCION
                  AND ATP.GRUPO_PROMOCION_ID          = Cn_IntIdPromocion
                  AND ATP.CODIGO_TIPO_PROMOCION       = Cn_IntTipoPromocion
                  )T
                  CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL
                ) T1;

                Ln_CantidadPeriodos         NUMBER                                         := 1;

        BEGIN

         IF C_ObtieneCantidadPeriodos%ISOPEN THEN
            CLOSE C_ObtieneCantidadPeriodos;
          END IF;
          --
          OPEN C_ObtieneCantidadPeriodos(Fv_TipoPromocion,Fv_IdPromocion);
          FETCH C_ObtieneCantidadPeriodos INTO Ln_CantidadPeriodos;
          CLOSE C_ObtieneCantidadPeriodos;
          --
          RETURN Ln_CantidadPeriodos;


    EXCEPTION
    WHEN OTHERS THEN
      --
      Ln_CantidadPeriodos := 0;

      RETURN Ln_CantidadPeriodos;

    END F_OBTIENE_PERIODOS;

   --
    FUNCTION F_OBTIENE_TIPO_CAMBIO_PLAN(
        Fn_IntIdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
        Fv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pv_TipoEjecucion IN VARCHAR2)
      RETURN VARCHAR2
    IS
 
        CURSOR C_GetUserCambioPlan(Cn_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Cd_FeCambioPlan  DATE,
                                   Cv_Observacion   VARCHAR2)
        IS
         SELECT 
            MAX(ISH.USR_CREACION) AS USR_CREACION
          FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
          WHERE ISH.SERVICIO_ID                     = Cn_IdServicio
          AND ISH.ID_SERVICIO_HISTORIAL             IN(SELECT MAX(HIS.ID_SERVICIO_HISTORIAL) 
                                                       FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL HIS
                                                       WHERE HIS.SERVICIO_ID = Cn_IdServicio 
                                                       AND HIS.OBSERVACION   LIKE Cv_Observacion)
          AND ISH.OBSERVACION                           LIKE Cv_Observacion
          AND ISH.FE_CREACION                       >= SYSDATE - 1
          AND ISH.FE_CREACION                       <= SYSDATE;

        --Costo: 2
       CURSOR C_GetIdHistCambioPlan(Cn_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Cd_FeCambioPlan  DATE,
                                    Cv_Observacion   VARCHAR2)
        IS
         SELECT 
             MAX(ID_SERVICIO_HISTORIAL) AS MAXIMO_HISTORIAL
         FROM INFO_SERVICIO_HISTORIAL
         WHERE SERVICIO_ID = CN_IDSERVICIO
         AND OBSERVACION   LIKE Cv_Observacion
         AND FE_CREACION   >= SYSDATE - 1
         AND FE_CREACION   <= SYSDATE; 

       CURSOR  C_GetPrecioAnteriorNuevo (Cn_IdServicioHist DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE)
       IS
         WITH
         phrases 
         AS (
             SELECT OBSERVACION AS texto
             FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
             WHERE ID_SERVICIO_HISTORIAL = Cn_IdServicioHist
            ),
        labels 
        AS (
            SELECT 
            'precio nuevo:' etiqueta_ini1,
            'precio anterior:' etiqueta_ini2,
            '<b>' tagIni,
            '</b>' tagFin 
            FROM DUAL 
           ),
        datos 
        AS (
            SELECT 
            substr(
                  substr(texto, instr(texto, lbl.etiqueta_ini2)), 
                  length(lbl.etiqueta_ini2 || tagIni ) + 1
                  , instr(substr(texto, instr(texto, lbl.etiqueta_ini2)), tagFin)
                  ) dato,
            substr(
                  substr(texto, instr(texto, lbl.etiqueta_ini1)), 
                  length(lbl.etiqueta_ini1 || tagIni ) + 1
                  , instr(substr(texto, instr(texto, lbl.etiqueta_ini1)), tagFin)
                  ) nuevo              
            FROM phrases
            JOIN labels lbl on 1 = 1
           )
        SELECT
         substr(dt.dato, 0 , instr(dt.dato, lbl.tagFin) - 1) PRECIO_ANTERIOR,
         substr(dt.nuevo, 0 , instr(dt.nuevo, lbl.tagFin) - 1) PRECIO_NUEVO
        FROM datos dt
        JOIN labels lbl on 1 = 1
       ;      
       
        CURSOR C_GetPlanCaract(Cn_IdServicioHist    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE,
                                Cv_TipoSol           DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                Cv_Caract            DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE
                                    )
        IS
          SELECT valor AS PLAN FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
            WHERE DETALLE_SOLICITUD_ID IN 
              ( SELECT MAX(ID_DETALLE_SOLICITUD) AS DETALLE_SOLICITUD
                 FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                  WHERE  
                  SERVICIO_ID = Cn_IdServicioHist
                  AND TIPO_SOLICITUD_ID IN (
                     SELECT ID_TIPO_SOLICITUD FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
                     WHERE DESCRIPCION_SOLICITUD = Cv_TipoSol)
                  )
            AND CARACTERISTICA_ID  IN (
                  SELECT ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA
                  WHERE DESCRIPCION_CARACTERISTICA = Cv_Caract);
          
    CURSOR C_ObtieneParametro(Cv_DescripcionParemetro DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                              Cv_Parametro            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                              Cv_EstadoActivo         VARCHAR2,
                              Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DET.VALOR1,
        DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
      AND DET.DESCRIPCION      = Cv_DescripcionParemetro
      AND DET.ESTADO           = Cv_EstadoActivo
      AND DET.EMPRESA_COD      = Cv_CodEmpresa
      AND CAB.NOMBRE_PARAMETRO = Cv_Parametro
      AND CAB.ESTADO           = Cv_EstadoActivo;

        Ln_IdServicioHist           NUMBER;
        Lv_PrecioAnterior           VARCHAR2(20);
        Lv_PrecioNuevo              VARCHAR2(20);
        Ln_PrecioAnterior           NUMBER;
        Ln_PrecioNuevo              NUMBER;
        Lv_TipoCambioPlan           VARCHAR2(20);
        Lv_UserCambioPlan           VARCHAR2(20);
        Lv_SolicPlanMasivo          DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE := 'SOLICITUD CAMBIO PLAN MASIVO';
        Lv_CaractPlanNuevo          DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PLAN NUEVO';
        Lv_CaractPlanAnterior       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PLAN VIEJO';
        Lv_PlanNuevo                VARCHAR2(20);
        Lv_PlanViejo                VARCHAR2(20);
        Lv_ValorPlanNuevo           VARCHAR2(20);
        Lv_ValorPlanViejo           VARCHAR2(20);
        Lv_MsjResultado             VARCHAR2(200);
        Lv_IpCreacion               VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        Ld_FeCambioPlan             DATE;
        Lv_DescripcionParametro     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_DESC_CAMBIO_PLAN';
        Lv_Parametro                DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_PARAMETROS';
        Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
        Lc_ObtieneParametro         C_ObtieneParametro%ROWTYPE;
        
        BEGIN

          IF C_ObtieneParametro%ISOPEN THEN
            CLOSE C_ObtieneParametro;
          END IF;
          --
          OPEN C_ObtieneParametro(Lv_DescripcionParametro,Lv_Parametro,Lv_EstadoActivo,Fv_CodEmpresa);
          FETCH C_ObtieneParametro INTO Lc_ObtieneParametro;
          CLOSE C_ObtieneParametro;

          Ld_FeCambioPlan:=SYSDATE;
    
          IF Pv_TipoEjecucion='MASIVO' THEN
        
            Ld_FeCambioPlan:=SYSDATE-1;
          
          END IF;
          IF C_GetUserCambioPlan%ISOPEN THEN
            CLOSE C_GetUserCambioPlan;
          END IF;
          --
          OPEN C_GetUserCambioPlan(Fn_IntIdServicio,Ld_FeCambioPlan,Lc_ObtieneParametro.VALOR1);
          FETCH C_GetUserCambioPlan INTO Lv_UserCambioPlan;
          CLOSE C_GetUserCambioPlan;
         --
         -- se verifica si el cambio de plan fue realizado por el usuario cambioplanm, de cambio de plan masivo
          IF Lv_UserCambioPlan ='cambioplanm' THEN
           -- buscar INFO_DETALLE_SOLICITUD y INFO_DETALLE_SOL_CARACT
           -- obtener los id planes y buscar el valor de plan nuevo y viejo  FUNCTION F_GET_VALOR_PLAN en comek consutlas
           
           -- obtengo plan nuevo 
              IF C_GetPlanCaract%ISOPEN THEN
                CLOSE C_GetPlanCaract;
              END IF;
              --
              OPEN C_GetPlanCaract(Fn_IntIdServicio,Lv_SolicPlanMasivo,Lv_CaractPlanNuevo);
              FETCH C_GetPlanCaract INTO Lv_PlanNuevo;
              CLOSE C_GetPlanCaract;
              
           -- obtengo plan viejo
              IF C_GetPlanCaract%ISOPEN THEN
                CLOSE C_GetPlanCaract;
              END IF;
              --
              OPEN C_GetPlanCaract(Fn_IntIdServicio,Lv_SolicPlanMasivo,Lv_CaractPlanAnterior);
              FETCH C_GetPlanCaract INTO Lv_PlanViejo;
              CLOSE C_GetPlanCaract;
              
              Lv_PrecioNuevo   :=DB_COMERCIAL.COMEK_CONSULTAS.F_GET_VALOR_PLAN(Lv_PlanNuevo); 
              Lv_PrecioAnterior:=DB_COMERCIAL.COMEK_CONSULTAS.F_GET_VALOR_PLAN(Lv_PlanViejo); 
              
              Ln_PrecioAnterior:=TO_NUMBER(REPLACE( Lv_PrecioAnterior, ',', '.' ), '9999.99') ;
              Ln_PrecioNuevo:=TO_NUMBER(REPLACE( Lv_PrecioNuevo, ',', '.' ), '9999.99') ;
          
          ELSE 
          
              IF C_GetIdHistCambioPlan%ISOPEN THEN
                CLOSE C_GetIdHistCambioPlan;
              END IF;
              --
              OPEN C_GetIdHistCambioPlan(Fn_IntIdServicio,Ld_FeCambioPlan,Lc_ObtieneParametro.VALOR1);
              FETCH C_GetIdHistCambioPlan INTO Ln_IdServicioHist;
              CLOSE C_GetIdHistCambioPlan;
              --
              IF Ln_IdServicioHist IS NULL THEN
                Lv_TipoCambioPlan:='N';
              END IF;              
              --
              IF C_GetPrecioAnteriorNuevo%ISOPEN THEN
                CLOSE C_GetPrecioAnteriorNuevo;
              END IF;
              --
              OPEN C_GetPrecioAnteriorNuevo(Ln_IdServicioHist);
              FETCH C_GetPrecioAnteriorNuevo INTO Lv_PrecioAnterior, Lv_PrecioNuevo;
              CLOSE C_GetPrecioAnteriorNuevo;

              Ln_PrecioAnterior:=TO_NUMBER(REPLACE( Lv_PrecioAnterior, ',', '.' ), '9999.99') ;
              Ln_PrecioNuevo:=TO_NUMBER(REPLACE( Lv_PrecioNuevo, ',', '.' ), '9999.99') ;
           
          END IF;
      
          IF Ln_PrecioNuevo>=Ln_PrecioAnterior THEN
          
           Lv_TipoCambioPlan:='UPGRADE';
          
          ELSIF  Ln_PrecioNuevo<Ln_PrecioAnterior THEN
          
           Lv_TipoCambioPlan:='DOWNGRADE';
          
          END IF;
          
          RETURN Lv_TipoCambioPlan;


    EXCEPTION
    WHEN OTHERS THEN
      --
         Lv_TipoCambioPlan := 'N';
         Lv_MsjResultado := 'Ocurrió un error al obtener el tipo de cambio de plan.'; 
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.F_OBTIENE_TIPO_CAMBIO_PLAN', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );    
         RETURN Lv_TipoCambioPlan;                                  
    END F_OBTIENE_TIPO_CAMBIO_PLAN;
    
--  
  PROCEDURE P_MAPEO_CAMBIO_PLAN ( Pr_Punto                 IN Lr_PtosClientesProcesar DEFAULT NULL,
                                  Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_TipoProceso           IN VARCHAR2,
                                  Pv_TipoEjecucion         IN VARCHAR2,
                                  Pn_IdPromocion           IN NUMBER DEFAULT NULL)
  IS
  
    CURSOR C_GetErrorRepetido(Cv_Mensaje VARCHAR2 ) IS
    SELECT 'EXISTE'
    FROM DB_GENERAL.INFO_ERROR
    WHERE DETALLE_ERROR = Cv_Mensaje;
    
    CURSOR C_GetEsCambioPrecio (Cv_IdServicio VARCHAR2 ) IS
       SELECT 
      case  when  ish.servicio_id is not null then 'S' else null end as cambio_precio
         FROM INFO_SERVICIO_HISTORIAL ish
         inner join info_servicio iser on ish.servicio_id=iser.id_servicio
         inner join info_punto ipu on iser.punto_id = ipu.id_punto
         WHERE ish.accion     =  'confirmoCambioPrecio'
         AND ish.FE_CREACION  >= sysdate - 1
         AND ish.FE_CREACION  <= sysdate
         and iser.id_servicio =  Cv_IdServicio
         group by ish.servicio_id;


    Lv_Estado                     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE   :='Activo';
    --
    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ld_FeEvaluaVigencia           DATE;
    Lv_EstadoServicio             VARCHAR2(20) :='Activo';
    Ln_IndGpro                    NUMBER; 
    La_GruposPromocionesProcesar  T_GruposPromocionesProcesar;
    Lb_OtorgoPromoCliente         BOOLEAN;
    Lb_CumplePromo                BOOLEAN;
    Lb_CumpleRegla2               BOOLEAN;
    Lb_CumpleRegla3               BOOLEAN;
    Lb_CumpleRegla4               BOOLEAN;  
    Lb_PromoIndefinida            BOOLEAN;
    La_SectorizacionProcesar      T_SectorizacionProcesar;  
    La_TiposPromocionesProcesar   T_TiposPromocionesProcesar;
    La_TipoPromoPlanProdProcesar  T_TipoPromoPlanProdProcesar;
    La_ServiciosProcesar          T_ServiciosProcesar;
    La_ServiciosCumplePromo       T_ServiciosProcesar;  
    --
    Lv_MsjResultado               VARCHAR2(32000);   
    Lv_MsjExceptionProceso        VARCHAR2(1000);
    Lv_MsjExceptionTipoPromo      VARCHAR2(1000);
    Lv_MsjExceptionGrupoPromo     VARCHAR2(1000);
    Lv_MsjExceptionPunto          VARCHAR2(1000);
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionTipoPromo         EXCEPTION;
    Le_ExceptionGrupoPromo        EXCEPTION;
    Le_ExceptionPunto             EXCEPTION;
    --
    Lr_Punto                      Lr_PtosClientesProcesar;
    Lr_GruposPromociones          Lr_GruposPromocionesProcesar;
    Lr_TiposPromociones           Lr_TiposPromocionesProcesar;
    Lr_GrupoPromoRegla            Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla             Lr_TipoPromoReglaProcesar;
    --
    Lrf_PuntosProcesar            SYS_REFCURSOR;
    Lrf_GruposPromociones         SYS_REFCURSOR;
    Lrf_TiposPromociones          SYS_REFCURSOR;    
    --
    Ln_Indx                       NUMBER;
    Ln_IndTpro                    NUMBER;   
    --
    Lv_Consulta                   VARCHAR2(4000);
    Lv_Trama                      VARCHAR2(32000);
    Lv_TipoPromocion              VARCHAR2(20);
    Lv_Existe                     VARCHAR2(6);
    Lv_EsCambioPrecio             VARCHAR2(20);
    Lv_TipoProceso                VARCHAR2(200) := Pv_TipoProceso;

  BEGIN
         --Limpiamos la Tabla de Servicios y Trama
    La_ServiciosProcesar.DELETE();    
    Lv_Trama:='';   
    Lb_OtorgoPromoCliente:=FALSE;
    Ld_FeEvaluaVigencia:=SYSDATE;
    
    IF Pv_TipoEjecucion='MASIVO' THEN
  
      Ld_FeEvaluaVigencia:=SYSDATE-1;
    
    END IF;

    --  
    IF C_GetEsCambioPrecio%ISOPEN THEN
      CLOSE C_GetEsCambioPrecio;
    END IF;
    OPEN  C_GetEsCambioPrecio(Pn_IdServicio);
    FETCH C_GetEsCambioPrecio INTO Lv_EsCambioPrecio;
    CLOSE C_GetEsCambioPrecio;
   --  
   
    IF Lv_EsCambioPrecio='S' THEN
  
     Lv_TipoProceso:='UPGRADE_CAMBIO_PRECIO';
    
    END IF;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                             'Se inicia proceso: P_MAPEO_CAMBIO_PLAN, ID_SERVICIO: '||Pn_IdServicio, 
                                             'telcos_mapeo_promo',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

    La_GruposPromocionesProcesar.DELETE();

               --Obtengo los Grupos de Promociones que se van a Procesar por código de grupo y empresa que cumplan la fecha de vigencia.
        DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT( Pd_FeEvaluaVigencia     => Ld_FeEvaluaVigencia,
                                                                 Pn_IdServicio           => Pn_IdServicio,
                                                                 Pn_IdPromocion          => Pn_IdPromocion,
                                                                 Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                 Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                 Pv_TipoProceso          => Pv_TipoProceso,
                                                                 Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                                 Pa_TiposPromoPrioridad  => La_TiposPromocionesProcesar);   


     IF La_GruposPromocionesProcesar IS NULL THEN
        Lv_MsjExceptionProceso:='No se pudo obtener los Grupos de Promocionales para el Proceso de Mapeo de Promociones. ';
        RAISE Le_ExceptionProceso;
     END IF;

       Ln_IndGpro :=La_GruposPromocionesProcesar.FIRST;   

       WHILE (Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente)       
          LOOP  
            --Inicio de Bloque para manejo de excepciones por Grupo Promocional                   
            BEGIN
              Lr_GruposPromociones := La_GruposPromocionesProcesar(Ln_IndGpro);
              Ln_IndGpro := La_GruposPromocionesProcesar.NEXT(Ln_IndGpro);  
                                    
              --Obtengo Reglas por Grupo Promocional.
              Lr_GrupoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_GRUPO_REGLA(Lr_GruposPromociones.ID_GRUPO_PROMOCION);   
              --
              IF Pv_CodigoGrupoPromocion ='PROM_MENS' AND Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION IS NULL THEN             
                Lv_MsjExceptionGrupoPromo:= 'Ocurrio un error al obtener las reglas del Grupo Promocion ID_GRUPO_PROMOCION: '
                                          ||Lr_GruposPromociones.ID_GRUPO_PROMOCION;

                RAISE Le_ExceptionGrupoPromo;            
              END IF;            
              --          
              --Limpiamos la Tabla de Sectores
              La_SectorizacionProcesar.DELETE();
              --Obtengo Sectorizacion como estructura de tabla por Grupo o por Tipo Promocional
              La_SectorizacionProcesar:=DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Lr_GruposPromociones.ID_GRUPO_PROMOCION);        
 
              --Obtengo los Tipos de Promociones que se van a Procesar por Grupo y empresa que cumplan la fecha de vigencia y ordenado Prioridad.
              P_OBTIENE_TIPOS_PROMOCIONES(Lr_GruposPromociones.ID_GRUPO_PROMOCION, Pv_CodigoGrupoPromocion, Pv_CodEmpresa ,Lrf_TiposPromociones, Ld_FeEvaluaVigencia);

              IF NOT(Lrf_TiposPromociones%ISOPEN) THEN              
                Lv_MsjExceptionGrupoPromo:= 'Ocurrio un error al obtener los Tipos de Promocionales del Grupo Promocion ID_GRUPO_PROMOCION: '
                                           ||Lr_GruposPromociones.ID_GRUPO_PROMOCION;

                RAISE Le_ExceptionGrupoPromo;
              END IF; 
              --
              La_TiposPromocionesProcesar.DELETE();
              --  
              --
              LOOP
                FETCH Lrf_TiposPromociones BULK COLLECT INTO La_TiposPromocionesProcesar LIMIT 4;
                Ln_IndTpro :=La_TiposPromocionesProcesar.FIRST;  

                WHILE (Ln_IndTpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente)       
                LOOP 
                  --Inicio de Bloque para manejo excepciones por Tipo Promocional
                  BEGIN
                    Lr_TiposPromociones := La_TiposPromocionesProcesar(Ln_IndTpro);
                    Ln_IndTpro := La_TiposPromocionesProcesar.NEXT(Ln_IndTpro); 

                    --Obtengo Reglas por Tipo Promocional.
                    Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Lr_TiposPromociones.ID_TIPO_PROMOCION);                    
                    --
                    IF Lr_TipoPromoRegla.ID_TIPO_PROMOCION IS NULL THEN                    
                      Lv_MsjExceptionTipoPromo:= 'Ocurrio un error al obtener las reglas del Tipo Promocional ID_TIPO_PROMOCION: '
                                                 ||Lr_TiposPromociones.ID_TIPO_PROMOCION;

                      RAISE Le_ExceptionTipoPromo;            
                    END IF;           
            
                    --
                    --Obtengo los planes y productos por Tipo de Promoción, en este caso: PROM_MIX, PROM_MPLA, PROM_MPRO, PROM_BW.
                    La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Lr_TiposPromociones.ID_TIPO_PROMOCION); 

                    IF (Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_BW')
                        AND La_TipoPromoPlanProdProcesar.COUNT = 0) THEN  

                      Lv_MsjExceptionTipoPromo:= 'No se encontraron definidos Planes y/o Productos para el Tipo Promocional ID_TIPO_PROMOCION: '
                                               ||Lr_TiposPromociones.ID_TIPO_PROMOCION;         
                      RAISE Le_ExceptionTipoPromo;             
                    END IF;
                    --
                    --Obtengo el valor de la regla que define el estado de los servicios a considerar en el Proceso.                         
                    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
                      Lv_EstadoServicio:=Lr_GrupoPromoRegla.PROM_ESTADO_SERVICIO;
                    ELSE
                      Lv_EstadoServicio:=Lr_TipoPromoRegla.PROM_ESTADO_SERVICIO;
                    END IF;

                    --
                    --Obtengo los servicios a procesar por punto considerando el estado de los servicios en base a la regla (PROM_ESTADO_SERVICIO)
                    --y al TipoProceso: NUEVO y/o EXISTENTE.
                    --Para el caso de NUEVO, se consideran los clientes que confirman servicio y el estado del servicio Activo.
                    P_OBTIENE_SERVICIOS_PROCESAR(Pn_IdPunto              => Pr_Punto.ID_PUNTO, 
                                                 Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion, 
                                                 Pv_CodEmpresa           => Pv_CodEmpresa, 
                                                 Pv_TipoProceso          => Pv_TipoProceso, 
                                                 Pa_ServiciosProcesar    => La_ServiciosProcesar,
                                                 Pv_EstadoServicio       => Lv_EstadoServicio);

                    IF La_ServiciosProcesar.COUNT = 0 THEN
                      Lv_MsjExceptionTipoPromo:= 'No se encontraron servicios para el Proceso de Mapeo de Promociones para el ID_PUNTO: '
                                                 ||Pr_Punto.ID_PUNTO;

                      RAISE Le_ExceptionTipoPromo; 
                    END IF;                    
                    --
                    --Limpiamos la Tabla de servicios que cumplen el Tipo Promocional
                    La_ServiciosCumplePromo.DELETE(); 
                    Lb_CumplePromo:=TRUE;                   
                    --Obtengo los servicios a procesar por cada Tipo Promocional            
                    DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_ServiciosProcesar, 
                                                                             Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION,
                                                                             La_TipoPromoPlanProdProcesar, 
                                                                             Lb_CumplePromo,
                                                                             La_ServiciosCumplePromo);                     
                    IF NOT Lb_CumplePromo and La_ServiciosCumplePromo.COUNT = 0 THEN                      
                      Lv_MsjExceptionTipoPromo:= 'No se encontraron servicios en el Punto Cliente ID_PUNTO: '||Pr_Punto.ID_PUNTO||
                                                 ' que cumplan o se encuentren definidos en el Tipo Promocional ID_TIPO_PROMOCION: ' 
                                                 ||Lr_TiposPromociones.ID_TIPO_PROMOCION;   

                      RAISE Le_ExceptionTipoPromo; 
                    END IF;                    
                    --
                    --Si se cumplen todas las Reglas Promocionales llamo al procedimiento que genera el Mapeo de Promociones
                    --Se llama a Proceso de Mapeo por Tipo de Promocion Indefinida o Definida.   
            
                    IF Lb_CumplePromo THEN        

                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                            'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                                            'Se cumplio la regla de planes y productos para el ID_SERVICIO: '||Pn_IdServicio, 
                                                            'telcos_mapeo_promo',
                                                            SYSDATE,
                                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                      Lb_CumpleRegla2:=DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                              Fn_IdPunto        => Pr_Punto.ID_PUNTO);                                                                

                      IF UPPER(Pv_TipoProceso) = 'NUEVO' THEN
                        Lb_CumpleRegla3 := TRUE;
                      ELSE
                        Lb_CumpleRegla3 := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PERMANENCIA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                                   Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                                   Pr_Punto.ID_PUNTO);
                      END IF;
                      
                      Lb_CumpleRegla4:=DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                        Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                        Pr_Punto.ID_PUNTO);
                                                                                       
                      Lb_PromoIndefinida:=F_VALIDA_PROMO_INDEFINIDA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                            Lr_TiposPromociones.CODIGO_TIPO_PROMOCION);                    
                      IF Lb_CumpleRegla2 THEN
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                              'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                                              'Se cumplio la regla de planes y productos para el ID_SERVICIO: '||Pn_IdServicio, 
                                                              'telcos_mapeo_promo',
                                                              SYSDATE,
                                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                      END IF;
                      IF Lb_CumpleRegla3 THEN
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                              'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                                              'Se cumplio la regla de permanencia minima para el ID_SERVICIO: '||Pn_IdServicio, 
                                                              'telcos_mapeo_promo',
                                                              SYSDATE,
                                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                      END IF;
                      IF Lb_CumpleRegla4 THEN
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                              'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                                              'Se cumplio la regla de mora para el ID_SERVICIO: '||Pn_IdServicio, 
                                                              'telcos_mapeo_promo',
                                                              SYSDATE,
                                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                      END IF;
                      IF  Lb_CumpleRegla2 AND Lb_CumpleRegla3 AND Lb_CumpleRegla4 THEN                         
                      
                        --Llamo a la Función que construye la Trama de la información del Cliente en base a las reglas Promocionales evaluadas.
                        Lv_Trama:=F_GET_TRAMA(Pr_Punto.ID_PUNTO, Lr_GrupoPromoRegla, Lr_TipoPromoRegla,  
                                              La_ServiciosCumplePromo,La_SectorizacionProcesar,null,Pv_CodEmpresa);

                        Lv_MsjResultado := NULL;
                        IF Lb_PromoIndefinida THEN  
                          --                                                    
                          Lv_TipoPromocion:= 'Promoción Indefinida';
                         
                          P_MAPEO_PROMO_MENSUAL(Pr_Punto,
                                                La_ServiciosCumplePromo,
                                                Lr_GruposPromociones,
                                                Lr_GrupoPromoRegla,
                                                Lr_TiposPromociones,
                                                Lr_TipoPromoRegla,
                                                Lv_TipoProceso,
                                                Lv_Trama,
                                                NULL,
                                                Lv_MsjResultado);                                                   
                        ELSE   
                          --                                                            
                          Lv_TipoPromocion:= 'Promoción Definida';

                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                             'Se inicia ejecución del proceso: P_MAPEO_PROMO_DEFINIDAS, ID_SERVICIO: '||Pn_IdServicio, 
                                             'telcos_mapeo_promo',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

                          P_MAPEO_PROMO_DEFINIDAS(Pr_Punto                => Pr_Punto,
                                                  Pa_ServiciosCumplePromo => La_ServiciosCumplePromo,
                                                  Pr_GruposPromociones    => Lr_GruposPromociones,
                                                  Pr_GrupoPromoRegla      => Lr_GrupoPromoRegla,
                                                  Pr_TiposPromociones     => Lr_TiposPromociones,
                                                  Pr_TipoPromoRegla       => Lr_TipoPromoRegla,
                                                  Pv_TipoProceso          => Lv_TipoProceso,
                                                  Pv_Trama                => Lv_Trama,
                                                  Pv_CodEmpresa           => Pv_CodEmpresa,
                                                  Pv_MsjResultado         => Lv_MsjResultado);
                        END IF;
                        --
                        IF Lv_MsjResultado IS NOT NULL THEN
                          --                          
                          Lv_MsjExceptionTipoPromo:= 'No se pudo generar el mapeo Promocional para el ID_PUNTO: '||Pr_Punto.ID_PUNTO||
                                                     ' Grupo Promocional ID_GRUPO_PROMOCION: ' ||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                                                     ' Tipo Promocional ID_TIPO_PROMOCION: ' ||Lr_TiposPromociones.ID_TIPO_PROMOCION||
                                                     ' ' ||Lv_TipoPromocion||' - ' || Lv_MsjResultado;                                               
                          RAISE Le_ExceptionTipoPromo; 
                          --
                        ELSE
                          Lb_OtorgoPromoCliente:=TRUE;

                        END IF;
                        --
                      END IF;
                    END IF;           
                    --                
                    --Limpiamos la Tabla de Planes y Productos por Tipo Promocional
                    La_TipoPromoPlanProdProcesar.DELETE();             
                    --
                    -- 
                  EXCEPTION
                  WHEN Le_ExceptionTipoPromo THEN

                    Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                                      || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionTipoPromo; 
                    Lv_Existe:='';
                    OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
                    --
                    FETCH C_GetErrorRepetido INTO Lv_Existe;
                    --
                    IF Lv_Existe <> 'EXISTE' THEN

                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                           'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                           'telcos_mapeo_promo',
                                                           SYSDATE,
                                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                                          ); 
                    END IF;
                    CLOSE C_GetErrorRepetido;                                      
                    Lv_MsjResultado:=NULL;
                    --
                  END;
                  --Fin de Bloque para manejo de excepciones por Tipo Promocional

                END LOOP;--Fin de WHILE (Ln_IndTpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente) 
                EXIT WHEN Lrf_TiposPromociones%NOTFOUND OR Lb_OtorgoPromoCliente;
                --
                --
              END LOOP;--Fin Loop 
              CLOSE Lrf_TiposPromociones;                                        
              --  
              --
            EXCEPTION
            WHEN Le_ExceptionGrupoPromo THEN
              Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                                 || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionGrupoPromo; 

              Lv_Existe:='';
              OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
              --
              FETCH C_GetErrorRepetido INTO Lv_Existe;
              --
              IF Lv_Existe <> 'EXISTE' THEN

                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                                     Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_mapeo_promo',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                                    ); 
              END IF;
              CLOSE C_GetErrorRepetido;
              Lv_MsjResultado:=NULL;
              --
            END;
            --Fin de Bloque para manejo de excepciones por Grupo Promocional
            --
          END LOOP;--Fin de WHILE (Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente) 

  EXCEPTION 
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para cambio de plan: '||
                      ' Servicio : '||Pn_IdServicio || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Perdida de Promociones
                      para el Grupo de Promocional: '|| Lv_TipoPromocion;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_MAPEO_CAMBIO_PLAN;
  --
  
  --  
  PROCEDURE P_MAPEO_CAMBIO_PLAN_INDIVIDUAL(Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                           Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                           Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                           Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_TipoProceso           IN VARCHAR2,
                                           Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL,
                                           Pv_Status                OUT VARCHAR2,
                                           Pv_MsjError              OUT VARCHAR2)
  IS
    
    --Costo:3
    CURSOR C_GetPunto(Cv_IdServicio VARCHAR2 ) IS
     SELECT ISER.PUNTO_ID
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE ISER.id_servicio = Cv_IdServicio;

    --Costo:20
    CURSOR C_GetIdPromocionMens(Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_Caracteristica       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS    
      SELECT AGP.ID_GRUPO_PROMOCION, DBAC.ID_CARACTERISTICA
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP
      WHERE ISC.SERVICIO_ID                 = Cn_IdServicio
      AND ISC.ESTADO                        = 'Activo'
      AND DBAC.ID_CARACTERISTICA            = ISC.CARACTERISTICA_ID
      AND DBAC.DESCRIPCION_CARACTERISTICA   = Cv_Caracteristica
      AND ATP.ID_TIPO_PROMOCION             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(TRIM(ISC.VALOR),'^\d+')),0)      
      AND ATP.ESTADO                        IN ('Activo','Inactivo')      
      AND AGP.ID_GRUPO_PROMOCION            = ATP.GRUPO_PROMOCION_ID
      AND AGP.EMPRESA_COD                   = Cv_CodEmpresa
      AND AGP.ESTADO                        IN ('Activo','Inactivo')
      AND ATPR.GRUPO_PROMOCION_ID           = AGP.ID_GRUPO_PROMOCION
      AND ATPR.ESTADO                       IN ('Activo','Inactivo')
      AND ATPR.CARACTERISTICA_ID            IN (SELECT CARAC.ID_CARACTERISTICA
                                                FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARAC
                                                WHERE CARAC.DESCRIPCION_CARACTERISTICA = 'PROM_CODIGO');

    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado               VARCHAR2(2000);   
    Lv_MsjExceptionProceso        VARCHAR2(1000);
    Lv_MsjExceptionTipoPromo      VARCHAR2(1000);
    Lv_MsjExceptionGrupoPromo     VARCHAR2(1000);
    Lv_MsjExceptionPunto          VARCHAR2(1000);
    Le_ExceptionCodigo            EXCEPTION;
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionTipoPromo         EXCEPTION;
    Le_ExceptionGrupoPromo        EXCEPTION;
    Le_ExceptionPunto             EXCEPTION;
    --
    Lv_EstadoPromocion            DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE;
    Lv_Consulta                   CLOB;
    La_PtosClientesProcesar       T_PtosClientesProcesar;
    Lrf_PuntosProcesar            SYS_REFCURSOR;
    Ln_Indx                       NUMBER;
    Ln_Limit                      CONSTANT PLS_INTEGER DEFAULT 5000;
    Lr_Punto                      Lr_PtosClientesProcesar;
    Lv_IdServicioPref             VARCHAR2(4000);
    Lv_EsCambioPlan               VARCHAR2(4000);
    Ln_IdPunto                    NUMBER;
    Lc_GetIdPromocion             C_GetIdPromocionMens%ROWTYPE;
    Ln_IdPromocion                DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Ln_IdCaracteristica           DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    
  BEGIN
    --
    --Obtengo consulta de los Puntos Clientes a Procesar por Tipo de Promoción, Código de empresa, 
    --Tipo de Proceso : Clientes Nuevos o Clientes Existentes.

    --
    IF Pn_IdServicio IS NOT NULL THEN
    --    
    --  
      IF C_GetPunto%ISOPEN THEN
        CLOSE C_GetPunto;
      END IF;
      OPEN  C_GetPunto(Pn_IdServicio);
      FETCH C_GetPunto INTO Ln_IdPunto;
      CLOSE C_GetPunto;
    --  
    ELSE
    --
      Ln_IdPunto:= Pn_IdPunto;
    --
    END IF;
    --
    IF DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Fn_IntIdServicio => Pn_IdServicio,
                                                       Fv_TipoPromocion => Pv_CodigoGrupoPromocion,
                                                       Fv_CodEmpresa    => Pv_CodEmpresa) = 'N' THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                           'Se valida promocion vigente: ' ||
                                           ', ID_SERVICIO: '||Pn_IdServicio, 
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                                                
      Lv_EstadoPromocion := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_OTIENE_ESTADO_PROMOCION(Fn_IntIdServicio  => Pn_IdServicio,
                                                                                         Fv_GrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                                         Fv_CodEmpresa     => Pv_CodEmpresa);
      IF Lv_EstadoPromocion IS NOT NULL AND Lv_EstadoPromocion = 'Activo' THEN                                                                                    
                                                                  
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                             'Se valida el estado del ultimo mapeo de la promocion vigente: ' ||
                                             ' Estado: Activo, ID_SERVICIO: '||Pn_IdServicio, 
                                             'telcos_mapeo_promo',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                                            
        DB_COMERCIAL.CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO(Pv_Empresa     => Pv_CodEmpresa,
                                                           Pv_TipoPromo   => Pv_CodigoGrupoPromocion,
                                                           Pn_IdPunto     => Ln_IdPunto);
      ELSIF Lv_EstadoPromocion IS NOT NULL AND Lv_EstadoPromocion = 'Finalizado' THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                             'Se valida el estado del ultimo mapeo de la promocion vigente: ' ||
                                             ' Estado: Finalizado, ID_SERVICIO: '||Pn_IdServicio, 
                                             'telcos_mapeo_promo',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        DB_COMERCIAL.CMKG_PROMOCIONES.P_PIERDE_PROMO_EXISTENTE(Pv_Empresa    => Pv_CodEmpresa,
                                                               Pv_IdServicio => Pn_IdServicio,
                                                               Pv_TipoPromo  => Pv_CodigoGrupoPromocion);
      END IF;   
      
    END IF;
 
    IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN

      IF C_GetIdPromocionMens%ISOPEN THEN
        CLOSE C_GetIdPromocionMens;
      END IF;
      OPEN C_GetIdPromocionMens(Pn_IdServicio, 'PROM_COD_CAMBIO', Pv_CodEmpresa);
      FETCH C_GetIdPromocionMens INTO Lc_GetIdPromocion;
      CLOSE C_GetIdPromocionMens;
        
      IF (Lc_GetIdPromocion.ID_GRUPO_PROMOCION IS NOT NULL AND Lc_GetIdPromocion.ID_GRUPO_PROMOCION > 0) THEN
        Ln_IdPromocion      := Lc_GetIdPromocion.ID_GRUPO_PROMOCION;
        Ln_IdCaracteristica := Lc_GetIdPromocion.ID_CARACTERISTICA;
      ELSE
        Lv_MsjExceptionProceso := 'No se encontró código definido para el servicio: ' || Pn_IdServicio || 'del Proceso de Promociones ' 
                                  || Pv_CodigoGrupoPromocion || ' COD_EMPRESA: '||Pv_CodEmpresa;
        RAISE Le_ExceptionCodigo;
      END IF;
    END IF;

    DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR(Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                            Pv_CodEmpresa           => Pv_CodEmpresa,
                                                            Pv_TipoProceso          => Pv_TipoProceso,
                                                            Pn_IdPunto              => Ln_IdPunto,
                                                            Pv_Consulta             => Lv_Consulta);
    --
    IF Lv_Consulta IS NULL THEN
      Lv_MsjExceptionProceso:='No se pudo obtener los puntos clientes para el Proceso de Mapeo de Promociones. ';
      RAISE Le_ExceptionProceso;
    END IF;
    --             
    --    
    La_PtosClientesProcesar.DELETE();
    --
    OPEN Lrf_PuntosProcesar FOR Lv_Consulta;
    LOOP    
      FETCH Lrf_PuntosProcesar BULK COLLECT INTO La_PtosClientesProcesar LIMIT Ln_Limit;
      Ln_Indx:=La_PtosClientesProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP       
        BEGIN
          Lv_IdServicioPref:='';
          --Recorriendo la data de los Puntos
          Lr_Punto := La_PtosClientesProcesar(Ln_Indx);
          Ln_Indx  := La_PtosClientesProcesar.NEXT(Ln_Indx);  
          -- Se realiza validación de Cambio de Plan
          Lv_IdServicioPref:= DB_COMERCIAL.GET_ID_SERVICIO_PREF(Lr_Punto.ID_PUNTO);

          Lv_EsCambioPlan  := DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_TIPO_CAMBIO_PLAN(Lv_IdServicioPref,Pv_CodEmpresa,'INDIVIDUAL');

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                               'Se inicia ejecución del proceso: P_MAPEO_CAMBIO_PLAN_INDIVIDUAL, Lv_EsCambioPlan: '||Lv_EsCambioPlan||
                                               ', ID_SERVICIO: '||Pn_IdServicio, 
                                               'telcos_mapeo_promo',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          IF Lv_EsCambioPlan!='N' THEN
            --P_MAPEO_CAMBIO_PLAN
            DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN(Lr_Punto, Lv_IdServicioPref, Pv_CodigoGrupoPromocion, Pv_CodEmpresa, Lv_EsCambioPlan,'INDIVIDUAL', Ln_IdPromocion);
          END IF;

        END;
      --Fin de Bloque para manejo de excepciones por Punto
      --
      END LOOP;--Fin de WHILE (Ln_Indx IS NOT NULL)
      COMMIT;
      EXIT WHEN Lrf_PuntosProcesar%NOTFOUND;
    --
    END LOOP;-- Fin Loop - End Loop  
    CLOSE Lrf_PuntosProcesar; 
    IF UPPER(TRIM(Pv_EsCodigo)) = 'S' AND
      DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Pn_IdServicio,Pv_CodigoGrupoPromocion,Pv_CodEmpresa) = 'S' THEN

      Lr_InfoServicioHistorial                       := NULL;
      Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
      Lr_InfoServicioHistorial.SERVICIO_ID           := Pn_IdServicio;
      Lr_InfoServicioHistorial.USR_CREACION          := 'telcos_map_prom';
      Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
      Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
      Lr_InfoServicioHistorial.ESTADO                := F_OBTIENE_ESTADO_SERV(Pn_IdServicio);
      Lr_InfoServicioHistorial.MOTIVO_ID             := NULL;
      Lr_InfoServicioHistorial.OBSERVACION           := 'El servicio no cumplió con las reglas de la promoción por código, este servicio '
                                                        || 'será evaluado para las demás promociones de cambio de plan sin código.';
      Lr_InfoServicioHistorial.ACCION                := NULL;
      DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,Lv_MsjResultado);
    END IF;
    Pv_Status   := 'OK';
  EXCEPTION 
    WHEN Le_ExceptionCodigo THEN
    --
    Pv_Status       := 'ERROR';
    Lv_MsjResultado := 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para cambio de plan: '||Pv_CodigoGrupoPromocion||
                       ' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
  
    WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Pv_Status       := 'ERROR';
    Lv_MsjResultado := 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para cambio de plan: '||Pv_CodigoGrupoPromocion||
                       ' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

  WHEN OTHERS THEN
    -- 
    ROLLBACK;
    Pv_Status   := 'ERROR';
    
    Pv_MsjError := 'Ha ocurrido un error al intentar ejecutar el proceso de mapeo de promociones de cambio de plan.';
    
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Perdida de Promociones
                      para el Grupo de Promocional: '; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            

  END P_MAPEO_CAMBIO_PLAN_INDIVIDUAL;
  --
   
     --  
  PROCEDURE P_MAPEO_CAMBIO_PRECIO(  Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS

    CURSOR C_GetServiciosCambioPrecio (Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
       SELECT DISTINCT DMS.SERVICIO_ID AS SERVICIO_ID,
        SERV.PUNTO_ID AS ID_PUNTO
        FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD DMS,
          DB_COMERCIAL.INFO_SERVICIO SERV
          WHERE SERV.ID_SERVICIO = DMS.SERVICIO_ID
          AND DMS.DETALLE_MAPEO_ID IN ( SELECT IDMP.ID_DETALLE_MAPEO
                                        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
                                        INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISER ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
                                        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON ISER.PUNTO_ID = IPU.ID_PUNTO
                                        INNER JOIN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP ON IDMP.PUNTO_ID = IPU.ID_PUNTO
                                        INNER JOIN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS ON IDMS.SERVICIO_ID= ISER.ID_SERVICIO 
                                              AND IDMS.DETALLE_MAPEO_ID= IDMP.ID_DETALLE_MAPEO
                                        WHERE (ISH.ACCION ='confirmoCambioPrecio' OR 
                                        (DBMS_LOB.SUBSTR(ISH.OBSERVACION,4000,1)) LIKE 'Se cambio de plan%')
                                        AND IDMP.TIPO_PROMOCION IN ('PROM_MIX','PROM_MPLA','PROM_MPRO')
                                        AND IDMP.ESTADO         =  'Activo'
                                        AND IDMP.EMPRESA_COD    = Cv_CodEmpresa
                                        AND ISH.FE_CREACION     >= SYSDATE-1
                                        AND ISH.FE_CREACION     <= SYSDATE)
       UNION
       SELECT 
         DISTINCT ISH.SERVICIO_ID AS SERVICIO_ID,
         IPU.ID_PUNTO AS ID_PUNTO
         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
         INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISER ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
         INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON ISER.PUNTO_ID = IPU.ID_PUNTO
         INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPU.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
         INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IPR ON IPER.EMPRESA_ROL_ID = IPR.ID_EMPRESA_ROL
         WHERE IPR.EMPRESA_COD = Cv_CodEmpresa
         AND (ISH.ACCION ='confirmoCambioPrecio' OR 
         (DBMS_LOB.SUBSTR(ISH.OBSERVACION,4000,1)) LIKE 'Se cambio de plan%')
         AND ISH.FE_CREACION >= SYSDATE - 1
         AND ISH.FE_CREACION <= SYSDATE;

    Lv_MsjResultado               VARCHAR2(2000);   
    Lv_MsjExceptionProceso        VARCHAR2(1000);
    Le_ExceptionProceso           EXCEPTION;
    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
    Lv_MsjError                   VARCHAR2(4000);
    Lv_Status                     VARCHAR2(4000);
    Lv_JobProceso                 VARCHAR2(4000);

  BEGIN
  --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PRECIO', 'Inicio ejecucion proceso P_MAPEO_CAMBIO_PRECIO',
                                             'telcos_cambioprecio',SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        
        IF C_GetServiciosCambioPrecio%ISOPEN THEN
          CLOSE C_GetServiciosCambioPrecio;
        END IF;

        Lv_JobProceso:='JobDiarioCambioPrecio';
        FOR Lr_ServiciosCambioPrecio IN C_GetServiciosCambioPrecio (Pv_CodEmpresa)
        LOOP        
             
             DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL(
                                                   Pn_IdPunto              => Lr_ServiciosCambioPrecio.id_punto,
                                                   Pn_IdServicio           => Lr_ServiciosCambioPrecio.servicio_id,
                                                   Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                   Pv_CodEmpresa           => Pv_CodEmpresa,
                                                   Pv_TipoProceso          => Pv_TipoProceso,
                                                   Pv_Status               => Lv_Status,
                                                   Pv_MsjError             => Lv_MsjError);
                                                                        
               DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => Pv_CodEmpresa,
                                                   Pv_TipoPromo    => Pv_CodigoGrupoPromocion,
                                                   Pn_IdServicio   => Lr_ServiciosCambioPrecio.servicio_id,
                                                   Pv_TipoProceso  => Pv_TipoProceso,
                                                   Pv_JobProceso   => Lv_JobProceso,
                                                   Pv_MsjResultado => Lv_MsjResultado
                                                   );                                                           

        END LOOP;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PRECIO', 'Fin ejecucion proceso P_MAPEO_CAMBIO_PRECIO',
                                             'telcos_cambioprecio',SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  EXCEPTION 
    WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para cambio de plan: '||Pv_CodigoGrupoPromocion||
                      ' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PRECIO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
  WHEN OTHERS THEN
    -- 
    ROLLBACK;
    Lv_Status   := 'ERROR';
    
    Lv_MsjError := 'Ha ocurrido un error al intentar ejecutar el proceso de mapeo de promociones de cambio de plan.';
    
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Perdida de Promociones
                      para el Grupo de Promocional: '; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PRECIO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_MAPEO_CAMBIO_PRECIO;
  -- 
    
--
  PROCEDURE P_GET_PROMOCIONES_SECT(Pd_FeEvaluaVigencia     IN DATE DEFAULT NULL,
                                   Pn_IdPunto              IN NUMBER DEFAULT NULL,
                                   Pn_IdServicio           IN NUMBER DEFAULT NULL,
                                   Pn_IdPromocion          IN NUMBER DEFAULT NULL,
                                   Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL,
                                   Pv_TipoEvaluacion       IN VARCHAR2 DEFAULT NULL,
                                   Pa_PromocionesPrioridad OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar,
                                   Pa_TiposPromoPrioridad  OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar)
  IS
    --Costo: 4
    CURSOR C_GetPrioridadSect(Cv_NombreParametro VARCHAR2,
                              Cv_EstadoActivo    VARCHAR2,
                              Cv_CodEmpresa      VARCHAR2) 
    IS  
      SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_NombreParametro
      AND APC.ESTADO             = Cv_EstadoActivo
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro
      AND APD.EMPRESA_COD        = Cv_CodEmpresa
      ORDER BY TO_NUMBER(COALESCE(TO_NUMBER(REGEXP_SUBSTR(APD.VALOR2,'^\d+')),0));

    --Costo: 13
    --Cursor para obtener el servicio 'Activo' del punto cliente.
    CURSOR C_SevicioPunto(Cn_IdPunto      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                          Cv_EstadoActivo VARCHAR2,
                          Cv_CodEmpresa   VARCHAR2)
    IS
      SELECT ISER.ID_SERVICIO 
        FROM DB_COMERCIAL.INFO_SERVICIO           ISER,
             DB_COMERCIAL.INFO_PLAN_DET           IPD,
             DB_COMERCIAL.ADMI_PRODUCTO           APR
      WHERE APR.CODIGO_PRODUCTO = 'INTD'
        AND APR.ID_PRODUCTO     =  IPD.PRODUCTO_ID
        AND IPD.PLAN_ID         =  ISER.PLAN_ID
        AND ISER.ESTADO         IN (SELECT APD.VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     =  APC.ID_PARAMETRO
                                      AND APD.ESTADO           =  Cv_EstadoActivo
                                      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                      AND APC.ESTADO           =  Cv_EstadoActivo
                                      AND APD.EMPRESA_COD      = Cv_CodEmpresa)
        AND ISER.PUNTO_ID   = Cn_IdPunto;

    --Costo: 29
    --Cursor para obtener los datos del servicio y punto del cliente.
    CURSOR C_SectorizacionPto(Cn_IdPto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT DISTINCT IP.PUNTO_COBERTURA_ID,
        APA.CANTON_ID AS ID_CANTON,
        APA.ID_PARROQUIA,
        ASE.ID_SECTOR,
        0 AS ID_ELEMENTO,
        0 AS EDIFICIO
      FROM DB_COMERCIAL.INFO_PUNTO IP,
        DB_GENERAL.ADMI_PARROQUIA  APA,
        DB_GENERAL.ADMI_SECTOR     ASE
      WHERE APA.ID_PARROQUIA  =  ASE.PARROQUIA_ID
        AND ASE.ID_SECTOR     =  IP.SECTOR_ID
        AND IP.ID_PUNTO       =  Cn_IdPto;

    --Costo: 29
    --Cursor para obtener los datos del servicio y punto del cliente.
    CURSOR C_SectorizacionServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT DISTINCT IP.PUNTO_COBERTURA_ID,
             APA.CANTON_ID AS ID_CANTON,
             APA.ID_PARROQUIA,
             ASE.ID_SECTOR,
             IE.ID_ELEMENTO,
             NVL((SELECT DISTINCT IPDA.ELEMENTO_ID
                   FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA,
                     DB_COMERCIAL.INFO_SERVICIO                DBIS,
                     DB_INFRAESTRUCTURA.INFO_ELEMENTO          DBIE,
                     DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   DBAME,
                     DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     DBATE
                  WHERE DBIS.ID_SERVICIO           =  ISE.ID_SERVICIO
                    AND IPDA.PUNTO_ID              =  DBIS.PUNTO_ID
                    AND IPDA.DEPENDE_DE_EDIFICIO   = 'S'
                    AND DBIE.ID_ELEMENTO           = IPDA.ELEMENTO_ID
                    AND DBAME.ID_MODELO_ELEMENTO   = DBIE.MODELO_ELEMENTO_ID
                    AND DBATE.ID_TIPO_ELEMENTO     = DBAME.TIPO_ELEMENTO_ID
                    AND DBATE.NOMBRE_TIPO_ELEMENTO = 'EDIFICACION'),0) AS EDIFICIO
      FROM DB_COMERCIAL.INFO_PUNTO                 IP,
           DB_GENERAL.ADMI_PARROQUIA               APA,
           DB_GENERAL.ADMI_SECTOR                  ASE,
           DB_COMERCIAL.INFO_SERVICIO              ISE,
           DB_COMERCIAL.INFO_SERVICIO_TECNICO      IST,
           DB_INFRAESTRUCTURA.INFO_ELEMENTO        IE,
           DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
           DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO   ATE,
           DB_COMERCIAL.INFO_PLAN_DET              IPD,
           DB_COMERCIAL.ADMI_PRODUCTO              AP
      WHERE APA.ID_PARROQUIA         =  ASE.PARROQUIA_ID
        AND ASE.ID_SECTOR            =  IP.SECTOR_ID
        AND ATE.NOMBRE_TIPO_ELEMENTO = 'OLT'
        AND ATE.ID_TIPO_ELEMENTO     =  AME.TIPO_ELEMENTO_ID
        AND AME.ID_MODELO_ELEMENTO   =  IE.MODELO_ELEMENTO_ID
        AND IE.ESTADO                = 'Activo'
        AND IE.ID_ELEMENTO           =  IST.ELEMENTO_ID
        AND IST.SERVICIO_ID          =  ISE.ID_SERVICIO
        AND AP.CODIGO_PRODUCTO       = 'INTD'
        AND AP.ID_PRODUCTO           =  IPD.PRODUCTO_ID
        AND IPD.PLAN_ID              =  ISE.PLAN_ID
        AND IP.ID_PUNTO              =  ISE.PUNTO_ID
        AND ISE.ID_SERVICIO          =  Cn_IdServicio;

    --Costo: 2
    CURSOR C_ExisteSectElemEdif(Cv_Valores VARCHAR2, Cn_Valor NUMBER)
    IS
      SELECT COUNT('X') AS VALOR
        FROM (SELECT REGEXP_SUBSTR (Cv_Valores,'[^,]+',1, LEVEL) VALOR FROM DUAL
              CONNECT BY REGEXP_SUBSTR (Cv_Valores,'[^,]+',1, LEVEL) IS NOT NULL) T
      WHERE Cn_Valor IN (COALESCE(TO_NUMBER(REGEXP_SUBSTR(T.VALOR,'^\d+')),0));

    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo               VARCHAR2(15) := 'Activo';
    Lv_NombreParametro            VARCHAR2(50) := 'PROM_PRIORIDAD_SECTORIZACION';
    Lv_Error                      VARCHAR2(32000);
    Lr_GruposPromociones          Lr_GruposPromocionesProcesar;
    Lr_TiposPromociones           Lr_TiposPromocionesProcesar;
    La_GruposPromocionesProcesar  T_GruposPromocionesProcesar;
    La_TiposPromocionesProcesar   T_TiposPromocionesProcesar;
    Lrf_GruposPromociones         SYS_REFCURSOR;
    Lrf_TiposPromociones          SYS_REFCURSOR;
    Lr_Sectorizaciones            SYS_REFCURSOR;
    Ln_Ind                        NUMBER := 1;
    Ln_IndGpro                    NUMBER;    
    Ln_ExisteSectElemEdif         NUMBER;
    Ln_idServicio                 NUMBER;
    Ln_IndxSectores               NUMBER;
    Lb_NoTieneDatos               BOOLEAN;
    Lb_Aplica                     BOOLEAN := FALSE;
    Lc_SectorizacionServicio      C_SectorizacionServicio%ROWTYPE;
    Lr_Sectorizacion              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_SectorizacionInsBwMens;
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    Lt_SectorizacionInsBwMens     DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tt_SectorizacionInsBwMens;
    Lex_Exception                 EXCEPTION;

  BEGIN
  --
    IF C_SectorizacionServicio%ISOPEN THEN
      CLOSE C_SectorizacionServicio;
    END IF;
    --
    IF C_SevicioPunto%ISOPEN THEN
      CLOSE C_SevicioPunto;
    END IF;
    --
    IF C_ExisteSectElemEdif%ISOPEN THEN
      CLOSE C_ExisteSectElemEdif;
    END IF;
    --
    IF C_GetPrioridadSect%ISOPEN THEN
      CLOSE C_GetPrioridadSect;
    END IF;    
    --
    --Obtenemos el servicio del cliente.
    IF UPPER(Pv_CodigoGrupoPromocion) IN ('PROM_INS','PROM_BW') OR
         (UPPER(Pv_CodigoGrupoPromocion) = 'PROM_MENS' AND Pn_IdServicio IS NOT NULL AND Pn_IdServicio > 0) THEN
    --CUANDO VIENE LLENO EL ID_SERVICIO EN TODAS LAS PROMOCIONES  
      Ln_idServicio := Pn_IdServicio;
    --
    ELSIF UPPER(Pv_CodigoGrupoPromocion) = 'PROM_MENS' AND Pn_IdPunto IS NOT NULL THEN
    --POR MENSUALIDAD SE OBTIENE EL SERVICIO POR EL ID_PUNTO
      OPEN C_SevicioPunto(Pn_IdPunto,'Activo',Pv_CodEmpresa);
        FETCH C_SevicioPunto INTO Ln_idServicio;
      CLOSE C_SevicioPunto;
    --
    ELSE
    --
      Lv_Error := 'Tipo de promoción no contemplada datos no validos';
      RAISE Lex_Exception;
    --
    END IF;

    IF Ln_idServicio IS NULL OR Ln_idServicio <= 0 THEN
      --Cursor para obtener los datos del punto (Sector del punto, parroquia, etc).
      OPEN C_SectorizacionPto(Pn_IdPunto);
        FETCH C_SectorizacionPto INTO Lc_SectorizacionServicio;
          Lb_NoTieneDatos := C_SectorizacionPto%NOTFOUND;
      CLOSE C_SectorizacionPto;    
    ELSE
      --Cursor para obtener los datos del servicio (Sector del punto, elementos, edificio, etc).
      OPEN C_SectorizacionServicio(Ln_idServicio);
        FETCH C_SectorizacionServicio INTO Lc_SectorizacionServicio;
          Lb_NoTieneDatos := C_SectorizacionServicio%NOTFOUND;
      CLOSE C_SectorizacionServicio;
    END IF;
    --Si el cursor para obtener los datos del servicio viene nulo, se procede a salir del la funcion con valor false.
    IF Lb_NoTieneDatos THEN
      Lv_Error := 'Cursor vacio para obtener los datos de sectorización del servicio';
      RAISE Lex_Exception;
    END IF;
    --ELIMINAMOS INFORMACIÓN DE LAS TABLAS A RETORNAR.
    Pa_PromocionesPrioridad.DELETE();
    Pa_TiposPromoPrioridad.DELETE();
    --SE OBTIENEN LAS PRIORIDADES POR SECTORIZACIÓN
    FOR Lc_GetPrioridadSect IN C_GetPrioridadSect (Lv_NombreParametro, Lv_EstadoActivo, Pv_CodEmpresa) 
    LOOP
    --
      Lb_Aplica := FALSE;
      --
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoEvaluacion IS NULL THEN
        --Obtengo los Grupos de Promociones que se van a Procesar por código de grupo y empresa que cumplan la fecha de vigencia.
        DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROMOCIONES(Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                   Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                   Pv_TipoProceso          => Pv_TipoProceso,
                                                                   Prf_GruposPromociones   => Lrf_GruposPromociones,
                                                                   Pd_FeEvaluaVigencia     => Pd_FeEvaluaVigencia,
                                                                   Pn_IdPromocion          => Pn_IdPromocion);
        --
        IF NOT(Lrf_GruposPromociones%ISOPEN) THEN
          Lv_Error := 'No se pudo obtener los Grupos de Promocionales para el Proceso de Mapeo de Promociones.';
          RAISE Lex_Exception;
        END IF;
        --ELIMINAMOS INFORMACIÓN DE LA TABLA A EVALUAR.      
        La_GruposPromocionesProcesar.DELETE();
        --  
        LOOP
        --
          FETCH Lrf_GruposPromociones BULK COLLECT INTO La_GruposPromocionesProcesar LIMIT 1000;          
          Ln_IndGpro := La_GruposPromocionesProcesar.FIRST;        
          --
          WHILE (Ln_IndGpro IS NOT NULL)       
          LOOP
          --
            Lb_Aplica                                  := FALSE;
            Lr_GruposPromociones                       := La_GruposPromocionesProcesar(Ln_IndGpro);
            Ln_IndGpro                                 := La_GruposPromocionesProcesar.NEXT(Ln_IndGpro);
            Lr_ParametrosValidarSec                    := NULL;
            Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION := Lr_GruposPromociones.ID_GRUPO_PROMOCION;
            Lr_ParametrosValidarSec.TIPO_PROMOCION     := Pv_CodigoGrupoPromocion; 
            --Obtenemos el cursor de la sectorización de acuerdo al tipo de promoción a la que se esta aplicando.
            Lr_Sectorizaciones                         := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_CURSOR_SECTORIZACION(Lr_ParametrosValidarSec);
            --Validamos que el cursor no sea nulo o no este abierto.
            IF Lr_Sectorizaciones IS NULL OR NOT Lr_Sectorizaciones%ISOPEN THEN
              Lb_Aplica := FALSE;
            ELSE
            --
              LOOP
                FETCH Lr_Sectorizaciones BULK COLLECT INTO Lt_SectorizacionInsBwMens LIMIT 100;
                EXIT WHEN Lt_SectorizacionInsBwMens.COUNT() < 1;
                --
                Ln_IndxSectores := Lt_SectorizacionInsBwMens.FIRST;
                --
                WHILE Ln_IndxSectores IS NOT NULL LOOP
                --
                  Lr_Sectorizacion := Lt_SectorizacionInsBwMens(Ln_IndxSectores);
                  Ln_IndxSectores  := Lt_SectorizacionInsBwMens.NEXT(Ln_IndxSectores);
                  --VALIDAMOS ELEMENTO
                  IF Lr_Sectorizacion.ID_ELEMENTO != '0' AND Lc_GetPrioridadSect.VALOR1 = 'ELEMENTO' THEN
                    OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_ELEMENTO,Lc_SectorizacionServicio.ID_ELEMENTO);
                      FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
                    CLOSE C_ExisteSectElemEdif;
                    IF Ln_ExisteSectElemEdif > 0 THEN
                      Lb_Aplica := TRUE;
                    END IF;
                  END IF;  
                  --VALIDAMOS EDIFICIO
                  IF Lr_Sectorizacion.ID_EDIFICIO != '0' AND Lc_GetPrioridadSect.VALOR1 = 'EDIFICIO' THEN
                  --
                    OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_EDIFICIO,Lc_SectorizacionServicio.EDIFICIO);
                      FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
                    CLOSE C_ExisteSectElemEdif;
                    IF Ln_ExisteSectElemEdif > 0 THEN
                      Lb_Aplica := TRUE;
                    END IF;
                  END IF;  
                  --VALIDAMOS SECTOR
                  IF Lr_Sectorizacion.ID_SECTOR != '0' AND Lc_GetPrioridadSect.VALOR1 = 'SECTOR' THEN
                  --
                    OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_SECTOR,Lc_SectorizacionServicio.ID_SECTOR);
                      FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
                    CLOSE C_ExisteSectElemEdif;
                    IF Ln_ExisteSectElemEdif > 0 THEN
                      Lb_Aplica := TRUE;
                    END IF;
                  END IF;
                  --VALIDAMOS LA PARROQUIA 
                  IF Lc_GetPrioridadSect.VALOR1 = 'PARROQUIA' AND Lr_Sectorizacion.ID_PARROQUIA != '0' 
                     AND Lr_Sectorizacion.ID_SECTOR = '0' AND Lr_Sectorizacion.ID_EDIFICIO = '0' 
                     AND Lr_Sectorizacion.ID_ELEMENTO = '0' AND Lc_SectorizacionServicio.ID_PARROQUIA  =
                     COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_PARROQUIA,'^\d+')),0) THEN
                     Lb_Aplica := TRUE;
                  END IF;
                  --VALIDAMOS EL CANTON 
                  IF Lc_GetPrioridadSect.VALOR1 = 'CANTON' AND Lr_Sectorizacion.ID_CANTON != '0' 
                     AND Lr_Sectorizacion.ID_PARROQUIA = '0' AND Lc_SectorizacionServicio.ID_CANTON =
                     COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_CANTON,'^\d+')),0) THEN
                    Lb_Aplica := TRUE;
                  END IF; 
                  --VALIDAMOS LA JURISDICCION
                  IF Lc_GetPrioridadSect.VALOR1 = 'JURISDICCION' AND Lr_Sectorizacion.ID_JURISDICCION != '0' 
                     AND Lr_Sectorizacion.ID_CANTON = '0' AND Lc_SectorizacionServicio.PUNTO_COBERTURA_ID =
                     COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_JURISDICCION,'^\d+')),0) THEN
                    Lb_Aplica := TRUE;
                  END IF;
                --
                END LOOP; --FIN SECTORIZACION POR PROMOCION 
              --
              END LOOP; --FIN DE TODAS LAS SECTORIZACIONES POR PROMOCION
            --
            END IF;-- FIN Validamos que el cursor no sea nulo o no este abierto.
            --SE VALIDA LA PRIORIDAD DE PROMOCIONES SIN SECTORIZACIÓN
            IF Lc_GetPrioridadSect.VALOR1 = 'SIN_SECTORIZACION' AND Lr_Sectorizaciones%ROWCOUNT = 0 THEN
              Lb_Aplica := TRUE;
            END IF;
            --SE GUARDA EN LA TABLA SI EL SERVICIO CUMPLIO CON AL MENOS UNA SECTORIZACIÓN DE LA PROMOCIÓN
            IF Lb_Aplica THEN
              Pa_PromocionesPrioridad(Ln_Ind).ID_GRUPO_PROMOCION  := Lr_GruposPromociones.ID_GRUPO_PROMOCION;
              Pa_PromocionesPrioridad(Ln_Ind).NOMBRE_GRUPO        := Lr_GruposPromociones.NOMBRE_GRUPO;
              Pa_PromocionesPrioridad(Ln_Ind).FE_INICIO_VIGENCIA  := Lr_GruposPromociones.FE_INICIO_VIGENCIA;
              Pa_PromocionesPrioridad(Ln_Ind).FE_FIN_VIGENCIA     := Lr_GruposPromociones.FE_FIN_VIGENCIA;
              Pa_PromocionesPrioridad(Ln_Ind).FE_CREACION         := Lr_GruposPromociones.FE_CREACION;
              Pa_PromocionesPrioridad(Ln_Ind).EMPRESA_COD         := Lr_GruposPromociones.EMPRESA_COD;
              Pa_PromocionesPrioridad(Ln_Ind).TIPO_PROCESO        := Lr_GruposPromociones.TIPO_PROCESO;
              Ln_Ind                                              := Ln_Ind + 1;
            END IF;
          --
          END LOOP;--FIN WHILE DE PROMOCIONES
          EXIT WHEN Lrf_GruposPromociones%NOTFOUND;   
        --
        END LOOP;--FIN LOOP DE PROMOCIONES
        CLOSE Lrf_GruposPromociones;
      ELSE
        --Obtengo los Grupos de Promociones que se van a Procesar por código de grupo y empresa que cumplan la fecha de vigencia.
        DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_TIPOS_PROMOCIONES(Pn_IdGrupoPromocion     => Pn_IdPromocion,
                                                                  Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                  Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                  Prf_TiposPromociones    => Lrf_TiposPromociones,
                                                                  Pd_FeEvaluaVigencia     => Pd_FeEvaluaVigencia,
                                                                  Pv_TipoProceso          => Pv_TipoProceso);
        --
        IF NOT(Lrf_TiposPromociones%ISOPEN) THEN
          Lv_Error := 'No se pudo obtener los Grupos de Promocionales para el Proceso de Mapeo de Promociones.';
          RAISE Lex_Exception;
        END IF;
        --ELIMINAMOS INFORMACIÓN DE LA TABLA A EVALUAR.      
        La_TiposPromocionesProcesar.DELETE();
        --  
        LOOP
        --
          FETCH Lrf_TiposPromociones BULK COLLECT INTO La_TiposPromocionesProcesar LIMIT 1000;
          Ln_IndGpro := La_TiposPromocionesProcesar.FIRST;
          --
          WHILE (Ln_IndGpro IS NOT NULL)       
          LOOP
          --
            Lb_Aplica                                  := FALSE;
            Lr_TiposPromociones                        := La_TiposPromocionesProcesar(Ln_IndGpro);
            Ln_IndGpro                                 := La_TiposPromocionesProcesar.NEXT(Ln_IndGpro);
            Lr_ParametrosValidarSec                    := NULL;
            Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
            Lr_ParametrosValidarSec.TIPO_PROMOCION     := Pv_CodigoGrupoPromocion;
            --Obtenemos el cursor de la sectorización de acuerdo al tipo de promoción a la que se esta aplicando.
            Lr_Sectorizaciones                         := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_CURSOR_SECTORIZACION(Lr_ParametrosValidarSec);
            --Validamos que el cursor no sea nulo o no este abierto.
            IF Lr_Sectorizaciones IS NULL OR NOT Lr_Sectorizaciones%ISOPEN THEN
              Lb_Aplica := FALSE;
            ELSE
            --
              LOOP
                FETCH Lr_Sectorizaciones BULK COLLECT INTO Lt_SectorizacionInsBwMens LIMIT 100;
                EXIT WHEN Lt_SectorizacionInsBwMens.COUNT() < 1;
                --
                Ln_IndxSectores := Lt_SectorizacionInsBwMens.FIRST;
                --
                WHILE Ln_IndxSectores IS NOT NULL LOOP
                --
                  Lr_Sectorizacion := Lt_SectorizacionInsBwMens(Ln_IndxSectores);
                  Ln_IndxSectores  := Lt_SectorizacionInsBwMens.NEXT(Ln_IndxSectores);
                  --VALIDAMOS ELEMENTO
                  IF Lr_Sectorizacion.ID_ELEMENTO != '0' AND Lc_GetPrioridadSect.VALOR1 = 'ELEMENTO' THEN
                    OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_ELEMENTO,Lc_SectorizacionServicio.ID_ELEMENTO);
                      FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
                    CLOSE C_ExisteSectElemEdif;
                    IF Ln_ExisteSectElemEdif > 0 THEN
                      Lb_Aplica := TRUE;
                    END IF;
                  END IF;  
                  --VALIDAMOS EDIFICIO
                  IF Lr_Sectorizacion.ID_EDIFICIO != '0' AND Lc_GetPrioridadSect.VALOR1 = 'EDIFICIO' THEN
                  --
                    OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_EDIFICIO,Lc_SectorizacionServicio.EDIFICIO);
                      FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
                    CLOSE C_ExisteSectElemEdif;
                    IF Ln_ExisteSectElemEdif > 0 THEN
                      Lb_Aplica := TRUE;
                    END IF;
                  END IF;  
                  --VALIDAMOS SECTOR
                  IF Lr_Sectorizacion.ID_SECTOR != '0' AND Lc_GetPrioridadSect.VALOR1 = 'SECTOR' THEN
                  --
                    OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_SECTOR,Lc_SectorizacionServicio.ID_SECTOR);
                      FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
                    CLOSE C_ExisteSectElemEdif;
                    IF Ln_ExisteSectElemEdif > 0 THEN
                      Lb_Aplica := TRUE;
                    END IF;
                  END IF;
                  --VALIDAMOS LA PARROQUIA 
                  IF Lc_GetPrioridadSect.VALOR1 = 'PARROQUIA' AND Lr_Sectorizacion.ID_PARROQUIA != '0' 
                     AND Lr_Sectorizacion.ID_SECTOR = '0' AND Lr_Sectorizacion.ID_EDIFICIO = '0' 
                     AND Lr_Sectorizacion.ID_ELEMENTO = '0' AND Lc_SectorizacionServicio.ID_PARROQUIA  =
                     COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_PARROQUIA,'^\d+')),0) THEN
                     Lb_Aplica := TRUE;
                  END IF;
                  --VALIDAMOS EL CANTON 
                  IF Lc_GetPrioridadSect.VALOR1 = 'CANTON' AND Lr_Sectorizacion.ID_CANTON != '0' 
                     AND Lr_Sectorizacion.ID_PARROQUIA = '0' AND Lc_SectorizacionServicio.ID_CANTON =
                     COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_CANTON,'^\d+')),0) THEN
                    Lb_Aplica := TRUE;
                  END IF; 
                  --VALIDAMOS LA JURISDICCION
                  IF Lc_GetPrioridadSect.VALOR1 = 'JURISDICCION' AND Lr_Sectorizacion.ID_JURISDICCION != '0' 
                     AND Lr_Sectorizacion.ID_CANTON = '0' AND Lc_SectorizacionServicio.PUNTO_COBERTURA_ID =
                     COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_JURISDICCION,'^\d+')),0) THEN
                    Lb_Aplica := TRUE;
                  END IF;
                --
                END LOOP; --FIN SECTORIZACION POR PROMOCION 
              --
              END LOOP; --FIN DE TODAS LAS SECTORIZACIONES POR PROMOCION
            --
            END IF;-- FIN Validamos que el cursor no sea nulo o no este abierto.
            --SE VALIDA LA PRIORIDAD DE PROMOCIONES SIN SECTORIZACIÓN
            IF Lc_GetPrioridadSect.VALOR1 = 'SIN_SECTORIZACION' AND Lr_Sectorizaciones%ROWCOUNT = 0 THEN
              Lb_Aplica := TRUE;
            END IF;
            --SE GUARDA EN LA TABLA SI EL SERVICIO CUMPLIO CON AL MENOS UNA SECTORIZACIÓN DE LA PROMOCIÓN
            IF Lb_Aplica THEN
              Pa_TiposPromoPrioridad(Ln_Ind).ID_GRUPO_PROMOCION     := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
              Pa_TiposPromoPrioridad(Ln_Ind).NOMBRE_GRUPO           := Lr_TiposPromociones.NOMBRE_GRUPO;
              Pa_TiposPromoPrioridad(Ln_Ind).FE_INICIO_VIGENCIA     := Lr_TiposPromociones.FE_INICIO_VIGENCIA;
              Pa_TiposPromoPrioridad(Ln_Ind).FE_FIN_VIGENCIA        := Lr_TiposPromociones.FE_FIN_VIGENCIA;
              Pa_TiposPromoPrioridad(Ln_Ind).ID_TIPO_PROMOCION      := Lr_TiposPromociones.ID_TIPO_PROMOCION;
              Pa_TiposPromoPrioridad(Ln_Ind).TIPO                   := Lr_TiposPromociones.TIPO;
              Pa_TiposPromoPrioridad(Ln_Ind).FE_CREACION            := Lr_TiposPromociones.FE_CREACION;
              Pa_TiposPromoPrioridad(Ln_Ind).CODIGO_TIPO_PROMOCION  := Lr_TiposPromociones.CODIGO_TIPO_PROMOCION;
              Pa_TiposPromoPrioridad(Ln_Ind).CODIGO_GRUPO_PROMOCION := Lr_TiposPromociones.CODIGO_GRUPO_PROMOCION;
              Pa_TiposPromoPrioridad(Ln_Ind).PRIORIDAD              := Lr_TiposPromociones.PRIORIDAD;
              Pa_TiposPromoPrioridad(Ln_Ind).EMPRESA_COD            := Lr_TiposPromociones.EMPRESA_COD;              
              Ln_Ind                                                := Ln_Ind + 1;
            END IF;
          --
          END LOOP;--FIN WHILE DE PROMOCIONES
          EXIT WHEN Lrf_TiposPromociones%NOTFOUND;   
        --
        END LOOP;--FIN LOOP DE PROMOCIONES
        CLOSE Lrf_TiposPromociones;
      END IF;
    --  
    END LOOP; --FIN LOOP DE PRIORIDADES

  EXCEPTION
  WHEN Lex_Exception THEN
    --
    Pa_TiposPromoPrioridad.DELETE();
    Pa_PromocionesPrioridad.DELETE();
    Lv_Error := Lv_Error || ', datos Pd_FeEvaluaVigencia: '|| Pd_FeEvaluaVigencia || ', Pn_IdPunto: ' ||  Pn_IdPunto || ', Pn_IdServicio: ' 
                || Pn_IdServicio || ', Pv_CodigoGrupoPromocion: ' || Pv_CodigoGrupoPromocion || ', Pv_CodEmpresa: ' || Pv_CodEmpresa 
                || ', Pv_TipoProceso: ' || Pv_TipoProceso;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT',
                                         Lv_Error,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  WHEN OTHERS THEN
    --
    Pa_TiposPromoPrioridad.DELETE();
    Pa_PromocionesPrioridad.DELETE();
    Lv_Error := 'MsjeError: Ocurrió un error en las evaluaciones de promociones por prioridad, datos Pd_FeEvaluaVigencia: '||
                Pd_FeEvaluaVigencia || ', Pn_IdPunto: ' ||  Pn_IdPunto || ', Pn_IdServicio: ' || Pn_IdServicio || 
                ', Pv_CodigoGrupoPromocion: ' || Pv_CodigoGrupoPromocion || ', Pv_CodEmpresa: ' || Pv_CodEmpresa ||
                ', Pv_TipoProceso: ' || Pv_TipoProceso;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT', 
                                         Lv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            
  END P_GET_PROMOCIONES_SECT;
  --
  PROCEDURE P_CAMBIO_PLAN_INDIVIDUAL(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoProceso          IN VARCHAR2,
                                     Pv_CodigoMens           IN VARCHAR2 DEFAULT NULL,
                                     Pv_IdTipoPromocion      IN VARCHAR2 DEFAULT NULL,
                                     Pv_Status               OUT VARCHAR2,
                                     Pv_MsjError             OUT VARCHAR2)
  IS 

    --Costo:2
    CURSOR C_GetCaracterist (Cv_DescCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Cv_DescCarac
      AND ESTADO                       = 'Activo';
  
    Lv_MsjResultado               VARCHAR2(2000);
    Lv_Status                     VARCHAR2(32000);
    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lr_InfoServicioCaracteristica DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE;
    Lc_GetCaracterist             C_GetCaracterist%ROWTYPE;
    Ln_idCaracteristica           DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
  
  BEGIN  

    IF TRIM(Pv_CodigoMens) IS NOT NULL AND TRIM(Pv_IdTipoPromocion) IS NOT NULL AND Pv_CodEmpresa != '10' THEN

      IF C_GetCaracterist%ISOPEN THEN    
        CLOSE C_GetCaracterist;    
      END IF;

      OPEN C_GetCaracterist('PROM_COD_CAMBIO');
      FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
      Ln_idCaracteristica := Lc_GetCaracterist.ID_CARACTERISTICA;
      CLOSE C_GetCaracterist;
      
      Lr_InfoServicioCaracteristica                             := NULL;
      Lr_InfoServicioCaracteristica.ID_SERVICIO_CARACTERISTICA  := DB_COMERCIAL.SEQ_INFO_SERVICIO_CARAC.NEXTVAL;
      Lr_InfoServicioCaracteristica.SERVICIO_ID                 := Pn_IdServicio;
      Lr_InfoServicioCaracteristica.CARACTERISTICA_ID           := Ln_idCaracteristica;
      Lr_InfoServicioCaracteristica.ESTADO                      := 'Activo';
      Lr_InfoServicioCaracteristica.VALOR                       := Pv_IdTipoPromocion; 
      Lr_InfoServicioCaracteristica.OBSERVACION                 := 'Se crea el código ' || Pv_CodigoMens || 
                                                                   ' promocional por Cambio de Plan.';
      Lr_InfoServicioCaracteristica.USR_CREACION                := 'telcos_map_prom';
      Lr_InfoServicioCaracteristica.IP_CREACION                 := Lv_IpCreacion;
      Lr_InfoServicioCaracteristica.FE_CREACION                 := SYSDATE;
      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_CARACTERISTICA_SERV (Lr_InfoServicioCaracteristica, Lv_MsjResultado);
      
      IF Lv_MsjResultado IS NULL THEN
      
        Lr_InfoServicioHistorial                          := NULL;
        Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL    := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
        Lr_InfoServicioHistorial.SERVICIO_ID              := Pn_IdServicio;
        Lr_InfoServicioHistorial.USR_CREACION             := 'telcos_map_prom';
        Lr_InfoServicioHistorial.FE_CREACION              := SYSDATE;
        Lr_InfoServicioHistorial.IP_CREACION              := Lv_IpCreacion;
        Lr_InfoServicioHistorial.ESTADO                   := DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_ESTADO_SERV(Pn_IdServicio);
        Lr_InfoServicioHistorial.MOTIVO_ID                := NULL;
        Lr_InfoServicioHistorial.OBSERVACION              := 'Se agregó el código promocional: '||TRIM(Pv_CodigoMens)||', de la promoción '||
        NVL(DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_OBTIENE_PROMOCION_COD(Fv_Codigo               => Pv_CodigoMens,
                                                                       Fv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                       Fv_CodEmpresa           => Pv_CodEmpresa),'por cambio de plan.');
        Lr_InfoServicioHistorial.ACCION                   := NULL;
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,Lv_MsjResultado);
      
        DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL(Pn_IdPunto               => Pn_IdPunto,
                                                                     Pn_IdServicio            => Pn_IdServicio,
                                                                     Pv_CodigoGrupoPromocion  => Pv_CodigoGrupoPromocion,
                                                                     Pv_CodEmpresa            => Pv_CodEmpresa,
                                                                     Pv_TipoProceso           => Pv_TipoProceso,
                                                                     Pv_EsCodigo              => 'S',
                                                                     Pv_Status                => Lv_Status,
                                                                     Pv_MsjError              => Lv_MsjResultado);
                                                                     
        Lr_InfoServicioCaracteristica                     := NULL;
        Lr_InfoServicioCaracteristica.SERVICIO_ID         := Pn_IdServicio;
        Lr_InfoServicioCaracteristica.CARACTERISTICA_ID   := Ln_idCaracteristica;
        Lr_InfoServicioCaracteristica.ESTADO              := 'Inactivo';
        Lr_InfoServicioCaracteristica.USR_ULT_MOD         := 'telcos_map_prom';
        Lr_InfoServicioCaracteristica.IP_ULT_MOD          := Lv_IpCreacion;
        Lr_InfoServicioCaracteristica.FE_ULT_MOD          := SYSDATE;
        DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_UPDATE_CARACTERISTICA_SERV (Lr_InfoServicioCaracteristica, Lv_MsjResultado);

      END IF;

    END IF;

    IF (TRIM(Pv_CodigoMens) IS NULL AND Pv_CodEmpresa != '10') OR
       DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Pn_IdServicio,Pv_CodigoGrupoPromocion,Pv_CodEmpresa) = 'S' THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                            'CMKG_PROMOCIONES.P_CAMBIO_PLAN_INDIVIDUAL', 
                                             'Se inicia ejecución del proceso: P_MAPEO_CAMBIO_PLAN_INDIVIDUAL, ID_SERVICIO: '||Pn_IdServicio, 
                                            'telcos_mapeo_promo',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

      DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PLAN_INDIVIDUAL(Pn_IdPunto               => Pn_IdPunto,
                                                                   Pn_IdServicio            => Pn_IdServicio,
                                                                   Pv_CodigoGrupoPromocion  => Pv_CodigoGrupoPromocion,
                                                                   Pv_CodEmpresa            => Pv_CodEmpresa,
                                                                   Pv_TipoProceso           => Pv_TipoProceso,
                                                                   Pv_EsCodigo              => 'N',
                                                                   Pv_Status                => Lv_Status,
                                                                   Pv_MsjError              => Lv_MsjResultado);
 
    END IF;

    Pv_Status   := Lv_Status;
    Pv_MsjError := Lv_MsjResultado;

  EXCEPTION  
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el Proceso de evaluación de Promociones para el Grupo de Promocional: '||
                        Pv_CodigoGrupoPromocion||', punto_Id - '|| Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio
                        || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_CAMBIO_PLAN_INDIVIDUAL', 
                                         Lv_MsjResultado, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  END P_CAMBIO_PLAN_INDIVIDUAL;
  --
  --
  --
  PROCEDURE P_PROMOCIONES_POR_CODIGO(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                     Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                     Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL)
  IS
  --Costo:0
  CURSOR C_GetEmpresa IS
  SELECT IEG.COD_EMPRESA
  FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
  WHERE IEG.COD_EMPRESA = Pv_CodEmpresa;

  --Costo:1
  CURSOR C_GetErrorRepetido(Cv_Mensaje VARCHAR2 ) IS
  SELECT 'EXISTE'
  FROM DB_GENERAL.INFO_ERROR
  WHERE DETALLE_ERROR = Cv_Mensaje;

    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionTipoPromo         EXCEPTION;
    Le_ExceptionGrupoPromo        EXCEPTION;
    Le_ExceptionPunto             EXCEPTION;
    Le_ExceptionServicioCod       EXCEPTION;
    Lv_Existe                     VARCHAR2(6);
    Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    --Mensaje para el registro de Log de Errores
    Lv_MsjResultado               VARCHAR2(32000);   
    Lv_MsjExceptionProceso        VARCHAR2(32000);
    Lv_MsjExceptionTipoPromo      VARCHAR2(32000);
    Lv_MsjExceptionGrupoPromo     VARCHAR2(32000);
    Lv_MsjExceptionPunto          VARCHAR2(32000);
    Lv_MsjExceptionServCod        VARCHAR2(32000);
    --Listados 
    Lrf_PuntosProcesar            SYS_REFCURSOR;
    Lrf_GruposPromociones         SYS_REFCURSOR;
    Lrf_TiposPromociones          SYS_REFCURSOR;    
    --Tipos definidos
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_InfoServicioCaracteristica DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE;
    Lr_Punto                      Lr_PtosClientesProcesar;
    Lr_GruposPromociones          Lr_GruposPromocionesProcesar;
    Lr_TiposPromociones           Lr_TiposPromocionesProcesar;
    Lr_GrupoPromoRegla            Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla             Lr_TipoPromoReglaProcesar;
    La_ServiciosCodigo            T_ServiciosPromCodigo;
    La_ServiciosProcesar          T_ServiciosProcesar;
    La_ServiciosCumplePromo       T_ServiciosProcesar;
    La_SectorizacionProcesar      T_SectorizacionProcesar;   
    La_TipoPromoPlanProdProcesar  T_TipoPromoPlanProdProcesar;
    Lb_OtorgoPromoCliente         BOOLEAN;
    Lb_CumplePromo                BOOLEAN;
    Lb_CumpleRegla2               BOOLEAN;
    Lb_CumpleRegla3               BOOLEAN;
    Lb_CumpleRegla4               BOOLEAN;  
    Lb_PromoIndefinida            BOOLEAN;
    Lv_TipoPromocion              VARCHAR2(20);
    Lv_EstadoServicio             VARCHAR2(20):='Activo';    
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    --Tipo para el BULK
    Ln_Limit                      CONSTANT PLS_INTEGER DEFAULT 5000;
    La_PtosClientesProcesar       T_PtosClientesProcesar;
    La_GruposPromocionesProcesar  T_GruposPromocionesProcesar;
    La_TiposPromocionesProcesar   T_TiposPromocionesProcesar;
    La_TiposPromoPrioridad        T_TiposPromocionesProcesar;
    Ln_Indx                       NUMBER;
    Ln_IndGpro                    NUMBER;    
    Ln_IndTpro                    NUMBER;
    
    Ln_ServiciosCodigo            NUMBER;
    
    --Query de consulta del script    
    Lv_Consulta                   CLOB;
    Lv_Trama                      VARCHAR2(4000);
    Ld_FeEvaluaVigencia           DATE;
    Lv_IdServicioPref             VARCHAR2(4000);
    Lv_EsCambioPlan               VARCHAR2(4000);

  BEGIN
    --
    IF Lrf_PuntosProcesar%ISOPEN THEN
      CLOSE Lrf_PuntosProcesar;
    END IF;
    --
    IF Lrf_GruposPromociones%ISOPEN THEN
      CLOSE Lrf_GruposPromociones;
    END IF;
    --
    IF Lrf_TiposPromociones%ISOPEN THEN
      CLOSE Lrf_TiposPromociones;
    END IF;
    --
    IF C_GetErrorRepetido%ISOPEN THEN
      CLOSE C_GetErrorRepetido;
    END IF;
    --
    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;
    --
    OPEN C_GetEmpresa;
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;
    --
    IF Lv_CodEmpresa IS NULL THEN
      Lv_MsjExceptionProceso := 'No se encuentra definido código de Empresa para el Proceso de Promociones COD_EMPRESA: '||Pv_CodEmpresa;
      RAISE Le_ExceptionProceso;
    END IF;
    --
    --Obtengo consulta de los Puntos de Clientes a Procesar que al menos un servicio tenga un código de promoción, 
    --Tipo de Proceso : Clientes Nuevos o Clientes Existentes.
    DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_PUNTOS_PROCESAR (Pv_CodigoGrupoPromocion  => Pv_CodigoGrupoPromocion,
                                                             Pv_CodEmpresa            => Pv_CodEmpresa,
                                                             Pv_TipoProceso           => Pv_TipoProceso,
                                                             Pv_FormaPago             => Pv_FormaPago,
                                                             Pn_IdCiclo               => Pn_IdCiclo,
                                                             Pv_IdsFormasPagoEmisores => Pv_IdsFormasPagoEmisores,
                                                             Pv_EsCodigo              => 'S',
                                                             Pv_Consulta              => Lv_Consulta);
    --
    IF Lv_Consulta IS NULL THEN
      Lv_MsjExceptionProceso:='No se pudo obtener los puntos clientes para el Proceso de Mapeo de Promociones por código. ';
      RAISE Le_ExceptionProceso;
    END IF;
    --    
    La_PtosClientesProcesar.DELETE();
    --
    OPEN Lrf_PuntosProcesar FOR Lv_Consulta;
    LOOP    
      FETCH Lrf_PuntosProcesar BULK COLLECT INTO La_PtosClientesProcesar LIMIT Ln_Limit;
      Ln_Indx := La_PtosClientesProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP       
      BEGIN
        --Limpiamos la Tabla de Servicios y Trama
        La_ServiciosProcesar.DELETE();    
        Lv_Trama              := '';   
        Lb_OtorgoPromoCliente := FALSE;
        --Recorriendo la data de los Puntos
        Lr_Punto              := La_PtosClientesProcesar(Ln_Indx);
        Ln_Indx               := La_PtosClientesProcesar.NEXT(Ln_Indx);

        --Obtengo los servicios a procesar por punto considerando el estado de los servicios en base a la regla (PROM_ESTADO_SERVICIO)
        --y al TipoProceso: NUEVO y/o EXISTENTE.
        --Para el caso de NUEVO, se consideran los clientes que confirman servicio y el estado del servicio Activo.
        DB_COMERCIAL.CMKG_PROMOCIONES.P_SERVICIOS_PROM_CODIGO(Pn_IdPunto              => Lr_Punto.ID_PUNTO, 
                                                              Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion, 
                                                              Pv_CodEmpresa           => Pv_CodEmpresa, 
                                                              Pv_TipoProceso          => Pv_TipoProceso,
                                                              Pv_EstadoServicio       => Lv_EstadoServicio,
                                                              Pa_ServiciosProcesar    => La_ServiciosCodigo);

        IF La_ServiciosCodigo.COUNT = 0 THEN
          Lv_MsjExceptionPunto := 'No se encontraron servicios para el Proceso de Mapeo de Promociones para el ID_PUNTO: '
                                  ||Lr_Punto.ID_PUNTO;
          RAISE Le_ExceptionPunto; 
        END IF;  
        --
        Ln_ServiciosCodigo := La_ServiciosCodigo.FIRST;           
        WHILE (Ln_ServiciosCodigo IS NOT NULL)   
        LOOP
        BEGIN
          --Obtengo la fecha con la cual se va a evaluar las vigencias de los grupos promocionales.
          Ld_FeEvaluaVigencia := NULL;
          La_GruposPromocionesProcesar.DELETE();
          --Obtengo los Grupos de Promociones que se van a Procesar por código de grupo y empresa que cumplan la fecha de vigencia.
          DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT(Pd_FeEvaluaVigencia     => Ld_FeEvaluaVigencia,
                                                               Pn_IdPunto              => Lr_Punto.ID_PUNTO,
                                                               Pn_IdPromocion          => La_ServiciosCodigo(Ln_ServiciosCodigo).ID_GRUPO_PROMOCION,
                                                               Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                               Pv_CodEmpresa           => Pv_CodEmpresa,
                                                               Pv_TipoProceso          => Pv_TipoProceso,
                                                               Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                               Pa_TiposPromoPrioridad  => La_TiposPromoPrioridad);
          --
          IF La_GruposPromocionesProcesar.COUNT = 0 THEN
            Lv_MsjExceptionServCod := 'No se pudo obtener los Grupos de Promocionales para el Proceso de Mapeo de Promociones. ';
            RAISE Le_ExceptionServicioCod;
          END IF;
          --
          Ln_IndGpro := La_GruposPromocionesProcesar.FIRST;        
          --
          WHILE (Ln_IndGpro IS NOT NULL)
          LOOP  
            --Inicio de Bloque para manejo de excepciones por Grupo Promocional                   
            BEGIN
              --
              Lr_GruposPromociones := La_GruposPromocionesProcesar(Ln_IndGpro);
              Ln_IndGpro           := La_GruposPromocionesProcesar.NEXT(Ln_IndGpro);  
              --Obtengo Reglas por Grupo Promocional.
              Lr_GrupoPromoRegla   := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_GRUPO_REGLA(Lr_GruposPromociones.ID_GRUPO_PROMOCION);   
              --
              IF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION IS NULL THEN             
                Lv_MsjExceptionGrupoPromo := 'Ocurrio un error al obtener las reglas del Grupo Promocion ID_GRUPO_PROMOCION: '
                                             ||Lr_GruposPromociones.ID_GRUPO_PROMOCION;
                RAISE Le_ExceptionGrupoPromo;            
              END IF;
              --          
              --Limpiamos la Tabla de Sectores
              La_SectorizacionProcesar.DELETE();
              --Obtengo Sectorizacion como estructura de tabla por Grupo o por Tipo Promocional
              La_SectorizacionProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Lr_GruposPromociones.ID_GRUPO_PROMOCION);        
              --Obtengo los Tipos de Promociones que se van a Procesar por Grupo y empresa que cumplan la fecha de vigencia y ordenado Prioridad.
              DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_TIPOS_PROMOCIONES(Pn_IdGrupoPromocion     => Lr_GruposPromociones.ID_GRUPO_PROMOCION, 
                                                                        Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                        Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                        Prf_TiposPromociones    => Lrf_TiposPromociones,
                                                                        Pd_FeEvaluaVigencia     => Ld_FeEvaluaVigencia,
                                                                        Pn_IdTipoPromocion      => La_ServiciosCodigo(Ln_ServiciosCodigo).ID_TIPO_PROMOCION);

              IF NOT(Lrf_TiposPromociones%ISOPEN) THEN              
                Lv_MsjExceptionGrupoPromo := 'Ocurrio un error al obtener los Tipos de Promocionales del Grupo Promocion ID_GRUPO_PROMOCION: '
                                             ||Lr_GruposPromociones.ID_GRUPO_PROMOCION;
                RAISE Le_ExceptionGrupoPromo;
              END IF;
              --
              La_TiposPromocionesProcesar.DELETE();
              --
              LOOP
                FETCH Lrf_TiposPromociones BULK COLLECT INTO La_TiposPromocionesProcesar LIMIT 4;
                Ln_IndTpro := La_TiposPromocionesProcesar.FIRST;  
                WHILE (Ln_IndTpro IS NOT NULL)
                LOOP 
                  --Inicio de Bloque para manejo excepciones por Tipo Promocional
                  BEGIN
                    Lr_TiposPromociones := La_TiposPromocionesProcesar(Ln_IndTpro);
                    Ln_IndTpro          := La_TiposPromocionesProcesar.NEXT(Ln_IndTpro); 
                    --Obtengo Reglas por Tipo Promocional.
                    Lr_TipoPromoRegla   := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Lr_TiposPromociones.ID_TIPO_PROMOCION);                    
                    --
                    IF Lr_TipoPromoRegla.ID_TIPO_PROMOCION IS NULL THEN                    
                      Lv_MsjExceptionTipoPromo := 'Ocurrio un error al obtener las reglas del Tipo Promocional ID_TIPO_PROMOCION: '
                                                  ||Lr_TiposPromociones.ID_TIPO_PROMOCION;
                      RAISE Le_ExceptionTipoPromo;            
                    END IF;            
                    --Obtengo los planes y productos por Tipo de Promoción, en este caso: PROM_MIX, PROM_MPLA, PROM_MPRO, PROM_BW.
                    La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Lr_TiposPromociones.ID_TIPO_PROMOCION); 
                    --
                    IF (Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_BW')
                        AND La_TipoPromoPlanProdProcesar.COUNT = 0) THEN  

                      Lv_MsjExceptionTipoPromo := 'No se encontraron definidos Planes y/o Productos para el Tipo Promocional ID_TIPO_PROMOCION: '
                                                  ||Lr_TiposPromociones.ID_TIPO_PROMOCION;         
                      RAISE Le_ExceptionTipoPromo;             
                    END IF;
                    --
                    --Obtengo el valor de la regla que define el estado de los servicios a considerar en el Proceso.                         
                    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
                      Lv_EstadoServicio := Lr_GrupoPromoRegla.PROM_ESTADO_SERVICIO;
                    ELSE
                      Lv_EstadoServicio := Lr_TipoPromoRegla.PROM_ESTADO_SERVICIO;
                    END IF;
                    --
                    --Obtengo los servicios a procesar por punto considerando el estado de los servicios en base a la regla (PROM_ESTADO_SERVICIO)
                    --y al TipoProceso: NUEVO y/o EXISTENTE.
                    --Para el caso de NUEVO, se consideran los clientes que confirman servicio y el estado del servicio Activo.
                    P_OBTIENE_SERVICIOS_PROCESAR(Pn_IdPunto              => Lr_Punto.ID_PUNTO,
                                                 Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion, 
                                                 Pv_CodEmpresa           => Pv_CodEmpresa, 
                                                 Pv_TipoProceso          => Pv_TipoProceso, 
                                                 Pa_ServiciosProcesar    => La_ServiciosProcesar,
                                                 Pv_EstadoServicio       => Lv_EstadoServicio,
                                                 Pv_EsCodigo             => 'S',
                                                 Pv_Codigo               => La_ServiciosCodigo(Ln_ServiciosCodigo).ID_TIPO_PROMOCION);

                    IF La_ServiciosProcesar.COUNT = 0 THEN
                      Lv_MsjExceptionTipoPromo := 'No se encontraron servicios para el Proceso de Mapeo de Promociones para el ID_PUNTO: '
                                                  ||Lr_Punto.ID_PUNTO;
                      RAISE Le_ExceptionTipoPromo; 
                    END IF;
                    --
                    --Limpiamos la Tabla de servicios que cumplen el Tipo Promocional
                    La_ServiciosCumplePromo.DELETE(); 
                    Lb_CumplePromo := TRUE;                   
                    --Obtengo los servicios a procesar por cada Tipo Promocional            
                    DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_ServiciosProcesar, 
                                                                             Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION,
                                                                             La_TipoPromoPlanProdProcesar, 
                                                                             Lb_CumplePromo,
                                                                             La_ServiciosCumplePromo);                     
                    IF NOT Lb_CumplePromo and La_ServiciosCumplePromo.COUNT = 0 THEN                      
                      Lv_MsjExceptionTipoPromo := 'No se encontraron servicios en el Punto Cliente ID_PUNTO: '||Lr_Punto.ID_PUNTO||
                                                  ' que cumplan o se encuentren definidos en el Tipo Promocional ID_TIPO_PROMOCION: ' 
                                                  ||Lr_TiposPromociones.ID_TIPO_PROMOCION;   
                      RAISE Le_ExceptionTipoPromo; 
                    END IF;                    
                    --
                    --Si se cumplen todas las Reglas Promocionales llamo al procedimiento que genera el Mapeo de Promociones
                    --Se llama a Proceso de Mapeo por Tipo de Promocion Indefinida o Definida.           
                    IF Lb_CumplePromo THEN                      

                      Lb_CumpleRegla2 := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                                Fn_IdPunto        => Lr_Punto.ID_PUNTO);
                      IF UPPER(Pv_TipoProceso) = 'NUEVO' THEN
                        Lb_CumpleRegla3  := TRUE;
                      ELSE
                        Lb_CumpleRegla3  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PERMANENCIA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                                    Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                                    Lr_Punto.ID_PUNTO);
                      END IF;
                      Lb_CumpleRegla4    := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                                             Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                             Lr_Punto.ID_PUNTO);
                      Lb_PromoIndefinida := F_VALIDA_PROMO_INDEFINIDA(Lr_GruposPromociones.ID_GRUPO_PROMOCION,
                                                                      Lr_TiposPromociones.CODIGO_TIPO_PROMOCION);                    

                      IF Lb_CumpleRegla2 AND Lb_CumpleRegla3 AND Lb_CumpleRegla4 THEN                         

                        --Llamo a la Función que construye la Trama de la información del Cliente en base a las reglas Promocionales evaluadas.
                        Lv_Trama        := F_GET_TRAMA(Lr_Punto.ID_PUNTO, Lr_GrupoPromoRegla, Lr_TipoPromoRegla,  
                                                       La_ServiciosCumplePromo,La_SectorizacionProcesar,null,Pv_CodEmpresa);
                        Lv_MsjResultado := NULL;
                        IF Lb_PromoIndefinida THEN  
                        --                                                    
                          Lv_TipoPromocion := 'Promoción Indefinida';
                          P_MAPEO_PROMO_MENSUAL(Lr_Punto,
                                                La_ServiciosCumplePromo,
                                                Lr_GruposPromociones,
                                                Lr_GrupoPromoRegla,
                                                Lr_TiposPromociones,
                                                Lr_TipoPromoRegla,
                                                Pv_TipoProceso,
                                                Lv_Trama,
                                                NULL,
                                                Lv_MsjResultado);                                                   
                        ELSE
                        --                                                            
                          Lv_TipoPromocion := 'Promoción Definida';
                          P_MAPEO_PROMO_DEFINIDAS(Pr_Punto                => Lr_Punto,
                                                  Pa_ServiciosCumplePromo => La_ServiciosCumplePromo,
                                                  Pr_GruposPromociones    => Lr_GruposPromociones,
                                                  Pr_GrupoPromoRegla      => Lr_GrupoPromoRegla,
                                                  Pr_TiposPromociones     => Lr_TiposPromociones,
                                                  Pr_TipoPromoRegla       => Lr_TipoPromoRegla,
                                                  Pv_TipoProceso          => Pv_TipoProceso,
                                                  Pv_Trama                => Lv_Trama,
                                                  Pv_CodEmpresa           => Pv_CodEmpresa,
                                                  Pv_MsjResultado         => Lv_MsjResultado);                                                   
                        END IF;
                        --
                        IF Lv_MsjResultado IS NOT NULL THEN
                          --                          
                          Lv_MsjExceptionTipoPromo:= 'No se pudo generar el mapeo Promocional para el ID_PUNTO: '||Lr_Punto.ID_PUNTO||
                                                     ' Grupo Promocional ID_GRUPO_PROMOCION: ' ||Lr_GruposPromociones.ID_GRUPO_PROMOCION||
                                                     ' Tipo Promocional ID_TIPO_PROMOCION: ' ||Lr_TiposPromociones.ID_TIPO_PROMOCION||
                                                     ' ' ||Lv_TipoPromocion||' - ' || Lv_MsjResultado;                                               
                          RAISE Le_ExceptionTipoPromo; 
                          --
                        ELSE
                          Lb_OtorgoPromoCliente:=TRUE;
                        END IF;
                        --
                      END IF;
                    END IF;           
                    --                
                    --Limpiamos la Tabla de Planes y Productos por Tipo Promocional
                    La_TipoPromoPlanProdProcesar.DELETE();             
                    --
                    -- 
                  EXCEPTION
                  WHEN Le_ExceptionTipoPromo THEN

                    Lv_MsjResultado := 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                                        || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionTipoPromo; 
                    Lv_Existe       := '';
                    OPEN C_GetErrorRepetido(Lv_MsjResultado);
                    --
                    FETCH C_GetErrorRepetido INTO Lv_Existe;
                    --
                    IF Lv_Existe <> 'EXISTE' THEN

                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                           'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                                           Lv_MsjResultado,
                                                           'telcos_mapeo_promo',
                                                           SYSDATE,
                                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                    END IF;
                    CLOSE C_GetErrorRepetido;                                      
                    Lv_MsjResultado:=NULL;
                    --
                  WHEN OTHERS THEN
                  --
                    Lv_MsjResultado := 'Ocurrió un error para el Proceso de Mapeo de Promociones para el ID_SERVICIO: ' ||
                                        La_ServiciosCodigo(Ln_ServiciosCodigo).ID_SERVICIO || ' con el tipo promocional: ' ||
                                        La_ServiciosCodigo(Ln_ServiciosCodigo).ID_TIPO_PROMOCION;
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                         'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                         'telcos_mapeo_promo',
                                                         SYSDATE,
                                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                    Lv_MsjResultado := NULL;
                  END;
                  --Fin de Bloque para manejo de excepciones por Tipo Promocional

                END LOOP;--Fin de WHILE (Ln_IndTpro IS NOT NULL) 
                EXIT WHEN Lrf_TiposPromociones%NOTFOUND;
                --
                --
              END LOOP;--Fin Loop 
              CLOSE Lrf_TiposPromociones;                                        
              --  
              --
            EXCEPTION
            WHEN Le_ExceptionGrupoPromo THEN
              Lv_MsjResultado := 'Ocurrió un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                                 || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionGrupoPromo; 

              Lv_Existe       := '';
              OPEN C_GetErrorRepetido(Lv_MsjResultado);
              --
              FETCH C_GetErrorRepetido INTO Lv_Existe;
              --
              IF Lv_Existe <> 'EXISTE' THEN

                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                                     Lv_MsjResultado,
                                                     'telcos_mapeo_promo',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
              END IF;
              CLOSE C_GetErrorRepetido;
              Lv_MsjResultado := NULL;
              --
            WHEN OTHERS THEN
            --
              Lv_MsjResultado := 'Ocurrió un error para el Proceso de Mapeo de Promociones para el ID_SERVICIO: ' ||
                                  La_ServiciosCodigo(Ln_ServiciosCodigo).ID_SERVICIO;
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                                   Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                   'telcos_mapeo_promo',
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
              Lv_MsjResultado := NULL;
            END;
            --Fin de Bloque para manejo de excepciones por Grupo Promocional
            --
          END LOOP;--Fin de WHILE (Ln_IndGpro IS NOT NULL)

          Lr_InfoServicioCaracteristica                     := NULL;
          Lr_InfoServicioCaracteristica.SERVICIO_ID         := La_ServiciosCodigo(Ln_ServiciosCodigo).ID_SERVICIO;
          Lr_InfoServicioCaracteristica.CARACTERISTICA_ID   := La_ServiciosCodigo(Ln_ServiciosCodigo).ID_CARACTERISTICA;
          Lr_InfoServicioCaracteristica.ESTADO              := 'Inactivo';
          Lr_InfoServicioCaracteristica.USR_ULT_MOD         := 'telcos_map_prom';
          Lr_InfoServicioCaracteristica.IP_ULT_MOD          := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion);
          Lr_InfoServicioCaracteristica.FE_ULT_MOD          := SYSDATE;
          DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_UPDATE_CARACTERISTICA_SERV (Lr_InfoServicioCaracteristica, Lv_MsjResultado);

        --
        EXCEPTION
        WHEN Le_ExceptionServicioCod THEN
          Lv_MsjResultado := Lv_MsjExceptionServCod;
          Lv_Existe       := '';
          OPEN C_GetErrorRepetido(Lv_MsjResultado);
          --
          FETCH C_GetErrorRepetido INTO Lv_Existe;
          --
          IF Lv_Existe <> 'EXISTE' THEN
        
             DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                  'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                                  Lv_MsjResultado,
                                                  'telcos_mapeo_promo',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          END IF;
          CLOSE C_GetErrorRepetido;
          Lv_MsjResultado := NULL;
          --
        WHEN OTHERS THEN
        --
          Lv_MsjResultado := 'Ocurrió un error para el Proceso de Mapeo de Promociones para el ID_PUNTO: ' ||Lr_Punto.ID_PUNTO;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                               Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                               'telcos_mapeo_promo',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          Lv_MsjResultado := NULL;
        END;
          Ln_ServiciosCodigo := La_ServiciosCodigo.NEXT(Ln_ServiciosCodigo);
        END LOOP; 
      --
      --
      EXCEPTION
        WHEN Le_ExceptionPunto THEN
          Lv_MsjResultado := 'Ocurrio un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '
                             || Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionPunto; 
          Lv_Existe       := '';
          OPEN C_GetErrorRepetido(Lv_MsjResultado);
          --
          FETCH C_GetErrorRepetido INTO Lv_Existe;
          --
          IF Lv_Existe <> 'EXISTE' THEN

             DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                  'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                                  Lv_MsjResultado,
                                                  'telcos_mapeo_promo',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          END IF;
          CLOSE C_GetErrorRepetido;
          Lv_MsjResultado := NULL;
          --
        WHEN OTHERS THEN
        --
          Lv_MsjResultado := 'Ocurrió un error para el Proceso de Mapeo de Promociones para el ID_PUNTO: ' ||Lr_Punto.ID_PUNTO;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                               Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                               'telcos_mapeo_promo',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          Lv_MsjResultado := NULL;
      END;
      --Fin de Bloque para manejo de excepciones por Punto
      --
      END LOOP;--Fin de WHILE (Ln_Indx IS NOT NULL)
      COMMIT;
      EXIT WHEN Lrf_PuntosProcesar%NOTFOUND;
      --
      --
    END LOOP;-- Fin Loop - End Loop  
    CLOSE Lrf_PuntosProcesar; 
    --

  EXCEPTION
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '||Pv_CodigoGrupoPromocion||
                       ' Tipo Proceso: '||Pv_TipoProceso || ' - ' ||Lv_MsjExceptionProceso; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'MsjeError: Ocurrió un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '||
                       Pv_CodigoGrupoPromocion|| ' Tipo Proceso: '||Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            
  END P_PROMOCIONES_POR_CODIGO;
  --
  --
  --
  PROCEDURE P_SERVICIOS_PROM_CODIGO(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                    Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_TipoProceso          IN VARCHAR2,
                                    Pv_EstadoServicio       IN VARCHAR2,
                                    Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosPromCodigo)
  IS
    
    --Costo:3
    CURSOR C_HoraJobCliNuev(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                            Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                            Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                            Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT APD.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APD.EMPRESA_COD        = Cv_CodEmpresa
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro;

    Lv_EstadoActivo       VARCHAR2(15) := 'Activo';
    Lv_EstadoInactivo     VARCHAR2(15) := 'Inactivo';
    Lv_DescripcionRol     VARCHAR2(15) := 'Cliente';
    Lv_EsVenta            VARCHAR2(1)  := 'S';
    Ln_Frecuencia         NUMBER := 1;  
    Ln_Numero             NUMBER := 0;
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(32000); 
    Lv_Consulta           VARCHAR2(32000);
    Lv_CadenaQuery        VARCHAR2(32000);
    Lv_CadenaFrom         VARCHAR2(32000);
    Lv_CadenaWhere        VARCHAR2(32000);
    Lv_CadenaOrdena       VARCHAR2(32000); 
    Lrf_ServiciosProcesar SYS_REFCURSOR; 
    Lr_Servicios          DB_COMERCIAL.CMKG_PROMOCIONES.Lr_ServiciosPromCodigo; 
    La_ServiciosProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosPromCodigo;  
    Ln_Indice             NUMBER := 1; 
    Ln_Indx               NUMBER;
    Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_HORA_EJECUCION_JOB';
    Lv_Descripcion        DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_HORA_EJECUCION_JOB_CLI_NUEV';
    Lv_Hora               VARCHAR2(10);
    Ld_FechaAnterior      DATE := SYSDATE - 1 ;
    Lv_fechaJob           VARCHAR2(100);
    Lv_CaracteristicaTipoProceso DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;

  BEGIN
 
    IF Pv_TipoProceso = 'NUEVO' THEN
      Lv_CaracteristicaTipoProceso := 'PROM_COD_NUEVO'; 
    ELSE
      Lv_CaracteristicaTipoProceso := 'PROM_COD_EXISTENTE'; 
    END IF;

    --Costo query obtiene servicios cliente Nuevo: 15
    --Costo query obtiene servicios cliente Existente: 14

    Lv_CadenaQuery := ' SELECT DISTINCT
      ISE.ID_SERVICIO,
      IP.ID_PUNTO,       
      ISE.PLAN_ID     AS ID_PLAN,
      ISE.PRODUCTO_ID AS ID_PRODUCTO,  
      NULL            AS PLAN_ID_SUPERIOR,
      ISE.ESTADO      AS ESTADO,
      AGP.ID_GRUPO_PROMOCION,
      DBAC.ID_CARACTERISTICA,
      ATP.CODIGO_TIPO_PROMOCION AS TIPO_PROMOCION,
      ATP.ID_TIPO_PROMOCION ';

    Lv_CadenaFrom := ' FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
        DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR ';

    Lv_CadenaWhere := ' WHERE ISE.CANTIDAD >  :1 
      AND IER.EMPRESA_COD                   = :2 
      AND ISE.ES_VENTA                      = :3 
      AND AR.DESCRIPCION_ROL                = :4 
      AND ISE.PRECIO_VENTA                  > :5 
      AND ISE.FRECUENCIA_PRODUCTO           = :6 
      AND IP.ID_PUNTO                       = :7 
      AND IP.ID_PUNTO                       = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL               = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA                    = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL                = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                         = IER.ROL_ID
      AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PLAN_EMP_PYME(ISE.ID_SERVICIO) = ''S''
      AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(ISE.ID_SERVICIO) = ''S''
      AND DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(ISE.ID_SERVICIO, :8 , :9 )=''S''      
      AND ISC.SERVICIO_ID                   = ISE.ID_SERVICIO
      AND DBAC.DESCRIPCION_CARACTERISTICA   = :10 
      AND ISC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA
      AND ISC.ESTADO                        = :11 
      AND ATPR.CARACTERISTICA_ID            IN (SELECT CARAC.ID_CARACTERISTICA
                                                FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARAC
                                                WHERE CARAC.DESCRIPCION_CARACTERISTICA = ''PROM_CODIGO'') 
      AND ATP.ID_TIPO_PROMOCION             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(TRIM(ISC.VALOR),''^\d+'')),0) 
      AND ATPR.ESTADO                       IN ( :12 , :13 )
      AND AGP.ID_GRUPO_PROMOCION            = ATPR.GRUPO_PROMOCION_ID
      AND ATP.GRUPO_PROMOCION_ID            = AGP.ID_GRUPO_PROMOCION
      AND ATP.ESTADO                        IN ( :14 , :15 )
      AND AGP.EMPRESA_COD                   = :16 ';

    Lv_CadenaOrdena := ' ORDER BY ISE.ID_SERVICIO ASC '; 


    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso = 'NUEVO' THEN   
      --
      IF C_HoraJobCliNuev%ISOPEN THEN
        CLOSE C_HoraJobCliNuev;
      END IF;

      BEGIN
        OPEN C_HoraJobCliNuev(Lv_NombreParametro,
                              Lv_Descripcion,
                              Lv_EstadoActivo,
                              Pv_CodEmpresa);
        FETCH C_HoraJobCliNuev INTO Lv_Hora;
        CLOSE C_HoraJobCliNuev;
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Hora := ' 23:20:00';
      END;

      Lv_fechaJob   := Ld_FechaAnterior || Lv_Hora ;
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ';
      Lv_CadenaWhere:= Lv_CadenaWhere || '
      AND ISE.ID_SERVICIO = ISH.SERVICIO_ID 
      AND ISE.ESTADO ='''||Lv_EstadoActivo||''' 
      AND (UPPER(dbms_lob.substr(ISH.OBSERVACION)) LIKE ''%CONFIRMO%'' 
      OR ISH.ACCION  = ''confirmarServicio'' )
      AND ISH.FE_CREACION                                    >= TO_DATE('''|| Lv_fechaJob ||''',''DD-MM-RRRR HH24:MI:SS'')
      AND ISH.FE_CREACION                                    <= SYSDATE ';   
      --
    ELSIF Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Pv_TipoProceso = 'EXISTENTE'  THEN
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND REGEXP_LIKE(NVL('''||Pv_EstadoServicio||''', '''||Lv_EstadoActivo||'''),ISE.ESTADO)  ';    
      --
    ELSE
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND ISE.ESTADO = '''||Lv_EstadoActivo||''' ';
      --
    END IF;

    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdena;

    Pa_ServiciosProcesar.DELETE();
    
    IF Lrf_ServiciosProcesar%ISOPEN THEN
      CLOSE Lrf_ServiciosProcesar;
    END IF;

    La_ServiciosProcesar.DELETE();
    OPEN Lrf_ServiciosProcesar FOR Lv_Consulta using 
    Ln_Numero,
    Pv_CodEmpresa,
    Lv_EsVenta,
    Lv_DescripcionRol,
    Ln_Numero,
    Ln_Frecuencia,
    Pn_IdPunto,
    Pv_CodigoGrupoPromocion,
    Pv_CodEmpresa,
    Lv_CaracteristicaTipoProceso,
    Lv_EstadoActivo,
    Lv_EstadoActivo,
    Lv_EstadoInactivo,
    Lv_EstadoActivo,
    Lv_EstadoInactivo,
    Pv_CodEmpresa;
    
    LOOP
      FETCH Lrf_ServiciosProcesar BULK COLLECT INTO La_ServiciosProcesar LIMIT 100;       
      Ln_Indx := La_ServiciosProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP  
        Lr_Servicios                                       := La_ServiciosProcesar(Ln_Indx);
        Ln_Indx                                            := La_ServiciosProcesar.NEXT(Ln_Indx);       
        Pa_ServiciosProcesar(Ln_Indice).ID_SERVICIO        := Lr_Servicios.ID_SERVICIO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PUNTO           := Lr_Servicios.ID_PUNTO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PLAN            := Lr_Servicios.ID_PLAN;
        Pa_ServiciosProcesar(Ln_Indice).ID_PRODUCTO        := Lr_Servicios.ID_PRODUCTO;
        Pa_ServiciosProcesar(Ln_Indice).PLAN_ID_SUPERIOR   := Lr_Servicios.PLAN_ID_SUPERIOR;
        Pa_ServiciosProcesar(Ln_Indice).ESTADO             := Lr_Servicios.ESTADO;
        Pa_ServiciosProcesar(Ln_Indice).ID_GRUPO_PROMOCION := Lr_Servicios.ID_GRUPO_PROMOCION;
        Pa_ServiciosProcesar(Ln_Indice).ID_CARACTERISTICA  := Lr_Servicios.ID_CARACTERISTICA;
        Pa_ServiciosProcesar(Ln_Indice).TIPO_PROMOCION     := Lr_Servicios.TIPO_PROMOCION;
        Pa_ServiciosProcesar(Ln_Indice).ID_TIPO_PROMOCION  := Lr_Servicios.ID_TIPO_PROMOCION;
        Ln_Indice                                          := Ln_Indice + 1;
      END LOOP;
      EXIT WHEN Lrf_ServiciosProcesar%NOTFOUND; 
    END LOOP;
    CLOSE Lrf_ServiciosProcesar;      

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrió un error al obtener los servicios del punto cliente con promociones con código para el Proceso de Mapeo de Promociones ' || 
                       'para el Grupo Promocional: '||Pv_CodigoGrupoPromocion||' Tipo Proceso: '||Pv_TipoProceso|| ' ID_PUNTO: '|| Pn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_SERVICIOS_PROM_CODIGO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    Pa_ServiciosProcesar.DELETE();
  END P_SERVICIOS_PROM_CODIGO;
  --
  --
  --
  PROCEDURE P_INSERT_DETALLE_TRASLADO( Pr_InfoDetalleMapeoPromo    IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE,
                                      Pa_DetalleServiciosMapear   IN T_ServiciosMapearTras,
                                      Pv_MsjResultado             OUT VARCHAR2)
  IS
    --
    Lr_InfoDetalleMapeoSolicitud  DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleMapeoHisto      DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lex_Exception                 EXCEPTION;
    Lv_MsjResultado               VARCHAR2(2000);
    Lv_IpCreacion                 VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_Indice                     PLS_INTEGER;
    Lv_UserMapeo                  VARCHAR2(20):='telcos_map_prom';
    --
  BEGIN
    --
    IF Pa_DetalleServiciosMapear.COUNT > 0 THEN
      --
      P_INSERT_INFO_DET_MAPEO_PROMO(Pr_InfoDetalleMapeoPromo, Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      ELSE    
        --   
        Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
        Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Pr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO;
        Lr_InfoDetalleMapeoHisto.FE_CREACION             := Pr_InfoDetalleMapeoPromo.FE_CREACION;
        Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UserMapeo;
        Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
        Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se registró correctamente el mapeo de la Promoción: '
                                                            ||Pr_InfoDetalleMapeoPromo.TIPO_PROMOCION
                                                            ||', Grupo-Promocional: '||Pr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID
                                                            ||', Fecha-Mapeo: '||TO_CHAR(Pr_InfoDetalleMapeoPromo.FE_MAPEO);
        Lr_InfoDetalleMapeoHisto.ESTADO                  := Pr_InfoDetalleMapeoPromo.ESTADO;
        --
        P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_MsjResultado);  
        --
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Lex_Exception;
        END IF;       
        --
        Lr_InfoDetalleMapeoSolicitud.DETALLE_MAPEO_ID    := Pr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO ;
        Lr_InfoDetalleMapeoSolicitud.SOLICITUD_ID        := NULL;
        Lr_InfoDetalleMapeoSolicitud.FE_CREACION         := Pr_InfoDetalleMapeoPromo.FE_CREACION;
        Lr_InfoDetalleMapeoSolicitud.USR_CREACION        := Lv_UserMapeo;
        Lr_InfoDetalleMapeoSolicitud.IP_CREACION         := Lv_IpCreacion;
        Lr_InfoDetalleMapeoSolicitud.FE_ULT_MOD          := NULL;
        Lr_InfoDetalleMapeoSolicitud.USR_ULT_MOD         := NULL;
        Lr_InfoDetalleMapeoSolicitud.IP_ULT_MOD          := NULL;
        --
        Ln_Indice := Pa_DetalleServiciosMapear.FIRST;
        --
        WHILE (Ln_Indice IS NOT NULL)  
        LOOP          
          --
          Lr_InfoDetalleMapeoSolicitud.ID_MAPEO_SOLICITUD   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_SOLICI.NEXTVAL;
          Lr_InfoDetalleMapeoSolicitud.SERVICIO_ID          := Pa_DetalleServiciosMapear(Ln_Indice).ID_SERVICIO;
          Lr_InfoDetalleMapeoSolicitud.PLAN_ID              := Pa_DetalleServiciosMapear(Ln_Indice).ID_PLAN;
          Lr_InfoDetalleMapeoSolicitud.PLAN_ID_SUPERIOR     := Pa_DetalleServiciosMapear(Ln_Indice).PLAN_ID_SUPERIOR;
          Lr_InfoDetalleMapeoSolicitud.PRODUCTO_ID          := Pa_DetalleServiciosMapear(Ln_Indice).ID_PRODUCTO; 
          Lr_InfoDetalleMapeoSolicitud.SOLICITUD_ID         := Pa_DetalleServiciosMapear(Ln_Indice).ID_DETALLE_SOLICITUD; 
          Lr_InfoDetalleMapeoSolicitud.ESTADO               := Pr_InfoDetalleMapeoPromo.ESTADO;
          --
          P_INSERT_INFO_DET_MAPEO_SOLIC(Lr_InfoDetalleMapeoSolicitud, Lv_MsjResultado);
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;       
          --
          Ln_Indice := Pa_DetalleServiciosMapear.NEXT (Ln_Indice);
          --
        END LOOP;
        --      
      END IF;
      --
    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                          'CMKG_PROMOCIONES.P_INSERT_DETALLE_TRASLADO', 
                                          Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          Lv_UserMapeo,
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    --
    Pv_MsjResultado := Lv_MsjResultado;
    --
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                          'CMKG_PROMOCIONES.P_INSERT_DETALLE_TRASLADO', 
                                          Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          Lv_UserMapeo,
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    --
    Pv_MsjResultado := Lv_MsjResultado;
    --
  END P_INSERT_DETALLE_TRASLADO;

  PROCEDURE P_VALIDA_PROM_TRASLADO(Pn_Id_Detalle_Mapeo     IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
                                   Pn_Id_Promocion         IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                   Pn_Id_Tipo_Promocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                   Pv_Tipo_Promocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pn_IntIdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Pb_CumplePromo          OUT BOOLEAN,
                                   Pa_ServiciosMapeados    OUT T_ServiciosProcesar,
                                   Pa_ServiciosProcesar    OUT T_ServiciosProcesar,
                                   Pa_PierdeServiciosPromo OUT T_ServiciosProcesar,
                                   Pb_CumpleEstadoServ     OUT BOOLEAN)
  IS

    --Costo: 4
    CURSOR C_MapeoSolicitud(Cn_Id_Detalle_Mapeo DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE)
    IS   
      SELECT IDMS.SERVICIO_ID,
        IDMP.PUNTO_ID,
        IDMS.PLAN_ID,
        IDMS.PRODUCTO_ID,
        IDMS.PLAN_ID_SUPERIOR,
        ISE.ESTADO AS ESTADO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO  IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
        DB_COMERCIAL.INFO_SERVICIO                ISE
      WHERE ISE.ID_SERVICIO     = IDMS.SERVICIO_ID
      AND IDMS.ESTADO           != 'Baja'
      AND IDMS.DETALLE_MAPEO_ID = IDMP.ID_DETALLE_MAPEO
      AND IDMP.ID_DETALLE_MAPEO = Cn_Id_Detalle_Mapeo;

    --Costo: 4  
    CURSOR C_ServiciosPunto(Cv_Empresa VARCHAR2,
                            Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cv_Estado  VARCHAR2)
    IS   
      SELECT ISE.ID_SERVICIO,
        IP.ID_PUNTO,       
        ISE.PLAN_ID     AS ID_PLAN,
        ISE.PRODUCTO_ID AS ID_PRODUCTO,  
        NULL            AS PLAN_ID_SUPERIOR,
        ISE.ESTADO      AS ESTADO 
      FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR
      WHERE ISE.CANTIDAD            > 0
      AND IER.EMPRESA_COD           = Cv_Empresa
      AND ISE.ES_VENTA              = 'S'
      AND AR.DESCRIPCION_ROL        = 'Cliente'
      AND ISE.PRECIO_VENTA          > 0
      AND ISE.FRECUENCIA_PRODUCTO   = 1      
      AND IP.ID_PUNTO               = Cn_IdPunto	  
      AND IP.ID_PUNTO               = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL       = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA            = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL        = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                 = IER.ROL_ID
      AND ISE.ESTADO                = 'Trasladado'
      AND EXISTS  (SELECT 1
                  FROM DB_COMERCIAL.INFO_SERVICIO SERV, --ISE
                  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC,
                  DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                  DB_COMERCIAL.ADMI_PRODUCTO APR,
                  DB_COMERCIAL.ADMI_CARACTERISTICA ACT
                  WHERE SERV.ID_SERVICIO = SPC.SERVICIO_ID
                  AND SPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
                  AND APC.PRODUCTO_ID = APR.ID_PRODUCTO
                  AND APC.CARACTERISTICA_ID = ACT.ID_CARACTERISTICA
                  AND APR.EMPRESA_COD = Cv_Empresa
                  AND APR.NOMBRE_TECNICO = 'INTERNET'
                  AND APR.ESTADO = 'Activo'
                  AND ACT.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
                  AND ACT.ESTADO = 'Activo'
                  AND SPC.ESTADO IN ('Activo', 'Eliminado')
                  AND SERV.ESTADO         = 'Activo'
                  AND VALOR = TO_CHAR(ISE.ID_SERVICIO)
                  )
      ORDER BY ISE.ID_SERVICIO ASC;
      
      
     --Costo: 1
    CURSOR C_GetEmpresa ( Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)                    
    IS
      SELECT IEG.COD_EMPRESA
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE IEG.prefijo= DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(Cn_IdPunto,NULL);

    Lr_GrupoPromoRegla     Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla      Lr_TipoPromoReglaProcesar;
    Lv_TipoPromocion       DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
    Lv_IpCreacion          VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado        VARCHAR2(2000);
    Lv_EstadoServicio      VARCHAR2(20);
    Ln_CumpleServicio      NUMBER := 0;
    Ln_Contador            NUMBER := 0;
    Ln_Ind                 NUMBER := 1;
    Ln_Ind1                NUMBER;
    Ln_Ind2                NUMBER := 1;
    Ln_Ind3                NUMBER := 1;
    Lb_CumpleMplaMpro      BOOLEAN;
    Lb_CumpleEstadoServ    BOOLEAN := FALSE;
    Lv_CodEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  BEGIN
    --
    IF C_GetEmpresa%ISOPEN THEN
    --
      CLOSE C_GetEmpresa;
    --
    END IF;
    --
    OPEN C_GetEmpresa(Pn_IntIdPunto);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;
    
    --Verifico que los Planes y Productos definidos por Tipo Promocional se encuentren como servicios en el Punto para poder 
    --otorgar la promoción.   
    Pa_ServiciosMapeados.DELETE();
    Pa_ServiciosProcesar.DELETE();
    Pa_PierdeServiciosPromo.DELETE();
    --Obtengo los servicios a procesar por punto.
    IF Pv_Tipo_Promocion IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_TOT') THEN
      Lv_TipoPromocion   := 'PROM_MENS';
      Lr_GrupoPromoRegla := F_GET_PROMO_GRUPO_REGLA(Pn_Id_Promocion);  
      Lv_EstadoServicio  := Lr_GrupoPromoRegla.PROM_ESTADO_SERVICIO;
      
      FOR Lc_Mapeo_Solicitud IN C_MapeoSolicitud(Pn_Id_Detalle_Mapeo)
      LOOP
      --
        Pa_ServiciosMapeados(Ln_Ind).ID_SERVICIO      := Lc_Mapeo_Solicitud.SERVICIO_ID;
        Pa_ServiciosMapeados(Ln_Ind).ID_PUNTO         := Lc_Mapeo_Solicitud.PUNTO_ID;
        Pa_ServiciosMapeados(Ln_Ind).ID_PLAN          := Lc_Mapeo_Solicitud.PLAN_ID;
        Pa_ServiciosMapeados(Ln_Ind).ID_PRODUCTO      := Lc_Mapeo_Solicitud.PRODUCTO_ID;
        Pa_ServiciosMapeados(Ln_Ind).PLAN_ID_SUPERIOR := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
        Pa_ServiciosMapeados(Ln_Ind).ESTADO           := Lc_Mapeo_Solicitud.ESTADO;
        Ln_Ind                                        := Ln_Ind + 1;
      --
      END LOOP;
  
      IF Pv_Tipo_Promocion = 'PROM_TOT' THEN
      --
        FOR Lc_ServiciosPunto IN C_ServiciosPunto(Lv_CodEmpresa,
                                                  Pn_IntIdPunto,
                                                  Lv_EstadoServicio)
        LOOP
        --
          Pa_ServiciosProcesar(Ln_Ind2).ID_SERVICIO      := Lc_ServiciosPunto.ID_SERVICIO;
          Pa_ServiciosProcesar(Ln_Ind2).ID_PUNTO         := Lc_ServiciosPunto.ID_PUNTO;
          Pa_ServiciosProcesar(Ln_Ind2).ID_PLAN          := Lc_ServiciosPunto.ID_PLAN;
          Pa_ServiciosProcesar(Ln_Ind2).ID_PRODUCTO      := Lc_ServiciosPunto.ID_PRODUCTO;
          Pa_ServiciosProcesar(Ln_Ind2).PLAN_ID_SUPERIOR := Lc_ServiciosPunto.PLAN_ID_SUPERIOR;
          Pa_ServiciosProcesar(Ln_Ind2).ESTADO           := Lc_ServiciosPunto.ESTADO;
          Ln_Ind2                                        := Ln_Ind2 + 1;
        --  
        END LOOP;
      --
      ELSE
      --
        IF Pa_ServiciosMapeados.COUNT > 0 THEN 
        --
          Ln_Ind1 := Pa_ServiciosMapeados.FIRST;   
          WHILE (Ln_Ind1 IS NOT NULL)   
          LOOP
          --
            Ln_Contador := Ln_Contador + 1;
            FOR Lc_ServiciosPunto IN C_ServiciosPunto(Lv_CodEmpresa,
                                                      Pa_ServiciosMapeados(Ln_Ind1).ID_PUNTO,
                                                      Lv_EstadoServicio)
            LOOP
            --
              Lb_CumpleEstadoServ:= TRUE;    
              Lb_CumpleMplaMpro  := FALSE;
              IF (Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN IS NOT NULL
                  AND Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO = Lc_ServiciosPunto.ID_SERVICIO
                  AND Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN = Lc_ServiciosPunto.ID_PLAN) OR 
                 (Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO IS NOT NULL 
                  AND Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO = Lc_ServiciosPunto.ID_SERVICIO
                  AND Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO = Lc_ServiciosPunto.ID_PRODUCTO) THEN
              --
                Ln_CumpleServicio := Ln_CumpleServicio + 1;
                Lb_CumpleMplaMpro := TRUE;           
              --         
              END IF;
              IF Lb_CumpleMplaMpro THEN
              --
                Pa_ServiciosProcesar(Ln_Ind2).ID_SERVICIO      := Lc_ServiciosPunto.ID_SERVICIO;
                Pa_ServiciosProcesar(Ln_Ind2).ID_PUNTO         := Lc_ServiciosPunto.ID_PUNTO;
                Pa_ServiciosProcesar(Ln_Ind2).ID_PLAN          := Lc_ServiciosPunto.ID_PLAN;
                Pa_ServiciosProcesar(Ln_Ind2).ID_PRODUCTO      := Lc_ServiciosPunto.ID_PRODUCTO;
                Pa_ServiciosProcesar(Ln_Ind2).PLAN_ID_SUPERIOR := Lc_ServiciosPunto.PLAN_ID_SUPERIOR;
                Pa_ServiciosProcesar(Ln_Ind2).ESTADO           := Lc_ServiciosPunto.ESTADO;
                Ln_Ind2                                        := Ln_Ind2 + 1;
              --
              END IF;
            --  
            END LOOP;
            IF Ln_CumpleServicio = 0 THEN
              Pa_PierdeServiciosPromo(Ln_Ind3).ID_SERVICIO      := Pa_ServiciosMapeados(Ln_Ind1).ID_SERVICIO;
              Pa_PierdeServiciosPromo(Ln_Ind3).ID_PUNTO         := Pa_ServiciosMapeados(Ln_Ind1).ID_PUNTO;
              Pa_PierdeServiciosPromo(Ln_Ind3).ID_PLAN          := Pa_ServiciosMapeados(Ln_Ind1).ID_PLAN;
              Pa_PierdeServiciosPromo(Ln_Ind3).ID_PRODUCTO      := Pa_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO;
              Pa_PierdeServiciosPromo(Ln_Ind3).PLAN_ID_SUPERIOR := Pa_ServiciosMapeados(Ln_Ind1).PLAN_ID_SUPERIOR;
              Pa_PierdeServiciosPromo(Ln_Ind3).ESTADO           := Pa_ServiciosMapeados(Ln_Ind1).ESTADO;
              Ln_Ind3                                           := Ln_Ind3 + 1;
            END IF;
            Ln_CumpleServicio := 0;
            Ln_Ind1           := Pa_ServiciosMapeados.NEXT(Ln_Ind1);
          --
          END LOOP;
        --
        END IF;
      --
      END IF;
     
      Pb_CumpleEstadoServ := Lb_CumpleEstadoServ;
      IF Ln_Contador = 0 AND Pv_Tipo_Promocion != 'PROM_TOT' THEN
        Pb_CumplePromo := FALSE;
      ELSE
        IF Pa_ServiciosProcesar.COUNT != Pa_ServiciosMapeados.COUNT AND
           Pv_Tipo_Promocion != 'PROM_TOT' THEN
           Pb_CumplePromo := FALSE;
        ELSE 
          Pb_CumplePromo := TRUE;
        END IF;
      END IF;
    ELSE
        Pb_CumplePromo := FALSE;
    END IF;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Pa_ServiciosProcesar.DELETE();
    Pb_CumplePromo := FALSE;
    Ln_Ind         := 1;
    Pa_ServiciosMapeados.DELETE();
    FOR Lc_Mapeo_Solicitud IN C_MapeoSolicitud(Pn_Id_Detalle_Mapeo)
    LOOP
    --
      Pa_ServiciosMapeados(Ln_Ind).ID_SERVICIO         := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PUNTO            := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PLAN             := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_ServiciosMapeados(Ln_Ind).ID_PRODUCTO         := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_ServiciosMapeados(Ln_Ind).PLAN_ID_SUPERIOR    := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_ServiciosMapeados(Ln_Ind).ESTADO              := Lc_Mapeo_Solicitud.ESTADO;

      Pa_ServiciosProcesar(Ln_Ind).ID_SERVICIO         := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_ServiciosProcesar(Ln_Ind).ID_PUNTO            := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_ServiciosProcesar(Ln_Ind).ID_PLAN             := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_ServiciosProcesar(Ln_Ind).ID_PRODUCTO         := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_ServiciosProcesar(Ln_Ind).PLAN_ID_SUPERIOR    := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_ServiciosProcesar(Ln_Ind).ESTADO              := Lc_Mapeo_Solicitud.ESTADO;

      Pa_PierdeServiciosPromo(Ln_Ind).ID_SERVICIO      := Lc_Mapeo_Solicitud.SERVICIO_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).ID_PUNTO         := Lc_Mapeo_Solicitud.PUNTO_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).ID_PLAN          := Lc_Mapeo_Solicitud.PLAN_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).ID_PRODUCTO      := Lc_Mapeo_Solicitud.PRODUCTO_ID;
      Pa_PierdeServiciosPromo(Ln_Ind).PLAN_ID_SUPERIOR := Lc_Mapeo_Solicitud.PLAN_ID_SUPERIOR;
      Pa_PierdeServiciosPromo(Ln_Ind).ESTADO           := Lc_Mapeo_Solicitud.ESTADO;

      Ln_Ind:=Ln_Ind + 1;
    --
    END LOOP;
    Lv_MsjResultado := 'Ocurrió un error al validar en traslado la Regla de Planes y Producto del GRUPO_PROMOCION : '
                        || Pn_Id_Promocion || ' - ' || Pv_Tipo_Promocion || ' para el ID_PUNTO: ' || Pn_IntIdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_VALIDA_PROM_TRASLADO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));                   
  END P_VALIDA_PROM_TRASLADO;
  --
  --
  --
  PROCEDURE P_TRASLADA_PROMO_MAPEO (Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pn_IdPuntoDestino        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pv_RespuestaProceso      OUT VARCHAR2,
                                    Pv_TrasladoPromo         OUT VARCHAR2)
  IS 

    CURSOR C_ServiciosPunto(Cv_Empresa VARCHAR2,
                            Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS   
      SELECT ISE.ID_SERVICIO,
        IP.ID_PUNTO,       
        ISE.PLAN_ID     AS ID_PLAN,
        ISE.PRODUCTO_ID AS ID_PRODUCTO,  
        NULL            AS PLAN_ID_SUPERIOR,
        ISE.ESTADO      AS ESTADO 
      FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR
      WHERE ISE.CANTIDAD            > 0
      AND IER.EMPRESA_COD           = Cv_Empresa
      AND ISE.ES_VENTA              = 'S'
      AND AR.DESCRIPCION_ROL        = 'Cliente'
      AND ISE.PRECIO_VENTA          > 0
      AND ISE.FRECUENCIA_PRODUCTO   = 1      
      AND IP.ID_PUNTO               = Cn_IdPunto	  
      AND IP.ID_PUNTO               = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL       = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA            = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL        = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                 = IER.ROL_ID
      AND ISE.ESTADO                = 'Trasladado'
      AND EXISTS  (SELECT 1
                  FROM DB_COMERCIAL.INFO_SERVICIO SERV,
                  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC,
                  DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                  DB_COMERCIAL.ADMI_PRODUCTO APR,
                  DB_COMERCIAL.ADMI_CARACTERISTICA ACT
                  WHERE SERV.ID_SERVICIO = SPC.SERVICIO_ID
                  AND SPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
                  AND APC.PRODUCTO_ID = APR.ID_PRODUCTO
                  AND APC.CARACTERISTICA_ID = ACT.ID_CARACTERISTICA
                  AND APR.EMPRESA_COD = Cv_Empresa
                  AND APR.NOMBRE_TECNICO = 'INTERNET'
                  AND APR.ESTADO = 'Activo'
                  AND ACT.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
                  AND ACT.ESTADO = 'Activo'
                  AND SPC.ESTADO IN ('Activo', 'Eliminado')
                  AND SERV.ESTADO         = 'Activo'
                  AND VALOR = TO_CHAR(ISE.ID_SERVICIO)
                  )
      ORDER BY ISE.ID_SERVICIO ASC;

    CURSOR C_ServicioDestino (Cn_IdServicioOrigen DB_COMERCIAL.Info_Servicio.ID_SERVICIO%TYPE,
                              Cv_CodEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT SERV.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO SERV,
      DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC,
      DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
      DB_COMERCIAL.ADMI_PRODUCTO APR,
      DB_COMERCIAL.ADMI_CARACTERISTICA ACT
      WHERE SERV.ID_SERVICIO = SPC.SERVICIO_ID
      AND SPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID = APR.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID = ACT.ID_CARACTERISTICA
      AND APR.EMPRESA_COD = Cv_CodEmpresa
      AND APR.NOMBRE_TECNICO = 'INTERNET'
      AND APR.ESTADO = 'Activo'
      AND ACT.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
      AND ACT.ESTADO = 'Activo'
      AND SPC.ESTADO IN ('Activo', 'Eliminado')
      AND SERV.ESTADO         = 'Activo'
      AND VALOR = TO_CHAR(Cn_IdServicioOrigen);
      
    Lv_TipoPromo       DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE := 'PROM_MENS';
    Lv_EstadoPromocion DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE;
    Lv_IpCreacion      VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_ServicioDestino NUMBER;
    Lv_msj             VARCHAR2(32000);
  
  BEGIN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                         'Inicia el proceso CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO : ' ||
                                         ' para el ID_PUNTO: '||Pn_IdPunto, 
                                         'telcos_mapeo_traslado',
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    --
    FOR Lc_ServiciosPunto IN C_ServiciosPunto(Pv_Empresa,
                                              Pn_IdPunto)
    LOOP
    --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                           'Antes del consumo de la funcion CMKG_PROMOCIONES.F_VALIDA_SERVICIO ' ||
                                           'para el ID_SERVICIO: '||Lc_ServiciosPunto.ID_SERVICIO, 
                                           'telcos_mapeo_traslado',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      --
      IF DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Lc_ServiciosPunto.ID_SERVICIO,Lv_TipoPromo,Pv_Empresa) = 'N' THEN
      --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                             'Antes del consumo de la funcion CMKG_PROMOCIONES_UTIL.F_OTIENE_ESTADO_PROMOCION ' ||
                                             'para el ID_SERVICIO: '||Lc_ServiciosPunto.ID_SERVICIO, 
                                             'telcos_mapeo_traslado',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        --
        OPEN C_ServicioDestino(Lc_ServiciosPunto.ID_SERVICIO,Pv_Empresa);
        FETCH C_ServicioDestino INTO Ln_ServicioDestino;
        CLOSE C_ServicioDestino;
        --
        IF DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Ln_ServicioDestino,Lv_TipoPromo,Pv_Empresa) = 'S' THEN
        --
          Lv_EstadoPromocion := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_OTIENE_ESTADO_PROMOCION(Fn_IntIdServicio  => Lc_ServiciosPunto.ID_SERVICIO,
                                                                                             Fv_GrupoPromocion => Lv_TipoPromo,
                                                                                             Fv_CodEmpresa     => Pv_Empresa);
          --
          IF Lv_EstadoPromocion IS NOT NULL AND Lv_EstadoPromocion != 'Baja' THEN                                                                                    
          --                                                          
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                                 'Se valida el estado del ultimo mapeo de la promocion vigente: ' ||
                                                 ' Estado: ' || Lv_EstadoPromocion||', ID_SERVICIO: '||Lc_ServiciosPunto.ID_SERVICIO, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            DB_COMERCIAL.CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO(Pv_Empresa          => Pv_Empresa,
                                                                 Pn_IdPunto          => Pn_IdPunto,
                                                                 Pn_IdServicio       => Lc_ServiciosPunto.ID_SERVICIO,
                                                                 Pv_Estado           => Lv_EstadoPromocion,
                                                                 Pn_IdPuntoDestino   => Pn_IdPuntoDestino,
                                                                 Pv_RespuestaProceso => Pv_RespuestaProceso,
                                                                 Pv_TrasladoPromo    => Pv_TrasladoPromo);
        --
        ELSE
        --                                                          
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                               'Se valida el estado del ultimo mapeo de la promocion vigente: ' ||
                                               ' Estado: ' || Lv_EstadoPromocion||', ID_SERVICIO: '||Lc_ServiciosPunto.ID_SERVICIO, 
                                               'telcos_mapeo_traslado',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        --
        END IF;
        --
        ELSE
        --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                               'El servicio destino ya cuenta con promoción: ' ||
                                               ' ID_SERVICIO: '||Lc_ServiciosPunto.ID_SERVICIO
                                               || ', ID_SERVICIO_DESTINO: '||Ln_ServicioDestino, 
                                               'telcos_mapeo_traslado',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        --                                        
        END IF;
      --
      END IF;
    --  
    END LOOP;

  EXCEPTION
  WHEN OTHERS THEN
    Pv_TrasladoPromo := 'ERROR';
    Lv_msj := 'Ocurrió un error al ejecutar el script de traslado de promociones.'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_TRASLADA_PROMO_MAPEO', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
  END P_TRASLADA_PROMO_MAPEO;
  --
  --
  --
  PROCEDURE P_PROMO_MAPEO_TRASLADO (Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                    Pv_Estado                IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE DEFAULT NULL,
                                    Pn_IdPuntoDestino        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pv_RespuestaProceso      OUT VARCHAR2,
                                    Pv_TrasladoPromo         OUT VARCHAR2)
  IS 

    --Costo: 16
    CURSOR C_ServicioActivo (Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS 
      SELECT COUNT(*) AS VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP 
      WHERE AP.CODIGO_PRODUCTO = 'INTD'
        AND AP.ID_PRODUCTO     = IPD.PRODUCTO_ID
        AND IPD.PLAN_ID        = ISER.PLAN_ID
        AND UPPER(ISER.ESTADO) IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                      AND APD.ESTADO           = 'Activo'
                                      AND APD.EMPRESA_COD      = Cv_CodEmpresa
                                      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                      AND APC.ESTADO           = 'Activo')
        AND ISER.PUNTO_ID   = Cn_IdPunto;

    CURSOR C_SolicitudAprobado (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, Cn_IdDetalleMapeo DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE)
    IS
    SELECT IDS.ID_DETALLE_SOLICITUD
    FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DMP, DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD DMS, DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
    WHERE  DMP.ID_DETALLE_MAPEO = DMS.DETALLE_MAPEO_ID
    AND DMS.SOLICITUD_ID = IDS.ID_DETALLE_SOLICITUD
    AND DMP.ID_DETALLE_MAPEO = Cn_IdDetalleMapeo
    AND DMS.SERVICIO_ID = Cn_IdServicio
    AND IDS.ESTADO = 'Aprobado';
    
    --Costo: 13  
    CURSOR C_ServicioDestino (Cn_IdServicioOrigen DB_COMERCIAL.Info_Servicio.ID_SERVICIO%TYPE,
                              Cv_CodEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT SERV.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO SERV,
      DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC,
      DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
      DB_COMERCIAL.ADMI_PRODUCTO APR,
      DB_COMERCIAL.ADMI_CARACTERISTICA ACT
      WHERE SERV.ID_SERVICIO = SPC.SERVICIO_ID
      AND SPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID = APR.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID = ACT.ID_CARACTERISTICA
      AND APR.EMPRESA_COD = Cv_CodEmpresa
      AND APR.NOMBRE_TECNICO = 'INTERNET'
      AND APR.ESTADO = 'Activo'
      AND ACT.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
      AND ACT.ESTADO = 'Activo'
      AND SPC.ESTADO IN ('Activo', 'Eliminado')
      AND SERV.ESTADO         = 'Activo'
      AND VALOR = TO_CHAR(Cn_IdServicioOrigen);
      
    --Costo: 1        
    CURSOR C_TipoPromocion (Cn_Id_Tipo_Promocion NUMBER)
    IS
      SELECT UPPER(TRIM(ATP.ESTADO)) AS ESTADO
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP 
      WHERE ATP.ID_TIPO_PROMOCION = Cn_Id_Tipo_Promocion;

    --Costo: 2        
    CURSOR C_Id_Detalle_Mapeo (Cn_Id_Promocion      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Cn_Id_Persona_rol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                               Cn_Id_Punto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Cn_Id_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                               Cn_Id_Mapeo          DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
                               Cn_Id_Servicio       DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IDMP.ID_DETALLE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
      WHERE IDMP.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
        AND IDMP.PERSONA_EMPRESA_ROL_ID = Cn_Id_Persona_rol
        AND IDMP.PUNTO_ID               = Cn_Id_Punto
        AND IDMP.TIPO_PROMOCION_ID      = Cn_Id_Tipo_Promocion
        AND IDMP.ID_DETALLE_MAPEO       > = Cn_Id_Mapeo
        AND IDMP.ID_DETALLE_MAPEO       = IDMS.DETALLE_MAPEO_ID 
        AND IDMS.SERVICIO_ID            = Cn_Id_Servicio
        ORDER BY IDMP.ID_DETALLE_MAPEO ASC;

    --Cosot: 16
    CURSOR C_ServicioAnulado (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT COUNT(*) AS VALOR
      FROM  DB_COMERCIAL.INFO_SERVICIO ISERV
      WHERE UPPER(ISERV.ESTADO) IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                    AND APD.ESTADO           = 'Activo'
                                    AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_BAJA_SERV'
                                    AND APD.EMPRESA_COD      = Cv_CodEmpresa
                                    AND APC.ESTADO           = 'Activo')                          
       AND ISERV.ID_SERVICIO         = Cn_IdServicio;

    Lc_Tipo_Promocion         C_TipoPromocion%ROWTYPE;
    Lr_InfoDetalleMapeoHisto  DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lr_GrupoPromoRegla        Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla         Lr_TipoPromoReglaProcesar;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    Lr_InfoDetMapSolicitud    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE; 
    Ln_IntIdPromocion         DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Ln_IntIdTipoPromocion     DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    Ln_IntIdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_IdPersonaRol           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
    Ln_Id_Detalle_Mapeo       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE;
    La_SectorizacionProcesar  T_SectorizacionProcesar;
    La_ClientesProcesar       T_ClientesMapeoTras;
    La_ClientesProcesarAll    T_ClientesMapeoTras;
    La_ServiciosMapeados      T_ServiciosProcesar;
    La_ServiciosProcesar      T_ServiciosProcesar;
    La_ServiciosPerdidos      T_ServiciosProcesar;
    La_ServiciosDetalle       T_ServiciosMapear;
    La_ServiciosDetNoActivo   T_ServiciosMapearTras;
    Lb_AplicaMapeo            BOOLEAN;
    Ln_ServicioActivo         NUMBER;
    Ln_ServicioDestino        NUMBER;
    Ln_ServicioAnulado        NUMBER;
    Lv_Status                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE;
    Lv_EstadoActivo           DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE := 'Activo'; 
    Ln_Indx                   NUMBER;
    Ln_IndxAll                NUMBER;
    Ln_Ind1                   NUMBER;
    Ln_Contador               NUMBER;
    Ln_ServiciosPerdidos      NUMBER;
    Ln_Id_Servicio            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_msj                    VARCHAR2(32000);
    Lv_Observacion            VARCHAR2(32000);
    Lv_Trama                  VARCHAR2(4000);
    Lv_ObservacionPromo       VARCHAR2(4000);
    Lv_NombrePromo            VARCHAR2(500);
    Le_ActualizaMapeo         EXCEPTION;
    Le_Exception              EXCEPTION;
    Lr_ParametrosValidarSec   DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;  
    --
    Lv_CaractCicloFact        VARCHAR2(20)   :='CICLO_FACTURACION';
    Lv_Consulta               VARCHAR2(4000);
    Lv_ConsultaAll            VARCHAR2(4000);
    Lv_CadenaRnQuery          VARCHAR2(4000);
    Lv_CadenaQuery            VARCHAR2(4000);
    Lv_CadenaFrom             VARCHAR2(3000);
    Lv_CadenaWhere            VARCHAR2(3000);
    Lv_CadenaNoActivoWhere    VARCHAR2(3000);
    Lv_CadenaOrdena           VARCHAR2(1000);
    Lv_CadenaOrdenaAll        VARCHAR2(1000);
    Lv_CadenaFinRn            VARCHAR2(1000);
    Lv_TieneSolicitud         VARCHAR2(1);
    Lc_Trama                  CLOB;
    Lrf_ClientesMapeo         SYS_REFCURSOR;  
    Lrf_ClientesMapeoAll      SYS_REFCURSOR;  
    Lb_CumpleEstadoServ       BOOLEAN;
    Ln_DiasRestar             NUMBER          :=1;
    Ln_PromosPendientes       NUMBER          :=0;
    Ln_PromosAplicadas        NUMBER          :=0;
    Ln_IdDetalleSolicitud     NUMBER          :=0;
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_TipoPromo              DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE := 'PROM_MENS';
    Lr_InfoDetalleSolHist     DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
  BEGIN
  --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                         'Empieza la ejecución del proceso P_PROMO_MAPEO_TRASLADO: ' ||
                                         ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                         ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                         'telcos_mapeo_traslado',
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    --
    Pv_RespuestaProceso := 'NO_REGISTRA_PROMO';
    Pv_TrasladoPromo    := 'NO_REGISTRA_PROMO';
    Lv_CadenaRnQuery := 'select * from ( ';
    Lv_CadenaQuery:= 'SELECT DISTINCT IDMP.ID_DETALLE_MAPEO,
        AGP.NOMBRE_GRUPO,
        IDMP.GRUPO_PROMOCION_ID,
        IDMP.TIPO_PROMOCION_ID,
        IDMP.PERSONA_EMPRESA_ROL_ID,
        IDMP.PUNTO_ID,
        IDMP.TIPO_PROMOCION,
        IDMP.INDEFINIDO,
        IDMP.FE_MAPEO,
        TO_CHAR(IDMP.TRAMA) TRAMA,
        IDMP.PERIODO,
        IDMP.FE_SIGUIENTE_MAPEO,
        IDMP.CANTIDAD_PERIODOS,
        IDMP.MAPEOS_GENERADOS,
        IDMP.PORCENTAJE,
        IDMP.TIPO_PROCESO,
        IDMP.INVALIDA,
        IDMP.ESTADO,
        (SELECT MAX(IDMS.SERVICIO_ID) AS SERVICIO_ID 
         FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS 
         WHERE IDMS.DETALLE_MAPEO_ID = IDMP.ID_DETALLE_MAPEO) AS SERVICIO_ID ';
         
    Lv_CadenaFrom:= ' FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                      DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS 
                      , DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP';

    Lv_CadenaWhere:=' WHERE  IDMP.EMPRESA_COD                 = '''||Pv_Empresa||'''
        AND IDMP.ESTADO                      = '''||Pv_Estado||'''
        AND IDMS.DETALLE_MAPEO_ID            = IDMP.ID_DETALLE_MAPEO
        AND IDMP.GRUPO_PROMOCION_ID          = AGP.ID_GRUPO_PROMOCION
        AND IDMS.ESTADO                      = '''||Pv_Estado||'''
        AND IDMP.TIPO_PROMOCION              IN (SELECT DET.VALOR2 
                                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                   DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                 WHERE CAB.NOMBRE_PARAMETRO = ''PROM_TIPO_PROMOCIONES''
                                                 AND CAB.ESTADO             = '''||Lv_EstadoActivo||'''
                                                 AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                 AND DET.EMPRESA_COD        = '''||Pv_Empresa||'''
                                                 AND DET.VALOR3             = '''||Lv_TipoPromo||'''
                                                 AND DET.ESTADO             = '''||Lv_EstadoActivo||''') '; 
                                                 
    Lv_CadenaNoActivoWhere:=' WHERE  IDMP.EMPRESA_COD                 = '''||Pv_Empresa||'''
        AND IDMP.ESTADO                      != '''||Pv_Estado||'''
        AND IDMS.DETALLE_MAPEO_ID            = IDMP.ID_DETALLE_MAPEO
        AND IDMP.GRUPO_PROMOCION_ID          = AGP.ID_GRUPO_PROMOCION
        AND IDMS.ESTADO                      != '''||Pv_Estado||'''
        AND IDMP.TIPO_PROMOCION              IN (SELECT DET.VALOR2 
                                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                   DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                 WHERE CAB.NOMBRE_PARAMETRO = ''PROM_TIPO_PROMOCIONES''
                                                 AND CAB.ESTADO             = '''||Lv_EstadoActivo||'''
                                                 AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                 AND DET.EMPRESA_COD        = '''||Pv_Empresa||'''
                                                 AND DET.VALOR3             = '''||Lv_TipoPromo||'''
                                                 AND DET.ESTADO             = '''||Lv_EstadoActivo||''') '; 

    Lv_CadenaOrdena:= ' ORDER BY IDMP.ID_DETALLE_MAPEO DESC ';
    Lv_CadenaOrdenaAll:= ' ORDER BY IDMP.ID_DETALLE_MAPEO ASC ';
    Lv_CadenaFinRn := ') where rownum<=1';
    --
    IF Pn_IdPunto IS NOT NULL THEN
       Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.PUNTO_ID ='''||Pn_IdPunto||''' ';
       Lv_CadenaNoActivoWhere:= Lv_CadenaNoActivoWhere || ' AND IDMP.PUNTO_ID ='''||Pn_IdPunto||''' ';
          
    END IF;
    --
    IF Pn_IdServicio IS NOT NULL THEN
       Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMS.SERVICIO_ID ='''||Pn_IdServicio||''' ';
       Lv_CadenaNoActivoWhere:= Lv_CadenaNoActivoWhere || ' AND IDMS.SERVICIO_ID ='''||Pn_IdServicio||''' ';
    END IF;
    --
    Lv_Consulta := Lv_CadenaRnQuery || Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdena || Lv_CadenaFinRn;    
    IF Lrf_ClientesMapeo%ISOPEN THEN
      CLOSE Lrf_ClientesMapeo;
    END IF;

    IF C_TipoPromocion%ISOPEN THEN
      CLOSE C_TipoPromocion;
    END IF;

    IF C_ServicioActivo%ISOPEN THEN
      CLOSE C_ServicioActivo;
    END IF;
    
    IF C_ServicioDestino%ISOPEN THEN
      CLOSE C_ServicioDestino;
    END IF;

    IF C_ServicioAnulado%ISOPEN THEN
      CLOSE C_ServicioAnulado;
    END IF;

    OPEN Lrf_ClientesMapeo FOR Lv_Consulta;
    LOOP
      FETCH Lrf_ClientesMapeo BULK COLLECT    
      INTO La_ClientesProcesar LIMIT 1000;
      EXIT WHEN La_ClientesProcesar.count = 0;
      Ln_Indx := La_ClientesProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)
      LOOP
        BEGIN
          Pv_RespuestaProceso := 'REGISTRA_PROMO';
          --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                               'Antes del consumo P_VALIDA_PROM_TRASLADO: ' ||
                                               ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                               ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado||
                                               ', Pn_IdPuntoDestino: '||Pn_IdPuntoDestino, 
                                               'telcos_mapeo_traslado',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          --
          P_VALIDA_PROM_TRASLADO(La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO,
                                 La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                 La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID,
                                 La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                 La_ClientesProcesar(Ln_Indx).PUNTO_ID,
                                 Lb_AplicaMapeo,
                                 La_ServiciosMapeados,
                                 La_ServiciosProcesar,
                                 La_ServiciosPerdidos,
                                 Lb_CumpleEstadoServ);

          OPEN C_ServicioActivo(Pn_IdPuntoDestino,Pv_Empresa);
          FETCH C_ServicioActivo INTO Ln_ServicioActivo;
          CLOSE C_ServicioActivo;

          IF Ln_ServicioActivo = 0 THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: '
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ', actualmente el servicio no se encuentra en un estado Activo.';
            Lv_Status             := 'Baja';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'El servicio no se encuentra en un estado Activo: ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            RAISE Le_ActualizaMapeo;
          END IF;
          OPEN C_TipoPromocion(La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID);
          FETCH C_TipoPromocion INTO Lc_Tipo_Promocion;
          CLOSE C_TipoPromocion;
          IF Lc_Tipo_Promocion.ESTADO = 'BAJA' THEN

            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' por estado actual "Baja" del Tipo de Promoción.';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'Estado actual "Baja": ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            Lv_Status             := 'Baja';
            RAISE Le_ActualizaMapeo;
          END IF;
          Lr_ParametrosValidarSec                    :=  NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_TIPO_PROMOCION  :=  La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_PUNTO           :=  Pn_IdPuntoDestino;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'EXISTENTE';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_MENS';
          Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_Empresa;

          IF NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec)) THEN

            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: '
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Sectorización.';
            Lv_Status             := 'Baja';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'Imcumple la Regla de Sectorización: ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            RAISE Le_ActualizaMapeo;
          END IF;

          IF NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                         Fn_IdPunto        => Pn_IdPuntoDestino)) THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por imcumplir la Regla de Forma de Pago.';
            Lv_Status             := 'Baja';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'Imcumple la Regla de Forma de Pago: ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            RAISE Le_ActualizaMapeo;
          END IF;

          IF NOT Lb_AplicaMapeo THEN

            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
               ' indefinidamente por imcumplir la Regla de Planes y Productos.';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'Imcumple la Regla de Planes y Productos: ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            IF  NOT Lb_CumpleEstadoServ  THEN
               Lv_Observacion        := 'El servicio pierde la Promoción: ' 
               || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
               || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                     ' indefinidamente por no contar con los estados permitidos del servicio.';
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                   'No cuenta con los estados permitidos del servicio: ' ||
                                                   ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                   ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                   'telcos_mapeo_traslado',
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
              --
            END IF;
              
            Lv_Status             := 'Baja';
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            RAISE Le_ActualizaMapeo;
          END IF;

          Lv_TieneSolicitud := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(La_ClientesProcesar(Ln_Indx).SERVICIO_ID);
          IF Lv_TieneSolicitud = 'N' THEN
            Ln_IntIdPromocion     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Ln_IntIdTipoPromocion := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Ln_IntIdPunto         := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Ln_IdPersonaRol       := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Ln_Id_Detalle_Mapeo   := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Ln_Id_Servicio        := La_ClientesProcesar(Ln_Indx).SERVICIO_ID;
            Lv_Observacion        := 'El servicio pierde la Promoción: ' 
            || La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO|| ' - '
            || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                   ' indefinidamente por contar con una solicitud de descuento.';
            Lv_Status             := 'Baja';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'Cuenta con una solicitud de descuento: ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            RAISE Le_ActualizaMapeo;
          END IF;

          Lc_Trama := REPLACE(La_ClientesProcesar(Ln_Indx).TRAMA, '"ID_PUNTO":"'||Pn_IdPunto||'"', '"ID_PUNTO":"'||Pn_IdPuntoDestino||'"');
          IF La_ServiciosMapeados.COUNT > 0 THEN
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 'Encontro servicios mapeados: ' ||
                                                 ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                 ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado, 
                                                 'telcos_mapeo_traslado',
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            --
            Ln_Ind1 := La_ServiciosMapeados.FIRST;   
            WHILE (Ln_Ind1 IS NOT NULL)   
            LOOP
              OPEN C_ServicioDestino(La_ServiciosMapeados(Ln_Ind1).ID_SERVICIO,Pv_Empresa);
              FETCH C_ServicioDestino INTO Ln_ServicioDestino;
              CLOSE C_ServicioDestino;
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                   'Encontro servicios mapeados: ' ||
                                                   ' ID_PUNTO: '||Pn_IdPunto|| ', ID_SERVICIO: '||Pn_IdServicio||
                                                   ', EMPRESA: ' ||Pv_Empresa|| ', Pv_Estado: ' ||Pv_Estado||
                                                   ', Ln_ServicioDestino: '||Ln_ServicioDestino, 
                                                   'telcos_mapeo_traslado',
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
              --                                      
              Lc_Trama := REPLACE(La_ClientesProcesar(Ln_Indx).TRAMA, '"ID_SERVICIO":"'||La_ServiciosMapeados(Ln_Ind1).ID_SERVICIO||'"', '"ID_SERVICIO":"'||Ln_ServicioDestino||'"');
              
              La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO      := Ln_ServicioDestino;
              La_ServiciosDetNoActivo(Ln_Ind1).ID_PUNTO         := Pn_IdPuntoDestino;
              La_ServiciosDetNoActivo(Ln_Ind1).ID_PLAN          := La_ServiciosMapeados(Ln_Ind1).ID_PLAN;
              La_ServiciosDetNoActivo(Ln_Ind1).ID_PRODUCTO      := La_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO;
              La_ServiciosDetNoActivo(Ln_Ind1).PLAN_ID_SUPERIOR := La_ServiciosMapeados(Ln_Ind1).PLAN_ID_SUPERIOR;
              La_ServiciosDetNoActivo(Ln_Ind1).ESTADO           := La_ServiciosMapeados(Ln_Ind1).ESTADO;
              La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO_ORIG := La_ServiciosMapeados(Ln_Ind1).ID_SERVICIO;
              
              La_ServiciosDetalle(Ln_Ind1).ID_SERVICIO      := Ln_ServicioDestino;
              La_ServiciosDetalle(Ln_Ind1).ID_PUNTO         := Pn_IdPuntoDestino;
              La_ServiciosDetalle(Ln_Ind1).ID_PLAN          := La_ServiciosMapeados(Ln_Ind1).ID_PLAN;
              La_ServiciosDetalle(Ln_Ind1).ID_PRODUCTO      := La_ServiciosMapeados(Ln_Ind1).ID_PRODUCTO;
              La_ServiciosDetalle(Ln_Ind1).PLAN_ID_SUPERIOR := La_ServiciosMapeados(Ln_Ind1).PLAN_ID_SUPERIOR;
              La_ServiciosDetalle(Ln_Ind1).ESTADO           := La_ServiciosMapeados(Ln_Ind1).ESTADO;
              La_ServiciosMapeados(Ln_Ind1).ID_SERVICIO     := Ln_ServicioDestino;
              La_ServiciosMapeados(Ln_Ind1).ID_PUNTO        := Pn_IdPuntoDestino;
              La_ServiciosMapeados(Ln_Ind1).ESTADO          := 'Activo';
              Ln_Ind1 := La_ServiciosMapeados.NEXT(Ln_Ind1);
            END LOOP;
          END IF;
          
          Lv_CadenaNoActivoWhere:= Lv_CadenaNoActivoWhere || ' AND IDMP.GRUPO_PROMOCION_ID ='''||La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID||''' ';
          Lv_ConsultaAll := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaNoActivoWhere || Lv_CadenaOrdenaAll;    
          --
          IF Pv_Estado = 'Activo' THEN 
          --
            IF Lrf_ClientesMapeoAll%ISOPEN THEN
              CLOSE Lrf_ClientesMapeoAll;
            END IF;
          
            OPEN Lrf_ClientesMapeoAll FOR Lv_ConsultaAll;
            LOOP
              FETCH Lrf_ClientesMapeoAll BULK COLLECT    
              INTO La_ClientesProcesarAll LIMIT 1000;
              EXIT WHEN La_ClientesProcesarAll.count = 0;
              Ln_IndxAll := La_ClientesProcesarAll.FIRST;
              WHILE (Ln_IndxAll IS NOT NULL)
              LOOP
                Lr_InfoDetalleMapeoPromo                          := NULL;
                Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO         := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
                Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID       := La_ClientesProcesarAll(Ln_IndxAll).GRUPO_PROMOCION_ID;
                Lr_InfoDetalleMapeoPromo.TRAMA                    := Lc_Trama;
                Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID   := La_ClientesProcesarAll(Ln_IndxAll).PERSONA_EMPRESA_ROL_ID;
                Lr_InfoDetalleMapeoPromo.PUNTO_ID                 := Pn_IdPuntoDestino;
                Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID        := La_ClientesProcesarAll(Ln_IndxAll).TIPO_PROMOCION_ID;
                Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION           := La_ClientesProcesarAll(Ln_IndxAll).TIPO_PROMOCION;
                Lr_InfoDetalleMapeoPromo.FE_MAPEO                 := La_ClientesProcesarAll(Ln_IndxAll).FE_MAPEO;
                Lr_InfoDetalleMapeoPromo.PERIODO                  := La_ClientesProcesarAll(Ln_IndxAll).PERIODO;
                Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO       := La_ClientesProcesarAll(Ln_IndxAll).FE_SIGUIENTE_MAPEO;
                Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS        := La_ClientesProcesarAll(Ln_IndxAll).CANTIDAD_PERIODOS;
                Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS         := La_ClientesProcesarAll(Ln_IndxAll).MAPEOS_GENERADOS;
                Lr_InfoDetalleMapeoPromo.PORCENTAJE               := La_ClientesProcesarAll(Ln_IndxAll).PORCENTAJE;
                Lr_InfoDetalleMapeoPromo.TIPO_PROCESO             := La_ClientesProcesarAll(Ln_IndxAll).TIPO_PROCESO;
                Lr_InfoDetalleMapeoPromo.INVALIDA                 := La_ClientesProcesarAll(Ln_IndxAll).INVALIDA;
                Lr_InfoDetalleMapeoPromo.INDEFINIDO               := La_ClientesProcesarAll(Ln_IndxAll).INDEFINIDO;
                Lr_InfoDetalleMapeoPromo.FE_CREACION              := SYSDATE;
                Lr_InfoDetalleMapeoPromo.USR_CREACION             := 'telcos_map_prom';
                Lr_InfoDetalleMapeoPromo.IP_CREACION              := Lv_IpCreacion;
                Lr_InfoDetalleMapeoPromo.FE_ULT_MOD               := NULL;
                Lr_InfoDetalleMapeoPromo.USR_ULT_MOD              := NULL;
                Lr_InfoDetalleMapeoPromo.IP_ULT_MOD               := NULL;
                Lr_InfoDetalleMapeoPromo.EMPRESA_COD              := Pv_Empresa;
                Lr_InfoDetalleMapeoPromo.ESTADO                   := La_ClientesProcesarAll(Ln_IndxAll).ESTADO;
                Ln_PromosAplicadas := Ln_PromosAplicadas + 1;
                IF La_ServiciosDetNoActivo.COUNT > 0 THEN 
                  Ln_Ind1 := La_ServiciosDetNoActivo.FIRST;   
                  WHILE (Ln_Ind1 IS NOT NULL)   
                  LOOP
                    Ln_IdDetalleSolicitud := NULL;
                    --
                    OPEN C_SolicitudAprobado(La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO_ORIG, La_ClientesProcesarAll(Ln_IndxAll).ID_DETALLE_MAPEO);
                    --
                    FETCH C_SolicitudAprobado INTO Ln_IdDetalleSolicitud;
                    --
                    CLOSE C_SolicitudAprobado;
                  
                    IF Ln_IdDetalleSolicitud IS NOT NULL AND Ln_IdDetalleSolicitud > 0 THEN
                      La_ServiciosDetNoActivo(Ln_Ind1).ID_DETALLE_SOLICITUD := Ln_IdDetalleSolicitud;
                    
                      UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                      SET SERVICIO_ID = La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO
                      WHERE ID_DETALLE_SOLICITUD=Ln_IdDetalleSolicitud;
                    
                      Lr_InfoDetalleSolHist                        := NULL;
                      Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                      Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := Ln_IdDetalleSolicitud;
                      Lr_InfoDetalleSolHist.ESTADO                 := 'Aprobado';
                      Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
                      Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
                      Lr_InfoDetalleSolHist.OBSERVACION            := 'Se actualiza SERVICIO_ID por traslado de promoción, ID_SERVICIO anterior: '||
                                                                      La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO_ORIG ||
                                                                      ' ID_SERVICIO nuevo: ' ||  La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO;
                      Lr_InfoDetalleSolHist.USR_CREACION           := 'telcos_map_prom';
                      Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
                      Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
                      Lr_InfoDetalleSolHist.MOTIVO_ID              := NULL;
                      P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_msj);
                      IF TRIM(Lv_msj) IS NOT NULL THEN
                        RAISE Le_Exception;
                      END IF;
                    END IF;
                    La_ServiciosDetNoActivo(Ln_Ind1).ESTADO           := La_ClientesProcesarAll(Ln_IndxAll).ESTADO;
                    Ln_Ind1                                           := La_ServiciosDetNoActivo.NEXT(Ln_Ind1);
                  END LOOP;
                END IF;
                P_INSERT_DETALLE_TRASLADO(Lr_InfoDetalleMapeoPromo, La_ServiciosDetNoActivo, Lv_msj);
                IF TRIM(Lv_msj) IS NOT NULL THEN
                  RAISE Le_Exception;
                END IF;
                Ln_IndxAll := La_ClientesProcesarAll.NEXT (Ln_IndxAll);
              END LOOP;
            END LOOP;
          --  
          END IF;
          Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IDMP.GRUPO_PROMOCION_ID ='''||La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID||''' ';
          Lv_ConsultaAll := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdenaAll;    

          IF Lrf_ClientesMapeoAll%ISOPEN THEN
            CLOSE Lrf_ClientesMapeoAll;
          END IF;
          
          OPEN Lrf_ClientesMapeoAll FOR Lv_ConsultaAll;
          LOOP
            FETCH Lrf_ClientesMapeoAll BULK COLLECT    
            INTO La_ClientesProcesarAll LIMIT 1000;
            EXIT WHEN La_ClientesProcesarAll.count = 0;
            Ln_IndxAll := La_ClientesProcesarAll.FIRST;
            WHILE (Ln_IndxAll IS NOT NULL)
            LOOP
              Lr_InfoDetalleMapeoPromo                          := NULL;
              Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO         := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
              Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID       := La_ClientesProcesarAll(Ln_IndxAll).GRUPO_PROMOCION_ID;
              Lr_InfoDetalleMapeoPromo.TRAMA                    := Lc_Trama;
              Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID   := La_ClientesProcesarAll(Ln_IndxAll).PERSONA_EMPRESA_ROL_ID;
              Lr_InfoDetalleMapeoPromo.PUNTO_ID                 := Pn_IdPuntoDestino;
              Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID        := La_ClientesProcesarAll(Ln_IndxAll).TIPO_PROMOCION_ID;
              Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION           := La_ClientesProcesarAll(Ln_IndxAll).TIPO_PROMOCION;
              Lr_InfoDetalleMapeoPromo.FE_MAPEO                 := La_ClientesProcesarAll(Ln_IndxAll).FE_MAPEO;
              Lr_InfoDetalleMapeoPromo.PERIODO                  := La_ClientesProcesarAll(Ln_IndxAll).PERIODO;
              Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO       := La_ClientesProcesarAll(Ln_IndxAll).FE_SIGUIENTE_MAPEO;
              Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS        := La_ClientesProcesarAll(Ln_IndxAll).CANTIDAD_PERIODOS;
              Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS         := La_ClientesProcesarAll(Ln_IndxAll).MAPEOS_GENERADOS;
              Lr_InfoDetalleMapeoPromo.PORCENTAJE               := La_ClientesProcesarAll(Ln_IndxAll).PORCENTAJE;
              Lr_InfoDetalleMapeoPromo.TIPO_PROCESO             := La_ClientesProcesarAll(Ln_IndxAll).TIPO_PROCESO;
              Lr_InfoDetalleMapeoPromo.INVALIDA                 := La_ClientesProcesarAll(Ln_IndxAll).INVALIDA;
              Lr_InfoDetalleMapeoPromo.INDEFINIDO               := La_ClientesProcesarAll(Ln_IndxAll).INDEFINIDO;
              Lr_InfoDetalleMapeoPromo.FE_CREACION              := SYSDATE;
              Lr_InfoDetalleMapeoPromo.USR_CREACION             := 'telcos_map_prom';
              Lr_InfoDetalleMapeoPromo.IP_CREACION              := Lv_IpCreacion;
              Lr_InfoDetalleMapeoPromo.FE_ULT_MOD               := NULL;
              Lr_InfoDetalleMapeoPromo.USR_ULT_MOD              := NULL;
              Lr_InfoDetalleMapeoPromo.IP_ULT_MOD               := NULL;
              Lr_InfoDetalleMapeoPromo.EMPRESA_COD              := Pv_Empresa;
              Lr_InfoDetalleMapeoPromo.ESTADO                   := La_ClientesProcesarAll(Ln_IndxAll).ESTADO;
              IF Pv_Estado = 'Activo' THEN
                Ln_PromosPendientes := Ln_PromosPendientes + 1;
              ELSE
                Ln_PromosAplicadas := Ln_PromosAplicadas + 1;
                IF La_ServiciosDetNoActivo.COUNT > 0 THEN 
                  Ln_Ind1 := La_ServiciosDetNoActivo.FIRST;   
                  WHILE (Ln_Ind1 IS NOT NULL)   
                  LOOP
                    Ln_IdDetalleSolicitud := NULL;
                    --
                    OPEN C_SolicitudAprobado(La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO_ORIG, La_ClientesProcesarAll(Ln_IndxAll).ID_DETALLE_MAPEO);
                    --
                    FETCH C_SolicitudAprobado INTO Ln_IdDetalleSolicitud;
                    --
                    CLOSE C_SolicitudAprobado;
                  
                    IF Ln_IdDetalleSolicitud IS NOT NULL AND Ln_IdDetalleSolicitud > 0 THEN
                      La_ServiciosDetNoActivo(Ln_Ind1).ID_DETALLE_SOLICITUD := Ln_IdDetalleSolicitud;
                    
                      UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                      SET SERVICIO_ID = La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO
                      WHERE ID_DETALLE_SOLICITUD=Ln_IdDetalleSolicitud;
                    
                      Lr_InfoDetalleSolHist                        := NULL;
                      Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                      Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := Ln_IdDetalleSolicitud;
                      Lr_InfoDetalleSolHist.ESTADO                 := 'Aprobado';
                      Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
                      Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
                      Lr_InfoDetalleSolHist.OBSERVACION            := 'Se actualiza SERVICIO_ID por traslado de promoción, ID_SERVICIO anterior: '||
                                                                      La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO_ORIG ||
                                                                      ' ID_SERVICIO nuevo: ' ||  La_ServiciosDetNoActivo(Ln_Ind1).ID_SERVICIO;
                      Lr_InfoDetalleSolHist.USR_CREACION           := 'telcos_map_prom';
                      Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
                      Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
                      Lr_InfoDetalleSolHist.MOTIVO_ID              := NULL;
                      P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_msj);
                      IF TRIM(Lv_msj) IS NOT NULL THEN
                        RAISE Le_Exception;
                      END IF;
                    END IF;
                    La_ServiciosDetNoActivo(Ln_Ind1).ESTADO           := La_ClientesProcesarAll(Ln_IndxAll).ESTADO;
                    Ln_Ind1                                           := La_ServiciosDetNoActivo.NEXT(Ln_Ind1);
                  END LOOP;
                END IF;
              END IF;
              P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo, La_ServiciosDetalle, Lv_msj); 
              IF TRIM(Lv_msj) IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              Ln_IndxAll := La_ClientesProcesarAll.NEXT (Ln_IndxAll);
            END LOOP;
          END LOOP;
          --
          IF Pv_Estado = 'Activo' THEN
            Lv_ObservacionPromo := 'Promoción '||La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO||': '||Ln_PromosAplicadas||' Meses Aplicados. Por recibir '||Ln_PromosPendientes||' Meses.';
          ELSE
            Lv_ObservacionPromo := 'Promoción '||La_ClientesProcesar(Ln_Indx).NOMBRE_GRUPO||': '||Ln_PromosAplicadas||' Meses Aplicados.';
          END IF;
          --
          P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                  Lv_ObservacionPromo,
                                  Lv_msj);
                                  
          IF TRIM(Lv_msj) IS NOT NULL THEN
              RAISE Le_Exception;
          END IF;
          Pv_TrasladoPromo := 'OK';
        EXCEPTION
        WHEN Le_ActualizaMapeo THEN
          BEGIN
            Ln_Contador := 0;
            La_SectorizacionProcesar.DELETE();
            Lv_msj                   := NULL;
            Lr_GrupoPromoRegla       := F_GET_PROMO_GRUPO_REGLA(Ln_IntIdPromocion);  
            Lr_TipoPromoRegla        := F_GET_PROMO_TIPO_REGLA(Ln_IntIdTipoPromocion);
            La_SectorizacionProcesar := F_GET_PROMO_SECTORIZACION(Ln_IntIdPromocion); 

            Lv_Trama                 := F_GET_TRAMA(Ln_IntIdPunto, 
                                                    Lr_GrupoPromoRegla,
                                                    Lr_TipoPromoRegla,
                                                    La_ServiciosMapeados,
                                                    La_SectorizacionProcesar,
                                                    null,
                                                    Pv_Empresa);
            FOR Lc_Id_Detalle_Mapeo IN C_Id_Detalle_Mapeo (Ln_IntIdPromocion,
                                                           Ln_IdPersonaRol,
                                                           Ln_IntIdPunto,
                                                           Ln_IntIdTipoPromocion,
                                                           Ln_Id_Detalle_Mapeo,
                                                           Ln_Id_Servicio) 
            LOOP
              IF Ln_Contador < 1 OR Lv_Status = 'Baja' THEN
                Lr_InfoDetalleMapeoPromo                        := NULL;
                Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                Lr_InfoDetalleMapeoPromo.TRAMA                  := Lv_Trama;
                Lr_InfoDetalleMapeoPromo.FE_ULT_MOD             := SYSDATE;
                Lr_InfoDetalleMapeoPromo.USR_ULT_MOD            := 'telcos_map_prom';
                Lr_InfoDetalleMapeoPromo.IP_ULT_MOD             := Lv_IpCreacion;
                Lr_InfoDetalleMapeoPromo.ESTADO                 := Lv_Status;

                P_UPDATE_DETALLE_MAPEO_PROM(Lr_InfoDetalleMapeoPromo,
                                            Lv_msj);

                IF TRIM(Lv_msj) IS NOT NULL THEN
                  RAISE Le_Exception;
                END IF;

                Lr_InfoDetMapSolicitud                     := NULL;
                Lr_InfoDetMapSolicitud.DETALLE_MAPEO_ID    := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
                Lr_InfoDetMapSolicitud.USR_ULT_MOD         := 'telcos_map_prom';
                Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;
                Lr_InfoDetMapSolicitud.ESTADO              := Lv_Status;
                P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud,
                                       Lv_msj);
                IF TRIM(Lv_msj) IS NOT NULL THEN
                  RAISE Le_Exception;
                END IF;

                Lr_InfoDetalleMapeoHisto                         := NULL;
                Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
                Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_Id_Detalle_Mapeo.ID_DETALLE_MAPEO;
                Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
                Lr_InfoDetalleMapeoHisto.USR_CREACION            := 'telcos_map_prom';
                Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
                Lr_InfoDetalleMapeoHisto.OBSERVACION             := Lv_Observacion;
                Lr_InfoDetalleMapeoHisto.ESTADO                  := Lv_Status;
                P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_msj);
                IF TRIM(Lv_msj) IS NOT NULL THEN
                  RAISE Le_Exception;
                END IF;
              END IF;
              Ln_Contador := Ln_Contador + 1;
            END LOOP;

            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            Pv_TrasladoPromo := 'PIERDE_PROMO';
          EXCEPTION                     
          WHEN Le_Exception THEN
            Lv_msj := 'Ocurrió un error al insertar el historial del servicio o mapeo para el ID_DETALLE_MAPEO: '
                      || Ln_Id_Detalle_Mapeo || ' en el script de traslado de promoción. MOTIVO : '
                      || Lv_Observacion || ' - ' || Lv_msj;

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 Lv_msj,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            Pv_TrasladoPromo := 'ERROR';
          WHEN OTHERS THEN
            Lv_msj := 'Ocurrió un error al actualizar el mapeo del ID_DETALLE_MAPEO: ' || Ln_Id_Detalle_Mapeo 
                       || ' para el script de traslado de promoción.'; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                                 Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            Pv_TrasladoPromo := 'ERROR';
          END;
        WHEN OTHERS THEN
          Lv_msj := 'Ocurrió un error al evaluar el mapeo del ID_DETALLE_MAPEO: ' || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO 
                     || ' para el script de traslado de promoción. ' || Lv_msj; 
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                               Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                               'telcos_mapeo_promo',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          Pv_TrasladoPromo := 'ERROR';
        END;
       
        Ln_Indx := La_ClientesProcesar.NEXT (Ln_Indx);
      END LOOP;
      COMMIT;
    END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_TrasladoPromo := 'ERROR';
    Lv_msj := 'Ocurrió un error al ejecutar el script de traslado de promociones.'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PROMO_MAPEO_TRASLADO', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
  END P_PROMO_MAPEO_TRASLADO;

  PROCEDURE P_PIERDE_PROMO_EXISTENTE (Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pv_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_TipoPromo   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE) IS

    --Costo: 3
    CURSOR C_ServicioMapeo (Cv_Cod_Empresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                            Cv_TipoPromo    DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                            Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                            Cv_EstadoActivo VARCHAR2)
    IS    
      SELECT DBIDMP.ID_DETALLE_MAPEO,
      DBIDMP.GRUPO_PROMOCION_ID, 
      DBIDMP.TIPO_PROMOCION_ID,
      DBIDMP.PERSONA_EMPRESA_ROL_ID,
      DBIDMP.PUNTO_ID,
      DBIDMP.TIPO_PROMOCION,
      (CASE
        WHEN DBIDMP.INDEFINIDO IS NULL
        THEN 'N'
        ELSE 'S'
      END) AS INDEFINIDO,
      DBIDMP.FE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DBIDMP
      WHERE DBIDMP.ID_DETALLE_MAPEO IN(SELECT MAX(IDMP.ID_DETALLE_MAPEO) AS ID_DETALLE_MAPEO
                                       FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                                       DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
                                       WHERE IDMP.INDEFINIDO IS NULL
                                       AND UPPER(IDMP.TIPO_PROCESO) = 'EXISTENTE'
                                       AND IDMP.TIPO_PROMOCION      IN (SELECT DET.VALOR2 
                                                                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                                        DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                                        WHERE CAB.NOMBRE_PARAMETRO = 'PROM_TIPO_PROMOCIONES'
                                                                        AND CAB.ESTADO             = Cv_EstadoActivo
                                                                        AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                                        AND DET.VALOR3             = Cv_TipoPromo
                                                                        AND DET.ESTADO             = Cv_EstadoActivo
                                                                        AND DET.EMPRESA_COD        = Cv_Cod_Empresa)
                                       AND IDMP.EMPRESA_COD         = Cv_Cod_Empresa
                                       AND IDMS.DETALLE_MAPEO_ID    = IDMP.ID_DETALLE_MAPEO
                                       AND IDMS.SERVICIO_ID         = Cn_IdServicio);

    Lv_Status                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE;
    Lr_TipoPromoRegla         Lr_TipoPromoReglaProcesar;
    Lr_GrupoPromoRegla        Lr_GrupoPromoReglaProcesar;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    La_SectorizacionProcesar  T_SectorizacionProcesar;
    La_ClientesProcesar       T_ClientesProcesar;
    La_ServiciosMapeados      T_ServiciosProcesar;
    La_ServiciosProcesar      T_ServiciosProcesar;
    La_ServiciosPerdidos      T_ServiciosProcesar;
    Lb_AplicaMapeo            BOOLEAN := TRUE;
    Ln_Indx                   NUMBER;
    Lv_EstadoActivo           VARCHAR2(6) := 'Activo';
    Lv_msj                    VARCHAR2(3200);
    Lv_Observacion            VARCHAR2(32000);
    Lv_Trama                  VARCHAR2(4000);
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lex_Exception             EXCEPTION;
    Lr_ParametrosValidarSec   DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    Lb_CumpleEstadoServ       BOOLEAN;

  BEGIN
  --
    OPEN C_ServicioMapeo (Pv_Empresa,
                          Pv_TipoPromo,
                          Pv_IdServicio,
                          Lv_EstadoActivo);
     LOOP
     --
      FETCH C_ServicioMapeo BULK COLLECT
      --
        INTO La_ClientesProcesar LIMIT 1000;
        EXIT WHEN La_ClientesProcesar.count = 0;
        Ln_Indx := La_ClientesProcesar.FIRST;
        WHILE (Ln_Indx IS NOT NULL)
        LOOP
        --
          BEGIN
          Lv_Status      := 'Activo';
          Lb_AplicaMapeo := TRUE;

          P_VALIDA_PROMO_PLAN_PROD(La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO,
                                   La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                   La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID,
                                   La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                   La_ClientesProcesar(Ln_Indx).PUNTO_ID,
                                   Lb_AplicaMapeo,
                                   La_ServiciosMapeados,
                                   La_ServiciosProcesar,
                                   La_ServiciosPerdidos,
                                   Lb_CumpleEstadoServ);

          IF NOT Lb_AplicaMapeo THEN
            IF La_ServiciosMapeados.COUNT = La_ServiciosPerdidos.COUNT OR (
               La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION = 'PROM_MIX' AND La_ServiciosPerdidos.COUNT > 0) THEN
              Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                ' indefinidamente por imcumplir la Regla de Planes y Productos.';
              P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                      Lv_Observacion,
                                      Lv_msj);

              IF TRIM(Lv_msj) IS NOT NULL THEN
              --
                Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
                RAISE Lex_Exception;
              --
              END IF;
              Lb_AplicaMapeo := FALSE;
              Lv_Status      := 'Baja';
            ELSE
              Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                                ' indefinidamente por imcumplir la Regla de Planes y Productos.';
              P_INSERTA_HIST_SERVICIO(La_ServiciosPerdidos,
                                      Lv_Observacion,
                                      Lv_msj);

              IF TRIM(Lv_msj) IS NOT NULL THEN
              --
                Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
                RAISE Lex_Exception;
              --
              END IF;
              Lb_AplicaMapeo := TRUE;
            END IF;
          END IF;

          Lr_ParametrosValidarSec                    :=  NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_TIPO_PROMOCION  :=  La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
          Lr_ParametrosValidarSec.ID_PUNTO           :=  La_ClientesProcesar(Ln_Indx).PUNTO_ID;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'EXISTENTE';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_MENS'; --MENSUALIDAD
          Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_Empresa;
          
          IF Lb_AplicaMapeo AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec)) THEN

            Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                              ' indefinidamente por imcumplir la Regla de Sectorización.';
            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            --
            END IF;

            Lb_AplicaMapeo := FALSE;
            Lv_Status      := 'Baja';
          END IF;

          IF Lb_AplicaMapeo AND 
             NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                         Fn_IdPunto        => La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
            Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                              ' indefinidamente por imcumplir la Regla de Forma de Pago.';
            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            --
            END IF;

            Lb_AplicaMapeo := FALSE;
            Lv_Status      := 'Baja';
          END IF;

          IF Lb_AplicaMapeo AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                                      La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                                                                      La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
            Lv_Observacion := 'El servicio pierde la Promoción: ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION||
                              ' momentaneamente por imcumplir la Regla por Mora.';
            P_INSERTA_HIST_SERVICIO(La_ServiciosMapeados,
                                    Lv_Observacion,
                                    Lv_msj);

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              Lv_msj:= 'Ocurrió un error al insertar el historial del servicio para el mapeo del ID_DETALLE_MAPEO: '
                        || La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO || ' por perdida de promoción. MOTIVO : '
                        || Lv_Observacion || ' - ' || Lv_msj;
              RAISE Lex_Exception;
            --
            END IF;

            Lb_AplicaMapeo := FALSE;
            Lv_Status      := 'Eliminado';
          END IF;
          
          IF Lv_Status IS NOT NULL AND Lv_Status IN ('Baja','Eliminado') THEN
            La_SectorizacionProcesar.DELETE();
            Lr_InfoDetalleMapeoPromo                        := NULL;
            Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
            Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID     := La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID      := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID;
            Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID := La_ClientesProcesar(Ln_Indx).PERSONA_EMPRESA_ROL_ID;
            Lr_InfoDetalleMapeoPromo.PUNTO_ID               := La_ClientesProcesar(Ln_Indx).PUNTO_ID;
            Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION         := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION;
            Lr_InfoDetalleMapeoPromo.INDEFINIDO             := La_ClientesProcesar(Ln_Indx).INDEFINIDO;
            Lr_InfoDetalleMapeoPromo.FE_MAPEO               := La_ClientesProcesar(Ln_Indx).FE_MAPEO;
            Lr_InfoDetalleMapeoPromo.EMPRESA_COD            := Pv_Empresa;
            Lr_InfoDetalleMapeoPromo.ESTADO                 := Lv_Status;
            Lr_GrupoPromoRegla                              := F_GET_PROMO_GRUPO_REGLA(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID);  
            Lr_TipoPromoRegla                               := F_GET_PROMO_TIPO_REGLA(La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID);  
            La_SectorizacionProcesar                        := F_GET_PROMO_SECTORIZACION(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID); 
            Lv_Trama                                        := F_GET_TRAMA(La_ClientesProcesar(Ln_Indx).PUNTO_ID, 
                                                                           Lr_GrupoPromoRegla,
                                                                           Lr_TipoPromoRegla,
                                                                           La_ServiciosProcesar,
                                                                           La_SectorizacionProcesar,
                                                                           null,
                                                                           Pv_Empresa);

            IF La_ServiciosMapeados.COUNT = La_ServiciosPerdidos.COUNT OR (
               La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION = 'PROM_MIX' AND La_ServiciosPerdidos.COUNT > 0)THEN

              P_MAPEO_PROMO_MENSUAL(Pa_ServiciosCumplePromo => La_ServiciosMapeados,
                                    Pr_TipoPromoRegla       => Lr_TipoPromoRegla,
                                    Prf_AdmiTipoPromoRegla  => Lr_InfoDetalleMapeoPromo,
                                    Pv_Trama                => Lv_Trama,
                                    Pv_MsjResultado         => Lv_msj);
            END IF;

            IF TRIM(Lv_msj) IS NOT NULL THEN
            --
              RAISE Lex_Exception;
            --
            END IF;
            
            IF Pv_TipoPromo = 'PROM_MENS' THEN
              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES(Pa_ServiciosPromo => La_ServiciosMapeados,
                                                                          Pv_CodEmpresa     => Pv_Empresa,
                                                                          Pv_TipoPromocion  => Pv_TipoPromo,
                                                                          Pv_EstadoOld      => 'Finalizada',
                                                                          Pv_estadoNew      => 'Eliminado',
                                                                          Pv_Observacion    => 'Se elimina la solicitud por perdida de promoción.',
                                                                          Pv_Mensaje        => Lv_msj);
            END IF;                                                            
          --
          END IF;
          EXCEPTION
          WHEN Lex_Exception THEN
          --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PIERDE_PROMO_EXISTENTE', 
                                                 Lv_msj,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          WHEN OTHERS THEN
          --
            Lv_msj := 'Ocurrió un error al mapear el registro para el  GRUPO_PROMOCION: '|| La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID
                      || ' TIPO_PROMOCION ' || La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID || ' para el ID_PUNTO: ' || 
                      La_ClientesProcesar(Ln_Indx).PUNTO_ID; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES.P_PIERDE_PROMO_EXISTENTE', 
                                                 Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          END;
          --
          Ln_Indx := La_ClientesProcesar.NEXT (Ln_Indx);
        END LOOP;
        COMMIT;
      --
      END LOOP;
    --
    CLOSE C_ServicioMapeo;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_msj := 'Ocurrió un error al ejecutar el proceso Mensual';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_PIERDE_PROMO_EXISTENTE', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_PIERDE_PROMO_EXISTENTE;


  PROCEDURE P_MAPEO_APLICA_PROMO_NUEVOS(Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoProceso          IN VARCHAR2,
                                        Pv_Alcance              IN VARCHAR2 DEFAULT NULL)
  IS

    Lv_MsjResultado           VARCHAR2(2000);
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_DiaCiclo               NUMBER;   
    Ln_promocionesCod         NUMBER;
    Ln_promociones            NUMBER;

  BEGIN

    Ln_promocionesCod := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_POMOCIONES_VIGENTES(FV_TipoProceso => Pv_TipoProceso,
                                                                                  Fv_CodEmpresa  => Pv_CodEmpresa,
                                                                                  Fv_EsCodigo    => 'S');
                                                                                  
    Ln_promociones    := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_POMOCIONES_VIGENTES(FV_TipoProceso => Pv_TipoProceso,
                                                                                  Fv_CodEmpresa  => Pv_CodEmpresa);
                                                                                  
    IF Ln_promocionesCod > 0 THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES',
                                           'Inicio de ejecucion P_PROMOCIONES_POR_CODIGO',
                                           'telcos_job_nuev_'||Pv_CodEmpresa,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                           Lv_IpCreacion));
      DB_COMERCIAL.CMKG_PROMOCIONES.P_PROMOCIONES_POR_CODIGO(Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                             Pv_CodEmpresa           => Pv_CodEmpresa,
                                                             Pv_TipoProceso          => Pv_TipoProceso);
    END IF;
    
    IF Ln_promociones > 0 THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES', 
                                           'Inicio de ejecucion P_PROCESO_MAPEO_PROMOCIONES',
                                           'telcos_job_nuev_'||Pv_CodEmpresa,
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                           Lv_IpCreacion));
      DB_COMERCIAL.CMKG_PROMOCIONES.P_PROCESO_MAPEO_PROMOCIONES(Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                Pv_TipoProceso          => Pv_TipoProceso,
                                                                Pv_Alcance              => Pv_Alcance);
    END IF;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'CMKG_PROMOCIONES.P_APLICA_PROMOCION', 
                                         'Inicio de ejecucion P_APLICA_PROMOCION',
                                         'telcos_job_nuev_'||Pv_CodEmpresa,
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         Lv_IpCreacion));
                                         
    DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => Pv_CodEmpresa,
                                                     Pv_TipoPromo    => Pv_CodigoGrupoPromocion,
                                                     Pv_TipoProceso  => Pv_TipoProceso,
                                                     Pv_JobProceso   => 'JobDiario',
                                                     Pv_MsjResultado => Lv_MsjResultado);
                                                     
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'CMKG_PROMOCIONES.P_APLICA_PROMOCION',
                                         'Fin de ejecucion P_APLICA_PROMOCION',
                                         'telcos_job_nuev_'||Pv_CodEmpresa,
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         Lv_IpCreacion));

  EXCEPTION 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al ejecutar el proceso P_MAPEO_APLICA_PROMO_NUEVOS: '||
                      Pv_CodigoGrupoPromocion|| ' Tipo Proceso: '||Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_MAPEO_APLICA_PROMO_NUEVOS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_MAPEO_APLICA_PROMO_NUEVOS;


END CMKG_PROMOCIONES;
/
