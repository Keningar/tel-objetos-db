CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_ARCHIVO_IMPRESION
AS
  --Procedimiento para obtener la informacion a visualizar en el reporte
  PROCEDURE LISTADO_PROCESADO(
      Pv_PrefijoEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pt_Fe_Inicio        IN VARCHAR2,
      Pt_Fe_Fin           IN VARCHAR2,
      Pv_Numeracion       IN VARCHAR2,
      Pv_CodTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pn_NumeracionUno    IN DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
      Pn_NumeracionDos    IN DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
      Cn_Puntos_Facturados OUT SYS_REFCURSOR);
      
  --Funcion para obterner la direcion de envio del punto
  FUNCTION F_DIRECCION_NUEVA(
      Fn_IdPunto IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    RETURN VARCHAR2;
    
  --Funcion para obtener la informacion de los telefonos de contacto
  FUNCTION F_INFORMACION_TELEFONOS(
      Fn_IdPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    RETURN VARCHAR2;
    
  --Funcion para obtener la informacion de los correos de contacto
  FUNCTION F_INFORMACION_CORREO(
      Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;
    
  --Funcion para obtener los servicios asociados al pto cliente
  FUNCTION F_INFORMACION_SERVICIOS(
      Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;
END FNCK_ARCHIVO_IMPRESION;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_ARCHIVO_IMPRESION
AS
PROCEDURE LISTADO_PROCESADO(
    Pv_PrefijoEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pt_Fe_Inicio        IN VARCHAR2,
    Pt_Fe_Fin           IN VARCHAR2,
    Pv_Numeracion       IN VARCHAR2,
    Pv_CodTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pn_NumeracionUno    IN DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
    Pn_NumeracionDos    IN DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
    Cn_Puntos_Facturados OUT SYS_REFCURSOR)
AS
  -- Listado de Ptos que se facturan en el mes
  Lv_String VARCHAR2(10000):='';
BEGIN
  Lv_String:=
  'select  
  icc.*, 
  ip.login, 
  substr(idfc.numero_factura_sri,0,3) as establecimiento_sri, 
  substr(idfc.numero_factura_sri,5,3) as oficina_sri, 
  substr(idfc.numero_factura_sri,9) as numero_sri, 
  idfc.estado_impresion_fact, 
  idfc.subtotal-nvl(idfc.subtotal_descuento,0) as subtotal, 
  idfc.subtotal_cero_impuesto-nvl(idfc.subtotal_descuento,0) as subtotal_cero_impuesto, 
  idfc.subtotal_con_impuesto, 
  idfc.subtotal_descuento, 
  idfc.valor_total, 
  idfc.fe_emision, 
  db_financiero.FNCK_ARCHIVO_IMPRESION.F_DIRECCION_NUEVA(ip.id_punto) as direccion_envio, 
  db_financiero.FNCK_ARCHIVO_IMPRESION.F_INFORMACION_TELEFONOS(icc.id_persona) as telefonos,  
  db_financiero.FNCK_ARCHIVO_IMPRESION.F_INFORMACION_CORREO(ip.id_punto) as correo, 
  db_financiero.FNCK_ARCHIVO_IMPRESION.F_INFORMACION_SERVICIOS(ip.id_punto) as servicios,
  DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC(''CICLO_FACTURACION'',ip.PERSONA_EMPRESA_ROL_ID) 
  AS CICLO_FACTURACION 
  from db_financiero.info_documento_financiero_cab idfc 
  join db_comercial.info_oficina_grupo iog on iog.id_oficina=idfc.oficina_id 
  join db_comercial.info_empresa_grupo ieg on ieg.cod_empresa=iog.empresa_id 
  join db_financiero.informacion_cliente_courier icc on icc.id_punto=idfc.punto_id 
  join db_financiero.admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id 
  join db_comercial.info_punto ip on ip.id_punto=idfc.punto_id 
  where ieg.prefijo='||q'[']'||Pv_PrefijoEmpresa||q'[']'|| 
  ' and idfc.fe_emision >= to_date('||q'[']'||Pt_Fe_Inicio||q'[']'||','||q'['YYYY-MM-DD HH24:MI:SS')]'|| 
  ' and idfc.fe_emision <= to_date('||q'[']'||Pt_Fe_Fin||q'[']'||','||q'['YYYY-MM-DD HH24:MI:SS') ]'|| 
  ' and idfc.numero_factura_sri like '||q'['%]'||Pv_Numeracion||q'[%']'|| 
  ' and idfc.numero_factura_sri is not null    
  and idfc.login_md is null ';
  --Se verifica si el Codigo del Tipo de documento es nulo
  IF (Pv_CodTipoDocumento IS NULL) THEN
    Lv_String             :=Lv_String||' and atdf.codigo_tipo_documento in ('||q'['FAC']'||','||q'['FACP')]';
  ELSE
    Lv_String:=Lv_String||' and atdf.codigo_tipo_documento in ('||q'[']'||Pv_CodTipoDocumento||q'[')]';
  END IF;
  --Se verifica la numeracion enviada a consultar
  IF (Pn_NumeracionUno  <> '-' AND Pn_NumeracionDos <> '-') THEN
    IF(Pn_NumeracionUno IS NOT NULL AND Pn_NumeracionDos IS NOT NULL)THEN
      Lv_String         :=Lv_String||' and (to_number(substr(idfc.NUMERO_FACTURA_SRI,9))) between '||Pn_NumeracionUno||' and '||Pn_NumeracionDos;
    END IF;
  END IF;
  --dbms_output.put_line('String:'||Lv_String);
  --Se retorna la informacion consultada
  OPEN Cn_Puntos_Facturados FOR Lv_String;
END LISTADO_PROCESADO;

--Funcion para obtener la direccion del envio del punto consultado
FUNCTION F_DIRECCION_NUEVA(
    Fn_IdPunto IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN VARCHAR2
IS
  Fv_DireccionEnvio DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL.DIRECCION_ENVIO%TYPE;
BEGIN
  SELECT REGEXP_REPLACE(ipda.direccion_envio,'[^[:alnum:],[:punct:]'' '']', NULL) AS direccion_envio
  INTO Fv_DireccionEnvio
  FROM db_comercial.info_punto_dato_adicional ipda
  WHERE ipda.punto_id=Fn_IdPunto;
  RETURN(Fv_DireccionEnvio);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RETURN '';
END F_DIRECCION_NUEVA;

--Funcion para obtener los telefonos del punto consultado
FUNCTION F_INFORMACION_TELEFONOS(
    Fn_IdPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
  RETURN VARCHAR2
IS
  Fv_Telefonos VARCHAR2(32000);
BEGIN
  SELECT LISTAGG(afc.descripcion_forma_contacto
    ||':'
    ||ipfc.valor, '|') WITHIN GROUP (
  ORDER BY afc.descripcion_forma_contacto DESC) "Telefonos"
  INTO Fv_Telefonos
  FROM db_comercial.info_persona_forma_contacto ipfc
  JOIN db_comercial.admi_forma_contacto afc
  ON afc.id_forma_contacto            =ipfc.forma_contacto_id
  WHERE ipfc.estado                   ='Activo'
  AND afc.descripcion_forma_contacto IN ('Telefono Movil','Telefono Fijo')
  AND ipfc.persona_id                 =Fn_IdPersona;
  RETURN(Fv_Telefonos);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RETURN '';
END F_INFORMACION_TELEFONOS;

--Funcion para obtener los correos del punto consultado
FUNCTION F_INFORMACION_CORREO(
    Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  Fv_Correos VARCHAR2(32000);
BEGIN
  SELECT LISTAGG(ipfc.valor, '|') WITHIN GROUP (
  ORDER BY afc.descripcion_forma_contacto DESC) "Correos"
  INTO Fv_Correos
  FROM db_comercial.info_punto_forma_contacto ipfc
  JOIN db_comercial.admi_forma_contacto afc
  ON afc.id_forma_contacto          =ipfc.forma_contacto_id
  WHERE ipfc.estado                 ='Activo'
  AND afc.descripcion_forma_contacto='Correo Electronico'
  AND ipfc.punto_id                 =Fn_IdPunto;
  RETURN(Fv_Correos);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RETURN '';
END F_INFORMACION_CORREO;

--Funcion para obtener los servicios asociados al pto cliente
FUNCTION F_INFORMACION_SERVICIOS(
    Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  Fv_Servicios VARCHAR2(32000);
BEGIN
  SELECT LISTAGG(temp.DESCRIPCION_PLAN
        ||' | FeActivacion: '
        ||temp.FE_CREACION, '|') WITHIN GROUP (
      ORDER BY temp.DESCRIPCION_PLAN DESC) "Servicios"
      INTO Fv_Servicios
    from
    (SELECT ipc.DESCRIPCION_PLAN,
      (SELECT MAX(ish.FE_CREACION)
      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ish
      WHERE ish.SERVICIO_ID                        =iser.ID_SERVICIO
      AND (upper(dbms_lob.substr(ish.OBSERVACION)))='SE CONFIRMO EL SERVICIO'
      ) AS FE_CREACION
    FROM db_comercial.info_servicio iser,
      db_comercial.info_plan_cab ipc,
      db_comercial.info_plan_det ipd,
      db_comercial.admi_producto ap
    WHERE iser.punto_id         =Fn_IdPunto
    AND iser.ESTADO             ='Activo'
    AND iser.cantidad           >0
    AND iser.ES_VENTA           ='S'
    AND iser.precio_venta       >0
    AND iser.frecuencia_producto=1
    AND ipc.id_plan             =iser.plan_id
    AND ipd.plan_id             =ipc.id_plan
    AND ap.id_producto          =ipd.producto_id
    AND ap.DESCRIPCION_PRODUCTO ='INTERNET DEDICADO') temp;
  RETURN(Fv_Servicios);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RETURN '';
END F_INFORMACION_SERVICIOS;
END FNCK_ARCHIVO_IMPRESION;
/