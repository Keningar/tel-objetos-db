CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C AS 

  /**
   * Documentacion para P_GET_FACTURAS
   *
   * Procedimiento para consultar una o varias facturas segun los filtros ingresados
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  codEmpresa            Código empresa,
   *  fechaEmisionDesde     Fecha de emisión inicial para consultar por rango,
   *  fechaEmisionHasta     Fecha de emisión final para consultar por rango,
   *  estado                Estado de la factura,
   *  idPunto               Id del punto de facturación,
   *  identificacionCliente Identificación del cliente,
   * ]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response  OUT CLOB Retorna respuesta de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   26-10-2021
   */
  PROCEDURE P_GET_FACTURAS(Pcl_Request  IN CLOB,
                           Pv_Status    OUT VARCHAR2,
                           Pv_Mensaje   OUT VARCHAR2,
                           Pcl_Response OUT CLOB);                                       
  
  /**
   * Documentacion para P_GET_DOC_FINANCIEROS_CAB
   *
   * Procedimiento para obtener los datos generales de documentos financieros
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  codigosTipoDoc        CodigosTipoDocumento
   *  idPunto               Identificador del punto,
   *  fechaDesde            Fecha inicial para consultar por rango,
   *  fechaHasta            Fecha final para consultar por rango
   * ]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response  OUT CLOB Retorna respuesta de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                              
  PROCEDURE P_GET_DOC_FINANCIEROS_CAB(Pcl_Request  IN CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Prf_Response OUT SYS_REFCURSOR);
  
  /**
   * Documentacion para P_GET_DOC_FIN_ANTIC_PAGOS
   *
   * Procedimiento para obtener los anticipos y pagos relacionados a documentos financieros
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  codigosTipoDoc        CodigosTipoDocumento
   *  idPunto               Identificador del punto,
   *  fechaDesde            Fecha inicial para consultar por rango,
   *  fechaHasta            Fecha final para consultar por rango,
   *  estados               Estados de los documentos
   * ]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response  OUT CLOB Retorna respuesta de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                                     
  PROCEDURE P_GET_DOC_FIN_ANTIC_PAGOS(Pcl_Request  IN CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Prf_Response OUT SYS_REFCURSOR);
  
  /**
   * Documentacion para P_GET_DOC_FINANCIEROS_OG
   *
   * Procedimiento para obtener los documentos financieros OG
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  idPunto               Identificador del punto,
   *  fechaDesde            Fecha inicial para consultar por rango,
   *  fechaHasta            Fecha final para consultar por rango
   * ]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response  OUT CLOB Retorna respuesta de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                                    
  PROCEDURE P_GET_DOC_FINANCIEROS_OG (Pcl_Request  IN CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Prf_Response OUT SYS_REFCURSOR);
  
  /**
   * Documentacion para P_GET_ANTICIPOS_PAGOS
   *
   * Procedimiento para obtener los anticipos y pagos
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  codigosTipoDoc        CodigosTipoDocumento
   *  idPunto               Identificador del punto,
   *  fechaDesde            Fecha inicial para consultar por rango,
   *  fechaHasta            Fecha final para consultar por rango,
   *  estado                Estado del documento
   * ]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response  OUT CLOB Retorna respuesta de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                                    
  PROCEDURE P_GET_ANTICIPOS_PAGOS(Pcl_Request  IN CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Prf_Response OUT SYS_REFCURSOR);
                                  
  /**
   * Documentacion para P_GET_DET_NOT_DEBITOS
   *
   * Procedimiento para obtener los detalles de notas de debitos
   *
   * @param Pn_IdDocumento        IN NUMBER Identificador del documento,
   * @param Pv_Login              IN VARCHAR2 Login del punto de facturación,
   * @param Pv_NombreOficinaGrupo IN VARCHAR2 Nombre de la oficina del grupo,
   * @param Pr_EstadoCuenta       IN OUT FNKG_TYPES_DOCUMENTOS.Ltr_EstadoCuenta Estructura con datos del Estado de Cuenta,
   * @param Pn_Id                 IN OUT NUMBER Id de secuencia del registro de la estructura del Estado de Cuenta,
   * @param Pn_ValorIngresoDoc    IN OUT NUMBER Valor acumulado de los ingresos según el tipo de documento,
   * @param Pn_ValorIngreso       IN OUT NUMBER Valor acumulado de los ingresos en general,
   * @param Pn_SumaValorTotal     IN OUT NUMBER Valor acumulado de la diferencia entre ingresos y egresos,
   * @param Pn_ValorEgresoDoc     IN OUT NUMBER Valor acumulado de los egresos seg{un el tipo de documento,
   * @param Pn_ValorEgreso        IN OUT NUMBER Valor acumulado de los egresos en general
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                                  
  PROCEDURE P_GET_DET_NOT_DEBITOS(Pn_IdDocumento        IN NUMBER,
                                  Pv_Login              IN VARCHAR2,
                                  Pv_NombreOficinaGrupo IN VARCHAR2,
                                  Pr_EstadoCuenta       IN OUT FNKG_TYPES_DOCUMENTOS.Ltr_EstadoCuenta,
                                  Pn_Id                 IN OUT NUMBER,
                                  Pn_ValorIngresoDoc    IN OUT NUMBER,
                                  Pn_ValorIngreso       IN OUT NUMBER,
                                  Pn_SumaValorTotal     IN OUT NUMBER,
                                  Pn_ValorEgresoDoc     IN OUT NUMBER,
                                  Pn_ValorEgreso        IN OUT NUMBER);                                  
                      
END FNKG_DOCUMENTOS_FINANCIEROS_C;
/


CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C AS

  PROCEDURE P_GET_FACTURAS(Pcl_Request  IN CLOB,
                           Pv_Status    OUT VARCHAR2,
                           Pv_Mensaje   OUT VARCHAR2,
                           Pcl_Response OUT CLOB) AS

    CURSOR C_GetFormaPago(Cv_CodigoFormaPago VARCHAR2) IS
      SELECT
        Afp.*
      FROM
        DB_GENERAL.Admi_Forma_Pago Afp
      WHERE
        Afp.Codigo_Forma_Pago = Cv_CodigoFormaPago;
        
    CURSOR C_GetTipoDocumento(Cv_CodigoTipoDocumento VARCHAR2) IS
      SELECT
        Atdf.*
      FROM
        Admi_Tipo_Documento_Financiero Atdf
      WHERE
        Atdf.Codigo_Tipo_Documento = Cv_CodigoTipoDocumento;        
        
    CURSOR C_GetPagoDet(Cn_IdPagoDet NUMBER, Cv_CodEmpresa VARCHAR2) IS
      SELECT
        Iog.nombre_oficina,Ipd.*
      FROM
             Info_Pago_Det Ipd
        INNER JOIN Info_Pago_Cab                   Ipc ON Ipd.Pago_Id = Ipc.Id_Pago
        INNER JOIN Db_Comercial.Info_Oficina_Grupo Iog ON Ipc.Oficina_Id = Iog.Id_Oficina
      WHERE
        Ipd.Id_Pago_Det = Cn_IdPagoDet
      AND Ipc.Empresa_Id = Cv_CodEmpresa;
        
    CURSOR C_GetRefDocFinancieroCab(Cn_RefIdDocumento NUMBER, 
                                    Cv_EstadoImprFact VARCHAR2, 
                                    Cv_NumFacturaSri VARCHAR2) IS
      SELECT
        Idfc.*
      FROM
        Info_Documento_Financiero_Cab Idfc
      WHERE
        Idfc.Referencia_Documento_Id = Cn_RefIdDocumento
      AND Idfc.estado_Impresion_Fact = Cv_EstadoImprFact
      AND Idfc.Numero_Factura_Sri = Cv_NumFacturaSri;
      
     CURSOR C_GetDocumentoFinancieroDet(Cn_IdDocumento NUMBER) IS
      SELECT
        Idfd.*
      FROM
        Info_Documento_Financiero_Det Idfd
      WHERE
        Idfd.Documento_Id = Cn_IdDocumento;      
                           
    Lv_CodEmpresa         DB_COMERCIAL.Info_Empresa_Grupo.cod_Empresa%TYPE;
    Lv_IdentCliente       DB_COMERCIAL.Info_Persona.Identificacion_Cliente%TYPE;
    Ln_Id_Punto           DB_COMERCIAL.Info_Punto.Id_Punto%TYPE;
    Lv_Estado             Info_Documento_Financiero_Cab.Estado_Impresion_Fact%TYPE;  
    Lc_FormaPago          C_GetFormaPago%ROWTYPE;
    Lc_PagoDet            C_GetPagoDet%ROWTYPE;
    Lc_RefDocFinCab       C_GetRefDocFinancieroCab%ROWTYPE;
    Lc_TipoDocumento      C_GetTipoDocumento%ROWTYPE;
    Lr_AdmiParametroDet   DB_GENERAL.Admi_Parametro_Det%ROWTYPE;
    Lv_FeEmisionDesde     VARCHAR2(25);
    Lv_FeEmisionHasta     VARCHAR2(25);
    Lv_WhereFeEmisionD    VARCHAR2(500);
    Lv_WhereFeEmisionH    VARCHAR2(500);
    Lv_Status             VARCHAR2(200);
    Lv_Mensaje            VARCHAR2(3000);
    Lcl_QuerySelect       CLOB;
    Lcl_QueryFrom         CLOB;
    Lcl_QueryWhere        CLOB;
    Lcl_QueryIdentif      CLOB;
    Lcl_Query             CLOB;
    Lcl_Response          CLOB;
    Lcl_ObsDetalleFact    CLOB;
    Lrf_DocumentosCab     SYS_REFCURSOR;
    Lrf_DocRelacionados   SYS_REFCURSOR;
    Li_Cont               PLS_INTEGER;
    Li_ContRel            PLS_INTEGER;
    Ln_ValorAbonado       NUMBER;
    Lr_DocumentoCab       FNKG_TYPES_DOCUMENTOS.Ltr_DocumentoCabecera;
    Lr_DocRelacionado     FNKG_TYPES_DOCUMENTOS.Ltr_InfoDocRelacionado;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Lv_FeEmisionDesde := APEX_JSON.get_varchar2('fechaEmisionDesde');
    Lv_FeEmisionHasta := APEX_JSON.get_varchar2('fechaEmisionHasta');
    Lv_Estado := APEX_JSON.get_varchar2('estado');
    Ln_Id_Punto := APEX_JSON.get_number('idPunto');
    Lv_IdentCliente := APEX_JSON.get_varchar2('identificacionCliente');
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryIdentif, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    
    IF Lv_FeEmisionDesde IS NULL AND Lv_Estado IS NULL THEN
      DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   => 'MS_CORE_FINANCIERO', 
                                                                  Pv_Descripcion       => 'DIAS_DEFAULT_PARA_CONSULTAR_FACTURAS',
                                                                  Pv_Empresa_Cod       => Nvl(Lv_CodEmpresa,10),
                                                                  Pr_AdmiParametroDet  => Lr_AdmiParametroDet,
                                                                  Pv_Status            => Lv_Status,
                                                                  Pv_Mensaje           => Lv_Mensaje); 

      Lv_FeEmisionDesde := to_char(Sysdate - Lr_AdmiParametroDet.Valor1,'rrrr-mm-dd'); 
    END IF;
    
    IF Lv_FeEmisionHasta IS NULL THEN
      Lv_FeEmisionHasta := to_char(Sysdate,'rrrr-mm-dd hh24:mi:ss');
    ELSE
      IF LENGTH(Lv_FeEmisionHasta) = 10 THEN
        Lv_FeEmisionHasta := Lv_FeEmisionHasta || ' 23:59:59';
      END IF;
    END IF;
    
    DBMS_LOB.APPEND(Lcl_QuerySelect,'SELECT
                                      Idfc.Id_Documento AS idDocumento,
                                      Idfc.Oficina_Id AS idOficina,
                                      Iog.Nombre_Oficina AS nombreOficina,
                                      Idfc.Punto_Id AS idPunto,
                                      Idfc.Tipo_Documento_Id AS idTipoDocumento,
                                      Atdf.Nombre_Tipo_Documento AS tipoDocumento,
                                      Idfc.Numero_Factura_Sri AS numeroFactura,
                                      Idfc.Subtotal AS subtotal,
                                      Idfc.Subtotal_Cero_Impuesto AS subtotalCeroImpuesto,
                                      Idfc.Subtotal_Con_Impuesto AS subtotalConImpuesto,
                                      Idfc.Subtotal_Descuento AS subtotalDescuento,
                                      Idfc.Subtotal_ice AS subtotalIce,
                                      Idfc.Subtotal_Servicios AS subtotalServicios,
                                      Idfc.Impuestos_Servicios AS impuestosServicios,
                                      Idfc.Subtotal_Bienes AS subtotalBienes,
                                      Idfc.Impuestos_Bienes AS impuestosBienes,
                                      Idfc.Descuento_Compensacion AS descuentoCompensacion,
                                      Idfc.Establecimiento AS establecimiento,
                                      Idfc.Emision AS emision,
                                      Idfc.Secuencia AS secuencia,
                                      Idfc.Valor_Total AS valorTotal,
                                      Idfc.Entrego_Retencion_Fte AS entregoRetencionFte,
                                      Idfc.Estado_Impresion_Fact AS estado,
                                      Idfc.Es_Automatica AS esAutomatica,
                                      Idfc.Prorrateo AS prorrateo,
                                      Idfc.Reactivacion AS reactivacion,
                                      Idfc.Recurrente AS esRecurrente,
                                      Idfc.Comisiona AS comisiona,
                                      Idfc.Num_Fact_Migracion AS numFactMigracion,
                                      Idfc.Observacion AS observacion,
                                      Idfc.Referencia_Documento_Id AS idReferenciaDocumento,
                                      Idfc.Login_Md AS loginMd,
                                      Idfc.Es_Electronica AS esElectronica,
                                      Idfc.Rango_Consumo AS rangoConsumo,
                                      Idfc.Fe_Emision AS fechaEmision,
                                      Idfc.Numero_Autorizacion AS numeroAutorizacion,
                                      Idfc.Fe_Autorizacion AS fechaAutorizacion,
                                      Idfc.Contabilizado AS contabilizado,
                                      Idfc.Mes_Consumo AS mesConsumo,
                                      Idfc.Anio_Consumo AS anioConsumo,
                                      Idfc.Fe_Creacion AS fechaCreacion,
                                      Idfc.Usr_Creacion AS usuarioCreacion ');
    DBMS_LOB.APPEND(Lcl_QueryFrom,'FROM
                                         Db_Financiero.Info_Documento_Financiero_Cab Idfc
                                    INNER JOIN Db_Financiero.Admi_Tipo_Documento_Financiero Atdf ON Idfc.Tipo_Documento_Id = Atdf.Id_Tipo_Documento
                                    INNER JOIN Db_Comercial.Info_Oficina_Grupo              Iog ON Idfc.Oficina_Id = Iog.Id_Oficina ');
    
    IF Lv_Estado IS NULL THEN
      Lv_WhereFeEmisionD := 'WHERE Idfc.Fe_Emision >= To_Date('':feEmisionD'',''rrrr-mm-dd hh24:mi:ss'') ';
      Lv_WhereFeEmisionH:= 'AND Idfc.Fe_Emision <= To_Date('':feEmisionH'',''rrrr-mm-dd hh24:mi:ss'') ';
    
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(Lv_WhereFeEmisionD, ':feEmisionD', Lv_FeEmisionDesde));
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(Lv_WhereFeEmisionH, ':feEmisionH', Lv_FeEmisionHasta));    
      DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Idfc.Estado_Impresion_Fact <> ''Eliminado'' ');
    ELSE
      DBMS_LOB.APPEND(Lcl_QueryWhere,'WHERE Idfc.Estado_Impresion_Fact = '''||Lv_Estado||''' ');
      IF Lv_FeEmisionDesde IS NOT NULL THEN
        Lv_WhereFeEmisionD := 'AND Idfc.Fe_Emision >= To_Date('':feEmisionD'',''rrrr-mm-dd hh24:mi:ss'') ';
        Lv_WhereFeEmisionH:= 'AND Idfc.Fe_Emision <= To_Date('':feEmisionH'',''rrrr-mm-dd hh24:mi:ss'') ';    
        DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(Lv_WhereFeEmisionD, ':feEmisionD', Lv_FeEmisionDesde));
        DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(Lv_WhereFeEmisionH, ':feEmisionH', Lv_FeEmisionHasta));
      END IF;
    END IF;
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Atdf.Codigo_Tipo_Documento IN ( ''FAC'', ''FACP'' ) ');
  
    IF Lv_CodEmpresa IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Iog.Empresa_Id = '':codEmpresa'' ',':codEmpresa',Lv_CodEmpresa));   
    END IF;
    
    IF Lv_IdentCliente IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryIdentif,'AND Idfc.Punto_Id IN (SELECT
                                                                Ipu.id_Punto
                                                              FROM
                                                                Db_Comercial.Info_Persona             Ipe 
                                                                  INNER JOIN Db_Comercial.Info_Persona_Empresa_Rol Iper ON Ipe.Id_Persona = Iper.Persona_Id
                                                                  INNER JOIN DB_Comercial.Info_Empresa_Rol Ier ON Iper.Empresa_Rol_Id = Ier.Id_Empresa_Rol
                                                                  INNER JOIN Db_Comercial.Info_Punto Ipu ON Iper.Id_Persona_Rol = Ipu.Persona_Empresa_Rol_Id
                                                              WHERE
                                                                  Ipe.Identificacion_Cliente = '':idenCliente''
                                                                  AND Ier.Empresa_Cod = '':codEmpresa'') ');
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(REPLACE(Lcl_QueryIdentif,':idenCliente',Lv_IdentCliente),':codEmpresa',Lv_CodEmpresa));   
    END IF;    
        
    IF Ln_Id_Punto IS NOT NULL THEN
       DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Idfc.Punto_Id = '||Ln_Id_Punto||' ');
    END IF;
    
    
    
    DBMS_LOB.APPEND(Lcl_Query,'SELECT tab.* FROM ( ');
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    DBMS_LOB.APPEND(Lcl_Query,') tab ');    
    
    DBMS_LOB.APPEND(Lcl_Query,'ORDER BY tab.fechaCreacion DESC');
  
    OPEN Lrf_DocumentosCab FOR Lcl_Query;
    
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_ARRAY;
    LOOP
      FETCH Lrf_DocumentosCab BULK COLLECT INTO Lr_DocumentoCab LIMIT 50;
      Li_Cont := Lr_DocumentoCab.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP      
        
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idDocumento', Lr_DocumentoCab(Li_Cont).Id_Documento);
        APEX_JSON.WRITE('idOficina', Lr_DocumentoCab(Li_Cont).Oficina_Id);
        APEX_JSON.WRITE('nombreOficina', Lr_DocumentoCab(Li_Cont).Nombre_Oficina);
        APEX_JSON.WRITE('idPunto', Lr_DocumentoCab(Li_Cont).Punto_Id);
        APEX_JSON.WRITE('idTipoDocumento', Lr_DocumentoCab(Li_Cont).Tipo_Documento_Id);
        APEX_JSON.WRITE('tipoDocumento', Lr_DocumentoCab(Li_Cont).Nombre_Tipo_Documento);
        APEX_JSON.WRITE('numeroFactura', Lr_DocumentoCab(Li_Cont).Numero_Factura_Sri);
        APEX_JSON.WRITE('subtotal', Lr_DocumentoCab(Li_Cont).Subtotal);
        APEX_JSON.WRITE('subtotalCeroImpuesto', Lr_DocumentoCab(Li_Cont).Subtotal_Cero_Impuesto);
        APEX_JSON.WRITE('subtotalConImpuesto', Lr_DocumentoCab(Li_Cont).Subtotal_Con_Impuesto);
        APEX_JSON.WRITE('subtotalDescuento', Lr_DocumentoCab(Li_Cont).Subtotal_Descuento);
        APEX_JSON.WRITE('subtotalIce', Lr_DocumentoCab(Li_Cont).Subtotal_ice);
        APEX_JSON.WRITE('subtotalServicios', Lr_DocumentoCab(Li_Cont).Subtotal_Servicios);
        APEX_JSON.WRITE('impuestosServicios', Lr_DocumentoCab(Li_Cont).Impuestos_Servicios);
        APEX_JSON.WRITE('subtotalBienes', Lr_DocumentoCab(Li_Cont).Subtotal_Bienes);
        APEX_JSON.WRITE('impuestosBienes', Lr_DocumentoCab(Li_Cont).Impuestos_Bienes);
        APEX_JSON.WRITE('descuentoCompensacion', Lr_DocumentoCab(Li_Cont).Descuento_Compensacion);
        APEX_JSON.WRITE('establecimiento', Lr_DocumentoCab(Li_Cont).Establecimiento);
        APEX_JSON.WRITE('emision', Lr_DocumentoCab(Li_Cont).Emision);
        APEX_JSON.WRITE('secuencia', Lr_DocumentoCab(Li_Cont).Secuencia);
        APEX_JSON.WRITE('valorTotal', Lr_DocumentoCab(Li_Cont).Valor_Total);
        APEX_JSON.WRITE('entregoRetencionFte', Lr_DocumentoCab(Li_Cont).Entrego_Retencion_Fte);
        APEX_JSON.WRITE('estado', Lr_DocumentoCab(Li_Cont).Estado_Impresion_Fact);
        APEX_JSON.WRITE('esAutomatica', Lr_DocumentoCab(Li_Cont).Es_Automatica);
        APEX_JSON.WRITE('prorrateo', Lr_DocumentoCab(Li_Cont).Prorrateo);
        APEX_JSON.WRITE('reactivacion', Lr_DocumentoCab(Li_Cont).Reactivacion);
        APEX_JSON.WRITE('esRecurrente', Lr_DocumentoCab(Li_Cont).Recurrente);
        APEX_JSON.WRITE('comisiona', Lr_DocumentoCab(Li_Cont).Comisiona);
        APEX_JSON.WRITE('numFactMigracion', Lr_DocumentoCab(Li_Cont).Num_Fact_Migracion);
        APEX_JSON.WRITE('observacion', Lr_DocumentoCab(Li_Cont).Observacion);
        APEX_JSON.WRITE('idReferenciaDocumento', Lr_DocumentoCab(Li_Cont).Referencia_Documento_Id);
        APEX_JSON.WRITE('loginMd', Lr_DocumentoCab(Li_Cont).Login_Md);
        APEX_JSON.WRITE('esElectronica', Lr_DocumentoCab(Li_Cont).Es_Electronica);
        APEX_JSON.WRITE('rangoConsumo', Lr_DocumentoCab(Li_Cont).Rango_Consumo);
        APEX_JSON.WRITE('fechaEmision', Lr_DocumentoCab(Li_Cont).Fe_Emision);
        APEX_JSON.WRITE('numeroAutorizacion', Lr_DocumentoCab(Li_Cont).Numero_Autorizacion);
        APEX_JSON.WRITE('fechaAutorizacion', Lr_DocumentoCab(Li_Cont).Fe_Autorizacion);
        APEX_JSON.WRITE('contabilizado', Lr_DocumentoCab(Li_Cont).Contabilizado);
        APEX_JSON.WRITE('mesConsumo', Lr_DocumentoCab(Li_Cont).Mes_Consumo);
        APEX_JSON.WRITE('anioConsumo', Lr_DocumentoCab(Li_Cont).Anio_Consumo);
        APEX_JSON.WRITE('fechaCreacion', Lr_DocumentoCab(Li_Cont).Fe_Creacion);
        APEX_JSON.WRITE('usuarioCreacion', Lr_DocumentoCab(Li_Cont).Usr_Creacion);
      
        FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS(Pn_IdFactura        => Lr_DocumentoCab(Li_Cont).Id_Documento,
                                                Pv_FeConsultaHasta  => TO_CHAR(SYSDATE,'DD-MM-YYYY'),
                                                Pr_Documentos       => Lrf_DocRelacionados); 
        
        Ln_ValorAbonado := 0;
        APEX_JSON.OPEN_ARRAY('detalles');
        LOOP
            FETCH Lrf_DocRelacionados BULK COLLECT INTO Lr_DocRelacionado LIMIT 50;
            Li_ContRel := Lr_DocRelacionado.FIRST;
            WHILE (Li_ContRel IS NOT NULL) LOOP 
              
              APEX_JSON.OPEN_OBJECT;
              APEX_JSON.WRITE('codigoTipoDocumento', Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento);
              OPEN C_GetTipoDocumento(Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento);
              FETCH C_GetTipoDocumento INTO Lc_TipoDocumento;
              CLOSE C_GetTipoDocumento;
              APEX_JSON.WRITE('tipoDocumento', Lc_TipoDocumento.Nombre_Tipo_Documento);
              Lc_PagoDet := null;
              OPEN C_GetPagoDet(Lr_DocRelacionado(Li_ContRel).Id_Pago_Det,Lv_CodEmpresa);
              FETCH C_GetPagoDet INTO Lc_PagoDet;
              CLOSE C_GetPagoDet;
              APEX_JSON.WRITE('nombreOficina', Lc_PagoDet.Nombre_Oficina);
              APEX_JSON.WRITE('numeroPago', Lr_DocRelacionado(Li_ContRel).Numero_Pago);
              APEX_JSON.WRITE('fechaPago', TO_CHAR(TO_DATE(Lr_DocRelacionado(Li_ContRel).Fe_Creacion,'DD/MM/RRRR'),'RRRR-MM-DD'));
              APEX_JSON.WRITE('estadoPago', Lr_DocRelacionado(Li_ContRel).Estado_Pago);
              APEX_JSON.WRITE('codigoFormaPago', Lr_DocRelacionado(Li_ContRel).Codigo_Forma_Pago);
              OPEN C_GetFormaPago(Lr_DocRelacionado(Li_ContRel).Codigo_Forma_Pago);
              Lc_FormaPago := null;
              FETCH C_GetFormaPago INTO Lc_FormaPago;
              CLOSE C_GetFormaPago;
              APEX_JSON.WRITE('formaPago', Lc_FormaPago.Descripcion_Forma_Pago);
              
              IF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('PAG','PAGC','ANT','ANTC','ANTS')  THEN                
                APEX_JSON.WRITE('valorIngreso', 0);
                APEX_JSON.WRITE('valorEgreso', Lr_DocRelacionado(Li_ContRel).Valor_Pago);
                APEX_JSON.WRITE('observacion',REPLACE(REPLACE(Lc_PagoDet.Comentario,'/','-'),chr(10),' '));
                Ln_ValorAbonado := Ln_ValorAbonado + Lr_DocRelacionado(Li_ContRel).Valor_Pago;
              ELSIF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('NC','NCI') THEN
                APEX_JSON.WRITE('valorIngreso', 0);
                APEX_JSON.WRITE('valorEgreso', Lr_DocRelacionado(Li_ContRel).Valor_Pago);
                Lc_RefDocFinCab := null;
                OPEN C_GetRefDocFinancieroCab(Lr_DocumentoCab(Li_Cont).Id_Documento, 
                                              'Activo', 
                                              Lr_DocRelacionado(Li_ContRel).Numero_Pago);
                FETCH C_GetRefDocFinancieroCab INTO Lc_RefDocFinCab;
                CLOSE C_GetRefDocFinancieroCab;
                APEX_JSON.WRITE('observacion',Lc_RefDocFinCab.Observacion);
                Ln_ValorAbonado := Ln_ValorAbonado + Lr_DocRelacionado(Li_ContRel).Valor_Pago;
              ELSIF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('ND','NDI','DEV') THEN 
                APEX_JSON.WRITE('valorIngreso', Lr_DocRelacionado(Li_ContRel).Valor_Pago);
                APEX_JSON.WRITE('valorEgreso', 0);
                FOR i In C_GetDocumentoFinancieroDet(Lr_DocRelacionado(Li_ContRel).Id_Pago_Det) LOOP
                  Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
                END LOOP;
                APEX_JSON.WRITE('observacion',Lcl_ObsDetalleFact);
              ELSIF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('FAC','FACP') THEN 
                APEX_JSON.WRITE('valorIngreso', Lr_DocRelacionado(Li_ContRel).Valor_Pago);
                APEX_JSON.WRITE('valorEgreso', 0);
                FOR i In C_GetDocumentoFinancieroDet(Lr_DocumentoCab(Li_Cont).Id_Documento) LOOP
                  Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
                END LOOP;
                APEX_JSON.WRITE('observacion',Lcl_ObsDetalleFact);
              END IF;
              APEX_JSON.CLOSE_OBJECT;
              Li_ContRel := Lr_DocRelacionado.NEXT(Li_ContRel);                                            
          END LOOP;
          EXIT WHEN Lrf_DocRelacionados%NOTFOUND;
        END LOOP;
        APEX_JSON.CLOSE_ARRAY;
        APEX_JSON.WRITE('valorAbonado',Ln_ValorAbonado);
         APEX_JSON.WRITE('saldo',Lr_DocumentoCab(Li_Cont).Valor_Total-Ln_ValorAbonado);                                       
        APEX_JSON.CLOSE_OBJECT;
        Li_Cont:= Lr_DocumentoCab.NEXT(Li_Cont);                                            
      END LOOP;
      EXIT WHEN Lrf_DocumentosCab%NOTFOUND;
    END LOOP;
    APEX_JSON.CLOSE_ARRAY;
    
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
    Pcl_Response := Lcl_Response;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_FACTURAS;
  
  PROCEDURE P_GET_DOC_FINANCIEROS_CAB(Pcl_Request  IN CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Prf_Response OUT SYS_REFCURSOR) AS
    
    Lv_CodigosTipoDoc   Varchar2(500);
    Ln_IdPunto          NUMBER;
    Lv_FechaDesde       Varchar2(30);
    Lv_FechaHasta       Varchar2(30);
    Lcl_QuerySelect     CLOB;
    Lcl_QueryFrom       CLOB;
    Lcl_QueryWhere      CLOB;
    Lcl_Query           CLOB;
  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodigosTipoDoc := APEX_JSON.get_varchar2('codigosTipoDoc');
    Ln_IdPunto := APEX_JSON.get_number('idPunto');
    Lv_FechaDesde := APEX_JSON.get_varchar2('fechaDesde');
    Lv_FechaHasta := APEX_JSON.get_varchar2('fechaHasta');
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    
    Lcl_QuerySelect := 'SELECT
                          Idfc.Id_Documento,
                          Idfc.Numero_Factura_Sri,
                          Idfc.Tipo_Documento_Id,
                          Idfc.Valor_Total,
                          Idfc.Fe_Creacion,
                          Idfc.Fec_Creacion,
                          Idfc.Fec_Emision,
                          Idfc.Fec_Autorizacion,
                          Idfc.Punto_Id,
                          Idfc.Oficina_Id,
                          Idfc.Referencia,
                          Idfc.Codigo_Forma_Pago,
                          Idfc.Numero_Referencia,
                          Idfc.Numero_Cuenta_Banco,
                          Idfc.Referencia_Id,
                          Atdf.Codigo_Tipo_Documento,
                          Atdf.Movimiento ';
    Lcl_QueryFrom := 'FROM Estado_Cuenta_Cliente Idfc,
                        Admi_Tipo_Documento_Financiero Atdf ';
    Lcl_QueryWhere := 'WHERE Idfc.Tipo_Documento_Id = Atdf.Id_Tipo_Documento ';
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Atdf.Codigo_Tipo_Documento IN ( :codigos ) ',':codigos',Lv_CodigosTipoDoc));
      
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Idfc.Migracion IS NULL ');
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Punto_Id = :idPunto ',':idPunto',Ln_IdPunto));
      
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Fe_Creacion >= TO_DATE('':fe_desde'', ''rrrr-mm-dd'') ',':fe_desde',Lv_FechaDesde));
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Fe_Creacion <= TO_DATE('':fe_hasta'', ''rrrr-mm-dd'') ',':fe_hasta',Lv_FechaHasta));  
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'ORDER BY Idfc.Fe_Creacion ');
    
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    
    OPEN Prf_Response FOR Lcl_Query;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || Sqlerrm;
  END P_GET_DOC_FINANCIEROS_CAB;      
  
  PROCEDURE P_GET_DOC_FIN_ANTIC_PAGOS(Pcl_Request  IN CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Prf_Response OUT SYS_REFCURSOR) AS
    
    Lv_CodigosTipoDoc   Varchar2(500);
    Lv_FechaDesde       Varchar2(30);
    Lv_FechaHasta       Varchar2(30);
    Lv_Estados          Varchar2(500);
    Ln_IdPunto          NUMBER;
    Lcl_QuerySelect     CLOB;
    Lcl_QueryFrom       CLOB;
    Lcl_QueryWhere      CLOB;
    Lcl_Query           CLOB;
  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodigosTipoDoc := APEX_JSON.get_varchar2('codigosTipoDoc');
    Ln_IdPunto := APEX_JSON.get_number('idPunto');
    Lv_FechaDesde := APEX_JSON.get_varchar2('fechaDesde');
    Lv_FechaHasta := APEX_JSON.get_varchar2('fechaHasta');
    Lv_Estados := APEX_JSON.get_varchar2('estados');
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    
    Lcl_QuerySelect := 'SELECT
                          Idfc.Id_Documento,
                          Idfc.Numero_Factura_Sri,
                          Idfc.Tipo_Documento_Id,
                          Atdf.Codigo_Tipo_Documento, 
                          Atdf.Movimiento,
                          Idfc.Valor_Total,
                          Idfc.Fe_Creacion Fe_Creacion,
                          Idfc.Fec_Creacion,
                          Idfc.Fec_Emision,
                          Idfc.Fec_Autorizacion,
                          Idfc.Punto_Id,
                          Idfc.Oficina_Id,
                          Idfc.Referencia,
                          Idfc.Codigo_Forma_Pago,
                          Idfc.Numero_Referencia,
                          Idfc.Numero_Cuenta_Banco,
                          Idfc.Referencia_Id,
                          Ipd.Comentario ';
    Lcl_QueryFrom := 'FROM Estado_Cuenta_Cliente Idfc,
                        Admi_Tipo_Documento_Financiero Atdf,
                        Info_Pago_Det Ipd ';
    Lcl_QueryWhere := 'WHERE Idfc.Tipo_Documento_Id = Atdf.Id_Tipo_Documento ';
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Atdf.Codigo_Tipo_Documento IN ( :codigos ) ',':codigos',Lv_CodigosTipoDoc));
      
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Idfc.Migracion IS NULL ');
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND EXISTS (
                                      SELECT
                                        Ipd.Id_Pago_Det
                                      FROM
                                        Info_Pago_Det Ipd
                                      WHERE
                                          Ipd.Id_Pago_Det = Idfc.Id_Documento
                                        AND Ipd.Estado IN ( :estados ))',':estados',Lv_Estados));
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Ipd.Referencia_Id IS NULL ');
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Ipd.Id_Pago_Det = Idfc.Id_Documento ');
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Punto_Id = :idPunto ',':idPunto',Ln_IdPunto));
      
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Fe_Creacion >= TO_DATE('':fe_desde'', ''rrrr-mm-dd'') ',':fe_desde',Lv_FechaDesde));
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Fe_Creacion <= TO_DATE('':fe_hasta'', ''rrrr-mm-dd'') ',':fe_hasta',Lv_FechaHasta));  
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'ORDER BY Idfc.Fe_Creacion ');
    
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    
    OPEN Prf_Response FOR Lcl_Query;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || Sqlerrm;
  END P_GET_DOC_FIN_ANTIC_PAGOS;
  
  PROCEDURE P_GET_DOC_FINANCIEROS_OG (Pcl_Request  IN CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Prf_Response OUT SYS_REFCURSOR) AS
    
    Ln_IdPunto          Number;
    Lv_FechaDesde       Varchar2(30);
    Lv_FechaHasta       Varchar2(30);
    Lcl_QuerySelect     CLOB;
    Lcl_QueryFrom       CLOB;
    Lcl_QueryWhere      CLOB;
    Lcl_Query           CLOB;
  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdPunto := APEX_JSON.get_number('idPunto');
    Lv_FechaDesde := APEX_JSON.get_varchar2('fechaDesde');
    Lv_FechaHasta := APEX_JSON.get_varchar2('fechaHasta');
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    
    Lcl_QuerySelect := 'SELECT
                          Idfc.Id_Documento,
                          Idfc.Numero_Factura_Sri,
                          Idfc.Tipo_Documento_Id,
                          Atdf.Codigo_Tipo_Documento, 
                          Atdf.Movimiento,
                          Idfc.Valor_Total,
                          Idfc.Fe_Creacion,
                          Idfc.Punto_Id,
                          Idfc.Oficina_Id,
                          Idfc.Referencia,
                          Idfc.Codigo_Forma_Pago,
                          Idfc.Numero_Referencia,
                          Idfc.Numero_Cuenta_Banco,
                          Idfc.Referencia_Id ';
    Lcl_QueryFrom := 'FROM Estado_Cuenta_Og Idfc,
                        Admi_Tipo_Documento_Financiero Atdf ';
    Lcl_QueryWhere := 'WHERE Idfc.Tipo_Documento_Id = Atdf.Id_Tipo_Documento ';

    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Punto_Id IN ( :idPunto ) ',':idPunto',Ln_IdPunto));
      
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Fe_Creacion >= TO_DATE('':fe_desde'', ''rrrr-mm-dd'') ',':fe_desde',Lv_FechaDesde));
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Idfc.Fe_Creacion <= TO_DATE('':fe_hasta'', ''rrrr-mm-dd'') ',':fe_hasta',Lv_FechaHasta));  
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'ORDER BY Idfc.Fe_Creacion ');
    
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    
    OPEN Prf_Response FOR Lcl_Query;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || Sqlerrm;
  END P_GET_DOC_FINANCIEROS_OG;
  
  PROCEDURE P_GET_ANTICIPOS_PAGOS(Pcl_Request  IN CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Prf_Response OUT SYS_REFCURSOR) AS
    
    Lv_CodigosTipoDoc   Varchar2(500);
    Lv_FechaDesde       Varchar2(30);
    Lv_FechaHasta       Varchar2(30);
    Lv_Estado           Varchar2(50);
    Ln_IdPunto          NUMBER;
    Lcl_QuerySelect     CLOB;
    Lcl_QueryFrom       CLOB;
    Lcl_QueryWhere      CLOB;
    Lcl_Query           CLOB;
  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodigosTipoDoc := APEX_JSON.get_varchar2('codigosTipoDoc');
    Ln_IdPunto := APEX_JSON.get_number('idPunto');
    Lv_FechaDesde := APEX_JSON.get_varchar2('fechaDesde');
    Lv_FechaHasta := APEX_JSON.get_varchar2('fechaHasta');
    Lv_Estado := APEX_JSON.get_varchar2('estado');
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    
    Lcl_QuerySelect := 'SELECT
                          Ipc.Id_Pago,
                          Ipc.Numero_Pago,
                          Atdf.Id_Tipo_Documento,
                          Atdf.Codigo_Tipo_Documento, 
                          Atdf.Movimiento,
                          Ipc.Valor_Total,
                          Ipc.Fe_Creacion,
                          Ipc.Punto_Id,
                          Ipc.Oficina_Id,
                          Rec.Id_Recaudacion ';
    Lcl_QueryFrom := 'FROM Info_Pago_Cab Ipc
                        LEFT JOIN Info_Recaudacion Rec ON Rec.Id_Recaudacion = Ipc.Recaudacion_Id,
                        Admi_Tipo_Documento_Financiero Atdf ';
    Lcl_QueryWhere := 'WHERE Ipc.Tipo_Documento_Id = Atdf.Id_Tipo_Documento ';
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Atdf.Codigo_Tipo_Documento IN ( :codigos ) ',':codigos',Lv_CodigosTipoDoc));
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ipc.Estado_Pago = :estado ',':estado',Lv_Estado));

    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ipc.Punto_Id IN ( :idPunto ) ',':idPunto',Ln_IdPunto));
      
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ipc.Fe_Creacion >= TO_DATE('':fe_desde'', ''rrrr-mm-dd'') ',':fe_desde',Lv_FechaDesde));
    DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ipc.Fe_Creacion <= TO_DATE('':fe_hasta'', ''rrrr-mm-dd'') ',':fe_hasta',Lv_FechaHasta));  
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'ORDER BY Ipc.Fe_Creacion ');
    
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
   
    OPEN Prf_Response FOR Lcl_Query;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || Sqlerrm;
  END P_GET_ANTICIPOS_PAGOS;
  
  PROCEDURE P_GET_DET_NOT_DEBITOS(Pn_IdDocumento        IN NUMBER,
                                  Pv_Login              IN VARCHAR2,
                                  Pv_NombreOficinaGrupo IN VARCHAR2,
                                  Pr_EstadoCuenta       IN OUT FNKG_TYPES_DOCUMENTOS.Ltr_EstadoCuenta,
                                  Pn_Id                 IN OUT NUMBER,
                                  Pn_ValorIngresoDoc    IN OUT NUMBER,
                                  Pn_ValorIngreso       IN OUT NUMBER,
                                  Pn_SumaValorTotal     IN OUT NUMBER,
                                  Pn_ValorEgresoDoc     IN OUT NUMBER,
                                  Pn_ValorEgreso        IN OUT NUMBER) AS
                                  
    CURSOR C_GetPagoDet(Cn_IdPagoDet NUMBER) IS
      SELECT
        Ipd.*
      FROM
        Info_Pago_Det Ipd
      WHERE
        Ipd.Id_Pago_Det = Cn_IdPagoDet;                                  
                                  
    CURSOR C_GetDocumentoFinancieroDet(Cn_IdDocumento NUMBER) IS
      SELECT
        Idfd.*
      FROM
        Info_Documento_Financiero_Det Idfd
      WHERE
        Idfd.Documento_Id = Cn_IdDocumento;                                  
                                  
    Lr_DocRelacionNdi   FNKG_TYPES_DOCUMENTOS.Ltr_InfoDocRelacionado;
    Lc_PagoDet          C_GetPagoDet%ROWTYPE;
    Lrf_DocRelacionNdi  SYS_REFCURSOR;
    Li_ContNdi          PLS_INTEGER;
    Lcl_ObsDetalleFact  CLOB;
  
  BEGIN
    
    FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS(Pn_IdFactura        => Pn_IdDocumento,
                                            Pv_FeConsultaHasta  => null,
                                            Pr_Documentos       => Lrf_DocRelacionNdi);
                                            
    LOOP
      FETCH Lrf_DocRelacionNdi BULK COLLECT INTO Lr_DocRelacionNdi LIMIT 10;
      Li_ContNdi := Lr_DocRelacionNdi.FIRST;
      WHILE (Li_ContNdi IS NOT NULL) LOOP
        
        IF Lr_DocRelacionNdi(Li_ContNdi).Codigo_Tipo_Documento IN ('PAG','PAGC','ANT','ANTC','ANTS') THEN
          Pn_ValorEgresoDoc := Pn_ValorEgresoDoc + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pn_SumaValorTotal := Pn_SumaValorTotal - ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pn_ValorEgreso := Pn_ValorEgreso + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          
          OPEN C_GetPagoDet(Lr_DocRelacionNdi(Li_ContNdi).Id_Pago_Det);
          FETCH C_GetPagoDet INTO Lc_PagoDet;
          CLOSE C_GetPagoDet;
          
          Pn_Id := Pn_Id + 1;        
          Pr_EstadoCuenta(Pn_Id).Id_Documento := Lr_DocRelacionNdi(Li_ContNdi).Numero_Pago;
          Pr_EstadoCuenta(Pn_Id).Valor_Ingreso := 0;
          Pr_EstadoCuenta(Pn_Id).Valor_Egreso := ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pr_EstadoCuenta(Pn_Id).Valor_Acumulado := NULL;
          Pr_EstadoCuenta(Pn_Id).Fecha_Creacion := Lr_DocRelacionNdi(Li_ContNdi).Fe_Creacion;
          Pr_EstadoCuenta(Pn_Id).Fecha_Emision := NULL;
          Pr_EstadoCuenta(Pn_Id).Fecha_Autorizacion := NULL;
          Pr_EstadoCuenta(Pn_Id).Codigo_Tipo_Documento := Lr_DocRelacionNdi(Li_ContNdi).Codigo_Tipo_Documento;
          Pr_EstadoCuenta(Pn_Id).Login := Pv_Login;
          Pr_EstadoCuenta(Pn_Id).Nombre_Oficina := Pv_NombreOficinaGrupo;
          Pr_EstadoCuenta(Pn_Id).Referencia := NULL;
          Pr_EstadoCuenta(Pn_Id).Codigo_Forma_Pago := Lr_DocRelacionNdi(Li_ContNdi).Codigo_Forma_Pago;
          Pr_EstadoCuenta(Pn_Id).Numero := Lr_DocRelacionNdi(Li_ContNdi).Numero_Referencia;
          Pr_EstadoCuenta(Pn_Id).Observacion := Lc_PagoDet.Comentario;
          Pr_EstadoCuenta(Pn_Id).Es_Suma_Valor_Total := NULL;
          
        END IF;
        
        IF Lr_DocRelacionNdi(Li_ContNdi).Codigo_Tipo_Documento IN ('ND','NDI','DEV') THEN
          
          Pn_ValorIngresoDoc := Pn_ValorIngresoDoc + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pn_SumaValorTotal := Pn_SumaValorTotal + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pn_ValorIngreso := Pn_ValorIngreso + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          
          Lcl_ObsDetalleFact := NULL;
          FOR i In C_GetDocumentoFinancieroDet(Lr_DocRelacionNdi(Li_ContNdi).Id_Pago_Det) LOOP
            Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
          END LOOP;
          
          Pn_Id := Pn_Id + 1;        
          Pr_EstadoCuenta(Pn_Id).Id_Documento := Lr_DocRelacionNdi(Li_ContNdi).Numero_Pago;
          Pr_EstadoCuenta(Pn_Id).Valor_Ingreso := ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pr_EstadoCuenta(Pn_Id).Valor_Egreso := 0;
          Pr_EstadoCuenta(Pn_Id).Valor_Acumulado := NULL;
          Pr_EstadoCuenta(Pn_Id).Fecha_Creacion := Lr_DocRelacionNdi(Li_ContNdi).Fe_Creacion;
          Pr_EstadoCuenta(Pn_Id).Fecha_Emision := NULL;
          Pr_EstadoCuenta(Pn_Id).Fecha_Autorizacion := NULL;
          Pr_EstadoCuenta(Pn_Id).Codigo_Tipo_Documento := Lr_DocRelacionNdi(Li_ContNdi).Codigo_Tipo_Documento;
          Pr_EstadoCuenta(Pn_Id).Login := Pv_Login;
          Pr_EstadoCuenta(Pn_Id).Nombre_Oficina := Pv_NombreOficinaGrupo;
          Pr_EstadoCuenta(Pn_Id).Referencia := NULL;
          Pr_EstadoCuenta(Pn_Id).Codigo_Forma_Pago := NULL;
          Pr_EstadoCuenta(Pn_Id).Numero := NULL;
          Pr_EstadoCuenta(Pn_Id).Observacion := Lcl_ObsDetalleFact;
          Pr_EstadoCuenta(Pn_Id).Es_Suma_Valor_Total := NULL;
          
          P_GET_DET_NOT_DEBITOS(Pn_IdDocumento        => Pn_IdDocumento,
                                Pv_Login              => Pv_Login,
                                Pv_NombreOficinaGrupo => Pv_NombreOficinaGrupo,
                                Pr_EstadoCuenta       => Pr_EstadoCuenta,
                                Pn_Id                 => Pn_Id,
                                Pn_ValorIngresoDoc    => Pn_ValorIngresoDoc,
                                Pn_ValorIngreso       => Pn_ValorIngreso,
                                Pn_SumaValorTotal     => Pn_SumaValorTotal,
                                Pn_ValorEgresoDoc     => Pn_ValorEgresoDoc,
                                Pn_ValorEgreso        => Pn_ValorEgreso);
          
        END IF;
        
        IF Lr_DocRelacionNdi(Li_ContNdi).Codigo_Tipo_Documento IN ('NC','NCI') THEN
          Pn_SumaValorTotal := Pn_SumaValorTotal - ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pn_ValorEgreso := Pn_ValorEgreso + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pn_ValorEgresoDoc := Pn_ValorEgresoDoc + ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          
          Lcl_ObsDetalleFact := NULL;
          FOR i In C_GetDocumentoFinancieroDet(Lr_DocRelacionNdi(Li_ContNdi).Id_Pago_Det) LOOP
            Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
          END LOOP;
          
          Pn_Id := Pn_Id + 1;        
          Pr_EstadoCuenta(Pn_Id).Id_Documento := Lr_DocRelacionNdi(Li_ContNdi).Numero_Pago;
          Pr_EstadoCuenta(Pn_Id).Valor_Ingreso := 0;
          Pr_EstadoCuenta(Pn_Id).Valor_Egreso := ROUND(Lr_DocRelacionNdi(Li_ContNdi).Valor_Pago,2);
          Pr_EstadoCuenta(Pn_Id).Valor_Acumulado := NULL;
          Pr_EstadoCuenta(Pn_Id).Fecha_Creacion := Lr_DocRelacionNdi(Li_ContNdi).Fe_Creacion;
          Pr_EstadoCuenta(Pn_Id).Fecha_Emision := NULL;
          Pr_EstadoCuenta(Pn_Id).Fecha_Autorizacion := NULL;
          Pr_EstadoCuenta(Pn_Id).Codigo_Tipo_Documento := Lr_DocRelacionNdi(Li_ContNdi).Codigo_Tipo_Documento;
          Pr_EstadoCuenta(Pn_Id).Login := Pv_Login;
          Pr_EstadoCuenta(Pn_Id).Nombre_Oficina := Pv_NombreOficinaGrupo;
          Pr_EstadoCuenta(Pn_Id).Referencia := NULL;
          Pr_EstadoCuenta(Pn_Id).Codigo_Forma_Pago := NULL;
          Pr_EstadoCuenta(Pn_Id).Numero := NULL;
          Pr_EstadoCuenta(Pn_Id).Observacion := Lcl_ObsDetalleFact;
          Pr_EstadoCuenta(Pn_Id).Es_Suma_Valor_Total := NULL;
          
        END IF;
        
        Li_ContNdi:= Lr_DocRelacionNdi.NEXT(Li_ContNdi);                                            
      END LOOP;
      EXIT WHEN Lrf_DocRelacionNdi%NOTFOUND;
    END LOOP;

  END;

END FNKG_DOCUMENTOS_FINANCIEROS_C;
/
