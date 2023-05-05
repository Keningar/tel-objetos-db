CREATE OR REPLACE PACKAGE BI_FINANCIERO.BFNKG_CONSULTS
AS
  --
  /**
  * Documentacion para la procedimiento ' PROCEDURE P_GET_INFO_DET_FACT_ASESOR'
  *
  * Procedimiento que consulta la informacfacturacion por asesor
  *
  * @param  Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,  prefijo de la empresa que se desea consultar
  * @param  Pv_TipoConsulta        IN varchar2 tipo de consulta si es TOTALIZADO o DETALLADO
  * @param  Pv_CargoPersona        IN varchar2 si es SUBGERENTE, VENDEDOR o GERENTE_VENTAS
  * @param  Pv_Tipo                IN varchar2 si es facturacion MRC o NRC
  * @param  Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  id_persona_empresa_rol del asesor
  * @param  Pd_FechaInicio         IN TIMESTAMP Fecha para consultar la informacion requerida
  * @param Pv_EmailUsrSesion       IN VARCHAR2 email del asesor que consulta reporte
  * @param Pr_InformacionDashboard OUT SYS_REFCURSOR  Retorna el resultado consultado
  *
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 19-03-2018
  *
  * Actualización: Ahora se obtiene valores MRC y NRC según la frecuencia del servicio. Tambien se recibe nuevo parametro Pv_EmailUsrSesion
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.1 25-04-2018
  *
  * Actualización: Se asigna los valores de instalación al NRC
                   En el reporte de excel se agrega FE_EMISION, NOMBRE ASESOR, IDENTIFICACION CLIENTE y TIPO 
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.2 08-05-2018
  *
  * Actualización: Ahora el procedimiento retorna el cumplimiento de presupuesto MRC y NRC con sus respectivos asesores
  * @author Kevin Baque <kbaque@telconet.ec>
  * @version 1.3 11-11-2018
  *  
  * Actualización: Se valida el tipo de facturación (MRC o NRC), en las facturas manuales.
  * @author David Leon <mdleon@telconet.ec>
  * @version 1.4 09-21-2021
  *
  * Actualización: Se incluye en los calculos los datos de Internet/Datos y Business Solutions, de la misma forma el calculo trimestral para Nrc.
  * @author David Leon <mdleon@telconet.ec>
  * @version 1.5 12-12-2021
  *
  * Actualización: Se agrega validación para filtrar correctamente los traslados y reubicaciones de TN como NRC y mostrar sus valores en la columna correspondiente.
  * @author Bryan Fonseca <bfonseca@telconet.ec>
  * @version 1.5 16-09-2022
  */
  PROCEDURE P_GET_INFO_DET_FACT_ASESOR(
      Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoConsulta         IN varchar2,
      Pv_CargoPersona         IN varchar2,
      Pv_Tipo                 IN varchar2,
      Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pd_FechaInicio          IN TIMESTAMP,
      Pv_EmailUsrSesion       IN VARCHAR2,
      Pr_InformacionDashboard OUT SYS_REFCURSOR );

  --
  /**
  * Documentacion para la procedimiento ' PROCEDURE P_GET_INFO_CUMPLIMIENTO_ASESOR'
  *
  * Procedimiento que envia al correo la facturacion detallada y el cumplimiento de presupuesto
  *
  * @param  Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,  prefijo de la empresa
  * @param  Pv_TipoConsulta        IN varchar2 tipo de consulta si es CUMPLIMIENTO_MRC o CUMPLIMIENTO_NRC
  * @param  Pv_CargoPersona        IN varchar2 si es SUBGERENTE, VENDEDOR o GERENTE_VENTAS
  * @param  Pv_Tipo                IN varchar2 si es facturacion MRC o NRC
  * @param  Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  id_persona_empresa_rol del asesor
  * @param  Pd_FechaInicio         IN TIMESTAMP Fecha para consultar la informacion requerida
  * @param Pv_EmailUsrSesion       IN VARCHAR2 email del asesor que consulta reporte
  *
  * @author Kevin Baque Puya<kbaque@telconet.ec>
  * @version 1.0 17-10-2018
  *
  * Actualización: Se incluye en los calculos los datos de Internet/Datos y Business Solutions para exportar los cumplimientos.
  * @author David Leon <mdleon@telconet.ec>
  * @version 1.1 12-12-2021
  *
  */
  PROCEDURE P_ENVIA_CUMPLIMIENTO_VEND(
      Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoConsulta         IN varchar2,
      Pv_CargoPersona         IN varchar2,
      Pv_Tipo                 IN varchar2,
      Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pd_FechaInicio          IN TIMESTAMP,
      Pv_EmailUsrSesion       IN VARCHAR2);
      
 --         
  --
 --         
END BFNKG_CONSULTS;
/

