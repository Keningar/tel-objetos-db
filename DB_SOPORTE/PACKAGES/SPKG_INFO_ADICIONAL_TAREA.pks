CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_INFO_ADICIONAL_TAREA AS
/*
  * Documentación para FUNCIÓN 'F_GET_TAREA_TIEMPO_PARCIAL'.
  * Función que obtiene la ultima fecha y tiempo de la tarea
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  id_detalle de la tarea
  * @Param VARCHAR2  Pv_estado  ->  estado de la tarea
  * @Param NUMBER   Pn_id_caso  -> id de caso
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_TAREA_TIEMPO_PARCIAL(Pn_detalle_id NUMBER, Pv_estado VARCHAR2, Pn_id_caso NUMBER)
      RETURN VARCHAR2;
 
/*
  * Documentación para FUNCIÓN 'F_GET_INFO_CASO'.
  * Función que obtiene el numero de caso 
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_id_caso  ->  id caso
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_INFO_CASO(Pn_id_caso NUMBER)
      RETURN VARCHAR2;
     
 /*
  * Documentación para FUNCIÓN 'F_GET_CLIENTES_AFECTADOS'.
  * Función que obtiene el cliente afectado
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  id detalle
  * @Param NUMBER  Pn_id_caso  ->  id caso
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_CLIENTES_AFECTADOS(Pn_detalle_id NUMBER, Pn_id_caso NUMBER)
      RETURN VARCHAR2;
     
 /*
  * Documentación para FUNCIÓN 'F_GET_FECHA_CREA_TAREA'.
  * Función que obtiene la fecha en que se inicio o acepto la tarea
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  id detalle
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_FECHA_CREA_TAREA(Pn_detalle_id NUMBER)
      RETURN VARCHAR2;
     
 /*
  * Documentación para FUNCIÓN 'F_GET_FECHA_TIEMPO_PARCIAL'.
  * Función que obtiene fecha y tiempo de la tarea
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  id detalle
  * @Param NUMBER  Pv_estado  ->  estado de la tarea
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_FECHA_TIEMPO_PARCIAL(Pn_detalle_id NUMBER, Pv_estado VARCHAR2)
      RETURN VARCHAR2; 
     
 /*
  * Documentación para FUNCIÓN 'F_GET_DEP_COORDINADOR'.
  * Función que obtiene el id departamento del coordinador
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_id_persona  ->  id persona
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_DEP_COORDINADOR(Pn_id_persona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
      RETURN NUMBER; 
     
 /*
  * Documentación para FUNCIÓN 'F_GET_ULTIMA_MILLA_SOPORTE'.
  * Función que obtiene el codigo timpo medio
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_id_caso  ->  id de caso
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_ULTIMA_MILLA_SOPORTE(Pn_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN VARCHAR2; 
     
  /*
  * Documentación para FUNCIÓN 'F_GET_CARACTERISTICA_DETALLE'.
  * Función que obtiene el codigo timpo medio
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  detalle id
  *  @Param NUMBER  Pn_numero_tarea  ->  numero de tarea
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_CARACTERISTICA_DETALLE(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
  									    Pn_numero_tarea DB_SOPORTE.INFO_TAREA.NUMERO_TAREA%TYPE)
      RETURN VARCHAR2; 
     
     
/*
  * Documentación para FUNCIÓN 'F_GET_MOTIVO_POR_TAREA'.
  * Función que obtiene la tarea anterior
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  detalle id
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_MOTIVO_POR_TAREA(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
      RETURN VARCHAR2;
     
 /*
  * Documentación para FUNCIÓN 'F_GET_INFO_ADICIONAL_TAREA'.
  * Función que obtiene información de tarea adicional
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  detalle id
  * @Param VARCHAR2  Pv_nombre_tarea  ->  nombre de tarea
  * @Param VARCHAR2  Pv_tareas_adicional  ->  lista de tareas adicionales
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_INFO_ADICIONAL_TAREA(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
  									  Pv_nombre_tarea DB_SOPORTE.INFO_TAREA.NOMBRE_TAREA%TYPE,
  									  Pv_tareas_adicional VARCHAR2)
      RETURN VARCHAR2;
     
  /*
  * Documentación para FUNCIÓN 'F_GET_ID_SERVICIO_VRF'.
  * Función que obtiene el id_servicio afectado
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  detalle id
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_ID_SERVICIO_VRF(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
      RETURN NUMBER;
 
  /*
  * Documentación para FUNCIÓN 'F_GET_INFO_TAREA_DETALE_CASO'.
  * Función que retorna el id persona por detalle o caso.
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  detalle id
  * @Param NUMBER Pn_id_caso  -> id del caso
  * @Param VARCHAR2 Pv_cod_emp -> codigo de empresa
  * @Param VARCHAR2 Pv_es_departamental -> bamdera si tarea es departamental
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_GET_INFO_TAREA_DETALE_CASO(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
	  										Pn_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
	  										Pv_cod_emp DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
	  										Pv_es_departamental VARCHAR2)
      RETURN VARCHAR2;
     
/*
  * Documentación para FUNCIÓN 'F_GET_VALIDA_PROGRESO_TAREA'.
  * Función que retorna el id persona por detalle o caso.
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id  ->  detalle id
  * @Param NUMBER Pn_id_caso  -> id del caso
  * @Param VARCHAR2 Pv_cod_emp -> codigo de empresa
  * @Param VARCHAR2 Pv_es_departamental -> bamdera si tarea es departamental
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  *
  * @author Emmanuel Martillo. <filopez@telconet.ec>
  * @version 1.1 28-02-2023  Se agrega validacion por codigo de empresa Ecuanet para obtener
  *                          el progreso PROG_SOPORTE_EN_FIBRA,PROG_SOPORTE_EN_MATERIALES,
  *                          PROG_INSTALACION_EN_FIBRA,PROG_INSTALACION_EN_MATERIALES.
  */
  FUNCTION F_GET_VALIDA_PROGRESO_TAREA(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
  										Pn_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
  										Pv_cod_emp DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  										Pv_es_departamental VARCHAR2)
      RETURN VARCHAR2;
     
  /*
  * Documentación para FUNCIÓN 'F_GET_TOTAL_TAREA_PERFIL'.
  * Función que retorna el total de tareas abiertas por perfil.
  *
  * PARAMETROS:
  * @Param VARCHAR2 Pv_FechaDefecto -> fecha por defecto
  * @Param VARCHAR2 Pv_PersonaEmpresaRol -> array de id persona empresa rol
  * @author Fernando López. <filopez@telconet.ec>
  * @version 1.0 28-07-2022
  */
  FUNCTION F_GET_TOTAL_TAREA_PERFIL(Pv_FechaDefecto VARCHAR2,
									Pv_PersonaEmpresaRol VARCHAR2)
      RETURN NUMBER;
     
