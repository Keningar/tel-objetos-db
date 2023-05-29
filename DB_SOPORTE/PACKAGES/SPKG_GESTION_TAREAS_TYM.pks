CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_GESTION_TAREAS_TYM 
AS 
/**
* Documentación para la funcion F_GET_TAREA_ID_X_NOMBRE
* La función F_GET_TAREA_ID_X_NOMBRE obtiene el id de la tarea buscada por nombre
*
* @param VARCHAR2 Fv_nombreTarea Recibe el nombre de la tarea
* @return NUMBER  Retorna el id de la tarea
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 05-08-2015
*/
FUNCTION F_GET_TAREA_ID_X_NOMBRE(Fv_nombreTarea VARCHAR2) return NUMBER;


/**
* Documentación para la funcion F_GET_CAT_TAREA_ID_X_VALOR1
* La función F_GET_CAT_TAREA_ID_X_VALOR1 obtiene el id de la categoría de la tarea buscada por su nombre
*
* @param VARCHAR2 Fv_nombreCategoriaTarea Recibe el nombre de la categoría de la tarea
* @return NUMBER  Retorna el id de la categoría de la tarea
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 05-08-2015
*/
FUNCTION F_GET_CAT_TAREA_ID_X_VALOR1(Fv_nombreCategoriaTarea VARCHAR2) return NUMBER;


TYPE nombresArray IS VARRAY(300) OF VARCHAR2(100);

/**
* P_ACTUALIZAR_CATEGORIAS_TAREAS
*
* PROCEDIMIENTO QUE ACTUALIZA LAS CATEGORÍAS DE LAS TAREAS DE TALLER Y MOVILIZACIÓN
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 05/08/2016
*
*/
PROCEDURE P_ACTUALIZAR_CATEGORIAS_TAREAS(Pv_tareas nombresArray,Pv_categorias nombresArray,Lv_MsjError OUT VARCHAR2);

 /**
  * COMF_GET_TAREAS_POR_PERSONA
  *
  * PROCEDIMIENTO QUE OBTIENE LAS TAREAS POR PERSONA
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 13/04/2018
  * @param NUMBER Pn_persona
  *
  * @author Robinson Salgado     <rsalgado@telconet.ec>
  * @version 1.1 12/07/2018
  * Se  reemplaza el signo | en el campo de dirección en el cursor C_getInfoPorPunto al momento de obtener la dirección del punto
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.2 18/07/2018
  * Se filtra el progreso de la tarea por idComunicacion y iddetalle
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.3 23/07/2018
  * Se implementa nuevo proceso para cuadrillas HAL, las cuales visualizarán sus tareas según planifique HAL
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.4 21/08/2018
  * Se optimizó la consulta de las tareas en el móvil
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.5 22/08/2018
  * Se ordena las tareas de formas ascendente en el móvil
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.6 1/10/2018
  * Se agregan las variables de tipo medio y factibilidad para el control de fibra.
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.7 19/10/2018
  * Se agrega la variable si es enlace, la cual sirve para reconocer las tareas de instalación que tienen un producto asociado a instalar
  *
  * @author Nestor Naula     <nnaulal@telconet.ec>
  * @version 1.8 10/01/2019
  * Se valida que el prefijo de la tarea sea igual al del caso.
  *
  * @author Jean Nazareno    <jnazareno@telconet.ec>
  * @version 1.9 02/04/2019
  * Se agrega campo "DETALLE_SOLICITUD_ID" para que retorne
  * y usarlo en el Movil.
  *
  * @author Wilmer Vera <wvera@telconet.ec>
  * @version 1.10 07/08/2019
  * Se elimina lógica para obtimizar cursor del paquete
  *
  * @author Jean Nazareno    <jnazareno@telconet.ec>
  * @version 2.0 12/07/2019
  * Se agregan campos Ln_idPlan, Lv_nombrePlan, Ln_idProducto, Lv_nombreProducto para que retorne
  * y usarlo en el Movil.
  *  
  * @author Jean Pierre Nazareno  <jnazareno@telconet.ec>
  * @version 2.1 05/09/2019
  * Se agrega nombre "Replanificada" en el filtro de tareas asignadas al tecnico, 
  * para que no se les muestren.
  *
  * @author Wilmer Vera <wvera@telconet.ec>
  * @version 2.2 07/07/2020
  * Se agrega última milla para tareas de soporte.
  *
  * @author Jean Pierre Nazareno  <jnazareno@telconet.ec>
  * @author Ronny Moran <rmoranc@telconet.ec>
  * @version 2.3 28/07/2020
  * Se agrega nuevo campo Ln_ProgRuta para validar el progreso de ruta_fibra en el movil, 
  *
  * @author Jean Pierre Nazareno  <jnazareno@telconet.ec>
  * @version 2.4 21/09/2020
  * Se agrega nombre "Reprogramada" en el filtro de tareas asignadas al tecnico, 
  * para que no se les muestren.
  *
  * @author Carlos Caguana  <ccaguana@telconet.ec>
  * @version 2.5 04/11/2020
  * Se agrega cursor getProductos que me trae el idProducto y el Nombre del Producto
  * relacionado con el idServicio.
  */  

   FUNCTION COMF_GET_TAREAS_POR_PERSONA(Pn_persona IN NUMBER)
      RETURN CLOB;

END SPKG_GESTION_TAREAS_TYM;
/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_GESTION_TAREAS_TYM
AS
FUNCTION F_GET_TAREA_ID_X_NOMBRE(Fv_nombreTarea VARCHAR2)
return NUMBER is  
    	--Cursor para obtener id de la tarea en base al nombre de la tarea
	cursor c_obtenerTareaXNombre(Fv_nombreTarea VARCHAR2) is
	SELECT tarea.ID_TAREA
	FROM DB_SOPORTE.ADMI_TAREA tarea
	where TRIM(tarea.NOMBRE_TAREA)=TRIM(Fv_nombreTarea)
	AND tarea.ESTADO = 'Activo';

	lr_obtenerTareaXNombre c_obtenerTareaXNombre%ROWTYPE;         

	l_id_tarea number := 0;
	begin       
		OPEN c_obtenerTareaXNombre(Fv_nombreTarea);
		FETCH c_obtenerTareaXNombre INTO lr_obtenerTareaXNombre;
		IF(c_obtenerTareaXNombre%found) THEN
		    l_id_tarea := lr_obtenerTareaXNombre.ID_TAREA;   
		END IF;
		CLOSE c_obtenerTareaXNombre;
		return l_id_tarea;
	END;


FUNCTION F_GET_CAT_TAREA_ID_X_VALOR1(Fv_nombreCategoriaTarea VARCHAR2)
	return NUMBER is  
	    	--Cursor para obtener id de la categoría tarea en base al nombre de la categoría de la tarea
		cursor c_obtenerCategoriaTareaXValor1(Fv_nombreCategoriaTarea VARCHAR2) is
		SELECT det.ID_PARAMETRO_DET
		FROM DB_GENERAL.ADMI_PARAMETRO_DET det
		INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB cab ON cab.ID_PARAMETRO = det.PARAMETRO_ID
		WHERE cab.NOMBRE_PARAMETRO='CATEGORIAS TAREAS OT TALLER Y MOVILIZACION'
		AND TRIM(det.VALOR1)=TRIM(Fv_nombreCategoriaTarea);
		lr_obtenerCatTareaXNombre c_obtenerCategoriaTareaXValor1%ROWTYPE;         

		l_id_categoria_tarea number := 0;
		begin       
			OPEN c_obtenerCategoriaTareaXValor1(Fv_nombreCategoriaTarea);
			FETCH c_obtenerCategoriaTareaXValor1 INTO lr_obtenerCatTareaXNombre;
			IF(c_obtenerCategoriaTareaXValor1%found) THEN
			    l_id_categoria_tarea := lr_obtenerCatTareaXNombre.ID_PARAMETRO_DET;   
			END IF;
			CLOSE c_obtenerCategoriaTareaXValor1;
			return l_id_categoria_tarea;
		END;

