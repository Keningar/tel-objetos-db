CREATE OR REPLACE package NAF47_TNET.ARCPK_WEBSERVICE is

/**
* Documentacion para NAF47_TNET.ARCPK_WEBSERVICE
* Paquete que contiene procesos y funciones para consumo webservices documentos electronicos
* @author llindao <llindao@telconet.ec>
* @version 1.0 02/07/2014
*
*/

  /**
  * Documentacion para RESPONSEWSRETENCION
  * Tipo Registro que guarda la estructura para obtener valores de retorno en cada response
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 02/07/2014
  */
  Type responseWsRetencion is record
     ( rucEmpresa       arcpmp.cedula%type,
       nombreArchivo    arcpmd.nombre_archivo%type,
       estado           arcpmd.estado_sri%type,
       claveAcceso      arcpmd.clave_acceso%type,
       numAutorizacion  arcpmd.no_autorizacion_comp%type,
       detalle          varchar2(32767)
     );

  /**
  * Documentacion para WS_VALIDACOMPELECTRONICO
  * Procedimiento que genera xml y enva a aprobacin sri consumiendo webservice documentos electronicos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 02/07/2014
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 31/03/2017 Se modifica para transformar el xml a cdata desde el envo y no en el query principal
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 13/04/2020 Se modifica para dar formato decimales a campo porcentaje porque emite error al generar xml
  */
  procedure Ws_ValidaCompElectronico;

  /**
  * Documentacion para WS_CONSULTAESTCOMPROBANTERET
  * Procedimiento que consume metodo ConsultaEstadoComprobante WebService Documentos Electronicos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 02/07/2014
  */
  procedure Ws_ConsultaEstComprobanteRET;

  /**
  * Documentacion para WS_RESPVALIDACOMPELECTRONICO
  * Procedimiento que procesa la respuesta del web service Documentos Electronicos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 02/07/2014
  *
  * @Param Pv_Xml         IN     XMLTYPE                              Recibe xml
  * @Param Pr_responseRET IN OUT arcpk_webservice.responseWsRetencion retorna registro de respuesta
  */
  procedure Ws_respValidaCompElectronico ( Pv_Xml           in     XMLTYPE,
                                           Pr_responseRET   in out arcpk_webservice.responseWsRetencion);

  /**
  * Documentacion para WS_RESPCONSULTAESTCOMP
  * Procedimiento que procesa la respuesta del metodo ConsultaEstadoComprobante web service
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 02/07/2014
  *
  * @Param Pv_Xml         IN     XMLTYPE                              Recibe xml
  * @Param Pr_responseRET IN OUT arcpk_webservice.responseWsRetencion retorna registro de respuesta
  */
  procedure Ws_respConsultaEstComp ( Pv_Xml         in     XMLTYPE,
                                     Pr_respConsRET in out arcpk_webservice.responseWsRetencion);

  /**
  * Documentacion para WS_VALIDACOMPELECTRONICOOFFLINE
  * Procedimiento que genera xml y enva a aprobacin sri consumiendo webservice documentos electronicos
  * @author mnavarrete <mnavarrete@telconet.ec>
  * @version 1.0  12/12/2017
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1  13/04/2020  Se modifica para dar formato decimales a campo porcentaje porque emite error al generar xml
  *
  * @author banton <banton@telconet.ec>
  * @version 1.2  13/10/2020  Se agrega codigo de agente de retencion en el bloque de informacion adicional
  *
  * @author banton <banton@telconet.ec>
  * @version 1.3  21/01/2021  Se agrega numero de agente de retencion en el bloque de informacion tributaria
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.4  04/04/2022 - Se modifica para direccionar el uso de los campos LOB a funciones en base 19c
  */
  procedure Ws_ValidaCompElectOffLine;


  /**
  * Documentacion para Ws_ConsultaCompElectOffLine
  * Procedimiento que realiza consulta y actualizacin de Estados de  documentos electronicos
  * @author mnavarrete <mnavarrete@telconet.ec>
  * @version 1.0  20/12/2017
  */
  procedure Ws_ConsultaCompElectOffLine;


  /**
  * Documentacion para Ws_ConsultaAutorizacionSRI
  * Procedimiento que realiza consulta de Autorizacion del SRI
  * @author mnavarrete <mnavarrete@telconet.ec>
  * @version 1.0  26/12/2017
  */
  procedure Ws_ConsultaAutorizacionSRI;


  /**
  * Documentacion para Ws_ConsultaAutorizacionSRI
  * Funcin que genera la clave de acceso para el comprobante,
  * se mueve a este paquete 
  * @author mnavarrete <mnavarrete@telconet.ec>
  * @version 1.0  26/12/2018
  */
 function Ws_CpGeneratorClave (Pv_FechaDocumento          IN Varchar2,
                                                  Pv_TipoComprobanteSRI    IN Varchar2,
                                                  Pv_Id_identificacion_prov   IN Varchar2,
                                                  Pv_AmbienteId                   IN Varchar2,
                                                  Pv_NoSerieComprob           IN Varchar2,
                                                  Pv_NoFisicoComprob          IN Varchar2,
                                                  Pv_TipoEmision                  IN Varchar2  ) Return Varchar2;

/**
  * Documentaci�n para P_ENVIA_LIQUIDACION_COMPRAS
  * Procedimiento para ingresar documento de liquidaci�n de compras en DB_COMPROBANTES.INFO_DOCUMENTO
  * 
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.0 22/11/2019
  *
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.1 13/07/2020 Se modifica para obtener detalle servicios del documento
  *
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.2 30/05/2022 Se modifica para obtener descripci�n del servicio ingresado de manera manual
  * 
   */                                     
  PROCEDURE P_ENVIA_LIQUIDACION_COMPRAS  ; 
   /**
  * Documentaci�n para P_CONSULTA_ESTADO_LIQ_COMPRAS
  * Procedimiento que verifica estado del comprobante para actualizarlo en NAF
  * 
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.0 29/11/2019
  * 
   */
  PROCEDURE P_CONSULTA_ESTADO_LIQ_COMPRAS;
   /**
  * Documentaci�n para P_GENERA_XML_FISICO
  * Procedimiento que genera xml para enviar a autorizar al SRI 
  * 
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.0 22/01/2020
  * 
  * @author llindao <llindao@telconet.ec>
  * @version 1.1  13/04/2020  Se modifica para dar formato decimales a campo porcentaje porque emite error al generar xml
  *
   @author Byron Ant�n <banton@telconet.ec>
  * @version 1.2 13/07/2020 Se modifica para obtener detalle servicios del documento
  *
   @author Byron Ant�n <banton@telconet.ec>
  * @version 1.3 06/10/2020 Se modifica para codigo de agente en bloque de informaci�n adicional
  * 
  * @author llindao <llindao@telconet.ec>
  * @version 1.4  04/04/2022 - Se modifica para direccionar el uso de los campos LOB a las funciones que leen desde base 19c
  */
  PROCEDURE P_GENERA_XML_FISICO (Pv_noDocu IN VARCHAR2,
                                 Pv_NoCia  IN VARCHAR2);

   /**
  * Documentaci�n para F_LEER_ARCHIVO_CLOB
  * Procedimiento que lee el xml desde la base para transcribir a disco desde el Forms 
  * 
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.0 22/01/2020
  */
  FUNCTION F_LEER_ARCHIVO_CLOB(Pv_NoDocu IN VARCHAR2,
                               Pv_NoCia  IN VARCHAR2,
                               Pn_Indice IN NUMBER) RETURN VARCHAR2;
                                                                                  
end arcpk_webservice;
/

