CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG AS

 /*
  * Documentación para Función 'F_OBTIENE_FECHA_EVAL_VIGENCIA'  
  * Función que obtiene la Fecha con la cual se va a evaluar el rango de fechas de Inicio y Fin de Vigencia para otorgar un grupo promocional.
  * 
  * Si el Punto corresponde a un Cliente Nuevo se tomará la fecha de creación de su contrato.
  * Si el Punto corresponde a un Punto Adicional contratado se tomará la fecha de creación del servicio de internet del Punto adicional.
  * Si se esta contratando un servicio adicional que no es internet se debe tomar la fecha de creación menor de sus servicios adicionales contratados.
  *
  * PARAMETROS:
  * @Param Fn_PuntoId              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Fv_EstadoServ           IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
  * @Param Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-10-2019  
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.1 05-11-2019  - Se agregan consideraciones al obtener la fecha de evaluación de vigencias para el caso de Promociones de instalación
  *                            y ancho de banda se verifica diferencia en meses entre la fecha de creación del contrato y la fecha de creación del 
  *                            servicio para la consideración de la fecha a tomar para el proceso.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.2 13-11-2019 -Se agrega que se inserte en INFO_ERROR LOG en caso de no obtener la fecha para evaluación de Vigencia por casos de 
  *                          inconsistencia en data de contratos se inserta LOG de error y se continua con el proceso.
  *                          Se agrega llamada a la funcion F_ESTADO_CONTRATO que obtiene el estado actual de contrato con el cual se procesa.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.3 14-11-2019 - Se agrega en la función que se tome para instalalción los estados de servicio configurados en el parmetro para 
  * que considere varios estados.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.4 03-01-2020 - Se mejora cursores C_GetFeCreaServInternetActivo, C_GetFeCreaServAdicionalActivo para que considere entre dos días la confirmación
  *                           de los servicios en estado activo.
  */
  FUNCTION F_OBTIENE_FECHA_EVAL_VIGENCIA(Fn_PuntoId              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Fv_EstadoServ           IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                         Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    RETURN DATE;

 /**
  * Documentación para PROCEDURE 'P_ELIMINA_CARACT_PROMO_BW'.
  * Proceso obtiene las características promocionales de un servicio para actualizar su estado a Eliminado.
  *
  * Costo del Query C_ObtieneCaractPromo: 7
  *
  * PARAMETROS:
  * @Param Pn_IdServicio    IN  INFO_SERVICIO.ID_SERVICIO%TYPE   Recibe id del servicio
  * @Param Pv_MsjResultado  OUT VARCHAR2                         Devuelve mensaje de resultado
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 26-09-2019
  */          
  PROCEDURE P_ELIMINA_CARACT_PROMO_BW (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Pv_MsjResultado  OUT VARCHAR2);

 /**
  * Documentación para PROCEDURE 'P_ACTUALIZA_CARACT_PROMO_BW'.
  * Proceso que actualiza el estado a Eliminado de las características promocionales de un servicio.
  *
  * PARAMETROS:
  * @Param Pr_InfoServicioProdCaract  IN  INFO_SERVICIO_PROD_CARACT%ROWTYPE  Recibe un record de INFO_SERVICIO_PROD_CART
  * @Param Pv_MsjResultado            OUT VARCHAR2                           Devuelve mensaje de resultado
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 24-09-2019
  */   
  PROCEDURE P_ACTUALIZA_CARACT_PROMO_BW(Pr_InfoServicioProdCaract  IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE,
                                        Pv_MsjResultado            OUT VARCHAR2);

 /**
  * Documentación para PROCEDURE 'P_VALIDA_ELIMINA_CARACT_BW'.
  * Proceso que valida si debe o no eliminar las características promocionales de un servicio.
  *
  * Costo del Query C_ObtieneMaxMapeo: 2
  *
  * PARAMETROS:
  * @Param Pn_IdServicio     IN  INFO_SERVICIO.ID_SERVICIO%TYPE                   Recibe id del servicio
  * @Param Pv_TipoPromo      IN  ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE   Recibe tipo de promoción
  * @Param Pb_EliminaCaract  OUT BOOLEAN                                          Devuelve TRUE/FALSE si debe o no eliminar 
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 24-09-2019
  */   
  PROCEDURE P_VALIDA_ELIMINA_CARACT_BW (Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                        Pv_TipoPromo       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pb_EliminaCaract  OUT BOOLEAN);

  /**
   * Documentación para el procedimiento 'P_INSERT_ISERVICIO_PROD_CARACT'.
   *
   * Proceso encargado de insertar las características promocionales de un servicio.
   *
   * @Param Pr_InfoServProdCaract IN  ROWTYPE  : Recibe un record de la tabla 'INFO_SERVICIO_PROD_CARACT' de 'DB_COMERCIAL'.
   * @Param Pv_Mensaje            OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_INSERT_ISERVICIO_PROD_CARACT(Pr_InfoServProdCaract IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE,
                                           Pv_Mensaje            OUT VARCHAR2);

  /**
   * Documentación para PROCEDURE 'P_ELIMINA_CARACT_INDV_BW'.
   * Proceso obtiene la característica de un servicio para actualizar su estado a Eliminado.
   *
   * Costo del Query C_ObtieneCaractPromo: 7
   *
   * PARAMETROS:
   * @Param Pn_IdServicio    IN INFO_SERVICIO.ID_SERVICIO%TYPE                              Recibe id del servicio
   * @Param Pv_NombreCaract  IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_CARACTERISTICA%TYPE  Nombre de caracteristica a eliminar
   * @Param Pv_MsjResultado  OUT VARCHAR2                                                   Devuelve mensaje de resultado
   *
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.0 16-10-2019
   */
  PROCEDURE P_ELIMINA_CARACT_INDV_BW (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_NombreCaract  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Pv_MsjResultado  OUT VARCHAR2);

  /**
   * Documentación para PROCEDURE 'P_ELIMINA_CARACT_INDV_BW'.
   * Proceso registra la característica de un servicio.
   *
   * PARAMETROS:
   * @Param Pn_IdServicio    IN INFO_SERVICIO.ID_SERVICIO%TYPE                               Recibe id del servicio
   * @Param Pv_NombreCaract  IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_CARACTERISTICA%TYPE   Nombre de caracteristica a eliminar
   * @Param Pv_MsjResultado  OUT VARCHAR2                                                    Devuelve mensaje de resultado
   *
   * Costo del Query C_AdmiProdCaract: 10
   *
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.0 16-10-2019
   */
  PROCEDURE P_CREA_CARACT_INDV_BW (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_NombreCaract  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Pv_ValorCaract   IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                   Pv_MsjResultado  OUT VARCHAR2);

  /**
   * Documentación para FUNCTION 'F_VALIDA_TIPO_NEGOCIO'.
   *
   * Función que verifica que el punto del cliente entre en los tipos de negocio configurado para la promoción,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
   *
   * Costo del Query C_TipoNegocioInsABan: 18
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
   * @Param Fv_CodEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-09-2019
   */ 
  FUNCTION F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentación para FUNCTION 'F_VALIDA_ULTIMA_MILLA'.
   *
   * Función que verifica que el punto del cliente entre en las últimas millas configurada para la promoción,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
   *
   * Costo del Query C_UltimaMillaInsABan: 15
   * Costo del Query C_UltimaMillaPunto: 18
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-09-2019
   */ 
  FUNCTION F_VALIDA_ULTIMA_MILLA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentación para FUNCTION 'F_VALIDA_FORMA_PAGO'.
   *
   * Función que verifica que el punto cumpla con las forma de pago de una promoción,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
   *
   * Costo del Query C_TipoPomocion: 2
   * Costo del Query C_FormaPagoMens: 2
   * Costo del Query C_FormaPagoInsABan: 3
   * Costo del Query C_FormaPagoPunto: 6
   * Costo del Query C_BancoTipoCuenta: 9
   * Costo del Query C_ExisteBancoTipoCta: 2
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   *
   * Se agrega lógica para que los cursores que obtienen la forma de pago no consideren estados por los tipos de promoción 
   * Instalación y Ancho de Banda.
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.1 27-09-2019
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.2 13-11-2019 - Se agrega llamada a la funcion F_ESTADO_CONTRATO que obtiene el estado actual del contrato con el cual se procesa.
   */
  FUNCTION F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentación para FUNCTION 'F_VALIDA_PERMANENCIA'.
   *
   * Función que verifica que el punto cumpla con la permanencia mínima configurada por tipo de promoción,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
   *
   * Costo del Query C_FechaConfirmacion: 11
   * Costo del Query C_PermanenciaMinima: 5
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fv_Tipo_Promocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
   * @Param Fn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   */
  FUNCTION F_VALIDA_PERMANENCIA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                Fv_Tipo_Promocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentación para FUNCTION 'F_VALIDA_MORA'.
   *
   * Función que verifica que el punto no halla caído en mora en el tiempo configurado por el tipo de promoción,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
   *
   * Costo del Query C_PierdeMora: 5
   * Costo del Query C_DiasMora: 5
   * Costo del Query C_TieneMora: 12
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fv_Tipo_Promocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
   * @Param Fn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   */
  FUNCTION F_VALIDA_MORA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                         Fv_Tipo_Promocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                         Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

 /**
  * Documentación para FUNCTION 'F_VALIDA_SECTORIZACION_OLT'.
  * Función que verifica que el elemento OLT cumpla con las reglas de sectorización de una promoción especifica,
  * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
  *
  * Costo del Query C_SectorizacionABan: 7
  * Costo del Query C_SectorizacionElemento: 13
  * Costo del Query C_SectorizacionPunto: 21
  *
  * PARAMETROS:
  * @Param Fn_IntIdPromocion   IN ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE  Recibe id grupo promoción
  * @Param Fn_IdElemento       IN INFO_ELEMENTO.ID_ELEMENTO%TYPE                Recibe id elemento
  * @Param Fv_CodEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE           Recibe código de empresa
  * @Param Fn_IdPunto          IN INFO_PUNTO.ID_PUNTO%TYPE                      Recibe id del punto
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-09-2019
  */    
  FUNCTION F_VALIDA_SECTORIZACION_OLT(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                      Fn_IdElemento     IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                      Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentación para FUNCTION 'F_VALIDA_ANTIGUEDAD'.
   * Función que verifica que el servicio tenga la antigüedad mínima configurada en la promoción,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" ó 0 "No Aplica".
   *
   * Costo del Query C_FechaConfirmacion: 11
   * Costo del Query C_Antiguedad: 5
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE  Recibe id grupo promoción
   * @Param Fn_IdPunto          IN INFO_PUNTO.ID_PUNTO%TYPE                      Recibe id del punto
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-09-2019
   */
  FUNCTION F_VALIDA_ANTIGUEDAD(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /*
   * Documentación para TYPE 'Tr_SectorizacionInsBwMens'.
   *
   * Record que permite almacenar los valores de sectorización.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @versión 1.0 18-10-2019
   */
  TYPE Tr_SectorizacionInsBwMens IS RECORD (
    ID_SECTORIZACION VARCHAR2(50),
    ID_JURISDICCION  VARCHAR2(50),
    ID_CANTON        VARCHAR2(50),
    ID_PARROQUIA     VARCHAR2(50),
    ID_SECTOR        VARCHAR2(50),
    ID_ELEMENTO      VARCHAR2(50),
    ID_EDIFICIO      VARCHAR2(50)
  );

  /**
   * Documentación para TYPE 'Tt_SectorizacionInsBwMens'.
   * TYPE TABLE para almacenar todos los valores de sectorización.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @versión 1.0 18-10-2019
   */
  TYPE Tt_SectorizacionInsBwMens IS TABLE OF Tr_SectorizacionInsBwMens INDEX BY PLS_INTEGER;

  /*
   * Documentación para TYPE 'Tr_ParametrosValidarSec'.
   *
   * Record de los parámetros necesarios para validar la sectorización de un servicio.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @versión 1.0 18-10-2019
   */
  TYPE Tr_ParametrosValidarSec IS RECORD (
    ID_GRUPO_PROMOCION NUMBER,
    ID_TIPO_PROMOCION  NUMBER,
    TIPO_PROMOCION     VARCHAR2(10), --PROM_MENS,PROM_INS,PROM_BW
    ID_PUNTO           NUMBER,
    ID_SERVICIO        NUMBER,
    TIPO_EVALUACION    VARCHAR2(20) --NUEVO,EXISTENTE
  );

  /**
   * Documentación para FUNCTION 'F_VALIDA_SECTORIZACION'.
   *
   * Función que verifica que el punto cumpla con las reglas de sectorización de una promoción.
   * Devuelve como respuesta un valor de tipo Boolean 1(Uno) "Si Aplica" ó 0(Cero) "No Aplica".
   *
   * Costo del Query C_SevicioPunto          : 13
   * Costo del Query C_SectorizacionServicio : 29
   * Costo del Query C_ExisteSectElemEdif    : 2
   *
   * @Param Pr_ParametrosValidarSec IN Tr_ParametrosValidarSec
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 18-10-2019
   *
   * @author José Candelario <jcandelario@telconet.ec>
   * @version 1.1 15-11-2019 - Se modifica cursor C_SevicioPunto para considera el estado de la estructura info_servicio.
   */
  FUNCTION F_VALIDA_SECTORIZACION(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN BOOLEAN;

  /**
   * Documentación para Función 'F_GET_CURSOR_SECTORIZACION'.
   * Función que devuelve el cursor de las sectorizaciones de una promoción.
   *
   * Costo del SYS_REFCURSOR: 7
   *
   * @Param Pr_ParametrosValidarSec IN RECORD - Recibe un record de tipo Tr_ParametrosValidarSec
   * @Return SYS_REFCURSOR
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 18-10-2019
   */
  FUNCTION F_GET_CURSOR_SECTORIZACION(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN SYS_REFCURSOR;

  /**
   * Documentación para la Función 'F_EXISTE_SOLICITUD_OLT'.
   * Método que valida si existe una solicitud de cambio de OLT de un punto cliente.
   *
   * Costo del SYS_REFCURSOR: 7
   *
   * @Param Pr_ParametrosValidarSec IN RECORD - Recibe un record de tipo Tr_ParametrosValidarSec
   * @Return BOOLEAN
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 18-10-2019
   */
  FUNCTION F_EXISTE_SOLICITUD_OLT(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN BOOLEAN;

  /**
  * Documentación para PROCESO 'P_MAPEO_PROM_TENTATIVA'.
  * Proceso encargado de evaluar si un servicio cae en una de las promociones para enviar información a Contrato Digital.
  *
  * Costo del Query C_GetEmpresa: 1
  * Costo del Query C_GetErrorRepetido: 11
  * Costo del Query C_Datos: 2
  * Costo del Query C_PeriodoDesc: 3
  * Costo del Query C_GetServicioHistorial: 15
  *
  * PARAMETROS:
  * @Param Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Fecha                IN VARCHAR2
  * @Param Pn_Descuento            OUT NUMBER
  * @Param Pn_CantPeriodo          OUT NUMBER
  * @Param Pv_Observacion          OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 29-10-2019
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1 14-04-2020 - Se agrega que la variable Pn_Descuento escriba el valor cero cuando no otorga promociones.
  *
  */
  PROCEDURE P_MAPEO_PROM_TENTATIVA(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_Fecha                IN VARCHAR2,
                                   Pv_FormaPago            IN VARCHAR2,
                                   Pn_Descuento            OUT NUMBER,
                                   Pn_CantPeriodo          OUT NUMBER,
                                   Pv_Observacion          OUT VARCHAR2);

  /**
  * Documentación para PROCESO 'P_OBTIENE_PROMO_TENTATIVAS'.
  * Proceso encargado de obtener las promociones activas por Tipo Promoción y fechas de vigencias.
  *
  * Costo del Query C_GrupoPromociones: 12
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoProceso           IN VARCHAR2
  * @Param Prf_GruposPromociones    OUT SYS_REFCURSOR
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 29-10-2019
  */
  PROCEDURE P_OBTIENE_PROMO_TENTATIVAS(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoProceso           IN VARCHAR2,
                                       Pv_fecha                 IN VARCHAR2,
                                       Pv_FormaPago             IN VARCHAR2,
                                       Prf_GruposPromociones    OUT SYS_REFCURSOR);

  /**
  * Documentación para PROCESO 'P_OBTIENE_SERVICIOS_PUNTO'.
  * Proceso encargado de obtener los servicios de un punto que se encuentran en un flujo de activación.
  *
  * Costo del Query C_ServiciosPunto: 12
  *
  * PARAMETROS:
  * @Param Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 29-10-2019
  */
  PROCEDURE P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar);

  /**
  * Documentación para FUNCTION 'F_ESTADO_CONTRATO'.
  * Función que obtiene el estado actual de contrato solo se consideran los siguinetes estados: "ACTIVO",
  * "PENDIENTE", "PORAUTORIZAR" ó NULL.
  *
  * Costo del Query C_EstadosContratos: 4
  * Costo del Query C_EstadoContrato: 6
  *
  * PARAMETROS:
  * @Param Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE Recibe id del punto
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 08-11-2019
  */                                      
  FUNCTION F_ESTADO_CONTRATO(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;

  /**
  * Documentación para FUNCTION 'F_ESTADO_SERVICOS'.
  * Función que obtiene la fecha del servicio según los estados configurados en el parámetro de Estados Servicios.
  * Fecha_servicio ó NULL.
  *
  * Costo del Query C_GetParametro: 4
  * Costo del Query C_GetFeCreacionServ: 7
  *
  * PARAMETROS:
  * @Param Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE Recibe id del punto
  * @Param Fv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE Recibe el nombre del parámetro
  * @Param Fv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE Recibe el tipo de promoción
  * @Param Fv_EstadoActivo    VARCHAR2 Recibe el estado del parámetro
  * @Param Fv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE Recibe el id de la empresa
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 15-11-2019
  */                                      
  FUNCTION F_ESTADO_SERVICOS(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Fv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                               Fv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                               Fv_EstadoActivo    VARCHAR2,
                               Fv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    RETURN VARCHAR2;
END CMKG_PROMOCIONES_UTIL_REG;
/

