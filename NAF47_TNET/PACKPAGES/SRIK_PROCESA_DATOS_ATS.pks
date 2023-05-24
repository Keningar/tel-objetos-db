CREATE OR REPLACE PACKAGE NAF47_TNET.SRIK_PROCESA_DATOS_ATS IS
  /**
  * Documentacion para NAF47_TNET.SRIK_PROCESA_DATOS_ATS
  * Paquete que contiene procesos y funciones para generar
  * informacion de Anexo y posterior generacion archivo xml
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  */

  /**
  * Documentacion para F_LEER_CLOB
  * Funcion que permite leer una variable clob desde forms para generar xml en pc del usuario.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @param Pv_NoCia  IN VARCHAR2 Recibe codigo de compania
  * @param Pn_Indice IN NUMBER Recibe indice que controla la longitud de variable clob
  * @return VARCHAR2        retorna texto de archivo xml para ser bajado a disco desde forms
  */
  FUNCTION F_LEER_CLOB(Pv_NoCia  IN SRI_COMPANIA.NO_CIA%TYPE,
                       Pn_Indice IN NUMBER) RETURN VARCHAR2;
  /**
  * Documentacion para P_GENERA_XML_ATS
  * Procedimiento que genera xml y lo registra en la tabla de companias
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  * @author sfernandez <sfernandez@telconet.ec>
  * @version 1.1 23/11/2016 Se agregan los tags para forma de pago en ventas, validacion por
  * documento electronico y asignacion de monto ICE
  *
  * @author Miguel Angulo <jmangulos@telconet.ec>
  * @version 1.2 30/09/2019 Se agrego funcionalidad en query "C_XmlCompras" para realizar
  * la distribucion de las retenciones
  *
  * @author jgilces <jgilces@telconet.ec>
  * @version 1.3 19/09/2022 Se a?aden las tablas creadas para la pantalla Carga Masiva de Documentos XML
  * en Modulo SRI / Procesos
  *
  * @param Pv_NoCia         IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso   IN VARCHAR2 Recibe anio de proceso
  * @param Pv_MesProceso    IN VARCHAR2 recibe mes de proceso
  * @param Pv_MensajeError OUT VARCHAR2 retorna mensajes de error
  */
  PROCEDURE P_GENERA_XML_ATS(Pv_NoCia        IN VARCHAR2,
                             Pv_AnioProceso  IN VARCHAR2,
                             Pv_MesProceso   IN VARCHAR2,
                             Pv_MensajeError IN OUT VARCHAR2);

  --  procedimiento que recupera los datos para generar ats --
  /**
  * Documentacion para P_PROCESAR
  * Procedure que recupera los datos para generar ats
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @author jgilces <jgilces@telconet.ec>
  * @version 1.3 19/09/2022 Se a?aden las tablas creadas para la pantalla Carga Masiva de Documentos XML
  * en Modulo SRI / Procesos
  *
  * @param Pv_NoCia         IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso   IN VARCHAR2 Recibe anio de proceso
  * @param Pv_MesProceso    IN VARCHAR2 recibe mes de proceso
  * @param Pv_MensajeError OUT VARCHAR2 retorna mensajes de error
  */
  PROCEDURE P_PROCESAR(Pv_MesProceso   IN VARCHAR2,
                       Pv_AnioProceso  IN VARCHAR2,
                       Pv_NoCia        IN VARCHAR2,
                       Pv_MensajeError IN OUT VARCHAR2);