CREATE or replace package body NAF47_TNET.RCPK_WEBSERVICE is

  procedure Ws_ValidaCompElectronico is
    --
    cursor c_retenciones is
      select a.no_cia,
             a.no_docu,
             d.id_tributario rucEmpresa,
             '07' tipoDocumento,
             substr(a.comp_ret_serie,1,3) establecimiento,
             substr(a.comp_ret_serie,4,3) ptoEmision,
             lpad(a.comp_ret,9,'0') secuencial,
             a.nombre_archivo nombreArchivo,
             f.usuario_ws usuario,
             f.clave_ws clave,
             a.estado_sri,
             c.cedula identificacion,
             XMLRoot(
             XMLElement("comprobanteRetencion",
                        XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),

                        XMLElement("infoTributaria", XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                                     XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                                     XMLElement("ruc",b.id_tributario),
                                                     XMLElement("codDoc",'07'),
                                                     XMLElement("estab",Substr(a.comp_ret_serie,1,3)),
                                                     XMLElement("ptoEmi",Substr(a.comp_ret_serie,4,3)),
                                                     XMLElement("secuencial",lpad(a.comp_ret , 9, '0')),
                                                     XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(b.direccion))),

                        XMLElement("infoCompRetencion", XMLElement("fechaEmision",to_char(a.fecha_retencion,'dd/mm/yyyy')),
                                                        XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                        (select XMLElement("contribuyenteEspecial", X.parametro) from ge_parametros x, ge_grupos_parametros y
                                                          where x.id_grupo_parametro = y.id_grupo_parametro
                                                            and x.id_aplicacion = y.id_aplicacion
                                                            and x.id_empresa = y.id_empresa
                                                            and x.id_grupo_parametro = 'ES_CONTRIB_ESPECIAL'
                                                            and x.id_aplicacion = 'CP'
                                                            and x.id_empresa = a.no_cia
                                                            and x.estado = 'A'
                                                            and y.estado = 'A'),
                                                        XMLElement("obligadoContabilidad",'SI'),
                                                        XMLElement("tipoIdentificacionSujetoRetenido",decode(c.tipo_id_tributario,'R','04','C','05','P','06','F','07',c.tipo_id_tributario)),
                                                        XMLElement("razonSocialSujetoRetenido",gek_consulta.gef_elimina_caracter_esp(c.nombre_largo)),
                                                        XMLElement("identificacionSujetoRetenido",c.cedula),
                                                        XMLElement("periodoFiscal",to_char(a.fecha,'mm/yyyy'))),

                        XMLElement("impuestos", (select XMLAgg(
                                                          XMLElement("impuesto",
                                                            XMLForest
                                                               (
                                                               decode(y.retencion_iva, 'S', '2', decode(y.retencion_fuente, 'S', '1')) as "codigo",
                                                                x.sri_retimp_renta as "codigoRetencion",
                                                                trim(to_char(x.base,'999999999999990.99')) as "baseImponible",
                                                                trim(to_char(x.porcentaje,'990.99')) as "porcentajeRetener",
                                                                trim(to_char(x.monto,'999999999999990.99')) as "valorRetenido"
                                                                ),
                                                                XMLElement("codDocSustento", Lpad(e.codigo_tipo_comprobante,2,'0')),
                                                                XMLElement("numDocSustento", a.serie_fisico||lpad(a.no_fisico, 9, '0')),
                                                                XMLElement("fechaEmisionDocSustento", to_char(a.fecha_documento,'dd/mm/yyyy'))))
                                                   from arcpti x, arcgimp y
                                                  where x.clave = y.clave
                                                    and x.no_cia = y.no_cia
                                                    and x.no_docu = a.no_docu
                                                    and x.tipo_doc = a.tipo_doc
                                                    and x.no_cia = a.no_cia
                                                    and nvl(x.anulada, 'N') = 'N'
                                                    and x.ind_imp_ret = 'R')),

                        XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),gek_consulta.gef_elimina_caracter_esp(c.direccion)),
                                                    case when c.telefono is not null then
                                                        XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"), gek_consulta.gef_elimina_caracter_esp(c.telefono))
                                                    end case,
                                                    (select XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),gek_consulta.gef_elimina_caracter_esp(x.descripcion))
                                                       from ge_parametros x
                                                      where x.id_empresa = a.no_cia
                                                        and x.id_grupo_parametro = 'LUGAR_EMISION_RETENC'
                                                        and x.id_aplicacion = 'CP'
                                                        and x.estado = 'A'),
                                                    case when c.email1 is not null and c.email2 is not null then
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),c.email1||';'||c.email2)
                                                         when c.email1 is not null then
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),c.email1)
                                                         when c.email2 is not null then
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),c.email2)
                                                    end case,
                                                    (select XMLElement("campoAdicional", XMLAttributes('tipoComprobante' AS "nombre"),gek_consulta.gef_elimina_caracter_esp(z.descripcion))
                                                       from sri_tipos_comprobantes z
                                                      where z.codigo = e.codigo_tipo_comprobante),
                                                    XMLElement("campoAdicional", XMLAttributes('nroComprobante' AS "nombre"),a.serie_fisico||a.no_fisico),
                                                    (select XMLElement("campoAdicional", XMLAttributes('valorPagar' AS "nombre"),trim(to_char(sum(x.monto),'999999990.99')))
                                                       from arcpti x, arcgimp y
                                                      where x.clave = y.clave
                                                        and x.no_cia = y.no_cia
                                                        and x.no_docu = a.no_docu
                                                        and x.tipo_doc = a.tipo_doc
                                                        and x.no_cia = a.no_cia
                                                        and nvl(x.anulada, 'N') = 'N'
                                                        and x.ind_imp_ret = 'R'))
                        ), VERSION '1.0" encoding="UTF-8') result_xml
        from arcpmd a,
             arcgmc b,
             arcpmp c,
             arcgmc d,
             arcptd e,
             arcpct f
       where a.no_cia = b.no_cia
         and a.no_prove = c.no_prove
         and a.no_cia = c.no_cia
         and a.no_cia = d.no_cia
         and a.no_cia = e.no_cia
         and a.tipo_doc = e.tipo_doc
         and a.no_cia = f.no_cia
         and a.estado_sri = 'G'
         and f.genera_doc_electronico = 'S'
         and f.tipo_generacion = 'WS'
       order by a.no_cia, a.no_docu;

    cursor c_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_RET'
         and a.id_aplicacion = 'CP'
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
         and a.id_grupo_parametro = 'METHOD_WS_RET'
         and a.parametro = 'VALIDAR'
         and a.id_aplicacion = 'CP'
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
    Lr_RespConEstCompRet arcpk_webservice.responseWsRetencion;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    Lv_noDocuError       arcpmd.no_docu%type := null;
    Lv_noCiaError        arcpmd.no_cia%type := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;


    --
  begin
    for ret in c_retenciones loop

     -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError := ret.nombrearchivo;
      Lv_noDocuError := ret.no_docu;
      Lv_noCiaError := ret.no_cia;
      Lr_RespConEstCompRet := null;
      --
      if l_url is null or Lv_auxCia != ret.no_cia then -- para que solo se levante una vez po empresa

        Lv_auxCia := ret.no_cia;

        -- se recuperan parametros de webservice
        for lr_parametro in c_wsParametros (ret.no_cia) loop
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
        open c_wsMetodo (ret.no_cia);
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
                             p_value   => ret.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'archivo',
                             p_type    => null,
                             p_value   => '<![CDATA['||ret.result_xml.getStringVal()||']]>');

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'nombreArchivo',
                             p_type    => null,
                             p_value   => ret.nombrearchivo);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => ret.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => ret.clave);


      l_response := soap_api.invoke(p_request => l_request,
                                  p_url      => l_url,
                                  p_action   => l_soap_action,
                                  p_pathcert => l_pathCert,
                                  p_pswcert  => l_pswCert,
                                  p_error    => Lr_RespConEstCompRet.detalle );

      if Lr_RespConEstCompRet.detalle is not null then
        Lr_RespConEstCompRet.numAutorizacion := null;
        Lr_RespConEstCompRet.claveAcceso := null;
        Lr_RespConEstCompRet.estado := 0;
      else
        -- traduce xml recibido
        arcpk_webservice.Ws_respValidaCompElectronico( l_response.doc,
                                                       Lr_RespConEstCompRet);
      end if;

      update arcpmd a
         set a.clave_acceso = nvl(Lr_RespConEstCompRet.claveAcceso, a.clave_acceso),
             a.estado_sri = nvl(Lr_RespConEstCompRet.estado,'X'), -- levantar excepcion por actualizacion
             a.detalle_rechazo = Lr_RespConEstCompRet.detalle,
             a.ind_impresion_ret = 'S',
             a.numero_envio_sri = a.numero_envio_sri + 1
       where a.no_docu = ret.no_docu
         and a.no_cia = ret.no_cia;

      Commit;

    end loop;
  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstCompRet.detalle := 'Error en Ws_ValidaCompElectronico, xml: '||Lv_noRetError||' '||Lr_RespConEstCompRet.detalle;

      update arcpmd a
         set a.estado_sri = '0',
             a.detalle_rechazo = Lr_RespConEstCompRet.detalle
       where a.no_docu = Lv_noDocuError
         and a.no_cia = Lv_noCiaError;
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstCompRet.detalle := 'Error en Ws_ValidaCompElectronico, xml: '||Lv_noRetError||' '||sqlerrm;

      update arcpmd a
         set a.estado_sri = '0',
             a.detalle_rechazo = Lr_RespConEstCompRet.detalle
       where a.no_docu = Lv_noDocuError
         and a.no_cia = Lv_noCiaError;
      --
      commit;
  end Ws_ValidaCompElectronico;

  procedure Ws_ConsultaEstComprobanteRET is

    cursor c_retenciones is
      select a.no_cia,
             a.no_docu,
             c.id_tributario rucEmpresa,
             '07' tipoDocumento,
             substr(a.comp_ret_serie,1,3) establecimiento,
             substr(a.comp_ret_serie,4,3) ptoEmision,
             lpad(a.comp_ret,9,'0') secuencial,
             a.clave_acceso,
             a.nombre_archivo nombreArchivo,
             b.usuario_ws usuario,
             b.clave_ws clave,
             a.estado_sri
        from arcpmd a,
             arcpct b,
             arcgmc c
       where a.no_cia = b.no_cia
         and a.no_cia = c.no_cia
         and a.estado_sri in ('1','3')
         and b.genera_doc_electronico = 'S'
         and b.tipo_generacion = 'WS'
       order by a.no_cia desc;
    --
        --
    cursor c_wsParametros (Cv_IdEmpresa Varchar2) is
      select a.parametro codigo,
             a.descripcion
        from ge_parametros a,
             ge_grupos_parametros b
       where a.id_grupo_parametro = b.id_grupo_parametro
         and a.id_aplicacion = b.id_aplicacion
         and a.id_empresa = b.id_empresa
         and a.id_grupo_parametro = 'WEB_SERVICE_RET'
         and a.id_aplicacion = 'CP'
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
         and a.id_grupo_parametro = 'METHOD_WS_RET'
         and a.parametro = 'CON_ESTADO'
         and a.id_aplicacion = 'CP'
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
    Lr_RespConEstCompRet arcpk_webservice.responseWsRetencion;
    Le_Error             Exception;
    Lv_auxCia            VARCHAR2(2) := '@';
    --
    Lv_noDocuError       arcpmd.no_docu%type := null;
    Lv_noCiaError        arcpmd.no_cia%type := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;
    --
  begin

    for ret in c_retenciones loop

      -- se inicializan variables para actualizar detalle de error en excepcion others
      Lv_noRetError := ret.nombrearchivo;
      Lv_noDocuError := ret.no_docu;
      Lv_noCiaError := ret.no_cia;
      Lr_RespConEstCompRet := null;

      if l_url is null or Lv_auxCia != ret.no_cia then -- para que solo se levante una vez po empresa

        Lv_auxCia := ret.no_cia;

        -- se recuperan parametros de webservice
        for lr_parametro in c_wsParametros (ret.no_cia) loop
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
        open c_wsMetodo (ret.no_cia);
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
                             p_value   => ret.rucempresa);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'claveAcceso',
                             p_type    => null,
                             p_value   => ret.clave_acceso);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'usuario',
                             p_type    => null,
                             p_value   => ret.usuario);

      soap_api.add_parameter(p_request => l_request,
                             p_name    => 'clave',
                             p_type    => null,
                             p_value   => ret.clave);

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
         arcpk_webservice.Ws_respConsultaEstComp( l_response.doc,
                                                  Lr_RespConEstCompRet);
       end if;

      update arcpmd a
         set a.no_autorizacion_comp = Lr_RespConEstCompRet.numAutorizacion,
             a.estado_sri = nvl(Lr_RespConEstCompRet.estado,'X'), -- levantar excepcion por estadoi nulo
             a.detalle_rechazo = Lr_RespConEstCompRet.detalle
       where a.no_docu = ret.no_docu
         and a.no_cia = ret.no_cia;

      Commit;

    end loop;

  exception
    when Le_Error then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstCompRet.detalle := 'Error en Ws_ConsultaEstComprobanteRET, xml: '||Lv_noRetError||' '||Lr_RespConEstCompRet.detalle;

      update arcpmd a
         set a.estado_sri = '0',
             a.detalle_rechazo = Lr_RespConEstCompRet.detalle
       where a.no_docu = Lv_noDocuError
         and a.no_cia = Lv_noCiaError;
      --
      commit;

    when others then
      rollback;
      -- se registra en la tabla el mensaje de error
      Lr_RespConEstCompRet.detalle := 'Error en Ws_ConsultaEstComprobanteRET, xml: '||Lv_noRetError||' '||sqlerrm;

      update arcpmd a
         set a.estado_sri = '0',
             a.detalle_rechazo = Lr_RespConEstCompRet.detalle
       where a.no_docu = Lv_noDocuError
         and a.no_cia = Lv_noCiaError;
      --
      commit;
  END Ws_ConsultaEstComprobanteRET;

  procedure Ws_respValidaCompElectronico ( Pv_Xml         in     XMLTYPE,
                                           Pr_responseRET in out arcpk_webservice.responseWsRetencion) is

  BEGIN

    -- Si xml esta OK este for traera datos
    FOR c IN ( SELECT nombreArchivo, claveAcceso, claveAccesoNueva, estado, detalle
                 FROM xmltable('//return'
                               passing Pv_Xml columns
                                              nombreArchivo    VARCHAR2(100) PATH './nombreArchivo',
                                              claveAcceso      VARCHAR2(100) PATH './claveAcceso',
                                              claveAccesoNueva VARCHAR2(100) PATH './claveAccesoNueva',
                                              estado           VARCHAR2(2)   PATH './estado',
                                              detalle          VARCHAR2(50)  PATH './detalle'))
    LOOP
       Pr_responseRET.nombreArchivo    := c.nombreArchivo;
       Pr_responseRET.estado           := c.estado;
       Pr_responseRET.detalle          := c.detalle;
       IF c.claveAccesoNueva IS NOT NULL THEN
         Pr_responseRET.claveAcceso      := c.claveAccesoNueva;
       ELSE
         Pr_responseRET.claveAcceso      := c.claveAcceso;
       END IF;
    END LOOP;

    -- si hubo ERRORES este for traera datos
    FOR c IN ( SELECT mensaje, infAdicional
                 FROM xmltable('//mensajes'
                               passing Pv_Xml columns
                                              mensaje      VARCHAR2(50)  PATH './mensaje',
                                              infAdicional VARCHAR2(500) PATH './informacionAdicional'))
    LOOP

      if Pr_responseRET.detalle is null then
        Pr_responseRET.detalle := c.mensaje||'-'||c.infAdicional;
      else
        Pr_responseRET.detalle := Pr_responseRET.detalle||'|'||c.mensaje||'-'||c.infAdicional;
      end if;
    END LOOP;

    -- *******************************************
    -- M a n e j o   d e   E r r o r e s
    -- *******************************************
    If (Pr_responseRET.estado is null) Or (instr(Pr_responseRET.detalle, 'NULL SELF') > 0)then
      Pr_responseRET.detalle := Pv_Xml.getClobVal;
      Pr_responseRET.estado := '0';    -- errores no controlados
        ELSIF  Pr_responseRET.estado in ('-4','-3') then
          -- Comprobante Duplicado / Version Obsoleta : se setea estado uno para consumir metodo de consulta
      Pr_responseRET.detalle := Pv_Xml.getClobVal;
      Pr_responseRET.estado := '1';

        ELSIF  Pr_responseRET.estado in ('-2','-1') then
          -- Error Autenticacion / No Recidido: Se setea estado P para volver a enviar
      Pr_responseRET.detalle := Pv_Xml.getClobVal;
      Pr_responseRET.estado := 'P';

    END IF;
    -- *******************************************

  exception
    when others then
      Pr_responseRET.detalle := Pr_responseRET.detalle||'. '||sqlerrm;
      Pr_responseRET.estado := '0';
  end Ws_respValidaCompElectronico;

  procedure ws_respConsultaEstComp ( Pv_Xml         in     XMLTYPE,
                                     Pr_respConsRET in out arcpk_webservice.responseWsRetencion) is
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
       Pr_respConsRET.estado          := C.estado;
       Pr_respConsRET.numAutorizacion := C.numAutoriza;
       Pr_respConsRET.claveAcceso     := C.claveAcceso;
       Pr_respConsRET.detalle         := 'Documento Electronico '||C.detalle||' '||C.fechaAutoriza;
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
      if Pr_respConsRET.detalle is null then
        Pr_respConsRET.detalle := c.mensaje;
      else
        Pr_respConsRET.detalle := Pr_respConsRET.detalle||', '||c.mensaje;
      end if;
    END LOOP;

    --errores no controlados
    if Pr_respConsRET.estado is null then
      Pr_respConsRET.detalle := Pv_Xml.getClobVal;
      Pr_respConsRET.estado := '0';
    end if;
    --
  exception
    when others then
      Pr_respConsRET.detalle := Pr_respConsRET.detalle||'. '||sqlerrm;
      Pr_respConsRET.estado := '0';
  end ws_respConsultaEstComp;