PROCEDURE P_ACTUALIZAR_CATEGORIAS_TAREAS(Pv_tareas nombresArray,Pv_categorias nombresArray,Lv_MsjError OUT VARCHAR2)
AS
	l_id_mantenimiento_c NUMBER;
	id_tarea_obtenida NUMBER;
	id_categoria_tarea_obtenida NUMBER;
	id_motivo number;
    v_num_registros_commit   NUMBER      :=0;

BEGIN
	FOR i in 1 .. Pv_tareas.COUNT LOOP
		id_tarea_obtenida := F_GET_TAREA_ID_X_NOMBRE(Pv_tareas(i));
		id_categoria_tarea_obtenida := F_GET_CAT_TAREA_ID_X_VALOR1(Pv_categorias(i));
        IF(id_tarea_obtenida<>0 AND id_categoria_tarea_obtenida<>0) 
		THEN 
			UPDATE DB_SOPORTE.ADMI_TAREA
			SET CATEGORIA_TAREA_ID = id_categoria_tarea_obtenida
			WHERE ID_TAREA = id_tarea_obtenida;
            dbms_output.put_line('ACTUALIZADO' || 'id_tarea ' || id_tarea_obtenida ||' id_categoria_tarea'|| id_categoria_tarea_obtenida);
            v_num_registros_commit    := v_num_registros_commit + 1;
            IF (v_num_registros_commit =20) THEN
              COMMIT;
              v_num_registros_commit := 0;
            END IF;
		END IF;
	END LOOP;

	EXCEPTION     
	WHEN OTHERS THEN 
        ROLLBACK; 
        Lv_MsjError := 'ERROR AL ACTUALIZAR LA CATEGORIA';
END P_ACTUALIZAR_CATEGORIAS_TAREAS;



FUNCTION COMF_GET_TAREAS_POR_PERSONA(Pn_persona IN NUMBER)
  RETURN CLOB
  AS

  CURSOR C_getElemento(Cv_id number) is
  SELECT 
  IE.ID_ELEMENTO,
  IE.NOMBRE_ELEMENTO,
  ATE.NOMBRE_TIPO_ELEMENTO,
  AME.NOMBRE_MODELO_ELEMENTO,
  U.LATITUD_UBICACION,
  U.LONGITUD_UBICACION
  FROM INFO_ELEMENTO IE
  JOIN ADMI_MODELO_ELEMENTO AME ON AME.ID_MODELO_ELEMENTO = IE.MODELO_ELEMENTO_ID
  JOIN ADMI_TIPO_ELEMENTO ATE ON ATE.ID_TIPO_ELEMENTO   = AME.TIPO_ELEMENTO_ID
  JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EEU ON EEU.ELEMENTO_ID = IE.ID_ELEMENTO 
  JOIN DB_INFRAESTRUCTURA.INFO_UBICACION U ON U.ID_UBICACION = EEU.UBICACION_ID
  WHERE IE.ID_ELEMENTO = Cv_id
  AND ROWNUM < 2;
  --
  CURSOR C_getMinDetalle(Cn_id NUMBER)
  IS
    SELECT MIN(ID_DETALLE)
    FROM INFO_DETALLE
    WHERE DETALLE_HIPOTESIS_ID = Cn_id
    AND TAREA_ID              IS NULL;
  --
  CURSOR C_getInfoAfectado(Cn_id NUMBER)
  IS
    SELECT AFECTADO_ID,
      TIPO_AFECTADO
    FROM INFO_PARTE_AFECTADA
    WHERE DETALLE_ID = Cn_id;
  --
  CURSOR C_getInfoAfectadoServicio(Cn_id NUMBER)
  IS