END SRIK_PROCESA_DATOS_ATS;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.SRIK_PROCESA_DATOS_ATS IS
  --
  Ge_Error EXCEPTION;
  --
  --

  /**
  * Documentacion para P_GENERA_LOG
  * Procedimiento que registra los mensajes de errores que se presenten durante el proceso.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @param Pv_NoCia         IN VARCHAR2 Recibe codigo de compania
  * @param Pv_NombreProceso IN VARCHAR2 Recibe nombre de proceso donde se presento el error
  * @param Pv_Clave         IN VARCHAR2 Recibe codigo unico de registro donde se presento el error
  * @param Pv_MensajeError  IN VARCHAR2 Recibe mensaje de error a registrar
  */
  PROCEDURE P_GENERA_LOG(Pv_NoCia         IN VARCHAR2,
                         Pv_NombreProceso IN VARCHAR2,
                         Pv_Clave         IN VARCHAR2,
                         Pv_MensajeError  IN VARCHAR2) IS
    --
    PRAGMA AUTONOMOUS_TRANSACTION;
    --
  BEGIN
    --
    INSERT INTO SRI_LOG_ERRORES
      (NO_CIA, NOMBRE_PROCESO, CLAVE, MENSAJE_ERROR)
    VALUES
      (Pv_NoCia, Pv_NombreProceso, Pv_Clave, Pv_MensajeError);
    --
    COMMIT;
    --
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION F_LEER_CLOB(Pv_NoCia  IN SRI_COMPANIA.NO_CIA%TYPE,
                       Pn_Indice IN NUMBER) RETURN VARCHAR2 IS
    Lv_Hilera VARCHAR2(2000);
  BEGIN
    --
    SELECT SUBSTR(ATS, 1 + Pn_Indice * 1000, 1000)
      INTO Lv_Hilera
      FROM SRI_COMPANIA
     WHERE NO_CIA = Pv_NoCia;
    --
    RETURN(Lv_Hilera);
  END;

  PROCEDURE P_GENERA_XML_ATS(Pv_NoCia        IN VARCHAR2,
                             Pv_AnioProceso  IN VARCHAR2,
                             Pv_MesProceso   IN VARCHAR2,
                             Pv_MensajeError IN OUT VARCHAR2) IS
    -- cursor que recupera datos de informante --
    CURSOR C_XmlInformante IS
      SELECT XMLElement("iva",
                        XMLForest(TIPO_IDENTIFICACION_INFORMANTE as
                                  "TipoIDInformante",
                                  RUC_INFORMANTE as "IdInformante",
                                  GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(RAZON_SOCIAL) as
                                  "razonSocial",
                                  ANIO_PERIODO_INFORMADO as "Anio",
                                  MES_PERIODO_INFORMADO as "Mes",
                                  LPAD(TO_CHAR(NUMERO_ESTABLECIMIENTOS),
                                       3,
                                       '0') as "numEstabRuc",
                                  TRIM(TO_CHAR(TOTAL_VENTAS,
                                               '999999999990.99')) as
                                  "totalVentas",
                                  'IVA' as "codigoOperativo"))
        FROM SRI_IDENTIFICACION_INFORMANTE a
       WHERE a.no_cia = Pv_NoCia;
    --
    -- cursor que recupera datos de compras
    CURSOR C_XmlCompras IS
      SELECT XMLELEMENT("compras",
                        XMLAGG(XMLELEMENT("detalleCompras",
                                          XMLFOREST(a.codigo_sust_trib as
                                                    "codSustento",
                                                    a.tipo_ident_prov as
                                                    "tpIdProv",
                                                    REPLACE(GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(a.ident_proveedor),
                                                            ' ',
                                                            '') as "idProv",
                                                    (CASE
                                                      WHEN a.comp_reembolso = 'N' AND a.registra_reembolso = 'S' THEN
                                                       '41'
                                                      ELSE
                                                       LPAD(a.codigo_tipo_comp, 2, '0')
                                                    END) as "tipoComprobante",
                                                    a.tipo_prove_extranjero as
                                                    "tipoProv",
                                                    a.nombre_prov_extranjero as
                                                    "denoProv",
                                                    DECODE(a.prov_parte_relacionada,
                                                           'S',
                                                           'SI',
                                                           'NO') as "parteRel",
                                                    TRIM(TO_CHAR(a.fecha_reg_contable,
                                                                 'dd/mm/yyyy')) as
                                                    "fechaRegistro",
                                                    a.no_serie_establec as
                                                    "establecimiento",
                                                    a.no_serie_pto_emision as
                                                    "puntoEmision",
                                                    a.no_secuencial as
                                                    "secuencial",
                                                    TRIM(TO_CHAR(a.fecha_emision_comp_vta,
                                                                 'dd/mm/yyyy')) as
                                                    "fechaEmision",
                                                    a.autorizacion_comp_vta as
                                                    "autorizacion",
                                                    TRIM(TO_CHAR(a.base_imponible_no_objeto_iva,
                                                                 '999999999990.99')) as
                                                    "baseNoGraIva",
                                                    TRIM(TO_CHAR(a.base_imponible_tarifa_0,
                                                                 '999999999990.99')) as
                                                    "baseImponible",
                                                    TRIM(TO_CHAR(a.base_imponible_gravado_0,
                                                                 '999999999990.99')) as
                                                    "baseImpGrav",
                                                    TRIM(TO_CHAR(a.base_imponible_excento_iva,
                                                                 '999999999990.99')) as
                                                    "baseImpExe",
                                                    TRIM(TO_CHAR(a.monto_ice,
                                                                 '999999999990.99')) as
                                                    "montoIce",
                                                    TRIM(TO_CHAR(a.monto_iva,
                                                                 '999999999990.99')) as
                                                    "montoIva",
                                                    TRIM(TO_CHAR(a.monto_ret_iva_bien_10,
                                                                 '999999999990.99')) as
                                                    "valRetBien10",
                                                    TRIM(TO_CHAR(a.monto_ret_iva_serv_20,
                                                                 '999999999990.99')) as
                                                    "valRetServ20",
                                                    TRIM(TO_CHAR(a.monto_ret_iva_bien_30,
                                                                 '999999999990.99')) as
                                                    "valorRetBienes",
                                                    '0.00' as "valRetServ50",
                                                    TRIM(TO_CHAR(a.monto_ret_iva_serv_70,
                                                                 '999999999990.99')) as
                                                    "valorRetServicios",
                                                    TRIM(TO_CHAR(a.monto_ret_iva_serv_100,
                                                                 '999999999990.99')) as
                                                    "valRetServ100",
                                                    TRIM(TO_CHAR(a.total_reembolso,
                                                                 '999999999990.99')) as
                                                    "totbasesImpReemb"),
                                          XMLELEMENT("pagoExterior",
                                                     XMLFOREST(a.pago_local_exterior as
                                                               "pagoLocExt",
                                                               a.tipo_regimen_exterior as
                                                               "tipoRegi",
                                                               a.pais_pago_regimen_general as
                                                               "paisEfecPagoGen",
                                                               a.pais_pago_paraiso_fisal as
                                                               "paisEfecPagoParFis",
                                                               a.denominacion as
                                                               "denopago",
                                                               a.pais_efectua_pago as
                                                               "paisEfecPago",
                                                               a.convenio_doble_tributacion as
                                                               "aplicConvDobTrib",
                                                               a.sujeto_a_retencion as
                                                               "pagExtSujRetNorLeg")),
                                          --FORMAS PAGO INI--
                                          /*(SELECT XMLFOREST(XMLAGG(XMLELEMENT("formaPago",
                                                                            fp.id_forma_pago)) as
                                                          "formasDePago")
                                           FROM cp_forma_pago_doc fp
                                          WHERE fp.id_documento = a.no_docu
                                            AND fp.id_compania = a.no_cia)*/
                                          (SELECT XMLFOREST(XMLAGG(XMLELEMENT("formaPago",
                                                                              FP2.ID_FORMA_PAGO)) as
                                                            "formasDePago")
                                             FROM (SELECT FP.ID_FORMA_PAGO,
                                                          FP.ID_COMPANIA,
                                                          FP.ID_DOCUMENTO
                                                     FROM cp_forma_pago_doc fp
                                                   UNION
                                                   SELECT SIP.FORMA_PAGO_ID,
                                                          Pv_NoCia AS ID_COMPANIA,
                                                          TO_CHAR(SIP.SECUENCIA_CARGA_ID)
                                                     FROM NAF47_TNET.INFO_PAGO              SIP,
                                                          NAF47_TNET.INFO_ARCHIVOS_CARGADOS A,
                                                          NAF47_TNET.INFO_FACTURA_RETENCION C
                                                    WHERE A.SECUENCIA_CARGA_ID =
                                                          C.SECUENCIA_CARGA_ID
                                                      AND A.SECUENCIA_CARGA_ID =
                                                          SIP.SECUENCIA_CARGA_ID
                                                      AND A.TIPO_DOCUMENTO =
                                                          'FACTURA'
                                                      AND C.IMPORTE_TOTAL >
                                                          1000.0) FP2
                                            WHERE FP2.ID_DOCUMENTO = A.NO_DOCU
                                              AND FP2.ID_COMPANIA = A.NO_CIA),
                                          --FORMAS PAGO FIN--
                                          --DETALLE AIR INI--
                                          (SELECT XMLELEMENT("air",
                                                             XMLAGG(XMLELEMENT("detalleAir",
                                                                               XMLFOREST(y.sri_retimp_renta as
                                                                                         "codRetAir",
                                                                                         TRIM(TO_CHAR(sum(y.base),
                                                                                                      '999999999990.99')) as
                                                                                         "baseImpAir",
                                                                                         TRIM(TO_CHAR(y.porcentaje,
                                                                                                      '999999999990.99')) as
                                                                                         "porcentajeAir",
                                                                                         TRIM(TO_CHAR(sum(y.monto),
                                                                                                      '999999999990.99')) as
                                                                                         "valRetAir"))))
                                             FROM (SELECT di.no_docu,
                                                          di.no_cia,
                                                          md.codigo_sustento cod_sustento,
                                                          i.sri_retimp_renta,
                                                          di.base,
                                                          di.porcentaje,
                                                          di.monto
                                                     FROM arcpti  di,
                                                          arcgimp i,
                                                          arcpmd  md
                                                    WHERE di.no_cia = i.no_cia
                                                      AND di.clave = i.clave
                                                      AND NVL(i.ind_retencion,
                                                              'N') = 'S'
                                                      AND NVL(di.ind_imp_ret,
                                                              'N') = 'R'
                                                      AND i.sri_retimp_renta IS NOT NULL
                                                      AND di.anulada = 'N'
                                                      AND md.no_cia = di.no_cia
                                                      AND md.no_docu =
                                                          di.no_docu
                                                      AND NOT EXISTS
                                                    (SELECT NULL
                                                             FROM ARCP_SUSTENTO_RETENCION
                                                            WHERE NO_CIA =
                                                                  di.no_cia
                                                              AND NO_DOCU =
                                                                  di.no_docu)
                                                   UNION
                                                   SELECT di.no_docu,
                                                          di.no_cia,
                                                          x.cod_sustento,
                                                          i.sri_retimp_renta,
                                                          x.base,
                                                          di.porcentaje,
                                                          x.monto
                                                     FROM arcpti                  di,
                                                          arcgimp                 i,
                                                          ARCP_SUSTENTO_RETENCION x
                                                    WHERE di.no_cia = i.no_cia
                                                      AND di.clave = i.clave
                                                      AND NVL(i.ind_retencion,
                                                              'N') = 'S'
                                                      AND NVL(di.ind_imp_ret,
                                                              'N') = 'R'
                                                      AND i.sri_retimp_renta IS NOT NULL
                                                      AND di.anulada = 'N'
                                                         --
                                                      AND di.clave = x.clave
                                                      AND di.no_cia = x.no_cia
                                                      AND di.no_docu =
                                                          x.no_docu
                                                   UNION
                                                   SELECT TO_CHAR(SIFR.SECUENCIA_CARGA_ID),
                                                          Pv_NoCia,
                                                          '02',
                                                          '332',
                                                          SIFR.TOTAL_SIMP,
                                                          0,
                                                          0
                                                     FROM NAF47_TNET.INFO_FACTURA_RETENCION SIFR) y
                                            where y.no_docu = a.no_docu
                                              and y.no_cia = a.no_cia
                                              and y.cod_sustento =
                                                  a.codigo_sust_trib
                                            group by y.sri_retimp_renta,
                                                     y.porcentaje,
                                                     y.cod_sustento),
                                          --DETALLE AIR FIN--
                                          XMLFOREST(a.serie_comp_ret_establecimiento as
                                                    "estabRetencion1",
                                                    a.serie_comp_ret_pto_emision as
                                                    "ptoEmiRetencion1",
                                                    a.sec_comp_ret as
                                                    "secRetencion1",
                                                    a.autorizacion_comp_ret as
                                                    "autRetencion1",
                                                    TRIM(TO_CHAR(a.fecha_emision_comp_ret,
                                                                 'dd/mm/yyyy')) as
                                                    "fechaEmiRet1"),
                                          XMLELEMENT("docModificado",
                                                     LPAD(NVL(a.tipo_comp_mod_nd_nc,
                                                              0),
                                                          2,
                                                          '0')),
                                          XMLELEMENT("estabModificado",
                                                     a.serie_comp_modificado_estab),
                                          XMLELEMENT("ptoEmiModificado",
                                                     a.serie_comp_modific_pto_emision),
                                          XMLELEMENT("secModificado",
                                                     a.no_secuencial_comp_modificado),
                                          XMLELEMENT("autModificado",
                                                     a.autorizacion_comp_modificado),
                                          (SELECT XMLFOREST(XMLAGG(XMLFOREST(XMLFOREST(LPAD(fr.tipo_comprobante,
                                                                                            2,
                                                                                            '0') as
                                                                                       "tipoComprobanteReemb",
                                                                                       fr.sec_transaccional as
                                                                                       "tpIdProvReemb",
                                                                                       fr.identificacion as
                                                                                       "idProvReemb",
                                                                                       fr.establecimiento as
                                                                                       "establecimientoReemb",
                                                                                       fr.punto_emision as
                                                                                       "puntoEmisionReemb",
                                                                                       fr.secuencia as
                                                                                       "secuencialReemb",
                                                                                       TRIM(TO_CHAR(fr.fecha_emision,
                                                                                                    'dd/mm/yyyy')) as
                                                                                       "fechaEmisionReemb",
                                                                                       fr.numero_autorizacion as
                                                                                       "autorizacionReemb",
                                                                                       trim(to_char(DECODE(fr.tipo_base_imponible,
                                                                                                           'TC',
                                                                                                           fr.base_imponible,
                                                                                                           0),
                                                                                                    '9999990.00')) as
                                                                                       "baseImponibleReemb",
                                                                                       trim(to_char(fr.base_gravada,
                                                                                                    '9999990.00')) as
                                                                                       "baseImpGravReemb",
                                                                                       trim(to_char(DECODE(fr.tipo_base_imponible,
                                                                                                           'NO',
                                                                                                           fr.base_imponible,
                                                                                                           0),
                                                                                                    '9999990.00')) as
                                                                                       "baseNoGraIvaReemb",
                                                                                       trim(to_char(DECODE(fr.tipo_base_imponible,
                                                                                                           'EX',
                                                                                                           fr.base_imponible,
                                                                                                           0),
                                                                                                    '9999990.00')) as
                                                                                       "baseImpExeReemb",
                                                                                       trim(to_char(fr.monto_ice,
                                                                                                    '9999990.00')) as
                                                                                       "montoIceRemb",
                                                                                       trim(to_char(fr.monto_iva,
                                                                                                    '9999990.00')) as
                                                                                       "montoIvaRemb") as
                                                                             "reembolso")) as
                                                            "reembolsos")
                                             FROM arcpmd_reembolso fr
                                            WHERE fr.no_documento = a.no_docu
                                              AND fr.no_cia = a.no_cia))))
        FROM sri_compras a, sri_tipos_comprobantes b
       WHERE a.no_cia = Pv_NoCia
         AND a.codigo_tipo_comp = b.codigo;
    --
    -- cursor que recupera datos de ventas
    CURSOR C_XmlVentas is
      SELECT XMLELEMENT("ventas",
                        XMLAGG(XMLELEMENT("detalleVentas",
                                          
                                          XMLFOREST(tipo_ident_cliente as
                                                    "tpIdCliente",
                                                    no_ident_cliente as
                                                    "idCliente",
                                                    DECODE(prov_parte_relacionada,
                                                           'S',
                                                           'SI',
                                                           'NO') as
                                                    "parteRelVtas",
                                                    LPAD(codigo_tipo_comp,
                                                         2,
                                                         '0') as
                                                    "tipoComprobante",
                                                    'E' as "tipoEmision", -- modificar para leer de tipos documentos
                                                    SUM(total_comprobantes_emitidos) as
                                                    "numeroComprobantes",
                                                    '0.00' as "baseNoGraIva",
                                                    TRIM(TO_CHAR(SUM(base_imp_excento_iva),
                                                                 '999999999990.99')) as
                                                    "baseImponible",
                                                    TRIM(TO_CHAR(SUM(base_imp_gravada_iva),
                                                                 '999999999990.99')) as
                                                    "baseImpGrav",
                                                    TRIM(TO_CHAR(SUM(monto_iva),
                                                                 '999999999990.99')) as
                                                    "montoIva",
                                                    '0.00' as "montoIce",
                                                    TRIM(TO_CHAR(SUM(iva_retenido),
                                                                 '999999999990.99')) as
                                                    "valorRetIva",
                                                    TRIM(TO_CHAR(SUM(renta_retenido),
                                                                 '999999999990.99')) as
                                                    "valorRetRenta"),
                                          case
                                            when codigo_tipo_comp not in (4, 5) then -- 4-Nota de cr\E9dito, 5-Nota de d\E9dito
                                             (SELECT DISTINCT XMLELEMENT("formasDePago",
                                                                         XMLAGG(XMLFOREST(NVL(pp.forma_pago_sri,
                                                                                              '20') as
                                                                                          "formaPago"))) -- 20 - OTROS CON UTILIZACI\D3N DEL SISTEMA FINANCIERO
                                                FROM (select arccmc.cedula,
                                                             arccmc.no_cia,
                                                             arfafe.fecha,
                                                             arfafe.forma_pago_sri
                                                        from arfafe, arccmc
                                                       where arfafe.no_cliente = arccmc.no_cliente
                                                         and arfafe.grupo = arccmc.grupo
                                                         AND arfafe.no_cia = arccmc.no_cia
                                                      union
                                                      select c.identificacion,
                                                             b.no_cia,
                                                             c.fe_emision,
                                                             a.forma_pago_id
                                                        from naf47_tnet.info_pago              a,
                                                             naf47_tnet.info_archivos_cargados b,
                                                             naf47_tnet.info_factura_retencion c
                                                       where b.secuencia_carga_id = a.secuencia_carga_id
                                                         and b.secuencia_carga_id = c.secuencia_carga_id
                                                         and b.tipo_documento = 'RETENCION') pp
                                               WHERE pp.cedula = sri_ventas.no_ident_cliente
                                                 AND pp.no_cia = sri_ventas.no_cia
                                                 AND pp.fecha >= TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                                         Pv_AnioProceso,
                                                                         'dd/mm/yyyy')
                                                 AND pp.fecha <=
                                                     LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                                      Pv_AnioProceso,
                                                                      'dd/mm/yyyy')))
                                          end case))) xml_ventas
      
        FROM sri_ventas
       WHERE no_cia = Pv_NoCia
       GROUP BY no_cia,
                tipo_ident_cliente,
                no_ident_cliente,
                codigo_tipo_comp,
                prov_parte_relacionada;
    --
    -- cursor que recupera datos de ventas por establecimientos --
    CURSOR C_VentasEstablecimientos IS
      SELECT XMLELEMENT("ventasEstablecimiento",
                        XMLAGG(XMLFOREST(XMLFOREST(SUBSTR(serie_fisico, 1, 3) as
                                                   "codEstab",
                                                   TRIM(TO_CHAR(SUM(total),
                                                                '999999999990.99')) as
                                                   "ventasEstab",
                                                   '0.00' as "ivaComp") AS
                                         "ventaEst"))) xml_ventas_estab
        FROM (SELECT a.no_cia,
                     a.serie_fisico,
                     a.fecha,
                     decode(c.es_doc_electronico,
                            'N',
                            (NVL(a.tot_lin, 0) - NVL(a.descuento, 0)),
                            0) total
                FROM arfafe a, arccmc b, arfact c
               WHERE a.no_cia = Pv_NoCia
                 AND NVL(a.ind_anu_dev, 'X') != 'A'
                 AND a.estado != 'P'
                 AND c.ind_fac_dev = 'F'
                 AND a.fecha >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'dd/mm/yyyy')
                 AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                 Pv_AnioProceso,
                                                 'dd/mm/yyyy'))
                 AND a.no_cia = b.no_cia
                 AND a.grupo = b.grupo
                 AND a.no_cliente = b.no_cliente
                 AND a.no_cia = c.no_cia
                 AND a.tipo_doc = c.tipo
              UNION ALL
              SELECT a.no_cia,
                     a.serie_fisico,
                     a.fecha,
                     decode(c.es_doc_electronico,
                            'N',
                            (NVL(a.tot_lin, 0) - NVL(a.descuento, 0)),
                            0) subtotal
                FROM arfafe a, arccmc b, arfact c
               WHERE a.no_cia = Pv_NoCia
                 AND NVL(a.ind_anu_dev, 'X') != 'A'
                 AND a.estado != 'P'
                 AND c.ind_fac_dev = 'D'
                 AND a.no_cia = b.no_cia
                 AND a.grupo = b.grupo
                 AND a.no_cliente = b.no_cliente
                 AND a.no_cia = c.no_cia
                 AND a.tipo_doc = c.tipo
                 AND a.fecha >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'dd/mm/yyyy')
                 AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                 Pv_AnioProceso,
                                                 'dd/mm/yyyy'))
              UNION ALL
              SELECT a.no_cia,
                     a.serie_fisico,
                     a.fecha,
                     decode(c.es_doc_electronico,
                            'N',
                            ((NVL(a.gravado, 0) + NVL(a.exento, 0)) * -1),
                            0) subtotal
                FROM arccmd a, arccmc b, arcctd c
               WHERE a.no_cia = Pv_NoCia
                 AND NVL(a.anulado, 'N') = 'N'
                 AND a.estado != 'P'
                 AND c.codigo_tipo_comprobante = '4'
                 AND a.origen = 'CC'
                 AND a.no_cia = b.no_cia
                 AND a.grupo = b.grupo
                 AND a.no_cliente = b.no_cliente
                 AND a.no_cia = c.no_cia
                 AND a.tipo_doc = c.tipo
                 AND a.fecha >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'dd/mm/yyyy')
                 AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                 Pv_AnioProceso,
                                                 'dd/mm/yyyy'))
              UNION ALL
              select b.no_cia,
                     a.establecimiento || a.punto_emision || a.secuencial_id as serie_fisico,
                     c.fe_emision,
                     0 SUBTOTAL
                from naf47_tnet.info_tributaria_doc    a,
                     naf47_tnet.info_archivos_cargados b,
                     naf47_tnet.info_factura_retencion c
               where a.secuencia_carga_id = b.secuencia_carga_id
                 and a.secuencia_carga_id = c.secuencia_carga_id
                 and b.no_cia = Pv_NoCia
                 and b.tipo_documento = 'RETENCION'
                 AND B.ESTADO = 'C'
                 AND c.fe_emision >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'dd/mm/yyyy')
                 AND c.fe_emision <=
                     LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                      Pv_AnioProceso,
                                      'dd/mm/yyyy')))
       GROUP BY SUBSTR(SERIE_FISICO, 1, 3);
    --
    -- cursor que recupera comprobantes anulados
    CURSOR C_XmlAnulados IS
      SELECT XMLELEMENT("anulados",
                        XMLAGG(XMLFOREST(XMLFOREST(LPAD(tipo_comp_anulado,
                                                        2,
                                                        '0') as
                                                   "tipoComprobante",
                                                   no_serie_comp_est as
                                                   "establecimiento",
                                                   no_serie_comp_pemi as
                                                   "puntoEmision",
                                                   no_sec_cpte_desde as
                                                   "secuencialInicio",
                                                   no_sec_cpte_hasta as
                                                   "secuencialFin",
                                                   no_autorizacion_cpte_vta as
                                                   "autorizacion") as
                                         "detalleAnulados")))
        FROM sri_comp_anulados
       WHERE no_cia = Pv_NoCia
         AND fecha_anula_cpte_vta >=
             TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                     'dd/mm/yyyy')
         AND fecha_anula_cpte_vta <=
             LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                              Pv_AnioProceso,
                              'dd/mm/yyyy'));
    --
    Lx_Ats    xmltype;
    Lx_xmlAux xmltype;
    --
  BEGIN
    -- se recupera xml informante
    IF C_XmlInformante%ISOPEN THEN
      CLOSE C_XmlInformante;
    END IF;
    --
    OPEN C_XmlInformante;
    FETCH C_XmlInformante
      INTO Lx_Ats;
    CLOSE C_XmlInformante;
  
    -- se recupera xml compras
    IF C_XmlCompras%ISOPEN THEN
      CLOSE C_XmlCompras;
    END IF;
    --
    OPEN C_XmlCompras;
    FETCH C_XmlCompras
      INTO Lx_xmlAux;
    CLOSE C_XmlCompras;
    --
    -- se agrega nodo de compras a xml principal
    Lx_Ats := Lx_Ats.appendChildXML('iva', Lx_xmlAux);
  
    -- se recupera xml ventas
    IF C_XmlVentas%ISOPEN THEN
      CLOSE C_XmlVentas;
    END IF;
    --
    OPEN C_XmlVentas;
    FETCH C_XmlVentas
      INTO Lx_xmlAux;
    CLOSE C_XmlVentas;
  
    -- se agrega nodo ventas en caso de existir
    IF Lx_xmlAux.existsNode('/ventas/detalleVentas') = 1 THEN
      Lx_Ats := Lx_Ats.appendChildXML('iva', Lx_xmlAux);
    END IF;
  
    -- Se recupera las ventas por establecimientos
    IF C_VentasEstablecimientos%ISOPEN THEN
      CLOSE C_VentasEstablecimientos;
    END IF;
    --
    OPEN C_VentasEstablecimientos;
    FETCH C_VentasEstablecimientos
      INTO Lx_xmlAux;
    CLOSE C_VentasEstablecimientos;
  
    -- se agrega nodo ventas establecimiento en caso de existir
    IF Lx_xmlAux.existsNode('/ventasEstablecimiento/ventaEst') = 1 THEN
      Lx_Ats := Lx_Ats.appendChildXML('iva', Lx_xmlAux);
    END IF;
  
    -- Se recupera comprobantes anulados
    IF C_XmlAnulados%ISOPEN THEN
      CLOSE C_XmlAnulados;
    END IF;
    --
    OPEN C_XmlAnulados;
    FETCH C_XmlAnulados
      INTO Lx_xmlAux;
    CLOSE C_XmlAnulados;
  
    -- se agrega comprobantes anulados en caso de existir
    IF Lx_xmlAux.existsNode('/anulados/detalleAnulados') = 1 THEN
      Lx_Ats := Lx_Ats.appendChildXML('iva', Lx_xmlAux);
    END IF;
  
    -- se agrega el root del xml
    SELECT XMLROOT(Lx_Ats, VERSION '1.0" encoding="UTF-8')
      INTO Lx_Ats
      FROM DUAL;
  
    -- se guarda en la tabla
    UPDATE SRI_COMPANIA
       SET ATS = Lx_Ats.getClobVal()
     WHERE NO_CIA = Pv_NoCia;
  
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error no controlado en SRIK_PROCESA_DATOS_ATS.P_GENERA_XML_ATS. ' ||
                         SQLERRM;
      ROLLBACK;
  END;

  /**
  * Documentacion para P_IDENTIFICACION_INFORMANTE
  * Procedimiento que recupera informaci?n de la empresa y lo registra en temporales de SRI
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @param Pv_NoCia       IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso IN VARCHAR2 Recibe anio proceso
  * @param Pv_MesProceso  IN VARCHAR2 Recibe mes proceso
  */
  PROCEDURE P_IDENTIFICACION_INFORMANTE(Pv_NoCia       IN VARCHAR2,
                                        Pv_AnioProceso IN VARCHAR2,
                                        Pv_MesProceso  IN VARCHAR2) IS
  
    -- cursor que recupera datos de clompania
    CURSOR C_Compania IS
      SELECT a.tipo_id_tributario,
             a.id_tributario,
             a.direccion,
             a.telefono,
             a.fax,
             a.e_mail,
             b.sri_ident,
             a.identificador_rep_legal,
             a.identificador_contador,
             a.razon_social
        FROM arcgmc a, argetid b
       WHERE a.no_cia = Pv_NoCia
         AND a.tipo_id_rep_legal = b.codigo;
    --
    -- cursor que recupera la cantidad de establecimientos y total de ventas de la empresa informante
    CURSOR C_DatosAdicionales IS
      SELECT COUNT(DISTINCT SUBSTR(SERIE_FISICO, 1, 3)) ESTABLECIMIENTOS,
             SUM(TOTAL) TOTAL
        FROM (SELECT a.no_cia,
                     a.serie_fisico,
                     a.fecha,
                     decode(c.es_doc_electronico,
                            'N',
                            (NVL(a.tot_lin, 0) - NVL(a.descuento, 0)),
                            0) total
                FROM arfafe a, arccmc b, arfact c
               WHERE a.no_cia = Pv_NoCia
                 AND NVL(a.ind_anu_dev, 'X') != 'A'
                 AND a.estado != 'P'
                 AND c.ind_fac_dev = 'F'
                 AND a.fecha >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'DD/MM/YYYY')
                 AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                 Pv_AnioProceso,
                                                 'DD/MM/YYYY'))
                 AND a.no_cia = b.no_cia
                 AND a.grupo = b.grupo
                 AND a.no_cliente = b.no_cliente
                 AND a.no_cia = c.no_cia
                 AND a.tipo_doc = c.tipo
              UNION ALL
              SELECT a.no_cia,
                     a.serie_fisico,
                     a.fecha,
                     decode(c.es_doc_electronico,
                            'N',
                            (NVL(a.tot_lin, 0) - NVL(a.descuento, 0)),
                            0) subtotal
                FROM arfafe a, arccmc b, arfact c
               WHERE a.no_cia = Pv_NoCia
                 AND NVL(a.ind_anu_dev, 'X') != 'A'
                 AND a.estado != 'P'
                 AND c.ind_fac_dev = 'D'
                 AND a.no_cia = b.no_cia
                 AND a.grupo = b.grupo
                 AND a.no_cliente = b.no_cliente
                 AND a.no_cia = c.no_cia
                 AND a.tipo_doc = c.tipo
                 AND a.fecha >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'DD/MM/YYYY')
                 AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                 Pv_AnioProceso,
                                                 'DD/MM/YYYY'))
              UNION ALL
              SELECT a.no_cia,
                     a.serie_fisico,
                     a.fecha,
                     decode(c.es_doc_electronico,
                            'N',
                            ((NVL(a.gravado, 0) + NVL(a.exento, 0)) * -1),
                            0) subtotal
                FROM arccmd a, arccmc b, arcctd c
               WHERE a.no_cia = Pv_NoCia
                 AND NVL(a.anulado, 'N') = 'N'
                 AND a.estado != 'P'
                 AND c.codigo_tipo_comprobante = '4'
                 AND a.origen = 'CC'
                 AND a.no_cia = b.no_cia
                 AND a.grupo = b.grupo
                 AND a.no_cliente = b.no_cliente
                 AND a.no_cia = c.no_cia
                 AND a.tipo_doc = c.tipo
                 AND a.fecha >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'DD/MM/YYYY')
                 AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                                 Pv_AnioProceso,
                                                 'DD/MM/YYYY'))
              /*AGREGAO POR CARGA MASIVA DE DOCUMENTOS*/
              /*UNION ALL
              SELECT A.NO_CIA AS NO_CIA,
                     C.ESTAB || '' || C.PTO_EMI AS SERIE_FISICO,
                     B.FECHA_EMISION AS FECHA,
                     B.IMPORTE_TOTAL AS TOTAL
                FROM SRI_ARCHIVOS_CARGADOS      a,
                     SRI_INFO_FACTURA_RETENCION B,
                     SRI_INFO_TRIBUTARIA_DOC    C
               WHERE A.SECUENCIA = B.COD
                 AND A.SECUENCIA = C.COD
                 AND A.ESTADO = 'C'
                 AND A.NO_CIA = Pv_NoCia
                 AND B.fecha_EMISION >=
                     TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                             'DD/MM/YYYY')
                 AND B.fecha_EMISION <=
                     LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                      Pv_AnioProceso,
                                      'DD/MM/YYYY'))*/
              );
    --
    Lv_Clave       sri_log_errores.clave%TYPE := NULL;
    Ln_NumeroEst   NUMBER := 0;
    Ln_TotalVentas NUMBER := 0;
    --
  BEGIN
    -- se abre ursor para recuperar la informacion del informante
    FOR i IN C_Compania LOOP
      --
      Lv_Clave := 'Identificacion: ' || substr(i.id_tributario, 1, 13);
      --
      -- se recupera total de establecimientos y total de ventas
      IF C_DatosAdicionales%ISOPEN THEN
        CLOSE C_DatosAdicionales;
      END IF;
      OPEN C_DatosAdicionales;
      FETCH C_DatosAdicionales
        INTO Ln_NumeroEst, Ln_TotalVentas;
      CLOSE C_DatosAdicionales;
    
      IF nvl(Ln_NumeroEst, 0) = 0 THEN
        -- para telconet valores default, esta inf lo genera telcos
        Ln_TotalVentas := 0;
        Ln_NumeroEst   := 1;
      END IF;
      --
      -- Se inserta en tabla de informante del modulo SRI
      BEGIN
        INSERT INTO SRI_IDENTIFICACION_INFORMANTE
          (TIPO_IDENTIFICACION_INFORMANTE,
           RUC_INFORMANTE,
           RAZON_SOCIAL,
           DIRECCION_MATRIZ,
           TELEFONO_RESPONSABLE,
           FAX,
           EMAIL,
           TIPO_IDENTIFICACION,
           IDENT_REP_LEGAL,
           IDENT_CONTADOR,
           ANIO_PERIODO_INFORMADO,
           MES_PERIODO_INFORMADO,
           NUMERO_ESTABLECIMIENTOS,
           TOTAL_VENTAS,
           NO_CIA)
        VALUES
          (substr(i.tipo_id_tributario, 1, 1),
           substr(i.id_tributario, 1, 13),
           substr(i.razon_social, 1, 60),
           substr(nvl(i.direccion, '.'), 1, 60),
           substr(i.telefono, 1, 9),
           substr(i.fax, 1, 9),
           substr(i.e_mail, 1, 60),
           i.sri_ident,
           substr(i.identificador_rep_legal, 1, 13),
           substr(i.identificador_contador, 1, 13),
           Pv_AnioProceso,
           Pv_MesProceso,
           Ln_NumeroEst,
           Ln_TotalVentas,
           Pv_NoCia);
      
      EXCEPTION
        WHEN OTHERS THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_IDENTIFICACION_INFORMANTE',
                       Lv_Clave,
                       'Error al insertar en SRI_IDENTIFICACION_INFORMANTE. ' ||
                       SQLERRM);
          RAISE Ge_Error;
      END;
    END LOOP;
  EXCEPTION
    WHEN Ge_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_IDENTIFICACION_INFORMANTE',
                   Lv_Clave,
                   'Error no controlado.' || SQLERRM);
      ROLLBACK;
  END P_IDENTIFICACION_INFORMANTE;

  /**
  * Documentacion para P_INFORMACION_CXP
  * Procedimiento que recupera informacion de compras y lo registra en temporales de SRI
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @param Pv_NoCia       IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso IN VARCHAR2 Recibe anio proceso
  * @param Pv_MesProceso  IN VARCHAR2 Recibe mes proceso
  *
  * @author sfernandez <sfernandez@telconet.ec>
  * @version 1.1 21/11/2016 Se considera la informacion del comprobante de retencion para la
  * generacion del ATS en el cursor de Compras para la insercion del 0%
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 13/10/2017 Se cambia validaci\F3n para llenar los datos del documento electr\F3nico
  * solo se asignan si el documento tiene valor en el campo arcpmd.tot_ret
  *
  * @author Miguel Angulo S\E1nchez<jmangulos@telconet.ec>
  * @version 1.3 26/08/2019 Se agrego tabla "ARCP_DET_SUSTENTO" para realizar la inserci\F3n de multiples
  * codigos de sustento, se agrego validaci\F3n de si ya existia el registro en la tabla "CP_FORMA_PAGO_DOC"
  */
  PROCEDURE P_INFORMACION_CXP(Pv_NoCia       IN VARCHAR2,
                              Pv_AnioProceso IN VARCHAR2,
                              Pv_MesProceso  IN VARCHAR2) IS
    -- cursor que recupera las trasncciones de cuentas por pagar
    CURSOR C_Compras IS
      SELECT a.no_fisico,
             a.serie_fisico,
             a.fecha,
             a.no_autorizacion no_autorizacion,
             a.codigo_sustento,
             a.derecho_devolucion_iva,
             a.fecha_caducidad fecha_caducidad,
             a.gravado,
             decode(a.tipo_base_imponible, 'TC', a.excentos, 0) BaseTarifaCero,
             decode(a.tipo_base_imponible, 'NO', a.excentos, 0) BaseNoObjetoIva,
             decode(a.tipo_base_imponible, 'EX', a.excentos, 0) BaseExcentoIva,
             a.fecha_documento,
             a.no_docu,
             b.cedula,
             b.no_prove,
             b.parte_relacionada,
             b.sri_sec_trans,
             a.tot_imp,
             c.codigo_tipo_comprobante,
             c.codigo_tipo_transaccion,
             c.tipo_doc,
             a.comp_ret,
             A.COMP_RET_SERIE,
             A.NO_AUTORIZACION_COMP,
             a.fecha_retencion,
             a.tot_ret,
             NVL(a.tipo_compra, 'V') tipo_factura, -- cambio tipo factura a tipo de cambio
             c.ingresa_reembolso,
             b.tipo_provee_extranjero,
             b.nombre,
             nvl(a.excentos, 0) + nvl(a.gravado, 0) + nvl(a.tot_imp, 0) total_comprobante,
             e.id_tipo_pago pago_local_exterior,
             e.id_tipo_regimen,
             decode(e.id_tipo_pago, '01', 'NA', e.codigo_sri) pais_efectua_pago,
             decode(e.id_tipo_regimen, '01', e.codigo_sri, null) pais_pago_regime_general,
             decode(e.id_tipo_regimen,
                    '02',
                    (select pf.id_paraiso_fiscal
                       from sri_paraiso_fiscal pf
                      where pf.pais_id = e.codigo_sri),
                    null) pais_pago_paraiso_fisal,
             e.denominacion,
             decode(e.id_tipo_pago, '01', 'NA', e.doble_tributacion) convenio_doble_tributacion,
             a.no_cia,
             --
             (SELECT count(fp.id_forma_pago)
                FROM cp_forma_pago_doc fp
               WHERE fp.id_documento = a.no_docu
                 AND fp.id_compania = a.no_cia) cantidad_forma_pagos,
             --
             (SELECT SUM(di.base)
                FROM arcpti di, arcgimp i
               WHERE di.no_cia = i.no_cia
                 AND di.clave = i.clave
                 AND NVL(i.ind_retencion, 'N') = 'S'
                 AND NVL(di.ind_imp_ret, 'N') = 'R'
                 AND i.sri_retimp_renta IS NOT NULL
                 AND di.anulada = 'N'
                 AND di.no_docu = a.no_docu
                 AND di.no_cia = a.no_cia
                 AND EXISTS
               (SELECT NULL
                        FROM sri_ret_fuente_imp_renta rf
                       WHERE rf.codigo = di.sri_retimp_renta)) TotalBaseRetFte,
             --
             (SELECT SUM(nvl(fr.base_imponible, 0) + nvl(fr.base_gravada, 0))
                FROM arcpmd_reembolso fr
               WHERE no_documento = a.no_docu
                 AND no_cia = a.no_cia) TotalReembolso,
             'N' identificador
      --
        FROM arcpmd a, arcpmp b, arcptd c, argetid d, argepai e
       WHERE a.no_cia = Pv_NoCia
         AND a.fecha >=
             TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                     'DD/MM/YYYY')
         AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                         Pv_AnioProceso,
                                         'DD/MM/YYYY'))
         AND NVL(ind_act, 'P') != 'P'
         AND NVL(a.anulado, 'N') = 'N'
         AND a.tipo_doc NOT IN ('CK', 'TR')
         AND NVL(c.doc_importacion, 'N') = 'N' --- Solamente compras
         AND NVL(c.declara_sri, 'N') = 'S'
         AND NVL(a.tipo_compra, 'V') != 'I'
         AND a.no_cia = b.no_cia
         AND a.no_prove = b.no_prove
         AND a.no_cia = c.no_cia
         AND a.tipo_doc = c.tipo_doc
         AND b.tipo_id_tributario = d.codigo
         AND b.pais = e.pais(+)
         AND NOT EXISTS (SELECT NULL
                FROM ARCP_DETALLE_SUSTENTO
               WHERE NO_CIA = a.NO_CIA
                 AND NO_DOCU = a.NO_DOCU)
      
      UNION
      
      SELECT a.no_fisico,
             a.serie_fisico,
             a.fecha,
             a.no_autorizacion no_autorizacion,
             f.cod_sustento codigo_sustento,
             a.derecho_devolucion_iva,
             a.fecha_caducidad fecha_caducidad,
             f.base_gravado gravado,
             decode(a.tipo_base_imponible, 'TC', f.base_imponible, 0) BaseTarifaCero,
             decode(a.tipo_base_imponible, 'NO', f.base_imponible, 0) BaseNoObjetoIva,
             decode(a.tipo_base_imponible, 'EX', f.base_imponible, 0) BaseExcentoIva,
             a.fecha_documento,
             a.no_docu,
             b.cedula,
             b.no_prove,
             b.parte_relacionada,
             b.sri_sec_trans,
             f.iva tot_imp,
             c.codigo_tipo_comprobante,
             c.codigo_tipo_transaccion,
             c.tipo_doc,
             a.comp_ret,
             A.COMP_RET_SERIE,
             A.NO_AUTORIZACION_COMP,
             a.fecha_retencion,
             (SELECT NVL(sum(MONTO), 0)
                FROM ARCP_SUSTENTO_RETENCION
               WHERE NO_CIA = a.no_cia
                 and NO_DOCU = a.no_docu
                 and COD_SUSTENTO = f.cod_sustento) tot_ret,
             NVL(a.tipo_compra, 'V') tipo_factura, -- cambio tipo factura a tipo de cambio
             c.ingresa_reembolso,
             b.tipo_provee_extranjero,
             b.nombre,
             nvl(f.base_imponible, 0) + nvl(f.base_gravado, 0) +
             nvl(f.iva, 0) total_comprobante,
             e.id_tipo_pago pago_local_exterior,
             e.id_tipo_regimen,
             decode(e.id_tipo_pago, '01', 'NA', e.codigo_sri) pais_efectua_pago,
             decode(e.id_tipo_regimen, '01', e.codigo_sri, null) pais_pago_regime_general,
             decode(e.id_tipo_regimen,
                    '02',
                    (select pf.id_paraiso_fiscal
                       from sri_paraiso_fiscal pf
                      where pf.pais_id = e.codigo_sri),
                    null) pais_pago_paraiso_fisal,
             e.denominacion,
             decode(e.id_tipo_pago, '01', 'NA', e.doble_tributacion) convenio_doble_tributacion,
             a.no_cia,
             --
             (SELECT count(fp.id_forma_pago)
                FROM cp_forma_pago_doc fp
               WHERE fp.id_documento = a.no_docu
                 AND fp.id_compania = a.no_cia) cantidad_forma_pagos,
             --
             (SELECT SUM(di.base)
                FROM arcpti di, arcgimp i
               WHERE di.no_cia = i.no_cia
                 AND di.clave = i.clave
                 AND NVL(i.ind_retencion, 'N') = 'S'
                 AND NVL(di.ind_imp_ret, 'N') = 'R'
                 AND i.sri_retimp_renta IS NOT NULL
                 AND di.anulada = 'N'
                 AND di.no_docu = a.no_docu
                 AND di.no_cia = a.no_cia
                 AND EXISTS
               (SELECT NULL
                        FROM sri_ret_fuente_imp_renta rf
                       WHERE rf.codigo = di.sri_retimp_renta)) TotalBaseRetFte,
             --
             (SELECT SUM(nvl(fr.base_imponible, 0) + nvl(fr.base_gravada, 0))
                FROM arcpmd_reembolso fr
               WHERE no_documento = a.no_docu
                 AND no_cia = a.no_cia) TotalReembolso,
             'S' identificador
      --
        FROM arcpmd                a,
             arcpmp                b,
             arcptd                c,
             argetid               d,
             argepai               e,
             ARCP_DETALLE_SUSTENTO f
       WHERE a.no_cia = Pv_NoCia
         AND a.fecha >=
             TO_DATE('01/' || Pv_MesProceso || '/' || Pv_AnioProceso,
                     'DD/MM/YYYY')
         AND a.fecha <= LAST_DAY(TO_DATE('01/' || Pv_MesProceso || '/' ||
                                         Pv_AnioProceso,
                                         'DD/MM/YYYY'))
         AND NVL(ind_act, 'P') != 'P'
         AND NVL(a.anulado, 'N') = 'N'
         AND a.tipo_doc NOT IN ('CK', 'TR')
         AND NVL(c.doc_importacion, 'N') = 'N' --- Solamente compras
         AND NVL(c.declara_sri, 'N') = 'S'
         AND NVL(a.tipo_compra, 'V') != 'I'
         AND a.no_cia = b.no_cia
         AND a.no_prove = b.no_prove
         AND a.no_cia = c.no_cia
         AND a.tipo_doc = c.tipo_doc
         AND b.tipo_id_tributario = d.codigo
         AND b.pais = e.pais(+)
            --
         AND f.no_cia = a.no_cia
         AND f.no_docu = a.no_docu;
  
    -- Cursor que recuperA codigo de Iva y Total Iva por documento --
    CURSOR C_Iva(Cv_IdProveedor   VARCHAR2,
                 Cv_TipoDocumento VARCHAR2,
                 Cv_NoDocumento   VARCHAR2) IS
      SELECT b.sri_codigo_iva, NVL(SUM(NVL(a.monto, 0)), 0)
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'N'
         AND NVL(a.ind_imp_ret, 'N') = 'I'
         AND b.sri_codigo_iva IS NOT NULL
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_NoDocumento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave
       GROUP BY b.sri_codigo_iva;
  
    -- Cursor que recuperA Total Iva por documento y Codigo sustento--
    CURSOR C_IvaSust(Cv_NoDocumento VARCHAR2, Cv_CodSustento VARCHAR2) IS
      SELECT IVA
        FROM ARCP_DETALLE_SUSTENTO
       WHERE NO_CIA = Pv_NoCia
         AND NO_DOCU = Cv_NoDocumento
         AND COD_SUSTENTO = Cv_CodSustento;
  
    -- Cursor que recupera codigo ICE y total Ice por documento --
    CURSOR C_Ice(Cv_IdProveedor   VARCHAR2,
                 Cv_TipoDocumento VARCHAR2,
                 Cv_NoDocumento   VARCHAR2) IS
      SELECT b.sri_codigo_ice, a.monto, a.base
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'N'
         AND NVL(a.ind_imp_ret, 'N') = 'I'
         AND b.sri_codigo_ice IS NOT NULL
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_NoDocumento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- recupera monto retencion iva bienes --
    CURSOR C_MontoRetIvaBienes(Cv_CodRetIva VARCHAR2,
                               Cv_NoDocu    VARCHAR2,
                               Cv_NoCia     VARCHAR2) IS
      SELECT NVL(SUM(NVL(monto, 0)), 0) monto
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND a.ind_imp_ret = 'R'
         AND b.sri_cod_retiva_bien = Cv_CodRetIva
         AND no_docu = Cv_NoDocu
         AND a.no_cia = Cv_NoCia;
  
    -- recupera monto retencion iva bienes por codigo de Sustento --
    CURSOR C_MontoRetIvaBienesSust(Cv_CodRetIva   VARCHAR2,
                                   CV_CodSustento VARCHAR2,
                                   Cv_NoDocu      VARCHAR2,
                                   Cv_NoCia       VARCHAR2) IS
      SELECT NVL(SUM(NVL(monto, 0)), 0) monto
        FROM ARCP_SUSTENTO_RETENCION a, arcgimp b
       WHERE a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND b.sri_cod_retiva_bien = Cv_CodRetIva
         AND no_docu = Cv_NoDocu
         AND a.no_cia = Cv_NoCia
         AND a.COD_SUSTENTO = CV_CodSustento;
  
    -- recupera monto retencion iva servicios --
    CURSOR C_MontoRetIvaServicios(Cv_CodRetIva VARCHAR2,
                                  Cv_NoDocu    VARCHAR2,
                                  Cv_NoCia     VARCHAR2) IS
      SELECT NVL(SUM(NVL(monto, 0)), 0) monto
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND a.ind_imp_ret = 'R'
         AND b.sri_cod_retiva_serv = Cv_CodRetIva
         AND no_docu = Cv_NoDocu
         AND a.no_cia = Cv_NoCia;
  
    -- recupera monto retencion iva servicios por Codigo de Sustento--
    CURSOR C_MontoRetIvaServiciosSust(Cv_CodRetIva   VARCHAR2,
                                      CV_CodSustento VARCHAR2,
                                      Cv_NoDocu      VARCHAR2,
                                      Cv_NoCia       VARCHAR2) IS
      SELECT NVL(SUM(NVL(monto, 0)), 0) monto
        FROM ARCP_SUSTENTO_RETENCION a, arcgimp b
       WHERE a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND b.sri_cod_retiva_serv = Cv_CodRetIva
         AND no_docu = Cv_NoDocu
         AND a.no_cia = Cv_NoCia
         AND a.COD_SUSTENTO = CV_CodSustento;
  
    -- cursor que recupera codigo retencion fuente 0% --
    CURSOR C_RetFteCero IS
      SELECT i.clave, i.sri_retimp_renta
        FROM arcgimp i
       WHERE i.no_cia = Pv_NoCia
         AND EXISTS (SELECT NULL
                FROM sri_ret_fuente_imp_renta ir
               WHERE ir.codigo = i.sri_retimp_renta
                 AND ir.cod_no_retencion = 'S');
  
    -- cursor que recupera monto minimo para aplicar forma pago --
    CURSOR C_ParametroFormaPago(Cv_NoCia VARCHAR2) IS
      SELECT a.numerico
        FROM ge_parametros a, ge_grupos_parametros b
       WHERE a.id_grupo_parametro = b.id_grupo_parametro
         AND a.id_aplicacion = b.id_aplicacion
         AND a.id_empresa = b.id_empresa
         AND a.id_grupo_parametro = 'INGRESA_FORMA_PAGO'
         AND a.id_aplicacion = 'CP'
         AND a.id_empresa = Cv_NoCia
         AND a.estado = 'A'
         AND b.estado = 'A';
  
    -- Cursor que recupera Retencion IVA Bienes --
    CURSOR C_RetIvaBienes(Cv_Idproveedor   VARCHAR2,
                          Cv_TipoDocumento VARCHAR2,
                          Cv_NoDocumento   VARCHAR2) IS
      SELECT b.sri_cod_retiva_bien, a.monto, a.base
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(b.ind_aplica_compras, 'N') = 'S' -- aplica bienes
         AND NVL(b.ind_aplica_servicios, 'N') = 'N' -- NO aplica servicios
         AND NVL(a.ind_imp_ret, 'N') = 'R'
         AND b.sri_cod_retiva_bien IS NOT NULL
         AND a.no_prove = Cv_Idproveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_NoDocumento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- Cursor que recupera Retencion IVA Bienes Por Codigo de Sustento--
    CURSOR C_RetIvaBienesSust(Cv_CodSustento VARCHAR2,
                              Cv_NoDocumento VARCHAR2) IS
      SELECT b.sri_cod_retiva_bien, a.monto, a.base
        FROM ARCP_SUSTENTO_RETENCION a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(b.ind_aplica_compras, 'N') = 'S' -- aplica bienes
         AND NVL(b.ind_aplica_servicios, 'N') = 'N' -- NO aplica servicios
         AND b.sri_cod_retiva_bien IS NOT NULL
         AND a.cod_sustento = Cv_CodSustento
         AND a.no_docu = Cv_NoDocumento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- Cursor que recupera retencion IVA Servicios --
    CURSOR C_RetIvaServicios(Cv_IdProveedor   VARCHAR2,
                             Cv_TipoDocumento VARCHAR2,
                             Cv_NoDocumento   VARCHAR2) IS
      SELECT b.sri_cod_retiva_serv, a.monto, a.base
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(b.ind_aplica_servicios, 'N') = 'S' -- aplica servicios
         AND NVL(b.ind_aplica_compras, 'N') = 'N' -- NO aplica bienes
         AND NVL(a.ind_imp_ret, 'N') = 'R'
         AND b.sri_cod_retiva_serv IS NOT NULL
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_NoDocumento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- Cursor que recupera retencion IVA Servicios Codigo de Sustento--
    CURSOR C_RetIvaServiciosSust(Cv_CodSustento VARCHAR2,
                                 Cv_NoDocumento VARCHAR2) IS
      SELECT b.sri_cod_retiva_serv, a.monto, a.base
        FROM ARCP_SUSTENTO_RETENCION a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(b.ind_aplica_servicios, 'N') = 'S' -- aplica servicios
         AND NVL(b.ind_aplica_compras, 'N') = 'N' -- NO aplica bienes
         AND b.sri_cod_retiva_serv IS NOT NULL
         AND a.cod_sustento = Cv_CodSustento
         AND a.no_docu = Cv_NoDocumento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- Cursor que recupera codigo retencion iva 100% --
    CURSOR C_RetIvaBienesServicios(Cv_IdProveedor   VARCHAR2,
                                   Cv_TipoDocumento VARCHAR2,
                                   Cv_Documento     VARCHAR2) IS
      SELECT NVL(b.sri_cod_retiva_bien, b.sri_cod_retiva_serv) sri_cod_retiva_bienserv,
             a.monto,
             a.base
        FROM arcpti a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(b.ind_aplica_compras, 'N') = 'S' -- aplica bienes
         AND NVL(b.ind_aplica_servicios, 'N') = 'S' -- aplica servicios
         AND NVL(a.ind_imp_ret, 'N') = 'R'
         AND (b.sri_cod_retiva_bien IS NOT NULL OR
             b.sri_cod_retiva_serv IS NOT NULL)
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_Documento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- Cursor que recupera codigo retencion iva 100% por Codigo de Sustento--
    CURSOR C_RetIvaBienesServiciosSust(Cv_CodSustento VARCHAR2,
                                       Cv_Documento   VARCHAR2) IS
      SELECT NVL(b.sri_cod_retiva_bien, b.sri_cod_retiva_serv) sri_cod_retiva_bienserv,
             a.monto,
             a.base
        FROM ARCP_SUSTENTO_RETENCION a, arcgimp b
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(b.ind_aplica_compras, 'N') = 'S' -- aplica bienes
         AND NVL(b.ind_aplica_servicios, 'N') = 'S' -- aplica servicios
         AND (b.sri_cod_retiva_bien IS NOT NULL OR
             b.sri_cod_retiva_serv IS NOT NULL)
         AND a.cod_sustento = Cv_CodSustento
         AND a.no_docu = Cv_Documento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave;
  
    -- Cursor que recupera retencion impuesto a la renta --
    CURSOR C_RetImpRenta(Cv_IdProveedor   VARCHAR2,
                         Cv_TipoDocumento VARCHAR2,
                         Cv_Documento     VARCHAR2) IS
      SELECT b.sri_retimp_renta, a.monto, a.base, c.porc_retencion
        FROM arcpti a, arcgimp b, sri_ret_fuente_imp_renta c
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(a.ind_imp_ret, 'N') = 'R'
         AND b.sri_retimp_renta IS NOT NULL
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_Documento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND b.sri_retimp_renta = c.codigo;
  
    -- Cursor que recupera retencion impuesto a la renta por Codigo de sustento--
    CURSOR C_RetImpRentaSust(Cv_CodSustento VARCHAR2,
                             Cv_Documento   VARCHAR2) IS
      SELECT b.sri_retimp_renta, a.monto, a.base, c.porc_retencion
        FROM ARCP_SUSTENTO_RETENCION  a,
             arcgimp                  b,
             sri_ret_fuente_imp_renta c
       WHERE a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND b.sri_retimp_renta IS NOT NULL
         AND a.cod_sustento = Cv_CodSustento
         AND a.no_docu = Cv_Documento
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND b.sri_retimp_renta = c.codigo;
  
    -- cursor que recupera los documentos modificados por ND y NC --
    CURSOR C_ComprobanteModificado(Cv_Documento VARCHAR2) IS
      SELECT c.codigo_tipo_comprobante,
             substr(a.serie_fisico, 1, 3),
             substr(a.serie_fisico, 4, 3),
             a.no_fisico,
             a.no_autorizacion,
             a.fecha_documento
        FROM arcpmd a, arcprd b, arcptd c
       WHERE a.no_cia = Pv_NoCia
         AND b.no_docu = Cv_Documento
         AND a.no_cia = b.no_cia
         AND a.no_docu = b.no_refe
         AND a.no_cia = c.no_cia
         AND a.tipo_doc = c.tipo_doc
         AND C.CONTROLA_AUTORIZACION_SRI = 'S';
  
    -- cursor que recupera datos de factura en detalle de impuestos  --
    CURSOR C_CompRet(Cv_IdProveedor   VARCHAR2,
                     Cv_TipoDocumento VARCHAR2,
                     Cv_Documento     VARCHAR2) IS
      SELECT DISTINCT SUBSTR(a.secuencia_ret, 1, 3) serie_estab,
                      SUBSTR(a.secuencia_ret, 4, 3) punto_emision,
                      a.autorizacion
        FROM arcpti a, arcgimp b, sri_ret_fuente_imp_renta c
       WHERE a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND a.sri_retimp_renta = c.codigo
         AND a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(a.ind_imp_ret, 'N') = 'R'
         AND nvl(a.anulada, 'N') = 'N'
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_Documento
      --
      UNION
      -- se recupera de ARCPTI informacion relacionado a la retencion de IVA
      SELECT DISTINCT SUBSTR(a.secuencia_ret, 1, 3) serie_estab,
                      SUBSTR(a.secuencia_ret, 4, 3) punto_emision,
                      a.autorizacion
        FROM arcpti a, arcgimp b, sri_ret_fuente_imp_renta c
       WHERE a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND a.no_cia = Pv_NoCia
         AND NVL(b.ind_retencion, 'N') = 'S'
         AND NVL(a.ind_imp_ret, 'N') = 'R'
         AND nvl(a.anulada, 'N') = 'N'
         AND a.no_prove = Cv_IdProveedor
         AND a.tipo_doc = Cv_TipoDocumento
         AND a.no_docu = Cv_Documento;
  
    -- Verifica la existencia de retenciones 0%
    CURSOR C_ExisteRetCero(CV_Compania VARCHAR2,
                           Cv_No_Prove VARCHAR2,
                           CV_TipoDoc  VARCHAR2,
                           CV_NoDocu   VARCHAR2,
                           CV_Clave    VARCHAR2,
                           CV_NoRefe   VARCHAR2) IS
      SELECT 1
        FROM ARCPTI
       WHERE NO_CIA = Cv_compania
         AND NO_PROVE = Cv_NO_PROVE
         AND TIPO_DOC = CV_TipoDoc
         AND NO_DOCU = CV_NoDocu
         AND CLAVE = CV_CLAVE
         AND NO_REFE = CV_NoRefe;
  
    Ln_encontro number := 0;
    --
  
    --
    ln_codigo_iva sri_porc_iva.porc_iva%TYPE;
    ln_monto_iva  NUMBER;
  
    ln_codigo_ice sri_porc_ice.codigo%TYPE;
    ln_monto_ice  NUMBER;
    ln_base_ice   NUMBER;
    --
    Ln_MontoIvaBien10  NUMBER := 0;
    Ln_MontoIvaBien30  NUMBER := 0;
    Ln_MontoIvaServ20  NUMBER := 0;
    Ln_MontoIvaServ70  NUMBER := 0;
    Ln_MontoIvaServ100 NUMBER := 0;
    Ln_MinFormaPago    NUMBER := 0;
    Lr_RetFteCero      C_RetFteCero%ROWTYPE := NULL;
    Lv_SujetoRetExt    VARCHAR2(2) := 'NO';
    --
    ln_codigo_retiva_bien sri_ret_iva_bienes.codigo%TYPE;
    ln_monto_retiva_bien  NUMBER;
    ln_base_retiva_bien   NUMBER;
  
    ln_codigo_retiva_servicio sri_porc_reten_iva_serv.codigo%TYPE;
    ln_monto_retiva_servicio  NUMBER;
    ln_base_retiva_servicio   NUMBER;
  
    Ln_Id_RetIva_BienServ    sri_porc_reten_iva_serv.codigo%TYPE;
    Ln_monto_RetIva_BienServ NUMBER;
    Ln_Base_RetIva_BienServ  NUMBER;
  
    lv_retimp_renta       sri_ret_fuente_imp_renta.codigo%TYPE;
    ln_monto_retimp_renta NUMBER;
    ln_base_retimp_renta  NUMBER;
    ln_porc_renta         sri_ret_fuente_imp_renta.porc_retencion%TYPE;
  
    lv_codigo_comprobante sri_tipos_comprobantes.codigo%TYPE;
    lv_serie_modificado   arcpmd.serie_fisico%TYPE;
    lv_ptoEmi_modificado  arcpmd.serie_fisico%TYPE;
    lv_fisico_Modificado  arcpmd.no_fisico%TYPE;
    lv_autorizacion       arcpmd.no_autorizacion_comp%TYPE;
    ld_fecha_registro     DATE;
  
    lv_estab            VARCHAR2(3);
    lv_pto_emis         VARCHAR2(3);
    lv_autorizacion_ret arcpmd.no_autorizacion_comp%TYPE;
    Ld_FechaRetencion   arcpmd.fecha_retencion%TYPE;
    Lv_SecRetencion     arcpmd.comp_ret%TYPE;
  
    Ln_procesados number := 0;
    Lv_Clave      sri_log_errores.clave%type := null;
    --
  
  BEGIN
    -- se recupera el valor minimo para aplicar forma de pago --
    IF C_ParametroFormaPago%ISOPEN THEN
      CLOSE C_ParametroFormaPago;
    END IF;
    OPEN C_ParametroFormaPago(Pv_NoCia);
    FETCH C_ParametroFormaPago
      INTO Ln_MinFormaPago;
    IF C_ParametroFormaPago%NOTFOUND THEN
      Ln_MinFormaPago := 0;
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                   'Empresa: ' || Pv_NoCia,
                   'No se ha configurado parametro que determina el monto minimo para el ingreso de forma de pago obligatorio');
    END IF;
    CLOSE C_ParametroFormaPago;
    --
    -- se recupera retencion fuente 0% para aquellas transacciones que no calculan fuente --
    IF C_RetFteCero%ISOPEN THEN
      CLOSE C_RetFteCero;
    END IF;
    OPEN C_RetFteCero;
    FETCH C_RetFteCero
      INTO Lr_RetFteCero;
    IF C_RetFteCero%NOTFOUND THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                   'Empresa: ' || Pv_NoCia,
                   'No se ha configurado Retencion Fuente Cero (0%) en catalogo de impuestos.');
      Lr_RetFteCero := NULL;
    END IF;
    CLOSE C_RetFteCero;
  
    -- se recupera las transacciones de compras --
    FOR i IN C_Compras LOOP
    
      -- se inicializa la variable que guarda PK que registrara error en caso de presentarse --
      Lv_Clave := 'Doc Interno: ' || i.no_docu || ', Serie: ' ||
                  i.serie_fisico || ', Nofisico: ' || i.no_fisico;
    
      -- inicializacion de variables --
      ln_codigo_iva := 0;
      ln_monto_iva  := 0;
      ln_codigo_ice := 0;
      ln_monto_ice  := 0;
      ln_base_ice   := 0;
    
      Ln_MontoIvaBien10  := 0;
      Ln_MontoIvaBien30  := 0;
      Ln_MontoIvaServ20  := 0;
      Ln_MontoIvaServ70  := 0;
      Ln_MontoIvaServ100 := 0;
      Lv_SujetoRetExt    := 'NO';
    
      ln_codigo_retiva_bien := 0;
      ln_monto_retiva_bien  := 0;
      ln_base_retiva_bien   := 0;
    
      ln_codigo_retiva_servicio := 0;
      ln_monto_retiva_servicio  := 0;
      ln_base_retiva_servicio   := 0;
    
      Ln_Id_RetIva_BienServ    := 0;
      Ln_monto_RetIva_BienServ := 0;
      Ln_Base_RetIva_BienServ  := 0;
    
      lv_retimp_renta       := NULL;
      ln_monto_retimp_renta := NULL;
      ln_base_retimp_renta  := NULL;
      ln_porc_renta         := NULL;
    
      lv_codigo_comprobante := NULL;
      lv_serie_modificado   := NULL;
      lv_ptoEmi_modificado  := NULL;
      lv_fisico_Modificado  := NULL;
      lv_autorizacion       := NULL;
      ld_fecha_registro     := NULL;
    
      lv_estab            := NULL;
      lv_pto_emis         := NULL;
      lv_autorizacion_ret := NULL;
      Ld_FechaRetencion   := NULL;
      Lv_SecRetencion     := NULL;
      --
      -- Recupera el codigo de iva y monto iva
      IF C_Iva%ISOPEN THEN
        CLOSE C_Iva;
      END IF;
      --
      OPEN C_Iva(i.no_prove, i.tipo_doc, i.no_docu);
      FETCH C_Iva
        INTO ln_codigo_iva, ln_monto_iva;
      CLOSE C_Iva;
      --
    
      --
      IF i.identificador = 'S' THEN
        IF C_IvaSust%ISOPEN THEN
          CLOSE C_IvaSust;
        END IF;
        --
        OPEN C_IvaSust(i.no_docu, i.codigo_sustento);
        FETCH C_IvaSust
          INTO ln_monto_iva;
        CLOSE C_IvaSust;
      END IF;
      --
    
      -- Recupera el codigo de ice y monto ice
      IF C_Ice%ISOPEN THEN
        CLOSE C_Ice;
      END IF;
      --
      OPEN C_Ice(i.no_prove, i.tipo_doc, i.no_docu);
      FETCH C_Ice
        INTO ln_codigo_ice, ln_monto_ice, ln_base_ice;
      CLOSE C_Ice;
    
      IF i.identificador = 'N' THEN
        -----------------------------------------
        --se recupera monto ret iva bienes 10% --
        IF C_MontoRetIvaBienes%ISOPEN THEN
          CLOSE C_MontoRetIvaBienes;
        END IF;
        --
        OPEN C_MontoRetIvaBienes('9', -- cod ret iva 10%
                                 i.no_docu,
                                 i.no_cia);
        FETCH C_MontoRetIvaBienes
          INTO Ln_MontoIvaBien10;
        IF C_MontoRetIvaBienes%NOTFOUND THEN
          Ln_MontoIvaBien10 := 0;
        END IF;
        CLOSE C_MontoRetIvaBienes;
      
        -----------------------------------------
        --se recupera monto ret iva bienes 30% --
        IF C_MontoRetIvaBienes%ISOPEN THEN
          CLOSE C_MontoRetIvaBienes;
        END IF;
        --
        OPEN C_MontoRetIvaBienes('1', -- cod ret iva 30%
                                 i.no_docu,
                                 i.no_cia);
        FETCH C_MontoRetIvaBienes
          INTO Ln_MontoIvaBien30;
        IF C_MontoRetIvaBienes%NOTFOUND THEN
          Ln_MontoIvaBien30 := 0;
        END IF;
        CLOSE C_MontoRetIvaBienes;
        --------------------------------------------
      ELSE
        --se recupera monto ret iva bienes 10% --
        IF C_MontoRetIvaBienesSust%ISOPEN THEN
          CLOSE C_MontoRetIvaBienesSust;
        END IF;
        --
        OPEN C_MontoRetIvaBienesSust('9', -- cod ret iva 10%
                                     i.codigo_sustento,
                                     i.no_docu,
                                     i.no_cia);
        FETCH C_MontoRetIvaBienesSust
          INTO Ln_MontoIvaBien10;
        IF C_MontoRetIvaBienesSust%NOTFOUND THEN
          Ln_MontoIvaBien10 := 0;
        END IF;
        CLOSE C_MontoRetIvaBienesSust;
      
        -----------------------------------------
        --se recupera monto ret iva bienes 30% --
        IF C_MontoRetIvaBienesSust%ISOPEN THEN
          CLOSE C_MontoRetIvaBienesSust;
        END IF;
        --
        OPEN C_MontoRetIvaBienesSust('1', -- cod ret iva 30%
                                     i.codigo_sustento,
                                     i.no_docu,
                                     i.no_cia);
        FETCH C_MontoRetIvaBienesSust
          INTO Ln_MontoIvaBien30;
        IF C_MontoRetIvaBienesSust%NOTFOUND THEN
          Ln_MontoIvaBien30 := 0;
        END IF;
        CLOSE C_MontoRetIvaBienesSust;
      END IF;
      --------------------------------------------
    
      IF i.identificador = 'N' THEN
        --se recupera monto ret iva servicios 20% --
        IF C_MontoRetIvaServicios%ISOPEN THEN
          CLOSE C_MontoRetIvaServicios;
        END IF;
        --
        OPEN C_MontoRetIvaServicios('10', -- cod ret iva serv 20%
                                    i.no_docu,
                                    i.no_cia);
        FETCH C_MontoRetIvaServicios
          INTO Ln_MontoIvaServ20;
        IF C_MontoRetIvaServicios%NOTFOUND THEN
          Ln_MontoIvaServ20 := 0;
        END IF;
        CLOSE C_MontoRetIvaServicios;
      
        --------------------------------------------
        --se recupera monto ret iva servicios 70% --
        IF C_MontoRetIvaServicios%ISOPEN THEN
          CLOSE C_MontoRetIvaServicios;
        END IF;
        --
        OPEN C_MontoRetIvaServicios('2', -- cod ret iva serv 70%
                                    i.no_docu,
                                    i.no_cia);
        FETCH C_MontoRetIvaServicios
          INTO Ln_MontoIvaServ70;
        IF C_MontoRetIvaServicios%NOTFOUND THEN
          Ln_MontoIvaServ70 := 0;
        END IF;
        CLOSE C_MontoRetIvaServicios;
      
        ---------------------------------------------
        --se recupera monto ret iva servicios 100% --
        IF C_MontoRetIvaServicios%ISOPEN THEN
          CLOSE C_MontoRetIvaServicios;
        END IF;
        --
        OPEN C_MontoRetIvaServicios('3', -- cod ret iva serv 100%
                                    i.no_docu,
                                    i.no_cia);
        FETCH C_MontoRetIvaServicios
          INTO Ln_MontoIvaServ100;
        IF C_MontoRetIvaServicios%NOTFOUND THEN
          Ln_MontoIvaServ100 := 0;
        END IF;
        CLOSE C_MontoRetIvaServicios;
      
      ELSE
      
        --se recupera monto ret iva servicios 20% --
        IF C_MontoRetIvaServiciosSust%ISOPEN THEN
          CLOSE C_MontoRetIvaServiciosSust;
        END IF;
        --
        OPEN C_MontoRetIvaServiciosSust('10', -- cod ret iva serv 20%
                                        i.codigo_sustento,
                                        i.no_docu,
                                        i.no_cia);
        FETCH C_MontoRetIvaServiciosSust
          INTO Ln_MontoIvaServ20;
        IF C_MontoRetIvaServiciosSust%NOTFOUND THEN
          Ln_MontoIvaServ20 := 0;
        END IF;
        CLOSE C_MontoRetIvaServiciosSust;
      
        --------------------------------------------
        --se recupera monto ret iva servicios 70% --
        IF C_MontoRetIvaServiciosSust%ISOPEN THEN
          CLOSE C_MontoRetIvaServiciosSust;
        END IF;
        --
        OPEN C_MontoRetIvaServiciosSust('2', -- cod ret iva serv 70%
                                        i.codigo_sustento,
                                        i.no_docu,
                                        i.no_cia);
        FETCH C_MontoRetIvaServiciosSust
          INTO Ln_MontoIvaServ70;
        IF C_MontoRetIvaServiciosSust%NOTFOUND THEN
          Ln_MontoIvaServ70 := 0;
        END IF;
        CLOSE C_MontoRetIvaServiciosSust;
      
      END IF;
    
      IF i.identificador = 'N' THEN
        -- se recupera retencion iva bienes
        IF C_RetIvaBienes%ISOPEN THEN
          CLOSE C_RetIvaBienes;
        END IF;
        --
        OPEN C_RetIvaBienes(i.no_prove, i.tipo_doc, i.no_docu);
        FETCH C_RetIvaBienes
          INTO ln_codigo_retiva_bien,
               ln_monto_retiva_bien,
               ln_base_retiva_bien;
        CLOSE C_RetIvaBienes;
      
        -- se recupera retencion iva servicios
        IF C_RetIvaServicios%ISOPEN THEN
          CLOSE C_RetIvaServicios;
        END IF;
        --
        OPEN C_RetIvaServicios(i.no_prove, i.tipo_doc, i.no_docu);
        FETCH C_RetIvaServicios
          INTO ln_codigo_retiva_servicio,
               ln_monto_retiva_servicio,
               ln_base_retiva_servicio;
        CLOSE C_RetIvaServicios;
      
        -- se recupera retencion iva 100%
        IF C_RetIvaBienesServicios%ISOPEN THEN
          CLOSE C_RetIvaBienesServicios;
        END IF;
        --
        OPEN C_RetIvaBienesServicios(i.no_prove, i.tipo_doc, i.no_docu);
        FETCH C_RetIvaBienesServicios
          INTO Ln_Id_RetIva_BienServ,
               Ln_monto_RetIva_BienServ,
               Ln_Base_RetIva_BienServ;
        CLOSE C_RetIvaBienesServicios;
      
        -- se busca retencion impuesto renta
        IF C_RetImpRenta%ISOPEN THEN
          CLOSE C_RetImpRenta;
        END IF;
        --
        OPEN C_RetImpRenta(i.no_prove, i.tipo_doc, i.no_docu);
        FETCH C_RetImpRenta
          INTO lv_retimp_renta,
               ln_monto_retimp_renta,
               ln_base_retimp_renta,
               ln_porc_renta;
        CLOSE C_RetImpRenta;
      
      ELSE
        -- se recupera retencion iva bienes
        IF C_RetIvaBienesSust%ISOPEN THEN
          CLOSE C_RetIvaBienesSust;
        END IF;
        --
        OPEN C_RetIvaBienesSust(i.codigo_sustento, i.no_docu);
        FETCH C_RetIvaBienesSust
          INTO ln_codigo_retiva_bien,
               ln_monto_retiva_bien,
               ln_base_retiva_bien;
        CLOSE C_RetIvaBienesSust;
      
        -- se recupera retencion iva servicios
        IF C_RetIvaServiciosSust%ISOPEN THEN
          CLOSE C_RetIvaServiciosSust;
        END IF;
        --
        OPEN C_RetIvaServiciosSust(i.codigo_sustento, i.no_docu);
        FETCH C_RetIvaServiciosSust
          INTO ln_codigo_retiva_servicio,
               ln_monto_retiva_servicio,
               ln_base_retiva_servicio;
        CLOSE C_RetIvaServiciosSust;
      
        -- se recupera retencion iva 100%
        IF C_RetIvaBienesServiciosSust%ISOPEN THEN
          CLOSE C_RetIvaBienesServiciosSust;
        END IF;
        --
        OPEN C_RetIvaBienesServiciosSust(i.codigo_sustento, i.no_docu);
        FETCH C_RetIvaBienesServiciosSust
          INTO Ln_Id_RetIva_BienServ,
               Ln_monto_RetIva_BienServ,
               Ln_Base_RetIva_BienServ;
        CLOSE C_RetIvaBienesServiciosSust;
      
        -- se busca retencion impuesto renta
        IF C_RetImpRentaSust%ISOPEN THEN
          CLOSE C_RetImpRentaSust;
        END IF;
        --
        OPEN C_RetImpRentaSust(i.codigo_sustento, i.no_docu);
        FETCH C_RetImpRentaSust
          INTO lv_retimp_renta,
               ln_monto_retimp_renta,
               ln_base_retimp_renta,
               ln_porc_renta;
        CLOSE C_RetImpRentaSust;
      
      END IF;
    
      -- solo si se ha aplicado retencion al documento --
      IF NVL(i.tot_ret, 0) > 0 THEN
        IF C_CompRet%ISOPEN THEN
          CLOSE C_CompRet;
        END IF;
        --
        OPEN C_CompRet(i.no_prove, i.tipo_doc, i.no_docu);
        FETCH C_CompRet
          INTO lv_estab, lv_pto_emis, lv_autorizacion_ret;
        CLOSE C_CompRet;
        --
        IF lv_estab IS NOT NULL THEN
          IF i.fecha_retencion IS NOT NULL THEN
            Ld_FechaRetencion := i.fecha_retencion;
          ELSE
            Ld_FechaRetencion := i.Fecha;
          END IF;
          --
          Lv_SecRetencion := i.comp_ret;
          --
        END IF;
      
      ELSE
        lv_estab            := null;
        lv_pto_emis         := null;
        lv_autorizacion_ret := null;
      END IF;
    
      -- se busca documento modificando si no tiene se garaba con valores defecto --
      IF C_ComprobanteModificado%ISOPEN THEN
        CLOSE C_ComprobanteModificado;
      END IF;
      --
      OPEN C_ComprobanteModificado(i.no_docu);
      FETCH C_ComprobanteModificado
        INTO lv_codigo_comprobante,
             lv_serie_modificado,
             lv_ptoEmi_modificado,
             lv_fisico_Modificado,
             lv_autorizacion,
             ld_fecha_registro;
      --
      IF C_ComprobanteModificado%NOTFOUND THEN
        lv_codigo_comprobante := NULL;
        lv_serie_modificado   := '000';
        lv_ptoEmi_modificado  := '000';
        lv_fisico_Modificado  := '000000000';
        lv_autorizacion       := '0000000000';
        ld_fecha_registro     := NULL;
      END IF;
    
      CLOSE C_ComprobanteModificado;
    
      -- se valida que todo documento con retenciones tenga comprobante de retencion.
      IF i.comp_ret IS NULL AND ln_monto_retimp_renta > 0 THEN
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                     Lv_Clave,
                     'El documento con valor de retencion mayor a cero y  sin numero de comprobante de retencion asignado');
      END IF;
    
      IF ((NVL(ln_base_retiva_bien, 0) + NVL(ln_base_retiva_servicio, 0) +
         NVL(Ln_Base_RetIva_BienServ, 0)) > 0) AND
         (NVL(ln_monto_iva, 0) > 0) AND (NVL(i.tot_imp, 0) > 0) THEN
        --- Valida que si la base de retencion de IVA (bien y servicio) es diferente al monto de
        IF (NVL(ln_base_retiva_bien, 0) + NVL(ln_base_retiva_servicio, 0) +
           NVL(Ln_Base_RetIva_BienServ, 0)) != NVL(i.tot_imp, 0) THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                       Lv_Clave,
                       'La base retencion IVA (bien): ' ||
                       NVL(ln_base_retiva_bien, 0) ||
                       ' mas la base retencion IVA (servicios): ' ||
                       NVL(ln_base_retiva_servicio, 0) ||
                       ' mas la base retencion IVA 100%: ' ||
                       NVL(Ln_Base_RetIva_BienServ, 0) ||
                       ', debe ser igual a la base IVA (Monto Impuesto): ' ||
                       NVL(i.tot_imp, 0));
        END IF;
      END IF;
    
      -- codigo pertenece a COMPRAS - PASAPORTE
      IF i.sri_sec_trans = '03' THEN
        IF i.tipo_provee_extranjero IS NULL THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                       'Proveedor ' || i.no_prove || ' - ' || i.nombre,
                       'Proveedor es extranjero y no se le ha asignado tipo Proveedor.');
        END IF;
      END IF;
      --
      -- Si es proveedor extranjero y su pais no maneja convenio doble tributacion --
      -- se valida si es sujeto a retencion --
      IF i.pago_local_exterior != '01' AND
         i.convenio_doble_tributacion = 'NO' then
        -- si aplico retenciones entonces esta sujeto a retencion
        IF i.totalbaseretfte > 0 THEN
          Lv_SujetoRetExt := 'SI';
        END IF;
      ELSE
        -- para proveedores locales el valor defecto es NA
        Lv_SujetoRetExt := 'NA';
      END IF;
    
      -- se inserta registro en estructura sri compras --
      BEGIN
      
        INSERT INTO SRI_COMPRAS
          (CODIGO_SUST_TRIB,
           TRANS_DERECHO_DEV_IVA,
           TIPO_IDENT_PROV,
           IDENT_PROVEEDOR,
           PROV_PARTE_RELACIONADA,
           CODIGO_TIPO_COMP,
           FECHA_REG_CONTABLE,
           NO_SERIE_ESTABLEC,
           NO_SERIE_PTO_EMISION,
           NO_SECUENCIAL,
           FECHA_EMISION_COMP_VTA,
           AUTORIZACION_COMP_VTA,
           FECHA_CADUCIDAD,
           BASE_IMPONIBLE_TARIFA_0,
           BASE_IMPONIBLE_NO_OBJETO_IVA,
           BASE_IMPONIBLE_EXCENTO_IVA,
           BASE_IMPONIBLE_GRAVADO_0,
           CODIGO_PORCENTAJE_IVA,
           MONTO_IVA,
           BASE_IMP_ICE,
           COD_PORC_ICE,
           MONTO_ICE,
           MONTO_IVA_BIENES, --
           PORC_RET_IVA_BIENES,
           MONTO_RET_IVA_BIENES,
           MONTO_IVA_SERVICIOS,
           CODIGO_PORC_RET_IVA_SERV,
           MONTO_RET_IVA_SERV,
           RET_FUENTE,
           BASE_IMPONIBLE_RENTA,
           CODIGO_PORC_RET_RENTA,
           MONTO_RETENCION_RENTA,
           SERIE_COMP_RET_ESTABLECIMIENTO,
           SERIE_COMP_RET_PTO_EMISION,
           SEC_COMP_RET,
           AUTORIZACION_COMP_RET,
           FECHA_EMISION_COMP_RET,
           TIPO_COMP_MOD_ND_NC,
           FECHA_EMISION_COMP_MODIFICADO,
           SERIE_COMP_MODIFICADO_ESTAB,
           SERIE_COMP_MODIFIC_PTO_EMISION,
           NO_SECUENCIAL_COMP_MODIFICADO,
           AUTORIZACION_COMP_MODIFICADO,
           CONTRATO_CONTRATACION,
           MONTO_TRANSACCION_TIT_ONEROSO,
           MONTO_TRANSACCION_TIT_GRATUITO,
           NO_CIA,
           NO_DOCU,
           MONTO_IVA_BIENES_SERV,
           ID_PORC_RET_IVA_BIENES_SERV,
           MONTO_RET_IVA_BIENES_SERV,
           TIPO_PROVE_EXTRANJERO,
           NOMBRE_PROV_EXTRANJERO,
           MONTO_RET_IVA_BIEN_10,
           MONTO_RET_IVA_BIEN_30,
           MONTO_RET_IVA_SERV_20,
           MONTO_RET_IVA_SERV_70,
           MONTO_RET_IVA_SERV_100,
           TOTAL_REEMBOLSO,
           PAGO_LOCAL_EXTERIOR,
           TIPO_REGIMEN_EXTERIOR,
           PAIS_PAGO_PARAISO_FISAL,
           PAIS_PAGO_REGIMEN_GENERAL,
           DENOMINACION,
           PAIS_EFECTUA_PAGO,
           CONVENIO_DOBLE_TRIBUTACION,
           SUJETO_A_RETENCION)
        VALUES
          (i.codigo_sustento, --- El campo es registrado en ARCPMD.
           i.derecho_devolucion_iva, --- El campo es registrado en ARCPMD.
           i.sri_sec_trans, --- El campo es registrado en ARGETID. Indicador si es tipo RUC, Cedula.
           SUBSTR(i.cedula, 1, 13), --- RUC o cedula del Proveedor.
           i.parte_relacionada,
           i.codigo_tipo_comprobante, --- El campo es registrado en ARCPTD.
           i.fecha, --- Fecha de registro contable es la fecha de registro del sistema.
           SUBSTR(i.serie_fisico, 1, 3), --- Tres primeros digitos son para el establecimiento.
           SUBSTR(i.serie_fisico, 4, 3), --- Tres siguientes digisots son para el punto de emision.
           SUBSTR(i.no_fisico, 1, 9), --- Numero de comprobante fisico.
           i.fecha_documento, --- Fecha de emision del comprobante.
           i.no_autorizacion, --- Numero de autorizacion del comprobante.
           i.fecha_caducidad, --- Fecha de caducidad del comprobante.
           NVL(i.BaseTarifaCero, 0), --- Valor Tarifa Cero.
           NVL(i.BaseNoObjetoIva, 0), --- Base Imponible No Objeto Iva
           NVL(i.BaseExcentoIva, 0), --- Base Imponible Excento Iva
           NVL(i.gravado, 0), --- Valor gravado.
           NVL(ln_codigo_iva, 0), --- Codigo para el IVA.
           NVL(ln_monto_iva, 0), --- Valor para el IVA.
           NVL(ln_base_ice, 0), --- Valor para la base del ICE.
           NVL(ln_codigo_ice, 0), --- Codigo para el ICE.
           NVL(ln_monto_ice, 0), --- Valor para el ICE.
           NVL(ln_base_retiva_bien, 0), --- MNA Base para el calculo de la retencion de IVA bienes.
           NVL(ln_codigo_retiva_bien, 0), --- Codigo de retencion de IVA bienes.
           NVL(ln_monto_retiva_bien, 0), --- Monto para retencion de IVA bienes.
           NVL(ln_base_retiva_servicio, 0), --- ***Debe ser el monto  del iva ----Base retencion iva servicios.
           NVL(ln_codigo_retiva_servicio, 0), --- Codigo retencion iva servicios.
           NVL(ln_monto_retiva_servicio, 0), --- Monto retencion iva servicios.
           lv_retimp_renta, --- Este campo no es obligatorio.
           ln_base_retimp_renta, --- Este campo no es obligatorio.
           ln_porc_renta, --- Este campo no es obligatorio.
           ln_monto_retimp_renta, --- Este campo no es obligatorio.
           lv_estab, --- Este campo es condicional, se convierte en obligatorio si la empresa imprime retenciones en formulario preimpreso.
           lv_pto_emis, --- Este campo es condicional, se convierte en obligatorio si la empresa imprime retenciones en formulario preimpreso.
           Lv_SecRetencion, -- i.comp_ret, --- Este campo es condicional, se convierte en obligatorio si la empresa imprime retenciones en formulario preimpreso.
           lv_autorizacion_ret, --- Este campo es condicional, se convierte en obligatorio si la empresa imprime retenciones en formulario preimpreso.
           Ld_FechaRetencion, --nvl(i.fecha_retencion, i.fecha), --- Este campo es condicional, se convierte en obligatorio si la empresa imprime retenciones en formulario preimpreso.
           lv_codigo_comprobante, --- Tipo de comprobante modificado (Factura).
           ld_fecha_registro, --- Fecha de registro del comprobante modificado
           lv_serie_modificado, -- SUBSTR(lv_serie_fisico, 1, 3), --- Numero de serie, establecimiento.
           lv_ptoEmi_modificado, -- SUBSTR(lv_serie_fisico, 4, 3), --- Numero de serie, punto de emision.
           SUBSTR(lv_fisico_Modificado, 1, 9), --- Numero fisico o secuencial del comprobante modificado.
           lv_autorizacion, --- Numero de autorizacion del comprobante modificado.
           NULL, --- Esto es para partidos politicos.
           0, --- Esto es para partidos politicos.
           0, --- Esto es para partidos politicos.
           Pv_NoCia, --- Compa\F1ia.
           i.no_docu, --- numero documento interno
           NVL(Ln_monto_RetIva_BienServ, 0), --- Base Iva 100%
           NVL(Ln_Id_RetIva_BienServ, 0), --- Codigo Retencion Iva 100%
           NVL(Ln_Base_RetIva_BienServ, 0), --- Monto retencido Iva 100%
           i.tipo_provee_extranjero, --- tipo de proveedor extranjero
           decode(i.tipo_provee_extranjero,
                  null,
                  null,
                  gek_consulta.GEF_ELIMINA_CARACTER_ESP(i.nombre)), -- Razon social de proveedor extranjero
           Ln_MontoIvaBien10, -- monto iva bien 10%
           Ln_MontoIvaBien30, -- monto iva bien 30%
           Ln_MontoIvaServ20, -- monto iva servicio 20%
           Ln_MontoIvaServ70, -- monto iva servicio 70%
           Ln_MontoIvaServ100, -- monto iva servicio 100%
           --
           nvl(i.totalreembolso, 0), -- total base imponible soporte reembolsos
           --
           i.pago_local_exterior, -- proveedor residente
           i.id_tipo_regimen, -- tipo regimen proveedor extranjero
           i.pais_pago_paraiso_fisal, -- codigo sri pais pago paraiso fiscal
           i.pais_pago_regime_general, -- codigo sri pais pago regimen general
           i.denominacion, -- denominacion regimen fiscal preferente
           i.pais_efectua_pago, -- codigo sri pais efectua pago
           i.convenio_doble_tributacion, -- aplica convenio doble tributacion
           Lv_SujetoRetExt -- sujeto a retencion porveedor extranjero.
           --
           );
      
      EXCEPTION
        WHEN dup_val_on_index THEN
          -- si se genera error se registra en log errores
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                       Lv_Clave,
                       'Registro duplado al insertar en SRI_COMPRAS. CxP #: ' ||
                       ' Sust: ' || i.codigo_sustento || ' TProv: ' ||
                       i.sri_sec_trans || ' Ident: ' ||
                       SUBSTR(i.cedula, 1, 13) || ' Comp: ' ||
                       i.codigo_tipo_comprobante || ' Est: ' ||
                       SUBSTR(i.serie_fisico, 1, 3) || ' Emis: ' ||
                       SUBSTR(i.serie_fisico, 4, 3) || ' Sec: ' ||
                       SUBSTR(i.no_fisico, 1, 7) || ' Aut: ' ||
                       SUBSTR(i.no_autorizacion, 1, 10) || ' ' || SQLERRM);
          Goto Continuar;
        WHEN OTHERS THEN
          -- si se genera error se registra en log errores
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                       Lv_Clave,
                       'Error no controlado al insertar en SRI_COMPRAS: ' ||
                       SQLERRM);
          Goto Continuar;
      END;
    
      -- se valida si es necesario ingresar forma pago por defecto --
      IF i.total_comprobante > Ln_MinFormaPago AND -- factura cumple con minimo a ingresar forma pago
         NVL(Ln_MinFormaPago, 0) > 0 AND -- existe parametro minimo forma pago
         NVL(i.cantidad_forma_pagos, 0) = 0 THEN
        -- documnto sin forma pago
        --
        BEGIN
          -- se inserta valor por defecto de forma de pago --
          INSERT INTO CP_FORMA_PAGO_DOC
            (ID_COMPANIA, ID_DOCUMENTO, ID_FORMA_PAGO, TIPO_DOCUMENTO)
          VALUES
            (i.no_cia,
             i.no_docu,
             '02', -- forma pago por defecto
             i.tipo_doc);
          --
        EXCEPTION
          WHEN OTHERS THEN
            -- Se registra error en log de errores --
            P_GENERA_LOG(Pv_NoCia,
                         'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                         Lv_Clave,
                         'Error no controlado al insertar en CP_FORMA_PAGO_DOC: ' ||
                         SQLERRM);
            Goto Continuar;
        END;
      END IF;
    
      IF C_ExisteRetCero%ISOPEN THEN
        CLOSE C_ExisteRetCero;
      END IF;
    
      OPEN C_ExisteRetCero(i.no_cia,
                           i.no_prove,
                           i.tipo_doc,
                           i.no_docu,
                           Lr_RetFteCero.Clave,
                           i.no_docu);
      FETCH C_ExisteRetCero
        INTO Ln_encontro;
      CLOSE C_ExisteRetCero;
    
      -- se valida que las bases retencion fuente cuadren con base imponible documento --
      IF ((NVL(i.basetarifacero, 0) + NVL(i.basenoobjetoiva, 0) +
         NVL(i.baseexcentoiva, 0) + NVL(i.gravado, 0)) -
         nvl(I.Totalbaseretfte, 0)) > 0 AND -- No se a aplicado total retencion fuente
         i.codigo_tipo_comprobante != '4' AND -- No es Nota Credito
         i.codigo_tipo_comprobante != '5' AND -- No es Nota debito
         i.ingresa_reembolso = 'N' AND -- No es documento Reembolso
         nvl(i.TotalReembolso, 0) = 0 AND -- No tiene reembolsos ingresados
         Ln_encontro = 1 THEN
        -- se verifica si se recupero ret fuente 0% --
        IF NVL(Lr_RetFteCero.Clave, 0) = 0 THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                       Lv_Clave,
                       'No se puede registrar Retencion Fuente 0% a documento ' ||
                       i.no_docu);
          Goto Continuar;
        END IF;
      
        BEGIN
          -- se inserta retencion 0% --
          INSERT INTO ARCPTI
            (NO_CIA,
             NO_PROVE,
             TIPO_DOC,
             NO_DOCU,
             CLAVE,
             PORCENTAJE,
             MONTO,
             IND_IMP_RET,
             BASE,
             COMPORTAMIENTO,
             NO_REFE,
             SECUENCIA_RET,
             SRI_RETIMP_RENTA,
             AUTORIZACION)
          VALUES
            (i.no_cia,
             i.no_prove,
             i.tipo_doc,
             i.no_docu,
             Lr_RetFteCero.Clave,
             0,
             0,
             'R',
             (NVL(i.basetarifacero, 0) + NVL(i.basenoobjetoiva, 0) +
             NVL(i.baseexcentoiva, 0) + NVL(i.gravado, 0)) -
             nvl(I.Totalbaseretfte, 0),
             'E',
             i.no_docu,
             I.COMP_RET_SERIE || I.COMP_RET,
             Lr_RetFteCero.Sri_Retimp_Renta,
             I.NO_AUTORIZACION_COMP);
        EXCEPTION
          WHEN OTHERS THEN
            -- si se gerena error se regostra en log de errore  --
            P_GENERA_LOG(Pv_NoCia,
                         'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                         Lv_Clave,
                         'Error no controlado al insertar en ARCPTI: ' ||
                         SQLERRM);
            Goto Continuar;
        END;
        --
      END IF;
    
      <<Continuar>>
      Ln_encontro   := 0;
      Ln_procesados := Ln_procesados + 1;
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXP',
                   Lv_Clave,
                   'Error no controlado en P_INFORMACION_CXP.P_INFORMACION_CXP. ' ||
                   SQLERRM);
      ROLLBACK;
  END P_INFORMACION_CXP;

  /**
  * Documentacion para P_INFORMACION_CXC
  * Procedimiento que recupera informacion de ventas y lo registra en temporales de SRI
  * el total de las facturas declaradas debe coincidir con reporte Total facturado (RFA60_03)
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @param Pv_NoCia       IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso IN VARCHAR2 Recibe anio proceso
  * @param Pv_MesProceso  IN VARCHAR2 Recibe mes proceso
  */
  PROCEDURE P_INFORMACION_CXC(Pv_NoCia       IN VARCHAR2,
                              Pv_AnioProceso IN VARCHAR2,
                              Pv_MesProceso  IN VARCHAR2) IS
    -- recupera los totales facturados por clientes
    CURSOR C_Ventas IS
      SELECT b.cedula,
             b.tipo_id_tributario,
             SUM(NVL(a.tot_lin, 0) - NVL(a.descuento, 0)) subtotal,
             SUM(a.impuesto) iva,
             COUNT(*) total_comprobantes_emitidos,
             b.parte_relacionada
        FROM arfafe a, arccmc b, arfact c
       WHERE a.no_cia = Pv_NoCia
         AND NVL(a.ind_anu_dev, 'X') != 'A'
         AND a.estado != 'P'
         AND c.ind_fac_dev = 'F'
         AND TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND a.no_cia = b.no_cia
         AND a.grupo = b.grupo
         AND a.no_cliente = b.no_cliente
         AND a.no_cia = c.no_cia
         AND a.tipo_doc = c.tipo
       GROUP BY b.cedula, b.tipo_id_tributario, b.parte_relacionada;
  
    -- recupera los totales devoluciones por clientes
    CURSOR C_DevVentas IS
      SELECT cedula,
             tipo_id_tributario,
             parte_relacionada,
             SUM(NVL(subtotal, 0)) subtotal,
             SUM(NVL(iva, 0)) iva,
             SUM(NVL(gravado, 0)) gravado,
             SUM(NVL(exento, 0)) exento,
             COUNT(*) total_comprobantes_emitidos
        FROM v_dev_ventas_sri
       WHERE no_cia = Pv_NoCia
         AND mes_anio = TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
       GROUP BY cedula, tipo_id_tributario, parte_relacionada;
  
    -- recupera tipo de identificacion tributaria
    CURSOR C_Identif(Cv_codigo VARCHAR2) IS
      SELECT e.codigo identificador
        FROM argetid d, sri_secuenciales_transacciones e
       WHERE d.codigo = Cv_codigo
         AND d.sri_ident = e.codigo_identificacion
         AND e.codigo_tipo_trans = '2'; --- ventas
  
    -- Para el caso de retenciones (IVA o FUENTE), debo recuperar en base a los cobros efectuados, ya que en ese movimiento se registran las retenciones ANR 08/10/2009
    -- Podria ser que no solo en los cobros se registre retenciones al IVA o retenciones en la FUENTE, es por esto que me verifico en todos los movimientos
  
    -- Para retenciones creo tipos de comprobante 18 pero sin valor en gravado, excento e IVA porque pueden ser retenciones que se recuperen
    -- el mismo mes, como retenciones que se recuperan en meses posteriores ANR 08/10/2009
  
    CURSOR C_VentasRetenciones IS
      SELECT DISTINCT a.tipo_doc,
                      b.grupo,
                      b.no_cliente,
                      b.parte_relacionada,
                      b.cedula,
                      e.codigo identificador
        FROM arccmd                         a,
             arccmc                         b,
             arcctd                         c,
             argetid                        d,
             sri_secuenciales_transacciones e
       WHERE a.no_cia = Pv_NoCia
         AND a.estado != 'P'
         AND NVL(a.anulado, 'N') = 'N'
         AND NVL(a.tot_ret, 0) > 0 --- Tiene retenciones
         AND TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND c.codigo_tipo_comprobante IN
             (SELECT codigo_tipo_comp
                FROM sri_rel_tipo_trans_tipo_comp
               WHERE codigo_tipo_trans = '2') --- corresponde a VENTAS
         AND e.codigo_tipo_trans = '2'
         AND a.no_cia = b.no_cia
         AND a.grupo = b.grupo
         AND a.no_cliente = b.no_cliente
         AND a.no_cia = c.no_cia
         AND a.tipo_doc = c.tipo
         AND b.tipo_id_tributario = d.codigo
         AND d.sri_ident = e.codigo_identificacion
      --
      UNION
      --
      SELECT DISTINCT a.tipo_doc,
                      b.grupo,
                      b.no_cliente,
                      b.parte_relacionada,
                      b.cedula,
                      e.codigo identificador
        FROM arccmd                         a,
             arccmc                         b,
             arcctd                         c,
             argetid                        d,
             sri_secuenciales_transacciones e
       WHERE a.no_cia = Pv_NoCia
         AND a.estado != 'P'
         AND NVL(a.anulado, 'N') = 'N'
         AND NVL(a.tot_ret, 0) > 0 --- Tiene retenciones
         AND TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND e.codigo_tipo_trans = '2'
         AND a.no_cia = b.no_cia
         AND a.grupo = b.grupo
         AND a.no_cliente = b.no_cliente
         AND a.no_cia = c.no_cia
         AND a.tipo_doc = c.tipo
         AND c.ind_nc_retencion = 'S'
         AND b.tipo_id_tributario = d.codigo
         AND d.sri_ident = e.codigo_identificacion;
  
    -- se recupera retenciones iva
    CURSOR C_RetencionIva(Cv_Grupo         VARCHAR2,
                          Cv_IdCliente     VARCHAR2,
                          Cv_TipoDocumento VARCHAR2) IS
      SELECT NVL(SUM(a.monto), 0) ret_iva
        FROM arccti a, arcgimp b, arccmd c
       WHERE a.no_cia = Pv_NoCia
         AND a.grupo = Cv_Grupo
         AND a.no_cliente = Cv_IdCliente
         AND c.tipo_doc = Cv_TipoDocumento
         AND c.estado != 'P'
         AND NVL(c.anulado, 'N') = 'N'
         AND TO_NUMBER(TO_CHAR(c.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND a.ind_imp_ret = 'R'
         AND b.ind_retencion = 'S'
         AND NVL(b.retencion_iva, 'N') = 'S'
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND a.no_cia = c.no_cia
         AND a.no_docu = c.no_docu;
  
    -- se recupera retenciones fuente
    CURSOR C_RetencionFuente(Cv_Grupo         VARCHAR2,
                             Cv_IdCliente     VARCHAR2,
                             Cv_TipoDocumento VARCHAR2) IS
      SELECT NVL(SUM(a.monto), 0) ret_fuente
        FROM arccti a, arcgimp b, arccmd c
       WHERE a.no_cia = Pv_NoCia
         AND a.grupo = Cv_Grupo
         AND a.no_cliente = Cv_IdCliente
         AND c.tipo_doc = Cv_TipoDocumento
         AND c.estado != 'P'
         AND NVL(c.anulado, 'N') = 'N'
         AND TO_NUMBER(TO_CHAR(c.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND a.ind_imp_ret = 'R'
         AND b.ind_retencion = 'S'
         AND NVL(b.retencion_fuente, 'N') = 'S'
         AND a.no_cia = b.no_cia
         AND a.clave = b.clave
         AND a.no_cia = c.no_cia
         AND a.no_docu = c.no_docu;
  
    -- recupera historico IVA
    CURSOR C_IvaHistorico IS
      SELECT porc_iva
        FROM sri_porc_iva
       WHERE (TO_DATE('01' || Pv_MesProceso || Pv_AnioProceso, 'DD/MM/YYYY')) BETWEEN
             fecha_inicio AND NVL(fecha_fin, TRUNC(SYSDATE))
         AND porc_iva > 0;
  
    -- Rcupera retenciones de facturas
    CURSOR C_RetFacturas(Cv_Identificacion VARCHAR2) IS
      SELECT SUM(decode(e.retencion_iva, 'S', a.monto, 0)) RetIva,
             SUM(decode(e.retencion_fuente, 'S', a.monto, 0)) RetFte
        FROM arccti a, arccrd b, arccmd c, arccmc d, arcgimp e
       WHERE a.no_docu = b.no_docu
         AND a.tipo_doc = b.tipo_doc
         AND a.no_cia = b.no_cia
         AND b.no_refe = c.no_docu
         AND b.tipo_refe = c.tipo_doc
         AND b.no_cia = c.no_cia
         AND a.no_cliente = d.no_cliente
         AND a.grupo = d.grupo
         AND a.no_cia = d.no_cia
         AND a.clave = e.clave
         AND a.no_cia = e.no_cia
         AND to_number(to_char(c.fecha, 'mmyyyy')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND a.no_cia = Pv_NoCia
         AND d.cedula = Cv_Identificacion
         AND e.ind_retencion = 'S';
  
    Ln_gravado          NUMBER := 0;
    Ln_exento           NUMBER := 0;
    Lv_cedula           Arccmc.cedula%TYPE;
    Ln_retencion_iva    Arccti.monto%TYPE;
    Ln_retencion_fuente Arccti.monto%TYPE;
    Ln_RetIva           NUMBER := 0;
    Ln_RetFte           NUMBER := 0;
  
    Lv_identificador sri_ventas.tipo_ident_cliente%TYPE;
  
    Ln_porc_iva   sri_porc_iva.porc_iva%TYPE;
    Lv_Clave      SRI_LOG_ERRORES.CLAVE%TYPE := NULL;
    Ln_Procesados NUMBER := 0;
  
  BEGIN
  
    /**** Proceso las ventas ***/
    FOR i IN C_Ventas LOOP
      --
      Lv_Clave := 'cliente: ' || i.cedula || ', tipo: ' ||
                  i.tipo_id_tributario;
      --
      -- se valida tipo tributario
      IF i.tipo_id_tributario IS NULL THEN
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                     Lv_Clave,
                     'Debe ingresar el tipo_id_tributario al identificador: ' ||
                     i.cedula);
      
        Goto Continua_Ventas;
      END IF;
    
      -- se recupera identificacion
      IF C_identif%ISOPEN THEN
        CLOSE C_identif;
      END IF;
      --
      OPEN C_identif(i.tipo_id_tributario);
      FETCH C_identif
        INTO Lv_identificador;
      IF C_identif%NOTFOUND THEN
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                     Lv_Clave,
                     'No existe configurado secuencial de transaccion para identificador: ' ||
                     i.tipo_id_tributario);
        Goto Continua_Ventas;
      END IF;
      CLOSE C_identif;
    
      IF C_IvaHistorico%ISOPEN THEN
        CLOSE C_IvaHistorico;
      END IF;
      --
      -- se verifica porcentaje iva enm historico
      OPEN C_IvaHistorico;
      FETCH C_IvaHistorico
        INTO Ln_porc_iva;
      IF C_IvaHistorico%NOTFOUND THEN
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                     Lv_Clave,
                     'No existe porcentaje de iva historico registrado para el mes y anio de proceso');
        Goto Continua_Ventas;
      END IF;
      CLOSE C_IvaHistorico;
    
      --- Calculo gravado y exento en base a (cedulas, ruc, consumidor final encontrados)
      IF i.iva != 0 AND nvl(Ln_porc_iva, 0) != 0 THEN
        Ln_gravado := round(i.iva * 100 / Ln_porc_iva, 2);
      ELSE
        Ln_gravado := 0;
      END IF;
    
      IF abs(i.subtotal - Ln_gravado) < 1 THEN
        Ln_exento  := 0;
        Ln_gravado := i.subtotal;
      ELSE
        Ln_exento := i.subtotal - Ln_gravado;
      END IF;
    
      --- Le resto al valor gravado los decimales por ajustes
      IF Ln_exento < 0 THEN
        Ln_gravado := Ln_gravado - abs(Ln_exento);
        Ln_exento  := 0;
      END IF;
    
      --- Gravado mas exento no puede ser mayor al subtotal
    
      IF Ln_gravado + Ln_exento > i.subtotal THEN
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                     Lv_Clave,
                     'No cuadra gravado: ' || Ln_gravado ||
                     ' mas excento: ' || abs(Ln_exento) ||
                     ' con el subtotal : ' || i.subtotal ||
                     ' del documento.');
        Goto Continua_Ventas;
      END IF;
    
      --- El consumidor final en el DIMM solo se subo con 13 digitos
      IF i.cedula = '9999999999' THEN
        Lv_cedula := '9999999999999';
      ELSE
        Lv_cedula := i.cedula;
      END IF;
    
      -- retenciones
      IF C_RetFacturas%ISOPEN THEN
        CLOSE C_RetFacturas;
      END IF;
      --
      OPEN C_RetFacturas(Lv_cedula);
      FETCH C_RetFacturas
        INTO Ln_RetIva, Ln_RetFte;
      IF C_RetFacturas%NOTFOUND THEN
        Ln_RetIva := 0;
        Ln_RetFte := 0;
      END IF;
      CLOSE C_RetFacturas;
    
      -- se realiza el ingreso en ventas
      BEGIN
        INSERT INTO SRI_VENTAS
          (no_cia,
           tipo_ident_cliente,
           prov_parte_relacionada,
           no_ident_cliente,
           codigo_tipo_comp,
           base_imp_excento_iva,
           base_imp_gravada_iva,
           base_no_objeto_iva,
           monto_iva,
           iva_retenido,
           renta_retenido,
           total_comprobantes_emitidos,
           indicador,
           tipo_doc)
        VALUES
          (Pv_NoCia,
           Lv_identificador,
           i.parte_relacionada,
           Lv_cedula,
           '18', --- ventas
           Ln_exento,
           Ln_gravado,
           0,
           i.iva,
           nvl(Ln_RetIva, 0),
           nvl(Ln_RetFte, 0),
           i.total_comprobantes_emitidos,
           'V',
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                       Lv_Clave,
                       'Error no controlado al insertar en SRI_VENTAS. ' ||
                       sqlerrm);
          Goto Continua_Ventas;
      END;
    
      <<Continua_Ventas>>
      Ln_Procesados := Ln_Procesados + 1;
    
    END LOOP;
  
    /*** Proceso devoluciones en ventas ***/
  
    FOR i IN C_DevVentas LOOP
    
      Ln_Procesados := 0;
      Lv_Clave      := 'cliente: ' || i.cedula || ', tipo: ' ||
                       i.tipo_id_tributario;
    
      IF i.tipo_id_tributario IS NULL THEN
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                     Lv_Clave,
                     'Debe ingresar el tipo id tributario dev ventas al identificador: ' ||
                     i.cedula);
        Goto Continua_Devolucion_Ventas;
      END IF;
    
      IF C_Identif%ISOPEN THEN
        CLOSE C_Identif;
      END IF;
      --
      OPEN C_Identif(i.tipo_id_tributario);
      FETCH C_Identif
        INTO Lv_Identificador;
      IF C_Identif%NOTFOUND THEN
        CLOSE C_Identif;
        P_GENERA_LOG(Pv_NoCia,
                     'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                     Lv_Clave,
                     'No existe configurado secuencial de transaccion dev ventas para identificador: ' ||
                     i.tipo_id_tributario);
        Goto Continua_Devolucion_Ventas;
      
      ELSE
        CLOSE C_identif;
      END IF;
    
      --- El consumidor final en el DIMM solo se subo con 13 digitos
    
      IF i.cedula = '9999999999' THEN
        Lv_cedula := '9999999999999';
      ELSE
        Lv_cedula := i.cedula;
      END IF;
    
      BEGIN
        INSERT INTO SRI_VENTAS
          (no_cia,
           tipo_ident_cliente,
           no_ident_cliente,
           prov_parte_relacionada,
           codigo_tipo_comp,
           base_imp_excento_iva,
           base_imp_gravada_iva,
           base_no_objeto_iva,
           monto_iva,
           iva_retenido,
           renta_retenido,
           total_comprobantes_emitidos,
           indicador,
           tipo_doc)
        VALUES
          (Pv_NoCia,
           Lv_identificador,
           Lv_cedula,
           i.parte_relacionada,
           '4', --- notas de credito
           i.exento,
           i.gravado,
           0,
           i.iva,
           0,
           0,
           i.total_comprobantes_emitidos,
           'V',
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                       Lv_Clave,
                       'Error al insertar devolucion ventas en SRI_VENTAS: ' ||
                       SQLERRM);
          Goto Continua_Devolucion_Ventas;
      END;
    
      <<Continua_Devolucion_Ventas>>
      Ln_Procesados := Ln_Procesados + 1;
    
    END LOOP;
  
    /*** Proceso las retenciones ***/
  
    FOR i IN C_VentasRetenciones LOOP
    
      Ln_Procesados := 0;
      Lv_Clave      := 'cliente: ' || i.grupo || '-' || i.no_cliente ||
                       ', identificador: ' || i.cedula || ', tipo: ' ||
                       i.identificador;
    
      IF C_RetencionIva%ISOPEN THEN
        CLOSE C_RetencionIva;
      END IF;
      --
      OPEN C_RetencionIva(i.grupo, i.no_cliente, i.tipo_doc);
      FETCH C_RetencionIva
        INTO Ln_retencion_iva;
      IF C_RetencionIva%NOTFOUND THEN
        Ln_retencion_iva := 0;
      END IF;
      CLOSE C_RetencionIva;
    
      IF C_RetencionFuente%ISOPEN THEN
        CLOSE C_RetencionFuente;
      END IF;
      --
      OPEN C_RetencionFuente(i.grupo, i.no_cliente, i.tipo_doc);
      FETCH C_RetencionFuente
        INTO Ln_retencion_fuente;
      IF C_RetencionFuente%NOTFOUND THEN
        CLOSE C_RetencionFuente;
        Ln_retencion_fuente := 0;
      ELSE
        CLOSE C_RetencionFuente;
      END IF;
    
      --- El consumidor final en el DIMM solo se subo con 13 digitos
    
      IF i.cedula = '9999999999' THEN
        Lv_cedula := '9999999999999';
      ELSE
        Lv_cedula := i.cedula;
      END IF;
    
      BEGIN
        INSERT INTO SRI_VENTAS
          (no_cia,
           tipo_ident_cliente,
           prov_parte_relacionada,
           no_ident_cliente,
           codigo_tipo_comp,
           base_imp_excento_iva,
           base_imp_gravada_iva,
           base_no_objeto_iva,
           monto_iva,
           iva_retenido,
           renta_retenido,
           total_comprobantes_emitidos,
           indicador,
           tipo_doc)
        VALUES
          (Pv_NoCia,
           i.identificador,
           i.parte_relacionada,
           Lv_cedula,
           '18',
           0,
           0,
           0,
           0,
           Ln_retencion_iva,
           Ln_retencion_fuente,
           0,
           'R',
           i.tipo_doc);
      EXCEPTION
        WHEN OTHERS THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                       Lv_Clave,
                       'Error al insertar ventas relacionadas en SRI_VENTAS: ' ||
                       SQLERRM);
          Goto Continua_Ventas_Relacionadas;
      END;
    
      <<Continua_Ventas_Relacionadas>>
      Ln_Procesados := Ln_Procesados + 1;
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_CXC',
                   Lv_Clave,
                   'Error no controlado en P_INFORMACION_CXP.P_INFORMACION_CXC. ' ||
                   SQLERRM);
      ROLLBACK;
  END P_INFORMACION_CXC;

  /**
  * Documentacion para P_INFORMACION_ANULADOS
  * Procedimiento que recupera informacion de comprobantes anulados y lo registra en temporales de SRI
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/10/2016
  *
  * @param Pv_NoCia       IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso IN VARCHAR2 Recibe anio proceso
  * @param Pv_MesProceso  IN VARCHAR2 Recibe mes proceso
  */
  PROCEDURE P_INFORMACION_ANULADOS(Pv_NoCia       IN VARCHAR2,
                                   Pv_AnioProceso IN VARCHAR2,
                                   Pv_MesProceso  IN VARCHAR2) IS
  
    --- PROCESO PARA RECUPERAR LOS COMPROBANTES ANULADOS
    --- Recupero la transaccion, tipo de documento y proveedor
    --- Exportaciones, Ventas
  
    CURSOR C_ComprobantesAnulados IS
    -- Importaciones, Compras
      SELECT c.codigo_tipo_comprobante,
             substr(b.secuencia_ret, 1, 6) serie_fisico,
             lpad(substr(b.secuencia_ret, 7, 9), 9, '0') no_fisico,
             b.autorizacion no_autorizacion,
             b.fecha_anula
        FROM arcpmd a, arcpti b, arcptd c
       WHERE a.no_docu = b.no_docu
         AND a.no_cia = b.no_cia
         AND a.no_cia = c.no_cia
         AND a.tipo_ret = c.tipo_doc
         AND a.no_cia = Pv_NoCia
         AND TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND NVL(ind_act, 'P') != 'P'
         AND comp_ret_anulada IS NOT NULL
         AND b.anulada = 'S'
       GROUP BY c.codigo_tipo_comprobante,
                b.secuencia_ret,
                b.secuencia_ret,
                b.autorizacion,
                b.fecha_anula
      --
      UNION
      --
      SELECT b.codigo_tipo_comprobante,
             a.comp_ret_serie serie_fisico,
             lpad(a.comp_ret, 9, '0') no_fisico,
             a.no_autorizacion_comp no_autorizacion,
             a.fecha fecha_anula
        FROM arcpmd a, arcptd b
       WHERE a.no_cia = b.no_cia
         AND a.tipo_ret = b.tipo_doc
         AND a.no_cia = Pv_NoCia
         AND TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) =
             TO_NUMBER(Pv_MesProceso || Pv_AnioProceso)
         AND NVL(a.ind_act, 'P') != 'P'
         AND a.comp_ret IS NOT NULL
         AND a.anulado = 'S';
    --
    Ln_Procesados NUMBER := 0;
    Lv_Clave      SRI_LOG_ERRORES.CLAVE%TYPE := NULL;
    --
  BEGIN
  
    -- Se recupera informaci?n de los comprobantes anulados.
    FOR i IN C_ComprobantesAnulados LOOP
      Lv_Clave := 'Tipo: ' || i.codigo_tipo_comprobante || ', serie: ' ||
                  i.serie_fisico || ', no_fisico: ' || i.no_fisico ||
                  ', autorizacion: ' || i.no_autorizacion;
      BEGIN
        INSERT INTO sri_comp_anulados
          (TIPO_COMP_ANULADO,
           NO_SERIE_COMP_EST,
           NO_SERIE_COMP_PEMI,
           NO_SEC_CPTE_DESDE,
           NO_SEC_CPTE_HASTA,
           NO_AUTORIZACION_CPTE_VTA,
           FECHA_ANULA_CPTE_VTA,
           NO_CIA)
        VALUES
          (i.codigo_tipo_comprobante, --- Codigo de tipo de comprobante, se configura en ARCCTD y ARCPTD.
           SUBSTR(i.serie_fisico, 1, 3), --- Tres primeros digitos son para el establecimiento.
           SUBSTR(i.serie_fisico, 4, 3), --- Tres siguientes digisots son para el punto de emision.
           SUBSTR(i.no_fisico, 1, 9), --- Comprobante desde (No Fisico).
           SUBSTR(i.no_fisico, 1, 9), --- Comprobante desde (No Fisico).
           --       SUBSTR(i.no_autorizacion, 1, 10), --- Numero de autorizacion.
           i.no_autorizacion, --- Numero de autorizacion.09/01/2014
           i.fecha_anula, --- Fecha de anulacion del comprobante.
           Pv_NoCia); --- Compa?ia.
      EXCEPTION
        WHEN OTHERS THEN
          P_GENERA_LOG(Pv_NoCia,
                       'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_ANULADOS',
                       Lv_Clave,
                       'Error al inserta anulados en SRI_COMP_ANULADOS, ' ||
                       SQLERRM);
          GoTo Continuar_Anulados;
      END;
    
      <<Continuar_Anulados>>
      Ln_Procesados := Ln_Procesados + 1;
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_ANULADOS',
                   Lv_Clave,
                   'Error no controlado en P_INFORMACION_CXP.P_INFORMACION_ANULADOS. ' ||
                   SQLERRM);
      ROLLBACK;
  END P_INFORMACION_ANULADOS;

  /**
  * Documentacion para P_INFORMACION_DOCS_ADICIONAL
  * Procedimiento que recupera informacion de facturas cargadas de forma masiva desde modulo SRI
  *
  * @author jgilces <jgilces@telconet.ec>
  * @version 1.0 18/09/2022
  *
  * @param Pv_NoCia       IN VARCHAR2 Recibe codigo de compania
  * @param Pv_AnioProceso IN VARCHAR2 Recibe anio proceso
  * @param Pv_MesProceso  IN VARCHAR2 Recibe mes proceso
  */
  PROCEDURE P_INFORMACION_DOCS_ADICIONAL(Pv_NoCia       IN VARCHAR2,
                                         Pv_AnioProceso IN VARCHAR2,
                                         Pv_MesProceso  IN VARCHAR2) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.SRI_COMPRAS
      select '02' as CODIGO_SUST_TRIB, -- EN BASE AL ATS MANUAL DEL USUARIO
             'N' TRANS_DERECHO_DEV_IVA,
             (case length(sitd.ruc)
               when 10 then
                '02'
               when 13 then
                '01'
             end) TIPO_IDENT_PROV,
             sitd.ruc as IDENT_PROVEEDOR,
             to_number(sitd.documento_id) as IDENT_PROVEEDOR,
             sifr.fe_emision as FECHA_REG_CONTABLE,
             sitd.establecimiento NO_SERIE_ESTABLEC,
             sitd.punto_emision NO_SERIE_PTO_EMISION,
             sitd.secuencial_id NO_SECUENCIAL,
             sifr.fe_emision FECHA_EMISION_COMP_VTA,
             sac.numero_aut AUTORIZACION_COMP_VTA,
             sifr.fe_emision FECHA_CADUCIDAD,
             '0.00' BASE_IMPONIBLE_TARIFA_0,
             NVL((SELECT A.TOTAL_SIMP
                   FROM NAF47_TNET.INFO_FACTURA_RETENCION A
                  WHERE A.SECUENCIA_CARGA_ID = SAC.SECUENCIA_CARGA_ID),
                 0) BASE_IMPONIBLE_GRAVADO_0,
             '2' CODIGO_PORCENTAJE_IVA,
             NVL((SELECT A.VALOR
                   FROM NAF47_TNET.INFO_IMPUESTOS A
                  WHERE A.SECUENCIA_CARGA_ID = SAC.SECUENCIA_CARGA_ID
                    AND A.ITEM_FACTURA_ID IS NULL
                    AND A.DOC_SUSTENTO_ID IS NULL
                    AND A.SUSTENTO_ID IS NULL
                    AND A.PORCENTAJE_ID = 2),
                 0) MONTO_IVA,
             0 BASE_IMP_ICE,
             0 COD_PORC_ICE,
             0 MONTO_ICE,
             0 MONTO_IVA_BIENES,
             0 PORC_RET_IVA_BIENES,
             0 MONTO_RET_IVA_BIENES,
             0 MONTO_IVA_SERVICIOS,
             0 CODIGO_PORC_RET_IVA_SERV,
             0 MONTO_RET_IVA_SERV,
             '332' RET_FUENTE, -- USUARIO INDICO QUE LAS FACTURAS NO APLICAN RETENCION, POR ESO SE COLOCA EL CODIGO 332
             (SELECT SUM(A.BASE_IMPONIBLE)
                FROM NAF47_TNET.INFO_IMPUESTOS A
               WHERE A.SECUENCIA_CARGA_ID = SAC.SECUENCIA_CARGA_ID
                 AND A.ITEM_FACTURA_ID IS NULL
                 AND A.DOC_SUSTENTO_ID IS NULL
                 AND A.SUSTENTO_ID IS NULL
                 AND A.PORCENTAJE_ID IN (2, 6)) BASE_IMPONIBLE_RENTA,
             0 CODIGO_PORC_RET_RENTA,
             0 MONTO_RETENCION_RENTA,
             NULL SERIE_COMP_RET_ESTABLECIMIENTO,
             NULL SERIE_COMP_RET_PTO_EMISION,
             NULL SEC_COMP_RET,
             NULL AUTORIZACION_COMP_RET,
             NULL FECHA_EMISION_COMP_RET,
             NULL TIPO_COMP_MOD_ND_NC,
             NULL FECHA_EMISION_COMP_MODIFICADO,
             '000' SERIE_COMP_MODIFICADO_ESTAB,
             '000' SERIE_COMP_MODIFIC_PTO_EMISION,
             '000000000' NO_SECUENCIAL_COMP_MODIFICADO,
             '0000000000' AUTORIZACION_COMP_MODIFICADO,
             NULL CONTRATO_CONTRATACION,
             0 MONTO_TRANSACCION_TIT_ONEROSO,
             0 MONTO_TRANSACCION_TIT_GRATUITO,
             SAC.NO_CIA NO_CIA,
             SAC.SECUENCIA_CARGA_ID NO_DOCU,
             NULL tarjeta_corp,
             NULL tipo_doc,
             0 monto_iva_bienes_serv,
             0 id_porc_ret_iva_bienes_serv,
             0 monto_ret_iva_bienes_serv,
             NVL((SELECT A.BASE_IMPONIBLE
                   FROM NAF47_TNET.INFO_IMPUESTOS A
                  WHERE A.SECUENCIA_CARGA_ID = SAC.SECUENCIA_CARGA_ID
                    AND A.ITEM_FACTURA_ID IS NULL
                    AND A.DOC_SUSTENTO_ID IS NULL
                    AND A.SUSTENTO_ID IS NULL
                    AND A.PORCENTAJE_ID = 6),
                 0) base_imponible_no_objeto_iva,
             0 base_imponible_excento_iva,
             'N' prov_parte_relacionada,
             'N' comp_reembolso,
             'N' registra_reembolso,
             NULL tipo_prove_extranjero,
             NULL nombre_prov_extranjero,
             0 monto_ret_iva_bien_10,
             0 monto_ret_iva_bien_30,
             0 monto_ret_iva_serv_20,
             0 monto_ret_iva_serv_70,
             0 monto_ret_iva_serv_100,
             0 total_reembolso,
             '01' pago_local_exterior,
             NULL tipo_regimen_exterior,
             NULL pais_pago_paraiso_fisal,
             NULL pais_pago_regimen_general,
             NULL denominacion,
             'NA',
             'NA',
             'NA'
        from NAF47_TNET.INFO_ARCHIVOS_CARGADOS sac,
             NAF47_TNET.INFO_TRIBUTARIA_DOC    sitd,
             NAF47_TNET.INFO_FACTURA_RETENCION sifr
       where sac.secuencia_carga_id = sitd.secuencia_carga_id
         AND SAC.TIPO_DOCUMENTO = 'FACTURA'
         AND SAC.PERIODO_ANIO = TO_NUMBER(Pv_AnioProceso)
         AND SAC.PERIODO_MES = TO_NUMBER(Pv_MesProceso)
         AND SAC.NO_CIA = Pv_NoCia
         AND SAC.ESTADO = 'C'
         and sac.secuencia_carga_id = sifr.secuencia_carga_id;
  EXCEPTION
    WHEN OTHERS THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFORMACION_DOCS_ADICIONAL',
                   'Carga Masiva Documentos XML',
                   'Error no controlado en SRIK_PROCESA_DATOS_ATS.P_INFORMACION_DOCS_ADICIONAL: ' ||
                   SQLERRM);
      ROLLBACK;
  END;

  PROCEDURE P_INFOR_DOCS_ADICIONAL_VENTAS(Pv_NoCia       IN VARCHAR2,
                                          Pv_AnioProceso IN VARCHAR2,
                                          Pv_MesProceso  IN VARCHAR2) IS
    CURSOR C_GET_INFO_BASE IS
      SELECT DISTINCT A.NO_CIA,
                      (case length(b.ruc)
                        when 10 then
                         '05'
                        when 13 then
                         '04'
                      end) TIPO_IDENT_CLIENTE,
                      B.RUC NO_IDENT_CLIENTE,
                      '18' CODIGO_TIPO_COMP,
                      0 BASE_IMP_EXCENTO_IVA,
                      0 BASE_IMP_GRAVADA_IVA,
                      0 BASE_NO_OBJETO_IVA,
                      0 MONTO_IVA,
                      'R' INDICADOR,
                      NULL TIPO_DOC
      --A.SECUENCIA,
      --DECODE(NVL(C.PARTE_REL, 'NO'),'SI','S','NO','N') PROV_PARTE_RELACIONADA
        FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A,
             NAF47_TNET.INFO_TRIBUTARIA_DOC    B,
             NAF47_TNET.INFO_FACTURA_RETENCION C
       WHERE A.SECUENCIA_CARGA_ID = B.SECUENCIA_CARGA_ID
         AND A.SECUENCIA_CARGA_ID = C.SECUENCIA_CARGA_ID
         AND A.NO_CIA = PV_NOCIA
         AND A.PERIODO_ANIO = TO_NUMBER(Pv_AnioProceso)
         AND A.PERIODO_MES = TO_NUMBER(Pv_MesProceso)
         AND A.ESTADO = 'C'
         AND A.TIPO_DOCUMENTO = 'RETENCION';
  
    CURSOR C_GET_DOCUMENTO(CV_CLIENTE VARCHAR2) IS
      SELECT A.SECUENCIA_CARGA_ID,
             DECODE(NVL(C.PARTE_REL, 'NO'), 'SI', 'S', 'NO', 'N') PROV_PARTE_RELACIONADA
        FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A,
             NAF47_TNET.INFO_TRIBUTARIA_DOC    B,
             NAF47_TNET.INFO_FACTURA_RETENCION C
       WHERE A.SECUENCIA_CARGA_ID = B.SECUENCIA_CARGA_ID
         AND A.SECUENCIA_CARGA_ID = C.SECUENCIA_CARGA_ID
         AND A.NO_CIA = Pv_NoCia
         AND A.PERIODO_ANIO = TO_NUMBER(Pv_AnioProceso)
         AND A.PERIODO_MES = TO_NUMBER(Pv_MesProceso)
         AND A.ESTADO = 'C'
         AND A.TIPO_DOCUMENTO = 'RETENCION'
         AND C.IDENTIFICACION = CV_CLIENTE;
  
    CURSOR GET_RETENCIONES_CAB(CN_SECUENCIA NUMBER) IS
      select DISTINCT A.SUSTENTO_ID, A.DOC_SUSTENTO_ID
        from NAF47_TNET.INFO_DOCS_SUSTENTOS_RET A
       WHERE A.SECUENCIA_CARGA_ID = CN_SECUENCIA;
  
    CURSOR GET_RETENCIONES_TOTAL(CN_SECUENCIA   NUMBER,
                                 CN_COD_SUS     NUMBER,
                                 CN_COD_DOC_SUS NUMBER) IS
      select DECODE(A.ELEMENTO_ID, 1, 'RENTA', 2, 'IVA') AS TIPO,
             SUM(A.VALOR_RETENIDO) AS TOTAL
        from NAF47_TNET.INFO_RETENCIONES A
       WHERE A.SECUENCIA_CARGA_ID = CN_SECUENCIA
         AND ('X' = DECODE(CN_COD_SUS, NULL, 'X') OR
             A.SUSTENTO_ID = CN_COD_SUS)
         AND A.DOC_SUSTENTO_ID = CN_COD_DOC_SUS
       GROUP BY A.ELEMENTO_ID;
  
    LN_TOTAL_IVA   NUMBER;
    LN_TOTAL_RENTA NUMBER;
  
  BEGIN
    FOR DATO IN C_GET_INFO_BASE LOOP
      LN_TOTAL_IVA   := 0;
      LN_TOTAL_RENTA := 0;
      FOR DOCUMENTO IN C_GET_DOCUMENTO(DATO.NO_IDENT_CLIENTE) LOOP
        FOR SUSTENTO IN GET_RETENCIONES_CAB(DOCUMENTO.SECUENCIA_CARGA_ID) LOOP
          --SE OBTIENE EL TOTAL DE IMPUESTOS DE RETENCION
          FOR TOTAL IN GET_RETENCIONES_TOTAL(DOCUMENTO.SECUENCIA_CARGA_ID,
                                             SUSTENTO.SUSTENTO_ID,
                                             SUSTENTO.DOC_SUSTENTO_ID) LOOP
            IF TOTAL.TIPO = 'IVA' THEN
              LN_TOTAL_IVA := LN_TOTAL_IVA + TOTAL.TOTAL;
            ELSIF TOTAL.TIPO = 'RENTA' THEN
              LN_TOTAL_RENTA := LN_TOTAL_RENTA + TOTAL.TOTAL;
            END IF;
          END LOOP;
        END LOOP;
      END LOOP;
    
      --SE INSERTAN LOS DATOS EN VENTAS
      INSERT INTO NAF47_TNET.SRI_VENTAS
        (NO_CIA,
         TIPO_IDENT_CLIENTE,
         NO_IDENT_CLIENTE,
         CODIGO_TIPO_COMP,
         BASE_IMP_EXCENTO_IVA,
         BASE_IMP_GRAVADA_IVA,
         BASE_NO_OBJETO_IVA,
         MONTO_IVA,
         IVA_RETENIDO,
         RENTA_RETENIDO,
         TOTAL_COMPROBANTES_EMITIDOS,
         INDICADOR,
         TIPO_DOC,
         PROV_PARTE_RELACIONADA)
      VALUES
        (DATO.NO_CIA,
         DATO.TIPO_IDENT_CLIENTE,
         DATO.NO_IDENT_CLIENTE,
         DATO.CODIGO_TIPO_COMP,
         DATO.BASE_IMP_EXCENTO_IVA,
         DATO.BASE_IMP_GRAVADA_IVA,
         DATO.BASE_NO_OBJETO_IVA,
         DATO.MONTO_IVA,
         LN_TOTAL_IVA,
         LN_TOTAL_RENTA,
         1,
         DATO.INDICADOR,
         DATO.TIPO_DOC,
         'N');
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      P_GENERA_LOG(Pv_NoCia,
                   'SRIK_PROCESA_DATOS_ATS.P_INFOR_DOCS_ADICIONAL_VENTAS',
                   'Carga Masiva Documentos XML',
                   'Error no controlado en SRIK_PROCESA_DATOS_ATS.P_INFOR_DOCS_ADICIONAL_VENTAS: ' ||
                   SQLERRM);
      ROLLBACK;
  END;
  -----------------------------
  -- Procedimiento principal --
  -----------------------------
  PROCEDURE P_PROCESAR(Pv_MesProceso   IN VARCHAR2,
                       Pv_AnioProceso  IN VARCHAR2,
                       Pv_NoCia        IN VARCHAR2,
                       Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_ERRORES IS
      SELECT COUNT(A.FE_CREACION) CANTIDAD
        FROM SRI_LOG_ERRORES A
       WHERE A.NO_CIA = Pv_NoCia
         AND A.USR_CREACION = USER;
    --
    Ln_CantErrores NUMBER := 0;
    --
  BEGIN
  
    ------------------------------------------
    -- se inicializan las tablas temporales --
    ------------------------------------------
    DELETE SRI_IDENTIFICACION_INFORMANTE WHERE NO_CIA = Pv_NoCia;
    --
    DELETE SRI_VENTAS WHERE NO_CIA = Pv_NoCia;
    --
    DELETE SRI_COMPRAS WHERE NO_CIA = Pv_NoCia;
    --
    DELETE SRI_COMP_ANULADOS WHERE NO_CIA = Pv_NoCia;
    --
    ---------------------------------------
    -- se inicializa la tabla de errores --
    ---------------------------------------
    DELETE SRI_LOG_ERRORES
     WHERE USR_CREACION = USER
       AND NO_CIA = Pv_NoCia;
  
    --
    -- llena identificacion informante
    P_IDENTIFICACION_INFORMANTE(Pv_NoCia, Pv_AnioProceso, Pv_MesProceso);
    --
    -- llena datos cuentas por pagar
    P_INFORMACION_CXP(Pv_NoCia, Pv_AnioProceso, Pv_MesProceso);
  
    --
    -- llena COMPRAS adicionales de facturas cargadas de forma masiva en el sistema
    P_INFORMACION_DOCS_ADICIONAL(Pv_NoCia, Pv_AnioProceso, Pv_MesProceso);
    --llena VENTAS adicionales de facturas cargadas de forma masiva en el sistema
    P_INFOR_DOCS_ADICIONAL_VENTAS(Pv_NoCia, Pv_AnioProceso, Pv_MesProceso);
  
    --
    -- llena datos cuentas por cobrar
    P_INFORMACION_CXC(Pv_NoCia, Pv_AnioProceso, Pv_MesProceso);
    --
    -- llena anulados
    P_INFORMACION_ANULADOS(Pv_NoCia, Pv_AnioProceso, Pv_MesProceso);
  
    -- se verifican si existen errores --
    IF C_ERRORES%ISOPEN THEN
      CLOSE C_ERRORES;
    END IF;
    --
    OPEN C_ERRORES;
    FETCH C_ERRORES
      INTO Ln_CantErrores;
    IF C_ERRORES%NOTFOUND THEN
      Ln_CantErrores := 0;
    END IF;
    CLOSE C_ERRORES;
  
    IF NVL(Ln_CantErrores, 0) > 0 THEN
      Pv_MensajeError := 'Se han presentado errores al procesar datos para ATS, favor revisar LOG.';
    END IF;
  
  END P_PROCESAR;

END SRIK_PROCESA_DATOS_ATS;
/