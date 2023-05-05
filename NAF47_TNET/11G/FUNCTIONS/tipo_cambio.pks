create or replace FUNCTION            tipo_cambio(
  clase     in varchar2,
  fechae    in date,
  fechas    in out date,
  p_t_camb  in varchar2
) RETURN NUMBER
IS
  -- --
  -- Funcion para obtener el tipo de cambio, si no se encuentra
  -- retorna 0
  TIPO_C   arcgtc.tipo_cambio%TYPE := 0;
  --
  CURSOR c_cambio IS
    SELECT decode(p_t_camb, 'C', TIPO_CAMBIO, Tipo_Cambio_Venta), FECHA
    FROM ARCGTC
    WHERE CLASE_CAMBIO = CLASE
      AND FECHA = (SELECT MAX(FECHA)
       FROM ARCGTC
       WHERE CLASE = CLASE_CAMBIO
         AND FECHA <= fechae);
  CURSOR c_cambio_mas_antiguo IS
    SELECT decode(p_t_camb, 'C', TIPO_CAMBIO, Tipo_Cambio_Venta),FECHA
    FROM ARCGTC
    WHERE CLASE_CAMBIO = CLASE
    ORDER BY FECHA;
   --
BEGIN
  OPEN c_cambio;
  FETCH c_cambio INTO TIPO_C, FECHAS;
  IF c_cambio%NOTFOUND THEN
     CLOSE c_cambio;
     --
     OPEN c_cambio_mas_antiguo;
     FETCH c_cambio_mas_antiguo INTO TIPO_C, FECHAS;
     CLOSE c_cambio_mas_antiguo;
  ELSE
     CLOSE c_cambio;
  END IF;
  RETURN( NVL(TIPO_C,0) );
END tipo_cambio;