-- ESQUEMA OFFLINE
    procedure Ws_ValidaCompElectOffLine  is
    --
    cursor c_retenciones is
      select a.no_cia,
             a.no_docu,
             d.id_tributario rucEmpresa,
             '07' tipoDocumento,
             ( select id_tipo_doc from DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO Where Codigo = '07' ) tipoAdmiDocumento,
             a.fecha_documento,
             a.fecha_retencion,
             substr(a.comp_ret_serie,1,3) establecimiento,
             substr(a.comp_ret_serie,4,3) ptoEmision,
             lpad(a.comp_ret,9,'0') secuencial,
             a.tot_ret,
             a.nombre_archivo nombreArchivo,
             f.usuario_ws usuario,
             f.clave_ws clave,
             a.estado_sri, --
             a.numero_envio_sri,  --
             a.clave_acceso,
             a.documento_id,
             c.no_prove,
             c.tipo_id_tributario,
             c.cedula identificacion,
             c.nombre,
             c.email1,
             c.email2,
             c.direccion,
             c.telefono,
             c.pais,
             c.provincia,
             c.canton,
             XMLRoot(
             XMLElement("comprobanteRetencion",
                        XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),

                        XMLElement("infoTributaria",
                                                     ( Select XMLElement("ambiente",  AE.AMBIENTE_ID)
                                                        From  DB_COMPROBANTES.ADMI_EMPRESA AE,
                                                                  DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
                                                        Where EG.COD_EMPRESA =  a.no_cia
                                                        and      EG.PREFIJO = AE.CODIGO ),
                                                     XMLElement("tipoEmision",'1'),
                                                     XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                                     XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                                     XMLElement("ruc",b.id_tributario),
                                                     XMLElement("claveAcceso",a.clave_acceso),
                                                     XMLElement("codDoc",'07'),
                                                     XMLElement("estab",Substr(a.comp_ret_serie,1,3)),
                                                     XMLElement("ptoEmi",Substr(a.comp_ret_serie,4,3)),
                                                     XMLElement("secuencial",lpad(a.comp_ret , 9, '0')),
                                                     XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                     CASE WHEN B.NUMERO_AGENTE_RET is not null  AND A.FECHA_RETENCION>=B.FECHA_COD_AGEN_RET THEN  
                                                     XMLElement("agenteRetencion", B.NUMERO_AGENTE_RET)
                                                    END CASE),

                        XMLElement("infoCompRetencion", XMLElement("fechaEmision",to_char(a.fecha_retencion,'dd/mm/yyyy')),
                                                        XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                        (select XMLElement("contribuyenteEspecial", X.parametro) from ge_parametros x, ge_grupos_parametros y
                                                          where x.id_grupo_parametro = y.id_grupo_parametro
                                                            and x.id_aplicacion = y.id_aplicacion
                                                            and x.id_empresa = y.id_empresa
                                                            and x.id_grupo_parametro = 'ES_CONTRIB_ESPECIAL'
                                                            and x.id_aplicacion = 'CP'
                                                            and x.id_empresa = a.no_cia
                                                            and x.estado = 'A'
                                                            and y.estado = 'A'),
                                                        XMLElement("obligadoContabilidad",'SI'),
                                                        XMLElement("tipoIdentificacionSujetoRetenido",decode(c.tipo_id_tributario,'R','04','C','05','P','06','F','07',c.tipo_id_tributario)),
                                                        XMLElement("razonSocialSujetoRetenido",gek_consulta.gef_elimina_caracter_esp(c.nombre_largo)),
                                                        XMLElement("identificacionSujetoRetenido",c.cedula),
                                                        XMLElement("periodoFiscal",to_char(a.fecha,'mm/yyyy'))),

                        XMLElement("impuestos", (select XMLAgg(
                                                          XMLElement("impuesto",
                                                            XMLForest
                                                               (
                                                               decode(y.retencion_iva, 'S', '2', decode(y.retencion_fuente, 'S', '1')) as "codigo",
                                                                x.sri_retimp_renta as "codigoRetencion",
                                                                trim(to_char(x.base,'999999999999990.99')) as "baseImponible",
                                                                trim(to_char(x.porcentaje,'990.99')) as "porcentajeRetener",
                                                                trim(to_char(x.monto,'999999999999990.99')) as "valorRetenido"
                                                                ),
                                                                XMLElement("codDocSustento", Lpad(e.codigo_tipo_comprobante,2,'0')),
                                                                XMLElement("numDocSustento", a.serie_fisico||lpad(a.no_fisico, 9, '0')),
                                                                XMLElement("fechaEmisionDocSustento", to_char(a.fecha_documento,'dd/mm/yyyy'))))
                                                   from NAF47_TNET.arcpti x, NAF47_TNET.arcgimp y
                                                  where x.clave = y.clave
                                                    and x.no_cia = y.no_cia
                                                    and x.no_docu = a.no_docu
                                                    and x.tipo_doc = a.tipo_doc
                                                    and x.no_cia = a.no_cia
                                                    and nvl(x.anulada, 'N') = 'N'
                                                    and x.ind_imp_ret = 'R')),

                        XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),gek_consulta.gef_elimina_caracter_esp(c.direccion)),
                                                    case when c.telefono is not null then
                                                        XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"), gek_consulta.gef_elimina_caracter_esp(c.telefono))
                                                    end case,
                                                    (select XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),gek_consulta.gef_elimina_caracter_esp(x.descripcion))
                                                       from NAF47_TNET.ge_parametros x
                                                      where x.id_empresa = a.no_cia
                                                        and x.id_grupo_parametro = 'LUGAR_EMISION_RETENC'
                                                        and x.id_aplicacion = 'CP'
                                                        and x.estado = 'A'),
                                                    case when c.email1 is not null and c.email2 is not null then
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),c.email1||';'||c.email2)
                                                         when c.email1 is not null then
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),c.email1)
                                                         when c.email2 is not null then
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),c.email2)
                                                    end case,
                                                    (select XMLElement("campoAdicional", XMLAttributes('tipoComprobante' AS "nombre"),gek_consulta.gef_elimina_caracter_esp(z.descripcion))
                                                       from NAF47_TNET.sri_tipos_comprobantes z
                                                      where z.codigo = e.codigo_tipo_comprobante),
                                                    XMLElement("campoAdicional", XMLAttributes('nroComprobante' AS "nombre"),a.serie_fisico||a.no_fisico),
                                                    (select XMLElement("campoAdicional", XMLAttributes('valorPagar' AS "nombre"),trim(to_char(sum(x.monto),'999999990.99')))
                                                       from NAF47_TNET.arcpti x, NAF47_TNET.arcgimp y
                                                      where x.clave = y.clave
                                                        and x.no_cia = y.no_cia
                                                        and x.no_docu = a.no_docu
                                                        and x.tipo_doc = a.tipo_doc
                                                        and x.no_cia = a.no_cia
                                                        and nvl(x.anulada, 'N') = 'N'
                                                        and x.ind_imp_ret = 'R')
                                                        
                                                        )
                        ), VERSION '1.0" encoding="UTF-8') result_xml
        from NAF47_TNET.arcpmd a,
             NAF47_TNET.arcgmc b,
             NAF47_TNET.arcpmp c,
             NAF47_TNET.arcgmc d,
             NAF47_TNET.arcptd e,
             NAF47_TNET.arcpct f
       where a.no_cia = b.no_cia
         and a.no_prove = c.no_prove
         and a.no_cia = c.no_cia
         and a.no_cia = d.no_cia
         and a.no_cia = e.no_cia
         and a.tipo_doc = e.tipo_doc
         and a.no_cia = f.no_cia
         and a.estado_sri = 'G'
         and f.genera_doc_electronico = 'S'
          -- Solo las que manejan el WS de TN,  Indica que tipo de generacin para enviar archivo XML. ED: EN DISCO; WS: WEBSERVICE; N: NINGUNO
         and f.tipo_generacion = 'WS'
       order by a.no_cia, a.no_docu;

    CURSOR C_ParametroOrigenDoc(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)    IS
          SELECT PAD.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
               DB_GENERAL.ADMI_PARAMETRO_DET PAD
          WHERE PAC.NOMBRE_PARAMETRO = Cv_NombreParametro
          AND PAC.ID_PARAMETRO  = PAD.PARAMETRO_ID
          AND PAC.ESTADO            ='Activo'
          AND PAD.ESTADO            ='Activo'
          AND ROWNUM                 = 1;

    Cursor c_wsParametroCiudad (Cv_Pais Varchar2,  Cv_Provincia Varchar2,  Cv_Canton Varchar2 ) is
          Select descripcion from NAF47_TNET.argecan c
          Where c.pais = Cv_Pais
          and c.provincia = Cv_Provincia
          and c.canton = Cv_Canton;

    -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR NUMERO DE IDENTIFICACION
    -- Costo: 3
    CURSOR C_UsuarioExiste(Cv_Identificacion DB_COMPROBANTES.ADMI_USUARIO.LOGIN%TYPE)    IS
          SELECT ID_USUARIO
          FROM DB_COMPROBANTES.ADMI_USUARIO
          WHERE LOGIN = Cv_Identificacion
          AND ROWNUM  = 1;
    --
    -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR EMPRESA
    CURSOR C_UsuarioEmpExiste(Cn_IdUsuario    DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE,
                                                     Cn_IdEmpresa  DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE)  IS
        SELECT USUE.ID_USR_EMP
        FROM  DB_COMPROBANTES.ADMI_USUARIO USU,
             DB_COMPROBANTES.ADMI_USUARIO_EMPRESA USUE
        WHERE  USUE.USUARIO_ID     = USU.ID_USUARIO
        AND USUE.EMPRESA_ID = Cn_IdEmpresa
        AND USU.ID_USUARIO    = Cn_IdUsuario
        AND ROWNUM          = 1;

    Cursor c_ParametroEmpresa (Cv_IdEmpresa Varchar2) is
        Select AE.ID_EMPRESA, AE.AMBIENTE_ID
        From  DB_COMPROBANTES.ADMI_EMPRESA AE,
                  DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
        Where EG.COD_EMPRESA = Cv_IdEmpresa
        and      EG.PREFIJO = AE.CODIGO;

    Cursor c_wsParametroTipoIdentif (Cv_IdEmpresa Varchar2, Cv_NoProve Varchar2)  is
        Select gp.numerico
        From NAF47_TNET.Arcpmp mp, NAF47_TNET.ge_parametros gp
        Where mp.no_cia = Cv_IdEmpresa
        and mp.no_prove = Cv_NoProve
        and gp.id_aplicacion ='CP'
        and gp.id_grupo_parametro = 'HOMOLOGA_NAF_TELCOS'
        and gp.parametro = mp.tipo_id_tributario;
  --
-----
  Lv_OrigenDocumento       VARCHAR2(25);
  Ln_IdUsuario                    DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%type;
  Ln_IdUsuarioEmpresa       DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.USUARIO_ID%type;
  Lv_mails_proveedor          db_comprobantes.admi_usuario.email%type;
  --
  Lr_CompAdmiUsuario         DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuario               := NULL;
  Lr_CompAdmiUsuarioEmp  DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuarioEmpresa  := NULL;
  Lr_CompInfoDocumento     DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento            := NULL;
  --
  Lv_Ciudad                         Argecan.Descripcion%type;
  Ln_IdEmpresa                   DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%type;
  Ln_IdTipoIdentificacion      DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_IDENTIFICACION_ID%type;
  Ln_AmbienteId                  DB_COMPROBANTES.ADMI_EMPRESA.AMBIENTE_ID%type;
  Ln_IdDocumento               DB_COMPROBANTES.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE:=NULL;
  Lv_Password                    DB_COMPROBANTES.ADMI_USUARIO.PASSWORD%TYPE:=NULL;
  Le_Error                           Exception;
  Lv_MessageError              VARCHAR2(2000);
  --
  Lv_NoCia                       arcpmd.no_Cia%type;
  Lv_NoDocu                    arcpmd.no_docu%type;
    --