SELECT DISTINCT(AFECTADO_ID)
    FROM INFO_PARTE_AFECTADA
    WHERE DETALLE_ID in (
    select ID_DETALLE 
    from DB_SOPORTE.INFO_DETALLE 
    where DETALLE_HIPOTESIS_ID = 
    (select DETALLE_HIPOTESIS_ID 
    from DB_SOPORTE.INFO_DETALLE 
    where ID_DETALLE = Cn_id))
    AND TIPO_AFECTADO = 'Servicio';
  --
  CURSOR C_getInfoCuadrillaHal
  IS
    SELECT (CASE WHEN NVL(AC.ES_HAL,'N') = 'S' THEN 1 ELSE 0 END) AS ISHAL
    FROM DB_COMERCIAL.ADMI_CUADRILLA AC
    INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE ON IPE.CUADRILLA_ID=AC.ID_CUADRILLA
    WHERE NVL(AC.ES_HAL,'N') = 'S' AND IPE.PERSONA_ID = Pn_persona AND IPE.ESTADO='Activo' AND AC.ESTADO!='Eliminado';
  --
  CURSOR C_tareasPendientes_hal
  IS
  SELECT 
    TF.ID_COMUNICACION ID_COMUNICACION,
    TF.ID_DETALLE ID_DETALLE,
    TF.NOMBRE_TAREA NOMBRE_TAREA,
    TF.persona_empresa_rol_id PERSONA_EMPRESA_ROL_ID,
    TF.EMPRESA_COD EMPRESA_COD,
    TF.DETALLE_SOLICITUD_ID DETALLE_SOLICITUD_ID,
    TF.DETALLE_HIPOTESIS_ID DETALLE_HIPOTESIS_ID,
    TF.FE_SOLICITADA FE_SOLICITADA,
    TF.ESTADOTAREA ESTADO,
    TF.ES_SOLUCION ES_SOLUCION,
    TF.ID_CASO ID_CASO,
    TF.NUMERO_CASO,
    TF.NOMBRE_TIPO_CASO NOMBRE_TIPO_CASO,
    TF.NOMBRE_NIVEL_CRITICIDAD NOMBRE_NIVEL_CRITICIDAD,
    TF.DESCRIPCION_NIVEL_CRITICIDAD DESCRIPCION_NIVEL_CRITICIDAD,
    TF.EMPRESA_CASO EMPRESA_CASO,
    ICO.EMPRESA_COD EMPRESA_TAREA,
    CASE WHEN IEG2.PREFIJO IS NOT NULL THEN IEG2.PREFIJO ELSE IEG.PREFIJO END AS EMPRESA_PREFIJO,
    TF.ID_TAREA ID_TAREA,
    TF.PROGRESO_TAREA_ID PROGRESO_TAREA_ID,
    NVL(sum(pp.PORCENTAJE),0)AS PORCENTAJE
    FROM(SELECT 
    MIN(ID_COMUNICACION) ID_COMUNICACION,
    ID_DETALLE ID_DETALLE,
    NOMBRE_TAREA NOMBRE_TAREA,
    persona_empresa_rol_id PERSONA_EMPRESA_ROL_ID,
    EMPRESA_COD EMPRESA_COD,
    DETALLE_SOLICITUD_ID DETALLE_SOLICITUD_ID,
    DETALLE_HIPOTESIS_ID DETALLE_HIPOTESIS_ID,
    FE_SOLICITADA FE_SOLICITADA,
    ESTADO ESTADOTAREA,
    ES_SOLUCION ES_SOLUCION,
    ID_CASO ID_CASO,
    NUMERO_CASO,
    NOMBRE_TIPO_CASO NOMBRE_TIPO_CASO,
    NOMBRE_NIVEL_CRITICIDAD NOMBRE_NIVEL_CRITICIDAD,
    DESCRIPCION_NIVEL_CRITICIDAD DESCRIPCION_NIVEL_CRITICIDAD,
    EMPRESA_CASO EMPRESA_CASO,
    ID_TAREA ID_TAREA,
    PROGRESO_TAREA_ID PROGRESO_TAREA_ID,
    MAX(ID_DETALLE_HISTORIAL) ID_DETALLE_HISTORIAL,
    MAX(ID_DETALLE_ASIGNACION) ID_DETALLE_ASIGNACION
    FROM
    (SELECT 
          C.ID_COMUNICACION,
          i1_.ID_DETALLE,
          T.NOMBRE_TAREA, 
          i0_.persona_empresa_rol_id,
          ER.EMPRESA_COD,
          i1_.DETALLE_SOLICITUD_ID,
          i1_.DETALLE_HIPOTESIS_ID,
          i1_.FE_SOLICITADA,
          i2_.ESTADO,
          i1_.ES_SOLUCION,
          IC.ID_CASO,
          IC.NUMERO_CASO,
          ATC.NOMBRE_TIPO_CASO,
          ANC.NOMBRE_NIVEL_CRITICIDAD,
          ANC.DESCRIPCION_NIVEL_CRITICIDAD,
          IC.EMPRESA_COD AS EMPRESA_CASO,
          C.EMPRESA_COD AS EMPRESA_TAREA,
          IEG.PREFIJO AS EMPRESA_PREFIJO,
          T.ID_TAREA,
          i1_.PROGRESO_TAREA_ID,
          i2_.ID_DETALLE_HISTORIAL,
          i0_.ID_DETALLE_ASIGNACION
        FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION i0_
        JOIN DB_SOPORTE.INFO_DETALLE i1_ ON i1_.ID_DETALLE = i0_.DETALLE_ID
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL i2_ ON i2_.DETALLE_ID = i1_.ID_DETALLE
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per ON per.CUADRILLA_ID = i0_.ASIGNADO_ID
        JOIN DB_SOPORTE.ADMI_TAREA T ON T.ID_TAREA = i1_.TAREA_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER ON ER.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
        JOIN DB_SOPORTE.INFO_COMUNICACION C ON C.DETALLE_ID = i1_.ID_DETALLE
        LEFT JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDH ON IDH.ID_DETALLE_HIPOTESIS = i1_.DETALLE_HIPOTESIS_ID
        LEFT JOIN DB_SOPORTE.INFO_CASO IC ON IC.ID_CASO = IDH.CASO_ID
        LEFT JOIN DB_SOPORTE.ADMI_TIPO_CASO ATC ON ATC.ID_TIPO_CASO = IC.TIPO_CASO_ID
        LEFT JOIN DB_SOPORTE.ADMI_NIVEL_CRITICIDAD ANC ON ANC.ID_NIVEL_CRITICIDAD = IC.NIVEL_CRITICIDAD_ID
        LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = C.EMPRESA_COD 
        INNER JOIN (
          SELECT MAX(i3_.ID_DETALLE_HISTORIAL) AS DETALLE_ID_HISTORIAL,i3_.DETALLE_ID
          FROM db_soporte.INFO_DETALLE_HISTORIAL i3_
          GROUP BY i3_.DETALLE_ID
        )T2  ON i2_.ID_DETALLE_HISTORIAL=T2.DETALLE_ID_HISTORIAL AND T2.DETALLE_ID=i0_.DETALLE_ID
        INNER JOIN 
        (SELECT MAX(i4_.ID_DETALLE_ASIGNACION) AS DETALLE_ASIGNACION_ID,i4_.DETALLE_ID AS DETALLE_ID
        FROM db_soporte.INFO_DETALLE_ASIGNACION i4_
        GROUP BY i4_.DETALLE_ID
        )T3  ON i0_.ID_DETALLE_ASIGNACION=T3.DETALLE_ASIGNACION_ID AND T3.DETALLE_ID=i0_.DETALLE_ID
        INNER JOIN 
        (SELECT CPD.COMUNICACION_ID AS COMUNICACION_ID,MAX(CPD.VISUALIZAR_MOVIL)
            FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET CPD
            INNER JOIN DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB IFCPC ON IFCPC.ID_CUADRILLA_PLANIF_CAB = CPD.CUADRILLA_PLANIF_CAB_ID
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.CUADRILLA_ID = IFCPC.CUADRILLA_ID
            WHERE CPD.VISUALIZAR_MOVIL IS NOT NULL AND IPER.PERSONA_ID = Pn_persona AND CPD.COMUNICACION_ID IS NOT NULL
            AND NVL(CPD.VISUALIZAR_MOVIL,'N')='S'
            GROUP BY CPD.COMUNICACION_ID
        )T5  ON C.ID_COMUNICACION=T5.COMUNICACION_ID
       WHERE per.persona_id = Pn_persona
       AND per.ESTADO                 = 'Activo'
       AND i2_.ESTADO NOT IN ('Cancelada','Rechazada','Anulada','Finalizada','Replanificada')
       AND i1_.FE_SOLICITADA BETWEEN SYSDATE-30 AND TRUNC(SYSDATE+1)
       ORDER BY i1_.FE_SOLICITADA ASC) group by ID_DETALLE, NOMBRE_TAREA, persona_empresa_rol_id, EMPRESA_COD, DETALLE_SOLICITUD_ID, 
                DETALLE_HIPOTESIS_ID, FE_SOLICITADA, ESTADO, ES_SOLUCION, ID_CASO, 
                NOMBRE_TIPO_CASO, NOMBRE_NIVEL_CRITICIDAD, DESCRIPCION_NIVEL_CRITICIDAD, EMPRESA_CASO, ID_TAREA, 
                PROGRESO_TAREA_ID, NUMERO_CASO) TF
       LEFT JOIN db_soporte.INFO_PROGRESO_TAREA pt ON TF.ID_DETALLE=pt.DETALLE_ID AND TF.ID_COMUNICACION=pt.COMUNICACION_ID
       LEFT JOIN db_soporte.INFO_PROGRESO_PORCENTAJE pp ON pt.PROGRESO_PORCENTAJE_ID = pp.ID_PROGRESO_PORCENTAJE
       INNER JOIN DB_COMUNICACION.INFO_COMUNICACION ICO ON ICO.ID_COMUNICACION = TF.ID_COMUNICACION
       LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = ICO.EMPRESA_COD 
       LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG2 ON IEG2.COD_EMPRESA = TF.EMPRESA_CASO
       WHERE NVL(pt.ESTADO,'Activo')                 = 'Activo'  AND  NVL(PORCENTAJE,0)<100
       GROUP BY TF.ID_COMUNICACION, TF.ID_DETALLE, TF.NOMBRE_TAREA, TF.persona_empresa_rol_id, TF.EMPRESA_COD, 
       TF.DETALLE_SOLICITUD_ID, TF.DETALLE_HIPOTESIS_ID, TF.FE_SOLICITADA, TF.ESTADOTAREA, TF.ES_SOLUCION, 
       TF.ID_CASO,TF.NUMERO_CASO, TF.NOMBRE_TIPO_CASO, TF.NOMBRE_NIVEL_CRITICIDAD, TF.DESCRIPCION_NIVEL_CRITICIDAD, TF.EMPRESA_CASO, 
       TF.ID_TAREA, TF.PROGRESO_TAREA_ID, TF.ID_DETALLE_HISTORIAL, TF.ID_DETALLE_ASIGNACION, ICO.EMPRESA_COD, 
       CASE WHEN IEG2.PREFIJO IS NOT NULL THEN IEG2.PREFIJO ELSE IEG.PREFIJO END
       ORDER BY TF.FE_SOLICITADA ASC;
  --
  CURSOR C_tareasPendientes
  IS
  SELECT 
    TF.ID_COMUNICACION ID_COMUNICACION,
    TF.ID_DETALLE ID_DETALLE,
    TF.NOMBRE_TAREA NOMBRE_TAREA,
    TF.persona_empresa_rol_id PERSONA_EMPRESA_ROL_ID,
    TF.EMPRESA_COD EMPRESA_COD,
    TF.DETALLE_SOLICITUD_ID DETALLE_SOLICITUD_ID,
    TF.DETALLE_HIPOTESIS_ID DETALLE_HIPOTESIS_ID,
    TF.FE_SOLICITADA FE_SOLICITADA,
    TF.ESTADOTAREA ESTADO,
    TF.ES_SOLUCION ES_SOLUCION,
    TF.ID_CASO ID_CASO,
    TF.NUMERO_CASO,
    TF.NOMBRE_TIPO_CASO NOMBRE_TIPO_CASO,
    TF.NOMBRE_NIVEL_CRITICIDAD NOMBRE_NIVEL_CRITICIDAD,
    TF.DESCRIPCION_NIVEL_CRITICIDAD DESCRIPCION_NIVEL_CRITICIDAD,
    TF.EMPRESA_CASO EMPRESA_CASO,
    ICO.EMPRESA_COD EMPRESA_TAREA,
    CASE WHEN IEG2.PREFIJO IS NOT NULL THEN IEG2.PREFIJO ELSE IEG.PREFIJO END AS EMPRESA_PREFIJO,
    TF.ID_TAREA ID_TAREA,
    TF.PROGRESO_TAREA_ID PROGRESO_TAREA_ID,
    NVL(sum(pp.PORCENTAJE),0)AS PORCENTAJE
    FROM(SELECT 
    MIN(ID_COMUNICACION) ID_COMUNICACION,
    ID_DETALLE ID_DETALLE,
    NOMBRE_TAREA NOMBRE_TAREA,
    persona_empresa_rol_id PERSONA_EMPRESA_ROL_ID,
    EMPRESA_COD EMPRESA_COD,
    DETALLE_SOLICITUD_ID DETALLE_SOLICITUD_ID,
    DETALLE_HIPOTESIS_ID DETALLE_HIPOTESIS_ID,
    FE_SOLICITADA FE_SOLICITADA,
    ESTADO ESTADOTAREA,
    ES_SOLUCION ES_SOLUCION,
    ID_CASO ID_CASO,
    NUMERO_CASO,
    NOMBRE_TIPO_CASO NOMBRE_TIPO_CASO,
    NOMBRE_NIVEL_CRITICIDAD NOMBRE_NIVEL_CRITICIDAD,
    DESCRIPCION_NIVEL_CRITICIDAD DESCRIPCION_NIVEL_CRITICIDAD,
    EMPRESA_CASO EMPRESA_CASO,
    ID_TAREA ID_TAREA,
    PROGRESO_TAREA_ID PROGRESO_TAREA_ID,
    MAX(ID_DETALLE_HISTORIAL) ID_DETALLE_HISTORIAL,
    MAX(ID_DETALLE_ASIGNACION) ID_DETALLE_ASIGNACION
    FROM
    (SELECT 
          C.ID_COMUNICACION,
          i1_.ID_DETALLE,
          T.NOMBRE_TAREA, 
          i0_.persona_empresa_rol_id,
          ER.EMPRESA_COD,
          i1_.DETALLE_SOLICITUD_ID,
          i1_.DETALLE_HIPOTESIS_ID,
          i1_.FE_SOLICITADA,
          i2_.ESTADO,
          i1_.ES_SOLUCION,
          IC.ID_CASO,
          IC.NUMERO_CASO,
          ATC.NOMBRE_TIPO_CASO,
          ANC.NOMBRE_NIVEL_CRITICIDAD,
          ANC.DESCRIPCION_NIVEL_CRITICIDAD,
          IC.EMPRESA_COD AS EMPRESA_CASO,
          C.EMPRESA_COD AS EMPRESA_TAREA,
          IEG.PREFIJO AS EMPRESA_PREFIJO,
          T.ID_TAREA,
          i1_.PROGRESO_TAREA_ID,
          i2_.ID_DETALLE_HISTORIAL,
          i0_.ID_DETALLE_ASIGNACION
        FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION i0_
        JOIN DB_SOPORTE.INFO_DETALLE i1_ ON i1_.ID_DETALLE = i0_.DETALLE_ID
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL i2_ ON i2_.DETALLE_ID = i1_.ID_DETALLE
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per ON per.ID_PERSONA_ROL = i0_.PERSONA_EMPRESA_ROL_ID
        JOIN DB_SOPORTE.ADMI_TAREA T ON T.ID_TAREA = i1_.TAREA_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER ON ER.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
        JOIN DB_SOPORTE.INFO_COMUNICACION C ON C.DETALLE_ID = i1_.ID_DETALLE
        LEFT JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDH ON IDH.ID_DETALLE_HIPOTESIS = i1_.DETALLE_HIPOTESIS_ID
        LEFT JOIN DB_SOPORTE.INFO_CASO IC ON IC.ID_CASO = IDH.CASO_ID
        LEFT JOIN DB_SOPORTE.ADMI_TIPO_CASO ATC ON ATC.ID_TIPO_CASO = IC.TIPO_CASO_ID
        LEFT JOIN DB_SOPORTE.ADMI_NIVEL_CRITICIDAD ANC ON ANC.ID_NIVEL_CRITICIDAD = IC.NIVEL_CRITICIDAD_ID
        LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = C.EMPRESA_COD 
        INNER JOIN (
          SELECT MAX(i3_.ID_DETALLE_HISTORIAL) AS DETALLE_ID_HISTORIAL,i3_.DETALLE_ID
          FROM db_soporte.INFO_DETALLE_HISTORIAL i3_
          GROUP BY i3_.DETALLE_ID
        )T2  ON i2_.ID_DETALLE_HISTORIAL=T2.DETALLE_ID_HISTORIAL AND T2.DETALLE_ID=i0_.DETALLE_ID
        INNER JOIN 
        (SELECT MAX(i4_.ID_DETALLE_ASIGNACION) AS DETALLE_ASIGNACION_ID,i4_.DETALLE_ID AS DETALLE_ID
        FROM db_soporte.INFO_DETALLE_ASIGNACION i4_
        GROUP BY i4_.DETALLE_ID
        )T3  ON i0_.ID_DETALLE_ASIGNACION=T3.DETALLE_ASIGNACION_ID AND T3.DETALLE_ID=i0_.DETALLE_ID
       WHERE per.persona_id = Pn_persona
       AND per.ESTADO                 = 'Activo'
       AND i2_.ESTADO NOT IN ('Cancelada','Rechazada','Anulada','Finalizada','Replanificada')
       AND i1_.FE_SOLICITADA BETWEEN SYSDATE-7 AND TRUNC(SYSDATE+1)
       ORDER BY i1_.FE_SOLICITADA ASC) group by ID_DETALLE, NOMBRE_TAREA, persona_empresa_rol_id, EMPRESA_COD, DETALLE_SOLICITUD_ID, 
        DETALLE_HIPOTESIS_ID, FE_SOLICITADA, ESTADO, ES_SOLUCION, ID_CASO,  NUMERO_CASO,
        NOMBRE_TIPO_CASO, NOMBRE_NIVEL_CRITICIDAD, DESCRIPCION_NIVEL_CRITICIDAD, EMPRESA_CASO, ID_TAREA, 
        PROGRESO_TAREA_ID
       ) TF
       LEFT JOIN db_soporte.INFO_PROGRESO_TAREA pt ON TF.ID_DETALLE=pt.DETALLE_ID AND TF.ID_COMUNICACION=pt.COMUNICACION_ID
       LEFT JOIN db_soporte.INFO_PROGRESO_PORCENTAJE pp ON pt.PROGRESO_PORCENTAJE_ID = pp.ID_PROGRESO_PORCENTAJE
       INNER JOIN DB_COMUNICACION.INFO_COMUNICACION ICO ON ICO.ID_COMUNICACION = TF.ID_COMUNICACION
       LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = ICO.EMPRESA_COD 
       LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG2 ON IEG2.COD_EMPRESA = TF.EMPRESA_CASO 
       WHERE NVL(pt.ESTADO,'Activo')                 = 'Activo'  AND  NVL(PORCENTAJE,0)<100
       GROUP BY TF.ID_COMUNICACION, TF.ID_DETALLE, TF.NOMBRE_TAREA, TF.persona_empresa_rol_id, TF.EMPRESA_COD, 
       TF.DETALLE_SOLICITUD_ID, TF.DETALLE_HIPOTESIS_ID, TF.FE_SOLICITADA, TF.ESTADOTAREA, TF.ES_SOLUCION, 
       TF.ID_CASO, TF.NUMERO_CASO, TF.NOMBRE_TIPO_CASO, TF.NOMBRE_NIVEL_CRITICIDAD, TF.DESCRIPCION_NIVEL_CRITICIDAD, TF.EMPRESA_CASO, 
       TF.ID_TAREA, TF.PROGRESO_TAREA_ID, TF.ID_DETALLE_HISTORIAL, TF.ID_DETALLE_ASIGNACION, ICO.EMPRESA_COD, 
       CASE WHEN IEG2.PREFIJO IS NOT NULL THEN IEG2.PREFIJO ELSE IEG.PREFIJO END
       ORDER BY TF.FE_SOLICITADA ASC;
  --
  CURSOR C_getInfoPorSolicitud (Cn_solicitud NUMBER)
  IS
    SELECT 
      er.EMPRESA_COD,
      s.ID_SERVICIO,
      IPC.ID_PLAN,
      IPC.NOMBRE_PLAN,
      APRO.ID_PRODUCTO,
      APRO.DESCRIPCION_PRODUCTO,
      TS.DESCRIPCION_SOLICITUD,
      P.ID_PUNTO,
      ip.ID_PERSONA,
      ip.NOMBRES
      ||' '
      ||ip.APELLIDOS AS nombre_completo ,
      ip.RAZON_SOCIAL,
      (SELECT PFC.VALOR
      FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PFC,
        DB_COMERCIAL.ADMI_FORMA_CONTACTO FC
      WHERE FC.ID_FORMA_CONTACTO = PFC.FORMA_CONTACTO_ID
      AND FC.DESCRIPCION_FORMA_CONTACTO LIKE 'Telefono Movil%'
      AND PFC.PUNTO_ID = P.ID_PUNTO
      AND ROWNUM < 2
      ) AS TELEFONO,
    REPLACE(P.DIRECCION,'|'),
    P.LATITUD,
    P.LONGITUD,
    DECODE (S.TIPO_ORDEN, 'N', 'NUEVO', 'T', 'TRASLADO', 'R', 'REUBICACION'),
    P.LOGIN,
    (CASE WHEN NVL(IPRT.PROGRESO_PORCENTAJE_ID,1) = 3 THEN 'S' ELSE 'N' END)
    FROM INFO_DETALLE_SOLICITUD DS
    LEFT JOIN INFO_SERVICIO S  ON S.ID_SERVICIO = DS.SERVICIO_ID
    LEFT JOIN INFO_PUNTO P ON P.ID_PUNTO = S.PUNTO_ID
    LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS ON TS.ID_TIPO_SOLICITUD = DS.TIPO_SOLICITUD_ID
    LEFT JOIN INFO_PERSONA_EMPRESA_ROL per ON per.ID_PERSONA_ROL = P.PERSONA_EMPRESA_ROL_ID
    LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL er ON er.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
    LEFT JOIN info_persona ip ON ip.ID_PERSONA = per.PERSONA_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC ON IPC.ID_PLAN = S.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = S.PRODUCTO_ID
    LEFT JOIN DB_COMERCIAL.INFO_DETALLE INFDT ON INFDT.DETALLE_SOLICITUD_ID = DS.ID_DETALLE_SOLICITUD
    LEFT JOIN DB_SOPORTE.INFO_PROGRESO_TAREA IPRT ON (IPRT.DETALLE_ID = INFDT.ID_DETALLE AND IPRT.PROGRESO_PORCENTAJE_ID IN (3))
    WHERE 
    DS.ID_DETALLE_SOLICITUD = Cn_solicitud;
  --
  CURSOR C_getInfoPorPunto (Cn_id NUMBER)
  IS
    SELECT
      er.EMPRESA_COD,
      IPC.ID_PLAN,
      IPC.NOMBRE_PLAN,
      APRO.ID_PRODUCTO,
      APRO.DESCRIPCION_PRODUCTO,
      P.ID_PUNTO,
      ip.ID_PERSONA,
      ip.NOMBRES
      ||' '
      ||ip.APELLIDOS AS nombre_completo ,
      ip.RAZON_SOCIAL,
      (SELECT PFC.VALOR
      FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PFC,
        DB_COMERCIAL.ADMI_FORMA_CONTACTO FC
      WHERE FC.ID_FORMA_CONTACTO = PFC.FORMA_CONTACTO_ID
      AND FC.DESCRIPCION_FORMA_CONTACTO LIKE 'Telefono Movil%'
      AND PFC.PUNTO_ID = P.ID_PUNTO
      AND ROWNUM < 2
      ) AS TELEFONO,
    REPLACE(P.DIRECCION,'|'),
    P.LATITUD,
    P.LONGITUD,
    AC.NOMBRE_CANTON,
    P.LOGIN
  FROM 
    INFO_PUNTO P
    LEFT JOIN INFO_PERSONA_EMPRESA_ROL per ON per.ID_PERSONA_ROL = P.PERSONA_EMPRESA_ROL_ID
    LEFT JOIN INFO_PERSONA ip ON ip.ID_PERSONA = per.PERSONA_ID
    LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL er ON er.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
    LEFT JOIN DB_GENERAL.ADMI_SECTOR ASEC ON ASEC.ID_SECTOR = P.SECTOR_ID
    LEFT JOIN DB_GENERAL.ADMI_PARROQUIA AP ON AP.ID_PARROQUIA = ASEC.PARROQUIA_ID
    LEFT JOIN DB_GENERAL.ADMI_CANTON AC ON AC.ID_CANTON = AP.CANTON_ID
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO IFS ON IFS.PUNTO_ID = P.ID_PUNTO
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC ON IPC.ID_PLAN = IFS.PLAN_ID AND IFS.ESTADO IN ('Activo', 'In-Corte')
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = IFS.PRODUCTO_ID AND IFS.ESTADO IN ('Activo', 'In-Corte') 
  WHERE P.ID_PUNTO = Cn_id;
  --
  --aqui 
