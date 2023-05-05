CREATE EDITIONABLE PACKAGE                      REGULARIZACION_IP_OTN AS 

  /* Funcion para validar las cadenas de texto */ 
  FUNCTION valida_cadena(pv_cadena_parametros IN VARCHAR2,
                         pv_separador         IN VARCHAR2) RETURN VARCHAR2 ;

  /* Funcion para obtener el valor de que se encuentra separados en tre PIPES */
  FUNCTION OBTENER_CAMPO_TRAMA(pv_cadena_parametros IN VARCHAR2,
                               pv_separador         IN VARCHAR2 DEFAULT '|',
                               pn_pos_campo         IN NUMBER) RETURN VARCHAR2 ;

  /**
 * Documentacion para el job JOB_MIGRACION_MASIVA_IPMP
 *
 * Procedimiento para ingresar IPs y rutas estaticas para los servicio clear channel
 *
 * @author Brenyx Giraldo <agiraldo@telconet.ec>
 * @version 1.0 30-06-2022
 */
   PROCEDURE P_REGULARIZACION_IP_CSV(
	    Pv_FileName    IN VARCHAR2,
	    Pv_Mensaje   OUT VARCHAR2);
      

END REGULARIZACION_IP_OTN;
/

CREATE EDITIONABLE PACKAGE BODY                     REGULARIZACION_IP_OTN AS


