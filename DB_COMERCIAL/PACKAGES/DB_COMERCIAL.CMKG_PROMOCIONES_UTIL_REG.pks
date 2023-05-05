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

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG AS
  --
  --
  FUNCTION F_OBTIENE_FECHA_EVAL_VIGENCIA(Fn_PuntoId              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Fv_EstadoServ           IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                         Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    RETURN DATE
  IS

    --Costo : 750
    CURSOR C_CuentaPuntos (Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
      SELECT PTO_B.PERSONA_EMPRESA_ROL_ID, 
        COUNT(*) AS TOTAL
      FROM DB_COMERCIAL.INFO_PUNTO PTO_A,
      DB_COMERCIAL.INFO_PUNTO PTO_B
      WHERE PTO_A.ID_PUNTO              = Cn_IdPunto
      AND PTO_A.PERSONA_EMPRESA_ROL_ID  = PTO_B.PERSONA_EMPRESA_ROL_ID
      AND PTO_B.ID_PUNTO                <> PTO_A.ID_PUNTO
      AND EXISTS (SELECT 1
                  FROM DB_COMERCIAL.INFO_SERVICIO SERV,
                       DB_COMERCIAL.INFO_PLAN_CAB IPC,
                       DB_COMERCIAL.INFO_PLAN_DET IPD,
                       DB_COMERCIAL.ADMI_PRODUCTO AP
                  WHERE SERV.PUNTO_ID     =  PTO_B.ID_PUNTO
                  AND SERV.PLAN_ID        =  IPC.ID_PLAN
                  AND IPC.ID_PLAN         =  IPD.PLAN_ID
                  AND IPD.PRODUCTO_ID     =  AP.ID_PRODUCTO
                  AND AP.NOMBRE_TECNICO   = 'INTERNET'
                  AND SERV.ESTADO         IN ('Activo','In-Corte')
                  )
       GROUP BY PTO_B.PERSONA_EMPRESA_ROL_ID;

    --Costo: 7
    CURSOR C_GetFeCreacionServ (Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Cv_EstadoServ  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS
      SELECT TRUNC(SERV.FE_CREACION) AS FE_EVALUA_VIGENCIA
      FROM DB_COMERCIAL.INFO_SERVICIO SERV, 
        DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE SERV.PUNTO_ID   =  Cn_IdPunto
      AND SERV.PLAN_ID      =  IPC.ID_PLAN
      AND IPC.ID_PLAN       =  IPD.PLAN_ID
      AND IPD.PRODUCTO_ID   =  AP.ID_PRODUCTO
      AND AP.NOMBRE_TECNICO = 'INTERNET'
      AND SERV.ESTADO       = Cv_EstadoServ;

   --Costo: 7
    CURSOR C_GetFeCreacionContrato (Cn_IdPunto         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Cv_EstadoContrato  DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE)
    IS
      SELECT MAX(TRUNC(CONT.FE_CREACION)) AS FE_EVALUA_VIGENCIA
      FROM DB_COMERCIAL.INFO_CONTRATO  CONT,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PROL, 
      DB_COMERCIAL.INFO_PUNTO               PTO
      WHERE PTO.ID_PUNTO              =  Cn_IdPunto
      AND PTO.PERSONA_EMPRESA_ROL_ID  =  PROL.ID_PERSONA_ROL
      AND PROL.ID_PERSONA_ROL         =  CONT.PERSONA_EMPRESA_ROL_ID
      AND CONT.ESTADO                 =  Cv_EstadoContrato;

    --Costo: 11
    CURSOR C_GetFeCreaServInternetActivo (Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                          Cv_EstadoServ  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS
     SELECT TRUNC(MIN(SERV.FE_CREACION)) AS FE_EVALUA_VIGENCIA 
     FROM DB_COMERCIAL.INFO_SERVICIO SERV, 
       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH,
       DB_COMERCIAL.INFO_PLAN_CAB IPC,
       DB_COMERCIAL.INFO_PLAN_DET IPD,
       DB_COMERCIAL.ADMI_PRODUCTO AP
     WHERE SERV.PUNTO_ID                           = Cn_IdPunto
     AND SERV.PLAN_ID                              = IPC.ID_PLAN
     AND IPC.ID_PLAN                               = IPD.PLAN_ID
     AND IPD.PRODUCTO_ID                           = AP.ID_PRODUCTO
     AND AP.NOMBRE_TECNICO                         = 'INTERNET'                   
      AND SERV.ID_SERVICIO                         = ISH.SERVICIO_ID
      AND SERV.ESTADO                              = Cv_EstadoServ
      AND (UPPER(dbms_lob.substr(ISH.OBSERVACION)) LIKE '%CONFIRMO%' 
      OR ISH.ACCION                                = 'confirmarServicio' ) 
      AND TO_CHAR(ISH.FE_CREACION,'RRRR-MM-DD')    >= TO_CHAR(SYSDATE -1,'RRRR-MM-DD')
      AND TO_CHAR(ISH.FE_CREACION,'RRRR-MM-DD')    <= TO_CHAR(SYSDATE,'RRRR-MM-DD') 
      AND ISH.ESTADO                               = Cv_EstadoServ;

    --Costo: 7
    CURSOR C_GetFeCreaServAdicionalActivo(Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                          Cv_EstadoServ  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS
    SELECT TRUNC(MIN(SERV.FE_CREACION)) AS FE_EVALUA_VIGENCIA 
    FROM DB_COMERCIAL.INFO_SERVICIO SERV, 
      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
    WHERE SERV.PUNTO_ID                          = Cn_IdPunto
    AND SERV.ID_SERVICIO                         = ISH.SERVICIO_ID
    AND SERV.ESTADO                              = Cv_EstadoServ
    AND (UPPER(dbms_lob.substr(ISH.OBSERVACION)) LIKE '%CONFIRMO%' 
    OR ISH.ACCION                                = 'confirmarServicio' ) 
    AND TO_CHAR(ISH.FE_CREACION,'RRRR-MM-DD')    >= TO_CHAR(SYSDATE - 1,'RRRR-MM-DD')
    AND TO_CHAR(ISH.FE_CREACION,'RRRR-MM-DD')    <= TO_CHAR(SYSDATE,'RRRR-MM-DD') 
    AND ISH.ESTADO                               = Cv_EstadoServ;

    CURSOR C_GetParamNumeroMesesContrato (Cv_NombreParam  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Cv_Estado       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE) 
    IS
    SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_MESES
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
    DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
    AND APD.ESTADO             = Cv_Estado
    AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
    AND APC.ESTADO             = Cv_Estado;

    --Variables Locales
    Ln_NumeroMeses          NUMBER := 0;
    Ln_TotalPuntos          NUMBER := 0;
    Ld_FeEvaluaVigencia     DATE;
    Ld_FeCreaServicio       DATE;
    Ld_FeCreaContrato       DATE;
    Ln_PersonaEmpRolId      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;     
    Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado         VARCHAR2(2000);
    Lv_Estado               DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE;
    Le_Exception            EXCEPTION;
  BEGIN

    Lv_Estado := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_ESTADO_CONTRATO (Fn_PuntoId);

    OPEN  C_GetParamNumeroMesesContrato(Cv_NombreParam => 'PROMOCIONES_NUMERO_MESES_EVALUA_FE_CONTRATO',
                                        Cv_Estado      => 'Activo');
    FETCH C_GetParamNumeroMesesContrato INTO Ln_NumeroMeses;
    CLOSE C_GetParamNumeroMesesContrato;

    OPEN  C_CuentaPuntos(Cn_IdPunto => Fn_PuntoId);
    FETCH C_CuentaPuntos INTO Ln_TotalPuntos, Ln_PersonaEmpRolId;
    CLOSE C_CuentaPuntos;

    IF Ln_TotalPuntos > 0 THEN

      --Es Punto Adicional 

      IF Fv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        --
        -- Si es Promoción de mensualidad obtengo la fecha de creación del servicio confirmado de Internet.
        OPEN  C_GetFeCreaServInternetActivo(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ => Fv_EstadoServ);
        FETCH C_GetFeCreaServInternetActivo INTO Ld_FeEvaluaVigencia;
        CLOSE C_GetFeCreaServInternetActivo;

        IF Ld_FeEvaluaVigencia IS NULL THEN                 
          OPEN  C_GetFeCreaServAdicionalActivo(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ => Fv_EstadoServ);
          FETCH C_GetFeCreaServAdicionalActivo INTO Ld_FeEvaluaVigencia;
          CLOSE C_GetFeCreaServAdicionalActivo;
        END IF;
        --
       ELSIF   Fv_CodigoGrupoPromocion = 'PROM_BW' THEN
        --     
        OPEN  C_GetFeCreacionServ(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ => Fv_EstadoServ);
        FETCH C_GetFeCreacionServ INTO Ld_FeEvaluaVigencia;
        CLOSE C_GetFeCreacionServ;
        --
      ELSE
        --
        Ld_FeEvaluaVigencia := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_ESTADO_SERVICOS (Fn_PuntoId,'PROM_ESTADO_SERVICIO',Fv_CodigoGrupoPromocion,'Activo','18');             
        --
      END IF;
      --
    ELSE

      --Es Cliente Nuevo

      IF Fv_CodigoGrupoPromocion = 'PROM_MENS' THEN       
        --
        -- Si es Promoción de mensualidad obtengo la fecha de creación del servicio confirmado de Internet.
        OPEN  C_GetFeCreaServInternetActivo(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ => Fv_EstadoServ);
        FETCH C_GetFeCreaServInternetActivo INTO Ld_FeCreaServicio;
        CLOSE C_GetFeCreaServInternetActivo;        
        --
        --Si el servicio confirmado es un servicio de internet debo tomar la fecha de creación contrato.
        --Si el servicio confirmado es un servicio adicional obtengo la minima fecha de creación de sus servicios adicionales.
        IF Ld_FeCreaServicio IS NOT NULL THEN                        
          OPEN  C_GetFeCreacionContrato(Cn_IdPunto => Fn_PuntoId, Cv_EstadoContrato => Lv_Estado);
          FETCH C_GetFeCreacionContrato INTO Ld_FeCreaContrato;
          CLOSE C_GetFeCreacionContrato;
          --Si la fecha de creacion del Contrato es menor a la fecha de creacion del servicio de internet confirmado se debe verificar
          --si los meses transcurridos entre ambas fechas es menor al numeros de meses parametrizados como validos para el contrato, caso
          --contrario se considera que se trata de un contrato antiguo y se toma la fecha de creacion del servicio para la evaluacion de vigencias.
          IF Ld_FeCreaServicio IS NOT NULL AND Ld_FeCreaContrato IS NOT NULL THEN
            IF Ld_FeCreaContrato < Ld_FeCreaServicio
              AND TRUNC(MONTHS_BETWEEN(Ld_FeCreaServicio, Ld_FeCreaContrato)) >= Ln_NumeroMeses THEN

              Ld_FeEvaluaVigencia:=Ld_FeCreaServicio;              
            ELSE
              Ld_FeEvaluaVigencia:=Ld_FeCreaContrato;              
            END IF;
          END IF;  
          --
        ELSE
          --Si se trata de un servicio Adicional confirmado, entonces se debe tomar la fecha de creacion minima de sus servicios adicionales.
          OPEN  C_GetFeCreaServAdicionalActivo(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ => Fv_EstadoServ);
          FETCH C_GetFeCreaServAdicionalActivo INTO Ld_FeEvaluaVigencia;
          CLOSE C_GetFeCreaServAdicionalActivo;
        END IF;
        --
      ELSE
        --
        OPEN  C_GetFeCreacionContrato(Cn_IdPunto => Fn_PuntoId, Cv_EstadoContrato => Lv_Estado);
        FETCH C_GetFeCreacionContrato INTO Ld_FeCreaContrato;
        CLOSE C_GetFeCreacionContrato;
        --
        --
         IF   Fv_CodigoGrupoPromocion = 'PROM_BW' THEN
            --     
            OPEN  C_GetFeCreacionServ(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ =>  Fv_EstadoServ);
            FETCH C_GetFeCreacionServ INTO Ld_FeCreaServicio;
            CLOSE C_GetFeCreacionServ;
            --
          ELSE     
            --
               Ld_FeCreaServicio := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_ESTADO_SERVICOS (Fn_PuntoId,'PROM_ESTADO_SERVICIO',Fv_CodigoGrupoPromocion,'Activo','18');

          END IF;
        --
        IF Ld_FeCreaServicio IS NOT NULL AND Ld_FeCreaContrato IS NOT NULL THEN
          IF Ld_FeCreaContrato < Ld_FeCreaServicio
            AND TRUNC(MONTHS_BETWEEN(Ld_FeCreaServicio, Ld_FeCreaContrato)) >= Ln_NumeroMeses THEN

            Ld_FeEvaluaVigencia:=Ld_FeCreaServicio;
          ELSE
            Ld_FeEvaluaVigencia:=Ld_FeCreaContrato;
          END IF;
        END IF;  
        --
      END IF;  
    --
    END IF;
    --Si no se pudo obtener Fecha para evaluación de vigencias se inserta error y se envia NULL
    IF Ld_FeEvaluaVigencia IS NULL THEN
       RAISE Le_Exception;         
    END IF; 

    RETURN Ld_FeEvaluaVigencia;
  EXCEPTION
    WHEN Le_Exception THEN      
      Lv_MsjResultado := 'Ocurrio un error al obtener la fecha para evaluación de vigencia de los '||
                         'grupos promocionales ID_PUNTO: ' || Fn_PuntoId || ' ESTADO: ' ||Fv_EstadoServ ||
                         ' CODIGO: ' || Fv_CodigoGrupoPromocion;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES_UTIL_REG.F_OBTIENE_FECHA_EVAL_VIGENCIA',
                                            Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

      RETURN NULL;
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurrio un error al obtener la fecha para evaluación de vigencia de los '||
                         'grupos promocionales ID_PUNTO: ' || Fn_PuntoId || ' ESTADO: ' ||Fv_EstadoServ ||
                         ' CODIGO: ' || Fv_CodigoGrupoPromocion;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES_UTIL_REG.F_OBTIENE_FECHA_EVAL_VIGENCIA',
                                            Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

      RETURN NULL;

  END F_OBTIENE_FECHA_EVAL_VIGENCIA;
  --
  --
  PROCEDURE P_ELIMINA_CARACT_PROMO_BW (Pn_IdServicio   IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Pv_MsjResultado OUT VARCHAR2)
  IS

    --Costo C_ObtieneCaractPromo: 7
    CURSOR C_ObtieneCaractPromo (Cn_IdServicio         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Cv_NombreTecnicoProd  DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                 Cv_EstadoActivo       VARCHAR2)
    IS  
       SELECT ISPC.ID_SERVICIO_PROD_CARACT,
         ISE.ID_SERVICIO
       FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC,
         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
         DB_COMERCIAL.ADMI_PRODUCTO AP,
         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
         DB_COMERCIAL.INFO_SERVICIO ISE 
        WHERE AC.ID_CARACTERISTICA              = APC.CARACTERISTICA_ID
          AND AP.ID_PRODUCTO                    = APC.PRODUCTO_ID
          AND ISPC.PRODUCTO_CARACTERISITICA_ID  = APC.ID_PRODUCTO_CARACTERISITICA
          AND ISE.ID_SERVICIO                   = ISPC.SERVICIO_ID
          AND AC.DESCRIPCION_CARACTERISTICA     IN ('AB-PROMO',
                                                    'PERFIL-PROMO',
                                                    'TRAFFIC-TABLE-PROMO',
                                                    'GEM-PORT-PROMO',
                                                    'LINE-PROFILE-NAME-PROMO',
                                                    'CAPACIDAD1-PROMO',
                                                    'CAPACIDAD2-PROMO')
          AND AP.NOMBRE_TECNICO                 = Cv_NombreTecnicoProd
          AND AC.ESTADO                         = Cv_EstadoActivo
          AND APC.ESTADO                        = Cv_EstadoActivo
          AND ISPC.ESTADO                       = Cv_EstadoActivo
          AND ISE.ID_SERVICIO                   = Cn_IdServicio;

    Lc_CaracteristicasPromo    C_ObtieneCaractPromo%ROWTYPE;
    Lr_InfoServicioProdCaract  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    --
    Le_Exception               EXCEPTION;
    Lv_MsjResultado            VARCHAR2(5000); 
    Lv_EstadoActivo            VARCHAR2(15):= 'Activo';
    Lv_EstadoEliminado         VARCHAR2(15):= 'Eliminado';
    Lv_UsuarioCreacion         VARCHAR2(15):= 'telcos_promo_bw';
    Lv_NombreTecnicoProd       DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE:='INTERNET';
    Lv_IpCreacion              VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
  BEGIN
  --
    IF C_ObtieneCaractPromo%ISOPEN THEN
      CLOSE C_ObtieneCaractPromo;
    END IF;

    FOR Lc_CaracteristicasPromo in C_ObtieneCaractPromo(Pn_IdServicio,
                                                        Lv_NombreTecnicoProd, 
                                                        Lv_EstadoActivo) 
    LOOP
      --
      Lr_InfoServicioProdCaract                          := NULL;
      Lr_InfoServicioProdCaract.ID_SERVICIO_PROD_CARACT  := Lc_CaracteristicasPromo.ID_SERVICIO_PROD_CARACT;
      Lr_InfoServicioProdCaract.ESTADO                   := Lv_EstadoEliminado;
      Lr_InfoServicioProdCaract.USR_ULT_MOD              := Lv_UsuarioCreacion;

      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.P_ACTUALIZA_CARACT_PROMO_BW(Lr_InfoServicioProdCaract,Lv_MsjResultado);
      --
      IF Lv_MsjResultado IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;
      --
    END LOOP;     
    --
  EXCEPTION
  WHEN Le_Exception THEN
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso de eliminar características promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_ELIMINA_CARACT_PROMO_BW', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
   Pv_MsjResultado:= Lv_MsjResultado;
   --
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso de eliminar características promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_ELIMINA_CARACT_PROMO_BW', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
    Pv_MsjResultado:= Lv_MsjResultado;
    --
  END P_ELIMINA_CARACT_PROMO_BW;
  --
  --
  PROCEDURE P_VALIDA_ELIMINA_CARACT_BW (Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                        Pv_TipoPromo       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pb_EliminaCaract  OUT BOOLEAN) 
  IS
    --Costo C_ObtieneMaxMapeo: 2
    CURSOR C_ObtieneMaxMapeo (Cn_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_TipoPromo     DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Cv_EstadoBaja    DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE)
    IS  
      SELECT IDMP.ID_DETALLE_MAPEO,
             IDMP.GRUPO_PROMOCION_ID,
             IDMP.TIPO_PROMOCION_ID,
             IDMP.PUNTO_ID,
             IDMP.FE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
      WHERE IDMP.ID_DETALLE_MAPEO = (SELECT MAX(IDMPMAX.ID_DETALLE_MAPEO)
                                     FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDMPMAX,
                                          DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMSMAX
                                     WHERE IDMPMAX.ID_DETALLE_MAPEO         = IDMSMAX.DETALLE_MAPEO_ID            
                                       AND IDMPMAX.TIPO_PROMOCION           = Cv_TipoPromo
                                       AND IDMPMAX.ESTADO                   <>Cv_EstadoBaja
                                       AND IDMSMAX.SERVICIO_ID              = Cn_IdServicio);

    Lc_MaxDetalleMapeo         C_ObtieneMaxMapeo%ROWTYPE;
    Lb_Elimina                 BOOLEAN:= FALSE;
    Lv_MsjResultado            VARCHAR2(5000); 
    Lv_UsuarioCreacion         VARCHAR2(15):= 'telcos_promo_bw';
    Lv_EstadoBaja              VARCHAR2(15):= 'Baja';
    Lv_IpCreacion              VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
    --
  BEGIN
  --
    IF C_ObtieneMaxMapeo%ISOPEN THEN
      CLOSE C_ObtieneMaxMapeo;
    END IF;

    OPEN C_ObtieneMaxMapeo(Pn_IdServicio,
                           Pv_TipoPromo,
                           Lv_EstadoBaja);

    FETCH C_ObtieneMaxMapeo INTO Lc_MaxDetalleMapeo;

    IF C_ObtieneMaxMapeo%FOUND AND TO_CHAR(SYSDATE,'RRRR-MM-DD') > TO_CHAR(Lc_MaxDetalleMapeo.FE_MAPEO,'RRRR-MM-DD') THEN
      --
      Lb_Elimina:= TRUE;
      --
    END IF;

    CLOSE C_ObtieneMaxMapeo;
    --
    Pb_EliminaCaract:= Lb_Elimina;
    --
  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso que valida si elimina las características promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_VALIDA_ELIMINA_CARACT_BW', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
    Pb_EliminaCaract:= FALSE;
    --
  END P_VALIDA_ELIMINA_CARACT_BW;
  --
  --
  PROCEDURE P_ACTUALIZA_CARACT_PROMO_BW(Pr_InfoServicioProdCaract   IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE,
                                        Pv_MsjResultado            OUT  VARCHAR2) 
  IS

  BEGIN
    --Actualización de las características promocionales de un servicio.
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      SET SERVICIO_ID                  = NVL(Pr_InfoServicioProdCaract.SERVICIO_ID,SERVICIO_ID),
          PRODUCTO_CARACTERISITICA_ID  = NVL(Pr_InfoServicioProdCaract.PRODUCTO_CARACTERISITICA_ID,PRODUCTO_CARACTERISITICA_ID),
          VALOR                        = NVL(Pr_InfoServicioProdCaract.VALOR,VALOR),
          FE_CREACION                  = NVL(Pr_InfoServicioProdCaract.FE_CREACION,FE_CREACION),
          FE_ULT_MOD                   = SYSDATE,
          USR_CREACION                 = NVL(Pr_InfoServicioProdCaract.USR_CREACION,USR_CREACION),
          USR_ULT_MOD                  = NVL(Pr_InfoServicioProdCaract.USR_ULT_MOD,USR_ULT_MOD),
          ESTADO                       = NVL(Pr_InfoServicioProdCaract.ESTADO,ESTADO),
          REF_SERVICIO_PROD_CARACT_ID  = NVL(Pr_InfoServicioProdCaract.REF_SERVICIO_PROD_CARACT_ID,REF_SERVICIO_PROD_CARACT_ID)
    WHERE (ID_SERVICIO_PROD_CARACT = Pr_InfoServicioProdCaract.ID_SERVICIO_PROD_CARACT);

  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Método: P_UPDATE_CARACTERISTICA_PROMO, Error: '||SUBSTR(SQLERRM,0,2000);

  END P_ACTUALIZA_CARACT_PROMO_BW;
  --
  --
  PROCEDURE P_INSERT_ISERVICIO_PROD_CARACT(Pr_InfoServProdCaract IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE,
                                           Pv_Mensaje            OUT VARCHAR2) IS

  BEGIN

    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT (
      ID_SERVICIO_PROD_CARACT,
      SERVICIO_ID,
      PRODUCTO_CARACTERISITICA_ID,
      VALOR,
      FE_CREACION,
      USR_CREACION,
      ESTADO
    ) VALUES (
      Pr_InfoServProdCaract.ID_SERVICIO_PROD_CARACT,
      Pr_InfoServProdCaract.SERVICIO_ID,
      Pr_InfoServProdCaract.PRODUCTO_CARACTERISITICA_ID,
      Pr_InfoServProdCaract.VALOR,
      Pr_InfoServProdCaract.FE_CREACION,
      Pr_InfoServProdCaract.USR_CREACION,
      Pr_InfoServProdCaract.ESTADO
    );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_INSERT_ISERVICIO_PROD_CARACT, Error: '||SUBSTR(SQLERRM,0,2000);
  END P_INSERT_ISERVICIO_PROD_CARACT;
  --
  --
  PROCEDURE P_ELIMINA_CARACT_INDV_BW (Pn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_NombreCaract    IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Pv_MsjResultado    OUT VARCHAR2) 
  IS                                    
    --Costo C_ObtieneCaractPromo: 7
    CURSOR C_ObtieneCaractPromo (Cn_IdServicio         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Cv_NombreTecnicoProd  DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                 Cv_EstadoActivo       VARCHAR2)
    IS  
       SELECT ISPC.ID_SERVICIO_PROD_CARACT,
         ISE.ID_SERVICIO
       FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC,
         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
         DB_COMERCIAL.ADMI_PRODUCTO AP,
         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
         DB_COMERCIAL.INFO_SERVICIO ISE 
        WHERE AC.ID_CARACTERISTICA              = APC.CARACTERISTICA_ID
          AND AP.ID_PRODUCTO                    = APC.PRODUCTO_ID
          AND ISPC.PRODUCTO_CARACTERISITICA_ID  = APC.ID_PRODUCTO_CARACTERISITICA
          AND ISE.ID_SERVICIO                   = ISPC.SERVICIO_ID
          AND AC.DESCRIPCION_CARACTERISTICA     = Pv_NombreCaract
          AND AP.NOMBRE_TECNICO                 = Cv_NombreTecnicoProd
          AND AC.ESTADO                         = Cv_EstadoActivo
          AND APC.ESTADO                        = Cv_EstadoActivo
          AND ISPC.ESTADO                       = Cv_EstadoActivo
          AND ISE.ID_SERVICIO                   = Cn_IdServicio;

    Lc_CaracteristicasPromo    C_ObtieneCaractPromo%ROWTYPE;
    Lr_InfoServicioProdCaract  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    --
    Le_Exception               EXCEPTION;
    Lv_MsjResultado            VARCHAR2(5000); 
    Lv_EstadoActivo            VARCHAR2(15):= 'Activo';
    Lv_EstadoEliminado         VARCHAR2(15):= 'Eliminado';
    Lv_UsuarioCreacion         VARCHAR2(15):= 'telcos_promo_bw';
    Lv_NombreTecnicoProd       DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE:='INTERNET';
    Lv_IpCreacion              VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  --
  BEGIN
  --
    IF C_ObtieneCaractPromo%ISOPEN THEN
      CLOSE C_ObtieneCaractPromo;
    END IF;

    IF Pn_IdServicio IS NULL OR Pv_NombreCaract IS NULL THEN
      Lv_MsjResultado := 'Parámetros incompletos';
      RAISE Le_Exception;
    END IF;

    FOR Lc_CaracteristicasPromo in C_ObtieneCaractPromo(Pn_IdServicio,Lv_NombreTecnicoProd,Lv_EstadoActivo) 
    LOOP
      --
      Lr_InfoServicioProdCaract                          := NULL;
      Lr_InfoServicioProdCaract.ID_SERVICIO_PROD_CARACT  := Lc_CaracteristicasPromo.ID_SERVICIO_PROD_CARACT;
      Lr_InfoServicioProdCaract.ESTADO                   := Lv_EstadoEliminado;
      Lr_InfoServicioProdCaract.USR_ULT_MOD              := Lv_UsuarioCreacion;

      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.P_ACTUALIZA_CARACT_PROMO_BW(Lr_InfoServicioProdCaract,Lv_MsjResultado);
      --
      IF Lv_MsjResultado IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso de eliminar características promocionales para el servicio: '
                         ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_PROMOCIONES_UTIL_REG.P_ELIMINA_CARACT_INDV_BW', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           Lv_UsuarioCreacion,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
     Pv_MsjResultado:= Lv_MsjResultado;
   --
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso de eliminar características promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_ELIMINA_CARACT_INDV_BW', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
    Pv_MsjResultado:= Lv_MsjResultado;
    --
  END P_ELIMINA_CARACT_INDV_BW;
  --
  --
  PROCEDURE P_CREA_CARACT_INDV_BW(Pn_IdServicio   IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Pv_NombreCaract IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                  Pv_ValorCaract  IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                  Pv_MsjResultado OUT VARCHAR2)
  IS                                    
    --Cursor que obtiene el producto característica.
    --Costo Query: 10
    CURSOR C_AdmiProdCaract(Cv_NombreTecnico  VARCHAR2,
                            Cv_CodEmpresa     VARCHAR2,
                            Cv_Caracteristica VARCHAR2,
                            Cv_Estado         VARCHAR2)
    IS
      SELECT APCAR.*
          FROM DB_COMERCIAL.ADMI_PRODUCTO                ADPRO,
               DB_COMERCIAL.ADMI_CARACTERISTICA          ADCARCT,
               DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APCAR
      WHERE APCAR.PRODUCTO_ID           = ADPRO.ID_PRODUCTO
        AND APCAR.CARACTERISTICA_ID     = ADCARCT.ID_CARACTERISTICA
        AND UPPER(ADPRO.NOMBRE_TECNICO) = UPPER(Cv_NombreTecnico)
        AND ADPRO.EMPRESA_COD           = Cv_CodEmpresa
        AND UPPER(ADCARCT.ESTADO)       = UPPER(Cv_Estado)
        AND UPPER(APCAR.ESTADO)         = UPPER(Cv_Estado)
        AND UPPER(ADCARCT.DESCRIPCION_CARACTERISTICA) = UPPER(Cv_Caracteristica);

    --Variables Locales
    Le_Exception           EXCEPTION;
    Lv_MsjResultado        VARCHAR2(5000);
    Lv_UsuarioCreacion     VARCHAR2(15):= 'telcos_promo_bw';
    Lc_AdmiProdCaract      C_AdmiProdCaract%ROWTYPE;
    Lr_InfoServProdCaract  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lb_TieneDatos          BOOLEAN;
    Lv_IpCreacion          VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
  BEGIN

    IF C_AdmiProdCaract%ISOPEN THEN
      CLOSE C_AdmiProdCaract;
    END IF;

    IF Pn_IdServicio IS NULL OR Pv_NombreCaract IS NULL THEN
      Lv_MsjResultado := 'Parámetros incompletos';
      RAISE Le_Exception;
    END IF;

    OPEN C_AdmiProdCaract('INTERNET','18',Pv_NombreCaract,'Activo');
      FETCH C_AdmiProdCaract INTO Lc_AdmiProdCaract;
        Lb_TieneDatos := C_AdmiProdCaract%NOTFOUND;
    CLOSE C_AdmiProdCaract;

    IF Lb_TieneDatos THEN
      Lv_MsjResultado := 'La característica: '||Pv_NombreCaract||' no se encuentra configurada.';
      RAISE Le_Exception;
    END IF;

    Lr_InfoServProdCaract                             :=  NULL;
    Lr_InfoServProdCaract.ESTADO                      := 'Activo';
    Lr_InfoServProdCaract.ID_SERVICIO_PROD_CARACT     :=  DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL;
    Lr_InfoServProdCaract.SERVICIO_ID                 :=  Pn_IdServicio;
    Lr_InfoServProdCaract.PRODUCTO_CARACTERISITICA_ID :=  Lc_AdmiProdCaract.ID_PRODUCTO_CARACTERISITICA;
    Lr_InfoServProdCaract.VALOR                       :=  Pv_ValorCaract;
    Lr_InfoServProdCaract.FE_CREACION                 :=  SYSDATE;
    Lr_InfoServProdCaract.USR_CREACION                :=  Lv_UsuarioCreacion;

    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.P_INSERT_ISERVICIO_PROD_CARACT(Lr_InfoServProdCaract,Lv_MsjResultado);

    IF Lv_MsjResultado IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso de eliminar características promocionales para el servicio: '
                         ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_PROMOCIONES_UTIL_REG.P_CREA_CARACT_INDV_BW', 
                                            Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            Lv_UsuarioCreacion,
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
   Pv_MsjResultado:= Lv_MsjResultado;
   --
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso de eliminar características promocionales para el servicio: '
                         ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_PROMOCIONES_UTIL_REG.P_CREA_CARACT_INDV_BW', 
                                            Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            Lv_UsuarioCreacion,
                                            SYSDATE,
                                            Lv_IpCreacion);
    Pv_MsjResultado:= Lv_MsjResultado;
    --
  END P_CREA_CARACT_INDV_BW;
  --
  --
  FUNCTION F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN BOOLEAN 
  IS

    --Costo: 18
    CURSOR C_TipoNegocioInsABan(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                Cn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      --
      SELECT 'X' AS VALOR 
      FROM DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_TIPO_NEGOCIO ATN,
        (SELECT REGEXP_SUBSTR(T.VALOR,'[^,]+', 1, LEVEL) AS VALOR
         FROM(SELECT ATPR.VALOR
              FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
                DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                DB_COMERCIAL.ADMI_CARACTERISTICA       AC
              WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_TIPO_NEGOCIO' 
              AND AC.ID_CARACTERISTICA            = ATPR.CARACTERISTICA_ID
              AND ATPR.ESTADO                     != 'Eliminado'
              AND ATPR.TIPO_PROMOCION_ID          = ATP.ID_TIPO_PROMOCION
              AND ATP.GRUPO_PROMOCION_ID          = Cn_IntIdPromocion ) T
         CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T1
       WHERE TO_NUMBER(TRIM(T1.VALOR)) = ATN.ID_TIPO_NEGOCIO
       AND ATN.EMPRESA_COD             = Cv_CodEmpresa
       AND ATN.NOMBRE_TIPO_NEGOCIO     = IPC.TIPO
       AND AP.CODIGO_PRODUCTO          = 'INTD'
       AND AP.ID_PRODUCTO              = IPD.PRODUCTO_ID
       AND IPD.PLAN_ID                 = IPC.ID_PLAN
       AND IPC.ID_PLAN                 = ISER.PLAN_ID
       AND ISER.ID_SERVICIO            = Cn_IdServicio;

    Lb_Aplica               BOOLEAN := TRUE;
    Lv_ExisteTipoNegocio    VARCHAR2(1); 
    Lv_MsjResultado         VARCHAR2(2000); 

  BEGIN
  --
    IF C_TipoNegocioInsABan%ISOPEN THEN
    --
      CLOSE C_TipoNegocioInsABan;
    --
    END IF;

    OPEN C_TipoNegocioInsABan(Fn_IntIdPromocion,
                              Fn_IdServicio,
                              Fv_CodEmpresa);
    --
    FETCH C_TipoNegocioInsABan INTO Lv_ExisteTipoNegocio;
    --
    CLOSE C_TipoNegocioInsABan;

    IF Lv_ExisteTipoNegocio IS NULL THEN
      Lb_Aplica := FALSE;
    ELSE
      Lb_Aplica := TRUE;
    END IF;

    RETURN Lb_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Tipo de Negocio del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el Servicio: ' || Fn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_TIPO_NEGOCIO', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_TIPO_NEGOCIO;
  --
  --
  FUNCTION F_VALIDA_ULTIMA_MILLA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN BOOLEAN 
  IS

    --Costo: 15
    CURSOR C_UltimaMillaInsABan(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT REGEXP_SUBSTR(T.VALOR,'[^,]+', 1, LEVEL) AS VALOR
      FROM(SELECT ATPR.VALOR
           FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
             DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
             DB_COMERCIAL.ADMI_CARACTERISTICA       AC
           WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_ULTIMA_MILLA' 
           AND AC.ID_CARACTERISTICA            = ATPR.CARACTERISTICA_ID
           AND ATPR.ESTADO                     != 'Eliminado'
           AND ATPR.TIPO_PROMOCION_ID          = ATP.ID_TIPO_PROMOCION
           AND ATP.GRUPO_PROMOCION_ID          = Cn_IntIdPromocion ) T
      CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL;

    --Costo: 18
    CURSOR C_UltimaMillaPunto(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS      
      SELECT IST.ULTIMA_MILLA_ID
      FROM DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
      WHERE AP.CODIGO_PRODUCTO      = 'INTD'
      AND AP.ID_PRODUCTO            = IPD.PRODUCTO_ID
      AND IPD.PLAN_ID               = ISER.PLAN_ID
      AND IST.SERVICIO_ID           = ISER.ID_SERVICIO
      AND ISER.PUNTO_FACTURACION_ID IS NOT NULL
      AND ISER.ID_SERVICIO          = Cn_IdServicio;

    Lb_Aplica               BOOLEAN := FALSE;
    Lv_MsjResultado         VARCHAR2(2000);
    Lc_UltimaMillaPunto     C_UltimaMillaPunto%ROWTYPE;


  BEGIN
  --
    IF C_UltimaMillaPunto%ISOPEN THEN
    --
      CLOSE C_UltimaMillaPunto;
    --
    END IF;

    OPEN C_UltimaMillaPunto(Fn_IdServicio);
    --
    FETCH C_UltimaMillaPunto INTO Lc_UltimaMillaPunto;
    --
      FOR Lc_UltimaMillaInsABan IN C_UltimaMillaInsABan(Fn_IntIdPromocion)
      LOOP

       IF TO_NUMBER(TRIM(Lc_UltimaMillaInsABan.VALOR)) = NVL(Lc_UltimaMillaPunto.ULTIMA_MILLA_ID,0) THEN
         Lb_Aplica := TRUE;
         RETURN Lb_Aplica;
       END IF;

      END LOOP;
    --
    CLOSE C_UltimaMillaPunto;

    RETURN Lb_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Última Milla del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el Servicio: ' || Fn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_ULTIMA_MILLA', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_ULTIMA_MILLA;
  --
  --
  FUNCTION F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN
  IS

   --Costo: 2
   CURSOR C_TipoPomocion(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT CODIGO_TIPO_PROMOCION 
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION 
      WHERE GRUPO_PROMOCION_ID = Cn_IntIdPromocion;

    --Costo: 2
    CURSOR C_FormaPagoMens(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS   
      SELECT T1.VALOR AS FORMA_PAGO, 
        NVL((SELECT AGPR.VALOR
             FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
               DB_COMERCIAL.ADMI_CARACTERISTICA           AC
             WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_EMISOR' 
               AND AC.ID_CARACTERISTICA          = AGPR.CARACTERISTICA_ID
               AND AGPR.ESTADO                   != 'Eliminado'
               AND AGPR.GRUPO_PROMOCION_ID       = Cn_IntIdPromocion),0)AS EMISOR 
      FROM (SELECT REGEXP_SUBSTR(T.VALOR,'[^,]+', 1, LEVEL) AS VALOR
            FROM(SELECT AGPR.VALOR
                 FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
                   DB_COMERCIAL.ADMI_CARACTERISTICA           AC
                 WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_FORMA_PAGO' 
                   AND AC.ID_CARACTERISTICA          = AGPR.CARACTERISTICA_ID
                   AND AGPR.ESTADO                   != 'Eliminado'
                   AND AGPR.GRUPO_PROMOCION_ID       = Cn_IntIdPromocion)T
            CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T1;

    --Costo: 3
    CURSOR C_FormaPagoInsABan(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT T1.VALOR AS FORMA_PAGO, 
        NVL((SELECT ATPR.VALOR
             FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
               DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
               DB_COMERCIAL.ADMI_CARACTERISTICA       AC
             WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_EMISOR' 
               AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
               AND ATPR.ESTADO                   != 'Eliminado'
               AND ATPR.TIPO_PROMOCION_ID        = ATP.ID_TIPO_PROMOCION
               AND ATP.GRUPO_PROMOCION_ID        = Cn_IntIdPromocion),0)AS EMISOR 
      FROM (SELECT REGEXP_SUBSTR(T.VALOR,'[^,]+', 1, LEVEL) AS VALOR
            FROM(SELECT ATPR.VALOR
                 FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
                   DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                   DB_COMERCIAL.ADMI_CARACTERISTICA       AC
                 WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_FORMA_PAGO' 
                   AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
                   AND ATPR.ESTADO                   != 'Eliminado'
                   AND ATPR.TIPO_PROMOCION_ID        = ATP.ID_TIPO_PROMOCION
                   AND ATP.GRUPO_PROMOCION_ID        = Cn_IntIdPromocion)T
            CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T1;

    --Costo: 6
    CURSOR C_FormaPagoPunto(Cn_IdPunto       DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cv_CodTipoPromo  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                            Cv_Estado        DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE)
    IS
      SELECT IC.FORMA_PAGO_ID
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      WHERE IC.ID_CONTRATO IN (SELECT MAX(DBIC.ID_CONTRATO) AS ID_CONTRATO
                               FROM DB_COMERCIAL.INFO_PUNTO IP, 
                                 DB_COMERCIAL.INFO_CONTRATO DBIC
                               WHERE DBIC.PERSONA_EMPRESA_ROL_ID = IP.PERSONA_EMPRESA_ROL_ID
                               AND IP.ID_PUNTO                   = Cn_IdPunto
                               AND UPPER(DBIC.ESTADO)            = UPPER(Cv_Estado));

    --Costo: 9
    CURSOR C_BancoTipoCuenta(Cn_IdPunto       DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Cv_CodTipoPromo  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                             Cv_Estado        DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE)
    IS        
      SELECT ICFP.BANCO_TIPO_CUENTA_ID 
      FROM DB_COMERCIAL.INFO_CONTRATO         IC,
        DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP
      WHERE ICFP.CONTRATO_ID = IC.ID_CONTRATO
      AND IC.ID_CONTRATO     IN (SELECT MAX(DBIC.ID_CONTRATO) AS ID_CONTRATO
                                 FROM DB_COMERCIAL.INFO_PUNTO IP, 
                                   DB_COMERCIAL.INFO_CONTRATO DBIC
                                 WHERE DBIC.PERSONA_EMPRESA_ROL_ID = IP.PERSONA_EMPRESA_ROL_ID
                                 AND IP.ID_PUNTO                   = Cn_IdPunto
                                 AND UPPER(DBIC.ESTADO)            = UPPER(Cv_Estado));

    --Costo: 2
    CURSOR C_ExisteBancoTipoCta(Cv_Valores VARCHAR2,
                                Cn_Valor   NUMBER)
    IS
      SELECT COUNT('X') AS VALOR
      FROM (SELECT REGEXP_SUBSTR (Cv_Valores,'[^,]+',1, LEVEL) VALOR FROM DUAL
            CONNECT BY REGEXP_SUBSTR (Cv_Valores,'[^,]+',1, LEVEL) IS NOT NULL) T
      WHERE Cn_Valor IN (COALESCE(TO_NUMBER(REGEXP_SUBSTR(T.VALOR,'^\d+')),0));

    Lc_Tipo_Pomocion      C_TipoPomocion%ROWTYPE;
    Lc_Forma_Pago_Punto   C_FormaPagoPunto%ROWTYPE;
    Lc_Banco_Tipo_Cuenta  C_BancoTipoCuenta%ROWTYPE;
    Ln_ExisteBancoTipoCta NUMBER;
    Lb_Aplica             BOOLEAN := FALSE;
    Lv_MsjResultado       VARCHAR2(2000);
    Lv_Estado             DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE;

  BEGIN

    IF C_TipoPomocion%ISOPEN THEN
    --
      CLOSE C_TipoPomocion;
    --
    END IF;

    IF C_FormaPagoPunto%ISOPEN THEN
    --
      CLOSE C_FormaPagoPunto;
    --
    END IF;

    IF C_ExisteBancoTipoCta%ISOPEN THEN
    --
      CLOSE C_ExisteBancoTipoCta;
    --
    END IF;

    IF C_BancoTipoCuenta%ISOPEN THEN
    --
      CLOSE C_BancoTipoCuenta;
    --
    END IF;

    Lv_Estado := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_ESTADO_CONTRATO (Fn_IdPunto);

    OPEN C_TipoPomocion(Fn_intIdPromocion);
    --
    FETCH C_TipoPomocion INTO Lc_Tipo_Pomocion;
    --
      IF Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION = 'PROM_INS' OR Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION = 'PROM_BW' THEN
        OPEN C_FormaPagoPunto(Fn_IdPunto,Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION,Lv_Estado);
        --
        FETCH C_FormaPagoPunto INTO Lc_Forma_Pago_Punto;
        --
          FOR Lc_FormaPago_Ins_ABan IN C_FormaPagoInsABan (Cn_IntIdPromocion => Fn_intIdPromocion)
          LOOP
          --
            IF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Ins_ABan.FORMA_PAGO,'^\d+')),0) = Lc_Forma_Pago_Punto.FORMA_PAGO_ID
               AND Lc_Forma_Pago_Punto.FORMA_PAGO_ID = 3 THEN
              OPEN C_BancoTipoCuenta(Fn_IdPunto,Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION,Lv_Estado);
              --
              FETCH C_BancoTipoCuenta INTO Lc_Banco_Tipo_Cuenta;
              --
                OPEN C_ExisteBancoTipoCta(Lc_FormaPago_Ins_ABan.EMISOR,
                                          Lc_Banco_Tipo_Cuenta.BANCO_TIPO_CUENTA_ID);
                --
                FETCH C_ExisteBancoTipoCta INTO Ln_ExisteBancoTipoCta ;
                --
                  IF Ln_ExisteBancoTipoCta > 0 THEN
                    Lb_Aplica := TRUE;
                    RETURN Lb_Aplica;
                  END IF;
                --
                CLOSE C_ExisteBancoTipoCta;
              --
              CLOSE C_BancoTipoCuenta;
            ELSIF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Ins_ABan.FORMA_PAGO,'^\d+')),0) = Lc_Forma_Pago_Punto.FORMA_PAGO_ID THEN
              Lb_Aplica := TRUE;
              RETURN Lb_Aplica;
            END IF;
          --
          END LOOP;
        --
        CLOSE C_FormaPagoPunto;
      --
      ELSE
      --
        OPEN C_FormaPagoPunto(Fn_IdPunto,Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION,Lv_Estado);
        --
        FETCH C_FormaPagoPunto INTO Lc_Forma_Pago_Punto;
        --
          FOR Lc_FormaPago_Mens IN C_FormaPagoMens (Cn_IntIdPromocion => Fn_intIdPromocion)
          LOOP
          --
            IF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Mens.FORMA_PAGO,'^\d+')),0) = Lc_Forma_Pago_Punto.FORMA_PAGO_ID 
               AND Lc_Forma_Pago_Punto.FORMA_PAGO_ID = 3 THEN
              OPEN C_BancoTipoCuenta(Fn_IdPunto,Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION,Lv_Estado);
              --
              FETCH C_BancoTipoCuenta INTO Lc_Banco_Tipo_Cuenta;
              --
                OPEN C_ExisteBancoTipoCta(Lc_FormaPago_Mens.EMISOR,
                                          Lc_Banco_Tipo_Cuenta.BANCO_TIPO_CUENTA_ID);
                --
                FETCH C_ExisteBancoTipoCta INTO Ln_ExisteBancoTipoCta ;
                --
                  IF Ln_ExisteBancoTipoCta > 0 THEN
                    Lb_Aplica := TRUE;
                    RETURN Lb_Aplica;
                  END IF;
                --
                CLOSE C_ExisteBancoTipoCta;
              --
              CLOSE C_BancoTipoCuenta;
            ELSIF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Mens.FORMA_PAGO,'^\d+')),0) = Lc_Forma_Pago_Punto.FORMA_PAGO_ID THEN
              Lb_Aplica := TRUE;
              RETURN Lb_Aplica;
            END IF;
          --
          END LOOP;
        --
        CLOSE C_FormaPagoPunto;

      END IF;
    --
    CLOSE C_TipoPomocion;
    RETURN Lb_Aplica;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Forma de Pago del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_FORMA_PAGO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_FORMA_PAGO;
  --
  --
  FUNCTION F_VALIDA_PERMANENCIA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                Fv_Tipo_Promocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN
  IS

    --Costo: 11
    CURSOR C_FechaConfirmacion(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT TO_CHAR(MIN(ISH.FE_CREACION),'DD-MM-YYYY') AS FECHA
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD ON IPD.PLAN_ID=ISER.PLAN_ID
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO=IPD.PRODUCTO_ID
      WHERE ISER.PUNTO_ID             = Cn_IdPunto
        AND AP.CODIGO_PRODUCTO        = 'INTD'
        AND ISH.ESTADO                = 'Activo'
        AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;

    --Costo: 5
    CURSOR C_PermanenciaMinima(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Cv_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    IS  
      SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(ATPR.VALOR,'^\d+')),0) AS VALOR
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA       AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_PERMANENCIA_MINIMA'
        AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
        AND ATPR.ESTADO                   != 'Eliminado'
        AND ATPR.TIPO_PROMOCION_ID        = ATP.ID_TIPO_PROMOCION
        AND ATP.CODIGO_TIPO_PROMOCION     = Cv_Tipo_Promocion
        AND ATP.ESTADO                    != 'Eliminado'
        AND ATP.GRUPO_PROMOCION_ID        = Cn_IntIdPromocion;

    Lc_PermanenciaMinima  C_PermanenciaMinima%ROWTYPE;
    Ln_Meses              NUMBER;
    Lb_Aplica             BOOLEAN := FALSE;
    Lv_MsjResultado       VARCHAR2(2000);
    Lv_FechaActual        VARCHAR2(10) := TO_CHAR(TRUNC(SYSDATE),'DD-MM-YYYY');
    Lc_FechaConfirmacion  C_FechaConfirmacion%ROWTYPE;

  BEGIN

    IF C_FechaConfirmacion%ISOPEN THEN
    --
      CLOSE C_FechaConfirmacion;
    --
    END IF;
    --
    IF C_PermanenciaMinima%ISOPEN THEN
    --
      CLOSE C_PermanenciaMinima;
    --
    END IF;
    --
    OPEN C_FechaConfirmacion(Fn_IdPunto);
    --
    FETCH C_FechaConfirmacion INTO Lc_FechaConfirmacion;
    --
      IF Lv_FechaActual = Lc_FechaConfirmacion.FECHA THEN
        Lb_Aplica := TRUE; --Aplica para Clientes nuevos
      ELSE
      --
        Ln_Meses := TRUNC(MONTHS_BETWEEN (TO_DATE(TRUNC(sysdate),'DD-MM-YY'),TO_DATE(Lc_FechaConfirmacion.FECHA,'DD-MM-YY')));

        OPEN C_PermanenciaMinima(Fn_IntIdPromocion,
                                 Fv_Tipo_Promocion);
        --
        FETCH C_PermanenciaMinima INTO Lc_PermanenciaMinima;
        --
          IF Lc_PermanenciaMinima.VALOR IS NOT NULL THEN
          --
            IF Lc_PermanenciaMinima.VALOR <= Ln_Meses THEN
              Lb_Aplica := TRUE;
            END IF;
          --
          ELSE
            Lb_Aplica := TRUE; --APLICA PARA DESCUENTO TOTAL
          END IF;
        --
      CLOSE C_PermanenciaMinima;
      --
      END IF;
    --
    CLOSE C_FechaConfirmacion;
    --
    RETURN Lb_Aplica;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Permanencia Mínima del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' - ' || Fv_Tipo_Promocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_PERMANENCIA', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_PERMANENCIA;
  --
  --
  FUNCTION F_VALIDA_MORA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                         Fv_Tipo_Promocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                         Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN
  IS

    --Costo: 5
    CURSOR C_PierdeMora(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                        Cv_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    IS  
      SELECT NVL(TRIM(ATPR.VALOR),'NO') AS VALOR
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA       AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_PIERDE_PROMOCION_MORA'
        AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
        AND ATPR.ESTADO                   != 'Eliminado'
        AND ATPR.TIPO_PROMOCION_ID        = ATP.ID_TIPO_PROMOCION
        AND ATP.CODIGO_TIPO_PROMOCION     = Cv_Tipo_Promocion
        AND ATP.ESTADO                    != 'Eliminado'
        AND ATP.GRUPO_PROMOCION_ID        = Cn_IntIdPromocion;

    --Costo: 5
    CURSOR C_DiasMora(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                      Cv_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    IS 
      SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(ATPR.VALOR,'^\d+')),0) AS VALOR
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA       AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_DIAS_MORA'
        AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
        AND ATPR.ESTADO                   != 'Eliminado'
        AND ATPR.TIPO_PROMOCION_ID        = ATP.ID_TIPO_PROMOCION
        AND ATP.CODIGO_TIPO_PROMOCION     = Cv_Tipo_Promocion
        AND ATP.ESTADO                    != 'Eliminado'
        AND ATP.GRUPO_PROMOCION_ID        = Cn_IntIdPromocion;

    --Costo: 12
    CURSOR C_TieneMora(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                       Cn_Dias    NUMBER)
    IS        
      SELECT DISTINCT 'X' AS VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD ON IPD.PLAN_ID = ISER.PLAN_ID
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO = IPD.PRODUCTO_ID
      WHERE ISER.PUNTO_ID             = Cn_IdPunto
        AND AP.CODIGO_PRODUCTO        = 'INTD'
        AND UPPER(TRIM(ISH.ESTADO))   = 'IN-CORTE'
        AND TRUNC(ISH.FE_CREACION)    BETWEEN TRUNC(SYSDATE)-Cn_Dias AND TRUNC(SYSDATE)
        AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;

    Lc_Pierde_Mora          C_PierdeMora%ROWTYPE;
    Lc_Dias_Mora            C_DiasMora%ROWTYPE;
    Lb_Aplica               BOOLEAN := TRUE;
    Lv_TieneMora            VARCHAR2(1);
    Lv_MsjResultado         VARCHAR2(2000);

  BEGIN

    IF C_PierdeMora%ISOPEN THEN
    --
      CLOSE C_PierdeMora;
    --
    END IF;

    IF C_DiasMora%ISOPEN THEN
    --
      CLOSE C_DiasMora;
    --
    END IF;

    IF C_TieneMora%ISOPEN THEN
    --
      CLOSE C_TieneMora;
    --
    END IF;

    OPEN C_PierdeMora(Fn_IntIdPromocion,
                      Fv_Tipo_Promocion);
    --
    FETCH C_PierdeMora INTO Lc_Pierde_Mora;
    --
      IF Lc_Pierde_Mora.VALOR = 'SI' THEN
        OPEN C_DiasMora(Fn_IntIdPromocion,
                        Fv_Tipo_Promocion);
        --
        FETCH C_DiasMora INTO Lc_Dias_Mora;
        --
          OPEN C_TieneMora(Fn_IdPunto,
                           Lc_Dias_Mora.VALOR);
          --
          FETCH C_TieneMora INTO Lv_TieneMora;
          --
            IF Lv_TieneMora IS NOT NULL THEN
              Lb_Aplica := FALSE;
              RETURN Lb_Aplica;
            END IF;
          --
          CLOSE C_TieneMora;
        --
        CLOSE C_DiasMora;
      END IF;
    --
    CLOSE C_PierdeMora;
    RETURN Lb_Aplica;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Mora del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' - ' || Fv_Tipo_Promocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_MORA', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_MORA;
  --
  --
  FUNCTION F_VALIDA_ANTIGUEDAD(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN
  IS

    --Costo: 11
    CURSOR C_FechaConfirmacion(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT TO_CHAR(MIN(TRUNC(ISH.FE_CREACION)),'YYYY-MM-DD') AS FECHA
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD ON IPD.PLAN_ID = ISER.PLAN_ID
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO = IPD.PRODUCTO_ID
      WHERE ISER.PUNTO_ID           = Cn_IdPunto
      AND AP.CODIGO_PRODUCTO        = 'INTD'
      AND ISH.ESTADO                = 'Activo'
      AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;

    --Costo: 5
    CURSOR C_Antiguedad(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS  
      SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(ATPR.VALOR,'^\d+')),0) AS VALOR
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION    ATP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA       AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = 'PROM_ANTIGUEDAD'
      AND AC.ID_CARACTERISTICA            = ATPR.CARACTERISTICA_ID
      AND ATPR.ESTADO                     != 'Eliminado'
      AND ATPR.TIPO_PROMOCION_ID          = ATP.ID_TIPO_PROMOCION
      AND ATP.ESTADO                      != 'Eliminado'
      AND ATP.GRUPO_PROMOCION_ID          = Cn_IntIdPromocion;

    Lc_Antiguedad         C_Antiguedad%ROWTYPE;
    Ln_Meses              NUMBER;
    Lb_Aplica             BOOLEAN := FALSE;
    Lv_MsjResultado       VARCHAR2(4000);
    Lc_FechaConfirmacion  C_FechaConfirmacion%ROWTYPE;
    Lv_UsuarioCreacion    VARCHAR2(15) := 'telcos_promo_bw';

  BEGIN

    IF C_FechaConfirmacion%ISOPEN THEN
    --
      CLOSE C_FechaConfirmacion;
    --
    END IF;

    IF C_Antiguedad%ISOPEN THEN
    --
      CLOSE C_Antiguedad;
    --
    END IF;

    OPEN C_FechaConfirmacion(Fn_IdPunto);
    --
    FETCH C_FechaConfirmacion INTO Lc_FechaConfirmacion;
    --
      Ln_Meses := TRUNC(MONTHS_BETWEEN (TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'),'YYYY-MM-DD'),TO_DATE(Lc_FechaConfirmacion.FECHA,'YYYY-MM-DD')));

      OPEN C_Antiguedad(Fn_IntIdPromocion);
      --
      FETCH C_Antiguedad INTO Lc_Antiguedad;
      --
        IF Lc_Antiguedad.VALOR = 0 THEN
          Lb_Aplica := TRUE;
        ELSE
          IF Lc_Antiguedad.VALOR <= Ln_Meses THEN
            Lb_Aplica := TRUE;
          END IF;
        END IF;
      --
      CLOSE C_Antiguedad;
    --
    CLOSE C_FechaConfirmacion;
    --
    RETURN Lb_Aplica;
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Antigüedad del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_ANTIGUEDAD', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_ANTIGUEDAD;
  --
  --
  FUNCTION F_VALIDA_SECTORIZACION_OLT(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                      Fn_IdElemento     IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                      Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN 
  IS

    --Costo: 7
    CURSOR C_SectorizacionABan(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS 
      SELECT SECTORIZACION.ID_SECTORIZACION,
        SECTORIZACION.ID_JURISDICCION,
        NVL(SECTORIZACION.ID_CANTON,'0')ID_CANTON,
        NVL(SECTORIZACION.ID_PARROQUIA,'0')ID_PARROQUIA,
        NVL(SECTORIZACION.ID_SECTOR,'0')ID_SECTOR,
        NVL(SECTORIZACION.ID_ELEMENTO,'0')ID_ELEMENTO,
        NVL(SECTORIZACION.ID_EDIFICIO,'0')ID_EDIFICIO
      FROM (SELECT *
              FROM (SELECT AC.DESCRIPCION_CARACTERISTICA,
                      ATPR.VALOR,
                      ATPR.SECUENCIA ID_SECTORIZACION
                    FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION       ATP,
                      DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA    ATPR,
                      DB_COMERCIAL.ADMI_CARACTERISTICA          AC
                    WHERE ATP.GRUPO_PROMOCION_ID        = Cn_IntIdPromocion
                      AND ATP.ID_TIPO_PROMOCION         = ATPR.TIPO_PROMOCION_ID
                      AND AC.ID_CARACTERISTICA          = ATPR.CARACTERISTICA_ID
                      AND AC.DESCRIPCION_CARACTERISTICA IN ('PROM_JURISDICCION',
                                                            'PROM_CANTON',
                                                            'PROM_PARROQUIA',
                                                            'PROM_SECTOR',
                                                            'PROM_ELEMENTO',
                                                            'PROM_EDIFICIO')
                      AND ATPR.SECUENCIA                IS NOT NULL
                      AND ATPR.ESTADO                   != 'Eliminado') PIVOT ( MAX ( VALOR )
              FOR DESCRIPCION_CARACTERISTICA
              IN ('PROM_JURISDICCION' ID_JURISDICCION, 
                  'PROM_CANTON' ID_CANTON, 
                  'PROM_PARROQUIA' ID_PARROQUIA, 
                  'PROM_SECTOR' ID_SECTOR, 
                  'PROM_ELEMENTO' ID_ELEMENTO,
                  'PROM_EDIFICIO' ID_EDIFICIO ))) SECTORIZACION
      ORDER BY ID_ELEMENTO DESC,
      ID_EDIFICIO DESC,
      ID_SECTOR DESC,
      ID_PARROQUIA DESC,
      ID_CANTON DESC,
      ID_JURISDICCION DESC;

    --Costo: 13
    CURSOR C_SectorizacionElemento(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                   Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DISTINCT ELEM.ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,
        DB_INFRAESTRUCTURA.INFO_UBICACION DBIU,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEM
      WHERE IEEU.EMPRESA_COD   = Cv_CodEmpresa
      AND IEEU.ELEMENTO_ID     = ELEM.ID_ELEMENTO
      AND ELEM.ESTADO          = 'Activo'
      AND ELEM.ID_ELEMENTO     = Cn_IdElemento;

    --Costo:21  
    CURSOR C_SectorizacionPunto(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT DISTINCT IP.PUNTO_COBERTURA_ID AS ID_JURISDICCION,
        APA.CANTON_ID AS ID_CANTON,
        APA.ID_PARROQUIA,
        ASE.ID_SECTOR,
        NVL((SELECT DISTINCT DBRELEM.ELEMENTO_ID_A 
             FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO DBIST,
               DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO DBRELEM,
               DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA,
               DB_COMERCIAL.INFO_SERVICIO ISERV
             WHERE IPDA.DEPENDE_DE_EDIFICIO = 'S'
             AND IPDA.ELEMENTO_ID           = DBRELEM.ELEMENTO_ID_A
             AND IPDA.PUNTO_ID              = ISERV.PUNTO_ID
             AND DBRELEM.ELEMENTO_ID_B      = DBIST.ELEMENTO_CONTENEDOR_ID
             AND DBRELEM.ESTADO             = 'Activo'
             AND DBIST.SERVICIO_ID          = ISERV.ID_SERVICIO
             AND ISERV.ID_SERVICIO          = ISE.ID_SERVICIO),0) AS ID_EDIFICIO
      FROM DB_COMERCIAL.INFO_PUNTO              IP,
        DB_GENERAL.ADMI_PARROQUIA               APA,
        DB_GENERAL.ADMI_SECTOR                  ASE,
        DB_COMERCIAL.INFO_SERVICIO              ISE,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL    ISH,
        DB_COMERCIAL.INFO_SERVICIO_TECNICO      IST,
        DB_COMERCIAL.INFO_PLAN_DET              IPD,
        DB_COMERCIAL.ADMI_PRODUCTO              AP
      WHERE APA.ID_PARROQUIA         = ASE.PARROQUIA_ID
        AND ASE.ID_SECTOR            = IP.SECTOR_ID
        AND IST.SERVICIO_ID          = ISE.ID_SERVICIO
        AND AP.CODIGO_PRODUCTO       = 'INTD'
        AND AP.ID_PRODUCTO           = IPD.PRODUCTO_ID
        AND IPD.PLAN_ID              = ISE.PLAN_ID
        AND ISH.ESTADO               IN (SELECT APD.VALOR1 
                                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                           DB_GENERAL.ADMI_PARAMETRO_DET APD
                                         WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                         AND APD.ESTADO           = 'Activo'
                                         AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                         AND APC.ESTADO           = 'Activo')
        AND ISH.ID_SERVICIO_HISTORIAL = (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) 
                                         FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH
                                         WHERE DBISH.SERVICIO_ID = ISE.ID_SERVICIO)
        AND ISH.SERVICIO_ID           = ISE.ID_SERVICIO
        AND ISE.PUNTO_ID              = IP.ID_PUNTO
        AND IP.ID_PUNTO               = Cn_IdPunto;

    Lc_SectorizacionElemento  C_SectorizacionElemento%ROWTYPE;
    Lc_SectorizacionPunto     C_SectorizacionPunto%ROWTYPE;
    Ln_Contador               NUMBER       := 0;
    Lb_Aplica                 BOOLEAN      := TRUE;
    Lv_UsuarioCreacion        VARCHAR2(15) := 'telcos_promo_bw';
    Lv_MsjResultado           VARCHAR2(4000); 

  BEGIN
  --
    IF C_SectorizacionElemento%ISOPEN THEN
      CLOSE C_SectorizacionElemento;
    END IF;

    OPEN C_SectorizacionElemento(Fn_IdElemento, Fv_CodEmpresa);
    FETCH C_SectorizacionElemento INTO Lc_SectorizacionElemento;
    --
    IF C_SectorizacionElemento%NOTFOUND THEN
      Lb_Aplica:= FALSE;
      return Lb_Aplica;
    END IF;
    --
    OPEN C_SectorizacionPunto(Fn_IdPunto);
    FETCH C_SectorizacionPunto INTO Lc_SectorizacionPunto;

    Ln_Contador := Ln_Contador + 1;

    FOR Lc_SectorizacionABan IN C_SectorizacionABan (Fn_intIdPromocion)
    LOOP
    --
      Lb_Aplica := TRUE;

      IF Lc_SectorizacionABan.ID_ELEMENTO != '0' THEN
      --
        IF Lc_SectorizacionElemento.ID_ELEMENTO = TO_NUMBER(TRIM(Lc_SectorizacionABan.ID_ELEMENTO)) THEN
          Lb_Aplica := TRUE;
          return Lb_Aplica;
        ELSE
          Lb_Aplica := FALSE;
          CONTINUE;
        END IF;
      --
      ELSIF Lc_SectorizacionABan.ID_EDIFICIO != '0' THEN
      --
        IF Lc_SectorizacionPunto.ID_EDIFICIO  = TO_NUMBER(TRIM(Lc_SectorizacionABan.ID_EDIFICIO)) THEN
          Lb_Aplica := TRUE;
          return Lb_Aplica;
        ELSE
          Lb_Aplica := FALSE;
          CONTINUE;
        END IF;
      --
      ELSIF Lc_SectorizacionABan.ID_SECTOR != '0' THEN
      --
        IF Lc_SectorizacionPunto.ID_SECTOR  = TO_NUMBER(TRIM(Lc_SectorizacionABan.ID_SECTOR)) THEN
          Lb_Aplica := TRUE;
          return Lb_Aplica;
        ELSE
          Lb_Aplica := FALSE;
          CONTINUE;
        END IF;
      --
      ELSE
      --
        IF Lc_SectorizacionPunto.ID_JURISDICCION != TO_NUMBER(TRIM(Lc_SectorizacionABan.ID_JURISDICCION)) THEN
          Lb_Aplica := FALSE;
          CONTINUE;
        END IF;

        IF Lc_SectorizacionABan.ID_CANTON != '0' THEN
          IF Lc_SectorizacionPunto.ID_CANTON != TO_NUMBER(TRIM(Lc_SectorizacionABan.ID_CANTON)) THEN
            Lb_Aplica := FALSE;
            CONTINUE;
          END IF;
        ELSE
          RETURN Lb_Aplica;
        END IF;

        IF Lc_SectorizacionABan.ID_PARROQUIA != '0' THEN
          IF Lc_SectorizacionPunto.ID_PARROQUIA != TO_NUMBER(TRIM(Lc_SectorizacionABan.ID_PARROQUIA)) THEN
            Lb_Aplica := FALSE;
            CONTINUE;
          END IF;
        ELSE
          RETURN Lb_Aplica;
        END IF;
      --  
      END IF;

      IF Lb_Aplica THEN
        RETURN Lb_Aplica;
      END IF;
      --
    END LOOP;
    --
    CLOSE C_SectorizacionElemento;
    --
    IF Ln_Contador = 0 THEN
      Lb_Aplica := FALSE;
    END IF;
    --
    RETURN Lb_Aplica;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MsjResultado := 'Ocurrió un error al validar la Regla de Sectorización por OLT del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el Elemento: ' || Fn_IdElemento; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_BW_HEC.F_VALIDA_SECTORIZACION_OLT', 
                                          SUBSTR(Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                          Lv_UsuarioCreacion,
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica:= FALSE;

    RETURN Lb_Aplica;

  END F_VALIDA_SECTORIZACION_OLT;
  --
  --
  FUNCTION F_VALIDA_SECTORIZACION(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN BOOLEAN
  IS

    --Costo: 13
    --Cursor para obtener el servicio 'Activo' del punto cliente.
    CURSOR C_SevicioPunto(Cn_IdPunto      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                          Cv_EstadoActivo VARCHAR2)
    IS
      SELECT ISER.ID_SERVICIO 
        FROM DB_COMERCIAL.INFO_SERVICIO           ISER,
             DB_COMERCIAL.INFO_PLAN_DET           IPD,
             DB_COMERCIAL.ADMI_PRODUCTO           APR,
             DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
      WHERE APR.CODIGO_PRODUCTO = 'INTD'
        AND APR.ID_PRODUCTO     =  IPD.PRODUCTO_ID
        AND IPD.PLAN_ID         =  ISER.PLAN_ID
        AND (ISH.ESTADO         IN (SELECT APD.VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     =  APC.ID_PARAMETRO
                                      AND APD.ESTADO           =  Cv_EstadoActivo
                                      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                      AND APC.ESTADO           =  Cv_EstadoActivo) OR 
            ISER.ESTADO         IN (SELECT APD.VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID     =  APC.ID_PARAMETRO
                                      AND APD.ESTADO           =  Cv_EstadoActivo
                                      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_SERVICIO'
                                      AND APC.ESTADO           =  Cv_EstadoActivo))
        AND ISH.ID_SERVICIO_HISTORIAL IN (
            SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) 
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH
            WHERE DBISH.SERVICIO_ID = ISER.ID_SERVICIO
        )
        AND ISH.SERVICIO_ID = ISER.ID_SERVICIO
        AND ISER.PUNTO_ID   = Cn_IdPunto;

    --Costo: 29
    --Cursor para obtener los datos del servicio y punto del cliente.
    CURSOR C_SectorizacionServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT DISTINCT IP.PUNTO_COBERTURA_ID,
             APA.CANTON_ID AS ID_CANTON,
             APA.ID_PARROQUIA,
             ASE.ID_SECTOR,
             IE.ID_ELEMENTO,
             NVL((SELECT DISTINCT DBRELEM.ELEMENTO_ID_A
                   FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO        DBIST,
                        DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO DBRELEM,
                        DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL    IPDA,
                        DB_COMERCIAL.INFO_SERVICIO                ISERV
                  WHERE IPDA.DEPENDE_DE_EDIFICIO = 'S'
                    AND IPDA.ELEMENTO_ID         =  DBRELEM.ELEMENTO_ID_A
                    AND IPDA.PUNTO_ID            =  ISERV.PUNTO_ID
                    AND DBRELEM.ELEMENTO_ID_B    =  DBIST.ELEMENTO_CONTENEDOR_ID
                    AND DBRELEM.ESTADO           = 'Activo'
                    AND DBIST.SERVICIO_ID        =  ISERV.ID_SERVICIO
                    AND ISERV.ID_SERVICIO        =  ISE.ID_SERVICIO),0) AS EDIFICIO
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

    --Variable Locales
    Lr_Sectorizacion           Tr_SectorizacionInsBwMens;
    Lc_SectorizacionServicio   C_SectorizacionServicio%ROWTYPE;
    Lb_Aplica                  BOOLEAN := FALSE;
    Ln_ExisteSectElemEdif      NUMBER;
    Lv_Error                   VARCHAR2(2000);
    Lex_Exception              EXCEPTION;
    Lr_Sectorizaciones         SYS_REFCURSOR;
    Ln_idServicio              NUMBER;
    Lb_NoTieneDatos            BOOLEAN;
    Ln_IndxSectores            NUMBER;
    Lt_SectorizacionInsBwMens  Tt_SectorizacionInsBwMens;

  BEGIN

    IF C_SectorizacionServicio%ISOPEN THEN
      CLOSE C_SectorizacionServicio;
    END IF;

    IF C_ExisteSectElemEdif%ISOPEN THEN
      CLOSE C_ExisteSectElemEdif;
    END IF;

    --Obtenemos el servicio del cliente.
    IF UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) = 'PROM_MENS' AND Pr_ParametrosValidarSec.ID_PUNTO IS NOT NULL THEN
      OPEN C_SevicioPunto(Pr_ParametrosValidarSec.ID_PUNTO,'Activo');
        FETCH C_SevicioPunto INTO Ln_idServicio;
      CLOSE C_SevicioPunto;
    ELSIF UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) IN ('PROM_INS','PROM_BW') OR
         (UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) = 'PROM_MENS' AND Pr_ParametrosValidarSec.ID_SERVICIO IS NOT NULL) THEN
      Ln_idServicio := Pr_ParametrosValidarSec.ID_SERVICIO;
    ELSE
      Lv_Error := 'Tipo de promocion no contemplada:'
              || '  TIPO_PROMOCION: '     ||Pr_ParametrosValidarSec.TIPO_PROMOCION
              || ', ID_GRUPO_PROMOCION: ' ||Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION
              || ', ID_TIPO_PROMOCION: '  ||Pr_ParametrosValidarSec.ID_TIPO_PROMOCION
              || ', ID_PUNTO: '           ||Pr_ParametrosValidarSec.ID_PUNTO
              || ', ID_SERVICIO: '        ||Pr_ParametrosValidarSec.ID_SERVICIO;
      RAISE Lex_Exception;
    END IF;

    --Cursor para obtener los datos del servicio (Sector del punto, elementos, edificio, etc).
    OPEN C_SectorizacionServicio(Ln_idServicio);
      FETCH C_SectorizacionServicio INTO Lc_SectorizacionServicio;
        Lb_NoTieneDatos := FALSE;--C_SectorizacionServicio%NOTFOUND;
    CLOSE C_SectorizacionServicio;

    --Si el cursor para obtener los datos del servicio viene nulo, se procede a salir del la funcion con valor false.
    IF Lb_NoTieneDatos THEN
      Lv_Error := 'Cursor vacio para obtener los datos del servicio:'
              || '  TIPO_PROMOCION: '     ||Pr_ParametrosValidarSec.TIPO_PROMOCION
              || ', ID_GRUPO_PROMOCION: ' ||Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION
              || ', ID_TIPO_PROMOCION: '  ||Pr_ParametrosValidarSec.ID_TIPO_PROMOCION
              || ', ID_PUNTO: '           ||Pr_ParametrosValidarSec.ID_PUNTO
              || ', ID_SERVICIO: '        ||Pr_ParametrosValidarSec.ID_SERVICIO;
      RAISE Lex_Exception;
    END IF;

    --Obtenemos el cursor de la sectorización de acuerdo al tipo de promoción a la que se esta aplicando.
    Lr_Sectorizaciones := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_GET_CURSOR_SECTORIZACION(Pr_ParametrosValidarSec);

    --Validamos que el cursor no sea nulo o no este abierto.
    IF Lr_Sectorizaciones IS NULL OR NOT Lr_Sectorizaciones%ISOPEN THEN
      RETURN Lb_Aplica;
    END IF;

    LOOP

      FETCH Lr_Sectorizaciones BULK COLLECT INTO Lt_SectorizacionInsBwMens LIMIT 100;

      EXIT WHEN Lt_SectorizacionInsBwMens.COUNT() < 1 OR Lb_Aplica;

      Ln_IndxSectores := Lt_SectorizacionInsBwMens.FIRST;

      WHILE Ln_IndxSectores IS NOT NULL AND NOT Lb_Aplica LOOP

        Lb_Aplica        := FALSE;
        Lr_Sectorizacion := Lt_SectorizacionInsBwMens(Ln_IndxSectores);
        Ln_IndxSectores  := Lt_SectorizacionInsBwMens.NEXT(Ln_IndxSectores);

        --VALIDAMOS EL ELEMENTO
        IF Lr_Sectorizacion.ID_ELEMENTO != '0' THEN

          OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_ELEMENTO,
                                    Lc_SectorizacionServicio.ID_ELEMENTO);
              FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
          CLOSE C_ExisteSectElemEdif;

          IF Ln_ExisteSectElemEdif > 0 THEN

            Lb_Aplica := TRUE; -- A ESTE PUNTO EL SERVICIO APLICA PROMOCION POR ELEMENTO

          ELSIF Ln_ExisteSectElemEdif = 0 AND UPPER(Pr_ParametrosValidarSec.TIPO_EVALUACION) = 'NUEVO' THEN

            Lb_Aplica := FALSE;

          ELSIF Ln_ExisteSectElemEdif = 0 AND UPPER(Pr_ParametrosValidarSec.TIPO_EVALUACION) = 'EXISTENTE' THEN

            Lb_Aplica := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_EXISTE_SOLICITUD_OLT(Pr_ParametrosValidarSec);

          END IF;

        --VALIDAMOS EL EDIFICIO
        ELSIF Lr_Sectorizacion.ID_EDIFICIO != '0' THEN

          OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_EDIFICIO,
                                    Lc_SectorizacionServicio.EDIFICIO);
            FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
          CLOSE C_ExisteSectElemEdif;

          IF Ln_ExisteSectElemEdif > 0 THEN
            Lb_Aplica := TRUE; -- A ESTE PUNTO EL SERVICIO APLICA PROMOCION POR EDIFICIO.
          ELSE
            Lb_Aplica := FALSE;
          END IF;

        ELSE

          --VALIDAMOS LA JURISDICCION U/O PUNTO DE COBERTURA
          IF Lc_SectorizacionServicio.PUNTO_COBERTURA_ID !=
             COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_JURISDICCION,'^\d+')),0) THEN
            Lb_Aplica := FALSE;
            CONTINUE;
          END IF;

          --VALIDAMOS EL CANTON
          IF Lr_Sectorizacion.ID_CANTON = '0' THEN
            Lb_Aplica := TRUE; -- A ESTE PUNTO EL SERVICIO APLICA PROMOCION POR CANTON.
            CONTINUE;
          ELSE
            IF Lc_SectorizacionServicio.ID_CANTON !=
               COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_CANTON,'^\d+')),0) THEN
              Lb_Aplica := FALSE;
              CONTINUE;
            END IF;
          END IF;

          --VALIDAMOS LA PARROQUIA
          IF Lr_Sectorizacion.ID_PARROQUIA = '0' THEN
            Lb_Aplica := TRUE; -- A ESTE PUNTO EL SERVICIO APLICA PROMOCION POR PARROQUIA.
            CONTINUE;
          ELSE
            IF Lc_SectorizacionServicio.ID_PARROQUIA !=
               COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_Sectorizacion.ID_PARROQUIA,'^\d+')),0) THEN
              Lb_Aplica := FALSE;
              CONTINUE;
            END IF;
          END IF;

          --VALIDAMOS EL SECTOR
          IF Lr_Sectorizacion.ID_SECTOR = '0' THEN
              Lb_Aplica := TRUE; -- A ESTE PUNTO EL SERVICIO APLICA PROMOCION POR SECTOR.
          ELSE
            OPEN C_ExisteSectElemEdif(Lr_Sectorizacion.ID_SECTOR,
                                    Lc_SectorizacionServicio.ID_SECTOR);
              FETCH C_ExisteSectElemEdif INTO Ln_ExisteSectElemEdif;
            CLOSE C_ExisteSectElemEdif;

            IF Ln_ExisteSectElemEdif > 0 THEN
              Lb_Aplica := TRUE; -- A ESTE PUNTO EL SERVICIO APLICA PROMOCION POR SECTOR.
            ELSE
              Lb_Aplica := FALSE;
            END IF;
          END IF;

        END IF;

      END LOOP;

    END LOOP;

    --En caso que el cursor no tenga datos, se retornará true por motivos que la promoción se creo sin sectorización.
    IF Lr_Sectorizaciones%ROWCOUNT = 0 THEN
      Lb_Aplica := TRUE;
    END IF;

    CLOSE Lr_Sectorizaciones;

    RETURN Lb_Aplica;

  EXCEPTION

    WHEN Lex_Exception THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL_REG',
                                           'F_VALIDA_SECTORIZACION',
                                            Lv_Error,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

      RETURN FALSE;

    WHEN OTHERS THEN

      Lv_Error := 'Ocurrió un error al obtener el cursor de solicitud: '
              ||'ID_GRUPO_PROMOCION: ' || Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION ||', '
              ||'ID_TIPO_PROMOCION: '  || Pr_ParametrosValidarSec.ID_TIPO_PROMOCION  ||', '
              ||'ID_SERVICIO: '        || Pr_ParametrosValidarSec.ID_SERVICIO        ||' O '
              ||'ID_PUNTO: '           || Pr_ParametrosValidarSec.ID_PUNTO;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL_REG',
                                           'F_VALIDA_SECTORIZACION',
                                            Lv_Error||' - '||SQLCODE||' -ERROR- '||SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

      RETURN FALSE;

  END F_VALIDA_SECTORIZACION;
  --
  --
  FUNCTION F_GET_CURSOR_SECTORIZACION(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN SYS_REFCURSOR
  IS

    Lr_Cursor SYS_REFCURSOR;
    Lv_Error  VARCHAR2(1000);

  BEGIN

    IF Lr_Cursor%ISOPEN THEN
      CLOSE Lr_Cursor;
    END IF;

    IF UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) IN ('PROM_INS','PROM_BW') THEN

      OPEN Lr_Cursor FOR
        SELECT SECTORIZACION.ID_SECTORIZACION,
               SECTORIZACION.ID_JURISDICCION,
               NVL(SECTORIZACION.ID_CANTON   ,'0') AS ID_CANTON,
               NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA,
               NVL(SECTORIZACION.ID_SECTOR   ,'0') AS ID_SECTOR,
               NVL(SECTORIZACION.ID_ELEMENTO ,'0') AS ID_ELEMENTO,
               NVL(SECTORIZACION.ID_EDIFICIO ,'0') AS ID_EDIFICIO
        FROM (SELECT *
              FROM (SELECT AC.DESCRIPCION_CARACTERISTICA,
                           ATPR.VALOR,
                           ATPR.SECUENCIA AS ID_SECTORIZACION
                    FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION       ATP,
                         DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                         DB_COMERCIAL.ADMI_CARACTERISTICA       AC
                    WHERE ATP.GRUPO_PROMOCION_ID = Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION
                      AND ATP.ID_TIPO_PROMOCION  = ATPR.TIPO_PROMOCION_ID
                      AND AC.ID_CARACTERISTICA   = ATPR.CARACTERISTICA_ID
                      AND AC.DESCRIPCION_CARACTERISTICA IN ('PROM_JURISDICCION',
                            'PROM_CANTON',
                            'PROM_PARROQUIA',
                            'PROM_SECTOR',
                            'PROM_ELEMENTO',
                            'PROM_EDIFICIO')
                    AND ATPR.SECUENCIA IS NOT NULL
                    AND ATPR.ESTADO != 'Eliminado')
              PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA
                IN ('PROM_JURISDICCION' AS ID_JURISDICCION, 
                    'PROM_CANTON'       AS ID_CANTON, 
                    'PROM_PARROQUIA'    AS ID_PARROQUIA, 
                    'PROM_SECTOR'       AS ID_SECTOR, 
                    'PROM_ELEMENTO'     AS ID_ELEMENTO,
                    'PROM_EDIFICIO'     AS ID_EDIFICIO ))) SECTORIZACION;

    ELSIF UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) = 'PROM_MENS' THEN

      OPEN Lr_Cursor FOR
        SELECT SECTORIZACION.ID_SECTORIZACION,
               SECTORIZACION.ID_JURISDICCION,
               NVL(SECTORIZACION.ID_CANTON   ,'0') AS ID_CANTON,
               NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA,
               NVL(SECTORIZACION.ID_SECTOR   ,'0') AS ID_SECTOR,
               NVL(SECTORIZACION.ID_ELEMENTO ,'0') AS ID_ELEMENTO,
               NVL(SECTORIZACION.ID_EDIFICIO ,'0') AS ID_EDIFICIO
        FROM (SELECT *
              FROM (SELECT AC.DESCRIPCION_CARACTERISTICA,
                           AGPR.VALOR,
                           AGPR.SECUENCIA AS ID_SECTORIZACION
                    FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION       AGP,
                         DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
                         DB_COMERCIAL.ADMI_CARACTERISTICA        AC
                    WHERE AGP.ID_GRUPO_PROMOCION = Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION
                      AND AGP.ID_GRUPO_PROMOCION = AGPR.GRUPO_PROMOCION_ID
                      AND AC.ID_CARACTERISTICA   = AGPR.CARACTERISTICA_ID
                      AND AC.DESCRIPCION_CARACTERISTICA IN ('PROM_JURISDICCION',
                            'PROM_CANTON',
                            'PROM_PARROQUIA',
                            'PROM_SECTOR',
                            'PROM_ELEMENTO',
                            'PROM_EDIFICIO')
                      AND AGPR.SECUENCIA IS NOT NULL
                      AND AGPR.ESTADO != 'Eliminado')
              PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA
                IN ('PROM_JURISDICCION' AS ID_JURISDICCION, 
                    'PROM_CANTON'       AS ID_CANTON, 
                    'PROM_PARROQUIA'    AS ID_PARROQUIA, 
                    'PROM_SECTOR'       AS ID_SECTOR, 
                    'PROM_ELEMENTO'     AS ID_ELEMENTO,
                    'PROM_EDIFICIO'     As ID_EDIFICIO))) SECTORIZACION;

    ELSE
        Lr_Cursor := NULL;
    END IF;

    RETURN Lr_Cursor;

  EXCEPTION

    WHEN OTHERS THEN

      Lv_Error := 'Ocurrió un error al obtener el cursor de solicitud: '
                   ||'ID_GRUPO_PROMOCION: ' || Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION ||', '
                   ||'ID_TIPO_PROMOCION: '  || Pr_ParametrosValidarSec.ID_TIPO_PROMOCION  ||', '
                   ||'ID_SERVICIO: '        || Pr_ParametrosValidarSec.ID_SERVICIO        ||' O '
                   ||'ID_PUNTO: '           || Pr_ParametrosValidarSec.ID_PUNTO;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL_REG',
                                           'F_GET_CURSOR_SECTORIZACION',
                                            Lv_Error||' - '||SQLCODE||' -ERROR- '||SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

      RETURN NULL;

  END F_GET_CURSOR_SECTORIZACION;
  --
  --
  FUNCTION F_EXISTE_SOLICITUD_OLT(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN BOOLEAN
  IS

    Lr_Cursor           SYS_REFCURSOR;
    Lv_Error            VARCHAR2(1000);
    Ln_Cantidad         NUMBER;
    Lb_ExisteSolicitud  BOOLEAN;

  BEGIN

    IF Lr_Cursor%ISOPEN THEN
        CLOSE Lr_Cursor;
    END IF;

    IF UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) IN ('PROM_INS','PROM_BW') THEN

      OPEN Lr_Cursor FOR
        SELECT COUNT(*) AS VALOR
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
             DB_COMERCIAL.ADMI_TIPO_SOLICITUD    ATS,
             DB_COMERCIAL.INFO_SERVICIO          ISER,
             (SELECT MAX(IDMP.FE_CREACION) AS FE_CREACION,
                     IDMS.SERVICIO_ID      AS SERVICIO_ID
              FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDMP,
                   DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
              WHERE IDMP.GRUPO_PROMOCION_ID = Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION
                AND IDMP.ID_DETALLE_MAPEO   = IDMS.DETALLE_MAPEO_ID
                AND IDMS.SERVICIO_ID        = Pr_ParametrosValidarSec.ID_SERVICIO
              GROUP BY IDMS.SERVICIO_ID) TABLA
        WHERE TRUNC(IDS.FE_CREACION) BETWEEN TRUNC(TABLA.FE_CREACION) AND SYSDATE
          AND TABLA.SERVICIO_ID         =  ISER.ID_SERVICIO
          AND IDS.SERVICIO_ID           =  ISER.ID_SERVICIO
          AND IDS.TIPO_SOLICITUD_ID     =  ATS.ID_TIPO_SOLICITUD
          AND ATS.DESCRIPCION_SOLICITUD IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APD.PARAMETRO_ID     =  APC.ID_PARAMETRO
                                              AND APD.ESTADO           = 'Activo'
                                              AND APC.NOMBRE_PARAMETRO = 'PROM_SOL_CAMBIOS_TEC'
                                              AND APC.ESTADO           = 'Activo')
          AND ISER.ID_SERVICIO = Pr_ParametrosValidarSec.ID_SERVICIO;
      FETCH Lr_Cursor INTO Ln_Cantidad;
      CLOSE Lr_Cursor;

    ELSIF UPPER(Pr_ParametrosValidarSec.TIPO_PROMOCION) = 'PROM_MENS' THEN

      OPEN Lr_Cursor FOR
        SELECT COUNT(*) AS VALOR
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
             DB_COMERCIAL.ADMI_TIPO_SOLICITUD    ATS,
             DB_COMERCIAL.INFO_SERVICIO          ISER,
             (SELECT MIN (TABLA.FE_CREACION) AS FE_CREACION
              FROM (SELECT MAX(IDMP.FE_CREACION) AS FE_CREACION,
                           IDMP.PERIODO
                    FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
                    WHERE IDMP.GRUPO_PROMOCION_ID = Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION
                      AND IDMP.PUNTO_ID           = Pr_ParametrosValidarSec.ID_PUNTO
                      AND IDMP.TIPO_PROMOCION_ID  = Pr_ParametrosValidarSec.ID_TIPO_PROMOCION
                    GROUP BY IDMP.PERIODO) TABLA
             ) TABLA_FE
        WHERE TRUNC(IDS.FE_CREACION) BETWEEN TRUNC(TABLA_FE.FE_CREACION) AND SYSDATE
          AND IDS.SERVICIO_ID           = ISER.ID_SERVICIO
          AND IDS.TIPO_SOLICITUD_ID     = ATS.ID_TIPO_SOLICITUD
          AND ATS.DESCRIPCION_SOLICITUD IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APD.PARAMETRO_ID     =  APC.ID_PARAMETRO
                                              AND APD.ESTADO           = 'Activo'
                                              AND APC.NOMBRE_PARAMETRO = 'PROM_SOL_CAMBIOS_TEC'
                                              AND APC.ESTADO           = 'Activo')
          AND ISER.ID_SERVICIO = Pr_ParametrosValidarSec.ID_SERVICIO;
      FETCH Lr_Cursor INTO Ln_Cantidad;
      CLOSE Lr_Cursor;

    ELSE

        Ln_Cantidad := 0;

    END IF;

    IF Ln_Cantidad > 0 THEN
      Lb_ExisteSolicitud := TRUE;
    ELSE
      Lb_ExisteSolicitud := FALSE;
    END IF;

    RETURN Lb_ExisteSolicitud;

  EXCEPTION

    WHEN OTHERS THEN

      Lv_Error := 'Ocurrió un error al obtener el cursor de solicitud: '
                   ||'ID_GRUPO_PROMOCION: ' || Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION ||', '
                   ||'ID_TIPO_PROMOCION: '  || Pr_ParametrosValidarSec.ID_TIPO_PROMOCION  ||', '
                   ||'ID_SERVICIO: '        || Pr_ParametrosValidarSec.ID_SERVICIO        ||' O '
                   ||'ID_PUNTO: '           || Pr_ParametrosValidarSec.ID_PUNTO;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL_REG',
                                           'F_EXISTE_SOLICITUD_OLT',
                                            Lv_Error||' - '||SQLCODE||' -ERROR- '||SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    RETURN FALSE;

  END F_EXISTE_SOLICITUD_OLT;
  --
  --
  --
  PROCEDURE P_MAPEO_PROM_TENTATIVA(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_Fecha                IN VARCHAR2,
                                   Pv_FormaPago            IN VARCHAR2,
                                   Pn_Descuento            OUT NUMBER,
                                   Pn_CantPeriodo          OUT NUMBER,
                                   Pv_Observacion          OUT VARCHAR2)
  IS

    PRAGMA AUTONOMOUS_TRANSACTION;

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

   --Costo: 2
    CURSOR C_Datos(Cn_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                   Cn_IdPromocion     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                   Cn_IdTipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE) IS
     SELECT 
      (SELECT COUNT(T1.VALOR) AS  CANTIDAD_PERIODOS
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
                  AND ATP.GRUPO_PROMOCION_ID          = Cn_IdPromocion
                  AND ATP.ID_TIPO_PROMOCION           = Cn_IdTipoPromocion)T
                  CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T1) AS PERIODOS,
      (SELECT ESTADO 
       FROM DB_COMERCIAL.INFO_SERVICIO 
       WHERE ID_SERVICIO = Cn_IdServicio) AS ESTADO FROM DUAL;

    --Costo: 3
    CURSOR C_PeriodoDesc(Cv_Trama  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE) IS       
      SELECT COUNT(T2.PERIODO) AS PERIODO, 
        T2.DESCUENTO 
      FROM ( SELECT SUBSTR(T.VALOR,1,INSTR(T.VALOR,'|',1)-1) AS PERIODO, 
               SUBSTR(T.VALOR,INSTR(T.VALOR,'|',1)+1) AS DESCUENTO 
             FROM (SELECT REGEXP_SUBSTR(Cv_Trama,'[^,]+', 1, LEVEL) AS VALOR
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(Cv_Trama, '[^,]+', 1, LEVEL) IS NOT NULL) T) T2
      GROUP BY T2.DESCUENTO;

    --Costo:15
    CURSOR C_GetServicioHistorial (Cv_User        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE,
                                   Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.SERVICIO_ID%TYPE) IS
      SELECT COUNT(ID_SERVICIO_HISTORIAL) AS EXISTE 
      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      WHERE USR_CREACION = Cv_User
        AND SERVICIO_ID  = Cn_IdServicio;


    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionTipoPromo         EXCEPTION;
    Lv_Existe                     VARCHAR2(6);
    Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Lv_MsjResultado               VARCHAR2(2000);
    Lv_MsjExceptionProceso        VARCHAR2(1000);
    Lv_MsjExceptionTipoPromo      VARCHAR2(1000);
    Lrf_TiposPromociones          SYS_REFCURSOR;
    Lr_TiposPromociones           DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar;
    Lr_TipoPromoRegla             DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.Tr_ParametrosValidarSec;
    La_TipoPromoPlanProdProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar;
    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_TiposPromocionesProcesar   DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar;
    Lb_OtorgoPromoCliente         BOOLEAN;
    Lb_CumpleSect                 BOOLEAN;
    Lb_CumpleFormPag              BOOLEAN;
    Lb_CumpleUltMilla             BOOLEAN;
    Lb_CumpleTipoNeg              BOOLEAN;  
    Lb_CumplePlaProd              BOOLEAN;
    Ln_IndGpro                    NUMBER;    
    Ln_IdTipoPromocion            DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    Ln_IdPromocion                DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Lc_Datos                      C_Datos%ROWTYPE;
    Lc_PeriodoDesc                C_PeriodoDesc%ROWTYPE;
    Lv_Observacion                VARCHAR2(3200);
    Lv_ObservacionDesc            VARCHAR2(3200);
    Lv_Descuento                  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE;
    Ln_Existe                     NUMBER;

  BEGIN

  --
    IF TRIM(Pv_CodigoGrupoPromocion) NOT IN ('PROM_INS','PROM_MENS') THEN
    --
      Lv_MsjExceptionProceso := 'La promoción solo aplica para los tipos: (PROM_INS,PROM_MENS), punto_Id - '
                                 || Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio;
      RAISE Le_ExceptionProceso;
    --
    END IF;

    IF Lrf_TiposPromociones%ISOPEN THEN
      CLOSE Lrf_TiposPromociones;
    END IF;

    IF C_GetErrorRepetido%ISOPEN THEN
    --
      CLOSE C_GetErrorRepetido;
    --
    END IF;

    IF C_GetEmpresa%ISOPEN THEN
    --
      CLOSE C_GetEmpresa;
    --
    END IF;

    IF C_Datos%ISOPEN THEN
    --
      CLOSE C_Datos;
    --
    END IF;

    OPEN C_GetEmpresa;
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;

    IF Lv_CodEmpresa IS NULL THEN
    --
      Lv_MsjExceptionProceso := 'No se encuentra definido código de Empresa para el Proceso de Promociones ' 
                                 || Pv_CodigoGrupoPromocion || ' COD_EMPRESA: '||Pv_CodEmpresa ||', punto_Id - '
                                 || Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio;
      RAISE Le_ExceptionProceso;
    --
    END IF;

    Lb_OtorgoPromoCliente   := FALSE;
    La_ServiciosProcesar.DELETE();

    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.P_OBTIENE_PROMO_TENTATIVAS(Pv_CodigoGrupoPromocion,
                                                                  Pv_CodEmpresa,
                                                                  'NUEVO',
                                                                  Pv_Fecha,
                                                                  Pv_FormaPago,
                                                                  Lrf_TiposPromociones);                                                                 
    --
    IF NOT(Lrf_TiposPromociones%ISOPEN) THEN
      Lv_MsjExceptionProceso := 'No se pudo obtener los Grupos de Promocionales para la evaluación de reglas. ';
      RAISE Le_ExceptionProceso;
    END IF;
    --

    La_TiposPromocionesProcesar.DELETE();
    --  
    LOOP
    FETCH Lrf_TiposPromociones BULK COLLECT INTO La_TiposPromocionesProcesar LIMIT 1000;
      Ln_IndGpro := La_TiposPromocionesProcesar.FIRST;        
      WHILE (Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente)       
      LOOP
        BEGIN
          Lr_TiposPromociones          := La_TiposPromocionesProcesar(Ln_IndGpro);
          Ln_IndGpro                   := La_TiposPromocionesProcesar.NEXT(Ln_IndGpro);         
          La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Lr_TiposPromociones.ID_TIPO_PROMOCION); 

          La_ServiciosCumplePromo.DELETE();
          La_ServiciosProcesar.DELETE();
          Lb_CumplePlaProd             := FALSE;

          IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto,
                                                                         Pv_CodEmpresa,
                                                                         La_ServiciosProcesar);

            IF La_ServiciosProcesar.COUNT = 0 THEN
              Lv_MsjExceptionTipoPromo:= 'No se encontraron servicios para el ID_PUNTO: '||Pn_IdPunto;
              RAISE Le_ExceptionTipoPromo; 
            END IF;
          --
          END IF;

          Lr_ParametrosValidarSec                    := NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
          Lr_ParametrosValidarSec.ID_SERVICIO        := Pn_IdServicio;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'NUEVO';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := Pv_CodigoGrupoPromocion;

          Lb_CumpleSect     := TRUE; --DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec);

          Lb_CumpleFormPag := TRUE; --DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_FORMA_PAGO(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                      --Pn_IdPunto); 

          IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN
            Lb_CumpleUltMilla := TRUE; --DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_ULTIMA_MILLA(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                        --  Pn_IdServicio);

            Lb_CumpleTipoNeg  := TRUE; --DB_COMERCIAL.CMKG_PROMOCIONES_UTIL_REG.F_VALIDA_TIPO_NEGOCIO(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                          --Pn_IdServicio,
                                                                                          --Pv_CodEmpresa);
          END IF;

          Lb_OtorgoPromoCliente := TRUE;
          Ln_IdPromocion        := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
          Ln_IdTipoPromocion    := Lr_TiposPromociones.ID_TIPO_PROMOCION;          

          La_TipoPromoPlanProdProcesar.DELETE();             

          --
        EXCEPTION
        WHEN Le_ExceptionTipoPromo THEN
          Lv_MsjResultado := 'Ocurrió un error al ejecutar el Proceso de evaluación de Promociones para el Grupo de Promocional: '
                             || Pv_CodigoGrupoPromocion|| ' - ' ||Lv_MsjExceptionTipoPromo ||', punto_Id - '
                             || Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio; 

          Lv_Existe       := '';
          OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
          --
          FETCH C_GetErrorRepetido INTO Lv_Existe;
          --
            IF Lv_Existe <> 'EXISTE' THEN

              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'CMKG_PROMOCIONES_UTIL_REG.P_MAPEO_PROM_TENTATIVA', 
                                                   Lv_MsjResultado,
                                                   'telcos_mapeo_promo',
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
            END IF;
          CLOSE C_GetErrorRepetido;
          Lv_MsjResultado := NULL;
        --
        END;
      END LOOP;
      EXIT WHEN Lrf_TiposPromociones%NOTFOUND OR Lb_OtorgoPromoCliente;   
    --
    --
    END LOOP;
    CLOSE Lrf_TiposPromociones;    

    Lb_OtorgoPromoCliente := TRUE;                                     
    IF Lb_OtorgoPromoCliente THEN
    --
      Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Ln_IdTipoPromocion);


      IF Lr_TipoPromoRegla.PROM_DESCUENTO IS NOT NULL THEN

        Lv_Descuento := Lr_TipoPromoRegla.PROM_DESCUENTO;
      --
      ELSE
      --

        OPEN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO);
        FETCH C_PeriodoDesc INTO Lc_PeriodoDesc;
        CLOSE C_PeriodoDesc;
        Lv_Descuento := Lc_PeriodoDesc.DESCUENTO;
      END IF;

      OPEN C_Datos(Pn_IdServicio,Ln_IdPromocion,Ln_IdTipoPromocion);
      FETCH C_Datos INTO Lc_Datos;
      CLOSE C_Datos;

      Lr_InfoServicioHistorial                       := NULL;
      Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
      Lr_InfoServicioHistorial.SERVICIO_ID           := Pn_IdServicio;
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lr_InfoServicioHistorial.USR_CREACION        := 'telcos_prom_mens';
      ELSE
        Lr_InfoServicioHistorial.USR_CREACION        := 'telcos_prom_inst';
      END IF;
      Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
      Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
      Lr_InfoServicioHistorial.ESTADO                := Lc_Datos.ESTADO;
      Lr_InfoServicioHistorial.MOTIVO_ID             := NULL;
      Lr_InfoServicioHistorial.OBSERVACION           := 'El servicio cumplió con las reglas de los grupos promocionales, para aplicar la promoción '
                                                         || Lr_TipoPromoRegla.NOMBRE_GRUPO;
      Lr_InfoServicioHistorial.ACCION                := NULL;
      --

      OPEN  C_GetServicioHistorial(Lr_InfoServicioHistorial.USR_CREACION,
                                   Pn_IdServicio);
      FETCH C_GetServicioHistorial INTO Ln_Existe;
      CLOSE C_GetServicioHistorial;

      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        IF UPPER(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA) = 'SI' THEN
          Lv_ObservacionDesc := ' Descuento: ' || Lv_Descuento ||'%';
        ELSE
          FOR Lc_Valores IN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO) LOOP
            Lv_ObservacionDesc := Lv_ObservacionDesc || ' #Numero de Periodos: '|| Lc_Valores.PERIODO 
                                  || ' - Descuento: ' || Lc_Valores.DESCUENTO || '%,';
          END LOOP;
            Lv_ObservacionDesc := SUBSTR (Lv_ObservacionDesc, 1, Length(Lv_ObservacionDesc) - 1 );
        END IF;
      END IF;

      IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN

        Lv_Observacion := 'Desct. Inst. Porcentaje: ' || Lv_Descuento ||'%, #Numero de Periodos: '||Lc_Datos.PERIODOS;
      ELSE
        Lv_Observacion := 'Desct. Fact. Mensual: Promoción Indefinida: ' || NVL(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA,'NO')
                          || ', Tipo Periodo: ' || UPPER(NVL(Lr_TipoPromoRegla.PROM_TIPO_PERIODO,'Unico')) || ',' || Lv_ObservacionDesc;

      END IF;

      Pn_Descuento   := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lv_Descuento,'^\d+')),0);
      Pn_CantPeriodo := TO_NUMBER(Lc_Datos.PERIODOS);
      Pv_Observacion := Lv_Observacion;

    --
    ElSE

      Pn_Descuento:=0;

    END IF;

    IF Lv_Observacion IS NULL THEN
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lv_Observacion := 'No aplica Promoción por descuento Mensual.';
        Pn_Descuento:=0;
      ELSE
        Lv_Observacion := 'No aplica Promoción por descuento de Instalación.';
        Pn_Descuento:=0;
      END IF;
      Pv_Observacion := Lv_Observacion;
    END IF;
    COMMIT;

  EXCEPTION
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el Proceso de evaluación de Promociones' || ' - ' ||Lv_MsjExceptionProceso
                        ||', punto_Id - '|| Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_MAPEO_PROM_TENTATIVA', 
                                         Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

    IF Lv_Observacion IS NULL THEN
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lv_Observacion := 'No aplica Promoción por descuento Mensual.';
      ELSE
        Lv_Observacion := 'No aplica Promoción por descuento de Instalación.';
      END IF;
      Pv_Observacion := Lv_Observacion;
    END IF;

  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el Proceso de evaluación de Promociones para el Grupo de Promocional: '||
                        Pv_CodigoGrupoPromocion||', punto_Id - '|| Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio
                        || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_MAPEO_PROM_TENTATIVA', 
                                         Lv_MsjResultado, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

    IF Lv_Observacion IS NULL THEN
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lv_Observacion := 'No otorgó Promoción por descuento Mensual, revisar en info_error.';
      ELSE
        Lv_Observacion := 'No otorgó Promoción por descuento de Instalación, revisar en info_error.';
      END IF;
      Pv_Observacion := Lv_Observacion;
    END IF;

  END P_MAPEO_PROM_TENTATIVA;

  PROCEDURE P_OBTIENE_PROMO_TENTATIVAS(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoProceso           IN VARCHAR2,
                                       Pv_Fecha                 IN VARCHAR2,
                                       Pv_FormaPago             IN VARCHAR2,
                                       Prf_GruposPromociones    OUT SYS_REFCURSOR)
  IS    
    Lv_EstadoActivo     VARCHAR2(15) := 'Activo';
    Lv_EstadoEliminado  VARCHAR2(15) := 'Eliminado';
    Lv_TipoCliente      VARCHAR2(20) := 'PROM_TIPO_CLIENTE';
    Lv_NombreParametro  VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion       VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado     VARCHAR2(2000);  
    Lv_QuerySelect      VARCHAR2(2000);
    Lv_QueryFrom        VARCHAR2(2000); 
    Lv_QueryWhere       VARCHAR2(2000); 
    Lv_QueryOrderBy     VARCHAR2(2000); 
    Lv_Consulta         VARCHAR2(4000); 
    Le_Exception        EXCEPTION;
  BEGIN
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
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
                       CAB.NOMBRE_PARAMETRO                = '''||Lv_NombreParametro||'''     
                       AND CAB.ESTADO                      = '''||Lv_EstadoActivo||'''     
                       AND DET.ESTADO                      = '''||Lv_EstadoActivo||'''    
                       AND DET.EMPRESA_COD                 = '''||Pv_CodEmpresa||'''
                       AND DET.VALOR3                      = '''||Pv_CodigoGrupoPromocion||'''
                       AND CAB.ID_PARAMETRO                = DET.PARAMETRO_ID
                       AND TPROMO.CODIGO_TIPO_PROMOCION    = DET.VALOR2  
                       --
                       AND TPROMO.GRUPO_PROMOCION_ID       = GPROMO.ID_GRUPO_PROMOCION  
                       --AND GPROMO.ESTADO                   = '''||Lv_EstadoActivo||''' 
                       --AND TPROMO.ESTADO                   = '''||Lv_EstadoActivo||''' 
                       AND GPROMO.EMPRESA_COD              = '''||Pv_CodEmpresa||'''
                       AND (TO_DATE(substr('''|| Pv_Fecha || ''',1,10) ,''DD/MM/YYYY'') 
                       BETWEEN TO_DATE(TO_CHAR(GPROMO.FE_INICIO_VIGENCIA,''DD/MM/YYYY''),''DD/MM/YYYY'')
                       AND TO_DATE(TO_CHAR(GPROMO.FE_FIN_VIGENCIA,''DD/MM/YYYY''),''DD/MM/YYYY'')) 
                       AND GPROMO.NOMBRE_GRUPO LIKE ''' || '%' || Pv_FormaPago || '%''';

   Lv_QueryOrderBy := ' ORDER BY GPROMO.FE_CREACION DESC, 
                        TO_NUMBER(DET.VALOR4) ASC';

   IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
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
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'Lv_NombreParametro' || Lv_NombreParametro || ' Lv_EstadoActivo ' || Lv_EstadoActivo || ' Pv_CodigoGrupoPromocion ' || Pv_CodigoGrupoPromocion, 
                                         Lv_Consulta, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  

   IF Lv_Consulta IS NULL THEN
      RAISE Le_Exception;
   END IF;

   OPEN Prf_GruposPromociones FOR Lv_Consulta;

  EXCEPTION
  WHEN Le_Exception THEN    
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
    Lv_MsjResultado := 'Ocurrió un error al obtener los Grupos de Promociones  del parámetro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_OBTIENE_PROMO_TENTATIVAS', 
                                         Lv_Consulta, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
    Prf_GruposPromociones := NULL;    
  WHEN OTHERS THEN
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
     Lv_MsjResultado := 'Ocurrió un error al obtener los Grupos de Promociones  del parámetro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.P_OBTIENE_PROMO_TENTATIVAS', 
                                         Lv_Consulta || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
    Prf_GruposPromociones := NULL;                      
  END P_OBTIENE_PROMO_TENTATIVAS;
  --
  --
  --
  PROCEDURE P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar)
  IS 
    Lv_Estados_Act_Serv   VARCHAR2(50) := 'PROM_ESTADOS_SERVICIO';
    Lv_Estados_Baja_Serv  VARCHAR2(50) := 'PROM_ESTADOS_BAJA_SERV';
    Lv_EstadoActivo       VARCHAR2(15) := 'Activo';
    Lv_DescripcionRol     VARCHAR2(50) := 'PROM_ROLES_CLIENTES';
    Lv_EsVenta            VARCHAR2(1)  := 'S';
    Ln_Frecuencia         NUMBER       := 1;  
    Ln_Numero             NUMBER       := 0;
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(2000); 
    Lv_Consulta           VARCHAR2(4000);
    Lv_CadenaQuery        VARCHAR2(2000);
    Lv_CadenaFrom         VARCHAR2(1000);
    Lv_CadenaWhere        VARCHAR2(4000);
    Lv_CadenaOrdena       VARCHAR2(1000); 
    Lrf_ServiciosProcesar SYS_REFCURSOR; 
    Lr_Servicios          DB_COMERCIAL.CMKG_PROMOCIONES.Lr_ServiciosProcesar; 
    La_ServiciosProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;  
    Ln_Indice             NUMBER        := 1; 
    Ln_Indx               NUMBER;
  BEGIN

    --Costo: 12
    Lv_CadenaQuery := ' SELECT
      DISTINCT
      ISE.ID_SERVICIO,
      IP.ID_PUNTO,       
      ISE.PLAN_ID     AS ID_PLAN,
      ISE.PRODUCTO_ID AS ID_PRODUCTO,  
      NULL            AS PLAN_ID_SUPERIOR,
      ISE.ESTADO      AS ESTADO ';

      Lv_CadenaFrom := ' FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPE,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AR ';

      Lv_CadenaWhere := ' WHERE 
      ISE.CANTIDAD                   > '||Ln_Numero||'
      AND IER.EMPRESA_COD            = '''||Pv_CodEmpresa||'''
      AND ISE.ES_VENTA               = '''||Lv_EsVenta||'''
      AND UPPER(AR.DESCRIPCION_ROL)  IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                           DB_GENERAL.ADMI_PARAMETRO_DET APD
                                         WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                         AND APD.ESTADO           = '''||Lv_EstadoActivo||'''
                                         AND APC.NOMBRE_PARAMETRO = '''||Lv_DescripcionRol||'''
                                         AND APC.ESTADO           = '''||Lv_EstadoActivo||''')
      AND ISE.PRECIO_VENTA           > '||Ln_Numero||'
      AND ISE.FRECUENCIA_PRODUCTO    = '|| Ln_Frecuencia ||'      
      AND IP.ID_PUNTO                = '||Pn_IdPunto||'   
      AND IP.ID_PUNTO                = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL        = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA             = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL         = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                  = IER.ROL_ID ) ';

    Lv_CadenaOrdena := ' ORDER BY ISE.ID_SERVICIO ASC '; 

    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdena;        
    Pa_ServiciosProcesar.DELETE();  
    IF Lrf_ServiciosProcesar%ISOPEN THEN
      CLOSE Lrf_ServiciosProcesar;
    END IF;

    La_ServiciosProcesar.DELETE();
    OPEN Lrf_ServiciosProcesar FOR Lv_Consulta;     
    LOOP
      FETCH Lrf_ServiciosProcesar BULK COLLECT INTO La_ServiciosProcesar LIMIT 100;       
      Ln_Indx:=La_ServiciosProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP  
        Lr_Servicios                                     := La_ServiciosProcesar(Ln_Indx);
        Ln_Indx                                          := La_ServiciosProcesar.NEXT(Ln_Indx);       
        Pa_ServiciosProcesar(Ln_Indice).ID_SERVICIO      := Lr_Servicios.ID_SERVICIO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PUNTO         := Lr_Servicios.ID_PUNTO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PLAN          := Lr_Servicios.ID_PLAN;
        Pa_ServiciosProcesar(Ln_Indice).ID_PRODUCTO      := Lr_Servicios.ID_PRODUCTO;
        Pa_ServiciosProcesar(Ln_Indice).PLAN_ID_SUPERIOR := Lr_Servicios.PLAN_ID_SUPERIOR;
        Pa_ServiciosProcesar(Ln_Indice).ESTADO           := Lr_Servicios.ESTADO;
        Ln_Indice                                        := Ln_Indice + 1;
      END LOOP;
      EXIT WHEN Lrf_ServiciosProcesar%NOTFOUND; 
    END LOOP;
    CLOSE Lrf_ServiciosProcesar;      

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrio un error al obtener los servicios del punto cliente para el ID_PUNTO: '|| Pn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES.P_OBTIENE_SERVICIOS_PUNTO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    Pa_ServiciosProcesar.DELETE();                  
  END P_OBTIENE_SERVICIOS_PUNTO;
  --
  --
  FUNCTION F_ESTADO_CONTRATO(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2
  IS

   --Costo: 4
   CURSOR C_EstadosContratos
    IS
      SELECT APD.VALOR1 AS VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
      AND APD.ESTADO           = 'Activo'
      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_CONTRATOS'
      AND APC.ESTADO           = 'Activo'
      ORDER BY APD.VALOR2 ASC;

    --Costo: 6
    CURSOR C_EstadoContrato(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cv_Estado  DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE)
    IS        
      SELECT COUNT(DBIC.ID_CONTRATO) AS ID_CONTRATO
      FROM DB_COMERCIAL.INFO_PUNTO IP, 
        DB_COMERCIAL.INFO_CONTRATO DBIC
      WHERE DBIC.PERSONA_EMPRESA_ROL_ID = IP.PERSONA_EMPRESA_ROL_ID
      AND IP.ID_PUNTO                   = Cn_IdPunto
      AND UPPER(DBIC.ESTADO)            = UPPER(Cv_Estado);

    Lv_Estado               DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE;
    Ln_ExisteEstadoContrato NUMBER;
    Lv_MsjResultado         VARCHAR2(2000);

  BEGIN

    IF C_EstadosContratos%ISOPEN THEN
    --
      CLOSE C_EstadosContratos;
    --
    END IF;

    IF C_EstadoContrato%ISOPEN THEN
    --
      CLOSE C_EstadoContrato;
    --
    END IF;

    FOR Lc_EstadosContratos IN C_EstadosContratos
    LOOP
    --
      Lv_Estado := Lc_EstadosContratos.VALOR1;
      OPEN C_EstadoContrato(Fn_IdPunto,Lv_Estado);
      --
      FETCH C_EstadoContrato INTO Ln_ExisteEstadoContrato;
      --
        IF Ln_ExisteEstadoContrato > 0 THEN
          RETURN Lv_Estado;
        END IF;
      --
      CLOSE C_EstadoContrato;
    --
    END LOOP;
    --
    Lv_Estado := null;
    RETURN Lv_Estado;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al obtener el estado del contrato para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_ESTADO_CONTRATO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Estado        := null;
    RETURN Lv_Estado;
  END F_ESTADO_CONTRATO;

    --
  FUNCTION F_ESTADO_SERVICOS(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Fv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                               Fv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                               Fv_EstadoActivo    VARCHAR2,
                               Fv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    RETURN VARCHAR2
  IS

       --Costo: 4
    CURSOR C_GetParametro (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Cv_EstadoActivo    VARCHAR2,
                             Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
     SELECT APD.VALOR2 AS VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
      AND APD.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APC.ESTADO           = Cv_EstadoActivo
       AND APD.VALOR1 = Cv_TipoPromo
        AND APD.EMPRESA_COD = Cv_EmpresaCod
      ORDER BY APD.VALOR2 ASC;

    --Costo 7
    CURSOR C_GetFeCreacionServ (Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Cv_EstadoServ  VARCHAR2)
    IS
      SELECT TRUNC(SERV.FE_CREACION) AS FE_EVALUA_VIGENCIA
      FROM DB_COMERCIAL.INFO_SERVICIO SERV, 
        DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE SERV.PUNTO_ID   =  Cn_IdPunto
      AND SERV.PLAN_ID      =  IPC.ID_PLAN
      AND IPC.ID_PLAN       =  IPD.PLAN_ID
      AND IPD.PRODUCTO_ID   =  AP.ID_PRODUCTO
      AND AP.NOMBRE_TECNICO = 'INTERNET'
      AND SERV.ESTADO       =  Cv_EstadoServ;


    Lv_MsjResultado         VARCHAR2(2000);
    Ld_FeCreaServicio       DATE;

  BEGIN

    IF C_GetParametro%ISOPEN THEN
    --
      CLOSE C_GetParametro;
    --
    END IF;

    FOR Lc_EstadosServicios IN C_GetParametro(Cv_NombreParametro => Fv_NombreParametro,
                              Cv_TipoPromo        => Fv_TipoPromo,
                              Cv_EstadoActivo     => Fv_EstadoActivo,
                              Cv_EmpresaCod       => Fv_EmpresaCod)
    LOOP
    --
      OPEN  C_GetFeCreacionServ(Cn_IdPunto => Fn_IdPunto, Cv_EstadoServ => Lc_EstadosServicios.VALOR2);
            FETCH C_GetFeCreacionServ INTO Ld_FeCreaServicio;
            CLOSE C_GetFeCreacionServ;


   IF Ld_FeCreaServicio is not null  THEN
       RETURN Ld_FeCreaServicio;
   END IF;

    --
    END LOOP;
    --

    RETURN Ld_FeCreaServicio;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al obtener el estado y frecha del servicio para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL_REG.F_ESTADO_SERVICOS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ld_FeCreaServicio        := null;
    RETURN Ld_FeCreaServicio;
  END F_ESTADO_SERVICOS;
END CMKG_PROMOCIONES_UTIL_REG;
/
