CREATE OR REPLACE TRIGGER NAF47_TNET.TR_EXCEDENTE_INSTALACIONES
  after insert
  on NAF47_TNET.ARINDA 
  for each row
  /*
  *Documentación para el trigger TR_EXCEDENTE_INSTALACIONES
  * Trigger que se ejecuta despues de realizar inserción de nuevo registro en catalogo de artículos
  * para asignar datos en la tabla DB_SOPORTE.ADMI_TAREA_MATERIAL importante para calculo de valores a cobrar a clientes 
  * por concepto de instalaciones o soporte
  *
  * @author Luis Lindao <llinda@telconet.ec>
  * @version 1.0 07-06-2020
  *
  */
declare
  -- local variables here
  Lc_ParametroGenMovil CONSTANT VARCHAR2(30) := 'PARAMETROS_GENERALES_MOVIL';
  Lc_EstadoActivo      CONSTANT VARCHAR2(6) := 'Activo';
  --
  CURSOR C_PARAMETRO_EXCEDENTE_INST (Cv_NombreParametro VARCHAR2,
                                     Cv_TipoArticulo    VARCHAR2,
                                     Cv_NoCia           VARCHAR2) IS
    SELECT APD.VALOR3 USADO_EN,
           APD.VALOR4 TAREA_ID,
           APD.VALOR5 COSTO,
           APD.VALOR6 PRECIO,
           APD.VALOR2 CANTIDAD
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
         DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.VALOR1 = Cv_NombreParametro
    AND APD.VALOR2 = NVL(Cv_TipoArticulo,APD.VALOR2)
    AND APD.ESTADO = Lc_EstadoActivo
    AND NVL(APD.EMPRESA_COD,'@') = NVL(Cv_NoCia, NVL(APD.EMPRESA_COD,'@'))
    AND APC.NOMBRE_PARAMETRO = Lc_ParametroGenMovil
    AND APC.ESTADO = Lc_EstadoActivo
    AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
    ORDER BY APD.ID_PARAMETRO_DET;
  --
  Lr_Datos    C_PARAMETRO_EXCEDENTE_INST%ROWTYPE;
  Ln_Cantidad DB_SOPORTE.ADMI_TAREA_MATERIAL.CANTIDAD_MATERIAL%TYPE := 0;
  --
begin
  --
  -- se recupera parametro cantidad instalación
  IF C_PARAMETRO_EXCEDENTE_INST%ISOPEN THEN 
    CLOSE C_PARAMETRO_EXCEDENTE_INST;
  END IF;
  OPEN C_PARAMETRO_EXCEDENTE_INST('CANTIDAD_BOBINA_INSTALACION_MD',
                                  NULL, 
                                  NULL);
  FETCH C_PARAMETRO_EXCEDENTE_INST INTO Lr_Datos;
  IF C_PARAMETRO_EXCEDENTE_INST%NOTFOUND THEN
    Lr_Datos.CANTIDAD := 0;
  END IF;
  CLOSE C_PARAMETRO_EXCEDENTE_INST;
  --
  IF Lr_Datos.CANTIDAD = 0 THEN
    RAISE_APPLICATION_ERROR(-20010,'No se ha definido parametro CANTIDAD_BOBINA_INSTALACION_MD, favor revisar!!!');
  END IF;
  --
  Ln_Cantidad := Lr_Datos.CANTIDAD;
  --
  IF C_PARAMETRO_EXCEDENTE_INST%ISOPEN THEN 
    CLOSE C_PARAMETRO_EXCEDENTE_INST;
  END IF;
  OPEN C_PARAMETRO_EXCEDENTE_INST('EXCEDENTE_ARTICULOS',
                                  :NEW.TIPO_ARTICULO, 
                                  :NEW.NO_CIA);
  LOOP
    FETCH C_PARAMETRO_EXCEDENTE_INST INTO Lr_Datos;
    EXIT WHEN C_PARAMETRO_EXCEDENTE_INST%NOTFOUND;
    --
    INSERT INTO DB_SOPORTE.ADMI_TAREA_MATERIAL ( 
      ID_TAREA_MATERIAL, 
      TAREA_ID, 
      MATERIAL_COD, 
      COSTO_MATERIAL, 
      PRECIO_VENTA_MATERIAL, 
      CANTIDAD_MATERIAL, 
      UNIDAD_MEDIDA_MATERIAL, 
      ESTADO, 
      USR_CREACION, 
      FE_CREACION, 
      EMPRESA_COD, 
      FACTURABLE, 
      UTILIZADO_EN)
    VALUES (
      DB_SOPORTE.SEQ_ADMI_TAREA_MATERIAL.NEXTVAL, 
      Lr_Datos.Tarea_Id, 
      :NEW.NO_ARTI, 
      Lr_Datos.Costo, 
      Lr_Datos.Precio, 
      Ln_Cantidad, 
      :NEW.UNIDAD, 
      'Activo', 
      user, 
      sysdate, 
      :NEW.NO_CIA, 
      '1', 
      Lr_Datos.Usado_En);
    --
  END LOOP;
  --
  CLOSE C_PARAMETRO_EXCEDENTE_INST;

end TR_ARTICULOS_TAREA_INSTALACION;

/
