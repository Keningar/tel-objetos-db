DELETE FROM  DB_COMERCIAL.INFO_PLAN_CARACTERISTICA IFCR
where IFCR.ID_PLAN_CARACTERISITCA IN ( SELECT DISTINCT APC.ID_PLAN_CARACTERISITCA FROM DB_COMERCIAL.INFO_PLAN_CARACTERISTICA APC WHERE 
                                                APC.CARACTERISTICA_ID IN
                                             ( SELECT  REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
                                                    FROM(
                                                           SELECT 
                                                              PDET.VALOR1
                                                           FROM DB_GENERAL.admi_parametro_Det PDET
                                                               where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                                                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                                                                     WHERE PCA.NOMBRE_PARAMETRO = 'VARIABLES_VELOCIDAD_PLANES' AND PCA.ESTADO='Activo') 
                                                              AND PDET.ESTADO='Activo'
                                                           ) T1 CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL)
                                                           AND APC.ESTADO='Activo'); 
 