BEGIN
    For ret in C_retenciones loop
        -- Para guaradar el referencia de registro a revicsar
         Lv_NoCia       := ret.no_cia;
         Lv_NoDocu    := ret.no_docu;

         -- *****  Validadciones por Parametrizacin de Esquema
        OPEN C_ParametroOrigenDoc('ORIGEN_FACTURACION');
        FETCH C_ParametroOrigenDoc INTO Lv_OrigenDocumento;
        --
        IF Lv_OrigenDocumento IS NULL THEN
          Lv_MessageError :=  'Error No existe Parametro ORIGEN_FACTURACION que define si es Online/Offline';
          RAISE Le_Error;
        END IF;
        CLOSE C_ParametroOrigenDoc;
        --
        Case when  ret.email1 is not null and  ret.email2 is not null then
               Lv_mails_proveedor := ret.email1 ||';'|| ret.email2;
             when ret.email1 is not null then
               Lv_mails_proveedor := ret.email1;
             when ret.email2 is not null then
               Lv_mails_proveedor := ret.email2;
        End Case;

        IF C_UsuarioExiste%ISOPEN         THEN  CLOSE C_UsuarioExiste;       End if;
        IF C_UsuarioEmpExiste%ISOPEN  THEN  CLOSE C_UsuarioEmpExiste; End if;

        --SI ES FACT OFFLINE SE REALIZA EL INGRESO DEL ADMI_USUARIO, ADMI_USUARIO_EMPRESA, INFO_DOCUMENTO EN DB_COMPROBANTES
        IF Lv_OrigenDocumento = 'Offline' THEN

               -- *****  Existe Usuario se busca por Identificacin
               OPEN C_UsuarioExiste(ret.identificacion);
               FETCH C_UsuarioExiste INTO Ln_IdUsuario;
                --
                IF (C_UsuarioExiste%notfound) THEN
                  -- Obtencin de clave para el Usuario  
                 Lv_Password  := DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERA_PASSWD_SHA256 (ret.identificacion);
                  --
                  Ln_IdUsuario                                             :=DB_COMPROBANTES.SEQ_ADMI_USUARIO.NEXTVAL;
                  Lr_CompAdmiUsuario.ID_USUARIO        :=Ln_IdUsuario;
                  Lr_CompAdmiUsuario.LOGIN                    :=ret.identificacion;
                  Lr_CompAdmiUsuario.NOMBRES             :=ret.Nombre;
                  Lr_CompAdmiUsuario.APELLIDOS          :=NULL;
                  Lr_CompAdmiUsuario.EMAIL                   :=Lv_mails_proveedor;
                  Lr_CompAdmiUsuario.ADMIN                  :='N';
                  Lr_CompAdmiUsuario.ESTADO                :='Activo';
                  Lr_CompAdmiUsuario.FE_CREACION     :=SYSDATE;
                  Lr_CompAdmiUsuario.USR_CREACION  :=TRIM(User);
                  Lr_CompAdmiUsuario.FE_ULT_MOD       :=NULL;
                  Lr_CompAdmiUsuario.USR_ULT_MOD    :=NULL;
                  Lr_CompAdmiUsuario.IP_CREACION       :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                  Lr_CompAdmiUsuario.PASSWORD           := Lv_Password;
                  Lr_CompAdmiUsuario.EMPRESA              :='N';
                  Lr_CompAdmiUsuario.LOCALE                 :='es_EC';
                  Lr_CompAdmiUsuario.EMPRESA_CONSULTA  :='N';
                  --
                  DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIO_COMP_ELECT(Lr_CompAdmiUsuario, Lv_MessageError);
                ELSE
                   Ln_IdUsuario := Ln_IdUsuario;
                END IF;
                CLOSE C_UsuarioExiste;

                IF Lv_MessageError IS NOT NULL THEN  
                  --
                  BEGIN
                    Lv_MessageError := Lv_MessageError || ' Se trato de hacer un comprobante no permitido IdDocumento: ';
                    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'INGRESO DE ADMI_USUARIO', Lv_MessageError);
                    Raise Le_Error;
                  END;
                END IF;

                --VERIFICO SI EXISTE EL USUARIO CREADO PARA LA EMPRESA ESPECIFICA, SI NO EXISTE SE INSERTA
                OPEN c_ParametroEmpresa(ret.no_cia);
                FETCH c_ParametroEmpresa INTO Ln_IdEmpresa, Ln_AmbienteId;
                CLOSE c_ParametroEmpresa;

                OPEN c_wsParametroCiudad(ret.pais,  ret.provincia, ret.canton );
                FETCH c_wsParametroCiudad INTO Lv_Ciudad;
                CLOSE c_wsParametroCiudad;

                OPEN C_UsuarioEmpExiste(Ln_IdUsuario,  Ln_IdEmpresa);
                FETCH C_UsuarioEmpExiste INTO Ln_IdUsuarioEmpresa;
                --
                IF(C_UsuarioEmpExiste%notfound) THEN
                --
                  Ln_IdUsuarioEmpresa                                           :=DB_COMPROBANTES.SEQ_ADMI_USUARIO_EMPRESA.NEXTVAL;
                  Lr_CompAdmiUsuarioEmp.ID_USR_EMP            :=Ln_IdUsuarioEmpresa;
                  Lr_CompAdmiUsuarioEmp.USUARIO_ID            :=Ln_IdUsuario;
                  Lr_CompAdmiUsuarioEmp.EMPRESA_ID            :=Ln_IdEmpresa;
                  Lr_CompAdmiUsuarioEmp.FE_CREACION          :=SYSDATE;
                  Lr_CompAdmiUsuarioEmp.USR_CREACION        :=TRIM(User);
                  Lr_CompAdmiUsuarioEmp.FE_ULT_MOD            :=NULL;
                  Lr_CompAdmiUsuarioEmp.USR_ULT_MOD          :=NULL;
                  Lr_CompAdmiUsuarioEmp.IP_CREACION            :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                  Lr_CompAdmiUsuarioEmp.EMAIL                         :=Lv_mails_proveedor;
                  Lr_CompAdmiUsuarioEmp.DIRECCION                :=ret.direccion;
                  Lr_CompAdmiUsuarioEmp.TELEFONO                 :=ret.Telefono;
                  Lr_CompAdmiUsuarioEmp.CIUDAD                      :=Lv_Ciudad;
                  Lr_CompAdmiUsuarioEmp.NUMERO                     :=NULL;--Lv_Numero;
                  Lr_CompAdmiUsuarioEmp.FORMAPAGO              :=NULL;--Lv_FormaPago;
                  Lr_CompAdmiUsuarioEmp.LOGIN                          :=NULL;--Lv_Login;
                  Lr_CompAdmiUsuarioEmp.CONTRATO                 :=NULL;--Lv_Contrato;
                  Lr_CompAdmiUsuarioEmp.PASSWORD                 := Lv_Password;
                  Lr_CompAdmiUsuarioEmp.N_CONEXION             :=0;
                  Lr_CompAdmiUsuarioEmp.FE_ULT_CONEXION  :=NULL;
                  Lr_CompAdmiUsuarioEmp.CAMBIO_CLAVE        :='N';
                  --
                 DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIOEMP_COMP_ELECT(Lr_CompAdmiUsuarioEmp, Lv_MessageError);
                  --
                ELSE
                   Ln_IdUsuarioEmpresa  :=  Ln_IdUsuarioEmpresa;
                END IF;
                CLOSE C_UsuarioEmpExiste;
                --
                IF Lv_MessageError IS NOT NULL  THEN  
                  --
                  BEGIN
                    Lv_MessageError := Lv_MessageError || ' Se trato de hacer un comprobante no permitido IdDocumento: ';
                     DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'INGRESO DE ADMI_USUARIO_EMPRESA', Lv_MessageError);
                   Raise Le_Error;
                  END;
                END IF;
                --
                OPEN c_wsParametroTipoIdentif( ret.no_cia,  ret.no_prove );
                FETCH c_wsParametroTipoIdentif INTO Ln_IdTipoIdentificacion;
                CLOSE c_wsParametroTipoIdentif;
                --
                --SETEO CAMPOS PARA INSERTAR EN DB_COMPROBANTES -> INFO_DOCUMENTO
                Ln_IdDocumento                                                  :=  DB_COMPROBANTES.SEQ_INFO_DOCUMENTO.NEXTVAL;
                Lr_CompInfoDocumento.ID_DOCUMENTO        := Ln_IdDocumento;
                Lr_CompInfoDocumento.TIPO_DOC_ID              := ret.tipoAdmiDocumento;
                Lr_CompInfoDocumento.FORMATO_ID               := 1;
                Lr_CompInfoDocumento.EMPRESA_ID                := Ln_IdEmpresa;
                Lr_CompInfoDocumento.NOMBRE                       := ret.nombreArchivo;
                Lr_CompInfoDocumento.FE_CREACION              := SYSDATE;
                Lr_CompInfoDocumento.USR_CREACION           := TRIM(User);
                Lr_CompInfoDocumento.FE_ULT_MOD               := NULL;
                Lr_CompInfoDocumento.USR_ULT_MOD            := NULL;
                Lr_CompInfoDocumento.IP_CREACION               := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                Lr_CompInfoDocumento.ESTABLECIMIENTO     := ret.establecimiento;
                Lr_CompInfoDocumento.PUNTO_EMISION         := ret.ptoEmision;
                Lr_CompInfoDocumento.VALOR                           := ret.tot_ret;
                Lr_CompInfoDocumento.ESTADO_DOC_ID          := 10;
                Lr_CompInfoDocumento.VERSION                        := 1;
                Lr_CompInfoDocumento.SECUENCIAL                 := ret.secuencial;
                Lr_CompInfoDocumento.FE_RECIBIDO                := SYSDATE;
                Lr_CompInfoDocumento.TIPO_IDENTIFICACION_ID    := Ln_IdTipoIdentificacion;
                Lr_CompInfoDocumento.IDENTIFICACION            := ret.identificacion;
                Lr_CompInfoDocumento.TIPO_EMISION_ID           := 1;
                Lr_CompInfoDocumento.USUARIO_ID                    := Ln_IdUsuario;
                Lr_CompInfoDocumento.LOTEMASIVO_ID             := 0;
                Lr_CompInfoDocumento.XML_ORIGINAL               := NAF47_TNET.MIG_LEE_CAMPOS_LOB.F_XMLBLOG(ret.result_xml);-- DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_XMLBLOG(ret.result_xml);
                Lr_CompInfoDocumento.AMBIENTE_ID                  := Ln_AmbienteId;
                Lr_CompInfoDocumento.FE_EMISION                      := ret.fecha_retencion;
                Lr_CompInfoDocumento.INTENTO_RECEPCION    := 0;
                Lr_CompInfoDocumento.INTENTO_CONSULTA     := 0;
                Lr_CompInfoDocumento.ORIGEN_DOCUMENTO   := Lv_OrigenDocumento;
                Lr_CompInfoDocumento.CLAVE_ACCESO              := ret.clave_acceso;
                Lr_CompInfoDocumento.DOCUMENTO_ID_FINAN:= 0;
        End if;

        IF  ret.numero_envio_sri = 0 THEN  --UPPER(Pv_TipoTransaccion) =  'INSERT'   THEN
           --
              NAF47_TNET.MIG_LEE_CAMPOS_LOB.P_INSERT_INFO_DOCUMENTO(Lr_CompInfoDocumento, Lv_MessageError);
              --
               IF Lv_MessageError IS NOT NULL  THEN  
                  --
                  BEGIN
                    Lv_MessageError := Lv_MessageError || ' Se trato de hacer un comprobante no permitido IdDocumento: ';
                     DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.P_INSERT_INFO_DOCUMENTO', 'INGRESO DE INFO_DOCUMENTO', Lv_MessageError);
                   Raise Le_Error;
                  END;
                END IF;
           --
        ELSIF  ret.numero_envio_sri  >  0  THEN  --UPPER(Pv_TipoTransaccion) =  'UPDATE'  THEN
              --
              --ACTUALIZO INFO_DOCUMENTO
              Lr_CompInfoDocumento.FE_ULT_MOD        := SYSDATE;
              Lr_CompInfoDocumento.USR_ULT_MOD       := TRIM(User);
              Ln_IdDocumento                         := ret.documento_id;
              Lr_CompInfoDocumento.ID_DOCUMENTO      := Ln_IdDocumento;
              NAF47_TNET.MIG_LEE_CAMPOS_LOB.P_Update_Info_Documento_NAF(Lr_CompInfoDocumento, Lv_MessageError);
        END IF;

         If  Lv_MessageError  is not null Then
             RAISE Le_Error;
         Else
              -- Se cambia de estado_sri para que este proceso no lo vuelva a tomar en cuenta.
              UPDATE arcpmd
                      SET estado_sri = '10',    -- EnviadoCompElectTN
                              numero_envio_sri = numero_envio_sri + 1,
                              documento_id       = Ln_IdDocumento,
                              tipo_doc_id = ret.tipoAdmiDocumento,
                              empresa_id = Ln_IdEmpresa
               WHERE no_cia =  ret.no_cia
                    AND no_docu = ret.no_docu;

              Commit;
         End If;
    --
    END LOOP;

  Exception
    when Le_Error then
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION_ELECTRONICA',
                                                                                                        'NAF47_TNET.ARCPK_WEBSERVICE.Ws_ValidaCompElectOffLine',
                                                                                                        Lv_MessageError);
      update arcpmd a
         set a.estado_sri = '0',
             a.detalle_rechazo = Lv_MessageError
       where a.no_docu =  Lv_NoDocu
         and a.no_cia = Lv_NoCia;

      Commit;

    when others then
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION_ELECTRONICA',
                                                                                                        'NAF47_TNET.ARCPK_WEBSERVICE.Ws_ValidaCompElectOffLine',
                                                                                                        SQLERRM);
      update arcpmd a
         set a.estado_sri = '0',
             a.detalle_rechazo = Lv_MessageError
       where a.no_docu =  Lv_NoDocu
         and a.no_cia = Lv_NoCia;

      Commit;

  End Ws_ValidaCompElectOffLine;


