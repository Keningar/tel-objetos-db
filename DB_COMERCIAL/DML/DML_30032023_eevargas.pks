-------------------------------------------------------------------------------------------------------------------
-- Se actualiza la columna CODIGO en la tabla DB_COMERCIAL.ADMI_FORMA_CONTACTO de los registros con codigos nulos--
-- Tiempo estimado: tarea completa en 0.029 segundos
-------------------------------------------------------------------------------------------------------------------

DECLARE
CODIGO VARCHAR2(15);
  CURSOR C_DATOS_CONTACTOS IS 
  SELECT
      AFC.ID_FORMA_CONTACTO,    
      AFC.DESCRIPCION_FORMA_CONTACTO,
      AFC.fe_creacion,
      AFC.usr_creacion,
      AFC.estado,
      AFC.fe_ult_mod,
      AFC.usr_ult_mod,
      UPPER(SUBSTR(AFC.DESCRIPCION_FORMA_CONTACTO, 1, 3) || TO_CHAR(AFC.ID_FORMA_CONTACTO)) AS CODIGO,
      AFC.mostrar_app
  FROM
      DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
  WHERE
      AFC.CODIGO IS NULL;

TYPE v_c_infoMasivo IS TABLE OF db_comercial.ADMI_FORMA_CONTACTO%ROWTYPE INDEX BY PLS_INTEGER;   
        
  t_c_infoMasivo      v_c_infoMasivo;   
  i PLS_INTEGER            := 0;
BEGIN
  OPEN C_DATOS_CONTACTOS;
    LOOP
        FETCH C_DATOS_CONTACTOS bulk collect INTO t_c_infoMasivo;
    EXIT
    WHEN t_c_infoMasivo.count = 0 ;
        i := t_c_infoMasivo.FIRST;
         WHILE (i IS NOT NULL) 
        LOOP        
        UPDATE  DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
        SET     AFC.CODIGO = t_c_infoMasivo(i).CODIGO,
                AFC.USR_ULT_MOD = 'eevargas'
        WHERE   AFC.ID_FORMA_CONTACTO=t_c_infoMasivo(i).ID_FORMA_CONTACTO;
        i := t_c_infoMasivo.NEXT(i);  
        END LOOP;
    END LOOP;
COMMIT;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error creando codigos para formas de contactos con codigos=NULL.'|| SQLCODE || SQLERRM);  
END;
