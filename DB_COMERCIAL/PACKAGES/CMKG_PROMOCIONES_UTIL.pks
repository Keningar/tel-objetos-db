CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES_UTIL AS

 /*
  * Documentaci�n para Funci�n 'F_OBTIENE_FECHA_EVAL_VIGENCIA'  
  * Funci�n que obtiene la Fecha con la cual se va a evaluar el rango de fechas de Inicio y Fin de Vigencia para otorgar un grupo promocional.
  * 
  * Si el Punto corresponde a un Cliente Nuevo se tomar� la fecha de creaci�n de su contrato.
  * Si el Punto corresponde a un Punto Adicional contratado se tomar� la fecha de creaci�n del servicio de internet del Punto adicional.
  * Si se esta contratando un servicio adicional que no es internet se debe tomar la fecha de creaci�n menor de sus servicios adicionales contratados.
  *
  * PARAMETROS:
  * @Param Fn_PuntoId              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Fv_EstadoServ           IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
  * @Param Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-10-2019  
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 05-11-2019  - Se agregan consideraciones al obtener la fecha de evaluaci�n de vigencias para el caso de Promociones de instalaci�n
  *                            y ancho de banda se verifica diferencia en meses entre la fecha de creaci�n del contrato y la fecha de creaci�n del 
  *                            servicio para la consideraci�n de la fecha a tomar para el proceso.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 13-11-2019 -Se agrega que se inserte en INFO_ERROR LOG en caso de no obtener la fecha para evaluaci�n de Vigencia por casos de 
  *                          inconsistencia en data de contratos se inserta LOG de error y se continua con el proceso.
  *                          Se agrega llamada a la funcion F_ESTADO_CONTRATO que obtiene el estado actual de contrato con el cual se procesa.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.3 14-11-2019 - Se agrega en la funci�n que se tome para instalalci�n los estados de servicio configurados en el parmetro para 
  * que considere varios estados.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.4 03-01-2020 - Se mejora cursores C_GetFeCreaServInternetActivo, C_GetFeCreaServAdicionalActivo para que considere entre dos d�as la confirmaci�n
  *                           de los servicios en estado activo.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.5 16-07-2020 - Se agrega par�metro Fv_TipoPto ('PTO_ADICIONAL','PTO_NUEVO') a la funci�n F_ESTADO_SERVICOS que obtiene la fecha para evaluar 
  *                           las promociones por instalaci�n.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.6 02-03-2023 - Se agrega cursor C_GetEmpresa para obterne el codigo de la empresa por medio del idServicio,
  *                           el mismo que servira para filtar la empresa en los cursores que utilizan las tablas de parametros.
  *
  */
  FUNCTION F_OBTIENE_FECHA_EVAL_VIGENCIA(Fn_PuntoId              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Fv_EstadoServ           IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                         Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    RETURN DATE;

 /**
  * Documentaci�n para PROCEDURE 'P_ELIMINA_CARACT_PROMO_BW'.
  * Proceso obtiene las caracter�sticas promocionales de un servicio para actualizar su estado a Eliminado.
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
  * Documentaci�n para PROCEDURE 'P_ACTUALIZA_CARACT_PROMO_BW'.
  * Proceso que actualiza el estado a Eliminado de las caracter�sticas promocionales de un servicio.
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
  * Documentaci�n para PROCEDURE 'P_VALIDA_ELIMINA_CARACT_BW'.
  * Proceso que valida si debe o no eliminar las caracter�sticas promocionales de un servicio.
  *
  * Costo del Query C_ObtieneMaxMapeo: 2
  *
  * PARAMETROS:
  * @Param Pn_IdServicio     IN  INFO_SERVICIO.ID_SERVICIO%TYPE                   Recibe id del servicio
  * @Param Pv_TipoPromo      IN  ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE   Recibe tipo de promoci�n
  * @Param Pb_EliminaCaract  OUT BOOLEAN                                          Devuelve TRUE/FALSE si debe o no eliminar 
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 24-09-2019
  */   
  PROCEDURE P_VALIDA_ELIMINA_CARACT_BW (Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                        Pv_TipoPromo       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pb_EliminaCaract  OUT BOOLEAN);

  /**
   * Documentaci�n para el procedimiento 'P_INSERT_ISERVICIO_PROD_CARACT'.
   *
   * Proceso encargado de insertar las caracter�sticas promocionales de un servicio.
   *
   * @Param Pr_InfoServProdCaract IN  ROWTYPE  : Recibe un record de la tabla 'INFO_SERVICIO_PROD_CARACT' de 'DB_COMERCIAL'.
   * @Param Pv_Mensaje            OUT VARCHAR2 : Mensaje de error en caso de existir.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   */
  PROCEDURE P_INSERT_ISERVICIO_PROD_CARACT(Pr_InfoServProdCaract IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE,
                                           Pv_Mensaje            OUT VARCHAR2);

  /**
   * Documentaci�n para PROCEDURE 'P_ELIMINA_CARACT_INDV_BW'.
   * Proceso obtiene la caracter�stica de un servicio para actualizar su estado a Eliminado.
   *
   * Costo del Query C_ObtieneCaractPromo: 7
   *
   * PARAMETROS:
   * @Param Pn_IdServicio    IN INFO_SERVICIO.ID_SERVICIO%TYPE                              Recibe id del servicio
   * @Param Pv_NombreCaract  IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_CARACTERISTICA%TYPE  Nombre de caracteristica a eliminar
   * @Param Pv_MsjResultado  OUT VARCHAR2                                                   Devuelve mensaje de resultado
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 16-10-2019
   */
  PROCEDURE P_ELIMINA_CARACT_INDV_BW (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_NombreCaract  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Pv_MsjResultado  OUT VARCHAR2);

  /**
   * Documentaci�n para PROCEDURE 'P_ELIMINA_CARACT_INDV_BW'.
   * Proceso registra la caracter�stica de un servicio.
   *
   * PARAMETROS:
   * @Param Pn_IdServicio    IN INFO_SERVICIO.ID_SERVICIO%TYPE                               Recibe id del servicio
   * @Param Pv_NombreCaract  IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_CARACTERISTICA%TYPE   Nombre de caracteristica a eliminar
   * @Param Pv_MsjResultado  OUT VARCHAR2                                                    Devuelve mensaje de resultado
   *
   * Costo del Query C_AdmiProdCaract: 10
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 16-10-2019
   */
  PROCEDURE P_CREA_CARACT_INDV_BW (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_NombreCaract  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Pv_ValorCaract   IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                   Pv_MsjResultado  OUT VARCHAR2);

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_TIPO_NEGOCIO'.
   *
   * Funci�n que verifica que el punto del cliente entre en los tipos de negocio configurado para la promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
   *
   * Costo del Query C_TipoNegocioInsABan: 18
   * Costo del Query C_TipoNegocioPto: 18
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
   * @Param Fv_CodEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-09-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 11-11-2020 Se agrega al proceso el valor de entrada Fn_IdPto para que la funci�n soporte evaluar la regla
   *                         tipo de negocio por el punto del cliente.
   */ 
  FUNCTION F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                 Fn_IdPto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                 Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_ULTIMA_MILLA'.
   *
   * Funci�n que verifica que el punto del cliente entre en las �ltimas millas configurada para la promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
   *
   * Costo del Query C_UltimaMillaInsABan: 15
   * Costo del Query C_UltimaMillaPunto: 18
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-09-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 11-11-2020 Se agrega al proceso el valor de entrada Fn_IdUltimaMilla que la funci�n evalue la regla por un
   *                         id de �ltima milla en espec�fico.
   */ 
  FUNCTION F_VALIDA_ULTIMA_MILLA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                 Fn_IdUltimaMilla  IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE DEFAULT NULL)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_FORMA_PAGO'.
   *
   * Funci�n que verifica que el punto cumpla con las forma de pago de una promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
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
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   *
   * Se agrega l�gica para que los cursores que obtienen la forma de pago no consideren estados por los tipos de promoci�n 
   * Instalaci�n y Ancho de Banda.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 27-09-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 13-11-2019 - Se agrega llamada a la funcion F_ESTADO_CONTRATO que obtiene el estado actual del contrato con el cual se procesa.
   *
   * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
   * @version 1.3 27-09-2021 - Se modifica query del cursor C_ExisteBancoTipoCta y se reemplaza uso de REGEXP_SUBSTR debido a que se detecta que la
   *                           funci�n consume entre 8 y 9 segundos por cada iteraci�n en el proceso de mapeo de promociones lo cual afecta el
   *                           tiempo de la ejecuci�n del proceso y posterior facturacion proporcional.
   */
  FUNCTION F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Pv_Trama          IN VARCHAR2 DEFAULT NULL)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_PERMANENCIA'.
   *
   * Funci�n que verifica que el punto cumpla con la permanencia m�nima configurada por tipo de promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
   *
   * Costo del Query C_FechaConfirmacion: 11
   * Costo del Query C_PermanenciaMinima: 5
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fv_Tipo_Promocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
   * @Param Fn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 15-09-2020 - Se cambia la forma de obtener la diferencia de meses, para que no d� problemas en el ambiente web.
   *
   */
  FUNCTION F_VALIDA_PERMANENCIA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                Fv_Tipo_Promocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_MORA'.
   *
   * Funci�n que verifica que el punto no halla ca�do en mora en el tiempo configurado por el tipo de promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
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
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   */
  FUNCTION F_VALIDA_MORA(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                         Fv_Tipo_Promocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                         Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

 /**
  * Documentaci�n para FUNCTION 'F_VALIDA_SECTORIZACION_OLT'.
  * Funci�n que verifica que el elemento OLT cumpla con las reglas de sectorizaci�n de una promoci�n especifica,
  * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
  *
  * Costo del Query C_SectorizacionABan: 7
  * Costo del Query C_SectorizacionElemento: 13
  * Costo del Query C_SectorizacionPunto: 21
  *
  * PARAMETROS:
  * @Param Fn_IntIdPromocion   IN ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE  Recibe id grupo promoci�n
  * @Param Fn_IdElemento       IN INFO_ELEMENTO.ID_ELEMENTO%TYPE                Recibe id elemento
  * @Param Fv_CodEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE           Recibe c�digo de empresa
  * @Param Fn_IdPunto          IN INFO_PUNTO.ID_PUNTO%TYPE                      Recibe id del punto
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-09-2019
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 07-03-2023 - Se agrega como filtro la empresa en los querys que incluyen las estructuras de parametros.
  */    
  FUNCTION F_VALIDA_SECTORIZACION_OLT(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                      Fn_IdElemento     IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                      Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_ANTIGUEDAD'.
   * Funci�n que verifica que el servicio tenga la antig�edad m�nima configurada en la promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
   *
   * Costo del Query C_FechaConfirmacion: 11
   * Costo del Query C_Antiguedad: 5
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion   IN ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE  Recibe id grupo promoci�n
   * @Param Fn_IdPunto          IN INFO_PUNTO.ID_PUNTO%TYPE                      Recibe id del punto
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 05-09-2019
   */
  FUNCTION F_VALIDA_ANTIGUEDAD(Fn_IntIdPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN BOOLEAN;

  /*
   * Documentaci�n para TYPE 'Tr_SectorizacionInsBwMens'.
   *
   * Record que permite almacenar los valores de sectorizaci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 18-10-2019
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 27-05-2022   Se modifica el tama�o de las variables del type para la sectorizaci�n.
   */
  TYPE Tr_SectorizacionInsBwMens IS RECORD (
    ID_SECTORIZACION VARCHAR2(4000),
    ID_JURISDICCION  VARCHAR2(4000),
    ID_CANTON        VARCHAR2(4000),
    ID_PARROQUIA     VARCHAR2(4000),
    ID_SECTOR        VARCHAR2(4000),
    ID_ELEMENTO      VARCHAR2(4000),
    ID_EDIFICIO      VARCHAR2(4000)
  );

  /**
   * Documentaci�n para TYPE 'Tt_SectorizacionInsBwMens'.
   * TYPE TABLE para almacenar todos los valores de sectorizaci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 18-10-2019
   */
  TYPE Tt_SectorizacionInsBwMens IS TABLE OF Tr_SectorizacionInsBwMens INDEX BY PLS_INTEGER;

  /*
   * Documentaci�n para TYPE 'Tr_ParametrosValidarSec'.
   *
   * Record de los par�metros necesarios para validar la sectorizaci�n de un servicio.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 18-10-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @versi�n 1.1 07-03-2023 - Se agrega EMPRESA_COD a la tabla dinamica.
   */
  TYPE Tr_ParametrosValidarSec IS RECORD (
    ID_GRUPO_PROMOCION NUMBER,
    ID_TIPO_PROMOCION  NUMBER,
    TIPO_PROMOCION     VARCHAR2(10), --PROM_MENS,PROM_INS,PROM_BW
    ID_PUNTO           NUMBER,
    ID_SERVICIO        NUMBER,
    TIPO_EVALUACION    VARCHAR2(20), --NUEVO,EXISTENTE
    EMPRESA_COD        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  );

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_SECTORIZACION'.
   *
   * Funci�n que verifica que el punto cumpla con las reglas de sectorizaci�n de una promoci�n.
   * Devuelve como respuesta un valor de tipo Boolean 1(Uno) "Si Aplica" � 0(Cero) "No Aplica".
   *
   * Costo del Query C_SevicioPunto          : 13
   * Costo del Query C_SectorizacionServicio : 29
   * Costo del Query C_ExisteSectElemEdif    : 2
   *
   * @Param Pr_ParametrosValidarSec IN Tr_ParametrosValidarSec
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 18-10-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 15-11-2019 - Se modifica cursor C_SevicioPunto para considera el estado de la estructura info_servicio.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 10-12-2020 - Se modifica cursor C_SevicioPunto para que no considere la estructura info_servicio_historial.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.3 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
   */
  FUNCTION F_VALIDA_SECTORIZACION(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para Funci�n 'F_GET_CURSOR_SECTORIZACION'.
   * Funci�n que devuelve el cursor de las sectorizaciones de una promoci�n.
   *
   * Costo del SYS_REFCURSOR: 7
   *
   * @Param Pr_ParametrosValidarSec IN RECORD - Recibe un record de tipo Tr_ParametrosValidarSec
   * @Return SYS_REFCURSOR
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 18-10-2019
   */
  FUNCTION F_GET_CURSOR_SECTORIZACION(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN SYS_REFCURSOR;

  /**
   * Documentaci�n para la Funci�n 'F_EXISTE_SOLICITUD_OLT'.
   * M�todo que valida si existe una solicitud de cambio de OLT de un punto cliente.
   *
   * Costo del SYS_REFCURSOR: 7
   *
   * @Param Pr_ParametrosValidarSec IN RECORD - Recibe un record de tipo Tr_ParametrosValidarSec
   * @Return BOOLEAN
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 18-10-2019
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 07-03-2023 - Se agrega empresa como filtro en los querys que hacen referencia a las estructuras de parametros.
   */
  FUNCTION F_EXISTE_SOLICITUD_OLT(Pr_ParametrosValidarSec Tr_ParametrosValidarSec)
    RETURN BOOLEAN;

  /**
  * Documentaci�n para PROCESO 'P_OBTIENE_PROMO_TENTATIVAS'.
  * Proceso encargado de obtener las promociones activas por Tipo Promoci�n y fechas de vigencias.
  *
  * Costo del Query C_GrupoPromociones: 12
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoProceso           IN VARCHAR2
  * @Param Pd_FechaEvalua           IN DATE DEFAULT NULL
  * @Param Prf_GruposPromociones    OUT SYS_REFCURSOR
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 29-10-2019
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 16-07-2020 - Se agrega un nuevo par�metro de entrada Pd_FechaEvalua para que obtenga las promociones con la fecha
  *                           enviada, en caso que el par�metro llego con un valor nulo se tomar� la fecha del sistema.  
  */
  PROCEDURE P_OBTIENE_PROMO_TENTATIVAS(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoProceso           IN VARCHAR2,
                                       Pd_FechaEvalua           IN DATE DEFAULT NULL,
                                       Prf_GruposPromociones    OUT SYS_REFCURSOR);

  /**
  * Documentaci�n para PROCESO 'P_OBTIENE_SERVICIOS_PUNTO'.
  * Proceso encargado de obtener los servicios de un punto que se encuentran en un flujo de activaci�n.
  *
  * Costo del Query C_ServiciosPunto: 12
  *
  * PARAMETROS:
  * @Param Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 29-10-2019
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 19-04-2022 - Se agregan par�metros de CodigoGrupoPromocion, TipoProceso, CaractCodProm, IdServicio por default null 
  *                            para el proceso por tentativa. El TipoProceso para las validaciones es 'PROM_EVAL_TENTATIVA'.
  *                           Se agrega sentencia para validaci�n mediante funci�n para obtener servicios del punto cuando 
  *                            no est�n registrados en la tabla de tentativa o historial de servicio. 
  *                           Se agrega sentencia para validaci�n mediante funci�n a servicios de plan de internet cuando se procese por c�digo 
  *                            de promoci�n por PROM_INS.
  *                           Cuando se env�e la caracter�stica de c�digo promocional valida que s�lo consulte servicios con c�digos promocionales.                        
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 28-02-2023 - Se agrega sentencia empresa_cod en la consulta Lv_CadenaQuery para los par�metros.
  */
  PROCEDURE P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                      Pv_Codigo               IN VARCHAR2 DEFAULT NULL,
                                      Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL,
                                      Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE DEFAULT NULL,
                                      Pv_CaractCodProm        IN VARCHAR2 DEFAULT NULL,
                                      Pn_IdServicio           IN NUMBER DEFAULT NULL,
                                      Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar);

  /**
  * Documentaci�n para FUNCTION 'F_ESTADO_CONTRATO'.
  * Funci�n que obtiene el estado actual de contrato solo se consideran los siguinetes estados: "ACTIVO",
  * "PENDIENTE", "PORAUTORIZAR" � NULL.
  *
  * Costo del Query C_EstadosContratos: 4
  * Costo del Query C_EstadoContrato: 6
  *
  * PARAMETROS:
  * @Param Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE Recibe id del punto
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 08-11-2019
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 02-03-2023 - Se agrega cursor C_GetEmpresa para obterne el codigo de la empresa por medio del idServicio,
  *                           el mismo que servira para filtar la empresa en los cursores que utilizan las tablas de parametros.
  */                                      
  FUNCTION F_ESTADO_CONTRATO(Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;

  /**
  * Documentaci�n para FUNCTION 'F_ESTADO_SERVICOS'.
  * Funci�n que obtiene la fecha del servicio seg�n los estados configurados en el par�metro de Estados Servicios.
  * Fecha_servicio � NULL.
  *
  * Costo del Query C_GetParametro: 4
  * Costo del Query C_GetFeCreacionServ: 7
  * Costo del Query C_GetFeCreaAdendum: 6
  * Costo del Query C_GetServicioInternet: 10
  * Costo del Query C_GetOrigenWeb: 3 
  *
  * PARAMETROS:
  * @Param Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE Recibe id del punto
  * @Param Fv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE Recibe el nombre del par�metro
  * @Param Fv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE Recibe el tipo de promoci�n
  * @Param Fv_EstadoActivo    VARCHAR2 Recibe el estado del par�metro
  * @Param Fv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE Recibe el id de la empresa
  * @Param Fv_TipoPto         VARCHAR2 ('PTO_ADICIONAL','PTO_NUEVO')
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 15-11-2019
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 16-07-2020 - Se agrega par�metro Fv_TipoPto ('PTO_ADICIONAL','PTO_NUEVO') para obtener la fecha para evaluar 
  *                           las promociones por instalaci�n.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.2 03-03-2023 - Se agrega filtro de empresa en el cursor C_GetFeCreaAdendum.
  */                                      
  FUNCTION F_ESTADO_SERVICOS(Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Fv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Fv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Fv_EstadoActivo    VARCHAR2,
                             Fv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Fv_TipoPto         IN VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentaci�n para PROCESO 'P_MAPEO_PROM_TENTATIVA'.
  * Proceso encargado de evaluar si un servicio cae en una de las promociones para enviar informaci�n a Contrato Digital.
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
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param Pn_FormaPagoId          IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
  * @Param Pn_TipoCuentaId         IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
  * @Param Pn_BancoTipoCuentaId    IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE,
  * @Param Pn_Descuento            OUT NUMBER
  * @Param Pn_CantPeriodo          OUT NUMBER
  * @Param Pv_Observacion          OUT VARCHAR2
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 29-10-2019 
  *
  * @author Edgar Holgu�n <eholgu�n@telconet.ec> Se agrega a funcionalidad original par�metros correspondientes a una nueva forma de pago
  * @version 1.1 16-03-2020
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.2 16-07-2020 - Se direcciona los valores que se enviaran a los par�metros del proceso P_OBTIENE_PROMO_TENTATIVAS evitando
  *                           que crucen valores con los par�metros DEFAULT NULL.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.3 11-11-2020 - Se direcciona los valores que se enviaran a los par�metros a la funci�n F_VALIDA_TIPO_NEGOCIO evitando que
  *                           crucen valores con los par�metros DEFAULT NULL.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.4 06-09-2021 -Se agrega envio de parametros al procedimiento invocado  P_GET_PROMOCIONES_SECT: Pn_IdPunto y Pn_IdServicio debido a 
  *                          que el Cursor C_SectorizacionPto que obtiene los datos del servicio y punto del cliente retorna: 
  *                          "Cursor vacio para obtener los datos de sectorizaci�n del servicio" por lo cual no se puede obtener los Grupos
  *                           Promocionales para la evaluaci�n de reglas, devolviendo cero en la tentativa.
  */
  PROCEDURE P_PROMO_TENTATIVA(Pn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Pn_IdServicio           IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Pv_CodigoGrupoPromocion IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Pn_FormaPagoId          IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                              Pn_TipoCuentaId         IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                              Pn_BancoTipoCuentaId    IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE,
                              Pn_Descuento            OUT NUMBER,
                              Pn_CantPeriodo          OUT NUMBER,
                              Pv_Observacion          OUT VARCHAR2);

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_FORMA_PAGO_CFP'.
   *
   * Funci�n que verifica que el punto cumpla con las forma de pago (enviada como par�metro) de una promoci�n,
   * devuelve como respuesta un valor de tipo Boolean 1 "Si Aplica" � 0 "No Aplica".
   *
   * Costo del Query C_TipoPomocion: 2
   * Costo del Query C_FormaPagoMens: 2
   * Costo del Query C_FormaPagoInsABan: 3
   * Costo del Query C_ExisteBancoTipoCta: 2
   *
   * PARAMETROS:
   * @Param Fn_IntIdPromocion     IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE
   * @Param Fn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   * @Param Fn_FormaPagoId        IN DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE
   * @Param Fn_TipoCuentaId       IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE
   * @Param Fn_BancoTipoCuentaId  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 03-06-2019
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.1 16-03-2020 Se agrega a funcionalidad original env�o de par�metros correspondientes a una nueva forma de pago.
   */
  FUNCTION F_VALIDA_FORMA_PAGO_CFP(Fn_IntIdPromocion     IN  DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                   Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                   Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                   Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para PROCEDURE 'P_VALIDACIONES_PREVIAS_CODIGO'.
   *
   * Proceso que realiza una evaluaci�n de un c�digo promocional ingresado por el Usuario, se evalua c�digo existente y reglas
   * del c�digo promocional contra la informaci�n del servicio.
   *
   * Costo del Query C_CodigoPromocionMens: 17
   * Costo del Query C_CodigoPromocionInsBw: 13
   * Costo del Query C_TipoProcesoInsBw: 6
   * Costo del Query C_TipoProcesoMens: 6
   * Costo del Query C_VigenciaPromo: 2
   * Costo del Query C_PromoActiva: 2
   * Costo del Query C_PtoServicio: 6
   * Costo del Query C_Punto: 3
   * Costo del Query C_PeriodoDesc: 3
   * Costo del Query C_Datos: 2
   * Costo del Query C_GetNombrePlan: 6
   * Costo del Query C_Parametros: 3
   * Costo del Query C_Servicio: 7
   * Costo del Query C_CuentaPuntos: 264
   * Costo del Query C_ExistePlan: 6
   *
   * PARAMETROS:
   * @Param Pv_Trama                 IN  VARCHAR2 (Grupo Promoci�n, Tipo Promoci�n, Tipo Proceso, IdEmpresa, C�digo)
   * @Param Pn_IdServicio            IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL
   * @Param Pn_IdPunto               IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL
   * @Param Pn_IdPlan                IN  DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE DEFAULT NULL
   * @Param Pn_IdProducto            IN  DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE DEFAULT NULL
   * @Param Pn_IdUltimaMilla         IN  DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE DEFAULT NULL
   * @Param Pv_FormaPago             IN VARCHAR2 DEFAULT NULL (Tipo, idFormaPago)
   * @Param Pv_Mensaje               OUT VARCHAR2
   * @Param Pv_Detalle               OUT VARCHAR2
   * @Param Pv_ServiciosMix          OUT VARCHAR2
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 11-11-2020
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.1 02-03-2023 - Se agrega empresa_cod en el llamado a funci�n P_GET_RESTRIC_PLAN_INST.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
   */
  PROCEDURE P_VALIDACIONES_PREVIAS_CODIGO(Pv_Trama                 IN  VARCHAR2,
                                          Pn_IdServicio            IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                          Pn_IdPunto               IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                          Pn_IdPlan                IN  DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE DEFAULT NULL,
                                          Pn_IdProducto            IN  DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE DEFAULT NULL,
                                          Pn_IdUltimaMilla         IN  DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE DEFAULT NULL,
                                          Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                          Pv_Mensaje               OUT VARCHAR2,
                                          Pv_Detalle               OUT VARCHAR2,
                                          Pv_ServiciosMix          OUT VARCHAR2);

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_PLAN_PROD'.
   *
   * Funci�n que realiza una evaluaci�n de la regla de planes � productos entre una promoci�n y un servicio, si el servicio
   * cumple con los datos de planes � producto de la promoci�n la funci�n retorna un valor boolean.
   *
   * PARAMETROS:
   * @Param Fn_IdPlan                    IN NUMBER DEFAULT NULL
   * @Param Fn_IdProducto                IN NUMBER DEFAULT NULL
   * @Param Fv_CodigoTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
   * @Param Fa_TipoPromoPlanProdProcesar IN DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 11-11-2020
   */
  FUNCTION F_VALIDA_PLAN_PROD(Fn_IdPlan                    IN NUMBER DEFAULT NULL,
                              Fn_IdProducto                IN NUMBER DEFAULT NULL,
                              Fv_CodigoTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Fa_TipoPromoPlanProdProcesar IN DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar)
    RETURN BOOLEAN;

  /**
   * Documentaci�n para PROCEDURE 'P_INSERT_CARACTERISTICA_SERV'.
   *
   * Procedimiento que realiza la funcionalidad de insertar datos en la estructura INFO_SERVICIO_CARACTERISTICA.
   *
   * PARAMETROS:
   * @Param Pr_InfoServicioCaracteristica  IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE
   * @Param Pv_MsjResultado                OUT VARCHAR2
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 11-11-2020
   */
  PROCEDURE P_INSERT_CARACTERISTICA_SERV(Pr_InfoServicioCaracteristica  IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                         Pv_MsjResultado                OUT VARCHAR2);

  /**
   * Documentaci�n para PROCEDURE 'P_UPDATE_CARACTERISTICA_SERV'.
   *
   * Procedimiento que realiza la funcionalidad de actualizar datos en la estructura INFO_SERVICIO_CARACTERISTICA.
   *
   * PARAMETROS:
   * @Param Pr_InfoServicioCaracteristica  IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE
   * @Param Pv_MsjResultado                OUT VARCHAR2
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 11-11-2020
   */
  PROCEDURE P_UPDATE_CARACTERISTICA_SERV(Pr_InfoServicioCaracteristica  IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                         Pv_MsjResultado                OUT VARCHAR2);

  /**
   * Documentaci�n para FUNCTION 'F_OBTIENE_PROMOCION_COD'.
   *
   * Funci�n que permite recuperar el nombre de una promoci�n por el c�digo promocional.
   *
   * PARAMETROS:
   * @Param Fv_Codigo               IN VARCHAR2
   * @Param Fv_IdTipoPromocion      IN VARCHAR2 DEFAULT NULL,
   * @Param Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
   * @Param Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 01-12-2020
   */                                         
  FUNCTION F_OBTIENE_PROMOCION_COD(Fv_Codigo               IN VARCHAR2 DEFAULT NULL,
                                   Fv_IdTipoPromocion      IN VARCHAR2 DEFAULT NULL,
                                   Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE DEFAULT NULL,
                                   Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_PLAN_EMP_PYME'.
   *
   * Funci�n que permite validar si un plan pertenece a un empleado o pyme empresa.
   *
   * Costo del Query C_GetNombrePlan: 4
   *
   * PARAMETROS:
   * @Param Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 19-13-2021
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.1 02-03-2023 - Se agrega empresa_cod en el llamado a funci�n P_GET_RESTRIC_PLAN_INST.
   *
   * Costo del Query C_GetEmpresa: 8
   *
   */ 
  FUNCTION F_VALIDA_PLAN_EMP_PYME(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_SOLICITUD_SERVICIO'.
   *
   * Funci�n que permite validar si un servicio cuenta ya con una solicitud de descuento.
   *
   * Costo del Query C_GetSolicitud: 7
   *
   * PARAMETROS:
   * @Param Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 19-13-2021
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 02-03-2023 - Se agrega cursor C_GetEmpresa para obterne el codigo de la empresa por medio del idServicio,
   *                           el mismo que servira para filtar la empresa en los cursores que utilizan las tablas de parametros.
   */     
  FUNCTION F_VALIDA_SOLICITUD_SERVICIO(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2;

  /**
   * Documentaci�n para FUNCTION 'F_VALIDA_ROL'.
   *
   * Funci�n que permite validar si un punto pertenece a una persona con un rol Cliente � PreCliente.
   *
   * Costo del Query C_RolPersona: 15
   *
   * PARAMETROS:
   * @Param Fn_IdPunto    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   * @Param Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 19-13-2021
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.1 28-02-2023 - Se agrega sentencia por empresa_cod en par�metros para cursor C_RolPersona.
   */
  FUNCTION F_VALIDA_ROL(Fn_IdPunto    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                        Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN BOOLEAN;

  /**
  *  Documentaci�n para TYPE 'Lr_SolicitudesProcesar'.
  *
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-03-2021
  */
  TYPE Lr_SolicitudesProcesar IS RECORD (
    ID_DETALLE_SOLICITUD  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE);

  /**
  * Documentaci�n para TYPE 'T_SolicitudesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-03-2021
  */
  TYPE T_SolicitudesProcesar IS TABLE OF Lr_SolicitudesProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para PROCEDURE 'P_REGULARIZA_SOLICITUDES'.
  *
  * Procedimiento que regulariza las solicitudes de promociones que se encuentran encoladas a estado eliminada.
  *
  * @Param Pv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_DescSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE
  * 
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-03-2021
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */ 
  PROCEDURE P_REGULARIZA_SOLICITUDES(Pv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_DescSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DETALLE_SOLI'.
  *
  * Procedimiento que actualiza registro de la solicitud en INFO_DETALLE_SOLICITUD
  *
  * @Param Pr_InfoDetalleSolicitud  IN   DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE Recibe un registro con la informaci�n
  * @Param Pv_MsnError              OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-03-2021
  */                                   
  PROCEDURE P_UPDATE_INFO_DETALLE_SOLI(Pr_InfoDetalleSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                       Pv_MsnError             OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_DETALLE_SOL_HIST'.
  *
  * Procedimiento que inserta registro de historial en la solicitud en INFO_DETALLE_SOL_HIST
  *
  * @Param Pr_InfoDetalleSolHist  IN   DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE Recibe un registro con la informaci�n necesaria para ingresar
  * @Param Pv_MsnError            OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-03-2021
  */                                      
  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
                                           Pv_MsnError             OUT VARCHAR2);

  /**
   * Documentaci�n para FUNCTION 'F_COMPARAR_PLAN_PROMO_BW'.
   * Funci�n que compara los dos planes por la caracter�stica del line profile de las promociones de ancho de banda.
   *
   * PARAMETROS:
   * @Param Fn_PlanIdUno IN NUMBER     - Id del plan uno
   * @Param Fn_PlanIdDos IN NUMBER     - Id del plan dos
   *
   * @author Felix Caicedo <facaicedo@telconet.ec>
   * @version 1.0 26-01-2022
   */
   FUNCTION F_COMPARAR_PLAN_PROMO_BW(Fn_PlanIdUno IN NUMBER,
                                     Fn_PlanIdDos IN NUMBER)
   RETURN VARCHAR2;

  /**
   * Documentaci�n para FUNCTION 'F_GET_LINE_PROFILE_PROMO_BW'.
   * Funci�n que obtiene el line profile del plan.
   *
   * PARAMETROS:
   * @Param Fn_PlanId IN NUMBER - Id del plan
   *
   * @author Felix Caicedo <facaicedo@telconet.ec>
   * @version 1.0 11-02-2022
   */
   FUNCTION F_GET_LINE_PROFILE_PROMO_BW(Fn_PlanId IN NUMBER)
   RETURN VARCHAR2;

  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_EVALUA_TENTATIVA'.
  *
  * Procedimiento que inserta registro en la tabla de tentativa INFO_EVALUA_TENTATIVA.
  *
  * PARAMETROS:
  * @Param Pr_InfoEvaluaTentativa IN DB_COMERCIAL.INFO_EVALUA_TENTATIVA%ROWTYPE
  * @Param Pv_MsjResultado        OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 01-04-2022
  */
  PROCEDURE P_INSERT_INFO_EVALUA_TENTATIVA(Pr_InfoEvaluaTentativa IN DB_COMERCIAL.INFO_EVALUA_TENTATIVA%ROWTYPE,
                                           Pv_MsjResultado        OUT VARCHAR2); 

  /**
  * Documentaci�n para FUNCTION 'F_VALIDA_TENTATIVA'.
  *
  * Funci�n que permite validar si existe registro de promoci�n por tentativa, devuelve como respuesta un valor
  * de tipo VARCHAR2 "S -> Existe registro en la tabla tentativa o historial de servicio" � "N -> No existe registro".
  *
  * PAR�METROS:
  * @Param Fn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  *
  * Costo query C_GetServTentativa: 7
  * Costo query C_GetServHistorial: 8
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 05-04-2022
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 28-02-2023 - Se agrega sentencia por empresa_cod en par�metros para cursor C_GetServTentativa.
  */                                           
  FUNCTION F_VALIDA_TENTATIVA(Fn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
  RETURN VARCHAR2; 

  /**
  * Documentaci�n para FUNCTION 'F_GET_FECHA_ADENDUM'.
  *
  * Funci�n que permite retornar la fecha m�nima del adendum mediante de los servicios.
  *
  * PAR�METROS:
  * @Param Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Fa_ServiciosProcesar IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar
  *
  * Costo query Lv_Consulta: 9
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 08-04-2022
  */                                           
  FUNCTION F_GET_FECHA_ADENDUM(Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Fa_ServiciosProcesar IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar)
  RETURN DATE; 

  /**
  * Documentaci�n para FUNCTION 'F_VALIDA_SERVICIO_INTD'.
  *
  * Funci�n que permite validar que el servicio sea de internet, devuelve como respuesta un valor de
  * tipo VARCHAR2 "S -> Es un servicio con plan INTD" � "N -> No es un servicio con plan de internet".
  *
  * PAR�METROS:
  * @Param Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  *
  * Costo query C_GetServPlanIntd: 7
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 06-05-2022
  */                                           
  FUNCTION F_VALIDA_SERVICIO_PLAN_INTD(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2; 

  /**
  * Documentaci�n para PROCEDURE 'P_PROMOCION_TENTATIVA'.
  *
  * Nuevo proceso de promoci�n de tentativa migrado reemplaza al proceso "P_MAPEO_PROM_TENTATIVA".
  * Proceso encargado de evaluar si el punto cae en una de las promociones para enviar informaci�n a Contrato Digital.
  * Se eval�a adicional las promociones por mix y por producto.
  *
  * PAR�METROS:
  * @Param Pn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pv_CodigoGrupoPromocion IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_CodMensaje           OUT VARCHAR2
  * @Param Pv_Status               OUT VARCHAR2
  * @Param Pv_Mensaje              OUT VARCHAR2
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 14-04-2022
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 27-04-2023 - Se agregan log para falicitar revisiones de seguimento.
  */ 
  PROCEDURE P_PROMOCION_TENTATIVA(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                  Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_CodMensaje           OUT VARCHAR2,
                                  Pv_Status               OUT VARCHAR2,
                                  Pv_Mensaje              OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_PROMOCION_EVALUA_TENTATIVA'.
  *
  * Nuevo proceso de promoci�n de tentativa migrado reemplaza al proceso "P_PROMOCIONES_TENTATIVA".
  * Proceso encargado de evaluar si el punto cae en una de las promociones para enviar informaci�n a Contrato Digital.
  * Se eval�a adicional las promociones por mix y por producto.
  * En el proceso los mensajes se parametrizaron y se agrega cambios para el registro y validaciones con la tabla INFO_EVALUA_TENTATIVA.
  *
  * PAR�METROS:
  * @Param Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL
  * @Param Pv_CodMensaje           OUT VARCHAR2
  * @Param Pv_Status               OUT VARCHAR2
  * @Param Pv_Mensaje              OUT VARCHAR2
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 19-04-2022
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 28-02-2023 - Se agrega sentencia por empresa_cod en par�metros para cursor C_GetIdPromocionMens.
  *                           Se agrega empresa_cod en el llamado a funci�n P_GET_RESTRIC_PLAN_INST.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.2 27-04-2023 - Se agregan log para falicitar revisiones de seguimento.
  */ 
  PROCEDURE P_PROMOCION_EVALUA_TENTATIVA(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                         Pv_CodMensaje           OUT VARCHAR2,
                                         Pv_Status               OUT VARCHAR2,
                                         Pv_Mensaje              OUT VARCHAR2);

 /**
  *  Documentaci�n para TYPE 'Lr_EvaluaTentativa'.
  *  
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-04-2022
  */      
  TYPE Lr_EvaluaTentativa IS RECORD (
    PUNTO_ID               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,   
    SERVICIO_ID            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    GRUPO_PROMOCION_ID     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
    TIPO_PROMOCION_ID      DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
    TIPO_PROMOCION         DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,   
    DESCUENTO	           DB_COMERCIAL.INFO_EVALUA_TENTATIVA.DESCUENTO%TYPE,
    CANTIDAD_PERIODOS	   DB_COMERCIAL.INFO_EVALUA_TENTATIVA.CANTIDAD_PERIODOS%TYPE,
    OBSERVACION	           DB_COMERCIAL.INFO_EVALUA_TENTATIVA.OBSERVACION%TYPE,
    FE_CREACION            DB_COMERCIAL.INFO_EVALUA_TENTATIVA.FE_CREACION%TYPE,
    EMPRESA_COD            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE
  ); 

  /**
  * Documentaci�n para TYPE 'T_EvaluaTentativa'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-04-2022
  */
  TYPE T_EvaluaTentativa IS TABLE OF Lr_EvaluaTentativa INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para PROCEDURE 'P_OBTIENE_EVALUA_TENTATIVA'.
  *
  * Procedimiento que obtiene de la tabla INFO_EVALUA_TENTATIVA las promociones tentativas por instalacion y mensualidad de un punto y servicio especifico, 
  * Costo Query obtiene Promocion Tentativa:7
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion 
  * Tipo de Promoci�n a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  *      Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad ,   
  * PROM_INS:  Descuento y Diferido de Instalaci�n.
  *
  * @Param Pv_CodEmpresa         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, C�digo de Empresa.
  * @Param Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  * @Param Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Prf_PromoTentativa    OUT SYS_REFCURSOR Obtiene listado de Tipos de Promociones a Procesar.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-04-2022
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 28-02-2023 - Se agrega sentencia empresa_cod en la consulta Lv_Consulta para los par�metros.
  */  
  PROCEDURE P_OBTIENE_EVALUA_TENTATIVA(Pv_CodigoGrupoPromocion      IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa                IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                                                                   
                                       Pn_IdPunto                   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                      
                                       Pn_IdServicio                IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Prf_PromoTentativa           OUT SYS_REFCURSOR); 

/**
  * Documentaci�n para PROCEDURE 'P_OBSERVACION_TENTATIVA'.
  *
  * Procedimiento que permite obtener la observaci�n de la promocion tentativa en instalacion PROM_INS, y en mensualidad PROM_MENS
  * en base a los mensajes de observacion parametrizados por tipo de promocion y en base a las reglas promocionales y parametros enviados.
  *
  * PARAMETROS:
  * @Param Pv_CodigoGrupoPromocion 
  * Tipo de Promoci�n a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  *      Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad ,   
  * PROM_INS:  Descuento y Diferido de Instalaci�n.
  *
  * @Param Pn_IdPromocion           IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
  * @Param Pv_CodigoTipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
  * @Param Pn_IdTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,    
  * @Param Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL
  * @Param Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_DescripcionObserv     OUT VARCHAR2 
  *
  * Costo query C_ObtieneValorObsProm: 3
  * Costo query C_CantidadPeriodos: 2
  * Costo query C_PeriodoDesc: 3
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-05-2022
  */     
 PROCEDURE P_OBSERVACION_TENTATIVA(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pn_IdPromocion           IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                   Pv_CodigoTipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Pn_IdTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,                                                                                                                                          
                                   Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL,
                                   Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_DescripcionObserv     OUT VARCHAR2);         

 /**
  * Documentaci�n para PROCEDURE 'P_MENSAJE_POR_CODIGO_ERROR'.
  *
  * Procedimiento que permite obtener los mensajes parametrizados por codigo de error parametro 'PARAM_EVALUA_TENTATIVA',
  * descripcion 'CODIGO_MENSAJE'
  *
  * @Param Pv_CodigoGrupoPromocion 
  *   PROM_MENS: Grupo de Promociones Mensual. 
  *   PROM_INS:  Descuento y Diferido de Instalaci�n.
  *
  * @Param Pn_IdPunto                IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @Param Pv_CodMensaje             IN VARCHAR2
  * @Param Pv_CodEmpresa             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Mensaje                OUT VARCHAR2 
  * @Param Pv_Descuento              OUT VARCHAR2 
  * @Param Pv_VisualizarContrato     OUT VARCHAR2 
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 09-05-2022
  */     
  PROCEDURE P_MENSAJE_POR_CODIGO_ERROR(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                       Pv_CodMensaje            IN VARCHAR2,
                                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_Mensaje               OUT VARCHAR2, 
                                       Pv_Descuento             OUT VARCHAR2,
                                       Pv_VisualizarContrato    OUT VARCHAR2); 

/**
  * Documentaci�n para PROCEDURE 'P_CONSUME_EVALUA_TENTATIVA'.
  *
  * Procedimiento que consume proceso P_OBTIENE_EVALUA_TENTATIVA para obtener las promociones tentativas por instalacion y mensualidad de un punto y servicio especifico,   
  *
  * PARAMETROS:
  * @Param Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  * @Param Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  
  * @Param Pv_CodigoGrupoPromocion 
  * Tipo de Promoci�n a ejecutarse: 
  * PROM_MENS: Grupo de Promociones Mensual.
  *      Del Grupo Mensual se procesan 4 Tipos de Promociones:
  *      1. PROM_MIX:  Descuento en Mensualidad Mix de Planes,
  *      2. PROM_MPLA: Descuento en Mensualidad de Planes, 
  *      3. PROM_MPRO: Descuento en Mensualidad de Productos, 
  *      4. PROM_TOT:  Descuento Total en Mensualidad ,   
  * PROM_INS:  Descuento y Diferido de Instalaci�n.
  *
  * @Param Pv_CodEmpresa       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, C�digo de Empresa. 
  * @Param Pn_Descuento        OUT NUMBER,
  * @Param Pn_CantPeriodo      OUT NUMBER,
  * @Param Pv_Observacion      OUT VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 03-05-2022
  */                                       
   PROCEDURE P_CONSUME_EVALUA_TENTATIVA(Pn_IdPunto                 IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                      
                                        Pn_IdServicio              IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,  
                                        Pv_CodigoGrupoPromocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                        Pv_CodEmpresa              IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                                                                   
                                        Pn_Descuento               OUT NUMBER,
                                        Pn_CantPeriodo             OUT NUMBER,
                                        Pv_Observacion             OUT VARCHAR2);

  /**
  * Documentaci�n para FUNCTION 'F_OTIENE_ESTADO_PROMOCION'.
  *
  * Funci�n que verifica el estado del �ltimo mapeo promocional vigente del servicio (Activo/Finalizado/Baja).
  *
  * Costo Query C_EstadoMapeo 3
  *
  * PARAMETROS:
  * @Param Fn_IntIdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Fv_GrupoPromocion  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE
  * @Param Fv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 03-01-2023
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 07-03-2023 - Se agregan validacion por proyecto Ecuanet.
  */                              
  FUNCTION F_OTIENE_ESTADO_PROMOCION(Fn_IntIdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Fv_GrupoPromocion IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                                     Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2;

  /**
  * Documentaci�n para PROCEDURE 'P_ACTUALIZAR_SOLICITUDES'.
  *
  * Proceso encargado de actualizar el estado de una solicitud e ingresar el historial de la misma.
  *
  * Costo Query C_Solicitudes 11
  *
  * PARAMETROS:
  * @Param Pa_ServiciosPromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar
  * @Param Pv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_TipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_EstadoOld       IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE
  * @Param Pv_EstadoNew       IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE
  * @Param Pv_Observacion     IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.OBSERVACION%TYPE
  * @Param Pv_Mensaje         OUT VARCHAR2
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 04-01-2023
  */   
  PROCEDURE P_ACTUALIZAR_SOLICITUDES(Pa_ServiciosPromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar,
                                     Pv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_EstadoOld       IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_EstadoNew       IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_Observacion     IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.OBSERVACION%TYPE,
                                     Pv_Mensaje         OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'F_POMOCIONES_VIGENTES'.
  *
  * Proceso encargado de actualizar el estado de una solicitud e ingresar el historial de la misma.
  *
  * Costo Query C_PromocionCodigo 20
  * Costo Query C_Promocion 15
  * Costo Query C_GetParamNumeroMesesContrato 5
  *
  * PARAMETROS:
  * @Param FV_TipoProceso IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE
  * @Param Fv_CodEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Fv_EsCodigo    IN VARCHAR2 DEFAULT NULL
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 17-03-2023
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 11-04-2023 - Se mejora los querys de consulta de promociones vigentes para que se valide el d�a completo.
  */ 
  FUNCTION F_POMOCIONES_VIGENTES(FV_TipoProceso IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE,
                                 Fv_CodEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Fv_EsCodigo    IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

END CMKG_PROMOCIONES_UTIL;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PROMOCIONES_UTIL AS
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
                                          Cv_Estado       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                          Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS
    SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_MESES
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
    DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
    AND APD.ESTADO             = Cv_Estado
    AND APD.EMPRESA_COD        = Cv_CodEmpresa
    AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
    AND APC.ESTADO             = Cv_Estado;

    --Costo: 8
    CURSOR C_GetEmpresa(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT IER.EMPRESA_COD
      FROM DB_COMERCIAL.INFO_PUNTO PTO,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE PTO.ID_PUNTO        = Cn_IdPunto
      AND IPER.ID_PERSONA_ROL   = PTO.PERSONA_EMPRESA_ROL_ID
      AND IER.ID_EMPRESA_ROL    = IPER.EMPRESA_ROL_ID;

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
    Lv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  BEGIN


    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;

    OPEN C_GetEmpresa(Fn_PuntoId);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;

    Lv_Estado := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_ESTADO_CONTRATO (Fn_PuntoId);

    OPEN  C_GetParamNumeroMesesContrato(Cv_NombreParam => 'PROMOCIONES_NUMERO_MESES_EVALUA_FE_CONTRATO',
                                        Cv_Estado      => 'Activo',
                                        Cv_CodEmpresa  => Lv_CodEmpresa);
    FETCH C_GetParamNumeroMesesContrato INTO Ln_NumeroMeses;
    CLOSE C_GetParamNumeroMesesContrato;

    OPEN  C_CuentaPuntos(Cn_IdPunto => Fn_PuntoId);
    FETCH C_CuentaPuntos INTO Ln_TotalPuntos, Ln_PersonaEmpRolId;
    CLOSE C_CuentaPuntos;

    IF Ln_TotalPuntos > 0 THEN

      --Es Punto Adicional 

      IF Fv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        --
        -- Si es Promoci�n de mensualidad obtengo la fecha de creaci�n del servicio confirmado de Internet.
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
        Ld_FeEvaluaVigencia := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_ESTADO_SERVICOS (Fn_PuntoId,'PROM_ESTADO_SERVICIO',Fv_CodigoGrupoPromocion,'Activo',Lv_CodEmpresa,'PTO_ADICIONAL');             
        --
      END IF;
      --
    ELSE

      --Es Cliente Nuevo

      IF Fv_CodigoGrupoPromocion = 'PROM_MENS' THEN       
        --
        -- Si es Promoci�n de mensualidad obtengo la fecha de creaci�n del servicio confirmado de Internet.
        OPEN  C_GetFeCreaServInternetActivo(Cn_IdPunto => Fn_PuntoId, Cv_EstadoServ => Fv_EstadoServ);
        FETCH C_GetFeCreaServInternetActivo INTO Ld_FeCreaServicio;
        CLOSE C_GetFeCreaServInternetActivo;        
        --
        --Si el servicio confirmado es un servicio de internet debo tomar la fecha de creaci�n contrato.
        --Si el servicio confirmado es un servicio adicional obtengo la minima fecha de creaci�n de sus servicios adicionales.
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
               Ld_FeCreaServicio := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_ESTADO_SERVICOS (Fn_PuntoId,'PROM_ESTADO_SERVICIO',Fv_CodigoGrupoPromocion,'Activo',Lv_CodEmpresa,'PTO_NUEVO');

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
    --Si no se pudo obtener Fecha para evaluaci�n de vigencias se inserta error y se envia NULL
    IF Ld_FeEvaluaVigencia IS NULL THEN
       RAISE Le_Exception;         
    END IF; 

    RETURN Ld_FeEvaluaVigencia;
  EXCEPTION
    WHEN Le_Exception THEN      
      Lv_MsjResultado := 'Ocurrio un error al obtener la fecha para evaluaci�n de vigencia de los '||
                         'grupos promocionales ID_PUNTO: ' || Fn_PuntoId || ' ESTADO: ' ||Fv_EstadoServ ||
                         ' CODIGO: ' || Fv_CodigoGrupoPromocion;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES_UTIL.F_OBTIENE_FECHA_EVAL_VIGENCIA',
                                            Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

      RETURN NULL;
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurrio un error al obtener la fecha para evaluaci�n de vigencia de los '||
                         'grupos promocionales ID_PUNTO: ' || Fn_PuntoId || ' ESTADO: ' ||Fv_EstadoServ ||
                         ' CODIGO: ' || Fv_CodigoGrupoPromocion;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES_UTIL.F_OBTIENE_FECHA_EVAL_VIGENCIA',
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

      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ACTUALIZA_CARACT_PROMO_BW(Lr_InfoServicioProdCaract,Lv_MsjResultado);
      --
      IF Lv_MsjResultado IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;
      --
    END LOOP;     
    --
  EXCEPTION
  WHEN Le_Exception THEN
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso de eliminar caracter�sticas promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));    
   Pv_MsjResultado:= Lv_MsjResultado;
   --
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso de eliminar caracter�sticas promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW', 
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
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso que valida si elimina las caracter�sticas promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.P_VALIDA_ELIMINA_CARACT_BW', 
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
    --Actualizaci�n de las caracter�sticas promocionales de un servicio.
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
    Pv_MsjResultado := 'M�todo: P_UPDATE_CARACTERISTICA_PROMO, Error: '||SUBSTR(SQLERRM,0,2000);

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
      Pv_Mensaje := 'M�todo: P_INSERT_ISERVICIO_PROD_CARACT, Error: '||SUBSTR(SQLERRM,0,2000);
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
      Lv_MsjResultado := 'Par�metros incompletos';
      RAISE Le_Exception;
    END IF;

    FOR Lc_CaracteristicasPromo in C_ObtieneCaractPromo(Pn_IdServicio,Lv_NombreTecnicoProd,Lv_EstadoActivo) 
    LOOP
      --
      Lr_InfoServicioProdCaract                          := NULL;
      Lr_InfoServicioProdCaract.ID_SERVICIO_PROD_CARACT  := Lc_CaracteristicasPromo.ID_SERVICIO_PROD_CARACT;
      Lr_InfoServicioProdCaract.ESTADO                   := Lv_EstadoEliminado;
      Lr_InfoServicioProdCaract.USR_ULT_MOD              := Lv_UsuarioCreacion;

      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ACTUALIZA_CARACT_PROMO_BW(Lr_InfoServicioProdCaract,Lv_MsjResultado);
      --
      IF Lv_MsjResultado IS NOT NULL THEN
        RAISE Le_Exception;
      END IF;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso de eliminar caracter�sticas promocionales para el servicio: '
                         ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_INDV_BW', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           Lv_UsuarioCreacion,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
     Pv_MsjResultado:= Lv_MsjResultado;
   --
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso de eliminar caracter�sticas promocionales para el servicio: '
                       ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_INDV_BW', 
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
    --Cursor que obtiene el producto caracter�stica.
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
      Lv_MsjResultado := 'Par�metros incompletos';
      RAISE Le_Exception;
    END IF;

    OPEN C_AdmiProdCaract('INTERNET','18',Pv_NombreCaract,'Activo');
      FETCH C_AdmiProdCaract INTO Lc_AdmiProdCaract;
        Lb_TieneDatos := C_AdmiProdCaract%NOTFOUND;
    CLOSE C_AdmiProdCaract;

    IF Lb_TieneDatos THEN
      Lv_MsjResultado := 'La caracter�stica: '||Pv_NombreCaract||' no se encuentra configurada.';
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

    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_ISERVICIO_PROD_CARACT(Lr_InfoServProdCaract,Lv_MsjResultado);

    IF Lv_MsjResultado IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso de eliminar caracter�sticas promocionales para el servicio: '
                         ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_PROMOCIONES_UTIL.P_CREA_CARACT_INDV_BW', 
                                            Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            Lv_UsuarioCreacion,
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
   Pv_MsjResultado:= Lv_MsjResultado;
   --
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al ejecutar el proceso de eliminar caracter�sticas promocionales para el servicio: '
                         ||Pn_IdServicio || ', del Grupo Promocional: PROM_BW'; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_PROMOCIONES_UTIL.P_CREA_CARACT_INDV_BW', 
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
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                 Fn_IdPto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
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

    --Costo: 18
    CURSOR C_TipoNegocioPto(Cn_IntIdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                            Cn_IdPto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT 'X' AS VALOR 
      FROM DB_COMERCIAL.INFO_PUNTO DBIP,
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
       WHERE DBIP.ID_PUNTO           = Cn_IdPto
       AND ATN.ID_TIPO_NEGOCIO       = DBIP.TIPO_NEGOCIO_ID
       AND ATN.EMPRESA_COD           = Cv_CodEmpresa
       AND TO_NUMBER(TRIM(T1.VALOR)) = ATN.ID_TIPO_NEGOCIO;

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

    IF C_TipoNegocioPto%ISOPEN THEN
    --
      CLOSE C_TipoNegocioPto;
    --
    END IF;

    IF Fn_IdServicio IS NOT NULL AND Fn_IdServicio > 0 THEN
    --
      OPEN C_TipoNegocioInsABan(Fn_IntIdPromocion,
                                Fn_IdServicio,
                                Fv_CodEmpresa);
      --
      FETCH C_TipoNegocioInsABan INTO Lv_ExisteTipoNegocio;
      --
      CLOSE C_TipoNegocioInsABan;
    --
    ELSE
    --
      OPEN C_TipoNegocioPto(Fn_IntIdPromocion,
                            Fn_IdPto,
                            Fv_CodEmpresa);
      --
      FETCH C_TipoNegocioPto INTO Lv_ExisteTipoNegocio;
      --
      CLOSE C_TipoNegocioPto;    
    --
    END IF;

    IF Lv_ExisteTipoNegocio IS NULL THEN
      Lb_Aplica := FALSE;
    ELSE
      Lb_Aplica := TRUE;
    END IF;

    RETURN Lb_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Tipo de Negocio del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el Servicio: ' || Fn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO', 
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
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                 Fn_IdUltimaMilla  IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE DEFAULT NULL)
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

    IF Fn_IdUltimaMilla IS NULL THEN
    --
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
    --
    ELSE
    --  
      FOR Lc_UltimaMillaInsABan IN C_UltimaMillaInsABan(Fn_IntIdPromocion)
      LOOP
      --
        IF TO_NUMBER(TRIM(Lc_UltimaMillaInsABan.VALOR)) = NVL(Fn_IdUltimaMilla,0) THEN
          Lb_Aplica := TRUE;
          RETURN Lb_Aplica;
        END IF;
      --
      END LOOP;
    --  
    END IF;

    RETURN Lb_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de �ltima Milla del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el Servicio: ' || Fn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA', 
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
                               Fn_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Pv_Trama          IN VARCHAR2 DEFAULT NULL)
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
     WITH x(y) AS (SELECT Cv_Valores from dual)
     SELECT INSTR(',' || y || ',',','||Cn_Valor||',') AS VALOR
     FROM x;  

    Lc_Tipo_Pomocion      C_TipoPomocion%ROWTYPE;
    Lc_Forma_Pago_Punto   C_FormaPagoPunto%ROWTYPE;
    Lc_Banco_Tipo_Cuenta  C_BancoTipoCuenta%ROWTYPE;
    Ln_ExisteBancoTipoCta NUMBER;
    Ln_Posicion           NUMBER;
    Ln_IdFormaPago        NUMBER;
    Lb_Aplica             BOOLEAN := FALSE;
    Lv_MsjResultado       VARCHAR2(2000);
    Lv_Trama              VARCHAR2(3200);
    Lv_Valor              VARCHAR2(3200);
    Lv_TipoFormaPago      DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
    Lv_Estado             DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE;
    Le_Exception          EXCEPTION;

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

    IF Pv_Trama IS NOT NULL AND NVL(LENGTH(TRIM(Pv_Trama)),0) > 0 THEN
    --
      Lv_Trama := Pv_Trama;
      --
      WHILE NVL(LENGTH(Lv_Trama),0) > 0 LOOP

        Ln_Posicion := INSTR(Lv_Trama, '|' );

        IF Ln_Posicion > 0 THEN

          Lv_Valor := SUBSTR(Lv_Trama,1, Ln_Posicion-1);

          IF INSTR(Lv_Valor,'Tipo',1) > 0 THEN
            Lv_TipoFormaPago := UPPER(TRIM(SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1)));
          END IF;

          IF INSTR(Lv_Valor,'Valor',1) > 0 THEN
            Ln_IdFormaPago := COALESCE(TO_NUMBER(REGEXP_SUBSTR(SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1),'^\d+')),0);
          END IF;

          Lv_Trama := SUBSTR(Lv_Trama,Ln_Posicion+1);

        ELSE
          Lv_Trama := NULL;
        END IF;

      END LOOP;
      --
      IF Lv_TipoFormaPago IS NULL OR Ln_IdFormaPago IS NULL OR Ln_IdFormaPago = 0 THEN
        Lv_MsjResultado  := 'Ocurri� un error al recuperar datos para la evaluaci�n de forma de pago -> Lv_TipoFormaPago: '||
                            Lv_TipoFormaPago || ', Ln_IdFormaPago: '||Ln_IdFormaPago;
        RAISE Le_Exception;  
      END IF;

      OPEN C_TipoPomocion(Fn_intIdPromocion);
      --
      FETCH C_TipoPomocion INTO Lc_Tipo_Pomocion;
      --
        IF Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION = 'PROM_INS' OR Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION = 'PROM_BW' THEN
        --
          FOR Lc_FormaPago_Ins_ABan IN C_FormaPagoInsABan (Cn_IntIdPromocion => Fn_intIdPromocion)
          LOOP
          --
            IF Lv_TipoFormaPago = 'DEBITO BANCARIO' THEN
            --
              OPEN C_ExisteBancoTipoCta(Lc_FormaPago_Ins_ABan.EMISOR,
                                        Ln_IdFormaPago);
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
            ELSIF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Ins_ABan.FORMA_PAGO,'^\d+')),0) = Ln_IdFormaPago AND
              Lv_TipoFormaPago = 'EFECTIVO' THEN
              Lb_Aplica := TRUE;
              RETURN Lb_Aplica;
            END IF;
          --
          END LOOP;
        --
        ELSE
        --
          FOR Lc_FormaPago_Mens IN C_FormaPagoMens (Cn_IntIdPromocion => Fn_intIdPromocion)
          LOOP
          --
            IF Lv_TipoFormaPago = 'DEBITO BANCARIO' THEN
            --
              OPEN C_ExisteBancoTipoCta(Lc_FormaPago_Mens.EMISOR,
                                        Ln_IdFormaPago);
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
            ELSIF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Mens.FORMA_PAGO,'^\d+')),0) = Ln_IdFormaPago AND
              Lv_TipoFormaPago = 'EFECTIVO' THEN
              Lb_Aplica := TRUE;
              RETURN Lb_Aplica;
            END IF;
          --
          END LOOP;
        --
        END IF;
      --
      CLOSE C_TipoPomocion;
    --
    ELSE
    --
      Lv_Estado := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_ESTADO_CONTRATO (Fn_IdPunto);

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
    --
    END IF;
    RETURN Lb_Aplica;
  EXCEPTION
  WHEN Le_Exception THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO',
                                          Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Forma de Pago del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO', 
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
       Ln_Meses := TRUNC(MONTHS_BETWEEN (TRUNC(sysdate) ,TO_DATE(Lc_FechaConfirmacion.FECHA,'DD-MM-RRRR')));

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
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Permanencia M�nima del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' - ' || Fv_Tipo_Promocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_PERMANENCIA', 
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
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Mora del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' - ' || Fv_Tipo_Promocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA', 
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
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Antig�edad del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_ANTIGUEDAD', 
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
    CURSOR C_SectorizacionPunto(Cn_IdPunto    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DISTINCT IP.PUNTO_COBERTURA_ID AS ID_JURISDICCION,
        APA.CANTON_ID AS ID_CANTON,
        APA.ID_PARROQUIA,
        ASE.ID_SECTOR,
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
               AND DBATE.NOMBRE_TIPO_ELEMENTO = 'EDIFICACION'),0) AS ID_EDIFICIO
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
                                         AND APD.EMPRESA_COD      = Cv_CodEmpresa
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
    OPEN C_SectorizacionPunto(Fn_IdPunto,Fv_CodEmpresa);
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
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Sectorizaci�n por OLT del GRUPO_PROMOCION: '
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
                          Cv_EstadoActivo VARCHAR2,
                          Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
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
                                      AND APD.EMPRESA_COD      =  Cv_CodEmpresa)
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
      OPEN C_SevicioPunto(Pr_ParametrosValidarSec.ID_PUNTO,'Activo',Pr_ParametrosValidarSec.EMPRESA_COD);
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
        Lb_NoTieneDatos := C_SectorizacionServicio%NOTFOUND;
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

    --Obtenemos el cursor de la sectorizaci�n de acuerdo al tipo de promoci�n a la que se esta aplicando.
    Lr_Sectorizaciones := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_CURSOR_SECTORIZACION(Pr_ParametrosValidarSec);

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

            Lb_Aplica := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_EXISTE_SOLICITUD_OLT(Pr_ParametrosValidarSec);

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

    --En caso que el cursor no tenga datos, se retornar� true por motivos que la promoci�n se creo sin sectorizaci�n.
    IF Lr_Sectorizaciones%ROWCOUNT = 0 THEN
      Lb_Aplica := TRUE;
    END IF;

    CLOSE Lr_Sectorizaciones;

    RETURN Lb_Aplica;

  EXCEPTION

    WHEN Lex_Exception THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL',
                                           'F_VALIDA_SECTORIZACION',
                                            Lv_Error,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

      RETURN FALSE;

    WHEN OTHERS THEN

      Lv_Error := 'Ocurri� un error al obtener el cursor de solicitud: '
              ||'ID_GRUPO_PROMOCION: ' || Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION ||', '
              ||'ID_TIPO_PROMOCION: '  || Pr_ParametrosValidarSec.ID_TIPO_PROMOCION  ||', '
              ||'ID_SERVICIO: '        || Pr_ParametrosValidarSec.ID_SERVICIO        ||' O '
              ||'ID_PUNTO: '           || Pr_ParametrosValidarSec.ID_PUNTO;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL',
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

      Lv_Error := 'Ocurri� un error al obtener el cursor de solicitud: '
                   ||'ID_GRUPO_PROMOCION: ' || Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION ||', '
                   ||'ID_TIPO_PROMOCION: '  || Pr_ParametrosValidarSec.ID_TIPO_PROMOCION  ||', '
                   ||'ID_SERVICIO: '        || Pr_ParametrosValidarSec.ID_SERVICIO        ||' O '
                   ||'ID_PUNTO: '           || Pr_ParametrosValidarSec.ID_PUNTO;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL',
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
                                              AND APC.ESTADO           = 'Activo'
                                              AND APD.EMPRESA_COD      = Pr_ParametrosValidarSec.EMPRESA_COD)
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
                                              AND APC.ESTADO           = 'Activo'
                                              AND APD.EMPRESA_COD      = Pr_ParametrosValidarSec.EMPRESA_COD)
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

      Lv_Error := 'Ocurri� un error al obtener el cursor de solicitud: '
                   ||'ID_GRUPO_PROMOCION: ' || Pr_ParametrosValidarSec.ID_GRUPO_PROMOCION ||', '
                   ||'ID_TIPO_PROMOCION: '  || Pr_ParametrosValidarSec.ID_TIPO_PROMOCION  ||', '
                   ||'ID_SERVICIO: '        || Pr_ParametrosValidarSec.ID_SERVICIO        ||' O '
                   ||'ID_PUNTO: '           || Pr_ParametrosValidarSec.ID_PUNTO;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_UTIL',
                                           'F_EXISTE_SOLICITUD_OLT',
                                            Lv_Error||' - '||SQLCODE||' -ERROR- '||SQLERRM,
                                           'telcos_mapeo_promo',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    RETURN FALSE;

  END F_EXISTE_SOLICITUD_OLT;
  --

  PROCEDURE P_OBTIENE_PROMO_TENTATIVAS(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_TipoProceso           IN VARCHAR2,
                                       Pd_FechaEvalua           IN DATE DEFAULT NULL,
                                       Prf_GruposPromociones    OUT SYS_REFCURSOR)
  IS    
    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';
    Lv_EstadoInactivo    VARCHAR2(15) := 'Inactivo';
    Lv_EstadoEliminado   VARCHAR2(15) := 'Eliminado';
    Lv_TipoCliente       VARCHAR2(20) := 'PROM_TIPO_CLIENTE';
    Lv_NombreParametro   VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion        VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado      VARCHAR2(2000);  
    Lv_QuerySelect       VARCHAR2(2000);
    Lv_QueryFrom         VARCHAR2(2000); 
    Lv_QueryWhere        VARCHAR2(2000); 
    Lv_QueryOrderBy      VARCHAR2(2000); 
    Lv_Consulta          VARCHAR2(4000);
    Lv_FeProcesaVigencia VARCHAR2(15);
    Le_Exception         EXCEPTION;
  BEGIN
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;

   IF Pd_FechaEvalua IS NULL THEN
     Lv_FeProcesaVigencia:= TO_CHAR(SYSDATE,'DD/MM/YYYY');
   ELSE
     Lv_FeProcesaVigencia:= TO_CHAR(Pd_FechaEvalua,'DD/MM/YYYY');
   END IF;
   --Costo: 10
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
                       AND GPROMO.ESTADO                   IN ( '''||Lv_EstadoActivo||''' , '''||Lv_EstadoInactivo||''' )
                       AND TPROMO.ESTADO                   IN ( '''||Lv_EstadoActivo||''' , '''||Lv_EstadoInactivo||''' )
                       AND GPROMO.EMPRESA_COD              = '''||Pv_CodEmpresa||'''
                       AND (TO_DATE('''||Lv_FeProcesaVigencia||''',''DD/MM/YYYY'')
                       BETWEEN TO_DATE(TO_CHAR(GPROMO.FE_INICIO_VIGENCIA,''DD/MM/YYYY''),''DD/MM/YYYY'')
                       AND TO_DATE(TO_CHAR(GPROMO.FE_FIN_VIGENCIA,''DD/MM/YYYY''),''DD/MM/YYYY'')) ';

   Lv_QueryOrderBy := ' ORDER BY GPROMO.FE_CREACION ASC, 
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

   IF Lv_Consulta IS NULL THEN
      RAISE Le_Exception;
   END IF;

   OPEN Prf_GruposPromociones FOR Lv_Consulta;

  EXCEPTION
  WHEN Le_Exception THEN    
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
    Lv_MsjResultado := 'Ocurri� un error al obtener los Grupos de Promociones  del par�metro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_OBTIENE_PROMO_TENTATIVAS', 
                                         Lv_Consulta, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
    Prf_GruposPromociones := NULL;    
  WHEN OTHERS THEN
    IF Prf_GruposPromociones%ISOPEN THEN
      CLOSE Prf_GruposPromociones;
    END IF;
     Lv_MsjResultado := 'Ocurri� un error al obtener los Grupos de Promociones  del par�metro :' || Lv_NombreParametro || 
                        ' para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || ' Empresa: '|| Pv_CodEmpresa; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_OBTIENE_PROMO_TENTATIVAS', 
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
                                      Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                      Pv_Codigo               IN VARCHAR2 DEFAULT NULL,
                                      Pv_TipoProceso          IN VARCHAR2 DEFAULT NULL,
                                      Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE DEFAULT NULL,
                                      Pv_CaractCodProm        IN VARCHAR2 DEFAULT NULL,
                                      Pn_IdServicio           IN NUMBER DEFAULT NULL,
                                      Pa_ServiciosProcesar    OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar)
  IS 
    Lv_Estados_Act_Serv   VARCHAR2(50) := 'PROM_ESTADOS_SERVICIO';
    Lv_Estados_Baja_Serv  VARCHAR2(50) := 'PROM_ESTADOS_BAJA_SERV';
    Lv_CaractPromoNuevos  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PROM_COD_NUEVO';
    Lv_EstadoActivo       VARCHAR2(15) := 'Activo';
    Lv_DescripcionRol     VARCHAR2(50) := 'PROM_ROLES_CLIENTES';
    Lv_EsVenta            VARCHAR2(1)  := 'S';
    Ln_Frecuencia         NUMBER       := 1;  
    Ln_Numero             NUMBER       := 0;
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado       VARCHAR2(2000); 
    Lv_Consulta           VARCHAR2(6000);
    Lv_CadenaQuery        VARCHAR2(2000);
    Lv_CadenaFrom         VARCHAR2(1000);
    Lv_CadenaWhere        VARCHAR2(5000);
    Lv_CadenaOrdena       VARCHAR2(1000); 
    Lrf_ServiciosProcesar SYS_REFCURSOR; 
    Lr_Servicios          DB_COMERCIAL.CMKG_PROMOCIONES.Lr_ServiciosProcesar; 
    La_ServiciosProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;  
    Ln_Indice             NUMBER        := 1; 
    Ln_Indx               NUMBER;
    Lv_EstadoInactivo     VARCHAR2(15) := 'Inactivo';
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
                                         AND APC.ESTADO           = '''||Lv_EstadoActivo||'''
                                         AND APD.EMPRESA_COD      = '''||Pv_CodEmpresa||''')
      AND ISE.PRECIO_VENTA           > '||Ln_Numero||'
      AND ISE.FRECUENCIA_PRODUCTO    = '|| Ln_Frecuencia ||'      
      AND IP.ID_PUNTO                = '||Pn_IdPunto||'   
      AND IP.ID_PUNTO                = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL        = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA             = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL         = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL                  = IER.ROL_ID 
      AND UPPER(ISE.ESTADO)          NOT IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                             FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                               DB_GENERAL.ADMI_PARAMETRO_DET APD
                                             WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                             AND APD.ESTADO           = '''||Lv_EstadoActivo||'''
                                             AND APC.NOMBRE_PARAMETRO = '''||Lv_Estados_Act_Serv||'''
                                             AND APC.ESTADO           = '''||Lv_EstadoActivo||'''
                                             AND APD.EMPRESA_COD      = '''||Pv_CodEmpresa||'''
                                             UNION 
                                             SELECT UPPER(APD.VALOR1) AS VALOR1
                                             FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                               DB_GENERAL.ADMI_PARAMETRO_DET APD
                                             WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                             AND APD.ESTADO           = '''||Lv_EstadoActivo||'''
                                             AND APC.NOMBRE_PARAMETRO = '''||Lv_Estados_Baja_Serv||'''
                                             AND APC.ESTADO           = '''||Lv_EstadoActivo||'''
                                             AND APD.EMPRESA_COD      = '''||Pv_CodEmpresa||''') ';

    IF UPPER(TRIM(Pv_EsCodigo)) = 'S' AND TRIM(Pv_EsCodigo) IS NOT NULL AND TRIM(Pv_Codigo) IS NOT NULL THEN
      Lv_CadenaWhere := Lv_CadenaWhere || ' AND EXISTS( SELECT ''X'' FROM     
          DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
          DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE ISC.SERVICIO_ID               = ISE.ID_SERVICIO
        AND ISC.ESTADO                      = '''||Lv_EstadoActivo||'''
        AND ISC.VALOR                       IS NOT NULL
        AND DBAC.ID_CARACTERISTICA          = ISC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractPromoNuevos||'''
        AND ISC.VALOR                       = '''||Pv_Codigo||''' )';
    END IF;

    --Se valida existencia de servicios en la tabla de tentativa, y se eval�a servicios con c�digo promocional.
    IF UPPER(Pv_TipoProceso) = 'PROM_EVAL_TENTATIVA' AND Pv_TipoProceso IS NOT NULL THEN
      Lv_CadenaWhere := Lv_CadenaWhere 
        ||' AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TENTATIVA(ISE.ID_SERVICIO,'''||Pv_CodEmpresa||''','''||Pv_CodigoGrupoPromocion||''') = ''N'' ';

        IF Pv_CodigoGrupoPromocion = 'PROM_INS' AND Pv_CodigoGrupoPromocion IS NOT NULL THEN 
          Lv_CadenaWhere := Lv_CadenaWhere 
            ||' AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SERVICIO_PLAN_INTD(ISE.ID_SERVICIO,'''||Pv_CodEmpresa||''') = ''S'' ';
        END IF;

        IF Pn_IdServicio IS NOT NULL THEN 
            Lv_CadenaWhere := Lv_CadenaWhere||' AND ISE.ID_SERVICIO = '||Pn_IdServicio||' ';
        END IF;

      IF UPPER(TRIM(Pv_EsCodigo)) = 'S' AND Pv_CaractCodProm IS NOT NULL THEN 
        Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC, 
                                             DB_COMERCIAL.ADMI_CARACTERISTICA DBAC, 
                                             DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP, 
                                             DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP ' ; 

        Lv_CadenaWhere := Lv_CadenaWhere || ' AND ISC.SERVICIO_ID                  = ISE.ID_SERVICIO 
                                              AND ISC.ESTADO                       = '''||Lv_EstadoActivo||''' 
                                              AND DBAC.ID_CARACTERISTICA           = ISC.CARACTERISTICA_ID 
                                              AND DBAC.DESCRIPCION_CARACTERISTICA  = '''||Pv_CaractCodProm||''' 
                                              AND ATP.ID_TIPO_PROMOCION            = COALESCE(TO_NUMBER(REGEXP_SUBSTR(TRIM(ISC.VALOR),''^\d+'')),0) 
                                              AND ATP.ESTADO                       IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''') 
                                              AND AGP.ID_GRUPO_PROMOCION           = ATP.GRUPO_PROMOCION_ID 
                                              AND AGP.EMPRESA_COD                  = '''||Pv_CodEmpresa||''' 
                                              AND AGP.ESTADO                       IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''') 
                                              AND ATPR.ESTADO                      IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''') 
                                              AND ATPR.CARACTERISTICA_ID           IN (SELECT CARAC.ID_CARACTERISTICA 
                                                                                       FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARAC 
                                                                                       WHERE CARAC.DESCRIPCION_CARACTERISTICA = ''PROM_CODIGO'') '; 
        IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN 
          Lv_CadenaFrom  := Lv_CadenaFrom ||', DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR ';
          Lv_CadenaWhere := Lv_CadenaWhere||' AND ATPR.TIPO_PROMOCION_ID = ATP.ID_TIPO_PROMOCION ';
        ELSE  
          Lv_CadenaFrom  := Lv_CadenaFrom ||', DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA ATPR ';
          Lv_CadenaWhere := Lv_CadenaWhere||' AND ATPR.GRUPO_PROMOCION_ID = AGP.ID_GRUPO_PROMOCION ';   
        END IF;  

      END IF;
    END IF;

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
   CURSOR C_EstadosContratos(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT APD.VALOR1 AS VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
      AND APD.ESTADO           = 'Activo'
      AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_CONTRATOS'
      AND APC.ESTADO           = 'Activo'
      AND APD.EMPRESA_COD      = Cv_CodEmpresa
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

    Lv_Estado               DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE;
    Ln_ExisteEstadoContrato NUMBER;
    Lv_MsjResultado         VARCHAR2(2000);
    Lv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  BEGIN

    IF C_GetEmpresa%ISOPEN THEN
    --
      CLOSE C_GetEmpresa;
    --
    END IF;

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

    OPEN C_GetEmpresa(Fn_IdPunto);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;

    FOR Lc_EstadosContratos IN C_EstadosContratos(Lv_CodEmpresa)
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
    Lv_MsjResultado := 'Ocurri� un error al obtener el estado del contrato para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_ESTADO_CONTRATO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Estado        := null;
    RETURN Lv_Estado;
  END F_ESTADO_CONTRATO;

    --
  FUNCTION F_ESTADO_SERVICOS(Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Fv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Fv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Fv_EstadoActivo    VARCHAR2,
                             Fv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Fv_TipoPto         IN VARCHAR2)
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
      AND APD.VALOR1           = Cv_TipoPromo
      AND APD.EMPRESA_COD      = Cv_EmpresaCod
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

    --Costo 6
    CURSOR C_GetFeCreaAdendum(Cn_IdPunto         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Cv_TipoAdendum     DB_COMERCIAL.INFO_ADENDUM.TIPO%TYPE,
                              Cv_EstadoActivo    DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                              Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT TRUNC(MIN(DBIA.FE_CREACION)) AS FE_EVALUA_VIGENCIA
      FROM DB_COMERCIAL.INFO_ADENDUM DBIA
      WHERE DBIA.PUNTO_ID = Cn_IdPunto
      AND DBIA.TIPO       = Cv_TipoAdendum
      AND DBIA.ESTADO     IN (SELECT APD.VALOR1 
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                DB_GENERAL.ADMI_PARAMETRO_DET APD
                              WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                              AND APD.ESTADO             = Cv_EstadoActivo
                              AND APD.EMPRESA_COD        = Cv_EmpresaCod
                              AND APC.NOMBRE_PARAMETRO   = 'PROM_ESTADOS_ADENDUM'
                              AND APC.ESTADO             = Cv_EstadoActivo);

    --Costo 10
    CURSOR C_GetServicioInternet(Cn_IdPunto         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_TipoPromo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                 Cv_EstadoActivo    VARCHAR2,
                                 Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT SERV.ID_SERVICIO,
        SERV.ESTADO
      FROM DB_COMERCIAL.INFO_SERVICIO SERV, 
        DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE SERV.PUNTO_ID   =  Cn_IdPunto
      AND SERV.PLAN_ID      =  IPC.ID_PLAN
      AND IPC.ID_PLAN       =  IPD.PLAN_ID
      AND IPD.PRODUCTO_ID   =  AP.ID_PRODUCTO
      AND AP.NOMBRE_TECNICO = 'INTERNET'
      AND SERV.ESTADO       IN (SELECT APD.VALOR2 AS VALOR2
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                  DB_GENERAL.ADMI_PARAMETRO_DET APD
                                WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                AND APD.ESTADO           = Cv_EstadoActivo
                                AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                                AND APC.ESTADO           = Cv_EstadoActivo
                                AND APD.VALOR1           = Cv_TipoPromo
                                AND APD.EMPRESA_COD      = Cv_EmpresaCod);

    --Costo 3
    CURSOR C_GetOrigenWeb(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT COUNT (DBIP.ID_PUNTO) AS VALOR
      FROM DB_COMERCIAL.INFO_PUNTO DBIP
      WHERE DBIP.ID_PUNTO        = Cn_IdPunto
      AND UPPER(DBIP.ORIGEN_WEB) = 'S';

    Lv_EstadoActivo           DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE := 'Activo';
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_UserMapeo              VARCHAR2(20):='telcos_map_prom';
    Lv_IpCreacion             VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lr_InfoServicioHistorial  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lc_GetServicioInternet    C_GetServicioInternet%ROWTYPE;
    Ln_OrigenWeb              NUMBER := 0;
    Ld_FeCreaServicio         DATE;

  BEGIN

    IF C_GetParametro%ISOPEN THEN
    --
      CLOSE C_GetParametro;
    --
    END IF;

    IF C_GetFeCreaAdendum%ISOPEN THEN
    --
      CLOSE C_GetFeCreaAdendum;
    --
    END IF;

    IF C_GetServicioInternet%ISOPEN THEN
    --
      CLOSE C_GetServicioInternet;
    --
    END IF;

    IF C_GetOrigenWeb%ISOPEN THEN
    --
      CLOSE C_GetOrigenWeb;
    --
    END IF;

    OPEN  C_GetOrigenWeb(Fn_IdPunto);
    FETCH C_GetOrigenWeb INTO Ln_OrigenWeb;
    CLOSE C_GetOrigenWeb;

    IF Fv_TipoPto = 'PTO_ADICIONAL' AND Ln_OrigenWeb = 0 THEN
    --
      OPEN  C_GetFeCreaAdendum(Fn_IdPunto,'AP',Lv_EstadoActivo,Fv_EmpresaCod);
      FETCH C_GetFeCreaAdendum INTO Ld_FeCreaServicio;
      CLOSE C_GetFeCreaAdendum;

      IF Ld_FeCreaServicio IS NULL THEN

        OPEN  C_GetServicioInternet(Fn_IdPunto,Fv_NombreParametro,Fv_TipoPromo,Fv_EstadoActivo,Fv_EmpresaCod);
        FETCH C_GetServicioInternet INTO Lc_GetServicioInternet;
        CLOSE C_GetServicioInternet;      

        Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
        Lr_InfoServicioHistorial.SERVICIO_ID            := Lc_GetServicioInternet.ID_SERVICIO;
        Lr_InfoServicioHistorial.USR_CREACION           := Lv_UserMapeo;
        Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
        Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
        Lr_InfoServicioHistorial.ESTADO                 := Lc_GetServicioInternet.ESTADO;
        Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
        Lr_InfoServicioHistorial.OBSERVACION            := 'No se encontr� informaci�n de Adendum para obtener la fecha'
                                                           || ' para evaluar las promociones por Instalaci�n, caso contrario'
                                                           || ' se obtiene la fecha de creaci�n del servicio.';
        Lr_InfoServicioHistorial.ACCION                 := NULL;
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);

        FOR Lc_EstadosServicios IN C_GetParametro(Cv_NombreParametro => Fv_NombreParametro,
                                                  Cv_TipoPromo       => Fv_TipoPromo,
                                                  Cv_EstadoActivo    => Fv_EstadoActivo,
                                                  Cv_EmpresaCod      => Fv_EmpresaCod)
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
      ELSE
        RETURN Ld_FeCreaServicio;
      END IF;
    --  
    ELSE
      FOR Lc_EstadosServicios IN C_GetParametro(Cv_NombreParametro => Fv_NombreParametro,
                                                Cv_TipoPromo       => Fv_TipoPromo,
                                                Cv_EstadoActivo    => Fv_EstadoActivo,
                                                Cv_EmpresaCod      => Fv_EmpresaCod)
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
    END IF;
    RETURN Ld_FeCreaServicio;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurri� un error al obtener el estado y frecha del servicio para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_ESTADO_SERVICOS', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ld_FeCreaServicio        := null;
    RETURN Ld_FeCreaServicio;
  END F_ESTADO_SERVICOS;



  PROCEDURE P_PROMO_TENTATIVA(Pn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Pn_IdServicio           IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Pv_CodigoGrupoPromocion IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Pn_FormaPagoId          IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                              Pn_TipoCuentaId         IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                              Pn_BancoTipoCuentaId    IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE,
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
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    La_TipoPromoPlanProdProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar;
    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_TiposPromocionesProcesar   DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar;
    La_GruposPromocionesProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar;
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
      Lv_MsjExceptionProceso := 'La promoci�n solo aplica para los tipos: (PROM_INS,PROM_MENS), punto_Id - '
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
      Lv_MsjExceptionProceso := 'No se encuentra definido c�digo de Empresa para el Proceso de Promociones ' 
                                 || Pv_CodigoGrupoPromocion || ' COD_EMPRESA: '||Pv_CodEmpresa ||', punto_Id - '
                                 || Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio;
      RAISE Le_ExceptionProceso;
    --
    END IF;

    Lb_OtorgoPromoCliente   := FALSE;
    La_ServiciosProcesar.DELETE();
    La_TiposPromocionesProcesar.DELETE();

    DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT(Pn_IdPunto              => Pn_IdPunto,
                                                         Pn_IdServicio           => Pn_IdServicio,
                                                         Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                         Pv_CodEmpresa           => Pv_CodEmpresa,
                                                         Pv_TipoProceso          => 'NUEVO',
                                                         Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                         Pa_TiposPromoPrioridad  => La_TiposPromocionesProcesar);

    IF La_TiposPromocionesProcesar.COUNT = 0 THEN
      Lv_MsjExceptionProceso := 'No se pudo obtener los Grupos de Promocionales para la evaluaci�n de reglas. ';
      RAISE Le_ExceptionProceso;
    END IF;
    --  
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
            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto           => Pn_IdPunto,
                                                                         Pv_CodEmpresa        => Pv_CodEmpresa,
                                                                         Pa_ServiciosProcesar => La_ServiciosProcesar);

            IF La_ServiciosProcesar.COUNT = 0 THEN
              Lv_MsjExceptionTipoPromo:= 'No se encontraron servicios para el ID_PUNTO: '||Pn_IdPunto;
              RAISE Le_ExceptionTipoPromo; 
            END IF;
            DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_ServiciosProcesar, 
                                                                     Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                     La_TipoPromoPlanProdProcesar, 
                                                                     Lb_CumplePlaProd,
                                                                     La_ServiciosCumplePromo);
          --
          END IF;

          Lr_ParametrosValidarSec                    := NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
          Lr_ParametrosValidarSec.ID_SERVICIO        := Pn_IdServicio;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    := 'NUEVO';
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := Pv_CodigoGrupoPromocion;
          Lr_ParametrosValidarSec.EMPRESA_COD        := Lv_CodEmpresa;

          Lb_CumpleSect     := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec);

          Lb_CumpleFormPag  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO_CFP(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                          Pn_IdPunto,
                                                                                          Pn_FormaPagoId,
                                                                                          Pn_TipoCuentaId,
                                                                                          Pn_BancoTipoCuentaId); 

          IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN
            Lb_CumpleUltMilla := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                          Pn_IdServicio);

            Lb_CumpleTipoNeg  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion => Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                          Fn_IdServicio     => Pn_IdServicio,
                                                                                          Fv_CodEmpresa     => Pv_CodEmpresa);
          END IF;


          IF Lb_CumpleSect AND Lb_CumpleFormPag AND ((Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Lb_CumplePlaProd) OR (
             Pv_CodigoGrupoPromocion = 'PROM_INS' AND Lb_CumpleUltMilla AND Lb_CumpleTipoNeg)) THEN
            Lb_OtorgoPromoCliente := TRUE;
            Ln_IdPromocion        := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
            Ln_IdTipoPromocion    := Lr_TiposPromociones.ID_TIPO_PROMOCION;
          END IF;

          La_TipoPromoPlanProdProcesar.DELETE();             

          --
        EXCEPTION
        WHEN Le_ExceptionTipoPromo THEN
          Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de evaluaci�n de Promociones para el Grupo de Promocional: '
                             || Pv_CodigoGrupoPromocion|| ' - ' ||Lv_MsjExceptionTipoPromo ||', punto_Id - '
                             || Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio; 

          Lv_Existe       := '';
          OPEN C_GetErrorRepetido(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
          --
          FETCH C_GetErrorRepetido INTO Lv_Existe;
          --
            IF Lv_Existe <> 'EXISTE' THEN

              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'CMKG_PROMOCIONES_UTIL.P_PROMO_TENTATIVA', 
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
      --
    IF Lb_OtorgoPromoCliente THEN
    --
      Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Ln_IdTipoPromocion);

      IF Lr_TipoPromoRegla.PROM_DESCUENTO IS NOT NULL THEN
      --
        Lv_Descuento := Lr_TipoPromoRegla.PROM_DESCUENTO;
      --
      ELSE
      --
        OPEN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO);
        FETCH C_PeriodoDesc INTO Lc_PeriodoDesc;
        CLOSE C_PeriodoDesc;
        Lv_Descuento := Lc_PeriodoDesc.DESCUENTO;
      --
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
      Lr_InfoServicioHistorial.OBSERVACION           := 'El servicio cumpli� con las reglas de los grupos promocionales, para aplicar la promoci�n '
                                                         || Lr_TipoPromoRegla.NOMBRE_GRUPO;
      Lr_InfoServicioHistorial.ACCION                := NULL;
      --

      OPEN  C_GetServicioHistorial(Lr_InfoServicioHistorial.USR_CREACION,
                                   Pn_IdServicio);
      FETCH C_GetServicioHistorial INTO Ln_Existe;
      CLOSE C_GetServicioHistorial;

      IF Ln_Existe = 0 THEN 
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,
                                                                   Lv_MsjResultado);

        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        --
          Lv_MsjExceptionProceso := Lv_MsjResultado;
          RAISE Le_ExceptionProceso;
        --
        END IF;
      END IF;
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
        Lv_Observacion := 'Desct. Fact. Mensual: Promoci�n Indefinida: ' || NVL(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA,'NO')
                          || ', Tipo Periodo: ' || UPPER(NVL(Lr_TipoPromoRegla.PROM_TIPO_PERIODO,'Unico')) || ',' || Lv_ObservacionDesc;
      END IF;

      Pn_Descuento   := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lv_Descuento,'^\d+')),0);
      Pn_CantPeriodo := TO_NUMBER(Lc_Datos.PERIODOS);
      Pv_Observacion := Lv_Observacion;
    --
    END IF;

    IF Lv_Observacion IS NULL THEN
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lv_Observacion := 'No aplica Promoci�n por descuento Mensual.';
      ELSE
        Lv_Observacion := 'No aplica Promoci�n por descuento de Instalaci�n.';
      END IF;
      Pv_Observacion := Lv_Observacion;
    END IF;
    COMMIT;
  EXCEPTION
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de evaluaci�n de Promociones' || ' - ' ||Lv_MsjExceptionProceso
                        ||', punto_Id - '|| Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_PROMO_TENTATIVA', 
                                         Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

    IF Lv_Observacion IS NULL THEN
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lv_Observacion := 'No aplica Promoci�n por descuento Mensual.';
      ELSE
        Lv_Observacion := 'No aplica Promoci�n por descuento de Instalaci�n.';
      END IF;
      Pv_Observacion := Lv_Observacion;
    END IF;
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de evaluaci�n de Promociones para el Grupo de Promocional: '||
                        Pv_CodigoGrupoPromocion||', punto_Id - '|| Pn_IdPunto || ' servicio_Id - ' || Pn_IdServicio
                        || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_PROMO_TENTATIVA', 
                                         Lv_MsjResultado, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

    IF Lv_Observacion IS NULL THEN
      IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        Lv_Observacion := 'No aplica Promoci�n por descuento Mensual.';
      ELSE
        Lv_Observacion := 'No aplica Promoci�n por descuento de Instalaci�n.';
      END IF;
      Pv_Observacion := Lv_Observacion;
    END IF;
  END P_PROMO_TENTATIVA;

  FUNCTION F_VALIDA_FORMA_PAGO_CFP(Fn_IntIdPromocion     IN  DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                   Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                   Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                   Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
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

    --Costo: 2
    CURSOR C_ExisteBancoTipoCta(Cv_Valores VARCHAR2,
                                Cn_Valor   NUMBER)
    IS
      SELECT COUNT('X') AS VALOR
      FROM (SELECT REGEXP_SUBSTR (Cv_Valores,'[^,]+',1, LEVEL) VALOR FROM DUAL
            CONNECT BY REGEXP_SUBSTR (Cv_Valores,'[^,]+',1, LEVEL) IS NOT NULL) T
      WHERE Cn_Valor IN (COALESCE(TO_NUMBER(REGEXP_SUBSTR(T.VALOR,'^\d+')),0));

    Lc_Tipo_Pomocion      C_TipoPomocion%ROWTYPE;
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


    IF C_ExisteBancoTipoCta%ISOPEN THEN
    --
      CLOSE C_ExisteBancoTipoCta;
    --
    END IF;

    Lv_Estado := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_ESTADO_CONTRATO (Fn_IdPunto);

    OPEN C_TipoPomocion(Fn_intIdPromocion);
    --
    FETCH C_TipoPomocion INTO Lc_Tipo_Pomocion;
    --
      IF Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION = 'PROM_INS' OR Lc_Tipo_Pomocion.CODIGO_TIPO_PROMOCION = 'PROM_BW' THEN
        --
          FOR Lc_FormaPago_Ins_ABan IN C_FormaPagoInsABan (Cn_IntIdPromocion => Fn_intIdPromocion)
          LOOP
          --
            IF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Ins_ABan.FORMA_PAGO,'^\d+')),0) = Fn_FormaPagoId
               AND Fn_FormaPagoId = 3 THEN
              --
                OPEN C_ExisteBancoTipoCta(Lc_FormaPago_Ins_ABan.EMISOR,
                                          Fn_BancoTipoCuentaId);
                --
                FETCH C_ExisteBancoTipoCta INTO Ln_ExisteBancoTipoCta ;
                --
                  IF Ln_ExisteBancoTipoCta > 0 THEN
                    Lb_Aplica := TRUE;
                    RETURN Lb_Aplica;
                  END IF;
                --
                CLOSE C_ExisteBancoTipoCta;
            ELSIF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Ins_ABan.FORMA_PAGO,'^\d+')),0) = Fn_FormaPagoId THEN
              Lb_Aplica := TRUE;
              RETURN Lb_Aplica;
            END IF;
          --
          END LOOP;
      --
      ELSE
      --

        --
          FOR Lc_FormaPago_Mens IN C_FormaPagoMens (Cn_IntIdPromocion => Fn_intIdPromocion)
          LOOP
          --
            IF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Mens.FORMA_PAGO,'^\d+')),0) = Fn_FormaPagoId 
               AND Fn_FormaPagoId = 3 THEN
              --
                OPEN C_ExisteBancoTipoCta(Lc_FormaPago_Mens.EMISOR,
                                          Fn_BancoTipoCuentaId);
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
            ELSIF COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_FormaPago_Mens.FORMA_PAGO,'^\d+')),0) = Fn_FormaPagoId THEN
              Lb_Aplica := TRUE;
              RETURN Lb_Aplica;
            END IF;
          --
          END LOOP;

      END IF;
    --
    CLOSE C_TipoPomocion;
    RETURN Lb_Aplica;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurri� un error al validar la Regla de Forma de Pago del GRUPO_PROMOCION: '
                        || Fn_IntIdPromocion || ' para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO_CFP', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_FORMA_PAGO_CFP;
  --
  --
  --
  PROCEDURE P_VALIDACIONES_PREVIAS_CODIGO(Pv_Trama                 IN  VARCHAR2,
                                          Pn_IdServicio            IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                                          Pn_IdPunto               IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                          Pn_IdPlan                IN  DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE DEFAULT NULL,
                                          Pn_IdProducto            IN  DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE DEFAULT NULL,
                                          Pn_IdUltimaMilla         IN  DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE DEFAULT NULL,
                                          Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                          Pv_Mensaje               OUT VARCHAR2,
                                          Pv_Detalle               OUT VARCHAR2,
                                          Pv_ServiciosMix          OUT VARCHAR2)
  IS    

    --Costo: 13
    CURSOR C_CodigoPromocionInsBw(Cv_TipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Cv_Codigo        VARCHAR2)
    IS
      SELECT COUNT(TIPO_PROMO_REGLA.ID_TIPO_PROMOCION) AS EXISTE,
        TIPO_PROMO_REGLA.ID_TIPO_PROMOCION
      FROM (SELECT *
      FROM (
            SELECT TPROMO.ID_TIPO_PROMOCION,
              REGPRO.DESCRIPCION_CARACTERISTICA,
              TPROMORE.VALOR
            FROM
              DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO,
              DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA TPROMORE,
              DB_COMERCIAL.ADMI_CARACTERISTICA  REGPRO
            WHERE  TPROMO.ID_TIPO_PROMOCION      IN (SELECT T.ID_TIPO_PROMOCION
                                                     FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION G,
                                                       DB_COMERCIAL.ADMI_TIPO_PROMOCION T
                                                     WHERE G.ID_GRUPO_PROMOCION = T.GRUPO_PROMOCION_ID
                                                     AND T.CODIGO_TIPO_PROMOCION IN (Cv_TipoPromocion))
            AND TPROMO.ID_TIPO_PROMOCION         = TPROMORE.TIPO_PROMOCION_ID
            AND TPROMORE.CARACTERISTICA_ID       = REGPRO.ID_CARACTERISTICA
            AND TPROMORE.ESTADO                  = 'Activo'
            AND REGPRO.DESCRIPCION_CARACTERISTICA IN (
            'PROM_CODIGO')
            ) PIVOT ( MAX ( VALOR )
                  FOR DESCRIPCION_CARACTERISTICA
                  IN ( 
                       'PROM_CODIGO' PROM_CODIGO)
             )) TIPO_PROMO_REGLA 
      WHERE  UPPER(TIPO_PROMO_REGLA.PROM_CODIGO) = UPPER(Cv_Codigo)
      GROUP BY TIPO_PROMO_REGLA.ID_TIPO_PROMOCION;

    --Costo: 17
    CURSOR C_CodigoPromocionMens(Cv_TipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                 Cv_Codigo        VARCHAR2)
    IS
      SELECT COUNT(TIPO_PROMO_REGLA.ID_TIPO_PROMOCION) AS EXISTE,
        TIPO_PROMO_REGLA.ID_TIPO_PROMOCION
      FROM (SELECT *
      FROM (
            SELECT DBATP.ID_TIPO_PROMOCION,
              REGPRO.DESCRIPCION_CARACTERISTICA,
              TPROMORE.VALOR
            FROM
              DB_COMERCIAL.ADMI_GRUPO_PROMOCION TPROMO,
              DB_COMERCIAL.ADMI_TIPO_PROMOCION DBATP,
              DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA TPROMORE,
              DB_COMERCIAL.ADMI_CARACTERISTICA  REGPRO
            WHERE DBATP.CODIGO_TIPO_PROMOCION    IN (Cv_TipoPromocion)
            AND DBATP.ESTADO                     != 'Eliminado'
            AND TPROMO.ID_GRUPO_PROMOCION        = DBATP.GRUPO_PROMOCION_ID
            AND TPROMO.ID_GRUPO_PROMOCION        = TPROMORE.GRUPO_PROMOCION_ID
            AND TPROMORE.CARACTERISTICA_ID       = REGPRO.ID_CARACTERISTICA
            AND TPROMORE.ESTADO                  = 'Activo'
            AND REGPRO.DESCRIPCION_CARACTERISTICA IN (
            'PROM_CODIGO')
            ) PIVOT ( MAX ( VALOR )
                  FOR DESCRIPCION_CARACTERISTICA
                  IN ( 
                       'PROM_CODIGO' PROM_CODIGO)
             )) TIPO_PROMO_REGLA 
      WHERE UPPER(TIPO_PROMO_REGLA.PROM_CODIGO) = UPPER(Cv_Codigo)
      GROUP BY TIPO_PROMO_REGLA.ID_TIPO_PROMOCION;

    --Costo: 6
    CURSOR C_TipoProcesoInsBw(Cv_TipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Cv_TipoProceso   VARCHAR2,
                              Cn_IdPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT COUNT(TIPO_PROMO_REGLA.ID_TIPO_PROMOCION) AS EXISTE,
        TIPO_PROMO_REGLA.ID_TIPO_PROMOCION
      FROM (SELECT *
      FROM (
            SELECT TPROMO.ID_TIPO_PROMOCION,
              REGPRO.DESCRIPCION_CARACTERISTICA,
              TPROMORE.VALOR
            FROM
              DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO,
              DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA TPROMORE,
              DB_COMERCIAL.ADMI_CARACTERISTICA  REGPRO
            WHERE  TPROMO.ID_TIPO_PROMOCION      IN (SELECT T.ID_TIPO_PROMOCION
                                                     FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION G,
                                                       DB_COMERCIAL.ADMI_TIPO_PROMOCION T
                                                     WHERE G.ID_GRUPO_PROMOCION = T.GRUPO_PROMOCION_ID
                                                     AND T.CODIGO_TIPO_PROMOCION IN (Cv_TipoPromocion))
            AND TPROMO.GRUPO_PROMOCION_ID        = Cn_IdPromocion
            AND TPROMO.ID_TIPO_PROMOCION         = TPROMORE.TIPO_PROMOCION_ID
            AND TPROMORE.CARACTERISTICA_ID       = REGPRO.ID_CARACTERISTICA
            AND TPROMORE.ESTADO                  != 'Eliminado'
            AND REGPRO.DESCRIPCION_CARACTERISTICA IN (
            'PROM_TIPO_CLIENTE')
            ) PIVOT ( MAX ( VALOR )
                  FOR DESCRIPCION_CARACTERISTICA
                  IN ( 
                       'PROM_TIPO_CLIENTE' PROM_TIPO_CLIENTE)
             )) TIPO_PROMO_REGLA 
      WHERE  REGEXP_LIKE(UPPER(TIPO_PROMO_REGLA.PROM_TIPO_CLIENTE), Cv_TipoProceso)
      GROUP BY TIPO_PROMO_REGLA.ID_TIPO_PROMOCION;

    --Costo: 6
    CURSOR C_TipoProcesoMens(Cv_TipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                             Cv_TipoProceso   VARCHAR2,
                             Cn_IdPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT COUNT(TIPO_PROMO_REGLA.ID_TIPO_PROMOCION) AS EXISTE,
        TIPO_PROMO_REGLA.ID_TIPO_PROMOCION
      FROM (SELECT *
      FROM (
            SELECT DBATP.ID_TIPO_PROMOCION,
              REGPRO.DESCRIPCION_CARACTERISTICA,
              TPROMORE.VALOR
            FROM
              DB_COMERCIAL.ADMI_GRUPO_PROMOCION TPROMO,
              DB_COMERCIAL.ADMI_TIPO_PROMOCION DBATP,
              DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA TPROMORE,
              DB_COMERCIAL.ADMI_CARACTERISTICA  REGPRO
            WHERE DBATP.CODIGO_TIPO_PROMOCION    IN (Cv_TipoPromocion)
            AND TPROMO.ID_GRUPO_PROMOCION        = Cn_IdPromocion
            AND DBATP.ESTADO                     != 'Eliminado'
            AND TPROMO.ID_GRUPO_PROMOCION        = DBATP.GRUPO_PROMOCION_ID
            AND TPROMO.ID_GRUPO_PROMOCION        = TPROMORE.GRUPO_PROMOCION_ID
            AND TPROMORE.CARACTERISTICA_ID       = REGPRO.ID_CARACTERISTICA
            AND TPROMORE.ESTADO                  != 'Eliminado'
            AND REGPRO.DESCRIPCION_CARACTERISTICA IN (
            'PROM_TIPO_CLIENTE')
            ) PIVOT ( MAX ( VALOR )
                  FOR DESCRIPCION_CARACTERISTICA
                  IN ( 
                       'PROM_TIPO_CLIENTE' PROM_TIPO_CLIENTE)
             )) TIPO_PROMO_REGLA 
      WHERE REGEXP_LIKE(UPPER(TIPO_PROMO_REGLA.PROM_TIPO_CLIENTE), Cv_TipoProceso)
      GROUP BY TIPO_PROMO_REGLA.ID_TIPO_PROMOCION;

    --Costo: 2
    CURSOR C_VigenciaPromo(Cn_IdTipoPromo DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
    IS
      SELECT COUNT(DBATP.ID_TIPO_PROMOCION) AS EXISTE
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION DBAGP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION DBATP
      WHERE DBATP.ID_TIPO_PROMOCION = Cn_IdTipoPromo
      AND DBAGP.ID_GRUPO_PROMOCION  = DBATP.GRUPO_PROMOCION_ID
      AND TO_CHAR(SYSDATE,'RRRR/MM/DD') BETWEEN TO_CHAR(DBAGP.FE_INICIO_VIGENCIA ,'RRRR/MM/DD')
      AND TO_CHAR(DBAGP.FE_FIN_VIGENCIA,'RRRR/MM/DD');

    --Costo: 2
    CURSOR C_PromoActiva(Cn_IdTipoPromo DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
    IS
      SELECT DBAGP.ESTADO, 
        DBAGP.ID_GRUPO_PROMOCION,
        DBAGP.NOMBRE_GRUPO
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION DBAGP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION DBATP
      WHERE DBATP.ID_TIPO_PROMOCION = Cn_IdTipoPromo
      AND DBAGP.ID_GRUPO_PROMOCION  = DBATP.GRUPO_PROMOCION_ID;

    --Costo: 6
    CURSOR C_PtoServicio(Cv_IdPunto    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                         Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ISER.ID_SERVICIO 
      FROM DB_COMERCIAL.INFO_SERVICIO      ISER,
        DB_COMERCIAL.INFO_PLAN_DET         IPD,
        DB_COMERCIAL.ADMI_PRODUCTO         APR,
        DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
      WHERE APR.CODIGO_PRODUCTO = 'INTD'
      AND APR.ID_PRODUCTO       =  IPD.PRODUCTO_ID
      AND IPD.PLAN_ID           =  ISER.PLAN_ID
      AND IST.ELEMENTO_ID       IS NOT NULL
      AND IST.SERVICIO_ID       = ISER.ID_SERVICIO
      AND ISER.ESTADO           IN (SELECT APD.VALOR2
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID   =  APC.ID_PARAMETRO
                                    AND APD.ESTADO           =  'Activo'
                                    AND APD.EMPRESA_COD      =  Cv_CodEmpresa
                                    AND APC.NOMBRE_PARAMETRO =  'PROM_ESTADO_SERVICIO'
                                    AND APC.ESTADO           =  'Activo'
                                    AND APD.VALOR1           =  'PROM_INS')
      AND ISER.PUNTO_ID         = Cv_IdPunto
      ORDER BY ISER.FE_CREACION DESC;

    --Costo: 3
    CURSOR C_Punto(Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT DBIP.PUNTO_ID
      FROM DB_COMERCIAL.INFO_SERVICIO DBIP
      WHERE DBIP.ID_SERVICIO = Cv_IdServicio;

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

    --Costo: 6
    CURSOR C_GetNombrePlan(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                           Cn_IdPlan     DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    IS
      SELECT DISTINCT TABLA.NOMBRE_PLAN
      FROM 
      (SELECT IPC.NOMBRE_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE ISER.ID_SERVICIO = Cn_IdServicio
      AND IPC.ID_PLAN        = ISER.PLAN_ID
      UNION
      SELECT IPC.NOMBRE_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB IPC
      WHERE IPC.ID_PLAN = Cn_IdPlan) TABLA;

    --Costo: 3      
    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion     VARCHAR2,
                        Cv_EstadoActivo    VARCHAR2)
    IS      
      SELECT DET.VALOR1,
        DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Cv_EstadoActivo
      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      AND DET.DESCRIPCION        = Cv_Descripcion
      AND DET.ESTADO             = Cv_EstadoActivo;

    --Costo: 7
    CURSOR C_Servicio(Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT COUNT(ISER.ID_SERVICIO) AS VALOR 
      FROM DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PLAN_DET    IPD,
        DB_COMERCIAL.ADMI_PRODUCTO    APR
      WHERE APR.CODIGO_PRODUCTO = 'INTD'
      AND APR.ID_PRODUCTO       =  IPD.PRODUCTO_ID
      AND IPD.PLAN_ID           =  ISER.PLAN_ID
      AND ISER.ID_SERVICIO      = Cv_IdServicio;

    --Costo : 264
    CURSOR C_CuentaPuntos (Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
      SELECT COUNT(TABLA.TOTAL) AS TOTAL
      FROM (SELECT PTO_B.PERSONA_EMPRESA_ROL_ID, 
            COUNT(*) AS TOTAL
            FROM DB_COMERCIAL.INFO_PUNTO PTO_A,
              DB_COMERCIAL.INFO_PUNTO PTO_B
            WHERE PTO_A.ID_PUNTO              =  Cn_IdPunto
            AND PTO_A.PERSONA_EMPRESA_ROL_ID  =  PTO_B.PERSONA_EMPRESA_ROL_ID
            AND PTO_B.ID_PUNTO                <> PTO_A.ID_PUNTO
            AND EXISTS (SELECT 1
                        FROM DB_COMERCIAL.INFO_SERVICIO SERV,
                          DB_COMERCIAL.INFO_PLAN_CAB IPC,
                          DB_COMERCIAL.INFO_PLAN_DET IPD,
                          DB_COMERCIAL.ADMI_PRODUCTO AP
                        WHERE SERV.PUNTO_ID     = PTO_B.ID_PUNTO
                        AND SERV.PLAN_ID        = IPC.ID_PLAN
                        AND IPC.ID_PLAN         = IPD.PLAN_ID
                        AND IPD.PRODUCTO_ID     = AP.ID_PRODUCTO
                        AND AP.NOMBRE_TECNICO   = 'INTERNET'
                        AND SERV.ESTADO         IN ('Activo','In-Corte'))
            GROUP BY PTO_B.PERSONA_EMPRESA_ROL_ID) TABLA;

    --Costo : 6
    CURSOR C_ExistePlan (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                         Cn_IdPlan     DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE) 
    IS            
      SELECT COUNT (ID_SERVICIO) AS VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO 
      WHERE ID_SERVICIO = Cn_IdServicio
      AND PLAN_ID       = Cn_IdPlan;

    Lv_TipoProceso                VARCHAR2(1000);
    Lv_Proceso                    VARCHAR2(1000);
    Lv_CodEmpresa                 VARCHAR2(1000);
    Lv_CodigoGrupoPromocion       VARCHAR2(1000);
    Lv_TipoPromocion              VARCHAR2(1000);
    Lv_Codigo                     VARCHAR2(1000);
    Lv_Trama                      VARCHAR2(3200);
    Lv_Valor                      VARCHAR2(3200);
    Lv_Servicios                  VARCHAR2(3200);
    Lv_Observacion                VARCHAR2(3200);
    Lv_ObservacionDesc            VARCHAR2(3200);
    Lv_Promocion                  VARCHAR2(3200);
    Lv_ObservacionIsnt            VARCHAR2(3200);
    Lv_MensajeOltEdificio         VARCHAR2(3200);
    Lv_Aplica                     VARCHAR2(1);
    Lv_EsContrato                 VARCHAR2(1);
    Lv_TieneSolicitud             VARCHAR2(1);
    Lv_Descuento                  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE;
    Ln_IdPunto                    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_ExistePlan                 NUMBER;
    Ln_Posicion                   NUMBER;
    Ln_VigenciaPromo              NUMBER;
    Ln_ServiciosCumplePromo       NUMBER;
    Ln_PorcentajeDescuento        NUMBER;
    Ln_ServicioInt                NUMBER;
    LnPuntoAdicional              NUMBER;
    Ln_IndxSectores               NUMBER;
    Ln_ExisteOltEdificio          NUMBER := 0;
    Ln_CountServicio              NUMBER;
    Lb_CumpleFormPag              BOOLEAN;
    Lb_CumpleUltMilla             BOOLEAN;
    Lb_CumpleTipoNeg              BOOLEAN;
    Lb_CumplePermanencia          BOOLEAN;
    Lb_CumpleMora                 BOOLEAN;
    Lb_CumpleAntiguedad           BOOLEAN;
    Lb_CumplePlanProd             BOOLEAN;
    Lb_PlanConRestriccion         BOOLEAN;
    Lb_AplicaRol                  BOOLEAN;
    Lr_Sectorizaciones            SYS_REFCURSOR;
    Lr_Sectorizacion              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_SectorizacionInsBwMens;
    Lr_TipoPromoRegla             DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    Lt_SectorizacionInsBwMens     DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tt_SectorizacionInsBwMens;
    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_TiposPromocionesProcesar   DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar;
    La_GruposPromocionesProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar;
    La_TipoPromoPlanProdProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar;
    Lc_PromoActiva                C_PromoActiva%ROWTYPE;
    Lc_CodigoPromocion            C_CodigoPromocionMens%ROWTYPE;
    Lc_TipoServicio               C_CodigoPromocionMens%ROWTYPE;
    Lc_Datos                      C_Datos%ROWTYPE;
    Lc_PeriodoDesc                C_PeriodoDesc%ROWTYPE;
    Lc_GetNombrePlan              C_GetNombrePlan%ROWTYPE;
    Le_Exception                  EXCEPTION;

  BEGIN

    IF C_CodigoPromocionMens%ISOPEN THEN
      CLOSE C_CodigoPromocionMens;
    END IF;

    IF C_CodigoPromocionInsBw%ISOPEN THEN
      CLOSE C_CodigoPromocionInsBw;
    END IF;

    IF C_TipoProcesoMens%ISOPEN THEN
      CLOSE C_TipoProcesoMens;
    END IF;

    IF C_TipoProcesoInsBw%ISOPEN THEN
      CLOSE C_TipoProcesoInsBw;
    END IF;

    IF C_PtoServicio%ISOPEN THEN
      CLOSE C_PtoServicio;
    END IF; 

    IF C_Punto%ISOPEN THEN
      CLOSE C_Punto;
    END IF; 

    Lv_Trama := Pv_Trama;

    WHILE NVL(LENGTH(Lv_Trama),0) > 0 LOOP

    Ln_Posicion := INSTR(Lv_Trama, '|' );

    IF Ln_Posicion > 0 THEN

      Lv_Valor := SUBSTR(Lv_Trama,1, Ln_Posicion-1);

    IF INSTR(Lv_Valor,'CodigoGrupoPromocion',1) > 0 THEN
      Lv_CodigoGrupoPromocion := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
    END IF;

    IF INSTR(Lv_Valor,'TipoPromocion',1) > 0 THEN
      Lv_TipoPromocion := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
    END IF;

    IF INSTR(Lv_Valor,'TipoProceso',1) > 0 THEN
      Lv_Proceso := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
    END IF;

    IF INSTR(Lv_Valor,'CodEmpresa',1) > 0 THEN
      Lv_CodEmpresa := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
    END IF;

    IF INSTR(Lv_Valor,'Codigo',1) > 0 THEN
      Lv_Codigo := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
    END IF;

    IF INSTR(Lv_Valor,'EsContrato',1) > 0 THEN
      Lv_EsContrato := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
    END IF;
    Lv_Trama := SUBSTR(Lv_Trama,Ln_Posicion+1);

    ELSE

     Lv_Trama := NULL;

    END IF;

    END LOOP;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_VALIDACIONES_PREVIAS_CODIGO', 
                                         ' Pv_trama: ' ||Pv_trama ||
                                         ' Pv_CodigoGrupoPromocion: ' ||Lv_CodigoGrupoPromocion ||
                                         ' Pv_TipoPromocion: ' || Lv_TipoPromocion ||
                                         ' Pv_TipoProceso: ' || Lv_Proceso ||
                                         ' Pv_CodEmpresa: ' || Lv_CodEmpresa ||
                                         ' Pv_Codigo: ' || Lv_Codigo ||
                                         ' Pn_IdServicio: '|| Pn_IdServicio ||
                                         ' Pn_IdPunto: '|| Pn_IdPunto ||
                                         ' Pn_IdPlan: '|| Pn_IdPlan ||
                                         ' Pn_IdProducto: ' || Pn_IdProducto ||
                                         ' Pn_IdUltimaMilla: ' || Pn_IdUltimaMilla ||
                                         ' Pv_FormaPago: ' || Pv_FormaPago ||
                                         ' Lv_EsContrato: ' || Lv_EsContrato,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         SYS_CONTEXT('USERENV','IP_ADDRESS'));

    IF Lv_CodigoGrupoPromocion IS NULL OR Lv_TipoPromocion IS NULL OR Lv_Proceso IS NULL
     OR Lv_CodEmpresa IS NULL OR Lv_Codigo IS NULL THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'Ocurri� un error al recuperar datos para la evaluaci�n del c�digo ingresado.';
      RAISE Le_Exception;  
    END IF;

    IF Lv_TipoPromocion = 'PROM_MIX' AND Lv_Proceso = 'NUEVO' AND (Lv_EsContrato IS NULL OR Lv_EsContrato != 'S') THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'Ocurri� un error al recuperar datos para la evaluaci�n del c�digo ingresado.';
      RAISE Le_Exception;
    END IF;

    IF (Pn_IdPunto IS NULL OR Pn_IdPunto <= 0) AND (Pn_IdServicio IS NOT NULL OR Pn_IdServicio > 0) THEN
      OPEN C_Punto(Pn_IdServicio);
        FETCH C_Punto INTO Ln_IdPunto;
      CLOSE C_Punto;
    ELSE
      Ln_IdPunto := Pn_IdPunto;
    END IF;

    Lb_AplicaRol := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ROL(Fn_IdPunto    => Ln_IdPunto,
                                                                    Fv_CodEmpresa => Lv_CodEmpresa);

    IF NOT Lb_AplicaRol THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'Los c�digos promocionales solo aplican para Personas con rol PreCliente � Cliente.';
      RAISE Le_Exception;
    END IF;

    IF UPPER(TRIM(Lv_Proceso)) = 'UPGRADE' OR UPPER(TRIM(Lv_Proceso)) = 'DOWNGRADE' THEN
      IF C_ExistePlan%ISOPEN THEN
        CLOSE C_ExistePlan;
      END IF; 
      OPEN C_ExistePlan(Pn_IdServicio,Pn_IdPlan);
      FETCH C_ExistePlan INTO Ln_ExistePlan;
      CLOSE C_ExistePlan;
      IF Ln_ExistePlan > 0 THEN
        Lv_Aplica   := 'N';
        Pv_Mensaje  := 'Debe escoger un plan diferente para poder validar el c�digo ingresado..';
        RAISE Le_Exception;
      END IF;
    END IF;

    IF UPPER(TRIM(Lv_Proceso)) = 'UPGRADE' OR UPPER(TRIM(Lv_Proceso)) = 'DOWNGRADE' THEN
      Lv_TipoProceso := 'EXISTENTE';
    ELSE
      Lv_TipoProceso := Lv_Proceso;
    END IF;

    IF Pn_IdServicio IS NULL OR UPPER(TRIM(Lv_TipoProceso)) = 'EXISTENTE' THEN
      Ln_ServicioInt := NULL;
    ELSIF UPPER(TRIM(Lv_TipoProceso)) = 'NUEVO' AND UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_MENS' AND Pn_IdServicio IS NOT NULL THEN
      OPEN C_PtoServicio(Ln_IdPunto, Lv_CodEmpresa);
      FETCH C_PtoServicio INTO Ln_ServicioInt;
      CLOSE C_PtoServicio;
    ELSE 
      Ln_ServicioInt := Pn_IdServicio;
    END IF;

    IF UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_MENS' THEN
    --
      OPEN C_CodigoPromocionMens(UPPER(TRIM(Lv_TipoPromocion)),Lv_Codigo);
        FETCH C_CodigoPromocionMens INTO Lc_CodigoPromocion;
      CLOSE C_CodigoPromocionMens;
    --
    ELSE
    --
      OPEN C_CodigoPromocionInsBw(UPPER(TRIM(Lv_TipoPromocion)),Lv_Codigo);
        FETCH C_CodigoPromocionInsBw INTO Lc_CodigoPromocion;
      CLOSE C_CodigoPromocionInsBw;
    --
    END IF;

    IF Lc_CodigoPromocion.EXISTE IS NULL THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El c�digo no es v�lido � no existe para el tipo de promoci�n ingresada.';
      RAISE Le_Exception;
    END IF;

    IF C_VigenciaPromo%ISOPEN THEN
      CLOSE C_VigenciaPromo;
    END IF;

    OPEN C_VigenciaPromo(Lc_CodigoPromocion.ID_TIPO_PROMOCION);
      FETCH C_VigenciaPromo INTO Ln_VigenciaPromo;
    CLOSE C_VigenciaPromo;

    IF Ln_VigenciaPromo = 0 THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El c�digo ingresado pertenece a una promoci�n que no est� vigente.';
      RAISE Le_Exception;
    END IF;

    IF C_PromoActiva%ISOPEN THEN
      CLOSE C_PromoActiva;
    END IF;

    OPEN C_PromoActiva(Lc_CodigoPromocion.ID_TIPO_PROMOCION);
      FETCH C_PromoActiva INTO Lc_PromoActiva;
    CLOSE C_PromoActiva;

    IF Lc_PromoActiva.ESTADO != 'Activo' THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El c�digo ingresado pertenece a una promoci�n en estado '||Lc_PromoActiva.ESTADO||'.';
      RAISE Le_Exception;
    END IF;

    IF UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_MENS' THEN
    --
      OPEN C_TipoProcesoMens(UPPER(TRIM(Lv_TipoPromocion)),UPPER(TRIM(Lv_Proceso)),Lc_PromoActiva.ID_GRUPO_PROMOCION);
        FETCH C_TipoProcesoMens INTO Lc_TipoServicio;
      CLOSE C_TipoProcesoMens;
    --
    ELSE
    --
      OPEN C_TipoProcesoInsBw(UPPER(TRIM(Lv_TipoPromocion)),UPPER(TRIM(Lv_Proceso)),Lc_PromoActiva.ID_GRUPO_PROMOCION);
        FETCH C_TipoProcesoInsBw INTO Lc_TipoServicio;
      CLOSE C_TipoProcesoInsBw;
    --
    END IF;

    IF Lc_TipoServicio.EXISTE IS NULL AND (UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_MENS' OR UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_BW') THEN

      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El c�digo no pertenece al tipo de procesamiento ';

      IF UPPER(TRIM(Lv_Proceso)) = 'UPGRADE' OR UPPER(TRIM(Lv_Proceso)) = 'DOWNGRADE' THEN
        Pv_Mensaje  := Pv_Mensaje || 'cambio de plan.';
      ELSIF UPPER(TRIM(Lv_Proceso)) = 'EXISTENTE' THEN
        Pv_Mensaje  := Pv_Mensaje || 'servicios existentes.';
      ELSIF UPPER(TRIM(Lv_Proceso)) = 'NUEVO' THEN
        Pv_Mensaje  := Pv_Mensaje || 'servicios nuevos.';
      ELSE
        Pv_Mensaje  := Pv_Mensaje || 'ejm: Servicio Nuevo, Existente � Cambio de Plan.';
      END IF;

      RAISE Le_Exception;

    END IF;

    IF Pn_IdServicio > 0 THEN
      Lv_TieneSolicitud := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(Pn_IdServicio => Pn_IdServicio);
      IF Lv_TieneSolicitud = 'N' THEN
        Lv_Aplica   := 'N';
        Pv_Mensaje  := 'El servicio ya cuenta con una solicitud por descuento.';
        RAISE Le_Exception;
      END IF;
    END IF;

    La_TiposPromocionesProcesar.DELETE();
    --
    DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT(Pn_IdPunto              => Ln_IdPunto,
                                                         Pn_IdServicio           => Ln_ServicioInt,
                                                         Pn_IdPromocion          => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                         Pv_CodigoGrupoPromocion => UPPER(TRIM(Lv_CodigoGrupoPromocion)),
                                                         Pv_CodEmpresa           => Lv_CodEmpresa,
                                                         Pv_TipoProceso          => UPPER(TRIM(Lv_Proceso)),
                                                         Pv_TipoEvaluacion       => 'PROM_CODIGO',
                                                         Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                         Pa_TiposPromoPrioridad  => La_TiposPromocionesProcesar);

    IF La_TiposPromocionesProcesar.COUNT = 0 THEN
    --
      IF UPPER(Lv_TipoProceso) = 'NUEVO' THEN
      --
        IF C_CuentaPuntos%ISOPEN THEN
          CLOSE C_CuentaPuntos;
        END IF;
        OPEN C_CuentaPuntos(Ln_IdPunto);
          FETCH C_CuentaPuntos INTO LnPuntoAdicional;
        CLOSE C_CuentaPuntos;
        IF LnPuntoAdicional > 0 THEN
        --
          Lr_ParametrosValidarSec                    := NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION := Lc_PromoActiva.ID_GRUPO_PROMOCION;
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := UPPER(TRIM(Lv_CodigoGrupoPromocion)); 
          Lr_ParametrosValidarSec.EMPRESA_COD        := Lv_CodEmpresa;
          --Obtenemos el cursor de la sectorizaci�n de acuerdo al tipo de promoci�n a la que se esta aplicando.
          Lr_Sectorizaciones                         := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_CURSOR_SECTORIZACION(Lr_ParametrosValidarSec);
          LOOP
          FETCH Lr_Sectorizaciones BULK COLLECT INTO Lt_SectorizacionInsBwMens LIMIT 100;
          EXIT WHEN Lt_SectorizacionInsBwMens.COUNT() < 1;
            Ln_IndxSectores    := Lt_SectorizacionInsBwMens.FIRST;
            WHILE Ln_IndxSectores IS NOT NULL LOOP
            --
              Lr_Sectorizacion := Lt_SectorizacionInsBwMens(Ln_IndxSectores);
              Ln_IndxSectores  := Lt_SectorizacionInsBwMens.NEXT(Ln_IndxSectores);
              IF Lr_Sectorizacion.ID_ELEMENTO != '0' OR Lr_Sectorizacion.ID_EDIFICIO != '0' THEN
                Ln_ExisteOltEdificio := Ln_ExisteOltEdificio + 1;
              END IF;
            --
            END LOOP;
          END LOOP;
          IF Ln_ExisteOltEdificio = 0 THEN
            Lv_Aplica   := 'N';
            Pv_Mensaje  := 'El servicio no cumple con la regla de "Sectorizaci�nn". ';
            RAISE Le_Exception;
          ELSE
            Lv_MensajeOltEdificio := 'NOTA: El c�digo promocional ingresado es por Olt/Edificio por lo tanto '|| 
                                     'su aplicaci�n se confirmar� despu�s de que el servicio este Factible. ';
          END IF;
        --
        ELSE
          Lv_Aplica   := 'N';
          Pv_Mensaje  := 'El servicio no cumple con la regla de "Sectorizaci�nnn". ';
          RAISE Le_Exception;        
        END IF;
      --  
      ELSE
        Lv_Aplica   := 'N';
        Pv_Mensaje  := 'El servicio no cumple con la regla de "Sectorizaci�n". ';
        RAISE Le_Exception;
      END IF;
    END IF;

    Lb_CumpleFormPag  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                                                Fn_IdPunto        => Ln_IdPunto,
                                                                                Pv_Trama          => Pv_FormaPago); 

    IF NOT Lb_CumpleFormPag THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El servicio no cumple con la regla "Forma de Pago". ';
      RAISE Le_Exception;
    END IF;                                                                                

    IF UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_INS' OR UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_BW' THEN

      Lb_CumpleUltMilla := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(Fn_IntIdPromocion => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                                                    Fn_IdServicio     => Pn_IdServicio,  
                                                                                    Fn_IdUltimaMilla  => Pn_IdUltimaMilla);

      IF NOT Lb_CumpleUltMilla THEN
        Lv_Aplica   := 'N';
        Pv_Mensaje  := 'El servicio no cumple con la regla por "�ltima Milla". ';
        RAISE Le_Exception;
      END IF;

      Lb_CumpleTipoNeg  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                                                    Fn_IdServicio     => Pn_IdServicio,
                                                                                    Fn_IdPto          => Ln_IdPunto,
                                                                                    Fv_CodEmpresa     => Lv_CodEmpresa);

      IF NOT Lb_CumpleTipoNeg THEN
        Lv_Aplica   := 'N';
        Pv_Mensaje  := 'El servicio no cumple con la regla por "Tipo Negocio". ';
        RAISE Le_Exception;
      END IF;

    END IF;

    IF UPPER(Lv_TipoProceso) = 'NUEVO' THEN
      Lb_CumplePermanencia := TRUE;
    ELSE
      Lb_CumplePermanencia := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PERMANENCIA(Fn_IntIdPromocion => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                                                      Fv_Tipo_Promocion => UPPER(TRIM(Lv_TipoPromocion)),
                                                                                      Fn_IdPunto        => Ln_IdPunto);
    END IF;

    IF NOT Lb_CumplePermanencia THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El servicio no cumple con la regla "Permanecia M�nima". ';
      RAISE Le_Exception;
    END IF; 

    IF UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_MENS' AND UPPER(TRIM(Lv_TipoProceso)) = 'EXISTENTE' THEN
    --
      Lb_CumpleMora := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_MORA(Fn_IntIdPromocion => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                                        Fv_Tipo_Promocion => UPPER(TRIM(Lv_TipoPromocion)),
                                                                        Fn_IdPunto        => Ln_IdPunto);
    --
    END IF;

    IF NOT Lb_CumpleMora THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El servicio no cumple con la regla por "Mora". ';
      RAISE Le_Exception;
    END IF;

    IF UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_BW' AND UPPER(TRIM(Lv_TipoProceso)) = 'EXISTENTE' THEN
    --
      Lb_CumpleAntiguedad := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ANTIGUEDAD(Fn_IntIdPromocion => Lc_PromoActiva.ID_GRUPO_PROMOCION,
                                                                                    Fn_IdPunto        => Ln_IdPunto);
    --
    END IF;

    IF NOT Lb_CumpleAntiguedad THEN
      Lv_Aplica   := 'N';
      Pv_Mensaje  := 'El servicio no cumple con la regla por "Antig�edad". ';
      RAISE Le_Exception;
    END IF;

    IF Pn_IdServicio > 0 OR Pn_IdPlan > 0 THEN
    --
      IF C_GetNombrePlan%ISOPEN THEN
        CLOSE C_GetNombrePlan;
      END IF;

      OPEN C_GetNombrePlan(Pn_IdServicio,Pn_IdPlan);
      FETCH C_GetNombrePlan INTO Lc_GetNombrePlan;
      CLOSE C_GetNombrePlan;

      IF Lc_GetNombrePlan.NOMBRE_PLAN IS NOT NULL THEN
      --Si posee plan con restricci�n debo generar la Solicitud de Facturaci�n con el valor base por FO y con el Descuento obtenido
      --del parametro RESTRICCION_PLANES_X_INSTALACION
        DB_COMERCIAL.COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           => Lc_GetNombrePlan.NOMBRE_PLAN,
                                                               Pv_EmpresaCod           => Lv_CodEmpresa,
                                                               Pb_PlanConRestriccion   => Lb_PlanConRestriccion,
                                                               Pn_PorcentajeDescuento  => Ln_PorcentajeDescuento,
                                                               Pv_Observacion          => Lv_ObservacionIsnt);
        IF Lb_PlanConRestriccion THEN
          Lv_Aplica   := 'N';
          Pv_Mensaje  := 'Las promociones no aplican para planes empleado o pyme empresa.';
          RAISE Le_Exception;
        END IF;
      END IF;
    END IF;

    IF UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_MENS' OR UPPER(TRIM(Lv_CodigoGrupoPromocion)) = 'PROM_BW' THEN
    --Obtengo los planes y productos por Tipo de Promoci�n, en este caso: PROM_MIX, PROM_MPLA, PROM_MPRO, PROM_BW.
      La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Fn_IdTipoPromocion => Lc_CodigoPromocion.ID_TIPO_PROMOCION); 

      IF (UPPER(TRIM(Lv_TipoPromocion)) IN ('PROM_MIX','PROM_MPLA','PROM_MPRO','PROM_BW')
          AND La_TipoPromoPlanProdProcesar.COUNT = 0) THEN  
      --
        Lv_Aplica  := 'N';
        Pv_Mensaje := 'No se encontraron definidos Planes y/o Productos para el c�digo ingresado.';        
        RAISE Le_Exception; 
      --
      END IF;

      La_ServiciosProcesar.DELETE(); 
      IF UPPER(TRIM(Lv_TipoPromocion)) = 'PROM_MIX' THEN
      --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_SERVICIOS_PROCESAR(Pn_IdPunto              => Ln_IdPunto, 
                                                                   Pv_CodigoGrupoPromocion => Lv_CodigoGrupoPromocion, 
                                                                   Pv_CodEmpresa           => Lv_CodEmpresa, 
                                                                   Pv_TipoProceso          => UPPER(TRIM(Lv_Proceso)), 
                                                                   Pa_ServiciosProcesar    => La_ServiciosProcesar,
                                                                   Pv_EstadoServicio       => DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_ESTADO_SERV(Pn_IdServicio),
                                                                   Pv_EsContrato           => Lv_EsContrato);

        IF La_ServiciosProcesar.COUNT = 0 THEN
          Lv_Aplica  := 'N';
          Pv_Mensaje := 'No cuenta con los servicios "Plan/Producto" necesarios para aplicar un tipo de promoci�n mix.';
          RAISE Le_Exception; 
        END IF;

        IF Pn_IdServicio = 0 THEN
          Ln_CountServicio                                         := La_ServiciosProcesar.COUNT + 1;
          La_ServiciosProcesar(Ln_CountServicio).ID_SERVICIO       := Pn_IdServicio;
          La_ServiciosProcesar(Ln_CountServicio).ID_PUNTO          := Ln_IdPunto;
          La_ServiciosProcesar(Ln_CountServicio).ID_PLAN           := Pn_IdPlan;
          La_ServiciosProcesar(Ln_CountServicio).ID_PRODUCTO       := 0;
          La_ServiciosProcesar(Ln_CountServicio).PLAN_ID_SUPERIOR  := 0;
          La_ServiciosProcesar(Ln_CountServicio).ESTADO            := 'Pendiente';
        END IF;

        La_ServiciosCumplePromo.DELETE(); 
        --Obtengo los servicios a procesar por cada Tipo Promocional            
        DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(Pa_ServiciosProcesar         => La_ServiciosProcesar, 
                                                                 Pv_CodigoTipoPromocion       => UPPER(TRIM(Lv_TipoPromocion)),
                                                                 Pa_TipoPromoPlanProdProcesar => La_TipoPromoPlanProdProcesar, 
                                                                 Pb_CumplePromo               => Lb_CumplePlanProd,
                                                                 Pa_ServiciosCumplePromo      => La_ServiciosCumplePromo);                     
        IF NOT Lb_CumplePlanProd AND La_ServiciosCumplePromo.COUNT = 0 THEN                      
          Lv_Aplica   := 'N';
          Pv_Mensaje  := 'Los servicios no cumplen con la regla "Plan/Producto" para aplicar un tipo de promoci�n mix.';
          RAISE Le_Exception;
        END IF;  

        Ln_ServiciosCumplePromo := La_ServiciosCumplePromo.FIRST;           
        WHILE (Ln_ServiciosCumplePromo IS NOT NULL)   
        LOOP
          IF La_ServiciosCumplePromo(Ln_ServiciosCumplePromo).ID_SERVICIO > 0 THEN
            Lv_Servicios := Lv_Servicios||La_ServiciosCumplePromo(Ln_ServiciosCumplePromo).ID_SERVICIO||',';      
          END IF;
          Ln_ServiciosCumplePromo := La_ServiciosCumplePromo.NEXT(Ln_ServiciosCumplePromo);
        END LOOP;
        Lv_Servicios := SUBSTR(Lv_Servicios,1,length(Lv_Servicios)-1);
      --
      ELSE
      --
        Lb_CumplePlanProd := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_PLAN_PROD(Fn_IdPlan                    => Pn_IdPlan,
                                                                                   Fn_IdProducto                => Pn_IdProducto,
                                                                                   Fv_CodigoTipoPromocion       => UPPER(TRIM(Lv_TipoPromocion)),
                                                                                   Fa_TipoPromoPlanProdProcesar => La_TipoPromoPlanProdProcesar);

        IF NOT Lb_CumplePlanProd THEN
          Lv_Aplica   := 'N';
          Pv_Mensaje  := 'El servicio no cumple con la regla "Plan/Producto". ';
          RAISE Le_Exception;
        END IF;
      END IF;
    END IF;

    Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Fn_IdTipoPromocion => Lc_CodigoPromocion.ID_TIPO_PROMOCION);

    IF Lr_TipoPromoRegla.PROM_DESCUENTO IS NOT NULL THEN
    --
      Lv_Descuento := Lr_TipoPromoRegla.PROM_DESCUENTO;
    --
    ELSE
    --
      OPEN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO);
      FETCH C_PeriodoDesc INTO Lc_PeriodoDesc;
      CLOSE C_PeriodoDesc;
      Lv_Descuento := Lc_PeriodoDesc.DESCUENTO;
    --
    END IF;

    OPEN C_Datos(Pn_IdServicio,Lc_PromoActiva.ID_GRUPO_PROMOCION,Lc_CodigoPromocion.ID_TIPO_PROMOCION);
    FETCH C_Datos INTO Lc_Datos;
    CLOSE C_Datos;

    IF Lv_CodigoGrupoPromocion = 'PROM_MENS' THEN
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

    IF Lv_CodigoGrupoPromocion = 'PROM_INS' THEN
      Lv_Observacion := 'Desct. Inst. Porcentaje: ' || Lv_Descuento ||'%, #Numero de Periodos: '||Lc_Datos.PERIODOS;
    ELSE
      Lv_Observacion := 'Desct. Fact. Mensual: Promoci�n Indefinida: ' || NVL(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA,'NO')
                        || ', Tipo Periodo: ' || UPPER(NVL(Lr_TipoPromoRegla.PROM_TIPO_PERIODO,'Unico')) || ',' || Lv_ObservacionDesc;
    END IF;

    IF Lv_CodigoGrupoPromocion = 'PROM_BW' THEN
      Lv_Promocion := Lc_PromoActiva.NOMBRE_GRUPO;
    ELSE
      Lv_Promocion := Lc_PromoActiva.NOMBRE_GRUPO || ', ' || Lv_Observacion;
    END IF;

    Lv_Aplica       := 'S';
    Pv_Mensaje      := Lv_Aplica||',El servicio cumple con los requisitos para aplicar el c�digo de la promoci�n '||
                       Lc_PromoActiva.NOMBRE_GRUPO ||' ingresada.,'||Lc_PromoActiva.NOMBRE_GRUPO||','
                       ||Lc_CodigoPromocion.ID_TIPO_PROMOCION||','||Lv_MensajeOltEdificio;
    Pv_Detalle      := Lv_Promocion;
    Pv_ServiciosMix := Lv_Servicios;

  EXCEPTION
  WHEN Le_Exception THEN
  --
    Lv_Aplica  := 'N';
    Pv_Mensaje := Lv_Aplica||','||Pv_Mensaje;
  --
  WHEN OTHERS THEN
  --
    Lv_Aplica  := 'N';
    Pv_Mensaje := Lv_Aplica||',Ocurri� un error al validar el c�digo ingresado.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_VALIDACIONES_PREVIAS_CODIGO', 
                                         Pv_Mensaje || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  --
  END P_VALIDACIONES_PREVIAS_CODIGO;

  FUNCTION F_VALIDA_PLAN_PROD(Fn_IdPlan                    IN NUMBER DEFAULT NULL,
                              Fn_IdProducto                IN NUMBER DEFAULT NULL,
                              Fv_CodigoTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Fa_TipoPromoPlanProdProcesar IN DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar)
    RETURN BOOLEAN
  IS
    Lv_IpCreacion      VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado    VARCHAR2(2000); 
    Ln_Indice1         NUMBER;
    Lb_cumplePlanProd  BOOLEAN := FALSE;

  BEGIN
    --Verifico que los Planes y Productos definidos por Tipo Promocional se encuentren como servicios en el Punto para poder 
    --otorgar la promoci�n.   
    IF (Fv_CodigoTipoPromocion != 'PROM_MIX' AND Fa_TipoPromoPlanProdProcesar.COUNT > 0) THEN   
    --
      Ln_Indice1 := Fa_TipoPromoPlanProdProcesar.FIRST;   
      WHILE (Ln_Indice1 IS NOT NULL)   
      LOOP

        IF ((Fa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PLAN IS NOT NULL 
          AND Fa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PLAN = Fn_IdPlan)
          OR (Fa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PRODUCTO IS NOT NULL 
          AND Fa_TipoPromoPlanProdProcesar(Ln_Indice1).ID_PRODUCTO = Fn_IdProducto)) THEN

         Lb_cumplePlanProd := TRUE;

        END IF;       

        --    
        Ln_Indice1 := Fa_TipoPromoPlanProdProcesar.NEXT(Ln_Indice1);   
        --
      END LOOP;
    --                  
    END IF;

    RETURN Lb_cumplePlanProd;

  EXCEPTION
  WHEN OTHERS THEN    
    Lv_MsjResultado := 'Ocurrio un error al verificar que los Planes y Productos de la promoci�n';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_PLAN_PROD', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN FALSE;                       
  END F_VALIDA_PLAN_PROD;

  PROCEDURE P_INSERT_CARACTERISTICA_SERV(Pr_InfoServicioCaracteristica  IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                         Pv_MsjResultado                OUT VARCHAR2) AS
  BEGIN

    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
    (ID_SERVICIO_CARACTERISTICA,
     SERVICIO_ID,
     CARACTERISTICA_ID,
     VALOR,
     FE_FACTURACION,
     CICLO_ORIGEN_ID,
     ESTADO,
     OBSERVACION,
     USR_CREACION,
     IP_CREACION,
     FE_CREACION,
     USR_ULT_MOD,
     IP_ULT_MOD,
     FE_ULT_MOD)
    VALUES
    (Pr_InfoServicioCaracteristica.ID_SERVICIO_CARACTERISTICA,
     Pr_InfoServicioCaracteristica.SERVICIO_ID,
     Pr_InfoServicioCaracteristica.CARACTERISTICA_ID,
     Pr_InfoServicioCaracteristica.VALOR,
     Pr_InfoServicioCaracteristica.FE_FACTURACION,
     Pr_InfoServicioCaracteristica.CICLO_ORIGEN_ID,
     Pr_InfoServicioCaracteristica.ESTADO,
     Pr_InfoServicioCaracteristica.OBSERVACION,
     Pr_InfoServicioCaracteristica.USR_CREACION,
     Pr_InfoServicioCaracteristica.IP_CREACION,
     Pr_InfoServicioCaracteristica.FE_CREACION,
     Pr_InfoServicioCaracteristica.USR_ULT_MOD,
     Pr_InfoServicioCaracteristica.IP_ULT_MOD,
     Pr_InfoServicioCaracteristica.FE_ULT_MOD);
    --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_INSERT_CARACTERISTICA_SERV - ' || SQLERRM;
  END P_INSERT_CARACTERISTICA_SERV;

  PROCEDURE P_UPDATE_CARACTERISTICA_SERV(Pr_InfoServicioCaracteristica  IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                         Pv_MsjResultado                OUT VARCHAR2) AS
  BEGIN

    UPDATE  DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
    SET ID_SERVICIO_CARACTERISTICA = NVL(Pr_InfoServicioCaracteristica.ID_SERVICIO_CARACTERISTICA, ID_SERVICIO_CARACTERISTICA),        
      SERVICIO_ID                    = NVL(Pr_InfoServicioCaracteristica.SERVICIO_ID, SERVICIO_ID),
      CARACTERISTICA_ID              = NVL(Pr_InfoServicioCaracteristica.CARACTERISTICA_ID, CARACTERISTICA_ID),
      VALOR                          = NVL(Pr_InfoServicioCaracteristica.VALOR, VALOR),
      FE_FACTURACION                 = NVL(Pr_InfoServicioCaracteristica.FE_FACTURACION, FE_FACTURACION),
      CICLO_ORIGEN_ID                = NVL(Pr_InfoServicioCaracteristica.CICLO_ORIGEN_ID, CICLO_ORIGEN_ID),
      ESTADO                         = NVL(Pr_InfoServicioCaracteristica.ESTADO, ESTADO),
      OBSERVACION                    = NVL(Pr_InfoServicioCaracteristica.OBSERVACION, OBSERVACION),
      USR_CREACION                   = NVL(Pr_InfoServicioCaracteristica.USR_CREACION, USR_CREACION),
      IP_CREACION                    = NVL(Pr_InfoServicioCaracteristica.IP_CREACION, IP_CREACION),
      FE_CREACION                    = NVL(Pr_InfoServicioCaracteristica.FE_CREACION, FE_CREACION),
      USR_ULT_MOD                    = NVL(Pr_InfoServicioCaracteristica.USR_ULT_MOD, USR_ULT_MOD),
      IP_ULT_MOD                     = NVL(Pr_InfoServicioCaracteristica.IP_ULT_MOD, IP_ULT_MOD),
      FE_ULT_MOD                     = NVL(Pr_InfoServicioCaracteristica.FE_ULT_MOD, FE_ULT_MOD)
    WHERE SERVICIO_ID     = Pr_InfoServicioCaracteristica.SERVICIO_ID
    AND CARACTERISTICA_ID = Pr_InfoServicioCaracteristica.CARACTERISTICA_ID;
    --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_CARACTERISTICA_SERV - ' || SQLERRM;
  END P_UPDATE_CARACTERISTICA_SERV;

  FUNCTION F_OBTIENE_PROMOCION_COD(Fv_Codigo               IN VARCHAR2 DEFAULT NULL,
                                   Fv_IdTipoPromocion      IN VARCHAR2 DEFAULT NULL,
                                   Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE DEFAULT NULL,
                                   Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2
  IS

    --Costo: 13
    CURSOR C_PromocionMens(Cv_Codigo  VARCHAR2,
                           Cv_Empresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS  
      SELECT AGP.NOMBRE_GRUPO 
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'PROM_CODIGO'
      AND AGPR.CARACTERISTICA_ID            = DBAC.ID_CARACTERISTICA
      AND AGPR.ESTADO                       = 'Activo'
      AND UPPER(TRIM(AGPR.VALOR))           = UPPER(TRIM(Cv_Codigo))
      AND AGP.ID_GRUPO_PROMOCION            = AGPR.GRUPO_PROMOCION_ID
      AND AGP.EMPRESA_COD                   = Cv_Empresa;

    --Costo: 13
    CURSOR C_PromocionBwInst(Cv_Codigo  VARCHAR2,
                             Cv_Empresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS  
      SELECT AGP.NOMBRE_GRUPO 
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'PROM_CODIGO'
      AND ATPR.CARACTERISTICA_ID            = DBAC.ID_CARACTERISTICA
      AND ATPR.ESTADO                       = 'Activo'
      AND UPPER(TRIM(ATPR.VALOR))           = UPPER(TRIM(Cv_Codigo))
      AND ATP.ID_TIPO_PROMOCION             = ATPR.TIPO_PROMOCION_ID
      AND AGP.ID_GRUPO_PROMOCION            = ATP.GRUPO_PROMOCION_ID
      AND AGP.EMPRESA_COD                   = Cv_Empresa;

    --Costo: 8
    CURSOR C_CodigoMens(Cv_IdTipoPromocion VARCHAR2,
                        Cv_Empresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS  
      SELECT UPPER(AGPR.VALOR)
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
      WHERE ATP.ID_TIPO_PROMOCION           = COALESCE(TO_NUMBER(REGEXP_SUBSTR( Cv_IdTipoPromocion ,'^\d+')),0)
      AND AGPR.GRUPO_PROMOCION_ID           = ATP.GRUPO_PROMOCION_ID
      AND DBAC.DESCRIPCION_CARACTERISTICA   = 'PROM_CODIGO'
      AND AGPR.CARACTERISTICA_ID            = DBAC.ID_CARACTERISTICA
      AND AGPR.ESTADO                       != 'Eliminado'
      AND AGP.ID_GRUPO_PROMOCION            = AGPR.GRUPO_PROMOCION_ID
      AND AGP.EMPRESA_COD                   = Cv_Empresa;

    --Costo: 8
    CURSOR C_CodigoBwInst(Cv_IdTipoPromocion VARCHAR2,
                          Cv_Empresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS  
      SELECT UPPER(ATPR.VALOR)
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
      WHERE ATP.ID_TIPO_PROMOCION           = COALESCE(TO_NUMBER(REGEXP_SUBSTR( Cv_IdTipoPromocion ,'^\d+')),0)
      AND ATPR.TIPO_PROMOCION_ID            = ATP.ID_TIPO_PROMOCION
      AND ATPR.ESTADO                       != 'Eliminado'
      AND DBAC.DESCRIPCION_CARACTERISTICA   = 'PROM_CODIGO'
      AND ATPR.CARACTERISTICA_ID            = DBAC.ID_CARACTERISTICA
      AND AGP.ID_GRUPO_PROMOCION            = ATP.GRUPO_PROMOCION_ID
      AND AGP.EMPRESA_COD                   = Cv_Empresa;

    --Costo: 1
    CURSOR C_Tipopromocion(Cv_IdTipoPromocion VARCHAR2) IS  
      SELECT ATP.CODIGO_TIPO_PROMOCION
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP
      WHERE ATP.ID_TIPO_PROMOCION = COALESCE(TO_NUMBER(REGEXP_SUBSTR( Cv_IdTipoPromocion ,'^\d+')),0);    

    Lv_IpCreacion      VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado    VARCHAR2(2000); 
    Ln_Indice1         NUMBER;
    Lv_NombrePromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE;
    Lv_Tipopromocion   DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;

  BEGIN

    IF TRIM(Fv_Codigo) IS NOT NULL AND TRIM(Fv_IdTipoPromocion) IS NULL THEN
    --
      IF C_PromocionBwInst%ISOPEN THEN    
        CLOSE C_PromocionBwInst;    
      END IF;

      IF C_PromocionMens%ISOPEN THEN    
        CLOSE C_PromocionMens;    
      END IF;

      IF Fv_CodigoGrupoPromocion = 'PROM_MENS' THEN
        OPEN C_PromocionMens(Fv_Codigo,Fv_CodEmpresa);
        FETCH C_PromocionMens INTO Lv_NombrePromocion;    
        CLOSE C_PromocionMens;
      ELSE
        OPEN C_PromocionBwInst(Fv_Codigo,Fv_CodEmpresa);
        FETCH C_PromocionBwInst INTO Lv_NombrePromocion;    
        CLOSE C_PromocionBwInst;
      END IF;
    --
    END IF;

    IF TRIM(Fv_IdTipoPromocion) IS NOT NULL AND TRIM(Fv_Codigo) IS NULL THEN
    --
      IF C_CodigoMens%ISOPEN THEN    
        CLOSE C_PromocionBwInst;    
      END IF;

      IF C_CodigoBwInst%ISOPEN THEN    
        CLOSE C_PromocionMens;    
      END IF;

      IF C_Tipopromocion%ISOPEN THEN    
        CLOSE C_Tipopromocion;    
      END IF;

      OPEN C_Tipopromocion(Fv_IdTipoPromocion);
      FETCH C_Tipopromocion INTO Lv_Tipopromocion;    
      CLOSE C_Tipopromocion;

      IF Lv_Tipopromocion IN ('PROM_INS','PROM_BW') THEN
        OPEN C_CodigoBwInst(Fv_IdTipoPromocion,Fv_CodEmpresa);
        FETCH C_CodigoBwInst INTO Lv_NombrePromocion;    
        CLOSE C_CodigoBwInst;
      ELSE
        OPEN C_CodigoMens(Fv_IdTipoPromocion,Fv_CodEmpresa);
        FETCH C_CodigoMens INTO Lv_NombrePromocion;    
        CLOSE C_CodigoMens;
      END IF;
    --
    END IF;

    RETURN Lv_NombrePromocion;

  EXCEPTION
  WHEN OTHERS THEN    
    Lv_MsjResultado := 'Ocurri� un error al obtener el nombre de la promoci�n por el c�digo promocional.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_OBTIENE_PROMOCION_COD', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Lv_NombrePromocion;                     
  END F_OBTIENE_PROMOCION_COD;

  FUNCTION F_VALIDA_PLAN_EMP_PYME(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2
  IS  

    --Costo: 4
    CURSOR C_GetNombrePlan(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IPC.NOMBRE_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE ISER.ID_SERVICIO = Cn_IdServicio
      AND IPC.ID_PLAN        = ISER.PLAN_ID;

    CURSOR C_GetEmpresa(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IER.EMPRESA_COD
      FROM DB_COMERCIAL.INFO_SERVICIO SERV,
        DB_COMERCIAL.INFO_PUNTO PTO,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE SERV.ID_SERVICIO  = Cn_IdServicio
      AND PTO.ID_PUNTO        = SERV.PUNTO_ID
      AND IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
      AND IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID;    

    Lv_Aplica              VARCHAR2(1) := 'S';
    Lv_ObservacionIsnt     VARCHAR2(3200);
    Ln_PorcentajeDescuento NUMBER;
    Lc_GetNombrePlan       C_GetNombrePlan%ROWTYPE;
    Lb_Aplica              BOOLEAN;
    Lv_CodEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  BEGIN

    IF C_GetNombrePlan%ISOPEN THEN
      CLOSE C_GetNombrePlan;
    END IF;

    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;

    OPEN C_GetEmpresa(Pn_IdServicio);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;

    OPEN C_GetNombrePlan(Pn_IdServicio);
    FETCH C_GetNombrePlan INTO Lc_GetNombrePlan;
    CLOSE C_GetNombrePlan;

    IF Lc_GetNombrePlan.NOMBRE_PLAN IS NOT NULL THEN

      DB_COMERCIAL.COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           => Lc_GetNombrePlan.NOMBRE_PLAN,
                                                             Pv_EmpresaCod           => Lv_CodEmpresa,
                                                             Pb_PlanConRestriccion   => Lb_Aplica,
                                                             Pn_PorcentajeDescuento  => Ln_PorcentajeDescuento,
                                                             Pv_Observacion          => Lv_ObservacionIsnt);
      IF Lb_Aplica THEN
        Lv_Aplica := 'N';
      ELSE
        Lv_Aplica := 'S';    
      END IF;
    END IF;

    RETURN Lv_Aplica;

  EXCEPTION
  WHEN OTHERS THEN    
    RETURN Lv_Aplica;                  
  END F_VALIDA_PLAN_EMP_PYME;

  FUNCTION F_VALIDA_SOLICITUD_SERVICIO(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2
  IS  

    --Costo: 8
    CURSOR C_GetEmpresa(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IER.EMPRESA_COD
      FROM DB_COMERCIAL.INFO_SERVICIO SERV,
        DB_COMERCIAL.INFO_PUNTO PTO,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE SERV.ID_SERVICIO  = Cn_IdServicio
      AND PTO.ID_PUNTO        = SERV.PUNTO_ID
      AND IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
      AND IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID;

    --Costo: 7
    CURSOR C_GetSolicitud(Cn_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                          Cv_EstadoActivo    VARCHAR2,
                          Cv_NombreParametro VARCHAR2,
                          Cv_DescParametro   VARCHAR2,
                          Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT COUNT(ID_DETALLE_SOLICITUD)
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
        DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
      WHERE ATS.DESCRIPCION_SOLICITUD = 'SOLICITUD DESCUENTO'
      AND IDS.TIPO_SOLICITUD_ID       = ATS.ID_TIPO_SOLICITUD
      AND IDS.ESTADO                  IN (SELECT DET.VALOR1
                                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                            DB_GENERAL.ADMI_PARAMETRO_DET DET
                                          WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                          AND CAB.ESTADO             = Cv_EstadoActivo
                                          AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                          AND DET.ESTADO             = Cv_EstadoActivo
                                          AND DET.DESCRIPCION        = Cv_DescParametro
                                          AND DET.EMPRESA_COD        = Cv_CodEmpresa)
      AND IDS.SERVICIO_ID             = Cn_IdServicio;

    Lv_Aplica              VARCHAR2(1) := 'S';
    Lv_EstadoActivo        VARCHAR2(6) := 'Activo';
    Lv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%Type := 'PROM_PARAMETROS';
    Lv_DescParametro       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%Type := 'PROM_ESTADOS_SOLICITUDES';
    Ln_Solicitud           NUMBER;
    Lv_CodEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  BEGIN

    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;

    IF C_GetSolicitud%ISOPEN THEN
      CLOSE C_GetSolicitud;
    END IF;

    OPEN C_GetEmpresa(Pn_IdServicio);
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;

    OPEN C_GetSolicitud(Pn_IdServicio,Lv_EstadoActivo,Lv_NombreParametro,Lv_DescParametro,Lv_CodEmpresa);
    FETCH C_GetSolicitud INTO Ln_Solicitud;
    CLOSE C_GetSolicitud;

    IF Ln_Solicitud > 0 THEN
      Lv_Aplica := 'N';
    ELSE
      Lv_Aplica := 'S';    
    END IF;

    RETURN Lv_Aplica;

  EXCEPTION
  WHEN OTHERS THEN    
    RETURN Lv_Aplica;                  
  END F_VALIDA_SOLICITUD_SERVICIO;

  FUNCTION F_VALIDA_ROL(Fn_IdPunto    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                        Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN BOOLEAN 
  IS

    --Costo: 15
    CURSOR C_RolPersona(Cn_IdPunto      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                        Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                        Cv_EstadoActivo VARCHAR2)
    IS
      SELECT COUNT(IPER.ID_PERSONA_ROL) AS VALOR
      FROM DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR
      WHERE IP.ID_PUNTO        = Cn_IdPunto
      AND IPER.ID_PERSONA_ROL  = IP.PERSONA_EMPRESA_ROL_ID
      AND IPER.ESTADO          IN (SELECT APD.VALOR1
                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                     DB_GENERAL.ADMI_PARAMETRO_DET APD
                                   WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                   AND APD.ESTADO           = Cv_EstadoActivo
                                   AND APD.DESCRIPCION      = 'PROM_ESTADOS_ROL'
                                   AND APC.NOMBRE_PARAMETRO = 'PROM_PARAMETROS'
                                   AND APC.ESTADO           = Cv_EstadoActivo
                                   AND APD.EMPRESA_COD      = Cv_CodEmpresa)
      AND IPE.ID_PERSONA        = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL    = IPER.EMPRESA_ROL_ID
      AND IER.EMPRESA_COD       = Cv_CodEmpresa
      AND AR.ID_ROL             = IER.ROL_ID
      AND AR.DESCRIPCION_ROL    IN (SELECT APD.VALOR1
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                  DB_GENERAL.ADMI_PARAMETRO_DET APD
                                WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                AND APD.ESTADO           = Cv_EstadoActivo
                                AND APC.NOMBRE_PARAMETRO = 'PROM_ROLES_CLIENTES'
                                AND APC.ESTADO           = Cv_EstadoActivo
                                AND APD.EMPRESA_COD      = Cv_CodEmpresa);


    Lb_Aplica        BOOLEAN := FALSE;
    Ln_Valor         NUMBER;
    Lv_EstadoActivo  VARCHAR2(6):= 'Activo';
    Lv_MsjResultado  VARCHAR2(3200);

  BEGIN
  --
    IF C_RolPersona%ISOPEN THEN
      CLOSE C_RolPersona;
    END IF;

    OPEN C_RolPersona(Fn_IdPunto,Fv_CodEmpresa,Lv_EstadoActivo);
    --
    FETCH C_RolPersona INTO Ln_Valor;
    --
    CLOSE C_RolPersona;

    IF Ln_Valor > 0 THEN
      Lb_Aplica := TRUE;
    END IF;

    RETURN Lb_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurri� un error al validar la el rol de la persona para el Punto: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_ROL', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lb_Aplica        := FALSE;
    RETURN Lb_Aplica;
  END F_VALIDA_ROL;

  PROCEDURE P_REGULARIZA_SOLICITUDES(Pv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_DescSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE)

  IS
    CURSOR C_Solicitudes(Cv_DescSolicitud  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                         Cv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                         Cv_EstadoActivo   VARCHAR2,
                         Cv_EstadoAprobado VARCHAR2)
    IS
      SELECT IDS.ID_DETALLE_SOLICITUD 
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS,
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
        DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescSolicitud
      AND IDS.TIPO_SOLICITUD_ID       = ATS.ID_TIPO_SOLICITUD 
      AND IDS.ESTADO                  = Cv_EstadoAprobado
      AND ISER.ID_SERVICIO            = IDS.SERVICIO_ID
      AND ISER.ESTADO                 IN ( SELECT APD.VALOR1
                                           FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                             DB_GENERAL.ADMI_PARAMETRO_DET APD
                                           WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                           AND APD.ESTADO           = Cv_EstadoActivo
                                           AND APC.NOMBRE_PARAMETRO = 'PROM_ESTADOS_BAJA_SERV'
                                           AND APC.ESTADO           = Cv_EstadoActivo
                                           AND APD.EMPRESA_COD      = Cv_CodEmpresa)
      AND IP.ID_PUNTO                 = ISER.PUNTO_ID
      AND IPER.ID_PERSONA_ROL         = IP.PERSONA_EMPRESA_ROL_ID
      AND IER.ID_EMPRESA_ROL          = IPER.EMPRESA_ROL_ID
      AND IER.EMPRESA_COD             = Cv_CodEmpresa
      UNION
      SELECT IDS.ID_DETALLE_SOLICITUD 
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS,
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
        DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER
      WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescSolicitud
      AND IDS.TIPO_SOLICITUD_ID       = ATS.ID_TIPO_SOLICITUD  
      AND IDS.ESTADO                  = Cv_EstadoAprobado
      AND ISER.ID_SERVICIO            = IDS.SERVICIO_ID
      AND EXISTS                      ( SELECT 'X'
                                        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DBIDS,
                                          DB_COMERCIAL.ADMI_TIPO_SOLICITUD DBATS
                                        WHERE DBATS.DESCRIPCION_SOLICITUD = 'SOLICITUD DESCUENTO'
                                        AND DBIDS.TIPO_SOLICITUD_ID       = DBATS.ID_TIPO_SOLICITUD
                                        AND DBIDS.ESTADO                  IN (SELECT DET.VALOR1
                                                                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                                              DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                                              WHERE CAB.NOMBRE_PARAMETRO = 'PROM_PARAMETROS'
                                                                              AND CAB.ESTADO             = Cv_EstadoActivo
                                                                              AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                                              AND DET.ESTADO             = Cv_EstadoActivo
                                                                              AND DET.EMPRESA_COD        = Cv_CodEmpresa
                                                                              AND DET.DESCRIPCION        = 'PROM_ESTADOS_SOLICITUDES')
                                        AND DBIDS.SERVICIO_ID             = ISER.ID_SERVICIO )
      AND IP.ID_PUNTO                 = ISER.PUNTO_ID
      AND IPER.ID_PERSONA_ROL         = IP.PERSONA_EMPRESA_ROL_ID
      AND IER.ID_EMPRESA_ROL          = IPER.EMPRESA_ROL_ID
      AND IER.EMPRESA_COD             = Cv_CodEmpresa;

    Lv_EstadoActivo         VARCHAR2(6) := 'Activo';
    Lv_EstadoAprobado       VARCHAR2(8) := 'Aprobado';
    Lv_IpCreacion           VARCHAR2(16) := '127.0.0.1';
    Lv_msj                  VARCHAR2(4000);
    Ln_Indx                 NUMBER;
    La_SolicitudesProcesar  T_SolicitudesProcesar;
    Lr_InfoDetalleSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolHist   DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lex_Exception           EXCEPTION;

  BEGIN

    OPEN C_Solicitudes (Pv_DescSolicitud,Pv_CodEmpresa,Lv_EstadoActivo,Lv_EstadoAprobado);
     LOOP
     --
      FETCH C_Solicitudes BULK COLLECT
      --
        INTO La_SolicitudesProcesar LIMIT 1000;
        EXIT WHEN La_SolicitudesProcesar.count = 0;
        Ln_Indx := La_SolicitudesProcesar.FIRST;
        WHILE (Ln_Indx IS NOT NULL)
        LOOP
        --
          BEGIN

            --Se procede a pasar la Solicitud a estado 'Eliminada'.
            Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolicitud.ESTADO               := 'Eliminada';
            --
            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_UPDATE_INFO_DETALLE_SOLI(Lr_InfoDetalleSolicitud, Lv_msj);
            --          
            IF TRIM(Lv_msj) IS NOT NULL THEN
              RAISE Lex_Exception;
            END IF;

            --Se guarda Historial en la Solicitud por estado 'Fallo'.
            Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolHist.ESTADO                 := 'Eliminada';
            Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
            Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
            Lr_InfoDetalleSolHist.OBSERVACION            := 'Se procede a cambiar el estado por regualarizaci�n de '||
                                                             'solicitudes de promociones encoladas.';
            Lr_InfoDetalleSolHist.USR_CREACION           := 'telcos_mapeo_promo';
            Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
            Lr_InfoDetalleSolHist.MOTIVO_ID              := NULL;
            --
            DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_msj);
            --
            IF TRIM(Lv_msj) IS NOT NULL THEN
              RAISE Lex_Exception;
            END IF; 

          EXCEPTION
          WHEN Lex_Exception THEN
          --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES_UTIL.P_REGULARIZA_SOLICITUDES', 
                                                 Lv_msj,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          WHEN OTHERS THEN
          --
            Lv_msj := 'Ocurri� un error al regularizar la solicitud: '|| La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES_UTIL.P_REGULARIZA_SOLICITUDES', 
                                                 Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          END;
        --
        Ln_Indx := La_SolicitudesProcesar.NEXT (Ln_Indx);
        END LOOP;
        --
        COMMIT;
      --
      END LOOP;
    --
    CLOSE C_Solicitudes;

  EXCEPTION  
  WHEN OTHERS THEN
  --
    Lv_msj := 'Ocurri� un error al ejecutar el proceso de regularizaci�n de solicitudes.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_REGULARIZA_SOLICITUDES', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

  END P_REGULARIZA_SOLICITUDES;

  PROCEDURE P_UPDATE_INFO_DETALLE_SOLI(Pr_InfoDetalleSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                       Pv_MsnError             OUT VARCHAR2)
  IS
    Le_Exception     EXCEPTION;
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN
    --
    IF (NVL(Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD, 0) = 0) THEN
      Pv_MsnError := 'Error al actualizar Solicitud. Par�metro Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD vac�o.';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    SET ESTADO                 = NVL(Pr_InfoDetalleSolicitud.ESTADO, ESTADO) 
    WHERE ID_DETALLE_SOLICITUD = Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES_UTIL.P_UPDATE_INFO_DETALLE_SOLI',
                                           Pv_MsnError,
                                           'telcos_mapeo_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    WHEN OTHERS THEN         
      Pv_MsnError := 'Error al actualizar la caracter�stica - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_PROMOCIONES_UTIL.P_UPDATE_INFO_DETALLE_SOLI',
                                           Pv_MsnError,
                                           'telcos_mapeo_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  --   
  END P_UPDATE_INFO_DETALLE_SOLI;

  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
                                           Pv_MsnError             OUT VARCHAR2)
  IS
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
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
      --            
      Pv_MsnError := 'Error al insertar historial de la Solicitud - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_PROMOCIONES_UTIL.P_INSERT_INFO_DETALLE_SOL_HIST', 
                                           Pv_MsnError, 
                                           'telcos_diferido',
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));    
  --
  END P_INSERT_INFO_DETALLE_SOL_HIST;
----
  FUNCTION F_COMPARAR_PLAN_PROMO_BW(Fn_PlanIdUno IN NUMBER,
                                    Fn_PlanIdDos IN NUMBER)
  RETURN VARCHAR2
  IS
      --
      Lv_ResulComparar         VARCHAR2(40);
      Lv_Resultado             VARCHAR2(5)  := 'NO';
      Lv_CaractLineProfile     VARCHAR2(40) := 'LINE-PROFILE-NAME';
      Lv_Estado                VARCHAR2(20) := 'Activo';
      Lv_EstadoInactivo        VARCHAR2(20) := 'Inactivo';
      Lv_EstadoClonado         VARCHAR2(20) := 'Clonado';
      Lv_CodigoProducto        VARCHAR2(5)  := 'INTD';
      Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
      Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
      Lv_MsjResultado          VARCHAR2(4000);
      --
      CURSOR C_CompararLineProfile
      IS
        SELECT 'SI' FROM (
          SELECT PCA.ID_PLAN, CAR.VALOR AS LINE_PROFILE_NAME
          FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR
            INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE ON PDE.ID_ITEM = CAR.PLAN_DET_ID
            INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PCA ON PCA.ID_PLAN = PDE.PLAN_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC ON PC.ID_PRODUCTO_CARACTERISITICA = CAR.PRODUCTO_CARACTERISITICA_ID
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C ON C.ID_CARACTERISTICA = PC.CARACTERISTICA_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = PDE.PRODUCTO_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P ON P.ID_PRODUCTO = PC.PRODUCTO_ID
          WHERE C.DESCRIPCION_CARACTERISTICA = Lv_CaractLineProfile
            AND P.CODIGO_PRODUCTO = Lv_CodigoProducto
            AND PRO.CODIGO_PRODUCTO = Lv_CodigoProducto
            AND PCA.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
            AND PDE.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
            AND CAR.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
        ) PLAN_PER
        WHERE EXISTS (
          SELECT 1
          FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR2
            INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE2 ON PDE2.ID_ITEM = CAR2.PLAN_DET_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC2 ON PC2.ID_PRODUCTO_CARACTERISITICA = CAR2.PRODUCTO_CARACTERISITICA_ID
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C2 ON C2.ID_CARACTERISTICA = PC2.CARACTERISTICA_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO2 ON PRO2.ID_PRODUCTO = PDE2.PRODUCTO_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P2 ON P2.ID_PRODUCTO = PC2.PRODUCTO_ID
          WHERE C2.DESCRIPCION_CARACTERISTICA = Lv_CaractLineProfile
            AND P2.CODIGO_PRODUCTO = Lv_CodigoProducto
            AND PRO2.CODIGO_PRODUCTO = Lv_CodigoProducto
            AND PDE2.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
            AND CAR2.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
            AND PDE2.PLAN_ID = Fn_PlanIdUno
            AND CAR2.VALOR   = PLAN_PER.LINE_PROFILE_NAME
        )
        AND PLAN_PER.ID_PLAN = Fn_PlanIdDos;
      --
  BEGIN
      --
      --
      IF C_CompararLineProfile%ISOPEN THEN
        CLOSE C_CompararLineProfile;
      END IF;
      --
      --comparar los planes
      Lv_ResulComparar := NULL;
      OPEN C_CompararLineProfile;
      FETCH C_CompararLineProfile INTO Lv_ResulComparar;
      CLOSE C_CompararLineProfile;
      --
      IF Lv_ResulComparar IS NOT NULL AND Lv_ResulComparar = 'SI' THEN
          Lv_Resultado := 'SI';
      END IF;
      --
      RETURN Lv_Resultado;
  EXCEPTION
    WHEN OTHERS THEN
        Lv_MsjResultado := 'Ocurri� un error al comparar los planes de las promociones de ancho de banda.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                            'CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW',
                                            SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                            Lv_User,
                                            SYSDATE,
                                            Lv_Ip);
        RETURN Lv_Resultado;
  END F_COMPARAR_PLAN_PROMO_BW;
----
  FUNCTION F_GET_LINE_PROFILE_PROMO_BW(Fn_PlanId IN NUMBER)
  RETURN VARCHAR2
  IS
      Lv_Resultado             VARCHAR2(45) := '';
      Lv_CaractLineProfile     VARCHAR2(40) := 'LINE-PROFILE-NAME';
      Lv_Estado                VARCHAR2(20) := 'Activo';
      Lv_EstadoInactivo        VARCHAR2(20) := 'Inactivo';
      Lv_EstadoClonado         VARCHAR2(20) := 'Clonado';
      Lv_CodigoProducto        VARCHAR2(5)  := 'INTD';
      Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
      Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
      Lv_MsjResultado          VARCHAR2(4000);
      --
      CURSOR C_ObtenerLineProfile
      IS
        SELECT CAR.VALOR
        FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR
          INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE ON PDE.ID_ITEM = CAR.PLAN_DET_ID
          INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PCA ON PCA.ID_PLAN = PDE.PLAN_ID
          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC ON PC.ID_PRODUCTO_CARACTERISITICA = CAR.PRODUCTO_CARACTERISITICA_ID
          INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C ON C.ID_CARACTERISTICA = PC.CARACTERISTICA_ID
          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = PDE.PRODUCTO_ID
          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P ON P.ID_PRODUCTO = PC.PRODUCTO_ID
        WHERE PCA.ID_PLAN = Fn_PlanId
          AND C.DESCRIPCION_CARACTERISTICA = Lv_CaractLineProfile
          AND P.CODIGO_PRODUCTO = Lv_CodigoProducto
          AND PRO.CODIGO_PRODUCTO = Lv_CodigoProducto
          AND PCA.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
          AND PDE.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado)
          AND CAR.ESTADO IN (Lv_Estado,Lv_EstadoInactivo,Lv_EstadoClonado);
      --
  BEGIN
      --
      --
      IF C_ObtenerLineProfile%ISOPEN THEN
        CLOSE C_ObtenerLineProfile;
      END IF;
      --
      --obtener line profile
      OPEN C_ObtenerLineProfile;
      FETCH C_ObtenerLineProfile INTO Lv_Resultado;
      CLOSE C_ObtenerLineProfile;
      --
      RETURN Lv_Resultado;
  EXCEPTION
    WHEN OTHERS THEN
        Lv_MsjResultado := 'Ocurri� un error al obtener el line profile del plan.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                            'CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW',
                                            SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                            Lv_User,
                                            SYSDATE,
                                            Lv_Ip);
        RETURN NULL;
  END F_GET_LINE_PROFILE_PROMO_BW;
  --

  PROCEDURE P_INSERT_INFO_EVALUA_TENTATIVA(Pr_InfoEvaluaTentativa IN DB_COMERCIAL.INFO_EVALUA_TENTATIVA%ROWTYPE,
                                           Pv_MsjResultado        OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_COMERCIAL.INFO_EVALUA_TENTATIVA
    (ID_TENTATIVA,
     PUNTO_ID,
     SERVICIO_ID,
     GRUPO_PROMOCION_ID,
     TIPO_PROMOCION_ID,
     TIPO_PROMOCION,
     CODIGO_GRUPO_PROMOCION,
     DESCUENTO,
     CANTIDAD_PERIODOS,
     OBSERVACION,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     EMPRESA_COD,     
     ESTADO )
    VALUES
    (Pr_InfoEvaluaTentativa.ID_TENTATIVA,
     Pr_InfoEvaluaTentativa.PUNTO_ID,
     Pr_InfoEvaluaTentativa.SERVICIO_ID,
     Pr_InfoEvaluaTentativa.GRUPO_PROMOCION_ID,
     Pr_InfoEvaluaTentativa.TIPO_PROMOCION_ID,
     Pr_InfoEvaluaTentativa.TIPO_PROMOCION,
     Pr_InfoEvaluaTentativa.CODIGO_GRUPO_PROMOCION,
     Pr_InfoEvaluaTentativa.DESCUENTO,
     Pr_InfoEvaluaTentativa.CANTIDAD_PERIODOS,
     Pr_InfoEvaluaTentativa.OBSERVACION,
     Pr_InfoEvaluaTentativa.FE_CREACION,
     Pr_InfoEvaluaTentativa.USR_CREACION,
     Pr_InfoEvaluaTentativa.IP_CREACION,
     Pr_InfoEvaluaTentativa.FE_ULT_MOD,
     Pr_InfoEvaluaTentativa.USR_ULT_MOD,
     Pr_InfoEvaluaTentativa.IP_ULT_MOD,
     Pr_InfoEvaluaTentativa.EMPRESA_COD,
     Pr_InfoEvaluaTentativa.ESTADO
    );
  EXCEPTION
  WHEN OTHERS THEN    
    Pv_MsjResultado := 'Error en P_INSERT_INFO_EVALUA_TENTATIVA - ' || SQLERRM;

  END P_INSERT_INFO_EVALUA_TENTATIVA; 
  --

  FUNCTION F_VALIDA_TENTATIVA(Fn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Fv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
  RETURN VARCHAR2
  IS
  --
    CURSOR C_GetServTentativa(Cn_IdServicio        DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_CodEmpresa        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Cv_CodGrupoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                              Cv_NombreParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                              Cv_Estado            DB_COMERCIAL.INFO_EVALUA_TENTATIVA.ESTADO%TYPE)
    IS
      SELECT COUNT(ID_TENTATIVA) 
      FROM DB_COMERCIAL.INFO_EVALUA_TENTATIVA  
      WHERE SERVICIO_ID  IN (Cn_IdServicio) 
      AND EMPRESA_COD    =  Cv_CodEmpresa
      AND TIPO_PROMOCION IN (SELECT DET.VALOR2 
                             FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                               DB_GENERAL.ADMI_PARAMETRO_DET DET
                             WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                               AND CAB.ESTADO           = Cv_Estado
                               AND DET.PARAMETRO_ID     = CAB.ID_PARAMETRO
                               AND DET.VALOR3           = Cv_CodGrupoPromocion
                              AND DET.ESTADO            = Cv_Estado
                               AND DET.EMPRESA_COD      = Cv_CodEmpresa)
      AND ESTADO         =  Cv_Estado;

    CURSOR C_GetServHistorial(Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_UsrCreacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE)
    IS
      SELECT COUNT(ID_SERVICIO_HISTORIAL) 
      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  
      WHERE SERVICIO_ID IN (Cn_IdServicio)
      AND USR_CREACION  IN (Cv_UsrCreacion);   

    Lv_Aplica          VARCHAR2(1)  := 'N';
    Lv_EstadoActivo    VARCHAR2(15) := 'Activo';
    Lv_IpCreacion      VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_NombreParametro VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Ln_Valor           NUMBER;
    Lv_UsrCreacion    VARCHAR2(50); 

  BEGIN
  --
    IF C_GetServTentativa%ISOPEN THEN
      CLOSE C_GetServTentativa;
    END IF;

    IF C_GetServHistorial%ISOPEN THEN
        CLOSE C_GetServHistorial;
    END IF;
    --

    IF Fv_CodigoGrupoPromocion = 'PROM_INS' THEN 
        Lv_UsrCreacion   := 'telcos_prom_inst';
    ELSE
        Lv_UsrCreacion   := 'telcos_prom_mens';
    END IF;

    OPEN C_GetServTentativa(Fn_IdServicio,Fv_CodEmpresa,Fv_CodigoGrupoPromocion,Lv_NombreParametro,Lv_EstadoActivo);
    FETCH C_GetServTentativa INTO Ln_Valor;
    CLOSE C_GetServTentativa;

    IF Ln_Valor > 0 THEN 
        Lv_Aplica := 'S';
    END IF;

    --Si no encontr� registro en la tabla INFO_EVALUA_TENTATIVA, se busca en INFO_SERVICIO_HISTORIAL. 
    IF Lv_Aplica = 'N' THEN 
        Ln_Valor := 0;

        OPEN C_GetServHistorial(Fn_IdServicio,Lv_UsrCreacion);
        FETCH C_GetServHistorial INTO Ln_Valor;
        CLOSE C_GetServHistorial;

        IF Ln_Valor > 0 THEN 
            Lv_Aplica := 'S';
        END IF;

    END IF;

  RETURN Lv_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_TENTATIVA', 
                                         'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
   RETURN Lv_Aplica;                                      

  END F_VALIDA_TENTATIVA;  
  --

  FUNCTION F_GET_FECHA_ADENDUM(Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Fa_ServiciosProcesar IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar)
  RETURN DATE
  IS
  --    
    Lv_IpCreacion      VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo    VARCHAR2(16) := 'Activo';
    Lv_IdServicios     VARCHAR2(500);
    Lv_Consulta        VARCHAR2(5000);
    Lrf_FechaAdendum   SYS_REFCURSOR;
    Ld_FechaEvalua     DATE;
    Ln_Index           NUMBER;
    Le_ExceptionFecha  EXCEPTION;

  BEGIN
  --
    Ln_Index := Fa_ServiciosProcesar.FIRST; 

    WHILE (Ln_Index IS NOT NULL)       
    LOOP
        Lv_IdServicios := Lv_IdServicios || Fa_ServiciosProcesar(Ln_Index).ID_SERVICIO||',';
        Ln_Index       := Fa_ServiciosProcesar.NEXT(Ln_Index);
    END LOOP;

    Lv_IdServicios := RTRIM(Lv_IdServicios, ',' );

    IF Lv_IdServicios IS NULL THEN
        RAISE Le_ExceptionFecha;
    END IF;

    Lv_Consulta := 'SELECT TRUNC(MIN(DBIA.FE_CREACION)) AS FE_EVALUA_VIGENCIA
                    FROM DB_COMERCIAL.INFO_ADENDUM DBIA
                    WHERE DBIA.SERVICIO_ID IN ('||Lv_IdServicios||' )
                    AND DBIA.ESTADO IN (SELECT APD.VALOR1 
                                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                        DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                        AND APD.ESTADO             = '''||Lv_EstadoActivo||'''
                                        AND APC.NOMBRE_PARAMETRO   = ''PROM_ESTADOS_ADENDUM''
                                        AND APC.ESTADO             = '''||Lv_EstadoActivo||'''
                                        AND APD.EMPRESA_COD        = '''||Fv_CodEmpresa||''') ';                                      

    OPEN Lrf_FechaAdendum FOR Lv_Consulta;
    FETCH Lrf_FechaAdendum INTO Ld_FechaEvalua;
    CLOSE Lrf_FechaAdendum;

  RETURN Ld_FechaEvalua;

  EXCEPTION
  WHEN Le_ExceptionFecha THEN
    RETURN Ld_FechaEvalua;

  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_GET_FECHA_ADENDUM', 
                                         'ERROR_STACK: '||DBMS_UTILITY.FORMAT_ERROR_STACK||' ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
   RETURN Ld_FechaEvalua;                                      

  END F_GET_FECHA_ADENDUM;  
  --

  FUNCTION F_VALIDA_SERVICIO_PLAN_INTD(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2
  IS
  --
    CURSOR C_GetServPlanIntd(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                             Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ISE.ID_SERVICIO  
      FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_SERVICIO ISE,
        DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_PLAN_DET IPD
      WHERE IPC.ID_PLAN        = IPD.PLAN_ID
        AND ISE.PLAN_ID        = IPC.ID_PLAN 
        AND AP.ID_PRODUCTO     = IPD.PRODUCTO_ID
        AND AP.CODIGO_PRODUCTO = 'INTD'
        AND AP.EMPRESA_COD     = Cv_CodEmpresa 
        AND ISE.ID_SERVICIO    = Cn_IdServicio;

    Lv_Aplica      VARCHAR2(1)  := 'N';
    Lv_IpCreacion  VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_IdServicio  NUMBER;

  BEGIN
  --
    IF C_GetServPlanIntd%ISOPEN THEN
      CLOSE C_GetServPlanIntd;
    END IF;

    OPEN C_GetServPlanIntd(Fn_IdServicio, Fv_CodEmpresa);
    FETCH C_GetServPlanIntd INTO Ln_IdServicio;
    CLOSE C_GetServPlanIntd;

    IF Ln_IdServicio IS NOT NULL THEN 
        Lv_Aplica := 'S';
    END IF;

  RETURN Lv_Aplica;

  EXCEPTION
  WHEN OTHERS THEN
    Lv_Aplica := 'N';

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_VALIDA_SERVICIO_PLAN_INTD', 
                                         'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
   RETURN Lv_Aplica;                                      

  END F_VALIDA_SERVICIO_PLAN_INTD;  
  --

  PROCEDURE P_PROMOCION_TENTATIVA(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                  Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                  Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_CodMensaje           OUT VARCHAR2,
                                  Pv_Status               OUT VARCHAR2,
                                  Pv_Mensaje              OUT VARCHAR2)
  IS 

    Lv_Status            VARCHAR2(100);
    Lv_Mensaje           VARCHAR2(4000);
    Lv_CodMensaje        VARCHAR2(100);
    Lv_EsCodigo          VARCHAR2(1);
    Lv_MsjResultado      VARCHAR2(4000);
    Lv_IpCreacion        VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    La_ServiciosProcesar DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;

  BEGIN  
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
    'Empieza el proceso de evaluaci�n de promociones tentativa para el idPunto: '||Pn_IdPunto,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    Lv_EsCodigo := 'S';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
    'Consumo del proceso P_PROMOCION_EVALUA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
    || ' - Lv_EsCodigo: ' || Lv_EsCodigo,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA(Pn_IdPunto              => Pn_IdPunto,
                                                                    Pv_CodigoGrupoPromocion => TRIM(Pv_CodigoGrupoPromocion),
                                                                    Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                    Pv_EsCodigo             => Lv_EsCodigo,
                                                                    Pv_CodMensaje           => Lv_CodMensaje,
                                                                    Pv_Status               => Lv_Status,
                                                                    Pv_Mensaje              => Lv_Mensaje);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
    'Despues del consumo del proceso P_PROMOCION_EVALUA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
    || ' - Lv_EsCodigo: ' || Lv_EsCodigo,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    La_ServiciosProcesar.DELETE();

    --Se valida si existe servicios a procesar para llamar al proceso por c�digo 'N'.
    Lv_EsCodigo := 'N';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
    'Consumo del proceso P_OBTIENE_SERVICIOS_PUNTO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
    || ' - Lv_EsCodigo: ' || Lv_EsCodigo,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto              => Pn_IdPunto,
                                                                 Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                 Pv_EsCodigo             => Lv_EsCodigo,
                                                                 Pv_TipoProceso          => 'PROM_EVAL_TENTATIVA',
                                                                 Pv_CodigoGrupoPromocion => TRIM(Pv_CodigoGrupoPromocion),
                                                                 Pa_ServiciosProcesar    => La_ServiciosProcesar);

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
    'Despues del consumo del proceso P_OBTIENE_SERVICIOS_PUNTO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
    || ' - Lv_EsCodigo: ' || Lv_EsCodigo,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    IF La_ServiciosProcesar.COUNT > 0 THEN
    --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
      'Consumo del proceso P_PROMOCION_EVALUA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
      || ' - Lv_EsCodigo: ' || Lv_EsCodigo,
      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
      --
      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA(Pn_IdPunto              => Pn_IdPunto,
                                                                      Pv_CodigoGrupoPromocion => TRIM(Pv_CodigoGrupoPromocion),
                                                                      Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                      Pv_EsCodigo             => Lv_EsCodigo,
                                                                      Pv_CodMensaje           => Lv_CodMensaje,
                                                                      Pv_Status               => Lv_Status,
                                                                      Pv_Mensaje              => Lv_Mensaje);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
      'Despues del consumo del proceso P_PROMOCION_EVALUA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
      || ' - Lv_EsCodigo: ' || Lv_EsCodigo,
      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    END IF;                                                                    

    Pv_Status     := Lv_Status;
    Pv_Mensaje    := Lv_Mensaje;
    Pv_CodMensaje := Lv_CodMensaje;

  EXCEPTION 
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de evaluaci�n de Promociones para el Grupo de Promocional: '||
                        Pv_CodigoGrupoPromocion||', punto_Id - '|| Pn_IdPunto || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_PROMOCION_TENTATIVA', 
                                         Lv_MsjResultado, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

  END P_PROMOCION_TENTATIVA;
  --

  PROCEDURE P_PROMOCION_EVALUA_TENTATIVA(Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                         Pv_CodMensaje           OUT VARCHAR2,
                                         Pv_Status               OUT VARCHAR2,
                                         Pv_Mensaje              OUT VARCHAR2)
  IS 

    --Costo: 1
    CURSOR C_GetEmpresa IS
      SELECT IEG.COD_EMPRESA
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE IEG.COD_EMPRESA = Pv_CodEmpresa;

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
    CURSOR C_PeriodoDesc(Cv_Trama  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
                         Cv_Orden  NUMBER) IS       
      SELECT COUNT(T2.PERIODO) AS PERIODO, 
        T2.DESCUENTO 
      FROM ( SELECT SUBSTR(T.VALOR,1,INSTR(T.VALOR,'|',1)-1) AS PERIODO, 
               SUBSTR(T.VALOR,INSTR(T.VALOR,'|',1)+1) AS DESCUENTO 
             FROM (SELECT REGEXP_SUBSTR(Cv_Trama,'[^,]+', 1, LEVEL) AS VALOR
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(Cv_Trama, '[^,]+', 1, LEVEL) IS NOT NULL) T) T2
      GROUP BY T2.DESCUENTO
      ORDER BY Cv_Orden DESC;

    --Costo: 6
    CURSOR C_GetFeCreaAdendum(Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cv_EstadoActivo DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                              Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT TRUNC(MIN(DBIA.FE_CREACION)) AS FE_EVALUA_VIGENCIA
      FROM DB_COMERCIAL.INFO_ADENDUM DBIA
      WHERE DBIA.SERVICIO_ID = Cn_IdServicio
      AND DBIA.ESTADO     IN (SELECT APD.VALOR1 
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                DB_GENERAL.ADMI_PARAMETRO_DET APD
                              WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                              AND APD.ESTADO             = Cv_EstadoActivo
                              AND APC.NOMBRE_PARAMETRO   = 'PROM_ESTADOS_ADENDUM'
                              AND APC.ESTADO             = Cv_EstadoActivo
                              AND APD.EMPRESA_COD        = Cv_CodEmpresa);

    --Costo: 6
    CURSOR C_GetNombrePlan(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IPC.NOMBRE_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE ISER.ID_SERVICIO = Cn_IdServicio
      AND IPC.ID_PLAN        = ISER.PLAN_ID;

    --Costo: 11
    CURSOR C_GetPersonaEmpresaRol (Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT IP.PERSONA_EMPRESA_ROL_ID
      FROM DB_COMERCIAL.INFO_PUNTO IP
      WHERE IP.ID_PUNTO = Cn_PuntoId;

    --Costo: 3      
    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion     VARCHAR2,
                        Cv_EstadoActivo    VARCHAR2,
                        Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS      
      SELECT DET.VALOR1,
        DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Cv_EstadoActivo
      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      AND DET.DESCRIPCION        = Cv_Descripcion
      AND DET.ESTADO             = Cv_EstadoActivo
      AND DET.EMPRESA_COD        = Cv_CodEmpresa;

    --Costo:20
    CURSOR C_GetIdPromocionMens(Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_CodigoGrupoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                Cv_Caracteristica       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
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
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA ATPR,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP
      WHERE ISC.SERVICIO_ID                 = Cn_IdServicio
      AND ISC.ESTADO                        = Cv_EstadoActivo
      AND DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Cn_IdServicio,Cv_CodigoGrupoPromocion,Cv_CodEmpresa) = 'S'      
      AND DBAC.ID_CARACTERISTICA            = ISC.CARACTERISTICA_ID
      AND DBAC.DESCRIPCION_CARACTERISTICA   = Cv_Caracteristica
      AND ATP.ID_TIPO_PROMOCION             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(TRIM(ISC.VALOR),'^\d+')),0)
      AND ATP.ESTADO                        IN (Cv_EstadoActivo,Cv_EstadoInactivo)
      AND AGP.ID_GRUPO_PROMOCION            = ATP.GRUPO_PROMOCION_ID
      AND AGP.EMPRESA_COD                   = Cv_CodEmpresa
      AND AGP.ESTADO                        IN (Cv_EstadoActivo,Cv_EstadoInactivo)
      AND ATPR.GRUPO_PROMOCION_ID           = AGP.ID_GRUPO_PROMOCION
      AND ATPR.ESTADO                       IN (Cv_EstadoActivo,Cv_EstadoInactivo)
      AND ATPR.CARACTERISTICA_ID            IN (SELECT CARAC.ID_CARACTERISTICA
                                                FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARAC
                                                WHERE CARAC.DESCRIPCION_CARACTERISTICA = 'PROM_CODIGO');

    --Costo:20
    CURSOR C_GetIdPromocionIns(Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                               Cv_CodigoGrupoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                               Cv_Caracteristica       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                               Cv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Cv_EstadoActivo         DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE,
                               Cv_EstadoInactivo       DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE) IS    
      SELECT DISTINCT AGP.ID_GRUPO_PROMOCION, ATP.ID_TIPO_PROMOCION, DBAC.ID_CARACTERISTICA, ATPR.VALOR AS CODIGO_PROMOCION
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR
      WHERE ISC.SERVICIO_ID                 = Cn_IdServicio
      AND ISC.ESTADO                        = Cv_EstadoActivo
      AND DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Cn_IdServicio,Cv_CodigoGrupoPromocion,Cv_CodEmpresa) = 'S'
      AND DBAC.ID_CARACTERISTICA            = ISC.CARACTERISTICA_ID
      AND DBAC.DESCRIPCION_CARACTERISTICA   = Cv_Caracteristica
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

    --Costo: 3      
    CURSOR C_ObtieneMsjPorCodigo(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                 Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                 Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                 Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
    IS 
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APD.DESCRIPCION      = Cv_Descripcion
        AND APC.ESTADO           = Cv_Estado
        AND APD.ESTADO           = Cv_Estado
        AND APD.EMPRESA_COD      = Cv_EmpresaCod
        AND APD.VALOR1           = Cv_Valor1;

    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado               VARCHAR2(2000);
    Lv_Observacion                VARCHAR2(3200);
    Lv_ObservacionDesc            VARCHAR2(3200);
    Lv_DescTipoPromocion          VARCHAR2(1000);
    Lv_ObservacionIsnt            VARCHAR2(3200);
    Lv_AplicaProceso              VARCHAR2(3200);
    Lv_AplicaProceso2             VARCHAR2(3200);
    Lv_TieneSolicitud             VARCHAR2(1);
    Lv_NombreParametroTentativa   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_TENTATIVA_MENSAJES';
    Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Lv_EstadoInactivo             DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE := 'Inactivo';
    Lv_Descuento                  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE;
    Lv_Caracteristica             DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;
    Ln_IndGpro                    NUMBER;
    Ln_PorcentajeDescuento        NUMBER;
    Ln_PorcentajeInst             NUMBER;
    Ln_PersonaEmpRolId            DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE;
    Ln_IdTipoPromocion            DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    Ln_IdPromocion                DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Lb_OtorgoPromoCliente         BOOLEAN;
    Lb_CumpleFormPag              BOOLEAN;
    Lb_CumpleUltMilla             BOOLEAN;
    Lb_CumpleTipoNeg              BOOLEAN;
    Lb_CumplePlaProd              BOOLEAN;
    Lb_PlanConRestriccion         BOOLEAN;
    Lb_AplicaRol                  BOOLEAN;
    Ld_FechaEvalua                DATE;
    Lr_TiposPromociones           DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar;
    Lr_TipoPromoRegla             DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    La_TipoPromoPlanProdProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar;
    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_TiposPromocionesProcesar   DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar;
    La_GruposPromocionesProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_GruposPromocionesProcesar;
    Lc_Parametros                 C_Parametros%ROWTYPE;
    Lc_GetPersonaEmpresaRol       C_GetPersonaEmpresaRol%ROWTYPE;
    Lc_GetNombrePlan              C_GetNombrePlan%ROWTYPE;
    Lc_Datos                      C_Datos%ROWTYPE;
    Lc_PeriodoDesc                C_PeriodoDesc%ROWTYPE;
    Lc_GetIdPromocion             C_GetIdPromocionMens%ROWTYPE;
    Lrf_TiposPromociones          SYS_REFCURSOR;
    Le_ExceptionProceso           EXCEPTION;
    Le_ExceptionServicios         EXCEPTION;
    Le_Exception                  EXCEPTION;
    Lv_MsjExceptionServicios      VARCHAR2(4000); 
    Lv_MsjException               VARCHAR2(4000); 
    Lv_CodMensaje                 VARCHAR2(500);
    Lv_Periodo                    VARCHAR2(100);
    Lv_DescripcionObserv          VARCHAR2(4000); 
    Lv_UsrCreacion                VARCHAR2(50);
    Ln_Index                      NUMBER;
    Ln_IdServicio                 NUMBER;
    Lv_NombreParamCab             VARCHAR2(500) := 'PARAM_EVALUA_TENTATIVA';
    Lv_EstadoActivo               VARCHAR2(50)  := 'Activo';
    Lv_DescripDetCodMsj           VARCHAR2(500) := 'CODIGO_MENSAJE';
    La_Servicios                  DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    Lr_InfoEvaluaTentativa        DB_COMERCIAL.INFO_EVALUA_TENTATIVA%ROWTYPE;
    Lc_Mensaje                    C_ObtieneMsjPorCodigo%ROWTYPE;
    Ln_IndexIns                   NUMBER := 1; 
    Ln_ServiciosCumplePromo       NUMBER; 
    Ln_IdServicioCumple           NUMBER; 
    Ln_IdPlanServicio             NUMBER; 
    Ln_IdProdServicio             NUMBER;
    Ln_IdPlanSupServicio          NUMBER;
    Lv_TieneTentativa             VARCHAR2(1);
    Lv_EstadoServicio             VARCHAR2(50);
    Ln_IdServicioEval             NUMBER;

  BEGIN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'Inicia la evaluacion del proceso P_PROMOCION_EVALUA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    IF TRIM(Pv_CodigoGrupoPromocion) NOT IN ('PROM_INS','PROM_MENS') THEN
      Lv_CodMensaje := 'COD_GRUPOS_PROM';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
      'Error en COD_GRUPOS_PROM para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
      --
      RAISE Le_ExceptionProceso;
    END IF;

    IF Lrf_TiposPromociones%ISOPEN THEN
      CLOSE Lrf_TiposPromociones;
    END IF;

    IF C_ObtieneMsjPorCodigo%ISOPEN THEN
      CLOSE C_ObtieneMsjPorCodigo;
    END IF;

    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;

    OPEN C_GetEmpresa;
    FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;  

    IF Lv_CodEmpresa IS NULL THEN
      Lv_CodMensaje := 'COD_EMPRESA';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
      'Error en COD_EMPRESA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
      --
      RAISE Le_ExceptionProceso;
    END IF;

    Lb_AplicaRol := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ROL(Fn_IdPunto    => Pn_IdPunto,
                                                                    Fv_CodEmpresa => Pv_CodEmpresa);

    IF NOT Lb_AplicaRol THEN
      Lv_CodMensaje := 'COD_ROL';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
      'Error en COD_ROL para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
      --
      RAISE Le_ExceptionProceso;
    END IF;

    IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN 
        Lv_UsrCreacion       := 'telcos_prom_inst';
        Lv_DescTipoPromocion := 'Instalaci�n';

        IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN
            Lv_Caracteristica := 'PROM_COD_INST';
        END IF;

    ELSE
        Lv_UsrCreacion       := 'telcos_prom_mens';
        Lv_DescTipoPromocion := 'Mensualidad';

        IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN
            Lv_Caracteristica := 'PROM_COD_NUEVO';
        END IF;

    END IF;

    La_ServiciosProcesar.DELETE();
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'Antes del cosnumo del proceso P_OBTIENE_SERVICIOS_PUNTO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
    || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa || ' - Lv_Caracteristica: ' || Lv_Caracteristica,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto              => Pn_IdPunto,
                                                                 Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                 Pv_EsCodigo             => Pv_EsCodigo,
                                                                 Pv_TipoProceso          => 'PROM_EVAL_TENTATIVA',
                                                                 Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                 Pv_CaractCodProm        => Lv_Caracteristica,
                                                                 Pa_ServiciosProcesar    => La_ServiciosProcesar);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'Despues del cosnumo del proceso P_OBTIENE_SERVICIOS_PUNTO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    IF La_ServiciosProcesar.COUNT = 0 THEN
      Lv_CodMensaje := 'COD_SIN_SERVICIOS';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
      'Error en COD_SIN_SERVICIOS para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
      --
      RAISE Le_ExceptionProceso; 
    END IF;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'Antes del cosnumo del proceso F_GET_FECHA_ADENDUM para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    --Se obtiene la fecha de vigencia.
    Ld_FechaEvalua := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_FECHA_ADENDUM(Fn_IdPunto           => Pn_IdPunto,
                                                                             Fv_CodEmpresa        => Pv_CodEmpresa,
                                                                             Fa_ServiciosProcesar => La_ServiciosProcesar);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'Despues del cosnumo del proceso F_GET_FECHA_ADENDUM para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
    || ' - Ld_FechaEvalua: ' || Ld_FechaEvalua,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
    IF Ld_FechaEvalua IS NULL THEN
        Ld_FechaEvalua := SYSDATE;
    END IF;

    Ln_Index := La_ServiciosProcesar.FIRST; 

    WHILE (Ln_Index IS NOT NULL) 
    LOOP
        BEGIN
            Ln_IdServicio        := La_ServiciosProcesar(Ln_Index).ID_SERVICIO;
            Ln_IdPlanServicio    := La_ServiciosProcesar(Ln_Index).ID_PLAN; 
            Ln_IdProdServicio    := La_ServiciosProcesar(Ln_Index).ID_PRODUCTO;
            Ln_IdPlanSupServicio := La_ServiciosProcesar(Ln_Index).PLAN_ID_SUPERIOR;
            Lv_EstadoServicio    := La_ServiciosProcesar(Ln_Index).ESTADO;

            Ln_Index           := La_ServiciosProcesar.NEXT(Ln_Index);
            Lc_GetIdPromocion  := NULL;
            Ln_IndGpro         := NULL;
            Lv_CodMensaje      := '';
            Lv_TieneTentativa  := ''; 
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'Antes del cosnumo del proceso F_VALIDA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
            || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
            --Verifica si el servicio a procesar tiene tentativa, caso contrario avanza al siguiente. 
            Lv_TieneTentativa := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TENTATIVA(Fn_IdServicio           => Ln_IdServicio,
                                                                                       Fv_CodEmpresa           => Pv_CodEmpresa,
                                                                                       Fv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion);
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'Despues del cosnumo del proceso F_VALIDA_TENTATIVA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
            || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa || ' - Lv_TieneTentativa: ' || Lv_TieneTentativa,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
            IF Lv_TieneTentativa = 'S' THEN
                CONTINUE;
            END IF;

            IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN 
                IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN 

                    IF C_GetIdPromocionIns%ISOPEN THEN
                        CLOSE C_GetIdPromocionIns;
                    END IF;

                    OPEN C_GetIdPromocionIns(Ln_IdServicio,
                                             Pv_CodigoGrupoPromocion,
                                             Lv_Caracteristica,
                                             Pv_CodEmpresa,
                                             Lv_EstadoActivo,
                                             Lv_EstadoInactivo);
                    FETCH C_GetIdPromocionIns INTO Lc_GetIdPromocion;
                    CLOSE C_GetIdPromocionIns;
                ELSE

                    IF C_GetIdPromocionMens%ISOPEN THEN
                        CLOSE C_GetIdPromocionMens;
                    END IF;

                    OPEN C_GetIdPromocionMens(Ln_IdServicio,
                                              Pv_CodigoGrupoPromocion,
                                              Lv_Caracteristica,
                                              Pv_CodEmpresa,
                                              Lv_EstadoActivo,
                                              Lv_EstadoInactivo);
                    FETCH C_GetIdPromocionMens INTO Lc_GetIdPromocion;
                    CLOSE C_GetIdPromocionMens;
                END IF;

            END IF;

            IF Ln_IdServicio > 0 AND Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN
                Lv_TieneSolicitud := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SOLICITUD_SERVICIO(Ln_IdServicio);
                IF Lv_TieneSolicitud = 'N' THEN
                    Lv_CodMensaje := 'COD_SOLICITUD';
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Error en COD_SOLICITUD para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                    || ' - Ln_IdServicio: ' || Ln_IdServicio,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    RAISE Le_ExceptionServicios;
                END IF;
            END IF;

            --La restricci�n COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST debe ser unicamente invocada en el proceso de tentativa solo por instalaci�n.
            IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN 
                Ln_PorcentajeInst  := NULL;
                Lc_Parametros      := NULL;
                Lc_GetNombrePlan   := NULL;
                Lv_ObservacionIsnt := '';

                IF C_GetNombrePlan%ISOPEN THEN
                    CLOSE C_GetNombrePlan;
                END IF;

                OPEN C_GetNombrePlan(Ln_IdServicio);
                FETCH C_GetNombrePlan INTO Lc_GetNombrePlan;
                CLOSE C_GetNombrePlan;

                IF Lc_GetNombrePlan.NOMBRE_PLAN IS NOT NULL THEN 
                    --Si posee plan con restricci�n debo generar la Solicitud de Facturaci�n con el valor base por FO y con el Descuento obtenido
                    --del parametro RESTRICCION_PLANES_X_INSTALACION
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Antes del cosnumo del proceso P_GET_RESTRIC_PLAN_INST para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                    || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa || ' - Lc_GetNombrePlan.NOMBRE_PLAN: ' 
                    || Lc_GetNombrePlan.NOMBRE_PLAN,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    DB_COMERCIAL.COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           => Lc_GetNombrePlan.NOMBRE_PLAN,
                                                                           Pv_EmpresaCod           => Pv_CodEmpresa,
                                                                           Pb_PlanConRestriccion   => Lb_PlanConRestriccion,
                                                                           Pn_PorcentajeDescuento  => Ln_PorcentajeDescuento,
                                                                           Pv_Observacion          => Lv_ObservacionIsnt);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Despues del cosnumo del proceso P_GET_RESTRIC_PLAN_INST para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                    || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa || ' - Lc_GetNombrePlan.NOMBRE_PLAN: ' 
                    || Lc_GetNombrePlan.NOMBRE_PLAN,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    IF Lb_PlanConRestriccion THEN 
                        Ln_PorcentajeInst := Ln_PorcentajeDescuento;
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'Error en RESTRINCION_PLAN para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                        || ' - Ln_IdServicio: ' || Ln_IdServicio,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        RAISE Le_ExceptionServicios;
                    END IF;
                END IF;

                IF C_GetPersonaEmpresaRol%ISOPEN THEN
                    CLOSE C_GetPersonaEmpresaRol;
                END IF;

                --Se obtiene la persona Empresa rol para verificar si es cliente canal
                Lc_GetPersonaEmpresaRol := NULL;
                OPEN  C_GetPersonaEmpresaRol(Cn_PuntoId => Pn_IdPunto);
                FETCH C_GetPersonaEmpresaRol INTO Lc_GetPersonaEmpresaRol;
                CLOSE C_GetPersonaEmpresaRol;

                IF Lc_GetPersonaEmpresaRol.PERSONA_EMPRESA_ROL_ID IS NOT NULL AND Lc_GetPersonaEmpresaRol.PERSONA_EMPRESA_ROL_ID > 0 THEN
                    --Se verifica que el cliente no sea Canal
                    Ln_PersonaEmpRolId := Lc_GetPersonaEmpresaRol.PERSONA_EMPRESA_ROL_ID;
                    IF DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DESCRIPCION_ROL(Pn_PersonaEmpRolId => Ln_PersonaEmpRolId) = 'Cliente Canal' THEN
                        IF C_Parametros%ISOPEN THEN
                            CLOSE C_Parametros;
                        END IF;

                        OPEN  C_Parametros(Lv_NombreParametroTentativa,'CLIENTE_CANAL',Lv_EstadoActivo,Pv_CodEmpresa);
                        FETCH C_Parametros INTO Lc_Parametros;
                        CLOSE C_Parametros;

                        Lv_ObservacionIsnt := Lc_Parametros.VALOR1;
                        Ln_PorcentajeInst  := Lc_Parametros.VALOR2;
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'Error en CLIENTE_CANAL para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                        || ' - Ln_IdServicio: ' || Ln_IdServicio,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        RAISE Le_ExceptionServicios;
                    END IF;
                END IF; --FIN Lc_GetPersonaEmpresaRol.PERSONA_EMPRESA_ROL_ID IS NOT NULL

                --Verifica Origen del Punto, si es migraci�n de Tecnolog�a no aplica al proceso de generar Fact de Instalaci�n
                Lv_AplicaProceso := DB_COMERCIAL.COMEK_CONSULTAS.F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod => Pv_CodEmpresa,
                                                                                                Pn_PuntoId    => Pn_IdPunto);
                IF Lv_AplicaProceso = 'N' THEN
                    IF C_Parametros%ISOPEN THEN
                      CLOSE C_Parametros;
                    END IF;

                    OPEN  C_Parametros(Lv_NombreParametroTentativa,'MIGRACION_TECNOLOGIA',Lv_EstadoActivo,Pv_CodEmpresa);
                    FETCH C_Parametros INTO Lc_Parametros;
                    CLOSE C_Parametros;

                    Lv_ObservacionIsnt := Lc_Parametros.VALOR1;
                    Ln_PorcentajeInst  := Lc_Parametros.VALOR2;
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Error en MIGRACION_TECNOLOGIA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                    || ' - Ln_IdServicio: ' || Ln_IdServicio,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    RAISE Le_ExceptionServicios;
                END IF;

                --Verifica Si existe Factura de Instalaci�n POR_CONTRATO_DIGITAL o POR_CONTRATO_FISICO, en estado Pendiente, Activo
                --o Cerrado y que no haya sido aplicada una NC por el valor total de la Factura.
                Lv_AplicaProceso2 := DB_FINANCIERO.FNCK_CONSULTS.F_APLICA_CREAR_FACT_INST (Pn_PuntoId => Pn_IdPunto);

                IF Lv_AplicaProceso2 = 'N' THEN
                    IF C_Parametros%ISOPEN THEN
                        CLOSE C_Parametros;
                    END IF;

                    OPEN  C_Parametros(Lv_NombreParametroTentativa,'EXISTE_FACTURA',Lv_EstadoActivo,Pv_CodEmpresa);
                    FETCH C_Parametros INTO Lc_Parametros;
                    CLOSE C_Parametros;

                    Lv_ObservacionIsnt := Lc_Parametros.VALOR1; 
                    Ln_PorcentajeInst  := Lc_Parametros.VALOR2;
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Error en EXISTE_FACTURA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                    || ' - Ln_IdServicio: ' || Ln_IdServicio,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    RAISE Le_ExceptionServicios;
                END IF;

            END IF;

            Lb_OtorgoPromoCliente := FALSE;

            La_TiposPromocionesProcesar.DELETE();
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'Antes del cosnumo del proceso P_GET_PROMOCIONES_SECT para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
            || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa || ' - Ld_FechaEvalua: ' || Ld_FechaEvalua,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
            DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_PROMOCIONES_SECT(Pd_FeEvaluaVigencia     => Ld_FechaEvalua,
                                                                 Pn_IdPunto              => Pn_IdPunto,
                                                                 Pn_IdPromocion          => Lc_GetIdPromocion.ID_GRUPO_PROMOCION,
                                                                 Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                 Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                 Pv_TipoProceso          => 'NUEVO',
                                                                 Pv_TipoEvaluacion       => 'PROM_TENTATIVA',
                                                                 Pa_PromocionesPrioridad => La_GruposPromocionesProcesar,
                                                                 Pa_TiposPromoPrioridad  => La_TiposPromocionesProcesar);
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'Despues del cosnumo del proceso P_GET_PROMOCIONES_SECT para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
            || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa || ' - Ld_FechaEvalua: ' || Ld_FechaEvalua,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
            IF La_TiposPromocionesProcesar.COUNT = 0 THEN
                Lv_CodMensaje := 'COD_PROM_GRUPOS';
                Ln_PorcentajeInst  := Lc_Parametros.VALOR2;
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                'Error en COD_PROM_GRUPOS para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                || ' - Ln_IdServicio: ' || Ln_IdServicio,
                'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                --
                RAISE Le_ExceptionServicios;
            END IF;

            La_TipoPromoPlanProdProcesar.DELETE();

            Ln_IndGpro := La_TiposPromocionesProcesar.FIRST;  
            WHILE (Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente) 
            LOOP
                BEGIN
                    Lr_TiposPromociones          := La_TiposPromocionesProcesar(Ln_IndGpro);
                    Ln_IndGpro                   := La_TiposPromocionesProcesar.NEXT(Ln_IndGpro);
                    La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Lr_TiposPromociones.ID_TIPO_PROMOCION); 
                    La_ServiciosCumplePromo.DELETE();
                    La_Servicios.DELETE();

                    Lb_CumplePlaProd := FALSE;
                    Ln_IdServicioEval := NULL;

                    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN 

                        IF Lr_TiposPromociones.CODIGO_TIPO_PROMOCION != 'PROM_MIX' THEN
                            Ln_IdServicioEval := Ln_IdServicio;
                        ELSE 
                            Ln_IdServicioEval := NULL;                                         
                        END IF;
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'Antes del cosnumo del proceso P_OBTIENE_SERVICIOS_PUNTO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                        || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioEval: ' || Ln_IdServicioEval || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                        || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                        || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION || ' - Ln_IdServicio: ' || Ln_IdServicio,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_OBTIENE_SERVICIOS_PUNTO(Pn_IdPunto              => Pn_IdPunto,
                                                                                     Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                                     Pv_EsCodigo             => Pv_EsCodigo,
                                                                                     Pv_TipoProceso          => 'PROM_EVAL_TENTATIVA',
                                                                                     Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion,
                                                                                     Pv_CaractCodProm        => Lv_Caracteristica,
                                                                                     Pn_IdServicio           => Ln_IdServicioEval,
                                                                                     Pa_ServiciosProcesar    => La_Servicios);
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'Antes del cosnumo del proceso P_GET_SERV_PROMO_PLAN_PROD para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                        || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioEval: ' || Ln_IdServicioEval || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                        || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                        || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION || ' - Ln_IdServicio: ' || Ln_IdServicio,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_Servicios, 
                                                                                 Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                                 La_TipoPromoPlanProdProcesar, 
                                                                                 Lb_CumplePlaProd,
                                                                                 La_ServiciosCumplePromo);
                        IF Lb_CumplePlaProd THEN 
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                          'Despues del cosnumo del proceso P_GET_SERV_PROMO_PLAN_PROD para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                          || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioEval: ' || Ln_IdServicioEval || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                          || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                          || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION || ' - Ln_IdServicio: ' || Ln_IdServicio,
                          'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                          --
                        END IF;
                    END IF;

                    Lb_CumpleFormPag := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Fn_IntIdPromocion => Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                               Fn_IdPunto        => Pn_IdPunto);
                    --
                    IF Lb_CumpleFormPag THEN 
                      --
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                      'Despues del cosnumo del proceso F_VALIDA_FORMA_PAGO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                      || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                      || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                      || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION || ' - Ln_IdServicio: ' || Ln_IdServicio,
                      'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                      --
                    END IF;
                    --
                    IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN
                        Lb_CumpleUltMilla := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                                      Ln_IdServicio);
                        --
                        IF Lb_CumpleUltMilla THEN 
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                          'Despues del cosnumo del proceso F_VALIDA_ULTIMA_MILLA para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                          || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                          || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                          || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                          'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                          --
                        END IF;
                        --
                        Lb_CumpleTipoNeg  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion => Lr_TiposPromociones.ID_GRUPO_PROMOCION,
                                                                                                      Fn_IdServicio     => Ln_IdServicio,
                                                                                                      Fv_CodEmpresa     => Pv_CodEmpresa);
                        --
                        IF Lb_CumpleTipoNeg THEN 
                          --
                          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                          'Despues del cosnumo del proceso F_VALIDA_TIPO_NEGOCIO para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                          || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                          || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                          || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                          'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                          --
                        END IF;
                        --
                    END IF;

                    IF Lb_CumpleFormPag AND ((Pv_CodigoGrupoPromocion = 'PROM_MENS' AND Lb_CumplePlaProd) OR (
                        Pv_CodigoGrupoPromocion = 'PROM_INS' AND Lb_CumpleUltMilla AND Lb_CumpleTipoNeg)) AND 
                        ((UPPER(TRIM(Pv_EsCodigo)) = 'N') OR  (UPPER(TRIM(Pv_EsCodigo)) = 'S' AND  
                        Lr_TiposPromociones.ID_TIPO_PROMOCION = Lc_GetIdPromocion.ID_TIPO_PROMOCION))THEN
                            Lb_OtorgoPromoCliente := TRUE;
                            --
                            IF Lb_OtorgoPromoCliente THEN 
                              --
                              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                              'Otorga promocion al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                              || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa 
                              || ' - Pv_EsCodigo: ' || Pv_EsCodigo || ' - Lr_TiposPromociones.CODIGO_TIPO_PROMOCION : ' 
                              || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                              'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                              --
                            END IF;
                            --
                            Ln_IdPromocion        := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
                            Ln_IdTipoPromocion    := Lr_TiposPromociones.ID_TIPO_PROMOCION;
                    END IF;

                    La_TipoPromoPlanProdProcesar.DELETE();
                END;

            END LOOP; --(Ln_IndGpro IS NOT NULL AND NOT Lb_OtorgoPromoCliente)  

            IF C_ObtieneMsjPorCodigo%ISOPEN THEN
                CLOSE C_ObtieneMsjPorCodigo;
            END IF;

            Lv_Observacion     := '';
            Lv_ObservacionDesc := '';

            IF Lb_OtorgoPromoCliente THEN 

                -- Si el c�digo grupo promocional es de instalaci�n (PROM_INS), se almacena el servicio que se est� procesando en la 
                -- variable 'La_ServiciosCumplePromo' para realizar iteraci�n y su registro en la tabla tentativa y de historial
                IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN
                    La_ServiciosCumplePromo(Ln_IndexIns).ID_SERVICIO      := Ln_IdServicio;
                    La_ServiciosCumplePromo(Ln_IndexIns).ID_PUNTO         := Pn_IdPunto;
                    La_ServiciosCumplePromo(Ln_IndexIns).ID_PLAN          := Ln_IdPlanServicio;
                    La_ServiciosCumplePromo(Ln_IndexIns).ID_PRODUCTO      := Ln_IdProdServicio;
                    La_ServiciosCumplePromo(Ln_IndexIns).PLAN_ID_SUPERIOR := Ln_IdPlanSupServicio;
                    La_ServiciosCumplePromo(Ln_IndexIns).ESTADO           := Lv_EstadoServicio;
                END IF;

                --Se recorre La_ServiciosCumplePromo
                Ln_ServiciosCumplePromo := La_ServiciosCumplePromo.FIRST;
                WHILE (Ln_ServiciosCumplePromo IS NOT NULL)   
                LOOP
                    Ln_IdServicioCumple := La_ServiciosCumplePromo(Ln_ServiciosCumplePromo).ID_SERVICIO;
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Cumple promocion el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion 
                    || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    Lv_Descuento      := '';
                    Lc_Datos          := NULL;
                    Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Ln_IdTipoPromocion);

                    IF C_ObtieneMsjPorCodigo%ISOPEN THEN
                        CLOSE C_ObtieneMsjPorCodigo;
                    END IF;

                    IF C_Datos%ISOPEN THEN
                        CLOSE C_Datos;
                    END IF;

                    IF Lr_TipoPromoRegla.PROM_DESCUENTO IS NOT NULL THEN
                        Lv_Descuento := Lr_TipoPromoRegla.PROM_DESCUENTO;
                    ELSE
                        Lc_PeriodoDesc := NULL;

                        IF C_PeriodoDesc%ISOPEN THEN
                            CLOSE C_PeriodoDesc;
                        END IF;

                        OPEN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO, 2);
                        FETCH C_PeriodoDesc INTO Lc_PeriodoDesc;
                        CLOSE C_PeriodoDesc;

                        Lv_Descuento := Lc_PeriodoDesc.DESCUENTO;
                    END IF;

                    OPEN C_Datos(Ln_IdServicioCumple,Ln_IdPromocion,Ln_IdTipoPromocion);
                    FETCH C_Datos INTO Lc_Datos;
                    CLOSE C_Datos;

                    Lv_CodMensaje := 'COD_PROM_REGLAS_CUMPLE';
                    Lc_Mensaje    := NULL;

                    OPEN C_ObtieneMsjPorCodigo(Lv_NombreParamCab,Lv_DescripDetCodMsj,Lv_EstadoActivo,Pv_CodEmpresa,Lv_CodMensaje);
                    FETCH C_ObtieneMsjPorCodigo INTO Lc_Mensaje;
                    CLOSE C_ObtieneMsjPorCodigo; 
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'ANTES INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    Lr_InfoServicioHistorial                       := NULL;
                    Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                    Lr_InfoServicioHistorial.SERVICIO_ID           := Ln_IdServicioCumple;
                    Lr_InfoServicioHistorial.USR_CREACION          := Lv_UsrCreacion;
                    Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
                    Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
                    Lr_InfoServicioHistorial.ESTADO                := Lc_Datos.ESTADO;
                    Lr_InfoServicioHistorial.OBSERVACION           := REPLACE(Lc_Mensaje.VALOR2,'NombreGrupo',Lr_TipoPromoRegla.NOMBRE_GRUPO);

                    DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'DESPUES INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'ERROR INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                        || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        Lv_MsjException := Lv_MsjResultado;
                        RAISE Le_Exception;
                    END IF;

                    --Se obtiene la observaci�n de la promoci�n tentativa en instalaci�n PROM_INS � mensualidad PROM_MENS.
                    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_OBSERVACION_TENTATIVA(Pv_CodigoGrupoPromocion => Pv_CodigoGrupoPromocion, 
                                                                               Pn_IdPromocion          => Ln_IdPromocion,
                                                                               Pv_CodigoTipoPromocion  => Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                               Pn_IdTipoPromocion      => Ln_IdTipoPromocion,
                                                                               Pv_EsCodigo             => Pv_EsCodigo,
                                                                               Pv_CodEmpresa           => Pv_CodEmpresa,
                                                                               Pv_DescripcionObserv    => Lv_DescripcionObserv); 

                    Lv_Observacion := Lv_DescripcionObserv; 
                    Lv_Periodo     := Lc_Datos.PERIODOS;

                    --Se inserta registro en la tabla de tentativa
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'ANTES INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    Lr_InfoEvaluaTentativa                        := NULL; 
                    Lr_InfoEvaluaTentativa.ID_TENTATIVA           := DB_COMERCIAL.SEQ_INFO_EVALUA_TENTATIVA.NEXTVAL ;
                    Lr_InfoEvaluaTentativa.PUNTO_ID               := Pn_IdPunto;
                    Lr_InfoEvaluaTentativa.SERVICIO_ID            := Ln_IdServicioCumple;
                    Lr_InfoEvaluaTentativa.GRUPO_PROMOCION_ID     := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
                    Lr_InfoEvaluaTentativa.TIPO_PROMOCION_ID      := Lr_TiposPromociones.ID_TIPO_PROMOCION;
                    Lr_InfoEvaluaTentativa.TIPO_PROMOCION         := Lr_TiposPromociones.CODIGO_TIPO_PROMOCION;
                    Lr_InfoEvaluaTentativa.CODIGO_GRUPO_PROMOCION := Pv_CodigoGrupoPromocion;
                    Lr_InfoEvaluaTentativa.DESCUENTO              := TO_NUMBER(Lv_Descuento,'9999.99');
                    Lr_InfoEvaluaTentativa.CANTIDAD_PERIODOS      := TO_NUMBER(Lv_Periodo,'9999.99');
                    Lr_InfoEvaluaTentativa.OBSERVACION            := Lv_Observacion;
                    Lr_InfoEvaluaTentativa.FE_CREACION            := SYSDATE;
                    Lr_InfoEvaluaTentativa.USR_CREACION           := 'telcos_tentativa';
                    Lr_InfoEvaluaTentativa.IP_CREACION            := Lv_IpCreacion;
                    Lr_InfoEvaluaTentativa.EMPRESA_COD            := Pv_CodEmpresa;
                    Lr_InfoEvaluaTentativa.ESTADO                 := 'Activo';

                    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_INFO_EVALUA_TENTATIVA(Lr_InfoEvaluaTentativa, Lv_MsjResultado);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'DESPUES INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    IF Lv_MsjResultado IS NOT NULL THEN
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'ERROR INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                        || Pv_CodigoGrupoPromocion || ' - Ln_IdServicioCumple: ' || Ln_IdServicioCumple || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        Lv_MsjException := Lv_MsjResultado;
                        RAISE Le_Exception;
                    END IF;

                    Ln_ServiciosCumplePromo := La_ServiciosCumplePromo.NEXT(Ln_ServiciosCumplePromo); 
                END LOOP; --fin de loop La_ServiciosCumplePromo    

            ELSE

                IF UPPER(TRIM(Pv_EsCodigo)) != 'S' THEN 
                    Lv_CodMensaje := 'COD_PROM_REGLAS_NO_CUMPLE';
                    Lc_Mensaje    := NULL;
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'Error en COD_PROM_REGLAS_NO_CUMPLE para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '|| Pv_CodigoGrupoPromocion
                    || ' - Ln_IdServicio: ' || Ln_IdServicio,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    OPEN C_ObtieneMsjPorCodigo(Lv_NombreParamCab,Lv_DescripDetCodMsj,Lv_EstadoActivo,Pv_CodEmpresa,Lv_CodMensaje);
                    FETCH C_ObtieneMsjPorCodigo INTO Lc_Mensaje;
                    CLOSE C_ObtieneMsjPorCodigo;  

                    --Se inserta historial del servicio
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'ANTES INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    Lr_InfoServicioHistorial                       := NULL; 
                    Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
                    Lr_InfoServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                    Lr_InfoServicioHistorial.USR_CREACION          := Lv_UsrCreacion;
                    Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
                    Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
                    Lr_InfoServicioHistorial.ESTADO                := DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_ESTADO_SERV(Ln_IdServicio);
                    Lr_InfoServicioHistorial.OBSERVACION           := REPLACE(Lc_Mensaje.VALOR2,'Lv_DescTipoPromocion',Lv_DescTipoPromocion);

                    DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Pr_InfoServicioHisto => Lr_InfoServicioHistorial, 
                                                                               Pv_MsjResultado      => Lv_MsjResultado);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'DESPUES INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    IF Lv_MsjResultado IS NOT NULL THEN
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'ERROR INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                        || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        Lv_MsjException := Lv_MsjResultado;
                        RAISE Le_Exception;
                    END IF;  

                    Lv_Descuento   := Lc_Mensaje.VALOR3;
                    Lv_Periodo     := Lc_Mensaje.VALOR4;
                    Lv_Observacion := REPLACE(Lc_Mensaje.VALOR2,'Lv_DescTipoPromocion',Lv_DescTipoPromocion); 
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'ANTES INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    --Se inserta registro en la tabla de tentativa
                    Lr_InfoEvaluaTentativa                        := NULL; 
                    Lr_InfoEvaluaTentativa.ID_TENTATIVA           := DB_COMERCIAL.SEQ_INFO_EVALUA_TENTATIVA.NEXTVAL ;
                    Lr_InfoEvaluaTentativa.PUNTO_ID               := Pn_IdPunto;
                    Lr_InfoEvaluaTentativa.SERVICIO_ID            := Ln_IdServicio;
                    Lr_InfoEvaluaTentativa.GRUPO_PROMOCION_ID     := NULL;
                    Lr_InfoEvaluaTentativa.TIPO_PROMOCION_ID      := NULL;
                    Lr_InfoEvaluaTentativa.TIPO_PROMOCION         := NULL;
                    Lr_InfoEvaluaTentativa.CODIGO_GRUPO_PROMOCION := Pv_CodigoGrupoPromocion;
                    Lr_InfoEvaluaTentativa.DESCUENTO              := TO_NUMBER(Lv_Descuento,'9999.99');
                    Lr_InfoEvaluaTentativa.CANTIDAD_PERIODOS      := TO_NUMBER(Lv_Periodo,'9999.99');
                    Lr_InfoEvaluaTentativa.OBSERVACION            := Lv_Observacion;
                    Lr_InfoEvaluaTentativa.FE_CREACION            := SYSDATE;
                    Lr_InfoEvaluaTentativa.USR_CREACION           := 'telcos_tentativa';
                    Lr_InfoEvaluaTentativa.IP_CREACION            := Lv_IpCreacion;
                    Lr_InfoEvaluaTentativa.EMPRESA_COD            := Pv_CodEmpresa;
                    Lr_InfoEvaluaTentativa.ESTADO                 := 'Activo';

                    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_INFO_EVALUA_TENTATIVA(Lr_InfoEvaluaTentativa, Lv_MsjResultado);
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                    'DESPUES INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                    || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                    --
                    IF Lv_MsjResultado IS NOT NULL THEN
                        --
                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                        'ERROR INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                        || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                        'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                        --
                        Lv_MsjException := Lv_MsjResultado;
                        RAISE Le_Exception;
                    END IF;

                END IF;

            END IF; 
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'FIN de evaluacion pare el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
            || Pv_CodigoGrupoPromocion || ' - Pv_Status: ' || Pv_Status || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa
            || ' - Lv_MsjResultado: ' || Lv_MsjResultado,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
            Pv_Status      := 'OK';
            Pv_Mensaje     := Lv_MsjResultado;
            Pv_CodMensaje  := '';

        EXCEPTION
        WHEN Le_ExceptionServicios THEN

            IF UPPER(TRIM(Pv_EsCodigo)) != 'S' THEN 
                Lv_Observacion := '';
                Lv_Descuento   := '';
                Lc_Mensaje     := NULL;

                OPEN C_ObtieneMsjPorCodigo(Lv_NombreParamCab,Lv_DescripDetCodMsj,Lv_EstadoActivo,Pv_CodEmpresa,Lv_CodMensaje);
                FETCH C_ObtieneMsjPorCodigo INTO Lc_Mensaje;
                CLOSE C_ObtieneMsjPorCodigo; 
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                'ANTES INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                --
                Lr_InfoServicioHistorial                       := NULL;  
                Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
                Lr_InfoServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                Lr_InfoServicioHistorial.FE_CREACION           := SYSDATE;
                Lr_InfoServicioHistorial.IP_CREACION           := Lv_IpCreacion;
                Lr_InfoServicioHistorial.ESTADO                := DB_COMERCIAL.CMKG_PROMOCIONES.F_OBTIENE_ESTADO_SERV(Ln_IdServicio);
                Lr_InfoServicioHistorial.USR_CREACION          := Lv_UsrCreacion;

                --Si es por proceso de Inst se setean las variables correspondientes.
                IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN    
                    Lv_Descuento   := Ln_PorcentajeInst; 
                    Lv_Observacion := Lv_ObservacionIsnt; 

                    IF Lc_Mensaje.ID_PARAMETRO_DET IS NOT NULL THEN
                        Lv_Descuento   := Lc_Mensaje.VALOR3; 
                        Lv_Observacion := Lc_Mensaje.VALOR2;
                    END IF;
                ELSE
                    Lv_Descuento   := Lc_Mensaje.VALOR3;
                    Lv_Observacion := Lc_Mensaje.VALOR2;
                END IF;

                Lr_InfoServicioHistorial.OBSERVACION := Lv_Observacion;   

                DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Pr_InfoServicioHisto => Lr_InfoServicioHistorial, 
                                                                           Pv_MsjResultado      => Lv_MsjResultado);   
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                'DESPUES INSERT INFO_SERVICIO_HISTORIAL al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                'ANTES INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                --
                --Se inserta registro en la tabla de tentativa
                Lr_InfoEvaluaTentativa                        := NULL; 
                Lr_InfoEvaluaTentativa.ID_TENTATIVA           := DB_COMERCIAL.SEQ_INFO_EVALUA_TENTATIVA.NEXTVAL ;
                Lr_InfoEvaluaTentativa.PUNTO_ID               := Pn_IdPunto;
                Lr_InfoEvaluaTentativa.SERVICIO_ID            := Ln_IdServicio;
                Lr_InfoEvaluaTentativa.GRUPO_PROMOCION_ID     := NULL;
                Lr_InfoEvaluaTentativa.TIPO_PROMOCION_ID      := NULL;
                Lr_InfoEvaluaTentativa.TIPO_PROMOCION         := NULL;
                Lr_InfoEvaluaTentativa.CODIGO_GRUPO_PROMOCION := Pv_CodigoGrupoPromocion;
                Lr_InfoEvaluaTentativa.DESCUENTO              := TO_NUMBER(Lv_Descuento,'9999.99');
                Lr_InfoEvaluaTentativa.CANTIDAD_PERIODOS      := 0;
                Lr_InfoEvaluaTentativa.OBSERVACION            := Lv_Observacion;
                Lr_InfoEvaluaTentativa.FE_CREACION            := SYSDATE;
                Lr_InfoEvaluaTentativa.USR_CREACION           := 'telcos_tentativa';
                Lr_InfoEvaluaTentativa.IP_CREACION            := Lv_IpCreacion;
                Lr_InfoEvaluaTentativa.EMPRESA_COD            := Pv_CodEmpresa;
                Lr_InfoEvaluaTentativa.ESTADO                 := 'Activo';

                DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_INFO_EVALUA_TENTATIVA(Lr_InfoEvaluaTentativa, Lv_MsjResultado);
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                'DESPUES INSERT INFO_EVALUA_TENTATIVA al idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
                || Pv_CodigoGrupoPromocion || ' - Ln_IdServicio: ' || Ln_IdServicio || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa,
                'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
                --
            END IF; 

            Pv_Status     := 'OK';
            Pv_Mensaje    := Lv_MsjResultado; 
            Pv_CodMensaje := ''; 
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'FIN de evaluacion por Le_ExceptionServicios para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
            || Pv_CodigoGrupoPromocion || ' - Pv_Status: ' || Pv_Status || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa
            || ' - Lv_MsjResultado: ' || Lv_MsjResultado,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
        WHEN Le_Exception THEN
            Lv_MsjResultado := Lv_MsjException; 

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                                                 Lv_MsjResultado,
                                                 'telcos_mapeo_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

            Pv_Status     := 'OK';
            Pv_Mensaje    := Lv_MsjResultado;                                     
            Pv_CodMensaje := '';
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
            'FIN de evaluacion por Le_Exception para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
            || Pv_CodigoGrupoPromocion || ' - Pv_Status: ' || Pv_Status || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa
            || ' - Lv_MsjResultado: ' || Lv_MsjResultado,
            'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
            --
        END;
        --

        COMMIT;
    --
    END LOOP;

  EXCEPTION 
  WHEN Le_ExceptionProceso THEN
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de evaluaci�n de Promociones. Pv_EsCodigo: '||Pv_EsCodigo
                       ||', C�digo Mensaje: '||Lv_CodMensaje;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                                         Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

    Pv_Status     := 'ERROR';
    Pv_Mensaje    := Lv_MsjResultado;                                     
    Pv_CodMensaje := Lv_CodMensaje;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'FIN de evaluacion por Le_ExceptionProceso para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
    || Pv_CodigoGrupoPromocion || ' - Pv_Status: ' || Pv_Status || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa
    || ' - Lv_MsjResultado: ' || Lv_MsjResultado,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
  WHEN OTHERS THEN
    ROLLBACK;

    Lv_CodMensaje   := 'COD_EXCEPCION';
    Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso de evaluaci�n de Promociones para el Grupo de Promocional: '||
                        Pv_CodigoGrupoPromocion||', punto_Id - '|| Pn_IdPunto ||', C�digo Mensaje: '|| Lv_CodMensaje ||
                        ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
                                         Lv_MsjResultado, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

    Pv_Status     := 'ERROR';
    Pv_Mensaje    := Lv_MsjResultado;                                     
    Pv_CodMensaje := Lv_CodMensaje;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+','CMKG_PROMOCIONES_UTIL.P_PROMOCION_EVALUA_TENTATIVA', 
    'FIN de evaluacion por ' || Lv_CodMensaje || ' para el idPunto: '|| Pn_IdPunto ||'- Pv_CodigoGrupoPromocion: '
    || Pv_CodigoGrupoPromocion || ' - Pv_Status: ' || Pv_Status || ' - Pv_CodEmpresa: ' || Pv_CodEmpresa
    || ' - Lv_MsjResultado: ' || Lv_MsjResultado,
    'telcos_log_tentativa',SYSDATE, Lv_IpCreacion);
    --
  END P_PROMOCION_EVALUA_TENTATIVA;
  --

  PROCEDURE P_OBTIENE_EVALUA_TENTATIVA(Pv_CodigoGrupoPromocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa              IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                                                                   
                                       Pn_IdPunto                 IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                      
                                       Pn_IdServicio              IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Prf_PromoTentativa         OUT SYS_REFCURSOR)
  IS    
    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';    
    Lv_NombreParametro   VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion        VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado      VARCHAR2(2000);     
    Lv_Consulta          VARCHAR2(4000);
    Le_Exception         EXCEPTION;
  BEGIN
    IF Prf_PromoTentativa%ISOPEN THEN
      CLOSE Prf_PromoTentativa;
    END IF;

    --Costo: 10	
    Lv_Consulta := ' SELECT ET.PUNTO_ID,
       ET.SERVICIO_ID,
       ET.GRUPO_PROMOCION_ID,
       ET.TIPO_PROMOCION_ID,
       ET.TIPO_PROMOCION,
       ET.DESCUENTO,
       ET.CANTIDAD_PERIODOS,
       ET.OBSERVACION,
       ET.FE_CREACION,
       ET.EMPRESA_COD,
       ET.ESTADO
       FROM DB_COMERCIAL.INFO_EVALUA_TENTATIVA ET
       WHERE ET.EMPRESA_COD    = '''||Pv_CodEmpresa||'''
       AND ET.PUNTO_ID         = '''||Pn_IdPunto||'''
       AND ET.SERVICIO_ID      = '''||Pn_IdServicio||'''
       AND ET.ESTADO           = '''||Lv_EstadoActivo||'''
       AND ( 
            ET.TIPO_PROMOCION   IN (SELECT DET.VALOR2 
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
            DB_GENERAL.ADMI_PARAMETRO_DET DET
            WHERE CAB.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''   
            AND CAB.ESTADO             =  '''||Lv_EstadoActivo||'''
            AND DET.PARAMETRO_ID       =  CAB.ID_PARAMETRO
            AND DET.VALOR3             =  '''||Pv_CodigoGrupoPromocion||'''
            AND DET.ESTADO             = '''||Lv_EstadoActivo||'''
            AND DET.EMPRESA_COD        =  '''||Pv_CodEmpresa||''')
         OR ET.CODIGO_GRUPO_PROMOCION ='''||Pv_CodigoGrupoPromocion||''') ';

   IF Lv_Consulta IS NULL THEN
      RAISE Le_Exception;
   END IF;

   OPEN Prf_PromoTentativa FOR Lv_Consulta;

  EXCEPTION
  WHEN Le_Exception THEN    
    IF Prf_PromoTentativa%ISOPEN THEN
      CLOSE Prf_PromoTentativa;
    END IF;
    Lv_MsjResultado := 'Ocurri� un error al obtener la promocion Tentativa para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || 
                       ' Empresa: '|| Pv_CodEmpresa ||
                       ' IdServicio: ' || Pn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_OBTIENE_EVALUA_TENTATIVA', 
                                         Lv_Consulta, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
    Prf_PromoTentativa := NULL;    
  WHEN OTHERS THEN
    IF Prf_PromoTentativa%ISOPEN THEN
      CLOSE Prf_PromoTentativa;
    END IF;
    Lv_MsjResultado := 'Ocurri� un error al obtener la promocion Tentativa para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || 
                       ' Empresa: '|| Pv_CodEmpresa ||
                       ' IdServicio: ' || Pn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_OBTIENE_EVALUA_TENTATIVA', 
                                         Lv_Consulta || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
    Prf_PromoTentativa := NULL;                      
  END P_OBTIENE_EVALUA_TENTATIVA;
  --

  PROCEDURE P_OBSERVACION_TENTATIVA(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                    Pn_IdPromocion           IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                    Pv_CodigoTipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                    Pn_IdTipoPromocion       IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,                                                                                                                                          
                                    Pv_EsCodigo              IN VARCHAR2 DEFAULT NULL,
                                    Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_DescripcionObserv     OUT VARCHAR2)           
  IS 
    --Costo: 3
    CURSOR C_ObtieneValorObsProm(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                 Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                 Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                 Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                 Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS 
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APD.DESCRIPCION      = Cv_Descripcion
        AND APC.ESTADO           = Cv_Estado
        AND APD.ESTADO           = Cv_Estado
        AND APD.EMPRESA_COD      = Cv_EmpresaCod
        AND APD.VALOR1           = Cv_Valor1
        AND APD.VALOR2           = NVL(Cv_Valor2,APD.VALOR2);

    --Costo: 2
    CURSOR C_CantidadPeriodos(Cn_IdPromocion     DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                              Cn_IdTipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE) IS

        SELECT COUNT(T1.VALOR) AS PERIODOS
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
                  CONNECT BY REGEXP_SUBSTR(T.VALOR, '[^,]+', 1, LEVEL) IS NOT NULL) T1; 

    --Costo: 3
    CURSOR C_PeriodoDesc(Cv_Trama  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE,
                         Cv_Orden  NUMBER) IS       
      SELECT COUNT(T2.PERIODO) AS PERIODO, 
        T2.DESCUENTO 
      FROM ( SELECT SUBSTR(T.VALOR,1,INSTR(T.VALOR,'|',1)-1) AS PERIODO, 
               SUBSTR(T.VALOR,INSTR(T.VALOR,'|',1)+1) AS DESCUENTO 
             FROM (SELECT REGEXP_SUBSTR(Cv_Trama,'[^,]+', 1, LEVEL) AS VALOR
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(Cv_Trama, '[^,]+', 1, LEVEL) IS NOT NULL) T) T2
      GROUP BY T2.DESCUENTO
      ORDER BY Cv_Orden DESC;

    Lv_IpCreacion           VARCHAR2(16)  := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo         VARCHAR2(50)  := 'Activo';
    Lv_NombreParamCab       VARCHAR2(500) := 'PARAM_EVALUA_TENTATIVA';
    Lv_DescripcionDetParam  VARCHAR2(1000); 
    Lv_ObservacionDesc      VARCHAR2(250);
    Lv_PeriodosDescuentos   VARCHAR2(250);
    Lv_ObservPeriodosDesc   VARCHAR2(250);
    Lv_TipoPromoReglaIndef  VARCHAR2(1000); 
    Lc_Valor                C_ObtieneValorObsProm%ROWTYPE;
    --
    Le_Exception            EXCEPTION;
    Lr_TipoPromoRegla       DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    Lv_MsjResultado         VARCHAR2(2000);
    Lc_CantidadPeriodos     C_CantidadPeriodos%ROWTYPE;
    Lc_PeriodoDesc          C_PeriodoDesc%ROWTYPE;
    Lv_Descuento            DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE;
    Lv_Periodo              VARCHAR2(50);

  BEGIN 
    Lv_Descuento      := '';
    Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Pn_IdTipoPromocion);
    IF Lr_TipoPromoRegla.ID_TIPO_PROMOCION IS NULL THEN                    
        Lv_MsjResultado:= 'Ocurrio un error al obtener las reglas del Tipo Promocional ID_TIPO_PROMOCION: '
                          ||Pn_IdTipoPromocion;
        RAISE Le_Exception;            
    END IF; 
    --
    IF C_CantidadPeriodos%ISOPEN THEN
      CLOSE C_CantidadPeriodos;
    END IF;

    IF Lr_TipoPromoRegla.PROM_DESCUENTO IS NOT NULL THEN
        Lv_Descuento := Lr_TipoPromoRegla.PROM_DESCUENTO;
    ELSE
        Lc_PeriodoDesc := NULL;

        IF C_PeriodoDesc%ISOPEN THEN
            CLOSE C_PeriodoDesc;
        END IF;

        OPEN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO, 2);
        FETCH C_PeriodoDesc INTO Lc_PeriodoDesc;
        CLOSE C_PeriodoDesc;
        Lv_Descuento := Lc_PeriodoDesc.DESCUENTO;
        --
    END IF;
    OPEN C_CantidadPeriodos(Pn_IdPromocion,Pn_IdTipoPromocion);
    FETCH C_CantidadPeriodos INTO Lc_CantidadPeriodos;
    CLOSE C_CantidadPeriodos; 
    Lv_Periodo := Lc_CantidadPeriodos.PERIODOS;
    --
    IF C_ObtieneValorObsProm%ISOPEN THEN
      CLOSE C_ObtieneValorObsProm;
    END IF;

    IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN 
        Lv_DescripcionDetParam := 'MENSAJE_OBS_TENTATIVA_INS';
        Lv_TipoPromoReglaIndef := NULL;

        IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN 
            Lv_DescripcionDetParam := 'MENSAJE_OBS_CODIGO_TENTATIVA_INS';
        END IF;
    ELSE
        Lv_DescripcionDetParam := 'MENSAJE_OBS_TENTATIVA_MENS';
        Lv_TipoPromoReglaIndef := NVL(Lr_TipoPromoRegla.PROM_PROMOCION_INDEFINIDA,'NO');

        IF UPPER(TRIM(Pv_EsCodigo)) = 'S' THEN 
            Lv_DescripcionDetParam := 'MENSAJE_OBS_CODIGO_TENTATIVA_MENS';
        END IF;
    END IF;

    --Se obtiene los detalles de par�metros.
    OPEN C_ObtieneValorObsProm(Lv_NombreParamCab, Lv_DescripcionDetParam, Lv_EstadoActivo,
                               Pv_CodEmpresa, Pv_CodigoTipoPromocion, Lv_TipoPromoReglaIndef);
    FETCH C_ObtieneValorObsProm INTO Lc_Valor;
    CLOSE C_ObtieneValorObsProm; 

    IF Pv_CodigoGrupoPromocion = 'PROM_INS' THEN 
        Lv_ObservacionDesc := Lc_Valor.VALOR3 ||
                              REPLACE(Lc_Valor.VALOR4,'Lv_Porcentaje',Lv_Descuento) ||', ' ||
                              REPLACE(Lc_Valor.VALOR5,'Lv_NumeroPeriodos',Lv_Periodo);
    END IF;

    IF Pv_CodigoGrupoPromocion = 'PROM_MENS' THEN 
        IF Lv_TipoPromoReglaIndef = 'SI' THEN
            IF Pv_CodigoTipoPromocion = 'PROM_TOT' THEN
                Lv_ObservacionDesc := '';
            ELSE                 
                Lv_ObservacionDesc := Lc_Valor.VALOR3 ||
                                      REPLACE(Lc_Valor.VALOR4,'Lv_Indefinida',Lv_TipoPromoReglaIndef)||', ' ||
                                      REPLACE(Lc_Valor.VALOR6,'Lv_Descuento',Lv_Descuento);

            END IF;            
        ELSE            
            FOR Lc_Valores IN C_PeriodoDesc(Lr_TipoPromoRegla.PROM_PERIODO, 1) LOOP

                Lv_PeriodosDescuentos := REPLACE(Lc_Valor.VALOR5,'Lv_NumeroPeriodos',Lc_Valores.PERIODO) ||' - ' ||
                                         REPLACE(Lc_Valor.VALOR6,'Lv_Descuento',Lc_Valores.DESCUENTO); 

                Lv_ObservPeriodosDesc:= Lv_ObservPeriodosDesc||Lv_PeriodosDescuentos||', ';
            END LOOP;

            IF  Pv_CodigoTipoPromocion = 'PROM_TOT' THEN 
               Lv_ObservacionDesc := Lc_Valor.VALOR3 || Lv_ObservPeriodosDesc;
            ELSE
               Lv_ObservacionDesc := Lc_Valor.VALOR3 ||
                                     REPLACE(Lc_Valor.VALOR4,'Lv_Indefinida',Lv_TipoPromoReglaIndef)||', ' ||
                                     Lv_ObservPeriodosDesc;
            END IF;          
            Lv_ObservacionDesc := SUBSTR (Lv_ObservacionDesc, 1, Length(Lv_ObservacionDesc) - 1 );
        END IF;

        Lv_ObservacionDesc := RTRIM(Lv_ObservacionDesc, ',' );      

    END IF;

    Pv_DescripcionObserv := Lv_ObservacionDesc;   

  EXCEPTION  
  WHEN Le_Exception THEN    
    Pv_DescripcionObserv := NULL;  

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_OBSERVACION_TENTATIVA', 
                                         'No se pudo obtener la Observacion de la Promocion tentativa - ' || Lv_MsjResultado,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
  WHEN OTHERS THEN
    Pv_DescripcionObserv := NULL;   

    Lv_MsjResultado := 'No se pudo obtener la Observacion de la Promocion tentativa de la promocion ID_TIPO_PROMOCION: '
                      ||Pn_IdTipoPromocion;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_OBSERVACION_TENTATIVA', 
                                         Lv_MsjResultado|| ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));                                                                                 

  END P_OBSERVACION_TENTATIVA;
  --

  PROCEDURE P_MENSAJE_POR_CODIGO_ERROR(Pv_CodigoGrupoPromocion  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                       Pv_CodMensaje            IN VARCHAR2,
                                       Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_Mensaje               OUT VARCHAR2, 
                                       Pv_Descuento             OUT VARCHAR2,
                                       Pv_VisualizarContrato    OUT VARCHAR2)
  IS 
    --Costo: 3
    CURSOR C_MensajePorCodError(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
    IS 
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APD.DESCRIPCION      = Cv_Descripcion
        AND APC.ESTADO           = Cv_Estado
        AND APD.ESTADO           = Cv_Estado
        AND APD.EMPRESA_COD      = Cv_EmpresaCod
        AND APD.VALOR1           = Cv_Valor1;

    Lv_IpCreacion           VARCHAR2(16)  := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo         VARCHAR2(50)  := 'Activo';
    Lv_NombreParamCab       VARCHAR2(250) := 'PARAM_EVALUA_TENTATIVA';    
    Lv_DescripcionDetParam  VARCHAR2(1000):= 'CODIGO_MENSAJE';     
    Lv_MsjResultado         VARCHAR2(2000);
    Lc_Valor                C_MensajePorCodError%ROWTYPE;
    Lv_Mensaje              VARCHAR2(500);

   BEGIN
      IF C_MensajePorCodError%ISOPEN THEN
        CLOSE C_MensajePorCodError;
      END IF;

      --Se obtiene los detalles de par�metros.
      OPEN C_MensajePorCodError(Lv_NombreParamCab, Lv_DescripcionDetParam, Lv_EstadoActivo,
                                Pv_CodEmpresa, Pv_CodMensaje);
      FETCH C_MensajePorCodError INTO Lc_Valor;
      CLOSE C_MensajePorCodError; 

      Lv_Mensaje            := REPLACE(Lc_Valor.VALOR2,'Pn_IdPunto',Pn_IdPunto);
      Lv_Mensaje            := REPLACE(Lv_Mensaje,'Pv_CodEmpresa',Pv_CodEmpresa);
      Lv_Mensaje            := REPLACE(Lv_Mensaje,'Pv_CodigoGrupoPromocion',Pv_CodigoGrupoPromocion);
      Pv_Mensaje            := Lv_Mensaje;
      Pv_Descuento          := NVL(Lc_Valor.VALOR3,'0');
      Pv_VisualizarContrato := NVL(Lc_Valor.VALOR5,'N');

   EXCEPTION  
   WHEN OTHERS THEN
     Pv_Mensaje   := NULL;  
     Pv_Descuento := NULL;   

     Lv_MsjResultado := 'No se pudo obtener el mensaje por codigo de error : ' ||Pv_CodMensaje;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                          'CMKG_PROMOCIONES_UTIL.P_MENSAJE_POR_CODIGO_ERROR', 
                                          Lv_MsjResultado|| ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          'telcos_mapeo_promo',
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));                                                                                 
  END P_MENSAJE_POR_CODIGO_ERROR;
  --

  PROCEDURE P_CONSUME_EVALUA_TENTATIVA(Pn_IdPunto                 IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                      
                                       Pn_IdServicio              IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,  
                                       Pv_CodigoGrupoPromocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                       Pv_CodEmpresa              IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                                                                   
                                       Pn_Descuento               OUT NUMBER,
                                       Pn_CantPeriodo             OUT NUMBER,
                                       Pv_Observacion             OUT VARCHAR2)
  IS    
    Lv_EstadoActivo            VARCHAR2(15) := 'Activo';     
    Lv_IpCreacion              VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado            VARCHAR2(2000);     
    Lv_Consulta                VARCHAR2(4000);
    Le_Exception               EXCEPTION;
    La_EvaluaTentativa         T_EvaluaTentativa;
    Lrf_EvaluaTentativa        SYS_REFCURSOR;   
    Ln_IndTpro                 NUMBER;    
    Lr_EvaluaTentativaPromo    Lr_EvaluaTentativa;

  BEGIN
    IF Lrf_EvaluaTentativa%ISOPEN THEN
      CLOSE Lrf_EvaluaTentativa;
    END IF;
    La_EvaluaTentativa.DELETE();

    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_OBTIENE_EVALUA_TENTATIVA(Pv_CodigoGrupoPromocion  => Pv_CodigoGrupoPromocion, 
                                                                  Pv_CodEmpresa            => Pv_CodEmpresa,
                                                                  Pn_IdPunto               => Pn_IdPunto,
                                                                  Pn_IdServicio            => Pn_IdServicio,
                                                                  Prf_PromoTentativa       => Lrf_EvaluaTentativa);
    IF NOT(Lrf_EvaluaTentativa%ISOPEN) THEN              
      Lv_MsjResultado := 'Ocurri� un error al consumir proceso de Tentativa para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || 
                       ' Empresa: '|| Pv_CodEmpresa ||
                       ' IdServicio: ' || Pn_IdServicio; 
      RAISE Le_Exception;
    END IF; 
              --
    La_EvaluaTentativa.DELETE();

    LOOP
      FETCH Lrf_EvaluaTentativa BULK COLLECT INTO La_EvaluaTentativa LIMIT 1;
      Ln_IndTpro :=La_EvaluaTentativa.FIRST;  

      WHILE (Ln_IndTpro IS NOT NULL)
      LOOP 
        Lr_EvaluaTentativaPromo := La_EvaluaTentativa(Ln_IndTpro);
        Ln_IndTpro := La_EvaluaTentativa.NEXT(Ln_IndTpro);          
        Pn_Descuento   := Lr_EvaluaTentativaPromo.DESCUENTO;
        Pn_CantPeriodo := Lr_EvaluaTentativaPromo.CANTIDAD_PERIODOS;
        Pv_Observacion := Lr_EvaluaTentativaPromo.OBSERVACION;
      END LOOP;--Fin de WHILE (Ln_IndTpro IS NOT NULL) 
      EXIT WHEN Lrf_EvaluaTentativa%NOTFOUND;
      --
      --
    END LOOP;--Fin Loop 
    CLOSE Lrf_EvaluaTentativa;                       
      --  
  EXCEPTION
  WHEN Le_Exception THEN    
    IF Lrf_EvaluaTentativa%ISOPEN THEN
      CLOSE Lrf_EvaluaTentativa;
    END IF;
    Lv_MsjResultado := 'Ocurri� un error al consumir proceso de Tentativa para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || 
                       ' Empresa: '|| Pv_CodEmpresa ||
                       ' IdServicio: ' || Pn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_CONSUME_EVALUA_TENTATIVA', 
                                         Lv_MsjResultado, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  

  WHEN OTHERS THEN
    IF Lrf_EvaluaTentativa%ISOPEN THEN
      CLOSE Lrf_EvaluaTentativa;
    END IF;
    Lv_MsjResultado := 'Ocurri� un error al consumir proceso de Tentativa para el Grupo Promocional: '|| Pv_CodigoGrupoPromocion || 
                       ' Empresa: '|| Pv_CodEmpresa ||
                       ' IdServicio: ' || Pn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_CONSUME_EVALUA_TENTATIVA', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  

  END P_CONSUME_EVALUA_TENTATIVA;

  FUNCTION F_OTIENE_ESTADO_PROMOCION(Fn_IntIdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Fv_GrupoPromocion IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                                     Fv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2
  IS

    CURSOR C_EstadoMapeo(Cn_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                         Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                         Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                         Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                         Cv_Valor           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
    IS 
      SELECT DBIDMP.ESTADO 
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DBIDMP
      WHERE DBIDMP.ID_DETALLE_MAPEO IN (SELECT MAX(IDMP.ID_DETALLE_MAPEO)
                                        FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                                        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
                                        WHERE IDMS.SERVICIO_ID    = Cn_IdServicio
                                        AND IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID
                                        AND IDMP.EMPRESA_COD      = Cv_EmpresaCod
                                        AND TIPO_PROMOCION        IN (SELECT DET.VALOR2 
                                                                      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                                      DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                                      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                                                      AND CAB.ESTADO             = Cv_Estado
                                                                      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                                      AND DET.EMPRESA_COD        = Cv_EmpresaCod
                                                                      AND DET.VALOR3             = Cv_Valor
                                                                      AND DET.ESTADO             = Cv_Estado));

    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';
    Lv_NombreParametro   VARCHAR2(50) := 'PROM_TIPO_PROMOCIONES';
    Lv_Valor             DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE;

  BEGIN

    IF C_EstadoMapeo%ISOPEN THEN
      CLOSE C_EstadoMapeo;
    END IF;
    --
    OPEN C_EstadoMapeo(Fn_IntIdServicio,
                       Lv_NombreParametro,
                       Lv_EstadoActivo,
                       Fv_CodEmpresa,
                       Fv_GrupoPromocion);
    FETCH C_EstadoMapeo INTO Lv_Valor;
    CLOSE C_EstadoMapeo;


    RETURN Lv_Valor;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_Valor := 'ERROR';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_OTIENE_ESTADO_PROMOCION', 
                                         'Error en F_OTIENE_ESTADO_PROMOCION' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')); 
    RETURN Lv_Valor;
  END F_OTIENE_ESTADO_PROMOCION;

  PROCEDURE P_ACTUALIZAR_SOLICITUDES(Pa_ServiciosPromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar,
                                     Pv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_EstadoOld       IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_EstadoNew       IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_Observacion     IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.OBSERVACION%TYPE,
                                     Pv_Mensaje         OUT VARCHAR2)

  IS
    CURSOR C_Solicitudes(Cn_IdServicio        DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                         Cv_TipoPromocion     DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                         Cv_NombreParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                         Cv_EmpresaCod        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                         Cv_EstadoActivo      VARCHAR2,
                         Cv_Estado            VARCHAR2)
    IS
      SELECT IDS.ID_DETALLE_SOLICITUD 
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
      WHERE IDS.SERVICIO_ID     =  Cn_IdServicio
      AND IDS.ESTADO            != Cv_Estado
      AND IDS.TIPO_SOLICITUD_ID IN (  SELECT ATS.ID_TIPO_SOLICITUD
                                      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                        DB_GENERAL.ADMI_PARAMETRO_DET APD,
                                        DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
                                      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
                                      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                                      AND APD.VALOR3           = Cv_TipoPromocion
                                      AND APD.EMPRESA_COD      = Cv_EmpresaCod
                                      AND APC.ESTADO           = Cv_EstadoActivo
                                      AND APD.VALOR5           = ATS.DESCRIPCION_SOLICITUD);

    Lv_EstadoActivo         VARCHAR2(6) := 'Activo';
    Lv_IpCreacion           VARCHAR2(16) := '127.0.0.1';
    Lv_msj                  VARCHAR2(4000);
    Lv_NombreParamTipoSol   VARCHAR2(25):='PROM_TIPO_PROMOCIONES';
    Ln_Indx                 NUMBER;
    Ln_Indice               NUMBER;
    La_SolicitudesProcesar  T_SolicitudesProcesar;
    Lr_InfoDetalleSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolHist   DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lex_Exception           EXCEPTION;

  BEGIN

    IF C_Solicitudes%ISOPEN THEN
      CLOSE C_Solicitudes;
    END IF;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                         'Empieza la ejecuci�n del proceso P_ACTUALIZAR_SOLICITUDES, datos Pv_CodEmpresa: '
                                         || Pv_CodEmpresa ||', Pv_TipoPromocion: '|| Pv_TipoPromocion || ', Pv_EstadoOld: '
                                         || Pv_EstadoOld || ', Pv_EstadoNew: '|| Pv_EstadoNew || ', Pv_Observacion:' || Pv_Observacion,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));     
    IF Pa_ServiciosPromo.COUNT > 0 THEN
      Ln_Indice := Pa_ServiciosPromo.FIRST;
      WHILE (Ln_Indice IS NOT NULL)
      LOOP
      --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                             'Servicio a procesar , ID_SERVICIO: '|| Pa_ServiciosPromo(Ln_Indice).ID_SERVICIO,
                                             'telcos_mapeo_promo',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
        OPEN C_Solicitudes (Pa_ServiciosPromo(Ln_Indice).ID_SERVICIO,
                            Pv_TipoPromocion,
                            Lv_NombreParamTipoSol,
                            Pv_CodEmpresa,
                            Lv_EstadoActivo,
                            Pv_EstadoOld);
         LOOP
         --
          FETCH C_Solicitudes BULK COLLECT
          --
            INTO La_SolicitudesProcesar LIMIT 1000;
            EXIT WHEN La_SolicitudesProcesar.count = 0;
            Ln_Indx := La_SolicitudesProcesar.FIRST;
            WHILE (Ln_Indx IS NOT NULL)
            LOOP
            --
              BEGIN
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                                     'Solicitud a procesar , ID_SOLICITUD: '|| La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD,
                                                     'telcos_mapeo_promo',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));  
                --Se procede a actualizar el estado de la solicitud
                Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD;
                Lr_InfoDetalleSolicitud.ESTADO               := Pv_EstadoNew;
                --
                DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_UPDATE_INFO_DETALLE_SOLI(Lr_InfoDetalleSolicitud, Lv_msj);
                --          
                IF TRIM(Lv_msj) IS NOT NULL THEN
                  RAISE Lex_Exception;
                END IF;

                --Se guarda Historial en la Solicitud.
                Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD;
                Lr_InfoDetalleSolHist.ESTADO                 := Pv_EstadoNew;
                Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
                Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
                Lr_InfoDetalleSolHist.OBSERVACION            := Pv_Observacion;
                Lr_InfoDetalleSolHist.USR_CREACION           := 'telcos_mapeo_promo';
                Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
                Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
                Lr_InfoDetalleSolHist.MOTIVO_ID              := NULL;
                --
                DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_msj);
                --
                IF TRIM(Lv_msj) IS NOT NULL THEN
                  RAISE Lex_Exception;
                END IF; 

              EXCEPTION
              WHEN Lex_Exception THEN
              --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                                     Lv_msj || ' - error en el ID_SERVICIO: '||Pa_ServiciosPromo(Ln_Indice).ID_SERVICIO,
                                                     'telcos_mapeo_promo',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
              WHEN OTHERS THEN
              --
                Lv_msj := 'Ocurri� un error al actualizar la solicitud: '|| La_SolicitudesProcesar(Ln_Indx).ID_DETALLE_SOLICITUD
                          || ' del ID_SERVICIO: '||Pa_ServiciosPromo(Ln_Indice).ID_SERVICIO;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                                     Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_mapeo_promo',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
              END;
            --
            Ln_Indx := La_SolicitudesProcesar.NEXT (Ln_Indx);
            END LOOP;
          --
          END LOOP;
        --
        CLOSE C_Solicitudes;
        --
        Ln_Indice := Pa_ServiciosPromo.NEXT (Ln_Indice);  
      --   
      END LOOP;
    ELSE
    --
      RAISE Lex_Exception;
    --
    END IF;
    Pv_Mensaje := 'OK';
  EXCEPTION 
  WHEN Lex_Exception THEN
  --
    Pv_Mensaje := 'ERROR'; 

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                         'Ocurri� un error el proceso no encontr� servicios a procesar.',
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
  WHEN OTHERS THEN
  --
    Pv_Mensaje := 'ERROR';
    Lv_msj     := 'Ocurri� un error al ejecutar el proceso de actualizaci�n de solicitudes';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.P_ACTUALIZAR_SOLICITUDES', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 

  END P_ACTUALIZAR_SOLICITUDES;


  FUNCTION F_POMOCIONES_VIGENTES(FV_TipoProceso IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROCESO%TYPE,
                                 Fv_CodEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Fv_EsCodigo    IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER
  IS
    --Costo 20
    CURSOR C_PromocionCodigo(Cn_Dias                 NUMBER,
                             Cv_CaracteristicaTipo   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                             Cv_CaracteristicaCodigo DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                             Cv_Estado               DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_EmpresaCod           DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Cv_Valor                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Cd_FeEvaluaVigencia     DATE)
    IS 
      SELECT COUNT(AGP.ID_GRUPO_PROMOCION) AS CONT 
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA TIPO
      WHERE (ADD_MONTHS(TRUNC(SYSDATE),-Cn_Dias) BETWEEN AGP.FE_INICIO_VIGENCIA AND AGP.FE_FIN_VIGENCIA
      OR TRUNC(Cd_FeEvaluaVigencia) BETWEEN AGP.FE_INICIO_VIGENCIA AND AGP.FE_FIN_VIGENCIA)
      AND AGP.EMPRESA_COD                 = Cv_EmpresaCod
      AND AGPR.GRUPO_PROMOCION_ID         = AGP.ID_GRUPO_PROMOCION
      AND TIPO.ID_CARACTERISTICA          = AGPR.CARACTERISTICA_ID
      AND TIPO.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaTipo
      AND UPPER(AGPR.VALOR)               LIKE '%'||Cv_Valor||'%'
      AND AGPR.ESTADO                     != Cv_Estado
      AND EXISTS (SELECT 1 
                  FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA DBAGPR,
                  DB_COMERCIAL.ADMI_CARACTERISTICA CODIGO
                  WHERE DBAGPR.GRUPO_PROMOCION_ID       = AGP.ID_GRUPO_PROMOCION
                  AND CODIGO.ID_CARACTERISTICA          = DBAGPR.CARACTERISTICA_ID
                  AND CODIGO.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaCodigo
                  AND DBAGPR.ESTADO                     != Cv_Estado);

    --Costo 15       
    CURSOR C_Promocion(Cn_Dias                 NUMBER,
                       Cv_CaracteristicaTipo   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                       Cv_Estado               DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                       Cv_EmpresaCod           DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                       Cv_Valor                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                       Cd_FeEvaluaVigencia     DATE)
    IS 
      SELECT COUNT(AGP.ID_GRUPO_PROMOCION) AS CONT 
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA AGPR,
        DB_COMERCIAL.ADMI_CARACTERISTICA TIPO
      WHERE (ADD_MONTHS(TRUNC(SYSDATE),-Cn_Dias) BETWEEN AGP.FE_INICIO_VIGENCIA AND AGP.FE_FIN_VIGENCIA
      OR TRUNC(Cd_FeEvaluaVigencia) BETWEEN AGP.FE_INICIO_VIGENCIA AND AGP.FE_FIN_VIGENCIA)
      AND AGP.EMPRESA_COD                 = Cv_EmpresaCod
      AND AGPR.GRUPO_PROMOCION_ID         = AGP.ID_GRUPO_PROMOCION
      AND TIPO.ID_CARACTERISTICA          = AGPR.CARACTERISTICA_ID
      AND TIPO.DESCRIPCION_CARACTERISTICA = Cv_CaracteristicaTipo
      AND UPPER(AGPR.VALOR)               LIKE '%'||Cv_Valor||'%'
      AND AGPR.ESTADO                     != Cv_Estado;

    --Costo 5
    CURSOR C_GetParamNumeroMesesContrato (Cv_NombreParam  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Cv_Estado       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                          Cv_Cod_Empresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS
      SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_MESES
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APD.EMPRESA_COD        = Cv_Cod_Empresa
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
      AND APC.ESTADO             = Cv_Estado;

    Lv_EstadoEliminado       VARCHAR2(15) := 'Eliminado';
    Lv_CaracteristicaCodigo  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PROM_CODIGO';
    Lv_CaracteristicaTipo    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'PROM_TIPO_CLIENTE';
    Ln_Valor                 NUMBER;
    Ln_mes                   NUMBER := 0;
    Ld_FeEvaluaVigencia      DATE := SYSDATE -1;

  BEGIN

    IF C_PromocionCodigo%ISOPEN THEN
      CLOSE C_PromocionCodigo;
    END IF;

    IF C_Promocion%ISOPEN THEN
      CLOSE C_Promocion;
    END IF;

    IF FV_TipoProceso = 'NUEVO' THEN
      OPEN  C_GetParamNumeroMesesContrato('PROMOCIONES_NUMERO_MESES_EVALUA_FE_CONTRATO',
                                          'Activo',
                                          Fv_CodEmpresa);
      FETCH C_GetParamNumeroMesesContrato INTO Ln_mes;
      CLOSE C_GetParamNumeroMesesContrato;
      Ld_FeEvaluaVigencia := SYSDATE;
    END IF;

    IF UPPER(TRIM(Fv_EsCodigo)) = 'S' THEN
      OPEN C_PromocionCodigo(Ln_mes,
                             Lv_CaracteristicaTipo,
                             Lv_CaracteristicaCodigo,
                             Lv_EstadoEliminado,
                             Fv_CodEmpresa,
                             FV_TipoProceso,
                             Ld_FeEvaluaVigencia);
      FETCH C_PromocionCodigo INTO Ln_Valor;
      CLOSE C_PromocionCodigo;
    ELSE
      OPEN C_Promocion(Ln_mes,
                       Lv_CaracteristicaTipo,
                       Lv_EstadoEliminado,
                       Fv_CodEmpresa,
                       FV_TipoProceso,
                       Ld_FeEvaluaVigencia);
      FETCH C_Promocion INTO Ln_Valor;
      CLOSE C_Promocion;
    END IF;

    RETURN Ln_Valor;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Ln_Valor := 0;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_UTIL.F_POMOCIONES_VIGENTES', 
                                         'Error en F_POMOCIONES_VIGENTES' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_mapeo_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')); 
    RETURN Ln_Valor;
  END F_POMOCIONES_VIGENTES;

END CMKG_PROMOCIONES_UTIL;
/