-- Consulta de Estados
procedure Ws_ConsultaCompElectOffLine  is

    Cursor C_RegistroConsulto is
      select a.no_cia,
             a.no_docu,
             a.clave_acceso,
             a.nombre_archivo nombreArchivo,
             a.estado_sri,
             a.documento_id,
             a.tipo_doc_id,
             a.empresa_id
        from arcpmd a,
             arcpct b,
             arcgmc c
       where a.no_cia = b.no_cia
         and a.no_cia = c.no_cia
         and a.estado_sri in ('1','3','10')  -- 0:Error,   1:Iniciado;   2:Rechazado;   3:Recibido,   4:Negado,   5:Autorizado,   8:Anulado,   10:EnviadoCompElect
         and b.genera_doc_electronico = 'S'
         and b.tipo_generacion = 'WS'
       order by a.no_cia desc;

    Cursor C_EstadoRetencionesWS  ( Cn_documento number, Cn_Tipo number,  Cn_Empresa number) is
        SELECT clave_acceso, estado_doc_id
        FROM DB_COMPROBANTES.INFO_DOCUMENTO
        WHERE tipo_doc_id     =  Cn_Tipo
             AND id_documento  = Cn_documento
             AND empresa_id      = Cn_Empresa;

    Cursor C_Mensaje  ( Cn_documento number ) is
        Select  substr(tipo||' - '||mensaje||' - '||infoadicional,1,2000)  informativo
        from DB_COMPROBANTES.INFO_MENSAJE
        where  documento_id = Cn_documento
        and id_mensaje in ( Select max(id_mensaje) mensaje
                                      from DB_COMPROBANTES.INFO_MENSAJE
                                      where documento_id = Cn_documento );

  Lv_clave_acceso    DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%type;      -- varchar
  Ln_estado_doc_id   DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_SRI_ID%type;       -- number
  Lv_mensaje            Arcpmd.Detalle_Rechazo%type;
    --
  Begin
    For est in C_RegistroConsulto Loop  -- Registro con estado_sri in ('1','3','10')
        --
        Open C_EstadoRetencionesWS(est.documento_id, est.tipo_doc_id, est.empresa_id); -- Estado actual en Telcos
        Fetch C_EstadoRetencionesWS into Lv_clave_acceso, Ln_estado_doc_id;
        Close C_EstadoRetencionesWS;
        --
        If  Ln_estado_doc_id = 1 Then
            update arcpmd a
               set --a.clave_acceso = nvl(Ln_estado_sri_id, a.clave_acceso),
                   a.estado_sri = Ln_estado_doc_id, --nvl(Lr_RespConEstCompRet.estado,'X'), -- levantar excepcion por actualizacion
                   a.detalle_rechazo = null,
                   a.ind_impresion_ret = 'S',
                   a.numero_envio_sri = 0
             where a.no_docu = est.no_docu
                 and a.no_cia = est.no_cia;

        Elsif  Ln_estado_doc_id = 2  Then  -- (Rechazado,  obtener motivo de rechazo en INFO_MENSAJE)
             Open  C_Mensaje (est.documento_id);
             Fetch C_Mensaje into Lv_mensaje;
             Close C_Mensaje;

             update arcpmd a
                set a.estado_sri = Ln_estado_doc_id,
                   a.detalle_rechazo = Lv_mensaje,
                   a.ind_impresion_ret = 'S',
                   a.numero_envio_sri = a.numero_envio_sri + 1
             where a.no_docu = est.no_docu
                 and a.no_cia = est.no_cia;

        Elsif  Ln_estado_doc_id = 0 Then  -- (Error por validacion WSTelconet,  obtener motivo de rechazo en INFO_MENSAJE)
             Open  C_Mensaje (est.documento_id);
             Fetch C_Mensaje into Lv_mensaje;
             Close C_Mensaje;

             update arcpmd a
                set a.estado_sri = Ln_estado_doc_id,
                   a.detalle_rechazo = Lv_mensaje,
                   a.numero_envio_sri = a.numero_envio_sri + 1
             where a.no_docu = est.no_docu
                 and a.no_cia = est.no_cia;

        Elsif  Ln_estado_doc_id = 5 Then  -- (Autorizado por validacion WSTelconet,  obtener mensaje en INFO_MENSAJE)
             Open  C_Mensaje (est.documento_id);
             Fetch C_Mensaje into Lv_mensaje;
             Close C_Mensaje;

            update arcpmd a
               set a.estado_sri = Ln_estado_doc_id,
                   a.detalle_rechazo = null,
                   a.ind_impresion_ret = 'S',
                   a.numero_envio_sri = a.numero_envio_sri + 1
             where a.no_docu = est.no_docu
                 and a.no_cia = est.no_cia;
        End if;
      Commit;
    end loop;

  End Ws_ConsultaCompElectOffLine;


-- Consulta de Estados
procedure Ws_ConsultaAutorizacionSRI  is

    Cursor C_AutorizacionSRI is
      select a.no_cia,
             a.no_docu,
             a.documento_id,
             a.tipo_doc_id,
             a.empresa_id
        from arcpmd a,
             arcpct b,
             arcgmc c
       where a.no_cia = b.no_cia
         and a.no_cia = c.no_cia
         and a.estado_sri = '5'    --  5:Autorizado
         and nvl(a.documento_id, 0) <> 0
         and nvl(a.mensaje_autorizacion_sri, '0') =  '0'
         and b.genera_doc_electronico = 'S'
         and b.tipo_generacion = 'WS'
       order by a.no_cia desc;

    Cursor C_Mensaje  ( Cn_documento number ) is
        Select  substr(mensaje||' - '||infoadicional, 1, 250)  informativo
        from DB_COMPROBANTES.INFO_MENSAJE
        where  documento_id = Cn_documento
        and id_mensaje in ( Select max(id_mensaje) mensaje
                                      from DB_COMPROBANTES.INFO_MENSAJE
                                      where documento_id = Cn_documento
                                      and mensaje = 'AUTORIZADO');

  Lv_mensaje     Arcpmd.Mensaje_Autorizacion_Sri%type;
  Lb_found         Boolean;
    --
  Begin
    For est in C_AutorizacionSRI Loop
        --
           Open  C_Mensaje (est.documento_id);
           Fetch C_Mensaje into Lv_mensaje;
           Lb_Found := nvl(C_Mensaje%found, false);
           Close C_Mensaje;

            If  Lb_Found  Then
               update arcpmd a
                  set  a.mensaje_autorizacion_sri  = Lv_mensaje
               where a.no_docu = est.no_docu
                   and a.no_cia = est.no_cia;

              Commit;
            End If;
    end loop;

  End Ws_ConsultaAutorizacionSRI;


Function Ws_CpGeneratorClave (Pv_FechaDocumento          IN Varchar2,
                                                  Pv_TipoComprobanteSRI    IN Varchar2,
                                                  Pv_Id_identificacion_prov   IN Varchar2,
                                                  Pv_AmbienteId                   IN Varchar2,
                                                  Pv_NoSerieComprob           IN Varchar2,
                                                  Pv_NoFisicoComprob          IN Varchar2,
                                                  Pv_TipoEmision                  IN Varchar2  ) return Varchar2 IS

   Lv_ClaveAcceso  DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%type;

Begin
    Lv_ClaveAcceso   :=  DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERATORCLAVE@GPOETNET (Pv_FechaDocumento,
                                                                                                                                                                Pv_TipoComprobanteSRI,
                                                                                                                                                                Pv_Id_identificacion_prov,
                                                                                                                                                                Pv_AmbienteId,
                                                                                                                                                                Pv_NoSerieComprob,
                                                                                                                                                                Pv_NoFisicoComprob,
                                                                                                                                                                Pv_FechaDocumento,
                                                                                                                                                                Pv_TipoEmision );
      return (Lv_ClaveAcceso);
End Ws_CpGeneratorClave;

