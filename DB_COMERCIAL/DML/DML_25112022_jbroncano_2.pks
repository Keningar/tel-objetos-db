 /**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 *  Ingreso de caracteristica VELOCIDAD COMERCIAL
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 18-11-2022 - Versión Inicial.
 */
DECLARE
        Lv_DescripCaracteristicaNa VARCHAR2(400) := 'CAPACIDAD1';
        Lv_DescripCaracteristicaIn VARCHAR2(400) := 'CAPACIDAD2';
        Lv_NombreParametroEstado   VARCHAR2(400) := 'ESTADO_PLAN_CONTRATO';
         Lv_ValorProducCaractNa     VARCHAR2(400);
        Lv_ValorProducCaractInt    VARCHAR2(400);

        
        Ln_idCaracteristicaNa       INTEGER;
        Ln_IteradorI                NUMBER;
        Ln_IteradorJ                INTEGER; 
        Ln_valorMinimo              INTEGER;
        Ln_valorMaximo              INTEGER; 

      CURSOR C_GET_CARACTERISTICA(Cv_DescripcionCaract VARCHAR2)
        IS
            SELECT ACA.ID_CARACTERISTICA
            FROM DB_COMERCIAL.ADMI_CARACTERISTICA ACA
            WHERE  ACA.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract ; 

    
       CURSOR C_GET_DET_PLAN(Cn_IdPlan VARCHAR2,Cv_NombreParametro VARCHAR2)
        IS
            SELECT IPD.PRODUCTO_ID,IPD.ID_ITEM,IPD.PRECIO_ITEM
            FROM DB_COMERCIAL.INFO_PLAN_DET IPD
            inner join DB_COMERCIAL.ADMI_PRODUCTO ap on ap.ID_PRODUCTO=IPD.PRODUCTO_ID and ap.DESCRIPCION_PRODUCTO='INTERNET DEDICADO'
            WHERE
            IPD.PLAN_ID = Cn_IdPlan 
            AND IPD.ESTADO IN (
                SELECT APD.VALOR1
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                  WHERE APD.PARAMETRO_ID =
                    (SELECT APC.ID_PARAMETRO
                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                    WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                    ) AND APD.ESTADO = 'Activo'
            ); 
     CURSOR C_GET_PLANES              
        IS
        SELECT DISTINCT APA.ID_PLAN  FROM DB_COMERCIAL.INFO_PLAN_CAB APA 
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.PLAN_ID = APA.ID_PLAN 
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISE.PRODUCTO_ID and APRO.DESCRIPCION_PRODUCTO='INTERNET DEDICADO' and APRO.EMPRESA_COD=18
            WHERE  APA.ID_PLAN   NOT IN  (  SELECT DISTINCT PA.ID_PLAN FROM DB_COMERCIAL.INFO_PLAN_CAB PA 
                                              inner join DB_COMERCIAL.INFO_PLAN_CARACTERISTICA APC ON APC.PLAN_ID=PA.ID_PLAN
                                              AND  APC.CARACTERISTICA_ID IN
                                              ( SELECT  REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
                                                    FROM(
                                                           SELECT 
                                                              PDET.VALOR1
                                                           FROM DB_GENERAL.admi_parametro_Det PDET
                                                               where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                                                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                                                                     WHERE PCA.NOMBRE_PARAMETRO = 'VARIABLES_VELOCIDAD_PLANES' AND PCA.ESTADO='Activo') 
                                                              AND PDET.ESTADO='Activo'
                                                           ) T1 CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL )) AND APA.empresa_cod=18;    
                            
       CURSOR C_GET_PRODUCTO_CARACT(Cn_IdProducto INTEGER,Cn_IdCaracteristica INTEGER,Cn_IdPlanDet INTEGER)
        IS
            SELECT IPPC.VALOR
            FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
            INNER JOIN DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT IPPC ON IPPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA 
            WHERE
            APC.PRODUCTO_ID = Cn_IdProducto 
            AND APC.CARACTERISTICA_ID = Cn_IdCaracteristica
            AND IPPC.PLAN_DET_ID = Cn_IdPlanDet;

      
        TYPE Pcl_planDet IS TABLE OF C_GET_DET_PLAN%ROWTYPE;
        Pcl_arrayPlanDet Pcl_planDet;
        
        TYPE Pcl_servicio IS TABLE OF C_GET_PLANES%ROWTYPE;
        Pcl_arrayServicio Pcl_servicio;

   BEGIN
        
        OPEN C_GET_PLANES;    
            FETCH C_GET_PLANES BULK COLLECT INTO Pcl_arrayServicio LIMIT 5000;
            CLOSE C_GET_PLANES;

        OPEN C_GET_CARACTERISTICA(Lv_DescripCaracteristicaNa);
            FETCH C_GET_CARACTERISTICA INTO Ln_idCaracteristicaNa;
            CLOSE C_GET_CARACTERISTICA;
        IF Ln_idCaracteristicaNa IS NOT NULL
        THEN
               dbms_output.put_line('Caracteristica encotrada'); 
              IF Pcl_arrayServicio IS NOT NULL AND Pcl_arrayServicio.EXISTS(1)
                THEN
                   Ln_IteradorI := Pcl_arrayServicio.FIRST;
                     
      
                  WHILE (Ln_IteradorI IS NOT NULL) 
                    LOOP
                        OPEN C_GET_DET_PLAN(Pcl_arrayServicio(Ln_IteradorI).ID_PLAN,Lv_NombreParametroEstado);
                      FETCH C_GET_DET_PLAN BULK COLLECT INTO Pcl_arrayPlanDet LIMIT 5000;
                      CLOSE C_GET_DET_PLAN;
                  
                    IF  Pcl_arrayPlanDet.EXISTS(1) THEN
                           Ln_IteradorJ := Pcl_arrayPlanDet.FIRST;
                        WHILE (Ln_IteradorJ IS NOT NULL) 
                            LOOP
                                OPEN C_GET_PRODUCTO_CARACT (Pcl_arrayPlanDet(Ln_IteradorJ).PRODUCTO_ID,Ln_idCaracteristicaNa,Pcl_arrayPlanDet(Ln_IteradorJ).ID_ITEM);                                      FETCH C_GET_PRODUCTO_CARACT INTO Lv_ValorProducCaractNa;
                                            CLOSE C_GET_PRODUCTO_CARACT;
                                              
                                  IF Lv_ValorProducCaractNa IS NOT NULL
                                  THEN
                                      Ln_valorMaximo       := ROUND(Lv_ValorProducCaractNa/1000,1);
                                      Ln_valorMinimo       := ROUND((ROUND(Lv_ValorProducCaractNa/1000,1))/2,1);
      
                                  END IF;
                               IF Ln_valorMaximo IS NOT NULL
                                  THEN
                                    dbms_output.put_line('Valores encontrados');
                                     insert into DB_COMERCIAL.INFO_PLAN_CARACTERISTICA
                                       (ID_PLAN_CARACTERISITCA,
                                        PLAN_ID,
                                        CARACTERISTICA_ID,
                                        VALOR,
                                        ESTADO,
                                        FE_CREACION,
                                        USR_CREACION,
                                        IP_CREACION) 
                                        VALUES
                                       (DB_COMERCIAL.SEQ_INFO_PLAN_CARACTERISTICA.nextval,
                                          Pcl_arrayServicio(Ln_IteradorI).ID_PLAN,
                                          (SELECT det.VALOR1 FROM DB_GENERAL.admi_parametro_det det
                                                      WHERE det.PARAMETRO_ID=(select cab.id_parametro 
                                                                                from DB_GENERAL.admi_parametro_cab cab 
                                                                                where cab.nombre_parametro = 'VARIABLES_VELOCIDAD_PLANES')
                                                      and det.DESCRIPCION='VELOCIDAD_MINIMA'),
                                          Ln_valorMinimo,
                                          'Activo',
                                          SYSDATE,
                                          'Telcos',
                                          NULL);
                                END IF;
                                 IF Ln_valorMinimo IS NOT NULL
                                 THEN
                                  insert into DB_COMERCIAL.INFO_PLAN_CARACTERISTICA
                                     (ID_PLAN_CARACTERISITCA,
                                      PLAN_ID,
                                      CARACTERISTICA_ID,
                                      VALOR,
                                      ESTADO,
                                      FE_CREACION,
                                      USR_CREACION,
                                      IP_CREACION) 
                                      VALUES
                                     (DB_COMERCIAL.SEQ_INFO_PLAN_CARACTERISTICA.nextval,
                                        Pcl_arrayServicio(Ln_IteradorI).ID_PLAN,
                                        (SELECT det.VALOR1 FROM DB_GENERAL.admi_parametro_det det
                                                    WHERE det.PARAMETRO_ID=(select cab.id_parametro 
                                                                              from DB_GENERAL.admi_parametro_cab cab 
                                                                              where cab.nombre_parametro = 'VARIABLES_VELOCIDAD_PLANES')
                                                    and det.DESCRIPCION='VELOCIDAD_MAXIMA'),
                                        Ln_valorMaximo,
                                        'Activo',
                                        SYSDATE,
                                        'Telcos',
                                        NULL); 
                               END IF;
                              Ln_IteradorJ := Pcl_arrayPlanDet.NEXT(Ln_IteradorJ);
                           END LOOP;
                         END IF;
                          Ln_IteradorI := Pcl_arrayServicio.NEXT(Ln_IteradorI);
                    END LOOP;
              END IF;
        END IF;       
END;

