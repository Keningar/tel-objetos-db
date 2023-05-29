CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_REPORTE_FINANCIERO AS 

  /*
  *Se agregan types necesarios para generación de reporte de pagos por vendedor.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 13-10-2016
  */

  TYPE Lr_ListadoPagos IS RECORD(TOTAL_REGISTRO NUMBER);
  --
  TYPE Lt_Result IS TABLE OF Lr_ListadoPagos;
  --
  TYPE Lrf_Result IS REF CURSOR;


  /*
  * Documentación para PROCEDURE 'P_REPORTE_COBRANZAS'.
  * Procedure que me permite obtener datos de los documentos financieros segun parametros indicados.
  *
  * PARAMETROS:
  * @Param varchar2 Pv_TipoDocumento   (tipo de documento a consultar)
  * @Param varchar2 Pv_NumeroDocumento (número de documento a consultar)
  * @Param varchar2 Pv_NumeroDocumentoAut (número de documento  autorizado a consultar)
  * @Param varchar2 Pv_UsrCreacion (usuariuo de creacion del documento a consultar)
  * @Param varchar2 Pv_EstadoDocumento (estado del documento a consultar)
  * @Param varchar2 Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creación del documento)
  * @Param varchar2 Pv_FechaCreacionHasta (rango final para consulta por fecha de creación del documento)
  * @Param varchar2 Pv_FormaPago (Forma de pago a conbnsultar)
  * @Param varchar2 Pv_Banco (Nombre del banco a consultar)
  * @Param varchar2 Pv_NumeroReferencia (Numero de referencia del documento a consultar)
  * @Param varchar2 Pv_EstadoPunto (Estado del punto a consultar)
  * @Param varchar2 Pn_EmpresaCod (empresa a generar el reporte)
  * @Param varchar2 Pv_UsrSesion  Usuario en sesion
  * @Param varchar2 Pv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2 Pv_EmailUsrSesion   Email de usuario en sesión
  * @Param varchar2 Pv_Start (Rango inicial de número de registros del reporte)
  * @Param varchar2 Pv_Limit (Rango final de número de registros del reporte)
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 16-09-2016
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 25-10-2016 Se elimina filtro de búsqueda por login vendedor debido a duplicidad de logins a nivel de la tabla INFO_PERSONA.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 26-10-2016 Se agrega visualización de campo comentario del detalle del documento.
  * @author Ricardo Coello Quezada <rcoello@telconet.ec> 
  * @version 1.7 16-11-2016   Se quita la estampa de tiempo(Fe_Emisión).
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.8 19-12-2016 - Se agregan las variables 'Pv_FechaContabilizacionDesde', 'Pv_FechaContabilizacionHasta' para realizar la búsqueda por
  *                           fechas con las cuales se contabilizan los documentos del departamento de cobranzas
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.9 11-01-2017 - Se modifica el reporte para agregar la columna '# COMPROBANTE' y que muestre el 'No FISICO' con el cual se ha
  *                           contabilizado el detalle del pago
  *
  * Se agrega parametro cuando se llama a F_GET_NUMERO_COMPROBANTE para evitar realizar insert
  * por error.
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.10 20-01-2017 
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.0 21-01-2017 - Se modifica la función para poder generar los reportes para realizar la respectiva cuadratura de la contabilidad. Para
  *                           ello se agregan validaciones dependiendo de cada proceso contable que existe actualmente en base para migrar la
  *                           información del TELCOS+ al NAF. Los reportes de contabilidad a generar son los siguientes:
  *                           - Reporte:          Reporte de pagos manuales (P_PAG). 
  *                             Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_PAGO_MANUAL
  *                             Definición:       Se obtiene el reporte de pagos manuales dependiendo de la forma de pago de los documentos.
  *                                               Si la forma de pago es depositable se considera la fecha de depósito del documento.
  *                                               Si la forma de pago no es depositable se considera la fecha de creación del documento.
  *                                               Adicional se considera para los pagos con forma de pago 'Débito Bancario' que en su cabecera tengan
  *                                               el campo 'DB_FINANCIERO.INFO_PAGO_CAB.DEBITO_GENERAL_HISTORIAL_ID' en 'NULL'
  *
  *                           - Reporte:          Reporte de pagos masivos (P_PAG_RET). 
  *                             Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_PAGO_RET 
  *                             Definición:       Se obtiene el reporte de pagos masivos considerando la fecha de creación de los documentos y de las
  *                                               siguientes formas de pago:
  *                                               + CANJ	CANJE
  *                                               + RF8	    RETENCION FUENTE 8%
  *                                               + RF2	    RETENCION FUENTE 2%
  *                                               + RF1	    RETENCION FUENTE 1%
  *                                               + RI70	RETENCION IVA 70%
  *                                               + RI10	RETENCION IVA 100%
  *                                               + RI1	    RETENCION IVA 10%
  *                                               + RI20	RETENCION IVA 20%
  *                                               + RTIV	RETENCION IVA 30%
  *                                               + SF	    SALDO FAVOR
  *                                               + IMP	    IMPUESTOS
  *                                               + PROI	PROVISION INCOBRABLE
  *                                               + REGP	REUBICACION DE PAGO
  *                                               + DNOM	DESCUENTO EN NOMINA
  *                                               + ROL	    ROL DE PAGO
  *                                               + CMBC	COMISIONES BANCARIAS
  *
  *                           - Reporte:          Reporte de débitos (P_DEB). 
  *                             Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_DEBITOS
  *                             Definición:       Se obtiene el reporte de pagos con forma de pago 'Debito Bancario' que en su cabecera tengan el
  *                                               campo 'DB_FINANCIERO.INFO_PAGO_CAB.DEBITO_GENERAL_HISTORIAL_ID' diferente de 'NULL'. Se realiza
  *                                               dicha verificación para asegurarse que los pagos fueron creados por el proceso de débitos del 
  *                                               TELCOS+. Para este reporte la fecha de validación para obtener el reporte de contabilidad es 
  *                                               'DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.FE_DOCUMENTO'
  *
  *                           - Reporte:          Reporte de débitos (P_DEP). 
  *                             Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_DEPOSITO
  *                             Definición:       Se obtiene el reporte de pagos con forma de pagos que son depositables y para ello se verifica que
  *                                               el campo 'DB_GENERAL.ADMI_FORMA_PAGO.ES_DEPOSITABLE' tenga valor 'S'. Adicional para este reporte 
  *                                               la fecha de validación para obtener el reporte de contabilidad es 
  *                                               'DB_FINANCIERO.INFO_DEPOSITO.FE_PROCESADO'
  *
  *                           - Reporte:          Reporte de anticipos por cruce (P_ANT_CRUCE). 
  *                             Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_CRUCE
  *                             Definición:       Se obtiene el reporte de anticipos (ANT) y anticipos por cruce (ANTC) que hayan sido cruzados
  *                                               contra una factura. Adicional para este reporte la fecha de validación para obtener el reporte de
  *                                               contabilidad es 'DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE'.
  *                             Consideración Especial: Para este reporte se crea una validación adicional puesto que actualmente el proceso contable
  *                                                     está migrando la información al NAF con la fecha de depósito o fecha de creación dependiendo
  *                                                     de la forma de pago, y no con la fecha de cruce con la cual se está realizando el movimiento.
  *                                                     Este cambio será subido a partir del '01-FEB-2017' por ello se valida para cuando la fecha de
  *                                                     consulta del usuario sea menor al '01-FEB-2017' se retorne la información de los pagos
  *                                                     considerando la fecha de creación o depósito de los pagos, caso contrario considerará la
  *                                                     fecha de cruce del pago.  
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.1 03-02-2017 - Se modifica la función para realizar mejoras a los reportes de contabilidad. Las mejoras consisten en agregar la
  *                           columna de 'FECHA CONTABILIDAD' la cual contiene la fecha con la cual ha sido procesado el pago en el NAF, se agrega al
  *                           query principal la columna 'DESCRIPCION_CTA_CONTABLE' la cual contiene el nombre de la cuenta contable a la cual fue
  *                           migrado el pago en el NAF en caso de existir dicha información en el detalle del pago, se corrige la información 
  *                           presentada en la columna 'BANCO EMPRESA' para que muestre la correcta cuenta o banco a la cual fue migrada la
  *                           información del pago al NAF.
  *
  *                           Adicional por reporte se realizaron ciertas mejoras que consisten en:
  *                           Reporte:          Reporte de pagos manuales (P_PAG). 
  *                           Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_PAGO_MANUAL
  *                           Mejora:           El reporte sólo debe mostrar los pagos con formas de pago depositables y pago con formas de pago no
  *                                             depositables pero que tienen tipo de forma de pago 'TARJETA_CREDITO', 'DEBITO' y 'DEPOSITO'.
  *                                             Adicional se excluyen los anticipos por cruce ('ANTC') y los pagos por cruce ('PAGC').
  *                                             Se implementa una mejora en la validación de la fecha de contabilidad la cual consiste en preguntar
  *                                             la tabla cabecera a la cual fue migrado el pago al NAF usando su forma de pago, el tipo de documento,
  *                                             el proceso ejecutado y el código de la empresa. Para ello se crea la función 
  *                                             'DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB' y si retorna 'MIGRA_ARCKMM' se valida con
  *                                             la fecha de depósito del pago, si retorna 'MIGRA_ARCGAE' o NULL se valida con la fecha de creación
  *                                             del pago.
  *
  *                           Reporte:          Reporte de anticipos por cruce (P_ANT_CRUCE). 
  *                           Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_CRUCE
  *                           Mejora:           El reporte sólo debe mostrar los pagos que no incluyan formas de pago depositables y pago con formas
  *                                             de pago no depositables pero que tienen tipo de forma de pago 'TARJETA_CREDITO', 'DEBITO' y 
  *                                             'DEPOSITO', y que estén en estado 'Activo' y que sean visibles en la opción de pagos.
  *                                             Adicional sólo se deben incluir los anticipos por cruce ('ANTC') y los pagos por cruce ('PAGC').
  *                                             Se implementa una mejora en la validación de la fecha de contabilidad cuando el parámetro 
  *                                             'Lv_ValidadorFechas' es igual a 'N'. La validación consiste en preguntar la tabla cabecera a la cual
  *                                             fue migrado el pago al NAF usando su forma de pago, el tipo de documento, el proceso ejecutado y el 
  *                                             código de la empresa. Para ello se crea la función 
  *                                             'DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB' y si retorna 'MIGRA_ARCKMM' se valida con
  *                                             la fecha de depósito del pago, si retorna 'MIGRA_ARCGAE' o NULL se valida con la fecha de creación
  *                                             del pago.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.2 24-03-2017 - Reporte:          Reporte de anticipos por cruce (P_ANT_CRUCE). 
  *                           Proceso Contable: DB_FINANCIERO.FNCK_CONTABILIZAR_CRUCE
  *                           Mejora:           Se valida que retorne los anticipos cruzados (ANT, ANTC, PAGC) que tengan fecha de cruce. Adicional
  *                                             se valida con la variable 'Lv_FechaCruceAnticipos' si la fecha de cruce corresponde a días anteriores
  *                                             del '01/02/2017' para validar el cruce contra la fecha de creación o la fecha de depósito.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.3 31-03-2017 - Se agregan los siguientes reportes:
  *                              - 'P_PAG_HISTO': Reporte histórico de pagos.
  *                              - 'P_ANT_HISTO': Reporte histórico de anticipos.
  *                            Adicional se realiza SUBSTR a las columnas 'COMENTARIO PAGO' y 'COMENTARIO PAGO_DET' puesto que debido a la cantidad
  *                            de caracteres obtenidos en dicha columna no permitía la generación respectiva del reporte solicitado.
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 2.4 27-07-2017 - Se agrega el filtro del Estado del Punto y se modifica los filtros
  *                           de forma de pago y estado de pago para que soporte multiseleccion.
  *                           Se mejora la presentacion del reporte en la columna FECHA CONTABILIZACION.
  *                           Se agregan dos validaciones para cambiar el asunto y el nombre del archivo cuando sea generado desde los JOBS
  *                           Costo del query principal de busqueda por ALL ROWS: 56928 utilizando los filtros: FE_CREACION, ID_FORMA_PAGO, ESTADO y
  *                           EMPRESA_ID
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.5 14-08-2017 - Se valida para los reportes 'P_DEB' y 'P_DEP' que se realice la búsqueda por fecha de creación cuando la fecha de
  *                           consulta sea mayor o igual al '15-Agosto-2017'
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 23-10-2017
  * Se agrega columna CICLO_FACTURACION
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.1 1-12-2017
  * Se agrega la columna de la descripcion del plan para el reporte
  *
  * @author Angel Reina <areina@telconet.ec>
  * @version 1.2 26-06-2019
  * Se agrega columna TIPO CUENTA para los reportes (PAG, PAGC, ANT, ANTC, ANTS)

  */
  PROCEDURE P_REPORTE_COBRANZAS(
    Pv_TipoDocumento                IN  VARCHAR2,
    Pv_NumeroDocumento              IN  VARCHAR2,
    Pv_NumeroDocumentoAut           IN  VARCHAR2,
    Pv_UsrCreacion                  IN  VARCHAR2,
    Pv_EstadoDocumento              IN  VARCHAR2, 
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FormaPago                    IN  VARCHAR2,
    Pv_Banco                        IN  VARCHAR2,
    Pv_NumeroReferencia             IN  VARCHAR2,
    Pv_EstadoPunto                  IN  VARCHAR2,
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_UsrSesion                    IN  VARCHAR2,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_Start                        IN  VARCHAR2,
    Pv_Limit                        IN  VARCHAR2,
    Pv_FechaContabilizacionDesde    IN  VARCHAR2,
    Pv_FechaContabilizacionHasta    IN  VARCHAR2
  );


  /*
  * Documentación para PROCEDURE 'P_REPORTE_FACTURACION'.
  * Procedure que me permite obtener datos de los documentos financieros segun parametros indicados.
  *
  * PARAMETROS:
  * @Param varchar2 Pv_TipoDocumento   (tipo de documento a consultar)
  * @Param varchar2 Pv_NumeroDocumento (número de documento a consultar)
  * @Param varchar2 Pv_UsrCreacion (usuario de creacion del documento a consultar)
  * @Param varchar2 Pv_EstadoDocumento (estado del documento a consultar)
  * @Param number   Pf_Monto (monto o valor a connsultar)
  * @Param varchar2 Pv_FiltroMonto (operador para rango de consulta)
  * @Param varchar2 Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creación del documento)
  * @Param varchar2 Pv_FechaCreacionHasta (rango final para consulta por fecha de creación del documento)
  * @Param varchar2 Pv_FechaEmisionDesde (rango inicial para consulta por fecha de emisión del documento)
  * @Param varchar2 Pv_FechaEmisionHasta (rango final para consulta por fecha de emisión del documento)
  * @Param varchar2 Pv_FechaAutorizacionDesde (rango inicial para consulta por fecha de autorización del documento)
  * @Param varchar2 Pv_FechaAutorizacionHasta (rango final para consulta por fecha de autorización del documento)
  * @Param varchar2 Pv_EmpresaCod (empresa a generar el reporte)
  * @Param varchar2 Pv_UsrSesion  Usuario en sesion
  * @Param varchar2 Pv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2 Pv_EmailUsrSesion   Email de usuario en sesión
  * @Param varchar2 Pv_Start (Rango inicial de número de registros del reporte)
  * @Param varchar2 Pv_Limit (Rango final de número de registros del reporte)
  * @return C_DocumentosFinancieros (cursor con la informacion de documentos financieros.)
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 12-09-2016
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.1 12-10-2016   Se actualizan longitud y tipo de datos en variables utilizadas para visualización de rpt NDI
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.2 17-10-2016   Se realiza corrección en consulta de documentos por fecha de emisión.
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.3 18-10-2016   Se agrega limpieza de caracteres especiales sobre campo responsable nc
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.4 19-10-2016   Se agregan nuevas columnas al reporte, cambio en forma de obtener descripción de documento
  *                           a partir del detalle (FACP) o del campo observación del historial realizando la consulta
  *                           por id y usuario de creación del documento.
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.5 26-10-2016   Se agrega redondeo a dos decimales en consulta de valores correspondientes a  subtotales.
  * @author Ricardo Coello Quezada <rcoello@telconet.ec> 
  * @version 1.7 16-11-2016   Se quita la estampa de tiempo(Fe_Emisión).
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.8 22-12-2016 - Se modifica el procedimiento para agregar la columna de valor de compensación para los documentos 'FAC', 'FACP', 'NC'.
  *                           Adicional se hace limpieza de caracteres especiales a las columnas NOMBRES, APELLIDOS y RAZON_SOCIAL
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.9 22-12-2016 - Se modifica el procedimiento para agregar la columna de fecha de anulación para los documentos 'FAC', 'FACP', 'NC'.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.0 11-01-2016 - Se modifica el procedimiento para agregar variable local 'Lv_ValorCompensacion' que permita traer las columnas de 
  *                           compensación solidaria.
  *
  * Se modifca el procedimiento para agregar las columnas VALOR_RETENCION_FTE y VALOR_RETENCION_IVA en el reporte,
  * en el query se llama a la funcion actualizada FNCK_CONSULTS.F_GET_VALOR_RETENCIONES
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.9 29-12-2016 
  *
  * Se modifica query para que el cálculo del campo subtotal cero impuesto se realice a través de una nueva función.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 2.0 19-01-2017 
  *
  * Se agrega redondeo a 2 decimales de campo valor total.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 2.1 13-02-2017 
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.2 11-05-2017 - Se setean en NULL las variables 'Lv_DescripcionFactura', 'Lv_TipoResponsable', 'Lv_DescripcionArea', 
  *                           'Lv_FacturaAplica', 'Lv_PagoAplica', 'Lv_FechaPagoAplica', 'Lv_Comentario', 'Lv_Multa', 'Lf_ValorRetenciones' en cada
  *                           registro del reporte para presentar en blanco la columna correspondiente en caso de no encontrar información.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 23-10-2017
  * Se agrega columna CICLO_FACTURACION
  */

  PROCEDURE P_REPORTE_FACTURACION(
    Pv_TipoDocumento                IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_NumeroDocumento              IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Pv_UsrCreacion                  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
    Pv_EstadoDocumento              IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE, 
    Pf_Monto                        IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    Pv_FiltroMonto                  IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FechaEmisionDesde            IN  VARCHAR2,
    Pv_FechaEmisionHasta            IN  VARCHAR2,
    Pv_FechaAutorizacionDesde       IN  VARCHAR2,
    Pv_FechaAutorizacionHasta       IN  VARCHAR2,
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_UsrSesion                    IN  VARCHAR2,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_Start                        IN  VARCHAR2,
    Pv_Limit                        IN  VARCHAR2
  );

  /**
   * Documentacion para la funcion F_INFO_CLIENTE_CICLOFAC
   * Retorna Información del Cliente como: ciclo de Facturación del cliente
   * 
   * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
   * @version 1.0 23-10-2017
   *
   * @param   Fv_TipoInformacion IN VARCHAR2 (Tipo de campo a obtener en la informacion del Cliente)
   * @param   Fn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE (Id del cliente)
   *   
   * @return VARCHAR2   Retorna Informacion del Cliente
   */
   FUNCTION F_INFO_CLIENTE_CICLOFAC(
    Fv_TipoInformacion     IN VARCHAR2,
    Fn_IdPersonaRol        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN VARCHAR2;

    /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia ciertos caracteres especiales que no forman parte de la razon social del cliente
   * Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
   * Retorna:
   * En tipo varchar2 la cadena sin caracteres especiales
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 26-09-2015
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.2 19-10-2016  Se agrega limpieza de nuevo caracter (;)
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.3 22-12-2016  Se agrega limpieza de los caracteres punto y coma(;), coma(,) y punto(.)
   */
  FUNCTION F_GET_VARCHAR_CLEAN(
      Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;  

  /*
  * Documentación para PROCEDURE 'P_GET_PAGOS_VENDEDOR'.
  * Procedure que me permite obtener lista de pagos por vendedor según filtros enviados como parámetros.
  *
  * PARAMETROS:
  * @Param number         Pn_EmpresaId  (empresa a generar el reporte)
  * @Param varchar2       Pv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2       Pv_UsrSesion  Usuario en sesion
  * @Param varchar2       Pv_EmailUsrSesion   Email de usuario en sesión
  * @Param varchar2       Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creación del documento)
  * @Param varchar2       Pv_FechaCreacionHasta (rango final para consulta por fecha de creación del documento)
  * @Param varchar2       Pv_Identificacion Numero de identificación el vendedor
  * @Param varchar2       Pv_RazonSocial   Razón social del cliente
  * @Param varchar2       Pv_Nombres   Nombres del cliente 
  * @Param varchar2       Pv_Apellidos Apellidos del cliente   
  * @Param number         Pn_Start (Rango inicial de consulta)
  * @Param number         Pn_Limit (Rango final consulta) 
  * @param number         Pn_TotalRegistros  OUT  ( Total de registros obtenidos de la consulta )
  * @param SYS_REFCURSOR  Pr_Documentos      OUT  ( Cursor con los documentos obtenidos de la consulta )
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 30-09-2016
  */

  PROCEDURE P_GET_PAGOS_VENDEDOR(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  );


  /*
  * Documentación para PROCEDURE 'P_REPORTE_PAGOS_VENDEDOR'.
  * Procedure que me permite generar reporte de pagos por vendedor en formato csv y enviarlo por mail según filtros enviados como parámetros.
  *
  * PARAMETROS:
  * @Param number   Pn_EmpresaId  (empresa a generar el reporte)
  * @Param varchar2 Pv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2 Pv_UsrSesion  Usuario en sesion
  * @Param varchar2 Pv_EmailUsrSesion   Email de usuario en sesión
  * @Param varchar2 Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creación del documento)
  * @Param varchar2 Pv_FechaCreacionHasta (rango final para consulta por fecha de creación del documento)
  * @Param varchar2 Pv_Identificacion Numero de identificación el vendedor
  * @Param varchar2 Pv_RazonSocial   Razón social del cliente
  * @Param varchar2 Pv_Nombres   Nombres del cliente 
  * @Param varchar2 Pv_Apellidos Apellidos del cliente  
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 30-09-2016
  */

  PROCEDURE P_REPORTE_PAGOS_VENDEDOR(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE
  );

  /*
  * Documentación para la función 'F_GET_PAGOS_VENDEDOR'.
  * Función que me permite obtener lista de pagos por vendedor según filtros enviados como parámetros.
  *
  * PARAMETROS:
  * @Param varchar2 Fn_EmpresaCod (empresa a generar el reporte)
  * @Param varchar2 Fv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2 Fv_UsrSesion  Usuario en sesion
  * @Param varchar2 Fv_EmailUsrSesion   Email de usuario en sesión
  * @Param varchar2 Fv_FechaCreacionDesde (rango inicial para consulta por fecha de creación del documento)
  * @Param varchar2 Fv_FechaCreacionHasta (rango final para consulta por fecha de creación del documento)
  * @Param varchar2 Fv_Identificacion Numero de identificación el vendedor
  * @Param varchar2 Fv_RazonSocial   Razón social del cliente
  * @Param varchar2 Fv_Nombres   Nombres del cliente 
  * @Param varchar2 Fv_Apellidos Apellidos del cliente
  * @Param number   Fn_Start   Rango inicial de consulta
  * @Param number   Fn_Limit   Rango final de consulta
  * @param number   Fn_TotalRegistros  OUT  ( Total de registros obtenidos de la consulta )
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 30-09-2016
  */

  FUNCTION F_GET_PAGOS_VENDEDOR(
    Fn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Fv_PrefijoEmpresa               IN  VARCHAR2,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Fv_EmailUsrSesion               IN  VARCHAR2,
    Fv_FechaCreacionDesde           IN  VARCHAR2,
    Fv_FechaCreacionHasta           IN  VARCHAR2,
    Fv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Fv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Fv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Fn_Start                        IN  NUMBER,
    Fn_Limit                        IN  NUMBER,
    Fn_TotalRegistros               OUT NUMBER
  )
    RETURN SYS_REFCURSOR; 

  /*
  * Funcion que sirve para obtener el total de los registros consultados
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0  13-10-2016
  * @param  CLOB  Lcl_Consulta  Sql que se consulta
  * @return NUMBER              Cantidad de registros
  */
  --
  FUNCTION F_GET_COUNT_REFCURSOR(
      Lcl_Consulta IN CLOB)
    RETURN NUMBER;

  /*
  * Procedimiento para guardar los parametros configurados por el usuario desde la interfaz
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0  12-07-2017
  * @param VARCHAR2 Pv_TipoDocumento Parametro de Tipo de Documento
  * @param VARCHAR2 Pv_EstadoPunto Parametro de Estado del Punto
  * @param VARCHAR2 Pv_EstadoPago Parametro de Estado del Pago
  * @param VARCHAR2 Pv_FormaPago Parametro de Forma de Pago
  * @param VARCHAR2 Pv_UsrSesion Parametro de Usuario que realiza la configuracion
  * @param VARCHAR2 Pv_IpClient Parametro de IP desde donde se realiza la configuracion
  * @param VARCHAR2 Pv_CodEmpresa Parametro de Codigo de la empresa que realiza la configuracion
  */
  PROCEDURE P_CONF_REPORT_AUTOM_PAGOS(
      Pv_TipoDocumento IN VARCHAR2,
      Pv_EstadoPunto   IN VARCHAR2,
      Pv_EstadoPago    IN VARCHAR2,
      Pv_FormaPago     IN VARCHAR2,
      Pv_UsrSesion     IN VARCHAR2,
      Pv_IpClient      IN VARCHAR2,
      Pv_CodEmpresa    IN VARCHAR2);

  /*
  * Funcion para obtener los parametros de configuracion del Reporte Automatico de Pagos
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0  12-07-2017
  * @param VARCHAR2 Pv_Parametro Parametro para busqueda en los parametros configurados
  */
  FUNCTION F_GET_PARM_CONF(
      Pv_Parametro     IN VARCHAR)
  RETURN VARCHAR2;

  /*
  * Procedimiento para guardar datos de ejecucion del JOB en la tabla INFO_REPORTE_HISTORIAL
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0  18-07-2017
  * @param VARCHAR2 PV_EMPRESACOD Parametro para el prefijo de la empresa
  * @param VARCHAR2 PV_CODTIPREP Parametro para tipo de reporte
  * @param VARCHAR2 PV_EMAILUSR Parametro para correo del usuario
  * @param VARCHAR2 PV_APLICACION Parametro para la aplicacion que ejecuta el proceso
  * @param VARCHAR2 PV_OBSERVACION Parametro para observaciones
  * @param VARCHAR2 PV_USRCREACION Parametro para usuario de creacion
  * @param DATE     PD_FECCREACION Parametro para fecha de creacion
  */
  PROCEDURE P_GUARDA_EJECUCION_JOB(
    PV_EMPRESACOD  IN VARCHAR2,
    PV_CODTIPREP   IN VARCHAR2,
    PV_EMAILUSR    IN VARCHAR2,
    PV_APLICACION  IN VARCHAR2,
    PV_OBSERVACION IN VARCHAR2,
    PV_USRCREACION IN VARCHAR2 DEFAULT USER,
    PD_FECCREACION IN DATE DEFAULT SYSDATE);


  /*
  * Documentación para PROCEDURE 'P_GEN_REPORTE_BURO'.
  * Procedure que me permite generar el reporte de buro segun parametros enviados.
  *
  * PARAMETROS:
  * @Param varchar2 Pv_Host                Host de conección para la base de datos
  * @Param varchar2 Pv_PathFileLogger      Ruta donde se guardará el log del script
  * @Param varchar2 Pv_NameFileLogger      Nombre del log del script
  * @Param varchar2 Pv_PrefijoEmpresa      Empresa del usuario que manda a ejecutar el script para generar el reporte
  * @Param varchar2 Pv_IpSession           Ip del usuario que manda a ejecutar el script para generar el reporte 
  * @Param varchar2 Pv_UsuarioSession      Nombre del usuario que manda a ejecutar el script para generar el reporte 
  * @Param varchar2 Pv_ValorClientesBuenos Valor de deuda permitido para los clientes buenos
  * @Param varchar2 Pv_ValorClientesMalos  Valor de deuda permitido para los clientes malos
  * @Param varchar2 Pv_DirectorioUpload    Directorio donde se guardará el reporte a descargar
  * @Param varchar2 Pv_Ambiente            Si es generado por el usuario o por el job  
  * @Param varchar2 Pv_EmailUsrSesion      Email del usuario que genera el reporte.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 07-08-2017
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 08-09-2017 Se realiza cambio para que reporte se almacene el el dbserver para posteriormente ser enviado al fileserver.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 15-09-2017 Se realiza cambio en función utilizada para mover el rpt generado del dbserver al fileserver.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.3 23-01-2018 Se realiza cambio en extensión de archivo comprimido a formato .zip
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.4 28-02-2018 Se corrige ubicación de línea que genera el archivo comprimido en formato zip .
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.5 01-12-2017 Se agrega la columna de Ciclo de Facturación.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.6 02-09-2019 Se agrega columna CANCELACION VOLUNTARIA.
  *
  * @author Gustavo Narea <gnarea@telconet.ec>
  * @version 1.7 25-02-2022 Se sube el archivo zip al servidor nfs.
  */
  PROCEDURE P_GEN_REPORTE_BURO(
    Pv_Host                     IN  VARCHAR2,
    Pv_PathFileLogger           IN  VARCHAR2,
    Pv_NameFileLogger           IN  VARCHAR2,
    Pv_PrefijoEmpresa           IN  VARCHAR2, 
    Pv_IpSession                IN  VARCHAR2,
    Pv_UsuarioSession           IN  VARCHAR2,
    Pv_ValorClientesBuenos      IN  VARCHAR2,
    Pv_ValorClientesMalos       IN  VARCHAR2,
    Pv_DirectorioUpload         IN  VARCHAR2,
    Pv_Ambiente                 IN  VARCHAR2,
    Pv_EmailUsrSesion           IN  VARCHAR2
  );

END FNKG_REPORTE_FINANCIERO;

/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_REPORTE_FINANCIERO AS     
  --
  PROCEDURE P_REPORTE_COBRANZAS(
    Pv_TipoDocumento                IN  VARCHAR2,
    Pv_NumeroDocumento              IN  VARCHAR2,
    Pv_NumeroDocumentoAut           IN  VARCHAR2,
    Pv_UsrCreacion                  IN  VARCHAR2,
    Pv_EstadoDocumento              IN  VARCHAR2, 
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FormaPago                    IN  VARCHAR2,
    Pv_Banco                        IN  VARCHAR2,
    Pv_NumeroReferencia             IN  VARCHAR2,
    Pv_EstadoPunto                  IN  VARCHAR2,
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_UsrSesion                    IN  VARCHAR2,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_Start                        IN  VARCHAR2,
    Pv_Limit                        IN  VARCHAR2,
    Pv_FechaContabilizacionDesde    IN  VARCHAR2,
    Pv_FechaContabilizacionHasta    IN  VARCHAR2
  )
  IS
    --
    CURSOR C_ValidadorFechas(Lv_FechaAValidar VARCHAR2, Lv_FechaDeValidacion DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE)
    IS
      --
      SELECT
        CASE
          WHEN CAST(TO_DATE(Lv_FechaAValidar,'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE) 
                >= CAST(TO_DATE(Lv_FechaDeValidacion,'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
          THEN 'S'
          ELSE 'N'
        END AS VALIDADOR
      FROM
        DUAL;
  --
  Lv_Query                  VARCHAR2(30000):='';  
  Lv_BancoEmpresa           VARCHAR2(100)  :='';
  Lv_TipoDocumento          VARCHAR2(100)  :='';
  Lv_Directorio             VARCHAR2(50)   :='DIR_REPGERENCIA';
  Lv_NombreArchivo          VARCHAR2(50)   :='ReporteCobranzas'||Pv_PrefijoEmpresa||'_'
                                                               ||Pv_TipoDocumento||'_'
                                                               ||Pv_UsrSesion||'.csv';
  Lv_Delimitador            VARCHAR2(1)    :=';';
  Lv_Gzip                   VARCHAR2(100)  :='gzip /backup/repgerencia/'||Lv_NombreArchivo;
  Lv_Remitente              VARCHAR2(20)   :='telcos@telconet.ec';
  Lv_Destinatario           VARCHAR2(100)  :=NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
  Lv_Asunto                 VARCHAR2(300)  :='Notificacion REPORTE DE COBRANZAS '||Pv_TipoDocumento;
  Lv_Cuerpo                 VARCHAR2(9999) :='';
  Lv_NombreArchivoZip       VARCHAR2(50)   :=Lv_NombreArchivo||'.gz';
  Lv_NumeroDocumento        VARCHAR2(200)  :='';
  Lv_TipoDocumento_aut      VARCHAR2(100)  :='';
  Lv_OficinaCliente         VARCHAR2(200)  :='';
  Lv_EstadoDocumento        VARCHAR2(200)  :='Todos';
  Lv_FechaCreacionDesde     VARCHAR2(200)  :='Todos';
  Lv_FechaCreacionHasta     VARCHAR2(200)  :='Todos';
  Lv_Monto                  VARCHAR2(200)  :='Todos';
  Lc_ReporteCobranzas       SYS_REFCURSOR;
  Lr_Datos    DB_FINANCIERO.FNKG_TYPES.Lr_Cobranza;
  Lr_DatosAts DB_FINANCIERO.FNKG_TYPES.Lr_Pago;
  Lc_GetAliasPlantilla      FNKG_TYPES.Lr_AliasPlantilla;
  Lfile_Archivo utl_file.file_type;
  Lv_FechaContabilizacionDesde VARCHAR2(200) := 'Todos';
  Lv_FechaContabilizacionHasta VARCHAR2(200) := 'Todos';
  Lv_CabeceraDocumentoProceso  VARCHAR2(100) := 'DOCUMENTO';
  Lv_EstadoPunto               VARCHAR2(200) :='';
  --
  Lv_DescripcionPunto         DB_COMERCIAL.INFO_PUNTO.DESCRIPCION_PUNTO%TYPE                := '';
  Lv_ComentarioPago           DB_FINANCIERO.INFO_PAGO_CAB.COMENTARIO_PAGO%TYPE              := '';
  Lv_ComentarioDetallePago    DB_FINANCIERO.INFO_PAGO_DET.COMENTARIO%TYPE                   := '';
  Lv_EstadoActivo             DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                     := 'Activo';
  Lv_CabReportesContabilidad  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE           := 'REPORTES_CONTABILIDAD';
  Lv_DetCodigoFormasPago      DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                := 'CODIGOS_FORMA_PAGO';
  Lv_DetCodigoTipoDocumento   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                := 'CODIGOS_TIPO_DOCUMENTO';
  Lv_DetFechaValidacion       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                     := 'FECHA_VALIDACION';
  Lv_ValidadorFechas          VARCHAR(2)                                                    := 'N';
  Lv_ProcesoIndividual        DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_PROCESO%TYPE   := 'INDIVIDUAL';
  Lv_ProcesoIndividualCruce   DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_PROCESO%TYPE   := 'INDIVIDUAL-CRUCE-ANT';
  Lv_DetTipoFormasPago        DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                := 'TIPOS_FORMA_PAGO';
  Ln_BandFechaContabilidad    NUMBER                                                        := 0;
  Lv_CabFechaContabilidad     VARCHAR2(100)                                                 := '';
  Lv_DetFechaContabilidad     VARCHAR2(100)                                                 := '';
  Lv_TablaCabeceraNaf         DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE := '';
  Lrf_GetAdmiParamtrosDet     SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  --
  --Variable usada para válidar si se deben mostrar los anticipos que han sido cruzados antes de esta fecha, en la cual se implemento una mejora al
  --proceso de cruce de anticipos
  Lv_FechaCruceAnticipos      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                     := '01/02/17';
  --
  BEGIN
    IF Pv_UsrSesion = 'JOB_MENSUAL' THEN
      Lv_NombreArchivo    := 'ReporteCobranzas'||Pv_PrefijoEmpresa||'_'
                                                               ||Pv_TipoDocumento||'_'
                                                               ||'MENSUAL'||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE DE COBRANZAS '||Pv_TipoDocumento||' MENSUAL';
    END IF;
    IF Pv_UsrSesion = 'JOB_DIARIO' THEN
      Lv_NombreArchivo    := 'ReporteCobranzas'||Pv_PrefijoEmpresa||'_'
                                                               ||Pv_TipoDocumento||'_'
                                                               ||'DIARIO'||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE DE COBRANZAS '||Pv_TipoDocumento||' DIARIO';
    END IF;
    --
    IF Pv_TipoDocumento IS NOT NULL THEN
      --
      CASE Pv_TipoDocumento
        --
        WHEN 'PAG' THEN
          --
          Lv_TipoDocumento :='Pago';
          --
        WHEN 'ANT' THEN 
          --
          Lv_TipoDocumento   :='Anticipo';
          --
        WHEN 'ANTS' THEN
          --
          Lv_TipoDocumento   :='Anticipo sin cliente';
          --
        WHEN 'PAGC' THEN 
          --
          Lv_TipoDocumento   :='Pago por Cruce';
          --
        WHEN 'ANTC' THEN
          --
          Lv_TipoDocumento   :='Anticipo por Cruce';
          --
        WHEN 'P_PAG' THEN 
          --
          Lv_TipoDocumento            := 'Pagos Manuales';
          Lv_CabeceraDocumentoProceso := 'PROCESO';
          --
        WHEN 'P_PAG_RET' THEN 
          --
          Lv_TipoDocumento            := 'Pagos Masivos';
          Lv_CabeceraDocumentoProceso := 'PROCESO';
          --
        WHEN 'P_DEB' THEN 
          --
          Lv_TipoDocumento            := 'Debitos';
          Lv_CabeceraDocumentoProceso := 'PROCESO';  
          --
        WHEN 'P_DEP' THEN 
          --
          Lv_TipoDocumento            := 'Depositos';
          Lv_CabeceraDocumentoProceso := 'PROCESO'; 
          --
        WHEN 'P_ANT_CRUCE' THEN 
          --
          Lv_TipoDocumento            := 'Cruce de Anticipos';
          Lv_CabeceraDocumentoProceso := 'PROCESO';
          --
        WHEN 'P_PAG_HISTO' THEN 
          --
          Lv_TipoDocumento            := 'Pagos';
          Lv_CabeceraDocumentoProceso := 'PROCESO';
          --
        WHEN 'P_ANT_HISTO' THEN 
          --
          Lv_TipoDocumento            := 'Anticipos';
          Lv_CabeceraDocumentoProceso := 'PROCESO';
          --
      END CASE;
      --
    END IF; 
    --
    --
    IF Pv_TipoDocumento = 'ANTS'  THEN
      --
      Lv_Query:= 'SELECT
                  IPC.ID_PAGO AS ID_DOCUMENTO,
                  IPD.ID_PAGO_DET AS ID_DOCUMENTO_DETALLE, 
                  IPC.OFICINA_ID,
                  IPC.NUMERO_PAGO AS NUMERO_DOCUMENTO, 
                  IPC.VALOR_TOTAL AS VALOR_TOTAL_GLOBAL, 
                  IPC.ESTADO_PAGO AS ESTADO_DOCUMENTO_GLOBAL,
                  DBMS_LOB.SUBSTR(IPC.COMENTARIO_PAGO, 2000, 1 ) AS COMENTARIO_PAGO,
                  IPD.FE_CREACION,
                  TO_CHAR(IPD.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_CREACION,
                  IPD.VALOR_PAGO AS VALOR_TOTAL, 
                  IPD.DEPOSITADO, 
                  IPD.BANCO_TIPO_CUENTA_ID, 
                  IPD.BANCO_CTA_CONTABLE_ID, 
                  IPD.REFERENCIA_ID, 
                  IPD.NUMERO_REFERENCIA, 
                  IPD.NUMERO_CUENTA_BANCO, 
                  IPD.USR_CREACION,
                  DBMS_LOB.SUBSTR(IPD.COMENTARIO, 2000, 1 ) AS COMENTARIO_DETALLE_PAGO, 
                  IPD.FE_DEPOSITO, 
                  CASE WHEN IPD.DEPOSITADO = ''S''THEN 
                    TO_CHAR(IDEP.FE_DEPOSITO, ''DD-MM-YYYY HH24:MI:SS'') 
                  ELSE TO_CHAR(IPD.FE_DEPOSITO, ''DD-MM-YYYY HH24:MI:SS'')             
                  END AS FECHA_DEPOSITO,                    
                  FP.ID_FORMA_PAGO, 
                  FP.DESCRIPCION_FORMA_PAGO, 
                  FP.ES_DEPOSITABLE, 
                  ATDF.CODIGO_TIPO_DOCUMENTO, 
                  ATDF.NOMBRE_TIPO_DOCUMENTO, 
                  IPC.FE_CRUCE,
                  TO_CHAR(IPC.FE_CRUCE, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_CRUCE,
                  FNCK_CONSULTS.F_GET_BANCO(IPD.BANCO_CTA_CONTABLE_ID) AS BANCO,
                  FNCK_CONSULTS.F_GET_BANCO_TC(IPD.BANCO_TIPO_CUENTA_ID)  AS BANCO_TC,
                  FNCK_CONSULTS.F_GET_BANCO_EMPRESA(IPD.BANCO_CTA_CONTABLE_ID, NULL) AS BANCO_EMPRESA,
                  IOGI.NOMBRE_OFICINA AS OFICINA_CLIENTE,
                  DB_FINANCIERO.FNCK_CONSULTS.F_GET_NUMERO_COMPROBANTE(IPD.ID_PAGO_DET, FP.CODIGO_FORMA_PAGO,''N'') AS NUMERO_COMPROBANTE,
                  DB_FINANCIERO.FNCK_ARCHIVO_IMPRESION.F_INFORMACION_SERVICIOS(IPC.PUNTO_ID) AS SERVICIOS,
                  FNCK_CONSULTS.F_GET_TIPO_CTA(IPD.BANCO_TIPO_CUENTA_ID) AS TIPO_CTA,                  
                  FNCK_CONSULTS.F_GET_CTA_CONTABLE(IPD.BANCO_CTA_CONTABLE_ID) AS TIPO_CTA_CONTABLE 
              FROM
                   DB_FINANCIERO.INFO_PAGO_CAB IPC
                   LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOGI ON IOGI.ID_OFICINA = IPC.OFICINA_ID,
                   DB_FINANCIERO.INFO_PAGO_DET IPD
                   LEFT JOIN DB_FINANCIERO.INFO_DEPOSITO IDEP ON IDEP.ID_DEPOSITO = IPD.DEPOSITO_PAGO_ID,
                   DB_GENERAL.ADMI_FORMA_PAGO FP,
                   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
              WHERE
                   IPC.ID_PAGO = IPD.PAGO_ID AND
                   IPC.EMPRESA_ID = ' || Pv_EmpresaCod ||' AND 
                   IPD.FORMA_PAGO_ID = FP.ID_FORMA_PAGO AND 
                   IPC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO ' ;
        --
      ELSE
        --
        Lv_Query:= 'SELECT
                      IPC.ID_PAGO AS ID_DOCUMENTO,
                      DB_FINANCIERO.FNCK_ARCHIVO_IMPRESION.F_INFORMACION_SERVICIOS(IPC.PUNTO_ID) AS SERVICIOS,
                      IPD.ID_PAGO_DET AS ID_DOCUMENTO_DETALLE, 
                      IPC.OFICINA_ID,
                      IPC.NUMERO_PAGO AS NUMERO_DOCUMENTO, 
                      IPC.VALOR_TOTAL AS VALOR_TOTAL_GLOBAL, ';
      --
      --
      IF ( Pv_TipoDocumento = 'P_PAG_HISTO' OR Pv_TipoDocumento = 'P_ANT_HISTO' ) AND Pv_FechaContabilizacionDesde IS NOT NULL 
         AND Pv_FechaContabilizacionHasta IS  NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_HISTORIAL_PAGO_ANTICIPO(IPC.ID_PAGO, IPC.ESTADO_PAGO, '''
                             || Pv_FechaContabilizacionDesde || ''', ''' || Pv_FechaContabilizacionHasta || ''', ''ESTADO'' ) AS  '
                             || ' ESTADO_DOCUMENTO_GLOBAL, ';
        --
      ELSE
        --
        Lv_Query := Lv_Query || ' IPC.ESTADO_PAGO AS ESTADO_DOCUMENTO_GLOBAL, ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query || ' DBMS_LOB.SUBSTR(IPC.COMENTARIO_PAGO, 2000, 1 ) AS COMENTARIO_PAGO,
                                IPD.FE_CREACION,
                                TO_CHAR(IPD.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_CREACION,
                                IPD.VALOR_PAGO AS VALOR_TOTAL, 
                                IPD.DEPOSITADO, 
                                IPD.BANCO_TIPO_CUENTA_ID, 
                                IPD.BANCO_CTA_CONTABLE_ID, 
                                IPD.REFERENCIA_ID, 
                                IPD.NUMERO_REFERENCIA, 
                                IPD.NUMERO_CUENTA_BANCO, 
                                IPD.USR_CREACION,
                                DBMS_LOB.SUBSTR(IPD.COMENTARIO, 2000, 1 ) AS COMENTARIO_DETALLE_PAGO, 
                                IPD.FE_DEPOSITO, 
                                CASE WHEN IPD.DEPOSITADO = ''S''THEN 
                                  TO_CHAR(IDEP.FE_DEPOSITO, ''DD-MM-YYYY HH24:MI:SS'') 
                                ELSE TO_CHAR(IPD.FE_DEPOSITO, ''DD-MM-YYYY HH24:MI:SS'')             
                                END AS FECHA_DEPOSITO,   
                                FP.ID_FORMA_PAGO, 
                                FP.DESCRIPCION_FORMA_PAGO, 
                                FP.ES_DEPOSITABLE, 
                                ATDF.CODIGO_TIPO_DOCUMENTO, 
                                ATDF.NOMBRE_TIPO_DOCUMENTO, 
                                IPTO.ID_PUNTO, 
                                IPTO.LOGIN, 
                                IPTO.NOMBRE_PUNTO, 
                                IPTO.DIRECCION,
                                IPTO.DESCRIPCION_PUNTO, 
                                IPTO.ESTADO, 
                                IPTO.USR_VENDEDOR, 
                                PER.ID_PERSONA, 
                                PER.IDENTIFICACION_CLIENTE, 
                                PER.NOMBRES AS NOMBRE_CLIENTE, 
                                PER.APELLIDOS AS APELLIDOS_CLIENTE, 
                                PER.RAZON_SOCIAL AS RAZON_SOCIAL_CLIENTE, 
                                PER.DIRECCION AS DIRECCION_CLIENTE, 
                                DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC(''CICLO_FACTURACION'',PEROL.ID_PERSONA_ROL) 
                                AS CICLO_FACTURACION,
                                PER.CALIFICACION_CREDITICIA,
                                IDEP.FE_PROCESADO,
                                TO_CHAR(IDEP.FE_PROCESADO, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_PROCESADO,
                                IDEP.NO_COMPROBANTE_DEPOSITO,
                                IPC.FE_CRUCE,
                                TO_CHAR(IPC.FE_CRUCE, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_CRUCE,
                                IPD.CUENTA_CONTABLE_ID,
                                FNCK_CONSULTS.F_GET_BANCO(IPD.BANCO_CTA_CONTABLE_ID) AS BANCO,
                                FNCK_CONSULTS.F_GET_BANCO_TC(IPD.BANCO_TIPO_CUENTA_ID)  AS BANCO_TC,
                                FNCK_CONSULTS.F_GET_BANCO_EMPRESA(IPD.BANCO_CTA_CONTABLE_ID, NULL) AS BANCO_EMPRESA,
                                FNCK_CONSULTS.F_GET_BANCO_EMPRESA_DEP(IDEP.CUENTA_CONTABLE_ID) AS BANCO_EMPRESA_DEP,
                                FNCK_CONSULTS.F_GET_BANCO_EMPRESA_DEP_NAF(IDEP.BANCO_NAF_ID) AS BANCO_EMPRESA_DEP_NAF,
                                ATDFF.NOMBRE_TIPO_DOCUMENTO AS  TIPO_DOCUMENTO_AUT,
                                IDFC.NUMERO_FACTURA_SRI AS NUMERO_DOCUMENTO_AUT,
                                TO_CHAR(IDFC.FE_EMISION, ''DD-MM-YYYY'') AS FECHA_EMISION,
                                FNKG_CARTERA_CLIENTES.F_NOMBRE_EJECUTIVO_COBRANZAS(IPD.USR_CREACION) AS USUARIO_CREACION,
                                IOGI.NOMBRE_OFICINA AS OFICINA_CLIENTE,
                                DB_FINANCIERO.FNCK_CONSULTS.F_GET_NUMERO_COMPROBANTE(IPD.ID_PAGO_DET, FP.CODIGO_FORMA_PAGO,''N'') AS '
                           || ' NUMERO_COMPROBANTE, ';
        --
        --
        IF Pv_TipoDocumento IS NOT NULL AND Pv_TipoDocumento = 'P_DEB' THEN
          --
          Lv_Query := Lv_Query || ' TRIM(FNCK_CONSULTS.F_GET_BANCO_EMPRESA(NULL, IDGH.CUENTA_CONTABLE_ID)) AS DESCRIPCION_CTA_CONTABLE, '
                               || ' IDGH.FE_DOCUMENTO, '
                               || ' IDGH.FE_CREACION, ';
          --
        ELSE
          --
          Lv_Query := Lv_Query || ' TRIM(FNCK_CONSULTS.F_GET_BANCO_EMPRESA(NULL, IPD.CUENTA_CONTABLE_ID)) AS DESCRIPCION_CTA_CONTABLE, '
                               || ' NULL, '
                               || ' NULL, ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || 'IDEP.FE_CREACION AS FECHA_CREACION_DEPOSITO,
                                 FNCK_CONSULTS.F_GET_CTA_CONTABLE(IPD.BANCO_CTA_CONTABLE_ID) AS TIPO_CTA_CONTABLE,
                                 FNCK_CONSULTS.F_GET_TIPO_CTA(IPD.BANCO_TIPO_CUENTA_ID) AS TIPO_CTA 
                                 FROM
                                      DB_FINANCIERO.INFO_PAGO_CAB IPC
                                 JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOGI ON IOGI.ID_OFICINA=IPC.OFICINA_ID
                                 JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEGI ON IEGI.COD_EMPRESA=IOGI.EMPRESA_ID 
                                 AND  IEGI.COD_EMPRESA=''' || Pv_EmpresaCod ||''',
                                      DB_FINANCIERO.INFO_PAGO_DET IPD 
                                 LEFT JOIN DB_FINANCIERO.INFO_DEPOSITO IDEP ON IDEP.ID_DEPOSITO = IPD.DEPOSITO_PAGO_ID
                                 LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC 
                                      ON IDFC.ID_DOCUMENTO = IPD.REFERENCIA_ID
                                 LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDFF 
                                      ON ATDFF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID,
                                      DB_GENERAL.ADMI_FORMA_PAGO FP,
                                      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                                      DB_COMERCIAL.INFO_PERSONA PER,
                                      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEROL,
                                      DB_COMERCIAL.INFO_PUNTO IPTO ';
        --
        --
        IF Pv_TipoDocumento IS NOT NULL AND Pv_TipoDocumento = 'P_DEB' THEN
          --
          Lv_Query := Lv_Query || ', DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL IDGH ';
          --
        END IF; 
        --
        --
        Lv_Query := Lv_Query || 'WHERE IPC.ID_PAGO = IPD.PAGO_ID AND
                                 IPC.EMPRESA_ID = ' || Pv_EmpresaCod ||' AND 
                                 IPD.FORMA_PAGO_ID = FP.ID_FORMA_PAGO AND 
                                 IPC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO AND 
                                 PEROL.ID_PERSONA_ROL = IPTO.PERSONA_EMPRESA_ROL_ID AND 
                                 PER.ID_PERSONA = PEROL.PERSONA_ID AND 
                                 IPC.PUNTO_ID = IPTO.ID_PUNTO ' ;
        --
      END IF;
      --
      --
      IF Pv_TipoDocumento IS NOT NULL THEN
        --
        IF Lv_CabeceraDocumentoProceso != 'PROCESO' THEN
          --
          Lv_Query := Lv_Query || ' AND ATDF.CODIGO_TIPO_DOCUMENTO = '''||Pv_TipoDocumento||'''';
          --
        ELSIF Pv_TipoDocumento = 'P_PAG' THEN
          --
          Lv_Query := Lv_Query || ' AND IPC.DEBITO_GENERAL_HISTORIAL_ID IS NULL '
                               || ' AND ATDF.CODIGO_TIPO_DOCUMENTO NOT IN ( '
                               || '                                         SELECT APD.VALOR2 '
                               || '                                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC '
                               || '                                         JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '
                               || '                                         ON APC.ID_PARAMETRO = APD.PARAMETRO_ID '
                               || '                                         WHERE APC.ESTADO           = ''' || Lv_EstadoActivo || ''' '
                               || '                                         AND APD.ESTADO             = ''' || Lv_EstadoActivo || ''' '
                               || '                                         AND APC.NOMBRE_PARAMETRO   = ''' || Lv_CabReportesContabilidad || ''' '
                               || '                                         AND APD.DESCRIPCION        = ''' || Lv_DetCodigoTipoDocumento || ''' '
                               || '                                         AND APD.VALOR1             = ''' || Pv_TipoDocumento || ''' '
                               || '                                       ) '
                               || ' AND FP.ID_FORMA_PAGO IN ( '
                               || '   SELECT AFP_S.ID_FORMA_PAGO '
                               || '   FROM DB_GENERAL.ADMI_FORMA_PAGO AFP_S '
                               || '   WHERE AFP_S.ES_DEPOSITABLE = ''S'''
                               || '   UNION ALL '
                               || '   SELECT AFP_SS.ID_FORMA_PAGO '
                               || '   FROM DB_GENERAL.ADMI_FORMA_PAGO AFP_SS '
                               || '   WHERE AFP_SS.ES_DEPOSITABLE = ''N'''
                               || '   AND AFP_SS.TIPO_FORMA_PAGO IN ( '
                               || '                                   SELECT APD.VALOR2 '
                               || '                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC '
                               || '                                   JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '
                               || '                                   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID '
                               || '                                   WHERE APC.ESTADO           = ''' || Lv_EstadoActivo || ''' '
                               || '                                   AND APD.ESTADO             = ''' || Lv_EstadoActivo || ''' '
                               || '                                   AND APC.NOMBRE_PARAMETRO   = ''' || Lv_CabReportesContabilidad || ''' '
                               || '                                   AND APD.DESCRIPCION        = ''' || Lv_DetTipoFormasPago || ''' '
                               || '                                   AND APD.VALOR1             = ''' || Pv_TipoDocumento || ''' '
                               || '                                 ) '
                               || '                         ) ';
          --
        ELSIF Pv_TipoDocumento = 'P_DEB' THEN
          --
          Lv_Query := Lv_Query || ' AND IPC.DEBITO_GENERAL_HISTORIAL_ID = IDGH.ID_DEBITO_GENERAL_HISTORIAL ';
          --
        ELSIF Pv_TipoDocumento = 'P_DEP' THEN
          --
          Lv_Query := Lv_Query || ' AND IPC.ANTICIPO_ID IS NULL ';
          --
        ELSIF Pv_TipoDocumento = 'P_PAG_RET' THEN
          --
          Lv_Query := Lv_Query || ' AND FP.ID_FORMA_PAGO NOT IN ( '
                               || '   SELECT AFP_S.ID_FORMA_PAGO '
                               || '   FROM DB_GENERAL.ADMI_FORMA_PAGO AFP_S '
                               || '   WHERE AFP_S.ES_DEPOSITABLE = ''S'''
                               || '   UNION ALL '
                               || '   SELECT AFP_SS.ID_FORMA_PAGO '
                               || '   FROM DB_GENERAL.ADMI_FORMA_PAGO AFP_SS '
                               || '   WHERE AFP_SS.ES_DEPOSITABLE = ''N'''
                               || '   AND AFP_SS.TIPO_FORMA_PAGO IN ( '
                               || '                                   SELECT APD.VALOR2 '
                               || '                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC '
                               || '                                   JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '
                               || '                                   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID '
                               || '                                   WHERE APC.ESTADO           = ''' || Lv_EstadoActivo || ''' '
                               || '                                   AND APD.ESTADO             = ''' || Lv_EstadoActivo || ''' '
                               || '                                   AND APC.NOMBRE_PARAMETRO   = ''' || Lv_CabReportesContabilidad || ''' '
                               || '                                   AND APD.DESCRIPCION        = ''' || Lv_DetTipoFormasPago || ''' '
                               || '                                   AND APD.VALOR1             = ''' || Pv_TipoDocumento || ''' '
                               || '                                 ) '
                               || '                              ) '
                               || ' AND FP.ESTADO = ''Activo'' AND FP.VISIBLE_EN_PAGO = ''S'' ';
          --
        END IF;
        --
        --
        IF TRIM(Lv_CabeceraDocumentoProceso) IS NOT NULL AND Lv_CabeceraDocumentoProceso = 'PROCESO' THEN
          --
          IF (Pv_TipoDocumento = 'P_DEB' OR Pv_TipoDocumento = 'P_PAG_RET') AND Lv_DetCodigoFormasPago = 'CODIGOS_FORMA_PAGO' THEN
            --
            Lv_Query := Lv_Query || ' AND FP.CODIGO_FORMA_PAGO IN ( '
                                 || '                               SELECT APD.VALOR2 '
                                 || '                               FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC '
                                 || '                               JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '
                                 || '                               ON APC.ID_PARAMETRO = APD.PARAMETRO_ID '
                                 || '                               WHERE APC.ESTADO           = ''' || Lv_EstadoActivo || ''' '
                                 || '                               AND APD.ESTADO             = ''' || Lv_EstadoActivo || ''' '
                                 || '                               AND APC.NOMBRE_PARAMETRO   = ''' || Lv_CabReportesContabilidad || ''' '
                                 || '                               AND APD.DESCRIPCION        = ''' || Lv_DetCodigoFormasPago || ''' '
                                 || '                               AND APD.VALOR1             = ''' || Pv_TipoDocumento || ''' '
                                 || '                             ) ';
            --
          END IF;
          --
          --
          IF ( Pv_TipoDocumento = 'P_ANT_CRUCE' OR Pv_TipoDocumento = 'P_PAG_HISTO' OR Pv_TipoDocumento = 'P_ANT_HISTO' ) 
             AND Lv_DetCodigoTipoDocumento = 'CODIGOS_TIPO_DOCUMENTO' THEN
            --
            Lv_Query := Lv_Query || ' AND ATDF.CODIGO_TIPO_DOCUMENTO IN ( '
                                 || '                                     SELECT APD.VALOR2 '
                                 || '                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC '
                                 || '                                     JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '
                                 || '                                     ON APC.ID_PARAMETRO = APD.PARAMETRO_ID '
                                 || '                                     WHERE APC.ESTADO           = ''' || Lv_EstadoActivo || ''' '
                                 || '                                     AND APD.ESTADO             = ''' || Lv_EstadoActivo || ''' '
                                 || '                                     AND APC.NOMBRE_PARAMETRO   = ''' || Lv_CabReportesContabilidad || ''' '
                                 || '                                     AND APD.DESCRIPCION        = ''' || Lv_DetCodigoTipoDocumento || ''' '
                                 || '                                     AND APD.VALOR1             = ''' || Pv_TipoDocumento || ''' '
                                 || '                                   ) ';
            --
          END IF;          
          --
        END IF;
        --
      END IF;
      --
      --
      IF Pv_NumeroDocumentoAut IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND (( SELECT COUNT(IDFC.ID_DOCUMENTO) 
                                         FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                                         WHERE IPD.REFERENCIA_ID = IDFC.ID_DOCUMENTO AND 
                                               IDFC.NUMERO_FACTURA_SRI LIKE ''%' || Pv_NumeroDocumentoAut || '%''
                                       ) > 0 
                                      )';
        --
      END IF;

      IF Pv_Banco IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND (
                                       ( SELECT COUNT(BTC.ID_BANCO_TIPO_CUENTA) 
                                         FROM DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BTC,DB_GENERAL.ADMI_BANCO BCO
                                         WHERE IPD.BANCO_TIPO_CUENTA_ID = BTC.ID_BANCO_TIPO_CUENTA 
                                         AND BTC.BANCO_ID=BCO.ID_BANCO 
                                         AND BCO.ESTADO NOT LIKE ''Eliminado'' 
                                         AND BCO.ESTADO NOT LIKE ''Inactivo'' 
                                         AND BTC.ESTADO NOT LIKE ''Eliminado'' 
                                         AND BTC.ESTADO NOT LIKE ''Inactivo'' 
                                         AND BCO.ID_BANCO = ''' || Pv_Banco || ''' 
                                        ) > 0 
                                        OR ( SELECT COUNT(BCC.ID_BANCO_CTA_CONTABLE) 
                                             FROM  DB_GENERAL.ADMI_BANCO_CTA_CONTABLE BCC,
                                                   DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC,
                                                   DB_GENERAL.ADMI_BANCO AB 
                                             WHERE BCC.ID_BANCO_CTA_CONTABLE=IPD.BANCO_CTA_CONTABLE_ID 
                                             AND   BCC.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA 
                                             AND   ABTC.BANCO_ID=AB.ID_BANCO 
                                             AND   AB.ESTADO NOT LIKE ''Eliminado''   
                                             AND   AB.ESTADO NOT LIKE ''Inactivo''    
                                             AND   ABTC.ESTADO NOT LIKE ''Eliminado'' 
                                             AND   ABTC.ESTADO NOT LIKE ''Inactivo''  
                                             AND   AB.ID_banco = ''' || Pv_Banco || '''
                                            )>0
                                      )';
        --
      END IF;

      IF Pv_FechaContabilizacionDesde IS NOT NULL AND  Pv_FechaContabilizacionHasta IS  NOT NULL THEN
        --
        Lv_FechaContabilizacionDesde := Pv_FechaContabilizacionDesde;
        Lv_FechaContabilizacionHasta := Pv_FechaContabilizacionHasta;
        --
        --
        IF ( Pv_TipoDocumento = 'P_PAG_HISTO' OR Pv_TipoDocumento = 'P_ANT_HISTO' ) THEN
          --
          Lv_Query := Lv_Query || ' AND CAST(TO_DATE(DB_FINANCIERO.FNCK_CONSULTS.F_GET_HISTORIAL_PAGO_ANTICIPO(IPC.ID_PAGO, IPC.ESTADO_PAGO, '''
                               || Lv_FechaContabilizacionDesde || ''', ''' || Lv_FechaContabilizacionHasta || ''', ''HISTORIAL'' ),''DD/MM/YY'') '
                               || ' AS TIMESTAMP WITH LOCAL TIME ZONE) >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS '
                               || ' TIMESTAMP WITH LOCAL TIME ZONE) '
                               || ' AND CAST(TO_DATE(DB_FINANCIERO.FNCK_CONSULTS.F_GET_HISTORIAL_PAGO_ANTICIPO(IPC.ID_PAGO, IPC.ESTADO_PAGO, '''
                               || Lv_FechaContabilizacionDesde || ''', ''' || Lv_FechaContabilizacionHasta || ''', ''HISTORIAL'' ), ''DD/MM/YY'') '
                               || ' AS TIMESTAMP WITH LOCAL TIME ZONE) < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS '
                               || ' TIMESTAMP WITH LOCAL TIME ZONE)+1 ';
          --
        ELSIF Pv_TipoDocumento = 'P_PAG_RET' THEN
          --
          Lv_Query := Lv_Query || ' AND IPD.FE_CREACION >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                               || 'LOCAL TIME ZONE) '
                               || ' AND IPD.FE_CREACION < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                              || 'LOCAL TIME ZONE)+1 ';
          --
        ELSE
          --
          Lr_GetAdmiParamtrosDet := NULL;
          Lv_ValidadorFechas     := NULL;
          --
          --
          IF Lrf_GetAdmiParamtrosDet%ISOPEN THEN
            --
            CLOSE Lrf_GetAdmiParamtrosDet;
            --
          END IF;
          --
          --
          Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_CabReportesContabilidad, 
                                                                                            Lv_EstadoActivo, 
                                                                                            Lv_EstadoActivo, 
                                                                                            Lv_DetFechaValidacion, 
                                                                                            Pv_TipoDocumento, 
                                                                                            NULL, 
                                                                                            NULL );
          --
          FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
          --
          CLOSE Lrf_GetAdmiParamtrosDet;
          --
          --
          IF TRIM(Lr_GetAdmiParamtrosDet.VALOR3) IS NOT NULL THEN
            --
            Lv_FechaCruceAnticipos := TRIM(Lr_GetAdmiParamtrosDet.VALOR3);
            --
            IF C_ValidadorFechas%ISOPEN THEN
              --
              CLOSE C_ValidadorFechas;
              --
            END IF;
            --
            --
            OPEN C_ValidadorFechas(Lv_FechaContabilizacionDesde, TRIM(Lr_GetAdmiParamtrosDet.VALOR3));
            --
            FETCH C_ValidadorFechas INTO Lv_ValidadorFechas;
            --
            CLOSE C_ValidadorFechas;
            --
          END IF;
          --
          --
          IF Lv_ValidadorFechas IS NULL OR Lv_ValidadorFechas = 'N' THEN
            --
            IF Pv_TipoDocumento = 'P_DEP' THEN
              --
              Lv_Query := Lv_Query || ' AND IDEP.FE_PROCESADO >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                                   || 'LOCAL TIME ZONE) '
                                   || ' AND IDEP.FE_PROCESADO < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                                  || 'LOCAL TIME ZONE)+1 ';
              --
            ELSIF Pv_TipoDocumento = 'P_DEB' THEN
              --
              Lv_Query := Lv_Query || ' AND IDGH.FE_DOCUMENTO >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP '
                                   || ' WITH LOCAL TIME ZONE) '
                                   || ' AND IDGH.FE_DOCUMENTO < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP '
                                   || ' WITH LOCAL TIME ZONE)+1 ';
              --
            ELSIF Pv_TipoDocumento = 'P_ANT_CRUCE' THEN
              --
              Lv_Query := Lv_Query || ' AND  DECODE( DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB(''' || Pv_EmpresaCod ||''','
                          || ' FP.ID_FORMA_PAGO, ATDF.CODIGO_TIPO_DOCUMENTO, ''' || Lv_ProcesoIndividualCruce || ''', ''' || Lv_EstadoActivo
                          || ''' ), ''MIGRA_ARCKMM'', IPD.FE_DEPOSITO, ''MIGRA_ARCGAE'', IPD.FE_CREACION, IPD.FE_CREACION ) >=  CAST(TO_DATE('
                          || '''' || Lv_FechaContabilizacionDesde || ''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) '
                          || ' AND  DECODE( DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB(''' || Pv_EmpresaCod ||''','
                          || ' FP.ID_FORMA_PAGO, ATDF.CODIGO_TIPO_DOCUMENTO, ''' || Lv_ProcesoIndividualCruce || ''', ''' || Lv_EstadoActivo 
                          || ''' ), ''MIGRA_ARCKMM'', IPD.FE_DEPOSITO, ''MIGRA_ARCGAE'', IPD.FE_CREACION, IPD.FE_CREACION ) <  CAST(TO_DATE('
                          || '''' || Lv_FechaContabilizacionHasta || ''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE)+1 '
                          || ' AND IPC.FE_CRUCE IS NOT NULL AND CAST(IPC.FE_CRUCE AS TIMESTAMP WITH LOCAL TIME ZONE) < '
                          || ' CAST(TO_DATE( ''' || Lv_FechaCruceAnticipos || ''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ';
              --
            ELSE
              --
              Lv_Query := Lv_Query || ' AND  DECODE( DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB(''' || Pv_EmpresaCod ||''','
                          || ' FP.ID_FORMA_PAGO, ATDF.CODIGO_TIPO_DOCUMENTO, ''' || Lv_ProcesoIndividual || ''', ''' || Lv_EstadoActivo || ''')'
                          || ', ''MIGRA_ARCKMM'', IPD.FE_DEPOSITO, ''MIGRA_ARCGAE'', IPD.FE_CREACION, IPD.FE_CREACION ) >=  CAST(TO_DATE('
                          || '''' || Lv_FechaContabilizacionDesde || ''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) '
                          || ' AND  DECODE( DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB(''' || Pv_EmpresaCod ||''','
                          || ' FP.ID_FORMA_PAGO, ATDF.CODIGO_TIPO_DOCUMENTO, ''' || Lv_ProcesoIndividual || ''', ''' || Lv_EstadoActivo || ''')'
                          || ', ''MIGRA_ARCKMM'', IPD.FE_DEPOSITO, ''MIGRA_ARCGAE'', IPD.FE_CREACION, IPD.FE_CREACION ) <  CAST(TO_DATE('
                          || '''' || Lv_FechaContabilizacionHasta || ''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE)+1 ';
              --
            END IF;
            --
          ELSE
            --
            IF Pv_TipoDocumento = 'P_DEP' THEN
              --
              Lv_Query := Lv_Query || ' AND IDEP.FE_CREACION >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                                 || 'LOCAL TIME ZONE) '
                                   || ' AND IDEP.FE_CREACION < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                                 || 'LOCAL TIME ZONE)+1 ';
              --
            ELSIF Pv_TipoDocumento = 'P_DEB' THEN
              --
              Lv_Query := Lv_Query || ' AND IDGH.FE_CREACION >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                                  || 'LOCAL TIME ZONE) '
                                   || ' AND IDGH.FE_CREACION < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                                                  || 'LOCAL TIME ZONE)+1 ';
              --
            ELSIF Pv_TipoDocumento = 'P_ANT_CRUCE' THEN
              --
              Lv_Query := Lv_Query || ' AND IPC.FE_CRUCE >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                   || 'LOCAL TIME ZONE) '
                                   || ' AND IPC.FE_CRUCE < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                   || 'LOCAL TIME ZONE)+1 ';
              --
            ELSE
              --
              Lv_Query := Lv_Query || ' AND IPD.FE_CREACION >= CAST(TO_DATE('''||Lv_FechaContabilizacionDesde||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                   || 'LOCAL TIME ZONE) '
                                   || ' AND IPD.FE_CREACION < CAST(TO_DATE('''||Lv_FechaContabilizacionHasta||''',''DD/MM/YY'') AS TIMESTAMP WITH '
                                   || 'LOCAL TIME ZONE)+1 ';
              --
            END IF;
            --
          END IF;
          --
        END IF;
        --
      END IF;

      IF Pv_FechaCreacionDesde IS NOT NULL AND  Pv_FechaCreacionHasta IS  NOT NULL THEN
        Lv_FechaCreacionDesde   := Pv_FechaCreacionDesde;
        Lv_FechaCreacionHasta   := Pv_FechaCreacionHasta;  
        Lv_FechaCreacionHasta   := TO_CHAR(TO_DATE( Lv_FechaCreacionHasta ,'DD/MM/YYYY') - 1, 'DD/MM/YYYY');
        --
        Lv_Query := Lv_Query || '  AND IPD.FE_CREACION BETWEEN TO_DATE('''||Pv_FechaCreacionDesde||''',''DD/MM/YY'')
                                   AND TO_DATE('''||Pv_FechaCreacionHasta||''',''DD/MM/YY'')' ;
      END IF;

      IF Pv_FormaPago IS NOT NULL AND Pv_FormaPago <> 'ALL' THEN
        --
        Lv_Query := Lv_Query || ' AND FP.ID_FORMA_PAGO IN (' || Pv_FormaPago || ')';
        --
      END IF;

      IF Pv_NumeroDocumento IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPC.NUMERO_PAGO LIKE ''%' || Pv_NumeroDocumento || '%''';
        --
      END IF;

      IF Pv_NumeroReferencia IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPD.NUMERO__REFERENCIA LIKE ''%'    || Pv_NumeroReferencia || 
                                '%'' OR IPD.NUMERO__CUENTA_BANCO LIKE ''%'|| Pv_NumeroReferencia || '%''';
        --
      END IF;

      IF Pv_EstadoPunto IS NOT NULL THEN
        --
        IF Pv_EstadoPunto = 'ALL' THEN
          Lv_EstadoPunto := LOWER(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PARM_CONF('CONF_ESTADO_PUNTO'));
        ELSE
          Lv_EstadoPunto := LOWER(Pv_EstadoPunto);
        END IF;
        Lv_Query := Lv_Query || ' AND LOWER(IPTO.ESTADO) IN ('''||REPLACE(Lv_EstadoPunto,',',''',''')||''')';
        --
      END IF;

      IF Pv_EstadoDocumento IS NOT NULL AND Pv_EstadoDocumento <> 'ALL' THEN
        Lv_EstadoDocumento  := Pv_EstadoDocumento;
        Lv_Query := Lv_Query || ' AND IPD.ESTADO IN ('''||REPLACE(Pv_EstadoDocumento,',',''',''')||''')';
        --
      END IF;

      IF Pv_UsrCreacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPD.USR_CREACION LIKE ''%' ||Pv_UsrCreacion||'%''';
        --
      END IF;
      --
      --
      IF TRIM(Lv_CabeceraDocumentoProceso) IS NOT NULL AND TRIM(Lv_CabeceraDocumentoProceso) = 'PROCESO' THEN
        --
        Lv_CabFechaContabilidad  := 'FECHA CONTABILIZACION' || Lv_Delimitador;
        Ln_BandFechaContabilidad := 1;
        --
      END IF;
      --

  Lv_Query := Lv_Query || ' ORDER BY IPD.FE_CREACION DESC';

  Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
  Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
  Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivo,'w',3000);--Opening a file

   -- CABECERA DEL REPORTE
   utl_file.put_line(Lfile_Archivo,'USUARIO QUE GENERA: '||Pv_UsrSesion||Lv_Delimitador  
           ||' '||Lv_Delimitador 
           ||'FECHA DE GENERACION:  '||SYSDATE||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||'TIPO ' || Lv_CabeceraDocumentoProceso || ':  ' || Lv_TipoDocumento || Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||'# DOCUMENTO: '||Lv_NumeroDocumento||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||'VALOR DOCUMENTO: '||Lv_Monto||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
             );

    IF Lv_CabeceraDocumentoProceso != 'PROCESO' THEN
      --
      utl_file.put_line( Lfile_Archivo,'FECHA CREACION: '||Lv_Delimitador  
                         ||' '||Lv_Delimitador 
                         ||'DESDE: '||Lv_FechaCreacionDesde||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||'HASTA: '||Lv_FechaCreacionHasta||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador 
                         ||' '||Lv_Delimitador );
      --
    END IF;

    utl_file.put_line(Lfile_Archivo,'FECHA CONTABILIZACION: '||Lv_Delimitador  
           ||' '||Lv_Delimitador 
           ||'DESDE: '||Lv_FechaContabilizacionDesde||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||'HASTA: '||Lv_FechaContabilizacionHasta||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
            );

    IF Pv_TipoDocumento = 'P_DEP' THEN
      --
      utl_file.put_line(Lfile_Archivo, 'ID DOCUMENTO'||Lv_Delimitador 
                                       ||'ID DETALLE DOCUMENTO'||Lv_Delimitador 
                                       ||'TIPO DOCUMENTO'||Lv_Delimitador 
                                       ||'# DOCUMENTO'||Lv_Delimitador 
                                       ||'VALOR'||Lv_Delimitador 
                                       ||'FORMA PAGO'||Lv_Delimitador 
                                       ||'# REFERENCIA'||Lv_Delimitador 
                                       ||'COMENTARIO PAGO'||Lv_Delimitador 
                                       ||'COMENTARIO PAGO DET'||Lv_Delimitador 
                                       ||'BANCO'||Lv_Delimitador 
                                       ||'BANCO EMPRESA'||Lv_Delimitador 
                                       ||'LOGIN'||Lv_Delimitador  
                                       ||'ESTADO PTO CLIENTE'||Lv_Delimitador 
                                       ||'DESCRIPCION PTO CLIENTE'||Lv_Delimitador 
                                       ||'IDENTIFICACION'||Lv_Delimitador 
                                       ||'NOMBRES'||Lv_Delimitador 
                                       ||'APELLIDOS'||Lv_Delimitador 
                                       ||'RAZON SOCIAL CLIENTE'||Lv_Delimitador
                                       ||'CICLO FACTURACION'||Lv_Delimitador
                                       ||'TIPO DOCUMENTO AUT'||Lv_Delimitador 
                                       ||'# DOCUMENTO AUT'||Lv_Delimitador 
                                       ||'FECHA EMISION'||Lv_Delimitador 
                                       ||'USUARIO CREACION'||Lv_Delimitador
                                       ||'ESTADO'||Lv_Delimitador 
                                       ||'FECHA CREACION'||Lv_Delimitador 
                                       ||'FECHA DEPOSITO'||Lv_Delimitador 
                                       ||'FECHA PROCESADO'||Lv_Delimitador 
                                       ||'FECHA CRUCE'||Lv_Delimitador
                                       || Lv_CabFechaContabilidad
                                       ||'# COMPROBANTE'||Lv_Delimitador 
                                       ||'OFICINA'||Lv_Delimitador
                                       ||'DESCRIPCION PLAN'||Lv_Delimitador);
      --
    ELSE
      --
      utl_file.put_line(Lfile_Archivo, 'LOGIN'||Lv_Delimitador  
                                       ||'ESTADO PTO CLIENTE'||Lv_Delimitador 
                                       ||'DESCRIPCION PTO CLIENTE'||Lv_Delimitador 
                                       ||'IDENTIFICACION'||Lv_Delimitador 
                                       ||'NOMBRES'||Lv_Delimitador 
                                       ||'APELLIDOS'||Lv_Delimitador 
                                       ||'RAZON SOCIAL CLIENTE'||Lv_Delimitador 
                                       ||'CICLO FACTURACION'||Lv_Delimitador
                                       ||'ID DOCUMENTO'||Lv_Delimitador 
                                       ||'ID DETALLE DOCUMENTO'||Lv_Delimitador 
                                       ||'TIPO DOCUMENTO'||Lv_Delimitador 
                                       ||'# DOCUMENTO'||Lv_Delimitador 
                                       ||'VALOR'||Lv_Delimitador 
                                       ||'FORMA PAGO'||Lv_Delimitador 
                                       ||'# REFERENCIA'||Lv_Delimitador 
                                       ||'COMENTARIO PAGO'||Lv_Delimitador 
                                       ||'COMENTARIO PAGO DET'||Lv_Delimitador 
                                       ||'BANCO'||Lv_Delimitador 
                                       ||'TIPO CUENTA'||Lv_Delimitador
                                       ||'BANCO EMPRESA'||Lv_Delimitador 
                                       ||'TIPO DOCUMENTO AUT'||Lv_Delimitador 
                                       ||'# DOCUMENTO AUT'||Lv_Delimitador 
                                       ||'FECHA EMISION'||Lv_Delimitador 
                                       ||'USUARIO CREACION'||Lv_Delimitador
                                       ||'ESTADO'||Lv_Delimitador 
                                       ||'FECHA CREACION'||Lv_Delimitador 
                                       ||'FECHA DEPOSITO'||Lv_Delimitador 
                                       ||'FECHA PROCESADO'||Lv_Delimitador 
                                       ||'FECHA CRUCE'||Lv_Delimitador 
                                       || Lv_CabFechaContabilidad
                                       ||'# COMPROBANTE'||Lv_Delimitador 
                                       ||'OFICINA'||Lv_Delimitador
                                       ||'DESCRIPCION PLAN'||Lv_Delimitador);  
      --
    END IF;
    --
    --
  OPEN Lc_ReporteCobranzas FOR Lv_Query;

  IF Pv_TipoDocumento = 'ANTS' THEN
    LOOP
      FETCH Lc_ReporteCobranzas INTO Lr_DatosAts;     
        EXIT
        WHEN Lc_ReporteCobranzas%NOTFOUND; 
        utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador  
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||NVL(Lr_DatosAts.id_documento,0)||Lv_Delimitador 
             ||NVL(Lr_DatosAts.id_documento_detalle,0)||Lv_Delimitador 
             ||NVL(Lr_DatosAts.nombre_tipo_documento, '')||Lv_Delimitador 
             ||NVL(Lr_DatosAts.numero_documento, '')||Lv_Delimitador 
             ||NVL(Lr_DatosAts.valor_total, 0)||Lv_Delimitador 
             ||NVL(Lr_DatosAts.descripcion_forma_pago, '')||Lv_Delimitador 
             ||NVL(Lr_DatosAts.NUMERO_REFERENCIA, Lr_DatosAts.NUMERO_CUENTA_BANCO)||Lv_Delimitador 
             ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                REPLACE(
                                                REPLACE(
                                                REPLACE(
                                                  Lr_DatosAts.comentario_pago, Chr(9), ' '), Chr(10), ' '),
                                                  Chr(13), ' '))), '')||Lv_Delimitador 
             ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                REPLACE(
                                                REPLACE(
                                                REPLACE(
                                                  Lr_DatosAts.comentario_detalle_pago, Chr(9), ' '), Chr(10), ' '),
                                                  Chr(13), ' '))), '')||Lv_Delimitador 
             ||NVL(NVL(Lr_DatosAts.banco, Lr_DatosAts.banco_tc),'')||Lv_Delimitador 
             ||NVL(NVL(Lr_DatosAts.tipo_cta, Lr_DatosAts.tipo_cta_contable),'')||Lv_Delimitador
             ||NVL(Lv_BancoEmpresa, '')||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||''||Lv_Delimitador
             ||''||Lv_Delimitador
             ||NVL(Lr_DatosAts.usr_creacion, '') || Lv_Delimitador 
             ||NVL(Lr_DatosAts.estado_documento_global, '')||Lv_Delimitador 
             ||NVL(Lr_DatosAts.fecha_creacion, '')||Lv_Delimitador 
             ||NVL(Lr_DatosAts.fecha_deposito, '')||Lv_Delimitador 
             ||''||Lv_Delimitador 
             ||NVL(Lr_DatosAts.fecha_cruce, '')||Lv_Delimitador 
             || Lv_DetFechaContabilidad
             ||NVL(Lr_DatosAts.NUMERO_COMPROBANTE, '')||Lv_Delimitador 
             ||NVL(Lr_DatosAts.OFICINA_CLIENTE, '')||Lv_Delimitador  
             ||NVL(Lr_DatosAts.SERVICIOS, '')||Lv_Delimitador  
             );                           

    END LOOP; 
  ELSE
    LOOP
      FETCH Lc_ReporteCobranzas INTO Lr_Datos;
        EXIT
        WHEN Lc_ReporteCobranzas%NOTFOUND;
        --
        --
        Lv_ComentarioPago        := '';
        Lv_DescripcionPunto      := '';
        Lv_ComentarioDetallePago := '';
        Lv_BancoEmpresa          := '';
        Lv_DetFechaContabilidad  := '' || Lv_Delimitador;
        Lv_TablaCabeceraNaf      := '';
        --
        --
        IF TRIM(Lv_CabeceraDocumentoProceso) IS NOT NULL AND TRIM(Lv_CabeceraDocumentoProceso) = 'PROCESO' THEN
          --
          IF Pv_TipoDocumento = 'P_PAG_RET' THEN
            --
            Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_CREACION, '') || Lv_Delimitador;
            --
          ELSIF Pv_TipoDocumento <> 'P_PAG_HISTO' AND Pv_TipoDocumento <> 'P_ANT_HISTO' THEN 
            --
            IF Pv_TipoDocumento = 'P_PAG' OR Pv_TipoDocumento = 'P_ANT_CRUCE' THEN
              --
              Lv_TablaCabeceraNaf := DB_FINANCIERO.FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB(Pv_EmpresaCod,   
                                                                                               Lr_Datos.ID_FORMA_PAGO, 
                                                                                               Lr_Datos.CODIGO_TIPO_DOCUMENTO, 
                                                                                               Lv_ProcesoIndividual, 
                                                                                               Lv_EstadoActivo );
              --
            END IF;
            --
            --
            IF Lv_ValidadorFechas IS NULL OR Lv_ValidadorFechas = 'N' THEN
              --
              IF Pv_TipoDocumento = 'P_PAG' OR Pv_TipoDocumento = 'P_ANT_CRUCE' THEN
                --
                IF TRIM(Lv_TablaCabeceraNaf) IS NOT NULL AND TRIM(Lv_TablaCabeceraNaf) = 'MIGRA_ARCKMM' THEN 
                  --
                  Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_DEPOSITO, '') || Lv_Delimitador;
                  --
                ELSIF TRIM(Lv_TablaCabeceraNaf) IS NOT NULL AND TRIM(Lv_TablaCabeceraNaf) = 'MIGRA_ARCGAE' THEN 
                  --
                  Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_CREACION, '') || Lv_Delimitador;
                  --
                ELSE
                  --
                  Lv_DetFechaContabilidad := '' || Lv_Delimitador;
                  --
                END IF;--TRIM(Lv_TablaCabeceraNaf) IS NOT NULL AND TRIM(Lv_TablaCabeceraNaf) = 'MIGRA_ARCKMM'
                --
              ELSE
                --
                IF Pv_TipoDocumento = 'P_DEB' THEN
                  --
                  Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_DOCUMENTO, '') || Lv_Delimitador;
                  --
                ELSE
                  --
                  Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_PROCESADO, '') || Lv_Delimitador;
                  --
                END IF;--Pv_TipoDocumento = 'P_DEB'
                --
              END IF;-- Pv_TipoDocumento = 'P_PAG' OR Pv_TipoDocumento = 'P_ANT_CRUCE'
              --
            ELSE
              --
              IF Pv_TipoDocumento = 'P_ANT_CRUCE' AND TRIM(Lv_TablaCabeceraNaf) IS NOT NULL AND ( TRIM(Lv_TablaCabeceraNaf) = 'MIGRA_ARCKMM' 
                 OR TRIM(Lv_TablaCabeceraNaf) = 'MIGRA_ARCGAE' ) THEN 
                --
                Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_CRUCE, '') || Lv_Delimitador;
                --
              ELSIF Pv_TipoDocumento = 'P_DEB' THEN
                --
                Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_CREACION_DEBITO, '') || Lv_Delimitador;
                --
              ELSIF Pv_TipoDocumento = 'P_DEP' THEN
                --
                Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_CREACION_DEPOSITO, '') || Lv_Delimitador;
                --
              ELSIF Pv_TipoDocumento = 'P_PAG' THEN
                --
                Lv_DetFechaContabilidad := NVL(Lr_Datos.FECHA_CREACION, '') || Lv_Delimitador;
                --
              ELSE
                --
                Lv_DetFechaContabilidad := '' || Lv_Delimitador;
                --
              END IF;
              --
            END IF;--TRIM(Lv_ValidadorFechas) IS NOT NULL AND Lv_ValidadorFechas = 'N'
            --
          END IF;
          --
        END IF;
        --
        --
        IF TRIM(Lr_Datos.comentario_pago) IS NOT NULL THEN
          --
          Lv_ComentarioPago := F_GET_VARCHAR_CLEAN( TRIM( 
                                                      REPLACE( 
                                                        REPLACE( 
                                                          REPLACE( TRIM(Lr_Datos.comentario_pago), Chr(9), ' '), Chr(10), ' '), Chr(13), ' ') ) );
          --
          --
          IF TRIM(Lv_ComentarioPago) IS NOT NULL THEN
            --
            Lv_ComentarioPago := SUBSTR(Lv_ComentarioPago, 1, 100);
            --
          END IF;
          --
        END IF;
        --
        --
        IF TRIM(Lr_Datos.descripcion_punto) IS NOT NULL THEN
          --
          Lv_DescripcionPunto := F_GET_VARCHAR_CLEAN( TRIM(
                                                        REPLACE(
                                                          REPLACE(
                                                            REPLACE( TRIM(Lr_Datos.descripcion_punto), Chr(9), ' '), Chr(10), ' '), Chr(13), ' ') )
                                                    );
          --
        END IF;
        --
        --
        IF TRIM(Lr_Datos.comentario_detalle_pago) IS NOT NULL THEN
          --
          Lv_ComentarioDetallePago := F_GET_VARCHAR_CLEAN( TRIM(
                                                            REPLACE(
                                                              REPLACE(
                                                                REPLACE( TRIM(Lr_Datos.comentario_detalle_pago), Chr(9), ' '), Chr(10), ' '), 
                                                                Chr(13), ' ')
                                                          ) );
          --
          --
          IF TRIM(Lv_ComentarioDetallePago) IS NOT NULL THEN
            --
            Lv_ComentarioDetallePago := SUBSTR(Lv_ComentarioDetallePago, 1, 100);
            --
          END IF;
          --
        END IF;
        --
        --
        IF Lr_Datos.DESCRIPCION_CTA_CONTABLE IS NOT NULL THEN
          --
          Lv_BancoEmpresa := Lr_Datos.DESCRIPCION_CTA_CONTABLE;
          --
        END IF;
        --
        --
        IF Lr_Datos.banco_empresa IS NOT NULL AND Lv_BancoEmpresa IS NULL THEN
          --
          Lv_BancoEmpresa := Lr_Datos.banco_empresa;
          --
        END IF;
        --
        --
        IF Lr_Datos.banco_empresa_dep IS NOT NULL AND Lv_BancoEmpresa IS NULL  THEN
          --
          Lv_BancoEmpresa := Lr_Datos.banco_empresa_dep;
          --
        END IF;  
        --
        --
        IF Lr_Datos.banco_empresa_dep_naf IS NOT NULL AND Lv_BancoEmpresa IS NULL  THEN
          --
          Lv_BancoEmpresa := Lr_Datos.banco_empresa_dep_naf;
          --
        END IF;

        IF Ln_BandFechaContabilidad = 0 THEN
          Lv_DetFechaContabilidad := '';
        END IF;

        IF Pv_TipoDocumento = 'P_DEP' THEN
          --
          utl_file.put_line(Lfile_Archivo, NVL(REGEXP_REPLACE(Lr_Datos.id_documento, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.id_documento_detalle, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.nombre_tipo_documento, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.numero_documento, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.valor_total, 0) ||Lv_Delimitador 
                                           || NVL(Lr_Datos.descripcion_forma_pago, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.numero_referencia, Lr_Datos.NUMERO_CUENTA_BANCO) ||Lv_Delimitador 
                                           || Lv_ComentarioPago ||Lv_Delimitador 
                                           || Lv_ComentarioDetallePago ||Lv_Delimitador 
                                           || NVL(NVL(Lr_Datos.banco, Lr_Datos.banco_tc),'')||Lv_Delimitador 
                                           || NVL(Lv_BancoEmpresa, '') ||Lv_Delimitador
                                           || NVL(Lr_Datos.login,'') ||Lv_Delimitador  
                                           || NVL(Lr_Datos.estado, '') ||Lv_Delimitador 
                                           || Lv_DescripcionPunto ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.identificacion_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.nombre_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador  
                                           || NVL(REGEXP_REPLACE(Lr_Datos.apellidos_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.razon_social_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador
                                           || NVL(Lr_Datos.CICLO_FACTURACION,'')||Lv_Delimitador 
                                           || NVL(Lr_Datos.tipo_documento_aut, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.numero_documento_aut, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_emision, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.usuario_creacion, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.estado_documento_global, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_creacion, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_deposito, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_procesado, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_cruce, '') ||Lv_Delimitador 
                                           || Lv_DetFechaContabilidad
                                           || NVL(Lr_Datos.NUMERO_COMPROBANTE, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.oficina_cliente, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.SERVICIOS, '') ||Lv_Delimitador );  
          --
        ELSE
          --
          utl_file.put_line(Lfile_Archivo, NVL(Lr_Datos.login,'') ||Lv_Delimitador  
                                           || NVL(Lr_Datos.estado, '') ||Lv_Delimitador 
                                           || Lv_DescripcionPunto ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.identificacion_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.nombre_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador  
                                           || NVL(REGEXP_REPLACE(Lr_Datos.apellidos_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.razon_social_cliente, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.CICLO_FACTURACION,'')||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.id_documento, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(REGEXP_REPLACE(Lr_Datos.id_documento_detalle, '[[:cntrl:];"]', ''), '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.nombre_tipo_documento, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.numero_documento, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.valor_total, 0) ||Lv_Delimitador 
                                           || NVL(Lr_Datos.descripcion_forma_pago, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.numero_referencia, Lr_Datos.NUMERO_CUENTA_BANCO) ||Lv_Delimitador 
                                           || Lv_ComentarioPago ||Lv_Delimitador 
                                           || Lv_ComentarioDetallePago ||Lv_Delimitador 
                                           || NVL(NVL(Lr_Datos.banco, Lr_Datos.banco_tc),'')||Lv_Delimitador 
                                           || NVL(NVL(Lr_Datos.tipo_cta, Lr_Datos.tipo_cta_contable),'')||Lv_Delimitador
                                           || NVL(Lv_BancoEmpresa, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.tipo_documento_aut, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.numero_documento_aut, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_emision, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.usuario_creacion, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.estado_documento_global, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_creacion, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_deposito, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_procesado, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.fecha_cruce, '') ||Lv_Delimitador 
                                           || Lv_DetFechaContabilidad
                                           || NVL(Lr_Datos.NUMERO_COMPROBANTE, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.oficina_cliente, '') ||Lv_Delimitador 
                                           || NVL(Lr_Datos.SERVICIOS, '') ||Lv_Delimitador); 
          --
        END IF;
        --
  END LOOP;    

  END IF;

  UTL_FILE.fclose(Lfile_Archivo);
  dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  
  DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                            Lv_Destinatario,
                                            Lv_Asunto, 
                                            Lv_Cuerpo, 
                                            Lv_Directorio,
                                            Lv_NombreArchivoZip);
  UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);           

  END P_REPORTE_COBRANZAS;

  PROCEDURE P_REPORTE_FACTURACION(
      Pv_TipoDocumento          IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_NumeroDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      Pv_UsrCreacion            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_EstadoDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
      Pf_Monto                  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      Pv_FiltroMonto            IN VARCHAR2,
      Pv_FechaCreacionDesde     IN VARCHAR2,
      Pv_FechaCreacionHasta     IN VARCHAR2,
      Pv_FechaEmisionDesde      IN VARCHAR2,
      Pv_FechaEmisionHasta      IN VARCHAR2,
      Pv_FechaAutorizacionDesde IN VARCHAR2,
      Pv_FechaAutorizacionHasta IN VARCHAR2,
      Pv_EmpresaCod             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_UsrSesion              IN VARCHAR2,
      Pv_PrefijoEmpresa         IN VARCHAR2,
      Pv_EmailUsrSesion         IN VARCHAR2,
      Pv_Start                  IN VARCHAR2,
      Pv_Limit                  IN VARCHAR2 )
  IS
      Lv_QueryFacturacion       VARCHAR2(10000) ;
      Lv_FechaCreacionDesde     VARCHAR2(200)  :='Todos';
      Lv_FechaCreacionHasta     VARCHAR2(200)  :='Todos';
      Lv_FechaEmisionDesde      VARCHAR2(200)  :='Todos';
      Lv_FechaEmisionHasta      VARCHAR2(200)  :='Todos';
      Lv_FechaAutorizacionDesde VARCHAR2(200)  :='Todos';
      Lv_FechaAutorizacionHasta VARCHAR2(200)  :='Todos';
      Lv_Monto                  VARCHAR2(200)  :='Todos';
      Lv_EstadoDocumento        VARCHAR2(200)  :='Todos';
      Lv_TipoDocumento          VARCHAR2(200)  :='Todos';
      Lv_NumeroDocumento        VARCHAR2(200)  :='Todos';
      Lv_DescripcionFactura     VARCHAR2(1000) :='';
      Lv_TipoResponsable        VARCHAR2(200)  :='';
      Lv_DescripcionArea        VARCHAR2(200)  :='';
      Lv_FacturaAplica          VARCHAR2(200)  :='';
      Lv_PagoAplica             VARCHAR2(500)  :='';
      Lv_FechaPagoAplica        VARCHAR2(200)  :='';
      Lv_Comentario             VARCHAR2(5000) :='';
      Lv_Multa                  VARCHAR2(200)  :='';
      Lf_ValorRetenciones       NUMBER         := 0;
      Lv_Directorio             VARCHAR2(50)   :='DIR_REPGERENCIA';
      Lv_NombreArchivo          VARCHAR2(50)   :='ReporteFacturacion'||Pv_PrefijoEmpresa||'_'
                                                                     ||Pv_TipoDocumento|| '_'
                                                                     ||Pv_UsrSesion||'.csv';
      Lv_Delimitador            VARCHAR2(1)    := ';';
      Lv_Gzip                   VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_Remitente              VARCHAR2(20)   := 'telcos@telconet.ec';
      Lv_Destinatario           VARCHAR2(100)  := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
      Lv_Asunto                 VARCHAR2(300)  := 'Notificacion REPORTE DE FACTURACION '||Pv_TipoDocumento;
      Lv_Cuerpo                 VARCHAR2(9999) := '';
      Lv_NombreArchivoZip       VARCHAR2(50)   := Lv_NombreArchivo||'.gz';
      Ld_FechaCreacionHasta     DATE;
      Lfile_Archivo             utl_file.file_type;
      Lr_DatosFacturacion       DB_FINANCIERO.FNKG_TYPES.Lr_Facturacion;
      Lc_GetAliasPlantilla      FNKG_TYPES.Lr_AliasPlantilla;
      Lc_ReporteFacturacion     SYS_REFCURSOR;
      --
      --
      Lv_CabeceraCompensacion   VARCHAR2(50)                                        := '';
      Lv_FilaCompensacion       VARCHAR2(50)                                        := '';
      Lv_EstadoActivo           DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE           := 'Activo';
      Lv_NombreCabecera         DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'REPORTE_DOCUMENTOS_FINANCIEROS';
      Lb_BanderaCompensacion    BOOLEAN                                             := false;
      Lr_GetAdmiParamtrosDet    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
      Lrf_GetAdmiParamtrosDet   SYS_REFCURSOR;
      Lb_EnvioRetencion         BOOLEAN                                             := FALSE;
      Lv_CabeceraRetenciones    VARCHAR2(200)                                       := '';
      Lv_FilaRetenciones        VARCHAR2(100)                                       := '';
      Lv_ReporteDocumento       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'REPORTE_FACTURACION_DOCUMENTOS';
      Lv_DetalleTipoDocumento   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'TIPOS_DOCUMENTOS';
      Lv_ValorActivo            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE           := 'S';
      Lb_BanderaFechaAnulacion  BOOLEAN                                             := false;
      Lb_BanderaFeUltMod        BOOLEAN                                             := false;
      Lb_BanderaUsrUltMod       BOOLEAN                                             := false;
      Lv_ValorFeAnulacion       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'FE_ANULACION';
      Lv_ValorFeUltMod          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'FE_ULT_MOD';
      Lv_ValorUsrUltMod         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'USR_ULT_MOD';
      Lv_ValorCompensacion      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'COMPENSACION';
      Lv_CabeceraFeAnulacion    VARCHAR2(50)                                        := '';
      Lv_CabeceraFeUltMod       VARCHAR2(50)                                        := '';
      Lv_CabeceraUsrUltMod      VARCHAR2(50)                                        := '';
      Lv_FilaFeAnulacion        VARCHAR2(100)                                       := '';
      Lv_FilaFeUltMod           VARCHAR2(100)                                       := '';
      Lv_FilaUsrUltMod          VARCHAR2(100)                                       := '';

  BEGIN

    Lv_QueryFacturacion :=
    'SELECT                
        IDFC.ID_DOCUMENTO,                
        IDFC.OFICINA_ID,                 
        IDFC.NUMERO_FACTURA_SRI AS NUMERO_DOCUMENTO,                
        ROUND(NVL(IDFC.VALOR_TOTAL, 0), 2),                
        IDFC.ESTADO_IMPRESION_FACT AS ESTADO_DOCUMENTO,                 
        CASE WHEN IDFC.ES_AUTOMATICA = ''S''THEN ''Si''
        ELSE ''No''                   
        END AS ES_AUTOMATICA,                
        IDFC.FE_CREACION,                 
        TO_CHAR(IDFC.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_CREACION,                
        IDFC.FE_EMISION,                
        TO_CHAR(IDFC.FE_EMISION, ''DD-MM-YYYY'') AS FECHA_EMISION,                 
        IDFC.FE_AUTORIZACION,                 
        TO_CHAR(IDFC.FE_AUTORIZACION, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_AUTORIZACION,                
        IDFC.USR_CREACION,
        FNCK_CONSULTS.F_GET_USR_ULT_MOD(IDFC.ID_DOCUMENTO) AS USR_ULT_MOD,
        FNCK_CONSULTS.F_GET_FE_ULT_MOD(IDFC.ID_DOCUMENTO) AS FE_ULT_MOD,                 
        ATDF.CODIGO_TIPO_DOCUMENTO,                 
        ATDF.NOMBRE_TIPO_DOCUMENTO,                 
        IPTO.ID_PUNTO,                 
        IPTO.LOGIN,                 
        IPTO.NOMBRE_PUNTO,                 
        IPTO.DIRECCION,                
        IPTO.DESCRIPCION_PUNTO,                 
        IPTO.ESTADO,                 
        IPTO.USR_VENDEDOR,                 
        IPER.ID_PERSONA,                 
        IPER.IDENTIFICACION_CLIENTE,                 
        DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(IPER.NOMBRES) AS NOMBRE_CLIENTE,                 
        DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(IPER.APELLIDOS) AS APELLIDOS_CLIENTE,                 
        DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(IPER.RAZON_SOCIAL) AS RAZON_SOCIAL_CLIENTE,                 
        DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(IPER.DIRECCION) AS DIRECCION_CLIENTE,                 
        DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC(''CICLO_FACTURACION'',PEROL.ID_PERSONA_ROL) 
        AS CICLO_FACTURACION,
        IPER.CALIFICACION_CREDITICIA,                
        CONCAT(IPVEND.NOMBRES,CONCAT(''  '',IPVEND.APELLIDOS)) AS NOMBRE_VENDEDOR,                
        ATN.CODIGO_TIPO_NEGOCIO,                
        IOG.NOMBRE_OFICINA,                
        ROUND(NVL(IDFC.SUBTOTAL, 0), 2),            
        ROUND(NVL(IDFC.SUBTOTAL_CON_IMPUESTO, 0), 2),
        ROUND(NVL(IDFC.SUBTOTAL_DESCUENTO, 0), 2),                          
        PEROL.ID_PERSONA_ROL,                
        IDFC.REFERENCIA_DOCUMENTO_ID,                
        FNCK_CONSULTS.F_GET_VALOR_IMPUESTO(IDFC.ID_DOCUMENTO,''IVA'') AS IVA,                
        FNCK_CONSULTS.F_GET_VALOR_IMPUESTO(IDFC.ID_DOCUMENTO,''ICE'') AS ICE,               
        ROUND((NVL(IDFC.SUBTOTAL,0)-NVL(IDFC.SUBTOTAL_DESCUENTO,0)), 2) AS VALOR_REAL,               
        FNCK_CONSULTS.F_GET_FORMA_PAGO_CONTRATO(PEROL.ID_PERSONA_ROL) AS FORMA_PAGO,                
        FNCK_CONSULTS.F_GET_VALOR_CARACTERISTICA(IDFC.ID_DOCUMENTO, ''TIPO_RESPONSABLE_NC'') AS TIPO_RESPONSABLE,                
        FNCK_CONSULTS.F_GET_VALOR_CARACTERISTICA(IDFC.ID_DOCUMENTO, ''RESPONSABLE_NC'') AS RESPONSABLE_NC,                
        FNCK_CONSULTS.F_GET_DOCUMENTO_APLICA(IDFC.REFERENCIA_DOCUMENTO_ID) AS FACTURA_APLICA,                
        FNCK_CONSULTS.F_GET_MOTIVO_DOCUMENTO(IDFC.ID_DOCUMENTO) AS MOTIVO_DOCUMENTO,                
        FNCK_CONSULTS.F_GET_PAGOS_APLICA_ND(IDFC.ID_DOCUMENTO) AS PAGO_APLICA,
        FNCK_CONSULTS.F_GET_FECHA_PAGOS_APLICA_ND(IDFC.ID_DOCUMENTO) AS FECHA_PAGO_APLICA,
        FNCK_CONSULTS.F_GET_COMENTARIO_ND(IDFC.ID_DOCUMENTO) AS COMENTARIO_ND,                
        FNCK_CONSULTS.F_GET_VALOR_CARACTERISTICA(IDFC.ID_DOCUMENTO, ''CHEQUE_PROTESTADO'') AS MULTA,                
        FNCK_CONSULTS.F_GET_VALOR_RETENCIONES(IDFC.ID_DOCUMENTO,''''''RF8'''',''''RF2'''''' ,NULL) AS VALOR_RETENCIONES,                
        IOGR.NOMBRE_OFICINA AS OFICINA_FACTURACION,
        DECODE(ATDF.CODIGO_TIPO_DOCUMENTO,''FACP'', 
               FNCK_CONSULTS.F_GET_DESCRIPCION_FACTURA_DET(IDFC.ID_DOCUMENTO), 
               FNCK_CONSULTS.F_GET_DESCRIPCION_FACTURA(IDFC.ID_DOCUMENTO,IDFC.USR_CREACION))
        AS
          DESCRIPCION_FACTURA,
        FNCK_CONSULTS.F_GET_VALOR_CARACTERISTICA(IDFC.ID_DOCUMENTO, ''DESCRIPCION_INTERNA_NC'') AS DESCRIPCION_NC,
        FNCK_CONSULTS.F_GET_MOTIVO_POR_ESTADO(IDFC.ID_DOCUMENTO,''Anulado'',''Anulado'')   AS MOTIVO_ANULACION_DOC,
        FNCK_CONSULTS.F_GET_SUBTOTAL_IMPUESTO(IDFC.ID_DOCUMENTO,14,''IVA'')   AS SUBTOTAL_IMPUESTO_CAT,
        FNCK_CONSULTS.F_GET_SUBTOTAL_IMPUESTO(IDFC.ID_DOCUMENTO,12,''IVA'')   AS SUBTOTAL_IMPUESTO_DOC,
        FNCK_CONSULTS.F_GET_SUBTOTAL_CERO_IMPUESTO(IDFC.ID_DOCUMENTO) AS SUBTOTAL_IMPUESTO_CER,                                
        IDFC.DESCUENTO_COMPENSACION, 
        FNCK_CONSULTS.F_GET_VALOR_RETENCIONES(IDFC.ID_DOCUMENTO, NULL, ''RETENCION FUENTE''),
        FNCK_CONSULTS.F_GET_VALOR_RETENCIONES(IDFC.ID_DOCUMENTO, NULL, ''RETENCION IVA''),
        DECODE(IDFC.ESTADO_IMPRESION_FACT, 
               ''Anulado'', FNCK_CONSULTS.F_GET_FECHA_HISTORIAL(IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, ''MIN_MOTIVO''),
               NULL) AS FE_ANULACION,
        DB_FINANCIERO.FNCK_ARCHIVO_IMPRESION.F_INFORMACION_SERVICIOS(IPTO.ID_PUNTO) AS SERVICIOS
      FROM                  
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC                    
        INNER JOIN DB_COMERCIAL.INFO_PUNTO                      IPTO   ON IPTO.ID_PUNTO          = IDFC.PUNTO_ID                    
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL        PEROL  ON PEROL.ID_PERSONA_ROL   = IPTO.PERSONA_EMPRESA_ROL_ID                    
        INNER JOIN DB_COMERCIAL.INFO_PERSONA                    IPER   ON IPER.ID_PERSONA        = PEROL.PERSONA_ID                                
        INNER JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF   ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID                                
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO              IOGI   ON IOGI.ID_OFICINA        = IDFC.OFICINA_ID                                
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO              IEGI   ON IEGI.COD_EMPRESA       = IOGI.EMPRESA_ID                     
        LEFT  JOIN DB_COMERCIAL.INFO_PERSONA                    IPVEND ON IPVEND.LOGIN           = IPTO.USR_VENDEDOR                    
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO               ATN    ON ATN.ID_TIPO_NEGOCIO    = IPTO.TIPO_NEGOCIO_ID                     
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG    ON IOG.ID_OFICINA         = PEROL.OFICINA_ID                     
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO              IOGR   ON IOGR.ID_OFICINA        = IDFC.OFICINA_ID                                 

      WHERE                 
        IEGI.COD_EMPRESA='|| Pv_EmpresaCod ;

    IF Pv_TipoDocumento IS NOT NULL THEN
    --
         CASE Pv_TipoDocumento
            WHEN 'FAC'
             THEN  Lv_TipoDocumento :='Factura';
            WHEN 'FACP'
             THEN Lv_TipoDocumento   :='Factura Proporcional';
            WHEN 'NC'
             THEN Lv_TipoDocumento   :='Nota de Credito';
            WHEN 'ND'
             THEN Lv_TipoDocumento   :='Nota de Debito';  
            WHEN 'NCI'
             THEN Lv_TipoDocumento   :='Nota de Credito Interna';
            WHEN 'NDI'
             THEN Lv_TipoDocumento   :='Nota de Debito Interna';
             ELSE Lv_TipoDocumento   :='No se encontro tipo de documento';

          END CASE;
          --
      IF Lrf_GetAdmiParamtrosDet%ISOPEN THEN
         CLOSE Lrf_GetAdmiParamtrosDet;
      END IF;

      -- Se obtiene y verifica si esta activo el envio de retencion en la fuente e iva para la empresa a ser procesada
      Lr_GetAdmiParamtrosDet  := NULL;
      Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_ReporteDocumento, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Lv_ReporteDocumento, 
                                                                                        Pv_PrefijoEmpresa, 
                                                                                        Lv_ValorActivo, 
                                                                                        NULL );

      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;

      IF TRIM(Lr_GetAdmiParamtrosDet.VALOR3) IS NOT NULL AND TRIM(Lr_GetAdmiParamtrosDet.VALOR3) = 'S' THEN

        -- Se obtiene el parametro y se verifica si esta activo el envio de retencion en la fuente e iva para el tipo de documento
        -- a ser procesado
        Lr_GetAdmiParamtrosDet  := NULL;
        Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_ReporteDocumento, 
                                                                                          Lv_EstadoActivo, 
                                                                                          Lv_EstadoActivo, 
                                                                                          Lv_DetalleTipoDocumento, 
                                                                                          Pv_TipoDocumento, 
                                                                                          Lv_ValorActivo, 
                                                                                          NULL );

        FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
        CLOSE Lrf_GetAdmiParamtrosDet;
        IF TRIM(Lr_GetAdmiParamtrosDet.VALOR3) IS NOT NULL AND TRIM(Lr_GetAdmiParamtrosDet.VALOR3) = 'S' THEN
          Lb_EnvioRetencion := TRUE;
        END IF;
      END IF;

      Lr_GetAdmiParamtrosDet:=NULL;

      Lv_QueryFacturacion := Lv_QueryFacturacion || ' AND ATDF.CODIGO_TIPO_DOCUMENTO = ''' || Pv_TipoDocumento ||'''';
      --
      --
      -- OBTIENE LOS PARAMETROS ADECUADOS PARA CONSULTAR SI SE DEBE AGREGAR O NO LA COLUMNA DE COMPENSACION SOLIDARIA
      Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabecera, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Pv_TipoDocumento, 
                                                                                        Lv_ValorCompensacion, 
                                                                                        Pv_EmpresaCod, 
                                                                                        NULL );
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      --
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET > 0 THEN
        --
        Lb_BanderaCompensacion := true;
        --
      END IF;
      --
      --
      -- OBTIENE LOS PARAMETROS ADECUADOS PARA CONSULTAR SI SE DEBE AGREGAR O NO LA COLUMNA DE FE_ANULACION
      Lr_GetAdmiParamtrosDet  := NULL;
      Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabecera, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Pv_TipoDocumento, 
                                                                                        Lv_ValorFeAnulacion, 
                                                                                        Pv_EmpresaCod, 
                                                                                        NULL );
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      --
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET > 0 THEN
        --
        Lb_BanderaFechaAnulacion := true;
        --
      END IF;

      --
      --
      -- OBTIENE LOS PARAMETROS ADECUADOS PARA CONSULTAR SI SE DEBE AGREGAR O NO LA COLUMNA DE FE_ULT_MOD
      Lr_GetAdmiParamtrosDet  := NULL;
      Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabecera, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Pv_TipoDocumento, 
                                                                                        Lv_ValorFeUltMod, 
                                                                                        Pv_EmpresaCod, 
                                                                                        NULL );
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      --
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET > 0 THEN
        --
        Lb_BanderaFeUltMod := true;
        --
      END IF;

      --
      --
      -- OBTIENE LOS PARAMETROS ADECUADOS PARA CONSULTAR SI SE DEBE AGREGAR O NO LA COLUMNA DE USR_ULT_MOD
      Lr_GetAdmiParamtrosDet  := NULL;
      Lrf_GetAdmiParamtrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabecera, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Lv_EstadoActivo, 
                                                                                        Pv_TipoDocumento, 
                                                                                        Lv_ValorUsrUltMod, 
                                                                                        Pv_EmpresaCod, 
                                                                                        NULL );
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      --
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET > 0 THEN
        --
        Lb_BanderaUsrUltMod := true;
        --
      END IF;

      --
    END IF;

    IF Pv_FechaCreacionDesde IS NOT NULL AND Pv_FechaCreacionHasta IS NOT NULL THEN
      Lv_FechaCreacionDesde   := Pv_FechaCreacionDesde;
      Lv_FechaCreacionHasta   := Pv_FechaCreacionHasta;
      Lv_FechaCreacionHasta   := TO_CHAR(TO_DATE( Lv_FechaCreacionHasta ,'DD/MM/YYYY') - 1, 'DD/MM/YYYY');
      --
      Lv_QueryFacturacion     := Lv_QueryFacturacion ||
                                '  AND IDFC.FE_CREACION BETWEEN TO_DATE('''||Pv_FechaCreacionDesde||''',''DD/MM/YY'')            
                                   AND TO_DATE('''||Pv_FechaCreacionHasta||''',''DD/MM/YY'')' ;
    END IF;

    IF Pv_FechaEmisionDesde IS NOT NULL AND Pv_FechaEmisionHasta IS NOT NULL THEN
      Lv_FechaEmisionDesde   := Pv_FechaEmisionDesde;
      Lv_FechaEmisionHasta   := Pv_FechaEmisionHasta;
      Lv_FechaEmisionHasta   := TO_CHAR(TO_DATE( Lv_FechaEmisionHasta ,'DD/MM/YYYY') - 1, 'DD/MM/YYYY');
      Lv_QueryFacturacion    := Lv_QueryFacturacion || 
                                     '  AND IDFC.FE_EMISION >= TO_DATE('''||Pv_FechaEmisionDesde||
                                    ''',''DD/MM/YY'') AND IDFC.FE_EMISION < TO_DATE('''||Pv_FechaEmisionHasta||''',''DD/MM/YY'')' ;                                   
    END IF;

    IF Pv_FechaAutorizacionDesde IS NOT NULL AND Pv_FechaAutorizacionHasta IS NOT NULL THEN
      Lv_FechaAutorizacionDesde   := Pv_FechaAutorizacionDesde;
      Lv_FechaAutorizacionHasta   := Pv_FechaAutorizacionHasta; 
      Lv_FechaAutorizacionHasta   := TO_CHAR(TO_DATE( Lv_FechaAutorizacionHasta ,'DD/MM/YYYY') - 1, 'DD/MM/YYYY');
      --
      Lv_QueryFacturacion         := Lv_QueryFacturacion || 
                                     '  AND IDFC.FE_AUTORIZACION BETWEEN TO_DATE('''||Pv_FechaAutorizacionDesde||
                                    ''',''DD/MM/YY'') AND TO_DATE('''||Pv_FechaAutorizacionHasta||''',''DD/MM/YY'')' ;
    END IF;
    IF Pv_UsrCreacion IS NOT NULL THEN
      --
      Lv_QueryFacturacion := Lv_QueryFacturacion || ' AND IDFC.USR_CREACION LIKE ''%' || Pv_UsrCreacion || '%''';
      --
    END IF;
    IF Pv_NumeroDocumento IS NOT NULL THEN
      Lv_NumeroDocumento  := Pv_NumeroDocumento ;
      Lv_QueryFacturacion := Lv_QueryFacturacion || ' AND IDFC.NUMERO_FACTURA_SRI LIKE ''%' ||
                             Pv_NumeroDocumento  || '%''';
      --
    END IF;
    IF Pv_EstadoDocumento IS NOT NULL THEN
      Lv_EstadoDocumento  := Pv_EstadoDocumento;
      Lv_QueryFacturacion := Lv_QueryFacturacion || 
                             ' AND LOWER(IDFC.ESTADO_IMPRESION_FACT) LIKE ''%' || LOWER(Pv_EstadoDocumento) || '%''';
      --
    END IF;
      IF Pf_Monto            IS NOT NULL AND Pv_FiltroMonto IS NOT NULL THEN
        Lv_Monto := Pf_Monto;

        IF Pv_FiltroMonto     = 'p' THEN
          Lv_QueryFacturacion := Lv_QueryFacturacion || '  AND IDFC.VALOR_TOTAL < ' || Pf_Monto ;
        END IF;
        IF Pv_FiltroMonto     = 'i' THEN
          Lv_QueryFacturacion := Lv_QueryFacturacion || '  AND IDFC.VALOR_TOTAL = ' || Pf_Monto ;
        END IF;
        IF Pv_FiltroMonto     = 'm' THEN
          Lv_QueryFacturacion := Lv_QueryFacturacion || '  AND IDFC.VALOR_TOTAL > ' || Pf_Monto ;
        END IF;
      END IF;

      Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
      Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
      Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivo,'w',3000);--Opening a file

      --
      -- BLOQUE QUE ESCRIBE EL NOMBRE DE LA COLUMNA COMPENSACION SOLIDARIA EN LA VARIABLE 'Lv_CabeceraCompensacion' PARA QUE LUEGO SEA MOSTRADA EN EL
      -- REPORTE ENVIADO VIA MAIL AL USUARIO
      IF Lb_BanderaCompensacion THEN
        --
        Lv_CabeceraCompensacion := 'TOTAL ANTES COMPENSACION'||Lv_Delimitador||'COMPENSACION 2%'||Lv_Delimitador;
        --
      END IF;
      --
      --
      --
      IF Lb_BanderaFechaAnulacion THEN 
        --
        Lv_CabeceraFeAnulacion := 'FECHA ANULACION' || Lv_Delimitador;
        --
      END IF;
      --
      --
      --
      IF Lb_BanderaFeUltMod THEN 
        --
        Lv_CabeceraFeUltMod := 'FECHA ULT.MOD' || Lv_Delimitador;
        --
      END IF;
      --
      --
      --
      IF Lb_BanderaUsrUltMod THEN 
        --
        Lv_CabeceraUsrUltMod := 'USUARIO ULT.MOD' || Lv_Delimitador;
        --
      END IF;
      --
      --
      --
      IF Lb_EnvioRetencion THEN
       Lv_CabeceraRetenciones := Lv_CabeceraRetenciones||'MONTO DE RET FTE'||Lv_Delimitador 
                                              ||'MONTO DE RET IVA'||Lv_Delimitador;
      END IF;

      --
      -- CABECERA DEL REPORTE
      utl_file.put_line(Lfile_Archivo,'USUARIO QUE GENERA: '||Pv_UsrSesion||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||'FECHA DE GENERACION:  '||SYSDATE||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||'TIPO DOCUMENTO:  '||Lv_TipoDocumento||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||'# DOCUMENTO: '||Lv_NumeroDocumento||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||'VALOR DOCUMENTO: '||Lv_Monto||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador );

       utl_file.put_line(Lfile_Archivo,'FECHA CREACION: '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||'DESDE: '||Lv_FechaCreacionDesde||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||'HASTA: '||Lv_FechaCreacionHasta||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador  
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador );     

        utl_file.put_line(Lfile_Archivo,'FECHA EMISION: '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||'DESDE: '||Lv_FechaEmisionDesde||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||'HASTA: '||Lv_FechaEmisionHasta||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador );   

         utl_file.put_line(Lfile_Archivo,'FECHA AUTORIZACION: '||Lv_Delimitador  
               ||' '||Lv_Delimitador 
               ||'DESDE: '||Lv_FechaAutorizacionDesde||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||'HASTA: '||Lv_FechaAutorizacionHasta||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador  
               ||' '||Lv_Delimitador
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador 
               ||' '||Lv_Delimitador );   

     utl_file.put_line(Lfile_Archivo,'LOGIN'||Lv_Delimitador  
               ||'ESTADO PTO CLIENTE'||Lv_Delimitador 
               ||'DESCRIPCION PTO CLIENTE'||Lv_Delimitador 
               ||'DESCRIPCION FACTURA'||Lv_Delimitador 
               ||'IDENTIFICACION'||Lv_Delimitador 
               ||'NOMBRES'||Lv_Delimitador 
               ||'APELLIDOS'||Lv_Delimitador 
               ||'RAZON SOCIAL CLIENTE'||Lv_Delimitador 
               ||'DIRECCION'||Lv_Delimitador 
               ||'CICLO DE FACTURACION'||Lv_Delimitador 
               ||'ID DOCUMENTO'||Lv_Delimitador 
               ||'TIPO DOCUMENTO'||Lv_Delimitador 
               ||'# DOCUMENTO'||Lv_Delimitador 
               ||'SUBTOTAL'||Lv_Delimitador 
               ||'DESCUENTO'||Lv_Delimitador 
               ||'VALOR REAL'||Lv_Delimitador 
               ||'SUBT 0%'||Lv_Delimitador 
               ||'SUBT 12%'||Lv_Delimitador 
               ||'SUBT 14%'||Lv_Delimitador 
               ||'IMPUESTOS'||Lv_Delimitador 
               ||'IVA'||Lv_Delimitador 
               ||'ICE'||Lv_Delimitador 
               || Lv_CabeceraCompensacion
               ||'VALOR'||Lv_Delimitador 
               ||'ES AUTOMATICA'||Lv_Delimitador 
               ||'USUARIO CREACION'||Lv_Delimitador
               ||Lv_CabeceraUsrUltMod
               ||'ESTADO'||Lv_Delimitador 
               ||'FECHA CREACION'||Lv_Delimitador 
               ||'FECHA EMISION'||Lv_Delimitador 
               ||'FECHA AUTORIZACION'||Lv_Delimitador
               ||Lv_CabeceraFeUltMod
               ||Lv_CabeceraFeAnulacion
               ||'FORMA DE PAGO'||Lv_Delimitador 
               ||'VENDEDOR'||Lv_Delimitador 
               ||'OFICINA CLIENTE'||Lv_Delimitador 
               ||'TIPO DE NEGOCIO'||Lv_Delimitador 
               ||'MOTIVO DE ANULACION'||Lv_Delimitador 
               ||'NC TIPO RESPONSABLE'||Lv_Delimitador
               ||'NC DESCRIPCION AREA'||Lv_Delimitador 
               ||'NC #FACTURA APLICA'||Lv_Delimitador 
               ||'MOTIVO'||Lv_Delimitador 
               ||'ND PAGO APLICA'||Lv_Delimitador 
               ||'ND FECHA PAGO APLICA'||Lv_Delimitador 
               ||'ND COMENTARIO'||Lv_Delimitador 
               ||'ND MULTA'||Lv_Delimitador 
               ||'ND VALOR RETENCIONES'||Lv_Delimitador 
               ||'OFICINA FACTURACION'||Lv_Delimitador
               ||Lv_CabeceraRetenciones
               ||'DESCRIPCION PLAN'||Lv_Delimitador
               );
    OPEN Lc_ReporteFacturacion FOR Lv_QueryFacturacion;

    LOOP
      FETCH Lc_ReporteFacturacion INTO Lr_DatosFacturacion;

      EXIT
      WHEN Lc_ReporteFacturacion%NOTFOUND; 

      Lv_DescripcionFactura := NULL;
      Lv_TipoResponsable    := NULL;
      Lv_DescripcionArea    := NULL;
      Lv_FacturaAplica      := NULL;
      Lv_PagoAplica         := NULL;
      Lv_FechaPagoAplica    := NULL;
      Lv_Comentario         := NULL;
      Lv_Multa              := NULL;
      Lf_ValorRetenciones   := NULL;

      IF Pv_TipoDocumento ='FAC' OR Pv_TipoDocumento ='FACP' THEN 
        IF Lr_DatosFacturacion.descripcion_factura IS NOT NULL THEN  
          Lv_DescripcionFactura:=F_GET_VARCHAR_CLEAN(TRIM(
                                                              REPLACE(
                                                              REPLACE(
                                                              REPLACE(
                                                                Lr_DatosFacturacion.descripcion_factura,Chr(9),' '), 
                                                                Chr(10), ' '), Chr(13), ' ')));
        END IF;
      END IF;

      -- Campos para Notas de Credito
      IF Pv_TipoDocumento='NC' OR Pv_TipoDocumento='NCI' THEN  
        IF Lr_DatosFacturacion.descripcion_nc IS NOT NULL THEN
          Lv_DescripcionFactura:=F_GET_VARCHAR_CLEAN(TRIM(
                                                              REPLACE(
                                                              REPLACE(
                                                              REPLACE(
                                                               Lr_DatosFacturacion.descripcion_nc,Chr(9), ' '),
                                                               Chr(10), ' '), Chr(13), ' ')));
        END IF;   
        IF Lr_DatosFacturacion.tipo_responsable IS NOT NULL THEN
          Lv_TipoResponsable:=Lr_DatosFacturacion.tipo_responsable;
        END IF;  
        IF Lr_DatosFacturacion.responsable_nc IS NOT NULL THEN
          Lv_DescripcionArea:=NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                  REPLACE(
                                                  REPLACE(
                                                  REPLACE(
                                                   Lr_DatosFacturacion.responsable_nc, Chr(9), ' '),
                                                   Chr(10), ' '), Chr(13), ' '))), '');          
        END IF;    
        IF Lr_DatosFacturacion.factura_aplica IS NOT NULL THEN
          Lv_FacturaAplica:=Lr_DatosFacturacion.factura_aplica;
        END IF;
      END IF;    

      -- Campos para Notas de Debito
      IF Pv_TipoDocumento='ND' OR Pv_TipoDocumento='NDI' THEN   
        IF Lr_DatosFacturacion.pago_aplica IS NOT NULL THEN
          Lv_PagoAplica:=Lr_DatosFacturacion.pago_aplica;
        END IF;

        IF Lr_DatosFacturacion.fecha_pago_aplica IS NOT NULL THEN
          Lv_FechaPagoAplica:=Lr_DatosFacturacion.fecha_pago_aplica;
        END IF;

        IF Lr_DatosFacturacion.comentario_nd IS NOT NULL THEN
          Lv_Comentario:=NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                  REPLACE(
                                                  REPLACE(
                                                  REPLACE(
                                                   Lr_DatosFacturacion.comentario_nd, Chr(9), ' '),
                                                   Chr(10), ' '), Chr(13), ' '))), '');
        END IF; 

        IF Lr_DatosFacturacion.multa IS NOT NULL THEN
          Lv_Multa:=Lr_DatosFacturacion.multa;
        END IF;

        IF Lr_DatosFacturacion.valor_retenciones IS NOT NULL THEN
          Lf_ValorRetenciones:=Lr_DatosFacturacion.valor_retenciones;
        END IF;  
      END IF;  

      --
      -- BLOQUE QUE VERIFICA SI SE DEBE AGREGAR EL LA FECHA DE ANULACION POR CADA FILA
      Lv_FilaFeAnulacion := '';
      --
      IF Lb_BanderaFechaAnulacion THEN
        --
        Lv_FilaFeAnulacion := Lr_DatosFacturacion.FE_ANULACION || Lv_Delimitador;
        --
      END IF;

      --
      -- BLOQUE QUE VERIFICA SI SE DEBE AGREGAR EL LA FECHA DE ANULACION POR CADA FILA
      Lv_FilaFeUltMod := '';
      --
      IF Lb_BanderaFechaAnulacion THEN
        --
        Lv_FilaFeUltMod := NVL(Lr_DatosFacturacion.fe_ult_mod, '') || Lv_Delimitador;
        --
      END IF;   

      --
      -- BLOQUE QUE VERIFICA SI SE DEBE AGREGAR EL LA FECHA DE ANULACION POR CADA FILA
      Lv_FilaUsrUltMod := '';
      --
      IF Lb_BanderaUsrUltMod THEN
        --
        Lv_FilaUsrUltMod := NVL(Lr_DatosFacturacion.usr_ult_mod, '') || Lv_Delimitador;
        --
      END IF;  

      --
      -- BLOQUE QUE VERIFICA SI SE DEBE AGREGAR EL VALOR DE COMPENSACION SOLIDARIA POR CADA FILA
      Lv_FilaCompensacion := '';
      --
      IF Lb_BanderaCompensacion THEN
        --
        Lv_FilaCompensacion := ( ROUND( NVL(Lr_DatosFacturacion.valor_real, 0) + NVL(Lr_DatosFacturacion.subtotal_con_impuesto, 0), 2 ) )
                               || Lv_Delimitador || NVL(Lr_DatosFacturacion.DESCUENTO_COMPENSACION, 0) || Lv_Delimitador;
        --
      END IF;

      Lv_FilaRetenciones := '';
      IF Lb_EnvioRetencion THEN 
        Lv_FilaRetenciones := Lv_FilaRetenciones||Lr_DatosFacturacion.VALOR_RETENCION_FTE||Lv_Delimitador
                                                ||Lr_DatosFacturacion.VALOR_RETENCION_IVA||Lv_Delimitador;
      END IF;

      utl_file.put_line(Lfile_Archivo,NVL(Lr_DatosFacturacion.login, '')||Lv_Delimitador  
                        ||NVL(Lr_DatosFacturacion.estado, '')||Lv_Delimitador 
                        ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                           REPLACE(
                                                           REPLACE(
                                                           REPLACE(
                                                            Lr_DatosFacturacion.descripcion_punto, Chr(9), ' '), 
                                                            Chr(10), ' '), Chr(13), ' '))), '')||Lv_Delimitador 
                        ||NVL(Lv_DescripcionFactura, '')||Lv_Delimitador 
                        ||NVL(REGEXP_REPLACE(
                               Lr_DatosFacturacion.identificacion_cliente, '[[:cntrl:];"]', ''), '')||Lv_Delimitador 
                        ||NVL(REGEXP_REPLACE(
                               Lr_DatosFacturacion.nombre_cliente, '[[:cntrl:];"]', ''), '')||Lv_Delimitador 
                        ||NVL(REGEXP_REPLACE(
                               Lr_DatosFacturacion.apellidos_cliente, '[[:cntrl:];"]', ''), '')||Lv_Delimitador 
                        ||NVL(REGEXP_REPLACE(
                               Lr_DatosFacturacion.razon_social_cliente, '[[:cntrl:];"]', ''), '')||Lv_Delimitador 
                        ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                           REPLACE(
                                                           REPLACE(
                                                           REPLACE(
                                                            Lr_DatosFacturacion.direccion_cliente, Chr(9), ' '),
                                                            Chr(10), ' '), Chr(13), ' '))), '')||Lv_Delimitador                                                                                                                         
                        ||NVL(Lr_DatosFacturacion.CICLO_FACTURACION,'')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.id_documento,0)||Lv_Delimitador 
                        ||NVL(REGEXP_REPLACE(
                               Lr_DatosFacturacion.nombre_tipo_documento, '[[:cntrl:];"]', ''), '')||Lv_Delimitador 
                        ||NVL(REGEXP_REPLACE(
                               Lr_DatosFacturacion.numero_documento, '[[:cntrl:];"]', ''), '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.subtotal, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.subtotal_descuento, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.valor_real, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.subtotal_impuesto_cer, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.subtotal_impuesto_doc, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.subtotal_impuesto_cat, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.subtotal_con_impuesto, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.iva, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.ice, 0)||Lv_Delimitador 
                        ||Lv_FilaCompensacion
                        ||NVL(Lr_DatosFacturacion.valor_total, 0)||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.es_automatica, '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.usr_creacion, '')||Lv_Delimitador  
                        ||Lv_FilaUsrUltMod  
                        ||NVL(Lr_DatosFacturacion.estado_documento, '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.fecha_creacion, '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.fecha_emision, '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.fecha_autorizacion, '')||Lv_Delimitador
                        ||Lv_FilaFeUltMod   
                        ||Lv_FilaFeAnulacion
                        ||NVL(Lr_DatosFacturacion.forma_pago, '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.nombre_vendedor, '')||Lv_Delimitador     
                        ||NVL(Lr_DatosFacturacion.nombre_oficina, '')||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.codigo_tipo_negocio, '')||Lv_Delimitador 
                        ||Lr_DatosFacturacion.motivo_anulacion_doc||Lv_Delimitador 
                        ||Lv_TipoResponsable||Lv_Delimitador
                        ||Lv_DescripcionArea||Lv_Delimitador 
                        ||Lv_FacturaAplica||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.motivo_documento, '')||Lv_Delimitador 
                        ||Lv_PagoAplica||Lv_Delimitador 
                        ||Lv_FechaPagoAplica||Lv_Delimitador 
                        ||Lv_Comentario||Lv_Delimitador 
                        ||Lv_Multa||Lv_Delimitador 
                        ||Lf_ValorRetenciones||Lv_Delimitador 
                        ||NVL(Lr_DatosFacturacion.oficina_facturacion, '')||Lv_Delimitador
                        ||Lv_FilaRetenciones
                        ||NVL(Lr_DatosFacturacion.SERVICIOS, '')||Lv_Delimitador
               );

    END LOOP;
    UTL_FILE.fclose(Lfile_Archivo); 
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  

    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio, 
                                              Lv_NombreArchivoZip); 
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 

  END P_REPORTE_FACTURACION;

  FUNCTION F_GET_VARCHAR_CLEAN(
          Fv_Cadena IN VARCHAR2)
      RETURN VARCHAR2
  IS
  BEGIN
      RETURN TRIM(
              REPLACE(
              REPLACE(
              REPLACE(
              REPLACE(
              TRANSLATE(
              REGEXP_REPLACE(
              REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|¿|<|>|/|;|,|.|%|"]|[)]+$', ' ')
              ,'[^A-Za-z0-9ÁÉÍÓÚáéíóúÑñ&()-_ ]' ,' ')
              ,'ÁÉÍÓÚÑ,áéíóúñ', 'AEIOUN aeioun')
              , Chr(9), ' ')
              , Chr(10), ' ')
              , Chr(13), ' ')
              , Chr(59), ' '));
      --

  END F_GET_VARCHAR_CLEAN;

  PROCEDURE P_GET_PAGOS_VENDEDOR(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  )
  IS

  BEGIN

    Pc_Documentos := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PAGOS_VENDEDOR(Pn_EmpresaId,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pv_EmailUsrSesion,
                                                                      Pv_FechaCreacionDesde,
                                                                      Pv_FechaCreacionHasta,
                                                                      Pv_Identificacion,
                                                                      Pv_RazonSocial,
                                                                      Pv_Nombres,
                                                                      Pv_Apellidos,
                                                                      Pn_Start,
                                                                      Pn_Limit,
                                                                      Pn_TotalRegistros
                                                                      );

    EXCEPTION
      WHEN OTHERS THEN
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_REPORTE_FINANCIERO', 
                                                    'FNKG_REPORTE_FINANCIERO.P_GET_PAGOS_VENDEDOR', 
                                                    SQLERRM
                                                   );
  END P_GET_PAGOS_VENDEDOR;


  PROCEDURE P_REPORTE_PAGOS_VENDEDOR(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE
  )
  IS

    Lv_Directorio                 VARCHAR2(50)   := 'DIR_REPGERENCIA';
    Lv_NombreArchivo              VARCHAR2(100)  := 'ReportePagosVendedor_'||Pv_PrefijoEmpresa||'_'||Pv_UsrSesion                                                                  ||Pv_UsrSesion||'.csv';
    Lv_Delimitador                VARCHAR2(1)    := ';';
    Lv_Gzip                       VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_Remitente                  VARCHAR2(20)   := 'telcos@telconet.ec';
    Lv_Destinatario               VARCHAR2(100)  := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
    Lv_Asunto                     VARCHAR2(300)  := 'Notificacion REPORTE DE PAGOS POR VENDEDOR ';
    Lv_Cuerpo                     VARCHAR2(9999) := '';
    Ln_Total                      NUMBER         := 0;
    Lv_NombreArchivoZip           VARCHAR2(250)  := Lv_NombreArchivo||'.gz';
    Lc_GetPagosVendedor           SYS_REFCURSOR;
    Lr_Datos                      DB_FINANCIERO.FNKG_TYPES.Lr_RptPagosVendedor;
    Lc_GetAliasPlantilla          FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo                 UTL_FILE.FILE_TYPE;

  BEGIN

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000); 

    Lc_GetPagosVendedor  := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PAGOS_VENDEDOR(Pn_EmpresaId,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pv_EmailUsrSesion,
                                                                      Pv_FechaCreacionDesde,
                                                                      Pv_FechaCreacionHasta,
                                                                      Pv_Identificacion,
                                                                      Pv_RazonSocial,
                                                                      Pv_Nombres,
                                                                      Pv_Apellidos,
                                                                      NULL,
                                                                      NULL,
                                                                      Ln_Total
                                                                      );

   -- CABECERA DEL REPORTE
   utl_file.put_line(Lfile_Archivo,'USUARIO QUE GENERA: '||Pv_UsrSesion||Lv_Delimitador  
           ||' '||Lv_Delimitador 
           ||'FECHA DE GENERACION:  '||TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS')||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
             );

   utl_file.put_line(Lfile_Archivo,'DESDE: '||Pv_FechaCreacionDesde||Lv_Delimitador  
           ||' '||Lv_Delimitador 
           ||'HASTA: '||Pv_FechaCreacionHasta||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
           ||' '||Lv_Delimitador 
            );

    utl_file.put_line(Lfile_Archivo,'VENDEDOR'||Lv_Delimitador  
           ||'CLIENTE'||Lv_Delimitador 
           ||'LOGIN'||Lv_Delimitador 
           ||'FECHA PAGO'||Lv_Delimitador 
           ||'NUMERO PAGO'||Lv_Delimitador 
           ||'FORMA DE PAGO'||Lv_Delimitador 
           ||'ESTADO DE PAGO'||Lv_Delimitador 
           ||'VALOR PAGO'||Lv_Delimitador 
           ||'CODIGO TIPO DOCUMENTO'||Lv_Delimitador 
           ||'FACTURA'||Lv_Delimitador 
           ||'FECHA FACTURA'||Lv_Delimitador 
           ||'ESTADO FACTURA'||Lv_Delimitador 
           );  
    LOOP
      FETCH Lc_GetPagosVendedor INTO Lr_Datos;     
        EXIT
        WHEN Lc_GetPagosVendedor%NOTFOUND; 
        UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_Datos.vendedor, '')||Lv_Delimitador  
             ||NVL(Lr_Datos.cliente, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.login,'')||Lv_Delimitador 
             ||NVL(Lr_Datos.fecha_pago, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.numero_pago, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.forma_pago, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.estado_pago, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.valor_pago, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.codigo_tipo_documento, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.factura, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.fecha_factura, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.estado_factura, '')||Lv_Delimitador 
             );                           

    END LOOP; 

    UTL_FILE.fclose(Lfile_Archivo);
    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 

    EXCEPTION
      WHEN OTHERS THEN
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR(
                                                    'FNKG_REPORTE_FINANCIERO', 
                                                    'FNKG_REPORTE_FINANCIERO.P_REPORTE_PAGOS_VENDEDOR', 
                                                     SQLERRM
                                                   );
  END P_REPORTE_PAGOS_VENDEDOR;


  FUNCTION F_GET_PAGOS_VENDEDOR(
    Fn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Fv_PrefijoEmpresa               IN  VARCHAR2,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Fv_EmailUsrSesion               IN  VARCHAR2,
    Fv_FechaCreacionDesde           IN  VARCHAR2,
    Fv_FechaCreacionHasta           IN  VARCHAR2,
    Fv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Fv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Fv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Fn_Start                        IN  NUMBER,
    Fn_Limit                        IN  NUMBER,
    Fn_TotalRegistros               OUT NUMBER
  )
    RETURN SYS_REFCURSOR
  IS
  --

    Lv_Query           CLOB;
    --
    Lv_QueryCount      CLOB;
    --
    Lv_QueryAllColumns CLOB;
    --
    Lv_LimitAllColumns CLOB;
    --
    Lv_LimitCount      CLOB;

    Lc_PagosVendedor  SYS_REFCURSOR;
  --
  BEGIN
    Lv_QueryCount      :='SELECT IPC.ID_PAGO TOTAL ';
    Lv_QueryAllColumns :='SELECT * FROM (SELECT ROWNUM ID_QUERY,
                            DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(TRIM(
                                                             REPLACE(
                                                             REPLACE(
                                                             REPLACE(
                                                               IPE.NOMBRES||'' ''||IPE.APELLIDOS, Chr(9), '' ''), Chr(10), '' ''), 
                                                               Chr(13), '' ''))) AS  VENDEDOR,
                             CASE
                               WHEN IPCL.RAZON_SOCIAL IS NULL THEN IPCL.NOMBRES||'' ''||IPCL.APELLIDOS
                             ELSE 
                               DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(TRIM(
                                                                             REPLACE(
                                                                             REPLACE(
                                                                             REPLACE(
                                                                               IPCL.RAZON_SOCIAL, Chr(9), '' ''), Chr(10), '' ''), 
                                                                               Chr(13), '' '')))                  
                             END AS CLIENTE,
                             IP.LOGIN,
                             TO_CHAR( IPC.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_PAGO,
                             IPC.NUMERO_PAGO,
                             AFP.DESCRIPCION_FORMA_PAGO AS FORMA_PAGO,
                             IPC.ESTADO_PAGO,
                             IPD.VALOR_PAGO,
                             ATDF.CODIGO_TIPO_DOCUMENTO,
                             IDFC.NUMERO_FACTURA_SRI AS FACTURA,
                             TO_CHAR( IPC.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FECHA_FACTURA,
                             IDFC.ESTADO_IMPRESION_FACT AS ESTADO_FACTURA ';

      Lv_Query          := 'FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
                              JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPD.PAGO_ID=IPC.ID_PAGO
                              LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IPD.FORMA_PAGO_ID 
                              JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC ON IDFC.ID_DOCUMENTO=IPD.REFERENCIA_ID
                              JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO=IDFC.PUNTO_ID
                              JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.LOGIN=IP.USR_VENDEDOR
                              JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IP.PERSONA_EMPRESA_ROL_ID
                              JOIN DB_COMERCIAL.INFO_PERSONA IPCL ON IPCL.ID_PERSONA=IPER.PERSONA_ID
                              JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF 
                                ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
                            WHERE
                              IPC.EMPRESA_ID='||Fn_EmpresaId||' 
                            AND IPC.ESTADO_PAGO NOT IN (''Anulado'',''Asignado'')   
                            AND IPC.PUNTO_ID IS NOT NULL
                            AND IPC.USR_CREACION <> ''telcos_migracion''
                            AND IPE.LOGIN LIKE ''%' ||Fv_UsrSesion|| '%''';

      IF Fv_FechaCreacionDesde IS NOT NULL AND  Fv_FechaCreacionDesde IS  NOT NULL THEN    
        Lv_Query := Lv_Query || '  AND IPC.FE_CREACION BETWEEN TO_DATE('''||Fv_FechaCreacionDesde||''',''DD/MM/YY'')
                                   AND TO_DATE('''||Fv_FechaCreacionHasta||''',''DD/MM/YY'')' ;
      END IF;

      IF Fv_Identificacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPCL.IDENTIFICACION_CLIENTE LIKE ''%' || Fv_Identificacion || '%''';
        --
      END IF;  

      IF Fv_Nombres IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPCL.NOMBRES LIKE ''%' || Fv_Nombres || '%''';
        --
      END IF; 

      IF Fv_Apellidos IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPCL.APELLIDOS LIKE ''%' || Fv_Apellidos || '%''';
        --
      END IF; 

      IF Fv_RazonSocial IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPCL.RAZON_SOCIAL LIKE ''%' || Fv_RazonSocial || '%''';
        --
      END IF; 

      IF Fn_Start   IS NOT NULL AND  Fn_Limit  IS NOT NULL THEN
        Lv_LimitAllColumns := ' ) TB WHERE TB.ID_QUERY >= ' || NVL(Fn_Start, 0) ||
        ' AND TB.ID_QUERY <= ' || (NVL(Fn_Start,0) + NVL(Fn_Limit,0)) || ' ORDER BY TB.ID_QUERY' ;
      ELSE
        Lv_LimitAllColumns := ' )  TB ORDER BY TB.ID_QUERY'
        ;
      END IF;     

  Lv_QueryAllColumns := Lv_QueryAllColumns || Lv_Query || Lv_LimitAllColumns;
  Lv_QueryCount      := Lv_QueryCount || Lv_Query;

  OPEN Lc_PagosVendedor FOR Lv_QueryAllColumns;

  Fn_TotalRegistros := FNKG_REPORTE_FINANCIERO.F_GET_COUNT_REFCURSOR(Lv_QueryCount);
  --
  RETURN Lc_PagosVendedor;
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR(
                                                  'FNKG_REPORTE_FINANCIERO', 
                                                  'FNKG_REPORTE_FINANCIERO.F_GET_PAGOS_VENDEDOR', 
                                                  SQLERRM
                                                 );

      RETURN NULL;
      --
  END F_GET_PAGOS_VENDEDOR;

  FUNCTION F_INFO_CLIENTE_CICLOFAC(
    Fv_TipoInformacion     IN VARCHAR2,
    Fn_IdPersonaRol        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN VARCHAR2
  IS
   --Costo: 1
   CURSOR C_GetPerRolCaractCiclo(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
   IS
   SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT,
   CI.NOMBRE_CICLO,
   IPERC.ESTADO
   FROM 
   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, 
   DB_COMERCIAL.ADMI_CARACTERISTICA CA,
   DB_FINANCIERO.ADMI_CICLO CI
   WHERE
   IPER.ID_PERSONA_ROL                                          = Cn_IdPersonaRol
   AND IPERC.PERSONA_EMPRESA_ROL_ID                             = IPER.ID_PERSONA_ROL
   AND IPERC.CARACTERISTICA_ID                                  = CA.ID_CARACTERISTICA
   AND CA.DESCRIPCION_CARACTERISTICA                            = 'CICLO_FACTURACION'  
   AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0) = CI.ID_CICLO
   AND IPERC.ESTADO                                             = 'Activo';

   Lr_GetPerRolCaractCiclo     C_GetPerRolCaractCiclo%ROWTYPE;   
   Lv_DatoCicloFact            VARCHAR2(1000);
   Lv_IpCreacion               VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN

    IF C_GetPerRolCaractCiclo%ISOPEN THEN
      CLOSE C_GetPerRolCaractCiclo;
    END IF;
    --
    OPEN C_GetPerRolCaractCiclo(Fn_IdPersonaRol);
    --
    FETCH C_GetPerRolCaractCiclo INTO Lr_GetPerRolCaractCiclo;
    IF(C_GetPerRolCaractCiclo%FOUND) THEN
    --
       IF Fv_TipoInformacion='CICLO_FACTURACION' THEN    
          Lv_DatoCicloFact := Lr_GetPerRolCaractCiclo.NOMBRE_CICLO; 
       END IF;
    END IF; 
    CLOSE C_GetPerRolCaractCiclo;
    --
 RETURN Lv_DatoCicloFact;
  --
EXCEPTION
WHEN OTHERS THEN 
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC', 
                                        'Error al obtener información de CICLO_FACTURACION del cliente
                                        (' || Fv_TipoInformacion || ', ' || Fn_IdPersonaRol || ') - '
                                        || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
  --
  RETURN NULL;
  --
  END F_INFO_CLIENTE_CICLOFAC;
  --
  --
  FUNCTION F_GET_COUNT_REFCURSOR(
      Lcl_Consulta IN CLOB)
    RETURN NUMBER
  IS
    Lrf_Count    Lrf_Result;
    Lt_RefCursor Lt_Result;
  BEGIN
    --
    OPEN Lrf_Count FOR Lcl_Consulta;
    --
    FETCH
      Lrf_Count BULK COLLECT
    INTO
      Lt_RefCursor;
    --
    RETURN Lt_RefCursor.COUNT;
    --
  END F_GET_COUNT_REFCURSOR;

  PROCEDURE P_CONF_REPORT_AUTOM_PAGOS(
    PV_TIPODOCUMENTO IN VARCHAR2,
    PV_ESTADOPUNTO   IN VARCHAR2,
    PV_ESTADOPAGO    IN VARCHAR2,
    PV_FORMAPAGO     IN VARCHAR2,
    PV_USRSESION     IN VARCHAR2,
    PV_IPCLIENT      IN VARCHAR2,
    PV_CODEMPRESA    IN VARCHAR2)
  IS

    CURSOR C_VALIDA_CAB(PV_PARAMETRO VARCHAR2)
    IS
      SELECT * FROM ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO=PV_PARAMETRO;

    CURSOR C_VALIDA_DET(PN_PARAMETRO NUMBER)
    IS
      SELECT COUNT(*) AS CANT
      FROM ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID=PN_PARAMETRO;

    LC_VALIDA_CAB C_VALIDA_CAB%ROWTYPE;
    LC_VALIDA_DET C_VALIDA_DET%ROWTYPE;
    LV_NOMBRE_CAB VARCHAR2(1000):='CONFIG_REP_AUT_PAG';

  BEGIN

    OPEN C_VALIDA_CAB(LV_NOMBRE_CAB);
    FETCH C_VALIDA_CAB INTO LC_VALIDA_CAB;
    CLOSE C_VALIDA_CAB;

    IF LC_VALIDA_CAB.ID_PARAMETRO IS NOT NULL THEN

      OPEN C_VALIDA_DET(LC_VALIDA_CAB.ID_PARAMETRO);
      FETCH C_VALIDA_DET INTO LC_VALIDA_DET;
      CLOSE C_VALIDA_DET;

      IF LC_VALIDA_DET.CANT = 8 THEN

        UPDATE ADMI_PARAMETRO_DET
        SET VALOR1      =PV_TIPODOCUMENTO,
          IP_ULT_MOD    =PV_IPCLIENT,
          USR_ULT_MOD   =PV_USRSESION,
          FE_ULT_MOD    =SYSDATE,
          EMPRESA_COD   =PV_CODEMPRESA
        WHERE VALOR2    ='TIPO_DOCUMENTO'
        AND PARAMETRO_ID=LC_VALIDA_CAB.ID_PARAMETRO;

        UPDATE ADMI_PARAMETRO_DET
        SET VALOR1      =PV_ESTADOPUNTO,
          IP_ULT_MOD    =PV_IPCLIENT,
          USR_ULT_MOD   =PV_USRSESION,
          FE_ULT_MOD    =SYSDATE,
          EMPRESA_COD   =PV_CODEMPRESA
        WHERE VALOR2    ='ESTADO_PUNTO'
        AND PARAMETRO_ID=LC_VALIDA_CAB.ID_PARAMETRO;

        UPDATE ADMI_PARAMETRO_DET
        SET VALOR1      =PV_ESTADOPAGO,
          IP_ULT_MOD    =PV_IPCLIENT,
          USR_ULT_MOD   =PV_USRSESION,
          FE_ULT_MOD    =SYSDATE,
          EMPRESA_COD   =PV_CODEMPRESA
        WHERE VALOR2    ='ESTADO_PAGO'
        AND PARAMETRO_ID=LC_VALIDA_CAB.ID_PARAMETRO;

        UPDATE ADMI_PARAMETRO_DET
        SET VALOR1      =PV_FORMAPAGO,
          IP_ULT_MOD    =PV_IPCLIENT,
          USR_ULT_MOD   =PV_USRSESION,
          FE_ULT_MOD    =SYSDATE,
          EMPRESA_COD   =PV_CODEMPRESA
        WHERE VALOR2    ='FORMA_PAGO'
        AND PARAMETRO_ID=LC_VALIDA_CAB.ID_PARAMETRO;

        COMMIT;
      ELSE
        RAISE_APPLICATION_ERROR(-20010,'Falta configurar mas parametros');
      END IF;

    ELSE
      RAISE_APPLICATION_ERROR(-20020,'No se encuentra la configuracion de los parametros');
    END IF;

  END P_CONF_REPORT_AUTOM_PAGOS;

  FUNCTION F_GET_PARM_CONF(
      PV_PARAMETRO IN VARCHAR)
  RETURN VARCHAR2
  IS
    CURSOR C_BUSCA_PARAMETRO(PV_PARAM_BUSC VARCHAR2) IS
    SELECT VALOR1,VALOR2
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
         DB_GENERAL.ADMI_PARAMETRO_DET DET
    WHERE CAB.NOMBRE_PARAMETRO='CONFIG_REP_AUT_PAG'
      AND CAB.ID_PARAMETRO=DET.PARAMETRO_ID
      AND DET.VALOR2=PV_PARAM_BUSC;

  LC_BUSCA_PARAMETRO C_BUSCA_PARAMETRO%ROWTYPE;

  BEGIN

    OPEN C_BUSCA_PARAMETRO(PV_PARAMETRO);
    FETCH C_BUSCA_PARAMETRO INTO LC_BUSCA_PARAMETRO;
    CLOSE C_BUSCA_PARAMETRO;

    RETURN LC_BUSCA_PARAMETRO.VALOR1;
  END F_GET_PARM_CONF;

  PROCEDURE P_GUARDA_EJECUCION_JOB(
    PV_EMPRESACOD  IN VARCHAR2,
    PV_CODTIPREP   IN VARCHAR2,
    PV_EMAILUSR    IN VARCHAR2,
    PV_APLICACION  IN VARCHAR2,
    PV_OBSERVACION IN VARCHAR2,
    PV_USRCREACION IN VARCHAR2 DEFAULT USER,
    PD_FECCREACION IN DATE DEFAULT SYSDATE)
  IS

  BEGIN

    INSERT
    INTO DB_FINANCIERO.INFO_REPORTE_HISTORIAL
      (
        ID_REPORTE_HISTORIAL,
        EMPRESA_COD,
        CODIGO_TIPO_REPORTE,
        USR_CREACION,
        FE_CREACION,
        EMAIL_USR_CREACION,
        APLICACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_FINANCIERO.SEQ_INFO_REPORTE_HISTORIAL.NEXTVAL,
        PV_EMPRESACOD,
        PV_CODTIPREP,
        PV_USRCREACION,
        PD_FECCREACION,
        PV_EMAILUSR,
        PV_APLICACION,
        'Activo',
        PV_OBSERVACION
      );

      COMMIT;

  END P_GUARDA_EJECUCION_JOB;

  PROCEDURE P_GEN_REPORTE_BURO(
    Pv_Host                     IN  VARCHAR2,
    Pv_PathFileLogger           IN  VARCHAR2,
    Pv_NameFileLogger           IN  VARCHAR2,
    Pv_PrefijoEmpresa           IN  VARCHAR2, 
    Pv_IpSession                IN  VARCHAR2,
    Pv_UsuarioSession           IN  VARCHAR2,
    Pv_ValorClientesBuenos      IN  VARCHAR2,
    Pv_ValorClientesMalos       IN  VARCHAR2,
    Pv_DirectorioUpload         IN  VARCHAR2,
    Pv_Ambiente                 IN  VARCHAR2,
    Pv_EmailUsrSesion           IN  VARCHAR2
  )
  IS
  --
  CURSOR C_Directory(Pv_Directorio VARCHAR2) IS
    SELECT DIRECTORY_PATH
    FROM ALL_DIRECTORIES
    WHERE UPPER(DIRECTORY_NAME) = Pv_Directorio;

    --Costo 5
    CURSOR C_PARAMETROS(Cv_NombreParametro      VARCHAR2,
                        Cv_DescripcionParametro VARCHAR2)
    IS 
      SELECT APD.VALOR1,
        APD.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APD.PARAMETRO_ID IN (SELECT APC.ID_PARAMETRO
                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                 WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro) 
      AND APD.DESCRIPCION = Cv_DescripcionParametro;  

    --Costo 4
    CURSOR C_RUTA_ARCHIVO_NFS (Cv_PrefijoEmpresa VARCHAR2)
    IS
      SELECT AGD.CODIGO_APP,
        AGD.CODIGO_PATH 
      FROM DB_FINANCIERO.ADMI_GESTION_DIRECTORIOS AGD
      WHERE AGD.APLICACION = 'TelcosWeb' 
      AND AGD.SUBMODULO    = 'ReporteBuro' 
      AND AGD.EMPRESA      = Cv_PrefijoEmpresa; 

  Lv_Query                  VARCHAR2(30000):= ''; 
  Lv_FnosPtoCliente         VARCHAR2(2000) := ''; 
  Lv_BancoEmpresa           VARCHAR2(100)  := '';
  Lv_TipoDocumento          VARCHAR2(100)  := '';
  Lv_FechaActual            VARCHAR2(100)  :=  TO_CHAR(SYSDATE, 'DD-MM-YYYY');
  Lv_FechaHoraRpt           VARCHAR2(100)  :=  TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  Lv_FechaCorte             VARCHAR2(100)  :=  TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 
  Lv_Directorio             VARCHAR2(100)  := 'DIR_BKREPBURO';
  Lv_DirectorioF            VARCHAR2(100)  := 'DIR_REPBURO';
  Lv_NombreArchivo          VARCHAR2(200)  := 'reporte_buro_'||Pv_PrefijoEmpresa||'_'||Lv_FechaHoraRpt;
  Lv_Gzip                   VARCHAR2(500)  := '';
  Lv_Delimitador            VARCHAR2(1)    := '|';
  Lv_NombreArchivoCsv       VARCHAR2(200)  := Lv_NombreArchivo||'.csv';
  Lv_NombreArchivoGz        VARCHAR2(200)  := Lv_NombreArchivoCsv||'.gz';
  Lv_NombreArchivoZip       VARCHAR2(200)  := Lv_NombreArchivo||'.zip';
  Lv_Remitente              VARCHAR2(20)   := 'telcos@telconet.ec';
  Lv_Destinatario           VARCHAR2(100)  := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
  Lv_Asunto                 VARCHAR2(300)  := 'Telcos+ : Generacion Reporte Buro '||Lv_FechaActual;
  Lv_Cuerpo                 VARCHAR2(9999) := '';
  Lv_ValorPorVencer         VARCHAR2(100)  := ''; 
  Lv_ValorVencido           VARCHAR2(100)  := ''; 
  Lv_ValorDemJudicial       VARCHAR2(100)  := ''; 
  Lv_ValorDemCastigada      VARCHAR2(100)  := '';
  Lv_TiempoVencido          VARCHAR2(100)  := '';  
  Lv_TipoPago               VARCHAR2(100)  := '';
  Lv_Emisor                 VARCHAR2(100)  := '';
  Lv_RetiroEquipo           VARCHAR2(100)  := '';
  Lv_EmpresaCod             VARCHAR2(100)  := '';
  Lv_fechaVencimiento       VARCHAR2(100)  := '';
  Lc_ReporteBuro            SYS_REFCURSOR;
  Lr_Datos                  DB_FINANCIERO.FNKG_TYPES.Lr_ClienteRptBuro;
  Lr_GetAliasPlantilla      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  Lfile_Archivo             utl_file.file_type;
  Lr_TipoClientes           DBMS_SQL.VARCHAR2_TABLE;
  Lr_InfoTransacciones      DB_SEGURIDAD.INFO_TRANSACCIONES%ROWTYPE;
  Lr_InfoReporteHistorial   DB_FINANCIERO.INFO_REPORTE_HISTORIAL%ROWTYPE;
  Lc_Directory              C_Directory%ROWTYPE;
  Lc_Parametros             C_PARAMETROS%ROWTYPE;
  Lv_CodigoApp              VARCHAR2(150)  := '';
  Lv_CodigoPath             VARCHAR2(150)  := '';
  Lv_PathAdicional          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
  Lv_reponse                VARCHAR2(1000)  := '';
  Lv_Comparacion            VARCHAR2(10)   := '';
  Lv_PathNFS                VARCHAR2(400) := '';

  --
  BEGIN

    OPEN C_Directory(Lv_Directorio);
    FETCH C_Directory INTO Lc_Directory;
    CLOSE C_Directory;

    OPEN C_PARAMETROS ('REPORTE_BURO','REPORTES_DISPONIBLES');
    FETCH C_PARAMETROS INTO Lc_Parametros;
    CLOSE C_PARAMETROS;
    Lv_PathAdicional := Lc_Parametros.valor1;

    OPEN C_PARAMETROS ('REPORTE_BURO','RUTA_NFS');
    FETCH C_PARAMETROS INTO Lc_Parametros;
    CLOSE C_PARAMETROS;

    OPEN C_RUTA_ARCHIVO_NFS (Pv_PrefijoEmpresa);
    FETCH C_RUTA_ARCHIVO_NFS INTO Lv_CodigoApp, Lv_CodigoPath;
    CLOSE C_RUTA_ARCHIVO_NFS;

    Lv_Gzip              :='gzip '||Lc_Directory.DIRECTORY_PATH||Lv_NombreArchivoCsv;


    Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivoCsv,'w',3000);

    Lv_EmpresaCod        := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Pv_PrefijoEmpresa);

    Lr_InfoTransacciones.ID_TRANSACCION         := DB_SEGURIDAD.SEQ_INFO_TRANSACCIONES.NEXTVAL;
    Lr_InfoTransacciones.NOMBRE_TRANSACCION     := Lv_NombreArchivoZip;
    Lr_InfoTransacciones.TIPO_TRANSACCION       := 'Generar';
    Lr_InfoTransacciones.ESTADO                 := 'Pendiente';
    Lr_InfoTransacciones.EMPRESA_ID             := Lv_EmpresaCod;
    Lr_InfoTransacciones.RELACION_SISTEMA_ID    := DB_GENERAL.GNRLPCK_UTIL.F_GET_INFO_TRANSACCION_ID('create','reporte_buro');
    Lr_InfoTransacciones.USR_CREACION           := Pv_UsuarioSession;
    Lr_InfoTransacciones.FE_CREACION            := SYSDATE;
    Lr_InfoTransacciones.IP_CREACION            := Pv_IpSession;
    Lr_InfoTransacciones.USR_ULT_MOD            := Pv_UsuarioSession;
    Lr_InfoTransacciones.FE_ULT_MOD             := SYSDATE;
    Lr_InfoTransacciones.IP_ULT_MOD             := Pv_IpSession;



    Lr_InfoReporteHistorial.ID_REPORTE_HISTORIAL := DB_FINANCIERO.SEQ_INFO_REPORTE_HISTORIAL.NEXTVAL;
    Lr_InfoReporteHistorial.EMPRESA_COD          := Lv_EmpresaCod;
    Lr_InfoReporteHistorial.CODIGO_TIPO_REPORTE  := 'BURO';
    Lr_InfoReporteHistorial.USR_CREACION         := Pv_UsuarioSession;
    Lr_InfoReporteHistorial.FE_CREACION          := SYSDATE ;
    Lr_InfoReporteHistorial.EMAIL_USR_CREACION   := '';

    IF Pv_Ambiente = 'TELCOS' THEN
       Lr_InfoReporteHistorial.EMAIL_USR_CREACION   := Lv_Destinatario;
       Lr_InfoReporteHistorial.APLICACION           := 'Telcos';
    ELSE
       Lr_InfoReporteHistorial.APLICACION           := 'Telcos Job';
    END IF;


    Lr_InfoReporteHistorial.ESTADO               := 'Pendiente';
    Lr_InfoReporteHistorial.OBSERVACION          := 'Ejecucion de reporte de buro - Ambiente :'||Pv_Ambiente||
                                                    ' Inicio:'||Lr_InfoReporteHistorial.FE_CREACION;
    Lr_InfoReporteHistorial.FE_ULT_MOD           := SYSDATE;

    --Se crea una transacción a estado Pendiente.
    DB_GENERAL.GECK_TRANSACTION.P_INSERT_INFO_TRANSACCIONES(Lr_InfoTransacciones);

    --Se crea registro de historial.
    DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_REPORTE_HIST(Lr_InfoReporteHistorial);

    Lr_TipoClientes(1)  := 'ClieBuenosActivos';
    Lr_TipoClientes(2)  := 'ClieMalosCancelados';
    Lr_TipoClientes(3)  := 'ClieMalosTrasladados';
    Lr_TipoClientes(4)  := 'ClieMalosEliminados';
    Lr_TipoClientes(5)  := 'ClieMalosCortados';
    Lr_TipoClientes(6)  := 'ClieMalosPrioridadCancelados';
    Lr_TipoClientes(7)  := 'ClieMalosPrioridadTrasladados';
    Lr_TipoClientes(8)  := 'ClieMalosPrioridadEliminados';
    Lr_TipoClientes(9)  := 'ClieMalosPrioridadAnulados';
    Lr_TipoClientes(10) := 'ClieMalosPrioridadInCorte';

   -- CABECERA DEL REPORTE
    utl_file.put_line(Lfile_Archivo, 'TIPO DE DOCUMENTO'||Lv_Delimitador 
                                     ||'# CED o RUC'||Lv_Delimitador 
                                     ||'APELLIDOS Y NOMBRES'||Lv_Delimitador 
                                     ||'DIRECCION'||Lv_Delimitador 
                                     ||'CIUDAD'||Lv_Delimitador 
                                     ||'TELEFONO'||Lv_Delimitador 
                                     ||'ACREEDOR'||Lv_Delimitador 
                                     ||'FECHA DE CORTE'||Lv_Delimitador 
                                     ||'TIPO DE RIESGO'||Lv_Delimitador 
                                     ||'N0 OPERACION'||Lv_Delimitador 
                                     ||'FECHA DE CONCESION'||Lv_Delimitador 
                                     ||'VALOR ORIGINAL CONCEDIDO'||Lv_Delimitador  
                                     ||'DEUDA TOTAL USD'||Lv_Delimitador 
                                     ||'VALOR POR VENCER USD'||Lv_Delimitador 
                                     ||'VALOR VENCIDO USD'||Lv_Delimitador 
                                     ||'DEMANDA JUDICIAL'||Lv_Delimitador 
                                     ||'CARTERA CASTICADA'||Lv_Delimitador 
                                     ||'TIEMPO VENCIDO DIAS'||Lv_Delimitador 
                                     ||'EMAIL'||Lv_Delimitador
                                     ||'ESTADO CLIENTE'||Lv_Delimitador 
                                     ||'TELEFONOS POR PUNTO'||Lv_Delimitador 
                                     ||'EMAILS POR PUNTO'||Lv_Delimitador 
                                     ||'DIRECCION_CLIENTE'||Lv_Delimitador
                                     ||'COORDENADAS'||Lv_Delimitador 
                                     ||'FORMA_PAGO'||Lv_Delimitador 
                                     ||'TIPO_PAGO'||Lv_Delimitador 
                                     ||'EMISOR'||Lv_Delimitador 
                                     ||'RETIRO_EQUIPOS'||Lv_Delimitador 
                                     ||'CICLO'||Lv_Delimitador
                                     ||'CANCELACION VOLUNTARIA'||Lv_Delimitador );

   FOR i IN Lr_TipoClientes.FIRST .. Lr_TipoClientes.LAST
   LOOP

      DB_FINANCIERO.FNCK_CONSULTS.P_GET_REPORTE_BURO(Lv_EmpresaCod,Lr_TipoClientes(i),Pv_ValorClientesBuenos,Pv_ValorClientesMalos, Lc_ReporteBuro);

    LOOP
      FETCH Lc_ReporteBuro INTO Lr_Datos;     
        EXIT
        WHEN Lc_ReporteBuro%NOTFOUND;

        Lv_FnosPtoCliente  := TO_CHAR(DBMS_LOB.SUBSTR(DB_FINANCIERO.FNCK_CONSULTS.F_GET_INFORMACION_PUNTO_CLOB(NVL(Lr_Datos.id_persona,0), 
                                                                                                               NVL(Lr_Datos.estado,''), 
                                                                                                               Lv_EmpresaCod, 
                                                                                                               'telfPtoPerson'), 2000, 1 ));
        IF Lr_Datos.estado = 'Activo' THEN
          --
          Lv_ValorPorVencer  := NVL(Lr_Datos.saldo, '0'); 
          Lv_ValorVencido    := '0'; 
          --
        ELSE ---
          --
          Lv_ValorPorVencer  := '0';

          IF Lr_Datos.forma_pago IS NOT NULL THEN
            --
            IF Lr_Datos.forma_pago = 'CARTERA LEGAL' THEN
              --
              Lv_ValorVencido    := '0'; 
                --
            ELSE 
              --
              Lv_ValorVencido    := NVL(Lr_Datos.saldo, '0'); 
                -- 
            END IF;
              --
          ELSE 
            --
            Lv_ValorVencido    := NVL(Lr_Datos.saldo, '0'); 
              -- 
          END IF;
        END IF;

        IF Lr_Datos.forma_pago IS NOT NULL THEN
          --
          IF Lr_Datos.forma_pago = 'CARTERA DEMANDADA' THEN
            --
            Lv_ValorDemJudicial    := NVL(Lr_Datos.saldo, '0');
              --
          ELSE 
            --
            Lv_ValorDemJudicial    := '0';
              -- 
          END IF;
            --
        ELSE 
          --
          Lv_ValorDemJudicial    := '0'; 
            -- 
        END IF;

        Lv_ValorDemCastigada :='0'; 

        IF Lr_Datos.estado = 'Activo' THEN
          --
          Lv_TiempoVencido  := '0';
          --
        ELSE 
          --
          Lv_fechaVencimiento  := SUBSTR(Lv_fechaVencimiento,0,10);
          Lv_TiempoVencido     := DB_FINANCIERO.FNCK_CONSULTS.F_GET_DIFERENCIAS_FECHAS(Lv_fechaVencimiento,Lv_FechaActual);
          Lv_TiempoVencido     := NVL(Lv_TiempoVencido, '0');   
          --    
        END IF;

        IF Lr_Datos.tipo_cuenta IS NOT NULL THEN
          --
          Lv_TipoPago := NVL(Lr_Datos.tipo_cuenta, ''); 
            --
        ELSE 
          --
          Lv_TipoPago := NVL(Lr_Datos.forma_pago, ''); 
            -- 
        END IF;
          -- 
        IF Lr_Datos.banco_tarjeta IS NOT NULL THEN
          --
          Lv_Emisor := NVL(Lr_Datos.banco_tarjeta, ''); 
            --
        ELSE 
          --
          Lv_Emisor := NVL(Lr_Datos.forma_pago, ''); 
            -- 
        END IF;

        IF (Lr_Datos.estado = 'Activo' OR Lr_Datos.estado = 'In-Corte')  THEN
          --
          Lv_RetiroEquipo  := ''; 
            --
        ELSE 
          --
          Lv_RetiroEquipo := NVL(Lr_Datos.retiro_equipo, ''); 
            -- 
        END IF;



        utl_file.put_line(Lfile_Archivo, NVL(Lr_Datos.tipo_documento, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.identificacion_cliente, '')||Lv_Delimitador 
                                         ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                             Lr_Datos.nombre_cliente, Chr(9), ' '), Chr(10), ' '),
                                                                             Chr(13), ' '), Chr(34), ' '))), '')||Lv_Delimitador  
                                         ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                             Lr_Datos.direccion_punto, Chr(9), ' '), Chr(10), ' '),
                                                                             Chr(13), ' '))), '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.canton_punto, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.telefono_cliente, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.acreedor, '')||Lv_Delimitador 
                                         ||Lv_FechaCorte||Lv_Delimitador 
                                         ||'TITULAR'||Lv_Delimitador 
                                         ||NVL(Lr_Datos.numero_contrato, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.fecha_concesion, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.saldo, '0')||Lv_Delimitador  
                                         ||NVL(Lr_Datos.saldo, '0')||Lv_Delimitador 
                                         ||Lv_ValorPorVencer||Lv_Delimitador 
                                         ||Lv_ValorVencido||Lv_Delimitador 
                                         ||Lv_ValorDemJudicial||Lv_Delimitador 
                                         ||Lv_ValorDemCastigada||Lv_Delimitador 
                                         ||Lv_TiempoVencido||Lv_Delimitador
                                         ||NVL(Lr_Datos.email_cliente, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.estado, '')||Lv_Delimitador
                                         ||NVL(Lv_FnosPtoCliente, '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.email_cliente, '')||Lv_Delimitador 
                                         ||NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                             Lr_Datos.direccion_cliente, Chr(9), ' '), Chr(10), ' '),
                                                                             Chr(13), ' '))), '')||Lv_Delimitador 
                                         ||NVL(Lr_Datos.coordenadas, '')||Lv_Delimitador
                                         ||NVL(Lr_Datos.forma_pago, '')||Lv_Delimitador
                                         ||Lv_TipoPago||Lv_Delimitador 
                                         ||Lv_Emisor||Lv_Delimitador 
                                         ||Lv_RetiroEquipo||Lv_Delimitador 
                                         ||Lr_Datos.CICLO||Lv_Delimitador
                                         ||NVL(Lr_Datos.cancel_voluntaria, 'No')||Lv_Delimitador );

    END LOOP; 

   END LOOP;

   UTL_FILE.fclose(Lfile_Archivo);
   DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  

   --Se actualiza el estado de la transacción a estado Activo.
   DB_GENERAL.GECK_TRANSACTION.P_UPDATE_INFO_TRANSACCIONES(
     Lr_InfoTransacciones.ID_TRANSACCION,
     Pv_UsuarioSession,
     Pv_IpSession);

   --Se actualiza historial del reporte a estado Activo.
   DB_FINANCIERO.FNCK_TRANSACTION.P_UPDATE_INFO_REPORTE_HIST(
     Lr_InfoReporteHistorial.ID_REPORTE_HISTORIAL);

   COMMIT;

   UTL_FILE.FCOPY(Lv_Directorio,Lv_NombreArchivoGz,Lv_Directorio,Lv_NombreArchivoZip);

    -- Si el reporte es generado desde la aplicación se envia correo al usuario confirmando que terminó el proceso.
   IF Pv_Ambiente = 'TELCOS' THEN
      --
      Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
      Lv_Cuerpo            := Lr_GetAliasPlantilla.PLANTILLA;

      DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                Lv_Destinatario,
                                                Lv_Asunto, 
                                                Lv_Cuerpo, 
                                                Lv_Directorio, 
                                                Lv_NombreArchivoZip);  
        -- 
   END IF;

   -- Se mueve el reporte zipeado desde el directorio del dbserver al fileserver
   Lv_reponse:= DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_HTTPPOSTMULTIPART(Lc_Parametros.VALOR2,
                                                                         Lc_Directory.DIRECTORY_PATH||Lv_NombreArchivoGz,
                                                                         Lv_NombreArchivoZip,
                                                                         Lv_PathAdicional,
                                                                         Lv_CodigoApp,
                                                                         Lv_CodigoPath);

   Lv_Comparacion := DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_CONTAINS(Lv_reponse,'200');
   IF Lv_Comparacion = 'OK' THEN
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Telcos+', 
                                                  'FNKG_REPORTE_FINANCIERO.P_GEN_REPORTE_BURO', 
                                                  'RESPUESTA DEL WS NFS: '||Lv_reponse);
      apex_json.parse (Lv_reponse);
      FOR i IN 1 .. apex_json.get_count('data') LOOP
        Lv_PathNFS := apex_json.get_varchar2('data[%d].pathFile', p0=>i);
      END LOOP;
      --Actualizacion de path-nfs en info_transaccion
      DB_GENERAL.GECK_TRANSACTION.P_UPDATE_URL_INFOTRANSAC(Lr_InfoTransacciones.ID_TRANSACCION, Lv_PathNFS);
      COMMIT;
      UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

   ELSE

      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Telcos+', 
                                                  'FNKG_RECAUDACIONES.P_GEN_REPORTE_BURO', 
                                                  'ERROR EN RESPUESTA DEL WS NFS: '||Lv_reponse);
   END IF;

   UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoGz);

   EXCEPTION
     WHEN OTHERS THEN
       --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_REPORTE_BURO', 
                                                    'FNKG_REPORTE_BURO.P_GEN_REPORTE_BURO', 
                                                    ' ERROR '||SQLERRM||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                                    ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

  END P_GEN_REPORTE_BURO;

END FNKG_REPORTE_FINANCIERO;
/