PROCEDURE P_ENVIA_LIQUIDACION_COMPRAS   AS

   CURSOR C_DOCUMENTOS is

        SELECT A.NO_CIA,
             A.no_docu,
             D.ID_TRIBUTARIO rucEmpresa,
             (SELECT CODIGO FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO WHERE DESCRIPCION='liquidacionCompra' ) tipoDocumento,
             (SELECT ID_TIPO_DOC FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO WHERE DESCRIPCION='liquidacionCompra' ) tipoAdmiDocumento,
             A.FECHA_DOCUMENTO,
             A.FECHA,
             SUBSTR(A.SERIE_FISICO,1,3) establecimiento,
             SUBSTR(A.SERIE_FISICO,4,3) ptoEmision,
             LPAD(A.NO_FISICO,9,'0') secuencial,
             (A.SUBTOTAL+A.TOT_IMP) monto,
             A.ARCHIVO_COMP_ELECT nombreArchivo,
             F.USUARIO_WS usuario,
             F.CLAVE_WS clave,
             A.EST_SRI_COMP_ELECT estado_sri, 
             A.NUM_ENVIO_COMP_ELECT  numero_envio_sri,
             A.CLAVE_ACCESO_COMP_ELECT clave_acceso,
             A.DOCUMENTO_ID_COMP_ELECT documento_id,
             C.NO_PROVE,
             C.TIPO_ID_TRIBUTARIO,
             C.CEDULA identificacion,
             C.NOMBRE,
             C.EMAIL1,
             C.EMAIL2,
             C.DIRECCION,
             C.TELEFONO,
             C.PAIS,
             C.PROVINCIA,
             C.CANTON,
             XMLRoot(
             XMLElement("liquidacionCompra",
                        XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),

                        XMLElement("infoTributaria",
                                                     ( SELECT XMLElement("ambiente",  AE.AMBIENTE_ID)
                                                        FROM  DB_COMPROBANTES.ADMI_EMPRESA AE,
                                                                  DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
                                                        WHERE EG.COD_EMPRESA =  A.no_cia
                                                        and      EG.PREFIJO = AE.CODIGO ),
                                                     XMLElement("tipoEmision",'1'),
                                                     XMLElement("razonSocial",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.RAZON_SOCIAL)),
                                                     XMLElement("nombreComercial",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.RAZON_SOCIAL)),
                                                     XMLElement("ruc",b.id_tributario),
                                                     XMLElement("claveAcceso",A.CLAVE_ACCESO_COMP_ELECT),
                                                     XMLElement("codDoc",(SELECT CODIGO FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO WHERE DESCRIPCION='liquidacionCompra')),
                                                     XMLElement("estab",SUBSTR(A.SERIE_FISICO,1,3)),
                                                     XMLElement("ptoEmi",SUBSTR(A.SERIE_FISICO,4,3)),
                                                     XMLElement("secuencial",lpad(A.no_fisico , 9, '0')),
                                                     XMLElement("dirMatriz",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.DIRECCION))),

                        XMLElement("infoLiquidacionCompra", XMLElement("fechaEmision",to_char(A.fecha,'dd/mm/yyyy')),
                                                        XMLElement("dirEstablecimiento",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.DIRECCION)),
                                                        (SELECT XMLElement("contribuyenteEspecial", X.parametro) FROM GE_PARAMETROS x, GE_GRUPOS_PARAMETROS y
                                                          WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
                                                            AND X.ID_APLICACION = Y.ID_APLICACION
                                                            AND X.ID_EMPRESA = Y.ID_EMPRESA
                                                            AND X.ID_GRUPO_PARAMETRO = 'ES_CONTRIB_ESPECIAL'
                                                            AND X.ID_APLICACION = 'CP'
                                                            AND X.ID_EMPRESA = A.NO_CIA
                                                            AND X.ESTADO = 'A'
                                                            AND Y.ESTADO = 'A'),
                                                        XMLElement("obligadoContabilidad",'SI'),
                                                        XMLElement("tipoIdentificacionProveedor",DECODE(C.TIPO_ID_TRIBUTARIO,'R','04','C','05','P','06','F','07',C.TIPO_ID_TRIBUTARIO)),
                                                        XMLElement("razonSocialProveedor",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(C.NOMBRE_LARGO)),
                                                        XMLElement("identificacionProveedor",C.CEDULA),
                                                        XMLElement("totalSinImpuestos",A.SUBTOTAL),
                                                        XMLElement("totalDescuento",NVL(A.DESCUENTO,0)),
                                                         XMLElement("totalConImpuestos", (SELECT XMLAgg(
                                                          XMLElement("totalImpuesto",
                                                            XMLForest
                                                               (
                                                               NVL(Y.SRI_CODIGO_IVA, Y.SRI_CODIGO_ICE) as "codigo",
                                                                Y.SRI_CODIGO_IVA as "codigoPorcentaje",
                                                                TRIM(to_char(x.Base,'999999999999990.99')) as "baseImponible",
                                                                TRIM(to_char(X.PORCENTAJE,'990.99')) as "tarifa",
                                                                TRIM(TO_CHAR(X.MONTO,'999999999999990.99')) as "valor"
                                                                )))
                                                   FROM NAF47_TNET.ARCPTI X, NAF47_TNET.ARCGIMP Y
                                                  WHERE X.CLAVE = Y.CLAVE
                                                    AND X.NO_CIA = Y.NO_CIA
                                                    AND X.NO_DOCU = A.NO_DOCU
                                                    AND X.TIPO_DOC = A.TIPO_DOC
                                                    AND X.NO_CIA = A.NO_CIA
                                                    AND NVL(X.ANULADA, 'N') = 'N'
                                                    AND X.IND_IMP_RET = 'I'),

                                                    case WHEN NVL(A.EXCENTOS,0) >0 THEN
                                                    XMLElement("totalImpuesto",XMLElement("codigo",'2'),
                                                                          XMLElement("codigoPorcentaje",DECODE(TIPO_BASE_IMPONIBLE,'TC','0','NO','6','EX','7',TIPO_BASE_IMPONIBLE)),
                                                                          XMLElement("baseImponible",A.EXCENTOS),
                                                                          XMLElement("tarifa",'0'),

                                                                          XMLElement("valor",'0'))
                                                                          end),
                                                    XMLElement("importeTotal",TRIM(TO_CHAR(A.SUBTOTAL+A.TOT_IMP,'999999999999990.99'))),
                                                    XMLElement("moneda",'DOLAR'),
                                                    XMLElement("pagos",XMLElement("pago",XMLElement("formaPago",A.FORMA_PAGO_ID),

                                                                                         XMLElement("total",TRIM(TO_CHAR(A.SUBTOTAL+A.TOT_IMP,'999999999999990.99'))),
                                                                                         XMLElement("plazo",A.PLAZO_C)))),
                        XMLElement("detalles",(SELECT XMLAgg(XMLElement("detalle", XMLForest
                                                               (DS.SERVICIO_ID as "codigoPrincipal",
                                                                DECODE (DS.DESCRIPCION_SERVICIO,NULL,
                                                                (SELECT DESCRIPCION
                                                                                                                    FROM NAF47_TNET.TAPCPS
                                                                                                                    WHERE NO_CIA = DS.NO_CIA 
                                                                                                                    AND CODIGO =DS.SERVICIO_ID),DS.DESCRIPCION_SERVICIO)as "descripcion",
                                                                 1 AS "cantidad",
                                                                 DECODE(DS.GRAVADO,NULL,DS.EXCENTO,DS.GRAVADO)as "precioUnitario",
                                                                 0 as "descuento",
                                                                 DECODE(DS.GRAVADO,NULL,DS.EXCENTO,DS.GRAVADO)as "precioTotalSinImpuesto",
                                                                
                                                                 CASE WHEN NVL(DS.GRAVADO,0) >0 THEN
                                                                 (SELECT XMLAgg(
                                                                 
                                                          XMLElement("impuesto",
                                                            XMLForest
                                                               (
                                                               NVL(Y.SRI_CODIGO_IVA, Y.SRI_CODIGO_ICE) as "codigo",
                                                                Y.SRI_CODIGO_IVA as "codigoPorcentaje",
                                                                TRIM(to_char(X.PORCENTAJE,'990.99')) as "tarifa",
                                                                TRIM(to_char(X.BASE,'999999999999990.99')) as "baseImponible",
                                                               TRIM(to_char(X.Monto,'999999999999990.99')) as "valor"
                                                                )))
                                                   FROM NAF47_TNET.ARCPTI X, NAF47_TNET.ARCGIMP y
                                                  WHERE x.CLAVE = Y.CLAVE
                                                    AND X.NO_CIA = Y.NO_CIA
                                                    AND X.NO_DOCU = A.NO_DOCU
                                                    AND X.TIPO_DOC = A.TIPO_DOC
                                                    AND X.NO_CIA = A.No_Cia
                                                    AND NVL(X.ANULADA, 'N') = 'N'
                                                    AND X.IND_IMP_RET = 'I')
                                                   ELSE
                                                   
                                                   XMLElement("impuesto",XMLElement("codigo",'2'),
                                                                          XMLElement("codigoPorcentaje",DECODE(TIPO_BASE_IMPONIBLE,'TC','0','NO','6','EX','7',TIPO_BASE_IMPONIBLE)),
                                                                          XMLElement("tarifa",'0'),
                                                                          XMLElement("baseImponible",DS.TOTAL),
                                                                          XMLElement("valor",'0'))
                                                                          
                                                   END
                                                    
                                                    as "impuestos"
                                                                 
                                                                 
                                                                )
                                                         )
                                               ) FROM ARCPDS DS WHERE DS.NO_CIA=A.NO_CIA AND DS.NO_DOCU=A.NO_DOCU 
                                                                      AND DS.TIPO_DOC=A.TIPO_DOC)       
                                   ),                                                                 
                        XMLElement("infoAdicional", case WHEN C.EMAIL1 is not null and C.EMAIL2 is not null THEN
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.EMAIL1||';'||C.EMAIL2)
                                                         WHEN C.EMAIL1 is not null THEN
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.EMAIL1)
                                                         WHEN C.EMAIL2 is not null THEN
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.EMAIL2)
                                                    end case,
                                                    (SELECT XMLElement("campoAdicional", XMLAttributes('tipoComprobante' AS "nombre"),GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(Z.DESCRIPCION))
                                                       FROM NAF47_TNET.SRI_TIPOS_COMPROBANTES Z
                                                      WHERE Z.CODIGO = E.CODIGO_TIPO_COMPROBANTE)
                                                   )
                        ), VERSION '1.0" encoding="UTF-8') result_xml
        FROM NAF47_TNET.ARCPMD A,
             NAF47_TNET.ARCGMC B,
             NAF47_TNET.ARCPMP C,
             NAF47_TNET.ARCGMC D,
             NAF47_TNET.ARCPTD E,
             NAF47_TNET.ARCPCT F
       WHERE A.NO_CIA = B.NO_CIA
         AND A.NO_PROVE = C.NO_PROVE
         AND A.NO_CIA = C.NO_CIA
         AND A.NO_CIA = D.NO_CIA
         AND A.NO_CIA = E.NO_CIA
         AND A.TIPO_DOC = E.TIPO_DOC
         AND EST_SRI_COMP_ELECT='G'
         AND A.NO_CIA = F.NO_CIA
         AND F.GENERA_DOC_ELECTRONICO = 'S'
         AND F.TIPO_GENERACION = 'WS'
         ORDER BY A.NO_CIA, A.NO_DOCU;


    CURSOR C_PARAMETROORIGENDOC(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)    IS
          SELECT PAD.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
               DB_GENERAL.ADMI_PARAMETRO_DET PAD
          WHERE PAC.NOMBRE_PARAMETRO = Cv_NombreParametro
          AND PAC.ID_PARAMETRO  = PAD.PARAMETRO_ID
          AND PAC.ESTADO            ='Activo'
          AND PAD.ESTADO           ='Activo'
          AND PAD.DESCRIPCION      ='OFFLINE';

    CURSOR C_WSPARAMETROCIUDAD (Cv_Pais Varchar2,  Cv_Provincia Varchar2,  Cv_Canton Varchar2 ) is
          SELECT DESCRIPCION FROM  NAF47_TNET.ARGECAN c
          WHERE C.PAIS = Cv_Pais
          and C.PROVINCIA = Cv_Provincia
          and C.CANTON = Cv_Canton;

    -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR NUMERO DE IDENTIFICACION

    CURSOR C_USUARIOEXISTE(Cv_Identificacion DB_COMPROBANTES.ADMI_USUARIO.LOGIN%TYPE)    IS
          SELECT ID_USUARIO
          FROM DB_COMPROBANTES.ADMI_USUARIO
          WHERE LOGIN = Cv_Identificacion
          AND ID_USUARIO  = ( SELECT MAX(ID_USUARIO)
                              FROM DB_COMPROBANTES.ADMI_USUARIO
                              WHERE LOGIN = Cv_Identificacion);

    -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR EMPRESA
    CURSOR C_USUARIOEMPEXISTE(Cn_IdUsuario    DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE,
                              Cn_IdEmpresa  DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE)  IS
        SELECT USUE.ID_USR_EMP
        FROM  DB_COMPROBANTES.ADMI_USUARIO USU,
              DB_COMPROBANTES.ADMI_USUARIO_EMPRESA USUE
        WHERE  USUE.USUARIO_ID     = USU.ID_USUARIO
        AND USUE.EMPRESA_ID = Cn_IdEmpresa
        AND USU.ID_USUARIO    = Cn_IdUsuario
        AND USUE.ID_USR_EMP  =(SELECT MAX(USUE.ID_USR_EMP)
                               FROM  DB_COMPROBANTES.ADMI_USUARIO USU,
                               DB_COMPROBANTES.ADMI_USUARIO_EMPRESA USUE
                               WHERE  USUE.USUARIO_ID     = USU.ID_USUARIO
                               AND USUE.EMPRESA_ID = Cn_IdEmpresa
                                AND USU.ID_USUARIO = Cn_IdUsuario);

    CURSOR C_PARAMETROEMPRESA (Cv_IdEmpresa Varchar2) is
        SELECT AE.ID_EMPRESA, AE.AMBIENTE_ID
        FROM  DB_COMPROBANTES.ADMI_EMPRESA AE,
              DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
        WHERE EG.COD_EMPRESA = Cv_IdEmpresa
        AND   EG.PREFIJO = AE.CODIGO;

    CURSOR C_WSPARAMETROTIPOIDENTIF (Cv_IdEmpresa Varchar2, Cv_NoProve Varchar2)  is
        SELECT GP.NUMERICO
        FROM NAF47_TNET.ARCPMP mp, NAF47_TNET.GE_PARAMETROS gp
        WHERE MP.NO_CIA = Cv_IdEmpresa
        AND MP.NO_PROVE = Cv_NoProve
        AND GP.ID_APLICACION ='CP'
        AND GP.ID_GRUPO_PARAMETRO = 'HOMOLOGA_NAF_TELCOS'
        AND GP.PARAMETRO = MP.TIPO_ID_TRIBUTARIO;


  Lr_CompAdmiUsuario       DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuario               := NULL;
  Lr_CompAdmiUsuarioEmp    DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuarioEmpresa  := NULL;
  Lr_CompInfoDocumento     DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento            := NULL;
  Lv_Ciudad                NAF47_TNET.ARGECAN.DESCRIPCION%TYPE;
  Ln_IdEmpresa             DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE;
  Ln_IdTipoIdentificacion  DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_IDENTIFICACION_ID%TYPE;
  Ln_AmbienteId            DB_COMPROBANTES.ADMI_EMPRESA.AMBIENTE_ID%TYPE;
  Ln_IdDocumento           DB_COMPROBANTES.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE:=NULL;
  Lv_Password              DB_COMPROBANTES.ADMI_USUARIO.PASSWORD%TYPE:=NULL;
  Le_Error                 EXCEPTION;
  Lv_MessageError          VARCHAR2(2000);
  Lv_NoCia                 NAF47_TNET.ARCPMD.NO_CIA%TYPE;
  Lv_NoDocu                NAF47_TNET.ARCPMD.NO_DOCU%TYPE;
  Lv_OrigenDocumento       VARCHAR2(25);
  Ln_IdUsuario             DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE;
  Ln_IdUsuarioEmpresa      DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.USUARIO_ID%TYPE;
  LvMailsProveedor         DB_COMPROBANTES.ADMI_USUARIO.EMAIL%TYPE;
    --