CURSOR C_getTipoMedioPorSolicitud (Cn_id_solicitud NUMBER)
  IS
    SELECT ATM.CODIGO_TIPO_MEDIO 
    FROM 
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, 
        DB_SOPORTE.ADMI_TIPO_MEDIO ATM ,
        DB_SOPORTE.INFO_SERVICIO_TECNICO IST 
    WHERE 
        IDS.SERVICIO_ID = IST.SERVICIO_ID 
    AND 
        IDS.ID_DETALLE_SOLICITUD = Cn_id_solicitud 
    AND 
        IST.ULTIMA_MILLA_ID = ATM.ID_TIPO_MEDIO 
    AND 
        ATM.ESTADO = 'Activo'; 
--
CURSOR C_getTipoMedioPorCaso(Cn_caso_id NUMBER)
  IS
    SELECT ATM.CODIGO_TIPO_MEDIO 
    FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS DH,
                  DB_SOPORTE.INFO_DETALLE ID,
                  DB_SOPORTE.INFO_PARTE_AFECTADA IPA,
                  DB_SOPORTE.ADMI_TIPO_MEDIO ATM ,
        DB_SOPORTE.INFO_SERVICIO_TECNICO IST
    WHERE DH.CASO_ID = Cn_caso_id
    AND DH.ID_DETALLE_HIPOTESIS = ID.DETALLE_HIPOTESIS_ID
    AND IPA.DETALLE_ID = ID.ID_DETALLE
    AND IPA.TIPO_AFECTADO='Servicio'
    AND IST.SERVICIO_ID = IPA.AFECTADO_ID
    AND IST.ULTIMA_MILLA_ID = ATM.ID_TIPO_MEDIO 
    and ATM.ESTADO = 'Activo';
 --
