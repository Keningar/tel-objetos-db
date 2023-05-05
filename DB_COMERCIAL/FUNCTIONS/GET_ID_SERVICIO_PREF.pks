create or replace FUNCTION               GET_ID_SERVICIO_PREF(Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetDescPlan( Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT ISR.ID_SERVICIO
    FROM 
      DB_COMERCIAL.INFO_SERVICIO ISR,
      DB_COMERCIAL.INFO_PLAN_CAB IPC,
      DB_COMERCIAL.INFO_PLAN_DET IPD,
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE ISR.PLAN_ID     = IPC.ID_PLAN
    AND IPC.ID_PLAN       = IPD.PLAN_ID
    AND IPD.PRODUCTO_ID   = AP.ID_PRODUCTO
    AND AP.NOMBRE_TECNICO = 'INTERNET'
    AND ISR.ESTADO        in ('Activo','In-Corte')        
    AND ISR.PUNTO_ID      = Cn_IdPunto;
  --
  CURSOR C_GetDescProducto( Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT ISR.ID_SERVICIO
    FROM 
      DB_COMERCIAL.INFO_SERVICIO ISR,
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE ISR.PRODUCTO_ID = AP.ID_PRODUCTO
    AND AP.NOMBRE_TECNICO = 'INTERNET'
    AND AP.ESTADO         = 'Activo'        
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
  OPEN C_GetDescPlan(Pn_IdPunto);
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
    OPEN C_GetDescProducto(Pn_IdPunto);
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
  
  
END GET_ID_SERVICIO_PREF;