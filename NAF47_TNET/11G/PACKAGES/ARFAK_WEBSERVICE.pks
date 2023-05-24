CREATE OR REPLACE package NAF47_TNET.ARFAK_WEBSERVICE is
/**
* Documentacion para NAF47_TNET.ARFAK_WEBSERVICE
* Paquete que contiene procesos y funciones para consumo webservices documentos electronicos
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 07/08/2017
*/

/**
* Documentacion para RESPONSEWSFACTURA
* Tipo Registro que guarda la estructura para obtener valores de retorno en cada response
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 07/08/2017
*/
  Type Lr_responseWsFactura is record
     ( rucEmpresa       arcpmp.cedula%type,
       nombreArchivo    arcpmd.nombre_archivo%type,
       estado           arcpmd.estado_sri%type,
       claveAcceso      arcpmd.clave_acceso%type,
       numAutorizacion  arcpmd.no_autorizacion_comp%type,
       detalle          varchar2(32767)   );

/**
* Documentacion para P_ValidaFactura
* Procedimiento que genera xml y envia a aprobacion sri consumiendo webservice documentos electronicos
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 07/08/2017
*/
  procedure P_ValidaFactura;

/**
* Documentacion para P_ValidaNotaCredito
* Procedimiento que genera xml y envia a aprobacion sri consumiendo webservice documentos electronicos
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 26/08/2017
*/
  procedure P_ValidaNotaCreditoDev;

/**
* Documentacion para P_ValidaNotaCredito
* Procedimiento que genera xml y envia a aprobacion sri consumiendo webservice documentos electronicos
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 26/08/2017
*/
  procedure P_ValidaNotaCreditoAnul;

/**
* Documentacion para P_ValidaNotaCreditoCxC
* Procedimiento que genera xml y envia a aprobacion sri consumiendo webservice documentos electronicos
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 18/09/2017
*/
  procedure P_ValidaNotaCreditoCxC;

/**
* Documentacion para P_respValidaFactura
* Procedimiento que procesa la respuesta del web service Documentos Electronicos
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 26/09/2017
* 
* @Param Pv_Xml          IN     XMLTYPE Recibe xml
* @Param Pr_responseFACT IN OUT arcpk_webservice.responseWsRetencion retorna registro de respuesta
*/
  procedure P_respValida ( Pv_Xml           in     XMLTYPE,
                           Pr_responseFACT  in out arfak_webservice.Lr_responseWsFactura);

/**
* Documentacion para WS_CONSULTAESTCOMPROBANTERET
* Procedimiento que consume metodo P_ConsultaEstadoFact 
* @author Martha Navarrete <mnavarrete@telconet.ec>
* @version 1.0 26/09/2017
*/
  procedure P_ConsultaEstadoFactDevAnul;

/**
* Documentacion para WS_CONSULTAESTCOMPROBANTERET
* Procedimiento que consume metodo ConsultaEstadoComprobante WebService Documentos Electronicos
* @author llindao <llindao@telconet.ec>
* @version 1.0 02/07/2014
*/
  procedure P_respConsultaEstado ( Pv_Xml          in     XMLTYPE,
                                   Pr_respConsulta in out arfak_webservice.Lr_responseWsFactura);

End ARFAK_WEBSERVICE;
/