/* Valida si existe el separado al inicio y fin de la trama */
  FUNCTION valida_cadena(pv_cadena_parametros IN VARCHAR2,
                         pv_separador         IN VARCHAR2) RETURN VARCHAR2 IS
    
    lv_cadena_parametro VARCHAR2(4000);
  BEGIN
    
    -- Si existen espacios en blanco al inicio y al final los quita.
    lv_cadena_parametro := TRIM(pv_cadena_parametros);
    
    -- Verifica si al inicio de la cadena existe el separador, por verdadero lo quita.
    IF SUBSTR(lv_cadena_parametro,0,1) = pv_separador THEN
      lv_cadena_parametro := SUBSTR(lv_cadena_parametro,2);
    END IF;
    
    -- Verifica si al final de la cadena existe el separador.
    IF SUBSTR(lv_cadena_parametro,-1) <> pv_separador THEN
      lv_cadena_parametro := lv_cadena_parametro || pv_separador;
    END IF;
    
    RETURN lv_cadena_parametro;
  EXCEPTION
    WHEN OTHERS THEN
      lv_cadena_parametro:= pv_cadena_parametros;
      RETURN lv_cadena_parametro;
  END valida_cadena;
  
  FUNCTION OBTENER_CAMPO_TRAMA(pv_cadena_parametros IN VARCHAR2,
                               pv_separador         IN VARCHAR2 DEFAULT '|',
                               pn_pos_campo         IN NUMBER) RETURN VARCHAR2 IS
    
    lv_cadena_parametros VARCHAR2(4000);
    lv_campo_cadena   VARCHAR2(4000);
    ln_pos_pipe_desde NUMBER := 0;
    ln_pos_pipe_hasta NUMBER;
  BEGIN
    lv_cadena_parametros := valida_cadena(pv_cadena_parametros, pv_separador);
    IF pn_pos_campo > 1 THEN
      ln_pos_pipe_desde := instr(lv_cadena_parametros,
                                 pv_separador,
                                 1,
                                 pn_pos_campo - 1);
    END IF;
    ln_pos_pipe_hasta := instr(lv_cadena_parametros,
                               pv_separador,
                               1,
                               pn_pos_campo);
    lv_campo_cadena   := substr(lv_cadena_parametros,
                                ln_pos_pipe_desde + 1,
                                ln_pos_pipe_hasta - ln_pos_pipe_desde - 1);
    RETURN lv_campo_cadena;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END OBTENER_CAMPO_TRAMA;





  PROCEDURE P_REGULARIZACION_IP_CSV(
	    Pv_FileName    IN VARCHAR2,
	    Pv_Mensaje   OUT VARCHAR2) AS
      
       Infile                         UTL_FILE.FILE_TYPE;
       Linebuf                        VARCHAR2 (4000);
       Lv_Directorio                  VARCHAR2(50) := 'RESPSOLARIS';
       Lv_EstadoEliminado             VARCHAR2(50) := 'Eliminado';
       
       --DATOS DE LA SUBRED    

       lv_SubRed                      VARCHAR2(50);
       Lv_Mascara                     VARCHAR2(50);
       Lv_Gateway                     VARCHAR2(50);
       Lv_Ip_Inicial                  VARCHAR2(50);
       Lv_Ip_Final                    VARCHAR2(50);
       Lv_Tipo                        VARCHAR2(50);
       Lv_Uso                         VARCHAR2(50);
       Lv_Ip                          VARCHAR2(50);
       Lv_Login                       VARCHAR2(100);
       Lv_Desc_Factura                VARCHAR2(200);
       Lv_Vlan                        VARCHAR2(20);
       Ln_No_Backup                   NUMBER;
       Ln_Id_Servicio                 NUMBER;
       
       
       ln_Id_SubRed                   NUMBER;
       ln_Id_Elemento                 NUMBER;
       Ln_Ip_Servicio                 NUMBER;
       Ln_IdIpResp                    NUMBER;

       Lv_login_Wan                   VARCHAR2(200);
      
       TYPE Fieldvalue IS TABLE OF VARCHAR2 (100)
                                    INDEX BY BINARY_INTEGER;

       Field_Position                 Fieldvalue;

       Total_Rec_Count                NUMBER := 0;
       Total_Rec_Processed            NUMBER := 0;
       Contador_Backup                NUMBER := 0;
       Contador_ServClear             NUMBER := 0;
       Contador_Servicio              NUMBER := 0;
       Lv_Nombre_Producto             VARCHAR2(200)  := 'CLEAR CHANNEL PUNTO A PUNTO';
            
          
       CURSOR C_SubRed_Exist (Cv_SubRed IN VARCHAR2, Cv_EstadoEliminado IN VARCHAR2) IS     
       SELECT ISR.ID_SUBRED, ISR.ELEMENTO_ID
       FROM DB_INFRAESTRUCTURA.INFO_SUBRED ISR
       WHERE ISR.ESTADO != Cv_EstadoEliminado 
       AND ISR.SUBRED = Cv_SubRed ;       
       
       
       CURSOR C_Except_Serv_Back ( Cv_Login IN VARCHAR2 , Cv_Nombre_Producto IN VARCHAR2) IS
       SELECT COUNT (ISR.ID_SERVICIO)  FROM DB_COMERCIAL.INFO_SERVICIO ISR
       INNER JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO = ISR.PUNTO_ID
       INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO = ISR.producto_id
       WHERE ISR.estado = 'Activo' AND AP.DESCRIPCION_PRODUCTO = Cv_Nombre_Producto 
        AND INSTR(UPPER(ISR.DESCRIPCION_PRESENTA_FACTURA),'BACKUP') > 0 AND IP.LOGIN = Cv_Login;
       
       CURSOR C_Except_Ip_Serv ( Cv_Login IN VARCHAR2 , Cv_Nombre_Producto IN VARCHAR2) IS
       SELECT COUNT (ISR.ID_SERVICIO)  FROM DB_COMERCIAL.INFO_SERVICIO ISR
       INNER JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO = ISR.PUNTO_ID
       INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO = ISR.producto_id
       WHERE ISR.estado = 'Activo' AND AP.DESCRIPCION_PRODUCTO = Cv_Nombre_Producto  
       AND INSTR(UPPER(ISR.DESCRIPCION_PRESENTA_FACTURA),'BACKUP') = 0 AND IP.LOGIN = Cv_Login;
       
       CURSOR C_Existe_Serv ( Cv_Login IN VARCHAR2 , Cv_Nombre_Producto IN VARCHAR2) IS
       SELECT COUNT (ISR.ID_SERVICIO)  FROM DB_COMERCIAL.INFO_SERVICIO ISR
       INNER JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO = ISR.PUNTO_ID
       INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO = ISR.producto_id
       WHERE ISR.estado = 'Activo' AND AP.DESCRIPCION_PRODUCTO = Cv_Nombre_Producto 
       AND IP.LOGIN = Cv_Login;
       
       CURSOR C_Find_Serv (Cv_Login IN VARCHAR2 , Cv_Nombre_Producto IN VARCHAR2) IS
       SELECT ISR.ID_SERVICIO, ISR.DESCRIPCION_PRESENTA_FACTURA  FROM DB_COMERCIAL.INFO_SERVICIO ISR
       INNER JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO = ISR.PUNTO_ID
       INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ON AP.ID_PRODUCTO = ISR.producto_id
       WHERE ISR.estado = 'Activo' AND AP.DESCRIPCION_PRODUCTO = Cv_Nombre_Producto 
       AND INSTR(UPPER(ISR.DESCRIPCION_PRESENTA_FACTURA),'BACKUP') = 0 AND IP.LOGIN = Cv_Login;
       
       CURSOR C_Fnd_Ip_serv (Cv_Ip IN VARCHAR2, Cn_Id_Servicio IN NUMBER) IS
       SELECT INFP.ID_IP FROM DB_INFRAESTRUCTURA.INFO_IP INFP
       INNER JOIN DB_COMERCIAL.INFO_SERVICIO  ISR ON ISR.ID_SERVICIO = INFP.SERVICIO_ID
       WHERE INFP.ESTADO = 'Activo' AND ISR.estado = 'Activo' 
       AND INFP.IP = Cv_Ip AND ISR.ID_SERVICIO = Cn_Id_Servicio;
       
       CURSOR C_Fnd_Ip_Login (Cn_Id_Ip IN NUMBER) IS
       SELECT IFP.LOGIN from DB_INFRAESTRUCTURA.INFO_IP IP
       INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISER ON ISER.ID_SERVICIO = IP.SERVICIO_ID
       INNER JOIN DB_COMERCIAL.INFO_PUNTO IFP ON IFP.ID_PUNTO = ISER.PUNTO_ID
       WHERE IP.ID_IP = Cn_Id_Ip;
       

       
      
  BEGIN
  
           
              Infile := UTL_FILE.FOPEN(Lv_Directorio, Pv_FileName , 'R');
              
              LOOP 
               UTL_FILE.Get_Line (Infile, Linebuf);
               Total_Rec_Count:=Total_Rec_Count + 1;
              
                IF Total_Rec_Count > 1
                THEN
                ln_Id_SubRed := NULL;
                ln_Id_Elemento := NULL;
                Lv_Ip := NULL;
                lv_SubRed := NULL;
                Lv_Login := NULL;
                Lv_Uso := NULL;
                Lv_Vlan := NULL;
                Contador_Servicio := NULL;
                Contador_Backup:= NULL;
                Contador_ServClear:= NULL;
                
              
                
        
                lv_SubRed := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',1));
                Lv_Mascara := TRIM( OBTENER_CAMPO_TRAMA(Linebuf,'|',2));
                Lv_Gateway := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',3));
                Lv_Ip_Inicial := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',4));
                Lv_Ip_Final := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',5));
                Lv_Tipo := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',6));
                Lv_Uso := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',11));
                Lv_Ip := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',7));
                Lv_Login := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',8));
                Lv_Vlan := TRIM(OBTENER_CAMPO_TRAMA(Linebuf,'|',12));
               
                IF Lv_Ip = 'NA' 
                THEN 
                Lv_Ip := Lv_Ip_Inicial;
                END IF;  
          
                OPEN C_SubRed_Exist(lv_SubRed, Lv_EstadoEliminado );   
                FETCH C_SubRed_Exist INTO ln_Id_SubRed,ln_Id_Elemento;   
                CLOSE C_SubRed_Exist; 
           
            
           
              
           
           
              IF lv_SubRed != 'NA' 
              THEN
              IF ln_Id_SubRed IS NOT NULL 
              THEN 
              IF ln_Id_Elemento IS NOT NULL
              THEN
               
                    OPEN C_Existe_Serv (Lv_Login, Lv_Nombre_Producto);
                    FETCH C_Existe_Serv INTO Contador_Servicio;
                    CLOSE C_Existe_Serv;
                    
          
                 
                 IF Contador_Servicio > 0
                 THEN
                 
                  
                   OPEN C_Except_Serv_Back (Lv_Login ,Lv_Nombre_Producto);
                   FETCH C_Except_Serv_Back INTO Contador_Backup;
                   CLOSE C_Except_Serv_Back;
                  
                   OPEN C_Except_Ip_Serv (Lv_Login , Lv_Nombre_Producto);
                   FETCH C_Except_Ip_Serv INTO Contador_ServClear;
                   CLOSE C_Except_Ip_Serv;
                   
                   IF Contador_Backup < 2 OR Contador_ServClear < 2
                   THEN
           
              FOR servicio in C_Find_Serv (Lv_Login, Lv_Nombre_Producto)
              LOOP 
              
              
              Ln_Id_Servicio := servicio.ID_SERVICIO;
              Lv_Desc_Factura :=servicio.DESCRIPCION_PRESENTA_FACTURA;
              
              Ln_No_Backup := INSTR(UPPER(Lv_Desc_Factura),'BACKUP');
              
              IF Ln_No_Backup = 0
              THEN
              Ln_Ip_Servicio := NULL;
           
              OPEN C_Fnd_Ip_serv (Lv_Ip,Ln_Id_Servicio);
              FETCH C_Fnd_Ip_serv INTO Ln_Ip_Servicio;
              CLOSE C_Fnd_Ip_serv;
              

            
              IF Ln_Ip_Servicio IS NULL 
              THEN
               IF  UPPER (Lv_Tipo) ='WAN'
               THEN
                    Ln_IdIpResp := NULL;
                    Insert into DB_INFRAESTRUCTURA.INFO_IP (ID_IP,ELEMENTO_ID,IP,USR_CREACION,FE_CREACION,IP_CREACION,ESTADO,
                    SUBRED_ID,MASCARA,GATEWAY,TIPO_IP,VERSION_IP,SERVICIO_ID,INTERFACE_ELEMENTO_ID,REF_IP_ID) 
                    values (DB_INFRAESTRUCTURA.SEQ_INFO_IP.NEXTVAL,null ,Lv_Ip ,'agiraldo' ,sysdate ,
                    '127.0.0.1','Activo' ,ln_Id_SubRed ,Lv_Mascara ,Lv_Gateway,Lv_Tipo,'IPV4' ,Ln_Id_Servicio ,null,null)
                    RETURNING ID_IP INTO Ln_IdIpResp;
                    
                    INSERT
                    INTO DB_GENERAL.ADMI_PARAMETRO_DET (id_parametro_det, parametro_id, descripcion, valor1, valor2, valor3,valor4,estado, usr_creacion,
                                                         fe_creacion,ip_creacion,empresa_cod  )
                    VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                    where NOMBRE_PARAMETRO  = 'REGULARIZACION IP OTN' AND  MODULO ='TECNICO' AND PROCESO ='REGULARIZACION'),
                        'VLAN SERVICIO CLEAR CHANNEL',Ln_Id_Servicio,Lv_Vlan,'0', '0','Activo','agiraldo', SYSDATE, '127.0.0.1','10' );
                     
                    total_rec_processed:=total_rec_processed + 1;
                ELSE
                     Lv_login_Wan := NULL;
                     OPEN C_Fnd_Ip_Login (Ln_IdIpResp);
                     FETCH C_Fnd_Ip_Login INTO Lv_login_Wan;
                     CLOSE C_Fnd_Ip_Login;
                  
                IF  Lv_login_Wan = Lv_Login
                  THEN
                    INSERT INTO DB_INFRAESTRUCTURA.INFO_RUTA_ELEMENTO (ID_RUTA_ELEMENTO,SERVICIO_ID,ELEMENTO_ID,SUBRED_ID,IP_ID,NOMBRE,
                    ESTADO, RED_LAN,MASCARA_RED_LAN, DISTANCIA_ADMIN,USR_CREACION, FE_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_CREACION,TIPO) 
                    VALUES (DB_INFRAESTRUCTURA.SEQ_INFO_RUTA_ELEMENTO.NEXTVAL,Ln_Id_Servicio ,ln_Id_Elemento ,ln_Id_SubRed ,Ln_IdIpResp , 
                    'Regularizacion OTN', 'Activo', null,null,1,'agiraldo',sysdate,null,null,'127.0.0.1','Ruta Clear Channel');
  
               ELSE 
               
               DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'REGULARIZACION_IP_OTN', 
                                            'P_REGULARIZACION_IP_CSV', 
                                             'NO SE REGISTRO LA RUTA DE LA SUBRED:  '|| lv_SubRed ||' Por que no se lo relaciono con el login:   '|| Lv_Login,
                                            'agiraldo',
                                             SYSDATE, 
                                            '127.0.0.1');

                  END IF;   
                END IF;
    
                     
              ELSE
               DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'REGULARIZACION_IP_OTN', 
                                            'P_REGULARIZACION_IP_CSV', 
                                            'LA IP YA TIENE REGISTRADO UN SERVICIO CLEAR CHANNEL -> IP: '|| Lv_Ip ||'  Id_Serv:  '|| Ln_Id_Servicio,
                                            'agiraldo',
                                             SYSDATE, 
                                            '127.0.0.1');

              
              END IF;              
              END IF;
              
              END LOOP;
                   
                  ELSE 
                            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'REGULARIZACION_IP_OTN', 
                            'P_REGULARIZACION_IP_CSV', 
                            'NO SE REGISTRO LA IP: '|| Lv_Ip ||'  EL LOGIN TIENE MAS DE UN SERVICIO CLEAR CHANEL: '|| Lv_Login,
                            'agiraldo',
                            SYSDATE, 
                            '127.0.0.1');
               
                    
                 END IF;
                 ELSE
                 
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'REGULARIZACION_IP_OTN', 
                                           'P_REGULARIZACION_IP_CSV', 
                                           'NO SE REGISTRO LA IP: '|| Lv_Ip ||'  NO EXISTE UN SERVICIO CLEAR CHANNEL PARA EL LOGIN: '|| Lv_Login,
                                           'agiraldo',
                                            SYSDATE, 
                                           '127.0.0.1');
                 
                 END IF;
             
               ELSE
                 
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'REGULARIZACION_IP_OTN', 
                                           'P_REGULARIZACION_IP_CSV', 
                                           'NO SE REGISTRO LA RUTA DE LA SUBRED: '|| lv_SubRed ||' LA SUBRED NO TIENE ASIGANDO UN ELEMENTO ID '|| Lv_Login,
                                           'agiraldo',
                                            SYSDATE, 
                                           '127.0.0.1');
                 
               END IF; 
              
              ELSE 
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'REGULARIZACION_IP_OTN', 
                                           'P_REGULARIZACION_IP_CSV', 
                                           'NO EXISTE LA SUBRED: '|| lv_SubRed || '   PARA LA IP: '|| Lv_Ip ,
                                           'agiraldo',
                                            SYSDATE, 
                                           '127.0.0.1');
                 
              END IF;
              END IF;
              END IF;
              END LOOP;
              
              IF UTL_FILE.is_open (infile)
            THEN
               
                UTL_FILE.Fclose (Infile);
            END IF;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                IF UTL_FILE.is_open (infile)
                THEN
                    UTL_FILE.Fclose (Infile);
                END IF;
            IF total_rec_processed > 0
            THEN
               COMMIT;
            END IF;
            WHEN OTHERS
            THEN
                IF UTL_FILE.is_open (infile)
                THEN
                    UTL_FILE.Fclose (Infile);
                END IF;

                Pv_Mensaje := Pv_Mensaje || ' ' || SQLERRM;
              
               
    

  
  END P_REGULARIZACION_IP_CSV;
  


END REGULARIZACION_IP_OTN;
/
