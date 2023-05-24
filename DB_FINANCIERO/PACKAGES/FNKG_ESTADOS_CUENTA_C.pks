CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_ESTADOS_CUENTA_C AS 

  /**
   * Documentacion para P_GET_ESTADO_CUENTA_POR_PUNTO
   * Procedimiento para consultar el estado de cuenta de un Cliente por Punto
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                           
  PROCEDURE P_GET_ESTADO_CUENTA_POR_PUNTO(Pcl_Request IN CLOB, Pv_Status OUT VARCHAR2,Pv_Mensaje OUT VARCHAR2,Pcl_Response OUT CLOB); 

  /**
   * Documentacion para P_GET_ESTADO_CUENTA_CLIENTE
   * Procedimiento para consultar el estado de cuenta por Cliente
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   23-11-2021
   */                           
  PROCEDURE P_GET_ESTADO_CUENTA_CLIENTE(Pcl_Request  IN CLOB, Pv_Status OUT VARCHAR2, Pv_Mensaje OUT VARCHAR2, Pcl_Response OUT CLOB);                                                                        

END FNKG_ESTADOS_CUENTA_C;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_ESTADOS_CUENTA_C AS
  
  PROCEDURE P_GET_ESTADO_CUENTA_POR_PUNTO(Pcl_Request  IN CLOB, Pv_Status OUT VARCHAR2, Pv_Mensaje OUT VARCHAR2, Pcl_Response OUT CLOB) AS  
  
    CURSOR C_GetDocumentoFinancieroCab(Cn_IdDocumento NUMBER) IS
      SELECT Idfc.* FROM Info_Documento_Financiero_Cab Idfc WHERE Idfc.Id_Documento = Cn_IdDocumento;

    CURSOR C_GetRefDocFinancieroCab(Cn_RefIdDocumento NUMBER, 
                                    Cv_EstadoImprFact VARCHAR2, 
                                    Cv_NumFacturaSri VARCHAR2) IS
      SELECT Idfc.* FROM Info_Documento_Financiero_Cab Idfc
      WHERE Idfc.Referencia_Documento_Id = Cn_RefIdDocumento
      AND Idfc.estado_Impresion_Fact = Cv_EstadoImprFact AND Idfc.Numero_Factura_Sri = Cv_NumFacturaSri;        

    CURSOR C_GetDocumentoFinancieroDet(Cn_IdDocumento NUMBER) IS
      SELECT Idfd.* FROM Info_Documento_Financiero_Det Idfd WHERE Idfd.Documento_Id = Cn_IdDocumento;

    CURSOR C_GetDocumentoCaracteristica(Cv_Tipo VARCHAR2, Cv_Caracteristica VARCHAR2, Cn_IdDocumento NUMBER) IS
    SELECT Idc.*
    FROM Db_Comercial.Admi_Caracteristica Ac INNER JOIN Info_Documento_Caracteristica Idc ON Ac.Id_Caracteristica = Idc.Caracteristica_Id
    WHERE Ac.Tipo = Cv_Tipo AND Ac.Estado = 'Activo' AND Ac.Descripcion_Caracteristica = Cv_Caracteristica AND Idc.Documento_Id = Cn_IdDocumento;

    CURSOR C_GetAnticipoPorCruce(Cn_IdDetPago NUMBER, Cv_CodTipoDocumento VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT Pc.* FROM Info_Pago_Cab Pc,Info_Pago_Det Pd,Info_Pago_Cab Ac,Admi_Tipo_Documento_Financiero Td
      WHERE Ac.Id_Pago = Pd.Pago_Id AND Pd.Id_Pago_Det = Cn_IdDetPago AND Pc.Anticipo_Id = Ac.Id_Pago AND Pc.Tipo_Documento_Id = Td.Id_Tipo_Documento
        AND Td.Codigo_Tipo_Documento = Cv_CodTipoDocumento AND Ac.Estado_Pago = Cv_Estado;

    CURSOR C_GetPagoDet(Cn_IdPagoDet NUMBER) IS
      SELECT Ipd.* FROM Info_Pago_Det Ipd WHERE Ipd.Id_Pago_Det = Cn_IdPagoDet;

    CURSOR C_GetHistorialPago(Cn_IdPago NUMBER) IS
      SELECT Iph.Observacion, Iph.Estado FROM Info_Pago_Cab Ipc, Info_Pago_Historial Iph
      WHERE Ipc.Id_Pago = Iph.Pago_Id AND Ipc.Id_Pago = Cn_IdPago ORDER BY Iph.Id_Pago_Historial ASC;

    CURSOR C_GetPunto(Cn_IdPunto NUMBER) IS
      SELECT Ipu.* FROM DB_COMERCIAL.Info_Punto Ipu WHERE Ipu.Id_Punto = Cn_IdPunto; 

    CURSOR C_GetOficinaGrupo(Cn_IdOficina NUMBER) IS
      SELECT Iog.* FROM DB_COMERCIAL.Info_Oficina_Grupo Iog WHERE Iog.Id_Oficina = Cn_IdOficina;  

    CURSOR C_GetInfoCliente(Cv_IdentificacionCliente VARCHAR2, Cv_CodEmpresa VARCHAR2) IS
      SELECT Ipe.Direccion,Ipe.Id_Persona,Ipe.Razon_Social,Ipe.Nombres,Ipe.Apellidos,Ipe.Direccion_Tributaria,Iog.Nombre_Oficina
      FROM Db_Comercial.Info_Persona Ipe,Db_Comercial.Info_Persona_Empresa_Rol Iper,Db_Comercial.Info_Empresa_Rol Ier,Info_Oficina_Grupo Iog
      WHERE Ipe.Identificacion_Cliente = Cv_IdentificacionCliente AND Ipe.Id_Persona = Iper.Persona_Id AND Iper.estado = 'Activo'
        AND Iper.Empresa_Rol_Id = Ier.Id_Empresa_Rol AND Ier.Empresa_Cod = Cv_CodEmpresa AND Iper.Oficina_Id = Iog.Id_Oficina;

    Lrf_DocFinancierosCab SYS_REFCURSOR; Lrf_DocFinAnticPagos  SYS_REFCURSOR; Lrf_DocFinancierosOg  SYS_REFCURSOR; Lrf_AnticiposPagos SYS_REFCURSOR; 
    Lrf_DocRelacionados   SYS_REFCURSOR; Lrf_AnticiposNoAplic  SYS_REFCURSOR; Lrf_AnticGenerado     SYS_REFCURSOR;
    Lr_DocFinancieroCab   FNKG_TYPES_DOCUMENTOS.Ltr_DocFinancieroCab;
    Lr_DocFinAnticPago    FNKG_TYPES_DOCUMENTOS.Ltr_DocFinAnticPago;
    Lr_DocFinancieroOg    FNKG_TYPES_DOCUMENTOS.Ltr_DocFinancieroOg;
    Lr_AnticipoPago       FNKG_TYPES_DOCUMENTOS.Ltr_AnticipoPago;
    Lr_DocRelacionado     FNKG_TYPES_DOCUMENTOS.Ltr_InfoDocRelacionado;
    Lr_EstadoCuenta       FNKG_TYPES_DOCUMENTOS.Ltr_EstadoCuenta;
    Lr_AnticNoAplic       FNKG_TYPES_DOCUMENTOS.Ltr_AnticNoAplic;
    Lr_AnticGenerado      FNKG_TYPES_DOCUMENTOS.Ltr_AnticGenerado;
    Lc_DocFinancieroCab   C_GetDocumentoFinancieroCab%ROWTYPE;
    Lc_RefDocFinCab       C_GetRefDocFinancieroCab%ROWTYPE;
    Lc_DocFinancieroDet   C_GetDocumentoFinancieroDet%ROWTYPE;
    Lc_DocCaracteristica  C_GetDocumentoCaracteristica%ROWTYPE;
    Lc_AnticipoPorCruce   C_GetAnticipoPorCruce%ROWTYPE;
    Lc_HistorialPago      C_GetHistorialPago%ROWTYPE;
    Lc_PagoDet            C_GetPagoDet%ROWTYPE;
    Lc_Punto              C_GetPunto%ROWTYPE;
    Lc_OficinaGrupo       C_GetOficinaGrupo%ROWTYPE;
    Lc_InfoCliente        C_GetInfoCliente%ROWTYPE;
    Lcl_Request           CLOB; Lcl_Response CLOB; Lcl_ObsDetalleFact CLOB;    
    Lv_FechaEmisionDesde  VARCHAR2(30); Lv_FechaEmisionHasta VARCHAR2(30); Lv_Status VARCHAR2(200); Lv_Mensaje VARCHAR2(3000);
    Lv_NumeroRefCtaBanco  VARCHAR2(500); Lv_NumeroFactPagada VARCHAR2(500); Lv_ObsInfoFinDocDet VARCHAR2(3000);
    Lv_IdentifCliente     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Ln_IdPunto            NUMBER; Ln_SumaValorTotal NUMBER := 0; Ln_ValorIngreso NUMBER := 0; Ln_ValorEgreso NUMBER := 0;
    Ln_SumaTotalMigracion NUMBER := 0; Ln_ValorIngresoDoc NUMBER := 0; Ln_ValorEgresoDoc NUMBER := 0; Ln_TotalFacturas NUMBER := 0;
    Ln_SumaPagoAnticPend  NUMBER := 0; Ln_ValorAnticPago NUMBER := 0; Ln_TotalAnticPagoPend NUMBER := 0; Ln_Id NUMBER := 0; Ln_Idx NUMBER := 0;
    Lb_ContinuaFlujo BOOLEAN; Lb_SumaValorTotal BOOLEAN;
    Li_Cont PLS_INTEGER; Li_ContRel PLS_INTEGER; Li_ContAnt PLS_INTEGER; Li_ContAntGen PLS_INTEGER;    
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lv_IdentifCliente := APEX_JSON.get_varchar2('identificacionCliente');
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Ln_IdPunto := APEX_JSON.get_number('idPunto');
    Lv_FechaEmisionDesde := APEX_JSON.get_varchar2('fechaEmisionDesde');
    Lv_FechaEmisionHasta := APEX_JSON.get_varchar2('fechaEmisionHasta');

    IF Lv_FechaEmisionDesde IS NULL THEN
      Lv_FechaEmisionDesde := TO_CHAR(SYSDATE,'RRRR')||'-01-01';
    END IF;    
    IF Lv_FechaEmisionHasta IS NULL THEN
      Lv_FechaEmisionHasta := TO_CHAR(SYSDATE,'RRRR-MM-DD');
    END IF;    

    OPEN C_GetInfoCliente(Lv_IdentifCliente,Lv_CodEmpresa);
    FETCH C_GetInfoCliente INTO Lc_InfoCliente;
    CLOSE C_GetInfoCliente;

    --Json para consultar las cabeceras de documentos financieros
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('codigosTipoDoc', '''FAC'', ''FACP'', ''NDI''');
    APEX_JSON.WRITE('idPunto', Ln_IdPunto );
    APEX_JSON.WRITE('fechaDesde', Lv_FechaEmisionDesde);
    APEX_JSON.WRITE('fechaHasta', Lv_FechaEmisionHasta);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C.P_GET_DOC_FINANCIEROS_CAB(Lcl_Request,Lv_Status,Lv_Mensaje,Lrf_DocFinancierosCab);

    --Json para consultar los anticipos o pagos relacionados a documentos financieros
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('codigosTipoDoc', '''PAG'', ''PAGC'', ''ANT'', ''ANTS'', ''ANTC''');
    APEX_JSON.WRITE('idPunto', Ln_IdPunto );
    APEX_JSON.WRITE('estados', '''Pendiente'', ''Cerrado''');
    APEX_JSON.WRITE('fechaDesde', Lv_FechaEmisionDesde);
    APEX_JSON.WRITE('fechaHasta', Lv_FechaEmisionHasta);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C.P_GET_DOC_FIN_ANTIC_PAGOS(Lcl_Request,Lv_Status,Lv_Mensaje,Lrf_DocFinAnticPagos);

    --Json para consultar los documentos financieros de OG
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idPunto', Ln_IdPunto );
    APEX_JSON.WRITE('fechaDesde', Lv_FechaEmisionDesde);
    APEX_JSON.WRITE('fechaHasta', Lv_FechaEmisionHasta);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C.P_GET_DOC_FINANCIEROS_OG(Lcl_Request,Lv_Status,Lv_Mensaje,Lrf_DocFinancierosOg);

    --Json para consultar los anticipos o pagos relacionados a documentos financieros
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('codigosTipoDoc', '''PAG'', ''PAGC'', ''ANT'', ''ANTS'', ''ANTC''');
    APEX_JSON.WRITE('idPunto', Ln_IdPunto );
    APEX_JSON.WRITE('estado', '''Asignado''');
    APEX_JSON.WRITE('fechaDesde', Lv_FechaEmisionDesde);
    APEX_JSON.WRITE('fechaHasta', Lv_FechaEmisionHasta);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C.P_GET_ANTICIPOS_PAGOS(Lcl_Request,Lv_Status,Lv_Mensaje,Lrf_AnticiposPagos);

    LOOP
      FETCH Lrf_DocFinancierosOg BULK COLLECT INTO Lr_DocFinancieroOg LIMIT 10;
      Li_Cont := Lr_DocFinancieroOg.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP
        Ln_ValorIngreso := 0;
        Ln_ValorEgreso := 0;        
        IF Lr_DocFinancieroOg(Li_Cont).Movimiento = '+' THEN
          Ln_SumaValorTotal := Ln_SumaValorTotal + Lr_DocFinancieroOg(Li_Cont).Valor_Total;
          Ln_ValorIngreso := Lr_DocFinancieroOg(Li_Cont).Valor_Total;
        ELSE
          Ln_SumaValorTotal := Ln_SumaValorTotal - Lr_DocFinancieroOg(Li_Cont).Valor_Total;
          Ln_ValorEgreso := Lr_DocFinancieroOg(Li_Cont).Valor_Total;
        END IF;        
        Lv_NumeroRefCtaBanco := NULL;
        Lv_NumeroRefCtaBanco := Lr_DocFinancieroOg(Li_Cont).Numero_Referencia;        
        IF Lv_NumeroRefCtaBanco IS NULL THEN
          Lv_NumeroRefCtaBanco := Lr_DocFinancieroOg(Li_Cont).Numero_Cuenta_Banco;
        END IF;        
        Lv_NumeroFactPagada := NULL;        
        IF Lr_DocFinancieroOg(Li_Cont).Referencia_Id IS NOT NULL AND Lr_DocFinancieroOg(Li_Cont).Codigo_Tipo_Documento IN ('PAG','PAGC','ANT','ANTC','ANTS','NC') THEN           
          OPEN C_GetDocumentoFinancieroCab(Lr_DocFinancieroOg(Li_Cont).Referencia_Id);
          FETCH C_GetDocumentoFinancieroCab INTO Lc_DocFinancieroCab;
          CLOSE C_GetDocumentoFinancieroCab;            
          Lv_NumeroFactPagada := Lc_DocFinancieroCab.Numero_Factura_Sri;            
        END IF;        
        OPEN C_GetPunto(Lr_DocFinancieroOg(Li_Cont).Punto_Id);
        FETCH C_GetPunto INTO Lc_Punto;
        CLOSE C_GetPunto;        
        OPEN C_GetOficinaGrupo(Lr_DocFinancieroOg(Li_Cont).Oficina_Id);
        FETCH C_GetOficinaGrupo INTO Lc_OficinaGrupo;
        CLOSE C_GetOficinaGrupo;        
        Ln_Id := Ln_Id + 1;        
        Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocFinancieroOg(Li_Cont).Numero_Factura_Sri;
        Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := Ln_ValorIngreso;
        Lr_EstadoCuenta(Ln_Id).Valor_Egreso := Ln_ValorEgreso;
        Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := ROUND(Ln_SumaValorTotal,2);
        Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_DocFinancieroOg(Li_Cont).Fe_Creacion;
        Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocFinancieroOg(Li_Cont).Codigo_Tipo_Documento;
        Lr_EstadoCuenta(Ln_Id).Login :=  Lc_Punto.Login;
        Lr_EstadoCuenta(Ln_Id).Nombre_Oficina :=  Lc_OficinaGrupo.Nombre_Oficina;
        Lr_EstadoCuenta(Ln_Id).Referencia := Lv_NumeroFactPagada;
        Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_DocFinancieroOg(Li_Cont).Codigo_Forma_Pago;
        Lr_EstadoCuenta(Ln_Id).Numero := Lv_NumeroRefCtaBanco;
        Lr_EstadoCuenta(Ln_Id).Observacion := Lv_NumeroRefCtaBanco;
        Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';        
        Li_Cont:= Lr_DocFinancieroOg.NEXT(Li_Cont);                                            
      END LOOP;
      EXIT WHEN Lrf_DocFinancierosOg%NOTFOUND;
    END LOOP;

    Ln_SumaTotalMigracion := Ln_SumaValorTotal;            
    Ln_Id := Ln_Id + 1; Lr_EstadoCuenta(Ln_Id).Id_Documento := 'MOVIMIENTOS';
    Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := NULL; Lr_EstadoCuenta(Ln_Id).Valor_Egreso := NULL; Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
    Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := NULL; Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL; Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
    Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := NULL; Lr_EstadoCuenta(Ln_Id).Login := NULL; Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := NULL;
    Lr_EstadoCuenta(Ln_Id).Referencia := NULL; Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL; Lr_EstadoCuenta(Ln_Id).Numero := NULL;
    Lr_EstadoCuenta(Ln_Id).Observacion := NULL; Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';    
    Ln_ValorIngreso := 0; Ln_ValorEgreso := 0; Ln_SumaValorTotal := 0;

    LOOP
      FETCH Lrf_DocFinancierosCab BULK COLLECT INTO Lr_DocFinancieroCab LIMIT 10;
      Li_Cont := Lr_DocFinancieroCab.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP        
        Ln_ValorIngresoDoc := 0; Ln_ValorEgresoDoc := 0; Lb_ContinuaFlujo := true; Lv_ObsInfoFinDocDet := '';        
        IF Lr_DocFinancieroCab(Li_Cont).Codigo_Tipo_Documento = 'NDI' THEN          
          OPEN C_GetDocumentoFinancieroDet(Lr_DocFinancieroCab(Li_Cont).Id_Documento);
          FETCH C_GetDocumentoFinancieroDet INTO Lc_DocFinancieroDet;
          CLOSE C_GetDocumentoFinancieroDet;          
          OPEN C_GetDocumentoCaracteristica('FINANCIERO','PROCESO_DIFERIDO',Lr_DocFinancieroCab(Li_Cont).Id_Documento);
          FETCH C_GetDocumentoCaracteristica INTO Lc_DocCaracteristica;
          CLOSE C_GetDocumentoCaracteristica;          
          IF Lc_DocCaracteristica.Id_Documento_Caracteristica IS NULL THEN
            IF Lc_DocFinancieroDet.Id_Doc_Detalle IS NOT NULL THEN
              IF NVL(Lc_DocFinancieroDet.Pago_Det_Id,0) > 0 THEN
                Lb_ContinuaFlujo := false;
              END IF;
            ELSE
              Lb_ContinuaFlujo := false;
            END IF;
          END IF;          
        END IF;        
        IF Lb_ContinuaFlujo THEN         
          OPEN C_GetPunto(Lr_DocFinancieroCab(Li_Cont).Punto_Id);
          FETCH C_GetPunto INTO Lc_Punto;
          CLOSE C_GetPunto;          
          IF Lr_DocFinancieroCab(Li_Cont).Movimiento = '+' THEN
            Ln_SumaValorTotal := Ln_SumaValorTotal + ROUND(Lr_DocFinancieroCab(Li_Cont).Valor_Total,2);
            Ln_ValorIngreso := Ln_ValorIngreso + ROUND(Lr_DocFinancieroCab(Li_Cont).Valor_Total,2);
            Ln_TotalFacturas := Ln_TotalFacturas + ROUND(Lr_DocFinancieroCab(Li_Cont).Valor_Total,2);
          END IF;          
          OPEN C_GetOficinaGrupo(Lr_DocFinancieroCab(Li_Cont).Oficina_Id);
          FETCH C_GetOficinaGrupo INTO Lc_OficinaGrupo;
          CLOSE C_GetOficinaGrupo;          
          Lv_NumeroRefCtaBanco := NULL;
          Lv_NumeroRefCtaBanco := Lr_DocFinancieroCab(Li_Cont).Numero_Referencia;          
          IF Lv_NumeroRefCtaBanco IS NULL THEN
            Lv_NumeroRefCtaBanco := Lr_DocFinancieroCab(Li_Cont).Numero_Cuenta_Banco;
          END IF;          
          Lv_NumeroFactPagada := NULL;          
          FOR i In C_GetDocumentoFinancieroDet(Lr_DocFinancieroCab(Li_Cont).Id_Documento) LOOP
            Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
          END LOOP;          
          FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS(Pn_IdFactura        => Lr_DocFinancieroCab(Li_Cont).Id_Documento,
                                                  Pv_FeConsultaHasta  => TO_CHAR(SYSDATE,'DD-MM-YYYY'),
                                                  Pr_Documentos       => Lrf_DocRelacionados);    
          LOOP
            FETCH Lrf_DocRelacionados BULK COLLECT INTO Lr_DocRelacionado LIMIT 50;
            Li_ContRel := Lr_DocRelacionado.FIRST;
            IF Lr_DocFinancieroCab(Li_Cont).Codigo_Tipo_Documento = 'NDI' THEN                
              Ln_ValorIngresoDoc := Ln_ValorIngresoDoc + Lr_DocFinancieroCab(Li_Cont).Valor_Total;            
              Ln_Id := Ln_Id + 1;        
              Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocFinancieroCab(Li_Cont).Numero_Factura_Sri;
              Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Lr_DocFinancieroCab(Li_Cont).Valor_Total,2);
              Lr_EstadoCuenta(Ln_Id).Valor_Egreso := 0;
              Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
              Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_DocFinancieroCab(Li_Cont).Fe_Creacion;
              Lr_EstadoCuenta(Ln_Id).Fecha_Emision := TO_DATE(Lr_DocFinancieroCab(Li_Cont).Fec_Emision,'DD/MM/YYYY HH24:MI');
              Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := TO_DATE(Lr_DocFinancieroCab(Li_Cont).Fec_Autorizacion,'DD/MM/YYYY HH24:MI');
              Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocFinancieroCab(Li_Cont).Codigo_Tipo_Documento;
              Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
              Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
              Lr_EstadoCuenta(Ln_Id).Referencia := Lv_NumeroFactPagada;
              Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_DocFinancieroCab(Li_Cont).Codigo_Forma_Pago;
              Lr_EstadoCuenta(Ln_Id).Numero := Lv_NumeroRefCtaBanco;
              Lr_EstadoCuenta(Ln_Id).Observacion := REPLACE(Lcl_ObsDetalleFact,'cuota','<font color="000000"><b>CUOTA</b></font>');
              Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';              
            END IF;              
            IF Lr_DocFinancieroCab(Li_Cont).Codigo_Tipo_Documento IN ('FAC','FACP') THEN              
              Ln_ValorIngresoDoc := Ln_ValorIngresoDoc + Lr_DocFinancieroCab(Li_Cont).Valor_Total;               
              Ln_Id := Ln_Id + 1;        
              Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocFinancieroCab(Li_Cont).Numero_Factura_Sri;
              Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Lr_DocFinancieroCab(Li_Cont).Valor_Total,2);
              Lr_EstadoCuenta(Ln_Id).Valor_Egreso := 0;
              Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
              Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_DocFinancieroCab(Li_Cont).Fe_Creacion;
              Lr_EstadoCuenta(Ln_Id).Fecha_Emision := TO_DATE(Lr_DocFinancieroCab(Li_Cont).Fec_Emision,'DD/MM/YYYY HH24:MI');
              Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := TO_DATE(Lr_DocFinancieroCab(Li_Cont).Fec_Autorizacion,'DD/MM/YYYY HH24:MI');
              Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocFinancieroCab(Li_Cont).Codigo_Tipo_Documento;
              Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
              Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
              Lr_EstadoCuenta(Ln_Id).Referencia := Lv_NumeroFactPagada;
              Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_DocFinancieroCab(Li_Cont).Codigo_Forma_Pago;
              Lr_EstadoCuenta(Ln_Id).Numero := Lv_NumeroRefCtaBanco;
              Lr_EstadoCuenta(Ln_Id).Observacion := Lcl_ObsDetalleFact;
              Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';              
            END IF;              
            WHILE (Li_ContRel IS NOT NULL) LOOP                          
              IF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('PAG','PAGC','ANT','ANTC','ANTS') THEN 
                Lb_SumaValorTotal := true;
                OPEN C_GetAnticipoPorCruce(Lr_DocRelacionado(Li_ContRel).Id_Pago_Det,Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento,'Cerrado');
                FETCH C_GetAnticipoPorCruce INTO Lc_AnticipoPorCruce;
                CLOSE C_GetAnticipoPorCruce;                
                IF Lc_AnticipoPorCruce.Id_Pago IS NOT NULL THEN
                  Lb_SumaValorTotal := false;
                END IF;                
                Ln_ValorEgresoDoc := Ln_ValorEgresoDoc + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);                
                IF Lb_SumaValorTotal THEN
                  Ln_SumaValorTotal := Ln_SumaValorTotal - ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                  Ln_ValorEgreso := Ln_ValorEgreso + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                END IF;                
                OPEN C_GetPagoDet(Lr_DocRelacionado(Li_ContRel).Id_Pago_Det);
                FETCH C_GetPagoDet INTO Lc_PagoDet;
                CLOSE C_GetPagoDet;                
                Ln_Id := Ln_Id + 1;        
                Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocRelacionado(Li_ContRel).Numero_Pago;
                Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := 0;
                Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := TO_DATE(Lr_DocRelacionado(Li_ContRel).Fe_Creacion,'DD/MM/RRRR');
                Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento;
                Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
                Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
                Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_DocRelacionado(Li_ContRel).Codigo_Forma_Pago;
                Lr_EstadoCuenta(Ln_Id).Numero := Lr_DocRelacionado(Li_ContRel).Numero_Referencia;
                Lr_EstadoCuenta(Ln_Id).Observacion := REPLACE(Lc_PagoDet.Comentario,'/','-');
                IF Lb_SumaValorTotal THEN
                  Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';
                ELSE
                  Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'N';
                END IF;                
              END IF;              
              Lcl_ObsDetalleFact := NULL;
              IF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('ND','NDI','DEV') THEN                
                Ln_ValorIngresoDoc := Ln_ValorIngresoDoc + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Ln_SumaValorTotal := Ln_SumaValorTotal + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Ln_ValorIngreso := Ln_ValorIngreso + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);                
                FOR i In C_GetDocumentoFinancieroDet(Lr_DocRelacionado(Li_ContRel).Id_Pago_Det) LOOP
                  Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
                END LOOP;                
                Ln_Id := Ln_Id + 1;        
                Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocRelacionado(Li_ContRel).Numero_Pago;
                Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Lr_EstadoCuenta(Ln_Id).Valor_Egreso := 0;
                Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := TO_DATE(Lr_DocRelacionado(Li_ContRel).Fe_Creacion,'DD/MM/RRRR');
                Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento;
                Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
                Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
                Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
                Lr_EstadoCuenta(Ln_Id).Numero := NULL;
                Lr_EstadoCuenta(Ln_Id).Observacion := Lcl_ObsDetalleFact;
                Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';

                DB_FINANCIERO.FNKG_DOCUMENTOS_FINANCIEROS_C.P_GET_DET_NOT_DEBITOS(Pn_IdDocumento        => Lr_DocRelacionado(Li_ContRel).Id_Pago_Det,
                                                                                  Pv_Login              => Lc_Punto.Login,
                                                                                  Pv_NombreOficinaGrupo => Lc_OficinaGrupo.Nombre_Oficina,
                                                                                  Pr_EstadoCuenta       => Lr_EstadoCuenta,
                                                                                  Pn_Id                 => Ln_Id,
                                                                                  Pn_ValorIngresoDoc    => Ln_ValorIngresoDoc,
                                                                                  Pn_ValorIngreso       => Ln_ValorIngreso,
                                                                                  Pn_SumaValorTotal     => Ln_SumaValorTotal,
                                                                                  Pn_ValorEgresoDoc     => Ln_ValorEgresoDoc,
                                                                                  Pn_ValorEgreso        => Ln_ValorEgreso);
              END IF;

              IF Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento IN ('NC','NCI') THEN
                Ln_SumaValorTotal := Ln_SumaValorTotal - ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Ln_ValorEgreso := Ln_ValorEgreso + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Ln_ValorEgresoDoc := Ln_ValorEgresoDoc + ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);

                OPEN C_GetRefDocFinancieroCab(Lr_DocFinancieroCab(Li_Cont).Id_Documento, 'Activo', Lr_DocRelacionado(Li_ContRel).Numero_Pago);
                FETCH C_GetRefDocFinancieroCab INTO Lc_RefDocFinCab;
                CLOSE C_GetRefDocFinancieroCab;

                Lcl_ObsDetalleFact := Lc_RefDocFinCab.Observacion;                
                Ln_Id := Ln_Id + 1;        
                Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocRelacionado(Li_ContRel).Numero_Pago;
                Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := 0;
                Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Lr_DocRelacionado(Li_ContRel).Valor_Pago,2);
                Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := TO_DATE(Lr_DocRelacionado(Li_ContRel).Fe_Creacion,'DD/MM/RRRR');
                Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocRelacionado(Li_ContRel).Codigo_Tipo_Documento;
                Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
                Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
                Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
                Lr_EstadoCuenta(Ln_Id).Numero := NULL;
                Lr_EstadoCuenta(Ln_Id).Observacion := Lcl_ObsDetalleFact;
                Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';                
              END IF;              
              Li_ContRel:= Lr_DocRelacionado.NEXT(Li_ContRel);                                            
            END LOOP;              

            Ln_Id := Ln_Id + 1;        
            Lr_EstadoCuenta(Ln_Id).Id_Documento := 'Total:';
            Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Ln_ValorIngresoDoc,2);
            Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Ln_ValorEgresoDoc,2);
            Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := ROUND(Ln_ValorIngresoDoc - Ln_ValorEgresoDoc,2);
            Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := NULL;
            Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
            Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
            Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := NULL;
            Lr_EstadoCuenta(Ln_Id).Login := NULL;
            Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := NULL;
            Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
            Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
            Lr_EstadoCuenta(Ln_Id).Numero := NULL;
            Lr_EstadoCuenta(Ln_Id).Observacion := NULL;
            Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';              
            Ln_ValorIngresoDoc := 0; Ln_ValorEgresoDoc := 0;
            EXIT WHEN Lrf_DocRelacionados%NOTFOUND;
          END LOOP;
        END IF;        
        Li_Cont:= Lr_DocFinancieroCab.NEXT(Li_Cont);        
      END LOOP;
      EXIT WHEN Lrf_DocFinancierosCab%NOTFOUND;
    END LOOP;

    LOOP
      FETCH Lrf_DocFinAnticPagos BULK COLLECT INTO Lr_DocFinAnticPago LIMIT 500;
      Li_Cont := Lr_DocFinAnticPago.FIRST;    
      Ln_SumaPagoAnticPend := 0; Ln_ValorAnticPago  := 0;

      Ln_Id := Ln_Id + 1; Lr_EstadoCuenta(Ln_Id).Id_Documento := 'Anticipos no aplicados';
      Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := NULL; Lr_EstadoCuenta(Ln_Id).Valor_Egreso := NULL; Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
      Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := NULL; Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL; Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
      Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := NULL; Lr_EstadoCuenta(Ln_Id).Login := NULL; Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := NULL;
      Lr_EstadoCuenta(Ln_Id).Referencia := NULL; Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL; Lr_EstadoCuenta(Ln_Id).Numero := NULL;
      Lr_EstadoCuenta(Ln_Id).Observacion := NULL; Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';

      Ln_TotalAnticPagoPend := 0; Ln_ValorIngresoDoc := 0; Ln_ValorEgresoDoc := 0;     

      WHILE (Li_Cont IS NOT NULL) LOOP    
        OPEN C_GetPunto(Lr_DocFinAnticPago(Li_Cont).Punto_Id);
        FETCH C_GetPunto INTO Lc_Punto;
        CLOSE C_GetPunto;        
        Lb_SumaValorTotal := true;
        OPEN C_GetAnticipoPorCruce(Lr_DocFinAnticPago(Li_Cont).Id_Documento, Lr_DocFinAnticPago(Li_Cont).Codigo_Tipo_Documento,'Cerrado');
        FETCH C_GetAnticipoPorCruce INTO Lc_AnticipoPorCruce;
        CLOSE C_GetAnticipoPorCruce;        
        IF Lc_AnticipoPorCruce.Id_Pago IS NOT NULL THEN
          Lb_SumaValorTotal := false;
        END IF;        
        IF Lr_DocFinAnticPago(Li_Cont).Movimiento = '-' THEN
          Ln_SumaPagoAnticPend := Ln_SumaPagoAnticPend + ROUND(Lr_DocFinAnticPago(Li_Cont).Valor_Total,2);
          Ln_ValorAnticPago := ROUND(Lr_DocFinAnticPago(Li_Cont).Valor_Total,2);
          Ln_TotalAnticPagoPend := Ln_TotalAnticPagoPend + ROUND(Lr_DocFinAnticPago(Li_Cont).Valor_Total,2);
          IF Lb_SumaValorTotal THEN
            Ln_SumaValorTotal := Ln_SumaValorTotal - ROUND(Lr_DocFinAnticPago(Li_Cont).Valor_Total,2);
            Ln_ValorEgreso := Ln_ValorEgreso + ROUND(Lr_DocFinAnticPago(Li_Cont).Valor_Total,2);
          END IF;            
        END IF;        
        OPEN C_GetOficinaGrupo(Lr_DocFinAnticPago(Li_Cont).Oficina_Id);
        FETCH C_GetOficinaGrupo INTO Lc_OficinaGrupo;
        CLOSE C_GetOficinaGrupo;        
        Lv_NumeroRefCtaBanco := NULL;
        Ln_ValorEgresoDoc := Ln_ValorEgresoDoc + Ln_ValorAnticPago;

        IF Lr_DocFinAnticPago(Li_Cont).Codigo_Forma_Pago = 'REC' THEN 
          DBMS_LOB.APPEND(Lr_DocFinAnticPago(Li_Cont).Comentario,', fecha: '||TO_CHAR(Lr_DocFinAnticPago(Li_Cont).Fe_Creacion,'rrrr-mm-dd hh24:mi:ss'));
        END IF;

        Ln_Id := Ln_Id + 1;        
        Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocFinAnticPago(Li_Cont).Numero_Factura_Sri;
        Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := 0;
        Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Ln_ValorAnticPago,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_DocFinAnticPago(Li_Cont).Fe_Creacion;
        Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocFinAnticPago(Li_Cont).Codigo_Tipo_Documento;
        Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
        Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
        Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_DocFinAnticPago(Li_Cont).Codigo_Forma_Pago;
        Lr_EstadoCuenta(Ln_Id).Numero := Lr_DocFinAnticPago(Li_Cont).Numero_Referencia;
        Lr_EstadoCuenta(Ln_Id).Observacion := Lr_DocFinAnticPago(Li_Cont).Comentario;
        IF Lb_SumaValorTotal THEN
          Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';
        ELSE
          Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'N';
        END IF;        
        P_DOC_ANT_NO_APLICADOS(id_pag_pendiente => Lr_DocFinAnticPago(Li_Cont).Id_Documento, nd_noapp => Lrf_AnticiposNoAplic);                                
        LOOP
          FETCH Lrf_AnticiposNoAplic BULK COLLECT INTO Lr_AnticNoAplic LIMIT 10;
            Li_ContAnt := Lr_AnticNoAplic.FIRST;
            WHILE (Li_ContAnt IS NOT NULL) LOOP                      
              IF Lr_AnticNoAplic(Li_ContAnt).Codigo_Tipo_Documento in ('ND','NDI','DEV') THEN
                Ln_ValorIngresoDoc := Ln_ValorIngresoDoc + ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);
                Ln_SumaValorTotal := Ln_SumaValorTotal + ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);
                Ln_ValorIngreso := Ln_ValorIngreso + ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);                
                FOR i In C_GetDocumentoFinancieroDet(Lr_AnticNoAplic(Li_ContAnt).Id_Documento) LOOP
                  Lcl_ObsDetalleFact := i.Observaciones_Factura_Detalle;
                END LOOP;                
                Ln_Id := Ln_Id + 1;        
                Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_AnticNoAplic(Li_ContAnt).Numero_Factura_Sri;
                Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);
                Lr_EstadoCuenta(Ln_Id).Valor_Egreso := 0;
                Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_AnticNoAplic(Li_ContAnt).Fecha_Creacion;
                Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_AnticNoAplic(Li_ContAnt).Codigo_Tipo_Documento;
                Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
                Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
                Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
                Lr_EstadoCuenta(Ln_Id).Numero := NULL;
                Lr_EstadoCuenta(Ln_Id).Observacion := Lcl_ObsDetalleFact;
                Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';
              END IF;              
              IF Lr_AnticNoAplic(Li_ContAnt).Codigo_Tipo_Documento in ('PAG','PAGC','ANT','ANTC','ANTS')  THEN
                Ln_ValorEgresoDoc := Ln_ValorEgresoDoc + ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);
                Ln_SumaValorTotal := Ln_SumaValorTotal - ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);
                Ln_ValorEgreso := Ln_ValorEgreso + ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);                
                OPEN C_GetPagoDet(Lr_AnticNoAplic(Li_ContAnt).Id_Documento);
                FETCH C_GetPagoDet INTO Lc_PagoDet;
                CLOSE C_GetPagoDet;                
                Ln_Id := Ln_Id + 1;        
                Lr_EstadoCuenta(Ln_Id).Id_Documento := NULL;
                Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := 0;
                Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Lr_AnticNoAplic(Li_ContAnt).Precio,2);
                Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_AnticNoAplic(Li_ContAnt).Fecha_Creacion;
                Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
                Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_AnticNoAplic(Li_ContAnt).Codigo_Tipo_Documento;
                Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
                Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
                Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
                Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_AnticNoAplic(Li_ContAnt).Codigo_Forma_Pago;
                Lr_EstadoCuenta(Ln_Id).Numero := Lr_AnticNoAplic(Li_ContAnt).Numero_Referencia;
                Lr_EstadoCuenta(Ln_Id).Observacion := REPLACE(Lc_PagoDet.Comentario,'/','-');
                Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';
              END IF;                             
             Li_ContAnt:= Lr_AnticNoAplic.NEXT(Li_ContAnt);                                            
          END LOOP;
          EXIT WHEN Lrf_AnticiposNoAplic%NOTFOUND;
        END LOOP;                  
        Ln_Id := Ln_Id + 1;        
        Lr_EstadoCuenta(Ln_Id).Id_Documento := 'Total:';
        Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Ln_ValorIngresoDoc,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Ln_ValorEgresoDoc,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := ROUND(Ln_ValorIngresoDoc - Ln_ValorEgresoDoc,2);
        Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := NULL;
        Lr_EstadoCuenta(Ln_Id).Login := NULL;
        Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := NULL;
        Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
        Lr_EstadoCuenta(Ln_Id).Numero := NULL;
        Lr_EstadoCuenta(Ln_Id).Observacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';        
        Ln_ValorIngresoDoc := 0; Ln_ValorEgresoDoc := 0;        
        Li_Cont:= Lr_DocFinAnticPago.NEXT(Li_Cont);                                            
      END LOOP;              
      EXIT WHEN Lrf_DocFinAnticPagos%NOTFOUND;
    END LOOP;    
    LOOP
      FETCH Lrf_AnticiposPagos BULK COLLECT INTO Lr_AnticipoPago LIMIT 500;
      Li_Cont := Lr_AnticipoPago.FIRST;        
      Ln_SumaPagoAnticPend := 0; Ln_ValorAnticPago  := 0;    
      Ln_Id := Ln_Id + 1; Lr_EstadoCuenta(Ln_Id).Id_Documento := 'Historial Anticipos asignados';
      Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := NULL; Lr_EstadoCuenta(Ln_Id).Valor_Egreso := NULL; Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
      Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := NULL; Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL; Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
      Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := NULL; Lr_EstadoCuenta(Ln_Id).Login := NULL; Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := NULL;
      Lr_EstadoCuenta(Ln_Id).Referencia := NULL; Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL; Lr_EstadoCuenta(Ln_Id).Numero := NULL;
      Lr_EstadoCuenta(Ln_Id).Observacion := NULL; Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';     
      Ln_TotalAnticPagoPend := 0; Ln_ValorIngresoDoc := 0; Ln_ValorEgresoDoc := 0;           
      WHILE (Li_Cont IS NOT NULL) LOOP        
        OPEN C_GetPunto(Lr_AnticipoPago(Li_Cont).Punto_Id);
        FETCH C_GetPunto INTO Lc_Punto;
        CLOSE C_GetPunto;        
        IF Lr_AnticipoPago(Li_Cont).Movimiento = '-' THEN
          Ln_SumaPagoAnticPend := Ln_SumaPagoAnticPend + ROUND(Lr_AnticipoPago(Li_Cont).Valor_Total,2);
          Ln_ValorAnticPago := ROUND(Lr_AnticipoPago(Li_Cont).Valor_Total,2);
          Ln_TotalAnticPagoPend := Ln_TotalAnticPagoPend + ROUND(Lr_AnticipoPago(Li_Cont).Valor_Total,2);
          Ln_SumaValorTotal := Ln_SumaValorTotal - ROUND(Lr_AnticipoPago(Li_Cont).Valor_Total,2);
          Ln_ValorEgreso := Ln_ValorEgreso + ROUND(Lr_AnticipoPago(Li_Cont).Valor_Total,2);
        END IF;        
        OPEN C_GetOficinaGrupo(Lr_AnticipoPago(Li_Cont).Oficina_Id);
        FETCH C_GetOficinaGrupo INTO Lc_OficinaGrupo;
        CLOSE C_GetOficinaGrupo;        
        Ln_ValorEgresoDoc := Ln_ValorEgresoDoc + Ln_ValorAnticPago;        
        OPEN C_GetHistorialPago(Lr_AnticipoPago(Li_Cont).Id_Pago);
        FETCH C_GetHistorialPago INTO Lc_HistorialPago;
        CLOSE C_GetHistorialPago;        
        IF Lr_AnticipoPago(Li_Cont).Id_Recaudacion IS NOT NULL THEN
          DBMS_LOB.APPEND(Lc_HistorialPago.observacion,', fecha:'||TO_CHAR(Lr_AnticipoPago(Li_Cont).Fe_Creacion,'RRRR-MM-DD HH24:MI:SS'));
        END IF;        
        Ln_Id := Ln_Id + 1;        
        Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_AnticipoPago(Li_Cont).Numero_Pago;
        Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := 0;
        Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Ln_ValorAnticPago,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := Lr_AnticipoPago(Li_Cont).Fe_Creacion;
        Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_AnticipoPago(Li_Cont).Codigo_Tipo_Documento;
        Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
        Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
        Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
        Lr_EstadoCuenta(Ln_Id).Numero := NULL;
        Lr_EstadoCuenta(Ln_Id).Observacion := Lc_HistorialPago.observacion;
        Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';         
        ANTICIPOS_GENERADOS(id_documento => Lr_AnticipoPago(Li_Cont).Id_Pago, anticipos     => Lrf_AnticGenerado);                            
        LOOP
          FETCH Lrf_AnticGenerado BULK COLLECT INTO Lr_AnticGenerado LIMIT 10;
            Li_ContAntGen := Lr_AnticGenerado.FIRST;
            WHILE (Li_ContAntGen IS NOT NULL) LOOP             
              Ln_ValorIngresoDoc := Ln_ValorIngresoDoc + ROUND(Lr_AnticGenerado(Li_ContAntGen).Valor_Pago,2);
              Ln_SumaValorTotal := Ln_SumaValorTotal + ROUND(Lr_AnticGenerado(Li_ContAntGen).Valor_Pago,2);
              Ln_ValorIngreso := Ln_ValorIngreso + ROUND(Lr_AnticGenerado(Li_ContAntGen).Valor_Pago,2);              
              OPEN C_GetPagoDet(Lr_AnticGenerado(Li_ContAntGen).Id_Pago_Det);
              FETCH C_GetPagoDet INTO Lc_PagoDet;
              CLOSE C_GetPagoDet;              
              Ln_Id := Ln_Id + 1;        
              Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_AnticGenerado(Li_ContAntGen).Numero_Pago;
              Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Lr_AnticGenerado(Li_ContAntGen).Valor_Pago,2);
              Lr_EstadoCuenta(Ln_Id).Valor_Egreso := 0;
              Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := NULL;
              Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := TO_DATE(Lr_AnticGenerado(Li_ContAntGen).Fecha_Creacion,'DD/MM/RRRR');
              Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
              Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
              Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_AnticGenerado(Li_ContAntGen).Codigo_Tipo_Documento;
              Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
              Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
              Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
              Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_AnticGenerado(Li_ContAntGen).Codigo_Forma_Pago;
              Lr_EstadoCuenta(Ln_Id).Numero := Lr_AnticGenerado(Li_ContAntGen).Numero_Referencia;
              Lr_EstadoCuenta(Ln_Id).Observacion := REPLACE(Lc_PagoDet.comentario,'/','-');
              Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';            
            Li_ContAntGen:= Lr_AnticGenerado.NEXT(Li_ContAntGen);                                            
            END LOOP;
          EXIT WHEN Lrf_AnticGenerado%NOTFOUND;
        END LOOP;                     
        Ln_Id := Ln_Id + 1;        
        Lr_EstadoCuenta(Ln_Id).Id_Documento := 'Total:';
        Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Ln_ValorIngresoDoc,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Ln_ValorEgresoDoc,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := ROUND(Ln_ValorIngresoDoc - Ln_ValorEgresoDoc,2);
        Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Emision := NULL;
        Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := NULL;
        Lr_EstadoCuenta(Ln_Id).Login := NULL;
        Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := NULL;
        Lr_EstadoCuenta(Ln_Id).Referencia := NULL;
        Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := NULL;
        Lr_EstadoCuenta(Ln_Id).Numero := NULL;
        Lr_EstadoCuenta(Ln_Id).Observacion := NULL;
        Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';        
        Ln_ValorIngresoDoc := 0; Ln_ValorEgresoDoc := 0;        
        Li_Cont:= Lr_AnticipoPago.NEXT(Li_Cont);                                  
      END LOOP;
      EXIT WHEN Lrf_AnticiposPagos%NOTFOUND;
    END LOOP;    
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('razonSocial', Lc_InfoCliente.Razon_Social);
    APEX_JSON.WRITE('nombres', Lc_InfoCliente.Nombres);
    APEX_JSON.WRITE('apellidos', Lc_InfoCliente.Apellidos);
    APEX_JSON.WRITE('direccion', Lc_InfoCliente.Direccion);
    APEX_JSON.WRITE('nombreOficina', Lc_InfoCliente.Nombre_Oficina);    
    APEX_JSON.OPEN_ARRAY('detalles');    
    Ln_Idx := Lr_EstadoCuenta.FIRST;
    WHILE Ln_Idx IS NOT NULL LOOP
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('documento', Lr_EstadoCuenta(Ln_Idx).Id_Documento);
      APEX_JSON.WRITE('valorIngreso', Lr_EstadoCuenta(Ln_Idx).Valor_Ingreso);
      APEX_JSON.WRITE('valorEgreso', Lr_EstadoCuenta(Ln_Idx).Valor_Egreso);
      APEX_JSON.WRITE('valorAcumulado', Lr_EstadoCuenta(Ln_Idx).Valor_Acumulado);
      APEX_JSON.WRITE('fechaCreacion', TO_CHAR(Lr_EstadoCuenta(Ln_Idx).Fecha_Creacion,'DD-MM-RRRR'));
      APEX_JSON.WRITE('fechaEmision', TO_CHAR(Lr_EstadoCuenta(Ln_Idx).Fecha_Emision,'DD-MM-RRRR'));
      APEX_JSON.WRITE('fechaAutorizacion', TO_CHAR(Lr_EstadoCuenta(Ln_Idx).Fecha_Autorizacion,'DD-MM-RRRR'));
      APEX_JSON.WRITE('codigoTipoDocumento', Lr_EstadoCuenta(Ln_Idx).Codigo_Tipo_Documento);
      APEX_JSON.WRITE('login', Lr_EstadoCuenta(Ln_Idx).Login);
      APEX_JSON.WRITE('nombreOficina', Lr_EstadoCuenta(Ln_Idx).Nombre_Oficina);
      APEX_JSON.WRITE('referencia', Lr_EstadoCuenta(Ln_Idx).Referencia);
      APEX_JSON.WRITE('codigoFormaPago', Lr_EstadoCuenta(Ln_Idx).Codigo_Forma_Pago);
      APEX_JSON.WRITE('numero', Lr_EstadoCuenta(Ln_Idx).Numero);
      APEX_JSON.WRITE('observacion', Lr_EstadoCuenta(Ln_Idx).Observacion);
      IF Lr_EstadoCuenta(Ln_Idx).Es_Suma_Valor_Total = 'S' THEN
        APEX_JSON.WRITE('tieneSumaValorTotal', true);
      ELSE
        APEX_JSON.WRITE('tieneSumaValorTotal', false);
      END IF;      
      APEX_JSON.CLOSE_OBJECT;
      Ln_Idx := Lr_EstadoCuenta.NEXT(Ln_Idx);
    END LOOP;    
    APEX_JSON.CLOSE_ARRAY;    
    APEX_JSON.WRITE('saldoMigracion', ROUND(ABS(Ln_SumaTotalMigracion),2));
    APEX_JSON.WRITE('saldoDebe', ROUND(Ln_ValorIngreso,2));
    APEX_JSON.WRITE('saldoHaber', ROUND(Ln_ValorEgreso,2));
    APEX_JSON.WRITE('saldo', ROUND(Ln_SumaValorTotal,2));
    APEX_JSON.CLOSE_OBJECT;    
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
    Pcl_Response := Lcl_Response;    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || Sqlerrm;
  END P_GET_ESTADO_CUENTA_POR_PUNTO;

  PROCEDURE P_GET_ESTADO_CUENTA_CLIENTE(Pcl_Request  IN CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT CLOB)  AS

    CURSOR C_GetPunto(Cn_IdPunto NUMBER) IS
      SELECT Ipu.* FROM DB_COMERCIAL.Info_Punto Ipu WHERE Ipu.Id_Punto = Cn_IdPunto;

    CURSOR C_GetOficinaGrupo(Cn_IdOficina NUMBER) IS
      SELECT Iog.* FROM DB_COMERCIAL.Info_Oficina_Grupo Iog WHERE Iog.Id_Oficina = Cn_IdOficina;            

    CURSOR C_GetAnticipoPorCruce(Cn_IdDetPago NUMBER, Cv_CodTipoDocumento VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT Pc.* FROM Info_Pago_Cab Pc,Info_Pago_Det Pd, Info_Pago_Cab Ac, Admi_Tipo_Documento_Financiero Td
      WHERE Ac.Id_Pago = Pd.Pago_Id AND Pd.Id_Pago_Det = Cn_IdDetPago AND Pc.Anticipo_Id = Ac.Id_Pago AND Pc.Tipo_Documento_Id = Td.Id_Tipo_Documento 
      AND Td.Codigo_Tipo_Documento = Cv_CodTipoDocumento AND Ac.Estado_Pago = Cv_Estado;

    CURSOR C_GetDocRelacionado(Cn_IdDocumento NUMBER) IS
      SELECT ipc.numero_Pago FROM Info_Documento_Financiero_Det idfd, Info_Pago_Det ipd, Info_Pago_Cab ipc
      WHERE idfd.documento_Id = Cn_IdDocumento AND ipd.id_pago_det = idfd.pago_Det_Id AND ipc.id_pago = ipd.pago_Id;

    CURSOR C_GetDocumentoCaracteristica(Cv_Tipo VARCHAR2, Cv_Caracteristica VARCHAR2, Cn_IdDocumento NUMBER) IS
      SELECT Idc.* FROM Db_Comercial.Admi_Caracteristica Ac INNER JOIN Info_Documento_Caracteristica Idc ON Ac.Id_Caracteristica = Idc.Caracteristica_Id
      WHERE Ac.Tipo = Cv_Tipo AND Ac.Estado = 'Activo' AND Ac.Descripcion_Caracteristica = Cv_Caracteristica AND Idc.Documento_Id = Cn_IdDocumento;

    CURSOR C_GetDocumentoFinancieroCab(Cn_IdDocumento NUMBER) IS
      SELECT Idfc.* FROM Info_Documento_Financiero_Cab Idfc WHERE Idfc.Id_Documento = Cn_IdDocumento;

    CURSOR C_GetPagoCab(Cn_IdPago NUMBER) IS
      SELECT Ipc.* FROM Info_Pago_Cab Ipc WHERE Ipc.Id_Pago = Cn_IdPago; 

    CURSOR C_GetInfoCliente(Cv_IdentificacionCliente VARCHAR2, Cv_CodEmpresa VARCHAR2) IS
      SELECT Ipe.Direccion, Ipe.Id_Persona, Ipe.Razon_Social, Ipe.Nombres,Ipe.Apellidos,Ipe.Direccion_Tributaria, Iog.Nombre_Oficina
      FROM Db_Comercial.Info_Persona Ipe,Db_Comercial.Info_Persona_Empresa_Rol Iper,Db_Comercial.Info_Empresa_Rol Ier,Info_Oficina_Grupo Iog
      WHERE Ipe.Identificacion_Cliente = Cv_IdentificacionCliente AND Ipe.Id_Persona = Iper.Persona_Id AND Iper.estado = 'Activo'
        AND Iper.Empresa_Rol_Id = Ier.Id_Empresa_Rol AND Ier.Empresa_Cod = Cv_CodEmpresa AND Iper.Oficina_Id = Iog.Id_Oficina;

    Lv_IdentifCliente     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Lc_Punto              C_GetPunto%ROWTYPE;
    Lc_AnticipoPorCruce   C_GetAnticipoPorCruce%ROWTYPE;
    Lc_OficinaGrupo       C_GetOficinaGrupo%ROWTYPE;
    Lc_DocRelacionado     C_GetDocRelacionado%ROWTYPE;
    Lc_DocFinancieroCab   C_GetDocumentoFinancieroCab%ROWTYPE;
    Lc_PagoCab            C_GetPagoCab%ROWTYPE;
    Lc_InfoCliente        C_GetInfoCliente%ROWTYPE;
    Ln_Id                 NUMBER := 0;
    Ln_Idx                NUMBER := 0;
    Ln_TotalRegistros     NUMBER;
    Ln_Sumatoria          NUMBER := 0;
    Ln_ValorIngreso       NUMBER := 0;
    Ln_ValorEgreso        NUMBER := 0;
    Ln_AnticiposPend      NUMBER := 0;
    Lb_DocTieneDepend     BOOLEAN;
    Lb_SumaValorTotal     BOOLEAN;
    Lv_Movimiento         VARCHAR2(5);
    Lv_FechaEmisionDesde  VARCHAR2(30);
    Lv_FechaEmisionHasta  VARCHAR2(30);
    Lv_NumeroRefCtaBanco  VARCHAR2(500);
    Lv_NumeroFactPagada   VARCHAR2(500);
    Lcl_Response          CLOB;
    Lrf_DocFinancierosCab SYS_REFCURSOR;
    Li_Cont               PLS_INTEGER;
    Lr_DocEstadoCuenta    FNKG_TYPES_DOCUMENTOS.Ltr_DocEstadoCuenta;
    Lr_EstadoCuenta       FNKG_TYPES_DOCUMENTOS.Ltr_EstadoCuenta;
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_IdentifCliente := APEX_JSON.get_varchar2('identificacionCliente');
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Lv_FechaEmisionDesde := APEX_JSON.get_varchar2('fechaEmisionDesde');
    Lv_FechaEmisionHasta := APEX_JSON.get_varchar2('fechaEmisionHasta');     
    OPEN C_GetInfoCliente(Lv_IdentifCliente,Lv_CodEmpresa);
    FETCH C_GetInfoCliente INTO Lc_InfoCliente;
    CLOSE C_GetInfoCliente;    
    FNCK_CONSULTS.P_ESTADO_CTA_CLIENTE(Pv_EmpresaCod        => Lv_CodEmpresa,
                                       Pn_PersonaId         => Lc_InfoCliente.Id_Persona,
                                       Pv_FechaEmisionDesde => TO_CHAR(TO_DATE(Lv_FechaEmisionDesde,'RRRR-MM-DD'),'DD/MM/YY'),
                                       Pv_FechaEmisionHasta => TO_CHAR(TO_DATE(Lv_FechaEmisionHasta,'RRRR-MM-DD'),'DD/MM/YY'),
                                       Pn_TotalRegistros    => Ln_TotalRegistros,
                                       Pc_Documentos        => Lrf_DocFinancierosCab);   
    LOOP
      FETCH Lrf_DocFinancierosCab BULK COLLECT INTO Lr_DocEstadoCuenta LIMIT 1000;
      Li_Cont := Lr_DocEstadoCuenta.FIRST;      
      Lb_DocTieneDepend := false;      
      WHILE (Li_Cont IS NOT NULL) LOOP         
        OPEN C_GetPunto(Lr_DocEstadoCuenta(Li_Cont).Punto_Id);
        FETCH C_GetPunto INTO Lc_Punto;
        CLOSE C_GetPunto;        
        Lb_SumaValorTotal := true;
        OPEN C_GetAnticipoPorCruce(Lr_DocEstadoCuenta(Li_Cont).Id_Documento,Lr_DocEstadoCuenta(Li_Cont).Codigo_Tipo_Documento,'Cerrado');
        FETCH C_GetAnticipoPorCruce INTO Lc_AnticipoPorCruce;
        CLOSE C_GetAnticipoPorCruce;
        IF Lc_AnticipoPorCruce.Id_Pago IS NOT NULL THEN
          Lb_SumaValorTotal := false;
        END IF;        
        Lv_Movimiento := Lr_DocEstadoCuenta(Li_Cont).Movimiento;                
        IF Lv_Movimiento = '+' THEN
          Ln_Sumatoria := Ln_Sumatoria + ROUND(Lr_DocEstadoCuenta(Li_Cont).Valor_Total,2);
          Ln_ValorIngreso := ROUND(Lr_DocEstadoCuenta(Li_Cont).Valor_Total,2);
        END IF;        
        IF Lv_Movimiento = '-' THEN
          IF Lb_SumaValorTotal THEN        
            Ln_Sumatoria := Ln_Sumatoria - ROUND(Lr_DocEstadoCuenta(Li_Cont).Valor_Total,2);
          ELSE
            Lv_Movimiento := null;
          END IF;
          Ln_ValorEgreso := ROUND(Lr_DocEstadoCuenta(Li_Cont).Valor_Total,2);
        END IF;        
        OPEN C_GetOficinaGrupo(Lr_DocEstadoCuenta(Li_Cont).Oficina_Id);
        FETCH C_GetOficinaGrupo INTO Lc_OficinaGrupo;
        CLOSE C_GetOficinaGrupo;        
        Lv_NumeroRefCtaBanco := NULL;
        Lv_NumeroRefCtaBanco := Lr_DocEstadoCuenta(Li_Cont).Numero_Referencia;        
        IF Lv_NumeroRefCtaBanco IS NULL THEN
          Lv_NumeroRefCtaBanco := Lr_DocEstadoCuenta(Li_Cont).Numero_Cuenta_Banco;
        END IF;
        Lv_NumeroFactPagada := NULL;        
        IF Lr_DocEstadoCuenta(Li_Cont).Codigo_Tipo_Documento IN ('ND','NDI','DEV') THEN           
          OPEN C_GetDocRelacionado(Lr_DocEstadoCuenta(Li_Cont).Id_Documento);
          FETCH C_GetDocRelacionado INTO Lc_DocRelacionado;
          CLOSE C_GetDocRelacionado;                      
          IF Lc_DocRelacionado.Numero_Pago IS NOT NULL THEN
            Lv_NumeroFactPagada := Lc_DocRelacionado.Numero_Pago;  
          ELSE
            IF Lr_DocEstadoCuenta(Li_Cont).Codigo_Tipo_Documento = 'NDI' THEN

              FOR i in C_GetDocumentoCaracteristica('FINANCIERO','ID_REFERENCIA_NCI',Lr_DocEstadoCuenta(Li_Cont).Id_Documento) LOOP                
                OPEN C_GetDocumentoFinancieroCab(i.Valor);
                FETCH C_GetDocumentoFinancieroCab INTO Lc_DocFinancieroCab;
                CLOSE C_GetDocumentoFinancieroCab;                
                IF Lc_DocFinancieroCab.Id_Documento IS NOT NULL THEN
                  Lv_NumeroFactPagada := Lv_NumeroFactPagada || Lc_DocFinancieroCab.Numero_Factura_Sri||' ';
                END IF;                
              END LOOP;              
            END IF;
          END IF;          
        END IF;        
        IF Lr_DocEstadoCuenta(Li_Cont).Pago_Tiene_Depend = 'S' THEN
          Lb_DocTieneDepend := true;
        END IF;        
        IF Lr_DocEstadoCuenta(Li_Cont).Referencia_Id IS NOT NULL THEN
          IF Lr_DocEstadoCuenta(Li_Cont).Codigo_Tipo_Documento IN ('PAG','PAGC','ANT','ANTC','ANTS','NC','NCI') THEN 
            OPEN C_GetDocumentoFinancieroCab(Lr_DocEstadoCuenta(Li_Cont).Referencia_Id);
            FETCH C_GetDocumentoFinancieroCab INTO Lc_DocFinancieroCab;
            CLOSE C_GetDocumentoFinancieroCab;
            Lv_NumeroFactPagada := Lc_DocFinancieroCab.Numero_Factura_Sri;
          ELSE
            Lv_NumeroFactPagada := NULL;
          END IF;
        ELSE
          IF Lr_DocEstadoCuenta(Li_Cont).Codigo_Tipo_Documento IN ('PAG','PAGC','ANT','ANTC','ANTS','NC','NCI') THEN 
            OPEN C_GetPagoCab(Lr_DocEstadoCuenta(Li_Cont).Ref_Anticipo_Id);
            FETCH C_GetPagoCab INTO Lc_PagoCab;
            CLOSE C_GetPagoCab;            
            Lv_NumeroFactPagada := Lc_PagoCab.Numero_Pago;            
            IF Lr_DocEstadoCuenta(Li_Cont).Estado_Impresion_Fact = 'Pendiente' THEN
              Ln_AnticiposPend := Ln_AnticiposPend + ROUND(Lr_DocEstadoCuenta(Li_Cont).Valor_Total,2);
            END IF;            
          END IF;
        END IF;        
        Ln_Id := Ln_Id + 1;        
        Lr_EstadoCuenta(Ln_Id).Id_Documento := Lr_DocEstadoCuenta(Li_Cont).Numero_Factura_Sri;
        Lr_EstadoCuenta(Ln_Id).Valor_Ingreso := ROUND(Ln_ValorIngreso,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Egreso := ROUND(Ln_ValorEgreso,2);
        Lr_EstadoCuenta(Ln_Id).Valor_Acumulado := ROUND(Ln_Sumatoria,2);
        Lr_EstadoCuenta(Ln_Id).Fecha_Creacion := TO_DATE(Lr_DocEstadoCuenta(Li_Cont).Fec_Creacion,'DD/MM/RRRR HH24:MI');
        Lr_EstadoCuenta(Ln_Id).Fecha_Emision := TO_DATE(Lr_DocEstadoCuenta(Li_Cont).Fec_Emision,'DD/MM/RRRR HH24:MI');
        Lr_EstadoCuenta(Ln_Id).Fecha_Autorizacion := TO_DATE(Lr_DocEstadoCuenta(Li_Cont).Fec_Autorizacion,'DD/MM/RRRR HH24:MI');
        Lr_EstadoCuenta(Ln_Id).Codigo_Tipo_Documento := Lr_DocEstadoCuenta(Li_Cont).Codigo_Tipo_Documento;
        Lr_EstadoCuenta(Ln_Id).Login := Lc_Punto.Login;
        Lr_EstadoCuenta(Ln_Id).Nombre_Oficina := Lc_OficinaGrupo.Nombre_Oficina;
        Lr_EstadoCuenta(Ln_Id).Referencia := Lv_NumeroFactPagada;
        Lr_EstadoCuenta(Ln_Id).Codigo_Forma_Pago := Lr_DocEstadoCuenta(Li_Cont).Codigo_Forma_Pago;
        Lr_EstadoCuenta(Ln_Id).Numero := Lv_NumeroRefCtaBanco;
        Lr_EstadoCuenta(Ln_Id).Movimiento := Lr_DocEstadoCuenta(Li_Cont).Movimiento;        
        Lr_EstadoCuenta(Ln_Id).Saldo_Actual_Doc := Lr_DocEstadoCuenta(Li_Cont).Saldo_Actual_Doc;
        IF Lb_SumaValorTotal THEN
          Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'S';
        ELSE
          Lr_EstadoCuenta(Ln_Id).Es_Suma_Valor_Total := 'N';
        END IF;
        IF Lb_DocTieneDepend THEN
          Lr_EstadoCuenta(Ln_Id).Pago_Tiene_Depend := 'S';
        ELSE
          Lr_EstadoCuenta(Ln_Id).Pago_Tiene_Depend := 'N';
        END IF;        
        Li_Cont:= Lr_DocEstadoCuenta.NEXT(Li_Cont);
      END LOOP;
      EXIT WHEN Lrf_DocFinancierosCab%NOTFOUND;
    END LOOP;    
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;        
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('razonSocial', Lc_InfoCliente.Razon_Social);
    APEX_JSON.WRITE('nombres', Lc_InfoCliente.Nombres);
    APEX_JSON.WRITE('apellidos', Lc_InfoCliente.Apellidos);
    APEX_JSON.WRITE('direccion', Lc_InfoCliente.Direccion);
    APEX_JSON.WRITE('nombreOficina', Lc_InfoCliente.Nombre_Oficina);    
    APEX_JSON.OPEN_ARRAY('detalles');    
    Ln_Idx := Lr_EstadoCuenta.FIRST;
    WHILE Ln_Idx IS NOT NULL LOOP
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('documento', Lr_EstadoCuenta(Ln_Idx).Id_Documento);
      APEX_JSON.WRITE('valorIngreso', Lr_EstadoCuenta(Ln_Idx).Valor_Ingreso);
      APEX_JSON.WRITE('valorEgreso', Lr_EstadoCuenta(Ln_Idx).Valor_Egreso);
      APEX_JSON.WRITE('valorAcumulado', Lr_EstadoCuenta(Ln_Idx).Valor_Acumulado);
      APEX_JSON.WRITE('fechaCreacion', TO_CHAR(Lr_EstadoCuenta(Ln_Idx).Fecha_Creacion,'DD-MM-RRRR'));
      APEX_JSON.WRITE('fechaEmision', TO_CHAR(Lr_EstadoCuenta(Ln_Idx).Fecha_Emision,'DD-MM-RRRR'));
      APEX_JSON.WRITE('fechaAutorizacion', TO_CHAR(Lr_EstadoCuenta(Ln_Idx).Fecha_Autorizacion,'DD-MM-RRRR'));
      APEX_JSON.WRITE('codigoTipoDocumento', Lr_EstadoCuenta(Ln_Idx).Codigo_Tipo_Documento);
      APEX_JSON.WRITE('login', Lr_EstadoCuenta(Ln_Idx).Login);
      APEX_JSON.WRITE('nombreOficina', Lr_EstadoCuenta(Ln_Idx).Nombre_Oficina);
      APEX_JSON.WRITE('referencia', Lr_EstadoCuenta(Ln_Idx).Referencia);
      APEX_JSON.WRITE('codigoFormaPago', Lr_EstadoCuenta(Ln_Idx).Codigo_Forma_Pago);
      APEX_JSON.WRITE('numero', Lr_EstadoCuenta(Ln_Idx).Numero);
      APEX_JSON.WRITE('movimiento', Lr_EstadoCuenta(Ln_Idx).Movimiento);
      APEX_JSON.WRITE('saldoActual', Lr_EstadoCuenta(Ln_Idx).Saldo_Actual_Doc);
      IF Lr_EstadoCuenta(Ln_Idx).Es_Suma_Valor_Total = 'S' THEN
        APEX_JSON.WRITE('tieneSumaValorTotal', true);
      ELSE
        APEX_JSON.WRITE('tieneSumaValorTotal', false);
      END IF;  
      IF Lr_EstadoCuenta(Ln_Idx).Pago_Tiene_Depend = 'S' THEN
        APEX_JSON.WRITE('pagoTieneDependencia', true);
      ELSE
        APEX_JSON.WRITE('pagoTieneDependencia', false);
      END IF;
      APEX_JSON.CLOSE_OBJECT;
      Ln_Idx := Lr_EstadoCuenta.NEXT(Ln_Idx);
    END LOOP;    
    APEX_JSON.CLOSE_ARRAY;    
    APEX_JSON.WRITE('saldo', ROUND(Ln_Sumatoria,2));
    APEX_JSON.WRITE('anticiposPendientes', ROUND(Ln_AnticiposPend,2));
    APEX_JSON.WRITE('saldoFinal', ROUND(Ln_Sumatoria,2));      
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
    Pcl_Response := Lcl_Response;    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || Sqlerrm;
  END;

END FNKG_ESTADOS_CUENTA_C;
/
