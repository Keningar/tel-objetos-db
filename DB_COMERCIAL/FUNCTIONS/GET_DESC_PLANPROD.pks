create or replace FUNCTION               GET_DESC_PLANPROD(
    Pn_IdEmpresa  IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_IdPunto    IN INFO_PUNTO.ID_PUNTO%TYPE,
    Pv_NomTecnico IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetDescPlan( Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                        Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, 
                        Cv_NomTecnico ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  IS
    SELECT IPC.NOMBRE_PLAN
    FROM 
      DB_COMERCIAL.INFO_SERVICIO ISR,
      DB_COMERCIAL.INFO_PLAN_CAB IPC,
      DB_COMERCIAL.INFO_PLAN_DET IPD,
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE ISR.PLAN_ID     = IPC.ID_PLAN
    AND IPC.ID_PLAN       = IPD.PLAN_ID
    AND IPD.PRODUCTO_ID   = AP.ID_PRODUCTO
    AND AP.NOMBRE_TECNICO = Cv_NomTecnico
    AND ISR.ESTADO        in ('Activo','In-Corte')  
    AND IPC.EMPRESA_COD   = Cn_IdEmpresa
    AND ISR.PUNTO_ID      = Cn_IdPunto;
  --
  CURSOR C_GetDescProducto( Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                            Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, 
                            Cv_NomTecnico ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  IS
    SELECT AP.DESCRIPCION_PRODUCTO
    FROM 
      DB_COMERCIAL.INFO_SERVICIO ISR,
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE ISR.PRODUCTO_ID = AP.ID_PRODUCTO
    AND AP.NOMBRE_TECNICO = Cv_NomTecnico    
    AND ISR.ESTADO        in ('Activo','In-Corte')
    AND AP.EMPRESA_COD    = Cn_IdEmpresa
    AND ISR.PUNTO_ID      = Cn_IdPunto;
  --
  Lv_Descripcion VARCHAR2(1000) := NULL;
BEGIN
  --
  IF C_GetDescPlan%ISOPEN THEN
    --
    CLOSE C_GetDescPlan;
    --
  END IF;
  --
  OPEN C_GetDescPlan(Pn_IdEmpresa, Pn_IdPunto, Pv_NomTecnico);
  --
  FETCH C_GetDescPlan INTO Lv_Descripcion;
  --
  IF C_GetDescPlan%NOTFOUND THEN
    --
    Lv_Descripcion := NULL;
    --
    IF C_GetDescProducto%ISOPEN THEN
      --
      CLOSE C_GetDescProducto;
      --
    END IF;
    --
    OPEN C_GetDescProducto(Pn_IdEmpresa, Pn_IdPunto, Pv_NomTecnico);
    --
    FETCH C_GetDescProducto INTO Lv_Descripcion;
    --
    CLOSE C_GetDescProducto;
    --
  END IF;
  --
  CLOSE C_GetDescPlan;
  --
  RETURN Lv_Descripcion;
  --
  
  
END GET_DESC_PLANPROD;