BEGIN
    FOR DOC in C_DOCUMENTOS LOOP
        -- Para guaradar el referencia de registro a revicsar
         Lv_NoCia     := DOC.NO_CIA;
         Lv_NoDocu    := DOC.NO_DOCU;

         -- *****  Validadciones por Parametrizacin de Esquema
        OPEN C_ParametroOrigenDoc('ORIGEN_FACTURACION');
        FETCH C_ParametroOrigenDoc INTO Lv_OrigenDocumento;

        IF Lv_OrigenDocumento IS NULL THEN
          Lv_MessageError :=  'Error No existe Parametro ORIGEN_FACTURACION que define si es Online/Offline';
          RAISE Le_Error;
       END IF;
        CLOSE C_ParametroOrigenDoc;

        Case WHEN  DOC.EMAIL1 is not null and  DOC.EMAIL2 is not null THEN
               LvMailsProveedor := DOC.EMAIL1 ||';'|| DOC.EMAIL2;
             WHEN DOC.EMAIL1 is not null THEN
               LvMailsProveedor := DOC.EMAIL1;
             WHEN DOC.EMAIL2 is not null THEN
               LvMailsProveedor := DOC.EMAIL2;
        End Case;

        IF C_USUARIOEXISTE%ISOPEN         THEN  CLOSE C_USUARIOEXISTE;      END IF;
        IF C_USUARIOEMPEXISTE%ISOPEN  THEN  CLOSE C_USUARIOEMPEXISTE;END IF;

        --SI ES FACT OFFLINE SE REALIZA EL INGRESO DEL ADMI_USUARIO, ADMI_USUARIO_EMPRESA, INFO_DOCUMENTO EN DB_COMPROBANTES
        IF Lv_OrigenDocumento = 'Offline' THEN

               -- *****  Existe Usuario se busca por Identificacin
               OPEN C_USUARIOEXISTE(DOC.identificacion);
               FETCH C_USUARIOEXISTE INTO Ln_IdUsuario;

                IF (C_USUARIOEXISTE%notfound) THEN
                  -- Obtenci�n de clave para el Usuario  
                 Lv_Password  := DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERA_PASSWD_SHA256 (DOC.identificacion);

                  Ln_IdUsuario                         :=DB_COMPROBANTES.SEQ_ADMI_USUARIO.NEXTVAL;
                  Lr_CompAdmiUsuario.ID_USUARIO        :=Ln_IdUsuario;
                  Lr_CompAdmiUsuario.LOGIN             :=DOC.identificacion;
                  Lr_CompAdmiUsuario.NOMBRES           :=DOC.Nombre;
                  Lr_CompAdmiUsuario.APELLIDOS         :=NULL;
                  Lr_CompAdmiUsuario.EMAIL             :=LvMailsProveedor;
                  Lr_CompAdmiUsuario.ADMIN             :='N';
                  Lr_CompAdmiUsuario.ESTADO            :='Activo';
                  Lr_CompAdmiUsuario.FE_CREACION       :=SYSDATE;
                  Lr_CompAdmiUsuario.USR_CREACION      :=TRIM(User);
                  Lr_CompAdmiUsuario.FE_ULT_MOD        :=NULL;
                  Lr_CompAdmiUsuario.USR_ULT_MOD       :=NULL;
                  Lr_CompAdmiUsuario.IP_CREACION       :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                  Lr_CompAdmiUsuario.PASSWORD          := Lv_Password;
                  Lr_CompAdmiUsuario.EMPRESA           :='N';
                  Lr_CompAdmiUsuario.LOCALE            :='es_EC';
                  Lr_CompAdmiUsuario.EMPRESA_CONSULTA  :='N';

                  DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIO_COMP_ELECT(Lr_CompAdmiUsuario, Lv_MessageError);
                ELSE
                   Ln_IdUsuario := Ln_IdUsuario;
               END IF;
                CLOSE C_USUARIOEXISTE;

                IF Lv_MessageError IS NOT NULL THEN  

                  BEGIN
                    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.P_INSERT_USUARIO_COMP_ELECT', 'INGRESO DE ADMI_USUARIO', Lv_MessageError);
                    RAISE Le_Error;
                  END;
               END IF;

                --VERIFICO SI EXISTE EL USUARIO CREADO PARA LA EMPRESA ESPECIFICA, SI NO EXISTE SE INSERTA
                OPEN C_PARAMETROEMPRESA(DOC.NO_CIA);
                FETCH C_PARAMETROEMPRESA INTO Ln_IdEmpresa, Ln_AmbienteId;
                CLOSE C_PARAMETROEMPRESA;

                OPEN C_WSPARAMETROCIUDAD(DOC.PAIS,  DOC.PROVINCIA, DOC.CANTON );
                FETCH C_WSPARAMETROCIUDAD INTO Lv_Ciudad;
                CLOSE C_WSPARAMETROCIUDAD;

                OPEN C_USUARIOEMPEXISTE(Ln_IdUsuario,  Ln_IdEmpresa);
                FETCH C_USUARIOEMPEXISTE INTO Ln_IdUsuarioEmpresa;

                IF(C_UsuarioEmpExiste%notfound) THEN

                  Ln_IdUsuarioEmpresa                       :=DB_COMPROBANTES.SEQ_ADMI_USUARIO_EMPRESA.NEXTVAL;
                  Lr_CompAdmiUsuarioEmp.ID_USR_EMP          :=Ln_IdUsuarioEmpresa;
                  Lr_CompAdmiUsuarioEmp.USUARIO_ID          :=Ln_IdUsuario;
                  Lr_CompAdmiUsuarioEmp.EMPRESA_ID          :=Ln_IdEmpresa;
                  Lr_CompAdmiUsuarioEmp.FE_CREACION         :=SYSDATE;
                  Lr_CompAdmiUsuarioEmp.USR_CREACION        :=TRIM(User);
                  Lr_CompAdmiUsuarioEmp.FE_ULT_MOD          :=NULL;
                  Lr_CompAdmiUsuarioEmp.USR_ULT_MOD         :=NULL;
                  Lr_CompAdmiUsuarioEmp.IP_CREACION         :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                  Lr_CompAdmiUsuarioEmp.EMAIL               :=LvMailsProveedor;
                  Lr_CompAdmiUsuarioEmp.DIRECCION           :=DOC.direccion;
                  Lr_CompAdmiUsuarioEmp.TELEFONO            :=DOC.Telefono;
                  Lr_CompAdmiUsuarioEmp.CIUDAD              :=Lv_Ciudad;
                  Lr_CompAdmiUsuarioEmp.NUMERO              :=NULL;
                  Lr_CompAdmiUsuarioEmp.FORMAPAGO           :=NULL;
                  Lr_CompAdmiUsuarioEmp.LOGIN               :=NULL;
                  Lr_CompAdmiUsuarioEmp.CONTRATO            :=NULL;
                  Lr_CompAdmiUsuarioEmp.PASSWORD            := Lv_Password;
                  Lr_CompAdmiUsuarioEmp.N_CONEXION          :=0;
                  Lr_CompAdmiUsuarioEmp.FE_ULT_CONEXION     :=NULL;
                  Lr_CompAdmiUsuarioEmp.CAMBIO_CLAVE        :='N';

                 DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIOEMP_COMP_ELECT(Lr_CompAdmiUsuarioEmp, Lv_MessageError);

                ELSE
                   Ln_IdUsuarioEmpresa  :=  Ln_IdUsuarioEmpresa;
               END IF;
                CLOSE C_USUARIOEMPEXISTE;

                IF Lv_MessageError IS NOT NULL  THEN  

                  BEGIN
                    Lv_MessageError := Lv_MessageError ;
                     DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.P_INSERT_USUARIOEMP_COMP_ELECT', 'INGRESO DE ADMI_USUARIO_EMPRESA', Lv_MessageError);
                   RAISE Le_Error;
                  END;
               END IF;

                OPEN C_WSPARAMETROTIPOIDENTIF( DOC.NO_CIA,  DOC.NO_PROVE );
                FETCH C_WSPARAMETROTIPOIDENTIF INTO Ln_IdTipoIdentificacion;
                CLOSE C_WSPARAMETROTIPOIDENTIF;

                --SETEO CAMPOS PARA INSERTAR EN DB_COMPROBANTES -> INFO_DOCUMENTO
                Ln_IdDocumento                               :=  DB_COMPROBANTES.SEQ_INFO_DOCUMENTO.NEXTVAL;
                Lr_CompInfoDocumento.ID_DOCUMENTO            := Ln_IdDocumento;
                Lr_CompInfoDocumento.TIPO_DOC_ID             := DOC.tipoAdmiDocumento;
                Lr_CompInfoDocumento.FORMATO_ID              := 1;
                Lr_CompInfoDocumento.EMPRESA_ID              := Ln_IdEmpresa;
                Lr_CompInfoDocumento.NOMBRE                  := DOC.nombreArchivo;
                Lr_CompInfoDocumento.FE_CREACION             := SYSDATE;
                Lr_CompInfoDocumento.USR_CREACION            := TRIM(User);
                Lr_CompInfoDocumento.FE_ULT_MOD              := NULL;
                Lr_CompInfoDocumento.USR_ULT_MOD             := NULL;
                Lr_CompInfoDocumento.IP_CREACION             := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                Lr_CompInfoDocumento.ESTABLECIMIENTO         := DOC.establecimiento;
                Lr_CompInfoDocumento.PUNTO_EMISION           := DOC.ptoEmision;
                Lr_CompInfoDocumento.VALOR                   := DOC.monto;
                Lr_CompInfoDocumento.ESTADO_DOC_ID           := 10;
                Lr_CompInfoDocumento.VERSION                 := 1;
                Lr_CompInfoDocumento.SECUENCIAL              := DOC.secuencial;
                Lr_CompInfoDocumento.FE_RECIBIDO             := SYSDATE;
                Lr_CompInfoDocumento.TIPO_IDENTIFICACION_ID  := Ln_IdTipoIdentificacion;
                Lr_CompInfoDocumento.IDENTIFICACION            := DOC.identificacion;
                Lr_CompInfoDocumento.TIPO_EMISION_ID           := 1;
                Lr_CompInfoDocumento.USUARIO_ID                := Ln_IdUsuario;
                Lr_CompInfoDocumento.LOTEMASIVO_ID             := 0;
                Lr_CompInfoDocumento.XML_ORIGINAL              := NAF47_TNET.MIG_LEE_CAMPOS_LOB.F_XMLBLOG(DOC.result_xml);--DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_XMLBLOG(DOC.result_xml);
                Lr_CompInfoDocumento.AMBIENTE_ID               := Ln_AmbienteId;
                Lr_CompInfoDocumento.FE_EMISION                := DOC.fecha;
                Lr_CompInfoDocumento.INTENTO_RECEPCION         := 0;
                Lr_CompInfoDocumento.INTENTO_CONSULTA          := 0;
                Lr_CompInfoDocumento.ORIGEN_DOCUMENTO          := Lv_OrigenDocumento;
                Lr_CompInfoDocumento.CLAVE_ACCESO              := DOC.clave_acceso;
                Lr_CompInfoDocumento.DOCUMENTO_ID_FINAN        := 0;
       END IF;

        IF  DOC.numero_envio_sri = 0 THEN 

              NAF47_TNET.MIG_LEE_CAMPOS_LOB.P_INSERT_INFO_DOCUMENTO(Lr_CompInfoDocumento, Lv_MessageError);

               IF Lv_MessageError IS NOT NULL  THEN  

                  BEGIN
                     Lv_MessageError := Lv_MessageError || ' Se trat� de hacer un comprobante no permitido IdDocumento: '||TO_CHAR(Ln_IdDocumento);
                     DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.P_INSERT_INFO_DOCUMENTO', 'INGRESO DE INFO_DOCUMENTO', Lv_MessageError);
                   RAISE Le_Error;
                  END;
               END IF;

        ELSIF  DOC.numero_envio_sri  >  0  THEN

              --ACTUALIZO INFO_DOCUMENTO
              Lr_CompInfoDocumento.FE_ULT_MOD        := SYSDATE;
              Lr_CompInfoDocumento.USR_ULT_MOD       := TRIM(User);
              Ln_IdDocumento                         := doc.documento_id;
              Lr_CompInfoDocumento.ID_DOCUMENTO      := Ln_IdDocumento;
              NAF47_TNET.MIG_LEE_CAMPOS_LOB.P_UPDATE_Info_Documento_NAF(Lr_CompInfoDocumento, Lv_MessageError);
       END IF;

         If  Lv_MessageError  is not null THEN
             RAISE Le_Error;
         Else
              -- Se cambia de estado_sri para que este proceso no lo vuelva a tomar en cuentA.

              UPDATE NAF47_TNET.ARCPMD
                      SET EST_SRI_COMP_ELECT  = '10',
                      NUM_ENVIO_COMP_ELECT    = DOC.numero_envio_sri + 1,
                      DOCUMENTO_ID_COMP_ELECT = Ln_IdDocumento,
                      TIPO_DOC_COMP_ELECT     = DOC.tipoAdmiDocumento,
                      EMPRESA_ID_COMP_ELECT   =Ln_IdEmpresa
               WHERE NO_CIA =  DOC.NO_CIA
                    AND NO_DOCU = DOC.no_docu;

              COMMIT;
        END IF;

    END LOOP;

  EXCEPTION
    WHEN Le_Error THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION_ELECTRONICA',
                                                         'NAF47_TNET.INKG_LIQUIDACION_COMPRAS.P_ENVIA_LIQUIDACION_COMPRAS',
                                                         Lv_MessageError);
      UPDATE NAF47_TNET.ARCPMD A
         set A.EST_SRI_COMP_ELECT = '0',
             A.DET_RECHAZO_COMP_ELECT = Lv_MessageError
       WHERE A.NO_DOCU =  Lv_NoDocu
         and A.NO_CIA = Lv_NoCia;

      COMMIT;

    WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION_ELECTRONICA',
                                                         'NAF47_TNET.INKG_LIQUIDACION_COMPRAS.P_ENVIA_LIQUIDACION_COMPRAS',
                                                         SQLERRM);
      UPDATE NAF47_TNET.ARCPMD a
         SET A.EST_SRI_COMP_ELECT     = '0',
             A.DET_RECHAZO_COMP_ELECT = Lv_MessageError
       WHERE A.NO_DOCU =  Lv_NoDocu
         AND A.NO_CIA = Lv_NoCia;

      COMMIT;

  END P_ENVIA_LIQUIDACION_COMPRAS;

  PROCEDURE P_CONSULTA_ESTADO_LIQ_COMPRAS  is

    CURSOR C_REGISTROCONSULTO is
      SELECT A.NO_CIA,
             A.NO_DOCU,
             A.CLAVE_ACCESO_COMP_ELECT CLAVE_ACCESO,
             A.ARCHIVO_COMP_ELECT NOMBREARCHIVO,
             A.EST_SRI_COMP_ELECT ESTADO_SRI,
             A.DOCUMENTO_ID_COMP_ELECT  DOCUMENTO_ID,
             A.TIPO_DOC_COMP_ELECT TIPO_DOC_ID,
             A.EMPRESA_ID_COMP_ELECT EMPRESA_ID
        FROM NAF47_TNET.ARCPMD a,
             NAF47_TNET.ARCPCT B,
             NAF47_TNET.ARCGMC C
       WHERE A.NO_CIA = B.NO_CIA
         AND A.NO_CIA = C.NO_CIA
         AND A.EST_SRI_COMP_ELECT in ('1','3','10')  -- 0:Error,   1:Iniciado;   2:Rechazado;   3:Recibido,   4:Negado,   5:Autorizado,   8:Anulado,   10:EnviadoCompElect
         AND B.GENERA_DOC_ELECTRONICO = 'S'
         AND B.TIPO_GENERACION = 'WS'
       ORDER BY A.NO_CIA DESC;

    CURSOR C_ESTADODCOUMENTO  ( Cn_Documento NUMBER, Cn_Tipo NUMBER,  Cn_Empresa NUMBER) IS
        SELECT CLAVE_ACCESO, ESTADO_DOC_ID
        FROM DB_COMPROBANTES.INFO_DOCUMENTO
        WHERE TIPO_DOC_ID      =  Cn_Tipo
             AND ID_DOCUMENTO  = Cn_Documento
             AND EMPRESA_ID    = Cn_Empresa;

    CURSOR C_MENSAJE  ( Cn_documento number ) is
        SELECT  SUBSTR(TIPO||' - '||MENSAJE||' - '||INFOADICIONAL,1,2000)  informativo
        FROM DB_COMPROBANTES.INFO_MENSAJE
        WHERE  DOCUMENTO_ID = Cn_documento
        AND ID_MENSAJE IN ( SELECT MAX(ID_MENSAJE) mensaje
                                      FROM DB_COMPROBANTES.INFO_MENSAJE
                                      WHERE DOCUMENTO_ID = Cn_documento );

  Lv_clave_acceso    DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%TYPE;    
  Ln_estado_doc_id   DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_SRI_ID%TYPE;  
  Lv_mensaje         ARCPMD.DET_RECHAZO_COMP_ELECT%TYPE;

  BEGIN
    FOR est in C_REGISTROCONSULTO LOOP  -- Registro con estado_sri in ('1','3','10')

        --
        OPEN C_ESTADODCOUMENTO(est.documento_id, est.tipo_doc_id, est.empresa_id); -- Estado actual en Telcos
        Fetch C_ESTADODCOUMENTO INTO Lv_clave_acceso, Ln_estado_doc_id;
        CLOSE C_ESTADODCOUMENTO;
        --
        Open  C_MENSAJE (est.documento_id);
        Fetch C_MENSAJE INTO Lv_mensaje;
        CLOSE C_MENSAJE;
        --
        UPDATE NAF47_TNET.ARCPMD a
        set A.EST_SRI_COMP_ELECT = Ln_estado_doc_id,
            A.DET_RECHAZO_COMP_ELECT = DECODE(Ln_estado_doc_id, 1, NULL, 5, NULL, Lv_mensaje),
            A.NUM_ENVIO_COMP_ELECT = DECODE(Ln_estado_doc_id, 1, 0, A.NUM_ENVIO_COMP_ELECT + 1)
        WHERE A.NO_DOCU = est.no_docu
        and A.NO_CIA = est.no_cia;
        --
    END LOOP;
    --
    COMMIT;
    --
  END P_CONSULTA_ESTADO_LIQ_COMPRAS;

  PROCEDURE P_GENERA_XML_FISICO (Pv_noDocu IN VARCHAR2,
                                Pv_NoCia  IN VARCHAR2) IS
   CURSOR C_DOCUMENTOS is

        SELECT XMLRoot(
             XMLElement("liquidacionCompra",
                        XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),

                        XMLElement("infoTributaria",
                                                     ( SELECT XMLElement("ambiente",  AE.AMBIENTE_ID)
                                                        FROM  DB_COMPROBANTES.ADMI_EMPRESA AE,
                                                                  DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
                                                        WHERE EG.COD_EMPRESA =  A.no_cia
                                                        and      EG.PREFIJO = AE.CODIGO ),
                                                     XMLElement("tipoEmision",'1'),
                                                     XMLElement("razonSocial",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.RAZON_SOCIAL)),
                                                     XMLElement("nombreComercial",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.RAZON_SOCIAL)),
                                                     XMLElement("ruc",b.id_tributario),
                                                     XMLElement("claveAcceso",A.CLAVE_ACCESO_COMP_ELECT),
                                                     XMLElement("codDoc",(SELECT CODIGO FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO WHERE DESCRIPCION='liquidacionCompra')),
                                                     XMLElement("estab",SUBSTR(A.SERIE_FISICO,1,3)),
                                                     XMLElement("ptoEmi",SUBSTR(A.SERIE_FISICO,4,3)),
                                                     XMLElement("secuencial",lpad(A.no_fisico , 9, '0')),
                                                     XMLElement("dirMatriz",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.DIRECCION))),

                        XMLElement("infoLiquidacionCompra", XMLElement("fechaEmision",to_char(A.fecha,'dd/mm/yyyy')),
                                                        XMLElement("dirEstablecimiento",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(B.DIRECCION)),
                                                        (SELECT XMLElement("contribuyenteEspecial", X.parametro) FROM GE_PARAMETROS x, GE_GRUPOS_PARAMETROS y
                                                          WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
                                                            AND X.ID_APLICACION = Y.ID_APLICACION
                                                            AND X.ID_EMPRESA = Y.ID_EMPRESA
                                                            AND X.ID_GRUPO_PARAMETRO = 'ES_CONTRIB_ESPECIAL'
                                                            AND X.ID_APLICACION = 'CP'
                                                            AND X.ID_EMPRESA = A.NO_CIA
                                                            AND X.ESTADO = 'A'
                                                            AND Y.ESTADO = 'A'),
                                                        XMLElement("obligadoContabilidad",'SI'),
                                                        XMLElement("tipoIdentificacionProveedor",DECODE(C.TIPO_ID_TRIBUTARIO,'R','04','C','05','P','06','F','07',C.TIPO_ID_TRIBUTARIO)),
                                                        XMLElement("razonSocialProveedor",GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(C.NOMBRE_LARGO)),
                                                        XMLElement("identificacionProveedor",C.CEDULA),
                                                        XMLElement("totalSinImpuestos",A.SUBTOTAL),
                                                        XMLElement("totalDescuento",NVL(A.DESCUENTO,0)),
                                                         XMLElement("totalConImpuestos", (SELECT XMLAgg(
                                                          XMLElement("totalImpuesto",
                                                            XMLForest
                                                               (
                                                               NVL(Y.SRI_CODIGO_IVA, Y.SRI_CODIGO_ICE) as "codigo",
                                                                Y.SRI_CODIGO_IVA as "codigoPorcentaje",
                                                                TRIM(to_char(x.Base,'999999999999990.99')) as "baseImponible",
                                                                TRIM(to_char(X.PORCENTAJE,'990.99')) as "tarifa",
                                                                TRIM(TO_CHAR(X.MONTO,'999999999999990.99')) as "valor"
                                                                )))
                                                   FROM NAF47_TNET.ARCPTI X, NAF47_TNET.ARCGIMP Y
                                                  WHERE X.CLAVE = Y.CLAVE
                                                    AND X.NO_CIA = Y.NO_CIA
                                                    AND X.NO_DOCU = A.NO_DOCU
                                                    AND X.TIPO_DOC = A.TIPO_DOC
                                                    AND X.NO_CIA = A.NO_CIA
                                                    AND NVL(X.ANULADA, 'N') = 'N'
                                                    AND X.IND_IMP_RET = 'I'),

                                                    case WHEN NVL(A.EXCENTOS,0) >0 THEN
                                                    XMLElement("totalImpuesto",XMLElement("codigo",'2'),
                                                                          XMLElement("codigoPorcentaje",'0'),
                                                                          XMLElement("baseImponible",A.EXCENTOS),
                                                                          XMLElement("tarifa",'0'),

                                                                          XMLElement("valor",'0'))
                                                                          end),
                                                    XMLElement("importeTotal",TRIM(TO_CHAR(A.SUBTOTAL+A.TOT_IMP,'999999999999990.99'))),
                                                    XMLElement("moneda",'DOLAR'),
                                                    XMLElement("pagos",XMLElement("pago",XMLElement("formaPago",A.FORMA_PAGO_ID),

                                                                                         XMLElement("total",TRIM(TO_CHAR(A.SUBTOTAL+A.TOT_IMP,'999999999999990.99'))),
                                                                                         XMLElement("plazo",A.PLAZO_C)))),
                        XMLElement("detalles",(SELECT XMLAgg(XMLElement("detalle", XMLForest
                                                               (DS.SERVICIO_ID as "codigoPrincipal",
                                                                (SELECT DESCRIPCION
                                                                                                                    FROM NAF47_TNET.TAPCPS
                                                                                                                    WHERE NO_CIA = DS.NO_CIA 
                                                                                                                    AND CODIGO =DS.SERVICIO_ID)as "descripcion",
                                                                 1 AS "cantidad",
                                                                 DECODE(DS.GRAVADO,NULL,DS.EXCENTO,DS.GRAVADO)as "precioUnitario",
                                                                 0 as "descuento",
                                                                 DECODE(DS.GRAVADO,NULL,DS.EXCENTO,DS.GRAVADO)as "precioTotalSinImpuesto",
                                                                
                                                                 CASE WHEN NVL(DS.GRAVADO,0) >0 THEN
                                                                 (SELECT XMLAgg(
                                                                 
                                                          XMLElement("impuesto",
                                                            XMLForest
                                                               (
                                                               NVL(Y.SRI_CODIGO_IVA, Y.SRI_CODIGO_ICE) as "codigo",
                                                                Y.SRI_CODIGO_IVA as "codigoPorcentaje",
                                                                TRIM(to_char(X.PORCENTAJE,'990.99')) as "tarifa",
                                                                TRIM(to_char(X.BASE,'999999999999990.99')) as "baseImponible",
                                                               TRIM(to_char(X.Monto,'999999999999990.99')) as "valor"
                                                                )))
                                                   FROM NAF47_TNET.ARCPTI X, NAF47_TNET.ARCGIMP y
                                                  WHERE x.CLAVE = Y.CLAVE
                                                    AND X.NO_CIA = Y.NO_CIA
                                                    AND X.NO_DOCU = A.NO_DOCU
                                                    AND X.TIPO_DOC = A.TIPO_DOC
                                                    AND X.NO_CIA = A.No_Cia
                                                    AND NVL(X.ANULADA, 'N') = 'N'
                                                    AND X.IND_IMP_RET = 'I')
                                                   ELSE
                                                   
                                                   XMLElement("impuesto",XMLElement("codigo",'2'),
                                                                          XMLElement("codigoPorcentaje",DECODE(TIPO_BASE_IMPONIBLE,'TC','0','NO','6','EX','7',TIPO_BASE_IMPONIBLE)),
                                                                          XMLElement("tarifa",'0'),
                                                                          XMLElement("baseImponible",A.EXCENTOS),
                                                                          XMLElement("valor",'0'))
                                                                          
                                                   END
                                                    
                                                    as "impuestos"
                                                                 
                                                                 
                                                                )
                                                         )
                                               ) FROM ARCPDS DS WHERE DS.NO_CIA=A.NO_CIA AND DS.NO_DOCU=A.NO_DOCU 
                                                                      AND DS.TIPO_DOC=A.TIPO_DOC)       
                                   ),                                                                 
                        XMLElement("infoAdicional", case WHEN C.EMAIL1 is not null and C.EMAIL2 is not null THEN
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.EMAIL1||';'||C.EMAIL2)
                                                         WHEN C.EMAIL1 is not null THEN
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.EMAIL1)
                                                         WHEN C.EMAIL2 is not null THEN
                                                           XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.EMAIL2)
                                                    end case,
                                                    (SELECT XMLElement("campoAdicional", XMLAttributes('tipoComprobante' AS "nombre"),GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP(Z.DESCRIPCION))
                                                       FROM NAF47_TNET.SRI_TIPOS_COMPROBANTES Z
                                                      WHERE Z.CODIGO = E.CODIGO_TIPO_COMPROBANTE),
                                                    CASE WHEN D.COD_AGENTE_RET is not null AND A.FECHA>=D.FECHA_COD_AGEN_RET THEN  
                                                     XMLElement("campoAdicional", XMLAttributes('Agente de Retencion' AS "nombre"),'    No. Resolucion: '||D.COD_AGENTE_RET)
                                                    END CASE  
                                                   )
                        ), VERSION '1.0" encoding="UTF-8') result_xml
        FROM NAF47_TNET.ARCPMD A,
             NAF47_TNET.ARCGMC B,
             NAF47_TNET.ARCPMP C,
             NAF47_TNET.ARCGMC D,
             NAF47_TNET.ARCPTD E,
             NAF47_TNET.ARCPCT F
       WHERE A.NO_CIA = B.NO_CIA
         AND A.NO_PROVE = C.NO_PROVE
         AND A.NO_CIA = C.NO_CIA
         AND A.NO_CIA = D.NO_CIA
         AND A.NO_CIA = E.NO_CIA
         AND A.TIPO_DOC = E.TIPO_DOC
         AND A.NO_DOCU = Pv_NoDocu
         AND A.NO_CIA = Pv_NoCia
         AND A.NO_CIA = F.NO_CIA
         AND F.TIPO_GENERACION = 'ED';
    --
    Lr_Documento C_DOCUMENTOS%ROWTYPE := NULL;
    --
  BEGIN
    --
    IF C_DOCUMENTOS%ISOPEN THEN
      CLOSE C_DOCUMENTOS;
    END IF;
    OPEN C_DOCUMENTOS;
    FETCH C_DOCUMENTOS INTO Lr_Documento;
    IF C_DOCUMENTOS%NOTFOUND THEN
      Lr_Documento := NULL;
    END IF;
    CLOSE C_DOCUMENTOS;
    --
    UPDATE NAF47_TNET.ARCPMD
    SET ARCHIVO_XML_TMP = Lr_Documento.Result_Xml.getClobVal()
    WHERE NO_DOCU = Pv_noDocu
    AND NO_CIA = Pv_NoCia;
    
  END;

  FUNCTION F_LEER_ARCHIVO_CLOB(Pv_NoDocu IN VARCHAR2,
                               Pv_NoCia  IN VARCHAR2,
                               Pn_Indice IN NUMBER) RETURN VARCHAR2 IS 
    Lv_Hilera VARCHAR2(2000);
  BEGIN
    --
    SELECT SUBSTR(ARCHIVO_XML_TMP, 1 + Pn_Indice * 1000, 1000)
    INTO Lv_Hilera
    FROM NAF47_TNET.ARCPMD
    WHERE NO_DOCU = Pv_NoDocu
    AND NO_CIA = Pv_NoCia;
    --
    RETURN(Lv_Hilera);
  END;


End Arcpk_webservice;
/
