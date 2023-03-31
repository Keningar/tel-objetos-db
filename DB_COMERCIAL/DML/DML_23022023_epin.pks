DECLARE
  PV_EMPRESA VARCHAR2(2);
  PV_EMPRESA_NUEVA VARCHAR2(2);
  
  Lv_CodigoEmpresa      VARCHAR2(2);
  Lv_CodigoEmpresaNueva VARCHAR2(2);
  Ln_Id_Producto        INTEGER;
  Ln_Id_Plan            INTEGER;
  
  CURSOR C_GET_EMPRESA (Cv_Prejifo VARCHAR2) IS
  SELECT COD_EMPRESA 
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = Cv_Prejifo
    AND ESTADO = 'Activo';
 
  CURSOR C_GET_PRODUCTOS (Cv_Empresa VARCHAR2) IS
  SELECT ID_PRODUCTO, EMPRESA_COD, CODIGO_PRODUCTO, DESCRIPCION_PRODUCTO, FUNCION_COSTO, INSTALACION, ESTADO, FE_CREACION, USR_CREACION, IP_CREACION, CTA_CONTABLE_PROD, CTA_CONTABLE_PROD_NC, ES_PREFERENCIA, ES_ENLACE, REQUIERE_PLANIFICACION, REQUIERE_INFO_TECNICA, NOMBRE_TECNICO, CTA_CONTABLE_DESC, TIPO, ES_CONCENTRADOR, FUNCION_PRECIO, SOPORTE_MASIVO, ESTADO_INICIAL, GRUPO, COMISION_VENTA, COMISION_MANTENIMIENTO, USR_GERENTE, CLASIFICACION, REQUIERE_COMISIONAR, SUBGRUPO, LINEA_NEGOCIO, FRECUENCIA, TERMINO_CONDICION 
    FROM DB_COMERCIAL.ADMI_PRODUCTO
    WHERE EMPRESA_COD = Cv_Empresa
    and nombre_tecnico = 'IP' and estado = 'Activo';

      
  
BEGIN
  PV_EMPRESA       := 'MD';
  PV_EMPRESA_NUEVA := 'EN';
  
  OPEN C_GET_EMPRESA(PV_EMPRESA);
  FETCH C_GET_EMPRESA INTO Lv_CodigoEmpresa;
  CLOSE C_GET_EMPRESA;
  
  OPEN C_GET_EMPRESA(PV_EMPRESA_NUEVA);
  FETCH C_GET_EMPRESA INTO Lv_CodigoEmpresaNueva;
  CLOSE C_GET_EMPRESA;
    
  --Se generan los productos de MD para una nueva empresa
  
  --admi_producto
  FOR I IN C_GET_PRODUCTOS(Lv_CodigoEmpresa) LOOP
    INSERT INTO DB_COMERCIAL.ADMI_PRODUCTO(ID_PRODUCTO, EMPRESA_COD, CODIGO_PRODUCTO, DESCRIPCION_PRODUCTO, FUNCION_COSTO, INSTALACION, ESTADO, FE_CREACION, USR_CREACION, IP_CREACION, CTA_CONTABLE_PROD, CTA_CONTABLE_PROD_NC, ES_PREFERENCIA, ES_ENLACE, REQUIERE_PLANIFICACION, REQUIERE_INFO_TECNICA, NOMBRE_TECNICO, CTA_CONTABLE_DESC, TIPO, ES_CONCENTRADOR, FUNCION_PRECIO, SOPORTE_MASIVO, ESTADO_INICIAL, GRUPO, COMISION_VENTA, COMISION_MANTENIMIENTO, USR_GERENTE, CLASIFICACION, REQUIERE_COMISIONAR, SUBGRUPO, LINEA_NEGOCIO, FRECUENCIA, TERMINO_CONDICION)
    VALUES(DB_COMERCIAL.SEQ_ADMI_PRODUCTO.NEXTVAL, Lv_CodigoEmpresaNueva, I.CODIGO_PRODUCTO, I.DESCRIPCION_PRODUCTO, I.FUNCION_COSTO, I.INSTALACION, I.ESTADO, sysdate, 'epin', '127.0.0.1', I.CTA_CONTABLE_PROD, I.CTA_CONTABLE_PROD_NC, I.ES_PREFERENCIA, I.ES_ENLACE, I.REQUIERE_PLANIFICACION, I.REQUIERE_INFO_TECNICA, I.NOMBRE_TECNICO, I.CTA_CONTABLE_DESC, I.TIPO, I.ES_CONCENTRADOR, I.FUNCION_PRECIO, I.SOPORTE_MASIVO, I.ESTADO_INICIAL, I.GRUPO, I.COMISION_VENTA, I.COMISION_MANTENIMIENTO, I.USR_GERENTE, I.CLASIFICACION, I.REQUIERE_COMISIONAR, I.SUBGRUPO, I.LINEA_NEGOCIO, I.FRECUENCIA, I.TERMINO_CONDICION)
    RETURNING ID_PRODUCTO INTO Ln_Id_Producto;
    
    --inserto los impuestos por productos
    INSERT INTO DB_COMERCIAL.info_producto_impuesto
    SELECT DB_COMERCIAL.SEQ_info_producto_impuesto.NEXTVAL, Ln_Id_Producto, IMP.IMPUESTO_ID, IMP.PORCENTAJE_IMPUESTO, SYSDATE, 'epin', sysdate, 'epin', IMP.ESTADO 
    FROM DB_COMERCIAL.info_producto_impuesto IMP WHERE IMP.PRODUCTO_ID = I.ID_PRODUCTO;
    
    --inserto las caracteristicas de los productos
    insert into DB_COMERCIAL.admi_producto_caracteristica 
    select db_comercial.seq_admi_producto_carac.nextval, Ln_Id_Producto, caracteristica_id, sysdate, null, 'epin', null, 'Activo', visible_comercial 
    from DB_COMERCIAL.admi_producto_caracteristica
    where producto_id = I.ID_PRODUCTO;

  END LOOP;
  
 
  COMMIT;
  
--rollback; 
END;
/