CREATE OR REPLACE PACKAGE BODY BI_FINANCIERO.BFNKG_CONSULTS
AS
  --
  --
  --
  PROCEDURE P_GET_INFO_DET_FACT_ASESOR(
      Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoConsulta         IN varchar2,
      Pv_CargoPersona         IN varchar2,
      Pv_Tipo                 IN varchar2,
      Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pd_FechaInicio          IN TIMESTAMP,
      Pv_EmailUsrSesion       IN VARCHAR2,
      Pr_InformacionDashboard OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    Lv_CamposAdicionales    VARCHAR2(500);
    Lv_RegistroAdicional    VARCHAR2(1000);
    Lv_Select               VARCHAR2(4500)       := 'SELECT ';
    Lv_From                 VARCHAR2(4000)       := '';
    Lv_Where                VARCHAR2(4000)       := '';
    Lv_GroupBy              VARCHAR2(4000)       := '';
    --
    Lv_Delimitador          VARCHAR2(1)          := ';';
    Lv_Remitente            VARCHAR2(20)         := 'telcos@telconet.ec';
    Lv_Destinatario         VARCHAR2(100)        := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
    Lv_Asunto               VARCHAR2(300)        := 'Notificacion DETALLADO DE FACTURACION';
    Lc_InformacionDashboard BFNKG_TYPES.Lr_DetalladoFacturacionMrcNrc;
    Lfile_Archivo           utl_file.file_type;
    Lv_Directorio           VARCHAR2(50)         := 'DIR_REPGERENCIA';
    Lv_NombreArchivo        VARCHAR2(100)        := 'DetalladoFacturacion_' || Pv_PrefijoEmpresa || '.csv';
    Lv_Gzip                 VARCHAR2(100)        := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip     VARCHAR2(100)        := Lv_NombreArchivo || '.gz';
    Lc_GetAliasPlantilla    DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Cuerpo               VARCHAR2(9999);
    Lv_Case     VARCHAR2(20) := ' CASE ';
    Lv_End      VARCHAR2(20) := ' END ';
    Lv_When     VARCHAR2(20) := ' WHEN ';
    Lv_Then     VARCHAR2(20) := ' THEN ';
    Lv_ElseCero VARCHAR2(20) := ' ELSE 0 ';
    --
    Lv_anio     NUMBER;
    Lv_mes      NUMBER;
    --
    Ln_Trimestre        NUMBER;
    Lv_FechaFin         VARCHAR2(100);
    Lv_FechaIni         VARCHAR2(100);    
    Lv_MesBase          VARCHAR2(100);
    Lv_AnioBase         VARCHAR2(100);
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE           := 'COMERCIAL';    
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE          := 'REPORTES';
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           := 'Activo';
    Lv_DescripcionBase  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'BASES POR VENDEDOR';    
    Lv_DescripcionMeta  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'METAS POR VENDEDOR';  
    Lv_Factura_Caract   NUMBER;
    Lv_Fac_Det_Caract   NUMBER;
    
    Lv_QueryNumFac      VARCHAR2(1000);
    Lv_QueryNumFacDet   VARCHAR2(1000);
    
    Lv_caracteristica      NUMBER;
    Lv_detCaracteristica   NUMBER;
    --
  BEGIN
    --
      Lv_anio   := EXTRACT(YEAR FROM Pd_FechaInicio);
      Lv_mes    := EXTRACT(MONTH FROM Pd_FechaInicio);
      IF Pv_Tipo IS NOT NULL THEN
        Lv_Asunto := Lv_Asunto || ' (' || Pv_Tipo || ')';
      END IF;

     Lv_QueryNumFac :=
    'SELECT ' ||
     '       CARACT.ID_CARACTERISTICA '||
    ' FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARACT '||
    q'[ WHERE CARACT.DESCRIPCION_CARACTERISTICA='NUM_FACTURA_ACUMULADA']';

    Lv_QueryNumFacDet :=
    'SELECT '||
           ' CARACT.ID_CARACTERISTICA '||
    ' FROM DB_COMERCIAL.ADMI_CARACTERISTICA CARACT '||
    q'[ WHERE CARACT.DESCRIPCION_CARACTERISTICA='VAL_FACTURA_ACUMULADA']';


     EXECUTE IMMEDIATE Lv_QueryNumFac INTO Lv_caracteristica;

     Lv_Factura_Caract  := Lv_caracteristica;

     EXECUTE IMMEDIATE Lv_QueryNumFacDet INTO Lv_detCaracteristica;

     Lv_Fac_Det_Caract := Lv_detCaracteristica;
      --
      Lv_Select := 'SELECT EXTRACT(MONTH FROM FE_EMISION) AS MES, ' ||
                   'DOC.FE_EMISION AS FE_EMISION, '||
                   q'[ CASE WHEN P.RAZON_SOCIAL IS NOT NULL THEN P.RAZON_SOCIAL ELSE  P.NOMBRES || ' ' || P.APELLIDOS END AS CLIENTE, ]' ||
                   'P.IDENTIFICACION_CLIENTE, ' ||
                   'PTO.USR_VENDEDOR, ' ||
                   q'[ PERS.NOMBRES || ' ' || PERS.APELLIDOS AS ASESOR, ]' ||
                   'PTO.LOGIN, ' ||
                   q'[CASE WHEN TNEG.CODIGO_TIPO_NEGOCIO = 'EMP' THEN 'RELACIONADA' ELSE 'NO RELACIONADA' END AS FILTRO, ]' ||
                   'PROD.LINEA_NEGOCIO, ' ||
                   'PROD.GRUPO, ' ||
                   'PROD.SUBGRUPO, ' ||
                   'PERC.ID_PERSONA_ROL, ' ||
                   'PROD.DESCRIPCION_PRODUCTO, ' ||
                   ' dbms_lob.substr( DOCD.OBSERVACIONES_FACTURA_DETALLE, 4000, 1 ) AS OBSERVACION_PRODUCTO, ' ||
                   Lv_Case||
                   q'[  WHEN SERV.FRECUENCIA_PRODUCTO = 1  AND PROD.SUBGRUPO <> 'INSTALACION' AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN') ]'||
                   '  THEN PERC.ID_PERSONA_ROL' ||
                   '  ELSE NULL ' ||
                   Lv_End ||
                   'AS ID_PERSONA_ROL_MRC, ' ||

                   Lv_Case||
                   q'[  WHEN SERV.FRECUENCIA_PRODUCTO <> 1 OR SERV.FRECUENCIA_PRODUCTO IS NULL  OR PROD.SUBGRUPO = 'INSTALACION' OR PROD.CODIGO_PRODUCTO IN ('TRASTN', 'REUTN') ]'||
                   '  THEN PERC.ID_PERSONA_ROL' ||
                   '  ELSE NULL ' ||
                   Lv_End ||
                   'AS ID_PERSONA_ROL_NRC, ' ||

                     Lv_Case ||
                     q'[  WHEN ((SERV.FRECUENCIA_PRODUCTO = 1  AND PROD.SUBGRUPO <> 'INSTALACION' AND (IDSC2.VALOR <>'NRC' OR IDSC2.VALOR IS NULL) AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN') ) OR (IDSC2.VALOR ='MRC')) ]'||
                        Lv_Then     ||
                          Lv_Case   || 
                       q'[  WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('FAC','FACP') THEN ]' ||
                     '        ROUND( (DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE) ,2)' ||
                          Lv_ElseCero ||
                          Lv_End      ||
                        Lv_ElseCero   ||
                     Lv_End           ||
                     'AS FAC_MRC, '   ||
                     
                     Lv_Case ||
                     q'[  WHEN (SERV.FRECUENCIA_PRODUCTO = 1  AND PROD.SUBGRUPO <> 'INSTALACION' AND PROD.GRUPO IN ('INTERNET Y DATOS','WIFI','IRU','NETLIFE') AND (IDSC2.VALOR <>'NRC' OR IDSC2.VALOR IS NULL) AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN')) OR IDSC2.VALOR ='MRC' ]'||
                        Lv_Then     ||
                          Lv_Case   || 
                       q'[  WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('FAC','FACP') THEN ]' ||
                     '        ROUND( (DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE) ,2)' ||
                          Lv_ElseCero ||
                          Lv_End      ||
                        Lv_ElseCero   ||
                     Lv_End           ||
                     'AS FAC_MRCID, '   ||

                     Lv_Case ||
                     q'[  WHEN (SERV.FRECUENCIA_PRODUCTO = 1  AND PROD.SUBGRUPO <> 'INSTALACION' AND PROD.GRUPO NOT IN ('INTERNET Y DATOS','WIFI','IRU','NETLIFE') AND (IDSC2.VALOR <>'NRC' OR IDSC2.VALOR IS NULL) AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN')) OR IDSC2.VALOR ='MRC' ]'||
                        Lv_Then     ||
                          Lv_Case   || 
                       q'[  WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('FAC','FACP') THEN ]' ||
                     '        ROUND( (DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE) ,2)' ||
                          Lv_ElseCero ||
                          Lv_End      ||
                        Lv_ElseCero   ||
                     Lv_End           ||
                     'AS FAC_MRCBS, '   ||

                     Lv_Case   ||
                       Lv_When ||
                     q'[ (((SERV.FRECUENCIA_PRODUCTO <> 1 OR SERV.FRECUENCIA_PRODUCTO IS NULL OR PROD.SUBGRUPO = 'INSTALACION') AND (IDSC2.VALOR <>'MRC' OR IDSC2.VALOR IS NULL)) OR (IDSC2.VALOR ='NRC') OR PROD.CODIGO_PRODUCTO IN ('TRASTN', 'REUTN')) OR (IDSC2.VALOR ='NRC') ]'||
                       Lv_Then        ||
                          Lv_Case     ||
                    q'[     WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('FAC','FACP') THEN ]' ||
                     '        ROUND( (DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE), 2) '|| 
                          Lv_ElseCero ||
                          Lv_End      ||
                       Lv_ElseCero    ||
                     Lv_End           ||
                     'AS FAC_NRC, '   ||

                     Lv_Case    ||
                       Lv_When  ||
                     q'[   SERV.FRECUENCIA_PRODUCTO = 1 AND PROD.SUBGRUPO <> 'INSTALACION' AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN') ]'||
                         Lv_Then   ||
                           Lv_Case ||
                    q'[      WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('NC') THEN ]'||
                     '         ROUND( (((DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE)) * -1), 2 )'||
                             Lv_ElseCero ||
                           Lv_End        ||
                         Lv_ElseCero     ||
                     Lv_End              ||
                     ' AS NC_MRC, '      ||
                     
                     Lv_Case    ||
                       Lv_When  ||
                     q'[   SERV.FRECUENCIA_PRODUCTO = 1 AND PROD.SUBGRUPO <> 'INSTALACION' AND PROD.GRUPO ='INTERNET Y DATOS' AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN')]'||
                         Lv_Then   ||
                           Lv_Case ||
                    q'[      WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('NC') THEN ]'||
                     '         ROUND( (((DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE)) * -1), 2 )'||
                             Lv_ElseCero ||
                           Lv_End        ||
                         Lv_ElseCero     ||
                     Lv_End              ||
                     ' AS NC_MRCID, '      ||
                     
                     Lv_Case    ||
                       Lv_When  ||
                     q'[   SERV.FRECUENCIA_PRODUCTO = 1 AND PROD.SUBGRUPO <> 'INSTALACION' AND PROD.GRUPO !='INTERNET Y DATOS' AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN')]'||
                         Lv_Then   ||
                           Lv_Case ||
                    q'[      WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('NC') THEN ]'||
                     '         ROUND( (((DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE)) * -1), 2 )'||
                             Lv_ElseCero ||
                           Lv_End        ||
                         Lv_ElseCero     ||
                     Lv_End              ||
                     ' AS NC_MRCBS, '      ||

                    Lv_Case ||
                    q'[  WHEN SERV.FRECUENCIA_PRODUCTO <> 1 OR SERV.FRECUENCIA_PRODUCTO IS NULL  OR PROD.SUBGRUPO = 'INSTALACION' OR PROD.CODIGO_PRODUCTO IN ('TRASTN', 'REUTN') ]' ||
                       Lv_Then   ||
                         Lv_Case ||
                   q'[     WHEN TDOC.CODIGO_TIPO_DOCUMENTO in ('NC') THEN ]' ||
                    '        ROUND( (((DOCD.PRECIO_VENTA_FACPRO_DETALLE * DOCD.CANTIDAD) - (DOCD.DESCUENTO_FACPRO_DETALLE)) * -1), 2) ' ||
                         Lv_ElseCero ||
                         Lv_End      ||
                       Lv_ElseCero   ||
                    Lv_End           ||
                    'AS NC_NRC ';

        Lv_From :=  ' FROM ' ||
                    '  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DOCD ' ||
                    '  JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB DOC ON DOC.ID_DOCUMENTO = DOCD.DOCUMENTO_ID ' ||
                    '  JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC ON TDOC.ID_TIPO_DOCUMENTO = DOC.TIPO_DOCUMENTO_ID ' || 
                    '  JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD ON DOCD.PRODUCTO_ID = PROD.ID_PRODUCTO ' ||
                    '  JOIN DB_COMERCIAL.INFO_PUNTO PTO ON DOC.PUNTO_ID = PTO.ID_PUNTO ' ||
                    '  JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFI ON OFI.ID_OFICINA = DOC.OFICINA_ID ' || 
                    '  JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP ON EMP.COD_EMPRESA = OFI.EMPRESA_ID ' ||
                    '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERC ON PERC.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID ' ||
                    '  LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SERV ON SERV.ID_SERVICIO = DOCD.SERVICIO_ID ' ||
                    '  JOIN DB_COMERCIAL.INFO_PERSONA P ON P.ID_PERSONA = PERC.PERSONA_ID ' ||
                    '  JOIN DB_COMERCIAL.INFO_PERSONA PERS ON PERS.LOGIN = PTO.USR_VENDEDOR ' ||
                    '  JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO TNEG ON PTO.TIPO_NEGOCIO_ID = TNEG.ID_TIPO_NEGOCIO ' ||
                    '  LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC ON cast(DOC.ID_DOCUMENTO as VARCHAR2(20))=IDSC.VALOR '||
                                                                          ' AND IDSC.CARACTERISTICA_ID = '|| Lv_Factura_Caract ||
                                                                        q'[ AND IDSC.ESTADO = 'Aprobada'  ]' ||
                    '  LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC2 ON IDSC2.DETALLE_SOLICITUD_ID=IDSC.DETALLE_SOLICITUD_ID '||
                                                                          ' AND IDSC2.CARACTERISTICA_ID = '|| Lv_Fac_Det_Caract ||
                                                                        q'[ AND IDSC2.ESTADO = 'Aprobada'  ]' ;                                                        
        Lv_Where := 'WHERE ';
        Lv_Where := Lv_Where || q'[     TDOC.CODIGO_TIPO_DOCUMENTO in ('FAC','FACP','NC')]';
		--
        IF Pv_Tipo = 'MRC' THEN
		  Lv_Where := Lv_Where || 
			' AND (' ||
				q'[ (SERV.FRECUENCIA_PRODUCTO = 1  ]' ||
				q'[ AND PROD.SUBGRUPO <> 'INSTALACION' ]' ||
				q'[ AND (IDSC2.VALOR <>'NRC' OR IDSC2.VALOR IS NULL) ]' ||
				q'[ AND PROD.CODIGO_PRODUCTO NOT IN ('TRASTN', 'REUTN')) ]' ||
			q'[ OR (IDSC2.VALOR ='MRC')) ]';
        ELSIF Pv_Tipo = 'NRC' THEN 
		  Lv_Where := Lv_Where ||
		    ' AND ( ' ||
				q'[ ((SERV.FRECUENCIA_PRODUCTO <> 1  ]'	||
				q'[ OR SERV.FRECUENCIA_PRODUCTO IS NULL ]' ||
				q'[ OR PROD.SUBGRUPO = 'INSTALACION') ]' ||
				q'[ AND (IDSC2.VALOR <>'MRC' OR IDSC2.VALOR IS NULL)) ]' ||
			q'[ OR (IDSC2.VALOR ='NRC') OR PROD.CODIGO_PRODUCTO IN ('TRASTN', 'REUTN')) ]';
        END IF;
        --
        IF Pv_CargoPersona = 'SUBGERENTE' THEN
          Lv_Where := Lv_Where ||
                      '       AND PTO.USR_VENDEDOR in( ' ||
                      '                          SELECT IPE_S.LOGIN FROM DB_COMERCIAL.INFO_PERSONA IPE_S  ' ||
                      '                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ' ||
                      '                          WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol '  ||
                      '                        )';
        ELSE
          IF Pv_CargoPersona = 'GERENTE_VENTAS' THEN
            Lv_Where := Lv_Where ||'';
          ELSE
              Lv_Where := Lv_Where ||
                          '       AND PTO.USR_VENDEDOR in( ' ||
                          '                          SELECT IPE_S.LOGIN FROM DB_COMERCIAL.INFO_PERSONA IPE_S  ' ||
                          '                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ' ||
                          '                          WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol '  ||
                          '                        )'; 

          END IF;
        END IF;
        --
        IF Pv_TipoConsulta <> 'CUMPLIMIENTO_NRC' AND Pv_TipoConsulta <> 'TOTALIZADO_TRIMESTRAL' AND Pv_TipoConsulta <> 'DETALLADO_TRIMESTRAL' AND Pv_TipoConsulta <> 'DETALLADO_EXCELT' THEN        
          Lv_Where := Lv_Where ||
                      '       AND DOC.NUMERO_FACTURA_SRI IS NOT NULL ' ||
                      '       AND DOC.NUMERO_AUTORIZACION IS NOT NULL ' ||
                      '       AND EMP.PREFIJO = :Pv_PrefijoEmpresa ' ||
                     q'[      AND DOC.ESTADO_IMPRESION_FACT not in ('Anulado') ]' ||
                      '       AND EXTRACT(YEAR FROM DOC.FE_EMISION) = :Lv_anio ' ||
                      '       AND EXTRACT(MONTH FROM DOC.FE_EMISION) = :Lv_mes '
                      ;
        END IF;
      --
      
        IF Pv_TipoConsulta = 'TOTALIZADO_TRIMESTRAL' OR Pv_TipoConsulta = 'DETALLADO_TRIMESTRAL' OR Pv_TipoConsulta = 'DETALLADO_EXCELT' THEN
        Ln_Trimestre:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'Q', 'nls_date_language=spanish'));
        --
        IF Ln_Trimestre = '1' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='enero' THEN
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='febrero' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;
          --
          ELSIF Lv_FechaIni ='marzo' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
          --
        ELSIF Ln_Trimestre = '2' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='abril' THEN
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='mayo' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;          
          --
          ELSIF Lv_FechaIni ='junio' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
        --
        ELSIF Ln_Trimestre = '3' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='julio' THEN
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='agosto' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;
          --
          ELSIF Lv_FechaIni ='septiembre' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
        --
        ELSIF Ln_Trimestre = '4' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='octubre' THEN          
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='noviembre' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;          
          --
          ELSIF Lv_FechaIni ='diciembre' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
        END IF;
        Lv_FechaIni:=to_char(TO_DATE(Lv_FechaIni,'dd-mm-yy'),'dd-mm-yyyy');
        Lv_FechaFin:=to_char(TO_DATE(Lv_FechaFin,'dd-mm-yy'),'dd-mm-yyyy');

        Lv_FechaIni    := EXTRACT(MONTH FROM TO_DATE(Lv_FechaIni,'dd-mm-yyyy'));
        Lv_FechaFin    := EXTRACT(MONTH FROM TO_DATE(Lv_FechaFin,'dd-mm-yyyy'));

	      Lv_Where := Lv_Where ||
                      '       AND DOC.NUMERO_FACTURA_SRI IS NOT NULL ' ||
                      '       AND DOC.NUMERO_AUTORIZACION IS NOT NULL ' ||
                      '       AND EMP.PREFIJO = :Pv_PrefijoEmpresa ' ||
                     q'[      AND DOC.ESTADO_IMPRESION_FACT not in ('Anulado') ]' ||
                      '       AND EXTRACT(YEAR FROM DOC.FE_EMISION) = :Lv_anio ' ||
		              '	      AND EXTRACT(MONTH FROM DOC.FE_EMISION) BETWEEN ' ||Lv_FechaIni ||' AND ' ||Lv_FechaFin 
                      ;
      END IF;
      
      --
      IF Pv_TipoConsulta = 'DETALLADO' OR Pv_TipoConsulta = 'DETALLADO_EXCEL' OR Pv_TipoConsulta = 'DETALLADO_TRIMESTRAL' OR Pv_TipoConsulta = 'DETALLADO_EXCELT' THEN
        -- COSTO QUERY: 332
        Lv_Query := Lv_Select || Lv_From || Lv_Where || Lv_GroupBy;
      END IF;
      IF Pv_TipoConsulta = 'TOTALIZADO' OR Pv_TipoConsulta = 'TOTALIZADO_TRIMESTRAL' THEN
        Lv_Query :='SELECT TFAC.MES, COUNT(TFAC.ID_PERSONA_ROL) CLIENTES, COUNT(TFAC.ID_PERSONA_ROL_MRC) CLIENTES_MRC, '||
                   '       COUNT(TFAC.ID_PERSONA_ROL_NRC) CLIENTES_NRC, SUM(TFAC.FAC_MRC) AS FAC_MRC, '||
                   '       SUM(TFAC.FAC_NRC) AS FAC_NRC, SUM(TFAC.NC_MRC) AS NC_MRC, SUM(TFAC.NC_NRC) AS NC_NRC, ' ||
                   '       SUM(TFAC.FAC_MRCID) AS FAC_MRCID, SUM(TFAC.NC_MRCID) AS NC_MRCID, ' ||
                   '       SUM(TFAC.FAC_MRCBS) AS FAC_MRCBS, SUM(TFAC.NC_MRCBS) AS NC_MRCBS ' ||
                   ' FROM '|| 
                   '( '||
                   '  SELECT TFACC.MES, TFACC.ID_PERSONA_ROL, TFACC.ID_PERSONA_ROL_MRC, TFACC.ID_PERSONA_ROL_NRC, SUM(TFACC.FAC_MRC) AS FAC_MRC, ' || 
                   '         SUM(TFACC.FAC_NRC) AS FAC_NRC, SUM(TFACC.NC_MRC) AS NC_MRC, SUM(TFACC.NC_NRC) AS NC_NRC, '||
                   '         SUM(TFACC.FAC_MRCID) AS FAC_MRCID, SUM(TFACC.NC_MRCID) AS NC_MRCID, '||
                   '         SUM(TFACC.FAC_MRCBS) AS FAC_MRCBS, SUM(TFACC.NC_MRCBS) AS NC_MRCBS  '||
                   '  FROM ' ||
                   '  ( ' ||
                         Lv_Select || Lv_From || Lv_Where ||
                   '  )TFACC ' ||
                   '  GROUP BY  MES, ID_PERSONA_ROL, ID_PERSONA_ROL_MRC, ID_PERSONA_ROL_NRC ' ||
                   ')TFAC '||
                   ' GROUP BY TFAC.MES '||
                   ' ORDER BY TFAC.MES ';
      END IF;
      --
      IF Pv_TipoConsulta = 'CUMPLIMIENTO_MRC' THEN
        Lv_MesBase  := TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
        Lv_AnioBase := TRIM(to_char(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'),'YYYY'));

        Lv_From := Lv_From ||
                   ' JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '||
                   'ON APD.VALOR5=PTO.USR_VENDEDOR '||
                   'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC '||
                   'ON APC.ID_PARAMETRO=APD.PARAMETRO_ID '||
                   'LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET APDMETA '||
                   'ON APDMETA.VALOR5=APD.VALOR5 ';
        Lv_Where := Lv_Where ||
                    ' AND APC.NOMBRE_PARAMETRO =:Lv_NombreParametro '||
                    'AND APC.MODULO           =:Lv_Modulo '||
                    'AND APC.PROCESO          =:Lv_Proceso '||
                    'AND APC.ESTADO           =:Lv_EstadoActivo '||
                    'AND APD.DESCRIPCION      =:Lv_DescripcionBase '||
                    'AND APDMETA.DESCRIPCION  =:Lv_DescripcionMeta '||
                    'AND LOWER(APD.VALOR1)    = LOWER(:Lv_MesBase) '||
                    'AND APD.VALOR2           =:Lv_AnioBase '||
                    'AND APD.ESTADO           =:Lv_EstadoActivo '||
                    'AND LOWER(APDMETA.valor6)= LOWER(TRIM(TO_CHAR(to_Date(cast(:Pd_FechaInicio as date),''dd-mm-yyyy''), ''month'', ''nls_date_language=spanish''))) '||
                    'AND APDMETA.valor7       =:Lv_AnioBase '||
                    'AND APDMETA.ESTADO       =:Lv_EstadoActivo ';
        Lv_Query :='SELECT INITCAP(TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''month'', ''nls_date_language=spanish''))) AS MES, ' ||
                           '       TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''yyyy'', ''nls_date_language=spanish'')) AS ANIO, ' ||                    
                   ' TFAC.USR_VENDEDOR, TFAC.BASE, TFAC.META, TFAC.MRC AS FACTURACION, ROUND(SUM(TFAC.MRC -TFAC.BASE-TFAC.META),2) AS DIF_PRESUPUESTO, ROUND(SUM(TFAC.MRC-TFAC.BASE)/(TFAC.META)*100,2) AS CUMPLIMIENTO_META,TFAC.BASEID, '||
                   ' TFAC.MRCID AS FACTURACIONID, TFAC.BASEBS, TFAC.METAID, TFAC.METABS, TFAC.MRCBS AS FACTURACIONBS, ROUND(SUM(TFAC.MRCID -TFAC.BASEID-TFAC.METAID),2) AS DIF_PRESUPUESTOID,  '||
                   ' ROUND(SUM(TFAC.MRCBS -TFAC.BASEBS-TFAC.METABS),2) AS DIF_PRESUPUESTOBS, DECODE(TFAC.METABS,0,0, ROUND(SUM(TFAC.MRCBS-TFAC.BASEBS)/(TFAC.METABS)*100,2)) AS CUMPLIMIENTO_METABS, '||
                   ' DECODE(TFAC.METAID,0,0, ROUND(SUM(TFAC.MRCID-TFAC.BASEID)/(TFAC.METAID)*100,2)) AS CUMPLIMIENTO_METAID '||
                   ' FROM '||
                   '( '||
                   '   SELECT TFACC.USR_VENDEDOR, ROUND(SUM(TFACC.FAC_MRC)+SUM(TFACC.NC_MRC),2) AS MRC, ROUND(SUM(TFACC.FAC_NRC)+SUM(TFACC.NC_NRC),2) AS NRC, '||
                   '     TFACC.BASE, TFACC.META, ROUND(SUM(TFACC.FAC_MRCID)+SUM(TFACC.NC_MRCID),2) AS MRCID, TFACC.BASEID, TFACC.BASEBS, TFACC.METAID, TFACC.METABS, ROUND(SUM(TFACC.FAC_MRCBS)+SUM(TFACC.NC_MRCBS),2) AS MRCBS '||
                   '   FROM '||
                   '   ( '||
                         Lv_Select || 
                   ',  APDMETA.VALOR3 AS META, APD.VALOR3 AS BASE,NVL(APD.VALOR6,0) AS BASEID, NVL(APD.VALOR7,0) AS BASEBS,DECODE (NVL(APDMETA.VALOR1,0),''MRC'',0,APDMETA.VALOR1)AS METAID, DECODE (NVL(APDMETA.VALOR2,0),''NRC'',0,APDMETA.VALOR2)AS METABS '||
                         Lv_From || Lv_Where ||
                   '    )TFACC '||
                   ' GROUP BY TFACC.USR_VENDEDOR,TFACC.BASE,TFACC.META,TFACC.BASEID,TFACC.BASEBS,TFACC.METAID, TFACC.METABS '||
                   ')TFAC '||
                   'GROUP BY TFAC.USR_VENDEDOR, TFAC.BASE, TFAC.META, TFAC.MRC,TFAC.BASEID, TFAC.MRCID, TFAC.BASEBS, TFAC.METAID, TFAC.MRCBS, TFAC.METABS '||
                   'ORDER BY TFAC.USR_VENDEDOR ';
      END IF;      
      --
      IF Pv_TipoConsulta = 'CUMPLIMIENTO_NRC' THEN
        Ln_Trimestre:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'Q', 'nls_date_language=spanish'));
        --
        IF Ln_Trimestre = '1' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='enero' THEN
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='febrero' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;
          --
          ELSIF Lv_FechaIni ='marzo' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
          --
        ELSIF Ln_Trimestre = '2' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='abril' THEN
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='mayo' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;          
          --
          ELSIF Lv_FechaIni ='junio' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
        --
        ELSIF Ln_Trimestre = '3' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='julio' THEN
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='agosto' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;
          --
          ELSIF Lv_FechaIni ='septiembre' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
        --
        ELSIF Ln_Trimestre = '4' THEN
          Lv_FechaIni:=TRIM(TO_CHAR(to_Date(cast(Pd_FechaInicio as date),'dd-mm-yyyy'), 'month', 'nls_date_language=spanish'));
          --
          IF Lv_FechaIni ='octubre' THEN          
            Lv_FechaIni:=to_char(TO_DATE(Lv_mes,'mm'),'dd-mm-yyyy');          
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+1)-1;
          --
          ELSIF Lv_FechaIni ='noviembre' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-1);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+2)-1;          
          --
          ELSIF Lv_FechaIni ='diciembre' THEN
            Lv_FechaIni:=ADD_MONTHS(TO_DATE(Lv_mes,'mm'),-2);
            Lv_FechaFin:=ADD_MONTHS(TO_DATE(Lv_FechaIni,'dd-mm-yyyy'),+3)-1;
          END IF;
        END IF;
        Lv_FechaIni:=to_char(TO_DATE(Lv_FechaIni,'dd-mm-yy'),'dd-mm-yyyy');
        Lv_FechaFin:=to_char(TO_DATE(Lv_FechaFin,'dd-mm-yy'),'dd-mm-yyyy');

        Lv_FechaIni    := EXTRACT(MONTH FROM TO_DATE(Lv_FechaIni,'dd-mm-yyyy'));
        Lv_FechaFin    := EXTRACT(MONTH FROM TO_DATE(Lv_FechaFin,'dd-mm-yyyy'));

        Lv_From := Lv_From ||
                   'JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD '||
                   'ON APD.VALOR5=PTO.USR_VENDEDOR '||
                   'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC '||
                   'ON APC.ID_PARAMETRO=APD.PARAMETRO_ID ';

        Lv_Where := Lv_Where ||
                    '       AND DOC.NUMERO_FACTURA_SRI IS NOT NULL ' ||
                    '       AND DOC.NUMERO_AUTORIZACION IS NOT NULL ' ||
                    '       AND EMP.PREFIJO = :Pv_PrefijoEmpresa ' ||
                   q'[      AND DOC.ESTADO_IMPRESION_FACT not in ('Anulado') ]' ||
                    'AND EXTRACT(YEAR FROM DOC.FE_EMISION)  = :Lv_anio '||
                    'AND EXTRACT(MONTH FROM DOC.FE_EMISION) BETWEEN :Lv_FechaIni AND :Lv_FechaFin '||
                    'AND APC.NOMBRE_PARAMETRO =:Lv_NombreParametro '||
                    'AND APC.MODULO           =:Lv_Modulo '||
                    'AND APC.PROCESO          =:Lv_Proceso '||
                    'AND APC.ESTADO           =:Lv_EstadoActivo '||
                    'AND APD.DESCRIPCION      =:Lv_DescripcionMeta '||
                    'AND LOWER(APD.valor6)= LOWER(TRIM(TO_CHAR(to_Date(cast(:Pd_FechaInicio as date),''dd-mm-yyyy''), ''month'', ''nls_date_language=spanish''))) '||
                    'AND APD.valor7           =:Lv_anio '||
                    'AND APD.ESTADO           =:Lv_EstadoActivo ';

        Lv_Query :='SELECT INITCAP(TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''month'', ''nls_date_language=spanish''))) AS MES, ' ||
                   '       TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''yyyy'', ''nls_date_language=spanish'')) AS ANIO, ' ||

                  '       TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''Q'', ''nls_date_language=spanish'')) AS TRIMESTRE, ' ||
                  '       CASE ' ||
                  '         WHEN TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''Q'', ''nls_date_language=spanish'')) = ''1'' THEN ' ||
                  '           ''ENERO - MARZO''' ||
                  '         WHEN TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''Q'', ''nls_date_language=spanish'')) = ''2'' THEN ' ||
                  '           ''ABRIL - JUNIO''' ||
                  '         WHEN TRIM(TO_CHAR(cast(:Pd_FechaInicio as date), ''Q'', ''nls_date_language=spanish'')) = ''3'' THEN ' ||
                  '           ''JULIO - SEPTIEMBRE''' || '         ELSE ' ||
                  '           ''OCTUBRE - DICIEMBRE''' ||
                  '       END AS MESES_TRIMESTRE, ' ||                  
                   '  TFAC.USR_VENDEDOR, TFAC.META, TFAC.NRC AS FACTURACION, SUM(TFAC.NRC-TFAC.META) AS DIF_PRESUPUESTO, ROUND(SUM(TFAC.NRC/TFAC.META)*100,2) AS CUMPLIMIENTO_META '||
                   'FROM '||
                   '( '||
                   '   SELECT TFACC.USR_VENDEDOR, ROUND(SUM(TFACC.FAC_NRC)+SUM(TFACC.NC_NRC),2) AS NRC, TFACC.META '||
                   '   FROM '||
                   '   ( '||
                         Lv_Select || 
                   ', APD.VALOR4 AS META '||
                         Lv_From || Lv_Where ||
                   '    )TFACC '||
                   ' GROUP BY TFACC.USR_VENDEDOR, TFACC.META '||
                   ')TFAC '||
                   'GROUP BY TFAC.USR_VENDEDOR, TFAC.META, TFAC.NRC '||
                   'ORDER BY TFAC.USR_VENDEDOR ';
      END IF;            
      --
      IF Pv_TipoConsulta = 'AGRUPADO' THEN
        Lv_Query :='  SELECT TFACC.MES, TFACC.CLIENTE, TFACC.USR_VENDEDOR, TFACC.ID_PERSONA_ROL, TFACC.ID_PERSONA_ROL_MRC, TFACC.ID_PERSONA_ROL_NRC, ' || 
                   '         SUM(TFACC.FAC_MRC) AS FAC_MRC, SUM(TFACC.FAC_NRC) AS FAC_NRC, SUM(TFACC.NC_MRC)  AS NC_MRC, SUM(TFACC.NC_NRC)  AS NC_NRC '||
                   '  FROM ' ||
                   '  ( ' ||
                         Lv_Select || Lv_From || Lv_Where ||
                   '  )TFACC ' ||
                   '  GROUP BY TFACC.CLIENTE, TFACC.USR_VENDEDOR, TFACC.MES, TFACC.ID_PERSONA_ROL, TFACC.ID_PERSONA_ROL_MRC, TFACC.ID_PERSONA_ROL_NRC '||
                   'ORDER BY TFACC.USR_VENDEDOR';
      END IF; 
      --
      IF Pv_TipoConsulta = 'POR_FACTURAR' THEN
        Lv_Where := Lv_Where ||
                      '       AND serv.estado not in ''Cancel'' ';
        Lv_Query :='  SELECT TFACC.MES, TFACC.CLIENTE, TFACC.USR_VENDEDOR, TFACC.ID_PERSONA_ROL, TFACC.ID_PERSONA_ROL_MRC, TFACC.ID_PERSONA_ROL_NRC, ' || 
                   '         SUM(TFACC.FAC_MRC) AS FAC_MRC, SUM(TFACC.FAC_NRC) AS FAC_NRC, SUM(TFACC.NC_MRC)  AS NC_MRC, SUM(TFACC.NC_NRC)  AS NC_NRC '||
                   '  FROM ' ||
                   '  ( ' ||
                         Lv_Select || Lv_From || Lv_Where ||
                   '  )TFACC ' ||
                   '  GROUP BY TFACC.CLIENTE, TFACC.USR_VENDEDOR, TFACC.MES, TFACC.ID_PERSONA_ROL, TFACC.ID_PERSONA_ROL_MRC, TFACC.ID_PERSONA_ROL_NRC '||
                   'ORDER BY TFACC.USR_VENDEDOR';
      END IF;         
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_PrefijoEmpresa',   Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_anio', Lv_anio);
      --
      IF Pv_TipoConsulta <> 'CUMPLIMIENTO_NRC' AND Pv_TipoConsulta <> 'TOTALIZADO_TRIMESTRAL' AND Pv_TipoConsulta <> 'DETALLADO_TRIMESTRAL' AND Pv_TipoConsulta <> 'DETALLADO_EXCELT' THEN
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_mes', Lv_mes);
      END IF;      
      --
      IF Pv_CargoPersona = 'SUBGERENTE' OR Pv_CargoPersona = 'VENDEDOR' OR Pv_CargoPersona IS NULL  THEN
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_IdPersonaEmpresaRol', Pv_IdPersonaEmpresaRol);
      END IF;
      --
      IF Pv_TipoConsulta = 'CUMPLIMIENTO_MRC' THEN
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_NombreParametro', Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EstadoActivo', Lv_EstadoActivo);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_DescripcionBase', Lv_DescripcionBase);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_DescripcionMeta', Lv_DescripcionMeta);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_MesBase', Lv_MesBase);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_AnioBase', Lv_anio);

      END IF;
      IF Pv_TipoConsulta = 'CUMPLIMIENTO_NRC' THEN
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_FechaIni', Lv_FechaIni);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_FechaFin', Lv_FechaFin);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_NombreParametro', Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EstadoActivo', Lv_EstadoActivo);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_DescripcionMeta', Lv_DescripcionMeta);
      END IF;      
      --
      Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_InformacionDashboard := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    --
    --
    IF Pv_TipoConsulta = 'DETALLADO_EXCEL' OR Pv_TipoConsulta = 'DETALLADO_EXCELT' THEN
      Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_C');
      Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
      Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio, Lv_NombreArchivo, 'w', 3000);
      --
      utl_file.put_line(Lfile_Archivo, 'FE_EMISION'||Lv_Delimitador 
                                       ||'IDENTIFICACION_CLIENTE'||Lv_Delimitador 
                                       ||'CLIENTE'||Lv_Delimitador 
                                       ||'LOGIN'||Lv_Delimitador 
                                       ||'PRODUCTO'||Lv_Delimitador 
                                       ||'VENDEDOR'||Lv_Delimitador 
                                       ||'TIPO'||Lv_Delimitador
                                       ||'LINEA NEGOCIO'||Lv_Delimitador 
                                       ||'GRUPO'||Lv_Delimitador 
                                       ||'SUBGRUPO'||Lv_Delimitador 
                                       ||'FACTURAS MRC'||Lv_Delimitador 
                                       ||'FACTURAS NRC'||Lv_Delimitador 
                                       ||'NC MRC'||Lv_Delimitador 
                                       ||'NC NRC'||Lv_Delimitador );
      --
      LOOP
        --
        FETCH Pr_InformacionDashboard INTO Lc_InformacionDashboard;
        EXIT WHEN Pr_InformacionDashboard%NOTFOUND;
        --
        --
        Lv_RegistroAdicional := NULL;
        --
        --
        utl_file.put_line(Lfile_Archivo, Lc_InformacionDashboard.FE_EMISION||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.IDENTIFICACION_CLIENTE||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.CLIENTE||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.LOGIN||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.DESCRIPCION_PRODUCTO||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.ASESOR||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.FILTRO||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.LINEA_NEGOCIO||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.GRUPO||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.SUBGRUPO||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.FAC_MRC||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.FAC_NRC||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.NC_MRC||Lv_Delimitador 
                                         ||Lc_InformacionDashboard.NC_NRC||Lv_Delimitador );
        --
      END LOOP;
      --
      UTL_FILE.fclose(Lfile_Archivo);
      --
      DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) );
      --
      DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH( Lv_Remitente, 
                                                 Lv_Destinatario,
                                                 Lv_Asunto, 
                                                 Lv_Cuerpo, 
                                                 Lv_Directorio,
                                                 Lv_NombreArchivoZip );
      --
      UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
      --
      --Pv_MensajeRespuesta := 'Reporte generado y enviado al mail exitosamente';
      --
    END IF;
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Lv_MensajeError         := 'Error al migrar la informacion para reporte INFO_REPORTE_ASESORES.';
    --
    BI_FINANCIERO.BFNKG_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'BFNKG_CONSULTS.P_GET_INFO_FACTURACION_VENDEDOR', 
                                          Lv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'BI_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    --
  WHEN OTHERS THEN
    Lv_MensajeError     := 'Error al migrar la informacion para reporte INFO_REPORTE_ASESORES.';
    ROLLBACK;
    BI_FINANCIERO.BFNKG_UTIL.INSERT_ERROR('Telcos+', 
                                         'BFNKG_CONSULTS.P_GET_INFO_FACTURACION_VENDEDOR', 
                                         Lv_MensajeError || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'BI_FINANCIERO'),
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFO_DET_FACT_ASESOR;
  --
  --
  --
  PROCEDURE P_ENVIA_CUMPLIMIENTO_VEND(
    Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_TipoConsulta        IN VARCHAR2,
    Pv_CargoPersona        IN VARCHAR2,
    Pv_Tipo                IN VARCHAR2,
    Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Pd_FechaInicio         IN TIMESTAMP,
    Pv_EmailUsrSesion      IN VARCHAR2)
    IS
      --
      Lv_RegistroAdicional VARCHAR2(1000);
      Lv_Delimitador       VARCHAR2(1)   := ';';
      Lv_Remitente         VARCHAR2(20)  := 'telcos@telconet.ec';
      Lv_Destinatario      VARCHAR2(100) := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
      Lv_Asunto            VARCHAR2(300) := 'Notificacion CUMPLIMIENTO DE PRESUPUESTO ';
      Lfile_Archivo utl_file.file_type;
      Lv_Directorio        VARCHAR2(50)  := 'DIR_REPGERENCIA';
      Lv_NombreArchivo     VARCHAR2(100) := 'CumplimientoDePresupuesto_';
      Lv_Gzip              VARCHAR2(100);
      Lv_NombreArchivoZip  VARCHAR2(100);
      Lc_GetAliasPlantilla DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
      Lv_Cuerpo            VARCHAR2(9999);
      Lv_MensajeError      VARCHAR2(4000);
      --
      Lv_TipoConsulta      VARCHAR2(100);
      Lv_FechaInicio       VARCHAR2(300);
      Lv_Mes               VARCHAR2(100);
      Ln_Anio              NUMBER;
      Lv_Trimestre         VARCHAR2(100);
      Lv_MesesTrimestre    VARCHAR2(100);
      Lv_Vendedor          VARCHAR2(100);
      Ln_Base              NUMBER;
      Ln_Meta              NUMBER;
      Ln_Facturacion       NUMBER;
      Ln_DifPresupuesto    NUMBER;
      Ln_CumpMeta          NUMBER;
      Ln_BaseID            NUMBER;
      Ln_MetaID            NUMBER;
      Ln_FacturacionID     NUMBER;
      Ln_DifPresupuestoID  NUMBER;
      Ln_CumpMetaID        NUMBER;
      Ln_BaseBS            NUMBER;
      Ln_MetaBS            NUMBER;
      Ln_FacturacionBS     NUMBER;
      Ln_DifPresupuestoBS  NUMBER;
      Ln_CumpMetaBS        NUMBER;
      Lr_FactAsesor Sys_Refcursor;
      Lr_CumpAsesor Sys_Refcursor;
      --
    BEGIN
      --
      IF Pv_TipoConsulta    = 'EXPORTAR_MRC' OR Pv_TipoConsulta = 'EXPORTAR_MRCID' OR Pv_TipoConsulta  = 'EXPORTAR_MRCBS' THEN
        Lv_TipoConsulta    :='CUMPLIMIENTO_MRC';
      ELSIF Pv_TipoConsulta = 'EXPORTAR_NRC' THEN
        Lv_TipoConsulta    :='CUMPLIMIENTO_NRC';
      END IF;
      --
      IF Pv_TipoConsulta = 'EXPORTAR_MRCID' THEN
        Lv_Asunto           := Lv_Asunto || ' Internet/Datos';
      ELSIF Pv_TipoConsulta  = 'EXPORTAR_MRCBS' THEN
        Lv_Asunto           := Lv_Asunto || ' Business Solutions';
      END IF;
      --
      IF Pv_Tipo            IS NOT NULL THEN
        Lv_Asunto           := Lv_Asunto || ' (' || Pv_Tipo || ')';
        Lv_NombreArchivo    := 'CumplimientoDePresupuesto_'||Pv_Tipo||'_'|| Pv_PrefijoEmpresa || '.csv';
        Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
        Lv_NombreArchivoZip := Lv_NombreArchivo || '.gz';
      END IF;
      --
      BFNKG_CONSULTS.P_GET_INFO_DET_FACT_ASESOR ( Pv_PrefijoEmpresa,
                                                  'DETALLADO_EXCEL',
                                                  Pv_CargoPersona,
                                                  Pv_Tipo,
                                                  Pv_IdPersonaEmpresaRol,
                                                  Pd_FechaInicio,
                                                  Pv_EmailUsrSesion,
                                                  Lr_FactAsesor);
      --
      BFNKG_CONSULTS.P_GET_INFO_DET_FACT_ASESOR( Pv_PrefijoEmpresa, 
                                                 Lv_TipoConsulta, 
                                                 Pv_CargoPersona, 
                                                 Pv_Tipo, 
                                                 Pv_IdPersonaEmpresaRol, 
                                                 Pd_FechaInicio, 
                                                 Pv_EmailUsrSesion, 
                                                 Lr_CumpAsesor);
      --
      Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_C');
      Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
      Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio, Lv_NombreArchivo, 'w', 3000);
      --
      IF Lv_TipoConsulta ='CUMPLIMIENTO_MRC' THEN
        utl_file.put_line(Lfile_Archivo, 'MES'||Lv_Delimitador || 
                                         'ANIO'||Lv_Delimitador ||
                                         'VENDEDOR'||Lv_Delimitador || 
                                         'BASE'||Lv_Delimitador || 
                                         'META'||Lv_Delimitador || 
                                         'FACTURACION_MRC'||Lv_Delimitador || 
                                         'DIFERENCIAL_PRESUPUESTO'||Lv_Delimitador || 
                                         'CUMPLIMIENTO'||Lv_Delimitador);
        --
      ELSIF Lv_TipoConsulta ='CUMPLIMIENTO_NRC' THEN
        utl_file.put_line(Lfile_Archivo, 'MES'||Lv_Delimitador || 
                                         'ANIO'||Lv_Delimitador ||
                                          'Trimestre'||Lv_Delimitador ||
                                          'Meses_Trimestre'||Lv_Delimitador ||
                                          'VENDEDOR'||Lv_Delimitador || 
                                          'META'||Lv_Delimitador || 
                                          'FACTURACION_NRC'||Lv_Delimitador || 
                                          'DIFERENCIAL_PRESUPUESTO'||Lv_Delimitador || 
                                          'CUMPLIMIENTO'||Lv_Delimitador);
      END IF;
      --
      LOOP
        --
        IF Lv_TipoConsulta ='CUMPLIMIENTO_MRC' THEN
          FETCH Lr_CumpAsesor
          INTO Lv_Mes,
            Ln_Anio,
            Lv_Vendedor,
            Ln_Base,
            Ln_Meta,
            Ln_Facturacion,
            Ln_DifPresupuesto,
            Ln_CumpMeta,
            Ln_BaseID,
            Ln_FacturacionID,
            Ln_BaseBS,
            Ln_MetaID,
            Ln_MetaBS,
            Ln_FacturacionBS,
            Ln_DifPresupuestoID,
            Ln_DifPresupuestoBS,
            Ln_CumpMetaBS,
            Ln_CumpMetaID;
          --
        ELSIF Lv_TipoConsulta ='CUMPLIMIENTO_NRC' THEN
          FETCH Lr_CumpAsesor
          INTO Lv_Mes,
            Ln_Anio,
            Lv_Trimestre,
            Lv_MesesTrimestre,
            Lv_Vendedor,
            Ln_Meta,
            Ln_Facturacion,
            Ln_DifPresupuesto,
            Ln_CumpMeta;
        END IF;
        EXIT
      WHEN Lr_CumpAsesor%NOTFOUND;
        --
        Lv_RegistroAdicional := NULL;
        --
        IF Lv_TipoConsulta ='CUMPLIMIENTO_MRC' THEN
          IF Pv_TipoConsulta = 'EXPORTAR_MRC' THEN
            utl_file.put_line(Lfile_Archivo, Lv_Mes||Lv_Delimitador || 
                                           Ln_Anio||Lv_Delimitador ||
                                           Lv_Vendedor||Lv_Delimitador || 
                                           Ln_Base||Lv_Delimitador || 
                                           Ln_Meta||Lv_Delimitador || 
                                           Ln_Facturacion||Lv_Delimitador || 
                                           Ln_DifPresupuesto||Lv_Delimitador ||
                                           Ln_CumpMeta||Lv_Delimitador );
          ELSIF Pv_TipoConsulta = 'EXPORTAR_MRCID' THEN
            utl_file.put_line(Lfile_Archivo, Lv_Mes||Lv_Delimitador || 
                                           Ln_Anio||Lv_Delimitador ||
                                           Lv_Vendedor||Lv_Delimitador || 
                                           Ln_BaseID||Lv_Delimitador || 
                                           Ln_MetaID||Lv_Delimitador || 
                                           Ln_FacturacionID||Lv_Delimitador || 
                                           Ln_DifPresupuestoID||Lv_Delimitador ||
                                           Ln_CumpMetaID||Lv_Delimitador );
          
          ELSIF Pv_TipoConsulta  = 'EXPORTAR_MRCBS' THEN
            utl_file.put_line(Lfile_Archivo, Lv_Mes||Lv_Delimitador || 
                                           Ln_Anio||Lv_Delimitador ||
                                           Lv_Vendedor||Lv_Delimitador || 
                                           Ln_BaseBS||Lv_Delimitador || 
                                           Ln_MetaBS||Lv_Delimitador || 
                                           Ln_FacturacionBS||Lv_Delimitador || 
                                           Ln_DifPresupuestoBS||Lv_Delimitador ||
                                           Ln_CumpMetaBS||Lv_Delimitador );
          
          END IF;
          --
        ELSIF Lv_TipoConsulta ='CUMPLIMIENTO_NRC' THEN
          utl_file.put_line(Lfile_Archivo, Lv_Mes||Lv_Delimitador || 
                                           Ln_Anio||Lv_Delimitador ||
                                           Lv_Trimestre||Lv_Delimitador ||
                                           Lv_MesesTrimestre||Lv_Delimitador ||
                                           Lv_Vendedor||Lv_Delimitador || 
                                           Ln_Meta||Lv_Delimitador || 
                                           Ln_Facturacion||Lv_Delimitador || 
                                           Ln_DifPresupuesto||Lv_Delimitador ||
                                           Ln_CumpMeta||Lv_Delimitador );
        END IF;
        --
      END LOOP;
      --
      UTL_FILE.fclose(Lfile_Archivo);
      --
      DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) );
      --
      DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH( Lv_Remitente, Lv_Destinatario, Lv_Asunto, Lv_Cuerpo, Lv_Directorio, Lv_NombreArchivoZip );
      --
      UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
      --
      IF Lr_FactAsesor%ISOPEN THEN
        CLOSE Lr_FactAsesor;
      END IF;
      --
      IF Lr_CumpAsesor%ISOPEN THEN
        CLOSE Lr_CumpAsesor;
      END IF;
      --
      --
    EXCEPTION
      --
    WHEN OTHERS THEN
      Lv_MensajeError := 'Error al migrar la informacion para reporte INFO_REPORTE_ASESORES.';
      ROLLBACK;
      BI_FINANCIERO.BFNKG_UTIL.INSERT_ERROR('Telcos+', 
                                            'BFNKG_CONSULTS.P_ENVIA_CUMPLIMIENTO_VEND', 
                                            Lv_MensajeError || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'BI_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END P_ENVIA_CUMPLIMIENTO_VEND;
END BFNKG_CONSULTS;
/