END SPKG_INFO_ADICIONAL_TAREA;
/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_INFO_ADICIONAL_TAREA AS

FUNCTION F_GET_TAREA_TIEMPO_PARCIAL(Pn_detalle_id NUMBER, Pv_estado VARCHAR2,Pn_id_caso NUMBER)
     RETURN VARCHAR2
  IS
    Le_Exception               EXCEPTION;
    lv_fe_creacion            VARCHAR2(50):= null;
    ln_tiempo                  number:= -1;
    Lv_camp_retorna            VARCHAR2(1000) := '{"has_fecha":"N","fe_creacion":"","tiempo":-1}';
    Lv_MensajeError            VARCHAR2(4000);

  BEGIN

    IF Pn_detalle_id IS NOT NULL AND Pv_estado IS NOT NULL AND Pn_id_caso != 0 THEN 
		
    	BEGIN 
		    SELECT TO_CHAR(FE_CREACION, 'YYYY-MM-DD HH24:MI:SS') AS FECHA, TIEMPO INTO lv_fe_creacion, ln_tiempo  FROM 
			    (SELECT itt.FE_CREACION,itt.TIEMPO FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL itt WHERE  itt.detalle_id = Pn_detalle_id
			     AND itt.estado = Pv_estado
			     AND itt.tiempo IS NOT NULL 
			     AND itt.tipo = 'C'
			     ORDER BY itt.fe_creacion DESC)
		     WHERE rownum = 1;
		EXCEPTION
	          WHEN NO_DATA_FOUND THEN
	            lv_fe_creacion := NULL;
        END;
       
        IF lv_fe_creacion IS NOT NULL THEN
           Lv_camp_retorna := '{"has_fecha":"S","fe_creacion":"'||lv_fe_creacion||'","tiempo":'||ln_tiempo||'}';
        END IF;     

    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_TAREA_TIEMPO_PARCIAL',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_TAREA_TIEMPO_PARCIAL;
 
 FUNCTION F_GET_INFO_CASO(Pn_id_caso NUMBER)
     RETURN VARCHAR2
  IS
    Le_Exception               EXCEPTION;
    lv_numero_caso             VARCHAR2(80):= null;
    lv_empresa_cod             VARCHAR2(5):= null;
    Lv_camp_retorna            VARCHAR2(100) := '{"has_caso":"N","numero_caso":"","empresa_cod":""}';
    Lv_MensajeError            VARCHAR2(4000);

  BEGIN

    IF Pn_id_caso IS NOT NULL AND Pn_id_caso != 0 THEN 
		BEGIN 
		    SELECT ic.NUMERO_CASO,ic.EMPRESA_COD INTO lv_numero_caso,lv_empresa_cod
		    FROM DB_SOPORTE.INFO_CASO ic WHERE ic.ID_CASO = Pn_id_caso;
	
		      IF lv_numero_caso IS NOT NULL AND lv_empresa_cod IS NOT NULL THEN
		        Lv_camp_retorna := '{"has_caso":"S","numero_caso":"'||lv_numero_caso||'","empresa_cod":"'||lv_empresa_cod||'"}';
		      END IF;     
		EXCEPTION
          WHEN NO_DATA_FOUND THEN
            lv_numero_caso := NULL;
        END;
    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_INFO_CASO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_INFO_CASO;
 
 FUNCTION F_GET_CLIENTES_AFECTADOS(Pn_detalle_id NUMBER, Pn_id_caso NUMBER)
     RETURN VARCHAR2
  IS
    Le_Exception               EXCEPTION;
    lb_cliente                 boolean := FALSE;
    lv_cliente                 VARCHAR2(4000):=NULL;
    lv_cliente_tmp             VARCHAR2(400):=NULL;
    ln_detalle_inicial         NUMBER:=0;
    Lv_camp_retorna            VARCHAR2(4000) := '';
    Lv_MensajeError            VARCHAR2(4000);
	
   CURSOR C_PARTE_AFECTADA(Cn_detalle_id NUMBER) is
    SELECT pa.AFECTADO_NOMBRE 
 	FROM DB_SOPORTE.INFO_PARTE_AFECTADA pa, DB_SOPORTE.INFO_CRITERIO_AFECTADO ca, DB_SOPORTE.INFO_DETALLE de 
    WHERE pa.CRITERIO_AFECTADO_ID = ca.ID_CRITERIO_AFECTADO AND ca.DETALLE_ID = de.ID_DETALLE AND pa.DETALLE_ID = ca.DETALLE_ID 
	AND pa.DETALLE_ID = de.ID_DETALLE 
	AND de.ID_DETALLE =  Cn_detalle_id  
	AND lower(pa.TIPO_AFECTADO) = 'cliente';
   
   CURSOR C_INFO_PARTE_AFECTADA(Cn_detalle_id NUMBER) IS
    SELECT pa.AFECTADO_NOMBRE, pa.TIPO_AFECTADO FROM DB_SOPORTE.INFO_PARTE_AFECTADA pa WHERE pa.DETALLE_ID =  Cn_detalle_id;
   
   CURSOR C_DETALLE_INICIAL(Cn_caso_id NUMBER) IS
    SELECT  MIN(id.ID_DETALLE) as detalleInicial
	    FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS idh,DB_SOPORTE.INFO_DETALLE id 
	    WHERE idh.ID_DETALLE_HIPOTESIS = id.DETALLE_HIPOTESIS_ID 
	    AND idh.CASO_ID = Cn_caso_id;
   
  BEGIN

    IF Pn_detalle_id IS NOT NULL THEN 
	  FOR parte_afectada in C_PARTE_AFECTADA(Pn_detalle_id) LOOP
         lb_cliente := TRUE;
         IF lv_cliente IS NULL THEN 
         	lv_cliente := parte_afectada.AFECTADO_NOMBRE;
         ELSE 
         	lv_cliente := lv_cliente || ',' || parte_afectada.AFECTADO_NOMBRE;
         END IF; 
      END LOOP;
    END IF;
    IF NOT lb_cliente THEN
    	BEGIN 
	    	SELECT infoPunto.login INTO lv_cliente
	    	FROM  DB_SOPORTE.info_punto infoPunto WHERE infoPunto.id_punto =
	          (SELECT infCom.PUNTO_ID FROM DB_COMUNICACION.INFO_COMUNICACION infCom
	          	WHERE infCom.id_comunicacion = (SELECT MIN(iCom.id_comunicacion)
	            		FROM DB_COMUNICACION.INFO_COMUNICACION iCom WHERE iCom.DETALLE_ID = Pn_detalle_id 
	            		AND iCom.PUNTO_ID IS NOT NULL)
	          ) AND infoPunto.estado = 'Activo'; 
         EXCEPTION
	          WHEN NO_DATA_FOUND THEN
	            lv_cliente := NULL;
	      END;
    END IF;
    
    IF Pn_id_caso != 0 THEN
    	lb_cliente := false;
    	lv_cliente := NULL;
    	FOR info_parte_afectada in C_INFO_PARTE_AFECTADA(Pn_detalle_id) LOOP
    		IF LOWER(info_parte_afectada.TIPO_AFECTADO) = 'cliente' THEN
    			lb_cliente := TRUE;
             	lv_cliente := info_parte_afectada.AFECTADO_NOMBRE;
            ELSIF lv_cliente_tmp IS NULL THEN
             	lv_cliente_tmp := info_parte_afectada.AFECTADO_NOMBRE;
            END IF; 
    	END LOOP;
        
    	IF NOT lb_cliente  AND lv_cliente_tmp IS NOT NULL THEN 
    		lv_cliente := lv_cliente_tmp;
   		END IF;
   		IF NOT lb_cliente AND lv_cliente_tmp IS NULL THEN 
   		    BEGIN 
	   			SELECT  MIN(id.ID_DETALLE) INTO ln_detalle_inicial
			    FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS idh,DB_SOPORTE.INFO_DETALLE id 
			    WHERE idh.ID_DETALLE_HIPOTESIS = id.DETALLE_HIPOTESIS_ID 
			    AND idh.CASO_ID = Pn_id_caso;
		    EXCEPTION
	          WHEN NO_DATA_FOUND THEN
	            ln_detalle_inicial := 0;
	        END;
		    IF ln_detalle_inicial != 0 THEN 
			   FOR info_parte_afectada in C_INFO_PARTE_AFECTADA(ln_detalle_inicial) LOOP
		    	  IF LOWER(info_parte_afectada.TIPO_AFECTADO) = 'cliente' THEN
		    		lb_cliente := TRUE;
		            lv_cliente := info_parte_afectada.AFECTADO_NOMBRE;
		          ELSIF lv_cliente_tmp IS NULL THEN
		             lv_cliente_tmp := info_parte_afectada.AFECTADO_NOMBRE;
		          END IF; 
	    	   END LOOP;
	    	   IF NOT lb_cliente  AND lv_cliente_tmp IS NOT NULL THEN 
		    		lv_cliente := lv_cliente_tmp;
		   	   END IF;
		   END IF;
		  
   		END IF; 
    END IF;
   
    Lv_camp_retorna := lv_cliente;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_CLIENTES_AFECTADOS',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_CLIENTES_AFECTADOS;
 
 FUNCTION F_GET_FECHA_CREA_TAREA(Pn_detalle_id NUMBER)
     RETURN VARCHAR2
  IS
    Le_Exception               EXCEPTION;
    ln_numero_tarea_iniciada   NUMBER :=0;
    Lv_camp_retorna            VARCHAR2(200) := NULL;
    Lv_MensajeError            VARCHAR2(4000);

  BEGIN

    IF Pn_detalle_id IS NOT NULL THEN 
	    BEGIN 
	        SELECT COUNT(its.ID_SEGUIMIENTO) INTO ln_numero_tarea_iniciada FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO its
	            WHERE its.DETALLE_ID = Pn_detalle_id AND its.OBSERVACION like ('%Iniciada%') ;
	        
	        Lv_camp_retorna := DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_GET_FECHA_CREACION_TAREA(Pn_detalle_id, ln_numero_tarea_iniciada);
	    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_numero_tarea_iniciada := 0;
        END;
        
    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_FECHA_CREA_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_FECHA_CREA_TAREA;
 
 FUNCTION F_GET_FECHA_TIEMPO_PARCIAL(Pn_detalle_id NUMBER, Pv_estado VARCHAR2)
     RETURN VARCHAR2
  IS
    Le_Exception               EXCEPTION;
    lv_has_fecha_pausa		   VARCHAR2(2):= 'N';
    lv_fecha_pausa         	   VARCHAR2(50):= '';
    ln_tiempo_pausa            NUMBER := -1;
    ln_val_p_pausa             NUMBER := -1;
    lv_has_fecha_reanuda	   VARCHAR2(2):= 'N';
    lv_fecha_reanuda           VARCHAR2(50):= '';
    ln_tiempo_reanuda          NUMBER := -1;
    ln_val_r_pausa             NUMBER := -1;
    lv_has_fecha_inicia	       VARCHAR2(2):= 'N';
    lv_fecha_inicia            VARCHAR2(50):= '';
    ln_tiempo_inicia           NUMBER := -1;
    ln_val_i_pausa             NUMBER := -1;
    lv_has_fecha_detalle	   VARCHAR2(2):= 'N';
    lv_fecha_detalle           VARCHAR2(50):= '';
    Lv_camp_retorna            VARCHAR2(4000) := '{"has_pausa":"","tiempo_pausa":"","fecha_pausa":"","has_reanuda":"","tiempo_reanuda_p":"","fecha_reanuda":""'||
    											',"has_inicia":"","tiempo_inicia":"","fecha_inicia":"","has_detalle":"","fecha_detalle":""}';
    Lv_MensajeError            VARCHAR2(4000);
   
    CURSOR C_OBTIENE_TIEMPO_FECHA(Cn_detalle_id NUMBER, Cn_estado VARCHAR2) IS
    	SELECT tp.VALOR_TIEMPO,TO_CHAR(tp.FE_CREACION, 'dd-mm-yyyy hh24:mi') AS FE_CREACION,tp.VALOR_TIEMPO_PAUSA 
	      		FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL tp WHERE tp.ID_TIEMPO_PARCIAL =
		          (SELECT max(tp1.ID_TIEMPO_PARCIAL) FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL tp1
		           WHERE tp1.DETALLE_ID = Cn_detalle_id AND tp1.ESTADO = Cn_estado);

  BEGIN
	IF C_OBTIENE_TIEMPO_FECHA%ISOPEN THEN
      CLOSE C_OBTIENE_TIEMPO_FECHA;
  	END IF;
     
	OPEN C_OBTIENE_TIEMPO_FECHA(Pn_detalle_id,'Pausada');
          FETCH C_OBTIENE_TIEMPO_FECHA INTO ln_tiempo_pausa,lv_fecha_pausa,ln_val_p_pausa;
    CLOSE C_OBTIENE_TIEMPO_FECHA;
    
    IF ln_tiempo_pausa != -1 THEN 
    	lv_has_fecha_pausa := 'S';
    END IF;
   
    OPEN C_OBTIENE_TIEMPO_FECHA(Pn_detalle_id,'Reanudada');
          FETCH C_OBTIENE_TIEMPO_FECHA INTO ln_tiempo_reanuda,lv_fecha_reanuda,ln_val_r_pausa;
    CLOSE C_OBTIENE_TIEMPO_FECHA;
   	
   	IF ln_tiempo_reanuda != -1 THEN 
    	lv_has_fecha_reanuda := 'S';
    END IF;
   
    IF ln_tiempo_reanuda != -1 THEN
    	OPEN C_OBTIENE_TIEMPO_FECHA(Pn_detalle_id,'Iniciada');
          FETCH C_OBTIENE_TIEMPO_FECHA INTO ln_tiempo_inicia,lv_fecha_inicia,ln_val_i_pausa;
    	CLOSE C_OBTIENE_TIEMPO_FECHA;
    
        IF ln_tiempo_inicia != -1 THEN 
	    	lv_has_fecha_inicia := 'S';
	    END IF;
    END IF;
   
    IF ln_tiempo_inicia != -1 THEN 
    	BEGIN 
	     SELECT TO_CHAR(id.FE_CREACION, 'dd-mm-yyyy hh24:mi') INTO lv_fecha_detalle FROM DB_SOPORTE.INFO_DETALLE id WHERE id.ID_DETALLE = Pn_detalle_id;
	     lv_has_fecha_detalle := 'S';
	    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            lv_has_fecha_detalle := 'N';
        END;
    END IF;
        
	Lv_camp_retorna := '{"has_pausa":"'||lv_has_fecha_pausa||'","tiempo_pausa":"'||ln_tiempo_pausa||'","fecha_pausa":"'||lv_fecha_pausa
						||'","has_reanuda":"'||lv_has_fecha_reanuda||'","tiempo_reanuda_p":"'||ln_val_r_pausa||'","fecha_reanuda":"'||lv_fecha_reanuda
						||'","has_inicia":"'||lv_has_fecha_inicia||'","tiempo_inicia":"'||ln_tiempo_inicia||'","fecha_inicia":"'||lv_fecha_inicia
						||'","has_detalle":"'||lv_has_fecha_detalle||'","fecha_detalle":"'||lv_fecha_detalle||'"}';

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_TAREA_TIEMPO_PARCIAL',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_FECHA_TIEMPO_PARCIAL;
 
 FUNCTION F_GET_DEP_COORDINADOR(Pn_id_persona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
     RETURN NUMBER
  IS
    Le_Exception               EXCEPTION;
    ln_idDepartamento          NUMBER := NULL;
    Lv_MensajeError            VARCHAR2(4000);

  BEGIN

    IF Pn_id_persona IS NOT NULL THEN 
		BEGIN
		    SELECT IPER.DEPARTAMENTO_ID INTO ln_idDepartamento
	            FROM DB_SOPORTE.INFO_PERSONA  INFPER, DB_SOPORTE.INFO_PERSONA_EMPRESA_ROL IPER, 
	                    DB_SOPORTE.ADMI_DEPARTAMENTO ADMDP, DB_SOPORTE.INFO_OFICINA_GRUPO IPG
	            WHERE INFPER.ID_PERSONA = Pn_id_persona
	            AND IPER.PERSONA_ID = INFPER.ID_PERSONA 
	            AND IPER.ESTADO = 'Activo' 
	            AND IPER.DEPARTAMENTO_ID IS NOT NULL 
	            AND IPER.DEPARTAMENTO_ID = ADMDP.ID_DEPARTAMENTO 
	            AND IPER.OFICINA_ID  = IPG.ID_OFICINA
	            AND IPG.EMPRESA_ID = 10
	            AND ADMDP.EMPRESA_COD = 10;
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_idDepartamento := NULL;
        END;
    END IF;

    RETURN ln_idDepartamento;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_DEP_COORDINADOR',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN ln_idDepartamento;
  END F_GET_DEP_COORDINADOR;
 
 FUNCTION F_GET_ULTIMA_MILLA_SOPORTE(Pn_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
     RETURN VARCHAR2
  IS
    Le_Exception               EXCEPTION;
    Lv_camp_retorna            VARCHAR2(10):= NULL;
    Lv_MensajeError            VARCHAR2(4000);

  BEGIN

    IF Pn_id_caso IS NOT NULL THEN 
		BEGIN
		    SELECT  
                    ATM.CODIGO_TIPO_MEDIO INTO Lv_camp_retorna
                FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS DH,
                    DB_SOPORTE.INFO_DETALLE ID,
                    DB_SOPORTE.INFO_PARTE_AFECTADA IPA,
                    DB_SOPORTE.ADMI_TIPO_MEDIO ATM ,
                    DB_SOPORTE.INFO_SERVICIO_TECNICO IST
                WHERE DH.CASO_ID = Pn_id_caso
                    AND DH.ID_DETALLE_HIPOTESIS = ID.DETALLE_HIPOTESIS_ID
                    AND IPA.DETALLE_ID = ID.ID_DETALLE
                    AND IPA.TIPO_AFECTADO='Servicio'
                    AND IST.SERVICIO_ID = IPA.AFECTADO_ID
                    AND IST.ULTIMA_MILLA_ID = ATM.ID_TIPO_MEDIO 
                    AND ATM.ESTADO = 'Activo';
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Lv_camp_retorna := NULL;
        END;
    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_ULTIMA_MILLA_SOPORTE',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_ULTIMA_MILLA_SOPORTE;
 
 FUNCTION F_GET_CARACTERISTICA_DETALLE(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
  									    Pn_numero_tarea DB_SOPORTE.INFO_TAREA.NUMERO_TAREA%TYPE)
     RETURN VARCHAR2
  IS
    Le_Exception                   EXCEPTION;
    lv_desc_caracteristica         VARCHAR2(100):= 'AUTH_CREACION_KML';
    Lv_camp_retorna                VARCHAR2(2):= 'N';
    ln_count                       NUMBER :=0;
    Lv_MensajeError                VARCHAR2(4000);

  BEGIN

    IF Pn_detalle_id IS NOT NULL AND Pn_numero_tarea IS NOT NULL THEN 
		BEGIN
		    SELECT count(*) INTO ln_count FROM DB_COMERCIAL.ADMI_CARACTERISTICA ac, DB_SOPORTE.INFO_TAREA_CARACTERISTICA itc
			WHERE ac.DESCRIPCION_CARACTERISTICA = lv_desc_caracteristica AND ac.ESTADO = 'Activo'
			AND ac.ID_CARACTERISTICA = itc.CARACTERISTICA_ID 
			AND itc.DETALLE_ID = Pn_detalle_id
			AND itc.TAREA_ID  = Pn_numero_tarea;
		    
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_count := 0;
        END;
    END IF;
    
    IF ln_count > 0 THEN 
    	Lv_camp_retorna := 'S';
    END IF;
   
    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_CARACTERISTICA_DETALLE',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_CARACTERISTICA_DETALLE;
 
 FUNCTION F_GET_MOTIVO_POR_TAREA(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
     RETURN VARCHAR2
  IS
    Le_Exception                   EXCEPTION;
    Lv_camp_retorna                VARCHAR2(4000):= '{"has_motivo":"","tarea_id":-1,"nombre_tarea":"","motivo_id":""}';
    Lv_MensajeError                VARCHAR2(4000);
    ln_tarea_id                    DB_SOPORTE.ADMI_TAREA.ID_TAREA%TYPE;
    lv_nombre_tarea                DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE;
    motivo_id                      DB_SOPORTE.INFO_DETALLE_HISTORIAL.MOTIVO_ID%TYPE;
    lv_has_motivo                  VARCHAR2(2):='N';

  BEGIN
	
    IF Pn_detalle_id IS NOT NULL THEN 
		BEGIN
            SELECT idh.TAREA_ID, ata.NOMBRE_TAREA, idh.MOTIVO_ID 
                   INTO ln_tarea_id,lv_nombre_tarea,motivo_id
		      FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh,
		           DB_SOPORTE.ADMI_TAREA ata
		      WHERE idh.ID_DETALLE_HISTORIAL =
		          (SELECT max(idh1.ID_DETALLE_HISTORIAL)
		           FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1
		           WHERE idh1.DETALLE_ID = Pn_detalle_id
		             AND idh1.ACCION = 'Reasignada')
		        AND ata.ID_TAREA = idh.TAREA_ID;
		       
		      lv_has_motivo := 'S';
		        
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            lv_has_motivo := 'N';
            ln_tarea_id := -1;
            lv_nombre_tarea := '';
            motivo_id := '';
        END;
    END IF;
    
    Lv_camp_retorna := '{"has_motivo":"'||lv_has_motivo||'","tarea_id":'||ln_tarea_id
    					||',"nombre_tarea":"'||lv_nombre_tarea||'","motivo_id":"'||motivo_id||'"}';
      
    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_MOTIVO_POR_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_MOTIVO_POR_TAREA;
 
 FUNCTION F_GET_INFO_ADICIONAL_TAREA(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
  									   Pv_nombre_tarea DB_SOPORTE.INFO_TAREA.NOMBRE_TAREA%TYPE,
  									   Pv_tareas_adicional VARCHAR2)
     RETURN VARCHAR2
  IS
    Le_Exception                   EXCEPTION;
    Lv_camp_retorna                VARCHAR2(4000):= '{"is_tarea_adic":"N","has_info_adic":"N","tipo_elemento_tarea":"","nombre_elemento_tarea":""}';
    Lv_tipo_elemento_tarea         DB_SOPORTE.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE := 'N/A';
    Lv_nombre_elemento_tarea       DB_SOPORTE.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE :='N/A';
    lv_is_tarea_adic               VARCHAR2(2) := 'N';
    lv_has_info_adic               VARCHAR2(2) := 'N';
    Lv_intareas                    VARCHAR2(4000) := '';
    ln_count                       NUMBER :=0;
    Lv_MensajeError                VARCHAR2(4000);

  BEGIN

    IF Pn_detalle_id IS NOT NULL AND Pv_nombre_tarea IS NOT NULL AND  LENGTH(Pv_tareas_adicional) > 0 THEN 
		BEGIN
		  SELECT INSTR(Pv_tareas_adicional, '|'||Pv_nombre_tarea||'|') INTO ln_count FROM dual; 
		  IF ln_count > 0 THEN 	
		  	  lv_is_tarea_adic := 'S';
			  SELECT ate.NOMBRE_TIPO_ELEMENTO AS TIPO_ELEMENTO_TAREA,
					ie.NOMBRE_ELEMENTO AS NOMBRE_ELEMENTO_TAREA INTO Lv_tipo_elemento_tarea,Lv_nombre_elemento_tarea
			   FROM DB_SOPORTE.INFO_DETALLE id, DB_SOPORTE.INFO_DETALLE_TAREA_ELEMENTO dte,
							  DB_SOPORTE.INFO_ELEMENTO ie, 
							  DB_SOPORTE.ADMI_MODELO_ELEMENTO ame,
						      DB_SOPORTE.ADMI_TIPO_ELEMENTO ate WHERE id.ID_DETALLE = Pn_detalle_id
						      AND dte.DETALLE_ID = id.ID_DETALLE 
						      AND dte.ELEMENTO_ID = ie.ID_ELEMENTO
						      AND ie.MODELO_ELEMENTO_ID = ame.ID_MODELO_ELEMENTO
						      AND ame.TIPO_ELEMENTO_ID = ate.ID_TIPO_ELEMENTO
						      AND rownum = 1;
						     
				lv_has_info_adic := 'S';
				
		   END IF;
		    
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_count := 0;
        END;
    END IF;
    
    Lv_camp_retorna := '{"is_tarea_adic":"'||lv_is_tarea_adic||'","has_info_adic":"'||lv_has_info_adic
    					||'","tipo_elemento_tarea":"'||Lv_tipo_elemento_tarea||'","nombre_elemento_tarea":"'||Lv_nombre_elemento_tarea||'"}';
   
    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_INFO_ADICIONAL_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_INFO_ADICIONAL_TAREA;
 
 FUNCTION F_GET_ID_SERVICIO_VRF(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
     RETURN NUMBER
  IS
    Le_Exception                   EXCEPTION;
    Ln_idAfectado                  DB_COMERCIAL.INFO_PARTE_AFECTADA.AFECTADO_ID%TYPE := NULL;
    Lv_MensajeError                VARCHAR2(4000);

  BEGIN

    IF Pn_detalle_id IS NOT NULL  THEN 
		BEGIN
		   SELECT DISTINCT(AFECTADO_ID) AS ID_SERVICIO INTO Ln_idAfectado FROM DB_COMERCIAL.INFO_PARTE_AFECTADA 
			    WHERE DETALLE_ID in (select ID_DETALLE from DB_SOPORTE.INFO_DETALLE 
								        where DETALLE_HIPOTESIS_ID = (select DETALLE_HIPOTESIS_ID 
								        								from DB_SOPORTE.INFO_DETALLE 
								        								where ID_DETALLE = Pn_detalle_id)
								     )
				AND TIPO_AFECTADO = 'Servicio'
				AND rownum = 1;
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Ln_idAfectado := NULL;
        END;
    END IF;   
    RETURN Ln_idAfectado;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_ID_SERVICIO_VRF',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Ln_idAfectado;
  END F_GET_ID_SERVICIO_VRF;
 
 FUNCTION F_GET_INFO_TAREA_DETALE_CASO(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
	  										Pn_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
	  										Pv_cod_emp DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
	  										Pv_es_departamental VARCHAR2 )
     RETURN VARCHAR2
  IS
    Le_Exception                   EXCEPTION;
    Lv_cod_emp				       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Ln_id_persona				   DB_SOPORTE.INFO_PERSONA.ID_PERSONA%TYPE := NULL;
    Ln_servicio_id  			   NUMBER := NULL;
    Ln_tipo_medio				   DB_SOPORTE.ADMI_TIPO_MEDIO.ID_TIPO_MEDIO%TYPE :=NULL;
    Lv_camp_retorna                VARCHAR2(4000):= '{"persona_id":"","servicio_id":"","tipo_medio":""}';
    Lv_MensajeError                VARCHAR2(4000);

  BEGIN

    IF Pn_detalle_id IS NOT NULL AND Pn_id_caso IS NOT NULL THEN 
    	Lv_cod_emp := Pv_cod_emp;
    	IF Pv_cod_emp IS NULL THEN 
    		Lv_cod_emp := '18';
    	END IF;
    
		BEGIN
		  IF Pn_id_caso != 0 THEN 
		  
		  	SELECT INFPER.PERSONA_ID,INFS.ID_SERVICIO INTO Ln_id_persona, Ln_servicio_id
            FROM
                DB_SOPORTE.INFO_DETALLE_HIPOTESIS INFDH,
                DB_SOPORTE.INFO_CASO INFCA,
                DB_SOPORTE.INFO_PARTE_AFECTADA INFPA,
                DB_SOPORTE.INFO_PUNTO INFPT,
                DB_SOPORTE.INFO_DETALLE INFDT,
                DB_SOPORTE.INFO_SERVICIO INFS,
                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL INFPER
            WHERE INFCA.ID_CASO = INFDH.CASO_ID
            AND INFDH.ID_DETALLE_HIPOTESIS = INFDT.DETALLE_HIPOTESIS_ID
            AND INFDT.ID_DETALLE = INFPA.DETALLE_ID
            AND INFPA.TIPO_AFECTADO = 'Cliente'
            AND INFPA.AFECTADO_ID = INFPT.ID_PUNTO
            AND INFPER.ID_PERSONA_ROL = INFPT.PERSONA_EMPRESA_ROL_ID
            AND INFPT.ID_PUNTO = INFS.PUNTO_ID
            AND INFCA.ID_CASO = Pn_id_caso
            AND ROWNUM = 1;
           
		  ELSIF (Pv_es_departamental = 'S') THEN 
		  
		  	SELECT IPER.ID_PERSONA INTO Ln_id_persona
            FROM 
	            DB_SOPORTE.INFO_PARTE_AFECTADA IPA, 
	            DB_SOPORTE.INFO_PUNTO INFPT, 
	            DB_SOPORTE.INFO_PERSONA_EMPRESA_ROL IPEROL, 
	            DB_SOPORTE.INFO_PERSONA IPER
            WHERE IPA.DETALLE_ID = Pn_detalle_id
            AND IPA.TIPO_AFECTADO= 'Cliente'
            AND IPA.AFECTADO_NOMBRE = INFPT.LOGIN
            AND IPEROL.ID_PERSONA_ROL = INFPT.PERSONA_EMPRESA_ROL_ID
            AND IPER.ID_PERSONA = IPEROL.PERSONA_ID
            AND ROWNUM = 1;
           
		  ELSE 
		  
		  	SELECT
	                INFPE.PERSONA_ID, IDS.SERVICIO_ID INTO Ln_id_persona,Ln_servicio_id
	        FROM
                DB_SOPORTE.INFO_COMUNICACION INFCM,
                DB_SOPORTE.INFO_PUNTO IFPT,
                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL INFPE,
                DB_SOPORTE.INFO_DETALLE IFDT,
                DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
	        WHERE IFPT.ID_PUNTO = INFCM.REMITENTE_ID
            AND INFCM.DETALLE_ID = IFDT.ID_DETALLE
            AND IFDT.ID_DETALLE = Pn_detalle_id
            AND INFPE.ID_PERSONA_ROL = IFPT.PERSONA_EMPRESA_ROL_ID
            AND IDS.ID_DETALLE_SOLICITUD = IFDT.DETALLE_SOLICITUD_ID
            AND INFCM.EMPRESA_COD = Lv_cod_emp
            AND ROWNUM = 1;
           
		  END IF; 
		 
		  IF Ln_servicio_id IS NOT NULL THEN 
		  	
		  	SELECT ATM.ID_TIPO_MEDIO INTO Ln_tipo_medio
                FROM 
                DB_SOPORTE.INFO_SERVICIO_TECNICO IFST, 
                DB_SOPORTE.ADMI_TIPO_MEDIO ATM
                WHERE
                IFST.ULTIMA_MILLA_ID = ATM.ID_TIPO_MEDIO
                AND IFST.SERVICIO_ID = Ln_servicio_id
                AND ROWNUM = 1;
                
		  END IF;
		  
	    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Ln_tipo_medio := NULL;
        END;
    END IF;  
	Lv_camp_retorna := '{"persona_id":"'||Ln_id_persona||'","servicio_id":"'||Ln_servicio_id||'","tipo_medio":"'||Ln_tipo_medio||'"}';
    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_INFO_TAREA_DETALE_CASO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_INFO_TAREA_DETALE_CASO;
 
 FUNCTION F_GET_VALIDA_PROGRESO_TAREA(Pn_detalle_id DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
  										Pn_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
  										Pv_cod_emp DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  										Pv_es_departamental VARCHAR2 )
     RETURN VARCHAR2
  IS
    Le_Exception                   EXCEPTION;
    Lv_cod_emp_md				   VARCHAR2(5):='18';
    Lv_cod_emp_en				   VARCHAR2(5):='33';
    Lv_camp_retorna                VARCHAR2(4000):= '{"tiene_fibra":"","tiene_materiales":"","tiene_confirmacion_ip_serv":""}';
    lv_query_parameter             VARCHAR2(4000);
    lv_filter_progreso			   VARCHAR2(1000) :='';
    lv_query_progreso              VARCHAR2(4000);
    lv_query_progreso_tmp          VARCHAR2(4000);
    lv_ids_progreso			       VARCHAR2(1000) :='';
    Lv_MensajeError                VARCHAR2(4000);
    lv_tiene_fibra 				   VARCHAR2(200):='NO';
    lv_tiene_materiales 		   VARCHAR2(200):='NO';
    lv_tiene_confirmacion_ip_serv  VARCHAR2(200):='NO';
    ln_id_progreso_porc            NUMBER := NULL;
    lv_valor1                      VARCHAR2(4000);
    lv_valor2                      VARCHAR2(4000);
    type Lrf_parameter             is ref cursor;
    Lr_parameter                   Lrf_parameter;
    lv_param_fibra				   VARCHAR2(5000) := 'PROG_SOPORTE_MD_FIBRA,PROG_SOPORTE_TN_FIBRA,PROG_SOPORTE_EN_FIBRA,PROG_INSTALACION_MD_FIBRA,PROG_INSTALACION_EN_FIBRA,PROG_INSTALACION_TN_FIBRA';
    lv_param_materiales			   VARCHAR2(5000) := 'PROG_SOPORTE_MD_MATERIALES,PROG_SOPORTE_EN_MATERIALES,PROG_SOPORTE_TN_MATERIALES,PROG_INSTALACION_MD_MATERIALES,PROG_INSTALACION_EN_MATERIALES,PROG_INSTALACION_TN_MATERIALES';
    lv_param_ip_serv			   VARCHAR2(4000) := 'PROG_SOPORTE_TN_CONFIRMAIP';
    
    Lrf_valor   SYS_REFCURSOR;
    TYPE Lr_valor_param IS RECORD
       (
          valor1           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    	  valor2           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE
       );
    TYPE Lr_valores IS TABLE OF Lr_valor_param INDEX BY PLS_INTEGER;
    Lr_valor     Lr_valores;
    i PLS_INTEGER		:= 0;
 
  BEGIN
	  
    IF Lrf_valor%ISOPEN THEN
      CLOSE Lrf_valor;
    END IF;
    Lr_valor.DELETE();
	
    lv_query_parameter :=  'SELECT pd.VALOR1 , pd.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET pd, DB_GENERAL.ADMI_PARAMETRO_CAB pc ' ||
					     	 '	 WHERE pc.ID_PARAMETRO = pd.PARAMETRO_ID '||
					     	 q'[	 AND pc.NOMBRE_PARAMETRO = 'IDS_PROGRESOS_TAREAS' ]'||
					      	 q'[	 AND pc.estado= 'Activo' AND pd.estado = 'Activo' ]';
	
    lv_query_progreso := 'SELECT max(IPP.ID_PROGRESO_PORCENTAJE) FROM  DB_SOPORTE.INFO_PROGRESO_PORCENTAJE IPP '||
			              q'[  WHERE IPP.EMPRESA_ID = :cod_emp AND ]'||
			              '      IPP.ID_PROGRESO_PORCENTAJE = ( '||
			              '      SELECT PROGRESO_PORCENTAJE_ID FROM DB_SOPORTE.INFO_PROGRESO_TAREA IPT '||
			              '     WHERE IPT.DETALLE_ID = :ln_detalle';				      	
		      	
    IF Pn_detalle_id IS NOT NULL THEN 
    	BEGIN
		  
		  IF Pn_id_caso != 0 OR Pv_es_departamental = 'S' THEN 
		  	IF Pv_cod_emp = Lv_cod_emp_md THEN 
		  	    lv_filter_progreso  := q'[	 AND pd.VALOR1 IN ('PROG_SOPORTE_MD_FIBRA','PROG_SOPORTE_MD_MATERIALES') ]';
		  	    lv_tiene_confirmacion_ip_serv  :='NO TIENE IDPROGRESO A BUSCAR';
        ELSIF Pv_cod_emp = Lv_cod_emp_en THEN 
		  	    lv_filter_progreso  := q'[	 AND pd.VALOR1 IN ('PROG_SOPORTE_EN_FIBRA','PROG_SOPORTE_EN_MATERIALES') ]';
		  	    lv_tiene_confirmacion_ip_serv  :='NO TIENE IDPROGRESO A BUSCAR';
		  	ELSE 
		  	    lv_filter_progreso  := q'[	 AND pd.VALOR1 IN ('PROG_SOPORTE_TN_FIBRA','PROG_SOPORTE_TN_MATERIALES','PROG_SOPORTE_TN_CONFIRMAIP') ]';	
		  	END IF;
		  ELSE 
		  	IF Pv_cod_emp = Lv_cod_emp_md THEN 
		  	    lv_filter_progreso  := q'[	 AND pd.VALOR1 IN ('PROG_INSTALACION_MD_FIBRA','PROG_INSTALACION_MD_MATERIALES') ]';
        ELSIF Pv_cod_emp = Lv_cod_emp_en THEN 
		  	    lv_filter_progreso  := q'[	 AND pd.VALOR1 IN ('PROG_INSTALACION_EN_FIBRA','PROG_INSTALACION_EN_MATERIALES') ]';		
		  	ELSE 
		  	    lv_filter_progreso  := q'[	 AND pd.VALOR1 IN ('PROG_INSTALACION_TN_FIBRA','PROG_INSTALACION_TN_MATERIALES') ]'; 	
		  	END IF;
		  	lv_tiene_confirmacion_ip_serv  :='NO TIENE IDPROGRESO A BUSCAR';
		  END IF;
		  
		  IF lv_filter_progreso IS NOT NULL THEN 
		     lv_query_parameter := lv_query_parameter||lv_filter_progreso; 
	         OPEN Lrf_valor FOR lv_query_parameter;
	         LOOP
	           FETCH Lrf_valor BULK COLLECT INTO  Lr_valor LIMIT 50;
			 
	           EXIT WHEN Lr_valor.count=0;
        	   i := Lr_valor.FIRST;
        	   WHILE (i IS NOT NULL) 
	           LOOP
	              lv_valor1 := Lr_valor(i).valor1;
	              lv_valor2 := Lr_valor(i).valor2;
	              ln_id_progreso_porc := NULL; 
	              lv_query_progreso_tmp := lv_query_progreso|| ' AND IPT.PROGRESO_PORCENTAJE_ID IN ('||lv_valor2||'))';
	              execute immediate lv_query_progreso_tmp into ln_id_progreso_porc USING Pv_cod_emp,Pn_detalle_id;
	           
	              IF INSTR(lv_param_fibra, lv_valor1, 1) != 0 AND ln_id_progreso_porc IS NOT NULL  THEN 
	                lv_tiene_fibra := 'SI';
	              ELSIF INSTR(lv_param_materiales, lv_valor1, 1) != 0 AND ln_id_progreso_porc IS NOT NULL  THEN 
	                lv_tiene_materiales := 'SI';
	              ELSIF INSTR(lv_param_ip_serv, lv_valor1, 1) != 0 AND ln_id_progreso_porc IS NOT NULL  THEN 
	                lv_tiene_confirmacion_ip_serv := 'SI';
	              END IF;
	              i := Lr_valor.NEXT(i);
	           END LOOP;
	         END LOOP;
	         CLOSE Lrf_valor;
  		  ELSE 
  		  	lv_tiene_fibra 				   :='NO TIENE IDPROGRESO A BUSCAR';
		    lv_tiene_materiales 		   :='NO TIENE IDPROGRESO A BUSCAR';
		    lv_tiene_confirmacion_ip_serv  :='NO TIENE IDPROGRESO A BUSCAR';
  		  END IF; 
    
	    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            ln_id_progreso_porc := NULL;
        END;
    ELSE 
    	lv_tiene_fibra 				   :='NO TIENE IDDETALLE';
		lv_tiene_materiales 		   :='NO TIENE IDDETALLE';
		lv_tiene_confirmacion_ip_serv  :='NO TIENE IDDETALLE';	
    END IF; 
    
    Lv_camp_retorna  := '{"tiene_fibra":"'||lv_tiene_fibra||'","tiene_materiales":"'||lv_tiene_materiales||'","tiene_confirmacion_ip_serv":"'||lv_tiene_confirmacion_ip_serv||'"}';
    
    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_VALIDA_PROGRESO_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_VALIDA_PROGRESO_TAREA;
 
  FUNCTION F_GET_TOTAL_TAREA_PERFIL(Pv_FechaDefecto VARCHAR2,
									Pv_PersonaEmpresaRol VARCHAR2)
     RETURN NUMBER
  IS
    Le_Exception                   EXCEPTION;
    Lv_MensajeError                VARCHAR2(4000);
    Lv_select					   VARCHAR2(4000);
    Lv_from						   VARCHAR2(4000);
    Lv_where					   VARCHAR2(4000);
    Lv_query					   VARCHAR2(4000);
    Lv_Estado                      VARCHAR2(60) := '''Finalizada'','||'''Cancelada'','||'''Rechazada'','||'''Anulada''';
    Ln_total                       NUMBER := -1;
    Lv_FechaDefecto				   VARCHAR2(4000);

  BEGIN
	
	Lv_FechaDefecto := Pv_FechaDefecto; 
	Lv_select := 'SELECT COUNT(ITA.DETALLE_ID)';  
    Lv_from   := ' FROM DB_SOPORTE.INFO_TAREA ITA ';
    Lv_where  := ' WHERE 1 = 1 ';
	 

    Lv_where := Lv_where ||' AND ITA.PERSONA_EMPRESA_ROL_ID IN (:paramPersonaEmpresaRol) '||
                                        'AND ITA.ESTADO NOT IN (:paramEstadoHistorial)';

    Lv_where := REPLACE(Lv_where,':paramPersonaEmpresaRol',Pv_PersonaEmpresaRol);
    Lv_where := REPLACE(Lv_where,':paramEstadoHistorial',Lv_Estado);
        
    Lv_FechaDefecto := TO_CHAR(TO_dATE(Lv_FechaDefecto,'RRRR-MM-DD'),'RRRR-MM-DD');
  	Lv_where := Lv_where ||' AND TO_CHAR(ITA.FE_CREACION_DETALLE,''RRRR-MM-DD'') >= :fechaDefault';
  	Lv_where := REPLACE(Lv_where,':fechaDefault',''''||Lv_FechaDefecto||'''');
  	Lv_where := Lv_where ||' AND NOT EXISTS
                                              (SELECT IID.COMUNICACION_ID FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID 
                                                  WHERE IID.COMUNICACION_ID = ITA.NUMERO_TAREA) ' ;
    Lv_query  := Lv_select||Lv_from||Lv_where;
    
    EXECUTE IMMEDIATE Lv_query INTO Ln_Total;                                                            
                                                                 
    RETURN Ln_Total;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_ADICIONAL_TAREA.F_GET_TOTAL_TAREA_PERFIL',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Ln_Total;
  END F_GET_TOTAL_TAREA_PERFIL;

END SPKG_INFO_ADICIONAL_TAREA;
/