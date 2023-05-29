CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_NOTIFICACIONES_PUSH
AS

  /**
   * Documentación para el procedimiento 'P_GRABAR_INFO_NOTIFICACION'.
   *
   * Método encargado de guradar informacion necesaria para notificaciones push 
   * por casos backbone de fallas masivas
   *
   * @param P_CASO_ID      IN  NUMBER Recibe codigo del caso.
   * @param P_COD_EMPRESA  IN  NUMBER Recibe codigo de la empresa.
   * @param P_TIPO_PROCESO IN  VARCHAR2 Recibe tipo de proceso.
   * @param P_USR_CREACION IN  VARCHAR2 Recibe usuario de creacion.
   * @param p_IP_CREACION  IN  VARCHAR2 Recibe ip creacion.
   * @param P_ERROR        OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param P_COD_ERROR    OUT NUMBER Retorna codigo de error
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 22-04-2022
   */
  PROCEDURE P_GRABAR_INFO_NOTIFICACION(P_CASO_ID      IN NUMBER,
                                       P_COD_EMPRESA  IN NUMBER,
                                       P_TIPO_PROCESO IN VARCHAR2,
                                       P_USR_CREACION IN VARCHAR2,
                                       p_IP_CREACION  IN VARCHAR2, 
                                       P_ERROR        OUT VARCHAR2,
                                       P_COD_ERROR    OUT NUMBER);
END INKG_NOTIFICACIONES_PUSH;
/

CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_NOTIFICACIONES_PUSH
AS

	PROCEDURE P_GRABAR_INFO_NOTIFICACION(P_CASO_ID      IN NUMBER,
	                                     P_COD_EMPRESA  IN NUMBER,
	                                     P_TIPO_PROCESO IN VARCHAR2,
	                                     P_USR_CREACION IN VARCHAR2,
	                                     p_IP_CREACION  IN VARCHAR2, 
	                                     P_ERROR        OUT VARCHAR2,
	                                     P_COD_ERROR    OUT NUMBER) AS

	  CURSOR C_GetObtenerClientesAfectado(Cn_IdCaso NUMBER) IS
		 SELECT p.ID_PUNTO,p.LOGIN  ,p.PERSONA_EMPRESA_ROL_ID 
		   FROM DB_SOPORTE.INFO_CASO c, 
				DB_SOPORTE.INFO_DETALLE_HIPOTESIS dh, 
				DB_SOPORTE.INFO_DETALLE d,
				DB_SOPORTE.INFO_PARTE_AFECTADA pa,
				DB_COMERCIAL.INFO_PUNTO p
		  WHERE c.ID_CASO = dh.CASO_ID
		    AND dh.ID_DETALLE_HIPOTESIS = d.DETALLE_HIPOTESIS_ID 
		    AND d.ID_DETALLE = pa.DETALLE_ID 
		    AND p.LOGIN = pa.AFECTADO_NOMBRE
		    AND c.ID_CASO  = Cn_IdCaso
			AND P.ESTADO = 'Activo'
		    AND pa.TIPO_AFECTADO ='Cliente';	
		   
		Ln_seq_cab NUMBER:=0;
	    Ln_seq_det NUMBER:=0;
	    Ln_cant    NUMBER:=0;
	    Ln_Error   NUMBER;
	    Lv_Error   VARCHAR2(250);
	    Le_error   EXCEPTION;
	 BEGIN
		 BEGIN
	 	   Ln_seq_cab := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
	 	 
	 	   INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB(ID_PROCESO_MASIVO_CAB,
	 	                                                          TIPO_PROCESO,
	 	                                                          EMPRESA_ID,
	 	                                                          ESTADO,
	 	                                                          FE_CREACION,
	 	                                                          USR_CREACION,
	 	                                                          IP_CREACION,
	 	                                                          CASO_ID)
	 	    VALUES(Ln_seq_cab,
	 	           P_TIPO_PROCESO,
	 	           P_COD_EMPRESA,
	 	           'Pendiente',
	 	           SYSDATE,
	 	           P_USR_CREACION,
	 	           p_IP_CREACION,
	 	           P_CASO_ID);
 	    EXCEPTION 	     
 	     WHEN OTHERS THEN
 	      Lv_Error := 'Error al crear cabecera para caso: ' || P_CASO_ID || ', Proceso:'|| 
 	                   P_TIPO_PROCESO || ': - '||substr(SQLERRM,1,200);
 	      Ln_Error := -1;
 	      Raise Le_error;
 	    END;
 	   
 	   
 	     
 	    FOR J IN C_GetObtenerClientesAfectado(P_CASO_ID) LOOP
	        BEGIN
		      Ln_seq_det := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
	 	      INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET(ID_PROCESO_MASIVO_DET,
	 	                                                             PROCESO_MASIVO_CAB_ID,
	 	                                                             PUNTO_ID,
	 	                                                             LOGIN, 
	 	                                                             ESTADO,
	 	                                                             FE_CREACION,
	 	                                                             USR_CREACION,
	 	                                                             IP_CREACION,
	 	                                                             PERSONA_EMPRESA_ROL_ID)
	 	      VALUES(Ln_seq_det,
	 	             Ln_seq_cab,
	 	             j.ID_PUNTO,
	 	             j.LOGIN,
	 	             'Pendiente',
	 	             SYSDATE,
	 	             P_USR_CREACION,
	 	             p_IP_CREACION,
	 	             j.PERSONA_EMPRESA_ROL_ID
	 	            );	 	      
	 	      
		    EXCEPTION 	     
	 	     WHEN OTHERS THEN
			      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
			                                            'CMKG_NOTIFICACIONES_PUSH.P_GRABAR_INFO_NOTIFICACION', 
			                                            'Error al crear detalle para caso: ' || P_CASO_ID || ', Proceso:'|| 
			 	                                         P_TIPO_PROCESO || ',Cliente:'|| j.LOGIN || ', - :'|| substr(SQLERRM,1,200),
			                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
			                                            SYSDATE, 
			                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') 
			                                           );	       
		    END;
		    Ln_seq_det:= 0;
		    Ln_cant := Ln_cant + 1;
		END LOOP;
	  
	   IF Ln_cant <=0 THEN
	    Lv_Error := 'No se encontraron clientes afectados';
	    Ln_error := -1;
	    Raise Le_error;
	   END IF;
	  
	  COMMIT;
	  P_ERROR     := 'Ok';
      P_COD_ERROR := 0; 
 	    
	EXCEPTION 
	 WHEN Le_error THEN     
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'CMKG_NOTIFICACIONES_PUSH.P_GRABAR_INFO_NOTIFICACION', 
                                            Lv_Error,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') 
                                           );
      ROLLBACK;
      P_ERROR     := Lv_Error;
      P_COD_ERROR := Ln_Error; 
     
	 WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'CMKG_NOTIFICACIONES_PUSH.P_GRABAR_INFO_NOTIFICACION', 
                                            'Error general para caso: ' || P_CASO_ID || ', Proceso:'|| 
 	                                        P_TIPO_PROCESO || ': - '||substr(SQLERRM,1,200),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') 
                                           );
      ROLLBACK;
      P_ERROR     := 'Error general: '||substr(SQLERRM,1,200);
      P_COD_ERROR := -1; 
	END P_GRABAR_INFO_NOTIFICACION; 

END INKG_NOTIFICACIONES_PUSH;
/
