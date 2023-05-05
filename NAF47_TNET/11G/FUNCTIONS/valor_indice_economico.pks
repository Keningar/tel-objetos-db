create or replace FUNCTION            valor_indice_economico(
  pcodigo   IN VARCHAR2,
  pfecha_e  IN DATE,
  pfecha_s  IN OUT DATE
) RETURN NUMBER
 IS
  -- --
  -- Funcion para obtener el factor o valor relacionado a un indice economico
  -- Si no existe el indice economico retorna null
  vvalor     arcgied.valor%type;
  vfecha_s   date;
  --
  CURSOR c_datos IS
    SELECT valor , fecha
    FROM  arcgied
    WHERE codigo  = pcodigo
      AND fecha   = (SELECT MAX(fecha)
                     FROM arcgied
                     WHERE codigo =  pcodigo
                       AND fecha  <= pfecha_e);
BEGIN
  OPEN c_datos;
  FETCH c_datos INTO vvalor, vfecha_s;
  CLOSE c_datos;
  pfecha_s := vfecha_s;
  RETURN( vvalor );
END;