CREATE or replace package body NAF47_TNET.ARFAK_WEBSERVICE is

  Procedure P_ValidaFactura is
    
  CURSOR C_Facturas  IS
    SELECT a.no_cia,  
      c.id_tributario rucEmpresa,
      a.no_factu,
      a.nombre_archivo nombreArchivo,
      f.usuario_ws usuario,
      f.clave_ws clave,
      XMLROOT(XMLElement("factura", XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),
                                 XMLElement("infoTributaria", XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("ruc",c.id_tributario),
                                                              XMLElement("codDoc",'01'),
                                                              XMLElement("estab",Substr(a.serie_fisico, 1, 3)),
                                                              XMLElement("ptoEmi",Substr(a.serie_fisico,4,3)), 
                                                              XMLElement("secuencial",lpad(a.no_fisico , 9, '0')),
                                                              XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(c.direccion))
                                            ),
                    XMLElement("infoFactura", XMLElement("fechaEmision",to_char(a.fecha,'dd/mm/yyyy')),
                                              XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(c.direccion)),
                                              (SELECT XMLElement("contribuyenteEspecial", X.parametro) 
                                                 FROM ge_parametros x, ge_grupos_parametros y
                                                WHERE x.id_grupo_parametro = y.id_grupo_parametro
                                                  AND x.id_aplicacion = y.id_aplicacion
                                                  AND x.id_empresa = y.id_empresa
                                                  AND x.id_grupo_parametro = 'ES_CONTRIB_ESPECIAL'
                                                  AND x.id_aplicacion = 'CP'
                                                  AND x.id_empresa = a.no_cia
                                                  AND x.estado = 'A'
                                                  AND y.estado = 'A'),
                                              XMLElement("obligadoContabilidad",'SI'),
                                              (SELECT XMLElement("tipoIdentificacionComprador", w.codigo)
                                                  FROM sri_secuenciales_transacciones w 
                                                 WHERE w.codigo_identificacion = b.tipo_id_tributario
                                                   AND w.codigo_tipo_trans = 2),
                                              XMLElement("razonSocialComprador",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                              XMLElement("identificacionComprador",b.cedula),
                                              (SELECT XMLForest ( trim(to_char(sum(d.total - a.descuento),'999999990.99'))  AS "totalSinImpuestos",
                                                                  trim(to_char(sum(d.descuento),'999999990.99')) AS "totalDescuento"  )
                                                 FROM arfafl d
                                                WHERE d.no_cia = a.no_cia
                                                  AND d.no_factu = a.no_factu),
                           (SELECT XMLElement("totalConImpuestos",
                                              XMLElement("totalImpuesto",
                                                         XMLForest ( '2' AS "codigo",
                                                                     i.sri_codigo_iva AS "codigoPorcentaje",
                                                                     trim(to_char(sum(mi.base),'999999990.99'))      AS "baseImponible",
                                                                     trim(to_char(sum(mi.Monto_Imp),'999999990.99')) AS "valor")))
                              FROM arfafli mi,
                                   arcgimp i
                             WHERE mi.clave = i.clave
                               AND mi.no_cia = i.no_cia
                               AND mi.no_factu = a.no_factu
                               AND mi.tipo_doc = a.tipo_doc
                               AND mi.no_cia = a.no_cia
                             group by i.sri_codigo_iva, mi.Porc_Imp),
                            (SELECT XMLForest ('0.00' AS "propina",
                                            trim(to_char(sum(xy.total + xy.i_ven_n - xy.descuento),'999999990.99')) AS "importeTotal",
                                               'DOLAR' AS "moneda" )
                              FROM arfafl xy
                             WHERE xy.no_cia = a.no_cia
                               AND xy.no_factu = a.no_factu),
                             --
                               ( XMLElement("pagos",
                                              XMLElement("pago",
                                                         (SELECT XMLForest( a.forma_pago_sri AS "formaPago",
                                                          trim(to_char(sum(ff.total + ff.i_ven_n - ff.descuento),'999999990.99')) AS "total")
                                                FROM arfafl ff
                                                WHERE ff.no_cia = a.no_cia
                                                  AND ff.no_factu = a.no_factu
                                                         ),
                                                         (SELECT XMLForest (cp.plazo AS "plazo")
                                                                       From arccplazos cp 
                                                                       WHERE cp.no_cia = a.no_cia
                                                                         AND cp.codigo = a.codigo_plazo),

                                                         XMLElement ("unidadTiempo", 'dias')
                                                         )
                                                 )
                                                 )
                             ),                                                                               
                            XMLElement("detalles",(SELECT XMLAgg(
                                                      XMLElement("detalle",
                                                        XMLForest 
                                                           ( r.no_arti AS "codigoPrincipal",
                                                             n.descripcion AS "descripcion",
                                                             r.pedido AS "cantidad",
                                                         trim(to_char(r.precio,'999999999999990.99'))    AS "precioUnitario",
                                                         trim(to_char(r.descuento,'999999999999990.99')) AS "descuento",
                                                  trim(to_char((( r.pedido * r.precio) - r.descuento),'999999999999990.99')) AS "precioTotalSinImpuesto"
                                                            ),
                                                             (SELECT XMLElement("impuestos",
                                                              XMLElement("impuesto",
                                                                         XMLForest('2' AS "codigo",
                                                                                   sri_codigo_iva AS "codigoPorcentaje",
                                                                                   a.porcentaje AS "tarifa"
                                                                                   ),
                                                                                   XMLElement("baseImponible", trim(to_char((r.total - r.descuento),'999999999999990.99')) ),
                                                                                   XMLElement("valor", trim(to_char((r.i_ven_n),'999999999999990.99')) )
                                                                                   ))
                                                                                   FROM arcgimp a
                                                                                   WHERE no_cia = a.no_cia
                                                                                     AND afecta = 'V'
                                                                                     AND ind_retencion = 'N'
                                                                                     AND grupo = 'IVA' 
                                                                                     AND clave in (SELECT DISTINCT(CLAVE) CLAVE 
                                                                                                     FROM ARFAFLI 
                                                                                                    WHERE NO_CIA = a.no_cia
                                                                                                      AND NO_FACTU = a.no_factu
                                                                                                      AND ROWNUM=1)
                                                            )
                                                            ))                                                           

                                                FROM arfafl r,
                                                     arinda n
                                               WHERE r.no_arti = n.no_arti
                                                 AND r.no_cia = n.no_cia
                                                 AND r.no_cia = a.no_cia
                                                 AND r.no_factu = a.no_factu)),

                    XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),b.email1),
                                                XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.telefono)),
                                                (SELECT XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),
                                                                   gek_consulta.gef_elimina_caracter_esp(t.descripcion))
                                                     FROM argecan t
                                                     WHERE t.canton = b.canton
                                                       AND t.provincia = b.provincia
                                                       AND t.pais = b.pais),
                                                XMLElement("campoAdicional", XMLAttributes('numeroCliente' AS "nombre"), b.grupo||'-'||b.no_cliente),
                                                XMLElement("campoAdicional", XMLAttributes('observacion' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(a.observ1))
                                                    )     
                     ), VERSION '1.0" encoding="UTF-8') result_xml
      FROM arfafe a,
           arccmc b,
           arcgmc c,
           ARFAMC f,
           ARFACT T
     WHERE a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
       AND a.estado = 'P' 
       AND a.estado_sri = '1'
       and a.no_cia = f.no_cia
       and f.genera_doc_electronico = 'S'
       and f.tipo_generacion = 'WS' 
       and a.no_cia = t.no_cia 
       and a.tipo_doc = t.tipo 
       and t.ind_fac_dev = 'F'
       order by a.no_cia, a.no_factu;

    cursor C_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_FACT'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    cursor C_wsMetodo (Cv_IdEmpresa Varchar2) is
      select a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'METHOD_WS_FACT'
         and a.parametro = 'VALIDAR'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    l_request             soap_api.t_request;
    l_response            soap_api.t_response;
    lv_url                VARCHAR2(32767);
    lv_namespace          VARCHAR2(32767);
    lv_method             VARCHAR2(32767);
    lv_soap_action        VARCHAR2(32767);
    lv_pathCert           VARCHAR2(32767);
    lv_pswCert            VARCHAR2(32767);
    --
    Lr_RespConEstFactura arfak_webservice.Lr_responseWsFactura;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    Lv_noDocuError       arcpmd.no_docu%type := null;
    Lv_noCiaError        arcpmd.no_cia%type := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;
    --
  begin
    For Lc_Fact in C_facturas loop
     -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError  := Lc_Fact.nombrearchivo;
      Lv_noDocuError := Lc_Fact.no_factu; --ret.no_docu;
      Lv_noCiaError  := Lc_Fact.no_cia;
      Lr_RespConEstFactura := null;
      --
      if lv_url is null or Lv_auxCia != Lc_Fact.no_cia then -- para que solo se levante una vez por empresa

        Lv_auxCia := Lc_Fact.no_cia;

        -- se recuperan parametros de webservice
        For lr_parametro in c_wsParametros (Lc_Fact.no_cia) loop
          case lr_parametro.codigo
            when 'URL' then
              lv_url := lr_parametro.descripcion;
            when 'NAMESPACE' then
              lv_namespace := lr_parametro.descripcion;
            when 'PATH_CERT' then
              lv_pathCert := lr_parametro.descripcion;
            when 'PWS_CERT' then
              lv_pswCert := lr_parametro.descripcion;
          end case;
        End loop;
        -- validaciones de parametros
        case
          when lv_url is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro url';
            Raise Le_Error;
          when lv_namespace is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro nameSpace';
            Raise Le_Error;
          when instr(lower(lv_url),'https') = 0 then
            lv_pathCert := null;
            lv_pswCert := null;
          when instr(lower(lv_url),'https') > 0 then
            if lv_pathCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro path_cert';
              Raise Le_Error;
            elsif lv_pswCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro pws_cert';
              Raise Le_Error;
            end if;
        end case;

        if C_wsMetodo%isopen then close C_wsMetodo; end if;
        open C_wsMetodo (Lc_Fact.no_cia);
        fetch C_wsMetodo into lv_method;
        if C_wsMetodo%notfound then
          Lr_RespConEstFactura.Detalle := 'No se ha definido el metodo CON_ESTADO en parametros Generales';
          Raise Le_Error;
        end if;
        close C_wsMetodo;

        lv_soap_action := trim(lv_url||'/'||lv_method);
      end if;

      l_request := soap_api.new_request(p_method       => lv_method,
                                        p_namespace    => lv_namespace);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'rucEmpresa',
                             p_type    => null,
                             p_value   => Lc_Fact.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'archivo',
                             p_type    => null,
                             p_value   => '<![CDATA['||Lc_Fact.result_xml.getStringVal()||']]>');

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'nombreArchivo',
                             p_type    => null,
                             p_value   => Lc_Fact.nombrearchivo);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => Lc_Fact.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => Lc_Fact.clave);

      l_response := soap_api.invoke(p_request  => l_request,
                                    p_url      => lv_url,
                                    p_action   => lv_soap_action,
                                    p_pathcert => lv_pathCert,
                                    p_pswcert  => lv_pswCert,
                                    p_error    => Lr_RespConEstFactura.detalle );

      if Lr_RespConEstFactura.detalle is not null then
        Lr_RespConEstFactura.numAutorizacion := null;
        Lr_RespConEstFactura.claveAcceso := null;
        Lr_RespConEstFactura.estado := 0;
      else
        -- traduce xml recibido
        arfak_webservice.P_respValida( l_response.doc,
                                       Lr_RespConEstFactura);
      end if;

      update arfafe a
         set a.clave_acceso = nvl(Lr_RespConEstFactura.claveAcceso, a.clave_acceso),
             a.estado_sri = nvl(Lr_RespConEstFactura.estado,'X'), -- levantar excepcion por actualizacion
             a.detalle_error_sri = Lr_RespConEstFactura.detalle,
             a.numero_envio_sri = a.numero_envio_sri + 1
       where a.no_factu = Lc_Fact.no_factu
         and a.no_cia   = Lc_Fact.no_cia;

      Commit;

    End loop;
  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaFactura, xml: '||Lv_noRetError||' '||Lr_RespConEstFactura.detalle;

      update arfafe a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_factu = Lv_noDocuError
         and a.no_cia   = Lv_noCiaError;
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaFactura, xml: '||Lv_noRetError||' '||sqlerrm;

      update arfafe a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_factu = Lv_noDocuError
         and a.no_cia   = Lv_noCiaError;
      --
      commit;
  End P_ValidaFactura;
  --
  --------------------------------------------------
  Procedure P_ValidaNotaCreditoDev is

  CURSOR C_NotaCredito  IS
    SELECT a.no_cia,  
      c.id_tributario rucEmpresa,
      a.no_factu,
      a.nombre_archivo nombreArchivo,
      f.usuario_ws usuario,
      f.clave_ws clave,
      XMLROOT(XMLElement("notaCredito", XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),
                                 XMLElement("infoTributaria", XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("ruc",c.id_tributario),
                                                              XMLElement("codDoc",'04'),
                                                              XMLElement("estab",Substr(a.serie_fisico, 1, 3)),
                                                              XMLElement("ptoEmi",Substr(a.serie_fisico,4,3)), 
                                                              XMLElement("secuencial",lpad(a.no_fisico , 9, '0')),
                                                              XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(c.direccion))
                                            ),
                    XMLElement("infoNotaCredito", XMLElement("fechaEmision",to_char(a.fecha,'dd/mm/yyyy')),
                                              XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(c.direccion)),

                                              (SELECT XMLElement("tipoIdentificacionComprador", w.codigo)
                                                  FROM sri_secuenciales_transacciones w 
                                                 WHERE w.codigo_identificacion = b.tipo_id_tributario
                                                   AND w.codigo_tipo_trans = 2),                                              
                                              XMLElement("razonSocialComprador",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                              XMLElement("identificacionComprador",b.cedula),                                              
                                              XMLElement("obligadoContabilidad",'SI'),
                                             -----------                                               
                                            (SELECT XMLForest ('01' AS "codDocModificado",
                                                   substr(fe.serie_fisico,1,3)||'-'||substr(fe.serie_fisico,4,3)||'-'||lpad(fe.no_fisico, 9, '0') AS "numDocModificado",
                                                   to_char(fe.fecha,'dd/mm/yyyy') AS "fechaEmisionDocSustento",
                                                   trim(to_char(sum(df.total),'999999990.99'))               AS "totalSinImpuestos",
                                                   trim(to_char(sum(df.total + df.i_ven_n),'999999990.99'))  AS "valorModificacion"  )
                                              FROM arfact t,
                                                   arfafe fe,
                                                   arfafl df
                                             WHERE fe.no_cia = t.no_cia
                                               AND fe.tipo_doc = t.tipo
                                               AND fe.no_factu = df.no_factu
                                               AND fe.tipo_doc = df.tipo_doc
                                               AND fe.no_cia = df.no_cia 
                                               AND fe.no_factu = a.n_factu_d --:uno.no_factu
                                               AND fe.tipo_doc = a.tipo_doc_d --:uno.tipo_doc   AND fe.centrod = :uno.centrod
                                               AND fe.no_cia = a.no_cia --:uno.no_cia  
                                             GROUP BY fe.serie_fisico, fe.no_fisico, fe.fecha),                                                      

                                             XMLElement("moneda",'DOLAR'),

                                            (Select XMLElement("totalConImpuestos",
                                                            XMLElement("totalImpuesto",
                                                                       XMLForest ('2' AS "codigo",
                                                                                   NVL(b.sri_codigo_iva,'2') AS "codigoPorcentaje",
                                                                                   --a.Porc_Imp porcentaje,
                                                                            trim(to_char(nvl(sum(a.base),0),'999999990.99'))      AS "baseImponible",
                                                                            trim(to_char(nvl(sum(a.Monto_Imp),0),'999999990.99')) AS "valor"  ) )  )
                                              from arfafli a,
                                                   arcgimp b
                                             where a.clave = b.clave
                                               and a.no_cia = b.no_cia
                                               and a.no_factu = a.n_factu_d --:uno.no_factu
                                               and a.tipo_doc = a.tipo_doc_d --:uno.tipo_doc
                                               and a.no_cia = a.no_cia --:uno.no_cia
                                             group by b.sri_codigo_iva, a.Porc_Imp),   

                                          ( Select XMLElement("motivo", gek_consulta.gef_elimina_caracter_esp(r.descripcion))     
                                            from arfafe z, razones r  
                                            where z.no_cia = a.no_cia
                                            and z.no_factu = a.no_factu 
                                            and z.no_cia=r.no_cia 
                                            and z.tipo_doc=r.tipo_doc   
                                            and z.razon=r.razon

                                           ) 

                             ),   --

                            XMLElement("detalles",(SELECT XMLAgg(
                                                      XMLElement("detalle",
                                                          (SELECT XMLForest(razon AS "codigoInterno",  
                                                                  descripcion AS "descripcion")
                                                            FROM razones r
                                                           WHERE r.no_cia = a.no_cia 
                                                             AND r.tipo_doc = a.tipo_doc
                                                             AND r.razon = a.razon), 

                                                         (SELECT XMLForest( 1 AS "cantidad",
                                                           trim(to_char(sum(df.total),'999999990.99')) AS "precioUnitario", --totalSinImpuestos,
                                                                                                     0 AS "descuento",
                                                           trim(to_char(sum(df.total),'999999990.99')) AS "precioTotalSinImpuesto") --totalSinImpuestos,
                                                            FROM arfact t,
                                                                 arfafe fe,
                                                                 arfafl df
                                                           WHERE fe.no_cia = t.no_cia
                                                             AND fe.tipo_doc = t.tipo
                                                             AND fe.no_factu = df.no_factu
                                                             AND fe.tipo_doc = df.tipo_doc
                                                             AND fe.no_cia = df.no_cia
                                                             AND fe.no_factu = a.n_factu_d --:uno.no_factu
                                                             --AND fe.tipo_doc = :uno.tipo_doc  AND fe.centrod = :uno.centrod
                                                             AND fe.no_cia = a.no_cia --:uno.no_cia
                                                           GROUP BY fe.serie_fisico, fe.no_fisico, fe.fecha, fe.no_factu),                                                       


( 
SELECT XMLElement("impuestos",
        XMLElement("impuesto",
                   XMLForest('2' AS "codigo",
                             p.sri_codigo_iva AS "codigoPorcentaje",
                             p.porcentaje AS "tarifa"
                             ),
                             XMLElement("baseImponible", trim(to_char(sum(i.base),'999999999999990.99')) ),
                             XMLElement("valor", trim(to_char(sum(i.monto_imp),'999999999999990.99')) )
                             ))
                             FROM arcgimp p, arfafli i
                             WHERE p.no_cia = a.no_cia and p.no_cia = i.no_cia and i.NO_FACTU = a.n_factu_d ----a.no_factu
                               AND p.afecta = 'V'
                               AND p.ind_retencion = 'N'
                               AND p.grupo = 'IVA' and  p.clave=i.clave group by p.sri_codigo_iva, p.porcentaje  )                                                         

                                                        ))                                                           
                                               from arfafli x,
                                                   arcgimp z
                                             where x.clave = z.clave
                                               and x.no_cia = z.no_cia
                                               and x.no_factu = a.n_factu_d --:uno.no_factu  and x.tipo_doc = :uno.tipo_doc
                                               and x.no_cia = a.no_cia AND ROWNUM = 1  -- :uno.no_cia
                                             group by z.sri_codigo_iva, x.Porc_Imp, a.n_factu_d  )    ), --

                    XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),b.email1),
                                                XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.telefono)),
                                                (SELECT XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),
                                                                   gek_consulta.gef_elimina_caracter_esp(t.descripcion))
                                                     FROM argecan t
                                                     WHERE t.canton = b.canton
                                                       AND t.provincia = b.provincia
                                                       AND t.pais = b.pais),
                                                XMLElement("campoAdicional", XMLAttributes('numeroCliente' AS "nombre"), b.grupo||'-'||b.no_cliente),
                                                XMLElement("campoAdicional", XMLAttributes('observacion' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(a.observ1))
                                                    )     
                     ), VERSION '1.0" encoding="UTF-8') result_xml
      FROM arfafe a,
           arccmc b,
           arcgmc c,  
           ARFAMC f,
           arfact d
     WHERE a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
    AND a.estado = 'P'   
    AND a.estado_sri = '1'
    and a.no_cia = f.no_cia
    and f.genera_doc_electronico = 'S'
    and f.tipo_generacion = 'WS' 
    and a.no_cia = d.no_cia
    and a.tipo_doc = d.tipo
    and d.es_doc_electronico = 'S'
     and d.ind_fac_dev = 'D'
    order by a.no_cia, a.no_factu;

    cursor c_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_FACT'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    cursor c_wsMetodo (Cv_IdEmpresa Varchar2) is
      select a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'METHOD_WS_FACT'
         and a.parametro = 'VALIDAR'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    l_request            soap_api.t_request;
    l_response           soap_api.t_response;
    lv_url                VARCHAR2(32767);
    lv_namespace          VARCHAR2(32767);
    lv_method             VARCHAR2(32767);
    lv_soap_action        VARCHAR2(32767);
    lv_pathCert           VARCHAR2(32767);
    lv_pswCert            VARCHAR2(32767);
    --
    Lr_RespConEstFactura arfak_webservice.Lr_responseWsFactura;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    Lv_noDocuError       arcpmd.no_docu%type := null;
    Lv_noCiaError        arcpmd.no_cia%type := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;
    --
  begin
    For Lc_NotaCred in C_NotaCredito loop
     -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError  := Lc_NotaCred.nombrearchivo;
      Lv_noDocuError := Lc_NotaCred.no_factu; --ret.no_docu;
      Lv_noCiaError  := Lc_NotaCred.no_cia;
      Lr_RespConEstFactura := null;
      --
      if lv_url is null or Lv_auxCia != Lc_NotaCred.no_cia then -- para que solo se levante una vez por empresa

        Lv_auxCia := Lc_NotaCred.no_cia;

        -- se recuperan parametros de webservice
        For lr_parametro in c_wsParametros (Lc_NotaCred.no_cia) loop
          case lr_parametro.codigo
            when 'URL' then
              lv_url := lr_parametro.descripcion;
            when 'NAMESPACE' then
              lv_namespace := lr_parametro.descripcion;
            when 'PATH_CERT' then
              lv_pathCert := lr_parametro.descripcion;
            when 'PWS_CERT' then
              lv_pswCert := lr_parametro.descripcion;
          end case;
        End loop;
        -- validaciones de parametros
        case
          when lv_url is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro url';
            Raise Le_Error;
          when lv_namespace is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro nameSpace';
            Raise Le_Error;
          when instr(lower(lv_url),'https') = 0 then
            lv_pathCert := null;
            lv_pswCert := null;
          when instr(lower(lv_url),'https') > 0 then
            if lv_pathCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro path_cert';
              Raise Le_Error;
            elsif lv_pswCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro pws_cert';
              Raise Le_Error;
            end if;
        end case;

        if c_wsMetodo%isopen then close c_wsMetodo; end if;
        open c_wsMetodo (Lc_NotaCred.no_cia);
        fetch c_wsMetodo into lv_method;
        if c_wsMetodo%notfound then
          Lr_RespConEstFactura.Detalle := 'No se ha definido el metodo CON_ESTADO en parametros Generales';
          Raise Le_Error;
        end if;
        close c_wsMetodo;

        lv_soap_action := trim(lv_url||'/'||lv_method);
      end if;

      l_request := soap_api.new_request(p_method       => lv_method,
                                        p_namespace    => lv_namespace);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'rucEmpresa',
                             p_type    => null,
                             p_value   => Lc_NotaCred.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'archivo',
                             p_type    => null,
                             p_value   => '<![CDATA['||Lc_NotaCred.result_xml.getStringVal()||']]>');

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'nombreArchivo',
                             p_type    => null,
                             p_value   => Lc_NotaCred.nombrearchivo);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => Lc_NotaCred.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => Lc_NotaCred.clave);

      l_response := soap_api.invoke(p_request  => l_request,
                                    p_url      => lv_url,
                                    p_action   => lv_soap_action,
                                    p_pathcert => lv_pathCert,
                                    p_pswcert  => lv_pswCert,
                                    p_error    => Lr_RespConEstFactura.detalle );

      if Lr_RespConEstFactura.detalle is not null then
        Lr_RespConEstFactura.numAutorizacion := null;
        Lr_RespConEstFactura.claveAcceso := null;
        Lr_RespConEstFactura.estado := 0;
      else
        -- traduce xml recibido
        arfak_webservice.P_respValida( l_response.doc,
                                              Lr_RespConEstFactura);
      end if;

      update arfafe a
         set a.clave_acceso = nvl(Lr_RespConEstFactura.claveAcceso, a.clave_acceso),
             a.estado_sri = nvl(Lr_RespConEstFactura.estado,'X'), -- levantar excepcion por actualizacion
             a.detalle_error_sri = Lr_RespConEstFactura.detalle,
             a.numero_envio_sri = a.numero_envio_sri + 1
       where a.no_factu = Lc_NotaCred.no_factu
         and a.no_cia   = Lc_NotaCred.no_cia;

      Commit;

    End loop;
  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaNotaCredito, xml: '||Lv_noRetError||' '||Lr_RespConEstFactura.detalle;

      update arfafe a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_factu = Lv_noDocuError
         and a.no_cia   = Lv_noCiaError;
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaNotaCredito, xml: '||Lv_noRetError||' '||sqlerrm;

      update arfafe a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_factu = Lv_noDocuError
         and a.no_cia   = Lv_noCiaError;
      --
      commit;
  End P_ValidaNotaCreditoDev;  

  --------------------------------------------------
  Procedure P_ValidaNotaCreditoAnul is

  CURSOR C_NotaCredito  IS
    SELECT a.no_cia,  
      c.id_tributario rucEmpresa,
      a.no_factu,
      e.nombre_archivo nombreArchivo,
      f.usuario_ws usuario,
      f.clave_ws clave,
      XMLROOT(XMLElement("notaCredito", XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),
                                 XMLElement("infoTributaria", XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("ruc",c.id_tributario),
                                                              XMLElement("codDoc",'04'),
                                                              XMLElement("estab",Substr(a.serie_fisico, 1, 3)),
                                                              XMLElement("ptoEmi",Substr(a.serie_fisico,4,3)), 
                                                              XMLElement("secuencial",lpad(a.no_fisico , 9, '0')),
                                                              XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(c.direccion))
                                            ),
                    XMLElement("infoNotaCredito", XMLElement("fechaEmision",to_char(a.fecha,'dd/mm/yyyy')),
                                              XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(c.direccion)),

                                              (SELECT XMLElement("tipoIdentificacionComprador", w.codigo)
                                                  FROM sri_secuenciales_transacciones w 
                                                 WHERE w.codigo_identificacion = b.tipo_id_tributario
                                                   AND w.codigo_tipo_trans = 2),                                              
                                              XMLElement("razonSocialComprador",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                              XMLElement("identificacionComprador",b.cedula),                                              
                                              XMLElement("obligadoContabilidad",'SI'),
                                             -----------                                               
                                            (SELECT XMLForest ('01' AS "codDocModificado",
                                                   substr(fe.serie_fisico,1,3)||'-'||substr(fe.serie_fisico,4,3)||'-'||lpad(fe.no_fisico, 9, '0') AS "numDocModificado",
                                                   to_char(fe.fecha,'dd/mm/yyyy')  AS "fechaEmisionDocSustento",
                                              trim(to_char(nvl(sum(df.total),0),'999999990.99'))               AS "totalSinImpuestos",
                                              trim(to_char(nvl(sum(df.total + df.i_ven_n),0),'999999990.99'))  AS "valorModificacion"  )
                                              FROM arfact t,
                                                   arfafe fe,
                                                   arfafl df
                                             WHERE fe.no_cia = t.no_cia
                                               AND fe.tipo_doc = t.tipo
                                               AND fe.no_factu = df.no_factu
                                               AND fe.tipo_doc = df.tipo_doc
                                               AND fe.no_cia = df.no_cia 
                                               AND fe.no_factu = a.no_factu  --:uno.no_factu                                                
                                               AND fe.no_cia = a.no_cia --:uno.no_cia  
                                             GROUP BY fe.serie_fisico, fe.no_fisico, fe.fecha),                                                      

                                             XMLElement("moneda",'DOLAR'),

                                            (Select XMLElement("totalConImpuestos",
                                                            XMLElement("totalImpuesto",
                                                                       XMLForest ('2' AS "codigo",
                                                                                   NVL(b.sri_codigo_iva,'2') AS "codigoPorcentaje",
                                                                                   --a.Porc_Imp porcentaje,
                                                                            trim(to_char(nvl(sum(i.base),0),'999999990.99'))      AS "baseImponible",
                                                                            trim(to_char(nvl(sum(i.Monto_Imp),0),'999999990.99')) AS "valor"  ) )  )
                                              from arfafli i,
                                                   arcgimp b
                                             where i.clave = b.clave
                                               and i.no_cia = b.no_cia
                                               and i.no_factu = a.no_factu --:uno.no_factu
                                               and i.no_cia = b.no_cia
                                               and i.no_cia = a.no_cia --and rownum = 1 --:uno.no_cia
                                             group by b.sri_codigo_iva, i.Porc_Imp, a.no_factu),                                                

                                            ( SELECT XMLElement("motivo", gek_consulta.gef_elimina_caracter_esp(descripcion))    --*--razon, descripcion
                                                FROM razones r
                                               WHERE r.no_cia = a.no_cia 
                                                 and r.tipo_doc = e.tipo_doc_a 
                                                 and r.razon = e.no_razon    )                                            
                             ),   --

                            XMLElement("detalles",(SELECT XMLAgg(
                                                      XMLElement("detalle",
                                                          (SELECT XMLForest(razon AS "codigoInterno",  
                                                                  descripcion AS "descripcion")
                                                            FROM razones r
                                                           WHERE r.no_cia = a.no_cia 
                                                             AND r.tipo_doc = e.tipo_doc_a
                                                             AND r.razon = e.no_razon), 

                                                         (SELECT XMLForest( 1 AS "cantidad",
                                                           trim(to_char(nvl(sum(df.total),0),'999999990.99')) AS "precioUnitario", --totalSinImpuestos,
                                                                 0 AS "descuento",
                                                           trim(to_char(nvl(sum(df.total),0),'999999990.99')) AS "precioTotalSinImpuesto") --totalSinImpuestos,
                                                            FROM arfact t,
                                                                 arfafe fe,
                                                                 arfafl df
                                                           WHERE fe.no_cia = t.no_cia
                                                             AND fe.tipo_doc = t.tipo
                                                             AND fe.no_factu = df.no_factu
                                                             AND fe.tipo_doc = df.tipo_doc
                                                             AND fe.no_cia = df.no_cia
                                                             AND fe.no_factu = a.no_factu --:uno.no_factu
                                                             AND fe.no_cia = a.no_cia --:uno.no_cia
                                                           GROUP BY fe.serie_fisico, fe.no_fisico, fe.fecha),                                                       

                              ( 
                              SELECT XMLElement("impuestos",
                                      XMLElement("impuesto",
                                                 XMLForest('2' AS "codigo",
                                                           p.sri_codigo_iva AS "codigoPorcentaje",
                                                           p.porcentaje AS "tarifa"
                                                           ),
                                                           XMLElement("baseImponible", trim(to_char(sum(i.base),'999999999999990.99')) ),
                                                           XMLElement("valor", trim(to_char(sum(i.monto_imp),'999999999999990.99')) )
                                                           ))
                                                           FROM arcgimp p, arfafli i
                                                           WHERE p.no_cia = a.no_cia 
                                                           and p.no_cia = i.no_cia 
                                                           and i.NO_FACTU = a.no_factu
                                                             --AND p.afecta = 'V'
                                                             AND p.ind_retencion = 'N'
                                                             AND p.grupo = 'IVA' 
                                                             and p.clave=i.clave 
                                                             group by p.sri_codigo_iva, p.porcentaje  )                                                           

                                                        ))                                                           
                                              from arfafli x,
                                                   arcgimp z
                                             where x.clave = z.clave
                                               and x.no_cia = z.no_cia
                                               and x.no_factu = a.no_factu 
                                               and x.no_cia = a.no_cia and rownum = 1 
                                             group by z.sri_codigo_iva, x.Porc_Imp)                         
                                         ), --

                    XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),b.email1),
                                                XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.telefono)),
                                                (SELECT XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),
                                                                   gek_consulta.gef_elimina_caracter_esp(t.descripcion))
                                                     FROM argecan t
                                                     WHERE t.canton = b.canton
                                                       AND t.provincia = b.provincia
                                                       AND t.pais = b.pais)
                                                    )     
                     ), VERSION '1.0" encoding="UTF-8') result_xml
    FROM arfafe a,
           arccmc b,
           arcgmc c,  
           ARFAMC f,
           arfact d,
           ARFA_ANULA_DOC_ELECTRONICO e
     WHERE a.no_cia = e.no_cia
    and e.estado_sri = 'P'
    and e.no_factu = a.no_factu
       AND a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
    and a.no_cia = f.no_cia
    and f.genera_doc_electronico = 'S'
    and f.tipo_generacion = 'WS' 
    and a.no_cia = d.no_cia
    and a.tipo_doc = d.tipo
    and d.es_doc_electronico = 'S'
    order by a.no_cia, a.no_factu;

    cursor c_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_FACT'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    cursor c_wsMetodo (Cv_IdEmpresa Varchar2) is
      select a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'METHOD_WS_FACT'
         and a.parametro = 'VALIDAR'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    l_request            soap_api.t_request;
    l_response           soap_api.t_response;
    lv_url                VARCHAR2(32767);
    lv_namespace          VARCHAR2(32767);
    lv_method             VARCHAR2(32767);
    lv_soap_action        VARCHAR2(32767);
    lv_pathCert           VARCHAR2(32767);
    lv_pswCert            VARCHAR2(32767);
    --
    Lr_RespConEstFactura arfak_webservice.Lr_responseWsFactura;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    Lv_noDocuError       arcpmd.no_docu%type := null;
    Lv_noCiaError        arcpmd.no_cia%type := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;
    --
  begin
    For Lc_NotaCred in C_NotaCredito loop
     -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError  := Lc_NotaCred.nombrearchivo;
      Lv_noDocuError := Lc_NotaCred.no_factu; --ret.no_docu;
      Lv_noCiaError  := Lc_NotaCred.no_cia;
      Lr_RespConEstFactura := null;
      --
      if lv_url is null or Lv_auxCia != Lc_NotaCred.no_cia then -- para que solo se levante una vez por empresa

        Lv_auxCia := Lc_NotaCred.no_cia;

        -- se recuperan parametros de webservice
        For lr_parametro in c_wsParametros (Lc_NotaCred.no_cia) loop
          case lr_parametro.codigo
            when 'URL' then
              lv_url := lr_parametro.descripcion;
            when 'NAMESPACE' then
              lv_namespace := lr_parametro.descripcion;
            when 'PATH_CERT' then
              lv_pathCert := lr_parametro.descripcion;
            when 'PWS_CERT' then
              lv_pswCert := lr_parametro.descripcion;
          end case;
        End loop;
        -- validaciones de parametros
        case
          when lv_url is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro url';
            Raise Le_Error;
          when lv_namespace is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro nameSpace';
            Raise Le_Error;
          when instr(lower(lv_url),'https') = 0 then
            lv_pathCert := null;
            lv_pswCert := null;
          when instr(lower(lv_url),'https') > 0 then
            if lv_pathCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro path_cert';
              Raise Le_Error;
            elsif lv_pswCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro pws_cert';
              Raise Le_Error;
            end if;
        end case;

        if c_wsMetodo%isopen then close c_wsMetodo; end if;
        open c_wsMetodo (Lc_NotaCred.no_cia);
        fetch c_wsMetodo into lv_method;
        if c_wsMetodo%notfound then
          Lr_RespConEstFactura.Detalle := 'No se ha definido el metodo CON_ESTADO en parametros Generales';
          Raise Le_Error;
        end if;
        close c_wsMetodo;

        lv_soap_action := trim(lv_url||'/'||lv_method);
      end if;


      l_request := soap_api.new_request(p_method       => lv_method,
                                        p_namespace    => lv_namespace);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'rucEmpresa',
                             p_type    => null,
                             p_value   => Lc_NotaCred.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'archivo',
                             p_type    => null,
                             p_value   => '<![CDATA['||Lc_NotaCred.result_xml.getStringVal()||']]>');

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'nombreArchivo',
                             p_type    => null,
                             p_value   => Lc_NotaCred.nombrearchivo);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => Lc_NotaCred.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => Lc_NotaCred.clave);

      l_response := soap_api.invoke(p_request  => l_request,
                                    p_url      => lv_url,
                                    p_action   => lv_soap_action,
                                    p_pathcert => lv_pathCert,
                                    p_pswcert  => lv_pswCert,
                                    p_error    => Lr_RespConEstFactura.detalle );

      if Lr_RespConEstFactura.detalle is not null then
        Lr_RespConEstFactura.numAutorizacion := null;
        Lr_RespConEstFactura.claveAcceso := null;
        Lr_RespConEstFactura.estado := 0;
      else
        -- traduce xml recibido
        arfak_webservice.P_respValida( l_response.doc,
                                              Lr_RespConEstFactura);
      end if;

      update arfafe a
         set a.clave_acceso = nvl(Lr_RespConEstFactura.claveAcceso, a.clave_acceso),
             a.estado_sri = nvl(Lr_RespConEstFactura.estado,'X'), -- levantar excepcion por actualizacion
             a.detalle_error_sri = Lr_RespConEstFactura.detalle,
             a.numero_envio_sri = a.numero_envio_sri + 1
       where a.no_factu = Lc_NotaCred.no_factu
         and a.no_cia = Lc_NotaCred.no_cia;

      Commit;

    End loop;
  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaNotaCredito, xml: '||Lv_noRetError||' '||Lr_RespConEstFactura.detalle;

      update arfafe a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_factu = Lv_noDocuError
         and a.no_cia = Lv_noCiaError;
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaNotaCredito, xml: '||Lv_noRetError||' '||sqlerrm;

      update arfafe a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_factu = Lv_noDocuError
         and a.no_cia = Lv_noCiaError;
      --
      commit;
  End P_ValidaNotaCreditoAnul;   

  --
  --------------------------------------------------
  Procedure P_ValidaNotaCreditoCxC is

  CURSOR C_NotaCreditoCxC  IS
    SELECT a.no_cia,  
      c.id_tributario rucEmpresa,
      a.no_docu,
      a.nombre_archivo nombreArchivo,
      f.usuario_ws usuario,
      f.clave_ws clave,
      XMLROOT(XMLElement("notaCredito", XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),
                                 XMLElement("infoTributaria", XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("ruc",c.id_tributario),
                                                              XMLElement("codDoc",'04'),
                                                              XMLElement("estab",Substr(a.serie_fisico, 1, 3)),
                                                              XMLElement("ptoEmi",Substr(a.serie_fisico,4,3)), 
                                                              XMLElement("secuencial",lpad(a.no_fisico , 9, '0')),
                                                              XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(c.direccion))
                                            ),
                    XMLElement("infoNotaCredito", XMLElement("fechaEmision",to_char(a.fecha,'dd/mm/yyyy')),
                                                  XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(c.direccion)),

                                              (SELECT XMLElement("tipoIdentificacionComprador", w.codigo)
                                                  FROM sri_secuenciales_transacciones w 
                                                 WHERE w.codigo_identificacion = b.tipo_id_tributario
                                                   AND w.codigo_tipo_trans = 2),                                              
                                              XMLElement("razonSocialComprador",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                              XMLElement("identificacionComprador",b.cedula),                                              
                                              XMLElement("obligadoContabilidad",'SI'),
                                             -----------                                               
                                            (SELECT XMLForest ('01' AS "codDocModificado",
                                                   substr(b.serie_fisico,1,3)||'-'||substr(b.serie_fisico,4,3)||'-'||lpad(b.no_fisico, 9, '0') AS "numDocModificado",
                                                   to_char(b.fecha,'dd/mm/yyyy') AS "fechaEmisionDocSustento",
                                                   trim(to_char(nvl(sum(nvl(b.gravado,0) + nvl(b.exento,0)),0),'999999990.99'))  AS "totalSinImpuestos",
                                                   trim(to_char(nvl(sum(b.m_original),0),'999999990.99'))   AS "valorModificacion"  )
                                              from arccrd h,
                                                   arccmd b 
                                             where h.no_docu = b.no_docu
                                               and h.no_cia = b.no_cia
                                               and b.no_docu = a.no_docu 
                                               and b.no_cia  = a.no_cia                                                                                               
                                             GROUP BY b.serie_fisico, b.no_fisico, b.fecha),                                                      

                                             XMLElement("moneda",'DOLAR'),

                                            (Select XMLElement("totalConImpuestos",
                                                            XMLElement("totalImpuesto",
                                                                       XMLForest ('2' AS "codigo",
                                                                                   NVL(b.sri_codigo_iva,'2') AS "codigoPorcentaje",
                                                                                   trim(to_char(nvl(sum(i.base),0),'999999990.99'))   AS "baseImponible",
                                                                                   trim(to_char(nvl(sum(i.Monto),0),'999999990.99'))  AS "valor"  ) )  )
                                              from arccti i,
                                                   arcgimp b
                                             where i.clave  = b.clave
                                               and i.no_cia = b.no_cia
                                               and i.no_docu = a.no_docu 
                                               and i.no_cia  = a.no_cia                           
                                             group by b.sri_codigo_iva, i.Porcentaje),   

                                            (Select XMLElement("motivo", gek_consulta.gef_elimina_caracter_esp(c.descripcion))
                                            from conceptos c, arccmd m 
                                            where c.no_cia = a.no_cia
                                            and c.no_cia = m.no_cia 
                                            and c.tipo_doc = a.tipo_doc
                                            and c.tipo_doc = m.tipo_doc
                                            and c.concepto = m.concepto
                                            and m.no_docu = a.no_docu   )  
                             ),    --

                            XMLElement("detalles",(SELECT XMLAgg(
                                                      XMLElement("detalle",
                                                          (SELECT XMLForest(concepto    AS "codigoInterno",  
                                                                            descripcion AS "descripcion")
                                                            from conceptos 
                                                           where no_cia = a.no_cia 
                                                             and tipo_doc = a.tipo_doc  
                                                             and concepto = a.concepto), 

                                                          (SELECT XMLForest( 1 AS "cantidad",
                                                               trim(to_char(nvl(sum(nvl(b.gravado,0) + nvl(b.exento,0)),0),'999999990.99'))  AS "precioUnitario", 
                                                                                                                                           0 AS "descuento",
                                                               trim(to_char(nvl(sum(nvl(b.gravado,0) + nvl(b.exento,0)),0),'999999990.99'))  AS "precioTotalSinImpuesto")                                                 
                                                              from arccrd r,
                                                                   arccmd b
                                                             where r.no_docu = b.no_docu
                                                               and r.no_cia = b.no_cia
                                                               and r.no_docu =  a.no_docu 
                                                               and r.no_cia = a.no_cia                                                        
                                                              GROUP BY b.serie_fisico, b.no_fisico, b.fecha                                                            
                                                             ) , --                                                                                                                

                                                        (SELECT XMLElement("impuestos",
                                                                        XMLElement("impuesto",
                                                                                   XMLForest ('2' AS "codigo",
                                                                                               NVL(b.sri_codigo_iva,'2') AS "codigoPorcentaje",
                                                                                               NVL(i.Porcentaje,0) AS "tarifa",
                                                                                               trim(to_char(nvl(sum(i.base),0),'999999990.99'))   AS "baseImponible",
                                                                                               trim(to_char(nvl(sum(i.Monto),0),'999999990.99'))  AS "valor"  ) )  )
                                                          from arccti i,
                                                               arcgimp b
                                                         where i.clave  = b.clave
                                                           and i.no_cia = b.no_cia
                                                           and i.no_docu = a.no_docu 
                                                           and i.no_cia  = a.no_cia                           
                                                         group by b.sri_codigo_iva, i.Porcentaje ) 
                                                        ))                                                           
                                              from arccti x, 
                                                   arcgimp z
                                             where x.clave  = z.clave
                                               and x.no_cia = z.no_cia
                                               and x.no_docu = a.no_docu 
                                               and x.no_cia   = a.no_cia 
                                             group by z.sri_codigo_iva, x.Porcentaje)                         
                                         ), --

                    XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),b.email1),
                                                XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.telefono)),
                                                (SELECT XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),
                                                                   gek_consulta.gef_elimina_caracter_esp(t.descripcion))
                                                     FROM argecan t
                                                     WHERE t.canton = b.canton
                                                       AND t.provincia = b.provincia
                                                       AND t.pais = b.pais),
                                                XMLElement("campoAdicional", XMLAttributes('numeroCliente' AS "nombre"), b.grupo||'-'||b.no_cliente),
                                                XMLElement("campoAdicional", XMLAttributes('observacion' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(a.detalle))
                                                    )     
                     ), VERSION '1.0" encoding="UTF-8') result_xml
      FROM arccmd a,  
           arccmc b,
           arcgmc c,  
           ARFAMC f,
           arcctd d 
     WHERE a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
    AND a.estado_sri = '1'
    and a.no_cia = f.no_cia
    and f.genera_doc_electronico = 'S'
    and f.tipo_generacion = 'WS' 
    and a.no_cia = d.no_cia
    and a.tipo_doc = d.tipo
    and d.TIPO_MOV='C' 
    and d.codigo_tipo_comprobante='4' 
    and d.ind_anulacion='N' 
    and d.es_doc_electronico='S'
    order by a.no_cia, a.no_docu;

    cursor c_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_FACT'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    cursor c_wsMetodo (Cv_IdEmpresa Varchar2) is
      select a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'METHOD_WS_FACT'
         and a.parametro = 'VALIDAR'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    l_request            soap_api.t_request;
    l_response           soap_api.t_response;
    lv_url                VARCHAR2(32767);
    lv_namespace          VARCHAR2(32767);
    lv_method             VARCHAR2(32767);
    lv_soap_action        VARCHAR2(32767);
    lv_pathCert           VARCHAR2(32767);
    lv_pswCert            VARCHAR2(32767);
    --
    Lr_RespConEstFactura arfak_webservice.Lr_responseWsFactura;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    Lv_noDocuError       arcpmd.no_docu%type := null;
    Lv_noCiaError        arcpmd.no_cia%type := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;
    --
  begin
    For Lc_NotaCred in C_NotaCreditoCxC loop
     -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError  := Lc_NotaCred.nombrearchivo;
      Lv_noDocuError := Lc_NotaCred.no_docu; 
      Lv_noCiaError  := Lc_NotaCred.no_cia;
      Lr_RespConEstFactura := null;
      --
      if lv_url is null or Lv_auxCia != Lc_NotaCred.no_cia then -- para que solo se levante una vez por empresa

        Lv_auxCia := Lc_NotaCred.no_cia;

        -- se recuperan parametros de webservice
        For lr_parametro in c_wsParametros (Lc_NotaCred.no_cia) loop
          case lr_parametro.codigo
            when 'URL' then
              lv_url := lr_parametro.descripcion;
            when 'NAMESPACE' then
              lv_namespace := lr_parametro.descripcion;
            when 'PATH_CERT' then
              lv_pathCert := lr_parametro.descripcion;
            when 'PWS_CERT' then
              lv_pswCert := lr_parametro.descripcion;
          end case;
        End loop;
        -- validaciones de parametros
        case
          when lv_url is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro url';
            Raise Le_Error;
          when lv_namespace is null then
            Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro nameSpace';
            Raise Le_Error;
          when instr(lower(lv_url),'https') = 0 then
            lv_pathCert := null;
            lv_pswCert := null;
          when instr(lower(lv_url),'https') > 0 then
            if lv_pathCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro path_cert';
              Raise Le_Error;
            elsif lv_pswCert is null then
              Lr_RespConEstFactura.detalle := 'En parametros generales WebService no se ha definido parametro pws_cert';
              Raise Le_Error;
            end if;
        end case;

        if c_wsMetodo%isopen then close c_wsMetodo; end if;
        open c_wsMetodo (Lc_NotaCred.no_cia);
        fetch c_wsMetodo into lv_method;
        if c_wsMetodo%notfound then
          Lr_RespConEstFactura.Detalle := 'No se ha definido el metodo CON_ESTADO en parametros Generales';
          Raise Le_Error;
        end if;
        close c_wsMetodo;

        lv_soap_action := trim(lv_url||'/'||lv_method);
      end if;

      l_request := soap_api.new_request(p_method       => lv_method,
                                        p_namespace    => lv_namespace);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'rucEmpresa',
                             p_type    => null,
                             p_value   => Lc_NotaCred.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'archivo',
                             p_type    => null,
                             p_value   => '<![CDATA['||Lc_NotaCred.result_xml.getStringVal()||']]>');

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'nombreArchivo',
                             p_type    => null,
                             p_value   => Lc_NotaCred.nombrearchivo);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => Lc_NotaCred.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => Lc_NotaCred.clave);

      l_response := soap_api.invoke(p_request  => l_request,
                                    p_url      => lv_url,
                                    p_action   => lv_soap_action,
                                    p_pathcert => lv_pathCert,
                                    p_pswcert  => lv_pswCert,
                                    p_error    => Lr_RespConEstFactura.detalle );

      if Lr_RespConEstFactura.detalle is not null then
        Lr_RespConEstFactura.numAutorizacion := null;
        Lr_RespConEstFactura.claveAcceso := null;
        Lr_RespConEstFactura.estado := 0;
      else
        -- traduce xml recibido
        arfak_webservice.P_respValida( l_response.doc,
                                              Lr_RespConEstFactura);
      end if;

      update arccmd a
         set a.clave_acceso = nvl(Lr_RespConEstFactura.claveAcceso, a.clave_acceso),
             a.estado_sri   = nvl(Lr_RespConEstFactura.estado,'X'), -- levantar excepcion por actualizacion
             a.detalle_error_sri = Lr_RespConEstFactura.detalle,
             a.numero_envio_sri  = a.numero_envio_sri + 1
       where a.no_docu = Lc_NotaCred.no_docu
         and a.no_cia  = Lc_NotaCred.no_cia;

      Commit;

    End loop;
  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaNotaCredito, xml: '||Lv_noRetError||' '||Lr_RespConEstFactura.detalle;

      update arccmd a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_docu = Lv_noDocuError
         and a.no_cia  = Lv_noCiaError;
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstFactura.detalle := 'Error en Ws_ValidaNotaCredito, xml: '||Lv_noRetError||' '||sqlerrm;

      update arccmd a
         set a.estado_sri = '0',
             a.detalle_error_sri = Lr_RespConEstFactura.detalle
       where a.no_docu = Lv_noDocuError
         and a.no_cia  = Lv_noCiaError;
      --
      commit;
  End P_ValidaNotaCreditoCxC;  

  --
  Procedure P_respValida ( Pv_Xml          in     XMLTYPE,
                           Pr_responseFACT in out arfak_webservice.Lr_responseWsFactura) is
  BEGIN
    -- Si xml esta OK este for traera datos
    FOR Lv_Xml  IN ( SELECT nombreArchivo, claveAcceso, claveAccesoNueva, estado, detalle
                 FROM xmltable('//return' 
                               passing Pv_Xml columns
                                              nombreArchivo    VARCHAR2(100) PATH './nombreArchivo',
                                              claveAcceso      VARCHAR2(100) PATH './claveAcceso',
                                              claveAccesoNueva VARCHAR2(100) PATH './claveAccesoNueva',
                                              estado           VARCHAR2(2)   PATH './estado',
                                              detalle          VARCHAR2(50)  PATH './detalle'))
    LOOP
       Pr_responseFACT.nombreArchivo    := Lv_Xml.nombreArchivo;
       Pr_responseFACT.estado           := Lv_Xml.estado;
       Pr_responseFACT.detalle          := Lv_Xml.detalle;

       IF Lv_Xml.claveAccesoNueva IS NOT NULL THEN
         Pr_responseFACT.claveAcceso    := Lv_Xml.claveAccesoNueva;
       ELSE
         Pr_responseFACT.claveAcceso    := Lv_Xml.claveAcceso;
       END IF;
    END LOOP;

    -- si hubo ERRORES este for traera datos
    FOR Lv_XmlError  IN ( SELECT mensaje, infAdicional
                 FROM xmltable('//mensajes' 
                               passing Pv_Xml columns 
                                              mensaje      VARCHAR2(50)  PATH './mensaje',
                                              infAdicional VARCHAR2(500) PATH './informacionAdicional'))
    LOOP

      if Pr_responseFACT.detalle is null then
        Pr_responseFACT.detalle := Lv_XmlError.mensaje||'-'||Lv_XmlError.infAdicional;
      else
        Pr_responseFACT.detalle := Pr_responseFACT.detalle||'|'||Lv_XmlError.mensaje||'-'||Lv_XmlError.infAdicional;
      end if;
    END LOOP;

    -- *******************************************
    -- M a n e j o   d e   E r r o r e s
    -- *******************************************
    If (Pr_responseFACT.estado is null) Or (instr(Pr_responseFACT.detalle, 'NULL SELF') > 0)then
      Pr_responseFACT.detalle := Pv_Xml.getClobVal;
      Pr_responseFACT.estado  := '0';    -- errores no controlados

    ELSIF  Pr_responseFACT.estado in ('-4','-3') then    
      -- Comprobante Duplicado / Version Obsoleta : se setea estado uno para consumir metodo de consulta
      Pr_responseFACT.detalle := Pv_Xml.getClobVal;
      Pr_responseFACT.estado  := '1';            

    ELSIF  Pr_responseFACT.estado in ('-2','-1') then     
      -- Error Autenticacion / No Recidido: Se setea estado P para volver a enviar
      Pr_responseFACT.detalle := Pv_Xml.getClobVal;
      Pr_responseFACT.estado  := 'P';                                                
    END IF;

  exception
    when others then
      Pr_responseFACT.detalle := Pr_responseFACT.detalle||'. '||sqlerrm;
      Pr_responseFACT.estado := '0';      
  End P_respValida;

  -- *******************************************   
  Procedure P_ConsultaEstadoFactDevAnul is

    Cursor C_FactDevAnul is
    SELECT 'FA' tipo,   -- Facturas
      a.no_cia,  
      a.no_factu no_docu,
      c.id_tributario rucEmpresa,
      '01' tipoDocumento,
      Substr(a.serie_fisico, 1, 3) establecimiento,
      Substr(a.serie_fisico, 4, 3) ptoEmision, 
      lpad(a.no_fisico, 9, '0') secuencial,
      a.clave_acceso,
      a.nombre_archivo nombreArchivo,      
      f.usuario_ws usuario,
      f.clave_ws clave,
      a.estado_sri 
      FROM arfafe a,
           arccmc b,
           arcgmc c,
           ARFAMC f,
           ARFACT T
     WHERE a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
       AND a.estado = 'P' 
       AND a.estado_sri in ('1','3')
       and a.no_cia = f.no_cia
       and f.genera_doc_electronico = 'S'
       and f.tipo_generacion = 'WS' 
       and a.no_cia = t.no_cia 
       and a.tipo_doc = t.tipo 
       and t.ind_fac_dev = 'F'
       UNION  
    SELECT 'DV' tipo,  -- Devoluciones
      a.no_cia,  
      a.no_factu,
      c.id_tributario rucEmpresa,
      '04' tipoDocumento,
      Substr(a.serie_fisico, 1, 3) establecimiento,
      Substr(a.serie_fisico, 4, 3) ptoEmision, 
      lpad(a.no_fisico, 9, '0') secuencial,
      a.clave_acceso,
      a.nombre_archivo nombreArchivo,      
      f.usuario_ws usuario,
      f.clave_ws clave,
      a.estado_sri 
      FROM arfafe a,
           arccmc b,
           arcgmc c,  
           ARFAMC f,
           arfact d
     WHERE a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
    AND a.estado = 'P'   
    AND a.estado_sri = '1'
    and a.no_cia = f.no_cia
    and f.genera_doc_electronico = 'S'
    and f.tipo_generacion = 'WS' 
    and a.no_cia = d.no_cia
    and a.tipo_doc = d.tipo
    and d.es_doc_electronico = 'S'
     and d.ind_fac_dev = 'D'     
    UNION      
    SELECT 'AN' tipo,  -- Anulaciones 
      a.no_cia,  
      a.no_factu,
      c.id_tributario rucEmpresa,
      '04' tipoDocumento,
      Substr(a.serie_fisico, 1, 3) establecimiento,
      Substr(a.serie_fisico, 4, 3) ptoEmision, 
      lpad(a.no_fisico, 9, '0') secuencial,
      a.clave_acceso,
      a.nombre_archivo nombreArchivo,
      f.usuario_ws usuario,
      f.clave_ws clave,
      a.estado_sri 
    FROM arfafe a,
           arccmc b,
           arcgmc c,  
           ARFAMC f,
           arfact d,
           ARFA_ANULA_DOC_ELECTRONICO e
     WHERE a.no_cia = e.no_cia
    and e.estado_sri = 'P'
    and e.no_factu = a.no_factu
       AND a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
    and a.no_cia = f.no_cia
    and f.genera_doc_electronico = 'S'
    and f.tipo_generacion = 'WS' 
    and a.no_cia = d.no_cia
    and a.tipo_doc = d.tipo
    and d.es_doc_electronico = 'S' 
   order by 1, 2; 
    --
    cursor c_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_FACT'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    cursor c_wsMetodo (Cv_IdEmpresa Varchar2) is
      select a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'METHOD_WS_FACT'
         and a.parametro = 'CON_ESTADO'
         and a.id_aplicacion = 'FA'
         and a.id_empresa = Cv_IdEmpresa
         and a.estado = 'A'
         and b.estado = 'A';
    --
    l_request            soap_api.t_request;
    l_response           soap_api.t_response;
    l_url                VARCHAR2(32767);
    l_namespace          VARCHAR2(32767);
    l_method             VARCHAR2(32767);
    l_soap_action        VARCHAR2(32767);
    l_pathCert           VARCHAR2(32767);
    l_pswCert            VARCHAR2(32767);
    --
    Lr_RespConEstCompRet arfak_webservice.Lr_responseWsFactura;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    --
    Lv_noFactuError      arfafe.no_factu%type := null;
    Lv_noCiaError        arfafe.no_cia%type   := null;
    Lv_TipoError         VARCHAR2(2) := '';    
    Lv_noRetError        VARCHAR2(1000) := NULL;
    --
  begin

    for doc in C_FactDevAnul loop

      -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError   := doc.nombrearchivo;
      Lv_noFactuError := doc.no_docu;
      Lv_TipoError    := doc.tipo;   -- Puede ser Factura, Devolucion, Anulaci\F3n.
      Lv_noCiaError   := doc.no_cia;

      Lr_RespConEstCompRet := null;

      if l_url is null or Lv_auxCia != doc.no_cia then -- para que solo se levante una vez po empresa

        Lv_auxCia := doc.no_cia;

        -- se recuperan parametros de webservice
        for lr_parametro in c_wsParametros (doc.no_cia) loop
          case lr_parametro.codigo
            when 'URL' then
              l_url := lr_parametro.descripcion;
            when 'NAMESPACE' then
              l_namespace := lr_parametro.descripcion;
            when 'PATH_CERT' then
              l_pathCert := lr_parametro.descripcion;
            when 'PWS_CERT' then
              l_pswCert := lr_parametro.descripcion;
          end case;
        end loop;
        -- validaciones de parametros
        case 
          when l_url is null then
            Lr_RespConEstCompRet.detalle := 'En parametros generales WebService no se ha definido parametro url';
            Raise Le_Error;
          when l_namespace is null then
            Lr_RespConEstCompRet.detalle := 'En parametros generales WebService no se ha definido parametro nameSpace';
            Raise Le_Error;
          when instr(lower(l_url),'https') = 0 then
            l_pathCert := null;
            l_pswCert := null;
          when instr(lower(l_url),'https') > 0 then
            if l_pathCert is null then
              Lr_RespConEstCompRet.detalle := 'En parametros generales WebService no se ha definido parametro path_cert';
              Raise Le_Error;
            elsif l_pswCert is null then
              Lr_RespConEstCompRet.detalle := 'En parametros generales WebService no se ha definido parametro pws_cert';
              Raise Le_Error;
            end if;
        end case;

        if c_wsMetodo%isopen then close c_wsMetodo; end if;
        open c_wsMetodo (doc.no_cia);
        fetch c_wsMetodo into l_method;
        if c_wsMetodo%notfound then
          Lr_RespConEstCompRet.Detalle := 'No se ha definido el metodo CON_ESTADO en parametros Generales';
          Raise Le_Error;
        end if;
        close c_wsMetodo;

        l_soap_action := trim(l_url||'/'||l_method);
      end if;


      l_request := soap_api.new_request(p_method       => l_method,
                                        p_namespace    => l_namespace);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'rucEmpresa',
                             p_type    => null,
                             p_value   => doc.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'claveAcceso',
                             p_type    => null,
                             p_value   => doc.clave_acceso);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => doc.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => doc.clave);

      l_response := soap_api.invoke(p_request => l_request,
                                  p_url      => l_url,
                                  p_action   => l_soap_action,
                                  p_pathcert => l_pathCert,
                                  p_pswcert  => l_pswCert,
                                  p_error    => Lr_RespConEstCompRet.detalle );

       if Lr_RespConEstCompRet.detalle is not null then
         Lr_RespConEstCompRet.estado := 0;
         Lr_RespConEstCompRet.numAutorizacion := null;
       else
         -- traduce xml recibido
         arfak_webservice.P_respConsultaEstado( l_response.doc,
                                                Lr_RespConEstCompRet);
       end if;

      -- Actualizar ARFAFE cuando doc.Tipo <> 'AN'
      IF doc.Tipo <> 'AN' Then
        update arfafe a
           set a.no_autorizacion = Lr_RespConEstCompRet.numAutorizacion,
               a.estado_sri = nvl(Lr_RespConEstCompRet.estado,'X'), -- levantar excepcion por estado nulo
               a.detalle_error_sri = Lr_RespConEstCompRet.detalle
         where a.no_factu = doc.no_docu
           and a.no_cia = doc.no_cia;

      Elsif doc.Tipo = 'AN'  Then
         update ARFA_ANULA_DOC_ELECTRONICO a
           set a.no_autorizacion = Lr_RespConEstCompRet.numAutorizacion,
               a.estado_sri = nvl(Lr_RespConEstCompRet.estado,'X'), -- levantar excepcion por estado nulo
               a.detalle_error_sri = Lr_RespConEstCompRet.detalle
         where a.no_factu = doc.no_docu
           and a.no_cia = doc.no_cia;       
      End if;

      Commit;
    End loop;  

  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error 
      Lr_RespConEstCompRet.detalle := 'Error en P_ConsultaEstadoFactDevAnul, xml: '||Lv_noRetError||' '||Lr_RespConEstCompRet.detalle;

      If Lv_TipoError <> 'AN' Then
        update arfafe a
           set a.estado_sri = '0',
               a.detalle_error_sri = Lr_RespConEstCompRet.detalle
         where a.no_factu = Lv_noFactuError
           and a.no_cia = Lv_noCiaError;

      Elsif Lv_TipoError = 'AN' Then   
        update ARFA_ANULA_DOC_ELECTRONICO a
           set a.estado_sri = '0',
               a.detalle_error_sri = Lr_RespConEstCompRet.detalle
         where a.no_factu = Lv_noFactuError
           and a.no_cia = Lv_noCiaError;              
      End if;  
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error 
      Lr_RespConEstCompRet.detalle := 'Error en P_ConsultaEstadoFactDevAnul, xml: '||Lv_noRetError||' '||sqlerrm;

      If Lv_TipoError <> 'AN' Then
        update arfafe a
           set a.estado_sri = '0',
               a.detalle_error_sri = Lr_RespConEstCompRet.detalle
         where a.no_factu = Lv_noFactuError
           and a.no_cia = Lv_noCiaError;

      Elsif Lv_TipoError = 'AN' Then   
        update ARFA_ANULA_DOC_ELECTRONICO a
           set a.estado_sri = '0',
               a.detalle_error_sri = Lr_RespConEstCompRet.detalle
         where a.no_factu = Lv_noFactuError
           and a.no_cia = Lv_noCiaError;              
      End if; 
      --
      commit;
  END P_ConsultaEstadoFactDevAnul; 
  --

  Procedure P_respConsultaEstado ( Pv_Xml          in     XMLTYPE,
                                   Pr_respConsulta in out arfak_webservice.Lr_responseWsFactura) is
  BEGIN                            
    -- Si xml esta OK se recuperan datos del documento
    FOR c IN ( SELECT numAutoriza, fechaAutoriza, claveAcceso, estado, detalle
                 FROM xmltable('//return' 
                               passing Pv_Xml columns 
                                              numAutoriza   VARCHAR2(100) PATH './numAutorizacion',
                                              fechaAutoriza VARCHAR2(15)  PATH './fechaAutorizacion',
                                              claveAcceso   VARCHAR2(100) PATH './claveAcceso',
                                              estado        VARCHAR2(2)   PATH './estado',
                                              detalle       VARCHAR2(100) PATH './detalle'))
    LOOP
       Pr_respConsulta.estado          := C.estado;
       Pr_respConsulta.numAutorizacion := C.numAutoriza;
       Pr_respConsulta.claveAcceso     := C.claveAcceso;
       Pr_respConsulta.detalle         := 'Documento Electronico '||C.detalle||' '||C.fechaAutoriza;
    END LOOP;

    -- se recuperan los mensajes retornados, advertencia, error, informativo
    FOR c IN ( SELECT mensaje
                 FROM xmltable('//mensajes' 
                               passing Pv_Xml columns 
                                              mensaje      VARCHAR2(50) PATH './mensaje')
               UNION
               SELECT infAdicional
                 FROM xmltable('//mensajes' 
                               passing Pv_Xml columns 
                                              infAdicional VARCHAR2(50) PATH './informacionAdicional'
                                              ))   
    LOOP
      if Pr_respConsulta.detalle is null then
        Pr_respConsulta.detalle := c.mensaje;
      else
        Pr_respConsulta.detalle := Pr_respConsulta.detalle||', '||c.mensaje;
      end if;
    END LOOP;

    --errores no controlados
    if Pr_respConsulta.estado is null then
      Pr_respConsulta.detalle := Pv_Xml.getClobVal;
      Pr_respConsulta.estado := '0';
    end if;
    --
  exception
    when others then
      Pr_respConsulta.detalle := Pr_respConsulta.detalle||'. '||sqlerrm;
      Pr_respConsulta.estado := '0';
  end P_respConsultaEstado;

End ARFAK_WEBSERVICE;
/