CURSOR C_getEsEnlace (Cn_id_solicitud NUMBER)
  IS
    SELECT APO.ES_ENLACE
    FROM DB_SOPORTE.INFO_DETALLE_SOLICITUD IDA
    INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISO ON IDA.SERVICIO_ID=ISO.ID_SERVICIO
    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO APO ON APO.ID_PRODUCTO=ISO.PRODUCTO_ID
    WHERE IDA.ID_DETALLE_SOLICITUD = Cn_id_solicitud
    AND ROWNUM<2;     

CURSOR C_getTipoFactPorSol (Cn_id_solicitud NUMBER)
  IS
    SELECT VALOR 
    FROM 
      DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
      JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ON IDS.SERVICIO_ID = ISPC.SERVICIO_ID
      JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC  ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
    WHERE 
       AC.DESCRIPCION_CARACTERISTICA = 'TIPO_FACTIBILIDAD' AND 
       IDS.ID_DETALLE_SOLICITUD = Cn_id_solicitud 
    AND AC.ESTADO = 'Activo' AND ISPC.ESTADO = 'Activo';     


CURSOR C_getProducto (Cn_idServcio NUMBER)
  IS
   SELECT INFO.PRODUCTO_ID,ADMI.DESCRIPCION_PRODUCTO 
   FROM DB_COMERCIAL.INFO_SERVICIO INFO, DB_COMERCIAL.ADMI_PRODUCTO ADMI 
   WHERE INFO.PRODUCTO_ID=ADMI.ID_PRODUCTO AND ID_SERVICIO=Cn_idServcio;

  --
  Lv_nombreSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE;
  Ln_Punto           DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
  Ln_persona         DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE;
  Lv_nombre          DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE;
  Lv_razonSocial     DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE;
  Lv_telefono        DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO.VALOR%TYPE;
  Lv_direccion       DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE;
  Lf_latitud         DB_COMERCIAL.INFO_PUNTO.LATITUD%TYPE;
  Lf_longitud        DB_COMERCIAL.INFO_PUNTO.LONGITUD%TYPE;
  Ln_minDetalle      DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE;

  Ln_afectado        DB_SOPORTE.INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE;
  Ln_tipoAfectado    DB_SOPORTE.INFO_PARTE_AFECTADA.TIPO_AFECTADO%TYPE;
  Lb_tieneAfectado   BOOLEAN := false;
  --
  Ln_idElemento      DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
  Lv_nombreElemento  DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE;
  Lv_tipoElemento    DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;
  Lv_modeloElemento  DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;

  Ln_servicio        DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;

  Ln_idPlan          DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
  Lv_nombrePlan      DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE;
  Ln_idProducto      DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
  Lv_nombreProducto  DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE;

  Ln_empresa         DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
  Lv_ciudad          DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE;
  Ln_tipoOrden       DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE;
  Ln_Login           DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;

  Ln_TipoMedio       VARCHAR2(10);
  Ln_esEnlace        VARCHAR2(10);
  Ln_factibilidad    VARCHAR2(10);

  Lv_resultado       CLOB;
  Lv_info            VARCHAR2(32766);

  Lv_isHal           C_getInfoCuadrillaHal%ROWTYPE;
  Ln_ProgRuta        VARCHAR2(10);

BEGIN

   OPEN C_getInfoCuadrillaHal;
   FETCH C_getInfoCuadrillaHal INTO Lv_isHal; 
   CLOSE C_getInfoCuadrillaHal; 

   IF Lv_isHal.ISHAL = 1
   THEN
      FOR i IN C_tareasPendientes_hal
      LOOP
        --SE FILTRA POR TAREAS DE INSTALACION
          --
          Lb_tieneAfectado := false;
          --
          Ln_afectado       := NULL;
          Ln_tipoAfectado   := NULL;
          Ln_Punto          := NULL;
          Ln_persona        := NULL;
          Lv_nombre         := NULL;
          Lv_razonSocial    := NULL;
          Lv_telefono       := NULL;
          Lv_direccion      := NULL;
          Lf_latitud        := NULL;
          Lf_longitud       := NULL;   
          Ln_idElemento     := NULL; 
          Lv_nombreElemento := NULL; 
          Lv_tipoElemento   := NULL; 
          Lv_modeloElemento := NULL; 
          Ln_servicio       := NULL;
          Ln_idPlan         := NULL; 
          Lv_nombrePlan     := NULL;
          Ln_idProducto     := NULL;
          Lv_nombreProducto := NULL;  
          Ln_empresa        := NULL;
          Lv_ciudad         := NULL;
          Ln_tipoOrden      := NULL;
          Ln_Login          := NULL;
          Ln_TipoMedio      := 'none';
          Ln_factibilidad   := 'none';
          Ln_esEnlace       := 'none';
          Ln_ProgRuta       := 'N';
          --
			--INSTALACION
          IF i.detalle_solicitud_id IS NOT NULL THEN

            OPEN C_getTipoMedioPorSolicitud(i.detalle_solicitud_id);
            FETCH C_getTipoMedioPorSolicitud
            INTO
              Ln_TipoMedio;
            CLOSE C_getTipoMedioPorSolicitud;

             OPEN C_getTipoFactPorSol(i.detalle_solicitud_id);
            FETCH C_getTipoFactPorSol
            INTO
              Ln_factibilidad;
            CLOSE C_getTipoFactPorSol;

            OPEN C_getEsEnlace(i.detalle_solicitud_id);
            FETCH C_getEsEnlace
            INTO
              Ln_esEnlace;
            CLOSE C_getEsEnlace;

            OPEN C_getInfoPorSolicitud(i.detalle_solicitud_id);
            FETCH C_getInfoPorSolicitud
            INTO 
              Ln_empresa,
              Ln_servicio,
              Ln_idPlan,
              Lv_nombrePlan,
              Ln_idProducto,
              Lv_nombreProducto,
              Lv_nombreSolicitud,
              Ln_Punto,
              Ln_persona,
              Lv_nombre,
              Lv_razonSocial,
              Lv_telefono,
              Lv_direccion,
              Lf_latitud,
              Lf_longitud,
              Ln_tipoOrden,
              Ln_Login,
              Ln_ProgRuta;
            CLOSE C_getInfoPorSolicitud;      
            --
            ELSIF i.detalle_hipotesis_id IS NOT NULL THEN

              OPEN C_getMinDetalle(i.detalle_hipotesis_id);
              FETCH C_getMinDetalle INTO Ln_minDetalle;
              CLOSE C_getMinDetalle;
              IF Ln_minDetalle IS NOT NULL THEN
                Lb_tieneAfectado := true;
                OPEN C_getInfoAfectado(Ln_minDetalle);
                FETCH C_getInfoAfectado INTO Ln_afectado, Ln_tipoAfectado;
                CLOSE C_getInfoAfectado;

              END IF;
            ELSE     

                Lb_tieneAfectado := true;

                OPEN C_getInfoAfectado(i.id_detalle);
                FETCH C_getInfoAfectado INTO Ln_afectado, Ln_tipoAfectado;
                CLOSE C_getInfoAfectado;

            END IF;

 			-- Esto es para CASOS
           	IF i.id_caso IS NOT NULL THEN
	           	OPEN C_getTipoMedioPorCaso(i.id_caso);
	            FETCH C_getTipoMedioPorCaso INTO Ln_TipoMedio;
	            CLOSE C_getTipoMedioPorCaso;
            END IF;

            DBMS_OUTPUT.PUT_LINE('I got here:'||i.id_detalle); 
            OPEN C_getInfoAfectadoServicio(i.id_detalle);
            FETCH C_getInfoAfectadoServicio INTO Ln_servicio;
            CLOSE C_getInfoAfectadoServicio;

            --
            IF Lb_tieneAfectado = true THEN
              IF Ln_tipoAfectado = 'Cliente' THEN
                --DBMS_OUTPUT.PUT_LINE ('Cliente');
                OPEN C_getInfoPorPunto(Ln_afectado);
                FETCH C_getInfoPorPunto
                INTO Ln_empresa,

                  Ln_idPlan,
                  Lv_nombrePlan,
                  Ln_idProducto,
                  Lv_nombreProducto,
                  Ln_Punto,
                  Ln_persona,
                  Lv_nombre,
                  Lv_razonSocial,
                  Lv_telefono,
                  Lv_direccion,
                  Lf_latitud,
                  Lf_longitud,
                  Lv_ciudad,
                  Ln_Login;
                CLOSE C_getInfoPorPunto;
                --
              elsif Ln_tipoAfectado = 'Servicio' THEN
                OPEN C_getInfoPorPunto(Ln_afectado);
                FETCH C_getInfoPorPunto
                INTO Lv_nombreSolicitud,
                  Ln_idPlan,
                  Lv_nombrePlan,
                  Ln_idProducto,
                  Lv_nombreProducto,
                  Ln_Punto,
                  Ln_persona,
                  Lv_nombre,
                  Lv_razonSocial,
                  Lv_telefono,
                  Lv_direccion,
                  Lf_latitud,
                  Lf_longitud,
                  Lv_ciudad,
                  Ln_Login;
                CLOSE C_getInfoPorPunto;
             
               
                
              elsif Ln_tipoAfectado= 'Elemento' THEN
                open C_getElemento(Ln_afectado);
                fetch C_getElemento into  Ln_idElemento, Lv_nombreElemento, Lv_tipoElemento, Lv_modeloElemento, Lf_latitud, Lf_longitud;
                close C_getElemento;

              END IF;
              
              
              
              --
            END IF; 

            --SI LA EMPRESA ES NULL O VACIO SE LE SETEA LA EMPRESA DE LA TAREA
              IF Ln_empresa IS NULL THEN
              IF I.EMPRESA_CASO IS NOT NULL THEN
                  Ln_empresa := I.EMPRESA_CASO;
                ELSE
                  Ln_empresa := I.EMPRESA_TAREA;
                END IF;
              END IF;
              
              
              
                OPEN C_getProducto(Ln_servicio);
                FETCH C_getProducto 
                INTO Ln_idProducto, 
                     Lv_nombreProducto;
                CLOSE C_getProducto;
                    
                     
              
              Lv_info :=           
              I.ID_COMUNICACION||'|'||
              I.NOMBRE_TAREA||'|'||
              to_char(I.FE_SOLICITADA,'dd/mm/yyyy HH:mi.am')||'|'||
              Lv_nombreSolicitud||'|'||
              Ln_empresa||'|'||
              Ln_servicio||'|'||
              Ln_Punto||'|'||
              Ln_persona||'|'||
              Lv_nombre||'|'||
              Lv_razonSocial||'|'||
              Lv_telefono||'|'||
              Lv_direccion ||'|'||
              Lf_latitud||'|'||
              Lf_longitud||'|'||
              Ln_idElemento||'|'||
              Lv_nombreElemento||'|'||
              Lv_tipoElemento||'|'||
              Lv_modeloElemento||'|'||
              Lv_ciudad||'|'||
              I.ESTADO||'|'||
              I.ES_SOLUCION||'|'||
              I.ID_CASO||'|'||

              I.NOMBRE_TIPO_CASO||'|'||
              I.NOMBRE_NIVEL_CRITICIDAD||'|'||
              I.DESCRIPCION_NIVEL_CRITICIDAD||'|'||
              I.ID_DETALLE||'|'||
              I.EMPRESA_PREFIJO||'|'||
              Ln_tipoOrden||'|'||
              I.ID_TAREA||'|'||
              I.PROGRESO_TAREA_ID||'|'||
              I.PORCENTAJE||'|'||
              Ln_Login||'|'||
              Ln_TipoMedio||'|'||
              Ln_factibilidad||'|'||
              Ln_esEnlace||'|'||
              I.DETALLE_SOLICITUD_ID||'|'||
              Ln_idPlan||'|'||
              Lv_nombrePlan||'|'||
              Ln_idProducto||'|'||
              Lv_nombreProducto||'|'||
              I.NUMERO_CASO||'|'||
              Ln_ProgRuta;
              --WVERA  PROBARCON NNAULAL 
              --
              if Lv_resultado is not null then 
                Lv_resultado := Lv_resultado  || '&&' || Lv_info;
              else
                Lv_resultado:= Lv_info;        
              end if;     
        END LOOP;    

   ELSE
      FOR i IN C_tareasPendientes
      LOOP
        --SE FILTRA POR TAREAS DE INSTALACION
          --
          Lb_tieneAfectado := false;
          --
          Lv_nombreSolicitud:= NULL;
          Ln_afectado       := NULL;
          Ln_tipoAfectado   := NULL;
          Ln_Punto          := NULL;
          Ln_persona        := NULL;
          Lv_nombre         := NULL;
          Lv_razonSocial    := NULL;
          Lv_telefono       := NULL;
          Lv_direccion      := NULL;
          Lf_latitud        := NULL;
          Lf_longitud       := NULL;   
          Ln_idElemento     := NULL; 
          Lv_nombreElemento := NULL; 
          Lv_tipoElemento   := NULL; 
          Lv_modeloElemento := NULL; 
          Ln_servicio       := NULL;
          Ln_idPlan         := NULL; 
          Lv_nombrePlan     := NULL;
          Ln_idProducto     := NULL;
          Lv_nombreProducto := NULL; 
          Ln_empresa        := NULL;
          Lv_ciudad         := NULL;
          Ln_tipoOrden      := NULL;
          Ln_Login          := NULL;
          Ln_TipoMedio      := 'none';
          Ln_factibilidad   := 'none';
          Ln_esEnlace       := 'none';
          Ln_ProgRuta       := 'N';
          --

          IF i.detalle_solicitud_id IS NOT NULL THEN

            OPEN C_getTipoMedioPorSolicitud(i.detalle_solicitud_id);
            FETCH C_getTipoMedioPorSolicitud
            INTO
              Ln_TipoMedio;
            CLOSE C_getTipoMedioPorSolicitud;

             OPEN C_getTipoFactPorSol(i.detalle_solicitud_id);
            FETCH C_getTipoFactPorSol
            INTO
              Ln_factibilidad;
            CLOSE C_getTipoFactPorSol;

            OPEN C_getEsEnlace(i.detalle_solicitud_id);
            FETCH C_getEsEnlace
            INTO
              Ln_esEnlace;
            CLOSE C_getEsEnlace;

            OPEN C_getInfoPorSolicitud(i.detalle_solicitud_id);
            FETCH C_getInfoPorSolicitud
            INTO 
              Ln_empresa,
              Ln_servicio,
              Ln_idPlan,
              Lv_nombrePlan,
              Ln_idProducto,
              Lv_nombreProducto,
              Lv_nombreSolicitud,
              Ln_Punto,
              Ln_persona,
              Lv_nombre,
              Lv_razonSocial,
              Lv_telefono,
              Lv_direccion,
              Lf_latitud,
              Lf_longitud,
              Ln_tipoOrden,
              Ln_Login,
              Ln_ProgRuta;
            CLOSE C_getInfoPorSolicitud;      
            --
            ELSIF i.detalle_hipotesis_id IS NOT NULL THEN

              OPEN C_getMinDetalle(i.detalle_hipotesis_id);
              FETCH C_getMinDetalle INTO Ln_minDetalle;
              CLOSE C_getMinDetalle;
              IF Ln_minDetalle IS NOT NULL THEN
                Lb_tieneAfectado := true;
                OPEN C_getInfoAfectado(Ln_minDetalle);
                FETCH C_getInfoAfectado INTO Ln_afectado, Ln_tipoAfectado;
                CLOSE C_getInfoAfectado;

              END IF;

            ELSE     

                Lb_tieneAfectado := true;

                OPEN C_getInfoAfectado(i.id_detalle);
                FETCH C_getInfoAfectado INTO Ln_afectado, Ln_tipoAfectado;
                CLOSE C_getInfoAfectado;

            END IF;

            -- Esto es para 
           	IF i.id_caso IS NOT NULL THEN
	           	OPEN C_getTipoMedioPorCaso(i.id_caso);
	            FETCH C_getTipoMedioPorCaso INTO Ln_TipoMedio;
	            CLOSE C_getTipoMedioPorCaso;
            END IF;

            DBMS_OUTPUT.PUT_LINE('I got here:'||i.id_detalle); 
            OPEN C_getInfoAfectadoServicio(i.id_detalle);
            FETCH C_getInfoAfectadoServicio INTO Ln_servicio;
            CLOSE C_getInfoAfectadoServicio;

            --
            IF Lb_tieneAfectado = true THEN
              IF Ln_tipoAfectado = 'Cliente' THEN
                --DBMS_OUTPUT.PUT_LINE ('Cliente');
                OPEN C_getInfoPorPunto(Ln_afectado);
                FETCH C_getInfoPorPunto
                INTO Ln_empresa,
                  Ln_idPlan,
                  Lv_nombrePlan,
                  Ln_idProducto,
                  Lv_nombreProducto,
                  Ln_Punto,
                  Ln_persona,
                  Lv_nombre,
                  Lv_razonSocial,
                  Lv_telefono,
                  Lv_direccion,
                  Lf_latitud,
                  Lf_longitud,
                  Lv_ciudad,
                  Ln_Login;
                CLOSE C_getInfoPorPunto;
                --
              elsif Ln_tipoAfectado = 'Servicio' THEN
                OPEN C_getInfoPorPunto(Ln_afectado);
                FETCH C_getInfoPorPunto
                INTO Lv_nombreSolicitud,
                  Ln_idPlan,
                  Lv_nombrePlan,
                  Ln_idProducto,
                  Lv_nombreProducto,
                  Ln_Punto,
                  Ln_persona,
                  Lv_nombre,
                  Lv_razonSocial,
                  Lv_telefono,
                  Lv_direccion,
                  Lf_latitud,
                  Lf_longitud,
                  Lv_ciudad,
                  Ln_Login;
                CLOSE C_getInfoPorPunto;
              elsif Ln_tipoAfectado= 'Elemento' THEN

                open C_getElemento(Ln_afectado);
                fetch C_getElemento into  Ln_idElemento, Lv_nombreElemento, Lv_tipoElemento, Lv_modeloElemento, Lf_latitud, Lf_longitud;
                close C_getElemento;

              END IF;
              --
            END IF; 

            --SI LA EMPRESA ES NULL O VACIO SE LE SETEA LA EMPRESA DE LA TAREA
              IF Ln_empresa IS NULL THEN
              IF I.EMPRESA_CASO IS NOT NULL THEN
                  Ln_empresa := I.EMPRESA_CASO;
                ELSE
                  Ln_empresa := I.EMPRESA_TAREA;
                END IF;
              END IF;
              
                    OPEN C_getProducto(Ln_servicio);
                FETCH C_getProducto 
                INTO Ln_idProducto, 
                     Lv_nombreProducto;
                CLOSE C_getProducto;
                    

              Lv_info :=           
              I.ID_COMUNICACION||'|'||
              I.NOMBRE_TAREA||'|'||
              to_char(I.FE_SOLICITADA,'dd/mm/yyyy HH:mi.am')||'|'||
              Lv_nombreSolicitud||'|'||
              Ln_empresa||'|'||
              Ln_servicio||'|'||
              Ln_Punto||'|'||
              Ln_persona||'|'||
              Lv_nombre||'|'||
              Lv_razonSocial||'|'||
              Lv_telefono||'|'||
              Lv_direccion ||'|'||
              Lf_latitud||'|'||
              Lf_longitud||'|'||
              Ln_idElemento||'|'||
              Lv_nombreElemento||'|'||
              Lv_tipoElemento||'|'||
              Lv_modeloElemento||'|'||
              Lv_ciudad||'|'||
              I.ESTADO||'|'||
              I.ES_SOLUCION||'|'||
              I.ID_CASO||'|'||
              I.NOMBRE_TIPO_CASO||'|'||
              I.NOMBRE_NIVEL_CRITICIDAD||'|'||
              I.DESCRIPCION_NIVEL_CRITICIDAD||'|'||
              I.ID_DETALLE||'|'||
              I.EMPRESA_PREFIJO||'|'||
              Ln_tipoOrden||'|'||
              I.ID_TAREA||'|'||
              I.PROGRESO_TAREA_ID||'|'||
              I.PORCENTAJE||'|'||
              Ln_Login||'|'||
              Ln_TipoMedio||'|'||
              Ln_factibilidad||'|'||
              Ln_esEnlace||'|'||
              I.DETALLE_SOLICITUD_ID||'|'||
              Ln_idPlan||'|'||
              Lv_nombrePlan||'|'||
              Ln_idProducto||'|'||
              Lv_nombreProducto||'|'||
              I.NUMERO_CASO||'|'||
              Ln_ProgRuta;
              --
              if Lv_resultado is not null then 
                Lv_resultado := Lv_resultado  || '&&' || Lv_info;
              else
                Lv_resultado:= Lv_info;        
              end if;

        END LOOP;    

   END IF;

   RETURN Lv_resultado;
  --
  END COMF_GET_TAREAS_POR_PERSONA;

END SPKG_GESTION_TAREAS_TYM;
/